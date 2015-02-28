;;; ebuff-menu.el --- electric-buffer-list mode

;; Copyright (C) 1985-1986, 1994, 2001-2013 Free Software Foundation,
;; Inc.

;; Author: Richard Mlynarik <mly@ai.mit.edu>
;; Maintainer: FSF
;; Keywords: convenience

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

;; Who says one can't have typeout windows in GNU Emacs?   The entry
;; point, `electric-buffer-list' works like ^r select buffer from the
;; ITS Emacs lunar or tmacs libraries.

;;; Code:

(require 'electric)

(defvar electric-buffer-menu-mode-map
  (let ((map (make-keymap)))
    (fillarray (car (cdr map)) 'Electric-buffer-menu-undefined)
    (define-key map "\e" nil)
    (define-key map "\C-z" 'suspend-frame)
    (define-key map "v" 'Electric-buffer-menu-mode-view-buffer)
    (define-key map (char-to-string help-char) 'Helper-help)
    (define-key map "?" 'Helper-describe-bindings)
    (define-key map "\C-c" nil)
    (define-key map "\C-c\C-c" 'Electric-buffer-menu-quit)
    (define-key map "\C-]" 'Electric-buffer-menu-quit)
    (define-key map "q" 'Electric-buffer-menu-quit)
    (define-key map " " 'Electric-buffer-menu-select)
    (define-key map "\C-m" 'Electric-buffer-menu-select)
    (define-key map "\C-l" 'recenter)
    (define-key map "s" 'Buffer-menu-save)
    (define-key map "d" 'Buffer-menu-delete)
    (define-key map "k" 'Buffer-menu-delete)
    (define-key map "\C-d" 'Buffer-menu-delete-backwards)
    ;; (define-key map "\C-k" 'Buffer-menu-delete)
    (define-key map "\177" 'Buffer-menu-backup-unmark)
    (define-key map "~" 'Buffer-menu-not-modified)
    (define-key map "u" 'Buffer-menu-unmark)
    (let ((i ?0))
      (while (<= i ?9)
	(define-key map (char-to-string i) 'digit-argument)
	(define-key map (concat "\e" (char-to-string i)) 'digit-argument)
	(setq i (1+ i))))
    (define-key map "-" 'negative-argument)
    (define-key map "\e-" 'negative-argument)
    (define-key map "m" 'Buffer-menu-mark)
    (define-key map "\C-u" 'universal-argument)
    (define-key map "\C-p" 'previous-line)
    (define-key map "\C-n" 'next-line)
    (define-key map "p" 'previous-line)
    (define-key map "n" 'next-line)
    (define-key map "\C-v" 'scroll-up-command)
    (define-key map "\ev" 'scroll-down-command)
    (define-key map ">" 'scroll-right)
    (define-key map "<" 'scroll-left)
    (define-key map "\e\C-v" 'scroll-other-window)
    (define-key map "\e>" 'end-of-buffer)
    (define-key map "\e<" 'beginning-of-buffer)
    (define-key map "\e\e" nil)
    (define-key map "\e\e\e" 'Electric-buffer-menu-quit)
    ;; This binding prevents the "escape => ESC" function-key-map mapping from
    ;; kicking in!
    ;; (define-key map [escape escape escape] 'Electric-buffer-menu-quit)
    (define-key map [mouse-2] 'Electric-buffer-menu-mouse-select)
    map))

(put 'Electric-buffer-menu-quit :advertised-binding "\C-c\C-c")
(put 'Electric-buffer-menu-select :advertised-binding " ")
(put 'Helper-help :advertised-binding (char-to-string help-char))
(put 'Helper-describe-bindings :advertised-binding "?")

(defvar electric-buffer-menu-mode-hook nil
  "Normal hook run by `electric-buffer-menu-mode'.")

