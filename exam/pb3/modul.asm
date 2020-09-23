bits 32
global sumOfDigits

segment code use 32 class = code public
    sumOfDigits:
        mov dx, [esp+6]
        mov ax, [esp+4]
        mov cx, 10
        mov bx, 0
        .repeat:
            cmp ax, 0
            je .outOfLoop
            div cx
            add bx, dx
            mov dx, 0
        jmp .repeat
        .outOfLoop:
        
        ret 4