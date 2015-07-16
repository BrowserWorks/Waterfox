;;;; 	Copyright (C) 1996, 1998, 2001, 2002, 2003, 2006 Free Software Foundation, Inc.
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
;;;; ----------------------------------------------------------------
;;;; threads.scm -- User-level interface to Guile's thread system
;;;; 4 March 1996, Anthony Green <green@cygnus.com>
;;;; Modified 5 October 1996, MDJ <djurfeldt@nada.kth.se>
;;;; Modified 6 April 2001, ttn
;;;; ----------------------------------------------------------------
;;;;

;;; Commentary:

;; This module is documented in the Guile Reference Manual.
;; Briefly, one procedure is exported: `%thread-handler';
;; as well as four macros: `make-thread', `begin-thread',
;; `with-mutex' and `monitor'.

;;; Code:

(define-module (ice-9 threads)
  :export (par-map
	   par-for-each
	   n-par-map
	   n-par-for-each
	   n-for-each-par-map
	   %thread-handler)
  :export-syntax (begin-thread
		  parallel
		  letpar
		  make-thread
		  with-mutex
		  monitor))



(define ((par-mapper mapper)  proc . arglists)
  (mapper join-thread
	  (apply map
		 (lambda args
		   (begin-thread (apply proc args)))
		 arglists)))

(define par-map (par-mapper map))
(define par-for-each (par-mapper for-each))

(define (n-par-map n proc . arglists)
  (let* ((m (make-mutex))
	 (threads '())
	 (results (make-list (length (car arglists))))
	 (result results))
    (do ((i 0 (+ 1 i)))
	((= i n)
	 (for-each join-thread threads)
	 results)
      (set! threads
	    (cons (begin-thread
		   (let loop ()
		     (lock-mutex m)
		     (if (null? result)
			 (unlock-mutex m)
			 (let ((args (map car arglists))
			       (my-result result))
			   (set! arglists (map cdr arglists))
			   (set! result (cdr result))
			   (unlock-mutex m)
			   (set-car! my-result (apply proc args))
			   (loop)))))
		  threads)))))

(define (n-par-for-each n proc . arglists)
  (let ((m (make-mutex))
	(threads '()))
    (do ((i 0 (+ 1 i)))
	((= i n)
	 (for-each join-thread threads))
      (set! threads
	    (cons (begin-thread
		   (let loop ()
		     (lock-mutex m)
		     (if (null? (car arglists))
			 (unlock-mutex m)
			 (let ((args (map car arglists)))
			   (set! arglists (map cdr arglists))
			   (unlock-mutex m)
			   (apply proc args)
			   (loop)))))
		  threads)))))

;;; The following procedure is motivated by the common and important
;;; case where a lot of work should be done, (not too much) in parallel,
;;; but the results need to be handled serially (for example when
;;; writing them to a file).
;;;
(define (n-for-each-par-map n s-proc p-proc . arglists)
  "Using N parallel processes, apply S-PROC in serial order on the results
of applying P-PROC on ARGLISTS."
  (let* ((m (make-mutex))
	 (threads '())
	 (no-result '(no-value))
	 (results (make-list (length (car arglists)) no-result))
	 (result results))
    (do ((i 0 (+ 1 i)))
	((= i n)
	 (for-each join-thread threads))
      (set! threads
	    (cons (begin-thread
		   (let loop ()
		     (lock-mutex m)
		     (cond ((null? results)
			    (unlock-mutex m))
			   ((not (eq? (car results) no-result))
			    (let ((arg (car results)))
			      ;; stop others from choosing to process results
			      (set-car! results no-result)
			      (unlock-mutex m)
			      (s-proc arg)
			      (lock-mutex m)
			      (set! results (cdr results))
			      (unlock-mutex m)
			      (loop)))
			   ((null? result)
			    (unlock-mutex m))
			   (else
			    (let ((args (map car arglists))
				  (my-result result))
			      (set! arglists (map cdr arglists))
			      (set! result (cdr result))
			      (unlock-mutex m)
			      (set-car! my-result (apply p-proc args))
			      (loop))))))
		  threads)))))

(define (thread-handler tag . args)
  (fluid-set! the-last-stack #f)
  (let ((n (length args))
	(p (current-error-port)))
    (display "In thread:" p)
    (newline p)
    (if (>= n 3)
        (display-error #f
                       p
                       (car args)
                       (cadr args)
                       (caddr args)
                       (if (= n 4)
                           (cadddr args)
                           '()))
        (begin
          (display "uncaught throw to " p)
          (display tag p)
          (display ": " p)
          (display args p)
          (newline p)))
    #f))

;;; Set system thread handler
(define %thread-handler thread-handler)

; --- MACROS -------------------------------------------------------

(define-macro (begin-thread . forms)
  (if (null? forms)
      '(begin)
      `(call-with-new-thread
	(lambda ()
	  ,@forms)
	%thread-handler)))

(define-macro (parallel . forms)
  (cond ((null? forms) '(values))
	((null? (cdr forms)) (car forms))
	(else
	 (let ((vars (map (lambda (f)
			    (make-symbol "f"))
			  forms)))
	   `((lambda ,vars
	       (values ,@(map (lambda (v) `(join-thread ,v)) vars)))
	     ,@(map (lambda (form) `(begin-thread ,form)) forms))))))

(define-macro (letpar bindings . body)
  (cond ((or (null? bindings) (null? (cdr bindings)))
	 `(let ,bindings ,@body))
	(else
	 (let ((vars (map car bindings)))
	   `((lambda ,vars
	       ((lambda ,vars ,@body)
		,@(map (lambda (v) `(join-thread ,v)) vars)))
	     ,@(map (lambda (b) `(begin-thread ,(cadr b))) bindings))))))

(define-macro (make-thread proc . args)
  `(call-with-new-thread
    (lambda ()
      (,proc ,@args))
    %thread-handler))

(define-macro (with-mutex m . body)
  `(dynamic-wind
       (lambda () (lock-mutex ,m))
       (lambda () (begin ,@body))
       (lambda () (unlock-mutex ,m))))

(define-macro (monitor first . rest)
  `(with-mutex ,(make-mutex)
     (begin
       ,first ,@rest)))

;;; threads.scm ends here
