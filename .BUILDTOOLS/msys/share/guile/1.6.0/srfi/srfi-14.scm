;;; srfi-14.scm --- Character-set Library

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

(define-module (srfi srfi-14)
  :export (
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
 char-set:full
 ))

(cond-expand-provide (current-module) '(srfi-14))

(load-extension "libguile-srfi-srfi-13-14-v-1" "scm_init_srfi_14")

(define (->char-set x)
  (cond
   ((string? x)   (string->char-set x))
   ((char? x)     (char-set x))
   ((char-set? x) x)
   (else (error "invalid argument to `->char-set'"))))

(define char-set:full (ucs-range->char-set 0 256))

(define char-set:lower-case (char-set-filter char-lower-case? char-set:full))

(define char-set:upper-case (char-set-filter char-upper-case? char-set:full))

(define char-set:title-case (char-set))

(define char-set:letter (char-set-union char-set:lower-case
					char-set:upper-case))

(define char-set:digit (string->char-set "0123456789"))

(define char-set:letter+digit
  (char-set-union char-set:letter char-set:digit))

(define char-set:punctuation (string->char-set "!\"#%&'()*,-./:;?@[\\]_{}"))

(define char-set:symbol (string->char-set "$+<=>^`|~"))

(define char-set:whitespace (char-set #\space #\newline #\tab #\cr #\vt #\np))

(define char-set:blank (char-set #\space #\tab))

(define char-set:graphic
  (char-set-union char-set:letter+digit char-set:punctuation char-set:symbol))

(define char-set:printing
  (char-set-union char-set:graphic char-set:whitespace))

(define char-set:iso-control
  (char-set-adjoin
   (char-set-filter (lambda (ch) (< (char->integer ch) 31)) char-set:full)
   (integer->char 127)))

(define char-set:hex-digit (string->char-set "0123456789abcdefABCDEF"))

(define char-set:ascii
  (char-set-filter (lambda (ch) (< (char->integer ch) 128)) char-set:full))

(define char-set:empty (char-set))

;;; srfi-14.scm ends here
