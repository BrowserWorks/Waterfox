;;;; 	Copyright (C) 1997, 2000, 2001 Free Software Foundation, Inc.
;;;;
;;;; This program is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation; either version 2, or (at your option)
;;;; any later version.
;;;;
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with this software; see the file COPYING.  If not, write to
;;;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;;;; Boston, MA 02111-1307 USA
;;;;
;;;; As a special exception, the Free Software Foundation gives permission
;;;; for additional uses of the text contained in its release of GUILE.
;;;;
;;;; The exception is that, if you link the GUILE library with other files
;;;; to produce an executable, this does not by itself cause the
;;;; resulting executable to be covered by the GNU General Public License.
;;;; Your use of that executable is in no way restricted on account of
;;;; linking the GUILE library code into it.
;;;;
;;;; This exception does not however invalidate any other reasons why
;;;; the executable file might be covered by the GNU General Public License.
;;;;
;;;; This exception applies only to the code released by the
;;;; Free Software Foundation under the name GUILE.  If you copy
;;;; code from other Free Software Foundation releases into a copy of
;;;; GUILE, as the General Public License permits, the exception does
;;;; not apply to the code that you add in this way.  To avoid misleading
;;;; anyone as to the status of such modified files, you must delete
;;;; this exception notice from them.
;;;;
;;;; If you write modifications of your own for GUILE, it is your choice
;;;; whether to permit this exception to apply to your modifications.
;;;; If you do not wish that, delete this exception notice.
;;;;


(define-module (ice-9 session)
  :use-module (ice-9 documentation)
  :use-module (ice-9 regex)
  :use-module (ice-9 rdelim)
  :export (help apropos apropos-internal apropos-fold
	   apropos-fold-accessible apropos-fold-exported apropos-fold-all
	   source arity system-module))



