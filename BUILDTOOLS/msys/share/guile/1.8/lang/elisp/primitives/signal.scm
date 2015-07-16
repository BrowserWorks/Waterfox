(define-module (lang elisp primitives signal)
  #:use-module (lang elisp internals signal)
  #:use-module (lang elisp internals fset))

(fset 'signal signal)
(fset 'error error)
