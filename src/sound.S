#include "util.inc"

.intel_syntax noprefix

.data
beep: .asciz "\7"

.macro sound_beep
#if __APPLE__
    call _NSBeep
#else
    lea rdi, [rip + beep]
    call printf
    xor edi, edi
    call fflush
#endif
.endm

.text
.global sound_did_break_block
sound_did_break_block:
    header
    sound_beep
    footer
    ret

.global sound_ball_did_hit_paddle
sound_ball_did_hit_paddle:
    header
    sound_beep
    footer
    ret

.global sound_ball_did_hit_wall
sound_ball_did_hit_wall:
    header
    sound_beep
    footer
    ret
