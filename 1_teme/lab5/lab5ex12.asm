bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;Two character strings S1 and S2 are given. Obtain the string D by concatenating the elements found on even positions in S2 ;and the elements found on odd positions in S1.
;Example:
;S1: 'a', 'b', 'c', 'd', 'e', 'f'
;S2: '1', '2', '3', '4', '5'
;D: '2', '4','a','c','e'

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    s1 db 'abcdef'
    lens1 equ $-s1
    s2 db '12345'
    lens2 equ $-s2
    d times ((lens1+lens2)/2 + 1) db 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov esi, s2+1 ; s2 the source string, but we start from pos 2(even pos)
        mov edi, d ;  d the destination string
        
       
        repeat:    
           mov al, [esi] ; move in al the byte from the offset esi AL:= [s2+1] := 2
           mov [edi], al; move in the byte frrom the offset edi the byte from al => [d] := 2
           add esi, 2; go to the next even position
           inc edi; go to the next element in d we need to coplete
           cmp esi, s2+lens2; if the offset in esi is smaller than the offset s2+lens2 jump to repeat lable. esi is now s2= s2+3
           jb repeat
           
         mov esi, s1; s1 is the source now
         ; the dest is now modified from d to d + (nr of even position in s2)
         
         repeat1:
            mov al, [esi]; move in al the byte from the offset esi (from the first odd pos in s1)
            mov [edi], al; mov in byte from the offset edi the byte al
            add esi, 2; move to the next odd pos in s1
            inc edi; move to the next position in d so the next position that has to be completed with a nr on odd pos in s1
            cmp esi, s1+lens1
            jb repeat1
         
         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
