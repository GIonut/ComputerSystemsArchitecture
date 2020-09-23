bits 32

global function

segment code use 32 class=code public
    function:
        mov ecx, [esp+12]
        mov esi, [esp+8]
        mov edi, [esp+4]
        
        shr ecx, 2
        .repeat1:
            cmp ecx, 0
            je .endloop1
            shl ecx, 4*4
            lodsd
            mov bx, 0
            mov cx, 10
            .repeat2:
                cmp eax, 0
                mov dx, 0
                je .outrp
                div cx
                add bx, dx
                cwd
            jmp .repeat2
            .outrp:
            mov cx, 0
            shr ecx, 4*4
            mov ax, bx
            cwde
            stosd
        loop .repeat1
        .endloop1:
        
        ret 4*3
         
            
        