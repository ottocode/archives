from objects import *
from collections import deque
from Queue import Queue

QMEAN = 100.0
SMEAN = 50.0
currTime = 0.0
events = deque()
custQ = deque()
debug = True
if debug:
    print events, custQ
    print len(events)

i = 5

while i:
    print "top"
    i -= 1
    if len(events)==0:
        getArrival(QMEAN)
