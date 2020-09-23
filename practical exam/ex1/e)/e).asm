bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fscanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db 'file.txt', 0
    access_mode db 'r', 0
    handle dd -1
    format db '%d', 0
    format_d db '%d ', 0
    number dd 0
    d db 1
    count db 1
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        
        add esp, 4*2
        
        mov dword [handle], eax
        cmp eax, 0
        je theend
        
        repeat:
        ;fscanf(handle, format, atributes)
        push dword number
        push dword format
        push dword [handle]
        call [fscanf]
        add esp, 4*3
        
        cmp eax, -1
        je EOF
        
        mov byte [count], 1 ; start counting the divisors
        mov byte [d], 2; start dividing by 2
        
        
        mov bx, word [number]
        shr bx, 1
        
        repeat1:
            mov ax, word [number] ; prepare the division
            mov dx, word [number+2]
            
            cmp byte [d], bl ; if d is greater than number/2 we stop searching divisors
            jg repeat
            
            div byte [d]; divide the number by d
            
            cmp ah, 0; if the rest is 0 than d is a divisor
            jne no_d
                ;if d is a divisor then print it
                mov al, byte [d]
                cbw
                cwd
                push eax
                push format_d
                call [printf]
                add esp, 4*2
            no_d:
            inc byte[d]
            jmp repeat1
            
        jmp repeat
        
        EOF:
        
        theend:
        push dword [handle]
        call [fclose]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
