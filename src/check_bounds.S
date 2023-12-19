.intel_syntax noprefix
.text
.global check_bounds
check_bounds: /// a: u64, min: u64, max: u64
    xor rax, rax
    mov rcx, rax
    inc rcx

    cmp rdi, rsi
    cmovle rax, rcx
    cmp rdi, rdx
    cmovge rax, rcx
    ret


