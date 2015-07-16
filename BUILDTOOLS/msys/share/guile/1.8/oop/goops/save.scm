;;; installed-scm-file

;;;; Copyright (C) 2000,2001,2002, 2006 Free Software Foundation, Inc.
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


(define-module (oop goops save)
  :use-module (oop goops internal)
  :use-module (oop goops util)
  :re-export (make-unbound)
  :export (save-objects load-objects restore
	   enumerate! enumerate-component!
	   write-readably write-component write-component-procedure
	   literal? readable make-readable))

;;;
;;; save-objects ALIST PORT [EXCLUDED] [USES]
;;;
;;; ALIST ::= ((NAME . OBJECT) ...)
;;;
;;; Save OBJECT ... to PORT so that when the data is read and evaluated
;;; OBJECT ... are re-created under names NAME ... .
;;; Exclude any references to objects in the list EXCLUDED.
;;; Add a (use-modules . USES) line to the top of the saved text.
;;;
;;; In some instances, when `save-object' doesn't know how to produce
;;; readable syntax for an object, you can explicitly register read
;;; syntax for an object using the special form `readable'.
;;;
;;; Example:
;;;
;;;   The function `foo' produces an object of obscure structure.
;;;   Only `foo' can construct such objects.  Because of this, an
;;;   object such as
;;;
;;;     (define x (vector 1 (foo)))
;;;
;;;   cannot be saved by `save-objects'.  But if you instead write
;;;
;;;     (define x (vector 1 (readable (foo))))
;;;
;;;   `save-objects' will happily produce the necessary read syntax.
;;;
;;; To add new read syntax, hang methods on `enumerate!' and
;;; `write-readably'.
;;;
;;; enumerate! OBJECT ENV
;;;   Should call `enumerate-component!' (which takes same args) on
;;;   each component object.  Should return #t if the composite object
;;;   can be written as a literal.  (`enumerate-component!' returns #t
;;;   if the component is a literal.
;;;
;;; write-readably OBJECT PORT ENV
;;;   Should write a readable representation of OBJECT to PORT.
;;;   Should use `write-component' to print each component object.
;;;   Use `literal?' to decide if a component is a literal.
;;;
;;; Utilities:
;;;
;;; enumerate-component! OBJECT ENV
;;;
;;; write-component OBJECT PATCHER PORT ENV
;;;   PATCHER is an expression which, when evaluated, stores OBJECT
;;;   into its current location.
;;;
;;;   Example:
;;;
;;;     (write-component (car ls) `(set-car! ,ls ,(car ls)) file env)
;;;
;;;   write-component is a macro.
;;;
;;; literal? COMPONENT ENV
;;;

(define-method (immediate? (o <top>)) #f)

(define-method (immediate? (o <null>)) #t)
(define-method (immediate? (o <number>)) #t)
(define-method (immediate? (o <boolean>)) #t)
(define-method (immediate? (o <symbol>)) #t)
(define-method (immediate? (o <char>)) #t)
(define-method (immediate? (o <keyword>)) #t)

;;; enumerate! OBJECT ENVIRONMENT
;;;
;;; Return #t if object is a literal.
;;;
(define-method (enumerate! (o <top>) env) #t)

(define-method (write-readably (o <top>) file env)
  ;;(goops-error "No read-syntax defined for object `~S'" o)
  (write o file) ;doesn't catch bugs, but is much more flexible
  )

;;;
;;; Readables
;;;

