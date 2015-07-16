;;;; Guile Debugger

;;; Copyright (C) 1999, 2001, 2002, 2006 Free Software Foundation, Inc.
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
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

(define-module (ice-9 debugger)
  #:use-module (ice-9 debugger command-loop)
  #:use-module (ice-9 debugger state)
  #:use-module (ice-9 debugger utils)
  #:use-module (ice-9 format)
  #:export (debug-stack
	    debug
	    debug-last-error
	    debugger-error
	    debugger-quit
	    debugger-input-port
	    debugger-output-port
	    debug-on-error)
  #:no-backtrace)

;;; The old (ice-9 debugger) has been factored into its constituent
;;; parts:
;;;
;;; (ice-9 debugger) - public interface to all of the following
;;;
;;; (... commands) - procedures implementing the guts of the commands
;;;                  provided by the interactive debugger
;;;
;;; (... command-loop) - binding these commands into the interactive
;;;                      debugger command loop
;;;
;;; (... state) - implementation of an object that tracks current
;;;               debugger state
;;;
;;; (... utils) - utilities for printing out frame and stack
;;;               information in various formats
;;;
;;; The division between (... commands) and (... command-loop) exists
;;; because I (NJ) have another generic command loop implementation
;;; under development, and I want to be able to switch easily between
;;; that and the command loop implementation here.  Thus the
;;; procedures in this file delegate to a debugger command loop
;;; implementation via the `debugger-command-loop-*' interface.  The
;;; (ice-9 debugger command-loop) implementation can be replaced by
;;; any other that implements the `debugger-command-loop-*' interface
;;; simply by changing the relevant #:use-module line above.
;;;
;;; - Neil Jerram <neil@ossau.uklinux.net> 2002-10-26, updated 2005-07-09

(define *not-yet-introduced* #t)

(define (debug-stack stack . flags)
  "Invoke the Guile debugger to explore the specified @var{stack}.

@var{flags}, if present, are keywords indicating characteristics of
the debugging session: the valid keywords are as follows.

@table @code
@item #:continuable
Indicates that the debugger is being invoked from a context (such as
an evaluator trap handler) where it is possible to return from the
debugger and continue normal code execution.  This enables the
@dfn{continuing execution} commands, for example @code{continue} and
@code{step}.

@item #:with-introduction
Indicates that the debugger should display an introductory message.
@end table"
  (start-stack 'debugger
    (let ((state (apply make-state stack 0 flags)))
      (with-input-from-port (debugger-input-port)
	(lambda ()
	  (with-output-to-port (debugger-output-port)
	    (lambda ()
	      (if (or *not-yet-introduced*
		      (memq #:with-introduction flags))
		  (let ((ssize (stack-length stack)))
		    (display "This is the Guile debugger -- for help, type `help'.\n")
		    (set! *not-yet-introduced* #f)
		    (if (= ssize 1)
			(display "There is 1 frame on the stack.\n\n")
			(format #t "There are ~A frames on the stack.\n\n" ssize))))
	      (write-state-short state)
	      (debugger-command-loop state))))))))

(define (debug)
  "Invoke the Guile debugger to explore the context of the last error."
  (let ((stack (fluid-ref the-last-stack)))
    (if stack
	(debug-stack stack)
	(display "Nothing to debug.\n"))))

(define debug-last-error debug)

(define (debugger-error message)
  "Signal a debugger usage error with message @var{message}."
  (debugger-command-loop-error message))

(define (debugger-quit)
  "Exit the debugger."
  (debugger-command-loop-quit))

;;; {Debugger Input and Output Ports}

(define debugger-input-port
  (let ((input-port (current-input-port)))
    (make-procedure-with-setter
     (lambda () input-port)
     (lambda (port) (set! input-port port)))))

(define debugger-output-port
  (let ((output-port (current-output-port)))
    (make-procedure-with-setter
     (lambda () output-port)
     (lambda (port) (set! output-port port)))))

;;; {Debug on Error}

(define (debug-on-error syms)
  "Enable or disable debug on error."
  (set! lazy-handler-dispatch
	(if syms
	    (lambda (key . args)
	      (if (memq key syms)
		  (begin
		    (debug-stack (make-stack #t lazy-handler-dispatch)
				 #:with-introduction
				 #:continuable)
		    (throw 'abort key)))
	      (apply default-lazy-handler key args))
	    default-lazy-handler)))

;;; (ice-9 debugger) ends here.
