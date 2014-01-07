Adding system calls to the Linux kernel.
======

This is my reproduction of the lab instructions originally written by Professor Garcia, University of San Diego.
To be clear, none of the following contents are originally my own.

## Overview

The general steps to adding a new system call are:

  1. Add a new system call number to the kernel.
  2. Add an antry to the kernel's system call table associated with the system call number that specifies which kernel function to invoke when there is a trap with the new system call number.
  3. Add code to the kernel that implements the functionality.

### Add call number and entry to call table

#### 64-bit x86

Go to `arch/x86/include/asm/unistd_64.h` and add

      #define __NR_newsystemcall 999
      __SYSCALL (__NR_newsystemcall, sys_newsystemcall)

The file `arch/x86/kernel/syscall_64.c` will generate the 64-bit call table.
The change made in `unistd_64.h` will cause header files to be added to 
`include/asm-generic` and `include/asm-x86/` with the new system call information

#### 32-bit x86

Go to `arch/x86/kernel/syscall_table_32.S` and add

      .long sys_rt_tgsigqueueinfo
      .long sys_perf_event_open
      .long sys_newsystemcall

Then in `arch/x86/include/asm/unistd_32.h` add

      #define __NR_per_event_open 998
      #define NR_syscalls 999

### Implement the system call

At the bottom of `include/asm-generic/syscalls.h` add a function prototype for the system call

      #ifndef sys_newsystemcall
      asmlinkage long sys_newsystemcall(int flag1, int flag2, ...)
      #endif

New type definitions should go in `include/linux/`.  be sure to include header guards.

Add the file that actually implements the new system call.  This aught to go in `kernel/`.  Using the macros, this looks like:

      #include <linux/kernel.h>
      #include <asm/uaccess.h>
      #include <linux/syscalls.h>
      //others as needed

      SYSCALL_DEFINE2(newsystemcall, int, flag, int __user *, flag2){
        /* The implementation goes here.
         * Notice that it is "SYSCALL_DEFINE" + number of user args
         */
        return 0;
      }

Now modify `kernel/Makefile` so that the new system call is built with the kernel.
Add

      obj-y += newsystemcall.o

right before

      obj-y += groups.o
