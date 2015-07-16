;;; tibetan.el --- support for Tibetan language -*- coding: utf-8-emacs; -*-

;; Copyright (C) 1997, 2001-2014 Free Software Foundation, Inc.
;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;   2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021
;; Copyright (C) 2003
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H13PRO009

;; Author: Toru TOMABECHI <Toru.Tomabechi@orient.unil.ch>
;; Created: Feb. 17. 1997
;; Keywords: multilingual, Tibetan, i18n

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

;;; History:

;; 1997.03.13 Modification for special signs and punctuation.

;;; Commentary:

;;; Code:

;;; Tibetan Character set.
;;; \x2130 -- \x234a is a subset of Unicode v.2 \x0f00 - \x0fb9
;;; with a slight modification. And there are some subjoined
;;; consonants which are not specified in Unicode.
;;; I hope I can add missing characters later.
;;;
;;;     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
;;;2120 // ö€€ ö€ ö€‚ ö€ƒ ö€„ ö€… ö€† ö€‡ ö€ˆ ö€‰ ö€Š ö€‹ ö€Œ ö€ ö€Ž ; obsolete glyphs (2123-5)
;;;2130 à¼€ à¼ à¼‚ à¼ƒ à¼„ à¼… à¼† à¼‡ à¼ˆ à¼‰ à¼Š à¼‹ à¼Œ à¼ à¼Ž à¼ ; Punctuation,
;;;2140 à¼ à¼‘ à¼’ à¼“ à¼” à¼• à¼– à¼— à¼˜ à¼™ à¼š à¼› à¼œ à¼ à¼ž à¼Ÿ ; Digits and
;;;2150 à¼  à¼¡ à¼¢ à¼£ à¼¤ à¼¥ à¼¦ à¼§ à¼¨ à¼© à¼ª à¼« à¼¬ à¼­ à¼® à¼¯ ; Special signs.
;;;2160 à¼° à¼± à¼² à¼³ à¼´ à¼µ à¼¶ à¼· à¼¸ à¼¹ à¼º à¼» à¼¼ à¼½ à¼¾ à¼¿ ;
;;;2170 ö ö ö‘ ö’ ö“ ö” ö• ö– ö— ö˜ ö™ öš ö› öœ ö // ;
;;;
;;;     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
;;;2220 // à½€ à½ à½‚ à½ƒ à½„ à½… à½† à½‡ ö¦ à½‰ à½Š à½‹ à½Œ à½ à½Ž ; Base consonants
;;;2230 à½ à½ à½‘ à½’ à½“ à½” à½• à½– à½— à½˜ à½™ à½š à½› à½œ à½ à½ž ; and
;;;2240 à½Ÿ à½  à½¡ à½¢ à½£ à½¤ à½¥ à½¦ à½§ à½¨ à½© à½ª ö‚‰ ö‚Š ö‚‹ ö‚Œ ; Vowel signs.
;;;2250 ö‚ ö‚Ž à½± à½² à½³ à½´ à½µ à½¶ à½· à½¸ à½¹ à½º à½» à½¼ à½½ à½¾ ; (\x2251 = vowel a)
;;;2260 à½¿ à¾€ à¾ à¾‚ à¾ƒ à¾„ à¾… à¾† à¾‡ à¾ˆ à¾‰ à¾Š à¾‹ ö‚ª ö‚« ö‚¬ ; Long vowels and
;;;2270 ö‚­ ö‚® ö‚¯ ö‚° ö‚± ö‚² ö‚³ ö‚´ ö‚µ ö‚¶ ö‚· ö‚¸ ö‚¹ ö‚º ö‚» // ; vocalic r, l ARE
;;;                                                     ; atomically
;;;                                                     ; encoded.
;;;     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
;;;2320 // à¾ à¾‘ à¾’ à¾“ à¾” à¾• à¾– à¾— öƒ„ à¾™ à¾š à¾› à¾œ à¾ à¾ž ; Subjoined consonants
;;;2330 à¾Ÿ à¾  à¾¡ à¾¢ à¾£ à¾¤ à¾¥ à¾¦ à¾§ à¾¨ à¾© à¾ª à¾« à¾¬ à¾­ à¾® ;
;;;2340 à¾¯ à¾° à¾± à¾² à¾³ à¾´ à¾µ à¾¶ à¾· à¾¸ à¾¹ à¾º à¾» à¾¼ öƒ© à¾¾ ;
;;;2350 à¾¿ à¿€ à¿ à¿‚ à¿ƒ à¿„ à¿… à¿† à¿‡ à¿ˆ à¿‰ à¿Š à¿‹ à¿Œ öƒ¹ öƒº ; Hereafter, the chars
;;;2360 à¿ öƒ¼ öƒ½ öƒ¾ öƒ¿ ö„€ ö„ ö„‚ ö„ƒ ö„„ ö„… ö„† ö„‡ ö„ˆ ö„‰ ö„Š ; are not specified
;;;2370 ö„‹ ö„Œ ö„ ö„Ž ö„ ö„ ö„‘ ö„’ ö„“ ö„” ö„• ö„– ö„— ö„˜ ö„™ // ; in Unicode.
;;;
;;;     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
;;;2420 // ö„š ö„› ö„œ ö„ ö„ž ö„Ÿ ö„  ö„¡ ö„¢ ö„£ ö„¤ ö„¥ ö„¦ ö„§ ö„¨ ; Precomposed
;;;2430 ö„© ö„ª ö„« ö„¬ ö„­ ö„® ö„¯ ö„° ö„± ö„² ö„³ ö„´ ö„µ ö„¶ ö„· ö„¸ ; consonants for
;;;2440 ö„¹ ö„º ö„» ö„¼ ö„½ ö„¾ ö„¿ ö…€ ö… ö…‚ ö…ƒ ö…„ ö…… ö…† ö…‡ ö…ˆ ; ordinary Tibetan.
;;;2450 ö…‰ ö…Š ö…‹ ö…Œ ö… ö…Ž ö… ö… ö…‘ ö…’ ö…“ ö…” ö…• ö…– ö…— ö…˜ ; They are decomposed
;;;2460 ö…™ ö…š ö…› ö…œ ö… ö…ž ö…Ÿ ö…  ö…¡ ö…¢ ö…£ ö…¤ ö…¥ ö…¦ ö…§ ö…¨ ; into base and
;;;2470 ö…© ö…ª ö…« ö…¬ ö…­ ö…® ö…¯ ö…° ö…± ö…² ö…³ ö…´ ö…µ ö…¶ ö…· // ; subjoined consonants
;;;                                                     ; when written on a
;;;     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F ; file in Tibetan
;;;2520 // ö…¸ ö…¹ ö…º ö…» ö…¼ ö…½ ö…¾ ö…¿ ö†€ ö† ö†‚ ö†ƒ ö†„ ö†… ö†† ; coding system.
;;;2530 ö†‡ ö†ˆ ö†‰ ö†Š ö†‹ ö†Œ ö† ö†Ž ö† ö† ö†‘ ö†’ ö†“ ö†” ö†• ö†– ;
;;;2540 ö†— ö†˜ ö†™ ö†š ö†› ö†œ ö† ö†ž ö†Ÿ ö†  ö†¡ ö†¢ ö†£ ö†¤ ö†¥ ö†¦ ;
;;;2550 ö†§ ö†¨ ö†© ö†ª ö†« ö†¬ ö†­ ö†® ö†¯ ö†° ö†± ö†² ö†³ ö†´ ö†µ ö†¶ ;
;;;2560 ö†· ö†¸ ö†¹ ö†º ö†» ö†¼ ö†½ ö†¾ ö†¿ ö‡€ ö‡ ö‡‚ ö‡ƒ ö‡„ ö‡… ö‡† ;
;;;2570 ö‡‡ ö‡ˆ ö‡‰ ö‡Š ö‡‹ ö‡Œ ö‡ ö‡Ž ö‡ ö‡ ö‡‘ ö‡’ ö‡“ ö‡” ö‡• // ;
;;;


