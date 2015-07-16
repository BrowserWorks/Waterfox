(define-module (lang elisp internals load)
  #:use-module (ice-9 optargs)
  #:use-module (lang elisp internals signal)
  #:use-module (lang elisp internals format)
  #:use-module (lang elisp internals evaluation)
  #:replace (load)
  #:export (load-path))

(define load-path '("/usr/share/emacs/20.7/lisp/"
		    "/usr/share/emacs/20.7/lisp/emacs-lisp/"))

(define* (load file #:optional noerror nomessage nosuffix must-suffix)
  (define (load1 filename)
    (let ((pathname (let loop ((dirs (if (char=? (string-ref filename 0) #\/)
					 '("")
					 load-path)))
		      (cond ((null? dirs) #f)
			    ((file-exists? (in-vicinity (car dirs) filename))
			     (in-vicinity (car dirs) filename))
			    (else (loop (cdr dirs)))))))
      (if pathname
	  (begin
	    (or nomessage
		(message "Loading %s..." pathname))
	    (with-input-from-file pathname
	      (lambda ()
		(let loop ((form (read)))
		  (or (eof-object? form)
		      (begin
			;; Note that `eval' already incorporates use
			;; of the specified module's transformer.
			(eval form the-elisp-module)
			(loop (read)))))))
	    (or nomessage
		(message "Loading %s...done" pathname))
	    #t)
	  #f)))
  (or (and (not nosuffix)
	   (load1 (string-append file ".el")))
      (and (not must-suffix)
	   (load1 file))
      noerror
      (signal 'file-error
	      (list "Cannot open load file" file))))
