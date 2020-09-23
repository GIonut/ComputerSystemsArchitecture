bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, strlen, fprintf, fscanf, fopen, fclose, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import strlen msvcrt.dll
import fprintf msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db 'input.txt', 0
    output_file db 'output.txt', 0
    access_mode db 'r', 0
    mode_write db 'w', 0
    format db '%s', 0
    format_print db '%s ', 0
    handle dd -1
    handle2 dd -1
    len dd 0
    string times 10 db 0
    inverse times 10 db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword access_mode
        push dword file_name
        call [fopen]
        
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        push dword mode_write
        push dword output_file
        call [fopen]
        add esp, 4*2
        
        mov [handle2], eax
        cmp eax, 0
        je theend
        
        repeat:
            push dword string
            push dword format
            push dword [handle]
            call [fscanf]
            add esp, 4*3
            
            cmp eax, -1
            je EOF
            
            push dword string
            call [strlen]
            mov dword [len], eax
            mov ecx, eax
            
            cmp byte [string], 'Z'
            jg notfirstword
            
            cmp byte [string], 10
            je notlastword
            
            mov byte [inverse+ecx], 0
            mov byte [string+ecx], 0
            mov edi, inverse
            mov esi, string

                repeat1:
                    mov al, byte [esi+ecx-1]
                    stosb
                    loop repeat1
                    
                mov esi, inverse
                mov edi, string
                mov ecx, [len]
                repnz movsb
            notfirstword:
          
            mov esi, string
            cmp byte [esi+ecx-1], '.'
            jne notlastword
            
                mov byte [inverse+ecx], 0
                mov byte [string+ecx], 0
                mov edi, inverse
                
                sub ecx, 1
                
                repeat2:
                    mov al, byte [esi+ecx-1]
                    stosb
                    loop repeat2
                mov byte [edi], '.'
                mov esi, inverse
                mov edi, string
                mov ecx, [len]
                add ecx, 1
                repnz movsb
                
            notlastword:
            
            push dword string
            push dword format_print
            push dword [handle2]
            call [fprintf]
            
            jmp repeat
            EOF:
            
            theend:
            push dword [handle]
            call [fclose]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program