;;; installed-scm-file

;;;; Copyright (C) 1999, 2001 Free Software Foundation, Inc.
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

(define uniform-vector? array?)
(define make-uniform-vector dimensions->uniform-array)

;;  (define uniform-vector-ref array-ref)

(define (uniform-vector-set! u i o)
  (uniform-array-set1! u o i))
(define uniform-vector-fill! array-fill!)
(define uniform-vector-read! uniform-array-read!)
(define uniform-vector-write uniform-array-write)

(define (make-array fill . args)
  (dimensions->uniform-array args '() fill))
(define (make-uniform-array prot . args)
  (dimensions->uniform-array args prot))
(define (list->array ndim lst)
  (list->uniform-array ndim '() lst))
(define (list->uniform-vector prot lst)
  (list->uniform-array 1 prot lst))
(define (array-shape a)
  (map (lambda (ind) (if (number? ind) (list 0 (+ -1 ind)) ind))
       (array-dimensions a)))

(let ((make-array-proc (lambda (template)
			 (lambda (c port)
			   (read:uniform-vector template port)))))
  (for-each (lambda (char template)
	      (read-hash-extend char
				(make-array-proc template)))
	    '(#\a #\u #\e #\s #\i #\c #\y   #\h #\l)
	    '(#\a 1   -1  1.0 1/3 0+i #\nul s   l)))

(let ((array-proc (lambda (c port)
		    (read:array c port))))
  (for-each (lambda (char) (read-hash-extend char array-proc))
		  '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)))

(define (read:array digit port)
  (define chr0 (char->integer #\0))
  (let ((rank (let readnum ((val (- (char->integer digit) chr0)))
		(if (char-numeric? (peek-char port))
		    (readnum (+ (* 10 val)
				(- (char->integer (read-char port)) chr0)))
		    val)))
	(prot (if (eq? #\( (peek-char port))
		  '()
		  (let ((c (read-char port)))
		    (case c ((#\b) #t)
			  ((#\a) #\a)
			  ((#\u) 1)
			  ((#\e) -1)
			  ((#\s) 1.0)
			  ((#\i) 1/3)
			  ((#\c) 0+i)
			  (else (error "read:array unknown option " c)))))))
    (if (eq? (peek-char port) #\()
	(list->uniform-array rank prot (read port))
	(error "read:array list not found"))))

(define (read:uniform-vector proto port)
  (if (eq? #\( (peek-char port))
      (list->uniform-array 1 proto (read port))))
