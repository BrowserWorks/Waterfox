;;; xml.el --- XML parser

;; Copyright (C) 2000-2013 Free Software Foundation, Inc.

;; Author: Emmanuel Briot  <briot@gnat.com>
;; Maintainer: Mark A. Hershberger <mah@everybody.org>
;; Keywords: xml, data

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

;; This file contains a somewhat incomplete non-validating XML parser.  It
;; parses a file, and returns a list that can be used internally by
;; any other Lisp libraries.

;;; FILE FORMAT

;; The document type declaration may either be ignored or (optionally)
;; parsed, but currently the parsing will only accept element
;; declarations.  The XML file is assumed to be well-formed.  In case
;; of error, the parsing stops and the XML file is shown where the
;; parsing stopped.
;;
;; It also knows how to ignore comments and processing instructions.
;;
;; The XML file should have the following format:
;;    <node1 attr1="name1" attr2="name2" ...>value
;;       <node2 attr3="name3" attr4="name4">value2</node2>
;;       <node3 attr5="name5" attr6="name6">value3</node3>
;;    </node1>
;; Of course, the name of the nodes and attributes can be anything.  There can
;; be any number of attributes (or none), as well as any number of children
;; below the nodes.
;;
;; There can be only top level node, but with any number of children below.

;;; LIST FORMAT

;; The functions `xml-parse-file', `xml-parse-region' and
;; `xml-parse-tag' return a list with the following format:
;;
;;    xml-list   ::= (node node ...)
;;    node       ::= (qname attribute-list . child_node_list)
;;    child_node_list ::= child_node child_node ...
;;    child_node ::= node | string
;;    qname      ::= (:namespace-uri . "name") | "name"
;;    attribute_list ::= ((qname . "value") (qname . "value") ...)
;;                       | nil
;;    string     ::= "..."
;;
;; Some macros are provided to ease the parsing of this list.
;; Whitespace is preserved.  Fixme: There should be a tree-walker that
;; can remove it.

;; TODO:
;;  * xml:base, xml:space support
;;  * more complete DOCTYPE parsing
;;  * pi support

;;; Code:

;; Note that buffer-substring and match-string were formerly used in
;; several places, because the -no-properties variants remove
;; composition info.  However, after some discussion on emacs-devel,
;; the consensus was that the speed of the -no-properties variants was
;; a worthwhile tradeoff especially since we're usually parsing files
;; instead of hand-crafted XML.

;;;  Macros to parse the list

(defconst xml-undefined-entity "?"
  "What to substitute for undefined entities")

(defconst xml-default-ns '(("" . "")
			   ("xml" . "http://www.w3.org/XML/1998/namespace")
			   ("xmlns" . "http://www.w3.org/2000/xmlns/"))
  "Alist mapping default XML namespaces to their URIs.")

(defvar xml-entity-alist
  '(("lt"   . "&#60;")
    ("gt"   . ">")
    ("apos" . "'")
    ("quot" . "\"")
    ("amp"  . "&#38;"))
  "Alist mapping XML entities to their replacement text.")

(defvar xml-entity-expansion-limit 20000
  "The maximum size of entity reference expansions.
If the size of the buffer increases by this many characters while
expanding entity references in a segment of character data, the
XML parser signals an error.  Setting this to nil removes the
limit (making the parser vulnerable to XML bombs).")

(defvar xml-parameter-entity-alist nil
  "Alist of defined XML parametric entities.")

(defvar xml-sub-parser nil
  "Non-nil when the XML parser is parsing an XML fragment.")

(defvar xml-validating-parser nil
  "Set to non-nil to get validity checking.")

(defsubst xml-node-name (node)
  "Return the tag associated with NODE.
Without namespace-aware parsing, the tag is a symbol.

With namespace-aware parsing, the tag is a cons of a string
representing the uri of the namespace with the local name of the
tag.  For example,

    <foo>

would be represented by

    '(\"\" . \"foo\").

If you'd just like a plain symbol instead, use 'symbol-qnames in
the PARSE-NS argument."

  (car node))

(defsubst xml-node-attributes (node)
  "Return the list of attributes of NODE.
The list can be nil."
  (nth 1 node))

(defsubst xml-node-children (node)
  "Return the list of children of NODE.
This is a list of nodes, and it can be nil."
  (cddr node))

(defun xml-get-children (node child-name)
  "Return the children of NODE whose tag is CHILD-NAME.
CHILD-NAME should match the value returned by `xml-node-name'."
  (let ((match ()))
    (dolist (child (xml-node-children node))
      (if (and (listp child)
               (equal (xml-node-name child) child-name))
          (push child match)))
    (nreverse match)))

(defun xml-get-attribute-or-nil (node attribute)
  "Get from NODE the value of ATTRIBUTE.
Return nil if the attribute was not found.

See also `xml-get-attribute'."
  (cdr (assoc attribute (xml-node-attributes node))))

(defsubst xml-get-attribute (node attribute)
  "Get from NODE the value of ATTRIBUTE.
An empty string is returned if the attribute was not found.

See also `xml-get-attribute-or-nil'."
  (or (xml-get-attribute-or-nil node attribute) ""))

;;; Regular expressions for XML components

;; The following regexps are used as subexpressions in regexps that
;; are `eval-when-compile'd for efficiency, so they must be defined at
;; compile time.
(eval-and-compile

;; [4] NameStartChar
;; See the definition of word syntax in `xml-syntax-table'.
(defconst xml-name-start-char-re (concat "[[:word:]:_]"))

