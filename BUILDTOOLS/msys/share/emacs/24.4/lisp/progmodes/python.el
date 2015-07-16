;;; python.el --- Python's flying circus support for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2003-2014 Free Software Foundation, Inc.

;; Author: Fabián E. Gallina <fabian@anue.biz>
;; URL: https://github.com/fgallina/python.el
;; Version: 0.24.4
;; Maintainer: emacs-devel@gnu.org
;; Created: Jul 2010
;; Keywords: languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Major mode for editing Python files with some fontification and
;; indentation bits extracted from original Dave Love's python.el
;; found in GNU/Emacs.

;; Implements Syntax highlighting, Indentation, Movement, Shell
;; interaction, Shell completion, Shell virtualenv support, Pdb
;; tracking, Symbol completion, Skeletons, FFAP, Code Check, Eldoc,
;; Imenu.

;; Syntax highlighting: Fontification of code is provided and supports
;; python's triple quoted strings properly.

;; Indentation: Automatic indentation with indentation cycling is
;; provided, it allows you to navigate different available levels of
;; indentation by hitting <tab> several times.  Also electric-indent-mode
;; is supported such that when inserting a colon the current line is
;; dedented automatically if needed.

;; Movement: `beginning-of-defun' and `end-of-defun' functions are
;; properly implemented.  There are also specialized
;; `forward-sentence' and `backward-sentence' replacements called
;; `python-nav-forward-block', `python-nav-backward-block'
;; respectively which navigate between beginning of blocks of code.
;; Extra functions `python-nav-forward-statement',
;; `python-nav-backward-statement',
;; `python-nav-beginning-of-statement', `python-nav-end-of-statement',
;; `python-nav-beginning-of-block', `python-nav-end-of-block' and
;; `python-nav-if-name-main' are included but no bound to any key.  At
;; last but not least the specialized `python-nav-forward-sexp' allows
;; easy navigation between code blocks.  If you prefer `cc-mode'-like
;; `forward-sexp' movement, setting `forward-sexp-function' to nil is
;; enough, You can do that using the `python-mode-hook':

;; (add-hook 'python-mode-hook
;;           (lambda () (setq forward-sexp-function nil)))

;; Shell interaction: is provided and allows opening Python shells
;; inside Emacs and executing any block of code of your current buffer
;; in that inferior Python process.

;; Besides that only the standard CPython (2.x and 3.x) shell and
;; IPython are officially supported out of the box, the interaction
;; should support any other readline based Python shells as well
;; (e.g. Jython and Pypy have been reported to work).  You can change
;; your default interpreter and commandline arguments by setting the
;; `python-shell-interpreter' and `python-shell-interpreter-args'
;; variables.  This example enables IPython globally:

;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i")

