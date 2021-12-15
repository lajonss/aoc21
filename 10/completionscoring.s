global _start

section .text
_start:
start_loop:
    call parse_line
jmp start_loop
parsing_finished:
    ; call print_scorebuffer
    call compute_score
jmp exit_success

parse_line:
    mov rsi, readchar
    mov rdi, buffer
parse_line_start:
    call read_char
    ; call print_char
    cmp al, 10
    je complete_parenthesis

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
    jne read_till_lf
jmp parse_line_start
complete_parenthesis:
    mov rcx, buffer
    dec rcx
    cmp rcx, rdi
    je parse_line_end

    xor rax, rax
    xor rbx, rbx
complete_parenthesis_loop:
    dec rdi
    cmp rcx, rdi
    je complete_parenthesis_end
    mov bl, [rdi]
    mov rdx, 5
    mul rdx
    cmp rbx, '('
    jne complete_parenthesis_0
    inc rax
jmp complete_parenthesis_loop
complete_parenthesis_0:
    cmp rbx, '['
    jne complete_parenthesis_1
    add rax, 2
jmp complete_parenthesis_loop
complete_parenthesis_1:
    cmp rbx, '{'
    jne complete_parenthesis_2
    add rax, 3
jmp complete_parenthesis_loop
complete_parenthesis_2:
    cmp rbx, '<'
    jne exception
    add rax, 4
jmp complete_parenthesis_loop
complete_parenthesis_end:
    ; call print_debug
    mov rdi, scorebufferlen
    mov rbx, [rdi]
    mov rsi, scorebuffer
    mov [rsi+rbx*8], rax ; qword alignment
    inc rbx
    mov [rdi], rbx
    ;call print_scorebuffer
jmp parse_line_end
    
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

compute_score:
    mov rsi, scorebufferlen
    mov rbx, [rsi]
compute_score_loop:
    cmp rbx, 1
    je pick_score
; remove_min
    mov rdi, scorebuffer
    xor rdx, rdx
    mov rcx, [rsi]
save_min_loop:
        mov rax, [rdi]
        cmp rax, 0
        jl save_min_loop_0
        cmp rdx, 0
        je save_min
        cmp rax, rdx
        jl save_min
save_min_loop_0:
        add rdi, 8 ; qword alignment
    loop save_min_loop
    ; call print_min
    call remove_stored_in_rdx
    dec rbx
; remove_max
    mov rdi, scorebuffer
    xor rdx, rdx
    mov rcx, [rsi]
save_max_loop:
        mov rax, [rdi]
        cmp rdx, 0
        je save_max
        cmp rax, rdx
        jg save_max
save_max_loop_0:
        add rdi, 8 ; qword alignment
    loop save_max_loop
    ; call print_max
    call remove_stored_in_rdx
    dec rbx
jmp compute_score_loop
save_min:
    mov rdx, rax
jmp save_min_loop_0
save_max:
    mov rdx, rax
jmp save_max_loop_0
pick_score:
    mov rsi, scorebuffer
pick_score_loop:
    mov rax, [rsi]
    cmp rax, 0
    jg save_score
    add rsi, 8 ; qword alignment
jmp pick_score_loop
save_score:
    mov rsi, score
    mov [rsi], rax
    call print_score
    call print_newline
ret

remove_stored_in_rdx:
    push rdi
    push rcx
    push rax
        mov rdi, scorebufferlen
        mov rcx, [rdi]
        mov rdi, scorebuffer
remove_stored_in_rdx_loop:
            mov rax, [rdi]
            cmp rax, rdx
            je remove_stored_in_rdx_do
            add rdi, 8 ; qword alignment
        loop remove_stored_in_rdx_loop
jmp exception
remove_stored_in_rdx_do:
        ; call print_number
        ; call print_newline
        xor rax, rax
        dec rax
        mov [rdi], rax
    pop rax
    pop rcx
    pop rdi
ret

print_score:
    push rsi
    push rax
        mov rsi, score
        mov rax, [rsi]
        call print_number
    pop rax
    pop rsi
ret

print_number:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
        mov rbx, 10

        mov rsi, buffer
        add rsi, 99

        xor rcx, rcx

print_score_loop:
        xor rdx, rdx ; div prep
        div rbx
        add rdx, 48
        mov [rsi], dl
        dec rsi
        inc rcx
        cmp rax, 0
        jne print_score_loop

        inc rsi
        mov rax, 1
        mov rdi, 1
        mov rdx, rcx
        syscall
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
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

print_min:
    push rsi
    push rdx
        mov rsi, debugmin
        mov rdx, debugminlen
        call print
    pop rdx
    pop rsi
ret

print_max:
    push rsi
    push rdx
        mov rsi, debugmax
        mov rdx, debugmaxlen
        call print
    pop rdx
    pop rsi
ret

print_min_max:
    call print
    
ret

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

print_scorebuffer:
    push rsi
    push rcx
    push rbx
    push rax
        mov rsi, scorebufferlen
        mov rcx, [rsi]
        mov rsi, scorebuffer
jmp print_scorebuffer_loop_0
print_scorebuffer_loop:
            call print_separator
print_scorebuffer_loop_0:
            mov rax, [rsi]
            call print_number
            add rsi, 8 ; qword alignment
        loop print_scorebuffer_loop

        call print_newline
    pop rax
    pop rbx
    pop rcx
    pop rsi
ret

print_separator:
    push rsi
    push rdx
        mov rsi, debugseparator
        mov rdx, 1
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
    push rcx
        mov rax, 1
        mov rdi, 1
        syscall
    pop rcx
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
    debugscorebuffer:   db "score buffer: "
    debugscorebufferlen:equ $ - debugscorebuffer
    debugseparator:     db ","
    debugmin:           db "min: "
    debugminlen:        equ $ - debugmin
    debugmax:           db "max: "
    debugmaxlen:        equ $ - debugmax

section .bss
    readchar:       resq 1
    buffer:         resb 200
    score:          resq 1
    debugchar:      resq 1
    scorebuffer:    resq 100
    scorebufferlen: resq 1
