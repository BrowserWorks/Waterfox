;;; installed-scm-file

;;;; 	Copyright (C) 1995, 1996, 1998, 2001, 2003, 2006 Free Software Foundation, Inc.
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
  (hashx-get-handle hashq-cons-hash hashq-cons-assoc table key))

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
