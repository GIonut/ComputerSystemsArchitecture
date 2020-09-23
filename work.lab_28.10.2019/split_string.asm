bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s db 'AB0C3'
    len equ $-s
    ci times len db 0
    li times len db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, len
        mov esi, 0
        mov edi, 0; index for letters
        mov edx, 0; index for digits
        et:
            mov al, [s+esi]
            cmp al, 'A'
            jl digit
            mov [li+edi], al
            inc edi
            jmp end
            digit:
                mov [ci+edx], al
                inc edx
            end:
            inc esi
        loop et
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
