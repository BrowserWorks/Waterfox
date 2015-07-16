;;;; common-list.scm --- COMMON LISP list functions for Scheme
;;;;
;;;; 	Copyright (C) 1995, 1996, 1997, 2001, 2006 Free Software Foundation, Inc.
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

;;; Commentary:

;; These procedures are exported:
;;  (adjoin e l)
;;  (union l1 l2)
;;  (intersection l1 l2)
;;  (set-difference l1 l2)
;;  (reduce-init p init l)
;;  (reduce p l)
;;  (some pred l . rest)
;;  (every pred l . rest)
;;  (notany pred . ls)
;;  (notevery pred . ls)
;;  (count-if pred l)
;;  (find-if pred l)
;;  (member-if pred l)
;;  (remove-if pred l)
;;  (remove-if-not pred l)
;;  (delete-if! pred l)
;;  (delete-if-not! pred l)
;;  (butlast lst n)
;;  (and? . args)
;;  (or? . args)
;;  (has-duplicates? lst)
;;  (pick p l)
;;  (pick-mappings p l)
;;  (uniq l)
;;
;; See docstrings for each procedure for more info.  See also module
;; `(srfi srfi-1)' for a complete list handling library.

;;; Code:

(define-module (ice-9 common-list)
  :export (adjoin union intersection set-difference reduce-init reduce
	   some every notany notevery count-if find-if member-if remove-if
	   remove-if-not delete-if! delete-if-not! butlast and? or?
	   has-duplicates? pick pick-mappings uniq))

;;"comlist.scm" Implementation of COMMON LISP list functions for Scheme
; Copyright (C) 1991, 1993, 1995 Aubrey Jaffer.
;
;Permission to copy this software, to redistribute it, and to use it
;for any purpose is granted, subject to the following restrictions and
;understandings.
;
;1.  Any copy made of this software must include this copyright notice
;in full.
;
;2.  I have made no warrantee or representation that the operation of
;this software will be error-free, and I am under no obligation to
;provide any services, by way of maintenance, update, or otherwise.
;
;3.  In conjunction with products arising from the use of this
;material, there shall be no use of my name in any advertising,
;promotional, or sales literature without prior written consent in
;each case.

(define (adjoin e l)
  "Return list L, possibly with element E added if it is not already in L."
  (if (memq e l) l (cons e l)))

(define (union l1 l2)
  "Return a new list that is the union of L1 and L2.
Elements that occur in both lists occur only once in
the result list."
  (cond ((null? l1) l2)
	((null? l2) l1)
	(else (union (cdr l1) (adjoin (car l1) l2)))))

(define (intersection l1 l2)
  "Return a new list that is the intersection of L1 and L2.
Only elements that occur in both lists occur in the result list."
  (if (null? l2) l2
      (let loop ((l1 l1) (result '()))
	(cond ((null? l1) (reverse! result))
	      ((memv (car l1) l2) (loop (cdr l1) (cons (car l1) result)))
	      (else (loop (cdr l1) result))))))

(define (set-difference l1 l2)
  "Return elements from list L1 that are not in list L2."
  (let loop ((l1 l1) (result '()))
    (cond ((null? l1) (reverse! result))
	  ((memv (car l1) l2) (loop (cdr l1) result))
	  (else (loop (cdr l1) (cons (car l1) result))))))

(define (reduce-init p init l)
  "Same as `reduce' except it implicitly inserts INIT at the start of L."
  (if (null? l)
      init
      (reduce-init p (p init (car l)) (cdr l))))

(define (reduce p l)
  "Combine all the elements of sequence L using a binary operation P.
The combination is left-associative.  For example, using +, one can
add up all the elements.  `reduce' allows you to apply a function which
accepts only two arguments to more than 2 objects.  Functional
programmers usually refer to this as foldl."
  (cond ((null? l) l)
	((null? (cdr l)) (car l))
	(else (reduce-init p (car l) (cdr l)))))

(define (some pred l . rest)
  "PRED is a boolean function of as many arguments as there are list
arguments to `some', i.e., L plus any optional arguments.  PRED is
applied to successive elements of the list arguments in order.  As soon
as one of these applications returns a true value, return that value.
If no application returns a true value, return #f.
All the lists should have the same length."
  (cond ((null? rest)
	 (let mapf ((l l))
	   (and (not (null? l))
		(or (pred (car l)) (mapf (cdr l))))))
	(else (let mapf ((l l) (rest rest))
		(and (not (null? l))
		     (or (apply pred (car l) (map car rest))
			 (mapf (cdr l) (map cdr rest))))))))

