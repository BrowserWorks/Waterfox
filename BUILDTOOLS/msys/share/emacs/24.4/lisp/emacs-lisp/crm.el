;;; crm.el --- read multiple strings with completion

;; Copyright (C) 1985-1986, 1993-2014 Free Software Foundation, Inc.

;; Author: Sen Nagata <sen@eccosys.com>
;; Keywords: completion, minibuffer, multiple elements

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

;; This code defines a function, `completing-read-multiple', which
;; provides the ability to read multiple strings in the minibuffer,
;; with completion.  See that function's documentation for details.

;; For the moment, I have decided to not bind any special behavior to
;; the separator key.  In the future, the separator key might be used
;; to provide completion in certain circumstances.  One of the reasons
;; why this functionality is not yet provided is that it is unclear to
;; the author what the precise circumstances are, under which
;; separator-invoked completion should be provided.

;; Design note: `completing-read-multiple' is modeled after
;; `completing-read'.  They should be similar -- it was intentional.

;; Some of this code started out as translation from C code in
;; src/minibuf.c to Emacs Lisp code.  After this code was rewritten in Elisp
;; and made to operate on any field, this file was completely rewritten to
;; just reuse that code.

;; Thanks to Sen Nagata <sen@eccosys.com> for the original version of the
;; code, and sorry for throwing it all out.  --Stef

;; Thanks to Richard Stallman for all of his help (many of the good
;; ideas in here are from him), Gerd Moellmann for his attention,
;; Stefan Monnier for responding with a code sample and comments very
;; early on, and Kai Grossjohann & Soren Dayton for valuable feedback.

;;; Questions and Thoughts:

;; -should `completing-read-multiple' allow a trailing separator in
;; a return value when REQUIRE-MATCH is t?  if not, should beep when a user
;; tries to exit the minibuffer via RET?

;; -tip: use M-f and M-b for ease of navigation among elements.

;; - the difference between minibuffer-completion-table and
;;   crm-completion-table is just crm--collection-fn.  In most cases it
;;   shouldn't make any difference.  But if a non-CRM completion function
;;   happens to be used, it will use minibuffer-completion-table and
;;   crm--collection-fn will try to make it do "more or less the right
;;   thing" by making it complete on the last element, which is about as
;;   good as we can hope for right now.
;;   I'm not sure if it's important or not.  Maybe we could just throw away
;;   crm-completion-table and crm--collection-fn, but there doesn't seem to
;;   be a pressing need for it, and since Sen did bother to write it, we may
;;   as well keep it, in case it helps.

;;; History:
;;
;; 2000-04-10:
;;
;;   first revamped version

;;; Code:

;; FIXME I don't see that this needs to exist as a separate variable.
;; crm-separator should suffice.
(defconst crm-default-separator "[ \t]*,[ \t]*"
  "Default value of `crm-separator'.")

