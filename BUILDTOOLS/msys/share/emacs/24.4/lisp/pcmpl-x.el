;;; pcmpl-x.el --- completion for miscellaneous tools  -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Author: Leo Liu <sdl.web@gmail.com>
;; Keywords: processes, tools, convenience
;; Package: pcomplete

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

;;; Code:

(eval-when-compile (require 'cl-lib))
(require 'pcomplete)


;;;; tlmgr - http://www.tug.org/texlive/tlmgr.html

(defcustom pcmpl-x-tlmgr-program "tlmgr"
  "Name of the tlmgr program."
  :version "24.4"
  :type 'file
  :group 'pcomplete)

(defvar pcmpl-x-tlmgr-common-options
  '("--repository"
    "--gui"
    "--gui-lang"
    "--machine-readable"
    "--package-logfile"
    "--pause"
    "--persistent-downloads"
    "--no-persistent-downloads"
    "--no-execute-actions"
    "--debug-translation"
    "--help"
    "--version"))

(defvar pcmpl-x-tlmgr-actions
  '(("help")
    ("version")
    ("gui")
    ("install")
    ("update")
    ("backup")
    ("restore")
    ("remove")
    ("repository" ("list" "add" "remove" "set"))
    ("candidates")
    ("option" ("show"
               "showall"
               "repository"
               "formats"
               "postcode"
               "docfiles"
               "srcfiles"
               "backupdir"
               "autobackup"
               "sys_bin"
               "sys_man"
               "sys_info"
               "desktop_integration"
               "fileassocs"
               "multiuser"))
    ("conf" ("texmf" "tlmgr"))
    ("paper"
     ("a4" "letter" "xdvi" "pdftex" "dvips" "dvipdfmx" "dvipdfm" "context")
     (lambda ()
       (unless (member (pcomplete-arg 1) '("a4" "letter"))
         (pcomplete-here* '("paper"))
         (pcomplete-here* '("a4" "letter")))))
    ("platform" ("list" "add" "remove"))
    ("print-platform" ("collections" "schemes"))
    ("arch" ("list" "add" "remove"))
    ("print-arch" ("collections" "schemes"))
    ("info" ("collections" "schemes"))
    ("search")
    ("dump-tlpdb")
    ("check" ("files" "depends" "executes" "runfiles" "all"))
    ("path" ("add" "remove"))
    ("postaction" ("install" "remove") ("shortcut" "fileassoc" "script"))
    ("uninstall")
    ("generate" ("language"
                 "language.dat"
                 "language.def"
                 "language.dat.lua"
                 "fmtutil"))))

(defvar pcmpl-x-tlmgr-options-cache (make-hash-table :size 31 :test 'equal))

(defun pcmpl-x-tlmgr-action-options (action)
  "Get the list of long options for ACTION."
  (if (eq (gethash action pcmpl-x-tlmgr-options-cache 'missing) 'missing)
      (with-temp-buffer
        (when (zerop
               (call-process pcmpl-x-tlmgr-program nil t nil action "-h"))
          (goto-char (point-min))
          (puthash action
                   (cons "--help"
                         (cl-loop while (re-search-forward
                                         "^[ \t]+\\(--[[:alnum:]-]+=?\\)"
                                         nil t)
                                  collect (match-string 1)))
                   pcmpl-x-tlmgr-options-cache)
          (pcmpl-x-tlmgr-action-options action)))
    (gethash action pcmpl-x-tlmgr-options-cache)))

;;;###autoload
(defun pcomplete/tlmgr ()
  "Completion for the `tlmgr' command."
  (while (pcomplete-match "^--" 0)
    (pcomplete-here* pcmpl-x-tlmgr-common-options)
    (unless (or (pcomplete-match "^--" 0)
                (all-completions (pcomplete-arg 0) pcmpl-x-tlmgr-actions))
      (pcomplete-here* (pcomplete-dirs-or-entries))))
  (pcomplete-here* pcmpl-x-tlmgr-actions)
  (let ((action (substring-no-properties (pcomplete-arg 1))))
    (while t
      (if (pcomplete-match "^--" 0)
          (pcomplete-here* (pcmpl-x-tlmgr-action-options action))
        (dolist (completions (cdr (assoc action pcmpl-x-tlmgr-actions)))
          (cond ((functionp completions)
                 (funcall completions))
                ((all-completions (pcomplete-arg 0) completions)
                 (pcomplete-here* completions))
                (t (pcomplete-here* (pcomplete-dirs-or-entries)))))
        (unless (pcomplete-match "^--" 0)
          (pcomplete-here* (pcomplete-dirs-or-entries)))))))


;;;; ack - http://betterthangrep.com

;; Usage:
;;   - To complete short options type '-' first
;;   - To complete long options type '--' first
;;   - Color name completion is supported following
;;       --color-filename=, --color-match= and --color-lineno=
;;   - Type completion is supported following --type=

(defcustom pcmpl-x-ack-program
  (file-name-nondirectory (or (executable-find "ack-grep")
                              (executable-find "ack")
                              "ack"))
  "Name of the ack program."
  :version "24.4"
  :type 'file
  :group 'pcomplete)

(defvar pcmpl-x-ack-color-options
  '("clear"
    "reset"
    "dark"
    "bold"
    "underline"
    "underscore"
    "blink"
    "reverse"
    "concealed"
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "on_black"
    "on_red"
    "on_green"
    "on_yellow"
    "on_blue"
    "on_magenta"
    "on_cyan"
    "on_white")
  "Color names for the `ack' command.")

(defun pcmpl-x-ack-run (buffer &rest args)
  "Run ack with ARGS and send the output to BUFFER."
  (condition-case nil
      (apply 'call-process (or pcmpl-x-ack-program "ack") nil buffer nil args)
    (file-error -1)))

(defun pcmpl-x-ack-short-options ()
  "Short options for the `ack' command."
  (with-temp-buffer
    (let (options)
      (when (zerop (pcmpl-x-ack-run t "--help"))
        (goto-char (point-min))
        (while (re-search-forward "^  -\\([^-]\\)" nil t)
          (push (match-string 1) options))
        (mapconcat 'identity (nreverse options) "")))))

(defun pcmpl-x-ack-long-options (&optional arg)
  "Long options for the `ack' command."
  (with-temp-buffer
    (let (options)
      (when (zerop (pcmpl-x-ack-run t (or arg "--help")))
        (goto-char (point-min))
        (while (re-search-forward
                "\\(?:   ?\\|, \\)\\(--\\(\\[no\\]\\)?\\([[:alnum:]-]+=?\\)\\)"
                nil t)
          (if (not (match-string 2))
              (push (match-string 1) options)
            (push (concat "--" (match-string 3)) options)
            (push (concat "--no" (match-string 3)) options)))
        (nreverse options)))))

(defun pcmpl-x-ack-type-options ()
  "A list of types for the `ack' command."
  (pcmpl-x-ack-long-options "--help-types"))

;;;###autoload
(defun pcomplete/ack ()
  "Completion for the `ack' command.
Start an argument with '-' to complete short options and '--' for
long options."
  ;; No space after =
  (while t
    (if (pcomplete-match "^-" 0)
        (cond
         ((pcomplete-match "^--color-\\w+=\\(\\S-*\\)" 0)
          (pcomplete-here* pcmpl-x-ack-color-options
                           (pcomplete-match-string 1 0) t))
         ((pcomplete-match "^--\\(?:no\\)?ignore-dir=\\(\\S-*\\)" 0)
          (pcomplete-here* (pcomplete-dirs)
                           (pcomplete-match-string 1 0) t))
         ((pcomplete-match "^--type=\\(\\S-*\\)" 0)
          (pcomplete-here* (mapcar (lambda (type-option)
                                     (substring type-option 2))
                                   (pcmpl-x-ack-type-options))
                           (pcomplete-match-string 1 0) t))
         ((pcomplete-match "^--" 0)
          (pcomplete-here* (append (pcmpl-x-ack-long-options)
                                   (pcmpl-x-ack-type-options))))
         (t (pcomplete-opt (pcmpl-x-ack-short-options))))
      (pcomplete-here* (pcomplete-dirs-or-entries)))))

;;;###autoload
(defalias 'pcomplete/ack-grep 'pcomplete/ack)


;;;; the_silver_search - https://github.com/ggreer/the_silver_searcher

(defvar pcmpl-x-ag-options nil)

(defun pcmpl-x-ag-options ()
  (or pcmpl-x-ag-options
      (setq pcmpl-x-ag-options
            (with-temp-buffer
              (when (zerop (call-process "ag" nil t nil "--help"))
                (let (short long)
                  (goto-char (point-min))
                  (while (re-search-forward "^ +\\(-[a-zA-Z]\\) " nil t)
                    (push (match-string 1) short))
                  (goto-char (point-min))
                  (while (re-search-forward
                          "^ +\\(?:-[a-zA-Z] \\)?\\(--\\(\\[no\\]\\)?[^ \t\n]+\\) "
                          nil t)
                    (if (match-string 2)
                        (progn
                          (replace-match "" nil nil nil 2)
                          (push (match-string 1) long)
                          (replace-match "no" nil nil nil 2)
                          (push (match-string 1) long))
                      (push (match-string 1) long)))
                  (list (cons 'short (nreverse short))
                        (cons 'long  (nreverse long)))))))))

;;;###autoload
(defun pcomplete/ag ()
  "Completion for the `ag' command."
  (while t
    (if (pcomplete-match "^-" 0)
        (pcomplete-here* (cdr (assq (if (pcomplete-match "^--" 0) 'long 'short)
                                    (pcmpl-x-ag-options))))
      (pcomplete-here* (pcomplete-dirs-or-entries)))))

(provide 'pcmpl-x)
;;; pcmpl-x.el ends here
