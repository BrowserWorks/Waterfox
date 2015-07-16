;;;; 	Copyright (C) 1996, 1998, 1999, 2001, 2006 Free Software Foundation, Inc.
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

;; This module is documented in the Guile Reference Manual.
;; Briefly, these are exported:
;;  procedures: expect-select, expect-regexec
;;   variables: expect-port, expect-timeout, expect-timeout-proc,
;;              expect-eof-proc, expect-char-proc,
;;              expect-strings-compile-flags, expect-strings-exec-flags,
;;      macros: expect, expect-strings

;;; Code:

(define-module (ice-9 expect)
  :use-module (ice-9 regex)
  :export-syntax (expect expect-strings)
  :export (expect-port expect-timeout expect-timeout-proc
	   expect-eof-proc expect-char-proc expect-strings-compile-flags
	   expect-strings-exec-flags expect-select expect-regexec))

;;; Expect: a macro for selecting actions based on what it reads from a port.
;;; The idea is from Don Libes' expect based on Tcl.
;;; This version by Gary Houston incorporating ideas from Aubrey Jaffer.


(define expect-port #f)
(define expect-timeout #f)
(define expect-timeout-proc #f)
(define expect-eof-proc #f)
(define expect-char-proc #f)

;;; expect: each test is a procedure which is applied to the accumulating
;;; string.
(defmacro expect clauses
  (let ((s (gensym))
	(c (gensym))
	(port (gensym))
	(timeout (gensym)))
    `(let ((,s "")
	   (,port (or expect-port (current-input-port)))
	   ;; when timeout occurs, in floating point seconds.
	   (,timeout (if expect-timeout
			 (let* ((secs-usecs (gettimeofday)))
			   (+ (car secs-usecs)
			      expect-timeout
			      (/ (cdr secs-usecs)
				 1000000))) ; one million.
			 #f)))
       (let next-char ()
	 (if (and expect-timeout
		  (not (expect-select ,port ,timeout)))
	     (if expect-timeout-proc
		 (expect-timeout-proc ,s)
		 #f)
	     (let ((,c (read-char ,port)))
	       (if expect-char-proc
		   (expect-char-proc ,c))
	       (if (not (eof-object? ,c))
		   (set! ,s (string-append ,s (string ,c))))
	       (cond
		;; this expands to clauses where the car invokes the
		;; match proc and the cdr is the return value from expect
		;; if the proc matched.
		,@(let next-expr ((tests (map car clauses))
				  (exprs (map cdr clauses))
				  (body '()))
		    (cond
		     ((null? tests)
		      (reverse body))
		     (else
		      (next-expr
		       (cdr tests)
		       (cdr exprs)
		       (cons
			`((,(car tests) ,s (eof-object? ,c))
			  ,@(cond ((null? (car exprs))
				   '())
				  ((eq? (caar exprs) '=>)
				   (if (not (= (length (car exprs))
					       2))
				       (scm-error 'misc-error
						  "expect"
						  "bad recipient: ~S"
						  (list (car exprs))
						  #f)
				       `((apply ,(cadar exprs)
						(,(car tests) ,s ,port)))))
				  (else
				   (car exprs))))
			body)))))
		;; if none of the clauses matched the current string.
		(else (cond ((eof-object? ,c)
			     (if expect-eof-proc
				 (expect-eof-proc ,s)
				 #f))
			    (else
			     (next-char)))))))))))


(define expect-strings-compile-flags regexp/newline)
(define expect-strings-exec-flags regexp/noteol)

;;; the regexec front-end to expect:
;;; each test must evaluate to a regular expression.
(defmacro expect-strings clauses
  `(let ,@(let next-test ((tests (map car clauses))
			  (exprs (map cdr clauses))
			  (defs '())
			  (body '()))
	    (cond ((null? tests)
		   (list (reverse defs) `(expect ,@(reverse body))))
		  (else
		   (let ((rxname (gensym)))
		     (next-test (cdr tests)
				(cdr exprs)
				(cons `(,rxname (make-regexp
						 ,(car tests)
						 expect-strings-compile-flags))
				      defs)
				(cons `((lambda (s eof?)
					  (expect-regexec ,rxname s eof?))
					,@(car exprs))
				      body))))))))

;;; simplified select: returns #t if input is waiting or #f if timed out or
;;; select was interrupted by a signal.
;;; timeout is an absolute time in floating point seconds.
(define (expect-select port timeout)
  (let* ((secs-usecs (gettimeofday))
	 (relative (- timeout
		      (car secs-usecs)
		      (/ (cdr secs-usecs)
			 1000000))))	; one million.
    (and (> relative 0)
	 (pair? (car (select (list port) '() '()
			     relative))))))

;;; match a string against a regexp, returning a list of strings (required
;;; by the => syntax) or #f.  called once each time a character is added
;;; to s (eof? will be #f), and once when eof is reached (with eof? #t).
(define (expect-regexec rx s eof?)
  ;; if expect-strings-exec-flags contains regexp/noteol,
  ;; remove it for the eof test.
  (let* ((flags (if (and eof?
			 (logand expect-strings-exec-flags regexp/noteol))
		    (logxor expect-strings-exec-flags regexp/noteol)
		    expect-strings-exec-flags))
	 (match (regexp-exec rx s 0 flags)))
    (if match
	(do ((i (- (match:count match) 1) (- i 1))
	     (result '() (cons (match:substring match i) result)))
	    ((< i 0) result))
	#f)))

;;; expect.scm ends here
