; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Elimina el pasto del campo de juego

; Parametros
; rdi : dir imagen input
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : offset -- Color offset, para manejar las distintas tonalidades

global remove_grass

%macro process_pixels 0
	movdqu xmm1, xmm0
	movdqu xmm2, xmm0
	movdqu xmm3, xmm0

	pshufb xmm1, xmm13
	pshufb xmm2, xmm14
	pshufb xmm3, xmm15

	paddd xmm1, xmm12
	paddd xmm3, xmm12
	
	movdqu xmm4, xmm2
	PCMPGTD xmm4, xmm1 ;G > R

	movdqu xmm5, xmm1  
	PCMPGTD xmm5, xmm3  ; R > B

	pand xmm4, xmm5

	packssdw xmm4, xmm9
	packsswb xmm4, xmm9
%endmacro

remove_grass:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	push r12 	; fuente 
	push r13 	; destino
	push r14 	; m
	push r15        ; n 
	push rbx        ; row_size

	; Guardo los parametros en los registros
	mov r9, rsi ; columnas bn
	mov r12, rsi ;columnas
	mov r13, rdx ;filas
	mov r14, rdi ;input
	
	; multiplico por 3 el valor de r12, porque son imagenes color - 3 pixeles
	add r12, rsi
	add r12, rsi

	; actualizo el valor de rsi
	mov rsi, r12

	pxor xmm9, xmm9
	
	movdqu xmm13, [mascara_r]
	movdqu xmm14, [mascara_g]
	movdqu xmm15, [mascara_b]
	
	; Armo el offset
	pxor xmm12, xmm12
	pinsrb xmm12, r8d, 0 ;actual
	pinsrb xmm12, r8d, 4 ;actual
	pinsrb xmm12, r8d, 8 ;actual
	pinsrb xmm12, r8d, 12 ;actual



	
.procesar:
	cmp r12, 16
	jl .abajo 

	; imagen original
	movdqu xmm6, [rdi]

	add rdi, 16
	sub r12, 16

	movdqu xmm7, [rdi]

	add rdi, 16
	sub r12, 16

	movdqu xmm8, [rdi]

	add rdi, 16
	sub r12, 16

	pxor xmm10, xmm10

	; Proceso Pixel 12-15 - BN
	movdqu xmm11, xmm8
	psrldq xmm11, 4
	movdqu xmm0, xmm11
	process_pixels
	movdqu xmm10, xmm4

	; Proceso Pixel 8-11 - BN
	movdqu xmm11, xmm7
	psrldq xmm11, 8
	pslldq xmm8, 8
	por xmm11, xmm8
	movdqu xmm0, xmm11
	process_pixels
	pslldq xmm10, 4
	paddb xmm10, xmm4

	; Proceso Pixel 4-7 - BN
	movdqu xmm11, xmm6
	psrldq xmm11, 12
	pslldq xmm7, 4
	por xmm7, xmm11
	movdqu xmm0, xmm7
	process_pixels
	pslldq xmm10, 4
	por xmm10, xmm4
	
	; Proceso Pixel 0-3 - BN
	movdqu xmm0, xmm6
	process_pixels
	pslldq xmm10, 4
	por xmm10, xmm4
	
	PCMPEQB xmm11, xmm11
	pxor xmm10, xmm11
	
	movdqu [rcx], xmm10
	
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

section data
mascara_r: db 2,255,255,255,5,255,255,255,8,255,255,255,11,255,255,255
mascara_g: db 1,255,255,255,4,255,255,255,7,255,255,255,10,255,255,255
mascara_b: db 0,255,255,255,3,255,255,255,6,255,255,255,9,255,255,255