(define-coding-system 'tibetan-iso-8bit
  "8-bit encoding for ASCII (MSB=0) and TIBETAN (MSB=1)."
  :coding-type 'iso-2022
  :mnemonic ?Q
  :designation [ascii tibetan nil nil]
  :charset-list '(ascii tibetan))

(define-coding-system-alias 'tibetan 'tibetan-iso-8bit)

(set-language-info-alist
 "Tibetan" '((charset tibetan tibetan-1-column)
	     (coding-system tibetan-iso-8bit)
	     (coding-priority iso-2022-7bit tibetan-iso-8bit)
	     (input-method . "tibetan-wylie")
	     (features tibet-util)
	     (documentation . t)
	     (sample-text . "Tibetan (à½–à½¼à½‘à¼‹à½¦à¾ö‚Žà½‘à¼‹) à¼„à¼…à¼…à¼Žà½–à½€à¾²ö‚Žà¼‹à½¤à½²à½¦à¼‹à½–à½‘à½ºà¼‹à½£à½ºà½‚à½¦à¼Žà½¨à½¼à½¾à¼‹à½˜ö‚Žà¼‹à½Žà½²à¼‹à½”ö‚Žà½‘à¾¨à½ºà¼‹à½§à½ à½´à¾‚à¼Ž")))

