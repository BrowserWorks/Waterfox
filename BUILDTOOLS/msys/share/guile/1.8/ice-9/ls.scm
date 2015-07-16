;;;; ls.scm --- functions for browsing modules
;;;;
;;;; 	Copyright (C) 1995, 1996, 1997, 1999, 2001, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 ls)
  :use-module (ice-9 common-list)
  :export (local-definitions-in definitions-in ls lls
	   recursive-local-define))

;;;;
;;;	local-definitions-in root name
;;;		Returns a list of names defined locally in the named
;;;		subdirectory of root.
;;;	definitions-in root name
;;;		Returns a list of all names defined in the named
;;;		subdirectory of root.  The list includes alll locally
;;;		defined names as well as all names inherited from a
;;;		member of a use-list.
;;;
;;; A convenient interface for examining the nature of things:
;;;
;;;	ls . various-names
;;;
;;;		With no arguments, return a list of definitions in
;;;		`(current-module)'.
;;;
;;;		With just one argument, interpret that argument as the
;;;		name of a subdirectory of the current module and
;;;		return a list of names defined there.
;;;
;;;		With more than one argument, still compute
;;;		subdirectory lists, but return a list:
;;;			((<subdir-name> . <names-defined-there>)
;;;			 (<subdir-name> . <names-defined-there>)
;;;			 ...)
;;;
;;;     lls . various-names
;;;
;;;		Analogous to `ls', but with local definitions only.

(define (local-definitions-in root names)
  (let ((m (nested-ref root names))
	(answer '()))
    (if (not (module? m))
	(set! answer m)
	(module-for-each (lambda (k v) (set! answer (cons k answer))) m))
    answer))

(define (definitions-in root names)
  (let ((m (nested-ref root names)))
    (if (not (module? m))
	m
	(reduce union
		(cons (local-definitions-in m  '())
		      (map (lambda (m2) (definitions-in m2 '()))
			   (module-uses m)))))))

(define (ls . various-refs)
  (if (pair? various-refs)
       (if (cdr various-refs)
	   (map (lambda (ref)
		  (cons ref (definitions-in (current-module) ref)))
		various-refs)
	  (definitions-in (current-module) (car various-refs)))
      (definitions-in (current-module) '())))

(define (lls . various-refs)
  (if (pair? various-refs)
       (if (cdr various-refs)
	   (map (lambda (ref)
		  (cons ref (local-definitions-in (current-module) ref)))
		various-refs)
	  (local-definitions-in (current-module) (car various-refs)))
      (local-definitions-in (current-module) '())))

(define (recursive-local-define name value)
  (let ((parent (reverse! (cdr (reverse name)))))
    (and parent (make-modules-in (current-module) parent))
    (local-define name value)))

;;; ls.scm ends here
