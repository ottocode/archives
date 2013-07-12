;#lang racket

(include "stats.ss")
(include "random.ss")

;;; Sorting Functions
(define (sortCustomers-arrival custa custb)
  (define caa (customer-arrival custa))
  (define cba (customer-arrival custb))
  (cond
    [(< caa cba) #t]
    [else #f]))

(define (sortCustomers-exit custa custb)
  (define caa (customer-exit custa))
  (define cba (customer-exit custb))
  (cond
    [(< caa cba) #t]
    [else #f]))

(define (sortEvent-exit eventa eventb)
  (define aa? (arrivalEvent? eventa))
  (define ba? (arrivalEvent? eventb))
  (cond
    [(and aa? ba?) (sortCustomers-exit (arrivalEvent-customer eventa) (arrivalEvent-customer eventb))]
    [(and aa? (not ba?)) (sortCustomers-exit (arrivalEvent-customer eventa) (departureEvent-customer eventb))]
    [(and (not aa?) ba?) (sortCustomers-exit (departureEvent-customer eventa) (arrivalEvent-customer eventb))]
    [else (sortCustomers-exit (departureEvent-customer eventa) (departureEvent-customer eventb))]))

(define (sortEvent-arrival eventa eventb)
  (define aa? (arrivalEvent? eventa))
  (define ba? (arrivalEvent? eventb))
  (cond
    [(and aa? ba?) (sortCustomers-arrival (arrivalEvent-customer eventa) (arrivalEvent-customer eventb))]
    [(and aa? (not ba?)) (sortCustomers-arrival (arrivalEvent-customer eventa) (departureEvent-customer eventb))]
    [(and (not aa?) ba?) (sortCustomers-arrival (departureEvent-customer eventa) (arrivalEvent-customer eventb))]
    [else (sortCustomers-arrival (departureEvent-customer eventa) (departureEvent-customer eventb))]))

;;; Args accessors
(define (updateargs args pos newelement)
  (append (take args pos) (list newelement) (cdr (list-tail args pos))))

(define (getevents args)
  (list-ref args 0))
(define (eventspos args)
  0)
(define (changeevents args newelement)
  (updateargs args 0 newelement))
(define (getservers args)
  (list-ref args 1))
(define (serverspos args)
   1)
(define (changeservers args newelement)
   (updateargs args 1 newelement))
(define (getqueues args)
  (list-ref args 2))
(define (queuespos args)
   2)
(define (changequeues args newelement)
   (updateargs args 2 newelement))
(define (getMAXQUEUE args)
  (list-ref args 3))
(define (MAXQUEUEpos args)
   3)
(define (changeMAXQUEUE args newelement)
   (updateargs args 3 newelement))
(define (getcurrtime args)
  (list-ref args 4))
(define (currtimepos args)
   4)
(define (changecurrtime args newelement)
   (updateargs args 4 newelement))
(define (getavgqlen args)
  (list-ref args 5))
(define (avgqlenpos args)
   5)
(define (changeavgqlen args newelement)
   (updateargs args 5 newelement))
(define (getsvridletime args)
  (list-ref args 6))
(define (svridletimepos args)
   6)
(define (changesvridletime args newelement)
   (updateargs args 6 newelement))
(define (getiter args)
  (list-ref args 7))
(define (iterpos args)
   7)
(define (changeiter args newelement)
   (updateargs args 7 newelement))

;;; QUEUE operations
(define (push q o)
  (append q (list o)))
(define (get q)
  (car q))
(define (pop q)
  (cond
    [(empty? q) (list)]
    [else (cdr q)]))

(define-struct customer (arrival service exit))
(define-struct arrivalEvent (customer queue))
(define-struct departureEvent (customer queue))

(define MEANARRIVAL 100)
(define MEANDEPART 50)
(define SERVERNUM 1)
(define QUEUENUM 1)
(define MAXQUEUE 30)
(define dropcount 0)
(define custcount 0)
(define currtime 0)
(define avgqlen 0)
(define svridletime 0)
(define server-list (build-list SERVERNUM (lambda (x) #t)))
(define queue-list (build-list QUEUENUM (lambda (x) (list))))

;;; choose queue
(define (chooseQueue stuff)
  0)

;;; create new arrival
(define (newArrival mean time args)
  (make-arrivalEvent (make-customer (+ time (rand-exp mean)) 0 0) (chooseQueue args)))

;;; getevent routine
(define (get-event args)
  (define event-list (getevents args))
  (define currtime (getcurrtime args))
  (cond
    [(empty? event-list) (newArrival MEANARRIVAL (getcurrtime args) args)]
    [else (car event-list)]))

;;; Drops
(define (dropEvent args thisevent)
  (write "DROPPING")
  1)

;;; What to do for an arrival
(define (executeArrival args thisevent)
  (define qpos (arrivalEvent-queue thisevent))
  (define maxq (getMAXQUEUE args))
  (define qlist (getqueues args))
  (define thisq (list-ref (getqueues args) qpos))
  (define nextA (newArrival MEANARRIVAL (getcurrtime args) args))
  (set! args (changeevents args (push (getevents args) nextA)))
  (cond
    [(>= (length (list-ref (getqueues args) qpos)) maxq) (dropEvent args thisevent)]
    [else 
      (set! qlist (append (take qlist qpos) 
                          (list (push thisq thisevent))
                          (cdr (list-tail qlist qpos))))
      (changequeues args qlist)]))


;;; What to do for a departure
(define (executeDeparture args)
  args)

;;; What to do when picked up from queue

;;; Outer loop
;;; args = events, servers, queues, MAXQUEUE, 
;;;         currtime, avgqlen, svridletime, iter,
(define (outerLoop args)
  (define nextEvent (get-event args))
  (set! args (changeevents args (pop (getevents args))))
  (define executeReturn (cond 
                          [(arrivalEvent? nextEvent) (executeArrival args nextEvent)]
                          [else (executeDeparture args nextEvent)]))

  (set! args executeReturn)
  (cond
    [(> (getiter args) 10) args]
    [else (outerLoop (changeiter args (+ (getiter args) 1)))]))

