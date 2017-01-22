; Organizacion del Computador II
; TP Final - Leticia Rodriguez
; Abril 2016

; Detecta los bordes en una imagen

; Parametros
; rdi : dir imagen input - grayscale preferentemente en blanco y negro
; rsi : columnas
; rdx : filas
; rcx : dir imagen output

global sobel

sobel:
	push rbp
	mov rbp, rsp
  sub rsp, 24
	push r12 	
	push r13 	
	push r14 	
	push r15        
	push rbx       

	; Guardo los parametros en los registros
	mov r12, rsi ; columnas
	mov r13, rdx ; filas
	
	; actualizo el valor de rsi
	mov rsi, r12

	mov r9, rdi
	add r9, rsi

	mov r10, r9
	add r10, rsi

	pxor    xmm15, xmm15
  movdqu xmm14, [threshold]

.procesar:
	cmp r12, 15
	jl .abajo 

	; imagen original
	;--------- ROW 1 ------------
	
	movdqu xmm0, [rdi]
	movdqu xmm1, xmm0
	movdqu xmm2, xmm0

	; alineo
	psrldq  xmm1, 1
  psrldq  xmm2, 2
	
  ; transformo a word para operar 
  ; PARTE ALTA
  movdqa xmm3, xmm0
  movdqa xmm4, xmm1
  movdqa xmm5, xmm2

  punpckhbw xmm3, xmm15 ; F1
  punpckhbw xmm4, xmm15 ; F1
  punpckhbw xmm5, xmm15 ; F1

  pxor xmm9, xmm9
  paddw xmm9, xmm5
  psubw xmm9, xmm3

  pxor xmm11, xmm11
	psubw xmm11, xmm3
	psubw xmm11, xmm4
	psubw xmm11, xmm4
	psubw xmm11, xmm5


  ; PARTE BAJA
  movdqa xmm3, xmm0
  movdqa xmm4, xmm1
  movdqa xmm5, xmm2

  punpcklbw xmm3, xmm15 ; F1
  punpcklbw xmm4, xmm15 ; F1
  punpcklbw xmm5, xmm15 ; F1

  pxor xmm10, xmm10
  paddw xmm10, xmm5
	psubw xmm10, xmm3
    
	pxor xmm12, xmm12
	psubw xmm12, xmm3
	psubw xmm12, xmm4
	psubw xmm12, xmm4
	psubw xmm12, xmm5

	;--------- ROW 2 ---------------
	movdqu xmm0, [r9]
	movdqu xmm1, xmm0
	movdqu xmm2, xmm0

	; alineo
	psrldq  xmm1, 1
  psrldq  xmm2, 2
	
  ; transformo a word para operar 
  ; PARTE ALTA
  movdqa xmm3, xmm0
  movdqa xmm4, xmm1
  movdqa xmm5, xmm2

  punpckhbw xmm3, xmm15 ; F1
  punpckhbw xmm4, xmm15 ; F1
  punpckhbw xmm5, xmm15 ; F1
  paddw xmm9, xmm5
  paddw xmm9, xmm5
  psubw xmm9, xmm3
  psubw xmm9, xmm3

  ; PARTE BAJA
  movdqa xmm3, xmm0
  movdqa xmm4, xmm1
  movdqa xmm5, xmm2

  punpcklbw xmm3, xmm15 ; F1
  punpcklbw xmm4, xmm15 ; F1
  punpcklbw xmm5, xmm15 ; F1

  paddw xmm10, xmm5
  paddw xmm10, xmm5
  psubw xmm10, xmm3
  psubw xmm10, xmm3

   
  ; FIN SEGUNDA LINEA

	;--------- ROW 3 ---------------

	movdqu xmm0, [r10]
	movdqu xmm1, xmm0
	movdqu xmm2, xmm0

;	; alineo
	psrldq  xmm1, 1
   psrldq  xmm2, 2
	
;   ; transformo a word para operar 
;   ; PARTE ALTA
   movdqa xmm3, xmm0
   movdqa xmm4, xmm1
   movdqa xmm5, xmm2

   punpckhbw xmm3, xmm15 ; F1
   punpckhbw xmm4, xmm15 ; F1
   punpckhbw xmm5, xmm15 ; F1

   psubw xmm9, xmm3
   paddw xmm9, xmm5
    
   paddw xmm11, xmm3
   paddw xmm11, xmm4
   paddw xmm11, xmm4
   paddw xmm11, xmm5

;   
;  ; PARTE BAJA
   movdqa xmm3, xmm0
   movdqa xmm4, xmm1
   movdqa xmm5, xmm2

   punpcklbw xmm3, xmm15 ; F1
   punpcklbw xmm4, xmm15 ; F1
   punpcklbw xmm5, xmm15 ; F1

   psubw xmm10, xmm3
   paddw xmm10, xmm5

   paddw xmm12, xmm3
   paddw xmm12, xmm4
   paddw xmm12, xmm4
   paddw xmm12, xmm5
  ; FIN TERCERA LINEA

 	
	; Elaboro los cuadrados
	pmullw  xmm9, xmm9      
    pmullw  xmm10, xmm10
    pmullw  xmm11, xmm11
    pmullw  xmm12, xmm12
    
    paddw   xmm9, xmm11     
    paddw   xmm10, xmm12
   
    movdqa  xmm1, xmm9
    movdqa  xmm3, xmm10
    
    ; paso a doubleword
    punpcklwd xmm9, xmm15   
    punpckhwd xmm1, xmm15   
    punpcklwd xmm10, xmm15    
    punpckhwd xmm3, xmm15   
    
    ; convierto a flotante
    cvtdq2ps  xmm0, xmm9    
    cvtdq2ps  xmm1, xmm1    
    cvtdq2ps  xmm2, xmm10   
    cvtdq2ps  xmm3, xmm3    
    
    ; opero en flotante
    sqrtps    xmm0, xmm0    
    sqrtps    xmm1, xmm1    
    sqrtps    xmm2, xmm2    
    sqrtps    xmm3, xmm3

    ; vuelvo a double word    
    cvttps2dq  xmm0, xmm0    
    cvttps2dq  xmm1, xmm1    
    cvttps2dq  xmm2, xmm2   
    cvttps2dq  xmm3, xmm3

    ; empaqueto
    packusdw xmm0,xmm1 
    packusdw xmm2,xmm3

    packuswb xmm2, xmm0 
   
    ; Threshold
   
    ; pcmpgtb xmm2, xmm14
    ; copio a la imagen original
	movdqu [rcx], xmm2

	add rdi, 14
	add r9, 14
	add r10, 14

	add rcx, 14
	sub r12, 14

	jmp .procesar
	
.abajo:
	; se ejecuta cuando completa una linea

	; si quedan 2 lineas termino
	cmp r13, 3
	je .fin
	
	; resto una linea
	sub r13, 1

	; avanzo abajo 
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
threshold: db 80, 80, 80, 80,  80, 80, 80, 80,  80, 80, 80, 80,  80, 80, 80, 80
threshold3: db 60, 60, 60, 60,  60, 60, 60, 60,  60, 60, 60, 60,  60, 60, 60, 60
threshold2: db 40, 40, 40, 40,  40, 40, 40, 40,  40, 40, 40, 40,  40, 40, 40, 40
