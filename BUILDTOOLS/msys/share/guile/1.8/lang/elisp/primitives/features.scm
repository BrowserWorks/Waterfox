(define-module (lang elisp primitives features)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals load)
  #:use-module (lang elisp internals null)
  #:use-module (ice-9 optargs))

(define-public features '())

(fset 'provide
      (lambda (feature)
	(or (memq feature features)
	    (set! features (cons feature features)))))

(fset 'featurep
      (lambda (feature)
	(->nil (memq feature features))))

(fset 'require
      (lambda* (feature #:optional file-name noerror)
	(or (memq feature features)
	    (load (or file-name
		      (symbol->string feature))
		  noerror
		  #f
		  #f
		  #t))))
