;;; eieio-opt.el -- eieio optional functions (debug, printing, speedbar)

;; Copyright (C) 1996, 1998-2003, 2005, 2008-2014 Free Software
;; Foundation, Inc.

;; Author: Eric M. Ludlam <zappo@gnu.org>
;; Keywords: OO, lisp
;; Package: eieio

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
;;   This contains support functions to eieio.  These functions contain
;; some small class browser and class printing functions.
;;

(require 'eieio)
(require 'find-func)
(require 'speedbar)
(require 'help-mode)

;;; Code:
;;;###autoload
(defun eieio-browse (&optional root-class)
  "Create an object browser window to show all objects.
If optional ROOT-CLASS, then start with that, otherwise start with
variable `eieio-default-superclass'."
  (interactive (if current-prefix-arg
		   (list (read (completing-read "Class: "
						(eieio-build-class-alist)
						nil t)))
		 nil))
  (if (not root-class) (setq root-class 'eieio-default-superclass))
  (eieio--check-type class-p root-class)
  (display-buffer (get-buffer-create "*EIEIO OBJECT BROWSE*") t)
  (with-current-buffer (get-buffer "*EIEIO OBJECT BROWSE*")
    (erase-buffer)
    (goto-char 0)
    (eieio-browse-tree root-class "" "")
    ))

(defun eieio-browse-tree (this-root prefix ch-prefix)
  "Recursively draw the children of the given class on the screen.
Argument THIS-ROOT is the local root of the tree.
Argument PREFIX is the character prefix to use.
Argument CH-PREFIX is another character prefix to display."
  (eieio--check-type class-p this-root)
  (let ((myname (symbol-name this-root))
	(chl (eieio--class-children (class-v this-root)))
	(fprefix (concat ch-prefix "  +--"))
	(mprefix (concat ch-prefix "  |  "))
	(lprefix (concat ch-prefix "     ")))
    (insert prefix myname "\n")
    (while (cdr chl)
      (eieio-browse-tree (car chl) fprefix mprefix)
      (setq chl (cdr chl)))
    (if chl
	(eieio-browse-tree (car chl) fprefix lprefix))
    ))

;;; CLASS COMPLETION / DOCUMENTATION

;;;###autoload
(defun eieio-help-class (class)
  "Print help description for CLASS.
If CLASS is actually an object, then also display current values of that object."
  ;; Header line
  (prin1 class)
  (insert " is a"
	  (if (class-option class :abstract)
	      "n abstract"
	    "")
	  " class")
  (let ((location (get class 'class-location)))
    (when location
      (insert " in `")
      (help-insert-xref-button
       (file-name-nondirectory location)
       'eieio-class-def class location)
      (insert "'")))
  (insert ".\n")
  ;; Parents
  (let ((pl (eieio-class-parents class))
	cur)
    (when pl
      (insert " Inherits from ")
      (while (setq cur (pop pl))
	(insert "`")
	(help-insert-xref-button (symbol-name cur)
				 'help-function cur)
	(insert (if pl "', " "'")))
      (insert ".\n")))
  ;; Children
  (let ((ch (eieio-class-children class))
	cur)
    (when ch
      (insert " Children ")
      (while (setq cur (pop ch))
	(insert "`")
	(help-insert-xref-button (symbol-name cur)
				 'help-function cur)
	(insert (if ch "', " "'")))
      (insert ".\n")))
  ;; System documentation
  (let ((doc (documentation-property class 'variable-documentation)))
    (when doc
      (insert "\n" doc "\n\n")))
  ;; Describe all the slots in this class.
  (eieio-help-class-slots class)
  ;; Describe all the methods specific to this class.
  (let ((methods (eieio-all-generic-functions class))
	(type [":STATIC" ":BEFORE" ":PRIMARY" ":AFTER"])
	counter doc)
    (when methods
      (insert (propertize "Specialized Methods:\n\n" 'face 'bold))
      (while methods
	(setq doc (eieio-method-documentation (car methods) class))
	(insert "`")
	(help-insert-xref-button (symbol-name (car methods))
				 'help-function (car methods))
	(insert "'")
	(if (not doc)
	    (insert "  Undocumented")
	  (setq counter 0)
	  (dolist (cur doc)
	    (when cur
	      (insert " " (aref type counter) " "
		      (prin1-to-string (car cur) (current-buffer))
		      "\n"
		      (or (cdr cur) "")))
	    (setq counter (1+ counter))))
	(insert "\n\n")
	(setq methods (cdr methods))))))

(defun eieio-help-class-slots (class)
  "Print help description for the slots in CLASS.
Outputs to the current buffer."
  (let* ((cv (class-v class))
	 (docs   (eieio--class-public-doc cv))
	 (names  (eieio--class-public-a cv))
	 (deflt  (eieio--class-public-d cv))
	 (types  (eieio--class-public-type cv))
	 (publp (eieio--class-public-printer cv))
	 (i      0)
	 (prot   (eieio--class-protection cv))
	 )
    (insert (propertize "Instance Allocated Slots:\n\n"
			'face 'bold))
    (while names
      (insert
       (concat
	(when (car prot)
	  (propertize "Private " 'face 'bold))
	(propertize "Slot: " 'face 'bold)
	(prin1-to-string (car names))
	(unless (eq (aref types i) t)
	  (concat "    type = "
		  (prin1-to-string (aref types i))))
	(unless (eq (car deflt) eieio-unbound)
	  (concat "    default = "
		  (prin1-to-string (car deflt))))
	(when (car publp)
	  (concat "    printer = "
		  (prin1-to-string (car publp))))
	(when (car docs)
	  (concat "\n  " (car docs) "\n"))
	"\n"))
      (setq names (cdr names)
	    docs (cdr docs)
	    deflt (cdr deflt)
	    publp (cdr publp)
	    prot (cdr prot)
	    i (1+ i)))
    (setq docs  (eieio--class-class-allocation-doc cv)
	  names (eieio--class-class-allocation-a cv)
	  types (eieio--class-class-allocation-type cv)
	  i     0
	  prot  (eieio--class-class-allocation-protection cv))
    (when names
      (insert (propertize "\nClass Allocated Slots:\n\n" 'face 'bold)))
    (while names
      (insert
       (concat
	(when (car prot)
	  "Private ")
	"Slot: "
	(prin1-to-string (car names))
	(unless (eq (aref types i) t)
	  (concat "    type = "
		  (prin1-to-string (aref types i))))
	(condition-case nil
	    (let ((value (eieio-oref class (car names))))
	      (concat "   value = "
		      (prin1-to-string value)))
	  (error nil))
	(when (car docs)
	  (concat "\n\n " (car docs) "\n"))
	"\n"))
      (setq names (cdr names)
	    docs (cdr docs)
	    prot (cdr prot)
	    i (1+ i)))))

(defun eieio-build-class-list (class)
  "Return a list of all classes that inherit from CLASS."
  (if (class-p class)
      (apply #'append
	     (mapcar
	      (lambda (c)
		(append (list c) (eieio-build-class-list c)))
	      (eieio-class-children-fast class)))
    (list class)))

(defun eieio-build-class-alist (&optional class instantiable-only buildlist)
  "Return an alist of all currently active classes for completion purposes.
Optional argument CLASS is the class to start with.
If INSTANTIABLE-ONLY is non nil, only allow names of classes which
are not abstract, otherwise allow all classes.
Optional argument BUILDLIST is more list to attach and is used internally."
  (let* ((cc (or class eieio-default-superclass))
	 (sublst (eieio--class-children (class-v cc))))
    (unless (assoc (symbol-name cc) buildlist)
      (when (or (not instantiable-only) (not (class-abstract-p cc)))
	(setq buildlist (cons (cons (symbol-name cc) 1) buildlist))))
    (while sublst
      (setq buildlist (eieio-build-class-alist
		       (car sublst) instantiable-only buildlist))
      (setq sublst (cdr sublst)))
    buildlist))

(defvar eieio-read-class nil
  "History of the function `eieio-read-class' prompt.")

(defun eieio-read-class (prompt &optional histvar instantiable-only)
  "Return a class chosen by the user using PROMPT.
Optional argument HISTVAR is a variable to use as history.
If INSTANTIABLE-ONLY is non nil, only allow names of classes which
are not abstract."
  (intern (completing-read prompt (eieio-build-class-alist nil instantiable-only)
			   nil t nil
			   (or histvar 'eieio-read-class))))

(defun eieio-read-subclass (prompt class &optional histvar instantiable-only)
  "Return a class chosen by the user using PROMPT.
CLASS is the base class, and completion occurs across all subclasses.
Optional argument HISTVAR is a variable to use as history.
If INSTANTIABLE-ONLY is non nil, only allow names of classes which
are not abstract."
  (intern (completing-read prompt
			   (eieio-build-class-alist class instantiable-only)
			   nil t nil
			   (or histvar 'eieio-read-class))))

;;; METHOD COMPLETION / DOC

(define-button-type 'eieio-method-def
  :supertype 'help-xref
  'help-function (lambda (class method file)
		   (eieio-help-find-method-definition class method file))
  'help-echo (purecopy "mouse-2, RET: find method's definition"))

(define-button-type 'eieio-class-def
  :supertype 'help-xref
  'help-function (lambda (class file)
		   (eieio-help-find-class-definition class file))
  'help-echo (purecopy "mouse-2, RET: find class definition"))

;;;###autoload
(defun eieio-help-constructor (ctr)
  "Describe CTR if it is a class constructor."
  (when (class-p ctr)
    (erase-buffer)
    (let ((location (get ctr 'class-location))
	  (def (symbol-function ctr)))
      (goto-char (point-min))
      (prin1 ctr)
      (insert (format " is an %s object constructor function"
		      (if (autoloadp def)
			  "autoloaded"
			"")))
      (when (and (autoloadp def)
		 (null location))
	(setq location
	      (find-lisp-object-file-name ctr def)))
      (when location
	(insert " in `")
	(help-insert-xref-button
	 (file-name-nondirectory location)
	 'eieio-class-def ctr location)
	(insert "'"))
      (insert ".\nCreates an object of class " (symbol-name ctr) ".")
      (goto-char (point-max))
      (if (autoloadp def)
	  (insert "\n\n[Class description not available until class definition is loaded.]\n")
	(save-excursion
	  (insert (propertize "\n\nClass description:\n" 'face 'bold))
	  (eieio-help-class ctr))
	))))


;;;###autoload
(defun eieio-help-generic (generic)
  "Describe GENERIC if it is a generic function."
  (when (and (symbolp generic) (generic-p generic))
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward " in `.+'.$" nil t)
	(replace-match ".")))
    (save-excursion
      (insert "\n\nThis is a generic function"
	      (cond
	       ((and (generic-primary-only-p generic)
		     (generic-primary-only-one-p generic))
		" with only one primary method")
	       ((generic-primary-only-p generic)
		" with only primary methods")
	       (t ""))
	      ".\n\n")
      (insert (propertize "Implementations:\n\n" 'face 'bold))
      (let ((i 4)
	    (prefix [ ":STATIC" ":BEFORE" ":PRIMARY" ":AFTER" ] ))
	;; Loop over fanciful generics
	(while (< i 7)
	  (let ((gm (aref (get generic 'eieio-method-tree) i)))
	    (when gm
	      (insert "Generic "
		      (aref prefix (- i 3))
		      "\n"
		      (or (nth 2 gm) "Undocumented")
		      "\n\n")))
	  (setq i (1+ i)))
	(setq i 0)
	;; Loop over defined class-specific methods
	(while (< i 4)
	  (let* ((gm (reverse (aref (get generic 'eieio-method-tree) i)))
		 cname location)
	    (while gm
	      (setq cname (caar gm))
	      (insert "`")
	      (help-insert-xref-button (symbol-name cname)
				       'help-variable cname)
	      (insert "' " (aref prefix i) " ")
	      ;; argument list
	      (let* ((func (cdr (car gm)))
		     (arglst (eieio-lambda-arglist func)))
		(prin1 arglst (current-buffer)))
	      (insert "\n"
		      (or (documentation (cdr (car gm)))
			  "Undocumented"))
	      ;; Print file location if available
	      (when (and (setq location (get generic 'method-locations))
			 (setq location (assoc cname location)))
		(setq location (cadr location))
		(insert "\n\nDefined in `")
		(help-insert-xref-button
		 (file-name-nondirectory location)
		 'eieio-method-def cname generic location)
		(insert "'\n"))
	      (setq gm (cdr gm))
	      (insert "\n")))
	  (setq i (1+ i)))))))

(defun eieio-lambda-arglist (func)
  "Return the argument list of FUNC, a function body."
  (if (symbolp func) (setq func (symbol-function func)))
  (if (byte-code-function-p func)
      (eieio-compiled-function-arglist func)
    (car (cdr func))))

(defun eieio-all-generic-functions (&optional class)
  "Return a list of all generic functions.
Optional CLASS argument returns only those functions that contain
methods for CLASS."
  (let ((l nil) tree (cn (if class (symbol-name class) nil)))
    (mapatoms
     (lambda (symbol)
       (setq tree (get symbol 'eieio-method-obarray))
       (if tree
	   (progn
	     ;; A symbol might be interned for that class in one of
	     ;; these three slots in the method-obarray.
	     (if (or (not class)
		     (fboundp (intern-soft cn (aref tree 0)))
		     (fboundp (intern-soft cn (aref tree 1)))
		     (fboundp (intern-soft cn (aref tree 2))))
		 (setq l (cons symbol l)))))))
    l))

(defun eieio-method-documentation (generic class)
  "Return a list of the specific documentation of GENERIC for CLASS.
If there is not an explicit method for CLASS in GENERIC, or if that
function has no documentation, then return nil."
  (let ((tree (get generic 'eieio-method-obarray))
	(cn (symbol-name class))
	before primary after)
    (if (not tree)
	nil
      ;; A symbol might be interned for that class in one of
      ;; these three slots in the method-obarray.
      (setq before (intern-soft cn (aref tree 0))
	    primary (intern-soft cn (aref tree 1))
	    after (intern-soft cn (aref tree 2)))
      (if (not (or (fboundp before)
		   (fboundp primary)
		   (fboundp after)))
	  nil
	(list (if (fboundp before)
		  (cons (eieio-lambda-arglist before)
			(documentation before))
		nil)
	      (if (fboundp primary)
		  (cons (eieio-lambda-arglist primary)
			(documentation primary))
		nil)
	      (if (fboundp after)
		  (cons (eieio-lambda-arglist after)
			(documentation after))
		nil))))))

(defvar eieio-read-generic nil
  "History of the `eieio-read-generic' prompt.")

(defun eieio-read-generic-p (fn)
  "Function used in function `eieio-read-generic'.
This is because `generic-p' is a macro.
Argument FN is the function to test."
  (generic-p fn))

(defun eieio-read-generic (prompt &optional historyvar)
  "Read a generic function from the minibuffer with PROMPT.
Optional argument HISTORYVAR is the variable to use as history."
  (intern (completing-read prompt obarray 'eieio-read-generic-p
			   t nil (or historyvar 'eieio-read-generic))))

;;; METHOD STATS
;;
;; Dump out statistics about all the active methods in a session.
(defun eieio-display-method-list ()
  "Display a list of all the methods and what features are used."
  (interactive)
  (let* ((meth1 (eieio-all-generic-functions))
	 (meth (sort meth1 (lambda (a b)
			     (string< (symbol-name a)
				      (symbol-name b)))))
	 (buff (get-buffer-create "*EIEIO Method List*"))
	 (methidx 0)
	 (standard-output buff)
	 (slots '(method-static
		  method-before
		  method-primary
		  method-after
		  method-generic-before
		  method-generic-primary
		  method-generic-after))
	 (slotn '("static"
		  "before"
		  "primary"
		  "after"
		  "G bef"
		  "G prim"
		  "G aft"))
	 (idxarray (make-vector (length slots) 0))
	 (primaryonly 0)
	 (oneprimary 0)
	 )
    (switch-to-buffer-other-window buff)
    (erase-buffer)
    (dolist (S slotn)
      (princ S)
      (princ "\t")
      )
    (princ "Method Name")
    (terpri)
    (princ "--------------------------------------------------------------------")
    (terpri)
    (dolist (M meth)
      (let ((mtree (get M 'eieio-method-tree))
	    (P nil) (numP)
	    (!P nil))
	(dolist (S slots)
	  (let ((num (length (aref mtree (symbol-value S)))))
	    (aset idxarray (symbol-value S)
		  (+ num (aref idxarray (symbol-value S))))
	    (prin1 num)
	    (princ "\t")
	    (when (< 0 num)
	      (if (eq S 'method-primary)
		  (setq P t numP num)
		(setq !P t)))
	    ))
	;; Is this a primary-only impl method?
	(when (and P (not !P))
	  (setq primaryonly (1+ primaryonly))
	  (when (= numP 1)
	    (setq oneprimary (1+ oneprimary))
	    (princ "*"))
	  (princ "* ")
	  )
	(prin1 M)
	(terpri)
	(setq methidx (1+ methidx))
	)
      )
    (princ "--------------------------------------------------------------------")
    (terpri)
    (dolist (S slots)
      (prin1 (aref idxarray (symbol-value S)))
      (princ "\t")
      )
    (prin1 methidx)
    (princ " Total symbols")
    (terpri)
    (dolist (S slotn)
      (princ S)
      (princ "\t")
      )
    (terpri)
    (terpri)
    (princ "Methods Primary Only: ")
    (prin1 primaryonly)
    (princ "\t")
    (princ (format "%d" (* (/ (float primaryonly) (float methidx)) 100)))
    (princ "% of total methods")
    (terpri)
    (princ "Only One Primary Impl: ")
    (prin1 oneprimary)
    (princ "\t")
    (princ (format "%d" (* (/ (float oneprimary) (float primaryonly)) 100)))
    (princ "% of total primary methods")
    (terpri)
    ))

;;; HELP AUGMENTATION
;;
(defun eieio-help-find-method-definition (class method file)
  (let ((filename (find-library-name file))
	location buf)
    (when (symbolp class)
      (setq class (symbol-name class)))
    (when (symbolp method)
      (setq method (symbol-name method)))
    (when (null filename)
      (error "Cannot find library %s" file))
    (setq buf (find-file-noselect filename))
    (with-current-buffer buf
      (goto-char (point-min))
      (when
	  (re-search-forward
	   ;; Regexp for searching methods.
	   (concat "(defmethod[ \t\r\n]+" method
		   "\\([ \t\r\n]+:[a-zA-Z]+\\)?"
		   "[ \t\r\n]+(\\s-*(\\(\\sw\\|\\s_\\)+\\s-+"
		   class
		   "\\s-*)")
	   nil t)
	(setq location (match-beginning 0))))
    (if (null location)
	(message "Unable to find location in file")
      (pop-to-buffer buf)
      (goto-char location)
      (recenter)
      (beginning-of-line))))

(defun eieio-help-find-class-definition (class file)
  (when (symbolp class)
    (setq class (symbol-name class)))
  (let ((filename (find-library-name file))
	location buf)
    (when (null filename)
      (error "Cannot find library %s" file))
    (setq buf (find-file-noselect filename))
    (with-current-buffer buf
      (goto-char (point-min))
      (when
	  (re-search-forward
	   ;; Regexp for searching a class.
	   (concat "(defclass[ \t\r\n]+" class "[ \t\r\n]+")
	   nil t)
	(setq location (match-beginning 0))))
    (if (null location)
	(message "Unable to find location in file")
      (pop-to-buffer buf)
      (goto-char location)
      (recenter)
      (beginning-of-line))))

;;; SPEEDBAR SUPPORT
;;

(defvar eieio-class-speedbar-key-map nil
  "Keymap used when working with a project in speedbar.")

(defun eieio-class-speedbar-make-map ()
  "Make a keymap for EIEIO under speedbar."
  (setq eieio-class-speedbar-key-map (speedbar-make-specialized-keymap))

  ;; General viewing stuff
  (define-key eieio-class-speedbar-key-map "\C-m" 'speedbar-edit-line)
  (define-key eieio-class-speedbar-key-map "+" 'speedbar-expand-line)
  (define-key eieio-class-speedbar-key-map "-" 'speedbar-contract-line)
  )

(if eieio-class-speedbar-key-map
    nil
  (if (not (featurep 'speedbar))
      (add-hook 'speedbar-load-hook (lambda ()
				      (eieio-class-speedbar-make-map)
				      (speedbar-add-expansion-list
				       '("EIEIO"
					 eieio-class-speedbar-menu
					 eieio-class-speedbar-key-map
					 eieio-class-speedbar))))
    (eieio-class-speedbar-make-map)
    (speedbar-add-expansion-list '("EIEIO"
				   eieio-class-speedbar-menu
				   eieio-class-speedbar-key-map
				   eieio-class-speedbar))))

(defvar eieio-class-speedbar-menu
  ()
  "Menu part in easymenu format used in speedbar while in `eieio' mode.")

(defun eieio-class-speedbar (dir-or-object depth)
  "Create buttons in speedbar that represents the current project.
DIR-OR-OBJECT is the object to expand, or nil, and DEPTH is the
current expansion depth."
  (when (eq (point-min) (point-max))
    ;; This function is only called once, to start the whole deal.
    ;; Create and expand the default object.
    (eieio-class-button eieio-default-superclass 0)
    (forward-line -1)
    (speedbar-expand-line)))

(defun eieio-class-button (class depth)
  "Draw a speedbar button at the current point for CLASS at DEPTH."
  (eieio--check-type class-p class)
  (let ((subclasses (eieio--class-children (class-v class))))
    (if subclasses
	(speedbar-make-tag-line 'angle ?+
				'eieio-sb-expand
				class
				(symbol-name class)
				'eieio-describe-class-sb
				class
				'speedbar-directory-face
				depth)
      (speedbar-make-tag-line 'angle ?  nil nil
			      (symbol-name class)
			      'eieio-describe-class-sb
			      class
			      'speedbar-directory-face
			      depth))))

(defun eieio-sb-expand (text class indent)
  "For button TEXT, expand CLASS at the current location.
Argument INDENT is the depth of indentation."
  (cond ((string-match "+" text)	;we have to expand this file
	 (speedbar-change-expand-button-char ?-)
	 (speedbar-with-writable
	   (save-excursion
	     (end-of-line) (forward-char 1)
	     (let ((subclasses (eieio--class-children (class-v class))))
	       (while subclasses
		 (eieio-class-button (car subclasses) (1+ indent))
		 (setq subclasses (cdr subclasses)))))))
	((string-match "-" text)	;we have to contract this node
	 (speedbar-change-expand-button-char ?+)
	 (speedbar-delete-subblock indent))
	(t (error "Ooops...  not sure what to do")))
  (speedbar-center-buffer-smartly))

(defun eieio-describe-class-sb (text token indent)
  "Describe the class TEXT in TOKEN.
INDENT is the current indentation level."
  (dframe-with-attached-buffer
   (describe-function token))
  (dframe-maybee-jump-to-attached-frame))

(provide 'eieio-opt)

;; Local variables:
;; generated-autoload-file: "eieio.el"
;; End:

;;; eieio-opt.el ends here
