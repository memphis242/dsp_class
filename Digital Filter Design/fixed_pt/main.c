#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

#define HSCALE ((uint64_t)1 << 32)
#define ACCSCALE ((uint64_t)1 << 45)
#define QIh 0
#define QFh 32
#define QIx 3
#define QFx 13  //16-QIx
#define L 4
#define G 2 //ceil(log2(L))
#define QIacc (QIh+QIx+G)
#define QFacc (QFh+QFx)
#define QIy QIacc
#define QFy (16-QIy)
#define ACCtoYshift (QFacc-QFy)

int main()
{
    //Ok now to practice some multiply and accumulate /w 16-bit Q3.13 signed X, Q0.32 signed H, and 64-bit ACC

    double h1 = 0.4792131002f;
    double h2 = -0.2314f * h1;
    double h3 = 1.03253f * h1;
    double h4 = 1.2f*h2;
    int32_t H1 = (int32_t) (h1*HSCALE);
    int32_t H2 = (int32_t) (h2*HSCALE);
    int32_t H3 = (int32_t) (h3*HSCALE);
    int32_t H4 = (int32_t) (h4*HSCALE);
    double hp1 = (double)H1 / HSCALE;
    double hp2 = (double)H2 / HSCALE;
    double hp3 = (double)H3 / HSCALE;
    double hp4 = (double)H4 / HSCALE;
    printf("h1: %f\t\tH1: %d\th1': %f\n", h1, H1, hp1);
    printf("h2: %f\t\tH2: %d\th2': %f\n", h2, H2, hp2);
    printf("h3: %f\t\tH3: %d\th3': %f\n", h3, H3, hp3);
    printf("h4: %f\t\tH4: %d\th4': %f\n\n", h4, H4, hp4);

    float v = 2.7f;
    uint16_t V = (uint16_t) (v*(1<<10));    //v = 2.835V as Q2.10 --> 2903u
    float vp = (float)V / (1<<10);
    printf("v: %f\t\tV: %d\t\tv': %f\n", v, V, vp);

    //Convert unsigned int inputs to desired range for calculations
    uint16_t adc = (uint16_t)(v*40950/33);
//    uint16_t adc = 0x0FFF;
    float x = v - 1.65f;
    int16_t X = (int16_t)adc * 270336/40950 - (135168/10);
    float xp = (float)(X) / (1<<13);
    printf("x: %f\t\tX: %d\tx': %f\n\n", x, X, xp);

    //Now process
//    int64_t ACC = (int64_t)X*H1;    //No adds
//    int64_t ACC = (int64_t)X*H1 + (int64_t)X*H2;    //One add
    int64_t ACC = (int64_t)X*H1 + (int64_t)X*H2 + (int64_t)X*H3 + (int64_t)X*H4;    //Three Adds; X is Q3.13 and H is Q0.32, so result of multiply is Q3.45 and adds Q5.45
    double acc = (double)ACC / ACCSCALE;
//    double y = x*h1;
//    double y = x*h1 + x*h2;
    double y = x*h1 + x*h2 + x*h3 + x*h4;
    int16_t Y = ACC >> ACCtoYshift;  //Y needs to be Q5.11, so shift ACC by 34 to get Q5.45 --> Q5.11
    float yp = (float)Y / (1<<QFy);
    uint16_t dacout = (uint16_t) ((Y * 40950 / (33 * (1<<QFy))) + (675675/330));
    printf("\t\t\tACC: %"PRId64"\tacc: %f\ny: %f\t\tY: %d\t\t\ty': %f\t\tdacout: %d\n\n", ACC, acc, y, Y, yp, dacout);

    return 0;
}
