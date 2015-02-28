;;; srfi-16.scm --- case-lambda

;; Copyright (C) 2001, 2002 Free Software Foundation, Inc.
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

;;; Author: Martin Grabmueller

;;; Commentary:

;; Implementation of SRFI-16.  `case-lambda' is a syntactic form
;; which permits writing functions acting different according to the
;; number of arguments passed.
;;
;; The syntax of the `case-lambda' form is defined in the following
;; EBNF grammar.
;;
;; <case-lambda>
;;    --> (case-lambda <case-lambda-clause>)
;; <case-lambda-clause>
;;    --> (<signature> <definition-or-command>*)
;; <signature>
;;    --> (<identifier>*)
;;      | (<identifier>* . <identifier>)
;;      | <identifier>
;;
;; The value returned by a `case-lambda' form is a procedure which
;; matches the number of actual arguments against the signatures in
;; the various clauses, in order.  The first matching clause is
;; selected, the corresponding values from the actual parameter list
;; are bound to the variable names in the clauses and the body of the
;; clause is evaluated.

;;; Code:

(define-module (srfi srfi-16)
  :export-syntax (case-lambda))

(cond-expand-provide (current-module) '(srfi-16))

(define-macro (case-lambda . clauses)

  ;; Return the length of the list @var{l}, but allow dotted list.
  ;;
  (define (alength l)
    (cond ((null? l) 0)
	  ((pair? l) (+ 1 (alength (cdr l))))
	  (else 0)))

  ;; Return @code{#t} if @var{l} is a dotted list, @code{#f} if it is
  ;; a normal list.
  ;;
  (define (dotted? l)
    (cond ((null? l) #f)
	  ((pair? l) (dotted? (cdr l)))
	  (else #t)))

  ;; Return the expression for accessing the @var{index}th element of
  ;; the list called @var{args-name}.  If @var{tail?} is true, code
  ;; for accessing the list-tail is generated, otherwise for accessing
  ;; the list element itself.
  ;;
  (define (accessor args-name index tail?)
    (if tail?
	(case index
	  ((0) `,args-name)
	  ((1) `(cdr ,args-name))
	  ((2) `(cddr ,args-name))
	  ((3) `(cdddr ,args-name))
	  ((4) `(cddddr ,args-name))
	  (else `(list-tail ,args-name ,index)))
	(case index
	  ((0) `(car ,args-name))
	  ((1) `(cadr ,args-name))
	  ((2) `(caddr ,args-name))
	  ((3) `(cadddr ,args-name))
	  (else `(list-ref ,args-name ,index)))))

  ;; Generate the binding lists of the variables of one case-lambda
  ;; clause.  @var{vars} is the (possibly dotted) list of variables
  ;; and @var{args-name} is the generated name used for the argument
  ;; list.
  ;;
  (define (gen-temps vars args-name)
    (let lp ((v vars) (i 0))
      (cond ((null? v) '())
	    ((pair? v) 
	     (cons `(,(car v) ,(accessor args-name i #f))
		   (lp (cdr v) (+ i 1))))
	    (else `((,v ,(accessor args-name i #t)))))))

  ;; Generate the cond clauses for each of the clauses of case-lambda,
  ;; including the parameter count check, binding of the parameters
  ;; and the code of the corresponding body.
  ;;
  (define (gen-clauses l length-name args-name)
    (cond ((null? l) (list '(else (error "too few arguments"))))
	  (else
	   (cons
	    `((,(if (dotted? (caar l)) '>= '=)
	       ,length-name ,(alength (caar l)))
	      (let ,(gen-temps (caar l) args-name)
	      ,@(cdar l)))
	    (gen-clauses (cdr l) length-name args-name)))))

  (let ((args-name (gensym))
	(length-name (gensym)))
    (let ((proc
	   `(lambda ,args-name
	      (let ((,length-name (length ,args-name)))
		(cond ,@(gen-clauses clauses length-name args-name))))))
      proc)))

;;; srfi-16.scm ends here
