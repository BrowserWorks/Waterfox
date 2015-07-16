(define-module (lang elisp internals lambda)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp transform)
  #:export (parse-formals
	    transform-lambda/interactive
	    interactive-spec))

;;; Parses a list of elisp formals, e.g. (x y &optional b &rest r) and
;;; returns three values: (i) list of symbols for required arguments,
;;; (ii) list of symbols for optional arguments, (iii) rest symbol, or
;;; #f if there is no rest argument.
(define (parse-formals formals)
  (letrec ((do-required
	    (lambda (required formals)
	      (if (null? formals)
		  (values (reverse required) '() #f)
		  (let ((next-sym (car formals)))
		    (cond ((not (symbol? next-sym))
			   (error "Bad formals (non-symbol in required list)"))
			  ((eq? next-sym '&optional)
			   (do-optional required '() (cdr formals)))
			  ((eq? next-sym '&rest)
			   (do-rest required '() (cdr formals)))
			  (else
			   (do-required (cons next-sym required)
					(cdr formals))))))))
	   (do-optional
	    (lambda (required optional formals)
	      (if (null? formals)
		  (values (reverse required) (reverse optional) #f)
		  (let ((next-sym (car formals)))
		    (cond ((not (symbol? next-sym))
			   (error "Bad formals (non-symbol in optional list)"))
			  ((eq? next-sym '&rest)
			   (do-rest required optional (cdr formals)))
			  (else
			   (do-optional required
					(cons next-sym optional)
					(cdr formals))))))))
	   (do-rest
	    (lambda (required optional formals)
	      (if (= (length formals) 1)
		  (let ((next-sym (car formals)))
		    (if (symbol? next-sym)
			(values (reverse required) (reverse optional) next-sym)
			(error "Bad formals (non-symbol rest formal)")))
		  (error "Bad formals (more than one rest formal)")))))

    (do-required '() (cond ((list? formals)
			    formals)
			   ((symbol? formals)
			    (list '&rest formals))
			   (else
			    (error "Bad formals (not a list or a single symbol)"))))))

(define (transform-lambda exp)
  (call-with-values (lambda () (parse-formals (cadr exp)))
    (lambda (required optional rest)
      (let ((num-required (length required))
	    (num-optional (length optional)))
	`(,lambda %--args
	   (,let ((%--num-args (,length %--args)))
	     (,cond ((,< %--num-args ,num-required)
		     (,error "Wrong number of args (not enough required args)"))
		    ,@(if rest
			  '()
			  `(((,> %--num-args ,(+ num-required num-optional))
			     (,error "Wrong number of args (too many args)"))))
		    (else
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
			      ,@(map transformer (cddr exp)))))))))))

(define (set-not-subr! proc boolean)
  (set! (not-subr? proc) boolean))

(define (transform-lambda/interactive exp name)
  (fluid-set! interactive-spec #f)
  (let* ((x (transform-lambda exp))
	 (is (fluid-ref interactive-spec)))
    `(,let ((%--lambda ,x))
       (,set-procedure-property! %--lambda (,quote name) (,quote ,name))
       (,set-not-subr! %--lambda #t)
       ,@(if is
	     `((,set! (,interactive-specification %--lambda) (,quote ,is)))
	     '())
       %--lambda)))

(define interactive-spec (make-fluid))
