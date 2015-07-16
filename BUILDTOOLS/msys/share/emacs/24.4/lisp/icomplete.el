;;; icomplete.el --- minibuffer completion incremental feedback

;; Copyright (C) 1992-1994, 1997, 1999, 2001-2014
;;   Free Software Foundation, Inc.

;; Author: Ken Manheimer <klm@i.am>
;; Maintainer: Ken Manheimer <klm@i.am>
;; Created: Mar 1993 Ken Manheimer, klm@nist.gov - first release to usenet
;; Keywords: help, abbrev

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

;; Enabling this package implements a more fine-grained minibuffer
;; completion feedback scheme.  Prospective completions are concisely
;; indicated within the minibuffer itself, with each successive
;; keystroke.

;; See `icomplete-completions' docstring for a description of the
;; icomplete display format.

;; See the `icomplete-minibuffer-setup-hook' docstring for a means to
;; customize icomplete setup for interoperation with other
;; minibuffer-oriented packages.

;; To enable/disable icomplete mode, use the `icomplete-mode' function.

;; Thanks to everyone for their suggestions for refinements of this
;; package.  I particularly have to credit Michael Cook, who
;; implemented an incremental completion style in his 'iswitch'
;; functions that served as a model for icomplete.  Some other
;; contributors: Noah Friedman (restructuring as minor mode), Colin
;; Rafferty (lemacs reconciliation), Lars Lindberg, RMS, and others.

;; klm.

;;; Code:

(defgroup icomplete nil
  "Show completions dynamically in minibuffer."
  :prefix "icomplete-"
  :link '(info-link "(emacs)Icomplete")
  :group 'minibuffer)

(defvar icomplete-prospects-length 80)
(make-obsolete-variable
 'icomplete-prospects-length 'icomplete-prospects-height "23.1")

(defcustom icomplete-separator " | "
  "String used by Icomplete to separate alternatives in the minibuffer."
  :type 'string
  :version "24.4")

(defcustom icomplete-hide-common-prefix t
  "When non-nil, hide common prefix from completion candidates.
When nil, show candidates in full."
  :type 'boolean
  :version "24.4")

(defcustom icomplete-show-matches-on-no-input nil
  "When non-nil, show completions when first prompting for input."
  :type 'boolean
  :version "24.4")

(defcustom icomplete-with-completion-tables t
  "Specialized completion tables with which Icomplete should operate.
If this is t, Icomplete operates on all tables.
Otherwise this should be a list of the completion tables (e.g.,
`internal-complete-buffer') on which Icomplete should operate."
  ;; Prior to 24.4, not a user-option, default '(internal-complete-buffer).
  :version "24.4"
  :type '(choice (const :tag "All" t)
		 (repeat function)))

(defface icomplete-first-match '((t :weight bold))
  "Face used by Icomplete for highlighting first match."
  :version "24.4")

;;;_* User Customization variables
(defcustom icomplete-prospects-height
  ;; 20 is an estimated common size for the prompt + minibuffer content, to
  ;; try to guess the number of lines used up by icomplete-prospects-length.
  (+ 1 (/ (+ icomplete-prospects-length 20) (window-width)))
  "Maximum number of lines to use in the minibuffer."
  :type 'integer
  :version "23.1")

