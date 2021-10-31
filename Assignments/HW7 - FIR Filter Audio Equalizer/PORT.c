#include "MK22F51212.h"                				 	//Device header
#include "PORT.h"																// ADC header



void PORT_Init(void) {
	
	SIM->SCGC5				|= SIM_SCGC5_PORTA_MASK;
	SIM->SCGC5				|= SIM_SCGC5_PORTB_MASK;	
	
	PORTA->PCR[1]			= PORT_PCR_MUX(1u);
	PORTB->PCR[17]			= PORT_PCR_MUX(1u);

	GPIOA->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 1));
	GPIOB->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 17));
	
	PORTB->PCR[17]		|= PORT_PCR_IRQC(0xA);	//This configures the interrupt flag to be set on a rising edge
	NVIC_ClearPendingIRQ(PORTB_IRQn);		//CMSIS Function to clear pending interrupts on PORTB
	NVIC_EnableIRQ(PORTB_IRQn);		//CMSIS Function to enable interrupt via PORTB
	
}
