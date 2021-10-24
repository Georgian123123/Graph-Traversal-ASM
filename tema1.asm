%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
   ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main


transformer:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]; in ebx avem stringul nostru pe care vrem sa l convertim
    xor eax, eax ; rezultatul final il facem 0
    
repeat:
    movzx ecx, byte[edx] ; luam un singur caracter
    
    cmp ecx, "-"
    je repeat2
    
    inc edx; mergem la urmatorul
    
    cmp ecx, '0'
    jb done
    
    cmp ecx, '9'
    ja done
    
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    jmp repeat
repeat2:

    inc edx
    movzx ecx, byte[edx] 
    
    cmp ecx, '0'
    jb done2
    
    cmp ecx, '9'
    ja done2
    
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    jmp repeat2
done:
    leave 
    ret
    
done2:
    neg eax
    leave
    ret
      
postorder:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    mov edx, [ebx]

    cmp byte[edx], "*"
    je mulish
    
    cmp byte[edx], "/"
    je divish
    
    cmp byte[edx], "+"
    je addish
    
    cmp byte[edx], "-"
    je subish
    
    jmp addstiv
return:
    leave
    ret

addish:
    mov ebx, [ebp + 8] ;iau adresa structurii
    mov ecx, [ebx + 4] ; iau adresa copilului stang
    push ecx ;il pun pe stiva pentru apelul functiei
    call postorder ; apelez recursiv pentru a ma duce in jos prin arbore
    pop ecx ; eliberez stiva
    
    push eax ;salvez returnul dat de stanga
    
    mov ebx, [ebp + 8] ;iau adresa structurii
    mov ecx, [ebx + 8] ;iau adresa copilului din dreapta
    push ecx ;...
    call postorder ;...
    pop ecx; eliberez stiva
    
    pop ecx; iau returnul dat de stanga
    
    add eax, ecx
    jmp return
    
divish:
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 4]
    push ecx
    call postorder
    pop ecx
    
    push eax ;salvez returnul dat de stanga
    
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 8]
    push ecx
    call postorder
    pop ecx
    
    pop ecx; iau returnul dat de stanga
    
    mov edx, ecx
    mov ecx, eax
    mov eax, edx
    
    xor edx , edx
    cmp eax, 0
    jl ELSE
    cmp ecx, 0
    jl else
    idiv ecx
    
    jmp return
   
ELSE:
    neg eax
    idiv ecx
    neg eax 
    jmp return
else:
    neg ecx
    idiv ecx
    neg eax
    jmp return
mulish:
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 4]
    push ecx
    call postorder
    pop ecx
    
    push eax ;salvez returnul dat de stanga
    
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 8]
    push ecx
    call postorder
    pop ecx
    
    pop ecx; iau returnul dat de stanga
    
    imul ecx
    jmp return
    
subish:
    cmp byte[edx + 1], 0
    jne addstiv
    
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 4]
    push ecx
    call postorder
    pop ecx
    
    push eax ;salvez returnul dat de stanga
    
    mov ebx, [ebp + 8]
    mov ecx, [ebx + 8]
    push ecx
    call postorder
    pop ecx
    
    pop ecx; iau returnul dat de stanga
      
    sub ecx, eax
    mov eax, ecx
    jmp return
addstiv:
    ;converteste numerele
    mov ebx, [ebp + 8]
    mov ecx, [ebx]
    
    push ecx
    call transformer
    pop ecx
    
    jmp return  
    
     
      
       
         
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    ; Implementati rezolvarea aici:
    mov [root], eax
    push eax
    call postorder
    add esp, 4 
        
    PRINT_DEC 4, eax
    NEWLINE
                                                                                                                                                                                                                                                                                                                                                                                              
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    xor eax, eax
    leave
    ret