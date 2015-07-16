(define-module (lang elisp internals signal)
  #:use-module (lang elisp internals format)
  #:replace (error)
  #:export (signal
	    wta))

(define (signal error-symbol data)
  (scm-error 'elisp-signal
	     #f
	     "Signalling ~A with data ~S"
	     (list error-symbol data)
	     #f))

(define (error . args)
  (signal 'error (list (apply format args))))

(define (wta expected actual pos)
  (signal 'wrong-type-argument (list expected actual)))
