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
    ;a - byte, b - word, c - double word, d - qword - Signed representation
    ; c-(d+a)+(b+c) = 34h - (92873h + 23h) + ( 123h + 34h) = 34h - 92896h + 157h = fff6d8f5h
    a db 23h
    b dw 123h
    c dd 34h
    d dq 92873h
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, [b]; bx := b
        cwd ; signed conversion from ax to dx:ax => dx:ax := b
        mov bx, [c]; move a word starting from the adress pointing by [c] in bx
        mov cx, [c+2] ; move a word starting from the adress pointing by [c+2] in cx  => bx:cx := c
        add bx, ax; bx := bx + ax     } => cx:bx := bx + ax = b + c
        adc cx, dx; cx := cx + dx +cf }
        push cx
        push bx
        pop ebx ; ebx := cx:bx := b + c 
        mov eax, ebx ;eax := ebx = b + c
        cdq; signed conversion from eax to edx:eax => edx:eax := b+c
        mov ebx, eax ;}-> ecx:ebx := edx:eax = b + c
        mov ecx, edx ;}
        
    ; ************************************************* ecx:ebx := b + c *******************************************************
        
        mov eax, [c]; eax := c
        cdq ; signed conversion from eax to edx:eax => edx:eax := c
        add ebx, eax; ebx := ebx + eax
        adc ecx, edx; ebx:ecx := c+(b+c)
    
    ;************************************************ ebx:ecx := c+(b+c) ***************************************************

        mov al, [a]; al := a
        cbw ; signed conversion from al to ax => ax := a
        cwde ; signed conversion from ax to eax => eax := a
        mov ecx, [d]; move a dword starting from the adress pointing by [d] in ecx
        mov edx, [d+4]; move a dword starting from the adress pointing by [d+4] in edx
        add eax, ecx; eax := eax + ecx  } => edx:eax := d + a
        adc edx, 0; edx := edx + 0 + cf }
    
    ;*********************************************** edx:eax := d + a **********************************************************
        
        sub ebx, eax ; ebx := ebx - eax }=> ecx:ebx := ecx:ebx - edx:eax = c-(d+a)+(b+c)
        sbb ecx, edx ; ecx := ecx - edx }
        mov edx, ecx; move the result in edx:eax
        mov eax, ebx;
        
    ;************************************************ edx:eax := c-(d+a)+(b+c) *************************************************
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
