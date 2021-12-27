SHELL = /bin/bash

CC = gcc
CFLAGS = -g
OBJDIR = obj
SRCDIR = src
debugger_objs = $(addprefix $(OBJDIR)/, debugger.o ptrace.o)
executable = $(addprefix $(SRCDIR)/, debugger)

all:
	