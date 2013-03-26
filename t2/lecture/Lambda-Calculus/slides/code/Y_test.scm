(load "church_test.scm")


(define Y
(lambda (f)
        (
                (lambda (x)
                        (f (lambda (y) ((x x) y)))
                )
                (lambda (x)
                        (f (lambda (y) ((x x) y)))
                )
        )
))

(define (top x) (car x))
(define (var x) (cadr x))
(define (result x) (caddr x))
(define mysum
(Y (lambda (f)
	(lambda (x)
		(if (<= (var x) (top x))
		        ;
			(f (list (top x) (+ (var x) 1) (+ (result x) (var x))))
			x
		)
	)
)))

(define solution (mysum (list 10 5 0)))
(display "The solution is: ")
(display (result solution))
(newline)

(define (top x) (lc_car x))
(define (var x) (lc_car (lc_cdr x)))
(define (result x) (lc_car (lc_cdr (lc_cdr x))))

(define make-mysum-list
(lambda (top)
	(lambda (var)
		(lambda (result)
			((lc_cons top) ((lc_cons var) ((lc_cons result) zero)))
		)
	)
))

(define mysum
(Y (lambda (f)
	(lambda (x)
		(((((less-or-equal (var x)) (top x))     ; If var x < top x
			(lambda (no_use)
			(f
				(((make-mysum-list
					(top x))
					(succ (var x)))
					((add (result x)) (var x)))
			)
			))
			(lambda (no_use)
				x
			))
				zero ;  Pass zero as argument to no_use
			)
		)
	)
))

(define solution (mysum
	(((make-mysum-list
		(int->church 10))
		(int->church 5))
		(int->church 0))
		))

(display "The solution is: ")
(display (church->int (result solution)))
(newline)

