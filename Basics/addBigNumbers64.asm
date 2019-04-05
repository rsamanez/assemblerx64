; Exercise
;=================================================================================================
;Calculate and print the sum of the elements in an array, keeping in mind that some of those
; numbers may be very quite large.
;
;Function Description
;    Complete the aVeryBigSum function. It must return the sum of all array elements.
;
;    Input Format
;           -The first line of the input consists of an integer . that is the number of
;            elements of the array  1< n <= 10
;           - Next enter the numbers one by one pressing ENTER at the end of every one
;                        0 <=  ar[i] <= 10^50
;    Output Format
;           -Print the integer sum of the elements in the array.
;
;==================================================================================================
; Compile with:
;     nasm -f elf64 -o addBigNumbers64.o addBigNumbers64.asm
; Link with:
;     ld -m elf_x86_64 -o addBigNumbers64 addBigNumbers64.o
; Run with:
;     ./addBigNumbers64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

global _start

%include 'readKeyFunction.asm'
%include 'basicFunctions.asm'

section .data
 chr1: db 0,0
 msg1: db "Number of elements to sum:",0
 msg2: db "Sum = ",0
 msg3: db "Enter Number[",0
 msg4: db "]:",0
 msg5: db "The maximun number is 10",0
 numElements: dq 0,0,0,0,0,0,0,0,0,0,0,0
 numbers:  times 641 db '0'
 endnumbers: db 0
 result: times 64 db '0'
 xxend:   db 0,0,0

section .text

; element index RBX
moveBuffer:
    push rcx
    push rdx
    push rax
    mov rcx,0
.movex1:
    cmp byte[buffer+rcx],0ah
    jz .movex2
    inc rcx
    jmp .movex1
.movex2:
    mov rdx,rbx
    shl rdx,6  ; RDX*64
.movex4:
    mov al,byte[buffer+rcx-1]
    mov byte[numbers+rdx],al
    dec rdx
    dec rcx
    cmp rcx,0
    jz .movex3
    jmp .movex4
.movex3:
    pop rax
    pop rdx
    pop rcx
    ret

;  maxlength RDI
;  result buffer,0ah
readNumber:
    push rax
    push rdx
    mov rdx,0
.readNewKey:
    call readKey
    cmp al,13
    jz .readNumEnd
    cmp al,48
    jl .readNewKey
    cmp al,57
    jg .readNewKey
    mov byte[buffer+rdx],al
    ; ECHO readed number
    mov byte[chr1],al
    mov rsi,chr1
    call print
    inc rdx
    cmp rdx,rdi
    jz .readNumEnd
    jmp .readNewKey
.readNumEnd:
    cmp rdx,0
    jz .readNewKey              ; read again if the first key pressed is ENTER
    mov byte[buffer+rdx],0ah
    pop rdx
    pop rax
    ret

_start:
    mov rsi,msg1
    call print
    call scanf
    call bufftonumber
    cmp rax,11                  ; MAX number can be 10
    jl .numberok
    call printnewline
    mov rsi,msg5
    call println
    jmp _start
.numberok:
    mov [numElements],rax
    mov rbx,1

.readAgain:
    ; process to read the big numbers
    mov rsi,msg3
    call print
    mov rax,rbx
    call printnumber
    mov rsi,msg4
    call print
    call readKeyInit
    mov rdi,50                  ; MAX number digits 50
    call readNumber
    call readKeyReset
    call printnewline
    call moveBuffer
    cmp rbx,[numElements]
    jz .finish
    inc rbx
    jmp .readAgain
.finish:
    ;-------------------------------------------------------------------------------
    ; start to adding big numbers

    mov rax,0
    mov r8,64                  ; point to element last number
.nextDigitloop:
    mov rdi,r8
    mov rbx,[numElements]       ; number of elements to be added
.nextElement:
    xor rcx,rcx
    mov cl,byte[numbers+rdi]
    sub cl,48
    add rax,rcx
    dec rbx
    cmp rbx,0
    jz .nextDigit
    add rdi,64
    jmp .nextElement
 .nextDigit:
    push rbx
    push rdx
    mov rbx,10
    mov rdx,0
    div rbx
    add rdx,48
    mov byte[result+r8],dl
    pop rdx
    pop rdx
    dec r8
    cmp r8,0
    jz .processEnd
    jmp .nextDigitloop
    ;---------------------------------------------------------------------------------
.processEnd:
    ;---------------------------------------------------------------------------------
    ; printing the result
    mov rsi,msg2
    call print
    mov rdx,0
.loopx:
    cmp byte[result+rdx],'0'        ; moving the pointer to the first number <> 0
    jnz .readytoPrint
    inc rdx
    jmp .loopx
.readytoPrint:
    mov rsi,result
    add rsi,rdx
    call println
    call exit
