;;; cl-lib.el --- Common Lisp extensions for Emacs  -*- lexical-binding: t -*-

;; Copyright (C) 1993, 2001-2013 Free Software Foundation, Inc.

;; Author: Dave Gillespie <daveg@synaptics.com>
;; Version: 1.0
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

;; These are extensions to Emacs Lisp that provide a degree of
;; Common Lisp compatibility, beyond what is already built-in
;; in Emacs Lisp.
;;
;; This package was written by Dave Gillespie; it is a complete
;; rewrite of Cesar Quiroz's original cl.el package of December 1986.
;;
;; Bug reports, comments, and suggestions are welcome!

;; This file contains the portions of the Common Lisp extensions
;; package which should always be present.


;;; Future notes:

;; Once Emacs 19 becomes standard, many things in this package which are
;; messy for reasons of compatibility can be greatly simplified.  For now,
;; I prefer to maintain one unified version.


;;; Change Log:

;; Version 2.02 (30 Jul 93):
;;  * Added "cl-compat.el" file, extra compatibility with old package.
;;  * Added `lexical-let' and `lexical-let*'.
;;  * Added `define-modify-macro', `callf', and `callf2'.
;;  * Added `ignore-errors'.
;;  * Changed `(setf (nthcdr N PLACE) X)' to work when N is zero.
;;  * Merged `*gentemp-counter*' into `*gensym-counter*'.
;;  * Extended `subseq' to allow negative START and END like `substring'.
;;  * Added `in-ref', `across-ref', `elements of-ref' loop clauses.
;;  * Added `concat', `vconcat' loop clauses.
;;  * Cleaned up a number of compiler warnings.

;; Version 2.01 (7 Jul 93):
;;  * Added support for FSF version of Emacs 19.
;;  * Added `add-hook' for Emacs 18 users.
;;  * Added `defsubst*' and `symbol-macrolet'.
;;  * Added `maplist', `mapc', `mapl', `mapcan', `mapcon'.
;;  * Added `map', `concatenate', `reduce', `merge'.
;;  * Added `revappend', `nreconc', `tailp', `tree-equal'.
;;  * Added `assert', `check-type', `typecase', `typep', and `deftype'.
;;  * Added destructuring and `&environment' support to `defmacro*'.
;;  * Added destructuring to `loop', and added the following clauses:
;;      `elements', `frames', `overlays', `intervals', `buffers', `key-seqs'.
;;  * Renamed `delete' to `delete*' and `remove' to `remove*'.
;;  * Completed support for all keywords in `remove*', `substitute', etc.
;;  * Added `most-positive-float' and company.
;;  * Fixed hash tables to work with latest Lucid Emacs.
;;  * `proclaim' forms are no longer compile-time-evaluating; use `declaim'.
;;  * Syntax for `warn' declarations has changed.
;;  * Improved implementation of `random*'.
;;  * Moved most sequence functions to a new file, cl-seq.el.
;;  * Moved `eval-when' into cl-macs.el.
;;  * Moved `pushnew' and `adjoin' to cl.el for most common cases.
;;  * Moved `provide' forms down to ends of files.
;;  * Changed expansion of `pop' to something that compiles to better code.
;;  * Changed so that no patch is required for Emacs 19 byte compiler.
;;  * Made more things dependent on `optimize' declarations.
;;  * Added a partial implementation of struct print functions.
;;  * Miscellaneous minor changes.

;; Version 2.00:
;;  * First public release of this package.


;;; Code:

(require 'macroexp)

(defvar cl-optimize-speed 1)
(defvar cl-optimize-safety 1)

;;;###autoload
(define-obsolete-variable-alias
  ;; This alias is needed for compatibility with .elc files that use defstruct
  ;; and were compiled with Emacs<24.3.
  'custom-print-functions 'cl-custom-print-functions "24.3")

;;;###autoload
(defvar cl-custom-print-functions nil
  "This is a list of functions that format user objects for printing.
Each function is called in turn with three arguments: the object, the
stream, and the print level (currently ignored).  If it is able to
print the object it returns true; otherwise it returns nil and the
printer proceeds to the next function on the list.

This variable is not used at present, but it is defined in hopes that
a future Emacs interpreter will be able to use it.")

;;; Generalized variables.
;; These macros are defined here so that they
;; can safely be used in init files.

(defmacro cl-incf (place &optional x)
  "Increment PLACE by X (1 by default).
PLACE may be a symbol, or any generalized variable allowed by `setf'.
The return value is the incremented value of PLACE."
  (declare (debug (place &optional form)))
  (if (symbolp place)
      (list 'setq place (if x (list '+ place x) (list '1+ place)))
    (list 'cl-callf '+ place (or x 1))))

