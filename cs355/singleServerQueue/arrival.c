#include "singleServerQueue.h"
#include <assert.h>
#include <stdio.h>

int arrivalRoutine(){
    if(debug){
        printf("inside arrivalRoutine()\n");
    }
    assert((clock <= arrivalQueue));
    incrementCustomerCount();
    arrivalQueue = getNextArrival();
    if(debug){
        printf("nextArrival: %f\n", arrivalQueue);
    }

    return 0;
}
double getNextArrival(){
    if(debug){
        printf("inside getNextArrival()\n");
    }
    double interTime = EXP ? exRand(1.0/arrivalG) : getRandDouble(arrivalG);
    double nextArrival = interTime + clock;

    return nextArrival;
}
int incrementCustomerCount(){
    if(qLen == (MAX_QUEUE+1)){
        dropCnt++;
        arrivalQueue = getNextArrival();
        return 0;
    }
    runStatistics(0, clock, qLen, 0);
    qLen ++;
    max_cust = qLen>max_cust ? qLen : max_cust;
    if(debug){
        printf("inside incrementCustomerCount()\n");
    }
    //printf("ctail %f &ctail %p\n", *ctail, ctail);//DEBUG
    assert(*ctail==0);
    *ctail = clock;
    ctail++;
    if(ctail >= (custQueue + MAX_QUEUE)){
        ctail = custQueue;
    }
    if(debug){
        printf("Number in queue: %d\n", qLen);
    }
    return 0;
}
int scheduleNextArrival(){
    return 0;
}
int updateQueueA(){
    return 0;
}
