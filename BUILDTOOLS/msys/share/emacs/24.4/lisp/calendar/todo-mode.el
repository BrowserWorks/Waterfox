;;; todo-mode.el --- facilities for making and maintaining todo lists

;; Copyright (C) 1997, 1999, 2001-2014 Free Software Foundation, Inc.

;; Author: Oliver Seidel <privat@os10000.net>
;;	Stephen Berman <stephen.berman@gmx.net>
;; Maintainer: Stephen Berman <stephen.berman@gmx.net>
;; Keywords: calendar, todo

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

;; This package provides facilities for making and maintaining
;; prioritized lists of things to do.  These todo lists are identified
;; with named categories, so you can group together thematically
;; related todo items.  Each category is stored in a file, providing a
;; further level of organization.  You can create as many todo files,
;; and in each as many categories, as you want.

;; With Todo mode you can navigate among the items of a category, and
;; between categories in the same and in different todo files.  You
;; can add and edit todo items, reprioritize them, move them to
;; another category, or delete them.  You can also mark items as done
;; and store them within their category or in separate archive files.
;; You can include todo items in the Emacs Fancy Diary display and
;; treat them as appointments.  You can add new todo files, and rename
;; or delete them.  You can add new categories to a file, rename or
;; delete them, move a category to another file and merge the items of
;; two categories.  You can also reorder the sequence of categories in
;; a todo file for the purpose of navigation.  You can display
;; sortable summary tables of the categories in a file and the types
;; of items they contain.  And you can filter items by various
;; criteria from multiple categories in one or more todo files to
;; create prioritizable cross-category overviews of your todo items.

;; To get started, type `M-x todo-show'.  For full details of the user
;; interface, commands and options, consult the Todo mode user manual,
;; which is included in the Info documentation.

;;; Code:

(require 'diary-lib)
(require 'cl-lib)			; For cl-oddp and cl-assert.

;; -----------------------------------------------------------------------------
;;; Setting up todo files, categories, and items
;; -----------------------------------------------------------------------------

(defcustom todo-directory (locate-user-emacs-file "todo/")
  "Directory where user's todo files are saved."
  :type 'directory
  :group 'todo)

(defun todo-files (&optional archives)
  "Default value of `todo-files-function'.
This returns the case-insensitive alphabetically sorted list of
file truenames in `todo-directory' with the extension
\".todo\".  With non-nil ARCHIVES return the list of archive file
truenames (those with the extension \".toda\")."
  (let ((files (if (file-exists-p todo-directory)
		   (mapcar 'file-truename
		    (directory-files todo-directory t
				     (if archives "\.toda$" "\.todo$") t)))))
    (sort files (lambda (s1 s2) (let ((cis1 (upcase s1))
				      (cis2 (upcase s2)))
				  (string< cis1 cis2))))))

(defcustom todo-files-function 'todo-files
  "Function returning the value of the variable `todo-files'.
This function should take an optional argument that, if non-nil,
makes it return the value of the variable `todo-archives'."
  :type 'function
  :group 'todo)

(defvar todo-files (funcall todo-files-function)
  "List of truenames of user's todo files.")

(defvar todo-archives (funcall todo-files-function t)
  "List of truenames of user's todo archives.")

(defvar todo-visited nil
  "List of todo files visited in this session by `todo-show'.
Used to determine initial display according to the value of
`todo-show-first'.")

(defvar todo-file-buffers nil
  "List of file names of live Todo mode buffers.")

(defvar todo-global-current-todo-file nil
  "Variable holding name of current todo file.
Used by functions called from outside of Todo mode to visit the
current todo file rather than the default todo file (i.e. when
users option `todo-show-current-file' is non-nil).")

(defvar todo-current-todo-file nil
  "Variable holding the name of the currently active todo file.")

