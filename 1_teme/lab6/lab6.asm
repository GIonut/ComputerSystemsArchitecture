bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;ex12:
;Given an array A of doublewords, build two arrays of bytes:  
; - array B1 contains as elements the lower part of the lower words from A
; - array B2 contains as elements the higher part of the higher words from A

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    A dd 11223344h, 44332211h, 11224433h, 2233h
    len equ $-A 
    B1 times len/4 db 0
    B2 times len/4 db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        cld; df = 0
        mov esi, A
        mov edi, B1
        mov ecx, len/4; we parse the loop len/4 times because len is the length of a string of doublewords 
        repeat:
            lodsw; The word starting from the address ESI is loaded in AX; DF=0 then ESI:=ESI+2
            and ax, 0000000011111111b; we get the lower part
            stosb; Store AL into the byte from the address EDI, so from B1; DF=0 then EDI:=EDI+1
            lodsw; we skip the higher part of the doubleword; DF=0 then ESI:=ESI+2
        loop repeat
        
        cld
        mov esi, A
        mov edi, B2
        mov ecx, len/4
        repeat1:
            lodsw;we skip the lower part of the doubleword; DF=0 then ESI:=ESI+2
            lodsw;The word starting from the address ESI is loaded in AX; DF=0 then ESI:=ESI+2
            and ax, 1111111100000000b; we get the higher part of the doubleword
            ror ax, 8; we get in AL the higher part of the higher word of the doubleword
            stosb; Store AL into the byte from the address EDI, so from B1; DF=0 then EDI:=EDI+1
        loop repeat1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
