bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
extern function
; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sir dd 12, 13, 76, 56, 32, 44
    len equ $-sir
    sums resb len+4
    format db '%d ',0
    newline db 10,13,0
    saveEax dd 0
    lenvar dd len/4
; our code starts here
segment code use32 class=code public
    start:
        ; ...
        push dword len
        push dword sir
        push dword sums
        ;push dword here
        ;jmp function
        call function
        ;here:
        mov dword[sums+len], 0
        mov eax, 0
        repeat:
            cmp dword[lenvar], 0
            je endloop
            mov eax, [saveEax]
            mov ebx, [sums + eax]
            mov ecx, [sums + eax + 4]
            cmp ebx, ecx
            jb ascending
                push dword[eax + sir]
                push dword format
                call [printf]
                
                add esp, 4*2
                
                push dword newline
                call [printf]
                
                add esp, 4
                add dword [saveEax], 4
                sub dword[lenvar], 1
                jmp repeat
            ascending:
                push dword[eax+sir]
                push dword format
                call [printf]
                
                add esp, 4*2
              
                add dword[saveEax], 4
        sub dword[lenvar], 1
        jmp repeat
        endloop:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
