;; hebrew.el --- Quail package for inputting Hebrew characters  -*-coding: utf-8;-*-

;; Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007,
;;   2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Many input methods in this file provided
;; by Yair Friedman <yair.f.lists@gmail.com>

;; Keywords: multilingual, input method, Hebrew

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

(quail-define-package
 "hebrew" "Hebrew" "ע" nil "Hebrew SI-1452 input method.

Based on SI-1452 keyboard layout.
Only Hebrew-related characters are considered.
 'q' is used to switch levels instead of Alt-Gr.
 Maqaaf (־) is mapped to '/פ'.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?\;)
 ("w" ?\')
 ("e" ?ק)  ; Qof
 ("r" ?ר)  ; Resh
 ("t" ?א)  ; Alef
 ("y" ?ט)  ; Tet
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?י)  ; Yod
 ("j" ?ח)  ; Het
 ("k" ?ל)  ; Lamed
 ("l" ?ך)  ; Final Kaf
 (";" ?ף)  ; Final Pe
 ("'" ?,)
 ("z" ?ז)  ; Zayin
 ("x" ?ס)  ; Samekh
 ("c" ?ב)  ; Bet
 ("v" ?ה)  ; He
 ("b" ?נ)  ; Nun
 ("n" ?מ)  ; Mem
 ("m" ?צ)  ; Tsadi
 ("," ?ת)  ; Tav
 ("." ?ץ)  ; Final Tsadi
 ("/" ?.)  ; Stop
 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring
 ("<" ?>)  ; mirroring
 (">" ?<)  ; mirroring
 ("q`" ?ְ)  ; Sheva
 ("q1" ?ֱ)  ; Hataf Segol
 ("q2" ?ֲ)  ; Hataf Patah
 ("q3" ?ֳ)  ; Hataf Qamats
 ("q4" ?ִ)  ; Hiriq
 ("q5" ?ֵ)  ; Tsere
 ("q6" ?ֶ)  ; Segol (Point)
 ("q7" ?ַ)  ; Patah
 ("q8" ?ָ)  ; Qamats
 ("q9" ?ׂ)  ; Sin dot
 ("q0" ?ׁ)  ; Shin dot
 ("q-" ?ֹ)  ; Holam
 ("q=" ?ּ)  ; Dagesh or Mapiq
 ("q\\" ?ֻ)  ; Qubuts
 ("qq" ?/)
 ("qw" ?׳)  ; Geresh (Punct.)
 ("qi" ?װ)  ; Yiddish Double Vav
 ("qp" ?־)  ; Maqaf
 ("q[" ?ֿ)  ; Rafe
 ("q]" ?ֽ)  ; Meteg
 ("qa" ?₪)  ; New Sheqel sign
 ("qh" ?ײ)  ; Yiddish Double Yod
 ("qj" ?ױ)  ; Yiddish Vav Yod
 ("q\"" ?״)  ; Gershayim (Punct.)
 ("q," ?\u200E)  ;  LRM
 ("q." ?\u200F)  ;  RLM
)

