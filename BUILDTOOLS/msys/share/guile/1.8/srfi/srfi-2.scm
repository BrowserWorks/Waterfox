;;; srfi-2.scm --- and-let*

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

;; This module is fully documented in the Guile Reference Manual.

;;; Code:

(define-module (srfi srfi-2)
  :use-module (ice-9 and-let-star)
  :re-export-syntax (and-let*))

(cond-expand-provide (current-module) '(srfi-2))

;;; srfi-2.scm ends here
