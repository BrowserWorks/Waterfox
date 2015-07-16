;;; vnvni.el --- Quail package for Vietnamese by VNI method

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.

;; Author:   Werner Lemberg <wl@gnu.org>
;;           Nguyen Thai Ngoc Duy <pclouds@gmail.com>
;; Keywords: multilingual, input method, Vietnamese

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

;; There are two commonly-used input methods for Vietnamese: Telex
;; (implemented in vntelex.el) and VNI (implemented in this file,
;; which was based on vntelex.el).

;;; Code:

(require 'quail)


(quail-define-package
 "vietnamese-vni"                ; NAME
 "Vietnamese"                    ; LANGUAGE
 "VV"                            ; TITLE
 t                               ; GUIDANCE
 "Vietnamese VNI input method

Diacritics:

  effect     postfix   examples
  ------------------------------
  circumflex    6      a6 -> â
  breve         8      a8 -> ă
  horn          7      o7 -> ơ

  acute         1      a1 -> á
  grave         2      a2 -> à
  hook above    3      a3 -> ả
  tilde         4      a4 -> ã
  dot below     5      a5 -> ạ

  d bar         9      d9 -> đ

Combinations:

  A82 -> Ằ, o74 -> ỡ, etc.

Doubling the postfix (but not in combinations) separates the letter
and postfix: E66 -> E6, a55 -> a5, etc.
"                                ; DOCSTRING
 nil                             ; TRANSLATION-KEYS
 t                               ; FORGET-LAST-SELECTION
 nil                             ; DETERMINISTIC
 nil                             ; KBD-TRANSLATE
 nil                             ; SHOW-LAYOUT
 nil                             ; CREATE-DECODE-MAP
 nil                             ; MAXIMUM-SHORTEST
 nil                             ; OVERLAY-PLIST
 nil                             ; UPDATE-TRANSLATION-FUNCTION
 nil                             ; CONVERSION-KEYS
 t)                              ; SIMPLE

(quail-define-rules
 ("a2" ?à)	; LATIN SMALL LETTER A WITH GRAVE
 ("A2" ?À)	; LATIN CAPITAL LETTER A WITH GRAVE
 ("a1" ?á)	; LATIN SMALL LETTER A WITH ACUTE
 ("A1" ?Á)	; LATIN CAPITAL LETTER A WITH ACUTE
 ("a6" ?â)	; LATIN SMALL LETTER A WITH CIRCUMFLEX
 ("A6" ?Â)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
 ("a4" ?ã)	; LATIN SMALL LETTER A WITH TILDE
 ("A4" ?Ã)	; LATIN CAPITAL LETTER A WITH TILDE
 ("e2" ?è)	; LATIN SMALL LETTER E WITH GRAVE
 ("E2" ?È)	; LATIN CAPITAL LETTER E WITH GRAVE
 ("e1" ?é)	; LATIN SMALL LETTER E WITH ACUTE
 ("E1" ?É)	; LATIN CAPITAL LETTER E WITH ACUTE
 ("e6" ?ê)	; LATIN SMALL LETTER E WITH CIRCUMFLEX
 ("E6" ?Ê)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
 ("i2" ?ì)	; LATIN SMALL LETTER I WITH GRAVE
 ("I2" ?Ì)	; LATIN CAPITAL LETTER I WITH GRAVE
 ("i1" ?í)	; LATIN SMALL LETTER I WITH ACUTE
 ("I1" ?Í)	; LATIN CAPITAL LETTER I WITH ACUTE
 ("o2" ?ò)	; LATIN SMALL LETTER O WITH GRAVE
 ("O2" ?Ò)	; LATIN CAPITAL LETTER O WITH GRAVE
 ("o1" ?ó)	; LATIN SMALL LETTER O WITH ACUTE
 ("O1" ?Ó)	; LATIN CAPITAL LETTER O WITH ACUTE
 ("o6" ?ô)	; LATIN SMALL LETTER O WITH CIRCUMFLEX
 ("O6" ?Ô)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
 ("o4" ?õ)	; LATIN SMALL LETTER O WITH TILDE
 ("O4" ?Õ)	; LATIN CAPITAL LETTER O WITH TILDE
 ("u2" ?ù)	; LATIN SMALL LETTER U WITH GRAVE
 ("U2" ?Ù)	; LATIN CAPITAL LETTER U WITH GRAVE
 ("u1" ?ú)	; LATIN SMALL LETTER U WITH ACUTE
 ("U1" ?Ú)	; LATIN CAPITAL LETTER U WITH ACUTE
 ("y1" ?ý)	; LATIN SMALL LETTER Y WITH ACUTE
 ("Y1" ?Ý)	; LATIN CAPITAL LETTER Y WITH ACUTE
 ("a8" ?ă)	; LATIN SMALL LETTER A WITH BREVE
 ("A8" ?Ă)	; LATIN CAPITAL LETTER A WITH BREVE
 ("i4" ?ĩ)	; LATIN SMALL LETTER I WITH TILDE
 ("I4" ?Ĩ)	; LATIN CAPITAL LETTER I WITH TILDE
 ("u4" ?ũ)	; LATIN SMALL LETTER U WITH TILDE
 ("U4" ?Ũ)	; LATIN CAPITAL LETTER U WITH TILDE
 ("o7" ?ơ)	; LATIN SMALL LETTER O WITH HORN
 ("O7" ?Ơ)	; LATIN CAPITAL LETTER O WITH HORN
 ("u7" ?ư)	; LATIN SMALL LETTER U WITH HORN
 ("U7" ?Ư)	; LATIN CAPITAL LETTER U WITH HORN
 ("a5" ?ạ)	; LATIN SMALL LETTER A WITH DOT BELOW
 ("A5" ?Ạ)	; LATIN CAPITAL LETTER A WITH DOT BELOW
 ("a3" ?ả)	; LATIN SMALL LETTER A WITH HOOK ABOVE
 ("A3" ?Ả)	; LATIN CAPITAL LETTER A WITH HOOK ABOVE
 ("a61" ?ấ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("A61" ?Ấ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("a62" ?ầ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("A62" ?Ầ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("a63" ?ẩ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND HO6K ABOVE
 ("A63" ?Ẩ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND HO6K ABOVE
 ("a64" ?ẫ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND TILDE
 ("A64" ?Ẫ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND TILDE
 ("a65" ?ậ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("A65" ?Ậ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("a81" ?ắ)	; LATIN SMALL LETTER A WITH BREVE AND ACUTE
 ("A81" ?Ắ)	; LATIN CAPITAL LETTER A WITH BREVE AND ACUTE
 ("a82" ?ằ)	; LATIN SMALL LETTER A WITH BREVE AND GRAVE
 ("A82" ?Ằ)	; LATIN CAPITAL LETTER A WITH BREVE AND GRAVE
 ("a83" ?ẳ)	; LATIN SMALL LETTER A WITH BREVE AND HO6K ABOVE
 ("A83" ?Ẳ)	; LATIN CAPITAL LETTER A WITH BREVE AND HO6K ABOVE
 ("a84" ?ẵ)	; LATIN SMALL LETTER A WITH BREVE AND TILDE
 ("A84" ?Ẵ)	; LATIN CAPITAL LETTER A WITH BREVE AND TILDE
 ("a85" ?ặ)	; LATIN SMALL LETTER A WITH BREVE AND DOT BELOW
 ("A85" ?Ặ)	; LATIN CAPITAL LETTER A WITH BREVE AND DOT BELOW
 ("e5" ?ẹ)	; LATIN SMALL LETTER E WITH DOT BELOW
 ("E5" ?Ẹ)	; LATIN CAPITAL LETTER E WITH DOT BELOW
 ("e3" ?ẻ)	; LATIN SMALL LETTER E WITH HO6K ABOVE
 ("E3" ?Ẻ)	; LATIN CAPITAL LETTER E WITH HO6K ABOVE
 ("e4" ?ẽ)	; LATIN SMALL LETTER E WITH TILDE
 ("E4" ?Ẽ)	; LATIN CAPITAL LETTER E WITH TILDE
 ("e61" ?ế)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("E61" ?Ế)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("e62" ?ề)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("E62" ?Ề)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("e63" ?ể)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND HO6K ABOVE
 ("E63" ?Ể)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND HO6K ABOVE
 ("e64" ?ễ)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND TILDE
 ("E64" ?Ễ)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND TILDE
 ("e65" ?ệ)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("E65" ?Ệ)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("i3" ?ỉ)	; LATIN SMALL LETTER I WITH HO6K ABOVE
 ("I3" ?Ỉ)	; LATIN CAPITAL LETTER I WITH HO6K ABOVE
 ("i5" ?ị)	; LATIN SMALL LETTER I WITH DOT BELOW
 ("I5" ?Ị)	; LATIN CAPITAL LETTER I WITH DOT BELOW
 ("o5" ?ọ)	; LATIN SMALL LETTER O WITH DOT BELOW
 ("O5" ?Ọ)	; LATIN CAPITAL LETTER O WITH DOT BELOW
 ("o3" ?ỏ)	; LATIN SMALL LETTER O WITH HO6K ABOVE
 ("O3" ?Ỏ)	; LATIN CAPITAL LETTER O WITH HO6K ABOVE
 ("o61" ?ố)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("O61" ?Ố)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("o62" ?ồ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("O62" ?Ồ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("o63" ?ổ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND HO6K ABOVE
 ("O63" ?Ổ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND HO6K ABOVE
 ("o64" ?ỗ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND TILDE
 ("O64" ?Ỗ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND TILDE
 ("o65" ?ộ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND DOT BELO7
 ("O65" ?Ộ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND DOT BELO7
 ("o71" ?ớ)	; LATIN SMALL LETTER O WITH HORN AND ACUTE
 ("O71" ?Ớ)	; LATIN CAPITAL LETTER O WITH HORN AND ACUTE
 ("o72" ?ờ)	; LATIN SMALL LETTER O WITH HORN AND GRAVE
 ("O72" ?Ờ)	; LATIN CAPITAL LETTER O WITH HORN AND GRAVE
 ("o73" ?ở)	; LATIN SMALL LETTER O WITH HORN AND HO6K ABOVE
 ("O73" ?Ở)	; LATIN CAPITAL LETTER O WITH HORN AND HO6K ABOVE
 ("o74" ?ỡ)	; LATIN SMALL LETTER O WITH HORN AND TILDE
 ("O74" ?Ỡ)	; LATIN CAPITAL LETTER O WITH HORN AND TILDE
 ("o75" ?ợ)	; LATIN SMALL LETTER O WITH HORN AND DOT BELO7
 ("O75" ?Ợ)	; LATIN CAPITAL LETTER O WITH HORN AND DOT BELO7
 ("u5" ?ụ)	; LATIN SMALL LETTER U WITH DOT BELO7
 ("U5" ?Ụ)	; LATIN CAPITAL LETTER U WITH DOT BELO7
 ("u3" ?ủ)	; LATIN SMALL LETTER U WITH HO6K ABOVE
 ("U3" ?Ủ)	; LATIN CAPITAL LETTER U WITH HO6K ABOVE
 ("u71" ?ứ)	; LATIN SMALL LETTER U WITH HORN AND ACUTE
 ("U71" ?Ứ)	; LATIN CAPITAL LETTER U WITH HORN AND ACUTE
 ("u72" ?ừ)	; LATIN SMALL LETTER U WITH HORN AND GRAVE
 ("U72" ?Ừ)	; LATIN CAPITAL LETTER U WITH HORN AND GRAVE
 ("u73" ?ử)	; LATIN SMALL LETTER U WITH HORN AND HO6K ABOVE
 ("U73" ?Ử)	; LATIN CAPITAL LETTER U WITH HORN AND HO6K ABOVE
 ("u74" ?ữ)	; LATIN SMALL LETTER U WITH HORN AND TILDE
 ("U74" ?Ữ)	; LATIN CAPITAL LETTER U WITH HORN AND TILDE
 ("u75" ?ự)	; LATIN SMALL LETTER U WITH HORN AND DOT BELO7
 ("U75" ?Ự)	; LATIN CAPITAL LETTER U WITH HORN AND DOT BELO7
 ("y2" ?ỳ)	; LATIN SMALL LETTER Y WITH GRAVE
 ("Y2" ?Ỳ)	; LATIN CAPITAL LETTER Y WITH GRAVE
 ("y5" ?ỵ)	; LATIN SMALL LETTER Y WITH DOT BELO7
 ("Y5" ?Ỵ)	; LATIN CAPITAL LETTER Y WITH DOT BELO7
 ("y3" ?ỷ)	; LATIN SMALL LETTER Y WITH HO6K ABOVE
 ("Y3" ?Ỷ)	; LATIN CAPITAL LETTER Y WITH HO6K ABOVE
 ("y4" ?ỹ)	; LATIN SMALL LETTER Y WITH TILDE
 ("Y4" ?Ỹ)	; LATIN CAPITAL LETTER Y WITH TILDE
 ("d9" ?đ)	; LATIN SMALL LETTER D WITH STROKE
 ("D9" ?Đ)	; LATIN CAPITAL LETTER D WITH STROKE
;("$$" ?₫)	; U+20AB DONG SIGN (#### check)

 ("a22" ["a22"])
 ("A22" ["A2"])
 ("a11" ["a1"])
 ("A11" ["A1"])
 ("a66"' ["a6"])
 ("A66"' ["A6"])
 ("a44" ["a4"])
 ("A44" ["A4"])
 ("e22" ["e2"])
 ("E22" ["E2"])
 ("e11" ["e1"])
 ("E11" ["E1"])
 ("e66" ["e6"])
 ("E66" ["E6"])
 ("i22" ["i2"])
 ("I22" ["I2"])
 ("i11" ["i1"])
 ("I11" ["I1"])
 ("o22" ["o2"])
 ("O22" ["O2"])
 ("o11" ["o1"])
 ("O11" ["O1"])
 ("o66" ["o6"])
 ("O66" ["O6"])
 ("o44" ["o4"])
 ("O44" ["O4"])
 ("u22" ["u2"])
 ("U22" ["U2"])
 ("u11" ["u1"])
 ("U11" ["U1"])
 ("y11" ["y1"])
 ("Y11" ["Y1"])
 ("a88" ["a8"])
 ("A88" ["A8"])
 ("i44" ["i4"])
 ("I44" ["I4"])
 ("u44" ["u4"])
 ("U44" ["u4"])
 ("o77" ["o7"])
 ("O77" ["O7"])
 ("u77" ["u7"])
 ("U77" ["U7"])
 ("a55" ["a5"])
 ("A55" ["A5"])
 ("a33" ["a3"])
 ("A33" ["A3"])
 ("e55" ["e5"])
 ("E55" ["E5"])
 ("e33" ["e3"])
 ("E33" ["E3"])
 ("e44" ["e4"])
 ("E44" ["E4"])
 ("i33" ["i3"])
 ("I33" ["I3"])
 ("i55" ["i5"])
 ("I55" ["I5"])
 ("o55" ["o5"])
 ("O55" ["O5"])
 ("o33" ["o3"])
 ("O33" ["O3"])
 ("u55" ["u5"])
 ("U55" ["U5"])
 ("u33" ["u3"])
 ("U33" ["U3"])
 ("y22" ["y2"])
 ("Y22" ["Y2"])
 ("y55" ["y5"])
 ("Y55" ["Y5"])
 ("y33" ["y3"])
 ("Y33" ["Y3"])
 ("y44" ["y4"])
 ("Y44" ["Y4"])
 ("d9"  ["d9"])
 ("D99" ["D9"])
;("$$$" ["$$"])

 ;; escape from composition
 ("\\1" ?1)
 ("\\2" ?2)
 ("\\3" ?3)
 ("\\4" ?4)
 ("\\5" ?5)
 ("\\6" ?6)
 ("\\7" ?7)
 ("\\8" ?8)
 ("\\9" ?9)
 ("\\\\" ?\\)) ; literal backslash


;; Local Variables:
;; coding: utf-8
;; End:
