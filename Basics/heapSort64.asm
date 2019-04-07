; Program to implement heap sort algorithm
; Compile with:
;     nasm -f elf64 -o heapSort64.o heapSort64.asm
; Link with:
;     ld -m elf_x86_64 -o heapSort64 heapSort64.o
; Run with:
;     ./heapSort64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
%ifdef	COMMENT

Heapsort pseudocode:

Heapsort(A) {
   BuildHeap(A)
   for i <- length(A) downto 1 {
      exchange A[1] <-> A[i]
      heapsize <- heapsize -1
      Heapify(A, 1)
}

BuildHeap(A) {
   heapsize <- length(A)
   for i <- floor( length/2 ) downto 1
      Heapify(A, i)
}

Heapify(A, i) {
   largest <- i 
   le <- left(i)
   ri <- right(i)
   if (le<=heapsize) and (A[le]>A[largest])
      largest <- le
   if (ri<=heapsize) and (A[ri]>A[largest])
      largest <- ri
   if (largest != i) {
      exchange A[i] <-> A[largest]
      Heapify(A, largest)
   }
}

%endif
;=======================================================================================
global _start

%include 'basicFunctions.asm' 


section .data
  array:  dq 23453,54544,3422,445,76435,87654,345,345,975,77686,34,887,3466,6654,1039,50433,1743,5543,8836,29975
  elements:  dq 20

section .rodata    ; read only data section
  msg1: db "Initial Array:",0
  msg2: db "Sorted Array:",0
  coma: db ",",0

section .text

;
;BuildHeap(A) {
;   heapsize <- length(A)
;   for i <- floor( length/2 ) downto 1
;      Heapify(A, i)
;}
buildheap:
   mov r8,[elements]       ; r8 <- heapsize = length(A)
   push rbx
   push rcx
   mov rbx,r8
   shr rbx,1               ;  i = floor(length/2)
forloop:
   mov rcx,rbx
   call heapify            ; heapify(rcx=i)
   dec rbx
   cmp rbx,0
   jnz forloop
   pop rcx
   pop rbx
   ret

;   
;Heapify(A, i) {
;   largest <- i
;   le <- left(i)
;   ri <- right(i)
;   if (le<=heapsize) and (A[le]>A[largest])
;      largest <- le
;   if (ri<=heapsize) and (A[ri]>A[largest])
;      largest <- ri
;   if (largest != i) {
;      exchange A[i] <-> A[largest]
;      Heapify(A, largest)
;   }
;}
; heapify(rcx=i)  r9=le r10=ri r11=largest
heapify:
   push r9
   push r10
   push r11
   mov r11,rcx             ; largest <- i
   mov r9,rcx
   shl r9,1                ; r9 <- rcx*2  le<-left(i)
   mov r10,r9
   inc r10                 ; r10 <- rcx*2+1 ri<-right(i)
   cmp r9,r8               ; le<=heapsize   if-x start
   jg ifendx
   mov r13,[array+r9*8-8]    ; r13 <- A[le]
   cmp r13,[array+r11*8-8]   ; A[le]>A[largest]
   jbe ifendx
   mov r11,r9              ;  largest <- le
ifendx:                    ; 
   cmp r10,r8              ;  ri<=heapsize   if-y start
   jg ifendy
   mov r13,[array+r10*8-8]   ; r13<- A[ri]
   cmp r13,[array+r11*8-8]   ; A[ri]>A[largest]
   jbe ifendy
   mov r11,r10             ; largest <- ri   if-y end
ifendy:
   cmp r11,rcx             ; largest!=i      if-z start
   je ifendz
   push rax
   push rbx
   mov rax,[array+rcx*8-8]   ; Exchange A[i]<>A[largest]
   mov rbx,[array+r11*8-8]
   mov [array+rcx*8-8],rbx
   mov [array+r11*8-8],rax
   pop rbx
   pop rax
   push rcx
   mov rcx,r11
   call heapify
   pop rcx
ifendz:
   pop r11
   pop r10
   pop r9
   ret

;Heapsort(A) {
;   BuildHeap(A)
;   for i <- length(A) downto 1 {
;      exchange A[1] <-> A[i]
;      heapsize <- heapsize -1
;      Heapify(A, 1)
;}
;           r12<-i
heapsort:
   call buildheap          ; return r8<- heapsize
   mov r12,[elements]      ; i<-length(A)
forw1:
   push rax
   push rbx
   mov rax,[array]         ; Exchange A[0]<>A[i]
   mov rbx,[array+r12*8-8]
   mov [array],rbx
   mov [array+r12*8-8],rax
   pop rbx
   pop rax
   dec r8                  ;  heapsize <- heapsize -1
   mov rcx,1
   call heapify            ; heapify(i)
   dec r12                 ; i--
   cmp r12,0               ; if i>0 goto forw1
   jnz forw1
   ret

_start:
  ; Printing the original array
  mov rsi,msg1
  call println            ; declared in basicFunctions
  mov rbx,0
loopx1:
  mov rax,[array+rbx*8]
  inc rbx
  call printnumber        ; declared in basicFunctions
  cmp rbx,[elements]
  je loopx2
  mov rsi,coma
  call print              ; declared in basicFunctions
  jmp loopx1
loopx2:
  call printnewline       ; declared in basicFunctions

  call heapsort

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
