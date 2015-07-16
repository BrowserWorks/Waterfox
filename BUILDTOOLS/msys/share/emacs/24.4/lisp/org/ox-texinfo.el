;;; ox-texinfo.el --- Texinfo Back-End for Org Export Engine

;; Copyright (C) 2012-2014 Free Software Foundation, Inc.
;; Author: Jonathan Leech-Pepin <jonathan.leechpepin at gmail dot com>
;; Keywords: outlines, hypermedia, calendar, wp

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
;; See Org manual for details.

;;; Code:

(eval-when-compile (require 'cl))
(require 'ox)

(defvar orgtbl-exp-regexp)



;;; Define Back-End

(org-export-define-backend 'texinfo
  '((bold . org-texinfo-bold)
    (center-block . org-texinfo-center-block)
    (clock . org-texinfo-clock)
    (code . org-texinfo-code)
    (comment . (lambda (&rest args) ""))
    (comment-block . (lambda (&rest args) ""))
    (drawer . org-texinfo-drawer)
    (dynamic-block . org-texinfo-dynamic-block)
    (entity . org-texinfo-entity)
    (example-block . org-texinfo-example-block)
    (export-block . org-texinfo-export-block)
    (export-snippet . org-texinfo-export-snippet)
    (fixed-width . org-texinfo-fixed-width)
    (footnote-definition . org-texinfo-footnote-definition)
    (footnote-reference . org-texinfo-footnote-reference)
    (headline . org-texinfo-headline)
    (inline-src-block . org-texinfo-inline-src-block)
    (inlinetask . org-texinfo-inlinetask)
    (italic . org-texinfo-italic)
    (item . org-texinfo-item)
    (keyword . org-texinfo-keyword)
    (line-break . org-texinfo-line-break)
    (link . org-texinfo-link)
    (paragraph . org-texinfo-paragraph)
    (plain-list . org-texinfo-plain-list)
    (plain-text . org-texinfo-plain-text)
    (planning . org-texinfo-planning)
    (property-drawer . org-texinfo-property-drawer)
    (quote-block . org-texinfo-quote-block)
    (quote-section . org-texinfo-quote-section)
    (radio-target . org-texinfo-radio-target)
    (section . org-texinfo-section)
    (special-block . org-texinfo-special-block)
    (src-block . org-texinfo-src-block)
    (statistics-cookie . org-texinfo-statistics-cookie)
    (subscript . org-texinfo-subscript)
    (superscript . org-texinfo-superscript)
    (table . org-texinfo-table)
    (table-cell . org-texinfo-table-cell)
    (table-row . org-texinfo-table-row)
    (target . org-texinfo-target)
    (template . org-texinfo-template)
    (timestamp . org-texinfo-timestamp)
    (verbatim . org-texinfo-verbatim)
    (verse-block . org-texinfo-verse-block))
  :export-block "TEXINFO"
  :filters-alist
  '((:filter-headline . org-texinfo-filter-section-blank-lines)
    (:filter-parse-tree . org-texinfo--normalize-headlines)
    (:filter-section . org-texinfo-filter-section-blank-lines))
  :menu-entry
  '(?i "Export to Texinfo"
       ((?t "As TEXI file" org-texinfo-export-to-texinfo)
	(?i "As INFO file" org-texinfo-export-to-info)))
  :options-alist
  '((:texinfo-filename "TEXINFO_FILENAME" nil nil t)
    (:texinfo-class "TEXINFO_CLASS" nil org-texinfo-default-class t)
    (:texinfo-header "TEXINFO_HEADER" nil nil newline)
    (:texinfo-post-header "TEXINFO_POST_HEADER" nil nil newline)
    (:subtitle "SUBTITLE" nil nil newline)
    (:subauthor "SUBAUTHOR" nil nil newline)
    (:texinfo-dircat "TEXINFO_DIR_CATEGORY" nil nil t)
    (:texinfo-dirtitle "TEXINFO_DIR_TITLE" nil nil t)
    (:texinfo-dirdesc "TEXINFO_DIR_DESC" nil nil t)
    (:texinfo-printed-title "TEXINFO_PRINTED_TITLE" nil nil t)))



;;; User Configurable Variables

(defgroup org-export-texinfo nil
  "Options for exporting Org mode files to Texinfo."
  :tag "Org Export Texinfo"
  :version "24.4"
  :package-version '(Org . "8.0")
  :group 'org-export)

;;;; Preamble

(defcustom org-texinfo-coding-system nil
  "Default document encoding for Texinfo output.

If `nil' it will default to `buffer-file-coding-system'."
  :group 'org-export-texinfo
  :type 'coding-system)

(defcustom org-texinfo-default-class "info"
  "The default Texinfo class."
  :group 'org-export-texinfo
  :type '(string :tag "Texinfo class"))

(defcustom org-texinfo-classes
  '(("info"
     "@documentencoding AUTO\n@documentlanguage AUTO"
     ("@chapter %s" . "@unnumbered %s")
     ("@section %s" . "@unnumberedsec %s")
     ("@subsection %s" . "@unnumberedsubsec %s")
     ("@subsubsection %s" . "@unnumberedsubsubsec %s")))
  "Alist of Texinfo classes and associated header and structure.
If #+TEXINFO_CLASS is set in the buffer, use its value and the
associated information.  Here is the structure of each cell:

  \(class-name
    header-string
    \(numbered-section . unnumbered-section)
    ...)


The header string
-----------------

The header string is inserted in the header of the generated
document, right after \"@setfilename\" and \"@settitle\"
commands.

If it contains the special string

  \"@documentencoding AUTO\"

\"AUTO\" will be replaced with an appropriate coding system.  See
`org-texinfo-coding-system' for more information.  Likewise, if
the string contains the special string

  \"@documentlanguage AUTO\"

\"AUTO\" will be replaced with the language defined in the
buffer, through #+LANGUAGE keyword, or globally, with
`org-export-default-language', which see.


The sectioning structure
------------------------

The sectioning structure of the class is given by the elements
following the header string.  For each sectioning level, a number
of strings is specified.  A %s formatter is mandatory in each
section string and will be replaced by the title of the section.

Instead of a list of sectioning commands, you can also specify
a function name.  That function will be called with two
parameters, the reduced) level of the headline, and a predicate
non-nil when the headline should be numbered.  It must return
a format string in which the section title will be added."
  :group 'org-export-texinfo
  :version "24.4"
  :package-version '(Org . "8.2")
  :type '(repeat
	  (list (string :tag "Texinfo class")
		(string :tag "Texinfo header")
		(repeat :tag "Levels" :inline t
			(choice
			 (cons :tag "Heading"
			       (string :tag "  numbered")
			       (string :tag "unnumbered"))
			 (function :tag "Hook computing sectioning"))))))

;;;; Headline

