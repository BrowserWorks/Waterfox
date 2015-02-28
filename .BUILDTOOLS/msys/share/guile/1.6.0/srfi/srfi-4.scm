;;; srfi-4.scm --- Homogeneous Numeric Vector Datatypes

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

;;; Author: Martin Grabmueller <mgrabmue@cs.tu-berlin.de>

;;; Commentary:

;; This module implements homogeneous numeric vectors as defined in SRFI-4.
;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-4)
  :export (
;;; Unsigned 8-bit vectors.
 u8vector? make-u8vector u8vector u8vector-length u8vector-ref
 u8vector-set! u8vector->list list->u8vector

;;; Signed 8-bit vectors.
 s8vector? make-s8vector s8vector s8vector-length s8vector-ref
 s8vector-set! s8vector->list list->s8vector

;;; Unsigned 16-bit vectors.
 u16vector? make-u16vector u16vector u16vector-length u16vector-ref
 u16vector-set! u16vector->list list->u16vector

;;; Signed 16-bit vectors.
 s16vector? make-s16vector s16vector s16vector-length s16vector-ref
 s16vector-set! s16vector->list list->s16vector

;;; Unsigned 32-bit vectors.
 u32vector? make-u32vector u32vector u32vector-length u32vector-ref
 u32vector-set! u32vector->list list->u32vector

;;; Signed 32-bit vectors.
 s32vector? make-s32vector s32vector s32vector-length s32vector-ref
 s32vector-set! s32vector->list list->s32vector

;;; Unsigned 64-bit vectors.
 u64vector? make-u64vector u64vector u64vector-length u64vector-ref
 u64vector-set! u64vector->list list->u64vector

;;; Signed 64-bit vectors.
 s64vector? make-s64vector s64vector s64vector-length s64vector-ref
 s64vector-set! s64vector->list list->s64vector

;;; 32-bit floating point vectors.
 f32vector? make-f32vector f32vector f32vector-length f32vector-ref
 f32vector-set! f32vector->list list->f32vector

;;; 64-bit floating point vectors.
 f64vector? make-f64vector f64vector f64vector-length f64vector-ref
 f64vector-set! f64vector->list list->f64vector
 ))


;; Make 'srfi-4 available as a feature identifiere to `cond-expand'.
;;
(cond-expand-provide (current-module) '(srfi-4))


;; Load the compiled primitives from the shared library.
;;
(load-extension "libguile-srfi-srfi-4-v-1" "scm_init_srfi_4")


;; Reader extension for #f32() and #f64() vectors.
;;
(define (hash-f char port)
  (if (or (char=? (peek-char port) #\3)
	  (char=? (peek-char port) #\6))
    (let* ((obj (read port)))
      (if (number? obj)
	(cond ((= obj 32)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->f32vector l)
		   (error "syntax error in #f32() vector literal"))))
	      ((= obj 64)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->f64vector l)
		   (error "syntax error in #f64() vector literal"))))
	      (else
	       (error "syntax error in #f...() vector literal")))
	(error "syntax error in #f...() vector literal")))
    #f))


;; Reader extension for #u8(), #u16(), #u32() and #u64() vectors.
;;
(define (hash-u char port)
  (if (or (char=? (peek-char port) #\8)
	  (char=? (peek-char port) #\1)
	  (char=? (peek-char port) #\3)
	  (char=? (peek-char port) #\6))
    (let ((obj (read port)))
      (cond ((= obj 8)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->u8vector l)
		   (error "syntax error in #u8() vector literal"))))
	    ((= obj 16)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->u16vector l)
		   (error "syntax error in #u16() vector literal"))))
	    ((= obj 32)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->u32vector l)
		   (error "syntax error in #u32() vector literal"))))
	    ((= obj 64)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->u64vector l)
		   (error "syntax error in #u64() vector literal"))))
	    (else
	     (error "syntax error in #u...() vector literal"))))
    (error "syntax error in #u...() vector literal")))


;; Reader extension for #s8(), #s16(), #s32() and #s64() vectors.
;;
(define (hash-s char port)
  (if (or (char=? (peek-char port) #\8)
	  (char=? (peek-char port) #\1)
	  (char=? (peek-char port) #\3)
	  (char=? (peek-char port) #\6))
    (let ((obj (read port)))
      (cond ((= obj 8)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->s8vector l)
		   (error "syntax error in #s8() vector literal"))))
	    ((= obj 16)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->s16vector l)
		   (error "syntax error in #s16() vector literal"))))
	    ((= obj 32)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->s32vector l)
		   (error "syntax error in #s32() vector literal"))))
	    ((= obj 64)
	       (let ((l (read port)))
		 (if (list? l)
		   (list->s64vector l)
		   (error "syntax error in #s64() vector literal"))))
	    (else
	     (error "syntax error in #s...() vector literal"))))
    (error "syntax error in #s...() vector literal")))


;; Install the hash extensions.
;;
(read-hash-extend #\f hash-f)
(read-hash-extend #\u hash-u)
(read-hash-extend #\s hash-s)

;;; srfi-4.scm ends here
