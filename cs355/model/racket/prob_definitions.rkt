;(require plot)
;(plot-new-window? #t)

(printf "Loading prob_definitions.rkt~n")

;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; The above line is good to not cross (I know, this is not the console using age)
;;; Hey, that was pretty good! I wonder if I can write another line the same length

;;; Assumes the load is skewed left (low-end users)
;;; n needs to  be even (or a lot more work needs to be done :<(
;;; if n=0, then the plot range must be explicitly given

;;; P(a<X<b) = \int_a^b density-function 
(define (density-function x n)
  (* (expt (- 1 x) n) (+ n 1)))

;;; P(X<a) = distribution-function(x)
(define (distribution-function x n)
  (- 1 (expt (- 1 x) (+ n 1))))

;;; Given a random number [0,1] inverse-distribution-function will give the 
;;; appropriate usage level
(define (inverse-distribution-function x n)
  (- 1 (expt (- 1 x) (/ 1 (+ n 1)))))

;;; Some useful functions that would be a shame to waste, although I may still use
;create a random normal generator
(define (genRandNormal mu sigma) 
  (+ mu 
     (* sigma 
        (- (foldl + 0 (build-list 12 (lambda (x) (random)))) 6))))

;Z is uniform random normal, U(0,1)
(define (Z) (genRandNormal 0 1))

;;; The distribution function above is great, but I don't actually need continuous
;;; Get in tenths, [0.1, 1]
(define (usage-fraction x n)
  (if (< x 0.1)
    0.1
  (/ (ceiling (* 10 (inverse-distribution-function x n))) 10)))


; general fold that takes two arguments
(define (fold func i c)
  (if (empty? c) i
    (fold func 
          (func i (first c))
          (rest c))))

