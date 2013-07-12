;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Overall Simulator
;;;
(printf "Loading a-level-func ~n")
(include "b-level-web.ss")
(include "b-level-db.ss")
(include "b-level-stor.ss")
(include "prob_definitions.rkt")

(define (get-purchase-param)
  4)
(define (get-use-param)
  4)

;;; Initializations
(define (initialize-customers parameters)
  (build-list (s_parameters-startcust parameters)
              (lambda (x)
                (make-customer 
                  (cust-provision (s_parameters-webuse parameters))
                  (cust-provision (s_parameters-webprov parameters))
                  (cust-provision (s_parameters-datause parameters))
                  (cust-provision (s_parameters-dataprov parameters))
                  (cust-provision (s_parameters-storuse parameters))
                  (cust-provision (s_parameters-storprov parameters))))))


(define (initialize-webservice parameters)
  (make-s_webservice (s_parameters-webcap parameters) 0))

(define (initialize-database parameters)
  (make-s_database (s_parameters-datacap parameters) 0))

(define (initialize-storage parameters)
  (make-s_storage (s_parameters-storcap parameters) 0))

(define (initialize-parameters)
  (make-s_parameters 3.0 2.0 2.0 3.0 2.0 2.0 3.0 2.0 2.0 20))

;;; Simulations
(define (sim-webs webservice customers)
  (web-simulation webservice customers))

(define (sim-database database customers)
  (db-simulation database customers))

(define (sim-storage storage customers)
  (stor-simulation storage customers))

(define (sim-parameters parameters)
  #f)

(define (sim-customers customers results)
  customers)

(define (calc-results web database storage customers results)
  (cond
    [(or (< (s_webservice-prev_prob web) Min-Capacity-percent)
         (> (s_webservice-prev_prob web) Max-Problem-percent)) 1]
    [(or (< (s_database-prev_prob database) Min-Capacity-percent)
         (> (s_database-prev_prob database) Max-Problem-percent)) 1]
    [(or (< (s_storage-prev_prob storage) Min-Capacity-percent)
         (> (s_storage-prev_prob storage) Max-Problem-percent)) 1]
    [else 0]))

; calculate the usage of a single customer
(define (usage-fold func initial customer use-param)
  (if (empty? customer) initial
    (usage-fold func
                (func initial (first customer) use-param)
                (rest customer) use-param)))

; to use with fold
(define (usage-sum ival c-provision use-param)
  (+ ival (cust-usage c-provision use-param)))

;how much will they use now
(define (cust-usage customer level)
  (* customer (usage-fraction (random) level)))

;what fraction did customer choose
(define (cust-provision level)
  (usage-fraction (random) level))

