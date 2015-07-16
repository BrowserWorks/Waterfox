(define-module (lang elisp primitives fns)
  #:use-module (lang elisp internals set)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null))

(fset 'fset fset)
(fset 'defalias fset)

(fset 'apply elisp-apply)

(fset 'funcall
      (lambda (function . args)
	(elisp-apply function args)))

(fset 'interactive-p
      (lambda ()
	%nil))

(fset 'commandp
      (lambda (sym)
	(if (interactive-specification (fref sym)) #t %nil)))

(fset 'fboundp
      (lambda (sym)
	(->nil (variable? (symbol-fref sym)))))

(fset 'symbol-function fref/error-if-void)

(fset 'macroexpand macroexpand)

(fset 'subrp
      (lambda (obj)
	(->nil (not (not-subr? obj)))))

(fset 'byte-code-function-p
      (lambda (object)
	%nil))

(fset 'run-hooks
      (lambda hooks
	(for-each (lambda (hooksym)
		    (for-each (lambda (fn)
				(elisp-apply fn '()))
			      (value hooksym #f)))
		  hooks)))
