; Program to show random numbers
; Compile with:
;     nasm -f elf64 -o mul64.o mul64.asm
; Link with:
;     ld -m elf_x86_64 -o mul64 mul64.o
; Run with:
;     ./mul64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include '../Basics/basicFunctions.asm'

section .data
  fileName:  db "/dev/urandom",0
  fileFlags: dq 002o         ; open file and read and write mode
  fileDescriptor: dq 0
  val: dq 81.0  ;declare quad word (double precision)
  binBuff: times 65 db 0
  

section .bss
   fileBuffer:  resq 80000
   res: resq 1     ;reserve 1 quad word for result

section .rodata    ; read only data section
  msg1: db "-",0
  cero: db "0",0
  uno: db "1",0

section .text

; binary print RAX number to print
binprint:
    push rbx
    push rsi
    push rcx
    push rdx
    mov rcx,64
nextbit:
    mov rbx,rax
    and rbx,1
    mov dl,'1'
    cmp rbx,1
    jz printbit
    mov dl,'0'
printbit:
    mov byte[binBuff+rcx],dl
    dec rcx
    shr rax,1
    cmp rax,0
    jnz nextbit
    mov rsi,binBuff
    add rsi,rcx
    inc rsi
    call print
    pop rdx
    pop rcx
    pop rsi
    pop rbx
    ret
  

_start:



    fld qword [val] ;load value into st0
    fsqrt           ;compute square root of st0 and store in st0
    fstp qword [res] ;store st0 in [res], and pop it off the x87 stack (leaving the x87 register stack empty again)
    mov rax,qword[res]
    call binprint
    call printnewline
    call exit

    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename  /dev/urandom
    mov rsi,[fileFlags]       ;   int flags
    syscall
    mov [fileDescriptor],rax
    ; reading 100 randon bytes
    mov rax,0                 ; sys_read
    mov rdi,[fileDescriptor]
    mov rsi,fileBuffer
    mov rdx,80000                ; bytes to read
    syscall

    
    ; print the random bytes read
    mov rbx,0
    xor rax,rax
loopx1:
    mov rax,[fileBuffer+rbx*8]
    call printnumber
    mov rsi,msg1
    call print
    inc rbx
    cmp rbx,20
    jnz loopx1

    call printnewline

    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall

    call exit
