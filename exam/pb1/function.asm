bits 32 ; assembling for the 32 bits architecture
      
global function
segment data use32 class=data public
    ; ...
    maxval dd 0
    maxstart dd 0
    
segment code use32 class=code public
   function:
        ; ...
        mov esi, [esp + 4]
        mov eax, 0
        mov ebx, 0
        mov ecx, esi
        .repeat1:
            cmp byte[esi], 0
            je .endloop1
            
            test byte[esi], 1
            jnz .odd
                cmp eax, [maxval]
                jb .notmax
                    mov [maxval], eax
                    mov [maxstart], ebx
                .notmax:
                lea ebx, [esi+1]
                sub ebx, ecx
                mov eax, 0
                inc esi
                jmp .repeat1
            .odd:
            
            inc eax
            inc esi
        jmp .repeat1
        .endloop1:
        cmp eax, [maxval]
                jb .notmax1
                    mov [maxval], eax
                    mov [maxstart], ebx
        .notmax1:
        
        mov eax, [maxval]
        mov ebx, [maxstart]
        
        ret 4
