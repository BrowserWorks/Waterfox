;;; debug.el --- debuggers and related commands for Emacs  -*- lexical-binding: t -*-

;; Copyright (C) 1985-1986, 1994, 2001-2014 Free Software Foundation,
;; Inc.

;; Maintainer: emacs-devel@gnu.org
;; Keywords: lisp, tools, maint

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

;; This is a major mode documented in the Emacs Lisp manual.

;;; Code:

(require 'button)

(defgroup debugger nil
  "Debuggers and related commands for Emacs."
  :prefix "debugger-"
  :group 'debug)

(defcustom debugger-mode-hook nil
  "Hooks run when `debugger-mode' is turned on."
  :type 'hook
  :group 'debugger
  :version "20.3")

(defcustom debugger-batch-max-lines 40
  "Maximum lines to show in debugger buffer in a noninteractive Emacs.
When the debugger is entered and Emacs is running in batch mode,
if the backtrace text has more than this many lines,
the middle is discarded, and just the beginning and end are displayed."
  :type 'integer
  :group 'debugger
  :version "21.1")

(defcustom debugger-bury-or-kill 'bury
  "What to do with the debugger buffer when exiting `debug'.
The value affects the behavior of operations on any window
previously showing the debugger buffer.

`nil' means that if its window is not deleted when exiting the
  debugger, invoking `switch-to-prev-buffer' will usually show
  the debugger buffer again.

`append' means that if the window is not deleted, the debugger
  buffer moves to the end of the window's previous buffers so
  it's less likely that a future invocation of
  `switch-to-prev-buffer' will switch to it.  Also, it moves the
  buffer to the end of the frame's buffer list.

`bury' means that if the window is not deleted, its buffer is
  removed from the window's list of previous buffers.  Also, it
  moves the buffer to the end of the frame's buffer list.  This
  value provides the most reliable remedy to not have
  `switch-to-prev-buffer' switch to the debugger buffer again
  without killing the buffer.

`kill' means to kill the debugger buffer.

The value used here is passed to `quit-restore-window'."
  :type '(choice
	  (const :tag "Keep alive" nil)
	  (const :tag "Append" append)
	  (const :tag "Bury" bury)
	  (const :tag "Kill" kill))
  :group 'debugger
  :version "24.3")

(defvar debugger-step-after-exit nil
  "Non-nil means \"single-step\" after the debugger exits.")

(defvar debugger-value nil
  "This is the value for the debugger to return, when it returns.")

(defvar debugger-old-buffer nil
  "This is the buffer that was current when the debugger was entered.")

(defvar debugger-previous-window nil
  "This is the window last showing the debugger buffer.")

(defvar debugger-previous-window-height nil
  "The last recorded height of `debugger-previous-window'.")

(defvar debugger-previous-backtrace nil
  "The contents of the previous backtrace (including text properties).
This is to optimize `debugger-make-xrefs'.")

(defvar debugger-outer-match-data)
(defvar debugger-will-be-back nil
  "Non-nil if we expect to get back in the debugger soon.")

(defvar inhibit-debug-on-entry nil
  "Non-nil means that debug-on-entry is disabled.")

(defvar debugger-jumping-flag nil
  "Non-nil means that debug-on-entry is disabled.
This variable is used by `debugger-jump', `debugger-step-through',
and `debugger-reenable' to temporarily disable debug-on-entry.")

(defvar inhibit-trace)                  ;Not yet implemented.

(defvar debugger-args nil
  "Arguments with which the debugger was called.
It is a list expected to take the form (CAUSE . REST)
where CAUSE can be:
- debug: called for entry to a flagged function.
- t: called because of debug-on-next-call.
- lambda: same thing but via `funcall'.
- exit: called because of exit of a flagged function.
- error: called because of `debug-on-error'.")

;;;###autoload
(setq debugger 'debug)
;;;###autoload
(defun debug (&rest args)
  "Enter debugger.  \\<debugger-mode-map>`\\[debugger-continue]' returns from the debugger.
Arguments are mainly for use when this is called from the internals
of the evaluator.

You may call with no args, or you may pass nil as the first arg and
any other args you like.  In that case, the list of args after the
first will be printed into the backtrace buffer."
  (interactive)
  (if inhibit-redisplay
      ;; Don't really try to enter debugger within an eval from redisplay.
      debugger-value
    (unless noninteractive
      (message "Entering debugger..."))
    (let (debugger-value
	  (debugger-previous-state
           (if (get-buffer "*Backtrace*")
               (with-current-buffer (get-buffer "*Backtrace*")
                 (list major-mode (buffer-string)))))
          (debugger-args args)
	  (debugger-buffer (get-buffer-create "*Backtrace*"))
	  (debugger-old-buffer (current-buffer))
	  (debugger-window nil)
	  (debugger-step-after-exit nil)
          (debugger-will-be-back nil)
	  ;; Don't keep reading from an executing kbd macro!
	  (executing-kbd-macro nil)
	  ;; Save the outer values of these vars for the `e' command
	  ;; before we replace the values.
	  (debugger-outer-match-data (match-data))
	  (debugger-with-timeout-suspend (with-timeout-suspend)))
      ;; Set this instead of binding it, so that `q'
      ;; will not restore it.
      (setq overriding-terminal-local-map nil)
      ;; Don't let these magic variables affect the debugger itself.
      (let ((last-command nil) this-command track-mouse
	    (inhibit-trace t)
	    (inhibit-debug-on-entry t)
	    unread-command-events
	    unread-post-input-method-events
	    last-input-event last-command-event last-nonmenu-event
	    last-event-frame
	    overriding-local-map
	    load-read-function
	    ;; If we are inside a minibuffer, allow nesting
	    ;; so that we don't get an error from the `e' command.
	    (enable-recursive-minibuffers
	     (or enable-recursive-minibuffers (> (minibuffer-depth) 0)))
	    (standard-input t) (standard-output t)
	    inhibit-redisplay
	    (cursor-in-echo-area nil)
	    (window-configuration (current-window-configuration)))
	(unwind-protect
	    (save-excursion
	      (when (eq (car debugger-args) 'debug)
		;; Skip the frames for backtrace-debug, byte-code,
		;; debug--implement-debug-on-entry and the advice's `apply'.
		(backtrace-debug 4 t)
		;; Place an extra debug-on-exit for macro's.
		(when (eq 'lambda (car-safe (cadr (backtrace-frame 4))))
		  (backtrace-debug 5 t)))
	      (pop-to-buffer
	       debugger-buffer
	       `((display-buffer-reuse-window
		  display-buffer-in-previous-window)
		  . (,(when debugger-previous-window
			`(previous-window . ,debugger-previous-window)))))
	      (setq debugger-window (selected-window))
	      (if (eq debugger-previous-window debugger-window)
		  (when debugger-jumping-flag
		    ;; Try to restore previous height of debugger
		    ;; window.
		    (condition-case nil
			(window-resize
			 debugger-window
			 (- debugger-previous-window-height
			    (window-total-height debugger-window)))
		      (error nil)))
		(setq debugger-previous-window debugger-window))
	      (debugger-mode)
	      (debugger-setup-buffer debugger-args)
	      (when noninteractive
		;; If the backtrace is long, save the beginning
		;; and the end, but discard the middle.
		(when (> (count-lines (point-min) (point-max))
			 debugger-batch-max-lines)
		  (goto-char (point-min))
		  (forward-line (/ 2 debugger-batch-max-lines))
		  (let ((middlestart (point)))
		    (goto-char (point-max))
		    (forward-line (- (/ 2 debugger-batch-max-lines)
				     debugger-batch-max-lines))
		    (delete-region middlestart (point)))
		  (insert "...\n"))
		(goto-char (point-min))
		(message "%s" (buffer-string))
		(kill-emacs -1))
	      (message "")
	      (let ((standard-output nil)
		    (buffer-read-only t))
		(message "")
		;; Make sure we unbind buffer-read-only in the right buffer.
		(save-excursion
		  (recursive-edit))))
	  (when (and (window-live-p debugger-window)
		     (eq (window-buffer debugger-window) debugger-buffer))
	    ;; Record height of debugger window.
	    (setq debugger-previous-window-height
		  (window-total-height debugger-window)))
	  (if debugger-will-be-back
	      ;; Restore previous window configuration (Bug#12623).
	      (set-window-configuration window-configuration)
	    (when (and (window-live-p debugger-window)
		       (eq (window-buffer debugger-window) debugger-buffer))
	      (progn
		;; Unshow debugger-buffer.
		(quit-restore-window debugger-window debugger-bury-or-kill)
		;; Restore current buffer (Bug#12502).
		(set-buffer debugger-old-buffer))))
          ;; Restore previous state of debugger-buffer in case we were
          ;; in a recursive invocation of the debugger, otherwise just
          ;; erase the buffer and put it into fundamental mode.
	  (when (buffer-live-p debugger-buffer)
	    (with-current-buffer debugger-buffer
	      (let ((inhibit-read-only t))
		(erase-buffer)
		(if (null debugger-previous-state)
		    (fundamental-mode)
		  (insert (nth 1 debugger-previous-state))
		  (funcall (nth 0 debugger-previous-state))))))
	  (with-timeout-unsuspend debugger-with-timeout-suspend)
	  (set-match-data debugger-outer-match-data)))
      (setq debug-on-next-call debugger-step-after-exit)
      debugger-value)))

(defun debugger-setup-buffer (args)
  "Initialize the `*Backtrace*' buffer for entry to the debugger.
That buffer should be current already."
  (setq buffer-read-only nil)
  (erase-buffer)
  (set-buffer-multibyte t)		;Why was it nil ?  -stef
  (setq buffer-undo-list t)
  (let ((standard-output (current-buffer))
	(print-escape-newlines t)
	(print-level 8)
	(print-length 50))
    (backtrace))
  (goto-char (point-min))
  (delete-region (point)
		 (progn
		   (search-forward "\n  debug(")
		   (forward-line (if (eq (car args) 'debug)
                                     ;; Remove debug--implement-debug-on-entry
                                     ;; and the advice's `apply' frame.
				     3
				   1))
		   (point)))
  (insert "Debugger entered")
  ;; lambda is for debug-on-call when a function call is next.
  ;; debug is for debug-on-entry function called.
  (let ((pos (point)))
    (pcase (car args)
      ((or `lambda `debug)
       (insert "--entering a function:\n")
       (setq pos (1- (point))))
      ;; Exiting a function.
      (`exit
       (insert "--returning value: ")
       (setq pos (point))
       (setq debugger-value (nth 1 args))
       (prin1 debugger-value (current-buffer))
       (insert ?\n)
       (delete-char 1)
       (insert ? )
       (beginning-of-line))
      ;; Debugger entered for an error.
      (`error
       (insert "--Lisp error: ")
       (setq pos (point))
       (prin1 (nth 1 args) (current-buffer))
       (insert ?\n))
      ;; debug-on-call, when the next thing is an eval.
      (`t
       (insert "--beginning evaluation of function call form:\n")
       (setq pos (1- (point))))
      ;; User calls debug directly.
      (_
       (insert ": ")
       (setq pos (point))
       (prin1 (if (eq (car args) 'nil)
                  (cdr args) args)
              (current-buffer))
       (insert ?\n)))
    ;; Place point on "stack frame 0" (bug#15101).
    (goto-char pos))
  ;; After any frame that uses eval-buffer,
  ;; insert a line that states the buffer position it's reading at.
  (save-excursion
    (let ((tem eval-buffer-list))
      (while (and tem
		  (re-search-forward "^  eval-\\(buffer\\|region\\)(" nil t))
	(end-of-line)
	(insert (format "  ; Reading at buffer position %d"
			;; This will get the wrong result
			;; if there are two nested eval-region calls
			;; for the same buffer.  That's not a very useful case.
			(with-current-buffer (car tem)
			  (point))))
	(pop tem))))
  (debugger-make-xrefs))

(defun debugger-make-xrefs (&optional buffer)
  "Attach cross-references to function names in the `*Backtrace*' buffer."
  (interactive "b")
  (with-current-buffer (or buffer (current-buffer))
    (save-excursion
      (setq buffer (current-buffer))
      (let ((inhibit-read-only t)
	    (old-end (point-min)) (new-end (point-min)))
	;; If we saved an old backtrace, find the common part
	;; between the new and the old.
	;; Compare line by line, starting from the end,
	;; because that's the part that is likely to be unchanged.
	(if debugger-previous-backtrace
	    (let (old-start new-start (all-match t))
	      (goto-char (point-max))
	      (with-temp-buffer
		(insert debugger-previous-backtrace)
		(while (and all-match (not (bobp)))
		  (setq old-end (point))
		  (forward-line -1)
		  (setq old-start (point))
		  (with-current-buffer buffer
		    (setq new-end (point))
		    (forward-line -1)
		    (setq new-start (point)))
		  (if (not (zerop
			    (let ((case-fold-search nil))
			      (compare-buffer-substrings
			       (current-buffer) old-start old-end
			       buffer new-start new-end))))
		      (setq all-match nil))))
	      ;; Now new-end is the position of the start of the
	      ;; unchanged part in the current buffer, and old-end is
	      ;; the position of that same text in the saved old
	      ;; backtrace.  But we must subtract (point-min) since strings are
	      ;; indexed in origin 0.

	      ;; Replace the unchanged part of the backtrace
	      ;; with the text from debugger-previous-backtrace,
	      ;; since that already has the proper xrefs.
	      ;; With this optimization, we only need to scan
	      ;; the changed part of the backtrace.
	      (delete-region new-end (point-max))
	      (goto-char (point-max))
	      (insert (substring debugger-previous-backtrace
				 (- old-end (point-min))))
	      ;; Make the unchanged part of the backtrace inaccessible
	      ;; so it won't be scanned.
	      (narrow-to-region (point-min) new-end)))

	;; Scan the new part of the backtrace, inserting xrefs.
	(goto-char (point-min))
	(while (progn
		 (goto-char (+ (point) 2))
		 (skip-syntax-forward "^w_")
		 (not (eobp)))
	  (let* ((beg (point))
		 (end (progn (skip-syntax-forward "w_") (point)))
		 (sym (intern-soft (buffer-substring-no-properties
				    beg end)))
		 (file (and sym (symbol-file sym 'defun))))
	    (when file
	      (goto-char beg)
	      ;; help-xref-button needs to operate on something matched
	      ;; by a regexp, so set that up for it.
	      (re-search-forward "\\(\\sw\\|\\s_\\)+")
	      (help-xref-button 0 'help-function-def sym file)))
	  (forward-line 1))
	(widen))
      (setq debugger-previous-backtrace (buffer-string)))))

(defun debugger-step-through ()
  "Proceed, stepping through subexpressions of this expression.
Enter another debugger on next entry to eval, apply or funcall."
  (interactive)
  (setq debugger-step-after-exit t)
  (setq debugger-jumping-flag t)
  (setq debugger-will-be-back t)
  (add-hook 'post-command-hook 'debugger-reenable)
  (message "Proceeding, will debug on next eval or call.")
  (exit-recursive-edit))

(defun debugger-continue ()
  "Continue, evaluating this expression without stopping."
  (interactive)
  (unless debugger-may-continue
    (error "Cannot continue"))
  (message "Continuing.")
  (save-excursion
    ;; Check to see if we've flagged some frame for debug-on-exit, in which
    ;; case we'll probably come back to the debugger soon.
    (goto-char (point-min))
    (if (re-search-forward "^\\* " nil t)
        (setq debugger-will-be-back t)))
  (exit-recursive-edit))

(defun debugger-return-value (val)
  "Continue, specifying value to return.
This is only useful when the value returned from the debugger
will be used, such as in a debug on exit from a frame."
  (interactive "XReturn value (evaluated): ")
  (when (memq (car debugger-args) '(t lambda error debug))
    (error "Cannot return a value %s"
           (if (eq (car debugger-args) 'error)
               "from an error" "at function entrance")))
  (setq debugger-value val)
  (princ "Returning " t)
  (prin1 debugger-value)
  (save-excursion
    ;; Check to see if we've flagged some frame for debug-on-exit, in which
    ;; case we'll probably come back to the debugger soon.
    (goto-char (point-min))
    (if (re-search-forward "^\\* " nil t)
        (setq debugger-will-be-back t)))
  (exit-recursive-edit))

(defun debugger-jump ()
  "Continue to exit from this frame, with all debug-on-entry suspended."
  (interactive)
  (debugger-frame)
  (setq debugger-jumping-flag t)
  (add-hook 'post-command-hook 'debugger-reenable)
  (message "Continuing through this frame")
  (setq debugger-will-be-back t)
  (exit-recursive-edit))

(defun debugger-reenable ()
  "Turn all debug-on-entry functions back on.
This function is put on `post-command-hook' by `debugger-jump' and
removes itself from that hook."
  (setq debugger-jumping-flag nil)
  (remove-hook 'post-command-hook 'debugger-reenable))

(defun debugger-frame-number (&optional skip-base)
  "Return number of frames in backtrace before the one point points at."
  (save-excursion
    (beginning-of-line)
    (if (looking-at " *;;;\\|[a-z]")
	(error "This line is not a function call"))
    (let ((opoint (point))
	  (count 0))
      (unless skip-base
        (while (not (eq (cadr (backtrace-frame count)) 'debug))
          (setq count (1+ count)))
        ;; Skip debug--implement-debug-on-entry frame.
        (when (eq 'debug--implement-debug-on-entry
                  (cadr (backtrace-frame (1+ count))))
          (setq count (+ 2 count))))
      (goto-char (point-min))
      (when (looking-at "Debugger entered--\\(Lisp error\\|returning value\\):")
	(goto-char (match-end 0))
	(forward-sexp 1))
      (forward-line 1)
      (while (progn
	       (forward-char 2)
	       (cond ((debugger--locals-visible-p)
		      (goto-char (next-single-char-property-change
				  (point) 'locals-visible)))
		     ((= (following-char) ?\()
		      (forward-sexp 1))
		     (t
		      (forward-sexp 2)))
	       (forward-line 1)
	       (<= (point) opoint))
	(if (looking-at " *;;;")
	    (forward-line 1))
	(setq count (1+ count)))
      count)))

(defun debugger-frame ()
  "Request entry to debugger when this frame exits.
Applies to the frame whose line point is on in the backtrace."
  (interactive)
  (backtrace-debug (debugger-frame-number) t)
  (beginning-of-line)
  (if (= (following-char) ? )
      (let ((inhibit-read-only t))
	(delete-char 1)
	(insert ?*)))
  (beginning-of-line))

(defun debugger-frame-clear ()
  "Do not enter debugger when this frame exits.
Applies to the frame whose line point is on in the backtrace."
  (interactive)
  (backtrace-debug (debugger-frame-number) nil)
  (beginning-of-line)
  (if (= (following-char) ?*)
      (let ((inhibit-read-only t))
	(delete-char 1)
	(insert ? )))
  (beginning-of-line))

(defmacro debugger-env-macro (&rest body)
  "Run BODY in original environment."
  (declare (indent 0))
  `(save-excursion
    (if (null (buffer-live-p debugger-old-buffer))
        ;; old buffer deleted
        (setq debugger-old-buffer (current-buffer)))
    (set-buffer debugger-old-buffer)
    (set-match-data debugger-outer-match-data)
    (prog1
        (progn ,@body)
      (setq debugger-outer-match-data (match-data)))))

(defun debugger--backtrace-base ()
  "Return the function name that marks the top of the backtrace.
See `backtrace-frame'."
  (cond ((eq 'debug--implement-debug-on-entry
	     (cadr (backtrace-frame 1 'debug)))
	 'debug--implement-debug-on-entry)
	(t 'debug)))

(defun debugger-eval-expression (exp &optional nframe)
  "Eval an expression, in an environment like that outside the debugger.
The environment used is the one when entering the activation frame at point."
  (interactive
   (list (read--expression "Eval in stack frame: ")))
  (let ((nframe (or nframe
                    (condition-case nil (1+ (debugger-frame-number 'skip-base))
                      (error 0)))) ;; If on first line.
	(base (debugger--backtrace-base)))
    (debugger-env-macro
      (let ((val (backtrace-eval exp nframe base)))
        (prog1
            (prin1 val t)
          (let ((str (eval-expression-print-format val)))
            (if str (princ str t))))))))

(defun debugger--locals-visible-p ()
  "Are the local variables of the current stack frame visible?"
  (save-excursion
    (move-to-column 2)
    (get-text-property (point) 'locals-visible)))

(defun debugger--insert-locals (locals)
  "Insert the local variables LOCALS at point."
  (cond ((null locals)
	 (insert "\n    [no locals]"))
	(t
	 (let ((print-escape-newlines t))
	   (dolist (s+v locals)
	     (let ((symbol (car s+v))
		   (value (cdr s+v)))
	       (insert "\n    ")
	       (prin1 symbol (current-buffer))
	       (insert " = ")
	       (prin1 value (current-buffer))))))))

(defun debugger--show-locals ()
  "For the frame at point, insert locals and add text properties."
  (let* ((nframe (1+ (debugger-frame-number 'skip-base)))
	 (base (debugger--backtrace-base))
	 (locals (backtrace--locals nframe base))
	 (inhibit-read-only t))
    (save-excursion
      (let ((start (progn
		     (move-to-column 2)
		     (point))))
	(end-of-line)
	(debugger--insert-locals locals)
	(add-text-properties start (point) '(locals-visible t))))))

(defun debugger--hide-locals ()
  "Delete local variables and remove the text property."
  (let* ((col (current-column))
	 (end (progn
		(move-to-column 2)
		(next-single-char-property-change (point) 'locals-visible)))
	 (start (previous-single-char-property-change end 'locals-visible))
	 (inhibit-read-only t))
    (remove-text-properties start end '(locals-visible))
    (goto-char start)
    (end-of-line)
    (delete-region (point) end)
    (move-to-column col)))

(defun debugger-toggle-locals ()
  "Show or hide local variables of the current stack frame."
  (interactive)
  (cond ((debugger--locals-visible-p)
	 (debugger--hide-locals))
	(t
	 (debugger--show-locals))))


(defvar debugger-mode-map
  (let ((map (make-keymap))
	(menu-map (make-sparse-keymap)))
    (set-keymap-parent map button-buffer-map)
    (suppress-keymap map)
    (define-key map "-" 'negative-argument)
    (define-key map "b" 'debugger-frame)
    (define-key map "c" 'debugger-continue)
    (define-key map "j" 'debugger-jump)
    (define-key map "r" 'debugger-return-value)
    (define-key map "u" 'debugger-frame-clear)
    (define-key map "d" 'debugger-step-through)
    (define-key map "l" 'debugger-list-functions)
    (define-key map "h" 'describe-mode)
    (define-key map "q" 'top-level)
    (define-key map "e" 'debugger-eval-expression)
    (define-key map "v" 'debugger-toggle-locals) ; "v" is for "variables".
    (define-key map " " 'next-line)
    (define-key map "R" 'debugger-record-expression)
    (define-key map "\C-m" 'debug-help-follow)
    (define-key map [mouse-2] 'push-button)
    (define-key map [menu-bar debugger] (cons "Debugger" menu-map))
    (define-key menu-map [deb-top]
      '(menu-item "Quit" top-level
		  :help "Quit debugging and return to top level"))
    (define-key menu-map [deb-s0] '("--"))
    (define-key menu-map [deb-descr]
      '(menu-item "Describe Debugger Mode" describe-mode
		  :help "Display documentation for debugger-mode"))
    (define-key menu-map [deb-hfol]
      '(menu-item "Help Follow" debug-help-follow
		  :help "Follow cross-reference"))
    (define-key menu-map [deb-nxt]
      '(menu-item "Next Line" next-line
		  :help "Move cursor down"))
    (define-key menu-map [deb-s1] '("--"))
    (define-key menu-map [deb-lfunc]
      '(menu-item "List debug on entry functions" debugger-list-functions
		  :help "Display a list of all the functions now set to debug on entry"))
    (define-key menu-map [deb-fclear]
      '(menu-item "Cancel debug frame" debugger-frame-clear
		  :help "Do not enter debugger when this frame exits"))
    (define-key menu-map [deb-frame]
      '(menu-item "Debug frame" debugger-frame
		  :help "Request entry to debugger when this frame exits"))
    (define-key menu-map [deb-s2] '("--"))
    (define-key menu-map [deb-ret]
      '(menu-item "Return value..." debugger-return-value
		  :help "Continue, specifying value to return."))
    (define-key menu-map [deb-rec]
      '(menu-item "Display and Record Expression" debugger-record-expression
		  :help "Display a variable's value and record it in `*Backtrace-record*' buffer"))
    (define-key menu-map [deb-eval]
      '(menu-item "Eval Expression..." debugger-eval-expression
		  :help "Eval an expression, in an environment like that outside the debugger"))
    (define-key menu-map [deb-jump]
      '(menu-item "Jump" debugger-jump
		  :help "Continue to exit from this frame, with all debug-on-entry suspended"))
    (define-key menu-map [deb-cont]
      '(menu-item "Continue" debugger-continue
	:help "Continue, evaluating this expression without stopping"))
    (define-key menu-map [deb-step]
      '(menu-item "Step through" debugger-step-through
	:help "Proceed, stepping through subexpressions of this expression"))
    map))

(put 'debugger-mode 'mode-class 'special)

(define-derived-mode debugger-mode fundamental-mode "Debugger"
  "Mode for backtrace buffers, selected in debugger.
\\<debugger-mode-map>
A line starts with `*' if exiting that frame will call the debugger.
Type \\[debugger-frame] or \\[debugger-frame-clear] to set or remove the `*'.

When in debugger due to frame being exited,
use the \\[debugger-return-value] command to override the value
being returned from that frame.

Use \\[debug-on-entry] and \\[cancel-debug-on-entry] to control
which functions will enter the debugger when called.

Complete list of commands:
\\{debugger-mode-map}"
  (setq truncate-lines t)
  (set-syntax-table emacs-lisp-mode-syntax-table)
  (use-local-map debugger-mode-map))

(defcustom debugger-record-buffer "*Debugger-record*"
  "Buffer name for expression values, for \\[debugger-record-expression]."
  :type 'string
  :group 'debugger
  :version "20.3")

(defun debugger-record-expression  (exp)
  "Display a variable's value and record it in `*Backtrace-record*' buffer."
  (interactive
   (list (read--expression "Record Eval: ")))
  (let* ((buffer (get-buffer-create debugger-record-buffer))
	 (standard-output buffer))
    (princ (format "Debugger Eval (%s): " exp))
    (princ (debugger-eval-expression exp))
    (terpri))

  (with-current-buffer (get-buffer debugger-record-buffer)
    (message "%s"
	     (buffer-substring (line-beginning-position 0)
			       (line-end-position 0)))))

(declare-function help-xref-interned "help-mode" (symbol))

(defun debug-help-follow (&optional pos)
  "Follow cross-reference at POS, defaulting to point.

For the cross-reference format, see `help-make-xrefs'."
  (interactive "d")
  (require 'help-mode)
  ;; Ideally we'd just do (call-interactively 'help-follow) except that this
  ;; assumes we're already in a *Help* buffer and reuses it, so it ends up
  ;; incorrectly "reusing" the *Backtrace* buffer to show the help info.
  (unless pos
    (setq pos (point)))
  (unless (push-button pos)
    ;; check if the symbol under point is a function or variable
    (let ((sym
	   (intern
	    (save-excursion
	      (goto-char pos) (skip-syntax-backward "w_")
	      (buffer-substring (point)
				(progn (skip-syntax-forward "w_")
				       (point)))))))
      (when (or (boundp sym) (fboundp sym) (facep sym))
        (help-xref-interned sym)))))

;; When you change this, you may also need to change the number of
;; frames that the debugger skips.
(defun debug--implement-debug-on-entry (&rest _ignore)
  "Conditionally call the debugger.
A call to this function is inserted by `debug-on-entry' to cause
functions to break on entry."
  (if (or inhibit-debug-on-entry debugger-jumping-flag)
      nil
    (funcall debugger 'debug)))

;;;###autoload
(defun debug-on-entry (function)
  "Request FUNCTION to invoke debugger each time it is called.

When called interactively, prompt for FUNCTION in the minibuffer.

This works by modifying the definition of FUNCTION.  If you tell the
debugger to continue, FUNCTION's execution proceeds.  If FUNCTION is a
normal function or a macro written in Lisp, you can also step through
its execution.  FUNCTION can also be a primitive that is not a special
form, in which case stepping is not possible.  Break-on-entry for
primitive functions only works when that function is called from Lisp.

Use \\[cancel-debug-on-entry] to cancel the effect of this command.
Redefining FUNCTION also cancels it."
  (interactive
   (let ((fn (function-called-at-point)) val)
     (when (special-form-p fn)
       (setq fn nil))
     (setq val (completing-read
		(if fn
		    (format "Debug on entry to function (default %s): " fn)
		  "Debug on entry to function: ")
		obarray
		#'(lambda (symbol)
		    (and (fboundp symbol)
			 (not (special-form-p symbol))))
		t nil nil (symbol-name fn)))
     (list (if (equal val "") fn (intern val)))))
  (advice-add function :before #'debug--implement-debug-on-entry
              '((depth . -100)))
  function)

(defun debug--function-list ()
  "List of functions currently set for debug on entry."
  (let ((funs '()))
    (mapatoms
     (lambda (s)
       (when (advice-member-p #'debug--implement-debug-on-entry s)
         (push s funs))))
    funs))

;;;###autoload
(defun cancel-debug-on-entry (&optional function)
  "Undo effect of \\[debug-on-entry] on FUNCTION.
If FUNCTION is nil, cancel debug-on-entry for all functions.
When called interactively, prompt for FUNCTION in the minibuffer.
To specify a nil argument interactively, exit with an empty minibuffer."
  (interactive
   (list (let ((name
		(completing-read
		 "Cancel debug on entry to function (default all functions): "
		 (mapcar #'symbol-name (debug--function-list)) nil t)))
	   (when name
	     (unless (string= name "")
	       (intern name))))))
  (if function
      (progn
        (advice-remove function #'debug--implement-debug-on-entry)
	function)
    (message "Canceling debug-on-entry for all functions")
    (mapcar #'cancel-debug-on-entry (debug--function-list))))

(defun debugger-list-functions ()
  "Display a list of all the functions now set to debug on entry."
  (interactive)
  (require 'help-mode)
  (help-setup-xref '(debugger-list-functions)
		   (called-interactively-p 'interactive))
  (with-output-to-temp-buffer (help-buffer)
    (with-current-buffer standard-output
      (let ((funs (debug--function-list)))
        (if (null funs)
            (princ "No debug-on-entry functions now\n")
          (princ "Functions set to debug on entry:\n\n")
          (dolist (fun funs)
            (make-text-button (point) (progn (prin1 fun) (point))
                              'type 'help-function
                              'help-args (list fun))
            (terpri))
          (terpri)
          (princ "Note: if you have redefined a function, then it may no longer\n")
          (princ "be set to debug on entry, even if it is in the list."))))))

(provide 'debug)

;;; debug.el ends here
