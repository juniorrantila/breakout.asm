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
block.occupied: .space PLAYFIELD_ROWS * PLAYFIELD_COLS * 8, 0xFFFFFFFFFFFFFFFF

.text
.global block_make
block_make: /// row: edi, column: esi
    header

    push BLOCK_HEIGHT + BLOCK_GAP
    pop rax
    imul eax, edi
    mov [rip + block_current.y], ax

    xor eax, eax
    mov eax, esi
    add ax, BLOCK_GAP
    push BLOCK_WIDTH + BLOCK_GAP
    pop rdx
    imul esi, edx
    sub esi, BLOCK_WIDTH - (BLOCK_GAP + BLOCK_GAP / 2)
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


.global block_set_unoccupied
block_set_unoccupied: /// row: di, column: si
    header
    xor eax, eax
    mov ax, si
    imul ax, di
    lea rcx, [rip + block.occupied]
    mov byte ptr [rcx + rax], 0
    footer
    ret


.global blocks_update
blocks_update:
    header

    push rbx
    push r12
    push PLAYFIELD_ROWS
    pop rbx
.blocks_update.loop_y:
    push PLAYFIELD_COLS
    pop r12
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
        mov edi, ebx
        mov esi, r12d
        call block_set_unoccupied

        xor ax, ax
        sub ax, [rip + ball.vy]
        mov [rip + ball.vy], ax

        call sound_did_break_block
    .blocks_update.did_not_hit:
        dec r12b
        jnz .blocks_update.loop_x
    dec bx
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
    push PLAYFIELD_ROWS
    pop rbx
.blocks_render.loop_y:
    push PLAYFIELD_COLS
    pop r12
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
        dec r12b
        jnz .blocks_render.loop_x
    dec bx
    jnz .blocks_render.loop_y
    pop r12
    pop rbx

    footer
    ret
