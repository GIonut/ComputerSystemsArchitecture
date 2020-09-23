bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;2) Se da un fisier care contine oricate numere cu valori cuprinse in
;intervalul 1-100. Scrieti un program asm care afiseaza pe ecran cea mai mare
;secventa de numere cu aspect de munte din fisierul dat, fara a retine in
;memorie toate numerele din acesta. In fisierul dat se pot afla oricate numere 
;pe oricate linii. In cazul in care exista mai multe astfel de secvente in 
;fisierul dat afisarea oricarei secvente se considera o solutie valida.
;Observatie: O secventa de numere cu aspect de munte reprezinta o seventa de
;numere in ordie strict crescatoare urmata de o secventa de numere strict
;descrescatoare.

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf , fscanf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
import fscanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    inpfile db 'secv.txt', 0
    modread db 'r', 0
    handle dd -1
    message db 'a mountain sequence is :', 0
    format db '%d ', 0
    nomountain db 'sorry, could not find a mountain sequence!', 0
    nr dd 0
    startp db 0
    len db 0
    index db 0
    newlen db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
                             ;fopen(path, mode)
        push dword modread
        push dword inpfile
        call [fopen]
        add esp, 4*2
        
        mov [handle], eax
        cmp eax, 0
        je theend
        
                             ;fread(adress, times, size, handle)
        repeat:
            mov bl, [nr]      ; first al:=0 but it will take the value of the first read nr. we will read 2 nr at each iteration
            push dword nr
            push dword format
            push dword [handle]           ; get in nr the value of numbers in the file, one by one
            call [fscanf]
            
            add esp, 4*3
            
            cmp eax, -1
            je EOF
            
            inc byte [len]        ; keep the length of a mountain sequence sequence
            inc byte [index]      ; counts how many numbers have been read
            
            cmp [len], byte 1     ; if len is 1 means that we are at the first number in a sequence
            jne continue          ; if len is not 1 jump at continue label
            cmp [startp], byte 0h   ; if len is 1 and start is 0 it means thet we ar at the first number in the file
            je repeat             ; so we need to read another one in order to compare them
            continue:
            cmp [len], byte 2     ; if len >= 2 jump to ascending label
            jge ascending
                                  ; else if len  < 2 
            cmp bl, [nr]          ; if the 2nd nr is greater than the 1st one it means that the sequence is ascending so far
            jl repeat             ; so we read the next number
                                  
                                  ; if the 2nd nr is smaller than the 1st one and len < 2 => the sequence is not a mountain
            notmountain:          ; not a mountain label:
            mov cl, byte [index]
            mov [startp], cl   ; sets the starting point of a new sequence to the index of the last read number
            mov [len], byte 0     ; and sets the length of the new sequence to 0
            jmp repeat            ; finaly jumps to the begining(repeat label)
            
            ascending:            ; ascending lable
            cmp bl, [nr]          ; if we are here it means that the last two nr read must be in a strictly ascending order
            je notmountain        ; if they are equal it means that the current sequence is not a mountain so jump at that label
            jg EOF                ; if the last two numbers are in a strictly descending order it means tht we have found 
                                  ; our mountain sequence so we are not going to read any more numbers from the file
        jmp repeat                ; if we have not find our mountain sequence untill now and we have not rich the EOF, repeat
        
        EOF: 
            push dword [handle] ; if we have reached the EOFwe close the file
            call [fclose]
            
            add esp, 4*1
            
            cmp [len], byte 2   ; if we dont have a mountain sequence of at least 3 numbers jump at noseq label
            jl noseq
            
            push dword modread    ; if we have a mountain sequence than we open the file again and search for the starting   
            push dword inpfile    ;point of the sequence, printing len numbers from there
            call [fopen]                        
            
            add esp, 4*2
            
            mov [handle], eax
            cmp eax, 0
            je theend
            
            mov bl, byte [startp] ; mov in cl the value of the starting point of our sequence
            mov [index], byte 0     ; set index to 0 again
            repeat1:
                 ; parse the file again
                push dword nr
                push dword format
                push dword [handle] ; read numbers from file one by one
                call [fscanf]
                
                add esp, 4*3
                
                inc byte [index]     ; keep the track of the index of the current number read
                
                cmp byte [index], bl ; if the index of the current number is lower than the index of the starting pt in our seq
                jl repeat1           ; we read the next number  
                jg print             ; if we reached at the starting point of our sequence
                mov al, [index]
                sub al, [startp]
                mov [newlen], al  ; set bl such that we can check the length of the sequence now
                push dword message   ; print the message: "the mountain sequence is: "
                call [printf]
                add esp, 4*1
                
                print:               ; if the index is greater than the starting point of the sequence
                mov al,byte [len]
                cmp [newlen], al; and newlen is smaller than the length of the sequence we print the current number and repeat
                jg theend           ; else it means that we have reached the final of our sequence so jump to the end
                
                push dword [nr]     
                push dword format
                call [printf]
                add esp, 4*2
                
                inc byte [newlen]
            jmp repeat1
            
            push dword [handle]
            call [fclose]
            
            add esp, 4*1
            
        noseq:               ; prints a message that we have not find a sequence
            push dword nomountain
            call [printf]
            
            add esp, 4*1
        theend: 
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
