;;; srfi-14.scm --- Character-set Library

;; 	Copyright (C) 2001, 2002, 2004, 2006 Free Software Foundation, Inc.
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

;;; Code:

(define-module (srfi srfi-14))

(re-export
;;; General procedures
 char-set?
 char-set=
 char-set<=
 char-set-hash

;;; Iterating over character sets
 char-set-cursor
 char-set-ref
 char-set-cursor-next
 end-of-char-set?
 char-set-fold
 char-set-unfold char-set-unfold!
 char-set-for-each
 char-set-map

;;; Creating character sets
 char-set-copy
 char-set
 list->char-set list->char-set!
 string->char-set string->char-set!
 char-set-filter char-set-filter!
 ucs-range->char-set ucs-range->char-set!
 ->char-set

;;; Querying character sets
 char-set-size
 char-set-count
 char-set->list
 char-set->string
 char-set-contains?
 char-set-every
 char-set-any

;;; Character set algebra
 char-set-adjoin char-set-adjoin!
 char-set-delete char-set-delete!
 char-set-complement
 char-set-union
 char-set-intersection
 char-set-difference
 char-set-xor
 char-set-diff+intersection
 char-set-complement!
 char-set-union!
 char-set-intersection!
 char-set-difference!
 char-set-xor!
 char-set-diff+intersection!

;;; Standard character sets
 char-set:lower-case
 char-set:upper-case
 char-set:title-case
 char-set:letter
 char-set:digit
 char-set:letter+digit
 char-set:graphic
 char-set:printing
 char-set:whitespace
 char-set:iso-control
 char-set:punctuation
 char-set:symbol
 char-set:hex-digit
 char-set:blank
 char-set:ascii
 char-set:empty
 char-set:full)

(cond-expand-provide (current-module) '(srfi-14))

;;; srfi-14.scm ends here