(defcustom icomplete-compute-delay .3
  "Completions-computation stall, used only with large-number completions.
See `icomplete-delay-completions-threshold'."
  :type 'number)

(defcustom icomplete-delay-completions-threshold 400
  "Pending-completions number over which to apply `icomplete-compute-delay'."
  :type 'integer)

(defcustom icomplete-max-delay-chars 3
  "Maximum number of initial chars to apply `icomplete-compute-delay'."
  :type 'integer)

(defvar icomplete-in-buffer nil
  "If non-nil, also use Icomplete when completing in non-mini buffers.")

(defcustom icomplete-minibuffer-setup-hook nil
  "Icomplete-specific customization of minibuffer setup.

This hook is run during minibuffer setup if Icomplete is active.
It is intended for use in customizing Icomplete for interoperation
with other features and packages.  For instance:

  (add-hook 'icomplete-minibuffer-setup-hook
	     (lambda () (setq-local max-mini-window-height 3)))

will constrain Emacs to a maximum minibuffer height of 3 lines when
icompletion is occurring."
  :type 'hook
  :group 'icomplete)


;;;_* Initialization

;;;_ + Internal Variables
;;;_  = icomplete-eoinput nil
(defvar icomplete-overlay (make-overlay (point-min) (point-min) nil t t)
  "Overlay used to display the list of completions.")

(defun icomplete-pre-command-hook ()
 (let ((non-essential t))
   (icomplete-tidy)))

(defun icomplete-post-command-hook ()
  (let ((non-essential t)) ;E.g. don't prompt for password!
    (icomplete-exhibit)))

(defvar icomplete-minibuffer-map
  (let ((map (make-sparse-keymap)))
    (define-key map [?\M-\t] 'minibuffer-force-complete)
    (define-key map [?\C-j]  'minibuffer-force-complete-and-exit)
    (define-key map [?\C-.]  'icomplete-forward-completions)
    (define-key map [?\C-,]  'icomplete-backward-completions)
    map)
  "Keymap used by `icomplete-mode' in the minibuffer.")

(defun icomplete-forward-completions ()
  "Step forward completions by one entry.
Second entry becomes the first and can be selected with
`minibuffer-force-complete-and-exit'."
  (interactive)
  (let* ((beg (icomplete--field-beg))
         (end (icomplete--field-end))
         (comps (completion-all-sorted-completions beg end))
	 (last (last comps)))
    (when comps
      (setcdr last (cons (car comps) (cdr last)))
      (completion--cache-all-sorted-completions beg end (cdr comps)))))

(defun icomplete-backward-completions ()
  "Step backward completions by one entry.
Last entry becomes the first and can be selected with
`minibuffer-force-complete-and-exit'."
  (interactive)
  (let* ((beg (icomplete--field-beg))
         (end (icomplete--field-end))
         (comps (completion-all-sorted-completions beg end))
	 (last-but-one (last comps 2))
	 (last (cdr last-but-one)))
    (when (consp last)		      ; At least two elements in comps
      (setcdr last-but-one (cdr last))
      (push (car last) comps)
      (completion--cache-all-sorted-completions beg end comps))))

;;;_ > icomplete-mode (&optional prefix)
;;;###autoload
(define-minor-mode icomplete-mode
  "Toggle incremental minibuffer completion (Icomplete mode).
With a prefix argument ARG, enable Icomplete mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

When this global minor mode is enabled, typing in the minibuffer
continuously displays a list of possible completions that match
the string you have typed.  See `icomplete-completions' for a
description of how prospective completions are displayed.

For more information, see Info node `(emacs)Icomplete'.
For options you can set, `\\[customize-group] icomplete'.

You can use the following key bindings to navigate and select
completions:

\\{icomplete-minibuffer-map}"
  :global t :group 'icomplete
  (remove-hook 'minibuffer-setup-hook #'icomplete-minibuffer-setup)
  (remove-hook 'completion-in-region-mode-hook #'icomplete--in-region-setup)
  (when icomplete-mode
    (when icomplete-in-buffer
      (add-hook 'completion-in-region-mode-hook #'icomplete--in-region-setup))
    (add-hook 'minibuffer-setup-hook #'icomplete-minibuffer-setup)))

(defun icomplete--completion-table ()
  (if (window-minibuffer-p) minibuffer-completion-table
    (or (nth 2 completion-in-region--data)
	(message "In %S (w=%S): %S"
		 (current-buffer) (selected-window) (window-minibuffer-p)))))
(defun icomplete--completion-predicate ()
  (if (window-minibuffer-p) minibuffer-completion-predicate
    (nth 3 completion-in-region--data)))
(defun icomplete--field-string ()
  (if (window-minibuffer-p) (minibuffer-contents)
    (buffer-substring-no-properties
     (nth 0 completion-in-region--data)
     (nth 1 completion-in-region--data))))
(defun icomplete--field-beg ()
  (if (window-minibuffer-p) (minibuffer-prompt-end)
    (nth 0 completion-in-region--data)))
(defun icomplete--field-end ()
  (if (window-minibuffer-p) (point-max)
    (nth 1 completion-in-region--data)))

;;;_ > icomplete-simple-completing-p ()
(defun icomplete-simple-completing-p ()
  "Non-nil if current window is a minibuffer that's doing simple completion.

Conditions are:
   the selected window is a minibuffer,
   and not in the middle of macro execution,
   and the completion table is not a function (which would
       indicate some non-standard, non-simple completion mechanism,
       like file-name and other custom-func completions),
   and `icomplete-with-completion-tables' doesn't restrict completion."

  (unless executing-kbd-macro
    (let ((table (icomplete--completion-table)))
      (and table
           (or (not (functionp table))
               (eq icomplete-with-completion-tables t)
               (member table icomplete-with-completion-tables))))))

;;;_ > icomplete-minibuffer-setup ()
(defun icomplete-minibuffer-setup ()
  "Run in minibuffer on activation to establish incremental completion.
Usually run by inclusion in `minibuffer-setup-hook'."
  (when (and icomplete-mode (icomplete-simple-completing-p))
    (set (make-local-variable 'completion-show-inline-help) nil)
    (use-local-map (make-composed-keymap icomplete-minibuffer-map
    					 (current-local-map)))
    (add-hook 'pre-command-hook  #'icomplete-pre-command-hook  nil t)
    (add-hook 'post-command-hook #'icomplete-post-command-hook nil t)
    (run-hooks 'icomplete-minibuffer-setup-hook)
    (when icomplete-show-matches-on-no-input
      (icomplete-exhibit))))

(defvar icomplete--in-region-buffer nil)

(defun icomplete--in-region-setup ()
  (when (or (not completion-in-region-mode)
	    (and icomplete--in-region-buffer
		 (not (eq icomplete--in-region-buffer (current-buffer)))))
    (with-current-buffer (or icomplete--in-region-buffer (current-buffer))
      (setq icomplete--in-region-buffer nil)
      (delete-overlay icomplete-overlay)
      (kill-local-variable 'completion-show-inline-help)
      (remove-hook 'pre-command-hook  'icomplete-pre-command-hook  t)
      (remove-hook 'post-command-hook 'icomplete-post-command-hook t)
      (message nil)))
  (when (and completion-in-region-mode
	     icomplete-mode (icomplete-simple-completing-p))
    (setq icomplete--in-region-buffer (current-buffer))
    (set (make-local-variable 'completion-show-inline-help) nil)
    (let ((tem (assq 'completion-in-region-mode
		     minor-mode-overriding-map-alist)))
      (unless (memq icomplete-minibuffer-map (cdr tem))
	(setcdr tem (make-composed-keymap icomplete-minibuffer-map
					  (cdr tem)))))
    (add-hook 'pre-command-hook  'icomplete-pre-command-hook  nil t)
    (add-hook 'post-command-hook 'icomplete-post-command-hook nil t)))



;;;_* Completion

;;;_ > icomplete-tidy ()
(defun icomplete-tidy ()
  "Remove completions display (if any) prior to new user input.
Should be run in on the minibuffer `pre-command-hook'.
See `icomplete-mode' and `minibuffer-setup-hook'."
  (delete-overlay icomplete-overlay))

;;;_ > icomplete-exhibit ()
(defun icomplete-exhibit ()
  "Insert Icomplete completions display.
Should be run via minibuffer `post-command-hook'.
See `icomplete-mode' and `minibuffer-setup-hook'."
  (when (and icomplete-mode
             (icomplete-simple-completing-p)) ;Shouldn't be necessary.
    (save-excursion
      (goto-char (point-max))
                                        ; Insert the match-status information:
      (if (and (or icomplete-show-matches-on-no-input
                   (> (icomplete--field-end) (icomplete--field-beg)))
               (or
                ;; Don't bother with delay after certain number of chars:
                (> (- (point) (icomplete--field-beg))
                   icomplete-max-delay-chars)
                ;; Don't delay if the completions are known.
                completion-all-sorted-completions
                ;; Don't delay if alternatives number is small enough:
                (and (sequencep (icomplete--completion-table))
                     (< (length (icomplete--completion-table))
                        icomplete-delay-completions-threshold))
                ;; Delay - give some grace time for next keystroke, before
		;; embarking on computing completions:
		(sit-for icomplete-compute-delay)))
	  (let* ((field-string (icomplete--field-string))
                 (text (while-no-input
                         (icomplete-completions
                          field-string
                          (icomplete--completion-table)
                          (icomplete--completion-predicate)
                          (if (window-minibuffer-p)
                              (not minibuffer-completion-confirm)))))
                 (buffer-undo-list t)
                 deactivate-mark)
	    ;; Do nothing if while-no-input was aborted.
            (when (stringp text)
              (move-overlay icomplete-overlay (point) (point) (current-buffer))
              ;; The current C cursor code doesn't know to use the overlay's
              ;; marker's stickiness to figure out whether to place the cursor
              ;; before or after the string, so let's spoon-feed it the pos.
              (put-text-property 0 1 'cursor t text)
              (overlay-put icomplete-overlay 'after-string text)))))))

;;;_ > icomplete-completions (name candidates predicate require-match)
(defun icomplete-completions (name candidates predicate require-match)
  "Identify prospective candidates for minibuffer completion.

The display is updated with each minibuffer keystroke during
minibuffer completion.

Prospective completion suffixes (if any) are displayed, bracketed by
one of (), [], or {} pairs.  The choice of brackets is as follows:

  (...) - a single prospect is identified and matching is enforced,
  [...] - a single prospect is identified but matching is optional, or
  {...} - multiple prospects, separated by commas, are indicated, and
          further input is required to distinguish a single one.

If there are multiple possibilities, `icomplete-separator' separates them.

The displays for unambiguous matches have ` [Matched]' appended
\(whether complete or not), or ` [No matches]', if no eligible
matches exist."
  (let* ((minibuffer-completion-table candidates)
	 (minibuffer-completion-predicate predicate)
	 (md (completion--field-metadata (icomplete--field-beg)))
	 (comps (completion-all-sorted-completions
                 (icomplete--field-beg) (icomplete--field-end)))
         (last (if (consp comps) (last comps)))
         (base-size (cdr last))
         (open-bracket (if require-match "(" "["))
         (close-bracket (if require-match ")" "]")))
    ;; `concat'/`mapconcat' is the slow part.
    (if (not (consp comps))
	(progn ;;(debug (format "Candidates=%S field=%S" candidates name))
	       (format " %sNo matches%s" open-bracket close-bracket))
      (if last (setcdr last nil))
      (let* ((most-try
              (if (and base-size (> base-size 0))
                  (completion-try-completion
                   name candidates predicate (length name) md)
                ;; If the `comps' are 0-based, the result should be
                ;; the same with `comps'.
                (completion-try-completion
                 name comps nil (length name) md)))
	     (most (if (consp most-try) (car most-try)
                     (if most-try (car comps) "")))
             ;; Compare name and most, so we can determine if name is
             ;; a prefix of most, or something else.
	     (compare (compare-strings name nil nil
				       most nil nil completion-ignore-case))
	     (ellipsis (if (char-displayable-p ?…) "…" "..."))
	     (determ (unless (or (eq t compare) (eq t most-try)
				 (= (setq compare (1- (abs compare)))
				    (length most)))
		       (concat open-bracket
			       (cond
				((= compare (length name))
                                 ;; Typical case: name is a prefix.
				 (substring most compare))
                                ;; Don't bother truncating if it doesn't gain
                                ;; us at least 2 columns.
				((< compare (+ 2 (string-width ellipsis))) most)
				(t (concat ellipsis (substring most compare))))
			       close-bracket)))
	     ;;"-prospects" - more than one candidate
	     (prospects-len (+ (string-width
				(or determ (concat open-bracket close-bracket)))
			       (string-width icomplete-separator)
			       (+ 2 (string-width ellipsis)) ;; take {…} into account
			       (string-width (buffer-string))))
             (prospects-max
              ;; Max total length to use, including the minibuffer content.
              (* (+ icomplete-prospects-height
                    ;; If the minibuffer content already uses up more than
                    ;; one line, increase the allowable space accordingly.
                    (/ prospects-len (window-width)))
                 (window-width)))
             ;; Find the common prefix among `comps'.
             ;; We can't use the optimization below because its assumptions
             ;; aren't always true, e.g. when completion-cycling (bug#10850):
             ;; (if (eq t (compare-strings (car comps) nil (length most)
             ;; 			 most nil nil completion-ignore-case))
             ;;     ;; Common case.
             ;;     (length most)
             ;; Else, use try-completion.
	     (prefix (when icomplete-hide-common-prefix
		       (try-completion "" comps)))
             (prefix-len
	      (and (stringp prefix)
                   ;; Only hide the prefix if the corresponding info
                   ;; is already displayed via `most'.
                   (string-prefix-p prefix most t)
                   (length prefix))) ;;)
	     prospects comp limit)
	(if (or (eq most-try t) (not (consp (cdr comps))))
	    (setq prospects nil)
	  (when (member name comps)
	    ;; NAME is complete but not unique.  This scenario poses
	    ;; following UI issues:
	    ;;
	    ;; - When `icomplete-hide-common-prefix' is non-nil, NAME
	    ;;   is stripped empty.  This would make the entry
	    ;;   inconspicuous.
	    ;;
	    ;; - Due to sorting of completions, NAME may not be the
	    ;;   first of the prospects and could be hidden deep in
	    ;;   the displayed string.
	    ;;
	    ;; - Because of `icomplete-prospects-height' , NAME may
	    ;;   not even be displayed to the user.
	    ;;
	    ;; To circumvent all the above problems, provide a visual
	    ;; cue to the user via an "empty string" in the try
	    ;; completion field.
	    (setq determ (concat open-bracket "" close-bracket)))
	  ;; Compute prospects for display.
	  (while (and comps (not limit))
	    (setq comp
		  (if prefix-len (substring (car comps) prefix-len) (car comps))
		  comps (cdr comps))
	    (setq prospects-len
                           (+ (string-width comp)
			      (string-width icomplete-separator)
			      prospects-len))
		     (if (< prospects-len prospects-max)
			 (push comp prospects)
	      (setq limit t))))
	(setq prospects (nreverse prospects))
	;; Decorate first of the prospects.
	(when prospects
	  (let ((first (copy-sequence (pop prospects))))
	    (put-text-property 0 (length first)
			       'face 'icomplete-first-match first)
	    (push first prospects)))
        ;; Restore the base-size info, since completion-all-sorted-completions
        ;; is cached.
        (if last (setcdr last base-size))
	(if prospects
	    (concat determ
		    "{"
		    (mapconcat 'identity prospects icomplete-separator)
		    (and limit (concat icomplete-separator ellipsis))
		    "}")
	  (concat determ " [Matched]"))))))

;;;_* Provide
(provide 'icomplete)

;;_* Local emacs vars.
;;Local variables:
;;allout-layout: (-2 :)
;;End:

;;; icomplete.el ends here
