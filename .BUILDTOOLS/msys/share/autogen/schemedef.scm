
;;;  AutoGen copyright 1992-2002 Bruce Korb

(use-modules (ice-9 common-list))

(define identifier?
  (lambda (x) (or (string? x) (symbol? x))))

(define normalize-identifier
  (lambda (x)
    (if (string? x) (string->symbol x) x)))

(define coerce->string
  (lambda (x)
    (let ((char->string (lambda (x) (make-string 1 x)))
          (coercable? (lambda (x) (or (string? x) (boolean? x)
                                      (char? x) (symbol? x)
                                      (list? x)
                                      (number? x)))))
      (if (not (coercable? x))
          (error "Wrong type to coerce->string" x))
      (cond ((string? x) (string-append (char->string #\") x 
                                        (char->string #\")))
            ; Probably not what was wanted, but fun
            ((boolean? x) (if x "#t" "#f"))
            ((char? x) (char->string x))
            ((number? x) (number->string x))
            ((symbol? x) (symbol->string x))
            ((list? x) (if (every coercable? x)
                           (apply string-append (map coerce->string x))))))))

                                                              

;;; alist->autogen-def:
;;; take a scheme alist of values, and create autogen assignments.
;;; recursive alists are handled. Using a bare list as a value to be assigned
;;; is not a terribly good idea, though it should work if it doesn't look
;;; too much like an alist
;;; The returned string doesn't contain opening and closing brackets.

(define alist->autogen-def 
  (lambda (lst . recursive)
    (if (null? recursive) (set! recursive #f)
        (set! recursive #t))
    (let ((res (if recursive "{\n" ""))
          (list-nnul? (lambda (x) (and (list? x) (not (null? x))))))
      (do ((i lst (cdr i)))
          ((null? i) (if recursive 
                          (string-append res "}") 
                           res))
        (let* ((kvpair (car i))
               (value (cdr kvpair))
               (value-is-alist (if (and (list-nnul? value) 
                                        (list-nnul? (car value))
                                        (list-nnul? (caar value))
                                        (identifier? (caaar value)))
                                   #t #f)))
          (set! res (string-append res 
                                   (coerce->string (normalize-identifier
                                                    (car kvpair)))
                                      " = " 
                                      (if value-is-alist
                                          (alist->autogen-def (car value) 1)
                                          (coerce->string (cdr kvpair)))
                                          ";\n")))))))
;;;
;;; Testing:
;;;
;;; guile> (alist->autogen-def '(
;;;         ( foo "foolish value" )
;;;         ( bar (
;;;                  (mumble "mumbling")
;;;                  (frummitz "stuff" )
;;;         )      )
;;;    )  )
