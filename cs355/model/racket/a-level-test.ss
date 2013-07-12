#lang racket
(require racket/include)
(require plot)
(plot-new-window? #t)
(include "a-level.ss")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Overall Simulator


(printf "Begin a-level tests~n~n")
(define test-seconds-in-day 10)

(printf "customers: ~a~n" customers)
(printf "webservice: ~a~n" webservice)
(printf "database: ~a~n" database)
(printf "storage: ~a~n" storage)

(a-level-sim test-seconds-in-day 
             customers
             webservice
             database
             storage
             parameters)

(printf "testing b-level-web.ss")
