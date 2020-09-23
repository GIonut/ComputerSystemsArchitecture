bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;4) Scrieti un program asm care citeste de la tastatura  un sir de maxim 10
;caractere de la tastatura, dupa care se vor citi numere intregi de la
;tastatura pana la introducerea numarului 0. Numerele citite de la tastatura
;se vor scrie in baza 16, pe cate o linie intr-un fisier avand numele identic
;cu sirul de caractere citit la inceputul programului.


; declare external functions needed by our program
extern exit, fopen, fclose, fprintf, scanf                ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    outpfile times 11 db  0
    modwrite db 'w', 0
    handle dd -1
    nr dd 0
    formats db '%s', 0
    formatd db '%d', 0
    formatx db '%x %c', 0
    formatc db '%c', 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; scanf(format, adress)
        push dword outpfile
        push dword formats
        call [scanf]
        
        add esp, 4*2
        
        mov [outpfile+10], byte 0
        
        ; fopen(file, mode)
        push dword modwrite
        push dword outpfile
        call [fopen]
        
        add esp, 4*2
        mov [handle], eax
        
        cmp eax, 0
        je theend
        
        repeat:
            ; scanf(format, adress)
            push dword nr
            push dword formatd
            call [scanf]
            
            add esp, 4*2
            
            cmp [nr], dword 0   
            je theend
            
            ; fprintf(file, format, adress)
            push dword 10
            push dword [nr]
            push dword formatx
            push dword [handle]
            call [fprintf]
            
            add esp, 4*4
         jmp repeat 

         theend:
            push dword [handle]
            call [fclose]
            
            add esp, 4*1
            
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
