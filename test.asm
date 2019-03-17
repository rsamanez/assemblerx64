extern scanf
extern printf
extern exit
global main

section .text
Start:
	sub rsp, 0x28
	
	mov rcx, info
	call printf
	
	mov rcx, formatin
	mov rdx, float1
	call scanf
	
	mov rcx, formatout
	mov eax, [float1]
  	movd xmm2, eax
	unpcklps xmm2, xmm2
	cvtps2pd xmm0, xmm2
	movq rax, xmm0
	mov rdx, rax
	call printf
	
	xor rcx, rcx
	call exit
	add rsp, 0x28
	ret
	
section .data
	info db "Please enter a floating point value: ", 0
	formatin db "%f", 0
	formatout db "You entered %f.", 10, 0
	float1 dq 0.0
	