;; `à½ ' is included in the pattern for subjoined consonants because we
;; treat it specially in tibetan-add-components.
;; modified by Tomabechi 1999/12/10
;; modified by Tomabechi 2000/06/08
;;          To allow infinite addition of vowels/modifiers
;;          as specified in Unicode v.3
;; à½  is removed from the class of subjoined. Tomabechi 2000/06/08
;; (for Unicode support)
(defconst tibetan-composable-pattern
  "[à½€-à½©à½ª][à¾-à¾¹à¾ºà¾»à¾¼]*[à½°ö‚Žà½±à½²-à½½à¾€à¾à¾„]*[à½¾à¾‚à¾ƒà¾†-à¾‹à¼™à¼µà¼·]*"
  "Regexp matching a composable sequence of Tibetan characters.")

;;;
;;; Definitions of conversion data.
;;;


;;; alists for tibetan char <-> transcription conversion
;;; longer transcription should come first
(defconst tibetan-consonant-transcription-alist
  '(("tsh" . "à½š")
    ("dzh" . "à½œ")
    ("kSH" . "à½©")
    ("kh" . "à½")
    ("gh" . "à½ƒ")
    ("ng" . "à½„")
    ("ch" . "à½†")
    ("ny" . "à½‰")
    ("TH" . "à½‹")
    ("DH" . "à½")
    ("th" . "à½")
    ("dh" . "à½’")
    ("ph" . "à½•")
    ("bh" . "à½—")
    ("ts" . "à½™")
    ("dz" . "à½›")
    ("zh" . "à½ž")
    ("sh" . "à½¤")
    ("SH" . "à½¥")
    ("k" . "à½€")
    ("g" . "à½‚")
    ("c" . "à½…")
    ("j" . "à½‡")
    ("T" . "à½Š")
    ("D" . "à½Œ")
    ("N" . "à½Ž")
    ("t" . "à½")
    ("d" . "à½‘")
    ("n" . "à½“")
    ("p" . "à½”")
    ("b" . "à½–")
    ("m" . "à½˜")
    ("w" . "à½")
    ("z" . "à½Ÿ")
    ("'" . "à½ ")
    ("y" . "à½¡")
    ("r" . "à½¢")
    ("l" . "à½£")
    ("s" . "à½¦")
    ("h" . "à½§")
    ("H" . "à½§")
    ("A" . "à½¨")
    ;; Added by Tomabechi 1999/12/10
    ("R" . "à½ª") ;; fixed form RA
    ))


(defconst tibetan-vowel-transcription-alist
  '(
    ;; Composite Vowels
    ;; Added by Tomabechi 2000/06/08
    ("frr" . "à½·")
    ("fll" . "à½¹")
    ("fa" . "à½±")
    ("fi" . "à½³")
    ("fu" . "à½µ")
    ("fr" . "à½¶")
    ("fl" . "à½¸")
    ("fI" . "à¾")
    ;; Normal Vowels
    ("ai" . "à½»")
    ("au" . "à½½")
    ("ee" . "à½»")
    ("oo" . "à½½")
    ("a" . "ö‚Ž")			; invisible vowel sign (\x2251)
    ("i" . "à½²")
    ("u" . "à½´")
    ("e" . "à½º")
    ("o" . "à½¼")
    ("E" . "à½»")
    ("O" . "à½½")
    ("I" . "à¾€")
    ("," . "à¾„")			; idem.
    ))

(defconst tibetan-modifier-transcription-alist
  '(("M" . "à½¾")
    ("~" . "à¾‚")
    ("`" . "à¾ƒ")
    ("x" . "à¾ˆ")
    ("X" . "à¾‰")
    ("v" . "à¾†")
    ("V" . "à¾‡")
    ("q" . "à¾Š")
    ("Q" . "à¾‹")
    ("_/" . "à¼™")
    ("_o" . "à¼·")
    ("_O" . "à¼µ")))

