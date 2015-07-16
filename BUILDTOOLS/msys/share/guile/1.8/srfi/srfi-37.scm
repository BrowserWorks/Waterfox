;;; srfi-37.scm --- args-fold

;; 	Copyright (C) 2007, 2008 Free Software Foundation, Inc.
;;
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


;;; Commentary:
;;
;; To use this module with Guile, use (cdr (program-arguments)) as
;; the ARGS argument to `args-fold'.  Here is a short example:
;;
;;  (args-fold (cdr (program-arguments))
;; 	    (let ((display-and-exit-proc
;; 		   (lambda (msg)
;; 		     (lambda (opt name arg)
;; 		       (display msg) (quit) (values)))))
;; 	      (list (option '(#\v "version") #f #f
;; 			    (display-and-exit-proc "Foo version 42.0\n"))
;; 		    (option '(#\h "help") #f #f
;; 			    (display-and-exit-proc
;; 			     "Usage: foo scheme-file ..."))))
;; 	    (lambda (opt name arg)
;; 	      (error "Unrecognized option `~A'" name))
;; 	    (lambda (op) (load op) (values)))
;;
;;; Code:


;;;; Module definition & exports
(define-module (srfi srfi-37)
  #:use-module (srfi srfi-9)
  #:export (option option-names option-required-arg?
	    option-optional-arg? option-processor
	    args-fold))

(cond-expand-provide (current-module) '(srfi-37))

;;;; args-fold and periphery procedures

;;; An option as answered by `option'.  `names' is a list of
;;; characters and strings, representing associated short-options and
;;; long-options respectively that should use this option's
;;; `processor' in an `args-fold' call.
;;;
;;; `required-arg?' and `optional-arg?' are mutually exclusive
;;; booleans and indicate whether an argument must be or may be
;;; provided.  Besides the obvious, this affects semantics of
;;; short-options, as short-options with a required or optional
;;; argument cannot be followed by other short options in the same
;;; program-arguments string, as they will be interpreted collectively
;;; as the option's argument.
;;;
;;; `processor' is called when this option is encountered.  It should
;;; accept the containing option, the element of `names' (by `equal?')
;;; encountered, the option's argument (or #f if none), and the seeds
;;; as variadic arguments, answering the new seeds as values.
(define-record-type srfi-37:option
  (option names required-arg? optional-arg? processor)
  option?
  (names option-names)
  (required-arg? option-required-arg?)
  (optional-arg? option-optional-arg?)
  (processor option-processor))

