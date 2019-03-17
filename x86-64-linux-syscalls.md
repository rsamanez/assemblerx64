x86-64 assembly on Linux - syscalls

Posted: 21 Jan 2010, Updated: 10 Sep 2017

*update* while fixing the broken links in this article, I stumbled across a much more complete writeup on Linux syscalls over here.

There are plenty of tutorials showing how write Linux programs in x86 assembler, a good resource is http://asm.sourceforge.net. However, there is very little on 64bit x86 assembler (x86-64). x86-64 is very similar to its 32bit counterpart. The main difference is that the registers are wider and there are more of them. You might think this would make it easy to adapt 32bit code to run in 64ibt mode under Linux.

Of course, there are a few gotchas. Linux has a completely different system call ABI under 64bit mode. The syscalls have different numbers and are called in a completely different way. Depending on how your kernel was compiled though, the 32bit interface may be present and usable as well lkml.

In ignorance of this situation, I wrote a whole lot of code making simple 32bit syscalls from 64bit mode. It worked just fine on my Ubuntu system. Then I tried it under 64bit ttyLinux, a minimalist Linux distribution. My programs crashed as soon as they hit the first syscall.

If you want your assembler programs to work reliably across different kernels and distributions, you ought to use the correct ABI.

So, how does it work? It's based on the x86-64 UNIX C ABI which goes like this: arguments 1-6 are passed in the registers RDI, RSI, RDX, RCX, R8, R9. The result comes back in the RAX register, if 64bits isn't enough the high bits are in RDX. The parameter registers plus R10 and R11 are clobbered, the rest are saved. C's int type is 32bits, C's long type is 64bits. It's all described in this document.

For the 64bit syscalls, parameter 4 is passed in R10 instead of RCX. RCX is still clobbered. The syscall number is passed in RAX, as in 32bit mode, but instead of the "int 0x80" used in 32bit mode, 64bit syscalls are made with the "syscall" instruction. The syscall numbers can be found in the Linux source code under arch/x86/entry/syscalls/syscall_64.tbl.

original source: https://callumscode.com/blog/2010/jan/x86-64-linux-syscalls


Document links:

NASM - The Netwide Assembler  https://www.nasm.us/xdoc/2.14.02/html/nasmdoc0.html

Assembler Code Tutorials  http://asm.sourceforge.net/resources.html#tutorials

Learn NASM Assembly 32bits https://www.tutorialspoint.com/assembly_programming/index.htm
