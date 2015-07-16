(define-module (lang elisp primitives load)
  #:use-module (lang elisp internals load)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals fset))

(fset 'load load)
(re-export load-path)

(fset 'eval
      (lambda (form)
	(eval form the-elisp-module)))

(fset 'autoload
      (lambda args
	#t))

(define-public current-load-list %nil)
