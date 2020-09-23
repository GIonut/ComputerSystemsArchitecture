bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;3) Se da un fisier txt cu continut variabli (fisierul poate contine orice si
;oricat). Scrieti in program asm care citeste fisierul dat pe bucati a cate
;10 octeti si il afiseaza pe ecran.



; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    inpfile db 'pb3.txt', 0
    modread db 'r', 0
    handle dd -1
    format db '%s%c', 0
    nr times 10 db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword modread
        push dword inpfile
        call [fopen]
        
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        repeat:
            push dword [handle]
            push dword 1
            push dword 10
            push dword nr
            call [fread]
            
            cmp eax, 0
            je theend
            
            push dword 10
            push dword nr
            push dword format
            call [printf]
            
            add esp, 4*3
        jmp repeat
        
        theend:
        
            
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
