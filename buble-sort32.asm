

section .data
welcome:        db      "Input the size of the array; Input q to quit"
w_len:          equ     $ - welcome
in_msg:         db      0xa, "Enter N: "
im_len:         equ     $ - in_msg
num_msg:        db      "Enter the numbers", 10
nm_len:         equ     $ - num_msg
out_msg:        db      "Sorted array: "
om_len:         equ     $ - out_msg

section .bss
n_str:          resb    4
num_str:        resb    4
num_arr:        resd    64

section .text
        global _start
print:
        push    ebx
        push    eax
        mov     eax,4
        mov     ebx,1
        int     0x80
        pop     eax
        pop     ebx
        ret

scan:
        push    ebx
        push    eax
        mov     eax,3
        mov     ebx,0
        int     0x80
        pop     eax
        pop     ebx
        ret

xTen:
        push    ebx
        mov     ebx,eax
        shl     eax,2
        add     eax,ebx
        shl     eax,1
        pop     ebx
        ret

byTen:
        push    edx
        push    ecx
        mov     edx,0
        mov     ecx,10
        div     ecx
        mov     ebx,edx
        pop     ecx
        pop     edx
        ret

toInt:
        push    ebx
        mov     eax,0
        mov     ebx,0
    .loopStr:
        call    xTen
        push    edx
        mov     edx,0
        mov     dl,byte[ecx+ebx]
        sub     dl,0x30
        add     eax,edx
        pop     edx
        inc     ebx
        cmp     byte[ecx+ebx],0xa
        jle     .return
        cmp     ebx,edx
        jge     .return
        jmp     .loopStr
    .return:
        pop     ebx
        ret

toStr:
        push    ebx
        push    eax
        mov     ebx,0
        push    0
    .loopDiv:
        call    byTen
        add     ebx,0x30
        push    ebx
        cmp     eax,0
        jg      .loopDiv
        mov     ebx,0
    .loopStr:
        pop     eax
        cmp     eax,0
        je      .loopFill
        cmp     ebx,edx
        je      .loopStr
        mov     byte[ecx+ebx],al
        inc     ebx
        jmp     .loopStr
    .loopFill:
        cmp     ebx,edx
        je      .return
        mov     byte[ecx+ebx],0
        inc     ebx
        jmp     .loopFill
    .return:
        pop     eax
        pop     ebx
        ret

sortN:  ;ebx=address of the array of numbers, ecx=array size(>0)
        ;Array gets sorted descending order.
        ;Equivalent C program (a = array; n = length):
        ; i=n;
        ; do {
        ;     i--;
        ;     j=i;
        ;     do {
        ;         j--;
        ;         if (a[i]>a[j])
        ;             swap(a[i],s[j]);
        ;     } while(j>0);
        ; } while (i>1);
        push    eax
        push    esi ;esi and edi are used here like eax, ebx etc.; Nothing special!
        push    edi
        mov     edi,ecx
        shl     edi,2
    .loopN:
        sub     edi,4
        mov     eax,dword[ebx+edi]
        mov     esi,edi
    .loopIn:
        sub     esi,4
        cmp     eax,dword[ebx+esi]
        jg      .swap
        jmp     .continue
    .swap:
        push    dword[ebx+esi]
        push    dword[ebx+edi]
        pop     dword[ebx+esi]
        pop     dword[ebx+edi]
        mov     eax,dword[ebx+edi]
    .continue:
        cmp     esi,0
        jg      .loopIn
        cmp     edi,4
        jg      .loopN

        pop     edi
        pop     esi
        pop     eax
        ret

_start:
        mov     ecx,welcome
        mov     edx,w_len
        call    print
    .main_loop:
        mov     ecx,in_msg ;Ask the user for N
        mov     edx,im_len
        call    print

        mov     ecx,n_str ;Input N
        mov     edx,4
        call    scan

        cmp     byte[n_str],0x71 ;If 'q', quit
        je      .quit

        call    toInt ;get the integer N, push it, and move it to ebx
        push    eax
        mov     ebx,eax

        mov     ecx,num_msg ;Ask the user to input all numbers
        mov     edx,nm_len
        call    print

    .loopN_1: ;Input the numbers
        dec     ebx
        ;get the number and store it in [num_arr+ebx*4]
        mov     ecx,num_str
        mov     edx,4
        call    scan
        call    toInt
        mov     edx,ebx
        shl     edx,2 ;edx = edx*4
        mov     dword[num_arr+edx], eax
        cmp     ebx,0
        jne     .loopN_1 ;Note: The numbers will be stored in reverse order of input

        mov     ebx,num_arr
        pop     ecx ;pop N to ecx
        call    sortN
        mov     ebx,ecx

        mov     ecx,out_msg
        mov     edx,om_len
        call    print

    .loopN_2: ;Output the numbers
        dec     ebx
        mov     edx,ebx
        shl     edx,2
        mov     eax, dword[num_arr+edx]
        mov     ecx,num_str
        mov     edx,4
        call    toStr
        mov     byte[num_str+3],0x20 ;ascii code for space
        call    print
        cmp     ebx,0
        jne     .loopN_2 ;Note: The numbers will be printed in reverse order too

        jmp     .main_loop

    .quit:
        mov     ebx,0
        mov     eax,1
        int     0x80

