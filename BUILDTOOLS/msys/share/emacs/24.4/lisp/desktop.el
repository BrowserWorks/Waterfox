;;; desktop.el --- save partial status of Emacs when killed -*- lexical-binding: t -*-

;; Copyright (C) 1993-1995, 1997, 2000-2014 Free Software Foundation, Inc.

;; Author: Morten Welinder <terra@diku.dk>
;; Keywords: convenience
;; Favorite-brand-of-beer: None, I hate beer.

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

;; Save the Desktop, i.e.,
;;	- some global variables
;; 	- the list of buffers with associated files.  For each buffer also
;;		- the major mode
;;		- the default directory
;;		- the point
;;		- the mark & mark-active
;;		- buffer-read-only
;;		- some local variables
;;	- frame and window configuration

;; To use this, use customize to turn on desktop-save-mode or add the
;; following line somewhere in your init file:
;;
;;	(desktop-save-mode 1)
;;
;; For further usage information, look at the section
;; (info "(emacs)Saving Emacs Sessions") in the GNU Emacs Manual.

;; When the desktop module is loaded, the function `desktop-kill' is
;; added to the `kill-emacs-hook'.  This function is responsible for
;; saving the desktop when Emacs is killed.  Furthermore an anonymous
;; function is added to the `after-init-hook'.  This function is
;; responsible for loading the desktop when Emacs is started.

;; Special handling.
;; -----------------
;; Variables `desktop-buffer-mode-handlers' and `desktop-minor-mode-handlers'
;; are supplied to handle special major and minor modes respectively.
;; `desktop-buffer-mode-handlers' is an alist of major mode specific functions
;; to restore a desktop buffer.  Elements must have the form
;;
;;    (MAJOR-MODE . RESTORE-BUFFER-FUNCTION).
;;
;; Functions listed are called by `desktop-create-buffer' when `desktop-read'
;; evaluates the desktop file.  Buffers with a major mode not specified here,
;; are restored by the default handler `desktop-restore-file-buffer'.
;; `desktop-minor-mode-handlers' is an alist of functions to restore
;; non-standard minor modes.  Elements must have the form
;;
;;    (MINOR-MODE . RESTORE-FUNCTION).
;;
;; Functions are called by `desktop-create-buffer' to restore minor modes.
;; Minor modes not specified here, are restored by the standard minor mode
;; function.  If you write a module that defines a major or minor mode that
;; needs a special handler, then place code like

;;    (defun foo-restore-desktop-buffer
;;    ...
;;    (add-to-list 'desktop-buffer-mode-handlers
;;                 '(foo-mode . foo-restore-desktop-buffer))

;; or

;;    (defun bar-desktop-restore
;;    ...
;;    (add-to-list 'desktop-minor-mode-handlers
;;                 '(bar-mode . bar-desktop-restore))

;; in the module itself, and make sure that the mode function is
;; autoloaded.  See the docstrings of `desktop-buffer-mode-handlers' and
;; `desktop-minor-mode-handlers' for more info.

;; Minor modes.
;; ------------
;; Conventional minor modes (see node "Minor Mode Conventions" in the elisp
;; manual) are handled in the following way:
;; When `desktop-save' saves the state of a buffer to the desktop file, it
;; saves as `desktop-minor-modes' the list of names of those variables in
;; `minor-mode-alist' that have a non-nil value.
;; When `desktop-create' restores the buffer, each of the symbols in
;; `desktop-minor-modes' is called as function with parameter 1.
;; The variables `desktop-minor-mode-table' and `desktop-minor-mode-handlers'
;; are used to handle non-conventional minor modes.  `desktop-save' uses
;; `desktop-minor-mode-table' to map minor mode variables to minor mode
;; functions before writing `desktop-minor-modes'.  If a minor mode has a
;; variable name that is different form its function name, an entry

;;    (NAME RESTORE-FUNCTION)

;; should be added to `desktop-minor-mode-table'.  If a minor mode should not
;; be restored, RESTORE-FUNCTION should be set to nil.  `desktop-create' uses
;; `desktop-minor-mode-handlers' to lookup minor modes that needs a restore
;; function different from the usual minor mode function.
;; ---------------------------------------------------------------------------

;; By the way: don't use desktop.el to customize Emacs -- the file .emacs
;; in your home directory is used for that.  Saving global default values
;; for buffers is an example of misuse.

;; PLEASE NOTE: The kill ring can be saved as specified by the variable
;; `desktop-globals-to-save' (by default it isn't).  This may result in saving
;; things you did not mean to keep.  Use M-x desktop-clear RET.

;; Thanks to  hetrick@phys.uva.nl (Jim Hetrick)      for useful ideas.
;;            avk@rtsg.mot.com (Andrew V. Klein)     for a dired tip.
;;            chris@tecc.co.uk (Chris Boucher)       for a mark tip.
;;            f89-kam@nada.kth.se (Klas Mellbourn)   for a mh-e tip.
;;            kifer@sbkifer.cs.sunysb.edu (M. Kifer) for a bug hunt.
;;            treese@lcs.mit.edu (Win Treese)        for ange-ftp tips.
;;            pot@cnuce.cnr.it (Francesco Potortì)  for misc. tips.
;; ---------------------------------------------------------------------------
;; TODO:
;;
;; Recognize more minor modes.
;; Save mark rings.

;;; Code:

(require 'cl-lib)
(require 'frameset)

(defvar desktop-file-version "206"
  "Version number of desktop file format.
Written into the desktop file and used at desktop read to provide
backward compatibility.")

;; ----------------------------------------------------------------------------
;; USER OPTIONS -- settings you might want to play with.
;; ----------------------------------------------------------------------------

(defgroup desktop nil
  "Save status of Emacs when you exit."
  :group 'frames)

;; Maintained for backward compatibility
(define-obsolete-variable-alias 'desktop-enable 'desktop-save-mode "22.1")
;;;###autoload
(define-minor-mode desktop-save-mode
  "Toggle desktop saving (Desktop Save mode).
With a prefix argument ARG, enable Desktop Save mode if ARG is positive,
and disable it otherwise.  If called from Lisp, enable the mode if ARG
is omitted or nil.

When Desktop Save mode is enabled, the state of Emacs is saved from
one session to another.  In particular, Emacs will save the desktop when
it exits (this may prompt you; see the option `desktop-save').  The next
time Emacs starts, if this mode is active it will restore the desktop.

To manually save the desktop at any time, use the command `M-x desktop-save'.
To load it, use `M-x desktop-read'.

Once a desktop file exists, Emacs will auto-save it according to the
option `desktop-auto-save-timeout'.

To see all the options you can set, browse the `desktop' customization group.

For further details, see info node `(emacs)Saving Emacs Sessions'."
  :global t
  :group 'desktop
  (if desktop-save-mode
      (desktop-auto-save-enable)
    (desktop-auto-save-disable)))

(defun desktop-save-mode-off ()
  "Disable `desktop-save-mode'.  Provided for use in hooks."
  (desktop-save-mode 0))

(defcustom desktop-save 'ask-if-new
  "Specifies whether the desktop should be saved when it is killed.
A desktop is killed when the user changes desktop or quits Emacs.
Possible values are:
   t             -- always save.
   ask           -- always ask.
   ask-if-new    -- ask if no desktop file exists, otherwise just save.
   ask-if-exists -- ask if desktop file exists, otherwise don't save.
   if-exists     -- save if desktop file exists, otherwise don't save.
   nil           -- never save.
The desktop is never saved when `desktop-save-mode' is nil.
The variables `desktop-dirname' and `desktop-base-file-name'
determine where the desktop is saved."
  :type
  '(choice
    (const :tag "Always save" t)
    (const :tag "Always ask" ask)
    (const :tag "Ask if desktop file is new, else do save" ask-if-new)
    (const :tag "Ask if desktop file exists, else don't save" ask-if-exists)
    (const :tag "Save if desktop file exists, else don't" if-exists)
    (const :tag "Never save" nil))
  :group 'desktop
  :version "22.1")

