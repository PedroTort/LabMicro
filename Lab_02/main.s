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
senha	  					SPACE 4
tentativa 					SPACE 4	
quantidade_digitos_corretos SPACE 1
senha_mestra 				SPACE 4 	;0000


GPIO_PORTJ_AHB_ICR_R		EQU		0x4006041C
	
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
		IMPORT  SysTick_Wait1us			
		IMPORT  GPIO_Init
		IMPORT  PortL_Input
		IMPORT  PortM_Dir
		IMPORT  PortM_Output
		IMPORT  Display_Init
		IMPORT  Display_Config
		IMPORT	Display_Clear
		IMPORT	Display_Write
		IMPORT 	Interrupt_Init
		IMPORT	Led_Enable
			
		EXPORT GPIOPortJ_Handler
			

STRING_ABERTO		DCB		"Cofre Aberto@Senha:", 0
STRING_ABRINDO		DCB		"Cofre Abrindo", 0
STRING_FECHADO		DCB		"Cofre Fechado@Senha:", 0
STRING_FECHANDO		DCB		"Cofre Fechando", 0
STRING_TRANCADO		DCB		"Cofre Trancado", 0
STRING_MESTRA		DCB		"Senha Mestra@Senha:", 0
STRING_ASTERISCO	DCB		"*", 0
; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ; Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ; Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ; Chama a subrotina que inicializa os GPIO
	BL Interrupt_Init
	BL Display_Init
	LDR R8, =senha
	LDR R7, =senha_mestra
	MOV R3, #0					 ; Coisa feia
	STRB R3, [R7]
	ADD R7, #1
	STRB R3, [R7]
	ADD R7, #1
	STRB R3, [R7]
	ADD R7, #1
	STRB R3, [R7]
	LDR R7, =tentativa
	LTORG
	MOV	R10, #0					 ; Aux para fazer o shift no r0!
	MOV R11, #0 				 ; Variavel para saber quan7tos digitos ja foram pressionados
	MOV R12, #0					 ; Variavel para saber o estado atual do cofre (0-aberto, 1-fechando, 2-fechado, 3-Abrindo, 4-Trancado) 
	MOV R6, #0					 ; Numero de tentativas de abrir o cofre!
	MOV R5, #0
	

MainLoop

	BL Display_Clear
	BL EscreveTextoLCD
	BL ConfiguraTeclado
	B LoopLeColuna

		
ConfiguraTeclado
	MOV R0, #0
	PUSH{LR}
	BL	PortM_Dir
	POP{LR}
	BX LR


LoopLeColuna	; ele só ta pegando a primeira coluna! ver esse R10 ai/rever o PortM_Dir e o PortM_Output			
	MOV R0, #1	; 
	LSL R0, #4
	MOV R9, #0 	; Variavel que recebe o valor da tecla digitada
	LSL R0, R10		; Primeira coluna recebe 0
		CMP R10, #4
		ITE NE
			ADDNE R10, #1
			MOVEQ R10,#0
	
	PUSH{LR}
	BL PortM_Dir
	POP{LR}
	
	PUSH{LR}
	BL	PortM_Output
	POP{LR}
	
	CMP R11, #4
		PUSH{LR}
		BLEQ EsperaEnter
		POP{LR}
		
	CMP R12, #5
		PUSH{R0}
		BLEQ LoopLeds
		POP{R0}
		
	CMP R0, #2_00010000 					
		PUSH{LR}
		BLEQ VarrePrimeiraColuna
		POP{LR}
		
	CMP R0, #2_00100000
		PUSH{LR}
		BLEQ VarreSegundaColuna
		POP{LR}
		
	CMP R0, #2_01000000			
		PUSH{LR}
		BLEQ VarreTerceiraColuna
		POP{LR}
		
	CMP R0, #2_10000000
		PUSH{LR}
		BLEQ VarreQuartaColuna
		POP{LR}

	B LoopLeColuna


EscreveTextoLCD

	MOV R2, #0
	MOV R3, #0
	
	PUSH{LR}
	BL Display_Clear
	POP{LR}
	
	CMP R6, #3
		MOVEQ R12, #4
	
	CMP R12, #0
		LDREQ R4,=STRING_ABERTO		; string para o display
	
	CMP R12, #1
		LDREQ R4, =STRING_FECHANDO
	
	CMP R12, #2
		LDREQ R4, =STRING_FECHADO
	
	CMP R12, #3
		LDREQ R4, =STRING_ABRINDO
	
	CMP R12, #4
		LDREQ R4, =STRING_TRANCADO
	
	CMP R12, #5
		LDREQ R4, =STRING_MESTRA
		
EscreveString
	LDRB R5, [R4, R3]
	ADD R3, R3, #1			; indice do vetor que vai ser lido
	
	CMP R5, #0				; Checa se acabou a string
		BEQ TerminouLCD		

	CMP  R5, #0x40  		; Checa por nova linha, se for nao imprime
		BNE AtualizaDisplay
	
	MOV R0, #0xC0			; Pula para segunda linha
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	B EscreveString


AdicionaDigito
	PUSH{LR}
	LDR R4, =STRING_ASTERISCO
	LDRB R5, [R4]
	MOV R0, R5
	
	PUSH{LR}
	BL Display_Write
	POP{LR}
	
	POP{LR}
	BX LR


AtualizaDisplay	
	MOV R0, R5
	PUSH{LR}
	BL Display_Write
	POP{LR}
	
	B EscreveString
	
	
TerminouLCD			
	MOV R0,#200
	PUSH{LR}
	BL SysTick_Wait1ms
	POP {LR}

	MOV R0, #5000
	CMP R12, #1
		PUSH{LR}	
		BLEQ SysTick_Wait1ms
		POP {LR}
	
	CMP R12, #1
		ITT EQ
			MOVEQ R12, #2	
			BEQ EscreveTextoLCD
		
	MOV R0, #5000
	CMP R12, #3
		PUSH{LR}	
		BLEQ SysTick_Wait1ms
		POP {LR}
		
	CMP R12, #3			; ta certo?
		ITT EQ
			MOVEQ R12, #0	
			BEQ EscreveTextoLCD

	CMP R12, #4
		BEQ.W LoopCofreTravado ;.W eh o sufixo para branch de 32 bits
	
	B LoopLeColuna


EsperaEnter
	
	MOV R0, #2_01000000 ; Transformando terceira coluna na que vai ser usada
	
	PUSH{LR, R0}
	BL PortM_Dir
	POP{LR, R0}
	
	PUSH{LR}
	BL	PortM_Output
	POP{LR}

	PUSH{LR}
	BL	PortL_Input
	POP{LR}

	PUSH{R0, LR}
	MOV R0, #50
	BL SysTick_Wait1ms
	POP{R0, LR}

	CMP R2, #7
		BEQ ApertouEnter

	CMP R12, #5
		PUSH{R0}
		BLEQ LoopLeds
		POP{R0}

	B EsperaEnter


ApertouEnter
	;(0-aberto, 1-fechando, 2-fechado, 3-Abrindo, 4-Trancado) 
	MOV R11, #0
	
	LDREQ R4,=quantidade_digitos_corretos
	LDR R8, =senha		;pegando endereco 
	LDR R7, =tentativa	

	CMP R12, #0
		MOVEQ R12, #1
		
	CMP R12, #2
		ITTT EQ
			MOVEQ R0,#0
			STRBEQ R0, [R4]
			BEQ ComparaSenhaTentativa	
				
	CMP R12, #5
		ITTTT EQ
			LDREQ R8,=senha_mestra
			MOVEQ R0,#0
			STRBEQ R0, [R4]
			BEQ ComparaSenhaMestra
	
	B EscreveTextoLCD
	
SalvaDigitoSenha
		
	CMP R12, #0
	ITTTT	EQ				
		STRBEQ R9, [R8]
		ADDEQ		R8, #1		
		ADDEQ R11, #1
		BLEQ AdicionaDigito
	
	CMP R12, #2
	ITTTT	EQ				
		STRBEQ R9, [R7]
		ADDEQ R7, #1		
		ADDEQ R11, #1
		BLEQ AdicionaDigito
		
	CMP R12, #5
	ITTTT	EQ				
		STRBEQ R9, [R7]
		ADDEQ R7, #1		
		ADDEQ R11, #1
		BLEQ AdicionaDigito
	
		
	B LoopLeColuna

ComparaSenhaTentativa
	
	CMP R6, #3			   ; Caso falhe mais que 3 vezes
		BLCS BloqueiaCofre
		
	LDRB R5, [R8]		
	LDRB R9, [R7]
	
	CMP R5, R9
		ITTTT		NE
			ADDNE	R6, #1
			LDRNE R8,=senha
			LDRNE R7,=tentativa
			BNE		EscreveTextoLCD
				
	CMP R5, R9
		ITTTT		EQ
			ADDEQ	R8, #1
			ADDEQ	R7, #1
			ADDEQ 	R0, #1
			STRBEQ	R0, [R4]
	
	
	CMP	R0, #4
		ITTTT	EQ
			MOVEQ R12, #3
			LDREQ R8,=senha
			LDREQ R7,=tentativa
			BEQ EscreveTextoLCD

	B ComparaSenhaTentativa

ComparaSenhaMestra	

	LDRB R5, [R8]		;salvando o valor do endereco
	LDRB R9, [R7]
	
	CMP R5, R9
		ITTT	NE
			LDRNE R8,=senha_mestra
			LDRNE R7,=tentativa
			BNE		EscreveTextoLCD
				
	CMP R5, R9
		ITTTT		EQ
			ADDEQ	R8, #1
			ADDEQ	R7, #1
			ADDEQ 	R0, #1
			STRBEQ	R0, [R4]
	
	
	CMP	R0, #4
		ITTTT	EQ
			MOVEQ R12, #3
			LDREQ R8,=senha
			LDREQ R7,=tentativa
			BEQ EscreveTextoLCD

	B ComparaSenhaMestra

