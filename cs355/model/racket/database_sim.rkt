;#lang racket
(require racket/include)
(require plot)
(plot-new-window? #t)
;(include "prob_definitions.rkt")
;(include "global_definitions.rkt")

(printf "Loading web_server_sim.rkt ~n")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Web Server simulator

(define times-exceeded 0)

;what fraction did customer choose
(define (cust-provision level)
  (usage-fraction (random) level))

;how much will they use now
(define (cust-usage customer level)
  (* customer (usage-fraction (random) level)))

;customer-list is just a list of provisioned levels
(define (make-customer-list num provisioned)
  (build-list num (lambda (x) (cust-provision provisioned))))

; calculate the usage of a single customer
(define (usage-fold func initial customer use-param)
  (if (empty? customer) initial
    (usage-fold func
                (func initial (first customer) use-param)
                (rest customer) use-param)))

; to use with fold
(define (usage-sum ival c-provision use-param)
  (+ ival (cust-usage c-provision use-param)))

;;; Simulation function
;;;     for each second calculate the total usage
;;;     returns a list of usage at every second
(define (simulate seconds customer use-param results)
  (let ([this-usage (usage-fold usage-sum 0 customer use-param )])
    (if (zero? seconds) results
      (simulate (- seconds 1) customer use-param (cons this-usage results)))))

;(define customer-list (make-customer-list num-cust provision-param))
;(define simulated-usage (simulate seconds-in-day customer-list usage-param '()))
;(define problems (filter (lambda (x) (> x total-capacity)) simulated-usage))
;(fold +  0 customer-list)
;(length problems)


;;; Want to vary: number of customers,
;;;                 total-capacity,
;;;                 provisioned parameter
;;;                 usage parameter
(define (web_parameter-tests seconds l-cust l-cap l-prov l-usage . args)
  (printf "cust, cap, prov, use, bought, percent-problems~n")
  (for-each (lambda (cust)
    (for-each (lambda (cap)
       (for-each (lambda (prov)
          (for-each (lambda (use)
              (let* ([cust-list (make-customer-list cust prov)]
                    [sim-result (simulate seconds cust-list use '())]
                    [problems (filter (lambda (x) (> x cap)) sim-result)]
                    [bought (fold + 0 cust-list)])
                (list bought (/ (length problems) seconds-in-day)))
              )l-usage ))l-prov ))l-cap ))l-cust))

;;; web test on the rocks
(define (web-tests seconds cust cap prov usage . args)
  (let* ([cust-list (make-customer-list cust prov)]
         [sim-result (simulate seconds cust-list usage '())]
         [problems (filter (lambda (x) (> x cap)) sim-result)]
         [bought (fold + 0 cust-list)])
    (list bought (/ (length problems) seconds-in-day))))

;(web_parameter-tests seconds-in-day '(10 50 100 200 500) ;number of customers
;                 '(20 26 40) ;total capacity (computing units)
;                 '(0 2 4 6)  ;provision parameter
;                 '(0 2 4 6)) ; usage parameter

;(web_parameter-tests seconds-in-day '(50) ;number of customers
;                 '(20) ;total capacity (computing units)
;                 '(6)  ;provision parameter
;                 '(6)) ; usage parameter
