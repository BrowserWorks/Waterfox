;;; xt-mouse.el --- support the mouse when emacs run in an xterm

;; Copyright (C) 1994, 2000-2013 Free Software Foundation, Inc.

;; Author: Per Abrahamsen <abraham@dina.kvl.dk>
;; Keywords: mouse, terminals

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

;; Enable mouse support when running inside an xterm.

;; This is actually useful when you are running X11 locally, but is
;; working on remote machine over a modem line or through a gateway.

;; It works by translating xterm escape codes into generic emacs mouse
;; events so it should work with any package that uses the mouse.

;; You don't have to turn off xterm mode to use the normal xterm mouse
;; functionality, it is still available by holding down the SHIFT key
;; when you press the mouse button.

;;; Todo:

;; Support multi-click -- somehow.

;;; Code:

(defvar xterm-mouse-debug-buffer nil)

(defvar xterm-mouse-last)

;; Mouse events symbols must have an 'event-kind property with
;; the value 'mouse-click.
(dolist (event-type '(mouse-1 mouse-2 mouse-3
		      M-down-mouse-1 M-down-mouse-2 M-down-mouse-3))
  (put event-type 'event-kind 'mouse-click))

(defun xterm-mouse-translate (_event)
  "Read a click and release event from XTerm."
  (xterm-mouse-translate-1))

(defun xterm-mouse-translate-extended (_event)
  "Read a click and release event from XTerm.
Similar to `xterm-mouse-translate', but using the \"1006\"
extension, which supports coordinates >= 231 (see
http://invisible-island.net/xterm/ctlseqs/ctlseqs.html)."
  (xterm-mouse-translate-1 1006))

(defun xterm-mouse-translate-1 (&optional extension)
  (save-excursion
    (save-window-excursion
      (deactivate-mark)
      (let* ((xterm-mouse-last nil)
	     (down (xterm-mouse-event extension))
	     (down-command (nth 0 down))
	     (down-data    (nth 1 down))
	     (down-where   (nth 1 down-data))
	     (down-binding (key-binding (if (symbolp down-where)
					    (vector down-where down-command)
					  (vector down-command))))
	     (is-click (string-match "^mouse" (symbol-name (car down)))))

	;; Retrieve the expected preface for the up-event.
	(unless is-click
	  (unless (cond ((null extension)
			 (and (eq (read-event) ?\e)
			      (eq (read-event) ?\[)
			      (eq (read-event) ?M)))
			((eq extension 1006)
			 (and (eq (read-event) ?\e)
			      (eq (read-event) ?\[)
			      (eq (read-event) ?<))))
	    (error "Unexpected escape sequence from XTerm")))

	;; Process the up-event.
	(let* ((click (if is-click down (xterm-mouse-event extension)))
	       (click-data  (nth 1 click))
	       (click-where (nth 1 click-data)))
	  (if (memq down-binding '(nil ignore))
	      (if (and (symbolp click-where)
		       (consp click-where))
		  (vector (list click-where click-data) click)
		(vector click))
	    (setq unread-command-events
		  (append (if (eq down-where click-where)
			      (list click)
			    (list
			     ;; Cheat `mouse-drag-region' with move event.
			     (list 'mouse-movement click-data)
			     ;; Generate a drag event.
			     (if (symbolp down-where)
				 0
			       (list (intern (format "drag-mouse-%d"
						     (1+ xterm-mouse-last)))
				     down-data click-data))))
			  unread-command-events))
	    (if xterm-mouse-debug-buffer
		(print unread-command-events xterm-mouse-debug-buffer))
	    (if (and (symbolp down-where)
		     (consp down-where))
		(vector (list down-where down-data) down)
	      (vector down))))))))

;; These two variables have been converted to terminal parameters.
;;
;;(defvar xterm-mouse-x 0
;;  "Position of last xterm mouse event relative to the frame.")
;;
;;(defvar xterm-mouse-y 0
;;  "Position of last xterm mouse event relative to the frame.")

(defvar xt-mouse-epoch nil)

;; Indicator for the xterm-mouse mode.

