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
    ;a,b,c - byte, d - word     –a*a + 2*(b-1) – d = -6*6 + 2*(4-1) - 12 = -36 + 6 - 15 = FFC2h
    a db 6h
    b db 4h
    c db 2h
    d dw 20h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [b]; al := b
        dec al; al := al - 1
        mov bl, 2
        mul byte bl ; ax := al * 2 = 2*(b-1)
        mov bx, ax; bx := ax
        
    ;************************************************* bx := 2*(b-1) ***********************************************************
        
        mov al, 0; al := 0
        sub al, [a]; al := -a
        imul byte [a]; ax := al*a = -a*a
    
    ;*************************************************** ax := -a*a ************************************************************
        
        cwd ; sign conversion from word to dw
        add ax, bx; ax := bx
        adc dx, 0;
    
    ;******************************************** ax := ax + bx := -a*a + 2*(b-1) **********************************************
        
        sub ax, [d]
        
    ;****************************************** ax := -a*a + 2*(b-1) - d *******************************************************
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
