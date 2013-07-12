#include "stats.h"
#include "random.h"

typedef struct ENTRY entry;
struct ENTRY{
    double arriveT;
    double servedT;
    double exitT;
};

typedef struct QUEUE queue;
struct QUEUE{
    entry *q;
    entry *qhead, *qtail;
    long size;
    long capacity;
};
queue* createQueue(long capacity);

int push(queue* thequeue, double n);
entry* pop(queue* thequeue);

