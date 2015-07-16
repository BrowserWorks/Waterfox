;;; installed-scm-file

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


;;;; This software is a derivative work of other copyrighted softwares; the
;;;; copyright notices of these softwares are placed in the file COPYRIGHTS
;;;;
;;;; This file is based upon active-slot.stklos from the STk
;;;; distribution by Erick Gallesio <eg@unice.fr>.
;;;;

(define-module (oop goops active-slot)
  :use-module (oop goops internal)
  :export (<active-class>))

(define-class <active-class> (<class>))

(define-method (compute-get-n-set (class <active-class>) slot)
  (if (eq? (slot-definition-allocation slot) #:active)
      (let* ((index 	  (slot-ref class 'nfields))
	     (name	  (car slot))
	     (s		  (cdr slot))
	     (env	  (class-environment class))
	     (before-ref  (get-keyword #:before-slot-ref  s #f))
	     (after-ref   (get-keyword #:after-slot-ref   s #f))
	     (before-set! (get-keyword #:before-slot-set! s #f))
	     (after-set!  (get-keyword #:after-slot-set!  s #f))
	     (unbound	  (make-unbound)))
	(slot-set! class 'nfields (+ index 1))
	(list (lambda (o)
		(if before-ref
		    (if (before-ref o)
			(let ((res (%fast-slot-ref o index)))
			  (and after-ref (not (eqv? res unbound)) (after-ref o))
			  res)
			(make-unbound))
		    (let ((res (%fast-slot-ref o index)))
		      (and after-ref (not (eqv? res unbound)) (after-ref o))
		      res)))

	      (lambda (o v) 
		(if before-set!
		    (if (before-set! o v)
			(begin
			  (%fast-slot-set! o index v)
			  (and after-set! (after-set! o v))))
		    (begin
		      (%fast-slot-set! o index v)
		      (and after-set! (after-set! o v)))))))
      (next-method)))
