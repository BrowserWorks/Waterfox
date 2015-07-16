;;; cyril-util.el --- utilities for Cyrillic scripts

;; Copyright (C) 1997-1998, 2001-2014 Free Software Foundation, Inc.

;; Keywords: mule, multilingual, Cyrillic

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

;; Fixme: are the next two useful?

;;;###autoload
(defun cyrillic-encode-koi8-r-char (char)
  "Return KOI8-R external character code of CHAR if appropriate."
  (encode-char char 'koi8-r))

;;;###autoload
(defun cyrillic-encode-alternativnyj-char (char)
  "Return ALTERNATIVNYJ external character code of CHAR if appropriate."
  (encode-char char 'alternativnyj))


;; Display

;; Written by Valery Alexeev <valery@math.uga.edu>.

(defvar cyrillic-language-alist
      (list '("Belarusian") '("Bulgarian") '("Macedonian")
	    '("Russian") '("Serbo-Croatian") '("Ukrainian"))
      "List of known cyrillic languages.")

;;;###autoload
(defun standard-display-cyrillic-translit (&optional cyrillic-language)
  "Display a cyrillic buffer using a transliteration.
For readability, the table is slightly
different from the one used for the input method `cyrillic-translit'.

The argument is a string which specifies which language you are using;
that affects the choice of transliterations slightly.
Possible values are listed in `cyrillic-language-alist'.
If the argument is t, we use the default cyrillic transliteration.
If the argument is nil, we return the display table to its standard state."
  (interactive
   (list
    (let* ((completion-ignore-case t))
      (completing-read
       "Cyrillic language (default nil): "
       cyrillic-language-alist nil t nil nil nil))))

  (or standard-display-table
      (setq standard-display-table (make-display-table)))

  (if (equal cyrillic-language "")
      (setq cyrillic-language nil))

  (if (null cyrillic-language)
      (setq standard-display-table (make-display-table))
    (aset standard-display-table ?а  [?a])
    (aset standard-display-table ?б  [?b])
    (aset standard-display-table ?в  [?v])
    (aset standard-display-table ?г  [?g])
    (aset standard-display-table ?д  [?d])
    (aset standard-display-table ?е  [?e])
    (aset standard-display-table ?ё  [?y ?o])
    (aset standard-display-table ?ж  [?z ?h])
    (aset standard-display-table ?з  [?z])
    (aset standard-display-table ?и  [?i])
    (aset standard-display-table ?й  [?j])
    (aset standard-display-table ?к  [?k])
    (aset standard-display-table ?л  [?l])
    (aset standard-display-table ?м  [?m])
    (aset standard-display-table ?н  [?n])
    (aset standard-display-table ?о  [?o])
    (aset standard-display-table ?п  [?p])
    (aset standard-display-table ?р  [?r])
    (aset standard-display-table ?с  [?s])
    (aset standard-display-table ?т  [?t])
    (aset standard-display-table ?у  [?u])
    (aset standard-display-table ?ф  [?f])
    (aset standard-display-table ?х  [?k ?h])
    (aset standard-display-table ?ц  [?t ?s])
    (aset standard-display-table ?ч  [?c ?h])
    (aset standard-display-table ?ш  [?s ?h])
    (aset standard-display-table ?щ  [?s ?c ?h])
    (aset standard-display-table ?ъ  [?~])
    (aset standard-display-table ?ы  [?y])
    (aset standard-display-table ?ь  [?'])
    (aset standard-display-table ?э  [?e ?'])
    (aset standard-display-table ?ю  [?y ?u])
    (aset standard-display-table ?я  [?y ?a])

    (aset standard-display-table ?А  [?A])
    (aset standard-display-table ?Б  [?B])
    (aset standard-display-table ?В  [?V])
    (aset standard-display-table ?Г  [?G])
    (aset standard-display-table ?Д  [?D])
    (aset standard-display-table ?Е  [?E])
    (aset standard-display-table ?Ё  [?Y ?o])
    (aset standard-display-table ?Ж  [?Z ?h])
    (aset standard-display-table ?З  [?Z])
    (aset standard-display-table ?И  [?I])
    (aset standard-display-table ?Й  [?J])
    (aset standard-display-table ?К  [?K])
    (aset standard-display-table ?Л  [?L])
    (aset standard-display-table ?М  [?M])
    (aset standard-display-table ?Н  [?N])
    (aset standard-display-table ?О  [?O])
    (aset standard-display-table ?П  [?P])
    (aset standard-display-table ?Р  [?R])
    (aset standard-display-table ?С  [?S])
    (aset standard-display-table ?Т  [?T])
    (aset standard-display-table ?У  [?U])
    (aset standard-display-table ?Ф  [?F])
    (aset standard-display-table ?Х  [?K ?h])
    (aset standard-display-table ?Ц  [?T ?s])
    (aset standard-display-table ?Ч  [?C ?h])
    (aset standard-display-table ?Ш  [?S ?h])
    (aset standard-display-table ?Щ  [?S ?c ?h])
    (aset standard-display-table ?Ъ  [?~])
    (aset standard-display-table ?Ы  [?Y])
    (aset standard-display-table ?Ь  [?'])
    (aset standard-display-table ?Э  [?E ?'])
    (aset standard-display-table ?Ю  [?Y ?u])
    (aset standard-display-table ?Я  [?Y ?a])

    (aset standard-display-table ?є  [?i ?e])
    (aset standard-display-table ?ї  [?i])
    (aset standard-display-table ?ў  [?u])
    (aset standard-display-table ?ђ  [?d ?j])
    (aset standard-display-table ?ћ  [?c ?h ?j])
    (aset standard-display-table ?ѓ  [?g ?j])
    (aset standard-display-table ?ѕ  [?s])
    (aset standard-display-table ?ќ  [?k])
    (aset standard-display-table ?і  [?i])
    (aset standard-display-table ?ј  [?j])
    (aset standard-display-table ?љ  [?l ?j])
    (aset standard-display-table ?њ  [?n ?j])
    (aset standard-display-table ?џ  [?d ?z])

    (aset standard-display-table ?Є  [?Y ?e])
    (aset standard-display-table ?Ї  [?Y ?i])
    (aset standard-display-table ?Ў  [?U])
    (aset standard-display-table ?Ђ  [?D ?j])
    (aset standard-display-table ?Ћ  [?C ?h ?j])
    (aset standard-display-table ?Ѓ  [?G ?j])
    (aset standard-display-table ?Ѕ  [?S])
    (aset standard-display-table ?Ќ  [?K])
    (aset standard-display-table ?І  [?I])
    (aset standard-display-table ?Ј  [?J])
    (aset standard-display-table ?Љ  [?L ?j])
    (aset standard-display-table ?Њ  [?N ?j])
    (aset standard-display-table ?Џ  [?D ?j])

    (when (equal cyrillic-language "Bulgarian")
      (aset standard-display-table ?щ [?s ?h ?t])
      (aset standard-display-table ?Щ [?S ?h ?t])
      (aset standard-display-table ?ю [?i ?u])
      (aset standard-display-table ?Ю [?I ?u])
      (aset standard-display-table ?я [?i ?a])
      (aset standard-display-table ?Я [?I ?a]))

    (when (equal cyrillic-language "Ukrainian")	; based on the official
					; transliteration table
      (aset standard-display-table ?и [?y])
      (aset standard-display-table ?И [?Y])
      (aset standard-display-table ?й [?i])
      (aset standard-display-table ?Й [?Y])
      (aset standard-display-table ?ю [?i ?u])
      (aset standard-display-table ?я [?i ?a]))))

;;
(provide 'cyril-util)

;; Local Variables:
;; coding: utf-8
;; End:

;;; cyril-util.el ends here
