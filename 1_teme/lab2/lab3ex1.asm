bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;a - byte, b - word, c - double word, d - qword - Unsigned representation
;c-(a+d)+(b+d) =  0000000000000134h
; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 23h
    b dw 123h
    c dd 34h
    d dq 92873h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov bx, [b]; bx := b
        mov cx, 0; unsigned conversion from bx to cx:bx
        push cx
        push bx
        pop ebx; unsigned conversion from cx:bx to ebx := b
        mov ecx, 0; unsigned conversion from ebx to ecx:ebx := b
        
        mov eax, dword [d]
        mov edx, dword [d+4]; edx:eax := d
        
        add ebx, eax;
        adc ecx, edx; ecx:ebx := b+d 
        
        
        mov eax, [c];
        mov edx, 0; unsigned conversion from eax to edx:eax
        
        add eax, ebx; 
        adc edx, ecx; edx:eax := c + (b+d)
        
        mov bl, [a];
        mov bh, 0; unsigned conversion from bl to bx
        mov cx, 0; unsigned conversion from bx to cx:bx
        
        push cx
        push bx
        pop ebx; unsigned conversion from cx:bx to ebx
        
        mov ecx, 0; unsigned conversion from ebx to ecx:ebx
        
        add ebx, dword [d]
        adc ecx, dword [d+4]; ecx:ebx := a + d
        
        sub eax, ebx;
        sbb edx, ecx; edx:eax := c - (a+d) + (b+d)
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
