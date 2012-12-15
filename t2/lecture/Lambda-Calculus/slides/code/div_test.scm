(load "while_test.scm")

(define greater-or-equal
(lambda (x)
	(lambda (y)
		((less-or-equal y) x)
	)
))

(define reminder_helper
(Y (lambda (f)
	(lambda (x)
		(((lambda (div)
			(lambda (div_by)
				(((((greater-or-equal div) div_by)
					(lambda (no_use)
						(f ((lc_cons
							((subtract div) div_by))
							div_by))
					))
					(lambda (no_use)
						div
					))
					zero
				)
			)
		) (lc_car x)) (lc_cdr x))
	)
)))

(define reminder
(lambda (div)
	(lambda (div_by)
		(reminder_helper ((lc_cons div) div_by))
	)
))

(define reminder2
(lambda (div)
    (lambda (div_by)
        ((Y (lambda (f)
            (lambda (x)
                (((((greater-or-equal x) div_by)  ; We can still see div_by
                    (lambda (no_use)
                        (f ((subtract x) div_by))
                    ))
                    (lambda (no_use)
                        x
                    )
                )
                    zero)    ; Pass zero as an argument to no_use
            )
        ))
            div)  ; Pass div as the initial x
    )
))


(display (church->int ((reminder (int->church 100)) (int->church 9))))
(newline)

;(define (div_get_counter tuple) (lc_car tuple))
;(define (div_get_number tuple) (lc_car (lc_cdr tuple)))
;(define (div_get_div_by tuple) (lc_car (lc_cdr (lc_cdr tuple))))

(define divide_helper
(Y (lambda (f)
	(lambda (x)
		(((lambda (div)
			(lambda (div_by)
				(((((greater-or-equal div) div_by)
					(lambda (no_use)
						(succ (f ((lc_cons
							((subtract div) div_by))
							div_by)))
					))
					(lambda (no_use)
						zero
					))
					zero
				)
			)
		) (lc_car x)) (lc_cdr x))
	)
)))

(define divide
(lambda (div)
	(lambda (div_by)
		(divide_helper ((lc_cons div) div_by))
	)
))

(define divide2
(lambda (div)
    (lambda (div_by)
        ((Y (lambda (f)
            (lambda (x)
                (((((greater-or-equal x) div_by)
                    (lambda (no_use)
                        (succ (f ((subtract x) div_by)))
                    ))
                    (lambda (no_use)
                        zero
                    )
                )
                    zero)    ; Pass zero as an argument to no_use
            )
        ))
            div)  ; Pass div as the initial x
    )
))

(display "50/8=")
(display (church->int ((divide (int->church 50)) (int->church 8))))
(newline)

(display "divide2: 50/8=")
(display (church->int ((divide2 (int->church 50)) (int->church 8))))
(newline)