(defvar crm-separator crm-default-separator
  "Separator regexp used for separating strings in `completing-read-multiple'.
It should be a regexp that does not match the list of completion candidates.
The default value is `crm-default-separator'.")

(defvar crm-local-completion-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map minibuffer-local-completion-map)
    (define-key map [remap minibuffer-complete] #'crm-complete)
    (define-key map [remap minibuffer-complete-word] #'crm-complete-word)
    (define-key map [remap minibuffer-completion-help] #'crm-completion-help)
    map)
  "Local keymap for minibuffer multiple input with completion.
Analog of `minibuffer-local-completion-map'.")

(defvar crm-local-must-match-map
  (let ((map (make-sparse-keymap)))
    ;; We'd want to have multiple inheritance here.
    (set-keymap-parent map minibuffer-local-must-match-map)
    (define-key map [remap minibuffer-complete] #'crm-complete)
    (define-key map [remap minibuffer-complete-word] #'crm-complete-word)
    (define-key map [remap minibuffer-completion-help] #'crm-completion-help)
    (define-key map [remap minibuffer-complete-and-exit]
      #'crm-complete-and-exit)
    map)
  "Local keymap for minibuffer multiple input with exact match completion.
Analog of `minibuffer-local-must-match-map' for crm.")

(defvar crm-completion-table nil
  "An alist whose elements' cars are strings, or an obarray.
This is a table used for completion by `completing-read-multiple' and its
supporting functions.")

;; this function evolved from a posting by Stefan Monnier
(defun crm--collection-fn (string predicate flag)
  "Function used by `completing-read-multiple' to compute completion values.
The value of STRING is the string to be completed.

The value of PREDICATE is a function to filter possible matches, or
nil if none.

The value of FLAG is used to specify the type of completion operation.
A value of nil specifies `try-completion'.  A value of t specifies
`all-completions'.  A value of lambda specifies a test for an exact match.

For more information on STRING, PREDICATE, and FLAG, see the Elisp
Reference sections on 'Programmed Completion' and 'Basic Completion
Functions'."
  (let ((beg 0))
    (while (string-match crm-separator string beg)
      (setq beg (match-end 0)))
    (completion-table-with-context (substring string 0 beg)
                                   crm-completion-table
                                   (substring string beg)
                                   predicate
                                   flag)))

(defun crm--current-element ()
  "Parse the minibuffer to find the current element.
Return the element's boundaries as (START . END)."
  (let ((bob (minibuffer-prompt-end)))
    (cons (save-excursion
                  (if (re-search-backward crm-separator bob t)
                      (match-end 0)
              bob))
          (save-excursion
                (if (re-search-forward crm-separator nil t)
                    (match-beginning 0)
              (point-max))))))

(defmacro crm--completion-command (beg end &rest body)
  "Run BODY with BEG and END bound to the current element's boundaries."
  (declare (indent 2) (debug (sexp sexp &rest body)))
  `(let* ((crm--boundaries (crm--current-element))
          (,beg (car crm--boundaries))
          (,end (cdr crm--boundaries)))
     ,@body))

(defun crm-completion-help ()
  "Display a list of possible completions of the current minibuffer element."
  (interactive)
  (crm--completion-command beg end
    (minibuffer-completion-help beg end))
  nil)

(defun crm-complete ()
  "Complete the current element.
If no characters can be completed, display a list of possible completions.

Return t if the current element is now a valid match; otherwise return nil."
  (interactive)
  (crm--completion-command beg end
    (completion-in-region beg end
                          minibuffer-completion-table
                          minibuffer-completion-predicate)))

(defun crm-complete-word ()
  "Complete the current element at most a single word.
Like `minibuffer-complete-word' but for `completing-read-multiple'."
  (interactive)
  (crm--completion-command beg end
    (completion-in-region--single-word
     beg end minibuffer-completion-table minibuffer-completion-predicate)))

(defun crm-complete-and-exit ()
  "If all of the minibuffer elements are valid completions then exit.
All elements in the minibuffer must match.  If there is a mismatch, move point
to the location of mismatch and do not exit.

This function is modeled after `minibuffer-complete-and-exit'."
  (interactive)
  (let ((doexit t))
    (goto-char (minibuffer-prompt-end))
    (while
        (and doexit
             (crm--completion-command beg end
               (let ((end (copy-marker end t)))
                 (goto-char end)
                 (setq doexit nil)
                 (completion-complete-and-exit beg end
                                               (lambda () (setq doexit t)))
                 (goto-char end)
                 (not (eobp))))
             (looking-at crm-separator))
      ;; Skip to the next element.
      (goto-char (match-end 0)))
    (if doexit (exit-minibuffer))))

(defun crm--choose-completion-string (choice buffer base-position
                                             &rest ignored)
  "Completion string chooser for `completing-read-multiple'.
This is called from `choose-completion-string-functions'.
It replaces the string that is currently being completed, without
exiting the minibuffer."
  (let ((completion-no-auto-exit t)
        (choose-completion-string-functions nil))
    (choose-completion-string choice buffer base-position)
    t))

;; superemulates behavior of completing_read in src/minibuf.c
;; Use \\<crm-local-completion-map> so that help-enable-auto-load can
;; do its thing.  Any keymap that is defined will do.
;;;###autoload
(defun completing-read-multiple
  (prompt table &optional predicate require-match initial-input
	  hist def inherit-input-method)
  "Read multiple strings in the minibuffer, with completion.
The arguments are the same as those of `completing-read'.
\\<crm-local-completion-map>
Input multiple strings by separating each one with a string that
matches the regexp `crm-separator'.  For example, if the separator
regexp is \",\", entering \"alice,bob,eve\" specifies the strings
\"alice\", \"bob\", and \"eve\".

We refer to contiguous strings of non-separator-characters as
\"elements\".  In this example there are three elements.

Completion is available on a per-element basis.  For example, if the
contents of the minibuffer are \"alice,bob,eve\" and point is between
\"l\" and \"i\", pressing \\[minibuffer-complete] operates on the element \"alice\".

This function returns a list of the strings that were read,
with empty strings removed."
  (unwind-protect
      (progn
	(add-hook 'choose-completion-string-functions
		  'crm--choose-completion-string)
	(let* ((minibuffer-completion-table #'crm--collection-fn)
	       (minibuffer-completion-predicate predicate)
	       ;; see completing_read in src/minibuf.c
	       (minibuffer-completion-confirm
		(unless (eq require-match t) require-match))
	       (crm-completion-table table)
	       (map (if require-match
			crm-local-must-match-map
		      crm-local-completion-map))
	       ;; If the user enters empty input, `read-from-minibuffer'
	       ;; returns the empty string, not DEF.
	       (input (read-from-minibuffer
		       prompt initial-input map
		       nil hist def inherit-input-method)))
	  (and def (string-equal input "") (setq input def))
          ;; Remove empty strings in the list of read strings.
	  (split-string input crm-separator t)))
    (remove-hook 'choose-completion-string-functions
		 'crm--choose-completion-string)))

(define-obsolete-function-alias 'crm-minibuffer-complete 'crm-complete "23.1")
(define-obsolete-function-alias
  'crm-minibuffer-completion-help 'crm-completion-help "23.1")
(define-obsolete-function-alias
  'crm-minibuffer-complete-and-exit 'crm-complete-and-exit "23.1")

;; testing and debugging
;; (defun crm-init-test-environ ()
;;   "Set up some variables for testing."
;;   (interactive)
;;   (setq my-prompt "Prompt: ")
;;   (setq my-table
;; 	'(("hi") ("there") ("man") ("may") ("mouth") ("ma")
;; 	  ("a") ("ab") ("abc") ("abd") ("abf") ("zab") ("acb")
;; 	  ("da") ("dab") ("dabc") ("dabd") ("dabf") ("dzab") ("dacb")
;; 	  ("fda") ("fdab") ("fdabc") ("fdabd") ("fdabf") ("fdzab") ("fdacb")
;; 	  ("gda") ("gdab") ("gdabc") ("gdabd") ("gdabf") ("gdzab") ("gdacb")
;; 	  ))
;;   (setq my-separator ","))

;(completing-read-multiple my-prompt my-table)
;(completing-read-multiple my-prompt my-table nil t)
;(completing-read-multiple my-prompt my-table nil "match")
;(completing-read my-prompt my-table nil t)
;(completing-read my-prompt my-table nil "match")

(provide 'crm)

;;; crm.el ends here
