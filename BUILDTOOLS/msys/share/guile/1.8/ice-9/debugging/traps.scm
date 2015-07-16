;;;; (ice-9 debugging traps) -- abstraction of libguile's traps interface

;;; Copyright (C) 2002, 2004 Free Software Foundation, Inc.
;;; Copyright (C) 2005 Neil Jerram
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

;;; This module provides an abstraction around Guile's low level trap
;;; handler interface; its aim is to make the low level trap mechanism
;;; shareable between the debugger and other applications, and to
;;; insulate the rest of the debugger code a bit from changes that may
;;; occur in the low level trap interface in future.

(define-module (ice-9 debugging traps)
  #:use-module (ice-9 regex)
  #:use-module (oop goops)
  #:use-module (oop goops describe)
  #:use-module (ice-9 debugging trc)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-2)
  #:export (tc:type
            tc:continuation
            tc:expression
            tc:return-value
            tc:stack
            tc:frame
            tc:depth
            tc:real-depth
            tc:exit-depth
	    tc:fired-traps
	    ;; Interface for users of <trap> subclasses defined in
	    ;; this module.
            add-trapped-stack-id!
	    remove-trapped-stack-id!
	    <procedure-trap>
	    <exit-trap>
	    <entry-trap>
	    <apply-trap>
	    <step-trap>
	    <source-trap>
	    <location-trap>
	    install-trap
	    uninstall-trap
            all-traps
            get-trap
	    list-traps
	    trap-ordering
            behaviour-ordering
	    throw->trap-context
	    on-lazy-handler-dispatch
	    ;; Interface for authors of new <trap> subclasses.
	    <trap-context>
	    <trap>
	    trap->behaviour
	    trap-runnable?
	    install-apply-frame-trap
	    install-breakpoint-trap
	    install-enter-frame-trap
	    install-exit-frame-trap
	    install-trace-trap
	    uninstall-apply-frame-trap
	    uninstall-breakpoint-trap
	    uninstall-enter-frame-trap
	    uninstall-exit-frame-trap
	    uninstall-trace-trap
	    frame->source-position
	    frame-file-name
	    without-traps
            guile-trap-features)
  #:re-export (make)
  #:export-syntax (trap-here))

