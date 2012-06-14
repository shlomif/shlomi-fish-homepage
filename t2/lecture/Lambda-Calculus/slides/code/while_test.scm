(load "Y_test.scm")

(define lc_while
(lambda (mycond)
	(lambda (oper)
		(lambda (initial_value)
			((Y (lambda (f)
				(lambda (x)
					((((mycond x)
						(lambda (no_use)
							(f (oper x))
						))
						(lambda (no_use)
							x
						)
					) zero)
				)
			)) initial_value)
		)
	)
))

(define (_cond x) (if (> x 5) lc_false lc_true))
(define (_oper x)
	(display x)
	(newline)
	(+ x 1)
)
(((lc_while _cond) _oper) 0)


(define _cond
(lambda (x)
	((less-or-equal x) (int->church 10))
))

(define _oper
(lambda (x)
	((mult x) (int->church 2))
))

(define a (((lc_while _cond) _oper) (int->church 1)))

(display "a = ")
(display (church->int a))
(newline)

