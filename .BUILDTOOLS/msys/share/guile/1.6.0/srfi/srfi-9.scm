;;; srfi-9.scm --- define-record-type

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

;; This module exports the syntactic form `define-record-type', which
;; is the means for creating record types defined in SRFI-9.
;;
;; The syntax of a record type definition is:
;;
;;  <record type definition>
;;    -> (define-record-type <type name>
;;         (<constructor name> <field tag> ...)
;;         <predicate name>
;;         <field spec> ...)
;;
;;  <field spec> -> (<field tag> <accessor name>)
;;               -> (<field tag> <accessor name> <modifier name>)
;;
;;  <field tag> -> <identifier>
;;  <... name>  -> <identifier>
;;
;; Usage example:
;;
;; guile> (use-modules (srfi srfi-9))
;; guile> (define-record-type :foo (make-foo x) foo?
;;                            (x get-x) (y get-y set-y!))
;; guile> (define f (make-foo 1))
;; guile> f
;; #<:foo x: 1 y: #f>
;; guile> (get-x f)
;; 1
;; guile> (set-y! f 2)
;; 2
;; guile> (get-y f)
;; 2
;; guile> f
;; #<:foo x: 1 y: 2>
;; guile> (foo? f)
;; #t
;; guile> (foo? 1)
;; #f

;;; Code:

(define-module (srfi srfi-9)
  :export-syntax (define-record-type))

(cond-expand-provide (current-module) '(srfi-9))

(define-macro (define-record-type type-name constructor/field-tag
		predicate-name . field-specs)
  `(begin
     (define ,type-name
       (make-record-type ',type-name ',(map car field-specs)))
     (define ,(car constructor/field-tag)
       (record-constructor ,type-name ',(cdr constructor/field-tag)))
     (define ,predicate-name
       (record-predicate ,type-name))
     ,@(map
	(lambda (spec)
	  (cond
	   ((= (length spec) 2)
	    `(define ,(cadr spec)
	       (record-accessor ,type-name ',(car spec))))
	   ((= (length spec) 3)
	    `(begin
	       (define ,(cadr spec)
		 (record-accessor ,type-name ',(car spec)))
	       (define ,(caddr spec)
		 (record-modifier ,type-name ',(car spec)))))
	   (else
	    (error "invalid field spec " spec))))
	field-specs)))

;;; srfi-9.scm ends here
