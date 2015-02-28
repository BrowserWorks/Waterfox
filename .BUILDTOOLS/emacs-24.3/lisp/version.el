;;; version.el --- record version number of Emacs

;; Copyright (C) 1985, 1992, 1994-1995, 1999-2013 Free Software
;; Foundation, Inc.

;; Maintainer: FSF
;; Keywords: internal
;; Package: emacs

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

(defconst emacs-major-version
  (progn (string-match "^[0-9]+" emacs-version)
         (string-to-number (match-string 0 emacs-version)))
  "Major version number of this version of Emacs.
This variable first existed in version 19.23.")

(defconst emacs-minor-version
  (progn (string-match "^[0-9]+\\.\\([0-9]+\\)" emacs-version)
         (string-to-number (match-string 1 emacs-version)))
  "Minor version number of this version of Emacs.
This variable first existed in version 19.23.")

(defconst emacs-build-time (current-time)
  "Time at which Emacs was dumped out.")

(defconst emacs-build-system (system-name)
  "Name of the system on which Emacs was built.")

(defvar motif-version-string)
(defvar gtk-version-string)
(defvar ns-version-string)

(defun emacs-version (&optional here)
  "Return string describing the version of Emacs that is running.
If optional argument HERE is non-nil, insert string at point.
Don't use this function in programs to choose actions according
to the system configuration; look at `system-configuration' instead."
  (interactive "P")
  (let ((version-string
         (format (if (not (called-interactively-p 'interactive))
		     "GNU Emacs %s (%s%s%s)\n of %s on %s"
		   "GNU Emacs %s (%s%s%s) of %s on %s")
                 emacs-version
		 system-configuration
		 (cond ((featurep 'motif)
			(concat ", " (substring motif-version-string 4)))
		       ((featurep 'gtk)
			(concat ", GTK+ Version " gtk-version-string))
		       ((featurep 'x-toolkit) ", X toolkit")
		       ((featurep 'ns)
			(format ", NS %s" ns-version-string))
		       (t ""))
		 (if (and (boundp 'x-toolkit-scroll-bars)
			  (memq x-toolkit-scroll-bars '(xaw xaw3d)))
		     (format ", %s scroll bars"
			     (capitalize (symbol-name x-toolkit-scroll-bars)))
		   "")
		 (format-time-string "%Y-%m-%d" emacs-build-time)
                 emacs-build-system)))
    (if here
        (insert version-string)
      (if (called-interactively-p 'interactive)
          (message "%s" version-string)
        version-string))))

;; We hope that this alias is easier for people to find.
(defalias 'version 'emacs-version)

;; Set during dumping, this is a defvar so that it can be setq'd.
(defvar emacs-bzr-version nil
  "String giving the bzr revision from which this Emacs was built.
The format is: [revno] revision_id, where revno may be absent.
Value is nil if Emacs was not built from a bzr checkout, or if we could
not determine the revision.")

(defun emacs-bzr-version-dirstate (dir)
  "Try to return as a string the bzr revision ID of directory DIR.
This uses the dirstate file's parent revision entry.
Returns nil if unable to find this information."
  (let ((file (expand-file-name ".bzr/checkout/dirstate" dir)))
    (when (file-readable-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (and (looking-at "#bazaar dirstate flat format 3")
             (forward-line 3)
             (looking-at "[0-9]+\0\\([^\0\n]+\\)\0")
             (match-string 1))))))

(defun emacs-bzr-version-bzr (dir)
  "Ask bzr itself for the version information for directory DIR."
  ;; Comments on `bzr version-info':
  ;; i) Unknown files also cause clean != 1.
  ;; ii) It can be slow, contacting the upstream repo to get the
  ;; branch nick if one is not set locally, even with a custom
  ;; template that is not asking for the nick (as used here).  You'd
  ;; think the latter part would be trivial to fix:
  ;; https://bugs.launchpad.net/bzr/+bug/882541/comments/3
  ;; https://bugs.launchpad.net/bzr/+bug/629150
  ;; You can set the nick locally with `bzr nick ...', which speeds
  ;; things up enormously.  `bzr revno' does not have this issue, but
  ;; has no way to print the revision_id AFAICS.
  (message "Waiting for bzr...")
  (with-temp-buffer
    (if (zerop
         (call-process "bzr" nil '(t nil) nil "version-info"
                       "--custom"
                       "--template={revno} {revision_id} (clean = {clean})"
                       "dir"))
        (buffer-string))))

(defun emacs-bzr-get-version (&optional dir external)
  "Try to return as a string the bzr revision of the Emacs sources.
The format is: [revno] revision_id, where revno may be absent.
Value is nil if the sources do not seem to be under bzr, or if we could
not determine the revision.  Note that this reports on the current state
of the sources, which may not correspond to the running Emacs.

Optional argument DIR is a directory to use instead of `source-directory'.
Optional argument EXTERNAL non-nil means to maybe ask `bzr' itself,
if the sources appear to be under bzr.  If `force', always ask bzr.
Otherwise only ask bzr if we cannot find any information ourselves."
  (or dir (setq dir source-directory))
  (when (file-directory-p (expand-file-name ".bzr/branch" dir))
    (if (eq external 'force)
        (emacs-bzr-version-bzr dir)
      (let (file loc rev)
        (cond ((file-readable-p
                (setq file (expand-file-name ".bzr/branch/last-revision" dir)))
               (with-temp-buffer
                 (insert-file-contents file)
                 (goto-char (point-max))
                 (if (looking-back "\n")
                     (delete-char -1))
                 (buffer-string)))
              ;; OK, no last-revision.  Is it a lightweight checkout?
              ((file-readable-p
                (setq file (expand-file-name ".bzr/branch/location" dir)))
               (setq rev (emacs-bzr-version-dirstate dir))
               ;; If the parent branch is local, try looking there for the rev.
               ;; Note: there is no guarantee that the parent branch's rev
               ;; corresponds to this branch.  This branch could have
               ;; been made with a specific -r revno argument, or the
               ;; parent could have been updated since this branch was created.
               ;; To try and detect this, we check the dirstate revids
               ;; to see if they match.
               (if (and (setq loc (with-temp-buffer
                                    (insert-file-contents file)
                                    (if (looking-at "file://\\(.*\\)")
                                        (match-string 1))))
                        (equal rev (emacs-bzr-version-dirstate loc)))
                   (emacs-bzr-get-version loc)
                 ;; If parent does not match, the best we can do without
                 ;; calling external commands is to use the dirstate rev.
                 rev))
              (external
               (emacs-bzr-version-bzr dir)))))))

;; We put version info into the executable in the form that `ident' uses.
(purecopy (concat "\n$Id: " (subst-char-in-string ?\n ?\s (emacs-version))
		  " $\n"))

;;; version.el ends here
