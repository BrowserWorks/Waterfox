;;; installed-scm-file

;;;; 	Copyright (C) 1999, 2001 Free Software Foundation, Inc.
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
;;;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;;;; Boston, MA 02111-1307 USA
;;;;
;;;; As a special exception, the Free Software Foundation gives permission
;;;; for additional uses of the text contained in its release of GUILE.
;;;;
;;;; The exception is that, if you link the GUILE library with other files
;;;; to produce an executable, this does not by itself cause the
;;;; resulting executable to be covered by the GNU General Public License.
;;;; Your use of that executable is in no way restricted on account of
;;;; linking the GUILE library code into it.
;;;;
;;;; This exception does not however invalidate any other reasons why
;;;; the executable file might be covered by the GNU General Public License.
;;;;
;;;; This exception applies only to the code released by the
;;;; Free Software Foundation under the name GUILE.  If you copy
;;;; code from other Free Software Foundation releases into a copy of
;;;; GUILE, as the General Public License permits, the exception does
;;;; not apply to the code that you add in this way.  To avoid misleading
;;;; anyone as to the status of such modified files, you must delete
;;;; this exception notice from them.
;;;;
;;;; If you write modifications of your own for GUILE, it is your choice
;;;; whether to permit this exception to apply to your modifications.
;;;; If you do not wish that, delete this exception notice.
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
