#include "test_suite.h"
#include "queue.h"
#include <stdio.h>

int test_queue(){

    int i = 0;
    long thesize = 4;
    queue *myqueue = createQueue(thesize);
    printf("my2queue components...\n");
    printf("queue addr: %p\n", myqueue);
    printf("queue q   : %p\n", myqueue->q);
    printf("queue head: %p\n", myqueue->qhead);
    printf("queue tail: %p\n", myqueue->qtail);
    printf("queue size: %ld\n", myqueue->capacity);
    printf("Running tests...\n\n");

    for(i=1; i<7; i++){
        push(myqueue, i);
        printf("queue size: %ld\n", myqueue->size);
    }
    for(i=0; i<7; i++){
        entry *ret = pop(myqueue);
        printf("queue size: %ld\n", myqueue->size);
        if(ret){printf("arrive: %f\n", ret->arriveT);}
    }


    return 0;
}
