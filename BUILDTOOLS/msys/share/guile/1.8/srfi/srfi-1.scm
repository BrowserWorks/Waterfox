;;; srfi-1.scm --- List Library

;; 	Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006 Free Software Foundation, Inc.
;;
;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 2.1 of the License, or (at your option) any later version.
;; 
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public
;; License along with this library; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

;;; Author: Martin Grabmueller <mgrabmue@cs.tu-berlin.de>
;;; Date: 2001-06-06

;;; Commentary:

;; This is an implementation of SRFI-1 (List Library).
;;
;; All procedures defined in SRFI-1, which are not already defined in
;; the Guile core library, are exported.  The procedures in this
;; implementation work, but they have not been tuned for speed or
;; memory usage.
;;
;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-1)
  :export (
;;; Constructors
 ;; cons				<= in the core
 ;; list				<= in the core
 xcons
 ;; cons*				<= in the core
 ;; make-list				<= in the core
 list-tabulate
 list-copy
 circular-list
 ;; iota				; Extended.

;;; Predicates
 proper-list?
 circular-list?
 dotted-list?
 ;; pair?				<= in the core
 ;; null?				<= in the core
 null-list?
 not-pair?
 list=

;;; Selectors
 ;; car					<= in the core
 ;; cdr					<= in the core
 ;; caar				<= in the core
 ;; cadr				<= in the core
 ;; cdar				<= in the core
 ;; cddr				<= in the core
 ;; caaar				<= in the core
 ;; caadr				<= in the core
 ;; cadar				<= in the core
 ;; caddr				<= in the core
 ;; cdaar				<= in the core
 ;; cdadr				<= in the core
 ;; cddar				<= in the core
 ;; cdddr				<= in the core
 ;; caaaar				<= in the core
 ;; caaadr				<= in the core
 ;; caadar				<= in the core
 ;; caaddr				<= in the core
 ;; cadaar				<= in the core
 ;; cadadr				<= in the core
 ;; caddar				<= in the core
 ;; cadddr				<= in the core
 ;; cdaaar				<= in the core
 ;; cdaadr				<= in the core
 ;; cdadar				<= in the core
 ;; cdaddr				<= in the core
 ;; cddaar				<= in the core
 ;; cddadr				<= in the core
 ;; cdddar				<= in the core
 ;; cddddr				<= in the core
 ;; list-ref				<= in the core
 first
 second
 third
 fourth
 fifth
 sixth
 seventh
 eighth
 ninth
 tenth
 car+cdr
 take
 drop
 take-right
 drop-right
 take!
 drop-right!
 split-at
 split-at!
 last
 ;; last-pair				<= in the core

;;; Miscelleneous: length, append, concatenate, reverse, zip & count
 ;; length				<= in the core
 length+
 ;; append				<= in the core
 ;; append!				<= in the core
 concatenate
 concatenate!
 ;; reverse				<= in the core
 ;; reverse!				<= in the core
 append-reverse
 append-reverse!
 zip
 unzip1
 unzip2
 unzip3
 unzip4
 unzip5
 count

;;; Fold, unfold & map
 fold
 fold-right
 pair-fold
 pair-fold-right
 reduce
 reduce-right
 unfold
 unfold-right
 ;; map					; Extended.
 ;; for-each				; Extended.
 append-map
 append-map!
 map!
 ;; map-in-order			; Extended.
 pair-for-each
 filter-map

;;; Filtering & partitioning
 ;; filter				<= in the core
 partition
 remove
 ;; filter!				<= in the core
 partition!
 remove!

;;; Searching
 find
 find-tail
 take-while
 take-while!
 drop-while
 span
 span!
 break
 break!
 any
 every
 ;; list-index				; Extended.
 ;; member				; Extended.
 ;; memq				<= in the core
 ;; memv				<= in the core

;;; Deletion
 ;; delete				; Extended.
 ;; delete!				; Extended.
 delete-duplicates
 delete-duplicates!

;;; Association lists
 ;; assoc				; Extended.
 ;; assq				<= in the core
 ;; assv				<= in the core
 alist-cons
 alist-copy
 alist-delete
 alist-delete!

;;; Set operations on lists
 lset<=
 lset=
 lset-adjoin
 lset-union
 lset-intersection
 lset-difference
 lset-xor
 lset-diff+intersection
 lset-union!
 lset-intersection!
 lset-difference!
 lset-xor!
 lset-diff+intersection!

;;; Primitive side-effects
 ;; set-car!				<= in the core
 ;; set-cdr!				<= in the core
 )
  :re-export (cons list cons* make-list pair? null?
	      car cdr caar cadr cdar cddr
	      caaar caadr cadar caddr cdaar cdadr cddar cdddr
	      caaaar caaadr caadar caaddr cadaar cadadr caddar cadddr
	      cdaaar cdaadr cdadar cdaddr cddaar cddadr cdddar cddddr
	      list-ref last-pair length append append! reverse reverse!
	      filter filter! memq memv assq assv set-car! set-cdr!)
  :replace (iota map for-each map-in-order list-copy list-index member
	    delete delete! assoc)
  )

