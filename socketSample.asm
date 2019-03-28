global _start

struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resb 8
endstruc

struc img
    .source_ip  resb 4
    .int_ip resb 4
    .group_ip   resb 4
endstruc

section .bss

    listen_socket:  resq 1
    buffer: resb 2048

section .data

pop_sa istruc sockaddr_in
        at sockaddr_in.sin_family, dw 2           ; AF_INET
        at sockaddr_in.sin_port, dw 0x4b10        ; port 40011
        at sockaddr_in.sin_addr, dd 0xb46c0ef             ; INADDR_ANY
        at sockaddr_in.sin_zero, dd 0, 0
iend
sockaddr_in_len     equ $ - pop_sa

pop_mc  istruc img  ;
    at img.source_ip,   dd 0xb46c0ef ;
    at img.int_ip,      dd 0             ; INADDR_ANY
    at img.group_ip,    dd 0x5a81320a ;
iend
img_len equ $ - pop_mc
from_ip:    dw 0    
from_ip_len:    db 16

section .text

_start:

    mov rdi, 2      ;AF_INET
    mov rsi, 2      ;SOCK_DGRAM
    mov rdx, 0      ;IPPROTO_UDP
    mov rax, 41
    syscall         ;sys_create_udp_socket
    mov[listen_socket], rax

    mov r8, 4        
    mov r10, 1   
    mov rdx, 2  ;SO_REUSEADDR
    mov rsi, 1  ;SOL_SOCKET
    mov rdi,[listen_socket]
    mov rax, 54
    syscall         ;sys_setsockopt

    mov rdx, sockaddr_in_len
    mov rsi, pop_sa
    mov rdi,[listen_socket]
    mov rax, 49
    syscall         ;sys_bind

    mov r8, img_len
    mov r10, pop_mc
    mov rdx, 39     ;IP_ADD_SOURCE_MEMBERSHIP
    mov rsi, 0  ;IPPROTO_UDP
    mov rdi,[listen_socket]
    mov rax, 54
    syscall         ;sys_setsockopt

    mov r9, [from_ip_len]   ;
    mov r8, [from_ip]
    mov r10, 0
    mov rdx, 2047
    mov rsi, buffer
    mov rdi,[listen_socket]
    mov rax, 45
    syscall         ;sys_recvfrom

    mov rdi, 0
    mov rax, 60
    syscall         ;sys_exit