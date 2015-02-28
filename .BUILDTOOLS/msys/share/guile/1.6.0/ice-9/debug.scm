;;;; 	Copyright (C) 1996, 1997, 1998, 1999, 2001 Free Software Foundation
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
;;;; As a special exception, the Free Software Foundation gives permission
;;;; for additional uses of the text contained in its release of GUILE.
;;;;
;;;; The exception is that, if you link the GUILE library with other files
;;;; to produce an executable, this does not by itself cause the
;;;; resulting executable to be covered by the GNU General Public License.
;;;; Your use of that executable is in no way restricted on account of
;;;; linking the GUILE library code into it.
;;;;
;;;; This exception does not however invalidate any other reasons why
;;;; the executable file might be covered by the GNU General Public License.
;;;;
;;;; This exception applies only to the code released by the
;;;; Free Software Foundation under the name GUILE.  If you copy
;;;; code from other Free Software Foundation releases into a copy of
;;;; GUILE, as the General Public License permits, the exception does
;;;; not apply to the code that you add in this way.  To avoid misleading
;;;; anyone as to the status of such modified files, you must delete
;;;; this exception notice from them.
;;;;
;;;; If you write modifications of your own for GUILE, it is your choice
;;;; whether to permit this exception to apply to your modifications.
;;;; If you do not wish that, delete this exception notice.
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



(debug-enable 'debug)
(read-enable 'positions)
