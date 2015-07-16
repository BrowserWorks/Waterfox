(define-module (lang elisp primitives strings)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null)
  #:use-module (lang elisp internals signal))

(fset 'substring substring)

(fset 'concat
      (lambda args
	(apply string-append
	       (map (lambda (arg)
		      (cond
		       ((string? arg) arg)
		       ((list? arg) (list->string arg))
		       ((vector? arg) (list->string (vector->list arg)))
		       (else (error "Wrong type argument for concat"))))
		    args))))

(fset 'string-to-number string->number)

(fset 'number-to-string number->string)

(fset 'string-lessp (lambda->nil string<?))
(fset 'string< 'string-lessp)

(fset 'aref
      (lambda (array idx)
	(cond ((vector? array) (vector-ref array idx))
	      ((string? array) (char->integer (string-ref array idx)))
	      (else (wta 'arrayp array 1)))))

(fset 'aset
      (lambda (array idx newelt)
	(cond ((vector? array) (vector-set! array idx newelt))
	      ((string? array) (string-set! array idx (integer->char newelt)))
	      (else (wta 'arrayp array 1)))))

(fset 'stringp (lambda->nil string?))

(fset 'vector vector)
