(define-module (ice-9 gds-client)
  #:use-module (oop goops)
  #:use-module (oop goops describe)
  #:use-module (ice-9 debugging trace)
  #:use-module (ice-9 debugging traps)
  #:use-module (ice-9 debugging trc)
  #:use-module (ice-9 debugging steps)
  #:use-module (ice-9 pretty-print)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 session)
  #:use-module (ice-9 string-fun)
  #:export (gds-debug-trap
	    run-utility
	    gds-accept-input))

(cond ((string>=? (version) "1.7")
       (use-modules (ice-9 debugger utils)))
      (else
       (define the-ice-9-debugger-module (resolve-module '(ice-9 debugger)))
       (module-export! the-ice-9-debugger-module
		       '(source-position
			 write-frame-short/application
			 write-frame-short/expression
			 write-frame-args-long
			 write-frame-long))))

(use-modules (ice-9 debugger))

(define gds-port #f)

;; Return an integer that somehow identifies the current thread.
(define (get-thread-id)
  (let ((root (dynamic-root)))
    (cond ((integer? root)
	   root)
	  ((pair? root)
	   (object-address root))
	  (else
	   (error "Unexpected dynamic root:" root)))))

;; gds-debug-read is a high-priority read.  The (debug-thread-id ID)
;; form causes the frontend to dismiss any reads from threads whose id
;; is not ID, until it receives the (thread-id ...) form with the same
;; id as ID.  Dismissing the reads of any other threads (by sending a
;; form that is otherwise ignored) causes those threads to release the
;; read mutex, which allows the (gds-read) here to proceed.
(define (gds-debug-read)
  (write-form `(debug-thread-id ,(get-thread-id)))
  (gds-read))

(define (gds-debug-trap trap-context)
  "Invoke the GDS debugger to explore the stack at the specified trap."
  (connect-to-gds)
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
		      (fired-traps (tc:fired-traps trap-context))
		      (special-index (and (= (length fired-traps) 1)
					  (is-a? (car fired-traps) <exit-trap>)
					  (eq? (tc:type trap-context) #:return)
					  (- (tc:depth trap-context)
					     (slot-ref (car fired-traps) 'depth)))))
                 ;; Write current stack to the frontend.
                 (write-form (list 'stack
				   (if (and special-index (> special-index 0))
				       special-index
				       0)
                                   (stack->emacs-readable stack)
                                   (append (flags->emacs-readable flags)
                                           (slot-ref trap-context
                                                     'handler-return-syms))))
		 ;; Now wait for instruction.
                 (let loop ((protocol (gds-debug-read)))
                   ;; Act on it.
                   (case (car protocol)
                     ((tweak)
		      ;; Request to tweak the handler return value.
		      (let ((tweaking (catch #t
					     (lambda ()
					       (list (with-input-from-string
							 (cadr protocol)
						       read)))
					     (lambda ignored #f))))
			(if tweaking
			    (slot-set! trap-context
				       'handler-return-value
				       (cons 'instead (car tweaking)))))
                      (loop (gds-debug-read)))
                     ((continue)
                      ;; Continue (by exiting the debugger).
                      *unspecified*)
                     ((evaluate)
                      ;; Evaluate expression in specified frame.
                      (eval-in-frame stack (cadr protocol) (caddr protocol))
                      (loop (gds-debug-read)))
                     ((info-frame)
                      ;; Return frame info.
                      (let ((frame (stack-ref stack (cadr protocol))))
                        (write-form (list 'info-result
                                          (with-output-to-string
                                            (lambda ()
                                              (write-frame-long frame))))))
                      (loop (gds-debug-read)))
                     ((info-args)
                      ;; Return frame args.
                      (let ((frame (stack-ref stack (cadr protocol))))
                        (write-form (list 'info-result
                                          (with-output-to-string
                                            (lambda ()
                                              (write-frame-args-long frame))))))
                      (loop (gds-debug-read)))
                     ((proc-source)
                      ;; Show source of application procedure.
                      (let* ((frame (stack-ref stack (cadr protocol)))
                             (proc (frame-procedure frame))
                             (source (and proc (procedure-source proc))))
                        (write-form (list 'info-result
                                          (if source
                                              (sans-surrounding-whitespace
                                               (with-output-to-string
                                                 (lambda ()
                                                   (pretty-print source))))
                                              (if proc
                                                  "This procedure is coded in C"
                                                  "This frame has no procedure")))))
                      (loop (gds-debug-read)))
		     ((traps-here)
		      ;; Show the traps that fired here.
		      (write-form (list 'info-result
					(with-output-to-string
					  (lambda ()
					    (for-each describe
						 (tc:fired-traps trap-context))))))
		      (loop (gds-debug-read)))
                     ((step-into)
                      ;; Set temporary breakpoint on next trap.
                      (at-step gds-debug-trap
                               1
			       #f
			       (if (memq #:return flags)
				   #f
				   (- (stack-length stack)
				      (cadr protocol)))))
                     ((step-over)
                      ;; Set temporary breakpoint on exit from
                      ;; specified frame.
                      (at-exit (- (stack-length stack) (cadr protocol))
                               gds-debug-trap))
                     ((step-file)
                      ;; Set temporary breakpoint on next trap in same
                      ;; source file.
                      (at-step gds-debug-trap
                               1
                               (frame-file-name (stack-ref stack
                                                           (cadr protocol)))
			       (if (memq #:return flags)
				   #f
				   (- (stack-length stack)
				      (cadr protocol)))))
                     (else
                      (safely-handle-nondebug-protocol protocol)
                      (loop (gds-debug-read))))))))

(define (connect-to-gds . application-name)
  (or gds-port
      (begin
        (set! gds-port
	      (or (let ((s (socket PF_INET SOCK_STREAM 0))
			(SOL_TCP 6)
			(TCP_NODELAY 1))
		    (setsockopt s SOL_TCP TCP_NODELAY 1)
		    (catch #t
			   (lambda ()
			     (connect s AF_INET (inet-aton "127.0.0.1") 8333)
			     s)
			   (lambda _ #f)))
		  (let ((s (socket PF_UNIX SOCK_STREAM 0)))
		    (catch #t
			   (lambda ()
			     (connect s AF_UNIX "/tmp/.gds_socket")
			     s)
			   (lambda _ #f)))
		  (error "Couldn't connect to GDS by TCP or Unix domain socket")))
        (write-form (list 'name (getpid) (apply client-name application-name))))))

(define (client-name . application-name)
  (let loop ((args (append application-name (program-arguments))))
    (if (null? args)
	(format #f "PID ~A" (getpid))
	(let ((arg (car args)))
	  (cond ((string-match "^(.*[/\\])?guile(\\..*)?$" arg)
		 (loop (cdr args)))
		((string-match "^-" arg)
		 (loop (cdr args)))
		(else
		 (format #f "~A (PID ~A)" arg (getpid))))))))

(if (not (defined? 'make-mutex))
    (begin
      (define (make-mutex) #f)
      (define lock-mutex noop)
      (define unlock-mutex noop)))

(define write-mutex (make-mutex))

(define (write-form form)
  ;; Write any form FORM to GDS.
  (lock-mutex write-mutex)
  (write form gds-port)
  (newline gds-port)
  (force-output gds-port)
  (unlock-mutex write-mutex))

(define (stack->emacs-readable stack)
  ;; Return Emacs-readable representation of STACK.
  (map (lambda (index)
	 (frame->emacs-readable (stack-ref stack index)))
       (iota (min (stack-length stack)
		  (cadr (memq 'depth (debug-options)))))))

(define (frame->emacs-readable frame)
  ;; Return Emacs-readable representation of FRAME.
  (if (frame-procedure? frame)
      (list 'application
	    (with-output-to-string
	     (lambda ()
	       (display (if (frame-real? frame) "  " "t "))
	       (write-frame-short/application frame)))
	    (source->emacs-readable frame))
      (list 'evaluation
	    (with-output-to-string
	     (lambda ()
	       (display (if (frame-real? frame) "  " "t "))
	       (write-frame-short/expression frame)))
	    (source->emacs-readable frame))))

(define (source->emacs-readable frame)
  ;; Return Emacs-readable representation of the filename, line and
  ;; column source properties of SOURCE.
  (or (frame->source-position frame) 'nil))

(define (flags->emacs-readable flags)
  ;; Return Emacs-readable representation of trap FLAGS.
  (let ((prev #f))
    (map (lambda (flag)
	   (let ((erf (if (and (keyword? flag)
			       (not (eq? prev #:return)))
			  (keyword->symbol flag)
			  (format #f "~S" flag))))
	     (set! prev flag)
	     erf))
	 flags)))

(define (eval-in-frame stack index expr)
  (write-form
   (list 'eval-result
         (format #f "~S"
                 (catch #t
                        (lambda ()
                          (local-eval (with-input-from-string expr read)
                                      (memoized-environment
                                       (frame-source (stack-ref stack
                                                                index)))))
                        (lambda args
                          (cons 'ERROR args)))))))

(set! (behaviour-ordering gds-debug-trap) 100)

;;; Code below here adds support for interaction between the GDS
;;; client program and the Emacs frontend even when not stopped in the
;;; debugger.

;; A mutex to control attempts by multiple threads to read protocol
;; back from the frontend.
(define gds-read-mutex (make-mutex))

;; Read a protocol instruction from the frontend.
(define (gds-read)
  ;; Acquire the read mutex.
  (lock-mutex gds-read-mutex)
  ;; Tell the front end something that identifies us as a thread.
  (write-form `(thread-id ,(get-thread-id)))
  ;; Now read, then release the mutex and return what was read.
  (let ((x (catch #t
		  (lambda () (read gds-port))
		  (lambda ignored the-eof-object))))
    (unlock-mutex gds-read-mutex)
    x))

(define (gds-accept-input exit-on-continue)
  ;; If reading from the GDS connection returns EOF, we will throw to
  ;; this catch.
  (catch 'server-eof
    (lambda ()
      (let loop ((protocol (gds-read)))
        (if (or (eof-object? protocol)
		(and exit-on-continue
		     (eq? (car protocol) 'continue)))
	    (throw 'server-eof))
        (safely-handle-nondebug-protocol protocol)
        (loop (gds-read))))
    (lambda ignored #f)))

(define (safely-handle-nondebug-protocol protocol)
  ;; This catch covers any internal errors in the GDS code or
  ;; protocol.
  (catch #t
    (lambda ()
      (lazy-catch #t
        (lambda ()
          (handle-nondebug-protocol protocol))
        save-lazy-trap-context-and-rethrow))
    (lambda (key . args)
      (write-form
       `(eval-results (error . ,(format #f "~s" protocol))
                      ,(if last-lazy-trap-context 't 'nil)
                      "GDS Internal Error
Please report this to <neil@ossau.uklinux.net>, ideally including:
- a description of the scenario in which this error occurred
- which versions of Guile and guile-debugging you are using
- the error stack, which you can get by clicking on the link below,
  and then cut and paste into your report.
Thanks!\n\n"
                      ,(list (with-output-to-string
                               (lambda ()
                                 (write key)
                                 (display ": ")
                                 (write args)
                                 (newline)))))))))

;; The key that is used to signal a read error changes from 1.6 to
;; 1.8; here we cover all eventualities by discovering the key
;; dynamically.
(define read-error-key
  (catch #t
    (lambda ()
      (with-input-from-string "(+ 3 4" read))
    (lambda (key . args)
      key)))

(define (handle-nondebug-protocol protocol)
  (case (car protocol)

    ((eval)
     (set! last-lazy-trap-context #f)
     (apply (lambda (correlator module port-name line column code flags)
              (with-input-from-string code
                (lambda ()
                  (set-port-filename! (current-input-port) port-name)
                  (set-port-line! (current-input-port) line)
                  (set-port-column! (current-input-port) column)
                  (let ((m (and module (resolve-module-from-root module))))
                    (catch read-error-key
                      (lambda ()
                        (let loop ((exprs '()) (x (read)))
                          (if (eof-object? x)
                              ;; Expressions to be evaluated have all
                              ;; been read.  Now evaluate them.
                              (let loop2 ((exprs (reverse! exprs))
                                          (results '())
                                          (n 1))
                                (if (null? exprs)
                                    (write-form `(eval-results ,correlator
                                                               ,(if last-lazy-trap-context 't 'nil)
                                                               ,@results))
                                    (loop2 (cdr exprs)
                                           (append results (gds-eval (car exprs) m
                                                                     (if (and (null? (cdr exprs))
                                                                              (= n 1))
                                                                         #f n)))
                                           (+ n 1))))
                              ;; Another complete expression read; add
                              ;; it to the list.
			      (begin
				(if (and (pair? x)
					 (memq 'debug flags))
				    (install-trap (make <source-trap>
						    #:expression x
						    #:behaviour gds-debug-trap)))
				(loop (cons x exprs) (read))))))
                      (lambda (key . args)
                        (write-form `(eval-results
                                      ,correlator
                                      ,(if last-lazy-trap-context 't 'nil)
                                      ,(with-output-to-string
                                         (lambda ()
                                           (display ";;; Reading expressions")
                                           (display " to evaluate\n")
                                           (apply display-error #f
                                                  (current-output-port) args)))
                                      ("error-in-read")))))))))
            (cdr protocol)))

    ((complete)
     (let ((matches (apropos-internal
		     (string-append "^" (regexp-quote (cadr protocol))))))
       (cond ((null? matches)
	      (write-form '(completion-result nil)))
	     (else
	      ;;(write matches (current-error-port))
	      ;;(newline (current-error-port))
	      (let ((match
		     (let loop ((match (symbol->string (car matches)))
				(matches (cdr matches)))
		       ;;(write match (current-error-port))
		       ;;(newline (current-error-port))
		       ;;(write matches (current-error-port))
		       ;;(newline (current-error-port))
		       (if (null? matches)
			   match
			   (if (string-prefix=? match
						(symbol->string (car matches)))
			       (loop match (cdr matches))
			       (loop (substring match 0
						(- (string-length match) 1))
				     matches))))))
		(if (string=? match (cadr protocol))
		    (write-form `(completion-result
				  ,(map symbol->string matches)))
		    (write-form `(completion-result
				  ,match))))))))

    ((debug-lazy-trap-context)
     (if last-lazy-trap-context
         (gds-debug-trap last-lazy-trap-context)
         (error "There is no stack available to show")))

    (else
     (error "Unexpected protocol:" protocol))))

(define (resolve-module-from-root name)
  (save-module-excursion
   (lambda ()
     (set-current-module the-root-module)
     (resolve-module name))))

(define (gds-eval x m part)
  ;; Consumer to accept possibly multiple values and present them for
  ;; Emacs as a list of strings.
  (define (value-consumer . values)
    (if (unspecified? (car values))
	'()
	(map (lambda (value)
	       (with-output-to-string (lambda () (write value))))
	     values)))
  ;; Now do evaluation.
  (let ((intro (if part
		   (format #f ";;; Evaluating expression ~A" part)
		   ";;; Evaluating"))
	(value #f))
    (let* ((do-eval (if m
			(lambda ()
			  (display intro)
			  (display " in module ")
			  (write (module-name m))
			  (newline)
			  (set! value
				(call-with-values (lambda ()
						    (start-stack 'gds-eval-stack
								 (eval x m)))
				  value-consumer)))
			(lambda ()
			  (display intro)
			  (display " in current module ")
			  (write (module-name (current-module)))
			  (newline)
			  (set! value
				(call-with-values (lambda ()
						    (start-stack 'gds-eval-stack
								 (primitive-eval x)))
				  value-consumer)))))
	   (output
	    (with-output-to-string
	     (lambda ()
	       (catch #t
                 (lambda ()
                   (lazy-catch #t
                     do-eval
                     save-lazy-trap-context-and-rethrow))
                 (lambda (key . args)
                   (case key
                     ((misc-error signal unbound-variable numerical-overflow)
                      (apply display-error #f
                             (current-output-port) args)
                      (set! value '("error-in-evaluation")))
                     (else
                      (display "EXCEPTION: ")
                      (display key)
                      (display " ")
                      (write args)
                      (newline)
                      (set! value
                            '("unhandled-exception-in-evaluation"))))))))))
      (list output value))))

(define last-lazy-trap-context #f)

(define (save-lazy-trap-context-and-rethrow key . args)
  (set! last-lazy-trap-context
	(throw->trap-context key args save-lazy-trap-context-and-rethrow))
  (apply throw key args))

(define (run-utility)
  (connect-to-gds)
  (write (getpid))
  (newline)
  (force-output)
  (named-module-use! '(guile-user) '(ice-9 session))
  (gds-accept-input #f))

(define-method (trap-description (trap <trap>))
  (let loop ((description (list (class-name (class-of trap))))
	     (next 'installed?))
    (case next
      ((installed?)
       (loop (if (slot-ref trap 'installed)
		 (cons 'installed description)
		 description)
	     'conditional?))
      ((conditional?)
       (loop (if (slot-ref trap 'condition)
		 (cons 'conditional description)
		 description)
	     'skip-count))
      ((skip-count)
       (loop (let ((skip-count (slot-ref trap 'skip-count)))
	       (if (zero? skip-count)
		   description
		   (cons* skip-count 'skip-count description)))
	     'single-shot?))
      ((single-shot?)
       (loop (if (slot-ref trap 'single-shot)
		 (cons 'single-shot description)
		 description)
	     'done))
      (else
       (reverse! description)))))

(define-method (trap-description (trap <procedure-trap>))
  (let ((description (next-method)))
    (set-cdr! description
	      (cons (procedure-name (slot-ref trap 'procedure))
		    (cdr description)))
    description))

(define-method (trap-description (trap <source-trap>))
  (let ((description (next-method)))
    (set-cdr! description
	      (cons (format #f "~s" (slot-ref trap 'expression))
		    (cdr description)))
    description))

(define-method (trap-description (trap <location-trap>))
  (let ((description (next-method)))
    (set-cdr! description
	      (cons* (slot-ref trap 'file-regexp)
		     (slot-ref trap 'line)
		     (slot-ref trap 'column)
		     (cdr description)))
    description))

(define (gds-trace-trap trap-context)
  (connect-to-gds)
  (gds-do-trace trap-context)
  (at-exit (tc:depth trap-context) gds-do-trace))

(define (gds-do-trace trap-context)
  (write-form (list 'trace
		    (format #f
			    "~3@a: ~a"
			    (trace/stack-real-depth trap-context)
			    (trace/info trap-context)))))

(define (gds-trace-subtree trap-context)
  (connect-to-gds)
  (gds-do-trace trap-context)
  (let ((step-trap (make <step-trap> #:behaviour gds-do-trace)))
    (install-trap step-trap)
    (at-exit (tc:depth trap-context)
	     (lambda (trap-context)
	       (uninstall-trap step-trap)))))

;;; (ice-9 gds-client) ends here.
