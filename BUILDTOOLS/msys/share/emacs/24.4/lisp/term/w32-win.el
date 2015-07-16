;;; w32-win.el --- parse switches controlling interface with W32 window system -*- lexical-binding: t -*-

;; Copyright (C) 1993-1994, 2001-2014 Free Software Foundation, Inc.

;; Author: Kevin Gallo
;; Keywords: terminals

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

;; w32-win.el:  this file is loaded from ../lisp/startup.el when it recognizes
;; that W32 windows are to be used.  Command line switches are parsed and those
;; pertaining to W32 are processed and removed from the command line.  The
;; W32 display is opened and hooks are set for popping up the initial window.

;; startup.el will then examine startup files, and eventually call the hooks
;; which create the first window (s).

;;; Code:


;; These are the standard X switches from the Xt Initialize.c file of
;; Release 4.

;; Command line		Resource Manager string

;; +rv			*reverseVideo
;; +synchronous		*synchronous
;; -background		*background
;; -bd			*borderColor
;; -bg			*background
;; -bordercolor		*borderColor
;; -borderwidth		.borderWidth
;; -bw			.borderWidth
;; -display		.display
;; -fg			*foreground
;; -fn			*font
;; -font		*font
;; -foreground		*foreground
;; -geometry		.geometry
;; -i			.iconType
;; -itype		.iconType
;; -iconic		.iconic
;; -name		.name
;; -reverse		*reverseVideo
;; -rv			*reverseVideo
;; -selectionTimeout    .selectionTimeout
;; -synchronous		*synchronous
;; -xrm

;; An alist of X options and the function which handles them.  See
;; ../startup.el.

