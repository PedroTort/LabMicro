// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron
#include <stdio.h> 
#include <stdlib.h> 
#include <stdint.h>
#include <string.h>
#include "tm4c1294ncpdt.h"

///////// DEFINES AND MACROS //////////

typedef enum estados
{
	ligado_pot,
	ligado_teclado,
	desligado,
} estados;

typedef enum sentidos
{
	horario,
	anti_horario,
} sentidos;

uint32_t configuracao = 0;
uint32_t conv = 0;
uint32_t valor_atual = 0;
uint32_t percentual = 0;
int escrever_mensagem = 1;

sentidos sentido_atual = horario;

estados estado_atual = desligado;
char strEscreveVelocidade[100];
char strVelocidade[11] = "Velocidade:";
char strPercentual[5];
///////// EXTERNAL FUNCTIONS INCLUSIONS //////////
// Since there is no .h in most files, theis functions must be included by hand.
// Same as if we were using IMPORT from assembly

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

void GPIO_Init(void);
void PortF_Output(uint32_t valor);
void PortP_Output(uint32_t valor);
void PortQ_Output(uint32_t valor);
void PortA_Output(uint32_t valor);
void PortN_Output(uint32_t valor);
uint32_t PortJ_Input(void);

void timerInit(void);

extern void LCD_GPIOinit(void);
extern void Display_Init(void);
extern void Display_Clear(void);
extern void Display_Config(uint32_t parametro);
extern void EscreveTextoLCD(char* parametro);
extern void PulaSegundaLinha(void);

extern void Teclado_GPIO_Init(void);
extern void  PortL_Input(void);
extern uint32_t EsperaConfiguracao(void);

extern void ADC_Init (void) ;
extern uint32_t ADC0_InSeq0 (void) ;
///////// LOCAL FUNCTIONS DECLARATIONS //////////



///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void)
{
	unsigned char msg = 0;
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	PortP_Output(0x20);
	timerInit();

	ADC_Init();

	LCD_GPIOinit();
	Display_Init();
	Teclado_GPIO_Init();
	Display_Clear();
	EscreveTextoLCD("MOTOR PARADO");
	PulaSegundaLinha();
	EscreveTextoLCD("A-Pot B-Teclado");
	while (1)
	{
		switch (estado_atual)
		{
			case ligado_pot:
				conv = ADC0_InSeq0();
				Display_Clear();
				if (valor_atual < 2047) {
					percentual = 100*(2047 - valor_atual)/2047;
					EscreveTextoLCD("Sentido:Hor");
				} else {
					percentual = 100*(valor_atual - 2047)/2047;
					EscreveTextoLCD("Sentido:Anti-Hor");
				}
				valor_atual = conv;
				strcpy(strEscreveVelocidade, strVelocidade);
				snprintf(strPercentual, 5, "%d", percentual);
				strcat(strEscreveVelocidade, strPercentual);
				PulaSegundaLinha();
				EscreveTextoLCD(strEscreveVelocidade);
				
				SysTick_Wait1ms(500);
			break;
			case ligado_teclado:
				Display_Clear();
				if(escrever_mensagem)
				{
					escrever_mensagem = 0;
					EscreveTextoLCD("A-Horario B-Anti");
					SysTick_Wait1ms(1000);
				}
				configuracao = EsperaConfiguracao();
				if ((sentido_atual == horario) && configuracao == 11) {
					//MUDAR O SENTIDO AOS POUCOS
					sentido_atual = anti_horario;
				}
				if ((sentido_atual == anti_horario) && configuracao == 10) {
					sentido_atual = horario;
				}
				conv = ADC0_InSeq0();
				percentual = 100*(valor_atual)/4095;
				if (sentido_atual == horario) {
					EscreveTextoLCD("Sentido:Hor");
				} else if (sentido_atual == anti_horario) {
					EscreveTextoLCD("Sentido:Anti-Hor");
				}
				valor_atual = conv;
				strcpy(strEscreveVelocidade, strVelocidade);
				snprintf(strPercentual, 5, "%d", percentual);
				strcat(strEscreveVelocidade, strPercentual);
				PulaSegundaLinha();
				EscreveTextoLCD(strEscreveVelocidade);
				SysTick_Wait1ms(500);
			break;
			case desligado:
				configuracao = EsperaConfiguracao();
				if (configuracao == 10) {
					estado_atual = ligado_pot;
				}
				else if (configuracao == 11) {
					estado_atual = ligado_teclado;
				}
			break;
		}
	}
}



///////// HANDLERS IMPLEMENTATIONS //////////

void GPIOPortJ_Handler(void)
{
	GPIO_PORTJ_AHB_ICR_R = 0x1;
	return;
}

void Timer2A_Handler(void)
{
   TIMER2_ICR_R = 1; // ACKS the interruption
   TIMER2_CTL_R = 1; // Enables timer

	return;
}
