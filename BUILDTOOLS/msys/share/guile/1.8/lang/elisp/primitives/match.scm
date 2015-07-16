(define-module (lang elisp primitives match)
  #:use-module (lang elisp internals fset)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 optargs))

(define last-match #f)

(fset 'string-match
      (lambda (regexp string . start)

	(define emacs-string-match

	  (if (defined? 'make-emacs-regexp)

	      ;; This is what we would do if we had an
	      ;; Emacs-compatible regexp primitive, here called
	      ;; `make-emacs-regexp'.
	      (lambda (pattern str . args)
		(let ((rx (make-emacs-regexp pattern))
		      (start (if (pair? args) (car args) 0)))
		  (regexp-exec rx str start)))

	      ;; But we don't have Emacs-compatible regexps, and I
	      ;; don't think it's worthwhile at this stage to write
	      ;; generic regexp conversion code.  So work around the
	      ;; discrepancies between Guile/libc and Emacs regexps by
	      ;; substituting the regexps that actually occur in the
	      ;; elisp code that we want to read.
	      (lambda (pattern str . args)
		(let loop ((discrepancies '(("^[0-9]+\\.\\([0-9]+\\)" .
					     "^[0-9]+\\.([0-9]+)"))))
		  (or (null? discrepancies)
		      (if (string=? pattern (caar discrepancies))
			  (set! pattern (cdar discrepancies))
			  (loop (cdr discrepancies)))))
		(apply string-match pattern str args))))

	(let ((match (apply emacs-string-match regexp string start)))
	  (set! last-match
		(if match
		    (apply append!
			   (map (lambda (n)
				  (list (match:start match n)
					(match:end match n)))
				(iota (match:count match))))
		    #f)))

	(if last-match (car last-match) %nil)))

(fset 'match-beginning
      (lambda (subexp)
	(list-ref last-match (* 2 subexp))))

(fset 'match-end
      (lambda (subexp)
	(list-ref last-match (+ (* 2 subexp) 1))))

(fset 'substring substring)

(fset 'match-data
      (lambda* (#:optional integers reuse)
	last-match))

(fset 'set-match-data
      (lambda (list)
	(set! last-match list)))

(fset 'store-match-data 'set-match-data)
