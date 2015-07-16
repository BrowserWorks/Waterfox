(define-module (lang elisp internals evaluation)
  #:export (the-elisp-module))

;;;; {Elisp Evaluation}

;;;; All elisp evaluation happens within the same module - namely
;;;; (lang elisp base).  This is necessary both because elisp itself
;;;; has no concept of different modules - reflected for example in
;;;; its single argument `eval' function - and because Guile's current
;;;; implementation of elisp stores elisp function definitions in
;;;; slots in global symbol objects.

(define the-elisp-module (resolve-module '(lang elisp base)))
