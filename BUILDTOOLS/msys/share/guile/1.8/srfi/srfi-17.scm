;;; srfi-17.scm --- Generalized set!

;; Copyright (C) 2001, 2002, 2003, 2006 Free Software Foundation, Inc.
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
  :export (getter-with-setter)
  :replace (;; redefined standard procedures
	    setter
	    car cdr caar cadr cdar cddr caaar caadr cadar caddr cdaar
	    cdadr cddar cdddr caaaar caaadr caadar caaddr cadaar cadadr
	    caddar cadddr cdaaar cdaadr cdadar cdaddr cddaar cddadr
	    cdddar cddddr string-ref vector-ref))

(cond-expand-provide (current-module) '(srfi-17))

;;; Procedures

(define getter-with-setter make-procedure-with-setter)

(define setter
  (getter-with-setter
   (@ (guile) setter)
   (lambda args
     (error "Setting setters is not supported for a good reason."))))

;;; Redefine R5RS procedures to appropriate procedures with setters

(define (compose-setter setter location)
  (lambda (obj value)
    (setter (location obj) value)))

(define car
  (getter-with-setter (@ (guile) car)
                      set-car!))
(define cdr
  (getter-with-setter (@ (guile) cdr)
                      set-cdr!))

(define caar
  (getter-with-setter (@ (guile) caar)
                      (compose-setter set-car! (@ (guile) car))))
(define cadr
  (getter-with-setter (@ (guile) cadr)
                      (compose-setter set-car! (@ (guile) cdr))))
(define cdar
  (getter-with-setter (@ (guile) cdar)
                      (compose-setter set-cdr! (@ (guile) car))))
(define cddr
  (getter-with-setter (@ (guile) cddr)
                      (compose-setter set-cdr! (@ (guile) cdr))))

(define caaar
  (getter-with-setter (@ (guile) caaar)
                      (compose-setter set-car! (@ (guile) caar))))
(define caadr
  (getter-with-setter (@ (guile) caadr)
                      (compose-setter set-car! (@ (guile) cadr))))
(define cadar
  (getter-with-setter (@ (guile) cadar)
                      (compose-setter set-car! (@ (guile) cdar))))
(define caddr
  (getter-with-setter (@ (guile) caddr)
                      (compose-setter set-car! (@ (guile) cddr))))
(define cdaar
  (getter-with-setter (@ (guile) cdaar)
                      (compose-setter set-cdr! (@ (guile) caar))))
(define cdadr
  (getter-with-setter (@ (guile) cdadr)
                      (compose-setter set-cdr! (@ (guile) cadr))))
(define cddar
  (getter-with-setter (@ (guile) cddar)
                      (compose-setter set-cdr! (@ (guile) cdar))))
(define cdddr
  (getter-with-setter (@ (guile) cdddr)
                      (compose-setter set-cdr! (@ (guile) cddr))))

(define caaaar
  (getter-with-setter (@ (guile) caaaar)
                      (compose-setter set-car! (@ (guile) caaar))))
(define caaadr
  (getter-with-setter (@ (guile) caaadr)
                      (compose-setter set-car! (@ (guile) caadr))))
(define caadar
  (getter-with-setter (@ (guile) caadar)
                      (compose-setter set-car! (@ (guile) cadar))))
(define caaddr
  (getter-with-setter (@ (guile) caaddr)
                      (compose-setter set-car! (@ (guile) caddr))))
(define cadaar
  (getter-with-setter (@ (guile) cadaar)
                      (compose-setter set-car! (@ (guile) cdaar))))
(define cadadr
  (getter-with-setter (@ (guile) cadadr)
                      (compose-setter set-car! (@ (guile) cdadr))))
(define caddar
  (getter-with-setter (@ (guile) caddar)
                      (compose-setter set-car! (@ (guile) cddar))))
(define cadddr
  (getter-with-setter (@ (guile) cadddr)
                      (compose-setter set-car! (@ (guile) cdddr))))
(define cdaaar
  (getter-with-setter (@ (guile) cdaaar)
                      (compose-setter set-cdr! (@ (guile) caaar))))
(define cdaadr
  (getter-with-setter (@ (guile) cdaadr)
                      (compose-setter set-cdr! (@ (guile) caadr))))
(define cdadar
  (getter-with-setter (@ (guile) cdadar)
                      (compose-setter set-cdr! (@ (guile) cadar))))
(define cdaddr
  (getter-with-setter (@ (guile) cdaddr)
                      (compose-setter set-cdr! (@ (guile) caddr))))
(define cddaar
  (getter-with-setter (@ (guile) cddaar)
                      (compose-setter set-cdr! (@ (guile) cdaar))))
(define cddadr
  (getter-with-setter (@ (guile) cddadr)
                      (compose-setter set-cdr! (@ (guile) cdadr))))
(define cdddar
  (getter-with-setter (@ (guile) cdddar)
                      (compose-setter set-cdr! (@ (guile) cddar))))
(define cddddr
  (getter-with-setter (@ (guile) cddddr)
                      (compose-setter set-cdr! (@ (guile) cdddr))))

(define string-ref
  (getter-with-setter (@ (guile) string-ref)
                      string-set!))

(define vector-ref
  (getter-with-setter (@ (guile) vector-ref)
                      vector-set!))

;;; srfi-17.scm ends here
