add ==  (lambda (n) (lambda (m) ((n succ) m)))

succ == (lambda (n) (lambda (f) (lambda (x) (f ((n f) x)))))

add2 == (lambda (n) (lambda (m) ((n f) ((m f) x))))
; We have to prove that "add" and "add2" produce the same results
; for every Church Numeral value of the "n" and "m" parameters.

; Proof by Induction.
; Step 1 : Base
; Let's prove it for n == lc_zero
add == (lambda (n)
         (lambda (m)
            ((n succ) m)
         )
       )

; n == lc_zero so:
n == (lambda (f) (lambda (x) x))

add == (lambda (n) (lambda (m) m))

; since m is (lambda (f) (lambda (x) ((m f) x))) then:

add == (lambda (n) (lambda (m) (lambda (f) (lambda (x) ((m f) x)))))

; Since ((n f) x) is:

((n f) x) == ((lc_zero f) x) == x

; It means that also:

add == (lambda (n) (lambda (m) (lambda (f) (lambda (x) ((n f) (m f) x)))))

; which means that add == add2 for n == lc_zero.

; Step 2 : Induction step
; Let's assume it holds for n and prove it for n* = (succ n)

add == (lambda (n*)
         (lambda (m)
           ((n* succ) m)
         )
       )

add == (lambda (n*)
         (lambda (m)
           (((succ n) succ) m)))

; Substituting succ once
add == (lambda (n*)
         (lambda (m)
           (((
            (lambda (t)
              (lambda (f)
                (lambda (x)
                  (f ((t f) x))
                  )))
            n) succ) m)))

; Evalutating

add == (lambda (n*)
         (lambda (m)
           (succ ((n succ) m))
           )
         )

; Substituting succ again.

add == (lambda (n*)
         (lambda (m)
           ((lambda (t)
              (lambda (f)
                (lambda (x)
                  (f ((t f) x))
                  )))
           ((n succ) m)
           )
           )
         )

add == (lambda (n*)
         (lambda (m)
           (lambda (f)
             (lambda (x)
               (f (((n succ) m) f) x)
               )
             )
           )
         )

; ((((n succ) m) f) x) is ((n f) ((m f) x)) according to the induction
; hypothesis

add == (lambda (n*)
         (lambda (m)
           (lambda (f)
             (lambda (x)
               (f ((n f) ((m f) x)))
               )
             )
           )
         )

; Since (succ n) ==  (f ((n f) x)))
; It means we can substitute (f ((n f) [Expr])) with (((succ n) f) [Expr])

add == (lambda (n*)
         (lambda (m)
           (lambda (f)
             (lambda (x)
               (((succ n) f) ((m f) x))
               )
             )
           )
         )

; n* == (succ n)

add == (lambda (n*)
         (lambda (m)
           (lambda (f)
             (lambda (x)
               ((n* f) ((m f) x))
               )
             )
           )
         )

; Thus add == add2 for n*.
; Q.E.D.

