#include "util.inc"
#include "block.inc"
#include "playfield.inc"

.intel_syntax noprefix

.data
.global block_current
.global block_current.x
.global block_current.y
.global block_current.w
.global block_current.h
.global block.occupied
block_current:
    block_current.x: .long 0
    block_current.y: .long 0
    block_current.w: .long BLOCK_WIDTH
    block_current.h: .long BLOCK_HEIGHT
block.occupied: .space PLAYFIELD_ROWS * PLAYFIELD_COLS, 1

.text
.global block_make
block_make: /// row: edi, column: esi
    header
    xor eax, eax
    mov ax, BLOCK_HEIGHT + BLOCK_GAP
    imul eax, edi
    mov [rip + block_current.y], ax

    xor eax, eax
    mov eax, esi
    add ax, BLOCK_GAP
    lea edx, [0 + BLOCK_WIDTH + BLOCK_GAP]
    imul esi, edx
    sub esi, BLOCK_WIDTH - BLOCK_GAP / 2
    mov [rip + block_current.x], esi
    footer
    ret


.global block_is_occupied
block_is_occupied: /// row: di, column: si
    header
    xor eax, eax
    mov ax, si
    imul ax, di
    lea rcx, [rip + block.occupied]
    mov al, [rcx + rax]
    footer
    ret


.global blocks_update
blocks_update:
    header

    push rbx
    push r12
    mov ebx, PLAYFIELD_ROWS
.blocks_update.loop_y:
    mov r12d, PLAYFIELD_COLS
    .blocks_update.loop_x:
        mov di, bx
        mov si, r12w
        call block_is_occupied
        cmp al, 0
        jz .blocks_update.did_not_hit
        mov edi, ebx
        mov esi, r12d
        call block_make

        lea rdi, [rip + block_current]
        lea rsi, [rip + ball]
        call sdl_has_intersection
        cmp al, 0
        jz .blocks_update.did_not_hit
        xor eax, eax
        mov ax, r12w
        imul ax, bx
        lea rcx, [rip + block.occupied]
        mov byte ptr [rcx + rax], 0
    .blocks_update.did_not_hit:
        dec r12d
        jnz .blocks_update.loop_x
    dec ebx
    jnz .blocks_update.loop_y
    pop r12
    pop rbx

    footer
    ret


.global blocks_render
blocks_render:
    header

    mov rdi, [rip + renderer]
    mov rsi, 0xFF - 0x18
    mov rdx, 0xFF - 0x18
    mov rcx, 0xFF - 0x18
    mov r8,  0xFF
    call sdl_set_render_draw_color

    push rbx
    push r12
    mov ebx, PLAYFIELD_ROWS
.blocks_render.loop_y:
    mov r12d, PLAYFIELD_COLS
    .blocks_render.loop_x:
        mov di, bx
        mov si, r12w
        call block_is_occupied
        cmp al, 0
        jz .blocks_render.dont_render_block
        mov edi, ebx
        mov esi, r12d
        call block_make
        mov rdi, [rip + renderer]
        lea rsi, [rip + block_current]
        call sdl_render_fill_rect
    .blocks_render.dont_render_block:
        dec r12d
        jnz .blocks_render.loop_x
    dec ebx
    jnz .blocks_render.loop_y
    pop r12
    pop rbx

    footer
    ret
