;;; installed-scm-file

;;;; 	Copyright (C) 1996, 2001, 2006 Free Software Foundation, Inc.
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

;; return true if lists X and Y are the same length and each element is `eq?'
(define (eq?-list x y)
  (if (null? x)
      (null? y)
      (and (not (null? y))
	   (eq? (car x) (car y))
	   (eq?-list (cdr x) (cdr y)))))

(define (funcq-assoc arg-list alist)
  (if (null? alist)
      #f
      (if (eq?-list arg-list (caar alist))
	  (car alist)
	  (funcq-assoc arg-list (cdr alist)))))



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








