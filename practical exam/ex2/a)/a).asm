bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, scanf, fwrite               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fwrite msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file db 'input.txt', 0
    output_file db 'output.txt', 0
    mode_read db 'r', 0
    mode_write db 'w', 0
    format_character db '%c', 0
    handleI dd -1
    handleO dd -1
    character db 0
    char db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;fopen(file_name, access_mode)
        push dword mode_read
        push dword input_file
        call [fopen]
        
        add esp, 4*2
        
        mov dword [handleI], eax
        cmp eax, 0
        je theend
        
        push dword mode_write
        push dword output_file
        call [fopen]
        add esp, 4*2
        
        mov dword [handleO], eax
        cmp eax, 0
        je theend
        
        ;int scanf(const char * format, adresa_variabila_1, ...);
        push dword character
        push dword format_character
        call [scanf]
        
        add esp, 4*2
        
        repeat:
        ;fread(void * buffer, int size, int count, FILE * stream)
            push dword [handleI]
            push dword 1
            push dword 1
            push dword char
            call [fread]
            add esp, 4*4
        
            cmp eax, 1
            jl EOF
        
            mov al, byte [character]
            cmp al, byte [char]
            jne continue
                
               mov byte [char], 'x'
               
            continue:
            sub al, 32
            cmp al, byte [char]
            jne continue1
                
               mov byte [char], 'X'
               
            continue1:
            ;int fwrite(void buffer, int size, int count, FILE stream );
            push dword [handleO]
            push dword 1
            push dword 1
            push dword char
            call [fwrite]
            
            add esp, 4*4
   
        jmp repeat
        EOF:
        
        theend:
        ;fclose(handle)
        push dword [handleI]
        call [fclose]
        add esp, 4
        
        push dword [handleO]
        call [fclose]
        add esp, 4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
