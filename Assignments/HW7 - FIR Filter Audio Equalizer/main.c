#include "MK22F51212.h"                 				//Device header
#include "MCG.h"																//Clock header
#include "TimerInt.h"														//Timer Interrupt Header
#include "ADC.h"																//ADC Header
#include "DAC.h"																//DAC Header
#include "BUTTONS.h"
#include "coeffH.h"
#include "useful_func.h"

uint8_t filter_select = 0u;

uint16_t adc_measurement;
uint16_t dac_out;

int16_t X[Lh];
int64_t ACC = 0;
int16_t Y = 0;
int16_t Xin = 0;

//double x[Lh];
//double y = 0.0f;
//double xin = 0.0f;

void PIT0_IRQHandler(void){	//This function is called when the timer interrupt expires
	//Place Interrupt Service Routine Here
	GPIOA->PSOR			|= GPIO_PSOR_PTSO(0x1u << 1);
	
	
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0x00)			;		//Writes to SC1A should produce software trigger...
	adc_measurement = ADC0->R[0];
	
	
	if(filter_select == 0) dac_out = adc_measurement;
	else{
		
		Xin = (int16_t)adc_measurement*270336/40950 - (135168/10);	
		
		//Shift in new input
		for(int16_t i=L; i>0; i--){
			X[i] = X[i-1];
		}
		X[0] = Xin;
		
		//Now apply difference equation
		for(uint16_t i=0; i<Lh; i++){		
			ACC += (int64_t)H[i]*X[i];
		}
		Y = ACC >> ACCtoYshift;
		
//		if(Y > YHigh) Y = YHigh;
//		else if(Y < YLow) Y = YLow;
		dac_out = (uint16_t) (((Y*1240)/(1<<QFy)) + 2048);
		
		ACC = 0;
		
//		xin = ((float)adc_measurement*(3.3f/4095.0f) - 1.65f);
//		for(int16_t i=L; i>0; i--){
//			x[i] = x[i-1];
//		}
//		x[0] = xin;

//		for(uint16_t i=0; i<Lh; i++){		
//			y += h[i]*x[i];
//		}

//		dac_out = (uint16_t) map(y,-1.65f,1.65f,0.0f,4095.0f);
//		y = 0.0f;
	
		
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
	
	GPIOB->PSOR			|= GPIO_PSOR_PTSO(0x1u << 19);
	filter_select = 0x00u;

	NVIC_ClearPendingIRQ(PORTB_IRQn);                              //CMSIS Function to clear pending interrupts on PORTB
  PORTB->ISFR  |= PORT_PCR_ISF(0x1u);

}

void PORTC_IRQHandler(void){ //This function is called when the SW3 is pushed

	GPIOB->PCOR			|= GPIO_PCOR_PTCO(0x1u << 19);
	filter_select = 0xFF;

	NVIC_ClearPendingIRQ(PORTC_IRQn);                              //CMSIS Function to clear pending interrupts on PORTB
  PORTC->ISFR  |= PORT_PCR_ISF(0x1u);

}




int main(void){
	zeros_int16(X,Lh);
//	zeros(x,Lh);
	
	MCG_Clock120_Init();
	ADC_Init();
	ADC_Calibrate();
	DAC_Init();
	BUTTONS_Init();
	TimerInt_Init(2999u);		//20kHz sample rate
	
	while(1){
		//Main loop goes here
	}
}
	
