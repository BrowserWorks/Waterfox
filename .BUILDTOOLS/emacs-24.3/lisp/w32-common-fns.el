;;; w32-common-fns.el --- Lisp routines for Windows and Cygwin-w32

;; Copyright (C) 1994, 2001-2013 Free Software Foundation, Inc.

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
;;;
;;; This file contains functions that are used by both native NT Emacs
;;; and Cygwin Emacs compiled to use the native Windows widget
;;; library.

(defun w32-version ()
  "Return the MS-Windows version numbers.
The value is a list of three integers: the major and minor version
numbers, and the build number."
  (x-server-version))

(defun w32-using-nt ()
  "Return non-nil if running on a Windows NT descendant.
That includes all Windows systems except for 9X/Me."
  (getenv "SystemRoot"))

(declare-function w32-get-clipboard-data "w32select.c")
(declare-function w32-set-clipboard-data "w32select.c")
(declare-function x-server-version "w32fns.c" (&optional display))

;;; Fix interface to (X-specific) mouse.el
(defun x-set-selection (type data)
  "Make an X selection of type TYPE and value DATA.
The argument TYPE (nil means `PRIMARY') says which selection, and
DATA specifies the contents.  TYPE must be a symbol.  \(It can also
be a string, which stands for the symbol with that name, but this
is considered obsolete.)  DATA may be a string, a symbol, an
integer (or a cons of two integers or list of two integers).

The selection may also be a cons of two markers pointing to the same buffer,
or an overlay.  In these cases, the selection is considered to be the text
between the markers *at whatever time the selection is examined*.
Thus, editing done in the buffer after you specify the selection
can alter the effective value of the selection.

The data may also be a vector of valid non-vector selection values.

The return value is DATA.

Interactively, this command sets the primary selection.  Without
prefix argument, it reads the selection in the minibuffer.  With
prefix argument, it uses the text of the region as the selection value.

Note that on MS-Windows, primary and secondary selections set by Emacs
are not available to other programs."
  (put 'x-selections (or type 'PRIMARY) data))

(defun x-get-selection (&optional type _data-type)
  "Return the value of an X Windows selection.
The argument TYPE (default `PRIMARY') says which selection,
and the argument DATA-TYPE (default `STRING') says
how to convert the data.

TYPE may be any symbol \(but nil stands for `PRIMARY').  However,
only a few symbols are commonly used.  They conventionally have
all upper-case names.  The most often used ones, in addition to
`PRIMARY', are `SECONDARY' and `CLIPBOARD'.

DATA-TYPE is usually `STRING', but can also be one of the symbols
in `selection-converter-alist', which see."
  (get 'x-selections (or type 'PRIMARY)))

;; x-selection-owner-p is used in simple.el
(defun x-selection-owner-p (&optional type)
  (and (memq type '(nil PRIMARY SECONDARY))
       (get 'x-selections (or type 'PRIMARY))))

;; The "Windows" keys on newer keyboards bring up the Start menu
;; whether you want it or not - make Emacs ignore these keystrokes
;; rather than beep.
(global-set-key [lwindow] 'ignore)
(global-set-key [rwindow] 'ignore)

(defvar w32-charset-info-alist)		; w32font.c


;;;; Selections

;; We keep track of the last text selected here, so we can check the
;; current selection against it, and avoid passing back our own text
;; from x-selection-value.
(defvar x-last-selected-text nil)

(defun x-get-selection-value ()
  "Return the value of the current selection.
Consult the selection.  Treat empty strings as if they were unset."
  (if x-select-enable-clipboard
      (let (text)
	;; Don't die if x-get-selection signals an error.
	(condition-case c
	    (setq text (w32-get-clipboard-data))
	  (error (message "w32-get-clipboard-data:%s" c)))
	(if (string= text "") (setq text nil))
	(cond
	 ((not text) nil)
	 ((eq text x-last-selected-text) nil)
	 ((string= text x-last-selected-text)
	  ;; Record the newer string, so subsequent calls can use the 'eq' test.
	  (setq x-last-selected-text text)
	  nil)
	 (t
	  (setq x-last-selected-text text))))))

(defalias 'x-selection-value 'x-get-selection-value)

;; Arrange for the kill and yank functions to set and check the clipboard.
(setq interprogram-cut-function 'x-select-text)
(setq interprogram-paste-function 'x-get-selection-value)

(provide 'w32-common-fns)
