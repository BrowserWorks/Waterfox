;;; electric.el --- window maker and Command loop for `electric' modes

;; Copyright (C) 1985-1986, 1995, 2001-2014 Free Software Foundation,
;; Inc.

;; Author: K. Shane Hartman
;; Maintainer: emacs-devel@gnu.org
;; Keywords: extensions

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

;; "Electric" has been used in Emacs to refer to different things.
;; Among them:
;;
;; - electric modes and buffers: modes that typically pop-up in a modal kind of
;;   way a transient buffer that automatically disappears as soon as the user
;;   is done with it.
;;
;; - electric keys: self inserting keys which additionally perform some side
;;   operation which happens to be often convenient at that time.  Examples of
;;   such side operations are: reindenting code, inserting a newline,
;;   ... auto-fill-mode and abbrev-mode can be considered as built-in forms of
;;   electric key behavior.

;;; Code:

;; This loop is the guts for non-standard modes which retain control
;; until some event occurs.  It is a `do-forever', the only way out is
;; to throw.  It assumes that you have set up the keymap, window, and
;; everything else: all it does is read commands and execute them -
;; providing error messages should one occur (if there is no loop
;; function - which see).  The required argument is a tag which should
;; expect a value of nil if the user decides to punt. The second
;; argument is the prompt to be used: if nil, use "->", if 'noprompt,
;; don't use a prompt, if a string, use that string as prompt, and if
;; a function of no variable, it will be evaluated in every iteration
;; of the loop and its return value, which can be nil, 'noprompt or a
;; string, will be used as prompt.  Given third argument non-nil, it
;; INHIBITS quitting unless the user types C-g at toplevel.  This is
;; so user can do things like C-u C-g and not get thrown out.  Fourth
;; argument, if non-nil, should be a function of two arguments which
;; is called after every command is executed.  The fifth argument, if
;; provided, is the state variable for the function.  If the
;; loop-function gets an error, the loop will abort WITHOUT throwing
;; (moral: use unwind-protect around call to this function for any
;; critical stuff).  The second argument for the loop function is the
;; conditions for any error that occurred or nil if none.

