(define-module (lang elisp primitives syntax)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals lambda)
  #:use-module (lang elisp internals set)
  #:use-module (lang elisp internals trace)
  #:use-module (lang elisp transform))

;;; Define Emacs Lisp special forms as macros.  This is more flexible
;;; than handling them specially in the translator: allows them to be
;;; redefined, and hopefully allows better source location tracking.

;;; {Variables}

(define (setq exp env)
  (cons begin
	(let loop ((sets (cdr exp)))
	  (if (null? sets)
	      '()
	      (cons `(,set (,quote ,(car sets)) ,(transformer (cadr sets)))
		    (loop (cddr sets)))))))

(fset 'setq
      (procedure->memoizing-macro setq))

(fset 'defvar
      (procedure->memoizing-macro
        (lambda (exp env)
	  (trc 'defvar (cadr exp))
	  (if (null? (cddr exp))
	      `(,quote ,(cadr exp))
	      `(,begin (,if (,not (,defined? (,quote ,(cadr exp))))
			    ,(setq (list (car exp) (cadr exp) (caddr exp)) env))
		       (,quote ,(cadr exp)))))))

(fset 'defconst
      (procedure->memoizing-macro
        (lambda (exp env)
	  (trc 'defconst (cadr exp))
	  `(,begin ,(setq (list (car exp) (cadr exp) (caddr exp)) env)
		   (,quote ,(cadr exp))))))

;;; {lambda, function and macro definitions}

(fset 'lambda
      (procedure->memoizing-macro
       (lambda (exp env)
	 (transform-lambda/interactive exp '<elisp-lambda>))))

(fset 'defun
      (procedure->memoizing-macro
       (lambda (exp env)
	 (trc 'defun (cadr exp))
	 `(,begin (,fset (,quote ,(cadr exp))
			 ,(transform-lambda/interactive (cdr exp)
							(symbol-append '<elisp-defun:
								       (cadr exp)
								       '>)))
		  (,quote ,(cadr exp))))))

(fset 'interactive
      (procedure->memoizing-macro
        (lambda (exp env)
	  (fluid-set! interactive-spec exp)
	  #f)))

(fset 'defmacro
      (procedure->memoizing-macro
       (lambda (exp env)
	 (trc 'defmacro (cadr exp))
	 (call-with-values (lambda () (parse-formals (caddr exp)))
	   (lambda (required optional rest)
	     (let ((num-required (length required))
		   (num-optional (length optional)))
	       `(,begin (,fset (,quote ,(cadr exp))
			       (,procedure->memoizing-macro
				(,lambda (exp1 env1)
				  (,trc (,quote using) (,quote ,(cadr exp)))
				  (,let* ((%--args (,cdr exp1))
					  (%--num-args (,length %--args)))
				    (,cond ((,< %--num-args ,num-required)
					    (,error "Wrong number of args (not enough required args)"))
					   ,@(if rest
						 '()
						 `(((,> %--num-args ,(+ num-required num-optional))
						    (,error "Wrong number of args (too many args)"))))
					   (else (,transformer
						  (, @bind ,(append (map (lambda (i)
									   (list (list-ref required i)
										 `(,list-ref %--args ,i)))
									 (iota num-required))
								    (map (lambda (i)
									   (let ((i+nr (+ i num-required)))
									     (list (list-ref optional i)
										   `(,if (,> %--num-args ,i+nr)
											 (,list-ref %--args ,i+nr)
											 ,%nil))))
									 (iota num-optional))
								    (if rest
									(list (list rest
										    `(,if (,> %--num-args
											      ,(+ num-required
												  num-optional))
											  (,list-tail %--args
												      ,(+ num-required
													  num-optional))
											  ,%nil)))
									'()))
							   ,@(map transformer (cdddr exp)))))))))))))))))

;;; {Sequencing}

(fset 'progn
      (procedure->memoizing-macro
        (lambda (exp env)
	  `(,begin ,@(map transformer (cdr exp))))))

(fset 'prog1
      (procedure->memoizing-macro
        (lambda (exp env)
	  `(,let ((%--res1 ,(transformer (cadr exp))))
	     ,@(map transformer (cddr exp))
	     %--res1))))

(fset 'prog2
      (procedure->memoizing-macro
        (lambda (exp env)
	  `(,begin ,(transformer (cadr exp))
		   (,let ((%--res2 ,(transformer (caddr exp))))
		     ,@(map transformer (cdddr exp))
		     %--res2)))))

;;; {Conditionals}

(fset 'if
      (procedure->memoizing-macro
        (lambda (exp env)
	  (let ((else-case (cdddr exp)))
	    (cond ((null? else-case)
		   `(,nil-cond ,(transformer (cadr exp)) ,(transformer (caddr exp)) ,%nil))
		  ((null? (cdr else-case))
		   `(,nil-cond ,(transformer (cadr exp))
			       ,(transformer (caddr exp))
			       ,(transformer (car else-case))))
		  (else
		   `(,nil-cond ,(transformer (cadr exp))
			       ,(transformer (caddr exp))
			       (,begin ,@(map transformer else-case)))))))))