(define (every pred l . rest)
  "Return #t iff every application of PRED to L, etc., returns #t.
Analogous to `some' except it returns #t if every application of
PRED is #t and #f otherwise."
  (cond ((null? rest)
	 (let mapf ((l l))
	   (or (null? l)
	       (and (pred (car l)) (mapf (cdr l))))))
	(else (let mapf ((l l) (rest rest))
		(or (null? l)
		    (and (apply pred (car l) (map car rest))
			 (mapf (cdr l) (map cdr rest))))))))

(define (notany pred . ls)
  "Return #t iff every application of PRED to L, etc., returns #f.
Analogous to some but returns #t if no application of PRED returns a
true value or #f as soon as any one does."
  (not (apply some pred ls)))

(define (notevery pred . ls)
  "Return #t iff there is an application of PRED to L, etc., that returns #f.
Analogous to some but returns #t as soon as an application of PRED returns #f,
or #f otherwise."
  (not (apply every pred ls)))

(define (count-if pred l)
  "Return the number of elements in L for which (PRED element) returns true."
  (let loop ((n 0) (l l))
    (cond ((null? l) n)
	  ((pred (car l)) (loop (+ n 1) (cdr l)))
	  (else (loop n (cdr l))))))

(define (find-if pred l)
  "Search for the first element in L for which (PRED element) returns true.
If found, return that element, otherwise return #f."
  (cond ((null? l) #f)
	((pred (car l)) (car l))
	(else (find-if pred (cdr l)))))

(define (member-if pred l)
  "Return the first sublist of L for whose car PRED is true."
  (cond ((null? l) #f)
	((pred (car l)) l)
	(else (member-if pred (cdr l)))))

(define (remove-if pred l)
  "Remove all elements from L where (PRED element) is true.
Return everything that's left."
  (let loop ((l l) (result '()))
    (cond ((null? l) (reverse! result))
	  ((pred (car l)) (loop (cdr l) result))
	  (else (loop (cdr l) (cons (car l) result))))))

(define (remove-if-not pred l)
  "Remove all elements from L where (PRED element) is #f.
Return everything that's left."
  (let loop ((l l) (result '()))
    (cond ((null? l) (reverse! result))
	  ((not (pred (car l))) (loop (cdr l) result))
	  (else (loop (cdr l) (cons (car l) result))))))

(define (delete-if! pred l)
  "Destructive version of `remove-if'."
  (let delete-if ((l l))
    (cond ((null? l) '())
	  ((pred (car l)) (delete-if (cdr l)))
	  (else
	   (set-cdr! l (delete-if (cdr l)))
	   l))))

(define (delete-if-not! pred l)
  "Destructive version of `remove-if-not'."
  (let delete-if-not ((l l))
    (cond ((null? l) '())
	  ((not (pred (car l))) (delete-if-not (cdr l)))
	  (else
	   (set-cdr! l (delete-if-not (cdr l)))
	   l))))

(define (butlast lst n)
  "Return all but the last N elements of LST."
  (letrec ((l (- (length lst) n))
	   (bl (lambda (lst n)
		 (cond ((null? lst) lst)
		       ((positive? n)
			(cons (car lst) (bl (cdr lst) (+ -1 n))))
		       (else '())))))
    (bl lst (if (negative? n)
		(error "negative argument to butlast" n)
		l))))

(define (and? . args)
  "Return #t iff all of ARGS are true."
  (cond ((null? args) #t)
	((car args) (apply and? (cdr args)))
	(else #f)))

(define (or? . args)
  "Return #t iff any of ARGS is true."
  (cond ((null? args) #f)
	((car args) #t)
	(else (apply or? (cdr args)))))

(define (has-duplicates? lst)
  "Return #t iff 2 members of LST are equal?, else #f."
  (cond ((null? lst) #f)
	((member (car lst) (cdr lst)) #t)
	(else (has-duplicates? (cdr lst)))))

(define (pick p l)
  "Apply P to each element of L, returning a list of elts
for which P returns a non-#f value."
  (let loop ((s '())
	     (l l))
    (cond
     ((null? l) 	s)
     ((p (car l))	(loop (cons (car l) s) (cdr l)))
     (else		(loop s (cdr l))))))

(define (pick-mappings p l)
  "Apply P to each element of L, returning a list of the
non-#f return values of P."
  (let loop ((s '())
	     (l l))
    (cond
     ((null? l) 	s)
     ((p (car l)) =>	(lambda (mapping) (loop (cons mapping s) (cdr l))))
     (else		(loop s (cdr l))))))

(define (uniq l)
  "Return a list containing elements of L, with duplicates removed."
  (let loop ((acc '())
	     (l l))
    (if (null? l)
	(reverse! acc)
	(loop (if (memq (car l) acc)
		  acc
		  (cons (car l) acc))
	      (cdr l)))))

;;; common-list.scm ends here
