;;; cl-macs.el --- Common Lisp macros  -*- lexical-binding: t; coding: utf-8 -*-

;; Copyright (C) 1993, 2001-2013 Free Software Foundation, Inc.

;; Author: Dave Gillespie <daveg@synaptics.com>
;; Version: 2.02
;; Keywords: extensions
;; Package: emacs

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

;; These are extensions to Emacs Lisp that provide a degree of
;; Common Lisp compatibility, beyond what is already built-in
;; in Emacs Lisp.
;;
;; This package was written by Dave Gillespie; it is a complete
;; rewrite of Cesar Quiroz's original cl.el package of December 1986.
;;
;; Bug reports, comments, and suggestions are welcome!

;; This file contains the portions of the Common Lisp extensions
;; package which should be autoloaded, but need only be present
;; if the compiler or interpreter is used---this file is not
;; necessary for executing compiled code.

;; See cl.el for Change Log.


;;; Code:

(require 'cl-lib)
(require 'macroexp)
;; `gv' is required here because cl-macs can be loaded before loaddefs.el.
(require 'gv)

(defmacro cl-pop2 (place)
  (declare (debug edebug-sexps))
  `(prog1 (car (cdr ,place))
     (setq ,place (cdr (cdr ,place)))))

(defvar cl-optimize-safety)
(defvar cl-optimize-speed)

;;; Initialization.

;; Place compiler macros at the beginning, otherwise uses of the corresponding
;; functions can lead to recursive-loads that prevent the calls from
;; being optimized.

;;;###autoload
(defun cl--compiler-macro-list* (_form arg &rest others)
  (let* ((args (reverse (cons arg others)))
	 (form (car args)))
    (while (setq args (cdr args))
      (setq form `(cons ,(car args) ,form)))
    form))

;;;###autoload
(defun cl--compiler-macro-cXXr (form x)
  (let* ((head (car form))
         (n (symbol-name (car form)))
         (i (- (length n) 2)))
    (if (not (string-match "c[ad]+r\\'" n))
        (if (and (fboundp head) (symbolp (symbol-function head)))
            (cl--compiler-macro-cXXr (cons (symbol-function head) (cdr form))
                                     x)
          (error "Compiler macro for cXXr applied to non-cXXr form"))
      (while (> i (match-beginning 0))
        (setq x (list (if (eq (aref n i) ?a) 'car 'cdr) x))
        (setq i (1- i)))
      x)))

;;; Some predicates for analyzing Lisp forms.
;; These are used by various
;; macro expanders to optimize the results in certain common cases.

(defconst cl--simple-funcs '(car cdr nth aref elt if and or + - 1+ 1- min max
			    car-safe cdr-safe progn prog1 prog2))
(defconst cl--safe-funcs '(* / % length memq list vector vectorp
			  < > <= >= = error))

(defun cl--simple-expr-p (x &optional size)
  "Check if no side effects, and executes quickly."
  (or size (setq size 10))
  (if (and (consp x) (not (memq (car x) '(quote function cl-function))))
      (and (symbolp (car x))
	   (or (memq (car x) cl--simple-funcs)
	       (get (car x) 'side-effect-free))
	   (progn
	     (setq size (1- size))
	     (while (and (setq x (cdr x))
			 (setq size (cl--simple-expr-p (car x) size))))
	     (and (null x) (>= size 0) size)))
    (and (> size 0) (1- size))))

(defun cl--simple-exprs-p (xs)
  (while (and xs (cl--simple-expr-p (car xs)))
    (setq xs (cdr xs)))
  (not xs))

(defun cl--safe-expr-p (x)
  "Check if no side effects."
  (or (not (and (consp x) (not (memq (car x) '(quote function cl-function)))))
      (and (symbolp (car x))
	   (or (memq (car x) cl--simple-funcs)
	       (memq (car x) cl--safe-funcs)
	       (get (car x) 'side-effect-free))
	   (progn
	     (while (and (setq x (cdr x)) (cl--safe-expr-p (car x))))
	     (null x)))))

;;; Check if constant (i.e., no side effects or dependencies).
(defun cl--const-expr-p (x)
  (cond ((consp x)
	 (or (eq (car x) 'quote)
	     (and (memq (car x) '(function cl-function))
		  (or (symbolp (nth 1 x))
		      (and (eq (car-safe (nth 1 x)) 'lambda) 'func)))))
	((symbolp x) (and (memq x '(nil t)) t))
	(t t)))

(defun cl--const-expr-val (x)
  (and (macroexp-const-p x) (if (consp x) (nth 1 x) x)))

(defun cl--expr-contains (x y)
  "Count number of times X refers to Y.  Return nil for 0 times."
  ;; FIXME: This is naive, and it will cl-count Y as referred twice in
  ;; (let ((Y 1)) Y) even though it should be 0.  Also it is often called on
  ;; non-macroexpanded code, so it may also miss some occurrences that would
  ;; only appear in the expanded code.
  (cond ((equal y x) 1)
	((and (consp x) (not (memq (car x) '(quote function cl-function))))
	 (let ((sum 0))
	   (while (consp x)
	     (setq sum (+ sum (or (cl--expr-contains (pop x) y) 0))))
	   (setq sum (+ sum (or (cl--expr-contains x y) 0)))
	   (and (> sum 0) sum)))
	(t nil)))

(defun cl--expr-contains-any (x y)
  (while (and y (not (cl--expr-contains x (car y)))) (pop y))
  y)

(defun cl--expr-depends-p (x y)
  "Check whether X may depend on any of the symbols in Y."
  (and (not (macroexp-const-p x))
       (or (not (cl--safe-expr-p x)) (cl--expr-contains-any x y))))

;;; Symbols.

(defvar cl--gensym-counter)
;;;###autoload
(defun cl-gensym (&optional prefix)
  "Generate a new uninterned symbol.
The name is made by appending a number to PREFIX, default \"G\"."
  (let ((pfix (if (stringp prefix) prefix "G"))
	(num (if (integerp prefix) prefix
	       (prog1 cl--gensym-counter
		 (setq cl--gensym-counter (1+ cl--gensym-counter))))))
    (make-symbol (format "%s%d" pfix num))))

;;;###autoload
(defun cl-gentemp (&optional prefix)
  "Generate a new interned symbol with a unique name.
The name is made by appending a number to PREFIX, default \"G\"."
  (let ((pfix (if (stringp prefix) prefix "G"))
	name)
    (while (intern-soft (setq name (format "%s%d" pfix cl--gensym-counter)))
      (setq cl--gensym-counter (1+ cl--gensym-counter)))
    (intern name)))


;;; Program structure.

(def-edebug-spec cl-declarations
  (&rest ("cl-declare" &rest sexp)))

(def-edebug-spec cl-declarations-or-string
  (&or stringp cl-declarations))

(def-edebug-spec cl-lambda-list
  (([&rest arg]
    [&optional ["&optional" cl-&optional-arg &rest cl-&optional-arg]]
    [&optional ["&rest" arg]]
    [&optional ["&key" [cl-&key-arg &rest cl-&key-arg]
		&optional "&allow-other-keys"]]
    [&optional ["&aux" &rest
		&or (symbolp &optional def-form) symbolp]]
    )))

(def-edebug-spec cl-&optional-arg
  (&or (arg &optional def-form arg) arg))

(def-edebug-spec cl-&key-arg
  (&or ([&or (symbolp arg) arg] &optional def-form arg) arg))

(defconst cl--lambda-list-keywords
  '(&optional &rest &key &allow-other-keys &aux &whole &body &environment))

(defvar cl--bind-block) (defvar cl--bind-defs) (defvar cl--bind-enquote)
(defvar cl--bind-inits) (defvar cl--bind-lets) (defvar cl--bind-forms)

(defun cl--transform-lambda (form bind-block)
  "Transform a function form FORM of name BIND-BLOCK.
BIND-BLOCK is the name of the symbol to which the function will be bound,
and which will be used for the name of the `cl-block' surrounding the
function's body.
FORM is of the form (ARGS . BODY)."
  (let* ((args (car form)) (body (cdr form)) (orig-args args)
	 (cl--bind-block bind-block) (cl--bind-defs nil) (cl--bind-enquote nil)
	 (cl--bind-inits nil) (cl--bind-lets nil) (cl--bind-forms nil)
	 (header nil) (simple-args nil))
    (while (or (stringp (car body))
	       (memq (car-safe (car body)) '(interactive declare cl-declare)))
      (push (pop body) header))
    (setq args (if (listp args) (cl-copy-list args) (list '&rest args)))
    (let ((p (last args))) (if (cdr p) (setcdr p (list '&rest (cdr p)))))
    (if (setq cl--bind-defs (cadr (memq '&cl-defs args)))
	(setq args (delq '&cl-defs (delq cl--bind-defs args))
	      cl--bind-defs (cadr cl--bind-defs)))
    (if (setq cl--bind-enquote (memq '&cl-quote args))
	(setq args (delq '&cl-quote args)))
    (if (memq '&whole args) (error "&whole not currently implemented"))
    (let* ((p (memq '&environment args)) (v (cadr p))
           (env-exp 'macroexpand-all-environment))
      (if p (setq args (nconc (delq (car p) (delq v args))
                              (list '&aux (list v env-exp))))))
    (while (and args (symbolp (car args))
		(not (memq (car args) '(nil &rest &body &key &aux)))
		(not (and (eq (car args) '&optional)
			  (or cl--bind-defs (consp (cadr args))))))
      (push (pop args) simple-args))
    (or (eq cl--bind-block 'cl-none)
	(setq body (list `(cl-block ,cl--bind-block ,@body))))
    (if (null args)
	(cl-list* nil (nreverse simple-args) (nconc (nreverse header) body))
      (if (memq '&optional simple-args) (push '&optional args))
      (cl--do-arglist args nil (- (length simple-args)
                                  (if (memq '&optional simple-args) 1 0)))
      (setq cl--bind-lets (nreverse cl--bind-lets))
      (cl-list* (and cl--bind-inits `(cl-eval-when (compile load eval)
                                ,@(nreverse cl--bind-inits)))
	     (nconc (nreverse simple-args)
		    (list '&rest (car (pop cl--bind-lets))))
	     (nconc (let ((hdr (nreverse header)))
                      ;; Macro expansion can take place in the middle of
                      ;; apparently harmless computation, so it should not
                      ;; touch the match-data.
                      (save-match-data
                        (require 'help-fns)
                        (cons (help-add-fundoc-usage
                               (if (stringp (car hdr)) (pop hdr))
                               (format "%S"
                                       (cons 'fn
                                             (cl--make-usage-args orig-args))))
                              hdr)))
		    (list `(let* ,cl--bind-lets
                             ,@(nreverse cl--bind-forms)
                             ,@body)))))))

;;;###autoload
(defmacro cl-defun (name args &rest body)
  "Define NAME as a function.
Like normal `defun', except ARGLIST allows full Common Lisp conventions,
and BODY is implicitly surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)"
  (declare (debug
            ;; Same as defun but use cl-lambda-list.
            (&define [&or name ("setf" :name setf name)]
                     cl-lambda-list
                     cl-declarations-or-string
                     [&optional ("interactive" interactive)]
                     def-body))
           (doc-string 3)
           (indent 2))
  (let* ((res (cl--transform-lambda (cons args body) name))
	 (form `(defun ,name ,@(cdr res))))
    (if (car res) `(progn ,(car res) ,form) form)))

;; The lambda list for macros is different from that of normal lambdas.
;; Note that &environment is only allowed as first or last items in the
;; top level list.

(def-edebug-spec cl-macro-list
  (([&optional "&environment" arg]
    [&rest cl-macro-arg]
    [&optional ["&optional" &rest
		&or (cl-macro-arg &optional def-form cl-macro-arg) arg]]
    [&optional [[&or "&rest" "&body"] cl-macro-arg]]
    [&optional ["&key" [&rest
			[&or ([&or (symbolp cl-macro-arg) arg]
			      &optional def-form cl-macro-arg)
			     arg]]
		&optional "&allow-other-keys"]]
    [&optional ["&aux" &rest
		&or (symbolp &optional def-form) symbolp]]
    [&optional "&environment" arg]
    )))

(def-edebug-spec cl-macro-arg
  (&or arg cl-macro-list1))

(def-edebug-spec cl-macro-list1
  (([&optional "&whole" arg]  ;; only allowed at lower levels
    [&rest cl-macro-arg]
    [&optional ["&optional" &rest
		&or (cl-macro-arg &optional def-form cl-macro-arg) arg]]
    [&optional [[&or "&rest" "&body"] cl-macro-arg]]
    [&optional ["&key" [&rest
			[&or ([&or (symbolp cl-macro-arg) arg]
			      &optional def-form cl-macro-arg)
			     arg]]
		&optional "&allow-other-keys"]]
    [&optional ["&aux" &rest
		&or (symbolp &optional def-form) symbolp]]
    . [&or arg nil])))

;;;###autoload
(defmacro cl-defmacro (name args &rest body)
  "Define NAME as a macro.
Like normal `defmacro', except ARGLIST allows full Common Lisp conventions,
and BODY is implicitly surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)"
  (declare (debug
            (&define name cl-macro-list cl-declarations-or-string def-body))
           (doc-string 3)
           (indent 2))
  (let* ((res (cl--transform-lambda (cons args body) name))
	 (form `(defmacro ,name ,@(cdr res))))
    (if (car res) `(progn ,(car res) ,form) form)))

(def-edebug-spec cl-lambda-expr
  (&define ("lambda" cl-lambda-list
	    ;;cl-declarations-or-string
	    ;;[&optional ("interactive" interactive)]
	    def-body)))

;; Redefine function-form to also match cl-function
(def-edebug-spec function-form
  ;; form at the end could also handle "function",
  ;; but recognize it specially to avoid wrapping function forms.
  (&or ([&or "quote" "function"] &or symbolp lambda-expr)
       ("cl-function" cl-function)
       form))

;;;###autoload
(defmacro cl-function (func)
  "Introduce a function.
Like normal `function', except that if argument is a lambda form,
its argument list allows full Common Lisp conventions."
  (declare (debug (&or symbolp cl-lambda-expr)))
  (if (eq (car-safe func) 'lambda)
      (let* ((res (cl--transform-lambda (cdr func) 'cl-none))
	     (form `(function (lambda . ,(cdr res)))))
	(if (car res) `(progn ,(car res) ,form) form))
    `(function ,func)))

(declare-function help-add-fundoc-usage "help-fns" (docstring arglist))

(defun cl--make-usage-var (x)
  "X can be a var or a (destructuring) lambda-list."
  (cond
   ((symbolp x) (make-symbol (upcase (symbol-name x))))
   ((consp x) (cl--make-usage-args x))
   (t x)))

(defun cl--make-usage-args (arglist)
  (if (cdr-safe (last arglist))         ;Not a proper list.
      (let* ((last (last arglist))
             (tail (cdr last)))
        (unwind-protect
            (progn
              (setcdr last nil)
              (nconc (cl--make-usage-args arglist) (cl--make-usage-var tail)))
          (setcdr last tail)))
    ;; `orig-args' can contain &cl-defs (an internal
    ;; CL thingy I don't understand), so remove it.
    (let ((x (memq '&cl-defs arglist)))
      (when x (setq arglist (delq (car x) (remq (cadr x) arglist)))))
    (let ((state nil))
      (mapcar (lambda (x)
                (cond
                 ((symbolp x)
                  (let ((first (aref (symbol-name x) 0)))
                    (if (eq ?\& first)
                        (setq state x)
                      ;; Strip a leading underscore, since it only
                      ;; means that this argument is unused.
                      (make-symbol (upcase (if (eq ?_ first)
                                               (substring (symbol-name x) 1)
                                             (symbol-name x)))))))
                 ((not (consp x)) x)
                 ((memq state '(nil &rest)) (cl--make-usage-args x))
                 (t      ;(VAR INITFORM SVAR) or ((KEYWORD VAR) INITFORM SVAR).
                  (cl-list*
                   (if (and (consp (car x)) (eq state '&key))
                       (list (caar x) (cl--make-usage-var (nth 1 (car x))))
                     (cl--make-usage-var (car x)))
                   (nth 1 x)                        ;INITFORM.
                   (cl--make-usage-args (nthcdr 2 x)) ;SVAR.
                   ))))
              arglist))))

(defun cl--do-arglist (args expr &optional num)   ; uses bind-*
  (if (nlistp args)
      (if (or (memq args cl--lambda-list-keywords) (not (symbolp args)))
	  (error "Invalid argument name: %s" args)
	(push (list args expr) cl--bind-lets))
    (setq args (cl-copy-list args))
    (let ((p (last args))) (if (cdr p) (setcdr p (list '&rest (cdr p)))))
    (let ((p (memq '&body args))) (if p (setcar p '&rest)))
    (if (memq '&environment args) (error "&environment used incorrectly"))
    (let ((save-args args)
	  (restarg (memq '&rest args))
	  (safety (if (cl--compiling-file) cl-optimize-safety 3))
	  (keys nil)
	  (laterarg nil) (exactarg nil) minarg)
      (or num (setq num 0))
      (if (listp (cadr restarg))
	  (setq restarg (make-symbol "--cl-rest--"))
	(setq restarg (cadr restarg)))
      (push (list restarg expr) cl--bind-lets)
      (if (eq (car args) '&whole)
	  (push (list (cl-pop2 args) restarg) cl--bind-lets))
      (let ((p args))
	(setq minarg restarg)
	(while (and p (not (memq (car p) cl--lambda-list-keywords)))
	  (or (eq p args) (setq minarg (list 'cdr minarg)))
	  (setq p (cdr p)))
	(if (memq (car p) '(nil &aux))
	    (setq minarg `(= (length ,restarg)
                             ,(length (cl-ldiff args p)))
		  exactarg (not (eq args p)))))
      (while (and args (not (memq (car args) cl--lambda-list-keywords)))
	(let ((poparg (list (if (or (cdr args) (not exactarg)) 'pop 'car)
			    restarg)))
	  (cl--do-arglist
	   (pop args)
	   (if (or laterarg (= safety 0)) poparg
	     `(if ,minarg ,poparg
                (signal 'wrong-number-of-arguments
                        (list ,(and (not (eq cl--bind-block 'cl-none))
                                    `',cl--bind-block)
                              (length ,restarg)))))))
	(setq num (1+ num) laterarg t))
      (while (and (eq (car args) '&optional) (pop args))
	(while (and args (not (memq (car args) cl--lambda-list-keywords)))
	  (let ((arg (pop args)))
	    (or (consp arg) (setq arg (list arg)))
	    (if (cddr arg) (cl--do-arglist (nth 2 arg) `(and ,restarg t)))
	    (let ((def (if (cdr arg) (nth 1 arg)
			 (or (car cl--bind-defs)
			     (nth 1 (assq (car arg) cl--bind-defs)))))
		  (poparg `(pop ,restarg)))
	      (and def cl--bind-enquote (setq def `',def))
	      (cl--do-arglist (car arg)
			     (if def `(if ,restarg ,poparg ,def) poparg))
	      (setq num (1+ num))))))
      (if (eq (car args) '&rest)
	  (let ((arg (cl-pop2 args)))
	    (if (consp arg) (cl--do-arglist arg restarg)))
	(or (eq (car args) '&key) (= safety 0) exactarg
	    (push `(if ,restarg
                       (signal 'wrong-number-of-arguments
                               (list
                                ,(and (not (eq cl--bind-block 'cl-none))
                                      `',cl--bind-block)
                                (+ ,num (length ,restarg)))))
                  cl--bind-forms)))
      (while (and (eq (car args) '&key) (pop args))
	(while (and args (not (memq (car args) cl--lambda-list-keywords)))
	  (let ((arg (pop args)))
	    (or (consp arg) (setq arg (list arg)))
	    (let* ((karg (if (consp (car arg)) (caar arg)
                           (let ((name (symbol-name (car arg))))
                             ;; Strip a leading underscore, since it only
                             ;; means that this argument is unused, but
                             ;; shouldn't affect the key's name (bug#12367).
                             (if (eq ?_ (aref name 0))
                                 (setq name (substring name 1)))
                             (intern (format ":%s" name)))))
		   (varg (if (consp (car arg)) (cl-cadar arg) (car arg)))
		   (def (if (cdr arg) (cadr arg)
			  (or (car cl--bind-defs) (cadr (assq varg cl--bind-defs)))))
		   (look `(memq ',karg ,restarg)))
	      (and def cl--bind-enquote (setq def `',def))
	      (if (cddr arg)
		  (let* ((temp (or (nth 2 arg) (make-symbol "--cl-var--")))
			 (val `(car (cdr ,temp))))
		    (cl--do-arglist temp look)
		    (cl--do-arglist varg
				   `(if ,temp
                                        (prog1 ,val (setq ,temp t))
                                      ,def)))
		(cl--do-arglist
		 varg
		 `(car (cdr ,(if (null def)
				 look
			       `(or ,look
                                    ,(if (eq (cl--const-expr-p def) t)
					 `'(nil ,(cl--const-expr-val def))
				       `(list nil ,def))))))))
	      (push karg keys)))))
      (setq keys (nreverse keys))
      (or (and (eq (car args) '&allow-other-keys) (pop args))
	  (null keys) (= safety 0)
	  (let* ((var (make-symbol "--cl-keys--"))
		 (allow '(:allow-other-keys))
		 (check `(while ,var
                           (cond
                            ((memq (car ,var) ',(append keys allow))
                             (setq ,var (cdr (cdr ,var))))
                            ((car (cdr (memq (quote ,@allow) ,restarg)))
                             (setq ,var nil))
                            (t
                             (error
                              ,(format "Keyword argument %%s not one of %s"
                                       keys)
                              (car ,var)))))))
	    (push `(let ((,var ,restarg)) ,check) cl--bind-forms)))
      (while (and (eq (car args) '&aux) (pop args))
	(while (and args (not (memq (car args) cl--lambda-list-keywords)))
	  (if (consp (car args))
	      (if (and cl--bind-enquote (cl-cadar args))
		  (cl--do-arglist (caar args)
				 `',(cadr (pop args)))
		(cl--do-arglist (caar args) (cadr (pop args))))
	    (cl--do-arglist (pop args) nil))))
      (if args (error "Malformed argument list %s" save-args)))))

(defun cl--arglist-args (args)
  (if (nlistp args) (list args)
    (let ((res nil) (kind nil) arg)
      (while (consp args)
	(setq arg (pop args))
	(if (memq arg cl--lambda-list-keywords) (setq kind arg)
	  (if (eq arg '&cl-defs) (pop args)
	    (and (consp arg) kind (setq arg (car arg)))
	    (and (consp arg) (cdr arg) (eq kind '&key) (setq arg (cadr arg)))
	    (setq res (nconc res (cl--arglist-args arg))))))
      (nconc res (and args (list args))))))

;;;###autoload
(defmacro cl-destructuring-bind (args expr &rest body)
  "Bind the variables in ARGS to the result of EXPR and execute BODY."
  (declare (indent 2)
           (debug (&define cl-macro-list def-form cl-declarations def-body)))
  (let* ((cl--bind-lets nil) (cl--bind-forms nil) (cl--bind-inits nil)
	 (cl--bind-defs nil) (cl--bind-block 'cl-none) (cl--bind-enquote nil))
    (cl--do-arglist (or args '(&aux)) expr)
    (append '(progn) cl--bind-inits
	    (list `(let* ,(nreverse cl--bind-lets)
                     ,@(nreverse cl--bind-forms) ,@body)))))


;;; The `cl-eval-when' form.

(defvar cl-not-toplevel nil)

;;;###autoload
(defmacro cl-eval-when (when &rest body)
  "Control when BODY is evaluated.
If `compile' is in WHEN, BODY is evaluated when compiled at top-level.
If `load' is in WHEN, BODY is evaluated when loaded after top-level compile.
If `eval' is in WHEN, BODY is evaluated when interpreted or at non-top-level.

\(fn (WHEN...) BODY...)"
  (declare (indent 1) (debug ((&rest &or "compile" "load" "eval") body)))
  (if (and (fboundp 'cl--compiling-file) (cl--compiling-file)
	   (not cl-not-toplevel) (not (boundp 'for-effect)))  ; horrible kludge
      (let ((comp (or (memq 'compile when) (memq :compile-toplevel when)))
	    (cl-not-toplevel t))
	(if (or (memq 'load when) (memq :load-toplevel when))
	    (if comp (cons 'progn (mapcar 'cl--compile-time-too body))
	      `(if nil nil ,@body))
	  (progn (if comp (eval (cons 'progn body))) nil)))
    (and (or (memq 'eval when) (memq :execute when))
	 (cons 'progn body))))

(defun cl--compile-time-too (form)
  (or (and (symbolp (car-safe form)) (get (car-safe form) 'byte-hunk-handler))
      (setq form (macroexpand
		  form (cons '(cl-eval-when) byte-compile-macro-environment))))
  (cond ((eq (car-safe form) 'progn)
	 (cons 'progn (mapcar 'cl--compile-time-too (cdr form))))
	((eq (car-safe form) 'cl-eval-when)
	 (let ((when (nth 1 form)))
	   (if (or (memq 'eval when) (memq :execute when))
	       `(cl-eval-when (compile ,@when) ,@(cddr form))
	     form)))
	(t (eval form) form)))

;;;###autoload
(defmacro cl-load-time-value (form &optional _read-only)
  "Like `progn', but evaluates the body at load time.
The result of the body appears to the compiler as a quoted constant."
  (declare (debug (form &optional sexp)))
  (if (cl--compiling-file)
      (let* ((temp (cl-gentemp "--cl-load-time--"))
	     (set `(set ',temp ,form)))
	(if (and (fboundp 'byte-compile-file-form-defmumble)
		 (boundp 'this-kind) (boundp 'that-one))
	    (fset 'byte-compile-file-form
		  `(lambda (form)
                     (fset 'byte-compile-file-form
                           ',(symbol-function 'byte-compile-file-form))
                     (byte-compile-file-form ',set)
                     (byte-compile-file-form form)))
	  (print set (symbol-value 'byte-compile--outbuffer)))
	`(symbol-value ',temp))
    `',(eval form)))


;;; Conditional control structures.

;;;###autoload
(defmacro cl-case (expr &rest clauses)
  "Eval EXPR and choose among clauses on that value.
Each clause looks like (KEYLIST BODY...).  EXPR is evaluated and compared
against each key in each KEYLIST; the corresponding BODY is evaluated.
If no clause succeeds, cl-case returns nil.  A single atom may be used in
place of a KEYLIST of one atom.  A KEYLIST of t or `otherwise' is
allowed only in the final clause, and matches if no other keys match.
Key values are compared by `eql'.
\n(fn EXPR (KEYLIST BODY...)...)"
  (declare (indent 1) (debug (form &rest (sexp body))))
  (let* ((temp (if (cl--simple-expr-p expr 3) expr (make-symbol "--cl-var--")))
	 (head-list nil)
	 (body (cons
		'cond
		(mapcar
		 (function
		  (lambda (c)
		    (cons (cond ((memq (car c) '(t otherwise)) t)
				((eq (car c) 'cl--ecase-error-flag)
				 `(error "cl-ecase failed: %s, %s"
                                         ,temp ',(reverse head-list)))
				((listp (car c))
				 (setq head-list (append (car c) head-list))
				 `(cl-member ,temp ',(car c)))
				(t
				 (if (memq (car c) head-list)
				     (error "Duplicate key in case: %s"
					    (car c)))
				 (push (car c) head-list)
				 `(eql ,temp ',(car c))))
			  (or (cdr c) '(nil)))))
		 clauses))))
    (if (eq temp expr) body
      `(let ((,temp ,expr)) ,body))))

;;;###autoload
(defmacro cl-ecase (expr &rest clauses)
  "Like `cl-case', but error if no case fits.
`otherwise'-clauses are not allowed.
\n(fn EXPR (KEYLIST BODY...)...)"
  (declare (indent 1) (debug cl-case))
  `(cl-case ,expr ,@clauses (cl--ecase-error-flag)))

;;;###autoload
(defmacro cl-typecase (expr &rest clauses)
  "Evals EXPR, chooses among clauses on that value.
Each clause looks like (TYPE BODY...).  EXPR is evaluated and, if it
satisfies TYPE, the corresponding BODY is evaluated.  If no clause succeeds,
cl-typecase returns nil.  A TYPE of t or `otherwise' is allowed only in the
final clause, and matches if no other keys match.
\n(fn EXPR (TYPE BODY...)...)"
  (declare (indent 1)
           (debug (form &rest ([&or cl-type-spec "otherwise"] body))))
  (let* ((temp (if (cl--simple-expr-p expr 3) expr (make-symbol "--cl-var--")))
	 (type-list nil)
	 (body (cons
		'cond
		(mapcar
		 (function
		  (lambda (c)
		    (cons (cond ((eq (car c) 'otherwise) t)
				((eq (car c) 'cl--ecase-error-flag)
				 `(error "cl-etypecase failed: %s, %s"
                                         ,temp ',(reverse type-list)))
				(t
				 (push (car c) type-list)
				 (cl--make-type-test temp (car c))))
			  (or (cdr c) '(nil)))))
		 clauses))))
    (if (eq temp expr) body
      `(let ((,temp ,expr)) ,body))))

;;;###autoload
(defmacro cl-etypecase (expr &rest clauses)
  "Like `cl-typecase', but error if no case fits.
`otherwise'-clauses are not allowed.
\n(fn EXPR (TYPE BODY...)...)"
  (declare (indent 1) (debug cl-typecase))
  `(cl-typecase ,expr ,@clauses (cl--ecase-error-flag)))


;;; Blocks and exits.

;;;###autoload
(defmacro cl-block (name &rest body)
  "Define a lexically-scoped block named NAME.
NAME may be any symbol.  Code inside the BODY forms can call `cl-return-from'
to jump prematurely out of the block.  This differs from `catch' and `throw'
in two respects:  First, the NAME is an unevaluated symbol rather than a
quoted symbol or other form; and second, NAME is lexically rather than
dynamically scoped:  Only references to it within BODY will work.  These
references may appear inside macro expansions, but not inside functions
called from BODY."
  (declare (indent 1) (debug (symbolp body)))
  (if (cl--safe-expr-p `(progn ,@body)) `(progn ,@body)
    `(cl--block-wrapper
      (catch ',(intern (format "--cl-block-%s--" name))
        ,@body))))

;;;###autoload
(defmacro cl-return (&optional result)
  "Return from the block named nil.
This is equivalent to `(cl-return-from nil RESULT)'."
  (declare (debug (&optional form)))
  `(cl-return-from nil ,result))

;;;###autoload
(defmacro cl-return-from (name &optional result)
  "Return from the block named NAME.
This jumps out to the innermost enclosing `(cl-block NAME ...)' form,
returning RESULT from that form (or nil if RESULT is omitted).
This is compatible with Common Lisp, but note that `defun' and
`defmacro' do not create implicit blocks as they do in Common Lisp."
  (declare (indent 1) (debug (symbolp &optional form)))
  (let ((name2 (intern (format "--cl-block-%s--" name))))
    `(cl--block-throw ',name2 ,result)))


;;; The "cl-loop" macro.

(defvar cl--loop-args) (defvar cl--loop-accum-var) (defvar cl--loop-accum-vars)
(defvar cl--loop-bindings) (defvar cl--loop-body) (defvar cl--loop-destr-temps)
(defvar cl--loop-finally) (defvar cl--loop-finish-flag)
(defvar cl--loop-first-flag)
(defvar cl--loop-initially) (defvar cl--loop-map-form) (defvar cl--loop-name)
(defvar cl--loop-result) (defvar cl--loop-result-explicit)
(defvar cl--loop-result-var) (defvar cl--loop-steps) (defvar cl--loop-symbol-macs)

;;;###autoload
(defmacro cl-loop (&rest loop-args)
  "The Common Lisp `loop' macro.
Valid clauses are:
  for VAR from/upfrom/downfrom NUM to/upto/downto/above/below NUM by NUM,
  for VAR in LIST by FUNC, for VAR on LIST by FUNC, for VAR = INIT then EXPR,
  for VAR across ARRAY, repeat NUM, with VAR = INIT, while COND, until COND,
  always COND, never COND, thereis COND, collect EXPR into VAR,
  append EXPR into VAR, nconc EXPR into VAR, sum EXPR into VAR,
  count EXPR into VAR, maximize EXPR into VAR, minimize EXPR into VAR,
  if COND CLAUSE [and CLAUSE]... else CLAUSE [and CLAUSE...],
  unless COND CLAUSE [and CLAUSE]... else CLAUSE [and CLAUSE...],
  do EXPRS..., initially EXPRS..., finally EXPRS..., return EXPR,
  finally return EXPR, named NAME.

\(fn CLAUSE...)"
  (declare (debug (&rest &or
                         ;; These are usually followed by a symbol, but it can
                         ;; actually be any destructuring-bind pattern, which
                         ;; would erroneously match `form'.
                         [[&or "for" "as" "with" "and"] sexp]
                         ;; These are followed by expressions which could
                         ;; erroneously match `symbolp'.
                         [[&or "from" "upfrom" "downfrom" "to" "upto" "downto"
                               "above" "below" "by" "in" "on" "=" "across"
                               "repeat" "while" "until" "always" "never"
                               "thereis" "collect" "append" "nconc" "sum"
                               "count" "maximize" "minimize" "if" "unless"
                               "return"] form]
                         ;; Simple default, which covers 99% of the cases.
                         symbolp form)))
  (if (not (memq t (mapcar 'symbolp (delq nil (delq t (cl-copy-list loop-args))))))
      `(cl-block nil (while t ,@loop-args))
    (let ((cl--loop-args loop-args) (cl--loop-name nil) (cl--loop-bindings nil)
	  (cl--loop-body nil)	(cl--loop-steps nil)
	  (cl--loop-result nil)	(cl--loop-result-explicit nil)
	  (cl--loop-result-var nil) (cl--loop-finish-flag nil)
	  (cl--loop-accum-var nil)	(cl--loop-accum-vars nil)
	  (cl--loop-initially nil)	(cl--loop-finally nil)
	  (cl--loop-map-form nil)   (cl--loop-first-flag nil)
	  (cl--loop-destr-temps nil) (cl--loop-symbol-macs nil))
      (setq cl--loop-args (append cl--loop-args '(cl-end-loop)))
      (while (not (eq (car cl--loop-args) 'cl-end-loop)) (cl-parse-loop-clause))
      (if cl--loop-finish-flag
	  (push `((,cl--loop-finish-flag t)) cl--loop-bindings))
      (if cl--loop-first-flag
	  (progn (push `((,cl--loop-first-flag t)) cl--loop-bindings)
		 (push `(setq ,cl--loop-first-flag nil) cl--loop-steps)))
      (let* ((epilogue (nconc (nreverse cl--loop-finally)
			      (list (or cl--loop-result-explicit cl--loop-result))))
	     (ands (cl--loop-build-ands (nreverse cl--loop-body)))
	     (while-body (nconc (cadr ands) (nreverse cl--loop-steps)))
	     (body (append
		    (nreverse cl--loop-initially)
		    (list (if cl--loop-map-form
			      `(cl-block --cl-finish--
                                 ,(cl-subst
                                   (if (eq (car ands) t) while-body
                                     (cons `(or ,(car ands)
                                                (cl-return-from --cl-finish--
                                                  nil))
                                           while-body))
                                   '--cl-map cl--loop-map-form))
			    `(while ,(car ands) ,@while-body)))
		    (if cl--loop-finish-flag
			(if (equal epilogue '(nil)) (list cl--loop-result-var)
			  `((if ,cl--loop-finish-flag
				(progn ,@epilogue) ,cl--loop-result-var)))
		      epilogue))))
	(if cl--loop-result-var (push (list cl--loop-result-var) cl--loop-bindings))
	(while cl--loop-bindings
	  (if (cdar cl--loop-bindings)
	      (setq body (list (cl--loop-let (pop cl--loop-bindings) body t)))
	    (let ((lets nil))
	      (while (and cl--loop-bindings
			  (not (cdar cl--loop-bindings)))
		(push (car (pop cl--loop-bindings)) lets))
	      (setq body (list (cl--loop-let lets body nil))))))
	(if cl--loop-symbol-macs
	    (setq body (list `(cl-symbol-macrolet ,cl--loop-symbol-macs ,@body))))
	`(cl-block ,cl--loop-name ,@body)))))

;; Below is a complete spec for cl-loop, in several parts that correspond
;; to the syntax given in CLtL2.  The specs do more than specify where
;; the forms are; it also specifies, as much as Edebug allows, all the
;; syntactically valid cl-loop clauses.  The disadvantage of this
;; completeness is rigidity, but the "for ... being" clause allows
;; arbitrary extensions of the form: [symbolp &rest &or symbolp form].

;; (def-edebug-spec cl-loop
;;   ([&optional ["named" symbolp]]
;;    [&rest
;;     &or
;;     ["repeat" form]
;;     loop-for-as
;;     loop-with
;;     loop-initial-final]
;;    [&rest loop-clause]
;;    ))

;; (def-edebug-spec loop-with
;;   ("with" loop-var
;;    loop-type-spec
;;    [&optional ["=" form]]
;;    &rest ["and" loop-var
;; 	  loop-type-spec
;; 	  [&optional ["=" form]]]))

;; (def-edebug-spec loop-for-as
;;   ([&or "for" "as"] loop-for-as-subclause
;;    &rest ["and" loop-for-as-subclause]))

;; (def-edebug-spec loop-for-as-subclause
;;   (loop-var
;;    loop-type-spec
;;    &or
;;    [[&or "in" "on" "in-ref" "across-ref"]
;;     form &optional ["by" function-form]]

;;    ["=" form &optional ["then" form]]
;;    ["across" form]
;;    ["being"
;;     [&or "the" "each"]
;;     &or
;;     [[&or "element" "elements"]
;;      [&or "of" "in" "of-ref"] form
;;      &optional "using" ["index" symbolp]];; is this right?
;;     [[&or "hash-key" "hash-keys"
;; 	  "hash-value" "hash-values"]
;;      [&or "of" "in"]
;;      hash-table-p &optional ["using" ([&or "hash-value" "hash-values"
;; 					   "hash-key" "hash-keys"] sexp)]]

;;     [[&or "symbol" "present-symbol" "external-symbol"
;; 	  "symbols" "present-symbols" "external-symbols"]
;;      [&or "in" "of"] package-p]

;;     ;; Extensions for Emacs Lisp, including Lucid Emacs.
;;     [[&or "frame" "frames"
;; 	  "screen" "screens"
;; 	  "buffer" "buffers"]]

;;     [[&or "window" "windows"]
;;      [&or "of" "in"] form]

;;     [[&or "overlay" "overlays"
;; 	  "extent" "extents"]
;;      [&or "of" "in"] form
;;      &optional [[&or "from" "to"] form]]

;;     [[&or "interval" "intervals"]
;;      [&or "in" "of"] form
;;      &optional [[&or "from" "to"] form]
;;      ["property" form]]

;;     [[&or "key-code" "key-codes"
;; 	  "key-seq" "key-seqs"
;; 	  "key-binding" "key-bindings"]
;;      [&or "in" "of"] form
;;      &optional ["using" ([&or "key-code" "key-codes"
;; 			      "key-seq" "key-seqs"
;; 			      "key-binding" "key-bindings"]
;; 			 sexp)]]
;;     ;; For arbitrary extensions, recognize anything else.
;;     [symbolp &rest &or symbolp form]
;;     ]

;;    ;; arithmetic - must be last since all parts are optional.
;;    [[&optional [[&or "from" "downfrom" "upfrom"] form]]
;;     [&optional [[&or "to" "downto" "upto" "below" "above"] form]]
;;     [&optional ["by" form]]
;;     ]))

;; (def-edebug-spec loop-initial-final
;;   (&or ["initially"
;; 	;; [&optional &or "do" "doing"]  ;; CLtL2 doesn't allow this.
;; 	&rest loop-non-atomic-expr]
;;        ["finally" &or
;; 	[[&optional &or "do" "doing"] &rest loop-non-atomic-expr]
;; 	["return" form]]))

;; (def-edebug-spec loop-and-clause
;;   (loop-clause &rest ["and" loop-clause]))

;; (def-edebug-spec loop-clause
;;   (&or
;;    [[&or "while" "until" "always" "never" "thereis"] form]

;;    [[&or "collect" "collecting"
;; 	 "append" "appending"
;; 	 "nconc" "nconcing"
;; 	 "concat" "vconcat"] form
;; 	 [&optional ["into" loop-var]]]

;;    [[&or "count" "counting"
;; 	 "sum" "summing"
;; 	 "maximize" "maximizing"
;; 	 "minimize" "minimizing"] form
;; 	 [&optional ["into" loop-var]]
;; 	 loop-type-spec]

;;    [[&or "if" "when" "unless"]
;;     form loop-and-clause
;;     [&optional ["else" loop-and-clause]]
;;     [&optional "end"]]

;;    [[&or "do" "doing"] &rest loop-non-atomic-expr]

;;    ["return" form]
;;    loop-initial-final
;;    ))

;; (def-edebug-spec loop-non-atomic-expr
;;   ([&not atom] form))

;; (def-edebug-spec loop-var
;;   ;; The symbolp must be last alternative to recognize e.g. (a b . c)
;;   ;; loop-var =>
;;   ;; (loop-var . [&or nil loop-var])
;;   ;; (symbolp . [&or nil loop-var])
;;   ;; (symbolp . loop-var)
;;   ;; (symbolp . (symbolp . [&or nil loop-var]))
;;   ;; (symbolp . (symbolp . loop-var))
;;   ;; (symbolp . (symbolp . symbolp)) == (symbolp symbolp . symbolp)
;;   (&or (loop-var . [&or nil loop-var]) [gate symbolp]))

;; (def-edebug-spec loop-type-spec
;;   (&optional ["of-type" loop-d-type-spec]))

;; (def-edebug-spec loop-d-type-spec
;;   (&or (loop-d-type-spec . [&or nil loop-d-type-spec]) cl-type-spec))



(defun cl-parse-loop-clause ()		; uses loop-*
  (let ((word (pop cl--loop-args))
	(hash-types '(hash-key hash-keys hash-value hash-values))
	(key-types '(key-code key-codes key-seq key-seqs
		     key-binding key-bindings)))
    (cond

     ((null cl--loop-args)
      (error "Malformed `cl-loop' macro"))

     ((eq word 'named)
      (setq cl--loop-name (pop cl--loop-args)))

     ((eq word 'initially)
      (if (memq (car cl--loop-args) '(do doing)) (pop cl--loop-args))
      (or (consp (car cl--loop-args)) (error "Syntax error on `initially' clause"))
      (while (consp (car cl--loop-args))
	(push (pop cl--loop-args) cl--loop-initially)))

     ((eq word 'finally)
      (if (eq (car cl--loop-args) 'return)
	  (setq cl--loop-result-explicit (or (cl-pop2 cl--loop-args) '(quote nil)))
	(if (memq (car cl--loop-args) '(do doing)) (pop cl--loop-args))
	(or (consp (car cl--loop-args)) (error "Syntax error on `finally' clause"))
	(if (and (eq (caar cl--loop-args) 'return) (null cl--loop-name))
	    (setq cl--loop-result-explicit (or (nth 1 (pop cl--loop-args)) '(quote nil)))
	  (while (consp (car cl--loop-args))
	    (push (pop cl--loop-args) cl--loop-finally)))))

     ((memq word '(for as))
      (let ((loop-for-bindings nil) (loop-for-sets nil) (loop-for-steps nil)
	    (ands nil))
	(while
	    ;; Use `cl-gensym' rather than `make-symbol'.  It's important that
	    ;; (not (eq (symbol-name var1) (symbol-name var2))) because
	    ;; these vars get added to the macro-environment.
	    (let ((var (or (pop cl--loop-args) (cl-gensym "--cl-var--"))))
	      (setq word (pop cl--loop-args))
	      (if (eq word 'being) (setq word (pop cl--loop-args)))
	      (if (memq word '(the each)) (setq word (pop cl--loop-args)))
	      (if (memq word '(buffer buffers))
		  (setq word 'in cl--loop-args (cons '(buffer-list) cl--loop-args)))
	      (cond

	       ((memq word '(from downfrom upfrom to downto upto
			     above below by))
		(push word cl--loop-args)
		(if (memq (car cl--loop-args) '(downto above))
		    (error "Must specify `from' value for downward cl-loop"))
		(let* ((down (or (eq (car cl--loop-args) 'downfrom)
				 (memq (cl-caddr cl--loop-args) '(downto above))))
		       (excl (or (memq (car cl--loop-args) '(above below))
				 (memq (cl-caddr cl--loop-args) '(above below))))
		       (start (and (memq (car cl--loop-args) '(from upfrom downfrom))
				   (cl-pop2 cl--loop-args)))
		       (end (and (memq (car cl--loop-args)
				       '(to upto downto above below))
				 (cl-pop2 cl--loop-args)))
		       (step (and (eq (car cl--loop-args) 'by) (cl-pop2 cl--loop-args)))
		       (end-var (and (not (macroexp-const-p end))
				     (make-symbol "--cl-var--")))
		       (step-var (and (not (macroexp-const-p step))
				      (make-symbol "--cl-var--"))))
		  (and step (numberp step) (<= step 0)
		       (error "Loop `by' value is not positive: %s" step))
		  (push (list var (or start 0)) loop-for-bindings)
		  (if end-var (push (list end-var end) loop-for-bindings))
		  (if step-var (push (list step-var step)
				     loop-for-bindings))
		  (if end
		      (push (list
			     (if down (if excl '> '>=) (if excl '< '<=))
			     var (or end-var end)) cl--loop-body))
		  (push (list var (list (if down '- '+) var
					(or step-var step 1)))
			loop-for-steps)))

	       ((memq word '(in in-ref on))
		(let* ((on (eq word 'on))
		       (temp (if (and on (symbolp var))
				 var (make-symbol "--cl-var--"))))
		  (push (list temp (pop cl--loop-args)) loop-for-bindings)
		  (push `(consp ,temp) cl--loop-body)
		  (if (eq word 'in-ref)
		      (push (list var `(car ,temp)) cl--loop-symbol-macs)
		    (or (eq temp var)
			(progn
			  (push (list var nil) loop-for-bindings)
			  (push (list var (if on temp `(car ,temp)))
				loop-for-sets))))
		  (push (list temp
			      (if (eq (car cl--loop-args) 'by)
				  (let ((step (cl-pop2 cl--loop-args)))
				    (if (and (memq (car-safe step)
						   '(quote function
							   cl-function))
					     (symbolp (nth 1 step)))
					(list (nth 1 step) temp)
				      `(funcall ,step ,temp)))
				`(cdr ,temp)))
			loop-for-steps)))

	       ((eq word '=)
		(let* ((start (pop cl--loop-args))
		       (then (if (eq (car cl--loop-args) 'then) (cl-pop2 cl--loop-args) start)))
		  (push (list var nil) loop-for-bindings)
		  (if (or ands (eq (car cl--loop-args) 'and))
		      (progn
			(push `(,var
				(if ,(or cl--loop-first-flag
					 (setq cl--loop-first-flag
					       (make-symbol "--cl-var--")))
				    ,start ,var))
			      loop-for-sets)
			(push (list var then) loop-for-steps))
		    (push (list var
				(if (eq start then) start
				  `(if ,(or cl--loop-first-flag
					    (setq cl--loop-first-flag
						  (make-symbol "--cl-var--")))
				       ,start ,then)))
			  loop-for-sets))))

	       ((memq word '(across across-ref))
		(let ((temp-vec (make-symbol "--cl-vec--"))
		      (temp-idx (make-symbol "--cl-idx--")))
		  (push (list temp-vec (pop cl--loop-args)) loop-for-bindings)
		  (push (list temp-idx -1) loop-for-bindings)
		  (push `(< (setq ,temp-idx (1+ ,temp-idx))
                            (length ,temp-vec)) cl--loop-body)
		  (if (eq word 'across-ref)
		      (push (list var `(aref ,temp-vec ,temp-idx))
			    cl--loop-symbol-macs)
		    (push (list var nil) loop-for-bindings)
		    (push (list var `(aref ,temp-vec ,temp-idx))
			  loop-for-sets))))

	       ((memq word '(element elements))
		(let ((ref (or (memq (car cl--loop-args) '(in-ref of-ref))
			       (and (not (memq (car cl--loop-args) '(in of)))
				    (error "Expected `of'"))))
		      (seq (cl-pop2 cl--loop-args))
		      (temp-seq (make-symbol "--cl-seq--"))
		      (temp-idx (if (eq (car cl--loop-args) 'using)
				    (if (and (= (length (cadr cl--loop-args)) 2)
					     (eq (cl-caadr cl--loop-args) 'index))
					(cadr (cl-pop2 cl--loop-args))
				      (error "Bad `using' clause"))
				  (make-symbol "--cl-idx--"))))
		  (push (list temp-seq seq) loop-for-bindings)
		  (push (list temp-idx 0) loop-for-bindings)
		  (if ref
		      (let ((temp-len (make-symbol "--cl-len--")))
			(push (list temp-len `(length ,temp-seq))
			      loop-for-bindings)
			(push (list var `(elt ,temp-seq ,temp-idx))
			      cl--loop-symbol-macs)
			(push `(< ,temp-idx ,temp-len) cl--loop-body))
		    (push (list var nil) loop-for-bindings)
		    (push `(and ,temp-seq
				(or (consp ,temp-seq)
                                    (< ,temp-idx (length ,temp-seq))))
			  cl--loop-body)
		    (push (list var `(if (consp ,temp-seq)
                                         (pop ,temp-seq)
                                       (aref ,temp-seq ,temp-idx)))
			  loop-for-sets))
		  (push (list temp-idx `(1+ ,temp-idx))
			loop-for-steps)))

	       ((memq word hash-types)
		(or (memq (car cl--loop-args) '(in of)) (error "Expected `of'"))
		(let* ((table (cl-pop2 cl--loop-args))
		       (other (if (eq (car cl--loop-args) 'using)
				  (if (and (= (length (cadr cl--loop-args)) 2)
					   (memq (cl-caadr cl--loop-args) hash-types)
					   (not (eq (cl-caadr cl--loop-args) word)))
				      (cadr (cl-pop2 cl--loop-args))
				    (error "Bad `using' clause"))
				(make-symbol "--cl-var--"))))
		  (if (memq word '(hash-value hash-values))
		      (setq var (prog1 other (setq other var))))
		  (setq cl--loop-map-form
			`(maphash (lambda (,var ,other) . --cl-map) ,table))))

	       ((memq word '(symbol present-symbol external-symbol
			     symbols present-symbols external-symbols))
		(let ((ob (and (memq (car cl--loop-args) '(in of)) (cl-pop2 cl--loop-args))))
		  (setq cl--loop-map-form
			`(mapatoms (lambda (,var) . --cl-map) ,ob))))

	       ((memq word '(overlay overlays extent extents))
		(let ((buf nil) (from nil) (to nil))
		  (while (memq (car cl--loop-args) '(in of from to))
		    (cond ((eq (car cl--loop-args) 'from) (setq from (cl-pop2 cl--loop-args)))
			  ((eq (car cl--loop-args) 'to) (setq to (cl-pop2 cl--loop-args)))
			  (t (setq buf (cl-pop2 cl--loop-args)))))
		  (setq cl--loop-map-form
			`(cl--map-overlays
			  (lambda (,var ,(make-symbol "--cl-var--"))
			    (progn . --cl-map) nil)
			  ,buf ,from ,to))))

	       ((memq word '(interval intervals))
		(let ((buf nil) (prop nil) (from nil) (to nil)
		      (var1 (make-symbol "--cl-var1--"))
		      (var2 (make-symbol "--cl-var2--")))
		  (while (memq (car cl--loop-args) '(in of property from to))
		    (cond ((eq (car cl--loop-args) 'from) (setq from (cl-pop2 cl--loop-args)))
			  ((eq (car cl--loop-args) 'to) (setq to (cl-pop2 cl--loop-args)))
			  ((eq (car cl--loop-args) 'property)
			   (setq prop (cl-pop2 cl--loop-args)))
			  (t (setq buf (cl-pop2 cl--loop-args)))))
		  (if (and (consp var) (symbolp (car var)) (symbolp (cdr var)))
		      (setq var1 (car var) var2 (cdr var))
		    (push (list var `(cons ,var1 ,var2)) loop-for-sets))
		  (setq cl--loop-map-form
			`(cl--map-intervals
			  (lambda (,var1 ,var2) . --cl-map)
			  ,buf ,prop ,from ,to))))

	       ((memq word key-types)
		(or (memq (car cl--loop-args) '(in of)) (error "Expected `of'"))
		(let ((cl-map (cl-pop2 cl--loop-args))
		      (other (if (eq (car cl--loop-args) 'using)
				 (if (and (= (length (cadr cl--loop-args)) 2)
					  (memq (cl-caadr cl--loop-args) key-types)
					  (not (eq (cl-caadr cl--loop-args) word)))
				     (cadr (cl-pop2 cl--loop-args))
				   (error "Bad `using' clause"))
			       (make-symbol "--cl-var--"))))
		  (if (memq word '(key-binding key-bindings))
		      (setq var (prog1 other (setq other var))))
		  (setq cl--loop-map-form
			`(,(if (memq word '(key-seq key-seqs))
			       'cl--map-keymap-recursively 'map-keymap)
			  (lambda (,var ,other) . --cl-map) ,cl-map))))

	       ((memq word '(frame frames screen screens))
		(let ((temp (make-symbol "--cl-var--")))
		  (push (list var  '(selected-frame))
			loop-for-bindings)
		  (push (list temp nil) loop-for-bindings)
		  (push `(prog1 (not (eq ,var ,temp))
                           (or ,temp (setq ,temp ,var)))
			cl--loop-body)
		  (push (list var `(next-frame ,var))
			loop-for-steps)))

	       ((memq word '(window windows))
		(let ((scr (and (memq (car cl--loop-args) '(in of)) (cl-pop2 cl--loop-args)))
		      (temp (make-symbol "--cl-var--"))
		      (minip (make-symbol "--cl-minip--")))
		  (push (list var (if scr
				      `(frame-selected-window ,scr)
				    '(selected-window)))
			loop-for-bindings)
		  ;; If we started in the minibuffer, we need to
		  ;; ensure that next-window will bring us back there
		  ;; at some point.  (Bug#7492).
		  ;; (Consider using walk-windows instead of cl-loop if
		  ;; you care about such things.)
		  (push (list minip `(minibufferp (window-buffer ,var)))
			loop-for-bindings)
		  (push (list temp nil) loop-for-bindings)
		  (push `(prog1 (not (eq ,var ,temp))
                           (or ,temp (setq ,temp ,var)))
			cl--loop-body)
		  (push (list var `(next-window ,var ,minip))
			loop-for-steps)))

	       (t
		;; This is an advertised interface: (info "(cl)Other Clauses").
		(let ((handler (and (symbolp word)
				    (get word 'cl-loop-for-handler))))
		  (if handler
		      (funcall handler var)
		    (error "Expected a `for' preposition, found %s" word)))))
	      (eq (car cl--loop-args) 'and))
	  (setq ands t)
	  (pop cl--loop-args))
	(if (and ands loop-for-bindings)
	    (push (nreverse loop-for-bindings) cl--loop-bindings)
	  (setq cl--loop-bindings (nconc (mapcar 'list loop-for-bindings)
				     cl--loop-bindings)))
	(if loop-for-sets
	    (push `(progn
                     ,(cl--loop-let (nreverse loop-for-sets) 'setq ands)
                     t) cl--loop-body))
	(if loop-for-steps
	    (push (cons (if ands 'cl-psetq 'setq)
			(apply 'append (nreverse loop-for-steps)))
		  cl--loop-steps))))

     ((eq word 'repeat)
      (let ((temp (make-symbol "--cl-var--")))
	(push (list (list temp (pop cl--loop-args))) cl--loop-bindings)
	(push `(>= (setq ,temp (1- ,temp)) 0) cl--loop-body)))

     ((memq word '(collect collecting))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum nil 'nreverse)))
	(if (eq var cl--loop-accum-var)
	    (push `(progn (push ,what ,var) t) cl--loop-body)
	  (push `(progn
                   (setq ,var (nconc ,var (list ,what)))
                   t) cl--loop-body))))

     ((memq word '(nconc nconcing append appending))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum nil 'nreverse)))
	(push `(progn
                 (setq ,var
                       ,(if (eq var cl--loop-accum-var)
                            `(nconc
                              (,(if (memq word '(nconc nconcing))
                                    #'nreverse #'reverse)
                               ,what)
                              ,var)
                          `(,(if (memq word '(nconc nconcing))
                                 #'nconc #'append)
                            ,var ,what))) t) cl--loop-body)))

     ((memq word '(concat concating))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum "")))
	(push `(progn (cl-callf concat ,var ,what) t) cl--loop-body)))

     ((memq word '(vconcat vconcating))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum [])))
	(push `(progn (cl-callf vconcat ,var ,what) t) cl--loop-body)))

     ((memq word '(sum summing))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum 0)))
	(push `(progn (cl-incf ,var ,what) t) cl--loop-body)))

     ((memq word '(count counting))
      (let ((what (pop cl--loop-args))
	    (var (cl--loop-handle-accum 0)))
	(push `(progn (if ,what (cl-incf ,var)) t) cl--loop-body)))

     ((memq word '(minimize minimizing maximize maximizing))
      (let* ((what (pop cl--loop-args))
	     (temp (if (cl--simple-expr-p what) what (make-symbol "--cl-var--")))
	     (var (cl--loop-handle-accum nil))
	     (func (intern (substring (symbol-name word) 0 3)))
	     (set `(setq ,var (if ,var (,func ,var ,temp) ,temp))))
	(push `(progn ,(if (eq temp what) set
                         `(let ((,temp ,what)) ,set))
                      t) cl--loop-body)))

     ((eq word 'with)
      (let ((bindings nil))
	(while (progn (push (list (pop cl--loop-args)
				  (and (eq (car cl--loop-args) '=) (cl-pop2 cl--loop-args)))
			    bindings)
		      (eq (car cl--loop-args) 'and))
	  (pop cl--loop-args))
	(push (nreverse bindings) cl--loop-bindings)))

     ((eq word 'while)
      (push (pop cl--loop-args) cl--loop-body))

     ((eq word 'until)
      (push `(not ,(pop cl--loop-args)) cl--loop-body))

     ((eq word 'always)
      (or cl--loop-finish-flag (setq cl--loop-finish-flag (make-symbol "--cl-flag--")))
      (push `(setq ,cl--loop-finish-flag ,(pop cl--loop-args)) cl--loop-body)
      (setq cl--loop-result t))

     ((eq word 'never)
      (or cl--loop-finish-flag (setq cl--loop-finish-flag (make-symbol "--cl-flag--")))
      (push `(setq ,cl--loop-finish-flag (not ,(pop cl--loop-args)))
	    cl--loop-body)
      (setq cl--loop-result t))

     ((eq word 'thereis)
      (or cl--loop-finish-flag (setq cl--loop-finish-flag (make-symbol "--cl-flag--")))
      (or cl--loop-result-var (setq cl--loop-result-var (make-symbol "--cl-var--")))
      (push `(setq ,cl--loop-finish-flag
                   (not (setq ,cl--loop-result-var ,(pop cl--loop-args))))
	    cl--loop-body))

     ((memq word '(if when unless))
      (let* ((cond (pop cl--loop-args))
	     (then (let ((cl--loop-body nil))
		     (cl-parse-loop-clause)
		     (cl--loop-build-ands (nreverse cl--loop-body))))
	     (else (let ((cl--loop-body nil))
		     (if (eq (car cl--loop-args) 'else)
			 (progn (pop cl--loop-args) (cl-parse-loop-clause)))
		     (cl--loop-build-ands (nreverse cl--loop-body))))
	     (simple (and (eq (car then) t) (eq (car else) t))))
	(if (eq (car cl--loop-args) 'end) (pop cl--loop-args))
	(if (eq word 'unless) (setq then (prog1 else (setq else then))))
	(let ((form (cons (if simple (cons 'progn (nth 1 then)) (nth 2 then))
			  (if simple (nth 1 else) (list (nth 2 else))))))
	  (if (cl--expr-contains form 'it)
	      (let ((temp (make-symbol "--cl-var--")))
		(push (list temp) cl--loop-bindings)
		(setq form `(if (setq ,temp ,cond)
                                ,@(cl-subst temp 'it form))))
	    (setq form `(if ,cond ,@form)))
	  (push (if simple `(progn ,form t) form) cl--loop-body))))

     ((memq word '(do doing))
      (let ((body nil))
	(or (consp (car cl--loop-args)) (error "Syntax error on `do' clause"))
	(while (consp (car cl--loop-args)) (push (pop cl--loop-args) body))
	(push (cons 'progn (nreverse (cons t body))) cl--loop-body)))

     ((eq word 'return)
      (or cl--loop-finish-flag (setq cl--loop-finish-flag (make-symbol "--cl-var--")))
      (or cl--loop-result-var (setq cl--loop-result-var (make-symbol "--cl-var--")))
      (push `(setq ,cl--loop-result-var ,(pop cl--loop-args)
                   ,cl--loop-finish-flag nil) cl--loop-body))

     (t
      ;; This is an advertised interface: (info "(cl)Other Clauses").
      (let ((handler (and (symbolp word) (get word 'cl-loop-handler))))
	(or handler (error "Expected a cl-loop keyword, found %s" word))
	(funcall handler))))
    (if (eq (car cl--loop-args) 'and)
	(progn (pop cl--loop-args) (cl-parse-loop-clause)))))

(defun cl--loop-let (specs body par)   ; uses loop-*
  (let ((p specs) (temps nil) (new nil))
    (while (and p (or (symbolp (car-safe (car p))) (null (cl-cadar p))))
      (setq p (cdr p)))
    (and par p
	 (progn
	   (setq par nil p specs)
	   (while p
	     (or (macroexp-const-p (cl-cadar p))
		 (let ((temp (make-symbol "--cl-var--")))
		   (push (list temp (cl-cadar p)) temps)
		   (setcar (cdar p) temp)))
	     (setq p (cdr p)))))
    (while specs
      (if (and (consp (car specs)) (listp (caar specs)))
	  (let* ((spec (caar specs)) (nspecs nil)
		 (expr (cadr (pop specs)))
		 (temp (cdr (or (assq spec cl--loop-destr-temps)
				(car (push (cons spec (or (last spec 0)
							  (make-symbol "--cl-var--")))
					   cl--loop-destr-temps))))))
	    (push (list temp expr) new)
	    (while (consp spec)
	      (push (list (pop spec)
			     (and expr (list (if spec 'pop 'car) temp)))
		       nspecs))
	    (setq specs (nconc (nreverse nspecs) specs)))
	(push (pop specs) new)))
    (if (eq body 'setq)
	(let ((set (cons (if par 'cl-psetq 'setq) (apply 'nconc (nreverse new)))))
	  (if temps `(let* ,(nreverse temps) ,set) set))
      `(,(if par 'let 'let*)
        ,(nconc (nreverse temps) (nreverse new)) ,@body))))

(defun cl--loop-handle-accum (def &optional func)   ; uses loop-*
  (if (eq (car cl--loop-args) 'into)
      (let ((var (cl-pop2 cl--loop-args)))
	(or (memq var cl--loop-accum-vars)
	    (progn (push (list (list var def)) cl--loop-bindings)
		   (push var cl--loop-accum-vars)))
	var)
    (or cl--loop-accum-var
	(progn
	  (push (list (list (setq cl--loop-accum-var (make-symbol "--cl-var--")) def))
		   cl--loop-bindings)
	  (setq cl--loop-result (if func (list func cl--loop-accum-var)
			      cl--loop-accum-var))
	  cl--loop-accum-var))))

(defun cl--loop-build-ands (clauses)
  "Return various representations of (and . CLAUSES).
CLAUSES is a list of Elisp expressions, where clauses of the form
\(progn E1 E2 E3 .. t) are the focus of particular optimizations.
The return value has shape (COND BODY COMBO)
such that COMBO is equivalent to (and . CLAUSES)."
  (let ((ands nil)
	(body nil))
    ;; Look through `clauses', trying to optimize (progn ,@A t) (progn ,@B) ,@C
    ;; into (progn ,@A ,@B) ,@C.
    (while clauses
      (if (and (eq (car-safe (car clauses)) 'progn)
	       (eq (car (last (car clauses))) t))
	  (if (cdr clauses)
	      (setq clauses (cons (nconc (butlast (car clauses))
					 (if (eq (car-safe (cadr clauses))
						 'progn)
					     (cl-cdadr clauses)
					   (list (cadr clauses))))
				  (cddr clauses)))
            ;; A final (progn ,@A t) is moved outside of the `and'.
	    (setq body (cdr (butlast (pop clauses)))))
	(push (pop clauses) ands)))
    (setq ands (or (nreverse ands) (list t)))
    (list (if (cdr ands) (cons 'and ands) (car ands))
	  body
	  (let ((full (if body
			  (append ands (list (cons 'progn (append body '(t)))))
			ands)))
	    (if (cdr full) (cons 'and full) (car full))))))


;;; Other iteration control structures.

;;;###autoload
(defmacro cl-do (steps endtest &rest body)
  "The Common Lisp `do' loop.

\(fn ((VAR INIT [STEP])...) (END-TEST [RESULT...]) BODY...)"
  (declare (indent 2)
           (debug
            ((&rest &or symbolp (symbolp &optional form form))
             (form body)
             cl-declarations body)))
  (cl-expand-do-loop steps endtest body nil))

;;;###autoload
(defmacro cl-do* (steps endtest &rest body)
  "The Common Lisp `do*' loop.

\(fn ((VAR INIT [STEP])...) (END-TEST [RESULT...]) BODY...)"
  (declare (indent 2) (debug cl-do))
  (cl-expand-do-loop steps endtest body t))

(defun cl-expand-do-loop (steps endtest body star)
  `(cl-block nil
     (,(if star 'let* 'let)
      ,(mapcar (lambda (c) (if (consp c) (list (car c) (nth 1 c)) c))
               steps)
      (while (not ,(car endtest))
        ,@body
        ,@(let ((sets (mapcar (lambda (c)
                                (and (consp c) (cdr (cdr c))
                                     (list (car c) (nth 2 c))))
                              steps)))
            (setq sets (delq nil sets))
            (and sets
                 (list (cons (if (or star (not (cdr sets)))
                                 'setq 'cl-psetq)
                             (apply 'append sets))))))
      ,@(or (cdr endtest) '(nil)))))

;;;###autoload
(defmacro cl-dolist (spec &rest body)
  "Loop over a list.
Evaluate BODY with VAR bound to each `car' from LIST, in turn.
Then evaluate RESULT to get return value, default nil.
An implicit nil block is established around the loop.

\(fn (VAR LIST [RESULT]) BODY...)"
  (declare (debug ((symbolp form &optional form) cl-declarations body))
           (indent 1))
  `(cl-block nil
     (,(if (eq 'cl-dolist (symbol-function 'dolist)) 'cl--dolist 'dolist)
      ,spec ,@body)))

;;;###autoload
(defmacro cl-dotimes (spec &rest body)
  "Loop a certain number of times.
Evaluate BODY with VAR bound to successive integers from 0, inclusive,
to COUNT, exclusive.  Then evaluate RESULT to get return value, default
nil.

\(fn (VAR COUNT [RESULT]) BODY...)"
  (declare (debug cl-dolist) (indent 1))
  `(cl-block nil
     (,(if (eq 'cl-dotimes (symbol-function 'dotimes)) 'cl--dotimes 'dotimes)
      ,spec ,@body)))

;;;###autoload
(defmacro cl-do-symbols (spec &rest body)
  "Loop over all symbols.
Evaluate BODY with VAR bound to each interned symbol, or to each symbol
from OBARRAY.

\(fn (VAR [OBARRAY [RESULT]]) BODY...)"
  (declare (indent 1)
           (debug ((symbolp &optional form form) cl-declarations body)))
  ;; Apparently this doesn't have an implicit block.
  `(cl-block nil
     (let (,(car spec))
       (mapatoms #'(lambda (,(car spec)) ,@body)
                 ,@(and (cadr spec) (list (cadr spec))))
       ,(cl-caddr spec))))

;;;###autoload
(defmacro cl-do-all-symbols (spec &rest body)
  "Like `cl-do-symbols', but use the default obarray.

\(fn (VAR [RESULT]) BODY...)"
  (declare (indent 1) (debug ((symbolp &optional form) cl-declarations body)))
  `(cl-do-symbols (,(car spec) nil ,(cadr spec)) ,@body))


;;; Assignments.

;;;###autoload
(defmacro cl-psetq (&rest args)
  "Set SYMs to the values VALs in parallel.
This is like `setq', except that all VAL forms are evaluated (in order)
before assigning any symbols SYM to the corresponding values.

\(fn SYM VAL SYM VAL ...)"
  (declare (debug setq))
  (cons 'cl-psetf args))


;;; Binding control structures.

;;;###autoload
(defmacro cl-progv (symbols values &rest body)
  "Bind SYMBOLS to VALUES dynamically in BODY.
The forms SYMBOLS and VALUES are evaluated, and must evaluate to lists.
Each symbol in the first list is bound to the corresponding value in the
second list (or to nil if VALUES is shorter than SYMBOLS); then the
BODY forms are executed and their result is returned.  This is much like
a `let' form, except that the list of symbols can be computed at run-time."
  (declare (indent 2) (debug (form form body)))
  (let ((bodyfun (make-symbol "cl--progv-body"))
        (binds (make-symbol "binds"))
        (syms (make-symbol "syms"))
        (vals (make-symbol "vals")))
    `(progn
       (defvar ,bodyfun)
       (let* ((,syms ,symbols)
              (,vals ,values)
              (,bodyfun (lambda () ,@body))
              (,binds ()))
         (while ,syms
           (push (list (pop ,syms) (list 'quote (pop ,vals))) ,binds))
         (eval (list 'let ,binds '(funcall ,bodyfun)))))))

(defvar cl--labels-convert-cache nil)

(defun cl--labels-convert (f)
  "Special macro-expander to rename (function F) references in `cl-labels'."
  (cond
   ;; ¡¡Big Ugly Hack!! We can't use a compiler-macro because those are checked
   ;; *after* handling `function', but we want to stop macroexpansion from
   ;; being applied infinitely, so we use a cache to return the exact `form'
   ;; being expanded even though we don't receive it.
   ((eq f (car cl--labels-convert-cache)) (cdr cl--labels-convert-cache))
   (t
    (let ((found (assq f macroexpand-all-environment)))
      (if (and found (ignore-errors
                       (eq (cadr (cl-caddr found)) 'cl-labels-args)))
          (cadr (cl-caddr (cl-cadddr found)))
        (let ((res `(function ,f)))
          (setq cl--labels-convert-cache (cons f res))
          res))))))

;;;###autoload
(defmacro cl-flet (bindings &rest body)
  "Make local function definitions.
Like `cl-labels' but the definitions are not recursive.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)"
  (declare (indent 1) (debug ((&rest (cl-defun)) cl-declarations body)))
  (let ((binds ()) (newenv macroexpand-all-environment))
    (dolist (binding bindings)
      (let ((var (make-symbol (format "--cl-%s--" (car binding)))))
	(push (list var `(cl-function (lambda . ,(cdr binding)))) binds)
	(push (cons (car binding)
                    `(lambda (&rest cl-labels-args)
                       (cl-list* 'funcall ',var
                                 cl-labels-args)))
              newenv)))
    `(let ,(nreverse binds)
       ,@(macroexp-unprogn
          (macroexpand-all
           `(progn ,@body)
           ;; Don't override lexical-let's macro-expander.
           (if (assq 'function newenv) newenv
             (cons (cons 'function #'cl--labels-convert) newenv)))))))

;;;###autoload
(defmacro cl-flet* (bindings &rest body)
  "Make local function definitions.
Like `cl-flet' but the definitions can refer to previous ones.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)"
  (declare (indent 1) (debug cl-flet))
  (cond
   ((null bindings) (macroexp-progn body))
   ((null (cdr bindings)) `(cl-flet ,bindings ,@body))
   (t `(cl-flet (,(pop bindings)) (cl-flet* ,bindings ,@body)))))

;;;###autoload
(defmacro cl-labels (bindings &rest body)
  "Make temporary function bindings.
The bindings can be recursive and the scoping is lexical, but capturing them
in closures will only work if `lexical-binding' is in use.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)"
  (declare (indent 1) (debug cl-flet))
  (let ((binds ()) (newenv macroexpand-all-environment))
    (dolist (binding bindings)
      (let ((var (make-symbol (format "--cl-%s--" (car binding)))))
	(push (list var `(cl-function (lambda . ,(cdr binding)))) binds)
	(push (cons (car binding)
                    `(lambda (&rest cl-labels-args)
                       (cl-list* 'funcall ',var
                                 cl-labels-args)))
              newenv)))
    (macroexpand-all `(letrec ,(nreverse binds) ,@body)
                     ;; Don't override lexical-let's macro-expander.
                     (if (assq 'function newenv) newenv
                       (cons (cons 'function #'cl--labels-convert) newenv)))))

;; The following ought to have a better definition for use with newer
;; byte compilers.
;;;###autoload
(defmacro cl-macrolet (bindings &rest body)
  "Make temporary macro definitions.
This is like `cl-flet', but for macros instead of functions.

\(fn ((NAME ARGLIST BODY...) ...) FORM...)"
  (declare (indent 1)
           (debug
            ((&rest (&define name (&rest arg) cl-declarations-or-string
                             def-body))
             cl-declarations body)))
  (if (cdr bindings)
      `(cl-macrolet (,(car bindings)) (cl-macrolet ,(cdr bindings) ,@body))
    (if (null bindings) (cons 'progn body)
      (let* ((name (caar bindings))
	     (res (cl--transform-lambda (cdar bindings) name)))
	(eval (car res))
	(macroexpand-all (cons 'progn body)
                         (cons (cons name `(lambda ,@(cdr res)))
                               macroexpand-all-environment))))))

(defconst cl--old-macroexpand
  (if (and (boundp 'cl--old-macroexpand)
           (eq (symbol-function 'macroexpand)
               #'cl--sm-macroexpand))
      cl--old-macroexpand
    (symbol-function 'macroexpand)))

(defun cl--sm-macroexpand (exp &optional env)
  "Special macro expander used inside `cl-symbol-macrolet'.
This function replaces `macroexpand' during macro expansion
of `cl-symbol-macrolet', and does the same thing as `macroexpand'
except that it additionally expands symbol macros."
  (let ((macroexpand-all-environment env))
    (while
        (progn
          (setq exp (funcall cl--old-macroexpand exp env))
          (pcase exp
            ((pred symbolp)
             ;; Perform symbol-macro expansion.
             (when (cdr (assq (symbol-name exp) env))
               (setq exp (cadr (assq (symbol-name exp) env)))))
            (`(setq . ,_)
             ;; Convert setq to setf if required by symbol-macro expansion.
             (let* ((args (mapcar (lambda (f) (cl--sm-macroexpand f env))
                                  (cdr exp)))
                    (p args))
               (while (and p (symbolp (car p))) (setq p (cddr p)))
               (if p (setq exp (cons 'setf args))
                 (setq exp (cons 'setq args))
                 ;; Don't loop further.
                 nil)))
            (`(,(or `let `let*) . ,(or `(,bindings . ,body) dontcare))
             ;; CL's symbol-macrolet treats re-bindings as candidates for
             ;; expansion (turning the let into a letf if needed), contrary to
             ;; Common-Lisp where such re-bindings hide the symbol-macro.
             (let ((letf nil) (found nil) (nbs ()))
               (dolist (binding bindings)
                 (let* ((var (if (symbolp binding) binding (car binding)))
                        (sm (assq (symbol-name var) env)))
                   (push (if (not (cdr sm))
                             binding
                           (let ((nexp (cadr sm)))
                             (setq found t)
                             (unless (symbolp nexp) (setq letf t))
                             (cons nexp (cdr-safe binding))))
                         nbs)))
               (when found
                 (setq exp `(,(if letf
                                  (if (eq (car exp) 'let) 'cl-letf 'cl-letf*)
                                (car exp))
                             ,(nreverse nbs)
                             ,@body)))))
            ;; FIXME: The behavior of CL made sense in a dynamically scoped
            ;; language, but for lexical scoping, Common-Lisp's behavior might
            ;; make more sense (and indeed, CL behaves like Common-Lisp w.r.t
            ;; lexical-let), so maybe we should adjust the behavior based on
            ;; the use of lexical-binding.
            ;; (`(,(or `let `let*) . ,(or `(,bindings . ,body) dontcare))
            ;;  (let ((nbs ()) (found nil))
            ;;    (dolist (binding bindings)
            ;;      (let* ((var (if (symbolp binding) binding (car binding)))
            ;;             (name (symbol-name var))
            ;;             (val (and found (consp binding) (eq 'let* (car exp))
            ;;                       (list (macroexpand-all (cadr binding)
            ;;                                              env)))))
            ;;        (push (if (assq name env)
            ;;                  ;; This binding should hide its symbol-macro,
            ;;                  ;; but given the way macroexpand-all works, we
            ;;                  ;; can't prevent application of `env' to the
            ;;                  ;; sub-expressions, so we need to α-rename this
            ;;                  ;; variable instead.
            ;;                  (let ((nvar (make-symbol
            ;;                               (copy-sequence name))))
            ;;                    (setq found t)
            ;;                    (push (list name nvar) env)
            ;;                    (cons nvar (or val (cdr-safe binding))))
            ;;                (if val (cons var val) binding))
            ;;              nbs)))
            ;;    (when found
            ;;      (setq exp `(,(car exp)
            ;;                  ,(nreverse nbs)
            ;;                  ,@(macroexp-unprogn
            ;;                     (macroexpand-all (macroexp-progn body)
            ;;                                      env)))))
            ;;    nil))
            )))
    exp))

;;;###autoload
(defmacro cl-symbol-macrolet (bindings &rest body)
  "Make symbol macro definitions.
Within the body FORMs, references to the variable NAME will be replaced
by EXPANSION, and (setq NAME ...) will act like (setf EXPANSION ...).

\(fn ((NAME EXPANSION) ...) FORM...)"
  (declare (indent 1) (debug ((&rest (symbol sexp)) cl-declarations body)))
  (cond
   ((cdr bindings)
    `(cl-symbol-macrolet (,(car bindings))
       (cl-symbol-macrolet ,(cdr bindings) ,@body)))
   ((null bindings) (macroexp-progn body))
   (t
    (let ((previous-macroexpand (symbol-function 'macroexpand)))
      (unwind-protect
          (progn
            (fset 'macroexpand #'cl--sm-macroexpand)
            ;; FIXME: For N bindings, this will traverse `body' N times!
            (macroexpand-all (cons 'progn body)
                             (cons (list (symbol-name (caar bindings))
                                         (cl-cadar bindings))
                                   macroexpand-all-environment)))
        (fset 'macroexpand previous-macroexpand))))))

;;; Multiple values.

;;;###autoload
(defmacro cl-multiple-value-bind (vars form &rest body)
  "Collect multiple return values.
FORM must return a list; the BODY is then executed with the first N elements
of this list bound (`let'-style) to each of the symbols SYM in turn.  This
is analogous to the Common Lisp `cl-multiple-value-bind' macro, using lists to
simulate true multiple return values.  For compatibility, (cl-values A B C) is
a synonym for (list A B C).

\(fn (SYM...) FORM BODY)"
  (declare (indent 2) (debug ((&rest symbolp) form body)))
  (let ((temp (make-symbol "--cl-var--")) (n -1))
    `(let* ((,temp ,form)
            ,@(mapcar (lambda (v)
                        (list v `(nth ,(setq n (1+ n)) ,temp)))
                      vars))
       ,@body)))

;;;###autoload
(defmacro cl-multiple-value-setq (vars form)
  "Collect multiple return values.
FORM must return a list; the first N elements of this list are stored in
each of the symbols SYM in turn.  This is analogous to the Common Lisp
`cl-multiple-value-setq' macro, using lists to simulate true multiple return
values.  For compatibility, (cl-values A B C) is a synonym for (list A B C).

\(fn (SYM...) FORM)"
  (declare (indent 1) (debug ((&rest symbolp) form)))
  (cond ((null vars) `(progn ,form nil))
	((null (cdr vars)) `(setq ,(car vars) (car ,form)))
	(t
	 (let* ((temp (make-symbol "--cl-var--")) (n 0))
	   `(let ((,temp ,form))
              (prog1 (setq ,(pop vars) (car ,temp))
                (setq ,@(apply #'nconc
                               (mapcar (lambda (v)
                                         (list v `(nth ,(setq n (1+ n))
                                                       ,temp)))
                                       vars)))))))))


;;; Declarations.

;;;###autoload
(defmacro cl-locally (&rest body)
  "Equivalent to `progn'."
  (declare (debug t))
  (cons 'progn body))
;;;###autoload
(defmacro cl-the (_type form)
  "At present this ignores _TYPE and is simply equivalent to FORM."
  (declare (indent 1) (debug (cl-type-spec form)))
  form)

(defvar cl-proclaim-history t)    ; for future compilers
(defvar cl-declare-stack t)       ; for future compilers

(defun cl-do-proclaim (spec hist)
  (and hist (listp cl-proclaim-history) (push spec cl-proclaim-history))
  (cond ((eq (car-safe spec) 'special)
	 (if (boundp 'byte-compile-bound-variables)
	     (setq byte-compile-bound-variables
		   (append (cdr spec) byte-compile-bound-variables))))

	((eq (car-safe spec) 'inline)
	 (while (setq spec (cdr spec))
	   (or (memq (get (car spec) 'byte-optimizer)
		     '(nil byte-compile-inline-expand))
	       (error "%s already has a byte-optimizer, can't make it inline"
		      (car spec)))
	   (put (car spec) 'byte-optimizer 'byte-compile-inline-expand)))

	((eq (car-safe spec) 'notinline)
	 (while (setq spec (cdr spec))
	   (if (eq (get (car spec) 'byte-optimizer)
		   'byte-compile-inline-expand)
	       (put (car spec) 'byte-optimizer nil))))

	((eq (car-safe spec) 'optimize)
	 (let ((speed (assq (nth 1 (assq 'speed (cdr spec)))
			    '((0 nil) (1 t) (2 t) (3 t))))
	       (safety (assq (nth 1 (assq 'safety (cdr spec)))
			     '((0 t) (1 t) (2 t) (3 nil)))))
	   (if speed (setq cl-optimize-speed (car speed)
			   byte-optimize (nth 1 speed)))
	   (if safety (setq cl-optimize-safety (car safety)
			    byte-compile-delete-errors (nth 1 safety)))))

	((and (eq (car-safe spec) 'warn) (boundp 'byte-compile-warnings))
	 (while (setq spec (cdr spec))
	   (if (consp (car spec))
	       (if (eq (cl-cadar spec) 0)
                   (byte-compile-disable-warning (caar spec))
                 (byte-compile-enable-warning (caar spec)))))))
  nil)

;;; Process any proclamations made before cl-macs was loaded.
(defvar cl-proclaims-deferred)
(let ((p (reverse cl-proclaims-deferred)))
  (while p (cl-do-proclaim (pop p) t))
  (setq cl-proclaims-deferred nil))

;;;###autoload
(defmacro cl-declare (&rest specs)
  "Declare SPECS about the current function while compiling.
For instance

  \(cl-declare (warn 0))

will turn off byte-compile warnings in the function.
See Info node `(cl)Declarations' for details."
  (if (cl--compiling-file)
      (while specs
	(if (listp cl-declare-stack) (push (car specs) cl-declare-stack))
	(cl-do-proclaim (pop specs) nil)))
  nil)

;;; The standard modify macros.

;; `setf' is now part of core Elisp, defined in gv.el.

;;;###autoload
(defmacro cl-psetf (&rest args)
  "Set PLACEs to the values VALs in parallel.
This is like `setf', except that all VAL forms are evaluated (in order)
before assigning any PLACEs to the corresponding values.

\(fn PLACE VAL PLACE VAL ...)"
  (declare (debug setf))
  (let ((p args) (simple t) (vars nil))
    (while p
      (if (or (not (symbolp (car p))) (cl--expr-depends-p (nth 1 p) vars))
	  (setq simple nil))
      (if (memq (car p) vars)
	  (error "Destination duplicated in psetf: %s" (car p)))
      (push (pop p) vars)
      (or p (error "Odd number of arguments to cl-psetf"))
      (pop p))
    (if simple
	`(progn (setq ,@args) nil)
      (setq args (reverse args))
      (let ((expr `(setf ,(cadr args) ,(car args))))
	(while (setq args (cddr args))
	  (setq expr `(setf ,(cadr args) (prog1 ,(car args) ,expr))))
	`(progn ,expr nil)))))

;;;###autoload
(defmacro cl-remf (place tag)
  "Remove TAG from property list PLACE.
PLACE may be a symbol, or any generalized variable allowed by `setf'.
The form returns true if TAG was found and removed, nil otherwise."
  (declare (debug (place form)))
  (gv-letplace (tval setter) place
    (macroexp-let2 macroexp-copyable-p ttag tag
      `(if (eq ,ttag (car ,tval))
           (progn ,(funcall setter `(cddr ,tval))
                  t)
         (cl--do-remf ,tval ,ttag)))))

;;;###autoload
(defmacro cl-shiftf (place &rest args)
  "Shift left among PLACEs.
Example: (cl-shiftf A B C) sets A to B, B to C, and returns the old A.
Each PLACE may be a symbol, or any generalized variable allowed by `setf'.

\(fn PLACE... VAL)"
  (declare (debug (&rest place)))
  (cond
   ((null args) place)
   ((symbolp place) `(prog1 ,place (setq ,place (cl-shiftf ,@args))))
   (t
    (gv-letplace (getter setter) place
      `(prog1 ,getter
         ,(funcall setter `(cl-shiftf ,@args)))))))

;;;###autoload
(defmacro cl-rotatef (&rest args)
  "Rotate left among PLACEs.
Example: (cl-rotatef A B C) sets A to B, B to C, and C to A.  It returns nil.
Each PLACE may be a symbol, or any generalized variable allowed by `setf'.

\(fn PLACE...)"
  (declare (debug (&rest place)))
  (if (not (memq nil (mapcar 'symbolp args)))
      (and (cdr args)
	   (let ((sets nil)
		 (first (car args)))
	     (while (cdr args)
	       (setq sets (nconc sets (list (pop args) (car args)))))
	     `(cl-psetf ,@sets ,(car args) ,first)))
    (let* ((places (reverse args))
	   (temp (make-symbol "--cl-rotatef--"))
	   (form temp))
      (while (cdr places)
        (setq form
              (gv-letplace (getter setter) (pop places)
                `(prog1 ,getter ,(funcall setter form)))))
      (gv-letplace (getter setter) (car places)
	(macroexp-let* `((,temp ,getter))
                       `(progn ,(funcall setter form) nil))))))

;; FIXME: `letf' is unsatisfactory because it does not really "restore" the
;; previous state.  If the getter/setter loses information, that info is
;; not recovered.

(defun cl--letf (bindings simplebinds binds body)
  ;; It's not quite clear what the semantics of cl-letf should be.
  ;; E.g. in (cl-letf ((PLACE1 VAL1) (PLACE2 VAL2)) BODY), while it's clear
  ;; that the actual assignments ("bindings") should only happen after
  ;; evaluating VAL1 and VAL2, it's not clear when the sub-expressions of
  ;; PLACE1 and PLACE2 should be evaluated.  Should we have
  ;;    PLACE1; VAL1; PLACE2; VAL2; bind1; bind2
  ;; or
  ;;    VAL1; VAL2; PLACE1; PLACE2; bind1; bind2
  ;; or
  ;;    VAL1; VAL2; PLACE1; bind1; PLACE2; bind2
  ;; Common-Lisp's `psetf' does the first, so we'll do the same.
  (if (null bindings)
      (if (and (null binds) (null simplebinds)) (macroexp-progn body)
        `(let* (,@(mapcar (lambda (x)
                            (pcase-let ((`(,vold ,getter ,_setter ,_vnew) x))
                              (list vold getter)))
                          binds)
                ,@simplebinds)
           (unwind-protect
               ,(macroexp-progn
                 (append
                  (delq nil
                        (mapcar (lambda (x)
                                  (pcase x
                                    ;; If there's no vnew, do nothing.
                                    (`(,_vold ,_getter ,setter ,vnew)
                                     (funcall setter vnew))))
                                binds))
                  body))
             ,@(mapcar (lambda (x)
                         (pcase-let ((`(,vold ,_getter ,setter ,_vnew) x))
                           (funcall setter vold)))
                       binds))))
    (let ((binding (car bindings)))
      (gv-letplace (getter setter) (car binding)
        (macroexp-let2 nil vnew (cadr binding)
          (if (symbolp (car binding))
              ;; Special-case for simple variables.
              (cl--letf (cdr bindings)
                        (cons `(,getter ,(if (cdr binding) vnew getter))
                              simplebinds)
                        binds body)
            (cl--letf (cdr bindings) simplebinds
                      (cons `(,(make-symbol "old") ,getter ,setter
                              ,@(if (cdr binding) (list vnew)))
                            binds)
                      body)))))))

;;;###autoload
(defmacro cl-letf (bindings &rest body)
  "Temporarily bind to PLACEs.
This is the analogue of `let', but with generalized variables (in the
sense of `setf') for the PLACEs.  Each PLACE is set to the corresponding
VALUE, then the BODY forms are executed.  On exit, either normally or
because of a `throw' or error, the PLACEs are set back to their original
values.  Note that this macro is *not* available in Common Lisp.
As a special case, if `(PLACE)' is used instead of `(PLACE VALUE)',
the PLACE is not modified before executing BODY.

\(fn ((PLACE VALUE) ...) BODY...)"
  (declare (indent 1) (debug ((&rest (gate gv-place &optional form)) body)))
  (if (and (not (cdr bindings)) (cdar bindings) (symbolp (caar bindings)))
      `(let ,bindings ,@body)
    (cl--letf bindings () () body)))

;;;###autoload
(defmacro cl-letf* (bindings &rest body)
  "Temporarily bind to PLACEs.
Like `cl-letf' but where the bindings are performed one at a time,
rather than all at the end (i.e. like `let*' rather than like `let')."
  (declare (indent 1) (debug cl-letf))
  (dolist (binding (reverse bindings))
    (setq body (list `(cl-letf (,binding) ,@body))))
  (macroexp-progn body))

;;;###autoload
(defmacro cl-callf (func place &rest args)
  "Set PLACE to (FUNC PLACE ARGS...).
FUNC should be an unquoted function name.  PLACE may be a symbol,
or any generalized variable allowed by `setf'."
  (declare (indent 2) (debug (cl-function place &rest form)))
  (gv-letplace (getter setter) place
    (let* ((rargs (cons getter args)))
      (funcall setter
               (if (symbolp func) (cons func rargs)
                 `(funcall #',func ,@rargs))))))

;;;###autoload
(defmacro cl-callf2 (func arg1 place &rest args)
  "Set PLACE to (FUNC ARG1 PLACE ARGS...).
Like `cl-callf', but PLACE is the second argument of FUNC, not the first.

\(fn FUNC ARG1 PLACE ARGS...)"
  (declare (indent 3) (debug (cl-function form place &rest form)))
  (if (and (cl--safe-expr-p arg1) (cl--simple-expr-p place) (symbolp func))
      `(setf ,place (,func ,arg1 ,place ,@args))
    (macroexp-let2 nil a1 arg1
      (gv-letplace (getter setter) place
        (let* ((rargs (cl-list* a1 getter args)))
          (funcall setter
                   (if (symbolp func) (cons func rargs)
                     `(funcall #',func ,@rargs))))))))

;;; Structures.

;;;###autoload
(defmacro cl-defstruct (struct &rest descs)
  "Define a struct type.
This macro defines a new data type called NAME that stores data
in SLOTs.  It defines a `make-NAME' constructor, a `copy-NAME'
copier, a `NAME-p' predicate, and slot accessors named `NAME-SLOT'.
You can use the accessors to set the corresponding slots, via `setf'.

NAME may instead take the form (NAME OPTIONS...), where each
OPTION is either a single keyword or (KEYWORD VALUE) where
KEYWORD can be one of :conc-name, :constructor, :copier, :predicate,
:type, :named, :initial-offset, :print-function, or :include.

Each SLOT may instead take the form (SLOT SLOT-OPTS...), where
SLOT-OPTS are keyword-value pairs for that slot.  Currently, only
one keyword is supported, `:read-only'.  If this has a non-nil
value, that slot cannot be set via `setf'.

\(fn NAME SLOTS...)"
  (declare (doc-string 2) (indent 1)
           (debug
            (&define                    ;Makes top-level form not be wrapped.
             [&or symbolp
                  (gate
                   symbolp &rest
                   (&or [":conc-name" symbolp]
                        [":constructor" symbolp &optional cl-lambda-list]
                        [":copier" symbolp]
                        [":predicate" symbolp]
                        [":include" symbolp &rest sexp] ;; Not finished.
                        ;; The following are not supported.
                        ;; [":print-function" ...]
                        ;; [":type" ...]
                        ;; [":initial-offset" ...]
                        ))]
             [&optional stringp]
             ;; All the above is for the following def-form.
             &rest &or symbolp (symbolp def-form
                                        &optional ":read-only" sexp))))
  (let* ((name (if (consp struct) (car struct) struct))
	 (opts (cdr-safe struct))
	 (slots nil)
	 (defaults nil)
	 (conc-name (concat (symbol-name name) "-"))
	 (constructor (intern (format "make-%s" name)))
	 (constrs nil)
	 (copier (intern (format "copy-%s" name)))
	 (predicate (intern (format "%s-p" name)))
	 (print-func nil) (print-auto nil)
	 (safety (if (cl--compiling-file) cl-optimize-safety 3))
	 (include nil)
	 (tag (intern (format "cl-struct-%s" name)))
	 (tag-symbol (intern (format "cl-struct-%s-tags" name)))
	 (include-descs nil)
	 (side-eff nil)
	 (type nil)
	 (named nil)
	 (forms nil)
	 pred-form pred-check)
    (if (stringp (car descs))
	(push `(put ',name 'structure-documentation
                    ,(pop descs)) forms))
    (setq descs (cons '(cl-tag-slot)
		      (mapcar (function (lambda (x) (if (consp x) x (list x))))
			      descs)))
    (while opts
      (let ((opt (if (consp (car opts)) (caar opts) (car opts)))
	    (args (cdr-safe (pop opts))))
	(cond ((eq opt :conc-name)
	       (if args
		   (setq conc-name (if (car args)
				       (symbol-name (car args)) ""))))
	      ((eq opt :constructor)
	       (if (cdr args)
                   (progn
                     ;; If this defines a constructor of the same name as
                     ;; the default one, don't define the default.
                     (if (eq (car args) constructor)
                         (setq constructor nil))
                     (push args constrs))
		 (if args (setq constructor (car args)))))
	      ((eq opt :copier)
	       (if args (setq copier (car args))))
	      ((eq opt :predicate)
	       (if args (setq predicate (car args))))
	      ((eq opt :include)
	       (setq include (car args)
		     include-descs (mapcar (function
					    (lambda (x)
					      (if (consp x) x (list x))))
					   (cdr args))))
	      ((eq opt :print-function)
	       (setq print-func (car args)))
	      ((eq opt :type)
	       (setq type (car args)))
	      ((eq opt :named)
	       (setq named t))
	      ((eq opt :initial-offset)
	       (setq descs (nconc (make-list (car args) '(cl-skip-slot))
				  descs)))
	      (t
	       (error "Slot option %s unrecognized" opt)))))
    (if print-func
	(setq print-func
              `(progn (funcall #',print-func cl-x cl-s cl-n) t))
      (or type (and include (not (get include 'cl-struct-print)))
	  (setq print-auto t
		print-func (and (or (not (or include type)) (null print-func))
				`(progn
                                   (princ ,(format "#S(%s" name) cl-s))))))
    (if include
	(let ((inc-type (get include 'cl-struct-type))
	      (old-descs (get include 'cl-struct-slots)))
	  (or inc-type (error "%s is not a struct name" include))
	  (and type (not (eq (car inc-type) type))
	       (error ":type disagrees with :include for %s" name))
	  (while include-descs
	    (setcar (memq (or (assq (caar include-descs) old-descs)
			      (error "No slot %s in included struct %s"
				     (caar include-descs) include))
			  old-descs)
		    (pop include-descs)))
	  (setq descs (append old-descs (delq (assq 'cl-tag-slot descs) descs))
		type (car inc-type)
		named (assq 'cl-tag-slot descs))
	  (if (cadr inc-type) (setq tag name named t))
	  (let ((incl include))
	    (while incl
	      (push `(cl-pushnew ',tag
                              ,(intern (format "cl-struct-%s-tags" incl)))
                    forms)
	      (setq incl (get incl 'cl-struct-include)))))
      (if type
	  (progn
	    (or (memq type '(vector list))
		(error "Invalid :type specifier: %s" type))
	    (if named (setq tag name)))
	(setq type 'vector named 'true)))
    (or named (setq descs (delq (assq 'cl-tag-slot descs) descs)))
    (push `(defvar ,tag-symbol) forms)
    (setq pred-form (and named
			 (let ((pos (- (length descs)
				       (length (memq (assq 'cl-tag-slot descs)
						     descs)))))
			   (if (eq type 'vector)
			       `(and (vectorp cl-x)
				     (>= (length cl-x) ,(length descs))
				     (memq (aref cl-x ,pos) ,tag-symbol))
			     (if (= pos 0)
				 `(memq (car-safe cl-x) ,tag-symbol)
			       `(and (consp cl-x)
				     (memq (nth ,pos cl-x) ,tag-symbol))))))
	  pred-check (and pred-form (> safety 0)
			  (if (and (eq (cl-caadr pred-form) 'vectorp)
				   (= safety 1))
			      (cons 'and (cl-cdddr pred-form)) pred-form)))
    (let ((pos 0) (descp descs))
      (while descp
	(let* ((desc (pop descp))
	       (slot (car desc)))
	  (if (memq slot '(cl-tag-slot cl-skip-slot))
	      (progn
		(push nil slots)
		(push (and (eq slot 'cl-tag-slot) `',tag)
			 defaults))
	    (if (assq slot descp)
		(error "Duplicate slots named %s in %s" slot name))
	    (let ((accessor (intern (format "%s%s" conc-name slot))))
	      (push slot slots)
	      (push (nth 1 desc) defaults)
	      (push `(cl-defsubst ,accessor (cl-x)
                       ,@(and pred-check
			      (list `(or ,pred-check
                                         (error "%s accessing a non-%s"
                                                ',accessor ',name))))
                       ,(if (eq type 'vector) `(aref cl-x ,pos)
                          (if (= pos 0) '(car cl-x)
                            `(nth ,pos cl-x)))) forms)
	      (push (cons accessor t) side-eff)
              (if (cadr (memq :read-only (cddr desc)))
                  (push `(gv-define-expander ,accessor
                           (lambda (_cl-do _cl-x)
                             (error "%s is a read-only slot" ',accessor)))
                        forms)
                ;; For normal slots, we don't need to define a setf-expander,
                ;; since gv-get can use the compiler macro to get the
                ;; same result.
                ;; (push `(gv-define-setter ,accessor (cl-val cl-x)
                ;;          ;; If cl is loaded only for compilation,
                ;;          ;; the call to cl--struct-setf-expander would
                ;;          ;; cause a warning because it may not be
                ;;          ;; defined at run time.  Suppress that warning.
                ;;          (progn
                ;;            (declare-function
                ;;             cl--struct-setf-expander "cl-macs"
                ;;             (x name accessor pred-form pos))
                ;;            (cl--struct-setf-expander
                ;;             cl-val cl-x ',name ',accessor
                ;;             ,(and pred-check `',pred-check)
                ;;             ,pos)))
                ;;       forms)
                )
	      (if print-auto
		  (nconc print-func
			 (list `(princ ,(format " %s" slot) cl-s)
			       `(prin1 (,accessor cl-x) cl-s)))))))
	(setq pos (1+ pos))))
    (setq slots (nreverse slots)
	  defaults (nreverse defaults))
    (and predicate pred-form
	 (progn (push `(cl-defsubst ,predicate (cl-x)
                         ,(if (eq (car pred-form) 'and)
                              (append pred-form '(t))
                            `(and ,pred-form t))) forms)
		(push (cons predicate 'error-free) side-eff)))
    (and copier
	 (progn (push `(defun ,copier (x) (copy-sequence x)) forms)
		(push (cons copier t) side-eff)))
    (if constructor
	(push (list constructor
		       (cons '&key (delq nil (copy-sequence slots))))
		 constrs))
    (while constrs
      (let* ((name (caar constrs))
	     (args (cadr (pop constrs)))
	     (anames (cl--arglist-args args))
	     (make (cl-mapcar (function (lambda (s d) (if (memq s anames) s d)))
			    slots defaults)))
	(push `(cl-defsubst ,name
                 (&cl-defs '(nil ,@descs) ,@args)
                 (,type ,@make)) forms)
	(if (cl--safe-expr-p `(progn ,@(mapcar #'cl-second descs)))
	    (push (cons name t) side-eff))))
    (if print-auto (nconc print-func (list '(princ ")" cl-s) t)))
    ;; Don't bother adding to cl-custom-print-functions since it's not used
    ;; by anything anyway!
    ;;(if print-func
    ;;    (push `(if (boundp 'cl-custom-print-functions)
    ;;               (push
    ;;                ;; The auto-generated function does not pay attention to
    ;;                ;; the depth argument cl-n.
    ;;                (lambda (cl-x cl-s ,(if print-auto '_cl-n 'cl-n))
    ;;                  (and ,pred-form ,print-func))
    ;;                cl-custom-print-functions))
    ;;          forms))
    (push `(setq ,tag-symbol (list ',tag)) forms)
    (push `(cl-eval-when (compile load eval)
             (put ',name 'cl-struct-slots ',descs)
             (put ',name 'cl-struct-type ',(list type (eq named t)))
             (put ',name 'cl-struct-include ',include)
             (put ',name 'cl-struct-print ,print-auto)
             ,@(mapcar (lambda (x)
                         `(put ',(car x) 'side-effect-free ',(cdr x)))
                       side-eff))
          forms)
    `(progn ,@(nreverse (cons `',name forms)))))

;;; Types and assertions.

;;;###autoload
(defmacro cl-deftype (name arglist &rest body)
  "Define NAME as a new data type.
The type name can then be used in `cl-typecase', `cl-check-type', etc."
  (declare (debug cl-defmacro) (doc-string 3))
  `(cl-eval-when (compile load eval)
     (put ',name 'cl-deftype-handler
          (cl-function (lambda (&cl-defs '('*) ,@arglist) ,@body)))))

(defun cl--make-type-test (val type)
  (if (symbolp type)
      (cond ((get type 'cl-deftype-handler)
	     (cl--make-type-test val (funcall (get type 'cl-deftype-handler))))
	    ((memq type '(nil t)) type)
	    ((eq type 'null) `(null ,val))
	    ((eq type 'atom) `(atom ,val))
	    ((eq type 'float) `(cl-floatp-safe ,val))
	    ((eq type 'real) `(numberp ,val))
	    ((eq type 'fixnum) `(integerp ,val))
	    ;; FIXME: Should `character' accept things like ?\C-\M-a ?  --Stef
	    ((memq type '(character string-char)) `(characterp ,val))
	    (t
	     (let* ((name (symbol-name type))
		    (namep (intern (concat name "p"))))
	       (if (fboundp namep) (list namep val)
		 (list (intern (concat name "-p")) val)))))
    (cond ((get (car type) 'cl-deftype-handler)
	   (cl--make-type-test val (apply (get (car type) 'cl-deftype-handler)
					 (cdr type))))
	  ((memq (car type) '(integer float real number))
	   (delq t `(and ,(cl--make-type-test val (car type))
			 ,(if (memq (cadr type) '(* nil)) t
                            (if (consp (cadr type)) `(> ,val ,(cl-caadr type))
                              `(>= ,val ,(cadr type))))
			 ,(if (memq (cl-caddr type) '(* nil)) t
                            (if (consp (cl-caddr type)) `(< ,val ,(cl-caaddr type))
                              `(<= ,val ,(cl-caddr type)))))))
	  ((memq (car type) '(and or not))
	   (cons (car type)
		 (mapcar (function (lambda (x) (cl--make-type-test val x)))
			 (cdr type))))
	  ((memq (car type) '(member cl-member))
	   `(and (cl-member ,val ',(cdr type)) t))
	  ((eq (car type) 'satisfies) (list (cadr type) val))
	  (t (error "Bad type spec: %s" type)))))

(defvar cl--object)
;;;###autoload
(defun cl-typep (object type)   ; See compiler macro below.
  "Check that OBJECT is of type TYPE.
TYPE is a Common Lisp-style type specifier."
  (let ((cl--object object)) ;; Yuck!!
    (eval (cl--make-type-test 'cl--object type))))

;;;###autoload
(defmacro cl-check-type (form type &optional string)
  "Verify that FORM is of type TYPE; signal an error if not.
STRING is an optional description of the desired type."
  (declare (debug (place cl-type-spec &optional stringp)))
  (and (or (not (cl--compiling-file))
	   (< cl-optimize-speed 3) (= cl-optimize-safety 3))
       (let* ((temp (if (cl--simple-expr-p form 3)
			form (make-symbol "--cl-var--")))
	      (body `(or ,(cl--make-type-test temp type)
                         (signal 'wrong-type-argument
                                 (list ,(or string `',type)
                                       ,temp ',form)))))
	 (if (eq temp form) `(progn ,body nil)
	   `(let ((,temp ,form)) ,body nil)))))

;;;###autoload
(defmacro cl-assert (form &optional show-args string &rest args)
  ;; FIXME: This is actually not compatible with Common-Lisp's `assert'.
  "Verify that FORM returns non-nil; signal an error if not.
Second arg SHOW-ARGS means to include arguments of FORM in message.
Other args STRING and ARGS... are arguments to be passed to `error'.
They are not evaluated unless the assertion fails.  If STRING is
omitted, a default message listing FORM itself is used."
  (declare (debug (form &rest form)))
  (and (or (not (cl--compiling-file))
	   (< cl-optimize-speed 3) (= cl-optimize-safety 3))
       (let ((sargs (and show-args
                         (delq nil (mapcar (lambda (x)
                                             (unless (macroexp-const-p x)
                                               x))
                                           (cdr form))))))
	 `(progn
            (or ,form
                ,(if string
                     `(error ,string ,@sargs ,@args)
                   `(signal 'cl-assertion-failed
                            (list ',form ,@sargs))))
            nil))))

;;; Compiler macros.

;;;###autoload
(defmacro cl-define-compiler-macro (func args &rest body)
  "Define a compiler-only macro.
This is like `defmacro', but macro expansion occurs only if the call to
FUNC is compiled (i.e., not interpreted).  Compiler macros should be used
for optimizing the way calls to FUNC are compiled; the form returned by
BODY should do the same thing as a call to the normal function called
FUNC, though possibly more efficiently.  Note that, like regular macros,
compiler macros are expanded repeatedly until no further expansions are
possible.  Unlike regular macros, BODY can decide to \"punt\" and leave the
original function call alone by declaring an initial `&whole foo' parameter
and then returning foo."
  (declare (debug cl-defmacro))
  (let ((p args) (res nil))
    (while (consp p) (push (pop p) res))
    (setq args (nconc (nreverse res) (and p (list '&rest p)))))
  `(cl-eval-when (compile load eval)
     (put ',func 'compiler-macro
          (cl-function (lambda ,(if (memq '&whole args) (delq '&whole args)
                             (cons '_cl-whole-arg args))
                         ,@body)))
     ;; This is so that describe-function can locate
     ;; the macro definition.
     (let ((file ,(or buffer-file-name
                      (and (boundp 'byte-compile-current-file)
                           (stringp byte-compile-current-file)
                           byte-compile-current-file))))
       (if file (put ',func 'compiler-macro-file
                     (purecopy (file-name-nondirectory file)))))))

;;;###autoload
(defun cl-compiler-macroexpand (form)
  "Like `macroexpand', but for compiler macros.
Expands FORM repeatedly until no further expansion is possible.
Returns FORM unchanged if it has no compiler macro, or if it has a
macro that returns its `&whole' argument."
  (while
      (let ((func (car-safe form)) (handler nil))
	(while (and (symbolp func)
		    (not (setq handler (get func 'compiler-macro)))
		    (fboundp func)
		    (or (not (autoloadp (symbol-function func)))
			(autoload-do-load (symbol-function func) func)))
	  (setq func (symbol-function func)))
	(and handler
	     (not (eq form (setq form (apply handler form (cdr form))))))))
  form)

;; Optimize away unused block-wrappers.

(defvar cl--active-block-names nil)

(cl-define-compiler-macro cl--block-wrapper (cl-form)
  (let* ((cl-entry (cons (nth 1 (nth 1 cl-form)) nil))
         (cl--active-block-names (cons cl-entry cl--active-block-names))
         (cl-body (macroexpand-all      ;Performs compiler-macro expansions.
                   (cons 'progn (cddr cl-form))
                   macroexpand-all-environment)))
    ;; FIXME: To avoid re-applying macroexpand-all, we'd like to be able
    ;; to indicate that this return value is already fully expanded.
    (if (cdr cl-entry)
        `(catch ,(nth 1 cl-form) ,@(cdr cl-body))
      cl-body)))

(cl-define-compiler-macro cl--block-throw (cl-tag cl-value)
  (let ((cl-found (assq (nth 1 cl-tag) cl--active-block-names)))
    (if cl-found (setcdr cl-found t)))
  `(throw ,cl-tag ,cl-value))

;;;###autoload
(defmacro cl-defsubst (name args &rest body)
  "Define NAME as a function.
Like `defun', except the function is automatically declared `inline',
ARGLIST allows full Common Lisp conventions, and BODY is implicitly
surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)"
  (declare (debug cl-defun) (indent 2))
  (let* ((argns (cl--arglist-args args)) (p argns)
	 (pbody (cons 'progn body))
	 (unsafe (not (cl--safe-expr-p pbody))))
    (while (and p (eq (cl--expr-contains args (car p)) 1)) (pop p))
    `(progn
       ,(if p nil   ; give up if defaults refer to earlier args
          `(cl-define-compiler-macro ,name
             ,(if (memq '&key args)
                  `(&whole cl-whole &cl-quote ,@args)
                (cons '&cl-quote args))
             (cl--defsubst-expand
              ',argns '(cl-block ,name ,@body)
              ;; We used to pass `simple' as
              ;; (not (or unsafe (cl-expr-access-order pbody argns)))
              ;; But this is much too simplistic since it
              ;; does not pay attention to the argvs (and
              ;; cl-expr-access-order itself is also too naive).
              nil
              ,(and (memq '&key args) 'cl-whole) ,unsafe ,@argns)))
       (cl-defun ,name ,args ,@body))))

(defun cl--defsubst-expand (argns body simple whole unsafe &rest argvs)
  (if (and whole (not (cl--safe-expr-p (cons 'progn argvs)))) whole
    (if (cl--simple-exprs-p argvs) (setq simple t))
    (let* ((substs ())
           (lets (delq nil
                       (cl-mapcar (lambda (argn argv)
                                    (if (or simple (macroexp-const-p argv))
                                        (progn (push (cons argn argv) substs)
                                               (and unsafe (list argn argv)))
                                      (list argn argv)))
                                  argns argvs))))
      ;; FIXME: `sublis/subst' will happily substitute the symbol
      ;; `argn' in places where it's not used as a reference
      ;; to a variable.
      ;; FIXME: `sublis/subst' will happily copy `argv' to a different
      ;; scope, leading to name capture.
      (setq body (cond ((null substs) body)
                       ((null (cdr substs))
                        (cl-subst (cdar substs) (caar substs) body))
                       (t (cl-sublis substs body))))
      (if lets `(let ,lets ,body) body))))


;; Compile-time optimizations for some functions defined in this package.

(defun cl--compiler-macro-member (form a list &rest keys)
  (let ((test (and (= (length keys) 2) (eq (car keys) :test)
		   (cl--const-expr-val (nth 1 keys)))))
    (cond ((eq test 'eq) `(memq ,a ,list))
	  ((eq test 'equal) `(member ,a ,list))
	  ((or (null keys) (eq test 'eql)) `(memql ,a ,list))
	  (t form))))

(defun cl--compiler-macro-assoc (form a list &rest keys)
  (let ((test (and (= (length keys) 2) (eq (car keys) :test)
		   (cl--const-expr-val (nth 1 keys)))))
    (cond ((eq test 'eq) `(assq ,a ,list))
	  ((eq test 'equal) `(assoc ,a ,list))
	  ((and (macroexp-const-p a) (or (null keys) (eq test 'eql)))
	   (if (cl-floatp-safe (cl--const-expr-val a))
	       `(assoc ,a ,list) `(assq ,a ,list)))
	  (t form))))

;;;###autoload
(defun cl--compiler-macro-adjoin (form a list &rest keys)
  (if (and (cl--simple-expr-p a) (cl--simple-expr-p list)
	   (not (memq :key keys)))
      `(if (cl-member ,a ,list ,@keys) ,list (cons ,a ,list))
    form))

(defun cl--compiler-macro-get (_form sym prop &optional def)
  (if def
      `(cl-getf (symbol-plist ,sym) ,prop ,def)
    `(get ,sym ,prop)))

(cl-define-compiler-macro cl-typep (&whole form val type)
  (if (macroexp-const-p type)
      (macroexp-let2 macroexp-copyable-p temp val
        (cl--make-type-test temp (cl--const-expr-val type)))
    form))

(dolist (y '(cl-first cl-second cl-third cl-fourth
             cl-fifth cl-sixth cl-seventh
             cl-eighth cl-ninth cl-tenth
             cl-rest cl-endp cl-plusp cl-minusp
             cl-caaar cl-caadr cl-cadar
             cl-caddr cl-cdaar cl-cdadr
             cl-cddar cl-cdddr cl-caaaar
             cl-caaadr cl-caadar cl-caaddr
             cl-cadaar cl-cadadr cl-caddar
             cl-cadddr cl-cdaaar cl-cdaadr
             cl-cdadar cl-cdaddr cl-cddaar
             cl-cddadr cl-cdddar cl-cddddr))
  (put y 'side-effect-free t))

;;; Things that are inline.
(cl-proclaim '(inline cl-floatp-safe cl-acons cl-map cl-concatenate cl-notany
               cl-notevery cl--set-elt cl-revappend cl-nreconc gethash))

;;; Things that are side-effect-free.
(mapc (lambda (x) (put x 'side-effect-free t))
      '(cl-oddp cl-evenp cl-signum last butlast cl-ldiff cl-pairlis cl-gcd cl-lcm
	cl-isqrt cl-floor cl-ceiling cl-truncate cl-round cl-mod cl-rem cl-subseq
	cl-list-length cl-get cl-getf))

;;; Things that are side-effect-and-error-free.
(mapc (lambda (x) (put x 'side-effect-free 'error-free))
      '(eql cl-floatp-safe cl-list* cl-subst cl-acons cl-equalp cl-random-state-p
	copy-tree cl-sublis))


(run-hooks 'cl-macs-load-hook)

;; Local variables:
;; byte-compile-dynamic: t
;; generated-autoload-file: "cl-loaddefs.el"
;; End:

(provide 'cl-macs)

;;; cl-macs.el ends here
