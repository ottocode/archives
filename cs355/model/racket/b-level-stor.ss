(require racket/include)
(printf "Loading b-level-stor.ss ~n")

;;; stor-simulation
;;; stor-service customers -> stor-service
;;;     stor-service: (capacity problem)
;;;     problem (over under)
;;;     customers (list customer)
;;;     customer (storuse storprov ...)
(define (stor-simulation storage customers)
  (let* ([this-usage (stor-usage-fold usage-sum 0 customers)])
    (make-s_storage (update-storcap storage this-usage) 
                     (/ (- this-usage (s_storage-capacity storage))
                        (s_storage-capacity storage)))))

(define (update-storcap service last-use)
  (s_storage-capacity service))


; calculate the usage of a single customer
(define (stor-usage-fold func initial customers)
  (if (empty? customers) initial
    (stor-usage-fold func
                (func initial (customer-storprov (first customers)) (customer-storuse (first customers)))
                (rest customers))))
