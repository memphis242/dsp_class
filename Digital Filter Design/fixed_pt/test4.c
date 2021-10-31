//    //Ok let's see how to convert between unsigned and signed for our purposes
//
//    float h1 = 0.4792131002f;
//    float h2 = -0.2314 * h1;
//    int16_t H1 = (int16_t) (h1*(1<<15));
//    int16_t H2 = (int16_t) (h2*(1<<15));
//    float hp1 = (float)H1 / (1<<15);
//    float hp2 = (float)H2 / (1<<15);
//    printf("h1: %f\t\tH1: %d\th1': %f\n\n", h1, H1, hp1);
//    printf("h2: %f\t\tH2: %d\th2': %f\n\n", h2, H2, hp2);
//
//    float v = 2.835f;
//    uint16_t V = (uint16_t) (v*(1<<10));    //v = 2.835V as Q2.10 --> 2903u
//    float vp = (float)V / (1<<10);
//    printf("v: %f\t\tV: %d\t\tv': %f\n\n", v, V, vp);
//
//    //Convert unsigned int inputs to desired range for calculations
//    float x = v - 1.65f;
//    int16_t X = (int16_t) (x*(1<<13));
////    V = V * (1<<3);
////    int16_t X = (int16_t) ((int32_t)V - (1<<11));     //Should get the +1.185V representation, which would be
////    X = X * (1<<3);
//    float xp = (float)(X) / (1<<13);
//    printf("x: %f\t\tX: %d\t\tx': %f\n\n", x, X, xp);
//
//    //Now process
//    int32_t ACC = (int32_t)X*H1 + (int32_t)X*H2;    //X is Q3.13 and H is Q0.15, so result of multiply is Q3.28 and adds Q4.28
//    float acc = (float)ACC / (1<<28);
//    float y = x*h1 + x*h2;
//    int16_t Y = ACC >> 16;  //Y needs to be Q4.12, so shift ACC by 16 to get Q4.28 --> Q4.12
//    float yp = (float)Y / (1<<12);
//    printf("ACC: %d\t\tacc: %f\ny: %f\t\tY: %d\t\t\ty': %f\n\n", ACC, acc, y, Y, yp);
