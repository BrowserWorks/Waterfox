;;;; string-fun.scm --- string manipulation functions
;;;;
;;;; 	Copyright (C) 1995, 1996, 1997, 1999, 2001, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 string-fun)
  :export (split-after-char split-before-char split-discarding-char
	   split-after-char-last split-before-char-last
	   split-discarding-char-last split-before-predicate
	   split-after-predicate split-discarding-predicate
	   separate-fields-discarding-char separate-fields-after-char
	   separate-fields-before-char string-prefix-predicate string-prefix=?
	   sans-surrounding-whitespace sans-trailing-whitespace
	   sans-leading-whitespace sans-final-newline has-trailing-newline?))

;;;;
;;;
;;; Various string funcitons, particularly those that take
;;; advantage of the "shared substring" capability.
;;;

;;; {String Fun: Dividing Strings Into Fields}
;;; 
;;; The names of these functions are very regular.
;;; Here is a grammar of a call to one of these:
;;;
;;;   <string-function-invocation>
;;;   := (<action>-<seperator-disposition>-<seperator-determination> <seperator-param> <str> <ret>)
;;;
;;; <str>    = the string
;;;
;;; <ret>    = The continuation.  String functions generally return
;;;	       multiple values by passing them to this procedure.
;;;
;;; <action> =    split
;;;		| separate-fields
;;;
;;;		"split" means to divide a string into two parts.
;;;			<ret> will be called with two arguments.
;;;
;;;		"separate-fields" means to divide a string into as many
;;;			parts as possible.  <ret> will be called with
;;;			however many fields are found.
;;;
;;; <seperator-disposition> = 	  before
;;;				| after
;;;				| discarding
;;;
;;;		"before" means to leave the seperator attached to
;;;			the beginning of the field to its right.
;;;		"after" means to leave the seperator attached to
;;;			the end of the field to its left.
;;;		"discarding" means to discard seperators.
;;;
;;;		Other dispositions might be handy.  For example, "isolate"
;;;		could mean to treat the separator as a field unto itself.
;;;
;;; <seperator-determination> =	  char
;;;				| predicate
;;;
;;;		"char" means to use a particular character as field seperator.
;;;		"predicate" means to check each character using a particular predicate.
;;;		
;;;		Other determinations might be handy.  For example, "character-set-member".
;;;
;;; <seperator-param> = A parameter that completes the meaning of the determinations.
;;;			For example, if the determination is "char", then this parameter
;;;			says which character.  If it is "predicate", the parameter is the
;;;			predicate.
;;;
;;;
;;; For example:
;;;
;;;		(separate-fields-discarding-char #\, "foo, bar, baz, , bat" list)
;;;		=> ("foo" " bar" " baz" " " " bat")
;;;
;;;		(split-after-char #\- 'an-example-of-split list)
;;;		=> ("an-" "example-of-split")
;;;
;;; As an alternative to using a determination "predicate", or to trying to do anything
;;; complicated with these functions, consider using regular expressions.
;;;

(define (split-after-char char str ret)
  (let ((end (cond
	      ((string-index str char) => 1+)
	      (else (string-length str)))))
    (ret (substring str 0 end)
	 (substring str end))))

(define (split-before-char char str ret)
  (let ((end (or (string-index str char)
		 (string-length str))))
    (ret (substring str 0 end)
	 (substring str end))))

(define (split-discarding-char char str ret)
  (let ((end (string-index str char)))
    (if (not end)
	(ret str "")
	(ret (substring str 0 end)
	     (substring str (1+ end))))))

(define (split-after-char-last char str ret)
  (let ((end (cond
	      ((string-rindex str char) => 1+)
	      (else 0))))
    (ret (substring str 0 end)
	 (substring str end))))

(define (split-before-char-last char str ret)
  (let ((end (or (string-rindex str char) 0)))
    (ret (substring str 0 end)
	 (substring str end))))

(define (split-discarding-char-last char str ret)
  (let ((end (string-rindex str char)))
    (if (not end)
	(ret str "")
	(ret (substring str 0 end)
	     (substring str (1+ end))))))

(define (split-before-predicate pred str ret)
  (let loop ((n 0))
    (cond
     ((= n (string-length str))		(ret str ""))
     ((not (pred (string-ref str n)))	(loop (1+ n)))
     (else				(ret (substring str 0 n)
					     (substring str n))))))
(define (split-after-predicate pred str ret)
  (let loop ((n 0))
    (cond
     ((= n (string-length str))		(ret str ""))
     ((not (pred (string-ref str n)))	(loop (1+ n)))
     (else				(ret (substring str 0 (1+ n))
					     (substring str (1+ n)))))))

(define (split-discarding-predicate pred str ret)
  (let loop ((n 0))
    (cond
     ((= n (string-length str))		(ret str ""))
     ((not (pred (string-ref str n)))	(loop (1+ n)))
     (else				(ret (substring str 0 n)
					     (substring str (1+ n)))))))

(define (separate-fields-discarding-char ch str ret)
  (let loop ((fields '())
	     (str str))
    (cond
     ((string-rindex str ch)
      => (lambda (w) (loop (cons (substring str (+ 1 w)) fields)
			   (substring str 0 w))))
     (else (apply ret str fields)))))

(define (separate-fields-after-char ch str ret)
  (reverse
   (let loop ((fields '())
             (str str))
     (cond
      ((string-index str ch)
       => (lambda (w) (loop (cons (substring str 0 (+ 1 w)) fields)
                           (substring str (+ 1 w)))))
      (else (apply ret str fields))))))

(define (separate-fields-before-char ch str ret)
  (let loop ((fields '())
	     (str str))
    (cond
     ((string-rindex str ch)
      => (lambda (w) (loop (cons (substring str w) fields)
			     (substring str 0 w))))
     (else (apply ret str fields)))))


;;; {String Fun: String Prefix Predicates}
;;;
;;; Very simple:
;;;
;;; (define-public ((string-prefix-predicate pred?) prefix str)
;;;  (and (<= (string-length prefix) (string-length str))
;;;	  (pred? prefix (substring str 0 (string-length prefix)))))
;;;
;;; (define-public string-prefix=? (string-prefix-predicate string=?))
;;;

(define ((string-prefix-predicate pred?) prefix str)
  (and (<= (string-length prefix) (string-length str))
       (pred? prefix (substring str 0 (string-length prefix)))))

(define string-prefix=? (string-prefix-predicate string=?))


;;; {String Fun: Strippers}
;;;
;;; <stripper> = sans-<removable-part>
;;;
;;; <removable-part> = 	  surrounding-whitespace
;;;			| trailing-whitespace
;;;			| leading-whitespace
;;;			| final-newline
;;;

(define (sans-surrounding-whitespace s)
  (let ((st 0)
	(end (string-length s)))
    (while (and (< st (string-length s))
		(char-whitespace? (string-ref s st)))
	   (set! st (1+ st)))
    (while (and (< 0 end)
		(char-whitespace? (string-ref s (1- end))))
	   (set! end (1- end)))
    (if (< end st)
	""
	(substring s st end))))

(define (sans-trailing-whitespace s)
  (let ((st 0)
	(end (string-length s)))
    (while (and (< 0 end)
		(char-whitespace? (string-ref s (1- end))))
	   (set! end (1- end)))
    (if (< end st)
	""
	(substring s st end))))

(define (sans-leading-whitespace s)
  (let ((st 0)
	(end (string-length s)))
    (while (and (< st (string-length s))
		(char-whitespace? (string-ref s st)))
	   (set! st (1+ st)))
    (if (< end st)
	""
	(substring s st end))))

(define (sans-final-newline str)
  (cond
   ((= 0 (string-length str))
    str)

   ((char=? #\nl (string-ref str (1- (string-length str))))
    (substring str 0 (1- (string-length str))))

   (else str)))

;;; {String Fun: has-trailing-newline?}
;;;

(define (has-trailing-newline? str)
  (and (< 0 (string-length str))
       (char=? #\nl (string-ref str (1- (string-length str))))))



;;; {String Fun: with-regexp-parts}

;;; This relies on the older, hairier regexp interface, which we don't
;;; particularly want to implement, and it's not used anywhere, so
;;; we're just going to drop it for now.
;;; (define-public (with-regexp-parts regexp fields str return fail)
;;;   (let ((parts (regexec regexp str fields)))
;;;     (if (number? parts)
;;;         (fail parts)
;;;         (apply return parts))))

