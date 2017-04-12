name "jogo da velha v.1"



;0700h segmento de dados.
;b800h segmento de video.

org 100h
                   
;=====================configura as variaveis================================

inicio:
  
;todas as variaveis estao dentro do segmento 0700 (segmento de dados)
mov [0002h], 1; alternador
;mov [0004h], 0; jogador 2 (desconsiderar)

mov [0006h], 0000h; contador de jogadas (cont);

mov [0008h], 'x'; simbolo atual;

mov [0040h], 0; contador de linhas de impressao;
mov [0042h], 0; contador de colunas de impressao;
mov [0044h], '_'; variavel i
mov [0046h], 0fh; variavel j


call limpa_matriz;

; o registrador de segmentos de dados extra aponta para a memoria do video
mov ax, 0b800h;
mov es, ax;

mov ax, 0000h; (40x25 - 16 cores - 8 paginas) 
int 10h;
                   
;####################configura as variaveis#################################                   
   
    
    call limpa_tela;
    call desenha_tabuleiro;
    
    ;esconde o cursor (o codigo 0100h mexe com o tamanho do cursor)
    mov ax, 0100h;
    mov cx, 0000h;
    mov ch, 32; esconde o cursor
    int 10h;
    
    
    ;posiciona o cursor
    mov ax, 0200h; chamada para posicionamento do cursor
    mov dh, 6; linha
    mov dl, 15; coluna
    mov bh, 0; numero da pagina

    int 10h;
    
    mov [0042h], 0; garante que a pessoa nao aperte 
                  ;enter sem posicionar o simbolo primeiro. 
           
    
    pega_caractere1:    
            
        mov ah, 00h;
                                    
        
        
        ;AH = BIOS scan code.
        ;AL = ASCII character.

        int 16h;    
    
        cmp al, 31h; digitou 1    
        jz c1; muda o estado
    
        cmp al, 32h; digitou 2   
        jz c2; muda o estado
                                                       
        cmp al, 33h; digitou 3    
        jz c3; muda o estado
        
        cmp al, 34h; digitou 4    
        jz c4; muda o estado
        
        cmp al, 35h; digitou 5    
        jz c5; muda o estado
        
        cmp al, 36h; digitou 6    
        jz c6; muda o estado
        
        cmp al, 37h; digitou 7    
        jz c7; muda o estado
        
        cmp al, 38h; digitou 8    
        jz c8; muda o estado
        
        cmp al, 39h; digitou 9    
        jz c9; muda o estado
        
        cmp al, 0Dh; digitou enter    
        jz enter; muda o estado
        
        cmp al, 's';
        jz sair; sai do jogo
        
    jmp pega_caractere1; nao digitou o botao certo, tente de novo
    
    
    ; ja foi adequado ao teclado numerico do computador.
    
    c7:
        ;posiciona o cursor
        mov dh, 5; linha
        mov dl, 11; coluna
        
        
        cmp [0010h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 10h; guarda o endereco da matriz        
        call movimentacao; 
    
         
    jmp pega_caractere1;
    
    
    c8:
        ;posiciona o cursor
        mov dh, 5; linha
        mov dl, 15; coluna
        
        cmp [0012h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 12h;
                
        call movimentacao;
    
    jmp pega_caractere1;
    
    c9:
        ;posiciona o cursor
        mov dh, 5; linha
        mov dl, 19; coluna
        
        cmp [0014h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 14h;
                
        call movimentacao;
         
    jmp pega_caractere1;
    
    c4:
        ;posiciona o cursor
        mov dh, 6; linha
        mov dl, 11; coluna
        
        cmp [0016h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 16h;
                
        call movimentacao;
         
    jmp pega_caractere1;
    
    c5:
        ;posiciona o cursor
        mov dh, 6; linha
        mov dl, 15; coluna
        
        cmp [0018h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 18h;
                        
        call movimentacao;
         
    jmp pega_caractere1;
    
    c6:
        ;posiciona o cursor
        mov dh, 6; linha
        mov dl, 19; coluna
        
        cmp [001Ah], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 1Ah;
                
        call movimentacao;
         
    jmp pega_caractere1;
    
    c1:
        ;posiciona o cursor
        mov dh, 7; linha
        mov dl, 11; coluna
        
        cmp [001Ch], 0; veh se a casa esta livre
        jnz pega_caractere1;
                
        mov [0042h], 1Ch;
                                        
        call movimentacao;                
         
    jmp pega_caractere1;
    
    c2:
        ;posiciona o cursor
        mov dh, 7; linha
        mov dl, 15; coluna
        
        cmp [001Eh], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 1Eh;
                
        call movimentacao;
         
    jmp pega_caractere1;
    
    c3:
        ;posiciona o cursor
        mov dh, 7; linha
        mov dl, 19; coluna
        
        cmp [0020h], 0; veh se a casa esta livre
        jnz pega_caractere1;
        
        mov [0042h], 20h;
                
        call movimentacao;
         
    jmp pega_caractere1;
    
    enter:
    
        ;verifica se a pessoa apertou enter antes de posicionar o simbolo;
        cmp [0042h], 0
        jz pega_caractere1;
        
        
        mov ah, 09h; chamada para impressao de caractere.
        mov al, [0008h]; caractere a ser escrito.
        mov bh, 00h; pagina em que sera escrito.
        mov bl, 0Ch; atributo.
        mov cx, 1; numero de vezes que sera escrito.

        int 10h;        
        
        ;escreve o codigo ascii do simbolo na matriz
        mov bh, 0;
        mov bl, [0042h];        
        
        ; simbolo atual eh colocado na matriz
        mov al, [0008h];
        mov [bx], al;
        
        mov [0046h], 0Ch; atributo (cor).     
        
        ; retorno da funcao teste_vencedor;
        mov bh, 1;
        
        call teste_vencedor; verifica se houve ganhador ou se atingiu o numero
                           ; maximo de jogadas e houve empate.      
        
        cmp bh, 0; caso alguém tenha ganhado,  reinicia.
        jz inicio;
        
        call troca_jogador;
        
        mov [0042h], 0; garante que o enter nao seja digitado sem posicionar o simbolo.
        
    jmp pega_caractere1;
    
sair:
    ret ; retorna para o sistema operacional.
    ;[hlt] para o processador (poderia ter sido usado).

; FIM DO PROGRAMA


;==============================movimentacao=================================

movimentacao:
    
    ; imprimi         
    mov ah, 09h; chamada para impressao de caractere
    mov al, [0044h]; caractere a ser escrito.
    mov bh, 00h; pagina em que sera escrito.
    mov bl, [0046h]; atributo (cor).
    mov cx, 1; numero de vezes que sera escrito.
    int 10h;
    
    mov ax, 0200h; chamada para posicionamento do cursor
    mov bh, 0; numero da pagina

    int 10h;
        
    ;pega o caractere dessa posicao        
    mov ax, 0800h;
    mov bx, 0;
        
    int 10h;
        
    mov [0044h], al; guarda o caractere
    mov [0046h], ah; guarda o atributo
        
    ; imprimi         
    mov ah, 09h; chamada para impressao de caractere
    mov al, [0008h]; caractere a ser escrito.
    mov bh, 00h; pagina em que sera escrito.
    mov bl, 0fh; atributo.
    mov cx, 1; numero de vezes que sera escrito.

    int 10h;
    
    
ret;    


                  
;==================rotina de limpeza da matriz==============================

limpa_matriz: 
    mov cx, 9;
    mov bx, 0010h; primeiro endereco da matriz.
    lp1:
      mov [bx], 0000h; zera
      add bx, 2; incrementa para o proxima jogadda (9 jogadas)
    loop lp1;
    
ret; fim da rotina limpa_matriz                          

;==================rotina de limpeza da matriz==============================


;==============================limpa tela====================================    

limpa_tela:

    mov ax, 0200h; chamada para posicionamento do cursor
    mov dh, 0; linha
    mov dl, 0; coluna
    mov bh, 0; numero da pagina
    
    int 10h;
    
    ; imprimi         
    mov ah, 09h; chamada para impressao de caractere
    mov al, ' '; caractere a ser escrito.
    mov bh, 00h; pagina em que sera escrito.
    mov bl, 0fh; atributo.
    mov cx, 500; numero de vezes que sera escrito.

    int 10h;
    
ret;

;==============================limpa tela====================================    



;===========================desenha tabuleiro================================    
; escreve direto na memoria de video.
desenha_tabuleiro:

   mov [0040h], 2;
   mov [0042h], 22;
   
   mov al, 80;
   mul [0040h];
   mov di, ax;
   add di, [0042h];
   
   mov es:[di], 'J';
   mov es:[di+2], 'o';
   mov es:[di+4], 'g';
   mov es:[di+6], 'a';
   mov es:[di+8], 'd';
   mov es:[di+10], 'o';
   mov es:[di+12], 'r';
   mov es:[di+14], ' ';
   mov es:[di+16], '1';   
     
   mov [0040h], 4;
   mov [0042h], 18;
   
   mov al, 80;
   mul [0040h];
   mov di, ax;
   add di, [0042h];
   
   mov es:[di], ' ';
   mov es:[di+2], '_';
   mov es:[di+4], '_';
   mov es:[di+6], '_';
   mov es:[di+8], ' ';
   mov es:[di+10], '_';
   mov es:[di+12], '_';
   mov es:[di+14], '_';
   mov es:[di+16], ' ';
   mov es:[di+18], '_';
   mov es:[di+20], '_';
   mov es:[di+22], '_';
   
   mov cx, 3;   
   
   lp10:
   
    add [0040h], 1;
    mov [0042h], 18
    
    mov al, 80;
    mul [0040h];
    mov di, ax;
    add di, [0042h];
   
    mov es:[di], '|';
    mov es:[di+2], '_';
    mov es:[di+4], '_';
    mov es:[di+6], '_';
    mov es:[di+8], '|';
    mov es:[di+10], '_';
    mov es:[di+12], '_';
    mov es:[di+14], '_';
    mov es:[di+16], '|';
    mov es:[di+18], '_';
    mov es:[di+20], '_';
    mov es:[di+22], '_';
    mov es:[di+24], '|';       
    
   loop lp10;
   
   add [0040h], 7;
   mov [0042h], 0;
   
   mov al, 80;
   mul [0040h];
   mov di, ax;
   
   
    mov es:[di], 'U';
    mov es:[di+2], 's';
    mov es:[di+4], 'e';
    mov es:[di+6], ' ';
    mov es:[di+8], 'o';
    mov es:[di+10], 's';
    mov es:[di+12], ' ';
    mov es:[di+14], 'n';
    mov es:[di+16], 248;
    mov es:[di+18], 's';
    mov es:[di+20], ' ';
    mov es:[di+22], 'e';
    mov es:[di+24], ' ';    
    mov es:[di+26], 'e';
    mov es:[di+28], 'n';
    mov es:[di+30], 't';
    mov es:[di+32], 'e';
    mov es:[di+34], 'r';
    mov es:[di+36], ' ';
    mov es:[di+38], 'p';
    mov es:[di+40], 'a';
    mov es:[di+42], 'r';
    mov es:[di+44], 'a';
    mov es:[di+46], ' ';
    mov es:[di+48], 'j';
    mov es:[di+50], 'o';
    mov es:[di+52], 'g';
    mov es:[di+54], 'a';
    mov es:[di+56], 'r';
    mov es:[di+58], ' ';
    mov es:[di+60], '(';
    mov es:[di+62], 's';
    mov es:[di+64], '-';
    mov es:[di+66], 's';
    mov es:[di+68], 'a';
    mov es:[di+70], 'i';
    mov es:[di+72], 'r';
    mov es:[di+74], ')';                             
                      
   
ret

;===========================desenha tabuleiro================================    



;============================troca jogador===================================
troca_jogador:
  
    cmp [0002h], 1; de quem eh a vez
    jz jogador_1; se for o primeiro, muda para o segundo
    jmp jogador_2;
    
    jogador_1:
        ; muda o titulo para jogador 2
        mov [0040h], 2;
        mov [0042h], 38;
   
        mov al, 80;
        mul [0040h];
        mov di, ax;
        add di, [0042h];
                
        mov es:[di], '2';
        
        mov [0044h], 'x'; quando mudar de posicao nao apaga o simbolo
    
        mov [0002h], 2; vez do jogador 2
        
        mov [0008h], 'o'; simbolo atual agora e a bola;          
    
        jmp volta1; sai da funcao
    
    jogador_2:
        ; muda o titulo para jogador 1
        mov [0040h], 2;
        mov [0042h], 38;
   
        mov al, 80;
        mul [0040h];
        mov di, ax;
        add di, [0042h];

        mov es:[di], '1';
        
        mov [0044h], 'o'; quando mudar de posicao nao apaga o simbolo
        
        mov [0002h], 1; vez do jogador 1
        
        mov [0008h], 'x'; simbolo atual agora e a bola;
        
        jmp volta1; sai da funcao
    
    volta1:
ret
;============================troca jogador===================================


;============================teste_vencedor==================================

teste_vencedor:
     
     mov cx,0; serve para contar o numero de simbolos na linha
     mov ah, 0; registrador temporario.
     
     ;linha 1================
     mov al, [0010h]; [1,1]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0012h]; [1,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [0014h]; [1,3]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou
     
     mov cx,0                                   
     ;linha 2================
     mov al, [0016h]; [2,1]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0018h]; [2,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [001Ah]; [2,3]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou
                    
     mov cx,0
     ;linha 3================ 
     mov al, [001Ch]; [3,1]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [001Eh]; [3,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [0020h]; [3,3]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou
     
     mov cx,0
     ;coluna 1================ 
     mov al, [0010h]; [1,1]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0016h]; [2,1]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [001Ch]; [3,1]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou
     
     mov cx,0
     ;coluna 2================ 
     mov al, [0012h]; [1,2]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0018h]; [2,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [001Eh]; [3,2]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou                                       
                    
     mov cx,0
     ;coluna 3================ 
     mov al, [0014h]; [1,3]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [001Ah]; [2,3]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [0020h]; [3,3]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou  
     
     mov cx,0
     ;cruzador 1================ 
     mov al, [0010h]; [1,1]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0018h]; [2,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [0020h]; [3,3]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou                                       
                          
     mov cx,0
     ;cruzador 2================ 
     mov al, [0014h]; [1,3]
     sub al, [0008h];
     add cx, ax; 
     
     mov al, [0018h]; [2,2]
     sub al, [0008h];
     add cx, ax;
     
     mov al, [001Ch]; [3,1]
     sub al, [0008h];
     add cx, ax;
     
     jz texto_ganhou                                       
                          
     ;empate================
              
     cmp [0006h],8 ; verifica se atingiu o valor maximo de jogadas
     je texto_empate;
     
     inc [0006h];incrementa o valor do contador        
     jmp sair2;
     
     texto_ganhou:
     call mensagem_vencedor;
     jmp sair2;  
     
     texto_empate:
     call mensagem_empate;
     
     
     sair2:     

ret;

;============================teste_vencedor==================================



;============================mensagem_vencedor==================================

mensagem_vencedor: 
    
   mov [0040h], 10;
   mov [0042h], 22;
   mov al, 80;
   mul [0040h];
   mov di, ax;
   
   
   mov es:[di], 'J';
   mov es:[di+2], 'o';
   mov es:[di+4], 'g';
   mov es:[di+6], 'a';
   mov es:[di+8], 'd';
   mov es:[di+10], 'o';
   mov es:[di+12], 'r';
   mov es:[di+14], ' ';
   
   mov al, 30h;
   add al, [0002];
   mov es:[di+16], al;
   mov es:[di+18], ' ';
   mov es:[di+20], 'g';
   mov es:[di+22], 'a';
   mov es:[di+24], 'n';
   mov es:[di+26], 'h';
   mov es:[di+28], 'o';
   mov es:[di+30], 'u';
   
   
   ; mensagem para iniciar outra partida
   add [0040h], 7;
   mov [0042h], 0;
   
   mov al, 80;
   mul [0040h];
   mov di, ax;
   
   
    mov es:[di], 'P';
    mov es:[di+2], 'r';
    mov es:[di+4], 'e';
    mov es:[di+6], 's';
    mov es:[di+8], 's';
    mov es:[di+10], 'i';
    mov es:[di+12], 'o';
    mov es:[di+14], 'n';
    mov es:[di+16], 'e';
    mov es:[di+18], ' ';
    mov es:[di+20], 'Q';
    mov es:[di+22], 'u';
    mov es:[di+24], 'a';    
    mov es:[di+26], 'l';
    mov es:[di+28], 'q';
    mov es:[di+30], 'u';
    mov es:[di+32], 'e';                            
    mov es:[di+34], 'r';
    mov es:[di+36], ' ';                            
    mov es:[di+38], 'T';
    mov es:[di+40], 'e';
    mov es:[di+42], 'c';    
    mov es:[di+44], 'l';
    mov es:[di+46], 'a';
    mov es:[di+48], ' ';
    mov es:[di+50], 'P';
    mov es:[di+52], 'a';                            
    mov es:[di+54], 'r';
    mov es:[di+56], 'a';                            
    mov es:[di+58], ' ';                            
    mov es:[di+60], 'N';
    mov es:[di+62], 'o';                            
    mov es:[di+64], 'v';
    mov es:[di+66], 'o';
    mov es:[di+68], ' ';
    mov es:[di+70], 'J';                            
    mov es:[di+72], 'o';
    mov es:[di+74], 'g';                            
    mov es:[di+76], 'o';
                                

        
   
   mov ah, 00h; espera o usuario apertar qualquer tecla;
   int 16h;
    
   mov bh, 0; retorno da funcao avisando que houve ganhador
   
ret        

;============================mensagem_vencedor==================================

;============================mensagem_empate====================================


mensagem_empate: 
   
   ; indica o local de inicio da mensagem 
   mov [0040h], 10;
   mov [0042h], 22;
   mov al, 80;
   mul [0040h];
   mov di, ax;
   
   
   mov es:[di], ' ';
   mov es:[di+2], 'E';
   mov es:[di+4], 'm';
   mov es:[di+6], 'p';
   mov es:[di+8], 'a';
   mov es:[di+10], 't';
   mov es:[di+12], 'o';
   mov es:[di+14], 'u';
   mov es:[di+16], ' ';
   mov [0006h], 0000h;zera contador
   
   mov bh, 0;
   
   mov ah, 00h; espera o usuario apertar qualquer tecla;
   int 16h;
    
ret
;============================mensagem_empate====================================