; gpio.s
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
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortL_Input          ; Permite chamar PortJ_Input de outro arquivo	
		EXPORT PortM_Output          ; Permite chamar PortJ_Input de outro arquivo	
		EXPORT PortM_Dir          ; Permite chamar PortJ_Input de outro arquivo	
		EXPORT Display_Write
		EXPORT Display_Init
		EXPORT Display_Config
		EXPORT Display_Clear
		EXPORT Display_Write
		EXPORT Led_Enable
		EXPORT Interrupt_Init
		IMPORT SysTick_Wait1ms
		IMPORT SysTick_Wait1us

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
		LDR     R0, =SYSCTL_RCGCGPIO_R  		
		MOV		R1, #GPIO_PORTA                 ; PORT A                                     
		ORR		R1, #GPIO_PORTJ                 ; PORT J                                     
		ORR     R1, #GPIO_PORTK                 ; PORT K                 
		ORR     R1, #GPIO_PORTL                 ; PORT L                 
		ORR     R1, #GPIO_PORTM                 ; PORT M                 
		; ORR     R1, #GPIO_PORTN               ; PORT N                   
		ORR     R1, #GPIO_PORTP                 ; PORT P                 
		ORR     R1, #GPIO_PORTQ                 ; PORT Q                 
		STR     R1, [R0]						

		LDR     R0, =SYSCTL_PRGPIO_R			
EsperaGPIO  LDR     R1, [R0]						
		MOV		R1, #GPIO_PORTA                 ; PORT A                                     
		ORR		R1, #GPIO_PORTJ                 ; PORT J                                     
		ORR     R1, #GPIO_PORTK                 ; PORT K                 
		ORR     R1, #GPIO_PORTL                 ; PORT L                 
		ORR     R1, #GPIO_PORTM                 ; PORT M                 
		; ORR     R1, #GPIO_PORTN               ; PORT N                   
		ORR     R1, #GPIO_PORTP                 ; PORT P                 
		ORR     R1, #GPIO_PORTQ                 ; PORT Q
		TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
		BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando

 
; 2. Limpar o AMSEL para desabilitar a analógica
		MOV     R1, #0x0
		LDR     R0, =GPIO_PORTA_AMSEL_R     	; PORT A
		STR     R1, [R0]						
		LDR     R0, =GPIO_PORTJ_AMSEL_R     	; PORT J
		STR     R1, [R0]						
		LDR     R0, =GPIO_PORTK_AMSEL_R			; PORT K
		STR     R1, [R0]					    
		LDR     R0, =GPIO_PORTL_AMSEL_R			; PORT L
		STR     R1, [R0]					    
		LDR     R0, =GPIO_PORTM_AMSEL_R			; PORT M
		STR     R1, [R0]					    
		; LDR     R0, =GPIO_PORTN_AMSEL_R		; PORT N	
		; STR     R1, [R0]
		LDR     R0, =GPIO_PORTP_AMSEL_R			; PORT P
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTQ_AMSEL_R			; PORT Q
		STR     R1, [R0]

 
; 3. Limpar PCTL para selecionar o GPIO
		MOV     R1, #0x0					    
		LDR     R0, =GPIO_PORTA_PCTL_R			; PORT A
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTJ_PCTL_R			; PORT J
		STR     R1, [R0]                        
		LDR     R0, =GPIO_PORTK_PCTL_R      	; PORT K
		STR     R1, [R0]                        
		LDR     R0, =GPIO_PORTL_PCTL_R      	; PORT L
		STR     R1, [R0]                        
		LDR     R0, =GPIO_PORTM_PCTL_R      	; PORT M
		STR     R1, [R0]                        
		; LDR     R0, =GPIO_PORTN_PCTL_R      	; PORT N
		; STR     R1, [R0]   
		LDR     R0, =GPIO_PORTP_PCTL_R      	; PORT P
		STR     R1, [R0]                        
		LDR     R0, =GPIO_PORTQ_PCTL_R      	; PORT Q
		STR     R1, [R0]                        
		
		
