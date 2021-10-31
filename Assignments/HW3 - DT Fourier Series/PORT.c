#include "MK22F51212.h"                				 	//Device header
#include "PORT.h"																// ADC header



void PORT_Init(void) {

	uint8_t pin = 0;

//I'm first just setting pin 1 of Port B as an output
	SIM->SCGC5			|= SIM_SCGC5_PORTB_MASK;	//Enable clock to PORTB Module
	PORTB->PCR[pin] 	= PORT_PCR_MUX(1u);				//Set PORTB's signal as GPIO
//	GPIOB->PSOR			= GPIO_PSOR_PTSO(0x1u << pin);	//Not sure why but in mbed api implementation, they set the output pin high before setting pin as output...
	GPIOB->PDDR			|= GPIO_PDDR_PDD(0x1u << pin);		//Set pin 0 of Port B as output

}
