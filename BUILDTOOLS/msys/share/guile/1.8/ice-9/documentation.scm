;;;; 	Copyright (C) 2000,2001, 2002, 2003, 2006 Free Software Foundation, Inc.
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

;; * This module exports:
;;
;; file-commentary      -- a procedure that returns a file's "commentary"
;;
;; documentation-files  -- a search-list of files using the Guile
;;                         Documentation Format Version 2.
;;
;; search-documentation-files -- a procedure that takes NAME (a symbol)
;;                               and searches `documentation-files' for
;;                               associated documentation.  optional
;;                               arg FILES is a list of filenames to use
;;                               instead of `documentation-files'.
;;
;; object-documentation -- a procedure that returns its arg's docstring
;;
;; * Guile Documentation Format
;;
;; Here is the complete and authoritative documentation for the Guile
;; Documentation Format Version 2:
;;
;; HEADER
;; ^LPROC1
;; DOCUMENTATION1
;;
;; ^LPROC2
;; DOCUMENTATION2
;;
;; ^L...
;;
;; The HEADER is completely ignored.  The "^L" are formfeeds.  PROC1, PROC2
;; and so on are symbols that name the element documented.  DOCUMENTATION1,
;; DOCUMENTATION2 and so on are the related documentation, w/o any further
;; formatting.  Note that there are two newlines before the next formfeed;
;; these are discarded when the documentation is read in.
;;
;; (Version 1, corresponding to guile-1.4 and prior, is documented as being
;; not documented anywhere except by this embarrassingly circular comment.)
;;
;; * File Commentary
;;
;; A file's commentary is the body of text found between comments
;;     ;;; Commentary:
;; and
;;     ;;; Code:
;; both of which must be at the beginning of the line.  In the result string,
;; semicolons at the beginning of each line are discarded.
;;
;; You can specify to `file-commentary' alternate begin and end strings, and
;; scrub procedure.  Use #t to get default values.  For example:
;;
;; (file-commentary "documentation.scm")
;; You should see this text!
;;
;; (file-commentary "documentation.scm" "^;;; Code:" "ends here$")
;; You should see the rest of this file.
;;
;; (file-commentary "documentation.scm" #t #t string-upcase)
;; You should see this text very loudly (note semicolons untouched).

;;; Code:

(define-module (ice-9 documentation)
  :use-module (ice-9 rdelim)
  :export (file-commentary
           documentation-files search-documentation-files
           object-documentation)
  :autoload (ice-9 regex) (match:suffix)
  :no-backtrace)


;;
;; commentary extraction
;;

(define (file-commentary filename . cust) ; (IN-LINE-RE AFTER-LINE-RE SCRUB)
   
  ;; These are constants but are not at the top level because the repl in
  ;; boot-9.scm loads session.scm which in turn loads this file, and we want
  ;; that to work even even when regexps are not available (ie. make-regexp
  ;; doesn't exist), as for instance is the case on mingw.
  ;;
  (define default-in-line-re (make-regexp "^;;; Commentary:"))
  (define default-after-line-re (make-regexp "^;;; Code:"))
  (define default-scrub (let ((dirt (make-regexp "^;+")))
			  (lambda (line)
			    (let ((m (regexp-exec dirt line)))
			      (if m (match:suffix m) line)))))
       
  ;; fixme: might be cleaner to use optargs here...
  (let ((in-line-re (if (> 1 (length cust))
                        default-in-line-re
                        (let ((v (car cust)))
                          (cond ((regexp? v) v)
                                ((string? v) (make-regexp v))
                                (else default-in-line-re)))))
        (after-line-re (if (> 2 (length cust))
                           default-after-line-re
                           (let ((v (cadr cust)))
                             (cond ((regexp? v) v)
                                   ((string? v) (make-regexp v))
                                   (else default-after-line-re)))))
        (scrub (if (> 3 (length cust))
                   default-scrub
                   (let ((v (caddr cust)))
                     (cond ((procedure? v) v)
                           (else default-scrub))))))
    (call-with-input-file filename
      (lambda (port)
	(let loop ((line (read-delimited "\n" port))
		   (doc "")
		   (parse-state 'before))
	  (if (or (eof-object? line) (eq? 'after parse-state))
	      doc
	      (let ((new-state
		     (cond ((regexp-exec in-line-re line) 'in)
			   ((regexp-exec after-line-re line) 'after)
			   (else parse-state))))
		(if (eq? 'after new-state)
		    doc
		    (loop (read-delimited "\n" port)
			  (if (and (eq? 'in new-state) (eq? 'in parse-state))
			      (string-append doc (scrub line) "\n")
			      doc)
			  new-state)))))))))



;;
;; documentation-files is the list of places to look for documentation
;;
(define documentation-files
  (map (lambda (vicinity)
	 (in-vicinity (vicinity) "guile-procedures.txt"))
       (list %library-dir
	     %package-data-dir
	     %site-dir
	     (lambda () "."))))

(define entry-delimiter "\f")

(define (find-documentation-in-file name file)
  (and (file-exists? file)
       (call-with-input-file file
	 (lambda (port)
	   (let ((name (symbol->string name)))
	     (let ((len (string-length name)))
	       (read-delimited entry-delimiter port) ;skip to first entry
	       (let loop ((entry (read-delimited entry-delimiter port)))
		 (cond ((eof-object? entry) #f)
		       ;; match?
		       ((and ;; large enough?
		         (>= (string-length entry) len)
			 ;; matching name?
			 (string=? (substring entry 0 len) name)
			 ;; terminated?
			 (memq (string-ref entry len) '(#\newline)))
			;; cut away name tag and extra surrounding newlines
			(substring entry (+ len 2) (- (string-length entry) 2)))
		       (else (loop (read-delimited entry-delimiter port)))))))))))

(define (search-documentation-files name . files)
  (or-map (lambda (file)
	    (find-documentation-in-file name file))
          (cond ((null? files) documentation-files)
                (else files))))

;; helper until the procedure documentation property is cleaned up
(define (proc-doc proc)
  (or (procedure-documentation proc)
      (procedure-property proc 'documentation)))

(define (object-documentation object)
  "Return the docstring for OBJECT.
OBJECT can be a procedure, macro or any object that has its
`documentation' property set."
  (or (and (procedure? object)
	   (proc-doc object))
      (and (defmacro? object)
	   (proc-doc (defmacro-transformer object)))
      (and (macro? object)
	   (let ((transformer (macro-transformer object)))
	     (and transformer
		  (proc-doc transformer))))
      (object-property object 'documentation)
      (and (procedure? object)
	   (not (closure? object))
	   (procedure-name object)
	   (let ((docstring (search-documentation-files
                             (procedure-name object))))
	     (if docstring
		 (set-procedure-property! object 'documentation docstring))
	     docstring))))

;;; documentation.scm ends here
