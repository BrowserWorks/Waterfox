;;;; streams.scm --- general lazy streams
;;;; -*- Scheme -*-

;;;; Copyright (C) 1999, 2001, 2004, 2006 Free Software Foundation, Inc.
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

;; the basic stream operations are inspired by
;; (i.e. ripped off) Scheme48's `stream' package,
;; modulo stream-empty? -> stream-null? renaming.

(define-module (ice-9 streams)
  :export (make-stream
	   stream-car stream-cdr stream-null?
	   list->stream vector->stream port->stream
	   stream->list stream->reversed-list
	   stream->list&length stream->reversed-list&length
	   stream->vector
	   stream-fold stream-for-each stream-map))

;; Use:
;;
;; (make-stream producer initial-state)
;;  - PRODUCER is a function of one argument, the current state.
;;    it should return either a pair or an atom (i.e. anything that
;;    is not a pair).  if PRODUCER returns a pair, then the car of the pair
;;    is the stream's head value, and the cdr is the state to be fed
;;    to PRODUCER later.  if PRODUCER returns an atom, then the stream is
;;    considered depleted.
;;
;; (stream-car stream)
;; (stream-cdr stream)
;; (stream-null? stream)
;;  - yes.
;;
;; (list->stream list)
;; (vector->stream vector)
;;  - make a stream with the same contents as LIST/VECTOR.
;;
;; (port->stream port read)
;;  - makes a stream of values which are obtained by READing from PORT.
;;
;; (stream->list stream)
;;  - returns a list with the same contents as STREAM.
;;
;; (stream->reversed-list stream)
;;  - as above, except the contents are in reversed order.
;;
;; (stream->list&length stream)
;; (stream->reversed-list&length stream)
;;  - multiple-valued versions of the above two, the second value is the
;;    length of the resulting list (so you get it for free).
;;
;; (stream->vector stream)
;;  - yes.
;;
;; (stream-fold proc init stream0 ...)
;;  - PROC must take (+ 1 <number-of-stream-arguments>) arguments, like this:
;;    (PROC car0 ... init).  *NOTE*: the INIT argument is last, not first.
;;    I don't have any preference either way, but it's consistent with
;;    `fold[lr]' procedures from SRFI-1.  PROC is applied to successive
;;    elements of the given STREAM(s) and to the value of the previous
;;    invocation (INIT on the first invocation).  the last result from PROC
;;    is returned.
;;
;; (stream-for-each proc stream0 ...)
;;  - like `for-each' we all know and love.
;;
;; (stream-map proc stream0 ...)
;;  - like `map', except returns a stream of results, and not a list.

;; Code:

(define (make-stream m state)
  (delay
    (let ((o (m state)))
      (if (pair? o)
	  (cons (car o)
		(make-stream m (cdr o)))
          '()))))

(define (stream-car stream)
  "Returns the first element in STREAM.  This is equivalent to `car'."
  (car (force stream)))

(define (stream-cdr stream)
  "Returns the first tail of STREAM. Equivalent to `(force (cdr STREAM))'."
  (cdr (force stream)))

(define (stream-null? stream)
  "Returns `#t' if STREAM is the end-of-stream marker; otherwise
returns `#f'.  This is equivalent to `null?', but should be used
whenever testing for the end of a stream."
  (null? (force stream)))

(define (list->stream l)
  "Returns a newly allocated stream whose elements are the elements of
LIST.  Equivalent to `(apply stream LIST)'."
  (make-stream
   (lambda (l) l)
   l))

(define (vector->stream v)
  (make-stream
   (let ((len (vector-length v)))
     (lambda (i)
       (or (= i len)
           (cons (vector-ref v i) (+ 1 i)))))
   0))

(define (stream->reversed-list&length stream)
  (let loop ((s stream) (acc '()) (len 0))
    (if (stream-null? s)
        (values acc len)
        (loop (stream-cdr s) (cons (stream-car s) acc) (+ 1 len)))))

(define (stream->reversed-list stream)
  (call-with-values
   (lambda () (stream->reversed-list&length stream))
   (lambda (l len) l)))

(define (stream->list&length stream)
  (call-with-values
   (lambda () (stream->reversed-list&length stream))
   (lambda (l len) (values (reverse! l) len))))

(define (stream->list stream)
  "Returns a newly allocated list whose elements are the elements of STREAM.
If STREAM has infinite length this procedure will not terminate."
  (reverse! (stream->reversed-list stream)))

(define (stream->vector stream)
  (call-with-values
   (lambda () (stream->reversed-list&length stream))
   (lambda (l len)
     (let ((v (make-vector len)))
       (let loop ((i 0) (l l))
         (if (not (null? l))
             (begin
               (vector-set! v (- len i 1) (car l))
               (loop (+ 1 i) (cdr l)))))
       v))))

(define (stream-fold f init stream . rest)
  (if (null? rest) ;fast path
      (stream-fold-one f init stream)
      (stream-fold-many f init (cons stream rest))))

(define (stream-fold-one f r stream)
  (if (stream-null? stream)
      r
      (stream-fold-one f (f (stream-car stream) r) (stream-cdr stream))))

(define (stream-fold-many f r streams)
  (if (or-map stream-null? streams)
      r
      (stream-fold-many f
                        (apply f (let recur ((cars
                                              (map stream-car streams)))
                                   (if (null? cars)
                                       (list r)
                                       (cons (car cars)
                                             (recur (cdr cars))))))
                        (map stream-cdr streams))))

(define (stream-for-each f stream . rest)
  (if (null? rest) ;fast path
      (stream-for-each-one f stream)
      (stream-for-each-many f (cons stream rest))))

(define (stream-for-each-one f stream)
  (if (not (stream-null? stream))
      (begin
        (f (stream-car stream))
        (stream-for-each-one f (stream-cdr stream)))))

(define (stream-for-each-many f streams)
  (if (not (or-map stream-null? streams))
      (begin
        (apply f (map stream-car streams))
        (stream-for-each-many f (map stream-cdr streams)))))

(define (stream-map f stream . rest)
  "Returns a newly allocated stream, each element being the result of
invoking F with the corresponding elements of the STREAMs
as its arguments."
  (if (null? rest) ;fast path
      (make-stream (lambda (s)
                     (or (stream-null? s)
                         (cons (f (stream-car s)) (stream-cdr s))))
                   stream)
      (make-stream (lambda (streams)
                     (or (or-map stream-null? streams)
                         (cons (apply f (map stream-car streams))
                               (map stream-cdr streams))))
                   (cons stream rest))))

(define (port->stream port read)
  (make-stream (lambda (p)
                 (let ((o (read p)))
                   (or (eof-object? o)
                       (cons o p))))
               port))

;;; streams.scm ends here
