(require racket/include)
(printf "Loading b-level-web.ss ~n")

;;; web-simulation
;;; web-service customers -> web-service
;;;     web-service: (capacity problem)
;;;     problem (over under)
;;;     customers (list customer)
;;;     customer (webuse webprov ...)
(define (web-simulation service customers)
  (let* ([this-usage (cust-usage-fold usage-sum 0 customers)])
    (make-s_webservice (update-webcap service this-usage) 
                       (/ (- this-usage (s_webservice-capacity service))
                          (s_webservice-capacity service)))))

(define (update-webcap service last-use)
  (s_webservice-capacity service))

; calculate the usage of a single customer
(define (cust-usage-fold func initial customers)
  (if (empty? customers) initial
    (cust-usage-fold func
                (func initial (customer-webprov (first customers)) (customer-webuse (first customers)))
                (rest customers))))
