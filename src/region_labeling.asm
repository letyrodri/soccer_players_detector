; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Pinta regiones de un mismo color en grayscale

; Parametros
; rdi : dir imagen input - en blanco y negro
; rsi : columnas
; rdx : filas
; rcx : dir imagen output
; r8 : estructura para almacenar equivalencias

global region_labeling

%macro process_pix 2
	;r11d anterior
	mov r9, 5
	pextrb r10d, xmm0, %1 ;arriba
	pextrb r13d, xmm0, %2 ;arriba costado
	pextrb r12d, xmm1, %1 ;actual

	cmp r12b, 0
	je .fin_process_pix%1

	cmp r10b, 0
	jne .usaArriba%1

	cmp r11b, 0
	jne .usaCostado%1

	cmp r13b, 0
	jne .usaArribaCostado%1

	jmp .usaNuevo%1

.usaArriba%1:
	mov r12b, r10b
	; chequeo si hay valor al costado
	cmp r11b, 0
	je .fin_process_pix%1

	cmp r11b, r10b
	je .fin_process_pix%1

	jmp .agregarEquivalencia%1


.usaArribaCostado%1:
	mov r12b, r13b
	jmp .fin_process_pix%1

.usaCostado%1:
	mov r12b, r11b
	jmp .fin_process_pix%1

.usaNuevo%1:
	mov r12b, r15b
	add r15b, 1
	jmp .fin_process_pix%1

.agregarEquivalencia%1:
	; r11 r10
	xor r9, r9
	cmp r11, r10
	jng .continuar_e%1

	;invierte
	mov r9, r11
	mov r11, r10
	mov r10, r9

.continuar_e%1:
	cmp byte [r8+r10], r11b
	je .fin_process_pix%1

	cmp byte [r8+r10], 0
	jne .buscarsiguiente%1

	mov byte [r8+r10], r11b
	jmp .fin_process_pix%1

.buscarsiguiente%1:
	mov byte r9b, [r8+r10]
	mov r10, r9
	jmp .agregarEquivalencia%1

.fin_process_pix%1:
	mov r11b, r12b  ;anterior = actual
	pinsrb xmm1, r12d, %1 ;actual

%endmacro

%macro update_equiv 1
	xor r12, r12
	pextrb r12d, xmm1, %1 ;actual

.buscar_update_equiv%1:
	cmp byte r12b, 0
	je .fin_update_equiv%1
	cmp byte [r8+r12],0
	je .fin_update_equiv%1

	mov byte r12b, [r8+r12]
	jmp .buscar_update_equiv%1

.fin_update_equiv%1:
	pinsrb xmm1, r12d, %1 ;actual

%endmacro

region_labeling:
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
	xor r15, r15
	mov r15b, 1

	push rdi
	push rax
	push rbx
	push rcx

	xor r14, r14
	mov r14b, 1 ; primer columna


.procesar:
	cmp rax, 15
	jl .abajo 
	
	; primera linea
	cmp rbx, rdx
	je .primeraLinea

	sub rdi, rsi
	movdqu xmm0, [rdi]
	add rdi, rsi

.continua:
	movdqu xmm1, [rdi]

	cmp r14b, 0
	jne .primerColumna

	pextrb r10d, xmm1, 0 ;anterior
	mov r11b, r10b

.continuab:
	process_pix 1, 2
	process_pix 2, 3
	process_pix 3, 4
	process_pix 4, 5
	process_pix 5, 6
	process_pix 6, 7
	process_pix 7, 8
	process_pix 8, 9
	process_pix 9, 10
	process_pix 10, 11
	process_pix 11, 12
	process_pix 12, 13
	process_pix 13, 14
	process_pix 14, 15

.siguiente:
	movdqu [rdi], xmm1
	movdqu [rcx], xmm1

	; actualizo contadores
	add rdi, 14
	add rcx, 14

	sub rax, 14

	jmp .procesar

.primerColumna:
	mov r14b, 0
	xor r11d, r11d
	process_pix 0 ,1
	jmp .continuab

.primeraLinea:
	movdqu xmm0, [vacio]
	jmp .continua

.abajo:
	; se ejecuta cuando completa una linea

	cmp rbx, 1
	je .segundoProceso
	
	; resto una linea
	sub rbx, 1

	; avanzo abajo 
	add rax, rsi
	mov r14b, 1
	jmp .procesar

.segundoProceso:
	pop rcx
	pop rbx
	pop rax
	pop rdi
	
.procesar2:
	cmp rax, 15
	jl .abajo2 
	
	movdqu xmm1, [rdi]

.continua2:
	update_equiv 0
	update_equiv 1
	update_equiv 2
	update_equiv 3
	update_equiv 4
	update_equiv 5
	update_equiv 6
	update_equiv 7
	update_equiv 8
	update_equiv 9
	update_equiv 10
	update_equiv 11
	update_equiv 12
	update_equiv 13
	update_equiv 14
	update_equiv 15

.siguiente2:
	movdqu [rcx], xmm1

	; actualizo contadores
	add rdi, 16
	add rcx, 16

	sub rax, 16

	jmp .procesar2

.abajo2:
	; se ejecuta cuando completa una linea

	cmp rbx, 1
	je .fin
	
	; resto una linea
	sub rbx, 1

	; avanzo abajo 
	add rax, rsi
	jmp .procesar2


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
vacio: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0