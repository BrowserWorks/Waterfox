;;; mm-archive.el --- Functions for parsing archive files as MIME

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Lars Magne Ingebrigtsen <larsi@gnus.org>
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

;;; Code:

(require 'mm-decode)
(eval-when-compile
  (autoload 'gnus-recursive-directory-files "gnus-util")
  (autoload 'mailcap-extension-to-mime "mailcap"))

(defvar mm-archive-decoders
  '(("application/ms-tnef" t "tnef" "-f" "-" "-C")
    ("application/zip" nil "unzip" "-j" "-x" "%f" "-d")
    ("application/x-gtar-compressed" nil "tar" "xzf" "-" "-C")
    ("application/x-tar" nil "tar" "xf" "-" "-C")))

(defun mm-archive-decoders () mm-archive-decoders)

(defun mm-dissect-archive (handle)
  (let ((decoder (cddr (assoc (car (mm-handle-type handle))
			      mm-archive-decoders)))
	(dir (mm-make-temp-file
	      (expand-file-name "emm." mm-tmp-directory) 'dir)))
    (set-file-modes dir #o700)
    (unwind-protect
	(progn
	  (mm-with-unibyte-buffer
	    (mm-insert-part handle)
	    (if (member "%f" decoder)
		(let ((file (expand-file-name "mail.zip" dir)))
		  (write-region (point-min) (point-max) file nil 'silent)
		  (setq decoder (copy-sequence decoder))
		  (setcar (member "%f" decoder) file)
		  (apply 'call-process (car decoder) nil nil nil
			 (append (cdr decoder) (list dir)))
		  (delete-file file))
	      (apply 'call-process-region (point-min) (point-max) (car decoder)
		     nil (get-buffer-create "*tnef*")
		     nil (append (cdr decoder) (list dir)))))
	  `("multipart/mixed"
	    ,handle
	    ,@(mm-archive-list-files (gnus-recursive-directory-files dir))))
      (delete-directory dir t))))

(defun mm-archive-list-files (files)
  (let ((handles nil)
	type disposition)
    (dolist (file files)
      (with-temp-buffer
	(when (string-match "\\.\\([^.]+\\)$" file)
	  (setq type (mailcap-extension-to-mime (match-string 1 file))))
	(unless type
	  (setq type "application/octet-stream"))
	(setq disposition
	      (if (string-match "^image/\\|^text/" type)
		  "inline"
		"attachment"))
	(insert (format "Content-type: %s\n" type))
	(insert "Content-Transfer-Encoding: 8bit\n\n")
	(insert-file-contents file)
	(push
	 (mm-make-handle (mm-copy-to-buffer)
			 (list type)
			 '8bit nil
			 `(,disposition (filename . ,file))
			 nil nil nil)
	 handles)))
    handles))

(defun mm-archive-dissect-and-inline (handle)
  (let ((start (point-marker)))
    (save-restriction
      (narrow-to-region (point) (point))
      (dolist (handle (cddr (mm-dissect-archive handle)))
	(goto-char (point-max))
	(mm-display-inline handle))
      (goto-char (point-max))
      (mm-handle-set-undisplayer
       handle
       `(lambda ()
	  (let ((inhibit-read-only t)
		(end ,(point-marker)))
	    (remove-images ,start end)
	    (delete-region ,start end)))))))

(provide 'mm-archive)

;; mm-archive.el ends here
