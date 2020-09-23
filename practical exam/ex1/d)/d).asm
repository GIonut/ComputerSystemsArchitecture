bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fscanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
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
    format db '%d ', 0
    sequence times 100 db 0
    start_pos dd sequence
    maxstart dd 0
    len dd 0
    maxlen dd 0
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
        
        mov edi, sequence
        repeat:
        ;fscanf(handle, format, atributes)
        push dword number
        push dword format_number
        push dword [handle]
        call [fscanf]
        add esp, 4*3
        
        cmp eax, -1
        je EOF
        
        test dword [number], 1
        je it_is_even
            ;it_is_odd
            mov eax, dword [len]
            cmp dword [maxlen],eax ;  check if the length of a sequence is bigger than the max sequence
            jge continue
                mov [maxlen], eax ; if so, we save it as the maximum sequence
                mov eax, edi
                sub eax, dword [len]
                mov dword [maxstart], eax ; we save the starting point of the maximum sequence
                
                mov dword [start_pos], edi; and return to the adress of the current number, which is odd
                mov dword [len], 0 ; looking for another sequence of even numbers, and start with len = 0
                jmp continue
        it_is_even:
            add dword [len], 4 ; if the number is even we increase the length of a sequence with the length of a doubleword
            continue:
            mov eax, dword[number] ; finaly we copy the sequence of numbers from the file into the memory
            stosd
        jmp repeat
        EOF:
        
            mov eax, dword [len]
            cmp dword [maxlen],eax ;  check if the length of a sequence is bigger than the max sequence
            jge continue1
                mov [maxlen], eax ; if so, we save it as the maximum sequence
                mov eax, edi
                sub eax, dword [len]
                mov dword [maxstart], eax ; we save the starting point of the maximum sequence
        continue1:
        
        
        
        
        mov esi, [maxstart]
        repeat1:
            lodsd
            push dword eax
            push dword format
            call [printf]
            add esp, 4*2
            
            sub dword [maxlen], 4
            ;add dword [maxstart], 4
            
        cmp dword [maxlen], 0
        jne repeat1
        theend:
        
        push dword [handle]
        call [fclose]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
