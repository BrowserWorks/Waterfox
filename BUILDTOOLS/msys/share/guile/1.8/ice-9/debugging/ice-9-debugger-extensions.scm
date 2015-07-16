
(define-module (ice-9 debugging ice-9-debugger-extensions)
  #:use-module (ice-9 debugger))

;;; Upgrade the debugger state object so that it can carry a flag
;;; indicating whether the debugging session is continuable.

(cond ((string>=? (version) "1.7")
       (use-modules (ice-9 debugger state))
       (define-module (ice-9 debugger state)))
      (else
       (define-module (ice-9 debugger))))

(set! state-rtd (make-record-type "debugger-state" '(stack index flags)))
(set! state? (record-predicate state-rtd))
(set! make-state
  (let ((make-state-internal (record-constructor state-rtd
						 '(stack index flags))))
    (lambda (stack index . flags)
      (make-state-internal stack index flags))))
(set! state-stack (record-accessor state-rtd 'stack))
(set! state-index (record-accessor state-rtd 'index))

(define state-flags (record-accessor state-rtd 'flags))

;;; Add commands that (ice-9 debugger) doesn't currently have, for
;;; continuing or single stepping program execution.

(cond ((string>=? (version) "1.7")
       (use-modules (ice-9 debugger command-loop))
       (define-module (ice-9 debugger command-loop)
	 #:use-module (ice-9 debugger)
	 #:use-module (ice-9 debugger state)
	 #:use-module (ice-9 debugging traps))
       (define new-define-command define-command)
       (set! define-command
	     (lambda (name argument-template documentation procedure)
	       (new-define-command name argument-template procedure))))
      (else
       (define-module (ice-9 debugger))))

(use-modules (ice-9 debugging steps))

(define (assert-continuable state)
  ;; Check that debugger is in a state where `continuing' makes sense.
  ;; If not, signal an error.
  (or (memq #:continuable (state-flags state))
      (user-error "This debug session is not continuable.")))

(define (debugger:continue state)
  "Tell the program being debugged to continue running.  (In fact this is
the same as the @code{quit} command, because it exits the debugger
command loop and so allows whatever code it was that invoked the
debugger to continue.)"
  (assert-continuable state)
  (throw 'exit-debugger))

(define (debugger:finish state)
  "Continue until evaluation of the current frame is complete, and
print the result obtained."
  (assert-continuable state)
  (at-exit (- (stack-length (state-stack state))
	      (state-index state))
	   (list trace-trap debug-trap))
  (debugger:continue state))

(define (debugger:step state n)
  "Tell the debugged program to do @var{n} more steps from its current
position.  One @dfn{step} means executing until the next frame entry
or exit of any kind.  @var{n} defaults to 1."
  (assert-continuable state)
  (at-step debug-trap (or n 1))
  (debugger:continue state))

(define (debugger:next state n)
  "Tell the debugged program to do @var{n} more steps from its current
position, but only counting frame entries and exits where the
corresponding source code comes from the same file as the current
stack frame.  (See @ref{Step Traps} for the details of how this
works.)  If the current stack frame has no source code, the effect of
this command is the same as of @code{step}.  @var{n} defaults to 1."
  (assert-continuable state)
  (at-step debug-trap
	   (or n 1)
	   (frame-file-name (stack-ref (state-stack state)
				       (state-index state)))
	   (if (memq #:return (state-flags state))
	       #f
	       (- (stack-length (state-stack state)) (state-index state))))
  (debugger:continue state))

(define-command "continue" '()
  "Continue program execution."
  debugger:continue)

(define-command "finish" '()
  "Continue until evaluation of the current frame is complete, and
print the result obtained."
  debugger:finish)

(define-command "step" '('optional exact-integer)
  "Continue until entry to @var{n}th next frame."
  debugger:step)

(define-command "next" '('optional exact-integer)
  "Continue until entry to @var{n}th next frame in same file."
  debugger:next)

;;; Export a couple of procedures for use by (ice-9 debugging trace).

(cond ((string>=? (version) "1.7"))
      (else
       (define-module (ice-9 debugger))
       (export write-frame-short/expression
	       write-frame-short/application)))

;;; Provide a `debug-trap' entry point in (ice-9 debugger).  This is
;;; designed so that it can be called to explore the stack at a
;;; breakpoint, and to single step from the breakpoint.

(define-module (ice-9 debugger))

(use-modules (ice-9 debugging traps))

(define *not-yet-introduced* #t)

(cond ((string>=? (version) "1.7"))
      (else
       (define (debugger-command-loop state)
	 (read-and-dispatch-commands state (current-input-port)))))

(define-public (debug-trap trap-context)
  "Invoke the Guile debugger to explore the stack at the specified @var{trap}."
  (start-stack 'debugger
	       (let* ((stack (tc:stack trap-context))
		      (flags1 (let ((trap-type (tc:type trap-context)))
				(case trap-type
				  ((#:return #:error)
				   (list trap-type
					 (tc:return-value trap-context)))
				  (else
				   (list trap-type)))))
		      (flags (if (tc:continuation trap-context)
				 (cons #:continuable flags1)
				 flags1))
		      (state (apply make-state stack 0 flags)))
		 (if *not-yet-introduced*
		     (let ((ssize (stack-length stack)))
		       (display "This is the Guile debugger -- for help, type `help'.\n")
		       (set! *not-yet-introduced* #f)
		       (if (= ssize 1)
			   (display "There is 1 frame on the stack.\n\n")
			   (format #t "There are ~A frames on the stack.\n\n" ssize))))
		 (write-state-short-with-source-location state)
		 (debugger-command-loop state))))

(define write-state-short-with-source-location
  (cond ((string>=? (version) "1.7")
	 write-state-short)
	(else
	 (lambda (state)
	   (let* ((frame (stack-ref (state-stack state) (state-index state)))
		  (source (frame-source frame))
		  (position (and source (source-position source))))
	     (format #t "Frame ~A at " (frame-number frame))
	     (if position
		 (display-position position)
		 (display "unknown source location"))
	     (newline)
	     (write-char #\tab)
	     (write-frame-short frame)
	     (newline))))))
