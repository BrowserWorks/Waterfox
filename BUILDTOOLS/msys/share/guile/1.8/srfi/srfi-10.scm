;;; srfi-10.scm --- Hash-Comma Reader Extension

;; 	Copyright (C) 2001, 2002, 2006 Free Software Foundation, Inc.
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
