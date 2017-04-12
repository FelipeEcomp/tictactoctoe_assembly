org 100  

mov ax, 3
int 10h
 


mov ah, 09h
mov al, 'X'
mov bl, 01000000b   
mov cx, 1
int 10h 


mov ah, 02h	 ; posicao do cursor
mov dh, 0	 ; Numero da linha
mov dl, 1	 ; Numero da coluna   
int 10h    

	
mov ah, 09h
mov al, 'O'
mov bl, 11110000b   
mov cx, 1
int 10h 
	 

mov ah, 02h	 ; posicao do cursor
mov dh, 0	 ; Numero da linha
mov dl, 2	 ; Numero da coluna   
int 10h 	 
	  
mov ah, 09h
mov al, 0
mov bl, 01000000b   
mov cx, 1
int 10h 
						      
mov ah, 02h	 ; posicao do cursor
mov dh, 1	 ; Numero da linha
mov dl, 0	 ; Numero da coluna   
int 10h 	

 				  
						      
mov ah, 09h
mov al, 0
mov bl, 11110000b   
mov cx, 1
int 10h 						      
						      

mov ah, 02h	 ; posicao do cursor
mov dh, 1	 ; Numero da linha
mov dl, 1	 ; Numero da coluna   
int 10h  

mov ah, 09h
mov al, 0
mov bl, 01000000b   
mov cx, 1
int 10h  

mov ah, 02h	 ; posicao do cursor
mov dh, 1	 ; Numero da linha
mov dl, 2	 ; Numero da coluna   
int 10h  

mov ah, 09h
mov al, 0
mov bl, 11110000b   
mov cx, 1
int 10h        
      
mov ah, 02h	 ; posicao do cursor
mov dh, 2	 ; Numero da linha
mov dl, 0	 ; Numero da coluna   
int 10h  

mov ah, 09h
mov al, 0
mov bl, 01000000b   
mov cx, 1
int 10h   

mov ah, 02h	 ; posicao do cursor
mov dh, 2	 ; Numero da linha
mov dl, 1	 ; Numero da coluna   
int 10h  

mov ah, 09h
mov al, 0
mov bl, 11110000b   
mov cx, 1
int 10h       

mov ah, 02h	 ; posicao do cursor
mov dh, 2	 ; Numero da linha
mov dl, 2	 ; Numero da coluna   
int 10h  

mov ah, 09h
mov al, 0
mov bl, 01000000b   
mov cx, 1
int 10h        

mov ah, 0
int 16h


MOV AH,4Ch     ; Select exit function
MOV AL,00	; Return 0
INT 21h 	; Call the interrupt to exit                                                        
						      

