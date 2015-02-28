;;; url-util.el --- Miscellaneous helper routines for URL library

;; Copyright (C) 1996-1999, 2001, 2004-2013 Free Software Foundation,
;; Inc.

;; Author: Bill Perry <wmperry@gnu.org>
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

(require 'url-parse)
(require 'url-vars)
(autoload 'timezone-parse-date "timezone")
(autoload 'timezone-make-date-arpa-standard "timezone")
(autoload 'mail-header-extract "mailheader")

(defvar url-parse-args-syntax-table
  (copy-syntax-table emacs-lisp-mode-syntax-table)
  "A syntax table for parsing sgml attributes.")

(modify-syntax-entry ?' "\"" url-parse-args-syntax-table)
(modify-syntax-entry ?` "\"" url-parse-args-syntax-table)
(modify-syntax-entry ?{ "(" url-parse-args-syntax-table)
(modify-syntax-entry ?} ")" url-parse-args-syntax-table)

;;;###autoload
(defcustom url-debug nil
  "What types of debug messages from the URL library to show.
Debug messages are logged to the *URL-DEBUG* buffer.

If t, all messages will be logged.
If a number, all messages will be logged, as well shown via `message'.
If a list, it is a list of the types of messages to be logged."
  :type '(choice (const :tag "none" nil)
		 (const :tag "all" t)
		 (checklist :tag "custom"
			    (const :tag "HTTP" :value http)
			    (const :tag "DAV" :value dav)
			    (const :tag "General" :value retrieval)
			    (const :tag "Filename handlers" :value handlers)
			    (symbol :tag "Other")))
  :group 'url-hairy)

;;;###autoload
(defun url-debug (tag &rest args)
  (if quit-flag
      (error "Interrupted!"))
  (if (or (eq url-debug t)
	  (numberp url-debug)
	  (and (listp url-debug) (memq tag url-debug)))
      (with-current-buffer (get-buffer-create "*URL-DEBUG*")
	(goto-char (point-max))
	(insert (symbol-name tag) " -> " (apply 'format args) "\n")
	(if (numberp url-debug)
	    (apply 'message args)))))

;;;###autoload
(defun url-parse-args (str &optional nodowncase)
  ;; Return an assoc list of attribute/value pairs from an RFC822-type string
  (let (
	name				; From name=
	value				; its value
	results				; Assoc list of results
	name-pos			; Start of XXXX= position
	val-pos				; Start of value position
	st
	nd
	)
    (save-excursion
      (save-restriction
	(set-buffer (get-buffer-create " *urlparse-temp*"))
	(set-syntax-table url-parse-args-syntax-table)
	(erase-buffer)
	(insert str)
	(setq st (point-min)
	      nd (point-max))
	(set-syntax-table url-parse-args-syntax-table)
	(narrow-to-region st nd)
	(goto-char (point-min))
	(while (not (eobp))
	  (skip-chars-forward "; \n\t")
	  (setq name-pos (point))
	  (skip-chars-forward "^ \n\t=;")
	  (if (not nodowncase)
	      (downcase-region name-pos (point)))
	  (setq name (buffer-substring name-pos (point)))
	  (skip-chars-forward " \t\n")
	  (if (/= (or (char-after (point)) 0)  ?=) ; There is no value
	      (setq value nil)
	    (skip-chars-forward " \t\n=")
	    (setq val-pos (point)
		  value
		  (cond
		   ((or (= (or (char-after val-pos) 0) ?\")
			(= (or (char-after val-pos) 0) ?'))
		    (buffer-substring (1+ val-pos)
				      (condition-case ()
					  (prog2
					      (forward-sexp 1)
					      (1- (point))
					    (skip-chars-forward "\""))
					(error
					 (skip-chars-forward "^ \t\n")
					 (point)))))
		   (t
		    (buffer-substring val-pos
				      (progn
					(skip-chars-forward "^;")
					(skip-chars-backward " \t")
					(point)))))))
	  (setq results (cons (cons name value) results))
	  (skip-chars-forward "; \n\t"))
	results))))

;;;###autoload
(defun url-insert-entities-in-string (string)
  "Convert HTML markup-start characters to entity references in STRING.
Also replaces the \" character, so that the result may be safely used as
an attribute value in a tag.  Returns a new string with the result of the
conversion.  Replaces these characters as follows:
    &  ==>  &amp;
    <  ==>  &lt;
    >  ==>  &gt;
    \"  ==>  &quot;"
  (if (string-match "[&<>\"]" string)
      (with-current-buffer (get-buffer-create " *entity*")
	(erase-buffer)
	(buffer-disable-undo (current-buffer))
	(insert string)
	(goto-char (point-min))
	(while (progn
		 (skip-chars-forward "^&<>\"")
		 (not (eobp)))
	  (insert (cdr (assq (char-after (point))
			     '((?\" . "&quot;")
			       (?& . "&amp;")
			       (?< . "&lt;")
			       (?> . "&gt;")))))
	  (delete-char 1))
	(buffer-string))
    string))

;;;###autoload
(defun url-normalize-url (url)
  "Return a 'normalized' version of URL.
Strips out default port numbers, etc."
  (let (type data retval)
    (setq data (url-generic-parse-url url)
	  type (url-type data))
    (if (member type '("www" "about" "mailto" "info"))
	(setq retval url)
      ;; FIXME all this does, and all this function seems to do in
      ;; most cases, is remove any trailing "#anchor" part of a url.
      (setf (url-target data) nil)
      (setq retval (url-recreate-url data)))
    retval))

;;;###autoload
(defun url-lazy-message (&rest args)
  "Just like `message', but is a no-op if called more than once a second.
Will not do anything if `url-show-status' is nil."
  (if (or (and url-current-object
	       (url-silent url-current-object))
	  (null url-show-status)
	  (active-minibuffer-window)
	  (= url-lazy-message-time
	     (setq url-lazy-message-time (nth 1 (current-time)))))
      nil
    (apply 'message args)))

;;;###autoload
(defun url-get-normalized-date (&optional specified-time)
 "Return a 'real' date string that most HTTP servers can understand."
 (let ((system-time-locale "C"))
  (format-time-string "%a, %d %b %Y %T GMT"
   (or specified-time (current-time)) t)))

;;;###autoload
(defun url-eat-trailing-space (x)
  "Remove spaces/tabs at the end of a string."
  (let ((y (1- (length x)))
	(skip-chars (list ?  ?\t ?\n)))
    (while (and (>= y 0) (memq (aref x y) skip-chars))
      (setq y (1- y)))
    (substring x 0 (1+ y))))

;;;###autoload
(defun url-strip-leading-spaces (x)
  "Remove spaces at the front of a string."
  (let ((y (1- (length x)))
	(z 0)
	(skip-chars (list ?  ?\t ?\n)))
    (while (and (<= z y) (memq (aref x z) skip-chars))
      (setq z (1+ z)))
    (substring x z nil)))

;;;###autoload
(defun url-pretty-length (n)
  (cond
   ((< n 1024)
    (format "%d bytes" n))
   ((< n (* 1024 1024))
    (format "%dk" (/ n 1024.0)))
   (t
    (format "%2.2fM" (/ n (* 1024 1024.0))))))

;;;###autoload
(defun url-display-percentage (fmt perc &rest args)
  (when (and url-show-status
	     (or (null url-current-object)
		 (not (url-silent url-current-object))))
    (if (null fmt)
	(if (fboundp 'clear-progress-display)
	    (clear-progress-display))
      (if (and (fboundp 'progress-display) perc)
	  (apply 'progress-display fmt perc args)
	(apply 'message fmt args)))))

;;;###autoload
(defun url-percentage (x y)
  (if (fboundp 'float)
      (round (* 100 (/ x (float y))))
    (/ (* x 100) y)))

;;;###autoload
(defalias 'url-basepath 'url-file-directory)

;;;###autoload
(defun url-file-directory (file)
  "Return the directory part of FILE, for a URL."
  (cond
   ((null file) "")
   ((string-match "\\?" file)
    (url-file-directory (substring file 0 (match-beginning 0))))
   ((string-match "\\(.*\\(/\\|%2[fF]\\)\\)" file)
    (match-string 1 file))))

;;;###autoload
(defun url-file-nondirectory (file)
  "Return the nondirectory part of FILE, for a URL."
  (cond
   ((null file) "")
   ((string-match "\\?" file)
    (url-file-nondirectory (substring file 0 (match-beginning 0))))
   ((string-match ".*\\(?:/\\|%2[fF]\\)\\(.*\\)" file)
    (match-string 1 file))
   (t file)))

;;;###autoload
(defun url-parse-query-string (query &optional downcase allow-newlines)
  (let (retval pairs cur key val)
    (setq pairs (split-string query "[;&]"))
    (while pairs
      (setq cur (car pairs)
	    pairs (cdr pairs))
      (unless (string-match "=" cur)
        (setq cur (concat cur "=")))

      (when (string-match "=" cur)
        (setq key (url-unhex-string (substring cur 0 (match-beginning 0))
                                    allow-newlines))
        (setq val (url-unhex-string (substring cur (match-end 0) nil)
                                    allow-newlines))
        (if downcase
            (setq key (downcase key)))
        (setq cur (assoc key retval))
        (if cur
            (setcdr cur (cons val (cdr cur)))
          (setq retval (cons (list key val) retval)))))
    retval))

;;;###autoload
(defun url-build-query-string (query &optional semicolons keep-empty)
  "Build a query-string.

Given a QUERY in the form:
'((key1 val1)
  (key2 val2)
  (key3 val1 val2)
  (key4)
  (key5 \"\"))

\(This is the same format as produced by `url-parse-query-string')

This will return a string
\"key1=val1&key2=val2&key3=val1&key3=val2&key4&key5\". Keys may
be strings or symbols; if they are symbols, the symbol name will
be used.

When SEMICOLONS is given, the separator will be \";\".

When KEEP-EMPTY is given, empty values will show as \"key=\"
instead of just \"key\" as in the example above."
  (mapconcat
   (lambda (key-vals)
     (let ((escaped
            (mapcar (lambda (sym)
                      (url-hexify-string (format "%s" sym))) key-vals)))
       (mapconcat (lambda (val)
                    (let ((vprint (format "%s" val))
                          (eprint (format "%s" (car escaped))))
                      (concat eprint
                              (if (or keep-empty
                                      (and val (not (zerop (length vprint)))))
                                  "="
                                "")
                              vprint)))
                  (or (cdr escaped) '("")) (if semicolons ";" "&"))))
   query (if semicolons ";" "&")))

(defun url-unhex (x)
  (if (> x ?9)
      (if (>= x ?a)
	  (+ 10 (- x ?a))
	(+ 10 (- x ?A)))
    (- x ?0)))

;; Fixme: Is this definition better, and does it ever matter?

;; (defun url-unhex-string (str &optional allow-newlines)
;;   "Remove %XX, embedded spaces, etc in a url.
;; If optional second argument ALLOW-NEWLINES is non-nil, then allow the
;; decoding of carriage returns and line feeds in the string, which is normally
;; forbidden in URL encoding."
;;   (setq str (or str ""))
;;   (setq str (replace-regexp-in-string "%[[:xdigit:]]\\{2\\}"
;; 				      (lambda (match)
;; 					(string (string-to-number
;; 						 (substring match 1) 16)))
;; 				      str t t))
;;   (if allow-newlines
;;       (replace-regexp-in-string "[\n\r]" (lambda (match)
;; 					   (format "%%%.2X" (aref match 0)))
;; 				str t t)
;;     str))

;;;###autoload
(defun url-unhex-string (str &optional allow-newlines)
  "Remove %XX embedded spaces, etc in a URL.
If optional second argument ALLOW-NEWLINES is non-nil, then allow the
decoding of carriage returns and line feeds in the string, which is normally
forbidden in URL encoding."
  (setq str (or str ""))
  (let ((tmp "")
	(case-fold-search t))
    (while (string-match "%[0-9a-f][0-9a-f]" str)
      (let* ((start (match-beginning 0))
	     (ch1 (url-unhex (elt str (+ start 1))))
	     (code (+ (* 16 ch1)
		      (url-unhex (elt str (+ start 2))))))
	(setq tmp (concat
		   tmp (substring str 0 start)
		   (cond
		    (allow-newlines
		     (byte-to-string code))
		    ((or (= code ?\n) (= code ?\r))
		     " ")
		    (t (byte-to-string code))))
	      str (substring str (match-end 0)))))
    (concat tmp str)))

(defconst url-unreserved-chars
  '(?a ?b ?c ?d ?e ?f ?g ?h ?i ?j ?k ?l ?m ?n ?o ?p ?q ?r ?s ?t ?u ?v ?w ?x ?y ?z
    ?A ?B ?C ?D ?E ?F ?G ?H ?I ?J ?K ?L ?M ?N ?O ?P ?Q ?R ?S ?T ?U ?V ?W ?X ?Y ?Z
    ?0 ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9
    ?- ?_ ?. ?~)
  "List of characters that are unreserved in the URL spec.
This is taken from RFC 3986 (section 2.3).")

(defconst url-encoding-table
  (let ((vec (make-vector 256 nil)))
    (dotimes (byte 256)
      ;; RFC 3986 (Section 2.1): For consistency, URI producers and
      ;; normalizers should use uppercase hexadecimal digits for all
      ;; percent-encodings.
      (aset vec byte (format "%%%02X" byte)))
    vec)
  "Vector translating bytes to URI-encoded %-sequences.")

(defun url--allowed-chars (char-list)
  "Return an \"allowed character\" mask (a 256-slot vector).
The Nth element is non-nil if character N is in CHAR-LIST.  The
result can be passed as the second arg to `url-hexify-string'."
  (let ((vec (make-vector 256 nil)))
    (dolist (byte char-list)
      (ignore-errors (aset vec byte t)))
    vec))

;;;###autoload
(defun url-hexify-string (string &optional allowed-chars)
  "URI-encode STRING and return the result.
If STRING is multibyte, it is first converted to a utf-8 byte
string.  Each byte corresponding to an allowed character is left
as-is, while all other bytes are converted to a three-character
string: \"%\" followed by two upper-case hex digits.

The allowed characters are specified by ALLOWED-CHARS.  If this
argument is nil, the list `url-unreserved-chars' determines the
allowed characters.  Otherwise, ALLOWED-CHARS should be a vector
whose Nth element is non-nil if character N is allowed."
  (unless allowed-chars
    (setq allowed-chars (url--allowed-chars url-unreserved-chars)))
  (mapconcat (lambda (byte)
	       (if (aref allowed-chars byte)
		   (char-to-string byte)
		 (aref url-encoding-table byte)))
	     (if (multibyte-string-p string)
		 (encode-coding-string string 'utf-8)
	       string)
	     ""))

(defconst url-host-allowed-chars
  ;; Allow % to avoid re-encoding %-encoded sequences.
  (url--allowed-chars (append '(?% ?! ?$ ?& ?' ?\( ?\) ?* ?+ ?, ?\; ?=)
			      url-unreserved-chars))
  "Allowed-character byte mask for the host segment of a URI.
These characters are specified in RFC 3986, Appendix A.")

(defconst url-path-allowed-chars
  (let ((vec (copy-sequence url-host-allowed-chars)))
    (aset vec ?/ t)
    (aset vec ?: t)
    (aset vec ?@ t)
    vec)
  "Allowed-character byte mask for the path segment of a URI.
These characters are specified in RFC 3986, Appendix A.")

(defconst url-query-allowed-chars
  (let ((vec (copy-sequence url-path-allowed-chars)))
    (aset vec ?? t)
    vec)
  "Allowed-character byte mask for the query segment of a URI.
These characters are specified in RFC 3986, Appendix A.")

;;;###autoload
(defun url-encode-url (url)
  "Return a properly URI-encoded version of URL.
This function also performs URI normalization, e.g. converting
the scheme to lowercase if it is uppercase.  Apart from
normalization, if URL is already URI-encoded, this function
should return it unchanged."
  (if (multibyte-string-p url)
      (setq url (encode-coding-string url 'utf-8)))
  (let* ((obj  (url-generic-parse-url url))
	 (user (url-user obj))
	 (pass (url-password obj))
	 (host (url-host obj))
	 (path-and-query (url-path-and-query obj))
	 (path  (car path-and-query))
	 (query (cdr path-and-query))
	 (frag (url-target obj)))
    (if user
	(setf (url-user obj) (url-hexify-string user)))
    (if pass
	(setf (url-password obj) (url-hexify-string pass)))
    ;; No special encoding for IPv6 literals.
    (and host
	 (not (string-match "\\`\\[.*\\]\\'" host))
	 (setf (url-host obj)
	       (url-hexify-string host url-host-allowed-chars)))

    (if path
	(setq path (url-hexify-string path url-path-allowed-chars)))
    (if query
	(setq query (url-hexify-string query url-query-allowed-chars)))
    (setf (url-filename obj) (if query (concat path "?" query) path))

    (if frag
	(setf (url-target obj)
	      (url-hexify-string frag url-query-allowed-chars)))
    (url-recreate-url obj)))

;;;###autoload
(defun url-file-extension (fname &optional x)
  "Return the filename extension of FNAME.
If optional argument X is t, then return the basename
of the file with the extension stripped off."
  (if (and fname
	   (setq fname (url-file-nondirectory fname))
	   (string-match "\\.[^./]+$" fname))
      (if x (substring fname 0 (match-beginning 0))
	(substring fname (match-beginning 0) nil))
    ;;
    ;; If fname has no extension, and x then return fname itself instead of
    ;; nothing. When caching it allows the correct .hdr file to be produced
    ;; for filenames without extension.
    ;;
    (if x
 	fname
      "")))

;;;###autoload
(defun url-truncate-url-for-viewing (url &optional width)
  "Return a shortened version of URL that is WIDTH characters wide or less.
WIDTH defaults to the current frame width."
  (let* ((fr-width (or width (frame-width)))
	 (str-width (length url))
	 (fname nil)
	 (modified 0)
	 (urlobj nil))
    ;; The first thing that can go are the search strings
    (if (and (>= str-width fr-width)
	     (string-match "?" url))
	(setq url (concat (substring url 0 (match-beginning 0)) "?...")
	      str-width (length url)))
    (if (< str-width fr-width)
	nil				; Hey, we are done!
      (setq urlobj (url-generic-parse-url url)
	    fname (url-filename urlobj)
	    fr-width (- fr-width 4))
      (while (and (>= str-width fr-width)
		  (string-match "/" fname))
	(setq fname (substring fname (match-end 0) nil)
	      modified (1+ modified))
	(setf (url-filename urlobj) fname)
	(setq url (url-recreate-url urlobj)
	      str-width (length url)))
      (if (> modified 1)
	  (setq fname (concat "/.../" fname))
	(setq fname (concat "/" fname)))
      (setf (url-filename urlobj) fname)
      (setq url (url-recreate-url urlobj)))
    url))

;;;###autoload
(defun url-view-url (&optional no-show)
  "View the current document's URL.
Optional argument NO-SHOW means just return the URL, don't show it in
the minibuffer.

This uses `url-current-object', set locally to the buffer."
  (interactive)
  (if (not url-current-object)
      nil
    (if no-show
	(url-recreate-url url-current-object)
      (message "%s" (url-recreate-url url-current-object)))))

(defvar url-get-url-filename-chars "-%.?@a-zA-Z0-9()_/:~=&"
  "Valid characters in a URL.")

(defun url-get-url-at-point (&optional pt)
  "Get the URL closest to point, but don't change position.
Has a preference for looking backward when not directly on a symbol."
  ;; Not at all perfect - point must be right in the name.
  (save-excursion
    (if pt (goto-char pt))
    (let (start url)
      (save-excursion
	;; first see if you're just past a filename
	(if (not (eobp))
	    (if (looking-at "[] \t\n[{}()]") ; whitespace or some parens
		(progn
		  (skip-chars-backward " \n\t\r({[]})")
		  (if (not (bobp))
		      (backward-char 1)))))
	(if (and (char-after (point))
		 (string-match (concat "[" url-get-url-filename-chars "]")
			       (char-to-string (char-after (point)))))
	    (progn
	      (skip-chars-backward url-get-url-filename-chars)
	      (setq start (point))
	      (skip-chars-forward url-get-url-filename-chars))
	  (setq start (point)))
	(setq url (buffer-substring-no-properties start (point))))
      (if (and url (string-match "^(.*)\\.?$" url))
	  (setq url (match-string 1 url)))
      (if (and url (string-match "^URL:" url))
	  (setq url (substring url 4 nil)))
      (if (and url (string-match "\\.$" url))
	  (setq url (substring url 0 -1)))
      (if (and url (string-match "^www\\." url))
	  (setq url (concat "http://" url)))
      (if (and url (not (string-match url-nonrelative-link url)))
	  (setq url nil))
      url)))

(defun url-generate-unique-filename (&optional fmt)
  "Generate a unique filename in `url-temporary-directory'."
  (declare (obsolete make-temp-file "23.1"))
  ;; This variable is obsolete, but so is this function.
  (let ((tempdir (with-no-warnings url-temporary-directory)))
    (if (not fmt)
	(let ((base (format "url-tmp.%d" (user-real-uid)))
	      (fname "")
	      (x 0))
	  (setq fname (format "%s%d" base x))
	  (while (file-exists-p
		  (expand-file-name fname tempdir))
	    (setq x (1+ x)
		  fname (concat base (int-to-string x))))
	  (expand-file-name fname tempdir))
      (let ((base (concat "url" (int-to-string (user-real-uid))))
	    (fname "")
	    (x 0))
	(setq fname (format fmt (concat base (int-to-string x))))
	(while (file-exists-p
		(expand-file-name fname tempdir))
	  (setq x (1+ x)
		fname (format fmt (concat base (int-to-string x)))))
	(expand-file-name fname tempdir)))))

(defun url-extract-mime-headers ()
  "Set `url-current-mime-headers' in current buffer."
  (save-excursion
    (goto-char (point-min))
    (unless url-current-mime-headers
      (set (make-local-variable 'url-current-mime-headers)
	   (mail-header-extract)))))

(defun url-make-private-file (file)
  "Make FILE only readable and writable by the current user.
Creates FILE and its parent directories if they do not exist."
  (let ((dir (file-name-directory file)))
    (when dir
      ;; For historical reasons.
      (make-directory dir t)))
  ;; Based on doc-view-make-safe-dir.
  (condition-case nil
      (let ((umask (default-file-modes)))
        (unwind-protect
            (progn
              (set-default-file-modes #o0600)
              (with-temp-buffer
                (write-region (point-min) (point-max)
                              file nil 'silent nil 'excl)))
          (set-default-file-modes umask)))
    (file-already-exists
     (if (file-symlink-p file)
         (error "Danger: `%s' is a symbolic link" file))
     (set-file-modes file #o0600))))

(provide 'url-util)

;;; url-util.el ends here