(defun xterm-mouse-position-function (pos)
  "Bound to `mouse-position-function' in XTerm mouse mode."
  (when (terminal-parameter nil 'xterm-mouse-x)
    (setcdr pos (cons (terminal-parameter nil 'xterm-mouse-x)
		      (terminal-parameter nil 'xterm-mouse-y))))
  pos)

;; Read XTerm sequences above ASCII 127 (#x7f)
(defun xterm-mouse-event-read ()
  ;; We get the characters decoded by the keyboard coding system.  Try
  ;; to recover the raw character.
  (let ((c (read-event)))
    (cond ;; If meta-flag is t we get a meta character
	  ((>= c ?\M-\^@)
	   (- c (- ?\M-\^@ 128)))
	  ;; Reencode the character in the keyboard coding system, if
	  ;; this is a non-ASCII character.
	  ((>= c #x80)
	   (aref (encode-coding-string (string c) (keyboard-coding-system)) 0))
	  (t c))))

(defun xterm-mouse-truncate-wrap (f)
  "Truncate with wrap-around."
  (condition-case nil
      ;; First try the built-in truncate, in case there's no overflow.
      (truncate f)
    ;; In case of overflow, do wraparound by hand.
    (range-error
     ;; In our case, we wrap around every 3 days or so, so if we assume
     ;; a maximum of 65536 wraparounds, we're safe for a couple years.
     ;; Using a power of 2 makes rounding errors less likely.
     (let* ((maxwrap (* 65536 2048))
            (dbig (truncate (/ f maxwrap)))
            (fdiff (- f (* 1.0 maxwrap dbig))))
       (+ (truncate fdiff) (* maxwrap dbig))))))

;; Normal terminal mouse click reporting: expect three bytes, of the
;; form <BUTTON+32> <X+32> <Y+32>.  Return a list (EVENT-TYPE X Y).
(defun xterm-mouse--read-event-sequence-1000 ()
  (list (let ((code (- (xterm-mouse-event-read) 32)))
	  (intern
	   ;; For buttons > 3, the release-event looks differently
	   ;; (see xc/programs/xterm/button.c, function EditorButton),
	   ;; and come in a release-event only, no down-event.
	   (cond ((>= code 64)
		  (format "mouse-%d" (- code 60)))
		 ((memq code '(8 9 10))
		  (setq xterm-mouse-last code)
		  (format "M-down-mouse-%d" (- code 7)))
		 ((= code 11)
		  (format "M-mouse-%d" (- xterm-mouse-last 7)))
		 ((= code 3)
		  ;; For buttons > 5 xterm only reports a
		  ;; button-release event.  Avoid error by mapping
		  ;; them all to mouse-1.
		  (format "mouse-%d" (+ 1 (or xterm-mouse-last 0))))
		 (t
		  (setq xterm-mouse-last code)
		  (format "down-mouse-%d" (+ 1 code))))))
	;; x and y coordinates
	(- (xterm-mouse-event-read) 33)
	(- (xterm-mouse-event-read) 33)))

;; XTerm's 1006-mode terminal mouse click reporting has the form
;; <BUTTON> ; <X> ; <Y> <M or m>, where the button and ordinates are
;; in encoded (decimal) form.  Return a list (EVENT-TYPE X Y).
(defun xterm-mouse--read-event-sequence-1006 ()
  (let (button-bytes x-bytes y-bytes c)
    (while (not (eq (setq c (xterm-mouse-event-read)) ?\;))
      (push c button-bytes))
    (while (not (eq (setq c (xterm-mouse-event-read)) ?\;))
      (push c x-bytes))
    (while (not (memq (setq c (xterm-mouse-event-read)) '(?m ?M)))
      (push c y-bytes))
    (list (let* ((code (string-to-number
			(apply 'string (nreverse button-bytes))))
		 (wheel (>= code 64))
		 (down (and (not wheel)
			    (eq c ?M))))
	    (intern (format "%s%smouse-%d"
			    (cond (wheel "")
				  ((< code 4)  "")
				  ((< code 8)  "S-")
				  ((< code 12) "M-")
				  ((< code 16) "M-S-")
				  ((< code 20) "C-")
				  ((< code 24) "C-S-")
				  ((< code 28) "C-M-")
				  ((< code 32) "C-M-S-")
				  (t
				   (error "Unexpected escape sequence from XTerm")))
			    (if down "down-" "")
			    (if wheel
				(- code 60)
			      (1+ (setq xterm-mouse-last (mod code 4)))))))
	  (1- (string-to-number (apply 'string (nreverse x-bytes))))
	  (1- (string-to-number (apply 'string (nreverse y-bytes)))))))

(defun xterm-mouse-event (&optional extension)
  "Convert XTerm mouse event to Emacs mouse event.
EXTENSION, if non-nil, means to use an extension to the usual
terminal mouse protocol; we currently support the value 1006,
which is the \"1006\" extension implemented in Xterm >= 277."
  (let* ((click (cond ((null extension)
		       (xterm-mouse--read-event-sequence-1000))
		      ((eq extension 1006)
		       (xterm-mouse--read-event-sequence-1006))
		      (t
		       (error "Unsupported XTerm mouse protocol"))))
	 (type (nth 0 click))
	 (x    (nth 1 click))
	 (y    (nth 2 click))
	 ;; Emulate timestamp information.  This is accurate enough
	 ;; for default value of mouse-1-click-follows-link (450msec).
	 (timestamp (xterm-mouse-truncate-wrap
                     (* 1000
                        (- (float-time)
                           (or xt-mouse-epoch
                               (setq xt-mouse-epoch (float-time)))))))
	 (w (window-at x y))
         (ltrb (window-edges w))
         (left (nth 0 ltrb))
         (top (nth 1 ltrb)))
    (set-terminal-parameter nil 'xterm-mouse-x x)
    (set-terminal-parameter nil 'xterm-mouse-y y)
    (setq
     last-input-event
     (list type
	   (let ((event (if w
			    (posn-at-x-y (- x left) (- y top) w t)
			  (append (list nil 'menu-bar)
				  (nthcdr 2 (posn-at-x-y x y))))))
	     (setcar (nthcdr 3 event) timestamp)
	     event)))))

;;;###autoload
(define-minor-mode xterm-mouse-mode
  "Toggle XTerm mouse mode.
With a prefix argument ARG, enable XTerm mouse mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

Turn it on to use Emacs mouse commands, and off to use xterm mouse commands.
This works in terminal emulators compatible with xterm.  It only
works for simple uses of the mouse.  Basically, only non-modified
single clicks are supported.  When turned on, the normal xterm
mouse functionality for such clicks is still available by holding
down the SHIFT key while pressing the mouse button."
  :global t :group 'mouse
  (let ((do-hook (if xterm-mouse-mode 'add-hook 'remove-hook)))
    (funcall do-hook 'terminal-init-xterm-hook
             'turn-on-xterm-mouse-tracking-on-terminal)
    (funcall do-hook 'delete-terminal-functions
             'turn-off-xterm-mouse-tracking-on-terminal)
    (funcall do-hook 'suspend-tty-functions
             'turn-off-xterm-mouse-tracking-on-terminal)
    (funcall do-hook 'resume-tty-functions
             'turn-on-xterm-mouse-tracking-on-terminal)
    (funcall do-hook 'suspend-hook 'turn-off-xterm-mouse-tracking)
    (funcall do-hook 'suspend-resume-hook 'turn-on-xterm-mouse-tracking)
    (funcall do-hook 'kill-emacs-hook 'turn-off-xterm-mouse-tracking))
  (if xterm-mouse-mode
      ;; Turn it on
      (progn
	(setq mouse-position-function #'xterm-mouse-position-function)
	(turn-on-xterm-mouse-tracking))
    ;; Turn it off
    (turn-off-xterm-mouse-tracking 'force)
    (setq mouse-position-function nil)))

(defun turn-on-xterm-mouse-tracking ()
  "Enable Emacs mouse tracking in xterm."
  (dolist (terminal (terminal-list))
    (turn-on-xterm-mouse-tracking-on-terminal terminal)))

(defun turn-off-xterm-mouse-tracking (&optional _force)
  "Disable Emacs mouse tracking in xterm."
  (dolist (terminal (terminal-list))
    (turn-off-xterm-mouse-tracking-on-terminal terminal)))

(defun turn-on-xterm-mouse-tracking-on-terminal (&optional terminal)
  "Enable xterm mouse tracking on TERMINAL."
  (when (and xterm-mouse-mode (eq t (terminal-live-p terminal))
	     ;; Avoid the initial terminal which is not a termcap device.
	     ;; FIXME: is there more elegant way to detect the initial terminal?
	     (not (string= (terminal-name terminal) "initial_terminal")))
    (unless (terminal-parameter terminal 'xterm-mouse-mode)
      ;; Simulate selecting a terminal by selecting one of its frames
      (with-selected-frame (car (frames-on-display-list terminal))
        (define-key input-decode-map "\e[M" 'xterm-mouse-translate)
        (define-key input-decode-map "\e[<" 'xterm-mouse-translate-extended))
      (set-terminal-parameter terminal 'xterm-mouse-mode t))
    (send-string-to-terminal "\e[?1000h" terminal)
    ;; Request extended mouse support, if available (xterm >= 277).
    (send-string-to-terminal "\e[?1006h" terminal)))

(defun turn-off-xterm-mouse-tracking-on-terminal (terminal)
  "Disable xterm mouse tracking on TERMINAL."
  ;; Only send the disable command to those terminals to which we've already
  ;; sent the enable command.
  (when (and (terminal-parameter terminal 'xterm-mouse-mode)
             (eq t (terminal-live-p terminal))
	     ;; Avoid the initial terminal which is not a termcap device.
	     ;; FIXME: is there more elegant way to detect the initial terminal?
	     (not (string= (terminal-name terminal) "initial_terminal")))
    ;; We could remove the key-binding and unset the `xterm-mouse-mode'
    ;; terminal parameter, but it seems less harmful to send this escape
    ;; command too many times (or to catch an unintended key sequence), than
    ;; to send it too few times (or to fail to let xterm-mouse events
    ;; pass by untranslated).
    (send-string-to-terminal "\e[?1000l" terminal)
    (send-string-to-terminal "\e[?1006l" terminal)))

(provide 'xt-mouse)

;;; xt-mouse.el ends here
