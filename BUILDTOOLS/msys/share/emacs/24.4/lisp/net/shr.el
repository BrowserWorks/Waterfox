;;; shr.el --- Simple HTML Renderer

;; Copyright (C) 2010-2014 Free Software Foundation, Inc.

;; Author: Lars Magne Ingebrigtsen <larsi@gnus.org>
;; Keywords: html

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

;; This package takes a HTML parse tree (as provided by
;; libxml-parse-html-region) and renders it in the current buffer.  It
;; does not do CSS, JavaScript or anything advanced: It's geared
;; towards rendering typical short snippets of HTML, like what you'd
;; find in HTML email and the like.

;;; Code:

(eval-when-compile (require 'cl))
(eval-when-compile (require 'url))      ;For url-filename's setf handler.
(require 'browse-url)

(defgroup shr nil
  "Simple HTML Renderer"
  :version "24.1"
  :group 'hypermedia)

(defcustom shr-max-image-proportion 0.9
  "How big pictures displayed are in relation to the window they're in.
A value of 0.7 means that they are allowed to take up 70% of the
width and height of the window.  If they are larger than this,
and Emacs supports it, then the images will be rescaled down to
fit these criteria."
  :version "24.1"
  :group 'shr
  :type 'float)

(defcustom shr-blocked-images nil
  "Images that have URLs matching this regexp will be blocked."
  :version "24.1"
  :group 'shr
  :type '(choice (const nil) regexp))

(defcustom shr-table-horizontal-line nil
  "Character used to draw horizontal table lines.
If nil, don't draw horizontal table lines."
  :group 'shr
  :type '(choice (const nil) character))

(defcustom shr-table-vertical-line ?\s
  "Character used to draw vertical table lines."
  :group 'shr
  :type 'character)

(defcustom shr-table-corner ?\s
  "Character used to draw table corners."
  :group 'shr
  :type 'character)

(defcustom shr-hr-line ?-
  "Character used to draw hr lines."
  :group 'shr
  :type 'character)

(defcustom shr-width fill-column
  "Frame width to use for rendering.
May either be an integer specifying a fixed width in characters,
or nil, meaning that the full width of the window should be
used."
  :type '(choice (integer :tag "Fixed width in characters")
		 (const   :tag "Use the width of the window" nil))
  :group 'shr)

(defcustom shr-bullet "* "
  "Bullet used for unordered lists.
Alternative suggestions are:
- \"  \"
- \"  \""
  :version "24.4"
  :type 'string
  :group 'shr)

(defcustom shr-external-browser 'browse-url-default-browser
  "Function used to launch an external browser."
  :version "24.4"
  :group 'shr
  :type 'function)

(defcustom shr-image-animate t
  "Non nil means that images that can be animated will be."
  :version "24.4"
  :group 'shr
  :type 'boolean)

(defvar shr-content-function nil
  "If bound, this should be a function that will return the content.
This is used for cid: URLs, and the function is called with the
cid: URL as the argument.")

(defvar shr-put-image-function 'shr-put-image
  "Function called to put image and alt string.")

(defface shr-strike-through '((t (:strike-through t)))
  "Font for <s> elements."
  :group 'shr)

(defface shr-link
  '((t (:inherit link)))
  "Font for link elements."
  :group 'shr)

;;; Internal variables.

(defvar shr-folding-mode nil)
(defvar shr-state nil)
(defvar shr-start nil)
(defvar shr-indentation 0)
(defvar shr-inhibit-images nil)
(defvar shr-list-mode nil)
(defvar shr-content-cache nil)
(defvar shr-kinsoku-shorten nil)
(defvar shr-table-depth 0)
(defvar shr-stylesheet nil)
(defvar shr-base nil)
(defvar shr-ignore-cache nil)
(defvar shr-external-rendering-functions nil)
(defvar shr-target-id nil)
(defvar shr-inhibit-decoration nil)
(defvar shr-table-separator-length 1)

(defvar shr-map
  (let ((map (make-sparse-keymap)))
    (define-key map "a" 'shr-show-alt-text)
    (define-key map "i" 'shr-browse-image)
    (define-key map "z" 'shr-zoom-image)
    (define-key map [?\t] 'shr-next-link)
    (define-key map [?\M-\t] 'shr-previous-link)
    (define-key map [follow-link] 'mouse-face)
    (define-key map [mouse-2] 'shr-browse-url)
    (define-key map "I" 'shr-insert-image)
    (define-key map "w" 'shr-copy-url)
    (define-key map "u" 'shr-copy-url)
    (define-key map "v" 'shr-browse-url)
    (define-key map "o" 'shr-save-contents)
    (define-key map "\r" 'shr-browse-url)
    map))

;; Public functions and commands.
(declare-function libxml-parse-html-region "xml.c"
		  (start end &optional base-url))

(defun shr-render-buffer (buffer)
  "Display the HTML rendering of the current buffer."
  (interactive (list (current-buffer)))
  (or (fboundp 'libxml-parse-html-region)
      (error "This function requires Emacs to be compiled with libxml2"))
  (pop-to-buffer "*html*")
  (erase-buffer)
  (shr-insert-document
   (with-current-buffer buffer
     (libxml-parse-html-region (point-min) (point-max))))
  (goto-char (point-min)))

;;;###autoload
(defun shr-render-region (begin end &optional buffer)
  "Display the HTML rendering of the region between BEGIN and END."
  (interactive "r")
  (unless (fboundp 'libxml-parse-html-region)
    (error "This function requires Emacs to be compiled with libxml2"))
  (with-current-buffer (or buffer (current-buffer))
    (let ((dom (libxml-parse-html-region begin end)))
      (delete-region begin end)
      (goto-char begin)
      (shr-insert-document dom))))

;;;###autoload
(defun shr-insert-document (dom)
  "Render the parsed document DOM into the current buffer.
DOM should be a parse tree as generated by
`libxml-parse-html-region' or similar."
  (setq shr-content-cache nil)
  (let ((start (point))
	(shr-state nil)
	(shr-start nil)
	(shr-base nil)
	(shr-width (or shr-width (1- (window-width)))))
    (shr-descend (shr-transform-dom dom))
    (shr-remove-trailing-whitespace start (point))))

(defun shr-remove-trailing-whitespace (start end)
  (let ((width (window-width)))
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (while (not (eobp))
	(end-of-line)
	(when (> (shr-previous-newline-padding-width (current-column)) width)
	  (dolist (overlay (overlays-at (point)))
	    (when (overlay-get overlay 'before-string)
	      (overlay-put overlay 'before-string nil))))
	(forward-line 1)))))

(defun shr-copy-url ()
  "Copy the URL under point to the kill ring.
If called twice, then try to fetch the URL and see whether it
redirects somewhere else."
  (interactive)
  (let ((url (get-text-property (point) 'shr-url)))
    (cond
     ((not url)
      (message "No URL under point"))
     ;; Resolve redirected URLs.
     ((equal url (car kill-ring))
      (url-retrieve
       url
       (lambda (a)
	 (when (and (consp a)
		    (eq (car a) :redirect))
	   (with-temp-buffer
	     (insert (cadr a))
	     (goto-char (point-min))
	     ;; Remove common tracking junk from the URL.
	     (when (re-search-forward ".utm_.*" nil t)
	       (replace-match "" t t))
	     (message "Copied %s" (buffer-string))
	     (copy-region-as-kill (point-min) (point-max)))))
       nil t))
     ;; Copy the URL to the kill ring.
     (t
      (with-temp-buffer
	(insert url)
	(copy-region-as-kill (point-min) (point-max))
	(message "Copied %s" url))))))

(defun shr-next-link ()
  "Skip to the next link."
  (interactive)
  (let ((skip (text-property-any (point) (point-max) 'help-echo nil)))
    (if (not (setq skip (text-property-not-all skip (point-max)
					       'help-echo nil)))
	(message "No next link")
      (goto-char skip)
      (message "%s" (get-text-property (point) 'help-echo)))))

(defun shr-previous-link ()
  "Skip to the previous link."
  (interactive)
  (let ((start (point))
	(found nil))
    ;; Skip past the current link.
    (while (and (not (bobp))
		(get-text-property (point) 'help-echo))
      (forward-char -1))
    ;; Find the previous link.
    (while (and (not (bobp))
		(not (setq found (get-text-property (point) 'help-echo))))
      (forward-char -1))
    (if (not found)
	(progn
	  (message "No previous link")
	  (goto-char start))
      ;; Put point at the start of the link.
      (while (and (not (bobp))
		  (get-text-property (point) 'help-echo))
	(forward-char -1))
      (forward-char 1)
      (message "%s" (get-text-property (point) 'help-echo)))))

(defun shr-show-alt-text ()
  "Show the ALT text of the image under point."
  (interactive)
  (let ((text (get-text-property (point) 'shr-alt)))
    (if (not text)
	(message "No image under point")
      (message "%s" text))))

(defun shr-browse-image (&optional copy-url)
  "Browse the image under point.
If COPY-URL (the prefix if called interactively) is non-nil, copy
the URL of the image to the kill buffer instead."
  (interactive "P")
  (let ((url (get-text-property (point) 'image-url)))
    (cond
     ((not url)
      (message "No image under point"))
     (copy-url
      (with-temp-buffer
	(insert url)
	(copy-region-as-kill (point-min) (point-max))
	(message "Copied %s" url)))
     (t
      (message "Browsing %s..." url)
      (browse-url url)))))

(defun shr-insert-image ()
  "Insert the image under point into the buffer."
  (interactive)
  (let ((url (get-text-property (point) 'image-url)))
    (if (not url)
	(message "No image under point")
      (message "Inserting %s..." url)
      (url-retrieve url 'shr-image-fetched
		    (list (current-buffer) (1- (point)) (point-marker))
		    t t))))

(defun shr-zoom-image ()
  "Toggle the image size.
The size will be rotated between the default size, the original
size, and full-buffer size."
  (interactive)
  (let ((url (get-text-property (point) 'image-url))
	(size (get-text-property (point) 'image-size))
	(buffer-read-only nil))
    (if (not url)
	(message "No image under point")
      ;; Delete the old picture.
      (while (get-text-property (point) 'image-url)
	(forward-char -1))
      (forward-char 1)
      (let ((start (point)))
	(while (get-text-property (point) 'image-url)
	  (forward-char 1))
	(forward-char -1)
	(put-text-property start (point) 'display nil)
	(when (> (- (point) start) 2)
	  (delete-region start (1- (point)))))
      (message "Inserting %s..." url)
      (url-retrieve url 'shr-image-fetched
		    (list (current-buffer) (1- (point)) (point-marker)
			  (list (cons 'size
				      (cond ((or (eq size 'default)
						 (null size))
					     'original)
					    ((eq size 'original)
					     'full)
					    ((eq size 'full)
					     'default)))))
		    t))))

;;; Utility functions.

(defun shr-transform-dom (dom)
  (let ((result (list (pop dom))))
    (dolist (arg (pop dom))
      (push (cons (intern (concat ":" (symbol-name (car arg))) obarray)
		  (cdr arg))
	    result))
    (dolist (sub dom)
      (if (stringp sub)
	  (push (cons 'text sub) result)
	(push (shr-transform-dom sub) result)))
    (nreverse result)))

(defsubst shr-generic (cont)
  (dolist (sub cont)
    (cond
     ((eq (car sub) 'text)
      (shr-insert (cdr sub)))
     ((listp (cdr sub))
      (shr-descend sub)))))

(defun shr-descend (dom)
  (let ((function
	 (or
	  ;; Allow other packages to override (or provide) rendering
	  ;; of elements.
	  (cdr (assq (car dom) shr-external-rendering-functions))
	  (intern (concat "shr-tag-" (symbol-name (car dom))) obarray)))
	(style (cdr (assq :style (cdr dom))))
	(shr-stylesheet shr-stylesheet)
	(start (point)))
    (when style
      (if (string-match "color\\|display\\|border-collapse" style)
	  (setq shr-stylesheet (nconc (shr-parse-style style)
				      shr-stylesheet))
	(setq style nil)))
    ;; If we have a display:none, then just ignore this part of the DOM.
    (unless (equal (cdr (assq 'display shr-stylesheet)) "none")
      (if (fboundp function)
	  (funcall function (cdr dom))
	(shr-generic (cdr dom)))
      (when (and shr-target-id
		 (equal (cdr (assq :id (cdr dom))) shr-target-id))
	;; If the element was empty, we don't have anything to put the
	;; anchor on.  So just insert a dummy character.
	(when (= start (point))
	  (insert "*"))
	(put-text-property start (1+ start) 'shr-target-id shr-target-id))
      ;; If style is set, then this node has set the color.
      (when style
	(shr-colorize-region start (point)
			     (cdr (assq 'color shr-stylesheet))
			     (cdr (assq 'background-color shr-stylesheet)))))))

(defmacro shr-char-breakable-p (char)
  "Return non-nil if a line can be broken before and after CHAR."
  `(aref fill-find-break-point-function-table ,char))
(defmacro shr-char-nospace-p (char)
  "Return non-nil if no space is required before and after CHAR."
  `(aref fill-nospace-between-words-table ,char))

;; KINSOKU is a Japanese word meaning a rule that should not be violated.
;; In Emacs, it is a term used for characters, e.g. punctuation marks,
;; parentheses, and so on, that should not be placed in the beginning
;; of a line or the end of a line.
(defmacro shr-char-kinsoku-bol-p (char)
  "Return non-nil if a line ought not to begin with CHAR."
  `(let ((char ,char))
     (and (not (eq char ?'))
	  (aref (char-category-set char) ?>))))
(defmacro shr-char-kinsoku-eol-p (char)
  "Return non-nil if a line ought not to end with CHAR."
  `(aref (char-category-set ,char) ?<))
(unless (shr-char-kinsoku-bol-p (make-char 'japanese-jisx0208 33 35))
  (load "kinsoku" nil t))

(defun shr-insert (text)
  (when (and (eq shr-state 'image)
	     (not (bolp))
	     (not (string-match "\\`[ \t\n]+\\'" text)))
    (insert "\n")
    (setq shr-state nil))
  (cond
   ((eq shr-folding-mode 'none)
    (insert text))
   (t
    (when (and (string-match "\\`[ \t\n ]" text)
	       (not (bolp))
	       (not (eq (char-after (1- (point))) ? )))
      (insert " "))
    (dolist (elem (split-string text "[ \f\t\n\r\v ]+" t))
      (when (and (bolp)
		 (> shr-indentation 0))
	(shr-indent))
      ;; No space is needed behind a wide character categorized as
      ;; kinsoku-bol, between characters both categorized as nospace,
      ;; or at the beginning of a line.
      (let (prev)
	(when (and (> (current-column) shr-indentation)
		   (eq (preceding-char) ? )
		   (or (= (line-beginning-position) (1- (point)))
		       (and (shr-char-breakable-p
			     (setq prev (char-after (- (point) 2))))
			    (shr-char-kinsoku-bol-p prev))
		       (and (shr-char-nospace-p prev)
			    (shr-char-nospace-p (aref elem 0)))))
	  (delete-char -1)))
      ;; The shr-start is a special variable that is used to pass
      ;; upwards the first point in the buffer where the text really
      ;; starts.
      (unless shr-start
	(setq shr-start (point)))
      (insert elem)
      (setq shr-state nil)
      (let (found)
	(while (and (> (current-column) shr-width)
		    (> shr-width 0)
		    (progn
		      (setq found (shr-find-fill-point))
		      (not (eolp))))
	  (when (eq (preceding-char) ? )
	    (delete-char -1))
	  (insert "\n")
	  (unless found
	    ;; No space is needed at the beginning of a line.
	    (when (eq (following-char) ? )
	      (delete-char 1)))
	  (when (> shr-indentation 0)
	    (shr-indent))
	  (end-of-line))
	(if (<= (current-column) shr-width)
	    (insert " ")
	  ;; In case we couldn't get a valid break point (because of a
	  ;; word that's longer than `shr-width'), just break anyway.
	  (insert "\n")
	  (when (> shr-indentation 0)
	    (shr-indent)))))
    (unless (string-match "[ \t\r\n ]\\'" text)
      (delete-char -1)))))

(defun shr-find-fill-point ()
  (when (> (move-to-column shr-width) shr-width)
    (backward-char 1))
  (let ((bp (point))
	failed)
    (while (not (or (setq failed (<= (current-column) shr-indentation))
		    (eq (preceding-char) ? )
		    (eq (following-char) ? )
		    (shr-char-breakable-p (preceding-char))
		    (shr-char-breakable-p (following-char))
		    (and (shr-char-kinsoku-bol-p (preceding-char))
			 (shr-char-breakable-p (following-char))
			 (not (shr-char-kinsoku-bol-p (following-char))))
		    (shr-char-kinsoku-eol-p (following-char))
		    (bolp)))
      (backward-char 1))
    (if failed
	;; There's no breakable point, so we give it up.
	(let (found)
	  (goto-char bp)
	  (unless shr-kinsoku-shorten
	    (while (setq found (re-search-forward
				"\\(\\c>\\)\\| \\|\\c<\\|\\c|"
				(line-end-position) 'move)))
	    (if (and found
		     (not (match-beginning 1)))
		(goto-char (match-beginning 0)))))
      (or
       (eolp)
       ;; Don't put kinsoku-bol characters at the beginning of a line,
       ;; or kinsoku-eol characters at the end of a line.
       (cond
	(shr-kinsoku-shorten
	 (while (and (not (memq (preceding-char) (list ?\C-@ ?\n ? )))
		     (shr-char-kinsoku-eol-p (preceding-char)))
	   (backward-char 1))
	 (when (setq failed (<= (current-column) shr-indentation))
	   ;; There's no breakable point that doesn't violate kinsoku,
	   ;; so we look for the second best position.
	   (while (and (progn
			 (forward-char 1)
			 (<= (current-column) shr-width))
		       (progn
			 (setq bp (point))
			 (shr-char-kinsoku-eol-p (following-char)))))
	   (goto-char bp)))
	((shr-char-kinsoku-eol-p (preceding-char))
	 ;; Find backward the point where kinsoku-eol characters begin.
	 (let ((count 4))
	   (while
	       (progn
		 (backward-char 1)
		 (and (> (setq count (1- count)) 0)
		      (not (memq (preceding-char) (list ?\C-@ ?\n ? )))
		      (or (shr-char-kinsoku-eol-p (preceding-char))
			  (shr-char-kinsoku-bol-p (following-char)))))))
	 (when (setq failed (<= (current-column) shr-indentation))
	   ;; There's no breakable point that doesn't violate kinsoku,
	   ;; so we go to the second best position.
	   (if (looking-at "\\(\\c<+\\)\\c<")
	       (goto-char (match-end 1))
	     (forward-char 1))))
	((shr-char-kinsoku-bol-p (following-char))
	 ;; Find forward the point where kinsoku-bol characters end.
	 (let ((count 4))
	   (while (progn
		    (forward-char 1)
		    (and (>= (setq count (1- count)) 0)
			 (shr-char-kinsoku-bol-p (following-char))
			 (shr-char-breakable-p (following-char))))))))
       (when (eq (following-char) ? )
	 (forward-char 1))))
    (not failed)))

(defun shr-parse-base (url)
  ;; Always chop off anchors.
  (when (string-match "#.*" url)
    (setq url (substring url 0 (match-beginning 0))))
  (let* ((parsed (url-generic-parse-url url))
	 (local (url-filename parsed)))
    (setf (url-filename parsed) "")
    ;; Chop off the bit after the last slash.
    (when (string-match "\\`\\(.*/\\)[^/]+\\'" local)
      (setq local (match-string 1 local)))
    ;; Always make the local bit end with a slash.
    (when (and (not (zerop (length local)))
	       (not (eq (aref local (1- (length local))) ?/)))
      (setq local (concat local "/")))
    (list (url-recreate-url parsed)
	  local
	  (url-type parsed)
	  url)))

(autoload 'url-expand-file-name "url-expand")

;; FIXME This needs some tests writing.
;; Does it even need to exist, given that url-expand-file-name does?
(defun shr-expand-url (url &optional base)
  (setq base
	(if base
	    (shr-parse-base base)
	  ;; Bound by the parser.
	  shr-base))
  (when (zerop (length url))
    (setq url nil))
  (cond ((or (not url)
	     (not base)
	     (string-match "\\`[a-z]*:" url))
	 ;; Absolute URL.
	 (or url (car base)))
	((eq (aref url 0) ?/)
	 (if (and (> (length url) 1)
		  (eq (aref url 1) ?/))
	     ;; //host...; just use the protocol
	     (concat (nth 2 base) ":" url)
	   ;; Just use the host name part.
	   (concat (car base) url)))
	((eq (aref url 0) ?#)
	 ;; A link to an anchor.
	 (concat (nth 3 base) url))
	(t
	 ;; Totally relative.
	 (url-expand-file-name url (concat (car base) (cadr base))))))

(defun shr-ensure-newline ()
  (unless (zerop (current-column))
    (insert "\n")))

(defun shr-ensure-paragraph ()
  (unless (bobp)
    (if (<= (current-column) shr-indentation)
	(unless (save-excursion
		  (forward-line -1)
		  (looking-at " *$"))
	  (insert "\n"))
      (if (save-excursion
	    (beginning-of-line)
	    ;; If the current line is totally blank, and doesn't even
	    ;; have any face properties set, then delete the blank
	    ;; space.
	    (and (looking-at " *$")
		 (not (get-text-property (point) 'face))
		 (not (= (next-single-property-change (point) 'face nil
						      (line-end-position))
			 (line-end-position)))))
	  (delete-region (match-beginning 0) (match-end 0))
	(insert "\n\n")))))

(defun shr-indent ()
  (when (> shr-indentation 0)
    (insert (make-string shr-indentation ? ))))

(defun shr-fontize-cont (cont &rest types)
  (let (shr-start)
    (shr-generic cont)
    (dolist (type types)
      (shr-add-font (or shr-start (point)) (point) type))))

;; Add face to the region, but avoid putting the font properties on
;; blank text at the start of the line, and the newline at the end, to
;; avoid ugliness.
(defun shr-add-font (start end type)
  (unless shr-inhibit-decoration
    (save-excursion
      (goto-char start)
      (while (< (point) end)
	(when (bolp)
	  (skip-chars-forward " "))
	(add-face-text-property (point) (min (line-end-position) end) type t)
	(if (< (line-end-position) end)
	    (forward-line 1)
	  (goto-char end))))))

(defun shr-mouse-browse-url (ev)
  "Browse the URL under the mouse cursor."
  (interactive "e")
  (mouse-set-point ev)
  (shr-browse-url))

(defun shr-browse-url (&optional external mouse-event)
  "Browse the URL under point.
If EXTERNAL, browse the URL using `shr-external-browser'."
  (interactive (list current-prefix-arg last-nonmenu-event))
  (mouse-set-point mouse-event)
  (let ((url (get-text-property (point) 'shr-url)))
    (cond
     ((not url)
      (message "No link under point"))
     ((string-match "^mailto:" url)
      (browse-url-mail url))
     (t
      (if external
	  (funcall shr-external-browser url)
	(browse-url url))))))

(defun shr-save-contents (directory)
  "Save the contents from URL in a file."
  (interactive "DSave contents of URL to directory: ")
  (let ((url (get-text-property (point) 'shr-url)))
    (if (not url)
	(message "No link under point")
      (url-retrieve (shr-encode-url url)
		    'shr-store-contents (list url directory)
		    nil t))))

(defun shr-store-contents (status url directory)
  (unless (plist-get status :error)
    (when (or (search-forward "\n\n" nil t)
	      (search-forward "\r\n\r\n" nil t))
      (write-region (point) (point-max)
		    (expand-file-name (file-name-nondirectory url)
				      directory)))))

(defun shr-image-fetched (status buffer start end &optional flags)
  (let ((image-buffer (current-buffer)))
    (when (and (buffer-name buffer)
	       (not (plist-get status :error)))
      (url-store-in-cache image-buffer)
      (when (or (search-forward "\n\n" nil t)
		(search-forward "\r\n\r\n" nil t))
	(let ((data (shr-parse-image-data)))
	  (with-current-buffer buffer
	    (save-excursion
	      (let ((alt (buffer-substring start end))
		    (properties (text-properties-at start))
		    (inhibit-read-only t))
		(delete-region start end)
		(goto-char start)
		(funcall shr-put-image-function data alt flags)
		(while properties
		  (let ((type (pop properties))
			(value (pop properties)))
		    (unless (memq type '(display image-size))
		      (put-text-property start (point) type value))))))))))
    (kill-buffer image-buffer)))

(defun shr-image-from-data (data)
  "Return an image from the data: URI content DATA."
  (when (string-match
	 "\\(\\([^/;,]+\\(/[^;,]+\\)?\\)\\(;[^;,]+\\)*\\)?,\\(.*\\)"
	 data)
    (let ((param (match-string 4 data))
	  (payload (url-unhex-string (match-string 5 data))))
      (when (string-match "^.*\\(;[ \t]*base64\\)$" param)
	(setq payload (base64-decode-string payload)))
      payload)))

;; Behind display-graphic-p test.
(declare-function image-size "image.c" (spec &optional pixels frame))
(declare-function image-animate "image" (image &optional index limit))

(defun shr-put-image (spec alt &optional flags)
  "Insert image SPEC with a string ALT.  Return image.
SPEC is either an image data blob, or a list where the first
element is the data blob and the second element is the content-type."
  (if (display-graphic-p)
      (let* ((size (cdr (assq 'size flags)))
	     (data (if (consp spec)
		       (car spec)
		     spec))
	     (content-type (and (consp spec)
				(cadr spec)))
	     (start (point))
	     (image (cond
		     ((eq size 'original)
		      (create-image data nil t :ascent 100
				    :format content-type))
		     ((eq size 'full)
		      (ignore-errors
			(shr-rescale-image data content-type)))
		     (t
		      (ignore-errors
			(shr-rescale-image data content-type))))))
        (when image
	  ;; When inserting big-ish pictures, put them at the
	  ;; beginning of the line.
	  (when (and (> (current-column) 0)
		     (> (car (image-size image t)) 400))
	    (insert "\n"))
	  (if (eq size 'original)
	      (insert-sliced-image image (or alt "*") nil 20 1)
	    (insert-image image (or alt "*")))
	  (put-text-property start (point) 'image-size size)
	  (when (and shr-image-animate
                     (cond ((fboundp 'image-multi-frame-p)
		       ;; Only animate multi-frame things that specify a
		       ;; delay; eg animated gifs as opposed to
		       ;; multi-page tiffs.  FIXME?
                            (cdr (image-multi-frame-p image)))
                           ((fboundp 'image-animated-p)
                            (image-animated-p image))))
            (image-animate image nil 60)))
	image)
    (insert alt)))

(defun shr-rescale-image (data &optional content-type)
  "Rescale DATA, if too big, to fit the current buffer."
  (if (not (and (fboundp 'imagemagick-types)
                (get-buffer-window (current-buffer))))
      (create-image data nil t :ascent 100)
    (let ((edges (window-inside-pixel-edges
		  (get-buffer-window (current-buffer)))))
      (create-image
       data 'imagemagick t
       :ascent 100
       :max-width (truncate (* shr-max-image-proportion
			       (- (nth 2 edges) (nth 0 edges))))
       :max-height (truncate (* shr-max-image-proportion
				(- (nth 3 edges) (nth 1 edges))))
       :format content-type))))

;; url-cache-extract autoloads url-cache.
(declare-function url-cache-create-filename "url-cache" (url))
(autoload 'mm-disable-multibyte "mm-util")
(autoload 'browse-url-mail "browse-url")

(defun shr-get-image-data (url)
  "Get image data for URL.
Return a string with image data."
  (with-temp-buffer
    (mm-disable-multibyte)
    (when (ignore-errors
	    (url-cache-extract (url-cache-create-filename (shr-encode-url url)))
	    t)
      (when (or (search-forward "\n\n" nil t)
		(search-forward "\r\n\r\n" nil t))
	(shr-parse-image-data)))))

(defun shr-parse-image-data ()
  (list
   (buffer-substring (point) (point-max))
   (save-excursion
     (save-restriction
       (narrow-to-region (point-min) (point))
       (let ((content-type (mail-fetch-field "content-type")))
	 (and content-type
	      (intern content-type obarray)))))))

(defun shr-image-displayer (content-function)
  "Return a function to display an image.
CONTENT-FUNCTION is a function to retrieve an image for a cid url that
is an argument.  The function to be returned takes three arguments URL,
START, and END.  Note that START and END should be markers."
  `(lambda (url start end)
     (when url
       (if (string-match "\\`cid:" url)
	   ,(when content-function
	      `(let ((image (funcall ,content-function
				     (substring url (match-end 0)))))
		 (when image
		   (goto-char start)
		   (funcall shr-put-image-function
			    image (buffer-substring start end))
		   (delete-region (point) end))))
	 (url-retrieve url 'shr-image-fetched
		       (list (current-buffer) start end)
		       t t)))))

(defun shr-heading (cont &rest types)
  (shr-ensure-paragraph)
  (apply #'shr-fontize-cont cont types)
  (shr-ensure-paragraph))

(defun shr-urlify (start url &optional title)
  (shr-add-font start (point) 'shr-link)
  (add-text-properties
   start (point)
   (list 'shr-url url
	 'help-echo (if title (format "%s (%s)" url title) url)
	 'follow-link t
	 'mouse-face 'highlight
	 'keymap shr-map)))

(defun shr-encode-url (url)
  "Encode URL."
  (browse-url-url-encode-chars url "[)$ ]"))

(autoload 'shr-color-visible "shr-color")
(autoload 'shr-color->hexadecimal "shr-color")

(defun shr-color-check (fg bg)
  "Check that FG is visible on BG.
Returns (fg bg) with corrected values.
Returns nil if the colors that would be used are the default
ones, in case fg and bg are nil."
  (when (or fg bg)
    (let ((fixed (cond ((null fg) 'fg)
                       ((null bg) 'bg))))
      ;; Convert colors to hexadecimal, or set them to default.
      (let ((fg (or (shr-color->hexadecimal fg)
                    (frame-parameter nil 'foreground-color)))
            (bg (or (shr-color->hexadecimal bg)
                    (frame-parameter nil 'background-color))))
        (cond ((eq fixed 'bg)
               ;; Only return the new fg
               (list nil (cadr (shr-color-visible bg fg t))))
              ((eq fixed 'fg)
               ;; Invert args and results and return only the new bg
               (list (cadr (shr-color-visible fg bg t)) nil))
              (t
               (shr-color-visible bg fg)))))))

(defun shr-colorize-region (start end fg &optional bg)
  (when (and (not shr-inhibit-decoration)
	     (or fg bg))
    (let ((new-colors (shr-color-check fg bg)))
      (when new-colors
	(when fg
	  (add-face-text-property start end
				  (list :foreground (cadr new-colors))
				  t))
	(when bg
	  (add-face-text-property start end
				  (list :background (car new-colors))
				  t)))
      new-colors)))

(defun shr-expand-newlines (start end color)
  (save-restriction
    ;; Skip past all white space at the start and ends.
    (goto-char start)
    (skip-chars-forward " \t\n")
    (beginning-of-line)
    (setq start (point))
    (goto-char end)
    (skip-chars-backward " \t\n")
    (forward-line 1)
    (setq end (point))
    (narrow-to-region start end)
    (let ((width (shr-buffer-width))
	  column)
      (goto-char (point-min))
      (while (not (eobp))
	(end-of-line)
	(when (and (< (setq column (current-column)) width)
		   (< (setq column (shr-previous-newline-padding-width column))
		      width))
	  (let ((overlay (make-overlay (point) (1+ (point)))))
	    (overlay-put overlay 'before-string
			 (concat
			  (mapconcat
			   (lambda (overlay)
			     (let ((string (plist-get
					    (overlay-properties overlay)
					    'before-string)))
			       (if (not string)
				   ""
				 (overlay-put overlay 'before-string "")
				 string)))
			   (overlays-at (point))
			   "")
			  (propertize (make-string (- width column) ? )
				      'face (list :background color))))))
	(forward-line 1)))))

(defun shr-previous-newline-padding-width (width)
  (let ((overlays (overlays-at (point)))
	(previous-width 0))
    (if (null overlays)
	width
      (dolist (overlay overlays)
	(setq previous-width
	      (+ previous-width
		 (length (plist-get (overlay-properties overlay)
				    'before-string)))))
      (+ width previous-width))))

;;; Tag-specific rendering rules.

(defun shr-tag-body (cont)
  (let* ((start (point))
	 (fgcolor (cdr (or (assq :fgcolor cont)
                           (assq :text cont))))
	 (bgcolor (cdr (assq :bgcolor cont)))
	 (shr-stylesheet (list (cons 'color fgcolor)
			       (cons 'background-color bgcolor))))
    (shr-generic cont)
    (shr-colorize-region start (point) fgcolor bgcolor)))

(defun shr-tag-style (_cont)
  )

(defun shr-tag-script (_cont)
  )

(defun shr-tag-comment (_cont)
  )

(defun shr-dom-to-xml (dom)
  "Convert DOM into a string containing the xml representation."
  (let ((arg " ")
        (text "")
	url)
    (dolist (sub (cdr dom))
      (cond
       ((listp (cdr sub))
	;; Ignore external image definitions if required.
	;; <image xlink:href="http://TRACKING_URL/"/>
	(when (or (not (eq (car sub) 'image))
		  (not (setq url (cdr (assq ':xlink:href (cdr sub)))))
		  (not shr-blocked-images)
		  (not (string-match shr-blocked-images url)))
	  (setq text (concat text (shr-dom-to-xml sub)))))
       ((eq (car sub) 'text)
        (setq text (concat text (cdr sub))))
       (t
        (setq arg (concat arg (format "%s=\"%s\" "
                                      (substring (symbol-name (car sub)) 1)
                                      (cdr sub)))))))
    (format "<%s%s>%s</%s>"
            (car dom)
            (substring arg 0 (1- (length arg)))
            text
            (car dom))))

(defun shr-tag-svg (cont)
  (when (and (image-type-available-p 'svg)
	     (not shr-inhibit-images))
    (funcall shr-put-image-function
             (shr-dom-to-xml (cons 'svg cont))
             "SVG Image")))

(defun shr-tag-sup (cont)
  (let ((start (point)))
    (shr-generic cont)
    (put-text-property start (point) 'display '(raise 0.5))))

(defun shr-tag-sub (cont)
  (let ((start (point)))
    (shr-generic cont)
    (put-text-property start (point) 'display '(raise -0.5))))

(defun shr-tag-label (cont)
  (shr-generic cont)
  (shr-ensure-paragraph))

(defun shr-tag-p (cont)
  (shr-ensure-paragraph)
  (shr-indent)
  (shr-generic cont)
  (shr-ensure-paragraph))

(defun shr-tag-div (cont)
  (shr-ensure-newline)
  (shr-indent)
  (shr-generic cont)
  (shr-ensure-newline))

(defun shr-tag-s (cont)
  (shr-fontize-cont cont 'shr-strike-through))

(defun shr-tag-del (cont)
  (shr-fontize-cont cont 'shr-strike-through))

(defun shr-tag-b (cont)
  (shr-fontize-cont cont 'bold))

(defun shr-tag-i (cont)
  (shr-fontize-cont cont 'italic))

(defun shr-tag-em (cont)
  (shr-fontize-cont cont 'italic))

(defun shr-tag-strong (cont)
  (shr-fontize-cont cont 'bold))

(defun shr-tag-u (cont)
  (shr-fontize-cont cont 'underline))

(defun shr-parse-style (style)
  (when style
    (save-match-data
      (when (string-match "\n" style)
        (setq style (replace-match " " t t style))))
    (let ((plist nil))
      (dolist (elem (split-string style ";"))
	(when elem
	  (setq elem (split-string elem ":"))
	  (when (and (car elem)
		     (cadr elem))
	    (let ((name (replace-regexp-in-string "^ +\\| +$" "" (car elem)))
		  (value (replace-regexp-in-string "^ +\\| +$" "" (cadr elem))))
	      (when (string-match " *!important\\'" value)
		(setq value (substring value 0 (match-beginning 0))))
	      (push (cons (intern name obarray)
			  value)
		    plist)))))
      plist)))

(defun shr-tag-base (cont)
  (let ((base (cdr (assq :href cont))))
    (when base
      (setq shr-base (shr-parse-base base))))
  (shr-generic cont))

(defun shr-tag-a (cont)
  (let ((url (cdr (assq :href cont)))
        (title (cdr (assq :title cont)))
	(start (point))
	shr-start)
    (shr-generic cont)
    (when (and shr-target-id
	       (equal (cdr (assq :name cont)) shr-target-id))
      ;; We have a zero-length <a name="foo"> element, so just
      ;; insert...  something.
      (when (= start (point))
	(shr-ensure-newline)
	(insert " "))
      (put-text-property start (1+ start) 'shr-target-id shr-target-id))
    (when (and url
	       (not shr-inhibit-decoration))
      (shr-urlify (or shr-start start) (shr-expand-url url) title))))

(defun shr-tag-object (cont)
  (let ((start (point))
	url)
    (dolist (elem cont)
      (when (eq (car elem) 'embed)
	(setq url (or url (cdr (assq :src (cdr elem))))))
      (when (and (eq (car elem) 'param)
		 (equal (cdr (assq :name (cdr elem))) "movie"))
	(setq url (or url (cdr (assq :value (cdr elem)))))))
    (when url
      (shr-insert " [multimedia] ")
      (shr-urlify start (shr-expand-url url)))
    (shr-generic cont)))

(defcustom shr-prefer-media-type-alist '(("webm" . 1.0)
                                         ("ogv"  . 1.0)
                                         ("ogg"  . 1.0)
                                         ("opus" . 1.0)
                                         ("flac" . 0.9)
                                         ("wav"  . 0.5))
  "Preferences for media types.
The key element should be a regexp matched against the type of the source or
url if no type is specified.  The value should be a float in the range 0.0 to
1.0.  Media elements with higher value are preferred."
  :version "24.4"
  :group 'shr
  :type '(alist :key-type regexp :value-type float))

(defun shr--get-media-pref (elem)
  "Determine the preference for ELEM.
The preference is a float determined from `shr-prefer-media-type'."
  (let ((type (cdr (assq :type elem)))
        (p 0.0))
    (unless type
      (setq type (cdr (assq :src elem))))
    (when type
      (dolist (pref shr-prefer-media-type-alist)
        (when (and
               (> (cdr pref) p)
               (string-match-p (car pref) type))
          (setq p (cdr pref)))))
    p))

(defun shr--extract-best-source (cont &optional url pref)
  "Extract the best `:src' property from <source> blocks in CONT."
  (setq pref (or pref -1.0))
  (let (new-pref)
    (dolist (elem cont)
      (when (and (eq (car elem) 'source)
		 (< pref
		    (setq new-pref
			  (shr--get-media-pref elem))))
	(setq pref new-pref
	      url (cdr (assq :src elem)))
        ;; libxml's html parser isn't HTML5 compliant and non terminated
        ;; source tags might end up as children.  So recursion it is...
        (dolist (child (cdr elem))
          (when (eq (car child) 'source)
            (let ((ret (shr--extract-best-source (list child) url pref)))
              (when (< pref (cdr ret))
                (setq url (car ret)
                      pref (cdr ret)))))))))
  (cons url pref))

(defun shr-tag-video (cont)
  (let ((image (cdr (assq :poster cont)))
        (url (cdr (assq :src cont)))
        (start (point)))
    (unless url
      (setq url (car (shr--extract-best-source cont))))
    (if image
        (shr-tag-img nil image)
      (shr-insert " [video] "))
    (shr-urlify start (shr-expand-url url))))

(defun shr-tag-audio (cont)
  (let ((url (cdr (assq :src cont)))
        (start (point)))
    (unless url
      (setq url (car (shr--extract-best-source cont))))
    (shr-insert " [audio] ")
    (shr-urlify start (shr-expand-url url))))

(defun shr-tag-img (cont &optional url)
  (when (or url
	    (and cont
		 (> (length (cdr (assq :src cont))) 0)))
    (when (and (> (current-column) 0)
	       (not (eq shr-state 'image)))
      (insert "\n"))
    (let ((alt (cdr (assq :alt cont)))
	  (url (shr-expand-url (or url (cdr (assq :src cont))))))
      (let ((start (point-marker)))
	(when (zerop (length alt))
	  (setq alt "*"))
	(cond
	 ((or (member (cdr (assq :height cont)) '("0" "1"))
	      (member (cdr (assq :width cont)) '("0" "1")))
	  ;; Ignore zero-sized or single-pixel images.
	  )
	 ((and (not shr-inhibit-images)
	       (string-match "\\`data:" url))
	  (let ((image (shr-image-from-data (substring url (match-end 0)))))
	    (if image
		(funcall shr-put-image-function image alt)
	      (insert alt))))
	 ((and (not shr-inhibit-images)
	       (string-match "\\`cid:" url))
	  (let ((url (substring url (match-end 0)))
		image)
	    (if (or (not shr-content-function)
		    (not (setq image (funcall shr-content-function url))))
		(insert alt)
	      (funcall shr-put-image-function image alt))))
	 ((or shr-inhibit-images
	      (and shr-blocked-images
		   (string-match shr-blocked-images url)))
	  (setq shr-start (point))
	  (let ((shr-state 'space))
	    (if (> (string-width alt) 8)
		(shr-insert (truncate-string-to-width alt 8))
	      (shr-insert alt))))
	 ((and (not shr-ignore-cache)
	       (url-is-cached (shr-encode-url url)))
	  (funcall shr-put-image-function (shr-get-image-data url) alt))
	 (t
	  (insert alt " ")
	  (when (and shr-ignore-cache
		     (url-is-cached (shr-encode-url url)))
	    (let ((file (url-cache-create-filename (shr-encode-url url))))
	      (when (file-exists-p file)
		(delete-file file))))
	  (url-queue-retrieve
	   (shr-encode-url url) 'shr-image-fetched
	   (list (current-buffer) start (set-marker (make-marker) (1- (point))))
	   t t)))
	(when (zerop shr-table-depth) ;; We are not in a table.
	  (put-text-property start (point) 'keymap shr-map)
	  (put-text-property start (point) 'shr-alt alt)
	  (put-text-property start (point) 'image-url url)
	  (put-text-property start (point) 'image-displayer
			     (shr-image-displayer shr-content-function))
	  (put-text-property start (point) 'help-echo
			     (or (cdr (assq :title cont))
				 alt)))
	(setq shr-state 'image)))))

(defun shr-tag-pre (cont)
  (let ((shr-folding-mode 'none))
    (shr-ensure-newline)
    (shr-indent)
    (shr-generic cont)
    (shr-ensure-newline)))

(defun shr-tag-blockquote (cont)
  (shr-ensure-paragraph)
  (shr-indent)
  (let ((shr-indentation (+ shr-indentation 4)))
    (shr-generic cont))
  (shr-ensure-paragraph))

(defun shr-tag-dl (cont)
  (shr-ensure-paragraph)
  (shr-generic cont)
  (shr-ensure-paragraph))

(defun shr-tag-dt (cont)
  (shr-ensure-newline)
  (shr-generic cont)
  (shr-ensure-newline))

(defun shr-tag-dd (cont)
  (shr-ensure-newline)
  (let ((shr-indentation (+ shr-indentation 4)))
    (shr-generic cont)))

(defun shr-tag-ul (cont)
  (shr-ensure-paragraph)
  (let ((shr-list-mode 'ul))
    (shr-generic cont))
  (shr-ensure-paragraph))

(defun shr-tag-ol (cont)
  (shr-ensure-paragraph)
  (let ((shr-list-mode 1))
    (shr-generic cont))
  (shr-ensure-paragraph))

(defun shr-tag-li (cont)
  (shr-ensure-newline)
  (shr-indent)
  (let* ((bullet
	  (if (numberp shr-list-mode)
	      (prog1
		  (format "%d " shr-list-mode)
		(setq shr-list-mode (1+ shr-list-mode)))
	    shr-bullet))
	 (shr-indentation (+ shr-indentation (length bullet))))
    (insert bullet)
    (shr-generic cont)))

(defun shr-tag-br (cont)
  (when (and (not (bobp))
	     ;; Only add a newline if we break the current line, or
	     ;; the previous line isn't a blank line.
	     (or (not (bolp))
		 (and (> (- (point) 2) (point-min))
		      (not (= (char-after (- (point) 2)) ?\n)))))
    (insert "\n")
    (shr-indent))
  (shr-generic cont))

(defun shr-tag-span (cont)
  (shr-generic cont))

(defun shr-tag-h1 (cont)
  (shr-heading cont 'bold 'underline))

(defun shr-tag-h2 (cont)
  (shr-heading cont 'bold))

(defun shr-tag-h3 (cont)
  (shr-heading cont 'italic))

(defun shr-tag-h4 (cont)
  (shr-heading cont))

(defun shr-tag-h5 (cont)
  (shr-heading cont))

(defun shr-tag-h6 (cont)
  (shr-heading cont))

(defun shr-tag-hr (_cont)
  (shr-ensure-newline)
  (insert (make-string shr-width shr-hr-line) "\n"))

(defun shr-tag-title (cont)
  (shr-heading cont 'bold 'underline))

(defun shr-tag-font (cont)
  (let* ((start (point))
         (color (cdr (assq :color cont)))
         (shr-stylesheet (nconc (list (cons 'color color))
				shr-stylesheet)))
    (shr-generic cont)
    (when color
      (shr-colorize-region start (point) color
			   (cdr (assq 'background-color shr-stylesheet))))))

;;; Table rendering algorithm.

;; Table rendering is the only complicated thing here.  We do this by
;; first counting how many TDs there are in each TR, and registering
;; how wide they think they should be ("width=45%", etc).  Then we
;; render each TD separately (this is done in temporary buffers, so
;; that we can use all the rendering machinery as if we were in the
;; main buffer).  Now we know how much space each TD really takes, so
;; we then render everything again with the new widths, and finally
;; insert all these boxes into the main buffer.
(defun shr-tag-table-1 (cont)
  (setq cont (or (cdr (assq 'tbody cont))
		 cont))
  (let* ((shr-inhibit-images t)
	 (shr-table-depth (1+ shr-table-depth))
	 (shr-kinsoku-shorten t)
	 ;; Find all suggested widths.
	 (columns (shr-column-specs cont))
	 ;; Compute how many characters wide each TD should be.
	 (suggested-widths (shr-pro-rate-columns columns))
	 ;; Do a "test rendering" to see how big each TD is (this can
	 ;; be smaller (if there's little text) or bigger (if there's
	 ;; unbreakable text).
	 (sketch (shr-make-table cont suggested-widths))
	 ;; Compute the "natural" width by setting each column to 500
	 ;; characters and see how wide they really render.
	 (natural (shr-make-table cont (make-vector (length columns) 500)))
	 (sketch-widths (shr-table-widths sketch natural suggested-widths)))
    ;; This probably won't work very well.
    (when (> (+ (loop for width across sketch-widths
		      summing (1+ width))
		shr-indentation 1)
	     (frame-width))
      (setq truncate-lines t))
    ;; Then render the table again with these new "hard" widths.
    (shr-insert-table (shr-make-table cont sketch-widths t) sketch-widths)))

(defun shr-tag-table (cont)
  (shr-ensure-paragraph)
  (let* ((caption (cdr (assq 'caption cont)))
	 (header (cdr (assq 'thead cont)))
	 (body (or (cdr (assq 'tbody cont)) cont))
	 (footer (cdr (assq 'tfoot cont)))
         (bgcolor (cdr (assq :bgcolor cont)))
	 (start (point))
	 (shr-stylesheet (nconc (list (cons 'background-color bgcolor))
				shr-stylesheet))
	 (nheader (if header (shr-max-columns header)))
	 (nbody (if body (shr-max-columns body)))
	 (nfooter (if footer (shr-max-columns footer))))
    (if (and (not caption)
	     (not header)
	     (not (cdr (assq 'tbody cont)))
	     (not (cdr (assq 'tr cont)))
	     (not footer))
	;; The table is totally invalid and just contains random junk.
	;; Try to output it anyway.
	(shr-generic cont)
      ;; It's a real table, so render it.
      (shr-tag-table-1
       (nconc
	(if caption `((tr (td ,@caption))))
	(if header
	    (if footer
		;; header + body + footer
		(if (= nheader nbody)
		    (if (= nbody nfooter)
			`((tr (td (table (tbody ,@header ,@body ,@footer)))))
		      (nconc `((tr (td (table (tbody ,@header ,@body)))))
			     (if (= nfooter 1)
				 footer
			       `((tr (td (table (tbody ,@footer))))))))
		  (nconc `((tr (td (table (tbody ,@header)))))
			 (if (= nbody nfooter)
			     `((tr (td (table (tbody ,@body ,@footer)))))
			   (nconc `((tr (td (table (tbody ,@body)))))
				  (if (= nfooter 1)
				      footer
				    `((tr (td (table (tbody ,@footer))))))))))
	      ;; header + body
	      (if (= nheader nbody)
		  `((tr (td (table (tbody ,@header ,@body)))))
		(if (= nheader 1)
		    `(,@header (tr (td (table (tbody ,@body)))))
		  `((tr (td (table (tbody ,@header))))
		    (tr (td (table (tbody ,@body))))))))
	  (if footer
	      ;; body + footer
	      (if (= nbody nfooter)
		  `((tr (td (table (tbody ,@body ,@footer)))))
		(nconc `((tr (td (table (tbody ,@body)))))
		       (if (= nfooter 1)
			   footer
			 `((tr (td (table (tbody ,@footer))))))))
	    (if caption
		`((tr (td (table (tbody ,@body)))))
	      body))))))
    (when bgcolor
      (shr-colorize-region start (point) (cdr (assq 'color shr-stylesheet))
			   bgcolor))
    ;; Finally, insert all the images after the table.  The Emacs buffer
    ;; model isn't strong enough to allow us to put the images actually
    ;; into the tables.
    (when (zerop shr-table-depth)
      (dolist (elem (shr-find-elements cont 'img))
	(shr-tag-img (cdr elem))))))

(defun shr-find-elements (cont type)
  (let (result)
    (dolist (elem cont)
      (cond ((eq (car elem) type)
	     (push elem result))
	    ((consp (cdr elem))
	     (setq result (nconc (shr-find-elements (cdr elem) type) result)))))
    (nreverse result)))

(defun shr-insert-table (table widths)
  (let* ((collapse (equal (cdr (assq 'border-collapse shr-stylesheet))
			  "collapse"))
	 (shr-table-separator-length (if collapse 0 1))
	 (shr-table-vertical-line (if collapse "" shr-table-vertical-line)))
    (unless collapse
      (shr-insert-table-ruler widths))
    (dolist (row table)
      (let ((start (point))
	    (height (let ((max 0))
		      (dolist (column row)
			(setq max (max max (cadr column))))
		      max)))
	(dotimes (i height)
	  (shr-indent)
	  (insert shr-table-vertical-line "\n"))
	(dolist (column row)
	  (goto-char start)
	  (let ((lines (nth 2 column)))
	    (dolist (line lines)
	      (end-of-line)
	      (insert line shr-table-vertical-line)
	      (forward-line 1))
	    ;; Add blank lines at padding at the bottom of the TD,
	    ;; possibly.
	    (dotimes (i (- height (length lines)))
	      (end-of-line)
	      (let ((start (point)))
		(insert (make-string (string-width (car lines)) ? )
			shr-table-vertical-line)
		(when (nth 4 column)
		  (shr-add-font start (1- (point))
				(list :background (nth 4 column)))))
	      (forward-line 1)))))
      (unless collapse
	(shr-insert-table-ruler widths)))))

(defun shr-insert-table-ruler (widths)
  (when shr-table-horizontal-line
    (when (and (bolp)
	       (> shr-indentation 0))
      (shr-indent))
    (insert shr-table-corner)
    (dotimes (i (length widths))
      (insert (make-string (aref widths i) shr-table-horizontal-line)
	      shr-table-corner))
    (insert "\n")))

(defun shr-table-widths (table natural-table suggested-widths)
  (let* ((length (length suggested-widths))
	 (widths (make-vector length 0))
	 (natural-widths (make-vector length 0)))
    (dolist (row table)
      (let ((i 0))
	(dolist (column row)
	  (aset widths i (max (aref widths i) column))
	  (setq i (1+ i)))))
    (dolist (row natural-table)
      (let ((i 0))
	(dolist (column row)
	  (aset natural-widths i (max (aref natural-widths i) column))
	  (setq i (1+ i)))))
    (let ((extra (- (apply '+ (append suggested-widths nil))
		    (apply '+ (append widths nil))))
	  (expanded-columns 0))
      ;; We have extra, unused space, so divide this space amongst the
      ;; columns.
      (when (> extra 0)
	;; If the natural width is wider than the rendered width, we
	;; want to allow the column to expand.
	(dotimes (i length)
	  (when (> (aref natural-widths i) (aref widths i))
	    (setq expanded-columns (1+ expanded-columns))))
	(dotimes (i length)
	  (when (> (aref natural-widths i) (aref widths i))
	    (aset widths i (min
			    (aref natural-widths i)
			    (+ (/ extra expanded-columns)
			       (aref widths i))))))))
    widths))

(defun shr-make-table (cont widths &optional fill)
  (or (cadr (assoc (list cont widths fill) shr-content-cache))
      (let ((data (shr-make-table-1 cont widths fill)))
	(push (list (list cont widths fill) data)
	      shr-content-cache)
	data)))

(defun shr-make-table-1 (cont widths &optional fill)
  (let ((trs nil)
	(shr-inhibit-decoration (not fill))
	(rowspans (make-vector (length widths) 0))
	width colspan)
    (dolist (row cont)
      (when (eq (car row) 'tr)
	(let ((tds nil)
	      (columns (cdr row))
	      (i 0)
	      (width-column 0)
	      column)
	  (while (< i (length widths))
	    ;; If we previously had a rowspan definition, then that
	    ;; means that we now have a "missing" td/th element here.
	    ;; So just insert a dummy, empty one to (sort of) emulate
	    ;; rowspan.
	    (setq column
		  (if (zerop (aref rowspans i))
		      (pop columns)
		    (aset rowspans i (1- (aref rowspans i)))
		    '(td)))
	    (when (or (memq (car column) '(td th))
		      (not column))
	      (when (cdr (assq :rowspan (cdr column)))
		(aset rowspans i (+ (aref rowspans i)
				    (1- (string-to-number
					 (cdr (assq :rowspan (cdr column))))))))
	      ;; Sanity check for invalid column-spans.
	      (when (>= width-column (length widths))
		(setq width-column 0))
	      (setq width
		    (if column
			(aref widths width-column)
		      10))
	      (when (and fill
			 (setq colspan (cdr (assq :colspan (cdr column)))))
		(setq colspan (min (string-to-number colspan)
				   ;; The colspan may be wrong, so
				   ;; truncate it to the length of the
				   ;; remaining columns.
				   (- (length widths) i)))
		(dotimes (j (1- colspan))
		  (if (> (+ i 1 j) (1- (length widths)))
		      (setq width (aref widths (1- (length widths))))
		    (setq width (+ width
				   shr-table-separator-length
				   (aref widths (+ i 1 j))))))
		(setq width-column (+ width-column (1- colspan))))
	      (when (or column
			(not fill))
		(push (shr-render-td (cdr column) width fill)
		      tds))
	      (setq i (1+ i)
		    width-column (1+ width-column))))
	  (push (nreverse tds) trs))))
    (nreverse trs)))

(defun shr-render-td (cont width fill)
  (with-temp-buffer
    (let ((bgcolor (cdr (assq :bgcolor cont)))
	  (fgcolor (cdr (assq :fgcolor cont)))
	  (style (cdr (assq :style cont)))
	  (shr-stylesheet shr-stylesheet)
	  actual-colors)
      (when style
	(setq style (and (string-match "color" style)
			 (shr-parse-style style))))
      (when bgcolor
	(setq style (nconc (list (cons 'background-color bgcolor)) style)))
      (when fgcolor
	(setq style (nconc (list (cons 'color fgcolor)) style)))
      (when style
	(setq shr-stylesheet (append style shr-stylesheet)))
      (let ((shr-width width)
	    (shr-indentation 0))
	(shr-descend (cons 'td cont)))
      ;; Delete padding at the bottom of the TDs.
      (delete-region
       (point)
       (progn
	 (skip-chars-backward " \t\n")
	 (end-of-line)
	 (point)))
      (goto-char (point-min))
      (let ((max 0))
	(while (not (eobp))
	  (end-of-line)
	  (setq max (max max (current-column)))
	  (forward-line 1))
	(when fill
	  (goto-char (point-min))
	  ;; If the buffer is totally empty, then put a single blank
	  ;; line here.
	  (if (zerop (buffer-size))
	      (insert (make-string width ? ))
	    ;; Otherwise, fill the buffer.
	    (let ((align (cdr (assq :align cont)))
		  length)
	      (while (not (eobp))
		(end-of-line)
		(setq length (- width (current-column)))
		(when (> length 0)
		  (cond
		   ((equal align "right")
		    (beginning-of-line)
		    (insert (make-string length ? )))
		   ((equal align "center")
		    (insert (make-string (/ length 2) ? ))
		    (beginning-of-line)
		    (insert (make-string (- length (/ length 2)) ? )))
		   (t
		    (insert (make-string length ? )))))
		(forward-line 1))))
	  (when style
	    (setq actual-colors
		  (shr-colorize-region
		   (point-min) (point-max)
		   (cdr (assq 'color shr-stylesheet))
		   (cdr (assq 'background-color shr-stylesheet))))))
	(if fill
	    (list max
		  (count-lines (point-min) (point-max))
		  (split-string (buffer-string) "\n")
		  nil
		  (car actual-colors))
	  max)))))

(defun shr-buffer-width ()
  (goto-char (point-min))
  (let ((max 0))
    (while (not (eobp))
      (end-of-line)
      (setq max (max max (current-column)))
      (forward-line 1))
    max))

(defun shr-pro-rate-columns (columns)
  (let ((total-percentage 0)
	(widths (make-vector (length columns) 0)))
    (dotimes (i (length columns))
      (setq total-percentage (+ total-percentage (aref columns i))))
    (setq total-percentage (/ 1.0 total-percentage))
    (dotimes (i (length columns))
      (aset widths i (max (truncate (* (aref columns i)
				       total-percentage
				       (- shr-width (1+ (length columns)))))
			  10)))
    widths))

;; Return a summary of the number and shape of the TDs in the table.
(defun shr-column-specs (cont)
  (let ((columns (make-vector (shr-max-columns cont) 1)))
    (dolist (row cont)
      (when (eq (car row) 'tr)
	(let ((i 0))
	  (dolist (column (cdr row))
	    (when (memq (car column) '(td th))
	      (let ((width (cdr (assq :width (cdr column)))))
		(when (and width
			   (string-match "\\([0-9]+\\)%" width)
			   (not (zerop (setq width (string-to-number
						    (match-string 1 width))))))
		  (aset columns i (/ width 100.0))))
	      (setq i (1+ i)))))))
    columns))

(defun shr-count (cont elem)
  (let ((i 0))
    (dolist (sub cont)
      (when (eq (car sub) elem)
	(setq i (1+ i))))
    i))

(defun shr-max-columns (cont)
  (let ((max 0))
    (dolist (row cont)
      (when (eq (car row) 'tr)
	(setq max (max max (+ (shr-count (cdr row) 'td)
			      (shr-count (cdr row) 'th))))))
    max))

(provide 'shr)

;; Local Variables:
;; coding: utf-8
;; End:

;;; shr.el ends here
