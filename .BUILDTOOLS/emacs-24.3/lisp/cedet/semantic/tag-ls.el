;;; semantic/tag-ls.el --- Language Specific override functions for tags

;; Copyright (C) 1999-2004, 2006-2013 Free Software Foundation, Inc.

;; Author: Eric M. Ludlam <zappo@gnu.org>

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
;; There are some features of tags that are too language dependent to
;; put in the core `semantic-tag' functionality.  For instance, the
;; protection of a tag (as specified by UML) could be almost anything.
;; In Java, it is a type specifier.  In C, there is a label.  This
;; information can be derived, and thus should not be stored in the tag
;; itself.  These are the functions that languages can use to derive
;; the information.

(require 'semantic)
(require 'semantic/find)

;;; Code:

;;; TAG SIMILARITY:
;;
;; Two tags that represent the same thing are "similar", but not the "same".
;; Similar tags might have the same name, but one is a :prototype, while
;; the other is an implementation.
;;
;; Each language will have different things that can be ignored
;; between two "similar" tags, so similarity checks involve a series
;; of mode overridable features.  Some are "internal" features.
(defvar semantic-tag-similar-ignorable-attributes '(:prototype-flag)
  "The tag attributes that can be ignored during a similarity test.")

(define-overloadable-function semantic--tag-similar-names-p (tag1 tag2 blankok)
  "Compare the names of TAG1 and TAG2.
If BLANKOK is false, then the names must exactly match.
If BLANKOK is true, then if either of TAG1 or TAG2 has blank
names, then that is ok, and this returns true, but if they both
have values, they must still match.")

(defun semantic--tag-similar-names-p-default (tag1 tag2 blankok)
  "Compare the names of TAG1 and TAG2.
If BLANKOK is false, then the names must exactly match.
If BLANKOK is true, then if either of TAG1 or TAG2 has blank
names, then that is ok, and this returns true, but if they both
have values, they must still match."
  (let ((n1 (semantic-tag-name tag1))
	(n2 (semantic-tag-name tag2)))
    (or (and blankok (or (null n1) (null n2) (string= n1 "") (string= n2 "")))
	(string= n1 n2))))

(define-overloadable-function semantic--tag-similar-types-p (tag1 tag2)
  "Compare the types of TAG1 and TAG2.
This function can be overridden, for example to compare a fully
qualified with an unqualified type."
  (cond
   ((and (null (semantic-tag-type tag1))
	 (null (semantic-tag-type tag2)))
    t)
   ((or (null (semantic-tag-type tag1))
	(null (semantic-tag-type tag2)))
    nil)
   (t
    (:override))))

(defun semantic--tag-similar-types-p-default (tag1 tag2)
  "Compare the types of TAG1 and TAG2.
This function can be overridden, for example to compare a fully
qualified with an unqualified type."
  (semantic-tag-of-type-p tag1 (semantic-tag-type tag2)))

(define-overloadable-function semantic--tag-attribute-similar-p (attr value1 value2 ignorable-attributes)
  "Test to see if attribute ATTR is similar for VALUE1 and VALUE2.
IGNORABLE-ATTRIBUTES is described in `semantic-tag-similar-p'.
This function is internal, but allows customization of `semantic-tag-similar-p'
for a given mode at a more granular level.

Note that :type, :name, and anything in IGNORABLE-ATTRIBUTES will
not be passed to this function.

Modes that override this function can call `semantic--tag-attribute-similar-p-default'
to do the default equality tests if ATTR is not special for that mode.")

(defun semantic--tag-attribute-similar-p-default (attr value1 value2 ignorable-attributes)
  "For ATTR, VALUE1, VALUE2 and IGNORABLE-ATTRIBUTES, test for similarity."
  (cond
   ;; Tag sublists require special testing.
   ((and (listp value1) (semantic-tag-p (car value1))
	 (listp value2) (semantic-tag-p (car value2)))
    (let ((ans t)
	  (taglist1 value1)
	  (taglist2 value2))
      (when (not (eq (length taglist1) (length taglist2)))
	(setq ans nil))
      (while (and ans taglist1 taglist2)
	(setq ans (apply 'semantic-tag-similar-p
			 (car taglist1) (car taglist2)
			 ignorable-attributes)
	      taglist1 (cdr taglist1)
	      taglist2 (cdr taglist2)))
      ans))

   ;; The attributes are not the same?
   ((not (equal value1 value2))
    nil)

   (t t))
  )

