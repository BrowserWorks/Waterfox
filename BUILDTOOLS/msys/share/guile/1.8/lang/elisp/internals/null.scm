(define-module (lang elisp internals null)
  #:export (->nil lambda->nil null))

(define (->nil x)
  (or x %nil))

(define (lambda->nil proc)
  (lambda args
    (->nil (apply proc args))))

(define (null obj)
  (->nil (or (not obj)
	     (null? obj))))