(quail-define-package
 "hebrew-new" "Hebrew" "ע" nil "Hebrew SI-1452 new draft input method.

Based on latest draft of SI-1452 keyboard layout.
Only Hebrew-related characters are considered.
 '`' is used to switch levels instead of Alt-Gr.
Geresh is mapped to '`k'.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("q" ?/)
 ("w" ?\')
 ("e" ?ק)  ; Qof
 ("r" ?ר)  ; Resh
 ("t" ?א)  ; Alef
 ("y" ?ט)  ; Tet
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?י)  ; Yod
 ("j" ?ח)  ; Het
 ("k" ?ל)  ; Lamed
 ("l" ?ך)  ; Final Kaf
 (";" ?ף)  ; Final Pe
 ("'" ?,)
 ("z" ?ז)  ; Zayin
 ("x" ?ס)  ; Samekh
 ("c" ?ב)  ; Bet
 ("v" ?ה)  ; He
 ("b" ?נ)  ; Nun
 ("n" ?מ)  ; Mem
 ("m" ?צ)  ; Tsadi
 ("," ?ת)  ; Tav
 ("." ?ץ)  ; Final Tsadi
 ("/" ?.)  ; Stop
 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring
 ("<" ?>)  ; mirroring
 (">" ?<)  ; mirroring

 ("``" ?\;)
 ("`1" ?ֽ)  ; Meteg
;("`2" ??)  ; Unassigned
 ("`3" ?€)  ; Euro Sign
 ("`4" ?₪)  ; New Sheqel sign
 ("`5" ?°)  ; Degree Sign
 ("`6" ?֫)  ; Ole
;("`7" ??)  ; Unassigned
 ("`8" ?×)  ; Multiplication Sign
 ("`9" ?\u200E)  ; LRM
 ("`0" ?\u200F)  ; RLM
 ("`-" ?־)  ; Maqaf
 ("`=" ?–)  ; En Dash
 ("`q" ?ׂ)  ; Sin dot
 ("`w" ?ׁ)  ; Shin dot
 ("`e" ?ָ)  ; Qamats
 ("`r" ?ֳ)  ; Hataf Qamats
;("`t" ??)  ; Unassigned
 ("`y" ?װ)  ; Yiddish Double Vav
 ("`u" ?ֹ)  ; Holam
;("`i" ??)  ; Unassigned
;("`o" ??)  ; Unassigned
 ("`p" ?ַ)  ; Patah
 ("`[" ?ֲ)  ; Hataf Patah
 ("`]" ?ֿ)  ; Rafe
 ("`\\" ?ֻ)  ; Qubuts
 ("`a" ?ְ)  ; Sheva
 ("`s" ?ּ)  ; Dagesh or Mapiq
;("`d" ??)  ; Unassigned
;("`f" ??)  ; Unassigned
 ("`g" ?ױ)  ; Yiddish Vav Yod
 ("`h" ?ײ)  ; Yiddish Double Yod
 ("`j" ?ִ)  ; Hiriq
 ("`k" ?׳)  ; Geresh (Punct.)
 ("`l" ?“)  ; Left Double Quotation Mark
 ("`;" ?”)  ; Right Double Quotation Mark
 ("`'" ?״)  ; Gershayim (Punct.)
;("`z" ??)  ; Unassigned
 ("`x" ?ֶ)  ; Segol (Point)
 ("`c" ?ֱ)  ; Hataf Segol
;("`v" ??)  ; Unassigned
;("`b" ??)  ; Unassigned
;("`n" ??)  ; Unassigned
 ("`m" ?ֵ)  ; Tsere
;("`," ??)  ; Unassigned
;("`." ??)  ; Unassigned
 ("`/" ?÷)  ; Division Sign

 ("``" ?׃)  ; Sof Pasuq
 ("`!" ?֑)  ; Etnahta
 ("`@" ?֒)  ; Segol (Accent)
 ("`#" ?֓)  ; Shalshelet
 ("`$" ?֔)  ; Zaqef Qatan
 ("`%" ?֕)  ; Zaqef Gadol
 ("`^" ?֖)  ; Tipeha
 ("`&" ?֗)  ; Revia
 ("`*" ?֘)  ; Zarqa
 ("`(" ?֙)  ; Pashta
 ("`)" ?֚)  ; Yetiv
 ("`_" ?֛)  ; Tevir
 ("`+" ?֜)  ; Geresh (Accent)
 ("`Q" ?֝)  ; Geresh Muqdam
 ("`W" ?֞)  ; Gershayim (Accent)
 ("`E" ?ׇ)  ; Qamats Qatan
 ("`R" ?֟)  ; Qarney Para
 ("`T" ?֠)  ; Telisha Gedola
 ("`Y" ?֡)  ; Pazer
 ("`U" ?ֺ)  ; Holam Haser for Vav
 ("`I" ?֢)  ; Atnah Hafukh
 ("`O" ?֣)  ; Munah
;("`P" ??)  ; Reserved
 ("`{" ?֤)  ; Mahapakh
 ("`}" ?֥)  ; Merkha
 ("`|" ?֦)  ; Merkha Kefula
;("`A" ??)  ; Reserved
;("`S" ??)  ; Reserved
 ("`D" ?֧)  ; Darga
 ("`F" ?֨)  ; Qadma
 ("`G" ?֩)  ; Telisha Qetana
 ("`H" ?֪)  ; Yerah Ben Yomo
 ("`J" ?\u200D)  ; ZWJ
 ("`K" ?֬)  ; Iluy
 ("`L" ?“)  ; Left Double Quotation Mark (2nd)
 ("`:" ?„)  ; Double Low-9 Quotation Mark
 ("`\"" ?֭)  ; Dehi
 ("`Z" ?֮)  ; Zinor
 ("`X" ?֯)  ; Masora Circle
 ("`C" ?\u034F)  ; CGJ
 ("`V" ?׀)  ; Paseq
 ("`B" ?׆)  ; Nun Hafukha
 ("`N" ?\u200C)  ; ZWNJ
;("`M" ??)  ; Unassigned
;("`<" ??)  ; Unassigned
 ("`>" ?ׅ)  ; Lower Dot
 ("`?" ?ׄ)  ; Upper Dot
)

