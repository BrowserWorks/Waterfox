;;; dbus.el --- Elisp bindings for D-Bus.

;; Copyright (C) 2007-2013 Free Software Foundation, Inc.

;; Author: Michael Albinus <michael.albinus@gmx.de>
;; Keywords: comm, hardware

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

;; This package provides language bindings for the D-Bus API.  D-Bus
;; is a message bus system, a simple way for applications to talk to
;; one another.  See <http://dbus.freedesktop.org/> for details.

;; Low-level language bindings are implemented in src/dbusbind.c.

;; D-Bus support in the Emacs core can be disabled with configuration
;; option "--without-dbus".

;;; Code:

;; Declare used subroutines and variables.
(declare-function dbus-message-internal "dbusbind.c")
(declare-function dbus-init-bus "dbusbind.c")
(defvar dbus-message-type-invalid)
(defvar dbus-message-type-method-call)
(defvar dbus-message-type-method-return)
(defvar dbus-message-type-error)
(defvar dbus-message-type-signal)
(defvar dbus-debug)
(defvar dbus-registered-objects-table)

;; Pacify byte compiler.
(eval-when-compile (require 'cl-lib))

(require 'xml)

(defconst dbus-service-dbus "org.freedesktop.DBus"
  "The bus name used to talk to the bus itself.")

(defconst dbus-path-dbus "/org/freedesktop/DBus"
  "The object path used to talk to the bus itself.")

;; Default D-Bus interfaces.

(defconst dbus-interface-dbus "org.freedesktop.DBus"
  "The interface exported by the service `dbus-service-dbus'.")

(defconst dbus-interface-peer (concat dbus-interface-dbus ".Peer")
  "The interface for peer objects.
See URL `http://dbus.freedesktop.org/doc/dbus-specification.html#standard-interfaces-peer'.")

;; <interface name="org.freedesktop.DBus.Peer">
;;   <method name="Ping">
;;   </method>
;;   <method name="GetMachineId">
;;     <arg name="machine_uuid" type="s" direction="out"/>
;;   </method>
;; </interface>

(defconst dbus-interface-introspectable
  (concat dbus-interface-dbus ".Introspectable")
  "The interface supported by introspectable objects.
See URL `http://dbus.freedesktop.org/doc/dbus-specification.html#standard-interfaces-introspectable'.")

;; <interface name="org.freedesktop.DBus.Introspectable">
;;   <method name="Introspect">
;;     <arg name="data" type="s" direction="out"/>
;;   </method>
;; </interface>

(defconst dbus-interface-properties (concat dbus-interface-dbus ".Properties")
  "The interface for property objects.
See URL `http://dbus.freedesktop.org/doc/dbus-specification.html#standard-interfaces-properties'.")

;; <interface name="org.freedesktop.DBus.Properties">
;;   <method name="Get">
;;     <arg name="interface" type="s" direction="in"/>
;;     <arg name="propname"  type="s" direction="in"/>
;;     <arg name="value"     type="v" direction="out"/>
;;   </method>
;;   <method name="Set">
;;     <arg name="interface" type="s" direction="in"/>
;;     <arg name="propname"  type="s" direction="in"/>
;;     <arg name="value"     type="v" direction="in"/>
;;   </method>
;;   <method name="GetAll">
;;     <arg name="interface" type="s" direction="in"/>
;;     <arg name="props"     type="a{sv}" direction="out"/>
;;   </method>
;;   <signal name="PropertiesChanged">
;;     <arg name="interface" type="s"/>
;;     <arg name="changed_properties"     type="a{sv}"/>
;;     <arg name="invalidated_properties" type="as"/>
;;   </signal>
;; </interface>

(defconst dbus-interface-objectmanager
  (concat dbus-interface-dbus ".ObjectManager")
  "The object manager interface.
See URL `http://dbus.freedesktop.org/doc/dbus-specification.html#standard-interfaces-objectmanager'.")

;; <interface name="org.freedesktop.DBus.ObjectManager">
;;   <method name="GetManagedObjects">
;;     <arg name="object_paths_interfaces_and_properties"
;;          type="a{oa{sa{sv}}}" direction="out"/>
;;   </method>
;;   <signal name="InterfacesAdded">
;;     <arg name="object_path"               type="o"/>
;;     <arg name="interfaces_and_properties" type="a{sa{sv}}"/>
;;   </signal>
;;   <signal name="InterfacesRemoved">
;;     <arg name="object_path"               type="o"/>
;;     <arg name="interfaces"                type="as"/>
;;   </signal>
;; </interface>

;; Emacs defaults.
(defconst dbus-service-emacs "org.gnu.Emacs"
  "The well known service name of Emacs.")

(defconst dbus-path-emacs "/org/gnu/Emacs"
  "The object path namespace used by Emacs.
All object paths provided by the service `dbus-service-emacs'
shall be subdirectories of this path.")

(defconst dbus-interface-emacs "org.gnu.Emacs"
  "The interface namespace used by Emacs.")

;; D-Bus constants.

(defmacro dbus-ignore-errors (&rest body)
  "Execute BODY; signal D-Bus error when `dbus-debug' is non-nil.
Otherwise, return result of last form in BODY, or all other errors."
  (declare (indent 0) (debug t))
  `(condition-case err
       (progn ,@body)
     (dbus-error (when dbus-debug (signal (car err) (cdr err))))))
(font-lock-add-keywords 'emacs-lisp-mode '("\\<dbus-ignore-errors\\>"))

(define-obsolete-variable-alias 'dbus-event-error-hooks
  'dbus-event-error-functions "24.3")
(defvar dbus-event-error-functions nil
  "Functions to be called when a D-Bus error happens in the event handler.
Every function must accept two arguments, the event and the error variable
caught in `condition-case' by `dbus-error'.")


;;; Basic D-Bus message functions.

(defvar dbus-return-values-table (make-hash-table :test 'equal)
  "Hash table for temporary storing arguments of reply messages.
A key in this hash table is a list (:serial BUS SERIAL), like in
`dbus-registered-objects-table'.  BUS is either a Lisp symbol,
`:system' or `:session', or a string denoting the bus address.
SERIAL is the serial number of the reply message.")

(defun dbus-call-method-handler (&rest args)
  "Handler for reply messages of asynchronous D-Bus message calls.
It calls the function stored in `dbus-registered-objects-table'.
The result will be made available in `dbus-return-values-table'."
  (puthash (list  :serial
		  (dbus-event-bus-name last-input-event)
		 (dbus-event-serial-number last-input-event))
	   (if (= (length args) 1) (car args) args)
	   dbus-return-values-table))

(defun dbus-call-method (bus service path interface method &rest args)
  "Call METHOD on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name to be used.  PATH is the D-Bus
object path SERVICE is registered at.  INTERFACE is an interface
offered by SERVICE.  It must provide METHOD.

If the parameter `:timeout' is given, the following integer TIMEOUT
specifies the maximum number of milliseconds the method call must
return.  The default value is 25,000.  If the method call doesn't
return in time, a D-Bus error is raised.

All other arguments ARGS are passed to METHOD as arguments.  They are
converted into D-Bus types via the following rules:

  t and nil => DBUS_TYPE_BOOLEAN
  number    => DBUS_TYPE_UINT32
  integer   => DBUS_TYPE_INT32
  float     => DBUS_TYPE_DOUBLE
  string    => DBUS_TYPE_STRING
  list      => DBUS_TYPE_ARRAY

All arguments can be preceded by a type symbol.  For details about
type symbols, see Info node `(dbus)Type Conversion'.

`dbus-call-method' returns the resulting values of METHOD as a list of
Lisp objects.  The type conversion happens the other direction as for
input arguments.  It follows the mapping rules:

  DBUS_TYPE_BOOLEAN     => t or nil
  DBUS_TYPE_BYTE        => number
  DBUS_TYPE_UINT16      => number
  DBUS_TYPE_INT16       => integer
  DBUS_TYPE_UINT32      => number or float
  DBUS_TYPE_UNIX_FD     => number or float
  DBUS_TYPE_INT32       => integer or float
  DBUS_TYPE_UINT64      => number or float
  DBUS_TYPE_INT64       => integer or float
  DBUS_TYPE_DOUBLE      => float
  DBUS_TYPE_STRING      => string
  DBUS_TYPE_OBJECT_PATH => string
  DBUS_TYPE_SIGNATURE   => string
  DBUS_TYPE_ARRAY       => list
  DBUS_TYPE_VARIANT     => list
  DBUS_TYPE_STRUCT      => list
  DBUS_TYPE_DICT_ENTRY  => list

Example:

\(dbus-call-method
  :session \"org.gnome.seahorse\" \"/org/gnome/seahorse/keys/openpgp\"
  \"org.gnome.seahorse.Keys\" \"GetKeyField\"
  \"openpgp:657984B8C7A966DD\" \"simple-name\")

  => (t (\"Philip R. Zimmermann\"))

If the result of the METHOD call is just one value, the converted Lisp
object is returned instead of a list containing this single Lisp object.

\(dbus-call-method
  :system \"org.freedesktop.Hal\" \"/org/freedesktop/Hal/devices/computer\"
  \"org.freedesktop.Hal.Device\" \"GetPropertyString\"
  \"system.kernel.machine\")

  => \"i686\""

  (or (memq bus '(:system :session)) (stringp bus)
      (signal 'wrong-type-argument (list 'keywordp bus)))
  (or (stringp service)
      (signal 'wrong-type-argument (list 'stringp service)))
  (or (stringp path)
      (signal 'wrong-type-argument (list 'stringp path)))
  (or (stringp interface)
      (signal 'wrong-type-argument (list 'stringp interface)))
  (or (stringp method)
      (signal 'wrong-type-argument (list 'stringp method)))

  (let ((timeout (plist-get args :timeout))
	(key
	 (apply
	  'dbus-message-internal dbus-message-type-method-call
	  bus service path interface method 'dbus-call-method-handler args)))

    ;; Wait until `dbus-call-method-handler' has put the result into
    ;; `dbus-return-values-table'.  If no timeout is given, use the
    ;; default 25".  Events which are not from D-Bus must be restored.
    (with-timeout ((if timeout (/ timeout 1000.0) 25))
      (while (eq (gethash key dbus-return-values-table :ignore) :ignore)
	(let ((event (let (unread-command-events) (read-event nil nil 0.1))))
	  (when (and event (not (ignore-errors (dbus-check-event event))))
	    (setq unread-command-events
		  (append unread-command-events (list event)))))))

    ;; Cleanup `dbus-return-values-table'.  Return the result.
    (prog1
	(gethash key dbus-return-values-table)
      (remhash key dbus-return-values-table))))

;; `dbus-call-method' works non-blocking now.
(defalias 'dbus-call-method-non-blocking 'dbus-call-method)
(make-obsolete 'dbus-call-method-non-blocking 'dbus-call-method "24.3")

(defun dbus-call-method-asynchronously
 (bus service path interface method handler &rest args)
 "Call METHOD on the D-Bus BUS asynchronously.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name to be used.  PATH is the D-Bus
object path SERVICE is registered at.  INTERFACE is an interface
offered by SERVICE.  It must provide METHOD.

HANDLER is a Lisp function, which is called when the corresponding
return message has arrived.  If HANDLER is nil, no return message
will be expected.

If the parameter `:timeout' is given, the following integer TIMEOUT
specifies the maximum number of milliseconds the method call must
return.  The default value is 25,000.  If the method call doesn't
return in time, a D-Bus error is raised.

All other arguments ARGS are passed to METHOD as arguments.  They are
converted into D-Bus types via the following rules:

  t and nil => DBUS_TYPE_BOOLEAN
  number    => DBUS_TYPE_UINT32
  integer   => DBUS_TYPE_INT32
  float     => DBUS_TYPE_DOUBLE
  string    => DBUS_TYPE_STRING
  list      => DBUS_TYPE_ARRAY

All arguments can be preceded by a type symbol.  For details about
type symbols, see Info node `(dbus)Type Conversion'.

If HANDLER is a Lisp function, the function returns a key into the
hash table `dbus-registered-objects-table'.  The corresponding entry
in the hash table is removed, when the return message has been arrived,
and HANDLER is called.

Example:

\(dbus-call-method-asynchronously
  :system \"org.freedesktop.Hal\" \"/org/freedesktop/Hal/devices/computer\"
  \"org.freedesktop.Hal.Device\" \"GetPropertyString\" 'message
  \"system.kernel.machine\")

  => \(:serial :system 2)

  -| i686"

  (or (memq bus '(:system :session)) (stringp bus)
      (signal 'wrong-type-argument (list 'keywordp bus)))
  (or (stringp service)
      (signal 'wrong-type-argument (list 'stringp service)))
  (or (stringp path)
      (signal 'wrong-type-argument (list 'stringp path)))
  (or (stringp interface)
      (signal 'wrong-type-argument (list 'stringp interface)))
  (or (stringp method)
      (signal 'wrong-type-argument (list 'stringp method)))
  (or (null handler) (functionp handler)
      (signal 'wrong-type-argument (list 'functionp handler)))

  (apply 'dbus-message-internal dbus-message-type-method-call
	 bus service path interface method handler args))

(defun dbus-send-signal (bus service path interface signal &rest args)
  "Send signal SIGNAL on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.  The signal is sent from the D-Bus object
Emacs is registered at BUS.

SERVICE is the D-Bus name SIGNAL is sent to.  It can be either a known
name or a unique name.  If SERVICE is nil, the signal is sent as
broadcast message.  PATH is the D-Bus object path SIGNAL is sent from.
INTERFACE is an interface available at PATH.  It must provide signal
SIGNAL.

All other arguments ARGS are passed to SIGNAL as arguments.  They are
converted into D-Bus types via the following rules:

  t and nil => DBUS_TYPE_BOOLEAN
  number    => DBUS_TYPE_UINT32
  integer   => DBUS_TYPE_INT32
  float     => DBUS_TYPE_DOUBLE
  string    => DBUS_TYPE_STRING
  list      => DBUS_TYPE_ARRAY

All arguments can be preceded by a type symbol.  For details about
type symbols, see Info node `(dbus)Type Conversion'.

Example:

\(dbus-send-signal
  :session nil \"/org/gnu/Emacs\" \"org.gnu.Emacs.FileManager\"
  \"FileModified\" \"/home/albinus/.emacs\")"

  (or (memq bus '(:system :session)) (stringp bus)
      (signal 'wrong-type-argument (list 'keywordp bus)))
  (or (null service) (stringp service)
      (signal 'wrong-type-argument (list 'stringp service)))
  (or (stringp path)
      (signal 'wrong-type-argument (list 'stringp path)))
  (or (stringp interface)
      (signal 'wrong-type-argument (list 'stringp interface)))
  (or (stringp signal)
      (signal 'wrong-type-argument (list 'stringp signal)))

  (apply 'dbus-message-internal dbus-message-type-signal
	 bus service path interface signal args))

(defun dbus-method-return-internal (bus service serial &rest args)
  "Return for message SERIAL on the D-Bus BUS.
This is an internal function, it shall not be used outside dbus.el."

  (or (memq bus '(:system :session)) (stringp bus)
      (signal 'wrong-type-argument (list 'keywordp bus)))
  (or (stringp service)
      (signal 'wrong-type-argument (list 'stringp service)))
  (or (natnump serial)
      (signal 'wrong-type-argument (list 'natnump serial)))

  (apply 'dbus-message-internal dbus-message-type-method-return
	 bus service serial args))

(defun dbus-method-error-internal (bus service serial &rest args)
  "Return error message for message SERIAL on the D-Bus BUS.
This is an internal function, it shall not be used outside dbus.el."

  (or (memq bus '(:system :session)) (stringp bus)
      (signal 'wrong-type-argument (list 'keywordp bus)))
  (or (stringp service)
      (signal 'wrong-type-argument (list 'stringp service)))
  (or (natnump serial)
      (signal 'wrong-type-argument (list 'natnump serial)))

  (apply 'dbus-message-internal dbus-message-type-error
	 bus service serial args))


;;; Hash table of registered functions.

(defun dbus-list-hash-table ()
  "Returns all registered member registrations to D-Bus.
The return value is a list, with elements of kind (KEY . VALUE).
See `dbus-registered-objects-table' for a description of the
hash table."
  (let (result)
    (maphash
     (lambda (key value) (add-to-list 'result (cons key value) 'append))
     dbus-registered-objects-table)
    result))

(defun dbus-setenv (bus variable value)
  "Set the value of the BUS environment variable named VARIABLE to VALUE.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.  Both VARIABLE and VALUE should be strings.

Normally, services inherit the environment of the BUS daemon.  This
function adds to or modifies that environment when activating services.

Some bus instances, such as `:system', may disable setting the environment."
  (dbus-call-method
   bus dbus-service-dbus dbus-path-dbus
   dbus-interface-dbus "UpdateActivationEnvironment"
   `(:array (:dict-entry ,variable ,value))))

(defun dbus-register-service (bus service &rest flags)
  "Register known name SERVICE on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name that should be registered.  It must
be a known name.

FLAGS are keywords, which control how the service name is registered.
The following keywords are recognized:

`:allow-replacement': Allow another service to become the primary
owner if requested.

`:replace-existing': Request to replace the current primary owner.

`:do-not-queue': If we can not become the primary owner do not place
us in the queue.

The function returns a keyword, indicating the result of the
operation.  One of the following keywords is returned:

`:primary-owner': Service has become the primary owner of the
requested name.

`:in-queue': Service could not become the primary owner and has been
placed in the queue.

`:exists': Service is already in the queue.

`:already-owner': Service is already the primary owner."

  ;; Add ObjectManager handler.
  (dbus-register-method
   bus service nil dbus-interface-objectmanager "GetManagedObjects"
   'dbus-managed-objects-handler 'dont-register)

  (let ((arg 0)
	reply)
    (dolist (flag flags)
      (setq arg
	    (+ arg
	       (pcase flag
		 (:allow-replacement 1)
		 (:replace-existing 2)
		 (:do-not-queue 4)
		 (_ (signal 'wrong-type-argument (list flag)))))))
    (setq reply (dbus-call-method
		 bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus
		 "RequestName" service arg))
    (pcase reply
      (1 :primary-owner)
      (2 :in-queue)
      (3 :exists)
      (4 :already-owner)
      (_ (signal 'dbus-error (list "Could not register service" service))))))

(defun dbus-unregister-service (bus service)
  "Unregister all objects related to SERVICE from D-Bus BUS.
BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.  SERVICE must be a known service name.

The function returns a keyword, indicating the result of the
operation.  One of the following keywords is returned:

`:released': Service has become the primary owner of the name.

`:non-existent': Service name does not exist on this bus.

`:not-owner': We are neither the primary owner nor waiting in the
queue of this service."

  (maphash
   (lambda (key value)
     (dolist (elt value)
       (ignore-errors
	 (when (and (equal bus (cadr key)) (string-equal service (cadr elt)))
	   (unless
	       (puthash key (delete elt value) dbus-registered-objects-table)
	     (remhash key dbus-registered-objects-table))))))
   dbus-registered-objects-table)
  (let ((reply (dbus-call-method
		bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus
		"ReleaseName" service)))
    (pcase reply
      (1 :released)
      (2 :non-existent)
      (3 :not-owner)
      (_ (signal 'dbus-error (list "Could not unregister service" service))))))

(defun dbus-register-signal
  (bus service path interface signal handler &rest args)
  "Register for a signal on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name used by the sending D-Bus object.
It can be either a known name or the unique name of the D-Bus object
sending the signal.

PATH is the D-Bus object path SERVICE is registered.  INTERFACE
is an interface offered by SERVICE.  It must provide SIGNAL.
HANDLER is a Lisp function to be called when the signal is
received.  It must accept as arguments the values SIGNAL is
sending.

SERVICE, PATH, INTERFACE and SIGNAL can be nil.  This is
interpreted as a wildcard for the respective argument.

The remaining arguments ARGS can be keywords or keyword string pairs.
The meaning is as follows:

`:argN' STRING:
`:pathN' STRING: This stands for the Nth argument of the
signal.  `:pathN' arguments can be used for object path wildcard
matches as specified by D-Bus, while an `:argN' argument
requires an exact match.

`:arg-namespace' STRING: Register for the signals, which first
argument defines the service or interface namespace STRING.

`:path-namespace' STRING: Register for the object path namespace
STRING.  All signals sent from an object path, which has STRING as
the preceding string, are matched.  This requires PATH to be nil.

`:eavesdrop': Register for unicast signals which are not directed
to the D-Bus object Emacs is registered at D-Bus BUS, if the
security policy of BUS allows this.

Example:

\(defun my-signal-handler (device)
  (message \"Device %s added\" device))

\(dbus-register-signal
  :system \"org.freedesktop.Hal\" \"/org/freedesktop/Hal/Manager\"
  \"org.freedesktop.Hal.Manager\" \"DeviceAdded\" 'my-signal-handler)

  => \(\(:signal :system \"org.freedesktop.Hal.Manager\" \"DeviceAdded\")
      \(\"org.freedesktop.Hal\" \"/org/freedesktop/Hal/Manager\" my-signal-handler))

`dbus-register-signal' returns an object, which can be used in
`dbus-unregister-object' for removing the registration."

  (let ((counter 0)
	(rule "type='signal'")
	uname key key1 value)

    ;; Retrieve unique name of service.  If service is a known name,
    ;; we will register for the corresponding unique name, if any.
    ;; Signals are sent always with the unique name as sender.  Note:
    ;; the unique name of `dbus-service-dbus' is that string itself.
    (if (and (stringp service)
	     (not (zerop (length service)))
	     (not (string-equal service dbus-service-dbus))
	     (not (string-match "^:" service)))
	(setq uname (dbus-get-name-owner bus service))
      (setq uname service))

    (setq rule (concat rule
		       (when uname (format ",sender='%s'" uname))
		       (when interface (format ",interface='%s'" interface))
		       (when signal (format ",member='%s'" signal))
		       (when path (format ",path='%s'" path))))

    ;; Add arguments to the rule.
    (if (or (stringp (car args)) (null (car args)))
	;; As backward compatibility option, we allow just strings.
	(dolist (arg args)
	  (if (stringp arg)
	      (setq rule (concat rule (format ",arg%d='%s'" counter arg)))
	    (if arg (signal 'wrong-type-argument (list "Wrong argument" arg))))
	  (setq counter (1+ counter)))

      ;; Parse keywords.
      (while args
	(setq
	 key (car args)
	 rule (concat
	       rule
	       (cond
		;; `:arg0' .. `:arg63', `:path0' .. `:path63'.
		((and (keywordp key)
		      (string-match
		       "^:\\(arg\\|path\\)\\([[:digit:]]+\\)$"
		       (symbol-name key)))
		 (setq counter (match-string 2 (symbol-name key))
		       args (cdr args)
		       value (car args))
		 (unless (and (<= counter 63) (stringp value))
		   (signal 'wrong-type-argument
			   (list "Wrong argument" key value)))
		 (format
		  ",arg%s%s='%s'"
		  counter
		  (if (string-equal (match-string 1 (symbol-name key)) "path")
		      "path" "")
		  value))
		;; `:arg-namespace', `:path-namespace'.
		((and (keywordp key)
		      (string-match
		       "^:\\(arg\\|path\\)-namespace$" (symbol-name key)))
		 (setq args (cdr args)
		       value (car args))
		 (unless (stringp value)
		   (signal 'wrong-type-argument
			   (list "Wrong argument" key value)))
		 (format
		  ",%s='%s'"
		  (if (string-equal (match-string 1 (symbol-name key)) "path")
		      "path_namespace" "arg0namespace")
		  value))
		;; `:eavesdrop'.
		((eq key :eavesdrop)
		 ",eavesdrop='true'")
		(t (signal 'wrong-type-argument (list "Wrong argument" key)))))
	 args (cdr args))))

    ;; Add the rule to the bus.
    (condition-case err
	(dbus-call-method
	 bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus
	 "AddMatch" rule)
      (dbus-error
       (if (not (string-match "eavesdrop" rule))
	   (signal (car err) (cdr err))
	 ;; The D-Bus spec says we shall fall back to a rule without eavesdrop.
	 (when dbus-debug (message "Removing eavesdrop from rule %s" rule))
	 (setq rule (replace-regexp-in-string ",eavesdrop='true'" "" rule))
	 (dbus-call-method
	  bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus
	  "AddMatch" rule))))

    (when dbus-debug (message "Matching rule \"%s\" created" rule))

    ;; Create a hash table entry.
    (setq key (list :signal bus interface signal)
	  key1 (list uname service path handler rule)
	  value (gethash key dbus-registered-objects-table))
    (unless  (member key1 value)
      (puthash key (cons key1 value) dbus-registered-objects-table))

    ;; Return the object.
    (list key (list service path handler))))

(defun dbus-register-method
  (bus service path interface method handler &optional dont-register-service)
  "Register for method METHOD on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name of the D-Bus object METHOD is
registered for.  It must be a known name (See discussion of
DONT-REGISTER-SERVICE below).

PATH is the D-Bus object path SERVICE is registered (See discussion of
DONT-REGISTER-SERVICE below).  INTERFACE is the interface offered by
SERVICE.  It must provide METHOD.

HANDLER is a Lisp function to be called when a method call is
received.  It must accept the input arguments of METHOD.  The return
value of HANDLER is used for composing the returning D-Bus message.
In case HANDLER shall return a reply message with an empty argument
list, HANDLER must return the symbol `:ignore'.

When DONT-REGISTER-SERVICE is non-nil, the known name SERVICE is not
registered.  This means that other D-Bus clients have no way of
noticing the newly registered method.  When interfaces are constructed
incrementally by adding single methods or properties at a time,
DONT-REGISTER-SERVICE can be used to prevent other clients from
discovering the still incomplete interface."

  ;; Register SERVICE.
  (unless (or dont-register-service
	      (member service (dbus-list-names bus)))
    (dbus-register-service bus service))

  ;; Create a hash table entry.  We use nil for the unique name,
  ;; because the method might be called from anybody.
  (let* ((key (list :method bus interface method))
	 (key1 (list nil service path handler))
	 (value (gethash key dbus-registered-objects-table)))

    (unless  (member key1 value)
      (puthash key (cons key1 value) dbus-registered-objects-table))

    ;; Return the object.
    (list key (list service path handler))))

(defun dbus-unregister-object (object)
  "Unregister OBJECT from D-Bus.
OBJECT must be the result of a preceding `dbus-register-method',
`dbus-register-property' or `dbus-register-signal' call.  It
returns `t' if OBJECT has been unregistered, `nil' otherwise.

When OBJECT identifies the last method or property, which is
registered for the respective service, Emacs releases its
association to the service from D-Bus."
  ;; Check parameter.
  (unless (and (consp object) (not (null (car object))) (consp (cdr object)))
    (signal 'wrong-type-argument (list 'D-Bus object)))

  ;; Find the corresponding entry in the hash table.
  (let* ((key (car object))
	 (type (car key))
	 (bus (cadr key))
	 (value (cadr object))
	 (service (car value))
	 (entry (gethash key dbus-registered-objects-table))
	 ret)
    ;; key has the structure (TYPE BUS INTERFACE MEMBER).
    ;; value has the structure (SERVICE PATH [HANDLER]).
    ;; entry has the structure ((UNAME SERVICE PATH MEMBER [RULE]) ...).
    ;; MEMBER is either a string (the handler), or a cons cell (a
    ;; property value).  UNAME and property values are not taken into
    ;; account for comparison.

    ;; Loop over the registered functions.
    (dolist (elt entry)
      (when (equal
	     value
	     (butlast (cdr elt) (- (length (cdr elt)) (length value))))
	(setq ret t)
	;; Compute new hash value.  If it is empty, remove it from the
	;; hash table.
	(unless (puthash key (delete elt entry) dbus-registered-objects-table)
	  (remhash key dbus-registered-objects-table))
	;; Remove match rule of signals.
	(when (eq type :signal)
	  (dbus-call-method
	   bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus
	   "RemoveMatch" (nth 4 elt)))))

    ;; Check, whether there is still a registered function or property
    ;; for the given service.  If not, unregister the service from the
    ;; bus.
    (when (and service (memq type '(:method :property))
	       (not (catch :found
		      (progn
			(maphash
			 (lambda (k v)
			   (dolist (e v)
			     (ignore-errors
			       (and
				;; Bus.
				(equal bus (cadr k))
				;; Service.
				(string-equal service (cadr e))
				;; Non-empty object path.
				(cl-caddr e)
				(throw :found t)))))
			 dbus-registered-objects-table)
			nil))))
      (dbus-unregister-service bus service))
    ;; Return.
    ret))


;;; D-Bus type conversion.

(defun dbus-string-to-byte-array (string)
  "Transforms STRING to list (:array :byte c1 :byte c2 ...).
STRING shall be UTF8 coded."
  (if (zerop (length string))
      '(:array :signature "y")
    (let (result)
      (dolist (elt (string-to-list string) (append '(:array) result))
	(setq result (append result (list :byte elt)))))))

(defun dbus-byte-array-to-string (byte-array)
  "Transforms BYTE-ARRAY into UTF8 coded string.
BYTE-ARRAY must be a list of structure (c1 c2 ...)."
  (apply 'string byte-array))

(defun dbus-escape-as-identifier (string)
  "Escape an arbitrary STRING so it follows the rules for a C identifier.
The escaped string can be used as object path component, interface element
component, bus name component or member name in D-Bus.

The escaping consists of replacing all non-alphanumerics, and the
first character if it's a digit, with an underscore and two
lower-case hex digits:

   \"0123abc_xyz\\x01\\xff\" -> \"_30123abc_5fxyz_01_ff\"

i.e. similar to URI encoding, but with \"_\" taking the role of \"%\",
and a smaller allowed set. As a special case, \"\" is escaped to
\"_\".

Returns the escaped string.  Algorithm taken from
telepathy-glib's `tp-escape-as-identifier'."
  (if (zerop (length string))
      "_"
    (replace-regexp-in-string
     "^[0-9]\\|[^A-Za-z0-9]"
     (lambda (x) (format "_%2x" (aref x 0)))
     string)))

(defun dbus-unescape-from-identifier (string)
  "Retrieve the original string from the encoded STRING.
STRING must have been coded with `dbus-escape-as-identifier'"
  (if (string-equal string "_")
      ""
    (replace-regexp-in-string
     "_.."
     (lambda (x) (format "%c" (string-to-number (substring x 1) 16)))
     string)))


;;; D-Bus events.

(defun dbus-check-event (event)
  "Checks whether EVENT is a well formed D-Bus event.
EVENT is a list which starts with symbol `dbus-event':

  (dbus-event BUS TYPE SERIAL SERVICE PATH INTERFACE MEMBER HANDLER &rest ARGS)

BUS identifies the D-Bus the message is coming from.  It is
either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.  TYPE is the D-Bus message type which
has caused the event, SERIAL is the serial number of the received
D-Bus message.  SERVICE and PATH are the unique name and the
object path of the D-Bus object emitting the message.  INTERFACE
and MEMBER denote the message which has been sent.  HANDLER is
the function which has been registered for this message.  ARGS
are the arguments passed to HANDLER, when it is called during
event handling in `dbus-handle-event'.

This function raises a `dbus-error' signal in case the event is
not well formed."
  (when dbus-debug (message "DBus-Event %s" event))
  (unless (and (listp event)
	       (eq (car event) 'dbus-event)
	       ;; Bus symbol.
	       (or (symbolp (nth 1 event))
		   (stringp (nth 1 event)))
	       ;; Type.
	       (and (natnump (nth 2 event))
		    (< dbus-message-type-invalid (nth 2 event)))
	       ;; Serial.
	       (natnump (nth 3 event))
	       ;; Service.
	       (or (= dbus-message-type-method-return (nth 2 event))
		   (= dbus-message-type-error (nth 2 event))
		   (stringp (nth 4 event)))
	       ;; Object path.
	       (or (= dbus-message-type-method-return (nth 2 event))
		   (= dbus-message-type-error (nth 2 event))
		   (stringp (nth 5 event)))
	       ;; Interface.
	       (or (= dbus-message-type-method-return (nth 2 event))
		   (= dbus-message-type-error (nth 2 event))
		   (stringp (nth 6 event)))
	       ;; Member.
	       (or (= dbus-message-type-method-return (nth 2 event))
		   (= dbus-message-type-error (nth 2 event))
		   (stringp (nth 7 event)))
	       ;; Handler.
	       (functionp (nth 8 event)))
    (signal 'dbus-error (list "Not a valid D-Bus event" event))))

;;;###autoload
(defun dbus-handle-event (event)
  "Handle events from the D-Bus.
EVENT is a D-Bus event, see `dbus-check-event'.  HANDLER, being
part of the event, is called with arguments ARGS.
If the HANDLER returns a `dbus-error', it is propagated as return message."
  (interactive "e")
  (condition-case err
      (let (result)
	;; We ignore not well-formed events.
	(dbus-check-event event)
	;; Error messages must be propagated.
	(when (= dbus-message-type-error (nth 2 event))
	  (signal 'dbus-error (nthcdr 9 event)))
	;; Apply the handler.
	(setq result (apply (nth 8 event) (nthcdr 9 event)))
	;; Return a message when it is a message call.
	(when (= dbus-message-type-method-call (nth 2 event))
	  (dbus-ignore-errors
	    (if (eq result :ignore)
		(dbus-method-return-internal
		 (nth 1 event) (nth 4 event) (nth 3 event))
	      (apply 'dbus-method-return-internal
		     (nth 1 event) (nth 4 event) (nth 3 event)
		     (if (consp result) result (list result)))))))
    ;; Error handling.
    (dbus-error
     ;; Return an error message when it is a message call.
     (when (= dbus-message-type-method-call (nth 2 event))
       (dbus-ignore-errors
	 (dbus-method-error-internal
	  (nth 1 event) (nth 4 event) (nth 3 event) (cadr err))))
     ;; Propagate D-Bus error messages.
     (run-hook-with-args 'dbus-event-error-functions event err)
     (when (or dbus-debug (= dbus-message-type-error (nth 2 event)))
       (signal (car err) (cdr err))))))

(defun dbus-event-bus-name (event)
  "Return the bus name the event is coming from.
The result is either a Lisp symbol, `:system' or `:session', or a
string denoting the bus address.  EVENT is a D-Bus event, see
`dbus-check-event'.  This function raises a `dbus-error' signal
in case the event is not well formed."
  (dbus-check-event event)
  (nth 1 event))

(defun dbus-event-message-type (event)
  "Return the message type of the corresponding D-Bus message.
The result is a number.  EVENT is a D-Bus event, see
`dbus-check-event'.  This function raises a `dbus-error' signal
in case the event is not well formed."
  (dbus-check-event event)
  (nth 2 event))

(defun dbus-event-serial-number (event)
  "Return the serial number of the corresponding D-Bus message.
The result is a number.  The serial number is needed for
generating a reply message.  EVENT is a D-Bus event, see
`dbus-check-event'.  This function raises a `dbus-error' signal
in case the event is not well formed."
  (dbus-check-event event)
  (nth 3 event))

(defun dbus-event-service-name (event)
  "Return the name of the D-Bus object the event is coming from.
The result is a string.  EVENT is a D-Bus event, see `dbus-check-event'.
This function raises a `dbus-error' signal in case the event is
not well formed."
  (dbus-check-event event)
  (nth 4 event))

(defun dbus-event-path-name (event)
  "Return the object path of the D-Bus object the event is coming from.
The result is a string.  EVENT is a D-Bus event, see `dbus-check-event'.
This function raises a `dbus-error' signal in case the event is
not well formed."
  (dbus-check-event event)
  (nth 5 event))

(defun dbus-event-interface-name (event)
  "Return the interface name of the D-Bus object the event is coming from.
The result is a string.  EVENT is a D-Bus event, see `dbus-check-event'.
This function raises a `dbus-error' signal in case the event is
not well formed."
  (dbus-check-event event)
  (nth 6 event))

(defun dbus-event-member-name (event)
  "Return the member name the event is coming from.
It is either a signal name or a method name. The result is a
string.  EVENT is a D-Bus event, see `dbus-check-event'.  This
function raises a `dbus-error' signal in case the event is not
well formed."
  (dbus-check-event event)
  (nth 7 event))


;;; D-Bus registered names.

(defun dbus-list-activatable-names (&optional bus)
  "Return the D-Bus service names which can be activated as list.
If BUS is left nil, `:system' is assumed.  The result is a list
of strings, which is `nil' when there are no activatable service
names at all."
  (dbus-ignore-errors
    (dbus-call-method
     (or bus :system) dbus-service-dbus
     dbus-path-dbus dbus-interface-dbus "ListActivatableNames")))

(defun dbus-list-names (bus)
  "Return the service names registered at D-Bus BUS.
The result is a list of strings, which is `nil' when there are no
registered service names at all.  Well known names are strings
like \"org.freedesktop.DBus\".  Names starting with \":\" are
unique names for services."
  (dbus-ignore-errors
    (dbus-call-method
     bus dbus-service-dbus dbus-path-dbus dbus-interface-dbus "ListNames")))

(defun dbus-list-known-names (bus)
  "Retrieve all services which correspond to a known name in BUS.
A service has a known name if it doesn't start with \":\"."
  (let (result)
    (dolist (name (dbus-list-names bus) result)
      (unless (string-equal ":" (substring name 0 1))
	(add-to-list 'result name 'append)))))

(defun dbus-list-queued-owners (bus service)
  "Return the unique names registered at D-Bus BUS and queued for SERVICE.
The result is a list of strings, or `nil' when there are no
queued name owners service names at all."
  (dbus-ignore-errors
    (dbus-call-method
     bus dbus-service-dbus dbus-path-dbus
     dbus-interface-dbus "ListQueuedOwners" service)))

(defun dbus-get-name-owner (bus service)
  "Return the name owner of SERVICE registered at D-Bus BUS.
The result is either a string, or `nil' if there is no name owner."
  (dbus-ignore-errors
    (dbus-call-method
     bus dbus-service-dbus dbus-path-dbus
     dbus-interface-dbus "GetNameOwner" service)))

(defun dbus-ping (bus service &optional timeout)
  "Check whether SERVICE is registered for D-Bus BUS.
TIMEOUT, a nonnegative integer, specifies the maximum number of
milliseconds `dbus-ping' must return.  The default value is 25,000.

Note, that this autoloads SERVICE if it is not running yet.  If
it shall be checked whether SERVICE is already running, one shall
apply

  \(member service \(dbus-list-known-names bus))"
  ;; "Ping" raises a D-Bus error if SERVICE does not exist.
  ;; Otherwise, it returns silently with `nil'.
  (condition-case nil
      (not
       (if (natnump timeout)
	   (dbus-call-method
	    bus service dbus-path-dbus dbus-interface-peer
	    "Ping" :timeout timeout)
	 (dbus-call-method
	  bus service dbus-path-dbus dbus-interface-peer "Ping")))
    (dbus-error nil)))


;;; D-Bus introspection.

(defun dbus-introspect (bus service path)
  "Return all interfaces and sub-nodes of SERVICE,
registered at object path PATH at bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.  SERVICE must be a known service name,
and PATH must be a valid object path.  The last two parameters
are strings.  The result, the introspection data, is a string in
XML format."
  ;; We don't want to raise errors.
  (dbus-ignore-errors
    (dbus-call-method
     bus service path dbus-interface-introspectable "Introspect"
     :timeout 1000)))

(defun dbus-introspect-xml (bus service path)
  "Return the introspection data of SERVICE in D-Bus BUS at object path PATH.
The data are a parsed list.  The root object is a \"node\",
representing the object path PATH.  The root object can contain
\"interface\" and further \"node\" objects."
  ;; We don't want to raise errors.
  (xml-node-name
   (ignore-errors
     (with-temp-buffer
       (insert (dbus-introspect bus service path))
       (xml-parse-region (point-min) (point-max))))))

(defun dbus-introspect-get-attribute (object attribute)
  "Return the ATTRIBUTE value of D-Bus introspection OBJECT.
ATTRIBUTE must be a string according to the attribute names in
the D-Bus specification."
  (xml-get-attribute-or-nil object (intern attribute)))

(defun dbus-introspect-get-node-names (bus service path)
  "Return all node names of SERVICE in D-Bus BUS at object path PATH.
It returns a list of strings.  The node names stand for further
object paths of the D-Bus service."
  (let ((object (dbus-introspect-xml bus service path))
	result)
    (dolist (elt (xml-get-children object 'node) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-all-nodes (bus service path)
  "Return all node names of SERVICE in D-Bus BUS at object path PATH.
It returns a list of strings, which are further object paths of SERVICE."
  (let ((result (list path)))
    (dolist (elt
             (dbus-introspect-get-node-names bus service path)
             result)
      (setq elt (expand-file-name elt path))
      (setq result
            (append result (dbus-introspect-get-all-nodes bus service elt))))))

(defun dbus-introspect-get-interface-names (bus service path)
  "Return all interface names of SERVICE in D-Bus BUS at object path PATH.
It returns a list of strings.

There will be always the default interface
\"org.freedesktop.DBus.Introspectable\".  Another default
interface is \"org.freedesktop.DBus.Properties\".  If present,
\"interface\" objects can also have \"property\" objects as
children, beside \"method\" and \"signal\" objects."
  (let ((object (dbus-introspect-xml bus service path))
	result)
    (dolist (elt (xml-get-children object 'interface) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-interface (bus service path interface)
  "Return the INTERFACE of SERVICE in D-Bus BUS at object path PATH.
The return value is an XML object.  INTERFACE must be a string,
element of the list returned by `dbus-introspect-get-interface-names'.
The resulting \"interface\" object can contain \"method\", \"signal\",
\"property\" and \"annotation\" children."
  (let ((elt (xml-get-children
	      (dbus-introspect-xml bus service path) 'interface)))
    (while (and elt
		(not (string-equal
		      interface
		      (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-method-names (bus service path interface)
  "Return a list of strings of all method names of INTERFACE.
SERVICE is a service of D-Bus BUS at object path PATH."
  (let ((object (dbus-introspect-get-interface bus service path interface))
	result)
    (dolist (elt (xml-get-children object 'method) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-method (bus service path interface method)
  "Return method METHOD of interface INTERFACE as XML object.
It must be located at SERVICE in D-Bus BUS at object path PATH.
METHOD must be a string, element of the list returned by
`dbus-introspect-get-method-names'.  The resulting \"method\"
object can contain \"arg\" and \"annotation\" children."
  (let ((elt (xml-get-children
	      (dbus-introspect-get-interface bus service path interface)
	      'method)))
    (while (and elt
		(not (string-equal
		      method (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-signal-names (bus service path interface)
  "Return a list of strings of all signal names of INTERFACE.
SERVICE is a service of D-Bus BUS at object path PATH."
  (let ((object (dbus-introspect-get-interface bus service path interface))
	result)
    (dolist (elt (xml-get-children object 'signal) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-signal (bus service path interface signal)
  "Return signal SIGNAL of interface INTERFACE as XML object.
It must be located at SERVICE in D-Bus BUS at object path PATH.
SIGNAL must be a string, element of the list returned by
`dbus-introspect-get-signal-names'.  The resulting \"signal\"
object can contain \"arg\" and \"annotation\" children."
  (let ((elt (xml-get-children
	      (dbus-introspect-get-interface bus service path interface)
	      'signal)))
    (while (and elt
		(not (string-equal
		      signal (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-property-names (bus service path interface)
  "Return a list of strings of all property names of INTERFACE.
SERVICE is a service of D-Bus BUS at object path PATH."
  (let ((object (dbus-introspect-get-interface bus service path interface))
	result)
    (dolist (elt (xml-get-children object 'property) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-property (bus service path interface property)
  "This function returns PROPERTY of INTERFACE as XML object.
It must be located at SERVICE in D-Bus BUS at object path PATH.
PROPERTY must be a string, element of the list returned by
`dbus-introspect-get-property-names'.  The resulting PROPERTY
object can contain \"annotation\" children."
  (let ((elt (xml-get-children
	      (dbus-introspect-get-interface bus service path interface)
	      'property)))
    (while (and elt
		(not (string-equal
		      property
		      (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-annotation-names
  (bus service path interface &optional name)
  "Return all annotation names as list of strings.
If NAME is `nil', the annotations are children of INTERFACE,
otherwise NAME must be a \"method\", \"signal\", or \"property\"
object, where the annotations belong to."
  (let ((object
	 (if name
	     (or (dbus-introspect-get-method bus service path interface name)
		 (dbus-introspect-get-signal bus service path interface name)
		 (dbus-introspect-get-property bus service path interface name))
	   (dbus-introspect-get-interface bus service path interface)))
	result)
    (dolist (elt (xml-get-children object 'annotation) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-annotation
  (bus service path interface name annotation)
  "Return ANNOTATION as XML object.
If NAME is `nil', ANNOTATION is a child of INTERFACE, otherwise
NAME must be the name of a \"method\", \"signal\", or
\"property\" object, where the ANNOTATION belongs to."
  (let ((elt (xml-get-children
	      (if name
		  (or (dbus-introspect-get-method
		       bus service path interface name)
		      (dbus-introspect-get-signal
		       bus service path interface name)
		      (dbus-introspect-get-property
		       bus service path interface name))
		(dbus-introspect-get-interface bus service path interface))
	      'annotation)))
    (while (and elt
		(not (string-equal
		      annotation
		      (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-argument-names (bus service path interface name)
  "Return a list of all argument names as list of strings.
NAME must be a \"method\" or \"signal\" object.

Argument names are optional, the function can return `nil'
therefore, even if the method or signal has arguments."
  (let ((object
	 (or (dbus-introspect-get-method bus service path interface name)
	     (dbus-introspect-get-signal bus service path interface name)))
	result)
    (dolist (elt (xml-get-children object 'arg) result)
      (add-to-list
       'result (dbus-introspect-get-attribute elt "name") 'append))))

(defun dbus-introspect-get-argument (bus service path interface name arg)
  "Return argument ARG as XML object.
NAME must be a \"method\" or \"signal\" object.  ARG must be a string,
element of the list returned by `dbus-introspect-get-argument-names'."
  (let ((elt (xml-get-children
	      (or (dbus-introspect-get-method bus service path interface name)
		  (dbus-introspect-get-signal bus service path interface name))
	      'arg)))
    (while (and elt
		(not (string-equal
		      arg (dbus-introspect-get-attribute (car elt) "name"))))
      (setq elt (cdr elt)))
    (car elt)))

(defun dbus-introspect-get-signature
  (bus service path interface name &optional direction)
  "Return signature of a `method' or `signal', represented by NAME, as string.
If NAME is a `method', DIRECTION can be either \"in\" or \"out\".
If DIRECTION is `nil', \"in\" is assumed.

If NAME is a `signal', and DIRECTION is non-`nil', DIRECTION must
be \"out\"."
  ;; For methods, we use "in" as default direction.
  (let ((object (or (dbus-introspect-get-method
		     bus service path interface name)
		    (dbus-introspect-get-signal
		     bus service path interface name))))
    (when (and (string-equal
		"method" (dbus-introspect-get-attribute object "name"))
	       (not (stringp direction)))
      (setq direction "in"))
    ;; In signals, no direction is given.
    (when (string-equal "signal" (dbus-introspect-get-attribute object "name"))
      (setq direction nil))
    ;; Collect the signatures.
    (mapconcat
     (lambda (x)
       (let ((arg (dbus-introspect-get-argument
                   bus service path interface name x)))
         (if (or (not (stringp direction))
                 (string-equal
                  direction
                  (dbus-introspect-get-attribute arg "direction")))
             (dbus-introspect-get-attribute arg "type")
           "")))
     (dbus-introspect-get-argument-names bus service path interface name)
     "")))


;;; D-Bus properties.

(defun dbus-get-property (bus service path interface property)
  "Return the value of PROPERTY of INTERFACE.
It will be checked at BUS, SERVICE, PATH.  The result can be any
valid D-Bus value, or `nil' if there is no PROPERTY."
  (dbus-ignore-errors
   ;; "Get" returns a variant, so we must use the `car'.
   (car
    (dbus-call-method
     bus service path dbus-interface-properties
     "Get" :timeout 500 interface property))))

(defun dbus-set-property (bus service path interface property value)
  "Set value of PROPERTY of INTERFACE to VALUE.
It will be checked at BUS, SERVICE, PATH.  When the value has
been set successful, the result is VALUE.  Otherwise, `nil' is
returned."
  (dbus-ignore-errors
   ;; "Set" requires a variant.
   (dbus-call-method
    bus service path dbus-interface-properties
    "Set" :timeout 500 interface property (list :variant value))
   ;; Return VALUE.
   (dbus-get-property bus service path interface property)))

(defun dbus-get-all-properties (bus service path interface)
  "Return all properties of INTERFACE at BUS, SERVICE, PATH.
The result is a list of entries.  Every entry is a cons of the
name of the property, and its value.  If there are no properties,
`nil' is returned."
  (dbus-ignore-errors
    ;; "GetAll" returns "a{sv}".
    (let (result)
      (dolist (dict
	       (dbus-call-method
		bus service path dbus-interface-properties
		"GetAll" :timeout 500 interface)
	       result)
	(add-to-list 'result (cons (car dict) (cl-caadr dict)) 'append)))))

(defun dbus-register-property
  (bus service path interface property access value
   &optional emits-signal dont-register-service)
  "Register property PROPERTY on the D-Bus BUS.

BUS is either a Lisp symbol, `:system' or `:session', or a string
denoting the bus address.

SERVICE is the D-Bus service name of the D-Bus.  It must be a
known name (See discussion of DONT-REGISTER-SERVICE below).

PATH is the D-Bus object path SERVICE is registered (See
discussion of DONT-REGISTER-SERVICE below).  INTERFACE is the
name of the interface used at PATH, PROPERTY is the name of the
property of INTERFACE.  ACCESS indicates, whether the property
can be changed by other services via D-Bus.  It must be either
the symbol `:read' or `:readwrite'.  VALUE is the initial value
of the property, it can be of any valid type (see
`dbus-call-method' for details).

If PROPERTY already exists on PATH, it will be overwritten.  For
properties with access type `:read' this is the only way to
change their values.  Properties with access type `:readwrite'
can be changed by `dbus-set-property'.

The interface \"org.freedesktop.DBus.Properties\" is added to
PATH, including a default handler for the \"Get\", \"GetAll\" and
\"Set\" methods of this interface.  When EMITS-SIGNAL is non-nil,
the signal \"PropertiesChanged\" is sent when the property is
changed by `dbus-set-property'.

When DONT-REGISTER-SERVICE is non-nil, the known name SERVICE is
not registered.  This means that other D-Bus clients have no way
of noticing the newly registered property.  When interfaces are
constructed incrementally by adding single methods or properties
at a time, DONT-REGISTER-SERVICE can be used to prevent other
clients from discovering the still incomplete interface."
  (unless (member access '(:read :readwrite))
    (signal 'wrong-type-argument (list "Access type invalid" access)))

  ;; Add handlers for the three property-related methods.
  (dbus-register-method
   bus service path dbus-interface-properties "Get"
   'dbus-property-handler 'dont-register)
  (dbus-register-method
   bus service path dbus-interface-properties "GetAll"
   'dbus-property-handler 'dont-register)
  (dbus-register-method
   bus service path dbus-interface-properties "Set"
   'dbus-property-handler 'dont-register)

  ;; Register SERVICE.
  (unless (or dont-register-service (member service (dbus-list-names bus)))
    (dbus-register-service bus service))

  ;; Send the PropertiesChanged signal.
  (when emits-signal
    (dbus-send-signal
     bus service path dbus-interface-properties "PropertiesChanged"
     `((:dict-entry ,property (:variant ,value)))
     '(:array)))

  ;; Create a hash table entry.  We use nil for the unique name,
  ;; because the property might be accessed from anybody.
  (let ((key (list :property bus interface property))
	(val
	 (list
	  (list
	   nil service path
	   (cons
	    (if emits-signal (list access :emits-signal) (list access))
	    value)))))
    (puthash key val dbus-registered-objects-table)

    ;; Return the object.
    (list key (list service path))))

(defun dbus-property-handler (&rest args)
  "Default handler for the \"org.freedesktop.DBus.Properties\" interface.
It will be registered for all objects created by `dbus-register-property'."
  (let ((bus (dbus-event-bus-name last-input-event))
	(service (dbus-event-service-name last-input-event))
	(path (dbus-event-path-name last-input-event))
	(method (dbus-event-member-name last-input-event))
	(interface (car args))
	(property (cadr args)))
    (cond
     ;; "Get" returns a variant.
     ((string-equal method "Get")
      (let ((entry (gethash (list :property bus interface property)
			    dbus-registered-objects-table)))
	(when (string-equal path (nth 2 (car entry)))
	  `((:variant ,(cdar (last (car entry))))))))

     ;; "Set" expects a variant.
     ((string-equal method "Set")
      (let* ((value (caar (cddr args)))
	     (entry (gethash (list :property bus interface property)
			     dbus-registered-objects-table))
	     ;; The value of the hash table is a list; in case of
	     ;; properties it contains just one element (UNAME SERVICE
	     ;; PATH OBJECT).  OBJECT is a cons cell of a list, which
	     ;; contains a list of annotations (like :read,
	     ;; :read-write, :emits-signal), and the value of the
	     ;; property.
	     (object (car (last (car entry)))))
	(unless (consp object)
	  (signal 'dbus-error
		  (list "Property not registered at path" property path)))
	(unless (member :readwrite (car object))
	  (signal 'dbus-error
		  (list "Property not writable at path" property path)))
	(puthash (list :property bus interface property)
		 (list (append (butlast (car entry))
			       (list (cons (car object) value))))
		 dbus-registered-objects-table)
	;; Send the "PropertiesChanged" signal.
	(when (member :emits-signal (car object))
	  (dbus-send-signal
	   bus service path dbus-interface-properties "PropertiesChanged"
	   `((:dict-entry ,property (:variant ,value)))
	   '(:array)))
	;; Return empty reply.
	:ignore))

     ;; "GetAll" returns "a{sv}".
     ((string-equal method "GetAll")
      (let (result)
	(maphash
	 (lambda (key val)
	   (when (and (equal (butlast key) (list :property bus interface))
		      (string-equal path (nth 2 (car val)))
		      (not (functionp (car (last (car val))))))
	     (add-to-list
	      'result
	      (list :dict-entry
		    (car (last key))
		    (list :variant (cdar (last (car val))))))))
	 dbus-registered-objects-table)
	;; Return the result, or an empty array.
	(list :array (or result '(:signature "{sv}"))))))))


;;; D-Bus object manager.

(defun dbus-get-all-managed-objects (bus service path)
  "Return all objects at BUS, SERVICE, PATH, and the children of PATH.
The result is a list of objects.  Every object is a cons of an
existing path name, and the list of available interface objects.
An interface object is another cons, which car is the interface
name, and the cdr is the list of properties as returned by
`dbus-get-all-properties' for that path and interface.  Example:

\(dbus-get-all-managed-objects :session \"org.gnome.SettingsDaemon\" \"/\")

  => \(\(\"/org/gnome/SettingsDaemon/MediaKeys\"
       \(\"org.gnome.SettingsDaemon.MediaKeys\")
       \(\"org.freedesktop.DBus.Peer\")
       \(\"org.freedesktop.DBus.Introspectable\")
       \(\"org.freedesktop.DBus.Properties\")
       \(\"org.freedesktop.DBus.ObjectManager\"))
      \(\"/org/gnome/SettingsDaemon/Power\"
       \(\"org.gnome.SettingsDaemon.Power.Keyboard\")
       \(\"org.gnome.SettingsDaemon.Power.Screen\")
       \(\"org.gnome.SettingsDaemon.Power\"
        \(\"Icon\" . \". GThemedIcon battery-full-charged-symbolic \")
        \(\"Tooltip\" . \"Laptop battery is charged\"))
       \(\"org.freedesktop.DBus.Peer\")
       \(\"org.freedesktop.DBus.Introspectable\")
       \(\"org.freedesktop.DBus.Properties\")
       \(\"org.freedesktop.DBus.ObjectManager\"))
      ...)

If possible, \"org.freedesktop.DBus.ObjectManager.GetManagedObjects\"
is used for retrieving the information.  Otherwise, the information
is collected via \"org.freedesktop.DBus.Introspectable.Introspect\"
and \"org.freedesktop.DBus.Properties.GetAll\", which is slow."
    (let ((result
	   ;; Direct call.  Fails, if the target does not support the
	   ;; object manager interface.
	   (dbus-ignore-errors
	    (dbus-call-method
	     bus service path dbus-interface-objectmanager
	     "GetManagedObjects" :timeout 1000))))

      (if result
	  ;; Massage the returned structure.
	  (dolist (entry result result)
	    ;; "a{oa{sa{sv}}}".
	    (dolist (entry1 (cdr entry))
	      ;; "a{sa{sv}}".
	      (dolist (entry2 entry1)
		;; "a{sv}".
		(if (cadr entry2)
		    ;; "sv".
		    (dolist (entry3 (cadr entry2))
		      (setcdr entry3 (cl-caadr entry3)))
		  (setcdr entry2 nil)))))

	;; Fallback: collect the information.  Slooow!
	(dolist (object
		 (dbus-introspect-get-all-nodes bus service path)
		 result)
	  (let (result1)
	    (dolist
		(interface
		 (dbus-introspect-get-interface-names bus service object)
		 result1)
	      (add-to-list
	       'result1
	       (cons interface
		     (dbus-get-all-properties bus service object interface))))
	    (when result1
	      (add-to-list 'result (cons object result1))))))))

(defun dbus-managed-objects-handler ()
  "Default handler for the \"org.freedesktop.DBus.ObjectManager\" interface.
It will be registered for all objects created by `dbus-register-method'."
  (let* ((last-input-event last-input-event)
	 (bus (dbus-event-bus-name last-input-event))
	 (service (dbus-event-service-name last-input-event))
	 (path (dbus-event-path-name last-input-event)))
    ;; "GetManagedObjects" returns "a{oa{sa{sv}}}".
    (let (interfaces result)

      ;; Check for object path wildcard interfaces.
      (maphash
       (lambda (key val)
	 (when (and (equal (butlast key 2) (list :method bus))
		    (null (nth 2 (car-safe val))))
	   (add-to-list 'interfaces (nth 2 key))))
       dbus-registered-objects-table)

      ;; Check all registered object paths.
      (maphash
       (lambda (key val)
	 (let ((object (or (nth 2 (car-safe val)) ""))
	       (interface (nth 2 key)))
	   (when (and (equal (butlast key 2) (list :method bus))
		      (string-prefix-p path object))
	     (dolist (interface (cons (nth 2 key) interfaces))
	       (unless (assoc object result)
		 (add-to-list 'result (list object)))
	       (unless (assoc interface (cdr (assoc object result)))
		 (setcdr
		  (assoc object result)
		  (append
		   (list (cons
		    interface
		    ;; We simulate "org.freedesktop.DBus.Properties.GetAll"
		    ;; by using an appropriate D-Bus event.
		    (let ((last-input-event
			   (append
			    (butlast last-input-event 4)
			    (list object dbus-interface-properties
				  "GetAll" 'dbus-property-handler))))
		      (dbus-property-handler interface))))
		   (cdr (assoc object result)))))))))
       dbus-registered-objects-table)

      ;; Return the result, or an empty array.
      (list
       :array
       (or
	(mapcar
	 (lambda (x)
	   (list
	    :dict-entry :object-path (car x)
	    (cons :array (mapcar (lambda (y) (cons :dict-entry y)) (cdr x)))))
	 result)
	'(:signature "{oa{sa{sv}}}"))))))

 
;; Initialize `:system' and `:session' buses.  This adds their file
;; descriptors to input_wait_mask, in order to detect incoming
;; messages immediately.
(when (featurep 'dbusbind)
  (dbus-ignore-errors
    (dbus-init-bus :system))
  (dbus-ignore-errors
    (dbus-init-bus :session)))

(provide 'dbus)

;;; TODO:

;; * Implement org.freedesktop.DBus.ObjectManager.InterfacesAdded and
;;   org.freedesktop.DBus.ObjectManager.InterfacesRemoved.

;;; dbus.el ends here
