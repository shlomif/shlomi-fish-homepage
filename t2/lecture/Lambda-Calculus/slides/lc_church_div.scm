; Reminder and Division in Church Numerals
; ----------------------------------------

; I promised that I will show how they were done so here goes:

(define greater-or-equal
    (lambda (x)
        (lambda (y)
            ((less-or-equal y) x)
        )
    )
)


(define reminder
    (lambda (div)
        (lambda (div_by)
            ((Y (lambda (f)
                (lambda (x)
                    (((((greater-or-equal x) div_by)  ; We can still see div_by
                        (lambda (no_use)
                            (f ((subtract x) div_by))
                        ))
                        (lambda (no_use)
                            x
                        )
                    )
                        zero)    ; Pass zero as an argument to no_use
                )
            ))
                div)  ; Pass div as the initial x
        )
)

(display (church->int ((reminder (int->church 100)) (int->church 9))))
(newline)

(define divide
    (lambda (div)
        (lambda (div_by)
            ((Y (lambda (f)
                (lambda (x)
                    (((((greater-or-equal x) div_by)
                        (lambda (no_use)
                            ; Add one to the result of (x-div_by)/div_by
                            (succ (f ((subtract x) div_by)))
                        ))
                        (lambda (no_use)
                            zero
                        )
                    )
                        zero)    ; Pass zero as an argument to no_use
                )
            ))
                div)  ; Pass div as the initial x
        )
    )
)

(display "50/8=")
(display (church->int ((divide (int->church 50)) (int->church 8))))
(newline)

; Note that the version of divide does not use tail-recursion.
; Thus, it will consume a memory of O(div/div_by). Nevertheless,
; a tail recursion version can be written using a tuple of
; (div, accumulator).


