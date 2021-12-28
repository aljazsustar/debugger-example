#include "ptrace.h"


void print_registers(Tracee* process) {

    struct user_regs_struct* regs = process->registers;
    printf("---------REGISTERS--------\n");
    printf("AX: 0x%llX \t", regs->rax);
    printf("Original RAX: 0x%llx\t", regs->orig_rax);
    printf("CX: 0x%llX \t", regs->rcx);
    printf("SP: 0x%llX \n", regs->rsp);
    printf("EFLAGS: 0x%llX \n", regs->eflags);
    printf("EIP: 0x%llX \n", regs->rip);
    printf("%llu\n", regs->eflags & 128);
    printf("-------------------------\n");
}

void print_syscall_args(long long unsigned int* args) {
    for (int i = 0; i < 5; i++) {
        printf("Argument %d: %lld\t", i, args[i]);
    }
    printf("\n");
}

void print_syscall_data(struct ptrace_syscall_info* info) {
    printf("--------SYSCALL DATA------\n");
    if (info->op == PTRACE_SYSCALL_INFO_ENTRY) {
        printf("Number: %lld\n", info->entry.nr);
        print_syscall_args(info->entry.args);
    } else if (info->op == PTRACE_SYSCALL_INFO_EXIT) {
        printf("Return value: %lld\n", info->exit.rval);
        printf("Error: %d\n", info->exit.is_error);
    }
}

void ptrace_traceme() {

    int res = ptrace(PTRACE_TRACEME);
    if (res) {
        perror("ptrace (PTRACE_TRACEME): ");
        exit(1);
    }
}

void ptrace_set_options(Tracee* tracee, unsigned int options) {

    int res = ptrace(PTRACE_SETOPTIONS, tracee->pid, NULL, options);
    if (res) {
        perror("ptrace (PTRACE_SETOPTIONS): ");
        exit(1);
    }
}

void ptrace_detach(Tracee* process) {

    int res = ptrace(PTRACE_DETACH, process->pid, NULL, 0);
    if (res) {
        perror("ptrace (PTRACE_DETACH): ");
        exit(1);
    }
}

void get_registers(Tracee* process, int* status){

    process->registers = (struct user_regs_struct*)malloc(sizeof(struct user_regs_struct));
    int res = ptrace(PTRACE_GETREGS, process->pid, NULL, process->registers);
    if (res) {
        perror("ptrace (PTRACE_GETREGS): ");
        exit(1);
    }
    print_registers(process);
}
void ptrace_singlestep(Tracee* process) {
    int res = ptrace(PTRACE_SINGLESTEP, process->pid, NULL, 0);
    if (res) {
        perror("ptrace (PTRACE_SINGLESTEP): ");
        exit(1);
    }
}

void ptrace_syscall(Tracee* process, int* status) {
    int res = ptrace(PTRACE_SYSCALL, process->pid, NULL, 0);
    if (res) {
        perror("ptrace (PTRACE_SYSCALL): ");
        exit(1);
    }
    waitpid(process->pid, status, 0);
}

void ptrace_continue(Tracee* process, int* status){
    int res = ptrace(PTRACE_CONT, process->pid, NULL, 0);
    if (res) {
        perror("ptrace (PTRACE_CONT): ");
        exit(1);
    }  
    waitpid(process->pid, status, 0);
}

void ptrace_kill(Tracee* process, int* status) {
    int res = ptrace(PTRACE_KILL, process->pid, NULL, 0);
    if (res) {
        perror("ptrace (PTRACE_KILL)");
        exit(1);
    }
    waitpid(process->pid, status, 0);
}

void ptrace_syscall_info(Tracee* process, int* status) {
    //struct ptrace_syscall_info* info = (struct ptrace_syscall_info*)malloc(sizeof(struct ptrace_syscall_info));
    struct ptrace_syscall_info info;
    int res = ptrace(PTRACE_GET_SYSCALL_INFO, process->pid, 0, &info);
    if (res) {
        perror("ptrace (PTRACE_GET_SYSCALL_INFO)");
        exit(1);
    }   
    print_syscall_data(&info);
    waitpid(process->pid, status, 0);
}

