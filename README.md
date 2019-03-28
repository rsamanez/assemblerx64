# Assembler x64 Samples

Good x64 Samples https://github.com/Sakib2263/64-Bit-NASM-Assembly-Code-Examples

Samples to Compile asm with C extern functions https://www.csee.umbc.edu/portal/help/nasm/sample_64.shtml#hello_64.asm

How to compile files with C imported:

nasm -f elf64 -l hello_64.lst  hello_64.asm

gcc -m64 -no-pie -o hello_64  hello_64.o

# How to compile with debugging symbols   

nasm -f elf64 -F dwarf -g  sample.asm   

ld -o sample sample.o   

use ddd a linux gui Debugger.   

DDD Reference:  http://www.gnu.org/software/ddd/
   
# syscall reference and demos   
https://www.exploit-db.com/shellcodes
   
http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/


# x86 and amd64 instruction reference
https://www.felixcloutier.com/x86

# Assembly Programming Tutorial
https://www.tutorialspoint.com/assembly_programming/index.htm

# More samples
http://lez-uncomplicate.blogspot.com/2012/02/nasm-example-3-input-array-and-sort-it.html

# Assembler Tutor
https://asmtutor.com/#lesson1
https://www.csee.umbc.edu/portal/help/nasm/sample_64.shtml#hello_64.asm

# Intel® 64 and IA-32 ArchitecturesSoftware Developer’s Manual
https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.pdf

# ASCII Reference
https://elcodigoascii.com.ar/codigos-ascii/numero-cero-0-codigo-ascii-48.html
