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
#define tempoEntrePasso 10
typedef enum estados
{
	lendo_graus,
	lendo_sentido,
	lendo_velocidade,
	motor_girando,
	motor_desligado,
	motor_interrompido,
} estados;

typedef enum sentidos
{
	horario,
	anti_horario,
} sentiodos;

typedef enum passos
{
	completo,
	meio,
} passos;

passos passo = completo;
sentiodos sentido_atual = horario;
estados estado_atual = lendo_graus;
int i = 0;
int escrever_mensagem = 1;
int ledPortaN = 0;
int pos_motor = 0;
int pos_atual_motor = 0;
int contador_passo = 0;
char string[100];

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

void uart_uartInit(void);
unsigned char uart_uartRx(void);
void escreveTerminal(unsigned char* string);
void write_string(unsigned char character);

///////// LOCAL FUNCTIONS DECLARATIONS //////////

static void Pisca_leds(void);
static void Reseta_Motor(void);

void adiciona_string(char character);
void reseta_cursor(void);
void limpa_tela(void);
void resetar_terminal(void);

void Trata_Numero_Rotacao();
void Trata_Sentido_Rotaca();
void Trata_Velocidade();
void Prepara_Para_Proxima_Operacao();
void Acende_Leds();
void Apaga_Led();
void Gira_Motor();
void Gira_MeioPasso();
void Gira_PassoCompleto();
void Trata_Led_PortN();

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void)
{
	unsigned char msg = 0;

	PLL_Init();
	SysTick_Init();
	uart_uartInit();
	GPIO_Init();
	PortP_Output(0x20);
	timerInit();

	while (1)
	{
		switch (estado_atual)
		{
			case lendo_graus:
				if(escrever_mensagem)
				{
					escrever_mensagem = 0;
					escreveTerminal("Digite o grau, entre 0 e 360º, em múltiplos de 15: ");
				}
				if((msg = uart_uartRx()) != '.')
				{
					if(msg<=57 && msg >= 48)
					{
						string[i] = msg;
						i++;
					}
				}
				else if (msg == '.')
				{
					Trata_Numero_Rotacao();
				}
			break;

			case lendo_sentido:
				if(escrever_mensagem)
				{
					escrever_mensagem = 0;
					escreveTerminal("Sentido da rotação (Horario ou Anti-Horario): ");
				}
				if((msg = uart_uartRx()) != '.')
				{
					if(msg<=126 && msg >= 32)
					{
						string[i] = msg;
						i++;
					}
				}
				else if (msg == '.')
				{
					Trata_Sentido_Rotaca();
				}
			break;

			case lendo_velocidade:
				if(escrever_mensagem)
				{
					escrever_mensagem = 0;
					escreveTerminal("Velocidade (Meio-Passo ou Passo-Completo): ");
				}
				if((msg = uart_uartRx()) != '.')
				{
					if(msg<=126 && msg >= 32)
					{
						string[i] = msg;
						i++;
					}
				}
				else if (msg == '.')
				{
					Trata_Velocidade();
				}
			break;

			case motor_girando:
				Gira_Motor();
			break;

			case motor_desligado:	// acho que esse aqui ta incompleto
				if(escrever_mensagem)
				{
					escrever_mensagem = 0;
					escreveTerminal("FIM");
				}
				if((msg = uart_uartRx()) != '*')
				{
					if(msg<=126 && msg >= 32)
					{
						string[i] = msg;
						i++;
					}
				}
				else if (msg == '*')
				{
					pos_motor = 0;
					pos_atual_motor = 0;
					ledPortaN = 0;	// repensar na forma de tratar essa flag (flag do ledN)
					contador_passo = 0; 
					Apaga_Led();	
					Prepara_Para_Proxima_Operacao();
					estado_atual = lendo_graus;
				}

			case motor_interrompido:	
					escreveTerminal("FIM");
					pos_motor = 0;
					pos_atual_motor = 0;
					ledPortaN = 0;	// repensar na forma de tratar essa flag (flag do ledN) 
					contador_passo = 0;
					Apaga_Led();	
					Prepara_Para_Proxima_Operacao();
					estado_atual = lendo_graus;
			break;
		}
	}
}

