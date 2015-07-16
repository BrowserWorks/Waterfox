(define-module (lang elisp primitives char-table)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null)
  #:use-module (ice-9 optargs))

(fset 'make-char-table
      (lambda* (purpose #:optional init)
	"Return a newly created char-table, with purpose PURPOSE.
Each element is initialized to INIT, which defaults to nil.
PURPOSE should be a symbol which has a `char-table-extra-slots' property.
The property's value should be an integer between 0 and 10."
	(list purpose (vector init))))

(fset 'define-charset
      (lambda (charset-id charset-symbol info-vector)
	(list 'charset charset-id charset-symbol info-vector)))

(fset 'setup-special-charsets
      (lambda ()
	'unimplemented))

(fset 'make-char-internal
      (lambda ()
	'unimplemented))