(defconst tibetan-precomposed-transcription-alist
  '(("phyw" . "ö…€")
    ("tshw" . "ö„¢")
    ("rtsw" . "ö†…")
    ("khw" . "ö„›")
    ("nyw" . "ö„ž")
    ("tsw" . "ö„¡")
    ("zhw" . "ö„£")
    ("shw" . "ö„§")
    ("khy" . "ö„º")
    ("phy" . "ö„½")
    ("khr" . "ö…Š")
    ("thr" . "ö…")
    ("phr" . "ö…")
    ("shr" . "ö…“")
    ("dzr" . "ö…—")
    ("grw" . "ö…˜")
    ("rng" . "ö…º")
    ("rny" . "ö…¼")
    ("rts" . "ö†‚")
    ("rdz" . "ö†ƒ")
    ("rgw" . "ö†„")
    ("rky" . "ö†‡")
    ("rgy" . "ö†ˆ")
    ("rmy" . "ö†‰")
    ("lng" . "ö†™")
    ("sng" . "ö†©")
    ("sny" . "ö†ª")
    ("sts" . "ö†±")
    ("sky" . "ö†·")
    ("sgy" . "ö†¸")
    ("spy" . "ö†¹")
    ("sby" . "ö†º")
    ("smy" . "ö†»")
    ("skr" . "ö‡‡")
    ("sgr" . "ö‡ˆ")
    ("snr" . "ö‡‰")
    ("spr" . "ö‡Š")
    ("sbr" . "ö‡‹")
    ("smr" . "ö‡Œ")
    ("kw" . "ö„š")
    ("gw" . "ö„œ")
    ("cw" . "ö„")
    ("tw" . "ö„Ÿ")
    ("dw" . "ö„ ")
    ("zw" . "ö„¤")
    ("rw" . "ö„¥")
    ("lw" . "ö„¦")
    ("sw" . "ö„¨")
    ("hw" . "ö„©")
    ("ky" . "ö„¹")
    ("gy" . "ö„»")
    ("py" . "ö„¼")
    ("by" . "ö„¾")
    ("my" . "ö„¿")
    ("kr" . "ö…‰")
    ("gr" . "ö…‹")
    ("tr" . "ö…Œ")
    ("dr" . "ö…Ž")
    ("pr" . "ö…")
    ("brk" . "à½–ö…¸")
    ("brg" . "à½–ö…¹")
    ("brng" . "à½–ö…º")
    ("brj" . "à½–ö…»")
    ("brny" . "à½–ö…¼")
    ("brt" .  "à½–ö…½")
    ("brd" . "à½–ö…¾")
    ("brn" . "à½–ö…¿")
    ("brts" . "à½–ö†‚")
    ("brdz" . "à½–ö†ƒ")
    ("brl" . "à½–ö…")
    ("br" . "ö…‘")
    ("mr" . "ö…’")
    ("sr" . "ö…”")
    ("hr" . "ö…•")
    ("jr" . "ö…–")
    ("kl" . "ö…™")
    ("gl" . "ö…š")
    ("blt" . "à½–ö†œ")
    ("bld" . "à½–ö†")
    ("bl" . "ö…›")
    ("zl" . "ö…œ")
    ("rl" . "ö…")
    ("sl" . "ö…ž")
    ("rk" . "ö…¸")
    ("rg" . "ö…¹")
    ("rj" . "ö…»")
    ("rt" . "ö…½")
    ("rd" . "ö…¾")
    ("rn" . "ö…¿")
    ("rb" . "ö†€")
    ("rm" . "ö†")
    ("lk" . "ö†—")
    ("lg" . "ö†˜")
    ("lc" . "ö†š")
    ("lj" . "ö†›")
    ("lt" . "ö†œ")
    ("ld" . "ö†")
    ("ln" . "ö€€")			; dummy \x2121
    ("lp" . "ö†ž")
    ("lb" . "ö†Ÿ")
    ("lh" . "ö† ")
    ("sk" . "ö†§")
    ("sg" . "ö†¨")
    ("st" . "ö†«")
    ("sd" . "ö†¬")
    ("sn" . "ö†­")
    ("sp" . "ö†®")
    ("sb" . "ö†¯")
    ("sm" . "ö†°"))
  )


