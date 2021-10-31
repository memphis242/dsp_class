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
#include "DAC.h"																//DAC Header
#include "PORT.h"
#include "useful_func.h"

#define PI 3.14159265



int main(void){
	MCG_Clock120_Init();
	DAC_Init();
	PORT_Init();

	GPIOB->PSOR		|= GPIO_PSOR_PTSO(1u << 0);

	while(1){
		//Main loop goes here
	}
}

