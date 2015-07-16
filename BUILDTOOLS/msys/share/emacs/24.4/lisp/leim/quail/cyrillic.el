;;; cyrillic.el --- Quail package for inputting Cyrillic characters

;; Copyright (C) 1997-1998, 2001-2014 Free Software Foundation, Inc.
;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;   2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Author: TAKAHASHI Naoto <ntakahas@m17n.org>
;; Keywords: multilingual, input method, Cyrillic, i18n

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

;; These methods use a mixture of 8859-5 and Unicode.  Quail, used
;; with ucs-tables provides support for translating on the fly to
;; what's appropriate for aa buffer's file coding system, so the
;; encoding shouldn't matter too much provided it supports the
;; necessary characters.

;;; Code:

(require 'quail)

;; This was `cyrillic-jcuken'.  Alexander Mikhailian
;; <mikhailian@altern.org> says:  "cyrillic-jcuken" is actually
;; russian.  It is ok but a bit outdated.  This layout has been used
;; in typewriters for ages but it has been superseded on desktops by
;; a variation of this layout, implemented in M$ Windows software.
;; The Windows layout is greatly preferred because of the comma and
;; period being placed more conveniently and, of course, because of
;; the popularity of Windows software. This layout is a common option
;; in X Windows and console layouts for GNU/Linux.  [See
;; `russian-computer' below.]
(quail-define-package
 "russian-typewriter" "Russian" "ЖЙ" nil
 "ЙЦУКЕН Russian typewriter layout (ISO 8859-5 encoding)."
 nil t t t t nil nil nil nil nil t)

;;  №1 -2 /3 "4 :5 ,6 .7 _8 ?9 %0 != ;\ |+
;;   Й  Ц  У  К  Е  Н  Г  Ш  Щ  З  Х  Ъ )(
;;    Ф  Ы  В  А  П  Р  О  Л  Д  Ж  Э
;;     Я  Ч  С  М  И  Т  Ь  Б  Ю  Ё

(quail-define-rules
 ("1" ?№)
 ("2" ?-)
 ("3" ?/)
 ("4" ?\")
 ("5" ?:)
 ("6" ?,)
 ("7" ?.)
 ("8" ?_)
 ("9" ??)
 ("0" ?%)
 ("-" ?!)
 ("=" ?\;)
 ("`" ?|)
 ("q" ?й)
 ("w" ?ц)
 ("e" ?у)
 ("r" ?к)
 ("t" ?е)
 ("y" ?н)
 ("u" ?г)
 ("i" ?ш)
 ("o" ?щ)
 ("p" ?з)
 ("[" ?х)
 ("]" ?ъ)
 ("a" ?ф)
 ("s" ?ы)
 ("d" ?в)
 ("f" ?а)
 ("g" ?п)
 ("h" ?р)
 ("j" ?о)
 ("k" ?л)
 ("l" ?д)
 (";" ?ж)
 ("'" ?э)
 ("\\" ?\))
 ("z" ?я)
 ("x" ?ч)
 ("c" ?с)
 ("v" ?м)
 ("b" ?и)
 ("n" ?т)
 ("m" ?ь)
 ("," ?б)
 ("." ?ю)
 ("/" ?ё)

 ("!" ?1)
 ("@" ?2)
 ("#" ?3)
 ("$" ?4)
 ("%" ?5)
 ("^" ?6)
 ("&" ?7)
 ("*" ?8)
 ("(" ?9)
 (")" ?0)
 ("_" ?=)
 ("+" ?\\)
 ("~" ?+)
 ("Q" ?Й)
 ("W" ?Ц)
 ("E" ?У)
 ("R" ?К)
 ("T" ?Е)
 ("Y" ?Н)
 ("U" ?Г)
 ("I" ?Ш)
 ("O" ?Щ)
 ("P" ?З)
 ("{" ?Х)
 ("}" ?Ъ)
 ("A" ?Ф)
 ("S" ?Ы)
 ("D" ?В)
 ("F" ?А)
 ("G" ?П)
 ("H" ?Р)
 ("J" ?О)
 ("K" ?Л)
 ("L" ?Д)
 (":" ?Ж)
 ("\"" ?Э)
 ("|" ?\()
 ("Z" ?Я)
 ("X" ?Ч)
 ("C" ?С)
 ("V" ?М)
 ("B" ?И)
 ("N" ?Т)
 ("M" ?Ь)
 ("<" ?Б)
 (">" ?Ю)
 ("?" ?Ё)
 )

;; Maintain the obsolete name for now.
(push (cons "cyrillic-jcuken"
	    (cdr (assoc "russian-typewriter" quail-package-alist)))
      quail-package-alist)

;; This needs to be seen by quail-update-leim-list-file, but cannot be
;; commented out because quail-update-leim-list-file ignores
;; commented-out lines.
(if nil
    (quail-define-package
     "cyrillic-jcuken" "Russian" "ЖЙ" nil
     "ЙЦУКЕН Russian typewriter layout (ISO 8859-5 encoding)."))

;; See comment above.  This is the variant `winkeys' from `ru' in XKB.
(quail-define-package
 "russian-computer" "Russian" "RU" nil
 "ЙЦУКЕН Russian computer layout"
 nil t t t t nil nil nil nil nil t)

;;  1! 2" 3№ 4; 5% 6: 7? 8* 9( 0) -_ =+ \/ ёЁ
;;   Й  Ц  У  К  Е  Н  Г  Ш  Щ  З  Х  Ъ
;;    Ф  Ы  В  А  П  Р  О  Л  Д  Ж  Э
;;     Я  Ч  С  М  И  Т  Ь  Б  Ю  .,

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?-)
 ("=" ?=)
 ("|" ?/)
 ("`" ?ё)
 ("q" ?й)
 ("w" ?ц)
 ("e" ?у)
 ("r" ?к)
 ("t" ?е)
 ("y" ?н)
 ("u" ?г)
 ("i" ?ш)
 ("o" ?щ)
 ("p" ?з)
 ("[" ?х)
 ("]" ?ъ)
 ("a" ?ф)
 ("s" ?ы)
 ("d" ?в)
 ("f" ?а)
 ("g" ?п)
 ("h" ?р)
 ("j" ?о)
 ("k" ?л)
 ("l" ?д)
 (";" ?ж)
 ("'" ?э)
 ("\\" ?\\)
 ("z" ?я)
 ("x" ?ч)
 ("c" ?с)
 ("v" ?м)
 ("b" ?и)
 ("n" ?т)
 ("m" ?ь)
 ("," ?б)
 ("." ?ю)
 ("/" ?.)
 ("!" ?!)
 ("@" ?\")
 ("#" ?№)
 ("$" ?\;)
 ("%" ?%)
 ("^" ?:)
 ("&" ??)
 ("*" ?*)
 ("(" ?()
 (")" ?))
 ("_" ?_)
 ("+" ?+)
 ("~" ?Ё)
 ("Q" ?Й)
 ("W" ?Ц)
 ("E" ?У)
 ("R" ?К)
 ("T" ?Е)
 ("Y" ?Н)
 ("U" ?Г)
 ("I" ?Ш)
 ("O" ?Щ)
 ("P" ?З)
 ("{" ?Х)
 ("}" ?Ъ)
 ("A" ?Ф)
 ("S" ?Ы)
 ("D" ?В)
 ("F" ?А)
 ("G" ?П)
 ("H" ?Р)
 ("J" ?О)
 ("K" ?Л)
 ("L" ?Д)
 (":" ?Ж)
 ("\"" ?Э)
 ("|" ?|)
 ("Z" ?Я)
 ("X" ?Ч)
 ("C" ?С)
 ("V" ?М)
 ("B" ?И)
 ("N" ?Т)
 ("M" ?Ь)
 ("<" ?Б)
 (">" ?Ю)
 ("?" ?,))

;; Mikhailian couldn't check the next two.

;; This seems to have the same layout for letters as mk in XKB, but at
;; least the top row is different.
(quail-define-package
 "cyrillic-macedonian" "Cyrillic" "ЖM" nil
 "ЉЊЕРТЗ-ЃЌ keyboard layout based on JUS.I.K1.004"
 nil t t t t nil nil nil nil nil t)

;;  1! 2" 3# 4$ 5% 6& 7' 8( 9) 0= /? +* <>
;;   Љ  Њ  Е  Р  Т  З  У  И  О  П  Ш  Ѓ
;;    А  С  Д  Ф  Г  Х  Ј  К  Л  Ч  Ќ  Ж
;;     Ѕ  Џ  Ц  В  Б  Н  М  ,; .: -_

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?/)
 ("=" ?+)
 ("`" ?<)
 ("q" ?љ)
 ("w" ?њ)
 ("e" ?е)
 ("r" ?р)
 ("t" ?т)
 ("y" ?з)
 ("u" ?у)
 ("i" ?и)
 ("o" ?о)
 ("p" ?п)
 ("[" ?ш)
 ("]" ?ѓ)
 ("a" ?а)
 ("s" ?с)
 ("d" ?д)
 ("f" ?ф)
 ("g" ?г)
 ("h" ?х)
 ("j" ?ј)
 ("k" ?к)
 ("l" ?л)
 (";" ?ч)
 ("'" ?ќ)
 ("\\" ?ж)
 ("z" ?ѕ)
 ("x" ?џ)
 ("c" ?ц)
 ("v" ?в)
 ("b" ?б)
 ("n" ?н)
 ("m" ?м)
 ("," ?,)
 ("." ?.)
 ("/" ?-)

 ("!" ?!)
 ("@" ?\")
 ("#" ?#)
 ("$" ?$)
 ("%" ?%)
 ("^" ?&)
 ("&" ?')
 ("*" ?\()
 ("(" ?\))
 (")" ?=)
 ("_" ??)
 ("+" ?*)
 ("~" ?>)
 ("Q" ?Љ)
 ("W" ?Њ)
 ("E" ?Е)
 ("R" ?Р)
 ("T" ?Т)
 ("Y" ?З)
 ("U" ?У)
 ("I" ?И)
 ("O" ?О)
 ("P" ?П)
 ("{" ?Ш)
 ("}" ?Ѓ)
 ("A" ?А)
 ("S" ?С)
 ("D" ?Д)
 ("F" ?Ф)
 ("G" ?Г)
 ("H" ?Х)
 ("J" ?Ј)
 ("K" ?К)
 ("L" ?Л)
 (":" ?Ч)
 ("\"" ?Ќ)
 ("|" ?Ж)
 ("Z" ?Ѕ)
 ("X" ?Џ)
 ("C" ?Ц)
 ("V" ?В)
 ("B" ?Б)
 ("N" ?Н)
 ("M" ?М)
 ("<" ?\;)
 (">" ?:)
 ("?" ?_))

;;

(quail-define-package
 "cyrillic-serbian" "Cyrillic" "ЖS" nil
 "ЉЊЕРТЗ-ЂЋ keyboard layout based on JUS.I.K1.005"
 nil t t t t nil nil nil nil nil t)

;;  1! 2" 3# 4$ 5% 6& 7' 8( 9) 0= /? +* <>
;;   Љ  Њ  Е  Р  Т  З  У  И  О  П  Ш  Ђ
;;    А  С  Д  Ф  Г  Х  Ј  К  Л  Ч  Ћ  Ж
;;     Ѕ  Џ  Ц  В  Б  Н  М  ,; .: -_

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?/)
 ("=" ?+)
 ("`" ?<)
 ("q" ?љ)
 ("w" ?њ)
 ("e" ?е)
 ("r" ?р)
 ("t" ?т)
 ("y" ?з)
 ("u" ?у)
 ("i" ?и)
 ("o" ?о)
 ("p" ?п)
 ("[" ?ш)
 ("]" ?ђ)
 ("a" ?а)
 ("s" ?с)
 ("d" ?д)
 ("f" ?ф)
 ("g" ?г)
 ("h" ?х)
 ("j" ?ј)
 ("k" ?к)
 ("l" ?л)
 (";" ?ч)
 ("'" ?ћ)
 ("\\" ?ж)
 ("z" ?ѕ)
 ("x" ?џ)
 ("c" ?ц)
 ("v" ?в)
 ("b" ?б)
 ("n" ?н)
 ("m" ?м)
 ("," ?,)
 ("." ?.)
 ("/" ?-)

 ("!" ?!)
 ("@" ?\")
 ("#" ?#)
 ("$" ?$)
 ("%" ?%)
 ("^" ?&)
 ("&" ?')
 ("*" ?\()
 ("(" ?\))
 (")" ?=)
 ("_" ??)
 ("+" ?*)
 ("~" ?>)
 ("Q" ?Љ)
 ("W" ?Њ)
 ("E" ?Е)
 ("R" ?Р)
 ("T" ?Т)
 ("Y" ?З)
 ("U" ?У)
 ("I" ?И)
 ("O" ?О)
 ("P" ?П)
 ("{" ?Ш)
 ("}" ?Ђ)
 ("A" ?А)
 ("S" ?С)
 ("D" ?Д)
 ("F" ?Ф)
 ("G" ?Г)
 ("H" ?Х)
 ("J" ?Ј)
 ("K" ?К)
 ("L" ?Л)
 (":" ?Ч)
 ("\"" ?Ћ)
 ("|" ?Ж)
 ("Z" ?Ѕ)
 ("X" ?Џ)
 ("C" ?Ц)
 ("V" ?В)
 ("B" ?Б)
 ("N" ?Н)
 ("M" ?М)
 ("<" ?\;)
 (">" ?:)
 ("?" ?_))

;;

;; Alexander Mikhailian comments:
;; Having worked for several years as a Belarusian linguist, I still
;; can not find the origin of this layout which BTW does include
;; several characters that are not present in Belarusian and does not
;; include a few ones that do exist in Belarusian.  Besides, the typo
;; in the name of this layout speaks for itself since Belarusian has
;; an outdated version of spelling which is "Byelorussian" and not
;; "beylorussian".  I suggest that you just remove this layout.

;; [`derived from JUS.I.K1' according to an old Mule note -- fx]

;; (quail-define-package
;;  "cyrillic-beylorussian" "Belarussian" "ЖB" nil
;;  "ЉЊЕРТЗ-ІЎ BEYLORUSSIAN (ISO 8859-5 encoding)"
;;  nil t t t t nil nil nil nil nil t)

;; ;;  1! 2" 3# 4$ 5% 6& 7' 8( 9) 0= /? +* <>
;; ;;   Љ  Њ  Е  Р  Т  З  У  И  О  П  Ш  І
;; ;;    А  С  Д  Ф  Г  Х  Ј  К  Л  Ч  Ў  Ж
;; ;;     Ѕ  Џ  Ц  В  Б  Н  М  ,; .: -_

;; (quail-define-rules
;;  ("-" ?/)
;;  ("=" ?+)
;;  ("`" ?<)
;;  ("q" ?љ)
;;  ("w" ?њ)
;;  ("e" ?е)
;;  ("r" ?р)
;;  ("t" ?т)
;;  ("y" ?з)
;;  ("u" ?у)
;;  ("i" ?и)
;;  ("o" ?о)
;;  ("p" ?п)
;;  ("[" ?ш)
;;  ("]" ?і)
;;  ("a" ?а)
;;  ("s" ?с)
;;  ("d" ?д)
;;  ("f" ?ф)
;;  ("g" ?г)
;;  ("h" ?х)
;;  ("j" ?ј)
;;  ("k" ?к)
;;  ("l" ?л)
;;  (";" ?ч)
;;  ("'" ?ў)
;;  ("\\" ?ж)
;;  ("z" ?ѕ)
;;  ("x" ?џ)
;;  ("c" ?ц)
;;  ("v" ?в)
;;  ("b" ?б)
;;  ("n" ?н)
;;  ("m" ?м)
;;  ("/" ?-)

;;  ("@" ?\")
;;  ("^" ?&)
;;  ("&" ?')
;;  ("*" ?\()
;;  ("(" ?\))
;;  (")" ?=)
;;  ("_" ??)
;;  ("+" ?*)
;;  ("~" ?>)
;;  ("Q" ?Љ)
;;  ("W" ?Њ)
;;  ("E" ?Е)
;;  ("R" ?Р)
;;  ("T" ?Т)
;;  ("Y" ?З)
;;  ("U" ?У)
;;  ("I" ?И)
;;  ("O" ?О)
;;  ("P" ?П)
;;  ("{" ?Ш)
;;  ("}" ?І)
;;  ("A" ?А)
;;  ("S" ?С)
;;  ("D" ?Д)
;;  ("F" ?Ф)
;;  ("G" ?Г)
;;  ("H" ?Х)
;;  ("J" ?Ј)
;;  ("K" ?К)
;;  ("L" ?Л)
;;  (":" ?Ч)
;;  ("\"" ?Ў)
;;  ("|" ?Ж)
;;  ("Z" ?Ѕ)
;;  ("X" ?Џ)
;;  ("C" ?Ц)
;;  ("V" ?В)
;;  ("B" ?Б)
;;  ("N" ?Н)
;;  ("M" ?М)
;;  ("<" ?\;)
;;  (">" ?:)
;;  ("?" ?_))

;;

;; Alexander Mikhailian reports the opinion of fellow Ukrainian
;; linguist Bogdan Babych <babych@altern.org>:
;; He had seen this layout on some oldish systems but that the vast
;; majority of the population uses a modified version of the M$ Windows
;; layout.  In fact, Microsoft shipped for a while a layout that was lacking
;; two characters, precisely the "GHE_WITH_UPTURN" and the apostrophe.  The
;; latest versions of Windows software do have the "GHE_WITH_UPTURN" in the
;; ukrainian keyboard layout but the apostrophe is still not there, whereas
;; there is one letter, "Cyrillic_YO", not used in ukrainian.  Ukrainians
;; normally replace the "Cyrillic_YO" by the apostrophe sign and live
;; happily with this little change.  [See "ukrainian-computer" below.]

;; Fixme: add GHE_WITH_UPTURN.
(quail-define-package
 "cyrillic-ukrainian" "Ukrainian" "ЖU" nil
 "ЄЇЕРТЗ-ІЎ UKRAINIAN

Sorry, but 'ghe with upturn' is not included in ISO 8859-5."
 nil t t t t nil nil nil nil nil t)

;;  1! 2" 3# 4$ 5% 6& 7' 8( 9) 0= /? +* <>
;;   Є  Ї  Е  Р  Т  З  У  И  О  П  Ш  І
;;    А  С  Д  Ф  Г  Х  Ј  К  Л  Ч  Ў  Ж
;;     Ѕ  Џ  Ц  В  Б  Н  М  ,; .: -_

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?/)
 ("=" ?+)
 ("`" ?<)
 ("q" ?є)
 ("w" ?ї)
 ("e" ?е)
 ("r" ?р)
 ("t" ?т)
 ("y" ?з)
 ("u" ?у)
 ("i" ?и)
 ("o" ?о)
 ("p" ?п)
 ("[" ?ш)
 ("]" ?і)
 ("a" ?а)
 ("s" ?с)
 ("d" ?д)
 ("f" ?ф)
 ("g" ?г)
 ("h" ?х)
 ("j" ?ј)
 ("k" ?к)
 ("l" ?л)
 (";" ?ч)
 ("'" ?ў)
 ("\\" ?ж)
 ("z" ?ѕ)
 ("x" ?џ)
 ("c" ?ц)
 ("v" ?в)
 ("b" ?б)
 ("n" ?н)
 ("m" ?м)
 ("," ?,)
 ("." ?.)
 ("/" ?-)

 ("!" ?!)
 ("@" ?\")
 ("#" ?#)
 ("$" ?$)
 ("%" ?%)
 ("^" ?&)
 ("&" ?')
 ("*" ?\()
 ("(" ?\))
 (")" ?=)
 ("_" ??)
 ("+" ?*)
 ("~" ?>)
 ("Q" ?Є)
 ("W" ?Ї)
 ("E" ?Е)
 ("R" ?Р)
 ("T" ?Т)
 ("Y" ?З)
 ("U" ?У)
 ("I" ?И)
 ("O" ?О)
 ("P" ?П)
 ("{" ?Ш)
 ("}" ?І)
 ("A" ?А)
 ("S" ?С)
 ("D" ?Д)
 ("F" ?Ф)
 ("G" ?Г)
 ("H" ?Х)
 ("J" ?Ј)
 ("K" ?К)
 ("L" ?Л)
 (":" ?Ч)
 ("\"" ?Ў)
 ("|" ?Ж)
 ("Z" ?Ѕ)
 ("X" ?Џ)
 ("C" ?Ц)
 ("V" ?В)
 ("B" ?Б)
 ("N" ?Н)
 ("M" ?М)
 ("<" ?\;)
 (">" ?:)
 ("?" ?_))


(quail-define-package
 "ukrainian-computer" "Ukrainian" "UK" nil
 "ЙЦУКЕН Ukrainian (Unicode-based for use with KOI8-U encoding)."
 nil t t t t nil nil nil nil nil t)

;;  ' 1! 2" 3№ 4; 5% 6: 7? 8* 9( 0) -_ =+
;;   Й  Ц  У  К  Е  Н  Г  Ш  Щ  З  Х  Ї
;;    Ф  І  В  А  П  Р  О  Л  Д  Ж  Є  Ґ
;;      Я  Ч  С  М  И  Т  Ь  Б  Ю  .,

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?-)
 ("=" ?=)
 ("`" ?')
 ("q" ?й)
 ("w" ?ц)
 ("e" ?у)
 ("r" ?к)
 ("t" ?е)
 ("y" ?н)
 ("u" ?г)
 ("i" ?ш)
 ("o" ?щ)
 ("p" ?з)
 ("[" ?х)
 ("]" ?ї)
 ("a" ?ф)
 ("s" ?і)
 ("d" ?в)
 ("f" ?а)
 ("g" ?п)
 ("h" ?р)
 ("j" ?о)
 ("k" ?л)
 ("l" ?д)
 (";" ?ж)
 ("'" ?є)
 ("z" ?я)
 ("x" ?ч)
 ("c" ?с)
 ("v" ?м)
 ("b" ?и)
 ("n" ?т)
 ("m" ?ь)
 ("," ?б)
 ("." ?ю)
 ("/" ?.)
 ("!" ?!)
 ("@" ?\")
 ("#" ?№)
 ("$" ?\;)
 ("%" ?%)
 ("^" ?:)
 ("&" ??)
 ("*" ?*)
 ("(" ?()
 (")" ?))
 ("_" ?_)
 ("+" ?+)
 ("~" ?')
 ("Q" ?Й)
 ("W" ?Ц)
 ("E" ?У)
 ("R" ?К)
 ("T" ?Е)
 ("Y" ?Н)
 ("U" ?Г)
 ("I" ?Ш)
 ("O" ?Щ)
 ("P" ?З)
 ("{" ?Х)
 ("}" ?Ї)
 ("A" ?Ф)
 ("S" ?І)
 ("D" ?В)
 ("F" ?А)
 ("G" ?П)
 ("H" ?Р)
 ("J" ?О)
 ("K" ?Л)
 ("L" ?Д)
 (":" ?Ж)
 ("\"" ?Є)
 ("Z" ?Я)
 ("X" ?Ч)
 ("C" ?С)
 ("V" ?М)
 ("B" ?И)
 ("N" ?Т)
 ("M" ?Ь)
 ("<" ?Б)
 (">" ?Ю)
 ("?" ?,)
 ("\\" ?ґ)
 ("|" ?Ґ))
;;

;; Alexander Mikhailian says this is of limited use.  It has been
;; popular among emigrants or foreigners who have to type in Cyrillic
;; (mostly Russian) from time to time.
(quail-define-package
 "cyrillic-yawerty" "Cyrillic" "ЖЯ" nil
 "ЯВЕРТЫ Roman transcription

This layout is based on Roman transcription by phonemic resemblance.
When preceded by a '/', the second and the third rows (number key row) change
as follows.

  keytop | Q  W  E  R  T  Y  U  I  O  P  A  S  D
 --------+---------------------------------------
  input  | Ђ  Ѓ  Є  Ѕ  І  Ї  Ј  Љ  Њ  Ћ  Ќ  Ў  Џ"
 nil t t t t nil nil nil nil nil t)

;;  1! 2ё 3ъ 4Ё 5% 6^ 7& 8* 9( 0) -_ Ч  Ю
;;   Я  В  Е  Р  Т  Ы  У  И  О  П  Ш  Щ
;;    А  С  Д  Ф  Г  Х  Й  К  Л  ;: '" Э
;;     З  Ь  Ц  Ж  Б  Н  М  ,< .> /?

;;  1! 2ё 3ъ 4Ё 5% 6^ 7& 8* 9( 0) -_ Ч  Ю
;;   Ђ  Ѓ  Є  Ѕ  І  Ї  Ј  Љ  Њ  Ћ  Ш  Щ
;;    Ќ  Ў  Џ  Ф  Г  Х  Й  К  Л  ;: '" Э
;;     З  Ь  Ц  Ж  Б  Н  М  ,< .> /?

(quail-define-rules
 ("1" ?1)
 ("2" ?2)
 ("3" ?3)
 ("4" ?4)
 ("5" ?5)
 ("6" ?6)
 ("7" ?7)
 ("8" ?8)
 ("9" ?9)
 ("0" ?0)
 ("-" ?-)
 ("=" ?ч)
 ("`" ?ю)
 ("q" ?я)
 ("w" ?в)
 ("e" ?е)
 ("r" ?р)
 ("t" ?т)
 ("y" ?ы)
 ("u" ?у)
 ("i" ?и)
 ("o" ?о)
 ("p" ?п)
 ("[" ?ш)
 ("]" ?щ)
 ("a" ?а)
 ("s" ?с)
 ("d" ?д)
 ("f" ?ф)
 ("g" ?г)
 ("h" ?х)
 ("j" ?й)
 ("k" ?к)
 ("l" ?л)
 (";" ?\;)
 ("'" ?')
 ("\\" ?э)
 ("z" ?з)
 ("x" ?ь)
 ("c" ?ц)
 ("v" ?ж)
 ("b" ?б)
 ("n" ?н)
 ("m" ?м)
 ("," ?,)
 ("." ?.)
 ("/" ?/)

 ("!" ?!)
 ("@" ?ё)
 ("#" ?ъ)
 ("$" ?Ё)
 ("%" ?%)
 ("^" ?^)
 ("&" ?&)
 ("*" ?*)
 ("(" ?\()
 (")" ?\))
 ("_" ?_)
 ("+" ?Ч)
 ("~" ?Ю)
 ("Q" ?Я)
 ("W" ?В)
 ("E" ?Е)
 ("R" ?Р)
 ("T" ?Т)
 ("Y" ?Ы)
 ("U" ?У)
 ("I" ?И)
 ("O" ?О)
 ("P" ?П)
 ("{" ?Ш)
 ("}" ?Щ)
 ("A" ?А)
 ("S" ?С)
 ("D" ?Д)
 ("F" ?Ф)
 ("G" ?Г)
 ("H" ?Х)
 ("J" ?Й)
 ("K" ?К)
 ("L" ?Л)
 (":" ?:)
 ("\"" ?\")
 ("|" ?Э)
 ("Z" ?З)
 ("X" ?Ь)
 ("C" ?Ц)
 ("V" ?Ж)
 ("B" ?Б)
 ("N" ?Н)
 ("M" ?М)
 ("<" ?<)
 (">" ?>)
 ("?" ??)

 ("/q" ?ђ)
 ("/w" ?ѓ)
 ("/e" ?є)
 ("/r" ?ѕ)
 ("/t" ?і)
 ("/y" ?ї)
 ("/u" ?ј)
 ("/i" ?љ)
 ("/o" ?њ)
 ("/p" ?ћ)
 ("/a" ?ќ)
 ("/s" ?ў)
 ("/d" ?џ)

 ("/Q" ?Ђ)
 ("/W" ?Ѓ)
 ("/E" ?Є)
 ("/R" ?Ѕ)
 ("/T" ?І)
 ("/Y" ?Ї)
 ("/U" ?Ј)
 ("/I" ?Љ)
 ("/O" ?Њ)
 ("/P" ?Ћ)
 ("/A" ?Ќ)
 ("/S" ?Ў)
 ("/D" ?Џ))

;; This was provided by Valery Alexeev <valery@domovoy.math.uga.edu>.

;; Ognyan Kulev <ogi@fmi.uni-sofia.bg> wrote:

;; I would suggest future `cyrillic-translit' to be with the
;; modification of `cyrillic-translit-bulgarian' applied and the
;; latter to disappear.  It could be used by people who write
;; bulgarian e-mails with latin letters for kick start (phonetic input
;; method is not so obvious as translit input method but each letter
;; is one keypress and a *lot* of people know it).

;; Anton Zinoviev <anton@lml.bas.bg> wrote:
;; I would say that the main idea for cyrillic-translit is to be
;; language-independent and universal.  It should be able to generate all
;; Cyrillic symbols.
(quail-define-package
 "cyrillic-translit" "Cyrillic" "Жt" t
 "Intuitively transliterated keyboard layout.
Most convenient for entering Russian, but all Cyrillic characters
are included.  Should handle most cases.  However:
  for ц (TSE) use \"c\", never \"ts\"
  щ (SHCHA = Bulgarian SHT) = \"shch\", \"sj\", \"/sht\" or \"/t\",
  э (REVERSE ROUNDED E) = \"e\\\"
  х (KHA) when after с (S) = \"x\" or \"kh\"
  ъ (HARD SIGN) = \"~\", Ъ (CAPITAL HARD SIGN) = \"~~\",
  ь (SOFT SIGN) = \"'\", Ь (CAPITAL SOFT SIGN) = \"''\",
  я (YA) = \"ya\", \"ja\" or \"q\".

Russian alphabet: a b v=w g d e yo=jo zh z i j=j' k l m n o p r s t
u f h=kh=x c ch sh shch=sj=/s=/sht ~ y ' e\\ yu=ju ya=ja=q

Also included are Ukrainian є (YE) = \"/e\", ї (YI) = \"yi\",
ґ (GHE WITH UPTURN) = \"g'\",
Belarusian ў (SHORT U) = \"u~\",
Serbo-Croatian ђ (DJE) = \"/d\", ћ (CHJE)= \"/ch\",
Macedonian ѓ (GJE) = \"/g\", ѕ (DZE) = \"/s\", ќ (KJE) = \"/k\",
cyrillic і (I DECIMAL) = \"/i\", ј (JE) = \"/j\",
љ (LJE) = \"/l\", њ (NJE) = \"/n\" and џ (DZE) =\"/z\"."
 nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("a" ?а) ("b" ?б) ("v" ?в) ("w" ?в) ("g" ?г) ("d" ?д)
 ("e" ?е) ("je" ?е)
 ("yo" ?ё) ("jo" ?ё)
 ("zh" ?ж) ("z" ?з) ("i" ?и)
 ("j" ?й) ("j'" ?й) ("j`" ?й) ("k" ?к) ("l" ?л)
 ("m" ?м) ("n" ?н) ("o" ?о) ("p" ?п) ("r" ?р) ("s" ?с) ("t" ?т) ("u" ?у)
 ("f" ?ф) ("x" ?х) ("h" ?х) ("kh" ?х)
 ("c" ?ц) ("ch" ?ч)
 ("sh" ?ш)
 ("shch" ?щ) ("sj" ?щ)
 ("/sht" ?щ) ("/t" ?щ)
 ("~" ?ъ) ("y" ?ы) ("'" ?ь) ("`" ?ь)
 ("e\\" ?э) ("e'" ?э) ("e`" ?э) ("@" ?э)
 ("yu" ?ю) ("ju" ?ю)
 ("ya" ?я) ("ja" ?я) ("q" ?я)

 ("A" ?А) ("B" ?Б) ("V" ?В) ("W" ?В) ("G" ?Г) ("D" ?Д)
 ("E" ?Е) ("Je" ?Е) ("JE" ?Е)
 ("Yo" ?Ё) ("YO" ?Ё) ("Jo" ?Ё) ("JO" ?Ё)
 ("Zh" ?Ж) ("ZH" ?Ж) ("Z" ?З) ("I" ?И)
 ("J" ?Й) ("J'" ?Й) ("J`" ?Й) ("K" ?К) ("L" ?Л)
 ("M" ?М) ("N" ?Н) ("O" ?О) ("P" ?П) ("R" ?Р) ("S" ?С) ("T" ?Т) ("U" ?У)
 ("F" ?Ф) ("X" ?Х) ("H" ?Х) ("Kh" ?Х) ("KH" ?Х)
 ("C" ?Ц) ("Ch" ?Ч) ("CH" ?Ч)
 ("Sh" ?Ш) ("SH" ?Ш)
 ("Shch" ?Щ) ("SHCH" ?Щ) ("Sj" ?Щ) ("SJ" ?Щ)
 ("/Sht" ?Щ) ("/SHT" ?Щ) ("/T" ?Щ)
 ("~~" ?Ъ) ("Y" ?Ы) ("''" ?Ь)
 ("E\\" ?Э) ("E'" ?Э) ("E`" ?Э) ("@@" ?Э)
 ("Yu" ?Ю) ("YU" ?Ю) ("Ju" ?Ю) ("JU" ?Ю)
 ("Ya" ?Я) ("YA" ?Я) ("Ja" ?Я) ("JA" ?Я) ("Q" ?Я)

 ("/e" ?є) ("yi" ?ї) ("u'" ?ў) ("u~" ?ў)
 ("g'" ?ґ)
 ("/d" ?ђ) ("/ch" ?ћ)
 ("/g" ?ѓ) ("/s" ?ѕ) ("/k" ?ќ)
 ("/i" ?і) ("/j" ?ј) ("/l" ?љ) ("/n" ?њ) ("/z" ?џ)
 ("/E" ?Є) ("YE" ?Є) ("Yi" ?Ї) ("YI" ?Ї) ("U'" ?Ў) ("U~" ?Ў)
 ("G'" ?Ґ)
 ("/D" ?Ђ) ("/Ch" ?Ћ) ("/CH" ?Ћ)
 ("/G" ?Ѓ) ("/S" ?Ѕ) ("/K" ?Ќ)
 ("/I" ?І) ("/J" ?Ј) ("/L" ?Љ) ("/N" ?Њ) ("/Z" ?Џ)

 ;; Combining accents as a separate character
 ("//'" ?́) ("//`" ?̀)

 ;; In the following two rules the accent is not a separate character
 ("i`" ?ѝ) ("I`" ?Ѝ)

 ("/-"  ?–)  ;; EN DASH
 ("/--" ?—)  ;; EM DASH
 ("/*" ?•)   ;; BULLET
 ("/." ?․)   ;; ONE DOT LEADER
 ("/.." ?‥)  ;; TWO DOT LEADER
 ("/..." ?…) ;; HORIZONTAL ELLIPSIS
 ("/,," ?„)  ;; DOUBLE LOW-9 QUOTATION MARK
 ("/," ?‚)   ;; SINGLE LOW-9 QUOTATION MARK
 ("/''" ?”)  ;; RIGHT DOUBLE QUOTATION MARK
 ("/'" ?’)   ;; RIGHT SINGLE QUOTATION MARK
 ("/``" ?“)  ;; LEFT DOUBLE QUOTATION MARK
 ("/`" ?‘)   ;; LEFT SINGLE QUOTATION MARK
 ("/<<" ?«)  ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
 ("/>>" ?»)  ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK

 ("/&" ?§)
 ("/ab" ?§)                             ; _аб_зац
 ("/pa" ?§)                             ; _pa_ragraph
 ("/#" ?№)
 ("/no" ?№)                             ; _но_мер

 ("/c" ?©)
 ("/tm" ?™)
 ("/reg" ?®)
 ("/eu"  ?€)
 ("/ce"  ?¢)

 ;; fractions
 ("/78" ?⅞)
 ("/58" ?⅝)
 ("/38" ?⅜)
 ("/18" ?⅛)
 ("/56" ?⅚)
 ("/16" ?⅙)
 ("/45" ?⅘)
 ("/35" ?⅗)
 ("/25" ?⅖)
 ("/15" ?⅕)
 ("/23" ?⅔)
 ("/13" ?⅓)
 ("/34" ?¾)
 ("/12" ?½)
 ("/14" ?¼)

 ;; Roman numerals, commonly used for months and section/subsection numbers
 ("/RI" ?Ⅰ)
 ("/RII" ?Ⅱ)
 ("/RIII" ?Ⅲ)
 ("/RIV" ?Ⅳ)
 ("/RV" ?Ⅴ)
 ("/RVI" ?Ⅵ)
 ("/RVII" ?Ⅶ)
 ("/RVIII" ?Ⅷ)
 ("/RIX" ?Ⅸ)
 ("/RX" ?Ⅹ)
 ("/RXI" ?Ⅺ)
 ("/RXII" ?Ⅻ)

 ("/ri" ?ⅰ)
 ("/rii" ?ⅱ)
 ("/riii" ?ⅲ)
 ("/riv" ?ⅳ)
 ("/rv" ?ⅴ)
 ("/rvi" ?ⅵ)
 ("/rvii" ?ⅶ)
 ("/rviii" ?ⅷ)
 ("/rix" ?ⅸ)
 ("/rx" ?ⅹ)
 ("/rxi" ?ⅺ)
 ("/rxii" ?ⅻ)
)

;; Originally from Yudit's `Belarusian input table according to
;; STB955-94 belarusian standard' (not all) by Alexander Mikhailian
;; <mikhailian@altern.org>, subsequently amended by AM.
(quail-define-package
 "belarusian" "Belarusian" "BE" nil
 "ЙЦУКЕН keyboard layout registered as STB955-94 Belarusian standard.
Unicode based."
 nil t t t t nil nil nil nil nil t)

;; ёЁ 1! 2" 3N 4; 5% 6: 7? 8* 9( 0) -_ =+
;;     Й  Ц  У  К  Е  Н  Г  Ш  Ў  З  Х  '
;;      Ф  Ы  В  А  П  Р  О  Л  Д  Ж  Э
;;       Я  Ч  С  М  І  Т  Ь  Б  Ю  .,

(quail-define-rules
 ("~" ?Ё)
 ("@" ?\")
 ("#" ?№)
 ("$" ?\;)
 ("%" ?%)
 ("^" ?:)
 ("&" ??)
 ("Q" ?Й)
 ("W" ?Ц)
 ("E" ?У)
 ("R" ?К)
 ("T" ?Е)
 ("Y" ?Н)
 ("U" ?Г)
 ("I" ?Ш)
 ("O" ?Ў)
 ("P" ?З)
 ("{" ?Х)
 ("}" ?')
 ("A" ?Ф)
 ("S" ?Ы)
 ("D" ?В)
 ("F" ?А)
 ("G" ?П)
 ("H" ?Р)
 ("J" ?О)
 ("K" ?Л)
 ("L" ?Д)
 (":" ?Ж)
 ("\"" ?Э)
 ("|" ?|)
 ("Z" ?Я)
 ("X" ?Ч)
 ("C" ?С)
 ("V" ?М)
 ("B" ?І)
 ("N" ?Т)
 ("M" ?Ь)
 ("<" ?Б)
 (">" ?Ю)
 ("?" ?,)

 ("`" ?ё)
 ("q" ?й)
 ("w" ?ц)
 ("e" ?у)
 ("r" ?к)
 ("t" ?е)
 ("y" ?н)
 ("u" ?г)
 ("i" ?ш)
 ("o" ?ў)
 ("p" ?з)
 ("[" ?х)
 ("]" ?')
 ("a" ?ф)
 ("s" ?ы)
 ("d" ?в)
 ("f" ?а)
 ("g" ?п)
 ("h" ?р)
 ("j" ?о)
 ("k" ?л)
 ("l" ?д)
 (";" ?ж)
 ("'" ?э)
 ("z" ?я)
 ("x" ?ч)
 ("c" ?с)
 ("v" ?м)
 ("b" ?і)
 ("n" ?т)
 ("m" ?ь)
 ("," ?б)
 ("." ?ю)
 ("/" ?.))

(quail-define-package
 "bulgarian-alt-phonetic" "Bulgarian" "БНФ"
 nil
 "Bulgarian alternative Phonetic keyboard layout, producing Unicode.

This phonetic layout replaces all the Latin letters with Bulgarian
\(Cyrillic) letters based on similarities in their pronunciation or look.

Note that, since the letters 'щ', 'ь', 'ю' and 'я' are attached to the
']', '\', '`' and '[' keys respectively, Caps Lock does not affect them."
nil t t t t nil nil nil nil nil t)

;;  Ю  1! 2@ 3№ 4$ 5% 6€ 7§ 8* 9( 0) -– =+ ьѝ
;;      Ч  Ш  Е  Р  Т  Ъ  У  И  О  П  Я  Щ
;;       А  С  Д  Ф  Г  Х  Й  К  Л  :; '"
;;        З  Ж  Ц  В  Б  Н  М  ,„ .“ /?

(quail-define-rules
 ("#" ?№)
 ("&" ?§)
 ("/#" ?#)
 ("/&" ?&)
 ("/<" ?<)
 ("/>" ?>)
 ("/[" ?\[)
 ("/\\" ?\\)
 ("/]" ?\])
 ("/^" ?^)
 ("/_" ?_)
 ("/`" ?`)
 ("/{" ?{)
 ("/|" ?|)
 ("/}" ?})
 ("/~" ?~)
 ("<" ?„)
 (">" ?“)
 ("A" ?А) ("a" ?а)
 ("B" ?Б) ("b" ?б)
 ("C" ?Ц) ("c" ?ц)
 ("D" ?Д) ("d" ?д)
 ("E" ?Е) ("e" ?е)
 ("F" ?Ф) ("f" ?ф)
 ("G" ?Г) ("g" ?г)
 ("H" ?Х) ("h" ?х)
 ("I" ?И) ("i" ?и)
 ("J" ?Й) ("j" ?й)
 ("K" ?К) ("k" ?к)
 ("L" ?Л) ("l" ?л)
 ("M" ?М) ("m" ?м)
 ("N" ?Н) ("n" ?н)
 ("O" ?О) ("o" ?о)
 ("P" ?П) ("p" ?п)
 ("Q" ?Ч) ("q" ?ч)
 ("R" ?Р) ("r" ?р)
 ("S" ?С) ("s" ?с)
 ("T" ?Т) ("t" ?т)
 ("U" ?У) ("u" ?у)
 ("V" ?В) ("v" ?в)
 ("W" ?Ш) ("w" ?ш)
 ("X" ?Ж) ("x" ?ж)
 ("Y" ?Ъ) ("y" ?ъ)
 ("Z" ?З) ("z" ?з)
 ("[" ?я)
 ("\\" ?ь)
 ("]" ?щ)
 ("^" ?€)
 ("_" ?–)
 ("`" ?ю)
 ("{" ?Я)
 ("|" ?ѝ)
 ("}" ?Щ)
 ("~" ?Ю))

;; From `Bulgarian-PHO.kmap for Yudit', Alexander Shopov
;; <al_shopov@web.bg>.

;; Extra commentary and the indicator from an independent
;; (cyrillic-iso8859-5) implementation by Ognyan Kulev
;; <ogi@fmi.uni-sofia.bg> and name changes from Anton Zinoviev
;; <anton@lml.bas.bg>.
(quail-define-package
 "bulgarian-phonetic" "Bulgarian" "ЖБФ"
 nil
 "Bulgarian Phonetic keyboard layout, producing Unicode.

The layout is similar to `cyrillic-translit', but all Bulgarian
characters are typed with a single key.

Use /& for § (Cyrillic paragraph) and /# for №.

The letters Ч, Ш, Щ and Ю are not affected by Caps Lock."
 nil t t t t nil nil nil nil nil t)

;;  Ч
;;      Я  В  Е  Р  Т  Ъ  У  И  О  П  Ш  Щ
;;       А  С  Д  Ф  Г  Х  Й  К  Л        Ю
;;        З  Ь  Ц  Ж  Б  Н  М

(quail-define-rules
 ("/&" ?§)
 ("/#" ?№)
 ("A" ?А)
 ("B" ?Б)
 ("W" ?В)
 ("G" ?Г)
 ("D" ?Д)
 ("E" ?Е)
 ("V" ?Ж)
 ("Z" ?З)
 ("I" ?И)
 ("J" ?Й)
 ("K" ?К)
 ("L" ?Л)
 ("M" ?М)
 ("N" ?Н)
 ("O" ?О)
 ("P" ?П)
 ("R" ?Р)
 ("S" ?С)
 ("T" ?Т)
 ("U" ?У)
 ("F" ?Ф)
 ("H" ?Х)
 ("C" ?Ц)
 ("~" ?Ч)
 ("{" ?Ш)
 ("}" ?Щ)
 ("Y" ?Ъ)
 ("X" ?Ь)
 ("|" ?Ю)
 ("Q" ?Я)
 ("a" ?а)
 ("b" ?б)
 ("w" ?в)
 ("g" ?г)
 ("d" ?д)
 ("e" ?е)
 ("v" ?ж)
 ("z" ?з)
 ("i" ?и)
 ("j" ?й)
 ("k" ?к)
 ("l" ?л)
 ("m" ?м)
 ("n" ?н)
 ("o" ?о)
 ("p" ?п)
 ("r" ?р)
 ("s" ?с)
 ("t" ?т)
 ("u" ?у)
 ("f" ?ф)
 ("h" ?х)
 ("c" ?ц)
 ("`" ?ч)
 ("[" ?ш)
 ("]" ?щ)
 ("y" ?ъ)
 ("x" ?ь)
 ("\\" ?ю)
 ("q" ?я))

;; Based on an implementation by Ognyan Kulev <ogi@fmi.uni-sofia.bg>.
;; This follows XKB bg.

(quail-define-package
 "bulgarian-bds" "Bulgarian" "БДС" nil
 "Bulgarian standard keyboard layout (BDS)

This keyboard layout is standard for Bulgarian typewriters.

The letters Ц, М, Ч, Р, Л, Б and Ы are not affected by Caps Lock.

In addition to original Bulgarian typewriter layout, keys \\ and |
are transformed into ' and Ы respectively.  Some keyboards mark these
keys as being transformed into ( and ) respectively.  For ( and ), use
` and ~ respectively.  This input method follows XKB."
 nil t t t t nil nil nil nil nil t)

;;  () 1! 2? 3+ 4" 5% 6= 7: 8/ 9_ 0№ -I .V
;;      ,ы У  Е  И  Ш  Щ  К  С  Д  З  Ц  ;§
;;       Ь  Я  А  О  Ж  Г  Т  Н  В  М  Ч  'Ы
;;        Ю  Й  Ъ  Э  Ф  Х  П  Р  Л  Б

(quail-define-rules

 ("1" ?1) ("!" ?!)
 ("2" ?2) ("@" ??)
 ("3" ?3) ("#" ?+)
 ("4" ?4) ("$" ?\")
 ("5" ?5) ("%" ?%)
 ("6" ?6) ("^" ?=)
 ("7" ?7) ("&" ?:)
 ("8" ?8) ("*" ?/)
 ("9" ?9) ("(" ?_)
 ("0" ?0) (")" ?№)
 ("-" ?-) ("_" ?I)
 ("=" ?.) ("+" ?V)

 ("q" ?,) ("Q" ?ы)
 ("w" ?у) ("W" ?У)
 ("e" ?е) ("E" ?Е)
 ("r" ?и) ("R" ?И)
 ("t" ?ш) ("T" ?Ш)
 ("y" ?щ) ("Y" ?Щ)
 ("u" ?к) ("U" ?К)
 ("i" ?с) ("I" ?С)
 ("o" ?д) ("O" ?Д)
 ("p" ?з) ("P" ?З)
 ("[" ?ц) ("{" ?Ц)
 ("]" ?\;) ("}" ?§)

 ("a" ?ь) ("A" ?Ь)
 ("s" ?я) ("S" ?Я)
 ("d" ?а) ("D" ?А)
 ("f" ?о) ("F" ?О)
 ("g" ?ж) ("G" ?Ж)
 ("h" ?г) ("H" ?Г)
 ("j" ?т) ("J" ?Т)
 ("k" ?н) ("K" ?Н)
 ("l" ?в) ("L" ?В)
 (";" ?м) (":" ?М)
 ("'" ?ч) ("\"" ?Ч)
 ("`" ?\() ("~" ?\))

 ("z" ?ю) ("Z" ?Ю)
 ("x" ?й) ("X" ?Й)
 ("c" ?ъ) ("C" ?Ъ)
 ("v" ?э) ("V" ?Э)
 ("b" ?ф) ("B" ?Ф)
 ("n" ?х) ("N" ?Х)
 ("m" ?п) ("M" ?П)
 ("," ?р) ("<" ?Р)
 ("." ?л) (">" ?Л)
 ("/" ?б) ("?" ?Б)
 ("\\" ?') ("|" ?Ы))

;; Local Variables:
;; coding: utf-8
;; End:

;;; cyrillic.el ends here
