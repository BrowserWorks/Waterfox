;;; tibetan.el --- Quail package for inputting Tibetan characters -*-coding: utf-8-emacs;-*-

;; Copyright (C) 1997, 2001-2014 Free Software Foundation, Inc.
;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;   2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Keywords: multilingual, input method, Tibetan

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

;; Author: Toru TOMABECHI <Toru.Tomabechi@orient.unil.ch>

;; Created: Feb. 17. 1997

;; History:
;; 1997.03.13 Support for inputting special signs and punctuation added.
;;            (Only Ext. Wylie input)

;;; Commentary:

;;; Code:

(require 'quail)
(require 'tibet-util)

;; Now quail-current-key is set to Tibetan-Roman transcription.  We
;; set quail-current-str to the corresponding Tibetan string (composed
;; if necessary).  Both Wylie and TibKey input methods use this
;; function.

(defun quail-tibetan-update-translation (control-flag)
  (if (numberp control-flag)
      ;; Non-composable-character typed.
      (setq quail-current-str
	    (buffer-substring (overlay-start quail-overlay)
			      (overlay-end quail-overlay))
	    unread-command-events
	    (string-to-list
	     (substring quail-current-key control-flag)))
    ;; Special treatment of "-d..." and "-y...".
    (if (string-match "^-[dy]" quail-current-key)
	(setq quail-current-key (substring quail-current-key 1)))
    (let ((str (tibetan-transcription-to-tibetan quail-current-key)))
      ;; If quail-current-key is for punctuation, it can't be
      ;; transcribed by tibetan-transcription-to-tibetan, thus STR
      ;; contains ASCII string now.  In that case, use the current
      ;; characters set in quail-current-str.
      (if (> (aref str 0) 255)
	  (setq quail-current-str (tibetan-compose-string str))
	(or quail-current-str
	    (setq quail-current-str quail-current-key)))))
  control-flag)

;;; Wylie transcription based input methods.

;; Special alist for `འ'.  It must be treated as a subjoined
;; consonant if it follows a consonant.
;; * Removed by Tomabechi 2000/06/10 *
;; 'a chung must be explicitly typed as a vowel ("fa")
;; འ is now treated as normal base consonants
;; (defconst tibetan-wylie-quote-alist '(("'" . ?འ)))

;; Special alist to avoid default stacking.
(defconst tibetan-wylie-non-stacking-alist
  '(("-d" . "ད")
    ("-y" . "ཡ")))

;; Punctuation characters are not transcribed.

(defconst tibetan-wylie-punctuation-alist
   '(("."  . " ")
     (":"  . "ཿ")
     (" "  . "་")
     ("/"  . "།")
     ("//" . "༎")
     ("////" . ["༎ ༎"])
     ("$"  . "༏")
     ("/\"" . "༐")			; Not defined in Ext. Wylie.
     ("&"  . "༐")
     (";"  . "༑")
     ("%"  . "༔")
     ("!"  . "༈")
     ("<"  . "༼")
     (">"  . "༽")
     ("@"  . "྅")
     ("*"  . ["༄༅"])
     ("#"  . ["༄༅༅"])
     ("^"  . "༆")
     ("0" . "༠")
     ("1" . "༡")
     ("2" . "༢")
     ("3" . "༣")
     ("4" . "༤")
     ("5" . "༥")
     ("6" . "༦")
     ("7" . "༧")
     ("8" . "༨")
     ("9" . "༩")
     ("-0" . "༳")
     ("-1" . "༪")
     ("-2" . "༫")
     ("-3" . "༬")
     ("-4" . "༭")
     ("-5" . "༮")
     ("-6" . "༯")
     ("-7" . "༰")
     ("-8" . "༱")
     ("-9" . "༲")
     ("|"  . "ༀ༁༂༃༇༉༊༒༓༕༖༗༘༙༚༛༜༝༞༟༴༶༸༺༻༾༿྾྿࿀࿁࿂࿃࿄࿅࿆࿇࿈࿉࿊࿋࿌࿏")))

(quail-define-package "tibetan-wylie" "Tibetan" "TIBw" t
"Tibetan character input by Extended Wylie key assignment.

    +-------------------------------------+
    |ཀ་ k |ཁ་ kh |ག་ g  |གྷ་ gh |ང་ ng|   ི i          །        /
    |ཅ་ c |ཆ་ ch |ཇ་ j  |       |ཉ་ ny|   ུ u          ༎       //
    |ཊ་ T |ཋ་ TH |ཌ་ D  |ཌྷ་ DH |ཎ་ N |   ེ e          ༎ ༎    ////
    |ཏ་ t |ཐ་ th |ད་ d  |དྷ་ dh |ན་ n |   ོ o          ༑       ;
    |པ་ p |ཕ་ ph |བ་ b  |བྷ་ bh |མ་ m |   ཻ ai (ee, E) ༏        $
    |ཙ་ ts|ཚ་ tsh|ཛ་ dz |ཛྷ་ dzh|ཝ་ w |   ཽ au (oo, O) ༐        &
    |ཞ་ zh|ཟ་ z  |འ་ '  |       |ཡ་ y |   ྀ I          ༄༅   *
    |ར་ r |ལ་ l  |ཤ་ sh |ཥ་ SH |ས་ s |   ཿ :         ༄༅༅  #
    |ཧ་ h |ཨ་ A  |ཀྵ་ kSH|       |      |   ཾ M           ༼ ༽   < >
    +-------------------------------------+   ༔  %
    (The consonant ཨ་ must be typed explicitly.)

  NOT SPECIFIED IN EXT. WYLIE:
    +--------------------------------------------------------+
    |ྂ = ~ |ྃ = ` |྄ = , |྅ = @ |༷ = _o|༵ = _O|༆ = ^|
    +--------------------------------------------------------+
    |ྈ = x |ྉ = X |྆ = v |྇ = V |ྊ = q |ྋ = Q |
    +-----------------------------------------------+

  SPECIAL KEYS
  +     :  Consonant Stacking
          (Consonant stacking for ordinary Tibetan is done automatically)
  -     : No Consonant Stacking
          (To suppress automatic stacking for \"g-y\",
            and to get da-drag in  -r-d, -l-d .)
  |     : Special signs.

  Tsheg is assigned to SPC.  Space is assigned to period '.'.
"
 nil nil nil nil nil nil nil nil
 'quail-tibetan-update-translation)

;; Here we build up a Quail map for a Tibetan sequence the whole of
;; which can be one composition.
;;
;; A Tibetan syllable is typically structured as follows:
;;      [P] C [c+] V [M] [S [s]]
;;          ^^^^^^^^^^^^
;; where P:prefix, C:base consonant, c:subjoined consonant,
;; V:vowel, M:vowel modifier, S:suffix, s:post suffix.
;; In this pattern, the part indicated by "^^^" can be one composition.

;;; modified by Tomabechi 1999/12/10
;;; modified by Tomabechi 2000/06/08
;;;             Allows infinite addition of vowels/modifiers
;;;             as specified in Unicode v.3
(quail-install-map
 (quail-map-from-table
  '((base-state (tibetan-consonant-transcription-alist . svm-state)
		(tibetan-precomposed-transcription-alist . svm-state)
		(tibetan-wylie-non-stacking-alist . svm-state)
		tibetan-subjoined-transcription-alist
		tibetan-vowel-transcription-alist
		tibetan-modifier-transcription-alist
		tibetan-wylie-punctuation-alist)
    (svm-state ;;(tibetan-wylie-quote-alist . vm-state)
		(tibetan-vowel-transcription-alist . vm-state)
		(tibetan-subjoined-transcription-alist . svm-state)
		(tibetan-modifier-transcription-alist . m-state))
    (vm-state (tibetan-vowel-transcription-alist . vm-state)
	      (tibetan-modifier-transcription-alist . m-state))
    (m-state (tibetan-modifier-transcription-alist . m-state)))))

