; How to print a string Program
; Compile with:
;     nasm -f elf64 -o printstring64.o printstring64.asm
; Link with:
;     ld -m elf_x86_64 -o printstring64 printstring64.o
; Run with:
;     ./printstring64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

global _start

section .rodata     ;  ReadOnly Data Section
  message: db "This is my first message with Assembler64!...", 10
  messagelen: equ $ - message

section .text       ; Program Code Section

_start:
  mov rax, 1          ; syscall to print string
  mov rdi, 1
  mov rsi, message
  mov rdx, messagelen
  syscall

  mov rax, 60       ; syscall to exit
  mov rdi, 0
  syscall