(defcustom org-texinfo-format-headline-function 'ignore
  "Function to format headline text.

This function will be called with 5 arguments:
TODO      the todo keyword (string or nil).
TODO-TYPE the type of todo (symbol: `todo', `done', nil)
PRIORITY  the priority of the headline (integer or nil)
TEXT      the main headline text (string).
TAGS      the tags as a list of strings (list of strings or nil).

The function result will be used in the section format string.

As an example, one could set the variable to the following, in
order to reproduce the default set-up:

\(defun org-texinfo-format-headline (todo todo-type priority text tags)
  \"Default format function for a headline.\"
  \(concat (when todo
            \(format \"\\\\textbf{\\\\textsc{\\\\textsf{%s}}} \" todo))
	  \(when priority
            \(format \"\\\\framebox{\\\\#%c} \" priority))
	  text
	  \(when tags
            \(format \"\\\\hfill{}\\\\textsc{%s}\"
              \(mapconcat 'identity tags \":\"))))"
  :group 'org-export-texinfo
  :type 'function)

;;;; Node listing (menu)

(defcustom org-texinfo-node-description-column 32
  "Column at which to start the description in the node listings.
If a node title is greater than this length, the description will
be placed after the end of the title."
  :group 'org-export-texinfo
  :type 'integer)

;;;; Timestamps

(defcustom org-texinfo-active-timestamp-format "@emph{%s}"
  "A printf format string to be applied to active timestamps."
  :group 'org-export-texinfo
  :type 'string)

(defcustom org-texinfo-inactive-timestamp-format "@emph{%s}"
  "A printf format string to be applied to inactive timestamps."
  :group 'org-export-texinfo
  :type 'string)

(defcustom org-texinfo-diary-timestamp-format "@emph{%s}"
  "A printf format string to be applied to diary timestamps."
  :group 'org-export-texinfo
  :type 'string)

;;;; Links

(defcustom org-texinfo-link-with-unknown-path-format "@indicateurl{%s}"
  "Format string for links with unknown path type."
  :group 'org-export-texinfo
  :type 'string)

;;;; Tables

(defcustom org-texinfo-tables-verbatim nil
  "When non-nil, tables are exported verbatim."
  :group 'org-export-texinfo
  :type 'boolean)

(defcustom org-texinfo-table-scientific-notation "%s\\,(%s)"
  "Format string to display numbers in scientific notation.
The format should have \"%s\" twice, for mantissa and exponent
\(i.e. \"%s\\\\times10^{%s}\").

When nil, no transformation is made."
  :group 'org-export-texinfo
  :type '(choice
	  (string :tag "Format string")
	  (const :tag "No formatting" nil)))

(defcustom org-texinfo-def-table-markup "@samp"
  "Default setting for @table environments."
  :group 'org-export-texinfo
  :type 'string)

;;;; Text markup

(defcustom org-texinfo-text-markup-alist '((bold . "@strong{%s}")
					   (code . code)
					   (italic . "@emph{%s}")
					   (verbatim . verb)
					   (comment . "@c %s"))
  "Alist of Texinfo expressions to convert text markup.

The key must be a symbol among `bold', `italic' and `comment'.
The value is a formatting string to wrap fontified text with.

Value can also be set to the following symbols: `verb' and
`code'.  For the former, Org will use \"@verb\" to
create a format string and select a delimiter character that
isn't in the string.  For the latter, Org will use \"@code\"
to typeset and try to protect special characters.

If no association can be found for a given markup, text will be
returned as-is."
  :group 'org-export-texinfo
  :type 'alist
  :options '(bold code italic verbatim comment))

;;;; Drawers

(defcustom org-texinfo-format-drawer-function
  (lambda (name contents) contents)
  "Function called to format a drawer in Texinfo code.

The function must accept two parameters:
  NAME      the drawer name, like \"LOGBOOK\"
  CONTENTS  the contents of the drawer.

The function should return the string to be exported.

The default function simply returns the value of CONTENTS."
  :group 'org-export-texinfo
  :version "24.4"
  :package-version '(Org . "8.2")
  :type 'function)

;;;; Inlinetasks

(defcustom org-texinfo-format-inlinetask-function 'ignore
  "Function called to format an inlinetask in Texinfo code.

The function must accept six parameters:
  TODO      the todo keyword, as a string
  TODO-TYPE the todo type, a symbol among `todo', `done' and nil.
  PRIORITY  the inlinetask priority, as a string
  NAME      the inlinetask name, as a string.
  TAGS      the inlinetask tags, as a list of strings.
  CONTENTS  the contents of the inlinetask, as a string.

The function should return the string to be exported.

For example, the variable could be set to the following function
in order to mimic default behavior:

\(defun org-texinfo-format-inlinetask \(todo type priority name tags contents\)
\"Format an inline task element for Texinfo export.\"
  \(let ((full-title
	 \(concat
	  \(when todo
            \(format \"@strong{%s} \" todo))
	  \(when priority (format \"#%c \" priority))
	  title
	  \(when tags
            \(format \":%s:\"
                    \(mapconcat 'identity tags \":\")))))
    \(format (concat \"@center %s\n\n\"
		    \"%s\"
                    \"\n\"))
	    full-title contents))"
  :group 'org-export-texinfo
  :type 'function)

;;;; Compilation

(defcustom org-texinfo-info-process '("makeinfo %f")
  "Commands to process a Texinfo file to an INFO file.
This is list of strings, each of them will be given to the shell
as a command.  %f in the command will be replaced by the full
file name, %b by the file base name (i.e without extension) and
%o by the base directory of the file."
  :group 'org-export-texinfo
  :type '(repeat :tag "Shell command sequence"
		 (string :tag "Shell command")))

(defcustom org-texinfo-logfiles-extensions
  '("aux" "toc" "cp" "fn" "ky" "pg" "tp" "vr")
  "The list of file extensions to consider as Texinfo logfiles.
The logfiles will be remove if `org-texinfo-remove-logfiles' is
non-nil."
  :group 'org-export-texinfo
  :type '(repeat (string :tag "Extension")))

(defcustom org-texinfo-remove-logfiles t
  "Non-nil means remove the logfiles produced by compiling a Texinfo file.
By default, logfiles are files with these extensions: .aux, .toc,
.cp, .fn, .ky, .pg and .tp.  To define the set of logfiles to remove,
set `org-texinfo-logfiles-extensions'."
  :group 'org-export-latex
  :type 'boolean)

;;; Constants

(defconst org-texinfo-max-toc-depth 4
  "Maximum depth for creation of detailed menu listings.
Beyond this depth, Texinfo will not recognize the nodes and will
cause errors.  Left as a constant in case this value ever
changes.")

(defconst org-texinfo-supported-coding-systems
  '("US-ASCII" "UTF-8" "ISO-8859-15" "ISO-8859-1" "ISO-8859-2" "koi8-r" "koi8-u")
  "List of coding systems supported by Texinfo, as strings.
Specified coding system will be matched against these strings.
If two strings share the same prefix (e.g. \"ISO-8859-1\" and
\"ISO-8859-15\"), the most specific one has to be listed first.")


;;; Internal Functions

(defun org-texinfo-filter-section-blank-lines (headline back-end info)
  "Filter controlling number of blank lines after a section."
  (let ((blanks (make-string 2 ?\n)))
    (replace-regexp-in-string "\n\\(?:\n[ \t]*\\)*\\'" blanks headline)))

(defun org-texinfo--normalize-headlines (tree back-end info)
  "Normalize headlines in TREE.

BACK-END is the symbol specifying back-end used for export. INFO
is a plist used as a communication channel.

Make sure every headline in TREE contains a section, since those
are required to install a menu.  Also put exactly one blank line
at the end of each section.

Return new tree."
  (org-element-map tree 'headline
    (lambda (hl)
      (org-element-put-property hl :post-blank 1)
      (let ((contents (org-element-contents hl)))
	(when contents
	  (let ((first (org-element-map contents '(headline section)
			 #'identity info t)))
	    (unless (eq (org-element-type first) 'section)
	      (apply #'org-element-set-contents
		     hl
		     (cons `(section (:parent ,hl)) contents)))))))
    info)
  tree)

(defun org-texinfo--find-verb-separator (s)
  "Return a character not used in string S.
This is used to choose a separator for constructs like \\verb."
  (let ((ll "~,./?;':\"|!@#%^&-_=+abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<>()[]{}"))
    (loop for c across ll
	  when (not (string-match (regexp-quote (char-to-string c)) s))
	  return (char-to-string c))))

(defun org-texinfo--text-markup (text markup)
  "Format TEXT depending on MARKUP text markup.
See `org-texinfo-text-markup-alist' for details."
  (let ((fmt (cdr (assq markup org-texinfo-text-markup-alist))))
    (cond
     ;; No format string: Return raw text.
     ((not fmt) text)
     ((eq 'verb fmt)
      (let ((separator (org-texinfo--find-verb-separator text)))
	(concat "@verb{" separator text separator "}")))
     ((eq 'code fmt)
      (let ((start 0)
	    (rtn "")
	    char)
	(while (string-match "[@{}]" text)
	  (setq char (match-string 0 text))
	  (if (> (match-beginning 0) 0)
	      (setq rtn (concat rtn (substring text 0 (match-beginning 0)))))
	  (setq text (substring text (1+ (match-beginning 0))))
	  (setq char (concat "@" char)
		rtn (concat rtn char)))
	(setq text (concat rtn text)
	      fmt "@code{%s}")
	(format fmt text)))
     ;; Else use format string.
     (t (format fmt text)))))

(defun org-texinfo--get-node (blob info)
  "Return node or anchor associated to BLOB.
BLOB is an element or object.  INFO is a plist used as
a communication channel.  The function guarantees the node or
anchor name is unique."
  (let ((cache (plist-get info :texinfo-node-cache)))
    (or (cdr (assq blob cache))
	(let ((name
	       (org-texinfo--sanitize-node
		(case (org-element-type blob)
		  (headline
		   (org-export-data (org-export-get-alt-title blob info) info))
		  ((radio-target target) (org-element-property :value blob))
		  (otherwise (or (org-element-property :name blob) ""))))))
	  ;; Ensure NAME is unique.
	  (while (rassoc name cache) (setq name (concat name "x")))
	  (plist-put info :texinfo-node-cache (cons (cons blob name) cache))
	  name))))

;;;; Menu sanitizing

(defun org-texinfo--sanitize-node (title)
  "Bend string TITLE to node line requirements.
Trim string and collapse multiple whitespace characters as they
are not significant.  Also remove the following characters: @
{ } ( ) : . ,"
  (replace-regexp-in-string
   "[:,.]" ""
   (replace-regexp-in-string
    "\\`(\\(.*)\\)" "[\\1"
    (org-trim (replace-regexp-in-string "[ \t]\\{2,\\}" " " title)))))

;;;; Content sanitizing

(defun org-texinfo--sanitize-content (text)
  "Escape special characters in string TEXT.
Special characters are: @ { }"
  (replace-regexp-in-string "[@{}]" "@\\&" text))

;;; Template

(defun org-texinfo-template (contents info)
  "Return complete document string after Texinfo conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (let ((title (org-export-data (plist-get info :title) info))
	;; Copying data is the contents of the first headline in
	;; parse tree with a non-nil copying property.
	(copying (org-element-map (plist-get info :parse-tree) 'headline
		   (lambda (hl)
		     (and (org-not-nil (org-element-property :COPYING hl))
			  (org-element-contents hl)))
		   info t)))
    (concat
     "\\input texinfo    @c -*- texinfo -*-\n"
     "@c %**start of header\n"
     (let ((file (or (plist-get info :texinfo-filename)
		     (let ((f (plist-get info :output-file)))
		       (and f (concat (file-name-sans-extension f) ".info"))))))
       (and file (format "@setfilename %s\n" file)))
     (format "@settitle %s\n" title)
     ;; Insert class-defined header.
     (org-element-normalize-string
      (let ((header (nth 1 (assoc (plist-get info :texinfo-class)
				  org-texinfo-classes)))
	    (coding
	     (catch 'coding-system
	       (let ((case-fold-search t)
		     (name (symbol-name (or org-texinfo-coding-system
					    buffer-file-coding-system))))
		 (dolist (system org-texinfo-supported-coding-systems "UTF-8")
		   (when (org-string-match-p (regexp-quote system) name)
		     (throw 'coding-system system))))))
	    (language (plist-get info :language))
	    (case-fold-search nil))
	;; Auto coding system.
	(replace-regexp-in-string
	 "^@documentencoding \\(AUTO\\)$"
	 coding
	 (replace-regexp-in-string
	  "^@documentlanguage \\(AUTO\\)$" language header t nil 1) t nil 1)))
     ;; Additional header options set by #+TEXINFO_HEADER.
     (let ((texinfo-header (plist-get info :texinfo-header)))
       (and texinfo-header (org-element-normalize-string texinfo-header)))
     "@c %**end of header\n\n"
     ;; Additional options set by #+TEXINFO_POST_HEADER.
     (let ((texinfo-post-header (plist-get info :texinfo-post-header)))
       (and texinfo-post-header
	    (org-element-normalize-string texinfo-post-header)))
     ;; Copying.
     (and copying
	  (format "@copying\n%s@end copying\n\n"
		  (org-element-normalize-string
		   (org-export-data copying info))))
     ;; Info directory information.  Only supply if both title and
     ;; category are provided.
     (let ((dircat (plist-get info :texinfo-dircat))
	   (dirtitle
	    (let ((title (plist-get info :texinfo-dirtitle)))
	      (and title
		   (string-match "^\\(?:\\* \\)?\\(.*?\\)\\(\\.\\)?$" title)
		   (format "* %s." (match-string 1 title))))))
       (when (and dircat dirtitle)
	 (concat "@dircategory " dircat "\n"
		 "@direntry\n"
		 (let ((dirdesc
			(let ((desc (plist-get info :texinfo-dirdesc)))
			  (cond ((not desc) nil)
				((org-string-match-p "\\.$" desc) desc)
				(t (concat desc "."))))))
		   (if dirdesc (format "%-23s %s" dirtitle dirdesc) dirtitle))
		 "\n"
		 "@end direntry\n\n")))
     ;; Title
     "@finalout\n"
     "@titlepage\n"
     (format "@title %s\n" (or (plist-get info :texinfo-printed-title) title))
     (let ((subtitle (plist-get info :subtitle)))
       (and subtitle
	    (org-element-normalize-string
	     (replace-regexp-in-string "^" "@subtitle " subtitle))))
     (when (plist-get info :with-author)
       (concat
	;; Primary author.
	(let ((author (org-string-nw-p
		       (org-export-data (plist-get info :author) info)))
	      (email (and (plist-get info :with-email)
			  (org-string-nw-p
			   (org-export-data (plist-get info :email) info)))))
	  (cond ((and author email)
		 (format "@author %s (@email{%s})\n" author email))
		(author (format "@author %s\n" author))
		(email (format "@author @email{%s}\n" email))))
	;; Other authors.
	(let ((subauthor (plist-get info :subauthor)))
	  (and subauthor
	       (org-element-normalize-string
		(replace-regexp-in-string "^" "@author " subauthor))))))
     (and copying "@page\n@vskip 0pt plus 1filll\n@insertcopying\n")
     "@end titlepage\n\n"
     ;; Table of contents.
     (and (plist-get info :with-toc) "@contents\n\n")
     ;; Configure Top Node when not for Tex
     "@ifnottex\n"
     "@node Top\n"
     (format "@top %s\n" title)
     (and copying "@insertcopying\n")
     "@end ifnottex\n\n"
     ;; Menu.
     (org-texinfo-make-menu (plist-get info :parse-tree) info 'master)
     "\n"
     ;; Document's body.
     contents "\n"
     ;; Creator.
     (case (plist-get info :with-creator)
       ((nil) nil)
       (comment (format "@c %s\n" (plist-get info :creator)))
       (otherwise (concat (plist-get info :creator) "\n")))
     ;; Document end.
     "@bye")))



;;; Transcode Functions

;;;; Bold

(defun org-texinfo-bold (bold contents info)
  "Transcode BOLD from Org to Texinfo.
CONTENTS is the text with bold markup.  INFO is a plist holding
contextual information."
  (org-texinfo--text-markup contents 'bold))

;;;; Center Block

(defun org-texinfo-center-block (center-block contents info)
  "Transcode a CENTER-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist used
as a communication channel."
  contents)

;;;; Clock

(defun org-texinfo-clock (clock contents info)
  "Transcode a CLOCK element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (concat
   "@noindent"
   (format "@strong{%s} " org-clock-string)
   (format org-texinfo-inactive-timestamp-format
	   (concat (org-translate-time
		    (org-element-property :raw-value
					  (org-element-property :value clock)))
		   (let ((time (org-element-property :duration clock)))
		     (and time (format " (%s)" time)))))
   "@*"))

;;;; Code

(defun org-texinfo-code (code contents info)
  "Transcode a CODE object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist used as a communication
channel."
  (org-texinfo--text-markup (org-element-property :value code) 'code))

;;;; Drawer

(defun org-texinfo-drawer (drawer contents info)
  "Transcode a DRAWER element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information."
  (let* ((name (org-element-property :drawer-name drawer))
	 (output (funcall org-texinfo-format-drawer-function
			  name contents)))
    output))

;;;; Dynamic Block

(defun org-texinfo-dynamic-block (dynamic-block contents info)
  "Transcode a DYNAMIC-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information."
  contents)

;;;; Entity

(defun org-texinfo-entity (entity contents info)
  "Transcode an ENTITY object from Org to Texinfo.
CONTENTS are the definition itself.  INFO is a plist holding
contextual information."
  (let ((ent (org-element-property :latex entity)))
    (if (org-element-property :latex-math-p entity) (format "@math{%s}" ent) ent)))

;;;; Example Block

(defun org-texinfo-example-block (example-block contents info)
  "Transcode an EXAMPLE-BLOCK element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (format "@verbatim\n%s@end verbatim"
	  (org-export-format-code-default example-block info)))

;;;; Export Block

(defun org-texinfo-export-block (export-block contents info)
  "Transcode a EXPORT-BLOCK element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (when (string= (org-element-property :type export-block) "TEXINFO")
    (org-remove-indentation (org-element-property :value export-block))))

;;;; Export Snippet

(defun org-texinfo-export-snippet (export-snippet contents info)
  "Transcode a EXPORT-SNIPPET object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (when (eq (org-export-snippet-backend export-snippet) 'texinfo)
    (org-element-property :value export-snippet)))

;;;; Fixed Width

(defun org-texinfo-fixed-width (fixed-width contents info)
  "Transcode a FIXED-WIDTH element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (format "@example\n%s\n@end example"
	  (org-remove-indentation
	   (org-texinfo--sanitize-content
	    (org-element-property :value fixed-width)))))

;;;; Footnote Reference

(defun org-texinfo-footnote-reference (footnote contents info)
  "Create a footnote reference for FOOTNOTE.

FOOTNOTE is the footnote to define.  CONTENTS is nil.  INFO is a
plist holding contextual information."
  (let ((def (org-export-get-footnote-definition footnote info)))
    (format "@footnote{%s}"
	    (org-trim (org-export-data def info)))))

;;;; Headline

(defun org-texinfo-headline (headline contents info)
  "Transcode a HEADLINE element from Org to Texinfo.
CONTENTS holds the contents of the headline.  INFO is a plist
holding contextual information."
  (let* ((class (plist-get info :texinfo-class))
	 (level (org-export-get-relative-level headline info))
	 (numberedp (org-export-numbered-headline-p headline info))
	 (class-sectioning (assoc class org-texinfo-classes))
	 ;; Find the index type, if any.
	 (index (org-element-property :INDEX headline))
	 ;; Create node info, to insert it before section formatting.
	 ;; Use custom menu title if present.
	 (node (format "@node %s\n" (org-texinfo--get-node headline info)))
	 ;; Section formatting will set two placeholders: one for the
	 ;; title and the other for the contents.
	 (section-fmt
	  (if (org-not-nil (org-element-property :APPENDIX headline))
	      "@appendix %s\n%s"
	    (let ((sec (if (and (symbolp (nth 2 class-sectioning))
				(fboundp (nth 2 class-sectioning)))
			   (funcall (nth 2 class-sectioning) level numberedp)
			 (nth (1+ level) class-sectioning))))
	      (cond
	       ;; No section available for that LEVEL.
	       ((not sec) nil)
	       ;; Section format directly returned by a function.
	       ((stringp sec) sec)
	       ;; (numbered-section . unnumbered-section)
	       ((not (consp (cdr sec)))
		(concat (if (or index (not numberedp)) (cdr sec) (car sec))
			"\n%s"))))))
	 (todo
	  (and (plist-get info :with-todo-keywords)
	       (let ((todo (org-element-property :todo-keyword headline)))
		 (and todo (org-export-data todo info)))))
	 (todo-type (and todo (org-element-property :todo-type headline)))
	 (tags (and (plist-get info :with-tags)
		    (org-export-get-tags headline info)))
	 (priority (and (plist-get info :with-priority)
			(org-element-property :priority headline)))
	 (text (org-export-data (org-element-property :title headline) info))
	 (full-text (if (not (eq org-texinfo-format-headline-function 'ignore))
			;; User-defined formatting function.
			(funcall org-texinfo-format-headline-function
				 todo todo-type priority text tags)
		      ;; Default formatting.
		      (concat
		       (when todo
			 (format "@strong{%s} " todo))
		       (when priority (format "@emph{#%s} " priority))
		       text
		       (when tags
			 (format " :%s:"
				 (mapconcat 'identity tags ":"))))))
	 (contents (if (org-string-nw-p contents) (concat "\n" contents) "")))
    (cond
     ;; Case 1: This is a footnote section: ignore it.
     ((org-element-property :footnote-section-p headline) nil)
     ;; Case 2: This is the `copying' section: ignore it
     ;;         This is used elsewhere.
     ((org-not-nil (org-element-property :COPYING headline)) nil)
     ;; Case 3: An index.  If it matches one of the known indexes,
     ;;         print it as such following the contents, otherwise
     ;;         print the contents and leave the index up to the user.
     (index
      (concat node
	      (format
	       section-fmt
	       full-text
	       (concat contents
		       (and (member index '("cp" "fn" "ky" "pg" "tp" "vr"))
			    (concat "\n@printindex " index))))))
     ;; Case 4: This is a deep sub-tree: export it as a list item.
     ;;         Also export as items headlines for which no section
     ;;         format has been found.
     ((or (not section-fmt) (org-export-low-level-p headline info))
      ;; Build the real contents of the sub-tree.
      (concat (and (org-export-first-sibling-p headline info)
		   (format "@%s\n" (if numberedp 'enumerate 'itemize)))
	      "@item\n" full-text "\n"
	      contents
	      (if (org-export-last-sibling-p headline info)
		  (format "@end %s" (if numberedp 'enumerate 'itemize))
		"\n")))
     ;; Case 5: Standard headline.  Export it as a section.
     (t (concat node (format section-fmt full-text contents))))))

;;;; Inline Src Block

(defun org-texinfo-inline-src-block (inline-src-block contents info)
  "Transcode an INLINE-SRC-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (let* ((code (org-element-property :value inline-src-block))
	 (separator (org-texinfo--find-verb-separator code)))
    (concat "@verb{" separator code separator "}")))

;;;; Inlinetask

(defun org-texinfo-inlinetask (inlinetask contents info)
  "Transcode an INLINETASK element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information."
  (let ((title (org-export-data (org-element-property :title inlinetask) info))
	(todo (and (plist-get info :with-todo-keywords)
		   (let ((todo (org-element-property :todo-keyword inlinetask)))
		     (and todo (org-export-data todo info)))))
	(todo-type (org-element-property :todo-type inlinetask))
	(tags (and (plist-get info :with-tags)
		   (org-export-get-tags inlinetask info)))
	(priority (and (plist-get info :with-priority)
		       (org-element-property :priority inlinetask))))
    ;; If `org-texinfo-format-inlinetask-function' is provided, call it
    ;; with appropriate arguments.
    (if (not (eq org-texinfo-format-inlinetask-function 'ignore))
	(funcall org-texinfo-format-inlinetask-function
		 todo todo-type priority title tags contents)
      ;; Otherwise, use a default template.
      (let ((full-title
	     (concat
	      (when todo (format "@strong{%s} " todo))
	      (when priority (format "#%c " priority))
	      title
	      (when tags (format ":%s:"
				 (mapconcat 'identity tags ":"))))))
	(format (concat "@center %s\n\n"
			"%s"
			"\n")
		full-title contents)))))

;;;; Italic

(defun org-texinfo-italic (italic contents info)
  "Transcode ITALIC from Org to Texinfo.
CONTENTS is the text with italic markup.  INFO is a plist holding
contextual information."
  (org-texinfo--text-markup contents 'italic))

;;;; Item

(defun org-texinfo-item (item contents info)
  "Transcode an ITEM element from Org to Texinfo.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (format "@item%s\n%s"
	  (let ((tag (org-element-property :tag item)))
	    (if tag (concat " " (org-export-data tag info)) ""))
	  (or contents "")))

;;;; Keyword

(defun org-texinfo-keyword (keyword contents info)
  "Transcode a KEYWORD element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (let ((key (org-element-property :key keyword))
	(value (org-element-property :value keyword)))
    (cond
     ((string= key "TEXINFO") value)
     ((string= key "CINDEX") (format "@cindex %s" value))
     ((string= key "FINDEX") (format "@findex %s" value))
     ((string= key "KINDEX") (format "@kindex %s" value))
     ((string= key "PINDEX") (format "@pindex %s" value))
     ((string= key "TINDEX") (format "@tindex %s" value))
     ((string= key "VINDEX") (format "@vindex %s" value)))))

;;;; Line Break

(defun org-texinfo-line-break (line-break contents info)
  "Transcode a LINE-BREAK object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  "@*\n")

;;;; Link

(defun org-texinfo-link (link desc info)
  "Transcode a LINK object from Org to Texinfo.

DESC is the description part of the link, or the empty string.
INFO is a plist holding contextual information.  See
`org-export-data'."
  (let* ((type (org-element-property :type link))
	 (raw-path (org-element-property :path link))
	 ;; Ensure DESC really exists, or set it to nil.
	 (desc (and (not (string= desc "")) desc))
	 (path (cond
		((member type '("http" "https" "ftp"))
		 (concat type ":" raw-path))
		((and (string= type "file") (file-name-absolute-p raw-path))
		 (concat "file:" raw-path))
		(t raw-path)))
	 protocol)
    (cond
     ((equal type "radio")
      (let ((destination (org-export-resolve-radio-link link info)))
	(if (not destination) desc
	  (format "@ref{%s,,%s}"
		  (org-texinfo--get-node destination info)
		  desc))))
     ((member type '("custom-id" "id" "fuzzy"))
      (let ((destination
	     (if (equal type "fuzzy")
		 (org-export-resolve-fuzzy-link link info)
	       (org-export-resolve-id-link link info))))
	(case (org-element-type destination)
	  ((nil)
	   (format org-texinfo-link-with-unknown-path-format
		   (org-texinfo--sanitize-content path)))
	  ;; Id link points to an external file.
	  (plain-text
	   (if desc (format "@uref{file://%s,%s}" destination desc)
	     (format "@uref{file://%s}" destination)))
	  (headline
	   (format "@ref{%s,%s}"
		   (org-texinfo--get-node destination info)
		   (cond
		    (desc)
		    ((org-export-numbered-headline-p destination info)
		     (org-export-data
		      (org-element-property :title destination) info))
		    (t
		     (mapconcat
		      #'number-to-string
		      (org-export-get-headline-number destination info) ".")))))
	  (otherwise
	   (let ((topic
		  (or desc
		      (if (and (eq (org-element-type destination) 'headline)
			       (not (org-export-numbered-headline-p
				     destination info)))
			  (org-export-data
			   (org-element-property :title destination) info))
		      (let ((n (org-export-get-ordinal destination info)))
			(cond
			 ((not n) nil)
			 ((integerp n) n)
			 (t (mapconcat #'number-to-string n ".")))))))
	     (when topic
	       (format "@ref{%s,,%s}"
		       (org-texinfo--get-node destination info)
		       topic)))))))
     ((equal type "info")
      (let* ((info-path (split-string path "[:#]"))
	     (info-manual (car info-path))
	     (info-node (or (cadr info-path) "top"))
	     (title (or desc "")))
	(format "@ref{%s,%s,,%s,}" info-node title info-manual)))
     ((string= type "mailto")
      (format "@email{%s}"
	      (concat (org-texinfo--sanitize-content path)
		      (and desc (concat "," desc)))))
     ((let ((protocol (nth 2 (assoc type org-link-protocols))))
	(and (functionp protocol)
	     (funcall protocol (org-link-unescape path) desc 'texinfo))))
     ;; External link with a description part.
     ((and path desc) (format "@uref{%s,%s}" path desc))
     ;; External link without a description part.
     (path (format "@uref{%s}" path))
     ;; No path, only description.  Try to do something useful.
     (t (format org-texinfo-link-with-unknown-path-format desc)))))


;;;; Menu

(defun org-texinfo-make-menu (scope info &optional master)
  "Create the menu for inclusion in the Texinfo document.

SCOPE is a headline or a full parse tree.  INFO is the
communication channel, as a plist.

When optional argument MASTER is non-nil, generate a master menu,
including detailed node listing."
  (let ((menu (org-texinfo--build-menu scope info)))
    (when (org-string-nw-p menu)
      (org-element-normalize-string
       (format
	"@menu\n%s@end menu"
	(concat menu
		(when master
		  (let ((detailmenu
			 (org-texinfo--build-menu
			  scope info
			  (let ((toc-depth (plist-get info :with-toc)))
			    (if (wholenump toc-depth) toc-depth
			      org-texinfo-max-toc-depth)))))
		    (when (org-string-nw-p detailmenu)
		      (concat "\n@detailmenu\n"
			      "--- The Detailed Node Listing ---\n\n"
			      detailmenu
			      "@end detailmenu\n"))))))))))

(defun org-texinfo--build-menu (scope info &optional level)
  "Build menu for entries within SCOPE.
SCOPE is a headline or a full parse tree.  INFO is a plist
containing contextual information.  When optional argument LEVEL
is an integer, build the menu recursively, down to this depth."
  (cond
   ((not level)
    (org-texinfo--format-entries (org-texinfo--menu-entries scope info) info))
   ((zerop level) nil)
   (t
    (org-element-normalize-string
     (mapconcat
      (lambda (h)
	(let ((entries (org-texinfo--menu-entries h info)))
	  (when entries
	    (concat
	     (format "%s\n\n%s\n"
		     (org-export-data (org-export-get-alt-title h info) info)
		     (org-texinfo--format-entries entries info))
	     (org-texinfo--build-menu h info (1- level))))))
      (org-texinfo--menu-entries scope info) "")))))

(defun org-texinfo--format-entries (entries info)
  "Format all direct menu entries in SCOPE, as a string.
SCOPE is either a headline or a full Org document.  INFO is
a plist containing contextual information."
  (org-element-normalize-string
   (mapconcat
    (lambda (h)
      (let* ((title (org-export-data
		     (org-export-get-alt-title h info) info))
	     (node (org-texinfo--get-node h info))
	     (entry (concat "* " title ":"
			    (if (string= title node) ":"
			      (concat " " node ". "))))
	     (desc (org-element-property :DESCRIPTION h)))
	(if (not desc) entry
	  (format (format "%%-%ds %%s" org-texinfo-node-description-column)
		  entry desc))))
    entries "\n")))

(defun org-texinfo--menu-entries (scope info)
  "List direct children in SCOPE needing a menu entry.
SCOPE is a headline or a full parse tree.  INFO is a plist
holding contextual information."
  (let* ((cache (or (plist-get info :texinfo-entries-cache)
		    (plist-get (plist-put info :texinfo-entries-cache
					  (make-hash-table :test #'eq))
			       :texinfo-entries-cache)))
	 (cached-entries (gethash scope cache 'no-cache)))
    (if (not (eq cached-entries 'no-cache)) cached-entries
      (puthash scope
	       (org-element-map (org-element-contents scope) 'headline
		 (lambda (h)
		   (and (not (org-not-nil (org-element-property :COPYING h)))
			(not (org-element-property :footnote-section-p h))
			(not (org-export-low-level-p h info))
			h))
		 info nil 'headline)
	       cache))))

;;;; Paragraph

(defun org-texinfo-paragraph (paragraph contents info)
  "Transcode a PARAGRAPH element from Org to Texinfo.
CONTENTS is the contents of the paragraph, as a string.  INFO is
the plist used as a communication channel."
  contents)

;;;; Plain List

(defun org-texinfo-plain-list (plain-list contents info)
  "Transcode a PLAIN-LIST element from Org to Texinfo.
CONTENTS is the contents of the list.  INFO is a plist holding
contextual information."
  (let* ((attr (org-export-read-attribute :attr_texinfo plain-list))
	 (indic (or (plist-get attr :indic) org-texinfo-def-table-markup))
	 (table-type (plist-get attr :table-type))
	 (type (org-element-property :type plain-list))
	 (list-type (cond
		     ((eq type 'ordered) "enumerate")
		     ((eq type 'unordered) "itemize")
		     ((member table-type '("ftable" "vtable")) table-type)
		     (t "table"))))
    (format "@%s\n%s@end %s"
	    (if (eq type 'descriptive) (concat list-type " " indic) list-type)
	    contents
	    list-type)))

;;;; Plain Text

(defun org-texinfo-plain-text (text info)
  "Transcode a TEXT string from Org to Texinfo.
TEXT is the string to transcode.  INFO is a plist holding
contextual information."
  ;; First protect @, { and }.
  (let ((output (org-texinfo--sanitize-content text)))
    ;; Activate smart quotes.  Be sure to provide original TEXT string
    ;; since OUTPUT may have been modified.
    (when (plist-get info :with-smart-quotes)
      (setq output
	    (org-export-activate-smart-quotes output :texinfo info text)))
    ;; LaTeX into @LaTeX{} and TeX into @TeX{}
    (let ((case-fold-search nil)
	  (start 0))
      (while (string-match "\\(\\(?:La\\)?TeX\\)" output start)
	(setq output (replace-match
		      (format "@%s{}" (match-string 1 output)) nil t output)
	      start (match-end 0))))
    ;; Convert special strings.
    (when (plist-get info :with-special-strings)
      (while (string-match (regexp-quote "...") output)
	(setq output (replace-match "@dots{}" nil t output))))
    ;; Handle break preservation if required.
    (when (plist-get info :preserve-breaks)
      (setq output (replace-regexp-in-string
		    "\\(\\\\\\\\\\)?[ \t]*\n" " @*\n" output)))
    ;; Return value.
    output))

;;;; Planning

(defun org-texinfo-planning (planning contents info)
  "Transcode a PLANNING element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (concat
   "@noindent"
   (mapconcat
    'identity
    (delq nil
	  (list
	   (let ((closed (org-element-property :closed planning)))
	     (when closed
	       (concat
		(format "@strong{%s} " org-closed-string)
		(format org-texinfo-inactive-timestamp-format
			(org-translate-time
			 (org-element-property :raw-value closed))))))
	   (let ((deadline (org-element-property :deadline planning)))
	     (when deadline
	       (concat
		(format "@strong{%s} " org-deadline-string)
		(format org-texinfo-active-timestamp-format
			(org-translate-time
			 (org-element-property :raw-value deadline))))))
	   (let ((scheduled (org-element-property :scheduled planning)))
	     (when scheduled
	       (concat
		(format "@strong{%s} " org-scheduled-string)
		(format org-texinfo-active-timestamp-format
			(org-translate-time
			 (org-element-property :raw-value scheduled))))))))
    " ")
   "@*"))

;;;; Property Drawer

(defun org-texinfo-property-drawer (property-drawer contents info)
  "Transcode a PROPERTY-DRAWER element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  ;; The property drawer isn't exported but we want separating blank
  ;; lines nonetheless.
  "")

;;;; Quote Block

(defun org-texinfo-quote-block (quote-block contents info)
  "Transcode a QUOTE-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist
holding contextual information."
  (let* ((title (org-element-property :name quote-block))
	 (start-quote (concat "@quotation"
			      (if title
				  (format " %s" title)))))
    (format "%s\n%s@end quotation" start-quote contents)))

;;;; Quote Section

(defun org-texinfo-quote-section (quote-section contents info)
  "Transcode a QUOTE-SECTION element from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (let ((value (org-remove-indentation
		(org-element-property :value quote-section))))
    (when value (format "@verbatim\n%s@end verbatim" value))))

;;;; Radio Target

(defun org-texinfo-radio-target (radio-target text info)
  "Transcode a RADIO-TARGET object from Org to Texinfo.
TEXT is the text of the target.  INFO is a plist holding
contextual information."
  (format "@anchor{%s}%s"
	  (org-export-solidify-link-text
	   (org-element-property :value radio-target))
	  text))

;;;; Section

(defun org-texinfo-section (section contents info)
  "Transcode a SECTION element from Org to Texinfo.
CONTENTS holds the contents of the section.  INFO is a plist
holding contextual information."
  (concat contents
	  (let ((parent (org-export-get-parent-headline section)))
	    (and parent (org-texinfo-make-menu parent info)))))

;;;; Special Block

(defun org-texinfo-special-block (special-block contents info)
  "Transcode a SPECIAL-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the block.  INFO is a plist used
as a communication channel."
  contents)

;;;; Src Block

(defun org-texinfo-src-block (src-block contents info)
  "Transcode a SRC-BLOCK element from Org to Texinfo.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (let ((lispp (org-string-match-p "lisp"
				   (org-element-property :language src-block)))
	(code (org-texinfo--sanitize-content
	       (org-export-format-code-default src-block info))))
    (format (if lispp "@lisp\n%s@end lisp" "@example\n%s@end example") code)))

;;;; Statistics Cookie

(defun org-texinfo-statistics-cookie (statistics-cookie contents info)
  "Transcode a STATISTICS-COOKIE object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual information."
  (org-element-property :value statistics-cookie))

;;;; Subscript

(defun org-texinfo-subscript (subscript contents info)
  "Transcode a SUBSCRIPT object from Org to Texinfo.
CONTENTS is the contents of the object.  INFO is a plist holding
contextual information."
  (format "@math{_%s}" contents))

;;;; Superscript

(defun org-texinfo-superscript (superscript contents info)
  "Transcode a SUPERSCRIPT object from Org to Texinfo.
CONTENTS is the contents of the object.  INFO is a plist holding
contextual information."
  (format "@math{^%s}" contents))

;;;; Table

(defun org-texinfo-table (table contents info)
  "Transcode a TABLE element from Org to Texinfo.
CONTENTS is the contents of the table.  INFO is a plist holding
contextual information."
  (if (eq (org-element-property :type table) 'table.el)
      (format "@verbatim\n%s@end verbatim"
	      (org-element-normalize-string
	       (org-element-property :value table)))
    (let* ((col-width (org-export-read-attribute :attr_texinfo table :columns))
	   (columns
	    (if col-width (format "@columnfractions %s" col-width)
	      (org-texinfo-table-column-widths table info))))
      (format "@multitable %s\n%s@end multitable"
	      columns
	      contents))))

(defun org-texinfo-table-column-widths (table info)
  "Determine the largest table cell in each column to process alignment.
TABLE is the table element to transcode.  INFO is a plist used as
a communication channel."
  (let ((widths (make-vector (cdr (org-export-table-dimensions table info)) 0)))
    (org-element-map table 'table-row
      (lambda (row)
	(let ((idx 0))
	  (org-element-map row 'table-cell
	    (lambda (cell)
	      ;; Length of the cell in the original buffer is only an
	      ;; approximation of the length of the cell in the
	      ;; output.  It can sometimes fail (e.g. it considers
	      ;; "/a/" being larger than "ab").
	      (let ((w (- (org-element-property :contents-end cell)
			  (org-element-property :contents-begin cell))))
		(aset widths idx (max w (aref widths idx))))
	      (incf idx))
	    info)))
      info)
    (format "{%s}" (mapconcat (lambda (w) (make-string w ?a)) widths "} {"))))

;;;; Table Cell

(defun org-texinfo-table-cell (table-cell contents info)
  "Transcode a TABLE-CELL element from Org to Texinfo.
CONTENTS is the cell contents.  INFO is a plist used as
a communication channel."
  (concat (if (and contents
		   org-texinfo-table-scientific-notation
		   (string-match orgtbl-exp-regexp contents))
	      ;; Use appropriate format string for scientific
	      ;; notation.
	      (format org-texinfo-table-scientific-notation
		      (match-string 1 contents)
		      (match-string 2 contents))
	    contents)
	  (when (org-export-get-next-element table-cell info) "\n@tab ")))

;;;; Table Row

(defun org-texinfo-table-row (table-row contents info)
  "Transcode a TABLE-ROW element from Org to Texinfo.
CONTENTS is the contents of the row.  INFO is a plist used as
a communication channel."
  ;; Rules are ignored since table separators are deduced from
  ;; borders of the current row.
  (when (eq (org-element-property :type table-row) 'standard)
    (let ((rowgroup-tag
	   (if (and (= 1 (org-export-table-row-group table-row info))
		    (org-export-table-has-header-p
		     (org-export-get-parent-table table-row) info))
	       "@headitem "
	     "@item ")))
      (concat rowgroup-tag contents "\n"))))

;;;; Target

(defun org-texinfo-target (target contents info)
  "Transcode a TARGET object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (format "@anchor{%s}"
	  (org-export-solidify-link-text (org-element-property :value target))))

;;;; Timestamp

(defun org-texinfo-timestamp (timestamp contents info)
  "Transcode a TIMESTAMP object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (let ((value (org-texinfo-plain-text
		(org-timestamp-translate timestamp) info)))
    (case (org-element-property :type timestamp)
      ((active active-range)
       (format org-texinfo-active-timestamp-format value))
      ((inactive inactive-range)
       (format org-texinfo-inactive-timestamp-format value))
      (t (format org-texinfo-diary-timestamp-format value)))))

;;;; Verbatim

(defun org-texinfo-verbatim (verbatim contents info)
  "Transcode a VERBATIM object from Org to Texinfo.
CONTENTS is nil.  INFO is a plist used as a communication
channel."
  (org-texinfo--text-markup (org-element-property :value verbatim) 'verbatim))

;;;; Verse Block

(defun org-texinfo-verse-block (verse-block contents info)
  "Transcode a VERSE-BLOCK element from Org to Texinfo.
CONTENTS is verse block contents. INFO is a plist holding
contextual information."
  (format "@display\n%s@end display" contents))


;;; Interactive functions

(defun org-texinfo-export-to-texinfo
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a Texinfo file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\begin{document}\" and \"\\end{document}\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Return output file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".texi" subtreep))
	(org-export-coding-system `,org-texinfo-coding-system))
    (org-export-to-file 'texinfo outfile
      async subtreep visible-only body-only ext-plist)))

(defun org-texinfo-export-to-info
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to Texinfo then process through to INFO.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"\\begin{document}\" and \"\\end{document}\".

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

When optional argument PUB-DIR is set, use it as the publishing
directory.

Return INFO file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".texi" subtreep))
	(org-export-coding-system `,org-texinfo-coding-system))
    (org-export-to-file 'texinfo outfile
      async subtreep visible-only body-only ext-plist
      (lambda (file) (org-texinfo-compile file)))))

;;;###autoload
(defun org-texinfo-publish-to-texinfo (plist filename pub-dir)
  "Publish an org file to Texinfo.

FILENAME is the filename of the Org file to be published.  PLIST
is the property list for the given project.  PUB-DIR is the
publishing directory.

Return output file name."
  (org-publish-org-to 'texinfo filename ".texi" plist pub-dir))

;;;###autoload
(defun org-texinfo-convert-region-to-texinfo ()
  "Assume the current region has org-mode syntax, and convert it to Texinfo.
This can be used in any buffer.  For example, you can write an
itemized list in org-mode syntax in an Texinfo buffer and use
this command to convert it."
  (interactive)
  (org-export-replace-region-by 'texinfo))

(defun org-texinfo-compile (file)
  "Compile a texinfo file.

FILE is the name of the file being compiled.  Processing is
done through the command specified in `org-texinfo-info-process'.

Return INFO file name or an error if it couldn't be produced."
  (let* ((base-name (file-name-sans-extension (file-name-nondirectory file)))
	 (full-name (file-truename file))
	 (out-dir (file-name-directory file))
	 ;; Properly set working directory for compilation.
	 (default-directory (if (file-name-absolute-p file)
				(file-name-directory full-name)
			      default-directory))
	 errors)
    (message (format "Processing Texinfo file %s..." file))
    (save-window-excursion
      ;; Replace %b, %f and %o with appropriate values in each command
      ;; before applying it.  Output is redirected to "*Org INFO
      ;; Texinfo Output*" buffer.
      (let ((outbuf (get-buffer-create "*Org INFO Texinfo Output*")))
	(dolist (command org-texinfo-info-process)
	  (shell-command
	   (replace-regexp-in-string
	    "%b" (shell-quote-argument base-name)
	    (replace-regexp-in-string
	     "%f" (shell-quote-argument full-name)
	     (replace-regexp-in-string
	      "%o" (shell-quote-argument out-dir) command t t) t t) t t)
	   outbuf))
	;; Collect standard errors from output buffer.
	(setq errors (org-texinfo-collect-errors outbuf)))
      (let ((infofile (concat out-dir base-name ".info")))
	;; Check for process failure.  Provide collected errors if
	;; possible.
	(if (not (file-exists-p infofile))
	    (error (concat (format "INFO file %s wasn't produced" infofile)
			   (when errors (concat ": " errors))))
	  ;; Else remove log files, when specified, and signal end of
	  ;; process to user, along with any error encountered.
	  (when org-texinfo-remove-logfiles
	    (dolist (ext org-texinfo-logfiles-extensions)
	      (let ((file (concat out-dir base-name "." ext)))
		(when (file-exists-p file) (delete-file file)))))
	  (message (concat "Process completed"
			   (if (not errors) "."
			     (concat " with errors: " errors)))))
	;; Return output file name.
	infofile))))

(defun org-texinfo-collect-errors (buffer)
  "Collect some kind of errors from \"makeinfo\" command output.

BUFFER is the buffer containing output.

Return collected error types as a string, or nil if there was
none."
  (with-current-buffer buffer
    (save-excursion
      (goto-char (point-min))
      ;; Find final "makeinfo" run.
      (when t
	(let ((case-fold-search t)
	      (errors ""))
	  (when (save-excursion
		  (re-search-forward "perhaps incorrect sectioning?" nil t))
	    (setq errors (concat errors " [incorrect sectioning]")))
	  (when (save-excursion
		  (re-search-forward "missing close brace" nil t))
	    (setq errors (concat errors " [syntax error]")))
	  (when (save-excursion
		  (re-search-forward "Unknown command" nil t))
	    (setq errors (concat errors " [undefined @command]")))
	  (when (save-excursion
		  (re-search-forward "No matching @end" nil t))
	    (setq errors (concat errors " [block incomplete]")))
	  (when (save-excursion
		  (re-search-forward "requires a sectioning" nil t))
	    (setq errors (concat errors " [invalid section command]")))
	  (when (save-excursion
		  (re-search-forward "\\[unexpected\]" nil t))
	    (setq errors (concat errors " [unexpected error]")))
	  (when (save-excursion
		  (re-search-forward "misplaced " nil t))
	    (setq errors (concat errors " [syntax error]")))
	  (and (org-string-nw-p errors) (org-trim errors)))))))


(provide 'ox-texinfo)

;; Local variables:
;; generated-autoload-file: "org-loaddefs.el"
;; End:

;;; ox-texinfo.el ends here
