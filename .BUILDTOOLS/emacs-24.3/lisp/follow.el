;;; follow.el --- synchronize windows showing the same buffer
;; Copyright (C) 1995-1997, 1999, 2001-2013 Free Software Foundation,
;; Inc.

;; Author: Anders Lindgren <andersl@andersl.com>
;; Maintainer: FSF (Anders' email bounces, Sep 2005)
;; Created: 1995-05-25
;; Keywords: display, window, minor-mode, convenience

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

;; `Follow mode' is a minor mode for Emacs and XEmacs that
;; combines windows into one tall virtual window.
;;
;; The feeling of a "virtual window" has been accomplished by the use
;; of two major techniques:
;;
;; * The windows always display adjacent sections of the buffer.
;;   This means that whenever one window is moved, all the
;;   others will follow.  (Hence the name Follow mode.)
;;
;; * Should the point (cursor) end up outside a window, another
;;   window displaying that point is selected, if possible.  This
;;   makes it possible to walk between windows using normal cursor
;;   movement commands.
;;
;; Follow mode comes to its prime when a large screen and two
;; side-by-side window are used.  The user can, with the help of Follow
;; mode, use two full-height windows as though they are one.
;; Imagine yourself editing a large function, or section of text,
;; and being able to use 144 lines instead of the normal 72... (your
;; mileage may vary).

;; To test this package, make sure `follow' is loaded, or will be
;; autoloaded when activated (see below).  Then do the following:
;;
;; * Find your favorite file (preferably a long one).
;;
;; * Resize Emacs so that it will be wide enough for two full size
;;   columns.  Delete the other windows and split the window with
;;   the commands `C-x 1 C-x 3'.
;;
;; * Give the command:
;;	M-x follow-mode <RETURN>
;;
;; * Now the display should look something like (assuming the text "71"
;;   is on line 71):
;;
;;		    +----------+----------+
;;		    |1         |73        |
;;		    |2         |74        |
;;		    |3         |75        |
;;		         ...        ...
;;		    |71        |143       |
;;		    |72        |144       |
;;		    +----------+----------+
;;
;;   As you can see, the right-hand window starts at line 73, the line
;;   immediately below the end of the left-hand window.  As long as
;;   `follow-mode' is active, the two windows will follow each other!
;;
;; * Play around and enjoy! Scroll one window and watch the other.
;;   Jump to the beginning or end.  Press `Cursor down' at the last
;;   line of the left-hand window.  Enter new lines into the
;;   text.  Enter long lines spanning several lines, or several
;;   windows.
;;
;; * Should you find `Follow' mode annoying, just type
;;	M-x follow-mode <RETURN>
;;   to turn it off.


;; The command `follow-delete-other-windows-and-split' maximizes the
;; visible area of the current buffer.
;;
;; I recommend adding it, and `follow-mode', to hotkeys in the global
;; key map.  To do so, add the following lines (replacing `[f7]' and
;; `[f8]' with your favorite keys) to the init file:
;;
;; (global-set-key [f8] 'follow-mode)
;; (global-set-key [f7] 'follow-delete-other-windows-and-split)


;; There exist two system variables that control the appearance of
;; lines wider than the window containing them.  The default is to
;; truncate long lines whenever a window isn't as wide as the frame.
;;
;; To make sure lines are never truncated, please place the following
;; lines in your init file:
;;
;; (setq truncate-lines nil)
;; (setq truncate-partial-width-windows nil)


;; The correct way to configure Follow mode, or any other mode for
;; that matter, is to create one or more functions that do
;; whatever you would like to do.  These functions are then added to
;; a hook.
;;
;; The keymap `follow-key-map' contains key bindings activated by
;; `follow-mode'.
;;
;; Example:
;; (add-hook 'follow-mode-hook 'my-follow-mode-hook)
;;
;; (defun my-follow-mode-hook ()
;;    (define-key follow-mode-map "\C-ca" 'your-favorite-function)
;;    (define-key follow-mode-map "\C-cb" 'another-function))


;; Usage:
;;
;; To activate, issue the command "M-x follow-mode"
;; and press Return.  To deactivate, do it again.
;;
;; The following is a list of commands useful when follow-mode is active.
;;
;;	follow-scroll-up			 C-c . C-v
;;		Scroll text in a Follow mode window chain up.
;;
;;	follow-scroll-down			 C-c . v
;;		Like `follow-scroll-up', but in the other direction.
;;
;;	follow-delete-other-windows-and-split	 C-c . 1
;;		Maximize the visible area of the current buffer,
;;		and enter Follow mode. 	This is a very convenient
;;		way to start Follow mode, hence we recommend that
;;		this command be added to the global keymap.
;;
;;	follow-recenter				 C-c . C-l
;;		Place the point in the center of the middle window,
;;		or a specified number of lines from either top or bottom.
;;
;;	follow-switch-to-buffer			 C-c . b
;;		Switch buffer in all windows displaying the current buffer
;;		in this frame.
;;
;;	follow-switch-to-buffer-all		 C-c . C-b
;;		Switch buffer in all windows in the selected frame.
;;
;;	follow-switch-to-current-buffer-all
;;		Show the current buffer in all windows on the current
;;		frame and turn on `follow-mode'.
;;
;;	follow-first-window			 C-c . <
;;		Select the first window in the frame showing the same buffer.
;;
;;	follow-last-window			 C-c . >
;;		Select the last window in the frame showing the same buffer.
;;
;;	follow-next-window			 C-c . n
;;		Select the next window in the frame showing the same buffer.
;;
;;	follow-previous-window			 C-c . p
;;		Select the previous window showing the same buffer.


;; Well, it seems ok, but what if I really want to look at two different
;; positions in the text? Here are two simple methods to use:
;;
;; 1) Use multiple frames; `follow' mode only affects windows displayed
;;    in the same frame. (My apologies to you who can't use frames.)
;;
;; 2) Bind `follow-mode' to key so you can turn it off whenever
;;    you want to view two locations.  Of course, `follow' mode can
;;    be reactivated by hitting the same key again.
;;
;;    Example from my ~/.emacs:
;;	(global-set-key [f8] 'follow-mode)

;; Implementation:
;;
;; The main method by which Follow mode aligns windows is via the
;; function `follow-post-command-hook', which is run after each
;; command.  This "fixes up" the alignment of other windows which are
;; showing the same Follow mode buffer, on the same frame as the
;; selected window.  It does not try to deal with buffers other than
;; the buffer of the selected frame, or windows on other frames.
;;
;; Comint mode specially calls `follow-comint-scroll-to-bottom' on
;; Follow mode buffers.  This function scrolls the bottom-most window
;; in a window chain and aligns the other windows accordingly.  Follow
;; mode adds a function to `compilation-filter-hook' to align
;; compilation buffers.

;;; Code:

(require 'easymenu)

;;; Variables

(defgroup follow nil
  "Synchronize windows showing the same buffer."
  :group 'windows
  :group 'convenience)

(defcustom follow-mode-hook nil
  "Normal hook run by `follow-mode'."
  :type 'hook
  :group 'follow)

;;; Keymap/Menu

;; Define keys for the follow-mode minor mode map and replace some
;; functions in the global map.  All Follow mode special functions can
;; be found on the `C-c .' prefix key.
;;
;; To change the prefix, redefine `follow-mode-prefix' before `follow'
;; is loaded, or see the section on `follow-mode-hook' above for an
;; example of how to bind the keys the way you like.

(defcustom follow-mode-prefix "\C-c."
  "Prefix key to use for follow commands in Follow mode.
The value of this variable is checked as part of loading Follow mode.
After that, changing the prefix key requires manipulating keymaps."
  :type 'string
  :group 'follow)

(defvar follow-mode-map
  (let ((mainmap (make-sparse-keymap))
        (map (make-sparse-keymap)))
    (define-key map "\C-v"	'follow-scroll-up)
    (define-key map "\M-v"	'follow-scroll-down)
    (define-key map "v"		'follow-scroll-down)
    (define-key map "1"		'follow-delete-other-windows-and-split)
    (define-key map "b"		'follow-switch-to-buffer)
    (define-key map "\C-b"	'follow-switch-to-buffer-all)
    (define-key map "\C-l"	'follow-recenter)
    (define-key map "<"		'follow-first-window)
    (define-key map ">"		'follow-last-window)
    (define-key map "n"		'follow-next-window)
    (define-key map "p"		'follow-previous-window)

    (define-key mainmap follow-mode-prefix map)

    ;; Replace the standard `end-of-buffer', when in Follow mode.  (I
    ;; don't see the point in trying to replace every function that
    ;; could be enhanced in Follow mode.  End-of-buffer is a special
    ;; case since it is very simple to define and it greatly enhances
    ;; the look and feel of Follow mode.)
    (define-key mainmap [remap end-of-buffer] 'follow-end-of-buffer)

    (define-key mainmap [remap scroll-bar-toolkit-scroll] 'follow-scroll-bar-toolkit-scroll)
    (define-key mainmap [remap scroll-bar-drag] 'follow-scroll-bar-drag)
    (define-key mainmap [remap scroll-bar-scroll-up] 'follow-scroll-bar-scroll-up)
    (define-key mainmap [remap scroll-bar-scroll-down] 'follow-scroll-bar-scroll-down)
    (define-key mainmap [remap mwheel-scroll] 'follow-mwheel-scroll)

    mainmap)
  "Minor mode keymap for Follow mode.")

;; When the mode is not activated, only one item is visible to activate
;; the mode.
(defun follow-menu-filter (menu)
  (if (bound-and-true-p follow-mode)
      menu
    '(["Follow mode"	follow-mode
       :style toggle :selected follow-mode])))

(easy-menu-add-item nil '("Tools")
  '("Follow"
    :filter follow-menu-filter
    ["Scroll Up"	follow-scroll-up	follow-mode]
    ["Scroll Down"	follow-scroll-down	follow-mode]
    "--"
    ["Delete Other Windows and Split" follow-delete-other-windows-and-split follow-mode]
    "--"
    ["Switch To Buffer"	follow-switch-to-buffer	follow-mode]
    ["Switch To Buffer (all windows)" follow-switch-to-buffer-all follow-mode]
    "--"
    ["First Window"	follow-first-window	follow-mode]
    ["Last Window"	follow-last-window	follow-mode]
    ["Next Window"	follow-next-window	follow-mode]
    ["Previous Window"	follow-previous-window	follow-mode]
    "--"
    ["Recenter"		follow-recenter		follow-mode]
    "--"
    ["Follow mode"	follow-mode :style toggle :selected follow-mode]))

(defcustom follow-mode-line-text " Follow"
  "Text shown in the mode line when Follow mode is active.
Defaults to \" Follow\".  Examples of other values
are \" Fw\", or simply \"\"."
  :type 'string
  :group 'follow)

(defcustom follow-auto nil
  "Non-nil activates Follow mode whenever a file is loaded."
  :type 'boolean
  :group 'follow
  :set (lambda (symbol value)
	 (if value
	     (add-hook 'find-file-hook 'follow-find-file-hook t)
	   (remove-hook 'find-file-hook 'follow-find-file-hook))
	 (set-default symbol value)))

(defvar follow-cache-command-list
  '(next-line previous-line forward-char backward-char)
  "List of commands that don't require recalculation.

In order to be able to use the cache, a command should not change the
contents of the buffer, nor should it change selected window or current
buffer.

The commands in this list are checked at load time.

To mark other commands as suitable for caching, set the symbol
property `follow-mode-use-cache' to non-nil.")

(defcustom follow-debug nil
  "If non-nil, emit Follow mode debugging messages."
  :type 'boolean
  :group 'follow)

;; Internal variables:

(defvar follow-internal-force-redisplay nil
  "True when Follow mode should redisplay the windows.")

(defvar follow-active-menu nil
  "The menu visible when Follow mode is active.")

(defvar follow-inactive-menu nil
  "The menu visible when Follow mode is inactive.")

(defvar follow-inside-post-command-hook nil
  "Non-nil when inside Follow modes `post-command-hook'.
Used by `follow-window-size-change'.")

(defvar follow-windows-start-end-cache nil
  "Cache used by `follow-window-start-end'.")

;;; Debug messages

;; This inline function must be as small as possible!
;; Maybe we should define a macro that expands to nil if
;; the variable is not set.

(defsubst follow-debug-message (&rest args)
  "Like `message', but only active when `follow-debug' is non-nil."
  (if (and (boundp 'follow-debug) follow-debug)
      (apply 'message args)))

;;; Cache

(dolist (cmd follow-cache-command-list)
  (put cmd 'follow-mode-use-cache t))

;;; The mode

;;;###autoload
(defun turn-on-follow-mode ()
  "Turn on Follow mode.  Please see the function `follow-mode'."
  (follow-mode 1))


;;;###autoload
(defun turn-off-follow-mode ()
  "Turn off Follow mode.  Please see the function `follow-mode'."
  (follow-mode -1))

(put 'follow-mode 'permanent-local t)
;;;###autoload
(define-minor-mode follow-mode
  "Toggle Follow mode.
With a prefix argument ARG, enable Follow mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

Follow mode is a minor mode that combines windows into one tall
virtual window.  This is accomplished by two main techniques:

* The windows always displays adjacent sections of the buffer.
  This means that whenever one window is moved, all the
  others will follow.  (Hence the name Follow mode.)

* Should the point (cursor) end up outside a window, another
  window displaying that point is selected, if possible.  This
  makes it possible to walk between windows using normal cursor
  movement commands.

Follow mode comes to its prime when used on a large screen and two
side-by-side windows are used.  The user can, with the help of Follow
mode, use two full-height windows as though they would have been
one.  Imagine yourself editing a large function, or section of text,
and being able to use 144 lines instead of the normal 72... (your
mileage may vary).

To split one large window into two side-by-side windows, the commands
`\\[split-window-right]' or \
`M-x follow-delete-other-windows-and-split' can be used.

Only windows displayed in the same frame follow each other.

This command runs the normal hook `follow-mode-hook'.

Keys specific to Follow mode:
\\{follow-mode-map}"
  :keymap follow-mode-map
  (if follow-mode
      (progn
	(add-hook 'compilation-filter-hook 'follow-align-compilation-windows t t)
	(add-hook 'post-command-hook 'follow-post-command-hook t)
	(add-hook 'window-size-change-functions 'follow-window-size-change t))
    ;; Remove globally-installed hook functions only if there is no
    ;; other Follow mode buffer.
    (let ((buffers (buffer-list))
	  following)
      (while (and (not following) buffers)
	(setq following (buffer-local-value 'follow-mode (car buffers))
	      buffers (cdr buffers)))
      (unless following
	(remove-hook 'post-command-hook 'follow-post-command-hook)
	(remove-hook 'window-size-change-functions 'follow-window-size-change)))
    (remove-hook 'compilation-filter-hook 'follow-align-compilation-windows t)))

(defun follow-find-file-hook ()
  "Find-file hook for Follow mode.  See the variable `follow-auto'."
  (if follow-auto (follow-mode 1)))

;;; User functions

;;; Scroll

;; `scroll-up' and `-down', but for windows in Follow mode.
;;
;; Almost like the real thing, except when the cursor ends up outside
;; the top or bottom...  In our case however, we end up outside the
;; window and hence we are recentered.  Should we let `recenter' handle
;; the point position we would never leave the selected window.  To do
;; it ourselves we would need to do our own redisplay, which is easier
;; said than done.  (Why didn't I do a real display abstraction from
;; the beginning?)
;;
;; We must sometimes set `follow-internal-force-redisplay', otherwise
;; our post-command-hook will move our windows back into the old
;; position...  (This would also be corrected if we would have had a
;; good redisplay abstraction.)

(defun follow-scroll-up (&optional arg)
  "Scroll text in a Follow mode window chain up.

If called with no ARG, the `next-screen-context-lines' last lines of
the bottom window in the chain will be visible in the top window.

If called with an argument, scroll ARG lines up.
Negative ARG means scroll downward.

Works like `scroll-up' when not in Follow mode."
  (interactive "P")
  (cond ((not follow-mode)
	 (scroll-up arg))
	(arg
	 (save-excursion (scroll-up arg))
	 (setq follow-internal-force-redisplay t))
	(t
	 (let* ((windows (follow-all-followers))
		(end (window-end (car (reverse windows)))))
	   (if (eq end (point-max))
	       (signal 'end-of-buffer nil)
	     (select-window (car windows))
	     ;; `window-end' might return nil.
	     (if end
		 (goto-char end))
	     (vertical-motion (- next-screen-context-lines))
	     (set-window-start (car windows) (point)))))))


(defun follow-scroll-down (&optional arg)
  "Scroll text in a Follow mode window chain down.

If called with no ARG, the `next-screen-context-lines' top lines of
the top window in the chain will be visible in the bottom window.

If called with an argument, scroll ARG lines down.
Negative ARG means scroll upward.

Works like `scroll-up' when not in Follow mode."
  (interactive "P")
  (cond ((not follow-mode)
	 (scroll-up arg))
	(arg
	 (save-excursion (scroll-down arg)))
	(t
	 (let* ((windows (follow-all-followers))
		(win (car (reverse windows)))
		(start (window-start (car windows))))
	   (if (eq start (point-min))
	       (signal 'beginning-of-buffer nil)
	     (select-window win)
	     (goto-char start)
	     (vertical-motion (- (- (window-height win)
				    (if header-line-format 2 1)
				    next-screen-context-lines)))
	     (set-window-start win (point))
	     (goto-char start)
	     (vertical-motion (- next-screen-context-lines 1))
	     (setq follow-internal-force-redisplay t))))))

(declare-function comint-adjust-point "comint" (window))
(defvar comint-scroll-show-maximum-output)

(defun follow-comint-scroll-to-bottom (&optional window)
  "Scroll the bottom-most window in the current Follow chain.
This is to be called by `comint-postoutput-scroll-to-bottom'."
  (let* ((buffer (current-buffer))
	 (selected (selected-window))
	 (is-selected (eq (window-buffer) buffer))
	 some-window)
    (when (or is-selected
	      (setq some-window (get-buffer-window)))
      (let* ((pos (progn (comint-adjust-point nil) (point)))
	     (win (if is-selected
		      selected
		    (car (last (follow-all-followers some-window))))))
	(select-window win)
	(goto-char pos)
	(setq follow-windows-start-end-cache nil)
	(follow-adjust-window win pos)
	(unless is-selected
	  (select-window selected)
	  (set-buffer buffer))))))

(defun follow-align-compilation-windows ()
  "Align the windows of the current Follow mode buffer.
This is to be called from `compilation-filter-hook'."
  (let ((buffer (current-buffer))
	(win (get-buffer-window))
	(selected (selected-window)))
    (when (and follow-mode (waiting-for-user-input-p) win)
      (let ((windows (follow-all-followers win)))
	(unless (eq (window-buffer selected) buffer)
	  (setq win (car windows))
	  (select-window win))
	(follow-redisplay windows win t)
	(setq follow-windows-start-end-cache nil)
	(unless (eq selected win)
	  (select-window selected)
	  (set-buffer buffer))))))

;;; Buffer

;;;###autoload
(defun follow-delete-other-windows-and-split (&optional arg)
  "Create two side by side windows and enter Follow mode.

Execute this command to display as much as possible of the text
in the selected window.  All other windows, in the current
frame, are deleted and the selected window is split in two
side-by-side windows.  Follow mode is activated, hence the
two windows always will display two successive pages.
\(If one window is moved, the other one will follow.)

If ARG is positive, the leftmost window is selected.  If negative,
the rightmost is selected.  If ARG is nil, the leftmost window is
selected if the original window is the first one in the frame."
  (interactive "P")
  (let ((other (or (and (null arg)
			(not (eq (selected-window)
				 (frame-first-window (selected-frame)))))
		   (and arg
			(< (prefix-numeric-value arg) 0))))
	(start (window-start)))
    (delete-other-windows)
    (split-window-right)
    (if other
	(progn
	  (other-window 1)
	  (set-window-start (selected-window) start)
	  (setq follow-internal-force-redisplay t)))
    (follow-mode 1)))

(defun follow-switch-to-buffer (buffer)
  "Show BUFFER in all windows in the current Follow mode window chain."
  (interactive "BSwitch to Buffer: ")
  (let ((orig-window (selected-window))
	(windows (follow-all-followers)))
    (while windows
      (select-window (car windows))
      (switch-to-buffer buffer)
      (setq windows (cdr windows)))
    (select-window orig-window)))


(defun follow-switch-to-buffer-all (&optional buffer)
  "Show BUFFER in all windows on this frame.
Defaults to current buffer."
  (interactive (list (read-buffer "Switch to Buffer: "
				  (current-buffer))))
  (or buffer (setq buffer (current-buffer)))
  (let ((orig-window (selected-window)))
    (walk-windows (lambda (win)
		    (select-window win)
		    (switch-to-buffer buffer))
		  'no-minibuf)
    (select-window orig-window)
    (follow-redisplay)))


(defun follow-switch-to-current-buffer-all ()
  "Show current buffer in all windows on this frame, and enter Follow mode."
  (interactive)
  (unless follow-mode
    (follow-mode 1))
  (follow-switch-to-buffer-all))

;;; Movement

;; Note, these functions are not very useful, at least not unless you
;; rebind the rather cumbersome key sequence `C-c . p'.

(defun follow-next-window ()
  "Select the next window showing the same buffer."
  (interactive)
  (let ((succ (cdr (follow-split-followers (follow-all-followers)))))
    (if succ
	(select-window (car succ))
      (error "%s" "No more windows"))))


(defun follow-previous-window ()
  "Select the previous window showing the same buffer."
  (interactive)
  (let ((pred (car (follow-split-followers (follow-all-followers)))))
    (if pred
	(select-window (car pred))
      (error "%s" "No more windows"))))


(defun follow-first-window ()
  "Select the first window in the frame showing the same buffer."
  (interactive)
  (select-window (car (follow-all-followers))))


(defun follow-last-window ()
  "Select the last window in the frame showing the same buffer."
  (interactive)
  (select-window (car (reverse (follow-all-followers)))))

;;; Redraw

(defun follow-recenter (&optional arg)
  "Recenter the middle window around point.
Rearrange all other windows around the middle window.

With a positive argument, place the current line ARG lines
from the top.  With a negative argument, place it -ARG lines
from the bottom."
  (interactive "P")
  (if arg
      (let ((p (point))
	    (arg (prefix-numeric-value arg)))
	(if (>= arg 0)
	    ;; Recenter relative to the top.
	    (progn
	      (follow-first-window)
	      (goto-char p)
	      (recenter arg))
	  ;; Recenter relative to the bottom.
	  (follow-last-window)
	  (goto-char p)
	  (recenter arg)
	  ;; Otherwise, our post-command-hook will move the window
	  ;; right back.
	  (setq follow-internal-force-redisplay t)))
    ;; Recenter in the middle.
    (let* ((dest (point))
	   (windows (follow-all-followers))
	   (win (nth (/ (- (length windows) 1) 2) windows)))
      (select-window win)
      (goto-char dest)
      (recenter))))


(defun follow-redraw ()
  "Arrange windows displaying the same buffer in successor order.
This function can be called even if the buffer is not in Follow mode.

Hopefully, there should be no reason to call this function when in
Follow mode since the windows should always be aligned."
  (interactive)
  (sit-for 0)
  (follow-redisplay))

;;; End of buffer

(defun follow-end-of-buffer (&optional arg)
  "Move point to the end of the buffer, Follow mode style.

If the end is not visible, it will be displayed in the last possible
window in the Follow mode window chain.

The mark is left at the previous position.  With arg N, put point N/10
of the way from the true end."
  (interactive "P")
  (let ((followers (follow-all-followers))
	(pos (point)))
    (cond (arg
	   (select-window (car (reverse followers))))
	  ((follow-select-if-end-visible
	    (follow-windows-start-end followers)))
	  (t
	   (select-window (car (reverse followers)))))
    (goto-char pos)
    (with-no-warnings
      (end-of-buffer arg))))

;;; Display

(defun follow--window-sorter (w1 w2)
  "Sorting function for W1 and W2 based on their positions.
Return non-nil if W1 is above W2; if their top-lines
are at the same position, return non-nil if W1 is to the
left of W2."
  (let* ((edge-1 (window-pixel-edges w1))
	 (edge-2 (window-pixel-edges w2))
	 (y1 (nth 1 edge-1))
	 (y2 (nth 1 edge-2)))
    (if (= y1 y2)
	(< (car edge-1) (car edge-2))
      (< y1 y2))))

(defun follow-all-followers (&optional win)
  "Return all windows displaying the same buffer as the WIN.
The list is sorted with topmost and leftmost windows first, and
contains only windows in the same frame as WIN.  If WIN is nil,
it defaults to the selected window."
  (unless (window-live-p win)
    (setq win (selected-window)))
  (let ((buffer (window-buffer win))
	windows)
    (dolist (w (window-list (window-frame win) 'no-minibuf win))
      (if (eq (window-buffer w) buffer)
	  (push w windows)))
    (sort windows 'follow--window-sorter)))

(defun follow-split-followers (windows &optional win)
  "Split WINDOWS into two sets: predecessors and successors.
Return `(PRED . SUCC)' where `PRED' and `SUCC' are ordered starting
from the selected window."
  (or win
      (setq win (selected-window)))
  (let ((pred '()))
    (while (not (eq (car windows) win))
      (setq pred (cons (car windows) pred))
      (setq windows (cdr windows)))
    (cons pred (cdr windows))))

(defun follow-calc-win-end (&optional win)
  "Calculate the end position for window WIN.
Return (END-POS END-OF-BUFFER).

Actually, the position returned is the start of the line after
the last fully-visible line in WIN.  If WIN is nil, the selected
window is used."
  (let* ((win (or win (selected-window)))
	 (edges (window-inside-pixel-edges win))
	 (ht (- (nth 3 edges) (nth 1 edges)))
	 (last-line-pos (posn-point (posn-at-x-y 0 (1- ht) win))))
    (if (pos-visible-in-window-p last-line-pos win)
	(let ((end (window-end win t)))
	  (list end (= end (point-max))))
      (list last-line-pos nil))))

(defun follow-calc-win-start (windows pos win)
  "Determine the start of window WIN in a Follow mode window chain.
WINDOWS is a list of chained windows, and POS is the starting
position for the first window in the list.  If WIN is nil, return
the point below all windows."
  (while (and windows (not (eq (car windows) win)))
    (let ((old-start (window-start (car windows))))
      ;; Can't use `save-window-excursion' since it triggers a redraw.
      (set-window-start (car windows) pos 'noforce)
      (setq pos (car (follow-calc-win-end (car windows))))
      (set-window-start (car windows) old-start 'noforce)
      (setq windows (cdr windows))))
  pos)

;; The result from `follow-windows-start-end' is cached when using
;; a handful simple commands, like cursor movement commands.

(defsubst follow-cache-valid-p (windows)
  "Test if the cached value of `follow-windows-start-end' can be used.
Note that this handles the case when the cache has been set to nil."
  (let ((res t)
	(cache follow-windows-start-end-cache))
    (while (and res windows cache)
      (setq res (and (eq (car windows)
			 (car (car cache)))
		     (eq (window-start (car windows))
			 (car (cdr (car cache))))))
      (setq windows (cdr windows))
      (setq cache (cdr cache)))
    (and res (null windows) (null cache))))

(defun follow-windows-start-end (windows)
  "Return a list of (WIN START END BUFFER-END-P) for window list WINDOWS."
  (if (follow-cache-valid-p windows)
      follow-windows-start-end-cache
    (let ((orig-win (selected-window))
	  win-start-end)
      (dolist (w windows)
	(select-window w)
	(push (cons w (cons (window-start) (follow-calc-win-end)))
	      win-start-end))
      (select-window orig-win)
      (setq follow-windows-start-end-cache (nreverse win-start-end)))))

(defsubst follow-pos-visible (pos win win-start-end)
  "Non-nil when POS is visible in WIN."
  (let ((wstart-wend-bend (cdr (assq win win-start-end))))
    (and (>= pos (car wstart-wend-bend))
	 (or (< pos (cadr wstart-wend-bend))
	     (nth 2 wstart-wend-bend)))))


;; By `aligned' we mean that for all adjacent windows, the end of the
;; first is equal with the start of the successor.  The first window
;; should start at a full screen line.

(defsubst follow-windows-aligned-p (win-start-end)
  "Non-nil if the follower windows are aligned.
The argument, WIN-START-END, should be a list of the form
returned by `follow-windows-start-end'."
  (let ((result t))
    (while (and win-start-end result)
      (if (cdr win-start-end)
	  (setq result (eq (nth 2 (car win-start-end))
			   (nth 1 (cadr win-start-end)))))
      (setq win-start-end (cdr win-start-end)))
    result))

;; Check if the point is visible in all windows. (So that
;; no one will be recentered.)

(defun follow-point-visible-all-windows-p (win-start-end)
  "Non-nil when the `window-point' is visible in all windows."
  (let ((res t))
    (while (and res win-start-end)
      (setq res (follow-pos-visible (window-point (car (car win-start-end)))
				    (car (car win-start-end))
				    win-start-end))
      (setq win-start-end (cdr win-start-end)))
    res))


;; Make sure WIN always starts at the beginning of a whole screen
;; line. If WIN is not aligned the start is updated which probably
;; will lead to a redisplay of the screen later on.
;;
;; This is used with the first window in a follow chain.  The reason
;; is that we want to detect that the point is outside the window.
;; (Without the update, the start of the window will move as the
;; user presses BackSpace, and the other window redisplay routines
;; will move the start of the window in the wrong direction.)

(defun follow-update-window-start (win)
  "Make sure that the start of WIN starts at a full screen line."
  (save-excursion
    (goto-char (window-start win))
    (unless (bolp)
      (vertical-motion 0 win)
      (unless (eq (point) (window-start win))
	(vertical-motion 1 win)
	(set-window-start win (point) 'noforce)))))

(defun follow-select-if-visible (dest win-start-end)
  "Select and return a window, if DEST is visible in it.
Return the selected window."
  (let (win win-end wse)
    (while (and (not win) win-start-end)
      ;; Don't select a window that was just moved. This makes it
      ;; possible to later select the last window after a
      ;; `end-of-buffer' command.
      (setq wse (car win-start-end))
      (when (follow-pos-visible dest (car wse) win-start-end)
	(setq win (car wse)
	      win-end (nth 2 wse))
	(select-window win))
      (setq win-start-end (cdr win-start-end)))
    win))

;; Lets select a window showing the end. Make sure we only select it if
;; it wasn't just moved here. (I.e. M-> shall not unconditionally place
;; the point in the selected window.)
;;
;; (Compatibility kludge: in Emacs `window-end' is equal to `point-max';
;; in XEmacs, it is equal to `point-max + 1'. Should I really bother
;; checking `window-end' now when I check `end-of-buffer' explicitly?)

(defun follow-select-if-end-visible (win-start-end)
  "Select and return a window, if end is visible in it."
  (let ((win nil))
    (while (and (not win) win-start-end)
      ;; Don't select a window that was just moved. This makes it
      ;; possible to later select the last window after a `end-of-buffer'
      ;; command.
      (if (and (eq (point-max) (nth 2 (car win-start-end)))
	       (nth 3 (car win-start-end))
	       ;; `window-end' might return nil.
	       (let ((end (window-end (car (car win-start-end)))))
		 (and end
		      (eq (point-max) (min (point-max) end)))))
	  (progn
	    (setq win (car (car win-start-end)))
	    (select-window win)))
      (setq win-start-end (cdr win-start-end)))
    win))


;; Select a window that will display the point if the windows would
;; be redisplayed with the first window fixed. This is useful for
;; example when the user has pressed return at the bottom of a window
;; as the point is not visible in any window.

(defun follow-select-if-visible-from-first (dest windows)
  "Try to select one of WINDOWS without repositioning the topmost window.
If one of the windows in WINDOWS contains DEST, select it, call
`follow-redisplay', move point to DEST, and return that window.
Otherwise, return nil."
  (let (win end-pos-end-p)
    (save-excursion
      (goto-char (window-start (car windows)))
      ;; Make sure the line start in the beginning of a real screen
      ;; line.
      (vertical-motion 0 (car windows))
      (when (>= dest (point))
	;; At or below the start. Check the windows.
	(save-window-excursion
	  (let ((windows windows))
	    (while (and (not win) windows)
	      (set-window-start (car windows) (point) 'noforce)
	      (setq end-pos-end-p (follow-calc-win-end (car windows)))
	      (goto-char (car end-pos-end-p))
	      ;; Visible, if dest above end, or if eob is visible
	      ;; inside the window.
	      (if (or (car (cdr end-pos-end-p))
		      (< dest (point)))
		  (setq win (car windows))
		(setq windows (cdr windows))))))))
    (when win
      (select-window win)
      (follow-redisplay windows (car windows))
      (goto-char dest))
    win))

;;; Redisplay

;; Redraw all the windows on the screen, starting with the top window.
;; The window used as as marker is WIN, or the selected window if WIN
;; is nil.  Start every window directly after the end of the previous
;; window, to make sure long lines are displayed correctly.

(defun follow-redisplay (&optional windows win preserve-win)
  "Reposition the WINDOWS around WIN.
Should the point be too close to the roof we redisplay everything
from the top.  WINDOWS should contain a list of windows to
redisplay; it is assumed that WIN is a member of the list.
Should WINDOWS be nil, the windows displaying the
same buffer as WIN, in the current frame, are used.
Should WIN be nil, the selected window is used.
If PRESERVE-WIN is non-nil, keep WIN itself unchanged while
repositioning the other windows."
  (or win (setq win (selected-window)))
  (or windows (setq windows (follow-all-followers win)))
  ;; Calculate the start of the first window.
  (let* ((old-win-start (window-start win))
	 (try-first-start (follow-estimate-first-window-start
			   windows win old-win-start))
	 (try-win-start (follow-calc-win-start
			 windows try-first-start win))
	 (start (cond ((= try-win-start old-win-start)
		       (follow-debug-message "exact")
		       try-first-start)
		      ((< try-win-start old-win-start)
		       (follow-debug-message "above")
		       (follow-calculate-first-window-start-from-above
			windows try-first-start win old-win-start))
		      (t
		       (follow-debug-message "below")
		       (follow-calculate-first-window-start-from-below
			windows try-first-start win old-win-start)))))
    (dolist (w windows)
      (unless (and preserve-win (eq w win))
	(set-window-start w start))
      (setq start (car (follow-calc-win-end w))))))

(defun follow-estimate-first-window-start (windows win start)
  "Estimate the position of the first window.
The estimate is computed by assuming that the window WIN, which
should be a member of WINDOWS, starts at position START."
  (let ((windows-before (car (follow-split-followers windows win))))
    (save-excursion
      (goto-char start)
      (vertical-motion 0 win)
      (dolist (w windows-before)
	(vertical-motion (- 1 (window-text-height w)) w))
      (point))))


;; Find the starting point, start at GUESS and search downward.
;; The returned point is always a point below GUESS.

(defun follow-calculate-first-window-start-from-above
       (windows guess win start)
  (save-excursion
    (let ((done nil)
	  win-start
	  res)
      (goto-char guess)
      (while (not done)
	(if (not (= (vertical-motion 1 (car windows)) 1))
	    ;; Hit bottom! (Can we really do this?)
	    ;; We'll keep it, since it ensures termination.
	    (progn
	      (setq done t)
	      (setq res (point-max)))
	  (setq win-start (follow-calc-win-start windows (point) win))
	  (if (>= win-start start)
	      (setq done t res (point)))))
      res)))


;; Find the starting point, start at GUESS and search upward.  Return
;; a point on the same line as GUESS, or above.

(defun follow-calculate-first-window-start-from-below
       (windows guess &optional win start)
  (setq win (or win (selected-window)))
  (setq start (or start (window-start win)))
  (save-excursion
    (let (done win-start res opoint)
      ;; Always calculate what happens when no line is displayed in the first
      ;; window. (The `previous' res is needed below!)
      (goto-char guess)
      (vertical-motion 0 (car windows))
      (setq res (point))
      (while (not done)
	(setq opoint (point))
	(if (not (= (vertical-motion -1 (car windows)) -1))
	    ;; Hit roof!
	    (setq done t res (point-min))
	  (setq win-start (follow-calc-win-start windows (point) win))
	  (cond ((>= (point) opoint)
		 ;; In some pathological cases, vertical-motion may
		 ;; return -1 even though point has not decreased.  In
		 ;; that case, avoid looping forever.
		 (setq done t res (point)))
		((= win-start start)	; Perfect match, use this value
		 (setq done t res (point)))
		((< win-start start)	; Walked to far, use previous result
		 (setq done t))
		(t			; Store result for next iteration
		 (setq res (point))))))
      res)))

;;; Avoid tail recenter

;; This sets the window internal flag `force_start'. The effect is
;; that windows only displaying the tail aren't recentered.
;;
;; A window displaying only the tail, is a window whose window-start
;; position is equal to (point-max) of the buffer it displays.

(defun follow-avoid-tail-recenter (&rest _rest)
  "Make sure windows displaying the end of a buffer aren't recentered.
This is done by reading and rewriting the start position of
non-first windows in Follow mode."
  (let* ((orig-buffer (current-buffer))
	 (top (frame-first-window (selected-frame)))
	 (win top)
	 who) ; list of (buffer . frame)
    ;; If the only window in the frame is a minibuffer
    ;; window, `next-window' will never find it again...
    (unless (window-minibuffer-p top)
      (while  ;; look, no body!
	  (let ((start (window-start win))
		(pair (cons (window-buffer win) (window-frame win))))
	    (set-buffer (window-buffer win))
	    (cond ((null (member pair who))
		   (setq who (cons pair who)))
		  ((and follow-mode (eq (point-max) start))
		   ;; Write the same window start back, but don't
		   ;; set the NOFORCE flag.
		   (set-window-start win start)))
	    (setq win (next-window win 'not t))
	    (not (eq win top))))  ;; Loop while this is true.
      (set-buffer orig-buffer))))

;;; Post Command Hook

;; The magic little box. This function is called after every command.

;; This is not as complicated as it seems. It is simply a list of common
;; display situations and the actions to take, plus commands for redrawing
;; the screen if it should be unaligned.
;;
;; We divide the check into two parts; whether we are at the end or not.
;; This is due to the fact that the end can actually be visible
;; in several window even though they are aligned.

(defun follow-post-command-hook ()
  "Ensure that the windows in Follow mode are adjacent after each command."
  (unless (input-pending-p)
    (let ((follow-inside-post-command-hook t)
	  (win (selected-window)))
      ;; Work in the selected window, not in the current buffer.
      (with-current-buffer (window-buffer win)
	(unless (and (symbolp this-command)
		     (get this-command 'follow-mode-use-cache))
	  (setq follow-windows-start-end-cache nil)))
      (follow-adjust-window win (point)))))

(defun follow-adjust-window (win dest)
  ;; Adjust the window WIN and its followers.
  (with-current-buffer (window-buffer win)
    (when (and follow-mode
	       (not (window-minibuffer-p win)))
      (let* ((windows (follow-all-followers win))
	     (win-start-end (progn
			      (follow-update-window-start (car windows))
			      (follow-windows-start-end windows)))
	     (aligned (follow-windows-aligned-p win-start-end))
	     (visible (follow-pos-visible dest win win-start-end))
	     selected-window-up-to-date)
	(unless (and aligned visible)
	  (setq follow-windows-start-end-cache nil))

	;; Select a window to display point.
	(unless follow-internal-force-redisplay
	  (if (eq dest (point-max))
	      ;; Be careful at point-max: the display can be aligned
	      ;; while DEST can be visible in several windows.
	      (cond
	       ;; Select the current window, but only when the display
	       ;; is correct. (When inserting characters in a tail
	       ;; window, the display is not correct, as they are
	       ;; shown twice.)
	       ;;
	       ;; Never stick to the current window after a deletion.
	       ;; Otherwise, when typing `DEL' in a window showing
	       ;; only the end of the file, a character would be
	       ;; removed from the window above, which is very
	       ;; unintuitive.
	       ((and visible
		     aligned
		     (not (memq this-command
				'(backward-delete-char
				  delete-backward-char
				  backward-delete-char-untabify
				  kill-region))))
		(follow-debug-message "Max: same"))
	       ;; If the end is visible, and the window doesn't
	       ;; seems like it just has been moved, select it.
	       ((follow-select-if-end-visible win-start-end)
		(follow-debug-message "Max: end visible")
		(setq visible t aligned nil)
		(goto-char dest))
	       ;; Just show the end...
	       (t
		(follow-debug-message "Max: default")
		(select-window (car (last windows)))
		(goto-char dest)
		(setq visible nil aligned nil)))

	    ;; We're not at the end, here life is much simpler.
	    (cond
	     ;; This is the normal case!
	     ;; It should be optimized for speed.
	     ((and visible aligned)
	      (follow-debug-message "same"))
	     ;; Pick a position in any window.  If the display is ok,
	     ;; this picks the `correct' window.
	     ((follow-select-if-visible dest win-start-end)
	      (follow-debug-message "visible")
	      (goto-char dest)
	      ;; Perform redisplay, in case line is partially visible.
	      (setq visible nil))
	     ;; Not visible anywhere else, lets pick this one.
	     (visible
	      (follow-debug-message "visible in selected."))
	     ;; If DEST is before the first window start, select the
	     ;; first window.
	     ((< dest (nth 1 (car win-start-end)))
	      (follow-debug-message "before first")
	      (select-window (car windows))
	      (goto-char dest)
	      (setq visible nil aligned nil))
	     ;; If we can position the cursor without moving the first
	     ;; window, do it. This is the case that catches `RET' at
	     ;; the bottom of a window.
	     ((follow-select-if-visible-from-first dest windows)
	      (follow-debug-message "Below first")
	      (setq visible t aligned t))
	     ;; None of the above.  Stick to the selected window.
	     (t
	      (follow-debug-message "None")
	      (setq visible nil aligned nil))))

	  ;; If a new window was selected, make sure that the old is
	  ;; not scrolled when the point is outside the window.
	  (unless (eq win (selected-window))
	    (let ((p (window-point win)))
	      (set-window-start win (window-start win) nil)
	      (set-window-point win p))))

	(unless visible
	  ;; If point may not be visible in the selected window,
	  ;; perform a redisplay; this ensures scrolling.
	  (let ((opoint (point)))
	    (redisplay)
	    ;; If this `redisplay' moved point, we got clobbered by a
	    ;; previous call to `set-window-start'.  Try again.
	    (when (/= (point) opoint)
	      (goto-char opoint)
	      (redisplay)))

	  (setq selected-window-up-to-date t)
	  (follow-avoid-tail-recenter)
	  (setq win-start-end (follow-windows-start-end windows)
		follow-windows-start-end-cache nil
		aligned nil))

	;; Now redraw the windows around the selected window.
	(unless (and (not follow-internal-force-redisplay)
		     (or aligned
			 (follow-windows-aligned-p win-start-end))
		     (follow-point-visible-all-windows-p win-start-end))
	  (setq follow-internal-force-redisplay nil)
	  (follow-redisplay windows (selected-window)
			    selected-window-up-to-date)
	  (setq win-start-end (follow-windows-start-end windows)
		follow-windows-start-end-cache nil)
	  ;; The point can ends up in another window when DEST is at
	  ;; the beginning of the buffer and the selected window is
	  ;; not the first.  It can also happen when long lines are
	  ;; used and there is a big difference between the width of
	  ;; the windows.  (When scrolling one line in a wide window
	  ;; which will cause a move larger that an entire small
	  ;; window.)
	  (unless (follow-pos-visible dest win win-start-end)
	    (follow-select-if-visible dest win-start-end)
	    (goto-char dest)))

	;; If the region is visible, make it look good when spanning
	;; multiple windows.
	(when (region-active-p)
	  (follow-maximize-region
	   (selected-window) windows win-start-end)))

      ;; Whether or not the buffer was in follow mode, update windows
      ;; displaying the tail so that Emacs won't recenter them.
      (follow-avoid-tail-recenter))))

;;; The region

;; Tries to make the highlighted area representing the region look
;; good when spanning several windows.
;;
;; Not perfect, as the point can't be placed at window end, only at
;; end-1.  This will highlight a little bit in windows above
;; the current.

(defun follow-maximize-region (win windows win-start-end)
  "Make a highlighted region stretching multiple windows look good."
  (let* ((all (follow-split-followers windows win))
	 (pred (car all))
	 (succ (cdr all))
	 data)
    (while pred
      (setq data (assq (car pred) win-start-end))
      (set-window-point (car pred) (max (nth 1 data) (- (nth 2 data) 1)))
      (setq pred (cdr pred)))
    (while succ
      (set-window-point (car succ) (nth 1 (assq (car succ) win-start-end)))
      (setq succ (cdr succ)))))

;;; Scroll bar

;;;; Scroll-bar support code.

;; This handles the case where the user drags the scroll bar of a
;; non-selected window whose buffer is in Follow mode.

(defun follow-scroll-bar-toolkit-scroll (event)
  (interactive "e")
  (scroll-bar-toolkit-scroll event)
  (follow-redraw-after-event event))

(defun follow-scroll-bar-drag (event)
  (interactive "e")
  (scroll-bar-drag event)
  (follow-redraw-after-event event))

(defun follow-scroll-bar-scroll-up (event)
  (interactive "e")
  (scroll-bar-scroll-up event)
  (follow-redraw-after-event event))

(defun follow-scroll-bar-scroll-down (event)
  (interactive "e")
  (scroll-bar-scroll-down event)
  (follow-redraw-after-event event))

(defun follow-mwheel-scroll (event)
  (interactive "e")
  (mwheel-scroll event)
  (follow-redraw-after-event event))

(defun follow-redraw-after-event (event)
  "Re-align the Follow mode windows affected by EVENT."
  (let* ((window (nth 0 (event-end event)))
	 (buffer (window-buffer window))
	 (orig-win (selected-window)))
    (when (and (buffer-local-value 'follow-mode buffer)
	       ;; Ignore the case where we scroll the selected window;
	       ;; that is handled by the post-command hook function.
	       (not (eq window (selected-window))))
      (select-window window)
      (follow-redisplay)
      (unless (eq (window-buffer orig-win) buffer)
	(select-window orig-win)))))

;;; Window size change

;; The functions in `window-size-change-functions' are called every
;; time a window in a frame changes size, most notably after the frame
;; has been resized.  We call `follow-post-command-hook' for every
;; Follow mode buffer visible in any window in the resized frame.
;;
;; Since `follow-window-size-change' can be called indirectly from
;; `follow-post-command-hook' we have a potential infinite loop.  To
;; avoid this, we simply do not do anything in this situation.  The
;; variable `follow-inside-post-command-hook' contains information
;; about whether the execution actually is inside the
;; post-command-hook or not.

(defun follow-window-size-change (frame)
  "Redraw all windows in FRAME, when in Follow mode."
  ;; Below, we call `post-command-hook'.  Avoid an infloop.
  (unless follow-inside-post-command-hook
    (let ((buffers '())
	  (orig-window (selected-window))
	  (orig-buffer (current-buffer))
	  (orig-frame (selected-frame))
	  windows
	  buf)
      (select-frame frame)
      (unwind-protect
	  (walk-windows
	   (lambda (win)
	     (setq buf (window-buffer win))
	     (unless (memq buf buffers)
	       (set-buffer buf)
	       (when follow-mode
		 (setq windows (follow-all-followers win))
		 (if (not (memq orig-window windows))
		     (follow-redisplay windows win)
		   ;; Make sure we're redrawing around the selected
		   ;; window.
		   (select-window orig-window)
		   (follow-post-command-hook)
		   (setq orig-window (selected-window)))
		 (setq buffers (cons buf buffers)))))
	   'no-minibuf)
	(select-frame orig-frame)
	(set-buffer orig-buffer)
	(select-window orig-window)))))

(add-hook 'window-scroll-functions 'follow-avoid-tail-recenter t)

;;; Profile support

;; The following (non-evaluated) section can be used to
;; profile this package using `elp'.
;;
;; Invalid indentation on purpose!

;; (setq elp-function-list
;;       '(window-end
;; 	vertical-motion
;; 	follow-mode
;; 	follow-all-followers
;; 	follow-split-followers
;; 	follow-redisplay
;; 	follow-estimate-first-window-start
;; 	follow-calculate-first-window-start-from-above
;; 	follow-calculate-first-window-start-from-below
;; 	follow-calc-win-end
;; 	follow-calc-win-start
;; 	follow-pos-visible
;; 	follow-windows-start-end
;; 	follow-cache-valid-p
;; 	follow-select-if-visible
;; 	follow-select-if-visible-from-first
;; 	follow-windows-aligned-p
;; 	follow-point-visible-all-windows-p
;; 	follow-avoid-tail-recenter
;; 	follow-update-window-start
;; 	follow-post-command-hook))

(provide 'follow)

;; /------------------------------------------------------------------------\
;; | "I [..] am rarely happier then when spending an entire day programming |
;; | my computer to perform automatically a task that it would otherwise    |
;; | take me a good ten seconds to do by hand. Ten seconds, I tell myself,  |
;; | is ten seconds. Time is valuable and ten seconds' worth of it is well  |
;; | worth the investment of a day's happy activity working out a way to    |
;; | save it".             -- Douglas Adams, "Last Chance to See"           |
;; \------------------------------------------------------------------------/

;;; follow.el ends here
