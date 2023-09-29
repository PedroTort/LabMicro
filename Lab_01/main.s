; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortP_Output
		IMPORT  PortQ_Output
        IMPORT  PortJ_Input	

lista_multiplicadores	EQU	0x20000400

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	MOV 	R9, #1								;Tabuada atual
	MOV		R8, #1								;valor atual
	LDR		R6, = lista_multiplicadores			;pegando endereço na lista de tabuadas	
	MOV		R5, #1
	MOV		R4,	#2_00000000
	
ZeraMemoria	
	CMP		R5,#10
	ITTT		NE
		STRNE	R4, [R6]
		ADDNE	R5, #1
		ADDNE	R6, #1
		BNE ZeraMemoria
	LDR		R6, =lista_multiplicadores							;volta pro endereço inicial
	ADD		R6, R9												;vai para o endereço da tabuada atual
	LDRB	R7,	[R6]											;salva o valor no R7
	ADD		R7, R9
	STRB	R7, [R6]


		

	
MainLoop
; ****************************************
; Escrever código que lê o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************
	B	Loop
	B 	MainLoop
	
		

Loop	

	
	PUSH	{LR}
	BL PortJ_Input
	POP		{LR}
	
	CMP		R0, #2
	PUSH	{LR}
	BLEQ 	Prox_Num_Tabuada
	POP		{LR}
		
		
	CMP 	R0, #1
	PUSH	{LR}
	BLEQ 	Prox_Mult
	POP		{LR}
	
	
	PUSH	{LR}
	BL		Acende_LED
	POP		{LR}
	
;	PUSH	{LR}
;	BL 		SysTick_Wait1ms
;	POP		{LR}
	
	PUSH	{LR}
	BL		Apaga_LED
	POP		{LR}
	
	PUSH	{LR}
	BL 		Pega_Resultado
	POP		{LR}
	
	PUSH	{LR}
	BL		Pega_Dezena
	POP		{LR}
	
;	PUSH	{LR}
;	BL 		SysTick_Wait1ms
;	POP		{LR}
	
	PUSH	{LR}
	BL 		Acende_Display_Dezena
	POP		{LR}
	
;	PUSH	{LR}
;	BL 		SysTick_Wait1ms
;	POP		{LR}
	
	PUSH	{LR}
	BL 		Apaga_Display_Dezena
	POP		{LR}
	
;	PUSH	{LR}
;	BL 		SysTick_Wait1ms
;	POP		{LR}
	
	PUSH	{LR}
	BL		Pega_Unidade
	POP		{LR}
	
	PUSH	{LR}
	BL 		Acende_Display_Unidade
	POP		{LR}
	
	PUSH	{LR}
	BL 		Apaga_Display_Unidade
	POP		{LR}
	
	B		Loop

Prox_Num_Tabuada			;funcao responsavel por atualizar o numero da tabuada atual
	ADD 	R9, #1
	CMP		R9,	#9
	IT		EQ
		MOVEQ R9, #1
		
	LDR		R6, = lista_multiplicadores		;pegando endereço na lista de tabuadas
	ADD		R6,	R9							;vai para o endereço da tabuada atual							
	LDRB		R7,	[R6]						;salva o valor no R7
	
	MOV		R0, #200
	PUSH	{LR}
	BL 		SysTick_Wait1ms
	POP		{LR}
	
	BX		LR

Prox_Mult			;funcao responsavel por pegar o proximo multiplo do numero atual da tabuada		
	
	LDRB		R7,	[R6]
	CMP		R7,	#9
	ITE		EQ
		MOVEQ 	R7, #0
		ADDNE 	R7, #1
	STRB		R7, [R6]

	MOV		R0, #200
	PUSH	{LR}
	BL 		SysTick_Wait1ms
	POP		{LR}
	
	BX		LR	
	
