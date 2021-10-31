/**************************************************************************/
//Name:  main.c																														//
//Purpose:  Skeleton project with configuration for ADC, DAC, MCG and PIT	//
//Author:  Ethan Hettwer																									//
//Revision:  1.0 15Sept2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"                 				//Device header
#include "MCG.h"																//Clock header
#include "TimerInt.h"														//Timer Interrupt Header
#include "ADC.h"																//ADC Header
#include "DAC.h"																//DAC Header
#include "PORT.h"
#include "useful_func.h"

uint16_t adc_measurement;
uint16_t y;
uint16_t dac_out;
uint8_t i = 0;
uint8_t pin = 0;
uint8_t N = 1;


void PIT0_IRQHandler(void){	//This function is called when the timer interrupt expires
	//Place Interrupt Service Routine Here
//	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;
	
	//Read ADC0
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0xFF)			;		//Writes to SC1A should produce software trigger... This is reading ADC0_DP0
	adc_measurement = ADC0->R[0];
	
//	dac_out = adc_measurement;

//	//Quesiton 1
//	if(i) {
//		dac_out = adc_measurement;
//	} else {
//		dac_out = 0xFFF - adc_measurement;
//	}
	
	//	Question 2
	if(i%2 == 0){
		dac_out = 0xFFF >> 1;
		i++;
	} else if(i==1){
		dac_out = adc_measurement;
		i++;
	} else {
		dac_out = 0xFFF - adc_measurement;
		i = 0;
	}

//	//Question 3
//	dac_out = adc_measurement & (0x0FFF << (12 - N));

	//Output to DAC0
	DAC0->DAT[0].DATL = DAC_DATL_DATA0( dac_out & 0xFFu )	;
	DAC0->DAT[0].DATH = DAC_DATH_DATA1( dac_out >> 8 )	;
	
	NVIC_ClearPendingIRQ(PIT0_IRQn);							//Clears interrupt flag in NVIC Register
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;		//Clears interrupt flag in PIT Register		

//	i=~i;
}

void PORTB_IRQHandler(void){
		
	if(N<12) N++;
	NVIC_ClearPendingIRQ(PORTB_IRQn);							//Clears interrupt flag in NVIC Register
	PORTB->PCR[0] |= PORT_PCR_ISF(1u);
}

void PORTC_IRQHandler(void){
	
	if(N>0) N--;
	NVIC_ClearPendingIRQ(PORTB_IRQn);							//Clears interrupt flag in NVIC Register
	PORTC->PCR[1] |= PORT_PCR_ISF(1u);
}

int main(void){
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	TimerInt_Init();
	PORT_Init();
	while(1){
		//Main loop goes here
	}
}


//	if(i==0){
//		GPIOA->PSOR = GPIO_PSOR_PTSO(0x1u << 1);
//		GPIOA->PCOR = GPIO_PCOR_PTCO(0x1u << 2);
//	} else {
//		GPIOA->PSOR = GPIO_PSOR_PTSO(0x1u << 2);
//		GPIOA->PCOR = GPIO_PCOR_PTCO(0x1u << 1);
//	}
//	
//	i = ~i;

//	if(i) adc_measurement = 0xFFF - adc_measurement;
	
