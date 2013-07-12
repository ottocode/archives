;#lang racket
;(require racket/include)
;(require plot)
;(plot-new-window? #t)
(include "a-level-func.ss")
(include "a-level-def.ss")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Overall Simulator

(printf "Starting a-level~n")

(define parameters (initialize-parameters))
(define customers (initialize-customers parameters))
(define webservice (initialize-webservice parameters))
(define database (initialize-database parameters))
(define storage (initialize-storage parameters))


(define (a-level-sim seconds-remaining
                     customers
                     webservice
                     database
                     storage
                     results)
  (let* ([rem-time (- seconds-remaining 1)]
         [n-webs (sim-webs webservice customers)]
         [n-database (sim-database database customers)]
         [n-storage (sim-storage storage customers)]
         [n-parameters (sim-parameters parameters)]
         [n-results (calc-results n-webs n-database n-storage 
                                customers results)]
         [n-customers (sim-customers customers results)])
    (printf "\t time: ~a customers: ~a, webservice ~a, database: ~a, storage: ~a, \
results: ~a~n" 
                seconds-remaining (length customers)
                (s_webservice-prev_prob n-webs)
                (s_database-prev_prob n-database)
                (s_storage-prev_prob n-storage)
                n-results)
    (if (zero? rem-time) 0
      (a-level-sim rem-time
                   n-customers
                   n-webs
                   n-database
                   n-storage
                   n-results))))
