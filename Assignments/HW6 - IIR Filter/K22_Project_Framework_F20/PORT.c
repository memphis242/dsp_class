#include "MK22F51212.h"                				 	//Device header
#include "PORT.h"																// ADC header



void PORT_Init(void) {
	
	SIM->SCGC5				|= SIM_SCGC5_PORTA_MASK;
	SIM->SCGC5				|= SIM_SCGC5_PORTB_MASK;

	PORTA->PCR[1]			= PORT_PCR_MUX(1u);
	PORTA->PCR[5]			= PORT_PCR_MUX(1u);
	
	GPIOA->PDDR				|= GPIO_PDDR_PDD(0x1u << 1);
	GPIOA->PDDR				|= GPIO_PDDR_PDD(0x1u << 5);
	
	//HW2 Port Setup
	SIM->SCGC5				|= SIM_SCGC5_PORTB_MASK;
	SIM->SCGC5				|= SIM_SCGC5_PORTC_MASK;
	
	PORTB->PCR[1]			= PORT_PCR_MUX(1u);
	PORTC->PCR[2]			= PORT_PCR_MUX(1u);

	GPIOB->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 1));
	GPIOC->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 2));
	
	PORTB->PCR[1]		|= PORT_PCR_IRQC(0x9);	//This configures the interrupt flag to be set on a rising edge
	PORTC->PCR[2]		|= PORT_PCR_IRQC(0x9);
	NVIC_ClearPendingIRQ(PORTB_IRQn);		//CMSIS Function to clear pending interrupts on PORTB
	NVIC_ClearPendingIRQ(PORTC_IRQn);
	NVIC_EnableIRQ(PORTB_IRQn);		//CMSIS Function to enable interrupt via PORTB
	NVIC_EnableIRQ(PORTC_IRQn);
	
}
