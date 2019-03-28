; Program to read file stat
; Compile with:
;     nasm -f elf64 -o sys_stat64.o sys_stat64.asm
; Link with:
;     ld -m elf_x86_64 -o sys_stat64 sys_stat64.o
; Run with:
;     ./sys_stat64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  fileName:  db "testFile.txt",0

section .bss
   stat resb 144
struc STAT
    .st_dev         resq 1
    .st_ino         resq 1
    .st_nlink       resq 1
    .st_mode        resd 1
    .st_uid         resd 1
    .st_gid         resd 1
    .pad0           resb 4
    .st_rdev        resq 1
    .st_size        resq 1
    .st_blksize     resq 1
    .st_blocks      resq 1
    .st_atime       resq 1
    .st_atime_nsec  resq 1
    .st_mtime       resq 1
    .st_mtime_nsec  resq 1
    .st_ctime       resq 1
    .st_ctime_nsec  resq 1
endstruc



section .rodata    ; read only data section
  msg1: db "File Size=",0
  msg2: db "File atime=",0
  msg3: db "File mtime=",0
  msg4: db "File ctime=",0
section .text
_start:
    mov rax,4               ;   sys_open
    mov rdi,fileName        ;   const char *filename
    mov rsi,stat            ;   struct stat *statbuf
    syscall
    mov rax, qword [stat + STAT.st_size]
    push rax
    mov rsi,msg1
    call print
    pop rax
    call printnumber
    call printnewline
    mov rsi,msg2
    call print
    mov rax, qword [stat + STAT.st_atime]
    call printnumber
    call printnewline
    mov rsi,msg3
    call print
    mov rax, qword [stat + STAT.st_mtime]
    call printnumber
    call printnewline
    mov rsi,msg4
    call print
    mov rax, qword [stat + STAT.st_ctime]
    call printnumber
    call printnewline
    call exit
