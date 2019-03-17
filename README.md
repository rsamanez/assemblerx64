# Assembler x64 Samples

Good x64 Samples https://github.com/Sakib2263/64-Bit-NASM-Assembly-Code-Examples

Samples to Compile asm with C extern functions https://www.csee.umbc.edu/portal/help/nasm/sample_64.shtml#hello_64.asm

How to compile:

nasm -f elf64 -l hello_64.lst  hello_64.asm

gcc -m64 -no-pie -o hello_64  hello_64.o
