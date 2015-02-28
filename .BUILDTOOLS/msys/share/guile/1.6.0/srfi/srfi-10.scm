;;; srfi-10.scm --- Hash-Comma Reader Extension

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

;; This module implements the syntax extension #,(), also called
;; hash-comma, which is defined in SRFI-10.
;;
;; The support for SRFI-10 consists of the procedure
;; `define-reader-ctor' for defining new reader constructors and the
;; read syntax form
;;
;; #,(<ctor> <datum> ...)
;;
;; where <ctor> must be a symbol for which a read constructor was
;; defined previously.
;;
;; Example:
;;
;; (define-reader-ctor 'file open-input-file)
;; (define f '#,(file "/etc/passwd"))
;; (read-line f)
;; =>
;; "root:x:0:0:root:/root:/bin/bash"
;;
;; Please note the quote before the #,(file ...) expression.  This is
;; necessary because ports are not self-evaluating in Guile.
;;
;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-10)
  :use-module (ice-9 rdelim)
  :export (define-reader-ctor))

(cond-expand-provide (current-module) '(srfi-10))

;; This hash table stores the association between comma-hash tags and
;; the corresponding constructor procedures.
;;
(define reader-ctors (make-hash-table 31))

;; This procedure installs the procedure @var{proc} as the constructor
;; for the comma-hash tag @var{symbol}.
;;
(define (define-reader-ctor symbol proc)
  (hashq-set! reader-ctors symbol proc)
  (if #f #f))				; Return unspecified value.

;; Retrieve the constructor procedure for the tag @var{symbol} or
;; throw an error if no such tag is defined.
;;
(define (lookup symbol)
  (let ((p (hashq-ref reader-ctors symbol #f)))
    (if (procedure? p)
	p
	(error "unknown hash-comma tag " symbol))))

;; This is the actual reader extension.
;;
(define (hash-comma char port)
  (let* ((obj (read port)))
    (if (and (list? obj) (positive? (length obj)) (symbol? (car obj)))
	(let ((p (lookup (car obj))))
	  (let ((res (apply p (cdr obj))))
	    res))
	(error "syntax error in hash-comma expression"))))

;; Install the hash extension.
;;
(read-hash-extend #\, hash-comma)

;;; srfi-10.scm ends here
