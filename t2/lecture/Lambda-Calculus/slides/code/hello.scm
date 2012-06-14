(define make-counter
(lambda (s)
	(define increment
	(lambda ()
		(set! s (+ s 1))
		s
	))
	increment
))
