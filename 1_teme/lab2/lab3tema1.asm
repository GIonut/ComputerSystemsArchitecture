bits 32 ; assembling for the 32 bits architecture

;(a+b)-(a+d)+(c-a) where a - byte, b - word, c - double word, d - qword - Unsigned representation

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 2h
    b dw 0ffh
    c dd 100h
    d dq 115h
    ;(a+b)-(a+d)+(c-a)= E8
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov bl, [a]; bl := a
        mov bh, 0; conv fara semn de la bl la bx := a
        mov cx, 0; conv fara semn de la bx la cx:bx := a
        
        mov ax, word [c] ;
        mov dx, word [c+2] ; dx:ax := c
        
        sub ax, bx; ax := ax - bx
        sbb dx, cx ; dx := dx - cx - cf
        
    ;*********************************************** dx:ax := c - a ************************************************************
        
        push dx
        push ax
        pop eax ; eax := c - a
        
        mov bl, [a] ; bl := a
        mov bh, 0 ; bx := a
        
        mov cl, byte [b]
        mov ch, byte [b + 1]; cx := b
        
        add bl, cl ; bl := bl + cl      }=> bx := a + b
        adc bh, ch ; bh := bh + ch + cf }
        
    ;************************************************** bx := a + b ***********************************************************
        
        mov cx, 0 ; conversie fara semn de la bx la cx:bx
        add ax, bx; ax := ax + bx
        adc dx, cx; dx := dx + cx + cf
        
        push dx
        push ax
        pop eax; eax := dx:ax + cx:bx := (c-a) + (a+b) = (a+b) + (c-a)
    
    ;*************************************************** cx:bx := (a + b) + (c - a) ********************************************
        
        mov bl, [a]; al := a
        mov bh, 0; conversie fara semn de la bl la bx:=a
        mov cx, 0; conversie fara semn de la bx la cx:bx:=a
        
        push cx
        push bx
        pop ebx ; ebx:=a
        
        mov ecx, 0; conversie fara semn de la ebx la ecx:ebx
        
        add ebx, dword [d]; 
        adc ecx, dword [d+4]; ecx:ebx:=a+d
        
        mov edx, 0; conversie fara semn de la eax la edx:eax:=(a+b)+(c-a)
        sub eax, ebx
        sbb edx, ecx ; edx:eax:=(a+b)-(a+d)+(c-a)
        
    ;********************************************* edx:eax:=(a+b)-(a+d)+(c-a) **************************************************
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
