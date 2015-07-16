;;; installed-scm-file

;;;; 	Copyright (C) 1996, 1998, 2001, 2003, 2006 Free Software Foundation, Inc.
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



(define-module (ice-9 lineio)
  :use-module (ice-9 readline)
  :export (unread-string read-string lineio-port?
	   make-line-buffering-input-port))


;;; {Line Buffering Input Ports}
;;;
;;; [This is a work-around to get past certain deficiencies in the capabilities
;;;  of ports.  Eventually, ports should be fixed and this module nuked.]
;;;
;;; A line buffering input port supports:
;;;
;;; 	read-string  	which returns the next line of input
;;;	unread-string 	which pushes a line back onto the stream
;;; 
;;; The implementation of unread-string is kind of limited; it doesn't
;;; interact properly with unread-char, or any of the other port
;;; reading functions.  Only read-string will get you back the things that
;;; unread-string accepts.
;;;
;;; Normally a "line" is all characters up to and including a newline.
;;; If lines are put back using unread-string, they can be broken arbitrarily
;;; -- that is, read-string returns strings passed to unread-string (or 
;;; shared substrings of them).
;;;

;; read-string port
;; unread-string port str
;;   Read (or buffer) a line from PORT.
;;
;; Not all ports support these functions -- only those with 
;; 'unread-string and 'read-string properties, bound to hooks
;; implementing these functions.
;;
(define (unread-string str line-buffering-input-port)
  ((object-property line-buffering-input-port 'unread-string) str))

;;
(define (read-string line-buffering-input-port)
  ((object-property line-buffering-input-port 'read-string)))


(define (lineio-port? port)
  (not (not (object-property port 'read-string))))

;; make-line-buffering-input-port port
;;   Return a wrapper for PORT.  The wrapper handles read-string/unread-string.
;;
;; The port returned by this function reads newline terminated lines from PORT.
;; It buffers these characters internally, and parsels them out via calls
;; to read-char, read-string, and unread-string.
;;

(define (make-line-buffering-input-port underlying-port)
  (let* (;; buffers - a list of strings put back by unread-string or cached
	 ;; using read-line.
	 ;;
	 (buffers '())

	 ;; getc - return the next character from a buffer or from the underlying
	 ;; port.
	 ;;
	 (getc (lambda ()
		 (if (not buffers)
		     (read-char underlying-port)
		     (let ((c (string-ref (car buffers) 0)))
		       (if (= 1 (string-length (car buffers)))
			   (set! buffers (cdr buffers))
			   (set-car! buffers (substring (car buffers) 1)))
		       c))))

	 (propogate-close (lambda () (close-port underlying-port)))

	 (self (make-soft-port (vector #f #f #f getc propogate-close) "r"))

	 (unread-string (lambda (str)
			  (and (< 0 (string-length str))
				   (set! buffers (cons str buffers)))))

	 (read-string (lambda ()
		       (cond
			((not (null? buffers))
			 (let ((answer (car buffers)))
			   (set! buffers (cdr buffers))
			   answer))
			(else
			 (read-line underlying-port 'concat)))))) ;handle-newline->concat

    (set-object-property! self 'unread-string unread-string)
    (set-object-property! self 'read-string read-string)
    self))


