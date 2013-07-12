#include "random.h"
#include <time.h>
#include <stdio.h>

int test_random(){
    sRandDouble((unsigned)time(NULL));
    long i = 0;
    double uniformAvg = 0;
    double expAvg = 0;

    for(i=0; i<10000; ){
        uniformAvg *= i++;
        uniformAvg = (uniformAvg + getRandDouble(0.5))/i;
    }
    printf("Uniform avg after %ld iterations is: %f\n", i, uniformAvg);

    for(i=0; i<100000; ){
        expAvg *= i++;
        double rand = exRand(0.5);
        expAvg = (expAvg + rand)/i;
    }
    printf("Exponential avg after %ld iterations is: %f\n", i, expAvg);
    return 0;
}
