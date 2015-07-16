;;;; 	Copyright (C) 2001, 2004, 2006 Free Software Foundation, Inc.
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

;; This module exports a single macro: `time'.
;; Usage: (time exp)
;;
;; Example:
;; guile> (time (sleep 3))
;; clock utime stime cutime cstime gctime
;; 3.01  0.00  0.00   0.00   0.00   0.00
;; 0

;;; Code:

(define-module (ice-9 time)
  :use-module (ice-9 format)
  :export (time))

(define (time-proc proc)
  (let* ((gc-start (gc-run-time))
         (tms-start (times))
         (result (proc))
         (tms-end (times))
         (gc-end (gc-run-time)))
    ;; FIXME: We would probably like format ~f to accept rationals, but
    ;; currently it doesn't so we force to a flonum with exact->inexact.
    (define (get proc start end)
      (exact->inexact (/ (- (proc end) (proc start)) internal-time-units-per-second)))
    (display "clock utime stime cutime cstime gctime\n")
    (format #t "~5,2F ~5,2F ~5,2F ~6,2F ~6,2F ~6,2F\n"
            (get tms:clock tms-start tms-end)
            (get tms:utime tms-start tms-end)
            (get tms:stime tms-start tms-end)
            (get tms:cutime tms-start tms-end)
            (get tms:cstime tms-start tms-end)
            (get identity gc-start gc-end))
    result))

(define-macro (time exp)
  `(,time-proc (lambda () ,exp)))

;;; time.scm ends here
