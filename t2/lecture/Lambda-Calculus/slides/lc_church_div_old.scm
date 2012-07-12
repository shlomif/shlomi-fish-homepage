; Reminder and Division in Church Numerals
; ----------------------------------------

; I promised that I will show how they were done so here goes:

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

(display (church->int ((reminder (int->church 100)) (int->church 9))))
(newline)

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

(display "50/8=")
(display (church->int ((divide (int->church 50)) (int->church 8))))
(newline)

; Note that the version of divide does not use tail-recursion.
; Thus, it will consume a memory of O(div/div_by). Still, a tail
; recursion version can be written using a three-elements
;( div, div_by, accumlator) list.
