;;; installed-scm-file

;;;; 	Copyright (C) 1999, 2000, 2001 Free Software Foundation, Inc.
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
;;;; This file is based upon composite-slot.stklos from the STk
;;;; distribution by Erick Gallesio <eg@unice.fr>.
;;;;

(define-module (oop goops composite-slot)
  :use-module (oop goops)
  :export (<composite-class>))

;;;
;;; (define-class CLASS SUPERS
;;;   ...
;;;   (OBJECT ...)
;;;   ...
;;;   (SLOT #:allocation #:propagated
;;;         #:propagate-to '(PROPAGATION ...))
;;;   ...
;;;   #:metaclass <composite-class>)
;;;
;;; PROPAGATION ::= OBJECT | (OBJECT TARGETSLOT)
;;;
;;; The slot SLOT will be propagated to the slot TARGETSLOT in the object
;;; stored in slot OBJECT.  If TARGETSLOT is omitted, assume that the target
;;; slot is named SLOT.
;;;

(define-class <composite-class> (<class>))

(define-method (compute-get-n-set (class <composite-class>) slot)
  (if (eq? (slot-definition-allocation slot) #:propagated)
      (compute-propagated-get-n-set slot)
      (next-method)))

(define (compute-propagated-get-n-set s)
  (let ((prop   	(get-keyword #:propagate-to (cdr s) #f))
	(s-name   	(slot-definition-name s)))
    
    (if (not prop)
	(goops-error "Propagation not specified for slot ~S" s-name))
    (if (not (pair? prop))
	(goops-error "Bad propagation list for slot ~S" s-name))

    (let ((objects (map (lambda (p) (if (pair? p) (car p) p)) prop))
	  (slots (map (lambda (p) (if (pair? p) (cadr p) s-name)) prop)))
      (let ((first-object (car objects))
	    (first-slot (car slots)))
	(list
	 ;; The getter
	 (lambda (o) 
	   (slot-ref (slot-ref o first-object) first-slot))

	 ;; The setter
	 (if (null? (cdr objects))
	     (lambda (o v)
	       (slot-set! (slot-ref o first-object) first-slot v))
	     (lambda (o v)
	       (for-each (lambda (object slot)
			   (slot-set! (slot-ref o object) slot v))
			 objects
			 slots))))))))
