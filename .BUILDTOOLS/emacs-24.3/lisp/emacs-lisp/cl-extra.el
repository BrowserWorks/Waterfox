;;; cl-extra.el --- Common Lisp features, part 2  -*- lexical-binding: t -*-

;; Copyright (C) 1993, 2000-2013 Free Software Foundation, Inc.

;; Author: Dave Gillespie <daveg@synaptics.com>
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

;; This file contains portions of the Common Lisp extensions
;; package which are autoloaded since they are relatively obscure.

;;; Code:

(require 'cl-lib)

;;; Type coercion.

;;;###autoload
(defun cl-coerce (x type)
  "Coerce OBJECT to type TYPE.
TYPE is a Common Lisp type specifier.
\n(fn OBJECT TYPE)"
  (cond ((eq type 'list) (if (listp x) x (append x nil)))
	((eq type 'vector) (if (vectorp x) x (vconcat x)))
	((eq type 'string) (if (stringp x) x (concat x)))
	((eq type 'array) (if (arrayp x) x (vconcat x)))
	((and (eq type 'character) (stringp x) (= (length x) 1)) (aref x 0))
	((and (eq type 'character) (symbolp x)) (cl-coerce (symbol-name x) type))
	((eq type 'float) (float x))
	((cl-typep x type) x)
	(t (error "Can't coerce %s to type %s" x type))))


;;; Predicates.

;;;###autoload
(defun cl-equalp (x y)
  "Return t if two Lisp objects have similar structures and contents.
This is like `equal', except that it accepts numerically equal
numbers of different types (float vs. integer), and also compares
strings case-insensitively."
  (cond ((eq x y) t)
	((stringp x)
	 (and (stringp y) (= (length x) (length y))
	      (or (string-equal x y)
		  (string-equal (downcase x) (downcase y)))))   ; lazy but simple!
	((numberp x)
	 (and (numberp y) (= x y)))
	((consp x)
	 (while (and (consp x) (consp y) (cl-equalp (car x) (car y)))
	   (setq x (cdr x) y (cdr y)))
	 (and (not (consp x)) (cl-equalp x y)))
	((vectorp x)
	 (and (vectorp y) (= (length x) (length y))
	      (let ((i (length x)))
		(while (and (>= (setq i (1- i)) 0)
			    (cl-equalp (aref x i) (aref y i))))
		(< i 0))))
	(t (equal x y))))


;;; Control structures.

;;;###autoload
(defun cl--mapcar-many (cl-func cl-seqs)
  (if (cdr (cdr cl-seqs))
      (let* ((cl-res nil)
	     (cl-n (apply 'min (mapcar 'length cl-seqs)))
	     (cl-i 0)
	     (cl-args (copy-sequence cl-seqs))
	     cl-p1 cl-p2)
	(setq cl-seqs (copy-sequence cl-seqs))
	(while (< cl-i cl-n)
	  (setq cl-p1 cl-seqs cl-p2 cl-args)
	  (while cl-p1
	    (setcar cl-p2
		    (if (consp (car cl-p1))
			(prog1 (car (car cl-p1))
			  (setcar cl-p1 (cdr (car cl-p1))))
		      (aref (car cl-p1) cl-i)))
	    (setq cl-p1 (cdr cl-p1) cl-p2 (cdr cl-p2)))
	  (push (apply cl-func cl-args) cl-res)
	  (setq cl-i (1+ cl-i)))
	(nreverse cl-res))
    (let ((cl-res nil)
	  (cl-x (car cl-seqs))
	  (cl-y (nth 1 cl-seqs)))
      (let ((cl-n (min (length cl-x) (length cl-y)))
	    (cl-i -1))
	(while (< (setq cl-i (1+ cl-i)) cl-n)
	  (push (funcall cl-func
                         (if (consp cl-x) (pop cl-x) (aref cl-x cl-i))
                         (if (consp cl-y) (pop cl-y) (aref cl-y cl-i)))
                cl-res)))
      (nreverse cl-res))))

;;;###autoload
(defun cl-map (cl-type cl-func cl-seq &rest cl-rest)
  "Map a FUNCTION across one or more SEQUENCEs, returning a sequence.
TYPE is the sequence type to return.
\n(fn TYPE FUNCTION SEQUENCE...)"
  (let ((cl-res (apply 'cl-mapcar cl-func cl-seq cl-rest)))
    (and cl-type (cl-coerce cl-res cl-type))))

;;;###autoload
(defun cl-maplist (cl-func cl-list &rest cl-rest)
  "Map FUNCTION to each sublist of LIST or LISTs.
Like `cl-mapcar', except applies to lists and their cdr's rather than to
the elements themselves.
\n(fn FUNCTION LIST...)"
  (if cl-rest
      (let ((cl-res nil)
	    (cl-args (cons cl-list (copy-sequence cl-rest)))
	    cl-p)
	(while (not (memq nil cl-args))
	  (push (apply cl-func cl-args) cl-res)
	  (setq cl-p cl-args)
	  (while cl-p (setcar cl-p (cdr (pop cl-p)) )))
	(nreverse cl-res))
    (let ((cl-res nil))
      (while cl-list
	(push (funcall cl-func cl-list) cl-res)
	(setq cl-list (cdr cl-list)))
      (nreverse cl-res))))

;;;###autoload
(defun cl-mapc (cl-func cl-seq &rest cl-rest)
  "Like `cl-mapcar', but does not accumulate values returned by the function.
\n(fn FUNCTION SEQUENCE...)"
  (if cl-rest
      (progn (apply 'cl-map nil cl-func cl-seq cl-rest)
	     cl-seq)
    (mapc cl-func cl-seq)))

;;;###autoload
(defun cl-mapl (cl-func cl-list &rest cl-rest)
  "Like `cl-maplist', but does not accumulate values returned by the function.
\n(fn FUNCTION LIST...)"
  (if cl-rest
      (apply 'cl-maplist cl-func cl-list cl-rest)
    (let ((cl-p cl-list))
      (while cl-p (funcall cl-func cl-p) (setq cl-p (cdr cl-p)))))
  cl-list)

;;;###autoload
(defun cl-mapcan (cl-func cl-seq &rest cl-rest)
  "Like `cl-mapcar', but nconc's together the values returned by the function.
\n(fn FUNCTION SEQUENCE...)"
  (apply 'nconc (apply 'cl-mapcar cl-func cl-seq cl-rest)))

;;;###autoload
(defun cl-mapcon (cl-func cl-list &rest cl-rest)
  "Like `cl-maplist', but nconc's together the values returned by the function.
\n(fn FUNCTION LIST...)"
  (apply 'nconc (apply 'cl-maplist cl-func cl-list cl-rest)))

;;;###autoload
(defun cl-some (cl-pred cl-seq &rest cl-rest)
  "Return true if PREDICATE is true of any element of SEQ or SEQs.
If so, return the true (non-nil) value returned by PREDICATE.
\n(fn PREDICATE SEQ...)"
  (if (or cl-rest (nlistp cl-seq))
      (catch 'cl-some
	(apply 'cl-map nil
	       (function (lambda (&rest cl-x)
			   (let ((cl-res (apply cl-pred cl-x)))
			     (if cl-res (throw 'cl-some cl-res)))))
	       cl-seq cl-rest) nil)
    (let ((cl-x nil))
      (while (and cl-seq (not (setq cl-x (funcall cl-pred (pop cl-seq))))))
      cl-x)))

;;;###autoload
(defun cl-every (cl-pred cl-seq &rest cl-rest)
  "Return true if PREDICATE is true of every element of SEQ or SEQs.
\n(fn PREDICATE SEQ...)"
  (if (or cl-rest (nlistp cl-seq))
      (catch 'cl-every
	(apply 'cl-map nil
	       (function (lambda (&rest cl-x)
			   (or (apply cl-pred cl-x) (throw 'cl-every nil))))
	       cl-seq cl-rest) t)
    (while (and cl-seq (funcall cl-pred (car cl-seq)))
      (setq cl-seq (cdr cl-seq)))
    (null cl-seq)))

;;;###autoload
(defun cl-notany (cl-pred cl-seq &rest cl-rest)
  "Return true if PREDICATE is false of every element of SEQ or SEQs.
\n(fn PREDICATE SEQ...)"
  (not (apply 'cl-some cl-pred cl-seq cl-rest)))

;;;###autoload
(defun cl-notevery (cl-pred cl-seq &rest cl-rest)
  "Return true if PREDICATE is false of some element of SEQ or SEQs.
\n(fn PREDICATE SEQ...)"
  (not (apply 'cl-every cl-pred cl-seq cl-rest)))

;;;###autoload
(defun cl--map-keymap-recursively (cl-func-rec cl-map &optional cl-base)
  (or cl-base
      (setq cl-base (copy-sequence [0])))
  (map-keymap
   (function
    (lambda (cl-key cl-bind)
      (aset cl-base (1- (length cl-base)) cl-key)
      (if (keymapp cl-bind)
	  (cl--map-keymap-recursively
	   cl-func-rec cl-bind
	   (vconcat cl-base (list 0)))
	(funcall cl-func-rec cl-base cl-bind))))
   cl-map))

;;;###autoload
(defun cl--map-intervals (cl-func &optional cl-what cl-prop cl-start cl-end)
  (or cl-what (setq cl-what (current-buffer)))
  (if (bufferp cl-what)
      (let (cl-mark cl-mark2 (cl-next t) cl-next2)
	(with-current-buffer cl-what
	  (setq cl-mark (copy-marker (or cl-start (point-min))))
	  (setq cl-mark2 (and cl-end (copy-marker cl-end))))
	(while (and cl-next (or (not cl-mark2) (< cl-mark cl-mark2)))
	  (setq cl-next (if cl-prop (next-single-property-change
				     cl-mark cl-prop cl-what)
			  (next-property-change cl-mark cl-what))
		cl-next2 (or cl-next (with-current-buffer cl-what
				       (point-max))))
	  (funcall cl-func (prog1 (marker-position cl-mark)
			     (set-marker cl-mark cl-next2))
		   (if cl-mark2 (min cl-next2 cl-mark2) cl-next2)))
	(set-marker cl-mark nil) (if cl-mark2 (set-marker cl-mark2 nil)))
    (or cl-start (setq cl-start 0))
    (or cl-end (setq cl-end (length cl-what)))
    (while (< cl-start cl-end)
      (let ((cl-next (or (if cl-prop (next-single-property-change
				      cl-start cl-prop cl-what)
			   (next-property-change cl-start cl-what))
			 cl-end)))
	(funcall cl-func cl-start (min cl-next cl-end))
	(setq cl-start cl-next)))))

;;;###autoload
(defun cl--map-overlays (cl-func &optional cl-buffer cl-start cl-end cl-arg)
  (or cl-buffer (setq cl-buffer (current-buffer)))
  (if (fboundp 'overlay-lists)

      ;; This is the preferred algorithm, though overlay-lists is undocumented.
      (let (cl-ovl)
	(with-current-buffer cl-buffer
	  (setq cl-ovl (overlay-lists))
	  (if cl-start (setq cl-start (copy-marker cl-start)))
	  (if cl-end (setq cl-end (copy-marker cl-end))))
	(setq cl-ovl (nconc (car cl-ovl) (cdr cl-ovl)))
	(while (and cl-ovl
		    (or (not (overlay-start (car cl-ovl)))
			(and cl-end (>= (overlay-start (car cl-ovl)) cl-end))
			(and cl-start (<= (overlay-end (car cl-ovl)) cl-start))
			(not (funcall cl-func (car cl-ovl) cl-arg))))
	  (setq cl-ovl (cdr cl-ovl)))
	(if cl-start (set-marker cl-start nil))
	(if cl-end (set-marker cl-end nil)))

    ;; This alternate algorithm fails to find zero-length overlays.
    (let ((cl-mark (with-current-buffer cl-buffer
		     (copy-marker (or cl-start (point-min)))))
	  (cl-mark2 (and cl-end (with-current-buffer cl-buffer
				  (copy-marker cl-end))))
	  cl-pos cl-ovl)
      (while (save-excursion
	       (and (setq cl-pos (marker-position cl-mark))
		    (< cl-pos (or cl-mark2 (point-max)))
		    (progn
		      (set-buffer cl-buffer)
		      (setq cl-ovl (overlays-at cl-pos))
		      (set-marker cl-mark (next-overlay-change cl-pos)))))
	(while (and cl-ovl
		    (or (/= (overlay-start (car cl-ovl)) cl-pos)
			(not (and (funcall cl-func (car cl-ovl) cl-arg)
				  (set-marker cl-mark nil)))))
	  (setq cl-ovl (cdr cl-ovl))))
      (set-marker cl-mark nil) (if cl-mark2 (set-marker cl-mark2 nil)))))

;;; Support for `setf'.
;;;###autoload
(defun cl--set-frame-visible-p (frame val)
  (cond ((null val) (make-frame-invisible frame))
	((eq val 'icon) (iconify-frame frame))
	(t (make-frame-visible frame)))
  val)


;;; Numbers.

;;;###autoload
(defun cl-gcd (&rest args)
  "Return the greatest common divisor of the arguments."
  (let ((a (abs (or (pop args) 0))))
    (while args
      (let ((b (abs (pop args))))
	(while (> b 0) (setq b (% a (setq a b))))))
    a))

;;;###autoload
(defun cl-lcm (&rest args)
  "Return the least common multiple of the arguments."
  (if (memq 0 args)
      0
    (let ((a (abs (or (pop args) 1))))
      (while args
	(let ((b (abs (pop args))))
	  (setq a (* (/ a (cl-gcd a b)) b))))
      a)))

;;;###autoload
(defun cl-isqrt (x)
  "Return the integer square root of the argument."
  (if (and (integerp x) (> x 0))
      (let ((g (cond ((<= x 100) 10) ((<= x 10000) 100)
		     ((<= x 1000000) 1000) (t x)))
	    g2)
	(while (< (setq g2 (/ (+ g (/ x g)) 2)) g)
	  (setq g g2))
	g)
    (if (eq x 0) 0 (signal 'arith-error nil))))

;;;###autoload
(defun cl-floor (x &optional y)
  "Return a list of the floor of X and the fractional part of X.
With two arguments, return floor and remainder of their quotient."
  (let ((q (floor x y)))
    (list q (- x (if y (* y q) q)))))

;;;###autoload
(defun cl-ceiling (x &optional y)
  "Return a list of the ceiling of X and the fractional part of X.
With two arguments, return ceiling and remainder of their quotient."
  (let ((res (cl-floor x y)))
    (if (= (car (cdr res)) 0) res
      (list (1+ (car res)) (- (car (cdr res)) (or y 1))))))

;;;###autoload
(defun cl-truncate (x &optional y)
  "Return a list of the integer part of X and the fractional part of X.
With two arguments, return truncation and remainder of their quotient."
  (if (eq (>= x 0) (or (null y) (>= y 0)))
      (cl-floor x y) (cl-ceiling x y)))

;;;###autoload
(defun cl-round (x &optional y)
  "Return a list of X rounded to the nearest integer and the remainder.
With two arguments, return rounding and remainder of their quotient."
  (if y
      (if (and (integerp x) (integerp y))
	  (let* ((hy (/ y 2))
		 (res (cl-floor (+ x hy) y)))
	    (if (and (= (car (cdr res)) 0)
		     (= (+ hy hy) y)
		     (/= (% (car res) 2) 0))
		(list (1- (car res)) hy)
	      (list (car res) (- (car (cdr res)) hy))))
	(let ((q (round (/ x y))))
	  (list q (- x (* q y)))))
    (if (integerp x) (list x 0)
      (let ((q (round x)))
	(list q (- x q))))))

;;;###autoload
(defun cl-mod (x y)
  "The remainder of X divided by Y, with the same sign as Y."
  (nth 1 (cl-floor x y)))

;;;###autoload
(defun cl-rem (x y)
  "The remainder of X divided by Y, with the same sign as X."
  (nth 1 (cl-truncate x y)))

;;;###autoload
(defun cl-signum (x)
  "Return 1 if X is positive, -1 if negative, 0 if zero."
  (cond ((> x 0) 1) ((< x 0) -1) (t 0)))


;; Random numbers.

;;;###autoload
(defun cl-random (lim &optional state)
  "Return a random nonnegative number less than LIM, an integer or float.
Optional second arg STATE is a random-state object."
  (or state (setq state cl--random-state))
  ;; Inspired by "ran3" from Numerical Recipes.  Additive congruential method.
  (let ((vec (aref state 3)))
    (if (integerp vec)
	(let ((i 0) (j (- 1357335 (% (abs vec) 1357333))) (k 1))
	  (aset state 3 (setq vec (make-vector 55 nil)))
	  (aset vec 0 j)
	  (while (> (setq i (% (+ i 21) 55)) 0)
	    (aset vec i (setq j (prog1 k (setq k (- j k))))))
	  (while (< (setq i (1+ i)) 200) (cl-random 2 state))))
    (let* ((i (aset state 1 (% (1+ (aref state 1)) 55)))
	   (j (aset state 2 (% (1+ (aref state 2)) 55)))
	   (n (logand 8388607 (aset vec i (- (aref vec i) (aref vec j))))))
      (if (integerp lim)
	  (if (<= lim 512) (% n lim)
	    (if (> lim 8388607) (setq n (+ (lsh n 9) (cl-random 512 state))))
	    (let ((mask 1023))
	      (while (< mask (1- lim)) (setq mask (1+ (+ mask mask))))
	      (if (< (setq n (logand n mask)) lim) n (cl-random lim state))))
	(* (/ n '8388608e0) lim)))))

;;;###autoload
(defun cl-make-random-state (&optional state)
  "Return a copy of random-state STATE, or of the internal state if omitted.
If STATE is t, return a new state object seeded from the time of day."
  (cond ((null state) (cl-make-random-state cl--random-state))
	((vectorp state) (copy-tree state t))
	((integerp state) (vector 'cl-random-state-tag -1 30 state))
	(t (cl-make-random-state (cl-random-time)))))

;;;###autoload
(defun cl-random-state-p (object)
  "Return t if OBJECT is a random-state object."
  (and (vectorp object) (= (length object) 4)
       (eq (aref object 0) 'cl-random-state-tag)))


;; Implementation limits.

(defun cl--finite-do (func a b)
  (condition-case _
      (let ((res (funcall func a b)))   ; check for IEEE infinity
	(and (numberp res) (/= res (/ res 2)) res))
    (arith-error nil)))

;;;###autoload
(defun cl-float-limits ()
  "Initialize the Common Lisp floating-point parameters.
This sets the values of: `cl-most-positive-float', `cl-most-negative-float',
`cl-least-positive-float', `cl-least-negative-float', `cl-float-epsilon',
`cl-float-negative-epsilon', `cl-least-positive-normalized-float', and
`cl-least-negative-normalized-float'."
  (or cl-most-positive-float (not (numberp '2e1))
      (let ((x '2e0) y z)
	;; Find maximum exponent (first two loops are optimizations)
	(while (cl--finite-do '* x x) (setq x (* x x)))
	(while (cl--finite-do '* x (/ x 2)) (setq x (* x (/ x 2))))
	(while (cl--finite-do '+ x x) (setq x (+ x x)))
	(setq z x y (/ x 2))
	;; Now cl-fill in 1's in the mantissa.
	(while (and (cl--finite-do '+ x y) (/= (+ x y) x))
	  (setq x (+ x y) y (/ y 2)))
	(setq cl-most-positive-float x
	      cl-most-negative-float (- x))
	;; Divide down until mantissa starts rounding.
	(setq x (/ x z) y (/ 16 z) x (* x y))
	(while (condition-case _ (and (= x (* (/ x 2) 2)) (> (/ y 2) 0))
		 (arith-error nil))
	  (setq x (/ x 2) y (/ y 2)))
	(setq cl-least-positive-normalized-float y
	      cl-least-negative-normalized-float (- y))
	;; Divide down until value underflows to zero.
	(setq x (/ 1 z) y x)
	(while (condition-case _ (> (/ x 2) 0) (arith-error nil))
	  (setq x (/ x 2)))
	(setq cl-least-positive-float x
	      cl-least-negative-float (- x))
	(setq x '1e0)
	(while (/= (+ '1e0 x) '1e0) (setq x (/ x 2)))
	(setq cl-float-epsilon (* x 2))
	(setq x '1e0)
	(while (/= (- '1e0 x) '1e0) (setq x (/ x 2)))
	(setq cl-float-negative-epsilon (* x 2))))
  nil)


;;; Sequence functions.

;;;###autoload
(defun cl-subseq (seq start &optional end)
  "Return the subsequence of SEQ from START to END.
If END is omitted, it defaults to the length of the sequence.
If START or END is negative, it counts from the end."
  (declare (gv-setter
            (lambda (new)
              `(progn (cl-replace ,seq ,new :start1 ,start :end1 ,end)
                      ,new))))
  (if (stringp seq) (substring seq start end)
    (let (len)
      (and end (< end 0) (setq end (+ end (setq len (length seq)))))
      (if (< start 0) (setq start (+ start (or len (setq len (length seq))))))
      (cond ((listp seq)
	     (if (> start 0) (setq seq (nthcdr start seq)))
	     (if end
		 (let ((res nil))
		   (while (>= (setq end (1- end)) start)
		     (push (pop seq) res))
		   (nreverse res))
	       (copy-sequence seq)))
	    (t
	     (or end (setq end (or len (length seq))))
	     (let ((res (make-vector (max (- end start) 0) nil))
		   (i 0))
	       (while (< start end)
		 (aset res i (aref seq start))
		 (setq i (1+ i) start (1+ start)))
	       res))))))

;;;###autoload
(defun cl-concatenate (type &rest seqs)
  "Concatenate, into a sequence of type TYPE, the argument SEQUENCEs.
\n(fn TYPE SEQUENCE...)"
  (cond ((eq type 'vector) (apply 'vconcat seqs))
	((eq type 'string) (apply 'concat seqs))
	((eq type 'list) (apply 'append (append seqs '(nil))))
	(t (error "Not a sequence type name: %s" type))))


;;; List functions.

;;;###autoload
(defun cl-revappend (x y)
  "Equivalent to (append (reverse X) Y)."
  (nconc (reverse x) y))

;;;###autoload
(defun cl-nreconc (x y)
  "Equivalent to (nconc (nreverse X) Y)."
  (nconc (nreverse x) y))

;;;###autoload
(defun cl-list-length (x)
  "Return the length of list X.  Return nil if list is circular."
  (let ((n 0) (fast x) (slow x))
    (while (and (cdr fast) (not (and (eq fast slow) (> n 0))))
      (setq n (+ n 2) fast (cdr (cdr fast)) slow (cdr slow)))
    (if fast (if (cdr fast) nil (1+ n)) n)))

;;;###autoload
(defun cl-tailp (sublist list)
  "Return true if SUBLIST is a tail of LIST."
  (while (and (consp list) (not (eq sublist list)))
    (setq list (cdr list)))
  (if (numberp sublist) (equal sublist list) (eq sublist list)))

;;; Property lists.

;;;###autoload
(defun cl-get (sym tag &optional def)
  "Return the value of SYMBOL's PROPNAME property, or DEFAULT if none.
\n(fn SYMBOL PROPNAME &optional DEFAULT)"
  (declare (compiler-macro cl--compiler-macro-get)
           (gv-setter (lambda (store) `(put ,sym ,tag ,store))))
  (or (get sym tag)
      (and def
           ;; Make sure `def' is really absent as opposed to set to nil.
	   (let ((plist (symbol-plist sym)))
	     (while (and plist (not (eq (car plist) tag)))
	       (setq plist (cdr (cdr plist))))
	     (if plist (car (cdr plist)) def)))))
(autoload 'cl--compiler-macro-get "cl-macs")

;;;###autoload
(defun cl-getf (plist tag &optional def)
  "Search PROPLIST for property PROPNAME; return its value or DEFAULT.
PROPLIST is a list of the sort returned by `symbol-plist'.
\n(fn PROPLIST PROPNAME &optional DEFAULT)"
  (declare (gv-expander
            (lambda (do)
              (gv-letplace (getter setter) plist
                (macroexp-let2 nil k tag
                  (macroexp-let2 nil d def
                    (funcall do `(cl-getf ,getter ,k ,d)
                             (lambda (v)
                               (funcall setter
                                        `(cl--set-getf ,getter ,k ,v))))))))))
  (setplist '--cl-getf-symbol-- plist)
  (or (get '--cl-getf-symbol-- tag)
      ;; Originally we called cl-get here,
      ;; but that fails, because cl-get has a compiler macro
      ;; definition that uses getf!
      (when def
        ;; Make sure `def' is really absent as opposed to set to nil.
	(while (and plist (not (eq (car plist) tag)))
	  (setq plist (cdr (cdr plist))))
	(if plist (car (cdr plist)) def))))

;;;###autoload
(defun cl--set-getf (plist tag val)
  (let ((p plist))
    (while (and p (not (eq (car p) tag))) (setq p (cdr (cdr p))))
    (if p (progn (setcar (cdr p) val) plist) (cl-list* tag val plist))))

;;;###autoload
(defun cl--do-remf (plist tag)
  (let ((p (cdr plist)))
    (while (and (cdr p) (not (eq (car (cdr p)) tag))) (setq p (cdr (cdr p))))
    (and (cdr p) (progn (setcdr p (cdr (cdr (cdr p)))) t))))

;;;###autoload
(defun cl-remprop (sym tag)
  "Remove from SYMBOL's plist the property PROPNAME and its value.
\n(fn SYMBOL PROPNAME)"
  (let ((plist (symbol-plist sym)))
    (if (and plist (eq tag (car plist)))
	(progn (setplist sym (cdr (cdr plist))) t)
      (cl--do-remf plist tag))))

;;; Some debugging aids.

(defun cl-prettyprint (form)
  "Insert a pretty-printed rendition of a Lisp FORM in current buffer."
  (let ((pt (point)) last)
    (insert "\n" (prin1-to-string form) "\n")
    (setq last (point))
    (goto-char (1+ pt))
    (while (search-forward "(quote " last t)
      (delete-char -7)
      (insert "'")
      (forward-sexp)
      (delete-char 1))
    (goto-char (1+ pt))
    (cl--do-prettyprint)))

(defun cl--do-prettyprint ()
  (skip-chars-forward " ")
  (if (looking-at "(")
      (let ((skip (or (looking-at "((") (looking-at "(prog")
		      (looking-at "(unwind-protect ")
		      (looking-at "(function (")
		      (looking-at "(cl--block-wrapper ")))
	    (two (or (looking-at "(defun ") (looking-at "(defmacro ")))
	    (let (or (looking-at "(let\\*? ") (looking-at "(while ")))
	    (set (looking-at "(p?set[qf] ")))
	(if (or skip let
		(progn
		  (forward-sexp)
		  (and (>= (current-column) 78) (progn (backward-sexp) t))))
	    (let ((nl t))
	      (forward-char 1)
	      (cl--do-prettyprint)
	      (or skip (looking-at ")") (cl--do-prettyprint))
	      (or (not two) (looking-at ")") (cl--do-prettyprint))
	      (while (not (looking-at ")"))
		(if set (setq nl (not nl)))
		(if nl (insert "\n"))
		(lisp-indent-line)
		(cl--do-prettyprint))
	      (forward-char 1))))
    (forward-sexp)))

;;;###autoload
(defun cl-prettyexpand (form &optional full)
  "Expand macros in FORM and insert the pretty-printed result.
Optional argument FULL non-nil means to expand all macros,
including `cl-block' and `cl-eval-when'."
  (message "Expanding...")
  (let ((cl--compiling-file full)
	(byte-compile-macro-environment nil))
    (setq form (macroexpand-all form
                                (and (not full) '((cl-block) (cl-eval-when)))))
    (message "Formatting...")
    (prog1 (cl-prettyprint form)
      (message ""))))



(run-hooks 'cl-extra-load-hook)

;; Local variables:
;; byte-compile-dynamic: t
;; generated-autoload-file: "cl-loaddefs.el"
;; End:

;;; cl-extra.el ends here
