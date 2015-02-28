;; popen emulation, for non-stdio based ports.

;;;; Copyright (C) 1998, 1999, 2000, 2001 Free Software Foundation, Inc.
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

(define-module (ice-9 popen)
  :export (port/pid-table open-pipe close-pipe open-input-pipe
	   open-output-pipe))

;;    (define-module (guile popen)
;;      :use-module (guile posix))

;; a guardian to ensure the cleanup is done correctly when
;; an open pipe is gc'd or a close-port is used.
(define pipe-guardian (make-guardian))

;; a weak hash-table to store the process ids.
(define port/pid-table (make-weak-key-hash-table 31))

(define (ensure-fdes port mode)
  (or (false-if-exception (fileno port))
      (open-fdes *null-device* mode)))

;; run a process connected to an input or output port.
;; mode: OPEN_READ or OPEN_WRITE.
;; returns port/pid pair.
(define (open-process mode prog . args)
  (let ((p (pipe))
	(reading (string=? mode OPEN_READ)))
    (setvbuf (cdr p) _IONBF)
    (let ((pid (primitive-fork)))
      (cond ((= pid 0)
	     ;; child
	     (set-batch-mode?! #t)

	     ;; select the three file descriptors to be used as
	     ;; standard descriptors 0, 1, 2 for the new process.  one
	     ;; is the pipe to the parent, the other two are taken
	     ;; from the current Scheme input/output/error ports if
	     ;; possible.

	     (let ((input-fdes (if reading
				   (ensure-fdes (current-input-port)
						O_RDONLY)
				   (fileno (car p))))
		   (output-fdes (if reading
				    (fileno (cdr p))
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

	       ;; copy the three selected descriptors to the standard
	       ;; descriptors 0, 1, 2.  note that it's possible that
	       ;; output-fdes or input-fdes is equal to error-fdes.

	       (cond ((not (= input-fdes 0))
		      (if (= output-fdes 0)
			  (set! output-fdes (dup->fdes 0)))
		      (if (= error-fdes 0)
			  (set! error-fdes (dup->fdes 0)))
		      (dup2 input-fdes 0)))

	       (cond ((not (= output-fdes 1))
		      (if (= error-fdes 1)
			  (set! error-fdes (dup->fdes 1)))
		      (dup2 output-fdes 1)))

	       (dup2 error-fdes 2)
		     
	       (apply execlp prog prog args)))

	    (else
	     ;; parent
	     (if reading
		 (close-port (cdr p))
		 (close-port (car p)))
	     (cons (if reading
		       (car p)
		       (cdr p))
		   pid))))))

(define (open-pipe command mode)
  "Executes the shell command @var{command} (a string) in a subprocess.
A pipe to the process is created and returned.  @var{modes} specifies
whether an input or output pipe to the process is created: it should 
be the value of @code{OPEN_READ} or @code{OPEN_WRITE}."
  (let* ((port/pid (open-process mode "/bin/sh" "-c" command))
	 (port (car port/pid)))
    (pipe-guardian port)
    (hashq-set! port/pid-table port (cdr port/pid))
    port))

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