static void Pisca_leds(void)
{
	PortN_Output(0x2);
	SysTick_Wait1ms(250);
	PortN_Output(0x1);
	SysTick_Wait1ms(250);
}

void Trata_Numero_Rotacao()
{
	pos_motor = atoi(string);

	if(pos_motor % 15 == 0 && pos_motor <= 360)
	{
		// chama os coisas do motor de rotacao
		estado_atual = lendo_sentido;
	}

	Prepara_Para_Proxima_Operacao();
	return;
}

void Trata_Sentido_Rotaca()
{
	if(strcmp(string,"horario") == 0 || strcmp(string,"Horario") == 0)
	{
		// chama os coisas do motor de velocidade
		sentido_atual = horario;
		estado_atual = lendo_velocidade;
	}
	else if(strcmp(string,"anti-horario") == 0 || strcmp(string,"Anti-Horario") == 0)	
	{
		// chama os coisas do motor de velocidade
		sentido_atual = anti_horario;
		estado_atual = lendo_velocidade;		
	}

	Prepara_Para_Proxima_Operacao();
	return;
}

void Trata_Velocidade()
{
	if(strcmp(string,"passo-completo") == 0 || strcmp(string,"Passo-Completo") == 0)
	{
		// chama os coisas do motor de velocidade
		passo = completo;
		estado_atual = motor_girando;		
	}
	else if(strcmp(string,"meio-passo") == 0 || strcmp(string,"Meio-Passo") == 0)
	{
		// chama os coisas do motor de velocidade
		passo = meio;
		estado_atual = motor_girando;
	}

	Prepara_Para_Proxima_Operacao();
	return;
}

void Prepara_Para_Proxima_Operacao()
{
	// for(int j = 0; j < strlen(string); j++)
	// {
	// 	string[j] = '\0';
	// }
	// // string[0]= '\0';
	memset(string,0,sizeof(string));
	i = 0;
	escrever_mensagem = 1;
	resetar_terminal();
}

void Acende_Leds() //tem que ficar chamando sempre enquanto o motor roda?
{
	// esquerda pra direita -> anti-horario
	// direita pra esquerda -> horario
		int leds_ativados = contador_passo/256;
		switch (leds_ativados)
		{
		case 1:
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0x80);
				PortQ_Output(0x0);
			}
			else
			{
				PortA_Output(0X0);
				PortQ_Output(0x01);
			}
		break;
		
		case 2: 
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xC0);
				PortQ_Output(0x0);
			}
			else
			{
				PortA_Output(0x0);
				PortQ_Output(0x3);
			}
		break;

		case 3:
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xE0);
				PortQ_Output(0x0);
			}
			else
			{
				PortA_Output(0x0);
				PortQ_Output(0x7);
			}		
		break;
		
		case 4: 
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xF0);
				PortQ_Output(0x0);
			}
			else
			{
				PortA_Output(0x0);
				PortQ_Output(0xF);
			}		
		break;

		case 5:
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xF0);
				PortQ_Output(0x08); // ultimo led da direita (da direita pra esquerda)
			}
			else
			{
				// PortA_Output(0x10); 
				PortA_Output(0x10);
				PortQ_Output(0xF);
			}		
		break;
		
		case 6: 
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xF0);
				PortQ_Output(0xC);
			}
			else
			{
				PortA_Output(0x30);
				PortQ_Output(0xF);
			}		
		break;

		case 7:
			if(sentido_atual)	//anti-horario
			{
				PortA_Output(0xF0);
				PortQ_Output(0xE);
			}
			else
			{
				PortA_Output(0x70);
				PortQ_Output(0xF);
			}		
		break;
		
		case 8: 
			PortA_Output(0xF0);
			PortQ_Output(0xF);
		break;
		}
	return;
}

