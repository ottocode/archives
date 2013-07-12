(require racket/include)
(printf "Loading b-level-db.ss ~n")

;;; db-simulation
;;; db-service customers -> db-service
;;;     db-service: (capacity problem)
;;;     problem (over under)
;;;     customers (list customer)
;;;     customer (datause dataprov ...)
(define (db-simulation database customers)
  (let* ([this-usage (db-usage-fold usage-sum 0 customers)])
    (make-s_database (update-dbcap database this-usage) 
                     (/ (- this-usage (s_database-capacity database)) 
                        (s_database-capacity database)))))

(define (update-dbcap service last-use)
  (s_database-capacity service))

; calculate the usage of a single customer
(define (db-usage-fold func initial customers)
  (if (empty? customers) initial
    (db-usage-fold func
                (func initial (customer-dataprov (first customers)) (customer-datause (first customers)))
                (rest customers))))
