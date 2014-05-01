; Welcome to Scheme!
; In Scheme function calls (or other constructs) start with a "("
; and end with a ")". The arguments are separated by whitespaces.
;
; The first argument is the function name and the rest are arguments.
;
; Examples:

(+ 5 6)
; Returns: 11

(+ (* 2 3) (* 1 7))
; Returns: 13

; A function can have more than two arguments
(+ 1 2 3 4)
; Returns: 10

; The function "display" can be used to output scalars

(display 5)
; Prints 5
(display "Hello World")
; Prints "Hello World"

; The function newline can be used to print a new line
(display "5+6=")
(newline)
(display (+ 5 6))
; Prints:
; 5+6=
; 11

; Use define to declare a variable and set its value
(define a 5)
(define b (+ 9 8))

; Use set! to set the value of a variable that was already declared
(set! a 500)
(set! b "Hello")
(set! myvar 89) ; Error - myvar was not declared.

