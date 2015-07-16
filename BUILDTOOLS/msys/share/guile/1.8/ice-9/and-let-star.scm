;;;; and-let-star.scm --- and-let* syntactic form (draft SRFI-2) for Guile
;;;; written by Michael Livshin <mike@olan.com>
;;;;
;;;; 	Copyright (C) 1999, 2001, 2004, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 and-let-star)
  :export-syntax (and-let*))

(defmacro and-let* (vars . body)

  (define (expand vars body)
    (cond
     ((null? vars)
      (if (null? body)
	  #t
	  `(begin ,@body)))
     ((pair? vars)
      (let ((exp (car vars)))
        (cond
         ((pair? exp)
          (cond
           ((null? (cdr exp))
            `(and ,(car exp) ,(expand (cdr vars) body)))
           (else
            (let ((var (car exp)))
              `(let (,exp)
                 (and ,var ,(expand (cdr vars) body)))))))
         (else
          `(and ,exp ,(expand (cdr vars) body))))))
     (else
      (error "not a proper list" vars))))

  (expand vars body))

(cond-expand-provide (current-module) '(srfi-2))
