;;;; 	Copyright (C) 1996, 1997, 1998, 1999, 2001, 2006 Free Software Foundation
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
;;;; The author can be reached at djurfeldt@nada.kth.se
;;;; Mikael Djurfeldt, SANS/NADA KTH, 10044 STOCKHOLM, SWEDEN
;;;;


(define-module (ice-9 debug)
  :export (frame-number->index trace untrace trace-stack untrace-stack))


;;; {Misc}
;;;
(define (frame-number->index n . stack)
  (let ((stack (if (null? stack)
		   (fluid-ref the-last-stack)
		   (car stack))))
    (if (memq 'backwards (debug-options))
	n
	(- (stack-length stack) n 1))))


;;; {Trace}
;;;
;;; This code is just an experimental prototype (e. g., it is not
;;; thread safe), but since it's at the same time useful, it's
;;; included anyway.
;;;
(define traced-procedures '())

(define (trace . args)
  (if (null? args)
      (nameify traced-procedures)
      (begin
	(for-each (lambda (proc)
		    (if (not (procedure? proc))
			(error "trace: Wrong type argument:" proc))
		    (set-procedure-property! proc 'trace #t)
		    (if (not (memq proc traced-procedures))
			(set! traced-procedures
			      (cons proc traced-procedures))))
		  args)
	(trap-set! apply-frame-handler trace-entry)
	(trap-set! exit-frame-handler trace-exit)
	;; We used to reset `trace-level' here to 0, but this is wrong
	;; if `trace' itself is being traced, since `trace-exit' will
	;; then decrement `trace-level' to -1!  It shouldn't actually
	;; be necessary to set `trace-level' here at all.
	(debug-enable 'trace)
	(nameify args))))

(define (untrace . args)
  (if (and (null? args)
	   (not (null? traced-procedures)))
      (apply untrace traced-procedures)
      (begin
	(for-each (lambda (proc)
		    (set-procedure-property! proc 'trace #f)
		    (set! traced-procedures (delq! proc traced-procedures)))
		  args)
	(if (null? traced-procedures)
	    (debug-disable 'trace))
	(nameify args))))

(define (nameify ls)
  (map (lambda (proc)
	 (let ((name (procedure-name proc)))
	   (or name proc)))
       ls))

(define trace-level 0)
(add-hook! abort-hook (lambda () (set! trace-level 0)))

(define traced-stack-ids (list 'repl-stack))
(define trace-all-stacks? #f)

(define (trace-stack id)
  "Add ID to the set of stack ids for which tracing is active.
If `#t' is in this set, tracing is active regardless of stack context.
To remove ID again, use `untrace-stack'.  If you add the same ID twice
using `trace-stack', you will need to remove it twice."
  (set! traced-stack-ids (cons id traced-stack-ids))
  (set! trace-all-stacks? (memq #t traced-stack-ids)))

(define (untrace-stack id)
  "Remove ID from the set of stack ids for which tracing is active."
  (set! traced-stack-ids (delq1! id traced-stack-ids))
  (set! trace-all-stacks? (memq #t traced-stack-ids)))

(define (trace-entry key cont tail)
  (if (or trace-all-stacks?
	  (memq (stack-id cont) traced-stack-ids))
      (let ((cep (current-error-port))
	    (frame (last-stack-frame cont)))
	(if (not tail)
	    (set! trace-level (+ trace-level 1)))
	(let indent ((n trace-level))
	  (cond ((> n 1) (display "|  " cep) (indent (- n 1)))))
	(display-application frame cep)
	(newline cep)))
  ;; It's not necessary to call the continuation since
  ;; execution will continue if the handler returns
  ;(cont #f)
  )

(define (trace-exit key cont retval)
  (if (or trace-all-stacks?
	  (memq (stack-id cont) traced-stack-ids))
      (let ((cep (current-error-port)))
	(set! trace-level (- trace-level 1))
	(let indent ((n trace-level))
	  (cond ((> n 0) (display "|  " cep) (indent (- n 1)))))
	(write retval cep)
	(newline cep))))


;;; A fix to get the error handling working together with the module system.
;;;
;;; XXX - Still needed?
(module-set! the-root-module 'debug-options debug-options)
