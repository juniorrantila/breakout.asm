#include "util.inc"
#include "sdl.inc"
#include "window.inc"

.intel_syntax noprefix

.data
.global window
.global renderer
.global keyboard
window:   .space 8
renderer: .space 8
keyboard: .space 8

window_name: .asciz "breakout"

start_ticks: .space 4

sdl_event:
    sdl_event.type: .space 4
    sdl_event.data: .space 60

should_quit: .space 1
zero: .space 8, 0

.text
.global breakout_entry
breakout_entry:
    header

    call init
    cmp rax, 0
    jnz .main.fi_0

.main.loop:
    call sdl_ticks
    mov [rip + start_ticks], eax

    call handle_events
    mov ax, [rip + should_quit]
    cmp ax, 0
    jnz .main.loop.end

    call update
    call render
    
    call sdl_ticks
    sub eax, [rip + start_ticks]
    mov edi, 16
    sub edi, eax
    cmp edi, 0
    jle .main.loop
    call sdl_delay
    jmp .main.loop
.main.loop.end:

    call deinit
    xor eax, eax
    jmp .main.end

.main.fi_0:
    mov rdi, rax
    call _puts
    mov eax, 1
.main.end:
    footer
    ret


init:
    header

    mov di, SDL_INIT_VIDEO
    call sdl_init
    cmp rax, 0
    jl .init.fi_0

    lea rdi, [rip + window_name]
    mov rsi, SDL_WINDOWPOS_CENTERED
    mov rdx, SDL_WINDOWPOS_CENTERED
    mov rcx, WINDOW_WIDTH
    mov r8, WINDOW_HEIGHT
    xor r9, r9
    call sdl_create_window
    cmp rax, 0
    jz .init.fi_1
    mov [rip + window], rax

    mov rdi, rax
    mov rsi, -1
    mov rdx, SDL_RENDERER_ACCELERATED
    call sdl_create_renderer
    cmp rax, 0
    jz .init.fi_2
    mov [rip + renderer], rax

    mov rdi, [rip + window]
    call sdl_show_window

    xor rdi, rdi
    call sdl_keyboard_state
    mov [rip + keyboard], rax

    xor rax, rax
    jmp .init.end
.init.fi_2:
    mov rdi, [rip + window]
    call sdl_destroy_window
.init.fi_1:
    call sdl_quit
.init.fi_0:
    call sdl_get_error
.init.end:
    footer
    ret


deinit:
    header
    mov rdi, [rip + renderer]
    call sdl_destroy_renderer
    mov rdi, [rip + window]
    call sdl_destroy_window
    call sdl_quit
    footer
    ret


update:
    header

    call paddle_update
    call ball_update 
    call blocks_update
    call log_state

    footer
    ret


render_clear:
    header

    mov rdi, [rip + renderer]
    mov rsi, 0x18
    mov rdx, 0x18
    mov rcx, 0x18
    mov r8,  0xFF
    call sdl_set_render_draw_color

    mov rdi, [rip + renderer]
    call sdl_render_clear

    footer
    ret


render:
    header

    call render_clear
    call blocks_render
    call paddle_render
    call ball_render

    mov rdi, [rip + renderer]
    call sdl_render_present

    footer
    ret


on_quit:
    mov byte ptr [rip + should_quit], 1
    ret


handle_events:
    header
    push rbx
    push r12
    lea rbx, [rip + .handle_events.loop]
.handle_events.loop:
    xor rbx, rbx
    lea rdi, [rip + sdl_event.type]
    call sdl_poll_event
    cmp rax, 0
    jz .handle_events.loop.end

    mov eax, [rip + sdl_event.type]

    lea r12, [rip + on_quit]
    cmp eax, SDL_QUIT
    cmove rbx, r12

    cmp rbx, 0
    je .handle_events.loop
    lea r12, [rip + .handle_events.loop]
    push r12
    jmp rbx
.handle_events.not_quit:
    jmp .handle_events.loop

.handle_events.loop.end:
    pop r12
    pop rbx
    footer
    ret
