#pragma once

.macro header
    push rbp
    mov rbp, rsp
.endm

.macro footer
    leave
.endm

.macro set_p0, value
    .set rdi, value
.endm

// SystemV => rdi, rsi, rdx, rcx, r8, r9

.set p0, rdi
#define p1 rsi
#define p2 rdx
#define p3 rcx
#define p4 r8 
#define p5 r9 

.macro breakpoint
    ud2
.endm
