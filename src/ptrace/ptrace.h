#include <sys/ptrace.h>
#include <sys/user.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

typedef struct Tracee {
    pid_t pid;
    struct user_regs_struct* registers;
} Tracee;

void ptrace_traceme();
void ptrace_singlestep(Tracee* process);
void ptrace_syscall(Tracee* process, int* status);
void ptrace_continue(Tracee* process, int* status);
void ptrace_kill(Tracee* process, int* status);
void ptrace_set_options(Tracee* process, unsigned int options);
void get_registers(Tracee* process, int* status);
void ptrace_detach(Tracee* process);