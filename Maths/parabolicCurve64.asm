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


section .data
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
; drawParabola(color) color = R10  v0=10184  angle=60°    
drawParabola:
    push rax
    push rbx
    push rcx                  ;  ecuation   y = 17321x/10000 - x^2/548
    push rdx                  ; x = [0..950]
    ;-----------------------------------
    mov r10,0x00ff00
    mov rbx,1
    ;-----------------------------------------
    push r8
    push r9
nextPixel:
    mov rax,rbx             ; rbx <- x
    mov rcx,17321
    mul rcx                 ; rax <- x * 17321
    xor rdx,rdx
    mov rcx,10000
    div rcx
    push rax                ; rax <- 17321x/10000
    mov rax,rbx             ; rax <- x
    xor rdx,rdx
    mul rbx                 ; rax <- x^2
    mov rcx,548
    xor rdx,rdx
    div rcx                 ; rax <- x^2/548
    mov rcx,rax             ; rcx <- x^2/548
    pop rax
    sub rax,rcx                 ; rax <- 17321x/10000 - x^2/548
    ;--------------------------------------
    mov r8,rbx              ; r8 <- x
    mov r9,rax              ; r9 <- y
    call drawPixel
    inc rbx
    cmp rbx,950
    jnz nextPixel
    pop r9
    pop r8
    ;-----------------------------------
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

_start:
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

    call drawParabola
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
