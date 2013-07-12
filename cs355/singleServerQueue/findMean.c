#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double getRandDouble(double gamma){
    int num = rand();
    double d = num/(double)INT_MAX;
    return d*gamma*2;
}

void sRandDouble(int seed){
    return srand(seed);
}

double exRand(double gamma){
    double r = getRandDouble(0.5);
    r = 1-r;
    r = log(r);
    r = r/(-gamma);
    return r;
}

int main(){
    sRandDouble( (unsigned)time(NULL) );
    double exavg = 0;
    double uavg = 0;
    int i = 0;
    while(i<50000){
        uavg = uavg*i + getRandDouble(5);
        exavg = exavg*i + exRand(1.0/5.0);
        exavg = exavg/(++i);
        uavg = uavg/(i);
    }
    printf("exavg: %f\n", exavg);
    printf("uavg: %f\n", uavg);

return 0;
}
