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
    number dd 0
    format_number db '%d', 0
    count dd 0
    format db '%d ', 0
    sequence times 100 db 0
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
           
           mov edi, sequence
            ;fscanf(file_handle, format, atributes)
            repeat:
                push dword number
                push dword format_number
                push dword [handle]
                call [fscanf]
                add esp, 4*3
                
                cmp eax, -1
                je EOF
                
                inc byte [count]
                mov eax, dword [number]
                stosd
                
            jmp repeat

            EOF:
            mov dx, 1
            repeat1:
                cmp dx, 0
                je print_sequence
                
                mov dx, 0
                mov esi, sequence
                mov ecx, dword [count]
                sub ecx, 1
                repeat2:
                mov eax, dword [esi]
                cmp eax, dword [esi+4]; compare sequence[i] and sequence[i+1]
                jle next
                    mov ebx, dword [esi+4]
                    mov dword [esi+4], eax
                    mov dword [esi], ebx
                    mov dx, 1
                next:
                add esi, 4
                loop repeat2
            jmp repeat1
            
            print_sequence:
            mov esi, sequence
            repeat3:
                cmp dword [count], 0
                je theend
                
                lodsd
                push eax
                push dword format
                call [printf]
                add esp, 4*2
                
                dec dword [count]
                
            jmp repeat3
            
            theend:
            push dword [handle]
            call [fclose]
            add esp, 4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
