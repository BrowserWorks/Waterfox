;;; srfi-26.scm --- specializing parameters without currying.

;; Copyright (C) 2002, 2006 Free Software Foundation, Inc.
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

(define-module (srfi srfi-26)
  :export (cut cute))

(cond-expand-provide (current-module) '(srfi-26))

(define-macro (cut slot . slots)
  (let loop ((slots	(cons slot slots))
	     (params	'())
	     (args	'()))
    (if (null? slots)
	`(lambda ,(reverse! params) ,(reverse! args))
      (let ((s	  (car slots))
	    (rest (cdr slots)))
	(case s
	  ((<>)
	   (let ((var (gensym)))
	     (loop rest (cons var params) (cons var args))))
	  ((<...>)
	   (if (pair? rest)
	       (error "<...> not on the end of cut expression"))
	   (let ((var (gensym)))
	     `(lambda ,(append! (reverse! params) var)
		(apply ,@(reverse! (cons var args))))))
	  (else
	   (loop rest params (cons s args))))))))

(define-macro (cute . slots)
  (let ((temp (map (lambda (s) (and (not (memq s '(<> <...>))) (gensym)))
		   slots)))
    `(let ,(delq! #f (map (lambda (t s) (and t (list t s))) temp slots))
       (cut ,@(map (lambda (t s) (or t s)) temp slots)))))