(defcustom desktop-auto-save-timeout auto-save-timeout
  "Number of seconds idle time before auto-save of the desktop.
The idle timer activates auto-saving only when window configuration changes.
This applies to an existing desktop file when `desktop-save-mode' is enabled.
Zero or nil means disable auto-saving due to idleness."
  :type '(choice (const :tag "Off" nil)
                 (integer :tag "Seconds"))
  :set (lambda (symbol value)
         (set-default symbol value)
         (ignore-errors
	   (if (and (integerp value) (> value 0))
	       (desktop-auto-save-enable value)
	     (desktop-auto-save-disable))))
  :group 'desktop
  :version "24.4")

(defcustom desktop-load-locked-desktop 'ask
  "Specifies whether the desktop should be loaded if locked.
Possible values are:
   t    -- load anyway.
   nil  -- don't load.
   ask  -- ask the user.
If the value is nil, or `ask' and the user chooses not to load the desktop,
the normal hook `desktop-not-loaded-hook' is run."
  :type
  '(choice
    (const :tag "Load anyway" t)
    (const :tag "Don't load" nil)
    (const :tag "Ask the user" ask))
  :group 'desktop
  :version "22.2")

(define-obsolete-variable-alias 'desktop-basefilename
                                'desktop-base-file-name "22.1")

(defcustom desktop-base-file-name
  (convert-standard-filename ".emacs.desktop")
  "Name of file for Emacs desktop, excluding the directory part."
  :type 'file
  :group 'desktop)

(defcustom desktop-base-lock-name
  (convert-standard-filename ".emacs.desktop.lock")
  "Name of lock file for Emacs desktop, excluding the directory part."
  :type 'file
  :group 'desktop
  :version "22.2")

(defcustom desktop-path (list user-emacs-directory "~")
  "List of directories to search for the desktop file.
The base name of the file is specified in `desktop-base-file-name'."
  :type '(repeat directory)
  :group 'desktop
  :version "23.2")                      ; user-emacs-directory added

(defcustom desktop-missing-file-warning nil
  "If non-nil, offer to recreate the buffer of a deleted file.
Also pause for a moment to display message about errors signaled in
`desktop-buffer-mode-handlers'.

If nil, just print error messages in the message buffer."
  :type 'boolean
  :group 'desktop
  :version "22.1")

(defcustom desktop-no-desktop-file-hook nil
  "Normal hook run when `desktop-read' can't find a desktop file.
Run in the directory in which the desktop file was sought.
May be used to show a dired buffer."
  :type 'hook
  :group 'desktop
  :version "22.1")

(defcustom desktop-not-loaded-hook nil
  "Normal hook run when the user declines to re-use a desktop file.
Run in the directory in which the desktop file was found.
May be used to deal with accidental multiple Emacs jobs."
  :type 'hook
  :group 'desktop
  :options '(desktop-save-mode-off save-buffers-kill-emacs)
  :version "22.2")

(defcustom desktop-after-read-hook nil
  "Normal hook run after a successful `desktop-read'.
May be used to show a buffer list."
  :type 'hook
  :group 'desktop
  :options '(list-buffers)
  :version "22.1")

(defcustom desktop-save-hook nil
  "Normal hook run before the desktop is saved in a desktop file.
Run with the desktop buffer current with only the header present.
May be used to add to the desktop code or to truncate history lists,
for example."
  :type 'hook
  :group 'desktop)

(defcustom desktop-globals-to-save
  '(desktop-missing-file-warning
    tags-file-name
    tags-table-list
    search-ring
    regexp-search-ring
    register-alist
    file-name-history)
  "List of global variables saved by `desktop-save'.
An element may be variable name (a symbol) or a cons cell of the form
\(VAR . MAX-SIZE), which means to truncate VAR's value to at most
MAX-SIZE elements (if the value is a list) before saving the value.
Feature: Saving `kill-ring' implies saving `kill-ring-yank-pointer'."
  :type '(repeat (restricted-sexp :match-alternatives (symbolp consp)))
  :group 'desktop)

(defcustom desktop-globals-to-clear
  '(kill-ring
    kill-ring-yank-pointer
    search-ring
    search-ring-yank-pointer
    regexp-search-ring
    regexp-search-ring-yank-pointer)
  "List of global variables that `desktop-clear' will clear.
An element may be variable name (a symbol) or a cons cell of the form
\(VAR . FORM).  Symbols are set to nil and for cons cells VAR is set
to the value obtained by evaluating FORM."
  :type '(repeat (restricted-sexp :match-alternatives (symbolp consp)))
  :group 'desktop
  :version "22.1")

(defcustom desktop-clear-preserve-buffers
  '("\\*scratch\\*" "\\*Messages\\*" "\\*server\\*" "\\*tramp/.+\\*"
    "\\*Warnings\\*")
  "List of buffers that `desktop-clear' should not delete.
Each element is a regular expression.  Buffers with a name matched by any of
these won't be deleted."
  :version "23.3"                       ; added Warnings - bug#6336
  :type '(repeat string)
  :group 'desktop)

;;;###autoload
(defcustom desktop-locals-to-save
  '(desktop-locals-to-save  ; Itself!  Think it over.
    truncate-lines
    case-fold-search
    case-replace
    fill-column
    overwrite-mode
    change-log-default-name
    line-number-mode
    column-number-mode
    size-indication-mode
    buffer-file-coding-system
    indent-tabs-mode
    tab-width
    indicate-buffer-boundaries
    indicate-empty-lines
    show-trailing-whitespace)
  "List of local variables to save for each buffer.
The variables are saved only when they really are local.  Conventional minor
modes are restored automatically; they should not be listed here."
  :type '(repeat symbol)
  :group 'desktop)

(defcustom desktop-buffers-not-to-save "\\` "
  "Regexp identifying buffers that are to be excluded from saving."
  :type '(choice (const :tag "None" nil)
		 regexp)
  :version "24.4"		    ; skip invisible temporary buffers
  :group 'desktop)

;; Skip tramp and ange-ftp files
(defcustom desktop-files-not-to-save
  "\\(^/[^/:]*:\\|(ftp)$\\)"
  "Regexp identifying files whose buffers are to be excluded from saving."
  :type '(choice (const :tag "None" nil)
		 regexp)
  :group 'desktop)

;; We skip TAGS files to save time (tags-file-name is saved instead).
(defcustom desktop-modes-not-to-save
  '(tags-table-mode)
  "List of major modes whose buffers should not be saved."
  :type '(repeat symbol)
  :group 'desktop)

(defcustom desktop-restore-frames t
  "When non-nil, save and restore the frame and window configuration.
See related options `desktop-restore-reuses-frames',
`desktop-restore-in-current-display', and `desktop-restore-forces-onscreen'."
  :type 'boolean
  :group 'desktop
  :version "24.4")

(defcustom desktop-restore-in-current-display nil
  "Controls how restoring of frames treats displays.
If t, restores frames into the current display.
If nil, restores frames into their original displays (if possible).
If `delete', deletes frames on other displays instead of restoring them."
  :type '(choice (const :tag "Restore in current display" t)
		 (const :tag "Restore in original display" nil)
		 (const :tag "Delete frames in other displays" delete))
  :group 'desktop
  :version "24.4")

(defcustom desktop-restore-forces-onscreen t
  "If t, restores frames that are fully offscreen onscreen instead.
If `all', also restores frames that are partially offscreen onscreen.

Note that checking of frame boundaries is only approximate.
It can fail to reliably detect frames whose onscreen/offscreen state
depends on a few pixels, especially near the right / bottom borders
of the screen."
  :type '(choice (const :tag "Only fully offscreen frames" t)
		 (const :tag "Also partially offscreen frames" all)
		 (const :tag "Do not force frames onscreen" nil))
  :group 'desktop
  :version "24.4")

