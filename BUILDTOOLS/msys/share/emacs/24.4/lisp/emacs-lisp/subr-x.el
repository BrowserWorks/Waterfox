;;; subr-x.el --- extra Lisp functions  -*- lexical-binding:t -*-

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Maintainer: emacs-devel@gnu.org
;; Keywords: convenience
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

;; Less commonly used functions that complement basic APIs, often implemented in
;; C code (like hash-tables and strings), and are not eligible for inclusion
;; in subr.el.

;; Do not document these functions in the lispref.
;; http://lists.gnu.org/archive/html/emacs-devel/2014-01/msg01006.html

;;; Code:

(defsubst hash-table-keys (hash-table)
  "Return a list of keys in HASH-TABLE."
  (let ((keys '()))
    (maphash (lambda (k _v) (push k keys)) hash-table)
    keys))

(defsubst hash-table-values (hash-table)
  "Return a list of values in HASH-TABLE."
  (let ((values '()))
    (maphash (lambda (_k v) (push v values)) hash-table)
    values))

(defsubst string-empty-p (string)
  "Check whether STRING is empty."
  (string= string ""))

(defsubst string-join (strings &optional separator)
  "Join all STRINGS using SEPARATOR."
  (mapconcat 'identity strings separator))

(defsubst string-reverse (str)
  "Reverse the string STR."
  (apply 'string (nreverse (string-to-list str))))

(defsubst string-trim-left (string)
  "Remove leading whitespace from STRING."
  (if (string-match "\\`[ \t\n\r]+" string)
      (replace-match "" t t string)
    string))

(defsubst string-trim-right (string)
  "Remove trailing whitespace from STRING."
  (if (string-match "[ \t\n\r]+\\'" string)
      (replace-match "" t t string)
    string))

(defsubst string-trim (string)
  "Remove leading and trailing whitespace from STRING."
  (string-trim-left (string-trim-right string)))

(defsubst string-blank-p (string)
  "Check whether STRING is either empty or only whitespace."
  (string-match-p "\\`[ \t\n\r]*\\'" string))

(defsubst string-remove-prefix (prefix string)
  "Remove PREFIX from STRING if present."
  (if (string-prefix-p prefix string)
      (substring string (length prefix))
    string))

(defsubst string-remove-suffix (suffix string)
  "Remove SUFFIX from STRING if present."
  (if (string-suffix-p suffix string)
      (substring string 0 (- (length string) (length suffix)))
    string))

(provide 'subr-x)

;;; subr-x.el ends here
