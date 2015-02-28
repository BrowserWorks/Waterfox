;;; plstore.el --- secure plist store -*- lexical-binding: t -*-
;; Copyright (C) 2011-2013 Free Software Foundation, Inc.

;; Author: Daiki Ueno <ueno@unixuser.org>
;; Keywords: PGP, GnuPG

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

;;; Commentary

;; Plist based data store providing search and partial encryption.
;;
;; Creating:
;;
;; ;; Open a new store associated with ~/.emacs.d/auth.plist.
;; (setq store (plstore-open (expand-file-name "~/.emacs.d/auth.plist")))
;; ;; Both `:host' and `:port' are public property.
;; (plstore-put store "foo" '(:host "foo.example.org" :port 80) nil)
;; ;; No encryption will be needed.
;; (plstore-save store)
;;
;; ;; `:user' is marked as secret.
;; (plstore-put store "bar" '(:host "bar.example.org") '(:user "test"))
;; ;; `:password' is marked as secret.
;; (plstore-put store "baz" '(:host "baz.example.org") '(:password "test"))
;; ;; Those secret properties are encrypted together.
;; (plstore-save store)
;;
;; ;; Kill the buffer visiting ~/.emacs.d/auth.plist.
;; (plstore-close store)
;;
;; Searching:
;;
;; (setq store (plstore-open (expand-file-name "~/.emacs.d/auth.plist")))
;;
;; ;; As the entry "foo" associated with "foo.example.org" has no
;; ;; secret properties, no need to decryption.
;; (plstore-find store '(:host ("foo.example.org")))
;;
;; ;; As the entry "bar" associated with "bar.example.org" has a
;; ;; secret property `:user', Emacs tries to decrypt the secret (and
;; ;; thus you will need to input passphrase).
;; (plstore-find store '(:host ("bar.example.org")))
;;
;; ;; While the entry "baz" associated with "baz.example.org" has also
;; ;; a secret property `:password', it is encrypted together with
;; ;; `:user' of "bar", so no need to decrypt the secret.
;; (plstore-find store '(:host ("bar.example.org")))
;;
;; (plstore-close store)
;;
;; Editing:
;;
;; This file also provides `plstore-mode', a major mode for editing
;; the PLSTORE format file.  Visit a non-existing file and put the
;; following line:
;;
;; (("foo" :host "foo.example.org" :secret-user "user"))
;;
;; where the prefixing `:secret-' means the property (without
;; `:secret-' prefix) is marked as secret.  Thus, when you save the
;; buffer, the `:secret-user' property is encrypted as `:user'.
;;
;; You can toggle the view between encrypted form and the decrypted
;; form with C-c C-c.

;;; Code:

(require 'epg)

(defgroup plstore nil
  "Searchable, partially encrypted, persistent plist store"
  :version "24.1"
  :group 'files)

(defcustom plstore-select-keys 'silent
  "Control whether or not to pop up the key selection dialog.

If t, always asks user to select recipients.
If nil, query user only when a file's default recipients are not
known (i.e. `plstore-encrypt-to' is not locally set in the buffer
visiting a plstore file).
If neither t nor nil, doesn't ask user."
  :type '(choice (const :tag "Ask always" t)
		 (const :tag "Ask when recipients are not set" nil)
		 (const :tag "Don't ask" silent))
  :group 'plstore)

(defvar plstore-encrypt-to nil
  "*Recipient(s) used for encrypting secret entries.
May either be a string or a list of strings.  If it is nil,
symmetric encryption will be used.")

(put 'plstore-encrypt-to 'safe-local-variable
     (lambda (val)
       (or (stringp val)
	   (and (listp val)
		(catch 'safe
		  (mapc (lambda (elt)
			  (unless (stringp elt)
			    (throw 'safe nil)))
			val)
		  t)))))

(put 'plstore-encrypt-to 'permanent-local t)

(defvar plstore-encoded nil)

(put 'plstore-encoded 'permanent-local t)

(defvar plstore-cache-passphrase-for-symmetric-encryption nil)
(defvar plstore-passphrase-alist nil)

(defun plstore-passphrase-callback-function (_context _key-id plstore)
  (if plstore-cache-passphrase-for-symmetric-encryption
      (let* ((file (file-truename (plstore-get-file plstore)))
	     (entry (assoc file plstore-passphrase-alist))
	     passphrase)
	(or (copy-sequence (cdr entry))
	    (progn
	      (unless entry
		(setq entry (list file)
		      plstore-passphrase-alist
		      (cons entry
			    plstore-passphrase-alist)))
	      (setq passphrase
		    (read-passwd (format "Passphrase for PLSTORE %s: "
					 (plstore--get-buffer plstore))))
	      (setcdr entry (copy-sequence passphrase))
	      passphrase)))
    (read-passwd (format "Passphrase for PLSTORE %s: "
			 (plstore--get-buffer plstore)))))

(defun plstore-progress-callback-function (_context _what _char current total
						    handback)
  (if (= current total)
      (message "%s...done" handback)
    (message "%s...%d%%" handback
	     (if (> total 0) (floor (* (/ current (float total)) 100)) 0))))

(defun plstore--get-buffer (arg)
  (aref arg 0))

(defun plstore--get-alist (arg)
  (aref arg 1))

(defun plstore--get-encrypted-data (arg)
  (aref arg 2))

(defun plstore--get-secret-alist (arg)
  (aref arg 3))

(defun plstore--get-merged-alist (arg)
  (aref arg 4))

(defun plstore--set-buffer (arg buffer)
  (aset arg 0 buffer))

(defun plstore--set-alist (arg plist)
  (aset arg 1 plist))

(defun plstore--set-encrypted-data (arg encrypted-data)
  (aset arg 2 encrypted-data))

(defun plstore--set-secret-alist (arg secret-alist)
  (aset arg 3 secret-alist))

(defun plstore--set-merged-alist (arg merged-alist)
  (aset arg 4 merged-alist))

(defun plstore-get-file (arg)
  (buffer-file-name (plstore--get-buffer arg)))

(defun plstore--make (&optional buffer alist encrypted-data secret-alist
				merged-alist)
  (vector buffer alist encrypted-data secret-alist merged-alist))

(defun plstore--init-from-buffer (plstore)
  (goto-char (point-min))
  (when (looking-at ";;; public entries")
    (forward-line)
    (plstore--set-alist plstore (read (point-marker)))
    (forward-sexp)
    (forward-char)
    (when (looking-at ";;; secret entries")
      (forward-line)
      (plstore--set-encrypted-data plstore (read (point-marker))))
    (plstore--merge-secret plstore)))

;;;###autoload
(defun plstore-open (file)
  "Create a plstore instance associated with FILE."
  (let* ((filename (file-truename file))
	 (buffer (or (find-buffer-visiting filename)
		     (generate-new-buffer (format " plstore %s" filename))))
	 (store (plstore--make buffer)))
    (with-current-buffer buffer
      (erase-buffer)
      (condition-case nil
	  (insert-file-contents-literally file)
	(error))
      (setq buffer-file-name (file-truename file))
      (set-buffer-modified-p nil)
      (plstore--init-from-buffer store)
      store)))

(defun plstore-revert (plstore)
  "Replace current data in PLSTORE with the file on disk."
  (with-current-buffer (plstore--get-buffer plstore)
    (revert-buffer t t)
    (plstore--init-from-buffer plstore)))

(defun plstore-close (plstore)
  "Destroy a plstore instance PLSTORE."
  (kill-buffer (plstore--get-buffer plstore)))

(defun plstore--merge-secret (plstore)
  (let ((alist (plstore--get-secret-alist plstore))
	modified-alist
	modified-plist
	modified-entry
	entry
	plist
	placeholder)
    (plstore--set-merged-alist
     plstore
     (copy-tree (plstore--get-alist plstore)))
    (setq modified-alist (plstore--get-merged-alist plstore))
    (while alist
      (setq entry (car alist)
	    alist (cdr alist)
	    plist (cdr entry)
	    modified-entry (assoc (car entry) modified-alist)
	    modified-plist (cdr modified-entry))
      (while plist
	(setq placeholder
	      (plist-member
	       modified-plist
	       (intern (concat ":secret-"
			       (substring (symbol-name (car plist)) 1)))))
	(if placeholder
	    (setcar placeholder (car plist)))
	(setq modified-plist
	      (plist-put modified-plist (car plist) (car (cdr plist))))
	(setq plist (nthcdr 2 plist)))
      (setcdr modified-entry modified-plist))))

(defun plstore--decrypt (plstore)
  (if (plstore--get-encrypted-data plstore)
      (let ((context (epg-make-context 'OpenPGP))
	    plain)
	(epg-context-set-passphrase-callback
	 context
	 (cons #'plstore-passphrase-callback-function
	       plstore))
	(epg-context-set-progress-callback
	 context
	 (cons #'plstore-progress-callback-function
	       (format "Decrypting %s" (plstore-get-file plstore))))
	(setq plain
	      (epg-decrypt-string context
				  (plstore--get-encrypted-data plstore)))
	(plstore--set-secret-alist plstore (car (read-from-string plain)))
	(plstore--merge-secret plstore)
	(plstore--set-encrypted-data plstore nil))))

(defun plstore--match (entry keys skip-if-secret-found)
  (let ((result t) key-name key-value prop-value secret-name)
    (while keys
      (setq key-name (car keys)
	    key-value (car (cdr keys))
	    prop-value (plist-get (cdr entry) key-name))
	(unless (member prop-value key-value)
	  (if skip-if-secret-found
	      (progn
		(setq secret-name
		      (intern (concat ":secret-"
				      (substring (symbol-name key-name) 1))))
		(if (plist-member (cdr entry) secret-name)
		    (setq result 'secret)
		  (setq result nil
			keys nil)))
	    (setq result nil
		  keys nil)))
	(setq keys (nthcdr 2 keys)))
    result))

(defun plstore-find (plstore keys)
  "Perform search on PLSTORE with KEYS.
KEYS is a plist."
  (let (entries alist entry match decrypt plist)
    ;; First, go through the merged plist alist and collect entries
    ;; matched with keys.
    (setq alist (plstore--get-merged-alist plstore))
    (while alist
      (setq entry (car alist)
	    alist (cdr alist)
	    match (plstore--match entry keys t))
      (if (eq match 'secret)
	  (setq decrypt t)
	(when match
	  (setq plist (cdr entry))
	  (while plist
	    (if (string-match "\\`:secret-" (symbol-name (car plist)))
		(setq decrypt t
		      plist nil))
	    (setq plist (nthcdr 2 plist)))
	  (setq entries (cons entry entries)))))
    ;; Second, decrypt the encrypted plist and try again.
    (when decrypt
      (setq entries nil)
      (plstore--decrypt plstore)
      (setq alist (plstore--get-merged-alist plstore))
      (while alist
	(setq entry (car alist)
	      alist (cdr alist)
	      match (plstore--match entry keys nil))
	(if match
	    (setq entries (cons entry entries)))))
    (nreverse entries)))

