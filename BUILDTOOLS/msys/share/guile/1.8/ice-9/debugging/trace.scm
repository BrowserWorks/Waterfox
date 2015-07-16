;;;; (ice-9 debugging trace) -- breakpoint trace behaviour

;;; Copyright (C) 2002 Free Software Foundation, Inc.
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

(define-module (ice-9 debugging trace)
  #:use-module (ice-9 debug)
  #:use-module (ice-9 debugger)
  #:use-module (ice-9 debugging ice-9-debugger-extensions)
  #:use-module (ice-9 debugging steps)
  #:use-module (ice-9 debugging traps)
  #:export (trace-trap
	    trace-port
	    set-trace-layout
            trace/pid
            trace/stack-id
            trace/stack-depth
            trace/stack-real-depth
            trace/stack
            trace/source-file-name
            trace/source-line
            trace/source-column
            trace/source
            trace/type
            trace/real?
            trace/info
	    trace-at-exit
	    trace-until-exit))

(cond ((string>=? (version) "1.7")
       (use-modules (ice-9 debugger utils))))

(define trace-format-string #f)
(define trace-arg-procs #f)

(define (set-trace-layout format-string . arg-procs)
  (set! trace-format-string format-string)
  (set! trace-arg-procs arg-procs))

(define (trace/pid trap-context)
  (getpid))

(define (trace/stack-id trap-context)
  (stack-id (tc:stack trap-context)))

(define (trace/stack-depth trap-context)
  (tc:depth trap-context))

(define (trace/stack-real-depth trap-context)
  (tc:real-depth trap-context))

(define (trace/stack trap-context)
  (format #f "~a:~a+~a"
	  (stack-id (tc:stack trap-context))
	  (tc:real-depth trap-context)
	  (- (tc:depth trap-context) (tc:real-depth trap-context))))

(define (trace/source-file-name trap-context)
  (cond ((frame->source-position (tc:frame trap-context)) => car)
	(else "")))

(define (trace/source-line trap-context)
  (cond ((frame->source-position (tc:frame trap-context)) => cadr)
	(else 0)))

(define (trace/source-column trap-context)
  (cond ((frame->source-position (tc:frame trap-context)) => caddr)
	(else 0)))

(define (trace/source trap-context)
  (cond ((frame->source-position (tc:frame trap-context))
	 =>
	 (lambda (pos)
	   (format #f "~a:~a:~a" (car pos) (cadr pos) (caddr pos))))
	(else "")))

(define (trace/type trap-context)
  (case (tc:type trap-context)
    ((#:application) "APP")
    ((#:evaluation) "EVA")
    ((#:return) "RET")
    ((#:error) "ERR")
    (else "???")))

(define (trace/real? trap-context)
  (if (frame-real? (tc:frame trap-context)) " " "t"))

(define (trace/info trap-context)
  (with-output-to-string
    (lambda ()
      (if (memq (tc:type trap-context) '(#:application #:evaluation))
	  ((if (tc:expression trap-context)
	       write-frame-short/expression
	       write-frame-short/application) (tc:frame trap-context))
	  (begin
	    (display "=>")
	    (write (tc:return-value trap-context)))))))

(set-trace-layout "|~3@a: ~a\n" trace/stack-real-depth trace/info)

;;; trace-trap
;;;
;;; Trace the current location, and install a hook to trace the return
;;; value when we exit the current frame.

(define (trace-trap trap-context)
  (apply format
	 (trace-port)
	 trace-format-string
	 (map (lambda (arg-proc)
		(arg-proc trap-context))
	      trace-arg-procs)))

(set! (behaviour-ordering trace-trap) 50)

;;; trace-port
;;;
;;; The port to which trace information is printed.

(define trace-port
  (let ((port (current-output-port)))
    (make-procedure-with-setter
     (lambda () port)
     (lambda (new) (set! port new)))))

;;; trace-at-exit
;;;
;;; Trace return value on exit from the current frame.

(define (trace-at-exit trap-context)
  (at-exit (tc:depth trap-context) trace-trap))

;;; trace-until-exit
;;;
;;; Trace absolutely everything until exit from the current frame.

(define (trace-until-exit trap-context)
  (let ((step-trap (make <step-trap> #:behaviour trace-trap)))
    (install-trap step-trap)
    (at-exit (tc:depth trap-context)
	     (lambda (trap-context)
	       (uninstall-trap step-trap)))))

;;; (ice-9 debugging trace) ends here.