(quail-define-package
 "hebrew-lyx" "Hebrew" "לִ" nil "Hebrew LyX input method.

Based on LyX keyboard layout.
Additional mappings for Rafe and Yiddish ligatures.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?\;)
 ("_" ?־)  ; Maqaf
 ("q`" ?ְ)  ; Sheva
 ("w" ?\')
 ("e" ?ק)  ; Qof
 ("r" ?ר)  ; Resh
 ("t" ?א)  ; Alef
 ("y" ?ט)  ; Tet
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?י)  ; Yod
 ("j" ?ח)  ; Het
 ("k" ?ל)  ; Lamed
 ("l" ?ך)  ; Final Kaf
 (";" ?ף)  ; Final Pe
 ("'" ?,)
 ("z" ?ז)  ; Zayin
 ("x" ?ס)  ; Samekh
 ("c" ?ב)  ; Bet
 ("v" ?ה)  ; He
 ("b" ?נ)  ; Nun
 ("n" ?מ)  ; Mem
 ("m" ?צ)  ; Tsadi
 ("," ?ת)  ; Tav
 ("." ?ץ)  ; Final Tsadi
 ("/" ?.)  ; Stop
 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("W" ?׳)  ; Geresh (Punct.)
 ("E" ?ָ)  ; Qamats
 ("R" ?ֿ)  ; Rafe
 ("T" ?\u200E)  ; LRM
 ("Y" ?\u200F)  ; RLM
 ("U" ?ֹ)  ; Holam
 ("I" ?ײ)  ; Yiddish Double Yod
 ("O" ?װ)  ; Yiddish Double Vav
 ("P" ?ַ)  ; Patah
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring
 ("A" ?ְ)  ; Sheva
 ("S" ?ּ)  ; Dagesh or Mapiq
 ("F"  ?״)  ; Gershayim (Punct.)
 ("G" ?ׂ)  ; Sin dot
 ("H" ?ׁ)  ; Shin dot
 ("J" ?ִ)  ; Hiriq
 ("K" ?₪)  ; New Sheqel sign
 ("L" ?ױ)  ; Yiddish Vav Yod
 ("X" ?ֶ)  ; Segol (Point)
 ("C" ?ֻ)  ; Qubuts
 ("V" ?ֱ)  ; Hataf Segol
 ("B" ?ֲ)  ; Hataf Patah
 ("N" ?ֳ)  ; Hataf Qamats
 ("M" ?ֵ)  ; Tsere
 ("<" ?>)  ; mirroring
 (">" ?<)  ; mirroring
)


