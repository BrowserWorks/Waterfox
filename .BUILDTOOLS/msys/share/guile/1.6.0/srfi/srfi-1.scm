;;; srfi-1.scm --- List Library

;; 	Copyright (C) 2001, 2002 Free Software Foundation, Inc.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this software; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;; Boston, MA 02111-1307 USA
;;
;; As a special exception, the Free Software Foundation gives permission
;; for additional uses of the text contained in its release of GUILE.
;;
;; The exception is that, if you link the GUILE library with other files
;; to produce an executable, this does not by itself cause the
;; resulting executable to be covered by the GNU General Public License.
;; Your use of that executable is in no way restricted on account of
;; linking the GUILE library code into it.
;;
;; This exception does not however invalidate any other reasons why
;; the executable file might be covered by the GNU General Public License.
;;
;; This exception applies only to the code released by the
;; Free Software Foundation under the name GUILE.  If you copy
;; code from other Free Software Foundation releases into a copy of
;; GUILE, as the General Public License permits, the exception does
;; not apply to the code that you add in this way.  To avoid misleading
;; anyone as to the status of such modified files, you must delete
;; this exception notice from them.
;;
;; If you write modifications of your own for GUILE, it is your choice
;; whether to permit this exception to apply to your modifications.
;; If you do not wish that, delete this exception notice.

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
  :use-module (ice-9 session)
  :use-module (ice-9 receive))

