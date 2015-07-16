;;; installed-scm-file

;;;; Copyright (C) 1998,1999,2000,2001,2002, 2003, 2006 Free Software Foundation, Inc.
;;;; 
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;; 
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;; 


;;;; This software is a derivative work of other copyrighted softwares; the
;;;; copyright notices of these softwares are placed in the file COPYRIGHTS
;;;;
;;;; This file is based upon stklos.stk from the STk distribution by
;;;; Erick Gallesio <eg@unice.fr>.
;;;;

(define-module (oop goops)
  :export-syntax (define-class class standard-define-class
		  define-generic define-accessor define-method
		  define-extended-generic define-extended-generics
		  method)
  :export (goops-version is-a? class-of
           ensure-metaclass ensure-metaclass-with-supers
	   make-class
	   make-generic ensure-generic
	   make-extended-generic
	   make-accessor ensure-accessor
	   process-class-pre-define-generic
	   process-class-pre-define-accessor
	   process-define-generic
	   process-define-accessor
	   make-method add-method!
	   object-eqv? object-equal?
	   class-slot-ref class-slot-set! slot-unbound slot-missing 
	   slot-definition-name  slot-definition-options
	   slot-definition-allocation
	   slot-definition-getter slot-definition-setter
	   slot-definition-accessor
	   slot-definition-init-value slot-definition-init-form
	   slot-definition-init-thunk slot-definition-init-keyword 
	   slot-init-function class-slot-definition
	   method-source
	   compute-cpl compute-std-cpl compute-get-n-set compute-slots
	   compute-getter-method compute-setter-method
	   allocate-instance initialize make-instance make
	   no-next-method  no-applicable-method no-method
	   change-class update-instance-for-different-class
	   shallow-clone deep-clone
	   class-redefinition
	   apply-generic apply-method apply-methods
	   compute-applicable-methods %compute-applicable-methods
	   method-more-specific? sort-applicable-methods
	   class-subclasses class-methods
	   goops-error
	   min-fixnum max-fixnum
	   ;;; *fixme* Should go into goops.c
	   instance?  slot-ref-using-class
	   slot-set-using-class! slot-bound-using-class?
	   slot-exists-using-class? slot-ref slot-set! slot-bound?
	   class-name class-direct-supers class-direct-subclasses
	   class-direct-methods class-direct-slots class-precedence-list
	   class-slots class-environment
	   generic-function-name
	   generic-function-methods method-generic-function method-specializers
	   primitive-generic-generic enable-primitive-generic!
	   method-procedure accessor-method-slot-definition
	   slot-exists? make find-method get-keyword)
  :replace (<class> <operator-class> <entity-class> <entity>)
  :no-backtrace)

;; First initialize the builtin part of GOOPS
(%init-goops-builtins)

;; Then load the rest of GOOPS
(use-modules (oop goops util)
	     (oop goops dispatch)
	     (oop goops compile))


(define min-fixnum (- (expt 2 29)))

(define max-fixnum (- (expt 2 29) 1))

;;
;; goops-error
;;
(define (goops-error format-string . args)
  (save-stack)
  (scm-error 'goops-error #f format-string args '()))

