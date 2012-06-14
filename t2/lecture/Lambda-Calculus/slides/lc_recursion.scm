; A Simple Recipe for Recursion
; -----------------------------
;
; In Lambda Calculus, a declared lambda cannot directly refer to itself.
; Therefore, recursion is a bit tricky.
;
; In order to recurse, a function should accept two parameters: a reference
; to itself, and its regular argument. We use a different function to call
; the function on itself and the argument.

; Let's demonstrate it in Scheme:

(define (recurser f p)
    (if (= p 0)
        1
        (* 2 (f f (- p 1)))
    )
)

(define (bootstrap f p)
    (f f p)
)

(define (power-2 p) (bootstrap recurser p))

; Now let's convert it to Lambda Calculus:

(define (power-2-lc p)
    ; This is the bootstrapping function
    ((lambda (f)
        ((f f) p)
    )

        ; This is the recursive function itself
        (lambda (f)
            (lambda (p)
                ((((if (= p 0) lc_true lc_false)
                    ; We wrap the conditions in lambdas so only one
                    ; will be executed.
                    (lambda (no_use)
                        1
                    ))
                    (lambda (no_use)
                        (* 2 ((f f) (- p 1)))
                    ))
                    lc_true ; Pass lc_true as no_use
                )
            )
        )
    )
)
