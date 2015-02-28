;;; delsel.el --- delete selection if you insert

;; Copyright (C) 1992, 1997-1998, 2001-2013 Free Software Foundation,
;; Inc.

;; Author: Matthieu Devin <devin@lucid.com>
;; Maintainer: FSF
;; Created: 14 Jul 92
;; Keywords: convenience emulations

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

;; This file makes the active region be pending delete, meaning that
;; text inserted while the region is active will replace the region contents.
;; This is a popular behavior of personal computers text editors.

;; Interface:

;; Commands which will delete the selection need a 'delete-selection
;; property on their symbols; commands which insert text but don't
;; have this property won't delete the selection.  It can be one of
;; the values:
;;  'yank
;;      For commands which do a yank; ensures the region about to be
;;      deleted isn't yanked.
;;  'supersede
;;      Delete the active region and ignore the current command,
;;      i.e. the command will just delete the region.
;;  'kill
;;      `kill-region' is used on the selection, rather than
;;      `delete-region'.  (Text selected with the mouse will typically
;;      be yankable anyhow.)
;;  t
;;      The normal case: delete the active region prior to executing
;;      the command which will insert replacement text.
;;  <function>
;;      For commands which need to dynamically determine this behaviour.
;;      The function should return one of the above values or nil.

;;; Code:

;;;###autoload
(defalias 'pending-delete-mode 'delete-selection-mode)

;;;###autoload
(define-minor-mode delete-selection-mode
  "Toggle Delete Selection mode.
With a prefix argument ARG, enable Delete Selection mode if ARG
is positive, and disable it otherwise.  If called from Lisp,
enable the mode if ARG is omitted or nil.

When Delete Selection mode is enabled, Transient Mark mode is also
enabled and typed text replaces the selection if the selection is
active.  Otherwise, typed text is just inserted at point regardless of
any selection."
  :global t :group 'editing-basics
  (if (not delete-selection-mode)
      (remove-hook 'pre-command-hook 'delete-selection-pre-hook)
    (add-hook 'pre-command-hook 'delete-selection-pre-hook)
    (transient-mark-mode t)))

(defun delete-active-region (&optional killp)
  "Delete the active region.
If KILLP in not-nil, the active region is killed instead of deleted."
  (if killp
      (kill-region (point) (mark))
    (delete-region (point) (mark)))
  t)

(defun delete-selection-helper (type)
  "Delete selection according to TYPE:
 `yank'
     For commands which do a yank; ensures the region about to be
     deleted isn't yanked.
 `supersede'
     Delete the active region and ignore the current command,
     i.e. the command will just delete the region.
 `kill'
     `kill-region' is used on the selection, rather than
     `delete-region'.  (Text selected with the mouse will typically
     be yankable anyhow.)
 t
     The normal case: delete the active region prior to executing
     the command which will insert replacement text.
 FUNCTION
     For commands which need to dynamically determine this behaviour.
     FUNCTION should take no argument and return one of the above values or nil."
  (condition-case data
      (cond ((eq type 'kill)
	     (delete-active-region t))
	    ((eq type 'yank)
	     ;; Before a yank command, make sure we don't yank the
	     ;; head of the kill-ring that really comes from the
	     ;; currently active region we are going to delete.
	     ;; That would make yank a no-op.
	     (when (and (string= (buffer-substring-no-properties
				  (point) (mark))
				 (car kill-ring))
			(fboundp 'mouse-region-match)
			(mouse-region-match))
	       (current-kill 1))
	     (delete-active-region))
	    ((eq type 'supersede)
	     (let ((empty-region (= (point) (mark))))
	       (delete-active-region)
	       (unless empty-region
		 (setq this-command 'ignore))))
	    ((functionp type) (delete-selection-helper (funcall type)))
	    (type
	     (delete-active-region)
	     (if (and overwrite-mode
		      (eq this-command 'self-insert-command))
		 (let ((overwrite-mode nil))
		   (self-insert-command
		    (prefix-numeric-value current-prefix-arg))
		   (setq this-command 'ignore)))))
    ;; If ask-user-about-supersession-threat signals an error,
    ;; stop safe_run_hooks from clearing out pre-command-hook.
    (file-supersession (message "%s" (cadr data)) (ding))
    (text-read-only
     ;; This signal may come either from `delete-active-region' or
     ;; `self-insert-command' (when `overwrite-mode' is non-nil).
     ;; To avoid clearing out `pre-command-hook' we handle this case
     ;; by issuing a simple message.  Note, however, that we do not
     ;; handle all related problems: When read-only text ends before
     ;; the end of the region, the latter is not deleted but any
     ;; subsequent insertion will succeed.  We could avoid this case
     ;; by doing a (setq this-command 'ignore) here.  This would,
     ;; however, still not handle the case where read-only text ends
     ;; precisely where the region starts: In that case the deletion
     ;; would succeed but the subsequent insertion would fail with a
     ;; text-read-only error.  To handle that case we would have to
     ;; investigate text properties at both ends of the region and
     ;; skip the deletion when inserting text is forbidden there.
     (message "Text is read-only") (ding))))

(defun delete-selection-pre-hook ()
  "Function run before commands that delete selections are executed.
Commands which will delete the selection need a `delete-selection'
property on their symbol; commands which insert text but don't
have this property won't delete the selection.
See `delete-selection-helper'."
  (when (and delete-selection-mode (use-region-p)
	     (not buffer-read-only))
    (delete-selection-helper (and (symbolp this-command)
                                  (get this-command 'delete-selection)))))

(put 'self-insert-command 'delete-selection
     (lambda ()
       (not (run-hook-with-args-until-success
             'self-insert-uses-region-functions))))

(put 'self-insert-iso 'delete-selection t)

(put 'yank 'delete-selection 'yank)
(put 'clipboard-yank 'delete-selection 'yank)
(put 'insert-register 'delete-selection t)

(put 'delete-backward-char 'delete-selection 'supersede)
(put 'backward-delete-char-untabify 'delete-selection 'supersede)
(put 'delete-char 'delete-selection 'supersede)

(put 'newline-and-indent 'delete-selection t)
(put 'newline 'delete-selection t)
(put 'open-line 'delete-selection 'kill)

;; This is very useful for canceling a selection in the minibuffer without
;; aborting the minibuffer.
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark t)
    (abort-recursive-edit)))

(define-key minibuffer-local-map "\C-g" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map "\C-g" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map "\C-g" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map "\C-g" 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map "\C-g" 'minibuffer-keyboard-quit)

(defun delsel-unload-function ()
  "Unload the Delete Selection library."
  (define-key minibuffer-local-map "\C-g" 'abort-recursive-edit)
  (define-key minibuffer-local-ns-map "\C-g" 'abort-recursive-edit)
  (define-key minibuffer-local-completion-map "\C-g" 'abort-recursive-edit)
  (define-key minibuffer-local-must-match-map "\C-g" 'abort-recursive-edit)
  (define-key minibuffer-local-isearch-map "\C-g" 'abort-recursive-edit)
  (dolist (sym '(self-insert-command self-insert-iso yank clipboard-yank
		 insert-register delete-backward-char backward-delete-char-untabify
		 delete-char newline-and-indent newline open-line))
    (put sym 'delete-selection nil))
  ;; continue standard unloading
  nil)

(provide 'delsel)

;;; delsel.el ends here
