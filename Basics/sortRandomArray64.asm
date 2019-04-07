; Program to sort a random array using QuickSort Algorithm
; Compile with:
;     nasm -f elf64 -o sortRandomArray64.o sortRandomArray64.asm
; Link with:
;     ld -m elf_x86_64 -o sortRandomArray64 sortRandomArray64.o
; Run with:
;     ./sortRandomArray64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start

%include 'basicFunctions.asm'

section .data
  fileName:  db "/dev/urandom",0
  fileFlags: dq 002o         ; open file and read and write mode
  fileDescriptor: dq 0
  elements:  dq 1000000       ; Array with 1'000,000 elements

section .bss
   array:  resq 8000000
   randBuff: resq 4000000
section .rodata    ; read only data section
  msg2: db "Sorted Array:",0
  coma: db '-',0

section .text


; partition(l,h)
; {
;   pivot= A[l]
;   i=l
;   j=h
;   while(i<j)
;   {
;       do
;       {
;         i++
;       }while(A[i]<=pivot)
;       do
;       {
;         j--
;       }while(A[j]>pivot)
;       if(i<j)
;           swap(A[i],A[j])
;   }
;   swap(A[l],A[j])
;   return j
; }
;
; partition(rax,rbx) return rcx
partition:
    mov r8,[array+rax*8]  ; pivot = A[l]
    mov r9,rax            ; i=r9
    mov r10,rbx           ; j=r10
loopx5:                   ; while(i<j)
    cmp r9,r10
    jge endwhile
loopx6:                   ; do
    inc r9                ; i++
    cmp [array+r9*8],r8   ; while(A[i]<=pivot)
    jle loopx6
loopx7:                   ; do
    dec r10               ; j--
    cmp [array+r10*8],r8  ; while(A[j]>pivot)
    jg loopx7
    cmp r9,r10            ; if(i<j)
    jge loopx5
    mov r11,[array+r9*8]      ; swap(A[i],A[j])
    mov r12,[array+r10*8]
    mov [array+r9*8],r12
    mov [array+r10*8],r11
    jmp loopx5
endwhile:
    mov r11,[array+rax*8]      ; swap(A[l],A[j])
    mov r12,[array+r10*8]
    mov [array+rax*8],r12
    mov [array+r10*8],r11
    mov rcx,r10               ; return j
    ret


; quicksort(l,h)
; {
;     if(l<h)
;     {
;          j= partition(l,h)
;          quicksort(l,j)
;          quicksort(j+1,h)
;     }
; }

; quicksort(rax,rbx)
quicksort:
    cmp rax,rbx     ; rax=l  rbx=h
    jge goEnd
    call partition  ; partition(rax,rbx) return rcx
    push rax
    push rbx
    push rcx
    mov rbx,rcx
    call quicksort  ; quicksort(l,j)
    pop rcx
    pop rbx
    pop rax
    inc rcx         ;  j++
    push rax
    push rbx
    push rcx
    mov rax,rcx
    call quicksort  ; quicksort(j+1,h)
    pop rcx
    pop rbx
    pop rax
goEnd:
    ret

_start:

    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename  /dev/urandom
    mov rsi,[fileFlags]       ;   int flags
    syscall
    mov [fileDescriptor],rax
    ; reading 400000 randon bytes
    mov rax,0                 ; sys_read
    mov rdi,[fileDescriptor]
    mov rsi,randBuff
    mov rdx,4000000                ; bytes to read
    syscall

    ;moving random numbers to array
    mov rax,0
    mov rbx,0
readBuffx1:
    mov eax,dword[randBuff+rbx*4]
    shr eax,8
    mov [array+rbx*8],rax
    inc rbx
    cmp rbx,1000000
    jnz readBuffx1

    xor rax,rax
    mov rbx,[elements]
    call quicksort

  ; Printing sorted Array
  mov rsi,msg2
  call println            ; declared in basicFunctions
  mov rbx,0
loopx3:
  mov rax,[array+rbx*8]
  inc rbx
  call printnumber        ; declared in basicFunctions
  cmp rbx,[elements]
  je loopx4
  mov rsi,coma
  call print              ; declared in basicFunctions
  jmp loopx3
loopx4:
  call printnewline       ; declared in basicFunctions
  call exit               ; declared in basicFunctions
