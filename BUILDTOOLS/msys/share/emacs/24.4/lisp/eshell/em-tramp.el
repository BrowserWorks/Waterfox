;;; em-tramp.el --- Eshell features that require TRAMP  -*- lexical-binding:t -*-

;; Copyright (C) 1999-2014 Free Software Foundation, Inc.

;; Author: Aidan Gauland <aidalgol@no8wireless.co.nz>

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

;; Eshell features that require TRAMP.

;;; Code:

(require 'esh-util)

(eval-when-compile
  (require 'esh-mode)
  (require 'eshell)
  (require 'tramp))

;;;###autoload
(progn
 (defgroup eshell-tramp nil
   "This module defines commands that use TRAMP in a way that is
  not transparent to the user.  So far, this includes only the
  built-in su and sudo commands, which are not compatible with
  the full, external su and sudo commands, and require the user
  to understand how to use the TRAMP sudo method."
   :tag "TRAMP Eshell features"
   :group 'eshell-module))

(defun eshell-tramp-initialize ()
  "Initialize the TRAMP-using commands code."
  (when (eshell-using-module 'eshell-cmpl)
    (add-hook 'pcomplete-try-first-hook
	      'eshell-complete-host-reference nil t))
  (make-local-variable 'eshell-complex-commands)
  (setq eshell-complex-commands
	(append '("su" "sudo")
		eshell-complex-commands)))

(autoload 'eshell-parse-command "esh-cmd")

(defun eshell/su (&rest args)
  "Alias \"su\" to call TRAMP.

Uses the system su through TRAMP's su method."
  (setq args (eshell-stringify-list (eshell-flatten-list args)))
  (let ((orig-args (copy-tree args)))
    (eshell-eval-using-options
     "su" args
     '((?h "help" nil nil "show this usage screen")
       (?l "login" nil login "provide a login environment")
       (?  nil nil login "provide a login environment")
       :usage "[- | -l | --login] [USER]
Become another USER during a login session.")
     (throw 'eshell-replace-command
	    (let ((user "root")
		  (host (or (file-remote-p default-directory 'host)
			    "localhost"))
		  (dir (or (file-remote-p default-directory 'localname)
			   (expand-file-name default-directory)))
		  (prefix (file-remote-p default-directory)))
	      (dolist (arg args)
		(if (string-equal arg "-") (setq login t) (setq user arg)))
	      ;; `eshell-eval-using-options' does not handle "-".
	      (if (member "-" orig-args) (setq login t))
	      (if login (setq dir "~/"))
	      (if (and prefix
		       (or
			(not (string-equal
			      "su" (file-remote-p default-directory 'method)))
			(not (string-equal
			      user (file-remote-p default-directory 'user)))))
		  (eshell-parse-command
		   "cd" (list (format "%s|su:%s@%s:%s"
				      (substring prefix 0 -1) user host dir)))
		(eshell-parse-command
		 "cd" (list (format "/su:%s@%s:%s" user host dir)))))))))

(put 'eshell/su 'eshell-no-numeric-conversions t)

(defun eshell/sudo (&rest args)
  "Alias \"sudo\" to call Tramp.

Uses the system sudo through TRAMP's sudo method."
  (setq args (eshell-stringify-list (eshell-flatten-list args)))
  (let ((orig-args (copy-tree args)))
    (eshell-eval-using-options
     "sudo" args
     '((?h "help" nil nil "show this usage screen")
       (?u "user" t user "execute a command as another USER")
       :show-usage
       :usage "[(-u | --user) USER] COMMAND
Execute a COMMAND as the superuser or another USER.")
     (throw 'eshell-external
	    (let ((user (or user "root"))
		  (host (or (file-remote-p default-directory 'host)
			    "localhost"))
		  (dir (or (file-remote-p default-directory 'localname)
			   (expand-file-name default-directory)))
		  (prefix (file-remote-p default-directory)))
	      ;; `eshell-eval-using-options' reads options of COMMAND.
	      (while (and (stringp (car orig-args))
			  (member (car orig-args) '("-u" "--user")))
		(setq orig-args (cddr orig-args)))
	      (let ((default-directory
		      (if (and prefix
			       (or
				(not
				 (string-equal
				  "sudo"
				  (file-remote-p default-directory 'method)))
				(not
				 (string-equal
				  user
				  (file-remote-p default-directory 'user)))))
			  (format "%s|sudo:%s@%s:%s"
				  (substring prefix 0 -1) user host dir)
			(format "/sudo:%s@%s:%s" user host dir))))
		(eshell-named-command (car orig-args) (cdr orig-args))))))))

(put 'eshell/sudo 'eshell-no-numeric-conversions t)

(provide 'em-tramp)

;; Local Variables:
;; generated-autoload-file: "esh-groups.el"
;; End:

;;; em-tramp.el ends here