(defun Electric-command-loop (return-tag
			      &optional prompt inhibit-quitting
					loop-function loop-state)

  (let (cmd
        (err nil)
        (inhibit-quit inhibit-quitting)
        (prompt-string prompt))
    (while t
      (if (functionp prompt)
          (setq prompt-string (funcall prompt)))
      (if (not (stringp prompt-string))
          (setq prompt-string (unless (eq prompt-string 'noprompt) "->")))
      (setq cmd (read-key-sequence prompt-string))
      (setq last-command-event (aref cmd (1- (length cmd)))
	    this-command (key-binding cmd t)
	    cmd this-command)
      (if (or (prog1 quit-flag (setq quit-flag nil))
	      (eq last-input-event ?\C-g))
	  (progn (setq unread-command-events nil
		       prefix-arg nil)
		 ;; If it wasn't canceling a prefix character, then quit.
		 (if (or (= (length (this-command-keys)) 1)
			 (not inhibit-quit)) ; safety
		     (progn (ding)
			    (message "Quit")
			    (throw return-tag nil))
		   (setq cmd nil))))
      (setq current-prefix-arg prefix-arg)
      (if cmd
	  (condition-case conditions
	      (progn (command-execute cmd)
		     (setq last-command this-command)
		     (if (or (prog1 quit-flag (setq quit-flag nil))
			     (eq last-input-event ?\C-g))
			 (progn (setq unread-command-events nil)
				(if (not inhibit-quit)
				    (progn (ding)
					   (message "Quit")
					   (throw return-tag nil))
				  (ding)))))
	    (buffer-read-only (if loop-function
				  (setq err conditions)
				(ding)
				(message "Buffer is read-only")
				(sit-for 2)))
	    (beginning-of-buffer (if loop-function
				     (setq err conditions)
				   (ding)
				   (message "Beginning of Buffer")
				   (sit-for 2)))
	    (end-of-buffer (if loop-function
			       (setq err conditions)
			     (ding)
			     (message "End of Buffer")
			     (sit-for 2)))
	    (error (if loop-function
		       (setq err conditions)
		     (ding)
		     (message "Error: %s"
			      (if (eq (car conditions) 'error)
				  (car (cdr conditions))
				(prin1-to-string conditions)))
		     (sit-for 2))))
	(ding))
      (if loop-function (funcall loop-function loop-state err))))
  (ding)
  (throw return-tag nil))

;; This function is like pop-to-buffer, sort of.
;; The algorithm is
;; If there is a window displaying buffer
;; 	Select it
;; Else if there is only one window
;; 	Split it, selecting the window on the bottom with height being
;; 	the lesser of max-height (if non-nil) and the number of lines in
;;      the buffer to be displayed subject to window-min-height constraint.
;; Else
;; 	Switch to buffer in the current window.
;;
;; Then if max-height is nil, and not all of the lines in the buffer
;; are displayed, grab the whole frame.
;;
;; Returns selected window on buffer positioned at point-min.

(defun Electric-pop-up-window (buffer &optional max-height)
  (let* ((win (or (get-buffer-window buffer) (selected-window)))
	 (buf (get-buffer buffer))
	 (one-window (one-window-p t))
	 (pop-up-windows t)
	 (pop-up-frames nil))
    (if (not buf)
	(error "Buffer %s does not exist" buffer)
      (cond ((and (eq (window-buffer win) buf))
	     (select-window win))
	    (one-window
	     (pop-to-buffer buffer)
	     (setq win (selected-window)))
	    (t
	     (switch-to-buffer buf)))
      ;; Don't shrink the window, but expand it if necessary.
      (goto-char (point-min))
      (unless (= (point-max) (window-end win t))
	(fit-window-to-buffer win max-height))
      win)))

;;; Electric keys.

(defgroup electricity ()
  "Electric behavior for self inserting keys."
  :group 'editing)

(defun electric--after-char-pos ()
  "Return the position after the char we just inserted.
Returns nil when we can't find this char."
  (let ((pos (point)))
    (when (or (eq (char-before) last-command-event) ;; Sanity check.
              (save-excursion
                (or (progn (skip-chars-backward " \t")
                           (setq pos (point))
                           (eq (char-before) last-command-event))
                    (progn (skip-chars-backward " \n\t")
                           (setq pos (point))
                           (eq (char-before) last-command-event)))))
      pos)))

(defun electric--sort-post-self-insertion-hook ()
  "Ensure order of electric functions in `post-self-insertion-hook'.

Hooks in this variable interact in non-trivial ways, so a
relative order must be maintained within it."
  (setq-default post-self-insert-hook
                (sort (default-value 'post-self-insert-hook)
                      #'(lambda (fn1 fn2)
                          (< (or (get fn1 'priority) 0)
                             (or (get fn2 'priority) 0))))))

;;; Electric indentation.

;; Autoloading variables is generally undesirable, but major modes
;; should usually set this variable by adding elements to the default
;; value, which only works well if the variable is preloaded.
;;;###autoload
(defvar electric-indent-chars '(?\n)
  "Characters that should cause automatic reindentation.")

(defvar electric-indent-functions nil
  "Special hook run to decide whether to auto-indent.
Each function is called with one argument (the inserted char), with
point right after that char, and it should return t to cause indentation,
`no-indent' to prevent indentation or nil to let other functions decide.")

(defvar-local electric-indent-inhibit nil
  "If non-nil, reindentation is not appropriate for this buffer.
This should be set by major modes such as `python-mode' since
Python does not lend itself to fully automatic indentation.")

(defvar electric-indent-functions-without-reindent
  '(indent-relative indent-to-left-margin indent-relative-maybe
    py-indent-line coffee-indent-line org-indent-line yaml-indent-line
    haskell-indentation-indent-line haskell-indent-cycle haskell-simple-indent
    yaml-indent-line)
  "List of indent functions that can't reindent.
If `line-indent-function' is one of those, then `electric-indent-mode' will
not try to reindent lines.  It is normally better to make the major
mode set `electric-indent-inhibit', but this can be used as a workaround.")

(defun electric-indent-post-self-insert-function ()
  "Function that `electric-indent-mode' adds to `post-self-insert-hook'.
This indents if the hook `electric-indent-functions' returns non-nil,
or if a member of `electric-indent-chars' was typed; but not in a string
or comment."
  ;; FIXME: This reindents the current line, but what we really want instead is
  ;; to reindent the whole affected text.  That's the current line for simple
  ;; cases, but not all cases.  We do take care of the newline case in an
  ;; ad-hoc fashion, but there are still missing cases such as the case of
  ;; electric-pair-mode wrapping a region with a pair of parens.
  ;; There might be a way to get it working by analyzing buffer-undo-list, but
  ;; it looks challenging.
  (let (pos)
    (when (and
           electric-indent-mode
           ;; Don't reindent while inserting spaces at beginning of line.
           (or (not (memq last-command-event '(?\s ?\t)))
               (save-excursion (skip-chars-backward " \t") (not (bolp))))
           (setq pos (electric--after-char-pos))
           (save-excursion
             (goto-char pos)
             (let ((act (or (run-hook-with-args-until-success
                             'electric-indent-functions
                             last-command-event)
                            (memq last-command-event electric-indent-chars))))
               (not
                (or (memq act '(nil no-indent))
                    ;; In a string or comment.
                    (unless (eq act 'do-indent) (nth 8 (syntax-ppss))))))))
      ;; For newline, we want to reindent both lines and basically behave like
      ;; reindent-then-newline-and-indent (whose code we hence copied).
      (let ((at-newline (<= pos (line-beginning-position))))
        (when at-newline
          (let ((before (copy-marker (1- pos) t)))
            (save-excursion
              (unless (or (memq indent-line-function
                                electric-indent-functions-without-reindent)
                          electric-indent-inhibit)
                ;; Don't reindent the previous line if the indentation function
                ;; is not a real one.
                (goto-char before)
                (indent-according-to-mode))
              ;; We are at EOL before the call to indent-according-to-mode, and
              ;; after it we usually are as well, but not always.  We tried to
              ;; address it with `save-excursion' but that uses a normal marker
              ;; whereas we need `move after insertion', so we do the
              ;; save/restore by hand.
              (goto-char before)
              (when (eolp)
                ;; Remove the trailing whitespace after indentation because
                ;; indentation may (re)introduce the whitespace.
                (delete-horizontal-space t)))))
        (unless (and electric-indent-inhibit
                     (not at-newline))
          (indent-according-to-mode))))))

(put 'electric-indent-post-self-insert-function 'priority  60)

(defun electric-indent-just-newline (arg)
  "Insert just a newline, without any auto-indentation."
  (interactive "*P")
  (let ((electric-indent-mode nil))
    (newline arg 'interactive)))

;;;###autoload
(define-key global-map "\C-j" 'electric-newline-and-maybe-indent)
;;;###autoload
(defun electric-newline-and-maybe-indent ()
  "Insert a newline.
If `electric-indent-mode' is enabled, that's that, but if it
is *disabled* then additionally indent according to major mode.
Indentation is done using the value of `indent-line-function'.
In programming language modes, this is the same as TAB.
In some text modes, where TAB inserts a tab, this command indents to the
column specified by the function `current-left-margin'."
  (interactive "*")
  (if electric-indent-mode
      (electric-indent-just-newline nil)
    (newline-and-indent)))

;;;###autoload
(define-minor-mode electric-indent-mode
  "Toggle on-the-fly reindentation (Electric Indent mode).
With a prefix argument ARG, enable Electric Indent mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

When enabled, this reindents whenever the hook `electric-indent-functions'
returns non-nil, or if you insert a character from `electric-indent-chars'.

This is a global minor mode.  To toggle the mode in a single buffer,
use `electric-indent-local-mode'."
  :global t :group 'electricity
  :initialize 'custom-initialize-delay
  :init-value t
  (if (not electric-indent-mode)
      (unless (catch 'found
                (dolist (buf (buffer-list))
                  (with-current-buffer buf
                    (if electric-indent-mode (throw 'found t)))))
        (remove-hook 'post-self-insert-hook
                     #'electric-indent-post-self-insert-function))
    (add-hook 'post-self-insert-hook
              #'electric-indent-post-self-insert-function)
    (electric--sort-post-self-insertion-hook)))

;;;###autoload
(define-minor-mode electric-indent-local-mode
  "Toggle `electric-indent-mode' only in this buffer."
  :variable (buffer-local-value 'electric-indent-mode (current-buffer))
  (cond
   ((eq electric-indent-mode (default-value 'electric-indent-mode))
    (kill-local-variable 'electric-indent-mode))
   ((not (default-value 'electric-indent-mode))
    ;; Locally enabled, but globally disabled.
    (electric-indent-mode 1)                ; Setup the hooks.
    (setq-default electric-indent-mode nil) ; But keep it globally disabled.
    )))

;;; Electric newlines after/before/around some chars.

(defvar electric-layout-rules nil
  "List of rules saying where to automatically insert newlines.

Each rule has the form (CHAR . WHERE) where CHAR is the char that
was just inserted and WHERE specifies where to insert newlines
and can be: nil, `before', `after', `around', `after-stay', or a
function of no arguments that returns one of those symbols.

The symbols specify where in relation to CHAR the newline
character(s) should be inserted. `after-stay' means insert a
newline after CHAR but stay in the same place.")

(defun electric-layout-post-self-insert-function ()
  (let* ((rule (cdr (assq last-command-event electric-layout-rules)))
         pos)
    (when (and rule
               (setq pos (electric--after-char-pos))
               ;; Not in a string or comment.
               (not (nth 8 (save-excursion (syntax-ppss pos)))))
      (let ((end (copy-marker (point)))
            (sym (if (functionp rule) (funcall rule) rule)))
        (set-marker-insertion-type end (not (eq sym 'after-stay)))
        (goto-char pos)
        (pcase sym
          ;; FIXME: we used `newline' down here which called
          ;; self-insert-command and ran post-self-insert-hook recursively.
          ;; It happened to make electric-indent-mode work automatically with
          ;; electric-layout-mode (at the cost of re-indenting lines
          ;; multiple times), but I'm not sure it's what we want.
          ;;
          ;; FIXME: check eolp before inserting \n?
          (`before (goto-char (1- pos)) (skip-chars-backward " \t")
                   (unless (bolp) (insert "\n")))
          (`after  (insert "\n"))
          (`after-stay (save-excursion
                         (let ((electric-layout-rules nil))
                           (newline 1 t))))
          (`around (save-excursion
                     (goto-char (1- pos)) (skip-chars-backward " \t")
                     (unless (bolp) (insert "\n")))
                   (insert "\n")))      ; FIXME: check eolp before inserting \n?
        (goto-char end)))))

(put 'electric-layout-post-self-insert-function 'priority  40)

;;;###autoload
(define-minor-mode electric-layout-mode
  "Automatically insert newlines around some chars.
With a prefix argument ARG, enable Electric Layout mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.
The variable `electric-layout-rules' says when and how to insert newlines."
  :global t :group 'electricity
  (cond (electric-layout-mode
         (add-hook 'post-self-insert-hook
                   #'electric-layout-post-self-insert-function)
         (electric--sort-post-self-insertion-hook))
        (t
         (remove-hook 'post-self-insert-hook
                      #'electric-layout-post-self-insert-function))))

(provide 'electric)

;;; electric.el ends here
