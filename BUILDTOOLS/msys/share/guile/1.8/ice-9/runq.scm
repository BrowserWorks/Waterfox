;;;; runq.scm --- the runq data structure
;;;;
;;;; 	Copyright (C) 1996, 2001, 2006 Free Software Foundation, Inc.
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

;;; One way to schedule parallel computations in a serial environment is
;;; to explicitly divide each task up into small, finite execution time,
;;; strips.  Then you interleave the execution of strips from various
;;; tasks to achieve a kind of parallelism.  Runqs are a handy data
;;; structure for this style of programming.
;;;
;;; We use thunks (nullary procedures) and lists of thunks to represent
;;; strips.  By convention, the return value of a strip-thunk must either
;;; be another strip or the value #f.
;;;
;;; A runq is a procedure that manages a queue of strips.  Called with no
;;; arguments, it processes one strip from the queue.  Called with
;;; arguments, the arguments form a control message for the queue.  The
;;; first argument is a symbol which is the message selector.
;;;
;;; A strip is processed this way: If the strip is a thunk, the thunk is
;;; called -- if it returns a strip, that strip is added back to the
;;; queue.  To process a strip which is a list of thunks, the CAR of that
;;; list is called.  After a call to that CAR, there are 0, 1, or 2 strips
;;; -- perhaps one returned by the thunk, and perhaps the CDR of the
;;; original strip if that CDR is not nil.  The runq puts whichever of
;;; these strips exist back on the queue.  (The exact order in which
;;; strips are put back on the queue determines the scheduling behavior of
;;; a particular queue -- it's a parameter.)

;;; Code:

(define-module (ice-9 runq)
  :use-module (ice-9 q)
  :export (runq-control make-void-runq make-fair-runq
	   make-exclusive-runq make-subordinate-runq-to strip-sequence
	   fair-strip-subtask))

;;;;
;;; 	(runq-control q msg . args)
;;;
;;; 		processes in the default way the control messages that
;;; 		can be sent to a runq.  Q should be an ordinary
;;; 		Q (see utils/q.scm).
;;;
;;; 		The standard runq messages are:
;;;
;;; 		'add! strip0 strip1...		;; to enqueue one or more strips
;;; 		'enqueue! strip0 strip1...	;; to enqueue one or more strips
;;; 		'push! strip0 ...		;; add strips to the front of the queue
;;; 		'empty?				;; true if it is
;;; 		'length				;; how many strips in the queue?
;;; 		'kill!				;; empty the queue
;;; 		else				;; throw 'not-understood
;;;
(define (runq-control q msg . args)
  (case msg
    ((add!)			(for-each (lambda (t) (enq! q t)) args) '*unspecified*)
    ((enqueue!)			(for-each (lambda (t) (enq! q t)) args) '*unspecified*)
    ((push!)			(for-each (lambda (t) (q-push! q t)) args) '*unspecified*)
    ((empty?)			(q-empty? q))
    ((length)			(q-length q))
    ((kill!)			(set! q (make-q)))
    (else			(throw 'not-understood msg args))))

(define (run-strip thunk) (catch #t thunk (lambda ign (warn 'runq-strip thunk ign) #f)))

;;;;
;;; make-void-runq
;;;
;;; Make a runq that discards all messages except "length", for which
;;; it returns 0.
;;;
(define (make-void-runq)
  (lambda opts
    (and opts
	(apply-to-args opts
	  (lambda (msg . args)
	    (case msg
	      ((length)		0)
	      (else		#f)))))))

;;;;
;;; 	(make-fair-runq)
;;;
;;; 		Returns a runq procedure.
;;; 		Called with no arguments, the procedure processes one strip from the queue.
;;; 		Called with arguments, it uses runq-control.
;;;
;;; 		In a fair runq, if a strip returns a new strip X, X is added
;;; 		to the end of the queue, meaning it will be the last to execute
;;; 		of all the remaining procedures.
;;;
(define (make-fair-runq)
  (letrec ((q (make-q))
	   (self
	    (lambda ctl
	      (if ctl
		  (apply runq-control q ctl)
		  (and (not (q-empty? q))
		       (let ((next-strip (deq! q)))
			 (cond
			  ((procedure? next-strip)	(let ((k (run-strip next-strip)))
							  (and k (enq! q k))))
			  ((pair? next-strip) (let ((k (run-strip (car next-strip))))
						(and k (enq! q k)))
					      (if (not (null? (cdr next-strip)))
						  (enq! q (cdr next-strip)))))
			 self))))))
    self))


;;;;
;;; 	(make-exclusive-runq)
;;;
;;; 		Returns a runq procedure.
;;; 		Called with no arguments, the procedure processes one strip from the queue.
;;; 		Called with arguments, it uses runq-control.
;;;
;;; 		In an exclusive runq, if a strip W returns a new strip X, X is added
;;; 		to the front of the queue, meaning it will be the next to execute
;;; 		of all the remaining procedures.
;;;
;;; 		An exception to this occurs if W was the CAR of a list of strips.
;;; 		In that case, after the return value of W is pushed onto the front
;;; 	 	of the queue, the CDR of the list of strips is pushed in front
;;; 		of that (if the CDR is not nil).   This way, the rest of the thunks
;;; 		in the list that contained W have priority over the return value of W.
;;;
(define (make-exclusive-runq)
  (letrec ((q (make-q))
	   (self
	    (lambda ctl
	      (if ctl
		  (apply runq-control q ctl)
		  (and (not (q-empty? q))
		       (let ((next-strip (deq! q)))
			 (cond
			  ((procedure? next-strip)	(let ((k (run-strip next-strip)))
							  (and k (q-push! q k))))
			  ((pair? next-strip) (let ((k (run-strip (car next-strip))))
						(and k (q-push! q k)))
					      (if (not (null? (cdr next-strip)))
						  (q-push! q (cdr next-strip)))))
			 self))))))
    self))


;;;;
;;; 	(make-subordinate-runq-to superior basic-inferior)
;;;
;;; 		Returns a runq proxy for the runq basic-inferior.
;;;
;;; 		The proxy watches for operations on the basic-inferior that cause
;;; 		a transition from a queue length of 0 to a non-zero length and
;;; 		vice versa.   While the basic-inferior queue is not empty,
;;; 		the proxy installs a task on the superior runq.  Each strip
;;; 		of that task processes N strips from the basic-inferior where
;;; 		N is the length of the basic-inferior queue when the proxy
;;; 		strip is entered.  [Countless scheduling variations are possible.]
;;;
(define (make-subordinate-runq-to superior-runq basic-runq)
  (let ((runq-task (cons #f #f)))
    (set-car! runq-task
	      (lambda ()
		(if (basic-runq 'empty?)
		    (set-cdr! runq-task #f)
		    (do ((n (basic-runq 'length) (1- n)))
			((<= n 0)		 #f)
		      (basic-runq)))))
    (letrec ((self
	      (lambda ctl
		(if (not ctl)
		    (let ((answer (basic-runq)))
		      (self 'empty?)
		      answer)
		    (begin
		      (case (car ctl)
			((suspend)		(set-cdr! runq-task #f))
			(else		      	(let ((answer (apply basic-runq ctl)))
						  (if (and (not (cdr runq-task)) (not (basic-runq 'empty?)))
						      (begin
							(set-cdr! runq-task runq-task)
							(superior-runq 'add! runq-task)))
						  answer))))))))
      self)))

;;;;
;;;	(define fork-strips (lambda args args))
;;;		Return a strip that starts several strips in
;;;		parallel.   If this strip is enqueued on a fair
;;;		runq, strips of the parallel subtasks will run
;;;		round-robin style.
;;;
(define fork-strips (lambda args args))


;;;;
;;; 	(strip-sequence . strips)
;;;
;;; 		Returns a new strip which is the concatenation of the argument strips.
;;;
(define ((strip-sequence . strips))
  (let loop ((st (let ((a strips)) (set! strips #f) a)))
    (and (not (null? st))
	 (let ((then ((car st))))
	   (if then
	       (lambda () (loop (cons then (cdr st))))
	       (lambda () (loop (cdr st))))))))


;;;;
;;; 	(fair-strip-subtask . initial-strips)
;;;
;;; 		Returns a new strip which is the synchronos, fair,
;;; 		parallel execution of the argument strips.
;;;
;;;
;;;
(define (fair-strip-subtask . initial-strips)
  (let ((st (make-fair-runq)))
    (apply st 'add! initial-strips)
    st))

;;; runq.scm ends here
