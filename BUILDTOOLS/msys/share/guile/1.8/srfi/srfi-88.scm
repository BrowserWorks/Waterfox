;;; srfi-88.scm --- Keyword Objects

;; Copyright (C) 2008 Free Software Foundation, Inc.
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

;;; Author: Ludovic Courtès <ludo@gnu.org>

;;; Commentary:

;; This is a convenience module providing SRFI-88 "keyword object".  All it
;; does is setup the right reader option and export keyword-related
;; convenience procedures.

;;; Code:

(define-module (srfi srfi-88)
  #:re-export (keyword?)
  #:export (keyword->string string->keyword))

(cond-expand-provide (current-module) '(srfi-88))


(read-set! keywords 'postfix)

(define (keyword->string k)
  "Return the name of @var{k} as a string."
  (symbol->string (keyword->symbol k)))

(define (string->keyword s)
  "Return the keyword object whose name is @var{s}."
  (symbol->keyword (string->symbol s)))

;;; Local Variables:
;;; coding: latin-1
;;; End:

;;; srfi-88.scm ends here
