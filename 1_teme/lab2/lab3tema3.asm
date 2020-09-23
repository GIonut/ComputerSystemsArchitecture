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
    ;x+a/b+c*d-b/c+e = ; a,b,d-byte; c-word; e-doubleword; x-qword ; all unsigned
    a db 0efh
    b db 12h
    c dw 42h
    d db 9ah
    e dd 992c5h
    x dq 3aaaaaabh
; our code starts here
segment code use32 class=code
    start:
        ; ...
       mov al, [a]; al := a
       mov ah, 0; unsigned conversion from al to ax := a
       div byte [b]; al := ax / b = a / b  ah := ax % b 
       mov bl, al; bl := al = a / b
       
    ;************************************************ bl := a / b ***********************************************************   
       
       mov al, [b]; al := b
       mov ah, 0; unsigned conversion from al to ax := b
       mov dx, 0;unsigned conversion from ax to dx:ax := a
       div word [c]; ax := dx:ax / c = b / c  dx := dx:ax % c
       
    ;************************************************  ax := b / c *********************************************************    
       
       mov bh, 0; unsigned conversion from bl to bx := a/b
       mov cx, 0; unsigned conversion from bx to cx:bx := a/b
       mov dx, 0; unsigned conversion from ax to dx:ax := b/c
       sub bx, ax; bx := bx - ax      } => cx:bx := cx:bx - dx:ax = a/b - b/c
       sbb cx, dx; cx := cx - dx - cf }
       
    ;************************************************ cx:bx := a/b - b/c ***************************************************    
       
       mov al, [d]; al := d
       mov ah, 0; unsigned conversion from al to ax := d
       mul word [c]; dx:ax := c*d
       
    ;************************************************ dx:ax := c*d *********************************************************    
      
       add bx, ax; bx := bx + ax      } => cx:bx := cx:bx + dx:ax = a/b + c*d - b/c 
       adc cx, dx; cx := cx + dx + cf }
       
    ;************************************************ cx:bx := a/b + c*d - b/c *********************************************    
      
       add bx, [e]; add to bx the word starting at the adress e
       adc cx, [e+2]; add with carry flag the word starting at the adress e + 2 
       push cx
       push bx
       pop ebx
       mov ecx, 0; unsigned conversion from ebx to ecx:ebx
       
    ;************************************************ ebx := a/b + c*d - b/c + e *******************************************    
    
        mov eax, [x]; moves in eax the dword starting at the adress pointed by [x]
        mov edx, [x+4]; moves in edx the dword starting at the adress pointed by [x+4]
        add eax, ebx; eax := eax + ebx      } => edx:eax := edx:eax + ecx:ebx 
        adc edx, ecx; edx := edx + ecx + cf }
        
    ;****************************************** edx:eax := x + a/b + c*d - b/c + e *****************************************    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
