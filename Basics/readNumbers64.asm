; How to read only numbers from keyboard and echo it to screen
; Compile with:
;     nasm -f elf64 -o readNumbers64.o readNumbers64.asm
; Link with:
;     ld -m elf_x86_64 -o readNumbers64 readNumbers64.o
; Run with:
;     ./readNumbers64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

global _start

%include 'readKeyFunction.asm'
%include 'basicFunctions.asm'

section .data
 chr1: db 0,0
 msg1: db "Reading only Numbers... push ENTER to finish",0ah,0
 msglen     equ $ - msg1
 msg2: db 0ah,"END.",0ah,0
 msg2len: equ $ - msg2

section .text

_start:
    mov rsi,msg1
    call println
    call readKeyInit
.readloop:
    call readKey
    cmp al,13
    jz .goEnd
    cmp al,48
    jl .readloop
    cmp al,57
    jg .readloop
    mov  byte[chr1],al
    mov rsi,chr1
    call print
    jmp .readloop
.goEnd:
    call readKeyReset
    mov rsi,msg2
    call println
    call exit