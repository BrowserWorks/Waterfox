;;; mule-util.el --- utility functions for multilingual environment (mule)

;; Copyright (C) 1997-1998, 2000-2014 Free Software Foundation, Inc.
;; Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021
;; Copyright (C) 2003
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H13PRO009

;; Keywords: mule, multilingual

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

;;; String manipulations while paying attention to multibyte
;;; characters.

;;;###autoload
(defsubst string-to-list (string)
  "Return a list of characters in STRING."
  (append string nil))

;;;###autoload
(defsubst string-to-vector (string)
  "Return a vector of characters in STRING."
  (vconcat string))

;;;###autoload
(defun store-substring (string idx obj)
  "Embed OBJ (string or character) at index IDX of STRING."
  (if (integerp obj)
      (aset string idx obj)
    (let ((len1 (length obj))
	  (len2 (length string))
	  (i 0))
      (while (< i len1)
	(aset string (+ idx i) (aref obj i))
	(setq i (1+ i)))))
  string)

;;;###autoload
(defun truncate-string-to-width (str end-column
				     &optional start-column padding ellipsis)
  "Truncate string STR to end at column END-COLUMN.
The optional 3rd arg START-COLUMN, if non-nil, specifies the starting
column; that means to return the characters occupying columns
START-COLUMN ... END-COLUMN of STR.  Both END-COLUMN and START-COLUMN
are specified in terms of character display width in the current
buffer; see also `char-width'.

The optional 4th arg PADDING, if non-nil, specifies a padding
character (which should have a display width of 1) to add at the end
of the result if STR doesn't reach column END-COLUMN, or if END-COLUMN
comes in the middle of a character in STR.  PADDING is also added at
the beginning of the result if column START-COLUMN appears in the
middle of a character in STR.

If PADDING is nil, no padding is added in these cases, so
the resulting string may be narrower than END-COLUMN.

If ELLIPSIS is non-nil, it should be a string which will replace the
end of STR (including any padding) if it extends beyond END-COLUMN,
unless the display width of STR is equal to or less than the display
width of ELLIPSIS.  If it is non-nil and not a string, then ELLIPSIS
defaults to \"...\"."
  (or start-column
      (setq start-column 0))
  (when (and ellipsis (not (stringp ellipsis)))
    (setq ellipsis "..."))
  (let ((str-len (length str))
	(str-width (string-width str))
	(ellipsis-len (if ellipsis (length ellipsis) 0))
	(ellipsis-width (if ellipsis (string-width ellipsis) 0))
	(idx 0)
	(column 0)
	(head-padding "") (tail-padding "")
	ch last-column last-idx from-idx)
    (condition-case nil
	(while (< column start-column)
	  (setq ch (aref str idx)
		column (+ column (char-width ch))
		idx (1+ idx)))
      (args-out-of-range (setq idx str-len)))
    (if (< column start-column)
	(if padding (make-string end-column padding) "")
      (when (and padding (> column start-column))
	(setq head-padding (make-string (- column start-column) padding)))
      (setq from-idx idx)
      (when (>= end-column column)
	(if (and (< end-column str-width)
		 (> str-width ellipsis-width))
	    (setq end-column (- end-column ellipsis-width))
	  (setq ellipsis ""))
	(condition-case nil
	    (while (< column end-column)
	      (setq last-column column
		    last-idx idx
		    ch (aref str idx)
		    column (+ column (char-width ch))
		    idx (1+ idx)))
	  (args-out-of-range (setq idx str-len)))
	(when (> column end-column)
	  (setq column last-column
		idx last-idx))
	(when (and padding (< column end-column))
	  (setq tail-padding (make-string (- end-column column) padding))))
      (concat head-padding (substring str from-idx idx)
	      tail-padding ellipsis))))


;;; Nested alist handler.  Nested alist is alist whose elements are
;;; also nested alist.

;;;###autoload
(defsubst nested-alist-p (obj)
  "Return t if OBJ is a nested alist.

Nested alist is a list of the form (ENTRY . BRANCHES), where ENTRY is
any Lisp object, and BRANCHES is a list of cons cells of the form
\(KEY-ELEMENT . NESTED-ALIST).

You can use a nested alist to store any Lisp object (ENTRY) for a key
sequence KEYSEQ, where KEYSEQ is a sequence of KEY-ELEMENT.  KEYSEQ
can be a string, a vector, or a list."
  (and obj (listp obj) (listp (cdr obj))))

;;;###autoload
(defun set-nested-alist (keyseq entry alist &optional len branches)
  "Set ENTRY for KEYSEQ in a nested alist ALIST.
Optional 4th arg LEN non-nil means the first LEN elements in KEYSEQ
 are considered.
Optional 5th argument BRANCHES if non-nil is branches for a keyseq
longer than KEYSEQ.
See the documentation of `nested-alist-p' for more detail."
  (or (nested-alist-p alist)
      (error "Invalid argument %s" alist))
  (let ((islist (listp keyseq))
	(len (or len (length keyseq)))
	(i 0)
	key-elt slot)
    (while (< i len)
      (if (null (nested-alist-p alist))
	  (error "Keyseq %s is too long for this nested alist" keyseq))
      (setq key-elt (if islist (nth i keyseq) (aref keyseq i)))
      (setq slot (assoc key-elt (cdr alist)))
      (unless slot
	(setq slot (cons key-elt (list t)))
	(setcdr alist (cons slot (cdr alist))))
      (setq alist (cdr slot))
      (setq i (1+ i)))
    (setcar alist entry)
    (if branches
	(setcdr (last alist) branches))))

