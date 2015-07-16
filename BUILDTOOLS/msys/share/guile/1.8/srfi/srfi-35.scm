;;; srfi-35.scm --- Conditions

;; Copyright (C) 2007, 2008 Free Software Foundation, Inc.
;;
;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 2.1 of the License, or (at your option) any later version.
;;
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public
;; License along with this library; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

;;; Author: Ludovic Courtès <ludo@gnu.org>

;;; Commentary:

;; This is an implementation of SRFI-35, "Conditions".  Conditions are a
;; means to convey information about exceptional conditions between parts of
;; a program.

;;; Code:

(define-module (srfi srfi-35)
  #:use-module (srfi srfi-1)
  #:export (make-condition-type condition-type?
            make-condition condition? condition-has-type? condition-ref
            make-compound-condition extract-condition
            define-condition-type condition
            &condition
            &message message-condition? condition-message
            &serious serious-condition?
            &error error?))

(cond-expand-provide (current-module) '(srfi-35))


;;;
;;; Condition types.
;;;

(define %condition-type-vtable
  ;; The vtable of all condition types.
  ;;   vtable fields: vtable, self, printer
  ;;   user fields:   id, parent, all-field-names
  (make-vtable-vtable "prprpr" 0
		      (lambda (ct port)
			(if (eq? ct %condition-type-vtable)
			    (display "#<condition-type-vtable>")
			    (format port "#<condition-type ~a ~a>"
				    (condition-type-id ct)
				    (number->string (object-address ct)
						    16))))))

(define (condition-type? obj)
  "Return true if OBJ is a condition type."
  (and (struct? obj)
       (eq? (struct-vtable obj)
	    %condition-type-vtable)))

(define (condition-type-id ct)
  (and (condition-type? ct)
       (struct-ref ct 3)))

(define (condition-type-parent ct)
  (and (condition-type? ct)
       (struct-ref ct 4)))

(define (condition-type-all-fields ct)
  (and (condition-type? ct)
       (struct-ref ct 5)))


(define (struct-layout-for-condition field-names)
  ;; Return a string denoting the layout required to hold the fields listed
  ;; in FIELD-NAMES.
  (let loop ((field-names field-names)
	     (layout      '("pr")))
    (if (null? field-names)
	(string-concatenate/shared layout)
	(loop (cdr field-names)
	      (cons "pr" layout)))))

(define (print-condition c port)
  (format port "#<condition ~a ~a>"
	  (condition-type-id (condition-type c))
	  (number->string (object-address c) 16)))

(define (make-condition-type id parent field-names)
  "Return a new condition type named ID, inheriting from PARENT, and with the
fields whose names are listed in FIELD-NAMES.  FIELD-NAMES must be a list of
symbols and must not contain names already used by PARENT or one of its
supertypes."
  (if (symbol? id)
      (if (condition-type? parent)
	  (let ((parent-fields (condition-type-all-fields parent)))
	    (if (and (every symbol? field-names)
		     (null? (lset-intersection eq?
					       field-names parent-fields)))
		(let* ((all-fields (append parent-fields field-names))
		       (layout     (struct-layout-for-condition all-fields)))
		  (make-struct %condition-type-vtable 0
			       (make-struct-layout layout) ;; layout
			       print-condition             ;; printer
			       id parent all-fields))
		(error "invalid condition type field names"
		       field-names)))
	  (error "parent is not a condition type" parent))
      (error "condition type identifier is not a symbol" id)))

(define (make-compound-condition-type id parents)
  ;; Return a compound condition type made of the types listed in PARENTS.
  ;; All fields from PARENTS are kept, even same-named ones, since they are
  ;; needed by `extract-condition'.
  (cond ((null? parents)
         (error "`make-compound-condition-type' passed empty parent list"
                id))
        ((null? (cdr parents))
         (car parents))
        (else
         (let* ((all-fields (append-map condition-type-all-fields
                                        parents))
                (layout     (struct-layout-for-condition all-fields)))
           (make-struct %condition-type-vtable 0
                        (make-struct-layout layout) ;; layout
                        print-condition             ;; printer
                        id
                        parents                     ;; list of parents!
                        all-fields
                        all-fields)))))


;;;
;;; Conditions.
;;;

(define (condition? c)
  "Return true if C is a condition."
  (and (struct? c)
       (condition-type? (struct-vtable c))))

