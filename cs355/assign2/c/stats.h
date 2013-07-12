
double dropRate(double oldRate, int oldDrops,
        double timeLastDrop, double newTime, 
        int newDrops);

double averageSysTime(double oldAvg, int lastCustCnt,
        double newTime, double startTime,
        int newCustCnt);

double averageQueueLen(double oldAvg, double totalTime,
        int newLen, double startTime,
        double newTime);