;; How to debug the debugging infrastructure, when needed.  Grep for
;; "(trc " to find other symbols that can be passed to trc-add.
;; (trc-add 'after-gc-hook)

;; In Guile 1.7 onwards, weak-vector and friends are provided by the
;; (ice-9 weak-vector) module.
(cond ((string>=? (version) "1.7")
       (use-modules (ice-9 weak-vector))))

;;; The current low level traps interface is as follows.
;;;
;;; All trap handlers are subject to SCM_TRAPS_P, which is controlled
;;; by the `traps' setting of `(evaluator-traps-interface)' but also
;;; (and more relevant in most cases) by the `with-traps' procedure.
;;; Basically, `with-traps' sets SCM_TRAPS_P to 1 during execution of
;;; its thunk parameter.
;;;
;;; Note that all trap handlers are called with SCM_TRAPS_P set to 0
;;; for the duration of the call, to avoid nasty recursive trapping
;;; loops.  If a trap handler knows what it is doing, it can override
;;; this by `(trap-enable traps)'.
;;;
;;; The apply-frame handler is called when Guile is about to perform
;;; an application if EITHER the `apply-frame' evaluator trap option
;;; is set, OR the `trace' debug option is set and the procedure to
;;; apply has its `trace' procedure property set.  The arguments
;;; passed are:
;;;
;;; - the symbol 'apply-frame
;;;
;;; - a continuation or debug object describing the current stack
;;;
;;; - a boolean indicating whether the application is tail-recursive.
;;;
;;; The enter-frame handler is called when the evaluator begins a new
;;; evaluation frame if EITHER the `enter-frame' evaluator trap option
;;; is set, OR the `breakpoints' debug option is set and the code to
;;; be evaluated has its `breakpoint' source property set.  The
;;; arguments passed are:
;;;
;;; - the symbol 'enter-frame
;;;
;;; - a continuation or debug object describing the current stack
;;;
;;; - a boolean indicating whether the application is tail-recursive.
;;;
;;; - an unmemoized copy of the expression to be evaluated.
;;;
;;; If the `enter-frame' evaluator trap option is set, the enter-frame
;;; handler is also called when about to perform an application in
;;; SCM_APPLY, immediately before possibly calling the apply-frame
;;; handler.  (I don't totally understand this.)  In this case, the
;;; arguments passed are:
;;;
;;; - the symbol 'enter-frame
;;;
;;; - a continuation or debug object describing the current stack.
;;;
;;; The exit-frame handler is called when Guile exits an evaluation
;;; frame (in SCM_CEVAL) or an application frame (in SCM_APPLY), if
;;; EITHER the `exit-frame' evaluator trap option is set, OR the
;;; `trace' debug option is set and the frame is marked as having been
;;; traced.  The frame will be marked as having been traced if the
;;; apply-frame handler was called for this frame.  (This is trickier
;;; than it sounds because of tail recursion: the same debug frame
;;; could have been used for multiple applications, only some of which
;;; were traced - I think.)  The arguments passed are:
;;;
;;; - the symbol 'exit-frame
;;;
;;; - a continuation or debug object describing the current stack
;;;
;;; - the result of the evaluation or application.

;;; {Trap Context}
;;;
;;; A trap context is a GOOPS object that encapsulates all the useful
;;; information about a particular trap.  Encapsulating this
;;; information in a single object also allows us:
;;;
;;; - to defer the calculation of information that is time-consuming
;;; to calculate, such as the stack, and to cache such information so
;;; that it is only ever calculated once per trap
;;;
;;; - to pass all interesting information to trap behaviour procedures
;;; in a single parameter, which (i) is convenient and (ii) makes for
;;; a more future-proof interface.
;;;
;;; It also allows us - where very carefully documented! - to pass
;;; information from one behaviour procedure to another.

(define-class <trap-context> ()
  ;; Information provided directly by the trap calls from the
  ;; evaluator.  The "type" slot holds a keyword indicating the type
  ;; of the trap: one of #:evaluation, #:application, #:return,
  ;; #:error.
  (type #:getter tc:type
        #:init-keyword #:type)
  ;; The "continuation" slot holds the continuation (or debug object,
  ;; if "cheap" traps are enabled, which is the default) at the point
  ;; of the trap.  For an error trap it is #f.
  (continuation #:getter tc:continuation
                #:init-keyword #:continuation)
  ;; The "expression" slot holds the source code expression, for an
  ;; evaluation trap.
  (expression #:getter tc:expression
              #:init-keyword #:expression
              #:init-value #f)
  ;; The "return-value" slot holds the return value, for a return
  ;; trap, or the error args, for an error trap.
  (return-value #:getter tc:return-value
                #:init-keyword #:return-value
                #:init-value #f)
  ;; The list of trap objects which fired in this trap context.
  (fired-traps #:getter tc:fired-traps
	       #:init-value '())
  ;; The set of symbols which, if one of them is set in the CAR of the
  ;; handler-return-value slot, will cause the CDR of that slot to
  ;; have an effect.
  (handler-return-syms #:init-value '())
  ;; The value which the trap handler should return to the evaluator.
  (handler-return-value #:init-value #f)
  ;; Calculated and cached information.  "stack" is the stack
  ;; (computed from the continuation (or debug object) by make-stack,
  ;; or else (in the case of an error trap) by (make-stack #t ...).
  (stack #:init-value #f)
  (frame #:init-value #f)
  (depth #:init-value #f)
  (real-depth #:init-value #f)
  (exit-depth #:init-value #f))

(define-method (tc:stack (ctx <trap-context>))
  (or (slot-ref ctx 'stack)
      (let ((stack (make-stack (tc:continuation ctx))))
        (slot-set! ctx 'stack stack)
        stack)))

(define-method (tc:frame (ctx <trap-context>))
  (or (slot-ref ctx 'frame)
      (let ((frame (cond ((tc:continuation ctx) => last-stack-frame)
			 (else (stack-ref (tc:stack ctx) 0)))))
        (slot-set! ctx 'frame frame)
        frame)))

(define-method (tc:depth (ctx <trap-context>))
  (or (slot-ref ctx 'depth)
      (let ((depth (stack-length (tc:stack ctx))))
        (slot-set! ctx 'depth depth)
        depth)))

(define-method (tc:real-depth (ctx <trap-context>))
  (or (slot-ref ctx 'real-depth)
      (let* ((stack (tc:stack ctx))
	     (real-depth (apply +
				(map (lambda (i)
				       (if (frame-real? (stack-ref stack i))
					   1
					   0))
				     (iota (tc:depth ctx))))))
        (slot-set! ctx 'real-depth real-depth)
        real-depth)))

(define-method (tc:exit-depth (ctx <trap-context>))
  (or (slot-ref ctx 'exit-depth)
      (let* ((stack (tc:stack ctx))
	     (depth (tc:depth ctx))
	     (exit-depth (let loop ((exit-depth depth))
			   (if (or (zero? exit-depth)
				   (frame-real? (stack-ref stack
							   (- depth
							      exit-depth))))
			       exit-depth
			       (loop (- exit-depth 1))))))
	(slot-set! ctx 'exit-depth exit-depth)
        exit-depth)))

;;; {Stack IDs}
;;;
;;; Mechanism for limiting trapping to contexts whose stack ID matches
;;; one of a registered set.  The default is for traps to fire
;;; regardless of stack ID.

(define trapped-stack-ids (list #t))
(define all-stack-ids-trapped? #t)

(define (add-trapped-stack-id! id)
  "Add ID to the set of stack ids for which traps are active.
If `#t' is in this set, traps are active regardless of stack context.
To remove ID again, use `remove-trapped-stack-id!'.  If you add the
same ID twice using `add-trapped-stack-id!', you will need to remove
it twice."
  (set! trapped-stack-ids (cons id trapped-stack-ids))
  (set! all-stack-ids-trapped? (memq #t trapped-stack-ids)))

(define (remove-trapped-stack-id! id)
  "Remove ID from the set of stack ids for which traps are active."
  (set! trapped-stack-ids (delq1! id trapped-stack-ids))
  (set! all-stack-ids-trapped? (memq #t trapped-stack-ids)))

(define (trap-here? cont)
  ;; Return true if the stack id of the specified continuation (or
  ;; debug object) is in the set that we should trap for; otherwise
  ;; false.
  (or all-stack-ids-trapped?
      (memq (stack-id cont) trapped-stack-ids)))

;;; {Global State}
;;;
;;; Variables tracking registered handlers, relevant procedures, and
;;; what's turned on as regards the evaluator's debugging options.

(define enter-frame-traps '())
(define apply-frame-traps '())
(define exit-frame-traps '())
(define breakpoint-traps '())
(define trace-traps '())

(define (non-null? hook)
  (not (null? hook)))

;; The low level frame handlers must all be initialized to something
;; harmless.  Otherwise we hit a problem immediately when trying to
;; enable one of these handlers.
(trap-set! enter-frame-handler noop)
(trap-set! apply-frame-handler noop)
(trap-set! exit-frame-handler noop)

(define set-debug-and-trap-options
  (let ((dopts (debug-options))
	(topts (evaluator-traps-interface))
	(setting (lambda (key opts)
		   (let ((l (memq key opts)))
		     (and l
			  (not (null? (cdr l)))
			  (cadr l)))))
	(debug-set-boolean! (lambda (key value)
			      ((if value debug-enable debug-disable) key)))
	(trap-set-boolean! (lambda (key value)
			     ((if value trap-enable trap-disable) key))))
    (let ((save-debug (memq 'debug dopts))
	  (save-trace (memq 'trace dopts))
	  (save-breakpoints (memq 'breakpoints dopts))
	  (save-enter-frame (memq 'enter-frame topts))
	  (save-apply-frame (memq 'apply-frame topts))
	  (save-exit-frame (memq 'exit-frame topts))
	  (save-enter-frame-handler (setting 'enter-frame-handler topts))
	  (save-apply-frame-handler (setting 'apply-frame-handler topts))
	  (save-exit-frame-handler (setting 'exit-frame-handler topts)))
      (lambda ()
	(let ((need-trace (non-null? trace-traps))
	      (need-breakpoints (non-null? breakpoint-traps))
	      (need-enter-frame (non-null? enter-frame-traps))
	      (need-apply-frame (non-null? apply-frame-traps))
	      (need-exit-frame (non-null? exit-frame-traps)))
	  (debug-set-boolean! 'debug
			      (or need-trace
				  need-breakpoints
				  need-enter-frame
				  need-apply-frame
				  need-exit-frame
				  save-debug))
	  (debug-set-boolean! 'trace
			      (or need-trace
				  save-trace))
	  (debug-set-boolean! 'breakpoints
			      (or need-breakpoints
				  save-breakpoints))
	  (trap-set-boolean! 'enter-frame
			     (or need-enter-frame
				 save-enter-frame))
	  (trap-set-boolean! 'apply-frame
			     (or need-apply-frame
				 save-apply-frame))
	  (trap-set-boolean! 'exit-frame
			     (or need-exit-frame
				 save-exit-frame))
	  (trap-set! enter-frame-handler
		     (cond ((or need-breakpoints
				need-enter-frame)
			    enter-frame-handler)
			   (else save-enter-frame-handler)))
	  (trap-set! apply-frame-handler
		     (cond ((or need-trace
				need-apply-frame)
			    apply-frame-handler)
			   (else save-apply-frame-handler)))
	  (trap-set! exit-frame-handler
		     (cond ((or need-exit-frame)
			    exit-frame-handler)
			   (else save-exit-frame-handler))))
	;;(write (evaluator-traps-interface))
	*unspecified*))))

(define (enter-frame-handler key cont . args)
  ;; For a non-application entry, ARGS is (TAIL? EXP), where EXP is an
  ;; unmemoized copy of the source expression.  For an application
  ;; entry, ARGS is empty.
  (if (trap-here? cont)
      (let* ((application-entry? (null? args))
             (trap-context (make <trap-context>
                             #:type #:evaluation
                             #:continuation cont
                             #:expression (if application-entry?
                                              #f
                                              (cadr args)))))
	(trc 'enter-frame-handler)
	(if (and (not application-entry?)
                 (memq 'tweaking guile-trap-features))
	    (slot-set! trap-context 'handler-return-syms '(instead)))
        (run-traps (if application-entry?
		       enter-frame-traps
		       (append enter-frame-traps breakpoint-traps))
		   trap-context)
	(slot-ref trap-context 'handler-return-value))))

(define (apply-frame-handler key cont tail?)
  (if (trap-here? cont)
      (let ((trap-context (make <trap-context>
                            #:type #:application
                            #:continuation cont)))
	(trc 'apply-frame-handler tail?)
        (run-traps (append apply-frame-traps trace-traps) trap-context)
	(slot-ref trap-context 'handler-return-value))))

(define (exit-frame-handler key cont retval)
  (if (trap-here? cont)
      (let ((trap-context (make <trap-context>
                            #:type #:return
                            #:continuation cont
                            #:return-value retval)))
	(trc 'exit-frame-handler retval (tc:depth trap-context))
	(if (memq 'tweaking guile-trap-features)
            (slot-set! trap-context 'handler-return-syms '(instead)))
        (run-traps exit-frame-traps trap-context)
	(slot-ref trap-context 'handler-return-value))))

(define-macro (trap-installer trap-list)
  `(lambda (trap)
     (set! ,trap-list (cons trap ,trap-list))
     (set-debug-and-trap-options)))

(define install-enter-frame-trap (trap-installer enter-frame-traps))
(define install-apply-frame-trap (trap-installer apply-frame-traps))
(define install-exit-frame-trap (trap-installer exit-frame-traps))
(define install-breakpoint-trap (trap-installer breakpoint-traps))
(define install-trace-trap (trap-installer trace-traps))

(define-macro (trap-uninstaller trap-list)
  `(lambda (trap)
     (or (memq trap ,trap-list)
         (error "Trap list does not include the specified trap"))
     (set! ,trap-list (delq1! trap ,trap-list))
     (set-debug-and-trap-options)))

(define uninstall-enter-frame-trap (trap-uninstaller enter-frame-traps))
(define uninstall-apply-frame-trap (trap-uninstaller apply-frame-traps))
(define uninstall-exit-frame-trap (trap-uninstaller exit-frame-traps))
(define uninstall-breakpoint-trap (trap-uninstaller breakpoint-traps))
(define uninstall-trace-trap (trap-uninstaller trace-traps))

(define trap-ordering (make-object-property))
(define behaviour-ordering (make-object-property))

(define (run-traps traps trap-context)
  (let ((behaviours (apply append
			   (map (lambda (trap)
				  (trap->behaviour trap trap-context))
				(sort traps
				      (lambda (t1 t2)
					(< (or (trap-ordering t1) 0)
					   (or (trap-ordering t2) 0))))))))
    (for-each (lambda (proc)
		(proc trap-context))
	      (sort (delete-duplicates behaviours)
		    (lambda (b1 b2)
                    (< (or (behaviour-ordering b1) 0)
                       (or (behaviour-ordering b2) 0)))))))

;;; {Pseudo-Traps for Non-Trap Events}

;;; Once there is a body of code to do with responding to (debugging,
;;; tracing, etc.) traps, it makes sense to be able to leverage that
;;; same code for certain events that are trap-like, but not actually
;;; traps in the sense of the calls made by libguile's evaluator.

;;; The main example of this is when an error is signalled.  Guile
;;; doesn't yet have a 100% reliable way of hooking into errors, but
;;; in practice most errors go through a lazy-catch whose handler is
;;; lazy-handler-dispatch (defined in ice-9/boot-9.scm), which in turn
;;; calls default-lazy-handler.  So we can present most errors as
;;; pseudo-traps by modifying default-lazy-handler.

(define default-default-lazy-handler default-lazy-handler)

(define (throw->trap-context key args . stack-args)
  (let ((ctx (make <trap-context>
	       #:type #:error
	       #:continuation #f
	       #:return-value (cons key args))))
    (slot-set! ctx 'stack
	       (let ((caller-stack (and (= (length stack-args) 1)
					(car stack-args))))
		 (if (stack? caller-stack)
		     caller-stack
		     (apply make-stack #t stack-args))))
    ctx))

(define (on-lazy-handler-dispatch behaviour . ignored-keys)
  (set! default-lazy-handler
	(if behaviour
	    (lambda (key . args)
	      (or (memq key ignored-keys)
		  (behaviour (throw->trap-context key
						  args
						  lazy-handler-dispatch)))
	      (apply default-default-lazy-handler key args))
	    default-default-lazy-handler)))

;;; {Trap Classes}

;;; Class: <trap>
;;;
;;; <trap> is the base class for traps.  Any actual trap should be an
;;; instance of a class derived from <trap>, not of <trap> itself,
;;; because there is no base class method for the install-trap,
;;; trap-runnable? and uninstall-trap GFs.
(define-class <trap> ()
  ;; "number" slot: the number of this trap (assigned automatically).
  (number)
  ;; "installed" slot: whether this trap is installed.
  (installed #:init-value #f)
  ;; "condition" slot: if non-#f, this is a thunk which is called when
  ;; the trap fires, to determine whether trap processing should
  ;; proceed any further.
  (condition #:init-value #f #:init-keyword #:condition)
  ;; "skip-count" slot: a count of valid (after "condition"
  ;; processing) firings of this trap to skip.
  (skip-count #:init-value 0 #:init-keyword #:skip-count)
  ;; "single-shot" slot: if non-#f, this trap is removed after it has
  ;; successfully fired (after "condition" and "skip-count"
  ;; processing) for the first time.
  (single-shot #:init-value #f #:init-keyword #:single-shot)
  ;; "behaviour" slot: procedure or list of procedures to call
  ;; (passing the trap context as parameter) if we finally decide
  ;; (after "condition" and "skip-count" processing) to run this
  ;; trap's behaviour.
  (behaviour #:init-value '() #:init-keyword #:behaviour)
  ;; "repeat-identical-behaviour" slot: normally, if multiple <trap>
  ;; objects are triggered by the same low level trap, and they
  ;; request the same behaviour, it's only useful to do that behaviour
  ;; once (per low level trap); so by default multiple requests for
  ;; the same behaviour are coalesced.  If this slot is non-#f, the
  ;; contents of the "behaviour" slot are uniquified so that they
  ;; avoid being coalesced in this way.
  (repeat-identical-behaviour #:init-value #f
			      #:init-keyword #:repeat-identical-behaviour)
  ;; "observer" slot: this is a procedure that is called with one
  ;; EVENT argument when the trap status changes in certain
  ;; interesting ways, currently the following.  (1) When the trap is
  ;; uninstalled because of the target becoming inaccessible; EVENT in
  ;; this case is 'target-gone.
  (observer #:init-value #f #:init-keyword #:observer))

(define last-assigned-trap-number 0)
(define all-traps (make-weak-value-hash-table 7))

(define-method (initialize (trap <trap>) initargs)
  (next-method)
  ;; Assign a trap number, and store in the hash of all traps.
  (set! last-assigned-trap-number (+ last-assigned-trap-number 1))
  (slot-set! trap 'number last-assigned-trap-number)
  (hash-set! all-traps last-assigned-trap-number trap)
  ;; Listify the behaviour slot, if not a list already.
  (let ((behaviour (slot-ref trap 'behaviour)))
    (if (procedure? behaviour)
	(slot-set! trap 'behaviour (list behaviour)))))

(define-generic install-trap)		; provided mostly by subclasses
(define-generic uninstall-trap)		; provided mostly by subclasses
(define-generic trap->behaviour)	; provided by <trap>
(define-generic trap-runnable?)		; provided by subclasses

(define-method (install-trap (trap <trap>))
  (if (slot-ref trap 'installed)
      (error "Trap is already installed"))
  (slot-set! trap 'installed #t))

(define-method (uninstall-trap (trap <trap>))
  (or (slot-ref trap 'installed)
      (error "Trap is not installed"))
  (slot-set! trap 'installed #f))

;;; uniquify-behaviour
;;;
;;; Uniquify BEHAVIOUR by wrapping it in a new lambda.
(define (uniquify-behaviour behaviour)
  (lambda (trap-context)
    (behaviour trap-context)))

;;; trap->behaviour
;;;
;;; If TRAP is runnable, given TRAP-CONTEXT, return a list of
;;; behaviour procs to call with TRAP-CONTEXT as a parameter.
;;; Otherwise return the empty list.
(define-method (trap->behaviour (trap <trap>) (trap-context <trap-context>))
  (if (and
       ;; Check that the trap is runnable.  Runnability is implemented
       ;; by the subclass and allows us to check, for example, that
       ;; the procedure being applied in an apply-frame trap matches
       ;; this trap's procedure.
       (trap-runnable? trap trap-context)
       ;; Check the additional condition, if specified.
       (let ((condition (slot-ref trap 'condition)))
	 (or (not condition)
	     ((condition))))
       ;; Check for a skip count.
       (let ((skip-count (slot-ref trap 'skip-count)))
	 (if (zero? skip-count)
	     #t
	     (begin
	       (slot-set! trap 'skip-count (- skip-count 1))
	       #f))))
      ;; All checks passed, so we will return the contents of this
      ;; trap's behaviour slot.
      (begin
	;; First, though, remove this trap if its single-shot slot
	;; indicates that it should fire only once.
	(if (slot-ref trap 'single-shot)
	    (uninstall-trap trap))
	;; Add this trap object to the context's list of traps which
	;; fired here.
	(slot-set! trap-context 'fired-traps
		   (cons trap (tc:fired-traps trap-context)))
	;; Return trap behaviour, uniquified if necessary.
	(if (slot-ref trap 'repeat-identical-behaviour)
	    (map uniquify-behaviour (slot-ref trap 'behaviour))
	    (slot-ref trap 'behaviour)))
      '()))

;;; Class: <procedure-trap>
;;;
;;; An installed instance of <procedure-trap> triggers on invocation
;;; of a specific procedure.
(define-class <procedure-trap> (<trap>)
  ;; "procedure" slot: the procedure to trap on.  This is implemented
  ;; virtually, using the following weak vector slot, so as to avoid
  ;; this trap preventing the GC of the target procedure.
  (procedure #:init-keyword #:procedure
	     #:allocation #:virtual
	     #:slot-ref
	     (lambda (trap)
	       (vector-ref (slot-ref trap 'procedure-wv) 0))
	     #:slot-set!
	     (lambda (trap proc)
	       (if (slot-bound? trap 'procedure-wv)
		   (vector-set! (slot-ref trap 'procedure-wv) 0 proc)
		   (slot-set! trap 'procedure-wv (weak-vector proc)))))
  (procedure-wv))

;; Customization of the initialize method: set up to handle what
;; should happen when the procedure is GC'd.
(define-method (initialize (trap <procedure-trap>) initargs)
  (next-method)
  (let* ((proc (slot-ref trap 'procedure))
	 (existing-traps (volatile-target-traps proc)))
    ;; If this is the target's first trap, give the target procedure
    ;; to the volatile-target-guardian, so we can find out if it
    ;; becomes inaccessible.
    (or existing-traps (volatile-target-guardian proc))
    ;; Add this trap to the target procedure's list of traps.
    (set! (volatile-target-traps proc)
	  (cons trap (or existing-traps '())))))

(define procedure-trace-count (make-object-property))

(define-method (install-trap (trap <procedure-trap>))
  (next-method)
  (let* ((proc (slot-ref trap 'procedure))
         (trace-count (or (procedure-trace-count proc) 0)))
    (set-procedure-property! proc 'trace #t)
    (set! (procedure-trace-count proc) (+ trace-count 1)))
  (install-trace-trap trap))

(define-method (uninstall-trap (trap <procedure-trap>))
  (next-method)
  (let* ((proc (slot-ref trap 'procedure))
         (trace-count (or (procedure-trace-count proc) 0)))
    (if (= trace-count 1)
        (set-procedure-property! proc 'trace #f))
    (set! (procedure-trace-count proc) (- trace-count 1)))
  (uninstall-trace-trap trap))

(define-method (trap-runnable? (trap <procedure-trap>)
			       (trap-context <trap-context>))
  (eq? (slot-ref trap 'procedure)
       (frame-procedure (tc:frame trap-context))))

;;; Class: <exit-trap>
;;;
;;; An installed instance of <exit-trap> triggers on stack frame exit
;;; past a specified stack depth.
(define-class <exit-trap> (<trap>)
  ;; "depth" slot: the reference depth for the trap.
  (depth #:init-keyword #:depth))

(define-method (install-trap (trap <exit-trap>))
  (next-method)
  (install-exit-frame-trap trap))

(define-method (uninstall-trap (trap <exit-trap>))
  (next-method)
  (uninstall-exit-frame-trap trap))

(define-method (trap-runnable? (trap <exit-trap>)
			       (trap-context <trap-context>))
  (<= (tc:exit-depth trap-context)
      (slot-ref trap 'depth)))

;;; Class: <entry-trap>
;;;
;;; An installed instance of <entry-trap> triggers on any frame entry.
(define-class <entry-trap> (<trap>))

(define-method (install-trap (trap <entry-trap>))
  (next-method)
  (install-enter-frame-trap trap))

(define-method (uninstall-trap (trap <entry-trap>))
  (next-method)
  (uninstall-enter-frame-trap trap))

(define-method (trap-runnable? (trap <entry-trap>)
			       (trap-context <trap-context>))
  #t)

;;; Class: <apply-trap>
;;;
;;; An installed instance of <apply-trap> triggers on any procedure
;;; application.
(define-class <apply-trap> (<trap>))

(define-method (install-trap (trap <apply-trap>))
  (next-method)
  (install-apply-frame-trap trap))

(define-method (uninstall-trap (trap <apply-trap>))
  (next-method)
  (uninstall-apply-frame-trap trap))

(define-method (trap-runnable? (trap <apply-trap>)
			       (trap-context <trap-context>))
  #t)

;;; Class: <step-trap>
;;;
;;; An installed instance of <step-trap> triggers on the next frame
;;; entry, exit or application, optionally with source location inside
;;; a specified file.
(define-class <step-trap> (<exit-trap>)
  ;; "file-name" slot: if non-#f, indicates that this trap should
  ;; trigger only for steps in source code from the specified file.
  (file-name #:init-value #f #:init-keyword #:file-name)
  ;; "exit-depth" slot: when non-#f, indicates that the next step may
  ;; be a frame exit past this depth; otherwise, indicates that the
  ;; next step must be an application or a frame entry.
  (exit-depth #:init-value #f #:init-keyword #:exit-depth))

(define-method (initialize (trap <step-trap>) initargs)
  (next-method)
  (slot-set! trap 'depth (slot-ref trap 'exit-depth)))

(define-method (install-trap (trap <step-trap>))
  (next-method)
  (install-enter-frame-trap trap)
  (install-apply-frame-trap trap))

(define-method (uninstall-trap (trap <step-trap>))
  (next-method)
  (uninstall-enter-frame-trap trap)
  (uninstall-apply-frame-trap trap))

(define-method (trap-runnable? (trap <step-trap>)
			       (trap-context <trap-context>))
  (if (eq? (tc:type trap-context) #:return)
      ;; We're in the context of an exit-frame trap.  Trap should only
      ;; be run if exit-depth is set and this exit-frame has returned
      ;; past the set depth.
      (and (slot-ref trap 'exit-depth)
	   (next-method)
	   ;; OK to run the trap here, but we should first reset the
	   ;; exit-depth slot to indicate that the step after this one
	   ;; must be an application or frame entry.
	   (begin
	     (slot-set! trap 'exit-depth #f)
	     #t))
      ;; We're in the context of an application or frame entry trap.
      ;; Check whether trap is limited to a specified file.
      (let ((file-name (slot-ref trap 'file-name)))
	(and (or (not file-name)
		 (equal? (frame-file-name (tc:frame trap-context)) file-name))
	     ;; Trap should run here, but we should also set exit-depth to
	     ;; the current stack length, so that - if we don't stop at any
	     ;; other steps first - the next step shows the return value of
	     ;; the current application or evaluation.
	     (begin
	       (slot-set! trap 'exit-depth (tc:depth trap-context))
	       (slot-set! trap 'depth (tc:depth trap-context))
	       #t)))))

(define (frame->source-position frame)
  (let ((source (if (frame-procedure? frame)
		    (or (frame-source frame)
			(let ((proc (frame-procedure frame)))
			  (and proc
			       (procedure? proc)
			       (procedure-source proc))))
		    (frame-source frame))))
    (and source
	 (string? (source-property source 'filename))
	 (list (source-property source 'filename)
	       (source-property source 'line)
	       (source-property source 'column)))))

(define (frame-file-name frame)
  (cond ((frame->source-position frame) => car)
	(else #f)))

;;; Class: <source-trap>
;;;
;;; An installed instance of <source-trap> triggers upon evaluation of
;;; a specified source expression.
(define-class <source-trap> (<trap>)
  ;; "expression" slot: the expression to trap on.  This is
  ;; implemented virtually, using the following weak vector slot, so
  ;; as to avoid this trap preventing the GC of the target source
  ;; code.
  (expression #:init-keyword #:expression
	      #:allocation #:virtual
	      #:slot-ref
	      (lambda (trap)
		(vector-ref (slot-ref trap 'expression-wv) 0))
	      #:slot-set!
	      (lambda (trap expr)
		(if (slot-bound? trap 'expression-wv)
		    (vector-set! (slot-ref trap 'expression-wv) 0 expr)
		    (slot-set! trap 'expression-wv (weak-vector expr)))))
  (expression-wv)
  ;; source property slots - for internal use only
  (filename)
  (line)
  (column))

;; Customization of the initialize method: get and save the
;; expression's source properties, or signal an error if it doesn't
;; have the necessary properties.
(define-method (initialize (trap <source-trap>) initargs)
  (next-method)
  (let* ((expr (slot-ref trap 'expression))
	 (filename (source-property expr 'filename))
         (line (source-property expr 'line))
         (column (source-property expr 'column))
	 (existing-traps (volatile-target-traps expr)))
    (or (and filename line column)
        (error "Specified source does not have the necessary properties"
               filename line column))
    (slot-set! trap 'filename filename)
    (slot-set! trap 'line line)
    (slot-set! trap 'column column)
    ;; If this is the target's first trap, give the target expression
    ;; to the volatile-target-guardian, so we can find out if it
    ;; becomes inaccessible.
    (or existing-traps (volatile-target-guardian expr))
    ;; Add this trap to the target expression's list of traps.
    (set! (volatile-target-traps expr)
	  (cons trap (or existing-traps '())))))

;; Just in case more than one trap is installed on the same source
;; expression ... so that we can still get the setting and resetting
;; of the 'breakpoint source property correct.
(define source-breakpoint-count (make-object-property))

(define-method (install-trap (trap <source-trap>))
  (next-method)
  (let* ((expr (slot-ref trap 'expression))
         (breakpoint-count (or (source-breakpoint-count expr) 0)))
    (set-source-property! expr 'breakpoint #t)
    (set! (source-breakpoint-count expr) (+ breakpoint-count 1)))
  (install-breakpoint-trap trap))

(define-method (uninstall-trap (trap <source-trap>))
  (next-method)
  (let* ((expr (slot-ref trap 'expression))
         (breakpoint-count (or (source-breakpoint-count expr) 0)))
    (if (= breakpoint-count 1)
        (set-source-property! expr 'breakpoint #f))
    (set! (source-breakpoint-count expr) (- breakpoint-count 1)))
  (uninstall-breakpoint-trap trap))

(define-method (trap-runnable? (trap <source-trap>)
			       (trap-context <trap-context>))
  (or (eq? (slot-ref trap 'expression)
           (tc:expression trap-context))
      (let ((trap-location (frame->source-position (tc:frame trap-context))))
        (and trap-location
             (string=? (car trap-location) (slot-ref trap 'filename))
             (= (cadr trap-location) (slot-ref trap 'line))
             (= (caddr trap-location) (slot-ref trap 'column))))))

;; (trap-here EXPRESSION . OPTIONS)
(define trap-here
  (procedure->memoizing-macro
   (lambda (expr env)
     (let ((trap (apply make
                        <source-trap>
                        #:expression expr
                        (local-eval `(list ,@(cddr expr))
                                    env))))
       (install-trap trap)
       (set-car! expr 'begin)
       (set-cdr! (cdr expr) '())
       expr))))

;;; Class: <location-trap>
;;;
;;; An installed instance of <location-trap> triggers on entry to a
;;; frame with a more-or-less precisely specified source location.
(define-class <location-trap> (<trap>)
  ;; "file-regexp" slot: regexp matching the name(s) of the file(s) to
  ;; trap in.
  (file-regexp #:init-keyword #:file-regexp)
  ;; "line" and "column" slots: position to trap at (0-based).
  (line #:init-value #f #:init-keyword #:line)
  (column #:init-value #f #:init-keyword #:column)
  ;; "compiled-regexp" slot - self explanatory, internal use only
  (compiled-regexp))

(define-method (initialize (trap <location-trap>) initargs)
  (next-method)
  (slot-set! trap 'compiled-regexp
             (make-regexp (slot-ref trap 'file-regexp))))

(define-method (install-trap (trap <location-trap>))
  (next-method)
  (install-enter-frame-trap trap))

(define-method (uninstall-trap (trap <location-trap>))
  (next-method)
  (uninstall-enter-frame-trap trap))

(define-method (trap-runnable? (trap <location-trap>)
			       (trap-context <trap-context>))
  (and-let* ((trap-location (frame->source-position (tc:frame trap-context)))
	     (tcline (cadr trap-location))
	     (tccolumn (caddr trap-location)))
    (and (= tcline (slot-ref trap 'line))
	 (= tccolumn (slot-ref trap 'column))
         (regexp-exec (slot-ref trap 'compiled-regexp)
		      (car trap-location) 0))))

;;; {Misc Trap Utilities}

(define (get-trap number)
  (hash-ref all-traps number))

(define (list-traps)
  (for-each describe
	    (map cdr (sort (hash-fold acons '() all-traps)
			   (lambda (x y) (< (car x) (car y)))))))

;;; {Volatile Traps}
;;;
;;; Some traps are associated with Scheme objects that are likely to
;;; be GC'd, such as procedures and read expressions.  When those
;;; objects are GC'd, we want to allow their traps to evaporate as
;;; well, or at least not to prevent them from doing so because they
;;; are (now pointlessly) included on the various installed trap
;;; lists.

;; An object property that maps each volatile target to the list of
;; traps that are installed on it.
(define volatile-target-traps (make-object-property))

;; A guardian that tells us when a volatile target is no longer
;; accessible.
(define volatile-target-guardian (make-guardian))

;; An after GC hook that checks for newly inaccessible targets.
(add-hook! after-gc-hook
	   (lambda ()
	     (trc 'after-gc-hook)
	     (let loop ((target (volatile-target-guardian)))
	       (if target
                   ;; We have a target which is now inaccessible.  Get
                   ;; the list of traps installed on it.
		   (begin
		     (trc 'after-gc-hook "got target")
		     ;; Uninstall all the traps that are installed on
		     ;; this target.
		     (for-each (lambda (trap)
				 (trc 'after-gc-hook "got trap")
				 ;; If the trap is still installed,
				 ;; uninstall it.
				 (if (slot-ref trap 'installed)
				     (uninstall-trap trap))
				 ;; If the trap has an observer, tell
				 ;; it that the target has gone.
				 (cond ((slot-ref trap 'observer)
					=>
					(lambda (proc)
					  (trc 'after-gc-hook "call obs")
					  (proc 'target-gone)))))
			       (or (volatile-target-traps target) '()))
                     ;; Check for any more inaccessible targets.
		     (loop (volatile-target-guardian)))))))

(define (without-traps thunk)
  (with-traps (lambda ()
		(trap-disable 'traps)
		(thunk))))

(define guile-trap-features
  ;; Helper procedure, to test whether a specific possible Guile
  ;; feature is supported.
  (let ((supported?
         (lambda (test-feature)
           (case test-feature
             ((tweaking)
              ;; Tweaking is supported if the description of the cheap
              ;; traps option includes the word "obsolete", or if the
              ;; option isn't there any more.
              (and (string>=? (version) "1.7")
                   (let ((cheap-opt-desc
                          (assq 'cheap (debug-options-interface 'help))))
                     (or (not cheap-opt-desc)
                         (string-match "obsolete" (caddr cheap-opt-desc))))))
             (else
              (error "Unexpected feature name:" test-feature))))))
    ;; Compile the list of actually supported features from all
    ;; possible features.
    (let loop ((possible-features '(tweaking))
               (actual-features '()))
      (if (null? possible-features)
          (reverse! actual-features)
          (let ((test-feature (car possible-features)))
            (loop (cdr possible-features)
                  (if (supported? test-feature)
                      (cons test-feature actual-features)
                      actual-features)))))))

;; Make sure that traps are enabled.
(trap-enable 'traps)

;;; (ice-9 debugging traps) ends here.
