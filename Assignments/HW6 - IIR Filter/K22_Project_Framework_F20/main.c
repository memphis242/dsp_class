#include "MK22F51212.h"                 				//Device header
#include "MCG.h"																//Clock header
#include "TimerInt.h"														//Timer Interrupt Header
#include "ADC.h"																//ADC Header
#include "DAC.h"																//DAC Header
#include "PORT.h"
#include "useful_func.h"
#include "coef.h"
//#include "coef_lpf_test.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

uint16_t y;
uint16_t adc_measurement;
uint16_t dac_out;


// The following represent my stages; I will be using circular addressing using xptr and yptr
//float X[NS][3];
float V[NS][3];
float Y[NS][3];
float xin = 0.0f;
float xnext = 0.0f;
//float ynew = 0.0f;
//float yvals[3];
//float xvals[3];
uint8_t xptr = 0u;
uint8_t vptr = 0u;
uint8_t yptr = 0u;



void PIT0_IRQHandler(void){	//This function is called when the timer interrupt expires
	//Place Interrupt Service Routine Here
//	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;
	
	
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0x00)			;		//Writes to SC1A should produce software trigger...
	adc_measurement = ADC0->R[0];
	xin = map((float)adc_measurement, 0.0f, 4095.0f, -1.65f, 1.65f);
	
//	dac_out = adc_measurement;
	
	
//	xvals[1] = xvals[0];
//	xvals[0] = xin;
//	ynew = 0.055555555f*xvals[0] + 0.044444444f*xvals[1] + 0.9f*yvals[1];
//	yvals[1] = yvals[0];
//	yvals[0] = ynew;
//	
//	dac_out = (uint16_t) map(ynew, -1.65f, 1.65f, 0.0f, 4095.0f);	
	
	
	xnext = xin;
	for(int i=0; i<NS; i++){
		
//		X[i][2] = X[i][1];
//		X[i][1] = X[i][0];
//		X[i][0] = xnext;
//		Y[i][2] = Y[i][1];
//		Y[i][1] = Y[i][0];
//		Y[i][0] = B[i][0]*X[i][0] + B[i][1]*X[i][1] + B[i][2]*X[i][2] - A[i][1]*Y[i][1] - A[i][2]*Y[i][2];
		
		//DFII Implementation
//		V[i][vptr] = xnext - A[i][1]*V[i][(vptr+1)%3] - A[i][2]*V[i][(vptr+1)%3];
//		Y[i][yptr] = B[i][0]*V[i][vptr] + B[i][1]*V[i][(vptr+1)%3] + B[i][2]*V[i][(vptr+2)%3];
//		xnext = Y[i][yptr];
//		vptr = (vptr+1)%3;
//		yptr = (yptr+1)%3;

//		V[i][2] = V[i][1];
//		V[i][1] = V[i][0];
//		V[i][0] = xnext - A[i][1]*V[i][1] - A[i][2]*V[i][2];
//		Y[i][2] = Y[i][1];
//		Y[i][1] = Y[i][0];
//		Y[i][0] = B[i][0]*V[i][0] + B[i][1]*V[i][1] + B[i][2]*V[i][2];
//		xnext = Y[i][0];
		
		V[i][0] = xnext - A[i][1]*V[i][1] - A[i][2]*V[i][2];
		xnext = B[i][0]*V[i][0] + B[i][1]*V[i][1] + B[i][2]*V[i][2];
		V[i][2] = V[i][1];
		V[i][1] = V[i][0];
		
//		xnext = Y[i][0];
		
	}
	
	dac_out = (uint16_t) map(0.80f*xnext, -1.65f, 1.65f, 0.0f, 4095.0f);

	
	//Output to DAC0
	DAC0->DAT[0].DATL = DAC_DATL_DATA0( dac_out & 0xFFu )	;
	DAC0->DAT[0].DATH = DAC_DATH_DATA1( dac_out >> 8u )	;
	
	NVIC_ClearPendingIRQ(PIT0_IRQn);							//Clears interrupt flag in NVIC Register
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;		//Clears interrupt flag in PIT Register		

	
	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 1);
	
}

int main(void){
	zeros2d(NS,3,V);
	zeros2d(NS,3,Y);
	
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	PORT_Init();
	TimerInt_Init(5999u);
	
	while(1){
		//Main loop goes here
	}
}
	
