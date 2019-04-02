; Exercise
;=================================================================================================
;Calculate factorial of 10000
;
;=================================================================================================
; Compile with:
;     nasm -f elf64 -o bigFactorialNumber64.o bigFactorialNumber64.asm
; Link with:
;     ld -m elf_x86_64 -o bigFactorialNumber64 bigFactorialNumber64.o
; Run with:
;     ./bigFactorialNumber64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

global _start

%include 'basicFunctions.asm'

  
section .data
; buff for 4 numbers of 40000 digits each one
 buff: times 40000 db '-'
 factors: times 120000 db 0
 result: times 40000 db '-'
 xxend:   db 0,0,0

section .text

getSize:
    mov rbx,0
.getSizex0:
    cmp byte[rsi+rbx],0
    jz .getSizex1
    inc rbx
    jmp .getSizex0
.getSizex1:
    ret

 _start:

;setting the first number 10! = 3628800
;   move to buffer in inverse order
    mov byte[buff],0
    mov byte[buff+1],0
    mov byte[buff+2],8
    mov byte[buff+3],8
    mov byte[buff+4],2
    mov byte[buff+5],6
    mov byte[buff+6],3
    mov r8,23       ; next factorial to be calculated


    mov r9,0        ; index in the actual number
    mov r10,40000   ; index of the next Factor
    mov r11,0       ; numElements to sum



    mov rax,r8      ; Unsigned divide RDX:RAX by RBX, with result stored in RAX ← Quotient, RDX ← Remainder.
    
    
 .nextSum:   
    mov rbx,10
    mov rdx,0
    div rbx
    push rax        ; RAX = Quotient
    push rdx
    pop rax         ; RAX = Remainder [AL]
    mov cl,0        ; carrier

.nextDigit:
    push rax
    mov bl,byte[buff+r9]
    mul bl                                ;Unsigned multiply (AX ← AL ∗ r/m8).      
    mov bl,10
    div bl          ;Unsigned divide AX by r/m8, with result stored in AL ← Quotient, AH ← Remainder.
    add ah,cl
    push rbx
    mov rbx,r10
    add rbx,r9
    mov byte[buff+rbx],ah
    pop rbx
    push rax         ; save the carrier al
    pop rcx          ; load the carrier cl
    inc r9
    pop rax
    cmp byte[buff+r9],'-'
    jnz .nextDigit
    push rcx
    pop rax
    push rax
    mov rax,r10
    add rax,r9
    mov byte[buff+rax],ah   ; move the carrier to buffer
    pop rax
    mov r9,0                    ; reset actual number index
    inc r11                     ; add numElements
    push r10
    pop rax
    add rax,r10
    inc rax
    mov r10,rax                 ; R10 = R10 + 40001
    pop rax                     ; Quotient to RAX
    cmp rax,0
    jnz .nextSum


    call exit


    ; SUM of all numElements
    mov rax,0
    mov r8,0                  ; point to element last number
.nextDigitloop:
    mov rdi,r8
    mov rbx,r11       ; number of elements to be added
.nextElement:
    xor rcx,rcx
    mov cl,byte[buff+rdi]
    add rax,rcx
    dec rbx
    cmp rbx,0
    jz .nextDigitx
    add rdi,40000
    jmp .nextElement
 .nextDigitx:   
    push rbx
    push rdx
    mov rbx,10
    mov rdx,0
    div rbx
    add rdx,48
    mov byte[result+r8],dl    
    pop rdx
    pop rdx
    inc r8
    cmp r8,20           ; cambiar por 40000
    jnz .nextDigitloop
    ;---------------------------------------------------------------------------------
    mov byte[result+r8],dl    
    pop rdx
    pop rdx
    inc r8
    cmp r8,20           ;   cambiar por 40000
    jnz .nextDigitloop
    ;---------------------------------------------------------------------------------
    mov rsi,result
    call println
    call exit

