#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct StackElement {
    char value;
    struct StackElement* next;
} StackElement;

typedef struct Stack {
    StackElement* top;
} Stack;

StackElement* pop(Stack* stack) {
    if (stack->top != NULL) {
        StackElement* res = stack->top;
        stack->top = stack->top->next;
        return res;
    }

    return NULL;
}

StackElement* push(Stack* stack, char value) {
    StackElement* element = (StackElement*)malloc(sizeof(StackElement));
    element->value = value;
    element->next = stack->top;
    stack->top = element;
    return element;
}

bool isPalindromeRek(char* str, int i) {

    if (str[i] != str[strlen(str) - i - 1]) return false;
    else if (i == strlen(str) / 2 || i == strlen(str) / 2 + 1) return true;

    return isPalindromeRek(str, ++i);
}

bool isPalindromeIter(char* str) {
    
    Stack* stack = (Stack*)malloc(sizeof(Stack));
    stack->top = NULL;

    int middle = strlen(str) / 2;


    for (int i = 0; i < middle; i++) {
        StackElement* element = push(stack, str[i]);
    }

    if (! (strlen(str) % 2)) middle--;

    for (int i = middle; i < strlen(str) - 1; i++) {
        StackElement* element = pop(stack);
        if (!element->value == str[middle] || element == NULL) return false;
    }

    return true;
}

int main(int argc, char** argv) {

    for (int i = 1; i < argc; i++) {
        bool resRek = isPalindromeRek(argv[i], 0);
        bool resIter = isPalindromeIter(argv[i]);

        if (resRek) printf("%s is palindrome\n", argv[i]);
        else printf("%s is not a palindrome\n", argv[i]);
    }

    return 0;
}