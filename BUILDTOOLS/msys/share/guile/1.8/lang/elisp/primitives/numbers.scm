(define-module (lang elisp primitives numbers)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null))

(fset 'logior logior)
(fset 'logand logand)
(fset 'integerp (lambda->nil integer?))
(fset '= =)
(fset '< <)
(fset '> >)
(fset '<= <=)
(fset '>= >=)
(fset '* *)
(fset '+ +)
(fset '- -)
(fset '1- 1-)
(fset 'ash ash)

(fset 'lsh
      (let ()
	(define (lsh num shift)
	  (cond ((= shift 0)
		 num)
		((< shift 0)
		 ;; Logical shift to the right.  Do an arithmetic
		 ;; shift and then mask out the sign bit.
		 (lsh (logand (ash num -1) most-positive-fixnum)
		      (+ shift 1)))
		(else
		 ;; Logical shift to the left.  Guile's ash will
		 ;; always preserve the sign of the result, which is
		 ;; not what we want for lsh, so we need to work
		 ;; around this.
		 (let ((new-sign-bit (ash (logand num
						  (logxor most-positive-fixnum
							  (ash most-positive-fixnum -1)))
					  1)))
		   (lsh (logxor new-sign-bit
				(ash (logand num most-positive-fixnum) 1))
			(- shift 1))))))
	lsh))

(fset 'numberp (lambda->nil number?))
