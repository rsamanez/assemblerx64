; How to scanf a string Program
; Compile with:
;     nasm -f elf64 -o scanfstring64.o scanfstring64.asm
; Link with:
;     ld -m elf_x86_64 -o scanfstring64 scanfstring64.o
; Run with:
;     ./scanfstring64
;==============================================================================
; Author : Rommel Samanez
; In this sample we will start using some functions
;==============================================================================

global _start

section .data
  newline: db 0ah,0

section .bss
  buffer:  resb 100   ; max message length 100 characters
  extra:  resb 10

section .rodata    ; read only data section
  msg: db "Write a string and then press [ENTER]:",0
  msg2: db "Your message is:",0

; strlen usage
;  mov rsi,message
;  call strlen
;  RETURN rdx : string length
;------------------------------------------------------------------------------
strlen:
  	mov rdx,0
      .stradd:
  	cmp byte[rsi+rdx],0
  	jz .strend
  	inc rdx
  	jmp .stradd
      .strend:
  	ret
;------------------------------------------------------------------------------
;  print usage
;	mov rsi,message  - message end  in 0
;	call print
;------------------------------------------------------------------------------
print:
	push rax
	push rdi
	push rdx
	call strlen
	mov rax,1
	mov rdi,1
	syscall
	pop rdx
	pop rdi
	pop rax
	ret
;------------------------------------------------------------------------------
;   println usage
;	mov rsi,message - message end in 0
;	call println
;------------------------------------------------------------------------------
println:
	call print
	push rsi
	mov rsi,newline
	call print
	pop rsi
	ret
;------------------------------------------------------------------------------
; exit the Program
; call exit
;------------------------------------------------------------------------------
exit:
	mov rax,60
	mov rdi,0
	syscall
;------------------------------------------------------------------------------
;  scanf usage
;  call scanf
; RETURN the readed string in the buffer memory variable
scanf:
	push rax
	push rdi
	push rdx
	mov rax,0
	mov rdi,1
	mov rsi,buffer
	mov rdx,100      ;  max 100 characters string
	syscall
	pop rdx
	pop rdi
	pop rax
	ret
;---------------------------------------------------

_start:       ; here the program starts

  mov rsi,msg
  call print
  call scanf
  mov rsi,msg2
  call println
  mov rsi,buffer
  call print
  call exit