(defmacro cl-decf (place &optional x)
  "Decrement PLACE by X (1 by default).
PLACE may be a symbol, or any generalized variable allowed by `setf'.
The return value is the decremented value of PLACE."
  (declare (debug cl-incf))
  (if (symbolp place)
      (list 'setq place (if x (list '- place x) (list '1- place)))
    (list 'cl-callf '- place (or x 1))))

(defmacro cl-pushnew (x place &rest keys)
  "(cl-pushnew X PLACE): insert X at the head of the list if not already there.
Like (push X PLACE), except that the list is unmodified if X is `eql' to
an element already on the list.
\nKeywords supported:  :test :test-not :key
\n(fn X PLACE [KEYWORD VALUE]...)"
  (declare (debug
            (form place &rest
                  &or [[&or ":test" ":test-not" ":key"] function-form]
                  [keywordp form])))
  (if (symbolp place)
      (if (null keys)
          (macroexp-let2 nil var x
            `(if (memql ,var ,place)
                 ;; This symbol may later on expand to actual code which then
                 ;; trigger warnings like "value unused" since cl-pushnew's
                 ;; return value is rarely used.  It should not matter that
                 ;; other warnings may be silenced, since `place' is used
                 ;; earlier and should have triggered them already.
                 (with-no-warnings ,place)
               (setq ,place (cons ,var ,place))))
	(list 'setq place (cl-list* 'cl-adjoin x place keys)))
    (cl-list* 'cl-callf2 'cl-adjoin x place keys)))

(defun cl--set-elt (seq n val)
  (if (listp seq) (setcar (nthcdr n seq) val) (aset seq n val)))

(defun cl--set-buffer-substring (start end val)
  (save-excursion (delete-region start end)
		  (goto-char start)
		  (insert val)
		  val))

(defun cl--set-substring (str start end val)
  (if end (if (< end 0) (cl-incf end (length str)))
    (setq end (length str)))
  (if (< start 0) (cl-incf start (length str)))
  (concat (and (> start 0) (substring str 0 start))
	  val
	  (and (< end (length str)) (substring str end))))


;;; Blocks and exits.

(defalias 'cl--block-wrapper 'identity)
(defalias 'cl--block-throw 'throw)


;;; Multiple values.
;; True multiple values are not supported, or even
;; simulated.  Instead, cl-multiple-value-bind and friends simply expect
;; the target form to return the values as a list.

(defun cl--defalias (cl-f el-f &optional doc)
  (defalias cl-f el-f doc)
  (put cl-f 'byte-optimizer 'byte-compile-inline-expand))

