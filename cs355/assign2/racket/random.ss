
;;; Random Functions
(define (rand-exp mean)
  (/ (log (- 1 (random))) (/ -1 mean)))

(define (rand-unf mean)
  (* 2 (* (random) mean)))

(define (rand-test mean avg i)
  (if (> i 100000)
    avg
    (rand-test mean  
               (/ (+ (* avg (- i 1)) (rand-unf mean)) i)
               (+ i 1))))

(define (rand-test-exp mean avg i)
  (if (> i 100000)
    avg
    (rand-test mean  
               (/ (+ (* avg (- i 1)) (rand-exp 0.5)) i)
               (+ i 1))))


