;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;83
;;; Overall Simulator
;;;
(printf "Loading a-level-def ~n")

;;; Basic constants
(define Max-Problem-percent 0.05)
(define Min-Capacity-percent -0.2)
(define seconds-in-day 86400)
(define starting-cust-size 10)

;;; Structures
(define-struct customer (webuse webprov datause dataprov storuse storprov))
(define-struct s_webservice (capacity prev_prob))
(define-struct s_database (capacity prev_prob))
(define-struct s_storage (capacity prev_prob))
(define-struct s_parameters (webcap webuse webprov 
                                    datacap datause dataprov
                                    storcap storuse storprov
                                    startcust))
(define-struct s_result (webover webunder
                                 dataover dataunder
                                 storover storunder
                                 out-of-bounds))
(define-struct problem (over under))
