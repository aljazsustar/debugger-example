#! /bin/bash

function run() {
    ./debugger ./palindrome banana
}

function compile() {
    gcc -g -c src/ptrace/ptrace.c src/debugger.c
    gcc -g -o debugger ptrace.o debugger.o
}

if [ $1 == "run" ]
then
    run
elif [ $1 == "compile" ]
then
    compile
fi