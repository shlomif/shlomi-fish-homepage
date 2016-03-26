; Conditionals
; ------------

; Use the if statement to put a conditional.
; Syntax:
; (if cond [true statement] [optional false statement])

(define a 50)
(define b 30)
(if (< a b)
    (display "a is lesser than b")
    (display "a is not lesser than b")
)

; Note: there can only be _one_ statement in the if conditionals. If you want
; to execute more than one statement use the "begin" construct. "begin" packs
; a few statements into one statement (and returns the value of the
; last statement.

(if (< a b)
    (begin
        (display a)
        (display " is lesser than ")
        (display b)
        (newline)
    )
)

; The if returns the value of the expression that was executed.
(define max-of-a-and-b (if (> a b) a b))


