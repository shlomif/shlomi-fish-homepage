;;;;
;;;; FILE: output_vars.scm
;;;;



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

; A function can have more than one argument.
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




;;;;
;;;; FILE: cond.scm
;;;;



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
; to execute more than one statement use the "begin" construct. "begin" packs a ; few statements into one statement (and returns the value of the 
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
(define max (if (> a b) a b))





;;;;
;;;; FILE: funcs.scm
;;;;



; Functions
; ---------

; use the "lambda" keyword to define an anonymous function.

(define pythagoras (lambda (a b)
	(sqrt 
		(+ 
			(* a a) 
			(* b b)
		)
	)
))

(display (pythagoras 3 4))
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
))

(display (myfunc 5 6))
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
))

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
))

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
	))
	(display_sum a b)
	(display_sum c d)
	(display_sum e f)
))

(display_sum 5 6) ; Error!, display_sum is not defined in this scope.




(define make-counter
(lambda (start_from)
	(define increment
	(lambda ()
		(set! start_from (+ start_from 1))
		(- start_from 1)
	))
	increment
))

(define counter (make-counter 100))
(display (counter))
(newline)
(display (counter))
(newline)
; This code will print:
; 100
; 101

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



;;;;
;;;; FILE: loops.scm
;;;;



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
))

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
	))
)

(iter1 1 100)



;;;;
;;;; FILE: lists.scm
;;;;



; Tuples
; ------

; The basic building block of the Scheme language is a tuple. A tuple is a pair
; that contains two elements. The first is called the car, the second is called
; the cdr. The car and the cdr may both be other tuples. (or the same tuple !)

; Construct a tuple using cons
(define a (cons 5 6))
(define complex-one (cons 5 (cons 6 7)))
; Get the tuple first element by using the function car
(display (car a))

; Get the second element by using cdr
(display (car b))

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



;;;;
;;;; FILE: lc_intro.scm
;;;;



; Lambda Calculus
; ---------------

; Lambda Calculus is a form of programming in which their are two basic
; operations:
; 1. Defining a function that accepts one argument and returns one argument.
;    Markup: [lambda][variable].[return expression]
; 2. Executing a lambda expression on another lambda expression:
;    Markup: ([function] [argument])

; Examples:
(define identity (lambda (a) a))
(define second-argument (lambda (a) (lambda (b) (lambda (c) b))))
(define another-example (lambda (f) (f f)))

; Note that as in Scheme, the returned lambdas remember all the variable
; with which they were called. So for example:
(((second-argument 5) 6) 7)
; Will propage into:
; (lambda (b) (lambda (c) b)) while remembering that a = 5
; And in turn into
; (lambda (c) b) while remembering that a = 5 and b = 6
; And into
; b while remembering that a = 5 and b = 6 and c = 7
; Which is in turn equal to 6




;;;;
;;;; FILE: lc_bools_conds_tuples.scm
;;;;



; Boolean constants in lambda calculus.
; -------------------------------------

; Traditonally true and false are:
(define lc_true  (lambda (x) (lambda (y) x)))
(define lc_false (lambda (x) (lambda (y) y)))

; Stay tuned to see why:

; Simple conditionals:
; --------------------

; The C-expression mycond ? a : b can be expressed in lambda calculus as:
((mycond a) b)

; Therefore, we can define if as:
(define lc_if 
(lambda (mycond) 
	(lambda (if-true) 
		(lambda (if-false) 
			((mycond if-true) if-false)
		)
	)
))

(display (((lc_if lc_true) 5) 6))
(newline)
; Prints 5

; Representing Tuples
; -------------------

; We can represent tuple as an if-expression. If the if is passed the value
; lc_true then we will return the tuple car. If the if is passed the value
; lc_false then we will return the tuple cdr.

(define lc_cons
(lambda (mycar)
	(lambda (mycdr)
		; we return this lambda-expression:
		(lambda (which)
			((which mycar) mycdr)
		)
	)
))

(define lc_car
(lambda (tuple)
	(tuple lc_true)
))

(define lc_cdr
(lambda (tuple)
	(tuple lc_false)
))

; Example:
(define mytuple ((lc_cons "A car") "A cdr"))

(display (lc_car mytuple))
(newline)
; Prints "A car"
(display (lc_car mytuple))
(newline)
; Prints "A cdr"



;;;;
;;;; FILE: lc_bool_ops.scm
;;;;



; Boolean Operations in Lambda Calculus
; -------------------------------------

; Not:
; Think of not(a) as
; if a == true
;      return false
; else
;      return true
; end
; Thus in lc it would become:
(define lc_not
(lambda (x)
        ((x lc_false) lc_true)
))

; And(x,y):
; again, think of and as:
; if x == true
;      if b == true
;          return true
;      else
;           return false
;      end
; else
;      return false
; end