(defun plstore-get (plstore name)
  "Get an entry with NAME in PLSTORE."
  (let ((entry (assoc name (plstore--get-merged-alist plstore)))
	plist)
    (setq plist (cdr entry))
    (while plist
      (if (string-match "\\`:secret-" (symbol-name (car plist)))
	  (progn
	    (plstore--decrypt plstore)
	    (setq entry (assoc name (plstore--get-merged-alist plstore))
		  plist nil))
	(setq plist (nthcdr 2 plist))))
    entry))

(defun plstore-put (plstore name keys secret-keys)
  "Put an entry with NAME in PLSTORE.
KEYS is a plist containing non-secret data.
SECRET-KEYS is a plist containing secret data."
  (let (entry
	plist
	secret-plist
	symbol)
    (if secret-keys
	(plstore--decrypt plstore))
    (while secret-keys
      (setq symbol
	    (intern (concat ":secret-"
			    (substring (symbol-name (car secret-keys)) 1))))
      (setq plist (plist-put plist symbol t)
	    secret-plist (plist-put secret-plist
				    (car secret-keys) (car (cdr secret-keys)))
	    secret-keys (nthcdr 2 secret-keys)))
    (while keys
      (setq symbol
	    (intern (concat ":secret-"
			    (substring (symbol-name (car keys)) 1))))
      (setq plist (plist-put plist (car keys) (car (cdr keys)))
	    keys (nthcdr 2 keys)))
    (setq entry (assoc name (plstore--get-alist plstore)))
    (if entry
	(setcdr entry plist)
      (plstore--set-alist
       plstore
       (cons (cons name plist) (plstore--get-alist plstore))))
    (when secret-plist
      (setq entry (assoc name (plstore--get-secret-alist plstore)))
      (if entry
	  (setcdr entry secret-plist)
	(plstore--set-secret-alist
	 plstore
	 (cons (cons name secret-plist) (plstore--get-secret-alist plstore)))))
    (plstore--merge-secret plstore)))

