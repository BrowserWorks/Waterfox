;;; prog-mode.el --- Generic major mode for programming  -*- lexical-binding: t -*-

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Maintainer: emacs-devel@gnu.org
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

;; This major mode is mostly intended as a parent of other programming
;; modes.  All major modes for programming languages should derive from this
;; mode so that users can put generic customization on prog-mode-hook.

;;; Code:

(eval-when-compile (require 'cl-lib))

(defgroup prog-mode nil
  "Generic programming mode, from which others derive."
  :group 'languages)

(defvar prog-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [?\C-\M-q] 'prog-indent-sexp)
    map)
  "Keymap used for programming modes.")

(defun prog-indent-sexp (&optional defun)
  "Indent the expression after point.
When interactively called with prefix, indent the enclosing defun
instead."
  (interactive "P")
  (save-excursion
    (when defun
      (end-of-line)
      (beginning-of-defun))
    (let ((start (point))
	  (end (progn (forward-sexp 1) (point))))
      (indent-region start end nil))))

(defvar-local prettify-symbols-alist nil
  "Alist of symbol prettifications.
Each element looks like (SYMBOL . CHARACTER), where the symbol
matching SYMBOL (a string, not a regexp) will be shown as
CHARACTER instead.")

(defun prettify-symbols--compose-symbol (alist)
  "Compose a sequence of characters into a symbol.
Regexp match data 0 points to the chars."
  ;; Check that the chars should really be composed into a symbol.
  (let* ((start (match-beginning 0))
	 (end (match-end 0))
	 (syntaxes (if (eq (char-syntax (char-after start)) ?w)
		       '(?w ?_) '(?. ?\\)))
	 match)
    (if (or (memq (char-syntax (or (char-before start) ?\s)) syntaxes)
	    (memq (char-syntax (or (char-after end) ?\s)) syntaxes)
            ;; syntax-ppss could modify the match data (bug#14595)
            (progn (setq match (match-string 0)) (nth 8 (syntax-ppss))))
	;; No composition for you.  Let's actually remove any composition
	;; we may have added earlier and which is now incorrect.
	(remove-text-properties start end '(composition))
      ;; That's a symbol alright, so add the composition.
      (compose-region start end (cdr (assoc match alist)))))
  ;; Return nil because we're not adding any face property.
  nil)

(defun prettify-symbols--make-keywords ()
  (if prettify-symbols-alist
      `((,(regexp-opt (mapcar 'car prettify-symbols-alist) t)
         (0 (prettify-symbols--compose-symbol ',prettify-symbols-alist))))
    nil))

(defvar-local prettify-symbols--keywords nil)

;;;###autoload
(define-minor-mode prettify-symbols-mode
  "Toggle Prettify Symbols mode.
With a prefix argument ARG, enable Prettify Symbols mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

When Prettify Symbols mode and font-locking are enabled, symbols are
prettified (displayed as composed characters) according to the rules
in `prettify-symbols-alist' (which see), which are locally defined
by major modes supporting prettifying.  To add further customizations
for a given major mode, you can modify `prettify-symbols-alist' thus:

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (push '(\"<=\" . ?≤) prettify-symbols-alist)))

You can enable this mode locally in desired buffers, or use
`global-prettify-symbols-mode' to enable it for all modes that
support it."
  :init-value nil
  (if prettify-symbols-mode
      ;; Turn on
      (when (setq prettify-symbols--keywords (prettify-symbols--make-keywords))
        (font-lock-add-keywords nil prettify-symbols--keywords)
        (setq-local font-lock-extra-managed-props
                    (cons 'composition font-lock-extra-managed-props))
        (font-lock-fontify-buffer))
    ;; Turn off
    (when prettify-symbols--keywords
      (font-lock-remove-keywords nil prettify-symbols--keywords)
      (setq prettify-symbols--keywords nil))
    (when (memq 'composition font-lock-extra-managed-props)
      (setq font-lock-extra-managed-props (delq 'composition
                                                font-lock-extra-managed-props))
      (with-silent-modifications
        (remove-text-properties (point-min) (point-max) '(composition nil))))))

(defun turn-on-prettify-symbols-mode ()
  (when (and (not prettify-symbols-mode)
             (local-variable-p 'prettify-symbols-alist))
    (prettify-symbols-mode 1)))

;;;###autoload
(define-globalized-minor-mode global-prettify-symbols-mode
  prettify-symbols-mode turn-on-prettify-symbols-mode)

;;;###autoload
(define-derived-mode prog-mode fundamental-mode "Prog"
  "Major mode for editing programming language source code."
  (setq-local require-final-newline mode-require-final-newline)
  (setq-local parse-sexp-ignore-comments t)
  ;; Any programming language is always written left to right.
  (setq bidi-paragraph-direction 'left-to-right))

(provide 'prog-mode)

;;; prog-mode.el ends here