;; [4a] NameChar ::= NameStartChar | "-" | "." | [0-9] | #xB7
;;                 | [#x0300-#x036F] | [#x203F-#x2040]
(defconst xml-name-char-re (concat "[-0-9.[:word:]:_·̀-ͯ‿-⁀]"))

;; [5] Name     ::= NameStartChar (NameChar)*
(defconst xml-name-re (concat xml-name-start-char-re xml-name-char-re "*"))

;; [6] Names    ::= Name (#x20 Name)*
(defconst xml-names-re (concat xml-name-re "\\(?: " xml-name-re "\\)*"))

;; [7] Nmtoken  ::= (NameChar)+
(defconst xml-nmtoken-re (concat xml-name-char-re "+"))

;; [8] Nmtokens ::= Nmtoken (#x20 Nmtoken)*
(defconst xml-nmtokens-re (concat xml-nmtoken-re "\\(?: " xml-name-re "\\)*"))

;; [66] CharRef ::= '&#' [0-9]+ ';' | '&#x' [0-9a-fA-F]+ ';'
(defconst xml-char-ref-re  "\\(?:&#[0-9]+;\\|&#x[0-9a-fA-F]+;\\)")

;; [68] EntityRef   ::= '&' Name ';'
(defconst xml-entity-ref (concat "&" xml-name-re ";"))

(defconst xml-entity-or-char-ref-re (concat "&\\(?:#\\(x\\)?\\([0-9a-fA-F]+\\)\\|\\("
					    xml-name-re "\\)\\);"))

;; [69] PEReference ::= '%' Name ';'
(defconst xml-pe-reference-re (concat "%\\(" xml-name-re "\\);"))

;; [67] Reference   ::= EntityRef | CharRef
(defconst xml-reference-re (concat "\\(?:" xml-entity-ref "\\|" xml-char-ref-re "\\)"))

;; [10] AttValue    ::= '"' ([^<&"] | Reference)* '"'
;;                    | "'" ([^<&'] | Reference)* "'"
(defconst xml-att-value-re (concat "\\(?:\"\\(?:[^&\"]\\|"
				   xml-reference-re "\\)*\"\\|"
				   "'\\(?:[^&']\\|" xml-reference-re
				   "\\)*'\\)"))

;; [56] TokenizedType ::= 'ID'
;;     [VC: ID] [VC: One ID / Element Type] [VC: ID Attribute Default]
;;                      | 'IDREF'    [VC: IDREF]
;;                      | 'IDREFS'   [VC: IDREF]
;;                      | 'ENTITY'   [VC: Entity Name]
;;                      | 'ENTITIES' [VC: Entity Name]
;;                      | 'NMTOKEN'  [VC: Name Token]
;;                      | 'NMTOKENS' [VC: Name Token]
(defconst xml-tokenized-type-re (concat "\\(?:ID\\|IDREF\\|IDREFS\\|ENTITY\\|"
					"ENTITIES\\|NMTOKEN\\|NMTOKENS\\)"))

;; [58] NotationType ::= 'NOTATION' S '(' S? Name (S? '|' S? Name)* S? ')'
(defconst xml-notation-type-re
  (concat "\\(?:NOTATION\\s-+(\\s-*" xml-name-re
	  "\\(?:\\s-*|\\s-*" xml-name-re "\\)*\\s-*)\\)"))

;; [59] Enumeration ::= '(' S? Nmtoken (S? '|' S? Nmtoken)* S? ')'
;;       [VC: Enumeration] [VC: No Duplicate Tokens]
(defconst xml-enumeration-re (concat "\\(?:(\\s-*" xml-nmtoken-re
				     "\\(?:\\s-*|\\s-*" xml-nmtoken-re
				     "\\)*\\s-+)\\)"))

;; [57] EnumeratedType ::= NotationType | Enumeration
(defconst xml-enumerated-type-re (concat "\\(?:" xml-notation-type-re
					 "\\|" xml-enumeration-re "\\)"))

;; [54] AttType    ::= StringType | TokenizedType | EnumeratedType
;; [55] StringType ::= 'CDATA'
(defconst xml-att-type-re (concat "\\(?:CDATA\\|" xml-tokenized-type-re
				  "\\|" xml-notation-type-re
				  "\\|" xml-enumerated-type-re "\\)"))

;; [60] DefaultDecl ::= '#REQUIRED' | '#IMPLIED' | (('#FIXED' S)? AttValue)
(defconst xml-default-decl-re (concat "\\(?:#REQUIRED\\|#IMPLIED\\|"
				      "\\(?:#FIXED\\s-+\\)*"
				      xml-att-value-re "\\)"))

;; [53] AttDef      ::= S Name S AttType S DefaultDecl
(defconst xml-att-def-re (concat "\\(?:\\s-*" xml-name-re
				 "\\s-*" xml-att-type-re
				 "\\s-*" xml-default-decl-re "\\)"))

;; [9] EntityValue ::= '"' ([^%&"] | PEReference | Reference)* '"'
;;                   | "'" ([^%&'] | PEReference | Reference)* "'"
(defconst xml-entity-value-re (concat "\\(?:\"\\(?:[^%&\"]\\|"
				      xml-pe-reference-re
				      "\\|" xml-reference-re
				      "\\)*\"\\|'\\(?:[^%&']\\|"
				      xml-pe-reference-re "\\|"
				      xml-reference-re "\\)*'\\)"))
) ; End of `eval-when-compile'


;; [75] ExternalID ::= 'SYSTEM' S SystemLiteral
;;                   | 'PUBLIC' S PubidLiteral S SystemLiteral
;; [76] NDataDecl ::=   	S 'NDATA' S
;; [73] EntityDef  ::= EntityValue| (ExternalID NDataDecl?)
;; [71] GEDecl     ::= '<!ENTITY' S Name S EntityDef S? '>'
;; [74] PEDef      ::= EntityValue | ExternalID
;; [72] PEDecl     ::= '<!ENTITY' S '%' S Name S PEDef S? '>'
;; [70] EntityDecl ::= GEDecl | PEDecl

;; Note that this is setup so that we can do whitespace-skipping with
;; `(skip-syntax-forward " ")', inter alia.  Previously this was slow
;; compared with `re-search-forward', but that has been fixed.

(defvar xml-syntax-table
  ;; By default, characters have symbol syntax.
  (let ((table (make-char-table 'syntax-table '(3))))
    ;; The XML space chars [3], and nothing else, have space syntax.
    (dolist (c '(?\s ?\t ?\r ?\n))
      (modify-syntax-entry c " " table))
    ;; The characters in NameStartChar [4], aside from ':' and '_',
    ;; have word syntax.  This is used by `xml-name-start-char-re'.
    (modify-syntax-entry '(?A . ?Z)         "w" table)
    (modify-syntax-entry '(?a . ?z)         "w" table)
    (modify-syntax-entry '(#xC0  . #xD6)    "w" table)
    (modify-syntax-entry '(#xD8  . #XF6)    "w" table)
    (modify-syntax-entry '(#xF8  . #X2FF)   "w" table)
    (modify-syntax-entry '(#x370 . #X37D)   "w" table)
    (modify-syntax-entry '(#x37F . #x1FFF)  "w" table)
    (modify-syntax-entry '(#x200C . #x200D) "w" table)
    (modify-syntax-entry '(#x2070 . #x218F) "w" table)
    (modify-syntax-entry '(#x2C00 . #x2FEF) "w" table)
    (modify-syntax-entry '(#x3001 . #xD7FF) "w" table)
    (modify-syntax-entry '(#xF900 . #xFDCF) "w" table)
    (modify-syntax-entry '(#xFDF0 . #xFFFD) "w" table)
    (modify-syntax-entry '(#x10000 . #xEFFFF) "w" table)
    table)
  "Syntax table used by the XML parser.
In this syntax table, the XML space characters [ \\t\\r\\n], and
only those characters, have whitespace syntax.")

;;; Entry points:

;;;###autoload
(defun xml-parse-file (file &optional parse-dtd parse-ns)
  "Parse the well-formed XML file FILE.
Return the top node with all its children.
If PARSE-DTD is non-nil, the DTD is parsed rather than skipped.

If PARSE-NS is non-nil, then QNAMES are expanded.  By default,
the variable `xml-default-ns' is the mapping from namespaces to
URIs, and expanded names will be returned as a cons

  (\"namespace:\" . \"foo\").

If PARSE-NS is an alist, it will be used as the mapping from
namespace to URIs instead.

If it is the symbol 'symbol-qnames, expanded names will be
returned as a plain symbol 'namespace:foo instead of a cons.

Both features can be combined by providing a cons cell

  (symbol-qnames . ALIST)."
  (with-temp-buffer
    (insert-file-contents file)
    (xml--parse-buffer parse-dtd parse-ns)))

;;;###autoload
(defun xml-parse-region (&optional beg end buffer parse-dtd parse-ns)
  "Parse the region from BEG to END in BUFFER.
Return the XML parse tree, or raise an error if the region does
not contain well-formed XML.

If BEG is nil, it defaults to `point-min'.
If END is nil, it defaults to `point-max'.
If BUFFER is nil, it defaults to the current buffer.
If PARSE-DTD is non-nil, parse the DTD and return it as the first
element of the list.
If PARSE-NS is non-nil, then QNAMES are expanded.  By default,
the variable `xml-default-ns' is the mapping from namespaces to
URIs, and expanded names will be returned as a cons

  (\"namespace:\" . \"foo\").

If PARSE-NS is an alist, it will be used as the mapping from
namespace to URIs instead.

If it is the symbol 'symbol-qnames, expanded names will be
returned as a plain symbol 'namespace:foo instead of a cons.

Both features can be combined by providing a cons cell

  (symbol-qnames . ALIST)."
  ;; Use fixed syntax table to ensure regexp char classes and syntax
  ;; specs DTRT.
  (unless buffer
    (setq buffer (current-buffer)))
  (with-temp-buffer
    (insert-buffer-substring-no-properties buffer beg end)
    (xml--parse-buffer parse-dtd parse-ns)))

;; XML [5]

;; Fixme:  This needs re-writing to deal with the XML grammar properly, i.e.
;;   document  ::=  prolog element Misc*
;;   prolog    ::=  XMLDecl? Misc* (doctypedecl Misc*)?

(defun xml--parse-buffer (parse-dtd parse-ns)
  (with-syntax-table xml-syntax-table
    (let ((case-fold-search nil)	; XML is case-sensitive.
	  ;; Prevent entity definitions from changing the defaults
	  (xml-entity-alist xml-entity-alist)
	  (xml-parameter-entity-alist xml-parameter-entity-alist)
 	  xml result dtd)
      (goto-char (point-min))
      (while (not (eobp))
	(if (search-forward "<" nil t)
	    (progn
	      (forward-char -1)
	      (setq result (xml-parse-tag-1 parse-dtd parse-ns))
	      (cond
	       ((null result)
		;; Not looking at an xml start tag.
		(unless (eobp)
		  (forward-char 1)))
	       ((and xml (not xml-sub-parser))
		;; Translation of rule [1] of XML specifications
		(error "XML: (Not Well-Formed) Only one root tag allowed"))
	       ((and (listp (car result))
		     parse-dtd)
		(setq dtd (car result))
		(if (cdr result)	; possible leading comment
		    (add-to-list 'xml (cdr result))))
	       (t
		(add-to-list 'xml result))))
	  (goto-char (point-max))))
      (if parse-dtd
	  (cons dtd (nreverse xml))
	(nreverse xml)))))

(defun xml-maybe-do-ns (name default xml-ns)
  "Perform any namespace expansion.
NAME is the name to perform the expansion on.
DEFAULT is the default namespace.  XML-NS is a cons of namespace
names to uris.  When namespace-aware parsing is off, then XML-NS
is nil.

During namespace-aware parsing, any name without a namespace is
put into the namespace identified by DEFAULT.  nil is used to
specify that the name shouldn't be given a namespace.
Expanded names will by default be returned as a cons.  If you
would like to get plain symbols instead, provide a cons cell

  (symbol-qnames . ALIST)

in the XML-NS argument."
  (if (consp xml-ns)
      (let* ((symbol-qnames (eq (car-safe xml-ns) 'symbol-qnames))
	     (nsp (string-match ":" name))
	     (lname (if nsp (substring name (match-end 0)) name))
	     (prefix (if nsp (substring name 0 (match-beginning 0)) default))
	     (special (and (string-equal lname "xmlns") (not prefix)))
             ;; Setting default to nil will insure that there is not
             ;; matching cons in xml-ns.  In which case we
	     (ns (or (cdr (assoc (if special "xmlns" prefix)
                                 (if symbol-qnames (cdr xml-ns) xml-ns)))
                     "")))
	(if (and symbol-qnames
		 (not (string= prefix "xmlns")))
	    (intern (concat ns lname))
	  (cons ns (if special "" lname))))
    (intern name)))

(defun xml-parse-tag (&optional parse-dtd parse-ns)
  "Parse the tag at point.
If PARSE-DTD is non-nil, the DTD of the document, if any, is parsed and
returned as the first element in the list.
If PARSE-NS is non-nil, expand QNAMES; for further details, see
`xml-parse-region'.

Return one of:
 - a list : the matching node
 - nil    : the point is not looking at a tag.
 - a pair : the first element is the DTD, the second is the node."
  (let* ((case-fold-search nil)
	 ;; Prevent entity definitions from changing the defaults
	 (xml-entity-alist xml-entity-alist)
	 (xml-parameter-entity-alist xml-parameter-entity-alist)
	 (buf (current-buffer))
	 (pos (point)))
    (with-temp-buffer
      (with-syntax-table xml-syntax-table
	(insert-buffer-substring-no-properties buf pos)
	(goto-char (point-min))
	(xml-parse-tag-1 parse-dtd parse-ns)))))

(defun xml-parse-tag-1 (&optional parse-dtd parse-ns)
  "Like `xml-parse-tag', but possibly modify the buffer while working."
  (let* ((xml-validating-parser (or parse-dtd xml-validating-parser))
	 (xml-ns
	  (cond ((eq parse-ns 'symbol-qnames)
		 (cons 'symbol-qnames xml-default-ns))
		((or (consp (car-safe parse-ns))
		     (and (eq (car-safe parse-ns) 'symbol-qnames)
			  (listp (cdr parse-ns))))
		 parse-ns)
		(parse-ns
		 xml-default-ns))))
    (cond
     ;; Processing instructions, like <?xml version="1.0"?>.
     ((looking-at "<\\?")
      (search-forward "?>")
      (skip-syntax-forward " ")
      (xml-parse-tag-1 parse-dtd xml-ns))
     ;; Character data (CDATA) sections, in which no tag should be interpreted
     ((looking-at "<!\\[CDATA\\[")
      (let ((pos (match-end 0)))
	(unless (search-forward "]]>" nil t)
	  (error "XML: (Not Well Formed) CDATA section does not end anywhere in the document"))
	(concat
	 (buffer-substring-no-properties pos (match-beginning 0))
	 (xml-parse-string))))
     ;; DTD for the document
     ((looking-at "<!DOCTYPE[ \t\n\r]")
      (let ((dtd (xml-parse-dtd parse-ns)))
	(skip-syntax-forward " ")
	(if xml-validating-parser
	    (cons dtd (xml-parse-tag-1 nil xml-ns))
	  (xml-parse-tag-1 nil xml-ns))))
     ;; skip comments
     ((looking-at "<!--")
      (search-forward "-->")
      ;; FIXME: This loses the skipped-over spaces.
      (skip-syntax-forward " ")
      (unless (eobp)
	(let ((xml-sub-parser t))
	  (xml-parse-tag-1 parse-dtd xml-ns))))
     ;; end tag
     ((looking-at "</")
      '())
     ;; opening tag
     ((looking-at (eval-when-compile (concat "<\\(" xml-name-re "\\)")))
      (goto-char (match-end 1))
      ;; Parse this node
      (let* ((node-name (match-string-no-properties 1))
	     ;; Parse the attribute list.
	     (attrs (xml-parse-attlist xml-ns))
	     children)
	;; add the xmlns:* attrs to our cache
	(when (consp xml-ns)
	  (dolist (attr attrs)
	    (when (and (consp (car attr))
		       (equal "http://www.w3.org/2000/xmlns/"
			      (caar attr)))
	      (push (cons (cdar attr) (cdr attr))
		    (if (symbolp (car xml-ns))
			(cdr xml-ns)
		      xml-ns)))))
	(setq children (list attrs (xml-maybe-do-ns node-name "" xml-ns)))
	(cond
	 ;; is this an empty element ?
	 ((looking-at "/>")
	  (forward-char 2)
	  (nreverse children))
	 ;; is this a valid start tag ?
	 ((eq (char-after) ?>)
	  (forward-char 1)
	  ;; Now check that we have the right end-tag.
	  (let ((end (concat "</" node-name "\\s-*>")))
	    (while (not (looking-at end))
	      (cond
	       ((eobp)
		(error "XML: (Not Well-Formed) End of document while reading element `%s'"
		       node-name))
	       ((looking-at "</")
		(forward-char 2)
		(error "XML: (Not Well-Formed) Invalid end tag `%s' (expecting `%s')"
		       (let ((pos (point)))
			 (buffer-substring pos (if (re-search-forward "\\s-*>" nil t)
						   (match-beginning 0)
						 (point-max))))
		       node-name))
	       ;; Read a sub-element and push it onto CHILDREN.
	       ((= (char-after) ?<)
		(let ((tag (xml-parse-tag-1 nil xml-ns)))
		  (when tag
		    (push tag children))))
	       ;; Read some character data.
	       (t
		(let ((expansion (xml-parse-string)))
		  (push (if (stringp (car children))
			    ;; If two strings were separated by a
			    ;; comment, concat them.
			    (concat (pop children) expansion)
			  expansion)
			children)))))
	    ;; Move point past the end-tag.
	    (goto-char (match-end 0))
	    (nreverse children)))
	 ;; Otherwise this was an invalid start tag (expected ">" not found.)
	 (t
	  (error "XML: (Well-Formed) Couldn't parse tag: %s"
		 (buffer-substring-no-properties (- (point) 10) (+ (point) 1)))))))

     ;; (Not one of PI, CDATA, Comment, End tag, or Start tag)
     (t
      (unless xml-sub-parser   ; Usually, we error out.
	(error "XML: (Well-Formed) Invalid character"))
      ;; However, if we're parsing incrementally, then we need to deal
      ;; with stray CDATA.
      (xml-parse-string)))))

(defun xml-parse-string ()
  "Parse character data at point, and return it as a string.
Leave point at the start of the next thing to parse.  This
function can modify the buffer by expanding entity and character
references."
  (let ((start (point))
	;; Keep track of the size of the rest of the buffer:
	(old-remaining-size (- (buffer-size) (point)))
	ref val)
    (while (and (not (eobp))
		(not (looking-at "<")))
      ;; Find the next < or & character.
      (skip-chars-forward "^<&")
      (when (eq (char-after) ?&)
	;; If we find an entity or character reference, expand it.
	(unless (looking-at xml-entity-or-char-ref-re)
	  (error "XML: (Not Well-Formed) Invalid entity reference"))
	;; For a character reference, the next entity or character
	;; reference must be after the replacement.  [4.6] "Numerical
	;; character references are expanded immediately when
	;; recognized and MUST be treated as character data."
	(if (setq ref (match-string 2))
	    (progn  ; Numeric char reference
	      (setq val (save-match-data
			  (decode-char 'ucs (string-to-number
					     ref (if (match-string 1) 16)))))
	      (and (null val)
		   xml-validating-parser
		   (error "XML: (Validity) Invalid character reference `%s'"
			  (match-string 0)))
	      (replace-match (if val (string val) xml-undefined-entity) t t))
	  ;; For an entity reference, search again from the start of
	  ;; the replaced text, since the replacement can contain
	  ;; entity or character references, or markup.
	  (setq ref (match-string 3)
		val (assoc ref xml-entity-alist))
	  (and (null val)
	       xml-validating-parser
	       (error "XML: (Validity) Undefined entity `%s'" ref))
	  (replace-match (or (cdr val) xml-undefined-entity) t t)
	  (goto-char (match-beginning 0)))
	;; Check for XML bombs.
	(and xml-entity-expansion-limit
	     (> (- (buffer-size) (point))
		(+ old-remaining-size xml-entity-expansion-limit))
	     (error "XML: Entity reference expansion \
surpassed `xml-entity-expansion-limit'"))))
    ;; [2.11] Clean up line breaks.
    (let ((end-marker (point-marker)))
      (goto-char start)
      (while (re-search-forward "\r\n?" end-marker t)
	(replace-match "\n" t t))
      (goto-char end-marker)
      (buffer-substring start (point)))))

(defun xml-parse-attlist (&optional xml-ns)
  "Return the attribute-list after point.
Leave point at the first non-blank character after the tag."
  (let ((attlist ())
	end-pos name)
    (skip-syntax-forward " ")
    (while (looking-at (eval-when-compile
			 (concat "\\(" xml-name-re "\\)\\s-*=\\s-*")))
      (setq end-pos (match-end 0))
      (setq name (xml-maybe-do-ns (match-string-no-properties 1) nil xml-ns))
      (goto-char end-pos)

      ;; See also: http://www.w3.org/TR/2000/REC-xml-20001006#AVNormalize

      ;; Do we have a string between quotes (or double-quotes),
      ;;  or a simple word ?
      (if (looking-at "\"\\([^\"]*\\)\"")
	  (setq end-pos (match-end 0))
	(if (looking-at "'\\([^']*\\)'")
	    (setq end-pos (match-end 0))
	  (error "XML: (Not Well-Formed) Attribute values must be given between quotes")))

      ;; Each attribute must be unique within a given element
      (if (assoc name attlist)
	  (error "XML: (Not Well-Formed) Each attribute must be unique within an element"))

      ;; Multiple whitespace characters should be replaced with a single one
      ;; in the attributes
      (let ((string (match-string-no-properties 1)))
	(replace-regexp-in-string "\\s-\\{2,\\}" " " string)
	(let ((expansion (xml-substitute-special string)))
	  (unless (stringp expansion)
	    ;; We say this is the constraint.  It is actually that
	    ;; neither external entities nor "<" can be in an
	    ;; attribute value.
	    (error "XML: (Not Well-Formed) Entities in attributes cannot expand into elements"))
	  (push (cons name expansion) attlist)))

      (goto-char end-pos)
      (skip-syntax-forward " "))
    (nreverse attlist)))

;;; DTD (document type declaration)

;; The following functions know how to skip or parse the DTD of a
;; document.  FIXME: it fails at least if the DTD contains conditional
;; sections.

(defun xml-skip-dtd ()
  "Skip the DTD at point.
This follows the rule [28] in the XML specifications."
  (let ((xml-validating-parser nil))
    (xml-parse-dtd)))

(defun xml-parse-dtd (&optional parse-ns)
  "Parse the DTD at point."
  (forward-char (eval-when-compile (length "<!DOCTYPE")))
  (skip-syntax-forward " ")
  (if (and (looking-at ">")
	   xml-validating-parser)
      (error "XML: (Validity) Invalid DTD (expecting name of the document)"))

  ;;  Get the name of the document
  (looking-at xml-name-re)
  (let ((dtd (list (match-string-no-properties 0) 'dtd))
	(xml-parameter-entity-alist xml-parameter-entity-alist)
	next-parameter-entity)
    (goto-char (match-end 0))
    (skip-syntax-forward " ")

    ;; External subset (XML [75])
    (cond ((looking-at "PUBLIC\\s-+")
	   (goto-char (match-end 0))
	   (unless (or (re-search-forward
			"\\=\"\\([[:space:][:alnum:]-'()+,./:=?;!*#@$_%]*\\)\""
			nil t)
		       (re-search-forward
			"\\='\\([[:space:][:alnum:]-()+,./:=?;!*#@$_%]*\\)'"
			nil t))
	     (error "XML: Missing Public ID"))
	   (let ((pubid (match-string-no-properties 1)))
	     (skip-syntax-forward " ")
	     (unless (or (re-search-forward "\\='\\([^']*\\)'" nil t)
			 (re-search-forward "\\=\"\\([^\"]*\\)\"" nil t))
	       (error "XML: Missing System ID"))
	     (push (list pubid (match-string-no-properties 1) 'public) dtd)))
	  ((looking-at "SYSTEM\\s-+")
	   (goto-char (match-end 0))
	   (unless (or (re-search-forward "\\='\\([^']*\\)'" nil t)
		       (re-search-forward "\\=\"\\([^\"]*\\)\"" nil t))
	     (error "XML: Missing System ID"))
	   (push (list (match-string-no-properties 1) 'system) dtd)))
    (skip-syntax-forward " ")

    (if (eq (char-after) ?>)

	;; No internal subset
	(forward-char)

      ;; Internal subset (XML [28b])
      (unless (eq (char-after) ?\[)
	(error "XML: Bad DTD"))
      (forward-char)

      ;; [2.8]: "markup declarations may be made up in whole or in
      ;; part of the replacement text of parameter entities."

      ;; Since parameter entities are valid only within the DTD, we
      ;; first search for the position of the next possible parameter
      ;; entity.  Then, search for the next DTD element; if it ends
      ;; before the next parameter entity, expand the parameter entity
      ;; and try again.
      (setq next-parameter-entity
	    (save-excursion
	      (if (re-search-forward xml-pe-reference-re nil t)
		  (match-beginning 0))))

      ;; Parse the rest of the DTD
      ;; Fixme: Deal with NOTATION, PIs.
      (while (not (looking-at "\\s-*\\]"))
	(skip-syntax-forward " ")
	(cond
	 ((eobp)
	  (error "XML: (Well-Formed) End of document while reading DTD"))
	 ;; Element declaration [45]:
	 ((and (looking-at (eval-when-compile
			     (concat "<!ELEMENT\\s-+\\(" xml-name-re
				     "\\)\\s-+\\([^>]+\\)>")))
	       (or (null next-parameter-entity)
		   (<= (match-end 0) next-parameter-entity)))
	  (let ((element (match-string-no-properties 1))
		(type    (match-string-no-properties 2))
		(end-pos (match-end 0)))
	    ;; Translation of rule [46] of XML specifications
	    (cond
	     ((string-match "\\`EMPTY\\s-*\\'" type)  ; empty declaration
	      (setq type 'empty))
	     ((string-match "\\`ANY\\s-*$" type)      ; any type of contents
	      (setq type 'any))
	     ((string-match "\\`(\\(.*\\))\\s-*\\'" type) ; children ([47])
	      (setq type (xml-parse-elem-type
			  (match-string-no-properties 1 type))))
	     ((string-match "^%[^;]+;[ \t\n\r]*\\'" type) ; substitution
	      nil)
	     (xml-validating-parser
	      (error "XML: (Validity) Invalid element type in the DTD")))

	    ;; rule [45]: the element declaration must be unique
	    (and (assoc element dtd)
		 xml-validating-parser
		 (error "XML: (Validity) DTD element declarations must be unique (<%s>)"
			element))

	    ;;  Store the element in the DTD
	    (push (list element type) dtd)
	    (goto-char end-pos)))

	 ;; Attribute-list declaration [52] (currently unsupported):
	 ((and (looking-at (eval-when-compile
			     (concat "<!ATTLIST[ \t\n\r]*\\(" xml-name-re
				     "\\)[ \t\n\r]*\\(" xml-att-def-re
				     "\\)*[ \t\n\r]*>")))
	       (or (null next-parameter-entity)
		   (<= (match-end 0) next-parameter-entity)))
	  (goto-char (match-end 0)))

	 ;; Comments (skip to end, ignoring parameter entity):
	 ((looking-at "<!--")
	  (search-forward "-->")
	  (and next-parameter-entity
	       (> (point) next-parameter-entity)
	       (setq next-parameter-entity
		     (save-excursion
		       (if (re-search-forward xml-pe-reference-re nil t)
			   (match-beginning 0))))))

	 ;; Internal entity declarations:
	 ((and (looking-at (eval-when-compile
			     (concat "<!ENTITY[ \t\n\r]+\\(%[ \t\n\r]+\\)?\\("
				     xml-name-re "\\)[ \t\n\r]*\\("
				     xml-entity-value-re "\\)[ \t\n\r]*>")))
	       (or (null next-parameter-entity)
		   (<= (match-end 0) next-parameter-entity)))
	  (let* ((name (prog1 (match-string-no-properties 2)
			 (goto-char (match-end 0))))
		 (alist (if (match-string 1)
			    'xml-parameter-entity-alist
			  'xml-entity-alist))
		 ;; Retrieve the deplacement text:
		 (value (xml--entity-replacement-text
			 ;; Entity value, sans quotation marks:
			 (substring (match-string-no-properties 3) 1 -1))))
	    ;; If the same entity is declared more than once, the
	    ;; first declaration is binding.
	    (unless (assoc name (symbol-value alist))
	      (set alist (cons (cons name value) (symbol-value alist))))))

	 ;; External entity declarations (currently unsupported):
	 ((and (or (looking-at (eval-when-compile
				 (concat "<!ENTITY[ \t\n\r]+\\(%[ \t\n\r]+\\)?\\("
					 xml-name-re "\\)[ \t\n\r]+SYSTEM[ \t\n\r]+"
					 "\\(\"[^\"]*\"\\|'[^']*'\\)[ \t\n\r]*>")))
		   (looking-at (eval-when-compile
				 (concat "<!ENTITY[ \t\n\r]+\\(%[ \t\n\r]+\\)?\\("
					 xml-name-re "\\)[ \t\n\r]+PUBLIC[ \t\n\r]+"
					 "\"[- \r\na-zA-Z0-9'()+,./:=?;!*#@$_%]*\""
					 "\\|'[- \r\na-zA-Z0-9()+,./:=?;!*#@$_%]*'"
					 "[ \t\n\r]+\\(\"[^\"]*\"\\|'[^']*'\\)"
					 "[ \t\n\r]*>"))))
	       (or (null next-parameter-entity)
		   (<= (match-end 0) next-parameter-entity)))
	  (goto-char (match-end 0)))

	 ;; If a parameter entity is in the way, expand it.
	 (next-parameter-entity
	  (save-excursion
	    (goto-char next-parameter-entity)
	    (unless (looking-at xml-pe-reference-re)
	      (error "XML: Internal error"))
	    (let* ((entity (match-string 1))
		   (beg    (point-marker))
		   (elt    (assoc entity xml-parameter-entity-alist)))
	      (if elt
		  (progn
		    (replace-match (cdr elt) t t)
		    ;; The replacement can itself be a parameter entity.
		    (goto-char next-parameter-entity))
		(goto-char (match-end 0))))
	    (setq next-parameter-entity
		  (if (re-search-forward xml-pe-reference-re nil t)
		      (match-beginning 0)))))

	 ;; Anything else is garbage (ignored if not validating).
	 (xml-validating-parser
	  (error "XML: (Validity) Invalid DTD item"))
	 (t
	  (skip-chars-forward "^]"))))

      (if (looking-at "\\s-*]>")
	  (goto-char (match-end 0))))
    (nreverse dtd)))

(defun xml--entity-replacement-text (string)
  "Return the replacement text for the entity value STRING.
The replacement text is obtained by replacing character
references and parameter-entity references."
  (let ((ref-re (eval-when-compile
		  (concat "\\(?:&#\\([0-9]+\\)\\|&#x\\([0-9a-fA-F]+\\)\\|%\\("
			  xml-name-re "\\)\\);")))
	children)
    (while (string-match ref-re string)
      (push (substring string 0 (match-beginning 0)) children)
      (let ((remainder (substring string (match-end 0)))
	    ref val)
	(cond ((setq ref (match-string 1 string))
	       ;; Decimal character reference
	       (setq val (decode-char 'ucs (string-to-number ref)))
	       (if val (push (string val) children)))
	      ;; Hexadecimal character reference
	      ((setq ref (match-string 2 string))
	       (setq val (decode-char 'ucs (string-to-number ref 16)))
	       (if val (push (string val) children)))
	      ;; Parameter entity reference
	      ((setq ref (match-string 3 string))
	       (setq val (assoc ref xml-parameter-entity-alist))
	       (and (null val)
		    xml-validating-parser
		    (error "XML: (Validity) Undefined parameter entity `%s'" ref))
	       (push (or (cdr val) xml-undefined-entity) children)))
	(setq string remainder)))
    (mapconcat 'identity (nreverse (cons string children)) "")))

(defun xml-parse-elem-type (string)
  "Convert element type STRING into a Lisp structure."

  (let (elem modifier)
    (if (string-match "(\\([^)]+\\))\\([+*?]?\\)" string)
	(progn
	  (setq elem     (match-string-no-properties 1 string)
		modifier (match-string-no-properties 2 string))
	  (if (string-match "|" elem)
	      (setq elem (cons 'choice
			       (mapcar 'xml-parse-elem-type
				       (split-string elem "|"))))
	    (if (string-match "," elem)
		(setq elem (cons 'seq
				 (mapcar 'xml-parse-elem-type
					 (split-string elem ",")))))))
      (if (string-match "[ \t\n\r]*\\([^+*?]+\\)\\([+*?]?\\)" string)
	  (setq elem	 (match-string-no-properties 1 string)
		modifier (match-string-no-properties 2 string))))

    (if (and (stringp elem) (string= elem "#PCDATA"))
	(setq elem 'pcdata))

    (cond
     ((string= modifier "+")
      (list '+ elem))
     ((string= modifier "*")
      (list '* elem))
     ((string= modifier "?")
      (list '\? elem))
     (t
      elem))))

;;; Substituting special XML sequences

(defun xml-substitute-special (string)
  "Return STRING, after substituting entity and character references.
STRING is assumed to occur in an XML attribute value."
  (let ((strlen (length string))
	children)
    (while (string-match xml-entity-or-char-ref-re string)
      (push (substring string 0 (match-beginning 0)) children)
      (let* ((remainder (substring string (match-end 0)))
	     (is-hex (match-string 1 string)) ; Is it a hex numeric reference?
	     (ref (match-string 2 string)))   ; Numeric part of reference
	(if ref
	    ;; [4.6] Character references are included as
	    ;; character data.
	    (let ((val (decode-char 'ucs (string-to-number ref (if is-hex 16)))))
	      (push (cond (val (string val))
			  (xml-validating-parser
			   (error "XML: (Validity) Undefined character `x%s'" ref))
			  (t xml-undefined-entity))
		    children)
	      (setq string remainder
		    strlen (length string)))
	  ;; [4.4.5] Entity references are "included in literal".
	  ;; Note that we don't need do anything special to treat
	  ;; quotes as normal data characters.
	  (setq ref (match-string 3 string)) ; entity name
	  (let ((val (or (cdr (assoc ref xml-entity-alist))
			 (if xml-validating-parser
			     (error "XML: (Validity) Undefined entity `%s'" ref)
			   xml-undefined-entity))))
	    (setq string (concat val remainder)))
	  (and xml-entity-expansion-limit
	       (> (length string) (+ strlen xml-entity-expansion-limit))
	       (error "XML: Passed `xml-entity-expansion-limit' while expanding `&%s;'"
		      ref)))))
    (mapconcat 'identity (nreverse (cons string children)) "")))

(defun xml-substitute-numeric-entities (string)
  "Substitute SGML numeric entities by their respective utf characters.
This function replaces numeric entities in the input STRING and
returns the modified string.  For example \"&#42;\" gets replaced
by \"*\"."
  (if (and string (stringp string))
      (let ((start 0))
        (while (string-match "&#\\([0-9]+\\);" string start)
          (condition-case nil
              (setq string (replace-match
                            (string (read (substring string
                                                     (match-beginning 1)
                                                     (match-end 1))))
                            nil nil string))
            (error nil))
          (setq start (1+ (match-beginning 0))))
        string)
    nil))

;;; Printing a parse tree (mainly for debugging).

(defun xml-debug-print (xml &optional indent-string)
  "Outputs the XML in the current buffer.
XML can be a tree or a list of nodes.
The first line is indented with the optional INDENT-STRING."
  (setq indent-string (or indent-string ""))
  (dolist (node xml)
    (xml-debug-print-internal node indent-string)))

(defalias 'xml-print 'xml-debug-print)

(defun xml-escape-string (string)
  "Convert STRING into a string containing valid XML character data.
Replace occurrences of &<>'\" in STRING with their default XML
entity references (e.g. replace each & with &amp;).

XML character data must not contain & or < characters, nor the >
character under some circumstances.  The XML spec does not impose
restriction on \" or ', but we just substitute for these too
\(as is permitted by the spec)."
  (with-temp-buffer
    (insert string)
    (dolist (substitution '(("&" . "&amp;")
			    ("<" . "&lt;")
			    (">" . "&gt;")
			    ("'" . "&apos;")
			    ("\"" . "&quot;")))
      (goto-char (point-min))
      (while (search-forward (car substitution) nil t)
	(replace-match (cdr substitution) t t nil)))
    (buffer-string)))

(defun xml-debug-print-internal (xml indent-string)
  "Outputs the XML tree in the current buffer.
The first line is indented with INDENT-STRING."
  (let ((tree xml)
	attlist)
    (insert indent-string ?< (symbol-name (xml-node-name tree)))

    ;;  output the attribute list
    (setq attlist (xml-node-attributes tree))
    (while attlist
      (insert ?\  (symbol-name (caar attlist)) "=\""
              (xml-escape-string (cdar attlist)) ?\")
      (setq attlist (cdr attlist)))

    (setq tree (xml-node-children tree))

    (if (null tree)
	(insert ?/ ?>)
      (insert ?>)

      ;;  output the children
      (dolist (node tree)
	(cond
	 ((listp node)
	  (insert ?\n)
	  (xml-debug-print-internal node (concat indent-string "  ")))
	 ((stringp node)
          (insert (xml-escape-string node)))
	 (t
	  (error "Invalid XML tree"))))

      (when (not (and (null (cdr tree))
		      (stringp (car tree))))
	(insert ?\n indent-string))
      (insert ?< ?/ (symbol-name (xml-node-name xml)) ?>))))

(provide 'xml)

;;; xml.el ends here
