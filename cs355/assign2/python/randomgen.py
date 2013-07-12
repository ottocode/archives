from math import log
from random import random, randint

def unfRand(mean):
    return 2.0*mean*random()

def expRand(mean):
    return (log(1-random()) ) / (-1.0/mean)

def randTest(mean, avg, i):
    if i > 500:
        return avg
    else:
        temp = (avg*(i-1.0) + expRand(mean))/i
        return randTest(mean, temp, i+1)
if __name__=="__main__":
    print randTest(4, 0, 1)
