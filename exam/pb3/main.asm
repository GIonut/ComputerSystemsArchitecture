bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
extern sumOfDigits
; declare external functions needed by our program
extern exit, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
   N dd 0
   format db '%d', 0
   nr dd 0
   sir resd 10
   sums resb 10
   saveEcx dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword N
        push dword format
        call [scanf]
        add esp, 4*2
        
        mov ecx, [N]
        mov [saveEcx], ecx
        mov edi, sir
        mov esi, sums
        repeat:
            cmp dword[saveEcx], 0
            je outOfLoop
            push dword edi
            push dword format
            call [scanf]
            
            add esp, 4*2
            
            push dword [edi]
            ;push dword here
            ;jmp sumOfDigits
            call sumOfDigits
            ;here:
            add edi, 4
            mov [esi], bl
            add esi, 1
            sub dword[saveEcx], 1
        jmp repeat
        outOfLoop:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
