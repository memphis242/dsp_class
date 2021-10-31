////Ok now to practice some multiply and accumulate /w some
//    //Ok let's see how to convert between unsigned and signed for our purposes
//
//    float h = 0.4792131002f;
//    int16_t H = (int16_t) (h*(1<<16));
//    float hp = (float)H / (1<<16);
//    printf("h: %f\t\tH: %d\th': %f\n\n", h, H, hp);
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
//    int32_t ACC = (int32_t)X*H;
//    float acc = (float)ACC / (1<<29);
//    float y = x*h;
//    int16_t Y = ACC >> 16;
//    float yp = (float)Y / (1<<13);
//    printf("ACC: %d\t\tacc: %f\ny: %f\t\tY: %d\t\t\ty': %f\n\n", ACC, acc, y, Y, yp);
