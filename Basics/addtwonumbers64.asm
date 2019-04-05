; Program to add two 8 bytes numbers
; Compile with:
;     nasm -f elf64 -o addtwonumbers64.o addtwonumbers64.asm
; Link with:
;     ld -m elf_x86_64 -o addtwonumbers64 addtwonumbers64.o
; Run with:
;     ./addtwonumbers64
;==============================================================================
; Author : Rommel Samanez
; In this sample we will start using INCLUDE files
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  a:  dq 0
  b:  dq 0

section .rodata    ; read only data section
  msg1: db "Write first number and then press [ENTER]:",0
  msg2: db "Write second number and then press [ENTER]:",0
  plus: db "+",0
  equal: db "=",0


section .text
_start:
  ; Reading the first number
  mov rsi,msg1
  call print
  call scanf
  call bufftonumber
  mov [a],rax
  ; Reading the second number
  mov rsi,msg2
  call print
  call scanf
  call bufftonumber
  mov [b],rax
  ;---------------
  add rax,[a]         ; RAX = [b] + [a]
  mov rbx,rax         ;  RBX = save the result
  ;----------------
  ; Print the results
  mov rax,[a]
  call printnumber
  mov rsi,plus
  call print
  mov rax,[b]
  call printnumber
  mov rsi,equal
  call print
  mov rax,rbx
  call printnumber
  call printnewline
  call exit
