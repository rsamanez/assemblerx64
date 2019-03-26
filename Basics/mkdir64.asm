; How to use syscall function to create a new Folder
; Compile with:
;     nasm -f elf64 -o mkdir64.o mkdir64.asm
; Link with:
;     ld -m elf_x86_64 -o mkdir64 mkdir64.o
; Run with:
;     ./mkdir64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

section .data
foldername         db      'new_folder', 0h     ; folder name

section .text
global  _start

_start:

    mov rax,83                  ; sys_mkdir
    mov rdi,foldername             ; address of the dir name to create
    mov rsi,770h                ; (mode & ~umask & 0777).
    syscall
    mov rax,60                  ; sys_exit
  	mov rdi,0                   ; error code
  	syscall
