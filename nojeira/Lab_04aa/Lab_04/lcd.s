; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
; PORT A
GPIO_PORTA_LOCK_R    	EQU    0x40058520
GPIO_PORTA_CR_R      	EQU    0x40058524
GPIO_PORTA_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_DIR_R     	EQU    0x40058400
GPIO_PORTA_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_DEN_R     	EQU    0x4005851C
GPIO_PORTA_PUR_R     	EQU    0x40058510	
GPIO_PORTA_DATA_R    	EQU    0x400583FC
GPIO_PORTA_DATA_BITS_R  EQU    0x40058000
GPIO_PORTA              EQU    2_000000000000001	

; PORT J
GPIO_PORTJ_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_CR_R      	EQU    0x40060524
GPIO_PORTJ_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ               	EQU    2_000000100000000
; Interrupt Port J
GPIO_PORTJ_AHB_IM_R			EQU	    0x40060410
GPIO_PORTJ_AHB_IS_R			EQU	    0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU	    0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU     0x4006040C
GPIO_PORTJ_AHB_ICR_R		EQU		0x4006041C	
GPIO_PORTJ_AHB_RIS_R		EQU 	0x40060414
	
NVIC_EN1_R					EQU		0xE000E104
NVIC_PRI12_R				EQU 	0xE000E430
	
; PORT K
GPIO_PORTK_LOCK_R    	EQU    0x40061520
GPIO_PORTK_CR_R      	EQU    0x40061524
GPIO_PORTK_AMSEL_R   	EQU    0x40061528
GPIO_PORTK_PCTL_R    	EQU    0x4006152C
GPIO_PORTK_DIR_R     	EQU    0x40061400
GPIO_PORTK_AFSEL_R   	EQU    0x40061420
GPIO_PORTK_DEN_R     	EQU    0x4006151C
GPIO_PORTK_PUR_R     	EQU    0x40061510	
GPIO_PORTK_DATA_R    	EQU    0x400613FC
GPIO_PORTK_DATA_BITS_R  EQU    0x40061000
GPIO_PORTK              EQU    2_000001000000000	

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

;; PORT N
;GPIO_PORTN_LOCK_R    	EQU    0x40064520
;GPIO_PORTN_CR_R      	EQU    0x40064524
;GPIO_PORTN_AMSEL_R   	EQU    0x40064528
;GPIO_PORTN_PCTL_R    	EQU    0x4006452C
;GPIO_PORTN_DIR_R     	EQU    0x40064400
;GPIO_PORTN_AFSEL_R   	EQU    0x40064420
;GPIO_PORTN_DEN_R     	EQU    0x4006451C
;GPIO_PORTN_PUR_R     	EQU    0x40064510	
;GPIO_PORTN_DATA_R    	EQU    0x400643FC
;GPIO_PORTN_DATA_BITS_R  EQU    0x40064000
;GPIO_PORTN              EQU    2_001000000000000

; PORT P
GPIO_PORTP_LOCK_R    	EQU    0x40065520
GPIO_PORTP_CR_R      	EQU    0x40065524
GPIO_PORTP_AMSEL_R   	EQU    0x40065528
GPIO_PORTP_PCTL_R    	EQU    0x4006552C
GPIO_PORTP_DIR_R     	EQU    0x40065400
GPIO_PORTP_AFSEL_R   	EQU    0x40065420
GPIO_PORTP_DEN_R     	EQU    0x4006551C
GPIO_PORTP_PUR_R     	EQU    0x40065510	
GPIO_PORTP_DATA_R    	EQU    0x400653FC
GPIO_PORTP_DATA_BITS_R  EQU    0x40065000
GPIO_PORTP              EQU    2_010000000000000	
	
; PORT Q
GPIO_PORTQ_LOCK_R    	EQU    0x40066520
GPIO_PORTQ_CR_R      	EQU    0x40066524
GPIO_PORTQ_AMSEL_R   	EQU    0x40066528
GPIO_PORTQ_PCTL_R    	EQU    0x4006652C
GPIO_PORTQ_DIR_R     	EQU    0x40066400
GPIO_PORTQ_AFSEL_R   	EQU    0x40066420
GPIO_PORTQ_DEN_R     	EQU    0x4006651C
GPIO_PORTQ_PUR_R     	EQU    0x40066510	
GPIO_PORTQ_DATA_R    	EQU    0x400663FC
GPIO_PORTQ_DATA_BITS_R  EQU    0x40066000
GPIO_PORTQ              EQU    2_100000000000000	
	



; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
		EXPORT Display_Write
		EXPORT Display_Init
		EXPORT Display_Config
		EXPORT Display_Clear
		EXPORT LCD_GPIOinit
		EXPORT EscreveTextoLCD
		EXPORT PulaSegundaLinha
		
		IMPORT SysTick_Wait1ms
		IMPORT SysTick_Wait1us

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
LCD_GPIOinit
   ; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
   LDR   R0, =SYSCTL_RCGCGPIO_R   ;carrega o endereco do registrador RCGCGPIO
   LDR R1, [R0]            ;carrega dado do registrador
   ORR R1, #GPIO_PORTK         ;seta apenas pinos da porta dos PINOS DE DADOS LCD 
   ORR   R1, #GPIO_PORTM         ;seta apenas pinos da porta dos PINOS DE COMANDO LCD 
   STR R1, [R0]            ;move para a memoria os bits das portas no endereco do RCGCGPIO

   ; verificar no PRGPIO se a porta esta pronta para uso.
   LDR R0, =SYSCTL_PRGPIO_R   ;carrega o endereco do PRGPIO para esperar os GPIO ficarem prontos
Espera_porta
   LDR   R1, [R0]         ;le da memoria o conteudo do endere?o do registrador
   MOV   R2, #GPIO_PORTK      ;LCD - PINOS DE DADOS
   ORR   R2, #GPIO_PORTM      ;LCD - PINOS DE COMANDO
   AND R1, R1, R2         ;seleciona apenas os pinos de porta de comparacao
   TST R1, R2            ;ANDS de R1 com R2
   BEQ Espera_porta      ;Se o flag Z=1, volta para o laco. Sen?o continua executando
   
   ; 2. Limpar o AMSEL para desabilitar a anal?gica
   LDR   R0, =GPIO_PORTK_AMSEL_R   ;LCD - PINOS DE DADOS
   LDR R1, [R0]
   BIC R1, #0xFF   ; Pinos PK0 a PK7 = 0: desabilita analogica
   STR R1, [R0]
   
   LDR   R0, =GPIO_PORTM_AMSEL_R   ;LCD - PINOS DE COMANDOS
   LDR R1, [R0]
   BIC R1, #2_111   ; Pinos M0 a M2 = 0: desabilita analogica
   STR   R1, [R0]
   
   ; 3. Limpar PCTL para selecionar o GPIO
   LDR   R0, =GPIO_PORTK_PCTL_R   ;LCD - PINOS DE DADOS
   LDR R1, [R0]
   BIC R1, #0xFF   ; Pinos PK0 a PK7 = 0: seleciona modo GPIO
   STR   R1, [R0]
   
   LDR   R0, =GPIO_PORTM_PCTL_R   ;LCD - PINOS DE COMANDOS
   LDR R1, [R0]
   BIC R1, #2_111   ; Pinos M0 a M2 = 0: seleciona modo GPIO
   STR   R1, [R0]

   ; 4. DIR para 0: input (BIC), 1: output (ORR)
   LDR   R0, =GPIO_PORTK_DIR_R
   LDR R1, [R0]
   ORR   R1, R1, #0xFF ; pinos PK0 a PK7 = 1: output
   STR   R1, [R0]
   
   LDR   R0, =GPIO_PORTM_DIR_R
   LDR R1, [R0]
   ORR R1, R1, #2_111 ; pinos M0 a M2 = 1: output
   STR R1, [R0]

   ; 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
   LDR   R0, =GPIO_PORTK_AFSEL_R
   LDR R1, [R0]
   BIC R1, R1, #0xFF ; pinos PK0 a PK7 = 0: sem funcao alternativa
   STR   R1, [R0]
   
   LDR   R0, =GPIO_PORTM_AFSEL_R
   LDR R1, [R0]
   BIC R1, R1, #2_111 ;pinos M0 a M2 = 0: sem funcao alternativa
   STR   R1, [R0]
   
   ; 6. Setar os bits de DEN para habilitar I/O digital
   LDR   R0, =GPIO_PORTK_DEN_R   ;LCD - PINOS DE DADOS
   LDR R1, [R0]
   ORR   R1, R1, #0xFF ; pinos K0 a K7 = 1: habilita I/O digital
   STR   R1, [R0]
   
   LDR   R0, =GPIO_PORTM_DEN_R   ;LCD - PINOS DE COMANDOS
   LDR R1, [R0]
   ORR R1, R1, #2_111 ; pinos M0 a M3 = 1 : habilita I/O digital
   STR   R1, [R0]
   
   ; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
   ; N/A

   BX   LR


