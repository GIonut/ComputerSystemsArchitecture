bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;Exercice 30
;given the word A, obtain the doubleword B as follows:
;the bits 0-3 of B are the same as the bits 1-4 of the result A XOR 0Ah
;the bits 4-11 of B are the same as the bits 7-14 of A
;the bits 12-19 of B have the value 0
;the bits 20-25 of B have the value 1
;the bits 26-31 of C are the same as the bits 3-8 of A complemented

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    A dw 1001101001010110b ; 9A56
    B dd 00000000000000000000000000000000b
; our code starts here
segment code use32 class=code
    start:
        ; ...
    ;the bits 0-3 of B are the same as the bits 1-4 of the result A XOR 0Ah    
        MOV AX, [A];  1001101001010110b xor
        XOR AX, 0AH;0000000000001010b
                   ;1001101001011100b= 9A5Ch
        AND AX, 0000000000011110B; ax := 0000000000011100b := 001Ch
        SHR AX, 1; ax := 0000000000001110b : 000Eh
        
        MOV BX, 0
        OR BX, AX; bx := 0000000000001110b = 000Eh
    
    ;the bits 4-11 of B are the same as the bits 7-14 of A    
        MOV AX, [A]
        AND AX, 0111111110000000B
        ROR AX, 2
        
        OR BX, AX; bx := 0001101000001010b
    
    ;the bits 12-19 of B have the value 0
        MOV CX, 0;
        MOV AX, 1111000000000000B
        
        OR BX, AX

        MOV AX, 0000000000001111B
        
        OR CX, AX; 00000000000000000001101000001010B
     
    ;the bits 20-25 of B have the value 1 
        MOV AX, 0000001111110000B
        
        OR CX, AX; 00000011111100000001101000001010B
        
    ;the bits 26-31 of C are the same as the bits 3-8 of A complemented
        MOV AX, [A]
        NEG AX
        AND AX, 0000000111111000B
        ROL AX, 7
        
        OR CX, AX; 11010111111100000001101000001010B = D7F01A0AH
        
     MOV WORD [B], WORD BX
     MOV WORD [B+2], WORD CX
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
