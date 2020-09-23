bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; Read contents from a file until there's nothing left and print it on the console

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fscanf, fclose
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fclose msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    f_name db "tema1.txt", 0
    handle dd -1
    f_acces db "r", 0
    format db "Numarul de cifre pare este: %d", 0
    format_2 db "%d", 0
    contor dd 0
    a dd 0
; our code starts here
segment code use32 class=code
    start:
    ;deschid fisierul
        push dword f_acces
        push dword f_name
        call [fopen]
        add esp, 4*2

        mov [handle], eax

        cmp eax, 0
        je final
        ;citim din fisier
     reading:
        push dword a
        push dword format_2
        push dword[handle]
        call [fscanf]
        
        add esp,4*3
        
        cmp eax,-1
        je eof
        mov eax,[a]
        and eax,01h;verif daca e par
        cmp eax,0
        jne impar
        inc dword[contor]
        impar:
        jmp reading
        eof:
        ;afisare
        push dword[contor]
        push format_2
        call [printf]
        add esp,4*2
        ;inchidere fisier
        push dword[handle]
        call [fclose]
        add esp,4*1
  
        final:
  
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program