; Program to open and write to file
; Compile with:
;     nasm -f elf64 -o writeToFile64.o writeToFile64.asm
; Link with:
;     ld -m elf_x86_64 -o writeToFile64 writeToFile64.o
; Run with:
;     ./writeToFile64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  fileName:  db "testFile.txt",0
  fileFlags: dq 0102o         ; create file + read and write mode
  fileMode:  dq 00600o        ; user has read write permission
  fileDescriptor: dq 0
section .rodata    ; read only data section
  msg1: db "Write this message to the test File.",0ah,0
  msglen equ $ - msg1
  msg2: db "File Descriptor=",0

section .text
_start:
    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename
    mov rsi,[fileFlags]       ;   int flags
    mov rdx,[fileMode]        ;   int mode
    syscall
    mov [fileDescriptor],rax
    mov rsi,msg2
    call print
    mov rax,[fileDescriptor]
    call printnumber
    call printnewline
    ; write a message to the created file
    mov rax,1                 ; sys_write
    mov rdi,[fileDescriptor]
    mov rsi,msg1
    mov rdx,msglen
    syscall
    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall

    call exit