(defvar todo-categories nil
  "Alist of categories in the current todo file.
The elements are cons cells whose car is a category name and
whose cdr is a vector of the category's item counts.  These are,
in order, the numbers of todo items, of todo items included in
the Diary, of done items and of archived items.")

(defvar todo-category-number 1
  "Variable holding the number of the current todo category.
Todo categories are numbered starting from 1.")

(defvar todo-categories-with-marks nil
  "Alist of categories and number of marked items they contain.")

(defconst todo-category-beg "--==-- "
  "String marking beginning of category (inserted with its name).")

(defconst todo-category-done "==--== DONE "
  "String marking beginning of category's done items.")

(defcustom todo-done-separator-string "="
  "String determining the value of variable `todo-done-separator'.
If the string consists of a single character,
`todo-done-separator' will be the string made by repeating this
character for the width of the window, and the length is
automatically recalculated when the window width changes.  If the
string consists of more (or less) than one character, it will be
the value of `todo-done-separator'."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todo-reset-done-separator-string
  :group 'todo-display)

(defun todo-done-separator ()
  "Return string used as value of variable `todo-done-separator'."
  (let ((sep todo-done-separator-string))
    (propertize (if (= 1 (length sep))
		    (make-string (window-width) (string-to-char sep))
		  todo-done-separator-string)
		'face 'todo-done-sep)))

(defvar todo-done-separator (todo-done-separator)
  "String used to visually separate done from not done items.
Displayed as an overlay instead of `todo-category-done' when
done items are shown.  Its value is determined by user option
`todo-done-separator-string'.")

(defvar todo-show-done-only nil
  "If non-nil display only done items in current category.
Set by the command `todo-toggle-view-done-only' and used by
`todo-category-select'.")

(defcustom todo-nondiary-marker '("[" "]")
  "List of strings surrounding item date to block diary inclusion.
The first string is inserted before the item date and must be a
non-empty string that does not match a diary date in order to
have its intended effect.  The second string is inserted after
the diary date."
  :type '(list string string)
  :group 'todo-edit
  :initialize 'custom-initialize-default
  :set 'todo-reset-nondiary-marker)

(defconst todo-nondiary-start (nth 0 todo-nondiary-marker)
  "String inserted before item date to block diary inclusion.")

(defconst todo-nondiary-end (nth 1 todo-nondiary-marker)
  "String inserted after item date matching `todo-nondiary-start'.")

(defconst todo-month-name-array
  (vconcat calendar-month-name-array (vector "*"))
  "Array of month names, in order.
The final element is \"*\", indicating an unspecified month.")

(defconst todo-month-abbrev-array
  (vconcat calendar-month-abbrev-array (vector "*"))
  "Array of abbreviated month names, in order.
The final element is \"*\", indicating an unspecified month.")

(defconst todo-date-pattern
  (let ((dayname (diary-name-pattern calendar-day-name-array nil t)))
    (concat "\\(?4:\\(?5:" dayname "\\)\\|"
	    (let ((dayname)
		  (monthname (format "\\(?6:%s\\)" (diary-name-pattern
						    todo-month-name-array
						    todo-month-abbrev-array)))
		  (month "\\(?7:[0-9]+\\|\\*\\)")
		  (day "\\(?8:[0-9]+\\|\\*\\)")
		  (year "-?\\(?9:[0-9]+\\|\\*\\)"))
	      (mapconcat 'eval calendar-date-display-form ""))
	    "\\)"))
  "Regular expression matching a todo item date header.")

;; By itself this matches anything, because of the `?'; however, it's only
;; used in the context of `todo-date-pattern' (but Emacs Lisp lacks
;; lookahead).
(defconst todo-date-string-start
  (concat "^\\(" (regexp-quote todo-nondiary-start) "\\|"
	  (regexp-quote diary-nonmarking-symbol) "\\)?")
  "Regular expression matching part of item header before the date.")

(defcustom todo-done-string "DONE "
  "Identifying string appended to the front of done todo items."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todo-reset-done-string
  :group 'todo-edit)

(defconst todo-done-string-start
  (concat "^\\[" (regexp-quote todo-done-string))
  "Regular expression matching start of done item.")

(defconst todo-item-start (concat "\\(" todo-date-string-start "\\|"
				 todo-done-string-start "\\)"
				 todo-date-pattern)
  "String identifying start of a todo item.")

;; -----------------------------------------------------------------------------
;;; Todo mode display options
;; -----------------------------------------------------------------------------

(defcustom todo-prefix ""
  "String prefixed to todo items for visual distinction."
  :type '(string :validate
		 (lambda (widget)
		   (when (string= (widget-value widget) todo-item-mark)
		     (widget-put
		      widget :error
		      "Invalid value: must be distinct from `todo-item-mark'")
		     widget)))
  :initialize 'custom-initialize-default
  :set 'todo-reset-prefix
  :group 'todo-display)

(defcustom todo-number-prefix t
  "Non-nil to prefix items with consecutively increasing integers.
These reflect the priorities of the items in each category."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todo-reset-prefix
  :group 'todo-display)

(defun todo-mode-line-control (cat)
  "Return a mode line control for todo or archive file buffers.
Argument CAT is the name of the current todo category.
This function is the value of the user variable
`todo-mode-line-function'."
  (let ((file (todo-short-file-name todo-current-todo-file)))
    (format "%s category %d: %s" file todo-category-number cat)))

(defcustom todo-mode-line-function 'todo-mode-line-control
  "Function that returns a mode line control for Todo mode buffers.
The function expects one argument holding the name of the current
todo category.  The resulting control becomes the local value of
`mode-line-buffer-identification' in each Todo mode buffer."
  :type 'function
  :group 'todo-display)

(defcustom todo-highlight-item nil
  "Non-nil means highlight items at point."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todo-reset-highlight-item
  :group 'todo-display)

(defcustom todo-wrap-lines t
  "Non-nil to activate Visual Line mode and use wrap prefix."
  :type 'boolean
  :group 'todo-display)

(defcustom todo-indent-to-here 3
  "Number of spaces to indent continuation lines of items.
This must be a positive number to ensure such items are fully
shown in the Fancy Diary display."
  :type '(integer :validate
		  (lambda (widget)
		    (unless (> (widget-value widget) 0)
		      (widget-put widget :error
				  "Invalid value: must be a positive integer")
		      widget)))
  :group 'todo-display)

(defun todo-indent ()
  "Indent from point to `todo-indent-to-here'."
  (indent-to todo-indent-to-here todo-indent-to-here))

(defcustom todo-show-with-done nil
  "Non-nil to display done items in all categories."
  :type 'boolean
  :group 'todo-display)

;; -----------------------------------------------------------------------------
;;; Faces
;; -----------------------------------------------------------------------------

(defface todo-key-prompt
  '((t (:weight bold)))
  "Face for making keys in item insertion prompt stand out."
  :group 'todo-faces)

(defface todo-mark
  ;; '((t :inherit font-lock-warning-face))
  '((((class color)
      (min-colors 88)
      (background light))
     (:weight bold :foreground "Red1"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:weight bold :foreground "Pink"))
    (((class color)
      (min-colors 16)
      (background light))
     (:weight bold :foreground "Red1"))
    (((class color)
      (min-colors 16)
      (background dark))
     (:weight bold :foreground "Pink"))
    (((class color)
      (min-colors 8))
     (:foreground "red"))
    (t
     (:weight bold :inverse-video t)))
  "Face for marks on marked items."
  :group 'todo-faces)

(defface todo-prefix-string
  ;; '((t :inherit font-lock-constant-face))
  '((((class grayscale) (background light))
     (:foreground "LightGray" :weight bold :underline t))
    (((class grayscale) (background dark))
     (:foreground "Gray50" :weight bold :underline t))
    (((class color) (min-colors 88) (background light)) (:foreground "dark cyan"))
    (((class color) (min-colors 88) (background dark)) (:foreground "Aquamarine"))
    (((class color) (min-colors 16) (background light)) (:foreground "CadetBlue"))
    (((class color) (min-colors 16) (background dark)) (:foreground "Aquamarine"))
    (((class color) (min-colors 8)) (:foreground "magenta"))
    (t (:weight bold :underline t)))
  "Face for todo item prefix or numerical priority string."
  :group 'todo-faces)

(defface todo-top-priority
  ;; bold font-lock-comment-face
  '((default :weight bold)
    (((class grayscale) (background light)) :foreground "DimGray" :slant italic)
    (((class grayscale) (background dark)) :foreground "LightGray" :slant italic)
    (((class color) (min-colors 88) (background light)) :foreground "Firebrick")
    (((class color) (min-colors 88) (background dark)) :foreground "chocolate1")
    (((class color) (min-colors 16) (background light)) :foreground "red")
    (((class color) (min-colors 16) (background dark)) :foreground "red1")
    (((class color) (min-colors 8) (background light)) :foreground "red")
    (((class color) (min-colors 8) (background dark)) :foreground "yellow")
    (t :slant italic))
  "Face for top priority todo item numerical priority string.
The item's priority number string has this face if the number is
less than or equal the category's top priority setting."
  :group 'todo-faces)

(defface todo-nondiary
  ;; '((t :inherit font-lock-type-face))
  '((((class grayscale) (background light)) :foreground "Gray90" :weight bold)
    (((class grayscale) (background dark))  :foreground "DimGray" :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "ForestGreen")
    (((class color) (min-colors 88) (background dark))  :foreground "PaleGreen")
    (((class color) (min-colors 16) (background light)) :foreground "ForestGreen")
    (((class color) (min-colors 16) (background dark))  :foreground "PaleGreen")
    (((class color) (min-colors 8)) :foreground "green")
    (t :weight bold :underline t))
  "Face for non-diary markers around todo item date/time header."
  :group 'todo-faces)

(defface todo-date
  '((t :inherit diary))
  "Face for the date string of a todo item."
  :group 'todo-faces)

(defface todo-time
  '((t :inherit diary-time))
  "Face for the time string of a todo item."
  :group 'todo-faces)

(defface todo-diary-expired
  ;; Doesn't contrast enough with todo-date (= diary) face.
  ;; ;; '((t :inherit warning))
  ;; '((default :weight bold)
  ;;   (((class color) (min-colors 16)) :foreground "DarkOrange")
  ;;   (((class color)) :foreground "yellow"))
  ;; bold font-lock-function-name-face
  '((default :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "Blue1")
    (((class color) (min-colors 88) (background dark))  :foreground "LightSkyBlue")
    (((class color) (min-colors 16) (background light)) :foreground "Blue")
    (((class color) (min-colors 16) (background dark))  :foreground "LightSkyBlue")
    (((class color) (min-colors 8)) :foreground "blue")
    (t :inverse-video t))
  "Face for expired dates of diary items."
  :group 'todo-faces)

(defface todo-done-sep
  ;; '((t :inherit font-lock-builtin-face))
  '((((class grayscale) (background light)) :foreground "LightGray" :weight bold)
    (((class grayscale) (background dark))  :foreground "DimGray" :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "dark slate blue")
    (((class color) (min-colors 88) (background dark))  :foreground "LightSteelBlue")
    (((class color) (min-colors 16) (background light)) :foreground "Orchid")
    (((class color) (min-colors 16) (background dark)) :foreground "LightSteelBlue")
    (((class color) (min-colors 8)) :foreground "blue" :weight bold)
    (t :weight bold))
  "Face for separator string between done and not done todo items."
  :group 'todo-faces)

(defface todo-done
  ;; '((t :inherit font-lock-keyword-face))
  '((((class grayscale) (background light)) :foreground "LightGray" :weight bold)
    (((class grayscale) (background dark))  :foreground "DimGray" :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "Purple")
    (((class color) (min-colors 88) (background dark))  :foreground "Cyan1")
    (((class color) (min-colors 16) (background light)) :foreground "Purple")
    (((class color) (min-colors 16) (background dark))  :foreground "Cyan")
    (((class color) (min-colors 8)) :foreground "cyan" :weight bold)
    (t :weight bold))
  "Face for done todo item header string."
  :group 'todo-faces)

(defface todo-comment
  ;; '((t :inherit font-lock-comment-face))
  '((((class grayscale) (background light))
     :foreground "DimGray" :weight bold :slant italic)
    (((class grayscale) (background dark))
     :foreground "LightGray" :weight bold :slant italic)
    (((class color) (min-colors 88) (background light))
     :foreground "Firebrick")
    (((class color) (min-colors 88) (background dark))
     :foreground "chocolate1")
    (((class color) (min-colors 16) (background light))
     :foreground "red")
    (((class color) (min-colors 16) (background dark))
     :foreground "red1")
    (((class color) (min-colors 8) (background light))
     :foreground "red")
    (((class color) (min-colors 8) (background dark))
     :foreground "yellow")
    (t :weight bold :slant italic))
  "Face for comments appended to done todo items."
  :group 'todo-faces)

(defface todo-search
  ;; '((t :inherit match))
  '((((class color)
      (min-colors 88)
      (background light))
     (:background "yellow1"))
    (((class color)
      (min-colors 88)
      (background dark))
     (:background "RoyalBlue3"))
    (((class color)
      (min-colors 8)
      (background light))
     (:foreground "black" :background "yellow"))
    (((class color)
      (min-colors 8)
      (background dark))
     (:foreground "white" :background "blue"))
    (((type tty)
      (class mono))
     (:inverse-video t))
    (t
     (:background "gray")))
  "Face for matches found by `todo-search'."
  :group 'todo-faces)

(defface todo-button
  ;; '((t :inherit widget-field))
  '((((type tty))
     (:foreground "black" :background "yellow3"))
    (((class grayscale color)
      (background light))
     (:background "gray85"))
    (((class grayscale color)
      (background dark))
     (:background "dim gray"))
    (t
     (:slant italic)))
  "Face for buttons in table of categories."
  :group 'todo-faces)

(defface todo-sorted-column
  '((((type tty))
     (:inverse-video t))
    (((class color)
      (background light))
     (:background "grey85"))
    (((class color)
      (background dark))
      (:background "grey85" :foreground "grey10"))
    (t
     (:background "gray")))
  "Face for sorted column in table of categories."
  :group 'todo-faces)

(defface todo-archived-only
  ;; '((t (:inherit (shadow))))
  '((((class color)
      (background light))
     (:foreground "grey50"))
    (((class color)
      (background dark))
     (:foreground "grey70"))
    (t
     (:foreground "gray")))
  "Face for archived-only category names in table of categories."
  :group 'todo-faces)

(defface todo-category-string
    ;; '((t :inherit font-lock-type-face))
  '((((class grayscale) (background light)) :foreground "Gray90" :weight bold)
    (((class grayscale) (background dark))  :foreground "DimGray" :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "ForestGreen")
    (((class color) (min-colors 88) (background dark))  :foreground "PaleGreen")
    (((class color) (min-colors 16) (background light)) :foreground "ForestGreen")
    (((class color) (min-colors 16) (background dark))  :foreground "PaleGreen")
    (((class color) (min-colors 8)) :foreground "green")
    (t :weight bold :underline t))
  "Face for category-file header in Todo Filtered Items mode."
  :group 'todo-faces)

;; -----------------------------------------------------------------------------
;;; Entering and exiting
;; -----------------------------------------------------------------------------

;; (defcustom todo-visit-files-commands (list 'find-file 'dired-find-file)
;;   "List of file finding commands for `todo-display-as-todo-file'.
;; Invoking these commands to visit a todo file or todo archive file
;; calls `todo-show' or `todo-find-archive', so that the file is
;; displayed correctly."
;;   :type '(repeat function)
;;   :group 'todo)

(defun todo-short-file-name (file)
  "Return the short form of todo file FILE's name.
This lacks the extension and directory components."
  (when (stringp file)
    (file-name-sans-extension (file-name-nondirectory file))))

(defcustom todo-default-todo-file (todo-short-file-name
				   (car (funcall todo-files-function)))
  "Todo file visited by first session invocation of `todo-show'."
  :type (when todo-files
	  `(radio ,@(mapcar (lambda (f) (list 'const f))
			    (mapcar 'todo-short-file-name
				    (funcall todo-files-function)))))
  :group 'todo)

(defcustom todo-show-current-file t
  "Non-nil to make `todo-show' visit the current todo file.
Otherwise, `todo-show' always visits `todo-default-todo-file'."
  :type 'boolean
  :initialize 'custom-initialize-default
  :set 'todo-set-show-current-file
  :group 'todo)

(defcustom todo-show-first 'first
  "What action to take on first use of `todo-show' on a file."
  :type '(choice (const :tag "Show first category" first)
		 (const :tag "Show table of categories" table)
		 (const :tag "Show top priorities" top)
		 (const :tag "Show diary items" diary)
		 (const :tag "Show regexp items" regexp))
  :group 'todo)

(defcustom todo-add-item-if-new-category t
  "Non-nil to prompt for an item after adding a new category."
  :type 'boolean
  :group 'todo-edit)

(defcustom todo-initial-file "Todo"
  "Default file name offered on adding first todo file."
  :type 'string
  :group 'todo)

(defcustom todo-initial-category "Todo"
  "Default category name offered on initializing a new todo file."
  :type 'string
  :group 'todo)

(defcustom todo-category-completions-files nil
  "List of files for building `todo-read-category' completions."
  :type `(set ,@(mapcar (lambda (f) (list 'const f))
			(mapcar 'todo-short-file-name
				(funcall todo-files-function))))
  :group 'todo)

(defcustom todo-completion-ignore-case nil
  "Non-nil means case is ignored by `todo-read-*' functions."
  :type 'boolean
  :group 'todo)

;;;###autoload
(defun todo-show (&optional solicit-file interactive)
  "Visit a todo file and display one of its categories.

When invoked in Todo mode, prompt for which todo file to visit.
When invoked outside of Todo mode with non-nil prefix argument
SOLICIT-FILE prompt for which todo file to visit; otherwise visit
`todo-default-todo-file'.  Subsequent invocations from outside
of Todo mode revisit this file or, with option
`todo-show-current-file' non-nil (the default), whichever todo
file was last visited.

If you call this command before you have created any todo file in
the current format, and you have an todo file in old format, it
will ask you whether to convert that file and show it.
Otherwise, calling this command before any todo file exists
prompts for a file name and an initial category (defaulting to
`todo-initial-file' and `todo-initial-category'), creates both of
these, visits the file and displays the category, and if option
`todo-add-item-if-new-category' is non-nil (the default), prompts
for the first item.

The first invocation of this command on an existing todo file
interacts with the option `todo-show-first': if its value is
`first' (the default), show the first category in the file; if
its value is `table', show the table of categories in the file;
if its value is one of `top', `diary' or `regexp', show the
corresponding saved top priorities, diary items, or regexp items
file, if any.  Subsequent invocations always show the file's
current (i.e., last displayed) category.

In Todo mode just the category's unfinished todo items are shown
by default.  The done items are hidden, but typing
`\\[todo-toggle-view-done-items]' displays them below the todo
items.  With non-nil user option `todo-show-with-done' both todo
and done items are always shown on visiting a category.

Invoking this command in Todo Archive mode visits the
corresponding todo file, displaying the corresponding category."
  (interactive "P\np")
  (when todo-default-todo-file
    (todo-check-file (todo-absolute-file-name todo-default-todo-file)))
  (catch 'shown
    ;; Before initializing the first todo first, check if there is a
    ;; legacy todo file and if so, offer to convert to the current
    ;; format and make it the first new todo file.
    (unless todo-default-todo-file
      (let ((legacy-todo-file (if (boundp 'todo-file-do)
    				  todo-file-do
    				(locate-user-emacs-file "todo-do" ".todo-do"))))
    	(when (and (file-exists-p legacy-todo-file)
    		   (y-or-n-p (concat "Do you want to convert a copy of your "
    				     "old todo file to the new format? ")))
    	  (when (todo-convert-legacy-files)
    	    (throw 'shown nil)))))
    (catch 'end
      (let* ((cat)
	     (show-first todo-show-first)
	     (file (cond ((or solicit-file
			      (and interactive
				   (memq major-mode '(todo-mode
						      todo-archive-mode
						      todo-filtered-items-mode))))
			  (if (funcall todo-files-function)
			      (todo-read-file-name "Choose a todo file to visit: "
						    nil t)
			    (user-error "There are no todo files")))
			 ((and (eq major-mode 'todo-archive-mode)
			       ;; Called noninteractively via todo-quit
			       ;; to jump to corresponding category in
			       ;; todo file.
			       (not interactive))
			  (setq cat (todo-current-category))
			  (concat (file-name-sans-extension
				   todo-current-todo-file) ".todo"))
			 (t
			  (or todo-current-todo-file
			      (and todo-show-current-file
				   todo-global-current-todo-file)
			      (todo-absolute-file-name todo-default-todo-file)
			      (todo-add-file)))))
	     add-item first-file)
	(unless todo-default-todo-file
	  ;; We just initialized the first todo file, so make it the default.
	  (setq todo-default-todo-file (todo-short-file-name file)
		first-file t)
	  (todo-reevaluate-default-file-defcustom))
	(unless (member file todo-visited)
	  ;; Can't setq t-c-t-f here, otherwise wrong file shown when
	  ;; todo-show is called from todo-show-categories-table.
	  (let ((todo-current-todo-file file))
	    (cond ((eq todo-show-first 'table)
		   (todo-show-categories-table))
		  ((memq todo-show-first '(top diary regexp))
		   (let* ((shortf (todo-short-file-name file))
			  (fi-file (todo-absolute-file-name
				    shortf todo-show-first)))
		     (when (eq todo-show-first 'regexp)
		       (let ((rxfiles (directory-files todo-directory t
						       ".*\\.todr$" t)))
			 (when (and rxfiles (> (length rxfiles) 1))
			   (let ((rxf (mapcar 'todo-short-file-name rxfiles)))
			     (setq fi-file (todo-absolute-file-name
					    (completing-read
					     "Choose a regexp items file: "
					     rxf) 'regexp))))))
		     (if (file-exists-p fi-file)
			 (progn
			   (set-window-buffer
			    (selected-window)
			    (set-buffer (find-file-noselect fi-file 'nowarn)))
			   (unless (derived-mode-p 'todo-filtered-items-mode)
			     (todo-filtered-items-mode)))
		       (message "There is no %s file for %s"
				(cond ((eq todo-show-first 'top)
				       "top priorities")
				      ((eq todo-show-first 'diary)
				       "diary items")
				      ((eq todo-show-first 'regexp)
				       "regexp items"))
				shortf)
		       (setq todo-show-first 'first)))))))
	(when (or (member file todo-visited)
		  (eq todo-show-first 'first))
	  (unless (todo-check-file file) (throw 'end nil))
	  (set-window-buffer (selected-window)
			     (set-buffer (find-file-noselect file 'nowarn)))
	  (if (equal (file-name-extension (buffer-file-name)) "toda")
	      (unless (derived-mode-p 'todo-archive-mode) (todo-archive-mode))
	    (unless (derived-mode-p 'todo-mode) (todo-mode)))
	  ;; When quitting an archive file, show the corresponding
	  ;; category in the corresponding todo file, if it exists.
	  (when (assoc cat todo-categories)
	    (setq todo-category-number (todo-category-number cat)))
	  ;; If this is a new todo file, add its first category.
	  (when (zerop (buffer-size))
	    (let (cat-added)
	      (unwind-protect
		  (setq todo-category-number
			(todo-add-category todo-current-todo-file "")
			add-item todo-add-item-if-new-category
			cat-added t)
		(if cat-added
		    ;; If the category was added, save the file now, so we
		    ;; don't risk having an empty todo file, which would
		    ;; signal an error if we tried to visit it later,
		    ;; since doing that looks for category boundaries.
		    (save-buffer 0)
		  ;; If user cancels before adding the category, clean up
		  ;; and exit, so we have a fresh slate the next time.
		  (delete-file file)
		  ;; (setq todo-files (funcall todo-files-function))
		  (setq todo-files (delete file todo-files))
		  (when first-file
		    (setq todo-default-todo-file nil
			  todo-current-todo-file nil)
		    (todo-reevaluate-default-file-defcustom))
		  (kill-buffer)
		  (keyboard-quit)))))
	  (save-excursion (todo-category-select))
	  (when add-item (todo-insert-item--basic)))
	(setq todo-show-first show-first)
	(add-to-list 'todo-visited file)))))

(defun todo-save ()
  "Save the current todo file."
  (interactive)
  (cond ((eq major-mode 'todo-filtered-items-mode)
	 (todo-check-filtered-items-file)
	 (todo-save-filtered-items-buffer))
	(t
	 (save-buffer))))

(defvar todo-descending-counts)

(defun todo-quit ()
  "Exit the current Todo-related buffer.
Depending on the specific mode, this either kills the buffer or
buries it and restores state as needed."
  (interactive)
  (let ((buf (current-buffer)))
    (cond ((eq major-mode 'todo-categories-mode)
	   ;; Postpone killing buffer till after calling todo-show, to
	   ;; prevent killing todo-mode buffer.
	   (setq todo-descending-counts nil)
	   ;; Ensure todo-show calls todo-show-categories-table only on
	   ;; first invocation per file.
	   (when (eq todo-show-first 'table)
	     (add-to-list 'todo-visited todo-current-todo-file))
	   (todo-show)
	   (kill-buffer buf))
	  ((eq major-mode 'todo-filtered-items-mode)
	   (kill-buffer)
	   (unless (eq major-mode 'todo-mode) (todo-show)))
	  ((eq major-mode 'todo-archive-mode)
	   ;; Have to write a newly created archive to file to avoid
	   ;; subsequent errors.
	   (todo-save)
	   (let ((todo-file (concat todo-directory
				    (todo-short-file-name todo-current-todo-file)
				    ".todo")))
	     (if (todo-check-file todo-file)
		 (todo-show)
	       (message "There is no todo file for this archive")))
	   ;; When todo-check-file runs in todo-show, it kills the
	   ;; buffer if the archive file was deleted externally.
	   (when (buffer-live-p buf) (bury-buffer buf)))
	  ((eq major-mode 'todo-mode)
	   (todo-save)
	   ;; If we just quit archive mode, just burying the buffer
	   ;; in todo-mode would return to archive.
	   (set-window-buffer (selected-window)
			      (set-buffer (other-buffer)))
	   (bury-buffer buf)))))

;; -----------------------------------------------------------------------------
;;; Navigation between and within categories
;; -----------------------------------------------------------------------------

(defcustom todo-skip-archived-categories nil
  "Non-nil to handle categories with only archived items specially.

Sequential category navigation using \\[todo-forward-category]
or \\[todo-backward-category] skips categories that contain only
archived items.  Other commands still recognize these categories.
In Todo Categories mode (\\[todo-show-categories-table]) these
categories shown in `todo-archived-only' face and pressing the
category button visits the category in the archive instead of the
todo file."
  :type 'boolean
  :group 'todo-display)

(defun todo-forward-category (&optional back)
  "Visit the numerically next category in this todo file.
If the current category is the highest numbered, visit the first
category.  With non-nil argument BACK, visit the numerically
previous category (the highest numbered one, if the current
category is the first)."
  (interactive)
  (setq todo-category-number
        (1+ (mod (- todo-category-number (if back 2 0))
		 (length todo-categories))))
  (when todo-skip-archived-categories
    (while (and (zerop (todo-get-count 'todo))
		(zerop (todo-get-count 'done))
		(not (zerop (todo-get-count 'archived))))
      (setq todo-category-number
	    (apply (if back '1- '1+) (list todo-category-number)))))
  (todo-category-select)
  (goto-char (point-min)))

(defun todo-backward-category ()
  "Visit the numerically previous category in this todo file.
If the current category is the highest numbered, visit the first
category."
  (interactive)
  (todo-forward-category t))

(defvar todo-categories-buffer)

(defun todo-jump-to-category (&optional file where)
  "Prompt for a category in a todo file and jump to it.

With non-nil FILE (interactively a prefix argument), prompt for a
specific todo file and choose (with TAB completion) a category
in it to jump to; otherwise, choose and jump to any category in
either the current todo file or a file in
`todo-category-completions-files'.

Also accept a non-existing category name and ask whether to add a
new category by that name; on confirmation, add it and jump to
that category, and if option `todo-add-item-if-new-category' is
non-nil (the default), then prompt for the first item.

In noninteractive calls non-nil WHERE specifies either the goal
category or its file.  If its value is `archive', the choice of
categories is restricted to the current archive file or the
archive you were prompted to choose; this is used by
`todo-jump-to-archive-category'.  If its value is the name of a
category, jump directly to that category; this is used in Todo
Categories mode."
  (interactive "P")
  ;; If invoked outside of Todo mode and there is not yet any Todo
  ;; file, initialize one.
  (if (null (funcall todo-files-function))
      (todo-show)
    (let* ((archive (eq where 'archive))
	   (cat (unless archive where))
	   (file0 (when cat		; We're in Todo Categories mode.
		    ;; With non-nil `todo-skip-archived-categories'
		    ;; jump to archive file of a category with only
		    ;; archived items.
		    (if (and todo-skip-archived-categories
			     (zerop (todo-get-count 'todo cat))
			     (zerop (todo-get-count 'done cat))
			     (not (zerop (todo-get-count 'archived cat))))
			(concat (file-name-sans-extension
				 todo-current-todo-file) ".toda")
		      ;; Otherwise, jump to current todo file.
		      todo-current-todo-file)))
	   (len (length todo-categories))
	   (cat+file (unless cat
		       (todo-read-category "Jump to category: "
					    (if archive 'archive) file)))
	   (add-item (and todo-add-item-if-new-category
			  (> (length todo-categories) len)))
	   (category (or cat (car cat+file))))
      (unless cat (setq file0 (cdr cat+file)))
      (with-current-buffer (find-file-noselect file0 'nowarn)
	(setq todo-current-todo-file file0)
	;; If called from Todo Categories mode, clean up before jumping.
	(if (string= (buffer-name) todo-categories-buffer)
	    (kill-buffer))
	(set-window-buffer (selected-window)
			   (set-buffer (find-buffer-visiting file0)))
	(unless todo-global-current-todo-file
	  (setq todo-global-current-todo-file todo-current-todo-file))
	(todo-category-number category)
	(todo-category-select)
	(goto-char (point-min))
	(when add-item (todo-insert-item--basic))))))

(defun todo-next-item (&optional count)
  "Move point down to the beginning of the next item.
With positive numerical prefix COUNT, move point COUNT items
downward.

If the category's done items are hidden, this command also moves
point to the empty line below the last todo item from any higher
item in the category, i.e., when invoked with or without a prefix
argument.  If the category's done items are visible, this command
called with a prefix argument only moves point to a lower item,
e.g., with point on the last todo item and called with prefix 1,
it moves point to the first done item; but if called with point
on the last todo item without a prefix argument, it moves point
the the empty line above the done items separator."
  (interactive "p")
  ;; It's not worth the trouble to allow prefix arg value < 1, since
  ;; we have the corresponding command.
  (cond ((and current-prefix-arg (< count 1))
	 (user-error "The prefix argument must be a positive number"))
	(current-prefix-arg
	 (todo-forward-item count))
	(t
	 (todo-forward-item))))

(defun todo-previous-item (&optional count)
  "Move point up to start of item with next higher priority.
With positive numerical prefix COUNT, move point COUNT items
upward.

If the category's done items are visible, this command called
with a prefix argument only moves point to a higher item, e.g.,
with point on the first done item and called with prefix 1, it
moves to the last todo item; but if called with point on the
first done item without a prefix argument, it moves point the the
empty line above the done items separator."
  (interactive "p")
  ;; Avoid moving to bob if on the first item but not at bob.
  (when (> (line-number-at-pos) 1)
    ;; It's not worth the trouble to allow prefix arg value < 1, since
    ;; we have the corresponding command.
    (cond ((and current-prefix-arg (< count 1))
	   (user-error "The prefix argument must be a positive number"))
	  (current-prefix-arg
	   (todo-backward-item count))
	  (t
	   (todo-backward-item)))))

;; -----------------------------------------------------------------------------
;;; Display toggle commands
;; -----------------------------------------------------------------------------

(defun todo-toggle-prefix-numbers ()
  "Hide item numbering if shown, show if hidden."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (let* ((ov (todo-get-overlay 'prefix))
	     (show-done (re-search-forward todo-done-string-start nil t))
	     (todo-show-with-done show-done)
	     (todo-number-prefix (not (equal (overlay-get ov 'before-string)
					      "1 "))))
	(if (eq major-mode 'todo-filtered-items-mode)
	    (todo-prefix-overlays)
	  (todo-category-select))))))

(defun todo-toggle-view-done-items ()
  "Show hidden or hide visible done items in current category."
  (interactive)
  (if (zerop (todo-get-count 'done (todo-current-category)))
      (message "There are no done items in this category.")
    (let ((opoint (point)))
      (goto-char (point-min))
      (let* ((shown (re-search-forward todo-done-string-start nil t))
	     (todo-show-with-done (not shown)))
	(todo-category-select)
	(goto-char opoint)
	;; If start of done items sections is below the bottom of the
	;; window, make it visible.
	(unless shown
	  (setq shown (progn
			(goto-char (point-min))
			(re-search-forward todo-done-string-start nil t)))
	  (if (not (pos-visible-in-window-p shown))
	      (recenter)
	    (goto-char opoint)))))))

(defun todo-toggle-view-done-only ()
  "Switch between displaying only done or only todo items."
  (interactive)
  (setq todo-show-done-only (not todo-show-done-only))
  (todo-category-select))

(defun todo-toggle-item-highlighting ()
  "Highlight or unhighlight the todo item the cursor is on."
  (interactive)
  (eval-and-compile (require 'hl-line))
  (when (memq major-mode
	      '(todo-mode todo-archive-mode todo-filtered-items-mode))
    (if hl-line-mode
	(hl-line-mode -1)
      (hl-line-mode 1))))

(defun todo-toggle-item-header ()
  "Hide or show item date-time headers in the current file.
With done items, this hides only the done date-time string, not
the the original date-time string."
  (interactive)
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (let ((ov (todo-get-overlay 'header)))
	(if ov
	    (remove-overlays 1 (1+ (buffer-size)) 'todo 'header)
	  (widen)
	  (goto-char (point-min))
	  (while (not (eobp))
	    (when (re-search-forward
		   (concat todo-item-start
			   "\\( " diary-time-regexp "\\)?"
			   (regexp-quote todo-nondiary-end) "? ")
		   nil t)
	      (setq ov (make-overlay (match-beginning 0) (match-end 0) nil t))
	      (overlay-put ov 'todo 'header)
	      (overlay-put ov 'display ""))
	    (todo-forward-item)))))))

;; -----------------------------------------------------------------------------
;;; File and category editing
;; -----------------------------------------------------------------------------

(defun todo-add-file ()
  "Name and initialize a new todo file.
Interactively, prompt for a category and display it, and if
option `todo-add-item-if-new-category' is non-nil (the default),
prompt for the first item.
Noninteractively, return the name of the new file."
  (interactive)
  (let* ((prompt (concat "Enter name of new todo file "
			 "(TAB or SPC to see current names): "))
	 (file (todo-read-file-name prompt)))
    ;; Don't accept the name of an existing todo file.
    (setq file (todo-absolute-file-name
		(todo-validate-name (todo-short-file-name file) 'file)))
    (with-current-buffer (get-buffer-create file)
      (erase-buffer)
      (write-region (point-min) (point-max) file nil 'nomessage nil t)
      (kill-buffer file))
    (setq todo-files (funcall todo-files-function))
    (todo-reevaluate-filelist-defcustoms)
    (if (called-interactively-p 'any)
	(progn
	  (set-window-buffer (selected-window)
			     (set-buffer (find-file-noselect file)))
	  (setq todo-current-todo-file file)
	  (todo-show))
      file)))

(defun todo-rename-file (&optional arg)
  "Rename the current todo file.
With prefix ARG, prompt for a todo file and rename it.
If there are corresponding archive or filtered items files,
rename these accordingly.  If there are live buffers visiting
these files, also rename them accordingly."
  (interactive "P")
  (let* ((oname (or (and arg
			 (todo-read-file-name "Choose a file to rename: "
					      nil t))
		    (buffer-file-name)))
	 (soname (todo-short-file-name oname))
	 (nname (todo-read-file-name "New name for this file: "))
	 (snname (todo-short-file-name nname))
	 (files (directory-files todo-directory t
				 (concat ".*" (regexp-quote soname)
					 ".*\.tod[aorty]$") t)))
    (dolist (f files)
      (let* ((sfname (todo-short-file-name f))
	     (fext (file-name-extension f t))
	     (fbuf (find-buffer-visiting f))
	     (fbname (buffer-name fbuf)))
	(when (string-match (regexp-quote soname) sfname)
	  (let* ((snfname (replace-match snname t t sfname))
		 (nfname (concat todo-directory snfname fext)))
	    (rename-file f nfname)
	    (when fbuf
	      (with-current-buffer fbuf
		(set-visited-file-name nfname t t)
		(cond ((member fext '(".todo" ".toda"))
		       (setq todo-current-todo-file (buffer-file-name))
		       (setq mode-line-buffer-identification
			     (funcall todo-mode-line-function
				      (todo-current-category))))
		      (t
		       (rename-buffer
			(replace-regexp-in-string
			 (regexp-quote soname) snname fbname))))))))))
    (setq todo-files (funcall todo-files-function)
	  todo-archives (funcall todo-files-function t))
    (when (string= todo-default-todo-file soname)
      (setq todo-default-todo-file snname))
    (when (string= todo-global-current-todo-file oname)
      (setq todo-global-current-todo-file nname))
    (todo-reevaluate-filelist-defcustoms)))

(defun todo-delete-file ()
  "Delete the current todo, archive or filtered items file.
If the todo file has a corresponding archive file, or vice versa,
prompt whether to delete that as well.  Also kill the buffers
visiting the deleted files."
  (interactive)
  (let* ((file1 (buffer-file-name))
	 (todo (eq major-mode 'todo-mode))
	 (archive (eq major-mode 'todo-archive-mode))
	 (filtered (eq major-mode 'todo-filtered-items-mode))
	 (file1-sn (todo-short-file-name file1))
	 (file2 (concat todo-directory file1-sn (cond (todo ".toda")
						      (archive ".todo"))))
	 (buf1 (current-buffer))
	 (buf2 (when file2 (find-buffer-visiting file2)))
	 (prompt1 (concat "Delete " (cond (todo "todo")
					  (archive "archive")
					  (filtered "filtered items"))
	 		  " file \"%s\"? "))
	 (prompt2 (concat "Also delete the corresponding "
			  (cond (todo "archive") (archive "todo")) " file "
			  (when buf2 "and kill the buffer visiting it? ")))
	 (delete1 (yes-or-no-p (format prompt1 file1-sn)))
	 (delete2 (when (and delete1 (or (file-exists-p file2) buf2))
		    (yes-or-no-p prompt2))))
    (when delete1
      (when (file-exists-p file1) (delete-file file1))
      (setq todo-visited (delete file1 todo-visited))
      (kill-buffer buf1)
      (if delete2
	  (progn
	    (when (file-exists-p file2) (delete-file file2))
	    (setq todo-visited (delete file2 todo-visited))
	    (and buf2 (kill-buffer buf2)))
	;; If we deleted an archive but not its todo file, update the
	;; latter's category sexp.
	(when (equal (file-name-extension file2) "todo")
	  (with-current-buffer (or buf2 (find-file-noselect file2))
	    (save-excursion
	      (save-restriction
		(widen)
		(goto-char (point-min))
		(let ((sexp (read (buffer-substring-no-properties
				   (line-beginning-position)
				   (line-end-position))))
		      (buffer-read-only nil))
		  (mapc (lambda (x) (aset (cdr x) 3 0)) sexp)
		  (delete-region (line-beginning-position) (line-end-position))
		  (prin1 sexp (current-buffer)))))
	    (todo-set-categories)
	    (unless buf2 (kill-buffer)))))
      (setq todo-files (funcall todo-files-function)
	    todo-archives (funcall todo-files-function t))
      (when (or (string=  file1-sn todo-default-todo-file)
		(and delete2 (string= file1-sn todo-default-todo-file)))
	(setq todo-default-todo-file (todo-short-file-name (car todo-files))))
      (when (or (string= file1 todo-global-current-todo-file)
		(and delete2 (string= file2 todo-global-current-todo-file)))
	(setq todo-global-current-todo-file nil))
      (todo-reevaluate-filelist-defcustoms)
      (message (concat (cond (todo "Todo") (archive "Archive")) " file \"%s\" "
		       (when delete2
			 (concat "and its "
				 (cond (todo "archive") (archive "todo"))
				 " file "))
		       "deleted")
	       file1-sn))))

(defvar todo-edit-buffer "*Todo Edit*"
  "Name of current buffer in Todo Edit mode.")

(defun todo-edit-file ()
  "Put current buffer in `todo-edit-mode'.
This makes the entire file visible and the buffer writable and
you can use the self-insertion keys and standard Emacs editing
commands to make changes.  To return to Todo mode, type
\\[todo-edit-quit].  This runs a file format check, signaling
an error if the format has become invalid.  However, this check
cannot tell if the number of items changed, which could result in
the file containing inconsistent information.  For this reason
this command should be used with caution."
  (interactive)
  (widen)
  (todo-edit-mode)
  (remove-overlays)
  (display-warning 'todo (format "\

Type %s to return to Todo mode.

This also runs a file format check and signals an error if
the format has become invalid.  However, this check cannot
tell if the number of items or categories changed, which
could result in the file containing inconsistent information.
You can repair this inconsistency by invoking the command
`todo-repair-categories-sexp', but this will revert any
renumbering of the categories you have made, so you will
have to renumber them again (see `(todo-mode) Reordering
Categories')." (substitute-command-keys "\\[todo-edit-quit]"))))

(defun todo-add-category (&optional file cat)
  "Add a new category to a todo file.

Called interactively with prefix argument FILE, prompt for a file
and then for a new category to add to that file, otherwise prompt
just for a category to add to the current todo file.  After
adding the category, visit it in Todo mode and if option
`todo-add-item-if-new-category' is non-nil (the default), prompt
for the first item.

Non-interactively, add category CAT to file FILE; if FILE is nil,
add CAT to the current todo file.  After adding the category,
return the new category number."
  (interactive "P")
  (let (catfil file0)
    ;; If cat is passed from caller, don't prompt, unless it is "",
    ;; which means the file was just added and has no category yet.
    (if (and cat (> (length cat) 0))
	(setq file0 (or (and (stringp file) file)
			todo-current-todo-file))
      (setq catfil (todo-read-category "Enter a new category name: "
					'add (when (called-interactively-p 'any)
					       file))
	    cat (car catfil)
	    file0 (if (called-interactively-p 'any)
		      (cdr catfil)
		    file)))
    (find-file file0)
    (let ((counts (make-vector 4 0))	; [todo diary done archived]
	  (num (1+ (length todo-categories)))
	  (buffer-read-only nil))
      (setq todo-current-todo-file file0)
      (setq todo-categories (append todo-categories
				     (list (cons cat counts))))
      (widen)
      (goto-char (point-max))
      (save-excursion			; Save point for todo-category-select.
	(insert todo-category-beg cat "\n\n" todo-category-done "\n"))
      (todo-update-categories-sexp)
      ;; If invoked by user, display the newly added category, if
      ;; called programmatically return the category number to the
      ;; caller.
      (if (called-interactively-p 'any)
	  (progn
	    (setq todo-category-number num)
	    (todo-category-select)
	    (when todo-add-item-if-new-category
	      (todo-insert-item--basic)))
	num))))

(defun todo-rename-category ()
  "Rename current todo category.
If this file has an archive containing this category, rename the
category there as well."
  (interactive)
  (let* ((cat (todo-current-category))
	 (new (read-from-minibuffer
	       (format "Rename category \"%s\" to: " cat))))
    (setq new (todo-validate-name new 'category))
    (let* ((ofile todo-current-todo-file)
	   (archive (concat (file-name-sans-extension ofile) ".toda"))
	   (buffers (append (list ofile)
			    (unless (zerop (todo-get-count 'archived cat))
			      (list archive)))))
      (dolist (buf buffers)
	(with-current-buffer (find-file-noselect buf)
	  (let (buffer-read-only)
	    (setq todo-categories (todo-set-categories))
	    (save-excursion
	      (save-restriction
		(setcar (assoc cat todo-categories) new)
		(widen)
		(goto-char (point-min))
		(todo-update-categories-sexp)
		(re-search-forward (concat (regexp-quote todo-category-beg)
					   "\\(" (regexp-quote cat) "\\)\n")
				   nil t)
		(replace-match new t t nil 1)))))))
    (force-mode-line-update))
  (save-excursion (todo-category-select)))

(defun todo-delete-category (&optional arg)
  "Delete current todo category provided it contains no items.
With prefix ARG delete the category even if it does contain
todo or done items."
  (interactive "P")
  (let* ((file todo-current-todo-file)
	 (cat (todo-current-category))
	 (todo (todo-get-count 'todo cat))
	 (done (todo-get-count 'done cat))
	 (archived (todo-get-count 'archived cat)))
    (if (and (not arg)
	     (or (> todo 0) (> done 0)))
	(message "%s" (substitute-command-keys
		       (concat "To delete a non-empty category, "
			       "type C-u \\[todo-delete-category].")))
      (when (cond ((= (length todo-categories) 1)
		   (todo-y-or-n-p
		    (concat "This is the only category in this file; "
			    "deleting it will also delete the file.\n"
			    "Do you want to proceed? ")))
		  ((> archived 0)
		   (todo-y-or-n-p (concat "This category has archived items; "
				     "the archived category will remain\n"
				     "after deleting the todo category.  "
				     "Do you still want to delete it\n"
				     "(see `todo-skip-archived-categories' "
				     "for another option)? ")))
		  (t
		   (todo-y-or-n-p (concat "Permanently remove category \"" cat
				     "\"" (and arg " and all its entries")
				     "? "))))
	(widen)
	(let ((buffer-read-only)
	      (beg (re-search-backward
		    (concat "^" (regexp-quote (concat todo-category-beg cat))
			    "\n") nil t))
	      (end (if (re-search-forward
			(concat "\n\\(" (regexp-quote todo-category-beg)
				".*\n\\)") nil t)
		       (match-beginning 1)
		     (point-max))))
	  (remove-overlays beg end)
	  (delete-region beg end)
	  (if (= (length todo-categories) 1)
	      ;; If deleted category was the only one, delete the file.
	      (progn
		(todo-reevaluate-filelist-defcustoms)
		;; Skip confirming killing the archive buffer if it has been
		;; modified and not saved.
		(set-buffer-modified-p nil)
		(delete-file file)
		(kill-buffer)
		(message "Deleted todo file %s." file))
	    (setq todo-categories (delete (assoc cat todo-categories)
					       todo-categories))
	    (todo-update-categories-sexp)
	    (setq todo-category-number
		  (1+ (mod todo-category-number (length todo-categories))))
	    (todo-category-select)
	    (goto-char (point-min))
	    (message "Deleted category %s." cat)))))))

(defun todo-move-category ()
  "Move current category to a different todo file.
If the todo file chosen does not exist, it is created.
If the current category has archived items, also move those to
the archive of the file moved to, creating it if it does not exist."
  (interactive)
  (when (or (> (length todo-categories) 1)
	    (todo-y-or-n-p (concat "This is the only category in this file; "
				    "moving it will also delete the file.\n"
				    "Do you want to proceed? ")))
    (let* ((ofile todo-current-todo-file)
	   (cat (todo-current-category))
	   (nfile (todo-read-file-name "Todo file to move this category to: "))
	   (archive (concat (file-name-sans-extension ofile) ".toda"))
	   (buffers (append (list ofile)
			    (unless (zerop (todo-get-count 'archived cat))
			      (list archive))))
	   new)
      (while (equal nfile (file-truename ofile))
	(setq nfile (todo-read-file-name
		     "Choose a file distinct from this file: ")))
      (unless (member nfile todo-files)
	(with-current-buffer (get-buffer-create nfile)
	  (erase-buffer)
	  (write-region (point-min) (point-max) nfile nil 'nomessage nil t)
	  (kill-buffer nfile))
	(setq todo-files (funcall todo-files-function))
	(todo-reevaluate-filelist-defcustoms))
      (dolist (buf buffers)
	(with-current-buffer (find-file-noselect buf)
	  (widen)
	  (goto-char (point-max))
	  (let* ((beg (re-search-backward
		       (concat "^"
			       (regexp-quote (concat todo-category-beg cat))
			       "$")
		       nil t))
		 (end (if (re-search-forward
			   (concat "^" (regexp-quote todo-category-beg))
			   nil t 2)
			  (match-beginning 0)
			(point-max)))
		 (content (buffer-substring-no-properties beg end))
		 (counts (cdr (assoc cat todo-categories)))
		 buffer-read-only)
	    ;; Move the category to the new file.  Also update or create
	    ;; archive file if necessary.
	    (with-current-buffer
		(find-file-noselect
		 ;; Regenerate todo-archives in case there
		 ;; is a newly created archive.
		 (if (member buf (funcall todo-files-function t))
		     (concat (file-name-sans-extension nfile) ".toda")
		   nfile))
	      (if (equal (file-name-extension (buffer-file-name)) "toda")
		  (unless (derived-mode-p 'todo-archive-mode)
		    (todo-archive-mode))
		(unless (derived-mode-p 'todo-mode) (todo-mode)))
	      (let* ((nfile-short (todo-short-file-name nfile))
		     (prompt (concat
			      (format "Todo file \"%s\" already has "
				      nfile-short)
			      (format "the category \"%s\";\n" cat)
			      "enter a new category name: "))
		     buffer-read-only)
		(widen)
		(goto-char (point-max))
		(insert content)
		;; If the file moved to has a category with the same
		;; name, rename the moved category.
		(when (assoc cat todo-categories)
		  (unless (member (file-truename (buffer-file-name))
				  (funcall todo-files-function t))
		    (setq new (read-from-minibuffer prompt))
		    (setq new (todo-validate-name new 'category))))
		;; Replace old with new name in todo and archive files.
		(when new
		  (goto-char (point-max))
		  (re-search-backward
		   (concat "^" (regexp-quote todo-category-beg)
			   "\\(" (regexp-quote cat) "\\)$") nil t)
		  (replace-match new nil nil nil 1)))
	      (setq todo-categories
		    (append todo-categories (list (cons (or new cat) counts))))
	      (todo-update-categories-sexp)
	      ;; If archive was just created, save it to avoid "File
	      ;; <xyz> no longer exists!" message on invoking
	      ;; `todo-view-archived-items'.
	      (unless (file-exists-p (buffer-file-name))
		(save-buffer))
	      (todo-category-number (or new cat))
	      (todo-category-select))
	    ;; Delete the category from the old file, and if that was the
	    ;; last category, delete the file.  Also handle archive file
	    ;; if necessary.
	    (remove-overlays beg end)
	    (delete-region beg end)
	    (goto-char (point-min))
	    ;; Put point after todo-categories sexp.
	    (forward-line)
	    (if (eobp)		; Aside from sexp, file is empty.
		(progn
		  ;; Skip confirming killing the archive buffer.
		  (set-buffer-modified-p nil)
		  (delete-file todo-current-todo-file)
		  (kill-buffer)
		  (when (member todo-current-todo-file todo-files)
		    (todo-reevaluate-filelist-defcustoms)))
	      (setq todo-categories (delete (assoc cat todo-categories)
					     todo-categories))
	      (todo-update-categories-sexp)
	      (when (> todo-category-number (length todo-categories))
		(setq todo-category-number 1))
	      (todo-category-select)))))
      (set-window-buffer (selected-window)
			 (set-buffer (find-file-noselect nfile)))
      (todo-category-number (or new cat))
      (todo-category-select))))

(defun todo-merge-category (&optional file)
  "Merge current category into another existing category.

With prefix argument FILE, prompt for a specific todo file and
choose (with TAB completion) a category in it to merge into;
otherwise, choose and merge into a category in either the
current todo file or a file in `todo-category-completions-files'.

After merging, the source category's todo and done items are
appended to the chosen goal category's todo and done items,
respectively.  The goal category becomes the current category,
and the source category is deleted.

If both the source and goal categories also have archived items,
they are also merged.  If only the source category has archived
items, the goal category is added as a new category to the
archive file and the source category is deleted."
  (interactive "P")
  (let* ((tfile todo-current-todo-file)
	 (cat (todo-current-category))
	 (cat+file (todo-read-category "Merge into category: " 'todo file))
	 (goal (car cat+file))
	 (gfile  (cdr cat+file))
	 (tarchive (concat (file-name-sans-extension tfile) ".toda"))
	 (garchive (concat (file-name-sans-extension gfile) ".toda"))
	 (archived-count (todo-get-count 'archived))
	 here)
    (with-current-buffer (get-buffer (find-file-noselect tfile))
      (widen)
      (let* ((buffer-read-only nil)
	     (cbeg (progn
		     (re-search-backward
		      (concat "^" (regexp-quote todo-category-beg)) nil t)
		     (point-marker)))
	     (tbeg (progn (forward-line) (point-marker)))
	     (dbeg (progn
		     (re-search-forward
		      (concat "^" (regexp-quote todo-category-done)) nil t)
		     (forward-line) (point-marker)))
	     ;; Omit empty line between todo and done items.
	     (tend (progn (forward-line -2) (point-marker)))
	     (cend (progn
		     (if (re-search-forward
			  (concat "^" (regexp-quote todo-category-beg)) nil t)
			 (progn
			   (goto-char (match-beginning 0))
			   (point-marker))
		       (point-max-marker))))
	     (todo (buffer-substring-no-properties tbeg tend))
	     (done (buffer-substring-no-properties dbeg cend))
	     (todo-count (todo-get-count 'todo cat))
	     (done-count (todo-get-count 'done cat)))
	;; Merge into goal todo category.
	(with-current-buffer (get-buffer (find-file-noselect gfile))
	  (unless (derived-mode-p 'todo-mode) (todo-mode))
	  (widen)
	  (goto-char (point-min))
	  (let ((buffer-read-only nil))
	    ;; Merge any todo items.
	    (unless (zerop (length todo))
	      (re-search-forward
	       (concat "^" (regexp-quote (concat todo-category-beg goal)) "$")
	       nil t)
	      (re-search-forward
	       (concat "^" (regexp-quote todo-category-done)) nil t)
	      (forward-line -1)
	      (setq here (point-marker))
	      (insert todo)
	      (todo-update-count 'todo todo-count goal))
	    ;; Merge any done items.
	    (unless (zerop (length done))
	      (goto-char (if (re-search-forward
			      (concat "^" (regexp-quote todo-category-beg))
			      nil t)
			     (match-beginning 0)
			   (point-max)))
	      (when (zerop (length todo)) (setq here (point-marker)))
	      (insert done)
	      (todo-update-count 'done done-count goal)))
	  (todo-update-categories-sexp))
	;; Update and clean up source todo file.
	(remove-overlays cbeg cend)
	(delete-region cbeg cend)
	(setq todo-categories (delete (assoc cat todo-categories)
				      todo-categories))
	(todo-update-categories-sexp)
	(when (> todo-category-number (length todo-categories))
		(setq todo-category-number 1))
	(todo-category-select)
	(mapc (lambda (m) (set-marker m nil))
	      (list cbeg tbeg dbeg tend cend))))
    (when (> archived-count 0)
      (with-current-buffer (get-buffer (find-file-noselect tarchive))
	(widen)
	(goto-char (point-min))
	(let* ((buffer-read-only nil)
	       (cbeg (progn
		       (when (re-search-forward
			      (concat "^" (regexp-quote
					   (concat todo-category-beg cat)) "$")
			      nil t)
			 (goto-char (match-beginning 0))
			 (point-marker))))
	       (cend (if (re-search-forward
			  (concat "^" (regexp-quote todo-category-beg)) nil t)
			 (match-beginning 0)
		       (point-max)))
	       (carch (progn
			(goto-char cbeg)
			(forward-line)
			(buffer-substring-no-properties (point) cend))))
	  ;; Merge into goal archive category, if it exists, else create it.
	  (with-current-buffer (get-buffer (find-file-noselect garchive))
	    (let ((gbeg (when (re-search-forward
			       (concat "^" (regexp-quote
					    (concat todo-category-beg goal))
				       "$")
			       nil t)
			  (goto-char (match-beginning 0))
			  (point-marker))))
	      (goto-char (if (and gbeg
				  (re-search-forward
				   (concat "^" (regexp-quote todo-category-beg))
				   nil t))
			     (match-beginning 0)
			   (point-max)))
	      (unless gbeg (todo-add-category nil goal))
	      (insert carch)
	      (todo-update-categories-sexp)))
	  ;; Update and clean up source archive file.
	  (remove-overlays cbeg cend)
	  (delete-region cbeg cend)
	  (setq todo-categories (todo-make-categories-list t))
	  (todo-update-categories-sexp))))
    ;; Update goal todo file for merged archived items and display it.
    (set-window-buffer (selected-window) (set-buffer (get-file-buffer gfile)))
    (unless (zerop archived-count)
      (todo-update-count 'archived archived-count goal)
      (todo-update-categories-sexp))
    (todo-category-number goal)
    ;; If there are only merged done items, show them.
    (let ((todo-show-with-done (zerop (todo-get-count 'todo goal))))
      (todo-category-select)
      ;; Put point on the first merged item.
      (goto-char here))
    (set-marker here nil)))

;; -----------------------------------------------------------------------------
;;; Item editing
;; -----------------------------------------------------------------------------

(defcustom todo-include-in-diary nil
  "Non-nil to allow new todo items to be included in the diary."
  :type 'boolean
  :group 'todo-edit)

(defcustom todo-diary-nonmarking nil
  "Non-nil to insert new todo diary items as nonmarking by default.
This appends `diary-nonmarking-symbol' to the front of an item on
insertion provided it doesn't begin with `todo-nondiary-marker'."
  :type 'boolean
  :group 'todo-edit)

(defcustom todo-always-add-time-string nil
  "Non-nil adds current time to a new item's date header by default.
When the todo insertion commands have a non-nil \"maybe-notime\"
argument, this reverses the effect of
`todo-always-add-time-string': if t, these commands omit the
current time, if nil, they include it."
  :type 'boolean
  :group 'todo-edit)

(defcustom todo-use-only-highlighted-region t
  "Non-nil to enable inserting only highlighted region as new item."
  :type 'boolean
  :group 'todo-edit)

(defcustom todo-default-priority 'first
  "Default priority of new and moved items."
  :type '(choice (const :tag "Highest priority" first)
		 (const :tag "Lowest priority" last))
  :group 'todo-edit)

(defcustom todo-item-mark "*"
  "String used to mark items.
To ensure item marking works, change the value of this option
only when no items are marked."
  :type '(string :validate
		 (lambda (widget)
		   (when (string= (widget-value widget) todo-prefix)
		     (widget-put
		      widget :error
		      "Invalid value: must be distinct from `todo-prefix'")
		     widget)))
  :set (lambda (symbol value)
	 (custom-set-default symbol (propertize value 'face 'todo-mark)))
  :group 'todo-edit)

(defcustom todo-comment-string "COMMENT"
  "String inserted before optional comment appended to done item."
  :type 'string
  :initialize 'custom-initialize-default
  :set 'todo-reset-comment-string
  :group 'todo-edit)

(defcustom todo-undo-item-omit-comment 'ask
  "Whether to omit done item comment on undoing the item.
Nil means never omit the comment, t means always omit it, `ask'
means prompt user and omit comment only on confirmation."
  :type '(choice (const :tag "Never" nil)
		 (const :tag "Always" t)
		 (const :tag "Ask" ask))
  :group 'todo-edit)

(defun todo-toggle-mark-item (&optional n)
  "Mark item with `todo-item-mark' if unmarked, otherwise unmark it.
With positive numerical prefix argument N, change the marking of
the next N items in the current category.  If both the todo and
done items sections are visible, the sequence of N items can
consist of the the last todo items and the first done items."
  (interactive "p")
  (when (todo-item-string)
    (unless (> n 1) (setq n 1))
    (catch 'end
      (dotimes (i n)
	(let* ((cat (todo-current-category))
	       (marks (assoc cat todo-categories-with-marks))
	       (ov (progn
		     (unless (looking-at todo-item-start)
		       (todo-item-start))
		     (todo-get-overlay 'prefix)))
	       (pref (overlay-get ov 'before-string)))
	  (if (todo-marked-item-p)
	      (progn
		(overlay-put ov 'before-string (substring pref 1))
		(if (= (cdr marks) 1)	; Deleted last mark in this category.
		    (setq todo-categories-with-marks
			  (assq-delete-all cat todo-categories-with-marks))
		  (setcdr marks (1- (cdr marks)))))
	    (overlay-put ov 'before-string (concat todo-item-mark pref))
	    (if marks
		(setcdr marks (1+ (cdr marks)))
	      (push (cons cat 1) todo-categories-with-marks))))
	(todo-forward-item)
	;; Don't try to mark the empty lines at the end of the todo
	;; and done items sections.
	(when (looking-at "^$")
	  (if (eobp)
	      (throw 'end nil)
	    (todo-forward-item)))))))

(defun todo-mark-category ()
  "Mark all visible items in this category with `todo-item-mark'."
  (interactive)
  (let* ((cat (todo-current-category))
	 (marks (assoc cat todo-categories-with-marks)))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(let* ((ov (todo-get-overlay 'prefix))
	       (pref (overlay-get ov 'before-string)))
	  (unless (todo-marked-item-p)
	    (overlay-put ov 'before-string (concat todo-item-mark pref))
	    (if marks
		(setcdr marks (1+ (cdr marks)))
	      (push (cons cat 1) todo-categories-with-marks))))
	(todo-forward-item)
	;; Don't try to mark the empty line between the todo and done
	;; items sections.
	(when (looking-at "^$")
	  (unless (eobp)
	    (todo-forward-item)))))))

(defun todo-unmark-category ()
  "Remove `todo-item-mark' from all visible items in this category."
  (interactive)
  (let* ((cat (todo-current-category))
	 (marks (assoc cat todo-categories-with-marks)))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(let* ((ov (todo-get-overlay 'prefix))
	       ;; No overlay on empty line between todo and done items.
	       (pref (when ov (overlay-get ov 'before-string))))
	  (when (todo-marked-item-p)
	    (overlay-put ov 'before-string (substring pref 1)))
	  (todo-forward-item))))
    (setq todo-categories-with-marks
	  (delq marks todo-categories-with-marks))))

(defvar todo-date-from-calendar nil
  "Helper variable for setting item date from the Emacs Calendar.")

(defvar todo-insert-item--keys-so-far)
(defvar todo-insert-item--parameters)

(defun todo-insert-item (&optional arg)
  "Choose an item insertion operation and carry it out.
This inserts a new todo item into a category.

With no prefix argument ARG, add the item to the current
category; with one prefix argument (`C-u'), prompt for a category
from the current todo file; with two prefix arguments (`C-u
C-u'), first prompt for a todo file, then a category in that
file.  If a non-existing category is entered, ask whether to add
it to the todo file; if answered affirmatively, add the category
and insert the item there.

There are a number of item insertion parameters which can be
combined by entering specific keys to produce different insertion
commands.  After entering each key, a message shows which have
already been entered and which remain available.  See
`(todo-mode) Inserting New Items' for details of the parameters,
their associated keys and their effects."
  (interactive "P")
  (setq todo-insert-item--keys-so-far "i")
  (todo-insert-item--next-param nil (list arg) todo-insert-item--parameters))

(defun todo-insert-item--basic (&optional arg diary-type date-type time where)
  "Function implementing the core of `todo-insert-item'."
  ;; If invoked outside of Todo mode and there is not yet any Todo
  ;; file, initialize one.
  (if (null (funcall todo-files-function))
      (todo-show)
    (let ((copy (eq where 'copy))
	  (region (eq where 'region))
	  (here (eq where 'here))
	  diary-item)
      (when copy
	(cond
	 ((not (eq major-mode 'todo-mode))
	  (user-error "You must be in Todo mode to copy a todo item"))
	 ((todo-done-item-p)
	  (user-error "You cannot copy a done item as a new todo item"))
	 ((looking-at "^$")
	  (user-error "Point must be on a todo item to copy it")))
	(setq diary-item (todo-diary-item-p)))
      (when region
	(let (use-empty-active-region)
	  (unless (and todo-use-only-highlighted-region (use-region-p))
	    (user-error "There is no active region"))))
      (let* ((obuf (current-buffer))
	     (ocat (todo-current-category))
	     (opoint (point))
	     (todo-mm (eq major-mode 'todo-mode))
	     (cat+file (cond ((equal arg '(4))
			      (todo-read-category "Insert in category: "))
			     ((equal arg '(16))
			      (todo-read-category "Insert in category: "
						   nil 'file))
			     (t
			      (cons (todo-current-category)
				    (or todo-current-todo-file
					(and todo-show-current-file
					     todo-global-current-todo-file)
					(todo-absolute-file-name
					 todo-default-todo-file))))))
	     (cat (car cat+file))
	     (file (cdr cat+file))
	     (new-item (cond (copy (todo-item-string))
			     (region (buffer-substring-no-properties
				      (region-beginning) (region-end)))
			     (t (read-from-minibuffer "Todo item: "))))
	     (date-string (cond
			   ((eq date-type 'date)
			    (todo-read-date))
			   ((eq date-type 'dayname)
			    (todo-read-dayname))
			   ((eq date-type 'calendar)
			    (setq todo-date-from-calendar t)
			    (or (todo-set-date-from-calendar)
				;; If user exits Calendar before choosing
				;; a date, cancel item insertion.
				(keyboard-quit)))
			   ((and (stringp date-type)
				 (string-match todo-date-pattern date-type))
			    (setq todo-date-from-calendar date-type)
			    (todo-set-date-from-calendar))
			   (t
			    (calendar-date-string
			     (calendar-current-date) t t))))
	     (time-string (or (and time (todo-read-time))
			      (and todo-always-add-time-string
				   (substring (current-time-string) 11 16)))))
	(setq todo-date-from-calendar nil)
	(find-file-noselect file 'nowarn)
	(set-window-buffer (selected-window)
			   (set-buffer (find-buffer-visiting file)))
	;; If this command was invoked outside of a Todo mode buffer,
	;; the call to todo-current-category above returned nil.  If
	;; we just entered Todo mode now, then cat was set to the
	;; file's first category, but if todo-mode was already
	;; enabled, cat did not get set, so we have to do that.
	(unless cat
	  (setq cat (todo-current-category)))
	(setq todo-current-todo-file file)
	(unless todo-global-current-todo-file
	  (setq todo-global-current-todo-file todo-current-todo-file))
	(let ((buffer-read-only nil)
	      (called-from-outside (not (and todo-mm (equal cat ocat))))
	      done-only item-added)
	  (unless copy
	    (setq new-item
		  ;; Add date, time and diary marking as required.
		  (concat (if (not (and diary-type
					(not todo-include-in-diary)))
			      todo-nondiary-start
			    (when (and (eq diary-type 'nonmarking)
				       (not todo-diary-nonmarking))
			      diary-nonmarking-symbol))
			  date-string (when (and time-string ; Can be empty.
						 (not (zerop (length
							      time-string))))
					(concat " " time-string))
			  (when (not (and diary-type
					  (not todo-include-in-diary)))
			    todo-nondiary-end)
			  " " new-item))
	    ;; Indent newlines inserted by C-q C-j if nonspace char follows.
	    (setq new-item (replace-regexp-in-string "\\(\n\\)[^[:blank:]]"
						     "\n\t" new-item nil nil 1)))
	  (unwind-protect
	      (progn
		;; Make sure the correct category is selected.  There
		;; are two cases: (i) we just visited the file, so no
		;; category is selected yet, or (ii) we invoked
		;; insertion "here" from outside the category we want
		;; to insert in (with priority insertion, category
		;; selection is done by todo-set-item-priority).
		(when (or (= (- (point-max) (point-min)) (buffer-size))
			  (and here called-from-outside))
		  (todo-category-number cat)
		  (todo-category-select))
		;; If only done items are displayed in category,
		;; toggle to todo items before inserting new item.
		(when (save-excursion
			(goto-char (point-min))
			(looking-at todo-done-string-start))
		  (setq done-only t)
		  (todo-toggle-view-done-only))
		(if here
		    (progn
		      ;; If command was invoked with point in done
		      ;; items section or outside of the current
		      ;; category, can't insert "here", so to be
		      ;; useful give new item top priority.
		      (when (or (todo-done-item-section-p)
				called-from-outside
				done-only)
			(goto-char (point-min)))
		      (todo-insert-with-overlays new-item))
		  (todo-set-item-priority new-item cat t))
		(setq item-added t))
	    ;; If user cancels before setting priority, restore
	    ;; display.
	    (unless item-added
	      (set-window-buffer (selected-window) (set-buffer obuf))
	      (when ocat
		(unless (equal cat ocat)
		  (todo-category-number ocat)
		  (todo-category-select))
		(and done-only (todo-toggle-view-done-only)))
	      (goto-char opoint))
	    ;; If the todo items section is not visible when the
	    ;; insertion command is called (either because only done
	    ;; items were shown or because the category was not in the
	    ;; current buffer), then if the item is inserted at the
	    ;; end of the category, point is at eob and eob at
	    ;; window-start, so that higher priority todo items are
	    ;; out of view.  So we recenter to make sure the todo
	    ;; items are displayed in the window.
	    (when item-added (recenter)))
	  (todo-update-count 'todo 1)
	  (when (or diary-item diary-type todo-include-in-diary)
	    (todo-update-count 'diary 1))
	  (todo-update-categories-sexp))))))

(defun todo-set-date-from-calendar ()
  "Return string of date chosen from Calendar."
  (cond ((and (stringp todo-date-from-calendar)
	      (string-match todo-date-pattern todo-date-from-calendar))
	 todo-date-from-calendar)
	(todo-date-from-calendar
	 (let (calendar-view-diary-initially-flag)
	   (calendar)) 			; *Calendar* is now current buffer.
	 (define-key calendar-mode-map [remap newline] 'exit-recursive-edit)
	 ;; If user exits Calendar before choosing a date, clean up properly.
	 (define-key calendar-mode-map
	   [remap calendar-exit] (lambda ()
				    (interactive)
				    (progn
				      (calendar-exit)
				      (exit-recursive-edit))))
	 (message "Put cursor on a date and type <return> to set it.")
	 (recursive-edit)
	 (unwind-protect
	     (when (equal (buffer-name) calendar-buffer)
	       (setq todo-date-from-calendar
		     (calendar-date-string (calendar-cursor-to-date t) t t))
	       (calendar-exit)
	       todo-date-from-calendar)
	   (define-key calendar-mode-map [remap newline] nil)
	   (define-key calendar-mode-map [remap calendar-exit] nil)
	   (unless (zerop (recursion-depth)) (exit-recursive-edit))
	   (when (stringp todo-date-from-calendar)
	     todo-date-from-calendar)))))

(defun todo-insert-item-from-calendar (&optional arg)
  "Prompt for and insert a new item with date selected from calendar.
Invoked without prefix argument ARG, insert the item into the
current category, without one prefix argument, prompt for the
category from the current todo file or from one listed in
`todo-category-completions-files'; with two prefix arguments,
prompt for a todo file and then for a category in it."
  (interactive "P")
  (setq todo-date-from-calendar
	(calendar-date-string (calendar-cursor-to-date t) t t))
  (calendar-exit)
  (todo-insert-item--basic arg nil todo-date-from-calendar))

(define-key calendar-mode-map "it" 'todo-insert-item-from-calendar)

(defun todo-delete-item ()
  "Delete at least one item in this category.
If there are marked items, delete all of these; otherwise, delete
the item at point."
  (interactive)
  (let (ov)
    (unwind-protect
	(let* ((cat (todo-current-category))
	       (marked (assoc cat todo-categories-with-marks))
	       (item (unless marked (todo-item-string)))
	       (answer (if marked
			   (todo-y-or-n-p
			    "Permanently delete all marked items? ")
			 (when item
			   (setq ov (make-overlay
				     (save-excursion (todo-item-start))
				     (save-excursion (todo-item-end))))
			   (overlay-put ov 'face 'todo-search)
			   (todo-y-or-n-p "Permanently delete this item? "))))
	       buffer-read-only)
	  (when answer
	    (and marked (goto-char (point-min)))
	    (catch 'done
	      (while (not (eobp))
		(if (or (and marked (todo-marked-item-p)) item)
		    (progn
		      (if (todo-done-item-p)
			  (todo-update-count 'done -1)
			(todo-update-count 'todo -1 cat)
			(and (todo-diary-item-p)
			     (todo-update-count 'diary -1)))
		      (if ov (delete-overlay ov))
		      (todo-remove-item)
		      ;; Don't leave point below last item.
		      (and item (bolp) (eolp) (< (point-min) (point-max))
			   (todo-backward-item))
		      (when item
			(throw 'done (setq item nil))))
		  (todo-forward-item))))
	    (when marked
	      (setq todo-categories-with-marks
		    (assq-delete-all cat todo-categories-with-marks)))
	    (todo-update-categories-sexp)
	    (todo-prefix-overlays)))
      (if ov (delete-overlay ov)))))

(defvar todo-edit-item--param-key-alist)
(defvar todo-edit-done-item--param-key-alist)

(defun todo-edit-item (&optional arg)
  "Choose an editing operation for the current item and carry it out."
  (interactive "P")
  (let ((marked (assoc (todo-current-category) todo-categories-with-marks)))
    (cond ((and (todo-done-item-p) (not marked))
	   (todo-edit-item--next-key todo-edit-done-item--param-key-alist))
	  ((or marked (todo-item-string))
	   (todo-edit-item--next-key todo-edit-item--param-key-alist arg)))))

(defun todo-edit-item--text (&optional arg)
  "Function providing the text editing facilities of `todo-edit-item'."
  (let ((full-item (todo-item-string)))
    ;; If there are marked items and user invokes a text-editing
    ;; commands with point not on an item, todo-item-start is nil and
    ;; 1+ signals an error, so just make this a noop.
    (when full-item
      (let* ((opoint (point))
	     (start (todo-item-start))
	     (end (save-excursion (todo-item-end)))
	     (item-beg (progn
			 (re-search-forward
			  (concat todo-date-string-start todo-date-pattern
				  "\\( " diary-time-regexp "\\)?"
				  (regexp-quote todo-nondiary-end) "?")
			  (line-end-position) t)
			 (1+ (- (point) start))))
	     (include-header (eq arg 'include-header))
	     (comment-edit (eq arg 'comment-edit))
	     (comment-delete (eq arg 'comment-delete))
	     (header-string (substring full-item 0 item-beg))
	     (item (if (or include-header comment-edit comment-delete)
		       full-item
		     (substring full-item item-beg)))
	     (multiline (or (eq arg 'multiline)
			    (> (length (split-string item "\n")) 1)))
	     (comment (save-excursion
			(todo-item-start)
			(re-search-forward
			 (concat " \\[" (regexp-quote todo-comment-string)
				 ": \\([^]]+\\)\\]") end t)))
	     (prompt (if comment "Edit comment: " "Enter a comment: "))
	     (buffer-read-only nil))
	;; When there are marked items, user can invoke todo-edit-item
	;; even if point is not on an item, but text editing only
	;; applies to the item at point.
	(when (or (and (todo-done-item-p)
		       (or comment-edit comment-delete))
		  (and (not (todo-done-item-p))
		       (or (not arg) include-header multiline)))
	  (cond
	   ((or comment-edit comment-delete)
	    (save-excursion
	      (todo-item-start)
	      (if (re-search-forward (concat " \\["
					     (regexp-quote todo-comment-string)
					     ": \\([^]]+\\)\\]") end t)
		  (if comment-delete
		      (when (todo-y-or-n-p "Delete comment? ")
			(delete-region (match-beginning 0) (match-end 0)))
		    (replace-match (read-string prompt (cons (match-string 1) 1))
				   nil nil nil 1))
		(if comment-delete
		    (user-error "There is no comment to delete")
		  (insert " [" todo-comment-string ": "
			  (prog1 (read-string prompt)
			    ;; If user moved point during editing,
			    ;; make sure it moves back.
			    (goto-char opoint)
			    (todo-item-end))
			  "]")))))
	   (multiline
	    (let ((buf todo-edit-buffer))
	      (set-window-buffer (selected-window)
				 (set-buffer (make-indirect-buffer
					      (buffer-name) buf)))
	      (narrow-to-region (todo-item-start) (todo-item-end))
	      (todo-edit-mode)
	      (message "%s" (substitute-command-keys
			     (concat "Type \\[todo-edit-quit] "
				     "to return to Todo mode.\n")))))
	   (t
	    (let ((new (concat (if include-header "" header-string)
			       (read-string "Edit: " (if include-header
							 (cons item item-beg)
						       (cons item 0))))))
	      (when include-header
		(while (not (string-match (concat todo-date-string-start
						  todo-date-pattern) new))
		  (setq new (read-from-minibuffer
			     "Item must start with a date: " new))))
	      ;; Ensure lines following hard newlines are indented.
	      (setq new (replace-regexp-in-string "\\(\n\\)[^[:blank:]]"
						  "\n\t" new nil nil 1))
	      ;; If user moved point during editing, make sure it moves back.
	      (goto-char opoint)
	      (todo-remove-item)
	      (todo-insert-with-overlays new)
	      (move-to-column item-beg)))))))))

(defun todo-edit-quit ()
  "Return from Todo Edit mode to Todo mode.
If the item contains hard line breaks, make sure the following
lines are indented by `todo-indent-to-here' to conform to diary
format.

If the whole file was in Todo Edit mode, check before returning
whether the file is still a valid todo file and if so, also
recalculate the todo file's categories sexp, in case changes were
made in the number or names of categories."
  (interactive)
  (if (> (buffer-size) (- (point-max) (point-min)))
      ;; We got here via `e m'.
      (let ((item (buffer-string))
	    (regex "\\(\n\\)[^[:blank:]]")
	    (buf (buffer-base-buffer)))
	(while (not (string-match (concat todo-date-string-start
					  todo-date-pattern) item))
	  (setq item (read-from-minibuffer
		     "Item must start with a date: " item)))
	;; Ensure lines following hard newlines are indented.
	(when (string-match regex (buffer-string))
	  (setq item (replace-regexp-in-string regex "\n\t" item nil nil 1))
	  (delete-region (point-min) (point-max))
	  (insert item))
	(kill-buffer)
	(unless (eq (current-buffer) buf)
	  (set-window-buffer (selected-window) (set-buffer buf))))
    ;; We got here via `F e'.
    (when (todo-check-format)
      ;; FIXME: separate out sexp check?
      ;; If manual editing makes e.g. item counts change, have to
      ;; call this to update todo-categories, but it restores
      ;; category order to list order.
      ;; (todo-repair-categories-sexp)
      ;; Compare (todo-make-categories-list t) with sexp and if
      ;; different ask (todo-update-categories-sexp) ?
      (todo-mode)
      (let* ((cat-beg (concat "^" (regexp-quote todo-category-beg)
			      "\\(.*\\)$"))
	     (curline (buffer-substring-no-properties
		       (line-beginning-position) (line-end-position)))
	     (cat (cond ((string-match cat-beg curline)
			 (match-string-no-properties 1 curline))
			((or (re-search-backward cat-beg nil t)
			     (re-search-forward cat-beg nil t))
			 (match-string-no-properties 1)))))
	(todo-category-number cat)
	(todo-category-select)
	(goto-char (point-min))))))

(defun todo-edit-item--header (what &optional inc)
  "Function providing header editing facilities of `todo-edit-item'."
  (let ((marked (assoc (todo-current-category) todo-categories-with-marks))
	(first t)
	(todo-date-from-calendar t)
	;; INC must be an integer, but users could pass it via
	;; `todo-edit-item' as e.g. `-' or `C-u'.
	(inc (prefix-numeric-value inc))
	(buffer-read-only nil)
	ndate ntime year monthname month day
	dayname)	; Needed by calendar-date-display-form.
    (when marked (todo--user-error-if-marked-done-item))
    (save-excursion
      (or (and marked (goto-char (point-min))) (todo-item-start))
      (catch 'end
	(while (not (eobp))
	  (and marked
	       (while (not (todo-marked-item-p))
		 (todo-forward-item)
		 (and (eobp) (throw 'end nil))))
	  (re-search-forward (concat todo-date-string-start "\\(?1:"
				     todo-date-pattern
				     "\\)\\(?2: " diary-time-regexp "\\)?"
				     (regexp-quote todo-nondiary-end) "?")
			     (line-end-position) t)
	  (let* ((odate (match-string-no-properties 1))
		 (otime (match-string-no-properties 2))
		 (odayname (match-string-no-properties 5))
		 (omonthname (match-string-no-properties 6))
		 (omonth (match-string-no-properties 7))
		 (oday (match-string-no-properties 8))
		 (oyear (match-string-no-properties 9))
		 (tmn-array todo-month-name-array)
		 (mlist (append tmn-array nil))
		 (tma-array todo-month-abbrev-array)
		 (mablist (append tma-array nil))
		 (yy (and oyear (unless (string= oyear "*")
				  (string-to-number oyear))))
		 (mm (or (and omonth (unless (string= omonth "*")
				       (string-to-number omonth)))
			 (1+ (- (length mlist)
				(length (or (member omonthname mlist)
					    (member omonthname mablist)))))))
		 (dd (and oday (unless (string= oday "*")
				 (string-to-number oday)))))
	    ;; If there are marked items, use only the first to set
	    ;; header changes, and apply these to all marked items.
	    (when first
	      (cond
	       ((eq what 'date)
		(setq ndate (todo-read-date)))
	       ((eq what 'calendar)
		(setq ndate (save-match-data (todo-set-date-from-calendar))))
	       ((eq what 'today)
		(setq ndate (calendar-date-string (calendar-current-date) t t)))
	       ((eq what 'dayname)
		(setq ndate (todo-read-dayname)))
	       ((eq what 'time)
		(setq ntime (save-match-data (todo-read-time)))
		(when (> (length ntime) 0)
		  (setq ntime (concat " " ntime))))
	       ;; When date string consists only of a day name,
	       ;; passing other date components is a noop.
	       ((and odayname (memq what '(year month day))))
	       ((eq what 'year)
		(setq day oday
		      monthname omonthname
		      month omonth
		      year (cond ((not current-prefix-arg)
				  (todo-read-date 'year))
				 ((string= oyear "*")
				  (user-error "Cannot increment *"))
				 (t
				  (number-to-string (+ yy inc))))))
	       ((eq what 'month)
		(setf day oday
		      year oyear
		      (if (memq 'month calendar-date-display-form)
			  month
			monthname)
		      (cond ((not current-prefix-arg)
			     (todo-read-date 'month))
			    ((or (string= omonth "*") (= mm 13))
			     (user-error "Cannot increment *"))
			    (t
			     (let ((mminc (+ mm inc)))
			       ;; Increment or decrement month by INC
			       ;; modulo 12.
			       (setq mm (% mminc 12))
			       ;; If result is 0, make month December.
			       (setq mm (if (= mm 0) 12 (abs mm)))
			       ;; Adjust year if necessary.
			       (setq year (or (and (cond ((> mminc 12)
							  (+ yy (/ mminc 12)))
							 ((< mminc 1)
							  (- yy (/ mminc 12) 1))
							 (t yy))
						   (number-to-string yy))
					      oyear)))
			     ;; Return the changed numerical month as
			     ;; a string or the corresponding month name.
			     (if omonth
				 (number-to-string mm)
			       (aref tma-array (1- mm))))))
		(let ((yy (string-to-number year)) ; 0 if year is "*".
		      ;; When mm is 13 (corresponding to "*" as value
		      ;; of month), this raises an args-out-of-range
		      ;; error in calendar-last-day-of-month, so use 1
		      ;; (corresponding to January) to get 31 days.
		      (mm (if (= mm 13) 1 mm)))
		  (if (> (string-to-number day)
			 (calendar-last-day-of-month mm yy))
		      (user-error "%s %s does not have %s days"
			     (aref tmn-array (1- mm))
			     (if (= mm 2) yy "") day))))
	       ((eq what 'day)
		(setq year oyear
		      month omonth
		      monthname omonthname
		      day (cond
			   ((not current-prefix-arg)
			    (todo-read-date 'day mm oyear))
			   ((string= oday "*")
			    (user-error "Cannot increment *"))
			   ((or (string= omonth "*") (string= omonthname "*"))
			    (setq dd (+ dd inc))
			    (if (> dd 31)
				(user-error
				 "A month cannot have more than 31 days")
			      (number-to-string dd)))
			   ;; Increment or decrement day by INC,
			   ;; adjusting month and year if necessary
			   ;; (if year is "*" assume current year to
			   ;; calculate adjustment).
			   (t
			    (let* ((yy (or yy (calendar-extract-year
					       (calendar-current-date))))
				   (date (calendar-gregorian-from-absolute
					  (+ (calendar-absolute-from-gregorian
					      (list mm dd yy)) inc)))
				   (adjmm (nth 0 date)))
			      ;; Set year and month(name) to adjusted values.
			      (unless (string= year "*")
				(setq year (number-to-string (nth 2 date))))
			      (if month
				  (setq month (number-to-string adjmm))
				(setq monthname (aref tma-array (1- adjmm))))
			      ;; Return changed numerical day as a string.
			      (number-to-string (nth 1 date)))))))))
	    (unless odayname
	      ;; If year, month or day date string components were
	      ;; changed, rebuild the date string.
	      (when (memq what '(year month day))
		(setq ndate (mapconcat 'eval calendar-date-display-form ""))))
	    (when ndate (replace-match ndate nil nil nil 1))
	    ;; Add new time string to the header, if it was supplied.
	    (when ntime
	      (if otime
		  (replace-match ntime nil nil nil 2)
		(goto-char (match-end 1))
		(insert ntime)))
	    (setq todo-date-from-calendar nil)
	    (setq first nil))
	  ;; Apply the changes to the first marked item header to the
	  ;; remaining marked items.  If there are no marked items,
	  ;; we're finished.
	  (if marked
	      (todo-forward-item)
	    (goto-char (point-max))))))))

(defun todo-edit-item--diary-inclusion (&optional nonmarking)
  "Function providing diary marking facilities of `todo-edit-item'."
  (let ((buffer-read-only)
	(marked (assoc (todo-current-category) todo-categories-with-marks)))
    (when marked (todo--user-error-if-marked-done-item))
    (catch 'stop
      (save-excursion
	(when marked (goto-char (point-min)))
	(while (not (eobp))
	  (unless (and marked (not (todo-marked-item-p)))
	    (let* ((beg (todo-item-start))
		   (lim (save-excursion (todo-item-end)))
		   (end (save-excursion
			  (or (todo-time-string-matcher lim)
			      (todo-date-string-matcher lim)))))
	      (if nonmarking
		  (if (looking-at (regexp-quote diary-nonmarking-symbol))
		      (replace-match "")
		    (when (looking-at (regexp-quote todo-nondiary-start))
		      (save-excursion
			(replace-match "")
			(search-forward todo-nondiary-end (1+ end) t)
			(replace-match "")
			(todo-update-count 'diary 1)))
		    (insert diary-nonmarking-symbol))
		(if (looking-at (regexp-quote todo-nondiary-start))
		    (progn
		      (replace-match "")
		      (search-forward todo-nondiary-end (1+ end) t)
		      (replace-match "")
		      (todo-update-count 'diary 1))
		  (when end
		    (when (looking-at (regexp-quote diary-nonmarking-symbol))
		      (replace-match "")
		      (setq end (1- end))) ; Since we deleted nonmarking symbol.
		    (insert todo-nondiary-start)
		    (goto-char (1+ end))
		    (insert todo-nondiary-end)
		    (todo-update-count 'diary -1))))))
	  (unless marked (throw 'stop nil))
	  (todo-forward-item)))))
  (todo-update-categories-sexp))

(defun todo-edit-category-diary-inclusion (arg)
  "Make all items in this category diary items.
With prefix ARG, make all items in this category non-diary
items."
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (let ((todo-count (todo-get-count 'todo))
	  (diary-count (todo-get-count 'diary))
	  (buffer-read-only))
      (catch 'stop
	(while (not (eobp))
	  (if (todo-done-item-p)	; We've gone too far.
	      (throw 'stop nil)
	    (let* ((beg (todo-item-start))
		   (lim (save-excursion (todo-item-end)))
		   (end (save-excursion
			  (or (todo-time-string-matcher lim)
			      (todo-date-string-matcher lim)))))
	      (if arg
		  (unless (looking-at (regexp-quote todo-nondiary-start))
		    (when (looking-at (regexp-quote diary-nonmarking-symbol))
		      (replace-match "")
		      (setq end (1- end))) ; Since we deleted nonmarking symbol.
		    (insert todo-nondiary-start)
		    (goto-char (1+ end))
		    (insert todo-nondiary-end))
		(when (looking-at (regexp-quote todo-nondiary-start))
		  (replace-match "")
		  (search-forward todo-nondiary-end (1+ end) t)
		  (replace-match "")))))
	  (todo-forward-item))
	(unless (if arg (zerop diary-count) (= diary-count todo-count))
	  (todo-update-count 'diary (if arg
				      (- diary-count)
				    (- todo-count diary-count))))
	(todo-update-categories-sexp)))))

(defun todo-edit-category-diary-nonmarking (arg)
  "Add `diary-nonmarking-symbol' to all diary items in this category.
With prefix ARG, remove `diary-nonmarking-symbol' from all diary
items in this category."
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (let (buffer-read-only)
      (catch 'stop
	(while (not (eobp))
	  (if (todo-done-item-p)		; We've gone too far.
	      (throw 'stop nil)
	    (unless (looking-at (regexp-quote todo-nondiary-start))
	      (if arg
		  (when (looking-at (regexp-quote diary-nonmarking-symbol))
		    (replace-match ""))
		(unless (looking-at (regexp-quote diary-nonmarking-symbol))
		  (insert diary-nonmarking-symbol))))
	    (todo-forward-item)))))))

(defun todo-set-item-priority (&optional item cat new arg)
  "Prompt for and set ITEM's priority in CATegory.

Interactively, ITEM is the todo item at point, CAT is the current
category, and the priority is a number between 1 and the number
of items in the category.  Non-interactively, non-nil NEW means
ITEM is a new item and the lowest priority is one more than the
number of items in CAT.

The new priority is set either interactively by prompt or by a
numerical prefix argument, or noninteractively by argument ARG,
whose value can be either of the symbols `raise' or `lower',
meaning to raise or lower the item's priority by one."
  (interactive)
  (unless (and (called-interactively-p 'any)
	       (or (todo-done-item-p) (looking-at "^$")))
    (let* ((item (or item (todo-item-string)))
	   (marked (todo-marked-item-p))
	   (cat (or cat (cond ((eq major-mode 'todo-mode)
			       (todo-current-category))
			      ((eq major-mode 'todo-filtered-items-mode)
			       (let* ((regexp1
				       (concat todo-date-string-start
					       todo-date-pattern
					       "\\( " diary-time-regexp "\\)?"
					       (regexp-quote todo-nondiary-end)
					       "?\\(?1: \\[\\(.+:\\)?.+\\]\\)")))
				 (save-excursion
				   (re-search-forward regexp1 nil t)
				   (match-string-no-properties 1)))))))
	   curnum
	   (todo (cond ((or (eq arg 'raise) (eq arg 'lower)
			    (eq major-mode 'todo-filtered-items-mode))
			(save-excursion
			  (let ((curstart (todo-item-start))
				(count 0))
			    (goto-char (point-min))
			    (while (looking-at todo-item-start)
			      (setq count (1+ count))
			      (when (= (point) curstart) (setq curnum count))
			      (todo-forward-item))
			    count)))
		       ((eq major-mode 'todo-mode)
			(todo-get-count 'todo cat))))
	   (maxnum (if new (1+ todo) todo))
	   (prompt (format "Set item priority (1-%d): " maxnum))
	   (priority (cond ((and (not arg) (numberp current-prefix-arg))
			    current-prefix-arg)
			   ((and (eq arg 'raise) (>= curnum 1))
			    (1- curnum))
			   ((and (eq arg 'lower) (<= curnum maxnum))
			    (1+ curnum))))
	   candidate
	   buffer-read-only)
      (unless (and priority
		   (or (and (eq arg 'raise) (zerop priority))
		       (and (eq arg 'lower) (> priority maxnum))))
	;; When moving item to another category, show the category before
	;; prompting for its priority.
	(unless (or arg (called-interactively-p 'any))
	  (todo-category-number cat)
	  ;; If done items in category are visible, keep them visible.
	  (let ((done todo-show-with-done))
	    (when (> (buffer-size) (- (point-max) (point-min)))
	      (save-excursion
		(goto-char (point-min))
		(setq done (re-search-forward todo-done-string-start nil t))))
	    (let ((todo-show-with-done done))
	      ;; Keep current item or top of moved to category in view
	      ;; while setting priority.
	      (save-excursion (todo-category-select)))))
	;; Prompt for priority only when the category has at least one
	;; todo item.
	(when (> maxnum 1)
	  (while (not priority)
	    (setq candidate (read-number prompt
					 (if (eq todo-default-priority 'first)
					     1 maxnum)))
	    (setq prompt (when (or (< candidate 1) (> candidate maxnum))
			   (format "Priority must be an integer between 1 and %d.\n"
				   maxnum)))
	    (unless prompt (setq priority candidate))))
	;; In Top Priorities buffer, an item's priority can be changed
	;; wrt items in another category, but not wrt items in the same
	;; category.
	(when (eq major-mode 'todo-filtered-items-mode)
	  (let* ((regexp2 (concat todo-date-string-start todo-date-pattern
				  "\\( " diary-time-regexp "\\)?"
				  (regexp-quote todo-nondiary-end)
				  "?\\(?1:" (regexp-quote cat) "\\)"))
		 (end (cond ((< curnum priority)
			     (save-excursion (todo-item-end)))
			    ((> curnum priority)
			     (save-excursion (todo-item-start)))))
		 (match (save-excursion
			  (cond ((< curnum priority)
				 (todo-forward-item (1+ (- priority curnum)))
				 (when (re-search-backward regexp2 end t)
				   (match-string-no-properties 1)))
				((> curnum priority)
				 (todo-backward-item (- curnum priority))
				 (when (re-search-forward regexp2 end t)
				   (match-string-no-properties 1)))))))
	    (when match
	      (user-error (concat "Cannot reprioritize items from the same "
			     "category in this mode, only in Todo mode")))))
	;; Interactively or with non-nil ARG, relocate the item within its
	;; category.
	(when (or arg (called-interactively-p 'any))
	  (todo-remove-item))
	(goto-char (point-min))
	(when priority
	  (unless (= priority 1)
	    (todo-forward-item (1- priority))
	    ;; When called from todo-item-undone and the highest priority
	    ;; is chosen, this advances point to the first done item, so
	    ;; move it up to the empty line above the done items
	    ;; separator.
	    (when (looking-back (concat "^"
					(regexp-quote todo-category-done)
					"\n"))
	      (todo-backward-item))))
	(todo-insert-with-overlays item)
	;; If item was marked, restore the mark.
	(and marked
	     (let* ((ov (todo-get-overlay 'prefix))
		    (pref (overlay-get ov 'before-string)))
	       (overlay-put ov 'before-string
			    (concat todo-item-mark pref))))))))

(defun todo-raise-item-priority ()
  "Raise priority of current item by moving it up by one item."
  (interactive)
  (todo-set-item-priority nil nil nil 'raise))

(defun todo-lower-item-priority ()
  "Lower priority of current item by moving it down by one item."
  (interactive)
  (todo-set-item-priority nil nil nil 'lower))

(defun todo-move-item (&optional file)
  "Move at least one todo or done item to another category.
If there are marked items, move all of these; otherwise, move
the item at point.

With prefix argument FILE, prompt for a specific todo file and
choose (with TAB completion) a category in it to move the item or
items to; otherwise, choose and move to any category in either
the current todo file or one of the files in
`todo-category-completions-files'.  If the chosen category is
not an existing categories, then it is created and the item(s)
become(s) the first entry/entries in that category.

With moved todo items, prompt to set the priority in the category
moved to (with multiple todo items, the one that had the highest
priority in the category moved from gets the new priority and the
rest of the moved todo items are inserted in sequence below it).
Moved done items are appended to the top of the done items
section in the category moved to."
  (interactive "P")
  (let* ((cat1 (todo-current-category))
	 (marked (assoc cat1 todo-categories-with-marks)))
    ;; Noop if point is not on an item and there are no marked items.
    (unless (and (looking-at "^$")
		 (not marked))
      (let* ((buffer-read-only)
	     (file1 todo-current-todo-file)
	     (num todo-category-number)
	     (item (todo-item-string))
	     (diary-item (todo-diary-item-p))
	     (done-item (and (todo-done-item-p) (concat item "\n")))
	     (omark (save-excursion (todo-item-start) (point-marker)))
	     (todo 0)
	     (diary 0)
	     (done 0)
	     ov cat2 file2 moved nmark todo-items done-items)
	(unwind-protect
	    (progn
	      (unless marked
		(setq ov (make-overlay (save-excursion (todo-item-start))
				       (save-excursion (todo-item-end))))
		(overlay-put ov 'face 'todo-search))
	      (let* ((pl (if (and marked (> (cdr marked) 1)) "s" ""))
		     (cat+file (todo-read-category (concat "Move item" pl
							    " to category: ")
						    nil file)))
		(while (and (equal (car cat+file) cat1)
			    (equal (cdr cat+file) file1))
		  (setq cat+file (todo-read-category
				  "Choose a different category: ")))
		(setq cat2 (car cat+file)
		      file2 (cdr cat+file))))
	  (if ov (delete-overlay ov)))
	(set-buffer (find-buffer-visiting file1))
	(if marked
	    (progn
	      (goto-char (point-min))
	      (while (not (eobp))
		(when (todo-marked-item-p)
		  (if (todo-done-item-p)
		      (setq done-items (concat done-items
					       (todo-item-string) "\n")
			    done (1+ done))
		    (setq todo-items (concat todo-items
					     (todo-item-string) "\n")
			  todo (1+ todo))
		    (when (todo-diary-item-p)
		      (setq diary (1+ diary)))))
		(todo-forward-item))
	      ;; Chop off last newline of multiple todo item string,
	      ;; since it will be reinserted when setting priority
	      ;; (but with done items priority is not set, so keep
	      ;; last newline).
	      (and todo-items
		   (setq todo-items (substring todo-items 0 -1))))
	  (if (todo-done-item-p)
	      (setq done 1)
	    (setq todo 1)
	    (when (todo-diary-item-p) (setq diary 1))))
	(set-window-buffer (selected-window)
			   (set-buffer (find-file-noselect file2 'nowarn)))
	(unwind-protect
	    (progn
	      (when (or todo-items (and item (not done-item)))
		(todo-set-item-priority (or todo-items item) cat2 t))
	      ;; Move done items en bloc to top of done items section.
	      (when (or done-items done-item)
		(todo-category-number cat2)
		(widen)
		(goto-char (point-min))
		(re-search-forward
		 (concat "^" (regexp-quote (concat todo-category-beg cat2))
			 "$") nil t)
		(re-search-forward
		 (concat "^" (regexp-quote todo-category-done)) nil t)
		(forward-line)
		(insert (or done-items done-item)))
	      (setq moved t))
	  (cond
	   ;; Move succeeded, so remove item from starting category,
	   ;; update item counts and display the category containing
	   ;; the moved item.
	   (moved
	    (setq nmark (point-marker))
	    (when todo (todo-update-count 'todo todo))
	    (when diary (todo-update-count 'diary diary))
	    (when done (todo-update-count 'done done))
	    (todo-update-categories-sexp)
	    (with-current-buffer (find-buffer-visiting file1)
	      (save-excursion
		(save-restriction
		  (widen)
		  (goto-char omark)
		  (if marked
		      (let (beg end)
			(setq item nil)
			(re-search-backward
			 (concat "^" (regexp-quote todo-category-beg)) nil t)
			(forward-line)
			(setq beg (point))
			(setq end (if (re-search-forward
				       (concat "^" (regexp-quote
						    todo-category-beg)) nil t)
				      (match-beginning 0)
				    (point-max)))
			(goto-char beg)
			(while (< (point) end)
			  (if (todo-marked-item-p)
			      (todo-remove-item)
			    (todo-forward-item)))
			(setq todo-categories-with-marks
			      (assq-delete-all cat1 todo-categories-with-marks)))
		    (if ov (delete-overlay ov))
		    (todo-remove-item))))
	      (when todo (todo-update-count 'todo (- todo) cat1))
	      (when diary (todo-update-count 'diary (- diary) cat1))
	      (when done (todo-update-count 'done (- done) cat1))
	      (todo-update-categories-sexp))
	    (set-window-buffer (selected-window)
			       (set-buffer (find-file-noselect file2 'nowarn)))
	    (setq todo-category-number (todo-category-number cat2))
	    (let ((todo-show-with-done (or done-items done-item)))
	      (todo-category-select))
	    (goto-char nmark)
	    ;; If item is moved to end of (just first?) category, make
	    ;; sure the items above it are displayed in the window.
	    (recenter))
	   ;; User quit before setting priority of todo item(s), so
	   ;; return to starting category.
	   (t
	    (set-window-buffer (selected-window)
			       (set-buffer (find-file-noselect file1 'nowarn)))
	    (todo-category-number cat1)
	    (todo-category-select)
	    (goto-char omark))))))))

(defun todo-item-done (&optional arg)
  "Tag a todo item in this category as done and relocate it.

With prefix argument ARG prompt for a comment and append it to
the done item; this is only possible if there are no marked
items.  If there are marked items, tag all of these with
`todo-done-string' plus the current date and, if
`todo-always-add-time-string' is non-nil, the current time;
otherwise, just tag the item at point.  Items tagged as done are
relocated to the category's (by default hidden) done section.  If
done items are visible on invoking this command, they remain
visible."
  (interactive "P")
  (let* ((cat (todo-current-category))
	 (marked (assoc cat todo-categories-with-marks)))
    (when marked (todo--user-error-if-marked-done-item))
    (unless (and (not marked)
		 (or (todo-done-item-p)
		     ;; Point is between todo and done items.
		     (looking-at "^$")))
      (let* ((date-string (calendar-date-string (calendar-current-date) t t))
	     (time-string (if todo-always-add-time-string
			      (concat " " (substring (current-time-string)
						     11 16))
			    ""))
	     (done-prefix (concat "[" todo-done-string date-string time-string
				  "] "))
	     (comment (and arg (read-string "Enter a comment: ")))
	     (item-count 0)
	     (diary-count 0)
	     (show-done (save-excursion
			  (goto-char (point-min))
			  (re-search-forward todo-done-string-start nil t)))
	     (buffer-read-only nil)
	     item done-item opoint)
	;; Don't add empty comment to done item.
	(setq comment (unless (zerop (length comment))
			(concat " [" todo-comment-string ": " comment "]")))
	(and marked (goto-char (point-min)))
	(catch 'done
	  ;; Stop looping when we hit the empty line below the last
	  ;; todo item (this is eobp if only done items are hidden).
	  (while (not (looking-at "^$"))
	    (if (or (not marked) (and marked (todo-marked-item-p)))
		(progn
		  (setq item (todo-item-string))
		  (setq done-item (concat done-item done-prefix item
					  comment (and marked "\n")))
		  (setq item-count (1+ item-count))
		  (when (todo-diary-item-p)
		    (setq diary-count (1+ diary-count)))
		  (todo-remove-item)
		  (unless marked (throw 'done nil)))
	      (todo-forward-item))))
	(when marked
	  ;; Chop off last newline of done item string.
	  (setq done-item (substring done-item 0 -1))
	  (setq todo-categories-with-marks
		(assq-delete-all cat todo-categories-with-marks)))
	(save-excursion
	  (widen)
	  (re-search-forward
	   (concat "^" (regexp-quote todo-category-done)) nil t)
	  (forward-char)
	  (when show-done (setq opoint (point)))
	  (insert done-item "\n"))
	(todo-update-count 'todo (- item-count))
	(todo-update-count 'done item-count)
	(todo-update-count 'diary (- diary-count))
	(todo-update-categories-sexp)
	(let ((todo-show-with-done show-done))
	  (todo-category-select)
	  ;; When done items are shown, put cursor on first just done item.
	  (when opoint (goto-char opoint)))))))

(defun todo-item-undone ()
  "Restore at least one done item to this category's todo section.
Prompt for the new priority.  If there are marked items, undo all
of these, giving the first undone item the new priority and the
rest following directly in sequence; otherwise, undo just the
item at point.

If the done item has a comment, ask whether to omit the comment
from the restored item.  With multiple marked done items with
comments, only ask once, and if affirmed, omit subsequent
comments without asking."
  (interactive)
  (let* ((cat (todo-current-category))
	 (marked (assoc cat todo-categories-with-marks))
	 (pl (if (and marked (> (cdr marked) 1)) "s" "")))
    (when (or marked (todo-done-item-p))
      (let ((buffer-read-only)
	    (opoint (point))
	    (omark (point-marker))
	    (first 'first)
	    (item-count 0)
	    (diary-count 0)
	    start end item ov npoint undone)
	(and marked (goto-char (point-min)))
	(catch 'done
	  (while (not (eobp))
	    (when (or (not marked) (and marked (todo-marked-item-p)))
	      (if (not (todo-done-item-p))
		  (progn
		    (goto-char opoint)
		    (user-error "Only done items can be undone"))
		(todo-item-start)
		(unless marked
		  (setq ov (make-overlay (save-excursion (todo-item-start))
					 (save-excursion (todo-item-end))))
		  (overlay-put ov 'face 'todo-search))
		;; Find the end of the date string added upon tagging item as
		;; done.
		(setq start (search-forward "] "))
		(setq item-count (1+ item-count))
		(unless (looking-at (regexp-quote todo-nondiary-start))
		  (setq diary-count (1+ diary-count)))
		(setq end (save-excursion (todo-item-end)))
		;; Ask (once) whether to omit done item's comment.  If
		;; affirmed, omit subsequent comments without asking.
		(when (re-search-forward
		       (concat " \\[" (regexp-quote todo-comment-string)
			       ": [^]]+\\]") end t)
		  (unwind-protect
		      (if (eq first 'first)
			  (setq first
				(if (eq todo-undo-item-omit-comment 'ask)
				    (when (todo-y-or-n-p
					   (concat "Omit comment" pl
						   " from restored item"
						   pl "? "))
				      'omit)
				  (when todo-undo-item-omit-comment 'omit)))
			t)
		    (when (and (eq first 'first) ov) (delete-overlay ov)))
		  (when (eq first 'omit)
		    (setq end (match-beginning 0))))
		(setq item (concat item
				   (buffer-substring-no-properties start end)
				   (when marked "\n")))
		(unless marked (throw 'done nil))))
	    (todo-forward-item)))
	(unwind-protect
	    (progn
	      ;; Chop off last newline of multiple items string, since
	      ;; it will be reinserted on setting priority.
	      (and marked (setq item (substring item 0 -1)))
	      (todo-set-item-priority item cat t)
	      (setq npoint (point))
	      (setq undone t))
	  (when ov (delete-overlay ov))
	  (if (not undone)
	      (goto-char opoint)
	    (if marked
		(progn
		  (setq item nil)
		  (re-search-forward
		   (concat "^" (regexp-quote todo-category-done)) nil t)
		  (while (not (eobp))
		    (if (todo-marked-item-p)
			(todo-remove-item)
		      (todo-forward-item)))
		  (setq todo-categories-with-marks
			(assq-delete-all cat todo-categories-with-marks)))
	      (goto-char omark)
	      (todo-remove-item))
	    (todo-update-count 'todo item-count)
	    (todo-update-count 'done (- item-count))
	    (when diary-count (todo-update-count 'diary diary-count))
	    (todo-update-categories-sexp)
	    (let ((todo-show-with-done (> (todo-get-count 'done) 0)))
	      (todo-category-select))
	    ;; Put cursor on undone item.
	    (goto-char npoint)))
	(set-marker omark nil)))))

;; -----------------------------------------------------------------------------
;;; Done item archives
;; -----------------------------------------------------------------------------

(defun todo-find-archive (&optional ask)
  "Visit the archive of the current todo category, if it exists.
If the category has no archived items, prompt to visit the
archive anyway.  If there is no archive for this file or with
non-nil argument ASK, prompt to visit another archive.

The buffer showing the archive is in Todo Archive mode.  The
first visit in a session displays the first category in the
archive, subsequent visits return to the last category
displayed."
  (interactive)
  (if (null (funcall todo-files-function t))
      (message "There are no archive files")
    (let* ((cat (todo-current-category))
	   (count (todo-get-count 'archived cat))
	   (archive (concat (file-name-sans-extension todo-current-todo-file)
			    ".toda"))
	   (place (cond (ask 'other-archive)
			((file-exists-p archive) 'this-archive)
			(t (when (todo-y-or-n-p
				  (concat "This file has no archive; "
					  "visit another archive? "))
			     'other-archive)))))
      (when (eq place 'other-archive)
	(setq archive (todo-read-file-name "Choose a todo archive: " t t)))
      (when (and (eq place 'this-archive) (zerop count))
	(setq place (when (todo-y-or-n-p
			    (concat "This category has no archived items;"
				    " visit archive anyway? "))
		       'other-cat)))
      (when place
	(set-window-buffer (selected-window)
			   (set-buffer (find-file-noselect archive)))
	(unless (derived-mode-p 'todo-archive-mode) (todo-archive-mode))
	(if (member place '(other-archive other-cat))
	    (setq todo-category-number 1)
	  (todo-category-number cat))
	(todo-category-select)))))

(defun todo-choose-archive ()
  "Choose an archive and visit it."
  (interactive)
  (todo-find-archive t))

(defun todo-archive-done-item (&optional all)
  "Archive at least one done item in this category.

With prefix argument ALL, prompt whether to archive all done
items in this category and on confirmation archive them.
Otherwise, if there are marked done items (and no marked todo
items), archive all of these; otherwise, archive the done item at
point.

If the archive of this file does not exist, it is created.  If
this category does not exist in the archive, it is created."
  (interactive "P")
  (when (eq major-mode 'todo-mode)
    (if (and all (zerop (todo-get-count 'done)))
	(message "No done items in this category")
      (catch 'end
	(let* ((cat (todo-current-category))
	       (tbuf (current-buffer))
	       (marked (assoc cat todo-categories-with-marks))
	       (afile (concat (file-name-sans-extension
			       todo-current-todo-file) ".toda"))
	       (archive (find-file-noselect afile t))
	       (item (and (not marked) (todo-done-item-p)
			  (concat (todo-item-string) "\n")))
	       (count 0)
	       (opoint (unless (todo-done-item-p) (point)))
	       marked-items beg end all-done
	       buffer-read-only)
	  (cond
	   (all
	    (if (todo-y-or-n-p "Archive all done items in this category? ")
		(save-excursion
		  (save-restriction
		    (goto-char (point-min))
		    (widen)
		    (setq beg (progn
				(re-search-forward todo-done-string-start
						   nil t)
				(match-beginning 0))
			  end (if (re-search-forward
				   (concat "^"
					   (regexp-quote todo-category-beg))
				   nil t)
				  (match-beginning 0)
				(point-max))
			  all-done (buffer-substring-no-properties beg end)
			  count (todo-get-count 'done))
		    ;; Restore starting point, unless it was on a done
		    ;; item, since they will all be deleted.
		    (when opoint (goto-char opoint))))
	      (throw 'end nil)))
	   (marked
	    (save-excursion
	      (goto-char (point-min))
	      (while (not (eobp))
		(when (todo-marked-item-p)
		  (if (not (todo-done-item-p))
		      (throw 'end (message "Only done items can be archived"))
		    (setq marked-items
			  (concat marked-items (todo-item-string) "\n"))
		    (setq count (1+ count))))
		(todo-forward-item)))))
	  (if (not (or marked all item))
	      (throw 'end (message "Only done items can be archived"))
	    (with-current-buffer archive
	      (unless (derived-mode-p 'todo-archive-mode) (todo-archive-mode))
	      (let (buffer-read-only)
		(widen)
		(goto-char (point-min))
		(if (and (re-search-forward
			  (concat "^" (regexp-quote
				       (concat todo-category-beg cat)) "$")
			  nil t)
			 (re-search-forward (regexp-quote todo-category-done)
					    nil t))
		    ;; Start of done items section in existing category.
		    (forward-char)
		  (todo-add-category nil cat)
		  ;; Start of done items section in new category.
		  (goto-char (point-max)))
		(insert (cond (marked marked-items)
			      (all all-done)
			      (item)))
		(todo-update-count 'done (if (or marked all) count 1) cat)
		(todo-update-categories-sexp)
		;; If archive is new, save to file now (with
		;; write-region to avoid prompt for file to save to)
		;; to update todo-archives, and set the mode for
		;; visiting the archive below.
		(unless (nth 7 (file-attributes afile))
		  (write-region nil nil afile t t)
		  (setq todo-archives (funcall todo-files-function t))
		  (todo-archive-mode))))
	    (with-current-buffer tbuf
	      (cond
	       (all
		(save-excursion
		  (save-restriction
		    ;; Make sure done items are accessible.
		    (widen)
		    (remove-overlays beg end)
		    (delete-region beg end)
		    (todo-update-count 'done (- count))
		    (todo-update-count 'archived count))))
	       ((or marked
		    ;; If we're archiving all done items, can't
		    ;; first archive item point was on, since
		    ;; that will short-circuit the rest.
		    (and item (not all)))
		(and marked (goto-char (point-min)))
		(catch 'done
		  (while (not (eobp))
		    (if (or (and marked (todo-marked-item-p)) item)
			(progn
			  (todo-remove-item)
			  (todo-update-count 'done -1)
			  (todo-update-count 'archived 1)
			  ;; Don't leave point below last item.
			  (and (or marked item) (bolp) (eolp)
			       (< (point-min) (point-max))
			       (todo-backward-item))
			  (when item
			    (throw 'done (setq item nil))))
		      (todo-forward-item))))))
	      (when marked
		(setq todo-categories-with-marks
		      (assq-delete-all cat todo-categories-with-marks)))
	      (todo-update-categories-sexp)
	      (todo-prefix-overlays)))
	  (find-file afile)
	  (todo-category-number cat)
	  (todo-category-select)
	  (split-window-below)
	  (set-window-buffer (selected-window) tbuf)
	  ;; Make todo file current to select category.
	  (find-file (buffer-file-name tbuf))
	  ;; Make sure done item separator is hidden (if done items
	  ;; were initially visible).
	  (let (todo-show-with-done) (todo-category-select)))))))

(defun todo-unarchive-items ()
  "Unarchive at least one item in this archive category.
If there are marked items, unarchive all of these; otherwise,
unarchive the item at point.

Unarchived items are restored as done items to the corresponding
category in the todo file, inserted at the top of done items
section.  If all items in the archive category have been
restored, the category is deleted from the archive.  If this was
the only category in the archive, the archive file is deleted."
  (interactive)
  (when (eq major-mode 'todo-archive-mode)
    (let* ((cat (todo-current-category))
	   (tbuf (find-file-noselect
		  (concat (file-name-sans-extension todo-current-todo-file)
			  ".todo") t))
	   (marked (assoc cat todo-categories-with-marks))
	   (item (concat (todo-item-string) "\n"))
	   (marked-count 0)
	   marked-items
	   buffer-read-only)
      (when marked
	(save-excursion
	  (goto-char (point-min))
	  (while (not (eobp))
	    (when (todo-marked-item-p)
	      (setq marked-items (concat marked-items (todo-item-string) "\n"))
	      (setq marked-count (1+ marked-count)))
	    (todo-forward-item))))
      ;; Restore items to top of category's done section and update counts.
      (with-current-buffer tbuf
	(let (buffer-read-only newcat)
	  (widen)
	  (goto-char (point-min))
	  ;; Find the corresponding todo category, or if there isn't
	  ;; one, add it.
	  (unless (re-search-forward
		   (concat "^" (regexp-quote (concat todo-category-beg cat))
			   "$") nil t)
	    (todo-add-category nil cat)
	    (setq newcat t))
	  ;; Go to top of category's done section.
	  (re-search-forward
	   (concat "^" (regexp-quote todo-category-done)) nil t)
	  (forward-line)
	  (cond (marked
		 (insert marked-items)
		 (todo-update-count 'done marked-count cat)
		 (unless newcat		; Newly added category has no archive.
		   (todo-update-count 'archived (- marked-count) cat)))
		(t
		 (insert item)
		 (todo-update-count 'done 1 cat)
		 (unless newcat		; Newly added category has no archive.
		   (todo-update-count 'archived -1 cat))))
	  (todo-update-categories-sexp)))
      ;; Delete restored items from archive.
      (when marked
	(setq item nil)
	(goto-char (point-min)))
      (catch 'done
	(while (not (eobp))
	  (if (or (todo-marked-item-p) item)
	      (progn
		(todo-remove-item)
		(when item
		  (throw 'done (setq item nil))))
	    (todo-forward-item))))
      (todo-update-count 'done (if marked (- marked-count) -1) cat)
      ;; If we unarchived the last item in category, then if that was
      ;; the only category, delete the whole file, otherwise, just
      ;; delete the category.
      (when (= 0 (todo-get-count 'done))
	(if (= 1 (length todo-categories))
	    (progn
	      (delete-file todo-current-todo-file)
	      ;; Kill the archive buffer silently.
	      (set-buffer-modified-p nil)
	      (kill-buffer))
	  (widen)
	  (let ((beg (re-search-backward
		      (concat "^" (regexp-quote todo-category-beg) cat "$")
		      nil t))
		(end (if (re-search-forward
			  (concat "^" (regexp-quote todo-category-beg))
			  nil t 2)
			 (match-beginning 0)
		       (point-max))))
	    (remove-overlays beg end)
	    (delete-region beg end)
	    (setq todo-categories (delete (assoc cat todo-categories)
					  todo-categories)))))
      (todo-update-categories-sexp)
      ;; Visit category in todo file and show restored done items.
      (let ((tfile (buffer-file-name tbuf))
	    (todo-show-with-done t))
	(set-window-buffer (selected-window)
			   (set-buffer (find-file-noselect tfile)))
	(todo-category-number cat)
	(todo-category-select)
	(message "Items unarchived.")))))

(defun todo-jump-to-archive-category (&optional file)
  "Prompt for a category in a todo archive and jump to it.
With prefix argument FILE, prompt for an archive and choose (with
TAB completion) a category in it to jump to; otherwise, choose
and jump to any category in the current archive."
  (interactive "P")
  (todo-jump-to-category file 'archive))

;; -----------------------------------------------------------------------------
;;; Displaying and sorting tables of categories
;; -----------------------------------------------------------------------------

(defcustom todo-categories-category-label "Category"
  "Category button label in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-todo-label "Todo"
  "Todo button label in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-diary-label "Diary"
  "Diary button label in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-done-label "Done"
  "Done button label in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-archived-label "Archived"
  "Archived button label in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-totals-label "Totals"
  "String to label total item counts in Todo Categories mode."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-number-separator " | "
  "String between number and category in Todo Categories mode.
This separates the number from the category name in the default
categories display according to priority."
  :type 'string
  :group 'todo-categories)

(defcustom todo-categories-align 'center
  "Alignment of category names in Todo Categories mode."
  :type '(radio (const left) (const center) (const right))
  :group 'todo-categories)

(defun todo-show-categories-table ()
  "Display a table of the current file's categories and item counts.

In the initial display the lines of the table are numbered,
indicating the current order of the categories when sequentially
navigating through the todo file with `\\[todo-forward-category]'
and `\\[todo-backward-category]'.  You can reorder the lines, and
hence the category sequence, by typing `\\[todo-raise-category]'
or `\\[todo-lower-category]' to raise or lower the category at
point, or by typing `\\[todo-set-category-number]' and entering a
number at the prompt or by typing `\\[todo-set-category-number]'
with a numeric prefix.  If you save the todo file after
reordering the categories, the new order persists in subsequent
Emacs sessions.

The labels above the category names and item counts are buttons,
and clicking these changes the display: sorted by category name
or by the respective item counts (alternately descending or
ascending).  In these displays the categories are not numbered
and `\\[todo-set-category-number]', `\\[todo-raise-category]' and
`\\[todo-lower-category]' are disabled.  (Programmatically, the
sorting is triggered by passing a non-nil SORTKEY argument.)

In addition, the lines with the category names and item counts
are buttonized, and pressing one of these button jumps to the
category in Todo mode (or Todo Archive mode, for categories
containing only archived items, provided user option
`todo-skip-archived-categories' is non-nil.  These categories
are shown in `todo-archived-only' face."
  (interactive)
  (todo-display-categories)
  (let (sortkey)
    (todo-update-categories-display sortkey)))

(defun todo-next-button (n)
  "Move point to the Nth next button in the table of categories."
  (interactive "p")
  (forward-button n 'wrap 'display-message)
  (and (bolp) (button-at (point))
       ;; Align with beginning of category label.
       (forward-char (+ 4 (length todo-categories-number-separator)))))

(defun todo-previous-button (n)
  "Move point to the Nth previous button in the table of categories."
  (interactive "p")
  (backward-button n 'wrap 'display-message)
  (and (bolp) (button-at (point))
       ;; Align with beginning of category label.
       (forward-char (+ 4 (length todo-categories-number-separator)))))

(defun todo-set-category-number (&optional arg)
  "Change number of category at point in the table of categories.

With ARG nil, prompt for the new number.  Alternatively, the
enter the new number with numerical prefix ARG.  Otherwise, if
ARG is either of the symbols `raise' or `lower', raise or lower
the category line in the table by one, respectively, thereby
decreasing or increasing its number."
  (interactive "P")
  (let ((curnum (save-excursion
		  ;; Get the number representing the priority of the category
		  ;; on the current line.
		  (forward-line 0) (skip-chars-forward " ") (number-at-point))))
    (when curnum		; Do nothing if we're not on a category line.
      (let* ((maxnum (length todo-categories))
	     (prompt (format "Set category priority (1-%d): " maxnum))
	     (col (current-column))
	     (buffer-read-only nil)
	     (priority (cond ((and (eq arg 'raise) (> curnum 1))
			      (1- curnum))
			     ((and (eq arg 'lower) (< curnum maxnum))
			      (1+ curnum))))
	     candidate)
	(while (not priority)
	  (setq candidate (or arg (read-number prompt)))
	  (setq arg nil)
	  (setq prompt
		(cond ((or (< candidate 1) (> candidate maxnum))
		       (format "Priority must be an integer between 1 and %d: "
			       maxnum))
		      ((= candidate curnum)
		       "Choose a different priority than the current one: ")))
	  (unless prompt (setq priority candidate)))
	(let* ((lower (< curnum priority)) ; Priority is being lowered.
	       (head (butlast todo-categories
			      (apply (if lower 'identity '1+)
				     (list (- maxnum priority)))))
	       (tail (nthcdr (apply (if lower 'identity '1-) (list priority))
			     todo-categories))
	       ;; Category's name and items counts list.
	       (catcons (nth (1- curnum) todo-categories))
	       (todo-categories (nconc head (list catcons) tail))
	       newcats)
	  (when lower (setq todo-categories (nreverse todo-categories)))
	  (setq todo-categories (delete-dups todo-categories))
	  (when lower (setq todo-categories (nreverse todo-categories)))
	  (setq newcats todo-categories)
	  (kill-buffer)
	  (with-current-buffer (find-buffer-visiting todo-current-todo-file)
	    (setq todo-categories newcats)
	    (todo-update-categories-sexp))
	  (todo-show-categories-table)
	  (forward-line (1+ priority))
	  (forward-char col))))))

(defun todo-raise-category ()
  "Raise priority of category at point in the table of categories."
  (interactive)
  (todo-set-category-number 'raise))

(defun todo-lower-category ()
  "Lower priority of category at point in the table of categories."
  (interactive)
  (todo-set-category-number 'lower))

(defun todo-sort-categories-alphabetically-or-numerically ()
  "Sort table of categories alphabetically or numerically."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (if (member 'alpha todo-descending-counts)
	(progn
	  (todo-update-categories-display nil)
	  (setq todo-descending-counts
		(delete 'alpha todo-descending-counts)))
      (todo-update-categories-display 'alpha))))

(defun todo-sort-categories-by-todo ()
  "Sort table of categories by number of todo items."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todo-update-categories-display 'todo)))

(defun todo-sort-categories-by-diary ()
  "Sort table of categories by number of diary items."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todo-update-categories-display 'diary)))

(defun todo-sort-categories-by-done ()
  "Sort table of categories by number of non-archived done items."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todo-update-categories-display 'done)))

(defun todo-sort-categories-by-archived ()
  "Sort table of categories by number of archived items."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (forward-line 2)
    (todo-update-categories-display 'archived)))

(defvar todo-categories-buffer "*Todo Categories*"
  "Name of buffer in Todo Categories mode.")

(defun todo-longest-category-name-length (categories)
  "Return the length of the longest name in list CATEGORIES."
  (let ((longest 0))
    (dolist (c categories longest)
      (setq longest (max longest (length c))))))

(defun todo-adjusted-category-label-length ()
  "Return adjusted length of category label button.
The adjustment ensures proper tabular alignment in Todo
Categories mode."
  (let* ((categories (mapcar 'car todo-categories))
	 (longest (todo-longest-category-name-length categories))
	 (catlablen (length todo-categories-category-label))
	 (lc-diff (- longest catlablen)))
    (if (and (natnump lc-diff) (cl-oddp lc-diff))
	(1+ longest)
      (max longest catlablen))))

(defun todo-padded-string (str)
  "Return category name or label string STR padded with spaces.
The placement of the padding is determined by the value of user
option `todo-categories-align'."
  (let* ((len (todo-adjusted-category-label-length))
	 (strlen (length str))
	 (strlen-odd (eq (logand strlen 1) 1))
	 (padding (max 0 (/ (- len strlen) 2)))
	 (padding-left (cond ((eq todo-categories-align 'left) 0)
			     ((eq todo-categories-align 'center) padding)
			     ((eq todo-categories-align 'right)
			      (if strlen-odd (1+ (* padding 2)) (* padding 2)))))
	 (padding-right (cond ((eq todo-categories-align 'left)
			       (if strlen-odd (1+ (* padding 2)) (* padding 2)))
			      ((eq todo-categories-align 'center)
			       (if strlen-odd (1+ padding) padding))
			      ((eq todo-categories-align 'right) 0))))
    (concat (make-string padding-left 32) str (make-string padding-right 32))))

(defvar todo-descending-counts nil
  "List of keys for category counts sorted in descending order.")

(defun todo-sort (list &optional key)
  "Return a copy of LIST, possibly sorted according to KEY."
  (let* ((l (copy-sequence list))
	 (fn (if (eq key 'alpha)
		   (lambda (x) (upcase x)) ; Alphabetize case insensitively.
		 (lambda (x) (todo-get-count key x))))
	 ;; Keep track of whether the last sort by key was descending or
	 ;; ascending.
	 (descending (member key todo-descending-counts))
	 (cmp (if (eq key 'alpha)
		  'string<
		(if descending '< '>)))
	 (pred (lambda (s1 s2) (let ((t1 (funcall fn (car s1)))
				     (t2 (funcall fn (car s2))))
				 (funcall cmp t1 t2)))))
    (when key
      (setq l (sort l pred))
      ;; Switch between descending and ascending sort order.
      (if descending
	  (setq todo-descending-counts
		(delete key todo-descending-counts))
	(push key todo-descending-counts)))
    l))

(defun todo-display-sorted (type)
  "Keep point on the TYPE count sorting button just clicked."
  (let ((opoint (point)))
    (todo-update-categories-display type)
    (goto-char opoint)))

(defun todo-label-to-key (label)
  "Return symbol for sort key associated with LABEL."
  (let (key)
    (cond ((string= label todo-categories-category-label)
	   (setq key 'alpha))
	  ((string= label todo-categories-todo-label)
	   (setq key 'todo))
	  ((string= label todo-categories-diary-label)
	   (setq key 'diary))
	  ((string= label todo-categories-done-label)
	   (setq key 'done))
	  ((string= label todo-categories-archived-label)
	   (setq key 'archived)))
    key))

(defun todo-insert-sort-button (label)
  "Insert button for displaying categories sorted by item counts.
LABEL determines which type of count is sorted."
  (let* ((str (if (string= label todo-categories-category-label)
		  (todo-padded-string label)
		label))
	 (beg (point))
	 (end (+ beg (length str)))
	 ov)
    (insert-button str 'face nil
		   'action
		   `(lambda (button)
		      (let ((key (todo-label-to-key ,label)))
			(if (and (member key todo-descending-counts)
				 (eq key 'alpha))
			    (progn
			      ;; If display is alphabetical, switch back to
			      ;; category priority order.
			      (todo-display-sorted nil)
			      (setq todo-descending-counts
				    (delete key todo-descending-counts)))
			  (todo-display-sorted key)))))
    (setq ov (make-overlay beg end))
    (overlay-put ov 'face 'todo-button)))

(defun todo-total-item-counts ()
  "Return a list of total item counts for the current file."
  (mapcar (lambda (i) (apply '+ (mapcar (lambda (l) (aref l i))
					(mapcar 'cdr todo-categories))))
	  (list 0 1 2 3)))

(defvar todo-categories-category-number 0
  "Variable for numbering categories in Todo Categories mode.")

(defun todo-insert-category-line (cat &optional nonum)
  "Insert button with category CAT's name and item counts.
With non-nil argument NONUM show only these; otherwise, insert a
number in front of the button indicating the category's priority.
The number and the category name are separated by the string
which is the value of the user option
`todo-categories-number-separator'."
  (let ((archive (member todo-current-todo-file todo-archives))
	(num todo-categories-category-number)
	(str (todo-padded-string cat))
	(opoint (point)))
    (setq num (1+ num) todo-categories-category-number num)
    (insert-button
     (concat (if nonum
		 (make-string (+ 4 (length todo-categories-number-separator))
			      32)
	       (format " %3d%s" num todo-categories-number-separator))
	     str
	     (mapconcat (lambda (elt)
			  (concat
			   (make-string (1+ (/ (length (car elt)) 2)) 32) ; label
			   (format "%3d" (todo-get-count (cdr elt) cat)) ; count
			   ;; Add an extra space if label length is odd.
			   (when (cl-oddp (length (car elt))) " ")))
			(if archive
			    (list (cons todo-categories-done-label 'done))
			  (list (cons todo-categories-todo-label 'todo)
				(cons todo-categories-diary-label 'diary)
				(cons todo-categories-done-label 'done)
				(cons todo-categories-archived-label
				      'archived)))
			  "")
	     " ") ; Make highlighting on last column look better.
     'face (if (and todo-skip-archived-categories
		    (zerop (todo-get-count 'todo cat))
		    (zerop (todo-get-count 'done cat))
		    (not (zerop (todo-get-count 'archived cat))))
	       'todo-archived-only
	     nil)
     'action `(lambda (button) (let ((buf (current-buffer)))
				 (todo-jump-to-category nil ,cat)
				 (kill-buffer buf))))
    ;; Highlight the sorted count column.
    (let* ((beg (+ opoint 7 (length str)))
	   end ovl)
      (cond ((eq nonum 'todo)
	     (setq beg (+ beg 1 (/ (length todo-categories-todo-label) 2))))
	    ((eq nonum 'diary)
	     (setq beg (+ beg 1 (length todo-categories-todo-label)
			   2 (/ (length todo-categories-diary-label) 2))))
	    ((eq nonum 'done)
	     (setq beg (+ beg 1 (length todo-categories-todo-label)
			   2 (length todo-categories-diary-label)
			   2 (/ (length todo-categories-done-label) 2))))
	    ((eq nonum 'archived)
	     (setq beg (+ beg 1 (length todo-categories-todo-label)
			   2 (length todo-categories-diary-label)
			   2 (length todo-categories-done-label)
			   2 (/ (length todo-categories-archived-label) 2)))))
      (unless (= beg (+ opoint 7 (length str))) ; Don't highlight categories.
	(setq end (+ beg 4))
	(setq ovl (make-overlay beg end))
	(overlay-put ovl 'face 'todo-sorted-column)))
    (newline)))

(defun todo-display-categories ()
  "Prepare buffer for displaying table of categories and item counts."
  (unless (eq major-mode 'todo-categories-mode)
    (setq todo-global-current-todo-file
	  (or todo-current-todo-file
	      (todo-absolute-file-name todo-default-todo-file)))
    (set-window-buffer (selected-window)
		       (set-buffer (get-buffer-create todo-categories-buffer)))
    (kill-all-local-variables)
    (todo-categories-mode)
    (let ((archive (member todo-current-todo-file todo-archives))
	  buffer-read-only)
      (erase-buffer)
      (insert (format (concat "Category counts for todo "
			      (if archive "archive" "file")
			      " \"%s\".")
		      (todo-short-file-name todo-current-todo-file)))
      (newline 2)
      ;; Make space for the column of category numbers.
      (insert (make-string (+ 4 (length todo-categories-number-separator)) 32))
      ;; Add the category and item count buttons (if this is the list of
      ;; categories in an archive, show only done item counts).
      (todo-insert-sort-button todo-categories-category-label)
      (if archive
	  (progn
	    (insert (make-string 3 32))
	    (todo-insert-sort-button todo-categories-done-label))
	(insert (make-string 3 32))
	(todo-insert-sort-button todo-categories-todo-label)
	(insert (make-string 2 32))
	(todo-insert-sort-button todo-categories-diary-label)
	(insert (make-string 2 32))
	(todo-insert-sort-button todo-categories-done-label)
	(insert (make-string 2 32))
	(todo-insert-sort-button todo-categories-archived-label))
      (newline 2))))

(defun todo-update-categories-display (sortkey)
  "Populate table of categories and sort by SORTKEY."
  (let* ((cats0 todo-categories)
	 (cats (todo-sort cats0 sortkey))
	 (archive (member todo-current-todo-file todo-archives))
	 (todo-categories-category-number 0)
	 ;; Find start of Category button if we just entered Todo Categories
	 ;; mode.
	 (pt (if (eq (point) (point-max))
		 (save-excursion
		   (forward-line -2)
		   (goto-char (next-single-char-property-change
			       (point) 'face nil (line-end-position))))))
	 (buffer-read-only))
    (forward-line 2)
    (delete-region (point) (point-max))
    ;; Fill in the table with buttonized lines, each showing a category and
    ;; its item counts.
    (mapc (lambda (cat) (todo-insert-category-line cat sortkey))
	  (mapcar 'car cats))
    (newline)
    ;; Add a line showing item count totals.
    (insert (make-string (+ 4 (length todo-categories-number-separator)) 32)
	    (todo-padded-string todo-categories-totals-label)
	    (mapconcat
	     (lambda (elt)
	       (concat
		(make-string (1+ (/ (length (car elt)) 2)) 32)
		(format "%3d" (nth (cdr elt) (todo-total-item-counts)))
		;; Add an extra space if label length is odd.
		(when (cl-oddp (length (car elt))) " ")))
	     (if archive
		 (list (cons todo-categories-done-label 2))
	       (list (cons todo-categories-todo-label 0)
		     (cons todo-categories-diary-label 1)
		     (cons todo-categories-done-label 2)
		     (cons todo-categories-archived-label 3)))
	     ""))
    ;; Put cursor on Category button initially.
    (if pt (goto-char pt))
    (setq buffer-read-only t)))

;; -----------------------------------------------------------------------------
;;; Searching and item filtering
;; -----------------------------------------------------------------------------

(defun todo-search ()
  "Search for a regular expression in this todo file.
The search runs through the whole file and encompasses all and
only todo and done items; it excludes category names.  Multiple
matches are shown sequentially, highlighted in `todo-search'
face."
  (interactive)
  (let ((regex (read-from-minibuffer "Enter a search string (regexp): "))
	(opoint (point))
	matches match cat in-done ov mlen msg)
    (widen)
    (goto-char (point-min))
    (while (not (eobp))
      (setq match (re-search-forward regex nil t))
      (goto-char (line-beginning-position))
      (unless (or (equal (point) 1)
		  (looking-at (concat "^" (regexp-quote todo-category-beg))))
	(if match (push match matches)))
      (forward-line))
    (setq matches (reverse matches))
    (if matches
	(catch 'stop
	  (while matches
	    (setq match (pop matches))
	    (goto-char match)
	    (todo-item-start)
	    (when (looking-at todo-done-string-start)
	      (setq in-done t))
	    (re-search-backward (concat "^" (regexp-quote todo-category-beg)
					"\\(.*\\)\n") nil t)
	    (setq cat (match-string-no-properties 1))
	    (todo-category-number cat)
	    (todo-category-select)
	    (if in-done
		(unless todo-show-with-done (todo-toggle-view-done-items)))
	    (goto-char match)
	    (setq ov (make-overlay (- (point) (length regex)) (point)))
	    (overlay-put ov 'face 'todo-search)
	    (when matches
	      (setq mlen (length matches))
	      (if (todo-y-or-n-p
		   (if (> mlen 1)
		       (format "There are %d more matches; go to next match? "
			       mlen)
		     "There is one more match; go to it? "))
		  (widen)
		(throw 'stop (setq msg (if (> mlen 1)
					   (format "There are %d more matches."
						   mlen)
					 "There is one more match."))))))
	  (setq msg "There are no more matches."))
      (todo-category-select)
      (goto-char opoint)
      (message "No match for \"%s\"" regex))
    (when msg
      (if (todo-y-or-n-p (concat msg "\nUnhighlight matches? "))
	  (todo-clear-matches)
	(message "You can unhighlight the matches later by typing %s"
		 (key-description (car (where-is-internal
					'todo-clear-matches))))))))

(defun todo-clear-matches ()
  "Remove highlighting on matches found by todo-search."
  (interactive)
  (remove-overlays 1 (1+ (buffer-size)) 'face 'todo-search))

(defcustom todo-top-priorities-overrides nil
  "List of rules specifying number of top priority items to show.
These rules override `todo-top-priorities' on invocations of
`\\[todo-filter-top-priorities]' and
`\\[todo-filter-top-priorities-multifile]'.  Each rule is a list
of the form (FILE NUM ALIST), where FILE is a member of
`todo-files', NUM is a number specifying the default number of
top priority items for each category in that file, and ALIST,
when non-nil, consists of conses of a category name in FILE and a
number specifying the default number of top priority items in
that category, which overrides NUM.

This variable should be set interactively by
`\\[todo-set-top-priorities-in-file]' or
`\\[todo-set-top-priorities-in-category]'."
  :type 'sexp
  :group 'todo-filtered)

(defcustom todo-top-priorities 1
  "Default number of top priorities shown by `todo-filter-top-priorities'."
  :type 'integer
  :group 'todo-filtered)

(defcustom todo-filter-files nil
  "List of default files for multifile item filtering."
  :type `(set ,@(mapcar (lambda (f) (list 'const f))
			(mapcar 'todo-short-file-name
				(funcall todo-files-function))))
  :group 'todo-filtered)

(defcustom todo-filter-done-items nil
  "Non-nil to include done items when processing regexp filters.
Done items from corresponding archive files are also included."
  :type 'boolean
  :group 'todo-filtered)

(defun todo-set-top-priorities-in-file ()
  "Set number of top priorities for this file.
See `todo-set-top-priorities' for more details."
  (interactive)
  (todo-set-top-priorities))

(defun todo-set-top-priorities-in-category ()
  "Set number of top priorities for this category.
See `todo-set-top-priorities' for more details."
  (interactive)
  (todo-set-top-priorities t))

(defun todo-filter-top-priorities (&optional arg)
  "Display a list of top priority items from different categories.
The categories can be any of those in the current todo file.

With numerical prefix ARG show at most ARG top priority items
from each category.  With `C-u' as prefix argument show the
numbers of top priority items specified by category in
`todo-top-priorities-overrides', if this has an entry for the file(s);
otherwise show `todo-top-priorities' items per category in the
file(s).  With no prefix argument, if a top priorities file for
the current todo file has previously been saved (see
`todo-save-filtered-items-buffer'), visit this file; if there is
no such file, build the list as with prefix argument `C-u'.

  The prefix ARG regulates how many top priorities from
each category to show, as described above."
  (interactive "P")
  (todo-filter-items 'top arg))

(defun todo-filter-top-priorities-multifile (&optional arg)
  "Display a list of top priority items from different categories.
The categories are a subset of the categories in the files listed
in `todo-filter-files', or if this nil, in the files chosen from
a file selection dialog that pops up in this case.

With numerical prefix ARG show at most ARG top priority items
from each category in each file.  With `C-u' as prefix argument
show the numbers of top priority items specified in
`todo-top-priorities-overrides', if this is non-nil; otherwise show
`todo-top-priorities' items per category.  With no prefix
argument, if a top priorities file for the chosen todo files
exists (see `todo-save-filtered-items-buffer'), visit this file;
if there is no such file, do the same as with prefix argument
`C-u'."
  (interactive "P")
  (todo-filter-items 'top arg t))

(defun todo-filter-diary-items (&optional arg)
  "Display a list of todo diary items from different categories.
The categories can be any of those in the current todo file.

Called with no prefix ARG, if a diary items file for the current
todo file has previously been saved (see
`todo-save-filtered-items-buffer'), visit this file; if there is
no such file, build the list of diary items.  Called with a
prefix argument, build the list even if there is a saved file of
diary items."
  (interactive "P")
  (todo-filter-items 'diary arg))

(defun todo-filter-diary-items-multifile (&optional arg)
  "Display a list of todo diary items from different categories.
The categories are a subset of the categories in the files listed
in `todo-filter-files', or if this nil, in the files chosen from
a file selection dialog that pops up in this case.

Called with no prefix ARG, if a diary items file for the chosen
todo files has previously been saved (see
`todo-save-filtered-items-buffer'), visit this file; if there is
no such file, build the list of diary items.  Called with a
prefix argument, build the list even if there is a saved file of
diary items."
  (interactive "P")
  (todo-filter-items 'diary arg t))

(defun todo-filter-regexp-items (&optional arg)
  "Prompt for a regular expression and display items that match it.
The matches can be from any categories in the current todo file
and with non-nil option `todo-filter-done-items', can include
not only todo items but also done items, including those in
Archive files.

Called with no prefix ARG, if a regexp items file for the current
todo file has previously been saved (see
`todo-save-filtered-items-buffer'), visit this file; if there is
no such file, build the list of regexp items.  Called with a
prefix argument, build the list even if there is a saved file of
regexp items."
  (interactive "P")
  (todo-filter-items 'regexp arg))

(defun todo-filter-regexp-items-multifile (&optional arg)
  "Prompt for a regular expression and display items that match it.
The matches can be from any categories in the files listed in
`todo-filter-files', or if this nil, in the files chosen from a
file selection dialog that pops up in this case.  With non-nil
option `todo-filter-done-items', the matches can include not
only todo items but also done items, including those in Archive
files.

Called with no prefix ARG, if a regexp items file for the current
todo file has previously been saved (see
`todo-save-filtered-items-buffer'), visit this file; if there is
no such file, build the list of regexp items.  Called with a
prefix argument, build the list even if there is a saved file of
regexp items."
  (interactive "P")
  (todo-filter-items 'regexp arg t))

(defun todo-find-filtered-items-file ()
  "Choose a filtered items file and visit it."
  (interactive)
  (let ((files (directory-files todo-directory t "\.tod[rty]$" t))
	falist file)
    (dolist (f files)
      (let ((type (cond ((equal (file-name-extension f) "todr") "regexp")
			((equal (file-name-extension f) "todt") "top")
			((equal (file-name-extension f) "tody") "diary"))))
	(push (cons (concat (todo-short-file-name f) " (" type ")") f)
	      falist)))
    (setq file (completing-read "Choose a filtered items file: "
				falist nil t nil nil (car falist)))
    (setq file (cdr (assoc-string file falist)))
    (find-file file)
    (unless (derived-mode-p 'todo-filtered-items-mode)
      (todo-filtered-items-mode))
    (todo-prefix-overlays)))

(defun todo-go-to-source-item ()
  "Display the file and category of the filtered item at point."
  (interactive)
  (let* ((str (todo-item-string))
	 (buf (current-buffer))
	 (res (todo-find-item str))
	 (found (nth 0 res))
	 (file (nth 1 res))
	 (cat (nth 2 res)))
    (if (not found)
	(message "Category %s does not contain this item." cat)
      (kill-buffer buf)
      (set-window-buffer (selected-window)
			 (set-buffer (find-buffer-visiting file)))
      (setq todo-current-todo-file file)
      (setq todo-category-number (todo-category-number cat))
      (let ((todo-show-with-done (if (or todo-filter-done-items
					  (eq (cdr found) 'done))
				      t
				    todo-show-with-done)))
	(todo-category-select))
      (goto-char (car found)))))

(defvar todo-multiple-filter-files nil
  "List of files selected from `todo-multiple-filter-files' widget.")

(defvar todo-multiple-filter-files-widget nil
  "Variable holding widget created by `todo-multiple-filter-files'.")

(defun todo-multiple-filter-files ()
  "Pop to a buffer with a widget for choosing multiple filter files."
  (require 'widget)
  (eval-when-compile
    (require 'wid-edit))
  (with-current-buffer (get-buffer-create "*Todo Filter Files*")
    (pop-to-buffer (current-buffer))
    (erase-buffer)
    (kill-all-local-variables)
    (widget-insert "Select files for generating the top priorities list.\n\n")
    (setq todo-multiple-filter-files-widget
	  (widget-create
	   `(set ,@(mapcar (lambda (x) (list 'const x))
			   (mapcar 'todo-short-file-name
				   (funcall todo-files-function))))))
    (widget-insert "\n")
    (widget-create 'push-button
		   :notify (lambda (widget &rest ignore)
			     (setq todo-multiple-filter-files 'quit)
			     (quit-window t)
			     (exit-recursive-edit))
		   "Cancel")
    (widget-insert "   ")
    (widget-create 'push-button
		   :notify (lambda (&rest ignore)
			     (setq todo-multiple-filter-files
				   (mapcar (lambda (f)
					     (file-truename
					      (concat todo-directory
						      f ".todo")))
					   (widget-value
					    todo-multiple-filter-files-widget)))
			     (quit-window t)
			     (exit-recursive-edit))
		   "Apply")
    (use-local-map widget-keymap)
    (widget-setup))
  (message "Click \"Apply\" after selecting files.")
  (recursive-edit))

(defconst todo-filtered-items-buffer "Todo filtered items"
  "Initial name of buffer in Todo Filter Items mode.")

(defconst todo-top-priorities-buffer "Todo top priorities"
  "Buffer type string for `todo-filter-items'.")

(defconst todo-diary-items-buffer "Todo diary items"
  "Buffer type string for `todo-filter-items'.")

(defconst todo-regexp-items-buffer "Todo regexp items"
  "Buffer type string for `todo-filter-items'.")

(defun todo-filter-items (filter &optional new multifile)
  "Display a list of items filtered by FILTER.
The values of FILTER can be `top' for top priority items, a cons
of `top' and a number passed by the caller, `diary' for diary
items, or `regexp' for items matching a regular expression
entered by the user.  The items can come from any categories in
the current todo file or, with non-nil MULTIFILE, from several
files.  If NEW is nil, visit an appropriate file containing the
list of filtered items; if there is no such file, or with non-nil
NEW, build the list and display it.

See the documentation strings of the commands
`todo-filter-top-priorities', `todo-filter-diary-items',
`todo-filter-regexp-items', and those of the corresponding
multifile commands for further details."
  (let* ((top (eq filter 'top))
	 (diary (eq filter 'diary))
	 (regexp (eq filter 'regexp))
	 (buf (cond (top todo-top-priorities-buffer)
		    (diary todo-diary-items-buffer)
		    (regexp todo-regexp-items-buffer)))
	 (flist (if multifile
		    (or todo-filter-files
			(progn (todo-multiple-filter-files)
			       todo-multiple-filter-files))
		  (list todo-current-todo-file)))
	 (fname (if (equal flist 'quit)
		    ;; Pressed `cancel' in t-m-f-f file selection dialog.
		    (keyboard-quit)
		  (concat todo-directory
			  (mapconcat 'todo-short-file-name flist "-")
			  (cond (top ".todt")
				(diary ".tody")
				(regexp ".todr")))))
	 (multi (> (length flist) 1))
	 (rxfiles (when regexp
		    (directory-files todo-directory t ".*\\.todr$" t)))
	 (file-exists (or (file-exists-p fname) rxfiles))
	 bufname)
    (cond ((and top new (natnump new))
	   (todo-filter-items-1 (cons 'top new) flist))
	  ((and (not new) file-exists)
	   (when (and rxfiles (> (length rxfiles) 1))
	     (let ((rxf (mapcar 'todo-short-file-name rxfiles)))
	       (setq fname (todo-absolute-file-name
			    (completing-read "Choose a regexp items file: "
					     rxf) 'regexp))))
	   (find-file fname)
	   (unless (derived-mode-p 'todo-filtered-items-mode)
	     (todo-filtered-items-mode))
	   (todo-prefix-overlays)
	   (todo-check-filtered-items-file))
	  (t
	   (todo-filter-items-1 filter flist)))
    (dolist (s (split-string (todo-short-file-name fname) "-"))
      (setq bufname (if bufname
			(concat bufname (if (member s (mapcar
						       'todo-short-file-name
						       todo-files))
					    ", " "-") s)
		      s)))
    (rename-buffer (format (concat "%s for file" (if multi "s" "")
				   " \"%s\"") buf bufname))))

(defun todo-filter-items-1 (filter file-list)
  "Build a list of items by applying FILTER to FILE-LIST.
Internal subroutine called by `todo-filter-items', which passes
the values of FILTER and FILE-LIST."
  (let ((num (if (consp filter) (cdr filter) todo-top-priorities))
	(buf (get-buffer-create todo-filtered-items-buffer))
	(multifile (> (length file-list) 1))
	regexp fname bufstr cat beg end done)
    (if (null file-list)
	(user-error "No files have been chosen for filtering")
      (with-current-buffer buf
	(erase-buffer)
	(kill-all-local-variables)
	(todo-filtered-items-mode))
      (when (eq filter 'regexp)
	(setq regexp (read-string "Enter a regular expression: ")))
      (save-current-buffer
	(dolist (f file-list)
	  ;; Before inserting file contents into temp buffer, save a modified
	  ;; buffer visiting it.
	  (let ((bf (find-buffer-visiting f)))
	    (when (buffer-modified-p bf)
	      (with-current-buffer bf (save-buffer))))
	  (setq fname (todo-short-file-name f))
	  (with-temp-buffer
	    (when (and todo-filter-done-items (eq filter 'regexp))
	      ;; If there is a corresponding archive file for the
	      ;; todo file, insert it first and add identifiers for
	      ;; todo-go-to-source-item.
	      (let ((arch (concat (file-name-sans-extension f) ".toda")))
		(when (file-exists-p arch)
		  (insert-file-contents arch)
		  ;; Delete todo archive file's categories sexp.
		  (delete-region (line-beginning-position)
				 (1+ (line-end-position)))
		  (save-excursion
		    (while (not (eobp))
		      (when (re-search-forward
			     (concat (if todo-filter-done-items
					 (concat "\\(?:" todo-done-string-start
						 "\\|" todo-date-string-start
						 "\\)")
				       todo-date-string-start)
				     todo-date-pattern "\\(?: "
				     diary-time-regexp "\\)?"
				     (if todo-filter-done-items
					 "\\]"
				       (regexp-quote todo-nondiary-end)) "?")
			     nil t)
			(insert "(archive) "))
		      (forward-line))))))
	    (insert-file-contents f)
	    ;; Delete todo file's categories sexp.
	    (delete-region (line-beginning-position) (1+ (line-end-position)))
	    (let (fnum)
	      ;; Unless the number of top priorities to show was
	      ;; passed by the caller, the file-wide value from
	      ;; `todo-top-priorities-overrides', if non-nil, overrides
	      ;; `todo-top-priorities'.
	      (unless (consp filter)
		(setq fnum (or (nth 1 (assoc f todo-top-priorities-overrides))
			       todo-top-priorities)))
	      (while (re-search-forward
		      (concat "^" (regexp-quote todo-category-beg)
			      "\\(.+\\)\n") nil t)
		(setq cat (match-string 1))
		(let (cnum)
		  ;; Unless the number of top priorities to show was
		  ;; passed by the caller, the category-wide value
		  ;; from `todo-top-priorities-overrides', if non-nil,
		  ;; overrides a non-nil file-wide value from
		  ;; `todo-top-priorities-overrides' as well as
		  ;; `todo-top-priorities'.
		  (unless (consp filter)
		    (let ((cats (nth 2 (assoc f todo-top-priorities-overrides))))
		      (setq cnum (or (cdr (assoc cat cats)) fnum))))
		  (delete-region (match-beginning 0) (match-end 0))
		  (setq beg (point))	; First item in the current category.
		  (setq end (if (re-search-forward
				 (concat "^" (regexp-quote todo-category-beg))
				 nil t)
				(match-beginning 0)
			      (point-max)))
		  (goto-char beg)
		  (setq done
			(if (re-search-forward
			     (concat "\n" (regexp-quote todo-category-done))
			     end t)
			    (match-beginning 0)
			  end))
		  (unless (and todo-filter-done-items (eq filter 'regexp))
		    ;; Leave done items.
		    (delete-region done end)
		    (setq end done))
		  (narrow-to-region beg end)	; Process only current category.
		  (goto-char (point-min))
		  ;; Apply the filter.
		  (cond ((eq filter 'diary)
			 (while (not (eobp))
			   (if (looking-at (regexp-quote todo-nondiary-start))
			       (todo-remove-item)
			     (todo-forward-item))))
			((eq filter 'regexp)
			 (while (not (eobp))
			   (if (looking-at todo-item-start)
			       (if (string-match regexp (todo-item-string))
				   (todo-forward-item)
				 (todo-remove-item))
			     ;; Kill lines that aren't part of a todo or done
			     ;; item (empty or todo-category-done).
			     (delete-region (line-beginning-position)
					    (1+ (line-end-position))))
			   ;; If last todo item in file matches regexp and
			   ;; there are no following done items,
			   ;; todo-category-done string is left dangling,
			   ;; because todo-forward-item jumps over it.
			   (if (and (eobp)
				    (looking-back
				     (concat (regexp-quote todo-done-string)
					     "\n")))
			       (delete-region (point) (progn
							(forward-line -2)
							(point))))))
			(t ; Filter top priority items.
			 (setq num (or cnum fnum num))
			 (unless (zerop num)
			   (todo-forward-item num))))
		  (setq beg (point))
		  ;; Delete non-top-priority items.
		  (unless (member filter '(diary regexp))
		    (delete-region beg end))
		  (goto-char (point-min))
		  ;; Add file (if using multiple files) and category tags to
		  ;; item.
		  (while (not (eobp))
		    (when (re-search-forward
			   (concat (if todo-filter-done-items
				       (concat "\\(?:" todo-done-string-start
					       "\\|" todo-date-string-start
					       "\\)")
				     todo-date-string-start)
				   todo-date-pattern "\\(?: " diary-time-regexp
				   "\\)?" (if todo-filter-done-items
					      "\\]"
					    (regexp-quote todo-nondiary-end))
				   "?")
			   nil t)
		      (insert " [")
		      (when (looking-at "(archive) ") (goto-char (match-end 0)))
		      (insert (if multifile (concat fname ":") "") cat "]"))
		    (forward-line))
		  (widen)))
		(setq bufstr (buffer-string))
		(with-current-buffer buf
		  (let (buffer-read-only)
		    (insert bufstr)))))))
      (set-window-buffer (selected-window) (set-buffer buf))
      (todo-prefix-overlays)
      (goto-char (point-min)))))

(defun todo-set-top-priorities (&optional arg)
  "Set number of top priorities shown by `todo-filter-top-priorities'.
With non-nil ARG, set the number only for the current Todo
category; otherwise, set the number for all categories in the
current todo file.

Calling this function via either of the commands
`todo-set-top-priorities-in-file' or
`todo-set-top-priorities-in-category' is the recommended way to
set the user customizable option `todo-top-priorities-overrides'."
  (let* ((cat (todo-current-category))
	 (file todo-current-todo-file)
	 (rules todo-top-priorities-overrides)
	 (frule (assoc-string file rules))
	 (crules (nth 2 frule))
	 (crule (assoc-string cat crules))
	 (fcur (or (nth 1 frule)
		   todo-top-priorities))
	 (ccur (or (and arg (cdr crule))
		   fcur))
	 (prompt (if arg (concat "Number of top priorities in this category"
				 " (currently %d): ")
		   (concat "Default number of top priorities per category"
				 " in this file (currently %d): ")))
	 (new -1))
    (while (< new 0)
      (let ((cur (if arg ccur fcur)))
	(setq new (read-number (format prompt cur))
	      prompt "Enter a non-negative number: "
	      cur nil)))
    (let ((nrule (if arg
		     (append (delete crule crules) (list (cons cat new)))
		   (append (list file new) (list crules)))))
      (setq rules (cons (if arg
			    (list file fcur nrule)
			  nrule)
			(delete frule rules)))
      (customize-save-variable 'todo-top-priorities-overrides rules)
      (todo-prefix-overlays))))

(defun todo-find-item (str)
  "Search for filtered item STR in its saved todo file.
Return the list (FOUND FILE CAT), where CAT and FILE are the
item's category and file, and FOUND is a cons cell if the search
succeeds, whose car is the start of the item in FILE and whose
cdr is `done', if the item is now a done item, `changed', if its
text was truncated or augmented or, for a top priority item, if
its priority has changed, and `same' otherwise."
  (string-match (concat (if todo-filter-done-items
			    (concat "\\(?:" todo-done-string-start "\\|"
				    todo-date-string-start "\\)")
			  todo-date-string-start)
			todo-date-pattern "\\(?: " diary-time-regexp "\\)?"
			(if todo-filter-done-items
			    "\\]"
			  (regexp-quote todo-nondiary-end)) "?"
			"\\(?4: \\[\\(?3:(archive) \\)?\\(?2:.*:\\)?"
			"\\(?1:.*\\)\\]\\).*$") str)
  (let ((cat (match-string 1 str))
	(file (match-string 2 str))
	(archive (string= (match-string 3 str) "(archive) "))
	(filcat (match-string 4 str))
	(tpriority 1)
	(tpbuf (save-match-data (string-match "top" (buffer-name))))
	found)
    (setq str (replace-match "" nil nil str 4))
    (when tpbuf
      ;; Calculate priority of STR wrt its category.
      (save-excursion
	(while (search-backward filcat nil t)
	    (setq tpriority (1+ tpriority)))))
    (setq file (if file
		   (concat todo-directory (substring file 0 -1)
			   (if archive ".toda" ".todo"))
		 (if archive
		     (concat (file-name-sans-extension
			      todo-global-current-todo-file) ".toda")
		   todo-global-current-todo-file)))
    (find-file-noselect file)
    (with-current-buffer (find-buffer-visiting file)
      (if archive
	  (unless (derived-mode-p 'todo-archive-mode) (todo-archive-mode))
	(unless (derived-mode-p 'todo-mode) (todo-mode)))
      (save-restriction
	(widen)
	(goto-char (point-min))
	(let ((beg (re-search-forward
		    (concat "^" (regexp-quote (concat todo-category-beg cat))
			    "$")
		    nil t))
	      (done (save-excursion
		      (re-search-forward
		       (concat "^" (regexp-quote todo-category-done)) nil t)))
	      (end (save-excursion
		     (or (re-search-forward
			  (concat "^" (regexp-quote todo-category-beg))
			  nil t)
			 (point-max)))))
	  (setq found (when (search-forward str end t)
			(goto-char (match-beginning 0))))
	  (when found
	    (setq found
		  (cons found (if (> (point) done)
				  'done
				(let ((cpriority 1))
				  (when tpbuf
				    (save-excursion
				      ;; Not top item in category.
				      (while (> (point) (1+ beg))
					(let ((opoint (point)))
					  (todo-backward-item)
					  ;; Can't move backward beyond
					  ;; first item in file.
					  (unless (= (point) opoint)
					    (setq cpriority (1+ cpriority)))))))
				  (if (and (= tpriority cpriority)
					   ;; Proper substring is not the same.
					   (string= (todo-item-string)
						    str))
				      'same
				    'changed)))))))))
      (list found file cat)))

(defun todo-check-filtered-items-file ()
  "Check if filtered items file is up to date and a show suitable message."
  ;; (catch 'old
  (let ((count 0))
    (while (not (eobp))
      (let* ((item (todo-item-string))
	     (found (car (todo-find-item item))))
	(unless (eq (cdr found) 'same)
	  (save-excursion
	    (overlay-put (make-overlay (todo-item-start) (todo-item-end))
			 'face 'todo-search))
	  (setq count (1+ count))))
	  ;; (throw 'old (message "The marked item is not up to date.")))
      (todo-forward-item))
    (if (zerop count)
	(message "Filtered items file is up to date.")
      (message (concat "The highlighted item" (if (= count 1) " is " "s are ")
		       "not up to date."
		       ;; "\nType <return> on item for details."
		       )))))

(defun todo-filter-items-filename ()
  "Return absolute file name for saving this Filtered Items buffer."
  (let ((bufname (buffer-name)))
    (string-match "\"\\([^\"]+\\)\"" bufname)
    (let* ((filename-str (substring bufname (match-beginning 1) (match-end 1)))
	   (filename-base (replace-regexp-in-string ", " "-" filename-str))
	   (top-priorities (string-match "top priorities" bufname))
	   (diary-items (string-match "diary items" bufname))
	   (regexp-items (string-match "regexp items" bufname)))
      (when regexp-items
	(let ((prompt (concat "Enter a short identifying string"
			      " to make this file name unique: ")))
	  (setq filename-base (concat filename-base "-" (read-string prompt)))))
      (concat todo-directory filename-base
	      (cond (top-priorities ".todt")
		    (diary-items ".tody")
		    (regexp-items ".todr"))))))

(defun todo-save-filtered-items-buffer ()
  "Save current Filtered Items buffer to a file.
If the file already exists, overwrite it only on confirmation."
  (let ((filename (or (buffer-file-name) (todo-filter-items-filename))))
    (write-file filename t)))

;; -----------------------------------------------------------------------------
;;; Printing Todo mode buffers
;; -----------------------------------------------------------------------------

(defcustom todo-print-buffer-function 'ps-print-buffer-with-faces
  "Function called by the command `todo-print-buffer'."
  :type 'symbol
  :group 'todo)

(defvar todo-print-buffer "*Todo Print*"
  "Name of buffer with printable version of Todo mode buffer.")

(defun todo-print-buffer (&optional to-file)
  "Produce a printable version of the current Todo mode buffer.
This converts overlays and soft line wrapping and, depending on
the value of `todo-print-buffer-function', includes faces.  With
non-nil argument TO-FILE write the printable version to a file;
otherwise, send it to the default printer."
  (interactive)
  (let ((buf todo-print-buffer)
	(header (cond
		 ((eq major-mode 'todo-mode)
		  (concat "Todo File: "
			  (todo-short-file-name todo-current-todo-file)
			  "\nCategory: " (todo-current-category)))
		 ((eq major-mode 'todo-filtered-items-mode)
		  (buffer-name))))
	(prefix (propertize (concat todo-prefix " ")
			    'face 'todo-prefix-string))
	(num 0)
	(fill-prefix (make-string todo-indent-to-here 32))
	(content (buffer-string))
	file)
    (with-current-buffer (get-buffer-create buf)
      (insert content)
      (goto-char (point-min))
      (while (not (eobp))
	(let ((beg (point))
	      (end (save-excursion (todo-item-end))))
	  (when todo-number-prefix
	    (setq num (1+ num))
	    (setq prefix (propertize (concat (number-to-string num) " ")
				     'face 'todo-prefix-string)))
	  (insert prefix)
	  (fill-region beg end))
	;; Calling todo-forward-item infloops at todo-item-start due to
	;; non-overlay prefix, so search for item start instead.
	(if (re-search-forward todo-item-start nil t)
	    (beginning-of-line)
	  (goto-char (point-max))))
      (if (re-search-backward (concat "^" (regexp-quote todo-category-done))
			      nil t)
	  (replace-match todo-done-separator))
      (goto-char (point-min))
      (insert header)
      (newline 2)
      (if to-file
	  (let ((file (read-file-name "Print to file: ")))
	    (funcall todo-print-buffer-function file))
	(funcall todo-print-buffer-function)))
    (kill-buffer buf)))

(defun todo-print-buffer-to-file ()
  "Save printable version of this Todo mode buffer to a file."
  (interactive)
  (todo-print-buffer t))

;; -----------------------------------------------------------------------------
;;; Legacy Todo mode files
;; -----------------------------------------------------------------------------

(defcustom todo-legacy-date-time-regexp
  (concat "\\(?1:[0-9]\\{4\\}\\)-\\(?2:[0-9]\\{2\\}\\)-"
	  "\\(?3:[0-9]\\{2\\}\\) \\(?4:[0-9]\\{2\\}:[0-9]\\{2\\}\\)")
  "Regexp matching legacy todo-mode.el item date-time strings.
In order for `todo-convert-legacy-files' to correctly convert
this string to the current Todo mode format, the regexp must
contain four explicitly numbered groups (see `(elisp) Regexp
Backslash'), where group 1 matches a string for the year, group 2
a string for the month, group 3 a string for the day and group 4
a string for the time.  The default value converts date-time
strings built using the default value of
`todo-time-string-format' from todo-mode.el."
  :type 'regexp
  :group 'todo)

(defun todo-convert-legacy-date-time ()
  "Return converted date-time string.
Helper function for `todo-convert-legacy-files'."
  (let* ((year (match-string 1))
	 (month (match-string 2))
	 (monthname (calendar-month-name (string-to-number month) t))
	 (day (match-string 3))
	 (time (match-string 4))
	 dayname)
    (replace-match "")
    (insert (mapconcat 'eval calendar-date-display-form "")
	    (when time (concat " " time)))))

(defun todo-convert-legacy-files ()
  "Convert legacy todo files to the current Todo mode format.
The old-style files named by the variables `todo-file-do' and
`todo-file-done' from the old package are converted to the new
format and saved (the latter as a todo archive file) with a new
name in `todo-directory'.  See also the documentation string of
`todo-legacy-date-time-regexp' for further details."
  (interactive)
  ;; If there are user customizations of legacy options, use them,
  ;; otherwise use the legacy default values.
  (let ((todo-file-do-tem (if (boundp 'todo-file-do)
			      todo-file-do
			    (locate-user-emacs-file "todo-do" ".todo-do")))
	(todo-file-done-tem (if (boundp 'todo-file-done)
				todo-file-done
			      (locate-user-emacs-file "todo-done" ".todo-done")))
	(todo-initials-tem (and (boundp 'todo-initials) todo-initials))
	(todo-entry-prefix-function-tem (and (boundp 'todo-entry-prefix-function)
					     todo-entry-prefix-function))
	todo-prefix-tem)
    ;; Convert `todo-file-do'.
    (if (not (file-exists-p todo-file-do-tem))
	(message "No legacy todo file exists")
      (let ((default "todo-do-conv")
	    file archive-sexp)
	(with-temp-buffer
	  (insert-file-contents todo-file-do-tem)
	  ;; Eliminate old-style local variables list in first line.
	  (delete-region (line-beginning-position) (1+ (line-end-position)))
	  (search-forward " --- " nil t) ; Legacy todo-category-beg.
	  (setq todo-prefix-tem (buffer-substring-no-properties
				 (line-beginning-position) (match-beginning 0)))
	  (goto-char (point-min))
	  (while (not (eobp))
	    (cond
	     ;; Old-style category start delimiter.
	     ((looking-at (regexp-quote (concat todo-prefix-tem " --- ")))
	      (replace-match todo-category-beg))
	     ;; Old-style category end delimiter.
	     ((looking-at (regexp-quote "--- End"))
	      (replace-match ""))
	     ;; Old-style category separator.
	     ((looking-at (regexp-quote
			   (concat todo-prefix-tem " "
				   (make-string 75 ?-))))
	      (replace-match todo-category-done))
	     ;; Old-style item header (date/time/initials).
	     ((looking-at (concat (regexp-quote todo-prefix-tem) " "
				  (if todo-entry-prefix-function-tem
				      (funcall todo-entry-prefix-function-tem)
				    (concat todo-legacy-date-time-regexp " "
					    (if todo-initials-tem
						(regexp-quote todo-initials-tem)
					      "[^:]*")
					    ":"))))
	      (todo-convert-legacy-date-time)))
	    (forward-line))
	  (setq file (concat todo-directory
			     (read-string
			      (format "Save file as (default \"%s\"): " default)
			      nil nil default)
			     ".todo"))
	  (unless (file-exists-p todo-directory)
	    (make-directory todo-directory))
	  (write-region (point-min) (point-max) file nil 'nomessage nil t))
	(with-temp-buffer
	  (insert-file-contents file)
	  (let ((todo-categories (todo-make-categories-list t)))
	    (todo-update-categories-sexp)
	    (todo-check-format))
	  (write-region (point-min) (point-max) file nil 'nomessage))
	(setq todo-files (funcall todo-files-function))
	;; Convert `todo-file-done'.
	(when (file-exists-p todo-file-done-tem)
	  (with-temp-buffer
	    (insert-file-contents todo-file-done-tem)
	    (let ((beg (make-marker))
		  (end (make-marker))
		  cat cats comment item)
	      (while (not (eobp))
		(when (looking-at todo-legacy-date-time-regexp)
		  (set-marker beg (point))
		  (todo-convert-legacy-date-time)
		  (set-marker end (point))
		  (goto-char beg)
		  (insert "[" todo-done-string)
		  (goto-char end)
		  (insert "]")
		  (forward-char)
		  (when (looking-at todo-legacy-date-time-regexp)
		    (todo-convert-legacy-date-time))
		  (when (looking-at (concat " " (if todo-initials-tem
						    (regexp-quote
						     todo-initials-tem)
						  "[^:]*")
					    ":"))
		    (replace-match "")))
		(if (re-search-forward
		     (concat "^" todo-legacy-date-time-regexp) nil t)
		    (goto-char (match-beginning 0))
		  (goto-char (point-max)))
		(backward-char)
		(when (looking-back "\\[\\([^][]+\\)\\]")
		  (setq cat (match-string 1))
		  (goto-char (match-beginning 0))
		  (replace-match ""))
		;; If the item ends with a non-comment parenthesis not
		;; followed by a period, we lose (but we inherit that
		;; problem from the legacy code).
		(when (looking-back "(\\(.*\\)) ")
		  (setq comment (match-string 1))
		  (replace-match "")
		  (insert "[" todo-comment-string ": " comment "]"))
		(set-marker end (point))
		(if (member cat cats)
		    ;; If item is already in its category, leave it there.
		    (unless (save-excursion
			      (re-search-backward
			       (concat "^" (regexp-quote todo-category-beg)
				       "\\(.*\\)$") nil t)
			      (string= (match-string 1) cat))
		      ;; Else move it to its category.
		      (setq item (buffer-substring-no-properties beg end))
		      (delete-region beg (1+ end))
		      (set-marker beg (point))
		      (re-search-backward
		       (concat "^"
			       (regexp-quote (concat todo-category-beg cat))
			       "$")
		       nil t)
		      (forward-line)
		      (if (re-search-forward
			   (concat "^" (regexp-quote todo-category-beg)
				   "\\(.*\\)$") nil t)
			  (progn (goto-char (match-beginning 0))
				 (newline)
				 (forward-line -1))
			(goto-char (point-max)))
		      (insert item "\n")
		      (goto-char beg))
		  (push cat cats)
		  (goto-char beg)
		  (insert todo-category-beg cat "\n\n"
			  todo-category-done "\n"))
		(forward-line))
	      (set-marker beg nil)
	      (set-marker end nil))
	    (setq file (concat (file-name-sans-extension file) ".toda"))
	    (write-region (point-min) (point-max) file nil 'nomessage nil t))
	  (with-temp-buffer
	    (insert-file-contents file)
	    (let* ((todo-categories (todo-make-categories-list t)))
	      (todo-update-categories-sexp)
	      (todo-check-format))
	    (write-region (point-min) (point-max) file nil 'nomessage)
	    (setq archive-sexp (read (buffer-substring-no-properties
				      (line-beginning-position)
				      (line-end-position)))))
	  (setq file (concat (file-name-sans-extension file) ".todo"))
	  ;; Update categories sexp of converted todo file again, adding
	  ;; counts of archived items.
	  (with-temp-buffer
	    (insert-file-contents file)
	    (let ((sexp (read (buffer-substring-no-properties
			       (line-beginning-position)
			       (line-end-position)))))
	      (dolist (cat sexp)
		(let ((archive-cat (assoc (car cat) archive-sexp)))
		  (if archive-cat
		      (aset (cdr cat) 3 (aref (cdr archive-cat) 2)))))
	      (delete-region (line-beginning-position) (line-end-position))
	      (prin1 sexp (current-buffer)))
	    (write-region (point-min) (point-max) file nil 'nomessage))
	  (setq todo-archives (funcall todo-files-function t)))
	(todo-reevaluate-filelist-defcustoms)
	(when (y-or-n-p (concat "Format conversion done; do you want to "
				"visit the converted file now? "))
	  (setq todo-current-todo-file file)
	  (unless todo-default-todo-file
	    ;; We just initialized the first todo file, so make it the
	    ;; default now to avoid an infinite recursion with todo-show.
	    (setq todo-default-todo-file (todo-short-file-name file)))
	  (todo-show))))))

;; -----------------------------------------------------------------------------
;;; Utility functions for todo files, categories and items
;; -----------------------------------------------------------------------------

(defun todo-absolute-file-name (name &optional type)
  "Return the absolute file name of short todo file NAME.
With TYPE `archive' or `top' return the absolute file name of the
short todo archive or top priorities file name, respectively."
  ;; No-op if there is no todo file yet (i.e. don't concatenate nil).
  (when name
    (file-truename
     (concat todo-directory name
	     (cond ((eq type 'archive) ".toda")
		   ((eq type 'top) ".todt")
		   ((eq type 'diary) ".tody")
		   ((eq type 'regexp) ".todr")
		   (t ".todo"))))))

(defun todo-check-file (file)
  "Check the state associated with FILE and update it if necessary.
If FILE exists, return t.  If it does not exist and there is no
live buffer with its content, return nil; if there is such a
buffer and the user tries to show it, ask whether to restore
FILE, and if confirmed, do so and return t; else delete the
buffer, clean up the state and return nil."
  (setq todo-files (funcall todo-files-function))
  (setq todo-archives (funcall todo-files-function t))
  (if (file-exists-p file)
      t
    (setq todo-visited (delete file todo-visited))
    (let ((buf (find-buffer-visiting file)))
      (if (and buf
	       (y-or-n-p
		(concat
		 (format (concat "Todo file \"%s\" has been deleted but "
				 "its content is still in a buffer!\n")
			 (todo-short-file-name file))
		 "Save that buffer and restore the todo file? ")))
	  (progn
	    (with-current-buffer buf (save-buffer))
	    (setq todo-files (funcall todo-files-function))
	    (setq todo-archives (funcall todo-files-function t))
	    t)
	(let* ((files (append todo-files todo-archives))
	       (tctf todo-current-todo-file)
	       (tgctf todo-global-current-todo-file)
	       (tdtf (todo-absolute-file-name todo-default-todo-file)))
	  (unless (or (not todo-current-todo-file)
		      (member todo-current-todo-file files))
	    (setq todo-current-todo-file nil))
	  (unless (or (not todo-global-current-todo-file)
		      (member todo-global-current-todo-file files))
	    (setq todo-global-current-todo-file nil))
	  (unless (or (not todo-default-todo-file)
		      (member todo-default-todo-file files))
	    (setq todo-default-todo-file (todo-short-file-name
					  (car todo-files))))
	  (todo-reevaluate-filelist-defcustoms)
	  (when buf (kill-buffer buf))
	  nil)))))

(defun todo-category-number (cat)
  "Return the number of category CAT in this todo file.
The buffer-local variable `todo-category-number' holds this
number as its value."
  (let ((categories (mapcar 'car todo-categories)))
    (setq todo-category-number
	  ;; Increment by one, so that the number of the first
	  ;; category is one rather than zero.
	  (1+ (- (length categories)
		 (length (member cat categories)))))))

(defun todo-current-category ()
  "Return the name of the current category."
  (car (nth (1- todo-category-number) todo-categories)))

(defun todo-category-select ()
  "Display the current category correctly."
  (let ((name (todo-current-category))
	cat-begin cat-end done-start done-sep-start done-end)
    (widen)
    (goto-char (point-min))
    (re-search-forward
     (concat "^" (regexp-quote (concat todo-category-beg name)) "$") nil t)
    (setq cat-begin (1+ (line-end-position)))
    (setq cat-end (if (re-search-forward
		       (concat "^" (regexp-quote todo-category-beg)) nil t)
		      (match-beginning 0)
		    (point-max)))
    (setq mode-line-buffer-identification
	  (funcall todo-mode-line-function name))
    (narrow-to-region cat-begin cat-end)
    (todo-prefix-overlays)
    (goto-char (point-min))
    (if (re-search-forward (concat "\n\\(" (regexp-quote todo-category-done)
				   "\\)") nil t)
	(progn
	  (setq done-start (match-beginning 0))
	  (setq done-sep-start (match-beginning 1))
	  (setq done-end (match-end 0)))
      (error "Category %s is missing todo-category-done string" name))
    (if todo-show-done-only
	(narrow-to-region (1+ done-end) (point-max))
      (when (and todo-show-with-done
		 (re-search-forward todo-done-string-start nil t))
	;; Now we want to see the done items, so reset displayed end to end of
	;; done items.
	(setq done-start cat-end)
	;; Make display overlay for done items separator string, unless there
	;; already is one.
	(let* ((done-sep todo-done-separator)
	       (ov (progn (goto-char done-sep-start)
			  (todo-get-overlay 'separator))))
	  (unless ov
	    (setq ov (make-overlay done-sep-start done-end))
	    (overlay-put ov 'todo 'separator)
	    (overlay-put ov 'display done-sep))))
      (narrow-to-region (point-min) done-start)
      ;; Loading this from todo-mode, or adding it to the mode hook, causes
      ;; Emacs to hang in todo-item-start, at (looking-at todo-item-start).
      (when todo-highlight-item
	(require 'hl-line)
	(hl-line-mode 1)))))

(defun todo-get-count (type &optional category)
  "Return count of TYPE items in CATEGORY.
If CATEGORY is nil, default to the current category."
  (let* ((cat (or category (todo-current-category)))
	 (counts (cdr (assoc cat todo-categories)))
	 (idx (cond ((eq type 'todo) 0)
		    ((eq type 'diary) 1)
		    ((eq type 'done) 2)
		    ((eq type 'archived) 3))))
    (aref counts idx)))

(defun todo-update-count (type increment &optional category)
  "Change count of TYPE items in CATEGORY by integer INCREMENT.
With nil or omitted CATEGORY, default to the current category."
  (let* ((cat (or category (todo-current-category)))
	 (counts (cdr (assoc cat todo-categories)))
	 (idx (cond ((eq type 'todo) 0)
		    ((eq type 'diary) 1)
		    ((eq type 'done) 2)
		    ((eq type 'archived) 3))))
    (aset counts idx (+ increment (aref counts idx)))))

(defun todo-set-categories ()
  "Set `todo-categories' from the sexp at the top of the file."
  ;; New archive files created by `todo-move-category' are empty, which would
  ;; make the sexp test fail and raise an error, so in this case we skip it.
  (unless (zerop (buffer-size))
    (save-excursion
      (save-restriction
	(widen)
	(goto-char (point-min))
	(setq todo-categories
	      (if (looking-at "\(\(\"")
		  (read (buffer-substring-no-properties
			 (line-beginning-position)
			 (line-end-position)))
		(error "Invalid or missing todo-categories sexp")))))))

(defun todo-update-categories-sexp ()
  "Update the `todo-categories' sexp at the top of the file."
  (let (buffer-read-only)
    (save-excursion
      (save-restriction
	(widen)
	(goto-char (point-min))
	(if (looking-at (concat "^" (regexp-quote todo-category-beg)))
	    (progn (newline) (goto-char (point-min)) ; Make space for sexp.
		   (setq todo-categories (todo-make-categories-list t)))
	  (delete-region (line-beginning-position) (line-end-position)))
	(prin1 todo-categories (current-buffer))))))

(defun todo-make-categories-list (&optional force)
  "Return an alist of todo categories and their item counts.
With non-nil argument FORCE parse the entire file to build the
list; otherwise, get the value by reading the sexp at the top of
the file."
  (setq todo-categories nil)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let (counts cat archive)
	;; If the file is a todo file and has archived items, identify the
	;; archive, in order to count its items.  But skip this with
	;; `todo-convert-legacy-files', since that converts filed items to
	;; archived items.
	(when buffer-file-name	 ; During conversion there is no file yet.
	  ;; If the file is an archive, it doesn't have an archive.
	  (unless (member (file-truename buffer-file-name)
			  (funcall todo-files-function t))
	    (setq archive (concat (file-name-sans-extension
				   todo-current-todo-file) ".toda"))))
	(while (not (eobp))
	  (cond ((looking-at (concat (regexp-quote todo-category-beg)
				     "\\(.*\\)\n"))
		 (setq cat (match-string-no-properties 1))
		 ;; Counts for each category: [todo diary done archive]
		 (setq counts (make-vector 4 0))
		 (setq todo-categories
		       (append todo-categories (list (cons cat counts))))
		 ;; Add archived item count to the todo file item counts.
		 ;; Make sure to include newly created archives, e.g. due to
		 ;; todo-move-category.
		 (when (member archive (funcall todo-files-function t))
		   (let ((archive-count 0)
			 (visiting (find-buffer-visiting archive)))
		     (with-current-buffer (or visiting
					      (find-file-noselect archive))
		       (save-excursion
			 (save-restriction
			   (widen)
			   (goto-char (point-min))
			   (when (re-search-forward
				  (concat "^" (regexp-quote todo-category-beg)
					  cat "$")
				  (point-max) t)
			     (forward-line)
			     (while (not (or (looking-at
					      (concat
					       (regexp-quote todo-category-beg)
					       "\\(.*\\)\n"))
					     (eobp)))
			       (when (looking-at todo-done-string-start)
				 (setq archive-count (1+ archive-count)))
			       (forward-line)))))
		       (unless visiting (kill-buffer)))
		     (todo-update-count 'archived archive-count cat))))
		((looking-at todo-done-string-start)
		 (todo-update-count 'done 1 cat))
		((looking-at (concat "^\\("
				     (regexp-quote diary-nonmarking-symbol)
				     "\\)?" todo-date-pattern))
		 (todo-update-count 'diary 1 cat)
		 (todo-update-count 'todo 1 cat))
		((looking-at (concat todo-date-string-start todo-date-pattern))
		 (todo-update-count 'todo 1 cat))
		;; If first line is todo-categories list, use it and end loop
		;; -- unless FORCEd to scan whole file.
		((bobp)
		 (unless force
		   (setq todo-categories (read (buffer-substring-no-properties
						 (line-beginning-position)
						 (line-end-position))))
		   (goto-char (1- (point-max))))))
	  (forward-line)))))
  todo-categories)

(defun todo-repair-categories-sexp ()
  "Repair corrupt todo file categories sexp.
This should only be needed as a consequence of careless manual
editing or a bug in todo.el.

*Warning*: Calling this command restores the category order to
the list element order in the todo file categories sexp, so any
order changes made in Todo Categories mode will have to be made
again."
  (interactive)
  (let ((todo-categories (todo-make-categories-list t)))
    (todo-update-categories-sexp)))

(defun todo-check-format ()
  "Signal an error if the current todo file is ill-formatted.
Otherwise return t.  Display a message if the file is well-formed
but the categories sexp differs from the current value of
`todo-categories'."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let* ((cats (prin1-to-string todo-categories))
	     (ssexp (buffer-substring-no-properties (line-beginning-position)
						    (line-end-position)))
	     (sexp (read ssexp)))
	;; Check the first line for `todo-categories' sexp.
	(dolist (c sexp)
	  (let ((v (cdr c)))
	    (unless (and (stringp (car c))
			 (vectorp v)
			 (= 4 (length v)))
	      (user-error "Invalid or missing todo-categories sexp"))))
	(forward-line)
	;; Check well-formedness of categories.
	(let ((legit (concat
		      "\\(^" (regexp-quote todo-category-beg) "\\)"
		      "\\|\\(" todo-date-string-start todo-date-pattern "\\)"
		      "\\|\\(^[ \t]+[^ \t]*\\)"
		      "\\|^$"
		      "\\|\\(^" (regexp-quote todo-category-done) "\\)"
		      "\\|\\(" todo-done-string-start "\\)")))
	  (while (not (eobp))
	    (unless (looking-at legit)
	      (user-error "Illegitimate todo file format at line %d"
		     (line-number-at-pos (point))))
	    (forward-line)))
	;; Warn user if categories sexp has changed.
	(unless (string= ssexp cats)
	  (message (concat "The sexp at the beginning of the file differs "
			   "from the value of `todo-categories.\n"
			   "If the sexp is wrong, you can fix it with "
			   "M-x todo-repair-categories-sexp,\n"
			   "but note this reverts any changes you have "
			   "made in the order of the categories."))))))
  t)

(defun todo-item-start ()
  "Move to start of current todo item and return its position."
  (unless (or
	   ;; Buffer is empty (invocation possible e.g. via todo-forward-item
	   ;; from todo-filter-items when processing category with no todo
	   ;; items).
	   (eq (point-min) (point-max))
	   ;; Point is on the empty line below category's last todo item...
	   (and (looking-at "^$")
		(or (eobp)		; ...and done items are hidden...
		    (save-excursion	; ...or done items are visible.
		      (forward-line)
		      (looking-at (concat "^"
					  (regexp-quote todo-category-done))))))
	   ;; Buffer is widened.
	   (looking-at (regexp-quote todo-category-beg)))
    (goto-char (line-beginning-position))
    (while (not (looking-at todo-item-start))
      (forward-line -1))
    (point)))

(defun todo-item-end ()
  "Move to end of current todo item and return its position."
  ;; Items cannot end with a blank line.
  (unless (looking-at "^$")
    (let* ((done (todo-done-item-p))
	   (to-lim nil)
	   ;; For todo items, end is before the done items section, for done
	   ;; items, end is before the next category.  If these limits are
	   ;; missing or inaccessible, end it before the end of the buffer.
	   (lim (if (save-excursion
		      (re-search-forward
		       (concat "^" (regexp-quote (if done
						     todo-category-beg
						   todo-category-done)))
		       nil t))
		    (progn (setq to-lim t) (match-beginning 0))
		  (point-max))))
      (when (bolp) (forward-char))	; Find start of next item.
      (goto-char (if (re-search-forward todo-item-start lim t)
		     (match-beginning 0)
		   (if to-lim lim (point-max))))
      ;; For last todo item, skip back over the empty line before the done
      ;; items section, else just back to the end of the previous line.
      (backward-char (when (and to-lim (not done) (eq (point) lim)) 2))
      (point))))

(defun todo-item-string ()
  "Return bare text of current item as a string."
  (let ((opoint (point))
	(start (todo-item-start))
	(end (todo-item-end)))
    (goto-char opoint)
    (and start end (buffer-substring-no-properties start end))))

(defun todo-forward-item (&optional count)
  "Move point COUNT items down (by default, move down by one item)."
  (let* ((not-done (not (or (todo-done-item-p) (looking-at "^$"))))
	 (start (line-end-position)))
    (goto-char start)
    (if (re-search-forward todo-item-start nil t (or count 1))
	(goto-char (match-beginning 0))
      (goto-char (point-max)))
    ;; If points advances by one from a todo to a done item, go back
    ;; to the space above todo-done-separator, since that is a
    ;; legitimate place to insert an item.  But skip this space if
    ;; count > 1, since that should only stop on an item.
    (when (and not-done (todo-done-item-p) (not count))
      ;; (if (or (not count) (= count 1))
	  (re-search-backward "^$" start t))));)
    ;; The preceding sexp is insufficient when buffer is not narrowed,
    ;; since there could be no done items in this category, so the
    ;; search puts us on first todo item of next category.  Does this
    ;; ever happen?  If so:
    ;; (let ((opoint) (point))
    ;;   (forward-line -1)
    ;;   (when (or (not count) (= count 1))
    ;; 	(cond ((looking-at (concat "^" (regexp-quote todo-category-beg)))
    ;; 	       (forward-line -2))
    ;; 	      ((looking-at (concat "^" (regexp-quote todo-category-done)))
    ;; 	       (forward-line -1))
    ;; 	      (t
    ;; 	       (goto-char opoint)))))))

(defun todo-backward-item (&optional count)
  "Move point up to start of item with next higher priority.
With positive numerical prefix COUNT, move point COUNT items
upward.

If the category's done items are visible, this command called
with a prefix argument only moves point to a higher item, e.g.,
with point on the first done item and called with prefix 1, it
moves to the last todo item; but if called with point on the
first done item without a prefix argument, it moves point the the
empty line above the done items separator."
  (let* ((done (todo-done-item-p)))
    (todo-item-start)
    (unless (bobp)
      (re-search-backward todo-item-start nil t (or count 1)))
    ;; Unless this is a regexp filtered items buffer (which can contain
    ;; intermixed todo and done items), if points advances by one from a
    ;; done to a todo item, go back to the space above
    ;; todo-done-separator, since that is a legitimate place to insert an
    ;; item.  But skip this space if count > 1, since that should only
    ;; stop on an item.
    (when (and done (not (todo-done-item-p)) (not count)
				    ;(or (not count) (= count 1))
	       (not (equal (buffer-name) todo-regexp-items-buffer)))
      (re-search-forward (concat "^" (regexp-quote todo-category-done))
			 nil t)
      (forward-line -1))))

(defun todo-remove-item ()
  "Internal function called in editing, deleting or moving items."
  (let* ((end (progn (todo-item-end) (1+ (point))))
	 (beg (todo-item-start))
	 (ov (todo-get-overlay 'prefix)))
    (when ov (delete-overlay ov))
    (delete-region beg end)))

(defun todo-diary-item-p ()
  "Return non-nil if item at point has diary entry format."
  (save-excursion
    (when (todo-item-string)		; Exclude empty lines.
      (todo-item-start)
      (not (looking-at (regexp-quote todo-nondiary-start))))))

;; This duplicates the item locating code from diary-goto-entry, but
;; without the marker code, to test whether the latter is dispensable.
;; If it is, diary-goto-entry can be simplified.  The code duplication
;; here can also be eliminated, leaving only the widening and category
;; selection, and instead of :override advice :around can be used.

(defun todo-diary-goto-entry (button)
  "Jump to the diary entry for the BUTTON at point.
If the entry is a todo item, display its category properly.
Overrides `diary-goto-entry'."
  ;; Locate the diary item in its source file.
  (let* ((locator (button-get button 'locator))
	 (file (cadr locator))
	 (date (regexp-quote (nth 2 locator)))
	 (content (regexp-quote (nth 3 locator))))
    (if (not (and (file-exists-p file)
		  (find-file-other-window file)))
	(message "Unable to locate this diary entry")
      ;; If it's a Todo file, make sure it's in Todo mode.
      (when (and (equal (file-name-directory (file-truename file))
			(file-truename todo-directory))
		 (not (derived-mode-p 'todo-mode)))
	(todo-mode))
      (when (eq major-mode 'todo-mode) (widen))
      (goto-char (point-min))
      (when (re-search-forward (format "%s.*\\(%s\\)" date content) nil t)
	(goto-char (match-beginning 1)))
      ;; If it's a todo item, determine its category and display the
      ;; category properly.
      (when (eq major-mode 'todo-mode)
	(let ((opoint (point)))
	  (re-search-backward (concat "^" (regexp-quote todo-category-beg)
				      "\\(.*\\)\n") nil t)
	  (todo-category-number (match-string 1))
	  (todo-category-select)
	  (goto-char opoint))))))

(add-function :override diary-goto-entry-function #'todo-diary-goto-entry)

(defun todo-desktop-save-buffer (_dir)
  `((catnum . ,(todo-category-number (todo-current-category)))))

(declare-function desktop-restore-file-buffer "desktop"
                  (buffer-filename buffer-name buffer-misc))

(defun todo-restore-desktop-buffer (file buffer misc)
  (desktop-restore-file-buffer file buffer misc)
  (with-current-buffer buffer
    (widen)
    (let ((todo-category-number (cdr (assq 'catnum misc))))
      (todo-category-select))))

(add-to-list 'desktop-buffer-mode-handlers
	     '(todo-mode . todo-restore-desktop-buffer))

(defun todo-done-item-p ()
  "Return non-nil if item at point is a done item."
  (save-excursion
    (todo-item-start)
    (looking-at todo-done-string-start)))

(defun todo-done-item-section-p ()
  "Return non-nil if point is in category's done items section."
  (save-excursion
    (or (re-search-backward (concat "^" (regexp-quote todo-category-done))
			    nil t)
	(progn (goto-char (point-min))
	       (looking-at todo-done-string-start)))))

(defun todo--user-error-if-marked-done-item ()
  "Signal user error on marked done items.
Helper function for editing commands that apply only to (possibly
marked) not done todo items."
  (save-excursion
    (save-restriction
      (goto-char (point-max))
      (todo-backward-item)
      (unless (todo-done-item-p)
	(widen)
	(unless (re-search-forward
		 (concat "^" (regexp-quote todo-category-beg)) nil t)
	  (goto-char (point-max)))
	(forward-line -1))
      (while (todo-done-item-p)
	(when (todo-marked-item-p)
	  (user-error "This command does not apply to done items"))
	(todo-backward-item)))))

(defun todo-reset-done-separator (sep)
  "Replace existing overlays of done items separator string SEP."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (while (re-search-forward
	      (concat "\n\\(" (regexp-quote todo-category-done) "\\)") nil t)
	(let* ((beg (match-beginning 1))
	       (end (match-end 0))
	       (ov (progn (goto-char beg)
			  (todo-get-overlay 'separator)))
	       (old-sep (when ov (overlay-get ov 'display)))
	       new-ov)
	  (when old-sep
	    (unless (string= old-sep sep)
	      (setq new-ov (make-overlay beg end))
	      (overlay-put new-ov 'todo 'separator)
	      (overlay-put new-ov 'display todo-done-separator)
	      (delete-overlay ov))))))))

(defun todo-get-overlay (val)
  "Return the overlay at point whose `todo' property has value VAL."
  ;; Use overlays-in to find prefix overlays and check over two
  ;; positions to find done separator overlay.
  (let ((ovs (overlays-in (point) (1+ (point))))
  	ov)
    (catch 'done
      (while ovs
  	(setq ov (pop ovs))
  	(when (eq (overlay-get ov 'todo) val)
  	  (throw 'done ov))))))

(defun todo-marked-item-p ()
  "Non-nil if this item begins with `todo-item-mark'.
In that case, return the item's prefix overlay."
  (let* ((ov (todo-get-overlay 'prefix))
	 ;; If an item insertion command is called on a todo file
	 ;; before it is visited, it has no prefix overlays yet, so
	 ;; check for this.
	 (pref (when ov (overlay-get ov 'before-string)))
	 (marked (when pref
		   (string-match (concat "^" (regexp-quote todo-item-mark))
				 pref))))
    (when marked ov)))

(defun todo-insert-with-overlays (item)
  "Insert ITEM at point and update prefix/priority number overlays."
  (todo-item-start)
  ;; Insertion pushes item down but not its prefix overlay.  When the
  ;; overlay includes a mark, this would now mark the inserted ITEM,
  ;; so move it to the pushed down item.
  (let ((ov (todo-get-overlay 'prefix))
	(marked (todo-marked-item-p)))
    (insert item "\n")
    (when marked (move-overlay ov (point) (point))))
  (todo-backward-item)
  (todo-prefix-overlays))

(defun todo-prefix-overlays ()
  "Update the prefix overlays of the current category's items.
The overlay's value is the string `todo-prefix' or with non-nil
`todo-number-prefix' an integer in the sequence from 1 to
the number of todo or done items in the category indicating the
item's priority.  Todo and done items are numbered independently
of each other."
  (let ((num 0)
	(cat-tp (or (cdr (assoc-string
			  (todo-current-category)
			  (nth 2 (assoc-string todo-current-todo-file
					       todo-top-priorities-overrides))))
		    (nth 1 (assoc-string todo-current-todo-file
					 todo-top-priorities-overrides))
		    todo-top-priorities))
	done prefix)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(when (or (todo-date-string-matcher (line-end-position))
		  (todo-done-string-matcher (line-end-position)))
	  (goto-char (match-beginning 0))
	  (setq num (1+ num))
	  ;; Reset number to 1 for first done item.
	  (when (and (eq major-mode 'todo-mode)
		     (looking-at todo-done-string-start)
		     (looking-back (concat "^"
					   (regexp-quote todo-category-done)
					   "\n")))
	    (setq num 1
		  done t))
	  (setq prefix (concat (propertize
				(if todo-number-prefix
				    (number-to-string num)
				  todo-prefix)
				'face
				;; Prefix of top priority items has a
				;; distinct face in Todo mode.
				(if (and (eq major-mode 'todo-mode)
					 (not done)
					 (<= num cat-tp))
				    'todo-top-priority
				  'todo-prefix-string))
			       " "))
	  (let ((ov (todo-get-overlay 'prefix))
		(marked (todo-marked-item-p)))
	    ;; Prefix overlay must be at a single position so its
	    ;; bounds aren't changed when (re)moving an item.
	    (unless ov (setq ov (make-overlay (point) (point))))
	    (overlay-put ov 'todo 'prefix)
	    (overlay-put ov 'before-string (if marked
					       (concat todo-item-mark prefix)
					     prefix))))
	(forward-line)))))

;; -----------------------------------------------------------------------------
;;; Generating and applying item insertion and editing key sequences
;; -----------------------------------------------------------------------------

;; Thanks to Stefan Monnier for suggesting dynamically generating item
;; insertion commands and their key bindings, and offering an elegant
;; implementation, which, however, relies on lexical scoping and so
;; cannot be used here until the Calendar code used by todo-mode.el is
;; converted to lexical binding.  Hence, the following implementation
;; uses dynamic binding.

(defconst todo-insert-item--parameters
  '((default copy) (diary nonmarking) (calendar date dayname) time (here region))
  "List of all item insertion parameters.
Passed by `todo-insert-item' to `todo-insert-item--next-param' to
dynamically create item insertion commands.")

(defconst todo-insert-item--param-key-alist
  '((default    . "i")
    (copy       . "p")
    (diary      . "y")
    (nonmarking . "k")
    (calendar   . "c")
    (date       . "d")
    (dayname    . "n")
    (time       . "t")
    (here       . "h")
    (region     . "r"))
  "List pairing item insertion parameters with their completion keys.")

(defsubst todo-insert-item--keyof (param)
  "Return key paired with item insertion PARAM."
  (cdr (assoc param todo-insert-item--param-key-alist)))

(defun todo-insert-item--argsleft (key list)
  "Return sublist of LIST whose first member corresponds to KEY."
  (let (l sym)
    (mapc (lambda (m)
	    (when (consp m)
	      (catch 'found1
		(dolist (s m)
		  (when (equal key (todo-insert-item--keyof s))
		    (throw 'found1 (setq sym s))))))
	    (if sym
		(progn
		  (push sym l)
		  (setq sym nil))
	      (push m l)))
	  list)
    (setq list (reverse l)))
  (memq (catch 'found2
	  (dolist (e todo-insert-item--param-key-alist)
	    (when (equal key (cdr e))
	      (throw 'found2 (car e)))))
	list))

(defsubst todo-insert-item--this-key () (char-to-string last-command-event))

(defvar todo-insert-item--keys-so-far ""
  "String of item insertion keys so far entered for this command.")

(defvar todo-insert-item--args nil)
(defvar todo-insert-item--argleft nil)
(defvar todo-insert-item--argsleft nil)
(defvar todo-insert-item--newargsleft nil)

(defun todo-insert-item--apply-args ()
  "Build list of arguments for item insertion and apply them.
The list consists of item insertion parameters that can be passed
as insertion command arguments in fixed positions.  If a position
in the list is not occupied by the corresponding parameter, it is
occupied by `nil'."
  (let* ((arg (list (car todo-insert-item--args)))
	 (args (nconc (cdr todo-insert-item--args)
		      (list (car (todo-insert-item--argsleft
				  (todo-insert-item--this-key)
				  todo-insert-item--argsleft)))))
	 (arglist (if (= 4 (length args))
		      args
		    (let ((v (make-vector 4 nil)) elt)
		      (while args
			(setq elt (pop args))
			(cond ((memq elt '(diary nonmarking))
			       (aset v 0 elt))
			      ((memq elt '(calendar date dayname))
			       (aset v 1 elt))
			      ((eq elt 'time)
			       (aset v 2 elt))
			      ((memq elt '(copy here region))
			       (aset v 3 elt))))
		      (append v nil)))))
    (apply #'todo-insert-item--basic (nconc arg arglist))))

(defun todo-insert-item--next-param (last args argsleft)
  "Build item insertion command from LAST, ARGS and ARGSLEFT and call it.
Dynamically generate key bindings, prompting with the keys
already entered and those still available."
  (cl-assert argsleft)
  (let* ((map (make-sparse-keymap))
         (prompt nil)
         (addprompt
	  (lambda (k name)
	    (setq prompt
		  (concat prompt
			  (format
			   (concat
			    (if (memq name '(default diary calendar here))
				" { " " ")
			    "%s=>%s"
			    (when (memq name '(copy nonmarking dayname region))
			      " }"))
			   (propertize k 'face 'todo-key-prompt)
			   name))))))
    (setq todo-insert-item--args args)
    (setq todo-insert-item--argsleft argsleft)
    (when last
      (if (memq last '(default copy))
	  (progn
	    (setq todo-insert-item--argsleft nil)
	    (todo-insert-item--apply-args))
	(let ((k (todo-insert-item--keyof last)))
	  (funcall addprompt k (make-symbol (concat (symbol-name last) ":GO!")))
	  (define-key map (todo-insert-item--keyof last)
	    (lambda () (interactive)
	      (todo-insert-item--apply-args))))))
    (while todo-insert-item--argsleft
      (let ((x (car todo-insert-item--argsleft)))
	(setq todo-insert-item--newargsleft (cdr todo-insert-item--argsleft))
        (dolist (argleft (if (consp x) x (list x)))
	  (let ((k (todo-insert-item--keyof argleft)))
	    (funcall addprompt k argleft)
	    (define-key map k
	      (if (null todo-insert-item--newargsleft)
		  (lambda () (interactive)
		    (todo-insert-item--apply-args))
		(lambda () (interactive)
		  (setq todo-insert-item--keys-so-far
			(concat todo-insert-item--keys-so-far " "
				(todo-insert-item--this-key)))
		  (todo-insert-item--next-param
		   (car (todo-insert-item--argsleft
			 (todo-insert-item--this-key)
			 todo-insert-item--argsleft))
		   (nconc todo-insert-item--args
			  (list (car (todo-insert-item--argsleft
				      (todo-insert-item--this-key)
				      todo-insert-item--argsleft))))
		   (cdr (todo-insert-item--argsleft
			 (todo-insert-item--this-key)
			 todo-insert-item--argsleft)))))))))
      (setq todo-insert-item--argsleft todo-insert-item--newargsleft))
    (when prompt (message "Press a key (so far `%s'): %s"
			  todo-insert-item--keys-so-far prompt))
    (set-transient-map map)
    (setq todo-insert-item--argsleft argsleft)))

(defconst todo-edit-item--param-key-alist
  '((edit       . "e")
    (header     . "h")
    (multiline  . "m")
    (diary      . "y")
    (nonmarking . "k")
    (date       . "d")
    (time       . "t"))
  "Alist of item editing parameters and their keys.")

(defconst todo-edit-item--date-param-key-alist
  '((full       . "f")
    (calendar   . "c")
    (today      . "a")
    (dayname    . "n")
    (year       . "y")
    (month      . "m")
    (daynum     . "d"))
  "Alist of item date editing parameters and their keys.")

(defconst todo-edit-done-item--param-key-alist
  '((add/edit   . "c")
    (delete     . "d"))
  "Alist of done item comment editing parameters and their keys.")

(defvar	todo-edit-item--prompt "Press a key (so far `e'): ")

(defun todo-edit-item--next-key (params &optional arg)
  (let* ((map (make-sparse-keymap))
	 (p->k (mapconcat (lambda (elt)
			    (format "%s=>%s"
				    (propertize (cdr elt) 'face
						'todo-key-prompt)
				    (concat (symbol-name (car elt))
					    (when (memq (car elt)
							'(add/edit delete))
					      " comment"))))
			  params " "))
	 (this-key (let ((key (read-key (concat todo-edit-item--prompt p->k))))
		     (and (characterp key) (char-to-string key))))
	 (this-param (car (rassoc this-key params))))
    (pcase this-param
      (`edit (todo-edit-item--text))
      (`header (todo-edit-item--text 'include-header))
      (`multiline (todo-edit-item--text 'multiline))
      (`add/edit (todo-edit-item--text 'comment-edit))
      (`delete (todo-edit-item--text 'comment-delete))
      (`diary (todo-edit-item--diary-inclusion))
      (`nonmarking (todo-edit-item--diary-inclusion 'nonmarking))
      (`date (let ((todo-edit-item--prompt "Press a key (so far `e d'): "))
	       (todo-edit-item--next-key
		todo-edit-item--date-param-key-alist arg)))
      (`full (progn (todo-edit-item--header 'date)
		    (when todo-always-add-time-string
		      (todo-edit-item--header 'time))))
      (`calendar (todo-edit-item--header 'calendar))
      (`today (todo-edit-item--header 'today))
      (`dayname (todo-edit-item--header 'dayname))
      (`year (todo-edit-item--header 'year arg))
      (`month (todo-edit-item--header 'month arg))
      (`daynum (todo-edit-item--header 'day arg))
      (`time (todo-edit-item--header 'time)))))

;; -----------------------------------------------------------------------------
;;; Todo minibuffer utilities
;; -----------------------------------------------------------------------------

(defcustom todo-y-with-space nil
  "Non-nil means allow SPC to affirm a \"y or n\" question."
  :type 'boolean
  :group 'todo)

(defun todo-y-or-n-p (prompt)
  "Ask \"y or n\" question PROMPT and return t if answer is \"y\".
Also return t if answer is \"Y\", but unlike `y-or-n-p', allow
SPC to affirm the question only if option `todo-y-with-space' is
non-nil."
  (unless todo-y-with-space
    (define-key query-replace-map " " 'ignore))
  (prog1
   (y-or-n-p prompt)
   (define-key query-replace-map " " 'act)))

(defun todo-category-completions (&optional archive)
  "Return a list of completions for `todo-read-category'.
Each element of the list is a cons of a category name and the
file or list of files (as short file names) it is in.  The files
are either the current (or if there is none, the default) todo
file plus the files listed in `todo-category-completions-files',
or, with non-nil ARCHIVE, the current archive file.

Before calculating the completions, update the value of
`todo-category-completions-files' in case any files named in it
have been removed."
  (let (deleted)
    (dolist (f todo-category-completions-files)
      (unless (file-exists-p (todo-absolute-file-name f))
	(setq todo-category-completions-files
	      (delete f todo-category-completions-files))
	(push f deleted)))
    (when deleted
      (let ((pl (> (length deleted) 1))
	    (names (mapconcat (lambda (f) (concat "\"" f "\"")) deleted ", ")))
	(message (concat "File" (if pl "s" "") " " names " ha" (if pl "ve" "s")
			 " been deleted and removed from\n"
			 "the list of category completion files")))
      (todo-reevaluate-category-completions-files-defcustom)
      (custom-set-default 'todo-category-completions-files
			  (symbol-value 'todo-category-completions-files))
      (sleep-for 1.5)))
  (let* ((curfile (or todo-current-todo-file
		      (and todo-show-current-file
			   todo-global-current-todo-file)
		      (todo-absolute-file-name todo-default-todo-file)))
	 (files (or (unless archive
		      (mapcar 'todo-absolute-file-name
			      todo-category-completions-files))
		    (list curfile)))
	 listall listf)
    ;; If file was just added, it has no category completions.
    (unless (zerop (buffer-size (find-buffer-visiting curfile)))
      (unless (member curfile todo-archives)
	(add-to-list 'files curfile))
      (dolist (f files listall)
	(with-current-buffer (find-file-noselect f 'nowarn)
	  (if archive
	      (unless (derived-mode-p 'todo-archive-mode) (todo-archive-mode))
	    (unless (derived-mode-p 'todo-mode) (todo-mode)))
	  ;; Ensure category is properly displayed in case user
	  ;; switches to file via a non-Todo mode command.  And if
	  ;; done items in category are visible, keep them visible.
	  (let ((done todo-show-with-done))
	    (when (> (buffer-size) (- (point-max) (point-min)))
	      (save-excursion
		(goto-char (point-min))
		(setq done (re-search-forward todo-done-string-start nil t))))
	    (let ((todo-show-with-done done))
	      (save-excursion (todo-category-select))))
	  (save-excursion
	    (save-restriction
	      (widen)
	      (goto-char (point-min))
	      (setq listf (read (buffer-substring-no-properties
				 (line-beginning-position)
				 (line-end-position)))))))
	(mapc (lambda (elt) (let* ((cat (car elt))
				   (la-elt (assoc cat listall)))
			      (if la-elt
				  (setcdr la-elt (append (list (cdr la-elt))
							 (list f)))
				(push (cons cat f) listall))))
	      listf)))))

(defun todo-read-file-name (prompt &optional archive mustmatch)
  "Choose and return the name of a todo file, prompting with PROMPT.

Show completions with TAB or SPC; the names are shown in short
form but the absolute truename is returned.  With non-nil ARCHIVE
return the absolute truename of a todo archive file.  With non-nil
MUSTMATCH the name of an existing file must be chosen;
otherwise, a new file name is allowed."
  (let* ((completion-ignore-case todo-completion-ignore-case)
	 (files (mapcar 'todo-short-file-name
			;; (funcall todo-files-function archive)))
			(if archive todo-archives todo-files)))
	 (file (completing-read prompt files nil mustmatch nil nil
				(if files
				    ;; If user hit RET without
				    ;; choosing a file, default to
				    ;; current or default file.
				    (todo-short-file-name
				     (or todo-current-todo-file
					 (and todo-show-current-file
					      todo-global-current-todo-file)
					 (todo-absolute-file-name
					  todo-default-todo-file)))
				  ;; Trigger prompt for initial file.
				  ""))))
    (unless (file-exists-p todo-directory)
      (make-directory todo-directory))
    (unless (or mustmatch (member file files))
      (setq file (todo-validate-name file 'file)))
    (setq file (file-truename (concat todo-directory file
				      (if archive ".toda" ".todo"))))))

(defun todo-read-category (prompt &optional match-type file)
  "Choose and return a category name, prompting with PROMPT.
Show completions for existing categories with TAB or SPC.

The argument MATCH-TYPE specifies the matching requirements on
the category name: with the value `todo' or `archive' the name
must complete to that of an existing todo or archive category,
respectively; with the value `add' the name must not be that of
an existing category; with all other values both existing and new
valid category names are accepted.

With non-nil argument FILE prompt for a file and complete only
against categories in that file; otherwise complete against all
categories from `todo-category-completions-files'."
  ;; Allow SPC to insert spaces, for adding new category names.
  (let ((map minibuffer-local-completion-map))
    (define-key map " " nil)
    (let* ((add (eq match-type 'add))
	   (archive (eq match-type 'archive))
	   (file0 (when (and file (> (length todo-files) 1))
		    (todo-read-file-name (concat "Choose a" (if archive
								 "n archive"
							       " todo")
						  " file: ") archive t)))
	   (completions (unless file0 (todo-category-completions archive)))
	   (categories (cond (file0
			      (with-current-buffer
				  (find-file-noselect file0 'nowarn)
				(unless (derived-mode-p 'todo-mode) (todo-mode))
				(let ((todo-current-todo-file file0))
				  todo-categories)))
			     ((and add (not file))
			      (with-current-buffer
				  (find-file-noselect todo-current-todo-file)
				todo-categories))
			     (t
			      completions)))
	   (completion-ignore-case todo-completion-ignore-case)
	   (cat (completing-read prompt categories nil
				 (eq match-type 'todo) nil nil
				 ;; Unless we're adding a category via
				 ;; todo-add-category, set default
				 ;; for existing categories to the
				 ;; current category of the chosen
				 ;; file or else of the current file.
				 (if (and categories (not add))
				     (with-current-buffer
					 (find-file-noselect
					  (or file0
					      todo-current-todo-file
					      (todo-absolute-file-name
					       todo-default-todo-file)))
				       (todo-current-category))
				   ;; Trigger prompt for initial category.
				   "")))
	   (catfil (cdr (assoc cat completions)))
	   (str "Category \"%s\" from which file (TAB for choices)? "))
      ;; If we do category completion and the chosen category name
      ;; occurs in more than one file, prompt to choose one file.
      (unless (or file0 add (not catfil))
	(setq file0 (file-truename
		     (if (atom catfil)
			 catfil
		       (todo-absolute-file-name
			(let ((files (mapcar 'todo-short-file-name catfil)))
			  (completing-read (format str cat) files)))))))
      ;; Default to the current file.
      (unless file0 (setq file0 todo-current-todo-file))
      ;; First validate only a name passed interactively from
      ;; todo-add-category, which must be of a nonexistent category.
      (unless (and (assoc cat categories) (not add))
	;; Validate only against completion categories.
	(let ((todo-categories categories))
	  (setq cat (todo-validate-name cat 'category)))
	;; When user enters a nonexistent category name by jumping or
	;; moving, confirm that it should be added, then validate.
	(unless add
	  (if (todo-y-or-n-p (format "Add new category \"%s\" to file \"%s\"? "
				cat (todo-short-file-name file0)))
	      (progn
		(when (assoc cat categories)
		  (let ((todo-categories categories))
		    (setq cat (todo-validate-name cat 'category))))
		;; Restore point and narrowing after adding new
		;; category, to avoid moving to beginning of file when
		;; moving marked items to a new category
		;; (todo-move-item).
		(save-excursion
		  (save-restriction
		    (todo-add-category file0 cat))))
	    ;; If we decide not to add a category, exit without returning.
	    (keyboard-quit))))
      (cons cat file0))))

(defun todo-validate-name (name type)
  "Prompt for new NAME for TYPE until it is valid, then return it.
TYPE can be either of the symbols `file' or `category'."
  (let ((categories todo-categories)
	(files (mapcar 'todo-short-file-name todo-files))
	prompt)
    (while
	(and
	 (cond ((string= "" name)
		(setq prompt
		      (cond ((eq type 'file)
			     (if files
				 "Enter a non-empty file name: "
			       ;; Empty string passed by todo-show to
			       ;; prompt for initial todo file.
			       (concat "Initial file name ["
				       todo-initial-file "]: ")))
			    ((eq type 'category)
			     (if categories
				 "Enter a non-empty category name: "
			       ;; Empty string passed by todo-show to
			       ;; prompt for initial category of a new
			       ;; todo file.
			       (concat "Initial category name ["
				       todo-initial-category "]: "))))))
	       ((string-match "\\`\\s-+\\'" name)
		(setq prompt
		      "Enter a name that does not contain only white space: "))
	       ((and (eq type 'file) (member name files))
		(setq prompt "Enter a non-existing file name: "))
	       ((and (eq type 'category) (assoc name categories))
		(setq prompt "Enter a non-existing category name: ")))
	 (setq name (if (or (and (eq type 'file) files)
			    (and (eq type 'category) categories))
			(completing-read prompt (cond ((eq type 'file)
						       files)
						      ((eq type 'category)
						       categories)))
		      ;; Offer default initial name.
		      (completing-read prompt (if (eq type 'file)
						  files
						categories)
				       nil nil (if (eq type 'file)
						   todo-initial-file
						 todo-initial-category))))))
    name))

;; Adapted from calendar-read-date and calendar-date-string.
(defun todo-read-date (&optional arg mo yr)
  "Prompt for Gregorian date and return it in the current format.

With non-nil ARG, prompt for and return only the date component
specified by ARG, which can be one of these symbols:
`month' (prompt for name, return name or number according to
value of `calendar-date-display-form'), `day' of month, or
`year'.  The value of each of these components can be `*',
indicating an unspecified month, day, or year.

When ARG is `day', non-nil arguments MO and YR determine the
number of the last the day of the month."
  (let (year monthname month day
	     dayname)			; Needed by calendar-date-display-form.
    (when (or (not arg) (eq arg 'year))
      (while (if (natnump year) (< year 1) (not (eq year '*)))
	(setq year (read-from-minibuffer
		    "Year (>0 or RET for this year or * for any year): "
		    nil nil t nil (number-to-string
				   (calendar-extract-year
				    (calendar-current-date)))))))
    (when (or (not arg) (eq arg 'month))
      (let* ((marray todo-month-name-array)
	     (mlist (append marray nil))
	     (mabarray todo-month-abbrev-array)
	     (mablist (append mabarray nil))
	     (completion-ignore-case todo-completion-ignore-case))
	(setq monthname (completing-read
			 "Month name (RET for current month, * for any month): "
			 mlist nil t nil nil
	      		 (calendar-month-name (calendar-extract-month
	      				       (calendar-current-date)) t))
	      month (1+ (- (length mlist)
			   (length (or (member monthname mlist)
				       (member monthname mablist))))))
	(setq monthname (aref mabarray (1- month)))))
    (when (or (not arg) (eq arg 'day))
      (let ((last (let ((mm (or month mo))
			(yy (or year yr)))
		    ;; If month is unspecified, use a month with 31
		    ;; days for checking day of month input.  Does
		    ;; Calendar do anything special when * is
		    ;; currently a shorter month?
		    (if (= mm 13) (setq mm 1))
		    ;; If year is unspecified, use a leap year to
		    ;; allow Feb. 29.
		    (if (eq year '*) (setq yy 2012))
		    (calendar-last-day-of-month mm yy))))
	(while (if (natnump day) (or (< day 1) (> day last)) (not (eq day '*)))
	  (setq day (read-from-minibuffer
		     (format "Day (1-%d or RET for today or * for any day): "
			     last)
		     nil nil t nil (number-to-string
				    (calendar-extract-day
				     (calendar-current-date))))))))
    ;; Stringify read values (monthname is already a string).
    (and year (setq year (if (eq year '*)
			     (symbol-name '*)
			   (number-to-string year))))
    (and day (setq day (if (eq day '*)
			   (symbol-name '*)
			 (number-to-string day))))
    (and month (setq month (if (eq month '*)
			       (symbol-name '*)
			     (number-to-string month))))
    (if arg
	(cond ((eq arg 'year) year)
	      ((eq arg 'day) day)
	      ((eq arg 'month)
	       (if (memq 'month calendar-date-display-form)
		   month
		 monthname)))
      (mapconcat 'eval calendar-date-display-form ""))))

(defun todo-read-dayname ()
  "Choose name of a day of the week with completion and return it."
  (let ((completion-ignore-case todo-completion-ignore-case))
    (completing-read "Enter a day name: "
		     (append calendar-day-name-array nil)
		     nil t)))

(defun todo-read-time ()
  "Prompt for and return a valid clock time as a string.

Valid time strings are those matching `diary-time-regexp'.
Typing `<return>' at the prompt returns the current time, if the
user option `todo-always-add-time-string' is non-nil, otherwise
the empty string (i.e., no time string)."
  (let (valid answer)
    (while (not valid)
      (setq answer (read-string "Enter a clock time: " nil nil
				(when todo-always-add-time-string
				  (substring (current-time-string) 11 16))))
      (when (or (string= "" answer)
		(string-match diary-time-regexp answer))
	(setq valid t)))
    answer))

;; -----------------------------------------------------------------------------
;;; Customization groups and utilities
;; -----------------------------------------------------------------------------

(defgroup todo nil
  "Create and maintain categorized lists of todo items."
  :link '(emacs-commentary-link "todo")
  :version "24.4"
  :group 'calendar)

(defgroup todo-edit nil
  "User options for adding and editing todo items."
  :version "24.4"
  :group 'todo)

(defgroup todo-categories nil
  "User options for Todo Categories mode."
  :version "24.4"
  :group 'todo)

(defgroup todo-filtered nil
  "User options for Todo Filter Items mode."
  :version "24.4"
  :group 'todo)

(defgroup todo-display nil
  "User display options for Todo mode."
  :version "24.4"
  :group 'todo)

(defgroup todo-faces nil
  "Faces for the Todo modes."
  :version "24.4"
  :group 'todo)

(defun todo-set-show-current-file (symbol value)
  "The :set function for user option `todo-show-current-file'."
  (custom-set-default symbol value)
  (if value
      (add-hook 'pre-command-hook 'todo-show-current-file nil t)
    (remove-hook 'pre-command-hook 'todo-show-current-file t)))

(defun todo-reset-prefix (symbol value)
  "The :set function for `todo-prefix' and `todo-number-prefix'."
  (let ((oldvalue (symbol-value symbol))
	(files todo-file-buffers))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-file-noselect f)
	  ;; Activate the new setting in the current category.
	  (save-excursion (todo-category-select)))))))

(defun todo-reset-nondiary-marker (symbol value)
  "The :set function for user option `todo-nondiary-marker'."
  (let* ((oldvalue (symbol-value symbol))
	 (files (append todo-files todo-archives
			(directory-files todo-directory t "\.tod[rty]$" t))))
    (custom-set-default symbol value)
    ;; Need to reset these to get font-locking right.
    (setq todo-nondiary-start (nth 0 todo-nondiary-marker)
	  todo-nondiary-end (nth 1 todo-nondiary-marker)
	  todo-date-string-start
	  ;; See comment in defvar of `todo-date-string-start'.
	  (concat "^\\(" (regexp-quote todo-nondiary-start) "\\|"
		  (regexp-quote diary-nonmarking-symbol) "\\)?"))
    (when (not (equal value oldvalue))
      (dolist (f files)
	(let ((buf (find-buffer-visiting f)))
	  (with-current-buffer (find-file-noselect f)
	    (let (buffer-read-only)
	      (widen)
	      (goto-char (point-min))
	      (while (not (eobp))
		(if (re-search-forward
		     (concat "^\\(" todo-done-string-start "[^][]+] \\)?"
			     "\\(?1:" (regexp-quote (car oldvalue))
			     "\\)" todo-date-pattern "\\( "
			     diary-time-regexp "\\)?\\(?2:"
			     (regexp-quote (cadr oldvalue)) "\\)")
		     nil t)
		    (progn
		      (replace-match (nth 0 value) t t nil 1)
		      (replace-match (nth 1 value) t t nil 2))
		  (forward-line)))
	      (if buf
		  (when (derived-mode-p 'todo-mode 'todo-archive-mode)
		    (todo-category-select))
		(save-buffer)
		(kill-buffer)))))))))

(defun todo-reset-done-separator-string (symbol value)
  "The :set function for `todo-done-separator-string'."
  (let ((oldvalue (symbol-value symbol))
	(files todo-file-buffers)
	(sep todo-done-separator))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(with-current-buffer (find-file-noselect f)
	  (let (buffer-read-only)
	    (setq todo-done-separator (todo-done-separator))
	    (when (= 1 (length value))
	      (todo-reset-done-separator sep)))
	  (todo-category-select))))))

(defun todo-reset-done-string (symbol value)
  "The :set function for user option `todo-done-string'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todo-files todo-archives
		       (directory-files todo-directory t "\.todr$" t))))
    (custom-set-default symbol value)
    ;; Need to reset this to get font-locking right.
    (setq todo-done-string-start
	  (concat "^\\[" (regexp-quote todo-done-string)))
    (when (not (equal value oldvalue))
      (dolist (f files)
	(let ((buf (find-buffer-visiting f)))
	  (with-current-buffer (find-file-noselect f)
	    (let (buffer-read-only)
	      (widen)
	      (goto-char (point-min))
	      (while (not (eobp))
		(if (re-search-forward
		     (concat "^" (regexp-quote todo-nondiary-start)
			     "\\(" (regexp-quote oldvalue) "\\)")
		     nil t)
		    (replace-match value t t nil 1)
		  (forward-line)))
	      (if buf
		  (when (derived-mode-p 'todo-mode 'todo-archive-mode)
		    (todo-category-select))
		(save-buffer)
		(kill-buffer)))))))))

(defun todo-reset-comment-string (symbol value)
  "The :set function for user option `todo-comment-string'."
  (let ((oldvalue (symbol-value symbol))
  	(files (append todo-files todo-archives
		       (directory-files todo-directory t "\.todr$" t))))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(let ((buf (find-buffer-visiting f)))
	  (with-current-buffer (find-file-noselect f)
	    (let (buffer-read-only)
	      (widen)
	      (goto-char (point-min))
	      (while (not (eobp))
		(if (re-search-forward
		     (concat "\\[\\(" (regexp-quote oldvalue)
			     "\\): [^]]*\\]")
		     nil t)
		    (replace-match value t t nil 1)
		  (forward-line)))
	      (if buf
		  (when (derived-mode-p 'todo-mode 'todo-archive-mode)
		    (todo-category-select))
		(save-buffer)
		(kill-buffer)))))))))

(defun todo-reset-highlight-item (symbol value)
  "The :set function for user option `todo-highlight-item'."
  (let ((oldvalue (symbol-value symbol))
	(files (append todo-files todo-archives
		       (directory-files todo-directory t "\.tod[rty]$" t))))
    (custom-set-default symbol value)
    (when (not (equal value oldvalue))
      (dolist (f files)
	(let ((buf (find-buffer-visiting f)))
	  (when buf
	    (with-current-buffer buf
	      (require 'hl-line)
	      (if value
		  (hl-line-mode 1)
		(hl-line-mode -1)))))))))

(defun todo-reevaluate-filelist-defcustoms ()
  "Reevaluate defcustoms that provide choice list of todo files."
  (custom-set-default 'todo-default-todo-file
		      (symbol-value 'todo-default-todo-file))
  (todo-reevaluate-default-file-defcustom)
  (custom-set-default 'todo-filter-files (symbol-value 'todo-filter-files))
  (todo-reevaluate-filter-files-defcustom)
  (custom-set-default 'todo-category-completions-files
		      (symbol-value 'todo-category-completions-files))
  (todo-reevaluate-category-completions-files-defcustom))

(defun todo-reevaluate-default-file-defcustom ()
  "Reevaluate defcustom of `todo-default-todo-file'.
Called after adding or deleting a todo file.  If the value of
`todo-default-todo-file' before calling this function was
associated with an existing file, keep that value."
  ;; (let ((curval todo-default-todo-file))
    (eval
     (defcustom todo-default-todo-file (todo-short-file-name
					(car (funcall todo-files-function)))
       "Todo file visited by first session invocation of `todo-show'."
       :type (when todo-files
	       `(radio ,@(mapcar (lambda (f) (list 'const f))
				 (mapcar 'todo-short-file-name
					 (funcall todo-files-function)))))
       :group 'todo))
    ;; (when (and curval (file-exists-p (todo-absolute-file-name curval)))
    ;;   (custom-set-default 'todo-default-todo-file curval)
    ;;   ;; (custom-reevaluate-setting 'todo-default-todo-file)
    ;;   )))
    )

(defun todo-reevaluate-category-completions-files-defcustom ()
  "Reevaluate defcustom of `todo-category-completions-files'.
Called after adding or deleting a todo file."
  (eval (defcustom todo-category-completions-files nil
  "List of files for building `todo-read-category' completions."
	  :type `(set ,@(mapcar (lambda (f) (list 'const f))
				(mapcar 'todo-short-file-name
					(funcall todo-files-function))))
	  :group 'todo)))

(defun todo-reevaluate-filter-files-defcustom ()
  "Reevaluate defcustom of `todo-filter-files'.
Called after adding or deleting a todo file."
  (eval (defcustom todo-filter-files nil
	  "List of files for multifile item filtering."
	  :type `(set ,@(mapcar (lambda (f) (list 'const f))
				(mapcar 'todo-short-file-name
					(funcall todo-files-function))))
	  :group 'todo)))

;; -----------------------------------------------------------------------------
;;; Font locking
;; -----------------------------------------------------------------------------

(defun todo-nondiary-marker-matcher (lim)
  "Search for todo item nondiary markers within LIM for font-locking."
  (re-search-forward (concat "^\\(?1:" (regexp-quote todo-nondiary-start) "\\)"
			     todo-date-pattern "\\(?: " diary-time-regexp
			     "\\)?\\(?2:" (regexp-quote todo-nondiary-end) "\\)")
		     lim t))

(defun todo-diary-nonmarking-matcher (lim)
  "Search for diary nonmarking symbol within LIM for font-locking."
  (re-search-forward (concat "^\\(?1:" (regexp-quote diary-nonmarking-symbol)
			     "\\)" todo-date-pattern) lim t))

(defun todo-date-string-matcher (lim)
  "Search for todo item date string within LIM for font-locking."
  (re-search-forward
   (concat todo-date-string-start "\\(?1:" todo-date-pattern "\\)") lim t))

(defun todo-time-string-matcher (lim)
  "Search for todo item time string within LIM for font-locking."
  (re-search-forward (concat todo-date-string-start todo-date-pattern
			     " \\(?1:" diary-time-regexp "\\)") lim t))

(defun todo-diary-expired-matcher (lim)
  "Search for expired diary item date within LIM for font-locking."
  (when (re-search-forward (concat "^\\(?:"
				   (regexp-quote diary-nonmarking-symbol)
				   "\\)?\\(?1:" todo-date-pattern "\\) \\(?2:"
				   diary-time-regexp "\\)?") lim t)
    (let* ((date (match-string-no-properties 1))
    	   (time (match-string-no-properties 2))
	   ;; Function days-between requires a non-empty time string.
    	   (date-time (concat date " " (or time "00:00"))))
      (or (and (not (string-match ".+day\\|\\*" date))
	       (< (days-between date-time (current-time-string)) 0))
	  (todo-diary-expired-matcher lim)))))

(defun todo-done-string-matcher (lim)
  "Search for done todo item header within LIM for font-locking."
  (re-search-forward (concat todo-done-string-start
		      "[^][]+]")
		     lim t))

(defun todo-comment-string-matcher (lim)
  "Search for done todo item comment within LIM for font-locking."
  (re-search-forward (concat "\\[\\(?1:" todo-comment-string "\\):")
		     lim t))

(defun todo-category-string-matcher-1 (lim)
  "Search for todo category name within LIM for font-locking.
This is for fontifying category and file names appearing in Todo
Filtered Items mode following done items."
  (if (eq major-mode 'todo-filtered-items-mode)
      (re-search-forward (concat todo-done-string-start todo-date-pattern
				 "\\(?: " diary-time-regexp
				 ;; Use non-greedy operator to prevent
				 ;; capturing possible following non-diary
				 ;; date string.
				 "\\)?] \\(?1:\\[.+?\\]\\)")
			 lim t)))

(defun todo-category-string-matcher-2 (lim)
  "Search for todo category name within LIM for font-locking.
This is for fontifying category and file names appearing in Todo
Filtered Items mode following todo (not done) items."
  (if (eq major-mode 'todo-filtered-items-mode)
      (re-search-forward (concat todo-date-string-start todo-date-pattern
				 "\\(?: " diary-time-regexp "\\)?\\(?:"
				 (regexp-quote todo-nondiary-end)
				 "\\)? \\(?1:\\[.+\\]\\)")
			 lim t)))

(defvar todo-nondiary-face 'todo-nondiary)
(defvar todo-date-face 'todo-date)
(defvar todo-time-face 'todo-time)
(defvar todo-diary-expired-face 'todo-diary-expired)
(defvar todo-done-sep-face 'todo-done-sep)
(defvar todo-done-face 'todo-done)
(defvar todo-comment-face 'todo-comment)
(defvar todo-category-string-face 'todo-category-string)
(defvar todo-font-lock-keywords
  (list
   '(todo-nondiary-marker-matcher 1 todo-nondiary-face t)
   '(todo-nondiary-marker-matcher 2 todo-nondiary-face t)
   ;; diary-lib.el uses font-lock-constant-face for diary-nonmarking-symbol.
   '(todo-diary-nonmarking-matcher 1 font-lock-constant-face t)
   '(todo-date-string-matcher 1 todo-date-face t)
   '(todo-time-string-matcher 1 todo-time-face t)
   '(todo-done-string-matcher 0 todo-done-face t)
   '(todo-comment-string-matcher 1 todo-comment-face t)
   '(todo-category-string-matcher-1 1 todo-category-string-face t t)
   '(todo-category-string-matcher-2 1 todo-category-string-face t t)
   '(todo-diary-expired-matcher 1 todo-diary-expired-face t)
   '(todo-diary-expired-matcher 2 todo-diary-expired-face t t)
   )
  "Font-locking for Todo modes.")

;; -----------------------------------------------------------------------------
;;; Key binding
;; -----------------------------------------------------------------------------

(defvar todo-key-bindings-t
  `(
    ("Af"	     todo-find-archive)
    ("Ac"	     todo-choose-archive)
    ("Ad"	     todo-archive-done-item)
    ("Cv"	     todo-toggle-view-done-items)
    ("v"	     todo-toggle-view-done-items)
    ("Ca"	     todo-add-category)
    ("Cr"	     todo-rename-category)
    ("Cg"	     todo-merge-category)
    ("Cm"	     todo-move-category)
    ("Ck"	     todo-delete-category)
    ("Cts"	     todo-set-top-priorities-in-category)
    ("Cey"	     todo-edit-category-diary-inclusion)
    ("Cek"	     todo-edit-category-diary-nonmarking)
    ("Fa"	     todo-add-file)
    ("Fr"	     todo-rename-file)
    ("Ff"	     todo-find-filtered-items-file)
    ("FV"	     todo-toggle-view-done-only)
    ("V"	     todo-toggle-view-done-only)
    ("Ftt"	     todo-filter-top-priorities)
    ("Ftm"	     todo-filter-top-priorities-multifile)
    ("Fts"	     todo-set-top-priorities-in-file)
    ("Fyy"	     todo-filter-diary-items)
    ("Fym"	     todo-filter-diary-items-multifile)
    ("Fxx"	     todo-filter-regexp-items)
    ("Fxm"	     todo-filter-regexp-items-multifile)
    ("e"	     todo-edit-item)
    ("d"	     todo-item-done)
    ("i"	     todo-insert-item)
    ("k"	     todo-delete-item)
    ("m"	     todo-move-item)
    ("u"	     todo-item-undone)
    ([remap newline] newline-and-indent)
   )
  "List of key bindings for Todo mode only.")

(defvar todo-key-bindings-t+a+f
  `(
    ("C*" todo-mark-category)
    ("Cu" todo-unmark-category)
    ("Fh" todo-toggle-item-header)
    ("h"  todo-toggle-item-header)
    ("Fk" todo-delete-file)
    ("Fe" todo-edit-file)
    ("FH" todo-toggle-item-highlighting)
    ("H"  todo-toggle-item-highlighting)
    ("FN" todo-toggle-prefix-numbers)
    ("N"  todo-toggle-prefix-numbers)
    ("PB" todo-print-buffer)
    ("PF" todo-print-buffer-to-file)
    ("b"  todo-backward-category)
    ("d"  todo-item-done)
    ("f"  todo-forward-category)
    ("j"  todo-jump-to-category)
    ("n"  todo-next-item)
    ("p"  todo-previous-item)
    ("q"  todo-quit)
    ("s"  todo-save)
    ("t"  todo-show)
   )
  "List of key bindings for Todo, Archive, and Filtered Items modes.")

(defvar todo-key-bindings-t+a
  `(
    ("Fc" todo-show-categories-table)
    ("S"  todo-search)
    ("X"  todo-clear-matches)
    ("*"  todo-toggle-mark-item)
   )
  "List of key bindings for Todo and Todo Archive modes.")

(defvar todo-key-bindings-t+f
  `(
    ("l" todo-lower-item-priority)
    ("r" todo-raise-item-priority)
    ("#" todo-set-item-priority)
   )
  "List of key bindings for Todo and Todo Filtered Items modes.")

(defvar todo-mode-map
  (let ((map (make-keymap)))
    ;; Don't suppress digit keys, so they can supply prefix arguments.
    (suppress-keymap map)
    (dolist (kb todo-key-bindings-t)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (dolist (kb todo-key-bindings-t+a+f)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (dolist (kb todo-key-bindings-t+a)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (dolist (kb todo-key-bindings-t+f)
      (define-key map (nth 0 kb) (nth 1 kb)))
    map)
  "Todo mode keymap.")

(defvar todo-archive-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (dolist (kb todo-key-bindings-t+a+f)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (dolist (kb todo-key-bindings-t+a)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (define-key map "a" 'todo-jump-to-archive-category)
    (define-key map "u" 'todo-unarchive-items)
    map)
  "Todo Archive mode keymap.")

(defvar todo-edit-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-x\C-q" 'todo-edit-quit)
    (define-key map [remap newline] 'newline-and-indent)
    map)
  "Todo Edit mode keymap.")

(defvar todo-categories-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map "c" 'todo-sort-categories-alphabetically-or-numerically)
    (define-key map "t" 'todo-sort-categories-by-todo)
    (define-key map "y" 'todo-sort-categories-by-diary)
    (define-key map "d" 'todo-sort-categories-by-done)
    (define-key map "a" 'todo-sort-categories-by-archived)
    (define-key map "#" 'todo-set-category-number)
    (define-key map "l" 'todo-lower-category)
    (define-key map "r" 'todo-raise-category)
    (define-key map "n" 'todo-next-button)
    (define-key map "p" 'todo-previous-button)
    (define-key map [tab] 'todo-next-button)
    (define-key map [backtab] 'todo-previous-button)
    (define-key map "q" 'todo-quit)
    map)
  "Todo Categories mode keymap.")

(defvar todo-filtered-items-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (dolist (kb todo-key-bindings-t+a+f)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (dolist (kb todo-key-bindings-t+f)
      (define-key map (nth 0 kb) (nth 1 kb)))
    (define-key map "g" 'todo-go-to-source-item)
    (define-key map [remap newline] 'todo-go-to-source-item)
    map)
  "Todo Filtered Items mode keymap.")

(easy-menu-define
  todo-menu todo-mode-map "Todo Menu"
  '("Todo"
    ("Navigation"
     ["Next Item"            todo-next-item t]
     ["Previous Item"        todo-previous-item t]
     "---"
     ["Next Category"        todo-forward-category t]
     ["Previous Category"    todo-backward-category t]
     ["Jump to Another Category"     todo-jump-to-category t]
     "---"
     ["Visit Another Todo File"     todo-show t]
     ["Visit Archive" todo-find-archive t]
     ["Visit Filtered Items File" todo-find-filtered-items-file t]
     )
    ("Editing"
     ["Insert New Item"      todo-insert-item t]
     ["Edit Item"            todo-edit-item t]
     ["Lower Item Priority"  todo-lower-item-priority t]
     ["Raise Item Priority"  todo-raise-item-priority t]
     ["Set Item Priority" todo-set-item-priority t]
     ["Mark/Unmark Item" todo-toggle-mark-item t]
     ["Move (Recategorize) Item" todo-move-item t]
     ["Delete Item"          todo-delete-item t]
     ["Mark and Bury Done Item" todo-item-done t]
     ["Undo Done Item" todo-item-undone t]
     ["Archive Done Item" todo-archive-done-item t]
     "---"
     ["Add New Category" todo-add-category t]
     ["Rename Current Category" todo-rename-category t]
     ["Delete Current Category" todo-delete-category t]
     ["Move Current Category" todo-move-category t]
     ["Merge Current Category" todo-merge-category t]
     "---"
     ["Add New Todo File" todo-add-file t]
     ["Rename Todo File" todo-rename-file t]
     ["Delete Todo File" todo-delete-file t]
     ["Edit Todo File" todo-edit-file t]
     )
    ("Searching and Item Filtering"
     ["Search Todo File" todo-search t]
     ["Clear Match Highlighting" todo-clear-matches t]
     "---"
     ["Set Top Priorities in File" todo-set-top-priorities-in-file t]
     ["Set Top Priorities in Category" todo-set-top-priorities-in-category t]
     ["Filter Top Priorities" todo-filter-top-priorities t]
     ["Filter Multifile Top Priorities" todo-filter-top-priorities-multifile t]
     ["Filter Diary Items" todo-filter-diary-items t]
     ["Filter Multifile Diary Items" todo-filter-diary-items-multifile t]
     ["Filter Regexp" todo-filter-regexp-items t]
     ["Filter Multifile Regexp" todo-filter-regexp-items-multifile t]
     )
    ("Display and Printing"
     ["Show/Hide Done Items" todo-toggle-view-done-items t]
     ["Show/Hide Done Items Only" todo-toggle-view-done-only t]
     ["Show/Hide Item Highlighting" todo-toggle-item-highlighting t]
     ["Show/Hide Item Numbering" todo-toggle-prefix-numbers t]
     ["Show/Hide Item Header" todo-toggle-item-header t]
     "---"
     ["Display Table of Categories" todo-show-categories-table t]
     "---"
     ["Print Category" todo-print-buffer t]
     ["Print Category to File" todo-print-buffer-to-file t]
     )
    "---"
    ["Save Todo File" todo-save t]
    ["Quit Todo Mode" todo-quit t]
    ))

;; -----------------------------------------------------------------------------
;;; Hook functions and mode definitions
;; -----------------------------------------------------------------------------

(defun todo-show-current-file ()
  "Visit current instead of default todo file with `todo-show'.
Added to `pre-command-hook' in Todo mode when user option
`todo-show-current-file' is set to non-nil."
  (setq todo-global-current-todo-file todo-current-todo-file))

;; (defun todo-display-as-todo-file ()
;;   "Show todo files correctly when visited from outside of Todo mode.
;; Added to `find-file-hook' in Todo mode and Todo Archive mode."
;;   (and (member this-command todo-visit-files-commands)
;;        (= (- (point-max) (point-min)) (buffer-size))
;;        (member major-mode '(todo-mode todo-archive-mode))
;;        (todo-category-select)))

;; (defun todo-add-to-buffer-list ()
;;   "Add name of just visited todo file to `todo-file-buffers'.
;; This function is added to `find-file-hook' in Todo mode."
;;   (let ((filename (file-truename (buffer-file-name))))
;;     (when (member filename todo-files)
;;       (add-to-list 'todo-file-buffers filename))))

(defun todo-update-buffer-list ()
  "Make current Todo mode buffer file car of `todo-file-buffers'.
This function is added to `post-command-hook' in Todo mode."
  (let ((filename (file-truename (buffer-file-name))))
    (unless (eq (car todo-file-buffers) filename)
      (setq todo-file-buffers
	    (cons filename (delete filename todo-file-buffers))))))

(defun todo-reset-global-current-todo-file ()
  "Update the value of `todo-global-current-todo-file'.
This becomes the latest existing todo file or, if there is none,
the value of `todo-default-todo-file'.
This function is added to `kill-buffer-hook' in Todo mode."
  (let ((filename (file-truename (buffer-file-name))))
    (setq todo-file-buffers (delete filename todo-file-buffers))
    (setq todo-global-current-todo-file
	  (or (car todo-file-buffers)
	      (todo-absolute-file-name todo-default-todo-file)))))

(defun todo-reset-and-enable-done-separator ()
  "Show resized done items separator overlay after window change.
Added to `window-configuration-change-hook' in Todo mode."
  (when (= 1 (length todo-done-separator-string))
    (let ((sep todo-done-separator))
      (setq todo-done-separator (todo-done-separator))
      (save-match-data (todo-reset-done-separator sep)))))

(defun todo-modes-set-1 ()
  "Make some settings that apply to multiple Todo modes."
  (setq-local font-lock-defaults '(todo-font-lock-keywords t))
  (setq-local tab-width todo-indent-to-here)
  (setq-local indent-line-function 'todo-indent)
  (when todo-wrap-lines
    (visual-line-mode)
    (setq wrap-prefix (make-string todo-indent-to-here 32))))

(defun todo-modes-set-2 ()
  "Make some settings that apply to multiple Todo modes."
  (add-to-invisibility-spec 'todo)
  (setq buffer-read-only t)
  (when (and (boundp 'desktop-save-mode) desktop-save-mode)
    (setq-local desktop-save-buffer 'todo-desktop-save-buffer))
  (when (boundp 'hl-line-range-function)
    (setq-local hl-line-range-function
		(lambda() (save-excursion
			    (when (todo-item-end)
			      (cons (todo-item-start)
				    (todo-item-end))))))))

(defun todo-modes-set-3 ()
  "Make some settings that apply to multiple Todo modes."
  (setq-local todo-categories (todo-set-categories))
  (setq-local todo-category-number 1)
  ;; (add-hook 'find-file-hook 'todo-display-as-todo-file nil t)
  )

(put 'todo-mode 'mode-class 'special)

;;;###autoload
(define-derived-mode todo-mode special-mode "Todo"
  "Major mode for displaying, navigating and editing todo lists.

\\{todo-mode-map}"
  ;; (easy-menu-add todo-menu)
  (todo-modes-set-1)
  (todo-modes-set-2)
  (todo-modes-set-3)
  ;; Initialize todo-current-todo-file.
  (when (member (file-truename (buffer-file-name))
		(funcall todo-files-function))
    (setq-local todo-current-todo-file (file-truename (buffer-file-name))))
  (setq-local todo-show-done-only nil)
  (setq-local todo-categories-with-marks nil)
  ;; (add-hook 'find-file-hook 'todo-add-to-buffer-list nil t)
  (add-hook 'post-command-hook 'todo-update-buffer-list nil t)
  (when todo-show-current-file
    (add-hook 'pre-command-hook 'todo-show-current-file nil t))
  (add-hook 'window-configuration-change-hook
	    'todo-reset-and-enable-done-separator nil t)
  (add-hook 'kill-buffer-hook 'todo-reset-global-current-todo-file nil t))

(put 'todo-archive-mode 'mode-class 'special)

;; If todo-mode is parent, all todo-mode key bindings appear to be
;; available in todo-archive-mode (e.g. shown by C-h m).
;;;###autoload
(define-derived-mode todo-archive-mode special-mode "Todo-Arch"
  "Major mode for archived todo categories.

\\{todo-archive-mode-map}"
  (todo-modes-set-1)
  (todo-modes-set-2)
  (todo-modes-set-3)
  (setq-local todo-current-todo-file (file-truename (buffer-file-name)))
  (setq-local todo-show-done-only t))

(defun todo-mode-external-set ()
  "Set `todo-categories' externally to `todo-current-todo-file'."
  (setq-local todo-current-todo-file todo-global-current-todo-file)
  (let ((cats (with-current-buffer
		  ;; Can't use find-buffer-visiting when
		  ;; `todo-show-categories-table' is called on first
		  ;; invocation of `todo-show', since there is then
		  ;; no buffer visiting the current file.
		  (find-file-noselect todo-current-todo-file 'nowarn)
		(or todo-categories
		    ;; In Todo Edit mode todo-categories is now nil
		    ;; since it uses same buffer as Todo mode but
		    ;; doesn't have the latter's local variables.
		    (save-excursion
		      (goto-char (point-min))
		      (read (buffer-substring-no-properties
			     (line-beginning-position)
			     (line-end-position))))))))
    (setq-local todo-categories cats)))

(define-derived-mode todo-edit-mode text-mode "Todo-Ed"
  "Major mode for editing multiline todo items.

\\{todo-edit-mode-map}"
  (todo-modes-set-1)
  (todo-mode-external-set)
  (setq buffer-read-only nil))

(put 'todo-categories-mode 'mode-class 'special)

(define-derived-mode todo-categories-mode special-mode "Todo-Cats"
  "Major mode for displaying and editing todo categories.

\\{todo-categories-mode-map}"
  (todo-mode-external-set))

(put 'todo-filtered-items-mode 'mode-class 'special)

;;;###autoload
(define-derived-mode todo-filtered-items-mode special-mode "Todo-Fltr"
  "Mode for displaying and reprioritizing top priority Todo.

\\{todo-filtered-items-mode-map}"
  (todo-modes-set-1)
  (todo-modes-set-2))

;; -----------------------------------------------------------------------------
(provide 'todo-mode)

;;; todo-mode.el ends here
