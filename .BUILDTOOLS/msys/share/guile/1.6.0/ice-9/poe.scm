;;; installed-scm-file

;;;; 	Copyright (C) 1996, 2001 Free Software Foundation, Inc.
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


(define-module  (ice-9 poe)
  :use-module (ice-9 hcons)
  :export (pure-funcq perfect-funcq))




;;; {Pure Functions}
;;; 
;;; A pure function (of some sort) is characterized by two equality
;;; relations: one on argument lists and one on return values.
;;; A pure function is one that when applied to equal arguments lists
;;; yields equal results.
;;;
;;; If the equality relationship on return values can be eq?, it may make
;;; sense to cache values returned by the function.  Choosing the right
;;; equality relation on arguments is tricky.
;;;


;;; {pure-funcq}
;;;
;;; The simplest case of pure functions are those in which results
;;; are only certainly eq? if all of the arguments are.  These functions
;;; are called "pure-funcq", for obvious reasons.
;;;


(define funcq-memo (make-weak-key-hash-table 523)) ; !!! randomly selected values
(define funcq-buffer (make-gc-buffer 256))

(define (funcq-hash arg-list n)
  (let ((it (let loop ((x 0)
		       (arg-list arg-list))
	      (if (null? arg-list)
		  (modulo x n)
		  (loop (logior x (hashq (car arg-list) 4194303))
			(cdr arg-list))))))
    it))

(define (funcq-assoc arg-list alist)
  (let ((it (and alist
		 (let and-map ((key arg-list)
			       (entry (caar alist)))
		   (or (and (and (not key) (not entry))
			    (car alist))
		       (and key entry
			    (eq? (car key) (car entry))
			    (and-map (cdr key) (cdr entry))))))))
    it))



(define (pure-funcq base-func)
  (lambda args
    (let ((cached (hashx-get-handle funcq-hash funcq-assoc funcq-memo (cons base-func args))))
      (if cached
	  (begin
	    (funcq-buffer (car cached))
	    (cdr cached))
	    
	  (let ((val (apply base-func args))
		(key (cons base-func args)))
	    (funcq-buffer key)
	    (hashx-set! funcq-hash funcq-assoc funcq-memo key val)
	    val)))))



;;; {Perfect funq}
;;;
;;; A pure funq may sometimes forget its past but a perfect
;;; funcq never does.
;;;

(define (perfect-funcq size base-func)
  (define funcq-memo (make-hash-table size))

  (lambda args
    (let ((cached (hashx-get-handle funcq-hash funcq-assoc funcq-memo (cons base-func args))))
      (if cached
	  (begin
	    (funcq-buffer (car cached))
	    (cdr cached))
	    
	  (let ((val (apply base-func args))
		(key (cons base-func args)))
	    (funcq-buffer key)
	    (hashx-set! funcq-hash funcq-assoc funcq-memo key val)
	    val)))))








