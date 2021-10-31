#include "MK22F51212.h"                				 	//Device header
#include "PORT.h"																// ADC header



void PORT_Init(void) {
	
//	uint8_t pin = 0;

//I'm first just setting pin 1 of Port B as an output	
//	SIM->SCGC5			|= SIM_SCGC5_PORTB_MASK;	//Enable clock to PORTB Module
//	PORTB->PCR[pin] 	= PORT_PCR_MUX(1u);				//Set PORTB's signal as GPIO
////	GPIOB->PSOR			= GPIO_PSOR_PTSO(0x1u << pin);	//Not sure why but in mbed api implementation, they set the output pin high before setting pin as output...
//	GPIOB->PDDR			|= GPIO_PDDR_PDD(0x1u << pin);		//Set pin 0 of Port B as output
	
//	//Now to test out digital input. I'm having port B pin read a digital signal, and will have the rgb led on the board (PTA1, PTA2, PTD5) indicate accordingly
//	SIM->SCGC5				|= SIM_SCGC5_PORTA_MASK;
//	SIM->SCGC5				|= SIM_SCGC5_PORTB_MASK;
//	
//	PORTA->PCR[1]			= PORT_PCR_MUX(1u);
//	PORTA->PCR[2]			= PORT_PCR_MUX(1u);
//	PORTB->PCR[pin]			= PORT_PCR_MUX(1u);
//	
//	GPIOA->PDDR				|= GPIO_PDDR_PDD(0x1u << 1);
//	GPIOA->PDDR				|= GPIO_PDDR_PDD(0x1u << 2);
//	GPIOB->PDDR				|= GPIO_PDDR_PDD(~(0x1u << pin));
//	
//	PORTB->PCR[pin]		|= PORT_PCR_IRQC(0x9);	//This configures the interrupt flag to be set on a rising edge
//	NVIC_ClearPendingIRQ(PORTB_IRQn);		//CMSIS Function to clear pending interrupts on PORTB
//	NVIC_EnableIRQ(PORTB_IRQn);		//CMSIS Function to enable interrupt via PORTB
	
	//HW2 Port Setup
	SIM->SCGC5				|= SIM_SCGC5_PORTB_MASK;
	SIM->SCGC5				|= SIM_SCGC5_PORTC_MASK;
	
	PORTB->PCR[0]			= PORT_PCR_MUX(1u);
	PORTC->PCR[1]			= PORT_PCR_MUX(1u);

	GPIOB->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 0));
	GPIOC->PDDR				|= GPIO_PDDR_PDD(~(0x1u << 1));
	
	PORTB->PCR[0]		|= PORT_PCR_IRQC(0x9);	//This configures the interrupt flag to be set on a rising edge
	PORTC->PCR[1]		|= PORT_PCR_IRQC(0x9);
	NVIC_ClearPendingIRQ(PORTB_IRQn);		//CMSIS Function to clear pending interrupts on PORTB
	NVIC_ClearPendingIRQ(PORTC_IRQn);
	NVIC_EnableIRQ(PORTB_IRQn);		//CMSIS Function to enable interrupt via PORTB
	NVIC_EnableIRQ(PORTC_IRQn);
	
}