(defcustom desktop-restore-reuses-frames t
  "If t, restoring frames reuses existing frames.
If nil, deletes existing frames.
If `keep', keeps existing frames and does not reuse them."
  :type '(choice (const :tag "Reuse existing frames" t)
		 (const :tag "Delete existing frames" nil)
		 (const :tag "Keep existing frames" :keep))
  :group 'desktop
  :version "24.4")

(defcustom desktop-file-name-format 'absolute
  "Format in which desktop file names should be saved.
Possible values are:
   absolute -- Absolute file name.
   tilde    -- Relative to ~.
   local    -- Relative to directory of desktop file."
  :type '(choice (const absolute) (const tilde) (const local))
  :group 'desktop
  :version "22.1")

(defcustom desktop-restore-eager t
  "Number of buffers to restore immediately.
Remaining buffers are restored lazily (when Emacs is idle).
If value is t, all buffers are restored immediately."
  :type '(choice (const t) integer)
  :group 'desktop
  :version "22.1")

(defcustom desktop-lazy-verbose t
  "Verbose reporting of lazily created buffers."
  :type 'boolean
  :group 'desktop
  :version "22.1")

(defcustom desktop-lazy-idle-delay 5
  "Idle delay before starting to create buffers.
See `desktop-restore-eager'."
  :type 'integer
  :group 'desktop
  :version "22.1")

