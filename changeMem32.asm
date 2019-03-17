; The program illustrates some of the concepts about using the memory area.
; It stores a name 'Zara Ali' in the data section of the memory, then changes
; its value to another name 'Nuha Ali' programmatically and displays both the
; names.
;  COMPILE:
;  nasm -f elf chengeMem32.asm
;  ld -m elf_i386 changeMem32.o -o changeMem32
;-------------------

section	.text
   global _start     ;must be declared for linker (ld)
_start:              ;tell linker entry point
	
   ;writing the name 'Zara Ali'
   mov	edx,10       ;message length
   mov	ecx, name   ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
	
   mov	[name],  dword 'Nuha'    ; Changed the name to Nuha Ali
	
   ;writing the name 'Nuha Ali'
   mov	edx,10       ;message length
   mov	ecx,name    ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
	
   mov	eax,1       ;system call number (sys_exit)
   int	0x80        ;call kernel

section	.data
name db 'Zara Ali ',0ah,0h


