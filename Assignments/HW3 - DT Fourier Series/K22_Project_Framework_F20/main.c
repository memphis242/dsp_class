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
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define PI 3.14159265

uint16_t y;
uint16_t dac_out;
uint8_t i = 0;
uint8_t K = 4;
//uint8_t a = 12;
float fy = 2e2;
float Y0 = 0.99;
float* yhat;
uint8_t size_yhat;

float Ck[10] = {0.6513, 0.8942, 0.4322, 0.2387, 0.1312, 0.2314, 0.2226, 0.1337, 0.0658, 0.1079};
float Ok[10] = {-1.9174, 2.6620, -0.6346, 2.8995, 1.3452, -1.6801, 1.6153, -1.5630, 2.7450, 0.4671};


void PIT0_IRQHandler(void){	//This function is called when the timer interrupt expires
	//Place Interrupt Service Routine Here
//	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;
	
	
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	
	dac_out = (uint16_t) map(yhat[i], -0.5, 3.5, 0, 4095);
	
	//Output to DAC0
	DAC0->DAT[0].DATL = DAC_DATL_DATA0( dac_out & 0xFFu )	;
	DAC0->DAT[0].DATH = DAC_DATH_DATA1( dac_out >> 8 )	;
	
	NVIC_ClearPendingIRQ(PIT0_IRQn);							//Clears interrupt flag in NVIC Register
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK;		//Clears interrupt flag in PIT Register		
	
	if(i==(size_yhat-1)) i = 0;
	else i++;
	
	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 1);
	
}

void PORTB_IRQHandler(void){
		
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	if(K<=4) K++;
	update_yhat();
	
//	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 5);
	
	NVIC_ClearPendingIRQ(PORTB_IRQn);							//Clears interrupt flag in NVIC Register
	PORTB->PCR[1] |= PORT_PCR_ISF(1u);
	
	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 1);
}

void PORTC_IRQHandler(void){
	
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	if(K<=4) K--;
	update_yhat();
	
//	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 5);
	
	
	NVIC_ClearPendingIRQ(PORTB_IRQn);							//Clears interrupt flag in NVIC Register
	PORTC->PCR[2] |= PORT_PCR_ISF(1u);
	
	GPIOA->PCOR			|= GPIO_PCOR_PTCO(0x1u << 1);
}


void update_yhat(){
	float Fn = 2*fy*K;
	float Fs = 12*Fn;
	float T = 1/Fs;
	uint32_t ldval = (uint32_t) (60e6 / Fs) - 1u;
	PIT->CHANNEL[0].LDVAL	=	PIT_LDVAL_TSV(ldval);
	size_yhat = 12*K;
	
	yhat = (float*)malloc(size_yhat * sizeof(float));
	zeros(yhat, size_yhat);
	
	float harmonics[K][size_yhat];
	zeros2d(K, size_yhat, harmonics);
	generate_harmonics(K, size_yhat, harmonics, fy, K, Ck, Ok);
	
	add_const_vec(Y0, yhat, size_yhat);
	for(int k=0; k<K; k++){
		add_vecs(yhat, harmonics[k], yhat, size_yhat);
	}
}




int main(void){
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	TimerInt_Init(4999u);
	PORT_Init();
	
	update_yhat();
	
	while(1){
		//Main loop goes here
	}
}
	
