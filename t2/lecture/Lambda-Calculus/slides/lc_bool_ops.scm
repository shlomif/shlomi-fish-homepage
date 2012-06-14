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
