; How to use syscall function to run OS command
; Compile with:
;     nasm -f elf64 -o runCommand64.o runCommand64.asm
; Link with:
;     ld -m elf_x86_64 -o runCommand64 runCommand64.o
; Run with:
;     ./runCommand64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

section .data
command         db      '/bin//sh', 0h     ; command to execute
arg1            db      'ls -l', 0h
arguments       dd      command
                dd      arg1                ; arguments to pass to commandline (in this case just one)
                dd      0h                  ; end the struct
environment     dd      0h                  ; arguments to pass as environment variables (inthis case none) end the struct

section .text
global  _start

_start:
                mul rsi
                push rax
                mov rdi, "/bin//sh"
                push rdi
                mov rdi, rsp
                mov al, 59
                syscall



  ; Is not working yet
    mov rax,59                  ; sys_execve
    mov rdi,command             ; address of the file to execute
    mov rsi,arguments           ; address of the arguments to pass to the commandline
    mov rdx,environment         ; address of environment variables
    syscall
    mov rax,60                  ; sys_exit
  	mov rdi,0                   ; error code
  	syscall
