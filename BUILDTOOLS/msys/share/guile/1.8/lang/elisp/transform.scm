(define-module (lang elisp transform)
  #:use-module (lang elisp internals trace)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals evaluation)
  #:use-module (ice-9 session)
  #:export (transformer transform))

;;; A note on the difference between `(transform-* (cdr x))' and `(map
;;; transform-* (cdr x))'.
;;;
;;; In most cases, none, as most of the transform-* functions are
;;; recursive.
;;;
;;; However, if (cdr x) is not a proper list, the `map' version will
;;; signal an error immediately, whereas the non-`map' version will
;;; produce a similarly improper list as its transformed output.  In
;;; some cases, improper lists are allowed, so at least these cases
;;; require non-`map'.
;;;
;;; Therefore we use the non-`map' approach in most cases below, but
;;; `map' in transform-application, since in the application case we
;;; know that `(func arg . args)' is an error.  It would probably be
;;; better for the transform-application case to check for an improper
;;; list explicitly and signal a more explicit error.

(define (syntax-error x)
  (error "Syntax error in expression" x))

(define-macro (scheme exp . module)
  (let ((m (if (null? module)
	       the-root-module
	       (save-module-excursion
		(lambda ()
		  ;; In order for `resolve-module' to work as
		  ;; expected, the current module must contain the
		  ;; `app' variable.  This is not true for #:pure
		  ;; modules, specifically (lang elisp base).  So,
		  ;; switch to the root module (guile) before calling
		  ;; resolve-module.
		  (set-current-module the-root-module)
		  (resolve-module (car module)))))))
    (let ((x `(,eval (,quote ,exp) ,m)))
      ;;(write x)
      ;;(newline)
      x)))

(define (transformer x)
  (cond ((pair? x)
	 (cond ((symbol? (car x))
		(case (car x)
		  ;; Allow module-related forms through intact.
		  ((define-module use-modules use-syntax)
		   x)
		  ;; Escape to Scheme.
		  ((scheme)
		   (cons-source x scheme (cdr x)))
		  ;; Quoting.
		  ((quote function)
		   (cons-source x quote (transform-quote (cdr x))))
		  ((quasiquote)
		   (cons-source x quasiquote (transform-quasiquote (cdr x))))
		  ;; Anything else is a function or macro application.
		  (else (transform-application x))))
	       ((and (pair? (car x))
		     (eq? (caar x) 'quasiquote))
		(transformer (car x)))
	       (else (syntax-error x))))
	(else
	 (transform-datum x))))

(define (transform-datum x)
  (cond ((eq? x 'nil) %nil)
	((eq? x 't) #t)
	;; Could add other translations here, notably `?A' -> 65 etc.
	(else x)))

(define (transform-quote x)
  (trc 'transform-quote x)
  (cond ((not (pair? x))
	 (transform-datum x))
	(else
	 (cons-source x
		      (transform-quote (car x))
		      (transform-quote (cdr x))))))

(define (transform-quasiquote x)
  (trc 'transform-quasiquote x)
  (cond ((not (pair? x))
	 (transform-datum x))
	((symbol? (car x))
	 (case (car x)
	   ((unquote) (list 'unquote (transformer (cadr x))))
	   ((unquote-splicing) (list 'unquote-splicing (transformer (cadr x))))
	   (else (cons-source x
			      (transform-datum (car x))
			      (transform-quasiquote (cdr x))))))
	(else
	 (cons-source x
		      (transform-quasiquote (car x))
		      (transform-quasiquote (cdr x))))))

(define (transform-application x)
  (cons-source x @fop `(,(car x) (,transformer-macro ,@(map transform-quote (cdr x))))))

(define transformer-macro
  (procedure->memoizing-macro
   (let ((cdr cdr))
     (lambda (exp env)
       (cons-source exp list (map transformer (cdr exp)))))))

(define transform transformer)