(defconst tibetan-subjoined-transcription-alist
  (sort '(("+k"  . "à¾")
	  ("+kh" . "à¾‘")
	  ("+g"  . "à¾’")
	  ("+gh" . "à¾“")
	  ("+ng" . "à¾”")
	  ("+c"  . "à¾•")
	  ("+ch" . "à¾–")
	  ("+j"  . "à¾—")
	  ("+ny"  . "à¾™")
	  ("+T"  . "à¾š")
	  ("+TH" . "à¾›")
	  ("+D"  . "à¾œ")
	  ("+DH" . "à¾")
	  ("+N"  . "à¾ž")
	  ("+t"  . "à¾Ÿ")
	  ("+th" . "à¾ ")
	  ("+d"  . "à¾¡")
	  ("+dh" . "à¾¢")
	  ("+n"  . "à¾£")
	  ("+p"  . "à¾¤")
	  ("+ph" . "à¾¥")
	  ("+b"  . "à¾¦")
	  ("+bh" . "à¾§")
	  ("+m"  . "à¾¨")
	  ("+ts" . "à¾©")
	  ("+tsh" . "à¾ª")
	  ("+dz" . "à¾«")
	  ("+dzh" . "à¾¬")
	  ("+w"  . "à¾­")
	  ("+zh" . "à¾®")
	  ("+z"  . "à¾¯")
	  ("+'"  . "à¾°")
	  ("+y"  . "à¾±")
	  ("+r"  . "à¾²")
	  ("+l"  . "à¾³")
	  ("+sh" . "à¾´")
	  ("+SH" . "à¾µ")
	  ("+s"  . "à¾¶")
	  ("+h"  . "à¾·")
	  ("+A"  . "à¾¸")
	  ("+kSH" . "à¾¹")
	  ;; Added by Tomabechi 1999/12/10
	  ("+W" . "à¾º") ;; fixed form subscribed WA
	  ("+Y" . "à¾»") ;; fixed form subscribed YA
	  ("+R" . "à¾¼") ;; fixed form subscribed RA
	  )
	(lambda (x y) (> (length (car x)) (length (car y))))))

;;;
;;; alist for Tibetan base consonant <-> subjoined consonant conversion.
;;;
(defconst tibetan-base-to-subjoined-alist
  '(("à½€" . "à¾")
    ("à½" . "à¾‘")
    ("à½‚" . "à¾’")
    ("à½ƒ" . "à¾“")
    ("à½„" . "à¾”")
    ("à½…" . "à¾•")
    ("à½†" . "à¾–")
    ("à½‡" . "à¾—")
    ("à½‰" . "à¾™")
    ("à½Š" . "à¾š")
    ("à½‹" . "à¾›")
    ("à½Œ" . "à¾œ")
    ("à½" . "à¾")
    ("à½Ž" . "à¾ž")
    ("à½" . "à¾Ÿ")
    ("à½" . "à¾ ")
    ("à½‘" . "à¾¡")
    ("à½’" . "à¾¢")
    ("à½“" . "à¾£")
    ("à½”" . "à¾¤")
    ("à½•" . "à¾¥")
    ("à½–" . "à¾¦")
    ("à½—" . "à¾§")
    ("à½˜" . "à¾¨")
    ("à½™" . "à¾©")
    ("à½š" . "à¾ª")
    ("à½›" . "à¾«")
    ("à½œ" . "à¾¬")
    ("à½" . "à¾­")
    ("à½ž" . "à¾®")
    ("à½Ÿ" . "à¾¯")
    ("à½ " . "à¾°")
    ("à½¡" . "à¾±")
    ("à½¢" . "à¾²")
    ("à½£" . "à¾³")
    ("à½¤" . "à¾´")
    ("à½¥" . "à¾µ")
    ("à½¦" . "à¾¶")
    ("à½§" . "à¾·")
    ("à½¨" . "à¾¸")
    ("à½©" . "à¾¹")
    ;; Added by Tomabechi 1999/12/10
    ("à½ª" . "à¾¼") ;; Fixed form RA (224B->234D)
    ))

