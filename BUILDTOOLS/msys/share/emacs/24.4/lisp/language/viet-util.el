;;; viet-util.el --- utilities for Vietnamese  -*- coding: utf-8; -*-

;; Copyright (C) 1998, 2001-2014 Free Software Foundation, Inc.
;; Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021
;; Copyright (C) 2003
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H13PRO009

;; Keywords: mule, multilingual, Vietnamese

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

;; Vietnamese uses ASCII characters and additional 134 unique
;; characters (these are Latin alphabets with various diacritical and
;; tone marks).  As far as I know, Vietnamese now has 5 different ways
;; for representing these characters: VISCII, TCVN-5712, VPS, VIQR,
;; and Unicode.  VISCII, TCVN-5712 and VPS are simple 1-byte code
;; which assigns 134 unique characters in control-code area
;; (0x00..0x1F) and right half area (0x80..0xFF).  VIQR is a mnemonic
;; encoding specification representing diacritical marks by following
;; ASCII characters.

;;; Code:

(defvar viet-viscii-nonascii-translation-table)

;;;###autoload
(defun viet-encode-viscii-char (char)
  "Return VISCII character code of CHAR if appropriate."
  (encode-char char 'viscii))

;; VIQR is a mnemonic encoding specification for Vietnamese.
;; It represents diacritical marks by ASCII characters as follows:
;; ------------+----------+--------
;;     mark    | mnemonic | example
;; ------------+----------+---------
;;    breve    |    (     | a( -> ă
;;  circumflex |    ^     | a^ -> â
;;    horn     |    +     | o+ -> ơ
;; ------------+----------+---------
;;    acute    |    '     | a' -> á
;;    grave    |    `     | a` -> à
;;  hook above |    ?     | a? -> ả
;;    tilde    |    ~     | a~ -> ã
;;   dot below |    .     | a. -> ạ
;; ------------+----------+---------
;;    d bar    |   dd     | dd -> đ
;; ------------+----------+---------

(defvar viet-viqr-alist
  '(;; lowercase
    (?ắ . "a('")			; 161
    (?ằ . "a(`")			; 162
    (?ặ . "a(.")			; 163
    (?ấ . "a^'")			; 164
    (?ầ . "a^`")			; 165
    (?ẩ . "a^?")			; 166
    (?ậ . "a^.")			; 167
    (?ẽ . "e~")				; 168
    (?ẹ . "e.")				; 169
    (?ế . "e^'")			; 170
    (?ề . "e^`")			; 171
    (?ể . "e^?")			; 172
    (?ễ . "e^~")			; 173
    (?ệ . "e^.")			; 174
    (?ố . "o^'")			; 175
    (?ồ . "o^`")			; 176
    (?ổ . "o^?")			; 177
    (?ỗ . "o^~")			; 178
    (?ộ . "o^.")			; 181
    (?ờ . "o+`")			; 182
    (?ở . "o+?")			; 183
    (?ị . "i.")				; 184
    (?ơ . "o+")				; 189
    (?ớ . "o+'")			; 190
    (?ẳ . "a(?")			; 198
    (?ẵ . "a(~")			; 199
    (?ỳ . "y`")				; 207
    (?ứ . "u+'")			; 209
    (?ạ . "a.")				; 213
    (?ỷ . "y?")				; 214
    (?ừ . "u+`")			; 215
    (?ử . "u+?")			; 216
    (?ỹ . "y~")				; 219
    (?ỵ . "y.")				; 220
    (?ỡ . "o+~")			; 222
    (?ư . "u+")				; 223
    (?à . "a`")				; 224
    (?á . "a'")				; 225
    (?â . "a^")				; 226
    (?ã . "a~")				; 227
    (?ả . "a?")				; 228
    (?ă . "a(")				; 229
    (?ữ . "u+~")			; 230
    (?ẫ . "a^~")			; 231
    (?è . "e`")				; 232
    (?é . "e'")				; 233
    (?ê . "e^")				; 234
    (?ẻ . "e?")				; 235
    (?ì . "i`")				; 236
    (?í . "i'")				; 237
    (?ĩ . "i~")				; 238
    (?ỉ . "i?")				; 239
    (?đ . "dd")				; 240
    (?ự . "u+.")			; 241
    (?ò . "o`")				; 242
    (?ó . "o'")				; 243
    (?ô . "o^")				; 244
    (?õ . "o~")				; 245
    (?ỏ . "o?")				; 246
    (?ọ . "o.")				; 247
    (?ụ . "u.")				; 248
    (?ù . "u`")				; 249
    (?ú . "u'")				; 250
    (?ũ . "u~")				; 251
    (?ủ . "u?")				; 252
    (?ý . "y'")				; 253
    (?ợ . "o+.")			; 254

    ;; upper case
    (?Ắ . "A('")			; 161
    (?Ằ . "A(`")			; 162
    (?Ặ . "A(.")			; 163
    (?Ấ . "A^'")			; 164
    (?Ầ . "A^`")			; 165
    (?Ẩ . "A^?")			; 166
    (?Ậ . "A^.")			; 167
    (?Ẽ . "E~")				; 168
    (?Ẹ . "E.")				; 169
    (?Ế . "E^'")			; 170
    (?Ề . "E^`")			; 171
    (?Ể . "E^?")			; 172
    (?Ễ . "E^~")			; 173
    (?Ệ . "E^.")			; 174
    (?Ố . "O^'")			; 175
    (?Ồ . "O^`")			; 176
    (?Ổ . "O^?")			; 177
    (?Ỗ . "O^~")			; 178
    (?Ộ . "O^.")			; 181
    (?Ờ . "O+`")			; 182
    (?Ở . "O+?")			; 183
    (?Ị . "I.")				; 184
    (?Ơ . "O+")				; 189
    (?Ớ . "O+'")			; 190
    (?Ẳ . "A(?")			; 198
    (?Ẵ . "A(~")			; 199
    (?Ỳ . "Y`")				; 207
    (?Ứ . "U+'")			; 209
    (?Ạ . "A.")				; 213
    (?Ỷ . "Y?")				; 214
    (?Ừ . "U+`")			; 215
    (?Ử . "U+?")			; 216
    (?Ỹ . "Y~")				; 219
    (?Ỵ . "Y.")				; 220
    (?Ỡ . "O+~")			; 222
    (?Ư . "U+")				; 223
    (?À . "A`")				; 224
    (?Á . "A'")				; 225
    (?Â . "A^")				; 226
    (?Ã . "A~")				; 227
    (?Ả . "A?")				; 228
    (?Ă . "A(")				; 229
    (?Ữ . "U+~")			; 230
    (?Ẫ . "A^~")			; 231
    (?È . "E`")				; 232
    (?É . "E'")				; 233
    (?Ê . "E^")				; 234
    (?Ẻ . "E?")				; 235
    (?Ì . "I`")				; 236
    (?Í . "I'")				; 237
    (?Ĩ . "I~")				; 238
    (?Ỉ . "I?")				; 239
    (?Đ . "DD")				; 240
    (?Đ . "dD")				; 240
    (?Đ . "Dd")				; 240
    (?Ự . "U+.")			; 241
    (?Ò . "O`")				; 242
    (?Ó . "O'")				; 243
    (?Ô . "O^")				; 244
    (?Õ . "O~")				; 245
    (?Ỏ . "O?")				; 246
    (?Ọ . "O.")				; 247
    (?Ụ . "U.")				; 248
    (?Ù . "U`")				; 249
    (?Ú . "U'")				; 250
    (?Ũ . "U~")				; 251
    (?Ủ . "U?")				; 252
    (?Ý . "Y'")				; 253
    (?Ợ . "O+.")			; 254

    ;; escape from composition
    (?\( . "\\(")			; breve (left parenthesis)
    (?^ . "\\^")			; circumflex (caret)
    (?+ . "\\+")			; horn (plus sign)
    (?' . "\\'")			; acute (apostrophe)
    (?` . "\\`")			; grave (backquote)
    (?? . "\\?")			; hook above (question mark)
    (?~ . "\\~")			; tilde (tilde)
    (?. . "\\.")			; dot below (period)
    (?d . "\\d")			; d-bar (d)
    (?\\ . "\\\\")			; literal backslash
    )
  "Alist of Vietnamese characters vs corresponding `VIQR' string.")

;; Regular expression matching single Vietnamese character represented
;; by VIQR.
(defconst viqr-regexp
  "[aeiouyAEIOUY]\\([(^+]?['`?~.]\\|[(^+]\\)\\|[Dd][Dd]")

;;;###autoload
(defun viet-decode-viqr-region (from to)
  "Convert `VIQR' mnemonics of the current region to Vietnamese characters.
When called from a program, expects two arguments,
positions (integers or markers) specifying the stretch of the region."
  (interactive "r")
  (save-restriction
    (narrow-to-region from to)
    (goto-char (point-min))
    (while (re-search-forward viqr-regexp nil t)
      (let* ((viqr (buffer-substring (match-beginning 0) (match-end 0)))
	     (ch (car (rassoc viqr viet-viqr-alist))))
	(if ch
	    (progn
	      (delete-region (match-beginning 0) (match-end 0))
	      (insert ch)))))))

;;;###autoload
(defun viet-decode-viqr-buffer ()
  "Convert `VIQR' mnemonics of the current buffer to Vietnamese characters."
  (interactive)
  (viet-decode-viqr-region (point-min) (point-max)))

;;;###autoload
(defun viet-encode-viqr-region (from to)
  "Convert Vietnamese characters of the current region to `VIQR' mnemonics.
When called from a program, expects two arguments,
positions (integers or markers) specifying the stretch of the region."
  (interactive "r")
  (save-restriction
    (narrow-to-region from to)
    (goto-char (point-min))
    (while (re-search-forward "\\cv" nil t)
      (let* ((ch (preceding-char))
	     (viqr (cdr (assq ch viet-viqr-alist))))
	(if viqr
	    (progn
	      (delete-char -1)
	      (insert viqr)))))))

;;;###autoload
(defun viet-encode-viqr-buffer ()
  "Convert Vietnamese characters of the current buffer to `VIQR' mnemonics."
  (interactive)
  (viet-encode-viqr-region (point-min) (point-max)))

;;;###autoload
(defun viqr-post-read-conversion (len)
  (save-excursion
    (save-restriction
      (narrow-to-region (point) (+ (point) len))
      (let ((buffer-modified-p (buffer-modified-p)))
	(viet-decode-viqr-region (point-min) (point-max))
	(set-buffer-modified-p buffer-modified-p)
	(- (point-max) (point-min))))))

;;;###autoload
(defun viqr-pre-write-conversion (from to)
  (let ((old-buf (current-buffer)))
    (set-buffer (generate-new-buffer " *temp*"))
    (if (stringp from)
	(insert from)
      (insert-buffer-substring old-buf from to))
    (viet-encode-viqr-region (point-min) (point-max))
    ;; Should return nil as annotations.
    nil))

;;;
(provide 'viet-util)

;;; viet-util.el ends here
