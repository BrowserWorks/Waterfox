;;;; (ice-9 debugger commands) -- debugger commands

;;; Copyright (C) 2002, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 debugger commands)
  #:use-module (ice-9 debug)
  #:use-module (ice-9 debugger)
  #:use-module (ice-9 debugger state)
  #:use-module (ice-9 debugger utils)
  #:export (backtrace
	    evaluate
	    info-args
	    info-frame
	    position
	    up
	    down
	    frame))

(define (backtrace state n-frames)
  "Print backtrace of all stack frames, or innermost COUNT frames.
With a negative argument, print outermost -COUNT frames.
If the number of frames isn't explicitly given, the debug option
`depth' determines the maximum number of frames printed."
  (let ((stack (state-stack state)))
    ;; Kludge around lack of call-with-values.
    (let ((values
	   (lambda (start end)
	     (display-backtrace stack
				(current-output-port)
				(if (memq 'backwards (debug-options))
				    start
				    (- end 1))
				(- end start))
	     )))
      (let ((end (stack-length stack)))
	(cond ((not n-frames) ;(>= (abs n-frames) end))
	       (values 0 (min end (cadr (memq 'depth (debug-options))))))
	      ((>= n-frames 0)
	       (values 0 n-frames))
	      (else
	       (values (+ end n-frames) end)))))))

(define (eval-handler key . args)
  (let ((stack (make-stack #t eval-handler)))
    (if (= (length args) 4)
	(apply display-error stack (current-error-port) args)
	;; We want display-error to be the "final common pathway"
	(catch #t
	       (lambda ()
		 (apply bad-throw key args))
	       (lambda (key . args)
		 (apply display-error stack (current-error-port) args)))))
  (throw 'continue))

(define (evaluate state expression)
  "Evaluate an expression in the environment of the selected stack frame.
The expression must appear on the same line as the command, however it
may be continued over multiple lines."
  (let ((source (frame-source (stack-ref (state-stack state)
					 (state-index state)))))
    (if (not source)
	(display "No environment for this frame.\n")
	(catch 'continue
	       (lambda ()
		 (lazy-catch #t
			     (lambda ()
			       (let* ((expr
				       ;; We assume that no one will
				       ;; really want to evaluate a
				       ;; string (since it is
				       ;; self-evaluating); so if we
				       ;; have a string here, read the
				       ;; expression to evaluate from
				       ;; it.
				       (if (string? expression)
					   (with-input-from-string expression
								   read)
					   expression))
				      (env (memoized-environment source))
				      (value (local-eval expr env)))
				 (write expr)
				 (display " => ")
				 (write value)
				 (newline)))
			     eval-handler))
	       (lambda args args)))))

(define (info-args state)
  "Display the argument variables of the current stack frame.
Arguments can also be seen in the backtrace, but are presented more
clearly by this command."
  (let ((index (state-index state)))
    (let ((frame (stack-ref (state-stack state) index)))
      (write-frame-index-long frame)
      (write-frame-args-long frame))))

(define (info-frame state)
  "Display a verbose description of the selected frame.  The
information that this command provides is equivalent to what can be
deduced from the one line summary for the frame that appears in a
backtrace, but is presented and explained more clearly."
  (write-state-long state))

(define (position state)
  "Display the name of the source file that the current expression
comes from, and the line and column number of the expression's opening
parenthesis within that file.  This information is only available when
the 'positions read option is enabled."
  (let* ((frame (stack-ref (state-stack state) (state-index state)))
	 (source (frame-source frame)))
    (if (not source)
	(display "No source available for this frame.")
	(let ((position (source-position source)))
	  (if (not position)
	      (display "No position information available for this frame.")
	      (display-position position)))))
  (newline))

(define (up state n)
  "Move @var{n} frames up the stack.  For positive @var{n}, this
advances toward the outermost frame, to lower frame numbers, to
frames that have existed longer.  @var{n} defaults to one."
  (set-stack-index! state (+ (state-index state) (or n 1)))
  (write-state-short state))

(define (down state n)
  "Move @var{n} frames down the stack.  For positive @var{n}, this
advances toward the innermost frame, to higher frame numbers, to frames
that were created more recently.  @var{n} defaults to one."
  (set-stack-index! state (- (state-index state) (or n 1)))
  (write-state-short state))

(define (frame state n)
  "Select and print a stack frame.
With no argument, print the selected stack frame.  (See also \"info frame\").
An argument specifies the frame to select; it must be a stack-frame number."
  (if n (set-stack-index! state (frame-number->index n (state-stack state))))
  (write-state-short state))

;;; (ice-9 debugger commands) ends here.
