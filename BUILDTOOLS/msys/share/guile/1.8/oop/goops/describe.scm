;;; installed-scm-file

;;;; 	Copyright (C) 1998, 1999, 2001, 2006, 2008 Free Software Foundation, Inc.
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
;;;; This file is based upon describe.stklos from the STk distribution by
;;;; Erick Gallesio <eg@unice.fr>.
;;;;

(define-module (oop goops describe)
  :use-module (oop goops)
  :use-module (ice-9 session)
  :use-module (ice-9 format)
  :export (describe))			; Export the describe generic function

;;;
;;; describe for simple objects
;;;
(define-method (describe (x <top>))
  (format #t "~s is " x)
  (cond
     ((integer? x)      (format #t "an integer"))
     ((real?    x)      (format #t "a real"))
     ((complex? x)	(format #t "a complex number"))
     ((null?	x)      (format #t "an empty list"))
     ((boolean?	x)      (format #t "a boolean value (~s)" (if x 'true 'false)))
     ((char?	x)      (format #t "a character, ascii value is ~s" 
				(char->integer x)))
     ((symbol?	x)      (format #t "a symbol"))
     ((list?	x)	(format #t "a list"))
     ((pair?    x)	(if (pair? (cdr x))
			    (format #t "an improper list")
			    (format #t "a pair")))
     ((string?	x)	(if (eqv? x "")
			    (format #t "an empty string")
			    (format #t "a string of length ~s" (string-length x))))
     ((vector?  x)   	(if (eqv? x '#())
			    (format #t "an empty vector")
			    (format #t "a vector of length ~s" (vector-length x))))
     ((eof-object? x)	(format #t "the end-of-file object"))
     (else	     	(format #t "an unknown object (~s)" x)))
  (format #t ".~%")
  *unspecified*)

(define-method (describe (x <procedure>))
  (let ((name (procedure-name x)))
    (if name
	(format #t "`~s'" name)
	(display x))
    (display " is ")
    (display (if name #\a "an anonymous"))
    (display (cond ((closure? x) " procedure")
		   ((not (struct? x)) " primitive procedure")
		   ((entity? x) " entity")
		   (else " operator")))
    (display " with ")
    (arity x)))

;;;
;;; describe for GOOPS instances
;;;
(define (safe-class-name class)
  (if (slot-bound? class 'name)
      (class-name class)
      class))

(define-method (describe (x <object>))
  (format #t "~S is an instance of class ~A~%"
	  x (safe-class-name (class-of x)))

  ;; print all the instance slots
  (format #t "Slots are: ~%")
  (for-each (lambda (slot)
	      (let ((name (slot-definition-name slot)))
		(format #t "     ~S = ~A~%"
			name
			(if (slot-bound? x name) 
			    (format #f "~S" (slot-ref x name))
			    "#<unbound>"))))
	    (class-slots (class-of x)))
  *unspecified*)

;;;
;;; Describe for classes
;;;
(define-method (describe (x <class>))
  (format #t "~S is a class. It's an instance of ~A~%" 
	  (safe-class-name x) (safe-class-name (class-of x)))
  
  ;; Super classes 
  (format #t "Superclasses are:~%")
  (for-each (lambda (class) (format #t "    ~A~%" (safe-class-name class)))
       (class-direct-supers x))

  ;; Direct slots
  (let ((slots (class-direct-slots x)))
    (if (null? slots) 
	(format #t "(No direct slot)~%")
	(begin
	  (format #t "Directs slots are:~%")
	  (for-each (lambda (s) 
		      (format #t "    ~A~%" (slot-definition-name s)))
		    slots))))

 
  ;; Direct subclasses
  (let ((classes (class-direct-subclasses x)))
    (if (null? classes)
	(format #t "(No direct subclass)~%")
	(begin
	  (format #t "Directs subclasses are:~%") 
	  (for-each (lambda (s) 
		      (format #t "    ~A~%" (safe-class-name s)))
		    classes))))

  ;; CPL
  (format #t "Class Precedence List is:~%")
  (for-each (lambda (s) (format #t "    ~A~%" (safe-class-name s))) 
	    (class-precedence-list x))

  ;; Direct Methods
  (let ((methods (class-direct-methods x)))
    (if (null? methods)
	(format #t "(No direct method)~%")
	(begin
	  (format #t "Class direct methods are:~%")
	  (for-each describe methods))))

;  (format #t "~%Field Initializers ~%    ")
;  (write (slot-ref x 'initializers)) (newline)

;  (format #t "~%Getters and Setters~%    ")
;  (write (slot-ref x 'getters-n-setters)) (newline)
)

;;;
;;; Describe for generic functions
;;;
(define-method (describe (x <generic>))
  (let ((name    (generic-function-name x))
	(methods (generic-function-methods x)))
    ;; Title
    (format #t "~S is a generic function. It's an instance of ~A.~%" 
	    name (safe-class-name (class-of x)))
    ;; Methods
    (if (null? methods)
	(format #t "(No method defined for ~S)~%" name)
	(begin
	  (format #t "Methods defined for ~S~%" name)
	  (for-each (lambda (x) (describe x #t)) methods)))))

;;;
;;; Describe for methods
;;;
(define-method (describe (x <method>) . omit-generic)
  (letrec ((print-args (lambda (args)
			 ;; take care of dotted arg lists
			 (cond ((null? args) (newline))
			       ((pair? args)
				(display #\space)
				(display (safe-class-name (car args)))
				(print-args (cdr args)))
			       (else
				(display #\space)
				(display (safe-class-name args))
				(newline))))))

    ;; Title
    (format #t "    Method ~A~%" x)
    
    ;; Associated generic
    (if (null? omit-generic)
      (let ((gf (method-generic-function x)))
	(if gf
	    (format #t "\t     Generic: ~A~%" (generic-function-name gf))
	    (format #t "\t(No generic)~%"))))

    ;; GF specializers
    (format #t "\tSpecializers:")
    (print-args (method-specializers x))))

(provide 'describe)