Acende_LED		;LED 0 - A7 || LED 4 - A4 || LED 5 - Q3 || LED 8 - Q0

	MOV		R0, #2_00100000	
	PUSH{LR}
	BL		PortP_Output
	POP{LR}
	
	CMP		R9, #1
	ITT		EQ
		MOVEQ		R0,  #2_10000000				; Inicialização
		MOVEQ		R12, #2_00000000
	
	CMP		R9, #2
	ITT		EQ
		MOVEQ		R0, #2_11000000		; Porta A
		MOVEQ		R12,#2_00000000		; Porta Q

	CMP		R9, #3
	ITT		EQ
		MOVEQ		R0, #2_11100000		; Porta A
		MOVEQ		R12,#2_00000000		; Porta Q
		
	CMP		R9, #4
	ITT		EQ
		MOVEQ		R0, #2_11110000		; Porta A
		MOVEQ		R12,#2_00000000		; Porta Q
		
	CMP		R9, #5
	ITT		EQ
		MOVEQ		R0, #2_11110000		; Porta A
		MOVEQ		R12,#2_00001000		; Porta Q
		
	CMP		R9, #6
	ITT		EQ
		MOVEQ		R0, #2_11110000		; Porta A
		MOVEQ		R12,#2_00001100		; Porta Q
		
	CMP		R9, #7
	ITT		EQ
		MOVEQ		R0, #2_11110000		; Porta A
		MOVEQ		R12,#2_00001110		; Porta Q
		
	CMP		R9, #8
	ITT		EQ
		MOVEQ		R0, #2_11110000		; Porta A
		MOVEQ		R12,#2_00001111		; Porta Q


	PUSH{LR}
	BL		PortA_Output
	POP{LR}
	
	MOV		R0,	R12
	
	PUSH{LR}
	BL		PortQ_Output
	POP{LR}	
	
	BX		LR

Apaga_LED			;apaga os led

	MOV		R0, #5
	PUSH	{LR}
	BL 		SysTick_Wait1ms
	POP		{LR}
	
	MOV		R0, #2_00000000			; Porta PP, "desliga" o transistor e apaga todos os leds
	
	PUSH{LR}
	BL		PortP_Output
	POP{LR}

	BX		LR
	
Pega_Resultado			
	MOV		R5, R7					; Quantidade de vezes que foi multiplicado
	MOV		R8, #0					; Resultado final da multiplicação
	
Multiplicacao_Resultado
	CMP		R5, #0
	ITTT		NE
		ADDNE	R8, R9
		ADDNE	R5, #-1
		BNE		Multiplicacao_Resultado
	
	BX		LR
	
	
Pega_Dezena		;PQ0 - a || PQ1 - b || PQ2 - c || PQ3 - d || PA4 - e || PA5 - f || PA6 - g 

	MOV 	R4, #0					; "Contador"/Valor da dezena
	MOV		R3, #2_0				; binario do A
	MOV		R12, #2_0				; binario do Q
	
	CMP		R8, #10					;Loops para saber o valor da dezena.
	ITTT		CC
		MOVCC	R3, #2_00110000		; binario do display correspondente a porta A
		MOVCC	R12, #2_00001111		; binario do display correspondente a porta Q
		BXCC	LR
	
	CMP		R8, #10
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_00000000
		MOVCS	R12, #2_00000110
		BXCC	LR

	CMP		R8, #20
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_01010000
		MOVCS	R12, #2_00001011
		BXCC	LR
		
	CMP		R8, #30
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_01000000
		MOVCS	R12, #2_00001111
		BXCC	LR
		
	CMP		R8, #40
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_01100000
		MOVCS	R12, #2_00000110
		BXCC	LR
		
	CMP		R8, #50
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_01100000
		MOVCS	R12, #2_00001101
		BXCC	LR
		
	CMP		R8, #60
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_01110000
		MOVCS	R12, #2_00001101
		BXCC	LR
		
	CMP		R8, #70
	ITTTE		CS
		ADDCS	R4, #1
		MOVCS	R3, #2_00000000
		MOVCS	R12, #2_00000111
		BXCC	LR
		
;	CMP		R8, #80
;	ITTTE		CC
;		ADDCS	R4, #1
;		MOVCS	R3, #2_01110000
;		MOVCS	R12, #2_00001111
;		BXCC	LR
		
	
	
