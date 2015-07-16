;;; sieve-manage.el --- Implementation of the managesieve protocol in elisp

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.

;; Author: Simon Josefsson <simon@josefsson.org>
;;         Albert Krewinkel <tarleb@moltkeplatz.de>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library provides an elisp API for the managesieve network
;; protocol.
;;
;; It uses the SASL library for authentication, which means it
;; supports DIGEST-MD5, CRAM-MD5, SCRAM-MD5, NTLM, PLAIN and LOGIN
;; methods.  STARTTLS is not well tested, but should be easy to get to
;; work if someone wants.
;;
;; The API should be fairly obvious for anyone familiar with the
;; managesieve protocol, interface functions include:
;;
;; `sieve-manage-open'
;; open connection to managesieve server, returning a buffer to be
;; used by all other API functions.
;;
;; `sieve-manage-opened'
;; check if a server is open or not
;;
;; `sieve-manage-close'
;; close a server connection.
;;
;; `sieve-manage-listscripts'
;; `sieve-manage-deletescript'
;; `sieve-manage-getscript'
;; performs managesieve protocol actions
;;
;; and that's it.  Example of a managesieve session in *scratch*:
;;
;; (with-current-buffer (sieve-manage-open "mail.example.com")
;;   (sieve-manage-authenticate)
;;   (sieve-manage-listscripts))
;;
;; => ((active . "main") "vacation")
;;
;; References:
;;
;; draft-martin-managesieve-02.txt,
;; "A Protocol for Remotely Managing Sieve Scripts",
;; by Tim Martin.
;;
;; Release history:
;;
;; 2001-10-31 Committed to Oort Gnus.
;; 2002-07-27 Added DELETESCRIPT.  Suggested by Ned Ludd.
;; 2002-08-03 Use SASL library.
;; 2013-06-05 Enabled STARTTLS support, fixed bit rot.

;;; Code:

