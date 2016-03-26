(define zero (lambda (f) (lambda (x) x)))

(define (church->int church)
	((church (lambda (a) (+ a 1))) 0)
)

(define succ
(lambda (n)
	(lambda (f)
		(lambda (x)
			(f ((n f) x))
		)
	)
))

(define (int->church n)
	(if (= n 0)
		zero
		(succ (int->church (- n 1)))
	)
)

(define add
(lambda (n)
	(lambda (m)
		((n succ) m)
	)
))

(define mult
(lambda (m)
	(lambda (n)
		(lambda (f)
			(m (n f))
		)
	)
))

(define power
(lambda (m)
	(lambda (n)
		((n (mult m)) (succ zero))
	)
))

(define c2 (int->church 2))
(define c3 (int->church 3))
(define c5 (int->church 5))
(define c6 (int->church 6))

(display "0^0 is ")
(display (church->int ((power zero) zero)))
(newline)

(define lc_true  (lambda (x) (lambda (y) x)))
(define lc_false (lambda (x) (lambda (y) y)))

(define lc_cons
(lambda (mycar)
	(lambda (mycdr)
		; we return this lambda-expression:
		(lambda (which)
			((which mycar) mycdr)
		)
	)
))

(define lc_car
(lambda (tuple)
	(tuple lc_true)
))

(define lc_cdr
(lambda (tuple)
	(tuple lc_false)
))

(define pred_next_tuple
(lambda (tuple)
	((lc_cons
		(lc_cdr tuple))
		(succ (lc_cdr tuple)))
))

(define pred
(lambda (n)
	(lc_car
		((n pred_next_tuple)
			((lc_cons zero) zero)
		)
	)
))

(define subtract
(lambda (n)
	(lambda (m)
		((m pred) n)
	)
))

(define is-zero?
(lambda (n)
        ((n (lambda (x) lc_false)) lc_true)
))

(define less-or-equal
(lambda (x)
        (lambda (y)
                (is-zero? ((subtract x) y))
        )
))

