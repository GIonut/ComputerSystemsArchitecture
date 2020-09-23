bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 8374
    b dd 63
    quotient dw 0 ; 132
    remainder dw 0; 58
    formatq db 'Quotient = %d %c', 0
    formatr db 'remainder = %d', 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [a]
        cdq                 ; convert doubleword [a] to quadword preparing it for division whit a doubleword
        idiv dword [b]      ; sign division edx:eax / [b] => ax:=quotient; dx:=remainder 
        
        mov [quotient], ax  ; save ax in the adress pointed by quotient lable
        mov [remainder], dx ;   save dx in the adress pointed by remainder label
                            
                            ; printf( "Quotient = %d %c", eax, 10)
        mov ax, [quotient]  ; ax gets the value pointed in memory by the lable quotient
        cwde                ; convert ax (quotient) from word to doubleword in order 
                            ; to use it as a parameter for printf function  so ax -> eax
        push dword 10       ; last parameter for printf function is character 10 ascii for LF-newline
        push dword eax      ; second parameter from right to left for printf function is the value of the quotient (doubleword)
        push dword formatq  ; first parameter for printf function is the formatq
        call [printf]       ; call the function
        add esp, 4*3        ; free the stack of the function's parameters(3)
        
        mov ax, [remainder] ;ax gets the value pointed in memory by the lable remainder
        cwde                ; convert ax (remainder) from word to doubleword in order 
        
                            ; printf("remainder = %d", eax)
        push dword eax      ; last parameter from right to left for printf function is the value of the remainder (doubleword)
        push dword formatr  ; first parameter for printf function is the formatr
        call [printf]       ; call the function
        add esp, 4*2        ; free the stack of the function's parameters(2)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
