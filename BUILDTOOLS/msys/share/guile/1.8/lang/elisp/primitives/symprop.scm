(define-module (lang elisp primitives symprop)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null)
  #:use-module (lang elisp internals set)
  #:use-module (ice-9 optargs))

;;; {Elisp Exports}

(fset 'put set-symbol-property!)

(fset 'get (lambda->nil symbol-property))

(fset 'set set)

(fset 'set-default 'set)

(fset 'boundp
      (lambda (sym)
	(->nil (module-defined? the-elisp-module sym))))

(fset 'default-boundp 'boundp)

(fset 'symbol-value
      (lambda (sym)
	(value sym #t)))

(fset 'default-value 'symbol-value)

(fset 'symbolp
      (lambda (object)
	(or (symbol? object)
	    (keyword? object)
	    %nil)))

(fset 'local-variable-if-set-p
      (lambda* (variable #:optional buffer)
	%nil))

(fset 'symbol-name symbol->string)