void Apaga_Led()
{
	PortA_Output(0x0);
	PortQ_Output(0x0);
	return;
}

void Trata_Led_PortN()	// n sei se ta certo!
{
	if(estado_atual == motor_girando)
	{
		if(ledPortaN){
			PortN_Output(0x01);
		}
		else{
			PortN_Output(0x0);
		}
		ledPortaN = !ledPortaN;
	}
}

void Gira_Motor()
{
	if(contador_passo%84 == 0)	// equivalente a 15
	{
		resetar_terminal();
		if(contador_passo == 2016)		// resolvendo problema de aproximacao usada para entrar na condicao (modulo de 84, que nao eh multiplo de 360)
										// coisa feia
		{
			contador_passo = 2048;
		}
		if(pos_atual_motor == pos_motor)
		{
			pos_atual_motor = 0;
			estado_atual = motor_desligado;
		} 
		else
		{
			switch (passo){
				case completo:
					escreveTerminal("Velocidade: Passo-Completo, ");
				break;
				case meio:
					escreveTerminal("Velocidade: Meio-passo, ");
				break;
        	}	

        	escreveTerminal("Posição: ");
			pos_atual_motor += 15;
			char numero[6];
			snprintf(numero, sizeof(numero), "%d°", pos_atual_motor); //salva o valor de posicao_atual em numero como string
			escreveTerminal(numero);
		}
    }

	if(contador_passo%256 == 0 && contador_passo != 0) // equivalente a 45
	{
		Acende_Leds();
	}

	switch (passo)
	{
	case completo:
		Gira_PassoCompleto();
		contador_passo = contador_passo + 4;
	break;

	case meio:
		Gira_MeioPasso();
		contador_passo = contador_passo + 4;		
	break;
	}
	// uma chamada de qualquer Gira eh equivalente a 4 passos.

}

void Gira_PassoCompleto()
{
    switch (sentido_atual)
    {
    case horario:
        GPIO_PORTH_AHB_DATA_R = 0x7; // 2_0111
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xB; // 2_1011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xD; // 2_1101
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xE; // 2_1110
        SysTick_Wait1ms(tempoEntrePasso);
    break;

    case anti_horario:
        GPIO_PORTH_AHB_DATA_R = 0xE; // 2_1110
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xD; // 2_1101
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xB; // 2_1011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x7; // 2_0111
        SysTick_Wait1ms(tempoEntrePasso);
    break;
    }
}

void Gira_MeioPasso()
{
    switch (sentido_atual)
    {
    case horario:
        GPIO_PORTH_AHB_DATA_R = 0x7; // 2_0111
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x3; // 2_0011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xB; // 2_1011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x9; // 2_1001
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xD; // 2_1101
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xC; // 2_1100
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xE; // 2_1110
        SysTick_Wait1ms(tempoEntrePasso);
    break;

    case anti_horario:
        GPIO_PORTH_AHB_DATA_R = 0xE; // 2_1110
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xC; // 2_1100
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xD; // 2_1101
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x9; // 2_1001
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0xB; // 2_1011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x3; // 2_0011
        SysTick_Wait1ms(tempoEntrePasso);
        GPIO_PORTH_AHB_DATA_R = 0x7; // 2_0111
        SysTick_Wait1ms(tempoEntrePasso);
    break;
    } 
}

///////// HANDLERS IMPLEMENTATIONS //////////

void GPIOPortJ_Handler(void)
{
	GPIO_PORTJ_AHB_ICR_R = 0x1;
	estado_atual = motor_interrompido;
	// char queijo;
	// snprintf(queijo, sizeof(estado_atual), "%d°", estado_atual); 
	// escreveTerminal(queijo);
	return;
}

void Timer2A_Handler(void)
{
   TIMER2_ICR_R = 1; // ACKS the interruption
   TIMER2_CTL_R = 1; // Enables timer

   // nao sei se ta certo, rever!
   	Trata_Led_PortN();	

	return;
}