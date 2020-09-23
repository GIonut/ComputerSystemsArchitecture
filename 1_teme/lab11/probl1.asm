bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
extern to16
; our data is declared here (the variables needed by our program)
segment data use32 class=data public
    ; ...
    a dd 0
    b times 8 db 0
    get_a db 'a = ', 0
    format_num db '%d', 0
    format_string db 'a = 0x%s', 10, 13, 0
    saveEcx dd 0
    x1 dd 0
; our code starts here
segment code use32 class=code public
    start:
        ; ...
        push dword get_a
        call [printf]
        
        push dword a
        push dword format_num
        call [scanf]
        
        push dword [a]
        ;push dword continue
        ;jmp to16
        call to16
        
        
        ;continue:
        add esp, 1*4; eliberam stiva
        
        mov [x1], eax
        push eax
        push dword format_string
        call [printf]
        add esp, 2*4
        
    mov eax, [x1]
    mov ecx, -1
    lea esi, [eax - 1]
    count:
        inc ecx
        inc esi
        cmp byte [esi], 0 ;numaram caracterele
    jne count
    
	mov esi, eax
    dec ecx
    lea edi, [eax+1*ecx +1] ; in memorie, dublam sirul; pt a afisa si numarul initial stergem +1 si dec ecx
    repeat:
        mov [saveEcx], ecx
        movsb
        push dword esi
        push format_string  ; afisam permutarile
        call [printf]
        mov ecx, [saveEcx]
    loop repeat
        
                
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
