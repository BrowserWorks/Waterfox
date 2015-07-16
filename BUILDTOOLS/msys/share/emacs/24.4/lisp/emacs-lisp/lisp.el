;;; lisp.el --- Lisp editing commands for Emacs  -*- lexical-binding:t -*-

;; Copyright (C) 1985-1986, 1994, 2000-2014 Free Software Foundation,
;; Inc.

;; Maintainer: emacs-devel@gnu.org
;; Keywords: lisp, languages
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

;; Lisp editing commands to go with Lisp major mode.  More-or-less
;; applicable in other modes too.

;;; Code:

;; Note that this variable is used by non-lisp modes too.
(defcustom defun-prompt-regexp nil
  "If non-nil, a regexp to ignore before a defun.
This is only necessary if the opening paren or brace is not in column 0.
See function `beginning-of-defun'."
  :type '(choice (const nil)
		 regexp)
  :group 'lisp)
(make-variable-buffer-local 'defun-prompt-regexp)

(defcustom parens-require-spaces t
  "If non-nil, add whitespace as needed when inserting parentheses.
This affects `insert-parentheses' and `insert-pair'."
  :type 'boolean
  :group 'lisp)

(defvar forward-sexp-function nil
  ;; FIXME:
  ;; - for some uses, we may want a "sexp-only" version, which only
  ;;   jumps over a well-formed sexp, rather than some dwimish thing
  ;;   like jumping from an "else" back up to its "if".
  ;; - for up-list, we could use the "sexp-only" behavior as well
  ;;   to treat the dwimish halfsexp as a form of "up-list" step.
  "If non-nil, `forward-sexp' delegates to this function.
Should take the same arguments and behave similarly to `forward-sexp'.")

(defun forward-sexp (&optional arg)
  "Move forward across one balanced expression (sexp).
With ARG, do it that many times.  Negative arg -N means
move backward across N balanced expressions.
This command assumes point is not in a string or comment.
Calls `forward-sexp-function' to do the work, if that is non-nil."
  (interactive "^p")
  (or arg (setq arg 1))
  (if forward-sexp-function
      (funcall forward-sexp-function arg)
    (goto-char (or (scan-sexps (point) arg) (buffer-end arg)))
    (if (< arg 0) (backward-prefix-chars))))

(defun backward-sexp (&optional arg)
  "Move backward across one balanced expression (sexp).
With ARG, do it that many times.  Negative arg -N means
move forward across N balanced expressions.
This command assumes point is not in a string or comment.
Uses `forward-sexp' to do the work."
  (interactive "^p")
  (or arg (setq arg 1))
  (forward-sexp (- arg)))

(defun mark-sexp (&optional arg allow-extend)
  "Set mark ARG sexps from point.
The place mark goes is the same place \\[forward-sexp] would
move to with the same argument.
Interactively, if this command is repeated
or (in Transient Mark mode) if the mark is active,
it marks the next ARG sexps after the ones already marked.
This command assumes point is not in a string or comment."
  (interactive "P\np")
  (cond ((and allow-extend
	      (or (and (eq last-command this-command) (mark t))
		  (and transient-mark-mode mark-active)))
	 (setq arg (if arg (prefix-numeric-value arg)
		     (if (< (mark) (point)) -1 1)))
	 (set-mark
	  (save-excursion
	    (goto-char (mark))
	    (forward-sexp arg)
	    (point))))
	(t
	 (push-mark
	  (save-excursion
	    (forward-sexp (prefix-numeric-value arg))
	    (point))
	  nil t))))

(defun forward-list (&optional arg)
  "Move forward across one balanced group of parentheses.
This command will also work on other parentheses-like expressions
defined by the current language mode.
With ARG, do it that many times.
Negative arg -N means move backward across N groups of parentheses.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (goto-char (or (scan-lists (point) arg 0) (buffer-end arg))))

(defun backward-list (&optional arg)
  "Move backward across one balanced group of parentheses.
This command will also work on other parentheses-like expressions
defined by the current language mode.
With ARG, do it that many times.
Negative arg -N means move forward across N groups of parentheses.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (forward-list (- arg)))

(defun down-list (&optional arg)
  "Move forward down one level of parentheses.
This command will also work on other parentheses-like expressions
defined by the current language mode.
With ARG, do this that many times.
A negative argument means move backward but still go down a level.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (let ((inc (if (> arg 0) 1 -1)))
    (while (/= arg 0)
      (goto-char (or (scan-lists (point) inc -1) (buffer-end arg)))
      (setq arg (- arg inc)))))

(defun backward-up-list (&optional arg)
  "Move backward out of one level of parentheses.
This command will also work on other parentheses-like expressions
defined by the current language mode.
With ARG, do this that many times.
A negative argument means move forward but still to a less deep spot.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (up-list (- (or arg 1))))

(defun up-list (&optional arg)
  "Move forward out of one level of parentheses.
This command will also work on other parentheses-like expressions
defined by the current language mode.
With ARG, do this that many times.
A negative argument means move backward but still to a less deep spot.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (let ((inc (if (> arg 0) 1 -1))
        pos)
    (while (/= arg 0)
      (if (null forward-sexp-function)
          (goto-char (or (scan-lists (point) inc 1) (buffer-end arg)))
	(condition-case err
	    (while (progn (setq pos (point))
			  (forward-sexp inc)
			  (/= (point) pos)))
	  (scan-error (goto-char (nth (if (> arg 0) 3 2) err))))
	(if (= (point) pos)
            (signal 'scan-error
                    (list "Unbalanced parentheses" (point) (point)))))
      (setq arg (- arg inc)))))

(defun kill-sexp (&optional arg)
  "Kill the sexp (balanced expression) following point.
With ARG, kill that many sexps after point.
Negative arg -N means kill N sexps before point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (let ((opoint (point)))
    (forward-sexp (or arg 1))
    (kill-region opoint (point))))

(defun backward-kill-sexp (&optional arg)
  "Kill the sexp (balanced expression) preceding point.
With ARG, kill that many sexps before point.
Negative arg -N means kill N sexps after point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (kill-sexp (- (or arg 1))))

;; After Zmacs:
(defun kill-backward-up-list (&optional arg)
  "Kill the form containing the current sexp, leaving the sexp itself.
A prefix argument ARG causes the relevant number of surrounding
forms to be removed.
This command assumes point is not in a string or comment."
  (interactive "*p")
  (let ((current-sexp (thing-at-point 'sexp)))
    (if current-sexp
        (save-excursion
          (backward-up-list arg)
          (kill-sexp)
          (insert current-sexp))
      (error "Not at a sexp"))))

(defvar beginning-of-defun-function nil
  "If non-nil, function for `beginning-of-defun-raw' to call.
This is used to find the beginning of the defun instead of using the
normal recipe (see `beginning-of-defun').  Major modes can define this
if defining `defun-prompt-regexp' is not sufficient to handle the mode's
needs.

The function takes the same argument as `beginning-of-defun' and should
behave similarly, returning non-nil if it found the beginning of a defun.
Ideally it should move to a point right before an open-paren which encloses
the body of the defun.")

(defun beginning-of-defun (&optional arg)
  "Move backward to the beginning of a defun.
With ARG, do it that many times.  Negative ARG means move forward
to the ARGth following beginning of defun.

If search is successful, return t; point ends up at the beginning
of the line where the search succeeded.  Otherwise, return nil.

When `open-paren-in-column-0-is-defun-start' is non-nil, a defun
is assumed to start where there is a char with open-parenthesis
syntax at the beginning of a line.  If `defun-prompt-regexp' is
non-nil, then a string which matches that regexp may also precede
the open-parenthesis.  If `defun-prompt-regexp' and
`open-paren-in-column-0-is-defun-start' are both nil, this
function instead finds an open-paren at the outermost level.

If the variable `beginning-of-defun-function' is non-nil, its
value is called as a function, with argument ARG, to find the
defun's beginning.

Regardless of the values of `defun-prompt-regexp' and
`beginning-of-defun-function', point always moves to the
beginning of the line whenever the search is successful."
  (interactive "^p")
  (or (not (eq this-command 'beginning-of-defun))
      (eq last-command 'beginning-of-defun)
      (and transient-mark-mode mark-active)
      (push-mark))
  (and (beginning-of-defun-raw arg)
       (progn (beginning-of-line) t)))

(defun beginning-of-defun-raw (&optional arg)
  "Move point to the character that starts a defun.
This is identical to function `beginning-of-defun', except that point
does not move to the beginning of the line when `defun-prompt-regexp'
is non-nil.

If variable `beginning-of-defun-function' is non-nil, its value
is called as a function to find the defun's beginning."
  (interactive "^p")   ; change this to "P", maybe, if we ever come to pass ARG
                      ; to beginning-of-defun-function.
  (unless arg (setq arg 1))
  (cond
   (beginning-of-defun-function
    (condition-case nil
        (funcall beginning-of-defun-function arg)
      ;; We used to define beginning-of-defun-function as taking no argument
      ;; but that makes it impossible to implement correct forward motion:
      ;; we used to use end-of-defun for that, but it's not supposed to do
      ;; the same thing (it moves to the end of a defun not to the beginning
      ;; of the next).
      ;; In case the beginning-of-defun-function uses the old calling
      ;; convention, fallback on the old implementation.
      (wrong-number-of-arguments
       (if (> arg 0)
           (dotimes (_ arg)
             (funcall beginning-of-defun-function))
	 (dotimes (_ (- arg))
	   (funcall end-of-defun-function))))))

   ((or defun-prompt-regexp open-paren-in-column-0-is-defun-start)
    (and (< arg 0) (not (eobp)) (forward-char 1))
    (and (re-search-backward (if defun-prompt-regexp
				 (concat (if open-paren-in-column-0-is-defun-start
					     "^\\s(\\|" "")
					 "\\(?:" defun-prompt-regexp "\\)\\s(")
			       "^\\s(")
			     nil 'move arg)
	 (progn (goto-char (1- (match-end 0)))
                t)))

   ;; If open-paren-in-column-0-is-defun-start and defun-prompt-regexp
   ;; are both nil, column 0 has no significance - so scan forward
   ;; from BOB to see how nested point is, then carry on from there.
   ;;
   ;; It is generally not a good idea to land up here, because the
   ;; call to scan-lists below can be extremely slow.  This is because
   ;; back_comment in syntax.c may have to scan from bob to find the
   ;; beginning of each comment.  Fixing this is not trivial -- cyd.

   ((eq arg 0))
   (t
    (let ((floor (point-min))
	  (ceiling (point-max))
	  (arg-+ve (> arg 0)))
      (save-restriction
	(widen)
	(let ((ppss (let (syntax-begin-function
			  font-lock-beginning-of-syntax-function)
		      (syntax-ppss)))
	      ;; position of least enclosing paren, or nil.
	      encl-pos)
	  ;; Back out of any comment/string, so that encl-pos will always
	  ;; become nil if we're at top-level.
	  (when (nth 8 ppss)
	    (goto-char (nth 8 ppss))
	    (setq ppss (syntax-ppss)))	; should be fast, due to cache.
	  (setq encl-pos (syntax-ppss-toplevel-pos ppss))
	  (if encl-pos (goto-char encl-pos))

	  (and encl-pos arg-+ve (setq arg (1- arg)))
	  (and (not encl-pos) (not arg-+ve) (not (looking-at "\\s("))
	       (setq arg (1+ arg)))

	  (condition-case nil   ; to catch crazy parens.
	      (progn
		(goto-char (scan-lists (point) (- arg) 0))
		(if arg-+ve
		    (if (>= (point) floor)
			t
		      (goto-char floor)
		      nil)
		  ;; forward to next (, or trigger the c-c
		  (goto-char (1- (scan-lists (point) 1 -1)))
		  (if (<= (point) ceiling)
		      t
		    (goto-char ceiling)
		    nil)))
	    (error
	     (goto-char (if arg-+ve floor ceiling))
	     nil))))))))

(defvar end-of-defun-function
  (lambda () (forward-sexp 1))
  "Function for `end-of-defun' to call.
This is used to find the end of the defun at point.
It is called with no argument, right after calling `beginning-of-defun-raw'.
So the function can assume that point is at the beginning of the defun body.
It should move point to the first position after the defun.")

(defun buffer-end (arg)
  "Return the \"far end\" position of the buffer, in direction ARG.
If ARG is positive, that's the end of the buffer.
Otherwise, that's the beginning of the buffer."
  (if (> arg 0) (point-max) (point-min)))

(defun end-of-defun (&optional arg)
  "Move forward to next end of defun.
With argument, do it that many times.
Negative argument -N means move back to Nth preceding end of defun.

An end of a defun occurs right after the close-parenthesis that
matches the open-parenthesis that starts a defun; see function
`beginning-of-defun'.

If variable `end-of-defun-function' is non-nil, its value
is called as a function to find the defun's end."
  (interactive "^p")
  (or (not (eq this-command 'end-of-defun))
      (eq last-command 'end-of-defun)
      (and transient-mark-mode mark-active)
      (push-mark))
  (if (or (null arg) (= arg 0)) (setq arg 1))
  (let ((pos (point))
        (beg (progn (end-of-line 1) (beginning-of-defun-raw 1) (point)))
	(skip (lambda ()
		;; When comparing point against pos, we want to consider that if
		;; point was right after the end of the function, it's still
		;; considered as "in that function".
		;; E.g. `eval-defun' from right after the last close-paren.
		(unless (bolp)
		  (skip-chars-forward " \t")
		  (if (looking-at "\\s<\\|\n")
		      (forward-line 1))))))
    (funcall end-of-defun-function)
    (funcall skip)
    (cond
     ((> arg 0)
      ;; Moving forward.
      (if (> (point) pos)
          ;; We already moved forward by one because we started from
          ;; within a function.
          (setq arg (1- arg))
        ;; We started from after the end of the previous function.
        (goto-char pos))
      (unless (zerop arg)
        (beginning-of-defun-raw (- arg))
        (funcall end-of-defun-function)))
     ((< arg 0)
      ;; Moving backward.
      (if (< (point) pos)
          ;; We already moved backward because we started from between
          ;; two functions.
          (setq arg (1+ arg))
        ;; We started from inside a function.
        (goto-char beg))
      (unless (zerop arg)
        (beginning-of-defun-raw (- arg))
	(setq beg (point))
        (funcall end-of-defun-function))))
    (funcall skip)
    (while (and (< arg 0) (>= (point) pos))
      ;; We intended to move backward, but this ended up not doing so:
      ;; Try harder!
      (goto-char beg)
      (beginning-of-defun-raw (- arg))
      (if (>= (point) beg)
	  (setq arg 0)
	(setq beg (point))
        (funcall end-of-defun-function)
	(funcall skip)))))

(defun mark-defun (&optional allow-extend)
  "Put mark at end of this defun, point at beginning.
The defun marked is the one that contains point or follows point.

Interactively, if this command is repeated
or (in Transient Mark mode) if the mark is active,
it marks the next defun after the ones already marked."
  (interactive "p")
  (cond ((and allow-extend
	      (or (and (eq last-command this-command) (mark t))
		  (and transient-mark-mode mark-active)))
	 (set-mark
	  (save-excursion
	    (goto-char (mark))
	    (end-of-defun)
	    (point))))
	(t
	 (let ((opoint (point))
	       beg end)
	   (push-mark opoint)
	   ;; Try first in this order for the sake of languages with nested
	   ;; functions where several can end at the same place as with
	   ;; the offside rule, e.g. Python.
	   (beginning-of-defun)
	   (setq beg (point))
	   (end-of-defun)
	   (setq end (point))
	   (while (looking-at "^\n")
	     (forward-line 1))
	   (if (> (point) opoint)
	       (progn
		 ;; We got the right defun.
		 (push-mark beg nil t)
		 (goto-char end)
		 (exchange-point-and-mark))
	     ;; beginning-of-defun moved back one defun
	     ;; so we got the wrong one.
	     (goto-char opoint)
	     (end-of-defun)
	     (push-mark (point) nil t)
	     (beginning-of-defun))
	   (re-search-backward "^\n" (- (point) 1) t)))))

(defun narrow-to-defun (&optional _arg)
  "Make text outside current defun invisible.
The defun visible is the one that contains point or follows point.
Optional ARG is ignored."
  (interactive)
  (save-excursion
    (widen)
    (let ((opoint (point))
	  beg end)
      ;; Try first in this order for the sake of languages with nested
      ;; functions where several can end at the same place as with
      ;; the offside rule, e.g. Python.

      ;; Finding the start of the function is a bit problematic since
      ;; `beginning-of-defun' when we are on the first character of
      ;; the function might go to the previous function.
      ;;
      ;; Therefore we first move one character forward and then call
      ;; `beginning-of-defun'.  However now we must check that we did
      ;; not move into the next function.
      (let ((here (point)))
        (unless (eolp)
	  (forward-char))
        (beginning-of-defun)
        (when (< (point) here)
          (goto-char here)
          (beginning-of-defun)))
      (setq beg (point))
      (end-of-defun)
      (setq end (point))
      (while (looking-at "^\n")
	(forward-line 1))
      (unless (> (point) opoint)
	;; beginning-of-defun moved back one defun
	;; so we got the wrong one.
	(goto-char opoint)
	(end-of-defun)
	(setq end (point))
	(beginning-of-defun)
	(setq beg (point)))
      (goto-char end)
      (re-search-backward "^\n" (- (point) 1) t)
      (narrow-to-region beg end))))

(defvar insert-pair-alist
  '((?\( ?\)) (?\[ ?\]) (?\{ ?\}) (?\< ?\>) (?\" ?\") (?\' ?\') (?\` ?\'))
  "Alist of paired characters inserted by `insert-pair'.
Each element looks like (OPEN-CHAR CLOSE-CHAR) or (COMMAND-CHAR
OPEN-CHAR CLOSE-CHAR).  The characters OPEN-CHAR and CLOSE-CHAR
of the pair whose key is equal to the last input character with
or without modifiers, are inserted by `insert-pair'.")

(defun insert-pair (&optional arg open close)
  "Enclose following ARG sexps in a pair of OPEN and CLOSE characters.
Leave point after the first character.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert characters
and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

If arguments OPEN and CLOSE are nil, the character pair is found
from the variable `insert-pair-alist' according to the last input
character with or without modifiers.  If no character pair is
found in the variable `insert-pair-alist', then the last input
character is inserted ARG times.

This command assumes point is not in a string or comment."
  (interactive "P")
  (if (not (and open close))
      (let ((pair (or (assq last-command-event insert-pair-alist)
                      (assq (event-basic-type last-command-event)
                            insert-pair-alist))))
        (if pair
            (if (nth 2 pair)
                (setq open (nth 1 pair) close (nth 2 pair))
              (setq open (nth 0 pair) close (nth 1 pair))))))
  (if (and open close)
      (if (and transient-mark-mode mark-active)
          (progn
            (save-excursion (goto-char (region-end))       (insert close))
            (save-excursion (goto-char (region-beginning)) (insert open)))
        (if arg (setq arg (prefix-numeric-value arg))
          (setq arg 0))
        (cond ((> arg 0) (skip-chars-forward " \t"))
              ((< arg 0) (forward-sexp arg) (setq arg (- arg))))
        (and parens-require-spaces
             (not (bobp))
             (memq (char-syntax (preceding-char)) (list ?w ?_ (char-syntax close)))
             (insert " "))
        (insert open)
        (save-excursion
          (or (eq arg 0) (forward-sexp arg))
          (insert close)
          (and parens-require-spaces
               (not (eobp))
               (memq (char-syntax (following-char)) (list ?w ?_ (char-syntax open)))
               (insert " "))))
    (insert-char (event-basic-type last-command-event)
                 (prefix-numeric-value arg))))

(defun insert-parentheses (&optional arg)
  "Enclose following ARG sexps in parentheses.
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\( ?\)))

(defun delete-pair ()
  "Delete a pair of characters enclosing the sexp that follows point."
  (interactive)
  (save-excursion (forward-sexp 1) (delete-char -1))
  (delete-char 1))

(defun raise-sexp (&optional arg)
  "Raise ARG sexps higher up the tree."
  (interactive "p")
  (let ((s (if (and transient-mark-mode mark-active)
               (buffer-substring (region-beginning) (region-end))
             (buffer-substring
              (point)
              (save-excursion (forward-sexp arg) (point))))))
    (backward-up-list 1)
    (delete-region (point) (save-excursion (forward-sexp 1) (point)))
    (save-excursion (insert s))))

(defun move-past-close-and-reindent ()
  "Move past next `)', delete indentation before it, then indent after it."
  (interactive)
  (up-list 1)
  (forward-char -1)
  (while (save-excursion		; this is my contribution
	   (let ((before-paren (point)))
	     (back-to-indentation)
	     (and (= (point) before-paren)
		  (progn
		    ;; Move to end of previous line.
		    (beginning-of-line)
		    (forward-char -1)
		    ;; Verify it doesn't end within a string or comment.
		    (let ((end (point))
			  state)
		      (beginning-of-line)
		      ;; Get state at start of line.
		      (setq state  (list 0 nil nil
					 (null (calculate-lisp-indent))
					 nil nil nil nil
					 nil))
		      ;; Parse state across the line to get state at end.
		      (setq state (parse-partial-sexp (point) end nil nil
						      state))
		      ;; Check not in string or comment.
		      (and (not (elt state 3)) (not (elt state 4))))))))
    (delete-indentation))
  (forward-char 1)
  (newline-and-indent))

