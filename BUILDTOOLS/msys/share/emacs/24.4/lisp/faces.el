;;; faces.el --- Lisp faces

;; Copyright (C) 1992-1996, 1998-2014 Free Software Foundation, Inc.

;; Maintainer: emacs-devel@gnu.org
;; Keywords: internal
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

;;; Code:

(defcustom term-file-prefix (purecopy "term/")
  "If non-nil, Emacs startup performs terminal-specific initialization.
It does this by: (load (concat term-file-prefix (getenv \"TERM\")))

You may set this variable to nil in your init file if you do not wish
the terminal-initialization file to be loaded."
  :type '(choice (const :tag "No terminal-specific initialization" nil)
		 (string :tag "Name of directory with term files"))
  :group 'terminals)

(declare-function xw-defined-colors "term/common-win" (&optional frame))

(defvar help-xref-stack-item)

(defvar face-name-history nil
  "History list for some commands that read face names.
Maximum length of the history list is determined by the value
of `history-length', which see.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Font selection.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup font-selection nil
  "Influencing face font selection."
  :group 'faces)


(defcustom face-font-selection-order
  '(:width :height :weight :slant)
  "A list specifying how face font selection chooses fonts.
Each of the four symbols `:width', `:height', `:weight', and `:slant'
must appear once in the list, and the list must not contain any other
elements.  Font selection first tries to find a best matching font
for those face attributes that appear before in the list.  For
example, if `:slant' appears before `:height', font selection first
tries to find a font with a suitable slant, even if this results in
a font height that isn't optimal."
  :tag "Font selection order"
  :type '(list symbol symbol symbol symbol)
  :group 'font-selection
  :set #'(lambda (symbol value)
	   (set-default symbol value)
	   (internal-set-font-selection-order value)))


;; In the absence of Fontconfig support, Monospace and Sans Serif are
;; unavailable, and we fall back on the courier and helv families,
;; which are generally available.
(defcustom face-font-family-alternatives
  (mapcar (lambda (arg) (mapcar 'purecopy arg))
  '(("Monospace" "courier" "fixed")
    ("courier" "CMU Typewriter Text" "fixed")
    ("Sans Serif" "helv" "helvetica" "arial" "fixed")
    ("helv" "helvetica" "arial" "fixed")))
  "Alist of alternative font family names.
Each element has the form (FAMILY ALTERNATIVE1 ALTERNATIVE2 ...).
If fonts of family FAMILY can't be loaded, try ALTERNATIVE1, then
ALTERNATIVE2 etc."
  :tag "Alternative font families to try"
  :type '(repeat (repeat string))
  :group 'font-selection
  :set #'(lambda (symbol value)
	   (set-default symbol value)
	   (internal-set-alternative-font-family-alist value)))


;; This is defined originally in xfaces.c.
(defcustom face-font-registry-alternatives
  (mapcar (lambda (arg) (mapcar 'purecopy arg))
  (if (featurep 'w32)
      '(("iso8859-1" "ms-oemlatin")
	("gb2312.1980" "gb2312" "gbk" "gb18030")
	("jisx0208.1990" "jisx0208.1983" "jisx0208.1978")
	("ksc5601.1989" "ksx1001.1992" "ksc5601.1987")
	("muletibetan-2" "muletibetan-0"))
    '(("gb2312.1980" "gb2312.80&gb8565.88" "gbk" "gb18030")
      ("jisx0208.1990" "jisx0208.1983" "jisx0208.1978")
      ("ksc5601.1989" "ksx1001.1992" "ksc5601.1987")
      ("muletibetan-2" "muletibetan-0"))))
  "Alist of alternative font registry names.
Each element has the form (REGISTRY ALTERNATIVE1 ALTERNATIVE2 ...).
If fonts of registry REGISTRY can be loaded, font selection
tries to find a best matching font among all fonts of registry
REGISTRY, ALTERNATIVE1, ALTERNATIVE2, and etc."
  :tag "Alternative font registries to try"
  :type '(repeat (repeat string))
  :version "21.1"
  :group 'font-selection
  :set #'(lambda (symbol value)
	   (set-default symbol value)
	   (internal-set-alternative-font-registry-alist value)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Creation, copying.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun face-list ()
  "Return a list of all defined faces."
  (mapcar #'car face-new-frame-defaults))

(defun make-face (face &optional no-init-from-resources)
  "Define a new face with name FACE, a symbol.
Do not call this directly from Lisp code; use `defface' instead.

If FACE is already known as a face, leave it unmodified.  Return FACE.

NO-INIT-FROM-RESOURCES has been deprecated and is no longer used
and will go away.  Handling of conditional X resources application
has been pushed down to make-x-resource-internal itself."
  (interactive (list (read-from-minibuffer
		      "Make face: " nil nil t 'face-name-history)))
  (unless (facep face)
    ;; Make frame-local faces (this also makes the global one).
    (dolist (frame (frame-list))
      (internal-make-lisp-face face frame))
    ;; Add the face to the face menu.
    (when (fboundp 'facemenu-add-new-face)
      (facemenu-add-new-face face))
    ;; Define frame-local faces for all frames from X resources.
    (make-face-x-resource-internal face))
  face)

;; Handling of whether to apply X resources or not, has been pushed down
;; to make-face-x-resource-internal itself, thus the optional arg is no
;; longer evaluated at all and going away.
(set-advertised-calling-convention 'make-face '(face) "24.4")

(defun make-empty-face (face)
  "Define a new, empty face with name FACE.
Do not call this directly from Lisp code; use `defface' instead."
  (interactive (list (read-from-minibuffer
		      "Make empty face: " nil nil t 'face-name-history)))
  (make-face face))

(defun copy-face (old-face new-face &optional frame new-frame)
  "Define a face named NEW-FACE, which is a copy of OLD-FACE.
This function does not copy face customization data, so NEW-FACE
will not be made customizable.  Most Lisp code should not call
this function; use `defface' with :inherit instead.

If NEW-FACE already exists as a face, modify it to be like
OLD-FACE.  If NEW-FACE doesn't already exist, create it.

If the optional argument FRAME is a frame, change NEW-FACE on
FRAME only.  If FRAME is t, copy the frame-independent default
specification for OLD-FACE to NEW-FACE.  If FRAME is nil, copy
the defaults as well as the faces on each existing frame.

If the optional fourth argument NEW-FRAME is given, copy the
information from face OLD-FACE on frame FRAME to NEW-FACE on
frame NEW-FRAME.  In this case, FRAME must not be nil."
  (let ((inhibit-quit t))
    (if (null frame)
	(progn
	  (when new-frame
	    (error "Copying face %s from all frames to one frame"
		   old-face))
	  (make-empty-face new-face)
	  (dolist (frame (frame-list))
	    (copy-face old-face new-face frame))
	  (copy-face old-face new-face t))
      (make-empty-face new-face)
      (internal-copy-lisp-face old-face new-face frame new-frame))
    new-face))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Predicates, type checks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun facep (face)
  "Return non-nil if FACE is a face name; nil otherwise.
A face name can be a string or a symbol."
  (internal-lisp-face-p face))


(defun check-face (face)
  "Signal an error if FACE doesn't name a face.
Value is FACE."
  (unless (facep face)
    (error "Not a face: %s" face))
  face)


;; The ID returned is not to be confused with the internally used IDs
;; of realized faces.  The ID assigned to Lisp faces is used to
;; support faces in display table entries.

(defun face-id (face &optional _frame)
  "Return the internal ID of face with name FACE.
If FACE is a face-alias, return the ID of the target face.
The optional argument FRAME is ignored, since the internal face ID
of a face name is the same for all frames."
  (check-face face)
  (or (get face 'face)
      (face-id (get face 'face-alias))))

(defun face-equal (face1 face2 &optional frame)
  "Non-nil if faces FACE1 and FACE2 are equal.
Faces are considered equal if all their attributes are equal.
If the optional argument FRAME is given, report on FACE1 and FACE2 in that frame.
If FRAME is t, report on the defaults for FACE1 and FACE2 (for new frames).
If FRAME is omitted or nil, use the selected frame."
  (internal-lisp-face-equal-p face1 face2 frame))


(defun face-differs-from-default-p (face &optional frame)
  "Return non-nil if FACE displays differently from the default face.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame."
  (let ((attrs
	 (delq :inherit (mapcar 'car face-attribute-name-alist)))
	(differs nil))
    (while (and attrs (not differs))
      (let* ((attr (pop attrs))
	     (attr-val (face-attribute face attr frame t)))
	(when (and
	       (not (eq attr-val 'unspecified))
	       (display-supports-face-attributes-p (list attr attr-val)
						   frame))
	  (setq differs attr))))
    differs))


(defun face-nontrivial-p (face &optional frame)
  "True if face FACE has some non-nil attribute.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame."
  (not (internal-lisp-face-empty-p face frame)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setting face attributes from X resources.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom face-x-resources
  (mapcar
   (lambda (arg)
     ;; FIXME; can we purecopy some of the conses too?
     (cons (car arg)
	   (cons (purecopy (car (cdr arg))) (purecopy (cdr (cdr arg))))))
  '((:family (".attributeFamily" . "Face.AttributeFamily"))
    (:foundry (".attributeFoundry" . "Face.AttributeFoundry"))
    (:width (".attributeWidth" . "Face.AttributeWidth"))
    (:height (".attributeHeight" . "Face.AttributeHeight"))
    (:weight (".attributeWeight" . "Face.AttributeWeight"))
    (:slant (".attributeSlant" . "Face.AttributeSlant"))
    (:foreground (".attributeForeground" . "Face.AttributeForeground"))
    (:distant-foreground
     (".attributeDistantForeground" . "Face.AttributeDistantForeground"))
    (:background (".attributeBackground" . "Face.AttributeBackground"))
    (:overline (".attributeOverline" . "Face.AttributeOverline"))
    (:strike-through (".attributeStrikeThrough" . "Face.AttributeStrikeThrough"))
    (:box (".attributeBox" . "Face.AttributeBox"))
    (:underline (".attributeUnderline" . "Face.AttributeUnderline"))
    (:inverse-video (".attributeInverse" . "Face.AttributeInverse"))
    (:stipple
     (".attributeStipple" . "Face.AttributeStipple")
     (".attributeBackgroundPixmap" . "Face.AttributeBackgroundPixmap"))
    (:bold (".attributeBold" . "Face.AttributeBold"))
    (:italic (".attributeItalic" . "Face.AttributeItalic"))
    (:font (".attributeFont" . "Face.AttributeFont"))
    (:inherit (".attributeInherit" . "Face.AttributeInherit"))))
  "List of X resources and classes for face attributes.
Each element has the form (ATTRIBUTE ENTRY1 ENTRY2...) where ATTRIBUTE is
the name of a face attribute, and each ENTRY is a cons of the form
\(RESOURCE . CLASS) with RESOURCE being the resource and CLASS being the
X resource class for the attribute."
  :type '(repeat (cons symbol (repeat (cons string string))))
  :group 'faces)


(declare-function internal-face-x-get-resource "xfaces.c"
		  (resource class &optional frame))

(declare-function internal-set-lisp-face-attribute-from-resource "xfaces.c"
		  (face attr value &optional frame))

(defun set-face-attribute-from-resource (face attribute resource class frame)
  "Set FACE's ATTRIBUTE from X resource RESOURCE, class CLASS on FRAME.
Value is the attribute value specified by the resource, or nil
if not present.  This function displays a message if the resource
specifies an invalid attribute."
  (let* ((face-name (face-name face))
	 (value (internal-face-x-get-resource (concat face-name resource)
					      class frame)))
    (when value
      (condition-case ()
	  (internal-set-lisp-face-attribute-from-resource
	   face attribute (downcase value) frame)
	(error
	 (message "Face %s, frame %s: invalid attribute %s %s from X resource"
		  face-name frame attribute value))))
    value))


(defun set-face-attributes-from-resources (face frame)
  "Set attributes of FACE from X resources for FRAME."
  (when (memq (framep frame) '(x w32))
    (dolist (definition face-x-resources)
      (let ((attribute (car definition)))
	(dolist (entry (cdr definition))
	  (set-face-attribute-from-resource face attribute (car entry)
					    (cdr entry) frame))))))


(defun make-face-x-resource-internal (face &optional frame)
  "Fill frame-local FACE on FRAME from X resources.
FRAME nil or not specified means do it for all frames.

If `inhibit-x-resources' is non-nil, this function does nothing."
  (unless inhibit-x-resources
    (dolist (frame (if (null frame) (frame-list) (list frame)))
      ;; `x-create-frame' already took care of correctly handling
      ;; the reverse video case-- do _not_ touch the default face
      (unless (and (eq face 'default)
		   (frame-parameter frame 'reverse))
        (set-face-attributes-from-resources face frame)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Retrieving face attributes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun face-name (face)
  "Return the name of face FACE."
  (symbol-name (check-face face)))


(defun face-all-attributes (face &optional frame)
  "Return an alist stating the attributes of FACE.
Each element of the result has the form (ATTR-NAME . ATTR-VALUE).
If FRAME is omitted or nil the value describes the default attributes,
but if you specify FRAME, the value describes the attributes
of FACE on FRAME."
  (mapcar (lambda (pair)
	    (let ((attr (car pair)))
	      (cons attr (face-attribute face attr (or frame t)))))
  	  face-attribute-name-alist))

(defun face-attribute (face attribute &optional frame inherit)
  "Return the value of FACE's ATTRIBUTE on FRAME.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.

If INHERIT is nil, only attributes directly defined by FACE are considered,
  so the return value may be `unspecified', or a relative value.
If INHERIT is non-nil, FACE's definition of ATTRIBUTE is merged with the
  faces specified by its `:inherit' attribute; however the return value
  may still be `unspecified' or relative.
If INHERIT is a face or a list of faces, then the result is further merged
  with that face (or faces), until it becomes specified and absolute.

To ensure that the return value is always specified and absolute, use a
value of `default' for INHERIT; this will resolve any unspecified or
relative values by merging with the `default' face (which is always
completely specified)."
  (let ((value (internal-get-lisp-face-attribute face attribute frame)))
    (when (and inherit (face-attribute-relative-p attribute value))
      ;; VALUE is relative, so merge with inherited faces
      (let ((inh-from (face-attribute face :inherit frame)))
	(unless (or (null inh-from) (eq inh-from 'unspecified))
          (condition-case nil
              (setq value
                    (face-attribute-merged-with attribute value inh-from frame))
            ;; The `inherit' attribute may point to non existent faces.
            (error nil)))))
    (when (and inherit
	       (not (eq inherit t))
	       (face-attribute-relative-p attribute value))
      ;; We should merge with INHERIT as well
      (setq value (face-attribute-merged-with attribute value inherit frame)))
    value))

(defun face-attribute-merged-with (attribute value faces &optional frame)
  "Merges ATTRIBUTE, initially VALUE, with faces from FACES until absolute.
FACES may be either a single face or a list of faces.
\[This is an internal function.]"
  (cond ((not (face-attribute-relative-p attribute value))
	 value)
	((null faces)
	 value)
	((consp faces)
	 (face-attribute-merged-with
	  attribute
	  (face-attribute-merged-with attribute value (car faces) frame)
	  (cdr faces)
	  frame))
	(t
	 (merge-face-attribute attribute
			       value
			       (face-attribute faces attribute frame t)))))


(defmacro face-attribute-specified-or (value &rest body)
  "Return VALUE, unless it's `unspecified', in which case evaluate BODY and return the result."
  (let ((temp (make-symbol "value")))
    `(let ((,temp ,value))
       (if (not (eq ,temp 'unspecified))
	   ,temp
	 ,@body))))

(defun face-foreground (face &optional frame inherit)
  "Return the foreground color name of FACE, or nil if unspecified.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.

If INHERIT is nil, only a foreground color directly defined by FACE is
  considered, so the return value may be nil.
If INHERIT is t, and FACE doesn't define a foreground color, then any
  foreground color that FACE inherits through its `:inherit' attribute
  is considered as well; however the return value may still be nil.
If INHERIT is a face or a list of faces, then it is used to try to
  resolve an unspecified foreground color.

To ensure that a valid color is always returned, use a value of
`default' for INHERIT; this will resolve any unspecified values by
merging with the `default' face (which is always completely specified)."
  (face-attribute-specified-or (face-attribute face :foreground frame inherit)
			       nil))

(defun face-background (face &optional frame inherit)
  "Return the background color name of FACE, or nil if unspecified.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.

If INHERIT is nil, only a background color directly defined by FACE is
  considered, so the return value may be nil.
If INHERIT is t, and FACE doesn't define a background color, then any
  background color that FACE inherits through its `:inherit' attribute
  is considered as well; however the return value may still be nil.
If INHERIT is a face or a list of faces, then it is used to try to
  resolve an unspecified background color.

To ensure that a valid color is always returned, use a value of
`default' for INHERIT; this will resolve any unspecified values by
merging with the `default' face (which is always completely specified)."
  (face-attribute-specified-or (face-attribute face :background frame inherit)
			       nil))

(defun face-stipple (face &optional frame inherit)
 "Return the stipple pixmap name of FACE, or nil if unspecified.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.

If INHERIT is nil, only a stipple directly defined by FACE is
  considered, so the return value may be nil.
If INHERIT is t, and FACE doesn't define a stipple, then any stipple
  that FACE inherits through its `:inherit' attribute is considered as
  well; however the return value may still be nil.
If INHERIT is a face or a list of faces, then it is used to try to
  resolve an unspecified stipple.

To ensure that a valid stipple or nil is always returned, use a value of
`default' for INHERIT; this will resolve any unspecified values by merging
with the `default' face (which is always completely specified)."
  (face-attribute-specified-or (face-attribute face :stipple frame inherit)
			       nil))


(defalias 'face-background-pixmap 'face-stipple)


(defun face-underline-p (face &optional frame inherit)
 "Return non-nil if FACE specifies a non-nil underlining.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.
Optional argument INHERIT is passed to `face-attribute'."
 (face-attribute-specified-or
  (face-attribute face :underline frame inherit) nil))


(defun face-inverse-video-p (face &optional frame inherit)
 "Return non-nil if FACE specifies a non-nil inverse-video.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.
Optional argument INHERIT is passed to `face-attribute'."
 (eq (face-attribute face :inverse-video frame inherit) t))


(defun face-bold-p (face &optional frame inherit)
  "Return non-nil if the font of FACE is bold on FRAME.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.
Optional argument INHERIT is passed to `face-attribute'.
Use `face-attribute' for finer control."
  (let ((bold (face-attribute face :weight frame inherit)))
    (memq bold '(semi-bold bold extra-bold ultra-bold))))


(defun face-italic-p (face &optional frame inherit)
  "Return non-nil if the font of FACE is italic on FRAME.
If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame.
Optional argument INHERIT is passed to `face-attribute'.
Use `face-attribute' for finer control."
  (let ((italic (face-attribute face :slant frame inherit)))
    (memq italic '(italic oblique))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Face documentation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun face-documentation (face)
  "Get the documentation string for FACE.
If FACE is a face-alias, get the documentation for the target face."
  (let ((alias (get face 'face-alias)))
    (if alias
        (let ((doc (get alias 'face-documentation)))
	  (format "%s is an alias for the face `%s'.%s" face alias
                  (if doc (format "\n%s" doc)
                    "")))
      (get face 'face-documentation))))


(defun set-face-documentation (face string)
  "Set the documentation string for FACE to STRING."
  ;; Perhaps the text should go in DOC.
  (put face 'face-documentation (purecopy string)))


(defalias 'face-doc-string 'face-documentation)
(defalias 'set-face-doc-string 'set-face-documentation)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setting face attributes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun set-face-attribute (face frame &rest args)
  "Set attributes of FACE on FRAME from ARGS.
This function overrides the face attributes specified by FACE's
face spec.  It is mostly intended for internal use only.

If FRAME is nil, set the attributes for all existing frames, as
well as the default for new frames.  If FRAME is t, change the
default for new frames only.

ARGS must come in pairs ATTRIBUTE VALUE.  ATTRIBUTE must be a
valid face attribute name.  All attributes can be set to
`unspecified'; this fact is not further mentioned below.

The following attributes are recognized:

`:family'

VALUE must be a string specifying the font family
\(e.g. \"Monospace\") or a fontset.

`:foundry'

VALUE must be a string specifying the font foundry,
e.g. ``adobe''.  If a font foundry is specified, wild-cards `*'
and `?' are allowed.

`:width'

VALUE specifies the relative proportionate width of the font to use.
It must be one of the symbols `ultra-condensed', `extra-condensed',
`condensed', `semi-condensed', `normal', `semi-expanded', `expanded',
`extra-expanded', or `ultra-expanded'.

`:height'

VALUE specifies the relative or absolute height of the font.  An
absolute height is an integer, and specifies font height in units
of 1/10 pt.  A relative height is either a floating point number,
which specifies a scaling factor for the underlying face height;
or a function that takes a single argument (the underlying face
height) and returns the new height.  Note that for the `default'
face, you must specify an absolute height (since there is nothing
for it to be relative to).

`:weight'

VALUE specifies the weight of the font to use.  It must be one of the
symbols `ultra-bold', `extra-bold', `bold', `semi-bold', `normal',
`semi-light', `light', `extra-light', `ultra-light'.

`:slant'

VALUE specifies the slant of the font to use.  It must be one of the
symbols `italic', `oblique', `normal', `reverse-italic', or
`reverse-oblique'.

`:foreground', `:background'

VALUE must be a color name, a string.

`:underline'

VALUE specifies whether characters in FACE should be underlined.
If VALUE is t, underline with foreground color of the face.
If VALUE is a string, underline with that color.
If VALUE is nil, explicitly don't underline.

Otherwise, VALUE must be a property list of the form:

`(:color COLOR :style STYLE)'.

COLOR can be a either a color name string or `foreground-color'.
STYLE can be either `line' or `wave'.
If a keyword/value pair is missing from the property list, a
default value will be used for the value.
The default value of COLOR is the foreground color of the face.
The default value of STYLE is `line'.

`:overline'

VALUE specifies whether characters in FACE should be overlined.  If
VALUE is t, overline with foreground color of the face.  If VALUE is a
string, overline with that color.  If VALUE is nil, explicitly don't
overline.

`:strike-through'

VALUE specifies whether characters in FACE should be drawn with a line
striking through them.  If VALUE is t, use the foreground color of the
face.  If VALUE is a string, strike-through with that color.  If VALUE
is nil, explicitly don't strike through.

`:box'

VALUE specifies whether characters in FACE should have a box drawn
around them.  If VALUE is nil, explicitly don't draw boxes.  If
VALUE is t, draw a box with lines of width 1 in the foreground color
of the face.  If VALUE is a string, the string must be a color name,
and the box is drawn in that color with a line width of 1.  Otherwise,
VALUE must be a property list of the form `(:line-width WIDTH
:color COLOR :style STYLE)'.  If a keyword/value pair is missing from
the property list, a default value will be used for the value, as
specified below.  WIDTH specifies the width of the lines to draw; it
defaults to 1.  If WIDTH is negative, the absolute value is the width
of the lines, and draw top/bottom lines inside the characters area,
not around it.  COLOR is the name of the color to draw in, default is
the foreground color of the face for simple boxes, and the background
color of the face for 3D boxes.  STYLE specifies whether a 3D box
should be draw.  If STYLE is `released-button', draw a box looking
like a released 3D button.  If STYLE is `pressed-button' draw a box
that appears like a pressed button.  If STYLE is nil, the default if
the property list doesn't contain a style specification, draw a 2D
box.

`:inverse-video'

VALUE specifies whether characters in FACE should be displayed in
inverse video.  VALUE must be one of t or nil.

`:stipple'

If VALUE is a string, it must be the name of a file of pixmap data.
The directories listed in the `x-bitmap-file-path' variable are
searched.  Alternatively, VALUE may be a list of the form (WIDTH
HEIGHT DATA) where WIDTH and HEIGHT are the size in pixels, and DATA
is a string containing the raw bits of the bitmap.  VALUE nil means
explicitly don't use a stipple pattern.

For convenience, attributes `:family', `:foundry', `:width',
`:height', `:weight', and `:slant' may also be set in one step
from an X font name:

`:font'

Set font-related face attributes from VALUE.  VALUE must be a
valid font name or font object.  Setting this attribute will also
set the `:family', `:foundry', `:width', `:height', `:weight',
and `:slant' attributes.

`:inherit'

VALUE is the name of a face from which to inherit attributes, or
a list of face names.  Attributes from inherited faces are merged
into the face like an underlying face would be, with higher
priority than underlying faces.

For backward compatibility, the keywords `:bold' and `:italic'
can be used to specify weight and slant respectively.  This usage
is considered obsolete.  For these two keywords, the VALUE must
be either t or nil.  A value of t for `:bold' is equivalent to
setting `:weight' to `bold', and a value of t for `:italic' is
equivalent to setting `:slant' to `italic'.  But if `:weight' is
specified in the face spec, `:bold' is ignored, and if `:slant'
is specified, `:italic' is ignored."
  (setq args (purecopy args))
  (let ((where (if (null frame) 0 frame))
	(spec args)
	family foundry)
    ;; If we set the new-frame defaults, this face is modified outside Custom.
    (if (memq where '(0 t))
	(put (or (get face 'face-alias) face) 'face-modified t))
    ;; If family and/or foundry are specified, set it first.  Certain
    ;; face attributes, e.g. :weight semi-condensed, are not supported
    ;; in every font.  See bug#1127.
    (while spec
      (cond ((eq (car spec) :family)
	     (setq family (cadr spec)))
	    ((eq (car spec) :foundry)
	     (setq foundry (cadr spec))))
      (setq spec (cddr spec)))
    (when (or family foundry)
      (when (and (stringp family)
		 (string-match "\\([^-]*\\)-\\([^-]*\\)" family))
	(unless foundry
	  (setq foundry (match-string 1 family)))
	(setq family (match-string 2 family)))
      (when (or (stringp family) (eq family 'unspecified))
	(internal-set-lisp-face-attribute face :family (purecopy family)
					  where))
      (when (or (stringp foundry) (eq foundry 'unspecified))
	(internal-set-lisp-face-attribute face :foundry (purecopy foundry)
					  where)))
    (while args
      (unless (memq (car args) '(:family :foundry))
	(internal-set-lisp-face-attribute face (car args)
					  (purecopy (cadr args))
					  where))
      (setq args (cddr args)))))

(defun make-face-bold (face &optional frame _noerror)
  "Make the font of FACE be bold, if possible.
FRAME nil or not specified means change face on all frames.
Argument NOERROR is ignored and retained for compatibility.
Use `set-face-attribute' for finer control of the font weight."
  (interactive (list (read-face-name "Make which face bold"
                                     (face-at-point t))))
  (set-face-attribute face frame :weight 'bold))


(defun make-face-unbold (face &optional frame _noerror)
  "Make the font of FACE be non-bold, if possible.
FRAME nil or not specified means change face on all frames.
Argument NOERROR is ignored and retained for compatibility."
  (interactive (list (read-face-name "Make which face non-bold"
                                     (face-at-point t))))
  (set-face-attribute face frame :weight 'normal))


(defun make-face-italic (face &optional frame _noerror)
  "Make the font of FACE be italic, if possible.
FRAME nil or not specified means change face on all frames.
Argument NOERROR is ignored and retained for compatibility.
Use `set-face-attribute' for finer control of the font slant."
  (interactive (list (read-face-name "Make which face italic"
                                     (face-at-point t))))
  (set-face-attribute face frame :slant 'italic))


(defun make-face-unitalic (face &optional frame _noerror)
  "Make the font of FACE be non-italic, if possible.
FRAME nil or not specified means change face on all frames.
Argument NOERROR is ignored and retained for compatibility."
  (interactive (list (read-face-name "Make which face non-italic"
                                     (face-at-point t))))
  (set-face-attribute face frame :slant 'normal))


(defun make-face-bold-italic (face &optional frame _noerror)
  "Make the font of FACE be bold and italic, if possible.
FRAME nil or not specified means change face on all frames.
Argument NOERROR is ignored and retained for compatibility.
Use `set-face-attribute' for finer control of font weight and slant."
  (interactive (list (read-face-name "Make which face bold-italic"
                                     (face-at-point t))))
  (set-face-attribute face frame :weight 'bold :slant 'italic))


(defun set-face-font (face font &optional frame)
  "Change font-related attributes of FACE to those of FONT (a string).
FRAME nil or not specified means change face on all frames.
This sets the attributes `:family', `:foundry', `:width',
`:height', `:weight', and `:slant'.  When called interactively,
prompt for the face and font."
  (interactive (read-face-and-attribute :font))
  (set-face-attribute face frame :font font))


;; Implementation note: Emulating gray background colors with a
;; stipple pattern is now part of the face realization process, and is
;; done in C depending on the frame on which the face is realized.

(defun set-face-background (face color &optional frame)
  "Change the background color of face FACE to COLOR (a string).
FRAME nil or not specified means change face on all frames.
COLOR can be a system-defined color name (see `list-colors-display')
or a hex spec of the form #RRGGBB.
When called interactively, prompts for the face and color."
  (interactive (read-face-and-attribute :background))
  (set-face-attribute face frame :background (or color 'unspecified)))


(defun set-face-foreground (face color &optional frame)
  "Change the foreground color of face FACE to COLOR (a string).
FRAME nil or not specified means change face on all frames.
COLOR can be a system-defined color name (see `list-colors-display')
or a hex spec of the form #RRGGBB.
When called interactively, prompts for the face and color."
  (interactive (read-face-and-attribute :foreground))
  (set-face-attribute face frame :foreground (or color 'unspecified)))


(defun set-face-stipple (face stipple &optional frame)
  "Change the stipple pixmap of face FACE to STIPPLE.
FRAME nil or not specified means change face on all frames.
STIPPLE should be a string, the name of a file of pixmap data.
The directories listed in the `x-bitmap-file-path' variable are searched.

Alternatively, STIPPLE may be a list of the form (WIDTH HEIGHT DATA)
where WIDTH and HEIGHT are the size in pixels,
and DATA is a string, containing the raw bits of the bitmap."
  (interactive (read-face-and-attribute :stipple))
  (set-face-attribute face frame :stipple (or stipple 'unspecified)))


(defun set-face-underline (face underline &optional frame)
  "Specify whether face FACE is underlined.
UNDERLINE nil means FACE explicitly doesn't underline.
UNDERLINE t means FACE underlines with its foreground color.
If UNDERLINE is a string, underline with that color.

UNDERLINE may also be a list of the form (:color COLOR :style STYLE),
where COLOR is a string or `foreground-color', and STYLE is either
`line' or `wave'.  :color may be omitted, which means to use the
foreground color.  :style may be omitted, which means to use a line.

FRAME nil or not specified means change face on all frames.
Use `set-face-attribute' to ``unspecify'' underlining."
  (interactive (read-face-and-attribute :underline))
  (set-face-attribute face frame :underline underline))

(define-obsolete-function-alias 'set-face-underline-p
                                'set-face-underline "24.3")


(defun set-face-inverse-video (face inverse-video-p &optional frame)
  "Specify whether face FACE is in inverse video.
INVERSE-VIDEO-P non-nil means FACE displays explicitly in inverse video.
INVERSE-VIDEO-P nil means FACE explicitly is not in inverse video.
FRAME nil or not specified means change face on all frames.
Use `set-face-attribute' to ``unspecify'' the inverse video attribute."
  (interactive
   (let ((list (read-face-and-attribute :inverse-video)))
     (list (car list) (if (cadr list) t))))
  (set-face-attribute face frame :inverse-video inverse-video-p))

(define-obsolete-function-alias 'set-face-inverse-video-p
                                'set-face-inverse-video "24.4")

(defun set-face-bold (face bold-p &optional frame)
  "Specify whether face FACE is bold.
BOLD-P non-nil means FACE should explicitly display bold.
BOLD-P nil means FACE should explicitly display non-bold.
FRAME nil or not specified means change face on all frames.
Use `set-face-attribute' or `modify-face' for finer control."
  (if (null bold-p)
      (make-face-unbold face frame)
    (make-face-bold face frame)))

(define-obsolete-function-alias 'set-face-bold-p 'set-face-bold "24.4")


(defun set-face-italic (face italic-p &optional frame)
  "Specify whether face FACE is italic.
ITALIC-P non-nil means FACE should explicitly display italic.
ITALIC-P nil means FACE should explicitly display non-italic.
FRAME nil or not specified means change face on all frames.
Use `set-face-attribute' or `modify-face' for finer control."
  (if (null italic-p)
      (make-face-unitalic face frame)
    (make-face-italic face frame)))

(define-obsolete-function-alias 'set-face-italic-p 'set-face-italic "24.4")


(defalias 'set-face-background-pixmap 'set-face-stipple)


(defun invert-face (face &optional frame)
  "Swap the foreground and background colors of FACE.
If FRAME is omitted or nil, it means change face on all frames.
If FACE specifies neither foreground nor background color,
set its foreground and background to the background and foreground
of the default face.  Value is FACE."
  (interactive (list (read-face-name "Invert face" (face-at-point t))))
  (let ((fg (face-attribute face :foreground frame))
	(bg (face-attribute face :background frame)))
    (if (not (and (eq fg 'unspecified) (eq bg 'unspecified)))
	(set-face-attribute face frame :foreground bg :background fg)
      (set-face-attribute face frame
			  :foreground
			  (face-attribute 'default :background frame)
			  :background
			  (face-attribute 'default :foreground frame))))
  face)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Interactively modifying faces.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar crm-separator) ; from crm.el

(defun read-face-name (prompt &optional default multiple)
  "Read one or more face names, prompting with PROMPT.
PROMPT should not end in a space or a colon.

Return DEFAULT if the user enters the empty string.
If DEFAULT is non-nil, it should be a single face or a list of face names
\(symbols or strings).  In the latter case, return the `car' of DEFAULT
\(if MULTIPLE is nil, see below), or DEFAULT (if MULTIPLE is non-nil).

If MULTIPLE is non-nil, this function uses `completing-read-multiple'
to read multiple faces with \"[ \\t]*,[ \\t]*\" as the separator regexp
and it returns a list of face names.  Otherwise, it reads and returns
a single face name."
  (if (and default (not (stringp default)))
      (setq default
            (cond ((symbolp default)
                   (symbol-name default))
                  (multiple
                   (mapconcat (lambda (f) (if (symbolp f) (symbol-name f) f))
                              default ", "))
                  ;; If we only want one, and the default is more than one,
                  ;; discard the unwanted ones.
                  (t (symbol-name (car default))))))
  (when (and default (not multiple))
    (require 'crm)
    ;; For compatibility with `completing-read-multiple' use `crm-separator'
    ;; to define DEFAULT if MULTIPLE is nil.
    (setq default (car (split-string default crm-separator t))))

  (let ((prompt (if default
                    (format "%s (default `%s'): " prompt default)
                  (format "%s: " prompt)))
        aliasfaces nonaliasfaces faces)
    ;; Build up the completion tables.
    (mapatoms (lambda (s)
                (if (facep s)
                    (if (get s 'face-alias)
                        (push (symbol-name s) aliasfaces)
                      (push (symbol-name s) nonaliasfaces)))))
    (if multiple
        (progn
          (dolist (face (completing-read-multiple
                         prompt
                         (completion-table-in-turn nonaliasfaces aliasfaces)
                         nil t nil 'face-name-history default))
            ;; Ignore elements that are not faces
            ;; (for example, because DEFAULT was "all faces")
            (if (facep face) (push (intern face) faces)))
          (nreverse faces))
      (let ((face (completing-read
                   prompt
                   (completion-table-in-turn nonaliasfaces aliasfaces)
                   nil t nil 'face-name-history default)))
        (if (facep face) (intern face))))))

;; Not defined without X, but behind window-system test.
(defvar x-bitmap-file-path)

(defun face-valid-attribute-values (attribute &optional frame)
  "Return valid values for face attribute ATTRIBUTE.
The optional argument FRAME is used to determine available fonts
and colors.  If it is nil or not specified, the selected frame is used.
Value is an alist of (NAME . VALUE) if ATTRIBUTE expects a value out
of a set of discrete values.  Value is `integerp' if ATTRIBUTE expects
an integer value."
  (let ((valid
         (pcase attribute
           (`:family
            (if (window-system frame)
                (mapcar (lambda (x) (cons x x))
                        (font-family-list))
	      ;; Only one font on TTYs.
	      (list (cons "default" "default"))))
           (`:foundry
	    (list nil))
	   (`:width
	    (mapcar #'(lambda (x) (cons (symbol-name (aref x 1)) (aref x 1)))
		    font-width-table))
           (`:weight
	    (mapcar #'(lambda (x) (cons (symbol-name (aref x 1)) (aref x 1)))
		    font-weight-table))
	   (`:slant
	    (mapcar #'(lambda (x) (cons (symbol-name (aref x 1)) (aref x 1)))
		    font-slant-table))
	   (`:inverse-video
	    (mapcar #'(lambda (x) (cons (symbol-name x) x))
		    (internal-lisp-face-attribute-values attribute)))
           ((or `:underline `:overline `:strike-through `:box)
            (if (window-system frame)
                (nconc (mapcar #'(lambda (x) (cons (symbol-name x) x))
                               (internal-lisp-face-attribute-values attribute))
                       (mapcar #'(lambda (c) (cons c c))
                               (defined-colors frame)))
	      (mapcar #'(lambda (x) (cons (symbol-name x) x))
		      (internal-lisp-face-attribute-values attribute))))
           ((or `:foreground `:background)
            (mapcar #'(lambda (c) (cons c c))
                    (defined-colors frame)))
           (`:height
            'integerp)
           (`:stipple
            (and (memq (window-system frame) '(x ns)) ; No stipple on w32
                 (mapcar #'list
                         (apply #'nconc
                                (mapcar (lambda (dir)
                                          (and (file-readable-p dir)
                                               (file-directory-p dir)
                                               (directory-files dir)))
                                        x-bitmap-file-path)))))
           (`:inherit
            (cons '("none" . nil)
                  (mapcar #'(lambda (c) (cons (symbol-name c) c))
                          (face-list))))
           (_
            (error "Internal error")))))
    (if (and (listp valid) (not (memq attribute '(:inherit))))
	(nconc (list (cons "unspecified" 'unspecified)) valid)
      valid)))


(defconst face-attribute-name-alist
  '((:family . "font family")
    (:foundry . "font foundry")
    (:width . "character set width")
    (:height . "height in 1/10 pt")
    (:weight . "weight")
    (:slant . "slant")
    (:underline . "underline")
    (:overline . "overline")
    (:strike-through . "strike-through")
    (:box . "box")
    (:inverse-video . "inverse-video display")
    (:foreground . "foreground color")
    (:background . "background color")
    (:stipple . "background stipple")
    (:inherit . "inheritance"))
  "An alist of descriptive names for face attributes.
Each element has the form (ATTRIBUTE-NAME . DESCRIPTION) where
ATTRIBUTE-NAME is a face attribute name (a keyword symbol), and
DESCRIPTION is a descriptive name for ATTRIBUTE-NAME.")


(defun face-descriptive-attribute-name (attribute)
  "Return a descriptive name for ATTRIBUTE."
  (cdr (assq attribute face-attribute-name-alist)))


(defun face-read-string (face default name &optional completion-alist)
  "Interactively read a face attribute string value.
FACE is the face whose attribute is read.  If non-nil, DEFAULT is the
default string to return if no new value is entered.  NAME is a
descriptive name of the attribute for prompting.  COMPLETION-ALIST is an
alist of valid values, if non-nil.

Entering nothing accepts the default string DEFAULT.
Value is the new attribute value."
  ;; Capitalize NAME (we don't use `capitalize' because that capitalizes
  ;; each word in a string separately).
  (setq name (concat (upcase (substring name 0 1)) (substring name 1)))
  (let* ((completion-ignore-case t)
	 (value (completing-read
		 (if default
		     (format "%s for face `%s' (default %s): "
			     name face default)
		   (format "%s for face `%s': " name face))
		 completion-alist nil nil nil nil default)))
    (if (equal value "") default value)))


(defun face-read-integer (face default name)
  "Interactively read an integer face attribute value.
FACE is the face whose attribute is read.  DEFAULT is the default
value to return if no new value is entered.  NAME is a descriptive
name of the attribute for prompting.  Value is the new attribute value."
  (let ((new-value
	 (face-read-string face
			   (format "%s" default)
			   name
			   (list (cons "unspecified" 'unspecified)))))
    (cond ((equal new-value "unspecified")
	   'unspecified)
	  ((member new-value '("unspecified-fg" "unspecified-bg"))
	   new-value)
	  (t
	   (string-to-number new-value)))))


;; FIXME this does allow you to enter the list forms of :box,
;; :stipple, or :underline, because face-valid-attribute-values does
;; not return those forms.
(defun read-face-attribute (face attribute &optional frame)
  "Interactively read a new value for FACE's ATTRIBUTE.
Optional argument FRAME nil or unspecified means read an attribute value
of a global face.  Value is the new attribute value."
  (let* ((old-value (face-attribute face attribute frame))
	 (attribute-name (face-descriptive-attribute-name attribute))
	 (valid (face-valid-attribute-values attribute frame))
	 new-value)
    ;; Represent complex attribute values as strings by printing them
    ;; out.  Stipple can be a vector; (WIDTH HEIGHT DATA).  Box can be
    ;; a list `(:width WIDTH :color COLOR)' or `(:width WIDTH :shadow
    ;; SHADOW)'.  Underline can be `(:color COLOR :style STYLE)'.
    (and (memq attribute '(:box :stipple :underline))
	 (or (consp old-value)
	     (vectorp old-value))
	 (setq old-value (prin1-to-string old-value)))
    (cond ((listp valid)
	   (let ((default
		   (or (car (rassoc old-value valid))
		       (format "%s" old-value))))
	     (setq new-value
		   (face-read-string face default attribute-name valid))
	     (if (equal new-value default)
		 ;; Nothing changed, so don't bother with all the stuff
		 ;; below.  In particular, this avoids a non-tty color
		 ;; from being canonicalized for a tty when the user
		 ;; just uses the default.
		 (setq new-value old-value)
	       ;; Terminal frames can support colors that don't appear
	       ;; explicitly in VALID, using color approximation code
	       ;; in tty-colors.el.
	       (when (and (memq attribute '(:foreground :background))
			  (not (memq (window-system frame) '(x w32 ns)))
			  (not (member new-value
				       '("unspecified"
					 "unspecified-fg" "unspecified-bg"))))
		 (setq new-value (car (tty-color-desc new-value frame))))
	       (when (assoc new-value valid)
		 (setq new-value (cdr (assoc new-value valid)))))))
	  ((eq valid 'integerp)
	   (setq new-value (face-read-integer face old-value attribute-name)))
	  (t (error "Internal error")))
    ;; Convert stipple and box value text we read back to a list or
    ;; vector if it looks like one.  This makes the assumption that a
    ;; pixmap file name won't start with an open-paren.
    (and (memq attribute '(:stipple :box :underline))
	 (stringp new-value)
	 (string-match-p "^[[(]" new-value)
	 (setq new-value (read new-value)))
    new-value))

(declare-function fontset-list "fontset.c" ())
(declare-function x-list-fonts "xfaces.c"
		  (pattern &optional face frame maximum width))

(defun read-face-font (face &optional frame)
  "Read the name of a font for FACE on FRAME.
If optional argument FRAME is nil or omitted, use the selected frame."
  (let ((completion-ignore-case t))
    (completing-read (format "Set font attributes of face `%s' from font: " face)
		     (append (fontset-list) (x-list-fonts "*" nil frame)))))


(defun read-all-face-attributes (face &optional frame)
  "Interactively read all attributes for FACE.
If optional argument FRAME is nil or omitted, use the selected frame.
Value is a property list of attribute names and new values."
  (let (result)
    (dolist (attribute face-attribute-name-alist result)
      (setq result (cons (car attribute)
			 (cons (read-face-attribute face (car attribute) frame)
			       result))))))

(defun modify-face (&optional face foreground background stipple
			      bold-p italic-p underline inverse-p frame)
  "Modify attributes of faces interactively.
If optional argument FRAME is nil or omitted, modify the face used
for newly created frame, i.e. the global face.
For non-interactive use, `set-face-attribute' is preferred.
When called from Lisp, if FACE is nil, all arguments but FRAME are ignored
and the face and its settings are obtained by querying the user."
  (interactive)
  (if face
      (set-face-attribute face frame
			  :foreground (or foreground 'unspecified)
			  :background (or background 'unspecified)
			  :stipple stipple
			  :weight (if bold-p 'bold 'normal)
			  :slant (if italic-p 'italic 'normal)
			  :underline underline
			  :inverse-video inverse-p)
    (setq face (read-face-name "Modify face" (face-at-point t)))
    (apply #'set-face-attribute face frame
	   (read-all-face-attributes face frame))))

(defun read-face-and-attribute (attribute &optional frame)
  "Read face name and face attribute value.
ATTRIBUTE is the attribute whose new value is read.
FRAME nil or unspecified means read attribute value of global face.
Value is a list (FACE NEW-VALUE) where FACE is the face read
\(a symbol), and NEW-VALUE is value read."
  (cond ((eq attribute :font)
	 (let* ((prompt "Set font-related attributes of face")
		(face (read-face-name prompt (face-at-point t)))
		(font (read-face-font face frame)))
	   (list face font)))
	(t
	 (let* ((attribute-name (face-descriptive-attribute-name attribute))
		(prompt (format "Set %s of face" attribute-name))
		(face (read-face-name prompt (face-at-point t)))
		(new-value (read-face-attribute face attribute frame)))
	   (list face new-value)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Listing faces.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst list-faces-sample-text
  "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  "Text string to display as the sample text for `list-faces-display'.")


;; The name list-faces would be more consistent, but let's avoid a
;; conflict with Lucid, which uses that name differently.

(defvar help-xref-stack)
(defun list-faces-display (&optional regexp)
  "List all faces, using the same sample text in each.
The sample text is a string that comes from the variable
`list-faces-sample-text'.

If REGEXP is non-nil, list only those faces with names matching
this regular expression.  When called interactively with a prefix
argument, prompt for a regular expression using `read-regexp'."
  (interactive (list (and current-prefix-arg
                          (read-regexp "List faces matching regexp"))))
  (let ((all-faces (zerop (length regexp)))
	(frame (selected-frame))
	(max-length 0)
	faces line-format
	disp-frame window face-name)
    ;; We filter and take the max length in one pass
    (setq faces
	  (delq nil
		(mapcar (lambda (f)
			  (let ((s (symbol-name f)))
			    (when (or all-faces (string-match-p regexp s))
			      (setq max-length (max (length s) max-length))
			      f)))
			(sort (face-list) #'string-lessp))))
    (unless faces
      (error "No faces matching \"%s\"" regexp))
    (setq max-length (1+ max-length)
	  line-format (format "%%-%ds" max-length))
    (with-help-window "*Faces*"
      (with-current-buffer standard-output
	(setq truncate-lines t)
	(insert
	 (substitute-command-keys
	  (concat
	   "\\<help-mode-map>Use "
	   (if (display-mouse-p) "\\[help-follow-mouse] or ")
	   "\\[help-follow] on a face name to customize it\n"
	   "or on its sample text for a description of the face.\n\n")))
	(setq help-xref-stack nil)
	(dolist (face faces)
	  (setq face-name (symbol-name face))
	  (insert (format line-format face-name))
	  ;; Hyperlink to a customization buffer for the face.  Using
	  ;; the help xref mechanism may not be the best way.
	  (save-excursion
	    (save-match-data
	      (search-backward face-name)
	      (setq help-xref-stack-item `(list-faces-display ,regexp))
	      (help-xref-button 0 'help-customize-face face)))
	  (let ((beg (point))
		(line-beg (line-beginning-position)))
	    (insert list-faces-sample-text)
	    ;; Hyperlink to a help buffer for the face.
	    (save-excursion
	      (save-match-data
		(search-backward list-faces-sample-text)
		(help-xref-button 0 'help-face face)))
	    (insert "\n")
	    (put-text-property beg (1- (point)) 'face face)
	    ;; Make all face commands default to the proper face
	    ;; anywhere in the line.
	    (put-text-property line-beg (1- (point)) 'read-face-name face)
	    ;; If the sample text has multiple lines, line up all of them.
	    (goto-char beg)
	    (forward-line 1)
	    (while (not (eobp))
	      (insert-char ?\s max-length)
	      (forward-line 1))))
	(goto-char (point-min))))
    ;; If the *Faces* buffer appears in a different frame,
    ;; copy all the face definitions from FRAME,
    ;; so that the display will reflect the frame that was selected.
    (setq window (get-buffer-window (get-buffer "*Faces*") t))
    (setq disp-frame (if window (window-frame window)
		       (car (frame-list))))
    (or (eq frame disp-frame)
	(dolist (face (face-list))
	  (copy-face face face frame disp-frame)))))


(defun describe-face (face &optional frame)
  "Display the properties of face FACE on FRAME.
Interactively, FACE defaults to the faces of the character after point
and FRAME defaults to the selected frame.

If the optional argument FRAME is given, report on face FACE in that frame.
If FRAME is t, report on the defaults for face FACE (for new frames).
If FRAME is omitted or nil, use the selected frame."
  (interactive (list (read-face-name "Describe face"
                                     (or (face-at-point t) 'default)
                                     t)))
  (let* ((attrs '((:family . "Family")
		  (:foundry . "Foundry")
		  (:width . "Width")
		  (:height . "Height")
		  (:weight . "Weight")
		  (:slant . "Slant")
		  (:foreground . "Foreground")
		  (:distant-foreground . "DistantForeground")
		  (:background . "Background")
		  (:underline . "Underline")
		  (:overline . "Overline")
		  (:strike-through . "Strike-through")
		  (:box . "Box")
		  (:inverse-video . "Inverse")
		  (:stipple . "Stipple")
		  (:font . "Font")
		  (:fontset . "Fontset")
		  (:inherit . "Inherit")))
	(max-width (apply #'max (mapcar #'(lambda (x) (length (cdr x)))
					attrs))))
    (help-setup-xref (list #'describe-face face)
		     (called-interactively-p 'interactive))
    (unless face
      (setq face 'default))
    (if (not (listp face))
	(setq face (list face)))
    (with-help-window (help-buffer)
      (with-current-buffer standard-output
	(dolist (f face)
	  (if (stringp f) (setq f (intern f)))
	  ;; We may get called for anonymous faces (i.e., faces
	  ;; expressed using prop-value plists).  Those can't be
	  ;; usefully customized, so ignore them.
	  (when (symbolp f)
	    (insert "Face: " (symbol-name f))
	    (if (not (facep f))
		(insert "   undefined face.\n")
	      (let ((customize-label "customize this face")
		    file-name)
		(insert (concat " (" (propertize "sample" 'font-lock-face f) ")"))
		(princ (concat " (" customize-label ")\n"))
		;; FIXME not sure how much of this belongs here, and
		;; how much in `face-documentation'.  The latter is
		;; not used much, but needs to return nil for
		;; undocumented faces.
		(let ((alias (get f 'face-alias))
		      (face f)
		      obsolete)
		  (when alias
		    (setq face alias)
		    (insert
		     (format "\n  %s is an alias for the face `%s'.\n%s"
			     f alias
			     (if (setq obsolete (get f 'obsolete-face))
				 (format "  This face is obsolete%s; use `%s' instead.\n"
					 (if (stringp obsolete)
					     (format " since %s" obsolete)
					   "")
					 alias)
			       ""))))
		  (insert "\nDocumentation:\n"
			  (or (face-documentation face)
			      "Not documented as a face.")
			  "\n\n"))
		(with-current-buffer standard-output
		  (save-excursion
		    (re-search-backward
		     (concat "\\(" customize-label "\\)") nil t)
		    (help-xref-button 1 'help-customize-face f)))
		(setq file-name (find-lisp-object-file-name f 'defface))
		(when file-name
		  (princ "Defined in `")
		  (princ (file-name-nondirectory file-name))
		  (princ "'")
		  ;; Make a hyperlink to the library.
		  (save-excursion
		    (re-search-backward "`\\([^`']+\\)'" nil t)
		    (help-xref-button 1 'help-face-def f file-name))
		  (princ ".")
		  (terpri)
		  (terpri))
		(dolist (a attrs)
		  (let ((attr (face-attribute f (car a) frame)))
		    (insert (make-string (- max-width (length (cdr a))) ?\s)
			    (cdr a) ": " (format "%s" attr))
		    (if (and (eq (car a) :inherit)
			     (not (eq attr 'unspecified)))
			;; Make a hyperlink to the parent face.
			(save-excursion
			  (re-search-backward ": \\([^:]+\\)" nil t)
			  (help-xref-button 1 'help-face attr)))
		    (insert "\n")))))
	    (terpri)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Face specifications (defface).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Parameter FRAME Is kept for call compatibility to with previous
;; face implementation.

(defun face-attr-construct (face &optional _frame)
  "Return a `defface'-style attribute list for FACE.
Value is a property list of pairs ATTRIBUTE VALUE for all specified
face attributes of FACE where ATTRIBUTE is the attribute name and
VALUE is the specified value of that attribute.
Argument FRAME is ignored and retained for compatibility."
  (let (result)
    (dolist (entry face-attribute-name-alist result)
      (let* ((attribute (car entry))
	     (value (face-attribute face attribute)))
	(unless (eq value 'unspecified)
	  (setq result (nconc (list attribute value) result)))))))


(defun face-spec-set-match-display (display frame)
  "Non-nil if DISPLAY matches FRAME.
DISPLAY is part of a spec such as can be used in `defface'.
If FRAME is nil, the current FRAME is used."
  (let* ((conjuncts display)
	 conjunct req options
	 ;; t means we have succeeded against all the conjuncts in
	 ;; DISPLAY that have been tested so far.
	 (match t))
    (if (eq conjuncts t)
	(setq conjuncts nil))
    (while (and conjuncts match)
      (setq conjunct (car conjuncts)
	    conjuncts (cdr conjuncts)
	    req (car conjunct)
	    options (cdr conjunct)
	    match (cond ((eq req 'type)
			 (or (memq (window-system frame) options)
			     (and (memq 'graphic options)
				  (memq (window-system frame) '(x w32 ns)))
			     ;; FIXME: This should be revisited to use
			     ;; display-graphic-p, provided that the
			     ;; color selection depends on the number
			     ;; of supported colors, and all defface's
			     ;; are changed to look at number of colors
			     ;; instead of (type graphic) etc.
			     (if (null (window-system frame))
				 (memq 'tty options)
			       (or (and (memq 'motif options)
					(featurep 'motif))
				   (and (memq 'gtk options)
					(featurep 'gtk))
				   (and (memq 'lucid options)
					(featurep 'x-toolkit)
					(not (featurep 'motif))
					(not (featurep 'gtk)))
				   (and (memq 'x-toolkit options)
					(featurep 'x-toolkit))))))
			((eq req 'min-colors)
			 (>= (display-color-cells frame) (car options)))
			((eq req 'class)
			 (memq (frame-parameter frame 'display-type) options))
			((eq req 'background)
			 (memq (frame-parameter frame 'background-mode)
			       options))
			((eq req 'supports)
			 (display-supports-face-attributes-p options frame))
			(t (error "Unknown req `%S' with options `%S'"
				  req options)))))
    match))


(defun face-spec-choose (spec &optional frame no-match-retval)
  "Return the proper attributes for FRAME, out of SPEC.

If no match is found or SPEC is nil, return nil, unless NO-MATCH-RETVAL
is given, in which case return its value instead."
  (unless frame
    (setq frame (selected-frame)))
  (let ((tail spec)
	result defaults match-found)
    (while tail
      (let* ((entry (pop tail))
	     (display (car entry))
	     (attrs (cdr entry))
	     thisval)
	;; Get the attributes as actually specified by this alternative.
	(setq thisval
	      (if (null (cdr attrs)) ;; was (listp (car attrs))
		  ;; Old-style entry, the attribute list is the
		  ;; first element.
		  (car attrs)
		attrs))

	;; If the condition is `default', that sets the default
	;; for following conditions.
	(if (eq display 'default)
	    (setq defaults thisval)
	  ;; Otherwise, if it matches, use it.
	  (when (face-spec-set-match-display display frame)
	    (setq result thisval
	          tail nil
		  match-found t)))))
    ;; If defaults have been found, it's safe to just append those to the result
    ;; list (which at this point will be either nil or contain actual specs) and
    ;; return it to the caller. Since there will most definitely be something to
    ;; return in this case, there's no need to know/check if a match was found.
    (if defaults
	(append result defaults)
      (if match-found
	  result
	no-match-retval))))


(defun face-spec-reset-face (face &optional frame)
  "Reset all attributes of FACE on FRAME to unspecified."
  (apply 'set-face-attribute face frame
	 (if (eq face 'default)
	     ;; For the default face, avoid making any attribute
	     ;; unspecified.  Instead, set attributes to default values
	     ;; (see also realize_default_face in xfaces.c).
	     (append
	      '(:underline nil :overline nil :strike-through nil
		:box nil :inverse-video nil :stipple nil :inherit nil)
	      ;; `display-graphic-p' is unavailable when running
	      ;; temacs, prior to loading frame.el.
	      (when (fboundp 'display-graphic-p)
		(unless (display-graphic-p frame)
		  `(:family "default" :foundry "default" :width normal
		    :height 1 :weight normal :slant normal
		    :foreground ,(if (frame-parameter nil 'reverse)
				     "unspecified-bg"
				   "unspecified-fg")
		    :background ,(if (frame-parameter nil 'reverse)
				     "unspecified-fg"
				   "unspecified-bg")))))
	   ;; For all other faces, unspecify all attributes.
	   (apply 'append
		  (mapcar (lambda (x) (list (car x) 'unspecified))
			  face-attribute-name-alist)))))

(defun face-spec-set (face spec &optional spec-type)
  "Set the face spec SPEC for FACE.
See `defface' for the format of SPEC.

The appearance of each face is controlled by its specs (set via
this function), and by the internal frame-specific face
attributes (set via `set-face-attribute').

This function also defines FACE as a valid face name if it is not
already one, and (re)calculates its attributes on existing
frames.

The argument SPEC-TYPE determines which spec to set:
  nil or `face-override-spec' means the override spec (which is
    usually what you want if calling this function outside of
    Custom code);
  `customized-face' or `saved-face' means the customized spec or
    the saved custom spec;
  `face-defface-spec' means the default spec
    (usually set only via `defface');
  `reset' means to ignore SPEC, but clear the `customized-face'
    and `face-override-spec' specs;
Any other value means not to set any spec, but to run the
function for its other effects."
  (if (get face 'face-alias)
      (setq face (get face 'face-alias)))
  ;; Save SPEC to the relevant symbol property.
  (unless spec-type
    (setq spec-type 'face-override-spec))
  (if (memq spec-type '(face-defface-spec face-override-spec
			customized-face saved-face))
      (put face spec-type spec))
  (if (memq spec-type '(reset saved-face))
      (put face 'customized-face nil))
  ;; Setting the face spec via Custom empties out any override spec,
  ;; similar to how setting a variable via Custom changes its values.
  (if (memq spec-type '(customized-face saved-face reset))
      (put face 'face-override-spec nil))
  ;; If we reset the face based on its custom spec, it is unmodified
  ;; as far as Custom is concerned.
  (unless (eq face 'face-override-spec)
    (put face 'face-modified nil))
  ;; Initialize the face if it does not exist, then recalculate.
  (make-empty-face face)
  (dolist (frame (frame-list))
    (face-spec-recalc face frame)))

(defun face-spec-recalc (face frame)
  "Reset the face attributes of FACE on FRAME according to its specs.
The following sources are applied in this order:

  face reset to default values if it's the default face, otherwise set
  to unspecified (through `face-spec-reset-face')
   |
  (theme and user customization)
    or: if none of the above exist, and none match the current frame or
        inherited from the defface spec instead of overwriting it
        entirely, the following is applied instead:
  (defface default spec)
  (X resources (if applicable))
   |
  defface override spec"
  (while (get face 'face-alias)
    (setq face (get face 'face-alias)))
  (face-spec-reset-face face frame)
  ;; If FACE is customized or themed, set the custom spec from
  ;; `theme-face' records.
  (let ((theme-faces (get face 'theme-face))
	(no-match-found 0)
	spec theme-face-applied)
    (if theme-faces
	(dolist (elt (reverse theme-faces))
	  (setq spec (face-spec-choose (cadr elt) frame no-match-found))
	  (unless (eq spec no-match-found)
	    (face-spec-set-2 face frame spec)
	    (setq theme-face-applied t))))
    ;; If there was a spec applicable to FRAME, that overrides the
    ;; defface spec entirely (rather than inheriting from it).  If
    ;; there was no spec applicable to FRAME, apply the defface spec
    ;; as well as any applicable X resources.
    (unless theme-face-applied
      (setq spec (face-spec-choose (face-default-spec face) frame))
      (face-spec-set-2 face frame spec)
      (make-face-x-resource-internal face frame))
    (setq spec (face-spec-choose (get face 'face-override-spec) frame))
    (face-spec-set-2 face frame spec)))

(defun face-spec-set-2 (face frame spec)
  "Set the face attributes of FACE on FRAME according to SPEC."
  (let (attrs)
    (while spec
      (when (assq (car spec) face-x-resources)
	(push (car spec) attrs)
	(push (cadr spec) attrs))
      (setq spec (cddr spec)))
    (apply 'set-face-attribute face frame (nreverse attrs))))

(defun face-attr-match-p (face attrs &optional frame)
  "Return t if attributes of FACE match values in plist ATTRS.
Optional parameter FRAME is the frame whose definition of FACE
is used.  If nil or omitted, use the selected frame."
  (unless frame
    (setq frame (selected-frame)))
  (let* ((list face-attribute-name-alist)
	 (match t)
	 (bold (and (plist-member attrs :bold)
		    (not (plist-member attrs :weight))))
	 (italic (and (plist-member attrs :italic)
		      (not (plist-member attrs :slant))))
	 (plist (if (or bold italic)
		    (copy-sequence attrs)
		  attrs)))
    ;; Handle the Emacs 20 :bold and :italic properties.
    (if bold
	(plist-put plist :weight (if bold 'bold 'normal)))
    (if italic
	(plist-put plist :slant (if italic 'italic 'normal)))
    (while (and match list)
      (let* ((attr (caar list))
	     (specified-value
	      (if (plist-member plist attr)
		  (plist-get plist attr)
		'unspecified))
	     (value-now (face-attribute face attr frame)))
	(setq match (equal specified-value value-now))
	(setq list (cdr list))))
    match))

(defsubst face-spec-match-p (face spec &optional frame)
  "Return t if FACE, on FRAME, matches what SPEC says it should look like."
  (face-attr-match-p face (face-spec-choose spec frame) frame))

(defsubst face-default-spec (face)
  "Return the default face-spec for FACE, ignoring any user customization.
If there is no default for FACE, return nil."
  (get face 'face-defface-spec))

(defsubst face-user-default-spec (face)
  "Return the user's customized face-spec for FACE, or the default if none.
If there is neither a user setting nor a default for FACE, return nil."
  (or (get face 'customized-face)
      (get face 'saved-face)
      (face-default-spec face)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Frame-type independent color support.
;;; We keep the old x-* names as aliases for back-compatibility.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun defined-colors (&optional frame)
  "Return a list of colors supported for a particular frame.
The argument FRAME specifies which frame to try.
The value may be different for frames on different display types.
If FRAME doesn't support colors, the value is nil.
If FRAME is nil, that stands for the selected frame."
  (if (memq (framep (or frame (selected-frame))) '(x w32 ns))
      (xw-defined-colors frame)
    (mapcar 'car (tty-color-alist frame))))
(defalias 'x-defined-colors 'defined-colors)

(declare-function xw-color-defined-p "xfns.c" (color &optional frame))

(defun color-defined-p (color &optional frame)
  "Return non-nil if COLOR is supported on frame FRAME.
COLOR should be a string naming a color (e.g. \"white\"), or a
string specifying a color's RGB components (e.g. \"#ff12ec\"), or
the symbol `unspecified'.

This function returns nil if COLOR is the symbol `unspecified',
or one of the strings \"unspecified-fg\" or \"unspecified-bg\".

If FRAME is omitted or nil, use the selected frame."
  (unless (member color '(unspecified "unspecified-bg" "unspecified-fg"))
    (if (member (framep (or frame (selected-frame))) '(x w32 ns))
	(xw-color-defined-p color frame)
      (numberp (tty-color-translate color frame)))))
(defalias 'x-color-defined-p 'color-defined-p)

(declare-function xw-color-values "xfns.c" (color &optional frame))

(defun color-values (color &optional frame)
  "Return a description of the color named COLOR on frame FRAME.
COLOR should be a string naming a color (e.g. \"white\"), or a
string specifying a color's RGB components (e.g. \"#ff12ec\").

Return a list of three integers, (RED GREEN BLUE), each between 0
and either 65280 or 65535 (the maximum depends on the system).
Use `color-name-to-rgb' if you want RGB floating-point values
normalized to 1.0.

If FRAME is omitted or nil, use the selected frame.
If FRAME cannot display COLOR, the value is nil.

COLOR can also be the symbol `unspecified' or one of the strings
\"unspecified-fg\" or \"unspecified-bg\", in which case the
return value is nil."
  (cond
   ((member color '(unspecified "unspecified-fg" "unspecified-bg"))
    nil)
   ((memq (framep (or frame (selected-frame))) '(x w32 ns))
    (xw-color-values color frame))
   (t
    (tty-color-values color frame))))

(defalias 'x-color-values 'color-values)

(declare-function xw-display-color-p "xfns.c" (&optional terminal))

(defun display-color-p (&optional display)
  "Return t if DISPLAY supports color.
The optional argument DISPLAY specifies which display to ask about.
DISPLAY should be either a frame or a display name (a string).
If omitted or nil, that stands for the selected frame's display."
  (if (memq (framep-on-display display) '(x w32 ns))
      (xw-display-color-p display)
    (tty-display-color-p display)))
(defalias 'x-display-color-p 'display-color-p)

(declare-function x-display-grayscale-p "xfns.c" (&optional terminal))

(defun display-grayscale-p (&optional display)
  "Return non-nil if frames on DISPLAY can display shades of gray.
DISPLAY should be either a frame or a display name (a string).
If omitted or nil, that stands for the selected frame's display."
  (let ((frame-type (framep-on-display display)))
    (cond
     ((memq frame-type '(x w32 ns))
      (x-display-grayscale-p display))
     (t
      (> (tty-color-gray-shades display) 2)))))

(defun read-color (&optional prompt convert-to-RGB allow-empty-name msg)
  "Read a color name or RGB triplet.
Completion is available for color names, but not for RGB triplets.

RGB triplets have the form \"#RRGGBB\".  Each of the R, G, and B
components can have one to four digits, but all three components
must have the same number of digits.  Each digit is a hex value
between 0 and F; either upper case or lower case for A through F
are acceptable.

In addition to standard color names and RGB hex values, the
following are available as color candidates.  In each case, the
corresponding color is used.

 * `foreground at point'   - foreground under the cursor
 * `background at point'   - background under the cursor

Optional arg PROMPT is the prompt; if nil, use a default prompt.

Interactively, or with optional arg CONVERT-TO-RGB-P non-nil,
convert an input color name to an RGB hex string.  Return the RGB
hex string.

If optional arg ALLOW-EMPTY-NAME is non-nil, the user is allowed
to enter an empty color name (the empty string).

Interactively, or with optional arg MSG non-nil, print the
resulting color name in the echo area."
  (interactive "i\np\ni\np")    ; Always convert to RGB interactively.
  (let* ((completion-ignore-case t)
	 (colors (or facemenu-color-alist
		     (append '("foreground at point" "background at point")
			     (if allow-empty-name '(""))
			     (defined-colors))))
	 (color (completing-read
		 (or prompt "Color (name or #RGB triplet): ")
		 ;; Completing function for reading colors, accepting
		 ;; both color names and RGB triplets.
		 (lambda (string pred flag)
		   (cond
		    ((null flag) ; Try completion.
		     (or (try-completion string colors pred)
			 (if (color-defined-p string)
			     string)))
		    ((eq flag t) ; List all completions.
		     (or (all-completions string colors pred)
			 (if (color-defined-p string)
			     (list string))))
		    ((eq flag 'lambda) ; Test completion.
		     (or (member string colors)
			 (color-defined-p string)))))
		 nil t)))

    ;; Process named colors.
    (when (member color colors)
      (cond ((string-equal color "foreground at point")
	     (setq color (foreground-color-at-point)))
	    ((string-equal color "background at point")
	     (setq color (background-color-at-point))))
      (when (and convert-to-RGB
		 (not (string-equal color "")))
	(let ((components (x-color-values color)))
	  (unless (string-match-p "^#\\(?:[a-fA-F0-9][a-fA-F0-9][a-fA-F0-9]\\)+$" color)
	    (setq color (format "#%04X%04X%04X"
				(logand 65535 (nth 0 components))
				(logand 65535 (nth 1 components))
				(logand 65535 (nth 2 components))))))))
    (when msg (message "Color: `%s'" color))
    color))

(defun face-at-point (&optional thing multiple)
  "Return the face of the character after point.
If it has more than one face, return the first one.
If THING is non-nil try first to get a face name from the buffer.
IF MULTIPLE is non-nil, return a list of all faces.
Return nil if there is no face."
  (let (faces)
    (if thing
        ;; Try to get a face name from the buffer.
        (let ((face (intern-soft (thing-at-point 'symbol))))
          (if (facep face)
              (push face faces))))
    ;; Add the named faces that the `read-face-name' or `face' property uses.
    (let ((faceprop (or (get-char-property (point) 'read-face-name)
                        (get-char-property (point) 'face))))
      (cond ((facep faceprop)
             (push faceprop faces))
            ((and (listp faceprop)
                  ;; Don't treat an attribute spec as a list of faces.
                  (not (keywordp (car faceprop)))
                  (not (memq (car faceprop)
                             '(foreground-color background-color))))
             (dolist (face faceprop)
               (if (facep face)
                   (push face faces))))))
    (setq faces (delete-dups (nreverse faces)))
    (if multiple faces (car faces))))

(defun foreground-color-at-point ()
  "Return the foreground color of the character after point."
  ;; `face-at-point' alone is not sufficient.  It only gets named faces.
  ;; Need also pick up any face properties that are not associated with named faces.
  (let ((face (or (face-at-point)
		  (get-char-property (point) 'read-face-name)
		  (get-char-property (point) 'face))))
    (cond ((and face (symbolp face))
	   (let ((value (face-foreground face nil 'default)))
	     (if (member value '("unspecified-fg" "unspecified-bg"))
		 nil
	       value)))
	  ((consp face)
	   (cond ((memq 'foreground-color face) (cdr (memq 'foreground-color face)))
		 ((memq ':foreground face) (cadr (memq ':foreground face)))))
	  (t nil))))			; Invalid face value.

(defun background-color-at-point ()
  "Return the background color of the character after point."
  ;; `face-at-point' alone is not sufficient.  It only gets named faces.
  ;; Need also pick up any face properties that are not associated with named faces.
  (let ((face (or (face-at-point)
		  (get-char-property (point) 'read-face-name)
		  (get-char-property (point) 'face))))
    (cond ((and face (symbolp face))
	   (let ((value (face-background face nil 'default)))
	     (if (member value '("unspecified-fg" "unspecified-bg"))
		 nil
	       value)))
	  ((consp face)
	   (cond ((memq 'background-color face) (cdr (memq 'background-color face)))
		 ((memq ':background face) (cadr (memq ':background face)))))
	  (t nil))))			; Invalid face value.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Frame creation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare-function x-display-list "xfns.c" ())
(declare-function x-open-connection "xfns.c"
		  (display &optional xrm-string must-succeed))
(declare-function x-get-resource "frame.c"
		  (attribute class &optional component subclass))
(declare-function x-parse-geometry "frame.c" (string))
(defvar x-display-name)

(defun x-handle-named-frame-geometry (parameters)
  "Add geometry parameters for a named frame to parameter list PARAMETERS.
Value is the new parameter list."
  ;; Note that `x-resource-name' has a global meaning.
  (let ((x-resource-name (cdr (assq 'name parameters))))
    (when x-resource-name
      ;; Before checking X resources, we must have an X connection.
      (or (window-system)
	  (x-display-list)
	  (x-open-connection (or (cdr (assq 'display parameters))
				 x-display-name)))
      (let (res-geometry parsed)
	(and (setq res-geometry (x-get-resource "geometry" "Geometry"))
	     (setq parsed (x-parse-geometry res-geometry))
	     (setq parameters
		   (append parameters parsed
			   ;; If the resource specifies a position,
			   ;; take note of that.
			   (if (or (assq 'top parsed) (assq 'left parsed))
			       '((user-position . t) (user-size . t)))))))))
  parameters)


(defun x-handle-reverse-video (frame parameters)
  "Handle the reverse-video frame parameter and X resource.
`x-create-frame' does not handle this one."
  (when (cdr (or (assq 'reverse parameters)
		 (let ((resource (x-get-resource "reverseVideo"
						 "ReverseVideo")))
		   (if resource
		       (cons nil (member (downcase resource)
					 '("on" "true")))))))
      (let* ((params (frame-parameters frame))
	     (bg (cdr (assq 'foreground-color params)))
	     (fg (cdr (assq 'background-color params))))
	(modify-frame-parameters frame
				 (list (cons 'foreground-color fg)
				       (cons 'background-color bg)))
	(if (equal bg (cdr (assq 'border-color params)))
	    (modify-frame-parameters frame
				     (list (cons 'border-color fg))))
	(if (equal bg (cdr (assq 'mouse-color params)))
	    (modify-frame-parameters frame
				     (list (cons 'mouse-color fg))))
	(if (equal bg (cdr (assq 'cursor-color params)))
	    (modify-frame-parameters frame
				     (list (cons 'cursor-color fg)))))))

(declare-function x-create-frame "xfns.c" (parms))
(declare-function x-setup-function-keys "term/common-win" (frame))

(defun x-create-frame-with-faces (&optional parameters)
  "Create and return a frame with frame parameters PARAMETERS.
If PARAMETERS specify a frame name, handle X geometry resources
for that name.  If PARAMETERS includes a `reverse' parameter, or
the X resource ``reverseVideo'' is present, handle that."
  (setq parameters (x-handle-named-frame-geometry parameters))
  (let* ((params (copy-tree parameters))
	 (visibility-spec (assq 'visibility parameters))
	 (delayed-params '(foreground-color background-color font
			   border-color cursor-color mouse-color
			   visibility scroll-bar-foreground
			   scroll-bar-background))
	 frame success)
    (dolist (param delayed-params)
      (setq params (assq-delete-all param params)))
    (setq frame (x-create-frame `((visibility . nil) . ,params)))
    (unwind-protect
	(progn
	  (x-setup-function-keys frame)
	  (x-handle-reverse-video frame parameters)
	  (frame-set-background-mode frame t)
	  (face-set-after-frame-default frame parameters)
	  (if (null visibility-spec)
	      (make-frame-visible frame)
	    (modify-frame-parameters frame (list visibility-spec)))
	  (setq success t))
      (unless success
	(delete-frame frame)))
    frame))

(defun face-set-after-frame-default (frame &optional parameters)
  "Initialize the frame-local faces of FRAME.
Calculate the face definitions using the face specs, custom theme
settings, X resources, and `face-new-frame-defaults'.
Finally, apply any relevant face attributes found amongst the
frame parameters in PARAMETERS."
  (let ((window-system-p (memq (window-system frame) '(x w32))))
    ;; The `reverse' is so that `default' goes first.
    (dolist (face (nreverse (face-list)))
      (condition-case ()
	  (progn
	    ;; Initialize faces from face spec and custom theme.
	    (face-spec-recalc face frame)
	    ;; Apply attributes specified by face-new-frame-defaults
	    (internal-merge-in-global-face face frame))
	;; Don't let invalid specs prevent frame creation.
	(error nil))))

  ;; Apply attributes specified by frame parameters.
  (let ((face-params '((foreground-color default :foreground)
  		       (background-color default :background)
                       (font default :font)
  		       (border-color border :background)
  		       (cursor-color cursor :background)
  		       (scroll-bar-foreground scroll-bar :foreground)
  		       (scroll-bar-background scroll-bar :background)
  		       (mouse-color mouse :background))))
    (dolist (param face-params)
      (let* ((param-name (nth 0 param))
  	     (value (cdr (assq param-name parameters))))
  	(if value
  	    (set-face-attribute (nth 1 param) frame
				(nth 2 param) value))))))

(defun tty-handle-reverse-video (frame parameters)
  "Handle the reverse-video frame parameter for terminal frames."
  (when (cdr (assq 'reverse parameters))
    (let* ((params (frame-parameters frame))
	   (bg (cdr (assq 'foreground-color params)))
	   (fg (cdr (assq 'background-color params))))
      (modify-frame-parameters frame
			       (list (cons 'foreground-color fg)
				     (cons 'background-color bg)))
      (if (equal bg (cdr (assq 'mouse-color params)))
	  (modify-frame-parameters frame
				   (list (cons 'mouse-color fg))))
      (if (equal bg (cdr (assq 'cursor-color params)))
	  (modify-frame-parameters frame
				   (list (cons 'cursor-color fg)))))))


(defun tty-create-frame-with-faces (&optional parameters)
  "Create and return a frame from optional frame parameters PARAMETERS.
If PARAMETERS contains a `reverse' parameter, handle that."
  (let ((frame (make-terminal-frame parameters))
	success)
    (unwind-protect
	(with-selected-frame frame
	  (tty-handle-reverse-video frame (frame-parameters frame))

          (unless (terminal-parameter frame 'terminal-initted)
            (set-terminal-parameter frame 'terminal-initted t)
            (set-locale-environment nil frame)
            (tty-run-terminal-initialization frame nil t))
	  (frame-set-background-mode frame t)
	  (face-set-after-frame-default frame parameters)
	  (setq success t))
      (unless success
	(delete-frame frame)))
    frame))

(defun tty-find-type (pred type)
  "Return the longest prefix of TYPE to which PRED returns non-nil.
TYPE should be a tty type name such as \"xterm-16color\".

The function tries only those prefixes that are followed by a
dash or underscore in the original type name, like \"xterm\" in
the above example."
  (let (hyphend)
    (while (and type
		(not (funcall pred type)))
      ;; Strip off last hyphen and what follows, then try again
      (setq type
	    (if (setq hyphend (string-match-p "[-_][^-_]+$" type))
		(substring type 0 hyphend)
	      nil))))
  type)

(defvar tty-setup-hook nil
  "Hook run after running the initialization function of a new text terminal.
Specifically, `tty-run-terminal-initialization' runs this.
This can be used to fine tune the `input-decode-map', for example.")

(defun tty-run-terminal-initialization (frame &optional type run-hook)
  "Run the special initialization code for the terminal type of FRAME.
The optional TYPE parameter may be used to override the autodetected
terminal type to a different value.

If optional argument RUN-HOOK is non-nil, then as a final step,
this runs the hook `tty-setup-hook'.

If you set `term-file-prefix' to nil, this function does nothing."
  (setq type (or type (tty-type frame)))
  ;; Load library for our terminal type.
  ;; User init file can set term-file-prefix to nil to prevent this.
  (with-selected-frame frame
    (unless (null term-file-prefix)
      (let* (term-init-func)
	;; First, load the terminal initialization file, if it is
	;; available and it hasn't been loaded already.
	(tty-find-type #'(lambda (type)
			   (let ((file (locate-library (concat term-file-prefix type))))
			     (and file
				  (or (assoc file load-history)
				      (load file t t)))))
		       type)
	;; Next, try to find a matching initialization function, and call it.
	(tty-find-type #'(lambda (type)
			   (fboundp (setq term-init-func
					  (intern (concat "terminal-init-" type)))))
		       type)
	(when (fboundp term-init-func)
	  (funcall term-init-func))
	(set-terminal-parameter frame 'terminal-initted term-init-func)
	(if run-hook (run-hooks 'tty-setup-hook))))))

;; Called from C function init_display to initialize faces of the
;; dumped terminal frame on startup.

(defun tty-set-up-initial-frame-faces ()
  (let ((frame (selected-frame)))
    (frame-set-background-mode frame t)
    (face-set-after-frame-default frame)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Standard faces.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup basic-faces nil
  "The standard faces of Emacs."
  :group 'faces)

(defface default
  '((t nil)) ; If this were nil, face-defface-spec would not be set.
  "Basic default face."
  :group 'basic-faces)

(defface bold
  '((t :weight bold))
  "Basic bold face."
  :group 'basic-faces)

(defface italic
  '((((supports :slant italic))
     :slant italic)
    (((supports :underline t))
     :underline t)
    (t
     ;; Default to italic, even if it doesn't appear to be supported,
     ;; because in some cases the display engine will do its own
     ;; workaround (to `dim' on ttys).
     :slant italic))
  "Basic italic face."
  :group 'basic-faces)

(defface bold-italic
  '((t :weight bold :slant italic))
  "Basic bold-italic face."
  :group 'basic-faces)

(defface underline
  '((((supports :underline t))
     :underline t)
    (((supports :weight bold))
     :weight bold)
    (t :underline t))
  "Basic underlined face."
  :group 'basic-faces)

(defface fixed-pitch
  '((t :family "Monospace"))
  "The basic fixed-pitch face."
  :group 'basic-faces)

(defface variable-pitch
  '((t :family "Sans Serif"))
  "The basic variable-pitch face."
  :group 'basic-faces)

(defface shadow
  '((((class color grayscale) (min-colors 88) (background light))
     :foreground "grey50")
    (((class color grayscale) (min-colors 88) (background dark))
     :foreground "grey70")
    (((class color) (min-colors 8) (background light))
     :foreground "green")
    (((class color) (min-colors 8) (background dark))
     :foreground "yellow"))
  "Basic face for shadowed text."
  :group 'basic-faces
  :version "22.1")

(defface link
  '((((class color) (min-colors 88) (background light))
     :foreground "RoyalBlue3" :underline t)
    (((class color) (background light))
     :foreground "blue" :underline t)
    (((class color) (min-colors 88) (background dark))
     :foreground "cyan1" :underline t)
    (((class color) (background dark))
     :foreground "cyan" :underline t)
    (t :inherit underline))
  "Basic face for unvisited links."
  :group 'basic-faces
  :version "22.1")

(defface link-visited
  '((default :inherit link)
    (((class color) (background light)) :foreground "magenta4")
    (((class color) (background dark)) :foreground "violet"))
  "Basic face for visited links."
  :group 'basic-faces
  :version "22.1")

(defface highlight
  '((((class color) (min-colors 88) (background light))
     :background "darkseagreen2")
    (((class color) (min-colors 88) (background dark))
     :background "darkolivegreen")
    (((class color) (min-colors 16) (background light))
     :background "darkseagreen2")
    (((class color) (min-colors 16) (background dark))
     :background "darkolivegreen")
    (((class color) (min-colors 8))
     :background "green" :foreground "black")
    (t :inverse-video t))
  "Basic face for highlighting."
  :group 'basic-faces)

;; Region face: under NS, default to the system-defined selection
;; color (optimized for the fixed white background of other apps),
;; if background is light.
(defface region
  '((((class color) (min-colors 88) (background dark))
     :background "blue3")
    (((class color) (min-colors 88) (background light) (type gtk))
     :distant-foreground "gtk_selection_fg_color"
     :background "gtk_selection_bg_color")
    (((class color) (min-colors 88) (background light) (type ns))
     :distant-foreground "ns_selection_fg_color"
     :background "ns_selection_bg_color")
    (((class color) (min-colors 88) (background light))
     :background "lightgoldenrod2")
    (((class color) (min-colors 16) (background dark))
     :background "blue3")
    (((class color) (min-colors 16) (background light))
     :background "lightgoldenrod2")
    (((class color) (min-colors 8))
     :background "blue" :foreground "white")
    (((type tty) (class mono))
     :inverse-video t)
    (t :background "gray"))
  "Basic face for highlighting the region."
  :version "21.1"
  :group 'basic-faces)

(defface secondary-selection
  '((((class color) (min-colors 88) (background light))
     :background "yellow1")
    (((class color) (min-colors 88) (background dark))
     :background "SkyBlue4")
    (((class color) (min-colors 16) (background light))
     :background "yellow")
    (((class color) (min-colors 16) (background dark))
     :background "SkyBlue4")
    (((class color) (min-colors 8))
     :background "cyan" :foreground "black")
    (t :inverse-video t))
  "Basic face for displaying the secondary selection."
  :group 'basic-faces)

(defface trailing-whitespace
  '((((class color) (background light))
     :background "red1")
    (((class color) (background dark))
     :background "red1")
    (t :inverse-video t))
  "Basic face for highlighting trailing whitespace."
  :version "21.1"
  :group 'basic-faces)

(defface escape-glyph
  '((((background dark)) :foreground "cyan")
    ;; See the comment in minibuffer-prompt for
    ;; the reason not to use blue on MS-DOS.
    (((type pc)) :foreground "magenta")
    ;; red4 is too dark, but some say blue is too loud.
    ;; brown seems to work ok. -- rms.
    (t :foreground "brown"))
  "Face for characters displayed as sequences using `^' or `\\'."
  :group 'basic-faces
  :version "22.1")

(defface nobreak-space
  '((((class color) (min-colors 88)) :inherit escape-glyph :underline t)
    (((class color) (min-colors 8)) :background "magenta")
    (t :inverse-video t))
  "Face for displaying nobreak space."
  :group 'basic-faces
  :version "22.1")

(defgroup mode-line-faces nil
  "Faces used in the mode line."
  :group 'mode-line
  :group 'faces
  :version "22.1")

(defface mode-line
  '((((class color) (min-colors 88))
     :box (:line-width -1 :style released-button)
     :background "grey75" :foreground "black")
    (t
     :inverse-video t))
  "Basic mode line face for selected window."
  :version "21.1"
  :group 'mode-line-faces
  :group 'basic-faces)

(defface mode-line-inactive
  '((default
     :inherit mode-line)
    (((class color) (min-colors 88) (background light))
     :weight light
     :box (:line-width -1 :color "grey75" :style nil)
     :foreground "grey20" :background "grey90")
    (((class color) (min-colors 88) (background dark) )
     :weight light
     :box (:line-width -1 :color "grey40" :style nil)
     :foreground "grey80" :background "grey30"))
  "Basic mode line face for non-selected windows."
  :version "22.1"
  :group 'mode-line-faces
  :group 'basic-faces)
(define-obsolete-face-alias 'modeline-inactive 'mode-line-inactive "22.1")

(defface mode-line-highlight
  '((((class color) (min-colors 88))
     :box (:line-width 2 :color "grey40" :style released-button))
    (t
     :inherit highlight))
  "Basic mode line face for highlighting."
  :version "22.1"
  :group 'mode-line-faces
  :group 'basic-faces)
(define-obsolete-face-alias 'modeline-highlight 'mode-line-highlight "22.1")

(defface mode-line-emphasis
  '((t (:weight bold)))
  "Face used to emphasize certain mode line features.
Use the face `mode-line-highlight' for features that can be selected."
  :version "23.1"
  :group 'mode-line-faces
  :group 'basic-faces)

(defface mode-line-buffer-id
  '((t (:weight bold)))
  "Face used for buffer identification parts of the mode line."
  :version "22.1"
  :group 'mode-line-faces
  :group 'basic-faces)
(define-obsolete-face-alias 'modeline-buffer-id 'mode-line-buffer-id "22.1")

(defface header-line
  '((default
     :inherit mode-line)
    (((type tty))
     ;; This used to be `:inverse-video t', but that doesn't look very
     ;; good when combined with inverse-video mode-lines and multiple
     ;; windows.  Underlining looks better, and is more consistent with
     ;; the window-system face variants, which deemphasize the
     ;; header-line in relation to the mode-line face.  If a terminal
     ;; can't underline, then the header-line will end up without any
     ;; highlighting; this may be too confusing in general, although it
     ;; happens to look good with the only current use of header-lines,
     ;; the info browser. XXX
     :inverse-video nil	       ;Override the value inherited from mode-line.
     :underline t)
    (((class color grayscale) (background light))
     :background "grey90" :foreground "grey20"
     :box nil)
    (((class color grayscale) (background dark))
     :background "grey20" :foreground "grey90"
     :box nil)
    (((class mono) (background light))
     :background "white" :foreground "black"
     :inverse-video nil
     :box nil
     :underline t)
    (((class mono) (background dark))
     :background "black" :foreground "white"
     :inverse-video nil
     :box nil
     :underline t))
  "Basic header-line face."
  :version "21.1"
  :group 'basic-faces)

(defface vertical-border
  '((((type tty)) :inherit mode-line-inactive))
  "Face used for vertical window dividers on ttys."
  :version "22.1"
  :group 'basic-faces)

(defface window-divider '((t :foreground "gray60"))
  "Basic face for window dividers.
When a divider is less than 3 pixels wide, it is drawn solidly
with the foreground of this face.  For larger dividers this face
is used for the inner part while the first pixel line/column is
drawn with the `window-divider-first-pixel' face and the last
pixel line/column with the `window-divider-last-pixel' face."
  :version "24.4"
  :group 'frames
  :group 'basic-faces)

(defface window-divider-first-pixel
  '((t :foreground "gray80"))
  "Basic face for first pixel line/column of window dividers.
When a divider is at least 3 pixels wide, its first pixel
line/column is drawn with the foreground of this face.  If you do
not want to accentuate the first pixel line/column, set this to
the same as `window-divider' face."
  :version "24.4"
  :group 'frames
  :group 'basic-faces)

(defface window-divider-last-pixel
  '((t :foreground "gray40"))
  "Basic face for last pixel line/column of window dividers.
When a divider is at least 3 pixels wide, its last pixel
line/column is drawn with the foreground of this face.  If you do
not want to accentuate the last pixel line/column, set this to
the same as `window-divider' face."
  :version "24.4"
  :group 'frames
  :group 'basic-faces)

(defface minibuffer-prompt
  '((((background dark)) :foreground "cyan")
    ;; Don't use blue because many users of the MS-DOS port customize
    ;; their foreground color to be blue.
    (((type pc)) :foreground "magenta")
    (t :foreground "medium blue"))
  "Face for minibuffer prompts.
By default, Emacs automatically adds this face to the value of
`minibuffer-prompt-properties', which is a list of text properties
used to display the prompt text."
  :version "22.1"
  :group 'basic-faces)

(setq minibuffer-prompt-properties
      (append minibuffer-prompt-properties (list 'face 'minibuffer-prompt)))

(defface fringe
  '((((class color) (background light))
     :background "grey95")
    (((class color) (background dark))
     :background "grey10")
    (t
     :background "gray"))
  "Basic face for the fringes to the left and right of windows under X."
  :version "21.1"
  :group 'frames
  :group 'basic-faces)

(defface scroll-bar '((t nil))
  "Basic face for the scroll bar colors under X."
  :version "21.1"
  :group 'frames
  :group 'basic-faces)

(defface border '((t nil))
  "Basic face for the frame border under X."
  :version "21.1"
  :group 'frames
  :group 'basic-faces)

(defface cursor
  '((((background light)) :background "black")
    (((background dark))  :background "white"))
  "Basic face for the cursor color under X.
Currently, only the `:background' attribute is meaningful; all
other attributes are ignored.  The cursor foreground color is
taken from the background color of the underlying text.

Note: Other faces cannot inherit from the cursor face."
  :version "21.1"
  :group 'cursor
  :group 'basic-faces)

(put 'cursor 'face-no-inherit t)

(defface mouse '((t nil))
  "Basic face for the mouse color under X."
  :version "21.1"
  :group 'mouse
  :group 'basic-faces)

(defface tool-bar
  '((default
     :box (:line-width 1 :style released-button)
     :foreground "black")
    (((type x w32 ns) (class color))
     :background "grey75")
    (((type x) (class mono))
     :background "grey"))
  "Basic tool-bar face."
  :version "21.1"
  :group 'basic-faces)

(defface menu
  '((((type tty))
     :inverse-video t)
    (((type x-toolkit))
     )
    (t
     :inverse-video t))
  "Basic face for the font and colors of the menu bar and popup menus."
  :version "21.1"
  :group 'menu
  :group 'basic-faces)

(defface help-argument-name '((t :inherit italic))
  "Face to highlight argument names in *Help* buffers."
  :group 'help)

(defface glyphless-char
  '((((type tty)) :inherit underline)
    (((type pc)) :inherit escape-glyph)
    (t :height 0.6))
  "Face for displaying non-graphic characters (e.g. U+202A (LRE)).
It is used for characters of no fonts too."
  :version "24.1"
  :group 'basic-faces)

(defface error
  '((default :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "Red1")
    (((class color) (min-colors 88) (background dark))  :foreground "Pink")
    (((class color) (min-colors 16) (background light)) :foreground "Red1")
    (((class color) (min-colors 16) (background dark))  :foreground "Pink")
    (((class color) (min-colors 8)) :foreground "red")
    (t :inverse-video t))
  "Basic face used to highlight errors and to denote failure."
  :version "24.1"
  :group 'basic-faces)

(defface warning
  '((default :weight bold)
    (((class color) (min-colors 16)) :foreground "DarkOrange")
    (((class color)) :foreground "yellow"))
  "Basic face used to highlight warnings."
  :version "24.1"
  :group 'basic-faces)

(defface success
  '((default :weight bold)
    (((class color) (min-colors 16) (background light)) :foreground "ForestGreen")
    (((class color) (min-colors 88) (background dark))  :foreground "Green1")
    (((class color) (min-colors 16) (background dark))  :foreground "Green")
    (((class color)) :foreground "green"))
  "Basic face used to indicate successful operation."
  :version "24.1"
  :group 'basic-faces)

;; Faces for TTY menus.
(defface tty-menu-enabled-face
  '((t
     :foreground "yellow" :background "blue" :weight bold))
  "Face for displaying enabled items in TTY menus."
  :group 'basic-faces)

(defface tty-menu-disabled-face
  '((((class color) (min-colors 16))
     :foreground "lightgray" :background "blue")
    (t
     :foreground "white" :background "blue"))
  "Face for displaying disabled items in TTY menus."
  :group 'basic-faces)

(defface tty-menu-selected-face
  '((t :background "red"))
  "Face for displaying the currently selected item in TTY menus."
  :group 'basic-faces)

(defgroup paren-showing-faces nil
  "Faces used to highlight paren matches."
  :group 'paren-showing
  :group 'faces
  :version "22.1")

(defface show-paren-match
  '((((class color) (background light))
     :background "turquoise")		; looks OK on tty (becomes cyan)
    (((class color) (background dark))
     :background "steelblue3")		; looks OK on tty (becomes blue)
    (((background dark))
     :background "grey50")
    (t
     :background "gray"))
  "Face used for a matching paren."
  :group 'paren-showing-faces)

(defface show-paren-mismatch
  '((((class color)) (:foreground "white" :background "purple"))
    (t (:inverse-video t)))
  "Face used for a mismatching paren."
  :group 'paren-showing-faces)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Manipulating font names.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This is here for compatibility with Emacs 20.2.  For example,
;; international/fontset.el uses x-resolve-font-name.  The following
;; functions are not used in the face implementation itself.

(defvar x-font-regexp nil)
(defvar x-font-regexp-head nil)
(defvar x-font-regexp-weight nil)
(defvar x-font-regexp-slant nil)

(defconst x-font-regexp-weight-subnum 1)
(defconst x-font-regexp-slant-subnum 2)
(defconst x-font-regexp-swidth-subnum 3)
(defconst x-font-regexp-adstyle-subnum 4)

;;; Regexps matching font names in "Host Portable Character Representation."
;;;
(let ((- 		"[-?]")
      (foundry		"[^-]+")
      (family 		"[^-]+")
      (weight		"\\(bold\\|demibold\\|medium\\)")		; 1
;     (weight\?		"\\(\\*\\|bold\\|demibold\\|medium\\|\\)")	; 1
      (weight\?		"\\([^-]*\\)")					; 1
      (slant		"\\([ior]\\)")					; 2
;     (slant\?		"\\([ior?*]?\\)")				; 2
      (slant\?		"\\([^-]?\\)")					; 2
;     (swidth		"\\(\\*\\|normal\\|semicondensed\\|\\)")	; 3
      (swidth		"\\([^-]*\\)")					; 3
;     (adstyle		"\\(\\*\\|sans\\|\\)")				; 4
      (adstyle		"\\([^-]*\\)")					; 4
      (pixelsize	"[0-9]+")
      (pointsize	"[0-9][0-9]+")
      (resx		"[0-9][0-9]+")
      (resy		"[0-9][0-9]+")
      (spacing		"[cmp?*]")
      (avgwidth		"[0-9]+")
      (registry		"[^-]+")
      (encoding		"[^-]+")
      )
  (setq x-font-regexp
	(purecopy (concat "\\`\\*?[-?*]"
		foundry - family - weight\? - slant\? - swidth - adstyle -
		pixelsize - pointsize - resx - resy - spacing - avgwidth -
		registry - encoding "\\*?\\'"
		)))
  (setq x-font-regexp-head
	(purecopy (concat "\\`[-?*]" foundry - family - weight\? - slant\?
		"\\([-*?]\\|\\'\\)")))
  (setq x-font-regexp-slant (purecopy (concat - slant -)))
  (setq x-font-regexp-weight (purecopy (concat - weight -)))
  nil)


(defun x-resolve-font-name (pattern &optional face frame)
  "Return a font name matching PATTERN.
All wildcards in PATTERN are instantiated.
If PATTERN is nil, return the name of the frame's base font, which never
contains wildcards.
Given optional arguments FACE and FRAME, return a font which is
also the same size as FACE on FRAME, or fail."
  (and (eq frame t)
       (setq frame nil))
  (if pattern
      ;; Note that x-list-fonts has code to handle a face with nil as its font.
      (let ((fonts (x-list-fonts pattern face frame 1)))
	(or fonts
	    (if face
		(if (string-match-p "\\*" pattern)
		    (if (null (face-font face))
			(error "No matching fonts are the same height as the frame default font")
		      (error "No matching fonts are the same height as face `%s'" face))
		  (if (null (face-font face))
		      (error "Height of font `%s' doesn't match the frame default font"
			     pattern)
		    (error "Height of font `%s' doesn't match face `%s'"
			   pattern face)))
	      (error "No fonts match `%s'" pattern)))
	(car fonts))
    (cdr (assq 'font (frame-parameters (selected-frame))))))

(defcustom font-list-limit 100
  "This variable is obsolete and has no effect."
  :type 'integer
  :group 'display)
(make-obsolete-variable 'font-list-limit nil "24.3")

(provide 'faces)

;;; faces.el ends here
