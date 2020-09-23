bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;PROBLEM STATEMENT
;An unsigned number a on 32 bits is given. Print the hexadecimal representation of a, but also the results of the circular ;permutations of its hex digits.

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 12345
    x times 8 db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword [a]
        push dword 0
        to16:
            mov ax, [esp+4] ; punem in dx:ax numarul transmis ca parametru
            mov dx, [esp+6]
            mov ecx, 0
            .repeat:
                mov bx, 16
                div bx; impartim succesiv numarul la 16 eax/bx => dx:=eax%bx  ax = eax/bx
                cmp dx, 10
                jb .notletter
                    sub dx, 16; daca restul e mai mare ca 9 atunci pregatim transformarea in litera mare ex: 'A' = '0'- 16 etc
                .notletter:
                    add dx, '0'; transformam restul in caracter
                push dx ; punem pe stiva restul, un word, ca mai apoi sa il putem lua in ordine inversa
                mov dx, 0
                inc ecx
            cmp ax, 0
            ja .repeat
            
        cld 
        mov edi, x
        
        .repeat1:
            pop ax
            stosb
        loop .repeat1
        
        push dword [x]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