(defun check-parens ()			; lame name?
  "Check for unbalanced parentheses in the current buffer.
More accurately, check the narrowed part of the buffer for unbalanced
expressions (\"sexps\") in general.  This is done according to the
current syntax table and will find unbalanced brackets or quotes as
appropriate.  (See Info node `(emacs)Parentheses'.)  If imbalance is
found, an error is signaled and point is left at the first unbalanced
character."
  (interactive)
  (condition-case data
      ;; Buffer can't have more than (point-max) sexps.
      (scan-sexps (point-min) (point-max))
    (scan-error (goto-char (nth 2 data))
		;; Could print (nth 1 data), which is either
		;; "Containing expression ends prematurely" or
		;; "Unbalanced parentheses", but those may not be so
		;; accurate/helpful, e.g. quotes may actually be
		;; mismatched.
  		(user-error "Unmatched bracket or quote"))))

(defun field-complete (table &optional predicate)
  (declare (obsolete completion-in-region "24.4"))
  (let ((minibuffer-completion-table table)
        (minibuffer-completion-predicate predicate)
        ;; This made sense for lisp-complete-symbol, but for
        ;; field-complete, this is out of place.  --Stef
        ;; (completion-annotate-function
        ;;  (unless (eq predicate 'fboundp)
        ;;    (lambda (str)
        ;;      (if (fboundp (intern-soft str)) " <f>"))))
        )
    (call-interactively 'minibuffer-complete)))

(defun lisp-complete-symbol (&optional predicate)
  "Perform completion on Lisp symbol preceding point.
Compare that symbol against the known Lisp symbols.
If no characters can be completed, display a list of possible completions.
Repeating the command at that point scrolls the list.

When called from a program, optional arg PREDICATE is a predicate
determining which symbols are considered, e.g. `commandp'.
If PREDICATE is nil, the context determines which symbols are
considered.  If the symbol starts just after an open-parenthesis, only
symbols with function definitions are considered.  Otherwise, all
symbols with function definitions, values or properties are
considered."
  (declare (obsolete completion-at-point "24.4"))
  (interactive)
  (let* ((data (lisp-completion-at-point predicate))
         (plist (nthcdr 3 data)))
    (if (null data)
        (minibuffer-message "Nothing to complete")
      (let ((completion-extra-properties plist))
        (completion-in-region (nth 0 data) (nth 1 data) (nth 2 data)
                              (plist-get plist :predicate))))))

(defun lisp--local-variables-1 (vars sexp)
  "Return the vars locally bound around the witness, or nil if not found."
  (let (res)
    (while
        (unless
            (setq res
                  (pcase sexp
                    (`(,(or `let `let*) ,bindings)
                     (let ((vars vars))
                       (when (eq 'let* (car sexp))
                         (dolist (binding (cdr (reverse bindings)))
                           (push (or (car-safe binding) binding) vars)))
                       (lisp--local-variables-1
                        vars (car (cdr-safe (car (last bindings)))))))
                    (`(,(or `let `let*) ,bindings . ,body)
                     (let ((vars vars))
                       (dolist (binding bindings)
                         (push (or (car-safe binding) binding) vars))
                       (lisp--local-variables-1 vars (car (last body)))))
                    (`(lambda ,_) (setq sexp nil))
                    (`(lambda ,args . ,body)
                     (lisp--local-variables-1
                      (append args vars) (car (last body))))
                    (`(condition-case ,_ ,e) (lisp--local-variables-1 vars e))
                    (`(condition-case ,v ,_ . ,catches)
                     (lisp--local-variables-1
                      (cons v vars) (cdr (car (last catches)))))
                    (`(quote . ,_) (setq sexp nil))
                    (`(,_ . ,_)
                     (lisp--local-variables-1 vars (car (last sexp))))
                    (`lisp--witness--lisp (or vars '(nil)))
                    (_ nil)))
          (setq sexp (ignore-errors (butlast sexp)))))
    res))

(defun lisp--local-variables ()
  "Return a list of locally let-bound variables at point."
  (save-excursion
    (skip-syntax-backward "w_")
    (let* ((ppss (syntax-ppss))
           (txt (buffer-substring-no-properties (or (car (nth 9 ppss)) (point))
                                                (or (nth 8 ppss) (point))))
           (closer ()))
      (dolist (p (nth 9 ppss))
        (push (cdr (syntax-after p)) closer))
      (setq closer (apply #'string closer))
      (let* ((sexp (condition-case nil
                       (car (read-from-string
                             (concat txt "lisp--witness--lisp" closer)))
                     (end-of-file nil)))
             (macroexpand-advice (lambda (expander form &rest args)
                                   (condition-case nil
                                       (apply expander form args)
                                     (error form))))
             (sexp
              (unwind-protect
                  (progn
                    (advice-add 'macroexpand :around macroexpand-advice)
                    (macroexpand-all sexp))
                (advice-remove 'macroexpand macroexpand-advice)))
             (vars (lisp--local-variables-1 nil sexp)))
        (delq nil
              (mapcar (lambda (var)
                        (and (symbolp var)
                             (not (string-match (symbol-name var) "\\`[&_]"))
                             ;; Eliminate uninterned vars.
                             (intern-soft var)
                             var))
                      vars))))))

(defvar lisp--local-variables-completion-table
  ;; Use `defvar' rather than `defconst' since defconst would purecopy this
  ;; value, which would doubly fail: it would fail because purecopy can't
  ;; handle the recursive bytecode object, and it would fail because it would
  ;; move `lastpos' and `lastvars' to pure space where they'd be immutable!
  (let ((lastpos nil) (lastvars nil))
    (letrec ((hookfun (lambda ()
                        (setq lastpos nil)
                        (remove-hook 'post-command-hook hookfun))))
      (completion-table-dynamic
       (lambda (_string)
         (save-excursion
           (skip-syntax-backward "_w")
           (let ((newpos (cons (point) (current-buffer))))
             (unless (equal lastpos newpos)
               (add-hook 'post-command-hook hookfun)
               (setq lastpos newpos)
               (setq lastvars
                     (mapcar #'symbol-name (lisp--local-variables))))))
         lastvars)))))

;; FIXME: Support for Company brings in features which straddle eldoc.
;; We should consolidate this, so that major modes can provide all that
;; data all at once:
;; - a function to extract "the reference at point" (may be more complex
;;     than a mere string, to distinguish various namespaces).
;; - a function to jump to such a reference.
;; - a function to show the signature/interface of such a reference.
;; - a function to build a help-buffer about that reference.
;; FIXME: Those functions should also be used by the normal completion code in
;; the *Completions* buffer.

(defun lisp--company-doc-buffer (str)
  (let ((symbol (intern-soft str)))
    ;; FIXME: we really don't want to "display-buffer and then undo it".
    (save-window-excursion
      ;; Make sure we don't display it in another frame, otherwise
      ;; save-window-excursion won't be able to undo it.
      (let ((display-buffer-overriding-action
             '(nil . ((inhibit-switch-frame . t)))))
        (ignore-errors
          (cond
           ((fboundp symbol) (describe-function symbol))
           ((boundp symbol) (describe-variable symbol))
           ((featurep symbol) (describe-package symbol))
           ((facep symbol) (describe-face symbol))
           (t (signal 'user-error nil)))
          (help-buffer))))))

(defun lisp--company-doc-string (str)
  (let* ((symbol (intern-soft str))
         (doc (if (fboundp symbol)
                  (documentation symbol t)
                (documentation-property symbol 'variable-documentation t))))
    (and (stringp doc)
         (string-match ".*$" doc)
         (match-string 0 doc))))

(declare-function find-library-name "find-func" (library))

(defun lisp--company-location (str)
  (let ((sym (intern-soft str)))
    (cond
     ((fboundp sym) (find-definition-noselect sym nil))
     ((boundp sym) (find-definition-noselect sym 'defvar))
     ((featurep sym)
      (require 'find-func)
      (cons (find-file-noselect (find-library-name
                                 (symbol-name sym)))
            0))
     ((facep sym) (find-definition-noselect sym 'defface)))))

(defun lisp-completion-at-point (&optional _predicate)
  "Function used for `completion-at-point-functions' in `emacs-lisp-mode'."
  (with-syntax-table emacs-lisp-mode-syntax-table
    (let* ((pos (point))
	   (beg (condition-case nil
		    (save-excursion
		      (backward-sexp 1)
		      (skip-syntax-forward "'")
		      (point))
		  (scan-error pos)))
	   (end
	    (unless (or (eq beg (point-max))
			(member (char-syntax (char-after beg))
                                '(?\s ?\" ?\( ?\))))
	      (condition-case nil
		  (save-excursion
		    (goto-char beg)
		    (forward-sexp 1)
		    (when (>= (point) pos)
		      (point)))
		(scan-error pos))))
           (funpos (eq (char-before beg) ?\()) ;t if in function position.
           (table-etc
            (if (not funpos)
                ;; FIXME: We could look at the first element of the list and
                ;; use it to provide a more specific completion table in some
                ;; cases.  E.g. filter out keywords that are not understood by
                ;; the macro/function being called.
                (list nil (completion-table-merge
                           lisp--local-variables-completion-table
                           (apply-partially #'completion-table-with-predicate
                                            obarray
                                            ;; Don't include all symbols
                                            ;; (bug#16646).
                                            (lambda (sym)
                                              (or (boundp sym)
                                                  (fboundp sym)
                                                  (symbol-plist sym)))
                                            'strict))
                      :annotation-function
                      (lambda (str) (if (fboundp (intern-soft str)) " <f>"))
                      :company-doc-buffer #'lisp--company-doc-buffer
                      :company-docsig #'lisp--company-doc-string
                      :company-location #'lisp--company-location)
              ;; Looks like a funcall position.  Let's double check.
              (save-excursion
                (goto-char (1- beg))
                (let ((parent
                       (condition-case nil
                           (progn (up-list -1) (forward-char 1)
                                  (let ((c (char-after)))
                                    (if (eq c ?\() ?\(
                                      (if (memq (char-syntax c) '(?w ?_))
                                          (read (current-buffer))))))
                         (error nil))))
                  (pcase parent
                    ;; FIXME: Rather than hardcode special cases here,
                    ;; we should use something like a symbol-property.
                    (`declare
                     (list t (mapcar (lambda (x) (symbol-name (car x)))
                                     (delete-dups
                                      ;; FIXME: We should include some
                                      ;; docstring with each entry.
                                      (append
                                       macro-declarations-alist
                                       defun-declarations-alist)))))
                    ((and (or `condition-case `condition-case-unless-debug)
                          (guard (save-excursion
                                   (ignore-errors
                                     (forward-sexp 2)
                                     (< (point) beg)))))
                     (list t obarray
                           :predicate (lambda (sym) (get sym 'error-conditions))))
		    ((and ?\(
			  (guard (save-excursion
				   (goto-char (1- beg))
				   (up-list -1)
				   (forward-symbol -1)
				   (looking-at "\\_<let\\*?\\_>"))))
		     (list t obarray
			   :predicate #'boundp
			   :company-doc-buffer #'lisp--company-doc-buffer
			   :company-docsig #'lisp--company-doc-string
			   :company-location #'lisp--company-location))
                    (_ (list nil obarray
                             :predicate #'fboundp
                             :company-doc-buffer #'lisp--company-doc-buffer
                             :company-docsig #'lisp--company-doc-string
                             :company-location #'lisp--company-location
                             ))))))))
      (when end
        (let ((tail (if (null (car table-etc))
                        (cdr table-etc)
                      (cons
                       (if (memq (char-syntax (or (char-after end) ?\s))
                                 '(?\s ?>))
                           (cadr table-etc)
                         (apply-partially 'completion-table-with-terminator
                                          " " (cadr table-etc)))
                       (cddr table-etc)))))
          `(,beg ,end ,@tail))))))

;;; lisp.el ends here
