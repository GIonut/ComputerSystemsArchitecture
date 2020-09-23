bits 32 

global start        
extern function

extern exit, printf               
import exit msvcrt.dll
import printf msvcrt.dll
 
segment data use32 class=data public
    ; ...
    sir db 12,3,1,4,15,3,1,3,6,1,3,5, 113, 41, 17, 19, 6,0
    seqv resb $-sir
    begin dd 0
    len dd 0
    format db '%x ', 0

segment code use32 class=code public
    start:
        ; ...
        push dword sir
        call function
        
        mov dword [begin], eax
        mov dword [len], ebx
        
        mov esi, sir
        add esi, [begin]
        mov edi, seqv
        repeat:
            cmp dword[len], 0
            je endloop
            
            mov al, byte [esi]
            mov ah, 0 
            cwde
            push eax
            push dword format
            call [printf]
            add esp, 4*2
            
            movsb
            dec dword[len]
        jmp repeat
        endloop:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
