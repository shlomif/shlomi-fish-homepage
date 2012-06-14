(load "lc_prelude.scm")

(define lc-bit->church
    (lambda (bit)
        ((bit one) zero)
    )
)

(define lc-full-adder-ret-make
    (lambda (bit)
        (lambda (carry)
            ((lc_cons bit) carry)
        )
    )
)

(define lc-full-adder-ret-get-bit lc_car)
(define lc-full-adder-ret-get-carry lc_cdr)

(define lc_xor
    (lambda (x)
        (lambda (y)
            ; If x then:
            ((x
                ; If-part
                ((y lc_false) lc_true))
                ; Else-part
                ((y lc_true) lc_false)
            )
        )
    )
)

(define greater-or-equal
    (lambda (x)
            (lambda (y)
                    (is-zero? ((subtract y) x))
            )
    )
)


(define lc-full-adder
    (lambda (bit1)
        (lambda (bit2)
            (lambda (carry)
                ((lambda (num-bits)
                    ((lc-full-adder-ret-make
                        ((lc_xor ((lc_xor bit1) bit2)) carry))
                        ((greater-or-equal num-bits) two)
                    )
                )
                    ((add
                        ((add
                            (lc-bit->church bit1))
                            (lc-bit->church bit2)
                        ))
                        (lc-bit->church carry)
                    )
                )
            )
        )
    )
)

(define (int->bit-vector num)
    (define (get-num-bits num num-bits)
        (if (= num 0)
            num-bits
            (get-num-bits (quotient num 2) (1+ num-bits))
        )
    )
    (define (myconvert num num-bits-log2)
        (if (= num-bits-log2 0)
            ; Put a single bit
            (if (= num 0) lc_false lc_true)
            (let*
                (
                    (next-log2 (-1+ num-bits-log2))
                    (exp2 (expt 2 (expt 2 next-log2)))
                )
                ((lc_cons
                    (myconvert (remainder num exp2) next-log2))
                    (myconvert (quotient num exp2) next-log2)
                    )
            )
        )
    )
    (let*
        (
            (num-bits (get-num-bits num 0))
            (num-bits-log2 (get-num-bits num-bits 0))
        )

        (list (myconvert num num-bits-log2) num-bits-log2)
    )
)

(define (bit-vector->int vec depth)
    (if (= depth 0)
        ; Get the numerical value of the bit
        ((vec 1) 0)
        ; int = int(car(vec)) | int(car(vec)) << (2**depth)
        (+
            (bit-vector->int (lc_car vec) (- depth 1))
            (*
                (expt 2 (expt 2 (- depth 1)))
                (bit-vector->int (lc_cdr vec) (- depth 1))
            )
        )
    )
)

(define (bit-vector-lc->scheme vec depth)
    (if (= depth 0)
        ((vec 1) 0)
        (cons
            (bit-vector-lc->scheme (lc_car vec) (-1+ depth))
            (bit-vector-lc->scheme (lc_cdr vec) (-1+ depth))
        )
    )
)

(define (full-adder-ret->scheme fa-ret)
    (list
        (((lc_car fa-ret) 1) 0)
        (((lc_cdr fa-ret) 1) 0)
    )
)

(define make-result-and-carry
    (lambda (result)
        (lambda (carry)
            ((lc_cons result) carry)
        )
    )
)

(define r-c-result
    (lambda (r-c)
        (lc_car r-c)
    )
)

(define r-c-carry
    (lambda (r-c)
        (lc_cdr r-c)
    )
)

(define make-lbva
    (lambda (depth)
        (lambda (vec1)
            (lambda (vec2)
                (lambda (carry)
                    ((lc_cons ((lc_cons vec1) vec2)) ((lc_cons depth) carry))
                )
            )
        )
    )
)

(define lbva-depth
    (lambda (lbva)
        (lc_car (lc_cdr lbva))
    )
)

(define lbva-vec1
    (lambda (lbva)
        (lc_car (lc_car lbva))
    )
)

(define lbva-vec2
    (lambda (lbva)
        (lc_cdr (lc_car lbva))
    )
)

(define lbva-carry
    (lambda (lbva)
        (lc_cdr (lc_cdr lbva))
    )
)


(define lc-bit-vector-add
    (lambda (depth)
        (lambda (vec1)
            (lambda (vec2)
                ((Y
                    (lambda (f)
                        (lambda (x)
                            (begin
                                ;(display "depth = ")
                                ;(display (church->int (lbva-depth x)))
                                ;(newline)

                            ((((is-zero? (lbva-depth x))
                                (lambda (no_use)
                                    (((lc-full-adder
                                        (lbva-vec1 x))
                                        (lbva-vec2 x))
                                        (lbva-carry x)
                                    )
                                ))
                                (lambda (no_use)
                                    ((lambda (first-part-sum)
                                        ((lambda (second-part-sum)
                                            (begin
                                                ;(display first-part-sum)
                                                ;(newline)
                                                ;(display second-part-sum)
                                                ;(newline)
                                            ((make-result-and-carry
                                                ((lc_cons
                                                    (r-c-result first-part-sum))
                                                    (r-c-result second-part-sum)))
                                                (r-c-carry second-part-sum)
                                            )
                                            )
                                        )

                                            (f ((((make-lbva
                                                (pred (lbva-depth x)))
                                                (lc_cdr (lbva-vec1 x)))
                                                (lc_cdr (lbva-vec2 x)))
                                                (r-c-carry first-part-sum)
                                            ))
                                        )
                                   )
                                        (f
                                            ((((make-lbva
                                                (pred (lbva-depth x)))
                                                (lc_car (lbva-vec1 x)))
                                                (lc_car (lbva-vec2 x)))
                                                (lbva-carry x)
                                            )
                                        )
                                   )
                                ))
                                    ; Pass zero as no_use
                                    zero
                            ))
                        )
                    )
                )
                ; This is the bootstrap for the Y combinator
                ((((make-lbva depth) vec1) vec2) lc_false)
                )
            )
        )
    )
)

(define a (int->bit-vector 189))
(display a)
(newline)
(define b (bit-vector->int (car a) (cadr a)))
(display b)
(newline)
(define a (((lc-full-adder lc_true) lc_true) lc_true))
(define t (greater-or-equal 5))

(define (bool->lc bool) (if bool lc_true lc_false))
(define bools-list (list #f #t))

(define (test-full-adder)
    (for-each
        (lambda (bit1)
            (for-each
                (lambda (bit2)
                    (for-each
                        (lambda (carry)
                            (display (list bit1 bit2 carry))
                            (display "    ")
                            (display (full-adder-ret->scheme (((lc-full-adder (bool->lc bit1)) (bool->lc bit2)) (bool->lc carry))))
                            (newline)
                        )
                        bools-list
                    )
                )
                bools-list
            )
        )
        bools-list
    )
)

;(test-full-adder)

(define a_int 2000)
(define b_int 1500)
(define a (int->bit-vector a_int))
(define b (int->bit-vector b_int))
(if (not (= (cadr a) (cadr b)))
    (error "the depths of a and b are not equal")
)
(define sum (((lc-bit-vector-add (int->church (cadr a))) (car a)) (car b)))
(for-each display (list a_int "+" b_int " = " (bit-vector->int (r-c-result sum) (cadr a))))
(newline)

