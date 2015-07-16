;;; opascal.el --- major mode for editing Object Pascal source in Emacs  -*- lexical-binding: t -*-

;; Copyright (C) 1998-1999, 2001-2014 Free Software Foundation, Inc.

;; Authors: Ray Blaak <blaak@infomatch.com>,
;;          Simon South <ssouth@member.fsf.org>
;; Maintainer: Simon South <ssouth@member.fsf.org>
;; Keywords: languages

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

;; To enter OPascal mode when you find an Object Pascal source file, one must
;; override the auto-mode-alist to associate OPascal with .pas (and .dpr and
;; .dpk) files.  Emacs, by default, will otherwise enter Pascal mode. E.g.
;;
;; (autoload 'opascal-mode "opascal")
;; (add-to-list 'auto-mode-alist
;;              '("\\.\\(pas\\|dpr\\|dpk\\)\\'" . opascal-mode))

;; When you have entered OPascal mode, you may get more info by pressing
;; C-h m.

;; This OPascal mode implementation is fairly tolerant of syntax errors,
;; relying as much as possible on the indentation of the previous statement.
;; This also makes it faster and simpler, since there is less searching for
;; properly constructed beginnings.

;;; Code:

(defgroup opascal nil
  "Major mode for editing OPascal source in Emacs."
  :version "24.4"
  :group 'languages)

(defconst opascal-debug nil
  "True if in debug mode.")

(define-obsolete-variable-alias
  'delphi-search-path 'opascal-search-path "24.4")
(defcustom opascal-search-path "."
  "Directories to search when finding external units.
It is a list of directory strings.  If only a single directory,
it can be a single string instead of a list.  If a directory
ends in \"...\" then that directory is recursively searched."
  :type 'string)

(define-obsolete-variable-alias
  'delphi-indent-level 'opascal-indent-level "24.4")
(defcustom opascal-indent-level 3
  "Indentation of OPascal statements with respect to containing block.
E.g.

begin
   // This is an indent of 3.
end;"
  :type 'integer)

(define-obsolete-variable-alias
  'delphi-compound-block-indent 'opascal-compound-block-indent "24.4")
(defcustom opascal-compound-block-indent 0
  "Extra indentation for blocks in compound statements.  E.g.

// block indent = 0     vs      // block indent = 2
if b then                       if b then
begin                             begin
end else begin                    end
end;                            else
                                  begin
                                  end;"
  :type 'integer)

(define-obsolete-variable-alias
  'delphi-case-label-indent 'opascal-case-label-indent "24.4")
(defcustom opascal-case-label-indent opascal-indent-level
  "Extra indentation for case statement labels.  E.g.

// case indent = 0      vs      // case indent = 3
case value of                   case value of
v1: process_v1;                    v1: process_v1;
v2: process_v2;                    v2: process_v2;
else                            else
   process_else;                   process_else;
end;                            end;"
  :type 'integer)

(define-obsolete-variable-alias 'delphi-verbose 'opascal-verbose "24.4")
(defcustom opascal-verbose t ; nil
  "If true then OPascal token processing progress is reported to the user."
  :type 'boolean)

(define-obsolete-variable-alias
  'delphi-tab-always-indents 'opascal-tab-always-indents "24.4")
(defcustom opascal-tab-always-indents tab-always-indent
  "Non-nil means `opascal-tab' should always reindent the current line.
That is, regardless of where in the line point is at the time."
  :type 'boolean)

(make-obsolete-variable 'opascal-tab-always-indents
                        "use `indent-for-tab-command' and `tab-always-indent'."
                        "24.4")

(defconst opascal-directives
  '(absolute abstract assembler automated cdecl default dispid dynamic
    export external far forward index inline message name near nodefault
    overload override pascal private protected public published read readonly
    register reintroduce resident resourcestring safecall stdcall stored
    virtual write writeonly)
  "OPascal4 directives.")

(defconst opascal-keywords
  (append
   '(;; Keywords.
     and array as asm at begin case class const constructor contains
     destructor dispinterface div do downto else end except exports
     file finalization finally for function goto if implementation implements
     in inherited initialization interface is label library mod nil not
     of object on or out package packed procedure program property
     raise record repeat requires result self set shl shr then threadvar
     to try type unit uses until var while with xor

     ;; These routines should be keywords, if Borland had the balls.
     break exit)

   ;; We want directives to look like keywords.
   opascal-directives)
  "OPascal4 keywords.")

(defconst opascal-previous-terminators `(semicolon comma)
  "Expression/statement terminators that denote a previous expression.")

(defconst opascal-comments
  '(comment-single-line comment-multi-line-1 comment-multi-line-2)
  "Tokens that represent comments.")

(defconst opascal-strings
  '(string double-quoted-string)
  "Tokens that represent string literals.")

(defconst opascal-whitespace `(space newline ,@opascal-comments)
  "Tokens that are considered whitespace.")

(defconst opascal-routine-statements
  '(procedure function constructor destructor property)
  "Marks the start of a routine, or routine-ish looking expression.")

(defconst opascal-body-expr-statements '(if while for on)
  "Statements that have either a single statement or a block as a body and also
are followed by an expression.")

(defconst opascal-expr-statements `(case ,@opascal-body-expr-statements)
  "Expression statements contain expressions after their keyword.")

(defconst opascal-body-statements `(else ,@opascal-body-expr-statements)
  "Statements that have either a single statement or a block as a body.")

(defconst opascal-expr-delimiters '(then do of)
  "Expression delimiter tokens.")

(defconst opascal-binary-ops
  '(plus minus equals not-equals times divides div mod and or xor)
  "OPascal binary operations.")

(defconst opascal-visibilities '(public private protected published automated)
  "Class visibilities.")

(defconst opascal-block-statements
  '(begin try case repeat initialization finalization asm)
  "Statements that contain multiple substatements.")

(defconst opascal-mid-block-statements
  `(except finally ,@opascal-visibilities)
  "Statements that mark mid sections of the enclosing block.")

(defconst opascal-end-block-statements `(end until)
  "Statements that end block sections.")

(defconst opascal-match-block-statements
  `(,@opascal-end-block-statements ,@opascal-mid-block-statements)
  "Statements that match the indentation of the parent block.")

(defconst opascal-decl-sections '(type const var label resourcestring)
  "Denotes the start of a declaration section.")

(defconst opascal-interface-types '(dispinterface interface)
  "Interface types.")

(defconst opascal-class-types '(class object)
  "Class types.")

(defconst opascal-composite-types
  `(,@opascal-class-types ,@opascal-interface-types record)
  "Types that contain declarations within them.")

(defconst opascal-unit-sections
  '(interface implementation program library package)
  "Unit sections within which the indent is 0.")

(defconst opascal-use-clauses `(uses requires exports contains)
  "Statements that refer to foreign symbols.")

(defconst opascal-unit-statements
  `(,@opascal-use-clauses ,@opascal-unit-sections initialization finalization)
  "Statements indented at level 0.")

(defconst opascal-decl-delimiters
  `(,@opascal-decl-sections ,@opascal-unit-statements
    ,@opascal-routine-statements)
  "Statements that a declaration statement should align with.")

(defconst opascal-decl-matchers
  `(begin ,@opascal-decl-sections)
  "Statements that should match to declaration statement indentation.")

(defconst opascal-enclosing-statements
  `(,@opascal-block-statements ,@opascal-mid-block-statements
    ,@opascal-decl-sections ,@opascal-use-clauses ,@opascal-routine-statements)
  "Delimits an enclosing statement.")

(defconst opascal-previous-statements
  `(,@opascal-unit-statements ,@opascal-routine-statements)
  "Delimits a previous statement.")

(defconst opascal-previous-enclosing-statements
  `(,@opascal-block-statements ,@opascal-mid-block-statements
    ,@opascal-decl-sections)
  "Delimits a previous enclosing statement.")

(defconst opascal-begin-enclosing-tokens
  `(,@opascal-block-statements ,@opascal-mid-block-statements)
  "Tokens that a begin token indents from.")

(defconst opascal-begin-previous-tokens
  `(,@opascal-decl-sections ,@opascal-routine-statements)
  "Tokens that a begin token aligns with, but only if not part of a nested
routine.")

(defconst opascal-space-chars "\000-\011\013- ") ; all except \n
(defconst opascal-non-space-chars (concat "^" opascal-space-chars))
(defconst opascal-spaces-re (concat "[" opascal-space-chars "]*"))
(defconst opascal-leading-spaces-re (concat "^" opascal-spaces-re))
(defconst opascal-word-chars "a-zA-Z0-9_")

(defvar opascal-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; Strings.
    (modify-syntax-entry ?\" "\"" st)
    (modify-syntax-entry ?\' "\"" st)
    ;; Comments.
    (modify-syntax-entry ?\{ "<" st)
    (modify-syntax-entry ?\} ">" st)
    (modify-syntax-entry ?\( "()1" st)
    (modify-syntax-entry ?\) ")(4" st)
    (modify-syntax-entry ?*  ". 23b" st)
    (modify-syntax-entry ?/  ". 12c" st)
    (modify-syntax-entry ?\n "> c" st)
    st))

(defmacro opascal-save-excursion (&rest forms)
  ;; Executes the forms such that any movements have no effect, including
  ;; searches.
  `(save-excursion
     (save-match-data
      (let ((inhibit-point-motion-hooks t)
            (deactivate-mark nil))
        (progn ,@forms)))))

(defsubst opascal-is (element in-set)
  ;; If the element is in the set, the element cdr is returned, otherwise nil.
  (memq element in-set))

(defun opascal-string-of (start end)
  ;; Returns the buffer string from start to end.
  (buffer-substring-no-properties start end))

(defun opascal-looking-at-string (p s)
  ;; True if point p marks the start of string s. s is not a regular
  ;; expression.
  (let ((limit (+ p (length s))))
    (and (<= limit (point-max))
         (string= s (opascal-string-of p limit)))))

(defun opascal-token-of (kind start end)
  ;; Constructs a token from a kind symbol and its start/end points.
  `[,kind ,start ,end])

(defsubst opascal-token-kind (token)
  ;; Returns the kind symbol of the token.
  (if token (aref token 0) nil))

(defun opascal-set-token-kind (token to-kind)
  ;; Sets the kind symbol of the token.
  (if token (aset token 0 to-kind)))

(defsubst opascal-token-start (token)
  ;; Returns the start point of the token.
  (if token (aref token 1) (point-min)))

(defsubst opascal-token-end (token)
  ;; Returns the end point of the token.
  (if token (aref token 2) (point-min)))

(defun opascal-set-token-start (token start)
  ;; Sets the start point of the token.
  (if token (aset token 1 start)))

(defun opascal-set-token-end (token end)
  ;; Sets the end point of the token.
  (if token (aset token 2 end)))

(defun opascal-token-string (token)
  ;; Returns the string image of the token.
  (if token
      (opascal-string-of (opascal-token-start token) (opascal-token-end token))
    ""))

(defun opascal-in-token (p token)
  ;; Returns true if the point p is within the token's start/end points.
  (and (<= (opascal-token-start token) p) (< p (opascal-token-end token))))

(defun opascal-column-of (p)
  ;; Returns the column of the point p.
  (save-excursion (goto-char p) (current-column)))

(defvar opascal-progress-last-reported-point nil
  "The last point at which progress was reported.")

(defconst opascal-parsing-progress-step 16384
  "Number of chars to process before the next parsing progress report.")
(defconst opascal-scanning-progress-step 2048
  "Number of chars to process before the next scanning progress report.")

(defun opascal-progress-start ()
  ;; Initializes progress reporting.
  (setq opascal-progress-last-reported-point nil))

(defun opascal-progress-done (&rest msgs)
  ;; Finalizes progress reporting.
  (setq opascal-progress-last-reported-point nil)
  (when opascal-verbose
     (if (null msgs)
         (message "")
       (apply #'message msgs))))

(defun opascal-step-progress (p desc step-size)
  ;; If enough distance has elapsed since the last reported point, then report
  ;; the current progress to the user.
  (cond ((null opascal-progress-last-reported-point)
         ;; This is the first progress step.
         (setq opascal-progress-last-reported-point p))

        ((and opascal-verbose
              (>= (abs (- p opascal-progress-last-reported-point)) step-size))
         ;; Report the percentage complete.
         (setq opascal-progress-last-reported-point p)
         (message "%s %s ... %d%%"
                  desc (buffer-name) (/ (* 100 p) (point-max))))))

(defun opascal-next-line-start (&optional from-point)
  ;; Returns the first point of the next line.
  (let ((curr-point (point))
        (next nil))
    (if from-point (goto-char from-point))
    (end-of-line)
    (setq next (min (1+ (point)) (point-max)))
    (goto-char curr-point)
    next))

(defconst opascal--literal-start-re (regexp-opt '("//" "{" "(*" "'" "\"")))

(defun opascal-literal-kind (p)
  ;; Returns the literal kind the point p is in (or nil if not in a literal).
  (when (and (<= (point-min) p) (<= p (point-max)))
    (save-excursion
      (let ((ppss (syntax-ppss p)))
        ;; We want to return non-nil when right in front
        ;; of a comment/string.
        (if (null (nth 8 ppss))
            (when (looking-at opascal--literal-start-re)
              (pcase (char-after)
                (`?/  'comment-single-line)
                (`?\{ 'comment-multi-line-1)
                (`?\( 'comment-multi-line-2)
                (`?\' 'string)
                (`?\" 'double-quoted-string)))
          (if (nth 3 ppss)   ;String.
              (if (eq (nth 3 ppss) ?\")
                  'double-quoted-string 'string)
            (pcase (nth 7 ppss)
              (`2 'comment-single-line)
              (`1 'comment-multi-line-2)
              (_  'comment-multi-line-1))))))))

(defun opascal-literal-start-pattern (literal-kind)
  ;; Returns the start pattern of the literal kind.
  (cdr (assoc literal-kind
              '((comment-single-line . "//")
                (comment-multi-line-1 . "{")
                (comment-multi-line-2 . "(*")
                (string . "'")
                (double-quoted-string . "\"")))))

(defun opascal-literal-end-pattern (literal-kind)
  ;; Returns the end pattern of the literal kind.
  (cdr (assoc literal-kind
              '((comment-single-line . "\n")
                (comment-multi-line-1 . "}")
                (comment-multi-line-2 . "*)")
                (string . "'")
                (double-quoted-string . "\"")))))

(defun opascal-literal-stop-pattern (literal-kind)
  ;; Returns the pattern that delimits end of the search for the literal kind.
  ;; These are regular expressions.
  (cdr (assoc literal-kind
              '((comment-single-line . "\n")
                (comment-multi-line-1 . "}")
                (comment-multi-line-2 . "\\*)")
                ;; Strings cannot span lines.
                (string . "['\n]")
                (double-quoted-string . "[\"\n]")))))

(defun opascal-is-literal-end (p)
  ;; True if the point p is at the end point of a (completed) literal.
  (save-excursion
    (and (null (nth 8 (syntax-ppss p)))
         (nth 8 (syntax-ppss (1- p))))))

(defun opascal-literal-token-at (p)
  "Return the literal token surrounding the point P, or nil if none."
  (save-excursion
    (let ((ppss (syntax-ppss p)))
      (when (or (nth 8 ppss) (looking-at opascal--literal-start-re))
        (let* ((new-start (or (nth 8 ppss) p))
               (new-end (progn
                          (goto-char new-start)
                          (condition-case nil
                              (if (memq (char-after) '(?\' ?\"))
                                  (forward-sexp 1)
                                (forward-comment 1))
                            (scan-error (goto-char (point-max))))
                          (point))))
          (opascal-token-of (opascal-literal-kind p) new-start new-end))))))

(defun opascal-point-token-at (p kind)
  ;; Returns the single character token at the point p.
  (opascal-token-of kind p (1+ p)))

(defsubst opascal-char-token-at (p char kind)
  ;; Returns the token at the point p that describes the specified character.
  ;; If not actually over such a character, nil is returned.
  (when (eq char (char-after p))
    (opascal-token-of kind p (1+ p))))

(defun opascal-charset-token-at (p charset kind)
  ;; Returns the token surrounding point p that contains only members of the
  ;; character set.
  (let ((currp (point))
        (end nil)
        (token nil))
    (goto-char p)
    (when (> (skip-chars-forward charset) 0)
       (setq end (point))
       (goto-char (1+ p))
       (skip-chars-backward charset)
       (setq token (opascal-token-of kind (point) end)))
    (goto-char currp)
    token))

(defun opascal-space-token-at (p)
  ;; If point p is surrounded by space characters, then return the token of the
  ;; contiguous spaces.
  (opascal-charset-token-at p opascal-space-chars 'space))

(defun opascal-word-token-at (p)
  ;; If point p is over a word (i.e. identifier characters), then return a word
  ;; token. If the word is actually a keyword, then return the keyword token.
  (let ((word (opascal-charset-token-at p opascal-word-chars 'word)))
    (when word
      (let* ((word-image (downcase (opascal-token-string word)))
             (keyword (intern-soft word-image)))
        (when (and (or keyword (string= "nil" word-image))
                   (opascal-is keyword opascal-keywords))
          (opascal-set-token-kind word keyword))
        word))))

(defun opascal-explicit-token-at (p token-string kind)
  ;; If point p is anywhere in the token string then returns the resulting
  ;; token.
  (let ((token (opascal-charset-token-at p token-string kind)))
    (when (and token (string= token-string (opascal-token-string token)))
       token)))

(defun opascal-token-at (p)
  ;; Returns the token from parsing text at point p.
  (when (and (<= (point-min) p) (<= p (point-max)))
     (cond ((opascal-char-token-at p ?\n 'newline))

           ((opascal-literal-token-at p))

           ((opascal-space-token-at p))

           ((opascal-word-token-at p))

           ((opascal-char-token-at p ?\( 'open-group))
           ((opascal-char-token-at p ?\) 'close-group))
           ((opascal-char-token-at p ?\[ 'open-group))
           ((opascal-char-token-at p ?\] 'close-group))
           ((opascal-char-token-at p ?\; 'semicolon))
           ((opascal-char-token-at p ?. 'dot))
           ((opascal-char-token-at p ?, 'comma))
           ((opascal-char-token-at p ?= 'equals))
           ((opascal-char-token-at p ?+ 'plus))
           ((opascal-char-token-at p ?- 'minus))
           ((opascal-char-token-at p ?* 'times))
           ((opascal-char-token-at p ?/ 'divides))
           ((opascal-char-token-at p ?: 'colon))

           ((opascal-explicit-token-at p "<>" 'not-equals))

           ((opascal-point-token-at p 'punctuation)))))

(defun opascal-current-token ()
  ;; Returns the opascal source token under the current point.
  (opascal-token-at (point)))

(defun opascal-next-token (token)
  ;; Returns the token after the specified token.
  (when token
     (let ((next (opascal-token-at (opascal-token-end token))))
       (if next
           (opascal-step-progress (opascal-token-start next) "Scanning"
                                 opascal-scanning-progress-step))
       next)))

(defun opascal-previous-token (token)
  ;; Returns the token before the specified token.
  (when token
     (let ((previous (opascal-token-at (1- (opascal-token-start token)))))
       (if previous
           (opascal-step-progress (opascal-token-start previous) "Scanning"
                                 opascal-scanning-progress-step))
       previous)))

(defun opascal-next-visible-token (token)
  ;; Returns the first non-space token after the specified token.
  (let (next-token)
    (while (progn
             (setq next-token (opascal-next-token token))
             (opascal-is (opascal-token-kind next-token) '(space newline))))
    next-token))

(defun opascal-group-start (from-token)
  ;; Returns the token that denotes the start of the ()/[] group.
  (let ((token (opascal-previous-token from-token))
        (token-kind nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; Skip over nested groups.
         ((eq 'close-group token-kind) (setq token (opascal-group-start token)))
         ((eq 'open-group token-kind) (throw 'done token)))
        (setq token (opascal-previous-token token)))
      ;; Start not found.
      nil)))

(defun opascal-group-end (from-token)
  ;; Returns the token that denotes the end of the ()/[] group.
  (let ((token (opascal-next-token from-token))
        (token-kind nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; Skip over nested groups.
         ((eq 'open-group token-kind) (setq token (opascal-group-end token)))
         ((eq 'close-group token-kind) (throw 'done token)))
        (setq token (opascal-next-token token)))
      ;; end not found.
      nil)))

(defun opascal-indent-of (token &optional offset)
  ;; Returns the start column of the token, plus any offset.
  (let ((indent (+ (opascal-column-of (opascal-token-start token))
                   (if offset offset 0))))
    (when opascal-debug
      (opascal-debug-log
       (concat "\n Indent of: %S %S"
               "\n column: %d indent: %d offset: %d")
       token (opascal-token-string token)
       (opascal-column-of (opascal-token-start token))
       indent (if offset offset 0)))
    indent))

(defun opascal-line-indent-of (from-token &optional offset &rest terminators)
  ;; Returns the column of first non-space character on the token's line, plus
  ;; any offset. We also stop if one of the terminators or an open ( or [ is
  ;; encountered.
  (let ((token (opascal-previous-token from-token))
        (last-token from-token)
        (kind nil))
    (catch 'done
      (while token
        (setq kind (opascal-token-kind token))
        (cond
         ;; Skip over ()/[] groups.
         ((eq 'close-group kind) (setq token (opascal-group-start token)))

         ;; Stop at the beginning of the line or an open group.
         ((opascal-is kind '(newline open-group)) (throw 'done nil))

         ;; Stop at one of the specified terminators.
         ((opascal-is kind terminators) (throw 'done nil)))
        (unless (opascal-is kind opascal-whitespace) (setq last-token token))
        (setq token (opascal-previous-token token))))
    (opascal-indent-of last-token offset)))

(defun opascal-stmt-line-indent-of (from-token &optional offset)
  ;; Like `opascal-line-indent-of' except is also stops on a use clause, and
  ;; colons that precede statements (i.e. case labels).
  (let ((token (opascal-previous-token from-token))
        (last-token from-token)
        (kind nil))
    (catch 'done
      (while token
        (setq kind (opascal-token-kind token))
        (cond
         ((and (eq 'colon kind)
               (opascal-is (opascal-token-kind last-token)
                          `(,@opascal-block-statements
                            ,@opascal-expr-statements)))
          ;; We hit a label followed by a statement. Indent to the statement.
          (throw 'done nil))

         ;; Skip over ()/[] groups.
         ((eq 'close-group kind) (setq token (opascal-group-start token)))

         ((opascal-is kind `(newline open-group ,@opascal-use-clauses))
          ;; Stop at the beginning of the line, an open group, or a use clause
          (throw 'done nil)))
        (unless (opascal-is kind opascal-whitespace) (setq last-token token))
        (setq token (opascal-previous-token token))))
    (opascal-indent-of last-token offset)))

(defun opascal-open-group-indent (token last-token &optional offset)
  ;; Returns the indent relative to an unmatched ( or [.
  (when (eq 'open-group (opascal-token-kind token))
    (if last-token
        (opascal-indent-of last-token offset)
      ;; There is nothing following the ( or [. Indent from its line.
      (opascal-stmt-line-indent-of token opascal-indent-level))))

(defun opascal-composite-type-start (token last-token)
  ;; Returns true (actually the last-token) if the pair equals (= class), (=
  ;; dispinterface), (= interface), (= object), or (= record), and nil
  ;; otherwise.
  (if (and (eq 'equals (opascal-token-kind token))
           (opascal-is (opascal-token-kind last-token) opascal-composite-types))
      last-token))

(defun opascal-is-simple-class-type (at-token limit-token)
  ;; True if at-token is the start of a simple class type. E.g.
  ;;   class of TClass;
  ;;   class (TBaseClass);
  ;;   class;
  (when (opascal-is (opascal-token-kind at-token) opascal-class-types)
    (catch 'done
      ;; Scan until the semi colon.
      (let ((token (opascal-next-token at-token))
            (token-kind nil)
            (limit (opascal-token-start limit-token)))
        (while (and token (<= (opascal-token-start token) limit))
          (setq token-kind (opascal-token-kind token))
          (cond
           ;; A semicolon delimits the search.
           ((eq 'semicolon token-kind) (throw 'done token))

           ;; Skip over the inheritance list.
           ((eq 'open-group token-kind) (setq token (opascal-group-end token)))

           ;; Only allow "of" and whitespace, and an identifier
           ((opascal-is token-kind `(of word ,@opascal-whitespace)))

           ;; Otherwise we are not in a simple class declaration.
           ((throw 'done nil)))
          (setq token (opascal-next-token token)))))))

(defun opascal-block-start (from-token &optional stop-on-class)
  ;; Returns the token that denotes the start of the block.
  (let ((token (opascal-previous-token from-token))
        (last-token nil)
        (token-kind nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; Skip over nested blocks.
         ((opascal-is token-kind opascal-end-block-statements)
          (setq token (opascal-block-start token)))

         ;; Regular block start found.
         ((opascal-is token-kind opascal-block-statements)
          (throw 'done
                 ;; As a special case, when a "case" block appears
                 ;; within a record declaration (to denote a variant
                 ;; part), the record declaration should be considered
                 ;; the enclosing block.
                 (if (eq 'case token-kind)
                     (let ((enclosing-token
                            (opascal-block-start token
                                                'stop-on-class)))
                       (if
                           (eq 'record
                               (opascal-token-kind enclosing-token))
                           (if stop-on-class
                               enclosing-token
                             (opascal-previous-token enclosing-token))
                         token))
                   token)))

         ;; A class/record start also begins a block.
         ((opascal-composite-type-start token last-token)
          (throw 'done (if stop-on-class last-token token)))
         )
        (unless (opascal-is token-kind opascal-whitespace)
          (setq last-token token))
        (setq token (opascal-previous-token token)))
      ;; Start not found.
      nil)))

(defun opascal-else-start (from-else)
  ;; Returns the token of the if or case statement.
  (let ((token (opascal-previous-token from-else))
        (token-kind nil)
        (semicolon-count 0))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; Skip over nested groups.
         ((eq 'close-group token-kind) (setq token (opascal-group-start token)))

         ;; Skip over any nested blocks.
         ((opascal-is token-kind opascal-end-block-statements)
          (setq token (opascal-block-start token)))

         ((eq 'semicolon token-kind)
          ;; Semicolon means we are looking for an enclosing if, unless we
          ;; are in a case statement. Keep counts of the semicolons and decide
          ;; later.
          (setq semicolon-count (1+ semicolon-count)))

         ((and (eq 'if token-kind) (= semicolon-count 0))
          ;; We only can match an if when there have been no intervening
          ;; semicolons.
          (throw 'done token))

         ((eq 'case token-kind)
          ;; We have hit a case statement start.
          (throw 'done token)))
        (setq token (opascal-previous-token token)))
      ;; No if or case statement found.
      nil)))

(defun opascal-comment-content-start (comment)
  ;; Returns the point of the first non-space character in the comment.
  (let ((kind (opascal-token-kind comment)))
    (when (opascal-is kind opascal-comments)
      (opascal-save-excursion
       (goto-char (+ (opascal-token-start comment)
                     (length (opascal-literal-start-pattern kind))))
       (skip-chars-forward opascal-space-chars)
       (point)))))

(defun opascal-comment-block-start (comment)
  ;; Returns the starting comment token of a contiguous // comment block. If
  ;; the comment is multiline (i.e. {...} or (*...*)), the original comment is
  ;; returned.
  (if (not (eq 'comment-single-line (opascal-token-kind comment)))
      comment
    ;; Scan until we run out of // comments.
    (let ((prev-comment comment)
          (start-comment comment))
      (while (let ((kind (opascal-token-kind prev-comment)))
               (cond ((eq kind 'space))
                     ((eq kind 'comment-single-line)
                      (setq start-comment prev-comment))
                     (t nil)))
        (setq prev-comment (opascal-previous-token prev-comment)))
      start-comment)))

(defun opascal-comment-block-end (comment)
  ;; Returns the end comment token of a contiguous // comment block. If the
  ;; comment is multiline (i.e. {...} or (*...*)), the original comment is
  ;; returned.
  (if (not (eq 'comment-single-line (opascal-token-kind comment)))
      comment
    ;; Scan until we run out of // comments.
    (let ((next-comment comment)
          (end-comment comment))
      (while (let ((kind (opascal-token-kind next-comment)))
               (cond ((eq kind 'space))
                     ((eq kind 'comment-single-line)
                      (setq end-comment next-comment))
                     (t nil)))
        (setq next-comment (opascal-next-token next-comment)))
      end-comment)))

(defun opascal-on-first-comment-line (comment)
  ;; Returns true if the current point is on the first line of the comment.
  (save-excursion
    (let ((comment-start (opascal-token-start comment))
          (current-point (point)))
      (goto-char comment-start)
      (end-of-line)
      (and (<= comment-start current-point) (<= current-point (point))))))

(defun opascal-comment-indent-of (comment)
  ;; Returns the correct indentation for the comment.
  (let ((start-comment (opascal-comment-block-start comment)))
    (if (and (eq start-comment comment)
             (opascal-on-first-comment-line comment))
        ;; Indent as a statement.
        (opascal-enclosing-indent-of comment)
      (save-excursion
        (let ((kind (opascal-token-kind comment)))
          (beginning-of-line)
          (cond ((eq 'comment-single-line kind)
                 ;; Indent to the first comment in the // block.
                 (opascal-indent-of start-comment))

                ((looking-at (concat opascal-leading-spaces-re
                                     (opascal-literal-stop-pattern kind)))
                 ;; Indent multi-line comment terminators to the comment start.
                 (opascal-indent-of comment))

                ;; Indent according to the comment's content start.
                ((opascal-column-of (opascal-comment-content-start comment)))))))
    ))

(defun opascal-is-use-clause-end (at-token last-token last-colon from-kind)
  ;; True if we are after the end of a uses type clause.
  (when (and last-token
             (not last-colon)
             (eq 'comma (opascal-token-kind at-token))
             (eq 'semicolon from-kind))
    ;; Scan for the uses statement, just to be sure.
    (let ((token (opascal-previous-token at-token))
          (token-kind nil))
      (catch 'done
        (while token
          (setq token-kind (opascal-token-kind token))
          (cond ((opascal-is token-kind opascal-use-clauses)
                 (throw 'done t))

                ;; Whitespace, identifiers, strings, "in" keyword, and commas
                ;; are allowed in use clauses.
                ((or (opascal-is token-kind '(word comma in newline))
                     (opascal-is token-kind opascal-whitespace)
                     (opascal-is token-kind opascal-strings)))

                ;; Nothing else is.
                ((throw 'done nil)))
          (setq token (opascal-previous-token token)))
        nil))))

(defun opascal-is-block-after-expr-statement (token)
  ;; Returns true if we have a block token trailing an expression delimiter (of
  ;; presumably an expression statement).
  (when (opascal-is (opascal-token-kind token) opascal-block-statements)
    (let ((previous (opascal-previous-token token))
          (previous-kind nil))
      (while (progn
               (setq previous-kind (opascal-token-kind previous))
               (eq previous-kind 'space))
        (setq previous (opascal-previous-token previous)))
      (or (opascal-is previous-kind opascal-expr-delimiters)
          (eq previous-kind 'else)))))

(defun opascal-previous-indent-of (from-token)
  ;; Returns the indentation of the previous statement of the token.
  (let ((token (opascal-previous-token from-token))
        (token-kind nil)
        (from-kind (opascal-token-kind from-token))
        (last-colon nil)
        (last-of nil)
        (last-token nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; An open ( or [ always is an indent point.
         ((eq 'open-group token-kind)
          (throw 'done (opascal-open-group-indent token last-token)))

         ;; Skip over any ()/[] groups.
         ((eq 'close-group token-kind) (setq token (opascal-group-start token)))

         ((opascal-is token-kind opascal-end-block-statements)
          (if (eq 'newline (opascal-token-kind (opascal-previous-token token)))
              ;; We can stop at an end token that is right up against the
              ;; margin.
              (throw 'done 0)
            ;; Otherwise, skip over any nested blocks.
            (setq token (opascal-block-start token))))

         ;; Special case: if we encounter a ", word;" then we assume that we
         ;; are in some kind of uses clause, and thus indent to column 0. This
         ;; works because no other constructs are known to have that form.
         ;; This fixes the irritating case of having indents after a uses
         ;; clause look like:
         ;;   uses
         ;;      someUnit,
         ;;      someOtherUnit;
         ;;      // this should be at column 0!
         ((opascal-is-use-clause-end token last-token last-colon from-kind)
          (throw 'done 0))

         ;; A previous terminator means we can stop. If we are on a directive,
         ;; however, then we are not actually encountering a new statement.
         ((and last-token
               (opascal-is token-kind opascal-previous-terminators)
               (not (opascal-is (opascal-token-kind last-token)
                               opascal-directives)))
          (throw 'done (opascal-stmt-line-indent-of last-token 0)))

         ;; Ignore whitespace.
         ((opascal-is token-kind opascal-whitespace))

         ;; Remember any "of" we encounter, since that affects how we
         ;; indent to a case statement within a record declaration
         ;; (i.e. a variant part).
         ((eq 'of token-kind)
          (setq last-of token))

         ;; Remember any ':' we encounter (until we reach an "of"),
         ;; since that affects how we indent to case statements in
         ;; general.
         ((eq 'colon token-kind)
          (unless last-of (setq last-colon token)))

         ;; A case statement delimits a previous statement. We indent labels
         ;; specially.
         ((eq 'case token-kind)
          (throw 'done
                (if last-colon (opascal-line-indent-of last-colon)
                  (opascal-line-indent-of token opascal-case-label-indent))))

         ;; If we are in a use clause then commas mark an enclosing rather than
         ;; a previous statement.
         ((opascal-is token-kind opascal-use-clauses)
          (throw 'done
                 (if (eq 'comma from-kind)
                     (if last-token
                         ;; Indent to first unit in use clause.
                         (opascal-indent-of last-token)
                       ;; Indent from use clause keyword.
                       (opascal-line-indent-of token opascal-indent-level))
                   ;; Indent to use clause keyword.
                   (opascal-line-indent-of token))))

         ;; Assembly sections always indent in from the asm keyword.
         ((eq token-kind 'asm)
          (throw 'done (opascal-stmt-line-indent-of token opascal-indent-level)))

         ;; An enclosing statement delimits a previous statement.
         ;; We try to use the existing indent of the previous statement,
         ;; otherwise we calculate from the enclosing statement.
         ((opascal-is token-kind opascal-previous-enclosing-statements)
          (throw 'done (if last-token
                           ;; Otherwise indent to the last token
                           (opascal-line-indent-of last-token)
                         ;; Just indent from the enclosing keyword
                         (opascal-line-indent-of token opascal-indent-level))))

         ;; A class or record declaration also delimits a previous statement.
         ((opascal-composite-type-start token last-token)
          (throw
           'done
           (if (opascal-is-simple-class-type last-token from-token)
               ;; c = class; or c = class of T; are previous statements.
               (opascal-line-indent-of token)
             ;; Otherwise c = class ... or r = record ... are enclosing
             ;; statements.
             (opascal-line-indent-of last-token opascal-indent-level))))

         ;; We have a definite previous statement delimiter.
         ((opascal-is token-kind opascal-previous-statements)
          (throw 'done (opascal-stmt-line-indent-of token 0)))
         )
        (unless (opascal-is token-kind opascal-whitespace)
           (setq last-token token))
        (setq token (opascal-previous-token token)))
      ;; We ran out of tokens. Indent to column 0.
      0)))

(defun opascal-section-indent-of (section-token)
  ;; Returns the indentation appropriate for begin/var/const/type/label
  ;; tokens.
  (let* ((token (opascal-previous-token section-token))
         (token-kind nil)
         (last-token nil)
         (nested-block-count 0)
         (expr-delimited nil)
         (last-terminator nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; Always stop at unmatched ( or [.
         ((eq token-kind 'open-group)
          (throw 'done (opascal-open-group-indent token last-token)))

         ;; Skip over any ()/[] groups.
         ((eq 'close-group token-kind) (setq token (opascal-group-start token)))

         ((opascal-is token-kind opascal-end-block-statements)
          (if (eq 'newline (opascal-token-kind (opascal-previous-token token)))
              ;; We can stop at an end token that is right up against the
              ;; margin.
              (throw 'done 0)
            ;; Otherwise, skip over any nested blocks.
            (setq token (opascal-block-start token)
                  nested-block-count (1+ nested-block-count))))

         ;; Remember if we have encountered any forward routine declarations.
         ((eq 'forward token-kind)
          (setq nested-block-count (1+ nested-block-count)))

         ;; Mark the completion of a nested routine traversal.
         ((and (opascal-is token-kind opascal-routine-statements)
               (> nested-block-count 0))
          (setq nested-block-count (1- nested-block-count)))

         ;; Remember if we have encountered any statement terminators.
         ((eq 'semicolon token-kind) (setq last-terminator token))

         ;; Remember if we have encountered any expression delimiters.
         ((opascal-is token-kind opascal-expr-delimiters)
          (setq expr-delimited token))

         ;; Enclosing body statements are delimiting. We indent the compound
         ;; bodies specially.
         ((and (not last-terminator)
               (opascal-is token-kind opascal-body-statements))
          (throw 'done
           (opascal-stmt-line-indent-of token opascal-compound-block-indent)))

         ;; An enclosing ":" means a label.
         ((and (eq 'colon token-kind)
               (opascal-is (opascal-token-kind section-token)
                          opascal-block-statements)
               (not last-terminator)
               (not expr-delimited)
               (not (eq 'equals (opascal-token-kind last-token))))
          (throw 'done
                 (opascal-stmt-line-indent-of token opascal-indent-level)))

         ;; Block and mid block tokens are always enclosing
         ((opascal-is token-kind opascal-begin-enclosing-tokens)
          (throw 'done
                 (opascal-stmt-line-indent-of token opascal-indent-level)))

         ;; Declaration sections and routines are delimiters, unless they
         ;; are part of a nested routine.
         ((and (opascal-is token-kind opascal-decl-delimiters)
               (= 0 nested-block-count))
          (throw 'done (opascal-line-indent-of token 0)))

         ;; Unit statements mean we indent right to the left.
         ((opascal-is token-kind opascal-unit-statements) (throw 'done 0))
         )
        (unless (opascal-is token-kind opascal-whitespace)
           (setq last-token token))
        (setq token (opascal-previous-token token)))
      ;; We ran out of tokens. Indent to column 0.
      0)))

(defun opascal-enclosing-indent-of (from-token)
  ;; Returns the indentation offset from the enclosing statement of the token.
  (let ((token (opascal-previous-token from-token))
        (from-kind (opascal-token-kind from-token))
        (token-kind nil)
        (stmt-start nil)
        (last-token nil)
        (equals-encountered nil)
        (before-equals nil)
        (expr-delimited nil))
    (catch 'done
      (while token
        (setq token-kind (opascal-token-kind token))
        (cond
         ;; An open ( or [ always is an indent point.
         ((eq 'open-group token-kind)
          (throw 'done
                 (opascal-open-group-indent
                  token last-token
                  (if (opascal-is from-kind opascal-binary-ops)
                      ;; Keep binary operations aligned with the open group.
                      0
                    opascal-indent-level))))

         ;; Skip over any ()/[] groups.
         ((eq 'close-group token-kind) (setq token (opascal-group-start token)))

         ;; Skip over any nested blocks.
         ((opascal-is token-kind opascal-end-block-statements)
          (setq token (opascal-block-start token)))

         ;; An expression delimiter affects indentation depending on whether
         ;; the point is before or after it. Remember that we encountered one.
         ;; Also remember the last encountered token, since if it exists it
         ;; should be the actual indent point.
         ((opascal-is token-kind opascal-expr-delimiters)
          (setq expr-delimited token stmt-start last-token))

         ;; With a non-delimited expression statement we indent after the
         ;; statement's keyword, unless we are on the delimiter itself.
         ((and (not expr-delimited)
               (opascal-is token-kind opascal-expr-statements))
          (throw 'done
             (cond ((opascal-is from-kind opascal-expr-delimiters)
                    ;; We are indenting a delimiter. Indent to the statement.
                    (opascal-stmt-line-indent-of token 0))

                   ((and last-token (opascal-is from-kind opascal-binary-ops))
                    ;; Align binary ops with the expression.
                    (opascal-indent-of last-token))

                   (last-token
                    ;; Indent in from the expression.
                    (opascal-indent-of last-token opascal-indent-level))

           ;; Indent in from the statement's keyword.
           ((opascal-indent-of token opascal-indent-level)))))

         ;; A delimited case statement indents the label according to
         ;; a special rule.
         ((eq 'case token-kind)
          (throw 'done
                 (if stmt-start
                     ;; We are not actually indenting to the case statement,
                     ;; but are within a label expression.
                     (opascal-stmt-line-indent-of
                      stmt-start opascal-indent-level)
                   ;; Indent from the case keyword.
                   (opascal-stmt-line-indent-of
                    token opascal-case-label-indent))))

         ;; Body expression statements are enclosing. Indent from the
         ;; statement's keyword, unless we have a non-block statement following
         ;; it.
         ((opascal-is token-kind opascal-body-expr-statements)
          (throw 'done
                 (opascal-stmt-line-indent-of
                  (or stmt-start token) opascal-indent-level)))

         ;; An else statement is enclosing, but it doesn't have an expression.
         ;; Thus we take into account last-token instead of stmt-start.
         ((eq 'else token-kind)
          (throw 'done (opascal-stmt-line-indent-of
                        (or last-token token) opascal-indent-level)))

         ;; We indent relative to an enclosing declaration section.
         ((opascal-is token-kind opascal-decl-sections)
          (throw 'done (opascal-indent-of (if last-token last-token token)
                                         opascal-indent-level)))

         ;; In unit sections we indent right to the left.
         ((opascal-is token-kind opascal-unit-sections)
          (throw 'done
                 ;; Handle specially the case of "interface", which can be used
                 ;; to start either a unit section or an interface definition.
                 (if (opascal-is token-kind opascal-interface-types)
                     (progn
                       ;; Find the previous non-whitespace token.
                       (while (progn
                                (setq last-token token
                                      token (opascal-previous-token token)
                                      token-kind (opascal-token-kind token))
                                (and token
                                     (opascal-is token-kind
                                                opascal-whitespace))))
                       ;; If this token is an equals sign, "interface" is being
                       ;; used to start an interface definition and we should
                       ;; treat it as a composite type; otherwise, we should
                       ;; consider it the start of a unit section.
                       (if (and token (eq token-kind 'equals))
                           (opascal-line-indent-of last-token
                                                  opascal-indent-level)
                         0))
                   0)))

         ;; A previous terminator means we can stop.
         ((opascal-is token-kind opascal-previous-terminators)
          (throw 'done
              (cond ((and last-token
                          (eq 'comma token-kind)
                          (opascal-is from-kind opascal-binary-ops))
                     ;; Align binary ops with the expression.
                     (opascal-indent-of last-token))

                    (last-token
                     ;; Indent in from the expression.
                     (opascal-indent-of last-token opascal-indent-level))

                    ;; No enclosing expression; use the previous statement's
                    ;; indent.
                    ((opascal-previous-indent-of token)))))

         ;; A block statement after an expression delimiter has its start
         ;; column as the expression statement. E.g.
         ;;    if (a = b)
         ;;       and (a != c) then begin
         ;;       //...
         ;;    end;
         ;; Remember it for when we encounter the expression statement start.
         ((opascal-is-block-after-expr-statement token)
          (throw 'done
           (cond (last-token (opascal-indent-of last-token opascal-indent-level))

                 ((+ (opascal-section-indent-of token) opascal-indent-level)))))

         ;; Assembly sections always indent in from the asm keyword.
         ((eq token-kind 'asm)
          (throw 'done (opascal-stmt-line-indent-of token opascal-indent-level)))

         ;; Stop at an enclosing statement and indent from it.
         ((opascal-is token-kind opascal-enclosing-statements)
          (throw 'done (opascal-stmt-line-indent-of
                        (or last-token token) opascal-indent-level)))

         ;; A class/record declaration is also enclosing.
         ((opascal-composite-type-start token last-token)
          (throw 'done
                 (opascal-line-indent-of last-token opascal-indent-level)))

         ;; A ":" we indent relative to its line beginning.  If we are in a
         ;; parameter list, then stop also if we hit a ";".
         ((and (eq token-kind 'colon)
               (not expr-delimited)
               (not (opascal-is from-kind opascal-expr-delimiters))
               (not equals-encountered)
               (not (eq from-kind 'equals)))
          (throw 'done
           (if last-token
               (opascal-indent-of last-token opascal-indent-level)
             (opascal-line-indent-of token opascal-indent-level 'semicolon))))

         ;; If the ":" was not processed above and we have token after the "=",
         ;; then indent from the "=". Ignore :=, however.
         ((and (eq token-kind 'colon) equals-encountered before-equals)
          (cond
           ;; Ignore binary ops for now. It would do, for example:
           ;;   val := 1 + 2
           ;;          + 3;
           ;; which is good, but also
           ;;   val := Foo
           ;;      (foo, args)
           ;;          + 2;
           ;; which doesn't look right.
           ;;;; Align binary ops with the before token.
           ;;((opascal-is from-kind opascal-binary-ops)
           ;;(throw 'done (opascal-indent-of before-equals 0)))

           ;; Assignments (:=) we skip over to get a normal indent.
           ((eq (opascal-token-kind last-token) 'equals))

           ;; Otherwise indent in from the equals.
           ((throw 'done
                   (opascal-indent-of before-equals opascal-indent-level)))))

         ;; Remember any "=" we encounter if it has not already been processed.
         ((eq token-kind 'equals)
          (setq equals-encountered token
                before-equals last-token))
         )
        (unless (opascal-is token-kind opascal-whitespace)
           (setq last-token token))
        (setq token (opascal-previous-token token)))
      ;; We ran out of tokens. Indent to column 0.
      0)))

(defun opascal-corrected-indentation ()
  ;; Returns the corrected indentation for the current line.
  (opascal-save-excursion
    (opascal-progress-start)
    ;; Move to the first token on the line.
    (beginning-of-line)
    (skip-chars-forward opascal-space-chars)
    (let* ((token (opascal-current-token))
           (token-kind (opascal-token-kind token))
           (indent
            (cond ((eq 'close-group token-kind)
                   ;; Indent to the matching start ( or [.
                   (opascal-indent-of (opascal-group-start token)))

                  ((opascal-is token-kind opascal-unit-statements) 0)

                  ((opascal-is token-kind opascal-comments)
                   ;; In a comment.
                   (opascal-comment-indent-of token))

                  ((opascal-is token-kind opascal-decl-matchers)
                   ;; Use a previous section/routine's indent.
                   (opascal-section-indent-of token))

                  ((opascal-is token-kind opascal-match-block-statements)
                   ;; Use the block's indentation.
                   (let ((block-start
                          (opascal-block-start token 'stop-on-class)))
                     (cond
                      ;; When trailing a body statement, indent to
                      ;; the statement's keyword.
                      ((opascal-is-block-after-expr-statement block-start)
                       (opascal-section-indent-of block-start))

                      ;; Otherwise just indent to the block start.
                      ((opascal-stmt-line-indent-of block-start 0)))))

                  ((eq 'else token-kind)
                   ;; Find the start of the if or case statement.
                   (opascal-stmt-line-indent-of (opascal-else-start token) 0))

                  ;; Otherwise indent in from enclosing statement.
                  ((opascal-enclosing-indent-of
                    (if token token (opascal-token-at (1- (point)))))))))
      (opascal-progress-done)
      indent)))

(defun opascal-indent-line ()
  "Indent the current line according to the current language construct.
If before the indent, the point is moved to the indent."
  (interactive)
  (save-match-data
   (let ((marked-point (point-marker))  ; Maintain our position reliably.
         (line-start nil)
         (old-indent 0)
         (new-indent 0))
     (beginning-of-line)
     (setq line-start (point))
     (skip-chars-forward opascal-space-chars)
     (setq old-indent (current-column))
     (setq new-indent (opascal-corrected-indentation))
     (if (< marked-point (point))
         ;; If before the indent column, then move to it.
         (set-marker marked-point (point)))
     ;; Advance our marked point after inserted spaces.
     (set-marker-insertion-type marked-point t)
     (when (/= old-indent new-indent)
           (delete-region line-start (point))
           (insert (make-string new-indent ?\s)))
     (goto-char marked-point)
     (set-marker marked-point nil))))

(defvar opascal-mode-abbrev-table nil
  "Abbrev table in use in OPascal mode buffers.")
(define-abbrev-table 'opascal-mode-abbrev-table ())

(defmacro opascal-ensure-buffer (buffer-var buffer-name)
  ;; Ensures there exists a buffer of the specified name in the specified
  ;; variable.
  `(when (not (buffer-live-p ,buffer-var))
     (setq ,buffer-var (get-buffer-create ,buffer-name))))

(defun opascal-log-msg (to-buffer the-msg)
  ;; Writes a message to the end of the specified buffer.
  (with-current-buffer to-buffer
    (save-selected-window
      (switch-to-buffer-other-window to-buffer)
      (goto-char (point-max))
      (set-window-point (get-buffer-window to-buffer) (point))
      (insert the-msg))))

;; Debugging helpers:

(defvar opascal-debug-buffer nil
  "Buffer to write OPascal mode debug messages to.  Created on demand.")

(defun opascal-debug-log (format-string &rest args)
  ;; Writes a message to the log buffer.
  (when opascal-debug
    (opascal-ensure-buffer opascal-debug-buffer "*OPascal Debug Log*")
    (opascal-log-msg opascal-debug-buffer
                    (concat (format-time-string "%H:%M:%S " (current-time))
                            (apply #'format (cons format-string args))
                            "\n"))))

(defun opascal-debug-token-string (token)
  (let* ((image (opascal-token-string token))
         (has-newline (string-match "^\\([^\n]*\\)\n\\(.+\\)?$" image)))
    (when has-newline
       (setq image (concat (match-string 1 image)
                           (if (match-beginning 2) "..."))))
    image))

(defun opascal-debug-show-current-token ()
  (interactive)
  (let ((token (opascal-current-token)))
    (opascal-debug-log "Token: %S %S" token (opascal-debug-token-string token))))

(defun opascal-debug-goto-point (p)
  (interactive "NGoto char: ")
  (goto-char p))

(defun opascal-debug-goto-next-token ()
  (interactive)
  (goto-char (opascal-token-start (opascal-next-token (opascal-current-token)))))

(defun opascal-debug-goto-previous-token ()
  (interactive)
  (goto-char
   (opascal-token-start (opascal-previous-token (opascal-current-token)))))

(defun opascal-debug-show-current-string (from to)
  (interactive "r")
  (opascal-debug-log "String: %S" (buffer-substring from to)))

(defun opascal-debug-tokenize-region (from to)
  (interactive)
  (opascal-save-excursion
   (opascal-progress-start)
   (goto-char from)
   (while (< (point) to)
     (goto-char (opascal-token-end (opascal-current-token)))
     (opascal-step-progress (point) "Tokenizing" opascal-scanning-progress-step))
   (opascal-progress-done "Tokenizing done")))

(defun opascal-debug-tokenize-buffer ()
  (interactive)
  (opascal-debug-tokenize-region (point-min) (point-max)))

(defun opascal-debug-tokenize-window ()
  (interactive)
  (opascal-debug-tokenize-region (window-start) (window-end)))


(defun opascal-tab ()
  "Indent the region, if Transient Mark mode is on and the region is active.
Otherwise, indent the current line or insert a TAB, depending on the
value of `opascal-tab-always-indents' and the current line position."
  (interactive)
  (cond ((use-region-p)
         ;; If Transient Mark mode is enabled and the region is active, indent
         ;; the entire region.
         (indent-region (region-beginning) (region-end)))
        ((or opascal-tab-always-indents
             (save-excursion (skip-chars-backward opascal-space-chars) (bolp)))
         ;; Otherwise, if we are configured always to indent (regardless of the
         ;; point's position in the line) or we are before the first non-space
         ;; character on the line, indent the line.
         (opascal-indent-line))
        (t
         ;; Otherwise, insert a tab character.
         (insert "\t"))))

(make-obsolete 'opascal-tab 'indent-for-tab-command "24.4")

(defun opascal-is-directory (path)
  ;; True if the specified path is an existing directory.
  (let ((attributes (file-attributes path)))
    (and attributes (car attributes))))

(defun opascal-is-file (path)
  ;; True if the specified file exists as a file.
  (let ((attributes (file-attributes path)))
    (and attributes (null (car attributes)))))

(defun opascal-search-directory (unit dir &optional recurse)
  ;; Searches for the unit in the specified directory. If recurse is true, then
  ;; the directory is recursively searched. File name comparison is done in a
  ;; case insensitive manner.
  (when (opascal-is-directory dir)
    (let ((files (directory-files dir))
          (unit-file (downcase unit)))
      (catch 'done
        ;; Search for the file.
        (dolist (file files)
          (let ((path (concat dir "/" file)))
            (if (and (string= unit-file (downcase file))
                     (opascal-is-file path))
                (throw 'done path))))

        ;; Not found. Search subdirectories.
        (when recurse
          (dolist (subdir files)
            (unless (member subdir '("." ".."))
              (let ((path (opascal-search-directory
                           unit (concat dir "/" subdir) recurse)))
                (if path (throw 'done path))))))

        ;; Not found.
        nil))))


(defun opascal-find-unit-in-directory (unit dir)
  ;; Searches for the unit in the specified directory. If the directory ends
  ;; in \"...\", then it is recursively searched.
  (let ((dir-name dir)
        (recurse nil))
    ;; Check if we need to recursively search the directory.
    (if (string-match "^\\(.+\\)\\.\\.\\.$" dir-name)
        (setq dir-name (match-string 1 dir-name)
              recurse t))
    ;; Ensure the trailing slash is removed.
    (if (string-match "^\\(.+\\)[\\\\/]$" dir-name)
        (setq dir-name (match-string 1 dir-name)))
    (opascal-search-directory unit dir-name recurse)))

(defun opascal-find-unit-file (unit)
  ;; Finds the specified opascal source file according to `opascal-search-path'.
  ;; If found, the full path is returned, otherwise nil is returned.
  (catch 'done
    (cond ((null opascal-search-path)
           (opascal-find-unit-in-directory unit "."))

          ((stringp opascal-search-path)
           (opascal-find-unit-in-directory unit opascal-search-path))

          ((dolist (dir opascal-search-path)
             (let ((file (opascal-find-unit-in-directory unit dir)))
               (if file (throw 'done file))))))
    nil))

(defun opascal-find-unit (unit)
  "Find the specified OPascal source file according to `opascal-search-path'.
If no extension is specified, .pas is assumed.  Creates a buffer for the unit."
  (interactive "sOPascal unit name: ")
  (let* ((unit-file (if (string-match "^\\(.*\\)\\.[a-z]+$" unit)
                        unit
                      (concat unit ".pas")))
         (file (opascal-find-unit-file unit-file)))
    (if (null file)
        (error "unit not found: %s" unit-file)
      (find-file file)
      (if (not (derived-mode-p 'opascal-mode))
          (opascal-mode)))
    file))

(defun opascal-find-current-def ()
  "Find the definition of the identifier under the current point."
  (interactive)
  (error "opascal-find-current-def: not implemented yet"))

(defun opascal-find-current-xdef ()
  "Find the definition of the identifier under the current point, searching
in external units if necessary (as listed in the current unit's use clause).
The set of directories to search for a unit is specified by the global variable
`opascal-search-path'."
  (interactive)
  (error "opascal-find-current-xdef: not implemented yet"))

(defun opascal-find-current-body ()
  "Find the body of the identifier under the current point, assuming
it is a routine."
  (interactive)
  (error "opascal-find-current-body: not implemented yet"))

(defun opascal-fill-comment ()
  "Fill the text of the current comment, according to `fill-column'.
An error is raised if not in a comment."
  (interactive)
  (save-excursion
    (save-restriction
    (let* ((comment (opascal-current-token))
           (comment-kind (opascal-token-kind comment)))
      (if (not (opascal-is comment-kind opascal-comments))
          (error "Not in a comment")
        (let* ((start-comment (opascal-comment-block-start comment))
               (end-comment (opascal-comment-block-end comment))
               ;; FIXME: Don't abuse global variables like `comment-end/start'.
               (comment-start (opascal-token-start start-comment))
               (comment-end (opascal-token-end end-comment))
               (content-start (opascal-comment-content-start start-comment))
               (content-indent (opascal-column-of content-start))
               (content-prefix (make-string content-indent ?\s))
               (content-prefix-re opascal-leading-spaces-re)
               (p nil)
               (marked-point (point-marker))) ; Maintain our position reliably.
          (when (eq 'comment-single-line comment-kind)
            ;; // style comments need more work.
            (setq content-prefix
                  (let ((comment-indent (opascal-column-of comment-start)))
                    (concat (make-string comment-indent ?\s) "//"
                            (make-string (- content-indent comment-indent 2)
                                         ?\s)))
                  content-prefix-re (concat opascal-leading-spaces-re
                                            "//"
                                            opascal-spaces-re)
                  comment-end (if (opascal-is-literal-end comment-end)
                                  ;; Don't include the trailing newline.
                                  (1- comment-end)
                                comment-end)))

          ;; Advance our marked point after inserted spaces.
          (set-marker-insertion-type marked-point t)

          ;; Ensure we can modify the buffer
          (goto-char content-start)
          (insert " ")
          (delete-char -1)

          (narrow-to-region content-start comment-end)

          ;; Strip off the comment prefixes
          (setq p (point-min))
          (while (when (< p (point-max))
                   (goto-char p)
                   (re-search-forward content-prefix-re nil t))
            (replace-match "" nil nil)
            (setq p (1+ (point))))

          ;; add an extra line to prevent the fill from doing it for us.
          (goto-char (point-max))
          (insert "\n")

          ;; Fill the comment contents.
          (let ((fill-column (- fill-column content-indent)))
            (fill-region (point-min) (point-max)))

          (goto-char (point-max))
          (delete-char -1)

          ;; Restore comment prefixes.
          (goto-char (point-min))
          (end-of-line)                 ; Don't reset the first line.
          (setq p (point))
          (while (when (< p (point-max))
                   (goto-char p)
                   (re-search-forward "^" nil t))
            (replace-match content-prefix nil nil)
            (setq p (1+ (point))))

          (setq comment-end (point-max))
          (widen)

          ;; Restore our position
          (goto-char marked-point)
          (set-marker marked-point nil)))))))

(defun opascal-new-comment-line ()
  "If in a // comment, do a newline, indented such that one is still in the
comment block.  If not in a // comment, just does a normal newline."
  (interactive)
  (let ((comment (opascal-current-token)))
    (if (not (eq 'comment-single-line (opascal-token-kind comment)))
        ;; Not in a // comment. Just do the normal newline.
        (newline)
      (let* ((start-comment (opascal-comment-block-start comment))
             (comment-start (opascal-token-start start-comment))
             (content-start (opascal-comment-content-start start-comment))
             (prefix
              (concat (make-string (opascal-column-of comment-start) ?\s) "//"
                      (make-string (- content-start comment-start 2) ?\s))))
        (delete-horizontal-space)
        (insert "\n" prefix)))))

(defun opascal-match-token (token limit)
  ;; Sets the match region used by (match-string 0) and friends to the token's
  ;; region.  Sets the current point to the end of the token (or limit).
  (set-match-data nil)
  (if token
      (let ((end (min (opascal-token-end token) limit)))
        (set-match-data (list (opascal-token-start token) end))
        (goto-char end)
        token)))

(defconst opascal-font-lock-keywords
  `(("\\_<\\(function\\|pro\\(cedure\\|gram\\)\\)[ \t]+\\([[:alpha:]][[:alnum:]_]*\\)"
     (1 font-lock-keyword-face) (3 font-lock-function-name-face))
    ,(concat "\\_<" (regexp-opt (mapcar #'symbol-name opascal-keywords))
              "\\_>")))

(defconst opascal-font-lock-defaults
  '(opascal-font-lock-keywords
    nil ; Syntactic fontification does apply.
    nil ; Don't care about case since we don't use regexps to find tokens.
    nil ; Syntax alists don't apply.
    nil ; Syntax begin movement doesn't apply.
    )
  "OPascal mode font-lock defaults.  Syntactic fontification is ignored.")

(defconst opascal--syntax-propertize
  (syntax-propertize-rules
   ;; The syntax-table settings are too coarse and end up treating /* and (/
   ;; as comment starters.  Fix it here by removing the "2" from the syntax
   ;; of the second char of such sequences.
   ("/\\(\\*\\)" (1 ". 3b"))
   ("(\\(\\/\\)" (1 (prog1 ". 1c" (forward-char -1) nil)))
   ;; Pascal uses '' and "" rather than \' and \" to escape quotes.
   ("''\\|\"\"" (0 (if (save-excursion
                         (nth 3 (syntax-ppss (match-beginning 0))))
                       (string-to-syntax ".")
                     ;; In case of 3 or more quotes in a row, only advance
                     ;; one quote at a time.
                     (forward-char -1)
                     nil)))))

(defvar opascal-debug-mode-map
  (let ((kmap (make-sparse-keymap)))
    (dolist (binding '(("n" opascal-debug-goto-next-token)
                       ("p" opascal-debug-goto-previous-token)
                       ("t" opascal-debug-show-current-token)
                       ("T" opascal-debug-tokenize-buffer)
                       ("W" opascal-debug-tokenize-window)
                       ("g" opascal-debug-goto-point)
                       ("s" opascal-debug-show-current-string)))
      (define-key kmap (car binding) (cadr binding)))
    kmap)
  "Keystrokes for OPascal mode debug commands.")

(defvar opascal-mode-map
  (let ((kmap (make-sparse-keymap)))
    (dolist (binding
             (list ;; '("\C-cd" opascal-find-current-def)
                   ;; '("\C-cx" opascal-find-current-xdef)
                   ;; '("\C-cb" opascal-find-current-body)
                   '("\C-cu" opascal-find-unit)
                   '("\M-q" opascal-fill-comment)
                   '("\M-j" opascal-new-comment-line)
                   ;; Debug bindings:
                   (list "\C-c\C-d" opascal-debug-mode-map)))
      (define-key kmap (car binding) (cadr binding)))
    kmap)
  "Keymap used in OPascal mode.")

(define-obsolete-variable-alias 'delphi-mode-hook 'opascal-mode-hook "24.4")
;;;###autoload
(define-obsolete-function-alias 'delphi-mode 'opascal-mode "24.4")
;;;###autoload
(define-derived-mode opascal-mode prog-mode "OPascal"
  "Major mode for editing OPascal code.\\<opascal-mode-map>
\\[opascal-find-unit]\t- Search for a OPascal source file.
\\[opascal-fill-comment]\t- Fill the current comment.
\\[opascal-new-comment-line]\t- If in a // comment, do a new comment line.

\\[indent-region] also works for indenting a whole region.

Customization:

 `opascal-indent-level'                (default 3)
    Indentation of OPascal statements with respect to containing block.
 `opascal-compound-block-indent'       (default 0)
    Extra indentation for blocks in compound statements.
 `opascal-case-label-indent'           (default 0)
    Extra indentation for case statement labels.
 `opascal-search-path'                 (default .)
    Directories to search when finding external units.
 `opascal-verbose'                     (default nil)
    If true then OPascal token processing progress is reported to the user.

Coloring:

 `opascal-keyword-face'                (default `font-lock-keyword-face')
    Face used to color OPascal keywords."

  ;; Buffer locals:
  (setq-local indent-line-function #'opascal-indent-line)
  (setq-local comment-indent-function #'opascal-indent-line)
  (setq-local case-fold-search t)
  (setq-local opascal-progress-last-reported-point nil)
  (setq-local font-lock-defaults opascal-font-lock-defaults)
  (setq-local tab-always-indent opascal-tab-always-indents)
  (setq-local syntax-propertize-function opascal--syntax-propertize)

  (setq-local comment-start "// ")
  (setq-local comment-start-skip "\\(?://\\|(\\*\\|{\\)[ \t]*")
  (setq-local comment-end-skip "[ \t]*\\(?:\n\\|\\*)\\|}\\)"))

(provide 'opascal)
;;; opascal.el ends here
