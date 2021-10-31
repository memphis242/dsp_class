/**************************************************************************/
//Name:  ADC.c																														//
//Purpose:  Allow configuration and use of ADC														//
//Author:  Ethan Hettwer																									//
//Revision:  1.1 15Sept2014	EH Confert to K22f														//
//					 1.0 29Aug2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"                				 	//Device header
#include "ADC.h"																// ADC header

/******************************************************************/
//						Function for Initialization of ADC									//
/******************************************************************/

void ADC_Init(void){
	
	//Configure clock gating and disable while configuring
	SIM->SCGC6 			|=SIM_SCGC6_ADC0_MASK			;		//Enable clock to ADC module
	ADC0->SC1[0] 		|=ADC_SC1_ADCH(0xFF)			;		//Disable ADC while configuring
	
	//Set ADC Hardware trigger on PIT Trigger 0
	//SIM->SOPT7			|=0x4U;
	
	//Configure pin(s)

	//Configure ADC Registers
	
	//Configure ADC0_SC1n - Status and Control Registers 1, Controls SE/DE mode, checks conversion complete and which channel to be read from.
	//For software trigger we only configure ADC0_SC1[0], for HW trigger we can configure ADC0_SC1[1] for multiple concurrent conversions.
	ADC0->SC1[0] 		=	//ADC_SC1_COCO_MASK			|		//Read only, if set conversion is completed.
										//ADC_SC1_AIEN_MASK			|		//If enabled allows conversion complete interrupts.  When COCO is set while AIEN = 1, an interrupt is triggered.
										//ADC_SC1_DIFF_MASK   	|		//If enabled differential conversions are enabled.  Leave as 0 for single ended conversions.
										ADC_SC1_ADCH(0x00)			|		//Controls which channel is read from.  15 disables, which will be left until we are ready to select the read pin. --> I've chosen DAD0, which works with ADC0_DP0 and DM0 pins I think
										0x00u;
	
	//Configure ADC0_CFG1 - Configuration Register 1, controls mode of operation, clock source, clock divide, low power and long sample time settings
	ADC0->CFG1			=	//ADC_CFG1_ADLPC_MASK		|		//Controls power configuration.  If set power is reduced at expense of max clock speed.
										ADC_CFG1_ADIV(0x02)			|		//Controls Divide ratio, where ratio is 2^n.
										//ADC_CFG1_ADLSMP_MASK	|		//Controls sample time.  Adjusts sample period to allow high impedance inputs or to maximize conversion speed.
										ADC_CFG1_MODE(0x01)			|		//Controls mode of conversion.  0 = 8 Bit, 1 = 12 bit, 2 = 10 bit, 3 = 16 bit.  This changes if differential measuring is enabled (See Ref Manual)
										ADC_CFG1_ADICLK(0x00)		|		//Controls the input clock.  0 = Bus clock, 1 = Bus clock/2, 2 = Alt Clock, 3 = Async Clock
										0x00u;
								
	//Configure ADC0_CFG2 - Configuration Register 2, controls high-speed configuration for very high speed conversions and long sample time for long sample mode.
	ADC0->CFG2			=	//ADC_CFG2_MUX_SEL_MASK	|		//Controls which set of ADC channels are being sampled, 0 samples ADxxa and 1 samples ADxxb.
										//ADC_CFG2_ADACKEN_MASK	|		//Always runs Async Clock and allows async clock to be used even if ADC is idle.
										//ADC_CFG2_ADHSC_MASK		|		//Configures the ADC for very high-speed conversions.  See conversion time section for more info.
										ADC_CFG2_ADLSTS(0x03)		|		//Configures long sample time if CFG1[ADLSMP] = 1.  Setting to be in a known state.  See conversion time section for more info.
										0x00u;
								
	//Configure ADC0_R - Data Result Register, contains result after ADC conversion of the channel selected by corresponding status and control register (SC1A or SC1B).
	//Unused bits are always cleared and data is right aligned.
	//ADC0->R[0] 															;		//Read only, holds result of conversion.
	
	//Configure ADC0_CV1 and CV2 - Compare Value Registers 1 and 2, contain value to be copmpared when conversion is complete.
	ADC0->CV1 			=	ADC_CV1_CV(0x00)				|		//Configures compare values if SC2[ACFE] = 1.  Setting to be in a known state.
										0x00u;
	ADC0->CV2				=	ADC_CV2_CV(0x00)				|		//Configures compare values if SC2[ACFE] = 1.  Only used if SC2[ACREN] = 1, or the "compare range" function is enabled.  Setting to be in a known state.
										0x00u;
								
	//Configure ADC0_SC2 - Status and Control Register 2, contains conversion active flag, hardware/software trigger slect, compare function and reference voltage select.
	ADC0->SC2 			=	//ADC_SC2_ADACT_MASK		|		//Read only.  When this bit is set it means a conversion is currently active.  It is cleared when a conversion is completed or aborted.
										//ADC_SC2_ADTRG_MASK		|		//Trigger select bit.  If cleared software trigger is enabled, if set, hardware trigger is enabled.
										//ADC_SC2_ACFE_MASK			|		//Compare function enable.  If cleared compare is disabled, if set, compare is enabled.  Based on ADC_CV1 and ADC_CV2.
										//ADC_SC2_ACFGT_MASK		|		//Compare function greater than enable.  Compares result relative to CV1 and CV2 based upon SC2[ACREN].  SC2[ACFE] must be set to have any effect.
										//ADC_SC2_ACREN_MASK		|		//Compare function range enable.  If cleared only compared to CV1, if set compared to both CV1 and CV2.  SC2[ACFE] must be set to have any effect.
										//ADC_SC2_DMAEN_MASK		|		//DMA Enable bit.  If cleared DMA is disabled, if set will assert the ADC DMA request when SC1n[COCO] is asserted.
										ADC_SC2_REFSEL(0x00)		|		//Vref select.  0 = Default to Vrefh and Vrefl external pins.  1 = alternate pins.  See chip configuration info in manual for details.  2&3 reserved.
										0x00u;
								
	//Configure ADC0_SC3 - Status and Control Register 3, contains calibration, continuous convert and hardware averaging functions.
	ADC0->SC3				=	//ADC_SC3_CAL_MASK			|		//Calibration.  Set to begin calibration sequence.  This stays set while calibration is in progress and is cleared when completed.
										//ADC_SC3_CALF_MASK			|		//Read Only.  Calibration failed flag.
										//ADC_SC3_ADCO_MASK			|		//Continus conversion enable.  If cleared will take a single conversion, if set will take continus conversions.
										//ADC_SC3_AVGE_MASK			|		//Hardware average enable.  If set hardware average is enabled.
										ADC_SC3_AVGS(0x00)			|		//Hardware average select.  Determines how many conversions are averaged.  0 = 4 samples, 1 = 8 samples, 2 = 16 samples, 11 = 32 samples.						
										0x00u;

}//End ADC_Init

