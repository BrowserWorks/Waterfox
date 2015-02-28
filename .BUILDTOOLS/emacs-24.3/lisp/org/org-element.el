;;; org-element.el --- Parser And Applications for Org syntax

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Nicolas Goaziou <n.goaziou at gmail dot com>
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
;; Org syntax can be divided into three categories: "Greater
;; elements", "Elements" and "Objects".
;;
;; Elements are related to the structure of the document.  Indeed, all
;; elements are a cover for the document: each position within belongs
;; to at least one element.
;;
;; An element always starts and ends at the beginning of a line.  With
;; a few exceptions (namely `babel-call', `clock', `headline', `item',
;; `keyword', `planning', `property-drawer' and `section' types), it
;; can also accept a fixed set of keywords as attributes.  Those are
;; called "affiliated keywords" to distinguish them from other
;; keywords, which are full-fledged elements.  Almost all affiliated
;; keywords are referenced in `org-element-affiliated-keywords'; the
;; others are export attributes and start with "ATTR_" prefix.
;;
;; Element containing other elements (and only elements) are called
;; greater elements.  Concerned types are: `center-block', `drawer',
;; `dynamic-block', `footnote-definition', `headline', `inlinetask',
;; `item', `plain-list', `quote-block', `section' and `special-block'.
;;
;; Other element types are: `babel-call', `clock', `comment',
;; `comment-block', `example-block', `export-block', `fixed-width',
;; `horizontal-rule', `keyword', `latex-environment', `paragraph',
;; `planning', `property-drawer', `quote-section', `src-block',
;; `table', `table-row' and `verse-block'.  Among them, `paragraph'
;; and `verse-block' types can contain Org objects and plain text.
;;
;; Objects are related to document's contents.  Some of them are
;; recursive.  Associated types are of the following: `bold', `code',
;; `entity', `export-snippet', `footnote-reference',
;; `inline-babel-call', `inline-src-block', `italic',
;; `latex-fragment', `line-break', `link', `macro', `radio-target',
;; `statistics-cookie', `strike-through', `subscript', `superscript',
;; `table-cell', `target', `timestamp', `underline' and `verbatim'.
;;
;; Some elements also have special properties whose value can hold
;; objects themselves (i.e. an item tag or an headline name).  Such
;; values are called "secondary strings".  Any object belongs to
;; either an element or a secondary string.
;;
;; Notwithstanding affiliated keywords, each greater element, element
;; and object has a fixed set of properties attached to it.  Among
;; them, four are shared by all types: `:begin' and `:end', which
;; refer to the beginning and ending buffer positions of the
;; considered element or object, `:post-blank', which holds the number
;; of blank lines, or white spaces, at its end and `:parent' which
;; refers to the element or object containing it.  Greater elements
;; and elements containing objects will also have `:contents-begin'
;; and `:contents-end' properties to delimit contents.
;;
;; Lisp-wise, an element or an object can be represented as a list.
;; It follows the pattern (TYPE PROPERTIES CONTENTS), where:
;;   TYPE is a symbol describing the Org element or object.
;;   PROPERTIES is the property list attached to it.  See docstring of
;;              appropriate parsing function to get an exhaustive
;;              list.
;;   CONTENTS is a list of elements, objects or raw strings contained
;;            in the current element or object, when applicable.
;;
;; An Org buffer is a nested list of such elements and objects, whose
;; type is `org-data' and properties is nil.
;;
;; The first part of this file defines Org syntax, while the second
;; one provide accessors and setters functions.
;;
;; The next part implements a parser and an interpreter for each
;; element and object type in Org syntax.
;;
;; The following part creates a fully recursive buffer parser.  It
;; also provides a tool to map a function to elements or objects
;; matching some criteria in the parse tree.  Functions of interest
;; are `org-element-parse-buffer', `org-element-map' and, to a lesser
;; extent, `org-element-parse-secondary-string'.
;;
;; The penultimate part is the cradle of an interpreter for the
;; obtained parse tree: `org-element-interpret-data'.
;;
;; The library ends by furnishing `org-element-at-point' function, and
;; a way to give information about document structure around point
;; with `org-element-context'.


;;; Code:

(eval-when-compile
  (require 'cl))

(require 'org)


;;; Definitions And Rules
;;
;; Define elements, greater elements and specify recursive objects,
;; along with the affiliated keywords recognized.  Also set up
;; restrictions on recursive objects combinations.
;;
;; These variables really act as a control center for the parsing
;; process.

(defconst org-element-paragraph-separate
  (concat "^\\(?:"
          ;; Headlines, inlinetasks.
          org-outline-regexp "\\|"
          ;; Footnote definitions.
	  "\\[\\(?:[0-9]+\\|fn:[-_[:word:]]+\\)\\]" "\\|"
          "[ \t]*\\(?:"
          ;; Empty lines.
          "$" "\\|"
	  ;; Tables (any type).
	  "\\(?:|\\|\\+-[-+]\\)" "\\|"
          ;; Blocks (any type), Babel calls, drawers (any type),
	  ;; fixed-width areas and keywords.  Note: this is only an
	  ;; indication and need some thorough check.
          "[#:]" "\\|"
          ;; Horizontal rules.
          "-\\{5,\\}[ \t]*$" "\\|"
          ;; LaTeX environments.
          "\\\\begin{\\([A-Za-z0-9]+\\*?\\)}" "\\|"
          ;; Planning and Clock lines.
          (regexp-opt (list org-scheduled-string
                            org-deadline-string
                            org-closed-string
                            org-clock-string))
          "\\|"
          ;; Lists.
          (let ((term (case org-plain-list-ordered-item-terminator
                        (?\) ")") (?. "\\.") (otherwise "[.)]")))
                (alpha (and org-alphabetical-lists "\\|[A-Za-z]")))
            (concat "\\(?:[-+*]\\|\\(?:[0-9]+" alpha "\\)" term "\\)"
                    "\\(?:[ \t]\\|$\\)"))
          "\\)\\)")
  "Regexp to separate paragraphs in an Org buffer.
In the case of lines starting with \"#\" and \":\", this regexp
is not sufficient to know if point is at a paragraph ending.  See
`org-element-paragraph-parser' for more information.")

(defconst org-element-all-elements
  '(center-block clock comment comment-block drawer dynamic-block example-block
		 export-block fixed-width footnote-definition headline
		 horizontal-rule inlinetask item keyword latex-environment
		 babel-call paragraph plain-list planning property-drawer
		 quote-block quote-section section special-block src-block table
		 table-row verse-block)
  "Complete list of element types.")

(defconst org-element-greater-elements
  '(center-block drawer dynamic-block footnote-definition headline inlinetask
		 item plain-list quote-block section special-block table)
  "List of recursive element types aka Greater Elements.")

(defconst org-element-all-successors
  '(export-snippet footnote-reference inline-babel-call inline-src-block
		   latex-or-entity line-break link macro radio-target
		   statistics-cookie sub/superscript table-cell target
		   text-markup timestamp)
  "Complete list of successors.")

(defconst org-element-object-successor-alist
  '((subscript . sub/superscript) (superscript . sub/superscript)
    (bold . text-markup) (code . text-markup) (italic . text-markup)
    (strike-through . text-markup) (underline . text-markup)
    (verbatim . text-markup) (entity . latex-or-entity)
    (latex-fragment . latex-or-entity))
  "Alist of translations between object type and successor name.

Sharing the same successor comes handy when, for example, the
regexp matching one object can also match the other object.")

(defconst org-element-all-objects
  '(bold code entity export-snippet footnote-reference inline-babel-call
	 inline-src-block italic line-break latex-fragment link macro
	 radio-target statistics-cookie strike-through subscript superscript
	 table-cell target timestamp underline verbatim)
  "Complete list of object types.")

(defconst org-element-recursive-objects
  '(bold italic link macro subscript radio-target strike-through superscript
	 table-cell underline)
  "List of recursive object types.")

(defconst org-element-block-name-alist
  '(("CENTER" . org-element-center-block-parser)
    ("COMMENT" . org-element-comment-block-parser)
    ("EXAMPLE" . org-element-example-block-parser)
    ("QUOTE" . org-element-quote-block-parser)
    ("SRC" . org-element-src-block-parser)
    ("VERSE" . org-element-verse-block-parser))
  "Alist between block names and the associated parsing function.
Names must be uppercase.  Any block whose name has no association
is parsed with `org-element-special-block-parser'.")

(defconst org-element-affiliated-keywords
  '("CAPTION" "DATA" "HEADER" "HEADERS" "LABEL" "NAME" "PLOT" "RESNAME" "RESULT"
    "RESULTS" "SOURCE" "SRCNAME" "TBLNAME")
  "List of affiliated keywords as strings.
By default, all keywords setting attributes (i.e. \"ATTR_LATEX\")
are affiliated keywords and need not to be in this list.")

(defconst org-element--affiliated-re
  (format "[ \t]*#\\+%s:"
	  ;; Regular affiliated keywords.
	  (format "\\(%s\\|ATTR_[-_A-Za-z0-9]+\\)\\(?:\\[\\(.*\\)\\]\\)?"
		  (regexp-opt org-element-affiliated-keywords)))
  "Regexp matching any affiliated keyword.

Keyword name is put in match group 1.  Moreover, if keyword
belongs to `org-element-dual-keywords', put the dual value in
match group 2.

Don't modify it, set `org-element-affiliated-keywords' instead.")

(defconst org-element-keyword-translation-alist
  '(("DATA" . "NAME")  ("LABEL" . "NAME") ("RESNAME" . "NAME")
    ("SOURCE" . "NAME") ("SRCNAME" . "NAME") ("TBLNAME" . "NAME")
    ("RESULT" . "RESULTS") ("HEADERS" . "HEADER"))
  "Alist of usual translations for keywords.
The key is the old name and the value the new one.  The property
holding their value will be named after the translated name.")

(defconst org-element-multiple-keywords '("HEADER")
  "List of affiliated keywords that can occur more that once in an element.

Their value will be consed into a list of strings, which will be
returned as the value of the property.

This list is checked after translations have been applied.  See
`org-element-keyword-translation-alist'.

By default, all keywords setting attributes (i.e. \"ATTR_LATEX\")
allow multiple occurrences and need not to be in this list.")

(defconst org-element-parsed-keywords '("AUTHOR" "CAPTION" "DATE" "TITLE")
  "List of keywords whose value can be parsed.

Their value will be stored as a secondary string: a list of
strings and objects.

This list is checked after translations have been applied.  See
`org-element-keyword-translation-alist'.")

(defconst org-element-dual-keywords '("CAPTION" "RESULTS")
  "List of keywords which can have a secondary value.

In Org syntax, they can be written with optional square brackets
before the colons.  For example, results keyword can be
associated to a hash value with the following:

  #+RESULTS[hash-string]: some-source

This list is checked after translations have been applied.  See
`org-element-keyword-translation-alist'.")

(defconst org-element-object-restrictions
  '((bold export-snippet inline-babel-call inline-src-block latex-or-entity link
	  radio-target sub/superscript target text-markup timestamp)
    (footnote-reference export-snippet footnote-reference inline-babel-call
			inline-src-block latex-or-entity line-break link macro
			radio-target sub/superscript target text-markup
			timestamp)
    (headline inline-babel-call inline-src-block latex-or-entity link macro
	      radio-target statistics-cookie sub/superscript target text-markup
	      timestamp)
    (inlinetask inline-babel-call inline-src-block latex-or-entity link macro
		radio-target sub/superscript target text-markup timestamp)
    (italic export-snippet inline-babel-call inline-src-block latex-or-entity
	    link radio-target sub/superscript target text-markup timestamp)
    (item export-snippet footnote-reference inline-babel-call latex-or-entity
	  link macro radio-target sub/superscript target text-markup)
    (keyword latex-or-entity macro sub/superscript text-markup)
    (link export-snippet inline-babel-call inline-src-block latex-or-entity link
	  sub/superscript text-markup)
    (macro macro)
    (paragraph export-snippet footnote-reference inline-babel-call
	       inline-src-block latex-or-entity line-break link macro
	       radio-target statistics-cookie sub/superscript target text-markup
	       timestamp)
    (radio-target export-snippet latex-or-entity sub/superscript)
    (strike-through export-snippet inline-babel-call inline-src-block
		    latex-or-entity link radio-target sub/superscript target
		    text-markup timestamp)
    (subscript export-snippet inline-babel-call inline-src-block latex-or-entity
	       sub/superscript target text-markup)
    (superscript export-snippet inline-babel-call inline-src-block
		 latex-or-entity sub/superscript target text-markup)
    (table-cell export-snippet latex-or-entity link macro radio-target
		sub/superscript target text-markup timestamp)
    (table-row table-cell)
    (underline export-snippet inline-babel-call inline-src-block latex-or-entity
	       link radio-target sub/superscript target text-markup timestamp)
    (verse-block footnote-reference inline-babel-call inline-src-block
		 latex-or-entity line-break link macro radio-target
		 sub/superscript target text-markup timestamp))
  "Alist of objects restrictions.

CAR is an element or object type containing objects and CDR is
a list of successors that will be called within an element or
object of such type.

For example, in a `radio-target' object, one can only find
entities, export snippets, latex-fragments, subscript and
superscript.

This alist also applies to secondary string.  For example, an
`headline' type element doesn't directly contain objects, but
still has an entry since one of its properties (`:title') does.")

(defconst org-element-secondary-value-alist
  '((headline . :title)
    (inlinetask . :title)
    (item . :tag)
    (footnote-reference . :inline-definition))
  "Alist between element types and location of secondary value.")



;;; Accessors and Setters
;;
;; Provide four accessors: `org-element-type', `org-element-property'
;; `org-element-contents' and `org-element-restriction'.
;;
;; Setter functions allow to modify elements by side effect.  There is
;; `org-element-put-property', `org-element-set-contents',
;; `org-element-set-element' and `org-element-adopt-element'.  Note
;; that `org-element-set-element' and `org-element-adopt-elements' are
;; higher level functions since also update `:parent' property.

(defsubst org-element-type (element)
  "Return type of ELEMENT.

The function returns the type of the element or object provided.
It can also return the following special value:
  `plain-text'       for a string
  `org-data'         for a complete document
  nil                in any other case."
  (cond
   ((not (consp element)) (and (stringp element) 'plain-text))
   ((symbolp (car element)) (car element))))

(defsubst org-element-property (property element)
  "Extract the value from the PROPERTY of an ELEMENT."
  (plist-get (nth 1 element) property))

(defsubst org-element-contents (element)
  "Extract contents from an ELEMENT."
  (and (consp element) (nthcdr 2 element)))

(defsubst org-element-restriction (element)
  "Return restriction associated to ELEMENT.
ELEMENT can be an element, an object or a symbol representing an
element or object type."
  (cdr (assq (if (symbolp element) element (org-element-type element))
	     org-element-object-restrictions)))

(defsubst org-element-put-property (element property value)
  "In ELEMENT set PROPERTY to VALUE.
Return modified element."
  (when (consp element)
    (setcar (cdr element) (plist-put (nth 1 element) property value)))
  element)

(defsubst org-element-set-contents (element &rest contents)
  "Set ELEMENT contents to CONTENTS.
Return modified element."
  (cond ((not element) (list contents))
	((cdr element) (setcdr (cdr element) contents))
	(t (nconc element contents))))

(defsubst org-element-set-element (old new)
  "Replace element or object OLD with element or object NEW.
The function takes care of setting `:parent' property for NEW."
  ;; Since OLD is going to be changed into NEW by side-effect, first
  ;; make sure that every element or object within NEW has OLD as
  ;; parent.
  (mapc (lambda (blob) (org-element-put-property blob :parent old))
	(org-element-contents new))
  ;; Transfer contents.
  (apply 'org-element-set-contents old (org-element-contents new))
  ;; Ensure NEW has same parent as OLD, then overwrite OLD properties
  ;; with NEW's.
  (org-element-put-property new :parent (org-element-property :parent old))
  (setcar (cdr old) (nth 1 new))
  ;; Transfer type.
  (setcar old (car new)))

(defsubst org-element-adopt-elements (parent &rest children)
  "Append elements to the contents of another element.

PARENT is an element or object.  CHILDREN can be elements,
objects, or a strings.

The function takes care of setting `:parent' property for CHILD.
Return parent element."
  (if (not parent) children
    ;; Link every child to PARENT.
    (mapc (lambda (child)
	    (unless (stringp child)
	      (org-element-put-property child :parent parent)))
	  children)
    ;; Add CHILDREN at the end of PARENT contents.
    (apply 'org-element-set-contents
	   parent
	   (nconc (org-element-contents parent) children))
    ;; Return modified PARENT element.
    parent))



;;; Greater elements
;;
;; For each greater element type, we define a parser and an
;; interpreter.
;;
;; A parser returns the element or object as the list described above.
;; Most of them accepts no argument.  Though, exceptions exist.  Hence
;; every element containing a secondary string (see
;; `org-element-secondary-value-alist') will accept an optional
;; argument to toggle parsing of that secondary string.  Moreover,
;; `item' parser requires current list's structure as its first
;; element.
;;
;; An interpreter accepts two arguments: the list representation of
;; the element or object, and its contents.  The latter may be nil,
;; depending on the element or object considered.  It returns the
;; appropriate Org syntax, as a string.
;;
;; Parsing functions must follow the naming convention:
;; org-element-TYPE-parser, where TYPE is greater element's type, as
;; defined in `org-element-greater-elements'.
;;
;; Similarly, interpreting functions must follow the naming
;; convention: org-element-TYPE-interpreter.
;;
;; With the exception of `headline' and `item' types, greater elements
;; cannot contain other greater elements of their own type.
;;
;; Beside implementing a parser and an interpreter, adding a new
;; greater element requires to tweak `org-element--current-element'.
;; Moreover, the newly defined type must be added to both
;; `org-element-all-elements' and `org-element-greater-elements'.


;;;; Center Block

(defun org-element-center-block-parser (limit)
  "Parse a center block.

LIMIT bounds the search.

Return a list whose CAR is `center-block' and CDR is a plist
containing `:begin', `:end', `:hiddenp', `:contents-begin',
`:contents-end' and `:post-blank' keywords.

Assume point is at the beginning of the block."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END_CENTER[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((block-end-line (match-beginning 0)))
	(let* ((keywords (org-element--collect-affiliated-keywords))
	       (begin (car keywords))
	       ;; Empty blocks have no contents.
	       (contents-begin (progn (forward-line)
				      (and (< (point) block-end-line)
					   (point))))
	       (contents-end (and contents-begin block-end-line))
	       (hidden (org-invisible-p2))
	       (pos-before-blank (progn (goto-char block-end-line)
					(forward-line)
					(point)))
	       (end (save-excursion (skip-chars-forward " \r\t\n" limit)
				    (skip-chars-backward " \t")
				    (if (bolp) (point) (line-end-position)))))
	  (list 'center-block
		(nconc
		 (list :begin begin
		       :end end
		       :hiddenp hidden
		       :contents-begin contents-begin
		       :contents-end contents-end
		       :post-blank (count-lines pos-before-blank end))
		 (cadr keywords))))))))

(defun org-element-center-block-interpreter (center-block contents)
  "Interpret CENTER-BLOCK element as Org syntax.
CONTENTS is the contents of the element."
  (format "#+BEGIN_CENTER\n%s#+END_CENTER" contents))


;;;; Drawer

(defun org-element-drawer-parser (limit)
  "Parse a drawer.

LIMIT bounds the search.

Return a list whose CAR is `drawer' and CDR is a plist containing
`:drawer-name', `:begin', `:end', `:hiddenp', `:contents-begin',
`:contents-end' and `:post-blank' keywords.

Assume point is at beginning of drawer."
  (let ((case-fold-search t))
    (if (not (save-excursion (re-search-forward "^[ \t]*:END:[ \t]*$" limit t)))
	;; Incomplete drawer: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((drawer-end-line (match-beginning 0)))
	(save-excursion
	  (let* ((case-fold-search t)
		 (name (progn (looking-at org-drawer-regexp)
			      (org-match-string-no-properties 1)))
		 (keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 ;; Empty drawers have no contents.
		 (contents-begin (progn (forward-line)
					(and (< (point) drawer-end-line)
					     (point))))
		 (contents-end (and contents-begin drawer-end-line))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char drawer-end-line)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'drawer
		  (nconc
		   (list :begin begin
			 :end end
			 :drawer-name name
			 :hiddenp hidden
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-drawer-interpreter (drawer contents)
  "Interpret DRAWER element as Org syntax.
CONTENTS is the contents of the element."
  (format ":%s:\n%s:END:"
	  (org-element-property :drawer-name drawer)
	  contents))


;;;; Dynamic Block

(defun org-element-dynamic-block-parser (limit)
  "Parse a dynamic block.

LIMIT bounds the search.

Return a list whose CAR is `dynamic-block' and CDR is a plist
containing `:block-name', `:begin', `:end', `:hiddenp',
`:contents-begin', `:contents-end', `:arguments' and
`:post-blank' keywords.

Assume point is at beginning of dynamic block."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END:?[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((block-end-line (match-beginning 0)))
	(save-excursion
	  (let* ((name (progn (looking-at org-dblock-start-re)
			      (org-match-string-no-properties 1)))
		 (arguments (org-match-string-no-properties 3))
		 (keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 ;; Empty blocks have no contents.
		 (contents-begin (progn (forward-line)
					(and (< (point) block-end-line)
					     (point))))
		 (contents-end (and contents-begin block-end-line))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char block-end-line)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'dynamic-block
		  (nconc
		   (list :begin begin
			 :end end
			 :block-name name
			 :arguments arguments
			 :hiddenp hidden
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-dynamic-block-interpreter (dynamic-block contents)
  "Interpret DYNAMIC-BLOCK element as Org syntax.
CONTENTS is the contents of the element."
  (format "#+BEGIN: %s%s\n%s#+END:"
	  (org-element-property :block-name dynamic-block)
	  (let ((args (org-element-property :arguments dynamic-block)))
	    (and args (concat " " args)))
	  contents))


;;;; Footnote Definition

(defun org-element-footnote-definition-parser (limit)
  "Parse a footnote definition.

LIMIT bounds the search.

Return a list whose CAR is `footnote-definition' and CDR is
a plist containing `:label', `:begin' `:end', `:contents-begin',
`:contents-end' and `:post-blank' keywords.

Assume point is at the beginning of the footnote definition."
  (save-excursion
    (let* ((label (progn (looking-at org-footnote-definition-re)
			 (org-match-string-no-properties 1)))
	   (keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (ending (save-excursion
		     (if (progn
			   (end-of-line)
			   (re-search-forward
			    (concat org-outline-regexp-bol "\\|"
				    org-footnote-definition-re "\\|"
				    "^[ \t]*$") limit 'move))
			 (match-beginning 0)
		       (point))))
	   (contents-begin (progn (search-forward "]")
				  (skip-chars-forward " \r\t\n" ending)
				  (and (/= (point) ending) (point))))
	   (contents-end (and contents-begin ending))
	   (end (progn (goto-char ending)
		       (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'footnote-definition
	    (nconc
	     (list :label label
		   :begin begin
		   :end end
		   :contents-begin contents-begin
		   :contents-end contents-end
		   :post-blank (count-lines ending end))
	     (cadr keywords))))))

(defun org-element-footnote-definition-interpreter (footnote-definition contents)
  "Interpret FOOTNOTE-DEFINITION element as Org syntax.
CONTENTS is the contents of the footnote-definition."
  (concat (format "[%s]" (org-element-property :label footnote-definition))
	  " "
	  contents))


;;;; Headline

(defun org-element-headline-parser (limit &optional raw-secondary-p)
  "Parse an headline.

Return a list whose CAR is `headline' and CDR is a plist
containing `:raw-value', `:title', `:begin', `:end',
`:pre-blank', `:hiddenp', `:contents-begin' and `:contents-end',
`:level', `:priority', `:tags', `:todo-keyword',`:todo-type',
`:scheduled', `:deadline', `:timestamp', `:clock', `:category',
`:quotedp', `:archivedp', `:commentedp' and `:footnote-section-p'
keywords.

The plist also contains any property set in the property drawer,
with its name in lowercase, the underscores replaced with hyphens
and colons at the beginning (i.e. `:custom-id').

When RAW-SECONDARY-P is non-nil, headline's title will not be
parsed as a secondary string, but as a plain string instead.

Assume point is at beginning of the headline."
  (save-excursion
    (let* ((components (org-heading-components))
	   (level (nth 1 components))
	   (todo (nth 2 components))
	   (todo-type
	    (and todo (if (member todo org-done-keywords) 'done 'todo)))
	   (tags (let ((raw-tags (nth 5 components)))
		   (and raw-tags (org-split-string raw-tags ":"))))
	   (raw-value (or (nth 4 components) ""))
	   (quotedp
	    (let ((case-fold-search nil))
	      (string-match (format "^%s\\( \\|$\\)" org-quote-string)
			    raw-value)))
	   (commentedp
	    (let ((case-fold-search nil))
	      (string-match (format "^%s\\( \\|$\\)" org-comment-string)
			    raw-value)))
	   (archivedp (member org-archive-tag tags))
	   (footnote-section-p (and org-footnote-section
				    (string= org-footnote-section raw-value)))
	   ;; Normalize property names: ":SOME_PROP:" becomes
	   ;; ":some-prop".
	   (standard-props (let (plist)
			     (mapc
			      (lambda (p)
				(let ((p-name (downcase (car p))))
				  (while (string-match "_" p-name)
				    (setq p-name
					  (replace-match "-" nil nil p-name)))
				  (setq p-name (intern (concat ":" p-name)))
				  (setq plist
					(plist-put plist p-name (cdr p)))))
			      (org-entry-properties nil 'standard))
			     plist))
	   (time-props (org-entry-properties nil 'special "CLOCK"))
	   (scheduled (cdr (assoc "SCHEDULED" time-props)))
	   (deadline (cdr (assoc "DEADLINE" time-props)))
	   (clock (cdr (assoc "CLOCK" time-props)))
	   (timestamp (cdr (assoc "TIMESTAMP" time-props)))
	   (begin (point))
	   (end (save-excursion (goto-char (org-end-of-subtree t t))))
	   (pos-after-head (progn (forward-line) (point)))
	   (contents-begin (save-excursion
			     (skip-chars-forward " \r\t\n" end)
			     (and (/= (point) end) (line-beginning-position))))
	   (hidden (org-invisible-p2))
	   (contents-end (and contents-begin
			      (progn (goto-char end)
				     (skip-chars-backward " \r\t\n")
				     (forward-line)
				     (point)))))
      ;; Clean RAW-VALUE from any quote or comment string.
      (when (or quotedp commentedp)
	(let ((case-fold-search nil))
	  (setq raw-value
		(replace-regexp-in-string
		 (concat
		  (regexp-opt (list org-quote-string org-comment-string))
		  "\\(?: \\|$\\)")
		 ""
		 raw-value))))
      ;; Clean TAGS from archive tag, if any.
      (when archivedp (setq tags (delete org-archive-tag tags)))
      (let ((headline
	     (list 'headline
		   (nconc
		    (list :raw-value raw-value
			  :begin begin
			  :end end
			  :pre-blank
			  (if (not contents-begin) 0
			    (count-lines pos-after-head contents-begin))
			  :hiddenp hidden
			  :contents-begin contents-begin
			  :contents-end contents-end
			  :level level
			  :priority (nth 3 components)
			  :tags tags
			  :todo-keyword todo
			  :todo-type todo-type
			  :scheduled scheduled
			  :deadline deadline
			  :timestamp timestamp
			  :clock clock
			  :post-blank (count-lines
				       (if (not contents-end) pos-after-head
					 (goto-char contents-end)
					 (forward-line)
					 (point))
				       end)
			  :footnote-section-p footnote-section-p
			  :archivedp archivedp
			  :commentedp commentedp
			  :quotedp quotedp)
		    standard-props))))
	(org-element-put-property
	 headline :title
	 (if raw-secondary-p raw-value
	   (org-element-parse-secondary-string
	    raw-value (org-element-restriction 'headline) headline)))))))

(defun org-element-headline-interpreter (headline contents)
  "Interpret HEADLINE element as Org syntax.
CONTENTS is the contents of the element."
  (let* ((level (org-element-property :level headline))
	 (todo (org-element-property :todo-keyword headline))
	 (priority (org-element-property :priority headline))
	 (title (org-element-interpret-data
		 (org-element-property :title headline)))
	 (tags (let ((tag-list (if (org-element-property :archivedp headline)
				   (cons org-archive-tag
					 (org-element-property :tags headline))
				 (org-element-property :tags headline))))
		 (and tag-list
		      (format ":%s:" (mapconcat 'identity tag-list ":")))))
	 (commentedp (org-element-property :commentedp headline))
	 (quotedp (org-element-property :quotedp headline))
	 (pre-blank (or (org-element-property :pre-blank headline) 0))
	 (heading (concat (make-string level ?*)
			  (and todo (concat " " todo))
			  (and quotedp (concat " " org-quote-string))
			  (and commentedp (concat " " org-comment-string))
			  (and priority
			       (format " [#%s]" (char-to-string priority)))
			  (cond ((and org-footnote-section
				      (org-element-property
				       :footnote-section-p headline))
				 (concat " " org-footnote-section))
				(title (concat " " title))))))
    (concat heading
	    ;; Align tags.
	    (when tags
	      (cond
	       ((zerop org-tags-column) (format " %s" tags))
	       ((< org-tags-column 0)
		(concat
		 (make-string
		  (max (- (+ org-tags-column (length heading) (length tags))) 1)
		  ? )
		 tags))
	       (t
		(concat
		 (make-string (max (- org-tags-column (length heading)) 1) ? )
		 tags))))
	    (make-string (1+ pre-blank) 10)
	    contents)))


;;;; Inlinetask

(defun org-element-inlinetask-parser (limit &optional raw-secondary-p)
  "Parse an inline task.

Return a list whose CAR is `inlinetask' and CDR is a plist
containing `:title', `:begin', `:end', `:hiddenp',
`:contents-begin' and `:contents-end', `:level', `:priority',
`:raw-value', `:tags', `:todo-keyword', `:todo-type',
`:scheduled', `:deadline', `:timestamp', `:clock' and
`:post-blank' keywords.

The plist also contains any property set in the property drawer,
with its name in lowercase, the underscores replaced with hyphens
and colons at the beginning (i.e. `:custom-id').

When optional argument RAW-SECONDARY-P is non-nil, inline-task's
title will not be parsed as a secondary string, but as a plain
string instead.

Assume point is at beginning of the inline task."
  (save-excursion
    (let* ((keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (components (org-heading-components))
	   (todo (nth 2 components))
	   (todo-type (and todo
			   (if (member todo org-done-keywords) 'done 'todo)))
	   (tags (let ((raw-tags (nth 5 components)))
		   (and raw-tags (org-split-string raw-tags ":"))))
	   (raw-value (or (nth 4 components) ""))
	   ;; Normalize property names: ":SOME_PROP:" becomes
	   ;; ":some-prop".
	   (standard-props (let (plist)
			     (mapc
			      (lambda (p)
				(let ((p-name (downcase (car p))))
				  (while (string-match "_" p-name)
				    (setq p-name
					  (replace-match "-" nil nil p-name)))
				  (setq p-name (intern (concat ":" p-name)))
				  (setq plist
					(plist-put plist p-name (cdr p)))))
			      (org-entry-properties nil 'standard))
			     plist))
	   (time-props (org-entry-properties nil 'special "CLOCK"))
	   (scheduled (cdr (assoc "SCHEDULED" time-props)))
	   (deadline (cdr (assoc "DEADLINE" time-props)))
	   (clock (cdr (assoc "CLOCK" time-props)))
	   (timestamp (cdr (assoc "TIMESTAMP" time-props)))
	   (task-end (save-excursion
		       (end-of-line)
		       (and (re-search-forward "^\\*+ END" limit t)
			    (match-beginning 0))))
	   (contents-begin (progn (forward-line)
				  (and task-end (< (point) task-end) (point))))
	   (hidden (and contents-begin (org-invisible-p2)))
	   (contents-end (and contents-begin task-end))
	   (before-blank (if (not task-end) (point)
			   (goto-char task-end)
			   (forward-line)
			   (point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position))))
	   (inlinetask
	    (list 'inlinetask
		  (nconc
		   (list :raw-value raw-value
			 :begin begin
			 :end end
			 :hiddenp hidden
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :level (nth 1 components)
			 :priority (nth 3 components)
			 :tags tags
			 :todo-keyword todo
			 :todo-type todo-type
			 :scheduled scheduled
			 :deadline deadline
			 :timestamp timestamp
			 :clock clock
			 :post-blank (count-lines before-blank end))
		   standard-props
		   (cadr keywords)))))
      (org-element-put-property
       inlinetask :title
       (if raw-secondary-p raw-value
	 (org-element-parse-secondary-string
	  raw-value
	  (org-element-restriction 'inlinetask)
	  inlinetask))))))

(defun org-element-inlinetask-interpreter (inlinetask contents)
  "Interpret INLINETASK element as Org syntax.
CONTENTS is the contents of inlinetask."
  (let* ((level (org-element-property :level inlinetask))
	 (todo (org-element-property :todo-keyword inlinetask))
	 (priority (org-element-property :priority inlinetask))
	 (title (org-element-interpret-data
		 (org-element-property :title inlinetask)))
	 (tags (let ((tag-list (org-element-property :tags inlinetask)))
		 (and tag-list
		      (format ":%s:" (mapconcat 'identity tag-list ":")))))
	 (task (concat (make-string level ?*)
		       (and todo (concat " " todo))
		       (and priority
			    (format " [#%s]" (char-to-string priority)))
		       (and title (concat " " title)))))
    (concat task
	    ;; Align tags.
	    (when tags
	      (cond
	       ((zerop org-tags-column) (format " %s" tags))
	       ((< org-tags-column 0)
		(concat
		 (make-string
		  (max (- (+ org-tags-column (length task) (length tags))) 1)
		  ? )
		 tags))
	       (t
		(concat
		 (make-string (max (- org-tags-column (length task)) 1) ? )
		 tags))))
	    ;; Prefer degenerate inlinetasks when there are no
	    ;; contents.
	    (when contents
	      (concat "\n"
		      contents
		      (make-string level ?*) " END")))))


;;;; Item

(defun org-element-item-parser (limit struct &optional raw-secondary-p)
  "Parse an item.

STRUCT is the structure of the plain list.

Return a list whose CAR is `item' and CDR is a plist containing
`:bullet', `:begin', `:end', `:contents-begin', `:contents-end',
`:checkbox', `:counter', `:tag', `:structure', `:hiddenp' and
`:post-blank' keywords.

When optional argument RAW-SECONDARY-P is non-nil, item's tag, if
any, will not be parsed as a secondary string, but as a plain
string instead.

Assume point is at the beginning of the item."
  (save-excursion
    (beginning-of-line)
    (looking-at org-list-full-item-re)
    (let* ((begin (point))
	   (bullet (org-match-string-no-properties 1))
	   (checkbox (let ((box (org-match-string-no-properties 3)))
		       (cond ((equal "[ ]" box) 'off)
			     ((equal "[X]" box) 'on)
			     ((equal "[-]" box) 'trans))))
	   (counter (let ((c (org-match-string-no-properties 2)))
		      (save-match-data
			(cond
			 ((not c) nil)
			 ((string-match "[A-Za-z]" c)
			  (- (string-to-char (upcase (match-string 0 c)))
			     64))
			 ((string-match "[0-9]+" c)
			  (string-to-number (match-string 0 c)))))))
	   (end (save-excursion (goto-char (org-list-get-item-end begin struct))
				(unless (bolp) (forward-line))
				(point)))
	   (contents-begin
	    (progn (goto-char
		    ;; Ignore tags in un-ordered lists: they are just
		    ;; a part of item's body.
		    (if (and (match-beginning 4)
			     (save-match-data (string-match "[.)]" bullet)))
			(match-beginning 4)
		      (match-end 0)))
		   (skip-chars-forward " \r\t\n" limit)
		   ;; If first line isn't empty, contents really start
		   ;; at the text after item's meta-data.
		   (if (= (point-at-bol) begin) (point) (point-at-bol))))
	   (hidden (progn (forward-line)
			  (and (not (= (point) end)) (org-invisible-p2))))
	   (contents-end (progn (goto-char end)
				(skip-chars-backward " \r\t\n")
				(forward-line)
				(point)))
	   (item
	    (list 'item
		  (list :bullet bullet
			:begin begin
			:end end
			;; CONTENTS-BEGIN and CONTENTS-END may be
			;; mixed up in the case of an empty item
			;; separated from the next by a blank line.
			;; Thus ensure the former is always the
			;; smallest.
			:contents-begin (min contents-begin contents-end)
			:contents-end (max contents-begin contents-end)
			:checkbox checkbox
			:counter counter
			:hiddenp hidden
			:structure struct
			:post-blank (count-lines contents-end end)))))
      (org-element-put-property
       item :tag
       (let ((raw-tag (org-list-get-tag begin struct)))
	 (and raw-tag
	      (if raw-secondary-p raw-tag
		(org-element-parse-secondary-string
		 raw-tag (org-element-restriction 'item) item))))))))

(defun org-element-item-interpreter (item contents)
  "Interpret ITEM element as Org syntax.
CONTENTS is the contents of the element."
  (let* ((bullet (org-list-bullet-string (org-element-property :bullet item)))
	 (checkbox (org-element-property :checkbox item))
	 (counter (org-element-property :counter item))
	 (tag (let ((tag (org-element-property :tag item)))
		(and tag (org-element-interpret-data tag))))
	 ;; Compute indentation.
	 (ind (make-string (length bullet) 32))
	 (item-starts-with-par-p
	  (eq (org-element-type (car (org-element-contents item)))
	      'paragraph)))
    ;; Indent contents.
    (concat
     bullet
     (and counter (format "[@%d] " counter))
     (case checkbox
       (on "[X] ")
       (off "[ ] ")
       (trans "[-] "))
     (and tag (format "%s :: " tag))
     (let ((contents (replace-regexp-in-string
		      "\\(^\\)[ \t]*\\S-" ind contents nil nil 1)))
       (if item-starts-with-par-p (org-trim contents)
	 (concat "\n" contents))))))


;;;; Plain List

(defun org-element-plain-list-parser (limit &optional structure)
  "Parse a plain list.

Optional argument STRUCTURE, when non-nil, is the structure of
the plain list being parsed.

Return a list whose CAR is `plain-list' and CDR is a plist
containing `:type', `:begin', `:end', `:contents-begin' and
`:contents-end', `:structure' and `:post-blank' keywords.

Assume point is at the beginning of the list."
  (save-excursion
    (let* ((struct (or structure (org-list-struct)))
	   (prevs (org-list-prevs-alist struct))
	   (parents (org-list-parents-alist struct))
	   (type (org-list-get-list-type (point) struct prevs))
	   (contents-begin (point))
	   (keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (contents-end
	    (progn (goto-char (org-list-get-list-end (point) struct prevs))
		   (unless (bolp) (forward-line))
		   (point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      ;; Return value.
      (list 'plain-list
	    (nconc
	     (list :type type
		   :begin begin
		   :end end
		   :contents-begin contents-begin
		   :contents-end contents-end
		   :structure struct
		   :post-blank (count-lines contents-end end))
	     (cadr keywords))))))

(defun org-element-plain-list-interpreter (plain-list contents)
  "Interpret PLAIN-LIST element as Org syntax.
CONTENTS is the contents of the element."
  (with-temp-buffer
    (insert contents)
    (goto-char (point-min))
    (org-list-repair)
    (buffer-string)))


;;;; Quote Block

(defun org-element-quote-block-parser (limit)
  "Parse a quote block.

LIMIT bounds the search.

Return a list whose CAR is `quote-block' and CDR is a plist
containing `:begin', `:end', `:hiddenp', `:contents-begin',
`:contents-end' and `:post-blank' keywords.

Assume point is at the beginning of the block."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END_QUOTE[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((block-end-line (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 ;; Empty blocks have no contents.
		 (contents-begin (progn (forward-line)
					(and (< (point) block-end-line)
					     (point))))
		 (contents-end (and contents-begin block-end-line))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char block-end-line)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'quote-block
		  (nconc
		   (list :begin begin
			 :end end
			 :hiddenp hidden
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-quote-block-interpreter (quote-block contents)
  "Interpret QUOTE-BLOCK element as Org syntax.
CONTENTS is the contents of the element."
  (format "#+BEGIN_QUOTE\n%s#+END_QUOTE" contents))


;;;; Section

(defun org-element-section-parser (limit)
  "Parse a section.

LIMIT bounds the search.

Return a list whose CAR is `section' and CDR is a plist
containing `:begin', `:end', `:contents-begin', `contents-end'
and `:post-blank' keywords."
  (save-excursion
    ;; Beginning of section is the beginning of the first non-blank
    ;; line after previous headline.
    (let ((begin (point))
	  (end (progn (org-with-limited-levels (outline-next-heading))
		      (point)))
	  (pos-before-blank (progn (skip-chars-backward " \r\t\n")
				   (forward-line)
				   (point))))
      (list 'section
	    (list :begin begin
		  :end end
		  :contents-begin begin
		  :contents-end pos-before-blank
		  :post-blank (count-lines pos-before-blank end))))))

(defun org-element-section-interpreter (section contents)
  "Interpret SECTION element as Org syntax.
CONTENTS is the contents of the element."
  contents)


;;;; Special Block

(defun org-element-special-block-parser (limit)
  "Parse a special block.

LIMIT bounds the search.

Return a list whose CAR is `special-block' and CDR is a plist
containing `:type', `:begin', `:end', `:hiddenp',
`:contents-begin', `:contents-end' and `:post-blank' keywords.

Assume point is at the beginning of the block."
  (let* ((case-fold-search t)
	 (type (progn (looking-at "[ \t]*#\\+BEGIN_\\(S-+\\)")
		      (upcase (match-string-no-properties 1)))))
    (if (not (save-excursion
	       (re-search-forward
		(format "^[ \t]*#\\+END_%s[ \t]*$" type) limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((block-end-line (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 ;; Empty blocks have no contents.
		 (contents-begin (progn (forward-line)
					(and (< (point) block-end-line)
					     (point))))
		 (contents-end (and contents-begin block-end-line))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char block-end-line)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'special-block
		  (nconc
		   (list :type type
			 :begin begin
			 :end end
			 :hiddenp hidden
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-special-block-interpreter (special-block contents)
  "Interpret SPECIAL-BLOCK element as Org syntax.
CONTENTS is the contents of the element."
  (let ((block-type (org-element-property :type special-block)))
    (format "#+BEGIN_%s\n%s#+END_%s" block-type contents block-type)))



;;; Elements
;;
;; For each element, a parser and an interpreter are also defined.
;; Both follow the same naming convention used for greater elements.
;;
;; Also, as for greater elements, adding a new element type is done
;; through the following steps: implement a parser and an interpreter,
;; tweak `org-element--current-element' so that it recognizes the new
;; type and add that new type to `org-element-all-elements'.
;;
;; As a special case, when the newly defined type is a block type,
;; `org-element-block-name-alist' has to be modified accordingly.


;;;; Babel Call

(defun org-element-babel-call-parser (limit)
  "Parse a babel call.

LIMIT bounds the search.

Return a list whose CAR is `babel-call' and CDR is a plist
containing `:begin', `:end', `:info' and `:post-blank' as
keywords."
  (save-excursion
    (let ((case-fold-search t)
	  (info (progn (looking-at org-babel-block-lob-one-liner-regexp)
		       (org-babel-lob-get-info)))
	  (begin (point-at-bol))
	  (pos-before-blank (progn (forward-line) (point)))
	  (end (progn (skip-chars-forward " \r\t\n" limit)
		      (skip-chars-backward " \t")
		      (if (bolp) (point) (line-end-position)))))
      (list 'babel-call
	    (list :begin begin
		  :end end
		  :info info
		  :post-blank (count-lines pos-before-blank end))))))

(defun org-element-babel-call-interpreter (babel-call contents)
  "Interpret BABEL-CALL element as Org syntax.
CONTENTS is nil."
  (let* ((babel-info (org-element-property :info babel-call))
	 (main (car babel-info))
	 (post-options (nth 1 babel-info)))
    (concat "#+CALL: "
	    (if (not (string-match "\\[\\(\\[.*?\\]\\)\\]" main)) main
	      ;; Remove redundant square brackets.
	      (replace-match (match-string 1 main) nil nil main))
	    (and post-options (format "[%s]" post-options)))))


;;;; Clock

(defun org-element-clock-parser (limit)
  "Parse a clock.

LIMIT bounds the search.

Return a list whose CAR is `clock' and CDR is a plist containing
`:status', `:value', `:time', `:begin', `:end' and `:post-blank'
as keywords."
  (save-excursion
    (let* ((case-fold-search nil)
	   (begin (point))
	   (value (progn (search-forward org-clock-string (line-end-position) t)
			 (org-skip-whitespace)
			 (looking-at "\\[.*\\]")
			 (org-match-string-no-properties 0)))
	   (time (and (progn (goto-char (match-end 0))
			     (looking-at " +=> +\\(\\S-+\\)[ \t]*$"))
		      (org-match-string-no-properties 1)))
	   (status (if time 'closed 'running))
	   (post-blank (let ((before-blank (progn (forward-line) (point))))
			 (skip-chars-forward " \r\t\n" limit)
			 (skip-chars-backward " \t")
			 (unless (bolp) (end-of-line))
			 (count-lines before-blank (point))))
	   (end (point)))
      (list 'clock
	    (list :status status
		  :value value
		  :time time
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-clock-interpreter (clock contents)
  "Interpret CLOCK element as Org syntax.
CONTENTS is nil."
  (concat org-clock-string " "
	  (org-element-property :value clock)
	  (let ((time (org-element-property :time clock)))
	    (and time
		 (concat " => "
			 (apply 'format
				"%2s:%02s"
				(org-split-string time ":")))))))


;;;; Comment

(defun org-element-comment-parser (limit)
  "Parse a comment.

LIMIT bounds the search.

Return a list whose CAR is `comment' and CDR is a plist
containing `:begin', `:end', `:value' and `:post-blank'
keywords.

Assume point is at comment beginning."
  (save-excursion
    (let* ((keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (value (prog2 (looking-at "[ \t]*# ?")
		      (buffer-substring-no-properties
		       (match-end 0) (line-end-position))
		    (forward-line)))
	   (com-end
	    ;; Get comments ending.
	    (progn
	      (while (and (< (point) limit) (looking-at "[ \t]*#\\( \\|$\\)"))
		;; Accumulate lines without leading hash and first
		;; whitespace.
		(setq value
		      (concat value
			      "\n"
			      (buffer-substring-no-properties
			       (match-end 0) (line-end-position))))
		(forward-line))
	      (point)))
	   (end (progn (goto-char com-end)
		       (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'comment
	    (nconc
	     (list :begin begin
		   :end end
		   :value value
		   :post-blank (count-lines com-end end))
	     (cadr keywords))))))

(defun org-element-comment-interpreter (comment contents)
  "Interpret COMMENT element as Org syntax.
CONTENTS is nil."
  (replace-regexp-in-string "^" "# " (org-element-property :value comment)))


;;;; Comment Block

(defun org-element-comment-block-parser (limit)
  "Parse an export block.

LIMIT bounds the search.

Return a list whose CAR is `comment-block' and CDR is a plist
containing `:begin', `:end', `:hiddenp', `:value' and
`:post-blank' keywords.

Assume point is at comment block beginning."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END_COMMENT[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((contents-end (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 (contents-begin (progn (forward-line) (point)))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char contents-end)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position))))
		 (value (buffer-substring-no-properties
			 contents-begin contents-end)))
	    (list 'comment-block
		  (nconc
		   (list :begin begin
			 :end end
			 :value value
			 :hiddenp hidden
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-comment-block-interpreter (comment-block contents)
  "Interpret COMMENT-BLOCK element as Org syntax.
CONTENTS is nil."
  (format "#+BEGIN_COMMENT\n%s#+END_COMMENT"
	  (org-remove-indentation (org-element-property :value comment-block))))


;;;; Example Block

(defun org-element-example-block-parser (limit)
  "Parse an example block.

LIMIT bounds the search.

Return a list whose CAR is `example-block' and CDR is a plist
containing `:begin', `:end', `:number-lines', `:preserve-indent',
`:retain-labels', `:use-labels', `:label-fmt', `:hiddenp',
`:switches', `:value' and `:post-blank' keywords."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END_EXAMPLE[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((contents-end (match-beginning 0)))
	(save-excursion
	  (let* ((switches
		  (progn (looking-at "^[ \t]*#\\+BEGIN_EXAMPLE\\(?: +\\(.*\\)\\)?")
			 (org-match-string-no-properties 1)))
		 ;; Switches analysis
		 (number-lines (cond ((not switches) nil)
				     ((string-match "-n\\>" switches) 'new)
				     ((string-match "+n\\>" switches) 'continued)))
		 (preserve-indent (and switches (string-match "-i\\>" switches)))
		 ;; Should labels be retained in (or stripped from) example
		 ;; blocks?
		 (retain-labels
		  (or (not switches)
		      (not (string-match "-r\\>" switches))
		      (and number-lines (string-match "-k\\>" switches))))
		 ;; What should code-references use - labels or
		 ;; line-numbers?
		 (use-labels
		  (or (not switches)
		      (and retain-labels (not (string-match "-k\\>" switches)))))
		 (label-fmt (and switches
				 (string-match "-l +\"\\([^\"\n]+\\)\"" switches)
				 (match-string 1 switches)))
		 ;; Standard block parsing.
		 (keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 (contents-begin (progn (forward-line) (point)))
		 (hidden (org-invisible-p2))
		 (value (org-unescape-code-in-string
			 (buffer-substring-no-properties
			  contents-begin contents-end)))
		 (pos-before-blank (progn (goto-char contents-end)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'example-block
		  (nconc
		   (list :begin begin
			 :end end
			 :value value
			 :switches switches
			 :number-lines number-lines
			 :preserve-indent preserve-indent
			 :retain-labels retain-labels
			 :use-labels use-labels
			 :label-fmt label-fmt
			 :hiddenp hidden
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-example-block-interpreter (example-block contents)
  "Interpret EXAMPLE-BLOCK element as Org syntax.
CONTENTS is nil."
  (let ((switches (org-element-property :switches example-block)))
    (concat "#+BEGIN_EXAMPLE" (and switches (concat " " switches)) "\n"
	    (org-remove-indentation
	     (org-escape-code-in-string
	      (org-element-property :value example-block)))
	    "#+END_EXAMPLE")))


;;;; Export Block

(defun org-element-export-block-parser (limit)
  "Parse an export block.

LIMIT bounds the search.

Return a list whose CAR is `export-block' and CDR is a plist
containing `:begin', `:end', `:type', `:hiddenp', `:value' and
`:post-blank' keywords.

Assume point is at export-block beginning."
  (let* ((case-fold-search t)
	 (type (progn (looking-at "[ \t]*#\\+BEGIN_\\(\\S-+\\)")
		      (upcase (org-match-string-no-properties 1)))))
    (if (not (save-excursion
	       (re-search-forward
		(format "^[ \t]*#\\+END_%s[ \t]*$" type) limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((contents-end (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 (contents-begin (progn (forward-line) (point)))
		 (hidden (org-invisible-p2))
		 (pos-before-blank (progn (goto-char contents-end)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position))))
		 (value (buffer-substring-no-properties contents-begin
							contents-end)))
	    (list 'export-block
		  (nconc
		   (list :begin begin
			 :end end
			 :type type
			 :value value
			 :hiddenp hidden
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-export-block-interpreter (export-block contents)
  "Interpret EXPORT-BLOCK element as Org syntax.
CONTENTS is nil."
  (let ((type (org-element-property :type export-block)))
    (concat (format "#+BEGIN_%s\n" type)
	    (org-element-property :value export-block)
	    (format "#+END_%s" type))))


;;;; Fixed-width

(defun org-element-fixed-width-parser (limit)
  "Parse a fixed-width section.

LIMIT bounds the search.

Return a list whose CAR is `fixed-width' and CDR is a plist
containing `:begin', `:end', `:value' and `:post-blank' keywords.

Assume point is at the beginning of the fixed-width area."
  (save-excursion
    (let* ((keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   value
	   (end-area
	    (progn
	      (while (and (< (point) limit)
			  (looking-at "[ \t]*:\\( \\|$\\)"))
		;; Accumulate text without starting colons.
		(setq value
		      (concat value
			      (buffer-substring-no-properties
			       (match-end 0) (point-at-eol))
			      "\n"))
		(forward-line))
	      (point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'fixed-width
	    (nconc
	     (list :begin begin
		   :end end
		   :value value
		   :post-blank (count-lines end-area end))
	     (cadr keywords))))))

(defun org-element-fixed-width-interpreter (fixed-width contents)
  "Interpret FIXED-WIDTH element as Org syntax.
CONTENTS is nil."
  (replace-regexp-in-string
   "^" ": " (substring (org-element-property :value fixed-width) 0 -1)))


;;;; Horizontal Rule

(defun org-element-horizontal-rule-parser (limit)
  "Parse an horizontal rule.

LIMIT bounds the search.

Return a list whose CAR is `horizontal-rule' and CDR is a plist
containing `:begin', `:end' and `:post-blank' keywords."
  (save-excursion
    (let* ((keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (post-hr (progn (forward-line) (point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'horizontal-rule
	    (nconc
	     (list :begin begin
		   :end end
		   :post-blank (count-lines post-hr end))
	     (cadr keywords))))))

(defun org-element-horizontal-rule-interpreter (horizontal-rule contents)
  "Interpret HORIZONTAL-RULE element as Org syntax.
CONTENTS is nil."
  "-----")


;;;; Keyword

(defun org-element-keyword-parser (limit)
  "Parse a keyword at point.

LIMIT bounds the search.

Return a list whose CAR is `keyword' and CDR is a plist
containing `:key', `:value', `:begin', `:end' and `:post-blank'
keywords."
  (save-excursion
    (let* ((case-fold-search t)
	   (begin (point))
	   (key (progn (looking-at "[ \t]*#\\+\\(\\S-+\\):")
		       (upcase (org-match-string-no-properties 1))))
	   (value (org-trim (buffer-substring-no-properties
			     (match-end 0) (point-at-eol))))
	   (pos-before-blank (progn (forward-line) (point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'keyword
	    (list :key key
		  :value value
		  :begin begin
		  :end end
		  :post-blank (count-lines pos-before-blank end))))))

(defun org-element-keyword-interpreter (keyword contents)
  "Interpret KEYWORD element as Org syntax.
CONTENTS is nil."
  (format "#+%s: %s"
	  (org-element-property :key keyword)
	  (org-element-property :value keyword)))


;;;; Latex Environment

(defun org-element-latex-environment-parser (limit)
  "Parse a LaTeX environment.

LIMIT bounds the search.

Return a list whose CAR is `latex-environment' and CDR is a plist
containing `:begin', `:end', `:value' and `:post-blank'
keywords.

Assume point is at the beginning of the latex environment."
  (save-excursion
    (let* ((case-fold-search t)
	   (code-begin (point))
	   (keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (env (progn (looking-at "^[ \t]*\\\\begin{\\([A-Za-z0-9]+\\*?\\)}")
		       (regexp-quote (match-string 1))))
	   (code-end
	    (progn (re-search-forward
		    (format "^[ \t]*\\\\end{%s}[ \t]*$" env) limit t)
		   (forward-line)
		   (point)))
	   (value (buffer-substring-no-properties code-begin code-end))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'latex-environment
	    (nconc
	     (list :begin begin
		   :end end
		   :value value
		   :post-blank (count-lines code-end end))
	     (cadr keywords))))))

(defun org-element-latex-environment-interpreter (latex-environment contents)
  "Interpret LATEX-ENVIRONMENT element as Org syntax.
CONTENTS is nil."
  (org-element-property :value latex-environment))


;;;; Paragraph

(defun org-element-paragraph-parser (limit)
  "Parse a paragraph.

LIMIT bounds the search.

Return a list whose CAR is `paragraph' and CDR is a plist
containing `:begin', `:end', `:contents-begin' and
`:contents-end' and `:post-blank' keywords.

Assume point is at the beginning of the paragraph."
  (save-excursion
    (let* ((contents-begin (point))
	   ;; INNER-PAR-P is non-nil when paragraph is at the
	   ;; beginning of an item or a footnote reference. In that
	   ;; case, we mustn't look for affiliated keywords since they
	   ;; belong to the container.
	   (inner-par-p (not (bolp)))
	   (keywords (unless inner-par-p
		       (org-element--collect-affiliated-keywords)))
	   (begin (if inner-par-p contents-begin (car keywords)))
	   (before-blank
	    (let ((case-fold-search t))
	      (end-of-line)
	      (if (not (re-search-forward
			org-element-paragraph-separate limit 'm))
		  limit
		;; A matching `org-element-paragraph-separate' is not
		;; necessarily the end of the paragraph.  In
		;; particular, lines starting with # or : as a first
		;; non-space character are ambiguous.  We have check
		;; if they are valid Org syntax (i.e. not an
		;; incomplete keyword).
		(beginning-of-line)
		(while (not
			(or
			 ;; There's no ambiguity for other symbols or
			 ;; empty lines: stop here.
			 (looking-at "[ \t]*\\(?:[^:#]\\|$\\)")
			 ;; Stop at valid fixed-width areas.
			 (looking-at "[ \t]*:\\(?: \\|$\\)")
			 ;; Stop at drawers.
			 (and (looking-at org-drawer-regexp)
			      (save-excursion
				(re-search-forward
				 "^[ \t]*:END:[ \t]*$" limit t)))
			 ;; Stop at valid comments.
			 (looking-at "[ \t]*#\\(?: \\|$\\)")
			 ;; Stop at valid dynamic blocks.
			 (and (looking-at org-dblock-start-re)
			      (save-excursion
				(re-search-forward
				 "^[ \t]*#\\+END:?[ \t]*$" limit t)))
			 ;; Stop at valid blocks.
			 (and (looking-at
			       "[ \t]*#\\+BEGIN_\\(\\S-+\\)")
			      (save-excursion
				(re-search-forward
				 (format "^[ \t]*#\\+END_%s[ \t]*$"
					 (match-string 1))
				 limit t)))
			 ;; Stop at valid latex environments.
			 (and (looking-at
			       "^[ \t]*\\\\begin{\\([A-Za-z0-9]+\\*?\\)}[ \t]*$")
			      (save-excursion
				(re-search-forward
				 (format "^[ \t]*\\\\end{%s}[ \t]*$"
					 (match-string 1))
				 limit t)))
			 ;; Stop at valid keywords.
			 (looking-at "[ \t]*#\\+\\S-+:")
			 ;; Skip everything else.
			 (not
			  (progn
			    (end-of-line)
			    (re-search-forward org-element-paragraph-separate
					       limit 'm)))))
		  (beginning-of-line)))
	      (if (= (point) limit) limit
		(goto-char (line-beginning-position)))))
	   (contents-end (progn (skip-chars-backward " \r\t\n" contents-begin)
				(forward-line)
				(point)))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'paragraph
	    (nconc
	     (list :begin begin
		   :end end
		   :contents-begin contents-begin
		   :contents-end contents-end
		   :post-blank (count-lines before-blank end))
	     (cadr keywords))))))

(defun org-element-paragraph-interpreter (paragraph contents)
  "Interpret PARAGRAPH element as Org syntax.
CONTENTS is the contents of the element."
  contents)


;;;; Planning

(defun org-element-planning-parser (limit)
  "Parse a planning.

LIMIT bounds the search.

Return a list whose CAR is `planning' and CDR is a plist
containing `:closed', `:deadline', `:scheduled', `:begin', `:end'
and `:post-blank' keywords."
  (save-excursion
    (let* ((case-fold-search nil)
	   (begin (point))
	   (post-blank (let ((before-blank (progn (forward-line) (point))))
			 (skip-chars-forward " \r\t\n" limit)
			 (skip-chars-backward " \t")
			 (unless (bolp) (end-of-line))
			 (count-lines before-blank (point))))
	   (end (point))
	   closed deadline scheduled)
      (goto-char begin)
      (while (re-search-forward org-keyword-time-not-clock-regexp
				(line-end-position) t)
	(goto-char (match-end 1))
	(org-skip-whitespace)
	(let ((time (buffer-substring-no-properties
		     (1+ (point)) (1- (match-end 0))))
	      (keyword (match-string 1)))
	  (cond ((equal keyword org-closed-string) (setq closed time))
		((equal keyword org-deadline-string) (setq deadline time))
		(t (setq scheduled time)))))
      (list 'planning
	    (list :closed closed
		  :deadline deadline
		  :scheduled scheduled
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-planning-interpreter (planning contents)
  "Interpret PLANNING element as Org syntax.
CONTENTS is nil."
  (mapconcat
   'identity
   (delq nil
	 (list (let ((closed (org-element-property :closed planning)))
		 (when closed (concat org-closed-string " [" closed "]")))
	       (let ((deadline (org-element-property :deadline planning)))
		 (when deadline (concat org-deadline-string " <" deadline ">")))
	       (let ((scheduled (org-element-property :scheduled planning)))
		 (when scheduled
		   (concat org-scheduled-string " <" scheduled ">")))))
   " "))


;;;; Property Drawer

(defun org-element-property-drawer-parser (limit)
  "Parse a property drawer.

LIMIT bounds the search.

Return a list whose CAR is `property-drawer' and CDR is a plist
containing `:begin', `:end', `:hiddenp', `:contents-begin',
`:contents-end', `:properties' and `:post-blank' keywords.

Assume point is at the beginning of the property drawer."
  (save-excursion
    (let ((case-fold-search t)
	  (begin (point))
	  (prop-begin (progn (forward-line) (point)))
	  (hidden (org-invisible-p2))
	  (properties
	   (let (val)
	     (while (not (looking-at "^[ \t]*:END:[ \t]*$"))
	       (when (looking-at "[ \t]*:\\([A-Za-z][-_A-Za-z0-9]*\\):")
		 (push (cons (org-match-string-no-properties 1)
			     (org-trim
			      (buffer-substring-no-properties
			       (match-end 0) (point-at-eol))))
		       val))
	       (forward-line))
	     val))
	  (prop-end (progn (re-search-forward "^[ \t]*:END:" limit t)
			   (point-at-bol)))
	  (pos-before-blank (progn (forward-line) (point)))
	  (end (progn (skip-chars-forward " \r\t\n" limit)
		      (skip-chars-backward " \t")
		      (if (bolp) (point) (line-end-position)))))
      (list 'property-drawer
	    (list :begin begin
		  :end end
		  :hiddenp hidden
		  :properties properties
		  :post-blank (count-lines pos-before-blank end))))))

(defun org-element-property-drawer-interpreter (property-drawer contents)
  "Interpret PROPERTY-DRAWER element as Org syntax.
CONTENTS is nil."
  (let ((props (org-element-property :properties property-drawer)))
    (concat
     ":PROPERTIES:\n"
     (mapconcat (lambda (p)
		  (format org-property-format (format ":%s:" (car p)) (cdr p)))
		(nreverse props) "\n")
     "\n:END:")))


;;;; Quote Section

(defun org-element-quote-section-parser (limit)
  "Parse a quote section.

LIMIT bounds the search.

Return a list whose CAR is `quote-section' and CDR is a plist
containing `:begin', `:end', `:value' and `:post-blank' keywords.

Assume point is at beginning of the section."
  (save-excursion
    (let* ((begin (point))
	   (end (progn (org-with-limited-levels (outline-next-heading))
		       (point)))
	   (pos-before-blank (progn (skip-chars-backward " \r\t\n")
				    (forward-line)
				    (point)))
	   (value (buffer-substring-no-properties begin pos-before-blank)))
      (list 'quote-section
	    (list :begin begin
		  :end end
		  :value value
		  :post-blank (count-lines pos-before-blank end))))))

(defun org-element-quote-section-interpreter (quote-section contents)
  "Interpret QUOTE-SECTION element as Org syntax.
CONTENTS is nil."
  (org-element-property :value quote-section))


;;;; Src Block

(defun org-element-src-block-parser (limit)
  "Parse a src block.

LIMIT bounds the search.

Return a list whose CAR is `src-block' and CDR is a plist
containing `:language', `:switches', `:parameters', `:begin',
`:end', `:hiddenp', `:number-lines', `:retain-labels',
`:use-labels', `:label-fmt', `:preserve-indent', `:value' and
`:post-blank' keywords.

Assume point is at the beginning of the block."
  (let ((case-fold-search t))
    (if (not (save-excursion (re-search-forward "^[ \t]*#\\+END_SRC[ \t]*$"
						limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((contents-end (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 ;; Get beginning position.
		 (begin (car keywords))
		 ;; Get language as a string.
		 (language
		  (progn
		    (looking-at
		     (concat "^[ \t]*#\\+BEGIN_SRC"
			     "\\(?: +\\(\\S-+\\)\\)?"
			     "\\(\\(?: +\\(?:-l \".*?\"\\|[-+][A-Za-z]\\)\\)+\\)?"
			     "\\(.*\\)[ \t]*$"))
		    (org-match-string-no-properties 1)))
		 ;; Get switches.
		 (switches (org-match-string-no-properties 2))
		 ;; Get parameters.
		 (parameters (org-match-string-no-properties 3))
		 ;; Switches analysis
		 (number-lines (cond ((not switches) nil)
				     ((string-match "-n\\>" switches) 'new)
				     ((string-match "+n\\>" switches) 'continued)))
		 (preserve-indent (and switches (string-match "-i\\>" switches)))
		 (label-fmt (and switches
				 (string-match "-l +\"\\([^\"\n]+\\)\"" switches)
				 (match-string 1 switches)))
		 ;; Should labels be retained in (or stripped from)
		 ;; src blocks?
		 (retain-labels
		  (or (not switches)
		      (not (string-match "-r\\>" switches))
		      (and number-lines (string-match "-k\\>" switches))))
		 ;; What should code-references use - labels or
		 ;; line-numbers?
		 (use-labels
		  (or (not switches)
		      (and retain-labels (not (string-match "-k\\>" switches)))))
		 ;; Get visibility status.
		 (hidden (progn (forward-line) (org-invisible-p2)))
		 ;; Retrieve code.
		 (value (org-unescape-code-in-string
			 (buffer-substring-no-properties (point) contents-end)))
		 (pos-before-blank (progn (goto-char contents-end)
					  (forward-line)
					  (point)))
		 ;; Get position after ending blank lines.
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'src-block
		  (nconc
		   (list :language language
			 :switches (and (org-string-nw-p switches)
					(org-trim switches))
			 :parameters (and (org-string-nw-p parameters)
					  (org-trim parameters))
			 :begin begin
			 :end end
			 :number-lines number-lines
			 :preserve-indent preserve-indent
			 :retain-labels retain-labels
			 :use-labels use-labels
			 :label-fmt label-fmt
			 :hiddenp hidden
			 :value value
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-src-block-interpreter (src-block contents)
  "Interpret SRC-BLOCK element as Org syntax.
CONTENTS is nil."
  (let ((lang (org-element-property :language src-block))
	(switches (org-element-property :switches src-block))
	(params (org-element-property :parameters src-block))
	(value (let ((val (org-element-property :value src-block)))
		 (cond
		  (org-src-preserve-indentation val)
		  ((zerop org-edit-src-content-indentation)
		   (org-remove-indentation val))
		  (t
		   (let ((ind (make-string
			       org-edit-src-content-indentation 32)))
		     (replace-regexp-in-string
		      "\\(^\\)[ \t]*\\S-" ind
		      (org-remove-indentation val) nil nil 1)))))))
    (concat (format "#+BEGIN_SRC%s\n"
		    (concat (and lang (concat " " lang))
			    (and switches (concat " " switches))
			    (and params (concat " " params))))
	    (org-escape-code-in-string value)
	    "#+END_SRC")))


;;;; Table

(defun org-element-table-parser (limit)
  "Parse a table at point.

LIMIT bounds the search.

Return a list whose CAR is `table' and CDR is a plist containing
`:begin', `:end', `:tblfm', `:type', `:contents-begin',
`:contents-end', `:value' and `:post-blank' keywords.

Assume point is at the beginning of the table."
  (save-excursion
    (let* ((case-fold-search t)
	   (table-begin (point))
	   (type (if (org-at-table.el-p) 'table.el 'org))
	   (keywords (org-element--collect-affiliated-keywords))
	   (begin (car keywords))
	   (table-end
	    (if (re-search-forward org-table-any-border-regexp limit 'm)
		(goto-char (match-beginning 0))
	      (point)))
	   (tblfm (let (acc)
		    (while (looking-at "[ \t]*#\\+TBLFM: +\\(.*\\)[ \t]*$")
		      (push (org-match-string-no-properties 1) acc)
		      (forward-line))
		    acc))
	   (pos-before-blank (point))
	   (end (progn (skip-chars-forward " \r\t\n" limit)
		       (skip-chars-backward " \t")
		       (if (bolp) (point) (line-end-position)))))
      (list 'table
	    (nconc
	     (list :begin begin
		   :end end
		   :type type
		   :tblfm tblfm
		   ;; Only `org' tables have contents.  `table.el' tables
		   ;; use a `:value' property to store raw table as
		   ;; a string.
		   :contents-begin (and (eq type 'org) table-begin)
		   :contents-end (and (eq type 'org) table-end)
		   :value (and (eq type 'table.el)
			       (buffer-substring-no-properties
				table-begin table-end))
		   :post-blank (count-lines pos-before-blank end))
	     (cadr keywords))))))

(defun org-element-table-interpreter (table contents)
  "Interpret TABLE element as Org syntax.
CONTENTS is nil."
  (if (eq (org-element-property :type table) 'table.el)
      (org-remove-indentation (org-element-property :value table))
    (concat (with-temp-buffer (insert contents)
			      (org-table-align)
			      (buffer-string))
	    (mapconcat (lambda (fm) (concat "#+TBLFM: " fm))
		       (reverse (org-element-property :tblfm table))
		       "\n"))))


;;;; Table Row

(defun org-element-table-row-parser (limit)
  "Parse table row at point.

LIMIT bounds the search.

Return a list whose CAR is `table-row' and CDR is a plist
containing `:begin', `:end', `:contents-begin', `:contents-end',
`:type' and `:post-blank' keywords."
  (save-excursion
    (let* ((type (if (looking-at "^[ \t]*|-") 'rule 'standard))
	   (begin (point))
	   ;; A table rule has no contents.  In that case, ensure
	   ;; CONTENTS-BEGIN matches CONTENTS-END.
	   (contents-begin (and (eq type 'standard)
				(search-forward "|")
				(point)))
	   (contents-end (and (eq type 'standard)
			      (progn
				(end-of-line)
				(skip-chars-backward " \t")
				(point))))
	   (end (progn (forward-line) (point))))
      (list 'table-row
	    (list :type type
		  :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank 0)))))

(defun org-element-table-row-interpreter (table-row contents)
  "Interpret TABLE-ROW element as Org syntax.
CONTENTS is the contents of the table row."
  (if (eq (org-element-property :type table-row) 'rule) "|-"
    (concat "| " contents)))


;;;; Verse Block

(defun org-element-verse-block-parser (limit)
  "Parse a verse block.

LIMIT bounds the search.

Return a list whose CAR is `verse-block' and CDR is a plist
containing `:begin', `:end', `:contents-begin', `:contents-end',
`:hiddenp' and `:post-blank' keywords.

Assume point is at beginning of the block."
  (let ((case-fold-search t))
    (if (not (save-excursion
	       (re-search-forward "^[ \t]*#\\+END_VERSE[ \t]*$" limit t)))
	;; Incomplete block: parse it as a paragraph.
	(org-element-paragraph-parser limit)
      (let ((contents-end (match-beginning 0)))
	(save-excursion
	  (let* ((keywords (org-element--collect-affiliated-keywords))
		 (begin (car keywords))
		 (hidden (progn (forward-line) (org-invisible-p2)))
		 (contents-begin (point))
		 (pos-before-blank (progn (goto-char contents-end)
					  (forward-line)
					  (point)))
		 (end (progn (skip-chars-forward " \r\t\n" limit)
			     (skip-chars-backward " \t")
			     (if (bolp) (point) (line-end-position)))))
	    (list 'verse-block
		  (nconc
		   (list :begin begin
			 :end end
			 :contents-begin contents-begin
			 :contents-end contents-end
			 :hiddenp hidden
			 :post-blank (count-lines pos-before-blank end))
		   (cadr keywords)))))))))

(defun org-element-verse-block-interpreter (verse-block contents)
  "Interpret VERSE-BLOCK element as Org syntax.
CONTENTS is verse block contents."
  (format "#+BEGIN_VERSE\n%s#+END_VERSE" contents))



;;; Objects
;;
;; Unlike to elements, interstices can be found between objects.
;; That's why, along with the parser, successor functions are provided
;; for each object.  Some objects share the same successor (i.e. `code'
;; and `verbatim' objects).
;;
;; A successor must accept a single argument bounding the search.  It
;; will return either a cons cell whose CAR is the object's type, as
;; a symbol, and CDR the position of its next occurrence, or nil.
;;
;; Successors follow the naming convention:
;; org-element-NAME-successor, where NAME is the name of the
;; successor, as defined in `org-element-all-successors'.
;;
;; Some object types (i.e. `italic') are recursive.  Restrictions on
;; object types they can contain will be specified in
;; `org-element-object-restrictions'.
;;
;; Adding a new type of object is simple.  Implement a successor,
;; a parser, and an interpreter for it, all following the naming
;; convention.  Register type in `org-element-all-objects' and
;; successor in `org-element-all-successors'.  Maybe tweak
;; restrictions about it, and that's it.


;;;; Bold

(defun org-element-bold-parser ()
  "Parse bold object at point.

Return a list whose CAR is `bold' and CDR is a plist with
`:begin', `:end', `:contents-begin' and `:contents-end' and
`:post-blank' keywords.

Assume point is at the first star marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (contents-begin (match-beginning 4))
	  (contents-end (match-end 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'bold
	    (list :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-bold-interpreter (bold contents)
  "Interpret BOLD object as Org syntax.
CONTENTS is the contents of the object."
  (format "*%s*" contents))

(defun org-element-text-markup-successor (limit)
  "Search for the next text-markup object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is a symbol among `bold',
`italic', `underline', `strike-through', `code' and `verbatim'
and CDR is beginning position."
  (save-excursion
    (unless (bolp) (backward-char))
    (when (re-search-forward org-emph-re limit t)
      (let ((marker (match-string 3)))
	(cons (cond
	       ((equal marker "*") 'bold)
	       ((equal marker "/") 'italic)
	       ((equal marker "_") 'underline)
	       ((equal marker "+") 'strike-through)
	       ((equal marker "~") 'code)
	       ((equal marker "=") 'verbatim)
	       (t (error "Unknown marker at %d" (match-beginning 3))))
	      (match-beginning 2))))))


;;;; Code

(defun org-element-code-parser ()
  "Parse code object at point.

Return a list whose CAR is `code' and CDR is a plist with
`:value', `:begin', `:end' and `:post-blank' keywords.

Assume point is at the first tilde marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (value (org-match-string-no-properties 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'code
	    (list :value value
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-code-interpreter (code contents)
  "Interpret CODE object as Org syntax.
CONTENTS is nil."
  (format "~%s~" (org-element-property :value code)))


;;;; Entity

(defun org-element-entity-parser ()
  "Parse entity at point.

Return a list whose CAR is `entity' and CDR a plist with
`:begin', `:end', `:latex', `:latex-math-p', `:html', `:latin1',
`:utf-8', `:ascii', `:use-brackets-p' and `:post-blank' as
keywords.

Assume point is at the beginning of the entity."
  (save-excursion
    (looking-at "\\\\\\(there4\\|sup[123]\\|frac[13][24]\\|[a-zA-Z]+\\)\\($\\|{}\\|[^[:alpha:]]\\)")
    (let* ((value (org-entity-get (match-string 1)))
	   (begin (match-beginning 0))
	   (bracketsp (string= (match-string 2) "{}"))
	   (post-blank (progn (goto-char (match-end 1))
			      (when bracketsp (forward-char 2))
			      (skip-chars-forward " \t")))
	   (end (point)))
      (list 'entity
	    (list :name (car value)
		  :latex (nth 1 value)
		  :latex-math-p (nth 2 value)
		  :html (nth 3 value)
		  :ascii (nth 4 value)
		  :latin1 (nth 5 value)
		  :utf-8 (nth 6 value)
		  :begin begin
		  :end end
		  :use-brackets-p bracketsp
		  :post-blank post-blank)))))

(defun org-element-entity-interpreter (entity contents)
  "Interpret ENTITY object as Org syntax.
CONTENTS is nil."
  (concat "\\"
	  (org-element-property :name entity)
	  (when (org-element-property :use-brackets-p entity) "{}")))

(defun org-element-latex-or-entity-successor (limit)
  "Search for the next latex-fragment or entity object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `entity' or
`latex-fragment' and CDR is beginning position."
  (save-excursion
    (unless (bolp) (backward-char))
    (let ((matchers
	   (remove "begin" (plist-get org-format-latex-options :matchers)))
	  ;; ENTITY-RE matches both LaTeX commands and Org entities.
	  (entity-re
	   "\\\\\\(there4\\|sup[123]\\|frac[13][24]\\|[a-zA-Z]+\\)\\($\\|{}\\|[^[:alpha:]]\\)"))
      (when (re-search-forward
	     (concat (mapconcat (lambda (e) (nth 1 (assoc e org-latex-regexps)))
				matchers "\\|")
		     "\\|" entity-re)
	     limit t)
	(goto-char (match-beginning 0))
	(if (looking-at entity-re)
	    ;; Determine if it's a real entity or a LaTeX command.
	    (cons (if (org-entity-get (match-string 1)) 'entity 'latex-fragment)
		  (match-beginning 0))
	  ;; No entity nor command: point is at a LaTeX fragment.
	  ;; Determine its type to get the correct beginning position.
	  (cons 'latex-fragment
		(catch 'return
		  (mapc (lambda (e)
			  (when (looking-at (nth 1 (assoc e org-latex-regexps)))
			    (throw 'return
				   (match-beginning
				    (nth 2 (assoc e org-latex-regexps))))))
			matchers)
		  (point))))))))


;;;; Export Snippet

(defun org-element-export-snippet-parser ()
  "Parse export snippet at point.

Return a list whose CAR is `export-snippet' and CDR a plist with
`:begin', `:end', `:back-end', `:value' and `:post-blank' as
keywords.

Assume point is at the beginning of the snippet."
  (save-excursion
    (re-search-forward "@@\\([-A-Za-z0-9]+\\):" nil t)
    (let* ((begin (match-beginning 0))
	   (back-end (org-match-string-no-properties 1))
	   (value (buffer-substring-no-properties
		   (point)
		   (progn (re-search-forward "@@" nil t) (match-beginning 0))))
	   (post-blank (skip-chars-forward " \t"))
	   (end (point)))
      (list 'export-snippet
	    (list :back-end back-end
		  :value value
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-export-snippet-interpreter (export-snippet contents)
  "Interpret EXPORT-SNIPPET object as Org syntax.
CONTENTS is nil."
  (format "@@%s:%s@@"
	  (org-element-property :back-end export-snippet)
	  (org-element-property :value export-snippet)))

(defun org-element-export-snippet-successor (limit)
  "Search for the next export-snippet object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `export-snippet' and CDR
its beginning position."
  (save-excursion
    (let (beg)
      (when (and (re-search-forward "@@[-A-Za-z0-9]+:" limit t)
		 (setq beg (match-beginning 0))
		 (search-forward "@@" limit t))
	(cons 'export-snippet beg)))))


;;;; Footnote Reference

(defun org-element-footnote-reference-parser ()
  "Parse footnote reference at point.

Return a list whose CAR is `footnote-reference' and CDR a plist
with `:label', `:type', `:inline-definition', `:begin', `:end'
and `:post-blank' as keywords."
  (save-excursion
    (looking-at org-footnote-re)
    (let* ((begin (point))
	   (label (or (org-match-string-no-properties 2)
		      (org-match-string-no-properties 3)
		      (and (match-string 1)
			   (concat "fn:" (org-match-string-no-properties 1)))))
	   (type (if (or (not label) (match-string 1)) 'inline 'standard))
	   (inner-begin (match-end 0))
	   (inner-end
	    (let ((count 1))
	      (forward-char)
	      (while (and (> count 0) (re-search-forward "[][]" nil t))
		(if (equal (match-string 0) "[") (incf count) (decf count)))
	      (1- (point))))
	   (post-blank (progn (goto-char (1+ inner-end))
			      (skip-chars-forward " \t")))
	   (end (point))
	   (footnote-reference
	    (list 'footnote-reference
		  (list :label label
			:type type
			:begin begin
			:end end
			:post-blank post-blank))))
      (org-element-put-property
       footnote-reference :inline-definition
       (and (eq type 'inline)
	    (org-element-parse-secondary-string
	     (buffer-substring inner-begin inner-end)
	     (org-element-restriction 'footnote-reference)
	     footnote-reference))))))

(defun org-element-footnote-reference-interpreter (footnote-reference contents)
  "Interpret FOOTNOTE-REFERENCE object as Org syntax.
CONTENTS is nil."
  (let ((label (or (org-element-property :label footnote-reference) "fn:"))
	(def
	 (let ((inline-def
		(org-element-property :inline-definition footnote-reference)))
	   (if (not inline-def) ""
	     (concat ":" (org-element-interpret-data inline-def))))))
    (format "[%s]" (concat label def))))

(defun org-element-footnote-reference-successor (limit)
  "Search for the next footnote-reference object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `footnote-reference' and
CDR is beginning position."
  (save-excursion
    (catch 'exit
      (while (re-search-forward org-footnote-re limit t)
	(save-excursion
	  (let ((beg (match-beginning 0))
		(count 1))
	    (backward-char)
	    (while (re-search-forward "[][]" limit t)
	      (if (equal (match-string 0) "[") (incf count) (decf count))
	      (when (zerop count)
		(throw 'exit (cons 'footnote-reference beg))))))))))


;;;; Inline Babel Call

(defun org-element-inline-babel-call-parser ()
  "Parse inline babel call at point.

Return a list whose CAR is `inline-babel-call' and CDR a plist
with `:begin', `:end', `:info' and `:post-blank' as keywords.

Assume point is at the beginning of the babel call."
  (save-excursion
    (unless (bolp) (backward-char))
    (looking-at org-babel-inline-lob-one-liner-regexp)
    (let ((info (save-match-data (org-babel-lob-get-info)))
	  (begin (match-end 1))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'inline-babel-call
	    (list :begin begin
		  :end end
		  :info info
		  :post-blank post-blank)))))

(defun org-element-inline-babel-call-interpreter (inline-babel-call contents)
  "Interpret INLINE-BABEL-CALL object as Org syntax.
CONTENTS is nil."
  (let* ((babel-info (org-element-property :info inline-babel-call))
	 (main-source (car babel-info))
	 (post-options (nth 1 babel-info)))
    (concat "call_"
	    (if (string-match "\\[\\(\\[.*?\\]\\)\\]" main-source)
		;; Remove redundant square brackets.
		(replace-match
		 (match-string 1 main-source) nil nil main-source)
	      main-source)
	    (and post-options (format "[%s]" post-options)))))

(defun org-element-inline-babel-call-successor (limit)
  "Search for the next inline-babel-call object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `inline-babel-call' and
CDR is beginning position."
  (save-excursion
    ;; Use a simplified version of
    ;; `org-babel-inline-lob-one-liner-regexp'.
    (when (re-search-forward
	   "call_\\([^()\n]+?\\)\\(?:\\[.*?\\]\\)?([^\n]*?)\\(\\[.*?\\]\\)?"
	   limit t)
      (cons 'inline-babel-call (match-beginning 0)))))


;;;; Inline Src Block

(defun org-element-inline-src-block-parser ()
  "Parse inline source block at point.

LIMIT bounds the search.

Return a list whose CAR is `inline-src-block' and CDR a plist
with `:begin', `:end', `:language', `:value', `:parameters' and
`:post-blank' as keywords.

Assume point is at the beginning of the inline src block."
  (save-excursion
    (unless (bolp) (backward-char))
    (looking-at org-babel-inline-src-block-regexp)
    (let ((begin (match-beginning 1))
	  (language (org-match-string-no-properties 2))
	  (parameters (org-match-string-no-properties 4))
	  (value (org-match-string-no-properties 5))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'inline-src-block
	    (list :language language
		  :value value
		  :parameters parameters
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-inline-src-block-interpreter (inline-src-block contents)
  "Interpret INLINE-SRC-BLOCK object as Org syntax.
CONTENTS is nil."
  (let ((language (org-element-property :language inline-src-block))
	(arguments (org-element-property :parameters inline-src-block))
	(body (org-element-property :value inline-src-block)))
    (format "src_%s%s{%s}"
	    language
	    (if arguments (format "[%s]" arguments) "")
	    body)))

(defun org-element-inline-src-block-successor (limit)
  "Search for the next inline-babel-call element.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `inline-babel-call' and
CDR is beginning position."
  (save-excursion
    (unless (bolp) (backward-char))
    (when (re-search-forward org-babel-inline-src-block-regexp limit t)
      (cons 'inline-src-block (match-beginning 1)))))

;;;; Italic

(defun org-element-italic-parser ()
  "Parse italic object at point.

Return a list whose CAR is `italic' and CDR is a plist with
`:begin', `:end', `:contents-begin' and `:contents-end' and
`:post-blank' keywords.

Assume point is at the first slash marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (contents-begin (match-beginning 4))
	  (contents-end (match-end 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'italic
	    (list :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-italic-interpreter (italic contents)
  "Interpret ITALIC object as Org syntax.
CONTENTS is the contents of the object."
  (format "/%s/" contents))


;;;; Latex Fragment

(defun org-element-latex-fragment-parser ()
  "Parse latex fragment at point.

Return a list whose CAR is `latex-fragment' and CDR a plist with
`:value', `:begin', `:end', and `:post-blank' as keywords.

Assume point is at the beginning of the latex fragment."
  (save-excursion
    (let* ((begin (point))
	   (substring-match
	    (catch 'exit
	      (mapc (lambda (e)
		      (let ((latex-regexp (nth 1 (assoc e org-latex-regexps))))
			(when (or (looking-at latex-regexp)
				  (and (not (bobp))
				       (save-excursion
					 (backward-char)
					 (looking-at latex-regexp))))
			  (throw 'exit (nth 2 (assoc e org-latex-regexps))))))
		    (plist-get org-format-latex-options :matchers))
	      ;; None found: it's a macro.
	      (looking-at "\\\\[a-zA-Z]+\\*?\\(\\(\\[[^][\n{}]*\\]\\)\\|\\({[^{}\n]*}\\)\\)*")
	      0))
	   (value (match-string-no-properties substring-match))
	   (post-blank (progn (goto-char (match-end substring-match))
			      (skip-chars-forward " \t")))
	   (end (point)))
      (list 'latex-fragment
	    (list :value value
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-latex-fragment-interpreter (latex-fragment contents)
  "Interpret LATEX-FRAGMENT object as Org syntax.
CONTENTS is nil."
  (org-element-property :value latex-fragment))

;;;; Line Break

(defun org-element-line-break-parser ()
  "Parse line break at point.

Return a list whose CAR is `line-break', and CDR a plist with
`:begin', `:end' and `:post-blank' keywords.

Assume point is at the beginning of the line break."
  (list 'line-break (list :begin (point) :end (point-at-eol) :post-blank 0)))

(defun org-element-line-break-interpreter (line-break contents)
  "Interpret LINE-BREAK object as Org syntax.
CONTENTS is nil."
  "\\\\")

(defun org-element-line-break-successor (limit)
  "Search for the next line-break object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `line-break' and CDR is
beginning position."
  (save-excursion
    (let ((beg (and (re-search-forward "[^\\\\]\\(\\\\\\\\\\)[ \t]*$" limit t)
		    (goto-char (match-beginning 1)))))
      ;; A line break can only happen on a non-empty line.
      (when (and beg (re-search-backward "\\S-" (point-at-bol) t))
	(cons 'line-break beg)))))


;;;; Link

(defun org-element-link-parser ()
  "Parse link at point.

Return a list whose CAR is `link' and CDR a plist with `:type',
`:path', `:raw-link', `:begin', `:end', `:contents-begin',
`:contents-end' and `:post-blank' as keywords.

Assume point is at the beginning of the link."
  (save-excursion
    (let ((begin (point))
	  end contents-begin contents-end link-end post-blank path type
	  raw-link link)
      (cond
       ;; Type 1: Text targeted from a radio target.
       ((and org-target-link-regexp (looking-at org-target-link-regexp))
	(setq type "radio"
	      link-end (match-end 0)
	      path (org-match-string-no-properties 0)))
       ;; Type 2: Standard link, i.e. [[http://orgmode.org][homepage]]
       ((looking-at org-bracket-link-regexp)
	(setq contents-begin (match-beginning 3)
	      contents-end (match-end 3)
	      link-end (match-end 0)
	      ;; RAW-LINK is the original link.
	      raw-link (org-match-string-no-properties 1)
	      link (org-translate-link
		    (org-link-expand-abbrev
		     (org-link-unescape raw-link))))
	;; Determine TYPE of link and set PATH accordingly.
	(cond
	 ;; File type.
	 ((or (file-name-absolute-p link) (string-match "^\\.\\.?/" link))
	  (setq type "file" path link))
	 ;; Explicit type (http, irc, bbdb...).  See `org-link-types'.
	 ((string-match org-link-re-with-space3 link)
	  (setq type (match-string 1 link) path (match-string 2 link)))
	 ;; Id type: PATH is the id.
	 ((string-match "^id:\\([-a-f0-9]+\\)" link)
	  (setq type "id" path (match-string 1 link)))
	 ;; Code-ref type: PATH is the name of the reference.
	 ((string-match "^(\\(.*\\))$" link)
	  (setq type "coderef" path (match-string 1 link)))
	 ;; Custom-id type: PATH is the name of the custom id.
	 ((= (aref link 0) ?#)
	  (setq type "custom-id" path (substring link 1)))
	 ;; Fuzzy type: Internal link either matches a target, an
	 ;; headline name or nothing.  PATH is the target or
	 ;; headline's name.
	 (t (setq type "fuzzy" path link))))
       ;; Type 3: Plain link, i.e. http://orgmode.org
       ((looking-at org-plain-link-re)
	(setq raw-link (org-match-string-no-properties 0)
	      type (org-match-string-no-properties 1)
	      path (org-match-string-no-properties 2)
	      link-end (match-end 0)))
       ;; Type 4: Angular link, i.e. <http://orgmode.org>
       ((looking-at org-angle-link-re)
	(setq raw-link (buffer-substring-no-properties
			(match-beginning 1) (match-end 2))
	      type (org-match-string-no-properties 1)
	      path (org-match-string-no-properties 2)
	      link-end (match-end 0))))
      ;; In any case, deduce end point after trailing white space from
      ;; LINK-END variable.
      (setq post-blank (progn (goto-char link-end) (skip-chars-forward " \t"))
	    end (point))
      (list 'link
	    (list :type type
		  :path path
		  :raw-link (or raw-link path)
		  :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-link-interpreter (link contents)
  "Interpret LINK object as Org syntax.
CONTENTS is the contents of the object, or nil."
  (let ((type (org-element-property :type link))
	(raw-link (org-element-property :raw-link link)))
    (if (string= type "radio") raw-link
      (format "[[%s]%s]"
	      raw-link
	      (if contents (format "[%s]" contents) "")))))

(defun org-element-link-successor (limit)
  "Search for the next link object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `link' and CDR is
beginning position."
  (save-excursion
    (let ((link-regexp
	   (if (not org-target-link-regexp) org-any-link-re
	     (concat org-any-link-re "\\|" org-target-link-regexp))))
      (when (re-search-forward link-regexp limit t)
	(cons 'link (match-beginning 0))))))


;;;; Macro

(defun org-element-macro-parser ()
  "Parse macro at point.

Return a list whose CAR is `macro' and CDR a plist with `:key',
`:args', `:begin', `:end', `:value' and `:post-blank' as
keywords.

Assume point is at the macro."
  (save-excursion
    (looking-at "{{{\\([a-zA-Z][-a-zA-Z0-9_]*\\)\\(([ \t\n]*\\([^\000]*?\\))\\)?}}}")
    (let ((begin (point))
	  (key (downcase (org-match-string-no-properties 1)))
	  (value (org-match-string-no-properties 0))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point))
	  (args (let ((args (org-match-string-no-properties 3)) args2)
		  (when args
		    ;; Do not use `org-split-string' since empty
		    ;; strings are meaningful here.
		    (setq args (split-string args ","))
		    (while args
		      (while (string-match "\\\\\\'" (car args))
			;; Repair bad splits, when comma is protected,
                        ;; and thus not a real separator.
			(setcar (cdr args) (concat (substring (car args) 0 -1)
						   "," (nth 1 args)))
			(pop args))
		      (push (pop args) args2))
		    (mapcar 'org-trim (nreverse args2))))))
      (list 'macro
	    (list :key key
		  :value value
		  :args args
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-macro-interpreter (macro contents)
  "Interpret MACRO object as Org syntax.
CONTENTS is nil."
  (org-element-property :value macro))

(defun org-element-macro-successor (limit)
  "Search for the next macro object.

LIMIT bounds the search.

Return value is cons cell whose CAR is `macro' and CDR is
beginning position."
  (save-excursion
    (when (re-search-forward
	   "{{{\\([a-zA-Z][-a-zA-Z0-9_]*\\)\\(([ \t\n]*\\([^\000]*?\\))\\)?}}}"
	   limit t)
      (cons 'macro (match-beginning 0)))))


;;;; Radio-target

(defun org-element-radio-target-parser ()
  "Parse radio target at point.

Return a list whose CAR is `radio-target' and CDR a plist with
`:begin', `:end', `:contents-begin', `:contents-end', `:value'
and `:post-blank' as keywords.

Assume point is at the radio target."
  (save-excursion
    (looking-at org-radio-target-regexp)
    (let ((begin (point))
	  (contents-begin (match-beginning 1))
	  (contents-end (match-end 1))
	  (value (org-match-string-no-properties 1))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'radio-target
	    (list :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank
		  :value value)))))

(defun org-element-radio-target-interpreter (target contents)
  "Interpret TARGET object as Org syntax.
CONTENTS is the contents of the object."
  (concat "<<<" contents ">>>"))

(defun org-element-radio-target-successor (limit)
  "Search for the next radio-target object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `radio-target' and CDR
is beginning position."
  (save-excursion
    (when (re-search-forward org-radio-target-regexp limit t)
      (cons 'radio-target (match-beginning 0)))))


;;;; Statistics Cookie

(defun org-element-statistics-cookie-parser ()
  "Parse statistics cookie at point.

Return a list whose CAR is `statistics-cookie', and CDR a plist
with `:begin', `:end', `:value' and `:post-blank' keywords.

Assume point is at the beginning of the statistics-cookie."
  (save-excursion
    (looking-at "\\[[0-9]*\\(%\\|/[0-9]*\\)\\]")
    (let* ((begin (point))
	   (value (buffer-substring-no-properties
		   (match-beginning 0) (match-end 0)))
	   (post-blank (progn (goto-char (match-end 0))
			      (skip-chars-forward " \t")))
	   (end (point)))
      (list 'statistics-cookie
	    (list :begin begin
		  :end end
		  :value value
		  :post-blank post-blank)))))

(defun org-element-statistics-cookie-interpreter (statistics-cookie contents)
  "Interpret STATISTICS-COOKIE object as Org syntax.
CONTENTS is nil."
  (org-element-property :value statistics-cookie))

(defun org-element-statistics-cookie-successor (limit)
  "Search for the next statistics cookie object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `statistics-cookie' and
CDR is beginning position."
  (save-excursion
    (when (re-search-forward "\\[[0-9]*\\(%\\|/[0-9]*\\)\\]" limit t)
      (cons 'statistics-cookie (match-beginning 0)))))


;;;; Strike-Through

(defun org-element-strike-through-parser ()
  "Parse strike-through object at point.

Return a list whose CAR is `strike-through' and CDR is a plist
with `:begin', `:end', `:contents-begin' and `:contents-end' and
`:post-blank' keywords.

Assume point is at the first plus sign marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (contents-begin (match-beginning 4))
	  (contents-end (match-end 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'strike-through
	    (list :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-strike-through-interpreter (strike-through contents)
  "Interpret STRIKE-THROUGH object as Org syntax.
CONTENTS is the contents of the object."
  (format "+%s+" contents))


;;;; Subscript

(defun org-element-subscript-parser ()
  "Parse subscript at point.

Return a list whose CAR is `subscript' and CDR a plist with
`:begin', `:end', `:contents-begin', `:contents-end',
`:use-brackets-p' and `:post-blank' as keywords.

Assume point is at the underscore."
  (save-excursion
    (unless (bolp) (backward-char))
    (let ((bracketsp (if (looking-at org-match-substring-with-braces-regexp)
			 t
		       (not (looking-at org-match-substring-regexp))))
	  (begin (match-beginning 2))
	  (contents-begin (or (match-beginning 5)
			      (match-beginning 3)))
	  (contents-end (or (match-end 5) (match-end 3)))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'subscript
	    (list :begin begin
		  :end end
		  :use-brackets-p bracketsp
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-subscript-interpreter (subscript contents)
  "Interpret SUBSCRIPT object as Org syntax.
CONTENTS is the contents of the object."
  (format
   (if (org-element-property :use-brackets-p subscript) "_{%s}" "_%s")
   contents))

(defun org-element-sub/superscript-successor  (limit)
  "Search for the next sub/superscript object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is either `subscript' or
`superscript' and CDR is beginning position."
  (save-excursion
    (unless (bolp) (backward-char))
    (when (re-search-forward org-match-substring-regexp limit t)
      (cons (if (string= (match-string 2) "_") 'subscript 'superscript)
	    (match-beginning 2)))))


;;;; Superscript

(defun org-element-superscript-parser ()
  "Parse superscript at point.

Return a list whose CAR is `superscript' and CDR a plist with
`:begin', `:end', `:contents-begin', `:contents-end',
`:use-brackets-p' and `:post-blank' as keywords.

Assume point is at the caret."
  (save-excursion
    (unless (bolp) (backward-char))
    (let ((bracketsp (if (looking-at org-match-substring-with-braces-regexp) t
		       (not (looking-at org-match-substring-regexp))))
	  (begin (match-beginning 2))
	  (contents-begin (or (match-beginning 5)
			      (match-beginning 3)))
	  (contents-end (or (match-end 5) (match-end 3)))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'superscript
	    (list :begin begin
		  :end end
		  :use-brackets-p bracketsp
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-superscript-interpreter (superscript contents)
  "Interpret SUPERSCRIPT object as Org syntax.
CONTENTS is the contents of the object."
  (format
   (if (org-element-property :use-brackets-p superscript) "^{%s}" "^%s")
   contents))


;;;; Table Cell

(defun org-element-table-cell-parser ()
  "Parse table cell at point.

Return a list whose CAR is `table-cell' and CDR is a plist
containing `:begin', `:end', `:contents-begin', `:contents-end'
and `:post-blank' keywords."
  (looking-at "[ \t]*\\(.*?\\)[ \t]*|")
  (let* ((begin (match-beginning 0))
	 (end (match-end 0))
	 (contents-begin (match-beginning 1))
	 (contents-end (match-end 1)))
    (list 'table-cell
	  (list :begin begin
		:end end
		:contents-begin contents-begin
		:contents-end contents-end
		:post-blank 0))))

(defun org-element-table-cell-interpreter (table-cell contents)
  "Interpret TABLE-CELL element as Org syntax.
CONTENTS is the contents of the cell, or nil."
  (concat  " " contents " |"))

(defun org-element-table-cell-successor (limit)
  "Search for the next table-cell object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `table-cell' and CDR is
beginning position."
  (when (looking-at "[ \t]*.*?[ \t]+|") (cons 'table-cell (point))))


;;;; Target

(defun org-element-target-parser ()
  "Parse target at point.

Return a list whose CAR is `target' and CDR a plist with
`:begin', `:end', `:value' and `:post-blank' as keywords.

Assume point is at the target."
  (save-excursion
    (looking-at org-target-regexp)
    (let ((begin (point))
	  (value (org-match-string-no-properties 1))
	  (post-blank (progn (goto-char (match-end 0))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'target
	    (list :begin begin
		  :end end
		  :value value
		  :post-blank post-blank)))))

(defun org-element-target-interpreter (target contents)
  "Interpret TARGET object as Org syntax.
CONTENTS is nil."
  (format "<<%s>>" (org-element-property :value target)))

(defun org-element-target-successor (limit)
  "Search for the next target object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `target' and CDR is
beginning position."
  (save-excursion
    (when (re-search-forward org-target-regexp limit t)
      (cons 'target (match-beginning 0)))))


;;;; Timestamp

(defun org-element-timestamp-parser ()
  "Parse time stamp at point.

Return a list whose CAR is `timestamp', and CDR a plist with
`:type', `:begin', `:end', `:value' and `:post-blank' keywords.

Assume point is at the beginning of the timestamp."
  (save-excursion
    (let* ((begin (point))
	   (activep (eq (char-after) ?<))
	   (main-value
	    (progn
	      (looking-at "[<[]\\(\\(%%\\)?.*?\\)[]>]\\(?:--[<[]\\(.*?\\)[]>]\\)?")
	      (match-string-no-properties 1)))
	   (range-end (match-string-no-properties 3))
	   (type (cond ((match-string 2) 'diary)
		       ((and activep range-end) 'active-range)
		       (activep 'active)
		       (range-end 'inactive-range)
		       (t 'inactive)))
	   (post-blank (progn (goto-char (match-end 0))
			      (skip-chars-forward " \t")))
	   (end (point)))
      (list 'timestamp
	    (list :type type
		  :value main-value
		  :range-end range-end
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-timestamp-interpreter (timestamp contents)
  "Interpret TIMESTAMP object as Org syntax.
CONTENTS is nil."
  (let ((type (org-element-property :type timestamp) ))
    (concat
     (format (if (memq type '(inactive inactive-range)) "[%s]" "<%s>")
	     (org-element-property :value timestamp))
     (let ((range-end (org-element-property :range-end timestamp)))
       (when range-end
	 (concat "--"
		 (format (if (eq type 'inactive-range) "[%s]" "<%s>")
			 range-end)))))))

(defun org-element-timestamp-successor (limit)
  "Search for the next timestamp object.

LIMIT bounds the search.

Return value is a cons cell whose CAR is `timestamp' and CDR is
beginning position."
  (save-excursion
    (when (re-search-forward
	   (concat org-ts-regexp-both
		   "\\|"
		   "\\(?:<[0-9]+-[0-9]+-[0-9]+[^>\n]+?\\+[0-9]+[dwmy]>\\)"
		   "\\|"
		   "\\(?:<%%\\(?:([^>\n]+)\\)>\\)")
	   limit t)
      (cons 'timestamp (match-beginning 0)))))


;;;; Underline

(defun org-element-underline-parser ()
  "Parse underline object at point.

Return a list whose CAR is `underline' and CDR is a plist with
`:begin', `:end', `:contents-begin' and `:contents-end' and
`:post-blank' keywords.

Assume point is at the first underscore marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (contents-begin (match-beginning 4))
	  (contents-end (match-end 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'underline
	    (list :begin begin
		  :end end
		  :contents-begin contents-begin
		  :contents-end contents-end
		  :post-blank post-blank)))))

(defun org-element-underline-interpreter (underline contents)
  "Interpret UNDERLINE object as Org syntax.
CONTENTS is the contents of the object."
  (format "_%s_" contents))


;;;; Verbatim

(defun org-element-verbatim-parser ()
  "Parse verbatim object at point.

Return a list whose CAR is `verbatim' and CDR is a plist with
`:value', `:begin', `:end' and `:post-blank' keywords.

Assume point is at the first equal sign marker."
  (save-excursion
    (unless (bolp) (backward-char 1))
    (looking-at org-emph-re)
    (let ((begin (match-beginning 2))
	  (value (org-match-string-no-properties 4))
	  (post-blank (progn (goto-char (match-end 2))
			     (skip-chars-forward " \t")))
	  (end (point)))
      (list 'verbatim
	    (list :value value
		  :begin begin
		  :end end
		  :post-blank post-blank)))))

(defun org-element-verbatim-interpreter (verbatim contents)
  "Interpret VERBATIM object as Org syntax.
CONTENTS is nil."
  (format "=%s=" (org-element-property :value verbatim)))



;;; Parsing Element Starting At Point
;;
;; `org-element--current-element' is the core function of this section.
;; It returns the Lisp representation of the element starting at
;; point.
;;
;; `org-element--current-element' makes use of special modes.  They
;; are activated for fixed element chaining (i.e. `plain-list' >
;; `item') or fixed conditional element chaining (i.e. `headline' >
;; `section'). Special modes are: `first-section', `section',
;; `quote-section', `item' and `table-row'.

(defun org-element--current-element
  (limit &optional granularity special structure)
  "Parse the element starting at point.

LIMIT bounds the search.

Return value is a list like (TYPE PROPS) where TYPE is the type
of the element and PROPS a plist of properties associated to the
element.

Possible types are defined in `org-element-all-elements'.

Optional argument GRANULARITY determines the depth of the
recursion.  Allowed values are `headline', `greater-element',
`element', `object' or nil.  When it is broader than `object' (or
nil), secondary values will not be parsed, since they only
contain objects.

Optional argument SPECIAL, when non-nil, can be either
`first-section', `section', `quote-section', `table-row' and
`item'.

If STRUCTURE isn't provided but SPECIAL is set to `item', it will
be computed.

This function assumes point is always at the beginning of the
element it has to parse."
  (save-excursion
    ;; If point is at an affiliated keyword, try moving to the
    ;; beginning of the associated element.  If none is found, the
    ;; keyword is orphaned and will be treated as plain text.
    (when (looking-at org-element--affiliated-re)
      (let ((opoint (point)))
        (while (looking-at org-element--affiliated-re) (forward-line))
        (when (looking-at "[ \t]*$") (goto-char opoint))))
    (let ((case-fold-search t)
	  ;; Determine if parsing depth allows for secondary strings
	  ;; parsing.  It only applies to elements referenced in
	  ;; `org-element-secondary-value-alist'.
	  (raw-secondary-p (and granularity (not (eq granularity 'object)))))
      (cond
       ;; Item.
       ((eq special 'item)
	(org-element-item-parser limit structure raw-secondary-p))
       ;; Table Row.
       ((eq special 'table-row) (org-element-table-row-parser limit))
       ;; Headline.
       ((org-with-limited-levels (org-at-heading-p))
        (org-element-headline-parser limit raw-secondary-p))
       ;; Sections (must be checked after headline).
       ((eq special 'section) (org-element-section-parser limit))
       ((eq special 'quote-section) (org-element-quote-section-parser limit))
       ((eq special 'first-section)
	(org-element-section-parser
	 (or (save-excursion (org-with-limited-levels (outline-next-heading)))
	     limit)))
       ;; When not at bol, point is at the beginning of an item or
       ;; a footnote definition: next item is always a paragraph.
       ((not (bolp)) (org-element-paragraph-parser limit))
       ;; Planning and Clock.
       ((and (looking-at org-planning-or-clock-line-re))
	(if (equal (match-string 1) org-clock-string)
	    (org-element-clock-parser limit)
	  (org-element-planning-parser limit)))
       ;; Inlinetask.
       ((org-at-heading-p)
	(org-element-inlinetask-parser limit raw-secondary-p))
       ;; LaTeX Environment.
       ((looking-at "[ \t]*\\\\begin{\\([A-Za-z0-9*]+\\)}")
        (if (save-excursion
              (re-search-forward
	       (format "[ \t]*\\\\end{%s}[ \t]*"
		       (regexp-quote (match-string 1)))
	       nil t))
            (org-element-latex-environment-parser limit)
          (org-element-paragraph-parser limit)))
       ;; Drawer and Property Drawer.
       ((looking-at org-drawer-regexp)
        (let ((name (match-string 1)))
	  (cond
	   ((not (save-excursion
		   (re-search-forward "^[ \t]*:END:[ \t]*$" nil t)))
	    (org-element-paragraph-parser limit))
	   ((equal "PROPERTIES" name)
	    (org-element-property-drawer-parser limit))
	   (t (org-element-drawer-parser limit)))))
       ;; Fixed Width
       ((looking-at "[ \t]*:\\( \\|$\\)")
	(org-element-fixed-width-parser limit))
       ;; Inline Comments, Blocks, Babel Calls, Dynamic Blocks and
       ;; Keywords.
       ((looking-at "[ \t]*#")
	(goto-char (match-end 0))
	(cond ((looking-at "\\(?: \\|$\\)")
	       (beginning-of-line)
	       (org-element-comment-parser limit))
	      ((looking-at "\\+BEGIN_\\(\\S-+\\)")
	       (beginning-of-line)
	       (let ((parser (assoc (upcase (match-string 1))
				    org-element-block-name-alist)))
		 (if parser (funcall (cdr parser) limit)
		   (org-element-special-block-parser limit))))
	      ((looking-at "\\+CALL:")
	       (beginning-of-line)
	       (org-element-babel-call-parser limit))
	      ((looking-at "\\+BEGIN:? ")
	       (beginning-of-line)
	       (org-element-dynamic-block-parser limit))
	      ((looking-at "\\+\\S-+:")
	       (beginning-of-line)
	       (org-element-keyword-parser limit))
	      (t
	       (beginning-of-line)
	       (org-element-paragraph-parser limit))))
       ;; Footnote Definition.
       ((looking-at org-footnote-definition-re)
        (org-element-footnote-definition-parser limit))
       ;; Horizontal Rule.
       ((looking-at "[ \t]*-\\{5,\\}[ \t]*$")
        (org-element-horizontal-rule-parser limit))
       ;; Table.
       ((org-at-table-p t) (org-element-table-parser limit))
       ;; List.
       ((looking-at (org-item-re))
        (org-element-plain-list-parser limit (or structure (org-list-struct))))
       ;; Default element: Paragraph.
       (t (org-element-paragraph-parser limit))))))


;; Most elements can have affiliated keywords.  When looking for an
;; element beginning, we want to move before them, as they belong to
;; that element, and, in the meantime, collect information they give
;; into appropriate properties.  Hence the following function.
;;
;; Usage of optional arguments may not be obvious at first glance:
;;
;; - TRANS-LIST is used to polish keywords names that have evolved
;;   during Org history.  In example, even though =result= and
;;   =results= coexist, we want to have them under the same =result=
;;   property.  It's also true for "srcname" and "name", where the
;;   latter seems to be preferred nowadays (thus the "name" property).
;;
;; - CONSED allows to regroup multi-lines keywords under the same
;;   property, while preserving their own identity.  This is mostly
;;   used for "attr_latex" and al.
;;
;; - PARSED prepares a keyword value for export.  This is useful for
;;   "caption".  Objects restrictions for such keywords are defined in
;;   `org-element-object-restrictions'.
;;
;; - DUALS is used to take care of keywords accepting a main and an
;;   optional secondary values.  For example "results" has its
;;   source's name as the main value, and may have an hash string in
;;   optional square brackets as the secondary one.
;;
;; A keyword may belong to more than one category.

(defun org-element--collect-affiliated-keywords
  (&optional key-re trans-list consed parsed duals)
  "Collect affiliated keywords before point.

Optional argument KEY-RE is a regexp matching keywords, which
puts matched keyword in group 1.  It defaults to
`org-element--affiliated-re'.

TRANS-LIST is an alist where key is the keyword and value the
property name it should be translated to, without the colons.  It
defaults to `org-element-keyword-translation-alist'.

CONSED is a list of strings.  Any keyword belonging to that list
will have its value consed.  The check is done after keyword
translation.  It defaults to `org-element-multiple-keywords'.

PARSED is a list of strings.  Any keyword member of this list
will have its value parsed.  The check is done after keyword
translation.  If a keyword is a member of both CONSED and PARSED,
it's value will be a list of parsed strings.  It defaults to
`org-element-parsed-keywords'.

DUALS is a list of strings.  Any keyword member of this list can
have two parts: one mandatory and one optional.  Its value is
a cons cell whose CAR is the former, and the CDR the latter.  If
a keyword is a member of both PARSED and DUALS, both values will
be parsed.  It defaults to `org-element-dual-keywords'.

Return a list whose CAR is the position at the first of them and
CDR a plist of keywords and values."
  (save-excursion
    (let ((case-fold-search t)
	  (key-re (or key-re org-element--affiliated-re))
	  (trans-list (or trans-list org-element-keyword-translation-alist))
	  (consed (or consed org-element-multiple-keywords))
	  (parsed (or parsed org-element-parsed-keywords))
	  (duals (or duals org-element-dual-keywords))
	  ;; RESTRICT is the list of objects allowed in parsed
	  ;; keywords value.
	  (restrict (org-element-restriction 'keyword))
	  output)
      (unless (bobp)
	(while (and (not (bobp)) (progn (forward-line -1) (looking-at key-re)))
	  (let* ((raw-kwd (upcase (match-string 1)))
		 ;; Apply translation to RAW-KWD.  From there, KWD is
		 ;; the official keyword.
		 (kwd (or (cdr (assoc raw-kwd trans-list)) raw-kwd))
		 ;; Find main value for any keyword.
		 (value
		  (save-match-data
		    (org-trim
		     (buffer-substring-no-properties
		      (match-end 0) (point-at-eol)))))
		 ;; If KWD is a dual keyword, find its secondary
		 ;; value.  Maybe parse it.
		 (dual-value
		  (and (member kwd duals)
		       (let ((sec (org-match-string-no-properties 2)))
			 (if (or (not sec) (not (member kwd parsed))) sec
			   (org-element-parse-secondary-string sec restrict)))))
		 ;; Attribute a property name to KWD.
		 (kwd-sym (and kwd (intern (concat ":" (downcase kwd))))))
	    ;; Now set final shape for VALUE.
	    (when (member kwd parsed)
	      (setq value (org-element-parse-secondary-string value restrict)))
	    (when (member kwd duals)
	      ;; VALUE is mandatory.  Set it to nil if there is none.
	      (setq value (and value (cons value dual-value))))
	    ;; Attributes are always consed.
	    (when (or (member kwd consed) (string-match "^ATTR_" kwd))
	      (setq value (cons value (plist-get output kwd-sym))))
	    ;; Eventually store the new value in OUTPUT.
	    (setq output (plist-put output kwd-sym value))))
	(unless (looking-at key-re) (forward-line 1)))
      (list (point) output))))



;;; The Org Parser
;;
;; The two major functions here are `org-element-parse-buffer', which
;; parses Org syntax inside the current buffer, taking into account
;; region, narrowing, or even visibility if specified, and
;; `org-element-parse-secondary-string', which parses objects within
;; a given string.
;;
;; The (almost) almighty `org-element-map' allows to apply a function
;; on elements or objects matching some type, and accumulate the
;; resulting values.  In an export situation, it also skips unneeded
;; parts of the parse tree.

(defun org-element-parse-buffer (&optional granularity visible-only)
  "Recursively parse the buffer and return structure.
If narrowing is in effect, only parse the visible part of the
buffer.

Optional argument GRANULARITY determines the depth of the
recursion.  It can be set to the following symbols:

`headline'          Only parse headlines.
`greater-element'   Don't recurse into greater elements excepted
		    headlines and sections.  Thus, elements
		    parsed are the top-level ones.
`element'           Parse everything but objects and plain text.
`object'            Parse the complete buffer (default).

When VISIBLE-ONLY is non-nil, don't parse contents of hidden
elements.

An element or an objects is represented as a list with the
pattern (TYPE PROPERTIES CONTENTS), where :

  TYPE is a symbol describing the element or object.  See
  `org-element-all-elements' and `org-element-all-objects' for an
  exhaustive list of such symbols.  One can retrieve it with
  `org-element-type' function.

  PROPERTIES is the list of attributes attached to the element or
  object, as a plist.  Although most of them are specific to the
  element or object type, all types share `:begin', `:end',
  `:post-blank' and `:parent' properties, which respectively
  refer to buffer position where the element or object starts,
  ends, the number of white spaces or blank lines after it, and
  the element or object containing it.  Properties values can be
  obtained by using `org-element-property' function.

  CONTENTS is a list of elements, objects or raw strings
  contained in the current element or object, when applicable.
  One can access them with `org-element-contents' function.

The Org buffer has `org-data' as type and nil as properties.
`org-element-map' function can be used to find specific elements
or objects within the parse tree.

This function assumes that current major mode is `org-mode'."
  (save-excursion
    (goto-char (point-min))
    (org-skip-whitespace)
    (org-element--parse-elements
     (point-at-bol) (point-max)
     ;; Start in `first-section' mode so text before the first
     ;; headline belongs to a section.
     'first-section nil granularity visible-only (list 'org-data nil))))

(defun org-element-parse-secondary-string (string restriction &optional parent)
  "Recursively parse objects in STRING and return structure.

RESTRICTION is a symbol limiting the object types that will be
looked after.

Optional argument PARENT, when non-nil, is the element or object
containing the secondary string.  It is used to set correctly
`:parent' property within the string."
  (with-temp-buffer
    (insert string)
    (let ((secondary (org-element--parse-objects
		      (point-min) (point-max) nil restriction)))
      (mapc (lambda (obj) (org-element-put-property obj :parent parent))
	    secondary))))

(defun org-element-map (data types fun &optional info first-match no-recursion)
  "Map a function on selected elements or objects.

DATA is an Org buffer parse tree, as returned by, i.e.,
`org-element-parse-buffer'.  TYPES is a symbol or list of symbols
of elements or objects types (see `org-element-all-elements' and
`org-element-all-objects' for a complete list of types).  FUN is
the function called on the matching element or object.  It has to
accept one argument: the element or object itself.

When optional argument INFO is non-nil, it should be a plist
holding export options.  In that case, parts of the parse tree
not exportable according to that property list will be skipped.

When optional argument FIRST-MATCH is non-nil, stop at the first
match for which FUN doesn't return nil, and return that value.

Optional argument NO-RECURSION is a symbol or a list of symbols
representing elements or objects types.  `org-element-map' won't
enter any recursive element or object whose type belongs to that
list.  Though, FUN can still be applied on them.

Nil values returned from FUN do not appear in the results.


Examples:
--------

Assuming TREE is a variable containing an Org buffer parse tree,
the following example will return a flat list of all `src-block'
and `example-block' elements in it:

  \(org-element-map tree '(example-block src-block) 'identity)

The following snippet will find the first headline with a level
of 1 and a \"phone\" tag, and will return its beginning position:

  \(org-element-map
   tree 'headline
   \(lambda (hl)
     \(and (= (org-element-property :level hl) 1)
          \(member \"phone\" (org-element-property :tags hl))
          \(org-element-property :begin hl)))
   nil t)

Eventually, this last example will return a flat list of all
`bold' type objects containing a `latex-snippet' type object:

  \(org-element-map
   tree 'bold
   \(lambda (b)
     \(and (org-element-map b 'latex-snippet 'identity nil t)
          b)))"
  ;; Ensure TYPES and NO-RECURSION are a list, even of one element.
  (unless (listp types) (setq types (list types)))
  (unless (listp no-recursion) (setq no-recursion (list no-recursion)))
  ;; Recursion depth is determined by --CATEGORY.
  (let* ((--category
	  (catch 'found
	    (let ((category 'greater-elements))
	      (mapc (lambda (type)
		      (cond ((or (memq type org-element-all-objects)
				 (eq type 'plain-text))
			     ;; If one object is found, the function
			     ;; has to recurse into every object.
			     (throw 'found 'objects))
			    ((not (memq type org-element-greater-elements))
			     ;; If one regular element is found, the
			     ;; function has to recurse, at least,
			     ;; into every element it encounters.
			     (and (not (eq category 'elements))
				  (setq category 'elements)))))
		    types)
	      category)))
	 --acc
	 --walk-tree
	 (--walk-tree
	  (function
	   (lambda (--data)
	     ;; Recursively walk DATA.  INFO, if non-nil, is a plist
	     ;; holding contextual information.
	     (let ((--type (org-element-type --data)))
	       (cond
		((not --data))
		;; Ignored element in an export context.
		((and info (memq --data (plist-get info :ignore-list))))
		;; Secondary string: only objects can be found there.
		((not --type)
		 (when (eq --category 'objects) (mapc --walk-tree --data)))
		;; Unconditionally enter parse trees.
		((eq --type 'org-data)
		 (mapc --walk-tree (org-element-contents --data)))
		(t
		 ;; Check if TYPE is matching among TYPES.  If so,
		 ;; apply FUN to --DATA and accumulate return value
		 ;; into --ACC (or exit if FIRST-MATCH is non-nil).
		 (when (memq --type types)
		   (let ((result (funcall fun --data)))
		     (cond ((not result))
			   (first-match (throw '--map-first-match result))
			   (t (push result --acc)))))
		 ;; If --DATA has a secondary string that can contain
		 ;; objects with their type among TYPES, look into it.
		 (when (eq --category 'objects)
		   (let ((sec-prop
			  (assq --type org-element-secondary-value-alist)))
		     (when sec-prop
		       (funcall --walk-tree
				(org-element-property (cdr sec-prop) --data)))))
		 ;; Determine if a recursion into --DATA is possible.
		 (cond
		  ;; --TYPE is explicitly removed from recursion.
		  ((memq --type no-recursion))
		  ;; --DATA has no contents.
		  ((not (org-element-contents --data)))
		  ;; Looking for greater elements but --DATA is simply
		  ;; an element or an object.
		  ((and (eq --category 'greater-elements)
			(not (memq --type org-element-greater-elements))))
		  ;; Looking for elements but --DATA is an object.
		  ((and (eq --category 'elements)
			(memq --type org-element-all-objects)))
		  ;; In any other case, map contents.
		  (t (mapc --walk-tree (org-element-contents --data)))))))))))
    (catch '--map-first-match
      (funcall --walk-tree data)
      ;; Return value in a proper order.
      (nreverse --acc))))

;; The following functions are internal parts of the parser.
;;
;; The first one, `org-element--parse-elements' acts at the element's
;; level.
;;
;; The second one, `org-element--parse-objects' applies on all objects
;; of a paragraph or a secondary string.  It uses
;; `org-element--get-next-object-candidates' to optimize the search of
;; the next object in the buffer.
;;
;; More precisely, that function looks for every allowed object type
;; first.  Then, it discards failed searches, keeps further matches,
;; and searches again types matched behind point, for subsequent
;; calls.  Thus, searching for a given type fails only once, and every
;; object is searched only once at top level (but sometimes more for
;; nested types).

(defun org-element--parse-elements
  (beg end special structure granularity visible-only acc)
  "Parse elements between BEG and END positions.

SPECIAL prioritize some elements over the others.  It can be set
to `first-section', `quote-section', `section' `item' or
`table-row'.

When value is `item', STRUCTURE will be used as the current list
structure.

GRANULARITY determines the depth of the recursion.  See
`org-element-parse-buffer' for more information.

When VISIBLE-ONLY is non-nil, don't parse contents of hidden
elements.

Elements are accumulated into ACC."
  (save-excursion
    (goto-char beg)
    ;; When parsing only headlines, skip any text before first one.
    (when (and (eq granularity 'headline) (not (org-at-heading-p)))
      (org-with-limited-levels (outline-next-heading)))
    ;; Main loop start.
    (while (< (point) end)
      ;; Find current element's type and parse it accordingly to
      ;; its category.
      (let* ((element (org-element--current-element
		       end granularity special structure))
	     (type (org-element-type element))
	     (cbeg (org-element-property :contents-begin element)))
	(goto-char (org-element-property :end element))
	;; Fill ELEMENT contents by side-effect.
	(cond
	 ;; If VISIBLE-ONLY is true and element is hidden or if it has
	 ;; no contents, don't modify it.
	 ((or (and visible-only (org-element-property :hiddenp element))
	      (not cbeg)))
	 ;; Greater element: parse it between `contents-begin' and
	 ;; `contents-end'.  Make sure GRANULARITY allows the
	 ;; recursion, or ELEMENT is an headline, in which case going
	 ;; inside is mandatory, in order to get sub-level headings.
	 ((and (memq type org-element-greater-elements)
	       (or (memq granularity '(element object nil))
		   (and (eq granularity 'greater-element)
			(eq type 'section))
		   (eq type 'headline)))
	  (org-element--parse-elements
	   cbeg (org-element-property :contents-end element)
	   ;; Possibly switch to a special mode.
	   (case type
	     (headline
	      (if (org-element-property :quotedp element) 'quote-section
		'section))
	     (plain-list 'item)
	     (table 'table-row))
	   (and (memq type '(item plain-list))
		(org-element-property :structure element))
	   granularity visible-only element))
	 ;; ELEMENT has contents.  Parse objects inside, if
	 ;; GRANULARITY allows it.
	 ((memq granularity '(object nil))
	  (org-element--parse-objects
	   cbeg (org-element-property :contents-end element) element
	   (org-element-restriction type))))
	(org-element-adopt-elements acc element)))
    ;; Return result.
    acc))

(defun org-element--parse-objects (beg end acc restriction)
  "Parse objects between BEG and END and return recursive structure.

Objects are accumulated in ACC.

RESTRICTION is a list of object types which are allowed in the
current object."
  (let (candidates)
    (save-excursion
      (goto-char beg)
      (while (and (< (point) end)
		  (setq candidates (org-element--get-next-object-candidates
				    end restriction candidates)))
	(let ((next-object
	       (let ((pos (apply 'min (mapcar 'cdr candidates))))
		 (save-excursion
		   (goto-char pos)
		   (funcall (intern (format "org-element-%s-parser"
					    (car (rassq pos candidates)))))))))
	  ;; 1. Text before any object.  Untabify it.
	  (let ((obj-beg (org-element-property :begin next-object)))
	    (unless (= (point) obj-beg)
	      (setq acc
		    (org-element-adopt-elements
		     acc
		     (replace-regexp-in-string
		      "\t" (make-string tab-width ? )
		      (buffer-substring-no-properties (point) obj-beg))))))
	  ;; 2. Object...
	  (let ((obj-end (org-element-property :end next-object))
		(cont-beg (org-element-property :contents-begin next-object)))
	    ;; Fill contents of NEXT-OBJECT by side-effect, if it has
	    ;; a recursive type.
	    (when (and cont-beg
		       (memq (car next-object) org-element-recursive-objects))
	      (save-restriction
		(narrow-to-region
		 cont-beg
		 (org-element-property :contents-end next-object))
		(org-element--parse-objects
		 (point-min) (point-max) next-object
		 (org-element-restriction next-object))))
	    (setq acc (org-element-adopt-elements acc next-object))
	    (goto-char obj-end))))
      ;; 3. Text after last object.  Untabify it.
      (unless (= (point) end)
	(setq acc
	      (org-element-adopt-elements
	       acc
	       (replace-regexp-in-string
		"\t" (make-string tab-width ? )
		(buffer-substring-no-properties (point) end)))))
      ;; Result.
      acc)))

(defun org-element--get-next-object-candidates (limit restriction objects)
  "Return an alist of candidates for the next object.

LIMIT bounds the search, and RESTRICTION narrows candidates to
some object types.

Return value is an alist whose CAR is position and CDR the object
type, as a symbol.

OBJECTS is the previous candidates alist."
  ;; Filter out any object found but not belonging to RESTRICTION.
  (setq objects
	(org-remove-if-not
	 (lambda (obj)
	   (let ((type (car obj)))
	     (memq (or (cdr (assq type org-element-object-successor-alist))
		       type)
		   restriction)))
	 objects))
  (let (next-candidates types-to-search)
    ;; If no previous result, search every object type in RESTRICTION.
    ;; Otherwise, keep potential candidates (old objects located after
    ;; point) and ask to search again those which had matched before.
    (if (not objects) (setq types-to-search restriction)
      (mapc (lambda (obj)
	      (if (< (cdr obj) (point)) (push (car obj) types-to-search)
		(push obj next-candidates)))
	    objects))
    ;; Call the appropriate successor function for each type to search
    ;; and accumulate matches.
    (mapc
     (lambda (type)
       (let* ((successor-fun
	       (intern
		(format "org-element-%s-successor"
			(or (cdr (assq type org-element-object-successor-alist))
			    type))))
	      (obj (funcall successor-fun limit)))
	 (and obj (push obj next-candidates))))
     types-to-search)
    ;; Return alist.
    next-candidates))



;;; Towards A Bijective Process
;;
;; The parse tree obtained with `org-element-parse-buffer' is really
;; a snapshot of the corresponding Org buffer.  Therefore, it can be
;; interpreted and expanded into a string with canonical Org syntax.
;; Hence `org-element-interpret-data'.
;;
;; The function relies internally on
;; `org-element--interpret-affiliated-keywords'.

;;;###autoload
(defun org-element-interpret-data (data &optional parent)
  "Interpret DATA as Org syntax.

DATA is a parse tree, an element, an object or a secondary string
to interpret.

Optional argument PARENT is used for recursive calls.  It contains
the element or object containing data, or nil.

Return Org syntax as a string."
  (let* ((type (org-element-type data))
	 (results
	  (cond
	   ;; Secondary string.
	   ((not type)
	    (mapconcat
	     (lambda (obj) (org-element-interpret-data obj parent))
	     data ""))
	   ;; Full Org document.
	   ((eq type 'org-data)
	    (mapconcat
	     (lambda (obj) (org-element-interpret-data obj parent))
	     (org-element-contents data) ""))
	   ;; Plain text.
	   ((stringp data) data)
	   ;; Element/Object without contents.
	   ((not (org-element-contents data))
	    (funcall (intern (format "org-element-%s-interpreter" type))
		     data nil))
	   ;; Element/Object with contents.
	   (t
	    (let* ((greaterp (memq type org-element-greater-elements))
		   (objectp (and (not greaterp)
				 (memq type org-element-recursive-objects)))
		   (contents
		    (mapconcat
		     (lambda (obj) (org-element-interpret-data obj data))
		     (org-element-contents
		      (if (or greaterp objectp) data
			;; Elements directly containing objects must
			;; have their indentation normalized first.
			(org-element-normalize-contents
			 data
			 ;; When normalizing first paragraph of an
			 ;; item or a footnote-definition, ignore
			 ;; first line's indentation.
			 (and (eq type 'paragraph)
			      (equal data (car (org-element-contents parent)))
			      (memq (org-element-type parent)
				    '(footnote-definition item))))))
		     "")))
	      (funcall (intern (format "org-element-%s-interpreter" type))
		       data
		       (if greaterp (org-element-normalize-contents contents)
			 contents)))))))
    (if (memq type '(org-data plain-text nil)) results
      ;; Build white spaces.  If no `:post-blank' property is
      ;; specified, assume its value is 0.
      (let ((post-blank (or (org-element-property :post-blank data) 0)))
	(if (memq type org-element-all-objects)
	    (concat results (make-string post-blank 32))
	  (concat
	   (org-element--interpret-affiliated-keywords data)
	   (org-element-normalize-string results)
	   (make-string post-blank 10)))))))

(defun org-element--interpret-affiliated-keywords (element)
  "Return ELEMENT's affiliated keywords as Org syntax.
If there is no affiliated keyword, return the empty string."
  (let ((keyword-to-org
	 (function
	  (lambda (key value)
	    (let (dual)
	      (when (member key org-element-dual-keywords)
		(setq dual (cdr value) value (car value)))
	      (concat "#+" key
		      (and dual
			   (format "[%s]" (org-element-interpret-data dual)))
		      ": "
		      (if (member key org-element-parsed-keywords)
			  (org-element-interpret-data value)
			value)
		      "\n"))))))
    (mapconcat
     (lambda (prop)
       (let ((value (org-element-property prop element))
	     (keyword (upcase (substring (symbol-name prop) 1))))
	 (when value
	   (if (or (member keyword org-element-multiple-keywords)
		   ;; All attribute keywords can have multiple lines.
		   (string-match "^ATTR_" keyword))
	       (mapconcat (lambda (line) (funcall keyword-to-org keyword line))
			  value
			  "")
	     (funcall keyword-to-org keyword value)))))
     ;; List all ELEMENT's properties matching an attribute line or an
     ;; affiliated keyword, but ignore translated keywords since they
     ;; cannot belong to the property list.
     (loop for prop in (nth 1 element) by 'cddr
	   when (let ((keyword (upcase (substring (symbol-name prop) 1))))
		  (or (string-match "^ATTR_" keyword)
		      (and
		       (member keyword org-element-affiliated-keywords)
		       (not (assoc keyword
				   org-element-keyword-translation-alist)))))
	   collect prop)
     "")))

;; Because interpretation of the parse tree must return the same
;; number of blank lines between elements and the same number of white
;; space after objects, some special care must be given to white
;; spaces.
;;
;; The first function, `org-element-normalize-string', ensures any
;; string different from the empty string will end with a single
;; newline character.
;;
;; The second function, `org-element-normalize-contents', removes
;; global indentation from the contents of the current element.

(defun org-element-normalize-string (s)
  "Ensure string S ends with a single newline character.

If S isn't a string return it unchanged.  If S is the empty
string, return it.  Otherwise, return a new string with a single
newline character at its end."
  (cond
   ((not (stringp s)) s)
   ((string= "" s) "")
   (t (and (string-match "\\(\n[ \t]*\\)*\\'" s)
	   (replace-match "\n" nil nil s)))))

(defun org-element-normalize-contents (element &optional ignore-first)
  "Normalize plain text in ELEMENT's contents.

ELEMENT must only contain plain text and objects.

If optional argument IGNORE-FIRST is non-nil, ignore first line's
indentation to compute maximal common indentation.

Return the normalized element that is element with global
indentation removed from its contents.  The function assumes that
indentation is not done with TAB characters."
  (let* (ind-list			; for byte-compiler
	 collect-inds			; for byte-compiler
	 (collect-inds
	  (function
	   ;; Return list of indentations within BLOB.  This is done by
	   ;; walking recursively BLOB and updating IND-LIST along the
	   ;; way.  FIRST-FLAG is non-nil when the first string hasn't
	   ;; been seen yet.  It is required as this string is the only
	   ;; one whose indentation doesn't happen after a newline
	   ;; character.
	   (lambda (blob first-flag)
	     (mapc
	      (lambda (object)
		(when (and first-flag (stringp object))
		  (setq first-flag nil)
		  (string-match "\\`\\( *\\)" object)
		  (let ((len (length (match-string 1 object))))
		    ;; An indentation of zero means no string will be
		    ;; modified.  Quit the process.
		    (if (zerop len) (throw 'zero (setq ind-list nil))
		      (push len ind-list))))
		(cond
		 ((stringp object)
		  (let ((start 0))
		    ;; Avoid matching blank or empty lines.
		    (while (and (string-match "\n\\( *\\)\\(.\\)" object start)
				(not (equal (match-string 2 object) " ")))
		      (setq start (match-end 0))
		      (push (length (match-string 1 object)) ind-list))))
		 ((memq (org-element-type object) org-element-recursive-objects)
		  (funcall collect-inds object first-flag))))
	      (org-element-contents blob))))))
    ;; Collect indentation list in ELEMENT.  Possibly remove first
    ;; value if IGNORE-FIRST is non-nil.
    (catch 'zero (funcall collect-inds element (not ignore-first)))
    (if (not ind-list) element
      ;; Build ELEMENT back, replacing each string with the same
      ;; string minus common indentation.
      (let* (build			; For byte compiler.
	     (build
	      (function
	       (lambda (blob mci first-flag)
		 ;; Return BLOB with all its strings indentation
		 ;; shortened from MCI white spaces.  FIRST-FLAG is
		 ;; non-nil when the first string hasn't been seen
		 ;; yet.
		 (setcdr (cdr blob)
			 (mapcar
			  (lambda (object)
			    (when (and first-flag (stringp object))
			      (setq first-flag nil)
			      (setq object
				    (replace-regexp-in-string
				     (format "\\` \\{%d\\}" mci) "" object)))
			    (cond
			     ((stringp object)
			      (replace-regexp-in-string
			       (format "\n \\{%d\\}" mci) "\n" object))
			     ((memq (org-element-type object)
				    org-element-recursive-objects)
			      (funcall build object mci first-flag))
			     (t object)))
			  (org-element-contents blob)))
		 blob))))
	(funcall build element (apply 'min ind-list) (not ignore-first))))))



;;; The Toolbox
;;
;; The first move is to implement a way to obtain the smallest element
;; containing point.  This is the job of `org-element-at-point'.  It
;; basically jumps back to the beginning of section containing point
;; and moves, element after element, with
;; `org-element--current-element' until the container is found.  Note:
;; When using `org-element-at-point', secondary values are never
;; parsed since the function focuses on elements, not on objects.
;;
;; At a deeper level, `org-element-context' lists all elements and
;; objects containing point.
;;
;; `org-element-nested-p' and `org-element-swap-A-B' may be used
;; internally by navigation and manipulation tools.

;;;###autoload
(defun org-element-at-point (&optional keep-trail)
  "Determine closest element around point.

Return value is a list like (TYPE PROPS) where TYPE is the type
of the element and PROPS a plist of properties associated to the
element.

Possible types are defined in `org-element-all-elements'.
Properties depend on element or object type, but always include
`:begin', `:end', `:parent' and `:post-blank' properties.

As a special case, if point is at the very beginning of a list or
sub-list, returned element will be that list instead of the first
item.  In the same way, if point is at the beginning of the first
row of a table, returned element will be the table instead of the
first row.

If optional argument KEEP-TRAIL is non-nil, the function returns
a list of elements leading to element at point.  The list's CAR
is always the element at point.  The following positions contain
element's siblings, then parents, siblings of parents, until the
first element of current section."
  (org-with-wide-buffer
   ;; If at an headline, parse it.  It is the sole element that
   ;; doesn't require to know about context.  Be sure to disallow
   ;; secondary string parsing, though.
   (if (org-with-limited-levels (org-at-heading-p))
       (progn
	 (beginning-of-line)
	 (if (not keep-trail) (org-element-headline-parser (point-max) t)
	   (list (org-element-headline-parser (point-max) t))))
     ;; Otherwise move at the beginning of the section containing
     ;; point.
     (let ((origin (point))
	   (end (save-excursion
		  (org-with-limited-levels (outline-next-heading)) (point)))
	   element type special-flag trail struct prevs parent)
       (org-with-limited-levels
	(if (org-with-limited-levels (org-before-first-heading-p))
	    (goto-char (point-min))
	  (org-back-to-heading)
	  (forward-line)))
       (org-skip-whitespace)
       (beginning-of-line)
       ;; Parse successively each element, skipping those ending
       ;; before original position.
       (catch 'exit
         (while t
           (setq element
		 (org-element--current-element end 'element special-flag struct)
                 type (car element))
	   (org-element-put-property element :parent parent)
	   (when keep-trail (push element trail))
           (cond
	    ;; 1. Skip any element ending before point.  Also skip
	    ;;    element ending at point when we're sure that another
	    ;;    element has started.
	    ((let ((elem-end (org-element-property :end element)))
	       (when (or (< elem-end origin)
			 (and (= elem-end origin) (/= elem-end end)))
		 (goto-char elem-end))))
	    ;; 2. An element containing point is always the element at
	    ;;    point.
	    ((not (memq type org-element-greater-elements))
	     (throw 'exit (if keep-trail trail element)))
	    ;; 3. At any other greater element type, if point is
	    ;;    within contents, move into it.
	    (t
	     (let ((cbeg (org-element-property :contents-begin element))
		   (cend (org-element-property :contents-end element)))
	       (if (or (not cbeg) (not cend) (> cbeg origin) (< cend origin)
		       ;; Create an anchor for tables and plain lists:
		       ;; when point is at the very beginning of these
		       ;; elements, ignoring affiliated keywords,
		       ;; target them instead of their contents.
		       (and (= cbeg origin) (memq type '(plain-list table)))
		       ;; When point is at contents end, do not move
		       ;; into elements with an explicit ending, but
		       ;; return that element instead.
		       (and (= cend origin)
			    (memq type
				  '(center-block
				    drawer dynamic-block inlinetask item
				    plain-list quote-block special-block))))
		   (throw 'exit (if keep-trail trail element))
		 (setq parent element)
		 (case type
		   (plain-list
		    (setq special-flag 'item
			  struct (org-element-property :structure element)))
		   (item (setq special-flag nil))
		   (property-drawer
		    (setq special-flag 'node-property struct nil))
		   (table (setq special-flag 'table-row struct nil))
		   (otherwise (setq special-flag nil struct nil)))
		 (setq end cend)
		 (goto-char cbeg)))))))))))

;;;###autoload
(defun org-element-context ()
  "Return closest element or object around point.

Return value is a list like (TYPE PROPS) where TYPE is the type
of the element or object and PROPS a plist of properties
associated to it.

Possible types are defined in `org-element-all-elements' and
`org-element-all-objects'.  Properties depend on element or
object type, but always include `:begin', `:end', `:parent' and
`:post-blank'."
  (org-with-wide-buffer
   (let* ((origin (point))
	  (element (org-element-at-point))
	  (type (car element))
	  end)
     ;; Check if point is inside an element containing objects or at
     ;; a secondary string.  In that case, move to beginning of the
     ;; element or secondary string and set END to the other side.
     (if (not (or (and (eq type 'item)
		       (let ((tag (org-element-property :tag element)))
			 (and tag
			      (progn
				(beginning-of-line)
				(search-forward tag (point-at-eol))
				(goto-char (match-beginning 0))
				(and (>= origin (point))
				     (<= origin
					 ;; `1+' is required so some
					 ;; successors can match
					 ;; properly their object.
					 (setq end (1+ (match-end 0)))))))))
		  (and (memq type '(headline inlinetask))
		       (progn (beginning-of-line)
			      (skip-chars-forward "* ")
			      (setq end (point-at-eol))))
		  (and (memq type '(paragraph table-row verse-block))
		       (let ((cbeg (org-element-property
				    :contents-begin element))
			     (cend (org-element-property
				    :contents-end element)))
			 (and (>= origin cbeg)
			      (<= origin cend)
			      (progn (goto-char cbeg) (setq end cend)))))))
	 element
       (let ((restriction (org-element-restriction element))
	     (parent element)
	     candidates)
	 (catch 'exit
	   (while (setq candidates (org-element--get-next-object-candidates
				    end restriction candidates))
	     (let ((closest-cand (rassq (apply 'min (mapcar 'cdr candidates))
					candidates)))
	       ;; If ORIGIN is before next object in element, there's
	       ;; no point in looking further.
	       (if (> (cdr closest-cand) origin) (throw 'exit parent)
		 (let* ((object
			 (progn (goto-char (cdr closest-cand))
				(funcall (intern (format "org-element-%s-parser"
							 (car closest-cand))))))
			(cbeg (org-element-property :contents-begin object))
			(cend (org-element-property :contents-end object))
			(obj-end (org-element-property :end object)))
		   (cond
		    ;; ORIGIN is after OBJECT, so skip it.
		    ((<= obj-end origin)
		     (if (/= obj-end end) (goto-char obj-end)
		       (throw 'exit
			      (org-element-put-property
			       object :parent parent))))
		    ;; ORIGIN is within a non-recursive object or at
		    ;; an object boundaries: Return that object.
		    ((or (not cbeg) (> cbeg origin) (< cend origin))
		     (throw 'exit
			    (org-element-put-property object :parent parent)))
		    ;; Otherwise, move within current object and
		    ;; restrict search to the end of its contents.
		    (t (goto-char cbeg)
		       (org-element-put-property object :parent parent)
		       (setq parent object
			     restriction (org-element-restriction object)
			     end cend)))))))
	   parent))))))

(defsubst org-element-nested-p (elem-A elem-B)
  "Non-nil when elements ELEM-A and ELEM-B are nested."
  (let ((beg-A (org-element-property :begin elem-A))
	(beg-B (org-element-property :begin elem-B))
	(end-A (org-element-property :end elem-A))
	(end-B (org-element-property :end elem-B)))
    (or (and (>= beg-A beg-B) (<= end-A end-B))
	(and (>= beg-B beg-A) (<= end-B end-A)))))

(defun org-element-swap-A-B (elem-A elem-B)
  "Swap elements ELEM-A and ELEM-B.
Assume ELEM-B is after ELEM-A in the buffer.  Leave point at the
end of ELEM-A."
  (goto-char (org-element-property :begin elem-A))
  ;; There are two special cases when an element doesn't start at bol:
  ;; the first paragraph in an item or in a footnote definition.
  (let ((specialp (not (bolp))))
    ;; Only a paragraph without any affiliated keyword can be moved at
    ;; ELEM-A position in such a situation.  Note that the case of
    ;; a footnote definition is impossible: it cannot contain two
    ;; paragraphs in a row because it cannot contain a blank line.
    (if (and specialp
	     (or (not (eq (org-element-type elem-B) 'paragraph))
		 (/= (org-element-property :begin elem-B)
		     (org-element-property :contents-begin elem-B))))
	(error "Cannot swap elements"))
    ;; In a special situation, ELEM-A will have no indentation.  We'll
    ;; give it ELEM-B's (which will in, in turn, have no indentation).
    (let* ((ind-B (when specialp
		    (goto-char (org-element-property :begin elem-B))
		    (org-get-indentation)))
	   (beg-A (org-element-property :begin elem-A))
	   (end-A (save-excursion
		    (goto-char (org-element-property :end elem-A))
		    (skip-chars-backward " \r\t\n")
		    (point-at-eol)))
	   (beg-B (org-element-property :begin elem-B))
	   (end-B (save-excursion
		    (goto-char (org-element-property :end elem-B))
		    (skip-chars-backward " \r\t\n")
		    (point-at-eol)))
	   ;; Store overlays responsible for visibility status.  We
	   ;; also need to store their boundaries as they will be
	   ;; removed from buffer.
	   (overlays
	    (cons
	     (mapcar (lambda (ov) (list ov (overlay-start ov) (overlay-end ov)))
		     (overlays-in beg-A end-A))
	     (mapcar (lambda (ov) (list ov (overlay-start ov) (overlay-end ov)))
		     (overlays-in beg-B end-B))))
	   ;; Get contents.
	   (body-A (buffer-substring beg-A end-A))
	   (body-B (delete-and-extract-region beg-B end-B)))
      (goto-char beg-B)
      (when specialp
	(setq body-B (replace-regexp-in-string "\\`[ \t]*" "" body-B))
	(org-indent-to-column ind-B))
      (insert body-A)
      ;; Restore ex ELEM-A overlays.
      (let ((offset (- beg-B beg-A)))
	(mapc (lambda (ov)
		(move-overlay
		 (car ov) (+ (nth 1 ov) offset) (+ (nth 2 ov) offset)))
	      (car overlays))
	(goto-char beg-A)
	(delete-region beg-A end-A)
	(insert body-B)
	;; Restore ex ELEM-B overlays.
	(mapc (lambda (ov)
		(move-overlay
		 (car ov) (- (nth 1 ov) offset) (- (nth 2 ov) offset)))
	      (cdr overlays)))
      (goto-char (org-element-property :end elem-B)))))

(provide 'org-element)

;; Local variables:
;; generated-autoload-file: "org-loaddefs.el"
;; End:

;;; org-element.el ends here
