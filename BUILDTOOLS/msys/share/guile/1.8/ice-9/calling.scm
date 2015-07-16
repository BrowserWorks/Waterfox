;;;; calling.scm --- Calling Conventions
;;;;
;;;; 	Copyright (C) 1995, 1996, 1997, 2000, 2001, 2006 Free Software Foundation, Inc.
;;;; 
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;; 
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;; 

(define-module (ice-9 calling)
  :export-syntax (with-excursion-function
		  with-getter-and-setter
		  with-getter
		  with-delegating-getter-and-setter
		  with-excursion-getter-and-setter
		  with-configuration-getter-and-setter
		  with-delegating-configuration-getter-and-setter
		  let-with-configuration-getter-and-setter))

;;;;
;;;
;;; This file contains a number of macros that support 
;;; common calling conventions.

;;;
;;; with-excursion-function <vars> proc
;;;  <vars> is an unevaluated list of names that are bound in the caller.
;;;  proc is a procedure, called:
;;;	     (proc excursion)
;;;
;;;  excursion is a procedure isolates all changes to <vars>
;;;  in the dynamic scope of the call to proc.  In other words,
;;;  the values of <vars> are saved when proc is entered, and when
;;;  proc returns, those values are restored.   Values are also restored
;;;  entering and leaving the call to proc non-locally, such as using
;;;  call-with-current-continuation, error, or throw.
;;;
(defmacro with-excursion-function (vars proc)
  `(,proc ,(excursion-function-syntax vars)))



;;; with-getter-and-setter <vars> proc
;;;  <vars> is an unevaluated list of names that are bound in the caller.
;;;  proc is a procedure, called:
;;;	(proc getter setter)
;;; 
;;;  getter and setter are procedures used to access
;;;  or modify <vars>.
;;; 
;;;  setter, called with keywords arguments, modifies the named
;;;  values.   If "foo" and "bar" are among <vars>, then:
;;; 
;;;	(setter :foo 1 :bar 2)
;;;	== (set! foo 1 bar 2)
;;; 
;;;  getter, called with just keywords, returns
;;;  a list of the corresponding values.  For example,
;;;  if "foo" and "bar" are among the <vars>, then
;;; 
;;;	(getter :foo :bar)
;;;	=> (<value-of-foo> <value-of-bar>)
;;; 
;;;  getter, called with no arguments, returns a list of all accepted 
;;;  keywords and the corresponding values.  If "foo" and "bar" are
;;;  the *only* <vars>, then:
;;; 
;;;	(getter)
;;;	=> (:foo <value-of-bar> :bar <value-of-foo>)
;;; 
;;;  The unusual calling sequence of a getter supports too handy
;;;  idioms:
;;; 
;;;	(apply setter (getter))		;; save and restore
;;; 
;;;	(apply-to-args (getter :foo :bar)		;; fetch and bind
;;;		    (lambda (foo bar) ....))
;;; 
;;;     ;; [ "apply-to-args" is just like two-argument "apply" except that it 
;;;	;;   takes its arguments in a different order.
;;; 
;;;
(defmacro with-getter-and-setter (vars proc)
  `(,proc ,@ (getter-and-setter-syntax vars)))

;;; with-getter vars proc
;;;   A short-hand for a call to with-getter-and-setter.
;;;   The procedure is called:
;;;		(proc getter)
;;;
(defmacro with-getter (vars proc)
  `(,proc ,(car (getter-and-setter-syntax vars))))


;;; with-delegating-getter-and-setter <vars> get-delegate set-delegate proc
;;;   Compose getters and setters.
;;; 
;;;   <vars> is an unevaluated list of names that are bound in the caller.
;;;   
;;;   get-delegate is called by the new getter to extend the set of 
;;;	gettable variables beyond just <vars>
;;;   set-delegate is called by the new setter to extend the set of 
;;;	gettable variables beyond just <vars>
;;;
;;;   proc is a procedure that is called
;;;		(proc getter setter)
;;;
(defmacro with-delegating-getter-and-setter (vars get-delegate set-delegate proc)
  `(,proc ,@ (delegating-getter-and-setter-syntax vars get-delegate set-delegate)))


