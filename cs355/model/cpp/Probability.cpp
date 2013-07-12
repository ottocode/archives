#include "Service.h"
#include <cmath>
#include <stdlib.h>
#include <stdio.h>


double inverse_distribution_function(int load){
    double randnum = (double)rand()/RAND_MAX;
    return 1.0 - pow(1.0 - randnum, 1.0 / (load + 1.0));
}

double usage_fraction(int load){
    double num = inverse_distribution_function(load);
    if(num < 0.1){
        return 0.1;
    }else{
        return ceil(10.0* num)/ 10.0;
    }
}

double genRandNormal(double mu, double sigma){
    double runningTotal = 0;
    for (int i = 0; i < 12; i++){
        double trand = (double)rand()/RAND_MAX;
        runningTotal += trand;
    }
    double num = mu + sigma * (runningTotal - 6);
    return num;
}

/** Generate a random normal number with mu = 1, sigma = 0.2 **/
double normal_dist(){
    return genRandNormal(1.0, 0.2);
}

