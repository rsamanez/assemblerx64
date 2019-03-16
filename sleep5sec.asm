global  _start

section .text
_start:

  ; print "Sleep"
  mov eax, 4
  mov ebx, 1
  mov ecx, bmessage
  mov edx, bmessagel
  int 0x80

  ; Sleep for 5 seconds and 0 nanoseconds
  mov dword [tv_sec], 5
  mov dword [tv_usec], 0
  mov eax, 162
  mov ebx, timeval
  mov ecx, 0
  int 0x80

  ; print "Continue"
  mov eax, 4
  mov ebx, 1
  mov ecx, emessage
  mov edx, emessagel
  int 0x80

  ; exit
  mov eax, 1
  mov ebx, 0
  int 0x80

section .data

  timeval:
    tv_sec  dd 0
    tv_usec dd 0

  bmessage  db "Sleep", 10, 0
  bmessagel equ $ - bmessage

  emessage  db "Continue", 10, 0
  emessagel equ $ - emessage

