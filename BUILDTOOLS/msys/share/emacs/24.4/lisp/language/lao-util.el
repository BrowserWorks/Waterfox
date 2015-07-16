;;; lao-util.el --- utilities for Lao -*- coding: utf-8; -*-

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.
;; Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
;;   2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021
;; Copyright (C) 2003
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H13PRO009

;; Keywords: multilingual, Lao, i18n

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

;; Setting information of Thai characters.

(defconst lao-category-table (make-category-table))
(define-category ?c "Lao consonant" lao-category-table)
(define-category ?s "Lao semi-vowel" lao-category-table)
(define-category ?v "Lao upper/lower vowel" lao-category-table)
(define-category ?t "Lao tone" lao-category-table)

(let ((l '((?ກ consonant "LETTER KOR  KAI'" "CHICKEN")
	   (?ຂ consonant "LETTER KHOR KHAI'" "EGG")
	   (?຃ invalid nil)
	   (?ຄ consonant "LETTER QHOR QHWARGN" "BUFFALO")
	   (?຅ invalid nil)
	   (?  invalid nil)
	   (?ງ consonant "LETTER NGOR NGUU" "SNAKE")
	   (?ຈ consonant "LETTER JOR JUA" "BUDDHIST NOVICE")
	   (?ຉ invalid nil)
	   (?ຊ consonant "LETTER XOR X\"ARNG" "ELEPHANT")
	   (?຋ invalid nil)
	   (?ຌ invalid nil)
	   (?ຍ consonant "LETTER YOR YUNG" "MOSQUITO")
	   (?ຎ invalid nil)
	   (?ຎ invalid nil)
	   (?ຎ invalid nil)
	   (?ຎ invalid nil)
	   (?ຎ invalid nil)
	   (?ຎ invalid nil)
	   (?ດ consonant "LETTER DOR DANG" "NOSE")
	   (?ຕ consonant "LETTER TOR TAR" "EYE")
	   (?ຖ consonant "LETTER THOR THUNG" "TO ASK,QUESTION")
	   (?ທ consonant "LETTER DHOR DHARM" "FLAG")
	   (?ຘ invalid nil)
	   (?ນ consonant "LETTER NOR NOK" "BIRD")
	   (?ບ consonant "LETTER BOR BED" "FISHHOOK")
	   (?ປ consonant "LETTER POR PAR" "FISH")
	   (?ຜ consonant "LETTER HPOR HPER\"" "BEE")
	   (?ຝ consonant "LETTER FHOR FHAR" "WALL")
	   (?ພ consonant "LETTER PHOR PHUU" "MOUNTAIN")
	   (?ຟ consonant "LETTER FOR FAI" "FIRE")
	   (?ຠ invalid nil)
	   (?ມ consonant "LETTER MOR MAR\"" "HORSE")
	   (?ຢ consonant "LETTER GNOR GNAR" "MEDICINE")
	   (?ຣ consonant "LETTER ROR ROD" "CAR")
	   (?຤ invalid nil)
	   (?ລ consonant "LETTER LOR LIING" "MONKEY")
	   (?຦ invalid nil)
	   (?ວ consonant "LETTER WOR WII" "HAND FAN")
	   (?ຨ invalid nil)
	   (?ຩ invalid nil)
	   (?ສ consonant "LETTER SOR SEA" "TIGER")
	   (?ຫ consonant "LETTER HHOR HHAI" "JAR")
	   (?ຬ invalid nil)
	   (?ອ consonant "LETTER OR OOW" "TAKE")
	   (?ຮ consonant "LETTER HOR HEA" "BOAT")
	   (?ຯ special "ELLIPSIS")
	   (?ະ vowel-base "VOWEL SIGN SARA A")
	   (?ັ vowel-upper "VOWEL SIGN MAI KAN")
	   (?າ vowel-base "VOWEL SIGN SARA AR")
	   (?ຳ vowel-base "VOWEL SIGN SARA AM")
	   (?ິ vowel-upper "VOWEL SIGN SARA I")
	   (?ີ vowel-upper "VOWEL SIGN SARA II")
	   (?ຶ vowel-upper "VOWEL SIGN SARA EU")
	   (?ື vowel-upper "VOWEL SIGN SARA UR")
	   (?ຸ vowel-lower "VOWEL SIGN SARA U")
	   (?ູ vowel-lower "VOWEL SIGN SARA UU")
	   (?຺ invalid nil)
	   (?ົ vowel-upper "VOWEL SIGN MAI KONG")
	   (?ຼ semivowel-lower "SEMIVOWEL SIGN LO")
	   (?ຽ vowel-base "SEMIVOWEL SIGN SARA IA")
	   (?຾ invalid nil)
	   (?຿ invalid nil)
	   (?ເ vowel-base "VOWEL SIGN SARA EE")
	   (?ແ vowel-base "VOWEL SIGN SARA AA")
	   (?ໂ vowel-base "VOWEL SIGN SARA OO")
	   (?ໃ vowel-base "VOWEL SIGN SARA EI MAI MUAN\"")
	   (?ໄ vowel-base "VOWEL SIGN SARA AI MAI MAY")
	   (?໅ invalid nil)
	   (?ໆ special "KO LA (REPETITION)")
	   (?໇ invalid nil)
	   (?່ tone "TONE MAI EK")
	   (?້ tone "TONE MAI THO")
	   (?໊ tone "TONE MAI TI")
	   (?໋ tone "TONE MAI JADTAWAR")
	   (?໌ tone "CANCELLATION MARK")
	   (?ໍ vowel-upper "VOWEL SIGN SARA OR")
	   (?໎ invalid nil)
	   (?໏ invalid nil)
	   (?໐ special "DIGIT ZERO")
	   (?໑ special "DIGIT ONE")
	   (?໒ special "DIGIT TWO")
	   (?໓ special "DIGIT THREE")
	   (?໔ special "DIGIT FOUR")
	   (?໕ special "DIGIT FIVE")
	   (?໖ special "DIGIT SIX")
	   (?໗ special "DIGIT SEVEN")
	   (?໘ special "DIGIT EIGHT")
	   (?໙ special "DIGIT NINE")
	   (?໚ invalid nil)
	   (?໛ invalid nil)
	   (?ໜ consonant "LETTER NHOR NHUU" "MOUSE")
	   (?ໝ consonant "LETTER MHOR MHAR" "DOG")
	   (?ໞ invalid nil)))
      elm)
  (while l
    (setq elm (car l) l (cdr l))
    (let ((char (car elm))
	  (ptype (nth 1 elm)))
      (cond ((eq ptype 'consonant)
	     (modify-category-entry char ?c lao-category-table))
	    ((memq ptype '(vowel-upper vowel-lower))
	     (modify-category-entry char ?v lao-category-table))
	    ((eq ptype 'semivowel-lower)
	     (modify-category-entry char ?s lao-category-table))
	    ((eq ptype 'tone)
	     (modify-category-entry char ?t lao-category-table)))
      (put-char-code-property char 'phonetic-type ptype)
      (put-char-code-property char 'name (nth 2 elm))
      (put-char-code-property char 'meaning (nth 3 elm)))))

;; The general composing rules are as follows:
;;
;;                          T
;;       V        T         V                  T
;; CV -> C, CT -> C, CVT -> C, Cv -> C, CvT -> C
;;                                   v         v
;;                             T
;;        V         T          V                    T
;; CsV -> C, CsT -> C, CsVT -> C, Csv -> C, CsvT -> C
;;        s         s          s         s          s
;;                                       v          v


;; where C: consonant, V: vowel upper, v: vowel lower,
;;       T: tone mark, s: semivowel lower

(defvar lao-composition-pattern
  "\\cc\\(\\ct\\|\\cv\\ct?\\|\\cs\\(\\ct\\|\\cv\\ct?\\)?\\)"
  "Regular expression matching a Lao composite sequence.")

;;;###autoload
(defun lao-compose-string (str)
  (with-category-table lao-category-table
   (let ((idx 0))
     (while (setq idx (string-match lao-composition-pattern str idx))
       (compose-string str idx (match-end 0))
       (setq idx (match-end 0))))
   str))

;;; LRT: Lao <-> Roman Transcription

;; Upper vowels and tone-marks are put on the letter.
;; Semi-vowel-sign-lo and lower vowels are put under the letter.

(defconst lao-transcription-consonant-alist
  (sort '(;; single consonants
	  ("k" . "ກ")
	  ("kh" . "ຂ")
	  ("qh" . "ຄ")
	  ("ng" . "ງ")
	  ("j" . "ຈ")
	  ("s" . "ສ")
	  ("x" . "ຊ")
	  ("y" . "ຍ")
	  ("d" . "ດ")
	  ("t" . "ຕ")
	  ("th" . "ຖ")
	  ("dh" . "ທ")
	  ("n" . "ນ")
	  ("b" . "ບ")
	  ("p" . "ປ")
	  ("hp" . "ຜ")
	  ("fh" . "ຝ")
	  ("ph" . "ພ")
	  ("f" . "ຟ")
	  ("m" . "ມ")
	  ("gn" . "ຢ")
	  ("l" . "ລ")
	  ("r" . "ຣ")
	  ("v" . "ວ")
	  ("w" . "ວ")
	  ("hh" . "ຫ")
	  ("O" . "ອ")
	  ("h" . "ຮ")
	  ("nh" . "ໜ")
	  ("mh" . "ໝ")
	  ("lh" . ["ຫຼ"])
	  ;; double consonants
	  ("ngh" . ["ຫງ"])
	  ("yh" . ["ຫຽ"])
	  ("wh" . ["ຫວ"])
	  ("hl" . ["ຫລ"])
	  ("hy" . ["ຫຍ"])
	  ("hn" . ["ຫນ"])
	  ("hm" . ["ຫມ"])
	  )
	(function (lambda (x y) (> (length (car x)) (length (car y)))))))

(defconst lao-transcription-semi-vowel-alist
  '(("r" . "ຼ")))

(defconst lao-transcription-vowel-alist
  (sort '(("a" . "ະ")
	  ("ar" . "າ")
	  ("i" . "ິ")
	  ("ii" . "ີ")
	  ("eu" . "ຶ")
	  ("ur" . "ື")
	  ("u" . "ຸ")
	  ("uu" . "ູ")
	  ("e" . ["ເະ"])
	  ("ee" . "ເ")
	  ("ae" . ["ແະ"])
	  ("aa" . "ແ")
	  ("o" . ["ໂະ"])
	  ("oo" . "ໂ")
	  ("oe" . ["ເາະ"])
	  ("or" . "ໍ")
	  ("er" . ["ເິ"])
	  ("ir" . ["ເີ"])
	  ("ua" . ["ົວະ"])
	  ("uaa" . ["ົວ"])
	  ("ie" . ["ເັຽະ"])
	  ("ia" . ["ເັຽ"])
	  ("ea" . ["ເຶອ"])
	  ("eaa" . ["ເືອ"])
	  ("ai" . "ໄ")
	  ("ei" . "ໃ")
	  ("ao" . ["ເົາ"])
	  ("aM" . "ຳ"))
	(function (lambda (x y) (> (length (car x)) (length (car y)))))))

;; Maa-sakod is put at the tail.
(defconst lao-transcription-maa-sakod-alist
  '(("k" . "ກ")
    ("g" . "ງ")
    ("y" . "ຍ")
    ("d" . "ດ")
    ("n" . "ນ")
    ("b" . "ບ")
    ("m" . "ມ")
    ("v" . "ວ")
    ("w" . "ວ")
    ))

(defconst lao-transcription-tone-alist
  '(("'" . "່")
    ("\"" . "້")
    ("^" . "໊")
    ("+" . "໋")
    ("~" . "໌")))

(defconst lao-transcription-punctuation-alist
  '(("\\0" . "໐")
    ("\\1" . "໑")
    ("\\2" . "໒")
    ("\\3" . "໓")
    ("\\4" . "໔")
    ("\\5" . "໕")
    ("\\6" . "໖")
    ("\\7" . "໗")
    ("\\8" . "໘")
    ("\\9" . "໙")
    ("\\\\" . "ໆ")
    ("\\$" . "ຯ")))

(defconst lao-transcription-pattern
  (concat
   "\\("
   (mapconcat 'car lao-transcription-consonant-alist "\\|")
   "\\)\\("
   (mapconcat 'car lao-transcription-semi-vowel-alist "\\|")
   "\\)?\\(\\("
   (mapconcat 'car lao-transcription-vowel-alist "\\|")
   "\\)\\("
   (mapconcat 'car lao-transcription-maa-sakod-alist "\\|")
   "\\)?\\("
   (mapconcat (lambda (x) (regexp-quote (car x)))
	      lao-transcription-tone-alist "\\|")
   "\\)?\\)?\\|"
   (mapconcat (lambda (x) (regexp-quote (car x)))
	      lao-transcription-punctuation-alist "\\|")
   )
  "Regexp of Roman transcription pattern for one Lao syllable.")

(defconst lao-transcription-pattern
  (concat
   "\\("
   (regexp-opt (mapcar 'car lao-transcription-consonant-alist))
   "\\)\\("
   (regexp-opt (mapcar 'car lao-transcription-semi-vowel-alist))
   "\\)?\\(\\("
   (regexp-opt (mapcar 'car lao-transcription-vowel-alist))
   "\\)\\("
   (regexp-opt (mapcar 'car lao-transcription-maa-sakod-alist))
   "\\)?\\("
   (regexp-opt (mapcar 'car lao-transcription-tone-alist))
   "\\)?\\)?\\|"
   (regexp-opt (mapcar 'car lao-transcription-punctuation-alist))
   )
  "Regexp of Roman transcription pattern for one Lao syllable.")

(defconst lao-vowel-reordering-rule
  '(("ະ" (0 ?ະ) (0 ?ັ))
    ("າ" (0 ?າ))
    ("ິ" (0 ?ີ))
    ("ີ" (0 ?ີ))
    ("ຶ" (0 ?ຶ))
    ("ື" (0 ?ື))
    ("ຸ" (0 ?ຸ))
    ("ູ" (0 ?ູ))
    ("ເະ" (?ເ 0 ?ະ) (?ເ 0 ?ັ))
    ("ເ" (?ເ 0))
    ("ແະ" (?ແ 0 ?ະ) (?ແ 0 ?ັ))
    ("ແ" (?ແ 0))
    ("ໂະ" (?ໂ 0 ?ະ) (0 ?ົ) (?ຍ ?ໂ 0 ?ັ) (?ວ ?ໂ 0 ?ັ))
    ("ໂ" (?ໂ 0))
    ("ເາະ" (?ເ 0 ?າ ?ະ) (0 ?ັ ?ອ))
    ("ໍ" (0 ?ໍ) (0 ?ອ))
    ("ເິ" (?ເ 0 ?ິ))
    ("ເີ" (?ເ 0 ?ີ))
    ("ົວະ" (0 ?ົ ?ວ ?ະ) (0 ?ັ ?ວ))
    ("ົວ" (0 ?ົ ?ວ) (0 ?ວ))
    ("ເັຽະ" (?ເ 0 ?ັ ?ຽ ?ະ) (0 ?ັ ?ຽ))
    ("ເັຽ" (?ເ 0 ?ັ ?ຽ) (0 ?ຽ))
    ("ເຶອ" (?ເ 0 ?ຶ ?ອ))
    ("ເືອ" (?ເ 0 ?ື ?ອ))
    ("ໄ" (?ໄ 0))
    ("ໃ" (?ໃ 0))
    ("ເົາ" (?ເ 0 ?ົ ?າ))
    ("ຳ" (0 ?ຳ)))
  "Alist of Lao vowel string vs the corresponding re-ordering rule.
Each element has this form:
	(VOWEL NO-MAA-SAKOD-RULE WITH-MAA-SAKOD-RULE (MAA-SAKOD-0 RULE-0) ...)

VOWEL is a vowel string (e.g. \"ເັຽະ\").

NO-MAA-SAKOD-RULE is a rule to re-order and modify VOWEL following a
consonant.  It is a list vowel characters or 0.  The element 0
indicate the place to embed a consonant.

Optional WITH-MAA-SAKOD-RULE is a rule to re-order and modify VOWEL
following a consonant and preceding a maa-sakod character.  If it is
nil, NO-MAA-SAKOD-RULE is used.  The maa-sakod character is always
appended at the tail.

For instance, rule `(\"ເືອ\" (?ເ t ?ື ?ອ))' tells that this vowel
string following a consonant `ກ' should be re-ordered as \"ເກືອ\".

Optional (MAA-SAKOD-n RULE-n) are rules specially applied to maa-sakod
character MAA-SAKOD-n.")

;;;###autoload
(defun lao-transcribe-single-roman-syllable-to-lao (from to &optional str)
  "Transcribe a Romanized Lao syllable in the region FROM and TO to Lao string.
Only the first syllable is transcribed.
The value has the form: (START END LAO-STRING), where
START and END are the beginning and end positions of the Roman Lao syllable,
LAO-STRING is the Lao character transcription of it.

Optional 3rd arg STR, if non-nil, is a string to search for Roman Lao
syllable.  In that case, FROM and TO are indexes to STR."
  (if str
      (if (setq from (string-match lao-transcription-pattern str from))
	  (progn
	    (if (>= from to)
		(setq from nil)
	      (setq to (match-end 0)))))
    (save-excursion
      (goto-char from)
      (if (setq to (re-search-forward lao-transcription-pattern to t))
	  (setq from (match-beginning 0))
	(setq from nil))))
  (if from
      (let* ((consonant (match-string 1 str))
	     (semivowel (match-string 3 str))
	     (vowel (match-string 5 str))
	     (maa-sakod (match-string 8 str))
	     (tone (match-string 9 str))
	     lao-consonant lao-semivowel lao-vowel lao-maa-sakod lao-tone
	     clen cidx)
	(setq to (match-end 0))
	(if (not consonant)
	    (setq str (cdr (assoc (match-string 0 str)
				  lao-transcription-punctuation-alist)))
	  (setq lao-consonant
		(cdr (assoc consonant lao-transcription-consonant-alist)))
	  (if (vectorp lao-consonant)
	      (setq lao-consonant (aref lao-consonant 0)))
	  (setq clen (length lao-consonant))
	  (if semivowel
	      ;; Include semivowel in STR.
	      (setq lao-semivowel
		    (cdr (assoc semivowel lao-transcription-semi-vowel-alist))
		    str (if (= clen 1)
			    (concat lao-consonant lao-semivowel)
			  (concat (substring lao-consonant 0 1) lao-semivowel
				  (substring lao-consonant 1))))
	    (setq str lao-consonant))
	  (if vowel
	      (let (rule)
		(setq lao-vowel
		      (cdr (assoc vowel lao-transcription-vowel-alist)))
		(if (vectorp lao-vowel)
		    (setq lao-vowel (aref lao-vowel 0)))
		(setq rule (assoc lao-vowel lao-vowel-reordering-rule))
		(if (null maa-sakod)
		    (setq rule (nth 1 rule))
		  (setq lao-maa-sakod
			(cdr (assoc maa-sakod lao-transcription-maa-sakod-alist))
			rule
			(or (cdr (assq (aref lao-maa-sakod 0) (nthcdr 2 rule)))
			    (nth 2 rule)
			    (nth 1 rule))))
		(or rule
		    (error "Lao vowel %S has no re-ordering rule" lao-vowel))
		(setq lao-consonant str str "")
		(while rule
		  (if (= (car rule) 0)
		      (setq str (concat str lao-consonant)
			    cidx (length str))
		    (setq str (concat str (list (car rule)))))
		  (setq rule (cdr rule)))
		(or cidx
		    (error "Lao vowel %S has malformed re-ordering rule" vowel))
		;; Set CIDX to after upper or lower vowel if any.
		(let ((len (length str)))
		  (while (and (< cidx len)
			      (memq (get-char-code-property (aref str cidx)
							    'phonetic-type)
				    '(vowel-lower vowel-upper)))
		    (setq cidx (1+ cidx))))
		(if lao-maa-sakod
		    (setq str (concat str lao-maa-sakod)))
		(if tone
		    (setq lao-tone
			  (cdr (assoc tone lao-transcription-tone-alist))
			  str (concat (substring str 0 cidx) lao-tone
				      (substring str cidx)))))))
	(list from to (lao-compose-string str)))))

;;;###autoload
(defun lao-transcribe-roman-to-lao-string (str)
  "Transcribe Romanized Lao string STR to Lao character string."
  (let ((from 0)
	(to (length str))
	(lao-str "")
	val)
    (while (setq val (lao-transcribe-single-roman-syllable-to-lao from to str))
      (let ((start (car val))
	    (end (nth 1 val))
	    (lao (nth 2 val)))
	(if (> start from)
	    (setq lao-str (concat lao-str (substring str from start) lao))
	  (setq lao-str (concat lao-str lao)))
	(setq from end)))
    (if (< from to)
	(concat lao-str (substring str from to))
      lao-str)))

;;;###autoload
(defun lao-composition-function (gstring)
  (if (= (lgstring-char-len gstring) 1)
      (compose-gstring-for-graphic gstring)
    (or (font-shape-gstring gstring)
	(let ((glyph-len (lgstring-glyph-len gstring))
	      (i 0)
	      glyph)
	  (while (and (< i glyph-len)
		      (setq glyph (lgstring-glyph gstring i)))
	    (setq i (1+ i)))
	  (compose-glyph-string-relative gstring 0 i 0.1)))))

;;;###autoload
(defun lao-compose-region (from to)
  (interactive "r")
  (save-restriction
    (narrow-to-region from to)
    (goto-char (point-min))
    (with-category-table lao-category-table
      (while (re-search-forward lao-composition-pattern nil t)
	(compose-region (match-beginning 0) (point))))))

;;
(provide 'lao-util)

;;; lao-util.el ends here
