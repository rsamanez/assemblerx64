;; c^2 = a^2 + b^2 - cos(C)*2*a*b
;; C is stored in ang

global _start

%include '../Basics/basicFunctions.asm'

section .data
    a: dq 4.56385   ;length of side a
    b: dq 7.89285   ;length of side b
    ang: dq 1.5  ;opposite angle to side c (around 85.94 degrees)
    binBuff: times 66 db 0
    sign: db "-",0
    punto: db ".",0
section .bss
    c: resq 1    ;the result ‒ length of side c

section .text


; doublePrint(RAX)
doublePrint:
    push rsi
    push rcx
    push rbx
    push rdx
    ;------------------------------------------------------------
    push rax
    push rax
    ; sign extract
    rol rax,1
    and rax,1
    cmp rax,0
    jz .positive
    mov rsi,sign
    call print          ; prints - sign
.positive:
    ; getting Exponent
    pop rax
    rol rax,12
    and rax,0x7FF
    mov rcx,1023
    cmp rax,rcx
    jge caso2
    sub rcx,rax     ; Exponent Negative
    dec rcx
    mov rax,2
    shl rax,cl
    shl rax,52
    mov rbx,rax
    jmp nextz
caso2:
    sub rax,rcx     ; Exponent Positive
    mov rcx,51
    sub rcx,rax 
    mov rax,2
    shl rax,cl
    mov rbx,rax
nextz:
    pop rax
    mov rcx,0xFFFFFFFFFFFFF
    and rax,rcx
    mov rcx,0x10000000000000
    or rax,rcx
    xor rdx,rdx
    div rbx
    call printnumber
    mov rsi,punto
    call print
    push rdx
    mov rax,rbx
    xor rdx,rdx
    mov rcx,100000000
    div rcx
    mov rbx,rax
    pop rax
    xor rdx,rdx
    div rbx
    call printnumber
    ;------------------------------------------------------------
    pop rdx
    pop rcx
    pop rbx
    pop rsi
    ret



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
    mov rax,[a]
    call doublePrint
    call printnewline
    mov rax,[b]
    call doublePrint
    call printnewline

    fld    qword [a]   ;load a into st0
    fmul   st0, st0    ;st0 = a * a = a^2

    fld    qword [b]   ;load b into st0   (pushing the a^2 result up to st1)
    fmul   st0, st0    ;st0 = b * b = b^2,   st1 = a^2

    faddp              ;add and pop, leaving st0 = old_st0 * old_st1 = a^2 + b^2.  (st1 is freed / empty now)

    fld    qword [ang] ;load angle into st0.  (st1 = a^2 + b^2 which we'll leave alone until later)
    fcos               ;st0 = cos(ang)

    fmul   qword [a]   ;st0 = cos(ang) * a
    fmul   qword [b]   ;st0 = cos(ang) * a * b
    fadd   st0, st0    ;st0 = cos(ang) * a * b + cos(ang) * a * b = 2(cos(ang) * a * b)

    fsubp  st1, st0    ;st1 = st1 - st0 = (a^2 + b^2) - (2 * a * b * cos(ang))
                       ;and pop st0

    fsqrt              ;take square root of st0 = c

    fstp   qword [c]   ;store st0 in c and pop, leaving the x87 stack empty again ‒ and we're done!
    mov rax,qword[c]

    push rax
    call binprint
    call printnewline
    pop rax
    call doublePrint
    call printnewline
    call exit