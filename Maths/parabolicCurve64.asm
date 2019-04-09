; Program to draw flight path of a projectile to 1000x1000 Bitmap File
;
; Ecuation:
;
;      y = x.tan(Ø) - g.x^2 / 2Vo^2 . cos^2(Ø)
;
; Compile with:
;     nasm -f elf64 -o parabolicCurve64.o parabolicCurve64.asm
; Link with:
;     ld -m elf_x86_64 -o parabolicCurve64 parabolicCurve64.o
; Run with:
;     ./parabolicCurve64
;==============================================================================
; Author : Rommel Samanez
; https://github.com/rsamanez/assemblerx64
;==============================================================================
global _start

%include '../Basics/basicFunctions.asm'

section .data
  angle: dq 0
  steps: dq 2.0
  ang:   dq 89.0
  v0:  dq 100.0
  c:   dq 0
  pi:  dq 3.1415926
  wq:  dq 200.00
  M1:  dq 0
  M2:  dq 0
  g:    dq 9.81
  xx:  dq 0
  yy:  dq 0
  uno:  dq 1.0
  inicio: dq 1.0
  binBuff: times 66 db 0
  sign: db "-",0
  punto: db ".",0
  fileName:  db "parabolicCurve.bmp",0
  fileFlags: dq 0102o         ; create file + read and write mode
  fileMode:  dq 00600o        ; user has read write permission
  fileDescriptor: dq 0
  bitmapImage: times 3000000 db 0
section .rodata    ; read only data section
    bmpWidth   equ  1000
    bmpHeight   equ  1000
    bmpSize equ 3 * bmpWidth * bmpHeight
    headerLen equ 54
    header: db "BM"         ; BM  Windows 3.1x, 95, NT, ... etc.
    bfSize: dd bmpSize + headerLen   ; The size of the BMP file in bytes
            dd 0                 ; reserved
    bfOffBits: dd headerLen   ; The offset, i.e. starting address, of the byte where the bitmap image data (pixel array) can be found
    biSize:   dd 40    ; header size, min = 40
    biWidth:  dd bmpWidth
    biHeight: dd bmpHeight
    biPlanes:       dw 1     ; must be 1
    biBitCount:     dw 24    ; bits per pixel: 1, 4, 8, 16, 24, or 32
    biCompression:  dd 0     ; uncompressed = 0
    biSizeImage:    dd bmpSize  ; Image Size - may be zero for uncompressed images
    hresolution:    dd 0
    vresolution:    dd 0
    palettecolors:  dd 0
    importantcolors: dd 0

section .text

; doubleToInt(RAX) return value=RAX negative=rsi
doubleToInt:
    push rbx
    push rcx
    push rdx
    ;------------------------------------------------------------
    xor rsi,rsi     ; rsi=0 means positive
    push rax
    push rax
    ; sign extract
    rol rax,1
    and rax,1
    cmp rax,0
    jz .positive
    mov rsi,1       ; rsi=1 means negative
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
    div rbx             ; rax = integer part
    ;------------------------------------------------------------
    pop rdx
    pop rcx
    pop rbx
    ret


; drawPixel(x,y,color{RGB}) ( R8,R9,R10) 
drawPixel:
    push rax
    push rbx
    ;---------------------------------
    mov rax,3000
    mul r9
    push rax
    mov rax,3
    mul r8
    pop rbx
    add rax,rbx         ; offset:  rax = 3*x+3000*y
    push r10
    pop rbx
    mov word[bitmapImage+rax],bx
    shr rbx,16
    mov byte[bitmapImage+rax+2],bl
    ;----------------------------------
    pop rbx
    pop rax
    ret
; color=R10 [angle]=inclination(grades)   [v0]=initial velocity
drawTrayectory:
    push r10
    push rbx
    push rax
    push r9
    push r8
    ;  y = M1*x - M2*x^2
    ;-----------------------------------
    mov r10,0x00ff00
    mov rbx,1
    ;-----------------------------------------
    ;  convert grades to radians
    fld   qword[angle]   ;load a into st0
    fmul  qword[pi]      ; st0 = st0 * PI
    fdiv qword[wq]       ; st0 = st0 / wq
    fstp qword[angle]    ; angle = st0
    ;-----------------------------------------
    ; M1 calcule
    fld  qword[angle]    ; st0 = angle
    fptan
    fstp qword[c]       ; se descarta
    fstp qword[M1]       ; M1 = tan(angle)
    ;-----------------------------------------
    ; M2 calculate
    fld  qword[g]       ; st0 = g
    fld  qword[v0]      ; st0 = v0  st1=g
    fmul st0,st0        ; st0 = v0*v0
    fld  qword[angle]   ; st0=angle st1=v0*v0 st2=g
    fcos                ; st0 = cos(angle)
    fmul st0,st0        ; st0 = cos(angle)*cos(angle)
    fmul st0,st1        ; st0 = cos(angle)*cos(angle)*v0*v0
    fadd st0,st0        ; st0 = 2*cos(angle)*cos(angle)*v0*v0
    fstp qword[M2]
    fstp qword[c]       ; se descarta
    fdiv qword[M2]      ; st0 = g / 2*cos(angle)*cos(angle)*v0*v0
    fstp qword[M2]      ; M2  = g / 2*cos(angle)*cos(angle)*v0*v0
    ;------------------------------------------
    mov rbx,1   ; x position
    fld qword[inicio] ; st0=1.0
    fstp qword[xx]
 loopD1:
    fld qword[xx]       ; sto =x
    fmul qword[M1]      ; st0 = M1*x
    fld qword[xx]       ; st0 = x   st1=M1*x
    fmul st0,st0        ; st0 = x^2
    fmul qword[M2]      ; st0 = M2*x^2
    fsubp  st1, st0
    fstp   qword [yy]   ; y value
    ;-----------------------------------------
    mov rax,qword[yy]
    call doubleToInt
    cmp rsi,1
    jz loopD2       ; finish when y<0
    cmp rax,1000
    jge loopD2      ; finish if y>=1000
    mov r8,rbx      ; r8=x
    mov r9,rax      ; r9=y
    call drawPixel
    inc rbx
    cmp rbx,1000
    jz loopD2
    ;-----------------------------------------
    fld qword[xx]
    fadd qword[uno]
    fstp qword[xx]      ; x new value
    jmp loopD1
    ;-----------------------------------------
loopD2:
    pop r8
    pop r9
    pop rax
    pop rbx
    pop r10
    ret


_start:

    mov r12,39
    mov rax, qword [ang]
    mov qword [angle],rax
xx1:
    call drawTrayectory
    fld qword[ang]
    fsub  qword[steps]
    fstp   qword [ang] 
    mov rax, qword [ang]
    mov qword [angle],rax 
    dec r12
    cmp r12,0
    jnz xx1

    mov rax,2               ;   sys_open
    mov rdi,fileName        ;   const char *filename
    mov rsi,[fileFlags]       ;   int flags
    mov rdx,[fileMode]        ;   int mode
    syscall
    mov [fileDescriptor],rax

    ; write the header to file
    mov rax,1                 ; sys_write
    mov rdi,[fileDescriptor]
    mov rsi,header
    mov rdx,54
    syscall

    
    ; write the Image to file
    mov rax,1                 ; sys_write
    mov rdi,[fileDescriptor]
    mov rsi,bitmapImage
    mov rdx,3000000
    syscall
    

    ; close file Descriptor
    mov rax,3                 ; sys_close
    mov rdi,[fileDescriptor]
    syscall

    ; EXIT to OS
    mov rax,60
  	mov rdi,0
  	syscall