;;; Documentation
;;;
(define help
  (procedure->syntax
    (lambda (exp env)
      "(help [NAME])
Prints useful information.  Try `(help)'."
      (cond ((not (= (length exp) 2))
             (help-usage))
            ((not (provided? 'regex))
             (display "`help' depends on the `regex' feature.
You don't seem to have regular expressions installed.\n"))
            (else
             (let ((name (cadr exp))
                   (not-found (lambda (type x)
                                (simple-format #t "No ~A found for ~A\n"
                                               type x))))
               (cond

                ;; SYMBOL
                ((symbol? name)
                 (help-doc name
                           (simple-format
                            #f "^~A$"
                            (regexp-quote (symbol->string name)))))

                ;; "STRING"
                ((string? name)
                 (help-doc name name))

                ;; (unquote SYMBOL)
                ((and (list? name)
                      (= (length name) 2)
                      (eq? (car name) 'unquote))
                 (cond ((object-documentation
                         (local-eval (cadr name) env))
                        => write-line)
                       (else (not-found 'documentation (cadr name)))))

                ;; (quote SYMBOL)
                ((and (list? name)
                      (= (length name) 2)
                      (eq? (car name) 'quote)
                      (symbol? (cadr name)))
                 (cond ((search-documentation-files (cadr name))
                        => write-line)
                       (else (not-found 'documentation (cadr name)))))

                ;; (SYM1 SYM2 ...)
                ((and (list? name)
                      (and-map symbol? name)
                      (not (null? name))
                      (not (eq? (car name) 'quote)))
                 (cond ((module-commentary name)
                        => (lambda (doc)
                             (display name) (write-line " commentary:")
                             (write-line doc)))
                       (else (not-found 'commentary name))))

                ;; unrecognized
                (else
                 (help-usage)))
               *unspecified*))))))

(define (module-filename name)          ; fixme: better way? / done elsewhere?
  (let* ((name (map symbol->string name))
         (reverse-name (reverse name))
	 (leaf (car reverse-name))
	 (dir-hint-module-name (reverse (cdr reverse-name)))
	 (dir-hint (apply string-append
                          (map (lambda (elt)
                                 (string-append elt "/"))
                               dir-hint-module-name))))
    (%search-load-path (in-vicinity dir-hint leaf))))

(define (module-commentary name)
  (cond ((module-filename name) => file-commentary)
        (else #f)))

(define (help-doc term regexp)
  (let ((entries (apropos-fold (lambda (module name object data)
				 (cons (list module
					     name
					     (object-documentation object)
					     (cond ((closure? object)
						    "a procedure")
						   ((procedure? object)
						    "a primitive procedure")
						   (else
						    "an object")))
				       data))
			       '()
			       regexp
			       apropos-fold-exported))
	(module car)
	(name cadr)
	(doc caddr)
	(type cadddr))
    (cond ((not (null? entries))
           (let ((first? #t)
                 (undocumented-entries '())
                 (documented-entries '())
                 (documentations '()))

             (for-each (lambda (entry)
                         (let ((entry-summary (simple-format
                                               #f "~S: ~S\n"
                                               (module-name (module entry))
                                               (name entry))))
                           (if (doc entry)
                               (begin
                                 (set! documented-entries
                                       (cons entry-summary documented-entries))
                                 ;; *fixme*: Use `describe' when we have GOOPS?
                                 (set! documentations
                                       (cons (simple-format
                                              #f "`~S' is ~A in the ~S module.\n\n~A\n"
                                              (name entry)
                                              (type entry)
                                              (module-name (module entry))
                                              (doc entry))
                                             documentations)))
                               (set! undocumented-entries
                                     (cons entry-summary
                                           undocumented-entries)))))
                       entries)

             (if (and (not (null? documented-entries))
                      (or (> (length documented-entries) 1)
                          (not (null? undocumented-entries))))
                 (begin
                   (display "Documentation found for:\n")
                   (for-each (lambda (entry) (display entry))
                             documented-entries)
                   (set! first? #f)))

             (for-each (lambda (entry)
                         (if first?
                             (set! first? #f)
                             (newline))
                         (display entry))
                       documentations)

             (if (not (null? undocumented-entries))
                 (begin
                   (if first?
                       (set! first? #f)
                       (newline))
                   (display "No documentation found for:\n")
                   (for-each (lambda (entry) (display entry))
                             undocumented-entries)))))
          ((search-documentation-files term)
           => (lambda (doc)
                (write-line "Documentation from file:")
                (write-line doc)))
          (else
           ;; no matches
           (display "Did not find any object ")
           (simple-format #t
                          (if (symbol? term)
                              "named `~A'\n"
                              "matching regexp \"~A\"\n")
                          term)))))

(define (help-usage)
  (display "Usage: (help NAME) gives documentation about objects named NAME (a symbol)
       (help REGEXP) ditto for objects with names matching REGEXP (a string)
       (help 'NAME) gives documentation for NAME, even if it is not an object
       (help ,EXPR) gives documentation for object returned by EXPR
       (help (my module)) gives module commentary for `(my module)'
       (help) gives this text

`help' searches among bindings exported from loaded modules, while
`apropos' searches among bindings visible from the \"current\" module.

Examples: (help help)
          (help cons)
          (help \"output-string\")

Other useful sources of helpful information:

(apropos STRING)
(arity PROCEDURE)
(name PROCEDURE-OR-MACRO)
(source PROCEDURE-OR-MACRO)

Tools:

(backtrace)				;show backtrace from last error
(debug)					;enter the debugger
(trace [PROCEDURE])			;trace procedure (no arg => show)
(untrace [PROCEDURE])			;untrace (no arg => untrace all)

(OPTIONSET-options 'full)		;display option information
(OPTIONSET-enable 'OPTION)
(OPTIONSET-disable 'OPTION)
(OPTIONSET-set! OPTION VALUE)

where OPTIONSET is one of debug, read, eval, print

"))

;;; {Apropos}
;;;
;;; Author: Roland Orre <orre@nada.kth.se>
;;;

(define (apropos rgx . options)
  "Search for bindings: apropos regexp {options= 'full 'shadow 'value}"
  (if (zero? (string-length rgx))
      "Empty string not allowed"
      (let* ((match (make-regexp rgx))
	     (modules (cons (current-module)
			    (module-uses (current-module))))
	     (separator #\tab)
	     (shadow (member 'shadow options))
	     (value (member 'value options)))
	(cond ((member 'full options)
	       (set! shadow #t)
	       (set! value #t)))
	(for-each
	 (lambda (module)
	   (let* ((name (module-name module))
		  (obarray (module-obarray module)))
	     ;; XXX - should use hash-fold here
	     (array-for-each
	      (lambda (oblist)
		(for-each
		 (lambda (x)
		   (cond ((regexp-exec match (symbol->string (car x)))
			  (display name)
			  (display ": ")
			  (display (car x))
			  (cond ((variable-bound? (cdr x))
				 (let ((val (variable-ref (cdr x))))
				   (cond ((or (procedure? val) value)
					  (display separator)
					  (display val)))))
				(else
				 (display separator)
				 (display "(unbound)")))
			  (if (and shadow
				   (not (eq? (module-ref module
							 (car x))
					     (module-ref (current-module)
							 (car x)))))
			      (display " shadowed"))
			  (newline))))
		 oblist))
	      obarray)))
	 modules))))

(define (apropos-internal rgx)
  "Return a list of accessible variable names."
  (apropos-fold (lambda (module name var data)
		  (cons name data))
		'()
		rgx
		(apropos-fold-accessible (current-module))))

(define (apropos-fold proc init rgx folder)
  "Folds PROCEDURE over bindings matching third arg REGEXP.

Result is

  (PROCEDURE MODULE1 NAME1 VALUE1
    (PROCEDURE MODULE2 NAME2 VALUE2
      ...
      (PROCEDURE MODULEn NAMEn VALUEn INIT)))

where INIT is the second arg to `apropos-fold'.

Fourth arg FOLDER is one of

  (apropos-fold-accessible MODULE) ;fold over bindings accessible in MODULE
  apropos-fold-exported		   ;fold over all exported bindings
  apropos-fold-all		   ;fold over all bindings"
  (let ((match (make-regexp rgx))
	(recorded (make-vector 61 '())))
    (let ((fold-module
	   (lambda (module data)
	     (let* ((obarray-filter
		     (lambda (name val data)
		       (if (and (regexp-exec match (symbol->string name))
				(not (hashq-get-handle recorded name)))
			   (begin
			     (hashq-set! recorded name #t)
			     (proc module name val data))
			   data)))
		    (module-filter
		     (lambda (name var data)
		       (if (variable-bound? var)
			   (obarray-filter name (variable-ref var) data)
			   data))))
	       (cond (module (hash-fold module-filter
					data
					(module-obarray module)))
		     (else data))))))
      (folder fold-module init))))

(define (make-fold-modules init-thunk traverse extract)
  "Return procedure capable of traversing a forest of modules.
The forest traversed is the image of the forest generated by root
modules returned by INIT-THUNK and the generator TRAVERSE.
It is an image under the mapping EXTRACT."
  (lambda (fold-module init)
    (let* ((table (make-hash-table 31))
	   (first? (lambda (obj)
		     (let* ((handle (hash-create-handle! table obj #t))
			    (first? (cdr handle)))
		       (set-cdr! handle #f)
		       first?))))
      (let rec ((data init)
		(modules (init-thunk)))
	(do ((modules modules (cdr modules))
	     (data data (if (first? (car modules))
			    (rec (fold-module (extract (car modules)) data)
				 (traverse (car modules)))
			    data)))
	    ((null? modules) data))))))

(define (apropos-fold-accessible module)
  (make-fold-modules (lambda () (list module))
		     module-uses
		     identity))

(define (root-modules)
  (cons the-root-module
	(submodules (nested-ref the-root-module '(app modules)))))

(define (submodules m)
  (hash-fold (lambda (name var data)
	       (let ((obj (and (variable-bound? var) (variable-ref var))))
		 (if (and (module? obj)
			  (eq? (module-kind obj) 'directory))
		     (cons obj data)
		     data)))
	     '()
	     (module-obarray m)))

(define apropos-fold-exported
  (make-fold-modules root-modules submodules module-public-interface))

(define apropos-fold-all
  (make-fold-modules root-modules submodules identity))

(define (source obj)
  (cond ((procedure? obj) (procedure-source obj))
	((macro? obj) (procedure-source (macro-transformer obj)))
	(else #f)))

(define (arity obj)
  (define (display-arg-list arg-list)
    (display #\`)
    (display (car arg-list))
    (let loop ((ls (cdr arg-list)))
      (cond ((null? ls)
	     (display #\'))
	    ((not (pair? ls))
	     (display "', the rest in `")
	     (display ls)
	     (display #\'))
	    (else
	     (if (pair? (cdr ls))
		 (display "', `")
		 (display "' and `"))
	     (display (car ls))
	     (loop (cdr ls))))))
  (define (display-arg-list/summary arg-list type)
    (let ((len (length arg-list)))
      (display len)
      (display " ")
      (display type)
      (if (> len 1)
	  (display " arguments: ")
	  (display " argument: "))
      (display-arg-list arg-list)))
  (cond
   ((procedure-property obj 'arglist)
    => (lambda (arglist)
	 (let ((required-args (car arglist))
	       (optional-args (cadr arglist))
	       (keyword-args (caddr arglist))
	       (allow-other-keys? (cadddr arglist))
	       (rest-arg (car (cddddr arglist)))
	       (need-punctuation #f))
	   (cond ((not (null? required-args))
		  (display-arg-list/summary required-args "required")
		  (set! need-punctuation #t)))
	   (cond ((not (null? optional-args))
		  (if need-punctuation (display ", "))
		  (display-arg-list/summary optional-args "optional")
		  (set! need-punctuation #t)))
	   (cond ((not (null? keyword-args))
		  (if need-punctuation (display ", "))
		  (display-arg-list/summary keyword-args "keyword")
		  (set! need-punctuation #t)))
	   (cond (allow-other-keys?
		  (if need-punctuation (display ", "))
		  (display "other keywords allowed")
		  (set! need-punctuation #t)))
	   (cond (rest-arg
		  (if need-punctuation (display ", "))
		  (display "the rest in `")
		  (display rest-arg)
		  (display "'"))))))
   (else
    (let ((arity (procedure-property obj 'arity)))
      (display (car arity))
      (cond ((caddr arity)
	     (display " or more"))
	    ((not (zero? (cadr arity)))
	     (display " required and ")
	     (display (cadr arity))
	     (display " optional")))
      (if (and (not (caddr arity))
	       (= (car arity) 1)
	       (<= (cadr arity) 1))
	  (display " argument")
	  (display " arguments"))
      (if (closure? obj)
	  (let ((formals (cadr (procedure-source obj))))
	    (cond
	     ((pair? formals)
	      (display ": ")
	      (display-arg-list formals))
	     (else
	      (display " in `")
	      (display formals)
	      (display #\'))))))))
    (display ".\n"))

(define system-module
  (procedure->syntax
   (lambda (exp env)
     (let* ((m (nested-ref the-root-module
			   (append '(app modules) (cadr exp)))))
       (if (not m)
	   (error "Couldn't find any module named" (cadr exp)))
       (let ((s (not (procedure-property (module-eval-closure m)
					 'system-module))))
	 (set-system-module! m s)
	 (string-append "Module " (symbol->string (module-name m))
			" is now a " (if s "system" "user") " module."))))))

;;; session.scm ends here
