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

//#include "arm_math.h"                   // ARM::CMSIS:DSP
//#include <stdbool.h>

uint16_t adc_measurement;
//uint16_t warble_factor = 0;
//float32_t warble_factor = 0;
//float32_t warble_factor2 = 0;
//static uint16_t cycle_count = 0;	//Keep track of cycle count to use for warble factor sine function
uint16_t dac_out;
//static bool test_pin = 0;

void PIT0_IRQHandler(void){	//This function is called when the timer interrupt expires
	//Place Interrupt Service Routine Here
	//Read ADC0
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0xFF)			;		//Writes to SC1A should produce software trigger...
	adc_measurement = ADC0->R[0];
	
	dac_out = adc_measurement;
	
	//Output to DAC0
	DAC0->DAT[0].DATL = DAC_DATL_DATA0( dac_out & 0xFF )	;
	DAC0->DAT[0].DATH = DAC_DATH_DATA1( dac_out >> 8 )	;
	
	NVIC_ClearPendingIRQ(PIT0_IRQn);							//Clears interrupt flag in NVIC Register
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;		//Clears interrupt flag in PIT Register													
}

int main(void){
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	TimerInt_Init();
	while(1){
		//Main loop goes here
	}
}