(quail-define-package
 "hebrew-full" "Hebrew" "עִ֫" nil "Hebrew Full method.

Provides access to all Hebrew characters suitable to Modern Hebrew.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?\;)
 ("-" ?־)  ; Maqaf
 ("w" ?')
 ("e" ?ק)  ; Qof
 ("r" ?ר)  ; Resh
 ("t" ?א)  ; Alef
 ("y" ?ט)  ; Tet
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?י)  ; Yod
 ("j" ?ח)  ; Het
 ("k" ?ל)  ; Lamed
 ("l" ?ך)  ; Final Kaf
 (";" ?ף)  ; Final Pe
 ("'" ?,)
 ("z" ?ז)  ; Zayin
 ("x" ?ס)  ; Samekh
 ("c" ?ב)  ; Bet
 ("v" ?ה)  ; He
 ("b" ?נ)  ; Nun
 ("n" ?מ)  ; Mem
 ("m" ?צ)  ; Tsadi
 ("," ?ת)  ; Tav
 ("." ?ץ)  ; Final Tsadi
 ("/" ?.)

 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("Q" ?/)
 ("W" ?׳)  ; Geresh (Punct.)
 ("E" ?₪)  ; New Sheqel Sign
 ("R" ?ֿ)  ; Rafe
 ("T" ?ֱ)  ; Hataf Segol
 ("Y" ?ױ)  ; Yiddish Vav Yod
 ("U" ?װ)  ; Yiddish Double Vav
 ("I" ?ֲ)  ; Hataf Patah
 ("O" ?ֳ)  ; Hataf Qamats
 ("P" ?״)  ; Gershayim (Punct.)
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring
 ("A" ?ְ)  ; Sheva
 ("S" ?ּ)  ; Dagesh or Mapiq
 ("D" ?ֻ)  ; Qubuts
 ("F" ?ֹ)  ; Holam
 ("G" ?ֶ)  ; Segol (Point)
 ("H" ?ֵ)  ; Tsere
 ("J" ?ִ)  ; Hiriq
 ("K" ?ַ)  ; Patah
 ("L" ?ָ)  ; Qamats
 ("Z" ?ׂ)  ; Sin Dot
 ("X" ?ׁ)  ; Shin Dot
 ("C" ?֫)  ; Ole
 ("V" ?ײ)  ; Yiddish Double Yod
 ("B" ?׃)  ; Sof Pasuq
 ("N" ?\u200E)  ; LRM
 ("M" ?\u200F)  ; RLM
 ("<" ?>)  ; mirroring
 (">" ?<)  ; mirroring

 ("q`" ?\u202D)  ; LRO
 ("q1" ?\u202E)  ; RLO
 ("q2" ?\u202A)  ; LRE
 ("q3" ?\u202B)  ; RLE
 ("q4" ?\u202C)  ; PDF
 ("q5" ?\u034F)  ; CGJ
 ("q6" ?֬)  ; Iluy
 ("q8" ?֭)  ; Dehi
 ("q9" ?ׇ)  ; Qamats Qatan
 ("q0" ?֝)  ; Geresh Muqdam
 ("q-" ?-)  ; Minus
 ("q=" ?֮)  ; Zinor
 ("q|" ?׀)  ; Paseq
 ("qw" ?֯)  ; Masora Circle
 ("qe" ?ׄ)  ; Upper Dot
 ("qr" ?ׅ)  ; Lower Dot
 ("qy" ?֟)  ; Qarney Para
 ("qu" ?֓)  ; Shalshelet
 ("qi" ?֞)  ; Gershayim (Accent)
 ("qo" ?֜)  ; Geresh (Accent)
 ("qp" ?֨)  ; Qadma
 ("q[" ?׆)  ; Nun Hafukha
 ("qa" ?ֺ)  ; Holam Haser for Vav
 ("qs" ?֩)  ; Telisha Qetana
 ("qd" ?֠)  ; Telisha Gedola
 ("qf" ?֡)  ; Pazer
 ("qg" ?֕)  ; Zaqef Gadol
 ("qh" ?֔)  ; Zaqef Qatan
 ("qj" ?֙)  ; Pashta
 ("qk" ?֤)  ; Mahapakh
 ("ql" ?֗)  ; Revia
 ("q;" ?֒)  ; Segol (Accent)
 ("q'" ?֘)  ; Zarqa
 ("qz" ?֪)  ; Yerah Ben Yomo
 ("qx" ?֦)  ; Merkha Kefula
 ("qc" ?֚)  ; Yetiv
 ("qv" ?֛)  ; Tevir
 ("qb" ?֧)  ; Darga
 ("qn" ?֑)  ; Etnahta
 ("qm" ?֣)  ; Munah
 ("q," ?֖)  ; Tipeha
 ("q." ?֥)  ; Merkha
 ("q/" ?ֽ)  ; Meteg
)