/******************************************************************/
//						End Function for Initialization of ADC							//
/******************************************************************/

/******************************************************************/
//						Function for Calibration of ADC											//
/******************************************************************/

void ADC_Calibrate(void){
	uint16_t Cal_Var = 0;
	//Change settings to allow optimal calibration.  This should be run after ADC_Init.
	ADC0->CFG1		|=ADC_CFG1_ADIV(0x03)				;		//Change clock divide to divide by 8.  For 24MHz bus clock, this makes the ADC clock 3MHz.
	ADC0->SC3  		|=ADC_SC3_AVGE_MASK					|		//Enable Hardware averaging.
									ADC_SC3_AVGS(0x03)				|		//Set AVGS to 3 for 32 sample averaging.
									ADC_SC3_CAL_MASK					;		//Set Calibration flag.  This begins the calibration sequence.
	
	while(!((ADC0->SC1[0])&ADC_SC1_COCO_MASK));		//Wait for calibration to complete.
	while((ADC0->SC3)& ADC_SC3_CALF_MASK);				//Calibration failed, lock up.
	
	//Begin plus-side calibration
	Cal_Var = ADC0->CLP0 + ADC0->CLP1 + ADC0->CLP2 + ADC0->CLP3 + ADC0->CLP4 + ADC0->CLPS; //Add plus side calibration results.
	Cal_Var = Cal_Var >> 1;												//Right Shift by 1, divide by two.
	Cal_Var |= (1u << 15u);												//Set MSB
	ADC0->PG = Cal_Var		;												//Set PG equal to Cal_Var
	
	//Begin minus-side calibration
	Cal_Var = ADC0->CLM0 + ADC0->CLM1 + ADC0->CLM2 + ADC0->CLM3 + ADC0->CLM4 + ADC0->CLMS; //Add minus side calibration results.
	Cal_Var = Cal_Var >> 1;												//Right Shift by 1, divide by two.
	Cal_Var |= (1u << 15u);												//Set MSB
	ADC0->MG = Cal_Var		;												//Set MG equal to Cal_Var
	
	//Reset ADC to previous values
	ADC_Init();
}//End ADC_Calibrate

/******************************************************************/
//						End Function for Calibration of ADC									//
/******************************************************************/
