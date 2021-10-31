#include "MK22F51212.h"                 				//Device header
#include "MCG.h"																//Clock header
#include "TimerInt.h"														//Timer Interrupt Header
#include "ADC.h"																//ADC Header
#include "DAC.h"																//DAC Header
#include "BUTTONS.h"
#include "useful_func.h"
#include "coef4.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

uint16_t y;
uint16_t adc_measurement;
uint16_t dac_out;

// The following represent my stages; I will be using circular addressing using xptr and yptr
float V[NS][3];
float Y[NS][3];
float xin = 0.0f;
float xnext = 0.0f;

uint8_t N = 0u;	//This is for selecting the filter
uint8_t M = 0u;	//This is for indexing the filter, which is N-1

void PIT0_IRQHandler(void){		
	
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0x00)			;		//Writes to SC1A should produce software trigger...
	adc_measurement = ADC0->R[0];
	
	if(N==0) dac_out = adc_measurement;
	else{
		M = N-1;
		xnext = map((float)adc_measurement, 0.0f, 4095.0f, -1.65f, 1.65f);
		for(int i=0; i<NS; i++){		
			//DFII Implementation		
			V[i][0] = xnext - A[M][i][1]*V[i][1] - A[M][i][2]*V[i][2];
			xnext = B[M][i][0]*V[i][0] + B[M][i][1]*V[i][1] + B[M][i][2]*V[i][2];
			V[i][2] = V[i][1];
			V[i][1] = V[i][0];
		}
		dac_out = (uint16_t) map(0.90f*xnext, -1.65f, 1.65f, 0.0f, 4095.0f);
	}
	
	//Output to DAC0
	DAC0->DAT[0].DATL = DAC_DATL_DATA0( dac_out & 0xFFu )	;
	DAC0->DAT[0].DATH = DAC_DATH_DATA1( dac_out >> 8u )	;
	
	NVIC_ClearPendingIRQ(PIT0_IRQn);							//Clears interrupt flag in NVIC Register
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;		//Clears interrupt flag in PIT Register		
	
	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 1);
	
}

// FILTER SELECTION BUTTONS
void PORTB_IRQHandler(void){ //This function is called when the SW3 is pushed

    if(N == 4) N = 0;
    else { N++;}
		
		zeros2d(NS,3,V);

    NVIC_ClearPendingIRQ(PORTB_IRQn);                              //CMSIS Function to clear pending interrupts on PORTB
  PORTB->ISFR  |= PORT_PCR_ISF(0x1u);

}
void PORTC_IRQHandler(void){ //This function is called when the SW3 is pushed

    if(N == 0) N = 4;
    else { N--;}
		
		zeros2d(NS,3,V);

    NVIC_ClearPendingIRQ(PORTC_IRQn);                              //CMSIS Function to clear pending interrupts on PORTB
  PORTC->ISFR  |= PORT_PCR_ISF(0x1u);

}


int main(void){
	zeros2d(NS,3,V);
	zeros2d(NS,3,Y);
	
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	BUTTONS_Init();
	TimerInt_Init(5999u);
	
	while(1){
		//Main loop goes here
	}
}
	
