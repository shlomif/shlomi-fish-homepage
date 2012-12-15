; Loops
; -----

; In Scheme loops should be implemented using recursion.
; For example:

(define a 1)

(define iter1
    (lambda ()
        (display a)
        (newline)
        (set! a (+ a 1))
        (if (<= a 100)
            (iter1)
        )
    )
)

(iter1)
; Prints all the integers from 1 to 100.

; It is customary to place output variables as arguments to the loop functions.
; Thus, the previous code should be re-written as:

(define (iter1 a top)         ; Equivalent to (define iter1 (lambda (a top)...
    (if (<= a top)
        (begin
            (display a)
            (newline)
            (iter1 (+ a 1) top)
        )
    )
)

(iter1 1 100)