(fset 'and
      (procedure->memoizing-macro
        (lambda (exp env)
	  (cond ((null? (cdr exp)) #t)
		((null? (cddr exp)) (transformer (cadr exp)))
		(else
		 (cons nil-cond
		       (let loop ((args (cdr exp)))
			 (if (null? (cdr args))
			     (list (transformer (car args)))
			     (cons (list not (transformer (car args)))
				   (cons %nil
					 (loop (cdr args))))))))))))

;;; NIL-COND expressions have the form:
;;;
;;; (nil-cond COND VAL COND VAL ... ELSEVAL)
;;;
;;; The CONDs are evaluated in order until one of them returns true
;;; (in the Elisp sense, so not including empty lists).  If a COND
;;; returns true, its corresponding VAL is evaluated and returned,
;;; except if that VAL is the unspecified value, in which case the
;;; result of evaluating the COND is returned.  If none of the COND's
;;; returns true, ELSEVAL is evaluated and its value returned.

(define <-- *unspecified*)

(fset 'or
      (procedure->memoizing-macro
        (lambda (exp env)
	  (cond ((null? (cdr exp)) %nil)
		((null? (cddr exp)) (transformer (cadr exp)))
		(else
		 (cons nil-cond
		       (let loop ((args (cdr exp)))
			 (if (null? (cdr args))
			     (list (transformer (car args)))
			     (cons (transformer (car args))
				   (cons <--
					 (loop (cdr args))))))))))))

(fset 'cond
      (procedure->memoizing-macro
       (lambda (exp env)
	 (if (null? (cdr exp))
	     %nil
	     (cons
	      nil-cond
	      (let loop ((clauses (cdr exp)))
		(if (null? clauses)
		    (list %nil)
		    (let ((clause (car clauses)))
		      (if (eq? (car clause) #t)
			  (cond ((null? (cdr clause)) (list #t))
				((null? (cddr clause))
				 (list (transformer (cadr clause))))
				(else `((,begin ,@(map transformer (cdr clause))))))
			  (cons (transformer (car clause))
				(cons (cond ((null? (cdr clause)) <--)
					    ((null? (cddr clause))
					     (transformer (cadr clause)))
					    (else
					     `(,begin ,@(map transformer (cdr clause)))))
				      (loop (cdr clauses)))))))))))))

(fset 'while
      (procedure->memoizing-macro
        (lambda (exp env)
	  `((,letrec ((%--while (,lambda ()
				  (,nil-cond ,(transformer (cadr exp))
					     (,begin ,@(map transformer (cddr exp))
						     (%--while))
					     ,%nil))))
	      %--while)))))

;;; {Local binding}

(fset 'let
      (procedure->memoizing-macro
        (lambda (exp env)
	  `(, @bind ,(map (lambda (binding)
			    (trc 'let binding)
			    (if (pair? binding)
				`(,(car binding) ,(transformer (cadr binding)))
				`(,binding ,%nil)))
			  (cadr exp))
		    ,@(map transformer (cddr exp))))))

(fset 'let*
      (procedure->memoizing-macro
        (lambda (exp env)
	  (if (null? (cadr exp))
	      `(,begin ,@(map transformer (cddr exp)))
	      (car (let loop ((bindings (cadr exp)))
		     (if (null? bindings)
			 (map transformer (cddr exp))
			 `((, @bind (,(let ((binding (car bindings)))
					(if (pair? binding)
					    `(,(car binding) ,(transformer (cadr binding)))
					    `(,binding ,%nil))))
				    ,@(loop (cdr bindings)))))))))))

;;; {Exception handling}

(fset 'unwind-protect
      (procedure->memoizing-macro
        (lambda (exp env)
	  (trc 'unwind-protect (cadr exp))
	  `(,let ((%--throw-args #f))
	     (,catch #t
	       (,lambda ()
		 ,(transformer (cadr exp)))
	       (,lambda args
		 (,set! %--throw-args args)))
	     ,@(map transformer (cddr exp))
	     (,if %--throw-args
		  (,apply ,throw %--throw-args))))))