(cl--defalias 'cl-values #'list
  "Return multiple values, Common Lisp style.
The arguments of `cl-values' are the values
that the containing function should return.

\(fn &rest VALUES)")

(cl--defalias 'cl-values-list #'identity
  "Return multiple values, Common Lisp style, taken from a list.
LIST specifies the list of values
that the containing function should return.

\(fn LIST)")

(defsubst cl-multiple-value-list (expression)
  "Return a list of the multiple values produced by EXPRESSION.
This handles multiple values in Common Lisp style, but it does not
work right when EXPRESSION calls an ordinary Emacs Lisp function
that returns just one value."
  expression)

(defsubst cl-multiple-value-apply (function expression)
  "Evaluate EXPRESSION to get multiple values and apply FUNCTION to them.
This handles multiple values in Common Lisp style, but it does not work
right when EXPRESSION calls an ordinary Emacs Lisp function that returns just
one value."
  (apply function expression))

(defalias 'cl-multiple-value-call 'apply
  "Apply FUNCTION to ARGUMENTS, taking multiple values into account.
This implementation only handles the case where there is only one argument.")

(cl--defalias 'cl-nth-value #'nth
  "Evaluate EXPRESSION to get multiple values and return the Nth one.
This handles multiple values in Common Lisp style, but it does not work
right when EXPRESSION calls an ordinary Emacs Lisp function that returns just
one value.

\(fn N EXPRESSION)")

;;; Declarations.

(defvar cl--compiling-file nil)
(defun cl--compiling-file ()
  (or cl--compiling-file
      (and (boundp 'byte-compile--outbuffer)
           (bufferp (symbol-value 'byte-compile--outbuffer))
	   (equal (buffer-name (symbol-value 'byte-compile--outbuffer))
		  " *Compiler Output*"))))

(defvar cl-proclaims-deferred nil)

(defun cl-proclaim (spec)
  "Record a global declaration specified by SPEC."
  (if (fboundp 'cl-do-proclaim) (cl-do-proclaim spec t)
    (push spec cl-proclaims-deferred))
  nil)

(defmacro cl-declaim (&rest specs)
  "Like `cl-proclaim', but takes any number of unevaluated, unquoted arguments.
Puts `(cl-eval-when (compile load eval) ...)' around the declarations
so that they are registered at compile-time as well as run-time."
  (let ((body (mapcar (function (lambda (x)
                                  (list 'cl-proclaim (list 'quote x))))
		      specs)))
    (if (cl--compiling-file) (cl-list* 'cl-eval-when '(compile load eval) body)
      (cons 'progn body))))   ; avoid loading cl-macs.el for cl-eval-when


;;; Symbols.

(defun cl-random-time ()
  (let* ((time (copy-sequence (current-time-string))) (i (length time)) (v 0))
    (while (>= (cl-decf i) 0) (setq v (+ (* v 3) (aref time i))))
    v))

(defvar cl--gensym-counter (* (logand (cl-random-time) 1023) 100))


;;; Numbers.

(defun cl-floatp-safe (object)
  "Return t if OBJECT is a floating point number.
On Emacs versions that lack floating-point support, this function
always returns nil."
  (and (numberp object) (not (integerp object))))

(defsubst cl-plusp (number)
  "Return t if NUMBER is positive."
  (> number 0))

(defsubst cl-minusp (number)
  "Return t if NUMBER is negative."
  (< number 0))

(defun cl-oddp (integer)
  "Return t if INTEGER is odd."
  (eq (logand integer 1) 1))

(defun cl-evenp (integer)
  "Return t if INTEGER is even."
  (eq (logand integer 1) 0))

(defvar cl--random-state (vector 'cl-random-state-tag -1 30 (cl-random-time)))

(defconst cl-most-positive-float nil
  "The largest value that a Lisp float can hold.
If your system supports infinities, this is the largest finite value.
For IEEE machines, this is approximately 1.79e+308.
Call `cl-float-limits' to set this.")

(defconst cl-most-negative-float nil
  "The largest negative value that a Lisp float can hold.
This is simply -`cl-most-positive-float'.
Call `cl-float-limits' to set this.")

(defconst cl-least-positive-float nil
  "The smallest value greater than zero that a Lisp float can hold.
For IEEE machines, it is about 4.94e-324 if denormals are supported,
or 2.22e-308 if they are not.
Call `cl-float-limits' to set this.")

(defconst cl-least-negative-float nil
  "The smallest value less than zero that a Lisp float can hold.
This is simply -`cl-least-positive-float'.
Call `cl-float-limits' to set this.")

(defconst cl-least-positive-normalized-float nil
  "The smallest normalized Lisp float greater than zero.
This is the smallest value for which IEEE denormalization does not lose
precision.  For IEEE machines, this value is about 2.22e-308.
For machines that do not support the concept of denormalization
and gradual underflow, this constant equals `cl-least-positive-float'.
Call `cl-float-limits' to set this.")

(defconst cl-least-negative-normalized-float nil
  "The smallest normalized Lisp float less than zero.
This is simply -`cl-least-positive-normalized-float'.
Call `cl-float-limits' to set this.")

(defconst cl-float-epsilon nil
  "The smallest positive float that adds to 1.0 to give a distinct value.
Adding a number less than this to 1.0 returns 1.0 due to roundoff.
For IEEE machines, epsilon is about 2.22e-16.
Call `cl-float-limits' to set this.")

(defconst cl-float-negative-epsilon nil
  "The smallest positive float that subtracts from 1.0 to give a distinct value.
For IEEE machines, it is about 1.11e-16.
Call `cl-float-limits' to set this.")


;;; Sequence functions.

(cl--defalias 'cl-copy-seq 'copy-sequence)

(declare-function cl--mapcar-many "cl-extra" (cl-func cl-seqs))

(defun cl-mapcar (cl-func cl-x &rest cl-rest)
  "Apply FUNCTION to each element of SEQ, and make a list of the results.
If there are several SEQs, FUNCTION is called with that many arguments,
and mapping stops as soon as the shortest list runs out.  With just one
SEQ, this is like `mapcar'.  With several, it is like the Common Lisp
`mapcar' function extended to arbitrary sequence types.
\n(fn FUNCTION SEQ...)"
  (if cl-rest
      (if (or (cdr cl-rest) (nlistp cl-x) (nlistp (car cl-rest)))
	  (cl--mapcar-many cl-func (cons cl-x cl-rest))
	(let ((cl-res nil) (cl-y (car cl-rest)))
	  (while (and cl-x cl-y)
	    (push (funcall cl-func (pop cl-x) (pop cl-y)) cl-res))
	  (nreverse cl-res)))
    (mapcar cl-func cl-x)))

(cl--defalias 'cl-svref 'aref)

;;; List functions.

(cl--defalias 'cl-first 'car)
(cl--defalias 'cl-second 'cadr)
(cl--defalias 'cl-rest 'cdr)
(cl--defalias 'cl-endp 'null)

(cl--defalias 'cl-third 'cl-caddr "Return the third element of the list X.")
(cl--defalias 'cl-fourth 'cl-cadddr "Return the fourth element of the list X.")

(defsubst cl-fifth (x)
  "Return the fifth element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 4 ,x) ,store))))
  (nth 4 x))

(defsubst cl-sixth (x)
  "Return the sixth element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 5 ,x) ,store))))
  (nth 5 x))

(defsubst cl-seventh (x)
  "Return the seventh element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 6 ,x) ,store))))
  (nth 6 x))

(defsubst cl-eighth (x)
  "Return the eighth element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 7 ,x) ,store))))
  (nth 7 x))

(defsubst cl-ninth (x)
  "Return the ninth element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 8 ,x) ,store))))
  (nth 8 x))

(defsubst cl-tenth (x)
  "Return the tenth element of the list X."
  (declare (gv-setter (lambda (store) `(setcar (nthcdr 9 ,x) ,store))))
  (nth 9 x))

