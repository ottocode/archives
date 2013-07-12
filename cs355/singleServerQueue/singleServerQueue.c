/** Single Server Queue main file
 *
 */

#include "singleServerQueue.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include <math.h>

/* Global variables
 */
double  clock;
double  departureTime = FLT_MAX;
double  serverIdle;
double  arrivalQueue;
double* custQueue;
double  *chead, *ctail;
double  totalIdleTime;
int     serverStatus;
int     max_cust;
long     total_count;
int     MAX_QUEUE = 200;
long     dropCnt;
int     qLen;
//int     depart_factor = 10*LOAD_ADJUST*2;
double  arrivalG    = 100;
double  departG     = 1;


int main(int argc, char** argv){
    sRandDouble( (unsigned)time(NULL) );
    if(argc !=0){
        printf("first argument %s\n", argv[1]);
    }
    assert(returnCheck);
    //assert(runTests());

    long i = 500000;
    double statQAvg;
    double  max_error = 0.0001;
    double statTimeAvg;
    printf("Running for %ld events.\n", i);
    int j = 5;
    for(j = 5; j<96; j+=5){
        i = 1;
        clock = 0;
        dropCnt = 0;
        max_cust = 0;
        qLen = 0;
        total_count = 0;
        totalIdleTime = 0;
        serverIdle = 0.0001;
        statQAvg = 0;
        statTimeAvg = 0;
        departG = j;
        initializeSystem();

        while(i){
            clock = arrivalQueue < departureTime ? arrivalQueue : departureTime;
            if( arrivalQueue < departureTime){
                total_count++;
                if(debug){
                    printf("\ni = %ld, Clock: %f, arriving at: %f\n", i, clock, arrivalQueue);
                }
                arrivalRoutine();
                if(serverIdle){
                    departureRoutine(0);
                }
            }
            else{
                if(debug){
                    printf("\ni = %ld, Clock: %f, departing at: %f\n", i, clock, departureTime);
                }
                departureRoutine(1);
            }
            //returnCheck = 0;
            //assert(returnCheck);
            i++;
            if(debug){
                if(i==5){break;}
            }
            if(i % 10000 ==0){
                double qtemp = statQAvg;
                double timeTemp = statTimeAvg;
                statQAvg = showQAvg();
                statTimeAvg = showAvgTime();
                double qConverge = fabs((statQAvg - qtemp)) / statQAvg;
                double tConverge = fabs((statTimeAvg - timeTemp)) / statTimeAvg;
                if(qConverge < max_error){
                    if(tConverge < max_error){
                        break;
                    }
                }
            }
        
        }
        if(debug){
            printf("final time: %f\n", clock);
            printf("Total Idle time: %f\n", totalIdleTime);
            printf("Max customers: %d\n", max_cust);
            printf("Avererage Queue Length: %f\n", showQAvg());
            printf("Average Time in system: %f\n", showAvgTime());
            printf("Total drops: %13ld\n", dropCnt);
            printf("Total arrivals: %10ld\n", total_count);
        }
        if(REPORT){
            printf("Total number of events: %ld\n", i);
            printf("Load Factor: %0.4f\n", (1/arrivalG)/(1/departG));
            printf("Percentage Idle time: %0.4f\n", totalIdleTime/clock);
            printf("Avererage Queue Length: %f\n", showQAvg());
            printf("Average Time in system: %f\n", showAvgTime());
            printf("Drop rate: %f\n\n", (double)dropCnt/clock);
        }
        freeSystem();
    }
    
    printf("Maxqueue is %d\n", MAX_QUEUE);
 
    printf("Done\n");
    return 0;
}

int getEvent(){ 
    double nextArrival = getNextArrival();
    if(debug){
        printf("\nNext Arrival: %f\n", nextArrival);
    }
    double nextDeparture = getNextDeparture();
    if(nextDeparture > nextArrival){
        return 1;
    }
    else{ return 0;}
}

int initializeSystem(){
    custQueue = malloc(sizeof(double)*(MAX_QUEUE+1));
    statsReset();
    double next;


    if(EXP){
        next = exRand(1.0/arrivalG);
    }
    else{next = getRandDouble(arrivalG);}
    ctail = custQueue;
    chead = custQueue;
    if(debug){
        printf("first random time: %f\n", next);
        printf("custQueue: %p\nctail: %p\nchead: %p\n", custQueue, ctail, chead);
    }

    arrivalQueue = next;
    if(debug){
        printf("first arrival time: %f\n", arrivalQueue);
    }
    
    return 1;
}

int runTests(){
    double num;
    int i=10;

    while(i-- > 0){
        num = getRandDouble(arrivalG);
        printf("random is: %f\n", num);
    }

    return 1;
}

int freeSystem(){
    free(custQueue);
    return 1;
}

double updateClock(double addedTime){
    clock += addedTime;
    return clock;
}

int executeEvent(){
    return 0;
}
