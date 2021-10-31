//    //Ok let's see how to convert between unsigned and signed for our purposes

//    uint8_t input1 = 120;
//    uint8_t input2 = 200;
//    int8_t i1 = (int8_t) input1;
//    int8_t i2 = (int8_t) input2;
//
//    printf("\nInput 1: %d\ti1: %d\n", input1, i1);
//    printf("Input 2: %d\ti2: %d\n\n", input2, i2);
//
//    //Convert unsigned int inputs to desired range for calculations
//    uint8_t x1 = input1;
//    int8_t y1 = (int8_t) ((int16_t)x1 - 128);
//    uint8_t x2 = input2;
//    int8_t y2 = (int8_t) ((int16_t)x2 - 128);
//
//    printf("x1: %d\t\ty1: %d\nx1: %d\t\ty2: %d\n\n", x1, y1, x2, y2);
//
//    //Convert calculated output back to desired unsigned range for output
//    uint8_t z1 = (uint8_t) (y1+128);
//    uint8_t z2 = (uint8_t) (y2+128);
//
//    printf("z1: %d\nz2: %d\n\n", z1, z2);
