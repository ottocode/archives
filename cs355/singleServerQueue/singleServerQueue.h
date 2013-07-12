
#define NDEBUG   //asserts

#define debug 0
#define REPORT 1
#define MAX_TIME 200
#define LOAD_ADJUST 5 
#define EXP 1

#include "random.h"

int getEvent();
double updateClock(double addedTime);
int executeEvent();
int runStatistics(int type, double newTime, int queueLen, double startTime);
int initializeSystem();
int freeSystem();
void ERROR(int code);
int runTests();
void statsReset();

/* Departure functions
 */

int departureRoutine(int type);
double scheduleNextDeparture();
int updateQueueA();
int updateQueueD();
int updateServer();
double getNextDeparture();

/* Arrival Functions
 */
int arrivalRoutine();
int incrementCustomerCount();
int scheduleNextArrival();
int updateQueue();
double getNextArrival();


/* Stats functions
 */
double averageQueueLen(double newTime, int queueLen);
double averageSysTime(double newTime, double startTime);
double showQAvg();
double showAvgTime();
long showCustCount();
double exRand(double gamma);

extern double  clock;
extern double  departureTime;
extern double  serverIdle;
extern double  arrivalQueue;
extern double* custQueue;
extern double  *chead, *ctail;
extern double  totalIdleTime;
extern double  arrivalG;
extern double  departG;
extern int     serverStatus;
//extern int     MAX_TIME;
extern int     MAX_QUEUE;
extern int     qLen;
extern int     depart_factor;
extern int     max_cust;
extern long     dropCnt;


