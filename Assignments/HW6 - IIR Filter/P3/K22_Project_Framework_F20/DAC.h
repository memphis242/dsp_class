/**************************************************************************/
//Name:  DAC.c																														//
//Purpose:  Allow configuration and use of DAC														//
//Author:  Ethan Hettwer																									//
//Revision:  1.1 15Sept2014	EH Confert to K22f														//
//					 1.0 29Aug2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"

#ifndef __DAC_H_
#define __DAC_H_

void DAC_Init(void);														//Initialize DAC

void DAC_Timer_Init(float time_interval);											//Setup timer for DAC output; time_interval in nanoseconds

#endif
