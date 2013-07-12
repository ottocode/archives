#lang racket
(require racket/include)
(include "mm2.ss")

(stats-dropRate 5 9 10 89 92)
(stats-avgSysTime 3 78 79 209 207)
(stats-avgQueueLen 8 3 78 90)

(rand-exp 0.5)
(rand-test 3 0 1)
(rand-test-exp 3 0 1)

(define ca (make-customer 2 4 5))
(define cb (make-customer 7 8 9))
(define cc (make-customer 1 42 49))
(customer-arrival ca)

(define ea (make-arrivalEvent ca 1))
(define eb (make-arrivalEvent cb 1))
(define ec (make-arrivalEvent cc 1))

(define test-list (list ea eb ec))
test-list
(define sortedList (sort test-list sortEvent-arrival))

(map (lambda (event)
       (define temp (arrivalEvent-customer event))
       (customer-exit temp)) test-list)
(map (lambda (event)
       (define temp (arrivalEvent-customer event))
       (customer-exit temp)) sortedList)

server-list
queue-list

(define lt (list 4 5 6))
lt
(set! lt (push lt 22))
lt
(get lt)
(set! lt (pop lt))
lt
(define args (list  '() server-list queue-list MAXQUEUE currtime avgqlen svridletime 0))
args
(fprintf (current-output-port)
         "END BASIC TESTS\n")
(outerLoop args)
(fprintf (current-output-port)
         "END  TESTS\n")
