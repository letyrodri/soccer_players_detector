; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Filtra regiones que tienen entre y pixeles

; Parametros
; rdi : dir imagen input - in grayscale
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : colores y cantidades en regiones contabilizados
;      dir arreglo 256 de estructura color/cantidad 
;typedef struct __attribute__((packed)) { 
;	unsigned char color;
;	int qty;
;} region_data_type ;

; r9 : dir estructura - rango de pixeles
;typedef struct __attribute__((packed)) {
;	int from;
;	int to;
;} t_color_range;


global filter_regions

con: db 0

filter_regions:
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

	pxor xmm0, xmm0
	xor r11,r11
	xor r10, r10
	xor r14, r14

	xor r12, r12
	xor r13, r13
	;from
	mov dword r12d, [r9]
	;to
	mov dword r13d, [r9+4]
	

	mov r10, 0

.init_color:
	cmp rax, 1
	jl .abajo 
	
	movdqu xmm0, [rdi]
	pxor xmm2, xmm2
	mov r10, 0

.process_color:
	mov r11, r8
	add r11,r10
	add r11,r10
	add r11,r10
	add r11,r10
	add r11,r10
	
	; color
	xor r14,r14
	mov byte r14b, [r11]

	; cantidad
	add r11,1
	mov dword r15d, [r11]

	cmp r15, 1
	jle .fin_procesar

	pxor xmm1, xmm1

	cmp r15, r12
	jle .prox_color
	cmp r15, r13 
	jg .prox_color

	;mov r14, 0x01
	pinsrw xmm1, r14d, 0 
	pinsrw xmm1, r14d, 1 
	pinsrw xmm1, r14d, 2
	pinsrw xmm1, r14d, 3 
	pinsrw xmm1, r14d, 4 
	pinsrw xmm1, r14d, 5 
	pinsrw xmm1, r14d, 6
	pinsrw xmm1, r14d, 7 	

.procesar:

	movdqu xmm3, xmm0
	movdqu xmm4, xmm0

	pxor xmm11, xmm11
	punpcklbw xmm3, xmm11
	punpckhbw xmm4, xmm11

	
	pcmpeqw xmm3, xmm1
	pcmpeqw xmm4, xmm1
	
	packsswb xmm3, xmm4
	
	movdqu xmm4, xmm0
	pand xmm4, xmm3

	paddb xmm2, xmm4

.prox_color:
	inc r10

	jmp .process_color

.fin_procesar:
	movdqu [rcx], xmm2


.siguiente:
	
	; actualizo contadores
	add rdi, 16
	add rcx, 16
	sub rax, 16

	jmp .init_color

.abajo:
	; se ejecuta cuando completa una linea

	cmp rbx, 1
	je .fin
	
	; resto una linea
	sub rbx, 1

	; avanzo abajo 
	add rax, rsi
	
	jmp .init_color


.fin:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 24
	pop rbp
	ret



