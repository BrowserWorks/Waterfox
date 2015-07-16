;;;; q.scm --- Queues
;;;;
;;;; 	Copyright (C) 1995, 2001, 2004, 2006 Free Software Foundation, Inc.
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

;;; Q: Based on the interface to
;;;
;;; "queue.scm"  Queues/Stacks for Scheme
;;;  Written by Andrew Wilcox (awilcox@astro.psu.edu) on April 1, 1992.

;;; {Q}
;;;
;;; A list is just a bunch of cons pairs that follows some constrains,
;;; right?  Association lists are the same.  Hash tables are just
;;; vectors and association lists.  You can print them, read them,
;;; write them as constants, pun them off as other data structures
;;; etc. This is good.  This is lisp.  These structures are fast and
;;; compact and easy to manipulate arbitrarily because of their
;;; simple, regular structure and non-disjointedness (associations
;;; being lists and so forth).
;;;
;;; So I figured, queues should be the same -- just a "subtype" of cons-pair
;;; structures in general.
;;;
;;; A queue is a cons pair:
;;;		( <the-q> . <last-pair> )
;;;
;;; <the-q> is a list of things in the q.  New elements go at the end
;;; of that list.
;;;
;;; <last-pair> is #f if the q is empty, and otherwise is the last
;;; pair of <the-q>.
;;;
;;; q's print nicely, but alas, they do not read well because the
;;; eq?-ness of <last-pair> and (last-pair <the-q>) is lost by read.
;;;
;;; All the functions that aren't explicitly defined to return
;;; something else (a queue element; a boolean value) return the queue
;;; object itself.

;;; Code:

(define-module (ice-9 q)
  :export (sync-q! make-q q? q-empty? q-empty-check q-front q-rear
	   q-remove! q-push! enq! q-pop! deq! q-length))

;;; sync-q!
;;;   The procedure
;;;
;;;		(sync-q! q)
;;;
;;;   recomputes and resets the <last-pair> component of a queue.
;;;
(define (sync-q! q)
  (set-cdr! q (if (pair? (car q)) (last-pair (car q))
		  #f))
  q)

;;; make-q
;;;  return a new q.
;;;
(define (make-q) (cons '() #f))

;;; q? obj
;;;   Return true if obj is a Q.
;;;   An object is a queue if it is equal? to '(() . #f)
;;;   or it is a pair P with (list? (car P))
;;;                      and (eq? (cdr P) (last-pair (car P))).
;;;
(define (q? obj)
  (and (pair? obj)
       (if (pair? (car obj))
	   (eq? (cdr obj) (last-pair (car obj)))
	   (and (null? (car obj))
		(not (cdr obj))))))

;;; q-empty? obj
;;;
(define (q-empty? obj) (null? (car obj)))

;;; q-empty-check q
;;;  Throw a q-empty exception if Q is empty.
(define (q-empty-check q) (if (q-empty? q) (throw 'q-empty q)))

;;; q-front q
;;;  Return the first element of Q.
(define (q-front q) (q-empty-check q) (caar q))

;;; q-rear q
;;;  Return the last element of Q.
(define (q-rear q) (q-empty-check q) (cadr q))

;;; q-remove! q obj
;;;  Remove all occurences of obj from Q.
(define (q-remove! q obj)
  (set-car! q (delq! obj (car q)))
  (sync-q! q))

;;; q-push! q obj
;;;  Add obj to the front of Q
(define (q-push! q obj)
  (let ((h (cons obj (car q))))
    (set-car! q h)
    (or (cdr q) (set-cdr! q h)))
  q)

;;; enq! q obj
;;;  Add obj to the rear of Q
(define (enq! q obj)
  (let ((h (cons obj '())))
    (if (null? (car q))
	(set-car! q h)
	(set-cdr! (cdr q) h))
    (set-cdr! q h))
  q)

;;; q-pop! q
;;;  Take the front of Q and return it.
(define (q-pop! q)
  (q-empty-check q)
  (let ((it (caar q))
	(next (cdar q)))
    (if (null? next)
	(set-cdr! q #f))
    (set-car! q next)
    it))

;;; deq! q
;;;  Take the front of Q and return it.
(define deq! q-pop!)

;;; q-length q
;;;  Return the number of enqueued elements.
;;;
(define (q-length q) (length (car q)))

;;; q.scm ends here
