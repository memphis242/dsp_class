/**************************************************************************/
//Name:  MCG.c																														//
//Purpose:  Configure Multipurpose Clock Generator												//
//Author:  Ethan Hettwer																									//
//Revision:  1.0 09Sept2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"                 				//Device header
#include "MCG.h"																//Clock Header

/******************************************************************/
//						Function for Initialization of Clock to 120MHz			//
/******************************************************************/

void MCG_Clock120_Init(void){
	
	//Enable PTA
	SIM->SCGC5			|=SIM_SCGC5_PORTA_MASK		;		//Enable PTA XTAL
	PORTA->PCR[18]	= PORT_PCR_MUX(0)					;		//Set PTA18 to XTAL
  PORTA->PCR[19]	= PORT_PCR_MUX(0)					;		//Set PTA19 to XTAL
	
	//Enable HSRun
	SMC->PMPROT			= SMC_PMPROT_AHSRUN_MASK	;		//Allow High Speed Run
	SMC->PMCTRL			=	SMC_PMCTRL_RUNM(3u)			;		//Move to High Speed Run
	
	//Change Clock dividers
	SIM->CLKDIV1		=	SIM_CLKDIV1_OUTDIV2(1u)	|		//Change OUTDIV2 to divide by 2, Bus Clock = 60MHz
										SIM_CLKDIV1_OUTDIV3(3u)	|		//Change OUTDIV3 to divide by 4, FlexBux Clock = 30MHz
										SIM_CLKDIV1_OUTDIV4(4u)	|		//Change OUTDIV4 to divide by 5, Flash Clock = 24MHz
										0x00;
	
	//Transition from FEI TO FBE mode
	MCG->C2 				=	MCG_C2_RANGE(1u)				|		//High Frequency range (3MHz-32MHz)
										//MCG_C2_HGO_MASK				|		//High Gain Operation
										MCG_C2_EREFS_MASK				|		//Crystal being used
										0x00;
	//OSC_CR				= OSC_CR_ERCLKEN_MASK			;		//Enable external crystal
	MCG->C1					=	MCG_C1_CLKS(2u)					|		//External reference clock
										MCG_C1_FRDIV(3u)				|		//Divide by 256, puts 8MHz to 31.25kHz range required
										//MCG_C1_IREFS					|		//Clear to select external reference clock and enable external oscillator
										0x00;
	
	while((MCG->S & MCG_S_OSCINIT0_MASK) == 0);		//Wait until OSCINIT0 is set indicating crystal selected by C2[EREFS0] has been initialized
	while((MCG->S & MCG_S_IREFST_MASK)	!= 0)	;		//Wait until IREFST is cleared indicating external reference is current source for reference clock
	while((MCG->S & MCG_S_CLKST_MASK) != 8u)	;		//Wait until CLCKST = b01 indicating that the external reference clock is selected to feed MCGOUTCLK
	
	//Configure C5[PRDIV0] to generate correct PLL reference Frequency
	
	MCG->C5					= MCG_C5_PRDIV0(1u)				|		//Divide by 2 to get Reference clock to 4MHz
										0x00;
	
	//Transition from FBE to PBE mode
	MCG->C6					=	MCG_C6_PLLS_MASK				|		//Set PLLS to 1
										MCG_C6_VDIV0(6u)				|		//Set VDIV0 to 0x06, or multiply by 30 (4*30MHz=120MHz)
										0x00;
	
	while((MCG->S & MCG_S_PLLST_MASK) == 0)		;		//Wait until S[PLLST] is set, indicating that the current source for the PLLS clock is the PLL
	while((MCG->S & MCG_S_LOCK0_MASK) == 0)		;		//Wait until S[LOCK0] is set, indicating that the PLL has acquired lock
	
	//Transition from PBE to PEE mode
	MCG->C1					&=~MCG_C1_CLKS_MASK				;		//Select out put of PLL as system clock source
	while((MCG->S & MCG_S_CLKST_MASK) != 0xC)	;		//Wait until S[CLKST] = 3, indicating PLL output is selected to feed MCGOUTCLK in current mode
	
	//With PRDIV dividing by 2 and VDIV multiply-by-30 we achieve a clock rate of ((8MHz/2) * 30) = 120MHz
	
}//End MCG_Clock120_Init

/******************************************************************/
//						End Function for Initialization of Clock to 120MHz	//
/******************************************************************/
