//    //The following will be in fixed-point execution of the operation 1.667*(-0.75) + 2.6 using 8-bit WL

//    int8_t a = 0x6A;    //Q2.6, 106, 1.667
//    int8_t b = 0xA0;    //Q1.7, -96, -0.75
//    int8_t c = 0x53;    //Q3.5, 83, 2.6
//
//    int16_t prod, sum;
//    int8_t prod8t, result;
//
//    prod = (int16_t)a * b;
//    prod8t = (int8_t)(prod >> 8);
//
//    sum = prod8t + c;
//    result = (int8_t) sum;
//
//    if(sum > 127) result = 0x7F;
//    else if(sum < -127) result = 0x80;
//    else result = (int8_t) sum;
//
//    //Result should be 1.375, 44 (Q3.5)
//    float final_result = (float)result / (1<<5);    //This is the same as result * 2^(-5)
//    printf("%f vs 1.34975\n", final_result);
//
//
//////    Now let's compare to floating-point execution
////    float a = 1.667f;
////    float b = -0.75f;
////    float c = 2.6f;
////
////    float resultf = a*b + c;
////    printf("%f vs 1.34975\n", resultf);
