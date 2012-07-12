; Church Numerals
; ---------------

; But how to represent numbers in lambda calculus? Alonso Church, the
; logician who invented lambda calculus suggested the following method:
(define zero (lambda (f) (lambda (x) x)))
(define one  (lambda (f) (lambda (x) (f x))))
(define two  (lambda (f) (lambda (x) (f (f x)))))
(define three  (lambda (f) (lambda (x) (f (f (f x))))))

; We take f and execute it on x N times

; Converting Church numerals to regular integers:

(define (church->int church)
	(
        (church
            (lambda (a) (+ a 1))
        )
            0
    )
)

; Finding the successor to a Church numeral:
; Let's take f and execute it on n one more time:
(define succ
    (lambda (n)
	    (lambda (f)
    		(lambda (x)
    			(f ((n f) x))
    		)
    	)
    )
)

; Converting an integer to a Church numeral
(define (int->church n)
	(if (= n 0)
		zero
		(succ (int->church (- n 1)))
	)
)
