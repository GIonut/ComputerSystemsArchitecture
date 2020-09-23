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
    sum dd 0
    product dd 1
    max dd 0
    contor db 0
    max_positions times 10 db 0
    special_format db 'sum = %d' ,10, 13, 'product = %d', 10, 13, 'max = %d', 10, 13, 0
    format_sequence db '%d ', 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; fopen(file_name, access_mode)
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        ;fscanf(file_handle, format, atributes)
        repeat:
        push dword number
        push dword format_number
        push dword [handle]
        call [fscanf]
        add esp, 4*3
        
        cmp eax, -1
        je EOF
        
        inc byte [contor]
        mov eax, dword [number]
        add dword [sum], eax    ; add the current number to the sum
        
        mov eax, dword [product]
        imul dword [number]     ; sign multiplication of the product with the current number 
        mov dword [product], eax
        
        mov eax, dword [max]
        cmp dword [number], eax
        jl notMax
            cmp dword [number], eax
            jne notSameMax
                mov al, byte [contor]
                stosb
                jmp notMax
            notSameMax:
                mov edi, max_positions
                mov al, byte [contor]
                stosb
                mov eax, dword [number]
                mov dword [max], eax
        notMax:
        
        jmp repeat
        
        EOF:
        
        ;printf(format, atributes)/ printf(specila_format, sum, product, max)
        push dword [max]; sand parameters through value
        push dword [product]
        push dword [sum]
        push dword special_format; it's over a double word so we transfer it through reference
        call [printf]
        add esp, 4*4
        
        mov byte [edi+1], 0
        mov esi, max_positions
        repeat1:
            lodsb
            cmp al, 0
            je theend
            mov ah, 0
            push word 0
            push ax
            push dword format_sequence
            call [printf]
            add esp, 4*2
        jmp repeat1
        
        theend:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
