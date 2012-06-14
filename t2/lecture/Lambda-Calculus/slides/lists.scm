; Tuples
; ------

; The basic building block of the Scheme language is a tuple. A tuple is a pair
; that contains two elements. The first is called the car, the second is called
; the cdr. The car and the cdr may both be other tuples. (or the same tuple !)

; (Note in Mathematics, tuples are an ordered group of elements which have a
; finite number of elements, which is not necessarily two. I will use the terms
; "tuple" and "pair" interchangebly because Scheme does not have an internal
; support for tuples of greater sizes)

; Construct a tuple using cons
(define a (cons 5 6))
(define complex-one (cons 5 (cons 6 7)))

; Get the tuple first element by using the function car
(display (car a))
(newline)

; Get the second element by using cdr
(display (cdr a))
(newline)

; Lists
; -----

; Lists are linked lists of tuples whose cars contains the elements and
; the cdr contains a reference to the next tuple in the list.
; The cdr of the last tuple contains a reference to the empty tuple

; Construct a list using the function "list".
(define mylist (list 5 500 "Hello" 4 4.3))

; Note: that statement is shorthand for:
(define mylist (cons 5 (cons 500 (cons "Hello" (cons 4 (cons 4.3 '()))))))

; The folllowing code prints this list:

(define (print-list a-list)
    (define (myprint rest-of-list element-num)
        (if (not (null? rest-of-list))
            (begin
                (display element-num)
                (display ": ")
                (display (car rest-of-list))
                (newline)
                (myprint (cdr rest-of-list) (+ element-num 1))
            )
        )
    )
    (myprint a-list 0)
)

(print-list mylist)

; Output:
; 0: 5
; 1: 500
; 2: Hello
; 3: 4
; 4: 4.3

; Nested Lists
; ------------

; One can nest lists by passing the return value of list as
; one of the arguments to list

(define towers-of-hanoi (list (list 5 4 3 2 1) '() '()))

(display towers-of-hanoi)
(newline)
;((5 4 3 2 1) () ())

; Shorthand for nestes lists of constants: (quote) or '
(define students '((shlomi fish) (orr dunkleman) (tzafrir cohen)))

; Note: inside the list there are now symbols not strings. You can
; convert strings and symbols to each other using:
(symbol->string 'hello)
(string->symbol "mystring")
