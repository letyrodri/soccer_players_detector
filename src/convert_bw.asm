; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Convert a grayscale image in black and white

; Parametros
; rdi : dir imagen input - in grayscale
; rsi : columnas
; rdx : filas
; rcx : dir imagen output

global convert_bw

convert_bw:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12 	; fuente 
	push r13 	; destino
	push r14 	; m
	push r15        ; n 
	push rbx        ; row_size

	; Guardo los parametros en los registros
	mov r12, rsi
	mov r13, rdx
	mov r14, rdi
	

	; actualizo el valor de rsi
	mov rsi, r12

.procesar:
	cmp r12, 0
	je .abajo 

	; imagen original
	movdqu xmm0, [rdi]

	movdqu xmm1, xmm0
	movdqu xmm2, xmm0

	pxor xmm11, xmm11
	punpcklbw xmm1, xmm11
	punpckhbw xmm2, xmm11

	pcmpgtw xmm1, xmm11
	pcmpgtw xmm2, xmm11
	
	packsswb xmm1, xmm2

	movdqu [rcx], xmm1

	add rdi, 16
	sub r12, 16
	add rcx, 16

	jmp .procesar
	
.abajo:
	cmp r13, 1
	je .fin
	
	sub r13, 1
	add r12, rsi
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

