////These will be macros later
//    uint8_t Lh = 4u;
//    uint8_t num_of_adds = Lh-1;
//    uint8_t QI_coeff = 0u;
//    uint8_t QF_coeff = 16u - QI_coeff;
//    uint8_t QI_adc = 2u;
//    uint8_t QF_adc = 12 - QI_adc;
//    uint8_t QI_acc = QI_adc + QI_coeff + 2u; //ceil(log2(num_of_adds))
//    uint8_t QF_acc = QF_adc + QF_coeff;
//    uint8_t QI_y = QI_acc;
//    uint8_t QF_y = 16u - QI_acc;
//    uint8_t acc_to_y_shift = QF_acc - QF_y;
//    uint8_t QI_dac = QI_y;
//    uint8_t QF_dac = 12 - QI_dac;
//    uint8_t y_to_dac_shift = QF_y - QF_dac;
//
//    //Now let's try out a run of a 4th order FIR filter
//    //Read adc inputs
//    uint16_t adc0 = 0x0FFF;
//    uint16_t adc1 = 0x0FFF;
//    uint16_t adc2 = 0x0FFF;
//    uint16_t adc3 = 0x0FFF;
//
//    //Convert unsigned inputs to signed values (about the midpoint 2048) for processing
//    int16_t x0 = (int16_t) ((int32_t)adc0 - (1<<11));
//    int16_t x1 = (int16_t) ((int32_t)adc1 - (1<<11));
//    int16_t x2 = (int16_t) ((int32_t)adc2 - (1<<11));
//    int16_t x3 = (int16_t) ((int32_t)adc3 - (1<<11));
//
//    //Coefficients in fixed-point
//    int16_t h0 = 0x2669;
//    int16_t h1 = 0x733d;
//    int16_t h2 = 0x733d;
//    int16_t h3 = 0x2669;
//
//    //Process
//    int32_t acc = ((int32_t)x0)*h0 + ((int32_t)x1)*h1 + ((int32_t)x2)*h2 + ((int32_t)x3)*h3;
////    int16_t y = acc >> 14;
////    int32_t acc = ((int32_t)x0)*h1;
////    int16_t y = acc >> 12;
////    int32_t acc = ((int32_t)x0)*h0 + ((int32_t)x1)*h1;
//    int16_t y = acc >> acc_to_y_shift;
//
//    //Dacout
//    uint16_t dacout = (((uint16_t) (y+(1<<15))) & 0xFFF0) >> 4;  //Convert signed back to unsigned and take upper 12 bits and shift
//    float dacrep = (float)dacout / (1<<QF_dac);
//
//    //To compare with expected result...
//    float xf = 3.9990234375f;
//    float h0f = 0.150052719359518f;
//    float h1f = 0.450158158078553f;
//    float h2f = h1f;
//    float h3f = h0f;
//    float yf = xf*(h0f + h1f + h2f + h3f);
//
//    printf("ADC Input: %d\t\t\tDAC Output: %d\t\tCorresponding Number: %f\n", adc0, dacout,dacrep);
//    printf("Actual Input: %f\t\tActual Output: %f\n\n", xf, yf);
