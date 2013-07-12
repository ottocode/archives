#lang racket
(require plot)
(plot-new-window? #t)

;;; EXAMPLE ;;;
;(plot (function (lambda (x) (- (* 3 x) 5 )) -4 4))


;;; Beta Density and Distribution ;;;
;define alpha and beta
;a=2, b=5 give a nice left-weighted look
(define alphaV 2)
(define betaV 5)

;the density function
(define (betaDensity alpha beta x)
    (* (expt x (- alpha 1)) 
       (expt (- 1 x) (- beta 1))
       (/ 1 (betaDistBuilder alpha beta 1))))

;the distribution function
(define (betaDistribution alpha beta x)
  (* (/ 1 (betaDistBuilder alpha beta 1)) 
     (betaDistBuilder alpha beta x)))

;helper function, ensures int_0^1 f(x) = 1
(define (betaDistBuilder alpha beta x)
  (- (/ (expt x alpha) alpha)
     (/ (expt x (+ alpha beta (- 1))) (+ alpha beta (- 1)))))


(betaDensity alphaV betaV 0.5)
(betaDistribution alphaV betaV 1)

(plot (function (lambda (x)
                  (betaDensity alphaV betaV x)) 0 1
      #:label "Density function"))
(plot (function (lambda (x)
                  (betaDistribution alphaV betaV x)) 0 1
                #:label "Cummulative distribution function"))

(plot (function (lambda (x)
                  (sqrt x)) 0 1))
(define (genRandNormal mu sigma) 
  (+ mu 
     (* sigma 
        (- (foldl + 0 (build-list 12 (lambda (x) (random)))) 6))))
(define Z (genRandNormal 0 1))

(define (invBetaDistribution x) 
  (cond 
    [(<= x 0) 0]
    [else 1]))

(plot (function (lambda (x)
                  (exp x)) 0 1))

(read)
