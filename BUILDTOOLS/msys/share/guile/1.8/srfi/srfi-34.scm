;;; srfi-34.scm --- Exception handling for programs

;; Copyright (C) 2003, 2006, 2008 Free Software Foundation, Inc.
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

;;; Author: Neil Jerram <neil@ossau.uklinux.net>

;;; Commentary:

;; This is an implementation of SRFI-34: Exception Handling for
;; Programs.  For documentation please see the SRFI-34 document; this
;; module is not yet documented at all in the Guile manual.

;;; Code:

(define-module (srfi srfi-34)
  #:export (with-exception-handler
	    raise)
  #:export-syntax (guard))

(cond-expand-provide (current-module) '(srfi-34))

(define throw-key 'srfi-34)

(define (with-exception-handler handler thunk)
  "Returns the result(s) of invoking THUNK. HANDLER must be a
procedure that accepts one argument.  It is installed as the current
exception handler for the dynamic extent (as determined by
dynamic-wind) of the invocation of THUNK."
  (with-throw-handler throw-key
	      thunk
	      (lambda (key obj)
		(handler obj))))

(define (raise obj)
  "Invokes the current exception handler on OBJ.  The handler is
called in the dynamic environment of the call to raise, except that
the current exception handler is that in place for the call to
with-exception-handler that installed the handler being called.  The
handler's continuation is otherwise unspecified."
  (throw throw-key obj))

(define-macro (guard var+clauses . body)
  "Syntax: (guard (<var> <clause1> <clause2> ...) <body>)
Each <clause> should have the same form as a `cond' clause.

Semantics: Evaluating a guard form evaluates <body> with an exception
handler that binds the raised object to <var> and within the scope of
that binding evaluates the clauses as if they were the clauses of a
cond expression.  That implicit cond expression is evaluated with the
continuation and dynamic environment of the guard expression.  If
every <clause>'s <test> evaluates to false and there is no else
clause, then raise is re-invoked on the raised object within the
dynamic environment of the original call to raise except that the
current exception handler is that of the guard expression."
  (let ((var (car var+clauses))
	(clauses (cdr var+clauses)))
    `(catch ',throw-key
	    (lambda ()
	      ,@body)
	    (lambda (key ,var)
	      (cond ,@(if (eq? (caar (last-pair clauses)) 'else)
			  clauses
			  (append clauses
				  `((else (throw key ,var))))))))))

;;; (srfi srfi-34) ends here.
