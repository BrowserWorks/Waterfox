;;; elec-pair.el --- Automatic parenthesis pairing  -*- lexical-binding:t -*-

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Author: João Távora <joaotavora@gmail.com>

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

;;; Code:

(require 'electric)

;;; Electric pairing.

(defcustom electric-pair-pairs
  '((?\" . ?\"))
  "Alist of pairs that should be used regardless of major mode.

Pairs of delimiters in this list are a fallback in case they have
no syntax relevant to `electric-pair-mode' in the mode's syntax
table.

See also the variable `electric-pair-text-pairs'."
  :version "24.1"
  :group 'electricity
  :type '(repeat (cons character character)))

;;;###autoload
(defcustom electric-pair-text-pairs
  '((?\" . ?\" ))
  "Alist of pairs that should always be used in comments and strings.

Pairs of delimiters in this list are a fallback in case they have
no syntax relevant to `electric-pair-mode' in the syntax table
defined in `electric-pair-text-syntax-table'"
  :version "24.4"
  :group 'electricity
  :type '(repeat (cons character character)))

(defcustom electric-pair-skip-self #'electric-pair-default-skip-self
  "If non-nil, skip char instead of inserting a second closing paren.

When inserting a closing paren character right before the same character,
just skip that character instead, so that hitting ( followed by ) results
in \"()\" rather than \"())\".

This can be convenient for people who find it easier to hit ) than C-f.

Can also be a function of one argument (the closer char just
inserted), in which case that function's return value is
considered instead."
  :version "24.1"
  :group 'electricity
  :type '(choice
          (const :tag "Never skip" nil)
          (const :tag "Help balance" electric-pair-default-skip-self)
          (const :tag "Always skip" t)
          function))

(defcustom electric-pair-inhibit-predicate
  #'electric-pair-default-inhibit
  "Predicate to prevent insertion of a matching pair.

The function is called with a single char (the opening char just inserted).
If it returns non-nil, then `electric-pair-mode' will not insert a matching
closer."
  :version "24.4"
  :group 'electricity
  :type '(choice
          (const :tag "Conservative" electric-pair-conservative-inhibit)
          (const :tag "Help balance" electric-pair-default-inhibit)
          (const :tag "Always pair" ignore)
          function))

(defcustom electric-pair-preserve-balance t
  "Non-nil if default pairing and skipping should help balance parentheses.

The default values of `electric-pair-inhibit-predicate' and
`electric-pair-skip-self' check this variable before delegating to other
predicates responsible for making decisions on whether to pair/skip some
characters based on the actual state of the buffer's parentheses and
quotes."
  :version "24.4"
  :group 'electricity
  :type 'boolean)

(defcustom electric-pair-delete-adjacent-pairs t
  "If non-nil, backspacing an open paren also deletes adjacent closer.

Can also be a function of no arguments, in which case that function's
return value is considered instead."
  :version "24.4"
  :group 'electricity
  :type '(choice
          (const :tag "Yes" t)
          (const :tag "No" nil)
          function))

(defcustom electric-pair-open-newline-between-pairs t
  "If non-nil, a newline between adjacent parentheses opens an extra one.

Can also be a function of no arguments, in which case that function's
return value is considered instead."
  :version "24.4"
  :group 'electricity
  :type '(choice
          (const :tag "Yes" t)
          (const :tag "No" nil)
          function))

(defcustom electric-pair-skip-whitespace t
  "If non-nil skip whitespace when skipping over closing parens.

The specific kind of whitespace skipped is given by the variable
`electric-pair-skip-whitespace-chars'.

The symbol `chomp' specifies that the skipped-over whitespace
should be deleted.

Can also be a function of no arguments, in which case that function's
return value is considered instead."
  :version "24.4"
  :group 'electricity
  :type '(choice
          (const :tag "Yes, jump over whitespace" t)
          (const :tag "Yes, and delete whitespace" chomp)
          (const :tag "No, no whitespace skipping" nil)
          function))

(defcustom electric-pair-skip-whitespace-chars (list ?\t ?\s ?\n)
  "Whitespace characters considered by `electric-pair-skip-whitespace'."
  :version "24.4"
  :group 'electricity
  :type '(choice (set (const :tag "Space" ?\s)
                      (const :tag "Tab" ?\t)
                      (const :tag "Newline" ?\n))
                 (list character)))

