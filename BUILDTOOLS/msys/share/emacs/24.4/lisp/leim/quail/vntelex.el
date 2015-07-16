;;; vntelex.el --- Quail package for Vietnamese by Telex method

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.

;; Author:   Werner Lemberg <wl@gnu.org>
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

;; based on the files VietnameseTelex.kmap (written by Nguyen Thanh
;; Bien <biennt@linuxvn.com>) and VNtelex.kmap (written by Nguyen Dai
;; Quy <DaiQuy.Nguyen@ulg.ac.be>) from the yudit 2.4 package

;;; Code:

(require 'quail)


(quail-define-package
 "vietnamese-telex"              ; NAME
 "Vietnamese"                    ; LANGUAGE
 "VT"                            ; TITLE
 t                               ; GUIDANCE
 "Vietnamese telex input method

Vowels with circumflex:

  aa -> â, EE -> Ê, etc.

Other diacritics:

  effect     postfix   examples
  ------------------------------
  breve         w      aw -> ă
  horn          w      ow -> ơ

  acute         s      as -> á
  grave         f      af -> à
  hook above    r      ar -> ả
  tilde         x      ax -> ã
  dot below     j      aj -> ạ

  d bar                dd -> đ

Combinations:

  AWF -> Ằ, owx -> ỡ, etc.

Alternatives:

  EE = Ee -> Ê, AWF = Awf -> Ằ, etc.

Doubling the postfix (but not in combinations) separates the letter
and postfix: Eee -> Ee, ajj -> aj, etc.
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
 ("af" ?à)	; LATIN SMALL LETTER A WITH GRAVE
 ("AF" ?À)	; LATIN CAPITAL LETTER A WITH GRAVE
 ("Af" ?À)
 ("as" ?á)	; LATIN SMALL LETTER A WITH ACUTE
 ("AS" ?Á)	; LATIN CAPITAL LETTER A WITH ACUTE
 ("As" ?Á)
 ("aa" ?â)	; LATIN SMALL LETTER A WITH CIRCUMFLEX
 ("AA" ?Â)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
 ("Aa" ?Â)
 ("ax" ?ã)	; LATIN SMALL LETTER A WITH TILDE
 ("AX" ?Ã)	; LATIN CAPITAL LETTER A WITH TILDE
 ("Ax" ?Ã)
 ("ef" ?è)	; LATIN SMALL LETTER E WITH GRAVE
 ("EF" ?È)	; LATIN CAPITAL LETTER E WITH GRAVE
 ("Ef" ?È)
 ("es" ?é)	; LATIN SMALL LETTER E WITH ACUTE
 ("ES" ?É)	; LATIN CAPITAL LETTER E WITH ACUTE
 ("Es" ?É)
 ("ee" ?ê)	; LATIN SMALL LETTER E WITH CIRCUMFLEX
 ("EE" ?Ê)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
 ("Ee" ?Ê)
 ("if" ?ì)	; LATIN SMALL LETTER I WITH GRAVE
 ("IF" ?Ì)	; LATIN CAPITAL LETTER I WITH GRAVE
 ("If" ?Ì)
 ("is" ?í)	; LATIN SMALL LETTER I WITH ACUTE
 ("IS" ?Í)	; LATIN CAPITAL LETTER I WITH ACUTE
 ("Is" ?Í)
 ("of" ?ò)	; LATIN SMALL LETTER O WITH GRAVE
 ("OF" ?Ò)	; LATIN CAPITAL LETTER O WITH GRAVE
 ("Of" ?Ò)
 ("os" ?ó)	; LATIN SMALL LETTER O WITH ACUTE
 ("OS" ?Ó)	; LATIN CAPITAL LETTER O WITH ACUTE
 ("Os" ?Ó)
 ("oo" ?ô)	; LATIN SMALL LETTER O WITH CIRCUMFLEX
 ("OO" ?Ô)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
 ("Oo" ?Ô)
 ("ox" ?õ)	; LATIN SMALL LETTER O WITH TILDE
 ("OX" ?Õ)	; LATIN CAPITAL LETTER O WITH TILDE
 ("Ox" ?Õ)
 ("uf" ?ù)	; LATIN SMALL LETTER U WITH GRAVE
 ("UF" ?Ù)	; LATIN CAPITAL LETTER U WITH GRAVE
 ("Uf" ?Ù)
 ("us" ?ú)	; LATIN SMALL LETTER U WITH ACUTE
 ("US" ?Ú)	; LATIN CAPITAL LETTER U WITH ACUTE
 ("Us" ?Ú)
 ("ys" ?ý)	; LATIN SMALL LETTER Y WITH ACUTE
 ("YS" ?Ý)	; LATIN CAPITAL LETTER Y WITH ACUTE
 ("Ys" ?Ý)
 ("aw" ?ă)	; LATIN SMALL LETTER A WITH BREVE
 ("AW" ?Ă)	; LATIN CAPITAL LETTER A WITH BREVE
 ("Aw" ?Ă)
 ("ix" ?ĩ)	; LATIN SMALL LETTER I WITH TILDE
 ("IX" ?Ĩ)	; LATIN CAPITAL LETTER I WITH TILDE
 ("Ix" ?Ĩ)
 ("ux" ?ũ)	; LATIN SMALL LETTER U WITH TILDE
 ("UX" ?Ũ)	; LATIN CAPITAL LETTER U WITH TILDE
 ("Ux" ?Ũ)
 ("ow" ?ơ)	; LATIN SMALL LETTER O WITH HORN
 ("OW" ?Ơ)	; LATIN CAPITAL LETTER O WITH HORN
 ("Ow" ?Ơ)
 ("uw" ?ư)	; LATIN SMALL LETTER U WITH HORN
 ("UW" ?Ư)	; LATIN CAPITAL LETTER U WITH HORN
 ("Uw" ?Ư)
 ("aj" ?ạ)	; LATIN SMALL LETTER A WITH DOT BELOW
 ("AJ" ?Ạ)	; LATIN CAPITAL LETTER A WITH DOT BELOW
 ("Aj" ?Ạ)
 ("ar" ?ả)	; LATIN SMALL LETTER A WITH HOOK ABOVE
 ("AR" ?Ả)	; LATIN CAPITAL LETTER A WITH HOOK ABOVE
 ("Ar" ?Ả)
 ("aas" ?ấ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("AAS" ?Ấ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND ACUTE
 ("Aas" ?Ấ)
 ("aaf" ?ầ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("AAF" ?Ầ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND GRAVE
 ("Aaf" ?Ầ)
 ("aar" ?ẩ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE
 ("AAR" ?Ẩ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE
 ("Aar" ?Ẩ)
 ("aax" ?ẫ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND TILDE
 ("AAX" ?Ẫ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND TILDE
 ("Aax" ?Ẫ)
 ("aaj" ?ậ)	; LATIN SMALL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("AAJ" ?Ậ)	; LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND DOT BELOW
 ("Aaj" ?Ậ)
 ("aws" ?ắ)	; LATIN SMALL LETTER A WITH BREVE AND ACUTE
 ("AWS" ?Ắ)	; LATIN CAPITAL LETTER A WITH BREVE AND ACUTE
 ("Aws" ?Ắ)
 ("awf" ?ằ)	; LATIN SMALL LETTER A WITH BREVE AND GRAVE
 ("AWF" ?Ằ)	; LATIN CAPITAL LETTER A WITH BREVE AND GRAVE
 ("Awf" ?Ằ)
 ("awr" ?ẳ)	; LATIN SMALL LETTER A WITH BREVE AND HOOK ABOVE
 ("AWR" ?Ẳ)	; LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE
 ("Awr" ?Ẳ)
 ("awx" ?ẵ)	; LATIN SMALL LETTER A WITH BREVE AND TILDE
 ("AWX" ?Ẵ)	; LATIN CAPITAL LETTER A WITH BREVE AND TILDE
 ("Awx" ?Ẵ)
 ("awj" ?ặ)	; LATIN SMALL LETTER A WITH BREVE AND DOT BELOW
 ("AWJ" ?Ặ)	; LATIN CAPITAL LETTER A WITH BREVE AND DOT BELOW
 ("Awj" ?Ặ)
 ("ej" ?ẹ)	; LATIN SMALL LETTER E WITH DOT BELOW
 ("EJ" ?Ẹ)	; LATIN CAPITAL LETTER E WITH DOT BELOW
 ("Ej" ?Ẹ)
 ("er" ?ẻ)	; LATIN SMALL LETTER E WITH HOOK ABOVE
 ("ER" ?Ẻ)	; LATIN CAPITAL LETTER E WITH HOOK ABOVE
 ("Er" ?Ẻ)
 ("ex" ?ẽ)	; LATIN SMALL LETTER E WITH TILDE
 ("EX" ?Ẽ)	; LATIN CAPITAL LETTER E WITH TILDE
 ("Ex" ?Ẽ)
 ("ees" ?ế)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("EES" ?Ế)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND ACUTE
 ("Ees" ?Ế)
 ("eef" ?ề)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("EEF" ?Ề)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND GRAVE
 ("Eef" ?Ề)
 ("eer" ?ể)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE
 ("EER" ?Ể)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE
 ("Eer" ?Ể)
 ("eex" ?ễ)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND TILDE
 ("EEX" ?Ễ)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND TILDE
 ("Eex" ?Ễ)
 ("eej" ?ệ)	; LATIN SMALL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("EEJ" ?Ệ)	; LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND DOT BELOW
 ("Eej" ?Ệ)
 ("ir" ?ỉ)	; LATIN SMALL LETTER I WITH HOOK ABOVE
 ("IR" ?Ỉ)	; LATIN CAPITAL LETTER I WITH HOOK ABOVE
 ("Ir" ?Ỉ)
 ("ij" ?ị)	; LATIN SMALL LETTER I WITH DOT BELOW
 ("IJ" ?Ị)	; LATIN CAPITAL LETTER I WITH DOT BELOW
 ("Ij" ?Ị)
 ("oj" ?ọ)	; LATIN SMALL LETTER O WITH DOT BELOW
 ("OJ" ?Ọ)	; LATIN CAPITAL LETTER O WITH DOT BELOW
 ("Oj" ?Ọ)
 ("or" ?ỏ)	; LATIN SMALL LETTER O WITH HOOK ABOVE
 ("OR" ?Ỏ)	; LATIN CAPITAL LETTER O WITH HOOK ABOVE
 ("Or" ?Ỏ)
 ("oos" ?ố)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("OOS" ?Ố)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND ACUTE
 ("Oos" ?Ố)
 ("oof" ?ồ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("OOF" ?Ồ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND GRAVE
 ("Oof" ?Ồ)
 ("oor" ?ổ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE
 ("OOR" ?Ổ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE
 ("Oor" ?Ổ)
 ("oox" ?ỗ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND TILDE
 ("OOX" ?Ỗ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND TILDE
 ("Oox" ?Ỗ)
 ("ooj" ?ộ)	; LATIN SMALL LETTER O WITH CIRCUMFLEX AND DOT BELOW
 ("OOJ" ?Ộ)	; LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND DOT BELOW
 ("Ooj" ?Ộ)
 ("ows" ?ớ)	; LATIN SMALL LETTER O WITH HORN AND ACUTE
 ("OWS" ?Ớ)	; LATIN CAPITAL LETTER O WITH HORN AND ACUTE
 ("Ows" ?Ớ)
 ("owf" ?ờ)	; LATIN SMALL LETTER O WITH HORN AND GRAVE
 ("OWF" ?Ờ)	; LATIN CAPITAL LETTER O WITH HORN AND GRAVE
 ("Owf" ?Ờ)
 ("owr" ?ở)	; LATIN SMALL LETTER O WITH HORN AND HOOK ABOVE
 ("OWR" ?Ở)	; LATIN CAPITAL LETTER O WITH HORN AND HOOK ABOVE
 ("Owr" ?Ở)
 ("owx" ?ỡ)	; LATIN SMALL LETTER O WITH HORN AND TILDE
 ("OWX" ?Ỡ)	; LATIN CAPITAL LETTER O WITH HORN AND TILDE
 ("Owx" ?Ỡ)
 ("owj" ?ợ)	; LATIN SMALL LETTER O WITH HORN AND DOT BELOW
 ("OWJ" ?Ợ)	; LATIN CAPITAL LETTER O WITH HORN AND DOT BELOW
 ("Owj" ?Ợ)
 ("uj" ?ụ)	; LATIN SMALL LETTER U WITH DOT BELOW
 ("UJ" ?Ụ)	; LATIN CAPITAL LETTER U WITH DOT BELOW
 ("Uj" ?Ụ)
 ("ur" ?ủ)	; LATIN SMALL LETTER U WITH HOOK ABOVE
 ("UR" ?Ủ)	; LATIN CAPITAL LETTER U WITH HOOK ABOVE
 ("Ur" ?Ủ)
 ("uws" ?ứ)	; LATIN SMALL LETTER U WITH HORN AND ACUTE
 ("UWS" ?Ứ)	; LATIN CAPITAL LETTER U WITH HORN AND ACUTE
 ("Uws" ?Ứ)
 ("uwf" ?ừ)	; LATIN SMALL LETTER U WITH HORN AND GRAVE
 ("UWF" ?Ừ)	; LATIN CAPITAL LETTER U WITH HORN AND GRAVE
 ("Uwf" ?Ừ)
 ("uwr" ?ử)	; LATIN SMALL LETTER U WITH HORN AND HOOK ABOVE
 ("UWR" ?Ử)	; LATIN CAPITAL LETTER U WITH HORN AND HOOK ABOVE
 ("Uwr" ?Ử)
 ("uwx" ?ữ)	; LATIN SMALL LETTER U WITH HORN AND TILDE
 ("UWX" ?Ữ)	; LATIN CAPITAL LETTER U WITH HORN AND TILDE
 ("Uwx" ?Ữ)
 ("uwj" ?ự)	; LATIN SMALL LETTER U WITH HORN AND DOT BELOW
 ("UWJ" ?Ự)	; LATIN CAPITAL LETTER U WITH HORN AND DOT BELOW
 ("Uwj" ?Ự)
 ("yf" ?ỳ)	; LATIN SMALL LETTER Y WITH GRAVE
 ("YF" ?Ỳ)	; LATIN CAPITAL LETTER Y WITH GRAVE
 ("Yf" ?Ỳ)
 ("yj" ?ỵ)	; LATIN SMALL LETTER Y WITH DOT BELOW
 ("YJ" ?Ỵ)	; LATIN CAPITAL LETTER Y WITH DOT BELOW
 ("Yj" ?Ỵ)
 ("yr" ?ỷ)	; LATIN SMALL LETTER Y WITH HOOK ABOVE
 ("YR" ?Ỷ)	; LATIN CAPITAL LETTER Y WITH HOOK ABOVE
 ("Yr" ?Ỷ)
 ("yx" ?ỹ)	; LATIN SMALL LETTER Y WITH TILDE
 ("YX" ?Ỹ)	; LATIN CAPITAL LETTER Y WITH TILDE
 ("Yx" ?Ỹ)
 ("dd" ?đ)	; LATIN SMALL LETTER D WITH STROKE
 ("DD" ?Đ)	; LATIN CAPITAL LETTER D WITH STROKE
 ("Dd" ?Đ)
;("$$" ?₫)	; U+20AB DONG SIGN (#### check)

 ("aff" ["af"])
 ("AFF" ["AF"])
 ("Aff" ["Af"])
 ("ass" ["as"])
 ("ASS" ["AS"])
 ("Ass" ["As"])
 ("aaa" ["aa"])
 ("AAA" ["AA"])
 ("Aaa" ["Aa"])
 ("axx" ["ax"])
 ("AXX" ["AX"])
 ("Axx" ["Ax"])
 ("eff" ["ef"])
 ("EFF" ["EF"])
 ("Eff" ["Ef"])
 ("ess" ["es"])
 ("ESS" ["ES"])
 ("Ess" ["Es"])
 ("eee" ["ee"])
 ("EEE" ["EE"])
 ("Eee" ["Ee"])
 ("iff" ["if"])
 ("IFF" ["IF"])
 ("Iff" ["If"])
 ("iss" ["is"])
 ("ISS" ["IS"])
 ("Iss" ["Is"])
 ("off" ["of"])
 ("OFF" ["OF"])
 ("Off" ["Of"])
 ("oss" ["os"])
 ("OSS" ["OS"])
 ("Oss" ["Os"])
 ("ooo" ["oo"])
 ("OOO" ["OO"])
 ("Ooo" ["Oo"])
 ("oxx" ["ox"])
 ("OXX" ["OX"])
 ("Oxx" ["Ox"])
 ("uff" ["uf"])
 ("UFF" ["UF"])
 ("Uff" ["Uf"])
 ("uss" ["us"])
 ("USS" ["US"])
 ("Uss" ["Us"])
 ("yss" ["ys"])
 ("YSS" ["YS"])
 ("Yss" ["Ys"])
 ("aww" ["aw"])
 ("AWW" ["AW"])
 ("Aww" ["Aw"])
 ("ixx" ["ix"])
 ("IXX" ["IX"])
 ("Ixx" ["Ix"])
 ("uxx" ["ux"])
 ("UXX" ["UX"])
 ("Uxx" ["ux"])
 ("oww" ["ow"])
 ("OWW" ["OW"])
 ("Oww" ["Ow"])
 ("uww" ["uw"])
 ("UWW" ["UW"])
 ("Uww" ["Uw"])
 ("ajj" ["aj"])
 ("AJJ" ["AJ"])
 ("Ajj" ["Aj"])
 ("arr" ["ar"])
 ("ARR" ["AR"])
 ("Arr" ["Ar"])
 ("ejj" ["ej"])
 ("EJJ" ["EJ"])
 ("Ejj" ["Ej"])
 ("err" ["er"])
 ("ERR" ["ER"])
 ("Err" ["Er"])
 ("exx" ["ex"])
 ("EXX" ["EX"])
 ("Exx" ["Ex"])
 ("irr" ["ir"])
 ("IRR" ["IR"])
 ("Irr" ["Ir"])
 ("ijj" ["ij"])
 ("IJJ" ["IJ"])
 ("Ijj" ["Ij"])
 ("ojj" ["oj"])
 ("OJJ" ["OJ"])
 ("Ojj" ["Oj"])
 ("orr" ["or"])
 ("ORR" ["OR"])
 ("Orr" ["Or"])
 ("ujj" ["uj"])
 ("UJJ" ["UJ"])
 ("Ujj" ["Uj"])
 ("urr" ["ur"])
 ("URR" ["UR"])
 ("Urr" ["Ur"])
 ("yff" ["yf"])
 ("YFF" ["YF"])
 ("Yff" ["Yf"])
 ("yjj" ["yj"])
 ("YJJ" ["YJ"])
 ("Yjj" ["Yj"])
 ("yrr" ["yr"])
 ("YRR" ["YR"])
 ("Yrr" ["Yr"])
 ("yxx" ["yx"])
 ("YXX" ["YX"])
 ("Yxx" ["Yx"])
 ("ddd" ["dd"])
 ("DDD" ["DD"])
 ("Ddd" ["Dd"])
;("$$$" ["$$"])

 ;; escape from composition
 ("\\w" ?w)	; breve or horn
 ("\\W" ?W)
 ("\\a" ?a)	; a circumflex
 ("\\A" ?A)	; A circumflex
 ("\\e" ?e)	; e circumflex
 ("\\E" ?E)	; E circumflex
 ("\\o" ?o)	; o circumflex
 ("\\O" ?O)	; O circumflex
 ("\\s" ?s)	; acute
 ("\\S" ?S)
 ("\\f" ?f)	; grave
 ("\\F" ?F)
 ("\\r" ?r)	; hook above
 ("\\R" ?R)
 ("\\x" ?x)	; tilde
 ("\\X" ?X)
 ("\\j" ?j)	; dot below
 ("\\J" ?J)
 ("\\d" ?d)	; d-bar (d)
 ("\\D" ?D)	; D-bar (d)
 ("\\\\" ?\\)	; literal backslash
)

;; Local Variables:
;; coding: utf-8
;; End:

;;; vntelex.el ends here
