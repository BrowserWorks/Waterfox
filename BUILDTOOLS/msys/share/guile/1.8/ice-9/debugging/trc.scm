;;;; (ice-9 debugging trc) -- tracing for Guile debugger code

;;; Copyright (C) 2002, 2004 Free Software Foundation, Inc.
;;;
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
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

(define-module (ice-9 debugging trc)
  #:export (trc trc-syms trc-all trc-none trc-add trc-remove trc-port))

(define *syms* #f)

(define (trc-set! syms)
  (set! *syms* syms))

(define (trc-syms . syms)
  (trc-set! syms))

(define (trc-all)
  (trc-set! #f))

(define (trc-none)
  (trc-set! '()))

(define (trc-add sym)
  (trc-set! (cons sym *syms*)))

(define (trc-remove sym)
  (trc-set! (delq1! sym *syms*)))

(define (trc sym . args)
  (if (or (not *syms*)
	  (memq sym *syms*))
      (let ((port (trc-port)))
	(write sym port)
	(display ":" port)
	(for-each (lambda (arg)
		    (display " " port)
		    (write arg port))
		  args)
	(newline port))))

(define trc-port
  (let ((port (current-error-port)))
    (make-procedure-with-setter
     (lambda () port)
     (lambda (p) (set! port p)))))

;; Default to no tracing.
(trc-none)

;;; (ice-9 debugging trc) ends here.