(cond-expand-provide (current-module) '(srfi-1))

;; Load the compiled primitives from the shared library.
;;
(load-extension "libguile-srfi-srfi-1-v-3" "scm_init_srfi_1")


;;; Constructors

;; internal helper, similar to (scsh utilities) check-arg.
(define (check-arg-type pred arg caller)
  (if (pred arg)
      arg
      (scm-error 'wrong-type-arg caller
		 "Wrong type argument: ~S" (list arg) '())))

;; the srfi spec doesn't seem to forbid inexact integers.
(define (non-negative-integer? x) (and (integer? x) (>= x 0)))



(define (circular-list elt1 . elts)
  (set! elts (cons elt1 elts))
  (set-cdr! (last-pair elts) elts)
  elts)

(define (iota count . rest)
  (check-arg-type non-negative-integer? count "iota")
  (let ((start (if (pair? rest) (car rest) 0))
	(step (if (and (pair? rest) (pair? (cdr rest))) (cadr rest) 1)))
    (let lp ((n 0) (acc '()))
      (if (= n count)
	(reverse! acc)
	(lp (+ n 1) (cons (+ start (* n step)) acc))))))

;;; Predicates

(define (proper-list? x)
  (list? x))

(define (circular-list? x)
  (if (not-pair? x)
    #f
    (let lp ((hare (cdr x)) (tortoise x))
      (if (not-pair? hare)
	#f
	(let ((hare (cdr hare)))
	  (if (not-pair? hare)
	    #f
	    (if (eq? hare tortoise)
	      #t
	      (lp (cdr hare) (cdr tortoise)))))))))

(define (dotted-list? x)
  (cond
    ((null? x) #f)
    ((not-pair? x) #t)
    (else
     (let lp ((hare (cdr x)) (tortoise x))
       (cond
	 ((null? hare) #f)
	 ((not-pair? hare) #t)
	 (else
	  (let ((hare (cdr hare)))
	    (cond
	      ((null? hare) #f)
	      ((not-pair? hare) #t)
	      ((eq? hare tortoise) #f)
	      (else
	       (lp (cdr hare) (cdr tortoise)))))))))))

(define (null-list? x)
  (cond
    ((proper-list? x)
     (null? x))
    ((circular-list? x)
     #f)
    (else
     (error "not a proper list in null-list?"))))

(define (list= elt= . rest)
  (define (lists-equal a b)
    (let lp ((a a) (b b))
      (cond ((null? a)
	     (null? b))
	    ((null? b)
	     #f)
	    (else
	     (and (elt= (car a) (car b))
		  (lp (cdr a) (cdr b)))))))
  (or (null? rest)
      (let lp ((lists rest))
	(or (null? (cdr lists))
	    (and (lists-equal (car lists) (cadr lists))
		 (lp (cdr lists)))))))

;;; Selectors

(define first car)
(define second cadr)
(define third caddr)
(define fourth cadddr)

(define take list-head)
(define drop list-tail)

;;; Miscelleneous: length, append, concatenate, reverse, zip & count

(define (zip clist1 . rest)
  (let lp ((l (cons clist1 rest)) (acc '()))
    (if (any null? l)
      (reverse! acc)
      (lp (map1 cdr l) (cons (map1 car l) acc)))))


(define (unzip1 l)
  (map1 first l))
(define (unzip2 l)
  (values (map1 first l) (map1 second l)))
(define (unzip3 l)
  (values (map1 first l) (map1 second l) (map1 third l)))
(define (unzip4 l)
  (values (map1 first l) (map1 second l) (map1 third l) (map1 fourth l)))
(define (unzip5 l)
  (values (map1 first l) (map1 second l) (map1 third l) (map1 fourth l)
	  (map1 fifth l)))

;;; Fold, unfold & map

(define (fold-right kons knil clist1 . rest)
  (if (null? rest)
    (let f ((list1 clist1))
      (if (null? list1)
	knil
	(kons (car list1) (f (cdr list1)))))
    (let f ((lists (cons clist1 rest)))
      (if (any null? lists)
	knil
	(apply kons (append! (map1 car lists) (list (f (map1 cdr lists)))))))))

(define (pair-fold kons knil clist1 . rest)
  (if (null? rest)
      (let f ((knil knil) (list1 clist1))
	(if (null? list1)
	    knil
	    (let ((tail (cdr list1)))
	    (f (kons list1 knil) tail))))
      (let f ((knil knil) (lists (cons clist1 rest)))
	(if (any null? lists)
	    knil
	    (let ((tails (map1 cdr lists)))
	      (f (apply kons (append! lists (list knil))) tails))))))


(define (pair-fold-right kons knil clist1 . rest)
  (if (null? rest)
    (let f ((list1 clist1))
      (if (null? list1)
	knil
	(kons list1 (f (cdr list1)))))
    (let f ((lists (cons clist1 rest)))
      (if (any null? lists)
	knil
	(apply kons (append! lists (list (f (map1 cdr lists)))))))))

(define (unfold p f g seed . rest)
  (let ((tail-gen (if (pair? rest)
		      (if (pair? (cdr rest))
			  (scm-error 'wrong-number-of-args
				     "unfold" "too many arguments" '() '())
			  (car rest))
		      (lambda (x) '()))))
    (let uf ((seed seed))
      (if (p seed)
	  (tail-gen seed)
	  (cons (f seed)
		(uf (g seed)))))))

(define (unfold-right p f g seed . rest)
  (let ((tail (if (pair? rest)
		  (if (pair? (cdr rest))
		      (scm-error 'wrong-number-of-args
				     "unfold-right" "too many arguments" '()
				     '())
		      (car rest))
		      '())))
    (let uf ((seed seed) (lis tail))
      (if (p seed)
	  lis
	  (uf (g seed) (cons (f seed) lis))))))


;; Internal helper procedure.  Map `f' over the single list `ls'.
;;
(define map1 map)

(define (append-map f clist1 . rest)
  (concatenate (apply map f clist1 rest)))
  
(define (append-map! f clist1 . rest)
  (concatenate! (apply map f clist1 rest)))

;; OPTIMIZE-ME: Re-use cons cells of list1
(define map! map)

(define (pair-for-each f clist1 . rest)
  (if (null? rest)
    (let lp ((l clist1))
      (if (null? l)
	(if #f #f)
	(begin
	  (f l)
	  (lp (cdr l)))))
    (let lp ((l (cons clist1 rest)))
      (if (any1 null? l)
	(if #f #f)
	(begin
	  (apply f l)
	  (lp (map1 cdr l)))))))

;;; Searching

(define (any pred ls . lists)
  (if (null? lists)
      (any1 pred ls)
      (let lp ((lists (cons ls lists)))
	(cond ((any1 null? lists)
	       #f)
	      ((any1 null? (map1 cdr lists))
	       (apply pred (map1 car lists)))
	      (else
	       (or (apply pred (map1 car lists)) (lp (map1 cdr lists))))))))

(define (any1 pred ls)
  (let lp ((ls ls))
    (cond ((null? ls)
	   #f)
	  ((null? (cdr ls))
	   (pred (car ls)))
	  (else
	   (or (pred (car ls)) (lp (cdr ls)))))))

(define (every pred ls . lists)
  (if (null? lists)
      (every1 pred ls)
      (let lp ((lists (cons ls lists)))
	(cond ((any1 null? lists)
	       #t)
	      ((any1 null? (map1 cdr lists))
	       (apply pred (map1 car lists)))
	      (else
	       (and (apply pred (map1 car lists)) (lp (map1 cdr lists))))))))

(define (every1 pred ls)
  (let lp ((ls ls))
    (cond ((null? ls)
	   #t)
	  ((null? (cdr ls))
	   (pred (car ls)))
	  (else
	   (and (pred (car ls)) (lp (cdr ls)))))))

;;; Association lists

(define alist-cons acons)

(define (alist-delete key alist . rest)
  (let ((k= (if (pair? rest) (car rest) equal?)))
    (let lp ((a alist) (rl '()))
      (if (null? a)
	(reverse! rl)
	(if (k= key (caar a))
	  (lp (cdr a) rl)
	  (lp (cdr a) (cons (car a) rl)))))))

(define (alist-delete! key alist . rest)
  (let ((k= (if (pair? rest) (car rest) equal?)))
    (alist-delete key alist k=)))	; XXX:optimize

;;; Set operations on lists

(define (lset<= = . rest)
  (if (null? rest)
    #t
    (let lp ((f (car rest)) (r (cdr rest)))
      (or (null? r)
	  (and (every (lambda (el) (member el (car r) =)) f)
	       (lp (car r) (cdr r)))))))

(define (lset= = . rest)
  (if (null? rest)
    #t
    (let lp ((f (car rest)) (r (cdr rest)))
      (or (null? r)
	  (and (every (lambda (el) (member el (car r) =)) f)
	       (every (lambda (el) (member el f (lambda (x y) (= y x)))) (car r))
	       (lp (car r) (cdr r)))))))

(define (lset-union = . rest)
  (let ((acc '()))
    (for-each (lambda (lst)
		(if (null? acc)
		    (set! acc lst)
		    (for-each (lambda (elem)
				(if (not (member elem acc
						 (lambda (x y) (= y x))))
				    (set! acc (cons elem acc))))
			      lst)))
	      rest)
    acc))

(define (lset-intersection = list1 . rest)
  (let lp ((l list1) (acc '()))
    (if (null? l)
      (reverse! acc)
      (if (every (lambda (ll) (member (car l) ll =)) rest)
	(lp (cdr l) (cons (car l) acc))
	(lp (cdr l) acc)))))

(define (lset-difference = list1 . rest)
  (if (null? rest)
    list1
    (let lp ((l list1) (acc '()))
      (if (null? l)
	(reverse! acc)
	(if (any (lambda (ll) (member (car l) ll =)) rest)
	  (lp (cdr l) acc)
	  (lp (cdr l) (cons (car l) acc)))))))

;(define (fold kons knil list1 . rest)

(define (lset-xor = . rest)
  (fold (lambda (lst res)
	  (let lp ((l lst) (acc '()))
	    (if (null? l)
	      (let lp0 ((r res) (acc acc))
		(if (null? r)
		  (reverse! acc)
		  (if (member (car r) lst =)
		    (lp0 (cdr r) acc)
		    (lp0 (cdr r) (cons (car r) acc)))))
	      (if (member (car l) res =)
		(lp (cdr l) acc)
		(lp (cdr l) (cons (car l) acc))))))
	'()
	rest))

(define (lset-diff+intersection = list1 . rest)
  (let lp ((l list1) (accd '()) (acci '()))
    (if (null? l)
      (values (reverse! accd) (reverse! acci))
      (let ((appears (every (lambda (ll) (member (car l) ll =)) rest)))
	(if appears
	  (lp (cdr l) accd (cons (car l) acci))
	  (lp (cdr l) (cons (car l) accd) acci))))))


(define (lset-union! = . rest)
  (apply lset-union = rest))		; XXX:optimize

(define (lset-intersection! = list1 . rest)
  (apply lset-intersection = list1 rest)) ; XXX:optimize

(define (lset-xor! = . rest)
  (apply lset-xor = rest))		; XXX:optimize

(define (lset-diff+intersection! = list1 . rest)
  (apply lset-diff+intersection = list1 rest)) ; XXX:optimize

;;; srfi-1.scm ends here
