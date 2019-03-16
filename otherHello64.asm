; compile with
; nasm -felf64 otherHello64.asm
; ld otherHello64.o -o otherHello64
;-------------------------------
[bits 64]

section .text
global _start
 _start:               ; ELF entry point
mov rax, 1             ; sys_write
mov rdi, 1             ; STDOUT
mov rsi, message       ; buffer
mov rdx, [messageLen]  ; length of buffer
syscall
mov rax, 60            ; sys_exit
mov rdi, 0             ; 0
syscall

section .data
messageLen: dq message.end-message
message: db 'Hello World', 10
 .end:

