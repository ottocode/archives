from objects2 import *
from randomgen import *
from collections import deque
import sys

#print "\n\nTesting"
t = Event(4)
t = ArrivalEvent((), 2)
t = DepartureEvent((), 2)
u = ArrivalEvent(None, 2)

NUMCUSTQUEUES = 20
NUMSERVERS = 1
serveMean = int(sys.argv[1])
QMAX = 10
dropcount = 0
EventList = []
QueueMeans = [100 for x in range(NUMCUSTQUEUES)]
QueueList = [Queue(x, QueueMeans[x], QMAX) for x in range(NUMCUSTQUEUES)]
randType = [unfRand for x in range(NUMCUSTQUEUES)]
genQueueMeans = 100
genrandType = unfRand
ServerMeans = [serveMean for x in range(NUMSERVERS)] #not being used
ServerList = [Server(QueueList[0], True, None, ServerMeans[x]) for x in range(NUMSERVERS)]

def queuePosGenerator():
    t = 0
    while t < len(QueueList):
        yield t
        t = (t+1) % len(QueueList)

queuePos = queuePosGenerator()


def serverPosGenerator():
    t = 0
    while t < len(ServerList):
        yield t
        t = (t+1) % len(ServerList)

serverPos = serverPosGenerator()

t = ArrivalEvent(None, genrandType(genQueueMeans))

TDMInterTime = 10
currTime = 0
lastTime = currTime
def nextCust(s):
    if debug:
        pass
    cust = s.custqueue.custList
    return cust.pop(0)
def updateInfo(customer):
    if debug:
        pass
    customer.startTime = currTime
def addCust(s, customer):
    if debug:
        pass
def createDepartureEvent(s):
    departTime = currTime+genrandType(s.mean)
    if debug:
        print "creating departure Event for %f!" %(departTime)
        print "server mean is: %s" %(s.mean)
    de = DepartureEvent(s, departTime)
    EventList.append(de)
def createTDMEvent():
    newTDM = TDMEvent(currTime + TDMInterTime)
    EventList.append(newTDM)
def custWaiting(s):
    if debug:
        pass
    if len(s.custqueue.custList) > 0:
        return True
    else:
        return False
def sysStats(queuenum, change, time):
    if debug:
        pass

def queueStats(thisqueue, change, time):
    if debug:
        print "queueStats. change: %s, time %s" %(change, time)
    return thisqueue.avgQueueLen(change, time)

def serverStats(server, ifdeparture):
    thisQueue = server.custqueue
    cust = server.customer
    if ifdeparture:
        thisQueue.updateSysTime(cust.arrivalTime, currTime)
        server.updateIdleTime(currTime, False)
    else:
        server.updateIdleTime(currTime, True)
def pickQueue():
    if randint(0, NUMCUSTQUEUES-1) % 2 ==0:
        queuePos.next()
    if debug:
        pass
    q = QueueList[queuePos.next()]
    for x in QueueList:
        a = QueueList[queuePos.next()]
        if a.oldlength < q.oldlength:
            q = a
    #uncomment next line and comment everything else for random queue choosing
    #return QueueList[randint(0,NUMCUSTQUEUES-1)]
    return q
def getEvent():
    if debug:
        pass
        print EventList
    if len(EventList) > 0:
        return EventList.pop(0)
def newArrival(thisqueue):
    newCust = Customer(currTime)
    if len(thisqueue.custList) == thisqueue.maximum:
        handleDrop(dropcount)
        return True 
    thisqueue.custList.append(newCust)
    if debug:
        print "making new arrival.  q: %d" %(thisqueue.id)
        print "q list: %s" %(thisqueue.custList)

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
        print "currTime: %f arrivalTime = %f" %(currTime, randnum+currTime)
def makeAvailable(servernum):
    if debug:
        pass
def calcRemaining(s):
    if debug:
        pass
def priorityPush(customer, s):
    if debug:
        print "returning customer to queue"
    s.custqueue.custList.insert(0, customer)
def switchQueue(s, TDMEvent):
    if debug:
        print "switching server: %d queue"
    qpos = [i for i, q in enumerate(QueueList) if q == s.custqueue]
    qpos = (qpos[0] +1) % len(QueueList)
    s.queue = QueueList[qpos]
    return 

def handleDrop(dropcount):
    dropcount = dropcount + 1
    return


tdm = TDMEvent(10)
EventList.append(t)
EventList.append(tdm)

debug = False
lightdebug = False
i = 10000
while(i):
    i-=1
    EventList.sort(key = lambda x: x.time)
    E = getEvent()                          #Done
    lastTime = currTime
    currTime = E.time
    if lightdebug:
        print "\n currTime %s, E: %s, qlengths: \n" %(currTime, E)
        print [q.oldlength for q in QueueList]
    if isinstance(E, ArrivalEvent):
        if E.custqueue:
            drop = newArrival(E.custqueue)         #Sort of done
            if drop:
                dropcount += 1
            else: 
                queueStats(E.custqueue, 1, currTime)
            newArrivalEvent(E.custqueue)    #Sort of
        else:
            E.custqueue = pickQueue()       #Sort of done
            drop = newArrival(E.custqueue)         #Sort of done
            if drop:
                dropcount += 1
            else:
                queueStats(E.custqueue, 1, currTime)
            newArrivalEvent(-1)    #Sort of
    elif isinstance(E, DepartureEvent):
        server = E.server
        if debug:
            print server
        serverStats(server, True)
        server.available = True
    elif isinstance(E, TDMEvent):
        if debug:
            print "tdmEvent"
        createTDMEvent()
        for s in ServerList:
            if not s.available:
                customer = calcRemaining(s)
                priorityPush(customer, s)
            switchQueue(s, TDMEvent)
    if i%5 == 0:
        serverPos.next()
    for x in ServerList:
        n = serverPos.next()
        if lightdebug:
            print "server pos is %d" %(n)
        s = ServerList[n]
        if s.available:
            if custWaiting(s):
                if debug:
                    print "customer waiting for server %s" %(s)
                customer = nextCust(s)          
                updateInfo(customer) 
                s.customer = customer
                queueStats(s.custqueue, -1, currTime)
                serverStats(s, False)
                createDepartureEvent(s)         
                s.available = False
            else:
                if debug:
                    print "server %s available, but no customer" %(s)

#print "\n\nEnd Analysis"
sys.stdout.write("numQueus, numServers, servermean, qmax, q1total, q1avglen, q1avgSys, s1idle, s2idle, dropcount\n")
#sys.stdout.write( "final time: %s" %(currTime))
sys.stdout.write( "%s, %s, %s, %s, " %(NUMCUSTQUEUES, NUMSERVERS, serveMean, QMAX))
for q in QueueList:
    sys.stdout.write( "%s, %s, %s, " %(q.custCount, q.oldAvg, q.avgSysTime))
for s in ServerList:
    sys.stdout.write( "%s, " %(s.idleTime/currTime))

sys.stdout.write( "%s\n" %(dropcount))
