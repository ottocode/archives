#include "queue.h"
#include <stdlib.h>


void advanceptr(queue* thequeue, entry **ptr);

void advanceptr(queue* thequeue, entry **ptr){
    long capacity = thequeue->capacity;
    entry *base = thequeue->q;
    (*ptr)++;
    if((*ptr - base) > capacity){
        *ptr = base;
    }
}

queue* createQueue(long capacity){
    queue *r = malloc(sizeof(queue));
    r->q = malloc(sizeof(entry)*(capacity));
    r->qhead = r->q;
    r->qtail = r->q;
    r->capacity = capacity;
    r->size = 0;
    advanceptr(r, &(r->qtail));
    return r;
}

int push(queue* thequeue, double n){
    int success = 0;
    entry *head = thequeue->qhead;
    entry *tail = thequeue->qtail;
    if(head != tail){
        tail = (entry*)malloc(sizeof(entry));
        (thequeue->qtail)->arriveT = n;
        thequeue->size = (thequeue->size)++;
        advanceptr(thequeue, &(thequeue->qtail));
    }
    else{ success = 1;}
    return success;
}

entry* pop(queue* thequeue){
    advanceptr(thequeue, &(thequeue->qhead));
    entry *head = thequeue->qhead;
    entry *tail = thequeue->qtail;
    if(head==tail){
        advanceptr(thequeue, &(thequeue->qtail));
        return 0;
    }
    thequeue->size = (thequeue->size)-1;
    entry *ret = head;
    //free(head);
    return ret;
}

