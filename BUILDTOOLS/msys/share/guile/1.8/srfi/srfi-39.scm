;;; srfi-39.scm --- Parameter objects

;; 	Copyright (C) 2004, 2005, 2006, 2008 Free Software Foundation, Inc.
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

;;; Author: Jose Antonio Ortega Ruiz <jao@gnu.org>
;;; Date: 2004-05-05

;;; Commentary:

;; This is an implementation of SRFI-39 (Parameter objects).
;;
;; The implementation is based on Guile's fluid objects, and is, therefore,
;; thread-safe (parameters are thread-local).
;;
;; In addition to the forms defined in SRFI-39 (`make-parameter',
;; `parameterize'), a new procedure `with-parameters*' is provided.
;; This procedures is analogous to `with-fluids*' but taking as first
;; argument a list of parameter objects instead of a list of fluids.
;;

;;; Code:

(define-module (srfi srfi-39)
  #:use-module (ice-9 syncase)
  #:use-module (srfi srfi-16)

  #:export (make-parameter)
  #:export-syntax (parameterize)

  ;; helper procedure not in srfi-39.
  #:export (with-parameters*)
  #:replace (current-input-port current-output-port current-error-port))

;; Make 'srfi-39 available as a feature identifiere to `cond-expand'.
;;
(cond-expand-provide (current-module) '(srfi-39))

(define make-parameter
  (case-lambda
    ((val) (make-parameter/helper val (lambda (x) x)))
    ((val conv) (make-parameter/helper val conv))))

(define get-fluid-tag (lambda () 'get-fluid)) ;; arbitrary unique (as per eq?) value
(define get-conv-tag (lambda () 'get-conv)) ;; arbitrary unique (as per eq?) value

(define (make-parameter/helper val conv)
  (let ((value (make-fluid))
        (conv conv))
    (begin
      (fluid-set! value (conv val))
      (lambda new-value
        (cond
         ((null? new-value) (fluid-ref value))
         ((eq? (car new-value) get-fluid-tag) value)
         ((eq? (car new-value) get-conv-tag) conv)
         ((null? (cdr new-value)) (fluid-set! value (conv (car new-value))))
         (else (error "make-parameter expects 0 or 1 arguments" new-value)))))))

(define-syntax parameterize
  (syntax-rules ()
    ((_ ((?param ?value) ...) ?body ...)
     (with-parameters* (list ?param ...)
                       (list ?value ...)
                       (lambda () ?body ...)))))

(define (current-input-port . new-value)
  (if (null? new-value)
      ((@ (guile) current-input-port))
      (apply set-current-input-port new-value)))

(define (current-output-port . new-value)
  (if (null? new-value)
      ((@ (guile) current-output-port))
      (apply set-current-output-port new-value)))

(define (current-error-port . new-value)
  (if (null? new-value)
      ((@ (guile) current-error-port))
      (apply set-current-error-port new-value)))

(define port-list
  (list current-input-port current-output-port current-error-port))

;; There are no fluids behind current-input-port etc, so those parameter
;; objects are picked out of the list and handled separately with a
;; dynamic-wind to swap their values to and from a location (the "value"
;; variable in the swapper procedure "let").
;;
;; current-input-port etc are already per-dynamic-root, so this arrangement
;; works the same as a fluid.  Perhaps they could become fluids for ease of
;; implementation here.
;;
;; Notice the use of a param local variable for the swapper procedure.  It
;; ensures any application changes to the PARAMS list won't affect the
;; winding.
;;
(define (with-parameters* params values thunk)
  (let more ((params params)
	     (values values)
	     (fluids '())     ;; fluids from each of PARAMS
	     (convs  '())     ;; VALUES with conversion proc applied
	     (swapper noop))  ;; wind/unwind procedure for ports handling
    (if (null? params)
	(if (eq? noop swapper)
	    (with-fluids* fluids convs thunk)
	    (dynamic-wind
		swapper
		(lambda ()
		  (with-fluids* fluids convs thunk))
		swapper))
	(if (memq (car params) port-list)
	    (more (cdr params) (cdr values)
		  fluids convs
		  (let ((param (car params))
			(value (car values))
			(prev-swapper swapper))
		    (lambda ()
		      (set! value (param value))
		      (prev-swapper))))
	    (more (cdr params) (cdr values)
		  (cons ((car params) get-fluid-tag) fluids)
		  (cons (((car params) get-conv-tag) (car values)) convs)
		  swapper)))))