(begin-deprecated
 ;; Prevent `export' from re-exporting core bindings.  This behaviour
 ;; of `export' is deprecated and will disappear in one of the next
 ;; releases.
 (define iota #f)
 (define map #f)
 (define map-in-order #f)
 (define for-each #f)
 (define list-index #f)
 (define member #f)
 (define delete #f)
 (define delete! #f)
 (define assoc #f))

(export
;;; Constructors
 ;; cons				<= in the core
 ;; list				<= in the core
 xcons
 ;; cons*				<= in the core
 ;; make-list				<= in the core
 list-tabulate
 ;; list-copy				<= in the core
 circular-list
 iota					; Extended.

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
 map					; Extended.
 for-each				; Extended.
 append-map
 append-map!
 map!
 map-in-order				; Extended.
 pair-for-each
 filter-map

;;; Filtering & partitioning
 filter
 partition
 remove
 filter!
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
 list-index				; Extended.
 member					; Extended.
 ;; memq				<= in the core
 ;; memv				<= in the core

;;; Deletion
 delete					; Extended.
 delete!				; Extended.
 delete-duplicates
 delete-duplicates!

;;; Association lists
 assoc					; Extended.
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

(cond-expand-provide (current-module) '(srfi-1))

;;; Constructors

(define (xcons d a)
  (cons a d))

;; internal helper, similar to (scsh utilities) check-arg.
(define (check-arg-type pred arg caller)
  (if (pred arg)
      arg
      (scm-error 'wrong-type-arg caller
		 "Wrong type argument: ~S" (list arg) '())))

;; the srfi spec doesn't seem to forbid inexact integers.
(define (non-negative-integer? x) (and (integer? x) (>= x 0)))

(define (list-tabulate n init-proc)
  (check-arg-type non-negative-integer? n "list-tabulate")
  (let lp ((n n) (acc '()))
    (if (<= n 0)
      acc
      (lp (- n 1) (cons (init-proc (- n 1)) acc)))))

(define (circular-list elt1 . rest)
  (let ((start (cons elt1 '())))
    (let lp ((r rest) (p start))
      (if (null? r)
	(begin
	  (set-cdr! p start)
	  start)
	(begin
	  (set-cdr! p (cons (car r) '()))
	  (lp (cdr r) (cdr p)))))))

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

(define (not-pair? x)
  (not (pair? x)))

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
      (let ((first (car rest)))
	(let lp ((lists rest))
	  (or (null? lists)
	      (and (lists-equal first (car lists))
		   (lp (cdr lists))))))))

;;; Selectors

(define first car)
(define second cadr)
(define third caddr)
(define fourth cadddr)
(define (fifth x) (car (cddddr x)))
(define (sixth x) (cadr (cddddr x)))
(define (seventh x) (caddr (cddddr x)))
(define (eighth x) (cadddr (cddddr x)))
(define (ninth x) (car (cddddr (cddddr x))))
(define (tenth x) (cadr (cddddr (cddddr x))))

(define (car+cdr x) (values (car x) (cdr x)))

(define (take x i)
  (let lp ((n i) (l x) (acc '()))
    (if (<= n 0)
      (reverse! acc)
      (lp (- n 1) (cdr l) (cons (car l) acc)))))
(define (drop x i)
  (let lp ((n i) (l x))
    (if (<= n 0)
      l
      (lp (- n 1) (cdr l)))))
(define (take-right flist i)
  (let lp ((n i) (l flist))
    (if (<= n 0)
      (let lp0 ((s flist) (l l))
	(if (null? l)
	  s
	  (lp0 (cdr s) (cdr l))))
      (lp (- n 1) (cdr l)))))

(define (drop-right flist i)
  (let lp ((n i) (l flist))
    (if (<= n 0)
      (let lp0 ((s flist) (l l) (acc '()))
	(if (null? l)
	  (reverse! acc)
	  (lp0 (cdr s) (cdr l) (cons (car s) acc))))
      (lp (- n 1) (cdr l)))))

(define (take! x i)
  (if (<= i 0)
    '()
    (let lp ((n (- i 1)) (l x))
      (if (<= n 0)
	(begin
	  (set-cdr! l '())
	  x)
	(lp (- n 1) (cdr l))))))

(define (drop-right! flist i)
  (if (<= i 0)
    flist
    (let lp ((n (+ i 1)) (l flist))
      (if (<= n 0)
	(let lp0 ((s flist) (l l))
	  (if (null? l)
	    (begin
	      (set-cdr! s '())
	      flist)
	    (lp0 (cdr s) (cdr l))))
	(if (null? l)
	  '()
	  (lp (- n 1) (cdr l)))))))

(define (split-at x i)
  (let lp ((l x) (n i) (acc '()))
    (if (<= n 0)
      (values (reverse! acc) l)
      (lp (cdr l) (- n 1) (cons (car l) acc)))))

(define (split-at! x i)
  (if (<= i 0)
    (values '() x)
    (let lp ((l x) (n (- i 1)))
      (if (<= n 0)
	(let ((tmp (cdr l)))
	  (set-cdr! l '())
	  (values x tmp))
	(lp (cdr l) (- n 1))))))

(define (last pair)
  (car (last-pair pair)))

;;; Miscelleneous: length, append, concatenate, reverse, zip & count

(define (length+ clist)
  (if (null? clist)
    0
    (let lp ((hare (cdr clist)) (tortoise clist) (l 1))
      (if (null? hare)
	l
	(let ((hare (cdr hare)))
	  (if (null? hare)
	    (+ l 1)
	    (if (eq? hare tortoise)
	      #f
	      (lp (cdr hare) (cdr tortoise) (+ l 2)))))))))

(define (concatenate l-o-l)
  (let lp ((l l-o-l) (acc '()))
    (if (null? l)
      (reverse! acc)
      (let lp0 ((ll (car l)) (acc acc))
	(if (null? ll)
	  (lp (cdr l) acc)
	  (lp0 (cdr ll) (cons (car ll) acc)))))))

(define (concatenate! l-o-l)
  (let lp0 ((l-o-l l-o-l))
    (cond
      ((null? l-o-l)
       '())
      ((null? (car l-o-l))
       (lp0 (cdr l-o-l)))
      (else
       (let ((result (car l-o-l)) (tail (last-pair (car l-o-l))))
	 (let lp ((l (cdr l-o-l)) (ntail tail))
	   (if (null? l)
	     result
	     (begin
	       (set-cdr! ntail (car l))
	       (lp (cdr l) (last-pair ntail))))))))))


(define (append-reverse rev-head tail)
  (let lp ((l rev-head) (acc tail))
    (if (null? l)
      acc
      (lp (cdr l) (cons (car l) acc)))))

(define (append-reverse! rev-head tail)
  (append-reverse rev-head tail))	; XXX:optimize

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

(define (count pred clist1 . rest)
  (if (null? rest)
      (count1 pred clist1)
      (let lp ((lists (cons clist1 rest)))
	(cond ((any1 null? lists)
	       0)
	      (else
	       (if (apply pred (map1 car lists))
		 (+ 1 (lp (map1 cdr lists)))
		 (lp (map1 cdr lists))))))))

(define (count1 pred clist)
  (let lp ((result 0) (rest clist))
    (if (null? rest)
	result
	(if (pred (car rest))
	    (lp (+ 1 result) (cdr rest))
	    (lp result (cdr rest))))))

;;; Fold, unfold & map

(define (fold kons knil list1 . rest)
  (if (null? rest)
      (let f ((knil knil) (list1 list1))
	(if (null? list1)
	    knil
	    (f (kons (car list1) knil) (cdr list1))))
      (let f ((knil knil) (lists (cons list1 rest)))
	(if (any null? lists)
	    knil
	    (let ((cars (map1 car lists))
		  (cdrs (map1 cdr lists)))
	      (f (apply kons (append! cars (list knil))) cdrs))))))

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

(define (reduce f ridentity lst)
  (fold f ridentity lst))

(define (reduce-right f ridentity lst)
  (fold-right f ridentity lst))


;; Internal helper procedure.  Map `f' over the single list `ls'.
;;
(define (map1 f ls)
  (if (null? ls)
      ls
      (let ((ret (list (f (car ls)))))
        (let lp ((ls (cdr ls)) (p ret))         ; tail pointer
          (if (null? ls)
              ret
              (begin
                (set-cdr! p (list (f (car ls))))
                (lp (cdr ls) (cdr p))))))))

;; This `map' is extended from the standard `map'.  It allows argument
;; lists of different length, so that the shortest list determines the
;; number of elements processed.
;;
(define (map f list1 . rest)
  (if (null? rest)
    (map1 f list1)
    (let lp ((l (cons list1 rest)))
      (if (any1 null? l)
	'()
	(cons (apply f (map1 car l)) (lp (map1 cdr l)))))))

;; extended to lists of unequal length.
(define map-in-order map)

;; This `for-each' is extended from the standard `for-each'.  It
;; allows argument lists of different length, so that the shortest
;; list determines the number of elements processed.
;;
(define (for-each f list1 . rest)
  (if (null? rest)
    (let lp ((l list1))
      (if (null? l)
	(if #f #f)			; Return unspecified value.
	(begin
	  (f (car l))
	  (lp (cdr l)))))
    (let lp ((l (cons list1 rest)))
      (if (any1 null? l)
	(if #f #f)
	(begin
	  (apply f (map1 car l))
	  (lp (map1 cdr l)))))))


(define (append-map f clist1 . rest)
  (if (null? rest)
    (let lp ((l clist1))
      (if (null? l)
	'()
	(append (f (car l)) (lp (cdr l)))))
    (let lp ((l (cons clist1 rest)))
      (if (any1 null? l)
	'()
	(append (apply f (map1 car l)) (lp (map1 cdr l)))))))


(define (append-map! f clist1 . rest)
  (if (null? rest)
    (let lp ((l clist1))
      (if (null? l)
	'()
	(append! (f (car l)) (lp (cdr l)))))
    (let lp ((l (cons clist1 rest)))
      (if (any1 null? l)
	'()
	(append! (apply f (map1 car l)) (lp (map1 cdr l)))))))

(define (map! f list1 . rest)
  (if (null? rest)
    (let lp ((l list1))
      (if (null? l)
	'()
	(begin
	  (set-car! l (f (car l)))
	  (set-cdr! l (lp (cdr l)))
	  l)))
    (let lp ((l (cons list1 rest)) (res list1))
      (if (any1 null? l)
	'()
	(begin
	  (set-car! res (apply f (map1 car l)))
	  (set-cdr! res (lp (map1 cdr l) (cdr res)))
	  res)))))

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

(define (filter-map f clist1 . rest)
  (if (null? rest)
    (let lp ((l clist1))
      (if (null? l)
	'()
	(let ((res (f (car l))))
	  (if res
	    (cons res (lp (cdr l)))
	    (lp (cdr l))))))
    (let lp ((l (cons clist1 rest)))
      (if (any1 null? l)
	'()
	(let ((res (apply f (map1 car l))))
	  (if res
	    (cons res (lp (map1 cdr l)))
	    (lp (map1 cdr l))))))))

;;; Filtering & partitioning

(define (filter pred list)
  (check-arg-type list? list "filter")  ; reject circular lists.
  (letrec ((filiter (lambda (pred rest result)
		      (if (null? rest)
			  (reverse! result)
			  (filiter pred (cdr rest)
				   (cond ((pred (car rest))
					  (cons (car rest) result))
					 (else
					  result)))))))
    (filiter pred list '())))

(define (partition pred list)
  (if (null? list)
    (values '() '())
    (if (pred (car list))
      (receive (in out) (partition pred (cdr list))
	       (values (cons (car list) in) out))
      (receive (in out) (partition pred (cdr list))
	       (values in (cons (car list) out))))))

(define (remove pred list)
  (filter (lambda (x) (not (pred x))) list))

(define (filter! pred list)
  (filter pred list))			; XXX:optimize

(define (partition! pred list)
  (partition pred list))		; XXX:optimize

(define (remove! pred list)
  (remove pred list))			; XXX:optimize

;;; Searching

(define (find pred clist)
  (if (null? clist)
    #f
    (if (pred (car clist))
      (car clist)
      (find pred (cdr clist)))))

(define (find-tail pred clist)
  (if (null? clist)
    #f
    (if (pred (car clist))
      clist
      (find-tail pred (cdr clist)))))

(define (take-while pred ls)
  (cond ((null? ls) '())
        ((not (pred (car ls))) '())
        (else
         (let ((result (list (car ls))))
           (let lp ((ls (cdr ls)) (p result))
             (cond ((null? ls) result)
                   ((not (pred (car ls))) result)
                   (else
                    (set-cdr! p (list (car ls)))
                    (lp (cdr ls) (cdr p)))))))))

(define (take-while! pred clist)
  (take-while pred clist))		; XXX:optimize

(define (drop-while pred clist)
  (if (null? clist)
    '()
    (if (pred (car clist))
      (drop-while pred (cdr clist))
      clist)))

(define (span pred clist)
  (if (null? clist)
    (values '() '())
    (if (pred (car clist))
      (receive (first last) (span pred (cdr clist))
	       (values (cons (car clist) first) last))
      (values '() clist))))

(define (span! pred list)
  (span pred list))			; XXX:optimize

(define (break pred clist)
  (if (null? clist)
    (values '() '())
    (if (pred (car clist))
      (values '() clist)
      (receive (first last) (break pred (cdr clist))
	       (values (cons (car clist) first) last)))))

(define (break! pred list)
  (break pred list))			; XXX:optimize

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

(define (list-index pred clist1 . rest)
  (if (null? rest)
    (let lp ((l clist1) (i 0))
      (if (null? l)
	#f
	(if (pred (car l))
	  i
	  (lp (cdr l) (+ i 1)))))
    (let lp ((lists (cons clist1 rest)) (i 0))
      (cond ((any1 null? lists)
	     #f)
	    ((apply pred (map1 car lists)) i)
	    (else
	     (lp (map1 cdr lists) (+ i 1)))))))

(define (member x list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (let lp ((l list))
      (if (null? l)
	#f
	(if (l= x (car l))
	  l
	  (lp (cdr l)))))))

;;; Deletion

(define (delete x list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (let lp ((l list))
      (if (null? l)
	'()
	(if (l= (car l) x)
	  (lp (cdr l))
	  (cons (car l) (lp (cdr l))))))))

(define (delete! x list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (delete x list l=)))		; XXX:optimize

(define (delete-duplicates list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (let lp0 ((l1 list))
      (if (null? l1)
	'()
	(if (let lp1 ((l2 (cdr l1)))
	      (if (null? l2)
		#f
		(if (l= (car l1) (car l2))
		  #t
		  (lp1 (cdr l2)))))
	  (lp0 (cdr l1))
	  (cons (car l1) (lp0 (cdr l1))))))))

(define (delete-duplicates list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (let lp ((list list))
      (if (null? list)
	'()
	(cons (car list) (lp (delete (car list) (cdr list) l=)))))))

(define (delete-duplicates! list . rest)
  (let ((l= (if (pair? rest) (car rest) equal?)))
    (delete-duplicates list l=)))	; XXX:optimize

;;; Association lists

(define (assoc key alist . rest)
  (let ((k= (if (pair? rest) (car rest) equal?)))
    (let lp ((a alist))
      (if (null? a)
	#f
	(if (k= key (caar a))
	  (car a)
	  (lp (cdr a)))))))

(define (alist-cons key datum alist)
  (acons key datum alist))

(define (alist-copy alist)
  (let lp ((a alist))
    (if (null? a)
      '()
      (acons (caar a) (cdar a) (lp (cdr a))))))

(define (alist-delete key alist . rest)
  (let ((k= (if (pair? rest) (car rest) equal?)))
    (let lp ((a alist))
      (if (null? a)
	'()
	(if (k= (caar a) key)
	  (lp (cdr a))
	  (cons (car a) (lp (cdr a))))))))

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

(define (lset= = list1 . rest)
  (if (null? rest)
    #t
    (let lp ((f list1) (r rest))
      (or (null? r)
	  (and (every (lambda (el) (member el (car r) =)) f)
	       (every (lambda (el) (member el f =)) (car r))
	       (lp (car r) (cdr r)))))))

(define (lset-adjoin = list . rest)
  (let lp ((l rest) (acc list))
    (if (null? l)
      acc
      (if (member (car l) acc)
	(lp (cdr l) acc)
	(lp (cdr l) (cons (car l) acc))))))

(define (lset-union = . rest)
  (let lp0 ((l rest) (acc '()))
    (if (null? l)
      (reverse! acc)
      (let lp1 ((ll (car l)) (acc acc))
	(if (null? ll)
	  (lp0 (cdr l) acc)
	  (if (member (car ll) acc =)
	    (lp1 (cdr ll) acc)
	    (lp1 (cdr ll) (cons (car ll) acc))))))))

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

(define (lset-difference! = list1 . rest)
  (apply lset-difference = list1 rest))	; XXX:optimize

(define (lset-xor! = . rest)
  (apply lset-xor = rest))		; XXX:optimize

(define (lset-diff+intersection! = list1 . rest)
  (apply lset-diff+intersection = list1 rest)) ; XXX:optimize

;;; srfi-1.scm ends here
