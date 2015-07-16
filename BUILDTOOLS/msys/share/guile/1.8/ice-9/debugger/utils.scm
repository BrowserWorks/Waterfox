
(define-module (ice-9 debugger utils)
  #:use-module (ice-9 debugger state)
  #:export (display-position
	    source-position
	    write-frame-args-long
	    write-frame-index-long
	    write-frame-short/expression
	    write-frame-short/application
	    write-frame-long
	    write-state-long
	    write-state-short))

;;; Procedures in this module print information about a stack frame.
;;; The available information is as follows.
;;;
;;; * Source code location.
;;;
;;; For an evaluation frame, this is the location recorded at the time
;;; that the expression being evaluated was read, if the 'positions
;;; read option was enabled at that time.
;;;
;;; For an application frame, I'm not yet sure.  Some applications
;;; seem to have associated source expressions.
;;;
;;; * Whether frame is still evaluating its arguments.
;;;
;;; Only applies to an application frame.  For example, an expression
;;; like `(+ (* 2 3) 4)' goes through the following stages of
;;; evaluation.
;;;
;;; (+ (* 2 3) 4)       -- evaluation
;;; [+ ...              -- application; the car of the evaluation
;;;                        has been evaluated and found to be a
;;;                        procedure; before this procedure can
;;;                        be applied, its arguments must be evaluated
;;; [+ 6 ...            -- same application after evaluating the
;;;                        first argument
;;; [+ 6 4]             -- same application after evaluating all
;;;                        arguments
;;; 10                  -- result
;;;
;;; * Whether frame is real or tail-recursive.
;;;
;;; If a frame is tail-recursive, its containing frame as shown by the
;;; debugger backtrace doesn't really exist as far as the Guile
;;; evaluator is concerned.  The effect of this is that when a
;;; tail-recursive frame returns, it looks as though its containing
;;; frame returns at the same time.  (And if the containing frame is
;;; also tail-recursive, _its_ containing frame returns at that time
;;; also, and so on ...)
;;;
;;; A `real' frame is one that is not tail-recursive.


(define (write-state-short state)
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
    (newline)))

(define (write-state-short* stack index)
  (write-frame-index-short stack index)
  (write-char #\space)
  (write-frame-short (stack-ref stack index))
  (newline))

(define (write-frame-index-short stack index)
  (let ((s (number->string (frame-number (stack-ref stack index)))))
    (display s)
    (write-char #\:)
    (write-chars #\space (- 4 (string-length s)))))

(define (write-frame-short frame)
  (if (frame-procedure? frame)
      (write-frame-short/application frame)
      (write-frame-short/expression frame)))

(define (write-frame-short/application frame)
  (write-char #\[)
  (write (let ((procedure (frame-procedure frame)))
	   (or (and (procedure? procedure)
		    (procedure-name procedure))
	       procedure)))
  (if (frame-evaluating-args? frame)
      (display " ...")
      (begin
	(for-each (lambda (argument)
		    (write-char #\space)
		    (write argument))
		  (frame-arguments frame))
	(write-char #\]))))

;;; Use builtin function instead:
(set! write-frame-short/application
      (lambda (frame)
	(display-application frame (current-output-port) 12)))

(define (write-frame-short/expression frame)
  (write (let* ((source (frame-source frame))
		(copy (source-property source 'copy)))
	   (if (pair? copy)
	       copy
	       (unmemoize-expr source)))))

(define (write-state-long state)
  (let ((index (state-index state)))
    (let ((frame (stack-ref (state-stack state) index)))
      (write-frame-index-long frame)
      (write-frame-long frame))))

(define (write-frame-index-long frame)
  (display "Stack frame: ")
  (write (frame-number frame))
  (if (frame-real? frame)
      (display " (real)"))
  (newline))

(define (write-frame-long frame)
  (if (frame-procedure? frame)
      (write-frame-long/application frame)
      (write-frame-long/expression frame)))

(define (write-frame-long/application frame)
  (display "This frame is an application.")
  (newline)
  (if (frame-source frame)
      (begin
	(display "The corresponding expression is:")
	(newline)
	(display-source frame)
	(newline)))
  (display "The procedure being applied is: ")
  (write (let ((procedure (frame-procedure frame)))
	   (or (and (procedure? procedure)
		    (procedure-name procedure))
	       procedure)))
  (newline)
  (display "The procedure's arguments are")
  (if (frame-evaluating-args? frame)
      (display " being evaluated.")
      (begin
	(display ": ")
	(write (frame-arguments frame))))
  (newline))

(define (display-source frame)
  (let* ((source (frame-source frame))
	 (copy (source-property source 'copy)))
    (cond ((source-position source)
	   => (lambda (p) (display-position p) (display ":\n"))))
    (display "  ")
    (write (or copy (unmemoize-expr source)))))

(define (source-position source)
  (let ((fname (source-property source 'filename))
	(line (source-property source 'line))
	(column (source-property source 'column)))
    (and fname
	 (list fname line column))))

(define (display-position pos)
  (format #t "~A:~D:~D" (car pos) (+ 1 (cadr pos)) (+ 1 (caddr pos))))

(define (write-frame-long/expression frame)
  (display "This frame is an evaluation.")
  (newline)
  (display "The expression being evaluated is:")
  (newline)
  (display-source frame)
  (newline))

(define (write-frame-args-long frame)
  (if (frame-procedure? frame)
      (let ((arguments (frame-arguments frame)))
	(let ((n (length arguments)))
	  (display "This frame has ")
	  (write n)
	  (display " argument")
	  (if (not (= n 1))
	      (display "s"))
	  (write-char (if (null? arguments) #\. #\:))
	  (newline))
	(for-each (lambda (argument)
		    (display "  ")
		    (write argument)
		    (newline))
		  arguments))
      (begin
	(display "This frame is an evaluation frame; it has no arguments.")
	(newline))))

(define (write-chars char n)
  (do ((i 0 (+ i 1)))
      ((>= i n))
    (write-char char)))
