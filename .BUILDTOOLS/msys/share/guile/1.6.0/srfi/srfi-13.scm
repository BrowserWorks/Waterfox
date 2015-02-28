;;; srfi-13.scm --- String Library

;; 	Copyright (C) 2001, 2002 Free Software Foundation, Inc.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this software; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;; Boston, MA 02111-1307 USA
;;
;; As a special exception, the Free Software Foundation gives permission
;; for additional uses of the text contained in its release of GUILE.
;;
;; The exception is that, if you link the GUILE library with other files
;; to produce an executable, this does not by itself cause the
;; resulting executable to be covered by the GNU General Public License.
;; Your use of that executable is in no way restricted on account of
;; linking the GUILE library code into it.
;;
;; This exception does not however invalidate any other reasons why
;; the executable file might be covered by the GNU General Public License.
;;
;; This exception applies only to the code released by the
;; Free Software Foundation under the name GUILE.  If you copy
;; code from other Free Software Foundation releases into a copy of
;; GUILE, as the General Public License permits, the exception does
;; not apply to the code that you add in this way.  To avoid misleading
;; anyone as to the status of such modified files, you must delete
;; this exception notice from them.
;;
;; If you write modifications of your own for GUILE, it is your choice
;; whether to permit this exception to apply to your modifications.
;; If you do not wish that, delete this exception notice.

;;; Commentary:

;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-13))

(begin-deprecated
 ;; Prevent `export' from re-exporting core bindings.  This behaviour
 ;; of `export' is deprecated and will disappear in one of the next
 ;; releases.
 (define string->list #f)
 (define string-copy #f)
 (define string-fill! #f)
 (define string-index #f)
 (define string-upcase #f)
 (define string-upcase! #f)
 (define string-downcase #f)
 (define string-downcase! #f))

(export
;;; Predicates
 ;; string? string-null?       <= in the core
 string-any string-every

;;; Constructors
 ;; make-string string         <= in the core
 string-tabulate

;;; List/string conversion
 string->list
 ;; list->string               <= in the core
 reverse-list->string
 string-join

;;; Selection
 ;; string-length string-ref   <= in the core
 string-copy
 substring/shared
 string-copy!
 string-take string-take-right
 string-drop string-drop-right
 string-pad string-pad-right
 string-trim string-trim-right
 string-trim-both

;;; Modification
 ;; string-set!                <= in the core
 string-fill!

;;; Comparison
 string-compare string-compare-ci
 string= string<>
 string< string>
 string<= string>=
 string-ci= string-ci<>
 string-ci< string-ci>
 string-ci<= string-ci>=
 string-hash string-hash-ci

;;; Prefixes/Suffixes
 string-prefix-length
 string-prefix-length-ci
 string-suffix-length
 string-suffix-length-ci
 string-prefix?
 string-prefix-ci?
 string-suffix?
 string-suffix-ci?

;;; Searching
 string-index string-index-right
 string-skip string-skip-right
 string-count
 string-contains string-contains-ci

;;; Alphabetic case mapping

 string-upcase string-upcase!
 string-downcase string-downcase!
 string-titlecase string-titlecase!

;;; Reverse/Append
 string-reverse string-reverse!
 ;; string-append                    <= in the core
 string-append/shared
 string-concatenate
 string-concatenate-reverse
 string-concatenate/shared
 string-concatenate-reverse/shared

;;; Fold/Unfold/Map
 string-map string-map!
 string-fold
 string-fold-right
 string-unfold
 string-unfold-right
 string-for-each
 string-for-each-index

;;; Replicate/Rotate
 xsubstring string-xcopy!

;;; Miscellaneous
 string-replace
 string-tokenize

;;; Filtering/Deleting
 string-filter
 string-delete
 )

(cond-expand-provide (current-module) '(srfi-13))

(load-extension "libguile-srfi-srfi-13-14-v-1" "scm_init_srfi_13")

(define string-hash
  (lambda (s . rest)
    (let ((bound (if (pair? rest)
		     (or (car rest)
			 871)
		     871))
	  (start (if (and (pair? rest) (pair? (cdr rest)))
		     (cadr rest)
		     0))
	  (end (if (and (pair? rest) (pair? (cdr rest)) (pair? (cddr rest)))
		   (caddr rest)
		   (string-length s))))
      (hash (substring/shared s start end) bound))))

(define string-hash-ci
  (lambda (s . rest)
    (let ((bound (if (pair? rest)
		     (or (car rest)
			 871)
		     871))
	  (start (if (and (pair? rest) (pair? (cdr rest)))
		     (cadr rest)
		     0))
	  (end (if (and (pair? rest) (pair? (cdr rest)) (pair? (cddr rest)))
		   (caddr rest)
		   (string-length s))))
      (hash (string-upcase (substring/shared s start end)) bound))))

;;; srfi-13.scm ends here