;; For Emacs <22.2 and XEmacs.
(eval-and-compile
  (unless (fboundp 'declare-function) (defmacro declare-function (&rest r))))

(if (locate-library "password-cache")
    (require 'password-cache)
  (require 'password))

(eval-when-compile
  (require 'cl)				; caddr
  (require 'sasl)
  (require 'starttls))
(autoload 'sasl-find-mechanism "sasl")
(autoload 'auth-source-search "auth-source")

;; User customizable variables:

(defgroup sieve-manage nil
  "Low-level Managesieve protocol issues."
  :group 'mail
  :prefix "sieve-")

(defcustom sieve-manage-log "*sieve-manage-log*"
  "Name of buffer for managesieve session trace."
  :type 'string
  :group 'sieve-manage)

(defcustom sieve-manage-server-eol "\r\n"
  "The EOL string sent from the server."
  :type 'string
  :group 'sieve-manage)

(defcustom sieve-manage-client-eol "\r\n"
  "The EOL string we send to the server."
  :type 'string
  :group 'sieve-manage)

(defcustom sieve-manage-authenticators '(digest-md5
					 cram-md5
					 scram-md5
					 ntlm
					 plain
					 login)
  "Priority of authenticators to consider when authenticating to server."
  ;; FIXME Improve this.  It's not `set'.
  ;; It's like (repeat (choice (const ...))), where each choice can
  ;; only appear once.
  :type '(repeat symbol)
  :group 'sieve-manage)

(defcustom sieve-manage-authenticator-alist
  '((cram-md5   sieve-manage-cram-md5-p       sieve-manage-cram-md5-auth)
    (digest-md5 sieve-manage-digest-md5-p     sieve-manage-digest-md5-auth)
    (scram-md5  sieve-manage-scram-md5-p      sieve-manage-scram-md5-auth)
    (ntlm       sieve-manage-ntlm-p           sieve-manage-ntlm-auth)
    (plain      sieve-manage-plain-p          sieve-manage-plain-auth)
    (login      sieve-manage-login-p          sieve-manage-login-auth))
  "Definition of authenticators.

\(NAME CHECK AUTHENTICATE)

NAME names the authenticator.  CHECK is a function returning non-nil if
the server support the authenticator and AUTHENTICATE is a function
for doing the actual authentication."
  :type '(repeat (list (symbol :tag "Name") (function :tag "Check function")
		       (function :tag "Authentication function")))
  :group 'sieve-manage)

(defcustom sieve-manage-default-port "sieve"
  "Default port number or service name for managesieve protocol."
  :type '(choice integer string)
  :version "24.4"
  :group 'sieve-manage)

(defcustom sieve-manage-default-stream 'network
  "Default stream type to use for `sieve-manage'."
  :version "24.1"
  :type 'symbol
  :group 'sieve-manage)

;; Internal variables:

(defconst sieve-manage-local-variables '(sieve-manage-server
					 sieve-manage-port
					 sieve-manage-auth
					 sieve-manage-stream
					 sieve-manage-process
					 sieve-manage-client-eol
					 sieve-manage-server-eol
					 sieve-manage-capability))
(defconst sieve-manage-coding-system-for-read 'binary)
(defconst sieve-manage-coding-system-for-write 'binary)
(defvar sieve-manage-stream nil)
(defvar sieve-manage-auth nil)
(defvar sieve-manage-server nil)
(defvar sieve-manage-port nil)
(defvar sieve-manage-state 'closed
  "Managesieve state.
Valid states are `closed', `initial', `nonauth', and `auth'.")
(defvar sieve-manage-process nil)
(defvar sieve-manage-capability nil)

;; Internal utility functions
(autoload 'mm-enable-multibyte "mm-util")

(defun sieve-manage-make-process-buffer ()
  (with-current-buffer
      (generate-new-buffer (format " *sieve %s:%s*"
                                   sieve-manage-server
                                   sieve-manage-port))
    (mapc 'make-local-variable sieve-manage-local-variables)
    (mm-enable-multibyte)
    (buffer-disable-undo)
    (current-buffer)))

(defun sieve-manage-erase (&optional p buffer)
  (let ((buffer (or buffer (current-buffer))))
    (and sieve-manage-log
	 (with-current-buffer (get-buffer-create sieve-manage-log)
	   (mm-enable-multibyte)
	   (buffer-disable-undo)
	   (goto-char (point-max))
	   (insert-buffer-substring buffer (with-current-buffer buffer
					     (point-min))
				    (or p (with-current-buffer buffer
					    (point-max)))))))
  (delete-region (point-min) (or p (point-max))))

(defun sieve-manage-open-server (server port &optional stream buffer)
  "Open network connection to SERVER on PORT.
Return the buffer associated with the connection."
  (with-current-buffer buffer
    (sieve-manage-erase)
    (setq sieve-manage-state 'initial)
    (destructuring-bind (proc . props)
        (open-protocol-stream
         "SIEVE" buffer server port
         :type stream
         :capability-command "CAPABILITY\r\n"
         :end-of-command "^\\(OK\\|NO\\).*\n"
         :success "^OK.*\n"
         :return-list t
         :starttls-function
         (lambda (capabilities)
           (when (string-match "\\bSTARTTLS\\b" capabilities)
             "STARTTLS\r\n")))
      (setq sieve-manage-process proc)
      (setq sieve-manage-capability
            (sieve-manage-parse-capability (plist-get props :capabilities)))
      ;; Ignore new capabilities issues after successful STARTTLS
      (when (and (memq stream '(nil network starttls))
                 (eq (plist-get props :type) 'tls))
        (sieve-manage-drop-next-answer))
      (current-buffer))))

;; Authenticators
(defun sieve-sasl-auth (buffer mech)
  "Login to server using the SASL MECH method."
  (message "sieve: Authenticating using %s..." mech)
  (with-current-buffer buffer
    (let* ((auth-info (auth-source-search :host sieve-manage-server
                                          :port "sieve"
                                          :max 1
                                          :create t))
           (user-name (or (plist-get (nth 0 auth-info) :user) ""))
           (user-password (or (plist-get (nth 0 auth-info) :secret) ""))
           (user-password (if (functionp user-password)
                              (funcall user-password)
                            user-password))
           (client (sasl-make-client (sasl-find-mechanism (list mech))
                                     user-name "sieve" sieve-manage-server))
           (sasl-read-passphrase
            ;; We *need* to copy the password, because sasl will modify it
            ;; somehow.
            `(lambda (prompt) ,(copy-sequence user-password)))
           (step (sasl-next-step client nil))
           (tag (sieve-manage-send
                 (concat
                  "AUTHENTICATE \""
                  mech
                  "\""
                  (and (sasl-step-data step)
                       (concat
                        " \""
                        (base64-encode-string
                         (sasl-step-data step)
                         'no-line-break)
                        "\"")))))
           data rsp)
      (catch 'done
        (while t
          (setq rsp nil)
          (goto-char (point-min))
          (while (null (or (progn
                             (setq rsp (sieve-manage-is-string))
                             (if (not (and rsp (looking-at
                                                sieve-manage-server-eol)))
                                 (setq rsp nil)
                               (goto-char (match-end 0))
                               rsp))
                           (setq rsp (sieve-manage-is-okno))))
            (accept-process-output sieve-manage-process 1)
            (goto-char (point-min)))
          (sieve-manage-erase)
          (when (sieve-manage-ok-p rsp)
            (when (and (cadr rsp)
                       (string-match "^SASL \"\\([^\"]+\\)\"" (cadr rsp)))
              (sasl-step-set-data
               step (base64-decode-string (match-string 1 (cadr rsp)))))
            (if (and (setq step (sasl-next-step client step))
                     (setq data (sasl-step-data step)))
                ;; We got data for server but it's finished
                (error "Server not ready for SASL data: %s" data)
              ;; The authentication process is finished.
              (throw 'done t)))
          (unless (stringp rsp)
            (error "Server aborted SASL authentication: %s" (caddr rsp)))
          (sasl-step-set-data step (base64-decode-string rsp))
          (setq step (sasl-next-step client step))
          (sieve-manage-send
           (if (sasl-step-data step)
               (concat "\""
                       (base64-encode-string (sasl-step-data step)
                                             'no-line-break)
                       "\"")
             ""))))
      (message "sieve: Login using %s...done" mech))))

(defun sieve-manage-cram-md5-p (buffer)
  (sieve-manage-capability "SASL" "CRAM-MD5" buffer))

(defun sieve-manage-cram-md5-auth (buffer)
  "Login to managesieve server using the CRAM-MD5 SASL method."
  (sieve-sasl-auth buffer "CRAM-MD5"))

(defun sieve-manage-digest-md5-p (buffer)
  (sieve-manage-capability "SASL" "DIGEST-MD5" buffer))

(defun sieve-manage-digest-md5-auth (buffer)
  "Login to managesieve server using the DIGEST-MD5 SASL method."
  (sieve-sasl-auth buffer "DIGEST-MD5"))

(defun sieve-manage-scram-md5-p (buffer)
  (sieve-manage-capability "SASL" "SCRAM-MD5" buffer))

(defun sieve-manage-scram-md5-auth (buffer)
  "Login to managesieve server using the SCRAM-MD5 SASL method."
  (sieve-sasl-auth buffer "SCRAM-MD5"))

(defun sieve-manage-ntlm-p (buffer)
  (sieve-manage-capability "SASL" "NTLM" buffer))

(defun sieve-manage-ntlm-auth (buffer)
  "Login to managesieve server using the NTLM SASL method."
  (sieve-sasl-auth buffer "NTLM"))

(defun sieve-manage-plain-p (buffer)
  (sieve-manage-capability "SASL" "PLAIN" buffer))

(defun sieve-manage-plain-auth (buffer)
  "Login to managesieve server using the PLAIN SASL method."
  (sieve-sasl-auth buffer "PLAIN"))

(defun sieve-manage-login-p (buffer)
  (sieve-manage-capability "SASL" "LOGIN" buffer))

(defun sieve-manage-login-auth (buffer)
  "Login to managesieve server using the LOGIN SASL method."
  (sieve-sasl-auth buffer "LOGIN"))

;; Managesieve API

(defun sieve-manage-open (server &optional port stream auth buffer)
  "Open a network connection to a managesieve SERVER (string).
Optional argument PORT is port number (integer) on remote server.
Optional argument STREAM is any of `sieve-manage-streams' (a symbol).
Optional argument AUTH indicates authenticator to use, see
`sieve-manage-authenticators' for available authenticators.
If nil, chooses the best stream the server is capable of.
Optional argument BUFFER is buffer (buffer, or string naming buffer)
to work in."
  (setq sieve-manage-port (or port sieve-manage-default-port))
  (with-current-buffer (or buffer (sieve-manage-make-process-buffer))
    (setq sieve-manage-server (or server
                                  sieve-manage-server)
          sieve-manage-stream (or stream
                                  sieve-manage-stream
                                  sieve-manage-default-stream)
          sieve-manage-auth   (or auth
                                  sieve-manage-auth))
    (message "sieve: Connecting to %s..." sieve-manage-server)
    (sieve-manage-open-server sieve-manage-server
                              sieve-manage-port
                              sieve-manage-stream
                              (current-buffer))
    (when (sieve-manage-opened (current-buffer))
      ;; Choose authenticator
      (when (and (null sieve-manage-auth)
                 (not (eq sieve-manage-state 'auth)))
        (dolist (auth sieve-manage-authenticators)
          (when (funcall (nth 1 (assq auth sieve-manage-authenticator-alist))
                       buffer)
            (setq sieve-manage-auth auth)
            (return)))
        (unless sieve-manage-auth
          (error "Couldn't figure out authenticator for server")))
      (sieve-manage-erase)
      (current-buffer))))

(defun sieve-manage-authenticate (&optional buffer)
  "Authenticate on server in BUFFER.
Return `sieve-manage-state' value."
  (with-current-buffer (or buffer (current-buffer))
    (if (eq sieve-manage-state 'nonauth)
        (when (funcall (nth 2 (assq sieve-manage-auth
                                    sieve-manage-authenticator-alist))
                       (current-buffer))
          (setq sieve-manage-state 'auth))
      sieve-manage-state)))

(defun sieve-manage-opened (&optional buffer)
  "Return non-nil if connection to managesieve server in BUFFER is open.
If BUFFER is nil then the current buffer is used."
  (and (setq buffer (get-buffer (or buffer (current-buffer))))
       (buffer-live-p buffer)
       (with-current-buffer buffer
	 (and sieve-manage-process
	      (memq (process-status sieve-manage-process) '(open run))))))

(defun sieve-manage-close (&optional buffer)
  "Close connection to managesieve server in BUFFER.
If BUFFER is nil, the current buffer is used."
  (with-current-buffer (or buffer (current-buffer))
    (when (sieve-manage-opened)
      (sieve-manage-send "LOGOUT")
      (sit-for 1))
    (when (and sieve-manage-process
	       (memq (process-status sieve-manage-process) '(open run)))
      (delete-process sieve-manage-process))
    (setq sieve-manage-process nil)
    (sieve-manage-erase)
    t))

(defun sieve-manage-capability (&optional name value buffer)
  "Check if capability NAME of server BUFFER match VALUE.
If it does, return the server value of NAME. If not returns nil.
If VALUE is nil, do not check VALUE and return server value.
If NAME is nil, return the full server list of capabilities."
  (with-current-buffer (or buffer (current-buffer))
    (if (null name)
	sieve-manage-capability
      (let ((server-value (cadr (assoc name sieve-manage-capability))))
        (when (or (null value)
                  (and server-value
                       (string-match value server-value)))
          server-value)))))

(defun sieve-manage-listscripts (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send "LISTSCRIPTS")
    (sieve-manage-parse-listscripts)))

(defun sieve-manage-havespace (name size &optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send (format "HAVESPACE \"%s\" %s" name size))
    (sieve-manage-parse-okno)))

(defun sieve-manage-putscript (name content &optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send (format "PUTSCRIPT \"%s\" {%d+}%s%s" name
                               ;; Here we assume that the coding-system will
                               ;; replace each char with a single byte.
                               ;; This is always the case if `content' is
                               ;; a unibyte string.
			       (length content)
			       sieve-manage-client-eol content))
    (sieve-manage-parse-okno)))

(defun sieve-manage-deletescript (name &optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send (format "DELETESCRIPT \"%s\"" name))
    (sieve-manage-parse-okno)))

(defun sieve-manage-getscript (name output-buffer &optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send (format "GETSCRIPT \"%s\"" name))
    (let ((script (sieve-manage-parse-string)))
      (sieve-manage-parse-crlf)
      (with-current-buffer output-buffer
	(insert script))
      (sieve-manage-parse-okno))))

(defun sieve-manage-setactive (name &optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (sieve-manage-send (format "SETACTIVE \"%s\"" name))
    (sieve-manage-parse-okno)))

;; Protocol parsing routines

(defun sieve-manage-wait-for-answer ()
  (let ((pattern "^\\(OK\\|NO\\).*\n")
        pos)
    (while (not pos)
      (setq pos (search-forward-regexp pattern nil t))
      (goto-char (point-min))
      (sleep-for 0 50))
    pos))

(defun sieve-manage-drop-next-answer ()
  (sieve-manage-wait-for-answer)
  (sieve-manage-erase))

(defun sieve-manage-ok-p (rsp)
  (string= (downcase (or (car-safe rsp) "")) "ok"))

(defun sieve-manage-is-okno ()
  (when (looking-at (concat
		     "^\\(OK\\|NO\\)\\( (\\([^)]+\\))\\)?\\( \\(.*\\)\\)?"
		     sieve-manage-server-eol))
    (let ((status (match-string 1))
	  (resp-code (match-string 3))
	  (response (match-string 5)))
      (when response
	(goto-char (match-beginning 5))
	(setq response (sieve-manage-is-string)))
      (list status resp-code response))))

(defun sieve-manage-parse-okno ()
  (let (rsp)
    (while (null rsp)
      (accept-process-output (get-buffer-process (current-buffer)) 1)
      (goto-char (point-min))
      (setq rsp (sieve-manage-is-okno)))
    (sieve-manage-erase)
    rsp))

(defun sieve-manage-parse-capability (str)
  "Parse managesieve capability string `STR'.
Set variable `sieve-manage-capability' to "
  (let ((capas (delq nil
                     (mapcar #'split-string-and-unquote
                             (split-string str "\n")))))
    (when (string= "OK" (caar (last capas)))
      (setq sieve-manage-state 'nonauth))
    capas))

(defun sieve-manage-is-string ()
  (cond ((looking-at "\"\\([^\"]+\\)\"")
	 (prog1
	     (match-string 1)
	   (goto-char (match-end 0))))
	((looking-at (concat "{\\([0-9]+\\+?\\)}" sieve-manage-server-eol))
	 (let ((pos (match-end 0))
	       (len (string-to-number (match-string 1))))
	   (if (< (point-max) (+ pos len))
	       nil
	     (goto-char (+ pos len))
	     (buffer-substring pos (+ pos len)))))))

(defun sieve-manage-parse-string ()
  (let (rsp)
    (while (null rsp)
      (accept-process-output (get-buffer-process (current-buffer)) 1)
      (goto-char (point-min))
      (setq rsp (sieve-manage-is-string)))
    (sieve-manage-erase (point))
    rsp))

(defun sieve-manage-parse-crlf ()
  (when (looking-at sieve-manage-server-eol)
    (sieve-manage-erase (match-end 0))))

(defun sieve-manage-parse-listscripts ()
  (let (tmp rsp data)
    (while (null rsp)
      (while (null (or (setq rsp (sieve-manage-is-okno))
		       (setq tmp (sieve-manage-is-string))))
	(accept-process-output (get-buffer-process (current-buffer)) 1)
	(goto-char (point-min)))
      (when tmp
	(while (not (looking-at (concat "\\( ACTIVE\\)?"
					sieve-manage-server-eol)))
	  (accept-process-output (get-buffer-process (current-buffer)) 1)
	  (goto-char (point-min)))
	(if (match-string 1)
	    (push (cons 'active tmp) data)
	  (push tmp data))
	(goto-char (match-end 0))
	(setq tmp nil)))
    (sieve-manage-erase)
    (if (sieve-manage-ok-p rsp)
	data
      rsp)))

(defun sieve-manage-send (cmdstr)
  (setq cmdstr (concat cmdstr sieve-manage-client-eol))
  (and sieve-manage-log
       (with-current-buffer (get-buffer-create sieve-manage-log)
	 (mm-enable-multibyte)
	 (buffer-disable-undo)
	 (goto-char (point-max))
	 (insert cmdstr)))
  (process-send-string sieve-manage-process cmdstr))

(provide 'sieve-manage)

;; sieve-manage.el ends here
