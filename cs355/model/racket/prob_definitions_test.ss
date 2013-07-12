#lang racket
(require racket/include)
(require plot)
(plot-new-window? #t)
(include "prob_definitions.rkt")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Uncomment next j:.,+8s/^;/ lines to see plots

(define n 2)
(plot (function (lambda (x)
                  (density-function x n)) 0 1
                #:label "n = 2")
                #:y-label "m(x)"
                #:x-label "percent max of provision"
                #:title "density function"
             ;   #:y-min 0
             ;   #:y-max 2
                #:out-file "density_out_2.pdf")

(plot (function (lambda (x)
                  (distribution-function x n)) 0 1
                #:label "n = 2")
                #:y-label "F(x)"
                #:x-label "percent max of provision"
                #:title "distrubution function"
             ;   #:y-min 0
             ;   #:y-max 2
                 #:out-file "distribution_out_2.pdf")

(plot (function (lambda (x)
                  (distribution-function x 4)) 0 1
                #:label "n = 4")
                #:y-label "F(x)"
                #:x-label "percent max of provision"
                #:title "distrubution function"
             ;   #:y-min 0
             ;   #:y-max 2
                 #:out-file "distribution_out_4.pdf")

(plot (function (lambda (x)
                  (distribution-function x 6)) 0 1
                #:label "n = 6")
                #:y-label "F(x)"
                #:x-label "percent max of provision"
                #:title "distrubution function"
             ;   #:y-min 0
             ;   #:y-max 2
                 #:out-file "distribution_out_6.pdf")


(plot (function (lambda (x)
                  (distribution-function x 8)) 0 1
                #:label "n = 8")
                #:y-label "F(x)"
                #:x-label "percent max of provision"
                #:title "distrubution function"
             ;   #:y-min 0
             ;   #:y-max 2
                 #:out-file "distribution_out_8.pdf")




(plot (function (lambda (x)
                  (inverse-distribution-function x n)) 0 1
                #:label "n = 2")
                #:x-label "percent max of provision"
                #:title "inverse distrubution function"
             ;   #:y-min 0
             ;   #:y-max 2
                )

(define (test-usage-fraction x n)
  (printf "inverse-distribution ~a~n"
          (inverse-distribution-function x n))
  (printf "usage-fraction ~a~n"
          (usage-fraction x n)))

;(test-usage-fraction 0.2 n)
;(test-usage-fraction 0.8 n)
;(test-usage-fraction 0.9999 n)
(read)
