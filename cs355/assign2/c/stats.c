#include "stats.h"


double dropRate(double oldRate, int oldDrops,
        double timeLastDrop, double newTime, 
        int newDrops){

    double newRate = (oldRate * oldDrops +
            (newTime - timeLastDrop)) / newDrops;

    return newRate;
}

double averageSysTime(double oldAvg, int lastCustCnt,
        double newTime, double startTime,
        int newCustCnt){

    double newAvg = ((oldAvg * lastCustCnt) +
            (newTime - startTime)) / newCustCnt;
    return newAvg;
}

double averageQueueLen(double oldAvg, double totalTime,
        int newLen, double startTime,
        double newTime){

    double newAvg = ((oldAvg*startTime) +
            (newLen * (newTime - startTime))) / totalTime;
    return newAvg;
}

