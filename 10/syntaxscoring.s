global _start

section .text
_start:
start_loop:
    call parse_line
jmp start_loop
parsing_finished:
    call print_score
jmp exit_success

parse_line:
    mov rsi, readchar
    mov rdi, buffer
parse_line_start:
    call read_char
    ; call print_char
    cmp al, 10
    je parse_line_end

    cmp rax, '('
    je push_char
    cmp rax, '['
    je push_char
    cmp rax, '{'
    je push_char
    cmp rax, '<'
    je push_char

    dec rdi
    xor rbx, rbx
    mov bl, [rdi]
    ; call print_debug_al_bl
    ; call print_buffer
    call invert_parenthesis
    cmp al, bl
    jne parse_line_error
jmp parse_line_start

parse_line_error:
    mov rsi, score
    mov rbx, [rsi]
    cmp al, '('
    jne parse_line_error_0
    add rbx, 3
jmp parse_line_error_end
parse_line_error_0:
    cmp rax, '['
    jne parse_line_error_1
    add rbx, 57
jmp parse_line_error_end
parse_line_error_1:
    cmp rax, '{'
    jne parse_line_error_2
    add rbx, 1197
jmp parse_line_error_end
parse_line_error_2:
    cmp rax, '<'
    jne exception
    add rbx, 25137
parse_line_error_end:
    mov [rsi], rbx
read_till_lf:
    call read_char
    cmp al, 10
    jne read_till_lf
parse_line_end:
ret

push_char:
    mov [rdi], al
    inc rdi
    ; call print_buffer
jmp parse_line_start

read_char:
    push rdi
    push rsi
    push rdx
        mov rax, 0
        mov rdi, 0
        mov rsi, readchar
        mov rdx, 1
        syscall
        cmp rax, 1
        jne parsing_finished
        xor rax, rax
        mov al, [rsi]
    pop rdx
    pop rsi
    pop rdi
ret

invert_parenthesis:
    cmp al, ')'
    jne invert_parenthesis_0
    mov al, '('
ret
invert_parenthesis_0:
    cmp al, ']'
    jne invert_parenthesis_1
    mov al, '['
ret
invert_parenthesis_1:
    cmp al, '}'
    jne invert_parenthesis_2
    mov al, '{'
ret
invert_parenthesis_2:
    cmp al, '>'
    jne exception
    mov al, '<'
ret

print_score:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
        mov rsi, score
        mov rax, [rsi]
        mov rcx, 10

        mov rsi, buffer
        add rsi, 100
        mov rbx, 10
        mov [rsi], bl
        dec rsi

        mov rbx, 2

print_score_loop:
        xor rdx, rdx
        div rcx
        add rdx, 48
        mov [rsi], dl
        dec rsi
        inc rbx
        cmp rax, 0
        jne print_score_loop

        mov rax, 1
        mov rdi, 1
        mov rdx, rbx
        syscall
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
ret

print_char:
    push rax
    push rdi
    push rsi
    push rdx
        mov rax, 1
        mov rdi, 1
        mov rsi, readchar
        mov rdx, 1
        syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
ret

exception:
    mov rax, 1
    mov rdi, 1
    mov rsi, exceptionstr
    mov rdx, exceptionstrlen
    syscall
jmp exit_failure

exit_success:
    mov rdi, 0
jmp exit
exit_failure:
    mov rdi, 1
exit:
    mov rax, 60
    syscall

print_debug:
    push rsi
    push rdx
        mov rsi, debugstr
        mov rdx, debugstrlen
        call print
    pop rdx
    pop rsi
ret

print_debug_al_bl:
    push rsi
        call print_debug
        mov rsi, debugchar
        mov [rsi], al
        call print_debugchar
        call print_debug
        mov [rsi], bl
        call print_debugchar
        call print_debug
    pop rsi
ret

print_debugchar:
    push rsi
    push rdx
        mov rsi, debugchar
        mov rdx, 1
        call print
    pop rdx
    pop rsi
ret

print_buffer:
    push rsi
    push rdx
        mov rsi, debugstack
        mov rdx, debugstacklen
        call print
        mov rsi, buffer
        mov rdx, buffer
        sub rdx, rdi
        mov rdx, 10
        call print
        mov rsi, debugstackend
        mov rdx, debugstackendlen
        call print
    pop rdx
    pop rsi
ret

print_newline:
    push rsi
    push rdx
        mov rsi, newline
        mov rdx, 1
        call print
    pop rdx
    pop rsi
ret

print:
    push rax
    push rdi
        mov rax, 1
        mov rdi, 1
        syscall
    pop rdi
    pop rax
ret

section .data
    debugstr:           db "k"
    debugstrlen:        equ $ - debugstr
    exceptionstr:       db "exception", 10
    exceptionstrlen:    equ $ - exceptionstr
    newline:            db 10
    debugstack:         db "char stack: '"
    debugstacklen:      equ $ - debugstack
    debugstackend:      db "'", 10
    debugstackendlen:   equ $ - debugstackend

section .bss
    readchar:   resb 1
    buffer:     resb 100
    score:      resq 1
    debugchar:  resb 1