(quail-define-package
 "hebrew-biblical-tiro" "Hebrew" "תִרֹ" nil
"Biblical Hebrew Tiro input method.

Based on Society of Biblical Literature's Tiro keyboard layout.
Not suitable for modern Hebrew input.
 'q' is used to switch levels instead of Alt-Gr.
 Combining dot above (Called Masora dot) (̇) is mapped to 'q1'.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?׃)  ; Sof Pasuq
 ("-" ?־)  ; Maqaf
 ("=" ?◦)  ; White Bullet
 ("w" ?׳)  ; Geresh (Punct.)
 ("e" ?ק)  ; Qof
 ("r" ?ר)  ; Resh
 ("t" ?א)  ; Alef
 ("y" ?ט)  ; Tet
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("\\" ?׀)  ; Paseq
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?י)  ; Yod
 ("j" ?ח)  ; Het
 ("k" ?ל)  ; Lamed
 ("l" ?ך)  ; Final Kaf
 (";" ?ף)  ; Final Pe
 ("'" ?֚)  ; Yetiv
 ("z" ?ז)  ; Zayin
 ("x" ?ס)  ; Samekh
 ("c" ?ב)  ; Bet
 ("v" ?ה)  ; He
 ("b" ?נ)  ; Nun
 ("n" ?מ)  ; Mem
 ("m" ?צ)  ; Tsadi
 ("," ?ת)  ; Tav
 ("." ?ץ)  ; Final Tsadi
 ("/" ?֭)  ; Dehi
 ("~" ?֮)  ; Zinor
 ("!" ?֩)  ; Telisha Qetana
 ("@" ?֙)  ; Pashta
 ("#" ?֒)  ; Segol (Accent)
 ("$" ?֯)  ; Masora circle
 ("%" ?ֺ)  ; Holam Haser for Vav
 ("^" ?ֹ)  ; Holam
 ("&" ?ֿ)  ; Rafe
 ("*" ?ׂ)  ; Sin dot
 ("(" ?ׁ)  ; Shin dot
 (")" ?֝)  ; Geresh Muqdam
 ("_" ?֠)  ; Telisha Gedola
 ("+" ?ּ)  ; Dagesh or Mapiq
 ("Q" ?ׄ)  ; Upper dot
 ("W" ?֬)  ; Iluy
 ("E" ?֫)  ; Ole
 ("R" ?֟)  ; Qarney Para
 ("T" ?֓)  ; Shalshelet
 ("Y" ?֞)  ; Gershayim (Accent)
 ("U" ?֜)  ; Geresh (Accent)
 ("I" ?֡)  ; Pazer
 ("O" ?֕)  ; Zaqef Gadol
 ("P" ?֔)  ; Zaqef Qatan
 ("{" ?֗)  ; Revia
 ("}" ?֘)  ; Zarqa
 ("|" ?֨)  ; Qadma
 ("A" ?ֽ)  ; Meteg
 ("S" ?ְ)  ; Sheva
 ("D" ?ֻ)  ; Qubuts
 ("F" ?ִ)  ; Hiriq
 ("G" ?ֱ)  ; Hataf Segol
 ("H" ?ֶ)  ; Segol (Point)
 ("J" ?ֵ)  ; Tsere
 ("K" ?ֳ)  ; Hataf Qamats
 ("L" ?ָ)  ; Qamats
 (":" ?ֲ)  ; Hataf Patah
 ("\"" ?ַ)  ; Patah
 ("Z" ?ׅ)  ; Lower dot
 ("X" ?֤)  ; Mahapakh
 ("C" ?֪)  ; Yerah Ben Yomo
 ("V" ?֦)  ; Merkha Kefula
 ("B" ?֥)  ; Merkha
 ("N" ?֧)  ; Darga
 ("M" ?֛)  ; Tevir
 ("<" ?֑)  ; Etnahta
 (">" ?֖)  ; Tipeha
 ("?" ?֣)  ; Munah

 ("q`" ?\;)
 ("q1" ?\u0307)  ; Combining dot above
 ("q2" ?\u0336)  ; Combining long stroke overlay
 ("q3" ?\u030A)  ; Combining ring above
 ("q4" ?₪)  ; New Sheqel Sign
 ("q5" ?\u200D)  ; ZWJ
 ("q6" ?\u200C)  ; ZWNJ
 ("q7" ?\u034F)  ; CGJ
 ("q8" ?\u200E)  ; LRM
 ("q9" ?\u200F)  ; RLM
 ("q0" ?◌)  ; Dotted Circle
 ("q-" ?-)  ; Minus
 ("q=" ?•)  ; Bullet
 ("qq" ?\u0308)  ; Combining Diaeresis
 ("qw" ?״)  ; Gershayim (Punct.)
 ("qe" ?€)  ; Euro Sign
 ("qu" ?װ)  ; Yiddish Double Vav
 ("q\\" ?\\)
 ("qh" ?ײ)  ; Yiddish Double Yod
 ("qj" ?ױ)  ; Yiddish Vav Yod
 ("ql" ?ׇ)  ; Qamats Qatan
 ("q'" ?,)
 ("qc" ?֢)  ; Atnah Hafukh
 ("qb" ?׆)  ; Nun Hafukha
 ("q/" ?.)

 ("q~" ?~)
 ("q!" ?!)
 ("q@" ?@)
 ("q#" ?#)
 ("q$" ?$)
 ("q%" ?%)
 ("q^" ?^)
 ("q&" ?&)
 ("q*" ?*)
 ("q(" ?\))  ; mirroring
 ("q)" ?\()  ; mirroring
 ("q_" ?_)
 ("q+" ?+)
 ("qQ" ?/)
 ("qW" ?')
 ("q{" ?})  ; mirroring
 ("q}" ?{)  ; mirroring
 ("q|" ?|)
 ("q:" ?:)
 ("q\"" ?\")
 ("q<" ?>)
 ("q>" ?<)
 ("q?" ??)
)

(quail-define-package
 "hebrew-biblical-sil" "Hebrew" "סִל" nil
"Biblical Hebrew SIL input method.

Based on Society of Biblical Literature's SIL keyboard layout.
Phonetic and not suitable for modern Hebrew input.
 '`' is used to switch levels instead of Alt-Gr.
 Euro Sign (€) is mapped to 'Z'.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("-" ?־)  ; Maqaf
 ("=" ?ּ)  ; Dagesh or Mapiq
 ("q" ?ק)  ; Qof
 ("w" ?ו)  ; Vav
 ("e" ?ֶ)  ; Segol (Point)
 ("r" ?ר)  ; Resh
 ("t" ?ת)  ; Tav
 ("y" ?י)  ; Yod
 ("u" ?ֻ)  ; Qubuts
 ("i" ?ִ)  ; Hiriq
 ("o" ?ֹ)  ; Holam
 ("p" ?פ)  ; Pe
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("\\" ?׀)  ; Paseq
 ("a" ?ַ)  ; Patah
 ("s" ?ס)  ; Samekh
 ("d" ?ד)  ; Dalet
 ("f" [ "שׂ" ])  ; Shin + Sin dot
 ("g" ?ג)  ; Gimel
 ("h" ?ה)  ; He
 ("j" [ "שׁ" ])  ; Shin + Shin dot
 ("k" ?כ)  ; Kaf
 ("l" ?ל)  ; Lamed
 (";" ?ְ)  ; Sheva
 ("'" ?’)  ; Right Single Quotation Mark
 ("z" ?ז)  ; Zayin
 ("x" ?ח)  ; Het
 ("c" ?צ)  ; Tsadi
 ("v" ?ט)  ; Tet
 ("b" ?ב)  ; Bet
 ("n" ?נ)  ; Nun
 ("m" ?מ)  ; Mem

 ("~" ?₪)  ; New Sheqel Sign
 ("@" ?֘)  ; Zarqa
 ("#" ?֨)  ; Qadma
 ("$" ?֜)  ; Geresh (Accent)
 ("%" ?֞)  ; Gershayim (Accent)
 ("&" ?֬)  ; Iluy
 ("*" ?֝)  ; Geresh Muqdam
 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("_" ?–)  ; Em Dash
 ("Q" ?֗)  ; Revia
 ("E" ?ֵ)  ; Tsere
 ("Y" ?֟)  ; Qarney Para
 ("O" ?ֺ)  ; Holam Haser for Vav
 ("P" ?ף)  ; Final Pe
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring

 ("A" ?ָ)  ; Qamats
 ("S" ?ש)  ; Shin
 ("K" ?ך)  ; Final Kaf
 (":" ?״)  ; Gershayim (Punct.)
 ("\"" ?”)  ; Right Double Quotation Mark
 ("Z" ?€)  ; Euro Sign
 ("C" ?ץ)  ; Final Tsadi
 ("N" ?ן)  ; Final Nun
 ("M" ?ם)  ; Final Mem
 ("<" ?ע)  ; Ayin
 (">" ?א)  ; Alef

 ("``" ?$)
 ("`1" ?ֽ)  ; Meteg
 ("`2" ?֢)  ; Atnah Hafukh
 ("`3" ?֖)  ; Tipeha
 ("`4" ?֥)  ; Merkha
 ("`5" ?֦)  ; Merkha Kefula
 ("`6" ?֭)  ; Dehi
 ("`7" ?֣)  ; Munah
 ("`8" ?֛)  ; Tevir
 ("`9" ?֧)  ; Darga
 ("`0" ?֪)  ; Yerah Ben Yomo
 ("`-" ?—)  ; Em Dash
 ("`=" ?֑)  ; Etnahta
 ("`]" ?֚)  ; Accent Yetiv
 ("`\\" ?֤)  ; Mahapakh
 ("`a" ?ׇ)  ; Qamats Qatan
 ("`g" ? ◦)  ; White Bullet
 ("`h" ?\u0336)  ; Combining Long Stroke Overlay
 ("`;" ?\;)
 ("`'" ?\u0323); Combining Dot Below (Lower Point??)
 ("`m" ?\u200C)  ; ZWNJ
 ("`," ?»)  ; mirroring
 ("`." ?«)  ; mirroring
 ("`/" ?׳)  ; Geresh (Punct.)

 ("`!" ?֗)  ; Revia
 ("`@" ?֮)  ; Zinor
 ("`#" ?֙)  ; Pashta
 ("`$" ?֠)  ; Telisha Gedola
 ("`%" ?֩)  ; Telisha Qetana
 ("`&" ?֡)  ; Pazer
 ("`*" ?֕)  ; Zaqef Gadol
 ("`(" ?֓)  ; Shalshelet
 ("`)" ?֯)  ; Masora Circle
 ("`_" ?ֿ)  ; Rafe
 ("`+" ?◌)  ; Dotted Circle
 ("`E" ?ֱ)  ; Hataf Segol
 ("`O" ?ֳ)  ; Hataf Qamats
 ("`P" ?\u034F)  ; CGJ
 ("`{" ?֔)  ; Zaqef Qatan
 ("`}" ?֒)  ; Segol (Accent)
 ("`|" ?֫)  ; Ole
 ("`A" ?ֲ)  ; Hataf Patah
 ("`G" ?•)  ; Bullet
 ("`H" ?\u030A)  ; Combining ring above
 ("`:" ?׃)  ; Sof Pasuq
 ("`\"" ?ׄ)  ; Upper Dot
 ("`M" ?\u200D)  ; ZWJ
 ("`<" ?\u0307)  ; Combining dot above
 ("`>" ?\u0308)  ; Combining Diaeresis
)


(quail-define-package
 "yiddish-royal" "Hebrew" "ײר" nil "Yiddish Royal input method.

Based on Royal Yiddish typewriter.
Better for yiddish than Hebrew methods.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?~)
 ("q" ?ק)  ; Qof
 ("w" [ "אָ" ])  ; Qamats Alef (Komets Alef)
 ("e" ?ר)  ; Resh
 ("r" ?א)  ; Alef (Shtumer Alef)
 ("t" ?ט)  ; Tet
 ("y" ?װ)  ; Yiddish Double Vav (Tsvey Vovn)
 ("u" ?ו)  ; Vav
 ("i" ?ן)  ; Final Nun
 ("o" ?ם)  ; Final Mem
 ("p" [ "פֿ" ])  ; Rafe Pe (Fey)
 ("[" [ "פּ" ])  ; Dagesh Pe (Pey)
 ("]" ?,)
 ("a" ?ש)  ; Shin
 ("s" ?ד)  ; Dalet
 ("d" ?ג)  ; Gimel
 ("f" ?כ)  ; Kaf
 ("g" ?ע)  ; Ayin
 ("h" ?ײ)  ; Yiddish Double Yod (Tsvey Yudn)
 ("j" ?י)  ; Yod
 ("k" ?ח)  ; Het
 ("l" ?ל)  ; Lamed
 (";" ?ך)  ; Final Kaf
 ("'" ?ף)  ; Final Pe
 ("z" ?.)
 ("x" ?ז)  ; Zayin
 ("c" ?ס)  ; Samekh
 ("v" ?ב)  ; Bet
 ("b" ?ה)  ; He
 ("n" ?נ)  ; Nun
 ("m" ?מ)  ; Mem
 ("," ?צ)  ; Tsadi
 ("." ?ת)  ; Tav
 ("/" ?ץ)  ; Final Tsadi

 ("~" ?@)
 ("!" ?”)  ; Right Double Quotation Mark
 ("@" ?„)  ; Double Low-9 Quotation Mark
 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("Q" ?“)  ; Left Double Quotation Mark
 ("W" ?”)  ; Right Double Quotation Mark
 ("E" ?ײ)  ; Yiddish Double Yod (x2)
 ("R" [ "אַ" ])  ; Patah Alef (Pasekh Alef)
; ("T" "")
 ("Y" ?ױ)  ; Ligature Yiddish Vav Yod (vov yud)
 ("U" [ "וּ" ])  ; Melupm vov
 ("I" ?/)
 ("O" ?\\)
 ("P" ?פ)  ; Pe
 ("{" ??)
 ("}" ?!)
 ("A" [ "שׂ" ])  ; Shin + Sin dot
 ("S" [ "שׂ" ])  ; Shin + Sin dot
; ("D" "")
 ("F" [ "כּ" ])  ; Dagesh Kaf (Kof)
; ("G" "")
 ("H" [ "ײַ" ])  ; Yiddish Double Yod + Patah (Pasekh Tsvey Yudn)
 ("J" [ "יִ" ])  ; Khirik Yud
 ("K" ?})  ; mirroring
 ("L" ?{)  ; mirroring
 ("\"" ?\;)
 ("Z" ??)
 ("X" ?|)
 ("C"  [ "בּ" ])  ; Dagesh Bet (Beys)
 ("V" [ "בֿ" ])  ; Rafe Bet (Veys)
 ("B" ?\])  ; mirroring
 ("N" ?\[)  ; mirroring
 ("M" ?>)  ; mirroring
 ("<" ?<)  ; mirroring
 (">" [ "תּ" ])  ; Dagesh Tav (Tof)
 ("?" ?\')
)


(quail-define-package
 "yiddish-keyman" "Hebrew" "ײק" nil "Yiddish Keyman input method.

Based on Keyman keyboard layout.
Better for yiddish than Hebrew methods..
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("`" ?\;)
 ("q" ?„)  ; Double Low-9 Quotation Mark
 ("w" ?ש)  ; Shin
 ("e" ?ע)  ; Ayin
 ("r" ?ר)  ; Resh
 ("t" ?ט)  ; Tet
 ("y" ?י)  ; Yod
 ("u" ?ו)  ; Vav
 ("i" ?י)  ; Yod (x2)
 ("o" [ "אָ" ])  ; Qamats Alef (Komets Alef)
 ("p" [ "פּ" ])  ; Dagesh Pe (Pey)
 ("[" ?\])  ; mirroring
 ("]" ?\[)  ; mirroring
 ("a"  [ "אַ" ])  ; Patah Alef (Pasekh Alef)
 ("s" ?ס)  ; Samekh
 ("d" ?ד)  ; Dalet
 ("f" [ "פֿ" ])  ; Rafe Pe (Fey)
 ("g" ?ג)  ; Gimel
 ("h" ?ה)  ; He
 ("j" ?ײ)  ; Yiddish Double Yod (Tsvey Yudn)
 ("k" ?ק)  ; Qof
 ("l" ?ל)  ; Lamed
 ("z" ?ז)  ; Zayin
 ("x" ?כ)  ; Kaf
 ("c" ?צ)  ; Tsadi
 ("v" ?װ)  ; Yiddish Double Vav (Tsvey Vovn)
 ("b" ?ב)  ; Bet
 ("n" ?נ)  ; Nun
 ("m" ?מ)  ; Mem

 ("(" ?\))  ; mirroring
 (")" ?\()  ; mirroring
 ("Q" ?”)  ; Right Double Quotation Mark
 ("W" [ "שׂ" ])  ; Shin + Sin dot
 ("E" ?ײ)  ; Yiddish Double Yod (x2)
; ("R" "")  ;
 ("T" [ "תּ" ])  ; Dagesh Tav (Tof)
 ("Y" [ "ײַ" ])  ; Yiddish Double Yod + Patah (Pasekh Tsvey Yudn)
 ("U" [ "וּ" ])  ; Melupm vov
 ("I" [ "יִ" ])  ; Khirik Yud
 ("O" ?ױ)  ; Ligature Yiddish Vav Yod (vov yud)
; ("P" "")
 ("{" ?})  ; mirroring
 ("}" ?{)  ; mirroring
 ("A" ?א)  ; Alef (Shtumer Alef)
 ("S" ?ת)  ; Tav
 ("F"  ?ף)  ; Final Pe
 ("G" ?׳)  ; Geresh (Punct.)
 ("H" ?ח)  ; Het
 ("J" ?ײ)  ; Yiddish Double Yod (x2)
 ("K" [ "כּ" ])  ; Dagesh Kaf (Kof)
; ("L" "")
; ("Z" "")
 ("X" ?ך)  ; Final Kaf
 ("C" ?ץ)  ; Final Tsadi
 ("V" [ "בֿ" ])  ; Rafe Bet (Veys) )  ; Bet
; ("B" "")
 ("N" ?ן)  ; Final Nun
 ("M" ?ם)  ; Final Mem
 ("<" ?>)  ; mirroring
 (">" ?<)  ; mirroring
)

;;; hebrew.el ends here
