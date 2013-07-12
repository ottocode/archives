#include "random.h"
#include <stdlib.h>
#include <limits.h>
#include <math.h>


/** Seed random number generator
 */
void sRandDouble(int seed){
    return srand(seed);
}

/** Get uniformly distributed random variable.
 * @input double gamma. Mean value = gamma.
 */
double getRandDouble(double gamma){
    int num = rand();
    double d = num/(double)INT_MAX;
    return d*gamma*2;
}

/** Get exponentially distributed random variable.
 * @input double gamma.  Mean value = gamma.
 */
double exRand(double gamma){
    double r = getRandDouble(0.5);
    r = 1-r;
    r = log(r);
    r = r/(-(1/gamma));
    return r;
}
