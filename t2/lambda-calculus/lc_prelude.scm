; Boolean constants in lambda calculus.
; -------------------------------------

; Traditonally true and false are:
(define lc_true  (lambda (x) (lambda (y) x)))
(define lc_false (lambda (x) (lambda (y) y)))

(define lc_cons
    (lambda (mycar)
        (lambda (mycdr)
            ; we return this lambda-expression:
            (lambda (which)
                ((which mycar) mycdr)
            )
        )
    )
)

(define lc_car
    (lambda (tuple)
        (tuple lc_true)
    )
)

(define lc_cdr
    (lambda (tuple)
        (tuple lc_false)
    )
)

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
    )
)

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
    )
)

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
    )
)


; Note, as opposed to the && and || operators in C or the "and" and "or"
; statements in Scheme, those ands and ors always evaluate both expressions.

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
	(
        (church
            (lambda (a) (+ a 1))
        )
            0
    )
)

; Finding the successor to a Church numeral:
; Let's take f and execute it on n one more time:
(define succ
    (lambda (n)
	    (lambda (f)
    		(lambda (x)
    			(f ((n f) x))
    		)
    	)
    )
)

; Converting an integer to a Church numeral
(define (int->church n)
	(if (= n 0)
		zero
		(succ (int->church (- n 1)))
	)
)

; Operations with Church Numerals
; -------------------------------

; We already saw how to get the number that follows a given number. Now
; how to do addition, substraction, multiplication, etc.

; Addition:
; We can repeat succ on m for n times in order to add n to m:

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
    )
)

; Now let's try multiplication. Since a church numeral is basically about
; repeating something n times, we can repeat the other multiplicand N times.

(define mult
    (lambda (m)
        (lambda (n)
            (lambda (f)
                (m (n f))
            )
        )
    )
)

; Power: we can repeat the LC's mult m times

(define power
    (lambda (m)
        (lambda (n)
            ((n (mult m)) (succ zero))
        )
    )
)

; This, in turn can be simplified into:

(define power
    (lambda (m)
        (lambda (n)
            (n m)
        )
    )
)

; Displays 1, which is another proof that 0^0 is 1.

; Predecessor
; -----------

; Getting the predecessor in Church numerals is quite tricky.
; Let's consider the following method:
;
; Create a pair [0,0] and convert it into the pair [0,1]. (what
; we do is take the cdr and put it in the car and set the cdr to it plus
; 1).
;
; Then into [1,2], [2,3], etc. Repeat this process N times and
; we'll get [N-1, N].
;
; Then we can return the first element of the final pair which is N-1.

(define pred_next_tuple
    (lambda (tuple)
        ((lc_cons
            (lc_cdr tuple))
            (succ (lc_cdr tuple)))
    )
)
; Note that we base the next tuple on the second item of the original tuple.

(define pred
    (lambda (n)
        (lc_car
            ((n pred_next_tuple)
                ; A tuple with two zeros.
                ((lc_cons zero) zero)
            )
        )
    )
)

; Note that the pred of zero is zero, because there isn't -1 in church numerals

; Subtraction is simply repeating pred m times

(define subtract
    (lambda (n)
        (lambda (m)
            ((m pred) n)
        )
    )
)


; Now, how do we compare two Church numerals? We can subtract the
; first one from the second one. If the result is equal to zero, then the
; second one is greater or equal to the first.

(define is-zero?
    (lambda (n)
            ((n (lambda (x) lc_false)) lc_true)
    )
)

(define less-or-equal
    (lambda (x)
            (lambda (y)
                    (is-zero? ((subtract x) y))
            )
    )
)

; In a similar way and by using not we can define all other comparison
; operators.


; Division and modulo? For this we need the Y combinator.
; Stay tuned...

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
    )
)

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
    )
)

; Now let's try multiplication. Since a church numeral is basically about
; repeating something n times, we can repeat the other multiplicand N times.

(define mult
    (lambda (m)
        (lambda (n)
            (lambda (f)
                (m (n f))
            )
        )
    )
)

; Power: we can repeat the LC's mult m times

(define power
    (lambda (m)
        (lambda (n)
            ((n (mult m)) (succ zero))
        )
    )
)

; This, in turn can be simplified into:

(define power
    (lambda (m)
        (lambda (n)
            (n m)
        )
    )
)

; Displays 1, which is another proof that 0^0 is 1.

; Predecessor
; -----------

; Getting the predecessor in Church numerals is quite tricky.
; Let's consider the following method:
;
; Create a pair [0,0] and convert it into the pair [0,1]. (what
; we do is take the cdr and put it in the car and set the cdr to it plus
; 1).
;
; Then into [1,2], [2,3], etc. Repeat this process N times and
; we'll get [N-1, N].
;
; Then we can return the first element of the final pair which is N-1.

(define pred_next_tuple
    (lambda (tuple)
        ((lc_cons
            (lc_cdr tuple))
            (succ (lc_cdr tuple)))
    )
)
; Note that we base the next tuple on the second item of the original tuple.

(define pred
    (lambda (n)
        (lc_car
            ((n pred_next_tuple)
                ; A tuple with two zeros.
                ((lc_cons zero) zero)
            )
        )
    )
)

; Note that the pred of zero is zero, because there isn't -1 in church numerals

; Subtraction is simply repeating pred m times

(define subtract
    (lambda (n)
        (lambda (m)
            ((m pred) n)
        )
    )
)


; Now, how do we compare two Church numerals? We can subtract the
; first one from the second one. If the result is equal to zero, then the
; second one is greater or equal to the first.

(define is-zero?
    (lambda (n)
            ((n (lambda (x) lc_false)) lc_true)
    )
)

(define less-or-equal
    (lambda (x)
            (lambda (y)
                    (is-zero? ((subtract x) y))
            )
    )
)

; In a similar way and by using not we can define all other comparison
; operators.


; Division and modulo? For this we need the Y combinator.
; Stay tuned...

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
    )
)



