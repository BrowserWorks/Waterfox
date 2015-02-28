;;; ede/linux.el --- Special project for Linux

;; Copyright (C) 2008-2013 Free Software Foundation, Inc.

;; Author: Eric M. Ludlam <eric@siege-engine.com>

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
;;
;; Provide a special project type just for Linux, cause Linux is special.
;;
;; Identifies a Linux project automatically.
;; Speedy ede-expand-filename based on extension.
;; Pre-populates the preprocessor map from lisp.h
;;
;; ToDo :
;; * Add "build" options.
;; * Add texinfo lookup options.
;; * Add website

(require 'ede)
(require 'ede/make)

(declare-function semanticdb-file-table-object "semantic/db")
(declare-function semanticdb-needs-refresh-p "semantic/db")
(declare-function semanticdb-refresh-table "semantic/db")

;;; Code:
(defgroup project-linux nil
  "File and tag browser frame."
  :group 'tools
  :group 'ede
  :version "24.3")

(defcustom project-linux-compile-target-command (concat ede-make-command " -k -C %s SUBDIRS=%s")
  "*Default command used to compile a target."
  :group 'project-linux
  :type 'string)

(defcustom project-linux-compile-project-command (concat ede-make-command " -k -C %s")
  "*Default command used to compile a project."
  :group 'project-linux
  :type 'string)

(defvar ede-linux-project-list nil
  "List of projects created by option `ede-linux-project'.")

(defun ede-linux-file-existing (dir)
  "Find a Linux project in the list of Linux projects.
DIR is the directory to search from."
  (let ((projs ede-linux-project-list)
	(ans nil))
    (while (and projs (not ans))
      (let ((root (ede-project-root-directory (car projs))))
	(when (string-match (concat "^" (regexp-quote root)) dir)
	  (setq ans (car projs))))
      (setq projs (cdr projs)))
    ans))

;;;###autoload
(defun ede-linux-project-root (&optional dir)
  "Get the root directory for DIR."
  (when (not dir) (setq dir default-directory))
  (let ((case-fold-search t)
	(proj (ede-linux-file-existing dir)))
    (if proj
	(ede-up-directory (file-name-directory
			   (oref proj :file)))
      ;; No pre-existing project.  Let's take a wild-guess if we have
      ;; an Linux project here.
      (when (string-match "linux[^/]*" dir)
	(let ((base (substring dir 0 (match-end 0))))
	  (when (file-exists-p (expand-file-name "scripts/ver_linux" base))
	      base))))))

(defun ede-linux-version (dir)
  "Find the Linux version for the Linux src in DIR."
  (let ((buff (get-buffer-create " *linux-query*")))
    (with-current-buffer buff
      (erase-buffer)
      (setq default-directory (file-name-as-directory dir))
      (insert-file-contents "Makefile" nil 0 512)
      (goto-char (point-min))
      (let (major minor sub)
	(re-search-forward "^VERSION *= *\\([0-9.]+\\)")
	(setq major (match-string 1))
	(re-search-forward "^PATCHLEVEL *= *\\([0-9.]+\\)")
	(setq minor (match-string 1))
	(re-search-forward "^SUBLEVEL *= *\\([0-9.]+\\)")
	(setq sub (match-string 1))
	(prog1
	    (concat major "." minor "." sub)
	  (kill-buffer buff)
	  )))))

(defclass ede-linux-project (ede-project eieio-instance-tracker)
  ((tracking-symbol :initform 'ede-linux-project-list)
   )
  "Project Type for the Linux source code."
  :method-invocation-order :depth-first)

;;;###autoload
(defun ede-linux-load (dir &optional rootproj)
  "Return an Linux Project object if there is a match.
Return nil if there isn't one.
Argument DIR is the directory it is created for.
ROOTPROJ is nil, since there is only one project."
  (or (ede-linux-file-existing dir)
      ;; Doesn't already exist, so let's make one.
      (let ((proj (ede-linux-project
		   "Linux"
		   :name "Linux"
		   :version (ede-linux-version dir)
		   :directory (file-name-as-directory dir)
		   :file (expand-file-name "scripts/ver_linux"
					   dir))))
	(ede-add-project-to-global-list proj))
      ))

;;;###autoload
(ede-add-project-autoload
 (ede-project-autoload "linux"
		       :name "LINUX ROOT"
		       :file 'ede/linux
		       :proj-file "scripts/ver_linux"
		       :proj-root-dirmatch "linux[^/]*"
		       :proj-root 'ede-linux-project-root
		       :load-type 'ede-linux-load
		       :class-sym 'ede-linux-project
		       :new-p nil
		       :safe-p t)
 'unique)

(defclass ede-linux-target-c (ede-target)
  ()
  "EDE Linux Project target for C code.
All directories need at least one target.")

(defclass ede-linux-target-misc (ede-target)
  ()
  "EDE Linux Project target for Misc files.
All directories need at least one target.")

(defmethod initialize-instance ((this ede-linux-project)
				&rest fields)
  "Make sure the targets slot is bound."
  (call-next-method)
  (unless (slot-boundp this 'targets)
    (oset this :targets nil)))

;;; File Stuff
;;
(defmethod ede-project-root-directory ((this ede-linux-project)
				       &optional file)
  "Return the root for THIS Linux project with file."
  (ede-up-directory (file-name-directory (oref this file))))

(defmethod ede-project-root ((this ede-linux-project))
  "Return my root."
  this)

(defmethod ede-find-subproject-for-directory ((proj ede-linux-project)
					      dir)
  "Return PROJ, for handling all subdirs below DIR."
  proj)

;;; TARGET MANAGEMENT
;;
(defun ede-linux-find-matching-target (class dir targets)
  "Find a target that is a CLASS and is in DIR in the list of TARGETS."
  (let ((match nil))
    (dolist (T targets)
      (when (and (object-of-class-p T class)
		 (string= (oref T :path) dir))
	(setq match T)
      ))
    match))

(defmethod ede-find-target ((proj ede-linux-project) buffer)
  "Find an EDE target in PROJ for BUFFER.
If one doesn't exist, create a new one for this directory."
  (let* ((ext (file-name-extension (buffer-file-name buffer)))
	 (cls (cond ((not ext)
		     'ede-linux-target-misc)
		    ((string-match "c\\|h" ext)
		     'ede-linux-target-c)
		    (t 'ede-linux-target-misc)))
	 (targets (oref proj targets))
	 (dir default-directory)
	 (ans (ede-linux-find-matching-target cls dir targets))
	 )
    (when (not ans)
      (setq ans (make-instance
		 cls
		 :name (file-name-nondirectory
			(directory-file-name dir))
		 :path dir
		 :source nil))
      (object-add-to-list proj :targets ans)
      )
    ans))

;;; UTILITIES SUPPORT.
;;
(defmethod ede-preprocessor-map ((this ede-linux-target-c))
  "Get the pre-processor map for Linux C code.
All files need the macros from lisp.h!"
  (require 'semantic/db)
  (let* ((proj (ede-target-parent this))
	 (root (ede-project-root proj))
	 (versionfile (ede-expand-filename root "include/linux/version.h"))
	 (table (when (and versionfile (file-exists-p versionfile))
		  (semanticdb-file-table-object versionfile)))
	 (filemap '( ("__KERNEL__" . "")
		     ))
	 )
    (when table
      (when (semanticdb-needs-refresh-p table)
	(semanticdb-refresh-table table))
      (setq filemap (append filemap (oref table lexical-table)))
      )
    filemap
    ))

(defun ede-linux-file-exists-name (name root subdir)
  "Return a file name if NAME exists under ROOT with SUBDIR in between."
  (let ((F (expand-file-name name (expand-file-name subdir root))))
    (when (file-exists-p F) F)))

(defmethod ede-expand-filename-impl ((proj ede-linux-project) name)
  "Within this project PROJ, find the file NAME.
Knows about how the Linux source tree is organized."
  (let* ((ext (file-name-extension name))
	 (root (ede-project-root proj))
	 (dir (ede-project-root-directory root))
	 (F (cond
	     ((not ext) nil)
	     ((string-match "h" ext)
	      (or (ede-linux-file-exists-name name dir "")
		  (ede-linux-file-exists-name name dir "include"))
	      )
	     ((string-match "txt" ext)
	      (ede-linux-file-exists-name name dir "Documentation"))
	     (t nil)))
	 )
    (or F (call-next-method))))

(defmethod project-compile-project ((proj ede-linux-project)
				    &optional command)
  "Compile the entire current project.
Argument COMMAND is the command to use when compiling."
  (let* ((dir (ede-project-root-directory proj)))

    (require 'compile)
    (if (not project-linux-compile-project-command)
	(setq project-linux-compile-project-command compile-command))
    (if (not command)
	(setq command
	      (format
	       project-linux-compile-project-command
	       dir)))

    (compile command)))

(defmethod project-compile-target ((obj ede-linux-target-c) &optional command)
  "Compile the current target.
Argument COMMAND is the command to use for compiling the target."
  (let* ((proj (ede-target-parent obj))
	 (root (ede-project-root proj))
	 (dir (ede-project-root-directory root))
	 (subdir (oref obj path)))

    (require 'compile)
    (if (not project-linux-compile-project-command)
	(setq project-linux-compile-project-command compile-command))
    (if (not command)
	(setq command
	      (format
	       project-linux-compile-target-command
	       dir subdir)))

    (compile command)))

(provide 'ede/linux)

;; Local variables:
;; generated-autoload-file: "loaddefs.el"
;; generated-autoload-load-name: "ede/linux"
;; End:

;;; ede/linux.el ends here
