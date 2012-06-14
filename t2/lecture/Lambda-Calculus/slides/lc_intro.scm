; Lambda Calculus
; ---------------

; Lambda Calculus is a form of programming in which there are two basic
; operations:
; 1. Defining a function that accepts one argument and returns one argument.
;    Markup: [lambda][variable].[return expression]
; 2. Executing a lambda expression on another lambda expression:
;    Markup: ([function] [argument])

; Examples:
(define identity (lambda (a) a))
(define second-argument (lambda (a) (lambda (b) (lambda (c) b))))
(define another-example (lambda (f) (f f)))

; Note that as in Scheme, the returned lambdas remember all the variables
; with which they were called. So for example:
(((second-argument 5) 6) 7)
; Will propagate into:
; (lambda (b) (lambda (c) b)) while remembering that a = 5
; And in turn into
; (lambda (c) b) while remembering that a = 5 and b = 6
; And into
; b while remembering that a = 5 and b = 6 and c = 7
; Which is in turn equal to 6


; Currying:
; ---------
;
; We can create functions of more than one argument in Lambda Calculus
; using a technique called Currying. What it means is that instead of having
; one function that accepts several arguments, we have several nested
; lambdas.
;
; Here's an example:
;
; Instead of writing:
(define my-func
    (lambda (x y)
        (+ (* 2 x) (* 3 y))
    )
)

; and invoking it with
(define ret (my-func 5 6))

; We can define:

(define my-func
    (lambda (x)
        (lambda (y)
            (+ (* 2 x) (* 3 y))
        )
    )
)

; and invoke it with
(define ret ((my-func 5) 6))

; I.e: by making one function call for every argument.

; This technique simplifies the lambda calculus grammar and allows
; us to only deal with functions (and function calls) of one argument


