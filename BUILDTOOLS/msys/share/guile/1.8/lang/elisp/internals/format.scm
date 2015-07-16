(define-module (lang elisp internals format)
  #:pure
  #:use-module (ice-9 r5rs)
  #:use-module ((ice-9 format) #:select ((format . scheme:format)))
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals signal)
  #:replace (format)
  #:export (message))

(define (format control-string . args)

  (define (cons-string str ls)
    (let loop ((sl (string->list str))
	       (ls ls))
      (if (null? sl)
	  ls
	  (loop (cdr sl) (cons (car sl) ls)))))

  (let loop ((input (string->list control-string))
	     (args args)
	     (output '())
	     (mid-control #f))
    (if (null? input)
	(if mid-control
	    (error "Format string ends in middle of format specifier")
	    (list->string (reverse output)))
	(if mid-control
	    (case (car input)
	      ((#\%)
	       (loop (cdr input)
		     args
		     (cons #\% output)
		     #f))
	      (else
	       (loop (cdr input)
		     (cdr args)
		     (cons-string (case (car input)
				    ((#\s) (scheme:format #f "~A" (car args)))
				    ((#\d) (number->string (car args)))
				    ((#\o) (number->string (car args) 8))
				    ((#\x) (number->string (car args) 16))
				    ((#\e) (number->string (car args))) ;FIXME
				    ((#\f) (number->string (car args))) ;FIXME
				    ((#\g) (number->string (car args))) ;FIXME
				    ((#\c) (let ((a (car args)))
					     (if (char? a)
						 (string a)
						 (string (integer->char a)))))
				    ((#\S) (scheme:format #f "~S" (car args)))
				    (else
				     (error "Invalid format operation %%%c" (car input))))
				  output)
		     #f)))
	    (case (car input)
	      ((#\%)
	       (loop (cdr input) args output #t))
	      (else
	       (loop (cdr input) args (cons (car input) output) #f)))))))

(define (message control-string . args)
  (display (apply format control-string args))
  (newline))
