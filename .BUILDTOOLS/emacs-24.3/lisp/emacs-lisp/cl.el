;;; cl.el --- Compatibility aliases for the old CL library.  -*- lexical-binding: t -*-

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Stefan Monnier <monnier@iro.umontreal.ca>
;; Keywords: extensions

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

;; This is a compatibility file which provides the old names provided by CL
;; before we cleaned up its namespace usage.

;;; Code:

(require 'cl-lib)
(require 'macroexp)

;; (defun cl--rename ()
;;   (let ((vdefs ())
;;         (fdefs ())
;;         (case-fold-search nil)
;;         (files '("cl.el" "cl-macs.el" "cl-seq.el" "cl-extra.el")))
;;     (dolist (file files)
;;       (with-current-buffer (find-file-noselect file)
;;         (goto-char (point-min))
;;         (while (re-search-forward
;;                 "^(\\(def[^ \t\n]*\\) +'?\\(\\(\\sw\\|\\s_\\)+\\)" nil t)
;;           (let ((name (match-string-no-properties 2))
;;                 (type (match-string-no-properties 1)))
;;             (unless (string-match-p "\\`cl-" name)
;;               (cond
;;                ((member type '("defvar" "defconst"))
;;                 (unless (member name vdefs) (push name vdefs)))
;;                ((member type '("defun" "defsubst" "defalias" "defmacro"))
;;                 (unless (member name fdefs) (push name fdefs)))
;;                ((member type '("def-edebug-spec" "defsetf" "define-setf-method"
;;                                "define-compiler-macro"))
;;                 nil)
;;                (t (error "Unknown type %S" type))))))))
;;     (let ((re (concat "\\_<" (regexp-opt (append vdefs fdefs)) "\\_>"))
;;           (conflicts ()))
;;       (dolist (file files)
;;         (with-current-buffer (find-file-noselect file)
;;           (goto-char (point-min))
;;           (while (re-search-forward re nil t)
;;             (replace-match "cl-\\&"))
;;           (save-buffer))))
;;     (with-current-buffer (find-file-noselect "cl-rename.el")
;;       (dolist (def vdefs)
;;         (insert (format "(defvaralias '%s 'cl-%s)\n" def def)))
;;       (dolist (def fdefs)
;;         (insert (format "(defalias '%s 'cl-%s)\n" def def)))
;;       (save-buffer))))

;; (defun cl--unrename ()
;;   ;; Taken from "Naming Conventions" node of the doc.
;;   (let* ((names '(defun* defsubst* defmacro* function* member*
;;                          assoc* rassoc* get* remove* delete*
;;                          mapcar* sort* floor* ceiling* truncate*
;;                          round* mod* rem* random*))
;;          (files '("cl.el" "cl-lib.el" "cl-macs.el" "cl-seq.el" "cl-extra.el"))
;;          (re (concat "\\_<cl-" (regexp-opt (mapcar #'symbol-name names))
;;                      "\\_>")))
;;     (dolist (file files)
;;       (with-current-buffer (find-file-noselect file)
;;         (goto-char (point-min))
;;         (while (re-search-forward re nil t)
;;           (delete-region (1- (point)) (point)))
;;         (save-buffer)))))

(defun cl-unload-function ()
  "Stop unloading of the Common Lisp extensions."
  (message "Cannot unload the feature `cl'")
  ;; Stop standard unloading!
  t)

;;; Aliases to cl-lib's features.

(dolist (var '(
               ;; loop-result-var
               ;; loop-result
               ;; loop-initially
               ;; loop-finally
               ;; loop-bindings
               ;; loop-args
               ;; bind-inits
               ;; bind-block
               ;; lambda-list-keywords
               float-negative-epsilon
               float-epsilon
               least-negative-normalized-float
               least-positive-normalized-float
               least-negative-float
               least-positive-float
               most-negative-float
               most-positive-float
               ;; custom-print-functions
               ))
  (defvaralias var (intern (format "cl-%s" var))))

;; Before overwriting subr.el's `dotimes' and `dolist', let's remember
;; them under a different name, so we can use them in our implementation
;; of `dotimes' and `dolist'.
(unless (fboundp 'cl--dotimes)
  (defalias 'cl--dotimes (symbol-function 'dotimes) "The non-CL `dotimes'."))
(unless (fboundp 'cl--dolist)
  (defalias 'cl--dolist (symbol-function 'dolist) "The non-CL `dolist'."))

(dolist (fun '(
               (get* . cl-get)
               (random* . cl-random)
               (rem* . cl-rem)
               (mod* . cl-mod)
               (round* . cl-round)
               (truncate* . cl-truncate)
               (ceiling* . cl-ceiling)
               (floor* . cl-floor)
               (rassoc* . cl-rassoc)
               (assoc* . cl-assoc)
               (member* . cl-member)
               (delete* . cl-delete)
               (remove* . cl-remove)
               (defsubst* . cl-defsubst)
               (sort* . cl-sort)
               (function* . cl-function)
               (defmacro* . cl-defmacro)
               (defun* . cl-defun)
               (mapcar* . cl-mapcar)

               remprop
               getf
               tailp
               list-length
               nreconc
               revappend
               concatenate
               subseq
               random-state-p
               make-random-state
               signum
               isqrt
               lcm
               gcd
               notevery
               notany
               every
               some
               mapcon
               mapcan
               mapl
               maplist
               map
               equalp
               coerce
               tree-equal
               nsublis
               sublis
               nsubst-if-not
               nsubst-if
               nsubst
               subst-if-not
               subst-if
               subsetp
               nset-exclusive-or
               set-exclusive-or
               nset-difference
               set-difference
               nintersection
               intersection
               nunion
               union
               rassoc-if-not
               rassoc-if
               assoc-if-not
               assoc-if
               member-if-not
               member-if
               merge
               stable-sort
               search
               mismatch
               count-if-not
               count-if
               count
               position-if-not
               position-if
               position
               find-if-not
               find-if
               find
               nsubstitute-if-not
               nsubstitute-if
               nsubstitute
               substitute-if-not
               substitute-if
               substitute
               delete-duplicates
               remove-duplicates
               delete-if-not
               delete-if
               remove-if-not
               remove-if
               replace
               fill
               reduce
               compiler-macroexpand
               define-compiler-macro
               assert
               check-type
               typep
               deftype
               defstruct
               callf2
               callf
               letf*
               ;; letf
               rotatef
               shiftf
               remf
               psetf
               (define-setf-method . define-setf-expander)
               declare
               the
               locally
               multiple-value-setq
               multiple-value-bind
               symbol-macrolet
               macrolet
               progv
               psetq
               do-all-symbols
               do-symbols
               dotimes
               dolist
               do*
               do
               loop
               return-from
               return
               block
               etypecase
               typecase
               ecase
               case
               load-time-value
               eval-when
               destructuring-bind
               gentemp
               gensym
               pairlis
               acons
               subst
               adjoin
               copy-list
               ldiff
               list*
               cddddr
               cdddar
               cddadr
               cddaar
               cdaddr
               cdadar
               cdaadr
               cdaaar
               cadddr
               caddar
               cadadr
               cadaar
               caaddr
               caadar
               caaadr
               caaaar
               cdddr
               cddar
               cdadr
               cdaar
               caddr
               cadar
               caadr
               caaar
               tenth
               ninth
               eighth
               seventh
               sixth
               fifth
               fourth
               third
               endp
               rest
               second
               first
               svref
               copy-seq
               evenp
               oddp
               minusp
               plusp
               floatp-safe
               declaim
               proclaim
               nth-value
               multiple-value-call
               multiple-value-apply
               multiple-value-list
               values-list
               values
               pushnew
               decf
               incf
               ))
  (let ((new (if (consp fun) (prog1 (cdr fun) (setq fun (car fun)))
               (intern (format "cl-%s" fun)))))
    (defalias fun new)))

;;; Features provided a bit differently in Elisp.

;; First, the old lexical-let is now better served by `lexical-binding', tho
;; it's not 100% compatible.

(defvar cl-closure-vars nil)
(defvar cl--function-convert-cache nil)

(defun cl--function-convert (f)
  "Special macro-expander for special cases of (function F).
The two cases that are handled are:
- closure-conversion of lambda expressions for `lexical-let'.
- renaming of F when it's a function defined via `cl-labels' or `labels'."
  (require 'cl-macs)
  (declare-function cl--expr-contains-any "cl-macs" (x y))
  (cond
   ;; ¡¡Big Ugly Hack!! We can't use a compiler-macro because those are checked
   ;; *after* handling `function', but we want to stop macroexpansion from
   ;; being applied infinitely, so we use a cache to return the exact `form'
   ;; being expanded even though we don't receive it.
   ((eq f (car cl--function-convert-cache)) (cdr cl--function-convert-cache))
   ((eq (car-safe f) 'lambda)
    (let ((body (mapcar (lambda (f)
                          (macroexpand-all f macroexpand-all-environment))
                        (cddr f))))
      (if (and cl-closure-vars
               (cl--expr-contains-any body cl-closure-vars))
          (let* ((new (mapcar 'cl-gensym cl-closure-vars))
                 (sub (cl-pairlis cl-closure-vars new)) (decls nil))
            (while (or (stringp (car body))
                       (eq (car-safe (car body)) 'interactive))
              (push (list 'quote (pop body)) decls))
            (put (car (last cl-closure-vars)) 'used t)
            `(list 'lambda '(&rest --cl-rest--)
                   ,@(cl-sublis sub (nreverse decls))
                   (list 'apply
                         (list 'quote
                               #'(lambda ,(append new (cadr f))
                                   ,@(cl-sublis sub body)))
                         ,@(nconc (mapcar (lambda (x) `(list 'quote ,x))
                                          cl-closure-vars)
                                  '((quote --cl-rest--))))))
        (let* ((newf `(lambda ,(cadr f) ,@body))
               (res `(function ,newf)))
          (setq cl--function-convert-cache (cons newf res))
          res))))
   (t
    (let ((found (assq f macroexpand-all-environment)))
      (if (and found (ignore-errors
                       (eq (cadr (cl-caddr found)) 'cl-labels-args)))
          (cadr (cl-caddr (cl-cadddr found)))
        (let ((res `(function ,f)))
          (setq cl--function-convert-cache (cons f res))
          res))))))

(defmacro lexical-let (bindings &rest body)
  "Like `let', but lexically scoped.
The main visible difference is that lambdas inside BODY will create
lexical closures as in Common Lisp.
\n(fn BINDINGS BODY)"
  (declare (indent 1) (debug let))
  (let* ((cl-closure-vars cl-closure-vars)
	 (vars (mapcar (function
			(lambda (x)
			  (or (consp x) (setq x (list x)))
			  (push (make-symbol (format "--cl-%s--" (car x)))
				cl-closure-vars)
			  (set (car cl-closure-vars) [bad-lexical-ref])
			  (list (car x) (cadr x) (car cl-closure-vars))))
		       bindings))
	 (ebody
	  (macroexpand-all
           `(cl-symbol-macrolet
                ,(mapcar (lambda (x)
                           `(,(car x) (symbol-value ,(cl-caddr x))))
                         vars)
              ,@body)
	   (cons (cons 'function #'cl--function-convert)
                 macroexpand-all-environment))))
    (if (not (get (car (last cl-closure-vars)) 'used))
        ;; Turn (let ((foo (cl-gensym)))
        ;;        (set foo <val>) ...(symbol-value foo)...)
        ;; into (let ((foo <val>)) ...(symbol-value 'foo)...).
        ;; This is good because it's more efficient but it only works with
        ;; dynamic scoping, since with lexical scoping we'd need
        ;; (let ((foo <val>)) ...foo...).
	`(progn
           ,@(mapcar (lambda (x) `(defvar ,(cl-caddr x))) vars)
           (let ,(mapcar (lambda (x) (list (cl-caddr x) (cadr x))) vars)
           ,(cl-sublis (mapcar (lambda (x)
                              (cons (cl-caddr x)
                                    `',(cl-caddr x)))
                            vars)
                    ebody)))
      `(let ,(mapcar (lambda (x)
                       (list (cl-caddr x)
                             `(make-symbol ,(format "--%s--" (car x)))))
                     vars)
         (setf ,@(apply #'append
                        (mapcar (lambda (x)
                                  (list `(symbol-value ,(cl-caddr x)) (cadr x)))
                                vars)))
         ,ebody))))

(defmacro lexical-let* (bindings &rest body)
  "Like `let*', but lexically scoped.
The main visible difference is that lambdas inside BODY, and in
successive bindings within BINDINGS, will create lexical closures
as in Common Lisp.  This is similar to the behavior of `let*' in
Common Lisp.
\n(fn BINDINGS BODY)"
  (declare (indent 1) (debug let))
  (if (null bindings) (cons 'progn body)
    (setq bindings (reverse bindings))
    (while bindings
      (setq body (list `(lexical-let (,(pop bindings)) ,@body))))
    (car body)))

