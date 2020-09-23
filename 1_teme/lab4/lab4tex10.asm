bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start    
    
;Exercice 10
;Replace the bits 0-3 of the byte B by the bits 8-11 of the word A

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 0010110101101101b ;2D6Dh
    b db 11101101b ;6Dh
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, [a];                       0010110101101101b and 
        and ax, 0000111100000000b;         0000111100000000b
        ;                          0D00h = 0000110100000000b
        ;mov cl, 8
        ;ror ax, cl; 000Bh = 0000000000001011b
        
        mov bl, [b]
        and bl, 0f0h; 01101101b and 
                    ; 11110000b
              ; 60h = 01100000b
        or bl, ah;  01100000b or
                 ;  00001101b
        mov [b], bl;01101101b = 6Dh
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