(defun plstore-delete (plstore name)
  "Delete an entry with NAME from PLSTORE."
  (let ((entry (assoc name (plstore--get-alist plstore))))
    (if entry
	(plstore--set-alist
	 plstore
	 (delq entry (plstore--get-alist plstore))))
    (setq entry (assoc name (plstore--get-secret-alist plstore)))
    (if entry
	(plstore--set-secret-alist
	 plstore
	 (delq entry (plstore--get-secret-alist plstore))))
    (setq entry (assoc name (plstore--get-merged-alist plstore)))
    (if entry
	(plstore--set-merged-alist
	 plstore
	 (delq entry (plstore--get-merged-alist plstore))))))

(defvar pp-escape-newlines)
(defun plstore--insert-buffer (plstore)
  (insert ";;; public entries -*- mode: plstore -*- \n"
	  (pp-to-string (plstore--get-alist plstore)))
  (if (plstore--get-secret-alist plstore)
      (let ((context (epg-make-context 'OpenPGP))
	    (pp-escape-newlines nil)
	    (recipients
	     (cond
	      ((listp plstore-encrypt-to) plstore-encrypt-to)
	      ((stringp plstore-encrypt-to) (list plstore-encrypt-to))))
	    cipher)
	(epg-context-set-armor context t)
	(epg-context-set-passphrase-callback
	 context
	 (cons #'plstore-passphrase-callback-function
	       plstore))
	(setq cipher (epg-encrypt-string
		      context
		      (pp-to-string
		       (plstore--get-secret-alist plstore))
		      (if (or (eq plstore-select-keys t)
			      (and (null plstore-select-keys)
				   (not (local-variable-p 'plstore-encrypt-to
							  (current-buffer)))))
			  (epa-select-keys
			   context
			   "Select recipients for encryption.
If no one is selected, symmetric encryption will be performed.  "
			   recipients)
			(if plstore-encrypt-to
			    (epg-list-keys context recipients)))))
	(goto-char (point-max))
	(insert ";;; secret entries\n" (pp-to-string cipher)))))

(defun plstore-save (plstore)
  "Save the contents of PLSTORE associated with a FILE."
  (with-current-buffer (plstore--get-buffer plstore)
    (erase-buffer)
    (plstore--insert-buffer plstore)
    (save-buffer)))

(defun plstore--encode (plstore)
  (plstore--decrypt plstore)
  (let ((merged-alist (plstore--get-merged-alist plstore)))
    (concat "("
	    (mapconcat
	     (lambda (entry)
	       (setq entry (copy-sequence entry))
	       (let ((merged-plist (cdr (assoc (car entry) merged-alist)))
		     (plist (cdr entry)))
		 (while plist
		   (if (string-match "\\`:secret-" (symbol-name (car plist)))
		       (setcar (cdr plist)
			       (plist-get
				merged-plist
				(intern (concat ":"
						(substring (symbol-name
							    (car plist))
							   (match-end 0)))))))
		   (setq plist (nthcdr 2 plist)))
		 (prin1-to-string entry)))
	     (plstore--get-alist plstore)
	     "\n")
	    ")")))

(defun plstore--decode (string)
  (let* ((alist (car (read-from-string string)))
	 (pointer alist)
	 secret-alist
	 plist
	 entry)
    (while pointer
      (unless (stringp (car (car pointer)))
	(error "Invalid PLSTORE format %s" string))
      (setq plist (cdr (car pointer)))
      (while plist
	(when (string-match "\\`:secret-" (symbol-name (car plist)))
	  (setq entry (assoc (car (car pointer)) secret-alist))
	  (unless entry
	    (setq entry (list (car (car pointer)))
		  secret-alist (cons entry secret-alist)))
	  (setcdr entry (plist-put (cdr entry)
				   (intern (concat ":"
						(substring (symbol-name
							    (car plist))
							   (match-end 0))))
				   (car (cdr plist))))
	  (setcar (cdr plist) t))
	(setq plist (nthcdr 2 plist)))
      (setq pointer (cdr pointer)))
    (plstore--make nil alist nil secret-alist)))

(defun plstore--write-contents-functions ()
  (when plstore-encoded
    (let ((store (plstore--decode (buffer-string)))
	  (file (buffer-file-name)))
      (unwind-protect
	  (progn
	    (set-visited-file-name nil)
	    (with-temp-buffer
	      (plstore--insert-buffer store)
	      (write-region (buffer-string) nil file)))
	(set-visited-file-name file)
	(set-buffer-modified-p nil))
      t)))

(defun plstore-mode-original ()
  "Show the original form of the this buffer."
  (interactive)
  (when plstore-encoded
    (if (and (buffer-modified-p)
	     (y-or-n-p "Save buffer before reading the original form? "))
	(save-buffer))
    (erase-buffer)
    (insert-file-contents-literally (buffer-file-name))
    (set-buffer-modified-p nil)
    (setq plstore-encoded nil)))

(defun plstore-mode-decoded ()
  "Show the decoded form of the this buffer."
  (interactive)
  (unless plstore-encoded
    (if (and (buffer-modified-p)
	     (y-or-n-p "Save buffer before decoding? "))
	(save-buffer))
    (let ((store (plstore--make (current-buffer))))
      (plstore--init-from-buffer store)
      (erase-buffer)
      (insert
       (substitute-command-keys "\
;;; You are looking at the decoded form of the PLSTORE file.\n\
;;; To see the original form content, do \\[plstore-mode-toggle-display]\n\n"))
      (insert (plstore--encode store))
      (set-buffer-modified-p nil)
      (setq plstore-encoded t))))

(defun plstore-mode-toggle-display ()
  "Toggle the display mode of PLSTORE between the original and decoded forms."
  (interactive)
  (if plstore-encoded
      (plstore-mode-original)
    (plstore-mode-decoded)))

(eval-when-compile
  (defmacro plstore-called-interactively-p (kind)
    (condition-case nil
        (progn
          (eval '(called-interactively-p 'any))
          ;; Emacs >=23.2
          `(called-interactively-p ,kind))
      ;; Emacs <23.2
      (wrong-number-of-arguments '(called-interactively-p))
      ;; XEmacs
      (void-function '(interactive-p)))))

;;;###autoload
(define-derived-mode plstore-mode emacs-lisp-mode "PLSTORE"
  "Major mode for editing PLSTORE files."
  (make-local-variable 'plstore-encoded)
  (add-hook 'write-contents-functions #'plstore--write-contents-functions)
  (define-key plstore-mode-map "\C-c\C-c" #'plstore-mode-toggle-display)
  ;; to create a new file with plstore-mode, mark it as already decoded
  (if (plstore-called-interactively-p 'any)
      (setq plstore-encoded t)
    (plstore-mode-decoded)))

(provide 'plstore)

;;; plstore.el ends here
