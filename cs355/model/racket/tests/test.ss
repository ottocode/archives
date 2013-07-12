#lang racket

(define-struct test (element))

(define test_struct (make-test 0))

test_struct
(test-element test_struct)

(define (getelement elementname structure)
  ((typeof structure)-elementname structure))

