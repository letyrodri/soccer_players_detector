; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Toma metricas sobre la region
; Recibe una imagen pintada x regiones
; cuenta la cantidad de pixeles de cada region

; Parametros
; rdi : dir imagen input grayscale regiones
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : temporal arreglo 256 enteros donde cuento los pixeles
; r9 : resultado final, estructura ordenada de mayor a menor de color-cantidad

global region_metrics

%macro process_pix 1
    
    xor r12, r12
	pextrb r12d, xmm1, %1  ; actual
	cmp r12d, 0
	je .finmacro%1

	add dword [r8+r12*4], 1

.finmacro%1:


%endmacro


%macro sortColors 0
	
	xor r15, r15
	
.repetirSort:
	maxColor r15
	
	cmp r10b, 0
	je .finSort

	cmp r15b, 255
	je .finSort

	mov r11, r9
	add r11,r15
	add r11,r15
	add r11,r15
	add r11,r15
	add r11,r15
	

	mov byte [r11],r10b

	add r11,1

	mov r14d, [r8+r10*4] 
	mov dword [r11],r14d

	mov dword [r8+r10*4],0
	
	inc r15

	jmp .repetirSort

.finSort:
	xor r15, r15

%endmacro

%macro maxColor 1
	xor r12,r12
	mov r11, 255
	mov r10, 0 ;maximo

.repetir%1:
	mov dword r12d, [r8+r10*4]
	mov dword r13d, [r8+r11*4]
	
	cmp r12d, r13d
	jg .continuar%1
	
	mov r10b, r11b

.continuar%1:	
	dec r11
	jnz .repetir%1

	

%endmacro


region_metrics:
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

	; color
	mov r15d, 20

	mov qword [inicio], rdi

	pxor xmm0, xmm0
	xor r11,r11
	xor r10, r10
	xor r14, r14

.procesar:
	cmp rax, 15
	jl .abajo 
	
	movdqu xmm1, [rdi]
	
	process_pix 0
	process_pix 1
	process_pix 2
	process_pix 3
	process_pix 4
	process_pix 5
	process_pix 6
	process_pix 7
	process_pix 8
	process_pix 9
	process_pix 10
	process_pix 11
	process_pix 12
	process_pix 13
	process_pix 14
	process_pix 15

	movdqu [rcx], xmm1
.siguiente:
	
	; actualizo contadores
	add rdi, 16
	add rcx, 16	
	sub rax, 16

	jmp .procesar

.abajo:
	; se ejecuta cuando completa una linea

	cmp rbx, 1
	je .segundaParte
	
	; resto una linea
	sub rbx, 1

	; avanzo abajo 
	add rax, rsi
	
	jmp .procesar

.segundaParte:
	sortColors

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
inicio: dq 0
