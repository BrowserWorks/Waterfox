;;; eieio.el --- Enhanced Implementation of Emacs Interpreted Objects
;;;              or maybe Eric's Implementation of Emacs Interpreted Objects

;; Copyright (C) 1995-1996, 1998-2014 Free Software Foundation, Inc.

;; Author: Eric M. Ludlam <zappo@gnu.org>
;; Version: 1.4
;; Keywords: OO, lisp

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
;;
;; EIEIO is a series of Lisp routines which implements a subset of
;; CLOS, the Common Lisp Object System.  In addition, EIEIO also adds
;; a few new features which help it integrate more strongly with the
;; Emacs running environment.
;;
;; See eieio.texi for complete documentation on using this package.
;;
;; Note: the implementation of the c3 algorithm is based on:
;;   Kim Barrett et al.: A Monotonic Superclass Linearization for Dylan
;;   Retrieved from:
;;   http://192.220.96.201/dylan/linearization-oopsla96.html

;; There is funny stuff going on with typep and deftype.  This
;; is the only way I seem to be able to make this stuff load properly.

;; @TODO - fix :initform to be a form, not a quoted value
;; @TODO - Prefix non-clos functions with `eieio-'.

;;; Code:

(eval-when-compile (require 'cl))       ;FIXME: Use cl-lib!

(defvar eieio-version "1.4"
  "Current version of EIEIO.")

(defun eieio-version ()
  "Display the current version of EIEIO."
  (interactive)
  (message eieio-version))

(require 'eieio-core)


;;; Defining a new class
;;
(defmacro defclass (name superclass slots &rest options-and-doc)
  "Define NAME as a new class derived from SUPERCLASS with SLOTS.
OPTIONS-AND-DOC is used as the class' options and base documentation.
SUPERCLASS is a list of superclasses to inherit from, with SLOTS
being the slots residing in that class definition.  NOTE: Currently
only one slot may exist in SUPERCLASS as multiple inheritance is not
yet supported.  Supported tags are:

  :initform   - Initializing form.
  :initarg    - Tag used during initialization.
  :accessor   - Tag used to create a function to access this slot.
  :allocation - Specify where the value is stored.
                Defaults to `:instance', but could also be `:class'.
  :writer     - A function symbol which will `write' an object's slot.
  :reader     - A function symbol which will `read' an object.
  :type       - The type of data allowed in this slot (see `typep').
  :documentation
              - A string documenting use of this slot.

The following are extensions on CLOS:
  :protection - Specify protection for this slot.
                Defaults to `:public'.  Also use `:protected', or `:private'.
  :custom     - When customizing an object, the custom :type.  Public only.
  :label      - A text string label used for a slot when customizing.
  :group      - Name of a customization group this slot belongs in.
  :printer    - A function to call to print the value of a slot.
                See `eieio-override-prin1' as an example.

A class can also have optional options.  These options happen in place
of documentation (including a :documentation tag), in addition to
documentation, or not at all.  Supported options are:

  :documentation - The doc-string used for this class.

Options added to EIEIO:

  :allow-nil-initform - Non-nil to skip typechecking of null initforms.
  :custom-groups      - List of custom group names.  Organizes slots into
                        reasonable groups for customizations.
  :abstract           - Non-nil to prevent instances of this class.
                        If a string, use as an error string if someone does
                        try to make an instance.
  :method-invocation-order
                      - Control the method invocation order if there is
                        multiple inheritance.  Valid values are:
                         :breadth-first - The default.
                         :depth-first

Options in CLOS not supported in EIEIO:

  :metaclass - Class to use in place of `standard-class'
  :default-initargs - Initargs to use when initializing new objects of
                      this class.

Due to the way class options are set up, you can add any tags you wish,
and reference them using the function `class-option'."
  ;; This is eval-and-compile only to silence spurious compiler warnings
  ;; about functions and variables not known to be defined.
  ;; When eieio-defclass code is merged here and this becomes
  ;; transparent to the compiler, the eval-and-compile can be removed.
  `(eval-and-compile
     (eieio-defclass ',name ',superclass ',slots ',options-and-doc)))


;;; CLOS style implementation of object creators.
;;
(defun make-instance (class &rest initargs)
  "Make a new instance of CLASS based on INITARGS.
CLASS is a class symbol.  For example:

  (make-instance 'foo)

  INITARGS is a property list with keywords based on the :initarg
for each slot.  For example:

  (make-instance 'foo :slot1 value1 :slotN valueN)

Compatibility note:

If the first element of INITARGS is a string, it is used as the
name of the class.

In EIEIO, the class' constructor requires a name for use when printing.
`make-instance' in CLOS doesn't use names the way Emacs does, so the
class is used as the name slot instead when INITARGS doesn't start with
a string."
  (if (and (car initargs) (stringp (car initargs)))
      (apply (class-constructor class) initargs)
    (apply  (class-constructor class)
	    (cond ((symbolp class) (symbol-name class))
		  (t (format "%S" class)))
	    initargs)))


