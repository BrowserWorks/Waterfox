(define-module (lang elisp internals trace)
  #:export (trc trc-syms trc-all trc-none))

(define *syms* #f)

(define (trc-syms . syms)
  (set! *syms* syms))

(define (trc-all)
  (set! *syms* #f))

(define (trc-none)
  (set! *syms* '()))

(define (trc . args)
  (let ((sym (car args))
	(args (cdr args)))
    (if (or (and *syms*
		 (memq sym *syms*))
	    (not *syms*))
	(begin
	  (write sym)
	  (display ": ")
	  (write args)
	  (newline)))))

;; Default to no tracing.
(trc-none)
