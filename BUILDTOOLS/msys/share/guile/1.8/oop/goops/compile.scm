;;;; 	Copyright (C) 1999, 2001, 2006 Free Software Foundation, Inc.
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


(define-module (oop goops compile)
  :use-module (oop goops)
  :use-module (oop goops util)
  :export (compute-cmethod compute-entry-with-cmethod
	   compile-method cmethod-code cmethod-environment)
  :no-backtrace
  )

(define source-formals cadr)
(define source-body cddr)

(define cmethod-code cdr)
(define cmethod-environment car)


;;;
;;; Method entries
;;;

(define code-table-lookup
  (letrec ((check-entry (lambda (entry types)
			  (if (null? types)
			      (and (not (struct? (car entry)))
				   entry)
			      (and (eq? (car entry) (car types))
				   (check-entry (cdr entry) (cdr types)))))))
    (lambda (code-table types)
      (cond ((null? code-table) #f)
	    ((check-entry (car code-table) types)
	     => (lambda (cmethod)
		  (cons (car code-table) cmethod)))
	    (else (code-table-lookup (cdr code-table) types))))))

(define (compute-entry-with-cmethod methods types)
  (or (code-table-lookup (slot-ref (car methods) 'code-table) types)
      (let* ((method (car methods))
	     (place-holder (list #f))
	     (entry (append types place-holder)))
	;; In order to handle recursion nicely, put the entry
	;; into the code-table before compiling the method 
	(slot-set! (car methods) 'code-table
		   (cons entry (slot-ref (car methods) 'code-table)))
	(let ((cmethod (compile-method methods types)))
	  (set-car! place-holder (car cmethod))
	  (set-cdr! place-holder (cdr cmethod)))
	(cons entry place-holder))))

(define (compute-cmethod methods types)
  (cdr (compute-entry-with-cmethod methods types)))

;;;
;;; Next methods
;;;

;;; Temporary solution---return #f if x doesn't refer to `next-method'.
(define (next-method? x)
  (and (pair? x)
       (or (eq? (car x) 'next-method)
	   (next-method? (car x))
	   (next-method? (cdr x)))))

(define (make-final-make-next-method method)
  (lambda default-args
    (lambda args
      (@apply method (if (null? args) default-args args)))))	  

(define (make-final-make-no-next-method gf)
  (lambda default-args
    (lambda args
      (no-next-method gf (if (null? args) default-args args)))))

(define (make-make-next-method vcell gf methods types)
  (lambda default-args
    (lambda args
      (if (null? methods)
	  (begin
	    (set-cdr! vcell (make-final-make-no-next-method gf))
	    (no-next-method gf (if (null? args) default-args args)))
	  (let* ((cmethod (compute-cmethod methods types))
		 (method (local-eval (cons 'lambda (cmethod-code cmethod))
				     (cmethod-environment cmethod))))
	    (set-cdr! vcell (make-final-make-next-method method))
	    (@apply method (if (null? args) default-args args)))))))

;;;
;;; Method compilation
;;;

;;; NOTE: This section is far from finished.  It will finally be
;;; implemented on C level.

(define %tag-body
  (nested-ref the-root-module '(app modules oop goops %tag-body)))

(define (compile-method methods types)
  (let* ((proc (method-procedure (car methods)))
	 ;; XXX - procedure-source can not be guaranteed to be
	 ;;       reliable or efficient
	 (src (procedure-source proc)) 
	 (formals (source-formals src))
	 (body (source-body src)))
    (if (next-method? body)
	(let ((vcell (cons 'goops:make-next-method #f)))
	  (set-cdr! vcell
		    (make-make-next-method
		     vcell
		     (method-generic-function (car methods))
		     (cdr methods) types))
	  ;;*fixme*
	  `(,(cons vcell (procedure-environment proc))
	    ,formals
	    ;;*fixme* Only do this on source where next-method can't be inlined
	    (let ((next-method ,(if (list? formals)
				    `(goops:make-next-method ,@formals)
				    `(apply goops:make-next-method
					    ,@(improper->proper formals)))))
	      ,@body)))
	(cons (procedure-environment proc)
	      (cons formals
		    (%tag-body body)))
	)))
