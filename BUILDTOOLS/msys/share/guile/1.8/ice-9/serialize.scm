;;;; 	Copyright (C) 2003, 2006 Free Software Foundation, Inc.
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

;;; Commentary:

;; (serialize FORM1 ...) and (parallelize FORM1 ...) are useful when
;; you don't trust the thread safety of most of your program, but
;; where you have some section(s) of code which you consider can run
;; in parallel to other sections.
;;
;; They "flag" (with dynamic extent) sections of code to be of
;; "serial" or "parallel" nature and have the single effect of
;; preventing a serial section from being run in parallel with any
;; serial section (including itself).
;;
;; Both serialize and parallelize can be nested.  If so, the
;; inner-most construct is in effect.
;;
;; NOTE 1: A serial section can run in parallel with a parallel
;; section.
;;
;; NOTE 2: If a serial section S is "interrupted" by a parallel
;; section P in the following manner: S = S1 P S2, S2 is not
;; guaranteed to be resumed by the same thread that previously
;; executed S1.
;;
;; WARNING: Spawning new threads within a serial section have
;; undefined effects.  It is OK, though, to spawn threads in unflagged
;; sections of code where neither serialize or parallelize is in
;; effect.
;;
;; A typical usage is when Guile is used as scripting language in some
;; application doing heavy computations.  If each thread is
;; encapsulated with a serialize form, you can then put a parallelize
;; form around the code performing the heavy computations (typically a
;; C code primitive), enabling the computations to run in parallel
;; while the scripting code runs single-threadedly.
;; 

;;; Code:

(define-module (ice-9 serialize)
  :use-module (ice-9 threads)
  :export (call-with-serialization
	   call-with-parallelization)
  :export-syntax (serialize
		  parallelize))


(define serialization-mutex (make-mutex))
(define admin-mutex (make-mutex))
(define owner #f)

(define (call-with-serialization thunk)
  (let ((outer-owner #f))
    (dynamic-wind
	(lambda ()
	  (lock-mutex admin-mutex)
	  (set! outer-owner owner)
	  (if (not (eqv? outer-owner (dynamic-root)))
	      (begin
		(unlock-mutex admin-mutex)
		(lock-mutex serialization-mutex)
		(set! owner (dynamic-root)))
	      (unlock-mutex admin-mutex)))
	thunk
	(lambda ()
	  (lock-mutex admin-mutex)
	  (if (not (eqv? outer-owner (dynamic-root)))
	      (begin
		(set! owner #f)
		(unlock-mutex serialization-mutex)))
	  (unlock-mutex admin-mutex)))))

(define-macro (serialize . forms)
  `(call-with-serialization (lambda () ,@forms)))

(define (call-with-parallelization thunk)
  (let ((outer-owner #f))
    (dynamic-wind
	(lambda ()
	  (lock-mutex admin-mutex)
	  (set! outer-owner owner)
	  (if (eqv? outer-owner (dynamic-root))
	      (begin
		(set! owner #f)
		(unlock-mutex serialization-mutex)))
	  (unlock-mutex admin-mutex))
	thunk
	(lambda ()
	  (lock-mutex admin-mutex)
	  (if (eqv? outer-owner (dynamic-root))
	      (begin
		(unlock-mutex admin-mutex)
		(lock-mutex serialization-mutex)
		(set! owner outer-owner))
	      (unlock-mutex admin-mutex))))))

(define-macro (parallelize . forms)
  `(call-with-parallelization (lambda () ,@forms)))
