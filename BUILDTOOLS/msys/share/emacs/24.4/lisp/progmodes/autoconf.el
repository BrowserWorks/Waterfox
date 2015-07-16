;;; autoconf.el --- mode for editing Autoconf configure.ac files

;; Copyright (C) 2000-2014 Free Software Foundation, Inc.

;; Author: Dave Love <fx@gnu.org>
;; Keywords: languages

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

;; Provides fairly minimal font-lock, imenu and indentation support
;; for editing configure.ac files.  Only Autoconf syntax is processed.
;; There is no attempt to deal with shell text -- probably that will
;; always lose.

;; This is specialized for configure.ac files.  It doesn't inherit the
;; general M4 stuff from M4 mode.

;; There is also an autoconf-mode.el in existence.  That appears to be
;; for editing the Autoconf M4 source, rather than configure.ac files.

;;; Code:

(defvar autoconf-mode-map (make-sparse-keymap))

(defvar autoconf-mode-hook nil
  "Hook run by `autoconf-mode'.")

(defconst autoconf-definition-regexp
  "A\\(?:H_TEMPLATE\\|C_\\(?:SUBST\\|DEFINE\\(?:_UNQUOTED\\)?\\)\\)(\\[*\\(\\(?:\\sw\\|\\s_\\)+\\)\\]*")

(defvar autoconf-font-lock-keywords
  `(("\\_<A[CHMS]_\\(?:\\sw\\|\\s_\\)+" . font-lock-keyword-face)
    (,autoconf-definition-regexp
     1 font-lock-function-name-face)
    ;; Are any other M4 keywords really appropriate for configure.ac,
    ;; given that we do `dnl'?
    ("changequote" . font-lock-keyword-face)))

(defvar autoconf-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\" "." table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?# "<" table)
    table))

(defvar autoconf-imenu-generic-expression
  (list (list nil autoconf-definition-regexp 1)))

;; It's not clear how best to implement this.
(defun autoconf-current-defun-function ()
  "Function to use for `add-log-current-defun-function' in Autoconf mode.
This version looks back for an AC_DEFINE or AC_SUBST.  It will stop
searching backwards at another AC_... command."
  (save-excursion
    (skip-syntax-forward "w_" (line-end-position))
    (if (re-search-backward autoconf-definition-regexp
                            (save-excursion (beginning-of-defun) (point))
                            t)
        (match-string-no-properties 1))))

;;;###autoload
(define-derived-mode autoconf-mode prog-mode "Autoconf"
  "Major mode for editing Autoconf configure.ac files."
  (setq-local parens-require-spaces nil) ; for M4 arg lists
  (setq-local defun-prompt-regexp "^[ \t]*A[CM]_\\(\\sw\\|\\s_\\)+")
  (setq-local comment-start "dnl ")
  ;; We want to avoid matching "dnl" in other text.
  (setq-local comment-start-skip "\\(?:\\(\\W\\|^\\)dnl\\|#\\) +")
  (setq-local syntax-propertize-function
	      (syntax-propertize-rules ("\\<dnl\\>" (0 "<"))))
  (setq-local font-lock-defaults
	      `(autoconf-font-lock-keywords nil nil))
  (setq-local imenu-generic-expression autoconf-imenu-generic-expression)
  (setq-local indent-line-function #'indent-relative)
  (setq-local add-log-current-defun-function
	      #'autoconf-current-defun-function))

(provide 'autoconf-mode)
(provide 'autoconf)

;;; autoconf.el ends here