;;; CLOS methods and generics
;;
(defmacro defgeneric (method args &optional doc-string)
  "Create a generic function METHOD.
DOC-STRING is the base documentation for this class.  A generic
function has no body, as its purpose is to decide which method body
is appropriate to use.  Uses `defmethod' to create methods, and calls
`defgeneric' for you.  With this implementation the ARGS are
currently ignored.  You can use `defgeneric' to apply specialized
top level documentation to a method."
  `(eieio--defalias ',method
                    (eieio--defgeneric-init-form ',method ,doc-string)))

(defmacro defmethod (method &rest args)
  "Create a new METHOD through `defgeneric' with ARGS.

The optional second argument KEY is a specifier that
modifies how the method is called, including:
   :before  - Method will be called before the :primary
   :primary - The default if not specified
   :after   - Method will be called after the :primary
   :static  - First arg could be an object or class
The next argument is the ARGLIST.  The ARGLIST specifies the arguments
to the method as with `defun'.  The first argument can have a type
specifier, such as:
  ((VARNAME CLASS) ARG2 ...)
where VARNAME is the name of the local variable for the method being
created.  The CLASS is a class symbol for a class made with `defclass'.
A DOCSTRING comes after the ARGLIST, and is optional.
All the rest of the args are the BODY of the method.  A method will
return the value of the last form in the BODY.

Summary:

 (defmethod mymethod [:before | :primary | :after | :static]
                     ((typearg class-name) arg2 &optional opt &rest rest)
    \"doc-string\"
     body)"
  (let* ((key (if (keywordp (car args)) (pop args)))
	 (params (car args))
	 (arg1 (car params))
         (fargs (if (consp arg1)
                   (cons (car arg1) (cdr params))
                 params))
	 (class (if (consp arg1) (nth 1 arg1)))
         (code `(lambda ,fargs ,@(cdr args))))
    `(progn
       ;; Make sure there is a generic and the byte-compiler sees it.
       (defgeneric ,method ,args
         ,(or (documentation code)
              (format "Generically created method `%s'." method)))
       (eieio--defmethod ',method ',key ',class #',code))))

;;; Get/Set slots in an object.
;;
(defmacro oref (obj slot)
  "Retrieve the value stored in OBJ in the slot named by SLOT.
Slot is the name of the slot when created by `defclass' or the label
created by the :initarg tag."
  `(eieio-oref ,obj (quote ,slot)))

(defalias 'slot-value 'eieio-oref)
(defalias 'set-slot-value 'eieio-oset)

(defmacro oref-default (obj slot)
  "Get the default value of OBJ (maybe a class) for SLOT.
The default value is the value installed in a class with the :initform
tag.  SLOT can be the slot name, or the tag specified by the :initarg
tag in the `defclass' call."
  `(eieio-oref-default ,obj (quote ,slot)))

;;; Handy CLOS macros
;;
(defmacro with-slots (spec-list object &rest body)
  "Bind SPEC-LIST lexically to slot values in OBJECT, and execute BODY.
This establishes a lexical environment for referring to the slots in
the instance named by the given slot-names as though they were
variables.  Within such a context the value of the slot can be
specified by using its slot name, as if it were a lexically bound
variable.  Both setf and setq can be used to set the value of the
slot.

SPEC-LIST is of a form similar to `let'.  For example:

  ((VAR1 SLOT1)
    SLOT2
    SLOTN
   (VARN+1 SLOTN+1))

Where each VAR is the local variable given to the associated
SLOT.  A slot specified without a variable name is given a
variable name of the same name as the slot."
  (declare (indent 2))
  ;; Transform the spec-list into a cl-symbol-macrolet spec-list.
  (let ((mappings (mapcar (lambda (entry)
			    (let ((var  (if (listp entry) (car entry) entry))
				  (slot (if (listp entry) (cadr entry) entry)))
			      (list var `(slot-value ,object ',slot))))
			  spec-list)))
    (append (list 'cl-symbol-macrolet mappings)
	    body)))

;;; Simple generators, and query functions.  None of these would do
;;  well embedded into an object.
;;
(define-obsolete-function-alias
  'object-class-fast #'eieio--object-class "24.4")

(defun eieio-object-name (obj &optional extra)
  "Return a Lisp like symbol string for object OBJ.
If EXTRA, include that in the string returned to represent the symbol."
  (eieio--check-type eieio-object-p obj)
  (format "#<%s %s%s>" (symbol-name (eieio--object-class obj))
	  (eieio--object-name obj) (or extra "")))
(define-obsolete-function-alias 'object-name #'eieio-object-name "24.4")

(defun eieio-object-name-string (obj) "Return a string which is OBJ's name."
  (eieio--check-type eieio-object-p obj)
  (eieio--object-name obj))
(define-obsolete-function-alias
  'object-name-string #'eieio-object-name-string "24.4")

(defun eieio-object-set-name-string (obj name)
  "Set the string which is OBJ's NAME."
  (eieio--check-type eieio-object-p obj)
  (eieio--check-type stringp name)
  (setf (eieio--object-name obj) name))
(define-obsolete-function-alias
  'object-set-name-string 'eieio-object-set-name-string "24.4")

(defun eieio-object-class (obj) "Return the class struct defining OBJ."
  (eieio--check-type eieio-object-p obj)
  (eieio--object-class obj))
(define-obsolete-function-alias 'object-class #'eieio-object-class "24.4")
;; CLOS name, maybe?
(define-obsolete-function-alias 'class-of #'eieio-object-class "24.4")

(defun eieio-object-class-name (obj)
  "Return a Lisp like symbol name for OBJ's class."
  (eieio--check-type eieio-object-p obj)
  (eieio-class-name (eieio--object-class obj)))
(define-obsolete-function-alias
  'object-class-name 'eieio-object-class-name "24.4")

(defun eieio-class-parents (class)
  "Return parent classes to CLASS.  (overload of variable).

The CLOS function `class-direct-superclasses' is aliased to this function."
  (eieio--check-type class-p class)
  (eieio-class-parents-fast class))
(define-obsolete-function-alias 'class-parents #'eieio-class-parents "24.4")

(defun eieio-class-children (class)
  "Return child classes to CLASS.
The CLOS function `class-direct-subclasses' is aliased to this function."
  (eieio--check-type class-p class)
  (eieio-class-children-fast class))
(define-obsolete-function-alias
  'class-children #'eieio-class-children "24.4")

;; Official CLOS functions.
(define-obsolete-function-alias
  'class-direct-superclasses #'eieio-class-parents "24.4")
(define-obsolete-function-alias
  'class-direct-subclasses #'eieio-class-children "24.4")

(defmacro eieio-class-parent (class)
  "Return first parent class to CLASS.  (overload of variable)."
  `(car (eieio-class-parents ,class)))
(define-obsolete-function-alias 'class-parent 'eieio-class-parent "24.4")

(defun same-class-p (obj class) "Return t if OBJ is of class-type CLASS."
  (eieio--check-type class-p class)
  (eieio--check-type eieio-object-p obj)
  (same-class-fast-p obj class))

(defun object-of-class-p (obj class)
  "Return non-nil if OBJ is an instance of CLASS or CLASS' subclasses."
  (eieio--check-type eieio-object-p obj)
  ;; class will be checked one layer down
  (child-of-class-p (eieio--object-class obj) class))
;; Backwards compatibility
(defalias 'obj-of-class-p 'object-of-class-p)

(defun child-of-class-p (child class)
  "Return non-nil if CHILD class is a subclass of CLASS."
  (eieio--check-type class-p class)
  (eieio--check-type class-p child)
  (let ((p nil))
    (while (and child (not (eq child class)))
      (setq p (append p (eieio--class-parent (class-v child)))
	    child (car p)
	    p (cdr p)))
    (if child t)))

(defun object-slots (obj)
  "Return list of slots available in OBJ."
  (eieio--check-type eieio-object-p obj)
  (eieio--class-public-a (class-v (eieio--object-class obj))))

(defun class-slot-initarg (class slot) "Fetch from CLASS, SLOT's :initarg."
  (eieio--check-type class-p class)
  (let ((ia (eieio--class-initarg-tuples (class-v class)))
	(f nil))
    (while (and ia (not f))
      (if (eq (cdr (car ia)) slot)
	  (setq f (car (car ia))))
      (setq ia (cdr ia)))
    f))

;;; Object Set macros
;;
(defmacro oset (obj slot value)
  "Set the value in OBJ for slot SLOT to VALUE.
SLOT is the slot name as specified in `defclass' or the tag created
with in the :initarg slot.  VALUE can be any Lisp object."
  `(eieio-oset ,obj (quote ,slot) ,value))

(defmacro oset-default (class slot value)
  "Set the default slot in CLASS for SLOT to VALUE.
The default value is usually set with the :initform tag during class
creation.  This allows users to change the default behavior of classes
after they are created."
  `(eieio-oset-default ,class (quote ,slot) ,value))

;;; CLOS queries into classes and slots
;;
(defun slot-boundp (object slot)
  "Return non-nil if OBJECT's SLOT is bound.
Setting a slot's value makes it bound.  Calling `slot-makeunbound' will
make a slot unbound.
OBJECT can be an instance or a class."
  ;; Skip typechecking while retrieving this value.
  (let ((eieio-skip-typecheck t))
    ;; Return nil if the magic symbol is in there.
    (not (eq (cond
	      ((eieio-object-p object) (eieio-oref object slot))
	      ((class-p object)        (eieio-oref-default object slot))
	      (t (signal 'wrong-type-argument (list 'eieio-object-p object))))
	     eieio-unbound))))

(defun slot-makeunbound (object slot)
  "In OBJECT, make SLOT unbound."
  (eieio-oset object slot eieio-unbound))

(defun slot-exists-p (object-or-class slot)
  "Return non-nil if OBJECT-OR-CLASS has SLOT."
  (let ((cv (class-v (cond ((eieio-object-p object-or-class)
			    (eieio-object-class object-or-class))
			   ((class-p object-or-class)
			    object-or-class))
		     )))
    (or (memq slot (eieio--class-public-a cv))
	(memq slot (eieio--class-class-allocation-a cv)))
    ))

(defun find-class (symbol &optional errorp)
  "Return the class that SYMBOL represents.
If there is no class, nil is returned if ERRORP is nil.
If ERRORP is non-nil, `wrong-argument-type' is signaled."
  (if (not (class-p symbol))
      (if errorp (signal 'wrong-type-argument (list 'class-p symbol))
	nil)
    (class-v symbol)))

;;; Slightly more complex utility functions for objects
;;
(defun object-assoc (key slot list)
  "Return an object if KEY is `equal' to SLOT's value of an object in LIST.
LIST is a list of objects whose slots are searched.
Objects in LIST do not need to have a slot named SLOT, nor does
SLOT need to be bound.  If these errors occur, those objects will
be ignored."
  (eieio--check-type listp list)
  (while (and list (not (condition-case nil
			    ;; This prevents errors for missing slots.
			    (equal key (eieio-oref (car list) slot))
			  (error nil))))
    (setq list (cdr list)))
  (car list))

(defun object-assoc-list (slot list)
  "Return an association list with the contents of SLOT as the key element.
LIST must be a list of objects with SLOT in it.
This is useful when you need to do completing read on an object group."
  (eieio--check-type listp list)
  (let ((assoclist nil))
    (while list
      (setq assoclist (cons (cons (eieio-oref (car list) slot)
				  (car list))
			    assoclist))
      (setq list (cdr list)))
    (nreverse assoclist)))

(defun object-assoc-list-safe (slot list)
  "Return an association list with the contents of SLOT as the key element.
LIST must be a list of objects, but those objects do not need to have
SLOT in it.  If it does not, then that element is left out of the association
list."
  (eieio--check-type listp list)
  (let ((assoclist nil))
    (while list
      (if (slot-exists-p (car list) slot)
	  (setq assoclist (cons (cons (eieio-oref (car list) slot)
				      (car list))
				assoclist)))
      (setq list (cdr list)))
    (nreverse assoclist)))

(defun object-add-to-list (object slot item &optional append)
  "In OBJECT's SLOT, add ITEM to the list of elements.
Optional argument APPEND indicates we need to append to the list.
If ITEM already exists in the list in SLOT, then it is not added.
Comparison is done with `equal' through the `member' function call.
If SLOT is unbound, bind it to the list containing ITEM."
  (let (ov)
    ;; Find the originating list.
    (if (not (slot-boundp object slot))
	(setq ov (list item))
      (setq ov (eieio-oref object slot))
      ;; turn it into a list.
      (unless (listp ov)
	(setq ov (list ov)))
      ;; Do the combination
      (if (not (member item ov))
	  (setq ov
		(if append
		    (append ov (list item))
		  (cons item ov)))))
    ;; Set back into the slot.
    (eieio-oset object slot ov)))

(defun object-remove-from-list (object slot item)
  "In OBJECT's SLOT, remove occurrences of ITEM.
Deletion is done with `delete', which deletes by side effect,
and comparisons are done with `equal'.
If SLOT is unbound, do nothing."
  (if (not (slot-boundp object slot))
      nil
    (eieio-oset object slot (delete item (eieio-oref object slot)))))

;;;
;; Method Calling Functions

(defun next-method-p ()
  "Return non-nil if there is a next method.
Returns a list of lambda expressions which is the `next-method'
order."
  eieio-generic-call-next-method-list)

(defun call-next-method (&rest replacement-args)
  "Call the superclass method from a subclass method.
The superclass method is specified in the current method list,
and is called the next method.

If REPLACEMENT-ARGS is non-nil, then use them instead of
`eieio-generic-call-arglst'.  The generic arg list are the
arguments passed in at the top level.

Use `next-method-p' to find out if there is a next method to call."
  (if (not (eieio--scoped-class))
      (error "`call-next-method' not called within a class specific method"))
  (if (and (/= eieio-generic-call-key method-primary)
	   (/= eieio-generic-call-key method-static))
      (error "Cannot `call-next-method' except in :primary or :static methods")
    )
  (let ((newargs (or replacement-args eieio-generic-call-arglst))
	(next (car eieio-generic-call-next-method-list))
	)
    (if (or (not next) (not (car next)))
	(apply 'no-next-method (car newargs) (cdr newargs))
      (let* ((eieio-generic-call-next-method-list
	      (cdr eieio-generic-call-next-method-list))
	     (eieio-generic-call-arglst newargs)
	     (fcn (car next))
	     )
	(eieio--with-scoped-class (cdr next)
	  (apply fcn newargs)) ))))

;;; Here are some CLOS items that need the CL package
;;

(defsetf eieio-oref eieio-oset)

(if (eval-when-compile (fboundp 'gv-define-expander))
    ;; Not needed for Emacs>=24.3 since gv.el's setf expands macros and
    ;; follows aliases.
    nil
(defsetf slot-value eieio-oset)

;; The below setf method was written by Arnd Kohrs <kohrs@acm.org>
(define-setf-method oref (obj slot)
  (with-no-warnings
    (require 'cl)
    (let ((obj-temp (gensym))
	  (slot-temp (gensym))
	  (store-temp (gensym)))
      (list (list obj-temp slot-temp)
	    (list obj `(quote ,slot))
	    (list store-temp)
	    (list 'set-slot-value obj-temp slot-temp
		  store-temp)
	    (list 'slot-value obj-temp slot-temp))))))


;;;
;; We want all objects created by EIEIO to have some default set of
;; behaviors so we can create object utilities, and allow various
;; types of error checking.  To do this, create the default EIEIO
;; class, and when no parent class is specified, use this as the
;; default.  (But don't store it in the other classes as the default,
;; allowing for transparent support.)
;;

(defclass eieio-default-superclass nil
  nil
  "Default parent class for classes with no specified parent class.
Its slots are automatically adopted by classes with no specified parents.
This class is not stored in the `parent' slot of a class vector."
  :abstract t)

(defalias 'standard-class 'eieio-default-superclass)

(defgeneric constructor (class newname &rest slots)
  "Default constructor for CLASS `eieio-default-superclass'.")

(defmethod constructor :static
  ((class eieio-default-superclass) newname &rest slots)
  "Default constructor for CLASS `eieio-default-superclass'.
NEWNAME is the name to be given to the constructed object.
SLOTS are the initialization slots used by `shared-initialize'.
This static method is called when an object is constructed.
It allocates the vector used to represent an EIEIO object, and then
calls `shared-initialize' on that object."
  (let* ((new-object (copy-sequence (eieio--class-default-object-cache (class-v class)))))
    ;; Update the name for the newly created object.
    (setf (eieio--object-name new-object) newname)
    ;; Call the initialize method on the new object with the slots
    ;; that were passed down to us.
    (initialize-instance new-object slots)
    ;; Return the created object.
    new-object))

(defgeneric shared-initialize (obj slots)
  "Set slots of OBJ with SLOTS which is a list of name/value pairs.
Called from the constructor routine.")

(defmethod shared-initialize ((obj eieio-default-superclass) slots)
  "Set slots of OBJ with SLOTS which is a list of name/value pairs.
Called from the constructor routine."
  (eieio--with-scoped-class (eieio--object-class obj)
    (while slots
      (let ((rn (eieio-initarg-to-attribute (eieio--object-class obj)
					    (car slots))))
	(if (not rn)
	    (slot-missing obj (car slots) 'oset (car (cdr slots)))
	  (eieio-oset obj rn (car (cdr slots)))))
      (setq slots (cdr (cdr slots))))))

(defgeneric initialize-instance (this &optional slots)
  "Construct the new object THIS based on SLOTS.")

(defmethod initialize-instance ((this eieio-default-superclass)
				&optional slots)
  "Construct the new object THIS based on SLOTS.
SLOTS is a tagged list where odd numbered elements are tags, and
even numbered elements are the values to store in the tagged slot.
If you overload the `initialize-instance', there you will need to
call `shared-initialize' yourself, or you can call `call-next-method'
to have this constructor called automatically.  If these steps are
not taken, then new objects of your class will not have their values
dynamically set from SLOTS."
  ;; First, see if any of our defaults are `lambda', and
  ;; re-evaluate them and apply the value to our slots.
  (let* ((this-class (class-v (eieio--object-class this)))
	 (slot (eieio--class-public-a this-class))
	 (defaults (eieio--class-public-d this-class)))
    (while slot
      ;; For each slot, see if we need to evaluate it.
      ;;
      ;; Paul Landes said in an email:
      ;; > CL evaluates it if it can, and otherwise, leaves it as
      ;; > the quoted thing as you already have.  This is by the
      ;; > Sonya E. Keene book and other things I've look at on the
      ;; > web.
      (let ((dflt (eieio-default-eval-maybe (car defaults))))
	(when (not (eq dflt (car defaults)))
	  (eieio-oset this (car slot) dflt) ))
      ;; Next.
      (setq slot (cdr slot)
	    defaults (cdr defaults))))
  ;; Shared initialize will parse our slots for us.
  (shared-initialize this slots))

(defgeneric slot-missing (object slot-name operation &optional new-value)
  "Method invoked when an attempt to access a slot in OBJECT fails.")

(defmethod slot-missing ((object eieio-default-superclass) slot-name
			 operation &optional new-value)
  "Method invoked when an attempt to access a slot in OBJECT fails.
SLOT-NAME is the name of the failed slot, OPERATION is the type of access
that was requested, and optional NEW-VALUE is the value that was desired
to be set.

This method is called from `oref', `oset', and other functions which
directly reference slots in EIEIO objects."
  (signal 'invalid-slot-name (list (eieio-object-name object)
				   slot-name)))

(defgeneric slot-unbound (object class slot-name fn)
  "Slot unbound is invoked during an attempt to reference an unbound slot.")

(defmethod slot-unbound ((object eieio-default-superclass)
			 class slot-name fn)
  "Slot unbound is invoked during an attempt to reference an unbound slot.
OBJECT is the instance of the object being reference.  CLASS is the
class of OBJECT, and SLOT-NAME is the offending slot.  This function
throws the signal `unbound-slot'.  You can overload this function and
return the value to use in place of the unbound value.
Argument FN is the function signaling this error.
Use `slot-boundp' to determine if a slot is bound or not.

In CLOS, the argument list is (CLASS OBJECT SLOT-NAME), but
EIEIO can only dispatch on the first argument, so the first two are swapped."
  (signal 'unbound-slot (list (eieio-class-name class) (eieio-object-name object)
			      slot-name fn)))

(defgeneric no-applicable-method (object method &rest args)
  "Called if there are no implementations for OBJECT in METHOD.")

(defmethod no-applicable-method ((object eieio-default-superclass)
				 method &rest args)
  "Called if there are no implementations for OBJECT in METHOD.
OBJECT is the object which has no method implementation.
ARGS are the arguments that were passed to METHOD.

Implement this for a class to block this signal.  The return
value becomes the return value of the original method call."
  (signal 'no-method-definition (list method (eieio-object-name object)))
  )

(defgeneric no-next-method (object &rest args)
"Called from `call-next-method' when no additional methods are available.")

(defmethod no-next-method ((object eieio-default-superclass)
			   &rest args)
  "Called from `call-next-method' when no additional methods are available.
OBJECT is othe object being called on `call-next-method'.
ARGS are the arguments it is called by.
This method signals `no-next-method' by default.  Override this
method to not throw an error, and its return value becomes the
return value of `call-next-method'."
  (signal 'no-next-method (list (eieio-object-name object) args))
  )

(defgeneric clone (obj &rest params)
  "Make a copy of OBJ, and then supply PARAMS.
PARAMS is a parameter list of the same form used by `initialize-instance'.

When overloading `clone', be sure to call `call-next-method'
first and modify the returned object.")

(defmethod clone ((obj eieio-default-superclass) &rest params)
  "Make a copy of OBJ, and then apply PARAMS."
  (let ((nobj (copy-sequence obj))
	(nm (eieio--object-name obj))
	(passname (and params (stringp (car params))))
	(num 1))
    (if params (shared-initialize nobj (if passname (cdr params) params)))
    (if (not passname)
	(save-match-data
	  (if (string-match "-\\([0-9]+\\)" nm)
	      (setq num (1+ (string-to-number (match-string 1 nm)))
		    nm (substring nm 0 (match-beginning 0))))
	  (setf (eieio--object-name nobj) (concat nm "-" (int-to-string num))))
      (setf (eieio--object-name nobj) (car params)))
    nobj))

(defgeneric destructor (this &rest params)
  "Destructor for cleaning up any dynamic links to our object.")

(defmethod destructor ((this eieio-default-superclass) &rest params)
  "Destructor for cleaning up any dynamic links to our object.
Argument THIS is the object being destroyed.  PARAMS are additional
ignored parameters."
  ;; No cleanup... yet.
  )

(defgeneric object-print (this &rest strings)
  "Pretty printer for object THIS.  Call function `object-name' with STRINGS.

It is sometimes useful to put a summary of the object into the
default #<notation> string when using EIEIO browsing tools.
Implement this method to customize the summary.")

(defmethod object-print ((this eieio-default-superclass) &rest strings)
  "Pretty printer for object THIS.  Call function `object-name' with STRINGS.
The default method for printing object THIS is to use the
function `object-name'.

It is sometimes useful to put a summary of the object into the
default #<notation> string when using EIEIO browsing tools.

Implement this function and specify STRINGS in a call to
`call-next-method' to provide additional summary information.
When passing in extra strings from child classes, always remember
to prepend a space."
  (eieio-object-name this (apply 'concat strings)))

(defvar eieio-print-depth 0
  "When printing, keep track of the current indentation depth.")

(defgeneric object-write (this &optional comment)
  "Write out object THIS to the current stream.
Optional COMMENT will add comments to the beginning of the output.")

(defmethod object-write ((this eieio-default-superclass) &optional comment)
  "Write object THIS out to the current stream.
This writes out the vector version of this object.  Complex and recursive
object are discouraged from being written.
  If optional COMMENT is non-nil, include comments when outputting
this object."
  (when comment
    (princ ";; Object ")
    (princ (eieio-object-name-string this))
    (princ "\n")
    (princ comment)
    (princ "\n"))
  (let* ((cl (eieio-object-class this))
	 (cv (class-v cl)))
    ;; Now output readable lisp to recreate this object
    ;; It should look like this:
    ;; (<constructor> <name> <slot> <slot> ... )
    ;; Each slot's slot is writen using its :writer.
    (princ (make-string (* eieio-print-depth 2) ? ))
    (princ "(")
    (princ (symbol-name (class-constructor (eieio-object-class this))))
    (princ " ")
    (prin1 (eieio-object-name-string this))
    (princ "\n")
    ;; Loop over all the public slots
    (let ((publa (eieio--class-public-a cv))
	  (publd (eieio--class-public-d cv))
	  (publp (eieio--class-public-printer cv))
	  (eieio-print-depth (1+ eieio-print-depth)))
      (while publa
	(when (slot-boundp this (car publa))
	  (let ((i (class-slot-initarg cl (car publa)))
		(v (eieio-oref this (car publa)))
		)
	    (unless (or (not i) (equal v (car publd)))
	      (unless (bolp)
		(princ "\n"))
	      (princ (make-string (* eieio-print-depth 2) ? ))
	      (princ (symbol-name i))
	      (if (car publp)
		  ;; Use our public printer
		  (progn
		    (princ " ")
		    (funcall (car publp) v))
		;; Use our generic override prin1 function.
		(princ (if (or (eieio-object-p v)
                               (eieio-object-p (car-safe v)))
                           "\n" " "))
		(eieio-override-prin1 v)))))
	(setq publa (cdr publa) publd (cdr publd)
	      publp (cdr publp))))
    (princ ")")
    (when (= eieio-print-depth 0)
      (princ "\n"))))

(defun eieio-override-prin1 (thing)
  "Perform a `prin1' on THING taking advantage of object knowledge."
  (cond ((eieio-object-p thing)
	 (object-write thing))
	((consp thing)
	 (eieio-list-prin1 thing))
	((class-p thing)
	 (princ (eieio-class-name thing)))
	((or (keywordp thing) (booleanp thing))
	 (prin1 thing))
	((symbolp thing)
	 (princ (concat "'" (symbol-name thing))))
	(t (prin1 thing))))

(defun eieio-list-prin1 (list)
  "Display LIST where list may contain objects."
  (if (not (eieio-object-p (car list)))
      (progn
	(princ "'")
	(prin1 list))
    (princ (make-string (* eieio-print-depth 2) ? ))
    (princ "(list")
    (let ((eieio-print-depth (1+ eieio-print-depth)))
      (while list
	(princ "\n")
	(if (eieio-object-p (car list))
	    (object-write (car list))
	  (princ (make-string (* eieio-print-depth 2) ? ))
	  (eieio-override-prin1 (car list)))
	(setq list (cdr list))))
    (princ ")")))


;;; Unimplemented functions from CLOS
;;
(defun change-class (obj class)
  "Change the class of OBJ to type CLASS.
This may create or delete slots, but does not affect the return value
of `eq'."
  (error "EIEIO: `change-class' is unimplemented"))

;; Hook ourselves into help system for describing classes and methods.
(add-hook 'help-fns-describe-function-functions 'eieio-help-generic)
(add-hook 'help-fns-describe-function-functions 'eieio-help-constructor)

;;; Interfacing with edebug
;;
(defun eieio-edebug-prin1-to-string (object &optional noescape)
  "Display EIEIO OBJECT in fancy format.
Overrides the edebug default.
Optional argument NOESCAPE is passed to `prin1-to-string' when appropriate."
  (cond ((class-p object) (eieio-class-name object))
	((eieio-object-p object) (object-print object))
	((and (listp object) (or (class-p (car object))
				 (eieio-object-p (car object))))
	 (concat "(" (mapconcat 'eieio-edebug-prin1-to-string object " ") ")"))
	(t (prin1-to-string object noescape))))

(add-hook 'edebug-setup-hook
	  (lambda ()
	    (def-edebug-spec defmethod
	      (&define			; this means we are defining something
	       [&or name ("setf" :name setf name)]
	       ;; ^^ This is the methods symbol
	       [ &optional symbolp ]    ; this is key :before etc
	       list              ; arguments
	       [ &optional stringp ]    ; documentation string
	       def-body	                ; part to be debugged
	       ))
	    ;; The rest of the macros
	    (def-edebug-spec oref (form quote))
	    (def-edebug-spec oref-default (form quote))
	    (def-edebug-spec oset (form quote form))
	    (def-edebug-spec oset-default (form quote form))
	    (def-edebug-spec class-v form)
	    (def-edebug-spec class-p form)
	    (def-edebug-spec eieio-object-p form)
	    (def-edebug-spec class-constructor form)
	    (def-edebug-spec generic-p form)
	    (def-edebug-spec with-slots (list list def-body))
	    ;; I suspect this isn't the best way to do this, but when
	    ;; cust-print was used on my system all my objects
	    ;; appeared as "#1 =" which was not useful.  This allows
	    ;; edebug to print my objects in the nice way they were
	    ;; meant to with `object-print' and `class-name'
	    ;; (defalias 'edebug-prin1-to-string 'eieio-edebug-prin1-to-string)
	    )
	  )


;;; Start of automatically extracted autoloads.

;;;### (autoloads nil "eieio-custom" "eieio-custom.el" "5b0e7b1beea11f9e9de6887279f75d61")
;;; Generated autoloads from eieio-custom.el

(autoload 'customize-object "eieio-custom" "\
Customize OBJ in a custom buffer.
Optional argument GROUP is the sub-group of slots to display.

\(fn OBJ &optional GROUP)" nil nil)

;;;***

;;;### (autoloads nil "eieio-opt" "eieio-opt.el" "99b94c63a73593402e3c825178a44f4f")
;;; Generated autoloads from eieio-opt.el

(autoload 'eieio-browse "eieio-opt" "\
Create an object browser window to show all objects.
If optional ROOT-CLASS, then start with that, otherwise start with
variable `eieio-default-superclass'.

\(fn &optional ROOT-CLASS)" t nil)

(autoload 'eieio-help-class "eieio-opt" "\
Print help description for CLASS.
If CLASS is actually an object, then also display current values of that object.

\(fn CLASS)" nil nil)

(autoload 'eieio-help-constructor "eieio-opt" "\
Describe CTR if it is a class constructor.

\(fn CTR)" nil nil)

(autoload 'eieio-help-generic "eieio-opt" "\
Describe GENERIC if it is a generic function.

\(fn GENERIC)" nil nil)

;;;***

;;; End of automatically extracted autoloads.

(provide 'eieio)

;;; eieio ends here
