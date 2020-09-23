bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

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
    file_name db 'input.txt', 0
    access_mode db 'r', 0
    handle dd -1
    char db 0
    count dd 0; count how many character exist in the frequency list
    frequency times 50 dw 0
    max1 db 0, 0
    max2 db 0, 0
    max3 db 0, 0
    max4 db 0, 0
    max5 db 0, 0
    special_format db '| nr_crt = %d | character = "%c" | frequency = %d |', 10, 13, 0
    var db 0, 0
    saveEcx dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;(frequency is a list partitioned in words so that on the low word of the word it is placed a character and on the high word of the word it is placed it's frequency in the text read from input.txt file; consider the little endian ordering system)
        ;idea: read the text once; for every character read, we search for it's existence in the frequency list; if it does not exist, we place it at the next free position in frequency; if it does exist, we increment it's frequency, the word having the adress bigger with 1 than the adress of the character in the string frequency
        
        ;FILE * fopen(const char* nume_fisier, const char * mod_acces)
        push dword access_mode
        push dword file_name
        call [fopen]
        
        add esp, 4*2
        
        mov dword [handle], eax
        cmp eax, 0
        je  theend
        
        repeat:
        ;fread(atribute, size, count, handle)
        push dword [handle]
        push dword 1
        push dword 1
        push dword char
        call [fread]
        
        cmp byte [char], ' '
        je repeat
        
        add esp, 4*4
        
        cmp eax, 1
        jl EOF
        
        mov esi, frequency
        mov ecx, dword [count]
        mov al, [char]
        repeat1:
        ; search for the char in the frequency list
        cmp ecx, 0
        je outofrepeat1
        
        cmp al, [esi]
        je increaseFrequency
        
        add esi, 2
        sub ecx, 1
        jmp repeat1
        outofrepeat1:
        ; if it will pass through the loop without jumping to the increaseFrequency label, it means that the character could not be found in the frequency list, so we will append it, and increase the counting position
        mov [esi], al
        add byte [count], 1
        
        increaseFrequency:
        inc byte [esi+1]; the frequency of a character in the frequency list is placed on the highest word of the current word in esp
        
        jmp repeat
        ; until now, we must have had a correct frequency list, and all it has had been left to do is to check for the five characters with the maximum frequencies
        
        EOF:
        ; wee loop through our frequency list and hold five maximums, updating them when we need to
        
        mov esi, frequency
        mov ecx, dword [count]

        cld
        repeat2:
        cmp ecx, 0
        je outofrepeat2
        sub ecx, 1
        lodsw
        mov bx, ax
        cmp bh, [max1+1]
        jb thenmax2
            mov ax, word[max4]
            mov [max5], ax
            mov ax, word[max3]
            mov [max4], ax
            mov ax, word[max2]
            mov [max3], ax
            mov ax, word[max1]
            mov [max2], ax
            mov [max1], bx
            jmp repeat2
        thenmax2:
        cmp bh, [max2+1]
        jb thenmax3
            mov ax, word[max4]
            mov [max5], ax
            mov ax, word[max3]
            mov [max4], ax
            mov ax, word[max2]
            mov [max3], ax
            mov [max2], bx
            jmp repeat2
        thenmax3:
        cmp bh, [max3+1]
        jb thenmax4
            mov ax, word[max4]
            mov [max5], ax
            mov ax, word[max3]
            mov [max4], ax
            mov [max3], bx
            jmp repeat2
        thenmax4:
        cmp bh, [max4+1]
        jb thenmax5
            mov ax, word[max4]
            mov [max5], ax
            mov [max4], bx
            jmp repeat2
        thenmax5:
        cmp bh, [max5+1]
        jb repeat2
            mov [max5], bx
        jmp repeat2
        outofrepeat2:
        
        mov ecx, 5
        mov esi, max1
        repeat3:
        mov [saveEcx], ecx 
        mov al, [esi]
        mov [var], al
        mov ebx, 0
        mov edx, 6
        sub edx, ecx
        mov bl, [esi+1]
        push dword ebx
        push dword [var]
        push dword edx
        push dword special_format
        call [printf]
        add esi, 2
        mov ecx, [saveEcx]
        loop repeat3
        
        theend:
        ;int fclose(FILE * descriptor)
        push dword [handle]
        call [fclose]
        add esp, 4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
