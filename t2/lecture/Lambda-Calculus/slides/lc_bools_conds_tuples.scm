; Boolean constants in lambda calculus.
; -------------------------------------

; Traditionally true and false are:
(define lc_true  (lambda (x) (lambda (y) x)))
(define lc_false (lambda (x) (lambda (y) y)))

; Stay tuned to see why:

; Simple conditionals:
; --------------------

; The C-expression mycond ? a : b can be expressed in lambda calculus as:
((mycond a) b)

; Therefore, we can define if as:
(define lc_if
    (lambda (mycond)
        (lambda (if-true)
            (lambda (if-false)
                ((mycond if-true) if-false)
            )
        )
    )
)

(display (((lc_if lc_true) 5) 6))
(newline)
; Prints 5

; Representing Tuples
; -------------------

; We can represent tuple as an if-expression. If the conditional is passed
; the value lc_true then we will return the tuple's car. If the if is passed
; the value lc_false then we will return the tuple's cdr.

(define lc_cons
    (lambda (mycar)
        (lambda (mycdr)
            ; we return this lambda-expression:
            (lambda (which)
                ((which mycar) mycdr)
            )
        )
    )
)

(define lc_car
    (lambda (tuple)
        (tuple lc_true)
    )
)

(define lc_cdr
    (lambda (tuple)
        (tuple lc_false)
    )
)

; Example:
(define mytuple ((lc_cons "A car") "A cdr"))

(display (lc_car mytuple))
(newline)
; Prints "A car"
(display (lc_cdr mytuple))
(newline)
; Prints "A cdr"
