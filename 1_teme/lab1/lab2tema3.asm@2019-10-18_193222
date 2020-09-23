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
    ;a,b,c,d - word (b+b)-c-(a+d) = (fffh + fffh) - 1050h - (ffh + 1h) = 1ffeh - 1050h - 100h = eaeh
    a dw 0ffh
    b dw 0fffh
    c dw 1050h
    d dw 1h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov bx, [a]; bx := a
        mov cx, 0 ; simple conversion from bx to cx:bx
        add bx, [d]; bx := bx + d
        adc cx, 0; cx := cx + 0 + cf
        
    ;**************************************************** cx:bx := a + d *******************************************************
        
        mov ax, [b]; ax := b
        mov dx, 0; simple conversion from ax to dx:ax
        add ax, [b]; ax := ax + b
        adc dx, 0; dx:ax := b + b
        
    ;**************************************************** dx:ax := b + b *******************************************************
        
        sub ax, bx; ax := ax - bx
        sbb dx, cx; dx := dx - cx - cf
      
    ;************************************************ ax:dx := (b + b) - (a + d) ***********************************************
        
        mov bx, [c]; bx := c
        mov cx, 0; simple conversion from bx to cx:bx
        sub ax, bx;
        sbb dx, cx;
        
        push dx;
        push ax;
        pop eax;
        
    ;************************************************ eax := (b + b) - c - (a + d) *********************************************
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
