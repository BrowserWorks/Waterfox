;;; srfi-13.scm --- String Library

;; 	Copyright (C) 2001, 2002, 2003, 2004, 2006 Free Software Foundation, Inc.
;;
;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 2.1 of the License, or (at your option) any later version.
;; 
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public
;; License along with this library; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

;;; Commentary:

;; This module is fully documented in the Guile Reference Manual.
;;
;; All procedures are in the core and are simply reexported here.

;;; Code:

(define-module (srfi srfi-13))

(re-export
;;; Predicates
 string?
 string-null?
 string-any
 string-every

;;; Constructors
 make-string
 string
 string-tabulate

;;; List/string conversion
 string->list
 list->string
 reverse-list->string
 string-join

;;; Selection
 string-length
 string-ref
 string-copy
 substring/shared
 string-copy!
 string-take string-take-right
 string-drop string-drop-right
 string-pad string-pad-right
 string-trim string-trim-right
 string-trim-both

;;; Modification
 string-set!
 string-fill!

;;; Comparison
 string-compare
 string-compare-ci
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
 string-index
 string-index-right
 string-skip string-skip-right
 string-count
 string-contains string-contains-ci

;;; Alphabetic case mapping
 string-upcase
 string-upcase!
 string-downcase
 string-downcase!
 string-titlecase
 string-titlecase!

;;; Reverse/Append
 string-reverse
 string-reverse!
 string-append
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
 xsubstring
 string-xcopy!

;;; Miscellaneous
 string-replace
 string-tokenize

;;; Filtering/Deleting
 string-filter
 string-delete)

(cond-expand-provide (current-module) '(srfi-13))

;;; srfi-13.scm ends here
