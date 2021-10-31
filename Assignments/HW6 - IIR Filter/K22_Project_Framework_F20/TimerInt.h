/**************************************************************************/
//Name:  TimerInt.h																												//
//Purpose:  Allow configuration and use of Timer Interrupts								//
//Author:  Ethan Hettwer																									//
//Revision:  1.1 12Sept2014 EH Convert to K22f														//
//					 1.0 4Sept2014 EH Initial Revision														//
//Target:  Freescale K22f																									//
/**************************************************************************/

#include "MK22F51212.h"

#ifndef __TIMERINT_H_
#define __TIMERINT_H_

void TimerInt_Init(uint32_t ldval); 											//Initialize Timer Interrupt

#endif
