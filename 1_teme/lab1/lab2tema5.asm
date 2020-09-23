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
    ;a,b,c,d-byte, e,f,g,h-word  (a-c)*3+b*b = (122h-84h)*3 + 8*8  = 100
    a db 50h
    b db 8h
    c db 10h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]; al := a
        sub al, [c]; al := al - c = a - c
    
    ;***************************************************** al := a - c *********************************************************
        
        mov bl, 3; bl := 3
        mul bl; ax := al * bl = (a - c)*3
        mov bx, ax; bx := ax 
        
    ;*************************************************** bx := (a - c)*3 *******************************************************
        
        mov al, [b]; al := b
        mul byte [b]; ax := al * b = b*b
    
    ;**************************************************** ax := b*b ************************************************************
        
        add ax, bx; ax := ax + bx = (a - c)*3 + b*b
        
    ;*********************************************** ax := (a - c)*3 + b*b *****************************************************
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
