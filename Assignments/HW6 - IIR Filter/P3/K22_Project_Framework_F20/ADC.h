/**************************************************************************/
//Name:  ADC.h																														//
//Purpose:  Allow configuration and use of ADC														//
//Author:  Ethan Hettwer																									//
//Revision:  1.1 15Sept2014	EH Confert to K22f														//
//					 1.0 29Aug2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#ifndef __ADC_H_
#define __ADC_H_

void ADC_Init(void);														//Initialize ADC

void ADC_Calibrate(void);												//Calibrate ADC **MUST BE RUN AFTER ADC_INIT**

#endif
