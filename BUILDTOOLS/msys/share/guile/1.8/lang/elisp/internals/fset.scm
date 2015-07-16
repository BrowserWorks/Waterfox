(define-module (lang elisp internals fset)
  #:use-module (lang elisp internals evaluation)
  #:use-module (lang elisp internals lambda)
  #:use-module (lang elisp internals signal)
  #:export (fset
	    fref
	    fref/error-if-void
	    elisp-apply
	    interactive-specification
	    not-subr?
	    elisp-export-module))

(define the-variables-module (resolve-module '(lang elisp variables)))

;; By default, Guile GC's unreachable symbols.  So we need to make
;; sure they stay reachable!
(define syms '())

;; elisp-export-module, if non-#f, holds a module to which definitions
;; should be exported under their normal symbol names.  This is used
;; when importing Elisp definitions into Scheme.
(define elisp-export-module (make-fluid))

;; Store the procedure, macro or alias symbol PROC in SYM's function
;; slot.
(define (fset sym proc)
  (or (memq sym syms)
      (set! syms (cons sym syms)))
  (let ((vcell (symbol-fref sym))
	(vsym #f)
	(export-module (fluid-ref elisp-export-module)))
    ;; Playing around with variables and name properties...  For the
    ;; reasoning behind this, see the commentary in (lang elisp
    ;; variables).
    (cond ((procedure? proc)
	   ;; A procedure created from Elisp will already have a name
	   ;; property attached, with value of the form
	   ;; <elisp-defun:NAME> or <elisp-lambda>.  Any other
	   ;; procedure coming through here must be an Elisp primitive
	   ;; definition, so we give it a name of the form
	   ;; <elisp-subr:NAME>.
	   (or (procedure-name proc)
	       (set-procedure-property! proc
					'name
					(symbol-append '<elisp-subr: sym '>)))
	   (set! vsym (procedure-name proc)))
	  ((macro? proc)
	   ;; Macros coming through here must be defmacros, as all
	   ;; primitive special forms are handled directly by the
	   ;; transformer.
	   (set-procedure-property! (macro-transformer proc)
				    'name
				    (symbol-append '<elisp-defmacro: sym '>))
	   (set! vsym (procedure-name (macro-transformer proc))))
	  (else
	   ;; An alias symbol.
	   (set! vsym (symbol-append '<elisp-defalias: sym '>))))
    ;; This is the important bit!
    (if (variable? vcell)
	(variable-set! vcell proc)
	(begin
	  (set! vcell (make-variable proc))
	  (symbol-fset! sym vcell)
	  ;; Playing with names and variables again - see above.
	  (module-add! the-variables-module vsym vcell)
	  (module-export! the-variables-module (list vsym))))
    ;; Export variable to the export module, if non-#f.
    (if (and export-module
	     (or (procedure? proc)
		 (macro? proc)))
	(begin
	  (module-add! export-module sym vcell)
	  (module-export! export-module (list sym))))))

;; Retrieve the procedure or macro stored in SYM's function slot.
;; Note the asymmetry w.r.t. fset: if fref finds an alias symbol, it
;; recursively calls fref on that symbol.  Returns #f if SYM's
;; function slot doesn't contain a valid definition.
(define (fref sym)
  (let ((var (symbol-fref sym)))
    (if (and var (variable? var))
	(let ((proc (variable-ref var)))
	  (cond ((symbol? proc)
		 (fref proc))
		(else
		 proc)))
	#f)))

;; Same as fref, but signals an Elisp error if SYM's function
;; definition is void.
(define (fref/error-if-void sym)
  (or (fref sym)
      (signal 'void-function (list sym))))

;; Maps a procedure to its (interactive ...) spec.
(define interactive-specification (make-object-property))

;; Maps a procedure to #t if it is NOT a built-in.
(define not-subr? (make-object-property))

(define (elisp-apply function . args)
  (apply apply
	 (cond ((symbol? function)
		(fref/error-if-void function))
	       ((procedure? function)
		function)
	       ((and (pair? function)
		     (eq? (car function) 'lambda))
		(eval (transform-lambda/interactive function '<elisp-lambda>)
		      the-root-module))
	       (else
		(signal 'invalid-function (list function))))
	 args))
