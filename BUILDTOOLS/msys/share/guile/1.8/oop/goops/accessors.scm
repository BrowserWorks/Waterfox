;;;; 	Copyright (C) 1999, 2000, 2005, 2006 Free Software Foundation, Inc.
;;;; 
;;;; This program is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation; either version 2, or (at your option)
;;;; any later version.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this software; see the file COPYING.  If not, write to
;;;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;;;; Boston, MA 02110-1301 USA
;;;; 


(define-module (oop goops accessors)
  :use-module (oop goops)
  :re-export (standard-define-class)
  :export (define-class-with-accessors
	   define-class-with-accessors-keywords))

(define define-class-with-accessors
  (procedure->memoizing-macro
   (lambda (exp env)
     (let ((name (cadr exp))
	   (supers (caddr exp))
	   (slots (cdddr exp))
	   (eat? #f))
       `(standard-define-class ,name ,supers
	  ,@(map-in-order
	     (lambda (slot)
	       (cond (eat?
		      (set! eat? #f)
		      slot)
		     ((keyword? slot)
		      (set! eat? #t)
		      slot)
		     ((pair? slot)
		      (if (get-keyword #:accessor (cdr slot) #f)
			  slot
			  (let ((name (car slot)))
			    `(,name #:accessor ,name ,@(cdr slot)))))
		     (else
		      `(,slot #:accessor ,slot))))
	     slots))))))

(define define-class-with-accessors-keywords
  (procedure->memoizing-macro
   (lambda (exp env)
     (let ((name (cadr exp))
	   (supers (caddr exp))
	   (slots (cdddr exp))
	   (eat? #f))
       `(standard-define-class ,name ,supers
	  ,@(map-in-order
	     (lambda (slot)
	       (cond (eat?
		      (set! eat? #f)
		      slot)
		     ((keyword? slot)
		      (set! eat? #t)
		      slot)
		     ((pair? slot)
		      (let ((slot
			     (if (get-keyword #:accessor (cdr slot) #f)
				 slot
				 (let ((name (car slot)))
				   `(,name #:accessor ,name ,@(cdr slot))))))
			(if (get-keyword #:init-keyword (cdr slot) #f)
			    slot
			    (let* ((name (car slot))
				   (keyword (symbol->keyword name)))
			      `(,name #:init-keyword ,keyword ,@(cdr slot))))))
		     (else
		      `(,slot #:accessor ,slot
			      #:init-keyword ,(symbol->keyword slot)))))
	     slots))))))
