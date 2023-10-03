; Exemplo.s
; Prof. Guilherme Peron
; Lab0
; Eduardo Soviersovski
; Pedro Tortola
; 04/09/2023

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT Start                ; Permite chamar a fun��o Start a partir de 


lista_multiplicadores	EQU	0x20000400

		
; -------------------------------------------------------------------------------
; Fun��o main()
Start  
; Comece o c�digo aqui <======================================================

	MOV R9, #1	;Tabuada atual
	MOV	R8, #0	;multiplicador atual
	
MainLoop
	LDR		R6, = lista_multiplicadores
	ADD		R6,	R9
	LDR		R7,	[R6]
	CMP		R7,	#10
	ITE		EQ
		MOVEQ 	R7, #0
		ADDNE 	R7, #1
	STR		R7, [R6]
	CMP		R7,	#5
	IT		EQ
		ADDEQ R9, #1
	B MainLoop

	NOP
	
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
;	LDR		R0,	=string			;pegando o endere�o do primeiro valor do vetor e salva no R0
;	LDR		R1,	=0x2000041A
;	LDR		R2, =inicio
;	MOV		R3,	#0
;	LDR		R4, =maior
;	
;	
;conta_letras
;	LDRB	R5,	[R0]			;pega o valor do endere�o, salva no R5
;	ADD		R0,	#1				;atualiza o indice
;	LDR		R6, =inicio			;pega o endere�o 0x20000400
;	ADD		R6, R5				;soma o valor em hexa da letra atual
;	ADD		R6, #-0x41			;subtrai valor de A em hexa, para saber qual � o que esta sendo lido
;	LDR		R7, [R6]			;quantidade atual da letra e salvando no R7
;	ADD		R7, #1				;soma 1 no endere�o atual
;	STR		R7,	[R6]			;volta pro valor atualizado
;	CMP		R5, #0
;	BNE		conta_letras
;	
;pega_maior
;	LDRB	R8, [R2]			;pega endere�o da primeira letra A
;	CMP		R8, R3				;compara para ver se � maior que a maior
;	IT		HI					
;		MOVHI	R3,	R8			;atualizando o maior
;	ADD		R2,	#1				;atualiza o indice
;	CMP		R2, R1				;verifica se chegou no Z+1
;	BLT		pega_maior			
;		
;	STR		R3, [R4]			;adiciona o maior no 0x20000500
;	
;		NOP
;string DCB	"MATERIAMICRO" ,0


