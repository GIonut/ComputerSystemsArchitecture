bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
 ;Exercice 1
 ; a, b - words; c- dword
 ;the bits 0-4 of C are the same as the bits 11-15 of A
 ;the bits 5-11 of C have the value 1
 ;the bits 12-15 of C are the same as the bits 8-11 of B
 ;the bits 16-31 of C are the same as the bits of A
; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 1001000101010010b ;9152h
    b dw 1101001010101010b ;D2AAh
    c dd 00000000h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov bx, [a] ; bx := 9152h = 1001000101010010b and
        and bx, 1111100000000000b ; 1111100000000000b
                             ;bx := 1001000000000000b := 9000h
        mov cl, 11
        ror bx, cl; bx := 0000000000010010b := 12h
        
        mov ax, 0;
        or ax, bx; ax := 0000000000010010b := 12h
        
        or ax, 00111111100000b; ax := 0000111111110010b := 0FF2h
        
        mov bx, [b];        bx := 1101001010101010b := D2AAh
        and bx, 0000111100000000b;0000111100000000b
                           ;bx := 0000001000000000b := 0200h
        mov cl, 4
        rol bx, cl ; bx := 0010000000000000b := 2000h
        or ax, bx; ax := 0010111111110010b := 2FF2h
        
        mov dx, [a]; dx := 1001000101010010b := 9152h
        push dx;
        push ax;
        pop eax; conversie fara semn de la ax la eax := 91522FF2h
        
        mov [c], eax
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
