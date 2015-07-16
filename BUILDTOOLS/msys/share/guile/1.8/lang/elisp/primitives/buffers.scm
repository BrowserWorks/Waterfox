(define-module (lang elisp primitives buffers)
  #:use-module (ice-9 optargs)
  #:use-module (lang elisp internals fset))

(fset 'buffer-disable-undo
      (lambda* (#:optional buffer)
	'unimplemented))

(fset 're-search-forward
      (lambda* (regexp #:optional bound noerror count)
	'unimplemented))

(fset 're-search-backward
      (lambda* (regexp #:optional bound noerror count)
	'unimplemented))