; 4. DIR para 0 se for entrada, 1 se for saída
		LDR     R0, =GPIO_PORTA_DIR_R			; PORT A
		MOV     R1, #2_11110000						;[PA7 .. PA4] SAIDA
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTJ_DIR_R			; PORT J
		MOV     R1, #0x0               				; PJ0 ENTRADA
		STR     R1, [R0]						
		LDR     R0, =GPIO_PORTK_DIR_R			;PORT K
		MOV     R1, #2_11111111						;[PK7 .. PK0] Saida
		STR     R1, [R0]						
		LDR     R0, =GPIO_PORTL_DIR_R			; PORT L
		MOV     R1, #2_0000							;[PL3 .. PL0] Entrada
		STR     R1, [R0]						
		LDR     R0, =GPIO_PORTM_DIR_R			; PORT M
		MOV     R1, #2_00000111						;[PM7 .. PM4] Entrada 
													;[PM2 .. PM0] SAIDA
		STR     R1, [R0]						
		; LDR     R0, =GPIO_PORTN_DIR_R			; PORT N
		; MOV     R1, #2_0010						; 
		;STR     R1, [R0]
		LDR     R0, =GPIO_PORTP_DIR_R			; PORT P
		MOV     R1, #2_100000						;[PP5] SAIDA
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTQ_DIR_R			; PORT Q
		MOV     R1, #2_1111							;[PQ3 .. PQ0] SAIDA
		STR     R1, [R0]			
		
			
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
		MOV     R1, #0x0						
		LDR     R0, =GPIO_PORTA_AFSEL_R     ; PORT A
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTJ_AFSEL_R     ; PORT J
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTK_AFSEL_R     ; PORT K
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTL_AFSEL_R     ; PORT L
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTM_AFSEL_R     ; PORT M
		STR     R1, [R0]
		; LDR     R0, =GPIO_PORTN_AFSEL_R	; PORT N
		; STR     R1, [R0]						
		LDR     R0, =GPIO_PORTP_AFSEL_R     ; PORT P
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTQ_AFSEL_R     ; PORT Q
		STR     R1, [R0]                        
			
; 6. Setar os bits de DEN para habilitar I/O digital
		LDR     R0, =GPIO_PORTA_DEN_R			
		MOV     R1, #2_11110000                          
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTJ_DEN_R			
		MOV     R1, #2_00000001                          
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTK_DEN_R			
		MOV     R1, #2_11111111                          
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTL_DEN_R			
		MOV     R1, #2_00001111                          
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTM_DEN_R			
		MOV     R1, #2_11110111                          
		STR     R1, [R0]
		; LDR     R0, =GPIO_PORTN_DEN_R			
		; MOV     R1, #2_00000001                          
		; STR     R1, [R0]
		LDR     R0, =GPIO_PORTP_DEN_R			
		MOV     R1, #2_00100000                          
		STR     R1, [R0]
		LDR     R0, =GPIO_PORTQ_DEN_R			
		MOV     R1, #2_00001111                          
		STR     R1, [R0]						 
                          
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
		LDR     R0, =GPIO_PORTJ_PUR_R			
		MOV     R1, #2_1							
		STR     R1, [R0]
								
		LDR     R0, =GPIO_PORTL_PUR_R			
		MOV     R1, #2_1111							
		STR     R1, [R0]							
		
		BX      LR


Interrupt_Init

 ;8. Habilitando interrupcoes!!

			
		; Border or level
			LDR R0, =GPIO_PORTJ_AHB_IS_R
			MOV R1, #0
			STR R1, [R0]
			
		; Activate in 1 or 2 borders
			LDR R0, =GPIO_PORTJ_AHB_IBE_R
			MOV R1, #0
			STR R1, [R0]
			
		; Activate in rising or lowering border 0 = lowering, 1 = rising
			LDR R0, =GPIO_PORTJ_AHB_IEV_R
			MOV R1, #2_0
			STR R1, [R0]
			
		; Enable GPIORIS AND GPIOMIS reset
			LDR R0, =GPIO_PORTJ_AHB_ICR_R
			MOV R1, #2_1
			STR R1, [R0]

		; Enable interrupt
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #2_1
			STR R1, [R0]
			
		; Enable interrut in Nvidea
			LDR R0, =NVIC_EN1_R
			MOV R1, #1
			LSL R1, R1, #19
			STR R1, [R0]
			
		; Set port interrupt priority
			LDR R0, =NVIC_PRI12_R
			MOV R1, #5
			LSL R1, R1, #29
			STR R1, [R0]

			BX LR
		
Led_Enable
		PUSH {R10, R11, R12}

		LDR R10, =GPIO_PORTA_DATA_R
		MOV R12, #0xF0
		STR R12, [R10]
		LDR R10, =GPIO_PORTQ_DATA_R
		MOV R12, #0x0F
		STR R12, [R10]

		LDR R11, =GPIO_PORTP_DATA_R
		
		LDR R12, [R11]
		BIC R12, #2_00100000
		ORR R12, R0
		STR R12, [R11]

		POP {R10, R11, R12}

		BX LR
		
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
	
	MOV R0, #0x01		; Reseta e cursor na primeira posição
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
	



; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
