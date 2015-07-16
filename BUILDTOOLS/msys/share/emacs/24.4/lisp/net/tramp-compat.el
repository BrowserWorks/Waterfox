;;; tramp-compat.el --- Tramp compatibility functions

;; Copyright (C) 2007-2014 Free Software Foundation, Inc.

;; Author: Michael Albinus <michael.albinus@gmx.de>
;; Keywords: comm, processes
;; Package: tramp

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

;; Tramp's main Emacs version for development is Emacs 24.  This
;; package provides compatibility functions for Emacs 22, Emacs 23,
;; XEmacs 21.4+ and SXEmacs 22.

;;; Code:

;; Pacify byte-compiler.
(eval-when-compile
  (require 'cl))

(eval-and-compile

  ;; Some packages must be required for XEmacs, because we compile
  ;; with -no-autoloads.
  (when (featurep 'xemacs)
    (require 'cus-edit)
    (require 'env)
    (require 'executable)
    (require 'outline)
    (require 'passwd)
    (require 'pp)
    (require 'regexp-opt))

  (require 'advice)
  (require 'custom)
  (require 'format-spec)
  (require 'shell)

  (require 'trampver)
  (require 'tramp-loaddefs)

  ;; As long as password.el is not part of (X)Emacs, it shouldn't be
  ;; mandatory.
  (if (featurep 'xemacs)
      (load "password" 'noerror)
    (or (require 'password-cache nil 'noerror)
	(require 'password nil 'noerror))) ; Part of contrib.

  ;; auth-source is relatively new.
  (if (featurep 'xemacs)
      (load "auth-source" 'noerror)
    (require 'auth-source nil 'noerror))

  ;; Load the appropriate timer package.
  (if (featurep 'xemacs)
      (require 'timer-funcs)
    (require 'timer))

  ;; Avoid byte-compiler warnings if the byte-compiler supports this.
  ;; Currently, XEmacs supports this.
  (when (featurep 'xemacs)
    (unless (boundp 'byte-compile-default-warnings)
      (defvar byte-compile-default-warnings nil))
    (delq 'unused-vars byte-compile-default-warnings))

  ;; `last-coding-system-used' is unknown in XEmacs.
  (unless (boundp 'last-coding-system-used)
    (defvar last-coding-system-used nil))

  ;; `directory-sep-char' is an obsolete variable in Emacs.  But it is
  ;; used in XEmacs, so we set it here and there.  The following is
  ;; needed to pacify Emacs byte-compiler.
  ;; Note that it was removed altogether in Emacs 24.1.
  (when (boundp 'directory-sep-char)
    (defvar byte-compile-not-obsolete-var nil)
    (setq byte-compile-not-obsolete-var 'directory-sep-char)
    ;; Emacs 23.2.
    (defvar byte-compile-not-obsolete-vars nil)
    (setq byte-compile-not-obsolete-vars '(directory-sep-char)))

  ;; `remote-file-name-inhibit-cache' has been introduced with Emacs 24.1.
  ;; Besides `t', `nil', and integer, we use also timestamps (as
  ;; returned by `current-time') internally.
  (unless (boundp 'remote-file-name-inhibit-cache)
    (defvar remote-file-name-inhibit-cache nil))

  ;; For not existing functions, or functions with a changed argument
  ;; list, there are compiler warnings.  We want to avoid them in
  ;; cases we know what we do.
  (defmacro tramp-compat-funcall (function &rest arguments)
    (if (featurep 'xemacs)
	`(funcall (symbol-function ,function) ,@arguments)
      `(when (or (subrp ,function) (functionp ,function))
	 (with-no-warnings (funcall ,function ,@arguments)))))

  ;; `set-buffer-multibyte' comes from Emacs Leim.
  (unless (fboundp 'set-buffer-multibyte)
    (defalias 'set-buffer-multibyte 'ignore))

  ;; The following functions cannot be aliases of the corresponding
  ;; `tramp-handle-*' functions, because this would bypass the locking
  ;; mechanism.

  ;; `file-remote-p' has been introduced with Emacs 22.  The version
  ;; of XEmacs is not a magic file name function (yet).
  (unless (fboundp 'file-remote-p)
    (defalias 'file-remote-p
      (lambda (file &optional identification connected)
	(when (tramp-tramp-file-p file)
	  (tramp-compat-funcall
	   'tramp-file-name-handler
	   'file-remote-p file identification connected)))))

  ;; `process-file' does not exist in XEmacs.
  (unless (fboundp 'process-file)
    (defalias 'process-file
      (lambda (program &optional infile buffer display &rest args)
	(when (tramp-tramp-file-p default-directory)
	  (apply
	   'tramp-file-name-handler
	   'process-file program infile buffer display args)))))

  ;; `start-file-process' is new in Emacs 23.
  (unless (fboundp 'start-file-process)
    (defalias 'start-file-process
      (lambda (name buffer program &rest program-args)
	(when (tramp-tramp-file-p default-directory)
	  (apply
	   'tramp-file-name-handler
	   'start-file-process name buffer program program-args)))))

  ;; `set-file-times' is also new in Emacs 23.
  (unless (fboundp 'set-file-times)
    (defalias 'set-file-times
      (lambda (filename &optional time)
	(when (tramp-tramp-file-p filename)
	  (tramp-compat-funcall
	   'tramp-file-name-handler 'set-file-times filename time)))))

  ;; We currently use "[" and "]" in the filename format for IPv6
  ;; hosts of GNU Emacs.  This means that Emacs wants to expand
  ;; wildcards if `find-file-wildcards' is non-nil, and then barfs
  ;; because no expansion could be found.  We detect this situation
  ;; and do something really awful: we have `file-expand-wildcards'
  ;; return the original filename if it can't expand anything.  Let's
  ;; just hope that this doesn't break anything else.
  ;; It is not needed anymore since GNU Emacs 23.2.
  (unless (or (featurep 'xemacs)
	      ;; `featurep' has only one argument in XEmacs.
	      (funcall 'featurep 'files 'remote-wildcards))
    (defadvice file-expand-wildcards
      (around tramp-advice-file-expand-wildcards activate)
      (let ((name (ad-get-arg 0)))
	;; If it's a Tramp file, look if wildcards need to be expanded
	;; at all.
	(if (and
	     (tramp-tramp-file-p name)
	     (not (string-match
		   "[[*?]" (tramp-compat-funcall
			    'file-remote-p name 'localname))))
	    (setq ad-return-value (list name))
	  ;; Otherwise, just run the original function.
	  ad-do-it)))
    (add-hook
     'tramp-unload-hook
     (lambda ()
       (ad-remove-advice
	'file-expand-wildcards 'around 'tramp-advice-file-expand-wildcards)
       (ad-activate 'file-expand-wildcards)))))

;; `with-temp-message' does not exist in XEmacs.
(if (fboundp 'with-temp-message)
    (defalias 'tramp-compat-with-temp-message 'with-temp-message)
  (defmacro tramp-compat-with-temp-message (_message &rest body)
    "Display MESSAGE temporarily if non-nil while BODY is evaluated."
    `(progn ,@body)))

;; `condition-case-unless-debug' is introduced with Emacs 24.
(if (fboundp 'condition-case-unless-debug)
    (defalias 'tramp-compat-condition-case-unless-debug
      'condition-case-unless-debug)
  (defmacro tramp-compat-condition-case-unless-debug
    (var bodyform &rest handlers)
  "Like `condition-case' except that it does not catch anything when debugging."
    (declare (debug condition-case) (indent 2))
    (let ((bodysym (make-symbol "body")))
      `(let ((,bodysym (lambda () ,bodyform)))
	 (if debug-on-error
	     (funcall ,bodysym)
	   (condition-case ,var
	       (funcall ,bodysym)
	     ,@handlers))))))

;; `font-lock-add-keywords' does not exist in XEmacs.
(defun tramp-compat-font-lock-add-keywords (mode keywords &optional how)
  "Add highlighting KEYWORDS for MODE."
  (ignore-errors
    (tramp-compat-funcall 'font-lock-add-keywords mode keywords how)))

(defsubst tramp-compat-temporary-file-directory ()
  "Return name of directory for temporary files (compat function).
For Emacs, this is the variable `temporary-file-directory', for XEmacs
this is the function `temp-directory'."
  (let (file-name-handler-alist)
    ;; We must return a local directory.  If it is remote, we could
    ;; run into an infloop.
    (cond
     ((and (boundp 'temporary-file-directory)
	   (eval (car (get 'temporary-file-directory 'standard-value)))))
     ((fboundp 'temp-directory) (tramp-compat-funcall 'temp-directory))
     ((let ((d (getenv "TEMP"))) (and d (file-directory-p d)))
      (file-name-as-directory (getenv "TEMP")))
     ((let ((d (getenv "TMP"))) (and d (file-directory-p d)))
      (file-name-as-directory (getenv "TMP")))
     ((let ((d (getenv "TMPDIR"))) (and d (file-directory-p d)))
      (file-name-as-directory (getenv "TMPDIR")))
     ((file-exists-p "c:/temp") (file-name-as-directory "c:/temp"))
     (t (message (concat "Neither `temporary-file-directory' nor "
			 "`temp-directory' is defined -- using /tmp."))
	(file-name-as-directory "/tmp")))))

;; `make-temp-file' exists in Emacs only.  On XEmacs, we use our own
;; implementation with `make-temp-name', creating the temporary file
;; immediately in order to avoid a security hole.
(defsubst tramp-compat-make-temp-file (f &optional dir-flag)
  "Create a temporary file (compat function).
Add the extension of F, if existing."
  (let* (file-name-handler-alist
	 (prefix (expand-file-name
		  (symbol-value 'tramp-temp-name-prefix)
		  (tramp-compat-temporary-file-directory)))
	 (extension (file-name-extension f t))
	 result)
    (condition-case nil
	(setq result
	      (tramp-compat-funcall 'make-temp-file prefix dir-flag extension))
      (error
       ;; We use our own implementation, taken from files.el.
       (while
	   (condition-case ()
	       (progn
		 (setq result (concat (make-temp-name prefix) extension))
		 (if dir-flag
		     (make-directory result)
		   (write-region "" nil result nil 'silent))
		 nil)
	     (file-already-exists t))
	 ;; The file was somehow created by someone else between
	 ;; `make-temp-name' and `write-region', let's try again.
	 nil)))
    result))

;; `most-positive-fixnum' does not exist in XEmacs.
(defsubst tramp-compat-most-positive-fixnum ()
  "Return largest positive integer value (compat function)."
  (cond
   ((boundp 'most-positive-fixnum) (symbol-value 'most-positive-fixnum))
   ;; Default value in XEmacs.
   (t 134217727)))

(defun tramp-compat-decimal-to-octal (i)
  "Return a string consisting of the octal digits of I.
Not actually used.  Use `(format \"%o\" i)' instead?"
  (cond ((< i 0) (error "Cannot convert negative number to octal"))
        ((not (integerp i)) (error "Cannot convert non-integer to octal"))
        ((zerop i) "0")
        (t (concat (tramp-compat-decimal-to-octal (/ i 8))
                   (number-to-string (% i 8))))))

;; Kudos to Gerd Moellmann for this suggestion.
(defun tramp-compat-octal-to-decimal (ostr)
  "Given a string of octal digits, return a decimal number."
  (let ((x (or ostr "")))
    ;; `save-match' is in `tramp-mode-string-to-int' which calls this.
    (unless (string-match "\\`[0-7]*\\'" x)
      (error "Non-octal junk in string `%s'" x))
    (string-to-number ostr 8)))

;; ID-FORMAT does not exist in XEmacs.
(defun tramp-compat-file-attributes (filename &optional id-format)
  "Like `file-attributes' for Tramp files (compat function)."
  (cond
   ((or (null id-format) (eq id-format 'integer))
    (file-attributes filename))
   ((tramp-tramp-file-p filename)
    (tramp-compat-funcall
     'tramp-file-name-handler 'file-attributes filename id-format))
   (t (condition-case nil
	  (tramp-compat-funcall 'file-attributes filename id-format)
	(wrong-number-of-arguments (file-attributes filename))))))

;; PRESERVE-UID-GID does not exist in XEmacs.
;; PRESERVE-EXTENDED-ATTRIBUTES has been introduced with Emacs 24.1
;; (as PRESERVE-SELINUX-CONTEXT), and renamed in Emacs 24.3.
(defun tramp-compat-copy-file
  (filename newname &optional ok-if-already-exists keep-date
	    preserve-uid-gid preserve-extended-attributes)
  "Like `copy-file' for Tramp files (compat function)."
  (cond
   (preserve-extended-attributes
    (condition-case nil
	(tramp-compat-funcall
	 'copy-file filename newname ok-if-already-exists keep-date
	 preserve-uid-gid preserve-extended-attributes)
      (wrong-number-of-arguments
       (tramp-compat-copy-file
	filename newname ok-if-already-exists keep-date preserve-uid-gid))))
   (preserve-uid-gid
    (condition-case nil
	(tramp-compat-funcall
	 'copy-file filename newname ok-if-already-exists keep-date
	 preserve-uid-gid)
      (wrong-number-of-arguments
       (tramp-compat-copy-file
	filename newname ok-if-already-exists keep-date))))
   (t
    (copy-file filename newname ok-if-already-exists keep-date))))

;; `copy-directory' is a new function in Emacs 23.2.  Implementation
;; is taken from there.
(defun tramp-compat-copy-directory
  (directory newname &optional keep-time parents copy-contents)
  "Make a copy of DIRECTORY (compat function)."
  (condition-case nil
      (tramp-compat-funcall
       'copy-directory directory newname keep-time parents copy-contents)

    ;; `copy-directory' is either not implemented, or it does not
    ;; support the the COPY-CONTENTS flag.  For the time being, we
    ;; ignore COPY-CONTENTS as well.

    (error
     ;; If `default-directory' is a remote directory, make sure we
     ;; find its `copy-directory' handler.
     (let ((handler (or (find-file-name-handler directory 'copy-directory)
			(find-file-name-handler newname 'copy-directory))))
       (if handler
	   (funcall handler 'copy-directory directory newname keep-time parents)

	 ;; Compute target name.
	 (setq directory (directory-file-name (expand-file-name directory))
	       newname   (directory-file-name (expand-file-name newname)))
	 (if (and (file-directory-p newname)
		  (not (string-equal (file-name-nondirectory directory)
				     (file-name-nondirectory newname))))
	     (setq newname
		   (expand-file-name
		    (file-name-nondirectory directory) newname)))
	 (if (not (file-directory-p newname)) (make-directory newname parents))

	 ;; Copy recursively.
	 (mapc
	  (lambda (file)
	    (if (file-directory-p file)
		(tramp-compat-copy-directory file newname keep-time parents)
	      (copy-file file newname t keep-time)))
	  ;; We do not want to delete "." and "..".
	  (directory-files
	   directory 'full "^\\([^.]\\|\\.\\([^.]\\|\\..\\)\\).*"))

	 ;; Set directory attributes.
	 (set-file-modes newname (file-modes directory))
	 (if keep-time
	     (set-file-times newname (nth 5 (file-attributes directory)))))))))

;; TRASH has been introduced with Emacs 24.1.
(defun tramp-compat-delete-file (filename &optional trash)
  "Like `delete-file' for Tramp files (compat function)."
  (condition-case nil
      (tramp-compat-funcall 'delete-file filename trash)
    ;; This Emacs version does not support the TRASH flag.
    (wrong-number-of-arguments
     (let ((delete-by-moving-to-trash
	    (and (boundp 'delete-by-moving-to-trash)
		 (symbol-value 'delete-by-moving-to-trash)
		 trash)))
       (delete-file filename)))))

;; RECURSIVE has been introduced with Emacs 23.2.  TRASH has been
;; introduced with Emacs 24.1.
(defun tramp-compat-delete-directory (directory &optional recursive trash)
  "Like `delete-directory' for Tramp files (compat function)."
  (condition-case nil
      (cond
       (trash
	(tramp-compat-funcall 'delete-directory directory recursive trash))
       (recursive
	(tramp-compat-funcall 'delete-directory directory recursive))
       (t
	(delete-directory directory)))
    ;; This Emacs version does not support the RECURSIVE or TRASH flag.  We
    ;; use the implementation from Emacs 23.2.
    (wrong-number-of-arguments
     (setq directory (directory-file-name (expand-file-name directory)))
     (if (not (file-symlink-p directory))
	 (mapc (lambda (file)
		 (if (eq t (car (file-attributes file)))
		     (tramp-compat-delete-directory file recursive trash)
		   (tramp-compat-delete-file file trash)))
	       (directory-files
		directory 'full "^\\([^.]\\|\\.\\([^.]\\|\\..\\)\\).*")))
     (delete-directory directory))))

;; MUST-SUFFIX doesn't exist on XEmacs.
(defun tramp-compat-load (file &optional noerror nomessage nosuffix must-suffix)
  "Like `load' for Tramp files (compat function)."
  (if must-suffix
      (tramp-compat-funcall 'load file noerror nomessage nosuffix must-suffix)
    (load file noerror nomessage nosuffix)))

;; `number-sequence' does not exist in XEmacs.  Implementation is
;; taken from Emacs 23.
(defun tramp-compat-number-sequence (from &optional to inc)
  "Return a sequence of numbers from FROM to TO as a list (compat function)."
  (if (or (subrp 'number-sequence) (symbol-file 'number-sequence))
      (tramp-compat-funcall 'number-sequence from to inc)
    (if (or (not to) (= from to))
	(list from)
      (or inc (setq inc 1))
      (when (zerop inc) (error "The increment can not be zero"))
      (let (seq (n 0) (next from))
	(if (> inc 0)
	    (while (<= next to)
	      (setq seq (cons next seq)
		    n (1+ n)
		    next (+ from (* n inc))))
	  (while (>= next to)
	    (setq seq (cons next seq)
		  n (1+ n)
		  next (+ from (* n inc)))))
	(nreverse seq)))))

(defun tramp-compat-split-string (string pattern)
  "Like `split-string' but omit empty strings.
In Emacs, (split-string \"/foo/bar\" \"/\") returns (\"foo\" \"bar\").
This is, the first, empty, element is omitted.  In XEmacs, the first
element is not omitted."
  (delete "" (split-string string pattern)))

(defun tramp-compat-process-running-p (process-name)
  "Returns `t' if system process PROCESS-NAME is running for `user-login-name'."
  (when (stringp process-name)
    (cond
     ;; GNU Emacs 22 on w32.
     ((fboundp 'w32-window-exists-p)
      (tramp-compat-funcall 'w32-window-exists-p process-name process-name))

     ;; GNU Emacs 23.
     ((and (fboundp 'list-system-processes) (fboundp 'process-attributes))
      (let (result)
	(dolist (pid (tramp-compat-funcall 'list-system-processes) result)
	  (let ((attributes (tramp-compat-funcall 'process-attributes pid)))
	    (when (and (string-equal
                        (cdr (assoc 'user attributes)) (user-login-name))
                       (let ((comm (cdr (assoc 'comm attributes))))
                         ;; The returned command name could be truncated
                         ;; to 15 characters.  Therefore, we cannot check
                         ;; for `string-equal'.
                         (and comm (string-match
                                    (concat "^" (regexp-quote comm))
                                    process-name))))
	      (setq result t))))))

     ;; Fallback, if there is no Lisp support yet.
     (t (let ((default-directory
		(if (tramp-tramp-file-p default-directory)
		    (tramp-compat-temporary-file-directory)
		  default-directory))
	      (unix95 (getenv "UNIX95"))
	      result)
	  (setenv "UNIX95" "1")
	  (when (member
		 (user-login-name)
		 (tramp-compat-split-string
		  (shell-command-to-string
		   (format "ps -C %s -o user=" process-name))
		  "[ \f\t\n\r\v]+"))
	    (setq result t))
	  (setenv "UNIX95" unix95)
	  result)))))

;; The following functions do not exist in XEmacs.  We ignore this;
;; they are used for checking a remote tty.
(defun tramp-compat-process-get (process propname)
  "Return the value of PROCESS' PROPNAME property.
This is the last value stored with `(process-put PROCESS PROPNAME VALUE)'."
  (ignore-errors (tramp-compat-funcall 'process-get process propname)))

(defun tramp-compat-process-put (process propname value)
  "Change PROCESS' PROPNAME property to VALUE.
It can be retrieved with `(process-get PROCESS PROPNAME)'."
  (ignore-errors (tramp-compat-funcall 'process-put process propname value)))

(defun tramp-compat-set-process-query-on-exit-flag (process flag)
  "Specify if query is needed for process when Emacs is exited.
If the second argument flag is non-nil, Emacs will query the user before
exiting if process is running."
  (if (fboundp 'set-process-query-on-exit-flag)
      (tramp-compat-funcall 'set-process-query-on-exit-flag process flag)
    (tramp-compat-funcall 'process-kill-without-query process flag)))

;; There exist different implementations for this function.
(defun tramp-compat-coding-system-change-eol-conversion (coding-system eol-type)
  "Return a coding system like CODING-SYSTEM but with given EOL-TYPE.
EOL-TYPE can be one of `dos', `unix', or `mac'."
  (cond ((fboundp 'coding-system-change-eol-conversion)
         (tramp-compat-funcall
	  'coding-system-change-eol-conversion coding-system eol-type))
        ((fboundp 'subsidiary-coding-system)
         (tramp-compat-funcall
	  'subsidiary-coding-system coding-system
	  (cond ((eq eol-type 'dos) 'crlf)
		((eq eol-type 'unix) 'lf)
		((eq eol-type 'mac) 'cr)
		(t
		 (error "Unknown EOL-TYPE `%s', must be %s"
			eol-type
			"`dos', `unix', or `mac'")))))
        (t (error "Can't change EOL conversion -- is MULE missing?"))))

;; `replace-regexp-in-string' does not exist in XEmacs.
;; Implementation is taken from Emacs 24.
(if (fboundp 'replace-regexp-in-string)
    (defalias 'tramp-compat-replace-regexp-in-string 'replace-regexp-in-string)
  (defun tramp-compat-replace-regexp-in-string
    (regexp rep string &optional fixedcase literal subexp start)
    "Replace all matches for REGEXP with REP in STRING.

Return a new string containing the replacements.

Optional arguments FIXEDCASE, LITERAL and SUBEXP are like the
arguments with the same names of function `replace-match'.  If START
is non-nil, start replacements at that index in STRING.

REP is either a string used as the NEWTEXT arg of `replace-match' or a
function.  If it is a function, it is called with the actual text of each
match, and its value is used as the replacement text.  When REP is called,
the match data are the result of matching REGEXP against a substring
of STRING.

To replace only the first match (if any), make REGEXP match up to \\'
and replace a sub-expression, e.g.
  (replace-regexp-in-string \"\\\\(foo\\\\).*\\\\'\" \"bar\" \" foo foo\" nil nil 1)
    => \" bar foo\""

    (let ((l (length string))
	  (start (or start 0))
	  matches str mb me)
      (save-match-data
	(while (and (< start l) (string-match regexp string start))
	  (setq mb (match-beginning 0)
		me (match-end 0))
	  ;; If we matched the empty string, make sure we advance by one char
	  (when (= me mb) (setq me (min l (1+ mb))))
	  ;; Generate a replacement for the matched substring.
	  ;; Operate only on the substring to minimize string consing.
	  ;; Set up match data for the substring for replacement;
	  ;; presumably this is likely to be faster than munging the
	  ;; match data directly in Lisp.
	  (string-match regexp (setq str (substring string mb me)))
	  (setq matches
		(cons (replace-match (if (stringp rep)
					 rep
				       (funcall rep (match-string 0 str)))
				     fixedcase literal str subexp)
		      (cons (substring string start mb) ; unmatched prefix
			    matches)))
	  (setq start me))
	;; Reconstruct a string from the pieces.
	(setq matches (cons (substring string start l) matches)) ; leftover
	(apply #'concat (nreverse matches))))))

(add-hook 'tramp-unload-hook
	  (lambda ()
	    (unload-feature 'tramp-loaddefs 'force)
	    (unload-feature 'tramp-compat 'force)))

(provide 'tramp-compat)

;;; TODO:

;;; tramp-compat.el ends here