(if (or (not (defined? 'readables))
	(not readables))
    (define readables (make-weak-key-hash-table 61)))

(define readable
  (procedure->memoizing-macro
    (lambda (exp env)
      `(make-readable ,(cadr exp) ',(copy-tree (cadr exp))))))

(define (make-readable obj expr)
  (hashq-set! readables obj expr)
  obj)

(define (readable-expression obj)
  `(readable ,(hashq-ref readables obj)))

(define (readable? obj)
  (hashq-get-handle readables obj))

;;;
;;; Strings
;;;

(define-method (enumerate! (o <string>) env) #f)

;;;
;;; Vectors
;;;

(define-method (enumerate! (o <vector>) env)
  (or (not (vector? o))
      (let ((literal? #t))
	(array-for-each (lambda (o)
			  (if (not (enumerate-component! o env))
			      (set! literal? #f)))
			o)
	literal?)))

(define-method (write-readably (o <vector>) file env)
  (if (not (vector? o))
      (write o file)
      (let ((n (vector-length o)))
	(if (zero? n)
	    (display "#()" file)
	    (let ((not-literal? (not (literal? o env))))
	      (display (if not-literal?
			   "(vector "
			   "#(")
		       file)
	      (if (and not-literal?
		       (literal? (vector-ref o 0) env))
		  (display #\' file))
	      (write-component (vector-ref o 0)
			       `(vector-set! ,o 0 ,(vector-ref o 0))
			       file
			       env)
	      (do ((i 1 (+ 1 i)))
		  ((= i n))
		(display #\space file)
		(if (and not-literal?
			 (literal? (vector-ref o i) env))
		    (display #\' file))
		(write-component (vector-ref o i)
				 `(vector-set! ,o ,i ,(vector-ref o i))
				 file
				 env))
	      (display #\) file))))))


;;;
;;; Arrays
;;;

(define-method (enumerate! (o <array>) env)
  (enumerate-component! (shared-array-root o) env))

(define (make-mapper array)
  (let* ((dims (array-dimensions array))
	 (n (array-rank array))
	 (indices (reverse (if (<= n 11)
			       (list-tail '(t s r q p n m l k j i)  (- 11 n))
			       (let loop ((n n)
					  (ls '()))
				 (if (zero? n)
				     ls
				     (loop (- n 1)
					   (cons (gensym "i") ls))))))))
    `(lambda ,indices
       (+ ,(shared-array-offset array)
	  ,@(map (lambda (ind dim inc)
		   `(* ,inc ,(if (pair? dim) `(- ,ind ,(car dim)) ind)))
		 indices
		 (array-dimensions array)
		 (shared-array-increments array))))))

(define (write-array prefix o not-literal? file env)
  (letrec ((inner (lambda (n indices)
		    (if (not (zero? n))
			(let ((el (apply array-ref o
					 (reverse (cons 0 indices)))))
			  (if (and not-literal?
				   (literal? el env))
			      (display #\' file))
			  (write-component
			   el
			   `(array-set! ,o ,el ,@indices)
			   file
			   env)))
		    (do ((i 1 (+ 1 i)))
			((= i n))
		      (display #\space file)
		      (let ((el (apply array-ref o
					 (reverse (cons i indices)))))
			  (if (and not-literal?
				   (literal? el env))
			      (display #\' file))
			  (write-component
			   el
			   `(array-set! ,o ,el ,@indices)
			   file
			   env))))))
    (display prefix file)
    (let loop ((dims (array-dimensions o))
	       (indices '()))
      (cond ((null? (cdr dims))
	     (inner (car dims) indices))
	    (else
	     (let ((n (car dims)))
	       (do ((i 0 (+ 1 i)))
		   ((= i n))
		 (if (> i 0)
		     (display #\space file))
		 (display prefix file)
		 (loop (cdr dims) (cons i indices))
		 (display #\) file))))))
    (display #\) file)))

(define-method (write-readably (o <array>) file env)
  (let ((root (shared-array-root o)))
    (cond ((literal? o env)
	   (if (not (vector? root))
	       (write o file)
	       (begin
		 (display #\# file)
		 (display (array-rank o) file)
		 (write-array #\( o #f file env))))
	  ((binding? root env)
	   (display "(make-shared-array " file)
	   (if (literal? root env)
	       (display #\' file))
	   (write-component root
			    (goops-error "write-readably(<array>): internal error")
			    file
			    env)
	   (display #\space file)
	   (display (make-mapper o) file)
	   (for-each (lambda (dim)
		       (display #\space file)
		       (display dim file))
		     (array-dimensions o))
	   (display #\) file))
	  (else
	   (display "(list->uniform-array " file)
	   (display (array-rank o) file)
	   (display " '() " file)
	   (write-array "(list " o file env)))))

;;;
;;; Pairs
;;;

;;; These methods have more complex structure than is required for
;;; most objects, since they take over some of the logic of
;;; `write-component'.
;;;

(define-method (enumerate! (o <pair>) env)
  (let ((literal? (enumerate-component! (car o) env)))
    (and (enumerate-component! (cdr o) env)
	 literal?)))

(define-method (write-readably (o <pair>) file env)
  (let ((proper? (let loop ((ls o))
		   (or (null? ls)
		       (and (pair? ls)
			    (not (binding? (cdr ls) env))
			    (loop (cdr ls))))))
	(1? (or (not (pair? (cdr o)))
		(binding? (cdr o) env)))
	(not-literal? (not (literal? o env)))
	(infos '())
	(refs (ref-stack env)))
    (display (cond ((not not-literal?) #\()
		   (proper? "(list ")
		   (1? "(cons ")
		   (else "(cons* "))
	     file)
    (if (and not-literal?
	     (literal? (car o) env))
	(display #\' file))
    (write-component (car o) `(set-car! ,o ,(car o)) file env)
    (do ((ls (cdr o) (cdr ls))
	 (prev o ls))
	((or (not (pair? ls))
	     (binding? ls env))
	 (if (not (null? ls))
	     (begin
	       (if (not not-literal?)
		   (display " ." file))
	       (display #\space file)
	       (if (and not-literal?
			(literal? ls env))
		   (display #\' file))
	       (write-component ls `(set-cdr! ,prev ,ls) file env)))
	 (display #\) file))
      (display #\space file)
      (set! infos (cons (object-info ls env) infos))
      (push-ref! ls env) ;*fixme* optimize
      (set! (visiting? (car infos)) #t)
      (if (and not-literal?
	       (literal? (car ls) env))
	  (display #\' file))
      (write-component (car ls) `(set-car! ,ls ,(car ls)) file env)
      )
    (for-each (lambda (info)
		(set! (visiting? info) #f))
	      infos)
    (set! (ref-stack env) refs)
    ))

;;;
;;; Objects
;;;

;;; Doesn't yet handle unbound slots

;; Don't export this function!  This is all very temporary.
;;
(define (get-set-for-each proc class)
  (for-each (lambda (slotdef g-n-s)
	      (let ((g-n-s (cddr g-n-s)))
		(cond ((integer? g-n-s)
		       (proc (standard-get g-n-s) (standard-set g-n-s)))
		      ((not (memq (slot-definition-allocation slotdef)
				  '(#:class #:each-subclass)))
		       (proc (car g-n-s) (cadr g-n-s))))))
	    (class-slots class)
	    (slot-ref class 'getters-n-setters)))

(define (access-for-each proc class)
  (for-each (lambda (slotdef g-n-s)
	      (let ((g-n-s (cddr g-n-s))
		    (a (slot-definition-accessor slotdef)))
		(cond ((integer? g-n-s)
		       (proc (slot-definition-name slotdef)
			     (and a (generic-function-name a))
			     (standard-get g-n-s)
			     (standard-set g-n-s)))
		      ((not (memq (slot-definition-allocation slotdef)
				  '(#:class #:each-subclass)))
		       (proc (slot-definition-name slotdef)
			     (and a (generic-function-name a))
			     (car g-n-s)
			     (cadr g-n-s))))))
	    (class-slots class)
	    (slot-ref class 'getters-n-setters)))

(define restore
  (procedure->memoizing-macro
    (lambda (exp env)
      "(restore CLASS (SLOT-NAME1 ...) EXP1 ...)"
      `(let ((o (,%allocate-instance ,(cadr exp) '())))
	 (for-each (lambda (name val)
		     (,slot-set! o name val))
		   ',(caddr exp)
		   (list ,@(cdddr exp)))
	 o))))

(define-method (enumerate! (o <object>) env)
  (get-set-for-each (lambda (get set)
		      (let ((val (get o)))
			(if (not (unbound? val))
			    (enumerate-component! val env))))
		    (class-of o))
  #f)

(define-method (write-readably (o <object>) file env)
  (let ((class (class-of o)))
    (display "(restore " file)
    (display (class-name class) file)
    (display " (" file)
    (let ((slotdefs
	   (filter (lambda (slotdef)
		     (not (or (memq (slot-definition-allocation slotdef)
				    '(#:class #:each-subclass))
			      (and (slot-bound? o (slot-definition-name slotdef))
				   (excluded?
				    (slot-ref o (slot-definition-name slotdef))
				    env)))))
		   (class-slots class))))
      (if (not (null? slotdefs))
	  (begin
	    (display (slot-definition-name (car slotdefs)) file)
	    (for-each (lambda (slotdef)
			(display #\space file)
			(display (slot-definition-name slotdef) file))
		      (cdr slotdefs)))))
    (display #\) file)
    (access-for-each (lambda (name aname get set)
		       (display #\space file)
		       (let ((val (get o)))
			 (cond ((unbound? val)
				(display '(make-unbound) file))
			       ((excluded? val env))
			       (else
				(if (literal? val env)
				    (display #\' file))
				(write-component val
						 (if aname
						     `(set! (,aname ,o) ,val)
						     `(slot-set! ,o ',name ,val))
						 file env)))))
		     class)
    (display #\) file)))

;;;
;;; Classes
;;;

;;; Currently, we don't support reading in class objects
;;;

(define-method (enumerate! (o <class>) env) #f)

(define-method (write-readably (o <class>) file env)
  (display (class-name o) file))

;;;
;;; Generics
;;;

;;; Currently, we don't support reading in generic functions
;;;

(define-method (enumerate! (o <generic>) env) #f)

(define-method (write-readably (o <generic>) file env)
  (display (generic-function-name o) file))

;;;
;;; Method
;;;

;;; Currently, we don't support reading in methods
;;;

(define-method (enumerate! (o <method>) env) #f)

(define-method (write-readably (o <method>) file env)
  (goops-error "No read-syntax for <method> defined"))

;;;
;;; Environments
;;;

(define-class <environment> ()
  (object-info 	  #:accessor object-info
	       	  #:init-form (make-hash-table 61))
  (excluded	  #:accessor excluded
		  #:init-form (make-hash-table 61))
  (pass-2?	  #:accessor pass-2?
		  #:init-value #f)
  (ref-stack	  #:accessor ref-stack
		  #:init-value '())
  (objects	  #:accessor objects
		  #:init-value '())
  (pre-defines	  #:accessor pre-defines
		  #:init-value '())
  (locals	  #:accessor locals
		  #:init-value '())
  (stand-ins	  #:accessor stand-ins
		  #:init-value '())
  (post-defines	  #:accessor post-defines
		  #:init-value '())
  (patchers	  #:accessor patchers
		  #:init-value '())
  (multiple-bound #:accessor multiple-bound
		  #:init-value '())
  )

(define-method (initialize (env <environment>) initargs)
  (next-method)
  (cond ((get-keyword #:excluded initargs #f)
	 => (lambda (excludees)
	      (for-each (lambda (e)
			  (hashq-create-handle! (excluded env) e #f))
			excludees)))))

(define-method (object-info o env)
  (hashq-ref (object-info env) o))

(define-method ((setter object-info) o env x)
  (hashq-set! (object-info env) o x))

(define (excluded? o env)
  (hashq-get-handle (excluded env) o))

(define (add-patcher! patcher env)
  (set! (patchers env) (cons patcher (patchers env))))

(define (push-ref! o env)
  (set! (ref-stack env) (cons o (ref-stack env))))

(define (pop-ref! env)
  (set! (ref-stack env) (cdr (ref-stack env))))

(define (container env)
  (car (ref-stack env)))

(define-class <object-info> ()
  (visiting  #:accessor visiting
	     #:init-value #f)
  (binding   #:accessor binding
	     #:init-value #f)
  (literal?  #:accessor literal?
	     #:init-value #f)
  )

(define visiting? visiting)

(define-method (binding (info <boolean>))
  #f)

(define-method (binding o env)
  (binding (object-info o env)))

(define binding? binding)

(define-method (literal? (info <boolean>))
  #t)

;;; Note that this method is intended to be used only during the
;;; writing pass
;;;
(define-method (literal? o env)
  (or (immediate? o)
      (excluded? o env)
      (let ((info (object-info o env)))
	;; write-component sets all bindings first to #:defining,
	;; then to #:defined
	(and (or (not (binding? info))
		 ;; we might be using `literal?' in a write-readably method
		 ;; to query about the object being defined
		 (and (eq? (visiting info) #:defining)
		      (null? (cdr (ref-stack env)))))
	     (literal? info)))))

;;;
;;; Enumeration
;;;

;;; Enumeration has two passes.
;;;
;;; Pass 1: Detect common substructure, circular references and order
;;;
;;; Pass 2: Detect literals

(define (enumerate-component! o env)
  (cond ((immediate? o) #t)
	((readable? o) #f)
	((excluded? o env) #t)
	((pass-2? env)
	 (let ((info (object-info o env)))
	   (if (binding? info)
	       ;; if circular reference, we print as a literal
	       ;; (note that during pass-2, circular references are
	       ;;  forward references, i.e. *not* yet marked with #:pass-2
	       (not (eq? (visiting? info) #:pass-2))
	       (and (enumerate! o env)
		    (begin
		      (set! (literal? info) #t)
		      #t)))))
	((object-info o env)
	 => (lambda (info)
	      (set! (binding info) #t)
	      (if (visiting? info)
		  ;; circular reference--mark container
		  (set! (binding (object-info (container env) env)) #t))))
	(else
	 (let ((info (make <object-info>)))
	   (set! (object-info o env) info)
	   (push-ref! o env)
	   (set! (visiting? info) #t)
	   (enumerate! o env)
	   (set! (visiting? info) #f)
	   (pop-ref! env)
	   (set! (objects env) (cons o (objects env)))))))

(define (write-component-procedure o file env)
  "Return #f if circular reference"
  (cond ((immediate? o) (write o file) #t)
	((readable? o) (write (readable-expression o) file) #t)
	((excluded? o env) (display #f file) #t)
	(else
	 (let ((info (object-info o env)))
	   (cond ((not (binding? info)) (write-readably o file env) #t)
		 ((not (eq? (visiting info) #:defined)) #f) ;forward reference
		 (else (display (binding info) file) #t))))))

;;; write-component OBJECT PATCHER FILE ENV
;;;
(define write-component
  (procedure->memoizing-macro
    (lambda (exp env)
      `(or (write-component-procedure ,(cadr exp) ,@(cdddr exp))
	   (begin
	     (display #f ,(cadddr exp))
	     (add-patcher! ,(caddr exp) env))))))

;;;
;;; Main engine
;;;

(define binding-name car)
(define binding-object cdr)

(define (pass-1! alist env)
  ;; Determine object order and necessary bindings
  (for-each (lambda (binding)
	      (enumerate-component! (binding-object binding) env))
	    alist))

(define (make-local i)
  (string->symbol (string-append "%o" (number->string i))))

(define (name-bindings! alist env)
  ;; Name top-level bindings
  (for-each (lambda (b)
	      (let ((o (binding-object b)))
		(if (not (or (immediate? o)
			     (readable? o)
			     (excluded? o env)))
		    (let ((info (object-info o env)))
		      (if (symbol? (binding info))
			  ;; already bound to a variable
			  (set! (multiple-bound env)
				(acons (binding info)
				       (binding-name b)
				       (multiple-bound env)))
			  (set! (binding info)
				(binding-name b)))))))
	    alist)
  ;; Name rest of bindings and create stand-in and definition lists
  (let post-loop ((ls (objects env))
		  (post-defs '()))
    (cond ((or (null? ls)
	       (eq? (binding (car ls) env) #t))
	   (set! (post-defines env) post-defs)
	   (set! (objects env) ls))
	  ((not (binding (car ls) env))
	   (post-loop (cdr ls) post-defs))
	  (else
	   (post-loop (cdr ls) (cons (car ls) post-defs)))))
  (let pre-loop ((ls (reverse (objects env)))
		 (i 0)
		 (pre-defs '())
		 (locs '())
		 (sins '()))
    (if (null? ls)
	(begin
	  (set! (pre-defines env) (reverse pre-defs))
	  (set! (locals env) (reverse locs))
	  (set! (stand-ins env) (reverse sins)))
	(let ((info (object-info (car ls) env)))
	  (cond ((not (binding? info))
		 (pre-loop (cdr ls) i pre-defs locs sins))
		((boolean? (binding info))
		 ;; local
		 (set! (binding info) (make-local i))
		 (pre-loop (cdr ls)
			   (+ 1 i)
			   pre-defs
			   (cons (car ls) locs)
			   sins))
		((null? locs)
		 (pre-loop (cdr ls)
			   i
			   (cons (car ls) pre-defs)
			   locs
			   sins))
		(else
		 (let ((real-name (binding info)))
		   (set! (binding info) (make-local i))
		   (pre-loop (cdr ls)
			     (+ 1 i)
			     pre-defs
			     (cons (car ls) locs)
			     (acons (binding info) real-name sins)))))))))

(define (pass-2! env)
  (set! (pass-2? env) #t)
  (for-each (lambda (o)
	      (let ((info (object-info o env)))
		(set! (literal? info) (enumerate! o env))
		(set! (visiting info) #:pass-2)))
	    (append (pre-defines env)
		    (locals env)
		    (post-defines env))))

(define (write-define! name val literal? file)
  (display "(define " file)
  (display name file)
  (display #\space file)
  (if literal? (display #\' file))
  (write val file)
  (display ")\n" file))

(define (write-empty-defines! file env)
  (for-each (lambda (stand-in)
	      (write-define! (cdr stand-in) #f #f file))
	    (stand-ins env))
  (for-each (lambda (o)
	      (write-define! (binding o env) #f #f file))
	    (post-defines env)))

(define (write-definition! prefix o file env)
  (display prefix file)
  (let ((info (object-info o env)))
    (display (binding info) file)
    (display #\space file)
    (if (literal? info)
	(display #\' file))
    (push-ref! o env)
    (set! (visiting info) #:defining)
    (write-readably o file env)
    (set! (visiting info) #:defined)
    (pop-ref! env)
    (display #\) file)))

(define (write-let*-head! file env)
  (display "(let* (" file)
  (write-definition! "(" (car (locals env)) file env)
  (for-each (lambda (o)
	      (write-definition! "\n       (" o file env))
	    (cdr (locals env)))
  (display ")\n" file))

(define (write-rebindings! prefix bindings file env)
  (for-each (lambda (patch)
	      (display prefix file)
	      (display (cdr patch) file)
	      (display #\space file)
	      (display (car patch) file)
	      (display ")\n" file))
	    bindings))

(define (write-definitions! selector prefix file env)
  (for-each (lambda (o)
	      (write-definition! prefix o file env)
	      (newline file))
	    (selector env)))

(define (write-patches! prefix file env)
  (for-each (lambda (patch)
	      (display prefix file)
	      (display (let name-objects ((patcher patch))
			 (cond ((binding patcher env)
				=> (lambda (name)
				     (cond ((assq name (stand-ins env))
					    => cdr)
					   (else name))))
			       ((pair? patcher)
				(cons (name-objects (car patcher))
				      (name-objects (cdr patcher))))
			       (else patcher)))
		       file)
	      (newline file))
	    (reverse (patchers env))))

(define (write-immediates! alist file)
  (for-each (lambda (b)
	      (if (immediate? (binding-object b))
		  (write-define! (binding-name b)
				 (binding-object b)
				 #t
				 file)))
	    alist))

(define (write-readables! alist file env)
  (let ((written '()))
    (for-each (lambda (b)
		(cond ((not (readable? (binding-object b))))
		      ((assq (binding-object b) written)
		       => (lambda (p)
			    (set! (multiple-bound env)
				  (acons (cdr p)
					 (binding-name b)
					 (multiple-bound env)))))
		      (else
		       (write-define! (binding-name b)
				      (readable-expression (binding-object b))
				      #f
				      file)
		       (set! written (acons (binding-object b)
					    (binding-name b)
					    written)))))
	      alist)))

(define-method (save-objects (alist <pair>) (file <string>) . rest)
  (let ((port (open-output-file file)))
    (apply save-objects alist port rest)
    (close-port port)
    *unspecified*))

(define-method (save-objects (alist <pair>) (file <output-port>) . rest)
  (let ((excluded (if (>= (length rest) 1) (car rest) '()))
	(uses     (if (>= (length rest) 2) (cadr rest) '())))
    (let ((env (make <environment> #:excluded excluded)))
      (pass-1! alist env)
      (name-bindings! alist env)
      (pass-2! env)
      (if (not (null? uses))
	  (begin
	    (write `(use-modules ,@uses) file)
	    (newline file)))
      (write-immediates! alist file)
      (if (null? (locals env))
	  (begin
	    (write-definitions! post-defines "(define " file env)
	    (write-patches! "" file env))
	  (begin
	    (write-definitions! pre-defines "(define " file env)
	    (write-empty-defines! file env)
	    (write-let*-head! file env)
	    (write-rebindings! "  (set! " (stand-ins env) file env)
	    (write-definitions! post-defines "  (set! " file env)
	    (write-patches! "  " file env)
	    (display "  )\n" file)))
      (write-readables! alist file env)
      (write-rebindings! "(define " (reverse (multiple-bound env)) file env))))

(define-method (load-objects (file <string>))
  (let* ((port (open-input-file file))
	 (objects (load-objects port)))
    (close-port port)
    objects))

(define-method (load-objects (file <input-port>))
  (let ((m (make-module)))
    (module-use! m the-scm-module)
    (module-use! m %module-public-interface)
    (save-module-excursion
     (lambda ()
       (set-current-module m)
       (let loop ((sexp (read file)))
	 (if (not (eof-object? sexp))
	     (begin
	       (eval sexp m)
	       (loop (read file)))))))
    (module-map (lambda (name var)
		  (cons name (variable-ref var)))
		m)))