;;;
;;; TibKey key alignment based input method
;;;

(defconst tibetan-tibkey-to-transcription-alist
  '(;; consonant
    ("`" . "`")				; sna ldan
    ("~" . "~")				; sna ldan + nada
    ("q" . "k")				; ka
    ("Q" ."kSH")			; kSHa
    ("w" . "kh")			; kha
    ("e" . "g")				; ga
    ("r" . "ng")			; nga
    ("t" . "c")				; ca
    ("T" . "I")				; gi gu log
    ("y" . "ch")			; cha
    ("u" . "j")				; ja
    ("i" . "ny")			; nya
    ("o" . "t")				; ta
    ("O" . "T")				; Ta
    ("p" . "th")			; tha
    ("P" . "TH")			; THa
    ("[" . "d")				; da
    ("{" . "D")				; Da
    ("]" . "n")				; na
    ("}" . "N")				; Na
    ("a" . "p")				; pa
    ("A" . "a")				; Vowel a (not used in original TibKey)
    ("s" . "ph")			; pha
    ("d" . "b")				; ba
    ("f" . "m")				; ma
    ("F" . "M")				; anusvara
    ("g" . "u")				; zhabs kyu
    ("G" . "i")				; gi gu
    ("H" . ",")				; virama
    ("j" . "o")				; naro
    ("J" . "e")				; 'greng bu
    ("k" . "ts")			; tsa
    ("l" . "tsh")			; tsha
    (";" . "dz")                        ; dza
    ("'" . "w")				; wa
    ("\"" . "+w")			; wa zur
    ("z" . "zh")			; zha
    ("x" . "z")				; za
    ("c" . "'")				; 'a
    ("C" . "+'")			; 'a chung
    ("v" . "y")				; ya
    ("V" . "+y")			; ya btags
    ("b" . "r")				; ra
    ("B" . "+r")			; ra btags
    ("n" . "l")				; la
    ("N" . "+l")			; la btags
    ("m" . "sh")			; sha
    ("M" . "SH")			; SHa
    ("," . "s")				; sa
    ("." . "h")				; ha
    ("/" . "A")				; Aa
    ;; subjoined
    ("hq" . "+k")			; ka
    ("hQ" ."+kSH")			; kSHa
    ("hw" . "+kh")			; kha
    ("he" . "+g")			; ga
    ("hr" . "+ng")			; nga
    ("ht" . "+c")			; ca
    ("hy" . "+ch")			; cha
    ("hu" . "+j")			; ja
    ("hi" . "+ny")			; nya
    ("ho" . "+t")			; ta
    ("hO" . "+T")			; Ta
    ("hp" . "+th")			; tha
    ("hP" . "+TH")			; THa
    ("h[" . "+d")			; da
    ("h{" . "+D")			; Da
    ("h]" . "+n")			; na
    ("h}" . "+N")			; Na
    ("ha" . "+p")			; pa
    ("hs" . "+ph")			; pha
    ("hd" . "+b")			; ba
    ("hf" . "+m")			; ma
    ("hk" . "+ts")			; tsa
    ("hl" . "+tsh")			; tsha
    ("h;" . "+dz")                      ; dza
    ("h'" . "+w")			; wa
    ("hz" . "+zh")			; zha
    ("hx" . "+z")			; za
    ("hc" . "+'")			; 'a
    ("hv" . "+y")			; ya
    ("hb" . "+r")			; ra
    ("hn" . "+l")			; la
    ("hm" . "+sh")			; sha
    ("hM" . "+SH")			; SHa
    ("h," . "+s")			; sa
    ("h." . "+h")			; ha
    ("h/" . "+A")			; Aa
    ;; Special rule for `ཡ' to avoid stacking.
    ("E" . "-y")
    ))

(defconst tibetan-consonant-tibkey-alist nil)
(defconst tibetan-subjoined-tibkey-alist nil)
(defconst tibetan-vowel-tibkey-alist nil)
(defconst tibetan-modifier-tibkey-alist nil)
(defconst tibetan-non-stacking-tibkey-alist nil)

(let ((type-list '("consonant" "subjoined" "vowel" "modifier" "non-stacking"))
      (tail tibetan-tibkey-to-transcription-alist)
      elt)
  (while tail
    (setq elt (car tail) tail (cdr tail))
    (let ((types type-list)
	  type transcription trans-alist tibkey-alist)
      (while types
	(setq type (car types) types (cdr types))
	(setq trans-alist
	      (if (string= type "non-stacking")
		  'tibetan-wylie-non-stacking-alist
		(intern (format "tibetan-%s-transcription-alist" type)))
	      transcription
	      (cdr (assoc (cdr elt) (symbol-value trans-alist))))
	(when transcription
	  (setq tibkey-alist (intern (format "tibetan-%s-tibkey-alist" type)))
	  (set tibkey-alist
	       (cons (cons (car elt) transcription)
		     (symbol-value tibkey-alist)))))
      (or tibkey-alist
	  (error "No Tibetan transcription for %s" (cdr elt))))))

(defconst tibetan-punctuation-tibkey-alist
  '(("1" . "༡")
    ("!" . "༄")		; nyi zla long
    ("2" . "༢")
    ("@" . "༅")			; nyi zla simple
    ("3" . "༣")
;;; ("#" )
    ("4" . "༤")
;;; ("$" )
    ("5" . "༥")
    ("%" . "༔")
    ("6" . "༦")
    ("^" . "༁")
    ("7" . "༧")
    ("8" . "༨")
;;; ("*" ) ; avagraha, not supported yet
    ("9" . "༩")
    ("(" . "༼")
    ("0" . "༠")
    (")" . "༽")
;;; ("-" ) ; emphatic, not yet supported
;;; ("_" ) ; id.
;;; ("=" ) ; special sign, not yet supported
    ("+" . "༑")
    ("\\" . "༏")
    ("|" . "༈")
    ("I" . "྅")				; avagraha
    (":" . "ཿ")
;;; (">" ?་) ; to be assigned to SPC
    (">" . " ")
    ("?" . "།")
    ("??" . "༎")
    ("????" . ["༎ ༎"])
    (" " . "་")
    ))

;; Convert TibKey string to Tibetan-Roman transcription string.
;; If there's no proper conversion, return nil.
(defun quail-tibkey-to-transcription (tibkey)
  (let ((len (length tibkey))
	(i 0)
	(trans-list nil))
    (while (< i len)
      (let ((last len)
	    trans)
	(while (and (not trans) (> last i))
	  (or (setq trans (cdr (assoc (substring tibkey i last)
				      tibetan-tibkey-to-transcription-alist)))
	      (setq last (1- last))))
	(if trans
	    (setq trans-list (cons trans trans-list)
		  i last)
	  (setq trans-list nil i len))))
    (apply 'concat (nreverse trans-list))))

(defvar quail-tibkey-characters nil)

(defun quail-tibkey-update-translation (control-flag)
  (if (integerp control-flag)
      ;; Non-composable-character typed.
      (setq quail-current-str
	    (buffer-substring (overlay-start quail-overlay)
			      (overlay-end quail-overlay))
	    unread-command-events
	    (string-to-list
	     (substring quail-current-key control-flag)))
    (let ((transcription (quail-tibkey-to-transcription quail-current-key)))
      (if (> (length transcription) 0)
	  (let ((quail-current-key transcription))
	    (setq control-flag
		  (quail-tibetan-update-translation control-flag)))
	(or quail-current-str
	    (setq quail-current-str quail-current-key)))))
  control-flag)

(quail-define-package "tibetan-tibkey" "Tibetan" "TIBt" t
"Tibetan character input by TibKey key assignment.

\(This implementation is still incomplete.
 Therefore, the following key assignment is a provisional one.)

  [NOT SHIFTED]

  +-------------------------------------------------------+
  |`ྃ|1༡|2༢|3༣|4༤|5༥|6༦|7༧|8༨|9༩|0༠|-  |=  |\\༈|
  +-------------------------------------------------------+
     |qཀ|wཁ|eག|rང|tཅ|yཆ|uཇ|iཉ|oཏ|pཐ|[ད|]ན|
     +-----------------------------------------------+
      |aཔ| sཕ| dབ|fམ|gུ|h  |jོ|kཙ|lཚ|;ཛ|'ཝ|
      +---------------------------------------------+
         |zཞ|xཟ|cའ|vཡ|bར|nལ|mཤ|,ས|.ཧ|/ཨ|
         +---------------------------------------+
  The key 'h' is used for consonant stacking.

  [SHIFTED]

  +----------------------------------------------------------+
  |~ྂ|!༄|@༅|#  |$  |%༔ |^༁|&  |*  |(༼|)༽|_  |+༑| |༈|
  +----------------------------------------------------------+
     |Qཀྵ|W  |E  |R  |Tྀ|Y  |U  |I྅|Oཊ|Pཋ|{ཌ|}ཎ|
     +-----------------------------------------------+
      |A  |S  |D  |Fཾ|Gི|H྄|Jེ|K  |L  |:ཿ|\"ྭ|
      +-------------------------------------------+
         |Z  |X  |Cཱ|Vྱ|Bྲ|Nླ|Mཥ|<  |>  |?། |
         +---------------------------------------+

  DIFFERENCE FROM THE ORIGINAL TIBKEY:

    1. Vowel 'a' should be typed explicitly by the key 'A'.
       This is really inconvenient.  But to make the coding
       scheme clear, it is desirable to have an explicit
       vowel sign for 'a'.
    2. Tsheg is assigned to SPC key.  You can input a space
       by typing '>'.
    4. To avoid the default stacking ���� and to obtain གཡ,
       type 'E' instead of 'v' (=ཡ).
    3. There are many characters that are not supported in the
       current implementation (especially special signs).
       I hope I'll complete in a future revision.
"
 nil nil nil nil nil nil nil nil
 'quail-tibkey-update-translation)

(quail-install-map
 (quail-map-from-table
  '((base-state (tibetan-consonant-tibkey-alist . s-state)
		(tibetan-non-stacking-tibkey-alist . s-state)
		tibetan-subjoined-tibkey-alist
		tibetan-vowel-tibkey-alist
		tibetan-modifier-tibkey-alist
		tibetan-punctuation-tibkey-alist)
    (s-state (tibetan-subjoined-tibkey-alist . s-state)
	     (tibetan-vowel-tibkey-alist . m-state))
    (m-state tibetan-modifier-tibkey-alist))))

;;; tibetan.el ends here