;;;###autoload
(defvar-local desktop-save-buffer nil
  "When non-nil, save buffer status in desktop file.

If the value is a function, it is called by `desktop-save' with argument
DESKTOP-DIRNAME to obtain auxiliary information to save in the desktop
file along with the state of the buffer for which it was called.

When file names are returned, they should be formatted using the call
\"(desktop-file-name FILE-NAME DESKTOP-DIRNAME)\".

Later, when `desktop-read' evaluates the desktop file, auxiliary information
is passed as the argument DESKTOP-BUFFER-MISC to functions in
`desktop-buffer-mode-handlers'.")
(make-obsolete-variable 'desktop-buffer-modes-to-save
                        'desktop-save-buffer "22.1")
(make-obsolete-variable 'desktop-buffer-misc-functions
                        'desktop-save-buffer "22.1")

;;;###autoload
(defvar desktop-buffer-mode-handlers nil
  "Alist of major mode specific functions to restore a desktop buffer.
Functions listed are called by `desktop-create-buffer' when `desktop-read'
evaluates the desktop file.  List elements must have the form

   (MAJOR-MODE . RESTORE-BUFFER-FUNCTION).

Buffers with a major mode not specified here, are restored by the default
handler `desktop-restore-file-buffer'.

Handlers are called with argument list

   (DESKTOP-BUFFER-FILE-NAME DESKTOP-BUFFER-NAME DESKTOP-BUFFER-MISC)

Furthermore, they may use the following variables:

   `desktop-file-version'
   `desktop-buffer-major-mode'
   `desktop-buffer-minor-modes'
   `desktop-buffer-point'
   `desktop-buffer-mark'
   `desktop-buffer-read-only'
   `desktop-buffer-locals'

If a handler returns a buffer, then the saved mode settings
and variable values for that buffer are copied into it.

Modules that define a major mode that needs a special handler should contain
code like

   (defun foo-restore-desktop-buffer
   ...
   (add-to-list 'desktop-buffer-mode-handlers
                '(foo-mode . foo-restore-desktop-buffer))

Furthermore the major mode function must be autoloaded.")

;;;###autoload
(put 'desktop-buffer-mode-handlers 'risky-local-variable t)
(make-obsolete-variable 'desktop-buffer-handlers
                        'desktop-buffer-mode-handlers "22.1")

(defcustom desktop-minor-mode-table
  '((auto-fill-function auto-fill-mode)
    (defining-kbd-macro nil)
    (isearch-mode nil)
    (vc-mode nil)
    (vc-dired-mode nil)
    (erc-track-minor-mode nil)
    (savehist-mode nil))
  "Table mapping minor mode variables to minor mode functions.
Each entry has the form (NAME RESTORE-FUNCTION).
NAME is the name of the buffer-local variable indicating that the minor
mode is active.  RESTORE-FUNCTION is the function to activate the minor mode.
RESTORE-FUNCTION nil means don't try to restore the minor mode.
Only minor modes for which the name of the buffer-local variable
and the name of the minor mode function are different have to be added to
this table.  See also `desktop-minor-mode-handlers'."
  :type 'sexp
  :group 'desktop)

;;;###autoload
(defvar desktop-minor-mode-handlers nil
  "Alist of functions to restore non-standard minor modes.
Functions are called by `desktop-create-buffer' to restore minor modes.
List elements must have the form

   (MINOR-MODE . RESTORE-FUNCTION).

Minor modes not specified here, are restored by the standard minor mode
function.

Handlers are called with argument list

   (DESKTOP-BUFFER-LOCALS)

Furthermore, they may use the following variables:

   `desktop-file-version'
   `desktop-buffer-file-name'
   `desktop-buffer-name'
   `desktop-buffer-major-mode'
   `desktop-buffer-minor-modes'
   `desktop-buffer-point'
   `desktop-buffer-mark'
   `desktop-buffer-read-only'
   `desktop-buffer-misc'

When a handler is called, the buffer has been created and the major mode has
been set, but local variables listed in desktop-buffer-locals has not yet been
created and set.

Modules that define a minor mode that needs a special handler should contain
code like

   (defun foo-desktop-restore
   ...
   (add-to-list 'desktop-minor-mode-handlers
                '(foo-mode . foo-desktop-restore))

Furthermore the minor mode function must be autoloaded.

See also `desktop-minor-mode-table'.")

;;;###autoload
(put 'desktop-minor-mode-handlers 'risky-local-variable t)

;; ----------------------------------------------------------------------------
(defvar desktop-dirname nil
  "The directory in which the desktop file should be saved.")

(defun desktop-full-file-name (&optional dirname)
  "Return the full name of the desktop file in DIRNAME.
DIRNAME omitted or nil means use `desktop-dirname'."
  (expand-file-name desktop-base-file-name (or dirname desktop-dirname)))

(defun desktop-full-lock-name (&optional dirname)
  "Return the full name of the desktop lock file in DIRNAME.
DIRNAME omitted or nil means use `desktop-dirname'."
  (expand-file-name desktop-base-lock-name (or dirname desktop-dirname)))

(defconst desktop-header
";; --------------------------------------------------------------------------
;; Desktop File for Emacs
;; --------------------------------------------------------------------------
" "*Header to place in Desktop file.")

(defvar desktop-delay-hook nil
  "Hooks run after all buffers are loaded; intended for internal use.")

(defvar desktop-file-checksum nil
  "Checksum of the last auto-saved contents of the desktop file.
Used to avoid writing contents unchanged between auto-saves.")

(defvar desktop-saved-frameset nil
  "Saved state of all frames.
Only valid during frame saving & restoring; intended for internal use.")

;; ----------------------------------------------------------------------------
;; Desktop file conflict detection
(defvar desktop-file-modtime nil
  "When the desktop file was last modified to the knowledge of this Emacs.
Used to detect desktop file conflicts.")

(defun desktop-owner (&optional dirname)
  "Return the PID of the Emacs process that owns the desktop file in DIRNAME.
Return nil if no desktop file found or no Emacs process is using it.
DIRNAME omitted or nil means use `desktop-dirname'."
  (let (owner
	(file (desktop-full-lock-name dirname)))
    (and (file-exists-p file)
	 (ignore-errors
	   (with-temp-buffer
	     (insert-file-contents-literally file)
	     (goto-char (point-min))
	     (setq owner (read (current-buffer)))
	     (integerp owner)))
	 owner)))

(defun desktop-claim-lock (&optional dirname)
  "Record this Emacs process as the owner of the desktop file in DIRNAME.
DIRNAME omitted or nil means use `desktop-dirname'."
  (write-region (number-to-string (emacs-pid)) nil
		(desktop-full-lock-name dirname)))

(defun desktop-release-lock (&optional dirname)
  "Remove the lock file for the desktop in DIRNAME.
DIRNAME omitted or nil means use `desktop-dirname'."
  (let ((file (desktop-full-lock-name dirname)))
    (when (file-exists-p file) (delete-file file))))

;; ----------------------------------------------------------------------------
(defun desktop-truncate (list n)
  "Truncate LIST to at most N elements destructively."
  (let ((here (nthcdr (1- n) list)))
    (when (consp here)
      (setcdr here nil))))

;; ----------------------------------------------------------------------------
;;;###autoload
(defun desktop-clear ()
  "Empty the Desktop.
This kills all buffers except for internal ones and those with names matched by
a regular expression in the list `desktop-clear-preserve-buffers'.
Furthermore, it clears the variables listed in `desktop-globals-to-clear'.
When called interactively and `desktop-restore-frames' is non-nil, it also
deletes all frames except the selected one (and its minibuffer frame,
if different)."
  (interactive)
  (desktop-lazy-abort)
  (dolist (var desktop-globals-to-clear)
    (if (symbolp var)
	(eval `(setq-default ,var nil))
      (eval `(setq-default ,(car var) ,(cdr var)))))
  (let ((preserve-regexp (concat "^\\("
                                 (mapconcat (lambda (regexp)
                                              (concat "\\(" regexp "\\)"))
                                            desktop-clear-preserve-buffers
                                            "\\|")
                                 "\\)$")))
    (dolist (buffer (buffer-list))
      (let ((bufname (buffer-name buffer)))
	(unless (or (eq (aref bufname 0) ?\s) ;; Don't kill internal buffers
		    (string-match-p preserve-regexp bufname))
	  (kill-buffer buffer)))))
  (delete-other-windows)
  (when (and desktop-restore-frames
	     ;; Non-interactive calls to desktop-clear happen before desktop-read
	     ;; which already takes care of frame restoration and deletion.
	     (called-interactively-p 'any))
    (let* ((this (selected-frame))
	   (mini (window-frame (minibuffer-window this)))) ; in case they differ
      (dolist (frame (sort (frame-list) #'frameset-minibufferless-first-p))
	(condition-case err
	    (unless (or (eq frame this)
			(eq frame mini)
			(frame-parameter frame 'desktop-dont-clear))
	      (delete-frame frame))
	  (error
	   (delay-warning 'desktop (error-message-string err))))))))

;; ----------------------------------------------------------------------------
(unless noninteractive
  (add-hook 'kill-emacs-hook 'desktop-kill))

(defun desktop-kill ()
  "If `desktop-save-mode' is non-nil, do what `desktop-save' says to do.
If the desktop should be saved and `desktop-dirname'
is nil, ask the user where to save the desktop."
  (when (and desktop-save-mode
             (let ((exists (file-exists-p (desktop-full-file-name))))
               (or (eq desktop-save t)
                   (and exists (eq desktop-save 'if-exists))
		   ;; If it exists, but we aren't using it, we are going
		   ;; to ask for a new directory below.
                   (and exists desktop-dirname (eq desktop-save 'ask-if-new))
                   (and
                    (or (memq desktop-save '(ask ask-if-new))
                        (and exists (eq desktop-save 'ask-if-exists)))
                    (y-or-n-p "Save desktop? ")))))
    (unless desktop-dirname
      (setq desktop-dirname
            (file-name-as-directory
             (expand-file-name
	      (read-directory-name "Directory for desktop file: " nil nil t)))))
    (condition-case err
	(desktop-save desktop-dirname t)
      (file-error
       (unless (yes-or-no-p "Error while saving the desktop.  Ignore? ")
	 (signal (car err) (cdr err))))))
  ;; If we own it, we don't anymore.
  (when (eq (emacs-pid) (desktop-owner)) (desktop-release-lock)))

;; ----------------------------------------------------------------------------
(defun desktop-list* (&rest args)
  (and args (apply #'cl-list* args)))

;; ----------------------------------------------------------------------------
(defun desktop-buffer-info (buffer)
  (set-buffer buffer)
  (list
   ;; base name of the buffer; replaces the buffer name if managed by uniquify
   (and (fboundp 'uniquify-buffer-base-name) (uniquify-buffer-base-name))
   ;; basic information
   (desktop-file-name (buffer-file-name) desktop-dirname)
   (buffer-name)
   major-mode
   ;; minor modes
   (let (ret)
     (mapc
      #'(lambda (minor-mode)
	  (and (boundp minor-mode)
	       (symbol-value minor-mode)
	       (let* ((special (assq minor-mode desktop-minor-mode-table))
		      (value (cond (special (cadr special))
				   ((functionp minor-mode) minor-mode))))
		 (when value (add-to-list 'ret value)))))
      (mapcar #'car minor-mode-alist))
     ret)
   ;; point and mark, and read-only status
   (point)
   (list (mark t) mark-active)
   buffer-read-only
   ;; auxiliary information
   (when (functionp desktop-save-buffer)
     (funcall desktop-save-buffer desktop-dirname))
   ;; local variables
   (let ((loclist (buffer-local-variables))
	 (ll nil))
     (dolist (local desktop-locals-to-save)
       (let ((here (assq local loclist)))
	 (cond (here
		(push here ll))
	       ((member local loclist)
		(push local ll)))))
     ll)))

;; ----------------------------------------------------------------------------
(defun desktop--v2s (value)
  "Convert VALUE to a pair (QUOTE . SEXP); (eval SEXP) gives VALUE.
SEXP is an sexp that when evaluated yields VALUE.
QUOTE may be `may' (value may be quoted),
`must' (value must be quoted), or nil (value must not be quoted)."
  (cond
    ((or (numberp value) (null value) (eq t value) (keywordp value))
     (cons 'may value))
    ((stringp value)
     (let ((copy (copy-sequence value)))
       (set-text-properties 0 (length copy) nil copy)
       ;; Get rid of text properties because we cannot read them.
       (cons 'may copy)))
    ((symbolp value)
     (cons 'must value))
    ((vectorp value)
     (let* ((pass1 (mapcar #'desktop--v2s value))
	    (special (assq nil pass1)))
       (if special
	   (cons nil `(vector
                       ,@(mapcar (lambda (el)
                                   (if (eq (car el) 'must)
                                       `',(cdr el) (cdr el)))
                                 pass1)))
	 (cons 'may `[,@(mapcar #'cdr pass1)]))))
    ((consp value)
     (let ((p value)
	   newlist
	   use-list*)
       (while (consp p)
	 (let ((q.sexp (desktop--v2s (car p))))
           (push q.sexp newlist))
	 (setq p (cdr p)))
       (when p
         (let ((last (desktop--v2s p)))
           (setq use-list* t)
           (push last newlist)))
       (if (assq nil newlist)
	   (cons nil
		 `(,(if use-list* 'desktop-list* 'list)
                   ,@(mapcar (lambda (el)
                               (if (eq (car el) 'must)
                                   `',(cdr el) (cdr el)))
                             (nreverse newlist))))
	 (cons 'must
	       `(,@(mapcar #'cdr
                           (nreverse (if use-list* (cdr newlist) newlist)))
                 ,@(if use-list* (cdar newlist)))))))
    ((subrp value)
     (cons nil `(symbol-function
                 ',(intern-soft (substring (prin1-to-string value) 7 -1)))))
    ((markerp value)
     (let ((pos (marker-position value))
	   (buf (buffer-name (marker-buffer value))))
       (cons nil
             `(let ((mk (make-marker)))
                (add-hook 'desktop-delay-hook
                          `(lambda ()
                             (set-marker ,mk ,,pos (get-buffer ,,buf))))
                mk))))
    (t                                  ; Save as text.
     (cons 'may "Unprintable entity"))))

;; ----------------------------------------------------------------------------
(defun desktop-value-to-string (value)
  "Convert VALUE to a string that when read evaluates to the same value.
Not all types of values are supported."
  (let* ((print-escape-newlines t)
	 (print-length nil)
	 (print-level nil)
	 (float-output-format nil)
	 (quote.sexp (desktop--v2s value))
	 (quote (car quote.sexp))
	 (print-quoted t)
	 (txt (prin1-to-string (cdr quote.sexp))))
    (if (eq quote 'must)
	(concat "'" txt)
      txt)))

;; ----------------------------------------------------------------------------
(defun desktop-outvar (varspec)
  "Output a setq statement for variable VAR to the desktop file.
The argument VARSPEC may be the variable name VAR (a symbol),
or a cons cell of the form (VAR . MAX-SIZE),
which means to truncate VAR's value to at most MAX-SIZE elements
\(if the value is a list) before saving the value."
  (let (var size)
    (if (consp varspec)
	(setq var (car varspec) size (cdr varspec))
      (setq var varspec))
    (when (boundp var)
      (when (and (integerp size)
		 (> size 0)
		 (listp (eval var)))
	(desktop-truncate (eval var) size))
      (insert "(setq "
	      (symbol-name var)
	      " "
	      (desktop-value-to-string (symbol-value var))
	      ")\n"))))

;; ----------------------------------------------------------------------------
(defun desktop-save-buffer-p (filename bufname mode &rest _dummy)
  "Return t if buffer should have its state saved in the desktop file.
FILENAME is the visited file name, BUFNAME is the buffer name, and
MODE is the major mode.
\n\(fn FILENAME BUFNAME MODE)"
  (let ((case-fold-search nil)
	(no-regexp-to-check (not (stringp desktop-files-not-to-save)))
	dired-skip)
    (and (or filename
	     (not (stringp desktop-buffers-not-to-save))
	     (not (string-match-p desktop-buffers-not-to-save bufname)))
	 (not (memq mode desktop-modes-not-to-save))
	 (or (and filename
		  (or no-regexp-to-check
		      (not (string-match-p desktop-files-not-to-save filename))))
	     (and (memq mode '(dired-mode vc-dir-mode))
		  (or no-regexp-to-check
		      (not (setq dired-skip
				 (with-current-buffer bufname
				   (string-match-p desktop-files-not-to-save
						   default-directory))))))
	     (and (null filename)
		  (null dired-skip)  ; bug#5755
		  (with-current-buffer bufname desktop-save-buffer)))
	 t)))

;; ----------------------------------------------------------------------------
(defun desktop-file-name (filename dirname)
  "Convert FILENAME to format specified in `desktop-file-name-format'.
DIRNAME must be the directory in which the desktop file will be saved."
  (cond
    ((not filename) nil)
    ((eq desktop-file-name-format 'tilde)
     (let ((relative-name (file-relative-name (expand-file-name filename) "~")))
       (cond
         ((file-name-absolute-p relative-name) relative-name)
         ((string= "./" relative-name) "~/")
         ((string= "." relative-name) "~")
         (t (concat "~/" relative-name)))))
    ((eq desktop-file-name-format 'local) (file-relative-name filename dirname))
    (t (expand-file-name filename))))


;; ----------------------------------------------------------------------------
(defun desktop--check-dont-save (frame)
  (not (frame-parameter frame 'desktop-dont-save)))

(defconst desktop--app-id `(desktop . ,desktop-file-version))

(defun desktop-save-frameset ()
  "Save the state of existing frames in `desktop-saved-frameset'.
Frames with a non-nil `desktop-dont-save' parameter are not saved."
  (setq desktop-saved-frameset
	(and desktop-restore-frames
	     (frameset-save nil
			    :app desktop--app-id
			    :name (concat user-login-name "@" system-name)
			    :predicate #'desktop--check-dont-save))))

;;;###autoload
(defun desktop-save (dirname &optional release only-if-changed)
  "Save the desktop in a desktop file.
Parameter DIRNAME specifies where to save the desktop file.
Optional parameter RELEASE says whether we're done with this desktop.
If ONLY-IF-CHANGED is non-nil, compare the current desktop information
to that in the desktop file, and if the desktop information has not
changed since it was last saved then do not rewrite the file."
  (interactive (list
                ;; Or should we just use (car desktop-path)?
                (let ((default (if (member "." desktop-path)
                                   default-directory
                                 user-emacs-directory)))
                  (read-directory-name "Directory to save desktop file in: "
                                       default default t))))
  (setq desktop-dirname (file-name-as-directory (expand-file-name dirname)))
  (save-excursion
    (let ((eager desktop-restore-eager)
	  (new-modtime (nth 5 (file-attributes (desktop-full-file-name)))))
      (when
	  (or (not new-modtime)		; nothing to overwrite
	      (equal desktop-file-modtime new-modtime)
	      (yes-or-no-p (if desktop-file-modtime
			       (if (> (float-time new-modtime) (float-time desktop-file-modtime))
				   "Desktop file is more recent than the one loaded.  Save anyway? "
				 "Desktop file isn't the one loaded.  Overwrite it? ")
			     "Current desktop was not loaded from a file.  Overwrite this desktop file? "))
	      (unless release (error "Desktop file conflict")))

	;; If we're done with it, release the lock.
	;; Otherwise, claim it if it's unclaimed or if we created it.
	(if release
	    (desktop-release-lock)
	  (unless (and new-modtime (desktop-owner)) (desktop-claim-lock)))

	(with-temp-buffer
	  (insert
	   ";; -*- mode: emacs-lisp; coding: emacs-mule; -*-\n"
	   desktop-header
	   ";; Created " (current-time-string) "\n"
	   ";; Desktop file format version " desktop-file-version "\n"
	   ";; Emacs version " emacs-version "\n")
	  (save-excursion (run-hooks 'desktop-save-hook))
	  (goto-char (point-max))
	  (insert "\n;; Global section:\n")
	  ;; Called here because we save the window/frame state as a global
	  ;; variable for compatibility with previous Emacsen.
	  (desktop-save-frameset)
	  (unless (memq 'desktop-saved-frameset desktop-globals-to-save)
	    (desktop-outvar 'desktop-saved-frameset))
	  (mapc (function desktop-outvar) desktop-globals-to-save)
	  (setq desktop-saved-frameset nil) ; after saving desktop-globals-to-save
	  (when (memq 'kill-ring desktop-globals-to-save)
	    (insert
	     "(setq kill-ring-yank-pointer (nthcdr "
	     (int-to-string (- (length kill-ring) (length kill-ring-yank-pointer)))
	     " kill-ring))\n"))

	  (insert "\n;; Buffer section -- buffers listed in same order as in buffer list:\n")
	  (dolist (l (mapcar 'desktop-buffer-info (buffer-list)))
	    (let ((base (pop l)))
	      (when (apply 'desktop-save-buffer-p l)
		(insert "("
			(if (or (not (integerp eager))
				(if (zerop eager)
				    nil
				  (setq eager (1- eager))))
			    "desktop-create-buffer"
			  "desktop-append-buffer-args")
			" "
			desktop-file-version)
		;; If there's a non-empty base name, we save it instead of the buffer name
		(when (and base (not (string= base "")))
		  (setcar (nthcdr 1 l) base))
		(dolist (e l)
		  (insert "\n  " (desktop-value-to-string e)))
		(insert ")\n\n"))))

	  (setq default-directory desktop-dirname)
	  ;; When auto-saving, avoid writing if nothing has changed since the last write.
	  (let* ((beg (and only-if-changed
			   (save-excursion
			     (goto-char (point-min))
			     ;; Don't check the header with changing timestamp
			     (and (search-forward "Global section" nil t)
				  ;; Also skip the timestamp in desktop-saved-frameset
				  ;; if it's saved in the first non-header line
				  (search-forward "desktop-saved-frameset"
						  (line-beginning-position 3) t)
				  ;; This is saved after the timestamp
				  (search-forward (format "%S" desktop--app-id) nil t))
			     (point))))
		 (checksum (and beg (md5 (current-buffer) beg (point-max) 'emacs-mule))))
	    (unless (and checksum (equal checksum desktop-file-checksum))
	      (let ((coding-system-for-write 'emacs-mule))
		(write-region (point-min) (point-max) (desktop-full-file-name) nil 'nomessage))
	      (setq desktop-file-checksum checksum)
	      ;; We remember when it was modified (which is presumably just now).
	      (setq desktop-file-modtime (nth 5 (file-attributes (desktop-full-file-name)))))))))))

;; ----------------------------------------------------------------------------
;;;###autoload
(defun desktop-remove ()
  "Delete desktop file in `desktop-dirname'.
This function also sets `desktop-dirname' to nil."
  (interactive)
  (when desktop-dirname
    (let ((filename (desktop-full-file-name)))
      (setq desktop-dirname nil)
      (when (file-exists-p filename)
        (delete-file filename)))))

(defvar desktop-buffer-args-list nil
  "List of args for `desktop-create-buffer'.")

(defvar desktop-lazy-timer nil)

;; ----------------------------------------------------------------------------
(defun desktop-restoring-frameset-p ()
  "True if calling `desktop-restore-frameset' will actually restore it."
  (and desktop-restore-frames desktop-saved-frameset t))

(defun desktop-restore-frameset ()
  "Restore the state of a set of frames.
This function depends on the value of `desktop-saved-frameset'
being set (usually, by reading it from the desktop)."
  (when (desktop-restoring-frameset-p)
    (frameset-restore desktop-saved-frameset
		      :reuse-frames (eq desktop-restore-reuses-frames t)
		      :cleanup-frames (not (eq desktop-restore-reuses-frames 'keep))
		      :force-display desktop-restore-in-current-display
		      :force-onscreen desktop-restore-forces-onscreen)))

;; Just to silence the byte compiler.
;; Dynamically bound in `desktop-read'.
(defvar desktop-first-buffer)
(defvar desktop-buffer-ok-count)
(defvar desktop-buffer-fail-count)

;; FIXME Interactively, this should have the option to prompt for dirname.
;;;###autoload
(defun desktop-read (&optional dirname)
  "Read and process the desktop file in directory DIRNAME.
Look for a desktop file in DIRNAME, or if DIRNAME is omitted, look in
directories listed in `desktop-path'.  If a desktop file is found, it
is processed and `desktop-after-read-hook' is run.  If no desktop file
is found, clear the desktop and run `desktop-no-desktop-file-hook'.
This function is a no-op when Emacs is running in batch mode.
It returns t if a desktop file was loaded, nil otherwise."
  (interactive)
  (unless noninteractive
    (setq desktop-dirname
          (file-name-as-directory
           (expand-file-name
            (or
             ;; If DIRNAME is specified, use it.
             (and (< 0 (length dirname)) dirname)
             ;; Otherwise search desktop file in desktop-path.
             (let ((dirs desktop-path))
               (while (and dirs
                           (not (file-exists-p
                                 (desktop-full-file-name (car dirs)))))
                 (setq dirs (cdr dirs)))
               (and dirs (car dirs)))
             ;; If not found and `desktop-path' is non-nil, use its first element.
             (and desktop-path (car desktop-path))
             ;; Default: .emacs.d.
             user-emacs-directory))))
    (if (file-exists-p (desktop-full-file-name))
	;; Desktop file found, but is it already in use?
	(let ((desktop-first-buffer nil)
	      (desktop-buffer-ok-count 0)
	      (desktop-buffer-fail-count 0)
	      (owner (desktop-owner))
	      ;; Avoid desktop saving during evaluation of desktop buffer.
	      (desktop-save nil))
	  (if (and owner
		   (memq desktop-load-locked-desktop '(nil ask))
		   (or (null desktop-load-locked-desktop)
		       (daemonp)
		       (not (y-or-n-p (format "Warning: desktop file appears to be in use by PID %s.\n\
Using it may cause conflicts.  Use it anyway? " owner)))))
	      (let ((default-directory desktop-dirname))
		(setq desktop-dirname nil)
		(run-hooks 'desktop-not-loaded-hook)
		(unless desktop-dirname
		  (message "Desktop file in use; not loaded.")))
	    (desktop-lazy-abort)
	    ;; Temporarily disable the autosave that will leave it
	    ;; disabled when loading the desktop fails with errors,
	    ;; thus not overwriting the desktop with broken contents.
	    (desktop-auto-save-disable)
	    ;; Evaluate desktop buffer and remember when it was modified.
	    (load (desktop-full-file-name) t t t)
	    (setq desktop-file-modtime (nth 5 (file-attributes (desktop-full-file-name))))
	    ;; If it wasn't already, mark it as in-use, to bother other
	    ;; desktop instances.
	    (unless (eq (emacs-pid) owner)
	      (condition-case nil
		  (desktop-claim-lock)
		(file-error (message "Couldn't record use of desktop file")
			    (sit-for 1))))

	    (unless (desktop-restoring-frameset-p)
	      ;; `desktop-create-buffer' puts buffers at end of the buffer list.
	      ;; We want buffers existing prior to evaluating the desktop (and
	      ;; not reused) to be placed at the end of the buffer list, so we
	      ;; move them here.
	      (mapc 'bury-buffer
		    (nreverse (cdr (memq desktop-first-buffer (nreverse (buffer-list))))))
	      (switch-to-buffer (car (buffer-list))))
	    (run-hooks 'desktop-delay-hook)
	    (setq desktop-delay-hook nil)
	    (desktop-restore-frameset)
	    (run-hooks 'desktop-after-read-hook)
	    (message "Desktop: %s%d buffer%s restored%s%s."
		     (if desktop-saved-frameset
			 (let ((fn (length (frameset-states desktop-saved-frameset))))
			   (format "%d frame%s, "
				   fn (if (= fn 1) "" "s")))
		       "")
		     desktop-buffer-ok-count
		     (if (= 1 desktop-buffer-ok-count) "" "s")
		     (if (< 0 desktop-buffer-fail-count)
			 (format ", %d failed to restore" desktop-buffer-fail-count)
		       "")
		     (if desktop-buffer-args-list
			 (format ", %d to restore lazily"
				 (length desktop-buffer-args-list))
		       ""))
	    (unless (desktop-restoring-frameset-p)
	      ;; Bury the *Messages* buffer to not reshow it when burying
	      ;; the buffer we switched to above.
	      (when (buffer-live-p (get-buffer "*Messages*"))
		(bury-buffer "*Messages*"))
	      ;; Clear all windows' previous and next buffers, these have
	      ;; been corrupted by the `switch-to-buffer' calls in
	      ;; `desktop-restore-file-buffer' (bug#11556).  This is a
	      ;; brute force fix and should be replaced by a more subtle
	      ;; strategy eventually.
	      (walk-window-tree (lambda (window)
				  (set-window-prev-buffers window nil)
				  (set-window-next-buffers window nil))))
 	    (setq desktop-saved-frameset nil)
	    (desktop-auto-save-enable)
	    t))
      ;; No desktop file found.
      (desktop-clear)
      (let ((default-directory desktop-dirname))
        (run-hooks 'desktop-no-desktop-file-hook))
      (message "No desktop file.")
      nil)))

;; ----------------------------------------------------------------------------
;; Maintained for backward compatibility
;;;###autoload
(defun desktop-load-default ()
  "Load the `default' start-up library manually.
Also inhibit further loading of it."
  (declare (obsolete desktop-save-mode "22.1"))
  (unless inhibit-default-init	        ; safety check
    (load "default" t t)
    (setq inhibit-default-init t)))

;; ----------------------------------------------------------------------------
;;;###autoload
(defun desktop-change-dir (dirname)
  "Change to desktop saved in DIRNAME.
Kill the desktop as specified by variables `desktop-save-mode' and
`desktop-save', then clear the desktop and load the desktop file in
directory DIRNAME."
  (interactive "DChange to directory: ")
  (setq dirname (file-name-as-directory (expand-file-name dirname desktop-dirname)))
  (desktop-kill)
  (desktop-clear)
  (desktop-read dirname))

;; ----------------------------------------------------------------------------
;;;###autoload
(defun desktop-save-in-desktop-dir ()
  "Save the desktop in directory `desktop-dirname'."
  (interactive)
  (if desktop-dirname
      (desktop-save desktop-dirname)
    (call-interactively 'desktop-save))
  (message "Desktop saved in %s" (abbreviate-file-name desktop-dirname)))

;; ----------------------------------------------------------------------------
;; Auto-Saving.
(defvar desktop-auto-save-timer nil)

(defun desktop-auto-save-enable (&optional timeout)
  (when (and (integerp (or timeout desktop-auto-save-timeout))
	     (> (or timeout desktop-auto-save-timeout) 0))
    (add-hook 'window-configuration-change-hook 'desktop-auto-save-set-timer)))

(defun desktop-auto-save-disable ()
  (remove-hook 'window-configuration-change-hook 'desktop-auto-save-set-timer)
  (desktop-auto-save-cancel-timer))

(defun desktop-auto-save ()
  "Save the desktop periodically.
Called by the timer created in `desktop-auto-save-set-timer'."
  (when (and desktop-save-mode
	     (integerp desktop-auto-save-timeout)
	     (> desktop-auto-save-timeout 0)
	     ;; Avoid desktop saving during lazy loading.
	     (not desktop-lazy-timer)
	     ;; Save only to own desktop file.
	     (eq (emacs-pid) (desktop-owner))
	     desktop-dirname)
    (desktop-save desktop-dirname nil t)))

(defun desktop-auto-save-set-timer ()
  "Set the auto-save timer.
Cancel any previous timer.  When `desktop-auto-save-timeout' is a positive
integer, start a new idle timer to call `desktop-auto-save' repeatedly
after that many seconds of idle time."
  (desktop-auto-save-cancel-timer)
  (when (and (integerp desktop-auto-save-timeout)
	     (> desktop-auto-save-timeout 0))
    (setq desktop-auto-save-timer
	  (run-with-idle-timer desktop-auto-save-timeout nil
			       'desktop-auto-save))))

(defun desktop-auto-save-cancel-timer ()
  (when desktop-auto-save-timer
    (cancel-timer desktop-auto-save-timer)
    (setq desktop-auto-save-timer nil)))

;; ----------------------------------------------------------------------------
;;;###autoload
(defun desktop-revert ()
  "Revert to the last loaded desktop."
  (interactive)
  (unless desktop-dirname
    (error "Unknown desktop directory"))
  (unless (file-exists-p (desktop-full-file-name))
    (error "No desktop file found"))
  (desktop-clear)
  (desktop-read desktop-dirname))

(defvar desktop-buffer-major-mode)
(defvar desktop-buffer-locals)
(defvar auto-insert)  ; from autoinsert.el
;; ----------------------------------------------------------------------------
(defun desktop-restore-file-buffer (buffer-filename
                                    _buffer-name
                                    _buffer-misc)
  "Restore a file buffer."
  (when buffer-filename
    (if (or (file-exists-p buffer-filename)
	    (let ((msg (format "Desktop: File \"%s\" no longer exists."
			       buffer-filename)))
	      (if desktop-missing-file-warning
		  (y-or-n-p (concat msg " Re-create buffer? "))
		(message "%s" msg)
		nil)))
	(let* ((auto-insert nil) ; Disable auto insertion
	       (coding-system-for-read
		(or coding-system-for-read
		    (cdr (assq 'buffer-file-coding-system
			       desktop-buffer-locals))))
	       (buf (find-file-noselect buffer-filename)))
	  (condition-case nil
	      (switch-to-buffer buf)
	    (error (pop-to-buffer buf)))
	  (and (not (eq major-mode desktop-buffer-major-mode))
	       (functionp desktop-buffer-major-mode)
	       (funcall desktop-buffer-major-mode))
	  buf)
      nil)))

(defun desktop-load-file (function)
  "Load the file where auto loaded FUNCTION is defined."
  (when (fboundp function)
    (autoload-do-load (symbol-function function) function)))

;; ----------------------------------------------------------------------------
;; Create a buffer, load its file, set its mode, ...;
;; called from Desktop file only.

(defun desktop-create-buffer
    (file-version
     buffer-filename
     buffer-name
     buffer-majormode
     buffer-minormodes
     buffer-point
     buffer-mark
     buffer-readonly
     buffer-misc
     &optional
     buffer-locals)

  (let ((desktop-file-version	    file-version)
	(desktop-buffer-file-name   buffer-filename)
	(desktop-buffer-name	    buffer-name)
	(desktop-buffer-major-mode  buffer-majormode)
	(desktop-buffer-minor-modes buffer-minormodes)
	(desktop-buffer-point	    buffer-point)
	(desktop-buffer-mark	    buffer-mark)
	(desktop-buffer-read-only   buffer-readonly)
	(desktop-buffer-misc	    buffer-misc)
	(desktop-buffer-locals	    buffer-locals))
    ;; To make desktop files with relative file names possible, we cannot
    ;; allow `default-directory' to change. Therefore we save current buffer.
    (save-current-buffer
      ;; Give major mode module a chance to add a handler.
      (desktop-load-file desktop-buffer-major-mode)
      (let ((buffer-list (buffer-list))
	    (result
	     (condition-case-unless-debug err
		 (funcall (or (cdr (assq desktop-buffer-major-mode
					 desktop-buffer-mode-handlers))
			      'desktop-restore-file-buffer)
			  desktop-buffer-file-name
			  desktop-buffer-name
			  desktop-buffer-misc)
	       (error
		(message "Desktop: Can't load buffer %s: %s"
			 desktop-buffer-name
			 (error-message-string err))
		(when desktop-missing-file-warning (sit-for 1))
		nil))))
	(if (bufferp result)
	    (setq desktop-buffer-ok-count (1+ desktop-buffer-ok-count))
	  (setq desktop-buffer-fail-count (1+ desktop-buffer-fail-count))
	  (setq result nil))
	;; Restore buffer list order with new buffer at end. Don't change
	;; the order for old desktop files (old desktop module behavior).
	(unless (< desktop-file-version 206)
	  (dolist (buf buffer-list)
            (and (buffer-live-p buf)
                 (bury-buffer buf)))
	  (when result (bury-buffer result)))
	(when result
	  (unless (or desktop-first-buffer (< desktop-file-version 206))
	    (setq desktop-first-buffer result))
	  (set-buffer result)
	  (unless (equal (buffer-name) desktop-buffer-name)
	    (rename-buffer desktop-buffer-name t))
	  ;; minor modes
	  (cond ((equal '(t) desktop-buffer-minor-modes) ; backwards compatible
		 (auto-fill-mode 1))
		((equal '(nil) desktop-buffer-minor-modes) ; backwards compatible
		 (auto-fill-mode 0))
		(t
		 (dolist (minor-mode desktop-buffer-minor-modes)
		   ;; Give minor mode module a chance to add a handler.
		   (desktop-load-file minor-mode)
		   (let ((handler (cdr (assq minor-mode desktop-minor-mode-handlers))))
		     (if handler
			 (funcall handler desktop-buffer-locals)
		       (when (functionp minor-mode)
			 (funcall minor-mode 1)))))))
	  ;; Even though point and mark are non-nil when written by
	  ;; `desktop-save', they may be modified by handlers wanting to set
	  ;; point or mark themselves.
	  (when desktop-buffer-point
	    (goto-char
	     (condition-case err
		 ;; Evaluate point.  Thus point can be something like
		 ;; '(search-forward ...
		 (eval desktop-buffer-point)
	       (error (message "%s" (error-message-string err)) 1))))
	  (when desktop-buffer-mark
            (if (consp desktop-buffer-mark)
                (progn
                  (move-marker (mark-marker) (car desktop-buffer-mark))
                  ;; FIXME: Should we call (de)activate-mark instead?
                  (setq mark-active (car (cdr desktop-buffer-mark))))
              (move-marker (mark-marker) desktop-buffer-mark)))
	  ;; Never override file system if the file really is read-only marked.
	  (when desktop-buffer-read-only (setq buffer-read-only desktop-buffer-read-only))
	  (dolist (this desktop-buffer-locals)
	    (if (consp this)
		;; An entry of this form `(symbol . value)'.
		(progn
		  (make-local-variable (car this))
		  (set (car this) (cdr this)))
	      ;; An entry of the form `symbol'.
	      (make-local-variable this)
	      (makunbound this))))))))

;; ----------------------------------------------------------------------------
;; Backward compatibility -- update parameters to 205 standards.
(defun desktop-buffer (buffer-filename buffer-name buffer-majormode
		       mim pt mk ro tl fc cfs cr buffer-misc)
  (desktop-create-buffer 205 buffer-filename buffer-name
			 buffer-majormode (cdr mim) pt mk ro
			 buffer-misc
			 (list (cons 'truncate-lines tl)
			       (cons 'fill-column fc)
			       (cons 'case-fold-search cfs)
			       (cons 'case-replace cr)
			       (cons 'overwrite-mode (car mim)))))

(defun desktop-append-buffer-args (&rest args)
  "Append ARGS at end of `desktop-buffer-args-list'.
ARGS must be an argument list for `desktop-create-buffer'."
  (setq desktop-buffer-args-list (nconc desktop-buffer-args-list (list args)))
  (unless desktop-lazy-timer
    (setq desktop-lazy-timer
          (run-with-idle-timer desktop-lazy-idle-delay t 'desktop-idle-create-buffers))))

(defun desktop-lazy-create-buffer ()
  "Pop args from `desktop-buffer-args-list', create buffer and bury it."
  (when desktop-buffer-args-list
    (let* ((remaining (length desktop-buffer-args-list))
           (args (pop desktop-buffer-args-list))
           (buffer-name (nth 2 args))
           (msg (format "Desktop lazily opening %s (%s remaining)..."
                            buffer-name remaining)))
      (when desktop-lazy-verbose
        (message "%s" msg))
      (let ((desktop-first-buffer nil)
            (desktop-buffer-ok-count 0)
            (desktop-buffer-fail-count 0))
        (apply 'desktop-create-buffer args)
        (run-hooks 'desktop-delay-hook)
        (setq desktop-delay-hook nil)
        (bury-buffer (get-buffer buffer-name))
        (when desktop-lazy-verbose
          (message "%s%s" msg (if (> desktop-buffer-ok-count 0) "done" "failed")))))))

(defun desktop-idle-create-buffers ()
  "Create buffers until the user does something, then stop.
If there are no buffers left to create, kill the timer."
  (let ((repeat 1))
    (while (and repeat desktop-buffer-args-list)
      (save-window-excursion
        (desktop-lazy-create-buffer))
      (setq repeat (sit-for 0.2))
    (unless desktop-buffer-args-list
      (cancel-timer desktop-lazy-timer)
      (setq desktop-lazy-timer nil)
      (message "Lazy desktop load complete")
      (sit-for 3)
      (message "")))))

(defun desktop-lazy-complete ()
  "Run the desktop load to completion."
  (interactive)
  (let ((desktop-lazy-verbose t))
    (while desktop-buffer-args-list
      (save-window-excursion
        (desktop-lazy-create-buffer)))
    (message "Lazy desktop load complete")))

(defun desktop-lazy-abort ()
  "Abort lazy loading of the desktop."
  (interactive)
  (when desktop-lazy-timer
    (cancel-timer desktop-lazy-timer)
    (setq desktop-lazy-timer nil))
  (when desktop-buffer-args-list
    (setq desktop-buffer-args-list nil)
    (when (called-interactively-p 'interactive)
      (message "Lazy desktop load aborted"))))

;; ----------------------------------------------------------------------------
;; When `desktop-save-mode' is non-nil and "--no-desktop" is not specified on the
;; command line, we do the rest of what it takes to use desktop, but do it
;; after finishing loading the init file.
;; We cannot use `command-switch-alist' to process "--no-desktop" because these
;; functions are processed after `after-init-hook'.
(add-hook
  'after-init-hook
  (lambda ()
    (let ((key "--no-desktop"))
      (when (member key command-line-args)
        (setq command-line-args (delete key command-line-args))
        (desktop-save-mode 0)))
    (when desktop-save-mode
      ;; People don't expect emacs -nw, or --daemon,
      ;; to create graphical frames (bug#17693).
      ;; TODO perhaps there should be a separate value
      ;; for desktop-restore-frames to control this startup behavior?
      (let ((desktop-restore-frames (and desktop-restore-frames
                                         initial-window-system
                                         (not (daemonp)))))
        (desktop-read)
        (setq inhibit-startup-screen t)))))

;; So we can restore vc-dir buffers.
(autoload 'vc-dir-mode "vc-dir" nil t)

(provide 'desktop)

;;; desktop.el ends here

;; Local Variables:
;; coding: utf-8
;; End:
