; teclado.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports

; PORT L
GPIO_PORTL_LOCK_R    	EQU    0x40062520
GPIO_PORTL_CR_R      	EQU    0x40062524
GPIO_PORTL_AMSEL_R   	EQU    0x40062528
GPIO_PORTL_PCTL_R    	EQU    0x4006252C
GPIO_PORTL_DIR_R     	EQU    0x40062400
GPIO_PORTL_AFSEL_R   	EQU    0x40062420
GPIO_PORTL_DEN_R     	EQU    0x4006251C
GPIO_PORTL_PUR_R     	EQU    0x40062510	
GPIO_PORTL_DATA_R    	EQU    0x400623FC
GPIO_PORTL_DATA_BITS_R  EQU    0x40062000
GPIO_PORTL              EQU    2_000010000000000	

; PORT M
GPIO_PORTM_LOCK_R    	EQU    0x40063520
GPIO_PORTM_CR_R      	EQU    0x40063524
GPIO_PORTM_AMSEL_R   	EQU    0x40063528
GPIO_PORTM_PCTL_R    	EQU    0x4006352C
GPIO_PORTM_DIR_R     	EQU    0x40063400
GPIO_PORTM_AFSEL_R   	EQU    0x40063420
GPIO_PORTM_DEN_R     	EQU    0x4006351C
GPIO_PORTM_PUR_R     	EQU    0x40063510	
GPIO_PORTM_DATA_R    	EQU    0x400633FC
GPIO_PORTM_DATA_BITS_R  EQU    0x40063000
GPIO_PORTM              EQU    2_000100000000000	
	



; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2        
        
        EXPORT Teclado_GPIO_Init
        EXPORT EsperaConfiguracao
		IMPORT SysTick_Wait1ms
		IMPORT SysTick_Wait1us

Teclado_GPIO_Init
	; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
	LDR	R0, =SYSCTL_RCGCGPIO_R  ;Carrega o endereao do registrador RCGCGPIO
	LDR R1, [R0]
	ORR	R1, #GPIO_PORTL         ; teclado - PINOS LINHAS 
	ORR R1, #GPIO_PORTM			; teclado - PINOS COLUNAS
   STR R1, [R0]				;Move para a memoria os bits das portas no endereao do RCGCGPIO

	; verificar no PRGPIO se a porta esta pronta para uso.
	LDR R0, =SYSCTL_PRGPIO_R	;Carrega o endereao do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  
	LDR R1, [R0]				;Le da memoria o conteado do endereao do registrador
	MOV R2, #GPIO_PORTL
	ORR R2, #GPIO_PORTM
	AND R1, R1, R2		;seleciona apenas os bits das portas referentes
	TST R1, R2			;compara se os bits estao iguais
	BEQ EsperaGPIO	;Se o flag Z=1, volta para o laao. Senao continua executando
   
	; 2. Limpar o AMSEL para desabilitar a analagica
	LDR R0, =GPIO_PORTL_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0xF	; L0 a L3 = 0 : desabilita analogica
	STR R1, [R0]
	
	LDR R0, =GPIO_PORTM_AMSEL_R
	LDR R1, [R0]
	BIC R1, #0xF0	; M4 a M7 = 0 : desabilita analogica
	STR R1, [R0]
   
	; 3. Limpar PCTL para selecionar o GPIO
	LDR R0, =GPIO_PORTL_PCTL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: seleciona modo GPIO
	STR R1, [R0]
	
	LDR R0, =GPIO_PORTM_PCTL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF0	;M4 a M7 = 0: seleciona modo GPIO
	STR R1, [R0]

	; 4. DIR para 0: input (BIC), 1: output (ORR)
   LDR R0, =GPIO_PORTL_DIR_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: INPUT
   STR R1, [R0]
	
   LDR R0, =GPIO_PORTM_DIR_R
	LDR R1, [R0]
	ORR	R1, R1, #0xF0	;M4 a M7 = 1: OUTPUT
   STR R1, [R0]
	
	; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
	LDR R0, =GPIO_PORTL_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF	;L0 a L3 = 0: sem funcao alternativa
	STR R1, [R0]
	LDR R0, =GPIO_PORTM_AFSEL_R
	LDR R1, [R0]
	BIC R1, R1, #0xF0	;M4 a M7 = 0: sem funcao alternativa
	STR R1, [R0]
	
	; 6. Setar os bits de DEN para habilitar I/O digital
	LDR R0, =GPIO_PORTL_DEN_R	;carrega o endereao do DEN
	LDR R1, [R0]
	ORR R1, R1, #0xF	;L0 a L3 = 1: habilita I/O digital
	STR R1, [R0]
   
	LDR R0, =GPIO_PORTM_DEN_R
	LDR R1, [R0]
	ORR R1, R1, #0xF0	;M4 a M7 = 1: habilita I/O digital
	STR R1, [R0]
   
	; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
	LDR R0, =GPIO_PORTL_PUR_R	;Carrega o endereao do PUR
	LDR R1, [R0]
	ORR R1, R1, #0xF	;L0 a L3 = 1: habilita funcionalidade digital de resistor de pull-up
   STR R1, [R0]

	BX  LR ;return


PortL_Input
	PUSH{R0,R1}
	LDR	R1, =GPIO_PORTL_DATA_R	
	LDR R2,[R1]   ;pega qual tecla ta pressionada
	POP{R0,R1}
	BX LR
	
PortM_Output			; Fazendo com que a coluna que vai ser usada receba 0 e as demais 1
	PUSH{R0,R1,R2}		; Configura todas as portas que nao vao ser usadas como saida
	LDR R1, =GPIO_PORTM_DATA_R	
	EOR R0, #2_11111111	
	STR R0, [R1]
	POP{R0,R1,R2}
	BX LR

PortM_Dir				; Fazendo com que a coluna que vai ser usada receba 1 e as demais 0					
	PUSH{R0,R1,R2}		; Configura a porta vai ser usada como entrada
	LDR	R1, =GPIO_PORTM_DIR_R				
	LDR R2, [R1]
	BIC R2, #2_11110000 
	ORR R0, R0, R2                       
	STR R0, [R1]  
	
	POP{R0,R1,R2}	
	BX LR

EsperaConfiguracao
	
	MOV R0, #2_10000000 ; Transformando quarta coluna na que vai ser usada
	
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

	MOV R0, #0

	CMP	R2, #2_1110	;Caso apertou a primeira tecla
		MOVEQ	R0, #10
		
	CMP	R2, #2_1101 	;Caso apertou a segunda tecla
		MOVEQ	R0, #11

	BX LR

	; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura


	ALIGN
	END