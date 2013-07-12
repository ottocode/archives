#include "Category.h"
#include "Service.h"
#include "Probability.h"
#include <assert.h>

Category::Category(){
    clearUsage();
    clearEffect();
    setSafety(0);

}

void Category::setSafety(double nsafe){
    safety = nsafe;
}

void Category::clearUsage(){
    usage = 0;
}

double Category::addUsage(double additional){
    usage += additional;
    return getUsage();
}

double Category::getUsage(){
    return usage;
}

void Category::setCapacity(double nCapacity){
    capacity = nCapacity;
}

void Category::updateCapacity(){
    if( effectQueue.size() < RUNNING_AVG){
        effectQueue.push(customerEffect);
    }else{
        effectQueue.pop();
        effectQueue.push(customerEffect);
    }
    int queuesize = effectQueue.size();
    double avgEffect = 0;
    for( int i = 0; i < queuesize; i++){
        double next = effectQueue.front();
        avgEffect += next;
        effectQueue.pop();
        effectQueue.push(next);
    }
    avgEffect = avgEffect / queuesize;

    if( avgEffect <= safety){ //oversold
        capacity *= (1-(avgEffect - safety));
    }
    else if( avgEffect > 0.1+safety){
        capacity *= (1-(avgEffect-0.1));
    }
}

double Category::getCapacity(){
    return capacity;
}

void Category::clearEffect(){
    customerEffect = 0;
}

void Category::updateEffect(){
    double unused = (capacity - usage) / capacity;
    customerEffect = unused;
    updateCapacity();
}

double Category::getEffect(){
    return customerEffect;
}
