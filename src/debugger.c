#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <errno.h>
#include <unistd.h>
#include <stdbool.h>

#include "ptrace/ptrace.h"

int status;

const unsigned int PT_OPTIONS = PTRACE_O_TRACEFORK | PTRACE_O_TRACEEXEC | PTRACE_O_TRACEEXIT | PTRACE_O_TRACESYSGOOD;

void resolve_request(char* input, Tracee* process) {
    if (!strcmp(input, "s")) ptrace_singlestep(process);
    else if (!strcmp(input, "c")) ptrace_continue(process, &status);
    else if (!strcmp(input, "sys")) ptrace_syscall(process, &status);
    else if (!strcmp(input, "k")) ptrace_kill(process, &status);
    else if (!strcmp(input, "lr")) get_registers(process, &status);
}

void loop(Tracee* process) {
        char buff[500];
        
        // wait for child process
        waitpid(-1, &status, WCONTINUED);
        ptrace(PTRACE_SETOPTIONS, process->pid, NULL, PT_OPTIONS);

        while(1) {
            
            //prompt user and read user input
            printf("debug> ");
            
            fflush(stdout);
            char input[20];  
            scanf("%s", input);
            fflush(stdin);
            resolve_request(input, process);
            
            if (WIFEXITED(status)) {
                int exit_status = WEXITSTATUS(status);
                printf("Exited with status %d\n", exit_status);
                exit(exit_status);
            } else if (WIFSIGNALED(status)) {
                int signal = WTERMSIG(status);
                printf("Terminated\n");
                fflush(stdout);
                break;
            } else if (WIFSTOPPED(status)) {
                int signal = WSTOPSIG(status);
                if (signal == (SIGTRAP | 0x80)) {
                    printf("Inside syscall\n");
                    //ptrace_syscall_info(process, &status);
                    fflush(stdout);
                } else {
                    printf("Received signal number %d\n", signal);
                    fflush(stdout);
                }
                continue;
            } 
            status = 0;
            wait(NULL);
        }
}

int main(int argc, char** argv) {


    char** args = malloc((argc - 2) * sizeof(char*));
    char* command = argv[1];

    for (int i = 0; i < argc; i++) {
        args[i] = argv[i + 1];
    }

    int pid = fork();

    if (!pid) {
        //initialize tracing
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        raise(SIGSTOP);

        execve(argv[1], args, NULL);
    } else {
        Tracee* process = (Tracee*)malloc(sizeof(Tracee));
        process->pid = pid;
        loop(process);
    }

    return 0;
}