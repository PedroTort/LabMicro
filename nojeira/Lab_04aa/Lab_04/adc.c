#include <stdint.h>
#include "tm4c1294ncpdt.h"
#define GPIO_PORTE (0x10) //bit 4


// Função ADC_Init
// Inicializa o port E e o ADC
// Parametro de entrada: Nao tem
// Parametro de saida: Nao tem
void ADC_Init (void) 
   {
   //la. Ativar o clock para o Port E porta setando o bit correspondente no registrador RCGCGPIO
   SYSCTL_RCGCGPIO_R |= GPIO_PORTE;
   //1b. apos isso verificar no PRGPIO se a porta esta pronta para uso.
   while((SYSCTL_PRGPIO_R & (GPIO_PORTE) ) != (GPIO_PORTE) ) {};
   // 2. Setar o AMSEL para habilitar a analogica do PE4
   GPIO_PORTE_AHB_AMSEL_R |= 0x10;
   // 3. Sem PCTL
   GPIO_PORTE_AHB_PCTL_R = 0x00000000;
   // 4. DIR para 0 se for entrada, 1 se for saida
   GPIO_PORTE_AHB_DIR_R = 0x00;
   // 5. Setar o AFSEL para 1 para selecionar uma funçao alternativa
   GPIO_PORTE_AHB_AFSEL_R |= 0x10;
   // 6. Desabilitar os bits de DEN para desabilitar I/O digital
   GPIO_PORTE_AHB_DEN_R &= ~0x10;
   // 7a. Habilitar o ADCO
   SYSCTL_RCGCADC_R |= 0x01;
   // 7b. Esperar o ADCO
   while((SYSCTL_PRADC_R & (0x01) ) != (0x01) ) {};
   // 8. Configurar para 125K
   ADC0_PC_R = 0x01;
   //Bit4
   //9. O sequenciador 3 tem a prioridade mais alta
   ADC0_SSPRI_R = 0x0123;
   //10. Desabilitar o sequenciador 3 para configurar
   ADC0_ACTSS_R &= ~0x0008;
   //11. Seq3 e trigger em software
   ADC0_EMUX_R &= ~0xF000;
   //12. Limpar o campo SS3 e setar o canal Ain9
   ADC0_SSMUX3_R = 9;
   //13. Sem TSO DO, sim IEO ENDO
   ADC0_SSCTL3_R = 0x0006;
   //14. Desabilitar interrupcoes no SS3
   ADC0_IM_R &= ~0x0008;
   //15. Habilitar o SS3
   ADC0_ACTSS_R |=0x0008;
}

uint32_t ADC0_InSeq0 (void) {
   uint32_t resultado;
   ADC0_PSSI_R = 0x0008; //inicia sequenciador SS3
   while ((ADC0_RIS_R & 0x08) == 0 ) {};
   resultado = ADC0_SSFIFO3_R&0xFFF;
   ADC0_ISC_R = 0x0008; //ACK
   return resultado;
}