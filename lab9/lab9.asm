bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fprintf, fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    outputfile db 'num.txt',0
    modwrite db 'w',0
    handle dd -1
    comp dd 0
    keyword db '~', 0
    message db "sir=",0
    format db "%s",0
    sumformat db "sum=%d",0
    intformat db "%d",0
    fileformat db '%s ' , 0
    n times 11 db 0
    sum dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword modwrite
        push dword outputfile
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
        beg:
            push dword message
            call [printf]       
            add esp, 4*1
            
            push dword n
            push dword format   ; read a message from keyboard
            call [scanf]
            add esp, 4*2
           
            mov bx, [n]
            cmp bx, word '~'  ;if the message is ~ then we are done
            je end
            noteq: ; else:
                cld
                mov esi, n
                mov ecx, 10 ; parse the string of 10 characters and 0
                mov edx, 0
                repeat1:
                    lodsb
                    cmp al, 0
                    je suma
                    cmp al, '0'
                    jl file     
                    cmp al, '9'
                    jg file     ; if it contains non-numerical values we print it in the created file num.txt
                    mov bl, al
                    sub bl, '0'
                    mov eax, edx
                    mov dx, 10
                    mul dx 
                    mov edx, eax
                    mov al, bl
                    cbw
                    cwde
                    add edx, eax  ;else convert the string in an integer 
                loop repeat1
            suma:
            add [sum], dx ; and add it to a sum
        jmp beg    
            file:
                push dword n
                push dword fileformat
                push dword [handle]
                call [fprintf]
                add esp, 4*3
                
                cmp eax, 0
                je error
        jmp beg
       end:
       push dword [sum]
       push dword sumformat
       call [printf]
       add esp, 4*2
       error:
            push dword [handle]
            call [fclose]
            add esp, 4*1
            
            cmp eax, 0
            je theend
        theend:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
