;;; wisent-python.el --- Semantic support for Python

;; Copyright (C) 2002, 2004, 2006-2013 Free Software Foundation, Inc.

;; Author: Richard Kim  <emacs18@gmail.com>
;; Maintainer: Richard Kim  <emacs18@gmail.com>
;; Created: June 2002
;; Keywords: syntax

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
;; Parser support for Python.

;;; Code:

(require 'rx)

;; Try to load python support, but fail silently since it is only used
;; for optional functionality
(require 'python nil t)

(require 'semantic/wisent)
(require 'semantic/wisent/python-wy)
(require 'semantic/find)
(require 'semantic/dep)
(require 'semantic/ctxt)

(eval-when-compile
  (require 'cl))

;;; Customization
;;

(defun semantic-python-get-system-include-path ()
  "Evaluate some Python code that determines the system include path."
  (delq nil
	(mapcar
	 (lambda (dir)
	   (when (file-directory-p dir)
	     dir))
	 (split-string
	  (python-shell-internal-send-string
	   "import sys;print ('\\n'.join(sys.path))")
	  "\n" t))))

(defcustom-mode-local-semantic-dependency-system-include-path
  python-mode semantic-python-dependency-system-include-path
  (when (and (featurep 'python)
	     ;; python-mode and batch somehow often hangs.
	     (not noninteractive))
    (semantic-python-get-system-include-path))
  "The system include path used by Python language.")

;;; Lexical analysis
;;

;; Python strings are delimited by either single quotes or double
;; quotes, e.g., "I'm a string" and 'I too am a string'.
;; In addition a string can have either a 'r' and/or 'u' prefix.
;; The 'r' prefix means raw, i.e., normal backslash substitutions are
;; to be suppressed.  For example, r"01\n34" is a string with six
;; characters 0, 1, \, n, 3 and 4.  The 'u' prefix means the following
;; string is Unicode.
(defconst wisent-python-string-start-re "[uU]?[rR]?['\"]"
  "Regexp matching beginning of a Python string.")

(defconst wisent-python-string-re
  (rx
   (opt (any "uU")) (opt (any "rR"))
   (or
    ;; Triple-quoted string using apostrophes
    (: "'''" (zero-or-more (or "\\'"
                               (not (any "'"))
                               (: (repeat 1 2 "'") (not (any "'")))))
       "'''")
    ;; String using apostrophes
    (: "'" (zero-or-more (or "\\'"
                             (not (any "'"))))
       "'")
    ;; Triple-quoted string using quotation marks.
    (: "\"\"\"" (zero-or-more (or "\\\""
                                  (not (any "\""))
                                  (: (repeat 1 2 "\"") (not (any "\"")))))
       "\"\"\"")
    ;; String using quotation marks.
    (: "\"" (zero-or-more (or "\\\""
                              (not (any "\""))))
       "\"")))
  "Regexp matching a complete Python string.")

(defvar wisent-python-EXPANDING-block nil
  "Non-nil when expanding a paren block for Python lexical analyzer.")

(defun wisent-python-implicit-line-joining-p ()
  "Return non-nil if implicit line joining is active.
That is, if inside an expression in parentheses, square brackets or
curly braces."
  wisent-python-EXPANDING-block)

(defsubst wisent-python-forward-string ()
  "Move point at the end of the Python string at point."
  (if (looking-at wisent-python-string-re)
      (let ((start (match-beginning 0))
            (end (match-end 0)))
        ;; Incomplete triple-quoted string gets matched instead as a
        ;; complete single quoted string.  (This special case would be
        ;; unnecessary if Emacs regular expressions had negative
        ;; look-ahead assertions.)
        (when (and (= (- end start) 2)
                   (looking-at "\"\\{3\\}\\|'\\{3\\}"))
          (error "unterminated syntax"))
        (goto-char end))
    (error "unterminated syntax")))

(defun wisent-python-forward-balanced-expression ()
  "Move point to the end of the balanced expression at point.
Here 'balanced expression' means anything matched by Emacs'
open/close parenthesis syntax classes.  We can't use forward-sexp
for this because that Emacs built-in can't parse Python's
triple-quoted string syntax."
  (let ((end-char (cdr (syntax-after (point)))))
    (forward-char 1)
    (while (not (or (eobp) (eq (char-after (point)) end-char)))
      (cond
       ;; Skip over python strings.
       ((looking-at wisent-python-string-start-re)
        (wisent-python-forward-string))
       ;; At a comment start just goto end of line.
       ((looking-at "\\s<")
        (end-of-line))
       ;; Skip over balanced expressions.
       ((looking-at "\\s(")
        (wisent-python-forward-balanced-expression))
       ;; Skip over white space, word, symbol, punctuation, paired
       ;; delimiter (backquote) characters, line continuation, and end
       ;; of comment characters (AKA newline characters in Python).
       ((zerop (skip-syntax-forward "-w_.$\\>"))
        (error "can't figure out how to go forward from here"))))
    ;; Skip closing character.  As a last resort this should raise an
    ;; error if we hit EOB before we find our closing character..
    (forward-char 1)))

(defun wisent-python-forward-line ()
  "Move point to the beginning of the next logical line.
Usually this is simply the next physical line unless strings,
implicit/explicit line continuation, blank lines, or comment lines are
encountered.  This function skips over such items so that the point is
at the beginning of the next logical line.  If the current logical
line ends at the end of the buffer, leave the point there."
  (while (not (eolp))
    (when (= (point)
             (progn
               (cond
                ;; Skip over python strings.
                ((looking-at wisent-python-string-start-re)
                 (wisent-python-forward-string))
                ;; At a comment start just goto end of line.
                ((looking-at "\\s<")
                 (end-of-line))
                ;; Skip over balanced expressions.
                ((looking-at "\\s(")
                 (wisent-python-forward-balanced-expression))
                ;; At the explicit line continuation character
                ;; (backslash) move to next line.
                ((looking-at "\\s\\")
                 (forward-line 1))
                ;; Skip over white space, word, symbol, punctuation,
                ;; and paired delimiter (backquote) characters.
                ((skip-syntax-forward "-w_.$)")))
               (point)))
      (error "python-forward-line endless loop detected")))
  ;; The point is at eol, skip blank and comment lines.
  (forward-comment (point-max))
  ;; Goto the beginning of the next line.
  (or (eobp) (beginning-of-line)))

(defun wisent-python-forward-line-skip-indented ()
  "Move point to the next logical line, skipping indented lines.
That is the next line whose indentation is less than or equal to
the indentation of the current line."
  (let ((indent (current-indentation)))
    (while (progn (wisent-python-forward-line)
                  (and (not (eobp))
                       (> (current-indentation) indent))))))

(defun wisent-python-end-of-block ()
  "Move point to the end of the current block."
  (let ((indent (current-indentation)))
    (while (and (not (eobp)) (>= (current-indentation) indent))
      (wisent-python-forward-line-skip-indented))
    ;; Don't include final comments in current block bounds
    (forward-comment (- (point-max)))
    (or (bolp) (forward-line 1))
    ))

;; Indentation stack, what the Python (2.3) language spec. says:
;;
;; The indentation levels of consecutive lines are used to generate
;; INDENT and DEDENT tokens, using a stack, as follows.
;;
;; Before the first line of the file is read, a single zero is pushed
;; on the stack; this will never be popped off again. The numbers
;; pushed on the stack will always be strictly increasing from bottom
;; to top. At the beginning of each logical line, the line's
;; indentation level is compared to the top of the stack. If it is
;; equal, nothing happens. If it is larger, it is pushed on the stack,
;; and one INDENT token is generated. If it is smaller, it must be one
;; of the numbers occurring on the stack; all numbers on the stack
;; that are larger are popped off, and for each number popped off a
;; DEDENT token is generated. At the end of the file, a DEDENT token
;; is generated for each number remaining on the stack that is larger
;; than zero.
(defvar wisent-python-indent-stack)

(define-lex-analyzer wisent-python-lex-beginning-of-line
  "Detect and create Python indentation tokens at beginning of line."
  (and
   (bolp) (not (wisent-python-implicit-line-joining-p))
   (let ((last-indent (car wisent-python-indent-stack))
         (last-pos (point))
         (curr-indent (current-indentation)))
     (skip-syntax-forward "-")
     (cond
      ;; Skip comments and blank lines. No change in indentation.
      ((or (eolp) (looking-at semantic-lex-comment-regex))
       (forward-comment (point-max))
       (or (eobp) (beginning-of-line))
       (setq semantic-lex-end-point (point))
       ;; Loop lexer to handle the next line.
       t)
      ;; No change in indentation.
      ((= curr-indent last-indent)
       (setq semantic-lex-end-point (point))
       ;; Try next analyzers.
       nil)
      ;; Indentation increased
      ((> curr-indent last-indent)
       (if (or (not semantic-lex-maximum-depth)
               (< semantic-lex-current-depth semantic-lex-maximum-depth))
           (progn
             ;; Return an INDENT lexical token
             (setq semantic-lex-current-depth (1+ semantic-lex-current-depth))
             (push curr-indent wisent-python-indent-stack)
             (semantic-lex-push-token
              (semantic-lex-token 'INDENT last-pos (point))))
         ;; Add an INDENT_BLOCK token
         (semantic-lex-push-token
          (semantic-lex-token
           'INDENT_BLOCK
           (progn (beginning-of-line) (point))
           (semantic-lex-unterminated-syntax-protection 'INDENT_BLOCK
             (wisent-python-end-of-block)
             (point)))))
       ;; Loop lexer to handle tokens in current line.
       t)
      ;; Indentation decreased
      ((progn
	 ;; Pop items from indentation stack
	 (while (< curr-indent last-indent)
	   (pop wisent-python-indent-stack)
	   (setq semantic-lex-current-depth (1- semantic-lex-current-depth)
		 last-indent (car wisent-python-indent-stack))
	   (semantic-lex-push-token
	    (semantic-lex-token 'DEDENT last-pos (point))))
	 (= last-pos (point)))
       ;; If pos did not change, then we must return nil so that
       ;; other lexical analyzers can be run.
       nil))))
  ;; All the work was done in the above analyzer matching condition.
  )

(define-lex-regex-analyzer wisent-python-lex-end-of-line
  "Detect and create Python newline tokens.
Just skip the newline character if the following line is an implicit
continuation of current line."
  "\\(\n\\|\\s>\\)"
  (if (wisent-python-implicit-line-joining-p)
      (setq semantic-lex-end-point (match-end 0))
    (semantic-lex-push-token
     (semantic-lex-token 'NEWLINE (point) (match-end 0)))))

(define-lex-regex-analyzer wisent-python-lex-string
  "Detect and create python string tokens."
  wisent-python-string-start-re
  (semantic-lex-push-token
   (semantic-lex-token
    'STRING_LITERAL
    (point)
    (semantic-lex-unterminated-syntax-protection 'STRING_LITERAL
      (wisent-python-forward-string)
      (point)))))

(define-lex-regex-analyzer wisent-python-lex-ignore-backslash
  "Detect and skip over backslash (explicit line joining) tokens.
A backslash must be the last token of a physical line, it is illegal
elsewhere on a line outside a string literal."
  "\\s\\\\s-*$"
  ;; Skip over the detected backslash and go to the first
  ;; non-whitespace character in the next physical line.
  (forward-line)
  (skip-syntax-forward "-")
  (setq semantic-lex-end-point (point)))

(define-lex wisent-python-lexer
  "Lexical Analyzer for Python code."
  ;; Must analyze beginning of line first to handle indentation.
  wisent-python-lex-beginning-of-line
  wisent-python-lex-end-of-line
  ;; Must analyze string before symbol to handle string prefix.
  wisent-python-lex-string
  ;; Analyzers auto-generated from grammar.
  wisent-python-wy--<number>-regexp-analyzer
  wisent-python-wy--<keyword>-keyword-analyzer
  wisent-python-wy--<symbol>-regexp-analyzer
  wisent-python-wy--<block>-block-analyzer
  wisent-python-wy--<punctuation>-string-analyzer
  ;; Ignored things.
  wisent-python-lex-ignore-backslash
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-comments
  ;; Signal error on unhandled syntax.
  semantic-lex-default-action)


;;; Parsing
;;

(defun wisent-python-reconstitute-function-tag (tag suite)
  "Move a docstring from TAG's members into its :documentation attribute.
Set attributes for constructors, special, private and static methods."
  ;; Analyze first statement to see whether it is a documentation
  ;; string.
  (let ((first-statement (car suite)))
    (when (semantic-python-docstring-p first-statement)
      (semantic-tag-put-attribute
       tag :documentation
       (semantic-python-extract-docstring first-statement))))

  ;; TODO HACK: we try to identify methods using the following
  ;; heuristic:
  ;; + at least one argument
  ;; + first argument is self
  (when (and (> (length (semantic-tag-function-arguments tag)) 0)
	     (string= (semantic-tag-name
		       (first (semantic-tag-function-arguments tag)))
		      "self"))
    (semantic-tag-put-attribute tag :parent "dummy"))

  ;; Identify constructors, special and private functions
  (cond
   ;; TODO only valid when the function resides inside a class
   ((string= (semantic-tag-name tag) "__init__")
    (semantic-tag-put-attribute tag :constructor-flag t)
    (semantic-tag-put-attribute tag :suite            suite))

   ((semantic-python-special-p tag)
    (semantic-tag-put-attribute tag :special-flag t))

   ((semantic-python-private-p tag)
    (semantic-tag-put-attribute tag :protection "private")))

  ;; If there is a staticmethod decorator, add a static typemodifier
  ;; for the function.
  (when (semantic-find-tags-by-name
	 "staticmethod"
	 (semantic-tag-get-attribute tag :decorators))
    (semantic-tag-put-attribute
     tag :typemodifiers
     (cons "static"
	   (semantic-tag-get-attribute tag :typemodifiers))))

  ;; TODO
  ;; + check for decorators classmethod
  ;; + check for operators
  tag)

(defun wisent-python-reconstitute-class-tag (tag)
  "Move a docstring from TAG's members into its :documentation attribute."
  ;; The first member of TAG may be a documentation string. If that is
  ;; the case, remove of it from the members list and stick its
  ;; content into the :documentation attribute.
  (let ((first-member (car (semantic-tag-type-members tag))))
    (when (semantic-python-docstring-p first-member)
      (semantic-tag-put-attribute
       tag :members
       (cdr (semantic-tag-type-members tag)))
      (semantic-tag-put-attribute
       tag :documentation
       (semantic-python-extract-docstring first-member))))

  ;; Try to find the constructor, determine the name of the instance
  ;; parameter, find assignments to instance variables and add
  ;; corresponding variable tags to the list of members.
  (dolist (member (semantic-tag-type-members tag))
    (when (semantic-tag-function-constructor-p member)
      (let ((self (semantic-tag-name
		   (car (semantic-tag-function-arguments member)))))
	(dolist (statement (semantic-tag-get-attribute member :suite))
	  (when (semantic-python-instance-variable-p statement self)
	    (let ((variable (semantic-tag-clone
			     statement
			     (substring (semantic-tag-name statement) 5)))
		  (members  (semantic-tag-get-attribute tag :members)))
	      (when (semantic-python-private-p variable)
		(semantic-tag-put-attribute variable :protection "private"))
	      (setcdr (last members) (list variable))))))))

  ;; TODO remove the :suite attribute
  tag)

(defun semantic-python-expand-tag (tag)
  "Expand compound declarations found in TAG into separate tags.
TAG contains compound declaration if the NAME part of the tag is
a list.  In python, this can happen with `import' statements."
  (let ((class (semantic-tag-class tag))
	(elts (semantic-tag-name tag))
	(expand nil))
    (cond
     ((and (eq class 'include) (listp elts))
      (dolist (E elts)
	(setq expand (cons (semantic-tag-clone tag E) expand)))
      (setq expand (nreverse expand)))
     )))



;;; Overridden Semantic API.
;;

(define-mode-local-override semantic-lex python-mode
  (start end &optional depth length)
  "Lexically analyze Python code in current buffer.
See the function `semantic-lex' for the meaning of the START, END,
DEPTH and LENGTH arguments.
This function calls `wisent-python-lexer' to actually perform the
lexical analysis, then emits the necessary Python DEDENT tokens from
what remains in the `wisent-python-indent-stack'."
  (let* ((wisent-python-indent-stack (list 0))
         (stream (wisent-python-lexer start end depth length))
         (semantic-lex-token-stream nil))
    ;; Emit DEDENT tokens if something remains in the INDENT stack.
    (while (> (pop wisent-python-indent-stack) 0)
      (semantic-lex-push-token (semantic-lex-token 'DEDENT end end)))
    (nconc stream (nreverse semantic-lex-token-stream))))

(define-mode-local-override semantic-get-local-variables python-mode ()
  "Get the local variables based on point's context.
To be implemented for Python!  For now just return nil."
  nil)

;; Adapted from the semantic Java support by Andrey Torba
(define-mode-local-override semantic-tag-include-filename python-mode (tag)
  "Return a suitable path for (some) Python imports."
  (let ((name (semantic-tag-name tag)))
    (concat (mapconcat 'identity (split-string name "\\.") "/") ".py")))

;; Override ctxt-current-function/assignment defaults, since they do
;; not work properly with Python code, even leading to endless loops
;; (see bug #xxxxx).
(define-mode-local-override semantic-ctxt-current-function python-mode (&optional point)
  "Return the current function call the cursor is in at POINT.
The function returned is the one accepting the arguments that
the cursor is currently in.  It will not return function symbol if the
cursor is on the text representing that function."
  nil)

(define-mode-local-override semantic-ctxt-current-assignment python-mode (&optional point)
  "Return the current assignment near the cursor at POINT.
Return a list as per `semantic-ctxt-current-symbol'.
Return nil if there is nothing relevant."
  nil)

;;; Enable Semantic in `python-mode'.
;;

;;;###autoload
(defun wisent-python-default-setup ()
  "Setup buffer for parse."
  (wisent-python-wy--install-parser)
  (set (make-local-variable 'parse-sexp-ignore-comments) t)
  ;; Give python modes the possibility to overwrite this:
  (if (not comment-start-skip)
      (set (make-local-variable 'comment-start-skip) "#+\\s-*"))
  (setq
  ;; Character used to separation a parent/child relationship
   semantic-type-relation-separator-character '(".")
   semantic-command-separation-character ";"
   ;; Parsing
   semantic-tag-expand-function 'semantic-python-expand-tag

   ;; Semantic to take over from the one provided by python.
   ;; The python one, if it uses the senator advice, will hang
   ;; Emacs unrecoverably.
   imenu-create-index-function 'semantic-create-imenu-index

   ;; I need a python guru to update this list:
   semantic-symbol->name-assoc-list-for-type-parts '((variable . "Variables")
						     (function . "Methods"))
   semantic-symbol->name-assoc-list '((type . "Classes")
				      (variable . "Variables")
				      (function . "Functions")
				      (include  . "Imports")
				      (package  . "Package")
				      (code . "Code")))
   )

;;;###autoload
(add-hook 'python-mode-hook 'wisent-python-default-setup)

;; Make sure the newer python modes pull in the same python
;; mode overrides.
(define-child-mode python-2-mode python-mode "Python 2 mode")
(define-child-mode python-3-mode python-mode "Python 3 mode")


;;; Utility functions
;;

(defun semantic-python-special-p (tag)
  "Return non-nil if the name of TAG is a special identifier of
the form __NAME__. "
  (string-match
   (rx (seq string-start "__" (1+ (syntax symbol)) "__" string-end))
   (semantic-tag-name tag)))

(defun semantic-python-private-p (tag)
  "Return non-nil if the name of TAG follows the convention _NAME
for private names."
  (string-match
   (rx (seq string-start "_" (0+ (syntax symbol)) string-end))
   (semantic-tag-name tag)))

(defun semantic-python-instance-variable-p (tag &optional self)
  "Return non-nil if TAG is an instance variable of the instance
SELF or the instance name \"self\" if SELF is nil."
  (when (semantic-tag-of-class-p tag 'variable)
    (let ((name (semantic-tag-name tag)))
      (when (string-match
	     (rx-to-string
	      `(seq string-start ,(or self "self") "."))
	     name)
	(not (string-match "\\." (substring name 5)))))))

(defun semantic-python-docstring-p (tag)
  "Return non-nil, when TAG is a Python documentation string."
  ;; TAG is considered to be a documentation string if the first
  ;; member is of class 'code and its name looks like a documentation
  ;; string.
  (let ((class (semantic-tag-class tag))
	(name  (semantic-tag-name  tag)))
    (and (eq class 'code)
	 (string-match
	  (rx (seq string-start "\"\"\"" (0+ anything) "\"\"\"" string-end))
	  name))))

(defun semantic-python-extract-docstring (tag)
  "Return the Python documentation string contained in TAG."
  ;; Strip leading and trailing """
  (let ((name (semantic-tag-name tag)))
    (substring name 3 -3)))


;;; Test
;;

(defun wisent-python-lex-buffer ()
  "Run `wisent-python-lexer' on current buffer."
  (interactive)
  (semantic-lex-init)
  (let ((token-stream (semantic-lex (point-min) (point-max) 0)))
    (with-current-buffer (get-buffer-create "*wisent-python-lexer*")
      (erase-buffer)
      (pp token-stream (current-buffer))
      (goto-char (point-min))
      (pop-to-buffer (current-buffer)))))

(provide 'semantic/wisent/python)

;; Local variables:
;; generated-autoload-file: "../loaddefs.el"
;; generated-autoload-load-name: "semantic/wisent/python"
;; End:

;;; semantic/wisent/python.el ends here