;;;###autoload
(defun electric-buffer-list (arg)
  "Pop up the Buffer Menu in an \"electric\" window.
If you type SPC or RET (`Electric-buffer-menu-select'), that
selects the buffer at point and quits the \"electric\" window.
Otherwise, you can move around in the Buffer Menu, marking
buffers to be selected, saved or deleted; these other commands
are much like those of `Buffer-menu-mode'.

Run hooks in `electric-buffer-menu-mode-hook' on entry.

\\<electric-buffer-menu-mode-map>
\\[keyboard-quit] or \\[Electric-buffer-menu-quit] -- exit buffer menu, returning to previous window and buffer
  configuration.  If the very first character typed is a space, it
  also has this effect.
\\[Electric-buffer-menu-select] -- select buffer of line point is on.
  Also show buffers marked with m in other windows,
  deletes buffers marked with \"D\", and saves those marked with \"S\".
\\[Buffer-menu-mark] -- mark buffer to be displayed.
\\[Buffer-menu-not-modified] -- clear modified-flag on that buffer.
\\[Buffer-menu-save] -- mark that buffer to be saved.
\\[Buffer-menu-delete] or \\[Buffer-menu-delete-backwards] -- mark that buffer to be deleted.
\\[Buffer-menu-unmark] -- remove all kinds of marks from current line.
\\[Electric-buffer-menu-mode-view-buffer] -- view buffer, returning when done.
\\[Buffer-menu-backup-unmark] -- back up a line and remove marks."
  (interactive "P")
  (let (select buffer)
    (save-window-excursion
      (setq buffer (list-buffers-noselect arg))
      (Electric-pop-up-window buffer)
      (unwind-protect
	  (let ((header header-line-format))
	    (set-buffer buffer)
	    (electric-buffer-menu-mode)
	    (setq header-line-format header)
	    (goto-char (point-min))
	    (if (search-forward "\n." nil t)
		(forward-char -1))
	    (electric-buffer-update-highlight)
	    (setq select
		  (catch 'electric-buffer-menu-select
		    (message "<<< Type SPC or RET to bury the buffer list >>>")
		    (setq unread-command-events (list (read-event)))
		    (let ((start-point (point))
			  (first (progn (goto-char (point-min))
					(unless Buffer-menu-use-header-line
					  (forward-line 2))
					(point)))
			  (last (progn (goto-char (point-max))
				       (forward-line -1)
				       (point)))
			  (goal-column 0))
		      ;; Use start-point if it is meaningful.
		      (goto-char (if (or (< start-point first)
					 (> start-point last))
				     first
				   start-point))
		      (Electric-command-loop 'electric-buffer-menu-select
					     nil
					     t
					     'electric-buffer-menu-looper
					     (cons first last))))))
	(set-buffer buffer)
	(Buffer-menu-mode)
	(bury-buffer)                ;Get rid of window, if dedicated.
	(message "")))
    (when select
      (set-buffer buffer)
      (let ((opoint (point-marker)))
	(Buffer-menu-execute)
	(goto-char (point-min))
	(if (prog1 (search-forward "\n>" nil t)
	      (goto-char opoint)
	      (set-marker opoint nil))
	    (Buffer-menu-select)
	  (switch-to-buffer (Buffer-menu-buffer t)))))))

(defun electric-buffer-menu-looper (state condition)
  (cond ((and condition
	      (not (memq (car condition) '(buffer-read-only
					   end-of-buffer
					   beginning-of-buffer))))
	 (signal (car condition) (cdr condition)))
	((< (point) (car state))
	 (goto-char (point-min))
	 (unless Buffer-menu-use-header-line
	   (forward-line 2)))
	((> (point) (cdr state))
	 (goto-char (point-max))
	 (forward-line -1)
	 (if (pos-visible-in-window-p (point-max))
	     (recenter -1))))
  (electric-buffer-update-highlight))

(defvar Helper-return-blurb)

(define-derived-mode electric-buffer-menu-mode Buffer-menu-mode
  "Electric Buffer Menu"
  "Toggle Electric Buffer Menu mode in this buffer.
With a prefix argument ARG, enable Long Lines mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

Electric Buffer Menu mode is a minor mode which is automatically
enabled and disabled by the \\[electric-buffer-list] command.
See the documentation of `electric-buffer-list' for details."
  (setq mode-line-buffer-identification "Electric Buffer List")
  (set (make-local-variable 'Helper-return-blurb)
       "return to buffer editing"))

(define-obsolete-function-alias 'Electric-buffer-menu-mode
  'electric-buffer-menu-mode "24.3")

;; generally the same as Buffer-menu-mode-map
;;  (except we don't indirect to global-map)
(put 'Electric-buffer-menu-undefined 'suppress-keymap t)

(defun Electric-buffer-menu-exit ()
  (interactive)
  (setq unread-command-events (listify-key-sequence (this-command-keys)))
  ;; for robustness
  (condition-case ()
      (throw 'electric-buffer-menu-select nil)
    (error (Buffer-menu-mode)
	   (other-buffer))))

(defun Electric-buffer-menu-select ()
  "Leave Electric Buffer Menu, selecting buffers and executing changes.
Save buffers marked \"S\".  Delete buffers marked \"K\".
Select buffer at point and display buffers marked \">\" in other windows."
  (interactive)
  (throw 'electric-buffer-menu-select (point)))

(defun Electric-buffer-menu-mouse-select (event)
  (interactive "e")
  (select-window (posn-window (event-end event)))
  (set-buffer (window-buffer (selected-window)))
  (goto-char (posn-point (event-end event)))
  (throw 'electric-buffer-menu-select (point)))

(defun Electric-buffer-menu-quit ()
  "Leave Electric Buffer Menu, restoring previous window configuration.
Skip execution of select, save, and delete commands."
  (interactive)
  (throw 'electric-buffer-menu-select nil))

(defun Electric-buffer-menu-undefined ()
  (interactive)
  (ding)
  (message "%s"
	   (substitute-command-keys "\
Type \\[Electric-buffer-menu-quit] to exit, \
\\[Electric-buffer-menu-select] to select, \
\\[Helper-help] for help, \\[Helper-describe-bindings] for commands."))
  (sit-for 4))

(defun Electric-buffer-menu-mode-view-buffer ()
  "View buffer on current line in Electric Buffer Menu.
Return to Electric Buffer Menu when done."
  (interactive)
  (let ((bufnam (Buffer-menu-buffer nil)))
    (if bufnam
	(view-buffer bufnam)
      (ding)
      (message "Buffer %s does not exist!" bufnam)
      (sit-for 4))))

(defvar electric-buffer-overlay nil)

(defun electric-buffer-update-highlight ()
  (when (derived-mode-p 'electric-buffer-menu-mode)
    ;; Make sure we have an overlay to use.
    (or electric-buffer-overlay
	(set (make-local-variable 'electric-buffer-overlay)
	     (make-overlay (point) (point))))
    (move-overlay electric-buffer-overlay
		  (line-beginning-position)
		  (line-end-position))
    (overlay-put electric-buffer-overlay 'face 'highlight)))

(provide 'ebuff-menu)

;;; ebuff-menu.el ends here
