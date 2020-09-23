bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, scanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    n resb 1
    formatn db '%d', 0
    messagen db  'get n = ', 0
    filename db 'pb14.txt', 0
    handle dd -1
    formatchar db '%c', 0
    char db '', 0
    modread db 'r', 0
    message db 'the new sentence is: %s', 0
    count db 0
    countwords db 0
    wordindex db 0
    aWord resb 15
    sentence resb 30
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; read n: scanf(formatn, n)
        push messagen; 'get n='
        call [printf]
        add esp, 4
        
        push dword n
        push dword formatn
        call [scanf]
        add esp, 4*2
        
        ; read n sentences (until n '\n' have been read): fread(handle, size, count, format)
        
        push dword modread
        push dword filename
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        jz error
        
        mov edi, sentence
        repeat:
            push dword [handle]
            push dword 1
            push dword 1
            push dword char
            call [fread]
            
            add esp, 4*4
            
            cmp byte[char], 0x0A
            jne notNewSentence
            
            dec byte [n]    ; if char is '\n' then we are at the end of a sentence so we decrement n and 
            
            mov cl, byte[count]
            cmp byte[countwords], cl ; if our word is the last word in a sentence we also add it to our sentence
            je lastword
            
            mov byte[countwords], 0 ; set count to 0; we now count the words from a new sentence 
            mov byte[wordindex], 0
            inc byte[count] ; increment count so we get the word from the next position in the next sentence
            
            notNewSentence:
            cmp byte[char], ' '  ; if the char is a whitespace it means we are at a new word in the current sentence
            jne notNewWord
            
            lastword:
            
            mov cl, byte[count]
            cmp byte[countwords], cl ; check if it is our word
            jne notOurWord
            
            cld
            mov esi, aWord
            mov al, [wordindex]
            cbw
            cwde
            mov ecx, eax

            again:
            movsb; And add it to our sentence
            loop again
            
            inc byte[countwords] ; we also increment count
            mov byte[wordindex], 0; we do not clear the bytes in aWord; we just consider them free so that we can overwrite them
            jmp check
            
            notOurWord:
            
            inc byte[countwords] ; if char is ' ' => we are at a new word in the current sentence so we increment count
            mov byte[wordindex], 0; we do not clear the bytes in aWord; we just consider them free so that we can overwrite them
            
            notNewWord:
            
            mov cl, [char]  ; if char is neither ' ' nor '\n' then we add it to the aword, at the index wordindex
            mov ebx, aWord
            mov al, byte[wordindex]
            cbw
            cwde
            mov byte[ebx+1*eax], cl
            inc byte[wordindex]; then increment wordindex
            
            check:
            cmp byte[n], 0; if we have parse all the sentences so that n = 0 we exit the loop
            jne repeat
           
        push sentence
        push message
        call [printf]
        add esp, 4*2
        
        error:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

        
;Read an integer (positive number) n from keyboard. Then read n sentences containing at least n words (no validation needed).
;Print the string containing the concatenation of the word i of the sentence i, for i=1,n (separated by a space).
;Example: n=5
;We read the following 5 sentences:
;We read the following 5 sentences.
;Today is monday and it is raining.
;My favorite book is the one I just showed you.
;It is pretty cold today.
;Tomorrow I am going shopping down town.

;The string printed on the screen should be:
;We is book cold shopping.