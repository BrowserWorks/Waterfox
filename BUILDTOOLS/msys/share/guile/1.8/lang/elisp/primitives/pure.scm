(define-module (lang elisp primitives pure)
  #:use-module (lang elisp internals fset))

;; Purification, unexec etc. are not yet implemented...

(fset 'purecopy identity)

(define-public purify-flag %nil)