;;
;; is-a?
;;
(define (is-a? obj class)
  (and (memq class (class-precedence-list (class-of obj))) #t))


;;;
;;; {Meta classes}
;;;

(define ensure-metaclass-with-supers
  (let ((table-of-metas '()))
    (lambda (meta-supers)
      (let ((entry (assoc meta-supers table-of-metas)))
	(if entry
	    ;; Found a previously created metaclass
	    (cdr entry)
	    ;; Create a new meta-class which inherit from "meta-supers"
	    (let ((new (make <class> #:dsupers meta-supers
			             #:slots   '()
				     #:name   (gensym "metaclass"))))
	      (set! table-of-metas (cons (cons meta-supers new) table-of-metas))
	      new))))))

(define (ensure-metaclass supers env)
  (if (null? supers)
      <class>
      (let* ((all-metas (map (lambda (x) (class-of x)) supers))
	     (all-cpls  (apply append
			       (map (lambda (m)
				      (cdr (class-precedence-list m))) 
				    all-metas)))
	     (needed-metas '()))
	;; Find the most specific metaclasses.  The new metaclass will be
	;; a subclass of these.
	(for-each
	 (lambda (meta)
	   (if (and (not (member meta all-cpls))
		      (not (member meta needed-metas)))
	     (set! needed-metas (append needed-metas (list meta)))))
	 all-metas)
	;; Now return a subclass of the metaclasses we found.
	(if (null? (cdr needed-metas))
	    (car needed-metas)  ; If there's only one, just use it.
	    (ensure-metaclass-with-supers needed-metas)))))

;;;
;;; {Classes}
;;;

;;; (define-class NAME (SUPER ...) SLOT-DEFINITION ... OPTION ...)
;;;
;;;   SLOT-DEFINITION ::= SLOT-NAME | (SLOT-NAME OPTION ...)
;;;   OPTION ::= KEYWORD VALUE
;;;
(define (define-class-pre-definition keyword exp env)
  (case keyword
    ((#:getter #:setter)
     `(process-class-pre-define-generic ',exp))
    ((#:accessor)
     `(process-class-pre-define-accessor ',exp))
    (else #f)))

(define (process-class-pre-define-generic name)
  (let ((var (module-variable (current-module) name)))
    (if (not (and var
		  (variable-bound? var)
		  (is-a? (variable-ref var) <generic>)))
	(process-define-generic name))))

(define (process-class-pre-define-accessor name)
  (let ((var (module-variable (current-module) name)))
    (cond ((or (not var)
	       (not (variable-bound? var)))
	   (process-define-accessor name))
	  ((or (is-a? (variable-ref var) <accessor>)
	       (is-a? (variable-ref var) <extended-generic-with-setter>)))
	  ((is-a? (variable-ref var) <generic>)
	   ;;*fixme* don't mutate an imported object!
	   (variable-set! var (ensure-accessor (variable-ref var) name)))
	  (else
	   (process-define-accessor name)))))

;;; This code should be implemented in C.
;;;
(define define-class
  (letrec (;; Some slot options require extra definitions to be made.
	   ;; In particular, we want to make sure that the generic
	   ;; function objects which represent accessors exist
	   ;; before `make-class' tries to add methods to them.
	   ;;
	   ;; Postpone error handling to class macro.
	   ;;
	   (pre-definitions
	    (lambda (slots env)
	      (do ((slots slots (cdr slots))
		   (definitions '()
		     (if (pair? (car slots))
			 (do ((options (cdar slots) (cddr options))
			      (definitions definitions
				(cond ((not (symbol? (cadr options)))
				       definitions)
				      ((define-class-pre-definition
					 (car options)
					 (cadr options)
					 env)
				       => (lambda (definition)
					    (cons definition definitions)))
				      (else definitions))))
			     ((not (and (pair? options)
					(pair? (cdr options))))
			      definitions))
			 definitions)))
		  ((or (not (pair? slots))
		       (keyword? (car slots)))
		   (reverse definitions)))))
	   
	   ;; Syntax
	   (name cadr)
	   (slots cdddr))
    
    (procedure->memoizing-macro
      (lambda (exp env)
	(cond ((not (top-level-env? env))
	       (goops-error "define-class: Only allowed at top level"))
	      ((not (and (list? exp) (>= (length exp) 3)))
	       (goops-error "missing or extra expression"))
	      (else
	       (let ((name (name exp)))
		 `(begin
		    ;; define accessors
		    ,@(pre-definitions (slots exp) env)
		    ;; update the current-module
		    (let* ((class (class ,@(cddr exp) #:name ',name))
			   (var (module-ensure-local-variable!
				 (current-module) ',name))
			   (old (and (variable-bound? var)
				     (variable-ref var))))
		      (if (and old
			       (is-a? old <class>)
			       (memq <object> (class-precedence-list old)))
			  (variable-set! var (class-redefinition old class))
			  (variable-set! var class)))))))))))

(define standard-define-class define-class)

;;; (class (SUPER ...) SLOT-DEFINITION ... OPTION ...)
;;;
;;;   SLOT-DEFINITION ::= SLOT-NAME | (SLOT-NAME OPTION ...)
;;;   OPTION ::= KEYWORD VALUE
;;;
(define class
  (letrec ((slot-option-keyword car)
	   (slot-option-value cadr)
	   (process-slot-options
	    (lambda (options)
	      (let loop ((options options)
			 (res '()))
		(cond ((null? options)
		       (reverse res))
		      ((null? (cdr options))
		       (goops-error "malformed slot option list"))
		      ((not (keyword? (slot-option-keyword options)))
		       (goops-error "malformed slot option list"))
		      (else
		       (case (slot-option-keyword options)
			 ((#:init-form)
			  (loop (cddr options)
				(append (list `(lambda ()
						 ,(slot-option-value options))
					      #:init-thunk
					      (list 'quote
						    (slot-option-value options))
					      #:init-form)
					res)))
			 (else
			  (loop (cddr options)
				(cons (cadr options)
				      (cons (car options)
					    res)))))))))))
    
    (procedure->memoizing-macro
      (let ((supers cadr)
	    (slots cddr)
	    (options cdddr))
	(lambda (exp env)
	  (cond ((not (and (list? exp) (>= (length exp) 2)))
		 (goops-error "missing or extra expression"))
		((not (list? (supers exp)))
		 (goops-error "malformed superclass list: ~S" (supers exp)))
		(else
		 (let ((slot-defs (cons #f '())))
		   (do ((slots (slots exp) (cdr slots))
			(defs slot-defs (cdr defs)))
		       ((or (null? slots)
			    (keyword? (car slots)))
			`(make-class
			  ;; evaluate super class variables
			  (list ,@(supers exp))
			  ;; evaluate slot definitions, except the slot name!
			  (list ,@(cdr slot-defs))
			  ;; evaluate class options
			  ,@slots
			  ;; place option last in case someone wants to
			  ;; pass a different value
			  #:environment ',env))
		     (set-cdr!
		      defs
		      (list (if (pair? (car slots))
				`(list ',(slot-definition-name (car slots))
				       ,@(process-slot-options
					  (slot-definition-options
					   (car slots))))
				`(list ',(car slots))))))))))))))

(define (make-class supers slots . options)
  (let ((env (or (get-keyword #:environment options #f)
		 (top-level-env))))
    (let* ((name (get-keyword #:name options (make-unbound)))
	   (supers (if (not (or-map (lambda (class)
				      (memq <object>
					    (class-precedence-list class)))
				    supers))
		       (append supers (list <object>))
		       supers))
	   (metaclass (or (get-keyword #:metaclass options #f)
			  (ensure-metaclass supers env))))

      ;; Verify that all direct slots are different and that we don't inherit
      ;; several time from the same class
      (let ((tmp1 (find-duplicate supers))
	    (tmp2 (find-duplicate (map slot-definition-name slots))))
	(if tmp1
	    (goops-error "make-class: super class ~S is duplicate in class ~S"
			 tmp1 name))
	(if tmp2
	    (goops-error "make-class: slot ~S is duplicate in class ~S"
			 tmp2 name)))

      ;; Everything seems correct, build the class
      (apply make metaclass
	     #:dsupers supers
	     #:slots slots 
	     #:name name
	     #:environment env
	     options))))

;;;
;;; {Generic functions and accessors}
;;;

(define define-generic
  (procedure->memoizing-macro
    (lambda (exp env)
      (let ((name (cadr exp)))
	(cond ((not (symbol? name))
	       (goops-error "bad generic function name: ~S" name))
	      ((top-level-env? env)
	       `(process-define-generic ',name))
	      (else
	       `(define ,name (make <generic> #:name ',name))))))))

(define (process-define-generic name)
  (let ((var (module-ensure-local-variable! (current-module) name)))
    (if (or (not var)
	    (not (variable-bound? var))
	    (is-a? (variable-ref var) <generic>))
	;; redefine if NAME isn't defined previously, or is another generic
	(variable-set! var (make <generic> #:name name))
	;; otherwise try to upgrade the object to a generic
	(variable-set! var (ensure-generic (variable-ref var) name)))))

(define define-extended-generic
  (procedure->memoizing-macro
    (lambda (exp env)
      (let ((name (cadr exp)))
	(cond ((not (symbol? name))
	       (goops-error "bad generic function name: ~S" name))
	      ((null? (cddr exp))
	       (goops-error "missing expression"))
	      (else
	       `(define ,name (make-extended-generic ,(caddr exp) ',name))))))))
(define define-extended-generics
  (procedure->memoizing-macro
    (lambda (exp env)
      (let ((names (cadr exp))
	    (prefixes (get-keyword #:prefix (cddr exp) #f)))
	(if prefixes
	    `(begin
	       ,@(map (lambda (name)
			`(define-extended-generic ,name
			   (list ,@(map (lambda (prefix)
					  (symbol-append prefix name))
					prefixes))))
		      names))
	    (goops-error "no prefixes supplied"))))))

(define (make-generic . name)
  (let ((name (and (pair? name) (car name))))
    (make <generic> #:name name)))

(define (make-extended-generic gfs . name)
  (let* ((name (and (pair? name) (car name)))
	 (gfs (if (pair? gfs) gfs (list gfs)))
	 (gws? (any (lambda (gf) (is-a? gf <generic-with-setter>)) gfs)))
    (let ((ans (if gws?
		   (let* ((sname (and name (make-setter-name name)))
			  (setters
			   (apply append
				  (map (lambda (gf)
					 (if (is-a? gf <generic-with-setter>)
					     (list (ensure-generic (setter gf)
								   sname))
					     '()))
				       gfs)))
			  (es (make <extended-generic-with-setter>
				#:name name
				#:extends gfs
				#:setter (make <extended-generic>
					   #:name sname
					   #:extends setters))))
		     (extended-by! setters (setter es))
		     es)
		   (make <extended-generic>
		     #:name name
		     #:extends gfs))))
      (extended-by! gfs ans)
      ans)))

(define (extended-by! gfs eg)
  (for-each (lambda (gf)
	      (slot-set! gf 'extended-by
			 (cons eg (slot-ref gf 'extended-by))))
	    gfs))

(define (not-extended-by! gfs eg)
  (for-each (lambda (gf)
	      (slot-set! gf 'extended-by
			 (delq! eg (slot-ref gf 'extended-by))))
	    gfs))

(define (ensure-generic old-definition . name)
  (let ((name (and (pair? name) (car name))))
    (cond ((is-a? old-definition <generic>) old-definition)
	  ((procedure-with-setter? old-definition)
	   (make <generic-with-setter>
		 #:name name
		 #:default (procedure old-definition)
		 #:setter (setter old-definition)))
	  ((procedure? old-definition)
	   (make <generic> #:name name #:default old-definition))
	  (else (make <generic> #:name name)))))

(define define-accessor
  (procedure->memoizing-macro
    (lambda (exp env)
      (let ((name (cadr exp)))
	(cond ((not (symbol? name))
	       (goops-error "bad accessor name: ~S" name))
	      ((top-level-env? env)
	       `(process-define-accessor ',name))
	      (else
	       `(define ,name (make-accessor ',name))))))))

(define (process-define-accessor name)
  (let ((var (module-ensure-local-variable! (current-module) name)))
    (if (or (not var)
	    (not (variable-bound? var))
	    (is-a? (variable-ref var) <accessor>)
	    (is-a? (variable-ref var) <extended-generic-with-setter>))
	;; redefine if NAME isn't defined previously, or is another accessor
	(variable-set! var (make-accessor name))
	;; otherwise try to upgrade the object to an accessor
	(variable-set! var (ensure-accessor (variable-ref var) name)))))

(define (make-setter-name name)
  (string->symbol (string-append "setter:" (symbol->string name))))

(define (make-accessor . name)
  (let ((name (and (pair? name) (car name))))
    (make <accessor>
	  #:name name
	  #:setter (make <generic>
		         #:name (and name (make-setter-name name))))))

(define (ensure-accessor proc . name)
  (let ((name (and (pair? name) (car name))))
    (cond ((and (is-a? proc <accessor>)
		(is-a? (setter proc) <generic>))
	   proc)
	  ((is-a? proc <generic-with-setter>)
	   (upgrade-accessor proc (setter proc)))
	  ((is-a? proc <generic>)
	   (upgrade-accessor proc (make-generic name)))
	  ((procedure-with-setter? proc)
	   (make <accessor>
		 #:name name
		 #:default (procedure proc)
		 #:setter (ensure-generic (setter proc) name)))
	  ((procedure? proc)
	   (ensure-accessor (ensure-generic proc name) name))
	  (else
	   (make-accessor name)))))

(define (upgrade-accessor generic setter)
  (let ((methods (slot-ref generic 'methods))
	(gws (make (if (is-a? generic <extended-generic>)
		       <extended-generic-with-setter>
		       <accessor>)
		   #:name (generic-function-name generic)
		   #:extended-by (slot-ref generic 'extended-by)
		   #:setter setter)))
    (if (is-a? generic <extended-generic>)
	(let ((gfs (slot-ref generic 'extends)))
	  (not-extended-by! gfs generic)
	  (slot-set! gws 'extends gfs)
	  (extended-by! gfs gws)))
    ;; Steal old methods
    (for-each (lambda (method)
		(slot-set! method 'generic-function gws))
	      methods)
    (slot-set! gws 'methods methods)
    gws))

;;;
;;; {Methods}
;;;

(define define-method
  (procedure->memoizing-macro
    (lambda (exp env)
      (let ((head (cadr exp)))
	(if (not (pair? head))
	    (goops-error "bad method head: ~S" head)
	    (let ((gf (car head)))
	      (cond ((and (pair? gf)
			  (eq? (car gf) 'setter)
			  (pair? (cdr gf))
			  (symbol? (cadr gf))
			  (null? (cddr gf)))
		     ;; named setter method
		     (let ((name (cadr gf)))
		       (cond ((not (symbol? name))
			      `(add-method! (setter ,name)
					    (method ,(cdadr exp)
						    ,@(cddr exp))))
			     ((defined? name env)
			      `(begin
				 ;; *fixme* Temporary hack for the current
				 ;;         module system
				 (if (not ,name)
				     (define-accessor ,name))
				 (add-method! (setter ,name)
					      (method ,(cdadr exp)
						      ,@(cddr exp)))))
			     (else
			      `(begin
				 (define-accessor ,name)
				 (add-method! (setter ,name)
					      (method ,(cdadr exp)
						      ,@(cddr exp))))))))
		    ((not (symbol? gf))
		     `(add-method! ,gf (method ,(cdadr exp) ,@(cddr exp))))
		    ((defined? gf env)
		     `(begin
			;; *fixme* Temporary hack for the current
			;;         module system
			(if (not ,gf)
			    (define-generic ,gf))
			(add-method! ,gf
				     (method ,(cdadr exp)
					     ,@(cddr exp)))))
		    (else
		     `(begin
			(define-generic ,gf)
			(add-method! ,gf
				     (method ,(cdadr exp)
					     ,@(cddr exp))))))))))))

(define (make-method specializers procedure)
  (make <method>
	#:specializers specializers
	#:procedure procedure))

(define method
  (letrec ((specializers
	    (lambda (ls)
	      (cond ((null? ls) (list (list 'quote '())))
		    ((pair? ls) (cons (if (pair? (car ls))
					  (cadar ls)
					  '<top>)
				      (specializers (cdr ls))))
		    (else '(<top>)))))
	   (formals
	    (lambda (ls)
	      (if (pair? ls)
		  (cons (if (pair? (car ls)) (caar ls) (car ls))
			(formals (cdr ls)))
		  ls))))
    (procedure->memoizing-macro
      (lambda (exp env)
	(let ((args (cadr exp))
	      (body (cddr exp)))
	  `(make <method>
		 #:specializers (cons* ,@(specializers args))
		 #:procedure (lambda ,(formals args)
			       ,@(if (null? body)
				     (list *unspecified*)
				     body))))))))

;;;
;;; {add-method!}
;;;

(define (add-method-in-classes! m)
  ;; Add method in all the classes which appears in its specializers list
  (for-each* (lambda (x)
	       (let ((dm (class-direct-methods x)))
		 (if (not (memv m dm))
		     (slot-set! x 'direct-methods (cons m dm)))))
	     (method-specializers m)))

(define (remove-method-in-classes! m)
  ;; Remove method in all the classes which appears in its specializers list
  (for-each* (lambda (x)
	       (slot-set! x
			  'direct-methods
			  (delv! m (class-direct-methods x))))
	     (method-specializers m)))

(define (compute-new-list-of-methods gf new)
  (let ((new-spec (method-specializers new))
	(methods  (slot-ref gf 'methods)))
    (let loop ((l methods))
      (if (null? l)
	  (cons new methods)
	  (if (equal? (method-specializers (car l)) new-spec)
	      (begin 
		;; This spec. list already exists. Remove old method from dependents
		(remove-method-in-classes! (car l))
		(set-car! l new) 
		methods)
	      (loop (cdr l)))))))

(define (internal-add-method! gf m)
  (slot-set! m  'generic-function gf)
  (slot-set! gf 'methods (compute-new-list-of-methods gf m))
  (let ((specializers (slot-ref m 'specializers)))
    (slot-set! gf 'n-specialized
	       (max (length* specializers)
		    (slot-ref gf 'n-specialized))))
  (%invalidate-method-cache! gf)
  (add-method-in-classes! m)
  *unspecified*)

(define-generic add-method!)

(internal-add-method! add-method!
		      (make <method>
			#:specializers (list <generic> <method>)
			#:procedure internal-add-method!))

(define-method (add-method! (proc <procedure>) (m <method>))
  (if (generic-capability? proc)
      (begin
	(enable-primitive-generic! proc)
	(add-method! proc m))
      (next-method)))

(define-method (add-method! (pg <primitive-generic>) (m <method>))
  (add-method! (primitive-generic-generic pg) m))

(define-method (add-method! obj (m <method>))
  (goops-error "~S is not a valid generic function" obj))

;;;
;;; {Access to meta objects}
;;;

;;;
;;; Methods
;;;
(define-method (method-source (m <method>))
  (let* ((spec (map* class-name (slot-ref m 'specializers)))
	 (proc (procedure-source (slot-ref m 'procedure)))
	 (args (cadr proc))
	 (body (cddr proc)))
    (cons 'method
	  (cons (map* list args spec)
		body))))

;;;
;;; Slots
;;;
(define slot-definition-name car)

(define slot-definition-options cdr)

(define (slot-definition-allocation s)
  (get-keyword #:allocation (cdr s) #:instance))

(define (slot-definition-getter s)
  (get-keyword #:getter (cdr s) #f))

(define (slot-definition-setter s)
  (get-keyword #:setter (cdr s) #f))

(define (slot-definition-accessor s)
  (get-keyword #:accessor (cdr s) #f))

(define (slot-definition-init-value s)
  ;; can be #f, so we can't use #f as non-value
  (get-keyword #:init-value (cdr s) (make-unbound)))

(define (slot-definition-init-form s)
  (get-keyword #:init-form (cdr s) (make-unbound)))

(define (slot-definition-init-thunk s)
  (get-keyword #:init-thunk (cdr s) #f))

(define (slot-definition-init-keyword s)
  (get-keyword #:init-keyword (cdr s) #f))

(define (class-slot-definition class slot-name)
  (assq slot-name (class-slots class)))

(define (slot-init-function class slot-name)
  (cadr (assq slot-name (slot-ref class 'getters-n-setters))))


;;;
;;; {Standard methods used by the C runtime}
;;;

;;; Methods to compare objects
;;;

(define-method (eqv? x y) #f)
(define-method (equal? x y) (eqv? x y))

;;; These following two methods are for backward compatibility only.
;;; They are not called by the Guile interpreter.
;;;
(define-method (object-eqv? x y)    #f)
(define-method (object-equal? x y)  (eqv? x y))

;;;
;;; methods to display/write an object
;;;

;     Code for writing objects must test that the slots they use are
;     bound. Otherwise a slot-unbound method will be called and will 
;     conduct to an infinite loop.

;; Write
(define (display-address o file)
  (display (number->string (object-address o) 16) file))

(define-method (write o file)
  (display "#<instance " file)
  (display-address o file)
  (display #\> file))

(define write-object (primitive-generic-generic write))

(define-method (write (o <object>) file)
  (let ((class (class-of o)))
    (if (slot-bound? class 'name)
	(begin
	  (display "#<" file)
	  (display (class-name class) file)
	  (display #\space file)
	  (display-address o file)
	  (display #\> file))
	(next-method))))

(define-method (write (o <foreign-object>) file)
  (let ((class (class-of o)))
    (if (slot-bound? class 'name)
	(begin
	  (display "#<foreign-object " file)
	  (display (class-name class) file)
	  (display #\space file)
	  (display-address o file)
	  (display #\> file))
	(next-method))))

(define-method (write (class <class>) file)
  (let ((meta (class-of class)))
    (if (and (slot-bound? class 'name)
	     (slot-bound? meta 'name))
	(begin
	  (display "#<" file)
	  (display (class-name meta) file)
	  (display #\space file)
	  (display (class-name class) file)
	  (display #\space file)
	  (display-address class file)
	  (display #\> file))
	(next-method))))

(define-method (write (gf <generic>) file)
  (let ((meta (class-of gf)))
    (if (and (slot-bound? meta 'name)
	     (slot-bound? gf 'methods))
	(begin
	  (display "#<" file)
	  (display (class-name meta) file)
	  (let ((name (generic-function-name gf)))
	    (if name
		(begin
		  (display #\space file)
		  (display name file))))
	  (display " (" file)
	  (display (length (generic-function-methods gf)) file)
	  (display ")>" file))
	(next-method))))

(define-method (write (o <method>) file)
  (let ((meta (class-of o)))
    (if (and (slot-bound? meta 'name)
	     (slot-bound? o 'specializers))
	(begin
	  (display "#<" file)
	  (display (class-name meta) file)
	  (display #\space file)
	  (display (map* (lambda (spec)
			   (if (slot-bound? spec 'name)
			       (slot-ref spec 'name)
			       spec))
			 (method-specializers o))
		   file)
	  (display #\space file)
	  (display-address o file)
	  (display #\> file))
	(next-method))))

;; Display (do the same thing as write by default)
(define-method (display o file) 
  (write-object o file))

;;;
;;; Handling of duplicate bindings in the module system
;;;

(define-method (merge-generics (module <module>)
			       (name <symbol>)
			       (int1 <module>)
			       (val1 <top>)
			       (int2 <module>)
			       (val2 <top>)
			       (var <top>)
			       (val <top>))
  #f)

(define-method (merge-generics (module <module>)
			       (name <symbol>)
			       (int1 <module>)
			       (val1 <generic>)
			       (int2 <module>)
			       (val2 <generic>)
			       (var <top>)
			       (val <boolean>))
  (and (not (eq? val1 val2))
       (make-variable (make-extended-generic (list val2 val1) name))))

(define-method (merge-generics (module <module>)
			       (name <symbol>)
			       (int1 <module>)
			       (val1 <generic>)
			       (int2 <module>)
			       (val2 <generic>)
			       (var <top>)
			       (gf <extended-generic>))
  (and (not (memq val2 (slot-ref gf 'extends)))
       (begin
	 (slot-set! gf
		    'extends
		    (cons val2 (delq! val2 (slot-ref gf 'extends))))
	 (slot-set! val2
		    'extended-by
		    (cons gf (delq! gf (slot-ref val2 'extended-by))))
	 var)))

(module-define! duplicate-handlers 'merge-generics merge-generics)

(define-method (merge-accessors (module <module>)
				(name <symbol>)
				(int1 <module>)
				(val1 <top>)
				(int2 <module>)
				(val2 <top>)
				(var <top>)
				(val <top>))
  #f)

(define-method (merge-accessors (module <module>)
				(name <symbol>)
				(int1 <module>)
				(val1 <accessor>)
				(int2 <module>)
				(val2 <accessor>)
				(var <top>)
				(val <top>))
  (merge-generics module name int1 val1 int2 val2 var val))

(module-define! duplicate-handlers 'merge-accessors merge-accessors)

;;;
;;; slot access
;;;

(define (class-slot-g-n-s class slot-name)
  (let* ((this-slot (assq slot-name (slot-ref class 'slots)))
	 (g-n-s (cddr (or (assq slot-name (slot-ref class 'getters-n-setters))
			  (slot-missing class slot-name)))))
    (if (not (memq (slot-definition-allocation this-slot)
		   '(#:class #:each-subclass)))
	(slot-missing class slot-name))
    g-n-s))

(define (class-slot-ref class slot)
  (let ((x ((car (class-slot-g-n-s class slot)) #f)))
    (if (unbound? x)
	(slot-unbound class slot)
	x)))

(define (class-slot-set! class slot value)
  ((cadr (class-slot-g-n-s class slot)) #f value))

(define-method (slot-unbound (c <class>) (o <object>) s)
  (goops-error "Slot `~S' is unbound in object ~S" s o))

(define-method (slot-unbound (c <class>) s)
  (goops-error "Slot `~S' is unbound in class ~S" s c))

(define-method (slot-unbound (o <object>))
  (goops-error "Unbound slot in object ~S" o))

(define-method (slot-missing (c <class>) (o <object>) s)
  (goops-error "No slot with name `~S' in object ~S" s o))
  
(define-method (slot-missing (c <class>) s)
  (goops-error "No class slot with name `~S' in class ~S" s c))
  

(define-method (slot-missing (c <class>) (o <object>) s value)
  (slot-missing c o s))

;;; Methods for the possible error we can encounter when calling a gf

(define-method (no-next-method (gf <generic>) args)
  (goops-error "No next method when calling ~S\nwith arguments ~S" gf args))

(define-method (no-applicable-method (gf <generic>) args)
  (goops-error "No applicable method for ~S in call ~S"
	       gf (cons (generic-function-name gf) args)))

(define-method (no-method (gf <generic>) args)
  (goops-error "No method defined for ~S"  gf))

;;;
;;; {Cloning functions (from rdeline@CS.CMU.EDU)}
;;;

(define-method (shallow-clone (self <object>))
  (let ((clone (%allocate-instance (class-of self) '()))
	(slots (map slot-definition-name
		    (class-slots (class-of self)))))
    (for-each (lambda (slot)
		(if (slot-bound? self slot)
		    (slot-set! clone slot (slot-ref self slot))))
	      slots)
    clone))

(define-method (deep-clone  (self <object>))
  (let ((clone (%allocate-instance (class-of self) '()))
	(slots (map slot-definition-name
		    (class-slots (class-of self)))))
    (for-each (lambda (slot)
		(if (slot-bound? self slot)
		    (slot-set! clone slot
			       (let ((value (slot-ref self slot)))
				 (if (instance? value)
				     (deep-clone value)
				     value)))))
	      slots)
    clone))

;;;
;;; {Class redefinition utilities}
;;;

;;; (class-redefinition OLD NEW)
;;;

;;; Has correct the following conditions:

;;; Methods
;;; 
;;; 1. New accessor specializers refer to new header
;;; 
;;; Classes
;;; 
;;; 1. New class cpl refers to the new class header
;;; 2. Old class header exists on old super classes direct-subclass lists
;;; 3. New class header exists on new super classes direct-subclass lists

(define-method (class-redefinition (old <class>) (new <class>))
  ;; Work on direct methods:
  ;;		1. Remove accessor methods from the old class 
  ;;		2. Patch the occurences of new in the specializers by old
  ;;		3. Displace the methods from old to new
  (remove-class-accessors! old)					;; -1-
  (let ((methods (class-direct-methods new)))
    (for-each (lambda (m)
     	         (update-direct-method! m new old))	;; -2-
              methods)
    (slot-set! new
	       'direct-methods
	       (append methods (class-direct-methods old))))

  ;; Substitute old for new in new cpl
  (set-car! (slot-ref new 'cpl) old)
  
  ;; Remove the old class from the direct-subclasses list of its super classes
  (for-each (lambda (c) (slot-set! c 'direct-subclasses
				   (delv! old (class-direct-subclasses c))))
	    (class-direct-supers old))

  ;; Replace the new class with the old in the direct-subclasses of the supers
  (for-each (lambda (c)
	      (slot-set! c 'direct-subclasses
			 (cons old (delv! new (class-direct-subclasses c)))))
	    (class-direct-supers new))

  ;; Swap object headers
  (%modify-class old new)

  ;; Now old is NEW!

  ;; Redefine all the subclasses of old to take into account modification
  (for-each 
       (lambda (c)
	 (update-direct-subclass! c new old))
       (class-direct-subclasses new))

  ;; Invalidate class so that subsequent instances slot accesses invoke
  ;; change-object-class
  (slot-set! new 'redefined old)
  (%invalidate-class new) ;must come after slot-set!

  old)

;;;
;;; remove-class-accessors!
;;;

(define-method (remove-class-accessors! (c <class>))
  (for-each (lambda (m)
	      (if (is-a? m <accessor-method>)
		  (let ((gf (slot-ref m 'generic-function)))
		    ;; remove the method from its GF
		    (slot-set! gf 'methods
			       (delq1! m (slot-ref gf 'methods)))
		    (%invalidate-method-cache! gf)
		    ;; remove the method from its specializers
		    (remove-method-in-classes! m))))
	    (class-direct-methods c)))

;;;
;;; update-direct-method!
;;;

(define-method (update-direct-method! (m  <method>)
				      (old <class>)
				      (new <class>))
  (let loop ((l (method-specializers m)))
    ;; Note: the <top> in dotted list is never used. 
    ;; So we can work as if we had only proper lists.
    (if (pair? l)       	  
	(begin
	  (if (eqv? (car l) old)  
	      (set-car! l new))
	  (loop (cdr l))))))

;;;
;;; update-direct-subclass!
;;;

(define-method (update-direct-subclass! (c <class>)
					(old <class>)
					(new <class>))
  (class-redefinition c
		      (make-class (class-direct-supers c)
				  (class-direct-slots c)
				  #:name (class-name c)
				  #:environment (slot-ref c 'environment)
				  #:metaclass (class-of c))))

;;;
;;; {Utilities for INITIALIZE methods}
;;;

;;; compute-slot-accessors
;;;
(define (compute-slot-accessors class slots env)
  (for-each
      (lambda (s g-n-s)
	(let ((name            (slot-definition-name     s))
	      (getter-function (slot-definition-getter   s))
	      (setter-function (slot-definition-setter   s))
	      (accessor        (slot-definition-accessor s)))
	  (if getter-function
	      (add-method! getter-function
			   (compute-getter-method class g-n-s)))
	  (if setter-function
	      (add-method! setter-function
			   (compute-setter-method class g-n-s)))
	  (if accessor
	      (begin
		(add-method! accessor
			     (compute-getter-method class g-n-s))
		(add-method! (setter accessor)
			     (compute-setter-method class g-n-s))))))
      slots (slot-ref class 'getters-n-setters)))

(define-method (compute-getter-method (class <class>) slotdef)
  (let ((init-thunk (cadr slotdef))
	(g-n-s (cddr slotdef)))
    (make <accessor-method>
          #:specializers (list class)
	  #:procedure (cond ((pair? g-n-s)
			     (make-generic-bound-check-getter (car g-n-s)))
			    (init-thunk
			     (standard-get g-n-s))
			    (else
			     (bound-check-get g-n-s)))
	  #:slot-definition slotdef)))

(define-method (compute-setter-method (class <class>) slotdef)
  (let ((g-n-s (cddr slotdef)))
    (make <accessor-method>
          #:specializers (list class <top>)
	  #:procedure (if (pair? g-n-s)
			  (cadr g-n-s)
			  (standard-set g-n-s))
	  #:slot-definition slotdef)))

(define (make-generic-bound-check-getter proc)
  (let ((source (and (closure? proc) (procedure-source proc))))
    (if (and source (null? (cdddr source)))
	(let ((obj (caadr source)))
	  ;; smart closure compilation
	  (local-eval
	   `(lambda (,obj) (,assert-bound ,(caddr source) ,obj))
	   (procedure-environment proc)))
	(lambda (o) (assert-bound (proc o) o)))))

(define n-standard-accessor-methods 10)

(define bound-check-get-methods (make-vector n-standard-accessor-methods #f))
(define standard-get-methods (make-vector n-standard-accessor-methods #f))
(define standard-set-methods (make-vector n-standard-accessor-methods #f))

(define (standard-accessor-method make methods)
  (lambda (index)
    (cond ((>= index n-standard-accessor-methods) (make index))
	  ((vector-ref methods index))
	  (else (let ((m (make index)))
		  (vector-set! methods index m)
		  m)))))

(define (make-bound-check-get index)
  (local-eval `(lambda (o) (@assert-bound-ref o ,index)) (the-environment)))

(define (make-get index)
  (local-eval `(lambda (o) (@slot-ref o ,index)) (the-environment)))

(define (make-set index)
  (local-eval `(lambda (o v) (@slot-set! o ,index v)) (the-environment)))

(define bound-check-get
  (standard-accessor-method make-bound-check-get bound-check-get-methods))
(define standard-get (standard-accessor-method make-get standard-get-methods))
(define standard-set (standard-accessor-method make-set standard-set-methods))

;;; compute-getters-n-setters
;;;
(define (make-thunk thunk)
  (lambda () (thunk)))

(define (compute-getters-n-setters class slots env)

  (define (compute-slot-init-function name s)
    (or (let ((thunk (slot-definition-init-thunk s)))
	  (and thunk
	       (cond ((not (thunk? thunk))
		      (goops-error "Bad init-thunk for slot `~S' in ~S: ~S"
				   name class thunk))
		     ((closure? thunk) thunk)
		     (else (make-thunk thunk)))))
	(let ((init (slot-definition-init-value s)))
	  (and (not (unbound? init))
	       (lambda () init)))))

  (define (verify-accessors slot l)
    (cond ((integer? l))
	  ((not (and (list? l) (= (length l) 2)))
	   (goops-error "Bad getter and setter for slot `~S' in ~S: ~S"
			slot class l))
	  (else
	   (let ((get (car l)) 
		 (set (cadr l)))
	     (if (not (and (closure? get)
			   (= (car (procedure-property get 'arity)) 1)))
		 (goops-error "Bad getter closure for slot `~S' in ~S: ~S"
			      slot class get))
	     (if (not (and (closure? set)
			   (= (car (procedure-property set 'arity)) 2)))
		 (goops-error "Bad setter closure for slot `~S' in ~S: ~S"
			      slot class set))))))

  (map (lambda (s)
	 ;; The strange treatment of nfields is due to backward compatibility.
	 (let* ((index (slot-ref class 'nfields))
		(g-n-s (compute-get-n-set class s))
		(size (- (slot-ref class 'nfields) index))
		(name  (slot-definition-name s)))
	   ;; NOTE: The following is interdependent with C macros
	   ;; defined above goops.c:scm_sys_prep_layout_x.
	   ;;
	   ;; For simple instance slots, we have the simplest form
	   ;; '(name init-function . index)
	   ;; For other slots we have
	   ;; '(name init-function getter setter . alloc)
	   ;; where alloc is:
	   ;;   '(index size) for instance allocated slots
	   ;;   '() for other slots
	   (verify-accessors name g-n-s)
	   (cons name
		 (cons (compute-slot-init-function name s)
		       (if (or (integer? g-n-s)
			       (zero? size))
			   g-n-s
			   (append g-n-s (list index size)))))))
       slots))

;;; compute-cpl
;;;
;;; Correct behaviour:
;;;
;;; (define-class food ())
;;; (define-class fruit (food))
;;; (define-class spice (food))
;;; (define-class apple (fruit))
;;; (define-class cinnamon (spice))
;;; (define-class pie (apple cinnamon))
;;; => cpl (pie) = pie apple fruit cinnamon spice food object top
;;;
;;; (define-class d ())
;;; (define-class e ())
;;; (define-class f ())
;;; (define-class b (d e))
;;; (define-class c (e f))
;;; (define-class a (b c))
;;; => cpl (a) = a b d c e f object top
;;;

(define-method (compute-cpl (class <class>))
  (compute-std-cpl class class-direct-supers))

;; Support

(define (only-non-null lst)
  (filter (lambda (l) (not (null? l))) lst))

(define (compute-std-cpl c get-direct-supers)
  (let ((c-direct-supers (get-direct-supers c)))
    (merge-lists (list c)
                 (only-non-null (append (map class-precedence-list
					     c-direct-supers)
                                        (list c-direct-supers))))))

(define (merge-lists reversed-partial-result inputs)
  (cond
   ((every null? inputs)
    (reverse! reversed-partial-result))
   (else
    (let* ((candidate (lambda (c)
                        (and (not (any (lambda (l)
                                         (memq c (cdr l)))
                                       inputs))
                             c)))
           (candidate-car (lambda (l)
                            (and (not (null? l))
                                 (candidate (car l)))))
           (next (any candidate-car inputs)))
      (if (not next)
          (goops-error "merge-lists: Inconsistent precedence graph"))
      (let ((remove-next (lambda (l)
                           (if (eq? (car l) next)
                               (cdr l)
                             l))))
        (merge-lists (cons next reversed-partial-result)
                     (only-non-null (map remove-next inputs))))))))

;; Modified from TinyClos:
;;
;; A simple topological sort.
;;
;; It's in this file so that both TinyClos and Objects can use it.
;;
;; This is a fairly modified version of code I originally got from Anurag
;; Mendhekar <anurag@moose.cs.indiana.edu>.
;;

(define (compute-clos-cpl c get-direct-supers)
  (top-sort ((build-transitive-closure get-direct-supers) c)
	    ((build-constraints get-direct-supers) c)
	    (std-tie-breaker get-direct-supers)))


(define (top-sort elements constraints tie-breaker)
  (let loop ((elements    elements)
	     (constraints constraints)
	     (result      '()))
    (if (null? elements)
	result
	(let ((can-go-in-now
	       (filter
		(lambda (x)
		  (every (lambda (constraint)
			   (or (not (eq? (cadr constraint) x))
			       (memq (car constraint) result)))
			 constraints))
		elements)))
	  (if (null? can-go-in-now)
	      (goops-error "top-sort: Invalid constraints")
	      (let ((choice (if (null? (cdr can-go-in-now))
				(car can-go-in-now)
				(tie-breaker result
					     can-go-in-now))))
		(loop
		 (filter (lambda (x) (not (eq? x choice)))
			 elements)
		 constraints
		 (append result (list choice)))))))))

(define (std-tie-breaker get-supers)
  (lambda (partial-cpl min-elts)
    (let loop ((pcpl (reverse partial-cpl)))
      (let ((current-elt (car pcpl)))
	(let ((ds-of-ce (get-supers current-elt)))
	  (let ((common (filter (lambda (x)
				      (memq x ds-of-ce))
				    min-elts)))
	    (if (null? common)
		(if (null? (cdr pcpl))
		    (goops-error "std-tie-breaker: Nothing valid")
		    (loop (cdr pcpl)))
		(car common))))))))


(define (build-transitive-closure get-follow-ons)
  (lambda (x)
    (let track ((result '())
		(pending (list x)))
      (if (null? pending)
	  result
	  (let ((next (car pending)))
	    (if (memq next result)
		(track result (cdr pending))
		(track (cons next result)
		       (append (get-follow-ons next)
			       (cdr pending)))))))))

(define (build-constraints get-follow-ons)
  (lambda (x)
    (let loop ((elements ((build-transitive-closure get-follow-ons) x))
	       (this-one '())
	       (result '()))
      (if (or (null? this-one) (null? (cdr this-one)))
	  (if (null? elements)
	      result
	      (loop (cdr elements)
		    (cons (car elements)
			  (get-follow-ons (car elements)))
		    result))
	  (loop elements
		(cdr this-one)
		(cons (list (car this-one) (cadr this-one))
		      result))))))

;;; compute-get-n-set
;;;
(define-method (compute-get-n-set (class <class>) s)
  (case (slot-definition-allocation s)
    ((#:instance) ;; Instance slot
     ;; get-n-set is just its offset
     (let ((already-allocated (slot-ref class 'nfields)))
       (slot-set! class 'nfields (+ already-allocated 1))
       already-allocated))

    ((#:class)  ;; Class slot
     ;; Class-slots accessors are implemented as 2 closures around 
     ;; a Scheme variable. As instance slots, class slots must be
     ;; unbound at init time.
     (let ((name (slot-definition-name s)))
       (if (memq name (map slot-definition-name (class-direct-slots class)))
	   ;; This slot is direct; create a new shared variable
	   (make-closure-variable class)
	   ;; Slot is inherited. Find its definition in superclass
	   (let loop ((l (cdr (class-precedence-list class))))
	     (let ((r (assoc name (slot-ref (car l) 'getters-n-setters))))
	       (if r
		   (cddr r)
		   (loop (cdr l))))))))

    ((#:each-subclass) ;; slot shared by instances of direct subclass.
     ;; (Thomas Buerger, April 1998)
     (make-closure-variable class))

    ((#:virtual) ;; No allocation
     ;; slot-ref and slot-set! function must be given by the user
     (let ((get (get-keyword #:slot-ref  (slot-definition-options s) #f))
	   (set (get-keyword #:slot-set! (slot-definition-options s) #f))
	   (env (class-environment class)))
       (if (not (and get set))
	   (goops-error "You must supply a #:slot-ref and a #:slot-set! in ~S"
			s))
       (list get set)))
    (else    (next-method))))

(define (make-closure-variable class)
  (let ((shared-variable (make-unbound)))
    (list (lambda (o) shared-variable)
	  (lambda (o v) (set! shared-variable v)))))

(define-method (compute-get-n-set (o <object>) s)
  (goops-error "Allocation \"~S\" is unknown" (slot-definition-allocation s)))

(define-method (compute-slots (class <class>))
  (%compute-slots class))

;;;
;;; {Initialize}
;;;

(define-method (initialize (object <object>) initargs)
  (%initialize-object object initargs))

(define-method (initialize (class <class>) initargs)
  (next-method)
  (let ((dslots (get-keyword #:slots initargs '()))
	(supers (get-keyword #:dsupers	  initargs '()))
	(env    (get-keyword #:environment initargs (top-level-env))))

    (slot-set! class 'name	  	(get-keyword #:name initargs '???))
    (slot-set! class 'direct-supers 	supers)
    (slot-set! class 'direct-slots  	dslots)
    (slot-set! class 'direct-subclasses '())
    (slot-set! class 'direct-methods    '())
    (slot-set! class 'cpl		(compute-cpl class))
    (slot-set! class 'redefined		#f)
    (slot-set! class 'environment	env)
    (let ((slots (compute-slots class)))
      (slot-set! class 'slots	  	  slots)
      (slot-set! class 'nfields	  	  0)
      (slot-set! class 'getters-n-setters (compute-getters-n-setters class 
								     slots 
								     env))
      ;; Build getters - setters - accessors
      (compute-slot-accessors class slots env))

    ;; Update the "direct-subclasses" of each inherited classes
    (for-each (lambda (x)
		(slot-set! x
			   'direct-subclasses 
			   (cons class (slot-ref x 'direct-subclasses))))
	      supers)

    ;; Support for the underlying structs:
    
    ;; Inherit class flags (invisible on scheme level) from supers
    (%inherit-magic! class supers)

    ;; Set the layout slot
    (%prep-layout! class)))

(define (initialize-object-procedure object initargs)
  (let ((proc (get-keyword #:procedure initargs #f)))
    (cond ((not proc))
	  ((pair? proc)
	   (apply set-object-procedure! object proc))
	  ((valid-object-procedure? proc)
	   (set-object-procedure! object proc))
	  (else
	   (set-object-procedure! object
				  (lambda args (apply proc args)))))))

(define-method (initialize (class <operator-class>) initargs)
  (next-method)
  (initialize-object-procedure class initargs))

(define-method (initialize (owsc <operator-with-setter-class>) initargs)
  (next-method)
  (%set-object-setter! owsc (get-keyword #:setter initargs #f)))

(define-method (initialize (entity <entity>) initargs)
  (next-method)
  (initialize-object-procedure entity initargs))

(define-method (initialize (ews <entity-with-setter>) initargs)
  (next-method)
  (%set-object-setter! ews (get-keyword #:setter initargs #f)))

(define-method (initialize (generic <generic>) initargs)
  (let ((previous-definition (get-keyword #:default initargs #f))
	(name (get-keyword #:name initargs #f)))
    (next-method)
    (slot-set! generic 'methods (if (is-a? previous-definition <procedure>)
				    (list (make <method>
						#:specializers <top>
						#:procedure
						(lambda l
						  (apply previous-definition 
							 l))))
				    '()))
    (if name
	(set-procedure-property! generic 'name name))
    ))

(define-method (initialize (eg <extended-generic>) initargs)
  (next-method)
  (slot-set! eg 'extends (get-keyword #:extends initargs '())))

(define dummy-procedure (lambda args *unspecified*))

(define-method (initialize (method <method>) initargs)
  (next-method)
  (slot-set! method 'generic-function (get-keyword #:generic-function initargs #f))
  (slot-set! method 'specializers (get-keyword #:specializers initargs '()))
  (slot-set! method 'procedure
	     (get-keyword #:procedure initargs dummy-procedure))
  (slot-set! method 'code-table '()))

(define-method (initialize (obj <foreign-object>) initargs))

;;;
;;; {Change-class}
;;;

(define (change-object-class old-instance old-class new-class)
  (let ((new-instance (allocate-instance new-class '())))
    ;; Initialize the slots of the new instance
    (for-each (lambda (slot)
		(if (and (slot-exists-using-class? old-class old-instance slot)
			 (eq? (slot-definition-allocation
			       (class-slot-definition old-class slot))
			      #:instance)
			 (slot-bound-using-class? old-class old-instance slot))
		    ;; Slot was present and allocated in old instance; copy it 
		    (slot-set-using-class!
		     new-class 
		     new-instance 
		     slot 
		     (slot-ref-using-class old-class old-instance slot))
		    ;; slot was absent; initialize it with its default value
		    (let ((init (slot-init-function new-class slot)))
		      (if init
			  (slot-set-using-class!
			       new-class 
			       new-instance 
			       slot
			       (apply init '()))))))
	      (map slot-definition-name (class-slots new-class)))
    ;; Exchange old and new instance in place to keep pointers valid
    (%modify-instance old-instance new-instance)
    ;; Allow class specific updates of instances (which now are swapped)
    (update-instance-for-different-class new-instance old-instance)
    old-instance))


(define-method (update-instance-for-different-class (old-instance <object>)
						    (new-instance
						     <object>))
  ;;not really important what we do, we just need a default method
  new-instance)

(define-method (change-class (old-instance <object>) (new-class <class>))
  (change-object-class old-instance (class-of old-instance) new-class))

;;;
;;; {make}
;;;
;;; A new definition which overwrites the previous one which was built-in
;;;

(define-method (allocate-instance (class <class>) initargs)
  (%allocate-instance class initargs))

(define-method (make-instance (class <class>) . initargs)
  (let ((instance (allocate-instance class initargs)))
    (initialize instance initargs)
    instance))

(define make make-instance)

;;;
;;; {apply-generic}
;;;
;;; Protocol for calling standard generic functions.  This protocol is
;;; not used for real <generic> functions (in this case we use a
;;; completely C hard-coded protocol).  Apply-generic is used by
;;; goops for calls to subclasses of <generic> and <generic-with-setter>.
;;; The code below is similar to the first MOP described in AMOP. In
;;; particular, it doesn't used the currified approach to gf
;;; call. There are 2 reasons for that:
;;;   - the protocol below is exposed to mimic completely the one written in C
;;;   - the currified protocol would be imho inefficient in C.
;;;

(define-method (apply-generic (gf <generic>) args)
  (if (null? (slot-ref gf 'methods))
      (no-method gf args))
  (let ((methods (compute-applicable-methods gf args)))
    (if methods
	(apply-methods gf (sort-applicable-methods gf methods args) args)
	(no-applicable-method gf args))))

;; compute-applicable-methods is bound to %compute-applicable-methods.
;; *fixme* use let
(define %%compute-applicable-methods
  (make <generic> #:name 'compute-applicable-methods))

(define-method (%%compute-applicable-methods (gf <generic>) args)
  (%compute-applicable-methods gf args))

(set! compute-applicable-methods %%compute-applicable-methods)

(define-method (sort-applicable-methods (gf <generic>) methods args)
  (let ((targs (map class-of args)))
    (sort methods (lambda (m1 m2) (method-more-specific? m1 m2 targs)))))

(define-method (method-more-specific? (m1 <method>) (m2 <method>) targs)
  (%method-more-specific? m1 m2 targs))

(define-method (apply-method (gf <generic>) methods build-next args)
  (apply (method-procedure (car methods))
	 (build-next (cdr methods) args)
	 args))

(define-method (apply-methods (gf <generic>) (l <list>) args)
  (letrec ((next (lambda (procs args)
		   (lambda new-args
		     (let ((a (if (null? new-args) args new-args)))
		       (if (null? procs)
			   (no-next-method gf a)
			   (apply-method gf procs next a)))))))
    (apply-method gf l next args)))

;; We don't want the following procedure to turn up in backtraces:
(for-each (lambda (proc)
	    (set-procedure-property! proc 'system-procedure #t))
	  (list slot-unbound
		slot-missing
		no-next-method
		no-applicable-method
		no-method
		))

;;;
;;; {<composite-metaclass> and <active-metaclass>}
;;;

;(autoload "active-slot"    <active-metaclass>)
;(autoload "composite-slot" <composite-metaclass>)
;(export <composite-metaclass> <active-metaclass>)

;;;
;;; {Tools}
;;;

;; list2set
;;
;; duplicate the standard list->set function but using eq instead of
;; eqv which really sucks a lot, uselessly here
;;
(define (list2set l)	       
  (let loop ((l l)
	     (res '()))
    (cond		       
     ((null? l) res)
     ((memq (car l) res) (loop (cdr l) res))
     (else (loop (cdr l) (cons (car l) res))))))

(define (class-subclasses c)
  (letrec ((allsubs (lambda (c)
		      (cons c (mapappend allsubs
					 (class-direct-subclasses c))))))
    (list2set (cdr (allsubs c)))))

(define (class-methods c)
  (list2set (mapappend class-direct-methods
		       (cons c (class-subclasses c)))))

;;;
;;; {Final initialization}
;;;

;; Tell C code that the main bulk of Goops has been loaded
(%goops-loaded)
