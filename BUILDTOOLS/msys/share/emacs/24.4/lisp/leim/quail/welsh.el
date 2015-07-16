;;; welsh.el --- Quail package for inputting Welsh characters  -*-coding: utf-8;-*-

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.

;; Author: Dave Love <fx@gnu.org>
;; Keywords: i18n

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

;; Welsh input following the Yudit map by david@sheetmusic.org.uk.

;;; Code:

(require 'quail)

(quail-define-package
 "welsh" "Welsh" "Ŵ" t
 "Welsh postfix input method"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("A\\" ?À)
 ("A/" ?Á)
 ("A^" ?Â)
 ("A+" ?Â)
 ("A\"" ?Ä)
 ("a\\" ?à)
 ("a/" ?á)
 ("a^" ?â)
 ("a+" ?â)
 ("a\"" ?ä)

 ("E\\" ?È)
 ("E/" ?É)
 ("E^" ?Ê)
 ("E+" ?Ê)
 ("E\"" ?Ë)
 ("e\\" ?è)
 ("e/" ?é)
 ("e^" ?ê)
 ("e+" ?ê)
 ("e\"" ?ë)

 ("I\\" ?Ì)
 ("I/" ?Í)
 ("I^" ?Î)
 ("I+" ?Î)
 ("I\"" ?Ï)
 ("i\\" ?ì)
 ("i/" ?í)
 ("i^" ?î)
 ("i+" ?î)
 ("i\"" ?ï)

 ("O\\" ?Ò)
 ("O/" ?Ó)
 ("O^" ?Ô)
 ("O+" ?Ô)
 ("O\"" ?Ö)
 ("o\\" ?ò)
 ("o/" ?ó)
 ("o^" ?ô)
 ("o+" ?ô)
 ("o\"" ?ö)

 ("U\\" ?Ù)
 ("U/" ?Ú)
 ("U^" ?Û)
 ("U+" ?Û)
 ("U\"" ?Ü)
 ("u\\" ?ù)
 ("u/" ?ú)
 ("u^" ?û)
 ("u+" ?û)
 ("u\"" ?ü)

 ("Y\\" ?Ỳ)
 ("Y/" ?Ý)
 ("Y^" ?Ŷ)
 ("Y+" ?Ŷ)
 ("Y\"" ?Ÿ)
 ("y\\" ?ỳ)
 ("y/" ?ý)
 ("y\"" ?ÿ)
 ("y^" ?ŷ)
 ("y+" ?ŷ)

 ("W\\" ?Ẁ)
 ("W/" ?Ẃ)
 ("W^" ?Ŵ)
 ("W+" ?Ŵ)
 ("W\"" ?Ẅ)
 ("w\\" ?ẁ)
 ("w/" ?ẃ)
 ("w^" ?ŵ)
 ("w+" ?ŵ)
 ("w\"" ?ẅ)

 ;; "hawlfraint" (copyright).  Dyma arwyddlun hawlfraint.
 ("(h)" ?ⓗ))

;; (quail-define-package
;;  "welsh" "Welsh" "Ŵ" t
;;  "Welsh postfix input method, using Latin-8"
;;  nil t nil nil nil nil nil nil nil nil t)

;; (quail-define-rules
;;  ("A\\" ?À)
;;  ("A/" ?Á)
;;  ("A^" ?Â)
;;  ("A+" ?Â)
;;  ("A\"" ?Ä)
;;  ("a\\" ?à)
;;  ("a/" ?á)
;;  ("a^" ?â)
;;  ("a+" ?â)
;;  ("a\"" ?ä)

;;  ("E\\" ?È)
;;  ("E/" ?É)
;;  ("E^" ?Ê)
;;  ("E+" ?Ê)
;;  ("E\"" ?Ë)
;;  ("e\\" ?è)
;;  ("e/" ?é)
;;  ("e^" ?ê)
;;  ("e+" ?ê)
;;  ("e\"" ?ë)

;;  ("I\\" ?Ì)
;;  ("I/" ?Í)
;;  ("I^" ?Î)
;;  ("I+" ?Î)
;;  ("I\"" ?Ï)
;;  ("i\\" ?ì)
;;  ("i/" ?í)
;;  ("i^" ?î)
;;  ("i+" ?î)
;;  ("i\"" ?ï)

;;  ("O\\" ?Ò)
;;  ("O/" ?Ó)
;;  ("O^" ?Ô)
;;  ("O+" ?Ô)
;;  ("O\"" ?Ö)
;;  ("o\\" ?ò)
;;  ("o/" ?ó)
;;  ("o^" ?ô)
;;  ("o+" ?ô)
;;  ("o\"" ?ö)

;;  ("U\\" ?Ù)
;;  ("U/" ?Ú)
;;  ("U^" ?Û)
;;  ("U+" ?Û)
;;  ("U\"" ?Ü)
;;  ("u\\" ?ù)
;;  ("u/" ?ú)
;;  ("u^" ?û)
;;  ("u+" ?û)
;;  ("u\"" ?ü)

;;  ("Y\\" ?¬)
;;  ("Y/" ?Ý)
;;  ("Y^" ?Þ)
;;  ("Y+" ?Þ)
;;  ("Y\"" ?¯)
;;  ("y\\" ?¼)
;;  ("y/" ?ý)
;;  ("y\"" ?ÿ)
;;  ("y^" ?þ)
;;  ("y+" ?þ)

;;  ("W\\" ?¨)
;;  ("W/" ?ª)
;;  ("W^" ?Ð)
;;  ("W+" ?Ð)
;;  ("W\"" ?½)
;;  ("w\\" ?¸)
;;  ("w/" ?º)
;;  ("w^" ?ð)
;;  ("w+" ?ð)
;;  ("w\"" ?¾))


;;; welsh.el ends here
