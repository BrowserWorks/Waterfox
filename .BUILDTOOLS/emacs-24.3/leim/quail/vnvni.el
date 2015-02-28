;;; vnvni.el --- Quail package for Vietnamese by VNI method

;; Copyright (C) 2001-2013 Free Software Foundation, Inc.

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
  circumflex    6      a6 -> ,Ab(B
  breve         8      a8 -> ,1e(B
  horn          7      o7 -> ,1=(B

  acute         1      a1 -> ,1a(B
  grave         2      a2 -> ,1`(B
  hook above    3      a3 -> ,1d(B
  tilde         4      a4 -> ,1c(B
  dot below     5      a5 -> ,1U(B

  d bar         9      d9 -> ,1p(B

Combinations:

  A82 -> ,2"(B, o74 -> ,1^(B, etc.

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
 ("a2" ?,1`(B)	; LATIN SMALL LETTER A WITH GRAVE
 ("A2" ?,2`(B)	; LATIN CAPITAL LETTER A WITH GRAVE
 ("a1" ?,1a(B)	; LATIN SMALL LETTER A WITH ACUTE
 ("A1" ?,2a(B)	; LATIN CAPITAL LETTER A WITH ACUTE
 ("a6" ?,1b(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX
 ("A6" ?,2b(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
 ("a4" ?,1c(B)	; LATIN SMALL LETTER A WITH TILDE
 ("A4" ?,2c(B)	; LATIN CAPITAL LETTER A WITH TILDE
 ("e2" ?,1h(B)	; LATIN SMALL LETTER E WITH GRAVE
 ("E2" ?,2h(B)	; LATIN CAPITAL LETTER E WITH GRAVE
 ("e1" ?,1i(B)	; LATIN SMALL LETTER E WITH ACUTE
 ("E1" ?,2i(B)	; LATIN CAPITAL LETTER E WITH ACUTE
 ("e6" ?,1j(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX
 ("E6" ?,2j(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
 ("i2" ?,1l(B)	; LATIN SMALL LETTER I WITH GRAVE
 ("I2" ?,2l(B)	; LATIN CAPITAL LETTER I WITH GRAVE
 ("i1" ?,1m(B)	; LATIN SMALL LETTER I WITH ACUTE
 ("I1" ?,2m(B)	; LATIN CAPITAL LETTER I WITH ACUTE
 ("o2" ?,1r(B)	; LATIN SMALL LETTER O WITH GRAVE
 ("O2" ?,2r(B)	; LATIN CAPITAL LETTER O WITH GRAVE
 ("o1" ?,1s(B)	; LATIN SMALL LETTER O WITH ACUTE
 ("O1" ?,2s(B)	; LATIN CAPITAL LETTER O WITH ACUTE
 ("o6" ?,1t(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX
 ("O6" ?,2t(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
 ("o4" ?,1u(B)	; LATIN SMALL LETTER O WITH TILDE
 ("O4" ?,2u(B)	; LATIN CAPITAL LETTER O WITH TILDE
 ("u2" ?,1y(B)	; LATIN SMALL LETTER U WITH GRAVE
 ("U2" ?,2y(B)	; LATIN CAPITAL LETTER U WITH GRAVE
 ("u1" ?,1z(B)	; LATIN SMALL LETTER U WITH ACUTE
 ("U1" ?,2z(B)	; LATIN CAPITAL LETTER U WITH ACUTE
 ("y1" ?,1}(B)	; LATIN SMALL LETTER Y WITH ACUTE
 ("Y1" ?,2}(B)	; LATIN CAPITAL LETTER Y WITH ACUTE
 ("a8" ?,1e(B)	; LATIN SMALL LETTER A WITH BREVE
 ("A8" ?,2e(B)	; LATIN CAPITAL LETTER A WITH BREVE
 ("i4" ?,1n(B)	; LATIN SMALL LETTER I WITH TILDE
 ("I4" ?,2n(B)	; LATIN CAPITAL LETTER I WITH TILDE
 ("u4" ?,1{(B)	; LATIN SMALL LETTER U WITH TILDE
 ("U4" ?,2{(B)	; LATIN CAPITAL LETTER U WITH TILDE
 ("o7" ?,1=(B)	; LATIN SMALL LETTER O WITH HORN
 ("O7" ?,2=(B)	; LATIN CAPITAL LETTER O WITH HORN
 ("u7" ?,1_(B)	; LATIN SMALL LETTER U WITH HORN
 ("U7" ?,2_(B)	; LATIN CAPITAL LETTER U WITH HORN
 ("a5" ?,1U(B)	; LATIN SMALL LETTER A WITH DOT BELOW
 ("A5" ?,2U(B)	; LATIN CAPITAL LETTER A WITH DOT BELOW
 ("a3" ?,1d(B)	; LATIN SMALL LETTER A WITH HOOK ABOVE
 ("A3" ?,2d(B)	; LATIN CAPITAL LETTER A WITH HOOK ABOVE
 ("a61" ?,1$(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("A61" ?,2$(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("a62" ?,1%(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("A62" ?,2%(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("a63" ?,1&(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND HO6K ABOVE
 ("A63" ?,2&(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND HO6K ABOVE
 ("a64" ?,1g(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND TILDE
 ("A64" ?,2g(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND TILDE
 ("a65" ?,1'(B)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("A65" ?,2'(B)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("a81" ?,1!(B)	; LATIN SMALL LETTER A WITH BREVE AND ACUTE
 ("A81" ?,2!(B)	; LATIN CAPITAL LETTER A WITH BREVE AND ACUTE
 ("a82" ?,1"(B)	; LATIN SMALL LETTER A WITH BREVE AND GRAVE
 ("A82" ?,2"(B)	; LATIN CAPITAL LETTER A WITH BREVE AND GRAVE
 ("a83" ?,1F(B)	; LATIN SMALL LETTER A WITH BREVE AND HO6K ABOVE
 ("A83" ?,2F(B)	; LATIN CAPITAL LETTER A WITH BREVE AND HO6K ABOVE
 ("a84" ?,1G(B)	; LATIN SMALL LETTER A WITH BREVE AND TILDE
 ("A84" ?,2G(B)	; LATIN CAPITAL LETTER A WITH BREVE AND TILDE
 ("a85" ?,1#(B)	; LATIN SMALL LETTER A WITH BREVE AND DOT BELOW
 ("A85" ?,2#(B)	; LATIN CAPITAL LETTER A WITH BREVE AND DOT BELOW
 ("e5" ?,1)(B)	; LATIN SMALL LETTER E WITH DOT BELOW
 ("E5" ?,2)(B)	; LATIN CAPITAL LETTER E WITH DOT BELOW
 ("e3" ?,1k(B)	; LATIN SMALL LETTER E WITH HO6K ABOVE
 ("E3" ?,2k(B)	; LATIN CAPITAL LETTER E WITH HO6K ABOVE
 ("e4" ?,1((B)	; LATIN SMALL LETTER E WITH TILDE
 ("E4" ?,2((B)	; LATIN CAPITAL LETTER E WITH TILDE
 ("e61" ?,1*(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("E61" ?,2*(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("e62" ?,1+(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("E62" ?,2+(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("e63" ?,1,(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND HO6K ABOVE
 ("E63" ?,2,(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND HO6K ABOVE
 ("e64" ?,1-(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND TILDE
 ("E64" ?,2-(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND TILDE
 ("e65" ?,1.(B)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("E65" ?,2.(B)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("i3" ?,1o(B)	; LATIN SMALL LETTER I WITH HO6K ABOVE
 ("I3" ?,2o(B)	; LATIN CAPITAL LETTER I WITH HO6K ABOVE
 ("i5" ?,18(B)	; LATIN SMALL LETTER I WITH DOT BELOW
 ("I5" ?,28(B)	; LATIN CAPITAL LETTER I WITH DOT BELOW
 ("o5" ?,1w(B)	; LATIN SMALL LETTER O WITH DOT BELOW
 ("O5" ?,2w(B)	; LATIN CAPITAL LETTER O WITH DOT BELOW
 ("o3" ?,1v(B)	; LATIN SMALL LETTER O WITH HO6K ABOVE
 ("O3" ?,2v(B)	; LATIN CAPITAL LETTER O WITH HO6K ABOVE
 ("o61" ?,1/(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("O61" ?,2/(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("o62" ?,10(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("O62" ?,20(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("o63" ?,11(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND HO6K ABOVE
 ("O63" ?,21(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND HO6K ABOVE
 ("o64" ?,12(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND TILDE
 ("O64" ?,22(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND TILDE
 ("o65" ?,15(B)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND DOT BELO7
 ("O65" ?,25(B)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND DOT BELO7
 ("o71" ?,1>(B)	; LATIN SMALL LETTER O WITH HORN AND ACUTE
 ("O71" ?,2>(B)	; LATIN CAPITAL LETTER O WITH HORN AND ACUTE
 ("o72" ?,16(B)	; LATIN SMALL LETTER O WITH HORN AND GRAVE
 ("O72" ?,26(B)	; LATIN CAPITAL LETTER O WITH HORN AND GRAVE
 ("o73" ?,17(B)	; LATIN SMALL LETTER O WITH HORN AND HO6K ABOVE
 ("O73" ?,27(B)	; LATIN CAPITAL LETTER O WITH HORN AND HO6K ABOVE
 ("o74" ?,1^(B)	; LATIN SMALL LETTER O WITH HORN AND TILDE
 ("O74" ?,2^(B)	; LATIN CAPITAL LETTER O WITH HORN AND TILDE
 ("o75" ?,1~(B)	; LATIN SMALL LETTER O WITH HORN AND DOT BELO7
 ("O75" ?,2~(B)	; LATIN CAPITAL LETTER O WITH HORN AND DOT BELO7
 ("u5" ?,1x(B)	; LATIN SMALL LETTER U WITH DOT BELO7
 ("U5" ?,2x(B)	; LATIN CAPITAL LETTER U WITH DOT BELO7
 ("u3" ?,1|(B)	; LATIN SMALL LETTER U WITH HO6K ABOVE
 ("U3" ?,2|(B)	; LATIN CAPITAL LETTER U WITH HO6K ABOVE
 ("u71" ?,1Q(B)	; LATIN SMALL LETTER U WITH HORN AND ACUTE
 ("U71" ?,2Q(B)	; LATIN CAPITAL LETTER U WITH HORN AND ACUTE
 ("u72" ?,1W(B)	; LATIN SMALL LETTER U WITH HORN AND GRAVE
 ("U72" ?,2W(B)	; LATIN CAPITAL LETTER U WITH HORN AND GRAVE
 ("u73" ?,1X(B)	; LATIN SMALL LETTER U WITH HORN AND HO6K ABOVE
 ("U73" ?,2X(B)	; LATIN CAPITAL LETTER U WITH HORN AND HO6K ABOVE
 ("u74" ?,1f(B)	; LATIN SMALL LETTER U WITH HORN AND TILDE
 ("U74" ?,2f(B)	; LATIN CAPITAL LETTER U WITH HORN AND TILDE
 ("u75" ?,1q(B)	; LATIN SMALL LETTER U WITH HORN AND DOT BELO7
 ("U75" ?,2q(B)	; LATIN CAPITAL LETTER U WITH HORN AND DOT BELO7
 ("y2" ?,1O(B)	; LATIN SMALL LETTER Y WITH GRAVE
 ("Y2" ?,2O(B)	; LATIN CAPITAL LETTER Y WITH GRAVE
 ("y5" ?,1\(B)	; LATIN SMALL LETTER Y WITH DOT BELO7
 ("Y5" ?,2\(B)	; LATIN CAPITAL LETTER Y WITH DOT BELO7
 ("y3" ?,1V(B)	; LATIN SMALL LETTER Y WITH HO6K ABOVE
 ("Y3" ?,2V(B)	; LATIN CAPITAL LETTER Y WITH HO6K ABOVE
 ("y4" ?,1[(B)	; LATIN SMALL LETTER Y WITH TILDE
 ("Y4" ?,2[(B)	; LATIN CAPITAL LETTER Y WITH TILDE
 ("d9" ?,1p(B)	; LATIN SMALL LETTER D WITH STROKE
 ("D9" ?,2p(B)	; LATIN CAPITAL LETTER D WITH STROKE
;("$$" ?$,1tK(B)	; U+20AB DONG SIGN (#### check)

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
;; coding: iso-2022-7bit
;; End:
