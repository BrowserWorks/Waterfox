;;; gv.el --- generalized variables  -*- lexical-binding: t -*-

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Stefan Monnier <monnier@iro.umontreal.ca>
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

;; This is a re-implementation of the setf machinery using a different
;; underlying approach than the one used earlier in CL, which was based on
;; define-setf-expander.
;; `define-setf-expander' makes every "place-expander" return a 5-tuple
;;   (VARS VALUES STORES GETTER SETTER)
;; where STORES is a list with a single variable (Common-Lisp allows multiple
;; variables for use with multiple-return-values, but this is rarely used and
;; not applicable to Elisp).
;; It basically says that GETTER is an expression that returns the place's
;; value, and (lambda STORES SETTER) is an expression that assigns the value(s)
;; passed to that function to the place, and that you need to wrap the whole
;; thing within a `(let* ,(zip VARS VALUES) ...).
;;
;; Instead, we use here a higher-order approach: instead
;; of a 5-tuple, a place-expander returns a function.
;; If you think about types, the old approach return things of type
;;    {vars: List Var, values: List Exp,
;;     stores: List Var, getter: Exp, setter: Exp}
;; whereas the new approach returns a function of type
;;    (do: ((getter: Exp, setter: ((store: Exp) -> Exp)) -> Exp)) -> Exp.
;; You can get the new function from the old 5-tuple with something like:
;;    (lambda (do)
;;       `(let* ,(zip VARS VALUES)
;;          (funcall do GETTER (lambda ,STORES ,SETTER))))
;; You can't easily do the reverse, because this new approach is more
;; expressive than the old one, so we can't provide a backward-compatible
;; get-setf-method.
;;
;; While it may seem intimidating for people not used to higher-order
;; functions, you will quickly see that its use (especially with the
;; `gv-letplace' macro) is actually much easier and more elegant than the old
;; approach which is clunky and often leads to unreadable code.

;; Food for thought: the syntax of places does not actually conflict with the
;; pcase patterns.  The `cons' gv works just like a `(,a . ,b) pcase
;; pattern, and actually the `logand' gv is even closer since it should
;; arguably fail when trying to set a value outside of the mask.
;; Generally, places are used for destructors (gethash, aref, car, ...)
;; whereas pcase patterns are used for constructors (backquote, constants,
;; vectors, ...).

;;; Code:

(require 'macroexp)

;; What we call a "gvar" is basically a function of type "(getter * setter ->
;; code) -> code", where "getter" is code and setter is "code -> code".

;; (defvar gv--macro-environment nil
;;   "Macro expanders for generalized variables.")

;;;###autoload
(defun gv-get (place do)
  "Build the code that applies DO to PLACE.
PLACE must be a valid generalized variable.
DO must be a function; it will be called with 2 arguments: GETTER and SETTER,
where GETTER is a (copyable) Elisp expression that returns the value of PLACE,
and SETTER is a function which returns the code to set PLACE when called
with a (not necessarily copyable) Elisp expression that returns the value to
set it to.
DO must return an Elisp expression."
  (if (symbolp place)
      (funcall do place (lambda (v) `(setq ,place ,v)))
    (let* ((head (car place))
           (gf (function-get head 'gv-expander 'autoload)))
      (if gf (apply gf do (cdr place))
        (let ((me (macroexpand place    ;FIXME: expand one step at a time!
                               ;; (append macroexpand-all-environment
                               ;;         gv--macro-environment)
                               macroexpand-all-environment)))
          (if (and (eq me place) (get head 'compiler-macro))
              ;; Expand compiler macros: this takes care of all the accessors
              ;; defined via cl-defsubst, such as cXXXr and defstruct slots.
              (setq me (apply (get head 'compiler-macro) place (cdr place))))
          (if (and (eq me place) (fboundp head)
                   (symbolp (symbol-function head)))
              ;; Follow aliases.
              (setq me (cons (symbol-function head) (cdr place))))
          (if (eq me place)
              (error "%S is not a valid place expression" place)
            (gv-get me do)))))))

;;;###autoload
(defmacro gv-letplace (vars place &rest body)
  "Build the code manipulating the generalized variable PLACE.
GETTER will be bound to a copyable expression that returns the value
of PLACE.
SETTER will be bound to a function that takes an expression V and returns
a new expression that sets PLACE to V.
BODY should return some Elisp expression E manipulating PLACE via GETTER
and SETTER.
The returned value will then be an Elisp expression that first evaluates
all the parts of PLACE that can be evaluated and then runs E.

\(fn (GETTER SETTER) PLACE &rest BODY)"
  (declare (indent 2) (debug (sexp form body)))
  `(gv-get ,place (lambda ,vars ,@body)))

;; Different ways to declare a generalized variable.
;;;###autoload
(defmacro gv-define-expander (name handler)
  "Use HANDLER to handle NAME as a generalized var.
NAME is a symbol: the name of a function, macro, or special form.
HANDLER is a function which takes an argument DO followed by the same
arguments as NAME.  DO is a function as defined in `gv-get'."
  (declare (indent 1) (debug (sexp form)))
  ;; Use eval-and-compile so the method can be used in the same file as it
  ;; is defined.
  ;; FIXME: Just like byte-compile-macro-environment, we should have something
  ;; like byte-compile-symbolprop-environment so as to handle these things
  ;; cleanly without affecting the running Emacs.
  `(eval-and-compile (put ',name 'gv-expander ,handler)))

;;;###autoload
(defun gv--defun-declaration (symbol name args handler &optional fix)
  `(progn
     ;; No need to autoload this part, since gv-get will auto-load the
     ;; function's definition before checking the `gv-expander' property.
     :autoload-end
     ,(pcase (cons symbol handler)
        (`(gv-expander . (lambda (,do) . ,body))
         `(gv-define-expander ,name (lambda (,do ,@args) ,@body)))
        (`(gv-expander . ,(pred symbolp))
         `(gv-define-expander ,name #',handler))
        (`(gv-setter . (lambda (,store) . ,body))
         `(gv-define-setter ,name (,store ,@args) ,@body))
        (`(gv-setter . ,(pred symbolp))
         `(gv-define-simple-setter ,name ,handler ,fix))
        ;; (`(expand ,expander) `(gv-define-expand ,name ,expander))
        (_ (message "Unknown %s declaration %S" symbol handler) nil))))

;;;###autoload
(push `(gv-expander ,(apply-partially #'gv--defun-declaration 'gv-expander))
      defun-declarations-alist)
;;;###autoload
(push `(gv-setter ,(apply-partially #'gv--defun-declaration 'gv-setter))
      defun-declarations-alist)

;; (defmacro gv-define-expand (name expander)
;;   "Use EXPANDER to handle NAME as a generalized var.
;; NAME is a symbol: the name of a function, macro, or special form.
;; EXPANDER is a function that will be called as a macro-expander to reduce
;; uses of NAME to some other generalized variable."
;;   (declare (debug (sexp form)))
;;   `(eval-and-compile
;;      (if (not (boundp 'gv--macro-environment))
;;          (setq gv--macro-environment nil))
;;      (push (cons ',name ,expander) gv--macro-environment)))

(defun gv--defsetter (name setter do args &optional vars)
  "Helper function used by code generated by `gv-define-setter'.
NAME is the name of the getter function.
SETTER is a function that generates the code for the setter.
NAME accept ARGS as arguments and SETTER accepts (NEWVAL . ARGS).
VARS is used internally for recursive calls."
  (if (null args)
      (let ((vars (nreverse vars)))
        (funcall do `(,name ,@vars) (lambda (v) (apply setter v vars))))
    ;; FIXME: Often it would be OK to skip this `let', but in general,
    ;; `do' may have all kinds of side-effects.
    (macroexp-let2 nil v (car args)
      (gv--defsetter name setter do (cdr args) (cons v vars)))))

;;;###autoload
(defmacro gv-define-setter (name arglist &rest body)
  "Define a setter method for generalized variable NAME.
This macro is an easy-to-use substitute for `gv-define-expander' that works
well for simple place forms.
Assignments of VAL to (NAME ARGS...) are expanded by binding the argument
forms (VAL ARGS...) according to ARGLIST, then executing BODY, which must
return a Lisp form that does the assignment.
The first arg in ARGLIST (the one that receives VAL) receives an expression
which can do arbitrary things, whereas the other arguments are all guaranteed
to be pure and copyable.  Example use:
  (gv-define-setter aref (v a i) `(aset ,a ,i ,v))"
  (declare (indent 2) (debug (&define name sexp body)))
  `(gv-define-expander ,name
     (lambda (do &rest args)
       (gv--defsetter ',name (lambda ,arglist ,@body) do args))))

;;;###autoload
(defmacro gv-define-simple-setter (name setter &optional fix-return)
  "Define a simple setter method for generalized variable NAME.
This macro is an easy-to-use substitute for `gv-define-expander' that works
well for simple place forms.  Assignments of VAL to (NAME ARGS...) are
turned into calls of the form (SETTER ARGS... VAL).

If FIX-RETURN is non-nil, then SETTER is not assumed to return VAL and
instead the assignment is turned into something equivalent to
  \(let ((temp VAL))
    (SETTER ARGS... temp)
    temp)
so as to preserve the semantics of `setf'."
  (declare (debug (sexp (&or symbolp lambda-expr) &optional sexp)))
  `(gv-define-setter ,name (val &rest args)
     ,(if fix-return
          `(macroexp-let2 nil v val
             `(progn
                (,',setter ,@(append args (list v)))
                ,v))
        `(cons ',setter (append args (list val))))))

;;; Typical operations on generalized variables.

;;;###autoload
(defmacro setf (&rest args)
  "Set each PLACE to the value of its VAL.
This is a generalized version of `setq'; the PLACEs may be symbolic
references such as (car x) or (aref x i), as well as plain symbols.
For example, (setf (cadr x) y) is equivalent to (setcar (cdr x) y).
The return value is the last VAL in the list.

\(fn PLACE VAL PLACE VAL ...)"
  (declare (debug (&rest [gv-place form])))
  (if (and args (null (cddr args)))
      (let ((place (pop args))
            (val (car args)))
        (gv-letplace (_getter setter) place
          (funcall setter val)))
    (let ((sets nil))
      (while args (push `(setf ,(pop args) ,(pop args)) sets))
      (cons 'progn (nreverse sets)))))

;; (defmacro gv-pushnew! (val place)
;;   "Like `gv-push!' but only adds VAL if it's not yet in PLACE.
;; Presence is checked with `member'.
;; The return value is unspecified."
;;   (declare (debug (form gv-place)))
;;   (macroexp-let2 macroexp-copyable-p v val
;;     (gv-letplace (getter setter) place
;;       `(if (member ,v ,getter) nil
;;          ,(funcall setter `(cons ,v ,getter))))))

;; (defmacro gv-inc! (place &optional val)
;;   "Increment PLACE by VAL (default to 1)."
;;   (declare (debug (gv-place &optional form)))
;;   (gv-letplace (getter setter) place
;;     (funcall setter `(+ ,getter ,(or val 1)))))

;; (defmacro gv-dec! (place &optional val)
;;   "Decrement PLACE by VAL (default to 1)."
;;   (declare (debug (gv-place &optional form)))
;;   (gv-letplace (getter setter) place
;;     (funcall setter `(- ,getter ,(or val 1)))))

;; For Edebug, the idea is to let Edebug instrument gv-places just like it does
;; for normal expressions, and then give it a gv-expander to DTRT.
;; Maybe this should really be in edebug.el rather than here.

;; Autoload this `put' since a user might use C-u C-M-x on an expression
;; containing a non-trivial `push' even before gv.el was loaded.
;;;###autoload
(put 'gv-place 'edebug-form-spec 'edebug-match-form)
;; CL did the equivalent of:
;;(gv-define-macroexpand edebug-after (lambda (before index place) place))

(put 'edebug-after 'gv-expander
     (lambda (do before index place)
       (gv-letplace (getter setter) place
         (funcall do `(edebug-after ,before ,index ,getter)
                  setter))))

;;; The common generalized variables.

(gv-define-simple-setter aref aset)
(gv-define-simple-setter car setcar)
(gv-define-simple-setter cdr setcdr)
;; FIXME: add compiler-macros for `cXXr' instead!
(gv-define-setter caar (val x) `(setcar (car ,x) ,val))
(gv-define-setter cadr (val x) `(setcar (cdr ,x) ,val))
(gv-define-setter cdar (val x) `(setcdr (car ,x) ,val))
(gv-define-setter cddr (val x) `(setcdr (cdr ,x) ,val))
(gv-define-setter elt (store seq n)
  `(if (listp ,seq) (setcar (nthcdr ,n ,seq) ,store)
     (aset ,seq ,n ,store)))
(gv-define-simple-setter get put)
(gv-define-setter gethash (val k h &optional _d) `(puthash ,k ,val ,h))

;; (gv-define-expand nth (lambda (idx list) `(car (nthcdr ,idx ,list))))
(put 'nth 'gv-expander
     (lambda (do idx list)
       (macroexp-let2 nil c `(nthcdr ,idx ,list)
         (funcall do `(car ,c) (lambda (v) `(setcar ,c ,v))))))
(gv-define-simple-setter symbol-function fset)
(gv-define-simple-setter symbol-plist setplist)
(gv-define-simple-setter symbol-value set)

(put 'nthcdr 'gv-expander
     (lambda (do n place)
       (macroexp-let2 nil idx n
         (gv-letplace (getter setter) place
           (funcall do `(nthcdr ,idx ,getter)
                    (lambda (v) `(if (<= ,idx 0) ,(funcall setter v)
                              (setcdr (nthcdr (1- ,idx) ,getter) ,v))))))))

;;; Elisp-specific generalized variables.

(gv-define-simple-setter default-value set-default)
(gv-define-simple-setter frame-parameter set-frame-parameter 'fix)
(gv-define-simple-setter terminal-parameter set-terminal-parameter)
(gv-define-simple-setter keymap-parent set-keymap-parent)
(gv-define-simple-setter match-data set-match-data 'fix)
(gv-define-simple-setter overlay-get overlay-put)
(gv-define-setter overlay-start (store ov)
  `(progn (move-overlay ,ov ,store (overlay-end ,ov)) ,store))
(gv-define-setter overlay-end (store ov)
  `(progn (move-overlay ,ov (overlay-start ,ov) ,store) ,store))
(gv-define-simple-setter process-buffer set-process-buffer)
(gv-define-simple-setter process-filter set-process-filter)
(gv-define-simple-setter process-sentinel set-process-sentinel)
(gv-define-simple-setter process-get process-put)
(gv-define-simple-setter window-buffer set-window-buffer)
(gv-define-simple-setter window-display-table set-window-display-table 'fix)
(gv-define-simple-setter window-dedicated-p set-window-dedicated-p)
(gv-define-simple-setter window-hscroll set-window-hscroll)
(gv-define-simple-setter window-parameter set-window-parameter)
(gv-define-simple-setter window-point set-window-point)
(gv-define-simple-setter window-start set-window-start)

;;; Some occasionally handy extensions.

;; While several of the "places" below are not terribly useful for direct use,
;; they can show up as the output of the macro expansion of reasonable places,
;; such as struct-accessors.

(put 'progn 'gv-expander
     (lambda (do &rest exps)
       (let ((start (butlast exps))
             (end (car (last exps))))
         (if (null start) (gv-get end do)
           `(progn ,@start ,(gv-get end do))))))

(let ((let-expander
       (lambda (letsym)
         (lambda (do bindings &rest body)
           `(,letsym ,bindings
                     ,@(macroexp-unprogn
                        (gv-get (macroexp-progn body) do)))))))
  (put 'let 'gv-expander (funcall let-expander 'let))
  (put 'let* 'gv-expander (funcall let-expander 'let*)))

(put 'if 'gv-expander
     (lambda (do test then &rest else)
       (if (or (not lexical-binding)  ;The other code requires lexical-binding.
               (macroexp-small-p (funcall do 'dummy (lambda (_) 'dummy))))
           ;; This duplicates the `do' code, which is a problem if that
           ;; code is large, but otherwise results in more efficient code.
           `(if ,test ,(gv-get then do)
              ,@(macroexp-unprogn (gv-get (macroexp-progn else) do)))
         (let ((v (make-symbol "v")))
           (macroexp-let2 nil
               gv `(if ,test ,(gv-letplace (getter setter) then
                                `(cons (lambda () ,getter)
                                       (lambda (,v) ,(funcall setter v))))
                     ,(gv-letplace (getter setter) (macroexp-progn else)
                        `(cons (lambda () ,getter)
                               (lambda (,v) ,(funcall setter v)))))
             (funcall do `(funcall (car ,gv))
                      (lambda (v) `(funcall (cdr ,gv) ,v))))))))

(put 'cond 'gv-expander
     (lambda (do &rest branches)
       (if (or (not lexical-binding)  ;The other code requires lexical-binding.
               (macroexp-small-p (funcall do 'dummy (lambda (_) 'dummy))))
           ;; This duplicates the `do' code, which is a problem if that
           ;; code is large, but otherwise results in more efficient code.
           `(cond
             ,@(mapcar (lambda (branch)
                         (if (cdr branch)
                             (cons (car branch)
                                   (macroexp-unprogn
                                    (gv-get (macroexp-progn (cdr branch)) do)))
                           (gv-get (car branch) do)))
                       branches))
         (let ((v (make-symbol "v")))
           (macroexp-let2 nil
               gv `(cond
                    ,@(mapcar
                       (lambda (branch)
                         (if (cdr branch)
                             `(,(car branch)
                               ,@(macroexp-unprogn
                                  (gv-letplace (getter setter)
                                      (macroexp-progn (cdr branch))
                                    `(cons (lambda () ,getter)
                                           (lambda (,v) ,(funcall setter v))))))
                           (gv-letplace (getter setter)
                               (car branch)
                             `(cons (lambda () ,getter)
                                    (lambda (,v) ,(funcall setter v))))))
                       branches))
             (funcall do `(funcall (car ,gv))
                      (lambda (v) `(funcall (cdr ,gv) ,v))))))))

;;; Even more debatable extensions.

(put 'cons 'gv-expander
     (lambda (do a d)
       (gv-letplace (agetter asetter) a
         (gv-letplace (dgetter dsetter) d
           (funcall do
                    `(cons ,agetter ,dgetter)
                    (lambda (v) `(progn
                              ,(funcall asetter `(car ,v))
                              ,(funcall dsetter `(cdr ,v)))))))))

(put 'logand 'gv-expander
     (lambda (do place &rest masks)
       (gv-letplace (getter setter) place
         (macroexp-let2 macroexp-copyable-p
             mask (if (cdr masks) `(logand ,@masks) (car masks))
           (funcall
            do `(logand ,getter ,mask)
            (lambda (v)
              (funcall setter
                       `(logior (logand ,v ,mask)
                                (logand ,getter (lognot ,mask))))))))))

;;; Vaguely related definitions that should be moved elsewhere.

;; (defun alist-get (key alist)
;;   "Get the value associated to KEY in ALIST."
;;   (declare
;;    (gv-expander
;;     (lambda (do)
;;       (macroexp-let2 macroexp-copyable-p k key
;;         (gv-letplace (getter setter) alist
;;           (macroexp-let2 nil p `(assoc ,k ,getter)
;;             (funcall do `(cdr ,p)
;;                      (lambda (v)
;;                        `(if ,p (setcdr ,p ,v)
;;                           ,(funcall setter
;;                                     `(cons (cons ,k ,v) ,getter)))))))))))
;;   (cdr (assoc key alist)))

(provide 'gv)
;;; gv.el ends here
