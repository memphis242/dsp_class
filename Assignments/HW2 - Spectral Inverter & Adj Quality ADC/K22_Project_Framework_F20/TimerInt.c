/**************************************************************************/
//Name:  TimerInt.c																												//
//Purpose:  Allow configuration and use of Timer Interrupts								//
//Author:  Ethan Hettwer																									//
//Revision:  1.1 12Sept2014 EH Convert to K22f														//
//					 1.0 4Sept2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"     					          	  //Device header
#include "TimerInt.h"																//Timer Interrupt Header

/******************************************************************/
//						Function for Initialization of TimerInt							//
/******************************************************************/

void TimerInt_Init(void){	
	
	//Configure NVIC - Nested Vector Interrupt Controller - Part of ARM Hardware that controls which interrupts are enabled
	NVIC_ClearPendingIRQ(PIT0_IRQn)								;		//CMSIS Function to clear pending interrupts on PIT
	NVIC_EnableIRQ(PIT0_IRQn)											;		//CMSIS Function to enable interrupt via PIT
	
	//Configure clock gating
	SIM->SCGC6 			|=SIM_SCGC6_PIT_MASK					;		//Enable clock to PIT
	
	//Configure PIT_MCR - Module Control Register, This enables or disable PIT timer clocks and controls timers while in debug mode.
	PIT->MCR 				= //PIT_MCR_MDIS_MASK					|		//While set this disables clock for standard PIT timers.  Set to allow setup.
										//PIT_MCR_FRZ_MASK					|		//While set this disables timers while debugging.
										0x00;
	
	//Configure PIT_LTMR64H - Upper Lifetime Timer Register - Used for chaining Timer 0 and Timer 1 for a 64 bit lifetimer
	//PIT->LTMR64H																;		//Read only, see manual for details
	
	//Configure PIT_LTMR64L - Lower Lifetime Timer Register - Used for chaining Timer 0 and Timer 1 for a 64 bit lifetimer
	//PIT->LTMR64L																;		//Read only, see manual for details
	
	//Configure PIT_LDVAL0 - Timer Load Value Register - Used to set period for PIT
	PIT->CHANNEL[0].LDVAL	=	PIT_LDVAL_TSV(5999u)	;		//Set Load value to XXXX clock cycles = YYYYY ms. --> For 10ksamples/s --> 100us per sample, with 60MHz bus clock, we need 6000 load value = 0x1770
	
	//Configure PIT_CVAL0 - Current Timer Value Register - holds current value for PIT
	//PIT->CHANNEL[0].CVAL												;		//Read only.  Read to find current value for PIT Timer
	
	//Configure PIT_TCTRL0 - Timer Control Register - Contains control bits for each timer
	PIT->CHANNEL[0].TCTRL	=	//PIT_TCTRL_CHN_MASK	|		//Chain mode.  When activated chains timers together to form a longer counter.
													PIT_TCTRL_TIE_MASK		|		//Timer Interupt Enable.  Request interrupt whenever TFLG0[TIF] is set.
													//PIT_TCTRL_TEN_MASK	|		//Timer Enable.  Set Enables or clear disables the timer.  Will be set upon completing configuration.
													0x00u;
													
	//Configure PIT_TFLG0 - Timer Flag Register - Contains PIT interrupt flags
	PIT->CHANNEL[0].TFLG	= PIT_TFLG_TIF_MASK			|		//Sets to 1 at end of timer period.  Writing 1 clears this bit.  If TCTRL[TIE] is set it also triggers an interrupt.
													0x00u;
	
	//Enable Timer after configuring
	PIT->CHANNEL[0].TCTRL |=PIT_TCTRL_TEN_MASK		;		//Timer Enable.  Set to 1 to enable timer.
	
}//End TimerInt_Init

/******************************************************************/
//						End Function for Initialization of TimerInt					//
/******************************************************************/
