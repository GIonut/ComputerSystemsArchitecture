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
    file_name db 'palindrom.txt', 0
    access_mode db 'r', 0
    format db '%d', 0
    format_space db '%d ', 0
    handle dd -1
    number dd 0
    saveNumber dd 0
    inverse dw 0
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
        
        repeat:
        push dword number
        push dword format
        push dword [handle]
        call [fscanf]
        add esp, 4*3
        
        cmp eax, -1
        je EOF
        
        mov word [inverse], 0
        mov eax, [number]
        mov [saveNumber], eax
        
        repeat1:
        mov ax, word [number]
        cmp ax, 0
        je outofrepeat1
        mov cl, 10
        div cl
        mov bh, ah
        mov ah, 0
        mov word[number], ax
        mov ax, [inverse]
        mov cl, 10
        mul cl
        add al, bh
        adc ah, 0
        mov [inverse], ax
        jmp repeat1
        outofrepeat1:
        
        mov ax, [inverse]
        cmp ax, word[saveNumber]
        jne repeat
            push dword [saveNumber]
            push dword format_space
            call [printf]
        jmp repeat
        
        EOF:
        
        theend:
        push dword [handle]
        call [fclose]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
