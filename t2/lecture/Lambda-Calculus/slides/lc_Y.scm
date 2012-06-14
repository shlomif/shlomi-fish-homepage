; The Y Combinator
; ----------------

; The Y combinator is defined as follows:

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
    )
)

; It has the property that (Y f) is equivalent to (f (Y f)) (and so to
; infinity. One can use the Y combinator to implement recursion in
; lambda calculus.

; Let's see an example in Scheme on how to use the Y combinator:

(define (top x) (car x))
(define (var x) (cadr x))        ; (cadr x) is equivalent to (car (cdr x))
(define (result x) (caddr x))

; This function calculates the sum of integers from (var x) to (top x).
; Note that we can only pass one argument to the Y's function so a
; list is used to pass multiple arguments.
(define mysum
    (Y (lambda (f)
        (lambda (x)
            (if (<= (var x) (top x))
                ; If part
                    ; The Y combinator enables us to use f to call
                    ; itself recursively.
                (f (list
                    (top x)
                    (+ (var x) 1)
                    (+ (result x) (var x))
                ))
                ; Else part
                x
            )
        )
    ))
)


(define solution (mysum (list 10 5 0)))
(display "The solution is: ")
(display (result solution))
(newline)

; Naturally, we can convert this entire thing to lambda calculus:

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

; Notice that we wrap the inner if's in lambdas and pass zero as no_use.
; Otherwise, both conditional clauses will always be evaluated and it will
; run an infinite number of times.
(define mysum
    (Y (lambda (f)
        (lambda (x)
            (((((less-or-equal (var x)) (top x)) ; If var x < top x
                ; If part
                (lambda (no_use)
                    (f
                        (((make-mysum-list
                            (top x))
                            (succ (var x)))
                            ((add (result x)) (var x))
                        )
                    )
                ))
                ; Else part
                (lambda (no_use)
                    x
                ))
                    zero ;  Pass zero as argument to no_use
            )
        )
    ))
)

(define solution (mysum
    (((make-mysum-list
        (int->church 10))
        (int->church 5))
        (int->church 0))
        ))

(display "The solution is: ")
(display (church->int (result solution)))
(newline)