;; (if (not (eq window-system 'w32))
;;     (error "%s: Loading w32-win.el but not compiled for w32" (invocation-name)))

(eval-when-compile (require 'cl-lib))
(require 'frame)
(require 'mouse)
(require 'scroll-bar)
(require 'faces)
(require 'select)
(require 'menu-bar)
(require 'dnd)
(require 'w32-vars)

;; Keep an obsolete alias for w32-focus-frame and w32-select-font in case
;; they are used by code outside Emacs.
(define-obsolete-function-alias 'w32-focus-frame 'x-focus-frame "23.1")
(declare-function x-select-font "w32font.c"
                  (&optional frame exclude-proportional))
(define-obsolete-function-alias 'w32-select-font 'x-select-font "23.1")

(defvar w32-color-map) ;; defined in w32fns.c
(make-obsolete 'w32-default-color-map nil "24.1")

(declare-function w32-send-sys-command "w32fns.c")
(declare-function set-message-beep "w32fns.c")

(declare-function cygwin-convert-file-name-from-windows "cygw32.c"
		  (path &optional absolute_p))

;; Conditional on new-fontset so bootstrapping works on non-GUI compiles
(if (fboundp 'new-fontset)
    (require 'fontset))

;; The following definition is used for debugging scroll bar events.
;(defun w32-handle-scroll-bar-event (event) (interactive "e") (princ event))

;; (defun w32-drag-n-drop-debug (event)
;;   "Print the drag-n-drop EVENT in a readable form."
;;   (interactive "e")
;;   (princ event))

(defun w32-handle-dropped-file (window file-name)
  (let ((f (if (eq system-type 'cygwin)
               (cygwin-convert-file-name-from-windows file-name t)
             (subst-char-in-string ?\\ ?/ file-name)))
        (coding (if (eq system-type 'windows-nt)
		    ;; Native w32 build pretends that its file names
		    ;; are encoded in UTF-8, and converts to the
		    ;; appropriate encoding internally.
		    'utf-8
		  (or file-name-coding-system
		      default-file-name-coding-system))))

    (setq file-name
          (mapconcat 'url-hexify-string
                     (split-string (encode-coding-string f coding)
                                   "/")
                     "/")))
		(dnd-handle-one-url window 'private
				    (concat
				     (if (eq system-type 'cygwin)
					 "file://"
				       "file:")
				     file-name)))

(defun w32-drag-n-drop (event &optional new-frame)
  "Edit the files listed in the drag-n-drop EVENT.
Switch to a buffer editing the last file dropped."
  (interactive "e")
  (save-excursion
    ;; Make sure the drop target has positive co-ords
    ;; before setting the selected frame - otherwise it
    ;; won't work.  <skx@tardis.ed.ac.uk>
    (let* ((window (posn-window (event-start event)))
	   (coords (posn-x-y (event-start event)))
	   (x (car coords))
	   (y (cdr coords)))
      (if (and (> x 0) (> y 0))
	  (set-frame-selected-window nil window))

      (when new-frame
        (select-frame (make-frame)))
      (raise-frame)
      (setq window (selected-window))

      (mapc (apply-partially #'w32-handle-dropped-file window)
            (car (cdr (cdr event)))))))

(defun w32-drag-n-drop-other-frame (event)
  "Edit the files listed in the drag-n-drop EVENT, in other frames.
May create new frames, or reuse existing ones.  The frame editing
the last file dropped is selected."
  (interactive "e")
  (w32-drag-n-drop event t))

;; Bind the drag-n-drop event.
(global-set-key [drag-n-drop] 'w32-drag-n-drop)
(global-set-key [C-drag-n-drop] 'w32-drag-n-drop-other-frame)

;; Keyboard layout/language change events
;; For now ignore language-change events; in the future
;; we should switch the Emacs Input Method to match the
;; new layout/language selected by the user.
(global-set-key [language-change] 'ignore)

(defvar x-resource-name)


;;;; Function keys

 ;;; make f10 activate the real menubar rather than the mini-buffer menu
 ;;; navigation feature.
 (defun w32-menu-bar-open (&optional frame)
   "Start key navigation of the menu bar in FRAME.

This initially activates the first menu-bar item, and you can then navigate
with the arrow keys, select a menu entry with the Return key or cancel with
the Escape key.  If FRAME has no menu bar, this function does nothing.

If FRAME is nil or not given, use the selected frame.
If FRAME does not have the menu bar enabled, display a text menu using
`tmm-menubar'."
   (interactive "i")
   (if menu-bar-mode
       (w32-send-sys-command ?\xf100 frame)
     (with-selected-frame (or frame (selected-frame))
       (tmm-menubar))))


;; W32 systems have different fonts than commonly found on X, so
;; we define our own standard fontset here.
(defvar w32-standard-fontset-spec
 "-*-Courier New-normal-r-*-*-13-*-*-*-c-*-fontset-standard"
 "String of fontset spec of the standard fontset.
This defines a fontset consisting of the Courier New variations for
European languages which are distributed with Windows as
\"Multilanguage Support\".

See the documentation of `create-fontset-from-fontset-spec' for the format.")

(defun x-win-suspend-error ()
  "Report an error when a suspend is attempted.
This returns an error if any Emacs frames are X frames, or always under W32."
  (error "Suspending an Emacs running under W32 makes no sense"))

(defvar dynamic-library-alist)
(defvar libpng-version)                 ; image.c #ifdef HAVE_NTGUI

;;; Set default known names for external libraries
(setq dynamic-library-alist
      (list
       '(xpm "libxpm.dll" "xpm4.dll" "libXpm-nox4.dll")
       ;; Versions of libpng 1.4.x and later are incompatible with
       ;; earlier versions.  Set up the list of libraries according to
       ;; the version we were compiled against.  (If we were compiled
       ;; without PNG support, libpng-version's value is -1.)
       (if (>= libpng-version 10400)
	   (let ((major (/ libpng-version 10000))
		 (minor (mod (/ libpng-version 100) 10)))
	     (list 'png
		   ;; libpngXY.dll is the default name when building
		   ;; with CMake or from a lpngXYY tarball on w32,
		   ;; libpngXY-XY.dll is the DLL name when building
		   ;; with libtool / autotools
		   (format "libpng%d%d.dll" major minor)
		   (format "libpng%d%d-%d%d.dll" major minor major minor)))
	 '(png "libpng12d.dll" "libpng12.dll" "libpng3.dll" "libpng.dll"
	       ;; these are libpng 1.2.8 from GTK+
	       "libpng13d.dll" "libpng13.dll"))
       '(tiff "libtiff-5.dll" "libtiff3.dll" "libtiff.dll")
       (if (> libjpeg-version 62)
	   ;; Versions of libjpeg after 6b are incompatible with
	   ;; earlier versions, and each of versions 7, 8, and 9 is
	   ;; also incompatible with the preceding ones (the core data
	   ;; structures used for communications with the library
	   ;; gained additional members with each new version).  So we
	   ;; must use only the version of the library which Emacs was
	   ;; compiled against.
	   (list 'jpeg (format "libjpeg-%d.dll" (/ libjpeg-version 10)))
	 '(jpeg "jpeg62.dll" "libjpeg.dll" "jpeg-62.dll" "jpeg.dll"))
       ;; Versions of giflib 5.0.0 and later changed signatures of
       ;; several functions used by Emacs, which makes those versions
       ;; incompatible with previous ones.  We select the correct
       ;; libraries according to the version of giflib we were
       ;; compiled against.  (If we were compiled without GIF support,
       ;; libgif-version's value is -1.)
       (if (>= libgif-version 50100)
	   ;; Yes, giflib 5.0 uses 6 as the major version of the API,
	   ;; and giflib 5.1 uses 7, thus "libgif-7.dll" and
	   ;; "libgif-6.dll" below (giflib 4.x used 5 as the major API
	   ;; version).  giflib5.dll is from the lua-files project,
	   ;; and gif.dll is from luapower.
	   '(gif "libgif-7.dll")
	 (if (>= libgif-version 50000)
	     '(gif "libgif-6.dll" "giflib5.dll" "gif.dll")
	 '(gif "libgif-5.dll" "giflib4.dll" "libungif4.dll" "libungif.dll")))
       '(svg "librsvg-2-2.dll")
       '(gdk-pixbuf "libgdk_pixbuf-2.0-0.dll")
       '(glib "libglib-2.0-0.dll")
       '(gobject "libgobject-2.0-0.dll")
       '(gnutls "libgnutls-28.dll" "libgnutls-26.dll")
       '(libxml2 "libxml2-2.dll" "libxml2.dll")
       '(zlib "zlib1.dll" "libz-1.dll")))

;;; multi-tty support
(defvar w32-initialized nil
  "Non-nil if the w32 window system has been initialized.")

(declare-function x-open-connection "w32fns.c"
                  (display &optional xrm-string must-succeed))
(declare-function create-default-fontset "fontset" ())
(declare-function create-fontset-from-fontset-spec "fontset"
                  (fontset-spec &optional style-variant noerror))
(declare-function create-fontset-from-x-resource "fontset" ())
(declare-function x-get-resource "frame.c"
                  (attribute class &optional component subclass))
(declare-function x-handle-args "common-win" (args))
(declare-function x-parse-geometry "frame.c" (string))
(defvar x-command-line-resources)

(defun w32-initialize-window-system (&optional _display)
  "Initialize Emacs for W32 GUI frames."
  (cl-assert (not w32-initialized))

  ;; Do the actual Windows setup here; the above code just defines
  ;; functions and variables that we use now.

  (setq command-line-args (x-handle-args command-line-args))

  ;; Make sure we have a valid resource name.
  (or (stringp x-resource-name)
      (setq x-resource-name
            ;; Change any . or * characters in x-resource-name to hyphens,
            ;; so as not to choke when we use it in X resource queries.
            (replace-regexp-in-string "[.*]" "-" (invocation-name))))

  (x-open-connection "w32" x-command-line-resources
                     ;; Exit with a fatal error if this fails and we
                     ;; are the initial display
                     (eq initial-window-system 'w32))

  ;; Create the default fontset.
  (create-default-fontset)
  ;; Create the standard fontset.
  (condition-case err
      (create-fontset-from-fontset-spec w32-standard-fontset-spec t)
    (error (display-warning
	    'initialization
	    (format "Creation of the standard fontset failed: %s" err)
	    :error)))
  ;; Create fontset specified in X resources "Fontset-N" (N is 0, 1,...).
  (create-fontset-from-x-resource)

  ;; Apply a geometry resource to the initial frame.  Put it at the end
  ;; of the alist, so that anything specified on the command line takes
  ;; precedence.
  (let* ((res-geometry (x-get-resource "geometry" "Geometry"))
         parsed)
    (if res-geometry
        (progn
          (setq parsed (x-parse-geometry res-geometry))
          ;; If the resource specifies a position,
          ;; call the position and size "user-specified".
          (if (or (assq 'top parsed) (assq 'left parsed))
              (setq parsed (cons '(user-position . t)
                                 (cons '(user-size . t) parsed))))
          ;; All geometry parms apply to the initial frame.
          (setq initial-frame-alist (append initial-frame-alist parsed))
          ;; The size parms apply to all frames.
          (if (and (assq 'height parsed)
                   (not (assq 'height default-frame-alist)))
              (setq default-frame-alist
                    (cons (cons 'height (cdr (assq 'height parsed)))
                          default-frame-alist))
          (if (and (assq 'width parsed)
                   (not (assq 'width default-frame-alist)))
              (setq default-frame-alist
                    (cons (cons 'width (cdr (assq 'width parsed)))
                          default-frame-alist)))))))

  ;; Check the reverseVideo resource.
  (let ((case-fold-search t))
    (let ((rv (x-get-resource "reverseVideo" "ReverseVideo")))
      (if (and rv (string-match "^\\(true\\|yes\\|on\\)$" rv))
          (setq default-frame-alist
                (cons '(reverse . t) default-frame-alist)))))

  ;; Don't let Emacs suspend under Windows.
  (add-hook 'suspend-hook 'x-win-suspend-error)

  ;; Turn off window-splitting optimization; w32 is usually fast enough
  ;; that this is only annoying.
  (setq split-window-keep-point t)

  ;; W32 expects the menu bar cut and paste commands to use the clipboard.
  (menu-bar-enable-clipboard)

  ;; Don't show the frame name; that's redundant.
  (setq-default mode-line-frame-identification "  ")

  ;; Set to a system sound if you want a fancy bell.
  (set-message-beep 'ok)
  (x-apply-session-resources)
  (setq w32-initialized t))

(add-to-list 'display-format-alist '("\\`w32\\'" . w32))
(add-to-list 'handle-args-function-alist '(w32 . x-handle-args))
(add-to-list 'frame-creation-function-alist '(w32 . x-create-frame-with-faces))
(add-to-list 'window-system-initialization-alist '(w32 . w32-initialize-window-system))

(provide 'w32-win)

;;; w32-win.el ends here
