;;;; (ice-9 debugger state) -- debugger state representation

;;; Copyright (C) 2002, 2006 Free Software Foundation, Inc.
;;;
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

(define-module (ice-9 debugger state)
  #:export (make-state
	    state-stack
	    state-index
	    state-flags
	    set-stack-index!))

(define state-rtd (make-record-type "debugger-state" '(stack index flags)))
(define state? (record-predicate state-rtd))
(define make-state
  (let ((make-state-internal (record-constructor state-rtd
						 '(stack index flags))))
    (lambda (stack index . flags)
      (make-state-internal stack index flags))))
(define state-stack (record-accessor state-rtd 'stack))
(define state-index (record-accessor state-rtd 'index))
(define state-flags (record-accessor state-rtd 'flags))

(define set-state-index! (record-modifier state-rtd 'index))

(define (set-stack-index! state index)
  (let* ((stack (state-stack state))
	 (ssize (stack-length stack)))
    (set-state-index! state
		      (cond ((< index 0) 0)
			    ((>= index ssize) (- ssize 1))
			    (else index)))))

;;; (ice-9 debugger state) ends here.
