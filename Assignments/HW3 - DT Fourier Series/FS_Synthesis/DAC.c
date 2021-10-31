/**************************************************************************/
//Name:  DAC.c																														//
//Purpose:  Allow configuration and use of DAC														//
//Author:  Ethan Hettwer																									//
//Revision:  1.2 03Aug2020 CTP fix DATH/DATL															//
//					 1.1 15Sept2014	EH Confert to K22f														//
//					 1.0 29Aug2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"                 				//Device header
#include "DAC.h"																//DAC header

/******************************************************************/
//						Function for Initialization of DAC									//
/******************************************************************/

void DAC_Init(void){
	
	//Configure clock gating and disable while configuring
	SIM->SCGC6 |= SIM_SCGC6_DAC0_MASK					;		//Enable clock to ADC module
	DAC0->C0	 &= ~(DAC_C0_DACEN_MASK)				;		//Disable DAC
	
	//Configure DAC Registers
	
	//Configure DAC_DAT - Data low/high register.  Vout = Vin * (1+DAC_DAT[11:0])/4096
	DAC0->DAT[0].DATL = DAC_DATL_DATA0(0x00)	;		//Set Output to 0.
	DAC0->DAT[0].DATH = DAC_DATH_DATA1(0x00)	;		//Set Output to 0.
	
	//Configure DAC0_SR - Status Register, writing 0 clears, writing 1 has no effect.
	DAC0->SR 				=	DAC_SR_DACBFRPTF_MASK		|		//DAC Buffer Read Pointer Top Position Flag, cleared if pointer is not 0, set if pointer is 0.
										//DAC_SR_DACBFRPBF_MASK |		//DAC Buffer Read Pointer Bottom Position Flag, cleared if pointer is not = C2[DACBFUP], set if is equal.
										0x00u;
	
	//Configure DAC0_C0 - Control Register 0, DO NOT USE 32 OR 16 BIT ACCESSES TO THIS REGISTER!!!
	DAC0->C0				=	//DAC_C0_DACEN_MASK			|		//DAC enable bit.
										DAC_C0_DACRFS_MASK			|		//DAC Reference Select.  If cleared use DACREF_1, if set use DACREF_2.
										//DAC_C0_DACTRGSEL_MASK	|		//DAC Trigger Select.  If cleared hardware triggered, if set software triggered.
										//DAC_C0_DACSWTRG_MASK	|		//DAC SW Trigger.  Write only, always reads 0.  If cleared software trigger not valed, if set software trigger valid.
										//DAC_C0_LPEN_MASK			|		//Low Power Control.  If cleared high power mode, if set low power mode.
										//DAC_C0_DACBTIEN_MASK	|		//DAC Buffer read pointer top flag interrupt enable.  If cleared disabled, if set enabled.
										//DAC_C0_DACBBIEN_MASK	|		//DAC Buffer read pointer bottom flag interrupt enable.  If cleared disabled, if set enabled.
										(uint8_t)0x00u;
										
	//Configure DAC0_C1 - Control Register 1, DO NOT USE 32 OR 16 BIT ACCESSES TO THIS REGISTER!!!
	DAC0->C1				= //DAC_C1_DMAEN_MASK			|		//DMA Enable.  If cleared disable, if set enabled.
										//DAC_C1_DACBFMD_MASK		|		//DAC Buffer Work Mode Select.  If cleared normal, if set one-time scan mode.
										//DAC_C1_DACBFEN_MASK		|		//DAC Buffer Enable.  If cleared converted data is always first word of the buffer, if set data is word read pointer points to.
										(uint8_t)0x00u;
										
	//Configure DAC0_C2 - Control Register 2, DO NOT USE 32 OR 16 BIT ACCESSES TO THIS REGISTER!!!
	DAC0->C2				=	//DAC_C2_DACBFRP_MASK		|		//DAC Buffer Read Pointer.  Keeps current value of buffer read pointer.
										//DAC_C2_DACBFUP_MASK		|		//DAC Buffer Upper Limit.  Selects upper limit of DAC buffer.
										(uint8_t)0x00u;
										
	//Enable DAC0 after configuration complete.
	DAC0->C0				|=DAC_C0_DACEN_MASK				|		//Enable DAC.
										(uint8_t)0x00u;
}//End DAC_Init					

