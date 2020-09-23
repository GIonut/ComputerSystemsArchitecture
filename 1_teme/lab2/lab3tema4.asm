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
 ;x+a/b+c*d-b/c+e = 3AB4 2324‬ ; a,b,d-byte; c-word; e-doubleword; x-qword ; all signed
    a db 0efh; 1110 1111 = -17 = ffefh
    b db 12h
    c dw 42h
    d db 9ah; 1001 1010 = -102 = ff9ah
    e dd 992c5h
    x dq 3aaaaaabh
; our code starts here
segment code use32 class=code
    start:
        ; ...
       mov al, [a]; al := a
       cbw; signed conversion from al to ax := a
       idiv byte [b]; al := ax / b = a / b  ah := ax % b 
       cbw; signed conversion from al to ax := a
       mov bx, ax; bx := ax = a / b
       
    ;************************************************ bx := a / b ***********************************************************   
       
       mov al, [b]; al := b
       cbw; signed conversion from al to ax := b
       cwd; signed conversion from ax to dx:ax := a
       idiv word [c]; ax := dx:ax / c = b / c  dx := dx:ax % c
       cwd; signed conversion from ax to dx:ax := b/c
       
    ;************************************************  dx:ax := b / c ******************************************************    
       
       mov cx, ax; cx := ax 
       mov ax, bx; ax := bx = a/b
       mov bx, cx; bx := cx } => cx:bx := b/c
       mov cx, dx; cx := dx }
       cwd; signed conversion from ax to dx:ax := a/b
       sub ax, bx; ax := ax - bx      } => dx:ax := dx:ax - cx:bx = a/b - b/c
       sbb dx, cx; dx := dx - cx - cf }
       mov bx, ax;
       mov cx, dx;
       
    ;************************************************ cx:bx := a/b - b/c ***************************************************    
       
       mov al, [d]; al := d
       cbw; signed conversion from al to ax := d
       imul word [c]; dx:ax := c*d
       
    ;************************************************ dx:ax := c*d *********************************************************    
      
       add ax, bx; ax := ax + bx      } => dx:ax := dx:ax + cx:bx = a/b + c*d - b/c 
       adc dx, cx; dx := dx + cx + cf }
       
       
    ;************************************************ dx:ax := a/b + c*d - b/c *********************************************    
      
       add ax, [e]; add to bx the word starting at the adress e
       adc dx, [e+2]; add with carry flag the word starting at the adress e + 2 
       push dx
       push ax
       pop eax
       cdq; unsigned conversion from eax to edx:eax
       
    ;********************************************* edx:eax := a/b + c*d - b/c + e ******************************************    
    
        add eax, [x]; adds in eax the dword starting at the adress pointed by [x]
        adc edx, [x+4]; adds in edx the dword starting at the adress pointed by [x+4]
    
    ;****************************************** edx:eax := x + a/b + c*d - b/c + e *****************************************    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
