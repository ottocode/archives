from randomgen import *

class Event:
    def __init__(self, time):
        self.time = time

class ArrivalEvent(Event):
    def __init__(self, custqueue, time):
        self.custqueue = custqueue
        Event.__init__(self, time)
class DepartureEvent(Event):
    def __init__(self, server, time):
        self.server = server
        Event.__init__(self, time)
class TDMEvent(Event):
    def __init__(self, time):
        Event.__init__(self, time)

class Customer():
    def __init__(self, arrivalTime):
        self.arrivalTime = arrivalTime
        self.startTime = None
        self.departTime = None 


class Server():
    def __init__(self, custqueue, available, customer, mean):
        self.idleTime = 0
        self.lastTime = 0
        self.custqueue = custqueue
        self.available = available
        self.customer = customer
        self.distribution = unfRand
        self.mean = mean

    def updateIdleTime(self, newTime, addIdle):
        if addIdle:
            self.idleTime += (newTime - self.lastTime)
        self.lastTime = newTime
        return self.idleTime

class Queue():
    def __init__(self, qid, mean, maximum):
        self.id = qid
        self.mean = mean
        self.oldAvg = 0
        self.oldlength = 0
        self.custCount = 0
        self.lastTime = 0
        self.avgSysTime = 0
        self.custList = []
        self.maximum = maximum

    def avgQueueLen(self, change, newTime):
        self.oldAvg =  ((self.oldAvg * self.lastTime) + (self.oldlength * (newTime - self.lastTime))) / (1.0*newTime)
        self.oldlength += change
        self.lastTime = newTime
        return self.oldAvg

    def updateSysTime(self, enterTime, newTime):
        self.custCount +=1
        self.avgSysTime = ((self.avgSysTime * (self.custCount-1)) + (newTime - enterTime))/ (1.0*self.custCount)



