; Program to open and read from text file 
; Compile with:
;     nasm -f elf64 -o readAllfromFile64.o readAllfromFile64.asm
; Link with:
;     ld -m elf_x86_64 -o readAllfromFile64 readAllfromFile64.o
; Run with:
;     ./readAllfromFile64
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
  msg1: db ".",0
  
section .text

_start:
    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename
    mov rsi,[fileFlags]       ;   int flags
    syscall
    mov [fileDescriptor],rax  
    ; reading from file
.readAgain:
    mov rax,0                 ; sys_read
    mov rdi,[fileDescriptor]
    mov rsi,fileBuffer
    mov rdx,800              ; bytes to read
    syscall
    cmp rax,0               ; check EOF
    jz .gotoEnd
    ; print fileBuffer
    mov rsi,fileBuffer
    mov rdx,rax
    mov rax,1
  	mov rdi,1
  	syscall
    jmp .readAgain
.gotoEnd:
    
    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall
    call exit