(define (error-duplicate-option option-name)
  (scm-error 'program-error "args-fold"
	     "Duplicate option name `~A~A'"
	     (list (if (char? option-name) #\- "--")
		   option-name)
	     #f))

(define (build-options-lookup options)
  "Answer an `equal?' Guile hash-table that maps OPTIONS' names back
to the containing options, signalling an error if a name is
encountered more than once."
  (let ((lookup (make-hash-table (* 2 (length options)))))
    (for-each
     (lambda (opt)
       (for-each (lambda (name)
		   (let ((assoc (hash-create-handle!
				 lookup name #f)))
		     (if (cdr assoc)
			 (error-duplicate-option (car assoc))
			 (set-cdr! assoc opt))))
		 (option-names opt)))
     options)
    lookup))

(define (args-fold args options unrecognized-option-proc
		   operand-proc . seeds)
  "Answer the results of folding SEEDS as multiple values against the
program-arguments in ARGS, as decided by the OPTIONS'
`option-processor's, UNRECOGNIZED-OPTION-PROC, and OPERAND-PROC."
  (let ((lookup (build-options-lookup options)))
    ;; I don't like Guile's `error' here
    (define (error msg . args)
      (scm-error 'misc-error "args-fold" msg args #f))

    (define (mutate-seeds! procedure . params)
      (set! seeds (call-with-values
		      (lambda ()
			(apply procedure (append params seeds)))
		    list)))

    ;; Clean up the rest of ARGS, assuming they're all operands.
    (define (rest-operands)
      (for-each (lambda (arg) (mutate-seeds! operand-proc arg))
		args)
      (set! args '()))

    ;; Call OPT's processor with OPT, NAME, an argument to be decided,
    ;; and the seeds.  Depending on OPT's *-arg? specification, get
    ;; the parameter by calling REQ-ARG-PROC or OPT-ARG-PROC thunks;
    ;; if no argument is allowed, call NO-ARG-PROC thunk.
    (define (invoke-option-processor
	     opt name req-arg-proc opt-arg-proc no-arg-proc)
      (mutate-seeds!
       (option-processor opt) opt name
       (cond ((option-required-arg? opt) (req-arg-proc))
	     ((option-optional-arg? opt) (opt-arg-proc))
	     (else (no-arg-proc) #f))))

    ;; Compute and answer a short option argument, advancing ARGS as
    ;; necessary, for the short option whose character is at POSITION
    ;; in the current ARG.
    (define (short-option-argument position)
      (cond ((< (1+ position) (string-length (car args)))
	     (let ((result (substring (car args) (1+ position))))
	       (set! args (cdr args))
	       result))
	    ((pair? (cdr args))
	     (let ((result (cadr args)))
	       (set! args (cddr args))
	       result))
	    (else #f)))

    ;; Interpret the short-option at index POSITION in (car ARGS),
    ;; followed by the remaining short options in (car ARGS).
    (define (short-option position)
      (if (>= position (string-length (car args)))
          (begin
            (set! args (cdr args))
            (next-arg))
	  (let* ((opt-name (string-ref (car args) position))
		 (option-here (hash-ref lookup opt-name)))
	    (cond ((not option-here)
		   (mutate-seeds! unrecognized-option-proc
				  (option (list opt-name) #f #f
					  unrecognized-option-proc)
				  opt-name #f)
		   (short-option (1+ position)))
		  (else
		   (invoke-option-processor
		    option-here opt-name
		    (lambda ()
		      (or (short-option-argument position)
			  (error "Missing required argument after `-~A'" opt-name)))
		    (lambda ()
		      ;; edge case: -xo -zf or -xo -- where opt-name=#\o
		      ;; GNU getopt_long resolves these like I do
		      (short-option-argument position))
		    (lambda () #f))
		   (if (not (or (option-required-arg? option-here)
				(option-optional-arg? option-here)))
		       (short-option (1+ position))))))))

    ;; Process the long option in (car ARGS).  We make the
    ;; interesting, possibly non-standard assumption that long option
    ;; names might contain #\=, so keep looking for more #\= in (car
    ;; ARGS) until we find a named option in lookup.
    (define (long-option)
      (let ((arg (car args)))
	(let place-=-after ((start-pos 2))
	  (let* ((index (string-index arg #\= start-pos))
		 (opt-name (substring arg 2 (or index (string-length arg))))
		 (option-here (hash-ref lookup opt-name)))
	    (if (not option-here)
		;; look for a later #\=, unless there can't be one
		(if index
		    (place-=-after (1+ index))
		    (mutate-seeds!
		     unrecognized-option-proc
		     (option (list opt-name) #f #f unrecognized-option-proc)
		     opt-name #f))
		(invoke-option-processor
		 option-here opt-name
		 (lambda ()
		   (if index
		       (substring arg (1+ index))
		       (error "Missing required argument after `--~A'" opt-name)))
		 (lambda () (and index (substring arg (1+ index))))
		 (lambda ()
		   (if index
		       (error "Extraneous argument after `--~A'" opt-name))))))))
      (set! args (cdr args)))

    ;; Process the remaining in ARGS.  Basically like calling
    ;; `args-fold', but without having to regenerate `lookup' and the
    ;; funcs above.
    (define (next-arg)
      (if (null? args)
	  (apply values seeds)
	  (let ((arg (car args)))
	    (cond ((or (not (char=? #\- (string-ref arg 0)))
		       (= 1 (string-length arg))) ;"-"
		   (mutate-seeds! operand-proc arg)
		   (set! args (cdr args)))
		  ((char=? #\- (string-ref arg 1))
		   (if (= 2 (string-length arg)) ;"--"
		       (begin (set! args (cdr args)) (rest-operands))
		       (long-option)))
		  (else (short-option 1)))
	    (next-arg))))

    (next-arg)))

;;; srfi-37.scm ends here