(defun cl-caaar (x)
  "Return the `car' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (car x))))

(defun cl-caadr (x)
  "Return the `car' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (cdr x))))

(defun cl-cadar (x)
  "Return the `car' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (car x))))

(defun cl-caddr (x)
  "Return the `car' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (cdr x))))

(defun cl-cdaar (x)
  "Return the `cdr' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (car x))))

(defun cl-cdadr (x)
  "Return the `cdr' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (cdr x))))

(defun cl-cddar (x)
  "Return the `cdr' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (car x))))

(defun cl-cdddr (x)
  "Return the `cdr' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (cdr x))))

(defun cl-caaaar (x)
  "Return the `car' of the `car' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (car (car x)))))

(defun cl-caaadr (x)
  "Return the `car' of the `car' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (car (cdr x)))))

(defun cl-caadar (x)
  "Return the `car' of the `car' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (cdr (car x)))))

(defun cl-caaddr (x)
  "Return the `car' of the `car' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (car (cdr (cdr x)))))

(defun cl-cadaar (x)
  "Return the `car' of the `cdr' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (car (car x)))))

(defun cl-cadadr (x)
  "Return the `car' of the `cdr' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (car (cdr x)))))

(defun cl-caddar (x)
  "Return the `car' of the `cdr' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (cdr (car x)))))

(defun cl-cadddr (x)
  "Return the `car' of the `cdr' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (car (cdr (cdr (cdr x)))))

(defun cl-cdaaar (x)
  "Return the `cdr' of the `car' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (car (car x)))))

(defun cl-cdaadr (x)
  "Return the `cdr' of the `car' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (car (cdr x)))))

(defun cl-cdadar (x)
  "Return the `cdr' of the `car' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (cdr (car x)))))

(defun cl-cdaddr (x)
  "Return the `cdr' of the `car' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (car (cdr (cdr x)))))

(defun cl-cddaar (x)
  "Return the `cdr' of the `cdr' of the `car' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (car (car x)))))

(defun cl-cddadr (x)
  "Return the `cdr' of the `cdr' of the `car' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (car (cdr x)))))

(defun cl-cdddar (x)
  "Return the `cdr' of the `cdr' of the `cdr' of the `car' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (cdr (car x)))))

(defun cl-cddddr (x)
  "Return the `cdr' of the `cdr' of the `cdr' of the `cdr' of X."
  (declare (compiler-macro cl--compiler-macro-cXXr))
  (cdr (cdr (cdr (cdr x)))))

;;(defun last* (x &optional n)
;;  "Returns the last link in the list LIST.
;;With optional argument N, returns Nth-to-last link (default 1)."
;;  (if n
;;      (let ((m 0) (p x))
;;	(while (consp p) (cl-incf m) (pop p))
;;	(if (<= n 0) p
;;	  (if (< n m) (nthcdr (- m n) x) x)))
;;    (while (consp (cdr x)) (pop x))
;;    x))

(defun cl-list* (arg &rest rest)
  "Return a new list with specified ARGs as elements, consed to last ARG.
Thus, `(cl-list* A B C D)' is equivalent to `(nconc (list A B C) D)', or to
`(cons A (cons B (cons C D)))'.
\n(fn ARG...)"
  (declare (compiler-macro cl--compiler-macro-list*))
  (cond ((not rest) arg)
	((not (cdr rest)) (cons arg (car rest)))
	(t (let* ((n (length rest))
		  (copy (copy-sequence rest))
		  (last (nthcdr (- n 2) copy)))
	     (setcdr last (car (cdr last)))
	     (cons arg copy)))))

(defun cl-ldiff (list sublist)
  "Return a copy of LIST with the tail SUBLIST removed."
  (let ((res nil))
    (while (and (consp list) (not (eq list sublist)))
      (push (pop list) res))
    (nreverse res)))

(defun cl-copy-list (list)
  "Return a copy of LIST, which may be a dotted list.
The elements of LIST are not copied, just the list structure itself."
  (if (consp list)
      (let ((res nil))
	(while (consp list) (push (pop list) res))
	(prog1 (nreverse res) (setcdr res list)))
    (car list)))

;; Autoloaded, but we have not loaded cl-loaddefs yet.
(declare-function cl-floor "cl-extra" (x &optional y))
(declare-function cl-ceiling "cl-extra" (x &optional y))
(declare-function cl-truncate "cl-extra" (x &optional y))
(declare-function cl-round "cl-extra" (x &optional y))
(declare-function cl-mod "cl-extra" (x y))

(defun cl-adjoin (cl-item cl-list &rest cl-keys)
  "Return ITEM consed onto the front of LIST only if it's not already there.
Otherwise, return LIST unmodified.
\nKeywords supported:  :test :test-not :key
\n(fn ITEM LIST [KEYWORD VALUE]...)"
  (declare (compiler-macro cl--compiler-macro-adjoin))
  (cond ((or (equal cl-keys '(:test eq))
	     (and (null cl-keys) (not (numberp cl-item))))
	 (if (memq cl-item cl-list) cl-list (cons cl-item cl-list)))
	((or (equal cl-keys '(:test equal)) (null cl-keys))
	 (if (member cl-item cl-list) cl-list (cons cl-item cl-list)))
	(t (apply 'cl--adjoin cl-item cl-list cl-keys))))

(defun cl-subst (cl-new cl-old cl-tree &rest cl-keys)
  "Substitute NEW for OLD everywhere in TREE (non-destructively).
Return a copy of TREE with all elements `eql' to OLD replaced by NEW.
\nKeywords supported:  :test :test-not :key
\n(fn NEW OLD TREE [KEYWORD VALUE]...)"
  (if (or cl-keys (and (numberp cl-old) (not (integerp cl-old))))
      (apply 'cl-sublis (list (cons cl-old cl-new)) cl-tree cl-keys)
    (cl--do-subst cl-new cl-old cl-tree)))

(defun cl--do-subst (cl-new cl-old cl-tree)
  (cond ((eq cl-tree cl-old) cl-new)
	((consp cl-tree)
	 (let ((a (cl--do-subst cl-new cl-old (car cl-tree)))
	       (d (cl--do-subst cl-new cl-old (cdr cl-tree))))
	   (if (and (eq a (car cl-tree)) (eq d (cdr cl-tree)))
	       cl-tree (cons a d))))
	(t cl-tree)))

(defun cl-acons (key value alist)
  "Add KEY and VALUE to ALIST.
Return a new list with (cons KEY VALUE) as car and ALIST as cdr."
  (cons (cons key value) alist))

(defun cl-pairlis (keys values &optional alist)
  "Make an alist from KEYS and VALUES.
Return a new alist composed by associating KEYS to corresponding VALUES;
the process stops as soon as KEYS or VALUES run out.
If ALIST is non-nil, the new pairs are prepended to it."
  (nconc (cl-mapcar 'cons keys values) alist))


;;; Generalized variables.

;; These used to be in cl-macs.el since all macros that use them (like setf)
;; were autoloaded from cl-macs.el.  But now that setf, push, and pop are in
;; core Elisp, they need to either be right here or be autoloaded via
;; cl-loaddefs.el, which is more trouble than it is worth.

;; Some more Emacs-related place types.
(gv-define-simple-setter buffer-file-name set-visited-file-name t)
(gv-define-setter buffer-modified-p (flag &optional buf)
  `(with-current-buffer ,buf
     (set-buffer-modified-p ,flag)))
(gv-define-simple-setter buffer-name rename-buffer t)
(gv-define-setter buffer-string (store)
  `(insert (prog1 ,store (erase-buffer))))
(gv-define-simple-setter buffer-substring cl--set-buffer-substring)
(gv-define-simple-setter current-buffer set-buffer)
(gv-define-simple-setter current-case-table set-case-table)
(gv-define-simple-setter current-column move-to-column t)
(gv-define-simple-setter current-global-map use-global-map t)
(gv-define-setter current-input-mode (store)
  `(progn (apply #'set-input-mode ,store) ,store))
(gv-define-simple-setter current-local-map use-local-map t)
(gv-define-simple-setter current-window-configuration
                         set-window-configuration t)
(gv-define-simple-setter default-file-modes set-default-file-modes t)
(gv-define-simple-setter documentation-property put)
(gv-define-setter face-background (x f &optional s)
  `(set-face-background ,f ,x ,s))
(gv-define-setter face-background-pixmap (x f &optional s)
  `(set-face-background-pixmap ,f ,x ,s))
(gv-define-setter face-font (x f &optional s) `(set-face-font ,f ,x ,s))
(gv-define-setter face-foreground (x f &optional s)
  `(set-face-foreground ,f ,x ,s))
(gv-define-setter face-underline-p (x f &optional s)
  `(set-face-underline ,f ,x ,s))
(gv-define-simple-setter file-modes set-file-modes t)
(gv-define-simple-setter frame-height set-screen-height t)
(gv-define-simple-setter frame-parameters modify-frame-parameters t)
(gv-define-simple-setter frame-visible-p cl--set-frame-visible-p)
(gv-define-simple-setter frame-width set-screen-width t)
(gv-define-simple-setter getenv setenv t)
(gv-define-simple-setter get-register set-register)
(gv-define-simple-setter global-key-binding global-set-key)
(gv-define-simple-setter local-key-binding local-set-key)
(gv-define-simple-setter mark set-mark t)
(gv-define-simple-setter mark-marker set-mark t)
(gv-define-simple-setter marker-position set-marker t)
(gv-define-setter mouse-position (store scr)
  `(set-mouse-position ,scr (car ,store) (cadr ,store)
                       (cddr ,store)))
(gv-define-simple-setter point goto-char)
(gv-define-simple-setter point-marker goto-char t)
(gv-define-setter point-max (store)
  `(progn (narrow-to-region (point-min) ,store) ,store))
(gv-define-setter point-min (store)
  `(progn (narrow-to-region ,store (point-max)) ,store))
(gv-define-setter read-mouse-position (store scr)
  `(set-mouse-position ,scr (car ,store) (cdr ,store)))
(gv-define-simple-setter screen-height set-screen-height t)
(gv-define-simple-setter screen-width set-screen-width t)
(gv-define-simple-setter selected-window select-window)
(gv-define-simple-setter selected-screen select-screen)
(gv-define-simple-setter selected-frame select-frame)
(gv-define-simple-setter standard-case-table set-standard-case-table)
(gv-define-simple-setter syntax-table set-syntax-table)
(gv-define-simple-setter visited-file-modtime set-visited-file-modtime t)
(gv-define-setter window-height (store)
  `(progn (enlarge-window (- ,store (window-height))) ,store))
(gv-define-setter window-width (store)
  `(progn (enlarge-window (- ,store (window-width)) t) ,store))
(gv-define-simple-setter x-get-secondary-selection x-own-secondary-selection t)
(gv-define-simple-setter x-get-selection x-own-selection t)

;; More complex setf-methods.

;; This is a hack that allows (setf (eq a 7) B) to mean either
;; (setq a 7) or (setq a nil) depending on whether B is nil or not.
;; This is useful when you have control over the PLACE but not over
;; the VALUE, as is the case in define-minor-mode's :variable.
;; It turned out that :variable needed more flexibility anyway, so
;; this doesn't seem too useful now.
(gv-define-expander eq
  (lambda (do place val)
    (gv-letplace (getter setter) place
      (macroexp-let2 nil val val
        (funcall do `(eq ,getter ,val)
                 (lambda (v)
                   `(cond
                     (,v ,(funcall setter val))
                     ((eq ,getter ,val) ,(funcall setter `(not ,val))))))))))

(gv-define-expander substring
  (lambda (do place from &optional to)
    (gv-letplace (getter setter) place
      (macroexp-let2 nil start from
        (macroexp-let2 nil end to
          (funcall do `(substring ,getter ,start ,end)
                   (lambda (v)
                     (funcall setter `(cl--set-substring
                                       ,getter ,start ,end ,v)))))))))

;;; Miscellaneous.

;;;###autoload
(progn
  ;; Make sure functions defined with cl-defsubst can be inlined even in
  ;; packages which do not require CL.  We don't put an autoload cookie
  ;; directly on that function, since those cookies only go to cl-loaddefs.
  (autoload 'cl--defsubst-expand "cl-macs")
  ;; Autoload, so autoload.el and font-lock can use it even when CL
  ;; is not loaded.
  (put 'cl-defun    'doc-string-elt 3)
  (put 'cl-defmacro 'doc-string-elt 3)
  (put 'cl-defsubst 'doc-string-elt 3)
  (put 'cl-defstruct 'doc-string-elt 2))

(load "cl-loaddefs" nil 'quiet)

(provide 'cl-lib)

;; Local variables:
;; byte-compile-dynamic: t
;; End:

;;; cl-lib.el ends here
