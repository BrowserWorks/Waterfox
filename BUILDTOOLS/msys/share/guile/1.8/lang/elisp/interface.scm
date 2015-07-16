(define-module (lang elisp interface)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals fset)
  #:use-module ((lang elisp internals load) #:select ((load . elisp:load)))
  #:use-module ((lang elisp transform) #:select (transformer))
  #:export (eval-elisp
	    translate-elisp
	    elisp-function
	    elisp-variable
	    load-elisp-file
	    load-elisp-library
	    use-elisp-file
	    use-elisp-library
	    export-to-elisp
	    load-emacs))

;;; This file holds my ideas for the mechanisms that would be useful
;;; to exchange definitions between Scheme and Elisp.

(define (eval-elisp x)
  "Evaluate the Elisp expression @var{x}."
  (eval x the-elisp-module))

(define (translate-elisp x)
  "Translate the Elisp expression @var{x} to equivalent Scheme code."
  (transformer x))

(define (elisp-function sym)
  "Return the procedure or macro that implements @var{sym} in Elisp.
If @var{sym} has no Elisp function definition, return @code{#f}."
  (fref sym))

(define (elisp-variable sym)
  "Return the variable that implements @var{sym} in Elisp.
If @var{sym} has no Elisp variable definition, return @code{#f}."
  (module-variable the-elisp-module sym))

(define (load-elisp-file file-name)
  "Load @var{file-name} into the Elisp environment.
@var{file-name} is assumed to name a file containing Elisp code."
  ;; This is the same as Elisp's `load-file', so use that if it is
  ;; available, otherwise duplicate the definition of `load-file' from
  ;; files.el.
  (let ((load-file (elisp-function 'load-file)))
    (if load-file
	(load-file file-name)
	(elisp:load file-name #f #f #t))))

(define (load-elisp-library library)
  "Load library @var{library} into the Elisp environment.
@var{library} should name an Elisp code library that can be found in
one of the directories of @code{load-path}."
  ;; This is the same as Elisp's `load-file', so use that if it is
  ;; available, otherwise duplicate the definition of `load-file' from
  ;; files.el.
  (let ((load-library (elisp-function 'load-library)))
    (if load-library
	(load-library library)
	(elisp:load library))))

(define export-module-name
  (let ((counter 0))
    (lambda ()
      (set! counter (+ counter 1))
      (list 'lang 'elisp
	    (string->symbol (string-append "imports:"
					   (number->string counter)))))))

(define-macro (use-elisp-file file-name . imports)
  "Load Elisp code file @var{file-name} and import its definitions
into the current Scheme module.  If any @var{imports} are specified,
they are interpreted as selection and renaming specifiers as per
@code{use-modules}."
  (let ((export-module-name (export-module-name)))
    `(begin
       (fluid-set! ,elisp-export-module (resolve-module ',export-module-name))
       (beautify-user-module! (resolve-module ',export-module-name))
       (load-elisp-file ,file-name)
       (use-modules (,export-module-name ,@imports))
       (fluid-set! ,elisp-export-module #f))))

(define-macro (use-elisp-library library . imports)
  "Load Elisp library @var{library} and import its definitions into
the current Scheme module.  If any @var{imports} are specified, they
are interpreted as selection and renaming specifiers as per
@code{use-modules}."
  (let ((export-module-name (export-module-name)))
    `(begin
       (fluid-set! ,elisp-export-module (resolve-module ',export-module-name))
       (beautify-user-module! (resolve-module ',export-module-name))
       (load-elisp-library ,library)
       (use-modules (,export-module-name ,@imports))
       (fluid-set! ,elisp-export-module #f))))

(define (export-to-elisp . defs)
  "Export procedures and variables specified by @var{defs} to Elisp.
Each @var{def} is either an object, in which case that object must be
a named procedure or macro and is exported to Elisp under its Scheme
name; or a symbol, in which case the variable named by that symbol is
exported under its Scheme name; or a pair @var{(obj . name)}, in which
case @var{obj} must be a procedure, macro or symbol as already
described and @var{name} specifies the name under which that object is
exported to Elisp."
  (for-each (lambda (def)
	      (let ((obj (if (pair? def) (car def) def))
		    (name (if (pair? def) (cdr def) #f)))
		(cond ((procedure? obj)
		       (or name
			   (set! name (procedure-name obj)))
		       (if name
			   (fset name obj)
			   (error "No procedure name specified or deducible:" obj)))
		      ((macro? obj)
		       (or name
			   (set! name (macro-name obj)))
		       (if name
			   (fset name obj)
			   (error "No macro name specified or deducible:" obj)))
		      ((symbol? obj)
		       (or name
			   (set! name obj))
		       (module-add! the-elisp-module name
				    (module-ref (current-module) obj)))
		      (else
		       (error "Can't export this kind of object to Elisp:" obj)))))
	    defs))

(define load-emacs (elisp-function 'load-emacs))
