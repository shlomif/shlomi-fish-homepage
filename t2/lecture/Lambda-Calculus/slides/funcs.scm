; Functions
; ---------

; use the "lambda" keyword to define an anonymous function.

(define pythagoras
    (lambda (a b)
        (sqrt
            (+
                (* a a)
                (* b b)
            )
        )
    )
)

(display (pythagoras 3 4))
(newline)
; Displays 5

; Note: you can declare a lambda and execute it in the same statement:

(define myvar ((lambda (a) (* 2 a)) 10))
; myvar will be set to 20

; A function executes all the statements inside it and returns the last statement.

(define myfunc
    (lambda (a b)
        (display a)
        (display "+")
        (display b)
        (display "=")
        (+ a b)
    )
)

(display (myfunc 5 6))
(newline)
;Will display:
;5+6=11

; More about "define" and "set!"
; ------------------------------

; A define inside a function will only be visible inside that function.
; Assuming a variable of the same name was defined in the outside, it will
; be restored to the same value as soon as the function terminates.

(define a 500)

(define myfunc
    (lambda ()
        (define a 6)
        (display a)
        (newline)
    )
)

(myfunc)
(display a)
(newline)

; A function can see all the variables that were defined on the outside.

; set! sets the variable that is most closest to the current scope. (hence
; is in the inner-most scope).

(define a "a_old_value")
(define b "b_old_value")

(define myfunc
    (lambda ()
        (define a 30)
        (set! a "a_new_value")
        (set! b "b_new_value")
    )
)

(display a)
(newline)
(display b)
(newline)

; This code will print:
; a_old_value
; b_new_value

; Functions inside functions
; --------------------------

; One can define functions inside functions. Those functions can see the
; variables of the outer functions even after those functions terminated.
; This behaviour is called lexical scoping.

(define display_sums
    (lambda (a b c d e f)
        (define display_sum
            (lambda (one two)
                (display one)
                (display "+")
                (display two)
                (display "=")
                (display (+ one two))
                (newline)
            )
        )
        (display_sum a b)
        (display_sum c d)
        (display_sum e f)
    )
)

(if #f
    (display_sum 5 6) ; Error!, display_sum is not defined in this scope.
)




(define make-counter
    (lambda (start_from)
        (define increment
            (lambda ()
                (set! start_from (+ start_from 1))
                start_from
            )
        )
        increment
    )
)

(define counter (make-counter 100))
(display (counter))
(newline)
(display (counter))
(newline)
; This code will print:
; 100
; 101

;;; Now let's define a second counter
(define second-counter (make-counter 100))
(display (second-counter))
(newline)
(display (counter))
(newline)

; Lambdas are regular variables
; -----------------------------

; You can pass them around. For example:

(define myfunc 0)
(set! myfunc (lambda (h) (* 3 h)))

(define twice (lambda (func x)
    (func (func x))
))

(display (twice myfunc 2))
(newline)

; This will print 18
