;;; thingatpt.el --- get the `thing' at point

;; Copyright (C) 1991-1998, 2000-2014 Free Software Foundation, Inc.

;; Author: Mike Williams <mikew@gopher.dosli.govt.nz>
;; Maintainer: emacs-devel@gnu.org
;; Keywords: extensions, matching, mouse
;; Created: Thu Mar 28 13:48:23 1991

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

;; This file provides routines for getting the "thing" at the location of
;; point, whatever that "thing" happens to be.  The "thing" is defined by
;; its beginning and end positions in the buffer.
;;
;; The function bounds-of-thing-at-point finds the beginning and end
;; positions by moving first forward to the end of the "thing", and then
;; backwards to the beginning.  By default, it uses the corresponding
;; forward-"thing" operator (eg. forward-word, forward-line).
;;
;; Special cases are allowed for using properties associated with the named
;; "thing":
;;
;;   forward-op		Function to call to skip forward over a "thing" (or
;;                      with a negative argument, backward).
;;
;;   beginning-op	Function to call to skip to the beginning of a "thing".
;;   end-op		Function to call to skip to the end of a "thing".
;;
;; Reliance on existing operators means that many `things' can be accessed
;; without further code:  eg.
;;     (thing-at-point 'line)
;;     (thing-at-point 'page)

;;; Code:

(provide 'thingatpt)

;; Basic movement

;;;###autoload
(defun forward-thing (thing &optional n)
  "Move forward to the end of the Nth next THING.
THING should be a symbol specifying a type of syntactic entity.
Possibilities include `symbol', `list', `sexp', `defun',
`filename', `url', `email', `word', `sentence', `whitespace',
`line', and `page'."
  (let ((forward-op (or (get thing 'forward-op)
			(intern-soft (format "forward-%s" thing)))))
    (if (functionp forward-op)
	(funcall forward-op (or n 1))
      (error "Can't determine how to move over a %s" thing))))

;; General routines

;;;###autoload
(defun bounds-of-thing-at-point (thing)
  "Determine the start and end buffer locations for the THING at point.
THING should be a symbol specifying a type of syntactic entity.
Possibilities include `symbol', `list', `sexp', `defun',
`filename', `url', `email', `word', `sentence', `whitespace',
`line', and `page'.

See the file `thingatpt.el' for documentation on how to define a
valid THING.

Return a cons cell (START . END) giving the start and end
positions of the thing found."
  (if (get thing 'bounds-of-thing-at-point)
      (funcall (get thing 'bounds-of-thing-at-point))
    (let ((orig (point)))
      (ignore-errors
	(save-excursion
	  ;; Try moving forward, then back.
	  (funcall ;; First move to end.
	   (or (get thing 'end-op)
	       (lambda () (forward-thing thing 1))))
	  (funcall ;; Then move to beg.
	   (or (get thing 'beginning-op)
	       (lambda () (forward-thing thing -1))))
	  (let ((beg (point)))
	    (if (<= beg orig)
		;; If that brings us all the way back to ORIG,
		;; it worked.  But END may not be the real end.
		;; So find the real end that corresponds to BEG.
		;; FIXME: in which cases can `real-end' differ from `end'?
		(let ((real-end
		       (progn
			 (funcall
			  (or (get thing 'end-op)
			      (lambda () (forward-thing thing 1))))
			 (point))))
		  (when (and (<= orig real-end) (< beg real-end))
		    (cons beg real-end)))
	      (goto-char orig)
	      ;; Try a second time, moving backward first and then forward,
	      ;; so that we can find a thing that ends at ORIG.
	      (funcall ;; First, move to beg.
	       (or (get thing 'beginning-op)
		   (lambda () (forward-thing thing -1))))
	      (funcall ;; Then move to end.
	       (or (get thing 'end-op)
		   (lambda () (forward-thing thing 1))))
	      (let ((end (point))
		    (real-beg
		     (progn
		       (funcall
			(or (get thing 'beginning-op)
			    (lambda () (forward-thing thing -1))))
		       (point))))
		(if (and (<= real-beg orig) (<= orig end) (< real-beg end))
		    (cons real-beg end))))))))))

;;;###autoload
(defun thing-at-point (thing &optional no-properties)
  "Return the THING at point.
THING should be a symbol specifying a type of syntactic entity.
Possibilities include `symbol', `list', `sexp', `defun',
`filename', `url', `email', `word', `sentence', `whitespace',
`line', `number', and `page'.

When the optional argument NO-PROPERTIES is non-nil,
strip text properties from the return value.

See the file `thingatpt.el' for documentation on how to define
a symbol as a valid THING."
  (let ((text
         (if (get thing 'thing-at-point)
             (funcall (get thing 'thing-at-point))
           (let ((bounds (bounds-of-thing-at-point thing)))
             (when bounds
               (buffer-substring (car bounds) (cdr bounds)))))))
    (when (and text no-properties)
      (set-text-properties 0 (length text) nil text))
    text))

;; Go to beginning/end

(defun beginning-of-thing (thing)
  "Move point to the beginning of THING.
The bounds of THING are determined by `bounds-of-thing-at-point'."
  (let ((bounds (bounds-of-thing-at-point thing)))
    (or bounds (error "No %s here" thing))
    (goto-char (car bounds))))

(defun end-of-thing (thing)
  "Move point to the end of THING.
The bounds of THING are determined by `bounds-of-thing-at-point'."
  (let ((bounds (bounds-of-thing-at-point thing)))
    (or bounds (error "No %s here" thing))
    (goto-char (cdr bounds))))

;;  Special cases

;;  Lines

;; bolp will be false when you click on the last line in the buffer
;; and it has no final newline.

(put 'line 'beginning-op
     (lambda () (if (bolp) (forward-line -1) (beginning-of-line))))

;;  Sexps

(defun in-string-p ()
  "Return non-nil if point is in a string.
\[This is an internal function.]"
  (let ((orig (point)))
    (save-excursion
      (beginning-of-defun)
      (nth 3 (parse-partial-sexp (point) orig)))))

(defun end-of-sexp ()
  "Move point to the end of the current sexp.
\[This is an internal function.]"
  (let ((char-syntax (syntax-after (point))))
    (if (or (eq char-syntax ?\))
	    (and (eq char-syntax ?\") (in-string-p)))
	(forward-char 1)
      (forward-sexp 1))))

(put 'sexp 'end-op 'end-of-sexp)

(defun beginning-of-sexp ()
  "Move point to the beginning of the current sexp.
\[This is an internal function.]"
  (let ((char-syntax (char-syntax (char-before))))
    (if (or (eq char-syntax ?\()
	    (and (eq char-syntax ?\") (in-string-p)))
	(forward-char -1)
      (forward-sexp -1))))

(put 'sexp 'beginning-op 'beginning-of-sexp)

;;  Lists

(put 'list 'bounds-of-thing-at-point 'thing-at-point-bounds-of-list-at-point)

(defun thing-at-point-bounds-of-list-at-point ()
  "Return the bounds of the list at point.
\[Internal function used by `bounds-of-thing-at-point'.]"
  (save-excursion
    (let ((opoint (point))
	  (beg (ignore-errors
		 (up-list -1)
		 (point))))
      (ignore-errors
	(if beg
	    (progn (forward-sexp)
		   (cons beg (point)))
	  ;; Are we are at the beginning of a top-level sexp?
	  (forward-sexp)
	  (let ((end (point)))
	    (backward-sexp)
	    (if (>= opoint (point))
		(cons opoint end))))))))

;; Defuns

(put 'defun 'beginning-op 'beginning-of-defun)
(put 'defun 'end-op       'end-of-defun)
(put 'defun 'forward-op   'end-of-defun)

;;  Filenames

(defvar thing-at-point-file-name-chars "-~/[:alnum:]_.${}#%,:"
  "Characters allowable in filenames.")

(put 'filename 'end-op
     (lambda ()
       (re-search-forward (concat "\\=[" thing-at-point-file-name-chars "]*")
			  nil t)))
(put 'filename 'beginning-op
     (lambda ()
       (if (re-search-backward (concat "[^" thing-at-point-file-name-chars "]")
			       nil t)
	   (forward-char)
	 (goto-char (point-min)))))

;;  URIs

(defvar thing-at-point-beginning-of-url-regexp nil
  "Regexp matching the beginning of a well-formed URI.
If nil, construct the regexp from `thing-at-point-uri-schemes'.")

(defvar thing-at-point-url-path-regexp
  "[^]\t\n \"'<>[^`{}]*[^]\t\n \"'<>[^`{}.,;]+"
  "Regexp matching the host and filename or e-mail part of a URL.")

(defvar thing-at-point-short-url-regexp
  (concat "[-A-Za-z0-9]+\\.[-A-Za-z0-9.]+" thing-at-point-url-path-regexp)
  "Regexp matching a URI without a scheme component.")

(defvar thing-at-point-uri-schemes
  ;; Officials from http://www.iana.org/assignments/uri-schemes.html
  '("aaa://" "about:" "acap://" "apt:" "bzr://" "bzr+ssh://"
    "attachment:/" "chrome://" "cid:" "content://" "crid://" "cvs://"
    "data:" "dav:" "dict://" "doi:" "dns:" "dtn:" "feed:" "file:/"
    "finger://" "fish://" "ftp://" "geo:" "git://" "go:" "gopher://"
    "h323:" "http://" "https://" "im:" "imap://" "info:" "ipp:"
    "irc://" "irc6://" "ircs://" "iris.beep:" "jar:" "ldap://"
    "ldaps://" "mailto:" "mid:"  "mtqp://" "mupdate://" "news:"
    "nfs://" "nntp://" "opaquelocktoken:" "pop://" "pres:"
    "resource://" "rmi://" "rsync://" "rtsp://" "rtspu://" "service:"
    "sftp://" "sip:" "sips:" "smb://" "sms:" "snmp://" "soap.beep://"
    "soap.beeps://" "ssh://" "svn://" "svn+ssh://" "tag:" "tel:"
    "telnet://" "tftp://" "tip://" "tn3270://" "udp://" "urn:"
    "uuid:" "vemmi://"  "webcal://" "xri://" "xmlrpc.beep://"
    "xmlrpc.beeps://" "z39.50r://" "z39.50s://" "xmpp:"
    ;; Compatibility
    "fax:" "mms://" "mmsh://" "modem:" "prospero:" "snews:"
    "wais://")
  "List of URI schemes recognized by `thing-at-point-url-at-point'.
Each string in this list should correspond to the start of a
URI's scheme component, up to and including the trailing // if
the scheme calls for that to be present.")

(defvar thing-at-point-markedup-url-regexp "<URL:\\([^<>\n]+\\)>"
  "Regexp matching a URL marked up per RFC1738.
This kind of markup was formerly recommended as a way to indicate
URIs, but as of RFC 3986 it is no longer recommended.
Subexpression 1 should contain the delimited URL.")

(defvar thing-at-point-newsgroup-regexp
  "\\`[[:lower:]]+\\.[-+[:lower:]_0-9.]+\\'"
  "Regexp matching a newsgroup name.")

(defvar thing-at-point-newsgroup-heads
  '("alt" "comp" "gnu" "misc" "news" "sci" "soc" "talk")
  "Used by `thing-at-point-newsgroup-p' if gnus is not running.")

(defvar thing-at-point-default-mail-uri-scheme "mailto"
  "Default scheme for ill-formed URIs that look like <foo@example.com>.
If nil, do not give such URIs a scheme.")

(put 'url 'bounds-of-thing-at-point 'thing-at-point-bounds-of-url-at-point)

(defun thing-at-point-bounds-of-url-at-point (&optional lax)
  "Return a cons cell containing the start and end of the URI at point.
Try to find a URI using `thing-at-point-markedup-url-regexp'.
If that fails, try with `thing-at-point-beginning-of-url-regexp'.
If that also fails, and optional argument LAX is non-nil, return
the bounds of a possible ill-formed URI (one lacking a scheme)."
  ;; Look for the old <URL:foo> markup.  If found, use it.
  (or (thing-at-point--bounds-of-markedup-url)
      ;; Otherwise, find the bounds within which a URI may exist.  The
      ;; method is similar to `ffap-string-at-point'.  Note that URIs
      ;; may contain parentheses but may not contain spaces (RFC3986).
      (let* ((allowed-chars "--:=&?$+@-Z_[:alpha:]~#,%;*()!'")
	     (skip-before "^[0-9a-zA-Z]")
	     (skip-after  ":;.,!?")
	     (pt (point))
	     (beg (save-excursion
		    (skip-chars-backward allowed-chars)
		    (skip-chars-forward skip-before pt)
		    (point)))
	     (end (save-excursion
		    (skip-chars-forward allowed-chars)
		    (skip-chars-backward skip-after pt)
		    (point))))
	(or (thing-at-point--bounds-of-well-formed-url beg end pt)
	    (if lax (cons beg end))))))

(defun thing-at-point--bounds-of-markedup-url ()
  (when thing-at-point-markedup-url-regexp
    (let ((case-fold-search t)
	  (pt (point))
	  (beg (line-beginning-position))
	  (end (line-end-position))
	  found)
      (save-excursion
	(goto-char beg)
	(while (and (not found)
		    (<= (point) pt)
		    (< (point) end))
	  (and (re-search-forward thing-at-point-markedup-url-regexp
				  end 1)
	       (> (point) pt)
	       (setq found t))))
      (if found
	  (cons (match-beginning 1) (match-end 1))))))

(defun thing-at-point--bounds-of-well-formed-url (beg end _pt)
  (save-excursion
    (goto-char beg)
    (let (url-beg paren-end regexp)
      (save-restriction
	(narrow-to-region beg end)
	;; The scheme component must either match at BEG, or have no
	;; other alphanumerical ASCII characters before it.
	(setq regexp (concat "\\(?:\\`\\|[^a-zA-Z0-9]\\)\\("
			     (or thing-at-point-beginning-of-url-regexp
				 (regexp-opt thing-at-point-uri-schemes))
			     "\\)"))
	(and (re-search-forward regexp end t)
	     ;; URI must have non-empty contents.
	     (< (point) end)
	     (setq url-beg (match-beginning 1))))
      (when url-beg
	;; If there is an open paren before the URI, truncate to the
	;; matching close paren.
	(and (> url-beg (point-min))
	     (eq (car-safe (syntax-after (1- url-beg))) 4)
	     (save-restriction
	       (narrow-to-region (1- url-beg) (min end (point-max)))
	       (setq paren-end (ignore-errors
				 (scan-lists (1- url-beg) 1 0))))
	     (not (blink-matching-check-mismatch (1- url-beg) paren-end))
	     (setq end (1- paren-end)))
	(cons url-beg end)))))

(put 'url 'thing-at-point 'thing-at-point-url-at-point)

(defun thing-at-point-url-at-point (&optional lax bounds)
  "Return the URL around or before point.
If no URL is found, return nil.

If optional argument LAX is non-nil, look for URLs that are not
well-formed, such as foo@bar or <nobody>.

If optional arguments BOUNDS are non-nil, it should be a cons
cell of the form (START . END), containing the beginning and end
positions of the URI.  Otherwise, these positions are detected
automatically from the text around point.

If the scheme component is absent, either because a URI delimited
with <url:...> lacks one, or because an ill-formed URI was found
with LAX or BEG and END, try to add a scheme in the returned URI.
The scheme is chosen heuristically: \"mailto:\" if the address
looks like an email address, \"ftp://\" if it starts with
\"ftp\", etc."
  (unless bounds
    (setq bounds (thing-at-point-bounds-of-url-at-point lax)))
  (when (and bounds (< (car bounds) (cdr bounds)))
    (let ((str (buffer-substring-no-properties (car bounds) (cdr bounds))))
      ;; If there is no scheme component, try to add one.
      (unless (string-match "\\`[a-zA-Z][-a-zA-Z0-9+.]*:" str)
	(or
	 ;; If the URI has the form <foo@bar>, treat it according to
	 ;; `thing-at-point-default-mail-uri-scheme'.  If there are
	 ;; no angle brackets, it must be mailto.
	 (when (string-match "\\`[^:</>@]+@[-.0-9=&?$+A-Z_a-z~#,%;*]" str)
	   (let ((scheme (if (and (eq (char-before (car bounds)) ?<)
				  (eq (char-after  (cdr bounds)) ?>))
			     thing-at-point-default-mail-uri-scheme
			   "mailto")))
	     (if scheme
		 (setq str (concat scheme ":" str)))))
	 ;; If the string is like <FOO>, where FOO is an existing user
	 ;; name on the system, treat that as an email address.
	 (and (string-match "\\`[[:alnum:]]+\\'" str)
	      (eq (char-before (car bounds)) ?<)
	      (eq (char-after  (cdr bounds)) ?>)
	      (not (string-match "~" (expand-file-name (concat "~" str))))
	      (setq str (concat "mailto:" str)))
	 ;; If it looks like news.example.com, treat it as news.
	 (if (thing-at-point-newsgroup-p str)
	     (setq str (concat "news:" str)))
	 ;; If it looks like ftp.example.com. treat it as ftp.
	 (if (string-match "\\`ftp\\." str)
	     (setq str (concat "ftp://" str)))
	 ;; If it looks like www.example.com. treat it as http.
	 (if (string-match "\\`www\\." str)
	     (setq str (concat "http://" str)))
	 ;; Otherwise, it just isn't a URI.
	 (setq str nil)))
      str)))

(defun thing-at-point-newsgroup-p (string)
  "Return STRING if it looks like a newsgroup name, else nil."
  (and
   (string-match thing-at-point-newsgroup-regexp string)
   (let ((htbs '(gnus-active-hashtb gnus-newsrc-hashtb gnus-killed-hashtb))
	 (heads thing-at-point-newsgroup-heads)
	 htb ret)
     (while htbs
       (setq htb (car htbs) htbs (cdr htbs))
       (ignore-errors
	 ;; errs: htb symbol may be unbound, or not a hash-table.
	 ;; gnus-gethash is just a macro for intern-soft.
	 (and (symbol-value htb)
	      (intern-soft string (symbol-value htb))
	      (setq ret string htbs nil))
	 ;; If we made it this far, gnus is running, so ignore "heads":
	 (setq heads nil)))
     (or ret (not heads)
	 (let ((head (string-match "\\`\\([[:lower:]]+\\)\\." string)))
	   (and head (setq head (substring string 0 (match-end 1)))
		(member head heads)
		(setq ret string))))
     ret)))

(put 'url 'end-op (lambda () (end-of-thing 'url)))

(put 'url 'beginning-op (lambda () (end-of-thing 'url)))

;; The normal thingatpt mechanism doesn't work for complex regexps.
;; This should work for almost any regexp wherever we are in the
;; match.  To do a perfect job for any arbitrary regexp would mean
;; testing every position before point.  Regexp searches won't find
;; matches that straddle the start position so we search forwards once
;; and then back repeatedly and then back up a char at a time.

(defun thing-at-point-looking-at (regexp &optional distance)
  "Return non-nil if point is in or just after a match for REGEXP.
Set the match data from the earliest such match ending at or after
point."
  (save-excursion
    (let ((old-point (point))
	  (forward-bound (and distance (+ (point) distance)))
	  (backward-bound (and distance (- (point) distance)))
	  match)
      (and (looking-at regexp)
	   (>= (match-end 0) old-point)
	   (setq match (point)))
      ;; Search back repeatedly from end of next match.
      ;; This may fail if next match ends before this match does.
      (re-search-forward regexp forward-bound 'limit)
      (while (and (re-search-backward regexp backward-bound t)
		  (or (> (match-beginning 0) old-point)
		      (and (looking-at regexp)	; Extend match-end past search start
			   (>= (match-end 0) old-point)
			   (setq match (point))))))
      (if (not match) nil
	(goto-char match)
	;; Back up a char at a time in case search skipped
	;; intermediate match straddling search start pos.
	(while (and (not (bobp))
		    (progn (backward-char 1) (looking-at regexp))
		    (>= (match-end 0) old-point)
		    (setq match (point))))
	(goto-char match)
	(looking-at regexp)))))

;;   Email addresses
(defvar thing-at-point-email-regexp
  "<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?"
  "A regular expression probably matching an email address.
This does not match the real name portion, only the address, optionally
with angle brackets.")

;; Haven't set 'forward-op on 'email nor defined 'forward-email' because
;; not sure they're actually needed, and URL seems to skip them too.
;; Note that (end-of-thing 'email) and (beginning-of-thing 'email)
;; work automagically, though.

(put 'email 'bounds-of-thing-at-point
     (lambda ()
       (let ((thing (thing-at-point-looking-at
		     thing-at-point-email-regexp 500)))
         (if thing
             (let ((beginning (match-beginning 0))
                   (end (match-end 0)))
               (cons beginning end))))))

(put 'email 'thing-at-point
     (lambda ()
       (let ((boundary-pair (bounds-of-thing-at-point 'email)))
         (if boundary-pair
             (buffer-substring-no-properties
              (car boundary-pair) (cdr boundary-pair))))))

;;  Buffer

(put 'buffer 'end-op (lambda () (goto-char (point-max))))
(put 'buffer 'beginning-op (lambda () (goto-char (point-min))))

;;  Aliases

(defun word-at-point ()
  "Return the word at point.  See `thing-at-point'."
  (thing-at-point 'word))

(defun sentence-at-point ()
  "Return the sentence at point.  See `thing-at-point'."
  (thing-at-point 'sentence))

(defun read-from-whole-string (str)
  "Read a Lisp expression from STR.
Signal an error if the entire string was not used."
  (let* ((read-data (read-from-string str))
	 (more-left
	  (condition-case nil
	      ;; The call to `ignore' suppresses a compiler warning.
	      (progn (ignore (read-from-string (substring str (cdr read-data))))
		     t)
	    (end-of-file nil))))
    (if more-left
	(error "Can't read whole string")
      (car read-data))))

(defun form-at-point (&optional thing pred)
  (let ((sexp (ignore-errors
		(read-from-whole-string (thing-at-point (or thing 'sexp))))))
    (if (or (not pred) (funcall pred sexp)) sexp)))

;;;###autoload
(defun sexp-at-point ()
  "Return the sexp at point, or nil if none is found."
  (form-at-point 'sexp))
;;;###autoload
(defun symbol-at-point ()
  "Return the symbol at point, or nil if none is found."
  (let ((thing (thing-at-point 'symbol)))
    (if thing (intern thing))))
;;;###autoload
(defun number-at-point ()
  "Return the number at point, or nil if none is found."
  (form-at-point 'sexp 'numberp))
(put 'number 'thing-at-point 'number-at-point)
;;;###autoload
(defun list-at-point ()
  "Return the Lisp list at point, or nil if none is found."
  (form-at-point 'list 'listp))

;;; thingatpt.el ends here
