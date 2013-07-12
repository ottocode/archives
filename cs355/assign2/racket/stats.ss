;;; Statistics Functions
;

;stats-dropRate
(define (stats-dropRate oldRate oldDrops newDrops timeLastDrop newTime)
  (/ (+ (* oldRate oldDrops) (- newTime timeLastDrop)) newDrops))

;stats-avgSysTime
(define (stats-avgSysTime oldAvg lastCustCnt  newCustCnt newTime startTime)
  (/ (+ (* oldAvg lastCustCnt) (- newTime startTime)) newCustCnt))

;stats-avgQueueLen
(define (stats-avgQueueLen oldAvg newLen startTime newTime)
  (/ (+ (* oldAvg startTime) (* newLen (- newTime startTime))) newTime))

(define (stats-serverIdleTime oldIdleTime startTime endTime)
  (+ oldIdleTime (- endTime startTime)))



