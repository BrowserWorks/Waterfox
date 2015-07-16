(define-module (lang elisp internals set)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals signal)
  #:export (set value))

;; Set SYM's variable value to VAL, and return VAL.
(define (set sym val)
  (if (module-defined? the-elisp-module sym)
      (module-set! the-elisp-module sym val)
      (module-define! the-elisp-module sym val))
  val)

;; Return SYM's variable value.  If it has none, signal an error if
;; MUST-EXIST is true, just return #nil otherwise.
(define (value sym must-exist)
  (if (module-defined? the-elisp-module sym)
      (module-ref the-elisp-module sym)
      (if must-exist
	  (error "Symbol's value as variable is void:" sym)
	  %nil)))
