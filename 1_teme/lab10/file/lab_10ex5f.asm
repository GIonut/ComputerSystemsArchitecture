bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;A text file is given. Read the content of the file, count the number of special characters and display the result on the ;screen. The name of text file is defined in the data segment.;

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
    inputfile db 'a.txt', 0
    modread db 'r', 0
    handle dd -1
    format db 'numOfSpecChar = %d', 0
    char db '', 0
    count db 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword modread
        push dword inputfile
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        repeat:
            push dword [handle]
            push dword 1
            push dword 1
            push dword char
            call [fread]
            add esp, 4*4
        
            cmp eax, 0
            je endOfFile
            
            mov al, [char]
            
            cmp al, '0'
            jl notdigit
            cmp al, '9'
            jle repeat
            
            notdigit:
            cmp al, 'A'
            jl notucase
            cmp al, 'Z'
            jle repeat
            
            notucase:
            cmp al, 'a'
            jl notlcase
            cmp al, 'z'
            jle repeat
            
            notlcase:
            
            inc byte [count]
            
        jmp repeat
        
        endOfFile:
        
        push dword [count]
        push dword format
        call [printf]
        add esp, 4*2
        
        push dword [handle]
        call [fclose]
        add esp, 4*1
        
        
        theend:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