Display_Init

	MOV R0, #0x38		; Inicia no modo duas linhas 
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	MOV R0, #40
	PUSH{R0,LR}
	BL SysTick_Wait1us
	POP{R0,LR}
	
	MOV R0, #0x06		; Cursor com autoincremento para direita
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	MOV R0, #40
	PUSH{R0,LR}
	BL SysTick_Wait1us
	POP{R0,LR}
	
	MOV R0, #0x0F		; Habilita display, cursor pisca
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	MOV R0, #40
	PUSH{R0,LR}
	BL SysTick_Wait1us
	POP{R0,LR}
	
	MOV R0, #0x01		; Reseta e cursor na primeira posi��o
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	MOV R0, #2
	PUSH{R0,LR}
	BL SysTick_Wait1ms
	POP{R0,LR}
	
	BX LR


Display_Config

	PUSH{R1,R2}
	LDR R1, =GPIO_PORTK_DATA_R	;habilitando os dados da porta K
	
	LDR R2, [R1]
	BIC R2, #0xFF
	ORR R2, R0
	STR R2, [R1]	
	
	MOV R0, #2_100				;
	LDR R1, =GPIO_PORTM_DATA_R
	LDR R2, [R1]
	BIC R2, #2_111
	ORR R2, R0
	STR R2, [R1]

	MOV R0, #2	
	PUSH{LR}
	BL SysTick_Wait1ms
	POP{LR}
	
	MOV R0, #2_000
	LDR R1, =GPIO_PORTM_DATA_R
	;MOV R0, #2_100
	LDR R2, [R1]
	BIC R2, #2_111
	ORR R2, R0
	STR R2, [R1]
	
	MOV R0, #2
	PUSH{LR}
	BL SysTick_Wait1ms
	POP{LR}
	
	POP{R1,R2}
	BX LR
		
		
Display_Clear
	PUSH{LR,R0}
	MOV R0, #0x01
	PUSH{LR}
	BL 	Display_Config
	POP{LR}
	POP{LR,R0}
	BX LR
	

Display_Write
	PUSH{R1,R2}
	LDR R1, =GPIO_PORTK_DATA_R	;habilitando os dados da porta K
	
	LDR R2, [R1]
	BIC R2, #0xFF
	ORR R2, R0
	STR R2, [R1]	
	
	MOV R0, #2_101				;EN = 1 RW = 0 RS = 1
	LDR R1, =GPIO_PORTM_DATA_R
	LDR R2, [R1]
	BIC R2, #2_111
	ORR R2, R0
	STR R2, [R1]

	MOV R0, #2
	PUSH{R0,LR}
	BL SysTick_Wait1ms
	POP{R0,LR}
	
	MOV R0, #2_001			 ;EN = 0 RW = 0 RS = 1		
	LDR R1, =GPIO_PORTM_DATA_R
	;MOV R0, #2_100
	LDR R2, [R1]
	BIC R2, #2_111
	ORR R2, R0
	STR R2, [R1]
	
	MOV R0, #2
	PUSH{R0,LR}
	BL SysTick_Wait1ms
	POP{R0,LR}
	
	POP{R1,R2}
	BX LR
	


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
	

EscreveTextoLCD

	MOV R2, #0
	MOV R3, #0
		
EscreveString
	LDRB R5, [R0, R3]
	ADD R3, R3, #1			; indice do vetor que vai ser lido
	
	CMP R5, #0				; Checa se acabou a string
		BXEQ LR		

	CMP  R5, #0x40  		; Checa por nova linha, se for nao imprime
		BNE AtualizaDisplay
	
	B EscreveString

PulaSegundaLinha
	MOV R0, #0xC0			; Pula para segunda linha
	PUSH{LR}
	BL Display_Config
	POP{LR}
	
	BX LR
	
AtualizaDisplay	
	PUSH{R0}
	MOV R0, R5
	PUSH{LR}
	BL Display_Write
	POP{LR}
	
	POP{R0}
	B EscreveString

; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
