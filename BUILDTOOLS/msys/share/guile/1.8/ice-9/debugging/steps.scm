;;;; (ice-9 debugging steps) -- stepping through code from the debugger

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

(define-module (ice-9 debugging steps)
  #:use-module (ice-9 debugging traps)
  #:use-module (ice-9 and-let-star)
  #:use-module (ice-9 debugger)
  #:use-module (ice-9 optargs)
  #:export (at-exit
	    at-entry
	    at-apply
	    at-step
	    at-next))

;;; at-exit DEPTH BEHAVIOUR
;;;
;;; Install a behaviour to run when we exit the current frame.

(define (at-exit depth behaviour)
  (install-trap (make <exit-trap>
		  #:depth depth
		  #:single-shot #t
		  #:behaviour behaviour)))

;;; at-entry BEHAVIOUR [COUNT]
;;;
;;; Install a behaviour to run when we get to the COUNT'th next frame
;;; entry.  COUNT defaults to 1.

(define* (at-entry behaviour #:optional (count 1))
  (install-trap (make <entry-trap>
		  #:skip-count (- count 1)
		  #:single-shot #t
		  #:behaviour behaviour)))

;;; at-apply BEHAVIOUR [COUNT]
;;;
;;; Install a behaviour to run when we get to the COUNT'th next
;;; application.  COUNT defaults to 1.

(define* (at-apply behaviour #:optional (count 1))
  (install-trap (make <apply-trap>
		  #:skip-count (- count 1)
		  #:single-shot #t
		  #:behaviour behaviour)))

;;; at-step BEHAVIOUR [COUNT [FILENAME [DEPTH]]
;;;
;;; Install BEHAVIOUR to run on the COUNT'th next application, frame
;;; entry or frame exit.  COUNT defaults to 1.  If FILENAME is
;;; specified and not #f, only frames that begin in the named file are
;;; counted.

(define* (at-step behaviour #:optional (count 1) filename (depth 1000))
  (install-trap (make <step-trap>
		  #:file-name filename
		  #:exit-depth depth
		  #:skip-count (- count 1)
		  #:single-shot #t
		  #:behaviour behaviour)))

;;  (or count (set! count 1))
;;  (letrec ((proc (lambda (trap-context)
;;		   ;; Behaviour whenever we enter or exit a frame.
;;		   (set! count (- count 1))
;;		   (if (= count 0)
;;		       (begin
;;			 (remove-enter-frame-hook! step)
;;			 (remove-apply-frame-hook! step)
;;			 (behaviour trap-context)))))
;;	   (step (lambda (trap-context)
;;		   ;; Behaviour on frame entry: both execute the above
;;		   ;; and install it as an exit hook.
;;		   (if (or (not filename)
;;			   (equal? (frame-file-name (tc:frame trap-context))
;;                                   filename))
;;		       (begin
;;			 (proc trap-context)
;;			 (at-exit (tc:depth trap-context) proc))))))
;;    (at-exit depth proc)
;;    (add-enter-frame-hook! step)
;;    (add-apply-frame-hook! step)))

;;; at-next BEHAVIOUR [COUNT]
;;;
;;; Install a behaviour to run when we get to the COUNT'th next frame
;;; entry in the same source file as the current location.  COUNT
;;; defaults to 1.  If the current location has no filename, fall back
;;; silently to `at-entry' behaviour.

;;; (ice-9 debugging steps) ends here.
