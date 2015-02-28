;;; srecode/java.el --- Srecode Java support

;; Copyright (C) 2009-2013 Free Software Foundation, Inc.

;; Author: Eric M. Ludlam <eric@siege-engine.com>

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
;;
;; Special support for the Java language.

;;; Code:

(require 'srecode/dictionary)
(require 'semantic/find)

;;;###autoload
(defun srecode-semantic-handle-:java (dict)
  "Add macros into the dictionary DICT based on the current java file.
Adds the following:
FILENAME_AS_PACKAGE - file/dir converted into a java package name.
FILENAME_AS_CLASS - file converted to a Java class name."
  ;; Symbols needed by empty files.
  (let* ((fsym (file-name-nondirectory (buffer-file-name)))
	 (fnox (file-name-sans-extension fsym))
	 (dir (file-name-directory (buffer-file-name)))
	 (fpak fsym)
	 )
    (while (string-match "\\.\\| " fpak)
      (setq fpak (replace-match "_" t t fpak)))
    (if (string-match "src/" dir)
	(setq dir (substring dir (match-end 0)))
      (setq dir (file-name-nondirectory (directory-file-name dir))))
    (setq dir (directory-file-name dir))
    (while (string-match "/" dir)
      (setq dir (replace-match "." t t dir)))
    (srecode-dictionary-set-value dict "FILENAME_AS_PACKAGE" dir)
    (srecode-dictionary-set-value dict "FILENAME_AS_CLASS" fnox)
    )
  ;; Symbols needed for most other files with stuff in them.
  (let ((pkg (semantic-find-tags-by-class 'package (current-buffer))))
    (when pkg
      (srecode-dictionary-set-value dict "CURRENT_PACKAGE" (semantic-tag-name (car pkg)))
      ))
  )

(provide 'srecode/java)

;; Local variables:
;; generated-autoload-file: "loaddefs.el"
;; generated-autoload-load-name: "srecode/java"
;; End:

;;; srecode/java.el ends here
