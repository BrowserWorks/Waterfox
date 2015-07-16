(define-module (lang elisp primitives lists)
  #:use-module (lang elisp internals fset)
  #:use-module (lang elisp internals null)
  #:use-module (lang elisp internals signal))

(fset 'cons cons)

(fset 'null null)

(fset 'not null)

(fset 'car
      (lambda (l)
	(if (null l)
	    %nil
	    (car l))))

(fset 'cdr
      (lambda (l)
	(if (null l)
	    %nil
	    (cdr l))))

(fset 'eq
      (lambda (x y)
	(or (eq? x y)
	    (and (null x) (null y)))))

(fset 'equal
      (lambda (x y)
	(or (equal? x y)
	    (and (null x) (null y)))))

(fset 'setcar set-car!)

(fset 'setcdr set-cdr!)

(for-each (lambda (sym proc)
	    (fset sym
		  (lambda (elt list)
		    (if (null list)
			%nil
			(if (null elt)
			    (let loop ((l list))
			      (cond ((null l) %nil)
				    ((null (car l)) l)
				    (else (loop (cdr l)))))
			    (proc elt list))))))
	  '( memq  member  assq  assoc)
	  `(,memq ,member ,assq ,assoc))

(fset 'length
      (lambda (x)
	(cond ((null x) 0)
	      ((pair? x) (length x))
	      ((vector? x) (vector-length x))
	      ((string? x) (string-length x))
	      (else (wta 'sequencep x 1)))))

(fset 'copy-sequence
      (lambda (x)
	(cond ((list? x) (list-copy x))
	      ((vector? x) (error "Vector copy not yet implemented"))
	      ((string? x) (string-copy x))
	      (else (wta 'sequencep x 1)))))

(fset 'elt
      (lambda (obj i)
	(cond ((pair? obj) (list-ref obj i))
	      ((vector? obj) (vector-ref obj i))
	      ((string? obj) (char->integer (string-ref obj i))))))

(fset 'list list)

(fset 'mapcar
      (lambda (function sequence)
	(map (lambda (elt)
	       (elisp-apply function (list elt)))
	     (cond ((null sequence) '())
		   ((list? sequence) sequence)
		   ((vector? sequence) (vector->list sequence))
		   ((string? sequence) (map char->integer (string->list sequence)))
		   (else (wta 'sequencep sequence 2))))))

(fset 'nth
      (lambda (n list)
	(if (or (null list)
		(>= n (length list)))
	    %nil
	    (list-ref list n))))

(fset 'listp
      (lambda (object)
	(or (null object)
	    (list? object))))

(fset 'consp pair?)

(fset 'nconc
      (lambda args
	(apply append! (map (lambda (arg)
			      (if arg arg '()))
			    args))))
