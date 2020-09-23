bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fscanf, fprintf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file db 'input file.txt', 0
    output_file db 'output file.txt', 0
    mode_read db 'r', 0
    mode_write db 'w', 0
    handle1 dd -1
    handle2 dd -1
    format_numbers db '%d', 0
    format_string db '%s ', 10, 13, 0
    count dd 0
    nr dd 0
    number times 17 db 0
    number2 times 17 db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;fopen(file_name, access_mode)
        push dword mode_read
        push dword input_file
        call [fopen]
        
        add esp, 4*2
        cmp eax, 0
        je theend
        mov [handle1], eax 
        
        push dword mode_write
        push dword output_file
        call [fopen]
        
        add esp, 4*2
        cmp eax, 0
        je theend
        mov [handle2], eax
        
        repeat:
            ; fscanf(file_handle, format, atribute)
            push dword nr
            push dword format_numbers
            push dword [handle1]
            call [fscanf]
            
            add esp, 4*3
            
            cmp eax, -1
            je EOF
            
            cmp dword [nr], 0
            jne continue
                mov byte[number2], '0'
                mov byte[number2+1], 0
                jmp printare
            continue:
            mov edi, number
            mov ebx, dword [nr]
            repeat1:
                cmp ebx, 0
                je outrepeat1
               
                test ebx, 1
                jne odd
                    ;else even
                    mov al, '0'
                    stosb
                    jmp even
                odd:
                mov al, '1'
                stosb
                even:
                shr ebx, 1
                inc dword [count]
            jmp repeat1
            
            outrepeat1:
            mov al, 0
            stosb
            lea esi, [edi-2]
            mov edi, number2
            
            
            mov ecx, [count]
            
            repeatecx:
            lodsb
            stosb
            sub esi, 2
            loop repeatecx
            
            
            mov al, 0
            stosb
            printare:
            push dword number2
            push dword format_string
            push dword [handle2]
            call [fprintf]
            add esp, 4*3
        jmp repeat
            
        EOF:
        push dword [handle1]
        call [fclose]
        
        push dword [handle2]
        call [fclose]
        theend:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
