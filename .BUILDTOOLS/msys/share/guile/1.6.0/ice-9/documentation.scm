;;;; 	Copyright (C) 2000,2001 Free Software Foundation, Inc.
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
(define default-in-line-re (make-regexp "^;;; Commentary:"))
(define default-after-line-re (make-regexp "^;;; Code:"))
(define default-scrub (let ((dirt (make-regexp "^;+")))
                        (lambda (line)
                          (let ((m (regexp-exec dirt line)))
                            (if m (match:suffix m) line)))))

(define (file-commentary filename . cust) ; (IN-LINE-RE AFTER-LINE-RE SCRUB)
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
                           (else default-scrub)))))
        (port (open-input-file filename)))
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
                      new-state)))))))



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
       (let ((port (open-input-file file))
	     (name (symbol->string name)))
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
		   (else (loop (read-delimited entry-delimiter port)))))))))

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
