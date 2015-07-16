;;; pop3.el --- Post Office Protocol (RFC 1460) interface

;; Copyright (C) 1996-2014 Free Software Foundation, Inc.

;; Author: Richard L. Pieri <ratinox@peorth.gweep.net>
;; Maintainer: emacs-devel@gnu.org
;; Keywords: mail

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

;; Most of the standard Post Office Protocol version 3 (RFC 1460) commands
;; are implemented.  The LIST command has not been implemented due to lack
;; of actual usefulness.
;; The optional POP3 command TOP has not been implemented.

;; This program was inspired by Kyle E. Jones's vm-pop program.

;;; Code:

(eval-when-compile (require 'cl))

(eval-and-compile
  ;; In Emacs 24, `open-protocol-stream' is an autoloaded alias for
  ;; `make-network-stream'.
  (unless (fboundp 'open-protocol-stream)
    (require 'proto-stream)))

(require 'mail-utils)
(defvar parse-time-months)

(defgroup pop3 nil
  "Post Office Protocol."
  :group 'mail
  :group 'mail-source)

(defcustom pop3-maildrop (or (user-login-name)
			     (getenv "LOGNAME")
			     (getenv "USER"))
  "*POP3 maildrop."
  :version "22.1" ;; Oort Gnus
  :type 'string
  :group 'pop3)

(defcustom pop3-mailhost (or (getenv "MAILHOST") ;; nil -> mismatch
			     "pop3")
  "*POP3 mailhost."
  :version "22.1" ;; Oort Gnus
  :type 'string
  :group 'pop3)

(defcustom pop3-port 110
  "*POP3 port."
  :version "22.1" ;; Oort Gnus
  :type 'number
  :group 'pop3)

(defcustom pop3-password-required t
  "*Non-nil if a password is required when connecting to POP server."
  :version "22.1" ;; Oort Gnus
  :type 'boolean
  :group 'pop3)

;; Should this be customizable?
(defvar pop3-password nil
  "*Password to use when connecting to POP server.")

(defcustom pop3-authentication-scheme 'pass
  "*POP3 authentication scheme.
Defaults to `pass', for the standard USER/PASS authentication.  The other
valid value is 'apop'."
  :type '(choice (const :tag "Normal user/password" pass)
		 (const :tag "APOP" apop))
  :version "22.1" ;; Oort Gnus
  :group 'pop3)

(defcustom pop3-stream-length 100
  "How many messages should be requested at one time.
The lower the number, the more latency-sensitive the fetching
will be.  If your pop3 server doesn't support streaming at all,
set this to 1."
  :type 'number
  :version "24.1"
  :group 'pop3)

(defcustom pop3-leave-mail-on-server nil
  "Non-nil if the mail is to be left on the POP server after fetching.
Mails once fetched will never be fetched again by the UIDL control.

If this is neither nil nor a number, all mails will be left on the
server.  If this is a number, leave mails on the server for this many
days since you first checked new mails.  If this is nil, mails will be
deleted on the server right after fetching.

Gnus users should use the `:leave' keyword in a mail source to direct
the behavior per server, rather than directly modifying this value.

Note that POP servers maintain no state information between sessions,
so what the client believes is there and what is actually there may
not match up.  If they do not, then you may get duplicate mails or
the whole thing can fall apart and leave you with a corrupt mailbox."
  :version "24.4"
  :type '(choice (const :tag "Don't leave mails" nil)
		 (const :tag "Leave all mails" t)
		 (number :tag "Leave mails for this many days" :value 14))
  :group 'pop3)

(defcustom pop3-uidl-file "~/.pop3-uidl"
  "File used to save UIDL."
  :version "24.4"
  :type 'file
  :group 'pop3)

(defcustom pop3-uidl-file-backup '(0 9)
  "How to backup the UIDL file `pop3-uidl-file' when updating.
If it is a list of numbers, the first one binds `kept-old-versions' and
the other binds `kept-new-versions' to keep number of oldest and newest
versions.  Otherwise, the value binds `version-control' (which see).

Note: Backup will take place whenever you check new mails on a server.
So, you may lose the backup files having been saved before a trouble
if you set it so as to make too few backups whereas you have access to
many servers."
  :version "24.4"
  :type '(choice (group :tag "Keep versions" :format "\n%v" :indent 3
			(number :tag "oldest")
			(number :tag "newest"))
		 (sexp :format "%v"
		       :match (lambda (widget value)
				(condition-case nil
				    (not (and (numberp (car value))
					      (numberp (car (cdr value)))))
				  (error t)))))
  :group 'pop3)

(defvar pop3-timestamp nil
  "Timestamp returned when initially connected to the POP server.
Used for APOP authentication.")

(defvar pop3-read-point nil)
(defvar pop3-debug nil)

;; Borrowed from nnheader-accept-process-output in nnheader.el.  See the
;; comments there for explanations about the values.

(eval-and-compile
  (if (and (fboundp 'nnheader-accept-process-output)
	   (boundp 'nnheader-read-timeout))
      (defalias 'pop3-accept-process-output 'nnheader-accept-process-output)
    ;; Borrowed from `nnheader.el':
    (defvar pop3-read-timeout
      (if (string-match "windows-nt\\|os/2\\|cygwin"
			(symbol-name system-type))
	  1.0
	0.01)
      "How long pop3 should wait between checking for the end of output.
Shorter values mean quicker response, but are more CPU intensive.")
    (defun pop3-accept-process-output (process)
      (accept-process-output
       process
       (truncate pop3-read-timeout)
       (truncate (* (- pop3-read-timeout
		       (truncate pop3-read-timeout))
		    1000))))))

(defvar pop3-uidl)
;; List of UIDLs of existing messages at present in the server:
;; ("UIDL1" "UIDL2" "UIDL3"...)

(defvar pop3-uidl-saved)
;; Locally saved UIDL data; an alist of the server, the user, and the UIDL
;; and timestamp pairs:
;; (("SERVER_A" ("USER_A1" "UIDL1" TIMESTAMP1 "UIDL2" TIMESTAMP2...)
;;              ("USER_A2" "UIDL1" TIMESTAMP1 "UIDL2" TIMESTAMP2...)
;;              ...)
;;  ("SERVER_B" ("USER_B1" "UIDL1" TIMESTAMP1 "UIDL2" TIMESTAMP2...)
;;              ("USER_B2" "UIDL1" TIMESTAMP1 "UIDL2" TIMESTAMP2...)
;;              ...))
;; Where TIMESTAMP is the most significant two digits of an Emacs time,
;; i.e. the return value of `current-time'.

;;;###autoload
(defun pop3-movemail (file)
  "Transfer contents of a maildrop to the specified FILE.
Use streaming commands."
  (let ((process (pop3-open-server pop3-mailhost pop3-port))
	messages total-size
	pop3-uidl
	pop3-uidl-saved)
    (pop3-logon process)
    (if pop3-leave-mail-on-server
	(setq messages (pop3-uidl-stat process)
	      total-size (cadr messages)
	      messages (car messages))
      (let ((size (pop3-stat process)))
	(dotimes (i (car size)) (push (1+ i) messages))
	(setq messages (nreverse messages)
	      total-size (cadr size))))
    (when messages
      (with-current-buffer (process-buffer process)
	(pop3-send-streaming-command process "RETR" messages total-size)
	(pop3-write-to-file file messages)
	(unless pop3-leave-mail-on-server
	  (pop3-send-streaming-command process "DELE" messages nil))))
    (if pop3-leave-mail-on-server
	(when (prog1 (pop3-uidl-dele process) (pop3-quit process))
	  (pop3-uidl-save))
      (pop3-quit process)
      ;; Remove UIDL data for the account that got not to leave mails.
      (setq pop3-uidl-saved (pop3-uidl-load))
      (let ((elt (assoc pop3-maildrop
			(cdr (assoc pop3-mailhost pop3-uidl-saved)))))
	(when elt
	  (setcdr elt nil)
	  (pop3-uidl-save))))
    t))

(defun pop3-send-streaming-command (process command messages total-size)
  (erase-buffer)
  (let ((count (length messages))
	(i 1)
	(start-point (point-min))
	(waited-for 0))
    (while messages
      (process-send-string process (format "%s %d\r\n" command (pop messages)))
      ;; Only do 100 messages at a time to avoid pipe stalls.
      (when (zerop (% i pop3-stream-length))
	(setq start-point
	      (pop3-wait-for-messages process pop3-stream-length
				      total-size start-point))
	(incf waited-for pop3-stream-length))
      (incf i))
    (pop3-wait-for-messages process (- count waited-for)
			    total-size start-point)))

(defun pop3-wait-for-messages (process count total-size start-point)
  (while (> count 0)
    (goto-char start-point)
    (while (or (and (re-search-forward "^\\+OK" nil t)
		    (or (not total-size)
			(re-search-forward "^\\.\r?\n" nil t)))
	       (re-search-forward "^-ERR " nil t))
      (decf count)
      (setq start-point (point)))
    (unless (memq (process-status process) '(open run))
      (error "pop3 process died"))
    (when total-size
      (let ((size 0))
	(goto-char (point-min))
	(while (re-search-forward "^\\+OK.*\n" nil t)
	  (setq size (+ size (- (point))
			(if (re-search-forward "^\\.\r?\n" nil 'move)
			    (match-beginning 0)
			  (point)))))
	(message "pop3 retrieved %dKB (%d%%)"
		 (truncate (/ size 1000))
		 (truncate (* (/ (* size 1.0) total-size) 100)))))
    (pop3-accept-process-output process))
  start-point)

(defun pop3-write-to-file (file messages)
  (let ((pop-buffer (current-buffer))
	(start (point-min))
	beg end
	temp-buffer)
    (with-temp-buffer
      (setq temp-buffer (current-buffer))
      (with-current-buffer pop-buffer
	(goto-char (point-min))
	(while (re-search-forward "^\\+OK" nil t)
	  (forward-line 1)
	  (setq beg (point))
	  (when (re-search-forward "^\\.\r?\n" nil t)
	    (setq start (point))
	    (forward-line -1)
	    (setq end (point)))
	  (with-current-buffer temp-buffer
	    (goto-char (point-max))
	    (let ((hstart (point)))
	      (insert-buffer-substring pop-buffer beg end)
	      (pop3-clean-region hstart (point))
	      (goto-char (point-max))
	      (pop3-munge-message-separator hstart (point))
	      (when pop3-leave-mail-on-server
		(pop3-uidl-add-xheader hstart (pop messages)))
	      (goto-char (point-max))))))
      (let ((coding-system-for-write 'binary))
	(goto-char (point-min))
	;; Check whether something inserted a newline at the start and
	;; delete it.
	(when (eolp)
	  (delete-char 1))
	(write-region (point-min) (point-max) file nil 'nomesg)))))

(defun pop3-logon (process)
  (let ((pop3-password pop3-password))
    ;; for debugging only
    (if pop3-debug (switch-to-buffer (process-buffer process)))
    ;; query for password
    (if (and pop3-password-required (not pop3-password))
	(setq pop3-password
	      (read-passwd (format "Password for %s: " pop3-maildrop))))
    (cond ((equal 'apop pop3-authentication-scheme)
	   (pop3-apop process pop3-maildrop))
	  ((equal 'pass pop3-authentication-scheme)
	   (pop3-user process pop3-maildrop)
	   (pop3-pass process))
	  (t (error "Invalid POP3 authentication scheme")))))

(defun pop3-get-message-count ()
  "Return the number of messages in the maildrop."
  (let* ((process (pop3-open-server pop3-mailhost pop3-port))
	 message-count
	 (pop3-password pop3-password))
    ;; for debugging only
    (if pop3-debug (switch-to-buffer (process-buffer process)))
    ;; query for password
    (if (and pop3-password-required (not pop3-password))
	(setq pop3-password
	      (read-passwd (format "Password for %s: " pop3-maildrop))))
    (cond ((equal 'apop pop3-authentication-scheme)
	   (pop3-apop process pop3-maildrop))
	  ((equal 'pass pop3-authentication-scheme)
	   (pop3-user process pop3-maildrop)
	   (pop3-pass process))
	  (t (error "Invalid POP3 authentication scheme")))
    (setq message-count (car (pop3-stat process)))
    (pop3-quit process)
    message-count))

(defun pop3-uidl-stat (process)
  "Return a list of unread message numbers and total size."
  (pop3-send-command process "UIDL")
  (let (err messages size)
    (if (condition-case code
	    (progn
	      (pop3-read-response process)
	      t)
	  (error (setq err (error-message-string code))
		 nil))
	(let ((start pop3-read-point)
	      saved list)
	  (with-current-buffer (process-buffer process)
	    (while (not (re-search-forward "^\\.\r\n" nil t))
	      (unless (memq (process-status process) '(open run))
		(error "pop3 server closed the connection"))
	      (pop3-accept-process-output process)
	      (goto-char start))
	    (setq pop3-read-point (point-marker)
		  pop3-uidl nil)
	    (while (progn (forward-line -1) (>= (point) start))
	      (when (looking-at "[0-9]+ \\([^\n\r ]+\\)")
		(push (match-string 1) pop3-uidl)))
	    (when pop3-uidl
	      (setq pop3-uidl-saved (pop3-uidl-load)
		    saved (cdr (assoc pop3-maildrop
				      (cdr (assoc pop3-mailhost
						  pop3-uidl-saved)))))
	      (let ((i (length pop3-uidl)))
		(while (> i 0)
		  (unless (member (nth (1- i) pop3-uidl) saved)
		    (push i messages))
		  (decf i)))
	      (when messages
		(setq list (pop3-list process)
		      size 0)
		(dolist (msg messages)
		  (setq size (+ size (cdr (assq msg list)))))
		(list messages size)))))
      (message "%s doesn't support UIDL (%s), so we try a regressive way..."
	       pop3-mailhost err)
      (sit-for 1)
      (setq size (pop3-stat process))
      (dotimes (i (car size)) (push (1+ i) messages))
      (setcar size (nreverse messages))
      size)))

(defun pop3-uidl-dele (process)
  "Delete messages according to `pop3-leave-mail-on-server'.
Return non-nil if it is necessary to update the local UIDL file."
  (let* ((ctime (current-time))
	 (srvr (assoc pop3-mailhost pop3-uidl-saved))
	 (saved (assoc pop3-maildrop (cdr srvr)))
	 i uidl mod new tstamp dele)
    (setcdr (cdr ctime) nil)
    ;; Add new messages to the data to be saved.
    (cond ((and pop3-uidl saved)
	   (setq i (1- (length pop3-uidl)))
	   (while (>= i 0)
	     (unless (member (setq uidl (nth i pop3-uidl)) (cdr saved))
	       (push ctime new)
	       (push uidl new))
	     (decf i)))
	  (pop3-uidl
	   (setq new (apply 'nconc (mapcar (lambda (elt) (list elt ctime))
					   pop3-uidl)))))
    (when new (setq mod t))
    ;; List expirable messages and delete them from the data to be saved.
    (setq ctime (when (numberp pop3-leave-mail-on-server)
		  (/ (+ (* (car ctime) 65536.0) (cadr ctime)) 86400))
	  i (1- (length saved)))
    (while (> i 0)
      (if (member (setq uidl (nth (1- i) saved)) pop3-uidl)
	  (progn
	    (setq tstamp (nth i saved))
	    (if (and ctime
		     (> (- ctime (/ (+ (* (car tstamp) 65536.0) (cadr tstamp))
				    86400))
			pop3-leave-mail-on-server))
		;; Mails to delete.
		(progn
		  (setq mod t)
		  (push uidl dele))
	      ;; Mails to keep.
	      (push tstamp new)
	      (push uidl new)))
	;; Mails having been deleted in the server.
	(setq mod t))
      (decf i 2))
    (cond (saved
	   (setcdr saved new))
	  (srvr
	   (setcdr (last srvr) (list (cons pop3-maildrop new))))
	  (t
	   (add-to-list 'pop3-uidl-saved
			(list pop3-mailhost (cons pop3-maildrop new))
			t)))
    ;; Actually delete the messages in the server.
    (when dele
      (setq uidl nil
	    i (length pop3-uidl))
      (while (> i 0)
	(when (member (nth (1- i) pop3-uidl) dele)
	  (push i uidl))
	(decf i))
      (when uidl
	(pop3-send-streaming-command process "DELE" uidl nil)))
    mod))

(defun pop3-uidl-load ()
  "Load saved UIDL."
  (when (file-exists-p pop3-uidl-file)
    (with-temp-buffer
      (condition-case code
	  (progn
	    (insert-file-contents pop3-uidl-file)
	    (goto-char (point-min))
	    (read (current-buffer)))
	(error
	 (message "Error while loading %s (%s)"
		  pop3-uidl-file (error-message-string code))
	 (sit-for 1)
	 nil)))))

(defun pop3-uidl-save ()
  "Save UIDL."
  (with-temp-buffer
    (if pop3-uidl-saved
	(progn
	  (insert "(")
	  (dolist (srvr pop3-uidl-saved)
	    (when (cdr srvr)
	      (insert "(\"" (pop srvr) "\"\n  ")
	      (dolist (elt srvr)
		(when (cdr elt)
		  (insert "(\"" (pop elt) "\"\n   ")
		  (while elt
		    (insert (format "\"%s\" %s\n   " (pop elt) (pop elt))))
		  (delete-char -4)
		  (insert ")\n  ")))
	      (delete-char -3)
	      (if (eq (char-before) ?\))
		  (insert ")\n ")
		(goto-char (1+ (point-at-bol)))
		(delete-region (point) (point-max)))))
	  (when (eq (char-before) ? )
	    (delete-char -2))
	  (insert ")\n"))
      (insert "()\n"))
    (let ((buffer-file-name pop3-uidl-file)
	  (delete-old-versions t)
	  (kept-new-versions kept-new-versions)
	  (kept-old-versions kept-old-versions)
	  (version-control version-control))
      (if (consp pop3-uidl-file-backup)
	  (setq kept-new-versions (cadr pop3-uidl-file-backup)
		kept-old-versions (car pop3-uidl-file-backup)
		version-control t)
	(setq version-control pop3-uidl-file-backup))
      (save-buffer))))

(defun pop3-uidl-add-xheader (start msgno)
  "Add X-UIDL header."
  (let ((case-fold-search t))
    (save-restriction
      (narrow-to-region start (progn
				(goto-char start)
				(search-forward "\n\n" nil 'move)
				(1- (point))))
      (goto-char start)
      (while (re-search-forward "^x-uidl:" nil t)
	(while (progn
		 (forward-line 1)
		 (memq (char-after) '(?\t ? ))))
	(delete-region (match-beginning 0) (point)))
      (goto-char (point-max))
      (insert "X-UIDL: " (nth (1- msgno) pop3-uidl) "\n"))))

(defcustom pop3-stream-type nil
  "*Transport security type for POP3 connections.
This may be either nil (plain connection), `ssl' (use an
SSL/TSL-secured stream) or `starttls' (use the starttls mechanism
to turn on TLS security after opening the stream).  However, if
this is nil, `ssl' is assumed for connections to port
995 (pop3s)."
  :version "23.1" ;; No Gnus
  :group 'pop3
  :type '(choice (const :tag "Plain" nil)
		 (const :tag "SSL/TLS" ssl)
		 (const starttls)))

(eval-and-compile
  (if (fboundp 'set-process-query-on-exit-flag)
      (defalias 'pop3-set-process-query-on-exit-flag
	'set-process-query-on-exit-flag)
    (defalias 'pop3-set-process-query-on-exit-flag
      'process-kill-without-query)))

(defun pop3-open-server (mailhost port)
  "Open TCP connection to MAILHOST on PORT.
Returns the process associated with the connection."
  (let ((coding-system-for-read 'binary)
	(coding-system-for-write 'binary)
	result)
    (with-current-buffer
        (get-buffer-create (concat " trace of POP session to "
                                   mailhost))
      (erase-buffer)
      (setq pop3-read-point (point-min))
      (setq result
	    (open-protocol-stream
	     "POP" (current-buffer) mailhost port
	     :type (cond
		    ((or (eq pop3-stream-type 'ssl)
			 (and (not pop3-stream-type)
			      (member port '(995 "pop3s"))))
		     'tls)
		    (t
		     (or pop3-stream-type 'network)))
	     :capability-command "CAPA\r\n"
	     :end-of-command "^\\(-ERR\\|+OK\\).*\n"
	     :end-of-capability "^\\.\r?\n\\|^-ERR"
	     :success "^\\+OK.*\n"
	     :return-list t
	     :starttls-function
	     (lambda (capabilities)
	       (and (string-match "\\bSTLS\\b" capabilities)
		    "STLS\r\n"))))
      (when result
	(let ((response (plist-get (cdr result) :greeting)))
	  (setq pop3-timestamp
		(substring response (or (string-match "<" response) 0)
			   (+ 1 (or (string-match ">" response) -1)))))
	(pop3-set-process-query-on-exit-flag (car result) nil)
	(erase-buffer)
	(car result)))))

;; Support functions

(defun pop3-send-command (process command)
  (set-buffer (process-buffer process))
  (goto-char (point-max))
  ;; (if (= (aref command 0) ?P)
  ;;     (insert "PASS <omitted>\r\n")
  ;;   (insert command "\r\n"))
  (setq pop3-read-point (point))
  (goto-char (point-max))
  (process-send-string process (concat command "\r\n")))

(defun pop3-read-response (process &optional return)
  "Read the response from the server.
Return the response string if optional second argument is non-nil."
  (let ((case-fold-search nil)
	match-end)
    (with-current-buffer (process-buffer process)
      (goto-char pop3-read-point)
      (while (and (memq (process-status process) '(open run))
		  (not (search-forward "\r\n" nil t)))
	(pop3-accept-process-output process)
	(goto-char pop3-read-point))
      (setq match-end (point))
      (goto-char pop3-read-point)
      (if (looking-at "-ERR")
	  (error "%s" (buffer-substring (point) (- match-end 2)))
	(if (not (looking-at "+OK"))
	    (progn (setq pop3-read-point match-end) nil)
	  (setq pop3-read-point match-end)
	  (if return
	      (buffer-substring (point) match-end)
	    t)
	  )))))

(defun pop3-clean-region (start end)
  (setq end (set-marker (make-marker) end))
  (save-excursion
    (goto-char start)
    (while (and (< (point) end) (search-forward "\r\n" end t))
      (replace-match "\n" t t))
    (goto-char start)
    (while (and (< (point) end) (re-search-forward "^\\." end t))
      (replace-match "" t t)
      (forward-char)))
  (set-marker end nil))

;; Copied from message-make-date.
(defun pop3-make-date (&optional now)
  "Make a valid date header.
If NOW, use that time instead."
  (require 'parse-time)
  (let* ((now (or now (current-time)))
	 (zone (nth 8 (decode-time now)))
	 (sign "+"))
    (when (< zone 0)
      (setq sign "-")
      (setq zone (- zone)))
    (concat
     (format-time-string "%d" now)
     ;; The month name of the %b spec is locale-specific.  Pfff.
     (format " %s "
	     (capitalize (car (rassoc (nth 4 (decode-time now))
				      parse-time-months))))
     (format-time-string "%Y %H:%M:%S " now)
     ;; We do all of this because XEmacs doesn't have the %z spec.
     (format "%s%02d%02d" sign (/ zone 3600) (/ (% zone 3600) 60)))))

(defun pop3-munge-message-separator (start end)
  "Check to see if a message separator exists.  If not, generate one."
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (if (not (or (looking-at "From .?") ; Unix mail
		   (looking-at "\001\001\001\001\n") ; MMDF
		   (looking-at "BABYL OPTIONS:") ; Babyl
		   ))
	  (let* ((from (mail-strip-quoted-names (mail-fetch-field "From")))
		 (tdate (mail-fetch-field "Date"))
		 (date (split-string (or (and tdate
					      (not (string= "" tdate))
					      tdate)
					 (pop3-make-date))
				     " "))
		 (From_))
	    ;; sample date formats I have seen
	    ;; Date: Tue, 9 Jul 1996 09:04:21 -0400 (EDT)
	    ;; Date: 08 Jul 1996 23:22:24 -0400
	    ;; should be
	    ;; Tue Jul 9 09:04:21 1996

	    ;; Fixme: This should use timezone on the date field contents.
	    (setq date
		  (cond ((not date)
			 "Tue Jan 1 00:00:0 1900")
			((string-match "[A-Z]" (nth 0 date))
			 (format "%s %s %s %s %s"
				 (nth 0 date) (nth 2 date) (nth 1 date)
				 (nth 4 date) (nth 3 date)))
			(t
			 ;; this really needs to be better but I don't feel
			 ;; like writing a date to day converter.
			 (format "Sun %s %s %s %s"
				 (nth 1 date) (nth 0 date)
				 (nth 3 date) (nth 2 date)))
			))
	    (setq From_ (format "\nFrom %s  %s\n" from date))
	    (while (string-match "," From_)
	      (setq From_ (concat (substring From_ 0 (match-beginning 0))
				  (substring From_ (match-end 0)))))
	    (goto-char (point-min))
	    (insert From_)
	    (if (search-forward "\n\n" nil t)
		nil
	      (goto-char (point-max))
	      (insert "\n"))
	    (let ((size (- (point-max) (point))))
	      (forward-line -1)
	      (insert (format "Content-Length: %s\n" size)))
	    )))))

;; The Command Set

;; AUTHORIZATION STATE

(defun pop3-user (process user)
  "Send USER information to POP3 server."
  (pop3-send-command process (format "USER %s" user))
  (let ((response (pop3-read-response process t)))
    (if (not (and response (string-match "+OK" response)))
	(error "USER %s not valid" user))))

(defun pop3-pass (process)
  "Send authentication information to the server."
  (pop3-send-command process (format "PASS %s" pop3-password))
  (let ((response (pop3-read-response process t)))
    (if (not (and response (string-match "+OK" response)))
	(pop3-quit process))))

(defun pop3-apop (process user)
  "Send alternate authentication information to the server."
  (let ((pass pop3-password))
    (if (and pop3-password-required (not pass))
	(setq pass
	      (read-passwd (format "Password for %s: " pop3-maildrop))))
    (if pass
	(let ((hash (md5 (concat pop3-timestamp pass) nil nil 'binary)))
	  (pop3-send-command process (format "APOP %s %s" user hash))
	  (let ((response (pop3-read-response process t)))
	    (if (not (and response (string-match "+OK" response)))
		(pop3-quit process)))))
    ))

;; TRANSACTION STATE

(defun pop3-stat (process)
  "Return the number of messages in the maildrop and the maildrop's size."
  (pop3-send-command process "STAT")
  (let ((response (pop3-read-response process t)))
    (list (string-to-number (nth 1 (split-string response " ")))
	  (string-to-number (nth 2 (split-string response " "))))
    ))

(defun pop3-list (process &optional msg)
  "If MSG is nil, return an alist of (MESSAGE-ID . SIZE) pairs.
Otherwise, return the size of the message-id MSG"
  (pop3-send-command process (if msg
				 (format "LIST %d" msg)
			       "LIST"))
  (let ((response (pop3-read-response process t)))
    (if msg
	(string-to-number (nth 2 (split-string response " ")))
      (let ((start pop3-read-point) end)
	(with-current-buffer (process-buffer process)
	  (while (not (re-search-forward "^\\.\r\n" nil t))
	    (pop3-accept-process-output process)
	    (goto-char start))
	  (setq pop3-read-point (point-marker))
	  (goto-char (match-beginning 0))
	  (setq end (point-marker))
	  (mapcar #'(lambda (s) (let ((split (split-string s " ")))
				  (cons (string-to-number (nth 0 split))
					(string-to-number (nth 1 split)))))
		  (split-string (buffer-substring start end) "\r\n" t)))))))

(defun pop3-retr (process msg crashbuf)
  "Retrieve message-id MSG to buffer CRASHBUF."
  (pop3-send-command process (format "RETR %s" msg))
  (pop3-read-response process)
  (let ((start pop3-read-point) end)
    (with-current-buffer (process-buffer process)
      (while (not (re-search-forward "^\\.\r\n" nil t))
	(unless (memq (process-status process) '(open run))
	  (error "pop3 server closed the connection"))
	(pop3-accept-process-output process)
	(goto-char start))
      (setq pop3-read-point (point-marker))
      ;; this code does not seem to work for some POP servers...
      ;; and I cannot figure out why not.
      ;;      (goto-char (match-beginning 0))
      ;;      (backward-char 2)
      ;;      (if (not (looking-at "\r\n"))
      ;;	  (insert "\r\n"))
      ;;      (re-search-forward "\\.\r\n")
      (goto-char (match-beginning 0))
      (setq end (point-marker))
      (pop3-clean-region start end)
      (pop3-munge-message-separator start end)
      (with-current-buffer crashbuf
	(erase-buffer))
      (copy-to-buffer crashbuf start end)
      (delete-region start end)
      )))

(defun pop3-dele (process msg)
  "Mark message-id MSG as deleted."
  (pop3-send-command process (format "DELE %s" msg))
  (pop3-read-response process))

(defun pop3-noop (process msg)
  "No-operation."
  (pop3-send-command process "NOOP")
  (pop3-read-response process))

(defun pop3-last (process)
  "Return highest accessed message-id number for the session."
  (pop3-send-command process "LAST")
  (let ((response (pop3-read-response process t)))
    (string-to-number (nth 1 (split-string response " ")))
    ))

(defun pop3-rset (process)
  "Remove all delete marks from current maildrop."
  (pop3-send-command process "RSET")
  (pop3-read-response process))

;; UPDATE

(defun pop3-quit (process)
  "Close connection to POP3 server.
Tell server to remove all messages marked as deleted, unlock the maildrop,
and close the connection."
  (pop3-send-command process "QUIT")
  (pop3-read-response process t)
  (if process
      (with-current-buffer (process-buffer process)
	(goto-char (point-max))
	(delete-process process))))

;; Summary of POP3 (Post Office Protocol version 3) commands and responses

;;; AUTHORIZATION STATE

;; Initial TCP connection
;; Arguments: none
;; Restrictions: none
;; Possible responses:
;;  +OK [POP3 server ready]

;; USER name
;; Arguments: a server specific user-id (required)
;; Restrictions: authorization state [after unsuccessful USER or PASS
;; Possible responses:
;;  +OK [valid user-id]
;;  -ERR [invalid user-id]

;; PASS string
;; Arguments: a server/user-id specific password (required)
;; Restrictions: authorization state, after successful USER
;; Possible responses:
;;  +OK [maildrop locked and ready]
;;  -ERR [invalid password]
;;  -ERR [unable to lock maildrop]

;; STLS      (RFC 2595)
;; Arguments: none
;; Restrictions: Only permitted in AUTHORIZATION state.
;; Possible responses:
;;  +OK
;;  -ERR

;;; TRANSACTION STATE

;; STAT
;; Arguments: none
;; Restrictions: transaction state
;; Possible responses:
;;  +OK nn mm [# of messages, size of maildrop]

;; LIST [msg]
;; Arguments: a message-id (optional)
;; Restrictions: transaction state; msg must not be deleted
;; Possible responses:
;;  +OK [scan listing follows]
;;  -ERR [no such message]

;; RETR msg
;; Arguments: a message-id (required)
;; Restrictions: transaction state; msg must not be deleted
;; Possible responses:
;;  +OK [message contents follow]
;;  -ERR [no such message]

;; DELE msg
;; Arguments: a message-id (required)
;; Restrictions: transaction state; msg must not be deleted
;; Possible responses:
;;  +OK [message deleted]
;;  -ERR [no such message]

;; NOOP
;; Arguments: none
;; Restrictions: transaction state
;; Possible responses:
;;  +OK

;; LAST
;; Arguments: none
;; Restrictions: transaction state
;; Possible responses:
;;  +OK nn [highest numbered message accessed]

;; RSET
;; Arguments: none
;; Restrictions: transaction state
;; Possible responses:
;;  +OK [all delete marks removed]

;; UIDL [msg]
;; Arguments: a message-id (optional)
;; Restrictions: transaction state; msg must not be deleted
;; Possible responses:
;;  +OK [uidl listing follows]
;;  -ERR [no such message]

;;; UPDATE STATE

;; QUIT
;; Arguments: none
;; Restrictions: none
;; Possible responses:
;;  +OK [TCP connection closed]

(provide 'pop3)

;;; pop3.el ends here
