/**************************************************************************/
//Name:  BUTTONS.c																						 						//
//Purpose:  Allow configuration and use of external BUTTONS SW2 & SW3			//
//Author:  Thomas Smallarz																								//
//Revision:  1.0 06Oct2020 TS Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h" 													//Device header
#include "BUTTONS.h"															// BUTTONS header

/******************************************************************/
//						Function for Initialization of BUTTONS							//
/******************************************************************/

void BUTTONS_Init(void){

		SIM->SCGC5				|= SIM_SCGC5_PORTA_MASK;  
		SIM->SCGC5           |= SIM_SCGC5_PORTB_MASK;					//Enables Clock to PORTB
    SIM->SCGC5           |= SIM_SCGC5_PORTC_MASK;					//Enables Clock to PORTC
    
    PORTA->PCR[1]			= PORT_PCR_MUX(1u);
		PORTB->PCR[17]        = PORT_PCR_MUX(0x1u);						//Set Signal Multiplexing to
		PORTB->PCR[19]        = PORT_PCR_MUX(0x1u);
    PORTC->PCR[1]         = PORT_PCR_MUX(0x1u);						//Set Signal Multiplexing to

    GPIOA->PDDR					 |= GPIO_PDDR_PDD(0x1u << 1);
		GPIOB->PDDR          |= GPIO_PDDR_PDD(~(0x1u << 17)); //Sets PTB17 to Input GPIO
		GPIOB->PDDR          |= GPIO_PDDR_PDD(0x1u << 19); 		//Sets PTB19 to Output GPIO
    GPIOC->PDDR          |= GPIO_PDDR_PDD(~(0x1u << 1));  //Sets PTC1 to Input GPIO
    
    PORTB->PCR[17]       |= PORT_PCR_IRQC(0xA);    				//This configures the interrupt flag to be set on a falling edge
    PORTC->PCR[1]        |= PORT_PCR_IRQC(0xA);	   				//This configures the interrupt flag to be set on a falling edge
	
    NVIC_ClearPendingIRQ(PORTB_IRQn);              				//CMSIS Function to clear pending interrupts on PORTB
    NVIC_ClearPendingIRQ(PORTC_IRQn);		   								//CMSIS Function to clear pending interrupts on PORTC
    NVIC_EnableIRQ(PORTB_IRQn);        										//CMSIS Function to enable interrupt via PORTB
    NVIC_EnableIRQ(PORTC_IRQn);			   										//CMSIS Function to enable interrupt via PORTC

}//End BUTTONS_Init

/******************************************************************/
//					End Function for Initialization of BUTTONS						//
/******************************************************************/