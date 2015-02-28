;;; installed-scm-file

;;;; 	Copyright (C) 1995, 1996, 1998, 2001 Free Software Foundation, Inc.
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


(define-module  (ice-9 hcons)
  :export (hashq-cons-hash hashq-cons-assoc hashq-cons-get-handle
	   hashq-cons-create-handle! hashq-cons-ref hashq-cons-set! hashq-cons
	   hashq-conser make-gc-buffer))


;;; {Eq? hash-consing}
;;;
;;; A hash conser maintains a private universe of pairs s.t. if 
;;; two cons calls pass eq? arguments, the pairs returned are eq?.
;;;
;;; A hash conser does not contribute life to the pairs it returns.
;;;

(define (hashq-cons-hash pair n)
  (modulo (logxor (hashq (car pair) 4194303)
		  (hashq (cdr pair) 4194303))
	  n))

(define (hashq-cons-assoc key l)
  (and (not (null? l))
       (or (and (pair? l)		; If not a pair, use its cdr?
		(pair? (car l))
		(pair? (caar l))
		(eq? (car key) (caaar l))
		(eq? (cdr key) (cdaar l))
		(car l))
	   (hashq-cons-assoc key (cdr l)))))

(define (hashq-cons-get-handle table key)
  (hashx-get-handle hashq-cons-hash hashq-cons-assoc table key #f))

(define (hashq-cons-create-handle! table key init)
  (hashx-create-handle! hashq-cons-hash hashq-cons-assoc table key init))

(define (hashq-cons-ref table key)
  (hashx-ref hashq-cons-hash hashq-cons-assoc table key #f))

(define (hashq-cons-set! table key val)
  (hashx-set! hashq-cons-hash hashq-cons-assoc table key val))

(define (hashq-cons table a d)
  (car (hashq-cons-create-handle! table (cons a d) #f)))

(define (hashq-conser hash-tab-or-size)
  (let ((table (if (vector? hash-tab-or-size)
		   hash-tab-or-size
		   (make-doubly-weak-hash-table hash-tab-or-size))))
    (lambda (a d) (hashq-cons table a d))))




(define (make-gc-buffer n)
  (let ((ring (make-list n #f)))
    (append! ring ring)
    (lambda (next)
      (set-car! ring next)
      (set! ring (cdr ring))
      next)))
