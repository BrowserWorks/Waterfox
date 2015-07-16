;;;; Guile Debugger UI server

;;; Copyright (C) 2003 Free Software Foundation, Inc.
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
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

(define-module (ice-9 gds-server)
  #:export (run-server))

;; UI is normally via a pipe to Emacs, so make sure to flush output
;; every time we write.
(define (write-to-ui form)
  (write form)
  (newline)
  (force-output))

(define (trc . args)
  (write-to-ui (cons '* args)))

(define (with-error->eof proc port)
  (catch #t
	 (lambda () (proc port))
	 (lambda args the-eof-object)))

(define connection->id (make-object-property))

(define (run-server port-or-path)

  (or (integer? port-or-path)
      (string? port-or-path)
      (error "port-or-path should be an integer (port number) or a string (file name)"
	     port-or-path))

  (let ((server (socket (if (integer? port-or-path) PF_INET PF_UNIX)
			SOCK_STREAM
			0)))

    ;; Initialize server socket.
    (if (integer? port-or-path)
	(begin
	  (setsockopt server SOL_SOCKET SO_REUSEADDR 1)
	  (bind server AF_INET INADDR_ANY port-or-path))
	(begin
	  (catch #t
		 (lambda () (delete-file port-or-path))
		 (lambda _ #f))
	  (bind server AF_UNIX port-or-path)))

    ;; Start listening.
    (listen server 5)

    (let loop ((clients '()) (readable-sockets '()))

      (define (do-read port)
	(cond ((eq? port (current-input-port))
	       (do-read-from-ui))
	      ((eq? port server)
	       (accept-new-client))
	      (else
	       (do-read-from-client port))))

      (define (do-read-from-ui)
	(trc "reading from ui")
	(let* ((form (with-error->eof read (current-input-port)))
	       (client (assq-ref (map (lambda (port)
					(cons (connection->id port) port))
				      clients)
				 (car form))))
	  (with-error->eof read-char (current-input-port))
	  (if client
	      (begin
		(write (cdr form) client)
		(newline client))
	      (trc "client not found")))	
	clients)

      (define (accept-new-client)
        (let ((new-port (car (accept server))))
	  ;; Read the client's ID.
	  (let ((name-form (read new-port)))
	    ;; Absorb the following newline character.
	    (read-char new-port)
	    ;; Check that we have a name form.
	    (or (eq? (car name-form) 'name)
		(error "Invalid name form:" name-form))
	    ;; Store an association from the connection to the ID.
	    (set! (connection->id new-port) (cadr name-form))
	    ;; Pass the name form on to Emacs.
	    (write-to-ui (cons (connection->id new-port) name-form)))
	  ;; Add the new connection to the set that we select on.
          (cons new-port clients)))

      (define (do-read-from-client port)
	(trc "reading from client")
	(let ((next-char (with-error->eof peek-char port)))
	  ;;(trc 'next-char next-char)
	  (cond ((eof-object? next-char)
		 (write-to-ui (list (connection->id port) 'closed))
		 (close port)
		 (delq port clients))
		((char=? next-char #\()
		 (write-to-ui (cons (connection->id port)
				    (with-error->eof read port)))
		 clients)
		(else
		 (with-error->eof read-char port)
		 clients))))

      ;;(trc 'clients clients)
      ;;(trc 'readable-sockets readable-sockets)

      (if (null? readable-sockets)
	  (loop clients (car (select (cons (current-input-port)
					   (cons server clients))
				     '()
				     '())))
	  (loop (do-read (car readable-sockets)) (cdr readable-sockets))))))

;; What happens if there are multiple copies of Emacs running on the
;; same machine, and they all try to start up the GDS server?  They
;; can't all listen on the same TCP port, so the short answer is that
;; all of them except the first will get an EADDRINUSE error when
;; trying to bind.
;;
;; We want to be able to handle this scenario, though, so that Scheme
;; code can be evaluated, and help invoked, in any of those Emacsen.
;; So we introduce the idea of a "slave server".  When a new GDS
;; server gets an EADDRINUSE bind error, the implication is that there
;; is already a GDS server running, so the new server instead connects
;; to the existing one (by issuing a connect to the GDS port number).
;;
;; Let's call the first server the "master", and the new one the
;; "slave".  In principle the master can now proxy any GDS client
;; connections through to the slave, so long as there is sufficient
;; information in the protocol for it to decide when and how to do
;; this.
;;
;; The basic information and mechanism that we need for this is as
;; follows.
;;
;; - A unique ID for each Emacs; this can be each Emacs's PID.  When a
;; slave server connects to the master, it announces itself by sending
;; the protocol (emacs ID).
;;
;; - A way for a client to indicate which Emacs it wants to use.  At
;; the protocol level, this is an extra argument in the (name ...)
;; protocol.  (The absence of this argument means "no preference".  A
;; simplistic master server might then decide to use its own Emacs; a
;; cleverer one might monitor which Emacs appears to be most in use,
;; and use that one.)  At the API level this can be an optional
;; argument to the `gds-connect' procedure, and the Emacs GDS code
;; would obviously set this argument when starting a client from
;; within Emacs.
;;
;; We also want a strategy for continuing seamlessly if the master
;; server shuts down.
;;
;; - Each slave server will detect this as an error on the connection
;; to the master socket.  Each server then tries to bind to the GDS
;; port again (a race which the OS will resolve), and if that fails,
;; connect again.  The result of this is that there should be a new
;; master, and the others all slaves connected to the new master.
;;
;; - Each client will also detect this as an error on the connection
;; to the (master) server.  Either the client should try to connect
;; again (perhaps after a short delay), or the reconnection can be
;; delayed until the next time that the client requires the server.
;; (Probably the latter, all done within `gds-read'.)
;;
;; (Historical note: Before this master-slave idea, clients were
;; identified within gds-server.scm and gds*.el by an ID which was
;; actually the file descriptor of their connection to the server.
;; That is no good in the new scheme, because each client's ID must
;; persist when the master server changes, so we now use the client's
;; PID instead.  We didn't use PID before because the client/server
;; code was written to be completely asynchronous, which made it
;; tricky for the server to discover each client's PID and associate
;; it with a particular connection.  Now we solve that problem by
;; handling the initial protocol exchange synchronously.)
(define (run-slave-server port)
  'not-implemented)
