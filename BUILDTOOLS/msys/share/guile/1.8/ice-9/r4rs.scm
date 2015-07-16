;;;; r4rs.scm --- definitions needed for libguile to be R4RS compliant
;;;; Jim Blandy <jimb@cyclic.com> --- October 1996

;;;; 	Copyright (C) 1996, 1997, 1998, 2000, 2001, 2006 Free Software Foundation, Inc.
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


;;;; apply and call-with-current-continuation

;;; We want these to be tail-recursive, so instead of using primitive
;;; procedures, we define them as closures in terms of the primitive
;;; macros @apply and @call-with-current-continuation.
(set! apply (lambda (fun . args) (@apply fun (apply:nconc2last args))))
(set-procedure-property! apply 'name 'apply)
(define (call-with-current-continuation proc)
  (@call-with-current-continuation proc))
(define (call-with-values producer consumer)
  (@call-with-values producer consumer))


;;;; Basic Port Code

;;; Specifically, the parts of the low-level port code that are written in 
;;; Scheme rather than C.
;;;
;;; WARNING: the parts of this interface that refer to file ports
;;; are going away.   It would be gone already except that it is used
;;; "internally" in a few places.


;;; OPEN_READ, OPEN_WRITE, and OPEN_BOTH are used to request the
;;; proper mode to open files in.
;;;
;;; If we want to support systems that do CRLF->LF translation, like
;;; Windows, then we should have a symbol in scmconfig.h made visible
;;; to the Scheme level that we can test here, and autoconf magic to
;;; #define it when appropriate.  Windows will probably just have a
;;; hand-generated scmconfig.h file.
(define OPEN_READ "r")
(define OPEN_WRITE "w")
(define OPEN_BOTH "r+")

(define *null-device* "/dev/null")

(define (open-input-file str)
  "Takes a string naming an existing file and returns an input port
capable of delivering characters from the file.  If the file
cannot be opened, an error is signalled."
  (open-file str OPEN_READ))

(define (open-output-file str)
  "Takes a string naming an output file to be created and returns an
output port capable of writing characters to a new file by that
name.  If the file cannot be opened, an error is signalled.  If a
file with the given name already exists, the effect is unspecified."
  (open-file str OPEN_WRITE))

(define (open-io-file str) 
  "Open file with name STR for both input and output."
  (open-file str OPEN_BOTH))

(define close-io-port close-port)

(define (call-with-input-file str proc)
  "PROC should be a procedure of one argument, and STR should be a
string naming a file.  The file must
already exist. These procedures call PROC
with one argument: the port obtained by opening the named file for
input or output.  If the file cannot be opened, an error is
signalled.  If the procedure returns, then the port is closed
automatically and the value yielded by the procedure is returned.
If the procedure does not return, then the port will not be closed
automatically unless it is possible to prove that the port will
never again be used for a read or write operation."
  (let* ((file (open-input-file str))
	 (ans (proc file)))
    (close-input-port file)
    ans))

(define (call-with-output-file str proc)
  "PROC should be a procedure of one argument, and STR should be a
string naming a file.  The behaviour is unspecified if the file 
already exists. These procedures call PROC
with one argument: the port obtained by opening the named file for
input or output.  If the file cannot be opened, an error is
signalled.  If the procedure returns, then the port is closed
automatically and the value yielded by the procedure is returned.
If the procedure does not return, then the port will not be closed
automatically unless it is possible to prove that the port will
never again be used for a read or write operation."
  (let* ((file (open-output-file str))
	 (ans (proc file)))
    (close-output-port file)
    ans))

(define (with-input-from-port port thunk)
  (let* ((swaports (lambda () (set! port (set-current-input-port port)))))
    (dynamic-wind swaports thunk swaports)))

(define (with-output-to-port port thunk)
  (let* ((swaports (lambda () (set! port (set-current-output-port port)))))
    (dynamic-wind swaports thunk swaports)))

(define (with-error-to-port port thunk)
  (let* ((swaports (lambda () (set! port (set-current-error-port port)))))
    (dynamic-wind swaports thunk swaports)))

(define (with-input-from-file file thunk)
  "THUNK must be a procedure of no arguments, and FILE must be a
string naming a file.  The file must already exist. The file is opened for
input, an input port connected to it is made
the default value returned by `current-input-port', 
and the THUNK is called with no arguments.
When the THUNK returns, the port is closed and the previous
default is restored.  Returns the value yielded by THUNK.  If an
escape procedure is used to escape from the continuation of these
procedures, their behavior is implementation dependent."
  (let* ((nport (open-input-file file))
	 (ans (with-input-from-port nport thunk)))
    (close-port nport)
    ans))

(define (with-output-to-file file thunk)
  "THUNK must be a procedure of no arguments, and FILE must be a
string naming a file.  The effect is unspecified if the file already exists. 
The file is opened for output, an output port connected to it is made
the default value returned by `current-output-port', 
and the THUNK is called with no arguments.
When the THUNK returns, the port is closed and the previous
default is restored.  Returns the value yielded by THUNK.  If an
escape procedure is used to escape from the continuation of these
procedures, their behavior is implementation dependent."
  (let* ((nport (open-output-file file))
	 (ans (with-output-to-port nport thunk)))
    (close-port nport)
    ans))

(define (with-error-to-file file thunk)
  "THUNK must be a procedure of no arguments, and FILE must be a
string naming a file.  The effect is unspecified if the file already exists. 
The file is opened for output, an output port connected to it is made
the default value returned by `current-error-port', 
and the THUNK is called with no arguments.
When the THUNK returns, the port is closed and the previous
default is restored.  Returns the value yielded by THUNK.  If an
escape procedure is used to escape from the continuation of these
procedures, their behavior is implementation dependent."
  (let* ((nport (open-output-file file))
	 (ans (with-error-to-port nport thunk)))
    (close-port nport)
    ans))

(define (with-input-from-string string thunk)
  "THUNK must be a procedure of no arguments.
The test of STRING  is opened for
input, an input port connected to it is made, 
and the THUNK is called with no arguments.
When the THUNK returns, the port is closed.
Returns the value yielded by THUNK.  If an
escape procedure is used to escape from the continuation of these
procedures, their behavior is implementation dependent."
  (call-with-input-string string
   (lambda (p) (with-input-from-port p thunk))))

(define (with-output-to-string thunk)
  "Calls THUNK and returns its output as a string."
  (call-with-output-string
   (lambda (p) (with-output-to-port p thunk))))

(define (with-error-to-string thunk)
  "Calls THUNK and returns its error output as a string."
  (call-with-output-string
   (lambda (p) (with-error-to-port p thunk))))

(define the-eof-object (call-with-input-string "" (lambda (p) (read-char p))))


;;;; Loading

(if (not (defined? '%load-verbosely))
    (define %load-verbosely #f))
(define (assert-load-verbosity v) (set! %load-verbosely v))

(define (%load-announce file)
  (if %load-verbosely
      (with-output-to-port (current-error-port)
	(lambda ()
	  (display ";;; ")
	  (display "loading ")
	  (display file)
	  (newline)
	  (force-output)))))

(set! %load-hook %load-announce)

(define (load name . reader)
  (with-fluid* current-reader (and (pair? reader) (car reader))
    (lambda ()
      (start-stack 'load-stack
		   (primitive-load name)))))
