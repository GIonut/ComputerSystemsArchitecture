bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fopen, fclose, fread, fwrite               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fwrite msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    table db 'CDEFGHIJKLMNOPQRSTUVWXYZAB', 0
    file_name db 'input.txt', 0
    output_file db 'output.txt', 0
    mode_write db 'w', 0
    access_mode db 'r', 0
    handle dd -1
    handle1 dd -1
    character db 0
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
        
        mov [handle1], eax
        
        cmp eax, 0
        je theend
       
        
        repeat:
        push dword [handle]
        push dword 1
        push dword 1
        push dword character
        call [fread]
        
        cmp eax, 1
        jl theend
        mov al, byte [character]
        cmp al, 'A'
        jl no
        cmp al, 'Z'
        jg no
            mov ebx, table
            sub al, 'A'
            xlat  
        no:
        
        mov byte [character], al
        
        push dword [handle1]
        push dword 1
        push dword 1
        push dword character
        call [fwrite]
        jmp repeat
      
        theend:
        push dword [handle]
        call [fclose]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
