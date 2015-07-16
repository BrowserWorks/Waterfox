;;; cus-face.el --- customization support for faces
;;
;; Copyright (C) 1996-1997, 1999-2014 Free Software Foundation, Inc.
;;
;; Author: Per Abrahamsen <abraham@dina.kvl.dk>
;; Keywords: help, faces
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
;;
;; See `custom.el'.

;;; Code:

(defalias 'custom-facep 'facep)

;;; Declaring a face.

(defun custom-declare-face (face spec doc &rest args)
  "Like `defface', but with FACE evaluated as a normal argument."
  (unless (get face 'face-defface-spec)
    (face-spec-set face (purecopy spec) 'face-defface-spec)
    (push (cons 'defface face) current-load-list)
    (when doc
      (set-face-documentation face (purecopy doc)))
    (custom-handle-all-keywords face args 'custom-face)
    (run-hooks 'custom-define-hook))
  face)

;;; Face attributes.

(defconst custom-face-attributes
  '((:family
     (string :tag "Font Family"
	     :help-echo "Font family or fontset alias name."))

    (:foundry
     (string :tag "Font Foundry"
	     :help-echo "Font foundry name."))

    (:width
     (choice :tag "Width"
	     :help-echo "Font width."
	     :value normal		; default
	     (const :tag "compressed" condensed)
	     (const :tag "condensed" condensed)
	     (const :tag "demiexpanded" semi-expanded)
	     (const :tag "expanded" expanded)
	     (const :tag "extracondensed" extra-condensed)
	     (const :tag "extraexpanded" extra-expanded)
	     (const :tag "medium" normal)
	     (const :tag "narrow" condensed)
	     (const :tag "normal" normal)
	     (const :tag "regular" normal)
	     (const :tag "semicondensed" semi-condensed)
	     (const :tag "semiexpanded" semi-expanded)
	     (const :tag "ultracondensed" ultra-condensed)
	     (const :tag "ultraexpanded" ultra-expanded)
	     (const :tag "wide" extra-expanded)))

    (:height
     (choice :tag "Height"
	     :help-echo "Face's font height."
	     :value 1.0			; default
	     (integer :tag "Height in 1/10 pt")
	     (number :tag "Scale" 1.0)))

    (:weight
     (choice :tag "Weight"
	     :help-echo "Font weight."
	     :value normal		; default
	     (const :tag "black" ultra-bold)
	     (const :tag "bold" bold)
	     (const :tag "book" semi-light)
	     (const :tag "demibold" semi-bold)
	     (const :tag "extralight" extra-light)
	     (const :tag "extrabold" extra-bold)
	     (const :tag "heavy" extra-bold)
	     (const :tag "light" light)
	     (const :tag "medium" normal)
	     (const :tag "normal" normal)
	     (const :tag "regular" normal)
	     (const :tag "semibold" semi-bold)
	     (const :tag "semilight" semi-light)
	     (const :tag "ultralight" ultra-light)
	     (const :tag "ultrabold" ultra-bold)
	     (const :tag "thin" thin)))

    (:slant
     (choice :tag "Slant"
	     :help-echo "Font slant."
	     :value normal		; default
	     (const :tag "italic" italic)
	     (const :tag "oblique" oblique)
	     (const :tag "normal" normal)
	     (const :tag "roman" roman)))

    (:underline
     (choice :tag "Underline"
	     :help-echo "Control text underlining."
	     (const :tag "Off" nil)
	     (list :tag "On"
		   :value (:color foreground-color :style line)
		   (const :format "" :value :color)
		   (choice :tag "Color"
			   (const :tag "Foreground Color" foreground-color)
			   color)
		   (const :format "" :value :style)
		   (choice :tag "Style"
			   (const :tag "Line" line)
			   (const :tag "Wave" wave))))
     ;; filter to make value suitable for customize
     (lambda (real-value)
       (and real-value
	    (let ((color
		   (or (and (consp real-value) (plist-get real-value :color))
		       (and (stringp real-value) real-value)
		       'foreground-color))
		  (style
		   (or (and (consp real-value) (plist-get real-value :style))
		       'line)))
	      (list :color color :style style))))
     ;; filter to make customized-value suitable for storing
     (lambda (cus-value)
       (and cus-value
	    (let ((color (plist-get cus-value :color))
		  (style (plist-get cus-value :style)))
	      (cond ((eq style 'line)
		     ;; Use simple value for default style
		     (if (eq color 'foreground-color) t color))
		    (t
		     `(:color ,color :style ,style)))))))

    (:overline
     (choice :tag "Overline"
	     :help-echo "Control text overlining."
	     (const :tag "Off" nil)
	     (const :tag "On" t)
	     (color :tag "Colored")))

    (:strike-through
     (choice :tag "Strike-through"
	     :help-echo "Control text strike-through."
	     (const :tag "Off" nil)
	     (const :tag "On" t)
	     (color :tag "Colored")))

    (:box
     ;; Fixme: this can probably be done better.
     (choice :tag "Box around text"
	     :help-echo "Control box around text."
	     (const :tag "Off" nil)
	     (list :tag "Box"
		   :value (:line-width 2 :color "grey75" :style released-button)
		   (const :format "" :value :line-width)
		   (integer :tag "Width")
		   (const :format "" :value :color)
		   (choice :tag "Color" (const :tag "*" nil) color)
		   (const :format "" :value :style)
		   (choice :tag "Style"
			   (const :tag "Raised" released-button)
			   (const :tag "Sunken" pressed-button)
			   (const :tag "None" nil))))
     ;; filter to make value suitable for customize
     (lambda (real-value)
       (and real-value
	    (let ((lwidth
		   (or (and (consp real-value)
			    (plist-get real-value :line-width))
		       (and (integerp real-value) real-value)
		       1))
		  (color
		   (or (and (consp real-value) (plist-get real-value :color))
		       (and (stringp real-value) real-value)
		       nil))
		  (style
		   (and (consp real-value) (plist-get real-value :style))))
	      (list :line-width lwidth :color color :style style))))
     ;; filter to make customized-value suitable for storing
     (lambda (cus-value)
       (and cus-value
	    (let ((lwidth (plist-get cus-value :line-width))
		  (color (plist-get cus-value :color))
		  (style (plist-get cus-value :style)))
	      (cond ((and (null color) (null style))
		     lwidth)
		    ((and (null lwidth) (null style))
		     ;; actually can't happen, because LWIDTH is always an int
		     color)
		    (t
		     ;; Keep as a plist, but remove null entries
		     (nconc (and lwidth `(:line-width ,lwidth))
			    (and color  `(:color ,color))
			    (and style  `(:style ,style)))))))))

    (:inverse-video
     (choice :tag "Inverse-video"
	     :help-echo "Control whether text should be in inverse-video."
	     (const :tag "Off" nil)
	     (const :tag "On" t)))

    (:foreground
     (color :tag "Foreground"
	    :help-echo "Set foreground color (name or #RRGGBB hex spec)."))

    (:distant-foreground
     (color :tag "Distant Foreground"
	    :help-echo "Set distant foreground color (name or #RRGGBB hex spec)."))

    (:background
     (color :tag "Background"
	    :help-echo "Set background color (name or #RRGGBB hex spec)."))

    (:stipple
     (choice :tag "Stipple"
	     :help-echo "Background bit-mask"
	     (const :tag "None" nil)
	     (file :tag "File"
		   :help-echo "Name of bitmap file."
		   :must-match t)))

    (:inherit
     (repeat :tag "Inherit"
	     :help-echo "List of faces to inherit attributes from."
	     (face :Tag "Face" default))
     ;; filter to make value suitable for customize
     (lambda (real-value)
       (cond ((or (null real-value) (eq real-value 'unspecified))
	      nil)
	     ((symbolp real-value)
	      (list real-value))
	     (t
	      real-value)))
     ;; filter to make customized-value suitable for storing
     (lambda (cus-value)
       (if (and (consp cus-value) (null (cdr cus-value)))
	   (car cus-value)
	 cus-value))))

  "Alist of face attributes.

The elements are of the form (KEY TYPE PRE-FILTER POST-FILTER),
where KEY is the name of the attribute, TYPE is a widget type for
editing the attribute, PRE-FILTER is a function to make the attribute's
value suitable for the customization widget, and POST-FILTER is a
function to make the customized value suitable for storing.  PRE-FILTER
and POST-FILTER are optional.

The PRE-FILTER should take a single argument, the attribute value as
stored, and should return a value for customization (using the
customization type TYPE).

The POST-FILTER should also take a single argument, the value after
being customized, and should return a value suitable for setting the
given face attribute.")

(defun custom-face-attributes-get (face frame)
  "For FACE on FRAME, return an alternating list describing its attributes.
The list has the form (KEYWORD VALUE KEYWORD VALUE...).
Each keyword should be listed in `custom-face-attributes'.

If FRAME is nil, use the global defaults for FACE."
  (let ((attrs custom-face-attributes)
	plist)
    (while attrs
      (let* ((attribute (car (car attrs)))
	     (value (face-attribute face attribute frame)))
	(setq attrs (cdr attrs))
	(unless (or (eq value 'unspecified)
		    (and (null value) (memq attribute '(:inherit))))
	  (setq plist (cons attribute (cons value plist))))))
    plist))

;;; Initializing.

(defun custom-set-faces (&rest args)
  "Apply a list of face specs for user customizations.
This works by calling `custom-theme-set-faces' for the `user'
theme, a special theme referring to settings made via Customize.
The arguments should be a list where each entry has the form:

  (FACE SPEC [NOW [COMMENT]])

See the documentation of `custom-theme-set-faces' for details."
  (apply 'custom-theme-set-faces 'user args))

(defun custom-theme-set-faces (theme &rest args)
  "Apply a list of face specs associated with theme THEME.
THEME should be a theme name (a symbol).  The special theme named
`user' refers to user settings applied via Customize.

The remaining ARGS should be a list where each entry is a list of
the form:

  (FACE SPEC [NOW [COMMENT]])

FACE should be a face name (a symbol).  If FACE is a face alias,
the setting refers to the parent face.

SPEC should be a face spec.  For details, see `defface'.

NOW, if present and non-nil, forces the face settings to take
immediate effect in the Emacs display; in particular, FACE is
initialized as a face if it is not yet one.  If NOW is omitted or
nil, the caller is responsible for making the settings take
effect later, by calling `custom-theme-recalc-face' or
`face-spec-recalc'.

COMMENT is a string comment about FACE.

This function works by calling `custom-push-theme' to record each
SPEC in each FACE's `theme-face' property, and in THEME's
`theme-settings' property.  If FACE has not already been
customized, it also stores SPEC in the `saved-face' property.

If THEME has a non-nil `theme-immediate' property, this is
equivalent to providing the NOW argument to all faces in the
argument list."
  (custom-check-theme theme)
  (let ((immediate (get theme 'theme-immediate)))
    (dolist (entry args)
      (unless (listp entry)
	(error "Incompatible Custom theme spec"))
      (let ((face (car entry))
	    (spec (nth 1 entry)))
	;; If FACE is actually an alias, customize the face it
	;; is aliased to.
	(if (get face 'face-alias)
	    (setq face (get face 'face-alias)))
	(if custom--inhibit-theme-enable
	    ;; Just update theme settings.
	    (custom-push-theme 'theme-face face theme 'set spec)
	  ;; Update theme settings and set the face spec.
	  (let ((now (nth 2 entry))
		(comment (nth 3 entry))
		(oldspec (get face 'theme-face)))
	    (when (not (and oldspec (eq 'user (caar oldspec))))
	      (put face 'saved-face spec)
	      (put face 'saved-face-comment comment))
	    (custom-push-theme 'theme-face face theme 'set spec)
	    (when (or now immediate)
	      (put face 'force-face (if now 'rogue 'immediate)))
	    (when (or now immediate (facep face))
	      (put face 'face-comment comment)
	      (face-spec-set face spec t))))))))

;; XEmacs compatibility function.  In XEmacs, when you reset a Custom
;; Theme, you have to specify the theme to reset it to.  We just apply
;; the next theme.
(defun custom-theme-reset-faces (theme &rest args)
  "Reset the specs in THEME of some faces to their specs in other themes.
Each of the arguments ARGS has this form:

    (FACE IGNORED)

This means reset FACE.  The argument IGNORED is ignored."
  (custom-check-theme theme)
  (dolist (arg args)
    (custom-push-theme 'theme-face (car arg) theme 'reset)))

(defun custom-reset-faces (&rest args)
  "Reset the specs of some faces to their specs in specified themes.
This creates settings in the `user' theme.

Each of the arguments ARGS has this form:

    (FACE FROM-THEME)

This means reset FACE to its value in FROM-THEME."
  (apply 'custom-theme-reset-faces 'user args))

;;; The End.

(provide 'cus-face)

;;; cus-face.el ends here
