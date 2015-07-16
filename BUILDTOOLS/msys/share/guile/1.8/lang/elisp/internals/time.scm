(define-module (lang elisp internals time)
  #:use-module (ice-9 optargs)
  #:export (format-time-string))

(define* (format-time-string format-string #:optional time universal)
  (strftime format-string
	    ((if universal gmtime localtime)
	     (if time
		 (+ (ash (car time) 16)
		    (let ((time-cdr (cdr time)))
		      (if (pair? time-cdr)
			  (car time-cdr)
			  time-cdr)))
		 (current-time)))))
