; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Hace dilatacion de pixeles

; Parametros
; rdi : dir imagen input - in grayscale
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : offset -- Color offset, para manejar las distintas tonalidades

global dilatation


dilatation:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12 	
	push r13 	
	push r14 	
	push r15        
	push rbx       

	; Guardo los parametros en los registros
	mov rax, rsi ; columnas
	mov rbx, rdx ; filas

	mov r12, rdi

	movdqu xmm3, [rdi]
	pxor xmm0, xmm0
	xor r9,r9

.procesar:
	cmp rax, 16
	jl .ultimos_linea 
	
	; primera linea
	cmp rbx, rdx
	je .bordes

	cmp rbx, 1
	je .bordes

	sub rdi, rsi
	movdqu xmm0, [rdi] ;arriba

	add rdi, rsi
	movdqu xmm1, [rdi] ;centro
	
	add rdi, rsi
	movdqu xmm2, [rdi] ;abajo
	sub rdi, rsi
	
	movdqu xmm4, xmm1
	movdqu xmm5, xmm1

	psrldq  xmm4, 1
	pslldq  xmm5, 1

	por xmm1, xmm0 ;arriba o centro
	por xmm1, xmm2 ;centro o abajo

	por xmm4, xmm5 ; derecho o izquierdo
	
	; invalido derecho e izquierdo de los extremos
	; porque shiftee , solo compara con arriba, abajo y medio.
	pinsrb xmm4, r9d, 0
	pinsrb xmm4, r9d, 15
	 
	por xmm1, xmm4 ; (arriba o centro o abajo) o (derecho o izquierdo) 


.siguiente:
	movdqu [rcx], xmm1

	; actualizo contadores
	add rdi, 15
	add rcx, 15

	sub rax, 15

	jmp .procesar

.siguiente_16:
	movdqu [rcx], xmm1

	; actualizo contadores
	add rdi, 16
	add rcx, 16

	sub rax, 16

	jmp .procesar

.ultimos_linea:
	;trampa - ya proceso ultima linea y me quedo 1 pq resta 15. 
	cmp rax, 1
	je .abajo
	cmp rax, 0
	je .abajo

	; vuelvo atras a los 16 bits anteriores
	add rdi, rax
	add rcx, rax
	mov rax, 16
	sub rdi, 16
	sub rcx, 16
	jmp .procesar


.bordes:
	movdqu xmm1, [rdi]
	jmp .siguiente_16

.abajo:
	; se ejecuta cuando completa una linea

	cmp rbx, 1
	je .fin
	
	; resto una linea
	sub rbx, 1

	; avanzo abajo 
	add rax, rsi
	
	jmp .procesar


.fin:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
	ret

