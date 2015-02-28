;;; semantic/ede-grammar.el --- EDE support for Semantic Grammar Files

;; Copyright (C) 2003-2004, 2007-2013 Free Software Foundation, Inc.

;; Author: Eric M. Ludlam <zappo@gnu.org>
;; Keywords: project, make

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
;; Handle .by or .wy files.

(require 'semantic)
(require 'ede/proj)
(require 'ede/pmake)
(require 'ede/pconf)
(require 'ede/proj-elisp)
(require 'semantic/grammar)

;;; Code:
(defclass semantic-ede-proj-target-grammar (ede-proj-target-elisp)
  ((menu :initform nil)
   (keybindings :initform nil)
   (phony :initform t)
   (sourcetype :initform
	       (semantic-ede-source-grammar-wisent
		semantic-ede-source-grammar-bovine
		))
   (availablecompilers :initform
		       (semantic-ede-grammar-compiler-wisent
			semantic-ede-grammar-compiler-bovine
			))
   (aux-packages :initform '("semantic" "cedet-compat"))
   (pre-load-packages :initform '("cedet-compat" "semantic/grammar" "semantic/bovine/grammar" "semantic/wisent/grammar"))
   )
  "This target consists of a group of grammar files.
A grammar target consists of grammar files that build Emacs Lisp programs for
parsing different languages.")

(defmethod ede-proj-makefile-dependencies ((this semantic-ede-proj-target-grammar))
  "Return a string representing the dependencies for THIS.
Some compilers only use the first element in the dependencies, others
have a list of intermediates (object files), and others don't care.
This allows customization of how these elements appear.
For Emacs Lisp, return addsuffix command on source files."
  (let ((source (car (oref this source))))
    (cond
     ((string-match "\\.wy$" source)
      (format "$(addsuffix -wy.elc, $(basename $(%s)))"
	      (ede-proj-makefile-sourcevar this)))
     ((string-match "\\.by$" source)
      (format "$(addsuffix -by.elc, $(basename $(%s)))"
	      (ede-proj-makefile-sourcevar this))))))

(defvar semantic-ede-source-grammar-wisent
  (ede-sourcecode "semantic-ede-grammar-source-wisent"
		  :name "Wisent Grammar"
		  :sourcepattern "\\.wy$"
		  :garbagepattern '("*-wy.el")
		  )
  "Semantic Grammar source code definition for wisent.")

(defclass semantic-ede-grammar-compiler-class (ede-compiler)
  nil
  "Specialized compiler for semantic grammars.")

(defvar semantic-ede-grammar-compiler-wisent
  (semantic-ede-grammar-compiler-class
   "ede-emacs-wisent-compiler"
   :name "emacs"
   :variables '(("EMACS" . "emacs")
		("EMACSFLAGS" . "-batch --no-site-file --eval '(setq debug-on-error t)'")
		("require" . "$(foreach r,$(1),(require (quote $(r))))"))
   :rules (list (ede-makefile-rule
		 "elisp-inference-rule"
		 :target "%-wy.el"
		 :dependencies "%.wy"
		 :rules '("$(EMACS) $(EMACSFLAGS) $(addprefix -L ,$(LOADPATH)) \
--eval '(progn $(call require,$(PRELOADS)))' -f semantic-grammar-batch-build-packages $^")))
   :sourcetype '(semantic-ede-source-grammar-wisent)
   :objectextention "-wy.el"
   )
  "Compile Emacs Lisp programs.")


(defvar semantic-ede-source-grammar-bovine
  (ede-sourcecode "semantic-ede-grammar-source-bovine"
		  :name "Bovine Grammar"
		  :sourcepattern "\\.by$"
		  :garbagepattern '("*-by.el")
		  )
  "Semantic Grammar source code definition for the bovinator.")

(defvar semantic-ede-grammar-compiler-bovine
  (semantic-ede-grammar-compiler-class
   "ede-emacs-wisent-compiler"
   :name "emacs"
   :variables '(("EMACS" . "emacs")
		("EMACSFLAGS" . "-batch --no-site-file --eval '(setq debug-on-error t)'")
		("require" . "$(foreach r,$(1),(require (quote $(r))))"))
   :rules (list (ede-makefile-rule
		 "elisp-inference-rule"
		 :target "%-by.el"
		 :dependencies "%.by"
		 :rules '("$(EMACS) $(EMACSFLAGS) $(addprefix -L ,$(LOADPATH)) \
--eval '(progn $(call require,$(PRELOADS)))' -f semantic-grammar-batch-build-packages $^")))
   :sourcetype '(semantic-ede-source-grammar-bovine)
   :objectextention "-by.el"
   )
  "Compile Emacs Lisp programs.")

;;; Target options.
(defmethod ede-buffer-mine ((this semantic-ede-proj-target-grammar) buffer)
  "Return t if object THIS lays claim to the file in BUFFER.
Lays claim to all -by.el, and -wy.el files."
  ;; We need to be a little more careful than this, but at the moment it
  ;; is common to have only one target of this class per directory.
  (if (string-match "-[bw]y\\.elc?$" (buffer-file-name buffer))
      t
    (call-next-method) ; The usual thing.
    ))

(defmethod project-compile-target ((obj semantic-ede-proj-target-grammar))
  "Compile all sources in a Lisp target OBJ."
  (let* ((cb (current-buffer))
	 (proj (ede-target-parent obj))
	 (default-directory (oref proj directory))
	 (comp 0)
	 (utd 0))
    (mapc (lambda (src)
	    (with-current-buffer (find-file-noselect src)
	      (let* ((package (semantic-grammar-create-package))
		     (fname (progn (string-match ".*/\\(.+\\.el\\)" package)
				   (match-string 1 package)))
		     (src (with-current-buffer fname (buffer-file-name)))
		     (csrc (concat (file-name-sans-extension src) ".elc")))
		(if (< emacs-major-version 24)
		    ;; Does not have `byte-recompile-file'
		    (if (or (not (file-exists-p csrc))
			    (file-newer-than-file-p src csrc))
			(progn
			  (setq comp (1+ comp))
			  (byte-compile-file src))
		      (setq utd (1+ utd)))
		  ;; Emacs 24 and newer
		  (with-no-warnings
		    (if (eq (byte-recompile-file src nil 0) t)
			(setq comp (1+ comp))
		      (setq utd (1+ utd))))))))
	  (oref obj source))
    (message "All Semantic Grammar sources are up to date in %s" (object-name obj))
    (cons comp utd)))

;;; Makefile generation functions
;;
(defmethod ede-proj-makefile-sourcevar ((this semantic-ede-proj-target-grammar))
  "Return the variable name for THIS's sources."
  (cond ((ede-proj-automake-p)
	 (error "No Automake support for Semantic Grammars"))
	(t (concat (ede-pmake-varname this) "_SEMANTIC_GRAMMAR"))))

(defmethod ede-proj-makefile-insert-variables :AFTER ((this semantic-ede-proj-target-grammar))
  "Insert variables needed by target THIS."
  (ede-proj-makefile-insert-loadpath-items
   (ede-proj-elisp-packages-to-loadpath
    (list "eieio" "semantic" "inversion" "ede")))
  ;; eieio for object system needed in ede
  ;; semantic because it is
  ;; Inversion for versioning system.
  ;; ede for project regeneration
  (ede-pmake-insert-variable-shared
      (concat (ede-pmake-varname this) "_SEMANTIC_GRAMMAR_EL")
    (insert
     (mapconcat (lambda (src)
		  (with-current-buffer (find-file-noselect src)
		    (concat (semantic-grammar-package) ".el")))
		(oref this source)
		" ")))
  )

(defmethod ede-proj-makefile-insert-rules :after ((this semantic-ede-proj-target-grammar))
    "Insert rules needed by THIS target.
This raises `max-specpdl-size' and `max-lisp-eval-depth', which can be
needed for the compilation of the resulting parsers."
    (insert (format "%s: EMACSFLAGS+= --eval '(setq max-specpdl-size 1500 \
max-lisp-eval-depth 700)'\n"
		    (oref this name))))

(defmethod ede-proj-makefile-insert-dist-dependencies ((this semantic-ede-proj-target-grammar))
  "Insert dist dependencies, or intermediate targets.
This makes sure that all grammar lisp files are created before the dist
runs, so they are always up to date.
Argument THIS is the target that should insert stuff."
  (call-next-method)
  (insert " $(" (ede-pmake-varname this) "_SEMANTIC_GRAMMAR_EL)")
  )

;; (autoload 'ede-proj-target-elisp "ede/proj-elisp"
;;   "Target class for Emacs/Semantic grammar files." nil nil)

(ede-proj-register-target "semantic grammar"
			  semantic-ede-proj-target-grammar)

(provide 'semantic/ede-grammar)

;;; semantic/ede-grammar.el ends here
