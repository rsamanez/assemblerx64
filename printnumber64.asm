; function print 64 bits implementation
;--------------------------------------
global _start

section .data
 newline: db 0ah,0     ;    *
  a:   dq 645657754416,0

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
;---------------------------------------------------
numbertobuff:
	push rcx
	push rdx
        mov rax,[a]
        mov rcx,0ah
	mov byte[buffer+rbx+1],0
   .pnfl01:
	dec rbx
        mov rdx,0
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
	pop rdx
	pop rcx
	ret

;-------------------------------------
;   printnumberf usage
;       mov rax,number to print
;       mov rbx,length   length to print filled with spaces in the left
;       call printnumberf

printnumberf:
	push rsi
	call numbertobuff
	mov rsi,buffer
	call println
	pop rsi
	ret

;----------------------------
;    printnumber  usage
;	mov rax,number
; 	call printnumber
printnumber:
	push rbx
	push rsi
	mov rbx,21
	call numbertobuff
	mov rsi,buffer
   .pnfl03:
	cmp byte[rsi],32
	jnz .pnfl04
	inc rsi
	jmp .pnfl03
   .pnfl04:
	call println
	pop rsi
	pop rbx
	ret



_start:

	mov rsi,msg2
	call println
	mov rax,[a]
	mov rbx,50
	call printnumberf
	mov rax,[a]
	call printnumber


	call exit



section .rodata    ; read only data section
    msg1: db "Hello World!",0
    msg2: db "Printing Decimal Number:",0
    msg3: db "Write a Number and then press [ENTER]:",0
