#include "MM2.h"

double currTime = 0;
double avgDropRate = 0;
double avgSysTime = 0;
double avgQLen = 0;

typedef struct EVENT event;
struct EVENT{
    entry *thisevent;
    event *nextEvent;
};



int servers = 2;

int main(int argc, char *argv[]){
    sRandDouble((unsigned)time(NULL));

    /** Main loop.
     *
     * If servers
     *  get new arrival
     */



    return EXIT_SUCCESS;
}
