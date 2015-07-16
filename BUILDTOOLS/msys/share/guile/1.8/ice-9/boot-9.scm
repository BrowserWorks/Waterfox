;;; installed-scm-file

;;;; Copyright (C) 1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007
;;;; Free Software Foundation, Inc.
;;;;
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;; 
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;;



;;; Commentary:

;;; This file is the first thing loaded into Guile.  It adds many mundane
;;; definitions and a few that are interesting.
;;;
;;; The module system (hence the hierarchical namespace) are defined in this
;;; file.
;;;

;;; Code:



;;; {Features}
;;;

(define (provide sym)
  (if (not (memq sym *features*))
      (set! *features* (cons sym *features*))))

;; Return #t iff FEATURE is available to this Guile interpreter.  In SLIB,
;; provided? also checks to see if the module is available.  We should do that
;; too, but don't.

(define (provided? feature)
  (and (memq feature *features*) #t))

;; let format alias simple-format until the more complete version is loaded

(define format simple-format)

;; this is scheme wrapping the C code so the final pred call is a tail call,
;; per SRFI-13 spec
(define (string-any char_pred s . rest)
  (let ((start (if (null? rest)
		   0 (car rest)))
	(end   (if (or (null? rest) (null? (cdr rest)))
		   (string-length s) (cadr rest))))
    (if (and (procedure? char_pred)
	     (> end start)
	     (<= end (string-length s))) ;; let c-code handle range error
	(or (string-any-c-code char_pred s start (1- end))
	    (char_pred (string-ref s (1- end))))
	(string-any-c-code char_pred s start end))))

;; this is scheme wrapping the C code so the final pred call is a tail call,
;; per SRFI-13 spec
(define (string-every char_pred s . rest)
  (let ((start (if (null? rest)
		   0 (car rest)))
	(end   (if (or (null? rest) (null? (cdr rest)))
		   (string-length s) (cadr rest))))
    (if (and (procedure? char_pred)
	     (> end start)
	     (<= end (string-length s))) ;; let c-code handle range error
	(and (string-every-c-code char_pred s start (1- end))
	     (char_pred (string-ref s (1- end))))
	(string-every-c-code char_pred s start end))))

;; A variant of string-fill! that we keep for compatability
;;
(define (substring-fill! str start end fill)
  (string-fill! str fill start end))



;;; {EVAL-CASE}
;;;

;; (eval-case ((situation*) forms)* (else forms)?)
;;
;; Evaluate certain code based on the situation that eval-case is used
;; in.  The only defined situation right now is `load-toplevel' which
;; triggers for code evaluated at the top-level, for example from the
;; REPL or when loading a file.

(define eval-case
  (procedure->memoizing-macro
   (lambda (exp env)
     (define (toplevel-env? env)
       (or (not (pair? env)) (not (pair? (car env)))))
     (define (syntax)
       (error "syntax error in eval-case"))
     (let loop ((clauses (cdr exp)))
       (cond
	((null? clauses)
	 #f)
	((not (list? (car clauses)))
	 (syntax))
	((eq? 'else (caar clauses))
	 (or (null? (cdr clauses))
	     (syntax))
	 (cons 'begin (cdar clauses)))
	((not (list? (caar clauses)))
	 (syntax))
	((and (toplevel-env? env)
	      (memq 'load-toplevel (caar clauses)))
	 (cons 'begin (cdar clauses)))
	(else
	 (loop (cdr clauses))))))))



;;; {Defmacros}
;;;
;;; Depends on: features, eval-case
;;;

(define macro-table (make-weak-key-hash-table 61))
(define xformer-table (make-weak-key-hash-table 61))

(define (defmacro? m)  (hashq-ref macro-table m))
(define (assert-defmacro?! m) (hashq-set! macro-table m #t))
(define (defmacro-transformer m) (hashq-ref xformer-table m))
(define (set-defmacro-transformer! m t) (hashq-set! xformer-table m t))

(define defmacro:transformer
  (lambda (f)
    (let* ((xform (lambda (exp env)
		    (copy-tree (apply f (cdr exp)))))
	   (a (procedure->memoizing-macro xform)))
      (assert-defmacro?! a)
      (set-defmacro-transformer! a f)
      a)))


(define defmacro
  (let ((defmacro-transformer
	  (lambda (name parms . body)
	    (let ((transformer `(lambda ,parms ,@body)))
	      `(eval-case
		((load-toplevel)
		 (define ,name (defmacro:transformer ,transformer)))
		(else
		 (error "defmacro can only be used at the top level")))))))
    (defmacro:transformer defmacro-transformer)))

(define defmacro:syntax-transformer
  (lambda (f)
    (procedure->syntax
	      (lambda (exp env)
		(copy-tree (apply f (cdr exp)))))))


;; XXX - should the definition of the car really be looked up in the
;; current module?

(define (macroexpand-1 e)
  (cond
   ((pair? e) (let* ((a (car e))
		     (val (and (symbol? a) (local-ref (list a)))))
		(if (defmacro? val)
		    (apply (defmacro-transformer val) (cdr e))
		    e)))
   (#t e)))

(define (macroexpand e)
  (cond
   ((pair? e) (let* ((a (car e))
		     (val (and (symbol? a) (local-ref (list a)))))
		(if (defmacro? val)
		    (macroexpand (apply (defmacro-transformer val) (cdr e)))
		    e)))
   (#t e)))

(provide 'defmacro)



;;; {Deprecation}
;;;
;;; Depends on: defmacro
;;;

(defmacro begin-deprecated forms
  (if (include-deprecated-features)
      (cons begin forms)
      #f))



;;; {R4RS compliance}
;;;

(primitive-load-path "ice-9/r4rs.scm")



;;; {Simple Debugging Tools}
;;;

;; peek takes any number of arguments, writes them to the
;; current ouput port, and returns the last argument.
;; It is handy to wrap around an expression to look at
;; a value each time is evaluated, e.g.:
;;
;;	(+ 10 (troublesome-fn))
;;	=> (+ 10 (pk 'troublesome-fn-returned (troublesome-fn)))
;;

(define (peek . stuff)
  (newline)
  (display ";;; ")
  (write stuff)
  (newline)
  (car (last-pair stuff)))

(define pk peek)

(define (warn . stuff)
  (with-output-to-port (current-error-port)
    (lambda ()
      (newline)
      (display ";;; WARNING ")
      (display stuff)
      (newline)
      (car (last-pair stuff)))))



;;; {Trivial Functions}
;;;

(define (identity x) x)
(define (and=> value procedure) (and value (procedure value)))
(define call/cc call-with-current-continuation)

;;; apply-to-args is functionally redundant with apply and, worse,
;;; is less general than apply since it only takes two arguments.
;;;
;;; On the other hand, apply-to-args is a syntacticly convenient way to
;;; perform binding in many circumstances when the "let" family of
;;; of forms don't cut it.  E.g.:
;;;
;;;	(apply-to-args (return-3d-mouse-coords)
;;;	  (lambda (x y z)
;;;		...))
;;;

(define (apply-to-args args fn) (apply fn args))

(defmacro false-if-exception (expr)
  `(catch #t (lambda () ,expr)
	  (lambda args #f)))



;;; {General Properties}
;;;

;; This is a more modern interface to properties.  It will replace all
;; other property-like things eventually.

(define (make-object-property)
  (let ((prop (primitive-make-property #f)))
    (make-procedure-with-setter
     (lambda (obj) (primitive-property-ref prop obj))
     (lambda (obj val) (primitive-property-set! prop obj val)))))



;;; {Symbol Properties}
;;;

(define (symbol-property sym prop)
  (let ((pair (assoc prop (symbol-pref sym))))
    (and pair (cdr pair))))

(define (set-symbol-property! sym prop val)
  (let ((pair (assoc prop (symbol-pref sym))))
    (if pair
	(set-cdr! pair val)
	(symbol-pset! sym (acons prop val (symbol-pref sym))))))

(define (symbol-property-remove! sym prop)
  (let ((pair (assoc prop (symbol-pref sym))))
    (if pair
	(symbol-pset! sym (delq! pair (symbol-pref sym))))))



;;; {Arrays}
;;;

(define (array-shape a)
  (map (lambda (ind) (if (number? ind) (list 0 (+ -1 ind)) ind))
       (array-dimensions a)))



;;; {Keywords}
;;;

(define (kw-arg-ref args kw)
  (let ((rem (member kw args)))
    (and rem (pair? (cdr rem)) (cadr rem))))



;;; {Structs}
;;;

(define (struct-layout s)
  (struct-ref (struct-vtable s) vtable-index-layout))



;;; {Environments}
;;;

(define the-environment
  (procedure->syntax
   (lambda (x e)
     e)))

(define the-root-environment (the-environment))

(define (environment-module env)
  (let ((closure (and (pair? env) (car (last-pair env)))))
    (and closure (procedure-property closure 'module))))



;;; {Records}
;;;

;; Printing records: by default, records are printed as
;;
;;   #<type-name field1: val1 field2: val2 ...>
;;
;; You can change that by giving a custom printing function to
;; MAKE-RECORD-TYPE (after the list of field symbols).  This function
;; will be called like
;;
;;   (<printer> object port)
;;
;; It should print OBJECT to PORT.

(define (inherit-print-state old-port new-port)
  (if (get-print-state old-port)
      (port-with-print-state new-port (get-print-state old-port))
      new-port))

;; 0: type-name, 1: fields
(define record-type-vtable
  (make-vtable-vtable "prpr" 0
		      (lambda (s p)
			(cond ((eq? s record-type-vtable)
			       (display "#<record-type-vtable>" p))
			      (else
			       (display "#<record-type " p)
			       (display (record-type-name s) p)
			       (display ">" p))))))

(define (record-type? obj)
  (and (struct? obj) (eq? record-type-vtable (struct-vtable obj))))

(define (make-record-type type-name fields . opt)
  (let ((printer-fn (and (pair? opt) (car opt))))
    (let ((struct (make-struct record-type-vtable 0
			       (make-struct-layout
				(apply string-append
				       (map (lambda (f) "pw") fields)))
			       (or printer-fn
				   (lambda (s p)
				     (display "#<" p)
				     (display type-name p)
				     (let loop ((fields fields)
						(off 0))
				       (cond
					((not (null? fields))
					 (display " " p)
					 (display (car fields) p)
					 (display ": " p)
					 (display (struct-ref s off) p)
					 (loop (cdr fields) (+ 1 off)))))
				     (display ">" p)))
			       type-name
			       (copy-tree fields))))
      ;; Temporary solution: Associate a name to the record type descriptor
      ;; so that the object system can create a wrapper class for it.
      (set-struct-vtable-name! struct (if (symbol? type-name)
					  type-name
					  (string->symbol type-name)))
      struct)))

(define (record-type-name obj)
  (if (record-type? obj)
      (struct-ref obj vtable-offset-user)
      (error 'not-a-record-type obj)))

(define (record-type-fields obj)
  (if (record-type? obj)
      (struct-ref obj (+ 1 vtable-offset-user))
      (error 'not-a-record-type obj)))

(define (record-constructor rtd . opt)
  (let ((field-names (if (pair? opt) (car opt) (record-type-fields rtd))))
    (local-eval `(lambda ,field-names
		   (make-struct ',rtd 0 ,@(map (lambda (f)
						 (if (memq f field-names)
						     f
						     #f))
					       (record-type-fields rtd))))
		the-root-environment)))

(define (record-predicate rtd)
  (lambda (obj) (and (struct? obj) (eq? rtd (struct-vtable obj)))))

(define (%record-type-error rtd obj)  ;; private helper
  (or (eq? rtd (record-type-descriptor obj))
      (scm-error 'wrong-type-arg "%record-type-check"
		 "Wrong type record (want `~S'): ~S"
		 (list (record-type-name rtd) obj)
		 #f)))

(define (record-accessor rtd field-name)
  (let* ((pos (list-index (record-type-fields rtd) field-name)))
    (if (not pos)
	(error 'no-such-field field-name))
    (local-eval `(lambda (obj)
                   (if (eq? (struct-vtable obj) ,rtd)
                       (struct-ref obj ,pos)
                       (%record-type-error ,rtd obj)))
		the-root-environment)))

(define (record-modifier rtd field-name)
  (let* ((pos (list-index (record-type-fields rtd) field-name)))
    (if (not pos)
	(error 'no-such-field field-name))
    (local-eval `(lambda (obj val)
                   (if (eq? (struct-vtable obj) ,rtd)
                       (struct-set! obj ,pos val)
                       (%record-type-error ,rtd obj)))
		the-root-environment)))


(define (record? obj)
  (and (struct? obj) (record-type? (struct-vtable obj))))

(define (record-type-descriptor obj)
  (if (struct? obj)
      (struct-vtable obj)
      (error 'not-a-record obj)))

(provide 'record)



;;; {Booleans}
;;;

(define (->bool x) (not (not x)))



;;; {Symbols}
;;;

(define (symbol-append . args)
  (string->symbol (apply string-append (map symbol->string args))))

(define (list->symbol . args)
  (string->symbol (apply list->string args)))

(define (symbol . args)
  (string->symbol (apply string args)))



;;; {Lists}
;;;

(define (list-index l k)
  (let loop ((n 0)
	     (l l))
    (and (not (null? l))
	 (if (eq? (car l) k)
	     n
	     (loop (+ n 1) (cdr l))))))



;;; {and-map and or-map}
;;;
;;; (and-map fn lst) is like (and (fn (car lst)) (fn (cadr lst)) (fn...) ...)
;;; (or-map fn lst) is like (or (fn (car lst)) (fn (cadr lst)) (fn...) ...)
;;;

;; and-map f l
;;
;; Apply f to successive elements of l until exhaustion or f returns #f.
;; If returning early, return #f.  Otherwise, return the last value returned
;; by f.  If f has never been called because l is empty, return #t.
;;
(define (and-map f lst)
  (let loop ((result #t)
	     (l lst))
    (and result
	 (or (and (null? l)
		  result)
	     (loop (f (car l)) (cdr l))))))

;; or-map f l
;;
;; Apply f to successive elements of l until exhaustion or while f returns #f.
;; If returning early, return the return value of f.
;;
(define (or-map f lst)
  (let loop ((result #f)
	     (l lst))
    (or result
	(and (not (null? l))
	     (loop (f (car l)) (cdr l))))))



(if (provided? 'posix)
    (primitive-load-path "ice-9/posix.scm"))

(if (provided? 'socket)
    (primitive-load-path "ice-9/networking.scm"))

;; For reference, Emacs file-exists-p uses stat in this same way.
;; ENHANCE-ME: Catching an exception from stat is a bit wasteful, do this in
;; C where all that's needed is to inspect the return from stat().
(define file-exists?
  (if (provided? 'posix)
      (lambda (str)
	(->bool (false-if-exception (stat str))))
      (lambda (str)
	(let ((port (catch 'system-error (lambda () (open-file str OPEN_READ))
			   (lambda args #f))))
	  (if port (begin (close-port port) #t)
	      #f)))))

(define file-is-directory?
  (if (provided? 'posix)
      (lambda (str)
	(eq? (stat:type (stat str)) 'directory))
      (lambda (str)
	(let ((port (catch 'system-error
			   (lambda () (open-file (string-append str "/.")
						 OPEN_READ))
			   (lambda args #f))))
	  (if port (begin (close-port port) #t)
	      #f)))))

(define (has-suffix? str suffix)
  (let ((sufl (string-length suffix))
	(sl (string-length str)))
    (and (> sl sufl)
	 (string=? (substring str (- sl sufl) sl) suffix))))

(define (system-error-errno args)
  (if (eq? (car args) 'system-error)
      (car (list-ref args 4))
      #f))



;;; {Error Handling}
;;;

(define (error . args)
  (save-stack)
  (if (null? args)
      (scm-error 'misc-error #f "?" #f #f)
      (let loop ((msg "~A")
		 (rest (cdr args)))
	(if (not (null? rest))
	    (loop (string-append msg " ~S")
		  (cdr rest))
	    (scm-error 'misc-error #f msg args #f)))))

;; bad-throw is the hook that is called upon a throw to a an unhandled
;; key (unless the throw has four arguments, in which case
;; it's usually interpreted as an error throw.)
;; If the key has a default handler (a throw-handler-default property),
;; it is applied to the throw.
;;
(define (bad-throw key . args)
  (let ((default (symbol-property key 'throw-handler-default)))
    (or (and default (apply default key args))
	(apply error "unhandled-exception:" key args))))



(define (tm:sec obj) (vector-ref obj 0))
(define (tm:min obj) (vector-ref obj 1))
(define (tm:hour obj) (vector-ref obj 2))
(define (tm:mday obj) (vector-ref obj 3))
(define (tm:mon obj) (vector-ref obj 4))
(define (tm:year obj) (vector-ref obj 5))
(define (tm:wday obj) (vector-ref obj 6))
(define (tm:yday obj) (vector-ref obj 7))
(define (tm:isdst obj) (vector-ref obj 8))
(define (tm:gmtoff obj) (vector-ref obj 9))
(define (tm:zone obj) (vector-ref obj 10))

(define (set-tm:sec obj val) (vector-set! obj 0 val))
(define (set-tm:min obj val) (vector-set! obj 1 val))
(define (set-tm:hour obj val) (vector-set! obj 2 val))
(define (set-tm:mday obj val) (vector-set! obj 3 val))
(define (set-tm:mon obj val) (vector-set! obj 4 val))
(define (set-tm:year obj val) (vector-set! obj 5 val))
(define (set-tm:wday obj val) (vector-set! obj 6 val))
(define (set-tm:yday obj val) (vector-set! obj 7 val))
(define (set-tm:isdst obj val) (vector-set! obj 8 val))
(define (set-tm:gmtoff obj val) (vector-set! obj 9 val))
(define (set-tm:zone obj val) (vector-set! obj 10 val))

(define (tms:clock obj) (vector-ref obj 0))
(define (tms:utime obj) (vector-ref obj 1))
(define (tms:stime obj) (vector-ref obj 2))
(define (tms:cutime obj) (vector-ref obj 3))
(define (tms:cstime obj) (vector-ref obj 4))

(define file-position ftell)
(define (file-set-position port offset . whence)
  (let ((whence (if (eq? whence '()) SEEK_SET (car whence))))
    (seek port offset whence)))

(define (move->fdes fd/port fd)
  (cond ((integer? fd/port)
	 (dup->fdes fd/port fd)
	 (close fd/port)
	 fd)
	(else
	 (primitive-move->fdes fd/port fd)
	 (set-port-revealed! fd/port 1)
	 fd/port)))

(define (release-port-handle port)
  (let ((revealed (port-revealed port)))
    (if (> revealed 0)
	(set-port-revealed! port (- revealed 1)))))

(define (dup->port port/fd mode . maybe-fd)
  (let ((port (fdopen (apply dup->fdes port/fd maybe-fd)
		      mode)))
    (if (pair? maybe-fd)
	(set-port-revealed! port 1))
    port))

(define (dup->inport port/fd . maybe-fd)
  (apply dup->port port/fd "r" maybe-fd))

(define (dup->outport port/fd . maybe-fd)
  (apply dup->port port/fd "w" maybe-fd))

(define (dup port/fd . maybe-fd)
  (if (integer? port/fd)
      (apply dup->fdes port/fd maybe-fd)
      (apply dup->port port/fd (port-mode port/fd) maybe-fd)))

(define (duplicate-port port modes)
  (dup->port port modes))

(define (fdes->inport fdes)
  (let loop ((rest-ports (fdes->ports fdes)))
    (cond ((null? rest-ports)
	   (let ((result (fdopen fdes "r")))
	     (set-port-revealed! result 1)
	     result))
	  ((input-port? (car rest-ports))
	   (set-port-revealed! (car rest-ports)
			       (+ (port-revealed (car rest-ports)) 1))
	   (car rest-ports))
	  (else
	   (loop (cdr rest-ports))))))

(define (fdes->outport fdes)
  (let loop ((rest-ports (fdes->ports fdes)))
    (cond ((null? rest-ports)
	   (let ((result (fdopen fdes "w")))
	     (set-port-revealed! result 1)
	     result))
	  ((output-port? (car rest-ports))
	   (set-port-revealed! (car rest-ports)
			       (+ (port-revealed (car rest-ports)) 1))
	   (car rest-ports))
	  (else
	   (loop (cdr rest-ports))))))

(define (port->fdes port)
  (set-port-revealed! port (+ (port-revealed port) 1))
  (fileno port))

(define (setenv name value)
  (if value
      (putenv (string-append name "=" value))
      (putenv name)))

(define (unsetenv name)
  "Remove the entry for NAME from the environment."
  (putenv name))



;;; {Load Paths}
;;;

;;; Here for backward compatability
;;
(define scheme-file-suffix (lambda () ".scm"))

(define (in-vicinity vicinity file)
  (let ((tail (let ((len (string-length vicinity)))
		(if (zero? len)
		    #f
		    (string-ref vicinity (- len 1))))))
    (string-append vicinity
		   (if (or (not tail)
			   (eq? tail #\/))
		       ""
		       "/")
		   file)))



;;; {Help for scm_shell}
;;;
;;; The argument-processing code used by Guile-based shells generates
;;; Scheme code based on the argument list.  This page contains help
;;; functions for the code it generates.
;;;

(define (command-line) (program-arguments))

;; This is mostly for the internal use of the code generated by
;; scm_compile_shell_switches.

(define (turn-on-debugging)
  (debug-enable 'debug)
  (debug-enable 'backtrace)
  (read-enable 'positions))

(define (load-user-init)
  (let* ((home (or (getenv "HOME")
		   (false-if-exception (passwd:dir (getpwuid (getuid))))
		   "/"))  ;; fallback for cygwin etc.
	 (init-file (in-vicinity home ".guile")))
    (if (file-exists? init-file)
	(primitive-load init-file))))



;;; {Loading by paths}
;;;

;;; Load a Scheme source file named NAME, searching for it in the
;;; directories listed in %load-path, and applying each of the file
;;; name extensions listed in %load-extensions.
(define (load-from-path name)
  (start-stack 'load-stack
	       (primitive-load-path name)))




;;; {Transcendental Functions}
;;;
;;; Derived from "Transcen.scm", Complex trancendental functions for SCM.
;;; Written by Jerry D. Hedden, (C) FSF.
;;; See the file `COPYING' for terms applying to this program.
;;;

(define expt
  (let ((integer-expt integer-expt))
    (lambda (z1 z2)
      (cond ((and (exact? z2) (integer? z2))
	     (integer-expt z1 z2))
	    ((and (real? z2) (real? z1) (>= z1 0))
	     ($expt z1 z2))
	    (else
	     (exp (* z2 (log z1))))))))

(define (sinh z)
  (if (real? z) ($sinh z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($sinh x) ($cos y))
			  (* ($cosh x) ($sin y))))))
(define (cosh z)
  (if (real? z) ($cosh z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($cosh x) ($cos y))
			  (* ($sinh x) ($sin y))))))
(define (tanh z)
  (if (real? z) ($tanh z)
      (let* ((x (* 2 (real-part z)))
	     (y (* 2 (imag-part z)))
	     (w (+ ($cosh x) ($cos y))))
	(make-rectangular (/ ($sinh x) w) (/ ($sin y) w)))))

(define (asinh z)
  (if (real? z) ($asinh z)
      (log (+ z (sqrt (+ (* z z) 1))))))

(define (acosh z)
  (if (and (real? z) (>= z 1))
      ($acosh z)
      (log (+ z (sqrt (- (* z z) 1))))))

(define (atanh z)
  (if (and (real? z) (> z -1) (< z 1))
      ($atanh z)
      (/ (log (/ (+ 1 z) (- 1 z))) 2)))

(define (sin z)
  (if (real? z) ($sin z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($sin x) ($cosh y))
			  (* ($cos x) ($sinh y))))))
(define (cos z)
  (if (real? z) ($cos z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($cos x) ($cosh y))
			  (- (* ($sin x) ($sinh y)))))))
(define (tan z)
  (if (real? z) ($tan z)
      (let* ((x (* 2 (real-part z)))
	     (y (* 2 (imag-part z)))
	     (w (+ ($cos x) ($cosh y))))
	(make-rectangular (/ ($sin x) w) (/ ($sinh y) w)))))

(define (asin z)
  (if (and (real? z) (>= z -1) (<= z 1))
      ($asin z)
      (* -i (asinh (* +i z)))))

(define (acos z)
  (if (and (real? z) (>= z -1) (<= z 1))
      ($acos z)
      (+ (/ (angle -1) 2) (* +i (asinh (* +i z))))))

(define (atan z . y)
  (if (null? y)
      (if (real? z) ($atan z)
	  (/ (log (/ (- +i z) (+ +i z))) +2i))
      ($atan2 z (car y))))



;;; {Reader Extensions}
;;;
;;; Reader code for various "#c" forms.
;;;

(read-hash-extend #\' (lambda (c port)
			(read port)))

(define read-eval? (make-fluid))
(fluid-set! read-eval? #f)
(read-hash-extend #\.
                  (lambda (c port)
                    (if (fluid-ref read-eval?)
                        (eval (read port) (interaction-environment))
                        (error
                         "#. read expansion found and read-eval? is #f."))))



;;; {Command Line Options}
;;;

(define (get-option argv kw-opts kw-args return)
  (cond
   ((null? argv)
    (return #f #f argv))

   ((or (not (eq? #\- (string-ref (car argv) 0)))
	(eq? (string-length (car argv)) 1))
    (return 'normal-arg (car argv) (cdr argv)))

   ((eq? #\- (string-ref (car argv) 1))
    (let* ((kw-arg-pos (or (string-index (car argv) #\=)
			   (string-length (car argv))))
	   (kw (symbol->keyword (substring (car argv) 2 kw-arg-pos)))
	   (kw-opt? (member kw kw-opts))
	   (kw-arg? (member kw kw-args))
	   (arg (or (and (not (eq? kw-arg-pos (string-length (car argv))))
			 (substring (car argv)
				    (+ kw-arg-pos 1)
				    (string-length (car argv))))
		    (and kw-arg?
			 (begin (set! argv (cdr argv)) (car argv))))))
      (if (or kw-opt? kw-arg?)
	  (return kw arg (cdr argv))
	  (return 'usage-error kw (cdr argv)))))

   (else
    (let* ((char (substring (car argv) 1 2))
	   (kw (symbol->keyword char)))
      (cond

       ((member kw kw-opts)
	(let* ((rest-car (substring (car argv) 2 (string-length (car argv))))
	       (new-argv (if (= 0 (string-length rest-car))
			     (cdr argv)
			     (cons (string-append "-" rest-car) (cdr argv)))))
	  (return kw #f new-argv)))

       ((member kw kw-args)
	(let* ((rest-car (substring (car argv) 2 (string-length (car argv))))
	       (arg (if (= 0 (string-length rest-car))
			(cadr argv)
			rest-car))
	       (new-argv (if (= 0 (string-length rest-car))
			     (cddr argv)
			     (cdr argv))))
	  (return kw arg new-argv)))

       (else (return 'usage-error kw argv)))))))

(define (for-next-option proc argv kw-opts kw-args)
  (let loop ((argv argv))
    (get-option argv kw-opts kw-args
		(lambda (opt opt-arg argv)
		  (and opt (proc opt opt-arg argv loop))))))

(define (display-usage-report kw-desc)
  (for-each
   (lambda (kw)
     (or (eq? (car kw) #t)
	 (eq? (car kw) 'else)
	 (let* ((opt-desc kw)
		(help (cadr opt-desc))
		(opts (car opt-desc))
		(opts-proper (if (string? (car opts)) (cdr opts) opts))
		(arg-name (if (string? (car opts))
			      (string-append "<" (car opts) ">")
			      ""))
		(left-part (string-append
			    (with-output-to-string
			      (lambda ()
				(map (lambda (x) (display (keyword->symbol x)) (display " "))
				     opts-proper)))
			    arg-name))
		(middle-part (if (and (< (string-length left-part) 30)
				      (< (string-length help) 40))
				 (make-string (- 30 (string-length left-part)) #\ )
				 "\n\t")))
	   (display left-part)
	   (display middle-part)
	   (display help)
	   (newline))))
   kw-desc))



(define (transform-usage-lambda cases)
  (let* ((raw-usage (delq! 'else (map car cases)))
	 (usage-sans-specials (map (lambda (x)
				    (or (and (not (list? x)) x)
					(and (symbol? (car x)) #t)
					(and (boolean? (car x)) #t)
					x))
				  raw-usage))
	 (usage-desc (delq! #t usage-sans-specials))
	 (kw-desc (map car usage-desc))
	 (kw-opts (apply append (map (lambda (x) (and (not (string? (car x))) x)) kw-desc)))
	 (kw-args (apply append (map (lambda (x) (and (string? (car x)) (cdr x))) kw-desc)))
	 (transmogrified-cases (map (lambda (case)
				      (cons (let ((opts (car case)))
					      (if (or (boolean? opts) (eq? 'else opts))
						  opts
						  (cond
						   ((symbol? (car opts))  opts)
						   ((boolean? (car opts)) opts)
						   ((string? (caar opts)) (cdar opts))
						   (else (car opts)))))
					    (cdr case)))
				    cases)))
    `(let ((%display-usage (lambda () (display-usage-report ',usage-desc))))
       (lambda (%argv)
	 (let %next-arg ((%argv %argv))
	   (get-option %argv
		       ',kw-opts
		       ',kw-args
		       (lambda (%opt %arg %new-argv)
			 (case %opt
			   ,@ transmogrified-cases))))))))




;;; {Low Level Modules}
;;;
;;; These are the low level data structures for modules.
;;;
;;; Every module object is of the type 'module-type', which is a record
;;; consisting of the following members:
;;;
;;; - eval-closure: the function that defines for its module the strategy that
;;;   shall be followed when looking up symbols in the module.
;;;
;;;   An eval-closure is a function taking two arguments: the symbol to be
;;;   looked up and a boolean value telling whether a binding for the symbol
;;;   should be created if it does not exist yet.  If the symbol lookup
;;;   succeeded (either because an existing binding was found or because a new
;;;   binding was created), a variable object representing the binding is
;;;   returned.  Otherwise, the value #f is returned.  Note that the eval
;;;   closure does not take the module to be searched as an argument: During
;;;   construction of the eval-closure, the eval-closure has to store the
;;;   module it belongs to in its environment.  This means, that any
;;;   eval-closure can belong to only one module.
;;;
;;;   The eval-closure of a module can be defined arbitrarily.  However, three
;;;   special cases of eval-closures are to be distinguished: During startup
;;;   the module system is not yet activated.  In this phase, no modules are
;;;   defined and all bindings are automatically stored by the system in the
;;;   pre-modules-obarray.  Since no eval-closures exist at this time, the
;;;   functions which require an eval-closure as their argument need to be
;;;   passed the value #f.
;;;
;;;   The other two special cases of eval-closures are the
;;;   standard-eval-closure and the standard-interface-eval-closure.  Both
;;;   behave equally for the case that no new binding is to be created.  The
;;;   difference between the two comes in, when the boolean argument to the
;;;   eval-closure indicates that a new binding shall be created if it is not
;;;   found.
;;;
;;;   Given that no new binding shall be created, both standard eval-closures
;;;   define the following standard strategy of searching bindings in the
;;;   module: First, the module's obarray is searched for the symbol.  Second,
;;;   if no binding for the symbol was found in the module's obarray, the
;;;   module's binder procedure is exececuted.  If this procedure did not
;;;   return a binding for the symbol, the modules referenced in the module's
;;;   uses list are recursively searched for a binding of the symbol.  If the
;;;   binding can not be found in these modules also, the symbol lookup has
;;;   failed.
;;;
;;;   If a new binding shall be created, the standard-interface-eval-closure
;;;   immediately returns indicating failure.  That is, it does not even try
;;;   to look up the symbol.  In contrast, the standard-eval-closure would
;;;   first search the obarray, and if no binding was found there, would
;;;   create a new binding in the obarray, therefore not calling the binder
;;;   procedure or searching the modules in the uses list.
;;;
;;;   The explanation of the following members obarray, binder and uses
;;;   assumes that the symbol lookup follows the strategy that is defined in
;;;   the standard-eval-closure and the standard-interface-eval-closure.
;;;
;;; - obarray: a hash table that maps symbols to variable objects.  In this
;;;   hash table, the definitions are found that are local to the module (that
;;;   is, not imported from other modules).  When looking up bindings in the
;;;   module, this hash table is searched first.
;;;
;;; - binder: either #f or a function taking a module and a symbol argument.
;;;   If it is a function it is called after the obarray has been
;;;   unsuccessfully searched for a binding.  It then can provide bindings
;;;   that would otherwise not be found locally in the module.
;;;
;;; - uses: a list of modules from which non-local bindings can be inherited.
;;;   These modules are the third place queried for bindings after the obarray
;;;   has been unsuccessfully searched and the binder function did not deliver
;;;   a result either.
;;;
;;; - transformer: either #f or a function taking a scheme expression as
;;;   delivered by read.  If it is a function, it will be called to perform
;;;   syntax transformations (e. g. makro expansion) on the given scheme
;;;   expression. The output of the transformer function will then be passed
;;;   to Guile's internal memoizer.  This means that the output must be valid
;;;   scheme code.  The only exception is, that the output may make use of the
;;;   syntax extensions provided to identify the modules that a binding
;;;   belongs to.
;;;
;;; - name: the name of the module.  This is used for all kinds of printing
;;;   outputs.  In certain places the module name also serves as a way of
;;;   identification.  When adding a module to the uses list of another
;;;   module, it is made sure that the new uses list will not contain two
;;;   modules of the same name.
;;;
;;; - kind: classification of the kind of module.  The value is (currently?)
;;;   only used for printing.  It has no influence on how a module is treated.
;;;   Currently the following values are used when setting the module kind:
;;;   'module, 'directory, 'interface, 'custom-interface.  If no explicit kind
;;;   is set, it defaults to 'module.
;;;
;;; - duplicates-handlers
;;;
;;; - duplicates-interface
;;;
;;; - observers
;;;
;;; - weak-observers
;;;
;;; - observer-id
;;;
;;; In addition, the module may (must?) contain a binding for
;;; %module-public-interface... More explanations here...
;;;
;;; !!! warning: The interface to lazy binder procedures is going
;;; to be changed in an incompatible way to permit all the basic
;;; module ops to be virtualized.
;;;
;;; (make-module size use-list lazy-binding-proc) => module
;;; module-{obarray,uses,binder}[|-set!]
;;; (module? obj) => [#t|#f]
;;; (module-locally-bound? module symbol) => [#t|#f]
;;; (module-bound? module symbol) => [#t|#f]
;;; (module-symbol-locally-interned? module symbol) => [#t|#f]
;;; (module-symbol-interned? module symbol) => [#t|#f]
;;; (module-local-variable module symbol) => [#<variable ...> | #f]
;;; (module-variable module symbol) => [#<variable ...> | #f]
;;; (module-symbol-binding module symbol opt-value)
;;;		=> [ <obj> | opt-value | an error occurs ]
;;; (module-make-local-var! module symbol) => #<variable...>
;;; (module-add! module symbol var) => unspecified
;;; (module-remove! module symbol) =>  unspecified
;;; (module-for-each proc module) => unspecified
;;; (make-scm-module) => module ; a lazy copy of the symhash module
;;; (set-current-module module) => unspecified
;;; (current-module) => #<module...>
;;;
;;;



;;; {Printing Modules}
;;;

;; This is how modules are printed.  You can re-define it.
;; (Redefining is actually more complicated than simply redefining
;; %print-module because that would only change the binding and not
;; the value stored in the vtable that determines how record are
;; printed. Sigh.)

(define (%print-module mod port)  ; unused args: depth length style table)
  (display "#<" port)
  (display (or (module-kind mod) "module") port)
  (let ((name (module-name mod)))
    (if name
	(begin
	  (display " " port)
	  (display name port))))
  (display " " port)
  (display (number->string (object-address mod) 16) port)
  (display ">" port))

;; module-type
;;
;; A module is characterized by an obarray in which local symbols
;; are interned, a list of modules, "uses", from which non-local
;; bindings can be inherited, and an optional lazy-binder which
;; is a (CLOSURE module symbol) which, as a last resort, can provide
;; bindings that would otherwise not be found locally in the module.
;;
;; NOTE: If you change anything here, you also need to change
;; libguile/modules.h.
;;
(define module-type
  (make-record-type 'module
		    '(obarray uses binder eval-closure transformer name kind
		      duplicates-handlers duplicates-interface
		      observers weak-observers observer-id)
		    %print-module))

;; make-module &opt size uses binder
;;
;; Create a new module, perhaps with a particular size of obarray,
;; initial uses list, or binding procedure.
;;
(define make-module
    (lambda args

      (define (parse-arg index default)
	(if (> (length args) index)
	    (list-ref args index)
	    default))

      (if (> (length args) 3)
	  (error "Too many args to make-module." args))

      (let ((size (parse-arg 0 31))
	    (uses (parse-arg 1 '()))
	    (binder (parse-arg 2 #f)))

	(if (not (integer? size))
	    (error "Illegal size to make-module." size))
	(if (not (and (list? uses)
		      (and-map module? uses)))
	    (error "Incorrect use list." uses))
	(if (and binder (not (procedure? binder)))
	    (error
	     "Lazy-binder expected to be a procedure or #f." binder))

	(let ((module (module-constructor (make-hash-table size)
					  uses binder #f #f #f #f #f #f
					  '()
					  (make-weak-value-hash-table 31)
					  0)))

	  ;; We can't pass this as an argument to module-constructor,
	  ;; because we need it to close over a pointer to the module
	  ;; itself.
	  (set-module-eval-closure! module (standard-eval-closure module))

	  module))))

(define module-constructor (record-constructor module-type))
(define module-obarray  (record-accessor module-type 'obarray))
(define set-module-obarray! (record-modifier module-type 'obarray))
(define module-uses  (record-accessor module-type 'uses))
(define set-module-uses! (record-modifier module-type 'uses))
(define module-binder (record-accessor module-type 'binder))
(define set-module-binder! (record-modifier module-type 'binder))

;; NOTE: This binding is used in libguile/modules.c.
(define module-eval-closure (record-accessor module-type 'eval-closure))

(define module-transformer (record-accessor module-type 'transformer))
(define set-module-transformer! (record-modifier module-type 'transformer))
(define module-name (record-accessor module-type 'name))
(define set-module-name! (record-modifier module-type 'name))
(define module-kind (record-accessor module-type 'kind))
(define set-module-kind! (record-modifier module-type 'kind))
(define module-duplicates-handlers
  (record-accessor module-type 'duplicates-handlers))
(define set-module-duplicates-handlers!
  (record-modifier module-type 'duplicates-handlers))
(define module-duplicates-interface
  (record-accessor module-type 'duplicates-interface))
(define set-module-duplicates-interface!
  (record-modifier module-type 'duplicates-interface))
(define module-observers (record-accessor module-type 'observers))
(define set-module-observers! (record-modifier module-type 'observers))
(define module-weak-observers (record-accessor module-type 'weak-observers))
(define module-observer-id (record-accessor module-type 'observer-id))
(define set-module-observer-id! (record-modifier module-type 'observer-id))
(define module? (record-predicate module-type))

(define set-module-eval-closure!
  (let ((setter (record-modifier module-type 'eval-closure)))
    (lambda (module closure)
      (setter module closure)
      ;; Make it possible to lookup the module from the environment.
      ;; This implementation is correct since an eval closure can belong
      ;; to maximally one module.
      (set-procedure-property! closure 'module module))))



;;; {Observer protocol}
;;;

(define (module-observe module proc)
  (set-module-observers! module (cons proc (module-observers module)))
  (cons module proc))

(define (module-observe-weak module proc)
  (let ((id (module-observer-id module)))
    (hash-set! (module-weak-observers module) id proc)
    (set-module-observer-id! module (+ 1 id))
    (cons module id)))

(define (module-unobserve token)
  (let ((module (car token))
	(id (cdr token)))
    (if (integer? id)
	(hash-remove! (module-weak-observers module) id)
	(set-module-observers! module (delq1! id (module-observers module)))))
  *unspecified*)

(define module-defer-observers #f)
(define module-defer-observers-mutex (make-mutex))
(define module-defer-observers-table (make-hash-table))

(define (module-modified m)
  (if module-defer-observers
      (hash-set! module-defer-observers-table m #t)
      (module-call-observers m)))

;;; This function can be used to delay calls to observers so that they
;;; can be called once only in the face of massive updating of modules.
;;;
(define (call-with-deferred-observers thunk)
  (dynamic-wind
      (lambda ()
	(lock-mutex module-defer-observers-mutex)
	(set! module-defer-observers #t))
      thunk
      (lambda ()
	(set! module-defer-observers #f)
	(hash-for-each (lambda (m dummy)
			 (module-call-observers m))
		       module-defer-observers-table)
	(hash-clear! module-defer-observers-table)
	(unlock-mutex module-defer-observers-mutex))))

(define (module-call-observers m)
  (for-each (lambda (proc) (proc m)) (module-observers m))
  (hash-fold (lambda (id proc res) (proc m)) #f (module-weak-observers m)))



;;; {Module Searching in General}
;;;
;;; We sometimes want to look for properties of a symbol
;;; just within the obarray of one module.  If the property
;;; holds, then it is said to hold ``locally'' as in, ``The symbol
;;; DISPLAY is locally rebound in the module `safe-guile'.''
;;;
;;;
;;; Other times, we want to test for a symbol property in the obarray
;;; of M and, if it is not found there, try each of the modules in the
;;; uses list of M.  This is the normal way of testing for some
;;; property, so we state these properties without qualification as
;;; in: ``The symbol 'fnord is interned in module M because it is
;;; interned locally in module M2 which is a member of the uses list
;;; of M.''
;;;

;; module-search fn m
;;
;; return the first non-#f result of FN applied to M and then to
;; the modules in the uses of m, and so on recursively.  If all applications
;; return #f, then so does this function.
;;
(define (module-search fn m v)
  (define (loop pos)
    (and (pair? pos)
	 (or (module-search fn (car pos) v)
	     (loop (cdr pos)))))
  (or (fn m v)
      (loop (module-uses m))))


;;; {Is a symbol bound in a module?}
;;;
;;; Symbol S in Module M is bound if S is interned in M and if the binding
;;; of S in M has been set to some well-defined value.
;;;

;; module-locally-bound? module symbol
;;
;; Is a symbol bound (interned and defined) locally in a given module?
;;
(define (module-locally-bound? m v)
  (let ((var (module-local-variable m v)))
    (and var
	 (variable-bound? var))))

;; module-bound? module symbol
;;
;; Is a symbol bound (interned and defined) anywhere in a given module
;; or its uses?
;;
(define (module-bound? m v)
  (module-search module-locally-bound? m v))

;;; {Is a symbol interned in a module?}
;;;
;;; Symbol S in Module M is interned if S occurs in
;;; of S in M has been set to some well-defined value.
;;;
;;; It is possible to intern a symbol in a module without providing
;;; an initial binding for the corresponding variable.  This is done
;;; with:
;;;       (module-add! module symbol (make-undefined-variable))
;;;
;;; In that case, the symbol is interned in the module, but not
;;; bound there.  The unbound symbol shadows any binding for that
;;; symbol that might otherwise be inherited from a member of the uses list.
;;;

(define (module-obarray-get-handle ob key)
  ((if (symbol? key) hashq-get-handle hash-get-handle) ob key))

(define (module-obarray-ref ob key)
  ((if (symbol? key) hashq-ref hash-ref) ob key))

(define (module-obarray-set! ob key val)
  ((if (symbol? key) hashq-set! hash-set!) ob key val))

(define (module-obarray-remove! ob key)
  ((if (symbol? key) hashq-remove! hash-remove!) ob key))

;; module-symbol-locally-interned? module symbol
;;
;; is a symbol interned (not neccessarily defined) locally in a given module
;; or its uses?  Interned symbols shadow inherited bindings even if
;; they are not themselves bound to a defined value.
;;
(define (module-symbol-locally-interned? m v)
  (not (not (module-obarray-get-handle (module-obarray m) v))))

;; module-symbol-interned? module symbol
;;
;; is a symbol interned (not neccessarily defined) anywhere in a given module
;; or its uses?  Interned symbols shadow inherited bindings even if
;; they are not themselves bound to a defined value.
;;
(define (module-symbol-interned? m v)
  (module-search module-symbol-locally-interned? m v))


;;; {Mapping modules x symbols --> variables}
;;;

;; module-local-variable module symbol
;; return the local variable associated with a MODULE and SYMBOL.
;;
;;; This function is very important. It is the only function that can
;;; return a variable from a module other than the mutators that store
;;; new variables in modules.  Therefore, this function is the location
;;; of the "lazy binder" hack.
;;;
;;; If symbol is defined in MODULE, and if the definition binds symbol
;;; to a variable, return that variable object.
;;;
;;; If the symbols is not found at first, but the module has a lazy binder,
;;; then try the binder.
;;;
;;; If the symbol is not found at all, return #f.
;;;
(define (module-local-variable m v)
;  (caddr
;   (list m v
	 (let ((b (module-obarray-ref (module-obarray m) v)))
	   (or (and (variable? b) b)
	       (and (module-binder m)
		    ((module-binder m) m v #f)))))
;))

;; module-variable module symbol
;;
;; like module-local-variable, except search the uses in the
;; case V is not found in M.
;;
;; NOTE: This function is superseded with C code (see modules.c)
;;;      when using the standard eval closure.
;;
(define (module-variable m v)
  (module-search module-local-variable m v))


;;; {Mapping modules x symbols --> bindings}
;;;
;;; These are similar to the mapping to variables, except that the
;;; variable is dereferenced.
;;;

;; module-symbol-binding module symbol opt-value
;;
;; return the binding of a variable specified by name within
;; a given module, signalling an error if the variable is unbound.
;; If the OPT-VALUE is passed, then instead of signalling an error,
;; return OPT-VALUE.
;;
(define (module-symbol-local-binding m v . opt-val)
  (let ((var (module-local-variable m v)))
    (if (and var (variable-bound? var))
	(variable-ref var)
	(if (not (null? opt-val))
	    (car opt-val)
	    (error "Locally unbound variable." v)))))

;; module-symbol-binding module symbol opt-value
;;
;; return the binding of a variable specified by name within
;; a given module, signalling an error if the variable is unbound.
;; If the OPT-VALUE is passed, then instead of signalling an error,
;; return OPT-VALUE.
;;
(define (module-symbol-binding m v . opt-val)
  (let ((var (module-variable m v)))
    (if (and var (variable-bound? var))
	(variable-ref var)
	(if (not (null? opt-val))
	    (car opt-val)
	    (error "Unbound variable." v)))))




;;; {Adding Variables to Modules}
;;;

;; module-make-local-var! module symbol
;;
;; ensure a variable for V in the local namespace of M.
;; If no variable was already there, then create a new and uninitialzied
;; variable.
;;
;; This function is used in modules.c.
;;
(define (module-make-local-var! m v)
  (or (let ((b (module-obarray-ref (module-obarray m) v)))
	(and (variable? b)
	     (begin
	       ;; Mark as modified since this function is called when
	       ;; the standard eval closure defines a binding
	       (module-modified m)
	       b)))

      ;; Create a new local variable.
      (let ((local-var (make-undefined-variable)))
        (module-add! m v local-var)
        local-var)))

;; module-ensure-local-variable! module symbol
;;
;; Ensure that there is a local variable in MODULE for SYMBOL.  If
;; there is no binding for SYMBOL, create a new uninitialized
;; variable.  Return the local variable.
;;
(define (module-ensure-local-variable! module symbol)
  (or (module-local-variable module symbol)
      (let ((var (make-undefined-variable)))
	(module-add! module symbol var)
	var)))

;; module-add! module symbol var
;;
;; ensure a particular variable for V in the local namespace of M.
;;
(define (module-add! m v var)
  (if (not (variable? var))
      (error "Bad variable to module-add!" var))
  (module-obarray-set! (module-obarray m) v var)
  (module-modified m))

;; module-remove!
;;
;; make sure that a symbol is undefined in the local namespace of M.
;;
(define (module-remove! m v)
  (module-obarray-remove! (module-obarray m) v)
  (module-modified m))

(define (module-clear! m)
  (hash-clear! (module-obarray m))
  (module-modified m))

;; MODULE-FOR-EACH -- exported
;;
;; Call PROC on each symbol in MODULE, with arguments of (SYMBOL VARIABLE).
;;
(define (module-for-each proc module)
  (hash-for-each proc (module-obarray module)))

(define (module-map proc module)
  (hash-map->list proc (module-obarray module)))



;;; {Low Level Bootstrapping}
;;;

;; make-root-module

;; A root module uses the pre-modules-obarray as its obarray.  This
;; special obarray accumulates all bindings that have been established
;; before the module system is fully booted.
;;
;; (The obarray continues to be used by code that has been closed over
;;  before the module system has been booted.)

(define (make-root-module)
  (let ((m (make-module 0)))
    (set-module-obarray! m (%get-pre-modules-obarray))
    m))

;; make-scm-module

;; The root interface is a module that uses the same obarray as the
;; root module.  It does not allow new definitions, tho.

(define (make-scm-module)
  (let ((m (make-module 0)))
    (set-module-obarray! m (%get-pre-modules-obarray))
    (set-module-eval-closure! m (standard-interface-eval-closure m))
    m))




;;; {Module-based Loading}
;;;

(define (save-module-excursion thunk)
  (let ((inner-module (current-module))
	(outer-module #f))
    (dynamic-wind (lambda ()
		    (set! outer-module (current-module))
		    (set-current-module inner-module)
		    (set! inner-module #f))
		  thunk
		  (lambda ()
		    (set! inner-module (current-module))
		    (set-current-module outer-module)
		    (set! outer-module #f)))))

(define basic-load load)

(define (load-module filename . reader)
  (save-module-excursion
   (lambda ()
     (let ((oldname (and (current-load-port)
			 (port-filename (current-load-port)))))
       (apply basic-load
	      (if (and oldname
		       (> (string-length filename) 0)
		       (not (char=? (string-ref filename 0) #\/))
		       (not (string=? (dirname oldname) ".")))
		  (string-append (dirname oldname) "/" filename)
		  filename)
	      reader)))))




;;; {MODULE-REF -- exported}
;;;

;; Returns the value of a variable called NAME in MODULE or any of its
;; used modules.  If there is no such variable, then if the optional third
;; argument DEFAULT is present, it is returned; otherwise an error is signaled.
;;
(define (module-ref module name . rest)
  (let ((variable (module-variable module name)))
    (if (and variable (variable-bound? variable))
	(variable-ref variable)
	(if (null? rest)
	    (error "No variable named" name 'in module)
	    (car rest)			; default value
	    ))))

;; MODULE-SET! -- exported
;;
;; Sets the variable called NAME in MODULE (or in a module that MODULE uses)
;; to VALUE; if there is no such variable, an error is signaled.
;;
(define (module-set! module name value)
  (let ((variable (module-variable module name)))
    (if variable
	(variable-set! variable value)
	(error "No variable named" name 'in module))))

;; MODULE-DEFINE! -- exported
;;
;; Sets the variable called NAME in MODULE to VALUE; if there is no such
;; variable, it is added first.
;;
(define (module-define! module name value)
  (let ((variable (module-local-variable module name)))
    (if variable
	(begin
	  (variable-set! variable value)
	  (module-modified module))
	(let ((variable (make-variable value)))
	  (module-add! module name variable)))))

;; MODULE-DEFINED? -- exported
;;
;; Return #t iff NAME is defined in MODULE (or in a module that MODULE
;; uses)
;;
(define (module-defined? module name)
  (let ((variable (module-variable module name)))
    (and variable (variable-bound? variable))))

;; MODULE-USE! module interface
;;
;; Add INTERFACE to the list of interfaces used by MODULE.
;;
(define (module-use! module interface)
  (set-module-uses! module
		    (cons interface
			  (filter (lambda (m)
				    (not (equal? (module-name m)
						 (module-name interface))))
				  (module-uses module))))
  (module-modified module))

;; MODULE-USE-INTERFACES! module interfaces
;;
;; Same as MODULE-USE! but add multiple interfaces and check for duplicates
;;
(define (module-use-interfaces! module interfaces)
  (let* ((duplicates-handlers? (or (module-duplicates-handlers module)
				   (default-duplicate-binding-procedures)))
	 (uses (module-uses module)))
    ;; remove duplicates-interface
    (set! uses (delq! (module-duplicates-interface module) uses))
    ;; remove interfaces to be added
    (for-each (lambda (interface)
		(set! uses
		      (filter (lambda (m)
				(not (equal? (module-name m)
					     (module-name interface))))
			      uses)))
	      interfaces)
    ;; add interfaces to use list
    (set-module-uses! module uses)
    (for-each (lambda (interface)
		(and duplicates-handlers?
		     ;; perform duplicate checking
		     (process-duplicates module interface))
		(set! uses (cons interface uses))
		(set-module-uses! module uses))
	      interfaces)
    ;; add duplicates interface
    (if (module-duplicates-interface module)
	(set-module-uses! module
			  (cons (module-duplicates-interface module) uses)))
    (module-modified module)))



;;; {Recursive Namespaces}
;;;
;;; A hierarchical namespace emerges if we consider some module to be
;;; root, and variables bound to modules as nested namespaces.
;;;
;;; The routines in this file manage variable names in hierarchical namespace.
;;; Each variable name is a list of elements, looked up in successively nested
;;; modules.
;;;
;;;		(nested-ref some-root-module '(foo bar baz))
;;;		=> <value of a variable named baz in the module bound to bar in
;;;		    the module bound to foo in some-root-module>
;;;
;;;
;;; There are:
;;;
;;;	;; a-root is a module
;;;	;; name is a list of symbols
;;;
;;;	nested-ref a-root name
;;;	nested-set! a-root name val
;;;	nested-define! a-root name val
;;;	nested-remove! a-root name
;;;
;;;
;;; (current-module) is a natural choice for a-root so for convenience there are
;;; also:
;;;
;;;	local-ref name		==	nested-ref (current-module) name
;;;	local-set! name val	==	nested-set! (current-module) name val
;;;	local-define! name val	==	nested-define! (current-module) name val
;;;	local-remove! name	==	nested-remove! (current-module) name
;;;


(define (nested-ref root names)
  (let loop ((cur root)
	     (elts names))
    (cond
     ((null? elts)		cur)
     ((not (module? cur))	#f)
     (else (loop (module-ref cur (car elts) #f) (cdr elts))))))

(define (nested-set! root names val)
  (let loop ((cur root)
	     (elts names))
    (if (null? (cdr elts))
	(module-set! cur (car elts) val)
	(loop (module-ref cur (car elts)) (cdr elts)))))

(define (nested-define! root names val)
  (let loop ((cur root)
	     (elts names))
    (if (null? (cdr elts))
	(module-define! cur (car elts) val)
	(loop (module-ref cur (car elts)) (cdr elts)))))

(define (nested-remove! root names)
  (let loop ((cur root)
	     (elts names))
    (if (null? (cdr elts))
	(module-remove! cur (car elts))
	(loop (module-ref cur (car elts)) (cdr elts)))))

(define (local-ref names) (nested-ref (current-module) names))
(define (local-set! names val) (nested-set! (current-module) names val))
(define (local-define names val) (nested-define! (current-module) names val))
(define (local-remove names) (nested-remove! (current-module) names))




;;; {The (%app) module}
;;;
;;; The root of conventionally named objects not directly in the top level.
;;;
;;; (%app modules)
;;; (%app modules guile)
;;;
;;; The directory of all modules and the standard root module.
;;;

(define (module-public-interface m)
  (module-ref m '%module-public-interface #f))
(define (set-module-public-interface! m i)
  (module-define! m '%module-public-interface i))
(define (set-system-module! m s)
  (set-procedure-property! (module-eval-closure m) 'system-module s))
(define the-root-module (make-root-module))
(define the-scm-module (make-scm-module))
(set-module-public-interface! the-root-module the-scm-module)
(set-module-name! the-root-module '(guile))
(set-module-name! the-scm-module '(guile))
(set-module-kind! the-scm-module 'interface)
(for-each set-system-module! (list the-root-module the-scm-module) '(#t #t))

;; NOTE: This binding is used in libguile/modules.c.
;;
(define (make-modules-in module name)
  (if (null? name)
      module
      (cond
       ((module-ref module (car name) #f)
	=> (lambda (m) (make-modules-in m (cdr name))))
       (else	(let ((m (make-module 31)))
		  (set-module-kind! m 'directory)
		  (set-module-name! m (append (or (module-name module)
						  '())
					      (list (car name))))
		  (module-define! module (car name) m)
		  (make-modules-in m (cdr name)))))))

(define (beautify-user-module! module)
  (let ((interface (module-public-interface module)))
    (if (or (not interface)
	    (eq? interface module))
	(let ((interface (make-module 31)))
	  (set-module-name! interface (module-name module))
	  (set-module-kind! interface 'interface)
	  (set-module-public-interface! module interface))))
  (if (and (not (memq the-scm-module (module-uses module)))
	   (not (eq? module the-root-module)))
      (set-module-uses! module
			(append (module-uses module) (list the-scm-module)))))

;; NOTE: This binding is used in libguile/modules.c.
;;
(define (resolve-module name . maybe-autoload)
  (let ((full-name (append '(%app modules) name)))
    (let ((already (nested-ref the-root-module full-name)))
      (if already
	  ;; The module already exists...
	  (if (and (or (null? maybe-autoload) (car maybe-autoload))
		   (not (module-public-interface already)))
	      ;; ...but we are told to load and it doesn't contain source, so
	      (begin
		(try-load-module name)
		already)
	      ;; simply return it.
	      already)
	  (begin
	    ;; Try to autoload it if we are told so
	    (if (or (null? maybe-autoload) (car maybe-autoload))
		(try-load-module name))
	    ;; Get/create it.
	    (make-modules-in (current-module) full-name))))))

;; Cheat.  These bindings are needed by modules.c, but we don't want
;; to move their real definition here because that would be unnatural.
;;
(define try-module-autoload #f)
(define process-define-module #f)
(define process-use-modules #f)
(define module-export! #f)

;; This boots the module system.  All bindings needed by modules.c
;; must have been defined by now.
;;
(set-current-module the-root-module)

(define %app (make-module 31))
(define app %app) ;; for backwards compatability
(local-define '(%app modules) (make-module 31))
(local-define '(%app modules guile) the-root-module)

;; (define-special-value '(%app modules new-ws) (lambda () (make-scm-module)))

(define (try-load-module name)
  (or (begin-deprecated (try-module-linked name))
      (try-module-autoload name)
      (begin-deprecated (try-module-dynamic-link name))))

(define (purify-module! module)
  "Removes bindings in MODULE which are inherited from the (guile) module."
  (let ((use-list (module-uses module)))
    (if (and (pair? use-list)
	     (eq? (car (last-pair use-list)) the-scm-module))
	(set-module-uses! module (reverse (cdr (reverse use-list)))))))

;; Return a module that is an interface to the module designated by
;; NAME.
;;
;; `resolve-interface' takes four keyword arguments:
;;
;;   #:select SELECTION
;;
;; SELECTION is a list of binding-specs to be imported; A binding-spec
;; is either a symbol or a pair of symbols (ORIG . SEEN), where ORIG
;; is the name in the used module and SEEN is the name in the using
;; module.  Note that SEEN is also passed through RENAMER, below.  The
;; default is to select all bindings.  If you specify no selection but
;; a renamer, only the bindings that already exist in the used module
;; are made available in the interface.  Bindings that are added later
;; are not picked up.
;;
;;   #:hide BINDINGS
;;
;; BINDINGS is a list of bindings which should not be imported.
;;
;;   #:prefix PREFIX
;;
;; PREFIX is a symbol that will be appended to each exported name.
;; The default is to not perform any renaming.
;;
;;   #:renamer RENAMER
;;
;; RENAMER is a procedure that takes a symbol and returns its new
;; name.  The default is not perform any renaming.
;;
;; Signal "no code for module" error if module name is not resolvable
;; or its public interface is not available.  Signal "no binding"
;; error if selected binding does not exist in the used module.
;;
(define (resolve-interface name . args)

  (define (get-keyword-arg args kw def)
    (cond ((memq kw args)
	   => (lambda (kw-arg)
		(if (null? (cdr kw-arg))
		    (error "keyword without value: " kw))
		(cadr kw-arg)))
	  (else
	   def)))

  (let* ((select (get-keyword-arg args #:select #f))
	 (hide (get-keyword-arg args #:hide '()))
	 (renamer (or (get-keyword-arg args #:renamer #f)
		      (let ((prefix (get-keyword-arg args #:prefix #f)))
			(and prefix (symbol-prefix-proc prefix)))
		      identity))
         (module (resolve-module name))
         (public-i (and module (module-public-interface module))))
    (and (or (not module) (not public-i))
         (error "no code for module" name))
    (if (and (not select) (null? hide) (eq? renamer identity))
        public-i
        (let ((selection (or select (module-map (lambda (sym var) sym)
						public-i)))
              (custom-i (make-module 31)))
          (set-module-kind! custom-i 'custom-interface)
	  (set-module-name! custom-i name)
	  ;; XXX - should use a lazy binder so that changes to the
	  ;; used module are picked up automatically.
	  (for-each (lambda (bspec)
		      (let* ((direct? (symbol? bspec))
			     (orig (if direct? bspec (car bspec)))
			     (seen (if direct? bspec (cdr bspec)))
			     (var (or (module-local-variable public-i orig)
				      (module-local-variable module orig)
				      (error
				       ;; fixme: format manually for now
				       (simple-format
					#f "no binding `~A' in module ~A"
					orig name)))))
			(if (memq orig hide)
			    (set! hide (delq! orig hide))
			    (module-add! custom-i
					 (renamer seen)
					 var))))
		    selection)
	  ;; Check that we are not hiding bindings which don't exist
	  (for-each (lambda (binding)
		      (if (not (module-local-variable public-i binding))
			  (error
			   (simple-format
			    #f "no binding `~A' to hide in module ~A"
			    binding name))))
		    hide)
          custom-i))))

(define (symbol-prefix-proc prefix)
  (lambda (symbol)
    (symbol-append prefix symbol)))

;; This function is called from "modules.c".  If you change it, be
;; sure to update "modules.c" as well.

(define (process-define-module args)
  (let* ((module-id (car args))
         (module (resolve-module module-id #f))
         (kws (cdr args))
         (unrecognized (lambda (arg)
                         (error "unrecognized define-module argument" arg))))
    (beautify-user-module! module)
    (let loop ((kws kws)
	       (reversed-interfaces '())
	       (exports '())
	       (re-exports '())
	       (replacements '()))

      (if (null? kws)
	  (call-with-deferred-observers
	   (lambda ()
	     (module-use-interfaces! module (reverse reversed-interfaces))
	     (module-export! module exports)
	     (module-replace! module replacements)
	     (module-re-export! module re-exports)))
	  (case (car kws)
	    ((#:use-module #:use-syntax)
	     (or (pair? (cdr kws))
		 (unrecognized kws))
	     (let* ((interface-args (cadr kws))
		    (interface (apply resolve-interface interface-args)))
	       (and (eq? (car kws) #:use-syntax)
		    (or (symbol? (caar interface-args))
			(error "invalid module name for use-syntax"
			       (car interface-args)))
		    (set-module-transformer!
		     module
		     (module-ref interface
				 (car (last-pair (car interface-args)))
				 #f)))
	       (loop (cddr kws)
		     (cons interface reversed-interfaces)
		     exports
		     re-exports
		     replacements)))
	    ((#:autoload)
	     (or (and (pair? (cdr kws)) (pair? (cddr kws)))
		 (unrecognized kws))
	     (loop (cdddr kws)
		   (cons (make-autoload-interface module
						  (cadr kws)
						  (caddr kws))
			 reversed-interfaces)
		   exports
		   re-exports
		   replacements))
	    ((#:no-backtrace)
	     (set-system-module! module #t)
	     (loop (cdr kws) reversed-interfaces exports re-exports replacements))
	    ((#:pure)
	     (purify-module! module)
	     (loop (cdr kws) reversed-interfaces exports re-exports replacements))
	    ((#:duplicates)
	     (if (not (pair? (cdr kws)))
		 (unrecognized kws))
	     (set-module-duplicates-handlers!
	      module
	      (lookup-duplicates-handlers (cadr kws)))
	     (loop (cddr kws) reversed-interfaces exports re-exports replacements))
	    ((#:export #:export-syntax)
	     (or (pair? (cdr kws))
		 (unrecognized kws))
	     (loop (cddr kws)
		   reversed-interfaces
		   (append (cadr kws) exports)
		   re-exports
		   replacements))
	    ((#:re-export #:re-export-syntax)
	     (or (pair? (cdr kws))
		 (unrecognized kws))
	     (loop (cddr kws)
		   reversed-interfaces
		   exports
		   (append (cadr kws) re-exports)
		   replacements))
	    ((#:replace #:replace-syntax)
	     (or (pair? (cdr kws))
		 (unrecognized kws))
	     (loop (cddr kws)
		   reversed-interfaces
		   exports
		   re-exports
		   (append (cadr kws) replacements)))
	    (else
	     (unrecognized kws)))))
    (run-hook module-defined-hook module)
    module))

;; `module-defined-hook' is a hook that is run whenever a new module
;; is defined.  Its members are called with one argument, the new
;; module.
(define module-defined-hook (make-hook 1))



;;; {Autoload}
;;;

(define (make-autoload-interface module name bindings)
  (let ((b (lambda (a sym definep)
	     (and (memq sym bindings)
		  (let ((i (module-public-interface (resolve-module name))))
		    (if (not i)
			(error "missing interface for module" name))
		    (let ((autoload (memq a (module-uses module))))
		      ;; Replace autoload-interface with actual interface if
		      ;; that has not happened yet.
		      (if (pair? autoload)
			  (set-car! autoload i)))
		    (module-local-variable i sym))))))
    (module-constructor (make-hash-table 0) '() b #f #f name 'autoload #f #f
			'() (make-weak-value-hash-table 31) 0)))

;;; {Compiled module}

(define load-compiled #f)



;;; {Autoloading modules}
;;;

(define autoloads-in-progress '())

;; This function is called from "modules.c".  If you change it, be
;; sure to update "modules.c" as well.

(define (try-module-autoload module-name)
  (let* ((reverse-name (reverse module-name))
	 (name (symbol->string (car reverse-name)))
	 (dir-hint-module-name (reverse (cdr reverse-name)))
	 (dir-hint (apply string-append
			  (map (lambda (elt)
				 (string-append (symbol->string elt) "/"))
			       dir-hint-module-name))))
    (resolve-module dir-hint-module-name #f)
    (and (not (autoload-done-or-in-progress? dir-hint name))
	 (let ((didit #f))
	   (define (load-file proc file)
	     (save-module-excursion (lambda () (proc file)))
	     (set! didit #t))
	   (dynamic-wind
	    (lambda () (autoload-in-progress! dir-hint name))
	    (lambda ()
	      (let ((file (in-vicinity dir-hint name)))
		(cond ((and load-compiled
			    (%search-load-path (string-append file ".go")))
		       => (lambda (full)
			    (load-file load-compiled full)))
		      ((%search-load-path file)
		       => (lambda (full)
			    (with-fluids ((current-reader #f))
			      (load-file primitive-load full)))))))
	    (lambda () (set-autoloaded! dir-hint name didit)))
	   didit))))



;;; {Dynamic linking of modules}
;;;

(define autoloads-done '((guile . guile)))

(define (autoload-done-or-in-progress? p m)
  (let ((n (cons p m)))
    (->bool (or (member n autoloads-done)
		(member n autoloads-in-progress)))))

(define (autoload-done! p m)
  (let ((n (cons p m)))
    (set! autoloads-in-progress
	  (delete! n autoloads-in-progress))
    (or (member n autoloads-done)
	(set! autoloads-done (cons n autoloads-done)))))

(define (autoload-in-progress! p m)
  (let ((n (cons p m)))
    (set! autoloads-done
	  (delete! n autoloads-done))
    (set! autoloads-in-progress (cons n autoloads-in-progress))))

(define (set-autoloaded! p m done?)
  (if done?
      (autoload-done! p m)
      (let ((n (cons p m)))
	(set! autoloads-done (delete! n autoloads-done))
	(set! autoloads-in-progress (delete! n autoloads-in-progress)))))



;;; {Run-time options}
;;;

(define define-option-interface
  (let* ((option-name car)
	 (option-value cadr)
	 (option-documentation caddr)

	 (print-option (lambda (option)
			 (display (option-name option))
			 (if (< (string-length
				 (symbol->string (option-name option)))
				8)
			     (display #\tab))
			 (display #\tab)
			 (display (option-value option))
			 (display #\tab)
			 (display (option-documentation option))
			 (newline)))

	 ;; Below follow the macros defining the run-time option interfaces.

	 (make-options (lambda (interface)
			 `(lambda args
			    (cond ((null? args) (,interface))
				  ((list? (car args))
				   (,interface (car args)) (,interface))
				  (else (for-each ,print-option
						  (,interface #t)))))))

	 (make-enable (lambda (interface)
			`(lambda flags
			   (,interface (append flags (,interface)))
			   (,interface))))

	 (make-disable (lambda (interface)
			 `(lambda flags
			    (let ((options (,interface)))
			      (for-each (lambda (flag)
					  (set! options (delq! flag options)))
					flags)
			      (,interface options)
			      (,interface))))))
    (procedure->memoizing-macro
     (lambda (exp env)
       (let* ((option-group (cadr exp))
	      (interface (car option-group))
	      (options/enable/disable (cadr option-group)))
	 `(begin
	    (define ,(car options/enable/disable)
	      ,(make-options interface))
	    (define ,(cadr options/enable/disable)
	      ,(make-enable interface))
	    (define ,(caddr options/enable/disable)
	      ,(make-disable interface))
	    (defmacro ,(caaddr option-group) (opt val)
	      `(,,(car options/enable/disable)
		(append (,,(car options/enable/disable))
			(list ',opt ,val))))))))))

(define-option-interface
  (eval-options-interface
   (eval-options eval-enable eval-disable)
   (eval-set!)))

(define-option-interface
  (debug-options-interface
   (debug-options debug-enable debug-disable)
   (debug-set!)))

(define-option-interface
  (evaluator-traps-interface
   (traps trap-enable trap-disable)
   (trap-set!)))

(define-option-interface
  (read-options-interface
   (read-options read-enable read-disable)
   (read-set!)))

(define-option-interface
  (print-options-interface
   (print-options print-enable print-disable)
   (print-set!)))



;;; {Running Repls}
;;;

(define (repl read evaler print)
  (let loop ((source (read (current-input-port))))
    (print (evaler source))
    (loop (read (current-input-port)))))

;; A provisional repl that acts like the SCM repl:
;;
(define scm-repl-silent #f)
(define (assert-repl-silence v) (set! scm-repl-silent v))

(define *unspecified* (if #f #f))
(define (unspecified? v) (eq? v *unspecified*))

(define scm-repl-print-unspecified #f)
(define (assert-repl-print-unspecified v) (set! scm-repl-print-unspecified v))

(define scm-repl-verbose #f)
(define (assert-repl-verbosity v) (set! scm-repl-verbose v))

(define scm-repl-prompt "guile> ")

(define (set-repl-prompt! v) (set! scm-repl-prompt v))

(define (default-lazy-handler key . args)
  (save-stack lazy-handler-dispatch)
  (apply throw key args))

(define (lazy-handler-dispatch key . args)
  (apply default-lazy-handler key args))

(define abort-hook (make-hook))

;; these definitions are used if running a script.
;; otherwise redefined in error-catching-loop.
(define (set-batch-mode?! arg) #t)
(define (batch-mode?) #t)

(define (error-catching-loop thunk)
  (let ((status #f)
	(interactive #t))
    (define (loop first)
      (let ((next
	     (catch #t

		    (lambda ()
		      (call-with-unblocked-asyncs
		       (lambda ()
			 (with-traps
			  (lambda ()
			    (first)

			    ;; This line is needed because mark
			    ;; doesn't do closures quite right.
			    ;; Unreferenced locals should be
			    ;; collected.
			    (set! first #f)
			    (let loop ((v (thunk)))
			      (loop (thunk)))
			    #f)))))

		    (lambda (key . args)
		      (case key
			((quit)
			 (set! status args)
			 #f)

			((switch-repl)
			 (apply throw 'switch-repl args))

			((abort)
			 ;; This is one of the closures that require
			 ;; (set! first #f) above
			 ;;
			 (lambda ()
			   (run-hook abort-hook)
			   (force-output (current-output-port))
			   (display "ABORT: "  (current-error-port))
			   (write args (current-error-port))
			   (newline (current-error-port))
			   (if interactive
			       (begin
				 (if (and
				      (not has-shown-debugger-hint?)
				      (not (memq 'backtrace
						 (debug-options-interface)))
				      (stack? (fluid-ref the-last-stack)))
				     (begin
				       (newline (current-error-port))
				       (display
					"Type \"(backtrace)\" to get more information or \"(debug)\" to enter the debugger.\n"
					(current-error-port))
				       (set! has-shown-debugger-hint? #t)))
				 (force-output (current-error-port)))
			       (begin
				 (primitive-exit 1)))
			   (set! stack-saved? #f)))

			(else
			 ;; This is the other cons-leak closure...
			 (lambda ()
			   (cond ((= (length args) 4)
				  (apply handle-system-error key args))
				 (else
				  (apply bad-throw key args)))))))

		    ;; Note that having just `lazy-handler-dispatch'
		    ;; here is connected with the mechanism that
		    ;; produces a nice backtrace upon error.  If, for
		    ;; example, this is replaced with (lambda args
		    ;; (apply lazy-handler-dispatch args)), the stack
		    ;; cutting (in save-stack) goes wrong and ends up
		    ;; saving no stack at all, so there is no
		    ;; backtrace.
		    lazy-handler-dispatch)))

	(if next (loop next) status)))
    (set! set-batch-mode?! (lambda (arg)
			     (cond (arg
				    (set! interactive #f)
				    (restore-signals))
				   (#t
				    (error "sorry, not implemented")))))
    (set! batch-mode? (lambda () (not interactive)))
    (call-with-blocked-asyncs
     (lambda () (loop (lambda () #t))))))

;;(define the-last-stack (make-fluid)) Defined by scm_init_backtrace ()
(define before-signal-stack (make-fluid))
(define stack-saved? #f)

(define (save-stack . narrowing)
  (or stack-saved?
      (cond ((not (memq 'debug (debug-options-interface)))
	     (fluid-set! the-last-stack #f)
	     (set! stack-saved? #t))
	    (else
	     (fluid-set!
	      the-last-stack
	      (case (stack-id #t)
		((repl-stack)
		 (apply make-stack #t save-stack primitive-eval #t 0 narrowing))
		((load-stack)
		 (apply make-stack #t save-stack 0 #t 0 narrowing))
		((tk-stack)
		 (apply make-stack #t save-stack tk-stack-mark #t 0 narrowing))
		((#t)
		 (apply make-stack #t save-stack 0 1 narrowing))
		(else
		 (let ((id (stack-id #t)))
		   (and (procedure? id)
			(apply make-stack #t save-stack id #t 0 narrowing))))))
	     (set! stack-saved? #t)))))

(define before-error-hook (make-hook))
(define after-error-hook (make-hook))
(define before-backtrace-hook (make-hook))
(define after-backtrace-hook (make-hook))

(define has-shown-debugger-hint? #f)

(define (handle-system-error key . args)
  (let ((cep (current-error-port)))
    (cond ((not (stack? (fluid-ref the-last-stack))))
	  ((memq 'backtrace (debug-options-interface))
	   (let ((highlights (if (or (eq? key 'wrong-type-arg)
				     (eq? key 'out-of-range))
				 (list-ref args 3)
				 '())))
	     (run-hook before-backtrace-hook)
	     (newline cep)
	     (display "Backtrace:\n")
	     (display-backtrace (fluid-ref the-last-stack) cep
				#f #f highlights)
	     (newline cep)
	     (run-hook after-backtrace-hook))))
    (run-hook before-error-hook)
    (apply display-error (fluid-ref the-last-stack) cep args)
    (run-hook after-error-hook)
    (force-output cep)
    (throw 'abort key)))

(define (quit . args)
  (apply throw 'quit args))

(define exit quit)

;;(define has-shown-backtrace-hint? #f) Defined by scm_init_backtrace ()

;; Replaced by C code:
;;(define (backtrace)
;;  (if (fluid-ref the-last-stack)
;;      (begin
;;	(newline)
;;	(display-backtrace (fluid-ref the-last-stack) (current-output-port))
;;	(newline)
;;	(if (and (not has-shown-backtrace-hint?)
;;		 (not (memq 'backtrace (debug-options-interface))))
;;	    (begin
;;	      (display
;;"Type \"(debug-enable 'backtrace)\" if you would like a backtrace
;;automatically if an error occurs in the future.\n")
;;	      (set! has-shown-backtrace-hint? #t))))
;;      (display "No backtrace available.\n")))

(define (error-catching-repl r e p)
  (error-catching-loop
   (lambda ()
     (call-with-values (lambda () (e (r)))
       (lambda the-values (for-each p the-values))))))

(define (gc-run-time)
  (cdr (assq 'gc-time-taken (gc-stats))))

(define before-read-hook (make-hook))
(define after-read-hook (make-hook))
(define before-eval-hook (make-hook 1))
(define after-eval-hook (make-hook 1))
(define before-print-hook (make-hook 1))
(define after-print-hook (make-hook 1))

;;; The default repl-reader function.  We may override this if we've
;;; the readline library.
(define repl-reader
  (lambda (prompt)
    (display prompt)
    (force-output)
    (run-hook before-read-hook)
    ((or (fluid-ref current-reader) read) (current-input-port))))

(define (scm-style-repl)

  (letrec (
	   (start-gc-rt #f)
	   (start-rt #f)
	   (repl-report-start-timing (lambda ()
				       (set! start-gc-rt (gc-run-time))
				       (set! start-rt (get-internal-run-time))))
	   (repl-report (lambda ()
			  (display ";;; ")
			  (display (inexact->exact
				    (* 1000 (/ (- (get-internal-run-time) start-rt)
					       internal-time-units-per-second))))
			  (display "  msec  (")
			  (display  (inexact->exact
				     (* 1000 (/ (- (gc-run-time) start-gc-rt)
						internal-time-units-per-second))))
			  (display " msec in gc)\n")))

	   (consume-trailing-whitespace
	    (lambda ()
	      (let ((ch (peek-char)))
		(cond
		 ((eof-object? ch))
		 ((or (char=? ch #\space) (char=? ch #\tab))
		  (read-char)
		  (consume-trailing-whitespace))
		 ((char=? ch #\newline)
		  (read-char))))))
	   (-read (lambda ()
		    (let ((val
			   (let ((prompt (cond ((string? scm-repl-prompt)
						scm-repl-prompt)
					       ((thunk? scm-repl-prompt)
						(scm-repl-prompt))
					       (scm-repl-prompt "> ")
					       (else ""))))
			     (repl-reader prompt))))

		      ;; As described in R4RS, the READ procedure updates the
		      ;; port to point to the first character past the end of
		      ;; the external representation of the object.  This
		      ;; means that it doesn't consume the newline typically
		      ;; found after an expression.  This means that, when
		      ;; debugging Guile with GDB, GDB gets the newline, which
		      ;; it often interprets as a "continue" command, making
		      ;; breakpoints kind of useless.  So, consume any
		      ;; trailing newline here, as well as any whitespace
		      ;; before it.
		      ;; But not if EOF, for control-D.
		      (if (not (eof-object? val))
			  (consume-trailing-whitespace))
		      (run-hook after-read-hook)
		      (if (eof-object? val)
			  (begin
			    (repl-report-start-timing)
			    (if scm-repl-verbose
				(begin
				  (newline)
				  (display ";;; EOF -- quitting")
				  (newline)))
			    (quit 0)))
		      val)))

	   (-eval (lambda (sourc)
		    (repl-report-start-timing)
		    (run-hook before-eval-hook sourc)
		    (let ((val (start-stack 'repl-stack
					    ;; If you change this procedure
					    ;; (primitive-eval), please also
					    ;; modify the repl-stack case in
					    ;; save-stack so that stack cutting
					    ;; continues to work.
					    (primitive-eval sourc))))
		      (run-hook after-eval-hook sourc)
		      val)))


	   (-print (let ((maybe-print (lambda (result)
					(if (or scm-repl-print-unspecified
						(not (unspecified? result)))
					    (begin
					      (write result)
					      (newline))))))
		     (lambda (result)
		       (if (not scm-repl-silent)
			   (begin
			     (run-hook before-print-hook result)
			     (maybe-print result)
			     (run-hook after-print-hook result)
			     (if scm-repl-verbose
				 (repl-report))
			     (force-output))))))

	   (-quit (lambda (args)
		    (if scm-repl-verbose
			(begin
			  (display ";;; QUIT executed, repl exitting")
			  (newline)
			  (repl-report)))
		    args))

	   (-abort (lambda ()
		     (if scm-repl-verbose
			 (begin
			   (display ";;; ABORT executed.")
			   (newline)
			   (repl-report)))
		     (repl -read -eval -print))))

    (let ((status (error-catching-repl -read
				       -eval
				       -print)))
      (-quit status))))




;;; {IOTA functions: generating lists of numbers}
;;;

(define (iota n)
  (let loop ((count (1- n)) (result '()))
    (if (< count 0) result
        (loop (1- count) (cons count result)))))



;;; {collect}
;;;
;;; Similar to `begin' but returns a list of the results of all constituent
;;; forms instead of the result of the last form.
;;; (The definition relies on the current left-to-right
;;;  order of evaluation of operands in applications.)
;;;

(defmacro collect forms
  (cons 'list forms))



;;; {with-fluids}
;;;

;; with-fluids is a convenience wrapper for the builtin procedure
;; `with-fluids*'.  The syntax is just like `let':
;;
;;  (with-fluids ((fluid val)
;;                ...)
;;     body)

(defmacro with-fluids (bindings . body)
  (let ((fluids (map car bindings))
	(values (map cadr bindings)))
    (if (and (= (length fluids) 1) (= (length values) 1))
	`(with-fluid* ,(car fluids) ,(car values) (lambda () ,@body))
	`(with-fluids* (list ,@fluids) (list ,@values)
		       (lambda () ,@body)))))



;;; {Macros}
;;;

;; actually....hobbit might be able to hack these with a little
;; coaxing
;;

(define (primitive-macro? m)
  (and (macro? m)
       (not (macro-transformer m))))

(defmacro define-macro (first . rest)
  (let ((name (if (symbol? first) first (car first)))
	(transformer
	 (if (symbol? first)
	     (car rest)
	     `(lambda ,(cdr first) ,@rest))))
    `(eval-case
      ((load-toplevel)
       (define ,name (defmacro:transformer ,transformer)))
      (else
       (error "define-macro can only be used at the top level")))))


(defmacro define-syntax-macro (first . rest)
  (let ((name (if (symbol? first) first (car first)))
	(transformer
	 (if (symbol? first)
	     (car rest)
	     `(lambda ,(cdr first) ,@rest))))
    `(eval-case
      ((load-toplevel)
       (define ,name (defmacro:syntax-transformer ,transformer)))
      (else
       (error "define-syntax-macro can only be used at the top level")))))



;;; {While}
;;;
;;; with `continue' and `break'.
;;;

;; The inner `do' loop avoids re-establishing a catch every iteration,
;; that's only necessary if continue is actually used.  A new key is
;; generated every time, so break and continue apply to their originating
;; `while' even when recursing.  `while-helper' is an easy way to keep the
;; `key' binding away from the cond and body code.
;;
;; FIXME: This is supposed to have an `unquote' on the `do' the same used
;; for lambda and not, so as to protect against any user rebinding of that
;; symbol, but unfortunately an unquote breaks with ice-9 syncase, eg.
;;
;;     (use-modules (ice-9 syncase))
;;     (while #f)
;;     => ERROR: invalid syntax ()
;;
;; This is probably a bug in syncase.
;;
(define-macro (while cond . body)
  (define (while-helper proc)
    (do ((key (make-symbol "while-key")))
	((catch key
		(lambda ()
		  (proc (lambda () (throw key #t))
			(lambda () (throw key #f))))
		(lambda (key arg) arg)))))
  `(,while-helper (,lambda (break continue)
		    (do ()
			((,not ,cond))
		      ,@body)
		    #t)))




;;; {Module System Macros}
;;;

;; Return a list of expressions that evaluate to the appropriate
;; arguments for resolve-interface according to SPEC.

(define (compile-interface-spec spec)
  (define (make-keyarg sym key quote?)
    (cond ((or (memq sym spec)
	       (memq key spec))
	   => (lambda (rest)
		(if quote?
		    (list key (list 'quote (cadr rest)))
		    (list key (cadr rest)))))
	  (else
	   '())))
  (define (map-apply func list)
    (map (lambda (args) (apply func args)) list))
  (define keys
    ;; sym     key      quote?
    '((:select #:select #t)
      (:hide   #:hide	#t)
      (:prefix #:prefix #t)
      (:renamer #:renamer #f)))
  (if (not (pair? (car spec)))
      `(',spec)
      `(',(car spec)
	,@(apply append (map-apply make-keyarg keys)))))

(define (keyword-like-symbol->keyword sym)
  (symbol->keyword (string->symbol (substring (symbol->string sym) 1))))

(define (compile-define-module-args args)
  ;; Just quote everything except #:use-module and #:use-syntax.  We
  ;; need to know about all arguments regardless since we want to turn
  ;; symbols that look like keywords into real keywords, and the
  ;; keyword args in a define-module form are not regular
  ;; (i.e. no-backtrace doesn't take a value).
  (let loop ((compiled-args `((quote ,(car args))))
	     (args (cdr args)))
    (cond ((null? args)
	   (reverse! compiled-args))
	  ;; symbol in keyword position
	  ((symbol? (car args))
	   (loop compiled-args
		 (cons (keyword-like-symbol->keyword (car args)) (cdr args))))
	  ((memq (car args) '(#:no-backtrace #:pure))
	   (loop (cons (car args) compiled-args)
		 (cdr args)))
	  ((null? (cdr args))
	   (error "keyword without value:" (car args)))
	  ((memq (car args) '(#:use-module #:use-syntax))
	   (loop (cons* `(list ,@(compile-interface-spec (cadr args)))
			(car args)
			compiled-args)
		 (cddr args)))
	  ((eq? (car args) #:autoload)
	   (loop (cons* `(quote ,(caddr args))
			`(quote ,(cadr args))
			(car args)
			compiled-args)
		 (cdddr args)))
	  (else
	   (loop (cons* `(quote ,(cadr args))
			(car args)
			compiled-args)
		 (cddr args))))))

(defmacro define-module args
  `(eval-case
    ((load-toplevel)
     (let ((m (process-define-module
	       (list ,@(compile-define-module-args args)))))
       (set-current-module m)
       m))
    (else
     (error "define-module can only be used at the top level"))))

;; The guts of the use-modules macro.  Add the interfaces of the named
;; modules to the use-list of the current module, in order.

;; This function is called by "modules.c".  If you change it, be sure
;; to change scm_c_use_module as well.

(define (process-use-modules module-interface-args)
  (let ((interfaces (map (lambda (mif-args)
			   (or (apply resolve-interface mif-args)
			       (error "no such module" mif-args)))
			 module-interface-args)))
    (call-with-deferred-observers
     (lambda ()
       (module-use-interfaces! (current-module) interfaces)))))

(defmacro use-modules modules
  `(eval-case
    ((load-toplevel)
     (process-use-modules
      (list ,@(map (lambda (m)
		     `(list ,@(compile-interface-spec m)))
		   modules)))
     *unspecified*)
    (else
     (error "use-modules can only be used at the top level"))))

(defmacro use-syntax (spec)
  `(eval-case
    ((load-toplevel)
     ,@(if (pair? spec)
	   `((process-use-modules (list
				   (list ,@(compile-interface-spec spec))))
	     (set-module-transformer! (current-module)
				      ,(car (last-pair spec))))
	   `((set-module-transformer! (current-module) ,spec)))
     *unspecified*)
    (else
     (error "use-syntax can only be used at the top level"))))

;; Dirk:FIXME:: This incorrect (according to R5RS) syntax needs to be changed
;; as soon as guile supports hygienic macros.
(define define-private define)

(defmacro define-public args
  (define (syntax)
    (error "bad syntax" (list 'define-public args)))
  (define (defined-name n)
    (cond
     ((symbol? n) n)
     ((pair? n) (defined-name (car n)))
     (else (syntax))))
  (cond
   ((null? args)
    (syntax))
   (#t
    (let ((name (defined-name (car args))))
      `(begin
	 (define-private ,@args)
	 (eval-case ((load-toplevel) (export ,name))))))))

(defmacro defmacro-public args
  (define (syntax)
    (error "bad syntax" (list 'defmacro-public args)))
  (define (defined-name n)
    (cond
     ((symbol? n) n)
     (else (syntax))))
  (cond
   ((null? args)
    (syntax))
   (#t
    (let ((name (defined-name (car args))))
      `(begin
	 (eval-case ((load-toplevel) (export-syntax ,name)))
	 (defmacro ,@args))))))

;; Export a local variable

;; This function is called from "modules.c".  If you change it, be
;; sure to update "modules.c" as well.

(define (module-export! m names)
  (let ((public-i (module-public-interface m)))
    (for-each (lambda (name)
		(let ((var (module-ensure-local-variable! m name)))
		  (module-add! public-i name var)))
	      names)))

(define (module-replace! m names)
  (let ((public-i (module-public-interface m)))
    (for-each (lambda (name)
		(let ((var (module-ensure-local-variable! m name)))
		  (set-object-property! var 'replace #t)
		  (module-add! public-i name var)))
	      names)))

;; Re-export a imported variable
;;
(define (module-re-export! m names)
  (let ((public-i (module-public-interface m)))
    (for-each (lambda (name)
		(let ((var (module-variable m name)))
		  (cond ((not var)
			 (error "Undefined variable:" name))
			((eq? var (module-local-variable m name))
			 (error "re-exporting local variable:" name))
			(else
			 (module-add! public-i name var)))))
	      names)))

(defmacro export names
  `(eval-case
    ((load-toplevel)
     (call-with-deferred-observers
      (lambda ()
	(module-export! (current-module) ',names))))
    (else
     (error "export can only be used at the top level"))))

(defmacro re-export names
  `(eval-case
    ((load-toplevel)
     (call-with-deferred-observers
      (lambda ()
	(module-re-export! (current-module) ',names))))
    (else
     (error "re-export can only be used at the top level"))))

(defmacro export-syntax names
  `(export ,@names))

(defmacro re-export-syntax names
  `(re-export ,@names))

(define load load-module)

;; The following macro allows one to write, for example,
;;
;;    (@ (ice-9 pretty-print) pretty-print)
;;
;; to refer directly to the pretty-print variable in module (ice-9
;; pretty-print).  It works by looking up the variable and inserting
;; it directly into the code.  This is understood by the evaluator.
;; Indeed, all references to global variables are memoized into such
;; variable objects.

(define-macro (@ mod-name var-name)
  (let ((var (module-variable (resolve-interface mod-name) var-name)))
    (if (not var)
	(error "no such public variable" (list '@ mod-name var-name)))
    var))

;; The '@@' macro is like '@' but it can also access bindings that
;; have not been explicitely exported.

(define-macro (@@ mod-name var-name)
  (let ((var (module-variable (resolve-module mod-name) var-name)))
    (if (not var)
	(error "no such variable" (list '@@ mod-name var-name)))
    var))



;;; {Parameters}
;;;

(define make-mutable-parameter
  (let ((make (lambda (fluid converter)
		(lambda args
		  (if (null? args)
		      (fluid-ref fluid)
		      (fluid-set! fluid (converter (car args))))))))
    (lambda (init . converter)
      (let ((fluid (make-fluid))
	    (converter (if (null? converter)
			   identity
			   (car converter))))
	(fluid-set! fluid (converter init))
	(make fluid converter)))))



;;; {Handling of duplicate imported bindings}
;;;

;; Duplicate handlers take the following arguments:
;;
;; module  importing module
;; name	   conflicting name
;; int1	   old interface where name occurs
;; val1	   value of binding in old interface
;; int2	   new interface where name occurs
;; val2	   value of binding in new interface
;; var	   previous resolution or #f
;; val	   value of previous resolution
;;
;; A duplicate handler can take three alternative actions:
;;
;; 1. return #f => leave responsibility to next handler
;; 2. exit with an error
;; 3. return a variable resolving the conflict
;;

(define duplicate-handlers
  (let ((m (make-module 7)))
    
    (define (check module name int1 val1 int2 val2 var val)
      (scm-error 'misc-error
		 #f
		 "~A: `~A' imported from both ~A and ~A"
		 (list (module-name module)
		       name
		       (module-name int1)
		       (module-name int2))
		 #f))
    
    (define (warn module name int1 val1 int2 val2 var val)
      (format (current-error-port)
	      "WARNING: ~A: `~A' imported from both ~A and ~A\n"
	      (module-name module)
	      name
	      (module-name int1)
	      (module-name int2))
      #f)
     
    (define (replace module name int1 val1 int2 val2 var val)
      (let ((old (or (and var (object-property var 'replace) var)
		     (module-variable int1 name)))
	    (new (module-variable int2 name)))
	(if (object-property old 'replace)
	    (and (or (eq? old new)
		     (not (object-property new 'replace)))
		 old)
	    (and (object-property new 'replace)
		 new))))
    
    (define (warn-override-core module name int1 val1 int2 val2 var val)
      (and (eq? int1 the-scm-module)
	   (begin
	     (format (current-error-port)
		     "WARNING: ~A: imported module ~A overrides core binding `~A'\n"
		     (module-name module)
		     (module-name int2)
		     name)
	     (module-local-variable int2 name))))
     
    (define (first module name int1 val1 int2 val2 var val)
      (or var (module-local-variable int1 name)))
     
    (define (last module name int1 val1 int2 val2 var val)
      (module-local-variable int2 name))
     
    (define (noop module name int1 val1 int2 val2 var val)
      #f)
    
    (set-module-name! m 'duplicate-handlers)
    (set-module-kind! m 'interface)
    (module-define! m 'check check)
    (module-define! m 'warn warn)
    (module-define! m 'replace replace)
    (module-define! m 'warn-override-core warn-override-core)
    (module-define! m 'first first)
    (module-define! m 'last last)
    (module-define! m 'merge-generics noop)
    (module-define! m 'merge-accessors noop)
    m))

(define (lookup-duplicates-handlers handler-names)
  (and handler-names
       (map (lambda (handler-name)
	      (or (module-symbol-local-binding
		   duplicate-handlers handler-name #f)
		  (error "invalid duplicate handler name:"
			 handler-name)))
	    (if (list? handler-names)
		handler-names
		(list handler-names)))))

(define default-duplicate-binding-procedures
  (make-mutable-parameter #f))

(define default-duplicate-binding-handler
  (make-mutable-parameter '(replace warn-override-core warn last)
			  (lambda (handler-names)
			    (default-duplicate-binding-procedures
			      (lookup-duplicates-handlers handler-names))
			    handler-names)))

(define (make-duplicates-interface)
  (let ((m (make-module)))
    (set-module-kind! m 'custom-interface)
    (set-module-name! m 'duplicates)
    m))

(define (process-duplicates module interface)
  (let* ((duplicates-handlers (or (module-duplicates-handlers module)
				  (default-duplicate-binding-procedures)))
	 (duplicates-interface (module-duplicates-interface module)))
    (module-for-each
     (lambda (name var)
       (cond ((module-import-interface module name)
	      =>
	      (lambda (prev-interface)
		(let ((var1 (module-local-variable prev-interface name))
		      (var2 (module-local-variable interface name)))
		  (if (not (eq? var1 var2))
		      (begin
			(if (not duplicates-interface)
			    (begin
			      (set! duplicates-interface
				    (make-duplicates-interface))
			      (set-module-duplicates-interface!
			       module
			       duplicates-interface)))
			(let* ((var (module-local-variable duplicates-interface
							   name))
			       (val (and var
					 (variable-bound? var)
					 (variable-ref var))))
			  (let loop ((duplicates-handlers duplicates-handlers))
			    (cond ((null? duplicates-handlers))
				  (((car duplicates-handlers)
				    module
				    name
				    prev-interface
				    (and (variable-bound? var1)
					 (variable-ref var1))
				    interface
				    (and (variable-bound? var2)
					 (variable-ref var2))
				    var
				    val)
				   =>
				   (lambda (var)
				     (module-add! duplicates-interface name var)))
				  (else
				   (loop (cdr duplicates-handlers)))))))))))))
     interface)))



;;; {`cond-expand' for SRFI-0 support.}
;;;
;;; This syntactic form expands into different commands or
;;; definitions, depending on the features provided by the Scheme
;;; implementation.
;;;
;;; Syntax:
;;;
;;; <cond-expand>
;;;   --> (cond-expand <cond-expand-clause>+)
;;;     | (cond-expand <cond-expand-clause>* (else <command-or-definition>))
;;; <cond-expand-clause>
;;;   --> (<feature-requirement> <command-or-definition>*)
;;; <feature-requirement>
;;;   --> <feature-identifier>
;;;     | (and <feature-requirement>*)
;;;     | (or <feature-requirement>*)
;;;     | (not <feature-requirement>)
;;; <feature-identifier>
;;;   --> <a symbol which is the name or alias of a SRFI>
;;;
;;; Additionally, this implementation provides the
;;; <feature-identifier>s `guile' and `r5rs', so that programs can
;;; determine the implementation type and the supported standard.
;;;
;;; Currently, the following feature identifiers are supported:
;;;
;;;   guile r5rs srfi-0 srfi-4 srfi-6 srfi-13 srfi-14 srfi-55 srfi-61
;;;
;;; Remember to update the features list when adding more SRFIs.
;;;

(define %cond-expand-features
  ;; Adjust the above comment when changing this.
  '(guile
    r5rs
    srfi-0   ;; cond-expand itself
    srfi-4   ;; homogenous numeric vectors
    srfi-6   ;; open-input-string etc, in the guile core
    srfi-13  ;; string library
    srfi-14  ;; character sets
    srfi-55  ;; require-extension
    srfi-61  ;; general cond clause
    ))

;; This table maps module public interfaces to the list of features.
;;
(define %cond-expand-table (make-hash-table 31))

;; Add one or more features to the `cond-expand' feature list of the
;; module `module'.
;;
(define (cond-expand-provide module features)
  (let ((mod (module-public-interface module)))
    (and mod
	 (hashq-set! %cond-expand-table mod
		     (append (hashq-ref %cond-expand-table mod '())
			     features)))))

(define cond-expand
  (procedure->memoizing-macro
   (lambda (exp env)
     (let ((clauses (cdr exp))
	   (syntax-error (lambda (cl)
			   (error "invalid clause in `cond-expand'" cl))))
       (letrec
	   ((test-clause
	     (lambda (clause)
	       (cond
		((symbol? clause)
		 (or (memq clause %cond-expand-features)
		     (let lp ((uses (module-uses (env-module env))))
		       (if (pair? uses)
			   (or (memq clause
				     (hashq-ref %cond-expand-table
						(car uses) '()))
			       (lp (cdr uses)))
			   #f))))
		((pair? clause)
		 (cond
		  ((eq? 'and (car clause))
		   (let lp ((l (cdr clause)))
		     (cond ((null? l)
			    #t)
			   ((pair? l)
			    (and (test-clause (car l)) (lp (cdr l))))
			   (else
			    (syntax-error clause)))))
		  ((eq? 'or (car clause))
		   (let lp ((l (cdr clause)))
		     (cond ((null? l)
			    #f)
			   ((pair? l)
			    (or (test-clause (car l)) (lp (cdr l))))
			   (else
			    (syntax-error clause)))))
		  ((eq? 'not (car clause))
		   (cond ((not (pair? (cdr clause)))
			  (syntax-error clause))
			 ((pair? (cddr clause))
			  ((syntax-error clause))))
		   (not (test-clause (cadr clause))))
		  (else
		   (syntax-error clause))))
		(else
		 (syntax-error clause))))))
	 (let lp ((c clauses))
	   (cond
	    ((null? c)
	     (error "Unfulfilled `cond-expand'"))
	    ((not (pair? c))
	     (syntax-error c))
	    ((not (pair? (car c)))
	     (syntax-error (car c)))
	    ((test-clause (caar c))
	     `(begin ,@(cdar c)))
	    ((eq? (caar c) 'else)
	     (if (pair? (cdr c))
		 (syntax-error c))
	     `(begin ,@(cdar c)))
	    (else
	     (lp (cdr c))))))))))

;; This procedure gets called from the startup code with a list of
;; numbers, which are the numbers of the SRFIs to be loaded on startup.
;;
(define (use-srfis srfis)
  (process-use-modules
   (map (lambda (num)
	  (list (list 'srfi (string->symbol
			     (string-append "srfi-" (number->string num))))))
	srfis)))



;;; srfi-55: require-extension
;;;

(define-macro (require-extension extension-spec)
  ;; This macro only handles the srfi extension, which, at present, is
  ;; the only one defined by the standard.
  (if (not (pair? extension-spec))
      (scm-error 'wrong-type-arg "require-extension"
                 "Not an extension: ~S" (list extension-spec) #f))
  (let ((extension (car extension-spec))
        (extension-args (cdr extension-spec)))
    (case extension
      ((srfi)
       (let ((use-list '()))
         (for-each
          (lambda (i)
            (if (not (integer? i))
                (scm-error 'wrong-type-arg "require-extension"
                           "Invalid srfi name: ~S" (list i) #f))
            (let ((srfi-sym (string->symbol
                             (string-append "srfi-" (number->string i)))))
              (if (not (memq srfi-sym %cond-expand-features))
                  (set! use-list (cons `(use-modules (srfi ,srfi-sym))
                                       use-list)))))
          extension-args)
         (if (pair? use-list)
             ;; i.e. (begin (use-modules x) (use-modules y) (use-modules z))
             `(begin ,@(reverse! use-list)))))
      (else
       (scm-error
        'wrong-type-arg "require-extension"
        "Not a recognized extension type: ~S" (list extension) #f)))))



;;; {Load emacs interface support if emacs option is given.}
;;;

(define (named-module-use! user usee)
  (module-use! (resolve-module user) (resolve-interface usee)))

(define (load-emacs-interface)
  (and (provided? 'debug-extensions)
       (debug-enable 'backtrace))
  (named-module-use! '(guile-user) '(ice-9 emacs)))



(define using-readline?
  (let ((using-readline? (make-fluid)))
     (make-procedure-with-setter
      (lambda () (fluid-ref using-readline?))
      (lambda (v) (fluid-set! using-readline? v)))))

(define (top-repl)
  (let ((guile-user-module (resolve-module '(guile-user))))

    ;; Load emacs interface support if emacs option is given.
    (if (and (module-defined? guile-user-module 'use-emacs-interface)
	     (module-ref guile-user-module 'use-emacs-interface))
	(load-emacs-interface))

    ;; Use some convenient modules (in reverse order)

    (set-current-module guile-user-module)
    (process-use-modules 
     (append
      '(((ice-9 r5rs))
	((ice-9 session))
	((ice-9 debug)))
      (if (provided? 'regex)
	  '(((ice-9 regex)))
	  '())
      (if (provided? 'threads)
	  '(((ice-9 threads)))
	  '())))
    ;; load debugger on demand
    (module-use! guile-user-module
		 (make-autoload-interface guile-user-module
					  '(ice-9 debugger) '(debug)))


    ;; Note: SIGFPE, SIGSEGV and SIGBUS are actually "query-only" (see
    ;; scmsigs.c scm_sigaction_for_thread), so the handlers setup here have
    ;; no effect.
    (let ((old-handlers #f)
	  (signals (if (provided? 'posix)
		       `((,SIGINT . "User interrupt")
			 (,SIGFPE . "Arithmetic error")
			 (,SIGSEGV
			  . "Bad memory access (Segmentation violation)"))
		       '())))
      ;; no SIGBUS on mingw
      (if (defined? 'SIGBUS)
	  (set! signals (acons SIGBUS "Bad memory access (bus error)"
			       signals)))

      (dynamic-wind

	  ;; call at entry
	  (lambda ()
	    (let ((make-handler (lambda (msg)
				  (lambda (sig)
				    ;; Make a backup copy of the stack
				    (fluid-set! before-signal-stack
						(fluid-ref the-last-stack))
				    (save-stack 2)
				    (scm-error 'signal
					       #f
					       msg
					       #f
					       (list sig))))))
	      (set! old-handlers
		    (map (lambda (sig-msg)
			   (sigaction (car sig-msg)
				      (make-handler (cdr sig-msg))))
			 signals))))

	  ;; the protected thunk.
	  (lambda ()
	    (let ((status (scm-style-repl)))
	      (run-hook exit-hook)
	      status))

	  ;; call at exit.
	  (lambda ()
	    (map (lambda (sig-msg old-handler)
		   (if (not (car old-handler))
		       ;; restore original C handler.
		       (sigaction (car sig-msg) #f)
		       ;; restore Scheme handler, SIG_IGN or SIG_DFL.
		       (sigaction (car sig-msg)
				  (car old-handler)
				  (cdr old-handler))))
		 signals old-handlers))))))

;;; This hook is run at the very end of an interactive session.
;;;
(define exit-hook (make-hook))



;;; {Deprecated stuff}
;;;

(begin-deprecated
 (define (feature? sym)
   (issue-deprecation-warning
    "`feature?' is deprecated.  Use `provided?' instead.")
   (provided? sym)))

(begin-deprecated
 (primitive-load-path "ice-9/deprecated.scm"))



;;; Place the user in the guile-user module.
;;;

(define-module (guile-user))

;;; boot-9.scm ends here
