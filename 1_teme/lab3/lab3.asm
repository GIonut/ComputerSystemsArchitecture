bits 32 ; assembling for the 32 bits architecture

;lab3.ex1: c+(a*a-b+7)/(2+a), a-byte; b-doubleword; c-qword unsigned

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 0ffh
    b dd 754h
    c dq 4838277829933h
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]; al := a := ffh
        mul byte [a]; ax := al*a := a*a := fe01h
        mov bx, ax; bx := ax := a*a := fe01h
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; bx := a*a ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        
        add bx, 7; bx := bx + 7 := a*a + 7 := fe08h
        mov cx, 0; unsigned conversion from bx to cx:bx := 0000fe08h
        sub bx, word[b] ;
        sbb bx, word[b+2]; cx:bx := cx:bx - b := 0000fe08h - 754h := 0000f6b4h
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; cx:bx := a*a - b + 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        
        
        mov al, [a]; bl := a := ffh
        mov ah, 0; unsigned conversion from al to ax := 00ffh
        add al, 2;
        adc ah, 0; ax := a+2 := 0101h
        mov dx, ax; dx := ax := 0101h
        mov ax, bx;
        mov bx, dx; bx := 0101h
        mov dx, cx; dx:ax := cx:bx := 0000f6b4h
        div bx; ax := dx:ax/bx := 0000f6b4h/0101h := 00f5h , dx := 00bfh
        mov dx, 0; unsigned conversion from ax to dx:ax := 00f5h
        push dx
        push ax
        pop ebx;
        mov ecx, 0; unsigned conversion from ebx to ecx:ebx
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ecx:ebx := (a*a - b + 7)/(a+2) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        
        mov eax, [c]
        mov edx, [c+4]; edx:eax := c 
        add eax, ebx;
        adc edx, ecx; edx:eax := edx:eax + ecx:ebx := c + (a*a - b +7)/(a+2) := 4 8382 7782 9A28‬h


        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
