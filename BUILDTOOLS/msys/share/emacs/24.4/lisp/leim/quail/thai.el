;;; thai.el --- Quail package for inputting Thai characters -*-coding: utf-8;-*-

;; Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Keywords: multilingual, input method, Thai

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

(defmacro thai-generate-quail-map (translation-table)
  (let (map)
     (dotimes (i (length translation-table))
       (let ((trans (aref translation-table i)))
	 (when (not (eq trans 0))
	   (if (> (length trans) 1)
	       (setq trans (vector trans))
	     (setq trans (aref trans 0)))
	   (setq map (cons (list (char-to-string i) trans) map)))))
     `(quail-define-rules ,@map)))

;; Thai Kesmanee keyboard support.

(quail-define-package
 "thai-kesmanee" "Thai" "กก>" t
 "Thai Kesmanee input method with TIS620 keyboard layout

The difference from the ordinal Thai keyboard:
    '฿' and '๏' are assigned to '\\' and '|' respectively,
    'ฃ' and 'ฅ' are assigned to '`' and '~' respectively,
    Don't know where to assign characters '๚' and '๛'."
 nil t t t t nil nil nil nil nil t)

(thai-generate-quail-map
 [
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	; control codes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	; control codes
;; This data is quite old.
;;   0   "#" "." "๒" "๓" "๔" "ั้" "ง"	; SPC .. '
;;   "๖" "๗" "๕" "๙" "ม" "ข" "ใ" "ฝ"	; ( .. /
;;   "จ" "ล" "/" "_" "ภ" "ถ" "ุ" "ึ"	; 0 .. 7
;;   "ค" "ต" "ซ" "ว" "ฒ" "ช" "ฬ" "ฦ"	; 8 .. ?
;;   "๑" "ฤ" "ฺ" "ฉ" "ฏ" "ฎ" "โ" "ฌ"	; @ .. G
;;   "็" "ณ" "๋" "ษ" "ศ" "๎" "์" "ฯ"	; H .. O
;;   "ญ" "๐" "ฑ" "ฆ" "ธ" "๊" "ฮ" "\""	; P .. W
;;   ")" "ํ" "(" "บ" "฿" "ล" "ู" "๘"	; X .. _
;;   "ฃ" "ฟ" "ิ" "แ" "ก" "ำ" "ด" "เ"	; ` .. g
;;   "้" "ร" "่" "า" "ส" "ท" "ื" "น"	; h .. o
;;   "ย" "ๆ" "พ" "ห" "ะ" "ี" "อ" "ไ"	; p .. w
;;   "ป" "ั" "ผ" "ฐ" "๏" "," "ฅ" 0	; x .. DEL
;; This is the correct data nowadays.
  0  "+" "." "๒" "๓" "๔" "฿" "ง"	; SPC .. '
  "๖" "๗" "๕" "๙" "ม" "ข" "ใ" "ฝ"	; ( .. /
  "จ" "ๅ" "/" "-" "ภ" "ถ" "ุ" "ึ"	; 0 .. 7
  "ค" "ต" "ซ" "ว" "ฒ" "ช" "ฬ" "ฦ"	; 8 .. ?
  "๑" "ฤ" "ฺ" "ฉ" "ฏ" "ฎ" "โ" "ฌ"	; @ .. G
  "็" "ณ" "๋" "ษ" "ศ" "?" "์" "ฯ"	; H .. O
  "ญ" "๐" "ฑ" "ฆ" "ธ" "๊" "ฮ" "\""	; P .. W
  "\)" "ํ" "\(" "บ" "ฃ" "ล" "ู" "๘"	; X .. _
  "_" "ฟ" "ิ" "แ" "ก" "ำ" "ด" "เ"	; ` .. g
  "้" "ร" "่" "า" "ส" "ท" "ื" "น"	; h .. o
  "ย" "ๆ" "พ" "ห" "ะ" "ี" "อ" "ไ"	; p .. w
  "ป" "ั" "ผ" "ฐ" "ฅ" "," "%" 0	; x .. DEL
  ])


;; Thai Pattachote keyboard support.

(quail-define-package
 "thai-pattachote" "Thai" "กป>" t
 "Thai Pattachote input method with TIS620 keyboard layout"
 nil t t t t nil nil nil nil nil t)

(thai-generate-quail-map
 [
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	; control codes
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	; control codes
  0 "+" "ฑ" "/" "," "?" "_" "ข"		; SPC .. '
  "(" ")" "." "%" "ะ" "๑" "จ" "พ"	; ( .. /
  "๐" "=" "๒" "๓" "๔" "๕" "ู" "๗"	; 0 .. 7
  "๘" "๙" "ฆ" "ไ" "ฟ" "๖" "ฒ" "ฬ"	; 8 .. ?
  "\"" "๋" "ั" "ฐ" "ำ" "ๆ" "ณ" "์"	; @ .. G
  "ื" "ซ" "ผ" "ช" "โ" "ฮ" "ศ" "ถ"	; H .. O
  "ฒ" "๊" "ญ" "ธ" "ษ" "ฝ" "ภ" "ฤ"	; P .. W
  "ฎ" "ึ" "ฎ" "ใ" "ฺ" "ฒ" "ุ" "-"	; X .. _
  "ฃ" "้" "ิ" "ล" "ง" "ย" "ก" "ั"	; ` .. g
  "ี" "ม" "า" "น" "เ" "ส" "ค" "ว"	; h .. o
  "แ" "็" "อ" "ท" "ร" "ด" "ห" "ต"	; p .. w
  "ป" "่" "บ" "ฯ" "ํ" "ฦ" "ฅ" 0		; x .. DEL
  ])

;;; thai.el ends here
