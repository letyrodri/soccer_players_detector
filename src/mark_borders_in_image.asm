; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Combina la imagen original del video con los bordes detectados

; Parametros
; rdi : dir imagen input color original del video
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : dir imagen bordes marcados - blanco y negro
global mark_borders_in_image

mark_borders_in_image:
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
	add r12, rsi
	add r12, rsi

	mov r13, rdx ;filas
	mov r14, rdi ;input

	mov rsi, r12

	movdqu xmm4, [mascara1]
	movdqu xmm5, [mascara2]
	movdqu xmm6, [mascara3]
	
	movdqu xmm7, [color1]
	movdqu xmm8, [color2]
	movdqu xmm9, [color3]
	
	pxor xmm10, xmm10  ;todos 1s
	

.procesar:
	cmp r12, 1
	jl .abajo 

	; imagen original
	movdqu xmm0, [rdi]
	movdqu xmm1, [rdi+16]
	movdqu xmm2, [rdi+32]
	
	movdqu xmm3, [r8]

	movdqu xmm11, xmm3
	movdqu xmm12, xmm3
	movdqu xmm13, xmm3
	
	pshufb xmm11, xmm4
	pshufb xmm12, xmm5
	pshufb xmm13, xmm6
		
	pand xmm11, xmm7
	por xmm11, xmm0

	pand xmm12, xmm8
	por xmm12, xmm1

	pand xmm13, xmm9
	por xmm13, xmm2

	movdqu [rcx], xmm11
	movdqu [rcx+16], xmm12
	movdqu [rcx+32], xmm13

	add rdi, 48
	add r8, 16
	sub r12, 48 
	add rcx, 48

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

section .data

;GBR
mascara3: db 10,11,11,11,12,12,12,13,13,13,14,14,14,15,15,15
mascara2: db 5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10
mascara1: db 0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5

color1: db 0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00
color2: db 0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00
color3: db 0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF,0x00,0x00,0xFF