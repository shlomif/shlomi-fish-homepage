;From shriram@cs.rice.edu Sat May 27 12:03:11 2000
;Date: Sat, 20 May 2000 15:01:54 -0500 (CDT)
;From: Shriram Krishnamurthi <shriram@cs.rice.edu>
;To: Shlomi Fish <shlomif@shlomifish.org>
;Subject: Re: www.schemers.org is dead


;For your amusement, I submit the following code, which my friend Mayer
;Goldberg (at BGU, whom you link to and may know) inspired me to write.
;(It's only a small step beyond the code in your LC lecture, and may
;suggest an amusing extension to it.)

(define zero
  (lambda (f)
    (lambda (x)
      x ) ) )

(define succ
  (lambda (n)
    (lambda (f)
      (lambda (x)
	(f ((n f) x)) ) ) ) )

(define num->int
  (lambda (n)
    ((n (lambda (x) (+ x 1))) 0) ) )

(define int->num
  (lambda (n)
    (if (zero? n)
	zero
	(succ (int->num (- n 1))) ) ) )

(define one (succ zero))
(define two (succ one))
(define three (succ two))
(define four (succ three))
(define five (succ four))

(define add
  (lambda (x)
    (lambda (y)
      ((y succ) x) ) ) )

(define pred
  (lambda (n)
    (kdr ((n (lambda (p)
	       ((kons (succ (kar p)))
		(kar p) ) ))
	  ((kons zero) zero) )) ) )

(define mult
  (lambda (x)
    (lambda (y)
      ((y (add x)) zero) ) ) )

(define kons
  (lambda (x)
    (lambda (y)
      (lambda (fun)
	((fun x) y) ) ) ) )

(define kar
  (lambda (p)
    (p (lambda (x)
	 (lambda (y)
	   x ) )) ) )

(define kdr
  (lambda (p)
    (p (lambda (x)
	 (lambda (y)
	   y ) )) ) )

(define fact
  (lambda (n)
    (kdr ((n (lambda (p)
	       ((kons (succ (kar p)))
		((mult (kar p)) (kdr p)) ) ))
	  ((kons one) one) )) ) )

(define exp-slow
  (lambda (x)
    (lambda (y)
      ((y (mult x)) one) ) ) )

(define exp-fast
  (lambda (x)
    (lambda (y)
      (y x) ) ) )

(define fibo
  (lambda (n)
    (kdr (kdr ((n (lambda (p)
		    ((kons (succ (kar p)))
		     ((kons (kdr (kdr p)))
		      ((add (kar (kdr p))) (kdr (kdr p))) ) ) ))
	       ((kons one) ((kons zero) one)) ))) ) )

(define monus
  (lambda (x)
    (lambda (y)
      ((y (lambda (z)
	    (pred z) ))
       x ) ) ) )

(define max
  (lambda (x)
    (lambda (y)
      ((add x)
       (kdr ((x (lambda (p)
		  ((kons (pred (kar p)))
		   (pred (kdr p)) ) ))
	     ((kons x) y) )) ) ) ) )

(define min
  (lambda (x)
    (lambda (y)
      ((monus y)
       ((add (kar ((x (lambda (p)
			((kons (pred (kar p)))
			 (pred (kdr p)) ) ))
		   ((kons x) y) )))
	(kdr ((x (lambda (p)
		   ((kons (pred (kar p)))
		    (pred (kdr p)) ) ))
	      ((kons x) y) )) ) ) ) ) )

(define div
  (lambda (x)
    (lambda (y)
      (kar ((x (lambda (p)
		 ((kons
		   ((add (kar p))
		    ((min one) ((monus (kdr p)) y)) ) )
		  ((monus (kdr p)) y) ) ))
	    ((kons zero) (succ x)) )) ) ) )

(define mod
  (lambda (x)
    (lambda (y)
      ((monus x) ((mult y) ((div x) y))) ) ) )

(define isnonzero
  (lambda (n)
    (kar ((n (lambda (p)
	       ((kons (kdr p))
		(pred (kdr p)) ) ))
	  ((kons n) n) )) ) )

(define iszero
  (lambda (n)
    ((monus one) (isnonzero n)) ) )

(define gcd
  (lambda (x)
    (lambda (y)
      (kar ((x (lambda (p)
		 ((kons ((add
			  ((mult (iszero (kdr p))) (kar p)) )
			 ((mult (isnonzero (kdr p))) (kdr p)) ))
		  ((add
		    ((mult (iszero (kdr p))) zero) )
		   ((mult (isnonzero (kdr p)))
		    ((mod (kar p)) (kdr p)) ) ) ) ))
	    ((kons x) y) )) ) ) )

(define sqrt
  (lambda (n)
    (kdr ((n (lambda (p)
	       ((kons (succ (kar p)))
		((add
		  ((mult (isnonzero
			  ((monus ((mult (succ (kdr p))) (succ (kdr p))))
			   n ) ))
		   (kdr p) ) )
		 ((mult (iszero
			 ((monus ((mult (succ (kdr p))) (succ (kdr p))))
			  n ) ))
		  (kar p) ) ) ) ))
	  ((kons one) zero) )) ) )

(define divides
  (lambda (x)
    (lambda (y)
      (iszero ((mod x) y)) ) ) )

(define tau
  (lambda (n)
    (kdr ((n (lambda (p)
	       ((kons (succ (kar p)))
		((add (kdr p)) ((divides n) (kar p))) ) ))
	  ((kons one) zero) )) ) )

(define isprime
  (lambda (n)
    (iszero ((monus (tau n)) two)) ) )
