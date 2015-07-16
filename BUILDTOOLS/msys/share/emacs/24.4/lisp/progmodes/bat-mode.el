;;; bat-mode.el --- Major mode for editing DOS/Windows scripts

;; Copyright (C) 2003, 2008-2014 Free Software Foundation, Inc.

;; Author: Arni Magnusson <arnima@hafro.is>
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
;;
;; Major mode for editing DOS/Windows scripts (batch files).  Provides syntax
;; highlighting, a basic template, access to DOS help pages, imenu/outline
;; navigation, and the ability to run scripts from within Emacs.  The syntax
;; groups for highlighting are:
;;
;; Face                          Example
;; bat-label-face                :LABEL
;; font-lock-comment-face        rem
;; font-lock-builtin-face        copy
;; font-lock-keyword-face        goto
;; font-lock-warning-face        cp
;; font-lock-constant-face       [call] prog
;; font-lock-variable-name-face  %var%
;; font-lock-type-face           -option
;;
;; Usage:
;;
;; See documentation of function `bat-mode'.
;;
;; Separate package `dos-indent' (Matthew Fidler) provides rudimentary
;; indentation, see http://www.emacswiki.org/emacs/dos-indent.el.
;;
;; Acknowledgements:
;;
;; Inspired by `batch-mode' (Agnar Renolen) and `cmd-mode' (Tadamegu Furukawa).

;;; Code:

;; 1  Preamble

(defgroup bat-mode nil
  "Major mode for editing DOS/Windows batch files."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'languages)

;; 2  User variables

(defface bat-label-face '((t :weight bold))
  "Font Lock mode face used to highlight labels in batch files.")

;; 3  Internal variables

(defvar bat-font-lock-keywords
  (eval-when-compile
    (let ((COMMANDS
           '("assoc" "at" "attrib" "cd" "cls" "color" "copy" "date" "del" "dir"
             "doskey" "echo" "endlocal" "erase" "fc" "find" "findstr" "format"
             "ftype" "label" "md" "mkdir" "more" "move" "net" "path" "pause"
             "popd" "prompt" "pushd" "rd" "ren" "rename" "replace" "rmdir" "set"
             "setlocal" "shift" "sort" "subst" "time" "title" "tree" "type"
             "ver" "vol" "xcopy"))
          (CONTROLFLOW
           '("call" "cmd" "defined" "do" "else" "equ" "exist" "exit" "for" "geq"
             "goto" "gtr" "if" "in" "leq" "lss" "neq" "not" "start"))
          (UNIX
           '("bash" "cat" "cp" "fgrep" "grep" "ls" "sed" "sh" "mv" "rm")))
      `(("\\_<\\(call\\|goto\\)\\_>[ \t]+%?\\([A-Za-z0-9-_\\:.]+\\)%?"
         (2 font-lock-constant-face t))
        ("^:[^:].*"
         . 'bat-label-face)
        ("\\_<\\(defined\\|set\\)\\_>[ \t]*\\(\\w+\\)"
         (2 font-lock-variable-name-face))
        ("%\\(\\w+\\)%?"
         (1 font-lock-variable-name-face))
        ("!\\(\\w+\\)!?"                ; delayed-expansion !variable!
         (1 font-lock-variable-name-face))
        ("[ =][-/]+\\(\\w+\\)"
         (1 font-lock-type-face append))
        (,(concat "\\_<" (regexp-opt COMMANDS) "\\_>") . font-lock-builtin-face)
        (,(concat "\\_<" (regexp-opt CONTROLFLOW) "\\_>")
         . font-lock-keyword-face)
        (,(concat "\\_<" (regexp-opt UNIX) "\\_>")
         . font-lock-warning-face)))))

(defvar bat-menu
  '("Bat"
    ["Run" bat-run :help "Run script"]
    ["Run with Args" bat-run-args :help "Run script with args"]
    "--"
    ["Imenu" imenu :help "Navigate with imenu"]
    "--"
    ["Template" bat-template :help "Insert template"]
    "--"
    ["Help (Command)" bat-cmd-help :help "Show help page for DOS command"]))

(defvar bat-mode-map
  (let ((map (make-sparse-keymap)))
    (easy-menu-define nil map nil bat-menu)
    (define-key map [?\C-c ?\C-/] 'bat-cmd-help) ;FIXME: Why not C-c C-? ?
    (define-key map [?\C-c ?\C-a] 'bat-run-args)
    (define-key map [?\C-c ?\C-c] 'bat-run)
    (define-key map [?\C-c ?\C-t] 'bat-template)
    (define-key map [?\C-c ?\C-v] 'bat-run)
    map))

(defvar bat-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\" "\"" table)
    ;; Beware: `w' should not be used for non-alphabetic chars.
    (modify-syntax-entry ?~ "_" table)
    (modify-syntax-entry ?% "." table)
    (modify-syntax-entry ?- "_" table)
    (modify-syntax-entry ?_ "_" table)
    ;; FIXME: { and } can appear in identifiers?  Really?
    (modify-syntax-entry ?{ "_" table)
    (modify-syntax-entry ?} "_" table)
    (modify-syntax-entry ?\\ "." table)
    table))

(defconst bat--syntax-propertize
  (syntax-propertize-rules
   ("^[ \t]*\\(?:\\(@?r\\)em\\_>\\|\\(?1::\\):\\).*" (1 "<"))))

;; 4  User functions

(defun bat-cmd-help (cmd)
  "Show help for batch file command CMD."
  (interactive "sHelp: ")
  (if (string-equal cmd "net")
      ;; FIXME: liable to quoting nightmare.  Use call-process?
      (shell-command "net /?") (shell-command (concat "help " cmd))))

(defun bat-run ()
  "Run a batch file."
  (interactive)
  ;; FIXME: liable to quoting nightmare.  Use call/start-process?
  (save-buffer) (shell-command buffer-file-name))

(defun bat-run-args (args)
  "Run a batch file with ARGS."
  (interactive "sArgs: ")
  ;; FIXME: Use `compile'?
  (shell-command (concat buffer-file-name " " args)))

(defun bat-template ()
  "Insert minimal batch file template."
  (interactive)
  (goto-char (point-min)) (insert "@echo off\nsetlocal\n\n"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.\\(bat\\|cmd\\)\\'" . bat-mode))

;; 5  Main function

;;;###autoload
(define-derived-mode bat-mode prog-mode "Bat"
  "Major mode for editing DOS/Windows batch files.\n
Start a new script from `bat-template'.  Read help pages for DOS commands
with `bat-cmd-help'.  Navigate between sections using `imenu'.
Run script using `bat-run' and `bat-run-args'.\n
\\{bat-mode-map}"
  (setq-local comment-start "rem ")
  (setq-local syntax-propertize-function bat--syntax-propertize)
  (setq-local font-lock-defaults
       '(bat-font-lock-keywords nil t)) ; case-insensitive keywords
  (setq-local imenu-generic-expression '((nil "^:[^:].*" 0)))
  (setq-local outline-regexp ":[^:]"))

(provide 'bat-mode)

;;; bat-mode.el ends here
