;;; url-parse.el --- Uniform Resource Locator parser

;; Copyright (C) 1996-1999, 2004-2013 Free Software Foundation, Inc.

;; Keywords: comm, data, processes

;; This file is part of GNU Emacs.
;;
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

(require 'url-vars)
(require 'auth-source)
(eval-when-compile (require 'cl-lib))

(autoload 'url-scheme-get-property "url-methods")

(cl-defstruct (url
            (:constructor nil)
            (:constructor url-parse-make-urlobj
                          (&optional type user password host portspec filename
                                     target attributes fullness))
            (:copier nil))
  type user password host portspec filename target attributes fullness
  silent (use-cookies t))

(defsubst url-port (urlobj)
  "Return the port number for the URL specified by URLOBJ."
  (declare (gv-setter (lambda (port) `(setf (url-portspec ,urlobj) ,port))))
  (or (url-portspec urlobj)
      (if (url-type urlobj)
          (url-scheme-get-property (url-type urlobj) 'default-port))))


(defun url-path-and-query (urlobj)
  "Return the path and query components of URLOBJ.
These two components are stored together in the FILENAME slot of
the object.  The return value of this function is (PATH . QUERY),
where each of PATH and QUERY are strings or nil."
  (let ((name (url-filename urlobj))
	path query)
    (when name
      (if (string-match "\\?" name)
	  (setq path  (substring name 0 (match-beginning 0))
		query (substring name (match-end 0)))
	(setq path name)))
    (if (equal path "") (setq path nil))
    (if (equal query "") (setq query nil))
    (cons path query)))

(defun url-port-if-non-default (urlobj)
  "Return the port number specified by URLOBJ, if it is not the default.
If the specified port number is the default, return nil."
  (let ((port (url-portspec urlobj))
	type)
    (and port
	 (or (null (setq type (url-type urlobj)))
	     (not (equal port (url-scheme-get-property type 'default-port))))
	 port)))

;;;###autoload
(defun url-recreate-url (urlobj)
  "Recreate a URL string from the parsed URLOBJ."
  (let* ((type (url-type urlobj))
	 (user (url-user urlobj))
	 (pass (url-password urlobj))
	 (host (url-host urlobj))
	 ;; RFC 3986: "omit the port component and its : delimiter if
	 ;; port is empty or if its value would be the same as that of
	 ;; the scheme's default."
	 (port (url-port-if-non-default urlobj))
	 (file (url-filename urlobj))
	 (frag (url-target urlobj)))
    (concat (if type (concat type ":"))
	    (if (url-fullness urlobj) "//")
	    (if (or user pass)
		(concat user
			(if pass (concat ":" pass))
			"@"))
	    host
	    (if port (format ":%d" (url-port urlobj)))
	    (or file "/")
	    (if frag (concat "#" frag)))))

(defun url-recreate-url-attributes (urlobj)
  "Recreate the attributes of an URL string from the parsed URLOBJ."
  (declare (obsolete nil "24.3"))
  (when (url-attributes urlobj)
    (concat ";"
	    (mapconcat (lambda (x)
                         (if (cdr x)
                             (concat (car x) "=" (cdr x))
                           (car x)))
                       (url-attributes urlobj) ";"))))

;;;###autoload
(defun url-generic-parse-url (url)
  "Return an URL-struct of the parts of URL.
The CL-style struct contains the following fields:

TYPE     is the URI scheme (string or nil).
USER     is the user name (string or nil).
PASSWORD is the password (string [deprecated] or nil).
HOST     is the host (a registered name, IP literal in square
         brackets, or IPv4 address in dotted-decimal form).
PORTSPEC is the specified port (a number), or nil.
FILENAME is the path AND the query component of the URI.
TARGET   is the fragment identifier component (used to refer to a
         subordinate resource, e.g. a part of a webpage).
ATTRIBUTES is nil; this slot originally stored the attribute and
         value alists for IMAP URIs, but this feature was removed
         since it conflicts with RFC 3986.
FULLNESS is non-nil iff the hierarchical sequence component of
         the URL starts with two slashes, \"//\".

The parser follows RFC 3986, except that it also tries to handle
URIs that are not fully specified (e.g. lacking TYPE), and it
does not check for or perform %-encoding.

Here is an example.  The URL

  foo://bob:pass@example.com:42/a/b/c.dtb?type=animal&name=narwhal#nose

parses to

  TYPE     = \"foo\"
  USER     = \"bob\"
  PASSWORD = \"pass\"
  HOST     = \"example.com\"
  PORTSPEC = 42
  FILENAME = \"/a/b/c.dtb?type=animal&name=narwhal\"
  TARGET   = \"nose\"
  ATTRIBUTES = nil
  FULLNESS = t"
  (if (null url)
      (url-parse-make-urlobj)
    (with-temp-buffer
      ;; Don't let those temp-buffer modifications accidentally
      ;; deactivate the mark of the current-buffer.
      (let ((deactivate-mark nil))
        (set-syntax-table url-parse-syntax-table)
	(erase-buffer)
	(insert url)
	(goto-char (point-min))
        (let ((save-pos (point))
              scheme user pass host port file fragment full
              (inhibit-read-only t))

          ;; 3.1. Scheme
	  ;; This is nil for a URI that is not fully specified.
          (when (looking-at "\\([a-zA-Z][-a-zA-Z0-9+.]*\\):")
	    (goto-char (match-end 0))
            (setq save-pos (point))
	    (setq scheme (downcase (match-string 1))))

          ;; 3.2. Authority
          (when (looking-at "//")
            (setq full t)
            (forward-char 2)
            (setq save-pos (point))
            (skip-chars-forward "^/?#")
            (setq host (buffer-substring save-pos (point)))
	    ;; 3.2.1 User Information
            (if (string-match "^\\([^@]+\\)@" host)
                (setq user (match-string 1 host)
                      host (substring host (match-end 0))))
            (if (and user (string-match "\\`\\([^:]*\\):\\(.*\\)" user))
                (setq pass (match-string 2 user)
                      user (match-string 1 user)))
            (cond
	     ;; IPv6 literal address.
	     ((string-match "^\\(\\[[^]]+\\]\\)\\(?::\\([0-9]*\\)\\)?$" host)
	      (setq port (match-string 2 host)
		    host (match-string 1 host)))
	     ;; Registered name or IPv4 address.
	     ((string-match ":\\([0-9]*\\)$" host)
	      (setq port (match-string 1 host)
		    host (substring host 0 (match-beginning 0)))))
	    (cond ((equal port "")
		   (setq port nil))
		  (port
		   (setq port (string-to-number port))))
            (setq host (downcase host)))

	  ;; Now point is on the / ? or # which terminates the
	  ;; authority, or at the end of the URI, or (if there is no
	  ;; authority) at the beginning of the absolute path.

          (setq save-pos (point))
          (if (string= "data" scheme)
	      ;; For the "data" URI scheme, all the rest is the FILE.
	      (setq file (buffer-substring save-pos (point-max)))
	    ;; For hysterical raisins, our data structure returns the
	    ;; path and query components together in one slot.
	    ;; 3.3. Path
	    (skip-chars-forward "^?#")
	    ;; 3.4. Query
	    (when (looking-at "?")
	      (skip-chars-forward "^#"))
	    (setq file (buffer-substring save-pos (point)))
	    ;; 3.5 Fragment
	    (when (looking-at "#")
	      (let ((opoint (point)))
		(forward-char 1)
		(unless (eobp)
		  (setq fragment (buffer-substring (point) (point-max))))
		(delete-region opoint (point-max)))))

          (if (and host (string-match "%[0-9][0-9]" host))
              (setq host (url-unhex-string host)))
          (url-parse-make-urlobj scheme user pass host port file
				 fragment nil full))))))

(defmacro url-bit-for-url (method lookfor url)
  `(let* ((urlobj (url-generic-parse-url url))
          (bit (funcall ,method urlobj))
          (methods (list 'url-recreate-url
                         'url-host))
          auth-info)
     (while (and (not bit) (> (length methods) 0))
       (setq auth-info (auth-source-search
                        :max 1
                        :host (funcall (pop methods) urlobj)
                        :port (url-type urlobj)))
       (setq bit (plist-get (nth 0 auth-info) ,lookfor))
       (when (functionp bit)
         (setq bit (funcall bit))))
     bit))

(defun url-user-for-url (url)
  "Attempt to use .authinfo to find a user for this URL."
  (url-bit-for-url 'url-user :user url))

(defun url-password-for-url (url)
  "Attempt to use .authinfo to find a password for this URL."
  (url-bit-for-url 'url-password :secret url))

(provide 'url-parse)

;;; url-parse.el ends here
