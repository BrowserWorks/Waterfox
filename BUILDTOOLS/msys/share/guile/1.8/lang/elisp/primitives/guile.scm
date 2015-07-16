(define-module (lang elisp primitives guile)
  #:use-module (lang elisp internals fset))

;;; {Importing Guile procedures into Elisp}

;; It may be worthwhile to import some Guile procedures into the Elisp
;; environment.  For now, though, we don't do this.

(if #f
    (let ((accessible-procedures
	   (apropos-fold (lambda (module name var data)
			   (cons (cons name var) data))
			 '()
			 ""
			 (apropos-fold-accessible (current-module)))))
      (for-each (lambda (name var)
		  (if (procedure? var)
		      (fset name var)))
		(map car accessible-procedures)
		(map cdr accessible-procedures))))