(defun electric-pair--skip-whitespace ()
  "Skip whitespace forward, not crossing comment or string boundaries."
  (let ((saved (point))
        (string-or-comment (nth 8 (syntax-ppss))))
    (skip-chars-forward (apply #'string electric-pair-skip-whitespace-chars))
    (unless (eq string-or-comment (nth 8 (syntax-ppss)))
      (goto-char saved))))

(defvar electric-pair-text-syntax-table prog-mode-syntax-table
  "Syntax table used when pairing inside comments and strings.

`electric-pair-mode' considers this syntax table only when point in inside
quotes or comments.  If lookup fails here, `electric-pair-text-pairs' will
be considered.")

(defun electric-pair-conservative-inhibit (char)
  (or
   ;; I find it more often preferable not to pair when the
   ;; same char is next.
   (eq char (char-after))
   ;; Don't pair up when we insert the second of "" or of ((.
   (and (eq char (char-before))
	(eq char (char-before (1- (point)))))
   ;; I also find it often preferable not to pair next to a word.
   (eq (char-syntax (following-char)) ?w)))

(defun electric-pair-syntax-info (command-event)
  "Calculate a list (SYNTAX PAIR UNCONDITIONAL STRING-OR-COMMENT-START).

SYNTAX is COMMAND-EVENT's syntax character.  PAIR is
COMMAND-EVENT's pair.  UNCONDITIONAL indicates the variables
`electric-pair-pairs' or `electric-pair-text-pairs' were used to
lookup syntax.  STRING-OR-COMMENT-START indicates that point is
inside a comment or string."
  (let* ((pre-string-or-comment (or (bobp)
                                    (nth 8 (save-excursion
                                             (syntax-ppss (1- (point)))))))
         (post-string-or-comment (nth 8 (syntax-ppss (point))))
         (string-or-comment (and post-string-or-comment
                                 pre-string-or-comment))
         (table (if string-or-comment
                    electric-pair-text-syntax-table
                  (syntax-table)))
         (table-syntax-and-pair (with-syntax-table table
                                  (list (char-syntax command-event)
                                        (or (matching-paren command-event)
                                            command-event))))
         (fallback (if string-or-comment
                       (append electric-pair-text-pairs
                               electric-pair-pairs)
                     electric-pair-pairs))
         (direct (assq command-event fallback))
         (reverse (rassq command-event fallback)))
    (cond
     ((memq (car table-syntax-and-pair)
            '(?\" ?\( ?\) ?\$))
      (append table-syntax-and-pair (list nil string-or-comment)))
     (direct (if (eq (car direct) (cdr direct))
                 (list ?\" command-event t string-or-comment)
               (list ?\( (cdr direct) t string-or-comment)))
     (reverse (list ?\) (car reverse) t string-or-comment)))))

(defun electric-pair--insert (char)
  (let ((last-command-event char)
	(blink-matching-paren nil)
	(electric-pair-mode nil))
    (self-insert-command 1)))

(defun electric-pair--syntax-ppss (&optional pos where)
  "Like `syntax-ppss', but sometimes fallback to `parse-partial-sexp'.

WHERE is a list defaulting to '(string comment) and indicates
when to fallback to `parse-partial-sexp'."
  (let* ((pos (or pos (point)))
         (where (or where '(string comment)))
         (quick-ppss (syntax-ppss pos))
         (in-string (and (nth 3 quick-ppss) (memq 'string where)))
         (in-comment (and (nth 4 quick-ppss) (memq 'comment where)))
         (s-or-c-start (cond (in-string
                              (1+ (nth 8 quick-ppss)))
                             (in-comment
                              (goto-char (nth 8 quick-ppss))
                              (forward-comment (- (point-max)))
                              (skip-syntax-forward " >!")
                              (point)))))
    (if s-or-c-start
        (with-syntax-table electric-pair-text-syntax-table
          (parse-partial-sexp s-or-c-start pos))
      ;; HACK! cc-mode apparently has some `syntax-ppss' bugs
      (if (memq major-mode '(c-mode c++ mode))
          (parse-partial-sexp (point-min) pos)
        quick-ppss))))

;; Balancing means controlling pairing and skipping of parentheses
;; so that, if possible, the buffer ends up at least as balanced as
;; before, if not more.  The algorithm is slightly complex because
;; some situations like "()))" need pairing to occur at the end but
;; not at the beginning.  Balancing should also happen independently
;; for different types of parentheses, so that having your {}'s
;; unbalanced doesn't keep `electric-pair-mode' from balancing your
;; ()'s and your []'s.
(defun electric-pair--balance-info (direction string-or-comment)
  "Examine lists forward or backward according to DIRECTION's sign.

STRING-OR-COMMENT is info suitable for running `parse-partial-sexp'.

Return a cons of two descriptions (MATCHED-P . PAIR) for the
innermost and outermost lists that enclose point.  The outermost
list enclosing point is either the first top-level or first
mismatched list found by listing up.

If the outermost list is matched, don't rely on its PAIR.
If point is not enclosed by any lists, return ((t) . (t))."
  (let* (innermost
         outermost
         (table (if string-or-comment
                    electric-pair-text-syntax-table
                  (syntax-table)))
         (at-top-level-or-equivalent-fn
          ;; called when `scan-sexps' ran perfectly, when it found
          ;; a parenthesis pointing in the direction of travel.
          ;; Also when travel started inside a comment and exited it.
          #'(lambda ()
              (setq outermost (list t))
              (unless innermost
                (setq innermost (list t)))))
         (ended-prematurely-fn
          ;; called when `scan-sexps' crashed against a parenthesis
          ;; pointing opposite the direction of travel.  After
          ;; traversing that character, the idea is to travel one sexp
          ;; in the opposite direction looking for a matching
          ;; delimiter.
          #'(lambda ()
              (let* ((pos (point))
                     (matched
                      (save-excursion
                        (cond ((< direction 0)
                               (condition-case nil
                                   (eq (char-after pos)
                                       (with-syntax-table table
                                         (matching-paren
                                          (char-before
                                           (scan-sexps (point) 1)))))
                                 (scan-error nil)))
                              (t
                               ;; In this case, no need to use
                               ;; `scan-sexps', we can use some
                               ;; `electric-pair--syntax-ppss' in this
                               ;; case (which uses the quicker
                               ;; `syntax-ppss' in some cases)
                               (let* ((ppss (electric-pair--syntax-ppss
                                             (1- (point))))
                                      (start (car (last (nth 9 ppss))))
                                      (opener (char-after start)))
                                 (and start
                                      (eq (char-before pos)
                                          (or (with-syntax-table table
                                                (matching-paren opener))
                                              opener))))))))
                     (actual-pair (if (> direction 0)
                                      (char-before (point))
                                    (char-after (point)))))
                (unless innermost
                  (setq innermost (cons matched actual-pair)))
                (unless matched
                  (setq outermost (cons matched actual-pair)))))))
    (save-excursion
      (while (not outermost)
        (condition-case err
            (with-syntax-table table
              (scan-sexps (point) (if (> direction 0)
                                      (point-max)
                                    (- (point-max))))
              (funcall at-top-level-or-equivalent-fn))
          (scan-error
           (cond ((or
                   ;; some error happened and it is not of the "ended
                   ;; prematurely" kind...
                   (not (string-match "ends prematurely" (nth 1 err)))
                   ;; ... or we were in a comment and just came out of
                   ;; it.
                   (and string-or-comment
                        (not (nth 8 (syntax-ppss)))))
                  (funcall at-top-level-or-equivalent-fn))
                 (t
                  ;; exit the sexp
                  (goto-char (nth 3 err))
                  (funcall ended-prematurely-fn)))))))
    (cons innermost outermost)))

