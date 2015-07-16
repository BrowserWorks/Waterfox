;;; tramp-gvfs.el --- Tramp access functions for GVFS daemon

;; Copyright (C) 2009-2014 Free Software Foundation, Inc.

;; Author: Michael Albinus <michael.albinus@gmx.de>
;; Keywords: comm, processes
;; Package: tramp

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

;; Access functions for the GVFS daemon from Tramp.  Tested with GVFS
;; 1.0 (Ubuntu 8.10, Gnome 2.24).  It has been reported also to run
;; with GVFS 0.2.5 (Ubuntu 8.04, Gnome 2.22), but there is an
;; incompatibility with the mount_info structure, which has been
;; worked around.

;; It has also been tested with GVFS 1.6 (Ubuntu 10.04, Gnome 2.30),
;; where the default_location has been added to mount_info (see
;; <https://bugzilla.gnome.org/show_bug.cgi?id=561998>.

;; With GVFS 1.14 (Ubuntu 12.10, Gnome 3.6) the interfaces have been
;; changed, again.  So we must introspect the D-Bus interfaces.

;; All actions to mount a remote location, and to retrieve mount
;; information, are performed by D-Bus messages.  File operations
;; themselves are performed via the mounted filesystem in ~/.gvfs.
;; Consequently, GNU Emacs 23.1 with enabled D-Bus bindings is a
;; precondition.

;; The GVFS D-Bus interface is said to be unstable.  There were even
;; no introspection data before GVFS 1.14.  The interface, as
;; discovered during development time, is given in respective
;; comments.

;; The customer option `tramp-gvfs-methods' contains the list of
;; supported connection methods.  Per default, these are "dav",
;; "davs", "obex" and "synce".  Note that with "obex" it might be
;; necessary to pair with the other bluetooth device, if it hasn't
;; been done already.  There might be also some few seconds delay in
;; discovering available bluetooth devices.

;; Other possible connection methods are "ftp", "sftp" and "smb".
;; When one of these methods is added to the list, the remote access
;; for that method is performed via GVFS instead of the native Tramp
;; implementation.

;; GVFS offers even more connection methods.  The complete list of
;; connection methods of the actual GVFS implementation can be
;; retrieved by:
;;
;; (message
;;  "%s"
;;  (mapcar
;;   'car
;;   (dbus-call-method
;;    :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
;;    tramp-gvfs-interface-mounttracker "listMountableInfo")))

;; Note that all other connection methods are not tested, beside the
;; ones offered for customization in `tramp-gvfs-methods'.  If you
;; request an additional connection method to be supported, please
;; drop me a note.

;; For hostname completion, information is retrieved either from the
;; bluez daemon (for the "obex" method), the hal daemon (for the
;; "synce" method), or from the zeroconf daemon (for the "dav",
;; "davs", and "sftp" methods).  The zeroconf daemon is pre-configured
;; to discover services in the "local" domain.  If another domain
;; shall be used for discovering services, the customer option
;; `tramp-gvfs-zeroconf-domain' can be set accordingly.

;; Restrictions:

;; * The current GVFS implementation does not allow to write on the
;;   remote bluetooth device via OBEX.
;;
;; * Two shares of the same SMB server cannot be mounted in parallel.

;;; Code:

;; D-Bus support in the Emacs core can be disabled with configuration
;; option "--without-dbus".  Declare used subroutines and variables.
(declare-function dbus-get-unique-name "dbusbind.c")

(require 'tramp)

(require 'dbus)
(require 'url-parse)
(require 'url-util)
(require 'zeroconf)

;; Pacify byte-compiler.
(eval-when-compile
  (require 'cl)
  (require 'custom))

;;;###tramp-autoload
(defcustom tramp-gvfs-methods '("dav" "davs" "obex" "synce")
  "List of methods for remote files, accessed with GVFS."
  :group 'tramp
  :version "23.2"
  :type '(repeat (choice (const "dav")
			 (const "davs")
			 (const "ftp")
			 (const "obex")
			 (const "sftp")
			 (const "smb")
			 (const "synce"))))

;; Add a default for `tramp-default-user-alist'.  Rule: For the SYNCE
;; method, no user is chosen.
;;;###tramp-autoload
(add-to-list 'tramp-default-user-alist '("\\`synce\\'" nil nil))

(defcustom tramp-gvfs-zeroconf-domain "local"
  "Zeroconf domain to be used for discovering services, like host names."
  :group 'tramp
  :version "23.2"
  :type 'string)

;; Add the methods to `tramp-methods', in order to allow minibuffer
;; completion.
;;;###tramp-autoload
(when (featurep 'dbusbind)
  (dolist (elt tramp-gvfs-methods)
    (unless (assoc elt tramp-methods)
      (add-to-list 'tramp-methods (cons elt nil)))))

(defconst tramp-gvfs-path-tramp (concat dbus-path-emacs "/Tramp")
  "The preceding object path for own objects.")

(defconst tramp-gvfs-service-daemon "org.gtk.vfs.Daemon"
  "The well known name of the GVFS daemon.")

;; D-Bus integration is available since Emacs 23 on some system types.
;; We don't call `dbus-ping', because this would load dbus.el.
(defconst tramp-gvfs-enabled
  (ignore-errors
    (and (featurep 'dbusbind)
	 (tramp-compat-funcall 'dbus-get-unique-name :system)
	 (tramp-compat-funcall 'dbus-get-unique-name :session)
	 (or (tramp-compat-process-running-p "gvfs-fuse-daemon")
	     (tramp-compat-process-running-p "gvfsd-fuse"))))
  "Non-nil when GVFS is available.")

(defconst tramp-gvfs-path-mounttracker "/org/gtk/vfs/mounttracker"
  "The object path of the GVFS daemon.")

(defconst tramp-gvfs-interface-mounttracker "org.gtk.vfs.MountTracker"
  "The mount tracking interface in the GVFS daemon.")

;; Introspection data exist since GVFS 1.14.  If there are no such
;; data, we expect an earlier interface.
(defconst tramp-gvfs-methods-mounttracker
  (dbus-introspect-get-method-names
   :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker)
  "The list of supported methods of the mount tracking interface.")

(defconst tramp-gvfs-listmounts
  (if (member "ListMounts" tramp-gvfs-methods-mounttracker)
      "ListMounts"
    "listMounts")
  "The name of the \"listMounts\" method.
It has been changed in GVFS 1.14.")

(defconst tramp-gvfs-mountlocation
  (if (member "MountLocation" tramp-gvfs-methods-mounttracker)
      "MountLocation"
    "mountLocation")
  "The name of the \"mountLocation\" method.
It has been changed in GVFS 1.14.")

(defconst tramp-gvfs-mountlocation-signature
  (dbus-introspect-get-signature
   :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker tramp-gvfs-mountlocation)
  "The D-Bus signature of the \"mountLocation\" method.
It has been changed in GVFS 1.14.")

;; <interface name='org.gtk.vfs.MountTracker'>
;;   <method name='listMounts'>
;;     <arg name='mount_info_list'
;;          type='a{sosssssbay{aya{say}}ay}'
;;          direction='out'/>
;;   </method>
;;   <method name='mountLocation'>
;;     <arg name='mount_spec'  type='{aya{say}}' direction='in'/>
;;     <arg name='dbus_id'     type='s'          direction='in'/>
;;     <arg name='object_path' type='o'          direction='in'/>
;;   </method>
;;   <signal name='mounted'>
;;     <arg name='mount_info'
;;          type='{sosssssbay{aya{say}}ay}'/>
;;   </signal>
;;   <signal name='unmounted'>
;;     <arg name='mount_info'
;;          type='{sosssssbay{aya{say}}ay}'/>
;;   </signal>
;; </interface>
;;
;; STRUCT		mount_info
;;   STRING		  dbus_id
;;   OBJECT_PATH	  object_path
;;   STRING		  display_name
;;   STRING		  stable_name
;;   STRING		  x_content_types	Since GVFS 1.0 only !!!
;;   STRING		  icon
;;   STRING		  preferred_filename_encoding
;;   BOOLEAN		  user_visible
;;   ARRAY BYTE		  fuse_mountpoint
;;   STRUCT		  mount_spec
;;     ARRAY BYTE	    mount_prefix
;;     ARRAY
;;       STRUCT		    mount_spec_item
;;         STRING	      key (server, share, type, user, host, port)
;;         ARRAY BYTE	      value
;;   ARRAY BYTE           default_location	Since GVFS 1.5 only !!!

(defconst tramp-gvfs-interface-mountoperation "org.gtk.vfs.MountOperation"
  "Used by the dbus-proxying implementation of GMountOperation.")

;; <interface name='org.gtk.vfs.MountOperation'>
;;   <method name='askPassword'>
;;     <arg name='message'        type='s' direction='in'/>
;;     <arg name='default_user'   type='s' direction='in'/>
;;     <arg name='default_domain' type='s' direction='in'/>
;;     <arg name='flags'          type='u' direction='in'/>
;;     <arg name='handled'        type='b' direction='out'/>
;;     <arg name='aborted'        type='b' direction='out'/>
;;     <arg name='password'       type='s' direction='out'/>
;;     <arg name='username'       type='s' direction='out'/>
;;     <arg name='domain'         type='s' direction='out'/>
;;     <arg name='anonymous'      type='b' direction='out'/>
;;     <arg name='password_save'  type='u' direction='out'/>
;;   </method>
;;   <method name='askQuestion'>
;;     <arg name='message' type='s'  direction='in'/>
;;     <arg name='choices' type='as' direction='in'/>
;;     <arg name='handled' type='b'  direction='out'/>
;;     <arg name='aborted' type='b'  direction='out'/>
;;     <arg name='choice'  type='u'  direction='out'/>
;;   </method>
;; </interface>

;; The following flags are used in "askPassword".  They are defined in
;; /usr/include/glib-2.0/gio/gioenums.h.

(defconst tramp-gvfs-password-need-password 1
  "Operation requires a password.")

(defconst tramp-gvfs-password-need-username 2
  "Operation requires a username.")

(defconst tramp-gvfs-password-need-domain 4
  "Operation requires a domain.")

(defconst tramp-gvfs-password-saving-supported 8
  "Operation supports saving settings.")

(defconst tramp-gvfs-password-anonymous-supported 16
  "Operation supports anonymous users.")

(defconst tramp-bluez-service "org.bluez"
  "The well known name of the BLUEZ service.")

(defconst tramp-bluez-interface-manager "org.bluez.Manager"
  "The manager interface of the BLUEZ daemon.")

;; <interface name='org.bluez.Manager'>
;;   <method name='DefaultAdapter'>
;;     <arg type='o' direction='out'/>
;;   </method>
;;   <method name='FindAdapter'>
;;     <arg type='s' direction='in'/>
;;     <arg type='o' direction='out'/>
;;   </method>
;;   <method name='ListAdapters'>
;;     <arg type='ao' direction='out'/>
;;   </method>
;;   <signal name='AdapterAdded'>
;;     <arg type='o'/>
;;   </signal>
;;   <signal name='AdapterRemoved'>
;;     <arg type='o'/>
;;   </signal>
;;   <signal name='DefaultAdapterChanged'>
;;     <arg type='o'/>
;;   </signal>
;; </interface>

(defconst tramp-bluez-interface-adapter "org.bluez.Adapter"
  "The adapter interface of the BLUEZ daemon.")

;; <interface name='org.bluez.Adapter'>
;;   <method name='GetProperties'>
;;     <arg type='a{sv}' direction='out'/>
;;   </method>
;;   <method name='SetProperty'>
;;     <arg type='s' direction='in'/>
;;     <arg type='v' direction='in'/>
;;   </method>
;;   <method name='RequestMode'>
;;     <arg type='s' direction='in'/>
;;   </method>
;;   <method name='ReleaseMode'/>
;;   <method name='RequestSession'/>
;;   <method name='ReleaseSession'/>
;;   <method name='StartDiscovery'/>
;;   <method name='StopDiscovery'/>
;;   <method name='ListDevices'>
;;     <arg type='ao' direction='out'/>
;;   </method>
;;   <method name='CreateDevice'>
;;     <arg type='s' direction='in'/>
;;     <arg type='o' direction='out'/>
;;   </method>
;;   <method name='CreatePairedDevice'>
;;     <arg type='s' direction='in'/>
;;     <arg type='o' direction='in'/>
;;     <arg type='s' direction='in'/>
;;     <arg type='o' direction='out'/>
;;   </method>
;;   <method name='CancelDeviceCreation'>
;;     <arg type='s' direction='in'/>
;;   </method>
;;   <method name='RemoveDevice'>
;;     <arg type='o' direction='in'/>
;;   </method>
;;   <method name='FindDevice'>
;;     <arg type='s' direction='in'/>
;;     <arg type='o' direction='out'/>
;;   </method>
;;   <method name='RegisterAgent'>
;;     <arg type='o' direction='in'/>
;;     <arg type='s' direction='in'/>
;;   </method>
;;   <method name='UnregisterAgent'>
;;     <arg type='o' direction='in'/>
;;   </method>
;;   <signal name='DeviceCreated'>
;;     <arg type='o'/>
;;   </signal>
;;   <signal name='DeviceRemoved'>
;;     <arg type='o'/>
;;   </signal>
;;   <signal name='DeviceFound'>
;;     <arg type='s'/>
;;     <arg type='a{sv}'/>
;;   </signal>
;;   <signal name='PropertyChanged'>
;;     <arg type='s'/>
;;     <arg type='v'/>
;;   </signal>
;;   <signal name='DeviceDisappeared'>
;;     <arg type='s'/>
;;   </signal>
;; </interface>

(defcustom tramp-bluez-discover-devices-timeout 60
  "Defines seconds since last bluetooth device discovery before rescanning.
A value of 0 would require an immediate discovery during hostname
completion, nil means to use always cached values for discovered
devices."
  :group 'tramp
  :version "23.2"
  :type '(choice (const nil) integer))

(defvar tramp-bluez-discovery nil
  "Indicator for a running bluetooth device discovery.
It keeps the timestamp of last discovery.")

(defvar tramp-bluez-devices nil
  "Alist of detected bluetooth devices.
Every entry is a list (NAME ADDRESS).")

(defconst tramp-hal-service "org.freedesktop.Hal"
  "The well known name of the HAL service.")

(defconst tramp-hal-path-manager "/org/freedesktop/Hal/Manager"
  "The object path of the HAL daemon manager.")

(defconst tramp-hal-interface-manager "org.freedesktop.Hal.Manager"
  "The manager interface of the HAL daemon.")

(defconst tramp-hal-interface-device "org.freedesktop.Hal.Device"
  "The device interface of the HAL daemon.")


;; New handlers should be added here.
(defconst tramp-gvfs-file-name-handler-alist
  '((access-file . ignore)
    (add-name-to-file . tramp-gvfs-handle-copy-file)
    ;; `byte-compiler-base-file-name' performed by default handler.
    ;; `copy-directory' performed by default handler.
    (copy-file . tramp-gvfs-handle-copy-file)
    (delete-directory . tramp-gvfs-handle-delete-directory)
    (delete-file . tramp-gvfs-handle-delete-file)
    ;; `diff-latest-backup-file' performed by default handler.
    (directory-file-name . tramp-handle-directory-file-name)
    (directory-files . tramp-handle-directory-files)
    (directory-files-and-attributes
     . tramp-handle-directory-files-and-attributes)
    (dired-call-process . ignore)
    (dired-compress-file . ignore)
    (dired-uncache . tramp-handle-dired-uncache)
    (expand-file-name . tramp-gvfs-handle-expand-file-name)
    (file-accessible-directory-p . tramp-handle-file-accessible-directory-p)
    (file-acl . ignore)
    (file-attributes . tramp-gvfs-handle-file-attributes)
    (file-directory-p . tramp-gvfs-handle-file-directory-p)
    ;; `file-equal-p' performed by default handler.
    (file-executable-p . tramp-gvfs-handle-file-executable-p)
    (file-exists-p . tramp-handle-file-exists-p)
    ;; `file-in-directory-p' performed by default handler.
    (file-local-copy . tramp-gvfs-handle-file-local-copy)
    (file-modes . tramp-handle-file-modes)
    (file-name-all-completions . tramp-gvfs-handle-file-name-all-completions)
    (file-name-as-directory . tramp-handle-file-name-as-directory)
    (file-name-completion . tramp-handle-file-name-completion)
    (file-name-directory . tramp-handle-file-name-directory)
    (file-name-nondirectory . tramp-handle-file-name-nondirectory)
    ;; `file-name-sans-versions' performed by default handler.
    (file-newer-than-file-p . tramp-handle-file-newer-than-file-p)
    (file-notify-add-watch . tramp-gvfs-handle-file-notify-add-watch)
    (file-notify-rm-watch . tramp-handle-file-notify-rm-watch)
    (file-ownership-preserved-p . ignore)
    (file-readable-p . tramp-gvfs-handle-file-readable-p)
    (file-regular-p . tramp-handle-file-regular-p)
    (file-remote-p . tramp-handle-file-remote-p)
    (file-selinux-context . ignore)
    (file-symlink-p . tramp-handle-file-symlink-p)
    ;; `file-truename' performed by default handler.
    (file-writable-p . tramp-gvfs-handle-file-writable-p)
    (find-backup-file-name . tramp-handle-find-backup-file-name)
    ;; `find-file-noselect' performed by default handler.
    ;; `get-file-buffer' performed by default handler.
    (insert-directory . tramp-handle-insert-directory)
    (insert-file-contents . tramp-handle-insert-file-contents)
    (load . tramp-handle-load)
    (make-auto-save-file-name . tramp-handle-make-auto-save-file-name)
    (make-directory . tramp-gvfs-handle-make-directory)
    (make-directory-internal . ignore)
    (make-symbolic-link . tramp-handle-make-symbolic-link)
    (process-file . ignore)
    (rename-file . tramp-gvfs-handle-rename-file)
    (set-file-acl . ignore)
    (set-file-modes . ignore)
    (set-file-selinux-context . ignore)
    (set-file-times . ignore)
    (set-visited-file-modtime . tramp-handle-set-visited-file-modtime)
    (shell-command . ignore)
    (start-file-process . ignore)
    (substitute-in-file-name . tramp-handle-substitute-in-file-name)
    (unhandled-file-name-directory . tramp-handle-unhandled-file-name-directory)
    (vc-registered . ignore)
    (verify-visited-file-modtime . tramp-handle-verify-visited-file-modtime)
    (write-region . tramp-gvfs-handle-write-region))
  "Alist of handler functions for Tramp GVFS method.
Operations not mentioned here will be handled by the default Emacs primitives.")

;; It must be a `defsubst' in order to push the whole code into
;; tramp-loaddefs.el.  Otherwise, there would be recursive autoloading.
;;;###tramp-autoload
(defsubst tramp-gvfs-file-name-p (filename)
  "Check if it's a filename handled by the GVFS daemon."
  (and (tramp-tramp-file-p filename)
       (let ((method
	      (tramp-file-name-method (tramp-dissect-file-name filename))))
	 (and (stringp method) (member method tramp-gvfs-methods)))))

;;;###tramp-autoload
(defun tramp-gvfs-file-name-handler (operation &rest args)
  "Invoke the GVFS related OPERATION.
First arg specifies the OPERATION, second arg is a list of arguments to
pass to the OPERATION."
  (unless tramp-gvfs-enabled
    (tramp-user-error nil "Package `tramp-gvfs' not supported"))
  (let ((fn (assoc operation tramp-gvfs-file-name-handler-alist)))
    (if fn
	(save-match-data (apply (cdr fn) args))
      (tramp-run-real-handler operation args))))

;; This might be moved to tramp.el.  It shall be the first file name
;; handler.
;;;###tramp-autoload
(when (featurep 'dbusbind)
  (add-to-list 'tramp-foreign-file-name-handler-alist
	       (cons 'tramp-gvfs-file-name-p 'tramp-gvfs-file-name-handler)))


;; D-Bus helper function.

(defun tramp-gvfs-dbus-string-to-byte-array (string)
  "Like `dbus-string-to-byte-array' but add trailing \\0 if needed."
  (dbus-string-to-byte-array
   (if (string-match "^(aya{sv})" tramp-gvfs-mountlocation-signature)
       (concat string (string 0)) string)))

(defun tramp-gvfs-dbus-byte-array-to-string (byte-array)
  "Like `dbus-byte-array-to-string' but remove trailing \\0 if exists."
  ;; The byte array could be a variant.  Take care.
  (let ((byte-array
	 (if (and (consp byte-array) (atom (car byte-array)))
	     byte-array (car byte-array))))
    (dbus-byte-array-to-string
     (if (and (consp byte-array) (zerop (car (last byte-array))))
	 (butlast byte-array) byte-array))))

(defun tramp-gvfs-stringify-dbus-message (message)
  "Convert a D-Bus message into readable UTF8 strings, used for traces."
  (cond
   ((and (consp message) (characterp (car message)))
    (format "%S" (tramp-gvfs-dbus-byte-array-to-string message)))
   ((consp message)
    (mapcar 'tramp-gvfs-stringify-dbus-message message))
   ((stringp message)
    (format "%S" message))
   (t message)))

(defmacro with-tramp-dbus-call-method
  (vec synchronous bus service path interface method &rest args)
  "Apply a D-Bus call on bus BUS.

If SYNCHRONOUS is non-nil, the call is synchronously.  Otherwise,
it is an asynchronous call, with `ignore' as callback function.

The other arguments have the same meaning as with `dbus-call-method'
or `dbus-call-method-asynchronously'.  Additionally, the call
will be traced by Tramp with trace level 6."
  `(let ((func (if ,synchronous
		   'dbus-call-method 'dbus-call-method-asynchronously))
	 (args (append (list ,bus ,service ,path ,interface ,method)
		       (if ,synchronous (list ,@args) (list 'ignore ,@args))))
	 result)
     (tramp-message ,vec 6 "%s %s" func args)
     (setq result (apply func args))
     (tramp-message ,vec 6 "%s" (tramp-gvfs-stringify-dbus-message result))
     result))

(put 'with-tramp-dbus-call-method 'lisp-indent-function 2)
(put 'with-tramp-dbus-call-method 'edebug-form-spec '(form symbolp body))
(tramp-compat-font-lock-add-keywords
 'emacs-lisp-mode '("\\<with-tramp-dbus-call-method\\>"))

(defvar tramp-gvfs-dbus-event-vector nil
  "Current Tramp file name to be used, as vector.
It is needed when D-Bus signals or errors arrive, because there
is no information where to trace the message.")

(defun tramp-gvfs-dbus-event-error (event err)
  "Called when a D-Bus error message arrives, see `dbus-event-error-functions'."
  (when tramp-gvfs-dbus-event-vector
    (tramp-message tramp-gvfs-dbus-event-vector 10 "%S" event)
    (tramp-error tramp-gvfs-dbus-event-vector 'file-error "%s" (cadr err))))

;; `dbus-event-error-hooks' has been renamed to `dbus-event-error-functions'.
(add-hook
 (if (boundp 'dbus-event-error-functions)
     'dbus-event-error-functions 'dbus-event-error-hooks)
 'tramp-gvfs-dbus-event-error)


;; File name primitives.

(defun tramp-gvfs-handle-copy-file
  (filename newname &optional ok-if-already-exists keep-date
	    preserve-uid-gid preserve-extended-attributes)
  "Like `copy-file' for Tramp files."
  (with-parsed-tramp-file-name
      (if (tramp-tramp-file-p filename) filename newname) nil

    (when (and (not ok-if-already-exists) (file-exists-p newname))
      (tramp-error
       v 'file-already-exists "File %s already exists" newname))

    (if (or (and (tramp-tramp-file-p filename)
		 (not (tramp-gvfs-file-name-p filename)))
	    (and (tramp-tramp-file-p newname)
		 (not (tramp-gvfs-file-name-p newname))))

	;; We cannot call `copy-file' directly.  Use
	;; `tramp-compat-funcall' for backward compatibility (number
	;; of arguments).
	(let ((tmpfile (tramp-compat-make-temp-file filename)))
	  (cond
	   (preserve-extended-attributes
	    (tramp-compat-funcall
	     'copy-file
	     filename tmpfile t keep-date preserve-uid-gid
	     preserve-extended-attributes))
	   (preserve-uid-gid
	    (tramp-compat-funcall
	     'copy-file filename tmpfile t keep-date preserve-uid-gid))
	   (t
	    (copy-file filename tmpfile t keep-date)))
	  (rename-file tmpfile newname ok-if-already-exists))

      ;; Direct copy.
      (with-tramp-progress-reporter
	  v 0 (format "Copying %s to %s" filename newname)
	(unless
	    (let ((args
		   (append (if (or keep-date preserve-uid-gid)
			       (list "--preserve")
			     nil)
			   (list
			    (tramp-gvfs-url-file-name filename)
			    (tramp-gvfs-url-file-name newname)))))
	      (apply 'tramp-gvfs-send-command v "gvfs-copy" args))
	  ;; Propagate the error.
	  (with-current-buffer (tramp-get-connection-buffer v)
	    (goto-char (point-min))
	    (tramp-error-with-buffer
	     nil v 'file-error
	     "Copying failed, see buffer `%s' for details." (buffer-name)))))

      (when (tramp-tramp-file-p newname)
	(with-parsed-tramp-file-name newname nil
	  (tramp-flush-file-property v (file-name-directory localname))
	  (tramp-flush-file-property v localname))))))

(defun tramp-gvfs-handle-delete-directory (directory &optional recursive trash)
  "Like `delete-directory' for Tramp files."
  (when (and recursive (not (file-symlink-p directory)))
    (mapc (lambda (file)
	    (if (eq t (car (file-attributes file)))
		(tramp-compat-delete-directory file recursive trash)
	      (tramp-compat-delete-file file trash)))
	  (directory-files
	   directory 'full "^\\([^.]\\|\\.\\([^.]\\|\\..\\)\\).*")))
  (with-parsed-tramp-file-name directory nil
    (tramp-flush-file-property v (file-name-directory localname))
    (tramp-flush-directory-property v localname)
    (unless
	(tramp-gvfs-send-command
	 v (if (and trash delete-by-moving-to-trash) "gvfs-trash" "gvfs-rm")
	 (tramp-gvfs-url-file-name directory))
      ;; Propagate the error.
      (with-current-buffer (tramp-get-connection-buffer v)
	(goto-char (point-min))
	(tramp-error-with-buffer
	 nil v 'file-error "Couldn't delete %s" directory)))))

(defun tramp-gvfs-handle-delete-file (filename &optional trash)
  "Like `delete-file' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    (tramp-flush-file-property v (file-name-directory localname))
    (tramp-flush-directory-property v localname)
    (unless
	(tramp-gvfs-send-command
	 v (if (and trash delete-by-moving-to-trash) "gvfs-trash" "gvfs-rm")
	 (tramp-gvfs-url-file-name filename))
      ;; Propagate the error.
      (with-current-buffer (tramp-get-connection-buffer v)
	(goto-char (point-min))
	(tramp-error-with-buffer
	 nil v 'file-error "Couldn't delete %s" filename)))))

(defun tramp-gvfs-handle-expand-file-name (name &optional dir)
  "Like `expand-file-name' for Tramp files."
  ;; If DIR is not given, use DEFAULT-DIRECTORY or "/".
  (setq dir (or dir default-directory "/"))
  ;; Unless NAME is absolute, concat DIR and NAME.
  (unless (file-name-absolute-p name)
    (setq name (concat (file-name-as-directory dir) name)))
  ;; If NAME is not a Tramp file, run the real handler.
  (if (not (tramp-tramp-file-p name))
      (tramp-run-real-handler 'expand-file-name (list name nil))
    ;; Dissect NAME.
    (with-parsed-tramp-file-name name nil
      ;; If there is a default location, expand tilde.
      (when (string-match "\\`\\(~\\)\\(/\\|\\'\\)" localname)
	(save-match-data
	  (tramp-gvfs-maybe-open-connection (vector method user host "/" hop)))
	(setq localname
	      (replace-match
	       (tramp-get-file-property  v "/" "default-location" "~")
	       nil t localname 1)))
      ;; Tilde expansion is not possible.
      (when (string-match "\\`\\(~[^/]*\\)\\(.*\\)\\'" localname)
	(tramp-error
	 v 'file-error
	 "Cannot expand tilde in file `%s'" name))
      (unless (tramp-run-real-handler 'file-name-absolute-p (list localname))
	(setq localname (concat "/" localname)))
      ;; We do not pass "/..".
      (if (string-equal "smb" method)
	  (when (string-match "^/[^/]+\\(/\\.\\./?\\)" localname)
	    (setq localname (replace-match "/" t t localname 1)))
	(when (string-match "^/\\.\\./?" localname)
	  (setq localname (replace-match "/" t t localname))))
      ;; There might be a double slash.  Remove this.
      (while (string-match "//" localname)
	(setq localname (replace-match "/" t t localname)))
      ;; No tilde characters in file name, do normal
      ;; `expand-file-name' (this does "/./" and "/../").
      (tramp-make-tramp-file-name
       method user host
       (tramp-run-real-handler
	'expand-file-name (list localname))))))

(defun tramp-gvfs-handle-file-attributes (filename &optional id-format)
  "Like `file-attributes' for Tramp files."
  (unless id-format (setq id-format 'integer))
  ;; Don't modify `last-coding-system-used' by accident.
  (let ((last-coding-system-used last-coding-system-used)
	dirp res-symlink-target res-numlinks res-uid res-gid res-access
	res-mod res-change res-size res-filemodes res-inode res-device)
    (with-parsed-tramp-file-name filename nil
      (with-tramp-file-property
	  v localname (format "file-attributes-%s" id-format)
	(tramp-message v 5 "file attributes: %s" localname)
	(tramp-gvfs-send-command
	 v "gvfs-info" (tramp-gvfs-url-file-name filename))
	;; Parse output ...
	(with-current-buffer (tramp-get-connection-buffer v)
	  (goto-char (point-min))
	  (when (re-search-forward "attributes:" nil t)
	    ;; ... directory or symlink
	    (goto-char (point-min))
	    (setq dirp (if (re-search-forward "type:\\s-+directory" nil t) t))
	    (goto-char (point-min))
	    (setq res-symlink-target
		  (if (re-search-forward
		       "standard::symlink-target:\\s-+\\(\\S-+\\)" nil t)
		      (match-string 1)))
	    ;; ... number links
	    (goto-char (point-min))
	    (setq res-numlinks
		  (if (re-search-forward "unix::nlink:\\s-+\\([0-9]+\\)" nil t)
		      (string-to-number (match-string 1)) 0))
	    ;; ... uid and gid
	    (goto-char (point-min))
	    (setq res-uid
		  (or (if (eq id-format 'integer)
			  (if (re-search-forward
			       "unix::uid:\\s-+\\([0-9]+\\)" nil t)
			      (string-to-number (match-string 1)))
			(if (re-search-forward
			     "owner::user:\\s-+\\(\\S-+\\)" nil t)
			    (match-string 1)))
		      (tramp-get-local-uid id-format)))
	    (setq res-gid
		  (or (if (eq id-format 'integer)
			  (if (re-search-forward
			       "unix::gid:\\s-+\\([0-9]+\\)" nil t)
			      (string-to-number (match-string 1)))
			(if (re-search-forward
			     "owner::group:\\s-+\\(\\S-+\\)" nil t)
			    (match-string 1)))
		      (tramp-get-local-gid id-format)))
	    ;; ... last access, modification and change time
	    (goto-char (point-min))
	    (setq res-access
		  (if (re-search-forward
		       "time::access:\\s-+\\([0-9]+\\)" nil t)
		      (seconds-to-time (string-to-number (match-string 1)))
		    '(0 0)))
	    (goto-char (point-min))
	    (setq res-mod
		  (if (re-search-forward
		       "time::modified:\\s-+\\([0-9]+\\)" nil t)
		      (seconds-to-time (string-to-number (match-string 1)))
		    '(0 0)))
	    (goto-char (point-min))
	    (setq res-change
		  (if (re-search-forward
		       "time::changed:\\s-+\\([0-9]+\\)" nil t)
		      (seconds-to-time (string-to-number (match-string 1)))
		    '(0 0)))
	    ;; ... size
	    (goto-char (point-min))
	    (setq res-size
		  (if (re-search-forward
		       "standard::size:\\s-+\\([0-9]+\\)" nil t)
		      (string-to-number (match-string 1)) 0))
	    ;; ... file mode flags
	    (goto-char (point-min))
	    (setq res-filemodes
		  (if (re-search-forward "unix::mode:\\s-+\\([0-9]+\\)" nil t)
		      (tramp-file-mode-from-int (match-string 1))
		    (if dirp "drwx------" "-rwx------")))
	    ;; ... inode and device
	    (goto-char (point-min))
	    (setq res-inode
		  (if (re-search-forward "unix::inode:\\s-+\\([0-9]+\\)" nil t)
		      (string-to-number (match-string 1))
		    (tramp-get-inode v)))
	    (goto-char (point-min))
	    (setq res-device
		  (if (re-search-forward "unix::device:\\s-+\\([0-9]+\\)" nil t)
		      (string-to-number (match-string 1))
		    (tramp-get-device v)))

	    ;; Return data gathered.
	    (list
	     ;; 0. t for directory, string (name linked to) for
	     ;; symbolic link, or nil.
	     (or dirp res-symlink-target)
	     ;; 1. Number of links to file.
	     res-numlinks
	     ;; 2. File uid.
	     res-uid
	     ;; 3. File gid.
	     res-gid
	     ;; 4. Last access time, as a list of integers.
	     ;; 5. Last modification time, likewise.
	     ;; 6. Last status change time, likewise.
	     res-access res-mod res-change
	     ;; 7. Size in bytes (-1, if number is out of range).
	     res-size
	     ;; 8. File modes.
	     res-filemodes
	     ;; 9. t if file's gid would change if file were deleted
	     ;; and recreated.
	     nil
	     ;; 10. Inode number.
	     res-inode
	     ;; 11. Device number.
	     res-device
	     )))))))

(defun tramp-gvfs-handle-file-directory-p (filename)
  "Like `file-directory-p' for Tramp files."
  (eq t (car (file-attributes filename))))

(defun tramp-gvfs-handle-file-executable-p (filename)
  "Like `file-executable-p' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    (with-tramp-file-property v localname "file-executable-p"
      (tramp-check-cached-permissions v ?x))))

(defun tramp-gvfs-handle-file-local-copy (filename)
  "Like `file-local-copy' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    (let ((tmpfile (tramp-compat-make-temp-file filename)))
      (unless (file-exists-p filename)
	(tramp-error
	 v 'file-error
	 "Cannot make local copy of non-existing file `%s'" filename))
      (copy-file filename tmpfile t t)
      tmpfile)))

(defun tramp-gvfs-handle-file-name-all-completions (filename directory)
  "Like `file-name-all-completions' for Tramp files."
  (unless (save-match-data (string-match "/" filename))
    (with-parsed-tramp-file-name (expand-file-name directory) nil

      (all-completions
       filename
       (mapcar
	'list
        (or
	 ;; Try cache entries for filename, filename with last
	 ;; character removed, filename with last two characters
	 ;; removed, ..., and finally the empty string - all
	 ;; concatenated to the local directory name.
         (let ((remote-file-name-inhibit-cache
		(or remote-file-name-inhibit-cache
		    tramp-completion-reread-directory-timeout)))

	   ;; This is inefficient for very long filenames, pity
	   ;; `reduce' is not available...
	   (car
	    (apply
	     'append
	     (mapcar
	      (lambda (x)
		(let ((cache-hit
		       (tramp-get-file-property
			v
			(concat localname (substring filename 0 x))
			"file-name-all-completions"
			nil)))
		  (when cache-hit (list cache-hit))))
	      ;; We cannot use a length of 0, because file properties
	      ;; for "foo" and "foo/" are identical.
	      (tramp-compat-number-sequence (length filename) 1 -1)))))

         ;; Cache expired or no matching cache entry found so we need
         ;; to perform a remote operation.
         (let ((result '("." ".."))
	       entry)
           ;; Get a list of directories and files.
	   (tramp-gvfs-send-command
	    v "gvfs-ls" (tramp-gvfs-url-file-name directory))

	   ;; Now grab the output.
           (with-temp-buffer
	     (insert-buffer-substring (tramp-get-connection-buffer v))
             (goto-char (point-max))
             (while (zerop (forward-line -1))
	       (setq entry (buffer-substring (point) (point-at-eol)))
	       (when (string-match filename entry)
		 (if (file-directory-p (expand-file-name entry directory))
		     (push (concat entry "/") result)
		   (push entry result)))))

           ;; Because the remote op went through OK we know the
           ;; directory we `cd'-ed to exists.
           (tramp-set-file-property v localname "file-exists-p" t)

           ;; Because the remote op went through OK we know every
           ;; file listed by `ls' exists.
           (mapc (lambda (entry)
		   (tramp-set-file-property
		    v (concat localname entry) "file-exists-p" t))
		 result)

           ;; Store result in the cache.
           (tramp-set-file-property
            v (concat localname filename)
	    "file-name-all-completions" result))))))))

(defun tramp-gvfs-handle-file-notify-add-watch (file-name _flags _callback)
  "Like `file-notify-add-watch' for Tramp files."
  (setq file-name (expand-file-name file-name))
  (with-parsed-tramp-file-name file-name nil
    (let ((p (start-process
	      "gvfs-monitor-file" (generate-new-buffer " *gvfs-monitor-file*")
	      "gvfs-monitor-file" (tramp-gvfs-url-file-name file-name))))
      (if (not (processp p))
	  (tramp-error
	   v 'file-notify-error "gvfs-monitor-file failed to start")
	(tramp-message
	 v 6 "Run `%s', %S" (mapconcat 'identity (process-command p) " ") p)
	(tramp-set-connection-property p "vector" v)
	(tramp-compat-set-process-query-on-exit-flag p nil)
	(set-process-filter p 'tramp-gvfs-file-gvfs-monitor-file-process-filter)
	(with-current-buffer (process-buffer p)
	  (setq default-directory (file-name-directory file-name)))
	p))))

(defun tramp-gvfs-file-gvfs-monitor-file-process-filter (proc string)
  "Read output from \"gvfs-monitor-file\" and add corresponding file-notify events."
  (let* ((rest-string (tramp-compat-process-get proc 'rest-string))
	 (dd (with-current-buffer (process-buffer proc) default-directory))
	 (ddu (regexp-quote (tramp-gvfs-url-file-name dd))))
    (when rest-string
      (tramp-message proc 10 "Previous string:\n%s" rest-string))
    (tramp-message proc 6 "%S\n%s" proc string)
    (setq string (concat rest-string string)
	  ;; Attribute change is returned in unused wording.
	  string (tramp-compat-replace-regexp-in-string
		  "ATTRIB CHANGED" "ATTRIBUTE_CHANGED" string))

    (while (string-match
	    (concat "^[\n\r]*"
		    "File Monitor Event:[\n\r]+"
		    "File = \\([^\n\r]+\\)[\n\r]+"
		    "Event = \\([^[:blank:]]+\\)[\n\r]+")
	    string)
      (let ((action (intern-soft
		     (tramp-compat-replace-regexp-in-string
		      "_" "-" (downcase (match-string 2 string)))))
	    (file (match-string 1 string)))
	(setq string (replace-match "" nil nil string))
	;; File names are returned as URL paths.  We must convert them.
	(when (string-match ddu file)
	  (setq file (replace-match dd nil nil file)))
	(while (string-match "%\\([0-9A-F]\\{2\\}\\)" file)
	  (setq file
		(replace-match
		 (char-to-string (string-to-number (match-string 1 file) 16))
		 nil nil file)))
	;; Usually, we would add an Emacs event now.  Unfortunately,
	;; `unread-command-events' does not accept several events at
	;; once.  Therefore, we apply the callback directly.
	(tramp-compat-funcall 'file-notify-callback (list proc action file))))

    ;; Save rest of the string.
    (when (zerop (length string)) (setq string nil))
    (when string (tramp-message proc 10 "Rest string:\n%s" string))
    (tramp-compat-process-put proc 'rest-string string)))

(defun tramp-gvfs-handle-file-readable-p (filename)
  "Like `file-readable-p' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    (with-tramp-file-property v localname "file-executable-p"
      (tramp-check-cached-permissions v ?r))))

(defun tramp-gvfs-handle-file-writable-p (filename)
  "Like `file-writable-p' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    (with-tramp-file-property v localname "file-writable-p"
      (if (file-exists-p filename)
	  (tramp-check-cached-permissions v ?w)
	;; If file doesn't exist, check if directory is writable.
	(and (file-directory-p (file-name-directory filename))
	     (file-writable-p (file-name-directory filename)))))))

(defun tramp-gvfs-handle-make-directory (dir &optional parents)
  "Like `make-directory' for Tramp files."
  (with-parsed-tramp-file-name dir nil
    (unless
	(apply
	 'tramp-gvfs-send-command v "gvfs-mkdir"
	 (if parents
	     (list "-p" (tramp-gvfs-url-file-name dir))
	   (list (tramp-gvfs-url-file-name dir))))
      ;; Propagate the error.
      (tramp-error v 'file-error "Couldn't make directory %s" dir))))

(defun tramp-gvfs-handle-rename-file
  (filename newname &optional ok-if-already-exists)
  "Like `rename-file' for Tramp files."
  (with-parsed-tramp-file-name
      (if (tramp-tramp-file-p filename) filename newname) nil

    (when (and (not ok-if-already-exists) (file-exists-p newname))
      (tramp-error
       v 'file-already-exists "File %s already exists" newname))

    (if (or (and (tramp-tramp-file-p filename)
		 (not (tramp-gvfs-file-name-p filename)))
	    (and (tramp-tramp-file-p newname)
		 (not (tramp-gvfs-file-name-p newname))))

	;; We cannot move directly.
	(let ((tmpfile (tramp-compat-make-temp-file filename)))
	  (rename-file filename tmpfile t)
	  (rename-file tmpfile newname ok-if-already-exists))

      ;; Direct move.
      (with-tramp-progress-reporter
	  v 0 (format "Renaming %s to %s" filename newname)
	(unless
	    (tramp-gvfs-send-command
	     v "gvfs-move"
	     (tramp-gvfs-url-file-name filename)
	     (tramp-gvfs-url-file-name newname))
	  ;; Propagate the error.
	  (with-current-buffer (tramp-get-buffer v)
	    (goto-char (point-min))
	    (tramp-error-with-buffer
	     nil v 'file-error
	     "Renaming failed, see buffer `%s' for details." (buffer-name)))))

      (when (tramp-tramp-file-p filename)
	(with-parsed-tramp-file-name filename nil
	  (tramp-flush-file-property v (file-name-directory localname))
	  (tramp-flush-file-property v localname)))

      (when (tramp-tramp-file-p newname)
	(with-parsed-tramp-file-name newname nil
	  (tramp-flush-file-property v (file-name-directory localname))
	  (tramp-flush-file-property v localname))))))

(defun tramp-gvfs-handle-write-region
  (start end filename &optional append visit lockname confirm)
  "Like `write-region' for Tramp files."
  (with-parsed-tramp-file-name filename nil
    ;; XEmacs takes a coding system as the seventh argument, not `confirm'.
    (when (and (not (featurep 'xemacs)) confirm (file-exists-p filename))
      (unless (y-or-n-p (format "File %s exists; overwrite anyway? " filename))
	(tramp-error v 'file-error "File not overwritten")))

    (let ((tmpfile (tramp-compat-make-temp-file filename)))
      (when (and append (file-exists-p filename))
	(copy-file filename tmpfile 'ok))
      ;; We say `no-message' here because we don't want the visited file
      ;; modtime data to be clobbered from the temp file.  We call
      ;; `set-visited-file-modtime' ourselves later on.
      (tramp-run-real-handler
       'write-region
       (if confirm ; don't pass this arg unless defined for backward compat.
	   (list start end tmpfile append 'no-message lockname confirm)
	 (list start end tmpfile append 'no-message lockname)))
      (condition-case nil
	  (rename-file tmpfile filename 'ok-if-already-exists)
	(error
	 (delete-file tmpfile)
	 (tramp-error
	  v 'file-error "Couldn't write region to `%s'" filename))))

    (tramp-flush-file-property v (file-name-directory localname))
    (tramp-flush-file-property v localname)

    ;; Set file modification time.
    (when (or (eq visit t) (stringp visit))
      (set-visited-file-modtime (nth 5 (file-attributes filename))))

    ;; The end.
    (when (or (eq visit t) (null visit) (stringp visit))
      (tramp-message v 0 "Wrote %s" filename))
    (run-hooks 'tramp-handle-write-region-hook)))


;; File name conversions.

(defun tramp-gvfs-url-file-name (filename)
  "Return FILENAME in URL syntax."
  ;; "/" must NOT be hexlified.
  (let ((url-unreserved-chars (append '(?/) url-unreserved-chars))
	result)
    (setq
     result
     (url-recreate-url
      (if (tramp-tramp-file-p filename)
	  (with-parsed-tramp-file-name filename nil
	    (when (and user (string-match tramp-user-with-domain-regexp user))
	      (setq user
		    (concat (match-string 2 user) ";" (match-string 1 user))))
	    (url-parse-make-urlobj
	     method (url-hexify-string user) nil
	     (tramp-file-name-real-host v) (tramp-file-name-port v)
	     (url-hexify-string localname) nil nil t))
	(url-parse-make-urlobj
	 "file" nil nil nil nil
	 (url-hexify-string (file-truename filename)) nil nil t))))
    (when (tramp-tramp-file-p filename)
      (with-parsed-tramp-file-name filename nil
	(tramp-message v 10 "remote file `%s' is URL `%s'" filename result)))
    result))

(defun tramp-gvfs-object-path (filename)
  "Create a D-Bus object path from FILENAME."
  (expand-file-name (dbus-escape-as-identifier filename) tramp-gvfs-path-tramp))

(defun tramp-gvfs-file-name (object-path)
  "Retrieve file name from D-Bus OBJECT-PATH."
  (dbus-unescape-from-identifier
   (tramp-compat-replace-regexp-in-string
    "^.*/\\([^/]+\\)$" "\\1" object-path)))

(defun tramp-bluez-address (device)
  "Return bluetooth device address from a given bluetooth DEVICE name."
  (when (stringp device)
    (if (string-match tramp-ipv6-regexp device)
	(match-string 0 device)
      (cadr (assoc device (tramp-bluez-list-devices))))))

(defun tramp-bluez-device (address)
  "Return bluetooth device name from a given bluetooth device ADDRESS.
ADDRESS can have the form \"xx:xx:xx:xx:xx:xx\" or \"[xx:xx:xx:xx:xx:xx]\"."
  (when (stringp address)
    (while (string-match "[][]" address)
      (setq address (replace-match "" t t address)))
    (let (result)
      (dolist (item (tramp-bluez-list-devices) result)
	(when (string-match address (cadr item))
	  (setq result (car item)))))))


;; D-Bus GVFS functions.

(defun tramp-gvfs-handler-askpassword (message user domain flags)
  "Implementation for the \"org.gtk.vfs.MountOperation.askPassword\" method."
  (let* ((filename
	  (tramp-gvfs-file-name (dbus-event-path-name last-input-event)))
	 (pw-prompt
	  (format
	   "%s for %s "
	   (if (string-match "\\([pP]assword\\|[pP]assphrase\\)" message)
	       (capitalize (match-string 1 message))
	     "Password")
	   filename))
	 password)

    (condition-case nil
	(with-parsed-tramp-file-name filename l
	  (when (and (zerop (length user))
		     (not
		      (zerop (logand flags tramp-gvfs-password-need-username))))
	    (setq user (read-string "User name: ")))
	  (when (and (zerop (length domain))
		     (not
		      (zerop (logand flags tramp-gvfs-password-need-domain))))
	    (setq domain (read-string "Domain name: ")))

	  (tramp-message l 6 "%S %S %S %d" message user domain flags)
	  (unless (tramp-get-connection-property l "first-password-request" nil)
	    (tramp-clear-passwd l))

	  (setq tramp-current-method l-method
		tramp-current-user user
		tramp-current-host l-host
		password (tramp-read-passwd
			  (tramp-get-connection-process l) pw-prompt))

	  ;; Return result.
	  (if (stringp password)
	      (list
	       t ;; password handled.
	       nil ;; no abort of D-Bus.
	       password
	       (tramp-file-name-real-user l)
	       domain
	       nil ;; not anonymous.
	       0) ;; no password save.
	    ;; No password provided.
	    (list nil t "" (tramp-file-name-real-user l) domain nil 0)))

      ;; When QUIT is raised, we shall return this information to D-Bus.
      (quit (list nil t "" "" "" nil 0)))))

(defun tramp-gvfs-handler-askquestion (message choices)
  "Implementation for the \"org.gtk.vfs.MountOperation.askQuestion\" method."
  (save-window-excursion
    (let ((enable-recursive-minibuffers t)
	  choice)

      (condition-case nil
	  (with-parsed-tramp-file-name
	      (tramp-gvfs-file-name (dbus-event-path-name last-input-event)) nil
	    (tramp-message v 6 "%S %S" message choices)

	    ;; In theory, there can be several choices.  Until now,
	    ;; there is only the question whether to accept an unknown
	    ;; host signature.
	    (with-temp-buffer
	      ;; Preserve message for `progress-reporter'.
	      (tramp-compat-with-temp-message ""
		(insert message)
		(pop-to-buffer (current-buffer))
		(setq choice (if (yes-or-no-p (concat (car choices) " ")) 0 1))
		(tramp-message v 6 "%d" choice)))

	    ;; When the choice is "no", we set a dummy fuse-mountpoint
	    ;; in order to leave the timeout.
	    (unless (zerop choice)
	      (tramp-set-file-property v "/" "fuse-mountpoint" "/"))

	    (list
	     t ;; handled.
	     nil ;; no abort of D-Bus.
	     choice))

	;; When QUIT is raised, we shall return this information to D-Bus.
	(quit (list nil t 0))))))

(defun tramp-gvfs-handler-mounted-unmounted (mount-info)
  "Signal handler for the \"org.gtk.vfs.MountTracker.mounted\" and
\"org.gtk.vfs.MountTracker.unmounted\" signals."
  (ignore-errors
    (let ((signal-name (dbus-event-member-name last-input-event))
	  (elt mount-info))
      ;; Jump over the first elements of the mount info. Since there
      ;; were changes in the entries, we cannot access dedicated
      ;; elements.
      (while (stringp (car elt)) (setq elt (cdr elt)))
      (let* ((fuse-mountpoint (tramp-gvfs-dbus-byte-array-to-string (cadr elt)))
	     (mount-spec (caddr elt))
	     (default-location (tramp-gvfs-dbus-byte-array-to-string
				(cadddr elt)))
	     (method (tramp-gvfs-dbus-byte-array-to-string
		      (cadr (assoc "type" (cadr mount-spec)))))
	     (user (tramp-gvfs-dbus-byte-array-to-string
		    (cadr (assoc "user" (cadr mount-spec)))))
	     (domain (tramp-gvfs-dbus-byte-array-to-string
		      (cadr (assoc "domain" (cadr mount-spec)))))
	     (host (tramp-gvfs-dbus-byte-array-to-string
		    (cadr (or (assoc "host" (cadr mount-spec))
			      (assoc "server" (cadr mount-spec))))))
	     (port (tramp-gvfs-dbus-byte-array-to-string
		    (cadr (assoc "port" (cadr mount-spec)))))
	     (ssl (tramp-gvfs-dbus-byte-array-to-string
		   (cadr (assoc "ssl" (cadr mount-spec)))))
	     (prefix (concat (tramp-gvfs-dbus-byte-array-to-string
			      (car mount-spec))
			     (tramp-gvfs-dbus-byte-array-to-string
			      (cadr (assoc "share" (cadr mount-spec)))))))
	(when (string-match "^smb" method)
	  (setq method "smb"))
	(when (string-equal "obex" method)
	  (setq host (tramp-bluez-device host)))
	(when (and (string-equal "dav" method) (string-equal "true" ssl))
	  (setq method "davs"))
	(unless (zerop (length domain))
	  (setq user (concat user tramp-prefix-domain-format domain)))
	(unless (zerop (length port))
	  (setq host (concat host tramp-prefix-port-format port)))
	(with-parsed-tramp-file-name
	    (tramp-make-tramp-file-name method user host "") nil
	  (tramp-message
	   v 6 "%s %s"
	   signal-name (tramp-gvfs-stringify-dbus-message mount-info))
	  (tramp-set-file-property v "/" "list-mounts" 'undef)
	  (if (string-equal (downcase signal-name) "unmounted")
	      (tramp-set-file-property v "/" "fuse-mountpoint" nil)
	    ;; Set prefix, mountpoint and location.
	    (unless (string-equal prefix "/")
	      (tramp-set-file-property v "/" "prefix" prefix))
	    (tramp-set-file-property v "/" "fuse-mountpoint" fuse-mountpoint)
	    (tramp-set-file-property
	     v "/" "default-location" default-location)))))))

(when tramp-gvfs-enabled
  (dbus-register-signal
   :session nil tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker "mounted"
   'tramp-gvfs-handler-mounted-unmounted)
  (dbus-register-signal
   :session nil tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker "Mounted"
   'tramp-gvfs-handler-mounted-unmounted)

  (dbus-register-signal
   :session nil tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker "unmounted"
   'tramp-gvfs-handler-mounted-unmounted)
  (dbus-register-signal
   :session nil tramp-gvfs-path-mounttracker
   tramp-gvfs-interface-mounttracker "Unmounted"
   'tramp-gvfs-handler-mounted-unmounted))

(defun tramp-gvfs-connection-mounted-p (vec)
  "Check, whether the location is already mounted."
  (or
   (tramp-get-file-property vec "/" "fuse-mountpoint" nil)
   (catch 'mounted
     (dolist
	 (elt
	  (with-tramp-file-property vec "/" "list-mounts"
	    (with-tramp-dbus-call-method vec t
	      :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
	      tramp-gvfs-interface-mounttracker tramp-gvfs-listmounts))
	  nil)
       ;; Jump over the first elements of the mount info. Since there
       ;; were changes in the entries, we cannot access dedicated
       ;; elements.
       (while (stringp (car elt)) (setq elt (cdr elt)))
       (let* ((fuse-mountpoint (tramp-gvfs-dbus-byte-array-to-string
				(cadr elt)))
	      (mount-spec (caddr elt))
	      (default-location (tramp-gvfs-dbus-byte-array-to-string
				 (cadddr elt)))
	      (method (tramp-gvfs-dbus-byte-array-to-string
		       (cadr (assoc "type" (cadr mount-spec)))))
	      (user (tramp-gvfs-dbus-byte-array-to-string
		     (cadr (assoc "user" (cadr mount-spec)))))
	      (domain (tramp-gvfs-dbus-byte-array-to-string
		       (cadr (assoc "domain" (cadr mount-spec)))))
	      (host (tramp-gvfs-dbus-byte-array-to-string
		     (cadr (or (assoc "host" (cadr mount-spec))
			       (assoc "server" (cadr mount-spec))))))
	      (port (tramp-gvfs-dbus-byte-array-to-string
		     (cadr (assoc "port" (cadr mount-spec)))))
	      (ssl (tramp-gvfs-dbus-byte-array-to-string
		    (cadr (assoc "ssl" (cadr mount-spec)))))
	      (prefix (concat (tramp-gvfs-dbus-byte-array-to-string
			       (car mount-spec))
			      (tramp-gvfs-dbus-byte-array-to-string
			       (cadr (assoc "share" (cadr mount-spec)))))))
	 (when (string-match "^smb" method)
	   (setq method "smb"))
	 (when (string-equal "obex" method)
	   (setq host (tramp-bluez-device host)))
	 (when (and (string-equal "dav" method) (string-equal "true" ssl))
	   (setq method "davs"))
	 (when (and (string-equal "synce" method) (zerop (length user)))
	   (setq user (or (tramp-file-name-user vec) "")))
	 (unless (zerop (length domain))
	   (setq user (concat user tramp-prefix-domain-format domain)))
	 (unless (zerop (length port))
	   (setq host (concat host tramp-prefix-port-format port)))
	 (when (and
		(string-equal method (tramp-file-name-method vec))
		(string-equal user (or (tramp-file-name-user vec) ""))
		(string-equal host (tramp-file-name-host vec))
		(string-match (concat "^" (regexp-quote prefix))
			      (tramp-file-name-localname vec)))
	   ;; Set prefix, mountpoint and location.
	   (unless (string-equal prefix "/")
	     (tramp-set-file-property vec "/" "prefix" prefix))
	   (tramp-set-file-property vec "/" "fuse-mountpoint" fuse-mountpoint)
	   (tramp-set-file-property vec "/" "default-location" default-location)
	   (throw 'mounted t)))))))

(defun tramp-gvfs-mount-spec-entry (key value)
  "Construct a mount-spec entry to be used in a mount_spec.
It was \"a(say)\", but has changed to \"a{sv})\"."
  (if (string-match "^(aya{sv})" tramp-gvfs-mountlocation-signature)
      (list :dict-entry key
	    (list :variant (tramp-gvfs-dbus-string-to-byte-array value)))
    (list :struct key (tramp-gvfs-dbus-string-to-byte-array value))))

(defun tramp-gvfs-mount-spec (vec)
  "Return a mount-spec for \"org.gtk.vfs.MountTracker.mountLocation\"."
  (let* ((method (tramp-file-name-method vec))
	 (user (tramp-file-name-real-user vec))
	 (domain (tramp-file-name-domain vec))
	 (host (tramp-file-name-real-host vec))
	 (port (tramp-file-name-port vec))
	 (localname (tramp-file-name-localname vec))
	 (ssl (if (string-match "^davs" method) "true" "false"))
	 (mount-spec
          `(:array
            ,@(cond
               ((string-equal "smb" method)
                (string-match "^/?\\([^/]+\\)" localname)
                (list (tramp-gvfs-mount-spec-entry "type" "smb-share")
                      (tramp-gvfs-mount-spec-entry "server" host)
                      (tramp-gvfs-mount-spec-entry
		       "share" (match-string 1 localname))))
               ((string-equal "obex" method)
                (list (tramp-gvfs-mount-spec-entry "type" method)
                      (tramp-gvfs-mount-spec-entry
                       "host" (concat "[" (tramp-bluez-address host) "]"))))
               ((string-match "\\`dav" method)
                (list (tramp-gvfs-mount-spec-entry "type" "dav")
                      (tramp-gvfs-mount-spec-entry "host" host)
                      (tramp-gvfs-mount-spec-entry "ssl" ssl)))
               (t
                (list (tramp-gvfs-mount-spec-entry "type" method)
                      (tramp-gvfs-mount-spec-entry "host" host))))
            ,@(when user
                (list (tramp-gvfs-mount-spec-entry "user" user)))
            ,@(when domain
                (list (tramp-gvfs-mount-spec-entry "domain" domain)))
            ,@(when port
                (list (tramp-gvfs-mount-spec-entry
		       "port" (number-to-string port))))))
	 (mount-pref
          (if (and (string-match "\\`dav" method)
                   (string-match "^/?[^/]+" localname))
              (match-string 0 localname)
            "/")))

    ;; Return.
    `(:struct ,(tramp-gvfs-dbus-string-to-byte-array mount-pref) ,mount-spec)))


;; Connection functions.

(defun tramp-gvfs-maybe-open-connection (vec)
  "Maybe open a connection VEC.
Does not do anything if a connection is already open, but re-opens the
connection if a previous connection has died for some reason."
  (tramp-check-proper-method-and-host vec)

  ;; We set the file name, in case there are incoming D-Bus signals or
  ;; D-Bus errors.
  (setq tramp-gvfs-dbus-event-vector vec)

  ;; For password handling, we need a process bound to the connection
  ;; buffer.  Therefore, we create a dummy process.  Maybe there is a
  ;; better solution?
  (unless (get-buffer-process (tramp-get-connection-buffer vec))
    (let ((p (make-network-process
	      :name (tramp-buffer-name vec)
	      :buffer (tramp-get-connection-buffer vec)
	      :server t :host 'local :service t)))
      (tramp-compat-set-process-query-on-exit-flag p nil)))

  (unless (tramp-gvfs-connection-mounted-p vec)
    (let* ((method (tramp-file-name-method vec))
	   (user (tramp-file-name-user vec))
	   (host (tramp-file-name-host vec))
	   (localname (tramp-file-name-localname vec))
	   (object-path
	    (tramp-gvfs-object-path
	     (tramp-make-tramp-file-name method user host ""))))

      (when (and (string-equal method "smb")
		 (string-equal localname "/"))
	(tramp-error vec 'file-error "Filename must contain a Windows share"))

      (with-tramp-progress-reporter
	  vec 3
	  (if (zerop (length user))
	      (format "Opening connection for %s using %s" host method)
	    (format "Opening connection for %s@%s using %s" user host method))

	;; Enable `auth-source'.
	(tramp-set-connection-property vec "first-password-request" t)

	;; There will be a callback of "askPassword" when a password is
	;; needed.
	(dbus-register-method
	 :session dbus-service-emacs object-path
	 tramp-gvfs-interface-mountoperation "askPassword"
	 'tramp-gvfs-handler-askpassword)
	(dbus-register-method
	 :session dbus-service-emacs object-path
	 tramp-gvfs-interface-mountoperation "AskPassword"
	 'tramp-gvfs-handler-askpassword)

	;; There could be a callback of "askQuestion" when adding fingerprint.
	(dbus-register-method
	 :session dbus-service-emacs object-path
	 tramp-gvfs-interface-mountoperation "askQuestion"
	 'tramp-gvfs-handler-askquestion)
	(dbus-register-method
	 :session dbus-service-emacs object-path
	 tramp-gvfs-interface-mountoperation "AskQuestion"
	 'tramp-gvfs-handler-askquestion)

	;; The call must be asynchronously, because of the "askPassword"
	;; or "askQuestion"callbacks.
	(if (string-match "(so)$" tramp-gvfs-mountlocation-signature)
	    (with-tramp-dbus-call-method vec nil
	      :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
	      tramp-gvfs-interface-mounttracker tramp-gvfs-mountlocation
	      (tramp-gvfs-mount-spec vec)
	      `(:struct :string ,(dbus-get-unique-name :session)
			:object-path ,object-path))
	  (with-tramp-dbus-call-method vec nil
	    :session tramp-gvfs-service-daemon tramp-gvfs-path-mounttracker
	    tramp-gvfs-interface-mounttracker tramp-gvfs-mountlocation
	    (tramp-gvfs-mount-spec vec)
	    :string (dbus-get-unique-name :session) :object-path object-path))

	;; We must wait, until the mount is applied.  This will be
	;; indicated by the "mounted" signal, i.e. the "fuse-mountpoint"
	;; file property.
	(with-timeout
	    ((or (tramp-get-method-parameter method 'tramp-connection-timeout)
		 tramp-connection-timeout)
	     (if (zerop (length (tramp-file-name-user vec)))
		 (tramp-error
		  vec 'file-error
		  "Timeout reached mounting %s using %s" host method)
	       (tramp-error
		vec 'file-error
		"Timeout reached mounting %s@%s using %s" user host method)))
	  (while (not (tramp-get-file-property vec "/" "fuse-mountpoint" nil))
	    (read-event nil nil 0.1)))

	;; If `tramp-gvfs-handler-askquestion' has returned "No", it
	;; is marked with the fuse-mountpoint "/".  We shall react.
	(when (string-equal
	       (tramp-get-file-property vec "/" "fuse-mountpoint" "") "/")
	  (tramp-error vec 'file-error "FUSE mount denied")))))

  ;; In `tramp-check-cached-permissions', the connection properties
  ;; {uig,gid}-{integer,string} are used.  We set them to their local
  ;; counterparts.
  (with-tramp-connection-property
   vec "uid-integer" (tramp-get-local-uid 'integer))
  (with-tramp-connection-property
   vec "gid-integer" (tramp-get-local-gid 'integer))
  (with-tramp-connection-property
   vec "uid-string" (tramp-get-local-uid 'string))
  (with-tramp-connection-property
   vec "gid-string" (tramp-get-local-gid 'string)))

(defun tramp-gvfs-send-command (vec command &rest args)
  "Send the COMMAND with its ARGS to connection VEC.
COMMAND is usually a command from the gvfs-* utilities.
`call-process' is applied, and it returns `t' if the return code is zero."
  (let (result)
    (with-current-buffer (tramp-get-connection-buffer vec)
      (tramp-gvfs-maybe-open-connection vec)
      (erase-buffer)
      (tramp-message vec 6 "%s %s" command (mapconcat 'identity args " "))
      (setq result (apply 'tramp-call-process command nil t nil args))
      (tramp-message vec 6 "\n%s" (buffer-string))
      (zerop result))))


;; D-Bus BLUEZ functions.

(defun tramp-bluez-list-devices ()
  "Return all discovered bluetooth devices as list.
Every entry is a list (NAME ADDRESS).

If `tramp-bluez-discover-devices-timeout' is an integer, and the last
discovery happened more time before indicated there, a rescan will be
started, which lasts some ten seconds.  Otherwise, cached results will
be used."
  ;; Reset the scanned devices list if time has passed.
  (and (integerp tramp-bluez-discover-devices-timeout)
       (integerp tramp-bluez-discovery)
       (> (tramp-time-diff (current-time) tramp-bluez-discovery)
	  tramp-bluez-discover-devices-timeout)
       (setq tramp-bluez-devices nil))

  ;; Rescan if needed.
  (unless tramp-bluez-devices
    (let ((object-path
	   (with-tramp-dbus-call-method tramp-gvfs-dbus-event-vector t
	     :system tramp-bluez-service "/"
	     tramp-bluez-interface-manager "DefaultAdapter")))
      (setq tramp-bluez-devices nil
	    tramp-bluez-discovery t)
      (with-tramp-dbus-call-method tramp-gvfs-dbus-event-vector nil
	:system tramp-bluez-service object-path
	tramp-bluez-interface-adapter "StartDiscovery")
      (while tramp-bluez-discovery
	(read-event nil nil 0.1))))
  (setq tramp-bluez-discovery (current-time))
  (tramp-message tramp-gvfs-dbus-event-vector 10 "%s" tramp-bluez-devices)
  tramp-bluez-devices)

(defun tramp-bluez-property-changed (property value)
  "Signal handler for the \"org.bluez.Adapter.PropertyChanged\" signal."
  (tramp-message tramp-gvfs-dbus-event-vector 6 "%s %s" property value)
  (cond
   ((string-equal property "Discovering")
    (unless (car value)
      ;; "Discovering" FALSE means discovery run has been completed.
      ;; We stop it, because we don't need another run.
      (setq tramp-bluez-discovery nil)
      (with-tramp-dbus-call-method tramp-gvfs-dbus-event-vector t
	:system tramp-bluez-service (dbus-event-path-name last-input-event)
	tramp-bluez-interface-adapter "StopDiscovery")))))

(when tramp-gvfs-enabled
  (dbus-register-signal
   :system nil nil tramp-bluez-interface-adapter "PropertyChanged"
   'tramp-bluez-property-changed))

(defun tramp-bluez-device-found (device args)
  "Signal handler for the \"org.bluez.Adapter.DeviceFound\" signal."
  (tramp-message tramp-gvfs-dbus-event-vector 6 "%s %s" device args)
  (let ((alias (car (cadr (assoc "Alias" args))))
	(address (car (cadr (assoc "Address" args)))))
    ;; Maybe we shall check the device class for being a proper
    ;; device, and call also SDP in order to find the obex service.
    (add-to-list 'tramp-bluez-devices (list alias address))))

(when tramp-gvfs-enabled
  (dbus-register-signal
   :system nil nil tramp-bluez-interface-adapter "DeviceFound"
   'tramp-bluez-device-found))

(defun tramp-bluez-parse-device-names (_ignore)
  "Return a list of (nil host) tuples allowed to access."
  (mapcar
   (lambda (x) (list nil (car x)))
   (tramp-bluez-list-devices)))

;; Add completion function for OBEX method.
(when (and tramp-gvfs-enabled
	   (member tramp-bluez-service (dbus-list-known-names :system)))
  (tramp-set-completion-function
   "obex" '((tramp-bluez-parse-device-names ""))))


;; D-Bus zeroconf functions.

(defun tramp-zeroconf-parse-workstation-device-names (_ignore)
  "Return a list of (user host) tuples allowed to access."
  (mapcar
   (lambda (x)
     (list nil (zeroconf-service-host x)))
   (zeroconf-list-services "_workstation._tcp")))

(defun tramp-zeroconf-parse-webdav-device-names (_ignore)
  "Return a list of (user host) tuples allowed to access."
  (mapcar
   (lambda (x)
     (let ((host (zeroconf-service-host x))
	   (port (zeroconf-service-port x))
	   (text (zeroconf-service-txt x))
	   user)
       (when port
	 (setq host (format "%s%s%d" host tramp-prefix-port-regexp port)))
       ;; A user is marked in a TXT field like "u=guest".
       (while text
	 (when (string-match "u=\\(.+\\)$" (car text))
	   (setq user (match-string 1 (car text))))
	 (setq text (cdr text)))
       (list user host)))
   (zeroconf-list-services "_webdav._tcp")))

;; Add completion function for DAV and DAVS methods.
(when (and tramp-gvfs-enabled
	   (member zeroconf-service-avahi (dbus-list-known-names :system)))
  (zeroconf-init tramp-gvfs-zeroconf-domain)
  (tramp-set-completion-function
   "sftp" '((tramp-zeroconf-parse-workstation-device-names "")))
  (tramp-set-completion-function
   "dav" '((tramp-zeroconf-parse-webdav-device-names "")))
  (tramp-set-completion-function
   "davs" '((tramp-zeroconf-parse-webdav-device-names ""))))


;; D-Bus SYNCE functions.

(defun tramp-synce-list-devices ()
  "Return all discovered synce devices as list.
They are retrieved from the hal daemon."
  (let (tramp-synce-devices)
    (dolist (device
	     (with-tramp-dbus-call-method tramp-gvfs-dbus-event-vector t
	       :system tramp-hal-service tramp-hal-path-manager
	       tramp-hal-interface-manager "GetAllDevices"))
      (when (with-tramp-dbus-call-method tramp-gvfs-dbus-event-vector t
	      :system tramp-hal-service device tramp-hal-interface-device
	      "PropertyExists" "sync.plugin")
	(let ((prop
	       (with-tramp-dbus-call-method
		tramp-gvfs-dbus-event-vector t
		:system tramp-hal-service device tramp-hal-interface-device
		"GetPropertyString" "pda.pocketpc.name")))
	  (unless (member prop tramp-synce-devices)
	    (push prop tramp-synce-devices)))))
    (tramp-message tramp-gvfs-dbus-event-vector 10 "%s" tramp-synce-devices)
    tramp-synce-devices))

(defun tramp-synce-parse-device-names (_ignore)
  "Return a list of (nil host) tuples allowed to access."
  (mapcar
   (lambda (x) (list nil x))
   (tramp-synce-list-devices)))

;; Add completion function for SYNCE method.
(when tramp-gvfs-enabled
  (tramp-set-completion-function
   "synce" '((tramp-synce-parse-device-names ""))))

(add-hook 'tramp-unload-hook
	  (lambda ()
	    (unload-feature 'tramp-gvfs 'force)))

(provide 'tramp-gvfs)

;;; TODO:

;; * Host name completion via smb-server or smb-network.
;; * Check how two shares of the same SMB server can be mounted in
;;   parallel.
;; * Apply SDP on bluetooth devices, in order to filter out obex
;;   capability.
;; * Implement obex for other serial communication but bluetooth.

;;; tramp-gvfs.el ends here
