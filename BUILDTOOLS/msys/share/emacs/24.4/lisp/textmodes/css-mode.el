;;; css-mode.el --- Major mode to edit CSS files -*- lexical-binding: t -*-

;; Copyright (C) 2006-2014 Free Software Foundation, Inc.

;; Author: Stefan Monnier <monnier@iro.umontreal.ca>
;; Keywords: hypermedia

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

;; Yet another CSS mode.

;;; Todo:

;; - electric ; and }
;; - filling code with auto-fill-mode
;; - completion
;; - fix font-lock errors with multi-line selectors

;;; Code:

(defgroup css nil
  "Cascading Style Sheets (CSS) editing mode."
  :group 'languages)


(defun css-extract-keyword-list (res)
  (with-temp-buffer
    (url-insert-file-contents "http://www.w3.org/TR/REC-CSS2/css2.txt")
    (goto-char (point-max))
    (search-backward "Appendix H. Index")
    (forward-line)
    (delete-region (point-min) (point))
    (let ((result nil)
          keys)
      (dolist (re res)
        (goto-char (point-min))
        (setq keys nil)
        (while (re-search-forward (cdr re) nil t)
          (push (match-string 1) keys))
        (push (cons (car re) (sort keys 'string-lessp)) result))
      (nreverse result))))

(defun css-extract-parse-val-grammar (string env)
  (let ((start 0)
        (elems ())
        name)
    (while (string-match
            (concat "\\(?:"
                    (concat "<a [^>]+><span [^>]+>\\(?:"
                            "&lt;\\([^&]+\\)&gt;\\|'\\([^']+\\)'"
                            "\\)</span></a>")
                    "\\|" "\\(\\[\\)"
                    "\\|" "\\(]\\)"
                    "\\|" "\\(||\\)"
                    "\\|" "\\(|\\)"
                    "\\|" "\\([*+?]\\)"
                    "\\|" "\\({[^}]+}\\)"
                    "\\|" "\\(\\w+\\(?:-\\w+\\)*\\)"
                    "\\)[ \t\n]*")
            string start)
      ;; (assert (eq start (match-beginning 0)))
      (setq start (match-end 0))
      (cond
       ;; Reference to a type of value.
       ((setq name (match-string-no-properties 1 string))
        (push (intern name) elems))
       ;; Reference to another property's values.
       ((setq name (match-string-no-properties 2 string))
        (setq elems (delete-dups (append (cdr (assoc name env)) elems))))
       ;; A literal
       ((setq name (match-string-no-properties 9 string))
        (push name elems))
       ;; We just ignore the rest.  I.e. we ignore the structure because
       ;; it's too difficult to exploit anyway (it would allow us to only
       ;; complete top/center/bottom after one of left/center/right and
       ;; vice-versa).
       (t nil)))
    elems))


(defun css-extract-props-and-vals ()
  (with-temp-buffer
    (url-insert-file-contents "http://www.w3.org/TR/CSS21/propidx.html")
    (goto-char (point-min))
    (let ((props ()))
      (while (re-search-forward "#propdef-\\([^\"]+\\)\"><span class=\"propinst-\\1 xref\">'\\1'</span></a>" nil t)
        (let ((prop (match-string-no-properties 1)))
          (save-excursion
            (goto-char (match-end 0))
            (search-forward "<td>")
            (let ((vals-string (buffer-substring (point)
                                                 (progn
                                                   (re-search-forward "[ \t\n]+|[ \t\n]+<a href=\"cascade.html#value-def-inherit\" class=\"noxref\"><span class=\"value-inst-inherit\">inherit</span></a>")
                                                   (match-beginning 0)))))
              ;;
              (push (cons prop (css-extract-parse-val-grammar vals-string props))
                    props)))))
      props)))

;; Extraction was done with:
;; (css-extract-keyword-list
;;  '((pseudo . "^ +\\* :\\([^ \n,]+\\)")
;;    (at . "^ +\\* @\\([^ \n,]+\\)")
;;    (descriptor . "^ +\\* '\\([^ '\n]+\\)' (descriptor)")
;;    (media . "^ +\\* '\\([^ '\n]+\\)' media group")
;;    (property . "^ +\\* '\\([^ '\n]+\\)',")))

(defconst css-pseudo-ids
  '("active" "after" "before" "first" "first-child" "first-letter" "first-line"
    "focus" "hover" "lang" "left" "link" "right" "visited")
  "Identifiers for pseudo-elements and pseudo-classes.")

(defconst css-at-ids
  '("charset" "font-face" "import" "media" "page")
  "Identifiers that appear in the form @foo.")

(defconst css-descriptor-ids
  '("ascent" "baseline" "bbox" "cap-height" "centerline" "definition-src"
    "descent" "font-family" "font-size" "font-stretch" "font-style"
    "font-variant" "font-weight" "mathline" "panose-1" "slope" "src" "stemh"
    "stemv" "topline" "unicode-range" "units-per-em" "widths" "x-height")
  "Identifiers for font descriptors.")

(defconst css-media-ids
  '("all" "aural" "bitmap" "continuous" "grid" "paged" "static" "tactile"
    "visual")
  "Identifiers for types of media.")