;;;###autoload
(defun lookup-nested-alist (keyseq alist &optional len start nil-for-too-long)
  "Look up key sequence KEYSEQ in nested alist ALIST.  Return the definition.
Optional 3rd argument LEN specifies the length of KEYSEQ.
Optional 4th argument START specifies index of the starting key.
The returned value is normally a nested alist of which
car part is the entry for KEYSEQ.
If ALIST is not deep enough for KEYSEQ, return number which is
 how many key elements at the front of KEYSEQ it takes
 to reach a leaf in ALIST.
Optional 5th argument NIL-FOR-TOO-LONG non-nil means return nil
 even if ALIST is not deep enough."
  (or (nested-alist-p alist)
      (error "Invalid argument %s" alist))
  (or len
      (setq len (length keyseq)))
  (let ((i (or start 0)))
    (if (catch 'lookup-nested-alist-tag
	  (if (listp keyseq)
	      (while (< i len)
		(if (setq alist (cdr (assoc (nth i keyseq) (cdr alist))))
		    (setq i (1+ i))
		  (throw 'lookup-nested-alist-tag t))))
	  (while (< i len)
	    (if (setq alist (cdr (assoc (aref keyseq i) (cdr alist))))
		(setq i (1+ i))
	      (throw 'lookup-nested-alist-tag t))))
	;; KEYSEQ is too long.
	(if nil-for-too-long nil i)
      alist)))


;; Coding system related functions.

;;;###autoload
(defun coding-system-post-read-conversion (coding-system)
  "Return the value of CODING-SYSTEM's `post-read-conversion' property."
  (coding-system-get coding-system :post-read-conversion))

;;;###autoload
(defun coding-system-pre-write-conversion (coding-system)
  "Return the value of CODING-SYSTEM's `pre-write-conversion' property."
  (coding-system-get coding-system :pre-write-conversion))

;;;###autoload
(defun coding-system-translation-table-for-decode (coding-system)
  "Return the value of CODING-SYSTEM's `decode-translation-table' property."
  (coding-system-get coding-system :decode-translation-table))

;;;###autoload
(defun coding-system-translation-table-for-encode (coding-system)
  "Return the value of CODING-SYSTEM's `encode-translation-table' property."
  (coding-system-get coding-system :encode-translation-table))

;;;###autoload
(defmacro with-coding-priority (coding-systems &rest body)
  "Execute BODY like `progn' with CODING-SYSTEMS at the front of priority list.
CODING-SYSTEMS is a list of coding systems.  See `set-coding-system-priority'.
This affects the implicit sorting of lists of coding systems returned by
operations such as `find-coding-systems-region'."
  (let ((current (make-symbol "current")))
  `(let ((,current (coding-system-priority-list)))
     (apply #'set-coding-system-priority ,coding-systems)
     (unwind-protect
	 (progn ,@body)
       (apply #'set-coding-system-priority ,current)))))
;;;###autoload(put 'with-coding-priority 'lisp-indent-function 1)
(put 'with-coding-priority 'edebug-form-spec t)

;;;###autoload
(defmacro detect-coding-with-priority (from to priority-list)
  "Detect a coding system of the text between FROM and TO with PRIORITY-LIST.
PRIORITY-LIST is an alist of coding categories vs the corresponding
coding systems ordered by priority."
  (declare (obsolete with-coding-priority "23.1"))
  `(with-coding-priority (mapcar #'cdr ,priority-list)
     (detect-coding-region ,from ,to)))

;;;###autoload
(defun detect-coding-with-language-environment (from to lang-env)
  "Detect a coding system for the text between FROM and TO with LANG-ENV.
The detection takes into account the coding system priorities for the
language environment LANG-ENV."
  (let ((coding-priority (get-language-info lang-env 'coding-priority)))
    (if coding-priority
	(with-coding-priority coding-priority
          (detect-coding-region from to)))))

(declare-function internal-char-font "fontset.c" (position &optional ch))

;;;###autoload
(defun char-displayable-p (char)
  "Return non-nil if we should be able to display CHAR.
On a multi-font display, the test is only whether there is an
appropriate font from the selected frame's fontset to display
CHAR's charset in general.  Since fonts may be specified on a
per-character basis, this may not be accurate."
  (cond ((< char 128)
	 ;; ASCII characters are always displayable.
	 t)
	((not enable-multibyte-characters)
	 ;; Maybe there's a font for it, but we can't put it in the buffer.
	 nil)
	((display-multi-font-p)
	 ;; On a window system, a character is displayable if we have
	 ;; a font for that character in the default face of the
	 ;; currently selected frame.
	 (car (internal-char-font nil char)))
	(t
	 ;; On a terminal, a character is displayable if the coding
	 ;; system for the terminal can encode it.
	 (let ((coding (terminal-coding-system)))
	   (when coding
	     (let ((cs-list (coding-system-get coding :charset-list)))
	       (cond
		 ((listp cs-list)
		  (catch 'tag
		    (mapc #'(lambda (charset)
			      (if (encode-char char charset)
				  (throw 'tag charset)))
			  cs-list)
		    nil))
		 ((eq cs-list 'iso-2022)
		  (catch 'tag2
		    (mapc #'(lambda (charset)
			      (if (and (plist-get (charset-plist charset)
						  :iso-final-char)
				       (encode-char char charset))
				  (throw 'tag2 charset)))
			  charset-list)
		    nil))
		 ((eq cs-list 'emacs-mule)
		  (catch 'tag3
		    (mapc #'(lambda (charset)
			      (if (and (plist-get (charset-plist charset)
						  :emacs-mule-id)
				       (encode-char char charset))
				  (throw 'tag3 charset)))
			  charset-list)
		    nil)))))))))

(provide 'mule-util)

;; Local Variables:
;; coding: utf-8
;; End:

;;; mule-util.el ends here
