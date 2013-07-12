
def dropRate(drops, time):
    return drops/(1.0 *time)

def avgSysTime(oldAvg, custCnt, startTime, newTime):
    return ((oldAvg * (custCnt-1)) + (newTime - startTime))/ (1.0*custCnt)

def avgQueueLen( oldAvg, newLen, startTime, newTime):
    return ((oldAvg * startTime) + (newLen * (newTime - startTime))) / (1.0*newTime)

def serverIdleTime ( oldIdleTime, startTime, endTime):
    return oldIdleTime + endTime - startTime



if __name__ == "__main__":
    print "testing dropRate 5 100"
    print dropRate(5, 100)


    print "testing avgSysTime 5, 100, 345, 350"
    print avgSysTime(5, 100, 345, 350)


    print "testing avgQueueLen(5, 7, 345, 350)"
    print avgQueueLen(5, 7, 345, 350)

    print "testing serverIdleTime( 89, 845, 850)"
    print serverIdleTime( 89, 845, 850)