(defconst css-property-ids
  '("azimuth" "background" "background-attachment" "background-color"
    "background-image" "background-position" "background-repeat" "block"
    "border" "border-bottom" "border-bottom-color" "border-bottom-style"
    "border-bottom-width" "border-collapse" "border-color" "border-left"
    "border-left-color" "border-left-style" "border-left-width" "border-right"
    "border-right-color" "border-right-style" "border-right-width"
    "border-spacing" "border-style" "border-top" "border-top-color"
    "border-top-style" "border-top-width" "border-width" "bottom"
    "caption-side" "clear" "clip" "color" "compact" "content"
    "counter-increment" "counter-reset" "cue" "cue-after" "cue-before"
    "cursor" "dashed" "direction" "display" "dotted" "double" "elevation"
    "empty-cells" "float" "font" "font-family" "font-size" "font-size-adjust"
    "font-stretch" "font-style" "font-variant" "font-weight" "groove" "height"
    "hidden" "inline" "inline-table" "inset" "left" "letter-spacing"
    "line-height" "list-item" "list-style" "list-style-image"
    "list-style-position" "list-style-type" "margin" "margin-bottom"
    "margin-left" "margin-right" "margin-top" "marker-offset" "marks"
    "max-height" "max-width" "min-height" "min-width" "orphans" "outline"
    "outline-color" "outline-style" "outline-width" "outset" "overflow"
    "padding" "padding-bottom" "padding-left" "padding-right" "padding-top"
    "page" "page-break-after" "page-break-before" "page-break-inside" "pause"
    "pause-after" "pause-before" "pitch" "pitch-range" "play-during" "position"
    "quotes" "richness" "ridge" "right" "run-in" "size" "solid" "speak"
    "speak-header" "speak-numeral" "speak-punctuation" "speech-rate" "stress"
    "table" "table-caption" "table-cell" "table-column" "table-column-group"
    "table-footer-group" "table-header-group" "table-layout" "table-row"
    "table-row-group" "text-align" "text-decoration" "text-indent"
    "text-shadow" "text-transform" "top" "unicode-bidi" "vertical-align"
    "visibility" "voice-family" "volume" "white-space" "widows" "width"
    "word-spacing" "z-index")
  "Identifiers for properties.")

