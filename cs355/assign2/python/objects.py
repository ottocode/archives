
class Event:
    def __init__(self, eventType, eventTime, eventQueue):
        self.eventType = eventType
        self.eventTime = eventTime 
        self.eventQueue = eventQueue

    def __str__(self):
        return "EVENT\n\ttype: %d time: %f queue %d" %( self.eventType, self.eventTime, self.eventQueue)

class Customer(object):
    def __init__(self, **kw):
        self.arrivalTime = None
        self.serviceTime = None
        self.exitTime = None
        self.queue = None
        self.magnitude = None
        for k in kw.keys():
            setattr(self, k, kw[k])


    def __str__(self):
        return str(self.__dict__)


class custQueue:
    def __init__(self, **kw):
        self.maxlen = 100
        self.size = 0
        self.avgQlen = 0
        self.avgServiceTime = 0
        self.avgSysTime = 0
        self.distribution = 0
        self.dropcount = 0
        for k in kw.keys():
            setattr(self, k, kw[k])

class QueueList:
    def __init__(self, **kw):
        self.num = 1
        self.avgtotalQlen = 0
        self.avgtotalServiceTime = 0
        self.avgtotalSysTime = 0
        for k in kw.keys():
            setattr(self, k, kw[k])
        self.queues = [custQueue() for x in range(self.num)]


class Server:
    def __init__(self, **kw):
        self.available = True
        self.queue = None
        self.Customer = None
        self.lastIdleStart = None
        self.idleTime = 0
        self.tdm = 0
        self.distribution = 0
        for k in kw.keys():
            setattr(self, k, kw[k])

if __name__ =="__main__":
    te = Event(1, 0.54, 0)
    print te

    print "Customer"
    tc = Customer(arrivalTime=4, serviceTime=5)
    print tc.serviceTime

    tq = QueueList()
    tq2 = QueueList(num=1)
    print tq.avgtotalQlen
    print tq.__dict__
    print tq2.__dict__