;;; alist for Tibetan composite vowels (long i, vocalic r, etc.)
;;; New variable. created by Tomabechi 2000/06/08
(defconst tibetan-composite-vowel-alist
  '(;; LONG A
    ;; ("à½±" . ((bc . tc) ?à½±))
    ;; LONG I
    ("à½³" . (?à½± (tc . bc) ?à½²))
    ;; LONG U
    ("à½µ" . (?à½± (bc . tc) ?à½´))
    ;; VOCALIC R
    ("à½¶" . (?à¾² (tc . bc) ?à¾€))
    ;; LONG VOCALIC R
    ("à½·" . (?à¾² (bc . tc) ?à½± (tc . bc) ?à¾€))
    ;; VOCALIC L
    ("à½¸" . (?à¾³ (tc . bc) ?à¾€))
    ;;à¼‹LONG VOCALIC L
    ("à½¹" . (?à¾³ (bc . tc) ?à½± (tc . bc) ?à¾€))
    ;; LONG REVERSE I
    ("à¾" . (?à½± (tc . bc) ?à¾€))
    ))



;;;
;;; alist for Tibetan consonantic components <-> precomposed glyph conversion.
;;; (includes some punctuation conversion rules)
;;;
(defconst tibetan-precomposition-rule-alist
  `(("à½•à¾±à¾­" . "ö…€")
    ("à½‚à¾²à¾­" . "ö…˜")
    ("à½šà¾­" . "ö„¢")
    ("à½¢à¾©à¾­" . "ö†…")
    ("à½¢à¾’à¾­" . "ö†„")
    ("à½¢à¾à¾±" . "ö†‡")
    ("à½¢à¾’à¾±" . "ö†ˆ")
    ("à½¢à¾¨à¾±" . "ö†‰")
    ("à½¦à¾à¾±" . "ö†·")
    ("à½¦à¾’à¾±" . "ö†¸")
    ("à½¦à¾¤à¾±" . "ö†¹")
    ("à½¦à¾¦à¾±" . "ö†º")
    ("à½¦à¾¨à¾±" . "ö†»")
    ("à½¦à¾à¾²" . "ö‡‡")
    ("à½¦à¾’à¾²" . "ö‡ˆ")
    ("à½¦à¾£à¾²" . "ö‡‰")
    ("à½¦à¾¤à¾²" . "ö‡Š")
    ("à½¦à¾¦à¾²" . "ö‡‹")
    ("à½¦à¾¨à¾²" . "ö‡Œ")
    ("à½à¾­" . "ö„›")
    ("à½‰à¾­" . "ö„ž")
    ("à½™à¾­" . "ö„¡")
    ("à½žà¾­" . "ö„£")
    ("à½¤à¾­" . "ö„§")
    ("à½à¾±" . "ö„º")
    ("à½•à¾±" . "ö„½")
    ("à½à¾²" . "ö…Š")
    ("à½à¾²" . "ö…")
    ("à½•à¾²" . "ö…")
    ("à½¤à¾²" . "ö…“")
    ("à½›à¾²" . "ö…—")
    ("à½¢à¾”" . "ö…º")
    ("à½¢à¾™" . "ö…¼")
    ("à½¢à¾©" . "ö†‚")
    ("à½¢à¾«" . "ö†ƒ")
    ("à½£à¾”" . "ö†™")
    ("à½¦à¾”" . "ö†©")
    ("à½¦à¾™" . "ö†ª")
    ("à½¦à¾©" . "ö†±")
    ("à½€à¾­" . "ö„š")
    ("à½‚à¾­" . "ö„œ")
    ("à½…à¾­" . "ö„")
    ("à½à¾­" . "ö„Ÿ")
    ("à½‘à¾­" . "ö„ ")
    ("à½Ÿà¾­" . "ö„¤")
    ("à½¢à¾­" . "ö„¥")
    ("à½£à¾­" . "ö„¦")
    ("à½¦à¾­" . "ö„¨")
    ("à½§à¾­" . "ö„©")
    ("à½€à¾±" . "ö„¹")
    ("à½‚à¾±" . "ö„»")
    ("à½”à¾±" . "ö„¼")
    ("à½–à¾±" . "ö„¾")
    ("à½˜à¾±" . "ö„¿")
    ("à½€à¾²" . "ö…‰")
    ("à½‚à¾²" . "ö…‹")
    ("à½à¾²" . "ö…Œ")
    ("à½‘à¾²" . "ö…Ž")
    ("à½”à¾²" . "ö…")
    ("à½–à¾²" . "ö…‘")
    ("à½˜à¾²" . "ö…’")
    ("à½¦à¾²" . "ö…”")
    ("à½§à¾²" . "ö…•")
    ("à½‡à¾²" . "ö…–")
    ("à½€à¾³" . "ö…™")
    ("à½‚à¾³" . "ö…š")
    ("à½–à¾³" . "ö…›")
    ("à½Ÿà¾³" . "ö…œ")
    ("à½¢à¾³" . "ö…")
    ("à½¦à¾³" . "ö…ž")
    ("à½¢à¾" . "ö…¸")
    ("à½¢à¾’" . "ö…¹")
    ("à½¢à¾—" . "ö…»")
    ("à½¢à¾Ÿ" . "ö…½")
    ("à½¢à¾¡" . "ö…¾")
    ("à½¢à¾£" . "ö…¿")
    ("à½¢à¾¦" . "ö†€")
    ("à½¢à¾¨" . "ö†")
    ("à½£à¾" . "ö†—")
    ("à½£à¾’" . "ö†˜")
    ("à½£à¾£" . "ö€€") ; dummy 0x2121 added 2000/06/08 for transition l -> lng
    ("à½£à¾•" . "ö†š")
    ("à½£à¾—" . "ö†›")
    ("à½£à¾Ÿ" . "ö†œ")
    ("à½£à¾¡" . "ö†")
    ("à½£à¾¤" . "ö†ž")
    ("à½£à¾¦" . "ö†Ÿ")
    ("à½£à¾·" . "ö† ")
    ("à½¦à¾" . "ö†§")
    ("à½¦à¾’" . "ö†¨")
    ("à½¦à¾Ÿ" . "ö†«")
    ("à½¦à¾¡" . "ö†¬")
    ("à½¦à¾£" . "ö†­")
    ("à½¦à¾¤" . "ö†®")
    ("à½¦à¾¦" . "ö†¯")
    ("à½¦à¾¨" . "ö†°")))

(defconst tibetan-regexp
  (let ((l (list tibetan-precomposed-transcription-alist
		 tibetan-consonant-transcription-alist
		 tibetan-vowel-transcription-alist
		 tibetan-modifier-transcription-alist
		 tibetan-subjoined-transcription-alist))
	(separator "\\|")
	tail pattern)
    (while l
      (setq tail (car l) l (cdr l))
      (while tail
	(setq pattern (cons separator (cons (car (car tail)) pattern))
	      tail (cdr tail))))
    (apply 'concat (nreverse (cdr pattern))))
  "Regexp matching a Tibetan transcription of a composable Tibetan sequence.
The result of matching is to be used for indexing alists at conversion
from a roman transcription to the corresponding Tibetan character.")

(defvar tibetan-precomposed-regexp
  (purecopy
  (let ((l tibetan-precomposed-transcription-alist)
	temp)
    (setq temp "^\\(")
    (setq temp
	  (concat temp (car (car l))))
    (setq l (cdr l))
    (while l
      (setq temp
	    (concat temp "\\|" (car (car l))))
      (setq l (cdr l)))
    (concat temp "\\)")))
  "Regexp string to match a romanized Tibetan complex consonant.
The result of matching is to be used for indexing alists when the input key
from an input method is converted to the corresponding precomposed glyph.")

(defvar tibetan-precomposition-rule-regexp
  (purecopy
  (let ((l tibetan-precomposition-rule-alist)
	temp)
    (setq temp "\\(")
    (setq temp (concat temp (car (car l))))
    (setq l (cdr l))
    (while l
      (setq temp (concat temp "\\|" (car (car l))))
      (setq l (cdr l)))
    (concat temp "\\)")))
  "Regexp string to match a sequence of Tibetan consonantic components, i.e.,
one base consonant and one or more subjoined consonants.
The result of matching is to be used for indexing alist when the component
sequence is converted to the corresponding precomposed glyph.
This also matches some punctuation characters which need conversion.")

(defvar tibetan-decomposed nil)
(defvar tibetan-decomposed-temp nil)

;; For automatic composition.
(set-char-table-range
 composition-function-table '(#xF00 . #xFD1)
 (list (vector tibetan-composable-pattern 0 'font-shape-gstring)))

(provide 'tibetan)

;;; tibetan.el ends here
