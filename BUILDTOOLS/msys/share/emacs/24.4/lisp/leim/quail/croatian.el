;;; croatian.el -- Quail package for inputting Croatian  -*-coding: utf-8;-*-

;; Copyright (C) 2003-2014 Free Software Foundation, Inc.

;; Author: Hrvoje Nikšić <hniksic@xemacs.org>
;; Keywords: i18n

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

;; Modeled after czech.el by Milan Zamazal.

;;; Code:

(require 'quail)

(quail-define-package
 "croatian" "Croatian" "HR" nil
 "\"Standard\" Croatian keyboard."
  nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("@" ?\")
 ("^" ?&)
 ("&" ?/)
 ("*" ?\()
 ("(" ?\))
 (")" ?=)
 ("-" ?\')
 ("_" ??)
 ("=" ?+)
 ("+" ?*)
 ("[" ?š)
 ("{" ?Š)
 ("]" ?đ)
 ("}" ?Đ)
 (";" ?č)
 (":" ?Č)
 ("'" ?ć)
 ("\"" ?Ć)
 ("\\" ?ž)
 ("|" ?Ž)
 ("<" ?\;)
 (">" ?:)
 ("/" ?-)
 ("?" ?_)
 ("y" ?z)
 ("Y" ?Z)
 ("z" ?y)
 ("Z" ?Y))

(quail-define-package
 "croatian-qwerty" "Croatian" "HR" nil
 "Croatian keyboard without the y/z swap."
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("@" ?\")
 ("^" ?&)
 ("&" ?/)
 ("*" ?\()
 ("(" ?\))
 (")" ?=)
 ("-" ?\')
 ("_" ??)
 ("=" ?+)
 ("+" ?*)
 ("[" ?š)
 ("{" ?Š)
 ("]" ?đ)
 ("}" ?Đ)
 (";" ?č)
 (":" ?Č)
 ("'" ?ć)
 ("\"" ?Ć)
 ("\\" ?ž)
 ("|" ?Ž)
 ("<" ?\;)
 (">" ?:)
 ("/" ?-)
 ("?" ?_))

(quail-define-package
 "croatian-prefix" "Croatian" "HR" nil
 "Croatian input method, prefix.

\"c -> č
'c -> ć
\"s -> š
\"z -> ž
/d -> đ"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("\"c" ?č)
 ("\"C" ?Č)
 ("'c" ?ć)
 ("'C" ?Ć)
 ("\"s" ?š)
 ("\"S" ?Š)
 ("\"z" ?ž)
 ("\"Z" ?Ž)
 ("/d" ?đ)
 ("/D" ?Đ))

(quail-define-package
 "croatian-postfix" "Croatian" "HR" nil
 "Croatian input method, postfix.

c\" -> č
c' -> ć
s\" -> š
z\" -> ž
d/ -> đ"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("c\"" ?č)
 ("C\"" ?Č)
 ("c'" ?ć)
 ("C'" ?Ć)
 ("s\"" ?š)
 ("S\"" ?Š)
 ("z\"" ?ž)
 ("Z\"" ?Ž)
 ("d/" ?đ)
 ("D/" ?Đ))

(quail-define-package
 "croatian-xy" "Croatian" "HR" nil
 "An alternative Croatian input method.

cx -> č
cy -> ć
sx -> š
zx -> ž
dy -> đ"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("cx" ?č)
 ("CX" ?Č)
 ("Cx" ?Č)
 ("cy" ?ć)
 ("CY" ?Ć)
 ("Cy" ?Ć)
 ("sx" ?š)
 ("SX" ?Š)
 ("Sx" ?Š)
 ("zx" ?ž)
 ("ZX" ?Ž)
 ("Zx" ?Ž)
 ("dy" ?đ)
 ("DY" ?Đ)
 ("Dy" ?Đ))

(quail-define-package
 "croatian-cc" "Croatian" "HR" nil
 "Another alternative Croatian input method.

cc -> č
ch -> ć
ss -> š
zz -> ž
dd -> đ"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("cc" ?č)
 ("CC" ?Č)
 ("Cc" ?Č)
 ("ch" ?ć)
 ("CH" ?Ć)
 ("Ch" ?Ć)
 ("ss" ?š)
 ("SS" ?Š)
 ("Ss" ?Š)
 ("zz" ?ž)
 ("ZZ" ?Ž)
 ("Zz" ?Ž)
 ("dd" ?đ)
 ("DD" ?Đ)
 ("Dd" ?Đ))

;;; croatian.el ends here
