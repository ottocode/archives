#lang racket
(require racket/include)
(require plot)
(plot-new-window? #t)
(include "prob_definitions.rkt")
(include "web_server_sim.rkt")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Overall Simulator

;;; Some global definitions
(define Max-Problem-percent 0.05)
(define Min-Capacity-percent 1.2)
(define seconds-in-day 86400)
(define number-customers '(50 100 200 400 800 1000 2000))
(define webserver-capacity '(20 40 80 160 320))
(define usage-parameters '(0 2 4 6))
(define provision-parameters '(0 2 4 6))
(define database-parameters '(0))
(define storage-parameters '(0))
(define gen-parameters (list  seconds-in-day 
                              number-customers 
                              webserver-capacity
                              usage-parameters
                              provision-parameters 
                              database-parameters 
                              storage-parameters))

(define test-parameters (list seconds-in-day 
                              50     ;num cust
                              20     ;web cap
                              4      ;usage
                              4      ;provision
                              0      ;database
                              0))    ;storage

;;; Statistics structure contains the progress of the simulation
(define-struct statistics (include deviation end))

;;; Result structure contains the problem percent and the usage of each simulation
(define-struct result (prob-percent usage) #:mutable)

;;; Simulate the server
;;; defined in web_server_sim.rkt
;;; (web_parameter-tests seconds l-cust l-cap l-prov l-usage)
;;; -> (list bought (/ (length problems) seconds-in-day)))
; Need to finish
(define (sim-server parameters)
  (printf "sim-server result: ~a~n" (apply web-tests test-parameters))
  (make-result 1 2))

;;; Simulate the database 
; Need to finish
(define (data-server parameters)
  (make-result 2 4))

;;; Simulate storage
; Need to finish
(define (store-server parameters)
  (make-result 4 8))

;;; Combine the results
;;; Return a total result
(define (comb-results result-list)
  (let* ([total-result (make-result 0 0)])
    (for-each (lambda (res)
      (set-result-prob-percent! total-result
        (+ (result-prob-percent res) (result-prob-percent total-result)))
      (set-result-usage! total-result
        (+ (result-usage res) (result-usage total-result)))) result-list)
    total-result))


;;; Function to update statistics
;;; result, statistics -> statistics
;;; Incorporates result into statistics
; Need to finish
(define (incl-fun new-results old-statistics)
  (make-statistics incl-fun 0 1))

;;; The simulation function
;;; Takes a set of server, database, storage, customer parameters and statistics
;;; Returns a result structure.
;;; If statistics end condition not satisfied, computation continues
(define (simulation server-param database-param storage-param cust-param stats)
  (let* ( [serv-results (sim-server test-parameters)]
          [data-results (data-server test-parameters)]
          [storage-results (store-server test-parameters)]
          [tot-results (comb-results (list serv-results data-results storage-results))]
          [new-stats ((statistics-include stats) tot-results stats)])
    (if (< (statistics-deviation new-stats) (statistics-end new-stats)) tot-results
      (simulation server-param database-param storage-param cust-param new-stats))))

;;; Define the base parameters
(define server-p (list 0 ))
(define database-p (list 0))
(define storage-p (list 0))
(define cust-p (list 0))
(define start-stats (make-statistics incl-fun 0 0))

(printf "Start Simulation ~n")
;;; Run the simulation for each of the base parameters
(for-each (lambda (serv)
  (for-each (lambda (dat)
    (for-each (lambda (stor)
      (for-each (lambda (cust)
        (let ([final (simulation serv dat stor cust start-stats)])
          (printf "{serv: ~a, dat: ~a, stor: ~a, cust: ~a, prob: ~a, usage: ~a}~n"
            serv dat stor cust (result-prob-percent final) (result-usage final)))
            )cust-p) )storage-p) )database-p) )server-p)

(printf "End Simulation ~n")