(defcustom css-electric-keys '(?\} ?\;) ;; '()
  "Self inserting keys which should trigger re-indentation."
  :version "22.2"
  :type '(repeat character)
  :options '((?\} ?\;))
  :group 'css)

(defvar css-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; C-style comments.
    (modify-syntax-entry ?/ ". 14" st)
    (modify-syntax-entry ?* ". 23" st)
    ;; Strings.
    (modify-syntax-entry ?\" "\"" st)
    (modify-syntax-entry ?\' "\"" st)
    ;; Blocks.
    (modify-syntax-entry ?\{ "(}" st)
    (modify-syntax-entry ?\} "){" st)
    ;; Args in url(...) thingies and other "function calls".
    (modify-syntax-entry ?\( "()" st)
    (modify-syntax-entry ?\) ")(" st)
    ;; To match attributes in selectors.
    (modify-syntax-entry ?\[ "(]" st)
    (modify-syntax-entry ?\] ")[" st)
    ;; Special chars that sometimes come at the beginning of words.
    (modify-syntax-entry ?@ "'" st)
    ;; (modify-syntax-entry ?: "'" st)
    (modify-syntax-entry ?# "'" st)
    ;; Distinction between words and symbols.
    (modify-syntax-entry ?- "_" st)
    st))

(defconst css-escapes-re
  "\\\\\\(?:[^\000-\037\177]\\|[0-9a-fA-F]+[ \n\t\r\f]?\\)")
(defconst css-nmchar-re (concat "\\(?:[-[:alnum:]]\\|" css-escapes-re "\\)"))
(defconst css-nmstart-re (concat "\\(?:[[:alpha:]]\\|" css-escapes-re "\\)"))
(defconst css-ident-re (concat css-nmstart-re css-nmchar-re "*"))
(defconst css-proprietary-nmstart-re ;; Vendor-specific properties.
  (concat "[-_]" (regexp-opt '("ms" "moz" "o" "khtml" "webkit")) "-"))
(defconst css-name-re (concat css-nmchar-re "+"))

(defface css-selector '((t :inherit font-lock-function-name-face))
  "Face to use for selectors."
  :group 'css)
(defface css-property '((t :inherit font-lock-variable-name-face))
  "Face to use for properties."
  :group 'css)
(defface css-proprietary-property '((t :inherit (css-property italic)))
  "Face to use for vendor-specific properties.")

(defvar css-font-lock-keywords
  `(("!\\s-*important" . font-lock-builtin-face)
    ;; Atrules keywords.  IDs not in css-at-ids are valid (ignored).
    ;; In fact the regexp should probably be
    ;; (,(concat "\\(@" css-ident-re "\\)\\([ \t\n][^;{]*\\)[;{]")
    ;;  (1 font-lock-builtin-face))
    ;; Since "An at-rule consists of everything up to and including the next
    ;; semicolon (;) or the next block, whichever comes first."
    (,(concat "@" css-ident-re) . font-lock-builtin-face)
    ;; Selectors.
    ;; FIXME: attribute selectors don't work well because they may contain
    ;; strings which have already been highlighted as f-l-string-face and
    ;; thus prevent this highlighting from being applied (actually now that
    ;; I use `append' this should work better).  But really the part of the
    ;; selector between [...] should simply not be highlighted.
    (,(concat "^\\([ \t]*[^@:{}\n][^:{}]+\\(?::" (regexp-opt css-pseudo-ids t)
              "\\(?:([^)]+)\\)?[^:{\n]*\\)*\\)\\(?:\n[ \t]*\\)*{")
     (1 'css-selector append))
    ;; In the above rule, we allow the open-brace to be on some subsequent
    ;; line.  This will only work if we properly mark the intervening text
    ;; as being part of a multiline element (and even then, this only
    ;; ensures proper refontification, but not proper discovery).
    ("^[ \t]*{" (0 (save-excursion
                     (goto-char (match-beginning 0))
                     (skip-chars-backward " \n\t")
                     (put-text-property (point) (match-end 0)
                                        'font-lock-multiline t)
                     ;; No face.
                     nil)))
    ;; Properties.  Again, we don't limit ourselves to css-property-ids.
    (,(concat "\\(?:[{;]\\|^\\)[ \t]*\\("
              "\\(?:\\(" css-proprietary-nmstart-re "\\)\\|"
              css-nmstart-re "\\)" css-nmchar-re "*"
              "\\)\\s-*:")
     (1 (if (match-end 2) 'css-proprietary-property 'css-property)))))

(defvar css-font-lock-defaults
  '(css-font-lock-keywords nil t))

(defcustom css-indent-offset 4
  "Basic size of one indentation step."
  :version "22.2"
  :type 'integer)

(require 'smie)

(defconst css-smie-grammar
  (smie-prec2->grammar
   (smie-precs->prec2 '((assoc ";") (assoc ",") (left ":")))))

(defun css-smie--forward-token ()
  (cond
   ((and (eq (char-before) ?\})
         ;; FIXME: If the next char is not whitespace, what should we do?
         (or (memq (char-after) '(?\s ?\t ?\n))
             (looking-at comment-start-skip)))
    (if (memq (char-after) '(?\s ?\t ?\n))
        (forward-char 1) (forward-comment 1))
    ";")
   ((progn (forward-comment (point-max))
           (looking-at "[;,:]"))
    (forward-char 1) (match-string 0))
   (t (smie-default-forward-token))))

(defun css-smie--backward-token ()
  (let ((pos (point)))
    (forward-comment (- (point)))
    (cond
     ;; FIXME: If the next char is not whitespace, what should we do?
     ((and (eq (char-before) ?\}) (> pos (point))) ";")
     ((memq (char-before) '(?\; ?\, ?\:))
      (forward-char -1) (string (char-after)))
     (t (smie-default-backward-token)))))

(defun css-smie-rules (kind token)
  (pcase (cons kind token)
    (`(:elem . basic) css-indent-offset)
    (`(:elem . arg) 0)
    (`(:list-intro . ,(or `";" `"")) t) ;"" stands for BOB (bug#15467).
    (`(:before . "{") (if (smie-rule-hanging-p)
                         (smie-rule-parent 0)))))

;;;###autoload
(define-derived-mode css-mode fundamental-mode "CSS"
  "Major mode to edit Cascading Style Sheets."
  (setq-local font-lock-defaults css-font-lock-defaults)
  (setq-local comment-start "/*")
  (setq-local comment-start-skip "/\\*+[ \t]*")
  (setq-local comment-end "*/")
  (setq-local comment-end-skip "[ \t]*\\*+/")
  (setq-local parse-sexp-ignore-comments t)
  (setq-local indent-line-function 'css-indent-line)
  (setq-local fill-paragraph-function 'css-fill-paragraph)
  (setq-local add-log-current-defun-function #'css-current-defun-name)
  (smie-setup css-smie-grammar #'css-smie-rules
              :forward-token #'css-smie--forward-token
              :backward-token #'css-smie--backward-token)
  (setq-local electric-indent-chars
              (append css-electric-keys electric-indent-chars)))

(defvar comment-continue)

(defun css-fill-paragraph (&optional justify)
  (save-excursion
    (let ((ppss (syntax-ppss))
          (eol (line-end-position)))
      (cond
       ((and (nth 4 ppss)
             (save-excursion
               (goto-char (nth 8 ppss))
               (forward-comment 1)
               (prog1 (not (bolp))
                 (setq eol (point)))))
        ;; Filling inside a comment whose comment-end marker is not \n.
        ;; This code is meant to be generic, so that it works not only for
        ;; css-mode but for all modes.
        (save-restriction
          (narrow-to-region (nth 8 ppss) eol)
          (comment-normalize-vars)      ;Will define comment-continue.
          (let ((fill-paragraph-function nil)
                (paragraph-separate
                 (if (and comment-continue
                          (string-match "[^ \t]" comment-continue))
                     (concat "\\(?:[ \t]*" (regexp-quote comment-continue)
                             "\\)?\\(?:" paragraph-separate "\\)")
                   paragraph-separate))
                (paragraph-start
                 (if (and comment-continue
                          (string-match "[^ \t]" comment-continue))
                     (concat "\\(?:[ \t]*" (regexp-quote comment-continue)
                             "\\)?\\(?:" paragraph-start "\\)")
                   paragraph-start)))
            (fill-paragraph justify)
            ;; Don't try filling again.
            t)))

       ((and (null (nth 8 ppss))
             (or (nth 1 ppss)
                 (and (ignore-errors
                        (down-list 1)
                        (when (<= (point) eol)
                          (setq ppss (syntax-ppss)))))))
        (goto-char (nth 1 ppss))
        (let ((end (save-excursion
                     (ignore-errors (forward-sexp 1) (copy-marker (point) t)))))
          (when end
            (while (re-search-forward "[{;}]" end t)
              (cond
               ;; This is a false positive inside a string or comment.
               ((nth 8 (syntax-ppss)) nil)
               ((eq (char-before) ?\})
                (save-excursion
                  (forward-char -1)
                  (skip-chars-backward " \t")
                  (unless (bolp) (newline))))
               (t
                (while
                    (progn
                      (setq eol (line-end-position))
                      (and (forward-comment 1)
                           (> (point) eol)
                           ;; A multi-line comment should be on its own line.
                           (save-excursion (forward-comment -1)
                                           (when (< (point) eol)
                                             (newline)
                                             t)))))
                (if (< (point) eol) (newline)))))
            (goto-char (nth 1 ppss))
            (indent-region (line-beginning-position 2) end)
            ;; Don't use the default filling code.
            t)))))))

(defun css-current-defun-name ()
  "Return the name of the CSS section at point, or nil."
  (save-excursion
    (let ((max (max (point-min) (- (point) 1600))))  ; approx 20 lines back
      (when (search-backward "{" max t)
	(skip-chars-backward " \t\r\n")
	(beginning-of-line)
	(if (looking-at "^[ \t]*\\([^{\r\n]*[^ {\t\r\n]\\)")
	    (match-string-no-properties 1))))))

(provide 'css-mode)
;;; css-mode.el ends here