;; This should really have some way to shadow 'byte-compile properties, etc.
(defmacro flet (bindings &rest body)
  "Make temporary overriding function definitions.
This is an analogue of a dynamically scoped `let' that operates on the function
cell of FUNCs rather than their value cell.
If you want the Common-Lisp style of `flet', you should use `cl-flet'.
The FORMs are evaluated with the specified function definitions in place,
then the definitions are undone (the FUNCs go back to their previous
definitions, or lack thereof).

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)"
  (declare (indent 1) (debug cl-flet)
           (obsolete "use either `cl-flet' or `cl-letf'."  "24.3"))
  `(letf ,(mapcar
           (lambda (x)
             (if (or (and (fboundp (car x))
                          (eq (car-safe (symbol-function (car x))) 'macro))
                     (cdr (assq (car x) macroexpand-all-environment)))
                 (error "Use `labels', not `flet', to rebind macro names"))
             (let ((func `(cl-function
                           (lambda ,(cadr x)
                             (cl-block ,(car x) ,@(cddr x))))))
               (when (cl--compiling-file)
                 ;; Bug#411.  It would be nice to fix this.
                 (and (get (car x) 'byte-compile)
                      (error "Byte-compiling a redefinition of `%s' \
will not work - use `labels' instead" (symbol-name (car x))))
                 ;; FIXME This affects the rest of the file, when it
                 ;; should be restricted to the flet body.
                 (and (boundp 'byte-compile-function-environment)
                      (push (cons (car x) (eval func))
                            byte-compile-function-environment)))
               (list `(symbol-function ',(car x)) func)))
           bindings)
     ,@body))

(defmacro labels (bindings &rest body)
  "Make temporary function bindings.
Like `cl-labels' except that the lexical scoping is handled via `lexical-let'
rather than relying on `lexical-binding'."
  (declare (indent 1) (debug cl-flet) (obsolete cl-labels "24.3"))
  (let ((vars nil) (sets nil) (newenv macroexpand-all-environment))
    (dolist (binding bindings)
      ;; It's important that (not (eq (symbol-name var1) (symbol-name var2)))
      ;; because these var's *names* get added to the macro-environment.
      (let ((var (make-symbol (format "--cl-%s--" (car binding)))))
	(push var vars)
	(push `(cl-function (lambda . ,(cdr binding))) sets)
	(push var sets)
	(push (cons (car binding)
                    `(lambda (&rest cl-labels-args)
                       (cl-list* 'funcall ',var
                                 cl-labels-args)))
              newenv)))
    (macroexpand-all `(lexical-let ,vars (setq ,@sets) ,@body) newenv)))

;; Generalized variables are provided by gv.el, but some details are
;; not 100% compatible: not worth the trouble to add them to cl-lib.el, but we
;; still need to support old users of cl.el.

(defmacro cl--symbol-function (symbol)
  "Like `symbol-function' but return `cl--unbound' if not bound."
  ;; (declare (gv-setter (lambda (store)
  ;;                       `(if (eq ,store 'cl--unbound)
  ;;                            (fmakunbound ,symbol) (fset ,symbol ,store)))))
  `(if (fboundp ,symbol) (symbol-function ,symbol) 'cl--unbound))
(gv-define-setter cl--symbol-function (store symbol)
  `(if (eq ,store 'cl--unbound) (fmakunbound ,symbol) (fset ,symbol ,store)))

(defmacro letf (bindings &rest body)
  "Dynamically scoped let-style bindings for places.
For more details, see `cl-letf'.  This macro behaves like that one
in almost every respect (apart from details that relate to some
deprecated usage of `symbol-function' in place forms)."  ; bug#12760
  (declare (indent 1) (debug cl-letf))
  ;; Like cl-letf, but with special handling of symbol-function.
  `(cl-letf ,(mapcar (lambda (x) (if (eq (car-safe (car x)) 'symbol-function)
                                `((cl--symbol-function ,@(cdar x)) ,@(cdr x))
                              x))
                     bindings)
            ,@body))

(defun cl--gv-adapt (cl-gv do)
  ;; This function is used by all .elc files that use define-setf-expander and
  ;; were compiled with Emacs>=24.3.
  (let ((vars (nth 0 cl-gv))
        (vals (nth 1 cl-gv))
        (binds ())
        (substs ()))
    ;; Use cl-sublis as was done in cl-setf-do-modify.
    (while vars
      (if (macroexp-copyable-p (car vals))
          (push (cons (pop vars) (pop vals)) substs)
        (push (list (pop vars) (pop vals)) binds)))
    (macroexp-let*
     binds
     (funcall do (cl-sublis substs (nth 4 cl-gv))
              ;; We'd like to do something like
              ;; (lambda ,(nth 2 cl-gv) ,(nth 3 cl-gv)).
              (lambda (exp)
                (macroexp-let2 macroexp-copyable-p v exp
                  (cl-sublis (cons (cons (car (nth 2 cl-gv)) v)
                                   substs)
                             (nth 3 cl-gv))))))))

(defmacro define-setf-expander (name arglist &rest body)
  "Define a `setf' method.
This method shows how to handle `setf's to places of the form
\(NAME ARGS...).  The argument forms ARGS are bound according to
ARGLIST, as if NAME were going to be expanded as a macro, then
the BODY forms are executed and must return a list of five elements:
a temporary-variables list, a value-forms list, a store-variables list
\(of length one), a store-form, and an access- form.

See `gv-define-expander', and `gv-define-setter' for better and
simpler ways to define setf-methods."
  (declare (debug
            (&define name cl-lambda-list cl-declarations-or-string def-body)))
  `(progn
     ,@(if (stringp (car body))
           (list `(put ',name 'setf-documentation ,(pop body))))
     (gv-define-expander ,name
       (cl-function
        (lambda (do ,@arglist)
          (cl--gv-adapt (progn ,@body) do))))))

(defmacro defsetf (name arg1 &rest args)
  "Define a `setf' method.
This macro is an easy-to-use substitute for `define-setf-expander'
that works well for simple place forms.

In the simple `defsetf' form, `setf's of the form (setf (NAME
ARGS...) VAL) are transformed to function or macro calls of the
form (FUNC ARGS... VAL).  For example:

  (defsetf aref aset)

You can replace this form with `gv-define-simple-setter'.

Alternate form: (defsetf NAME ARGLIST (STORE) BODY...).

Here, the above `setf' call is expanded by binding the argument
forms ARGS according to ARGLIST, binding the value form VAL to
STORE, then executing BODY, which must return a Lisp form that
does the necessary `setf' operation.  Actually, ARGLIST and STORE
may be bound to temporary variables which are introduced
automatically to preserve proper execution order of the arguments.
For example:

  (defsetf nth (n x) (v) `(setcar (nthcdr ,n ,x) ,v))

You can replace this form with `gv-define-setter'.

\(fn NAME [FUNC | ARGLIST (STORE) BODY...])"
  (declare (debug
            (&define name
                     [&or [symbolp &optional stringp]
                          [cl-lambda-list (symbolp)]]
                     cl-declarations-or-string def-body)))
  (if (and (listp arg1) (consp args))
      ;; Like `gv-define-setter' but with `cl-function'.
      `(gv-define-expander ,name
         (lambda (do &rest args)
           (gv--defsetter ',name
                          (cl-function
                           (lambda (,@(car args) ,@arg1) ,@(cdr args)))
			  do args)))
    `(gv-define-simple-setter ,name ,arg1 ,(car args))))

;; FIXME: CL used to provide a setf method for `apply', but I haven't been able
;; to find a case where it worked.  The code below tries to handle it as well.
;; (defun cl--setf-apply (form last-witness last)
;;   (cond
;;    ((not (consp form)) form)
;;    ((eq (ignore-errors (car (last form))) last-witness)
;;     `(apply #',(car form) ,@(butlast (cdr form)) ,last))
;;    ((and (memq (car form) '(let let*))
;;          (rassoc (list last-witness) (cadr form)))
;;     (let ((rebind (rassoc (list last-witness) (cadr form))))
;;     `(,(car form) ,(remq rebind (cadr form))
;;       ,@(mapcar (lambda (form) (cl--setf-apply form (car rebind) last))
;;                 (cddr form)))))
;;    (t (mapcar (lambda (form) (cl--setf-apply form last-witness last)) form))))
;; (gv-define-setter apply (val fun &rest args)
;;   (pcase fun (`#',(and (pred symbolp) f) (setq fun f))
;;          (_ (error "First arg to apply in setf is not #'SYM: %S" fun)))
;;   (let* ((butlast (butlast args))
;;          (last (car (last args)))
;;          (last-witness (make-symbol "--cl-tailarg--"))
;;          (setter (macroexpand `(setf (,fun ,@butlast ,last-witness) ,val)
;;                               macroexpand-all-environment)))
;;     (cl--setf-apply setter last-witness last)))


;; FIXME: CL used to provide get-setf-method, which was used by some
;; setf-expanders, but now that we use gv.el, it is a lot more difficult
;; and in general impossible to provide get-setf-method.  Hopefully, it
;; won't be needed.  If needed, we'll have to do something nasty along the
;; lines of
;; (defun get-setf-method (place &optional env)
;;   (let* ((witness (list 'cl-gsm))
;;          (expansion (gv-letplace (getter setter) place
;;                      `(,witness ,getter ,(funcall setter witness)))))
;;     ...find "let prefix" of expansion, extract getter and setter from
;;     ...the rest, and build the 5-tuple))
(make-obsolete 'get-setf-method 'gv-letplace "24.3")

(defmacro define-modify-macro (name arglist func &optional doc)
  "Define a `setf'-like modify macro.
If NAME is called, it combines its PLACE argument with the other
arguments from ARGLIST using FUNC.  For example:

  (define-modify-macro incf (&optional (n 1)) +)

You can replace this macro with `gv-letplace'."
  (declare (debug
            (&define name cl-lambda-list ;; should exclude &key
                     symbolp &optional stringp)))
  (if (memq '&key arglist)
      (error "&key not allowed in define-modify-macro"))
  (let ((place (make-symbol "--cl-place--")))
    `(cl-defmacro ,name (,place ,@arglist)
       ,doc
       (,(if (memq '&rest arglist) #'cl-list* #'list)
        #'cl-callf ',func ,place
        ,@(cl--arglist-args arglist)))))

;;; Additional compatibility code.
;; For names that were clean but really aren't needed any more.

(define-obsolete-function-alias 'cl-macroexpand 'macroexpand "24.3")
(define-obsolete-variable-alias 'cl-macro-environment
  'macroexpand-all-environment "24.3")
(define-obsolete-function-alias 'cl-macroexpand-all 'macroexpand-all "24.3")

;;; Hash tables.
;; This is just kept for compatibility with code byte-compiled by Emacs-20.

;; No idea if this might still be needed.
(defun cl-not-hash-table (x &optional y &rest _z)
  (declare (obsolete nil "24.3"))
  (signal 'wrong-type-argument (list 'cl-hash-table-p (or y x))))

(defvar cl-builtin-gethash (symbol-function 'gethash))
(make-obsolete-variable 'cl-builtin-gethash nil "24.3")
(defvar cl-builtin-remhash (symbol-function 'remhash))
(make-obsolete-variable 'cl-builtin-remhash nil "24.3")
(defvar cl-builtin-clrhash (symbol-function 'clrhash))
(make-obsolete-variable 'cl-builtin-clrhash nil "24.3")
(defvar cl-builtin-maphash (symbol-function 'maphash))

(make-obsolete-variable 'cl-builtin-maphash nil "24.3")
(define-obsolete-function-alias 'cl-map-keymap 'map-keymap "24.3")
(define-obsolete-function-alias 'cl-copy-tree 'copy-tree "24.3")
(define-obsolete-function-alias 'cl-gethash 'gethash "24.3")
(define-obsolete-function-alias 'cl-puthash 'puthash "24.3")
(define-obsolete-function-alias 'cl-remhash 'remhash "24.3")
(define-obsolete-function-alias 'cl-clrhash 'clrhash "24.3")
(define-obsolete-function-alias 'cl-maphash 'maphash "24.3")
(define-obsolete-function-alias 'cl-make-hash-table 'make-hash-table "24.3")
(define-obsolete-function-alias 'cl-hash-table-p 'hash-table-p "24.3")
(define-obsolete-function-alias 'cl-hash-table-count 'hash-table-count "24.3")

(define-obsolete-function-alias 'cl-map-keymap-recursively
  'cl--map-keymap-recursively "24.3")
(define-obsolete-function-alias 'cl-map-intervals 'cl--map-intervals "24.3")
(define-obsolete-function-alias 'cl-map-extents 'cl--map-overlays "24.3")
(define-obsolete-function-alias 'cl-set-getf 'cl--set-getf "24.3")

(defun cl-maclisp-member (item list)
  (declare (obsolete member "24.3"))
  (while (and list (not (equal item (car list)))) (setq list (cdr list)))
  list)

;; Used in the expansion of the old `defstruct'.
(defun cl-struct-setf-expander (x name accessor pred-form pos)
  (declare (obsolete nil "24.3"))
  (let* ((temp (make-symbol "--cl-x--")) (store (make-symbol "--cl-store--")))
    (list (list temp) (list x) (list store)
	  `(progn
             ,@(and pred-form
                    (list `(or ,(cl-subst temp 'cl-x pred-form)
                               (error ,(format
                                        "%s storing a non-%s"
                                        accessor name)))))
             ,(if (eq (car (get name 'cl-struct-type)) 'vector)
                  `(aset ,temp ,pos ,store)
                `(setcar
                  ,(if (<= pos 5)
                       (let ((xx temp))
                         (while (>= (setq pos (1- pos)) 0)
                           (setq xx `(cdr ,xx)))
                         xx)
                     `(nthcdr ,pos ,temp))
                  ,store)))
	  (list accessor temp))))

(provide 'cl)

(run-hooks 'cl-load-hook)

;;; cl.el ends here
