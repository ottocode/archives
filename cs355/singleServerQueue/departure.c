#include "singleServerQueue.h"
#include <assert.h>
#include <stdio.h>
#include <limits.h>
#include <float.h>

/* Departure Routine
 * type 0:  server is idle
 * type 1:  server is not idle
 */
int departureRoutine(int type){
    if(debug){
        printf("inside departureRoutine(%d)\n", type);
    }
    if(type){
    }
    else{
        /*server is idle, schedule next departure and get out
         */
        departureTime = scheduleNextDeparture();
        if(debug){
            printf("added departureTime of: %f\n", departureTime);
        }
        totalIdleTime += (clock - serverIdle);
        serverIdle = 0;
        //run different statistics
        return 0;
    }

    assert((clock <= departureTime));
    if((ctail - chead) != 0){
        runStatistics(1, clock, qLen, *chead);
        if(debug){
            printf("next departure: %f\n", departureTime);
        }
        *chead = 0;
        chead++;
        qLen--;
        if(chead >= (custQueue + MAX_QUEUE)){
            chead = custQueue;
        }
        if(qLen>0){
            departureTime = scheduleNextDeparture();
        }
        else{
            departureTime = FLT_MAX;
            serverIdle = clock;
        }

    }
    else{
        if(debug){
            printf("empty queue.  ctail-chead: %ld\n", ctail-chead);
        }
        runStatistics(1, clock, qLen, *chead);
        departureTime = FLT_MAX;
        serverIdle = clock;
        *chead = 0;
        chead++;
        qLen--;
        if(chead >= (custQueue + MAX_QUEUE)){
            chead = custQueue;
        }
    }
    return 0;
}
double scheduleNextDeparture(){
    if(debug){
        printf("inside scheduleNextDeparture()\n");
    }
    double interTime = EXP ? exRand(1.0/departG) : getRandDouble(departG);
    double nextDeparture = interTime + clock;
    return nextDeparture;
}
int updateQueueD(){
    return 0;
}
int updateServer(){
    return 0;
}
double getNextDeparture(){
    return departureTime;
}
