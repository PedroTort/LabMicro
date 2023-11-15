// UART bus initialization

#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include <string.h>

#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTF  (0x0020) // bit 5

/////// EXTERNABLE FUNCTIONS DECLARATION ///////

/**
 * @brief Initializes all UART registers
 */
extern void uart_uartInit(void);

/**
 * @brief Receives data from UART0 if the queue is not empty
 * 
 * @return unsigned char The byte received
 */
extern unsigned char uart_uartRx(void);

/**
 * @brief Transmits data to UART0 if the queue is not full and txMsg differs from 0
 * 
 * @param txMsg The byte to be sent
 */
extern void escreveTerminal(unsigned char* txMsg);

extern void write_string(unsigned char character);

extern unsigned char* get_uartRX();

extern void reseta_cursor(void);

extern void limpa_tela(void);

extern void resetar_terminal(void);

/////// EXTERNABLE FUNCTIONS IMPLEMENTATION ///////

extern void uart_uartInit(void)
{
   // UART SETTINGS
   SYSCTL_RCGCUART_R = SYSCTL_RCGCUART_R0; // Enables clk

   while ((SYSCTL_PRUART_R & SYSCTL_PRUART_R0) != SYSCTL_PRUART_R0) { } // Waits for clock to be ready

   UART0_CTL_R = UART0_CTL_R & (~UART_CTL_UARTEN); // Disables uart0 by setting uarten to 0

   UART0_IBRD_R = 130; // Magic numbers from slide show -> sysclock/(clkDiv * BaudRate) = 80M/(16*38400)
   UART0_FBRD_R = 13; // round(Decimal number * 64)

   UART0_LCRH_R = 0x7A; // WLEN = 11, FEN = 1, STP2 = 1, EPS = 0, PEN = 1	A nossa pariedade é impar!

   UART0_CC_R = 0; // CLK = sysCLK

   UART0_CTL_R = (UART_CTL_UARTEN | UART_CTL_TXE | UART_CTL_RXE); // Enables Tx, Rx, HSE=0 (clkDiv = 16) and UARTEN

   return;
}


extern unsigned char uart_uartRx(void)
{
	unsigned char rxMsg = 0;
	// unsigned long isRxQueueEmpty = (UART0_FR_R & UART_FR_RXFE) >> 4;

	// if (0 == isRxQueueEmpty)
	// {
	// 	rxMsg = UART0_DR_R;
	// }

	// return rxMsg;
	while ((UART0_FR_R & 0x10) == 0x10) {}
	rxMsg =UART0_DR_R;
	return rxMsg;
}


extern void escreveTerminal(unsigned char* txMsg) 	// "escreve" a string no terminal
{
	// unsigned long isTxQueueFull = (UART0_FR_R & UART_FR_TXFF) >> 5;
	// while(isTxQueueFull && txMsg != "") {}
		unsigned char character = txMsg[0];
		int i = 1;
		while (character != '\0') {
			write_string(character);
			character = txMsg[i];
			i++;
		}

	return;
}

extern void write_string(unsigned char character) // recebe cada caracter para escrever no terminal
{
	while ((UART0_FR_R & 0x20) == 0x20) {}
	UART0_DR_R = character;
	return;
}

void reseta_cursor(void){
	write_string(0x1B);
	write_string('[');
	write_string(';');
	write_string('H');
}

void limpa_tela(void){

	write_string(0x1B);
	write_string('[');
	write_string('2');
	write_string('J');
}

void resetar_terminal(void){
	limpa_tela();
	reseta_cursor();
}