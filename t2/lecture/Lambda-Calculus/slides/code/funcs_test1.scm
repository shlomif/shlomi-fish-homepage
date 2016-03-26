(define myfunc 0)
(set! myfunc (lambda (h) (* 3 h)))

(define twice (lambda (func x)
	(func (func x))
))

(display (twice myfunc 2))
(newline)
