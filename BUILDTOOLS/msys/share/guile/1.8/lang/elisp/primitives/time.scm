(define-module (lang elisp primitives time)
  #:use-module (lang elisp internals time)
  #:use-module (lang elisp internals fset)
  #:use-module (ice-9 optargs))

(fset 'current-time
      (lambda ()
	(let ((now (current-time)))
	  (list (ash now -16)
		(logand now (- (ash 1 16) 1))
		0))))

(fset 'format-time-string format-time-string)

(fset 'current-time-string
      (lambda* (#:optional specified-time)
	(format-time-string "%a %b %e %T %Y" specified-time)))
