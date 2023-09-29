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
GPIO_PORTA_AHB_LOCK_R   	EQU		0x40058520
GPIO_PORTA_AHB_CR_R     	EQU		0x40058524
GPIO_PORTA_AHB_AMSEL_R  	EQU		0x40058528
GPIO_PORTA_AHB_PCTL_R   	EQU		0x4005852C
GPIO_PORTA_AHB_DIR_R    	EQU		0x40058400
GPIO_PORTA_AHB_AFSEL_R  	EQU		0x40058420
GPIO_PORTA_AHB_DEN_R    	EQU		0x4005851C
GPIO_PORTA_AHB_PUR_R    	EQU		0x40058510
GPIO_PORTA_AHB_DATA_R   	EQU		0x400583FC
GPIO_PORTA              	EQU    2_000000000000001
; PORT B	
GPIO_PORTB_AHB_LOCK_R   	EQU		0x40059520
GPIO_PORTB_AHB_CR_R     	EQU		0x40059524
GPIO_PORTB_AHB_AMSEL_R  	EQU		0x40059528
GPIO_PORTB_AHB_PCTL_R   	EQU		0x4005952C
GPIO_PORTB_AHB_DIR_R    	EQU		0x40059400
GPIO_PORTB_AHB_AFSEL_R  	EQU		0x40059420
GPIO_PORTB_AHB_DEN_R    	EQU		0x4005951C
GPIO_PORTB_AHB_PUR_R    	EQU		0x40059510
GPIO_PORTB_AHB_DATA_R   	EQU		0x400593FC
GPIO_PORTB              	EQU    2_000000000000010
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000
; PORT P	
GPIO_PORTP_LOCK_R    		EQU    0x40065520
GPIO_PORTP_CR_R      		EQU    0x40065524
GPIO_PORTP_AMSEL_R   		EQU    0x40065528
GPIO_PORTP_PCTL_R    		EQU    0x4006552C
GPIO_PORTP_DIR_R     		EQU    0x40065400
GPIO_PORTP_AFSEL_R   		EQU    0x40065420
GPIO_PORTP_DEN_R     		EQU    0x4006551C
GPIO_PORTP_PUR_R     		EQU    0x40065510	
GPIO_PORTP_DATA_R    		EQU    0x400653FC
GPIO_PORTP              	EQU    2_010000000000000
; PORT Q
GPIO_PORTQ_LOCK_R    		EQU    0x40066520
GPIO_PORTQ_CR_R      		EQU    0x40066524
GPIO_PORTQ_AMSEL_R   		EQU    0x40066528
GPIO_PORTQ_PCTL_R    		EQU    0x4006652C
GPIO_PORTQ_DIR_R     		EQU    0x40066400
GPIO_PORTQ_AFSEL_R   		EQU    0x40066420
GPIO_PORTQ_DEN_R     		EQU    0x4006651C
GPIO_PORTQ_PUR_R     		EQU    0x40066510	
GPIO_PORTQ_DATA_R    		EQU    0x400663FC
GPIO_PORTQ              	EQU    2_100000000000000


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT PortB_Output          ; Permite chamar PortJ_Input de outro arquivo	
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT PortP_Output          ; Permite chamar PortJ_Input de outro arquivo	
		EXPORT PortQ_Output          ; Permite chamar PortJ_Input de outro arquivo	
		IMPORT SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
			LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R1, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
			STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO

			LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV		R2, #GPIO_PORTA                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
			ORR     R2, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR     R2, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
			ORR     R2, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
			TST     R1, R2							;ANDS de R1 com R2
			BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando

		; 2. Limpar o AMSEL para desabilitar a analógica
			MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
			LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta A
			STR     R1, [R0]						;Guarda no registrador AMSEL da porta A da memória
			LDR     R0, =GPIO_PORTB_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta B
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da memória
			LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta J
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta J da memória
			LDR     R0, =GPIO_PORTP_AMSEL_R			;Carrega o R0 com o endereço do AMSEL para a porta P
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da memória			
			LDR     R0, =GPIO_PORTQ_AMSEL_R			;Carrega o R0 com o endereço do AMSEL para a porta Q
			STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta Q da memória
			
		; 3. Limpar PCTL para selecionar o GPIO
			MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			LDR     R0, =GPIO_PORTA_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta A
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
			LDR     R0, =GPIO_PORTB_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta B
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
			LDR     R0, =GPIO_PORTJ_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta J
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória	
			LDR     R0, =GPIO_PORTP_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta P
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória			
			LDR     R0, =GPIO_PORTQ_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta Q
			STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória			
			
			
			
		; 4. DIR para 0 se for entrada, 1 se for saída
			;Pino A
			LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta A
			MOV     R1, #2_11110000					;PA4 até o PA7 para Leds e Display 7 segmentos (entrada)
			STR     R1, [R0]						;Guarda no registrador

			;Pino B
			LDR     R0, =GPIO_PORTB_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta B
			MOV     R1, #2_0110000					;PB4 e PB5 para os transistores dos Displays 7 segmentos (entrada)
			STR     R1, [R0]						;Guarda no registrador
			
			
			;Pino J
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
			MOV     R1, #2_00						;Colocar 0 no registrador DIR para funcionar com saída
			STR     R1, [R0]						;Guarda no registrador
			
			;Pino P
			LDR     R0, =GPIO_PORTP_DIR_R			;Carrega o R0 com o endereço do DIR para a porta P
			MOV     R1, #2_100000               	;PP5 para o transistor dos leds (entrada)
			STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			
			;Pino Q
			LDR     R0, =GPIO_PORTQ_DIR_R		;Carrega o R0 com o endereço do DIR para a porta N
			MOV     R1, #2_00001111					;PQ0 até o PQ3 para Leds e Display 7 segmentos (entrada)
			STR     R1, [R0]						;Guarda no registrador
			
		; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
		;    Sem função alternativa
			MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
			LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta A
			STR     R1, [R0]						;Escreve na porta
			LDR     R0, =GPIO_PORTB_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta B
			STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta J
			STR     R1, [R0]						;Escreve na porta
			LDR     R0, =GPIO_PORTP_AFSEL_R     ;Carrega o endereço do AFSEL da porta P
			STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTQ_AFSEL_R     ;Carrega o endereço do AFSEL da porta Q
			STR     R1, [R0]                        ;Escreve na porta
			
		; 6. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_PORTA_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_11110000                     ;Ativa os pinos PA4 ao PA7 como I/O Digital
			STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 

			LDR     R0, =GPIO_PORTB_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_0110000                      ;Ativa os pinos PB4 e PB5  como I/O Digital      
			STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_11                     		;Ativa os pinos PJ0 e PJ1 como I/O Digital
			STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 

			LDR     R0, =GPIO_PORTP_DEN_R				;Carrega o endereço do DEN
			MOV     R1, #2_100000                       ;Ativa o pino PP5  como I/O Digital      
			STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			LDR     R0, =GPIO_PORTQ_DEN_R				;Carrega o endereço do DEN
			MOV     R1, #2_00001111                     ;Ativa os pinos PQ0 até PQ3  como I/O Digital      
			STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
			
		; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_0000011						;Habilitar funcionalidade digital de resistor de pull-up 
														;nos bits 0 e 1
			STR     R1, [R0]	

			BX LR

; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
;PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
;	LDR R9, =GPIO_PORTN_AHB_DATA_R
;	MOV R8, #0x02
;	STR R8, [R9]
;	PUSH {LR}
;	MOV R0, #1000
;	BL SysTick_Wait1ms
;	MOV R8, #0x00
;	STR R8, [R9]
;	MOV R0, #1000
;	BL SysTick_Wait1ms
;	POP {LR}
;	
;	BX LR


PortA_Output
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000 					;Pinos PA4 - PA7             
	ORR R0, R0, R2                      
	STR R0, [R1]                        
	BX LR

PortB_Output
	LDR	R1, =GPIO_PORTB_AHB_DATA_R		
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_110000              			;Pinos PB4 - PB5
	ORR R0, R0, R2                      
	STR R0, [R1]                        
	BX LR

PortP_Output
	LDR	R1, =GPIO_PORTP_DATA_R		
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_100000               		;Pino PP5
	ORR R0, R0, R2                      
	STR R0, [R1]                        
	BX LR

PortQ_Output
	LDR	R1, =GPIO_PORTQ_DATA_R		
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_1111      					;Pinos PQ0 - PQ3		         
	ORR R0, R0, R2                      
	STR R0, [R1]                        
	BX LR



; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J1-J0]
	BX LR	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo