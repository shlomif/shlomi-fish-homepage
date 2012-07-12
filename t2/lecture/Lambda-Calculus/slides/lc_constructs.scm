; Common Language Constructs in Lambda Calculus
; ---------------------------------------------


; As you have seen an if-statement should be wrapped in lambdas while
; passing zero or other meaningless value as the argument to them. The
; reason for that is that otherwise both clauses will always be evaluated.
; (and we don't want that, do we?)

; The while loop can be defined as follows:

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
    )
)

; Scheme Example for the while loop:
(define (_cond x) (if (> x 5) lc_false lc_true))
(define (_oper x)
	(display x)
	(newline)
	(+ x 1)
)
(((lc_while _cond) _oper) 0)

; Lambda Calculus example: finding the lowest power of 2 that is greater than 10.

(define _cond
    (lambda (x)
        ((less-or-equal x) (int->church 10))
    )
)

(define _oper
    (lambda (x)
        ((mult x) (int->church 2))
    )
)

(define a (((lc_while _cond) _oper) (int->church 1)))

(display "a = ")
(display (church->int a))
(newline)

; Creating a sequnce of operations
; --------------------------------

; Since functions are executed in order we can do operations according
; to the call order.

(define (f1 x) (display 5) 0)
(define (f2 x) (display "+") 0)
(define (f3 x) (display 6) 0)
(define (f4 x) (display "=") 0)
(define (f5 x) (display 11) 0)
(define (f6 x) (newline) 0)

(define my_seq
    (lambda (x)
        (f6 (f5 (f4 (f3 (f2 (f1 x))))))
    )
)

(my_seq 0)
; Displays "5+6=11"

; Notice that it is in reverse order from the reading order



; Using a value more than once
; ----------------------------

; To calculate a value once and use it more than once you can create a
; lambda and pass the calculated value as its argument.

(define hello
    (lambda (tuple)
        ((lambda (thecar)
            ; Do something with thecar and possibly tuple
        ) (lc_car tuple)) ; Pass (lc_car tuple) as thecar.
    )
)
