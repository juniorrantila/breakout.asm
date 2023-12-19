#include "ball.inc"
#include "util.inc"

.intel_syntax noprefix

.data
.global ball
.global ball.x
.global ball.y
.global ball.w
.global ball.h
.global ball.vx
.global ball.vy
ball:
    ball.x: .long BALL_START_X
    ball.y: .long BALL_START_Y
    ball.w: .long BALL_WIDTH
    ball.h: .long BALL_HEIGHT
    ball.vx: .word 2
    ball.vy: .word 2

.text
.global ball_update
ball_update:
    header

    xor ah, ah

    mov ax, [rip + ball.x]
    add ax, [rip + ball.vx]
    mov [rip + ball.x], ax
    xor edi, edi
    mov di, ax
    xor esi, esi
    mov rdx, WINDOW_WIDTH - BALL_WIDTH
    call check_bounds
    cmp rax, 0
    jz .ball_update.dont_flip_x
.ball_update.flip_x:
    xor ax, ax
    sub ax, [rip + ball.vx]
    mov [rip + ball.vx], ax
.ball_update.dont_flip_x:

    mov ax, [rip + ball.y]
    add ax, [rip + ball.vy]
    mov [rip + ball.y], ax
    xor edi, edi
    mov di, ax
    xor esi, esi
    mov rdx, WINDOW_HEIGHT - BALL_HEIGHT
    call check_bounds
    cmp rax, 0
    jz .ball_update.dont_flip_y
.ball_update.flip_y:
    xor ax, ax
    sub ax, [rip + ball.vy]
    mov [rip + ball.vy], ax
.ball_update.dont_flip_y:

    lea rdi, [rip + paddle]
    lea rsi, [rip + ball]
    call sdl_has_intersection 
    cmp al, 0
    jz .ball_update.end

    xor ax, ax
    sub ax, [rip + ball.vy]
    mov [rip + ball.vy], ax
    
.ball_update.end:
    footer
    ret


.global ball_render
ball_render:
    header

    mov rdi, [rip + renderer]
    mov rsi, 0xFF - 0x18
    mov rdx, 0x18
    mov rcx, 0x18
    mov r8,  0xFF
    call sdl_set_render_draw_color

    mov rdi, [rip + renderer]
    lea rsi, [rip + ball]
    call sdl_render_fill_rect

    footer
    ret