BloqueiaCofre
	LDR R8,=senha
	LDR R7,=tentativa
	MOV R6, #0
	
LoopCofreTravado
	CMP R5,#5	;maneira porca, mas é o que tem
		BEQ CofreDestrava	
	BL LoopLeds
	B LoopCofreTravado
	
LoopLeds
	PUSH{LR}
	MOV R0, #0x20				; Acende LEDs
	BL Led_Enable
			
	MOV R0,#100
	BL SysTick_Wait1ms
	
	MOV R0, #0x00				; Apaga LEDs
	BL Led_Enable

	MOV R0,#100
	BL SysTick_Wait1ms
	POP{LR}
	BX LR


CofreDestrava
	MOV R12, #5
	MOV R6, #0
	B EscreveTextoLCD
	
VarrePrimeiraColuna			;Olhe as teclas de cima para baixo
	PUSH{LR}
	BL	PortL_Input
	POP{LR}
	
	PUSH{R0, R2, LR}
	MOV R0, #150
	BL SysTick_Wait1ms
	POP{R0, R2, LR}
	
	
	CMP	R2, #2_1110	;Caso apertou a primeira tecla
		MOVEQ	R9, #1
		
	CMP	R2, #2_1101 	;Caso apertou a segunda tecla
		MOVEQ	R9, #4

	CMP	R2, #2_1011 	;Caso apertou a terceira tecla
		MOVEQ	R9, #7

	CMP	R2, #2_0111 	;Caso apertou a quarta tecla
		MOVEQ	R9, #14
	
	CMP R2, #0xF
		PUSH{LR}	
		BLNE SalvaDigitoSenha
		POP{LR}
		
	
	BX LR
	
VarreSegundaColuna			;Olhe as teclas de cima para baixo
	PUSH{LR}
	BL	PortL_Input
	POP{LR}
	
	PUSH{R0, R2, LR}
	MOV R0, #150
	BL SysTick_Wait1ms
	POP{R0, R2, LR}
	
	CMP	R2, #2_1110	;Caso apertou a primeira tecla
		MOVEQ	R9, #2
		
	CMP	R2, #2_1101 	;Caso apertou a segunda tecla
		MOVEQ	R9, #5

	CMP	R2, #2_1011 	;Caso apertou a terceira tecla
		MOVEQ	R9, #8

	CMP	R2, #2_0111 	;Caso apertou a quarta tecla
		MOVEQ	R9, #0

	CMP R2, #0xF
		PUSH{LR}	
		BLNE SalvaDigitoSenha
		POP{LR}
		
	POP{R2,R9}	
	
	BX LR

VarreTerceiraColuna			;Olhe as teclas de cima para baixo
	PUSH{LR}
	BL	PortL_Input
	POP{LR}
	
	PUSH{R0, R2, LR}
	MOV R0, #150
	BL SysTick_Wait1ms
	POP{R0, R2, LR}
	
	CMP	R2, #2_1110	;Caso apertou a primeira tecla
		MOVEQ	R9, #3
		
	CMP	R2, #2_1101 	;Caso apertou a segunda tecla
		MOVEQ	R9, #6

	CMP	R2, #2_1011 	;Caso apertou a terceira tecla
		MOVEQ	R9, #9
	
	CMP R2, #0xF
		PUSH{LR}	
		BLNE	SalvaDigitoSenha
		POP{LR}
		
	POP{R2,R9}	

	BX LR

VarreQuartaColuna			;Olhe as teclas de cima para baixo
	PUSH{LR}
	BL	PortL_Input
	POP{LR}
	
	PUSH{R0, R2, LR}
	MOV R0, #150
	BL SysTick_Wait1ms
	POP{R0, R2, LR}
	
	CMP	R2, #2_1110	;Caso apertou a primeira tecla
		MOVEQ	R9, #10
		
	CMP	R2, #2_1101 	;Caso apertou a segunda tecla
		MOVEQ	R9, #11

	CMP	R2, #2_1011 	;Caso apertou a terceira tecla
		MOVEQ	R9, #12

	CMP	R2, #2_0111 	;Caso apertou a quarta tecla
		MOVEQ	R9, #13
	
	CMP R2, #0xF
		PUSH{LR}	
		BLNE	SalvaDigitoSenha
		POP{LR}
	
	BX LR
	
GPIOPortJ_Handler 	;Acho que é isso <-
	PUSH{R0,R2,R4}
	LDR 	R4, =GPIO_PORTJ_AHB_ICR_R
	MOV     R2, #2_1			
	STR     R2, [R4]
	
	CMP R12, #4
	IT EQ
		MOVEQ R5, #5
	POP{R0,R2,R4}
	BX LR


; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
