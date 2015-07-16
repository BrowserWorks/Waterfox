(define-module (lang elisp primitives format)
  #:use-module (lang elisp internals format)
  #:use-module (lang elisp internals fset))

(fset 'format format)
(fset 'message message)
