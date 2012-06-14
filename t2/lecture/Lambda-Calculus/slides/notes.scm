; Notes
; -----

; 1. In this lecture, we have used "define" to define commonly used
; functions. However, we can write the whole program with all the functions
; defined by such constructs:

(
    (lambda (succ)
        (
            ;;; Do something with succ - for example:
            (succ (lambda (f) (lambda (x) (f (f (f x))))))
        )
    )
    ; This is the definition of succ that is accepted as a value to the
    ; function call.
    (lambda (n)
            (lambda (f)
                (lambda (x)
                        (f ((n f) x))
                )
        )
    )
)

; 2. Representing arrays: arrays (a.k.a vectors) can be constructed using
; a binary tree complex of pairs whose leaves are the array's values.

; 3. Church Numerals are base-1 numbers so they are not very efficient. If
; you strive for calculatation efficiency in lambda calculus you may wish
; to represent numbers as vectors of digits, and define calculations on them
; using Al-Khwarizmi's algorithms.

; 4. In order to do things like write to the screen, to files, or etc. You
; need to suply the lambda calculus program with stubs. That way, everything
; can be done in LC.

; 5. It was proved that every recursive function can be implemented in
; Lambda Calculus.

; 6. Lambda Calculus is fairly easy to write in languages that support lexical
; scoping and closures. For example: Scheme, Perl, Python and ML
; can all do LC without any special programming.

; In other languages, like C, Pascal, Assembly or Basic, one can implement
; Lambda Calculus using a stack. I don't remember the exact details, but it's
; possible.

; 7. One can define Y-like combinators that take functions of more than
; one argument (I mean (lambda (x) (lambda (y) ... ))). For example, the
; two-argument Y is:

(define Y2
    (lambda (g)
        (
            (lambda (f)
                (g (lambda (x) (lambda (y) (((f f) x) y))))
            )
            (lambda (f)
                (g (lambda (x) (lambda (y) (((f f) x) y))))
            )
        )
    )
)

; 8. Instead of using pairs one can use a three-object tuple, or a four object
; tuple, etc. For example, the definition of the three-item tuple functions
; are:

(define lc-cons-tuple3
    (lambda (first)
        (lambda (second)
            (lambda (third)
                (lambda (which)
                    (((which first) second) third)
                )
            )
        )
    )
)

(define tuple3-get-first
    (lambda (tuple)
        (tuple (lambda (x) (lambda (y) (lambda (z) x))))
    )
)

(define tuple3-get-second
    (lambda (tuple)
        (tuple (lambda (x) (lambda (y) (lambda (z) y))))
    )
)

(define tuple3-get-third
    (lambda (tuple)
        (tuple (lambda (x) (lambda (y) (lambda (z) z))))
    )
)

; 9. It is sometimes useful to make a lambda expression into a tuple in which
; its car is a Church numeral that denotes its type, and specifies whether
; the cdr is a tuple, a church numeral, a function, a vector, etc.

; 10. Lambda Calculus still has a certain degree of arbitrarity. For example:
; Church numerals could have been defined as:

(define zero (lambda (x) (lambda (f) x)))
(define one  (lambda (x) (lambda (f) (f x))))
(define two  (lambda (x) (lambda (f) (f (f x)))))

; Etc.
; Or true could have been defined as false and false as true...