Acende_Display_Dezena ;PQ0 - a || PQ1 - b || PQ2 - c || PQ3 - d || PA4 - e || PA5 - f || PA6 - g 

	MOV		R0, #2_000010000			; Porta PP, "acende" o transistor e apaga todos os leds
	
	PUSH{LR}
	BL		PortB_Output
	POP{LR}
	
	MOV		R0, R3

	PUSH{LR}
	BL		PortA_Output
	POP{LR}
	
	MOV		R0,	R12
	
	PUSH{LR}
	BL		PortQ_Output
	POP{LR}
	
	BX		LR
	
Apaga_Display_Dezena

	MOV		R0, #5
	PUSH	{LR}
	BL 		SysTick_Wait1ms
	POP		{LR}
	
	MOV		R0, #2_00000000			; Porta PP, "desliga" o transistor e apaga todos os leds
	
	PUSH{LR}
	BL		PortB_Output
	POP{LR}
	
	;PUSH{LR}
;	BL		PortA_Output
;	POP{LR}
;	
;	PUSH{LR}
;	BL		PortQ_Output
;	POP{LR}

	BX		LR	

Pega_Unidade
	MOV		R10, R8 		; Valor da unidade
	MOV		R11,  R4		; Aux para valor da dezena
	
	
Unidade_Resultado
	CMP		R11, #0
	ITTT		NE
		ADDNE	R10, #-10
		ADDNE	R11, #-1
		BNE		Unidade_Resultado
	
	MOV		R3, #2_0				; binario do A
	MOV		R12, #2_0				; binario do Q
	
	CMP		R10, #0					;Loops para saber o valor da dezena.
	ITTT		EQ
		MOVEQ	R3, #2_00110000		; binario do display correspondente a porta A
		MOVEQ	R12, #2_00001111		; binario do display correspondente a porta Q
		BXEQ	LR
	
	CMP		R10, #1
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_00000000
		MOVEQ	R12, #2_00000110
		BXEQ	LR

	CMP		R10, #2
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01010000
		MOVEQ	R12, #2_00001011
		BXEQ	LR
		
	CMP		R10, #3
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01000000
		MOVEQ	R12, #2_00001111
		BXEQ	LR
		
	CMP		R10, #4
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01100000
		MOVEQ	R12, #2_00000110
		BXEQ	LR
		
	CMP		R10, #5
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01100000
		MOVEQ	R12, #2_00001101
		BXEQ	LR
		
	CMP		R10, #6
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01110000
		MOVEQ	R12, #2_00001101
		BXEQ	LR
		
	CMP		R10, #7
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_00000000
		MOVEQ	R12, #2_00000111
		BXEQ	LR
		
	CMP		R10, #8
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01110000
		MOVEQ	R12, #2_00001111
		BXEQ	LR
		
	CMP		R10, #9
	ITTTT		EQ
		ADDEQ	R4, #1
		MOVEQ	R3, #2_01100000
		MOVEQ	R12, #2_00000111
		BXEQ	LR
	
	BX		LR

Acende_Display_Unidade
	MOV		R0, #2_000100000			; Porta PP, "desliga" o transistor e apaga todos os leds
	
	PUSH{LR}
	BL		PortB_Output
	POP{LR}

	MOV		R0, R3

	PUSH{LR}
	BL		PortA_Output
	POP{LR}
	
	MOV		R0,	R12
	
	PUSH{LR}
	BL		PortQ_Output
	POP{LR}
	
	BX		LR

Apaga_Display_Unidade

	MOV		R0, #5
	PUSH	{LR}
	BL 		SysTick_Wait1ms
	POP		{LR}
	
	MOV		R0, #2_00000000			; Porta PP, "desliga" o transistor e apaga todos os leds
	
	PUSH{LR}
	BL		PortB_Output
	POP{LR}
	
	BX		LR	
		
	

;--------------------------------------------------------------------------------
; Função Pisca_LED
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;Pisca_LED
; ****************************************
; Escrever função que acende o LED, espera 1 segundo, apaga o LED e espera 1 s
; Esta função deve chamar a rotina SysTick_Wait1ms com o parâmetro de entrada em R0
; ****************************************
;	BL PortN_Output
;	B Pisca_LED

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
