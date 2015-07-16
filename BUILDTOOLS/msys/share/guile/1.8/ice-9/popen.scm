;; popen emulation, for non-stdio based ports.

;;;; Copyright (C) 1998, 1999, 2000, 2001, 2003, 2006 Free Software Foundation, Inc.
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

(define-module (ice-9 popen)
  :export (port/pid-table open-pipe* open-pipe close-pipe open-input-pipe
	   open-output-pipe open-input-output-pipe))

(define (make-rw-port read-port write-port)
  (make-soft-port
   (vector
    (lambda (c) (write-char c write-port))
    (lambda (s) (display s write-port))
    (lambda () (force-output write-port))
    (lambda () (read-char read-port))
    (lambda () (close-port read-port) (close-port write-port)))
   "r+"))

;; a guardian to ensure the cleanup is done correctly when
;; an open pipe is gc'd or a close-port is used.
(define pipe-guardian (make-guardian))

;; a weak hash-table to store the process ids.
(define port/pid-table (make-weak-key-hash-table 31))

(define (ensure-fdes port mode)
  (or (false-if-exception (fileno port))
      (open-fdes *null-device* mode)))

;; run a process connected to an input, an output or an
;; input/output port
;; mode: OPEN_READ, OPEN_WRITE or OPEN_BOTH
;; returns port/pid pair.
(define (open-process mode prog . args)
  (let* ((reading (or (equal? mode OPEN_READ)
		      (equal? mode OPEN_BOTH)))
	 (writing (or (equal? mode OPEN_WRITE)
		      (equal? mode OPEN_BOTH)))
	 (c2p (if reading (pipe) #f))  ; child to parent
	 (p2c (if writing (pipe) #f))) ; parent to child
    
    (if c2p (setvbuf (cdr c2p) _IONBF))
    (if p2c (setvbuf (cdr p2c) _IONBF))
    (let ((pid (primitive-fork)))
      (cond ((= pid 0)
	     ;; child
	     (set-batch-mode?! #t)

	     ;; select the three file descriptors to be used as
	     ;; standard descriptors 0, 1, 2 for the new
	     ;; process. They are pipes to/from the parent or taken
	     ;; from the current Scheme input/output/error ports if
	     ;; possible.

	     (let ((input-fdes (if writing
				   (fileno (car p2c))
				   (ensure-fdes (current-input-port)
						O_RDONLY)))
		   (output-fdes (if reading
				    (fileno (cdr c2p))
				    (ensure-fdes (current-output-port)
						 O_WRONLY)))
		   (error-fdes (ensure-fdes (current-error-port)
					    O_WRONLY)))

	       ;; close all file descriptors in ports inherited from
	       ;; the parent except for the three selected above.
	       ;; this is to avoid causing problems for other pipes in
	       ;; the parent.

	       ;; use low-level system calls, not close-port or the
	       ;; scsh routines, to avoid side-effects such as
	       ;; flushing port buffers or evicting ports.

	       (port-for-each (lambda (pt-entry)
				(false-if-exception
				 (let ((pt-fileno (fileno pt-entry)))
				   (if (not (or (= pt-fileno input-fdes)
						(= pt-fileno output-fdes)
						(= pt-fileno error-fdes)))
				       (close-fdes pt-fileno))))))

	       ;; Copy the three selected descriptors to the standard
	       ;; descriptors 0, 1, 2, if not already there

	       (cond ((not (= input-fdes 0))
		      (if (= output-fdes 0)
			  (set! output-fdes (dup->fdes 0)))
		      (if (= error-fdes 0)
			  (set! error-fdes (dup->fdes 0)))
		      (dup2 input-fdes 0)
		      ;; it's possible input-fdes is error-fdes
		      (if (not (= input-fdes error-fdes))
			  (close-fdes input-fdes))))
	       
	       (cond ((not (= output-fdes 1))
		      (if (= error-fdes 1)
			  (set! error-fdes (dup->fdes 1)))
		      (dup2 output-fdes 1)
		      ;; it's possible output-fdes is error-fdes
		      (if (not (= output-fdes error-fdes))
			  (close-fdes output-fdes))))

	       (cond ((not (= error-fdes 2))
		      (dup2 error-fdes 2)
		      (close-fdes error-fdes)))
		     
	       (apply execlp prog prog args)))

	    (else
	     ;; parent
	     (if c2p (close-port (cdr c2p)))
	     (if p2c (close-port (car p2c)))
	     (cons (cond ((not writing) (car c2p))
			 ((not reading) (cdr p2c))
			 (else (make-rw-port (car c2p)
					     (cdr p2c))))
		   pid))))))

(define (open-pipe* mode command . args)
  "Executes the program @var{command} with optional arguments
@var{args} (all strings) in a subprocess.
A port to the process (based on pipes) is created and returned.
@var{modes} specifies whether an input, an output or an input-output
port to the process is created: it should be the value of
@code{OPEN_READ}, @code{OPEN_WRITE} or @code{OPEN_BOTH}."
  (let* ((port/pid (apply open-process mode command args))
	 (port (car port/pid)))
    (pipe-guardian port)
    (hashq-set! port/pid-table port (cdr port/pid))
    port))

(define (open-pipe command mode)
  "Executes the shell command @var{command} (a string) in a subprocess.
A port to the process (based on pipes) is created and returned.
@var{modes} specifies whether an input, an output or an input-output
port to the process is created: it should be the value of
@code{OPEN_READ}, @code{OPEN_WRITE} or @code{OPEN_BOTH}."
  (open-pipe* mode "/bin/sh" "-c" command))

(define (fetch-pid port)
  (let ((pid (hashq-ref port/pid-table port)))
    (hashq-remove! port/pid-table port)
    pid))

(define (close-process port/pid)
  (close-port (car port/pid))
  (cdr (waitpid (cdr port/pid))))

;; for the background cleanup handler: just clean up without reporting
;; errors.  also avoids blocking the process: if the child isn't ready
;; to be collected, puts it back into the guardian's live list so it
;; can be tried again the next time the cleanup runs.
(define (close-process-quietly port/pid)
  (catch 'system-error
	 (lambda ()
	   (close-port (car port/pid)))
	 (lambda args #f))
  (catch 'system-error
	 (lambda ()
	   (let ((pid/status (waitpid (cdr port/pid) WNOHANG)))
	     (cond ((= (car pid/status) 0)
		    ;; not ready for collection
		    (pipe-guardian (car port/pid))
		    (hashq-set! port/pid-table
				(car port/pid) (cdr port/pid))))))
	 (lambda args #f)))

(define (close-pipe p)
  "Closes the pipe created by @code{open-pipe}, then waits for the process
to terminate and returns its status value, @xref{Processes, waitpid}, for
information on how to interpret this value."
  (let ((pid (fetch-pid p)))
    (if (not pid)
        (error "close-pipe: pipe not in table"))
    (close-process (cons p pid))))

(define reap-pipes
  (lambda ()
    (let loop ((p (pipe-guardian)))
      (cond (p 
	     ;; maybe removed already by close-pipe.
	     (let ((pid (fetch-pid p)))
	       (if pid
		   (close-process-quietly (cons p pid))))
	     (loop (pipe-guardian)))))))

(add-hook! after-gc-hook reap-pipes)

(define (open-input-pipe command)
  "Equivalent to @code{open-pipe} with mode @code{OPEN_READ}"
  (open-pipe command OPEN_READ))

(define (open-output-pipe command)
  "Equivalent to @code{open-pipe} with mode @code{OPEN_WRITE}"
  (open-pipe command OPEN_WRITE))

(define (open-input-output-pipe command)
  "Equivalent to @code{open-pipe} with mode @code{OPEN_BOTH}"
  (open-pipe command OPEN_BOTH))