;;; with-excursion-getter-and-setter <vars> proc
;;;   <vars> is an unevaluated list of names that are bound in the caller.
;;;   proc is called:
;;;
;;;		(proc excursion getter setter)
;;;
;;;   See also:
;;;	with-getter-and-setter
;;;	with-excursion-function
;;;
(defmacro with-excursion-getter-and-setter (vars proc)
  `(,proc  ,(excursion-function-syntax vars)
	  ,@ (getter-and-setter-syntax vars)))


(define (excursion-function-syntax vars)
  (let ((saved-value-names (map gensym vars))
	(tmp-var-name (gensym "temp"))
	(swap-fn-name (gensym "swap"))
	(thunk-name (gensym "thunk")))
    `(lambda (,thunk-name)
       (letrec ((,tmp-var-name #f)
		(,swap-fn-name
		 (lambda () ,@ (map (lambda (n sn) 
				      `(begin (set! ,tmp-var-name ,n)
					      (set! ,n ,sn)
					      (set! ,sn ,tmp-var-name)))
				    vars saved-value-names)))
		,@ (map (lambda (sn n) `(,sn ,n)) saved-value-names vars))
	 (dynamic-wind
	  ,swap-fn-name
	  ,thunk-name
	  ,swap-fn-name)))))


(define (getter-and-setter-syntax vars)
  (let ((args-name (gensym "args"))
	(an-arg-name (gensym "an-arg"))
	(new-val-name (gensym "new-value"))
	(loop-name (gensym "loop"))
	(kws (map symbol->keyword vars)))
    (list `(lambda ,args-name
	     (let ,loop-name ((,args-name ,args-name))
		  (if (null? ,args-name)
		      ,(if (null? kws)
			   ''()
			   `(let ((all-vals (,loop-name ',kws)))
			      (let ,loop-name ((vals all-vals)
					       (kws ',kws))
				   (if (null? vals)
				       '()
				       `(,(car kws) ,(car vals) ,@(,loop-name (cdr vals) (cdr kws)))))))
		      (map (lambda (,an-arg-name)
			     (case ,an-arg-name
			       ,@ (append
				   (map (lambda (kw v) `((,kw) ,v)) kws vars)
				   `((else (throw 'bad-get-option ,an-arg-name))))))
			   ,args-name))))

	  `(lambda ,args-name
	     (let ,loop-name ((,args-name ,args-name))
		  (or (null? ,args-name)
		      (null? (cdr ,args-name))
		      (let ((,an-arg-name (car ,args-name))
			    (,new-val-name (cadr ,args-name)))
			(case ,an-arg-name
			  ,@ (append
			      (map (lambda (kw v) `((,kw) (set! ,v ,new-val-name))) kws vars)
			      `((else (throw 'bad-set-option ,an-arg-name)))))
			(,loop-name (cddr ,args-name)))))))))

(define (delegating-getter-and-setter-syntax  vars get-delegate set-delegate)
  (let ((args-name (gensym "args"))
	(an-arg-name (gensym "an-arg"))
	(new-val-name (gensym "new-value"))
	(loop-name (gensym "loop"))
	(kws (map symbol->keyword vars)))
    (list `(lambda ,args-name
	     (let ,loop-name ((,args-name ,args-name))
		  (if (null? ,args-name)
		      (append!
		       ,(if (null? kws)
			    ''()
			    `(let ((all-vals (,loop-name ',kws)))
			       (let ,loop-name ((vals all-vals)
						(kws ',kws))
				    (if (null? vals)
					'()
					`(,(car kws) ,(car vals) ,@(,loop-name (cdr vals) (cdr kws)))))))
		       (,get-delegate))
		      (map (lambda (,an-arg-name)
			     (case ,an-arg-name
			       ,@ (append
				   (map (lambda (kw v) `((,kw) ,v)) kws vars)
				   `((else (car (,get-delegate ,an-arg-name)))))))
			   ,args-name))))

	  `(lambda ,args-name
	     (let ,loop-name ((,args-name ,args-name))
		  (or (null? ,args-name)
		      (null? (cdr ,args-name))
		      (let ((,an-arg-name (car ,args-name))
			    (,new-val-name (cadr ,args-name)))
			(case ,an-arg-name
			  ,@ (append
			      (map (lambda (kw v) `((,kw) (set! ,v ,new-val-name))) kws vars)
			      `((else  (,set-delegate ,an-arg-name ,new-val-name)))))
			(,loop-name (cddr ,args-name)))))))))




;;; with-configuration-getter-and-setter <vars-etc> proc
;;;
;;;  Create a getter and setter that can trigger arbitrary computation.
;;;
;;;  <vars-etc> is a list of variable specifiers, explained below.
;;;  proc is called:
;;;
;;;		(proc getter setter)
;;;
;;;   Each element of the <vars-etc> list is of the form:
;;;
;;;	(<var> getter-hook setter-hook)
;;;
;;;   Both hook elements are evaluated; the variable name is not.
;;;   Either hook may be #f or procedure.
;;;
;;;   A getter hook is a thunk that returns a value for the corresponding
;;;   variable.   If omitted (#f is passed), the binding of <var> is
;;;   returned.
;;;
;;;   A setter hook is a procedure of one argument that accepts a new value
;;;   for the corresponding variable.  If omitted, the binding of <var>
;;;   is simply set using set!.
;;;
(defmacro with-configuration-getter-and-setter (vars-etc proc)
  `((lambda (simpler-get simpler-set body-proc)
      (with-delegating-getter-and-setter ()
	simpler-get simpler-set body-proc))

    (lambda (kw)
      (case kw
	,@(map (lambda (v) `((,(symbol->keyword (car v)))
			     ,(cond
			       ((cadr v)	=> list)
			       (else		`(list ,(car v))))))
	       vars-etc)))

    (lambda (kw new-val)
      (case kw
	,@(map (lambda (v) `((,(symbol->keyword (car v)))
			     ,(cond
			       ((caddr v)	=> (lambda (proc) `(,proc new-val)))
			       (else		`(set! ,(car v) new-val)))))
	       vars-etc)))

       ,proc))

(defmacro with-delegating-configuration-getter-and-setter (vars-etc delegate-get delegate-set proc)
  `((lambda (simpler-get simpler-set body-proc)
      (with-delegating-getter-and-setter ()
	simpler-get simpler-set body-proc))

    (lambda (kw)
      (case kw
	,@(append! (map (lambda (v) `((,(symbol->keyword (car v)))
				      ,(cond
					((cadr v)	=> list)
					(else		`(list ,(car v))))))
			vars-etc)
		   `((else (,delegate-get kw))))))

    (lambda (kw new-val)
      (case kw
	,@(append! (map (lambda (v) `((,(symbol->keyword (car v)))
				      ,(cond
					((caddr v)	=> (lambda (proc) `(,proc new-val)))
					(else		`(set! ,(car v) new-val)))))
			vars-etc)
		   `((else (,delegate-set kw new-val))))))

    ,proc))


;;; let-configuration-getter-and-setter <vars-etc> proc
;;;
;;;   This procedure is like with-configuration-getter-and-setter (q.v.)
;;;   except that each element of <vars-etc> is:
;;;
;;;		(<var> initial-value getter-hook setter-hook)
;;;
;;;   Unlike with-configuration-getter-and-setter, let-configuration-getter-and-setter
;;;   introduces bindings for the variables named in <vars-etc>.
;;;   It is short-hand for:
;;;
;;;		(let ((<var1> initial-value-1)
;;;		      (<var2> initial-value-2)
;;;			...)
;;;		  (with-configuration-getter-and-setter ((<var1> v1-get v1-set) ...) proc))
;;;
(defmacro let-with-configuration-getter-and-setter (vars-etc proc)
  `(let ,(map (lambda (v) `(,(car v) ,(cadr v))) vars-etc)
     (with-configuration-getter-and-setter ,(map (lambda (v) `(,(car v) ,(caddr v) ,(cadddr v))) vars-etc)
					   ,proc)))
