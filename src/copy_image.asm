; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Copia imagenes entre dos posiciones de memoria

; Parametros
; rdi : dir imagen input - in grayscale o color
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : es color? 1 indica que si , 0 que no

global copy_image

copy_image:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12 	; fuente 
	push r13 	; destino
	push r14 	; m
	push r15        ; n 
	push rbx        ; row_size

	; Guardo los parametros en los registros
	mov r12, rsi ;columnas
	mov r13, rdx ;filas
	mov r14, rdi ;input
	
	; multiplico por 3 el valor de r12, porque son imagenes color - 3 pixeles
	cmp r8, 1
	jne .continuar
	add r12, rsi
	add r12, rsi

	; actualizo el valor de rsi
.continuar:
	mov rsi, r12

.procesar:
	cmp r12, 0
	je .abajo 

	; imagen original
	movdqu xmm0, [rdi]
	movdqu [rcx], xmm0


	add rdi, 16
	sub r12, 16
	add rcx, 16

	jmp .procesar
	
.abajo:
	cmp r13, 1
	je .fin
	
	sub r13, 1
	mov r12, rsi
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

