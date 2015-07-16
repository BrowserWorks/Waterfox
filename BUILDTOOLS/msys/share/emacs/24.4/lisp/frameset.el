;;; frameset.el --- save and restore frame and window setup -*- lexical-binding: t -*-

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Author: Juanma Barranquero <lekktu@gmail.com>
;; Keywords: convenience

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

;; This file provides a set of operations to save a frameset (the state
;; of all or a subset of the existing frames and windows), both
;; in-session and persistently, and restore it at some point in the
;; future.
;;
;; It should be noted that restoring the frames' windows depends on
;; the buffers they are displaying, but this package does not provide
;; any way to save and restore sets of buffers (see desktop.el for
;; that).  So, it's up to the user of frameset.el to make sure that
;; any relevant buffer is loaded before trying to restore a frameset.
;; When a window is restored and a buffer is missing, the window will
;; be deleted unless it is the last one in the frame, in which case
;; some previous buffer will be shown instead.

;;; Code:

(require 'cl-lib)


(cl-defstruct (frameset (:type vector) :named
                        (:constructor frameset--make)
			;; Copier is defined below.
			(:copier nil))

  "A frameset encapsulates a serializable view of a set of frames and windows.

It contains the following slots, which can be accessed with
\(frameset-SLOT fs) and set with (setf (frameset-SLOT fs) VALUE):

  version      A read-only version number, identifying the format
		 of the frameset struct.  Currently its value is 1.
  timestamp    A read-only timestamp, the output of `current-time'.
  app          A symbol, or a list whose first element is a symbol, which
		 identifies the creator of the frameset and related info;
		 for example, desktop.el sets this slot to a list
		 `(desktop . ,desktop-file-version).
  name         A string, the name of the frameset instance.
  description  A string, a description for user consumption (to show in
		 menus, messages, etc).
  properties   A property list, to store both frameset-specific and
		 user-defined serializable data.
  states       A list of items (FRAME-PARAMETERS . WINDOW-STATE), in no
		 particular order.  Each item represents a frame to be
		 restored.  FRAME-PARAMETERS is a frame's parameter alist,
		 extracted with (frame-parameters FRAME) and filtered
		 through `frameset-filter-params'.
		 WINDOW-STATE is the output of `window-state-get' applied
		 to the root window of the frame.

To avoid collisions, it is recommended that applications wanting to add
private serializable data to `properties' either store all info under a
single, distinctive name, or use property names with a well-chosen prefix.

A frameset is intended to be used through the following simple API:

 - `frameset-save', the type's constructor, captures all or a subset of the
   live frames, and returns a serializable snapshot of them (a frameset).
 - `frameset-restore' takes a frameset, and restores the frames and windows
   it describes, as faithfully as possible.
 - `frameset-p' is the predicate for the frameset type.
 - `frameset-valid-p' checks a frameset's validity.
 - `frameset-copy' returns a deep copy of a frameset.
 - `frameset-prop' is a `setf'able accessor for the contents of the
   `properties' slot.
 - The `frameset-SLOT' accessors described above."

  (version     1              :read-only t)
  (timestamp   (current-time) :read-only t)
  (app         nil)
  (name        nil)
  (description nil)
  (properties  nil)
  (states      nil))

;; Add nicer docstrings for built-in predicate and accessors.
(put 'frameset-p 'function-documentation
     "Return non-nil if OBJECT is a frameset, nil otherwise.\n\n(fn OBJECT)")
(put 'frameset-version 'function-documentation
     "Return the version number of FRAMESET.\n
It is an integer that identifies the format of the frameset struct.
This slot cannot be modified.\n\n(fn FRAMESET)")
(put 'frameset-timestamp 'function-documentation
     "Return the creation timestamp of FRAMESET.\n
The value is in the format returned by `current-time'.
This slot cannot be modified.\n\n(fn FRAMESET)")
(put 'frameset-app 'function-documentation
     "Return the application identifier for FRAMESET.\n
The value is either a symbol, like `my-app', or a list
\(my-app ADDITIONAL-DATA...).\n\n(fn FRAMESET)")
(put 'frameset-name 'function-documentation
     "Return the name of FRAMESET (a string).\n\n(fn FRAMESET)")
(put 'frameset-description 'function-documentation
     "Return the description of FRAMESET (a string).\n\n(fn FRAMESET)")
(put 'frameset-properties 'function-documentation
     "Return the property list of FRAMESET.\n
This list is useful to store both frameset-specific and user-defined
serializable data.  The simplest way to access and modify it is
through `frameset-prop' (which see).\n\n(fn FRAMESET)")
(put 'frameset-states 'function-documentation
     "Return the list of frame states of FRAMESET.\n
A frame state is a pair (FRAME-PARAMETERS . WINDOW-STATE), where
FRAME-PARAMETERS is a frame's parameter alist, extracted with
\(frame-parameters FRAME) and filtered through `frameset-filter-params',
and WINDOW-STATE is the output of `window-state-get' applied to the
root window of the frame.\n
IMPORTANT: Modifying this slot may cause frameset functions to fail,
unless the type constraints defined above are respected.\n\n(fn FRAMESET)")

;; We autoloaded this for use in register.el, but now that we use registerv
;; objects, this autoload is not useful any more.
;; ;;;###autoload (autoload 'frameset-p "frameset"
;; ;;;###autoload   "Return non-nil if OBJECT is a frameset, nil otherwise." nil)

(defun frameset-copy (frameset)
  "Return a deep copy of FRAMESET.
FRAMESET is copied with `copy-tree'."
  (copy-tree frameset t))

(defun frameset-valid-p (object)
  "Return non-nil if OBJECT is a valid frameset, nil otherwise."
  (and (frameset-p object)
       (integerp (frameset-version object))
       (consp (frameset-timestamp object))
       (let ((app (frameset-app object)))
	 (or (null app)                   ; APP is nil
	     (symbolp app)                ; or a symbol
	     (and (consp app)             ; or a list
		  (symbolp (car app)))))  ; starting with a symbol
       (stringp (or (frameset-name object) ""))
       (stringp (or (frameset-description object) ""))
       (listp (frameset-properties object))
       (let ((states (frameset-states object)))
         (and (listp states)
              (cl-every #'consp (frameset-states object))))
       (frameset-version object)))        ; And VERSION is non-nil.

(defun frameset--prop-setter (frameset property value)
  "Setter function for `frameset-prop'.  Internal use only."
  (setf (frameset-properties frameset)
	(plist-put (frameset-properties frameset) property value))
  value)

;; A setf'able accessor to the frameset's properties
(defun frameset-prop (frameset property)
  "Return the value for FRAMESET of PROPERTY.

Properties can be set with

  (setf (frameset-prop FRAMESET PROPERTY) NEW-VALUE)"
  (declare (gv-setter frameset--prop-setter))
  (plist-get (frameset-properties frameset) property))


;; Filtering

;; What's the deal with these "filter alists"?
;;
;; Let's say that Emacs' frame parameters were never designed as a tool to
;; precisely record (or restore) a frame's state.  They grew organically,
;; and their uses and behaviors reflect their history.  In using them to
;; implement framesets, the unwary implementer, or the prospective package
;; writer willing to use framesets in their code, might fall victim of some
;; unexpected... oddities.
;;
;; You can find frame parameters that:
;;
;; - can be used to get and set some data from the frame's current state
;;   (`height', `width')
;; - can be set at creation time, and setting them afterwards has no effect
;;   (`window-state', `minibuffer')
;; - can be set at creation time, and setting them afterwards will fail with
;;   an error, *unless* you set it to the same value, a noop (`border-width')
;; - act differently when passed at frame creation time, and when set
;;   afterwards (`height')
;; - affect the value of other parameters (`name', `visibility')
;; - can be ignored by window managers (most positional args, like `height',
;;   `width', `left' and `top', and others, like `auto-raise', `auto-lower')
;; - can be set externally in X resources or Window registry (again, most
;;   positional parameters, and also `toolbar-lines', `menu-bar-lines' etc.)
;, - can contain references to live objects (`buffer-list', `minibuffer') or
;;   code (`buffer-predicate')
;; - are set automatically, and cannot be changed (`window-id', `parent-id'),
;;   but setting them produces no error
;; - have a noticeable effect in some window managers, and are ignored in
;;   others (`menu-bar-lines')
;; - can not be safely set in a tty session and then copied back to a GUI
;;   session (`font', `background-color', `foreground-color')
;;
;; etc etc.
;;
;; Which means that, in order to save a parameter alist to disk and read it
;; back later to reconstruct a frame, some processing must be done.  That's
;; what `frameset-filter-params' and the `frameset-*-filter-alist' variables
;; are for.
;;
;; First, a clarification.  The word "filter" in these names refers to both
;; common meanings of filter: to filter out (i.e., to remove), and to pass
;; through a transformation function (think `filter-buffer-substring').
;;
;; `frameset-filter-params' takes a parameter alist PARAMETERS, a filtering
;; alist FILTER-ALIST, and a flag SAVING to indicate whether we are filtering
;; parameters with the intent of saving a frame or restoring it.  It then
;; accumulates an output alist, FILTERED, by checking each parameter in
;; PARAMETERS against FILTER-ALIST and obeying any rule found there.  The
;; absence of a rule just means the parameter/value pair (called CURRENT in
;; filtering functions) is copied to FILTERED as is.  Keyword values :save,
;; :restore and :never tell the function to copy CURRENT to FILTERED in the
;; respective situations, that is, when saving, restoring, or never at all.
;; Values :save and :restore are not used in this package, because usually if
;; you don't want to save a parameter, you don't want to restore it either.
;; But they can be useful, for example, if you already have a saved frameset
;; created with some intent, and want to reuse it for a different objective
;; where the expected parameter list has different requirements.
;;
;; Finally, the value can also be a filtering function, or a filtering
;; function plus some arguments.  The function is called for each matching
;; parameter, and receives CURRENT (the parameter/value pair being processed),
;; FILTERED (the output alist so far), PARAMETERS (the full parameter alist),
;; SAVING (the save/restore flag), plus any additional ARGS set along the
;; function in the `frameset-*-filter-alist' entry.  The filtering function
;; then has the possibility to pass along CURRENT, or reject it altogether,
;; or pass back a (NEW-PARAM . NEW-VALUE) pair, which does not even need to
;; refer to the same parameter (so you can filter `width' and return `height'
;; and vice versa, if you're feeling silly and want to mess with the user's
;; mind).  As a help in deciding what to do, the filtering function has
;; access to PARAMETERS, but must not change it in any way.  It also has
;; access to FILTERED, which can be modified at will.  This allows two or
;; more filters to coordinate themselves, because in general there's no way
;; to predict the order in which they will be run.
;;
;; So, which parameters are filtered by default, and why? Let's see.
;;
;; - `buffer-list', `buried-buffer-list', `buffer-predicate': They contain
;;   references to live objects, or in the case of `buffer-predicate', it
;;   could also contain an fbound symbol (a predicate function) that could
;;   not be defined in a later session.
;;
;; - `window-id', `outer-window-id', `parent-id': They are assigned
;;   automatically and cannot be set, so keeping them is harmless, but they
;;   add clutter.  `window-system' is similar: it's assigned at frame
;;   creation, and does not serve any useful purpose later.
;;
;; - `left', `top': Only problematic when saving an iconified frame, because
;;   when the frame is iconified they are set to (- 32000), which doesn't
;;   really help in restoring the frame.  Better to remove them and let the
;;   window manager choose a default position for the frame.
;;
;; - `background-color', `foreground-color': In tty frames they can be set
;;   to "unspecified-bg" and "unspecified-fg", which aren't understood on
;;   GUI sessions.  They have to be filtered out when switching from tty to
;;   a graphical display.
;;
;; - `tty', `tty-type': These are tty-specific.  When switching to a GUI
;;   display they do no harm, but they clutter the parameter alist.
;;
;; - `minibuffer': It can contain a reference to a live window, which cannot
;;   be serialized.  Because of Emacs' idiosyncratic treatment of this
;;   parameter, frames created with (minibuffer . t) have a parameter
;;   (minibuffer . #<window...>), while frames created with
;;   (minibuffer . #<window...>) have (minibuffer . nil), which is madness
;;   but helps to differentiate between minibufferless and "normal" frames.
;;   So, changing (minibuffer . #<window...>) to (minibuffer . t) allows
;;   Emacs to set up the new frame correctly.  Nice, uh?
;;
;; - `name': If this parameter is directly set, `explicit-name' is
;;   automatically set to t, and then `name' no longer changes dynamically.
;;   So, in general, not saving `name' is the right thing to do, though
;;   surely there are applications that will want to override this filter.
;;
;; - `font', `fullscreen', `height' and `width': These parameters suffer
;;   from the fact that they are badly mangled when going through a
;;   tty session, though not all in the same way.  When saving a GUI frame
;;   and restoring it in a tty, the height and width of the new frame are
;;   those of the tty screen (let's say 80x25, for example); going back
;;   to a GUI session means getting frames of the tty screen size (so all
;;   your frames are 80 cols x 25 rows).  For `fullscreen' there's a
;;   similar problem, because a tty frame cannot really be fullscreen or
;;   maximized, so the state is lost.  The problem with `font' is a bit
;;   different, because a valid GUI font spec in `font' turns into
;;   (font . "tty") in a tty frame, and when read back into a GUI session
;;   it fails because `font's value is no longer a valid font spec.
;;
;; In most cases, the filtering functions just do the obvious thing: remove
;; CURRENT when it is meaningless to keep it, or pass a modified copy if
;; that helps (as in the case of `minibuffer').
;;
;; The exception are the parameters in the last set, which should survive
;; the roundtrip though tty-land.  The answer is to add "stashing
;; parameters", working in pairs, to shelve the GUI-specific contents and
;; restore it once we're back in pixel country.  That's what functions
;; `frameset-filter-shelve-param' and `frameset-filter-unshelve-param' do.
;;
;; Basically, if you set `frameset-filter-shelve-param' as the filter for
;; a parameter P, it will detect when it is restoring a GUI frame into a
;; tty session, and save P's value in the custom parameter X:P, but only
;; if X:P does not exist already (so it is not overwritten if you enter
;; the tty session more than once).  If you're not switching to a tty
;; frame, the filter just passes CURRENT along.
;;
;; The parameter X:P, on the other hand, must have been setup to be
;; filtered by `frameset-filter-unshelve-param', which unshelves the
;; value: if we're entering a GUI session, returns P instead of CURRENT,
;; while in other cases it just passes it along.
;;
;; The only additional trick is that `frameset-filter-shelve-param' does
;; not set P if switching back to GUI and P already has a value, because
;; it assumes that `frameset-filter-unshelve-param' did set it up.  And
;; `frameset-filter-unshelve-param', when unshelving P, must look into
;; FILTERED to determine if P has already been set and if so, modify it;
;; else just returns P.
;;
;; Currently, the value of X in X:P is `GUI', but you can use any prefix,
;; by passing its symbol as argument in the filter:
;;
;;   (my-parameter frameset-filter-shelve-param MYPREFIX)
;;
;; instead of
;;
;;   (my-parameter . frameset-filter-shelve-param)
;;
;; Note that `frameset-filter-unshelve-param' does not need MYPREFIX
;; because it is available from the parameter name in CURRENT.  Also note
;; that the colon between the prefix and the parameter name is hardcoded.
;; The reason is that X:P is quite readable, and that the colon is a
;; very unusual character in symbol names, other than in initial position
;; in keywords (emacs -Q has only two such symbols, and one of them is a
;; URL).  So the probability of a collision with existing or future
;; symbols is quite insignificant.
;;
;; Now, what about the filter alist variables? There are three of them,
;; though only two sets of parameters:
;;
;; - `frameset-session-filter-alist' contains these filters that allow to
;;   save and restore framesets in-session, without the need to serialize
;;   the frameset or save it to disk (for example, to save a frameset in a
;;   register and restore it later).  Filters in this list do not remove
;;   live objects, except in `minibuffer', which is dealt especially by
;;   `frameset-save' / `frameset-restore'.
;;
;; - `frameset-persistent-filter-alist' is the whole deal.  It does all
;;   the filtering described above, and the result is ready to be saved on
;;   disk without loss of information.  That's the format used by the
;;   desktop.el package, for example.
;;
;; IMPORTANT: These variables share structure and should NEVER be modified.
;;
;; - `frameset-filter-alist': The value of this variable is the default
;;   value for the FILTERS arguments of `frameset-save' and
;;   `frameset-restore'.  It is set to `frameset-persistent-filter-alist',
;;   though it can be changed by specific applications.
;;
;; How to use them?
;;
;; The simplest way is just do nothing.  The default should work
;; reasonably and sensibly enough.  But, what if you really need a
;; customized filter alist?  Then you can create your own variable
;;
;;   (defvar my-filter-alist
;;     '((my-param1 . :never)
;;       (my-param2 . :save)
;;       (my-param3 . :restore)
;;       (my-param4 . my-filtering-function-without-args)
;;       (my-param5   my-filtering-function-with arg1 arg2)
;;       ;;; many other parameters
;;       )
;;     "My customized parameter filter alist.")
;;
;; or, if you're only changing a few items,
;;
;;   (defvar my-filter-alist
;;     (nconc '((my-param1 . :never)
;;              (my-param2 . my-filtering-function))
;;            frameset-filter-alist)
;;     "My brief customized parameter filter alist.")
;;
;; and pass it to the FILTER arg of the save/restore functions,
;; ALWAYS taking care of not modifying the original lists; if you're
;; going to do any modifying of my-filter-alist, please use
;;
;;   (nconc '((my-param1 . :never) ...)
;;          (copy-sequence frameset-filter-alist))
;;
;; One thing you shouldn't forget is that they are alists, so searching
;; in them is sequential.  If you just want to change the default of
;; `name' to allow it to be saved, you can set (name . nil) in your
;; customized filter alist; it will take precedence over the latter
;; setting.  In case you decide that you *always* want to save `name',
;; you can add it to `frameset-filter-alist':
;;
;;   (push '(name . nil) frameset-filter-alist)
;;
;; In certain applications, having a parameter filtering function like
;; `frameset-filter-params' can be useful, even if you're not using
;; framesets.  The interface of `frameset-filter-params' is generic
;; and does not depend of global state, with one exception: it uses
;; the dynamically bound variable `frameset--target-display' to decide
;; if, and how, to modify the `display' parameter of FILTERED.  That
;; should not represent a problem, because it's only meaningful when
;; restoring, and customized uses of `frameset-filter-params' are
;; likely to use their own filter alist and just call
;;
;;   (setq my-filtered (frameset-filter-params my-params my-filters t))
;;
;; In case you want to use it with the standard filters, you can
;; wrap the call to `frameset-filter-params' in a let form to bind
;; `frameset--target-display' to nil or the desired value.
;;

;;;###autoload
(defvar frameset-session-filter-alist
  '((name            . :never)
    (left            . frameset-filter-iconified)
    (minibuffer      . frameset-filter-minibuffer)
    (top             . frameset-filter-iconified))
  "Minimum set of parameters to filter for live (on-session) framesets.
DO NOT MODIFY.  See `frameset-filter-alist' for a full description.")

;;;###autoload
(defvar frameset-persistent-filter-alist
  (nconc
   '((background-color   . frameset-filter-sanitize-color)
     (buffer-list        . :never)
     (buffer-predicate   . :never)
     (buried-buffer-list . :never)
     (font               . frameset-filter-shelve-param)
     (foreground-color   . frameset-filter-sanitize-color)
     (fullscreen         . frameset-filter-shelve-param)
     (GUI:font           . frameset-filter-unshelve-param)
     (GUI:fullscreen     . frameset-filter-unshelve-param)
     (GUI:height         . frameset-filter-unshelve-param)
     (GUI:width          . frameset-filter-unshelve-param)
     (height             . frameset-filter-shelve-param)
     (outer-window-id    . :never)
     (parent-id          . :never)
     (tty                . frameset-filter-tty-to-GUI)
     (tty-type           . frameset-filter-tty-to-GUI)
     (width              . frameset-filter-shelve-param)
     (window-id          . :never)
     (window-system      . :never))
   frameset-session-filter-alist)
  "Parameters to filter for persistent framesets.
DO NOT MODIFY.  See `frameset-filter-alist' for a full description.")

;;;###autoload
(defvar frameset-filter-alist frameset-persistent-filter-alist
  "Alist of frame parameters and filtering functions.

This alist is the default value of the FILTERS argument of
`frameset-save' and `frameset-restore' (which see).

Initially, `frameset-filter-alist' is set to, and shares the value of,
`frameset-persistent-filter-alist'.  You can override any item in
this alist by `push'ing a new item onto it.  If, for some reason, you
intend to modify existing values, do

  (setq frameset-filter-alist (copy-tree frameset-filter-alist))

before changing anything.

On saving, PARAMETERS is the parameter alist of each frame processed,
and FILTERED is the parameter alist that gets saved to the frameset.

On restoring, PARAMETERS is the parameter alist extracted from the
frameset, and FILTERED is the resulting frame parameter alist used
to restore the frame.

Elements of `frameset-filter-alist' are conses (PARAM . ACTION),
where PARAM is a parameter name (a symbol identifying a frame
parameter), and ACTION can be:

 nil       The parameter is copied to FILTERED.
 :never    The parameter is never copied to FILTERED.
 :save     The parameter is copied only when saving the frame.
 :restore  The parameter is copied only when restoring the frame.
 FILTER    A filter function.

FILTER can be a symbol FILTER-FUN, or a list (FILTER-FUN ARGS...).
FILTER-FUN is invoked with

  (apply FILTER-FUN CURRENT FILTERED PARAMETERS SAVING ARGS)

where

 CURRENT     A cons (PARAM . VALUE), where PARAM is the one being
	     filtered and VALUE is its current value.
 FILTERED    The resulting alist (so far).
 PARAMETERS  The complete alist of parameters being filtered,
 SAVING      Non-nil if filtering before saving state, nil if filtering
	       before restoring it.
 ARGS        Any additional arguments specified in the ACTION.

FILTER-FUN is allowed to modify items in FILTERED, but no other arguments.
It must return:
 nil                      Skip CURRENT (do not add it to FILTERED).
 t                        Add CURRENT to FILTERED as is.
 (NEW-PARAM . NEW-VALUE)  Add this to FILTERED instead of CURRENT.

Frame parameters not on this alist are passed intact, as if they were
defined with ACTION = nil.")

;; Dynamically bound in `frameset-save', `frameset-restore'.
(defvar frameset--target-display)
;; Either (display . VALUE) or nil.
;; This refers to the current frame config being processed with
;; `frameset-filter-params' and its auxiliary filtering functions.
;; If nil, there is no need to change the display.
;; If non-nil, display parameter to use when creating the frame.

(defun frameset-switch-to-gui-p (parameters)
  "True when switching to a graphic display.
Return non-nil if the parameter alist PARAMETERS describes a frame on a
text-only terminal, and the frame is being restored on a graphic display;
otherwise return nil.  Only meaningful when called from a filtering
function in `frameset-filter-alist'."
  (and frameset--target-display                   ; we're switching
       (null (cdr (assq 'display parameters)))    ; from a tty
       (cdr frameset--target-display)))           ; to a GUI display

(defun frameset-switch-to-tty-p (parameters)
  "True when switching to a text-only terminal.
Return non-nil if the parameter alist PARAMETERS describes a frame on a
graphic display, and the frame is being restored on a text-only terminal;
otherwise return nil.  Only meaningful when called from a filtering
function in `frameset-filter-alist'."
  (and frameset--target-display                   ; we're switching
       (cdr (assq 'display parameters))           ; from a GUI display
       (null (cdr frameset--target-display))))    ; to a tty

(defun frameset-filter-tty-to-GUI (_current _filtered parameters saving)
  "Remove CURRENT when switching from tty to a graphic display.

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (or saving
      (not (frameset-switch-to-gui-p parameters))))

(defun frameset-filter-sanitize-color (current _filtered parameters saving)
  "When switching to a GUI frame, remove \"unspecified\" colors.
Useful as a filter function for tty-specific parameters.

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (or saving
      (not (frameset-switch-to-gui-p parameters))
      (not (stringp (cdr current)))
      (not (string-match-p "^unspecified-[fb]g$" (cdr current)))))

(defun frameset-filter-minibuffer (current filtered _parameters saving)
  "Force the minibuffer parameter to have a sensible value.

When saving, convert (minibuffer . #<window>) to (minibuffer . t).
When restoring, if there are two copies, keep the one pointing to
a live window.

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (let ((value (cdr current)) mini)
    (cond (saving
	   (if (windowp value) '(minibuffer . t) t))
	  ((setq mini (assq 'minibuffer filtered))
	   (when (windowp value) (setcdr mini value))
	   nil)
	  (t t))))

(defun frameset-filter-shelve-param (current _filtered parameters saving
					     &optional prefix)
  "When switching to a tty frame, save parameter P as PREFIX:P.
The parameter can be later restored with `frameset-filter-unshelve-param'.
PREFIX defaults to `GUI'.

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (unless prefix (setq prefix 'GUI))
  (cond (saving t)
	((frameset-switch-to-tty-p parameters)
	 (let ((prefix:p (intern (format "%s:%s" prefix (car current)))))
	   (if (assq prefix:p parameters)
	       nil
	     (cons prefix:p (cdr current)))))
	((frameset-switch-to-gui-p parameters)
	 (not (assq (intern (format "%s:%s" prefix (car current))) parameters)))
	(t t)))

(defun frameset-filter-unshelve-param (current filtered parameters saving)
  "When switching to a GUI frame, restore PREFIX:P parameter as P.
CURRENT must be of the form (PREFIX:P . value).

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (or saving
      (not (frameset-switch-to-gui-p parameters))
      (let* ((prefix:p (symbol-name (car current)))
	     (p (intern (substring prefix:p
				   (1+ (string-match-p ":" prefix:p)))))
	     (val (cdr current))
	     (found (assq p filtered)))
	(if (not found)
	    (cons p val)
	  (setcdr found val)
	  nil))))

(defun frameset-filter-iconified (_current _filtered parameters saving)
  "Remove CURRENT when saving an iconified frame.
This is used for positional parameters `left' and `top', which are
meaningless in an iconified frame, so the frame is restored in a
default position.

For the meaning of CURRENT, FILTERED, PARAMETERS and SAVING,
see `frameset-filter-alist'."
  (not (and saving (eq (cdr (assq 'visibility parameters)) 'icon))))

(defun frameset-filter-params (parameters filter-alist saving)
  "Filter parameter alist PARAMETERS and return a filtered alist.
FILTER-ALIST is an alist of parameter filters, in the format of
`frameset-filter-alist' (which see).
SAVING is non-nil while filtering parameters to save a frameset,
nil while the filtering is done to restore it."
  (let ((filtered nil))
    (dolist (current parameters)
      ;; When saving, the parameter alist is temporary, so modifying it
      ;; is not a problem.  When restoring, the parameter alist is part
      ;; of a frameset, so we must copy parameters to avoid inadvertent
      ;; modifications.
      (pcase (cdr (assq (car current) filter-alist))
	(`nil
	 (push (if saving current (copy-tree current)) filtered))
	(:never
	 nil)
	(:restore
	 (unless saving (push (copy-tree current) filtered)))
	(:save
	 (when saving (push current filtered)))
	((or `(,fun . ,args) (and fun (pred fboundp)))
	 (let* ((this (apply fun current filtered parameters saving args))
		(val (if (eq this t) current this)))
	   (when val
	     (push (if saving val (copy-tree val)) filtered))))
	(other
	 (delay-warning 'frameset (format "Unknown filter %S" other) :error))))
    ;; Set the display parameter after filtering, so that filter functions
    ;; have access to its original value.
    (when frameset--target-display
      (let ((display (assq 'display filtered)))
	(if display
	    (setcdr display (cdr frameset--target-display))
	  (push frameset--target-display filtered))))
    filtered))


;; Frame ids

(defun frameset--set-id (frame)
  "Set FRAME's id if not yet set.
Internal use only."
  (unless (frame-parameter frame 'frameset--id)
    (set-frame-parameter frame
			 'frameset--id
			 (mapconcat (lambda (n) (format "%04X" n))
				    (cl-loop repeat 4 collect (random 65536))
				    "-"))))

(defun frameset-cfg-id (frame-cfg)
  "Return the frame id for frame configuration FRAME-CFG."
  (cdr (assq 'frameset--id frame-cfg)))

;;;###autoload
(defun frameset-frame-id (frame)
  "Return the frame id of FRAME, if it has one; else, return nil.
A frame id is a string that uniquely identifies a frame.
It is persistent across `frameset-save' / `frameset-restore'
invocations, and once assigned is never changed unless the same
frame is duplicated (via `frameset-restore'), in which case the
newest frame keeps the id and the old frame's is set to nil."
  (frame-parameter frame 'frameset--id))

;;;###autoload
(defun frameset-frame-id-equal-p (frame id)
  "Return non-nil if FRAME's id matches ID."
  (string= (frameset-frame-id frame) id))

;;;###autoload
(defun frameset-frame-with-id (id &optional frame-list)
  "Return the live frame with id ID, if exists; else nil.
If FRAME-LIST is a list of frames, check these frames only.
If nil, check all live frames."
  (cl-find-if (lambda (f)
		(and (frame-live-p f)
		     (frameset-frame-id-equal-p f id)))
	      (or frame-list (frame-list))))


;; Saving framesets

(defun frameset--record-minibuffer-relationships (frame-list)
  "Process FRAME-LIST and record minibuffer relationships.
FRAME-LIST is a list of frames.  Internal use only."
  ;; Record frames with their own minibuffer
  (dolist (frame (minibuffer-frame-list))
    (when (memq frame frame-list)
      (frameset--set-id frame)
      ;; For minibuffer-owning frames, frameset--mini is a cons
      ;; (t . DEFAULT?), where DEFAULT? is a boolean indicating whether
      ;; the frame is the one pointed out by `default-minibuffer-frame'.
      (set-frame-parameter frame
			   'frameset--mini
			   (cons t (eq frame default-minibuffer-frame)))))
  ;; Now link minibufferless frames with their minibuffer frames
  (dolist (frame frame-list)
    (unless (frame-parameter frame 'frameset--mini)
      (frameset--set-id frame)
      (let ((mb-frame (window-frame (minibuffer-window frame))))
	;; For minibufferless frames, frameset--mini is a cons
	;; (nil . FRAME-ID), where FRAME-ID is the frameset--id of
	;; the frame containing its minibuffer window.
	;; FRAME-ID can be set to nil, if FRAME-LIST doesn't contain
	;; the minibuffer frame of a minibufferless frame; we allow
	;; it without trying to second-guess the user.
	(set-frame-parameter frame
			     'frameset--mini
			     (cons nil
				   (and mb-frame
					(frameset-frame-id mb-frame))))))))

;;;###autoload
(cl-defun frameset-save (frame-list
			 &key app name description
			      filters predicate properties)
  "Return a frameset for FRAME-LIST, a list of frames.
Dead frames and non-frame objects are silently removed from the list.
If nil, FRAME-LIST defaults to the output of `frame-list' (all live frames).
APP, NAME and DESCRIPTION are optional data; see the docstring of the
`frameset' defstruct for details.
FILTERS is an alist of parameter filters; if nil, the value of the variable
`frameset-filter-alist' is used instead.
PREDICATE is a predicate function, which must return non-nil for frames that
should be saved; if PREDICATE is nil, all frames from FRAME-LIST are saved.
PROPERTIES is a user-defined property list to add to the frameset."
  (let* ((list (or (copy-sequence frame-list) (frame-list)))
	 (frameset--target-display nil)
	 (frames (cl-delete-if-not #'frame-live-p
				   (if predicate
				       (cl-delete-if-not predicate list)
				     list)))
	 fs)
    (frameset--record-minibuffer-relationships frames)
    (setq fs (frameset--make
	      :app app
	      :name name
	      :description description
	      :properties properties
	      :states (mapcar
		       (lambda (frame)
			 (cons
			  (frameset-filter-params (frame-parameters frame)
						  (or filters
						      frameset-filter-alist)
						  t)
			  (window-state-get (frame-root-window frame) t)))
		       frames)))
    (cl-assert (frameset-valid-p fs))
    fs))


;; Restoring framesets

;; Dynamically bound in `frameset-restore'.
(defvar frameset--reuse-list)
(defvar frameset--action-map)

(defun frameset-compute-pos (value left/top right/bottom)
  "Return an absolute positioning value for a frame.
VALUE is the value of a positional frame parameter (`left' or `top').
If VALUE is relative to the screen edges (like (+ -35) or (-200), it is
converted to absolute by adding it to the corresponding edge; if it is
an absolute position, it is returned unmodified.
LEFT/TOP and RIGHT/BOTTOM indicate the dimensions of the screen in
pixels along the relevant direction: either the position of the left
and right edges for a `left' positional parameter, or the position of
the top and bottom edges for a `top' parameter."
  (pcase value
    (`(+ ,val) (+ left/top val))
    (`(- ,val) (+ right/bottom val))
    (val val)))

(defun frameset-move-onscreen (frame force-onscreen)
  "If FRAME is offscreen, move it back onscreen and, if necessary, resize it.
For the description of FORCE-ONSCREEN, see `frameset-restore'.
When forced onscreen, frames wider than the monitor's workarea are converted
to fullwidth, and frames taller than the workarea are converted to fullheight.
NOTE: This only works for non-iconified frames."
  (pcase-let* ((`(,left ,top ,width ,height) (cl-cdadr (frame-monitor-attributes frame)))
	       (right (+ left width -1))
	       (bottom (+ top height -1))
	       (fr-left (frameset-compute-pos (frame-parameter frame 'left) left right))
	       (fr-top (frameset-compute-pos (frame-parameter frame 'top) top bottom))
	       (ch-width (frame-char-width frame))
	       (ch-height (frame-char-height frame))
	       (fr-width (max (frame-pixel-width frame) (* ch-width (frame-width frame))))
	       (fr-height (max (frame-pixel-height frame) (* ch-height (frame-height frame))))
	       (fr-right (+ fr-left fr-width -1))
	       (fr-bottom (+ fr-top fr-height -1)))
    (when (pcase force-onscreen
	    ;; A predicate.
	    ((pred functionp)
	     (funcall force-onscreen
		      frame
		      (list fr-left fr-top fr-width fr-height)
		      (list left top width height)))
	    ;; Any corner is outside the screen.
	    (:all (or (< fr-bottom top)  (> fr-bottom bottom)
		      (< fr-left   left) (> fr-left   right)
		      (< fr-right  left) (> fr-right  right)
		      (< fr-top    top)  (> fr-top    bottom)))
	    ;; Displaced to the left, right, above or below the screen.
	    (`t   (or (> fr-left   right)
		      (< fr-right  left)
		      (> fr-top    bottom)
		      (< fr-bottom top)))
	    ;; Fully inside, no need to do anything.
	    (_ nil))
      (let ((fullwidth (> fr-width width))
	    (fullheight (> fr-height height))
	    (params nil))
	;; Position frame horizontally.
	(cond (fullwidth
	       (push `(left . ,left) params))
	      ((> fr-right right)
	       (push `(left . ,(+ left (- width fr-width))) params))
	      ((< fr-left left)
	       (push `(left . ,left) params)))
	;; Position frame vertically.
	(cond (fullheight
	       (push `(top . ,top) params))
	      ((> fr-bottom bottom)
	       (push `(top . ,(+ top (- height fr-height))) params))
	      ((< fr-top top)
	       (push `(top . ,top) params)))
	;; Compute fullscreen state, if required.
	(when (or fullwidth fullheight)
	  (push (cons 'fullscreen
		      (cond ((not fullwidth) 'fullheight)
			    ((not fullheight) 'fullwidth)
			    (t 'maximized)))
		params))
	;; Finally, move the frame back onscreen.
	(when params
	  (modify-frame-parameters frame params))))))

(defun frameset--find-frame-if (predicate display &rest args)
  "Find a reusable frame satisfying PREDICATE.
Look through available frames whose display property matches DISPLAY
and return the first one for which (PREDICATE frame ARGS) returns t.
If PREDICATE is nil, it is always satisfied.  Internal use only."
  (cl-find-if (lambda (frame)
		(and (equal (frame-parameter frame 'display) display)
		     (or (null predicate)
			 (apply predicate frame args))))
	      frameset--reuse-list))

(defun frameset--reuse-frame (display parameters)
  "Return an existing frame to reuse, or nil if none found.
DISPLAY is the display where the frame will be shown, and PARAMETERS
is the parameter alist of the frame being restored.  Internal use only."
  (let ((frame nil)
	mini)
    ;; There are no fancy heuristics there.  We could implement some
    ;; based on frame size and/or position, etc., but it is not clear
    ;; that any "gain" (in the sense of reduced flickering, etc.) is
    ;; worth the added complexity.  In fact, the code below mainly
    ;; tries to work nicely when M-x desktop-read is used after a
    ;; desktop session has already been loaded.  The other main use
    ;; case, which is the initial desktop-read upon starting Emacs,
    ;; will usually have only one frame, and should already work.
    (cond ((null display)
	   ;; When the target is tty, every existing frame is reusable.
	   (setq frame (frameset--find-frame-if nil display)))
	  ((car (setq mini (cdr (assq 'frameset--mini parameters))))
	   ;; If the frame has its own minibuffer, let's see whether
	   ;; that frame has already been loaded (which can happen after
	   ;; M-x desktop-read).
	   (setq frame (frameset--find-frame-if
			(lambda (f id)
			  (frameset-frame-id-equal-p f id))
			display (frameset-cfg-id parameters)))
	   ;; If it has not been loaded, and it is not a minibuffer-only frame,
	   ;; let's look for an existing non-minibuffer-only frame to reuse.
	   (unless (or frame (eq (cdr (assq 'minibuffer parameters)) 'only))
	     (setq frame (frameset--find-frame-if
			  (lambda (f)
			    (let ((w (frame-parameter f 'minibuffer)))
			      (and (window-live-p w)
				   (window-minibuffer-p w)
				   (eq (window-frame w) f))))
			  display))))
	  (mini
	   ;; For minibufferless frames, check whether they already exist,
	   ;; and that they are linked to the right minibuffer frame.
	   (setq frame (frameset--find-frame-if
			(lambda (f id mini-id)
			  (and (frameset-frame-id-equal-p f id)
			       (or (null mini-id) ; minibuffer frame not saved
				   (frameset-frame-id-equal-p
				    (window-frame (minibuffer-window f))
				    mini-id))))
			display (frameset-cfg-id parameters) (cdr mini))))
	  (t
	   ;; Default to just finding a frame in the same display.
	   (setq frame (frameset--find-frame-if nil display))))
    ;; If found, remove from the list.
    (when frame
      (setq frameset--reuse-list (delq frame frameset--reuse-list)))
    frame))

(defun frameset--initial-params (parameters)
  "Return a list of PARAMETERS that must be set when creating the frame.
Setting position and size parameters as soon as possible helps reducing
flickering; other parameters, like `minibuffer' and `border-width', can
not be changed once the frame has been created.  Internal use only."
  (cl-loop for param in '(left top width height border-width minibuffer)
	   when (assq param parameters) collect it))

(defun frameset--restore-frame (parameters window-state filters force-onscreen)
  "Set up and return a frame according to its saved state.
That means either reusing an existing frame or creating one anew.
PARAMETERS is the frame's parameter alist; WINDOW-STATE is its window state.
For the meaning of FILTERS and FORCE-ONSCREEN, see `frameset-restore'.
Internal use only."
  (let* ((fullscreen (cdr (assq 'fullscreen parameters)))
	 (filtered-cfg (frameset-filter-params parameters filters nil))
	 (display (cdr (assq 'display filtered-cfg))) ;; post-filtering
	 alt-cfg frame)

    (when fullscreen
      ;; Currently Emacs has the limitation that it does not record the size
      ;; and position of a frame before maximizing it, so we cannot save &
      ;; restore that info.  Instead, when restoring, we resort to creating
      ;; invisible "fullscreen" frames of default size and then maximizing them
      ;; (and making them visible) which at least is somewhat user-friendly
      ;; when these frames are later de-maximized.
      (let ((width (and (eq fullscreen 'fullheight) (cdr (assq 'width filtered-cfg))))
	    (height (and (eq fullscreen 'fullwidth) (cdr (assq 'height filtered-cfg))))
	    (visible (assq 'visibility filtered-cfg)))
	(setq filtered-cfg (cl-delete-if (lambda (p)
					   (memq p '(visibility fullscreen width height)))
					 filtered-cfg :key #'car))
	(when width
	  (setq filtered-cfg (append `((user-size . t) (width . ,width))
				     filtered-cfg)))
	(when height
	  (setq filtered-cfg (append `((user-size . t) (height . ,height))
				     filtered-cfg)))
	;; These are parameters to apply after creating/setting the frame.
	(push visible alt-cfg)
	(push (cons 'fullscreen fullscreen) alt-cfg)))

    ;; Time to find or create a frame and apply the big bunch of parameters.
    (setq frame (and frameset--reuse-list
		     (frameset--reuse-frame display filtered-cfg)))
    (if frame
	(puthash frame :reused frameset--action-map)
      ;; If a frame needs to be created and it falls partially or fully offscreen,
      ;; sometimes it gets "pushed back" onscreen; however, moving it afterwards is
      ;; allowed.  So we create the frame as invisible and then reapply the full
      ;; parameter alist (including position and size parameters).
      (setq frame (make-frame-on-display display
					 (cons '(visibility)
					       (frameset--initial-params filtered-cfg))))
      (puthash frame :created frameset--action-map))

    (modify-frame-parameters frame
			     (if (eq (frame-parameter frame 'fullscreen) fullscreen)
				 ;; Workaround for bug#14949
				 (assq-delete-all 'fullscreen filtered-cfg)
			       filtered-cfg))

    ;; If requested, force frames to be onscreen.
    (when (and force-onscreen
	       ;; FIXME: iconified frames should be checked too,
	       ;; but it is impossible without deiconifying them.
	       (not (eq (frame-parameter frame 'visibility) 'icon)))
      (frameset-move-onscreen frame force-onscreen))

    ;; Let's give the finishing touches (visibility, maximization).
    (when alt-cfg (modify-frame-parameters frame alt-cfg))
    ;; Now restore window state.
    (window-state-put window-state (frame-root-window frame) 'safe)
    frame))

(defun frameset--minibufferless-last-p (state1 state2)
  "Predicate to sort frame states in an order suitable for creating frames.
It sorts minibuffer-owning frames before minibufferless ones.
Internal use only."
  (pcase-let ((`(,hasmini1 ,id-def1) (assq 'frameset--mini (car state1)))
	      (`(,hasmini2 ,id-def2) (assq 'frameset--mini (car state2))))
    (cond ((eq id-def1 t) t)
	  ((eq id-def2 t) nil)
	  ((not (eq hasmini1 hasmini2)) (eq hasmini1 t))
	  ((eq hasmini1 nil) (or id-def1 id-def2))
	  (t t))))

(defun frameset-keep-original-display-p (force-display)
  "True if saved frames' displays should be honored.
For the meaning of FORCE-DISPLAY, see `frameset-restore'."
  (cond ((daemonp) t)
	((eq system-type 'windows-nt) nil) ;; Does ns support more than one display?
	(t (not force-display))))

(defun frameset-minibufferless-first-p (frame1 _frame2)
  "Predicate to sort minibufferless frames before other frames."
  (not (frame-parameter frame1 'minibuffer)))

;;;###autoload
(cl-defun frameset-restore (frameset
			    &key predicate filters reuse-frames
				 force-display force-onscreen
				 cleanup-frames)
  "Restore a FRAMESET into the current display(s).

PREDICATE is a function called with two arguments, the parameter alist
and the window-state of the frame being restored, in that order (see
the docstring of the `frameset' defstruct for additional details).
If PREDICATE returns nil, the frame described by that parameter alist
and window-state is not restored.

FILTERS is an alist of parameter filters; if nil, the value of
`frameset-filter-alist' is used instead.

REUSE-FRAMES selects the policy to reuse frames when restoring:
  t        All existing frames can be reused.
  nil      No existing frame can be reused.
  match    Only frames with matching frame ids can be reused.
  PRED     A predicate function; it receives as argument a live frame,
             and must return non-nil to allow reusing it, nil otherwise.

FORCE-DISPLAY can be:
  t        Frames are restored in the current display.
  nil      Frames are restored, if possible, in their original displays.
  delete   Frames in other displays are deleted instead of restored.
  PRED     A function called with two arguments, the parameter alist and
	     the window state (in that order).  It must return t, nil or
	     `delete', as above but affecting only the frame that will
	     be created from that parameter alist.

FORCE-ONSCREEN can be:
  t        Force onscreen only those frames that are fully offscreen.
  nil      Do not force any frame back onscreen.
  all      Force onscreen any frame fully or partially offscreen.
  PRED     A function called with three arguments,
	   - the live frame just restored,
	   - a list (LEFT TOP WIDTH HEIGHT), describing the frame,
	   - a list (LEFT TOP WIDTH HEIGHT), describing the workarea.
	   It must return non-nil to force the frame onscreen, nil otherwise.

CLEANUP-FRAMES allows to \"clean up\" the frame list after restoring a frameset:
  t        Delete all frames that were not created or restored upon.
  nil      Keep all frames.
  FUNC     A function called with two arguments:
           - FRAME, a live frame.
           - ACTION, which can be one of
             :rejected  Frame existed, but was not a candidate for reuse.
             :ignored   Frame existed, was a candidate, but wasn't reused.
             :reused    Frame existed, was a candidate, and restored upon.
             :created   Frame didn't exist, was created and restored upon.
           Return value is ignored.

Note the timing and scope of the operations described above: REUSE-FRAMES
affects existing frames; PREDICATE, FILTERS and FORCE-DISPLAY affect the frame
being restored before that happens; FORCE-ONSCREEN affects the frame once
it has been restored; and CLEANUP-FRAMES affects all frames alive after the
restoration, including those that have been reused or created anew.

All keyword parameters default to nil."

  (cl-assert (frameset-valid-p frameset))

  (let* ((frames (frame-list))
	 (frameset--action-map (make-hash-table :test #'eq))
	 ;; frameset--reuse-list is a list of frames potentially reusable.  Later we
	 ;; will decide which ones can be reused, and how to deal with any leftover.
	 (frameset--reuse-list
	  (pcase reuse-frames
	    (`t
	     frames)
	    (`nil
	     nil)
	    (`match
	     (cl-loop for (state) in (frameset-states frameset)
		      when (frameset-frame-with-id (frameset-cfg-id state) frames)
		      collect it))
	    ((pred functionp)
	     (cl-remove-if-not reuse-frames frames))
	    (_
	     (error "Invalid arg :reuse-frames %s" reuse-frames)))))

    ;; Mark existing frames in the map; candidates to reuse are marked as :ignored;
    ;; they will be reassigned later, if chosen.
    (dolist (frame frames)
      (puthash frame
	       (if (memq frame frameset--reuse-list) :ignored :rejected)
	       frameset--action-map))

    ;; Sort saved states to guarantee that minibufferless frames will be created
    ;; after the frames that contain their minibuffer windows.
    (dolist (state (sort (copy-sequence (frameset-states frameset))
			 #'frameset--minibufferless-last-p))
      (pcase-let ((`(,frame-cfg . ,window-cfg) state))
	(when (or (null predicate) (funcall predicate frame-cfg window-cfg))
	  (condition-case-unless-debug err
	      (let* ((d-mini (cdr (assq 'frameset--mini frame-cfg)))
		     (mb-id (cdr d-mini))
		     (default (and (car d-mini) mb-id))
		     (force-display (if (functionp force-display)
					(funcall force-display frame-cfg window-cfg)
				      force-display))
		     (frameset--target-display nil)
		     frame to-tty duplicate)
		;; Only set target if forcing displays and the target display is different.
		(unless (or (frameset-keep-original-display-p force-display)
			    (equal (frame-parameter nil 'display)
				   (cdr (assq 'display frame-cfg))))
		  (setq frameset--target-display (cons 'display
						       (frame-parameter nil 'display))
			to-tty (null (cdr frameset--target-display))))
		;; Time to restore frames and set up their minibuffers as they were.
		;; We only skip a frame (thus deleting it) if either:
		;; - we're switching displays, and the user chose the option to delete, or
		;; - we're switching to tty, and the frame to restore is minibuffer-only.
		(unless (and frameset--target-display
			     (or (eq force-display 'delete)
				 (and to-tty
				      (eq (cdr (assq 'minibuffer frame-cfg)) 'only))))
		  ;; To avoid duplicating frame ids after restoration, we note any
		  ;; existing frame whose id matches a frame configuration in the
		  ;; frameset.  Once the frame config is properly restored, we can
		  ;; reset the old frame's id to nil.
		  (setq duplicate (frameset-frame-with-id (frameset-cfg-id frame-cfg)
							  frames))
		  ;; Restore minibuffers.  Some of this stuff could be done in a filter
		  ;; function, but it would be messy because restoring minibuffers affects
		  ;; global state; it's best to do it here than add a bunch of global
		  ;; variables to pass info back-and-forth to/from the filter function.
		  (cond
		   ((null d-mini)) ;; No frameset--mini.  Process as normal frame.
		   (to-tty) ;; Ignore minibuffer stuff and process as normal frame.
		   ((car d-mini) ;; Frame has minibuffer (or it is minibuffer-only).
		    (when (eq (cdr (assq 'minibuffer frame-cfg)) 'only)
		      (setq frame-cfg (append '((tool-bar-lines . 0) (menu-bar-lines . 0))
					      frame-cfg))))
		   (t ;; Frame depends on other frame's minibuffer window.
		    (when mb-id
		      (let ((mb-frame (frameset-frame-with-id mb-id))
			    (mb-window nil))
			(if (not mb-frame)
			    (delay-warning 'frameset
					   (format "Minibuffer frame %S not found" mb-id)
					   :warning)
			  (setq mb-window (minibuffer-window mb-frame))
			  (unless (and (window-live-p mb-window)
				       (window-minibuffer-p mb-window))
			    (delay-warning 'frameset
					   (format "Not a minibuffer window %s" mb-window)
					   :warning)
			    (setq mb-window nil)))
			(when mb-window
			  (push (cons 'minibuffer mb-window) frame-cfg))))))
		  ;; OK, we're ready at last to create (or reuse) a frame and
		  ;; restore the window config.
		  (setq frame (frameset--restore-frame frame-cfg window-cfg
						       (or filters frameset-filter-alist)
						       force-onscreen))
		  ;; Now reset any duplicate frameset--id
		  (when (and duplicate (not (eq frame duplicate)))
		    (set-frame-parameter duplicate 'frameset--id nil))
		  ;; Set default-minibuffer if required.
		  (when default (setq default-minibuffer-frame frame))))
	    (error
	     (delay-warning 'frameset (error-message-string err) :error))))))

    ;; In case we try to delete the initial frame, we want to make sure that
    ;; other frames are already visible (discussed in thread for bug#14841).
    (sit-for 0 t)

    ;; Clean up the frame list
    (when cleanup-frames
      (let ((map nil)
	    (cleanup (if (eq cleanup-frames t)
			 (lambda (frame action)
			   (when (memq action '(:rejected :ignored))
			     (delete-frame frame)))
		       cleanup-frames)))
	(maphash (lambda (frame _action) (push frame map)) frameset--action-map)
	(dolist (frame (sort map
			     ;; Minibufferless frames must go first to avoid
			     ;; errors when attempting to delete a frame whose
			     ;; minibuffer window is used by another frame.
			     #'frameset-minibufferless-first-p))
	  (condition-case-unless-debug err
	      (funcall cleanup frame (gethash frame frameset--action-map))
	    (error
	     (delay-warning 'frameset (error-message-string err) :warning))))))

    ;; Make sure there's at least one visible frame.
    (unless (or (daemonp)
		(catch 'visible
		  (maphash (lambda (frame _)
			     (and (frame-live-p frame) (frame-visible-p frame)
				  (throw 'visible t)))
			   frameset--action-map)))
      (make-frame-visible (selected-frame)))))


;; Register support

;;;###autoload
(defun frameset--jump-to-register (data)
  "Restore frameset from DATA stored in register.
Called from `jump-to-register'.  Internal use only."
  (frameset-restore
   (aref data 0)
   :filters frameset-session-filter-alist
   :reuse-frames (if current-prefix-arg t 'match)
   :cleanup-frames (if current-prefix-arg
		       ;; delete frames
		       nil
		     ;; iconify frames
		     (lambda (frame action)
		       (pcase action
			 (`rejected (iconify-frame frame))
			 ;; In the unexpected case that a frame was a candidate
			 ;; (matching frame id) and yet not restored, remove it
			 ;; because it is in fact a duplicate.
			 (`ignored (delete-frame frame))))))

  ;; Restore selected frame, buffer and point.
  (let ((frame (frameset-frame-with-id (aref data 1)))
	buffer window)
    (when frame
      (select-frame-set-input-focus frame)
      (when (and (buffer-live-p (setq buffer (marker-buffer (aref data 2))))
		 (window-live-p (setq window (get-buffer-window buffer frame))))
	(set-frame-selected-window frame window)
	(with-current-buffer buffer (goto-char (aref data 2)))))))

;;;###autoload
(defun frameset-to-register (register)
  "Store the current frameset in register REGISTER.
Use \\[jump-to-register] to restore the frameset.
Argument is a character, naming the register.

Interactively, reads the register using `register-read-with-preview'."
  (interactive (list (register-read-with-preview "Frameset to register: ")))
  (set-register register
		(registerv-make
		 (vector (frameset-save nil
					:app 'register
					:filters frameset-session-filter-alist)
			 ;; frameset-save does not include the value of point
			 ;; in the current buffer, so record that separately.
			 (frameset-frame-id nil)
			 (point-marker))
		 :print-func (lambda (_data) (princ "a frameset."))
		 :jump-func #'frameset--jump-to-register)))

(provide 'frameset)

;;; frameset.el ends here