(define-overloadable-function semantic-tag-similar-p (tag1 tag2 &rest ignorable-attributes)
  "Test to see if TAG1 and TAG2 are similar.
Two tags are similar if their name, datatype, and various attributes
are the same.

Similar tags that have sub-tags such as arg lists or type members,
are similar w/out checking the sub-list of tags.
Optional argument IGNORABLE-ATTRIBUTES are attributes to ignore while comparing similarity.
By default, `semantic-tag-similar-ignorable-attributes' is referenced for
attributes, and IGNORABLE-ATTRIBUTES will augment this list.

Note that even though :name is not an attribute, it can be used to
to indicate lax comparison of names via `semantic--tag-similar-names-p'")

;; Note: optional thing is because overloadable fcns don't handle this
;; quite right.
(defun semantic-tag-similar-p-default (tag1 tag2 &optional ignorable-attributes)
  "Test to see if TAG1 and TAG2 are similar.
Two tags are similar if their name, datatype, and various attributes
are the same.

IGNORABLE-ATTRIBUTES are tag attributes that can be ignored.

See `semantic-tag-similar-p' for details."
  (let* ((ignore (append ignorable-attributes semantic-tag-similar-ignorable-attributes))
	 (A1 (and (semantic--tag-similar-names-p tag1 tag2 (memq :name ignore))
		  (semantic--tag-similar-types-p tag1 tag2)
		  (semantic-tag-of-class-p tag1 (semantic-tag-class tag2))))
	 (attr1 (semantic-tag-attributes tag1))
	 (attr2 (semantic-tag-attributes tag2))
	 (A2 t)
	 (A3 t)
	 )
    ;; Test if there are non-ignorable attributes in A2 which are not present in A1
    (while (and A2 attr2)
      (let ((a (car attr2)))
	(unless (or (eq a :type) (memq a ignore))
	  (setq A2 (semantic-tag-get-attribute tag1 a)))
	(setq attr2 (cdr (cdr attr2)))))
    (while (and A2 attr1 A3)
      (let ((a (car attr1)))

	(cond ((or (eq a :type) ;; already tested above.
		   (memq a ignore)) ;; Ignore them...
	       nil)

	      (t
	       (setq A3
		     (semantic--tag-attribute-similar-p
		      a (car (cdr attr1)) (semantic-tag-get-attribute tag2 a)
		      ignorable-attributes)))
	      ))
      (setq attr1 (cdr (cdr attr1))))
    (and A1 A2 A3)))

;;; FULL NAMES
;;
;; For programmer convenience, a full name is not specified in source
;; code.  Instead some abbreviation is made, and the local environment
;; will contain the info needed to determine the full name.
(define-overloadable-function semantic-tag-full-package (tag &optional stream-or-buffer)
  "Return the fully qualified package name of TAG in a package hierarchy.
STREAM-OR-BUFFER can be anything convertible by `semantic-something-to-stream',
but must be a toplevel semantic tag stream that contains TAG.
A Package Hierarchy is defined in UML by the way classes and methods
are organized on disk.  Some languages use this concept such that a
class can be accessed via it's fully qualified name, (such as Java.)
Other languages qualify names within a Namespace (such as C++) which
result in a different package like structure.

Languages which do not override this function will just search the
stream for a tag of class 'package, and return that."
  (let ((stream (semantic-something-to-tag-table
                 (or stream-or-buffer tag))))
    (:override-with-args (tag stream))))

(defun semantic-tag-full-package-default (tag stream)
  "Default method for `semantic-tag-full-package' for TAG.
Return the name of the first tag of class `package' in STREAM."
  (let ((pack (car-safe (semantic-find-tags-by-class 'package stream))))
    (when (and pack (semantic-tag-p pack))
      (semantic-tag-name pack))))

(define-overloadable-function semantic-tag-full-name (tag &optional stream-or-buffer)
  "Return the fully qualified name of TAG in the package hierarchy.
STREAM-OR-BUFFER can be anything convertible by `semantic-something-to-stream',
but must be a toplevel semantic tag stream that contains TAG.
A Package Hierarchy is defined in UML by the way classes and methods
are organized on disk.  Some languages use this concept such that a
class can be accessed via it's fully qualified name, (such as Java.)
Other languages qualify names within a Namespace (such as C++) which
result in a different package like structure.

Languages which do not override this function with
`tag-full-name' will combine `semantic-tag-full-package' and
`semantic-tag-name', separated with language separator character.
Override functions only need to handle STREAM-OR-BUFFER with a
tag stream value, or nil.

TODO - this function should probably also take a PARENT to TAG to
resolve issues where a method in a class in a package is present."
  (let ((stream (semantic-something-to-tag-table
                 (or stream-or-buffer tag))))
    (:override-with-args (tag stream))))

(make-obsolete-overload 'semantic-nonterminal-full-name
                        'semantic-tag-full-name "23.2")

(defun semantic-tag-full-name-default (tag stream)
  "Default method for `semantic-tag-full-name'.
Return the name of TAG found in the toplevel STREAM."
  (let ((pack (semantic-tag-full-package tag stream))
	(name (semantic-tag-name tag)))
    (if pack
	(concat pack
		(car semantic-type-relation-separator-character)
		name)
      name)))

;;; UML features:
;;
;; UML can represent several types of features of a tag
;; such as the `protection' of a symbol, or if it is abstract,
;; leaf, etc.  Learn about UML to catch onto the lingo.

(define-overloadable-function semantic-tag-calculate-parent (tag)
  "Attempt to calculate the parent of TAG.
The default behavior (if not overridden with `tag-calculate-parent')
is to search a buffer found with TAG, and if externally defined,
search locally, then semanticdb for that tag (when enabled.)")

(defun semantic-tag-calculate-parent-default (tag)
  "Attempt to calculate the parent of TAG."
  (when (semantic-tag-in-buffer-p tag)
    (with-current-buffer (semantic-tag-buffer tag)
      (save-excursion
	(goto-char (semantic-tag-start tag))
	(semantic-current-tag-parent))
      )))

(define-overloadable-function semantic-tag-protection (tag &optional parent)
  "Return protection information about TAG with optional PARENT.
This function returns on of the following symbols:
   nil        - No special protection.  Language dependent.
   'public    - Anyone can access this TAG.
   'private   - Only methods in the local scope can access TAG.
   'protected - Like private for outside scopes, like public for child
                classes.
Some languages may choose to provide additional return symbols specific
to themselves.  Use of this function should allow for this.

The default behavior (if not overridden with `tag-protection'
is to return a symbol based on type modifiers."
  (and (not parent)
       (semantic-tag-overlay tag)
       (semantic-tag-in-buffer-p tag)
       (setq parent (semantic-tag-calculate-parent tag)))
  (:override))

(make-obsolete-overload 'semantic-nonterminal-protection
                        'semantic-tag-protection "23.2")

(defun semantic-tag-protection-default (tag &optional parent)
  "Return the protection of TAG as a child of PARENT default action.
See `semantic-tag-protection'."
  (let ((mods (semantic-tag-modifiers tag))
	(prot nil))
    (while (and (not prot) mods)
      (if (stringp (car mods))
	  (let ((s (car mods)))
	    (setq prot
		  ;; A few silly defaults to get things started.
		  (cond ((or (string= s "public")
			     (string= s "extern")
			     (string= s "export"))
			 'public)
			((string= s "private")
			 'private)
			((string= s "protected")
			 'protected)
			((string= s "package")
			 'package)
			))))
      (setq mods (cdr mods)))
    prot))

(defun semantic-tag-package-protected-p (tag &optional parent currentpackage)
  "Non-nil if TAG is not available via package access control.
For languages (such as Java) where a method is package protected,
this method will return nil if TAG, as found in PARENT is available
for access from a file in CURRENTPACKAGE.
If TAG is not protected by PACKAGE, also return t.  Use
`semantic-tag-protected-p' instead.
If PARENT is not provided, it will be derived when passed to
`semantic-tag-protection'.
If CURRENTPACKAGE is not provided, it will be derived from the current
buffer."
  (let ((tagpro (semantic-tag-protection tag parent)))
    (if (not (eq tagpro 'package))
	t ;; protected

      ;; package protection, so check currentpackage.
      ;; Deriving the package is better from the parent, as TAG is
      ;; probably a field or method.
      (if (not currentpackage)
	  (setq currentpackage (semantic-tag-full-package nil (current-buffer))))
      (let ((tagpack (semantic-tag-full-package (or parent tag))))
	(if (string= currentpackage tagpack)
	    nil
	  t)) )))

(defun semantic-tag-protected-p (tag protection &optional parent)
  "Non-nil if TAG is protected.
PROTECTION is a symbol which can be returned by the method
`semantic-tag-protection'.
PARENT is the parent data type which contains TAG.

For these PROTECTIONs, true is returned if TAG is:
@table @asis
@item nil
  Always true.
@item  private
  True if nil.
@item protected
  True if private or nil.
@item public
  True if private, protected, or nil.
@end table"
  (if (null protection)
      t
    (let ((tagpro (semantic-tag-protection tag parent)))
      (or (and (eq protection 'private)
	       (null tagpro))
	  (and (eq protection 'protected)
	       (or (null tagpro)
		   (eq tagpro 'private)))
	  (and (eq protection 'public)
	       (not (eq tagpro 'public)))))
    ))

(define-overloadable-function semantic-tag-abstract-p (tag &optional parent)
  "Return non nil if TAG is abstract.
Optional PARENT is the parent tag of TAG.
In UML, abstract methods and classes have special meaning and behavior
in how methods are overridden.  In UML, abstract methods are italicized.

The default behavior (if not overridden with `tag-abstract-p'
is to return true if `abstract' is in the type modifiers.")

(make-obsolete-overload 'semantic-nonterminal-abstract
                        'semantic-tag-abstract-p "23.2")

(defun semantic-tag-abstract-p-default (tag &optional parent)
  "Return non-nil if TAG is abstract as a child of PARENT default action.
See `semantic-tag-abstract-p'."
  (let ((mods (semantic-tag-modifiers tag))
	(abs nil))
    (while (and (not abs) mods)
      (if (stringp (car mods))
	  (setq abs (or (string= (car mods) "abstract")
			(string= (car mods) "virtual"))))
      (setq mods (cdr mods)))
    abs))

(define-overloadable-function semantic-tag-leaf-p (tag &optional parent)
  "Return non nil if TAG is leaf.
Optional PARENT is the parent tag of TAG.
In UML, leaf methods and classes have special meaning and behavior.

The default behavior (if not overridden with `tag-leaf-p'
is to return true if `leaf' is in the type modifiers.")

(make-obsolete-overload 'semantic-nonterminal-leaf
                        'semantic-tag-leaf-p "23.2")

(defun semantic-tag-leaf-p-default (tag &optional parent)
  "Return non-nil if TAG is leaf as a child of PARENT default action.
See `semantic-tag-leaf-p'."
  (let ((mods (semantic-tag-modifiers tag))
	(leaf nil))
    (while (and (not leaf) mods)
      (if (stringp (car mods))
	  ;; Use java FINAL as example default.  There is none
	  ;; for C/C++
	  (setq leaf (string= (car mods) "final")))
      (setq mods (cdr mods)))
    leaf))

(define-overloadable-function semantic-tag-static-p (tag &optional parent)
  "Return non nil if TAG is static.
Optional PARENT is the parent tag of TAG.
In UML, static methods and attributes mean that they are allocated
in the parent class, and are not instance specific.
UML notation specifies that STATIC entries are underlined.")

(defun semantic-tag-static-p-default (tag &optional parent)
  "Return non-nil if TAG is static as a child of PARENT default action.
See `semantic-tag-static-p'."
  (let ((mods (semantic-tag-modifiers tag))
	(static nil))
    (while (and (not static) mods)
      (if (stringp (car mods))
	  (setq static (string= (car mods) "static")))
      (setq mods (cdr mods)))
    static))

;;;###autoload
(define-overloadable-function semantic-tag-prototype-p (tag)
  "Return non nil if TAG is a prototype.
For some languages, such as C, a prototype is a declaration of
something without an implementation."
  )

(defun semantic-tag-prototype-p-default (tag)
  "Non-nil if TAG is a prototype."
  (let ((p (semantic-tag-get-attribute tag :prototype-flag)))
    (cond
     ;; Trust the parser author.
     (p p)
     ;; Empty types might be a prototype.
     ;; @todo - make this better.
     ((eq (semantic-tag-class tag) 'type)
      (not (semantic-tag-type-members tag)))
     ;; No other heuristics.
     (t nil))
    ))

(provide 'semantic/tag-ls)

;; Local variables:
;; generated-autoload-file: "loaddefs.el"
;; generated-autoload-load-name: "semantic/tag-ls"
;; End:

;;; semantic/tag-ls.el ends here
