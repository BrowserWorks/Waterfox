;;; lao.el --- Quail package for inputting Lao characters  -*-coding: utf-8;-*-

;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;   2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Keywords: multilingual, input method, Lao

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

(require 'quail)
(require 'lao-util)

(defun quail-lao-update-translation (control-flag)
  (if (integerp control-flag)
      ;; Non-composable character typed.
      (setq quail-current-str
	    (buffer-substring (overlay-start quail-overlay)
			      (overlay-end quail-overlay))
	    unread-command-events
	    (string-to-list
	     (substring quail-current-key control-flag)))
    (setq quail-current-str
	  (compose-string (quail-lookup-map-and-concat quail-current-key))))
  control-flag)

(defvar lao-key-alist
  '(("!" . "1")
    ("\"" . "=")
    ("#" . "3")
    ("$" . "4")
    ("&" . "5")
    ("%" . "໌")
    ("'" . "ງ")
    ("(" . "7")
    (")" . "8")
    ("*" . "6")
    ("+" . ["ໍ່"])
    ("," . "ມ")
    ("-" . "ຊ")
    ("." . "ໃ")
    ("/" . "ຝ")
    ("0" . "ຂ")
    ("1" . "ຢ")
    ("2" . "ຟ")
    ("3" . "ໂ")
    ("4" . "ຖ")
    ("5" . "ຸ")
    ("6" . "ູ")
    ("7" . "ຄ")
    ("8" . "ຕ")
    ("9" . "ຈ")
    (":" . "%")
    (";" . "ວ")
    ("<" . "ໝ")
    ("=" . "ໍ")
    (">" . "$")
    ("?" . ")")
    ("@" . "2")
    ("A" . ["ັ້"])
    ("B" . ["ຶ້"])
    ("C" . "ຯ")
    ("D" . ".")
    ("E" . ["ຳ້"])
    ("F" . ",")
    ("G" . ":")
    ("H" . "໊")
    ("I" . "ຮ")
    ("J" . "໋")
    ("K" . "!")
    ("L" . "?")
    ("M" . "ໆ")
    ("N" . ["ື້"])
    ("O" . "ໜ")
    ("P" . "ຽ")
    ("Q" . ["ົ້"])
    ("R" . "_")
    ("S" . ";")
    ("T" . "+")
    ("U" . ["ີ້"])
    ("V" . "x")
    ("W" . "0")
    ("X" . "(")
    ("Y" . ["ິ້"])
    ("Z" . "\"")
    ("[" . "ບ")
    ("]" . "ລ")
    ("^" . "ຼ")
    ("_" . "9")
    ("`" . "ງ")
    ("a" . "ັ")
    ("b" . "ຶ")
    ("c" . "ແ")
    ("d" . "ກ")
    ("e" . "ຳ")
    ("f" . "ດ")
    ("g" . "ເ")
    ("h" . "້")
    ("i" . "ຣ")
    ("j" . "່")
    ("k" . "າ")
    ("l" . "ສ")
    ("m" . "ທ")
    ("n" . "ື")
    ("o" . "ນ")
    ("p" . "ຍ")
    ("q" . "ົ")
    ("r" . "ພ")
    ("s" . "ຫ")
    ("t" . "ະ")
    ("u" . "ີ")
    ("v" . "ອ")
    ("w" . "ໄ")
    ("x" . "ປ")
    ("y" . "ິ")
    ("z" . "ຜ")
    ("{" . "-")
    ("|" . ["ຫຼ"])
    ("}" . "/")
    ("~" . "໌")
    ("\\0" . "໐")
    ("\\1" . "໑")
    ("\\2" . "໒")
    ("\\3" . "໓")
    ("\\4" . "໔")
    ("\\5" . "໕")
    ("\\6" . "໖")
    ("\\7" . "໗")
    ("\\8" . "໘")
    ("\\9" . "໙")
    )
  "Alist of key sequences vs the corresponding Lao string to input.
This variable is for the input method \"lao\".
If you change the value of this variable while quail/lao is already loaded,
you need to re-load it to properly re-initialize related alists.")

;; Temporary variable to initialize lao-consonant-key-alist, etc.
(defconst lao-key-alist-vector
  (let ((tail lao-key-alist)
	consonant-key-alist semivowel-key-alist vowel-key-alist
	voweltone-key-alist tone-key-alist other-key-alist
	elt phonetic-type)
    (while tail
      (setq elt (car tail) tail (cdr tail))
      (if (stringp (cdr elt))
	  (setq phonetic-type (get-char-code-property (aref (cdr elt) 0)
						      'phonetic-type))
	(setq phonetic-type (get-char-code-property (aref (aref (cdr elt) 0) 0)
						    'phonetic-type))
	(aset (cdr elt) 0 (compose-string (aref (cdr elt) 0))))
      (cond ((eq phonetic-type 'consonant)
	     (setq consonant-key-alist (cons elt consonant-key-alist)))
	    ((memq phonetic-type '(vowel-upper vowel-lower))
	     (if (stringp (cdr elt))
		 (setq vowel-key-alist (cons elt vowel-key-alist))
	       (setq voweltone-key-alist (cons elt voweltone-key-alist))))
	    ((eq  phonetic-type 'tone)
	     (setq tone-key-alist (cons elt tone-key-alist)))
	    ((eq phonetic-type 'semivowel-lower)
	     (setq semivowel-key-alist (cons elt semivowel-key-alist)))
	    (t
	     (setq other-key-alist (cons elt other-key-alist)))))
    (vector consonant-key-alist semivowel-key-alist vowel-key-alist
	    voweltone-key-alist tone-key-alist other-key-alist)))

(defconst lao-consonant-key-alist (aref lao-key-alist-vector 0))
(defconst lao-semivowel-key-alist (aref lao-key-alist-vector 1))
(defconst lao-vowel-key-alist (aref lao-key-alist-vector 2))
(defconst lao-voweltone-key-alist (aref lao-key-alist-vector 3))
(defconst lao-tone-key-alist (aref lao-key-alist-vector 4))
(defconst lao-other-key-alist (aref lao-key-alist-vector 5))

;; Done with it.
(makunbound 'lao-key-alist-vector)

(quail-define-package
 "lao" "Lao" "ລ" t
 "Lao input method simulating Lao keyboard layout based on Thai TIS620"
 nil t t t t nil nil nil 'quail-lao-update-translation nil t)

(quail-install-map
 (quail-map-from-table
  '((base-state (lao-consonant-key-alist . svt-state)
		lao-vowel-key-alist
		lao-voweltone-key-alist
		lao-tone-key-alist
		lao-other-key-alist)
    (svt-state (lao-semivowel-key-alist . v-state)
	       (lao-vowel-key-alist . t-state)
	       lao-voweltone-key-alist
	       lao-tone-key-alist)
    (v-state (lao-vowel-key-alist . t-state))
    (t-state lao-tone-key-alist))))

;;; lao.el ends here
