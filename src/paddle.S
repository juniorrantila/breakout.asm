#include "paddle.inc"
#include "util.inc"
#include "sdl.inc"

.intel_syntax noprefix

.data
.global paddle
.global paddle.x
.global paddle.y
.global paddle.w
.global paddle.h
.global paddle.vx
.global paddle.vy
paddle:
    paddle.x: .long PADDLE_START_X
    paddle.y: .long PADDLE_Y
    paddle.w: .long PADDLE_WIDTH
    paddle.h: .long PADDLE_HEIGHT
    paddle.vx: .word 3
    paddle.vy: .word 3

.text
.global paddle_update
paddle_update:
    header

    mov si, 1
    mov rax, [rip + keyboard]
    mov dx, [rip + paddle.x]
    mov al, byte ptr [rax + SDL_SCANCODE_A]
    xor ah, ah
    imul ax, [rip + paddle.vx]
    sub dx, ax
    cmp dx, si
    cmovle dx, si
    mov [rip + paddle.x], dx

    mov si, WINDOW_WIDTH - PADDLE_WIDTH - 1
    mov rax, [rip + keyboard]
    mov dx, [rip + paddle.x]
    mov al, byte ptr [rax + SDL_SCANCODE_D]
    xor ah, ah
    imul ax, [rip + paddle.vx]
    add dx, ax
    cmp dx, WINDOW_WIDTH - PADDLE_WIDTH
    cmovge dx, si
    mov [rip + paddle.x], dx
    
    footer
    ret


.global paddle_render
paddle_render:
    header

    mov rdi, [rip + renderer]
    mov rsi, 0xFF - 0x18
    mov rdx, 0xFF - 0x18
    mov rcx, 0xFF - 0x18
    mov r8,  0xFF
    call sdl_set_render_draw_color

    mov rdi, [rip + renderer]
    lea rsi, [rip + paddle]
    call sdl_render_fill_rect

    footer
    ret
