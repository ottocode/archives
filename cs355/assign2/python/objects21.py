from objects2 import *
from randomgen import *
debug = True
NUMCUSTQUEUES = 1
EventList = []
QueueList = [[] for x in range(NUMCUSTQUEUES)]
QueueMeans = [100 for x in range(NUMCUSTQUEUES)]
randType = [unfRand for x in range(NUMCUSTQUEUES)]
genQueueMeans = 100
genrandType = unfRand

global currTime = 0
def nextCust(s):
    if debug:
        print "getting next customer in line. will need to pop"
def updateInfo(customer):
    if debug:
        print "need to update customer information"
def addCust(s, customer):
    if debug:
        print "adding customer to server"
def createDepartureEvent(s):
    if debug:
        print "creating departure Event!"
def custWaiting(s):
    if debug:
        print "check if customer is waiting"
def queueStats(queuenum):
    if debug:
        print "updating queueStats"
def serverStats(server):
    if debug:
        print "updating serverStats"
def pickQueue():
    if debug:
        print "choosing a queue"
    return 0
def getEvent():
    if debug:
        print "getting event"
        print EventList
    if len(EventList) > 0:
        return EventList.pop(0)
def newArrival(queuenum):
    if debug:
        print "making new arrival.  q: %d" %(queuenum)
    newCust = Customer(currTime, None, None)
    QueueList[queuenum].append(newCust)

def newArrivalEvent(queuenum):
    if queuenum<0:
        randnum = genrandType(genQueueMeans)
        av = ArrivalEvent(None, randnum+currTime)
    else:
        randnum = randType[queuenum](QueueMeans[queuenum])
        av = ArrivalEvent(queuenum, randnum+currTime)
    EventList.append(av)
    if debug:
        print "making new arrival event q: %d" %(queuenum)
        print "currTime: %f arrivalTime = %f" %(currTime, randnum)
def makeNotAvailable(s):
    if debug:
        print "making server: %d not available" %(servernum)
def makeAvailable(servernum):
    if debug:
        print "making server: %d available" %(servernum)
def available(servernum):
    if debug:
        print "checking if server %d is available"
def calcRemaining(s):
    if debug:
        print "calculating remaining work"
def priorityPush(customer, s):
    if debug:
        print "returning customer to queue"
def switchQueue(s, TDMEvent):
    if debug:
        print "switching server: %d queue"

ServerList = []
i = 5

