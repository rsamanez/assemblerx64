; Program to show random numbers
; Compile with:
;     nasm -f elf64 -o readRandom64.o readRandom64.asm
; Link with:
;     ld -m elf_x86_64 -o readRandom64 readRandom64.o
; Run with:
;     ./readRandom64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  fileName:  db "/dev/urandom",0
  fileFlags: dq 002o         ; open file and read and write mode
  fileDescriptor: dq 0

section .bss
   fileBuffer:  resq 80000

section .rodata    ; read only data section
  msg1: db "-",0

section .text
_start:
    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename  /dev/urandom
    mov rsi,[fileFlags]       ;   int flags
    syscall
    mov [fileDescriptor],rax
    ; reading 100 randon bytes
    mov rax,0                 ; sys_read
    mov rdi,[fileDescriptor]
    mov rsi,fileBuffer
    mov rdx,80000                ; bytes to read
    syscall

    ; print the random bytes read
    mov rbx,0
    xor rax,rax
loopx1:
    mov rax,[fileBuffer+rbx*8]
    call printnumber
    mov rsi,msg1
    call print
    inc rbx
    cmp rbx,10000
    jnz loopx1

    call printnewline

    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall

    call exit
