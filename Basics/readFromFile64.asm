; Program to open and read from a file
; Compile with:
;     nasm -f elf64 -o readFromFile64.o readFromFile64.asm
; Link with:
;     ld -m elf_x86_64 -o readFromFile64 readFromFile64.o
; Run with:
;     ./readFromFile64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  fileName:  db "testFile.txt",0
  fileFlags: dq 002o         ; open file and read and write mode
  fileDescriptor: dq 0

section .bss
   fileBuffer:  resq 100

section .rodata    ; read only data section
  msg1: db "Bytes readed=",0
  msg2: db "File Descriptor=",0

section .text
_start:
    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename
    mov rsi,[fileFlags]       ;   int flags
    syscall
    mov [fileDescriptor],rax
    mov rsi,msg2
    call print
    mov rax,[fileDescriptor]
    call printnumber
    call printnewline
    ; read a message to the created file
    mov rax,0                 ; sys_read
    mov rdi,[fileDescriptor]
    mov rsi,fileBuffer
    mov rdx,100                ; bytes to read
    syscall
    ; print the number of bytes Readed
    push rax
    mov rsi,msg1
    call print
    pop rax
    call printnumber
    call printnewline




    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall
    ; Print message Readed
    mov rsi,fileBuffer
    call println

    call exit
