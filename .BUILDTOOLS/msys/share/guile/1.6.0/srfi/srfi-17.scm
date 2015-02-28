;;; srfi-17.scm --- Generalized set!

;; Copyright (C) 2001, 2002 Free Software Foundation, Inc.
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

;;; Author: Matthias Koeppe <mkoeppe@mail.math.uni-magdeburg.de>

;;; Commentary:

;; This is an implementation of SRFI-17: Generalized set!
;;
;; It exports the Guile procedure `make-procedure-with-setter' under
;; the SRFI name `getter-with-setter' and exports the standard
;; procedures `car', `cdr', ..., `cdddr', `string-ref' and
;; `vector-ref' as procedures with setters, as required by the SRFI.
;;
;; SRFI-17 was heavily criticized during its discussion period but it
;; was finalized anyway.  One issue was its concept of globally
;; associating setter "properties" with (procedure) values, which is
;; non-Schemy.  For this reason, this implementation chooses not to
;; provide a way to set the setter of a procedure.  In fact, (set!
;; (setter PROC) SETTER) signals an error.  The only way to attach a
;; setter to a procedure is to create a new object (a "procedure with
;; setter") via the `getter-with-setter' procedure. This procedure is
;; also specified in the SRFI.  Using it avoids the described
;; problems.
;;
;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-17)
  :export (getter-with-setter
	   setter
	   ;; redefined standard procedures
	   car cdr caar cadr cdar cddr caaar caadr cadar caddr cdaar
	   cdadr cddar cdddr caaaar caaadr caadar caaddr cadaar cadadr
	   caddar cadddr cdaaar cdaadr cdadar cdaddr cddaar cddadr
	   cdddar cddddr string-ref vector-ref))

(cond-expand-provide (current-module) '(srfi-17))

;;; Procedures

(define getter-with-setter make-procedure-with-setter)

(define setter
  (getter-with-setter
   setter
   (lambda args
     (error "Setting setters is not supported for a good reason."))))

;;; Redefine R5RS procedures to appropriate procedures with setters

(define (compose-setter setter location)
  (lambda (obj value)
    (setter (location obj) value)))

(define car (getter-with-setter car set-car!))
(define cdr (getter-with-setter cdr set-cdr!))
(define caar (getter-with-setter caar (compose-setter set-car! car)))
(define cadr (getter-with-setter cadr (compose-setter set-car! cdr)))
(define cdar (getter-with-setter cdar (compose-setter set-cdr! car)))
(define cddr (getter-with-setter cddr (compose-setter set-cdr! cdr)))
(define caaar (getter-with-setter caaar (compose-setter set-car! caar)))
(define caadr (getter-with-setter caadr (compose-setter set-car! cadr)))
(define cadar (getter-with-setter cadar (compose-setter set-car! cdar)))
(define caddr (getter-with-setter caddr (compose-setter set-car! cddr)))
(define cdaar (getter-with-setter cdaar (compose-setter set-cdr! caar)))
(define cdadr (getter-with-setter cdadr (compose-setter set-cdr! cadr)))
(define cddar (getter-with-setter cddar (compose-setter set-cdr! cdar)))
(define cdddr (getter-with-setter cdddr (compose-setter set-cdr! cddr)))
(define caaaar (getter-with-setter caaaar (compose-setter set-car! caaar)))
(define caaadr (getter-with-setter caaadr (compose-setter set-car! caadr)))
(define caadar (getter-with-setter caadar (compose-setter set-car! cadar)))
(define caaddr (getter-with-setter caaddr (compose-setter set-car! caddr)))
(define cadaar (getter-with-setter cadaar (compose-setter set-car! cdaar)))
(define cadadr (getter-with-setter cadadr (compose-setter set-car! cdadr)))
(define caddar (getter-with-setter caddar (compose-setter set-car! cddar)))
(define cadddr (getter-with-setter cadddr (compose-setter set-car! cdddr)))
(define cdaaar (getter-with-setter cdaaar (compose-setter set-cdr! caaar)))
(define cdaadr (getter-with-setter cdaadr (compose-setter set-cdr! caadr)))
(define cdadar (getter-with-setter cdadar (compose-setter set-cdr! cadar)))
(define cdaddr (getter-with-setter cdaddr (compose-setter set-cdr! caddr)))
(define cddaar (getter-with-setter cddaar (compose-setter set-cdr! cdaar)))
(define cddadr (getter-with-setter cddadr (compose-setter set-cdr! cdadr)))
(define cdddar (getter-with-setter cdddar (compose-setter set-cdr! cddar)))
(define cddddr (getter-with-setter cddddr (compose-setter set-cdr! cdddr)))
(define string-ref (getter-with-setter string-ref string-set!))
(define vector-ref (getter-with-setter vector-ref vector-set!))

;;; srfi-17.scm ends here
