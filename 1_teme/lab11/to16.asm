bits 32

global to16

segment data use32 class=data public
    x times 16 db 0

segment code use32 class=code public    
        to16:
            mov ax, [esp+4] ; punem in dx:ax numarul transmis ca parametru
            mov dx, [esp+6]
            mov ecx, 0
            .repeat:
                mov bx, 16
                div bx; impartim succesiv numarul la 16 eax/bx => dx:=eax%bx  ax = eax/bx
                cmp dx, 10
                jb .notletter
                    add dx, 7; daca restul e mai mare ca 9 atunci pregatim transformarea in litera mare ex: 'A' = '0' + 7 etc
                .notletter:
                    add dx, '0'; transformam restul in caracter
                push dx ; punem pe stiva restul, un word, ca mai apoi sa il putem lua in ordine inversa
                mov dx, 0
                inc ecx
            cmp ax, 0
            ja .repeat
            
        cld 
        mov edi, x
        
        .repeat1:
            pop ax
            stosb
        loop .repeat1
        
        mov eax, x
        
        ret