;; Using the "console" subcommand to start IPython in server-client
;; mode is known to fail intermittently due a bug on IPython itself
;; (see URL `http://debbugs.gnu.org/cgi/bugreport.cgi?bug=18052#27').
;; There seems to be a race condition in the IPython server (A.K.A
;; kernel) when code is sent while it is still initializing, sometimes
;; causing the shell to get stalled.  With that said, if an IPython
;; kernel is already running, "console --existing" seems to work fine.

;; Running IPython on Windows needs more tweaking.  The way you should
;; set `python-shell-interpreter' and `python-shell-interpreter-args'
;; is as follows (of course you need to modify the paths according to
;; your system):

;; (setq python-shell-interpreter "C:\\Python27\\python.exe"
;;       python-shell-interpreter-args
;;       "-i C:\\Python27\\Scripts\\ipython-script.py")

;; If you are experiencing missing or delayed output in your shells,
;; that's likely caused by your Operating System's pipe buffering
;; (e.g. this is known to happen running CPython 3.3.4 in Windows 7.
;; See URL `http://debbugs.gnu.org/cgi/bugreport.cgi?bug=17304').  To
;; fix this, using CPython's "-u" commandline argument or setting the
;; "PYTHONUNBUFFERED" environment variable should help: See URL
;; `https://docs.python.org/3/using/cmdline.html#cmdoption-u'.

;; The interaction relies upon having prompts for input (e.g. ">>> "
;; and "... " in standard Python shell) and output (e.g. "Out[1]: " in
;; IPython) detected properly.  Failing that Emacs may hang but, in
;; the case that happens, you can recover with \\[keyboard-quit].  To
;; avoid this issue, a two-step prompt autodetection mechanism is
;; provided: the first step is manual and consists of a collection of
;; regular expressions matching common prompts for Python shells
;; stored in `python-shell-prompt-input-regexps' and
;; `python-shell-prompt-output-regexps', and dir-local friendly vars
;; `python-shell-prompt-regexp', `python-shell-prompt-block-regexp',
;; `python-shell-prompt-output-regexp' which are appended to the
;; former automatically when a shell spawns; the second step is
;; automatic and depends on the `python-shell-prompt-detect' helper
;; function.  See its docstring for details on global variables that
;; modify its behavior.

;; Shell completion: hitting tab will try to complete the current
;; word.  Shell completion is implemented in such way that if you
;; change the `python-shell-interpreter' it should be possible to
;; integrate custom logic to calculate completions.  To achieve this
;; you just need to set `python-shell-completion-setup-code' and
;; `python-shell-completion-string-code'.  The default provided code,
;; enables autocompletion for both CPython and IPython (and ideally
;; any readline based Python shell).  This code depends on the
;; readline module, so if you are using some Operating System that
;; bundles Python without it (like Windows), installing pyreadline
;; from URL `http://ipython.scipy.org/moin/PyReadline/Intro' should
;; suffice.  To troubleshoot why you are not getting any completions
;; you can try the following in your Python shell:

;; >>> import readline, rlcompleter

;; If you see an error, then you need to either install pyreadline or
;; setup custom code that avoids that dependency.

;; Shell virtualenv support: The shell also contains support for
;; virtualenvs and other special environment modifications thanks to
;; `python-shell-process-environment' and `python-shell-exec-path'.
;; These two variables allows you to modify execution paths and
;; environment variables to make easy for you to setup virtualenv rules
;; or behavior modifications when running shells.  Here is an example
;; of how to make shell processes to be run using the /path/to/env/
;; virtualenv:

;; (setq python-shell-process-environment
;;       (list
;;        (format "PATH=%s" (mapconcat
;;                           'identity
;;                           (reverse
;;                            (cons (getenv "PATH")
;;                                  '("/path/to/env/bin/")))
;;                           ":"))
;;        "VIRTUAL_ENV=/path/to/env/"))
;; (python-shell-exec-path . ("/path/to/env/bin/"))

;; Since the above is cumbersome and can be programmatically
;; calculated, the variable `python-shell-virtualenv-path' is
;; provided.  When this variable is set with the path of the
;; virtualenv to use, `process-environment' and `exec-path' get proper
;; values in order to run shells inside the specified virtualenv.  So
;; the following will achieve the same as the previous example:

;; (setq python-shell-virtualenv-path "/path/to/env/")

;; Also the `python-shell-extra-pythonpaths' variable have been
;; introduced as simple way of adding paths to the PYTHONPATH without
;; affecting existing values.

;; Pdb tracking: when you execute a block of code that contains some
;; call to pdb (or ipdb) it will prompt the block of code and will
;; follow the execution of pdb marking the current line with an arrow.

;; Symbol completion: you can complete the symbol at point.  It uses
;; the shell completion in background so you should run
;; `python-shell-send-buffer' from time to time to get better results.

;; Skeletons: 6 skeletons are provided for simple inserting of class,
;; def, for, if, try and while.  These skeletons are integrated with
;; abbrev.  If you have `abbrev-mode' activated and
;; `python-skeleton-autoinsert' is set to t, then whenever you type
;; the name of any of those defined and hit SPC, they will be
;; automatically expanded.  As an alternative you can use the defined
;; skeleton commands: `python-skeleton-class', `python-skeleton-def'
;; `python-skeleton-for', `python-skeleton-if', `python-skeleton-try'
;; and `python-skeleton-while'.

;; FFAP: You can find the filename for a given module when using ffap
;; out of the box.  This feature needs an inferior python shell
;; running.

;; Code check: Check the current file for errors with `python-check'
;; using the program defined in `python-check-command'.

;; Eldoc: returns documentation for object at point by using the
;; inferior python subprocess to inspect its documentation.  As you
;; might guessed you should run `python-shell-send-buffer' from time
;; to time to get better results too.

;; Imenu: There are two index building functions to be used as
;; `imenu-create-index-function': `python-imenu-create-index' (the
;; default one, builds the alist in form of a tree) and
;; `python-imenu-create-flat-index'.  See also
;; `python-imenu-format-item-label-function',
;; `python-imenu-format-parent-item-label-function',
;; `python-imenu-format-parent-item-jump-label-function' variables for
;; changing the way labels are formatted in the tree version.

;; If you used python-mode.el you probably will miss auto-indentation
;; when inserting newlines.  To achieve the same behavior you have
;; two options:

;; 1) Use GNU/Emacs' standard binding for `newline-and-indent': C-j.

;; 2) Add the following hook in your .emacs:

;; (add-hook 'python-mode-hook
;;   #'(lambda ()
;;       (define-key python-mode-map "\C-m" 'newline-and-indent)))

;; I'd recommend the first one since you'll get the same behavior for
;; all modes out-of-the-box.

;;; Installation:

;; Add this to your .emacs:

;; (add-to-list 'load-path "/folder/containing/file")
;; (require 'python)

;;; TODO:

;;; Code:

(require 'ansi-color)
(require 'cl-lib)
(require 'comint)
(require 'json)

;; Avoid compiler warnings
(defvar view-return-to-alist)
(defvar compilation-error-regexp-alist)
(defvar outline-heading-end-regexp)

(autoload 'comint-mode "comint")

;;;###autoload
(add-to-list 'auto-mode-alist (cons (purecopy "\\.py\\'")  'python-mode))
;;;###autoload
(add-to-list 'interpreter-mode-alist (cons (purecopy "python[0-9.]*") 'python-mode))

(defgroup python nil
  "Python Language's flying circus support for Emacs."
  :group 'languages
  :version "24.3"
  :link '(emacs-commentary-link "python"))


;;; Bindings

(defvar python-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Movement
    (define-key map [remap backward-sentence] 'python-nav-backward-block)
    (define-key map [remap forward-sentence] 'python-nav-forward-block)
    (define-key map [remap backward-up-list] 'python-nav-backward-up-list)
    (define-key map "\C-c\C-j" 'imenu)
    ;; Indent specific
    (define-key map "\177" 'python-indent-dedent-line-backspace)
    (define-key map (kbd "<backtab>") 'python-indent-dedent-line)
    (define-key map "\C-c<" 'python-indent-shift-left)
    (define-key map "\C-c>" 'python-indent-shift-right)
    ;; Skeletons
    (define-key map "\C-c\C-tc" 'python-skeleton-class)
    (define-key map "\C-c\C-td" 'python-skeleton-def)
    (define-key map "\C-c\C-tf" 'python-skeleton-for)
    (define-key map "\C-c\C-ti" 'python-skeleton-if)
    (define-key map "\C-c\C-tt" 'python-skeleton-try)
    (define-key map "\C-c\C-tw" 'python-skeleton-while)
    ;; Shell interaction
    (define-key map "\C-c\C-p" 'run-python)
    (define-key map "\C-c\C-s" 'python-shell-send-string)
    (define-key map "\C-c\C-r" 'python-shell-send-region)
    (define-key map "\C-\M-x" 'python-shell-send-defun)
    (define-key map "\C-c\C-c" 'python-shell-send-buffer)
    (define-key map "\C-c\C-l" 'python-shell-send-file)
    (define-key map "\C-c\C-z" 'python-shell-switch-to-shell)
    ;; Some util commands
    (define-key map "\C-c\C-v" 'python-check)
    (define-key map "\C-c\C-f" 'python-eldoc-at-point)
    ;; Utilities
    (substitute-key-definition 'complete-symbol 'completion-at-point
                               map global-map)
    (easy-menu-define python-menu map "Python Mode menu"
      `("Python"
        :help "Python-specific Features"
        ["Shift region left" python-indent-shift-left :active mark-active
         :help "Shift region left by a single indentation step"]
        ["Shift region right" python-indent-shift-right :active mark-active
         :help "Shift region right by a single indentation step"]
        "-"
        ["Start of def/class" beginning-of-defun
         :help "Go to start of outermost definition around point"]
        ["End of def/class" end-of-defun
         :help "Go to end of definition around point"]
        ["Mark def/class" mark-defun
         :help "Mark outermost definition around point"]
        ["Jump to def/class" imenu
         :help "Jump to a class or function definition"]
        "--"
        ("Skeletons")
        "---"
        ["Start interpreter" run-python
         :help "Run inferior Python process in a separate buffer"]
        ["Switch to shell" python-shell-switch-to-shell
         :help "Switch to running inferior Python process"]
        ["Eval string" python-shell-send-string
         :help "Eval string in inferior Python session"]
        ["Eval buffer" python-shell-send-buffer
         :help "Eval buffer in inferior Python session"]
        ["Eval region" python-shell-send-region
         :help "Eval region in inferior Python session"]
        ["Eval defun" python-shell-send-defun
         :help "Eval defun in inferior Python session"]
        ["Eval file" python-shell-send-file
         :help "Eval file in inferior Python session"]
        ["Debugger" pdb :help "Run pdb under GUD"]
        "----"
        ["Check file" python-check
         :help "Check file for errors"]
        ["Help on symbol" python-eldoc-at-point
         :help "Get help on symbol at point"]
        ["Complete symbol" completion-at-point
         :help "Complete symbol before point"]))
    map)
  "Keymap for `python-mode'.")


;;; Python specialized rx

(eval-when-compile
  (defconst python-rx-constituents
    `((block-start          . ,(rx symbol-start
                                   (or "def" "class" "if" "elif" "else" "try"
                                       "except" "finally" "for" "while" "with")
                                   symbol-end))
      (dedenter            . ,(rx symbol-start
                                   (or "elif" "else" "except" "finally")
                                   symbol-end))
      (block-ender         . ,(rx symbol-start
                                  (or
                                   "break" "continue" "pass" "raise" "return")
                                  symbol-end))
      (decorator            . ,(rx line-start (* space) ?@ (any letter ?_)
                                   (* (any word ?_))))
      (defun                . ,(rx symbol-start (or "def" "class") symbol-end))
      (if-name-main         . ,(rx line-start "if" (+ space) "__name__"
                                   (+ space) "==" (+ space)
                                   (any ?' ?\") "__main__" (any ?' ?\")
                                   (* space) ?:))
      (symbol-name          . ,(rx (any letter ?_) (* (any word ?_))))
      (open-paren           . ,(rx (or "{" "[" "(")))
      (close-paren          . ,(rx (or "}" "]" ")")))
      (simple-operator      . ,(rx (any ?+ ?- ?/ ?& ?^ ?~ ?| ?* ?< ?> ?= ?%)))
      ;; FIXME: rx should support (not simple-operator).
      (not-simple-operator  . ,(rx
                                (not
                                 (any ?+ ?- ?/ ?& ?^ ?~ ?| ?* ?< ?> ?= ?%))))
      ;; FIXME: Use regexp-opt.
      (operator             . ,(rx (or "+" "-" "/" "&" "^" "~" "|" "*" "<" ">"
                                       "=" "%" "**" "//" "<<" ">>" "<=" "!="
                                       "==" ">=" "is" "not")))
      ;; FIXME: Use regexp-opt.
      (assignment-operator  . ,(rx (or "=" "+=" "-=" "*=" "/=" "//=" "%=" "**="
                                       ">>=" "<<=" "&=" "^=" "|=")))
      (string-delimiter . ,(rx (and
                                ;; Match even number of backslashes.
                                (or (not (any ?\\ ?\' ?\")) point
                                    ;; Quotes might be preceded by a escaped quote.
                                    (and (or (not (any ?\\)) point) ?\\
                                         (* ?\\ ?\\) (any ?\' ?\")))
                                (* ?\\ ?\\)
                                ;; Match single or triple quotes of any kind.
                                (group (or  "\"" "\"\"\"" "'" "'''"))))))
    "Additional Python specific sexps for `python-rx'")

  (defmacro python-rx (&rest regexps)
    "Python mode specialized rx macro.
This variant of `rx' supports common Python named REGEXPS."
    (let ((rx-constituents (append python-rx-constituents rx-constituents)))
      (cond ((null regexps)
             (error "No regexp"))
            ((cdr regexps)
             (rx-to-string `(and ,@regexps) t))
            (t
             (rx-to-string (car regexps) t))))))


;;; Font-lock and syntax

(eval-when-compile
  (defun python-syntax--context-compiler-macro (form type &optional syntax-ppss)
    (pcase type
      (`'comment
       `(let ((ppss (or ,syntax-ppss (syntax-ppss))))
          (and (nth 4 ppss) (nth 8 ppss))))
      (`'string
       `(let ((ppss (or ,syntax-ppss (syntax-ppss))))
          (and (nth 3 ppss) (nth 8 ppss))))
      (`'paren
       `(nth 1 (or ,syntax-ppss (syntax-ppss))))
      (_ form))))

(defun python-syntax-context (type &optional syntax-ppss)
  "Return non-nil if point is on TYPE using SYNTAX-PPSS.
TYPE can be `comment', `string' or `paren'.  It returns the start
character address of the specified TYPE."
  (declare (compiler-macro python-syntax--context-compiler-macro))
  (let ((ppss (or syntax-ppss (syntax-ppss))))
    (pcase type
      (`comment (and (nth 4 ppss) (nth 8 ppss)))
      (`string (and (nth 3 ppss) (nth 8 ppss)))
      (`paren (nth 1 ppss))
      (_ nil))))

(defun python-syntax-context-type (&optional syntax-ppss)
  "Return the context type using SYNTAX-PPSS.
The type returned can be `comment', `string' or `paren'."
  (let ((ppss (or syntax-ppss (syntax-ppss))))
    (cond
     ((nth 8 ppss) (if (nth 4 ppss) 'comment 'string))
     ((nth 1 ppss) 'paren))))

(defsubst python-syntax-comment-or-string-p ()
  "Return non-nil if point is inside 'comment or 'string."
  (nth 8 (syntax-ppss)))

(define-obsolete-function-alias
  'python-info-ppss-context #'python-syntax-context "24.3")

(define-obsolete-function-alias
  'python-info-ppss-context-type #'python-syntax-context-type "24.3")

(define-obsolete-function-alias
  'python-info-ppss-comment-or-string-p
  #'python-syntax-comment-or-string-p "24.3")

(defvar python-font-lock-keywords
  ;; Keywords
  `(,(rx symbol-start
         (or
          "and" "del" "from" "not" "while" "as" "elif" "global" "or" "with"
          "assert" "else" "if" "pass" "yield" "break" "except" "import" "class"
          "in" "raise" "continue" "finally" "is" "return" "def" "for" "lambda"
          "try"
          ;; Python 2:
          "print" "exec"
          ;; Python 3:
          ;; False, None, and True are listed as keywords on the Python 3
          ;; documentation, but since they also qualify as constants they are
          ;; fontified like that in order to keep font-lock consistent between
          ;; Python versions.
          "nonlocal"
          ;; Extra:
          "self")
         symbol-end)
    ;; functions
    (,(rx symbol-start "def" (1+ space) (group (1+ (or word ?_))))
     (1 font-lock-function-name-face))
    ;; classes
    (,(rx symbol-start "class" (1+ space) (group (1+ (or word ?_))))
     (1 font-lock-type-face))
    ;; Constants
    (,(rx symbol-start
          (or
           "Ellipsis" "False" "None" "NotImplemented" "True" "__debug__"
           ;; copyright, license, credits, quit and exit are added by the site
           ;; module and they are not intended to be used in programs
           "copyright" "credits" "exit" "license" "quit")
          symbol-end) . font-lock-constant-face)
    ;; Decorators.
    (,(rx line-start (* (any " \t")) (group "@" (1+ (or word ?_))
                                            (0+ "." (1+ (or word ?_)))))
     (1 font-lock-type-face))
    ;; Builtin Exceptions
    (,(rx symbol-start
          (or
           "ArithmeticError" "AssertionError" "AttributeError" "BaseException"
           "DeprecationWarning" "EOFError" "EnvironmentError" "Exception"
           "FloatingPointError" "FutureWarning" "GeneratorExit" "IOError"
           "ImportError" "ImportWarning" "IndexError" "KeyError"
           "KeyboardInterrupt" "LookupError" "MemoryError" "NameError"
           "NotImplementedError" "OSError" "OverflowError"
           "PendingDeprecationWarning" "ReferenceError" "RuntimeError"
           "RuntimeWarning" "StopIteration" "SyntaxError" "SyntaxWarning"
           "SystemError" "SystemExit" "TypeError" "UnboundLocalError"
           "UnicodeDecodeError" "UnicodeEncodeError" "UnicodeError"
           "UnicodeTranslateError" "UnicodeWarning" "UserWarning" "VMSError"
           "ValueError" "Warning" "WindowsError" "ZeroDivisionError"
           ;; Python 2:
           "StandardError"
           ;; Python 3:
           "BufferError" "BytesWarning" "IndentationError" "ResourceWarning"
           "TabError")
          symbol-end) . font-lock-type-face)
    ;; Builtins
    (,(rx symbol-start
          (or
           "abs" "all" "any" "bin" "bool" "callable" "chr" "classmethod"
           "compile" "complex" "delattr" "dict" "dir" "divmod" "enumerate"
           "eval" "filter" "float" "format" "frozenset" "getattr" "globals"
           "hasattr" "hash" "help" "hex" "id" "input" "int" "isinstance"
           "issubclass" "iter" "len" "list" "locals" "map" "max" "memoryview"
           "min" "next" "object" "oct" "open" "ord" "pow" "print" "property"
           "range" "repr" "reversed" "round" "set" "setattr" "slice" "sorted"
           "staticmethod" "str" "sum" "super" "tuple" "type" "vars" "zip"
           "__import__"
           ;; Python 2:
           "basestring" "cmp" "execfile" "file" "long" "raw_input" "reduce"
           "reload" "unichr" "unicode" "xrange" "apply" "buffer" "coerce"
           "intern"
           ;; Python 3:
           "ascii" "bytearray" "bytes" "exec"
           ;; Extra:
           "__all__" "__doc__" "__name__" "__package__")
          symbol-end) . font-lock-builtin-face)
    ;; assignments
    ;; support for a = b = c = 5
    (,(lambda (limit)
        (let ((re (python-rx (group (+ (any word ?. ?_)))
                             (? ?\[ (+ (not (any  ?\]))) ?\]) (* space)
                             assignment-operator))
              (res nil))
          (while (and (setq res (re-search-forward re limit t))
                      (or (python-syntax-context 'paren)
                          (equal (char-after (point-marker)) ?=))))
          res))
     (1 font-lock-variable-name-face nil nil))
    ;; support for a, b, c = (1, 2, 3)
    (,(lambda (limit)
        (let ((re (python-rx (group (+ (any word ?. ?_))) (* space)
                             (* ?, (* space) (+ (any word ?. ?_)) (* space))
                             ?, (* space) (+ (any word ?. ?_)) (* space)
                             assignment-operator))
              (res nil))
          (while (and (setq res (re-search-forward re limit t))
                      (goto-char (match-end 1))
                      (python-syntax-context 'paren)))
          res))
     (1 font-lock-variable-name-face nil nil))))

(defconst python-syntax-propertize-function
  (syntax-propertize-rules
   ((python-rx string-delimiter)
    (0 (ignore (python-syntax-stringify))))))

(defsubst python-syntax-count-quotes (quote-char &optional point limit)
  "Count number of quotes around point (max is 3).
QUOTE-CHAR is the quote char to count.  Optional argument POINT is
the point where scan starts (defaults to current point), and LIMIT
is used to limit the scan."
  (let ((i 0))
    (while (and (< i 3)
                (or (not limit) (< (+ point i) limit))
                (eq (char-after (+ point i)) quote-char))
      (setq i (1+ i)))
    i))

(defun python-syntax-stringify ()
  "Put `syntax-table' property correctly on single/triple quotes."
  (let* ((num-quotes (length (match-string-no-properties 1)))
         (ppss (prog2
                   (backward-char num-quotes)
                   (syntax-ppss)
                 (forward-char num-quotes)))
         (string-start (and (not (nth 4 ppss)) (nth 8 ppss)))
         (quote-starting-pos (- (point) num-quotes))
         (quote-ending-pos (point))
         (num-closing-quotes
          (and string-start
               (python-syntax-count-quotes
                (char-before) string-start quote-starting-pos))))
    (cond ((and string-start (= num-closing-quotes 0))
           ;; This set of quotes doesn't match the string starting
           ;; kind. Do nothing.
           nil)
          ((not string-start)
           ;; This set of quotes delimit the start of a string.
           (put-text-property quote-starting-pos (1+ quote-starting-pos)
                              'syntax-table (string-to-syntax "|")))
          ((= num-quotes num-closing-quotes)
           ;; This set of quotes delimit the end of a string.
           (put-text-property (1- quote-ending-pos) quote-ending-pos
                              'syntax-table (string-to-syntax "|")))
          ((> num-quotes num-closing-quotes)
           ;; This may only happen whenever a triple quote is closing
           ;; a single quoted string. Add string delimiter syntax to
           ;; all three quotes.
           (put-text-property quote-starting-pos quote-ending-pos
                              'syntax-table (string-to-syntax "|"))))))

(defvar python-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; Give punctuation syntax to ASCII that normally has symbol
    ;; syntax or has word syntax and isn't a letter.
    (let ((symbol (string-to-syntax "_"))
          (sst (standard-syntax-table)))
      (dotimes (i 128)
        (unless (= i ?_)
          (if (equal symbol (aref sst i))
              (modify-syntax-entry i "." table)))))
    (modify-syntax-entry ?$ "." table)
    (modify-syntax-entry ?% "." table)
    ;; exceptions
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?' "\"" table)
    (modify-syntax-entry ?` "$" table)
    table)
  "Syntax table for Python files.")

(defvar python-dotty-syntax-table
  (let ((table (make-syntax-table python-mode-syntax-table)))
    (modify-syntax-entry ?. "w" table)
    (modify-syntax-entry ?_ "w" table)
    table)
  "Dotty syntax table for Python files.
It makes underscores and dots word constituent chars.")


;;; Indentation

(defcustom python-indent-offset 4
  "Default indentation offset for Python."
  :group 'python
  :type 'integer
  :safe 'integerp)

(defcustom python-indent-guess-indent-offset t
  "Non-nil tells Python mode to guess `python-indent-offset' value."
  :type 'boolean
  :group 'python
  :safe 'booleanp)

(defcustom python-indent-trigger-commands
  '(indent-for-tab-command yas-expand yas/expand)
  "Commands that might trigger a `python-indent-line' call."
  :type '(repeat symbol)
  :group 'python)

(define-obsolete-variable-alias
  'python-indent 'python-indent-offset "24.3")

(define-obsolete-variable-alias
  'python-guess-indent 'python-indent-guess-indent-offset "24.3")

(defvar python-indent-current-level 0
  "Current indentation level `python-indent-line-function' is using.")

(defvar python-indent-levels '(0)
  "Levels of indentation available for `python-indent-line-function'.")

(defun python-indent-guess-indent-offset ()
  "Guess and set `python-indent-offset' for the current buffer."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((block-end))
        (while (and (not block-end)
                    (re-search-forward
                     (python-rx line-start block-start) nil t))
          (when (and
                 (not (python-syntax-context-type))
                 (progn
                   (goto-char (line-end-position))
                   (python-util-forward-comment -1)
                   (if (equal (char-before) ?:)
                       t
                     (forward-line 1)
                     (when (python-info-block-continuation-line-p)
                       (while (and (python-info-continuation-line-p)
                                   (not (eobp)))
                         (forward-line 1))
                       (python-util-forward-comment -1)
                       (when (equal (char-before) ?:)
                         t)))))
            (setq block-end (point-marker))))
        (let ((indentation
               (when block-end
                 (goto-char block-end)
                 (python-util-forward-comment)
                 (current-indentation))))
          (if (and indentation (not (zerop indentation)))
              (set (make-local-variable 'python-indent-offset) indentation)
            (message "Can't guess python-indent-offset, using defaults: %s"
                     python-indent-offset)))))))

(defun python-indent-context ()
  "Get information on indentation context.
Context information is returned with a cons with the form:
    (STATUS . START)

Where status can be any of the following symbols:

 * after-comment: When current line might continue a comment block
 * inside-paren: If point in between (), {} or []
 * inside-string: If point is inside a string
 * after-backslash: Previous line ends in a backslash
 * after-beginning-of-block: Point is after beginning of block
 * after-line: Point is after normal line
 * dedenter-statement: Point is on a dedenter statement.
 * no-indent: Point is at beginning of buffer or other special case
START is the buffer position where the sexp starts."
  (save-restriction
    (widen)
    (let ((ppss (save-excursion (beginning-of-line) (syntax-ppss)))
          (start))
      (cons
       (cond
        ;; Beginning of buffer
        ((save-excursion
           (goto-char (line-beginning-position))
           (bobp))
         'no-indent)
        ;; Comment continuation
        ((save-excursion
           (when (and
                  (or
                   (python-info-current-line-comment-p)
                   (python-info-current-line-empty-p))
                  (progn
                    (forward-comment -1)
                    (python-info-current-line-comment-p)))
             (setq start (point))
             'after-comment)))
        ;; Inside string
        ((setq start (python-syntax-context 'string ppss))
         'inside-string)
        ;; Inside a paren
        ((setq start (python-syntax-context 'paren ppss))
         'inside-paren)
        ;; After backslash
        ((setq start (when (not (or (python-syntax-context 'string ppss)
                                    (python-syntax-context 'comment ppss)))
                       (let ((line-beg-pos (line-number-at-pos)))
                         (python-info-line-ends-backslash-p
                          (1- line-beg-pos)))))
         'after-backslash)
        ;; After beginning of block
        ((setq start (save-excursion
                       (when (progn
                               (back-to-indentation)
                               (python-util-forward-comment -1)
                               (equal (char-before) ?:))
                         ;; Move to the first block start that's not in within
                         ;; a string, comment or paren and that's not a
                         ;; continuation line.
                         (while (and (re-search-backward
                                      (python-rx block-start) nil t)
                                     (or
                                      (python-syntax-context-type)
                                      (python-info-continuation-line-p))))
                         (when (looking-at (python-rx block-start))
                           (point-marker)))))
         'after-beginning-of-block)
        ((when (setq start (python-info-dedenter-statement-p))
           'dedenter-statement))
        ;; After normal line
        ((setq start (save-excursion
                       (back-to-indentation)
                       (skip-chars-backward (rx (or whitespace ?\n)))
                       (python-nav-beginning-of-statement)
                       (point-marker)))
         'after-line)
        ;; Do not indent
        (t 'no-indent))
       start))))

(defun python-indent-calculate-indentation ()
  "Calculate correct indentation offset for the current line."
  (let* ((indentation-context (python-indent-context))
         (context-status (car indentation-context))
         (context-start (cdr indentation-context)))
    (save-restriction
      (widen)
      (save-excursion
        (pcase context-status
          (`no-indent 0)
          (`after-comment
           (goto-char context-start)
           (current-indentation))
          ;; When point is after beginning of block just add one level
          ;; of indentation relative to the context-start
          (`after-beginning-of-block
           (goto-char context-start)
           (+ (current-indentation) python-indent-offset))
          ;; When after a simple line just use previous line
          ;; indentation.
          (`after-line
           (let* ((pair (save-excursion
                          (goto-char context-start)
                          (cons
                           (current-indentation)
                           (python-info-beginning-of-block-p))))
                  (context-indentation (car pair))
                  ;; TODO: Separate block enders into its own case.
                  (adjustment
                   (if (save-excursion
                         (python-util-forward-comment -1)
                         (python-nav-beginning-of-statement)
                         (looking-at (python-rx block-ender)))
                       python-indent-offset
                     0)))
             (- context-indentation adjustment)))
          ;; When point is on a dedenter statement, search for the
          ;; opening block that corresponds to it and use its
          ;; indentation.  If no opening block is found just remove
          ;; indentation as this is an invalid python file.
          (`dedenter-statement
           (let ((block-start-point
                  (python-info-dedenter-opening-block-position)))
             (save-excursion
               (if (not block-start-point)
                   0
                 (goto-char block-start-point)
                 (current-indentation)))))
          ;; When inside of a string, do nothing. just use the current
          ;; indentation.  XXX: perhaps it would be a good idea to
          ;; invoke standard text indentation here
          (`inside-string
           (goto-char context-start)
           (current-indentation))
          ;; After backslash we have several possibilities.
          (`after-backslash
           (cond
            ;; Check if current line is a dot continuation.  For this
            ;; the current line must start with a dot and previous
            ;; line must contain a dot too.
            ((save-excursion
               (back-to-indentation)
               (when (looking-at "\\.")
                 ;; If after moving one line back point is inside a paren it
                 ;; needs to move back until it's not anymore
                 (while (prog2
                            (forward-line -1)
                            (and (not (bobp))
                                 (python-syntax-context 'paren))))
                 (goto-char (line-end-position))
                 (while (and (re-search-backward
                              "\\." (line-beginning-position) t)
                             (python-syntax-context-type)))
                 (if (and (looking-at "\\.")
                          (not (python-syntax-context-type)))
                     ;; The indentation is the same column of the
                     ;; first matching dot that's not inside a
                     ;; comment, a string or a paren
                     (current-column)
                   ;; No dot found on previous line, just add another
                   ;; indentation level.
                   (+ (current-indentation) python-indent-offset)))))
            ;; Check if prev line is a block continuation
            ((let ((block-continuation-start
                    (python-info-block-continuation-line-p)))
               (when block-continuation-start
                 ;; If block-continuation-start is set jump to that
                 ;; marker and use first column after the block start
                 ;; as indentation value.
                 (goto-char block-continuation-start)
                 (re-search-forward
                  (python-rx block-start (* space))
                  (line-end-position) t)
                 (current-column))))
            ;; Check if current line is an assignment continuation
            ((let ((assignment-continuation-start
                    (python-info-assignment-continuation-line-p)))
               (when assignment-continuation-start
                 ;; If assignment-continuation is set jump to that
                 ;; marker and use first column after the assignment
                 ;; operator as indentation value.
                 (goto-char assignment-continuation-start)
                 (current-column))))
            (t
             (forward-line -1)
             (goto-char (python-info-beginning-of-backslash))
             (if (save-excursion
                   (and
                    (forward-line -1)
                    (goto-char
                     (or (python-info-beginning-of-backslash) (point)))
                    (python-info-line-ends-backslash-p)))
                 ;; The two previous lines ended in a backslash so we must
                 ;; respect previous line indentation.
                 (current-indentation)
               ;; What happens here is that we are dealing with the second
               ;; line of a backslash continuation, in that case we just going
               ;; to add one indentation level.
               (+ (current-indentation) python-indent-offset)))))
          ;; When inside a paren there's a need to handle nesting
          ;; correctly
          (`inside-paren
           (cond
            ;; If current line closes the outermost open paren use the
            ;; current indentation of the context-start line.
            ((save-excursion
               (skip-syntax-forward "\s" (line-end-position))
               (when (and (looking-at (regexp-opt '(")" "]" "}")))
                          (progn
                            (forward-char 1)
                            (not (python-syntax-context 'paren))))
                 (goto-char context-start)
                 (current-indentation))))
            ;; If open paren is contained on a line by itself add another
            ;; indentation level, else look for the first word after the
            ;; opening paren and use it's column position as indentation
            ;; level.
            ((let* ((content-starts-in-newline)
                    (indent
                     (save-excursion
                       (if (setq content-starts-in-newline
                                 (progn
                                   (goto-char context-start)
                                   (forward-char)
                                   (save-restriction
                                     (narrow-to-region
                                      (line-beginning-position)
                                      (line-end-position))
                                     (python-util-forward-comment))
                                   (looking-at "$")))
                           (+ (current-indentation) python-indent-offset)
                         (current-column)))))
               ;; Adjustments
               (cond
                ;; If current line closes a nested open paren de-indent one
                ;; level.
                ((progn
                   (back-to-indentation)
                   (looking-at (regexp-opt '(")" "]" "}"))))
                 (- indent python-indent-offset))
                ;; If the line of the opening paren that wraps the current
                ;; line starts a block add another level of indentation to
                ;; follow new pep8 recommendation. See: http://ur1.ca/5rojx
                ((save-excursion
                   (when (and content-starts-in-newline
                              (progn
                                (goto-char context-start)
                                (back-to-indentation)
                                (looking-at (python-rx block-start))))
                     (+ indent python-indent-offset))))
                (t indent)))))))))))

(defun python-indent-calculate-levels ()
  "Calculate `python-indent-levels' and reset `python-indent-current-level'."
  (if (not (python-info-dedenter-statement-p))
      (let* ((indentation (python-indent-calculate-indentation))
             (remainder (% indentation python-indent-offset))
             (steps (/ (- indentation remainder) python-indent-offset)))
        (setq python-indent-levels (list 0))
        (dotimes (step steps)
          (push (* python-indent-offset (1+ step)) python-indent-levels))
        (when (not (eq 0 remainder))
          (push (+ (* python-indent-offset steps) remainder) python-indent-levels)))
    (setq python-indent-levels
          (or
           (mapcar (lambda (pos)
                     (save-excursion
                       (goto-char pos)
                       (current-indentation)))
                   (python-info-dedenter-opening-block-positions))
           (list 0))))
  (setq python-indent-current-level (1- (length python-indent-levels))
        python-indent-levels (nreverse python-indent-levels)))

(defun python-indent-toggle-levels ()
  "Toggle `python-indent-current-level' over `python-indent-levels'."
  (setq python-indent-current-level (1- python-indent-current-level))
  (when (< python-indent-current-level 0)
    (setq python-indent-current-level (1- (length python-indent-levels)))))

(defun python-indent-line (&optional force-toggle)
  "Internal implementation of `python-indent-line-function'.
Uses the offset calculated in
`python-indent-calculate-indentation' and available levels
indicated by the variable `python-indent-levels' to set the
current indentation.

When the variable `last-command' is equal to one of the symbols
inside `python-indent-trigger-commands' or FORCE-TOGGLE is
non-nil it cycles levels indicated in the variable
`python-indent-levels' by setting the current level in the
variable `python-indent-current-level'.

When the variable `last-command' is not equal to one of the
symbols inside `python-indent-trigger-commands' and FORCE-TOGGLE
is nil it calculates possible indentation levels and saves them
in the variable `python-indent-levels'.  Afterwards it sets the
variable `python-indent-current-level' correctly so offset is
equal to
   (nth python-indent-current-level python-indent-levels)"
  (or
   (and (or (and (memq this-command python-indent-trigger-commands)
                 (eq last-command this-command))
            force-toggle)
        (not (equal python-indent-levels '(0)))
        (or (python-indent-toggle-levels) t))
   (python-indent-calculate-levels))
  (let* ((starting-pos (point-marker))
         (indent-ending-position
          (+ (line-beginning-position) (current-indentation)))
         (follow-indentation-p
          (or (bolp)
              (and (<= (line-beginning-position) starting-pos)
                   (>= indent-ending-position starting-pos))))
         (next-indent (nth python-indent-current-level python-indent-levels)))
    (unless (= next-indent (current-indentation))
      (beginning-of-line)
      (delete-horizontal-space)
      (indent-to next-indent)
      (goto-char starting-pos))
    (and follow-indentation-p (back-to-indentation)))
  (python-info-dedenter-opening-block-message))

(defun python-indent-line-function ()
  "`indent-line-function' for Python mode.
See `python-indent-line' for details."
  (python-indent-line))

(defun python-indent-dedent-line ()
  "De-indent current line."
  (interactive "*")
  (when (and (not (python-syntax-comment-or-string-p))
             (<= (point-marker) (save-excursion
                                  (back-to-indentation)
                                  (point-marker)))
             (> (current-column) 0))
    (python-indent-line t)
    t))

(defun python-indent-dedent-line-backspace (arg)
  "De-indent current line.
Argument ARG is passed to `backward-delete-char-untabify' when
point is not in between the indentation."
  (interactive "*p")
  (when (not (python-indent-dedent-line))
    (backward-delete-char-untabify arg)))
(put 'python-indent-dedent-line-backspace 'delete-selection 'supersede)

(defun python-indent-region (start end)
  "Indent a Python region automagically.

Called from a program, START and END specify the region to indent."
  (let ((deactivate-mark nil))
    (save-excursion
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (or (bolp) (forward-line 1))
      (while (< (point) end)
        (or (and (bolp) (eolp))
            (let (word)
              (forward-line -1)
              (back-to-indentation)
              (setq word (current-word))
              (forward-line 1)
              (when (and word
                         ;; Don't mess with strings, unless it's the
                         ;; enclosing set of quotes.
                         (or (not (python-syntax-context 'string))
                             (eq
                              (syntax-after
                               (+ (1- (point))
                                  (current-indentation)
                                  (python-syntax-count-quotes (char-after) (point))))
                              (string-to-syntax "|"))))
                (beginning-of-line)
                (delete-horizontal-space)
                (indent-to (python-indent-calculate-indentation)))))
        (forward-line 1))
      (move-marker end nil))))

(defun python-indent-shift-left (start end &optional count)
  "Shift lines contained in region START END by COUNT columns to the left.
COUNT defaults to `python-indent-offset'.  If region isn't
active, the current line is shifted.  The shifted region includes
the lines in which START and END lie.  An error is signaled if
any lines in the region are indented less than COUNT columns."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end) current-prefix-arg)
     (list (line-beginning-position) (line-end-position) current-prefix-arg)))
  (if count
      (setq count (prefix-numeric-value count))
    (setq count python-indent-offset))
  (when (> count 0)
    (let ((deactivate-mark nil))
      (save-excursion
        (goto-char start)
        (while (< (point) end)
          (if (and (< (current-indentation) count)
                   (not (looking-at "[ \t]*$")))
              (error "Can't shift all lines enough"))
          (forward-line))
        (indent-rigidly start end (- count))))))

(add-to-list 'debug-ignored-errors "^Can't shift all lines enough")

(defun python-indent-shift-right (start end &optional count)
  "Shift lines contained in region START END by COUNT columns to the right.
COUNT defaults to `python-indent-offset'.  If region isn't
active, the current line is shifted.  The shifted region includes
the lines in which START and END lie."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end) current-prefix-arg)
     (list (line-beginning-position) (line-end-position) current-prefix-arg)))
  (let ((deactivate-mark nil))
    (setq count (if count (prefix-numeric-value count)
                  python-indent-offset))
    (indent-rigidly start end count)))

(defun python-indent-post-self-insert-function ()
  "Adjust indentation after insertion of some characters.
This function is intended to be added to `post-self-insert-hook.'
If a line renders a paren alone, after adding a char before it,
the line will be re-indented automatically if needed."
  (when (and electric-indent-mode
             (eq (char-before) last-command-event))
    (cond
     ;; Electric indent inside parens
     ((and
       (not (bolp))
       (let ((paren-start (python-syntax-context 'paren)))
         ;; Check that point is inside parens.
         (when paren-start
           (not
            ;; Filter the case where input is happening in the same
            ;; line where the open paren is.
            (= (line-number-at-pos)
               (line-number-at-pos paren-start)))))
       ;; When content has been added before the closing paren or a
       ;; comma has been inserted, it's ok to do the trick.
       (or
        (memq (char-after) '(?\) ?\] ?\}))
        (eq (char-before) ?,)))
      (save-excursion
        (goto-char (line-beginning-position))
        (let ((indentation (python-indent-calculate-indentation)))
          (when (< (current-indentation) indentation)
            (indent-line-to indentation)))))
     ;; Electric colon
     ((and (eq ?: last-command-event)
           (memq ?: electric-indent-chars)
           (not current-prefix-arg)
           ;; Trigger electric colon only at end of line
           (eolp)
           ;; Avoid re-indenting on extra colon
           (not (equal ?: (char-before (1- (point)))))
           (not (python-syntax-comment-or-string-p))
           ;; Never re-indent at beginning of defun
           (not (save-excursion
                  (python-nav-beginning-of-statement)
                  (python-info-looking-at-beginning-of-defun))))
      (python-indent-line)))))


;;; Navigation

(defvar python-nav-beginning-of-defun-regexp
  (python-rx line-start (* space) defun (+ space) (group symbol-name))
  "Regexp matching class or function definition.
The name of the defun should be grouped so it can be retrieved
via `match-string'.")

(defun python-nav--beginning-of-defun (&optional arg)
  "Internal implementation of `python-nav-beginning-of-defun'.
With positive ARG search backwards, else search forwards."
  (when (or (null arg) (= arg 0)) (setq arg 1))
  (let* ((re-search-fn (if (> arg 0)
                           #'re-search-backward
                         #'re-search-forward))
         (line-beg-pos (line-beginning-position))
         (line-content-start (+ line-beg-pos (current-indentation)))
         (pos (point-marker))
         (beg-indentation
          (and (> arg 0)
               (save-excursion
                 (while (and
                         (not (python-info-looking-at-beginning-of-defun))
                         (python-nav-backward-block)))
                 (or (and (python-info-looking-at-beginning-of-defun)
                          (+ (current-indentation) python-indent-offset))
                     0))))
         (found
          (progn
            (when (and (< arg 0)
                       (python-info-looking-at-beginning-of-defun))
              (end-of-line 1))
            (while (and (funcall re-search-fn
                                 python-nav-beginning-of-defun-regexp nil t)
                        (or (python-syntax-context-type)
                            ;; Handle nested defuns when moving
                            ;; backwards by checking indentation.
                            (and (> arg 0)
                                 (not (= (current-indentation) 0))
                                 (>= (current-indentation) beg-indentation)))))
            (and (python-info-looking-at-beginning-of-defun)
                 (or (not (= (line-number-at-pos pos)
                             (line-number-at-pos)))
                     (and (>= (point) line-beg-pos)
                          (<= (point) line-content-start)
                          (> pos line-content-start)))))))
    (if found
        (or (beginning-of-line 1) t)
      (and (goto-char pos) nil))))

(defun python-nav-beginning-of-defun (&optional arg)
  "Move point to `beginning-of-defun'.
With positive ARG search backwards else search forward.
ARG nil or 0 defaults to 1.  When searching backwards,
nested defuns are handled with care depending on current
point position.  Return non-nil if point is moved to
`beginning-of-defun'."
  (when (or (null arg) (= arg 0)) (setq arg 1))
  (let ((found))
    (while (and (not (= arg 0))
                (let ((keep-searching-p
                       (python-nav--beginning-of-defun arg)))
                  (when (and keep-searching-p (null found))
                    (setq found t))
                  keep-searching-p))
      (setq arg (if (> arg 0) (1- arg) (1+ arg))))
    found))

(defun python-nav-end-of-defun ()
  "Move point to the end of def or class.
Returns nil if point is not in a def or class."
  (interactive)
  (let ((beg-defun-indent)
        (beg-pos (point)))
    (when (or (python-info-looking-at-beginning-of-defun)
              (python-nav-beginning-of-defun 1)
              (python-nav-beginning-of-defun -1))
      (setq beg-defun-indent (current-indentation))
      (while (progn
               (python-nav-end-of-statement)
               (python-util-forward-comment 1)
               (and (> (current-indentation) beg-defun-indent)
                    (not (eobp)))))
      (python-util-forward-comment -1)
      (forward-line 1)
      ;; Ensure point moves forward.
      (and (> beg-pos (point)) (goto-char beg-pos)))))

(defun python-nav--syntactically (fn poscompfn &optional contextfn)
  "Move point using FN avoiding places with specific context.
FN must take no arguments.  POSCOMPFN is a two arguments function
used to compare current and previous point after it is moved
using FN, this is normally a less-than or greater-than
comparison.  Optional argument CONTEXTFN defaults to
`python-syntax-context-type' and is used for checking current
point context, it must return a non-nil value if this point must
be skipped."
  (let ((contextfn (or contextfn 'python-syntax-context-type))
        (start-pos (point-marker))
        (prev-pos))
    (catch 'found
      (while t
        (let* ((newpos
                (and (funcall fn) (point-marker)))
               (context (funcall contextfn)))
          (cond ((and (not context) newpos
                      (or (and (not prev-pos) newpos)
                          (and prev-pos newpos
                               (funcall poscompfn newpos prev-pos))))
                 (throw 'found (point-marker)))
                ((and newpos context)
                 (setq prev-pos (point)))
                (t (when (not newpos) (goto-char start-pos))
                   (throw 'found nil))))))))

(defun python-nav--forward-defun (arg)
  "Internal implementation of python-nav-{backward,forward}-defun.
Uses ARG to define which function to call, and how many times
repeat it."
  (let ((found))
    (while (and (> arg 0)
                (setq found
                      (python-nav--syntactically
                       (lambda ()
                         (re-search-forward
                          python-nav-beginning-of-defun-regexp nil t))
                       '>)))
      (setq arg (1- arg)))
    (while (and (< arg 0)
                (setq found
                      (python-nav--syntactically
                       (lambda ()
                         (re-search-backward
                          python-nav-beginning-of-defun-regexp nil t))
                       '<)))
      (setq arg (1+ arg)))
    found))

(defun python-nav-backward-defun (&optional arg)
  "Navigate to closer defun backward ARG times.
Unlikely `python-nav-beginning-of-defun' this doesn't care about
nested definitions."
  (interactive "^p")
  (python-nav--forward-defun (- (or arg 1))))

(defun python-nav-forward-defun (&optional arg)
  "Navigate to closer defun forward ARG times.
Unlikely `python-nav-beginning-of-defun' this doesn't care about
nested definitions."
  (interactive "^p")
  (python-nav--forward-defun (or arg 1)))

(defun python-nav-beginning-of-statement ()
  "Move to start of current statement."
  (interactive "^")
  (back-to-indentation)
  (let* ((ppss (syntax-ppss))
         (context-point
          (or
           (python-syntax-context 'paren ppss)
           (python-syntax-context 'string ppss))))
    (cond ((bobp))
          (context-point
           (goto-char context-point)
           (python-nav-beginning-of-statement))
          ((save-excursion
             (forward-line -1)
             (python-info-line-ends-backslash-p))
           (forward-line -1)
           (python-nav-beginning-of-statement))))
  (point-marker))

(defun python-nav-end-of-statement (&optional noend)
  "Move to end of current statement.
Optional argument NOEND is internal and makes the logic to not
jump to the end of line when moving forward searching for the end
of the statement."
  (interactive "^")
  (let (string-start bs-pos)
    (while (and (or noend (goto-char (line-end-position)))
                (not (eobp))
                (cond ((setq string-start (python-syntax-context 'string))
                       (goto-char string-start)
                       (if (python-syntax-context 'paren)
                           ;; Ended up inside a paren, roll again.
                           (python-nav-end-of-statement t)
                         ;; This is not inside a paren, move to the
                         ;; end of this string.
                         (goto-char (+ (point)
                                       (python-syntax-count-quotes
                                        (char-after (point)) (point))))
                         (or (re-search-forward (rx (syntax string-delimiter)) nil t)
                             (goto-char (point-max)))))
                      ((python-syntax-context 'paren)
                       ;; The statement won't end before we've escaped
                       ;; at least one level of parenthesis.
                       (condition-case err
                           (goto-char (scan-lists (point) 1 -1))
                         (scan-error (goto-char (nth 3 err)))))
                      ((setq bs-pos (python-info-line-ends-backslash-p))
                       (goto-char bs-pos)
                       (forward-line 1))))))
  (point-marker))

(defun python-nav-backward-statement (&optional arg)
  "Move backward to previous statement.
With ARG, repeat.  See `python-nav-forward-statement'."
  (interactive "^p")
  (or arg (setq arg 1))
  (python-nav-forward-statement (- arg)))

(defun python-nav-forward-statement (&optional arg)
  "Move forward to next statement.
With ARG, repeat.  With negative argument, move ARG times
backward to previous statement."
  (interactive "^p")
  (or arg (setq arg 1))
  (while (> arg 0)
    (python-nav-end-of-statement)
    (python-util-forward-comment)
    (python-nav-beginning-of-statement)
    (setq arg (1- arg)))
  (while (< arg 0)
    (python-nav-beginning-of-statement)
    (python-util-forward-comment -1)
    (python-nav-beginning-of-statement)
    (setq arg (1+ arg))))

(defun python-nav-beginning-of-block ()
  "Move to start of current block."
  (interactive "^")
  (let ((starting-pos (point)))
    (if (progn
          (python-nav-beginning-of-statement)
          (looking-at (python-rx block-start)))
        (point-marker)
      ;; Go to first line beginning a statement
      (while (and (not (bobp))
                  (or (and (python-nav-beginning-of-statement) nil)
                      (python-info-current-line-comment-p)
                      (python-info-current-line-empty-p)))
        (forward-line -1))
      (let ((block-matching-indent
             (- (current-indentation) python-indent-offset)))
        (while
            (and (python-nav-backward-block)
                 (> (current-indentation) block-matching-indent)))
        (if (and (looking-at (python-rx block-start))
                 (= (current-indentation) block-matching-indent))
            (point-marker)
          (and (goto-char starting-pos) nil))))))

(defun python-nav-end-of-block ()
  "Move to end of current block."
  (interactive "^")
  (when (python-nav-beginning-of-block)
    (let ((block-indentation (current-indentation)))
      (python-nav-end-of-statement)
      (while (and (forward-line 1)
                  (not (eobp))
                  (or (and (> (current-indentation) block-indentation)
                           (or (python-nav-end-of-statement) t))
                      (python-info-current-line-comment-p)
                      (python-info-current-line-empty-p))))
      (python-util-forward-comment -1)
      (point-marker))))

(defun python-nav-backward-block (&optional arg)
  "Move backward to previous block of code.
With ARG, repeat.  See `python-nav-forward-block'."
  (interactive "^p")
  (or arg (setq arg 1))
  (python-nav-forward-block (- arg)))

(defun python-nav-forward-block (&optional arg)
  "Move forward to next block of code.
With ARG, repeat.  With negative argument, move ARG times
backward to previous block."
  (interactive "^p")
  (or arg (setq arg 1))
  (let ((block-start-regexp
         (python-rx line-start (* whitespace) block-start))
        (starting-pos (point)))
    (while (> arg 0)
      (python-nav-end-of-statement)
      (while (and
              (re-search-forward block-start-regexp nil t)
              (python-syntax-context-type)))
      (setq arg (1- arg)))
    (while (< arg 0)
      (python-nav-beginning-of-statement)
      (while (and
              (re-search-backward block-start-regexp nil t)
              (python-syntax-context-type)))
      (setq arg (1+ arg)))
    (python-nav-beginning-of-statement)
    (if (not (looking-at (python-rx block-start)))
        (and (goto-char starting-pos) nil)
      (and (not (= (point) starting-pos)) (point-marker)))))

(defun python-nav--lisp-forward-sexp (&optional arg)
  "Standard version `forward-sexp'.
It ignores completely the value of `forward-sexp-function' by
setting it to nil before calling `forward-sexp'.  With positive
ARG move forward only one sexp, else move backwards."
  (let ((forward-sexp-function)
        (arg (if (or (not arg) (> arg 0)) 1 -1)))
    (forward-sexp arg)))

(defun python-nav--lisp-forward-sexp-safe (&optional arg)
  "Safe version of standard `forward-sexp'.
When at end of sexp (i.e. looking at a opening/closing paren)
skips it instead of throwing an error.  With positive ARG move
forward only one sexp, else move backwards."
  (let* ((arg (if (or (not arg) (> arg 0)) 1 -1))
         (paren-regexp
          (if (> arg 0) (python-rx close-paren) (python-rx open-paren)))
         (search-fn
          (if (> arg 0) #'re-search-forward #'re-search-backward)))
    (condition-case nil
        (python-nav--lisp-forward-sexp arg)
      (error
       (while (and (funcall search-fn paren-regexp nil t)
                   (python-syntax-context 'paren)))))))

(defun python-nav--forward-sexp (&optional dir safe)
  "Move to forward sexp.
With positive optional argument DIR direction move forward, else
backwards.  When optional argument SAFE is non-nil do not throw
errors when at end of sexp, skip it instead."
  (setq dir (or dir 1))
  (unless (= dir 0)
    (let* ((forward-p (if (> dir 0)
                          (and (setq dir 1) t)
                        (and (setq dir -1) nil)))
           (context-type (python-syntax-context-type)))
      (cond
       ((memq context-type '(string comment))
        ;; Inside of a string, get out of it.
        (let ((forward-sexp-function))
          (forward-sexp dir)))
       ((or (eq context-type 'paren)
            (and forward-p (looking-at (python-rx open-paren)))
            (and (not forward-p)
                 (eq (syntax-class (syntax-after (1- (point))))
                     (car (string-to-syntax ")")))))
        ;; Inside a paren or looking at it, lisp knows what to do.
        (if safe
            (python-nav--lisp-forward-sexp-safe dir)
          (python-nav--lisp-forward-sexp dir)))
       (t
        ;; This part handles the lispy feel of
        ;; `python-nav-forward-sexp'.  Knowing everything about the
        ;; current context and the context of the next sexp tries to
        ;; follow the lisp sexp motion commands in a symmetric manner.
        (let* ((context
                (cond
                 ((python-info-beginning-of-block-p) 'block-start)
                 ((python-info-end-of-block-p) 'block-end)
                 ((python-info-beginning-of-statement-p) 'statement-start)
                 ((python-info-end-of-statement-p) 'statement-end)))
               (next-sexp-pos
                (save-excursion
                  (if safe
                      (python-nav--lisp-forward-sexp-safe dir)
                    (python-nav--lisp-forward-sexp dir))
                  (point)))
               (next-sexp-context
                (save-excursion
                  (goto-char next-sexp-pos)
                  (cond
                   ((python-info-beginning-of-block-p) 'block-start)
                   ((python-info-end-of-block-p) 'block-end)
                   ((python-info-beginning-of-statement-p) 'statement-start)
                   ((python-info-end-of-statement-p) 'statement-end)
                   ((python-info-statement-starts-block-p) 'starts-block)
                   ((python-info-statement-ends-block-p) 'ends-block)))))
          (if forward-p
              (cond ((and (not (eobp))
                          (python-info-current-line-empty-p))
                     (python-util-forward-comment dir)
                     (python-nav--forward-sexp dir))
                    ((eq context 'block-start)
                     (python-nav-end-of-block))
                    ((eq context 'statement-start)
                     (python-nav-end-of-statement))
                    ((and (memq context '(statement-end block-end))
                          (eq next-sexp-context 'ends-block))
                     (goto-char next-sexp-pos)
                     (python-nav-end-of-block))
                    ((and (memq context '(statement-end block-end))
                          (eq next-sexp-context 'starts-block))
                     (goto-char next-sexp-pos)
                     (python-nav-end-of-block))
                    ((memq context '(statement-end block-end))
                     (goto-char next-sexp-pos)
                     (python-nav-end-of-statement))
                    (t (goto-char next-sexp-pos)))
            (cond ((and (not (bobp))
                        (python-info-current-line-empty-p))
                   (python-util-forward-comment dir)
                   (python-nav--forward-sexp dir))
                  ((eq context 'block-end)
                   (python-nav-beginning-of-block))
                  ((eq context 'statement-end)
                   (python-nav-beginning-of-statement))
                  ((and (memq context '(statement-start block-start))
                        (eq next-sexp-context 'starts-block))
                   (goto-char next-sexp-pos)
                   (python-nav-beginning-of-block))
                  ((and (memq context '(statement-start block-start))
                        (eq next-sexp-context 'ends-block))
                   (goto-char next-sexp-pos)
                   (python-nav-beginning-of-block))
                  ((memq context '(statement-start block-start))
                   (goto-char next-sexp-pos)
                   (python-nav-beginning-of-statement))
                  (t (goto-char next-sexp-pos))))))))))

(defun python-nav-forward-sexp (&optional arg)
  "Move forward across expressions.
With ARG, do it that many times.  Negative arg -N means move
backward N times."
  (interactive "^p")
  (or arg (setq arg 1))
  (while (> arg 0)
    (python-nav--forward-sexp 1)
    (setq arg (1- arg)))
  (while (< arg 0)
    (python-nav--forward-sexp -1)
    (setq arg (1+ arg))))

(defun python-nav-backward-sexp (&optional arg)
  "Move backward across expressions.
With ARG, do it that many times.  Negative arg -N means move
forward N times."
  (interactive "^p")
  (or arg (setq arg 1))
  (python-nav-forward-sexp (- arg)))

(defun python-nav-forward-sexp-safe (&optional arg)
  "Move forward safely across expressions.
With ARG, do it that many times.  Negative arg -N means move
backward N times."
  (interactive "^p")
  (or arg (setq arg 1))
  (while (> arg 0)
    (python-nav--forward-sexp 1 t)
    (setq arg (1- arg)))
  (while (< arg 0)
    (python-nav--forward-sexp -1 t)
    (setq arg (1+ arg))))

(defun python-nav-backward-sexp-safe (&optional arg)
  "Move backward safely across expressions.
With ARG, do it that many times.  Negative arg -N means move
forward N times."
  (interactive "^p")
  (or arg (setq arg 1))
  (python-nav-forward-sexp-safe (- arg)))

(defun python-nav--up-list (&optional dir)
  "Internal implementation of `python-nav-up-list'.
DIR is always 1 or -1 and comes sanitized from
`python-nav-up-list' calls."
  (let ((context (python-syntax-context-type))
        (forward-p (> dir 0)))
    (cond
     ((memq context '(string comment)))
     ((eq context 'paren)
      (let ((forward-sexp-function))
        (up-list dir)))
     ((and forward-p (python-info-end-of-block-p))
      (let ((parent-end-pos
             (save-excursion
               (let ((indentation (and
                                   (python-nav-beginning-of-block)
                                   (current-indentation))))
                 (while (and indentation
                             (> indentation 0)
                             (>= (current-indentation) indentation)
                             (python-nav-backward-block)))
                 (python-nav-end-of-block)))))
        (and (> (or parent-end-pos (point)) (point))
             (goto-char parent-end-pos))))
     (forward-p (python-nav-end-of-block))
     ((and (not forward-p)
           (> (current-indentation) 0)
           (python-info-beginning-of-block-p))
      (let ((prev-block-pos
             (save-excursion
               (let ((indentation (current-indentation)))
                 (while (and (python-nav-backward-block)
                             (>= (current-indentation) indentation))))
               (point))))
        (and (> (point) prev-block-pos)
             (goto-char prev-block-pos))))
     ((not forward-p) (python-nav-beginning-of-block)))))

(defun python-nav-up-list (&optional arg)
  "Move forward out of one level of parentheses (or blocks).
With ARG, do this that many times.
A negative argument means move backward but still to a less deep spot.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (while (> arg 0)
    (python-nav--up-list 1)
    (setq arg (1- arg)))
  (while (< arg 0)
    (python-nav--up-list -1)
    (setq arg (1+ arg))))

(defun python-nav-backward-up-list (&optional arg)
  "Move backward out of one level of parentheses (or blocks).
With ARG, do this that many times.
A negative argument means move forward but still to a less deep spot.
This command assumes point is not in a string or comment."
  (interactive "^p")
  (or arg (setq arg 1))
  (python-nav-up-list (- arg)))

(defun python-nav-if-name-main ()
  "Move point at the beginning the __main__ block.
When \"if __name__ == '__main__':\" is found returns its
position, else returns nil."
  (interactive)
  (let ((point (point))
        (found (catch 'found
                 (goto-char (point-min))
                 (while (re-search-forward
                         (python-rx line-start
                                    "if" (+ space)
                                    "__name__" (+ space)
                                    "==" (+ space)
                                    (group-n 1 (or ?\" ?\'))
                                    "__main__" (backref 1) (* space) ":")
                         nil t)
                   (when (not (python-syntax-context-type))
                     (beginning-of-line)
                     (throw 'found t))))))
    (if found
        (point)
      (ignore (goto-char point)))))


;;; Shell integration

(defcustom python-shell-buffer-name "Python"
  "Default buffer name for Python interpreter."
  :type 'string
  :group 'python
  :safe 'stringp)

(defcustom python-shell-interpreter "python"
  "Default Python interpreter for shell."
  :type 'string
  :group 'python)

(defcustom python-shell-internal-buffer-name "Python Internal"
  "Default buffer name for the Internal Python interpreter."
  :type 'string
  :group 'python
  :safe 'stringp)

(defcustom python-shell-interpreter-args "-i"
  "Default arguments for the Python interpreter."
  :type 'string
  :group 'python)

(defcustom python-shell-interpreter-interactive-arg "-i"
  "Interpreter argument to force it to run interactively."
  :type 'string
  :version "24.4")

(defcustom python-shell-prompt-detect-enabled t
  "Non-nil enables autodetection of interpreter prompts."
  :type 'boolean
  :safe 'booleanp
  :version "24.4")

(defcustom python-shell-prompt-detect-failure-warning t
  "Non-nil enables warnings when detection of prompts fail."
  :type 'boolean
  :safe 'booleanp
  :version "24.4")

(defcustom python-shell-prompt-input-regexps
  '(">>> " "\\.\\.\\. "                 ; Python
    "In \\[[0-9]+\\]: "                 ; IPython
    ;; Using ipdb outside IPython may fail to cleanup and leave static
    ;; IPython prompts activated, this adds some safeguard for that.
    "In : " "\\.\\.\\.: ")
  "List of regular expressions matching input prompts."
  :type '(repeat string)
  :version "24.4")

(defcustom python-shell-prompt-output-regexps
  '(""                                  ; Python
    "Out\\[[0-9]+\\]: "                 ; IPython
    "Out :")                            ; ipdb safeguard
  "List of regular expressions matching output prompts."
  :type '(repeat string)
  :version "24.4")

(defcustom python-shell-prompt-regexp ">>> "
  "Regular expression matching top level input prompt of Python shell.
It should not contain a caret (^) at the beginning."
  :type 'string)

(defcustom python-shell-prompt-block-regexp "\\.\\.\\. "
  "Regular expression matching block input prompt of Python shell.
It should not contain a caret (^) at the beginning."
  :type 'string)

(defcustom python-shell-prompt-output-regexp ""
  "Regular expression matching output prompt of Python shell.
It should not contain a caret (^) at the beginning."
  :type 'string)

(defcustom python-shell-prompt-pdb-regexp "[(<]*[Ii]?[Pp]db[>)]+ "
  "Regular expression matching pdb input prompt of Python shell.
It should not contain a caret (^) at the beginning."
  :type 'string)

(defcustom python-shell-enable-font-lock t
  "Should syntax highlighting be enabled in the Python shell buffer?
Restart the Python shell after changing this variable for it to take effect."
  :type 'boolean
  :group 'python
  :safe 'booleanp)

(defcustom python-shell-process-environment nil
  "List of environment variables for Python shell.
This variable follows the same rules as `process-environment'
since it merges with it before the process creation routines are
called.  When this variable is nil, the Python shell is run with
the default `process-environment'."
  :type '(repeat string)
  :group 'python
  :safe 'listp)

(defcustom python-shell-extra-pythonpaths nil
  "List of extra pythonpaths for Python shell.
The values of this variable are added to the existing value of
PYTHONPATH in the `process-environment' variable."
  :type '(repeat string)
  :group 'python
  :safe 'listp)

(defcustom python-shell-exec-path nil
  "List of path to search for binaries.
This variable follows the same rules as `exec-path' since it
merges with it before the process creation routines are called.
When this variable is nil, the Python shell is run with the
default `exec-path'."
  :type '(repeat string)
  :group 'python
  :safe 'listp)

(defcustom python-shell-virtualenv-path nil
  "Path to virtualenv root.
This variable, when set to a string, makes the values stored in
`python-shell-process-environment' and `python-shell-exec-path'
to be modified properly so shells are started with the specified
virtualenv."
  :type '(choice (const nil) string)
  :group 'python
  :safe 'stringp)

(defcustom python-shell-setup-codes '(python-shell-completion-setup-code
                                      python-ffap-setup-code
                                      python-eldoc-setup-code)
  "List of code run by `python-shell-send-setup-codes'."
  :type '(repeat symbol)
  :group 'python
  :safe 'listp)

(defcustom python-shell-compilation-regexp-alist
  `((,(rx line-start (1+ (any " \t")) "File \""
          (group (1+ (not (any "\"<")))) ; avoid `<stdin>' &c
          "\", line " (group (1+ digit)))
     1 2)
    (,(rx " in file " (group (1+ not-newline)) " on line "
          (group (1+ digit)))
     1 2)
    (,(rx line-start "> " (group (1+ (not (any "(\"<"))))
          "(" (group (1+ digit)) ")" (1+ (not (any "("))) "()")
     1 2))
  "`compilation-error-regexp-alist' for inferior Python."
  :type '(alist string)
  :group 'python)

(defvar python-shell--prompt-calculated-input-regexp nil
  "Calculated input prompt regexp for inferior python shell.
Do not set this variable directly, instead use
`python-shell-prompt-set-calculated-regexps'.")

(defvar python-shell--prompt-calculated-output-regexp nil
  "Calculated output prompt regexp for inferior python shell.
Do not set this variable directly, instead use
`python-shell-set-prompt-regexp'.")

(defun python-shell-prompt-detect ()
  "Detect prompts for the current `python-shell-interpreter'.
When prompts can be retrieved successfully from the
`python-shell-interpreter' run with
`python-shell-interpreter-interactive-arg', returns a list of
three elements, where the first two are input prompts and the
last one is an output prompt.  When no prompts can be detected
and `python-shell-prompt-detect-failure-warning' is non-nil,
shows a warning with instructions to avoid hangs and returns nil.
When `python-shell-prompt-detect-enabled' is nil avoids any
detection and just returns nil."
  (when python-shell-prompt-detect-enabled
    (let* ((process-environment (python-shell-calculate-process-environment))
           (exec-path (python-shell-calculate-exec-path))
           (code (concat
                  "import sys\n"
                  "ps = [getattr(sys, 'ps%s' % i, '') for i in range(1,4)]\n"
                  ;; JSON is built manually for compatibility
                  "ps_json = '\\n[\"%s\", \"%s\", \"%s\"]\\n' % tuple(ps)\n"
                  "print (ps_json)\n"
                  "sys.exit(0)\n"))
           (output
            (with-temp-buffer
              ;; TODO: improve error handling by using
              ;; `condition-case' and displaying the error message to
              ;; the user in the no-prompts warning.
              (ignore-errors
                (let ((code-file (python-shell--save-temp-file code)))
                  ;; Use `process-file' as it is remote-host friendly.
                  (process-file
                   python-shell-interpreter
                   code-file
                   '(t nil)
                   nil
                   python-shell-interpreter-interactive-arg)
                  ;; Try to cleanup
                  (delete-file code-file)))
              (buffer-string)))
           (prompts
            (catch 'prompts
              (dolist (line (split-string output "\n" t))
                (let ((res
                       ;; Check if current line is a valid JSON array
                       (and (string= (substring line 0 2) "[\"")
                            (ignore-errors
                              ;; Return prompts as a list, not vector
                              (append (json-read-from-string line) nil)))))
                  ;; The list must contain 3 strings, where the first
                  ;; is the input prompt, the second is the block
                  ;; prompt and the last one is the output prompt.  The
                  ;; input prompt is the only one that can't be empty.
                  (when (and (= (length res) 3)
                             (cl-every #'stringp res)
                             (not (string= (car res) "")))
                    (throw 'prompts res))))
              nil)))
      (when (and (not prompts)
                 python-shell-prompt-detect-failure-warning)
        (warn
         (concat
          "Python shell prompts cannot be detected.\n"
          "If your emacs session hangs when starting python shells\n"
          "recover with `keyboard-quit' and then try fixing the\n"
          "interactive flag for your interpreter by adjusting the\n"
          "`python-shell-interpreter-interactive-arg' or add regexps\n"
          "matching shell prompts in the directory-local friendly vars:\n"
          "  + `python-shell-prompt-regexp'\n"
          "  + `python-shell-prompt-block-regexp'\n"
          "  + `python-shell-prompt-output-regexp'\n"
          "Or alternatively in:\n"
          "  + `python-shell-prompt-input-regexps'\n"
          "  + `python-shell-prompt-output-regexps'")))
      prompts)))

(defun python-shell-prompt-validate-regexps ()
  "Validate all user provided regexps for prompts.
Signals `user-error' if any of these vars contain invalid
regexps: `python-shell-prompt-regexp',
`python-shell-prompt-block-regexp',
`python-shell-prompt-pdb-regexp',
`python-shell-prompt-output-regexp',
`python-shell-prompt-input-regexps',
`python-shell-prompt-output-regexps'."
  (dolist (symbol (list 'python-shell-prompt-input-regexps
                        'python-shell-prompt-output-regexps
                        'python-shell-prompt-regexp
                        'python-shell-prompt-block-regexp
                        'python-shell-prompt-pdb-regexp
                        'python-shell-prompt-output-regexp))
    (dolist (regexp (let ((regexps (symbol-value symbol)))
                      (if (listp regexps)
                          regexps
                        (list regexps))))
      (when (not (python-util-valid-regexp-p regexp))
        (user-error "Invalid regexp %s in `%s'"
                    regexp symbol)))))

(defun python-shell-prompt-set-calculated-regexps ()
  "Detect and set input and output prompt regexps.
Build and set the values for `python-shell-input-prompt-regexp'
and `python-shell-output-prompt-regexp' using the values from
`python-shell-prompt-regexp', `python-shell-prompt-block-regexp',
`python-shell-prompt-pdb-regexp',
`python-shell-prompt-output-regexp',
`python-shell-prompt-input-regexps',
`python-shell-prompt-output-regexps' and detected prompts from
`python-shell-prompt-detect'."
  (when (not (and python-shell--prompt-calculated-input-regexp
                  python-shell--prompt-calculated-output-regexp))
    (let* ((detected-prompts (python-shell-prompt-detect))
           (input-prompts nil)
           (output-prompts nil)
           (build-regexp
            (lambda (prompts)
              (concat "^\\("
                      (mapconcat #'identity
                                 (sort prompts
                                       (lambda (a b)
                                         (let ((length-a (length a))
                                               (length-b (length b)))
                                           (if (= length-a length-b)
                                               (string< a b)
                                             (> (length a) (length b))))))
                                 "\\|")
                      "\\)"))))
      ;; Validate ALL regexps
      (python-shell-prompt-validate-regexps)
      ;; Collect all user defined input prompts
      (dolist (prompt (append python-shell-prompt-input-regexps
                              (list python-shell-prompt-regexp
                                    python-shell-prompt-block-regexp
                                    python-shell-prompt-pdb-regexp)))
        (cl-pushnew prompt input-prompts :test #'string=))
      ;; Collect all user defined output prompts
      (dolist (prompt (cons python-shell-prompt-output-regexp
                            python-shell-prompt-output-regexps))
        (cl-pushnew prompt output-prompts :test #'string=))
      ;; Collect detected prompts if any
      (when detected-prompts
        (dolist (prompt (butlast detected-prompts))
          (setq prompt (regexp-quote prompt))
          (cl-pushnew prompt input-prompts :test #'string=))
        (cl-pushnew (regexp-quote
                     (car (last detected-prompts)))
                    output-prompts :test #'string=))
      ;; Set input and output prompt regexps from collected prompts
      (setq python-shell--prompt-calculated-input-regexp
            (funcall build-regexp input-prompts)
            python-shell--prompt-calculated-output-regexp
            (funcall build-regexp output-prompts)))))

(defun python-shell-get-process-name (dedicated)
  "Calculate the appropriate process name for inferior Python process.
If DEDICATED is t and the variable `buffer-file-name' is non-nil
returns a string with the form
`python-shell-buffer-name'[variable `buffer-file-name'] else
returns the value of `python-shell-buffer-name'."
  (let ((process-name
         (if (and dedicated
                  buffer-file-name)
             (format "%s[%s]" python-shell-buffer-name buffer-file-name)
           (format "%s" python-shell-buffer-name))))
    process-name))

(defun python-shell-internal-get-process-name ()
  "Calculate the appropriate process name for Internal Python process.
The name is calculated from `python-shell-global-buffer-name' and
a hash of all relevant global shell settings in order to ensure
uniqueness for different types of configurations."
  (format "%s [%s]"
          python-shell-internal-buffer-name
          (md5
           (concat
            python-shell-interpreter
            python-shell-interpreter-args
            python-shell--prompt-calculated-input-regexp
            python-shell--prompt-calculated-output-regexp
            (mapconcat #'symbol-value python-shell-setup-codes "")
            (mapconcat #'identity python-shell-process-environment "")
            (mapconcat #'identity python-shell-extra-pythonpaths "")
            (mapconcat #'identity python-shell-exec-path "")
            (or python-shell-virtualenv-path "")
            (mapconcat #'identity python-shell-exec-path "")))))

(defun python-shell-parse-command ()    ;FIXME: why name it "parse"?
  "Calculate the string used to execute the inferior Python process."
  ;; FIXME: process-environment doesn't seem to be used anywhere within
  ;; this let.
  (let ((process-environment (python-shell-calculate-process-environment))
        (exec-path (python-shell-calculate-exec-path)))
    (format "%s %s"
            ;; FIXME: Why executable-find?
            (executable-find python-shell-interpreter)
            python-shell-interpreter-args)))

(defun python-shell-calculate-process-environment ()
  "Calculate process environment given `python-shell-virtualenv-path'."
  (let ((process-environment (append
                              python-shell-process-environment
                              process-environment nil))
        (virtualenv (if python-shell-virtualenv-path
                        (directory-file-name python-shell-virtualenv-path)
                      nil)))
    (when python-shell-extra-pythonpaths
      (setenv "PYTHONPATH"
              (format "%s%s%s"
                      (mapconcat 'identity
                                 python-shell-extra-pythonpaths
                                 path-separator)
                      path-separator
                      (or (getenv "PYTHONPATH") ""))))
    (if (not virtualenv)
        process-environment
      (setenv "PYTHONHOME" nil)
      (setenv "PATH" (format "%s/bin%s%s"
                             virtualenv path-separator
                             (or (getenv "PATH") "")))
      (setenv "VIRTUAL_ENV" virtualenv))
    process-environment))

(defun python-shell-calculate-exec-path ()
  "Calculate exec path given `python-shell-virtualenv-path'."
  (let ((path (append python-shell-exec-path
                      exec-path nil)))  ;FIXME: Why nil?
    (if (not python-shell-virtualenv-path)
        path
      (cons (expand-file-name "bin" python-shell-virtualenv-path)
            path))))

(defun python-comint-output-filter-function (output)
  "Hook run after content is put into comint buffer.
OUTPUT is a string with the contents of the buffer."
  (ansi-color-filter-apply output))

(defvar python-shell--parent-buffer nil)

(defvar python-shell-output-syntax-table
  (let ((table (make-syntax-table python-dotty-syntax-table)))
    (modify-syntax-entry ?\' "." table)
    (modify-syntax-entry ?\" "." table)
    (modify-syntax-entry ?\( "." table)
    (modify-syntax-entry ?\[ "." table)
    (modify-syntax-entry ?\{ "." table)
    (modify-syntax-entry ?\) "." table)
    (modify-syntax-entry ?\] "." table)
    (modify-syntax-entry ?\} "." table)
    table)
  "Syntax table for shell output.
It makes parens and quotes be treated as punctuation chars.")

(define-derived-mode inferior-python-mode comint-mode "Inferior Python"
  "Major mode for Python inferior process.
Runs a Python interpreter as a subprocess of Emacs, with Python
I/O through an Emacs buffer.  Variables `python-shell-interpreter'
and `python-shell-interpreter-args' control which Python
interpreter is run.  Variables
`python-shell-prompt-regexp',
`python-shell-prompt-output-regexp',
`python-shell-prompt-block-regexp',
`python-shell-enable-font-lock',
`python-shell-completion-setup-code',
`python-shell-completion-string-code',
`python-eldoc-setup-code', `python-eldoc-string-code',
`python-ffap-setup-code' and `python-ffap-string-code' can
customize this mode for different Python interpreters.

You can also add additional setup code to be run at
initialization of the interpreter via `python-shell-setup-codes'
variable.

\(Type \\[describe-mode] in the process buffer for a list of commands.)"
  (let ((interpreter python-shell-interpreter)
        (args python-shell-interpreter-args))
    (when python-shell--parent-buffer
      (python-util-clone-local-variables python-shell--parent-buffer))
    ;; Users can override default values for these vars when calling
    ;; `run-python'.  This ensures new values let-bound in
    ;; `python-shell-make-comint' are locally set.
    (set (make-local-variable 'python-shell-interpreter) interpreter)
    (set (make-local-variable 'python-shell-interpreter-args) args))
  (set (make-local-variable 'python-shell--prompt-calculated-input-regexp) nil)
  (set (make-local-variable 'python-shell--prompt-calculated-output-regexp) nil)
  (python-shell-prompt-set-calculated-regexps)
  (setq comint-prompt-regexp python-shell--prompt-calculated-input-regexp)
  (setq mode-line-process '(":%s"))
  (make-local-variable 'comint-output-filter-functions)
  (add-hook 'comint-output-filter-functions
            'python-comint-output-filter-function)
  (add-hook 'comint-output-filter-functions
            'python-pdbtrack-comint-output-filter-function)
  (set (make-local-variable 'compilation-error-regexp-alist)
       python-shell-compilation-regexp-alist)
  (define-key inferior-python-mode-map [remap complete-symbol]
    'completion-at-point)
  (add-hook 'completion-at-point-functions
            'python-shell-completion-complete-at-point nil 'local)
  (add-to-list (make-local-variable 'comint-dynamic-complete-functions)
               'python-shell-completion-complete-at-point)
  (define-key inferior-python-mode-map "\t"
    'python-shell-completion-complete-or-indent)
  (make-local-variable 'python-pdbtrack-buffers-to-kill)
  (make-local-variable 'python-pdbtrack-tracked-buffer)
  (make-local-variable 'python-shell-internal-last-output)
  (when python-shell-enable-font-lock
    (set-syntax-table python-mode-syntax-table)
    (set (make-local-variable 'font-lock-defaults)
         '(python-font-lock-keywords nil nil nil nil))
    (set (make-local-variable 'syntax-propertize-function)
         (eval
          ;; XXX: Unfortunately eval is needed here to make use of the
          ;; dynamic value of `comint-prompt-regexp'.
          `(syntax-propertize-rules
            (,comint-prompt-regexp
             (0 (ignore
                 (put-text-property
                  comint-last-input-start end 'syntax-table
                  python-shell-output-syntax-table)
                 ;; XXX: This might look weird, but it is the easiest
                 ;; way to ensure font lock gets cleaned up before the
                 ;; current prompt, which is needed for unclosed
                 ;; strings to not mess up with current input.
                 (font-lock-unfontify-region comint-last-input-start end))))
            (,(python-rx string-delimiter)
             (0 (ignore
                 (and (not (eq (get-text-property start 'field) 'output))
                      (python-syntax-stringify)))))))))
  (compilation-shell-minor-mode 1))

(defun python-shell-make-comint (cmd proc-name &optional pop internal)
  "Create a Python shell comint buffer.
CMD is the Python command to be executed and PROC-NAME is the
process name the comint buffer will get.  After the comint buffer
is created the `inferior-python-mode' is activated.  When
optional argument POP is non-nil the buffer is shown.  When
optional argument INTERNAL is non-nil this process is run on a
buffer with a name that starts with a space, following the Emacs
convention for temporary/internal buffers, and also makes sure
the user is not queried for confirmation when the process is
killed."
  (save-excursion
    (let* ((proc-buffer-name
            (format (if (not internal) "*%s*" " *%s*") proc-name))
           (process-environment (python-shell-calculate-process-environment))
           (exec-path (python-shell-calculate-exec-path)))
      (when (not (comint-check-proc proc-buffer-name))
        (let* ((cmdlist (split-string-and-unquote cmd))
               (interpreter (car cmdlist))
               (args (cdr cmdlist))
               (buffer (apply #'make-comint-in-buffer proc-name proc-buffer-name
                              interpreter nil args))
               (python-shell--parent-buffer (current-buffer))
               (process (get-buffer-process buffer))
               ;; As the user may have overridden default values for
               ;; these vars on `run-python', let-binding them allows
               ;; to have the new right values in all setup code
               ;; that's is done in `inferior-python-mode', which is
               ;; important, especially for prompt detection.
               (python-shell-interpreter interpreter)
               (python-shell-interpreter-args
                (mapconcat #'identity args " ")))
          (with-current-buffer buffer
            (inferior-python-mode))
          (accept-process-output process)
          (and pop (pop-to-buffer buffer t))
          (and internal (set-process-query-on-exit-flag process nil))))
      proc-buffer-name)))

;;;###autoload
(defun run-python (cmd &optional dedicated show)
  "Run an inferior Python process.
Input and output via buffer named after
`python-shell-buffer-name'.  If there is a process already
running in that buffer, just switch to it.

With argument, allows you to define CMD so you can edit the
command used to call the interpreter and define DEDICATED, so a
dedicated process for the current buffer is open.  When numeric
prefix arg is other than 0 or 4 do not SHOW.

Runs the hook `inferior-python-mode-hook' after
`comint-mode-hook' is run.  (Type \\[describe-mode] in the
process buffer for a list of commands.)"
  (interactive
   (if current-prefix-arg
       (list
        (read-string "Run Python: " (python-shell-parse-command))
        (y-or-n-p "Make dedicated process? ")
        (= (prefix-numeric-value current-prefix-arg) 4))
     (list (python-shell-parse-command) nil t)))
  (python-shell-make-comint
   cmd (python-shell-get-process-name dedicated) show)
  dedicated)

(defun run-python-internal ()
  "Run an inferior Internal Python process.
Input and output via buffer named after
`python-shell-internal-buffer-name' and what
`python-shell-internal-get-process-name' returns.

This new kind of shell is intended to be used for generic
communication related to defined configurations; the main
difference with global or dedicated shells is that these ones are
attached to a configuration, not a buffer.  This means that can
be used for example to retrieve the sys.path and other stuff,
without messing with user shells.  Note that
`python-shell-enable-font-lock' and `inferior-python-mode-hook'
are set to nil for these shells, so setup codes are not sent at
startup."
  (let ((python-shell-enable-font-lock nil)
        (inferior-python-mode-hook nil))
    (get-buffer-process
     (python-shell-make-comint
      (python-shell-parse-command)
      (python-shell-internal-get-process-name) nil t))))

(defun python-shell-get-buffer ()
  "Return inferior Python buffer for current buffer."
  (let* ((dedicated-proc-name (python-shell-get-process-name t))
         (dedicated-proc-buffer-name (format "*%s*" dedicated-proc-name))
         (global-proc-name  (python-shell-get-process-name nil))
         (global-proc-buffer-name (format "*%s*" global-proc-name))
         (dedicated-running (comint-check-proc dedicated-proc-buffer-name))
         (global-running (comint-check-proc global-proc-buffer-name)))
    ;; Always prefer dedicated
    (or (and dedicated-running dedicated-proc-buffer-name)
        (and global-running global-proc-buffer-name))))

(defun python-shell-get-process ()
  "Return inferior Python process for current buffer."
  (get-buffer-process (python-shell-get-buffer)))

(defun python-shell-get-or-create-process (&optional cmd dedicated show)
  "Get or create an inferior Python process for current buffer and return it.
Arguments CMD, DEDICATED and SHOW are those of `run-python' and
are used to start the shell.  If those arguments are not
provided, `run-python' is called interactively and the user will
be asked for their values."
  (let* ((dedicated-proc-name (python-shell-get-process-name t))
         (dedicated-proc-buffer-name (format "*%s*" dedicated-proc-name))
         (global-proc-name  (python-shell-get-process-name nil))
         (global-proc-buffer-name (format "*%s*" global-proc-name))
         (dedicated-running (comint-check-proc dedicated-proc-buffer-name))
         (global-running (comint-check-proc global-proc-buffer-name))
         (current-prefix-arg 16))
    (when (and (not dedicated-running) (not global-running))
      (if (if (not cmd)
              ;; XXX: Refactor code such that calling `run-python'
              ;; interactively is not needed anymore.
              (call-interactively 'run-python)
            (run-python cmd dedicated show))
          (setq dedicated-running t)
        (setq global-running t)))
    ;; Always prefer dedicated
    (get-buffer-process (if dedicated-running
                            dedicated-proc-buffer-name
                          global-proc-buffer-name))))

(defvar python-shell-internal-buffer nil
  "Current internal shell buffer for the current buffer.
This is really not necessary at all for the code to work but it's
there for compatibility with CEDET.")

(defvar python-shell-internal-last-output nil
  "Last output captured by the internal shell.
This is really not necessary at all for the code to work but it's
there for compatibility with CEDET.")

(defun python-shell-internal-get-or-create-process ()
  "Get or create an inferior Internal Python process."
  (let* ((proc-name (python-shell-internal-get-process-name))
         (proc-buffer-name (format " *%s*" proc-name)))
    (when (not (process-live-p proc-name))
      (run-python-internal)
      (setq python-shell-internal-buffer proc-buffer-name)
      ;; XXX: Why is this `sit-for' needed?
      ;; `python-shell-make-comint' calls `accept-process-output'
      ;; already but it is not helping to get proper output on
      ;; 'gnu/linux when the internal shell process is not running and
      ;; a call to `python-shell-internal-send-string' is issued.
      (sit-for 0.1 t))
    (get-buffer-process proc-buffer-name)))

(define-obsolete-function-alias
  'python-proc 'python-shell-internal-get-or-create-process "24.3")

(define-obsolete-variable-alias
  'python-buffer 'python-shell-internal-buffer "24.3")

(define-obsolete-variable-alias
  'python-preoutput-result 'python-shell-internal-last-output "24.3")

(defun python-shell--save-temp-file (string)
  (let* ((temporary-file-directory
          (if (file-remote-p default-directory)
              (concat (file-remote-p default-directory) "/tmp")
            temporary-file-directory))
         (temp-file-name (make-temp-file "py"))
         (coding-system-for-write 'utf-8))
    (with-temp-file temp-file-name
      (insert "# -*- coding: utf-8 -*-\n") ;Not needed for Python-3.
      (insert string)
      (delete-trailing-whitespace))
    temp-file-name))

(defun python-shell-send-string (string &optional process)
  "Send STRING to inferior Python PROCESS."
  (interactive "sPython command: ")
  (let ((process (or process (python-shell-get-or-create-process))))
    (if (string-match ".\n+." string)   ;Multiline.
        (let* ((temp-file-name (python-shell--save-temp-file string)))
          (python-shell-send-file temp-file-name process temp-file-name t))
      (comint-send-string process string)
      (when (or (not (string-match "\n\\'" string))
                (string-match "\n[ \t].*\n?\\'" string))
        (comint-send-string process "\n")))))

(defvar python-shell-output-filter-in-progress nil)
(defvar python-shell-output-filter-buffer nil)

(defun python-shell-output-filter (string)
  "Filter used in `python-shell-send-string-no-output' to grab output.
STRING is the output received to this point from the process.
This filter saves received output from the process in
`python-shell-output-filter-buffer' and stops receiving it after
detecting a prompt at the end of the buffer."
  (setq
   string (ansi-color-filter-apply string)
   python-shell-output-filter-buffer
   (concat python-shell-output-filter-buffer string))
  (when (string-match
         ;; XXX: It seems on OSX an extra carriage return is attached
         ;; at the end of output, this handles that too.
         (concat
          "\r?\n"
          ;; Remove initial caret from calculated regexp
          (replace-regexp-in-string
           (rx string-start ?^) ""
           python-shell--prompt-calculated-input-regexp)
          "$")
         python-shell-output-filter-buffer)
    ;; Output ends when `python-shell-output-filter-buffer' contains
    ;; the prompt attached at the end of it.
    (setq python-shell-output-filter-in-progress nil
          python-shell-output-filter-buffer
          (substring python-shell-output-filter-buffer
                     0 (match-beginning 0)))
    (when (string-match
           python-shell--prompt-calculated-output-regexp
           python-shell-output-filter-buffer)
      ;; Some shells, like IPython might append a prompt before the
      ;; output, clean that.
      (setq python-shell-output-filter-buffer
            (substring python-shell-output-filter-buffer (match-end 0)))))
  "")

(defun python-shell-send-string-no-output (string &optional process)
  "Send STRING to PROCESS and inhibit output.
Return the output."
  (let ((process (or process (python-shell-get-or-create-process)))
        (comint-preoutput-filter-functions
         '(python-shell-output-filter))
        (python-shell-output-filter-in-progress t)
        (inhibit-quit t))
    (or
     (with-local-quit
       (python-shell-send-string string process)
       (while python-shell-output-filter-in-progress
         ;; `python-shell-output-filter' takes care of setting
         ;; `python-shell-output-filter-in-progress' to NIL after it
         ;; detects end of output.
         (accept-process-output process))
       (prog1
           python-shell-output-filter-buffer
         (setq python-shell-output-filter-buffer nil)))
     (with-current-buffer (process-buffer process)
       (comint-interrupt-subjob)))))

(defun python-shell-internal-send-string (string)
  "Send STRING to the Internal Python interpreter.
Returns the output.  See `python-shell-send-string-no-output'."
  ;; XXX Remove `python-shell-internal-last-output' once CEDET is
  ;; updated to support this new mode.
  (setq python-shell-internal-last-output
        (python-shell-send-string-no-output
         ;; Makes this function compatible with the old
         ;; python-send-receive. (At least for CEDET).
         (replace-regexp-in-string "_emacs_out +" "" string)
         (python-shell-internal-get-or-create-process))))

(define-obsolete-function-alias
  'python-send-receive 'python-shell-internal-send-string "24.3")

(define-obsolete-function-alias
  'python-send-string 'python-shell-internal-send-string "24.3")

(defvar python--use-fake-loc nil
  "If non-nil, use `compilation-fake-loc' to trace errors back to the buffer.
If nil, regions of text are prepended by the corresponding number of empty
lines and Python is told to output error messages referring to the whole
source file.")

(defun python-shell-buffer-substring (start end &optional nomain)
  "Send buffer substring from START to END formatted for shell.
This is a wrapper over `buffer-substring' that takes care of
different transformations for the code sent to be evaluated in
the python shell:
  1. When optional argument NOMAIN is non-nil everything under an
     \"if __name__ == '__main__'\" block will be removed.
  2. When a subregion of the buffer is sent, it takes care of
     appending extra empty lines so tracebacks are correct.
  3. Wraps indented regions under an \"if True:\" block so the
     interpreter evaluates them correctly."
  (let ((substring (buffer-substring-no-properties start end))
        (fillstr (unless python--use-fake-loc
                   (make-string (1- (line-number-at-pos start)) ?\n)))
        (toplevel-block-p (save-excursion
                            (goto-char start)
                            (or (zerop (line-number-at-pos start))
                                (progn
                                  (python-util-forward-comment 1)
                                  (zerop (current-indentation)))))))
    (with-temp-buffer
      (python-mode)
      (if fillstr (insert fillstr))
      (insert substring)
      (goto-char (point-min))
      (unless python--use-fake-loc
        ;; python-shell--save-temp-file adds an extra coding line, which would
        ;; throw off the line-counts, so let's try to compensate here.
        (if (looking-at "[ \t]*[#\n]")
            (delete-region (point) (line-beginning-position 2))))
      (when (not toplevel-block-p)
        (insert "if True:")
        (delete-region (point) (line-end-position)))
      (when nomain
        (let* ((if-name-main-start-end
                (and nomain
                     (save-excursion
                       (when (python-nav-if-name-main)
                         (cons (point)
                               (progn (python-nav-forward-sexp-safe)
                                      (point)))))))
               ;; Oh destructuring bind, how I miss you.
               (if-name-main-start (car if-name-main-start-end))
               (if-name-main-end (cdr if-name-main-start-end)))
          (when if-name-main-start-end
            (goto-char if-name-main-start)
            (delete-region if-name-main-start if-name-main-end)
            (insert
             (make-string
              (- (line-number-at-pos if-name-main-end)
                 (line-number-at-pos if-name-main-start)) ?\n)))))
      (buffer-substring-no-properties (point-min) (point-max)))))

(declare-function compilation-fake-loc "compile"
                  (marker file &optional line col))

(defun python-shell-send-region (start end &optional nomain)
  "Send the region delimited by START and END to inferior Python process."
  (interactive "r")
  (let* ((python--use-fake-loc
          (or python--use-fake-loc (not buffer-file-name)))
         (string (python-shell-buffer-substring start end nomain))
         (process (python-shell-get-or-create-process))
         (_ (string-match "\\`\n*\\(.*\\)" string)))
    (message "Sent: %s..." (match-string 1 string))
    (let* ((temp-file-name (python-shell--save-temp-file string))
           (file-name (or (buffer-file-name) temp-file-name)))
      (python-shell-send-file file-name process temp-file-name t)
      (unless python--use-fake-loc
        (with-current-buffer (process-buffer process)
          (compilation-fake-loc (copy-marker start) temp-file-name
                                2)) ;; Not 1, because of the added coding line.
        ))))

(defun python-shell-send-buffer (&optional arg)
  "Send the entire buffer to inferior Python process.
With prefix ARG allow execution of code inside blocks delimited
by \"if __name__== '__main__':\"."
  (interactive "P")
  (save-restriction
    (widen)
    (python-shell-send-region (point-min) (point-max) (not arg))))

(defun python-shell-send-defun (arg)
  "Send the current defun to inferior Python process.
When argument ARG is non-nil do not include decorators."
  (interactive "P")
  (save-excursion
    (python-shell-send-region
     (progn
       (end-of-line 1)
       (while (and (or (python-nav-beginning-of-defun)
                       (beginning-of-line 1))
                   (> (current-indentation) 0)))
       (when (not arg)
         (while (and (forward-line -1)
                     (looking-at (python-rx decorator))))
         (forward-line 1))
       (point-marker))
     (progn
       (or (python-nav-end-of-defun)
           (end-of-line 1))
       (point-marker)))))

(defun python-shell-send-file (file-name &optional process temp-file-name
                                         delete)
  "Send FILE-NAME to inferior Python PROCESS.
If TEMP-FILE-NAME is passed then that file is used for processing
instead, while internally the shell will continue to use FILE-NAME.
If DELETE is non-nil, delete the file afterwards."
  (interactive "fFile to send: ")
  (let* ((process (or process (python-shell-get-or-create-process)))
         (temp-file-name (when temp-file-name
                           (expand-file-name
                            (or (file-remote-p temp-file-name 'localname)
                                temp-file-name))))
         (file-name (or (when file-name
                          (expand-file-name
                           (or (file-remote-p file-name 'localname)
                               file-name)))
                        temp-file-name)))
    (when (not file-name)
      (error "If FILE-NAME is nil then TEMP-FILE-NAME must be non-nil"))
    (python-shell-send-string
     (format
      (concat "__pyfile = open('''%s''');"
              "exec(compile(__pyfile.read(), '''%s''', 'exec'));"
              "__pyfile.close()%s")
      (or temp-file-name file-name) file-name
      (if delete (format "; import os; os.remove('''%s''')"
                         (or temp-file-name file-name))
        ""))
     process)))

(defun python-shell-switch-to-shell ()
  "Switch to inferior Python process buffer."
  (interactive)
  (pop-to-buffer (process-buffer (python-shell-get-or-create-process)) t))

(defun python-shell-send-setup-code ()
  "Send all setup code for shell.
This function takes the list of setup code to send from the
`python-shell-setup-codes' list."
  (let ((process (get-buffer-process (current-buffer))))
    (dolist (code python-shell-setup-codes)
      (when code
        (message "Sent %s" code)
        (python-shell-send-string
         (symbol-value code) process)))))

(add-hook 'inferior-python-mode-hook
          #'python-shell-send-setup-code)


;;; Shell completion

(defcustom python-shell-completion-setup-code
  "try:
    import readline, rlcompleter
except ImportError:
    def __PYTHON_EL_get_completions(text):
        return []
else:
    def __PYTHON_EL_get_completions(text):
        completions = []
        try:
            splits = text.split()
            is_module = splits and splits[0] in ('from', 'import')
            is_ipython = getattr(
                __builtins__, '__IPYTHON__',
                getattr(__builtins__, '__IPYTHON__active', False))
            if is_module:
                from IPython.core.completerlib import module_completion
                completions = module_completion(text.strip())
            elif is_ipython and getattr(__builtins__, '__IP', None):
                completions = __IP.complete(text)
            elif is_ipython and getattr(__builtins__, 'get_ipython', None):
                completions = get_ipython().Completer.all_completions(text)
            else:
                i = 0
                while True:
                    res = readline.get_completer()(text, i)
                    if not res:
                        break
                    i += 1
                    completions.append(res)
        except:
            pass
        return completions"
  "Code used to setup completion in inferior Python processes."
  :type 'string
  :group 'python)

(defcustom python-shell-completion-string-code
  "';'.join(__PYTHON_EL_get_completions('''%s'''))\n"
  "Python code used to get a string of completions separated by semicolons.
The string passed to the function is the current python name or
the full statement in the case of imports."
  :type 'string
  :group 'python)

(define-obsolete-variable-alias
  'python-shell-completion-module-string-code
  'python-shell-completion-string-code
  "24.4"
  "Completion string code must also autocomplete modules.")

(defcustom python-shell-completion-pdb-string-code
  "';'.join(globals().keys() + locals().keys())"
  "Python code used to get completions separated by semicolons for [i]pdb."
  :type 'string
  :group 'python)

(defun python-shell-completion-get-completions (process line input)
  "Do completion at point for PROCESS.
LINE is used to detect the context on how to complete given INPUT."
  (with-current-buffer (process-buffer process)
    (let* ((prompt
            ;; Get last prompt of the inferior process buffer (this
            ;; intentionally avoids using `comint-last-prompt' because
            ;; of incompatibilities with Emacs 24.x).
            (save-excursion
              (buffer-substring-no-properties
               (line-beginning-position) ;End of prompt.
               (re-search-backward "^"))))
           (completion-code
            ;; Check whether a prompt matches a pdb string, an import
            ;; statement or just the standard prompt and use the
            ;; correct python-shell-completion-*-code string
            (cond ((and (> (length python-shell-completion-pdb-string-code) 0)
                        (string-match
                         (concat "^" python-shell-prompt-pdb-regexp) prompt))
                   python-shell-completion-pdb-string-code)
                  ((string-match
                    python-shell--prompt-calculated-input-regexp prompt)
                   python-shell-completion-string-code)
                  (t nil)))
           (input
            (if (string-match
                 (python-rx line-start (* space) (or "from" "import") space)
                 line)
                line
              input)))
      (and completion-code
           (> (length input) 0)
           (let ((completions
                  (python-util-strip-string
                   (python-shell-send-string-no-output
                    (format completion-code input) process))))
             (and (> (length completions) 2)
                  (split-string completions
                                "^'\\|^\"\\|;\\|'$\\|\"$" t)))))))

(defun python-shell-completion-complete-at-point (&optional process)
  "Perform completion at point in inferior Python.
Optional argument PROCESS forces completions to be retrieved
using that one instead of current buffer's process."
  (setq process (or process (get-buffer-process (current-buffer))))
  (let* ((start
          (save-excursion
            (with-syntax-table python-dotty-syntax-table
              (let* ((paren-depth (car (syntax-ppss)))
                     (syntax-string "w_")
                     (syntax-list (string-to-syntax syntax-string)))
                ;; Stop scanning for the beginning of the completion
                ;; subject after the char before point matches a
                ;; delimiter
                (while (member
                        (car (syntax-after (1- (point)))) syntax-list)
                  (skip-syntax-backward syntax-string)
                  (when (or (equal (char-before) ?\))
                            (equal (char-before) ?\"))
                    (forward-char -1))
                  (while (or
                          ;; honor initial paren depth
                          (> (car (syntax-ppss)) paren-depth)
                          (python-syntax-context 'string))
                    (forward-char -1)))
                (point)))))
         (end (point)))
    (list start end
          (completion-table-dynamic
           (apply-partially
            #'python-shell-completion-get-completions
            process (buffer-substring-no-properties
                     (line-beginning-position) end))))))

(defun python-shell-completion-complete-or-indent ()
  "Complete or indent depending on the context.
If content before pointer is all whitespace, indent.
If not try to complete."
  (interactive)
  (if (string-match "^[[:space:]]*$"
                    (buffer-substring (comint-line-beginning-position)
                                      (point-marker)))
      (indent-for-tab-command)
    (completion-at-point)))


;;; PDB Track integration

(defcustom python-pdbtrack-activate t
  "Non-nil makes Python shell enable pdbtracking."
  :type 'boolean
  :group 'python
  :safe 'booleanp)

(defcustom python-pdbtrack-stacktrace-info-regexp
  "> \\([^\"(<]+\\)(\\([0-9]+\\))\\([?a-zA-Z0-9_<>]+\\)()"
  "Regular expression matching stacktrace information.
Used to extract the current line and module being inspected."
  :type 'string
  :group 'python
  :safe 'stringp)

(defvar python-pdbtrack-tracked-buffer nil
  "Variable containing the value of the current tracked buffer.
Never set this variable directly, use
`python-pdbtrack-set-tracked-buffer' instead.")

(defvar python-pdbtrack-buffers-to-kill nil
  "List of buffers to be deleted after tracking finishes.")

(defun python-pdbtrack-set-tracked-buffer (file-name)
  "Set the buffer for FILE-NAME as the tracked buffer.
Internally it uses the `python-pdbtrack-tracked-buffer' variable.
Returns the tracked buffer."
  (let ((file-buffer (get-file-buffer
                      (concat (file-remote-p default-directory)
                              file-name))))
    (if file-buffer
        (setq python-pdbtrack-tracked-buffer file-buffer)
      (setq file-buffer (find-file-noselect file-name))
      (when (not (member file-buffer python-pdbtrack-buffers-to-kill))
        (add-to-list 'python-pdbtrack-buffers-to-kill file-buffer)))
    file-buffer))

(defun python-pdbtrack-comint-output-filter-function (output)
  "Move overlay arrow to current pdb line in tracked buffer.
Argument OUTPUT is a string with the output from the comint process."
  (when (and python-pdbtrack-activate (not (string= output "")))
    (let* ((full-output (ansi-color-filter-apply
                         (buffer-substring comint-last-input-end (point-max))))
           (line-number)
           (file-name
            (with-temp-buffer
              (insert full-output)
              ;; When the debugger encounters a pdb.set_trace()
              ;; command, it prints a single stack frame.  Sometimes
              ;; it prints a bit of extra information about the
              ;; arguments of the present function.  When ipdb
              ;; encounters an exception, it prints the _entire_ stack
              ;; trace.  To handle all of these cases, we want to find
              ;; the _last_ stack frame printed in the most recent
              ;; batch of output, then jump to the corresponding
              ;; file/line number.
              (goto-char (point-max))
              (when (re-search-backward python-pdbtrack-stacktrace-info-regexp nil t)
                (setq line-number (string-to-number
                                   (match-string-no-properties 2)))
                (match-string-no-properties 1)))))
      (if (and file-name line-number)
          (let* ((tracked-buffer
                  (python-pdbtrack-set-tracked-buffer file-name))
                 (shell-buffer (current-buffer))
                 (tracked-buffer-window (get-buffer-window tracked-buffer))
                 (tracked-buffer-line-pos))
            (with-current-buffer tracked-buffer
              (set (make-local-variable 'overlay-arrow-string) "=>")
              (set (make-local-variable 'overlay-arrow-position) (make-marker))
              (setq tracked-buffer-line-pos (progn
                                              (goto-char (point-min))
                                              (forward-line (1- line-number))
                                              (point-marker)))
              (when tracked-buffer-window
                (set-window-point
                 tracked-buffer-window tracked-buffer-line-pos))
              (set-marker overlay-arrow-position tracked-buffer-line-pos))
            (pop-to-buffer tracked-buffer)
            (switch-to-buffer-other-window shell-buffer))
        (when python-pdbtrack-tracked-buffer
          (with-current-buffer python-pdbtrack-tracked-buffer
            (set-marker overlay-arrow-position nil))
          (mapc #'(lambda (buffer)
                    (ignore-errors (kill-buffer buffer)))
                python-pdbtrack-buffers-to-kill)
          (setq python-pdbtrack-tracked-buffer nil
                python-pdbtrack-buffers-to-kill nil)))))
  output)


;;; Symbol completion

(defun python-completion-complete-at-point ()
  "Complete current symbol at point.
For this to work as best as possible you should call
`python-shell-send-buffer' from time to time so context in
inferior Python process is updated properly."
  (let ((process (python-shell-get-process)))
    (if (not process)
        (error "Completion needs an inferior Python process running")
      (python-shell-completion-complete-at-point process))))

(add-to-list 'debug-ignored-errors
             "^Completion needs an inferior Python process running.")


;;; Fill paragraph

(defcustom python-fill-comment-function 'python-fill-comment
  "Function to fill comments.
This is the function used by `python-fill-paragraph' to
fill comments."
  :type 'symbol
  :group 'python)

(defcustom python-fill-string-function 'python-fill-string
  "Function to fill strings.
This is the function used by `python-fill-paragraph' to
fill strings."
  :type 'symbol
  :group 'python)

(defcustom python-fill-decorator-function 'python-fill-decorator
  "Function to fill decorators.
This is the function used by `python-fill-paragraph' to
fill decorators."
  :type 'symbol
  :group 'python)

(defcustom python-fill-paren-function 'python-fill-paren
  "Function to fill parens.
This is the function used by `python-fill-paragraph' to
fill parens."
  :type 'symbol
  :group 'python)

(defcustom python-fill-docstring-style 'pep-257
  "Style used to fill docstrings.
This affects `python-fill-string' behavior with regards to
triple quotes positioning.

Possible values are `django', `onetwo', `pep-257', `pep-257-nn',
`symmetric', and nil.  A value of nil won't care about quotes
position and will treat docstrings a normal string, any other
value may result in one of the following docstring styles:

`django':

    \"\"\"
    Process foo, return bar.
    \"\"\"

    \"\"\"
    Process foo, return bar.

    If processing fails throw ProcessingError.
    \"\"\"

`onetwo':

    \"\"\"Process foo, return bar.\"\"\"

    \"\"\"
    Process foo, return bar.

    If processing fails throw ProcessingError.

    \"\"\"

`pep-257':

    \"\"\"Process foo, return bar.\"\"\"

    \"\"\"Process foo, return bar.

    If processing fails throw ProcessingError.

    \"\"\"

`pep-257-nn':

    \"\"\"Process foo, return bar.\"\"\"

    \"\"\"Process foo, return bar.

    If processing fails throw ProcessingError.
    \"\"\"

`symmetric':

    \"\"\"Process foo, return bar.\"\"\"

    \"\"\"
    Process foo, return bar.

    If processing fails throw ProcessingError.
    \"\"\""
  :type '(choice
          (const :tag "Don't format docstrings" nil)
          (const :tag "Django's coding standards style." django)
          (const :tag "One newline and start and Two at end style." onetwo)
          (const :tag "PEP-257 with 2 newlines at end of string." pep-257)
          (const :tag "PEP-257 with 1 newline at end of string." pep-257-nn)
          (const :tag "Symmetric style." symmetric))
  :group 'python
  :safe (lambda (val)
          (memq val '(django onetwo pep-257 pep-257-nn symmetric nil))))

(defun python-fill-paragraph (&optional justify)
  "`fill-paragraph-function' handling multi-line strings and possibly comments.
If any of the current line is in or at the end of a multi-line string,
fill the string or the paragraph of it that point is in, preserving
the string's indentation.
Optional argument JUSTIFY defines if the paragraph should be justified."
  (interactive "P")
  (save-excursion
    (cond
     ;; Comments
     ((python-syntax-context 'comment)
      (funcall python-fill-comment-function justify))
     ;; Strings/Docstrings
     ((save-excursion (or (python-syntax-context 'string)
                          (equal (string-to-syntax "|")
                                 (syntax-after (point)))))
      (funcall python-fill-string-function justify))
     ;; Decorators
     ((equal (char-after (save-excursion
                           (python-nav-beginning-of-statement))) ?@)
      (funcall python-fill-decorator-function justify))
     ;; Parens
     ((or (python-syntax-context 'paren)
          (looking-at (python-rx open-paren))
          (save-excursion
            (skip-syntax-forward "^(" (line-end-position))
            (looking-at (python-rx open-paren))))
      (funcall python-fill-paren-function justify))
     (t t))))

(defun python-fill-comment (&optional justify)
  "Comment fill function for `python-fill-paragraph'.
JUSTIFY should be used (if applicable) as in `fill-paragraph'."
  (fill-comment-paragraph justify))

(defun python-fill-string (&optional justify)
  "String fill function for `python-fill-paragraph'.
JUSTIFY should be used (if applicable) as in `fill-paragraph'."
  (let* ((str-start-pos
          (set-marker
           (make-marker)
           (or (python-syntax-context 'string)
               (and (equal (string-to-syntax "|")
                           (syntax-after (point)))
                    (point)))))
         (num-quotes (python-syntax-count-quotes
                      (char-after str-start-pos) str-start-pos))
         (str-end-pos
          (save-excursion
            (goto-char (+ str-start-pos num-quotes))
            (or (re-search-forward (rx (syntax string-delimiter)) nil t)
                (goto-char (point-max)))
            (point-marker)))
         (multi-line-p
          ;; Docstring styles may vary for oneliners and multi-liners.
          (> (count-matches "\n" str-start-pos str-end-pos) 0))
         (delimiters-style
          (pcase python-fill-docstring-style
            ;; delimiters-style is a cons cell with the form
            ;; (START-NEWLINES .  END-NEWLINES). When any of the sexps
            ;; is NIL means to not add any newlines for start or end
            ;; of docstring.  See `python-fill-docstring-style' for a
            ;; graphic idea of each style.
            (`django (cons 1 1))
            (`onetwo (and multi-line-p (cons 1 2)))
            (`pep-257 (and multi-line-p (cons nil 2)))
            (`pep-257-nn (and multi-line-p (cons nil 1)))
            (`symmetric (and multi-line-p (cons 1 1)))))
         (docstring-p (save-excursion
                        ;; Consider docstrings those strings which
                        ;; start on a line by themselves.
                        (python-nav-beginning-of-statement)
                        (and (= (point) str-start-pos))))
         (fill-paragraph-function))
    (save-restriction
      (narrow-to-region str-start-pos str-end-pos)
      (fill-paragraph justify))
    (save-excursion
      (when (and docstring-p python-fill-docstring-style)
        ;; Add the number of newlines indicated by the selected style
        ;; at the start of the docstring.
        (goto-char (+ str-start-pos num-quotes))
        (delete-region (point) (progn
                                 (skip-syntax-forward "> ")
                                 (point)))
        (and (car delimiters-style)
             (or (newline (car delimiters-style)) t)
             ;; Indent only if a newline is added.
             (indent-according-to-mode))
        ;; Add the number of newlines indicated by the selected style
        ;; at the end of the docstring.
        (goto-char (if (not (= str-end-pos (point-max)))
                       (- str-end-pos num-quotes)
                     str-end-pos))
        (delete-region (point) (progn
                                 (skip-syntax-backward "> ")
                                 (point)))
        (and (cdr delimiters-style)
             ;; Add newlines only if string ends.
             (not (= str-end-pos (point-max)))
             (or (newline (cdr delimiters-style)) t)
             ;; Again indent only if a newline is added.
             (indent-according-to-mode))))) t)

(defun python-fill-decorator (&optional _justify)
  "Decorator fill function for `python-fill-paragraph'.
JUSTIFY should be used (if applicable) as in `fill-paragraph'."
  t)

(defun python-fill-paren (&optional justify)
  "Paren fill function for `python-fill-paragraph'.
JUSTIFY should be used (if applicable) as in `fill-paragraph'."
  (save-restriction
    (narrow-to-region (progn
                        (while (python-syntax-context 'paren)
                          (goto-char (1- (point-marker))))
                        (point-marker)
                        (line-beginning-position))
                      (progn
                        (when (not (python-syntax-context 'paren))
                          (end-of-line)
                          (when (not (python-syntax-context 'paren))
                            (skip-syntax-backward "^)")))
                        (while (and (python-syntax-context 'paren)
                                    (not (eobp)))
                          (goto-char (1+ (point-marker))))
                        (point-marker)))
    (let ((paragraph-start "\f\\|[ \t]*$")
          (paragraph-separate ",")
          (fill-paragraph-function))
      (goto-char (point-min))
      (fill-paragraph justify))
    (while (not (eobp))
      (forward-line 1)
      (python-indent-line)
      (goto-char (line-end-position))))
  t)


;;; Skeletons

(defcustom python-skeleton-autoinsert nil
  "Non-nil means template skeletons will be automagically inserted.
This happens when pressing \"if<SPACE>\", for example, to prompt for
the if condition."
  :type 'boolean
  :group 'python
  :safe 'booleanp)

(define-obsolete-variable-alias
  'python-use-skeletons 'python-skeleton-autoinsert "24.3")

(defvar python-skeleton-available '()
  "Internal list of available skeletons.")

(define-abbrev-table 'python-mode-skeleton-abbrev-table ()
  "Abbrev table for Python mode skeletons."
  :case-fixed t
  ;; Allow / inside abbrevs.
  :regexp "\\(?:^\\|[^/]\\)\\<\\([[:word:]/]+\\)\\W*"
  ;; Only expand in code.
  :enable-function (lambda ()
                     (and
                      (not (python-syntax-comment-or-string-p))
                      python-skeleton-autoinsert)))

(defmacro python-skeleton-define (name doc &rest skel)
  "Define a `python-mode' skeleton using NAME DOC and SKEL.
The skeleton will be bound to python-skeleton-NAME and will
be added to `python-mode-skeleton-abbrev-table'."
  (declare (indent 2))
  (let* ((name (symbol-name name))
         (function-name (intern (concat "python-skeleton-" name))))
    `(progn
       (define-abbrev python-mode-skeleton-abbrev-table
         ,name "" ',function-name :system t)
       (setq python-skeleton-available
             (cons ',function-name python-skeleton-available))
       (define-skeleton ,function-name
         ,(or doc
              (format "Insert %s statement." name))
         ,@skel))))

(define-abbrev-table 'python-mode-abbrev-table ()
  "Abbrev table for Python mode."
  :parents (list python-mode-skeleton-abbrev-table))

(defmacro python-define-auxiliary-skeleton (name doc &optional &rest skel)
  "Define a `python-mode' auxiliary skeleton using NAME DOC and SKEL.
The skeleton will be bound to python-skeleton-NAME."
  (declare (indent 2))
  (let* ((name (symbol-name name))
         (function-name (intern (concat "python-skeleton--" name)))
         (msg (format
               "Add '%s' clause? " name)))
    (when (not skel)
      (setq skel
            `(< ,(format "%s:" name) \n \n
                > _ \n)))
    `(define-skeleton ,function-name
       ,(or doc
            (format "Auxiliary skeleton for %s statement." name))
       nil
       (unless (y-or-n-p ,msg)
         (signal 'quit t))
       ,@skel)))

(python-define-auxiliary-skeleton else nil)

(python-define-auxiliary-skeleton except nil)

(python-define-auxiliary-skeleton finally nil)

(python-skeleton-define if nil
  "Condition: "
  "if " str ":" \n
  _ \n
  ("other condition, %s: "
   <
   "elif " str ":" \n
   > _ \n nil)
  '(python-skeleton--else) | ^)

(python-skeleton-define while nil
  "Condition: "
  "while " str ":" \n
  > _ \n
  '(python-skeleton--else) | ^)

(python-skeleton-define for nil
  "Iteration spec: "
  "for " str ":" \n
  > _ \n
  '(python-skeleton--else) | ^)

(python-skeleton-define try nil
  nil
  "try:" \n
  > _ \n
  ("Exception, %s: "
   <
   "except " str ":" \n
   > _ \n nil)
  resume:
  '(python-skeleton--except)
  '(python-skeleton--else)
  '(python-skeleton--finally) | ^)

(python-skeleton-define def nil
  "Function name: "
  "def " str "(" ("Parameter, %s: "
                  (unless (equal ?\( (char-before)) ", ")
                  str) "):" \n
                  "\"\"\"" - "\"\"\"" \n
                  > _ \n)

(python-skeleton-define class nil
  "Class name: "
  "class " str "(" ("Inheritance, %s: "
                    (unless (equal ?\( (char-before)) ", ")
                    str)
  & ")" | -2
  ":" \n
  "\"\"\"" - "\"\"\"" \n
  > _ \n)

(defun python-skeleton-add-menu-items ()
  "Add menu items to Python->Skeletons menu."
  (let ((skeletons (sort python-skeleton-available 'string<)))
    (dolist (skeleton skeletons)
      (easy-menu-add-item
       nil '("Python" "Skeletons")
       `[,(format
           "Insert %s" (nth 2 (split-string (symbol-name skeleton) "-")))
         ,skeleton t]))))

;;; FFAP

(defcustom python-ffap-setup-code
  "def __FFAP_get_module_path(module):
    try:
        import os
        path = __import__(module).__file__
        if path[-4:] == '.pyc' and os.path.exists(path[0:-1]):
            path = path[:-1]
        return path
    except:
        return ''"
  "Python code to get a module path."
  :type 'string
  :group 'python)

(defcustom python-ffap-string-code
  "__FFAP_get_module_path('''%s''')\n"
  "Python code used to get a string with the path of a module."
  :type 'string
  :group 'python)

(defun python-ffap-module-path (module)
  "Function for `ffap-alist' to return path for MODULE."
  (let ((process (or
                  (and (eq major-mode 'inferior-python-mode)
                       (get-buffer-process (current-buffer)))
                  (python-shell-get-process))))
    (if (not process)
        nil
      (let ((module-file
             (python-shell-send-string-no-output
              (format python-ffap-string-code module) process)))
        (when module-file
          (substring-no-properties module-file 1 -1))))))

(defvar ffap-alist)

(eval-after-load "ffap"
  '(progn
     (push '(python-mode . python-ffap-module-path) ffap-alist)
     (push '(inferior-python-mode . python-ffap-module-path) ffap-alist)))


;;; Code check

(defcustom python-check-command
  "pyflakes"
  "Command used to check a Python file."
  :type 'string
  :group 'python)

(defcustom python-check-buffer-name
  "*Python check: %s*"
  "Buffer name used for check commands."
  :type 'string
  :group 'python)

(defvar python-check-custom-command nil
  "Internal use.")

(defun python-check (command)
  "Check a Python file (default current buffer's file).
Runs COMMAND, a shell command, as if by `compile'.
See `python-check-command' for the default."
  (interactive
   (list (read-string "Check command: "
                      (or python-check-custom-command
                          (concat python-check-command " "
                                  (shell-quote-argument
                                   (or
                                    (let ((name (buffer-file-name)))
                                      (and name
                                           (file-name-nondirectory name)))
                                    "")))))))
  (setq python-check-custom-command command)
  (save-some-buffers (not compilation-ask-about-save) nil)
  (let ((process-environment (python-shell-calculate-process-environment))
        (exec-path (python-shell-calculate-exec-path)))
    (compilation-start command nil
                       (lambda (_modename)
                         (format python-check-buffer-name command)))))


;;; Eldoc

(defcustom python-eldoc-setup-code
  "def __PYDOC_get_help(obj):
    try:
        import inspect
        if hasattr(obj, 'startswith'):
            obj = eval(obj, globals())
        doc = inspect.getdoc(obj)
        if not doc and callable(obj):
            target = None
            if inspect.isclass(obj) and hasattr(obj, '__init__'):
                target = obj.__init__
                objtype = 'class'
            else:
                target = obj
                objtype = 'def'
            if target:
                args = inspect.formatargspec(
                    *inspect.getargspec(target)
                )
                name = obj.__name__
                doc = '{objtype} {name}{args}'.format(
                    objtype=objtype, name=name, args=args
                )
        else:
            doc = doc.splitlines()[0]
    except:
        doc = ''
    try:
        exec('print doc')
    except SyntaxError:
        print(doc)"
  "Python code to setup documentation retrieval."
  :type 'string
  :group 'python)

(defcustom python-eldoc-string-code
  "__PYDOC_get_help('''%s''')\n"
  "Python code used to get a string with the documentation of an object."
  :type 'string
  :group 'python)

(defun python-eldoc--get-doc-at-point (&optional force-input force-process)
  "Internal implementation to get documentation at point.
If not FORCE-INPUT is passed then what `python-info-current-symbol'
returns will be used.  If not FORCE-PROCESS is passed what
`python-shell-get-process' returns is used."
  (let ((process (or force-process (python-shell-get-process))))
    (if (not process)
        (error "Eldoc needs an inferior Python process running")
      (let ((input (or force-input
                       (python-info-current-symbol t))))
        (and input
             (python-shell-send-string-no-output
              (format python-eldoc-string-code input)
              process))))))

(defun python-eldoc-function ()
  "`eldoc-documentation-function' for Python.
For this to work as best as possible you should call
`python-shell-send-buffer' from time to time so context in
inferior Python process is updated properly."
  (python-eldoc--get-doc-at-point))

(defun python-eldoc-at-point (symbol)
  "Get help on SYMBOL using `help'.
Interactively, prompt for symbol."
  (interactive
   (let ((symbol (python-info-current-symbol t))
         (enable-recursive-minibuffers t))
     (list (read-string (if symbol
                            (format "Describe symbol (default %s): " symbol)
                          "Describe symbol: ")
                        nil nil symbol))))
  (message (python-eldoc--get-doc-at-point symbol)))

(add-to-list 'debug-ignored-errors
             "^Eldoc needs an inferior Python process running.")


;;; Imenu

(defvar python-imenu-format-item-label-function
  'python-imenu-format-item-label
  "Imenu function used to format an item label.
It must be a function with two arguments: TYPE and NAME.")

(defvar python-imenu-format-parent-item-label-function
  'python-imenu-format-parent-item-label
  "Imenu function used to format a parent item label.
It must be a function with two arguments: TYPE and NAME.")

(defvar python-imenu-format-parent-item-jump-label-function
  'python-imenu-format-parent-item-jump-label
  "Imenu function used to format a parent jump item label.
It must be a function with two arguments: TYPE and NAME.")

(defun python-imenu-format-item-label (type name)
  "Return Imenu label for single node using TYPE and NAME."
  (format "%s (%s)" name type))

(defun python-imenu-format-parent-item-label (type name)
  "Return Imenu label for parent node using TYPE and NAME."
  (format "%s..." (python-imenu-format-item-label type name)))

(defun python-imenu-format-parent-item-jump-label (type _name)
  "Return Imenu label for parent node jump using TYPE and NAME."
  (if (string= type "class")
      "*class definition*"
    "*function definition*"))

(defun python-imenu--put-parent (type name pos tree)
  "Add the parent with TYPE, NAME and POS to TREE."
  (let ((label
         (funcall python-imenu-format-item-label-function type name))
        (jump-label
         (funcall python-imenu-format-parent-item-jump-label-function type name)))
    (if (not tree)
        (cons label pos)
      (cons label (cons (cons jump-label pos) tree)))))

(defun python-imenu--build-tree (&optional min-indent prev-indent tree)
  "Recursively build the tree of nested definitions of a node.
Arguments MIN-INDENT, PREV-INDENT and TREE are internal and should
not be passed explicitly unless you know what you are doing."
  (setq min-indent (or min-indent 0)
        prev-indent (or prev-indent python-indent-offset))
  (let* ((pos (python-nav-backward-defun))
         (type)
         (name (when (and pos (looking-at python-nav-beginning-of-defun-regexp))
                 (let ((split (split-string (match-string-no-properties 0))))
                   (setq type (car split))
                   (cadr split))))
         (label (when name
                  (funcall python-imenu-format-item-label-function type name)))
         (indent (current-indentation))
         (children-indent-limit (+ python-indent-offset min-indent)))
    (cond ((not pos)
           ;; Nothing found, probably near to bobp.
           nil)
          ((<= indent min-indent)
           ;; The current indentation points that this is a parent
           ;; node, add it to the tree and stop recursing.
           (python-imenu--put-parent type name pos tree))
          (t
           (python-imenu--build-tree
            min-indent
            indent
            (if (<= indent children-indent-limit)
                ;; This lies within the children indent offset range,
                ;; so it's a normal child of its parent (i.e., not
                ;; a child of a child).
                (cons (cons label pos) tree)
              ;; Oh no, a child of a child?!  Fear not, we
              ;; know how to roll.  We recursively parse these by
              ;; swapping prev-indent and min-indent plus adding this
              ;; newly found item to a fresh subtree.  This works, I
              ;; promise.
              (cons
               (python-imenu--build-tree
                prev-indent indent (list (cons label pos)))
               tree)))))))

(defun python-imenu-create-index ()
  "Return tree Imenu alist for the current Python buffer.
Change `python-imenu-format-item-label-function',
`python-imenu-format-parent-item-label-function',
`python-imenu-format-parent-item-jump-label-function' to
customize how labels are formatted."
  (goto-char (point-max))
  (let ((index)
        (tree))
    (while (setq tree (python-imenu--build-tree))
      (setq index (cons tree index)))
    index))

(defun python-imenu-create-flat-index (&optional alist prefix)
  "Return flat outline of the current Python buffer for Imenu.
Optional argument ALIST is the tree to be flattened; when nil
`python-imenu-build-index' is used with
`python-imenu-format-parent-item-jump-label-function'
`python-imenu-format-parent-item-label-function'
`python-imenu-format-item-label-function' set to
  (lambda (type name) name)
Optional argument PREFIX is used in recursive calls and should
not be passed explicitly.

Converts this:

    ((\"Foo\" . 103)
     (\"Bar\" . 138)
     (\"decorator\"
      (\"decorator\" . 173)
      (\"wrap\"
       (\"wrap\" . 353)
       (\"wrapped_f\" . 393))))

To this:

    ((\"Foo\" . 103)
     (\"Bar\" . 138)
     (\"decorator\" . 173)
     (\"decorator.wrap\" . 353)
     (\"decorator.wrapped_f\" . 393))"
  ;; Inspired by imenu--flatten-index-alist removed in revno 21853.
  (apply
   'nconc
   (mapcar
    (lambda (item)
      (let ((name (if prefix
                      (concat prefix "." (car item))
                    (car item)))
            (pos (cdr item)))
        (cond ((or (numberp pos) (markerp pos))
               (list (cons name pos)))
              ((listp pos)
               (cons
                (cons name (cdar pos))
                (python-imenu-create-flat-index (cddr item) name))))))
    (or alist
        (let* ((fn (lambda (_type name) name))
               (python-imenu-format-item-label-function fn)
              (python-imenu-format-parent-item-label-function fn)
              (python-imenu-format-parent-item-jump-label-function fn))
          (python-imenu-create-index))))))


;;; Misc helpers

(defun python-info-current-defun (&optional include-type)
  "Return name of surrounding function with Python compatible dotty syntax.
Optional argument INCLUDE-TYPE indicates to include the type of the defun.
This function can be used as the value of `add-log-current-defun-function'
since it returns nil if point is not inside a defun."
  (save-restriction
    (widen)
    (save-excursion
      (end-of-line 1)
      (let ((names)
            (starting-indentation (current-indentation))
            (starting-pos (point))
            (first-run t)
            (last-indent)
            (type))
        (catch 'exit
          (while (python-nav-beginning-of-defun 1)
            (when (save-match-data
                    (and
                     (or (not last-indent)
                         (< (current-indentation) last-indent))
                     (or
                      (and first-run
                           (save-excursion
                             ;; If this is the first run, we may add
                             ;; the current defun at point.
                             (setq first-run nil)
                             (goto-char starting-pos)
                             (python-nav-beginning-of-statement)
                             (beginning-of-line 1)
                             (looking-at-p
                              python-nav-beginning-of-defun-regexp)))
                      (< starting-pos
                         (save-excursion
                           (let ((min-indent
                                  (+ (current-indentation)
                                     python-indent-offset)))
                             (if (< starting-indentation  min-indent)
                                 ;; If the starting indentation is not
                                 ;; within the min defun indent make the
                                 ;; check fail.
                                 starting-pos
                               ;; Else go to the end of defun and add
                               ;; up the current indentation to the
                               ;; ending position.
                               (python-nav-end-of-defun)
                               (+ (point)
                                  (if (>= (current-indentation) min-indent)
                                      (1+ (current-indentation))
                                    0)))))))))
              (save-match-data (setq last-indent (current-indentation)))
              (if (or (not include-type) type)
                  (setq names (cons (match-string-no-properties 1) names))
                (let ((match (split-string (match-string-no-properties 0))))
                  (setq type (car match))
                  (setq names (cons (cadr match) names)))))
            ;; Stop searching ASAP.
            (and (= (current-indentation) 0) (throw 'exit t))))
        (and names
             (concat (and type (format "%s " type))
                     (mapconcat 'identity names ".")))))))

(defun python-info-current-symbol (&optional replace-self)
  "Return current symbol using dotty syntax.
With optional argument REPLACE-SELF convert \"self\" to current
parent defun name."
  (let ((name
         (and (not (python-syntax-comment-or-string-p))
              (with-syntax-table python-dotty-syntax-table
                (let ((sym (symbol-at-point)))
                  (and sym
                       (substring-no-properties (symbol-name sym))))))))
    (when name
      (if (not replace-self)
          name
        (let ((current-defun (python-info-current-defun)))
          (if (not current-defun)
              name
            (replace-regexp-in-string
             (python-rx line-start word-start "self" word-end ?.)
             (concat
              (mapconcat 'identity
                         (butlast (split-string current-defun "\\."))
                         ".") ".")
             name)))))))

(defun python-info-statement-starts-block-p ()
  "Return non-nil if current statement opens a block."
  (save-excursion
    (python-nav-beginning-of-statement)
    (looking-at (python-rx block-start))))

(defun python-info-statement-ends-block-p ()
  "Return non-nil if point is at end of block."
  (let ((end-of-block-pos (save-excursion
                            (python-nav-end-of-block)))
        (end-of-statement-pos (save-excursion
                                (python-nav-end-of-statement))))
    (and end-of-block-pos end-of-statement-pos
         (= end-of-block-pos end-of-statement-pos))))

(defun python-info-beginning-of-statement-p ()
  "Return non-nil if point is at beginning of statement."
  (= (point) (save-excursion
               (python-nav-beginning-of-statement)
               (point))))

(defun python-info-end-of-statement-p ()
  "Return non-nil if point is at end of statement."
  (= (point) (save-excursion
               (python-nav-end-of-statement)
               (point))))

(defun python-info-beginning-of-block-p ()
  "Return non-nil if point is at beginning of block."
  (and (python-info-beginning-of-statement-p)
       (python-info-statement-starts-block-p)))

(defun python-info-end-of-block-p ()
  "Return non-nil if point is at end of block."
  (and (python-info-end-of-statement-p)
       (python-info-statement-ends-block-p)))

(define-obsolete-function-alias
  'python-info-closing-block
  'python-info-dedenter-opening-block-position "24.4")

(defun python-info-dedenter-opening-block-position ()
  "Return the point of the closest block the current line closes.
Returns nil if point is not on a dedenter statement or no opening
block can be detected.  The latter case meaning current file is
likely an invalid python file."
  (let ((positions (python-info-dedenter-opening-block-positions))
        (indentation (current-indentation))
        (position))
    (while (and (not position)
                positions)
      (save-excursion
        (goto-char (car positions))
        (if (<= (current-indentation) indentation)
            (setq position (car positions))
          (setq positions (cdr positions)))))
    position))

(defun python-info-dedenter-opening-block-positions ()
  "Return points of blocks the current line may close sorted by closer.
Returns nil if point is not on a dedenter statement or no opening
block can be detected.  The latter case meaning current file is
likely an invalid python file."
  (save-excursion
    (let ((dedenter-pos (python-info-dedenter-statement-p)))
      (when dedenter-pos
        (goto-char dedenter-pos)
        (let* ((pairs '(("elif" "elif" "if")
                        ("else" "if" "elif" "except" "for" "while")
                        ("except" "except" "try")
                        ("finally" "else" "except" "try")))
               (dedenter (match-string-no-properties 0))
               (possible-opening-blocks (cdr (assoc-string dedenter pairs)))
               (collected-indentations)
               (opening-blocks))
          (catch 'exit
            (while (python-nav--syntactically
                    (lambda ()
                      (re-search-backward (python-rx block-start) nil t))
                    #'<)
              (let ((indentation (current-indentation)))
                (when (and (not (memq indentation collected-indentations))
                           (or (not collected-indentations)
                               (< indentation (apply #'min collected-indentations))))
                  (setq collected-indentations
                        (cons indentation collected-indentations))
                  (when (member (match-string-no-properties 0)
                                possible-opening-blocks)
                    (setq opening-blocks (cons (point) opening-blocks))))
                (when (zerop indentation)
                  (throw 'exit nil)))))
          ;; sort by closer
          (nreverse opening-blocks))))))

(define-obsolete-function-alias
  'python-info-closing-block-message
  'python-info-dedenter-opening-block-message "24.4")

(defun python-info-dedenter-opening-block-message  ()
  "Message the first line of the block the current statement closes."
  (let ((point (python-info-dedenter-opening-block-position)))
    (when point
      (save-restriction
        (widen)
        (message "Closes %s" (save-excursion
                               (goto-char point)
                               (buffer-substring
                                (point) (line-end-position))))))))

(defun python-info-dedenter-statement-p ()
  "Return point if current statement is a dedenter.
Sets `match-data' to the keyword that starts the dedenter
statement."
  (save-excursion
    (python-nav-beginning-of-statement)
    (when (and (not (python-syntax-context-type))
               (looking-at (python-rx dedenter)))
      (point))))

(defun python-info-line-ends-backslash-p (&optional line-number)
  "Return non-nil if current line ends with backslash.
With optional argument LINE-NUMBER, check that line instead."
  (save-excursion
    (save-restriction
      (widen)
      (when line-number
        (python-util-goto-line line-number))
      (while (and (not (eobp))
                  (goto-char (line-end-position))
                  (python-syntax-context 'paren)
                  (not (equal (char-before (point)) ?\\)))
        (forward-line 1))
      (when (equal (char-before) ?\\)
        (point-marker)))))

(defun python-info-beginning-of-backslash (&optional line-number)
  "Return the point where the backslashed line start.
Optional argument LINE-NUMBER forces the line number to check against."
  (save-excursion
    (save-restriction
      (widen)
      (when line-number
        (python-util-goto-line line-number))
      (when (python-info-line-ends-backslash-p)
        (while (save-excursion
                 (goto-char (line-beginning-position))
                 (python-syntax-context 'paren))
          (forward-line -1))
        (back-to-indentation)
        (point-marker)))))

(defun python-info-continuation-line-p ()
  "Check if current line is continuation of another.
When current line is continuation of another return the point
where the continued line ends."
  (save-excursion
    (save-restriction
      (widen)
      (let* ((context-type (progn
                             (back-to-indentation)
                             (python-syntax-context-type)))
             (line-start (line-number-at-pos))
             (context-start (when context-type
                              (python-syntax-context context-type))))
        (cond ((equal context-type 'paren)
               ;; Lines inside a paren are always a continuation line
               ;; (except the first one).
               (python-util-forward-comment -1)
               (point-marker))
              ((member context-type '(string comment))
               ;; move forward an roll again
               (goto-char context-start)
               (python-util-forward-comment)
               (python-info-continuation-line-p))
              (t
               ;; Not within a paren, string or comment, the only way
               ;; we are dealing with a continuation line is that
               ;; previous line contains a backslash, and this can
               ;; only be the previous line from current
               (back-to-indentation)
               (python-util-forward-comment -1)
               (when (and (equal (1- line-start) (line-number-at-pos))
                          (python-info-line-ends-backslash-p))
                 (point-marker))))))))

(defun python-info-block-continuation-line-p ()
  "Return non-nil if current line is a continuation of a block."
  (save-excursion
    (when (python-info-continuation-line-p)
      (forward-line -1)
      (back-to-indentation)
      (when (looking-at (python-rx block-start))
        (point-marker)))))

(defun python-info-assignment-continuation-line-p ()
  "Check if current line is a continuation of an assignment.
When current line is continuation of another with an assignment
return the point of the first non-blank character after the
operator."
  (save-excursion
    (when (python-info-continuation-line-p)
      (forward-line -1)
      (back-to-indentation)
      (when (and (not (looking-at (python-rx block-start)))
                 (and (re-search-forward (python-rx not-simple-operator
                                                    assignment-operator
                                                    not-simple-operator)
                                         (line-end-position) t)
                      (not (python-syntax-context-type))))
        (skip-syntax-forward "\s")
        (point-marker)))))

(defun python-info-looking-at-beginning-of-defun (&optional syntax-ppss)
  "Check if point is at `beginning-of-defun' using SYNTAX-PPSS."
  (and (not (python-syntax-context-type (or syntax-ppss (syntax-ppss))))
       (save-excursion
         (beginning-of-line 1)
         (looking-at python-nav-beginning-of-defun-regexp))))

(defun python-info-current-line-comment-p ()
  "Return non-nil if current line is a comment line."
  (char-equal
   (or (char-after (+ (line-beginning-position) (current-indentation))) ?_)
   ?#))

(defun python-info-current-line-empty-p ()
  "Return non-nil if current line is empty, ignoring whitespace."
  (save-excursion
    (beginning-of-line 1)
    (looking-at
     (python-rx line-start (* whitespace)
                (group (* not-newline))
                (* whitespace) line-end))
    (string-equal "" (match-string-no-properties 1))))


;;; Utility functions

(defun python-util-goto-line (line-number)
  "Move point to LINE-NUMBER."
  (goto-char (point-min))
  (forward-line (1- line-number)))

;; Stolen from org-mode
(defun python-util-clone-local-variables (from-buffer &optional regexp)
  "Clone local variables from FROM-BUFFER.
Optional argument REGEXP selects variables to clone and defaults
to \"^python-\"."
  (mapc
   (lambda (pair)
     (and (symbolp (car pair))
          (string-match (or regexp "^python-")
                        (symbol-name (car pair)))
          (set (make-local-variable (car pair))
               (cdr pair))))
   (buffer-local-variables from-buffer)))

(defun python-util-forward-comment (&optional direction)
  "Python mode specific version of `forward-comment'.
Optional argument DIRECTION defines the direction to move to."
  (let ((comment-start (python-syntax-context 'comment))
        (factor (if (< (or direction 0) 0)
                    -99999
                  99999)))
    (when comment-start
      (goto-char comment-start))
    (forward-comment factor)))

(defun python-util-popn (lst n)
  "Return LST first N elements.
N should be an integer, when negative its opposite is used.
When N is bigger than the length of LST, the list is
returned as is."
  (let* ((n (min (abs n)))
         (len (length lst))
         (acc))
    (if (> n len)
        lst
      (while (< 0 n)
        (setq acc (cons (car lst) acc)
              lst (cdr lst)
              n (1- n)))
      (reverse acc))))

(defun python-util-strip-string (string)
  "Strip STRING whitespace and newlines from end and beginning."
  (replace-regexp-in-string
   (rx (or (: string-start (* (any whitespace ?\r ?\n)))
           (: (* (any whitespace ?\r ?\n)) string-end)))
   ""
   string))

(defun python-util-valid-regexp-p (regexp)
  "Return non-nil if REGEXP is valid."
  (ignore-errors (string-match regexp "") t))


(defun python-electric-pair-string-delimiter ()
  (when (and electric-pair-mode
             (memq last-command-event '(?\" ?\'))
             (let ((count 0))
               (while (eq (char-before (- (point) count)) last-command-event)
                 (cl-incf count))
               (= count 3))
             (eq (char-after) last-command-event))
    (save-excursion (insert (make-string 2 last-command-event)))))

(defvar electric-indent-inhibit)

;;;###autoload
(define-derived-mode python-mode prog-mode "Python"
  "Major mode for editing Python files.

\\{python-mode-map}"
  (set (make-local-variable 'tab-width) 8)
  (set (make-local-variable 'indent-tabs-mode) nil)

  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#+\\s-*")

  (set (make-local-variable 'parse-sexp-lookup-properties) t)
  (set (make-local-variable 'parse-sexp-ignore-comments) t)

  (set (make-local-variable 'forward-sexp-function)
       'python-nav-forward-sexp)

  (set (make-local-variable 'font-lock-defaults)
       '(python-font-lock-keywords nil nil nil nil))

  (set (make-local-variable 'syntax-propertize-function)
       python-syntax-propertize-function)

  (set (make-local-variable 'indent-line-function)
       #'python-indent-line-function)
  (set (make-local-variable 'indent-region-function) #'python-indent-region)
  ;; Because indentation is not redundant, we cannot safely reindent code.
  (setq-local electric-indent-inhibit t)
  (setq-local electric-indent-chars (cons ?: electric-indent-chars))

  ;; Add """ ... """ pairing to electric-pair-mode.
  (add-hook 'post-self-insert-hook
            #'python-electric-pair-string-delimiter 'append t)

  (set (make-local-variable 'paragraph-start) "\\s-*$")
  (set (make-local-variable 'fill-paragraph-function)
       #'python-fill-paragraph)

  (set (make-local-variable 'beginning-of-defun-function)
       #'python-nav-beginning-of-defun)
  (set (make-local-variable 'end-of-defun-function)
       #'python-nav-end-of-defun)

  (add-hook 'completion-at-point-functions
            #'python-completion-complete-at-point nil 'local)

  (add-hook 'post-self-insert-hook
            #'python-indent-post-self-insert-function 'append 'local)

  (set (make-local-variable 'imenu-create-index-function)
       #'python-imenu-create-index)

  (set (make-local-variable 'add-log-current-defun-function)
       #'python-info-current-defun)

  (add-hook 'which-func-functions #'python-info-current-defun nil t)

  (set (make-local-variable 'skeleton-further-elements)
       '((abbrev-mode nil)
         (< '(backward-delete-char-untabify (min python-indent-offset
                                                 (current-column))))
         (^ '(- (1+ (current-indentation))))))

  (set (make-local-variable 'eldoc-documentation-function)
       #'python-eldoc-function)

  (add-to-list 'hs-special-modes-alist
               `(python-mode "^\\s-*\\(?:def\\|class\\)\\>" nil "#"
                             ,(lambda (_arg)
                                (python-nav-end-of-defun)) nil))

  (set (make-local-variable 'outline-regexp)
       (python-rx (* space) block-start))
  (set (make-local-variable 'outline-heading-end-regexp) ":[^\n]*\n")
  (set (make-local-variable 'outline-level)
       #'(lambda ()
           "`outline-level' function for Python mode."
           (1+ (/ (current-indentation) python-indent-offset))))

  (python-skeleton-add-menu-items)

  (make-local-variable 'python-shell-internal-buffer)

  (when python-indent-guess-indent-offset
    (python-indent-guess-indent-offset)))


(provide 'python)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; python.el ends here