(define lc_and
(lambda (x)
        (lambda (y)
                ((x ((y lc_true) lc_false)) lc_false)
        )
))

; Or(x,y):
; if x == true
;     return true
; else
;     if y == true
;         return true
;     else
;         return false
;     end
; end

(define lc_or
(lambda (x)
        (lambda (y)
                ((x lc_true) ((y lc_true) lc_false))
        )
))


; Note, as opposed to the && and || operators in C or the "and" and "or" 
; statements in Scheme, those ands and ors always evaluate both expressions.



;;;;
;;;; FILE: lc_church.scm
;;;;



; Church Numerals
; ---------------

; But how to represent numbers in lambda calculus? Alonso Church, the 
; logician who invented lambda calculus suggested the following method:
(define zero (lambda (f) (lambda (x) x)))
(define one  (lambda (f) (lambda (x) (f x))))
(define two  (lambda (f) (lambda (x) (f (f x)))))
(define three  (lambda (f) (lambda (x) (f (f (f x))))))

; We take f and execute it on x N times

; Converting Church numerals to regular integers:

(define (church->int church)
	((church (lambda (a) (+ a 1))) 0)
)

; Finding the successor to a church numeral:
; Let's take f and execute it on n one more time:
(define succ 
(lambda (n) 
	(lambda (f) 
		(lambda (x) 
			(f ((n f) x))
		)
	)
))

; Converting an integer to a church-numeral
(define (int->church n)
	(if (= n 0)
		zero
		(succ (int->church (- n 1)))
	)
)



;;;;
;;;; FILE: lc_church_ops.scm
;;;;



; Operations with Church Numerals
; -------------------------------

; We already saw how to get the number that follows a given number. Now
; how to do addition, substraction, multiplication, etc.

; Addition:
; We can repeat succ on m for n times in order to add n to m:

(define add
(lambda (n)
	(lambda (m)
		((n succ) m)
	)	
))

; We can evaluate it into:
(define add
(lambda (m)
	(lambda (n)
		(lambda (f)
			(lambda (x)
				((m f) 
					((n f) x)
				)
			)
		)
	)
))

; Now let's try multiplication. Since a church numeral is basically about
; repeating something n times, we can repeat the other multiplicand N times.

(define mult
(lambda (m)
	(lambda (n)
		(lambda (f)
			(m (n f))
		)
	)
))

; Power: we can repeat lc_church_mult m times

(define power
(lambda (m)
	(lambda (n)
		((n (mult m)) (succ zero))
	)
)

; This, in turn can be simplified into:

(define power
(lambda (m)
	(lambda (n)
		(n m)
	)
)

(display (church->int ((power zero) zero)))
; Displays 1, which is another proof that 0^0 is 1.

; Predecessor
; -----------

; Getting the predecessor in Church numerals is quite tricky. 
; Let's consider the following method:
;
; Create a tuple [0,0] and convert it into the tuple [0,1]. Then into
; [1,2], [2,3], etc. Repeat this process N times and we'll get [N-1, N].
; Then we can return the first element of the final tuple which is N-1.

(define pred_next_tuple
(lambda (tuple)
	((lc_cons
		(lc_cdr tuple))       
		(succ (lc_cdr tuple)))
))
; Note that we base the next tuple on the second item of the original tuple.

(define pred
(lambda (n)
	(lc_car 
		((n pred_next_tuple) 
			; A tuple with two zeros.
			((lc_cons zero) zero)
		)
	)
))

; Note that the pred of zero is zero, because there isn't -1 in church numerals

; Subtraction is simply repeating pred m times

(define subtract
(lambda (n)
	(lambda (m)
		((m pred) n)
	)
))


; Now, how do we compare two Church Numerals. We can subtract the
; first one from the second one. If the result is equal to zero, then the 
; second one is greater or equal to the first.

(define is-zero?
(lambda (n)
        ((n (lambda (x) lc_false)) lc_true)
))

(define less-or-equal
(lambda (x)
        (lambda (y)
                (is-zero? ((subtract x) y))
        )
))

; In a similiar way and using not we can define all comparison operators.


; Division and modulo? For this we need the Y combinator.
; Stay tuned...





;;;;
;;;; FILE: lc_Y.scm
;;;;



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
))

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
		        ; The Y combinator enables us to use f to call itself recursively.
			(f (list 
				(top x) 
				(+ (var x) 1) 
				(+ (result x) (var x))
			))
			; Else part
			x
		)
	)
)))

(define solution (mysum (list 10 5 0)))
(display "The solution is: ")
(display (result solution))
(newline)

; Naturally we can convert this entire thing to lambda calculus:

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
		(((((less-or-equal (var x)) (top x))     ; If var x < top x
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
)))

(define solution (mysum 
	(((make-mysum-list 
		(int->church 10))
		(int->church 5))
		(int->church 0))
		))

