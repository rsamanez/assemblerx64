; Simple Keyboard Reading function in x86_64 assembly, using Linux syscalls
;
; Adaptation of original code from:
;   https://stackoverflow.com/questions/32193374/wait-for-keypress-assembly-nasm-linux
;--------------------------------------------------------------------------
;   %include 'readKeyFunction.asm'
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
section .data
  orig: times 100 db 0
  new:  times 100 db 0
  char: db 0,0

readKeyInit:
    push rax
    push rdx
    push rsi
    push rdi

    ; fetch the current terminal settings
    mov rax, 16    ; __NR_ioctl
    mov rdi, 0     ; fd: stdin
    mov rsi, 21505 ; cmd: TCGETS
    mov rdx, orig  ; arg: the buffer, orig
    syscall

    ; again, but this time for the 'new' buffer
    mov rax, 16
    mov rdi, 0
    mov rsi, 21505
    mov rdx, new
    syscall

    ; change settings
    and dword [new+0], -1516    ; ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON)
    and dword [new+4], -2       ; ~OPOST
    and dword [new+12], -32844  ; ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN)
    and dword [new+8], -305     ; ~(CSIZE | PARENB)
    or  dword [new+8], 48        ; CS8

    ; set settings (with ioctl again)
    mov rax, 16    ; __NR_ioctl
    mov rdi, 0     ; fd: stdin
    mov rsi, 21506 ; cmd: TCSETS
    mov rdx, new   ; arg: the buffer, new
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax
    
    ret

readKeyReset:
    push rax
    push rdx
    push rsi
    push rdi

    ; reset settings (with ioctl again)
    mov rax, 16    ; __NR_ioctl
    mov rdi, 0     ; fd: stdin
    mov rsi, 21506 ; cmd: TCSETS
    mov rdx, orig  ; arg: the buffer, orig
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax
    
    ret
;----------------------------------------------------
; readkey function
; return readkey on rax [al]
;----------------------------------------------------
readKey:
    
    push rdx
    push rsi
    push rdi
    ; read character
    mov rax, 0     ; __NR_read
    mov rdi, 0     ; fd: stdin
    mov rsi, char  ; buf: the temporary buffer, char
    mov rdx, 1     ; count: the length of the buffer, 1
    syscall
    mov al,byte[char]
    pop rdi
    pop rsi
    pop rdx
    
    ret