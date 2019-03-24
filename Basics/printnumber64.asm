; How to print a 8bytes number Program
; Compile with:
;     nasm -f elf64 -o printnumber64.o printnumber64.asm
; Link with:
;     ld -m elf_x86_64 -o printnumber64 printnumber64.o
; Run with:
;     ./printnumber64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

section .data
  a:   dq 645657754416        ; Number to Print, it is defined in 8bytes length

section .bss
 buffer:  resq 100            ; Memory Buffer to convert the number to string

section .text

_start:

; Transforming Number BASE-10 to string
    mov rax,[a]
    mov rcx,0ah
    mov rbx,20                ;length to print filled with spaces in the left
    mov byte[buffer+rbx+1],0ah ; to println at the end
    mov byte[buffer+rbx+2],0   ; End of string
.pnfl01:
    dec rbx
    xor rdx,rdx     ; mov rdx,0   best way to set a register to 0
    div rcx         ; RDX:RAX / RCX  -->  Q=RAX  R=RDX
    add rdx,48
    cmp rax,0
    jnz .pnfl02
    cmp rdx,48
    jnz .pnfl02
    mov rdx,32
.pnfl02:
    mov byte[buffer+rbx],dl
    cmp rbx,0
    jnz .pnfl01
;----END Transforming Process
    
    mov rax, 1          ; syscall to print string
    mov rdi, 1
    mov rsi,buffer
    mov rdx,22          ; number length + 0ah + 0
    syscall

    mov rax, 60       ; syscall to exit
    mov rdi, 0
    syscall
