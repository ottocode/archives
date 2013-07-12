#include "singleServerQueue.h"
#include <stdio.h>

double lastTime = 0;
double qAvg = 0;
double avgTime = 0;
long total_cust = 0;


/** Base statistics call.
 * type     0 if arrival, 1 if departure
 * newTime  current time of calling function
 * queueLen queueLen of calling function (before updates)
 * startTime the time departing element entered queue
 */
int runStatistics(int type, double newTime, int queueLen, double startTime){
    if(debug){
        printf("\ttype: %d\n\tnewTime: %f\n\tqueueLen: %d\n\tstartTime: %f\n",
                type, newTime, queueLen, startTime);
    }
    qAvg = averageQueueLen(newTime, queueLen);
    lastTime = newTime;
    if(type){
        avgTime = averageSysTime(newTime, startTime);
    }
    return 0;
}

double averageQueueLen(double newTime, int queueLen){
    double newAvg = qAvg * lastTime;
    newAvg += (queueLen*(newTime-lastTime));
    newAvg = newAvg / clock;
    return newAvg;
}

double averageSysTime(double newTime, double startTime){
    double newAvg = (total_cust++)*avgTime + (newTime - startTime);
    if(debug){
        printf("\ttotal_cust: %ld\n\tavgTime: %f\n\tnewTime: %f\n\tstartTime: %f\n",
                total_cust, avgTime, newTime, startTime);
    }
    newAvg = newAvg / (total_cust);
    return newAvg;
}

double showQAvg(){
    return qAvg;
}

void statsReset(){
    lastTime = 0;
    qAvg = 0;
    avgTime = 0;
    total_cust = 0;
}

long showCustCount(){
    return total_cust;
}

double showAvgTime(){
    return avgTime;
}
