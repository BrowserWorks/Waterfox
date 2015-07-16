;;;; Guile Debugger command loop

;;; Copyright (C) 1999, 2001, 2002, 2003, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 debugger command-loop)
  #:use-module ((ice-9 debugger commands) :prefix debugger:)
  #:export (debugger-command-loop
	    debugger-command-loop-error
	    debugger-command-loop-quit)
  #:no-backtrace)

;;; {Interface used by (ice-9 debugger).}

(define (debugger-command-loop state)
  (read-and-dispatch-commands state (current-input-port)))

(define (debugger-command-loop-error message)
  (user-error message))

(define (debugger-command-loop-quit)
  (throw 'exit-debugger))

;;; {Implementation.}
  
(define debugger-prompt "debug> ")

(define (debugger-handler key . args)
  (case key
    ((exit-debugger) #f)
    ((signal)
     ;; Restore stack
     (fluid-set! the-last-stack (fluid-ref before-signal-stack))
     (apply display-error #f (current-error-port) args))
    (else
     (display "Internal debugger error:\n")
     (save-stack debugger-handler)
     (apply throw key args)))
  (throw 'exit-debugger))		;Pop the stack

(define (read-and-dispatch-commands state port)
  (catch 'exit-debugger
    (lambda ()
      (lazy-catch #t
        (lambda ()
	  (with-fluids ((last-command #f))
	    (let loop ()
	      (read-and-dispatch-command state port)
	      (loop))))
	debugger-handler))
    (lambda args
      *unspecified*)))

(define set-readline-prompt! #f)

(define (read-and-dispatch-command state port)
  (if (using-readline?)
      (begin
	;; Import set-readline-prompt! if we haven't already.
	(or set-readline-prompt!
	    (set! set-readline-prompt!
		  (module-ref (resolve-module '(ice-9 readline))
			      'set-readline-prompt!)))
	(set-readline-prompt! debugger-prompt debugger-prompt))
      (display debugger-prompt))
  (force-output)			;This should not be necessary...
  (let ((token (read-token port)))
    (cond ((eof-object? token)
	   (throw 'exit-debugger))
	  ((not token)
	   (discard-rest-of-line port)
	   (catch-user-errors port (lambda () (run-last-command state))))
	  (else
	   (catch-user-errors port
	     (lambda ()
	       (dispatch-command token command-table state port)))))))

(define (run-last-command state)
  (let ((procedure (fluid-ref last-command)))
    (if procedure
	(procedure state))))

(define (catch-user-errors port thunk)
  (catch 'debugger-user-error
	 thunk
	 (lambda (key . objects)
	   (apply user-warning objects)
	   (discard-rest-of-line port))))

(define last-command (make-fluid))

(define (user-warning . objects)
  (for-each (lambda (object)
	      (display object))
	    objects)
  (newline))

(define (user-error . objects)
  (apply throw 'debugger-user-error objects))

;;;; Command dispatch

(define (dispatch-command string table state port)
  (let ((value (command-table-value table string)))
    (if value
	(dispatch-command/value value state port)
	(user-error "Unknown command: " string))))

(define (dispatch-command/value value state port)
  (cond ((command? value)
	 (dispatch-command/command value state port))
	((command-table? value)
	 (dispatch-command/table value state port))
	((list? value)
	 (dispatch-command/name value state port))
	(else
	 (error "Unrecognized command-table value: " value))))

(define (dispatch-command/command command state port)
  (let ((procedure (command-procedure command))
	(arguments ((command-parser command) port)))
    (let ((procedure (lambda (state) (apply procedure state arguments))))
      (warn-about-extra-args port)
      (fluid-set! last-command procedure)
      (procedure state))))

(define (warn-about-extra-args port)
  ;; **** modify this to show the arguments.
  (let ((char (skip-whitespace port)))
    (cond ((eof-object? char) #f)
	  ((char=? #\newline char) (read-char port))
	  (else
	   (user-warning "Extra arguments at end of line: "
			 (read-rest-of-line port))))))

(define (dispatch-command/table table state port)
  (let ((token (read-token port)))
    (if (or (eof-object? token)
	    (not token))
	(user-error "Command name too short.")
	(dispatch-command token table state port))))

(define (dispatch-command/name name state port)
  (let ((value (lookup-command name)))
    (cond ((not value)
	   (apply user-error "Unknown command name: " name))
	  ((command-table? value)
	   (apply user-error "Partial command name: " name))
	  (else
	   (dispatch-command/value value state port)))))

;;;; Command definition

(define (define-command name argument-template procedure)
  (let ((name (canonicalize-command-name name)))
    (add-command name
		 (make-command name
			       (argument-template->parser argument-template)
			       (procedure-documentation procedure)
			       procedure)
		 command-table)
    name))

(define (define-command-alias name1 name2)
  (let ((name1 (canonicalize-command-name name1)))
    (add-command name1 (canonicalize-command-name name2) command-table)
    name1))

(define (argument-template->parser template)
  ;; Deliberately handles only cases that occur in "commands.scm".
  (cond ((eq? 'tokens template)
	 (lambda (port)
	   (let loop ((tokens '()))
	     (let ((token (read-token port)))
	       (if (or (eof-object? token)
		       (not token))
		   (list (reverse! tokens))
		   (loop (cons token tokens)))))))
	((null? template)
	 (lambda (port)
	   '()))
	((and (pair? template)
	      (null? (cdr template))
	      (eq? 'object (car template)))
	 (lambda (port)
	   (list (read port))))
	((and (pair? template)
	      (equal? ''optional (car template))
	      (pair? (cdr template))
	      (null? (cddr template)))
	 (case (cadr template)
	   ((token)
	    (lambda (port)
	      (let ((token (read-token port)))
		(if (or (eof-object? token)
			(not token))
		    (list #f)
		    (list token)))))
	   ((exact-integer)
	    (lambda (port)
	      (list (parse-optional-exact-integer port))))
	   ((exact-nonnegative-integer)
	    (lambda (port)
	      (list (parse-optional-exact-nonnegative-integer port))))
	   ((object)
	    (lambda (port)
	      (list (parse-optional-object port))))
	   (else
	    (error "Malformed argument template: " template))))
	(else
	 (error "Malformed argument template: " template))))

(define (parse-optional-exact-integer port)
  (let ((object (parse-optional-object port)))
    (if (or (not object)
	    (and (integer? object)
		 (exact? object)))
	object
	(user-error "Argument not an exact integer: " object))))

(define (parse-optional-exact-nonnegative-integer port)
  (let ((object (parse-optional-object port)))
    (if (or (not object)
	    (and (integer? object)
		 (exact? object)
		 (not (negative? object))))
	object
	(user-error "Argument not an exact non-negative integer: " object))))

(define (parse-optional-object port)
  (let ((terminator (skip-whitespace port)))
    (if (or (eof-object? terminator)
	    (eq? #\newline terminator))
	#f
	(let ((object (read port)))
	  (if (eof-object? object)
	      #f
	      object)))))

;;;; Command tables

(define (lookup-command name)
  (let loop ((table command-table) (strings name))
    (let ((value (command-table-value table (car strings))))
      (cond ((or (not value) (null? (cdr strings))) value)
	    ((command-table? value) (loop value (cdr strings)))
	    (else #f)))))

(define (command-table-value table string)
  (let ((entry (command-table-entry table string)))
    (and entry
	 (caddr entry))))

(define (command-table-entry table string)
  (let loop ((entries (command-table-entries table)))
    (and (not (null? entries))
	 (let ((entry (car entries)))
	   (if (and (<= (cadr entry)
			(string-length string)
			(string-length (car entry)))
		    (= (string-length string)
		       (match-strings (car entry) string)))
	       entry
	       (loop (cdr entries)))))))

(define (match-strings s1 s2)
  (let ((n (min (string-length s1) (string-length s2))))
    (let loop ((i 0))
      (cond ((= i n) i)
	    ((char=? (string-ref s1 i) (string-ref s2 i)) (loop (+ i 1)))
	    (else i)))))

(define (write-command-name name)
  (display (car name))
  (for-each (lambda (string)
	      (write-char #\space)
	      (display string))
	    (cdr name)))

(define (add-command name value table)
  (let loop ((strings name) (table table))
    (let ((entry
	   (or (let loop ((entries (command-table-entries table)))
		 (and (not (null? entries))
		      (if (string=? (car strings) (caar entries))
			  (car entries)
			  (loop (cdr entries)))))
	       (let ((entry (list (car strings) #f #f)))
		 (let ((entries
			(let ((entries (command-table-entries table)))
			  (if (or (null? entries)
				  (string<? (car strings) (caar entries)))
			      (cons entry entries)
			      (begin
				(let loop ((prev entries) (this (cdr entries)))
				  (if (or (null? this)
					  (string<? (car strings) (caar this)))
				      (set-cdr! prev (cons entry this))
				      (loop this (cdr this))))
				entries)))))
		   (compute-string-abbreviations! entries)
		   (set-command-table-entries! table entries))
		 entry))))
      (if (null? (cdr strings))
	  (set-car! (cddr entry) value)
	  (loop (cdr strings)
		(if (command-table? (caddr entry))
		    (caddr entry)
		    (let ((table (make-command-table '())))
		      (set-car! (cddr entry) table)
		      table)))))))

(define (canonicalize-command-name name)
  (cond ((and (string? name)
	      (not (string-null? name)))
	 (list name))
	((let loop ((name name))
	   (and (pair? name)
		(string? (car name))
		(not (string-null? (car name)))
		(or (null? (cdr name))
		    (loop (cdr name)))))
	 name)
	(else
	 (error "Illegal command name: " name))))

(define (compute-string-abbreviations! entries)
  (let loop ((entries entries) (index 0))
    (let ((groups '()))
      (for-each
       (lambda (entry)
	 (let* ((char (string-ref (car entry) index))
		(group (assv char groups)))
	   (if group
	       (set-cdr! group (cons entry (cdr group)))
	       (set! groups
		     (cons (list char entry)
			   groups)))))
       entries)
      (for-each
       (lambda (group)
	 (let ((index (+ index 1)))
	   (if (null? (cddr group))
	       (set-car! (cdadr group) index)
	       (loop (let ((entry
			    (let loop ((entries (cdr group)))
			      (and (not (null? entries))
				   (if (= index (string-length (caar entries)))
				       (car entries)
				       (loop (cdr entries)))))))
		       (if entry
			   (begin
			     (set-car! (cdr entry) index)
			     (delq entry (cdr group)))
			   (cdr group)))
		     index))))
       groups))))

;;;; Data structures

(define command-table-rtd (make-record-type "command-table" '(entries)))
(define make-command-table (record-constructor command-table-rtd '(entries)))
(define command-table? (record-predicate command-table-rtd))
(define command-table-entries (record-accessor command-table-rtd 'entries))
(define set-command-table-entries!
  (record-modifier command-table-rtd 'entries))

(define command-rtd
  (make-record-type "command"
		    '(name parser documentation procedure)))

(define make-command
  (record-constructor command-rtd
		      '(name parser documentation procedure)))

(define command? (record-predicate command-rtd))
(define command-name (record-accessor command-rtd 'name))
(define command-parser (record-accessor command-rtd 'parser))
(define command-documentation (record-accessor command-rtd 'documentation))
(define command-procedure (record-accessor command-rtd 'procedure))

;;;; Character parsing

(define (read-token port)
  (letrec
      ((loop
	(lambda (chars)
	  (let ((char (peek-char port)))
	    (cond ((eof-object? char)
		   (do-eof char chars))
		  ((char=? #\newline char)
		   (do-eot chars))
		  ((char-whitespace? char)
		   (do-eot chars))
		  ((char=? #\# char)
		   (read-char port)
		   (let ((terminator (skip-comment port)))
		     (if (eof-object? char)
			 (do-eof char chars)
			 (do-eot chars))))
		  (else
		   (read-char port)
		   (loop (cons char chars)))))))
       (do-eof
	(lambda (eof chars)
	  (if (null? chars)
	      eof
	      (do-eot chars))))
       (do-eot
	(lambda (chars)
	  (if (null? chars)
	      #f
	      (list->string (reverse! chars))))))
    (skip-whitespace port)
    (loop '())))

(define (skip-whitespace port)
  (let ((char (peek-char port)))
    (cond ((or (eof-object? char)
	       (char=? #\newline char))
	   char)
	  ((char-whitespace? char)
	   (read-char port)
	   (skip-whitespace port))
	  ((char=? #\# char)
	   (read-char port)
	   (skip-comment port))
	  (else char))))

(define (skip-comment port)
  (let ((char (peek-char port)))
    (if (or (eof-object? char)
	    (char=? #\newline char))
	char
	(begin
	  (read-char port)
	  (skip-comment port)))))

(define (read-rest-of-line port)
  (let loop ((chars '()))
    (let ((char (read-char port)))
      (if (or (eof-object? char)
	      (char=? #\newline char))
	  (list->string (reverse! chars))
	  (loop (cons char chars))))))

(define (discard-rest-of-line port)
  (let loop ()
    (if (not (let ((char (read-char port)))
	       (or (eof-object? char)
		   (char=? #\newline char))))
	(loop))))

;;;; Commands

(define command-table (make-command-table '()))

(define-command "help" 'tokens
  (lambda (state tokens)
    "Type \"help\" followed by a command name for full documentation."
    (let loop ((name (if (null? tokens) '("help") tokens)))
      (let ((value (lookup-command name)))
	(cond ((not value)
	       (write-command-name name)
	       (display " is not a known command name.")
	       (newline))
	      ((command? value)
	       (display (command-documentation value))
	       (newline)
	       (if (equal? '("help") (command-name value))
		   (begin
		     (display "Available commands are:")
		     (newline)
		     (for-each (lambda (entry)
				 (if (not (list? (caddr entry)))
				     (begin
				       (display "  ")
				       (display (car entry))
				       (newline))))
			       (command-table-entries command-table)))))
	      ((command-table? value)
	       (display "The \"")
	       (write-command-name name)
	       (display "\" command requires a subcommand.")
	       (newline)
	       (display "Available subcommands are:")
	       (newline)
	       (for-each (lambda (entry)
			   (if (not (list? (caddr entry)))
			       (begin
				 (display "  ")
				 (write-command-name name)
				 (write-char #\space)
				 (display (car entry))
				 (newline))))
			 (command-table-entries value)))
	      ((list? value)
	       (loop value))
	      (else
	       (error "Unknown value from lookup-command:" value)))))
    state))

(define-command "frame" '('optional exact-nonnegative-integer) debugger:frame)

(define-command "position" '() debugger:position)

(define-command "up" '('optional exact-integer) debugger:up)

(define-command "down" '('optional exact-integer) debugger:down)

(define-command "backtrace" '('optional exact-integer) debugger:backtrace)

(define-command "evaluate" '(object) debugger:evaluate)

(define-command '("info" "args") '() debugger:info-args)

(define-command '("info" "frame") '() debugger:info-frame)

(define-command "quit" '()
  (lambda (state)
    "Exit the debugger."
    (debugger-command-loop-quit)))

(define-command-alias "f" "frame")
(define-command-alias '("info" "f") '("info" "frame"))
(define-command-alias "bt" "backtrace")
(define-command-alias "where" "backtrace")
(define-command-alias "p" "evaluate")
(define-command-alias '("info" "stack") "backtrace")
