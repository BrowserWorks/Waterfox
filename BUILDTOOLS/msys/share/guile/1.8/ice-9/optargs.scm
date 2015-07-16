;;;; optargs.scm -- support for optional arguments
;;;;
;;;; 	Copyright (C) 1997, 1998, 1999, 2001, 2002, 2004, 2006 Free Software Foundation, Inc.
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
;;;; Contributed by Maciej Stachowiak <mstachow@alum.mit.edu>



;;; Commentary:

;;; {Optional Arguments}
;;;
;;; The C interface for creating Guile procedures has a very handy
;;; "optional argument" feature. This module attempts to provide
;;; similar functionality for procedures defined in Scheme with
;;; a convenient and attractive syntax.
;;;
;;; exported macros are:
;;;   let-optional
;;;   let-optional*
;;;   let-keywords
;;;   let-keywords*
;;;   lambda*
;;;   define*
;;;   define*-public
;;;   defmacro*
;;;   defmacro*-public
;;;
;;;
;;; Summary of the lambda* extended parameter list syntax (brackets
;;; are used to indicate grouping only):
;;;
;;; ext-param-list ::= [identifier]* [#:optional [ext-var-decl]+]?
;;;   [#:key [ext-var-decl]+ [#:allow-other-keys]?]?
;;;   [[#:rest identifier]|[. identifier]]?
;;;
;;; ext-var-decl ::= identifier | ( identifier expression )
;;;
;;; The characters `*', `+' and `?' are not to be taken literally; they
;;; mean respectively, zero or more occurences, one or more occurences,
;;; and one or zero occurences.
;;;

;;; Code:

(define-module (ice-9 optargs)
  :export-syntax (let-optional
		  let-optional*
		  let-keywords
		  let-keywords*
		  define* lambda*
		  define*-public
		  defmacro*
		  defmacro*-public))

;; let-optional rest-arg (binding ...) . body
;; let-optional* rest-arg (binding ...) . body
;;   macros used to bind optional arguments
;;
;; These two macros give you an optional argument interface that is
;; very "Schemey" and introduces no fancy syntax. They are compatible
;; with the scsh macros of the same name, but are slightly
;; extended. Each of binding may be of one of the forms <var> or
;; (<var> <default-value>). rest-arg should be the rest-argument of
;; the procedures these are used from. The items in rest-arg are
;; sequentially bound to the variable namess are given. When rest-arg
;; runs out, the remaining vars are bound either to the default values
;; or to `#f' if no default value was specified. rest-arg remains
;; bound to whatever may have been left of rest-arg.
;;

(defmacro let-optional (REST-ARG BINDINGS . BODY)
  (let-optional-template REST-ARG BINDINGS BODY 'let))

(defmacro let-optional* (REST-ARG BINDINGS . BODY)
  (let-optional-template REST-ARG BINDINGS BODY 'let*))



;; let-keywords rest-arg allow-other-keys? (binding ...) . body
;; let-keywords* rest-arg allow-other-keys? (binding ...) . body
;;   macros used to bind keyword arguments
;;
;; These macros pick out keyword arguments from rest-arg, but do not
;; modify it. This is consistent at least with Common Lisp, which
;; duplicates keyword args in the rest arg. More explanation of what
;; keyword arguments in a lambda list look like can be found below in
;; the documentation for lambda*.  Bindings can have the same form as
;; for let-optional. If allow-other-keys? is false, an error will be
;; thrown if anything that looks like a keyword argument but does not
;; match a known keyword parameter will result in an error.
;;


(defmacro let-keywords (REST-ARG ALLOW-OTHER-KEYS? BINDINGS . BODY)
  (let-keywords-template REST-ARG ALLOW-OTHER-KEYS? BINDINGS BODY 'let))

(defmacro let-keywords* (REST-ARG ALLOW-OTHER-KEYS? BINDINGS . BODY)
  (let-keywords-template REST-ARG ALLOW-OTHER-KEYS? BINDINGS BODY 'let*))


;; some utility procedures for implementing the various let-forms.

(define (let-o-k-template REST-ARG BINDINGS BODY let-type proc)
  (let ((bindings (map (lambda (x)
			 (if (list? x)
			     x
			     (list x #f)))
		       BINDINGS)))
    `(,let-type ,(map proc bindings) ,@BODY)))

(define (let-optional-template REST-ARG BINDINGS BODY let-type)
    (if (null? BINDINGS)
	`(let () ,@BODY)
	(let-o-k-template REST-ARG BINDINGS BODY let-type
			  (lambda (optional)
			    `(,(car optional)
			      (cond
			       ((not (null? ,REST-ARG))
				(let ((result (car ,REST-ARG)))
				  ,(list 'set! REST-ARG
					 `(cdr ,REST-ARG))
				  result))
			       (else
				,(cadr optional))))))))

(define (let-keywords-template REST-ARG ALLOW-OTHER-KEYS? BINDINGS BODY let-type)
    (if (null? BINDINGS)
	`(let () ,@BODY)
	(let* ((kb-list-gensym (gensym "kb:G"))
	       (bindfilter (lambda (key)
			     `(,(car key)
			       (cond
				((assq ',(car key) ,kb-list-gensym)
				 => cdr)
				(else
				 ,(cadr key)))))))
	  `(let* ((ra->kbl ,rest-arg->keyword-binding-list)
		  (,kb-list-gensym (ra->kbl ,REST-ARG ',(map
							 (lambda (x) (symbol->keyword (if (pair? x) (car x) x)))
							 BINDINGS)
					    ,ALLOW-OTHER-KEYS?)))
	     ,(let-o-k-template REST-ARG BINDINGS BODY let-type bindfilter)))))


(define (rest-arg->keyword-binding-list rest-arg keywords allow-other-keys?)
  (if (null? rest-arg)
      '()
      (let loop ((first (car rest-arg))
		 (rest (cdr rest-arg))
		 (accum '()))
	(let ((next (lambda (a)
		      (if (null? (cdr rest))
			  a
			  (loop (cadr rest) (cddr rest) a)))))
	  (if (keyword? first)
	      (cond
	       ((memq first keywords)
		(if (null? rest)
		    (error "Keyword argument has no value.")
		    (next (cons (cons (keyword->symbol first)
				      (car rest)) accum))))
	       ((not allow-other-keys?)
		(error "Unknown keyword in arguments."))
	       (else (if (null? rest)
			 accum
			 (next accum))))
	      (if (null? rest)
		  accum
		  (loop (car rest) (cdr rest) accum)))))))


;; lambda* args . body
;;   lambda extended for optional and keyword arguments
;;
;; lambda* creates a procedure that takes optional arguments. These
;; are specified by putting them inside brackets at the end of the
;; paramater list, but before any dotted rest argument. For example,
;;   (lambda* (a b #:optional c d . e) '())
;; creates a procedure with fixed arguments a and b, optional arguments c
;; and d, and rest argument e. If the optional arguments are omitted
;; in a call, the variables for them are bound to `#f'.
;;
;; lambda* can also take keyword arguments. For example, a procedure
;; defined like this:
;;   (lambda* (#:key xyzzy larch) '())
;; can be called with any of the argument lists (#:xyzzy 11)
;; (#:larch 13) (#:larch 42 #:xyzzy 19) (). Whichever arguments
;; are given as keywords are bound to values.
;;
;; Optional and keyword arguments can also be given default values
;; which they take on when they are not present in a call, by giving a
;; two-item list in place of an optional argument, for example in:
;;   (lambda* (foo #:optional (bar 42) #:key (baz 73)) (list foo bar baz))
;; foo is a fixed argument, bar is an optional argument with default
;; value 42, and baz is a keyword argument with default value 73.
;; Default value expressions are not evaluated unless they are needed
;; and until the procedure is called.
;;
;; lambda* now supports two more special parameter list keywords.
;;
;; lambda*-defined procedures now throw an error by default if a
;; keyword other than one of those specified is found in the actual
;; passed arguments. However, specifying #:allow-other-keys
;; immediately after the keyword argument declarations restores the
;; previous behavior of ignoring unknown keywords. lambda* also now
;; guarantees that if the same keyword is passed more than once, the
;; last one passed is the one that takes effect. For example,
;;   ((lambda* (#:key (heads 0) (tails 0)) (display (list heads tails)))
;;    #:heads 37 #:tails 42 #:heads 99)
;; would result in (99 47) being displayed.
;;
;; #:rest is also now provided as a synonym for the dotted syntax rest
;; argument. The argument lists (a . b) and (a #:rest b) are equivalent in
;; all respects to lambda*. This is provided for more similarity to DSSSL,
;; MIT-Scheme and Kawa among others, as well as for refugees from other
;; Lisp dialects.


(defmacro lambda* (ARGLIST . BODY)
  (parse-arglist
   ARGLIST
   (lambda (non-optional-args optionals keys aok? rest-arg)
     ;; Check for syntax errors.
     (if (not (every? symbol? non-optional-args))
	 (error "Syntax error in fixed argument declaration."))
     (if (not (every? ext-decl? optionals))
	 (error "Syntax error in optional argument declaration."))
     (if (not (every? ext-decl? keys))
	 (error "Syntax error in keyword argument declaration."))
     (if (not (or (symbol? rest-arg) (eq? #f rest-arg)))
	 (error "Syntax error in rest argument declaration."))
     ;; generate the code.
     (let ((rest-gensym (or rest-arg (gensym "lambda*:G")))
	   (lambda-gensym (gensym "lambda*:L")))
       (if (not (and (null? optionals) (null? keys)))
	   `(let ((,lambda-gensym
		   (lambda (,@non-optional-args . ,rest-gensym)
		     ;; Make sure that if the proc had a docstring, we put it
		     ;; here where it will be visible.
		     ,@(if (and (not (null? BODY))
				(string? (car BODY)))
			   (list (car BODY))
			   '())
		     (let-optional*
		      ,rest-gensym
		      ,optionals
		      (let-keywords* ,rest-gensym
				     ,aok?
				     ,keys
				     ,@(if (and (not rest-arg) (null? keys))
					   `((if (not (null? ,rest-gensym))
						 (error "Too many arguments.")))
					   '())
				     (let ()
				       ,@BODY))))))
	      (set-procedure-property! ,lambda-gensym 'arglist
				       '(,non-optional-args
					 ,optionals
					 ,keys
					 ,aok?
					 ,rest-arg))
	      ,lambda-gensym)
	   `(lambda (,@non-optional-args . ,(if rest-arg rest-arg '()))
	      ,@BODY))))))


(define (every? pred lst)
  (or (null? lst)
      (and (pred (car lst))
	   (every? pred (cdr lst)))))

(define (ext-decl? obj)
  (or (symbol? obj)
      (and (list? obj) (= 2 (length obj)) (symbol? (car obj)))))

;; XXX - not tail recursive
(define (improper-list-copy obj)
  (if (pair? obj)
      (cons (car obj) (improper-list-copy (cdr obj)))
      obj))

(define (parse-arglist arglist cont)
  (define (split-list-at val lst cont)
    (cond
     ((memq val lst)
      => (lambda (pos)
	   (if (memq val (cdr pos))
	       (error (with-output-to-string
			(lambda ()
			  (map display `(,val
					 " specified more than once in argument list.")))))
	       (cont (reverse (cdr (memq val (reverse lst)))) (cdr pos) #t))))
     (else (cont lst '() #f))))
  (define (parse-opt-and-fixed arglist keys aok? rest cont)
    (split-list-at
     #:optional arglist
     (lambda (before after split?)
       (if (and split? (null? after))
	   (error "#:optional specified but no optional arguments declared.")
	   (cont before after keys aok? rest)))))
  (define (parse-keys arglist rest cont)
    (split-list-at
     #:allow-other-keys arglist
     (lambda (aok-before aok-after aok-split?)
       (if (and aok-split? (not (null? aok-after)))
	   (error "#:allow-other-keys not at end of keyword argument declarations.")
	   (split-list-at
	    #:key aok-before
	    (lambda (key-before key-after key-split?)
	      (cond
	       ((and aok-split? (not key-split?))
		(error "#:allow-other-keys specified but no keyword arguments declared."))
	       (key-split?
		(cond
		 ((null? key-after) (error "#:key specified but no keyword arguments declared."))
		 ((memq #:optional key-after) (error "#:optional arguments declared after #:key arguments."))
		 (else (parse-opt-and-fixed key-before key-after aok-split? rest cont))))
	       (else (parse-opt-and-fixed arglist '() #f rest cont)))))))))
  (define (parse-rest arglist cont)
    (cond
     ((null? arglist) (cont '() '() '() #f #f))
     ((not (pair? arglist)) (cont '() '() '() #f arglist))
     ((not (list? arglist))
	  (let* ((copy (improper-list-copy arglist))
		 (lp (last-pair copy))
		 (ra (cdr lp)))
	    (set-cdr! lp '())
	    (if (memq #:rest copy)
		(error "Cannot specify both #:rest and dotted rest argument.")
		(parse-keys copy ra cont))))
     (else (split-list-at
	    #:rest arglist
	    (lambda (before after split?)
	      (if split?
		  (case (length after)
		    ((0) (error "#:rest not followed by argument."))
		    ((1) (parse-keys before (car after) cont))
		    (else (error "#:rest argument must be declared last.")))
		  (parse-keys before #f cont)))))))

  (parse-rest arglist cont))



;; define* args . body
;; define*-public args . body
;;   define and define-public extended for optional and keyword arguments
;;
;; define* and define*-public support optional arguments with
;; a similar syntax to lambda*. They also support arbitrary-depth
;; currying, just like Guile's define. Some examples:
;;   (define* (x y #:optional a (z 3) #:key w . u) (display (list y z u)))
;; defines a procedure x with a fixed argument y, an optional agument
;; a, another optional argument z with default value 3, a keyword argument w,
;; and a rest argument u.
;;   (define-public* ((foo #:optional bar) #:optional baz) '())
;; This illustrates currying. A procedure foo is defined, which,
;; when called with an optional argument bar, returns a procedure that
;; takes an optional argument baz.
;;
;; Of course, define*[-public] also supports #:rest and #:allow-other-keys
;; in the same way as lambda*.

(defmacro define* (ARGLIST . BODY)
  (define*-guts 'define ARGLIST BODY))

(defmacro define*-public (ARGLIST . BODY)
  (define*-guts 'define-public ARGLIST BODY))

;; The guts of define* and define*-public.
(define (define*-guts DT ARGLIST BODY)
  (define (nest-lambda*s arglists)
    (if (null? arglists)
        BODY
        `((lambda* ,(car arglists) ,@(nest-lambda*s (cdr arglists))))))
  (define (define*-guts-helper ARGLIST arglists)
    (let ((first (car ARGLIST))
	  (al (cons (cdr ARGLIST) arglists)))
      (if (symbol? first)
	  `(,DT ,first ,@(nest-lambda*s al))
	  (define*-guts-helper first al))))
  (if (symbol? ARGLIST)
      `(,DT ,ARGLIST ,@BODY)
      (define*-guts-helper ARGLIST '())))



;; defmacro* name args . body
;; defmacro*-public args . body
;;   defmacro and defmacro-public extended for optional and keyword arguments
;;
;; These are just like defmacro and defmacro-public except that they
;; take lambda*-style extended paramter lists, where #:optional,
;; #:key, #:allow-other-keys and #:rest are allowed with the usual
;; semantics. Here is an example of a macro with an optional argument:
;;   (defmacro* transmorgify (a #:optional b)

(defmacro defmacro* (NAME ARGLIST . BODY)
  (defmacro*-guts 'define NAME ARGLIST BODY))

(defmacro defmacro*-public (NAME ARGLIST . BODY)
  (defmacro*-guts 'define-public NAME ARGLIST BODY))

;; The guts of defmacro* and defmacro*-public
(define (defmacro*-guts DT NAME ARGLIST BODY)
  `(,DT ,NAME
	(,(lambda (transformer) (defmacro:transformer transformer))
	 (lambda* ,ARGLIST ,@BODY))))

;;; optargs.scm ends here
