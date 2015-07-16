(define-module (lang elisp primitives read)
  #:use-module (lang elisp internals fset))

;;; MEGA HACK!!!!

(fset 'read (lambda (str)
	      (cond ((string=? str "?\\M-\\^@")
		     -134217728)
		    (else
		     (with-input-from-string str read)))))