(define (condition-type c)
  (and (struct? c)
       (let ((vtable (struct-vtable c)))
	 (if (condition-type? vtable)
	     vtable
	     #f))))

(define (condition-has-type? c type)
  "Return true if condition C has type TYPE."
  (if (and (condition? c) (condition-type? type))
      (let loop ((ct (condition-type c)))
        (or (eq? ct type)
            (and ct
                 (let ((parent (condition-type-parent ct)))
                   (if (list? parent)
                       (any loop parent) ;; compound condition
                       (loop (condition-type-parent ct)))))))
      (throw 'wrong-type-arg "condition-has-type?"
             "Wrong type argument")))

(define (condition-ref c field-name)
  "Return the value of the field named FIELD-NAME from condition C."
  (if (condition? c)
      (if (symbol? field-name)
	  (let* ((type   (condition-type c))
		 (fields (condition-type-all-fields type))
		 (index  (list-index (lambda (name)
				       (eq? name field-name))
				     fields)))
	    (if index
		(struct-ref c index)
		(error "invalid field name" field-name)))
	  (error "field name is not a symbol" field-name))
      (throw 'wrong-type-arg "condition-ref"
             "Wrong type argument: ~S" c)))

(define (make-condition-from-values type values)
  (apply make-struct type 0 values))

(define (make-condition type . field+value)
  "Return a new condition of type TYPE with fields initialized as specified
by FIELD+VALUE, a sequence of field names (symbols) and values."
  (if (condition-type? type)
      (let* ((all-fields (condition-type-all-fields type))
	     (inits      (fold-right (lambda (field inits)
				       (let ((v (memq field field+value)))
					 (if (pair? v)
					     (cons (cadr v) inits)
					     (error "field not specified"
						    field))))
				     '()
				     all-fields)))
	(make-condition-from-values type inits))
      (throw 'wrong-type-arg "make-condition"
             "Wrong type argument: ~S" type)))

(define (make-compound-condition . conditions)
  "Return a new compound condition composed of CONDITIONS."
  (let* ((types  (map condition-type conditions))
	 (ct     (make-compound-condition-type 'compound types))
	 (inits  (append-map (lambda (c)
			       (let ((ct (condition-type c)))
				 (map (lambda (f)
					(condition-ref c f))
				      (condition-type-all-fields ct))))
			     conditions)))
    (make-condition-from-values ct inits)))

(define (extract-condition c type)
  "Return a condition of condition type TYPE with the field values specified
by C."

  (define (first-field-index parents)
    ;; Return the index of the first field of TYPE within C.
    (let loop ((parents parents)
	       (index   0))
      (let ((parent (car parents)))
	(cond ((null? parents)
	       #f)
	      ((eq? parent type)
	       index)
	      ((pair? parent)
	       (or (loop parent index)
		   (loop (cdr parents)
			 (+ index
			    (apply + (map condition-type-all-fields
					  parent))))))
	      (else
	       (let ((shift (length (condition-type-all-fields parent))))
		 (loop (cdr parents)
		       (+ index shift))))))))

  (define (list-fields start-index field-names)
    ;; Return a list of the form `(FIELD-NAME VALUE...)'.
    (let loop ((index       start-index)
	       (field-names field-names)
	       (result      '()))
      (if (null? field-names)
	  (reverse! result)
	  (loop (+ 1 index)
		(cdr field-names)
		(cons* (struct-ref c index)
		       (car field-names)
		       result)))))

  (if (and (condition? c) (condition-type? type))
      (let* ((ct     (condition-type c))
             (parent (condition-type-parent ct)))
        (cond ((eq? type ct)
               c)
              ((pair? parent)
               ;; C is a compound condition.
               (let ((field-index (first-field-index parent)))
                 ;;(format #t "field-index: ~a ~a~%" field-index
                 ;;        (list-fields field-index
                 ;;                     (condition-type-all-fields type)))
                 (apply make-condition type
                        (list-fields field-index
                                     (condition-type-all-fields type)))))
              (else
               ;; C does not have type TYPE.
               #f)))
      (throw 'wrong-type-arg "extract-condition"
             "Wrong type argument")))


;;;
;;; Syntax.
;;;

(define-macro (define-condition-type name parent pred . field-specs)
  `(begin
     (define ,name
       (make-condition-type ',name ,parent
			    ',(map car field-specs)))
     (define (,pred c)
       (condition-has-type? c ,name))
     ,@(map (lambda (field-spec)
	      (let ((field-name (car field-spec))
		    (accessor   (cadr field-spec)))
		`(define (,accessor c)
		   (condition-ref c ',field-name))))
	    field-specs)))

(define-macro (condition . type-field-bindings)
  (cond ((null? type-field-bindings)
	 (error "`condition' syntax error" type-field-bindings))
	(else
	 ;; the poor man's hygienic macro
	 (let ((mc   (gensym "mc"))
	       (mcct (gensym "mcct")))
	   `(let ((,mc   (@  (srfi srfi-35) make-condition))
		  (,mcct (@@ (srfi srfi-35) make-compound-condition-type)))
	      (,mc (,mcct 'compound (list ,@(map car type-field-bindings)))
		   ,@(append-map (lambda (type-field-binding)
				   (append-map (lambda (field+value)
						 (let ((f (car field+value))
						       (v (cadr field+value)))
						   `(',f ,v)))
					       (cdr type-field-binding)))
				 type-field-bindings)))))))


;;;
;;; Standard condition types.
;;;

(define &condition
  ;; The root condition type.
  (make-struct %condition-type-vtable 0
	       (make-struct-layout "")
	       (lambda (c port)
		 (display "<&condition>"))
	       '&condition #f '() '()))

(define-condition-type &message &condition
  message-condition?
  (message condition-message))

(define-condition-type &serious &condition
  serious-condition?)

(define-condition-type &error &serious
  error?)


;;; Local Variables:
;;; coding: latin-1
;;; End:

;;; srfi-35.scm ends here
