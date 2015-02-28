;;;; buffered-input.scm --- construct a port from a buffered input reader
;;;;
;;;; 	Copyright (C) 2001 Free Software Foundation, Inc.
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

(define-module (ice-9 buffered-input)
  #:export (make-buffered-input-port
            make-line-buffered-input-port
            set-buffered-input-continuation?!))

;; @code{buffered-input-continuation?} is a property of the ports
;; created by @code{make-line-buffered-input-port} that stores the
;; read continuation flag for each such port.
(define buffered-input-continuation? (make-object-property))

(define (set-buffered-input-continuation?! port val)
  "Set the read continuation flag for @var{port} to @var{val}.

See @code{make-buffered-input-port} for the meaning and use of this
flag."
  (set! (buffered-input-continuation? port) val))

(define (make-buffered-input-port reader)
  "Construct a line-buffered input port from the specified @var{reader}.
@var{reader} should be a procedure of one argument that somehow reads
a chunk of input and returns it as a string.

The port created by @code{make-buffered-input-port} does @emph{not}
interpolate any additional characters between the strings returned by
@var{reader}.

@var{reader} should take a boolean @var{continuation?} argument.
@var{continuation?} indicates whether @var{reader} is being called to
start a logically new read operation (in which case
@var{continuation?} is @code{#f}) or to continue a read operation for
which some input has already been read (in which case
@var{continuation?} is @code{#t}).  Some @var{reader} implementations
use the @var{continuation?} argument to determine what prompt to
display to the user.

The new/continuation distinction is largely an application-level
concept: @code{set-buffered-input-continuation?!} allows an
application to specify when a read operation is considered to be new.
But note that if there is non-whitespace data already buffered in the
port when a new read operation starts, this data will be read before
the first call to @var{reader}, and so @var{reader} will be called
with @var{continuation?} set to @code{#t}."
  (let ((read-string "")
	(string-index -1))
    (letrec ((get-character
	      (lambda ()
		(cond 
		 ((eof-object? read-string)
		  read-string)
		 ((>= string-index (string-length read-string))
		  (set! string-index -1)
                  (get-character))
		 ((= string-index -1)
		  (set! read-string (reader (buffered-input-continuation? port)))
                  (set! string-index 0)
                  (if (not (eof-object? read-string))
                      (get-character)
                      read-string))
		 (else
		  (let ((res (string-ref read-string string-index)))
		    (set! string-index (+ 1 string-index))
                    (if (not (char-whitespace? res))
                        (set! (buffered-input-continuation? port) #t))
		    res)))))
             (port #f))
      (set! port (make-soft-port (vector #f #f #f get-character #f) "r"))
      (set! (buffered-input-continuation? port) #f)
      port)))

(define (make-line-buffered-input-port reader)
  "Construct a line-buffered input port from the specified @var{reader}.
@var{reader} should be a procedure of one argument that somehow reads
a line of input and returns it as a string @emph{without} the
terminating newline character.

The port created by @code{make-line-buffered-input-port} automatically
interpolates a newline character after each string returned by
@var{reader}.

@var{reader} should take a boolean @var{continuation?} argument.  For
the meaning and use of this argument, see
@code{make-buffered-input-port}."
  (make-buffered-input-port (lambda (continuation?)
                              (let ((str (reader continuation?)))
                                (if (eof-object? str)
                                    str
                                    (string-append str "\n"))))))

;;; buffered-input.scm ends here
