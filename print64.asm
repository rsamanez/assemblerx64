; function print 64 bits implementation
;--------------------------------------
global _start

section .data
 newline: db 0ah,0

section .bss
 buffer:  resq 100

section .text

; strlen usage
;  mov rsi,message
;  call strlen
;  RETURN rdx : string length
;--------------------
strlen:
	mov rdx,0
    .stradd:
	cmp byte[rsi+rdx],0
	jz .strend
	inc rdx
	jmp .stradd
    .strend:
	ret

;  print usage
;	mov rsi,message  - message end  in 0
;	call print
;------------------------
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

;    println usage
;	mov rsi,message - message end in 0
;	call println
;---------------------------
println:
	call print
	push rsi
	mov rsi,newline
	call print
	pop rsi
	ret
exit:
	mov rax,60
	mov rdi,0
	syscall

scanf:
	push rax
	push rdi
	push rdx
	mov rax,0
	mov rdi,1
	mov rsi,buffer
	mov rdx,10      ;  max 10 digits number
	syscall
	pop rdx
	pop rdi
	pop rax
	ret

_start:
	mov rsi,msg3
	call print
	call scanf
	mov rsi,msg1
	call println
	mov rsi,msg2
	call println
	mov rsi,buffer
	call print
	call exit

section .rodata    ; read only data section
    msg1: db "Hello World!",0
    msg2: db "Jurassic Park.",0
    msg3: db "Write a Number and then press [ENTER]:",0