(defvar electric-pair-string-bound-function 'point-max
  "Next buffer position where strings are syntactically unexpected.
Value is a function called with no arguments and returning a
buffer position. Major modes should set this variable
buffer-locally if they experience slowness with
`electric-pair-mode' when pairing quotes.")

(defun electric-pair--unbalanced-strings-p (char)
  "Return non-nil if there are unbalanced strings started by CHAR."
  (let* ((selector-ppss (syntax-ppss))
         (relevant-ppss (save-excursion
                          (if (nth 4 selector-ppss) ; comment
                              (electric-pair--syntax-ppss
                               (progn
                                 (goto-char (nth 8 selector-ppss))
                                 (forward-comment (point-max))
                                 (skip-syntax-backward " >!")
                                 (point)))
                            (syntax-ppss
                             (funcall electric-pair-string-bound-function)))))
         (string-delim (nth 3 relevant-ppss)))
    (or (eq t string-delim)
        (eq char string-delim))))

(defun electric-pair--inside-string-p (char)
  "Return non-nil if point is inside a string started by CHAR.

A comments text is parsed with `electric-pair-text-syntax-table'.
Also consider strings within comments, but not strings within
strings."
  ;; FIXME: could also consider strings within strings by examining
  ;; delimiters.
  (let ((ppss (electric-pair--syntax-ppss (point) '(comment))))
    (memq (nth 3 ppss) (list t char))))

(defun electric-pair-inhibit-if-helps-balance (char)
  "Return non-nil if auto-pairing of CHAR would hurt parentheses' balance.

Works by first removing the character from the buffer, then doing
some list calculations, finally restoring the situation as if nothing
happened."
  (pcase (electric-pair-syntax-info char)
    (`(,syntax ,pair ,_ ,s-or-c)
     (unwind-protect
         (progn
           (delete-char -1)
           (cond ((eq ?\( syntax)
                  (let* ((pair-data
                          (electric-pair--balance-info 1 s-or-c))
                         (outermost (cdr pair-data)))
                    (cond ((car outermost)
                           nil)
                          (t
                           (eq (cdr outermost) pair)))))
                 ((eq syntax ?\")
                  (electric-pair--unbalanced-strings-p char))))
       (insert-char char)))))

(defun electric-pair-skip-if-helps-balance (char)
  "Return non-nil if skipping CHAR would benefit parentheses' balance.

Works by first removing the character from the buffer, then doing
some list calculations, finally restoring the situation as if nothing
happened."
  (pcase (electric-pair-syntax-info char)
    (`(,syntax ,pair ,_ ,s-or-c)
     (unwind-protect
         (progn
           (delete-char -1)
           (cond ((eq syntax ?\))
                  (let* ((pair-data
                          (electric-pair--balance-info
                           -1 s-or-c))
                         (innermost (car pair-data))
                         (outermost (cdr pair-data)))
                    (and
                     (cond ((car outermost)
                            (car innermost))
                           ((car innermost)
                            (not (eq (cdr outermost) pair)))))))
                 ((eq syntax ?\")
                  (electric-pair--inside-string-p char))))
       (insert-char char)))))

(defun electric-pair-default-skip-self (char)
  (if electric-pair-preserve-balance
      (electric-pair-skip-if-helps-balance char)
    t))

(defun electric-pair-default-inhibit (char)
  (if electric-pair-preserve-balance
      (electric-pair-inhibit-if-helps-balance char)
    (electric-pair-conservative-inhibit char)))

(defun electric-pair-post-self-insert-function ()
  (let* ((pos (and electric-pair-mode (electric--after-char-pos)))
         (skip-whitespace-info))
    (pcase (electric-pair-syntax-info last-command-event)
      (`(,syntax ,pair ,unconditional ,_)
       (cond
        ((null pos) nil)
        ;; Wrap a pair around the active region.
        ;;
        ((and (memq syntax '(?\( ?\) ?\" ?\$)) (use-region-p))
         ;; FIXME: To do this right, we'd need a post-self-insert-function
         ;; so we could add-function around it and insert the closer after
         ;; all the rest of the hook has run.
         (if (or (eq syntax ?\")
                 (and (eq syntax ?\))
                      (>= (point) (mark)))
                 (and (not (eq syntax ?\)))
                      (>= (mark) (point))))
             (save-excursion
               (goto-char (mark))
               (electric-pair--insert pair))
           (delete-region pos (1- pos))
           (electric-pair--insert pair)
           (goto-char (mark))
           (electric-pair--insert last-command-event)))
        ;; Backslash-escaped: no pairing, no skipping.
        ((save-excursion
           (goto-char (1- pos))
           (not (zerop (% (skip-syntax-backward "\\") 2))))
         nil)
        ;; Skip self.
        ((and (memq syntax '(?\) ?\" ?\$))
              (and (or unconditional
                       (if (functionp electric-pair-skip-self)
                           (funcall electric-pair-skip-self last-command-event)
                         electric-pair-skip-self))
                   (save-excursion
                     (when (and (not (and unconditional
                                          (eq syntax ?\")))
                                (setq skip-whitespace-info
                                      (if (functionp electric-pair-skip-whitespace)
                                          (funcall electric-pair-skip-whitespace)
                                        electric-pair-skip-whitespace)))
                       (electric-pair--skip-whitespace))
                     (eq (char-after) last-command-event))))
         ;; This is too late: rather than insert&delete we'd want to only
         ;; skip (or insert in overwrite mode).  The difference is in what
         ;; goes in the undo-log and in the intermediate state which might
         ;; be visible to other post-self-insert-hook.  We'll just have to
         ;; live with it for now.
         (when skip-whitespace-info
           (electric-pair--skip-whitespace))
         (delete-region (1- pos) (if (eq skip-whitespace-info 'chomp)
                                     (point)
                                   pos))
         (forward-char))
        ;; Insert matching pair.
        ((and (memq syntax `(?\( ?\" ?\$))
              (not overwrite-mode)
              (or unconditional
                  (not (funcall electric-pair-inhibit-predicate
                                last-command-event))))
         (save-excursion (electric-pair--insert pair)))))
      (t
       (when (and (if (functionp electric-pair-open-newline-between-pairs)
                      (funcall electric-pair-open-newline-between-pairs)
                    electric-pair-open-newline-between-pairs)
                  (eq last-command-event ?\n)
                  (< (1+ (point-min)) (point) (point-max))
                  (eq (save-excursion
                        (skip-chars-backward "\t\s")
                        (char-before (1- (point))))
                      (matching-paren (char-after))))
         (save-excursion (newline 1 t)))))))

(put 'electric-pair-post-self-insert-function   'priority  20)

(defun electric-pair-will-use-region ()
  (and (use-region-p)
       (memq (car (electric-pair-syntax-info last-command-event))
             '(?\( ?\) ?\" ?\$))))

(defun electric-pair-delete-pair (arg &optional killp)
  "When between adjacent paired delimiters, delete both of them.
ARG and KILLP are passed directly to
`backward-delete-char-untabify', which see."
  (interactive "*p\nP")
  (delete-char 1)
  (backward-delete-char-untabify arg killp))

(defvar electric-pair-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\177"
      `(menu-item
        "" electric-pair-delete-pair
        :filter
        ,(lambda (cmd)
           (let* ((prev (char-before))
                  (next (char-after))
                  (syntax-info (and prev
                                    (electric-pair-syntax-info prev)))
                  (syntax (car syntax-info))
                  (pair (cadr syntax-info)))
             (and next pair
                  (memq syntax '(?\( ?\" ?\$))
                  (eq pair next)
                  (if (functionp electric-pair-delete-adjacent-pairs)
                      (funcall electric-pair-delete-adjacent-pairs)
                    electric-pair-delete-adjacent-pairs)
                  cmd)))))
    map)
  "Keymap used by `electric-pair-mode'.")

;;;###autoload
(define-minor-mode electric-pair-mode
  "Toggle automatic parens pairing (Electric Pair mode).
With a prefix argument ARG, enable Electric Pair mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

Electric Pair mode is a global minor mode.  When enabled, typing
an open parenthesis automatically inserts the corresponding
closing parenthesis.  (Likewise for brackets, etc.)."
  :global t :group 'electricity
  (if electric-pair-mode
      (progn
	(add-hook 'post-self-insert-hook
		  #'electric-pair-post-self-insert-function)
        (electric--sort-post-self-insertion-hook)
	(add-hook 'self-insert-uses-region-functions
		  #'electric-pair-will-use-region))
    (remove-hook 'post-self-insert-hook
                 #'electric-pair-post-self-insert-function)
    (remove-hook 'self-insert-uses-region-functions
                 #'electric-pair-will-use-region)))

(provide 'elec-pair)

;;; elec-pair.el ends here
