;;; installed-scm-file

;;;; Copyright (C) 1997, 1999, 2000, 2001 Free Software Foundation, Inc.
;;;; 
;;;; This program is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation; either version 2, or (at your option)
;;;; any later version.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this software; see the file COPYING.  If not, write to
;;;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;;;; Boston, MA 02111-1307 USA
;;;;
;;;; As a special exception, the Free Software Foundation gives permission
;;;; for additional uses of the text contained in its release of GUILE.
;;;;
;;;; The exception is that, if you link the GUILE library with other files
;;;; to produce an executable, this does not by itself cause the
;;;; resulting executable to be covered by the GNU General Public License.
;;;; Your use of that executable is in no way restricted on account of
;;;; linking the GUILE library code into it.
;;;;
;;;; This exception does not however invalidate any other reasons why
;;;; the executable file might be covered by the GNU General Public License.
;;;;
;;;; This exception applies only to the code released by the
;;;; Free Software Foundation under the name GUILE.  If you copy
;;;; code from other Free Software Foundation releases into a copy of
;;;; GUILE, as the General Public License permits, the exception does
;;;; not apply to the code that you add in this way.  To avoid misleading
;;;; anyone as to the status of such modified files, you must delete
;;;; this exception notice from them.
;;;;
;;;; If you write modifications of your own for GUILE, it is your choice
;;;; whether to permit this exception to apply to your modifications.
;;;; If you do not wish that, delete this exception notice.
;;;; 


;;; This is the Scheme part of the module for delimited I/O.  It's
;;; similar to (scsh rdelim) but somewhat incompatible.

(define-module (ice-9 rdelim)
  :export (read-line read-line! read-delimited read-delimited!
	   %read-delimited! %read-line write-line)  ; C
  )

(%init-rdelim-builtins)

(define (read-line! string . maybe-port)
  ;; corresponds to SCM_LINE_INCREMENTORS in libguile.
  (define scm-line-incrementors "\n")

  (let* ((port (if (pair? maybe-port)
		   (car maybe-port)
		   (current-input-port))))
    (let* ((rv (%read-delimited! scm-line-incrementors
				 string
				 #t
				 port))
	   (terminator (car rv))
	   (nchars (cdr rv)))
      (cond ((and (= nchars 0)
		  (eof-object? terminator))
	     terminator)
	    ((not terminator) #f)
	    (else nchars)))))

(define (read-delimited! delims buf . args)
  (let* ((num-args (length args))
	 (port (if (> num-args 0)
		   (car args)
		   (current-input-port)))
	 (handle-delim (if (> num-args 1)
			   (cadr args)
			   'trim))
	 (start (if (> num-args 2)
		    (caddr args)
		    0))
	 (end (if (> num-args 3)
		  (cadddr args)
		  (string-length buf))))
    (let* ((rv (%read-delimited! delims
				 buf
				 (not (eq? handle-delim 'peek))
				 port
				 start
				 end))
	   (terminator (car rv))
	   (nchars (cdr rv)))
      (cond ((or (not terminator)	; buffer filled
		 (eof-object? terminator))
	     (if (zero? nchars)
		 (if (eq? handle-delim 'split)
		     (cons terminator terminator)
		     terminator)
		 (if (eq? handle-delim 'split)
		     (cons nchars terminator)
		     nchars)))
	    (else
	     (case handle-delim
	       ((trim peek) nchars)
	       ((concat) (string-set! buf (+ nchars start) terminator)
			 (+ nchars 1))
	       ((split) (cons nchars terminator))
	       (else (error "unexpected handle-delim value: " 
			    handle-delim))))))))
  
(define (read-delimited delims . args)
  (let* ((port (if (pair? args)
		   (let ((pt (car args)))
		     (set! args (cdr args))
		     pt)
		   (current-input-port)))
	 (handle-delim (if (pair? args)
			   (car args)
			   'trim)))
    (let loop ((substrings '())
	       (total-chars 0)
	       (buf-size 100))		; doubled each time through.
      (let* ((buf (make-string buf-size))
	     (rv (%read-delimited! delims
				   buf
				   (not (eq? handle-delim 'peek))
				   port))
	     (terminator (car rv))
	     (nchars (cdr rv))
	     (join-substrings
	      (lambda ()
		(apply string-append
		       (reverse
			(cons (if (and (eq? handle-delim 'concat)
				       (not (eof-object? terminator)))
				  (string terminator)
				  "")
			      (cons (substring buf 0 nchars)
				    substrings))))))
	     (new-total (+ total-chars nchars)))
	(cond ((not terminator)
	       ;; buffer filled.
	       (loop (cons (substring buf 0 nchars) substrings)
		     new-total
		     (* buf-size 2)))
	      ((eof-object? terminator)
	       (if (zero? new-total)
		   (if (eq? handle-delim 'split)
		       (cons terminator terminator)
		       terminator)
		   (if (eq? handle-delim 'split)
		       (cons (join-substrings) terminator)
		       (join-substrings))))
	      (else
	       (case handle-delim
		   ((trim peek concat) (join-substrings))
		   ((split) (cons (join-substrings) terminator))


		   (else (error "unexpected handle-delim value: "
				handle-delim)))))))))

;;; read-line [PORT [HANDLE-DELIM]] reads a newline-terminated string
;;; from PORT.  The return value depends on the value of HANDLE-DELIM,
;;; which may be one of the symbols `trim', `concat', `peek' and
;;; `split'.  If it is `trim' (the default), the trailing newline is
;;; removed and the string is returned.  If `concat', the string is
;;; returned with the trailing newline intact.  If `peek', the newline
;;; is left in the input port buffer and the string is returned.  If
;;; `split', the newline is split from the string and read-line
;;; returns a pair consisting of the truncated string and the newline.

(define (read-line . args)
  (let* ((port		(if (null? args)
			    (current-input-port)
			    (car args)))
	 (handle-delim	(if (> (length args) 1)
			    (cadr args)
			    'trim))
	 (line/delim	(%read-line port))
	 (line		(car line/delim))
	 (delim		(cdr line/delim)))
    (case handle-delim
      ((trim) line)
      ((split) line/delim)
      ((concat) (if (and (string? line) (char? delim))
		    (string-append line (string delim))
		    line))
      ((peek) (if (char? delim)
		  (unread-char delim port))
	      line)
      (else
       (error "unexpected handle-delim value: " handle-delim)))))
