;;;; 	Copyright (C) 2000, 2001, 2006 Free Software Foundation, Inc.
;;;; 
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;; 
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;; 

;;;; Safe subset of R5RS bindings

(define-module (ice-9 safe)
  :export (safe-environment make-safe-module))

(define safe-r5rs-interface (resolve-interface '(ice-9 safe-r5rs)))

(define (safe-environment n)
  (if (not (= n 5))
      (scm-error 'misc-error 'safe-environment
		 "~A is not a valid version"
		 (list n)
		 '()))
  safe-r5rs-interface)

(define (make-safe-module)
  (make-module 1021 (list safe-r5rs-interface)))