(display "The solution is: ")
(display (church->int (result solution)))
(newline)




;;;;
;;;; FILE: lc_constructs.scm
;;;;



; Common Language Constructs in Lambda Calculus
; ---------------------------------------------


; As you have seen an if-statement should be wrapped in lambdas while 
; passing zero or other meaningless value as the argument to them. The
; reason for that is that otherwise both clauses will always be evaluated.
; (and we don't want that, do we?)

; The while loop can be defined as follows:

(define lc_while
(lambda (mycond)
	(lambda (oper)
		(lambda (initial_value)
			((Y (lambda (f)
				(lambda (x)
					((((mycond x)
						(lambda (no_use)
							(f (oper x))
						))
						(lambda (no_use)
							x
						)
					) zero)
				)
			)) initial_value)
		)
	)
))

; Scheme Example for the while loop:
(define (_cond x) (if (> x 5) lc_false lc_true))
(define (_oper x) 
	(display x)
	(newline)
	(+ x 1)
)
(((lc_while _cond) _oper) 0)

; Lambda Calculus example: finding the lowest power of 2 that is greater than 10.

(define _cond
(lambda (x)
	((less-or-equal x) (int->church 10))
))

(define _oper
(lambda (x)
	((mult x) (int->church 2))
))

(define a (((lc_while _cond) _oper) (int->church 1)))

(display "a = ")
(display (church->int a))
(newline)

; Creating a sequnce of operations
; --------------------------------

; Since functions are executed in order we can do operations according 
; to the call order.

(define (f1 x) (display 5) 0)
(define (f2 x) (display "+") 0)
(define (f3 x) (display 6) 0)
(define (f4 x) (display "=") 0)
(define (f5 x) (display 11) 0)
(define (f6 x) (newline) 0)

(define my_seq
(lambda (x)
	(f6 (f5 (f4 (f3 (f2 (f1 x))))))
))

(my_seq 0)
; Displays "5+6=11"

; Notice that it is in reverse order from the reading order

; Using a value more than once
; ----------------------------

; To calculate a value once and use it more than once you can create a
; lambda and pass the calculated value as its argument.

(define hello
(lambda (tuple)
	((lambda (thecar)
		; Do something with thecar and possibly tuple
	) (lc_car tuple)) ; Pass (lc_car tuple) as thecar.
))



;;;;
;;;; FILE: lc_church_div.scm
;;;;



; Reminder and Division in Church Numerals
; ----------------------------------------

; I promised that I will show how they were done so here goes:

(define greater-or-equal
(lambda (x)
	(lambda (y)
		((less-or-equal y) x)
	)
))


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
))

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
))

(display "50/8=")
(display (church->int ((divide (int->church 50)) (int->church 8))))
(newline)

; Note that the version of divide does not use tail-recursion.
; Thus, it will consume a memory of O(div/div_by). Still, a tail
; recursion version can be written using a tuple of 
; (div, accumlator).



;;;;
;;;; FILE: notes.scm
;;;;



; Notes
; -----

; 1. In this lecture, we have used define to define commonly used
; functions. But, we can write the program with all functions exapanded,
; giving us a really long lambda expression.

; 2. Representing arrays: arrays (a.k.a vectors) can be constructed using
; a binary tree complex of tuples whose leaves are the array's values.

; 3. Church Numerals are base-1 numbers so they are not very efficient. If
; you strive for calculatation efficiency in lambda calculus you may wish
; to represent numbers as vectors of digits, and define calculations on them
; using Al-Khwarizmi's algorithms.

; 4. In order to do things like write to the screen, to files, or etc. You 
; need to suply the lambda calculus program with stubs. Otherwise, everything
; can be done in LC.

; 5. It was proved that every recursive function can be implemented in 
; Lambda Calculus.

; 6. Lambda Calculus is fairly easy to use in languages that support lexical
; scoping and closures. For example: Scheme, Common LISP, Perl, Python and ML
; can all do LC without any special programming. (In Python it's a bit messy
; though)

; In other languages, like C, Pascal, Assembly or Basic, one can implement 
; Lambda Calculus using a Stack. I don't remember the exact details, but it's
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
))

; 8. Instead of using tuples one can use a three-object tier, or a four object
; tier, etc. For example, the definition of a truple's functions are:

(define lc-cons-truple 
(lambda (first)
	(lambda (second)
		(lambda (third)
			(lambda (which)
				(((which first) second) third)
			)
		)
	)
))

(define truple-get-first
(lambda (tuple)
	(tuple (lambda (x) (lambda (y) (lambda (z) x))))
))

(define truple-get-second
(lambda (tuple)
	(tuple (lambda (x) (lambda (y) (lambda (z) y))))
))

(define truple-get-third
(lambda (tuple)
	(tuple (lambda (x) (lambda (y) (lambda (z) z))))
))

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



