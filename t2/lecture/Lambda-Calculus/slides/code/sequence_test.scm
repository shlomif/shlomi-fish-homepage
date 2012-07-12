(define (f1 x) (display 5) 0)
(define (f2 x) (display "+") 0)
(define (f3 x) (display 6) 0)
(define (f4 x) (display "=") 0)
(define (f5 x) (display 11) 0)
(define (f6 x) (newline) 0)

(define my_seq
(lambda (x)
	(f6 (f5 (f4 (f3 (f2 (f1 x))))))
))

(my_seq 0)