/******************************************************************/
//						End Function for Initialization of DAC							//
/******************************************************************/



//time_interval is in nanoseconds
void DAC_Timer_Init(float time_interval){	
	
	//Calculate needed load value into PIT1_LDVAL register, assuming 60MHz bus clock, which is what the PIT module goes off of
	float clock_interval = 100.0/6;		//In nanoseconds, the clock cycle at 60MHz is around 16.667 nanoseconds, or 100/6
	uint32_t ld_val = (uint32_t) (time_interval/clock_interval) - 1;
	
	//Configure NVIC - Nested Vector Interrupt Controller - Part of ARM Hardware that controls which interrupts are enabled
	NVIC_ClearPendingIRQ(PIT1_IRQn)								;		//CMSIS Function to clear pending interrupts on PIT
	NVIC_EnableIRQ(PIT1_IRQn)											;		//CMSIS Function to enable interrupt via PIT
	
	//Configure clock gating
	SIM->SCGC6 			|=SIM_SCGC6_PIT_MASK					;		//Enable clock to PIT
	
	//Configure PIT_MCR - Module Control Register, This enables or disables PIT timer clocks and controls timers while in debug mode.
	PIT->MCR 				= //PIT_MCR_MDIS_MASK					|		//While set this disables clock for standard PIT timers.  Set to allow setup.
										//PIT_MCR_FRZ_MASK					|		//While set this disables timers while debugging.
										0x00;
	
	//Configure PIT_LTMR64H - Upper Lifetime Timer Register - Used for chaining Timer 0 and Timer 1 for a 64 bit lifetimer
	//PIT->LTMR64H																;		//Read only, see manual for details
	
	//Configure PIT_LTMR64L - Lower Lifetime Timer Register - Used for chaining Timer 0 and Timer 1 for a 64 bit lifetimer
	//PIT->LTMR64L																;		//Read only, see manual for details
	
	//Configure PIT_LDVAL0 - Timer Load Value Register - Used to set period for PIT
	PIT->CHANNEL[1].LDVAL	=	PIT_LDVAL_TSV(ld_val)	;		//Set Load value to XXXX clock cycles = YYYYY ms. --> For 10ksamples/s --> 100us per sample, with 60MHz bus clock, we need 6000 load value = 0x1770
	
	//Configure PIT_CVAL0 - Current Timer Value Register - holds current value for PIT
	//PIT->CHANNEL[0].CVAL												;		//Read only.  Read to find current value for PIT Timer
	
	//Configure PIT_TCTRL0 - Timer Control Register - Contains control bits for each timer
	PIT->CHANNEL[1].TCTRL	=	//PIT_TCTRL_CHN_MASK	|		//Chain mode.  When activated chains timers together to form a longer counter.
													PIT_TCTRL_TIE_MASK		|		//Timer Interupt Enable.  Request interrupt whenever TFLG0[TIF] is set.
													//PIT_TCTRL_TEN_MASK	|		//Timer Enable.  Set Enables or clear disables the timer.  Will be set upon completing configuration.
													0x00u;
													
	//Configure PIT_TFLG0 - Timer Flag Register - Contains PIT interrupt flags
	PIT->CHANNEL[1].TFLG	= PIT_TFLG_TIF_MASK			|		//Sets to 1 at end of timer period.  Writing 1 clears this bit.  If TCTRL[TIE] is set it also triggers an interrupt.
													0x00u;
	
	//Enable Timer after configuring
	PIT->CHANNEL[1].TCTRL |=PIT_TCTRL_TEN_MASK		;		//Timer Enable.  Set to 1 to enable timer.
	
}//End TimerInt_Init
