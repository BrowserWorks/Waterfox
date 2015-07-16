;;; eww.el --- Emacs Web Wowser

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

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

;;; Code:

(eval-when-compile (require 'cl))
(require 'format-spec)
(require 'shr)
(require 'url)
(require 'mm-url)

(defgroup eww nil
  "Emacs Web Wowser"
  :version "24.4"
  :link '(custom-manual "(eww) Top")
  :group 'hypermedia
  :prefix "eww-")

(defcustom eww-header-line-format "%t: %u"
  "Header line format.
- %t is replaced by the title.
- %u is replaced by the URL."
  :version "24.4"
  :group 'eww
  :type 'string)

(defcustom eww-search-prefix "https://duckduckgo.com/html/?q="
  "Prefix URL to search engine"
  :version "24.4"
  :group 'eww
  :type 'string)

(defcustom eww-download-directory "~/Downloads/"
  "Directory where files will downloaded."
  :version "24.4"
  :group 'eww
  :type 'string)

(defcustom eww-use-external-browser-for-content-type
  "\\`\\(video/\\|audio/\\|application/ogg\\)"
  "Always use external browser for specified content-type."
  :version "24.4"
  :group 'eww
  :type '(choice (const :tag "Never" nil)
                 regexp))

(defcustom eww-form-checkbox-selected-symbol "[X]"
  "Symbol used to represent a selected checkbox.
See also `eww-form-checkbox-symbol'."
  :version "24.4"
  :group 'eww
  :type '(choice (const "[X]")
                 (const "☒")            ; Unicode BALLOT BOX WITH X
                 (const "☑")            ; Unicode BALLOT BOX WITH CHECK
                 string))

(defcustom eww-form-checkbox-symbol "[ ]"
  "Symbol used to represent a checkbox.
See also `eww-form-checkbox-selected-symbol'."
  :version "24.4"
  :group 'eww
  :type '(choice (const "[ ]")
                 (const "☐")            ; Unicode BALLOT BOX
                 string))

(defface eww-form-submit
  '((((type x w32 ns) (class color))	; Like default mode line
     :box (:line-width 2 :style released-button)
     :background "#808080" :foreground "black"))
  "Face for eww buffer buttons."
  :version "24.4"
  :group 'eww)

(defface eww-form-checkbox
  '((((type x w32 ns) (class color))	; Like default mode line
     :box (:line-width 2 :style released-button)
     :background "lightgrey" :foreground "black"))
  "Face for eww buffer buttons."
  :version "24.4"
  :group 'eww)

(defface eww-form-select
  '((((type x w32 ns) (class color))	; Like default mode line
     :box (:line-width 2 :style released-button)
     :background "lightgrey" :foreground "black"))
  "Face for eww buffer buttons."
  :version "24.4"
  :group 'eww)

(defface eww-form-text
  '((t (:background "#505050"
		    :foreground "white"
		    :box (:line-width 1))))
  "Face for eww text inputs."
  :version "24.4"
  :group 'eww)

(defface eww-form-textarea
  '((t (:background "#C0C0C0"
		    :foreground "black"
		    :box (:line-width 1))))
  "Face for eww textarea inputs."
  :version "24.4"
  :group 'eww)

(defvar eww-current-url nil)
(defvar eww-current-dom nil)
(defvar eww-current-source nil)
(defvar eww-current-title ""
  "Title of current page.")
(defvar eww-history nil)
(defvar eww-history-position 0)

(defvar eww-next-url nil)
(defvar eww-previous-url nil)
(defvar eww-up-url nil)
(defvar eww-home-url nil)
(defvar eww-start-url nil)
(defvar eww-contents-url nil)

(defvar eww-local-regex "localhost"
  "When this regex is found in the URL, it's not a keyword but an address.")

(defvar eww-link-keymap
  (let ((map (copy-keymap shr-map)))
    (define-key map "\r" 'eww-follow-link)
    map))

;;;###autoload
(defun eww (url)
  "Fetch URL and render the page.
If the input doesn't look like an URL or a domain name, the
word(s) will be searched for via `eww-search-prefix'."
  (interactive "sEnter URL or keywords: ")
  (cond ((string-match-p "\\`file://" url))
        ((string-match-p "\\`ftp://" url)
         (user-error "FTP is not supported."))
        (t
         (if (and (= (length (split-string url)) 1)
                 (or (and (not (string-match-p "\\`[\"\'].*[\"\']\\'" url))
                          (> (length (split-string url "\\.")) 1))
                     (string-match eww-local-regex url)))
             (progn
               (unless (string-match-p "\\`[a-zA-Z][-a-zA-Z0-9+.]*://" url)
                 (setq url (concat "http://" url)))
               ;; some site don't redirect final /
               (when (string= (url-filename (url-generic-parse-url url)) "")
                 (setq url (concat url "/"))))
           (setq url (concat eww-search-prefix
                             (replace-regexp-in-string " " "+" url))))))
  (url-retrieve url 'eww-render (list url)))

;;;###autoload (defalias 'browse-web 'eww)

;;;###autoload
(defun eww-open-file (file)
  "Render a file using EWW."
  (interactive "fFile: ")
  (eww (concat "file://"
	       (and (memq system-type '(windows-nt ms-dos))
		    "/")
	       (expand-file-name file))))

(defun eww-render (status url &optional point)
  (let ((redirect (plist-get status :redirect)))
    (when redirect
      (setq url redirect)))
  (let* ((headers (eww-parse-headers))
	 (content-type
	  (mail-header-parse-content-type
	   (or (cdr (assoc "content-type" headers))
	       "text/plain")))
	 (charset (intern
		   (downcase
		    (or (cdr (assq 'charset (cdr content-type)))
			(eww-detect-charset (equal (car content-type)
						   "text/html"))
			"utf8"))))
	 (data-buffer (current-buffer)))
    (unwind-protect
	(progn
          (setq eww-current-title "")
	  (cond
           ((and eww-use-external-browser-for-content-type
                 (string-match-p eww-use-external-browser-for-content-type
                                 (car content-type)))
            (eww-browse-with-external-browser url))
	   ((equal (car content-type) "text/html")
	    (eww-display-html charset url nil point))
	   ((string-match-p "\\`image/" (car content-type))
	    (eww-display-image)
	    (eww-update-header-line-format))
	   (t
	    (eww-display-raw)
	    (eww-update-header-line-format)))
	  (setq eww-current-url url
		eww-history-position 0))
      (kill-buffer data-buffer))))

(defun eww-parse-headers ()
  (let ((headers nil))
    (goto-char (point-min))
    (while (and (not (eobp))
		(not (eolp)))
      (when (looking-at "\\([^:]+\\): *\\(.*\\)")
	(push (cons (downcase (match-string 1))
		    (match-string 2))
	      headers))
      (forward-line 1))
    (unless (eobp)
      (forward-line 1))
    headers))

(defun eww-detect-charset (html-p)
  (let ((case-fold-search t)
	(pt (point)))
    (or (and html-p
	     (re-search-forward
	      "<meta[\t\n\r ]+[^>]*charset=\"?\\([^\t\n\r \"/>]+\\)[\\\"'.*]" nil t)
	     (goto-char pt)
	     (match-string 1))
	(and (looking-at
	      "[\t\n\r ]*<\\?xml[\t\n\r ]+[^>]*encoding=\"\\([^\"]+\\)")
	     (match-string 1)))))

(declare-function libxml-parse-html-region "xml.c"
		  (start end &optional base-url))

(defun eww-display-html (charset url &optional document point)
  (or (fboundp 'libxml-parse-html-region)
      (error "This function requires Emacs to be compiled with libxml2"))
  (unless (eq charset 'utf8)
    (condition-case nil
	(decode-coding-region (point) (point-max) charset)
      (coding-system-error nil)))
  (let ((document
	 (or document
	     (list
	      'base (list (cons 'href url))
	      (libxml-parse-html-region (point) (point-max))))))
    (setq eww-current-source (buffer-substring (point) (point-max)))
    (eww-setup-buffer)
    (setq eww-current-dom document)
    (let ((inhibit-read-only t)
	  (after-change-functions nil)
	  (shr-width nil)
	  (shr-target-id (url-target (url-generic-parse-url url)))
	  (shr-external-rendering-functions
	   '((title . eww-tag-title)
	     (form . eww-tag-form)
	     (input . eww-tag-input)
	     (textarea . eww-tag-textarea)
	     (body . eww-tag-body)
	     (select . eww-tag-select)
	     (link . eww-tag-link)
	     (a . eww-tag-a))))
      (shr-insert-document document)
      (cond
       (point
	(goto-char point))
       (shr-target-id
	(goto-char (point-min))
	(let ((point (next-single-property-change
		      (point-min) 'shr-target-id)))
	  (when point
	    (goto-char point))))
       (t
	(goto-char (point-min)))))
    (setq eww-current-url url
	  eww-history-position 0)
    (eww-update-header-line-format)))

(defun eww-handle-link (cont)
  (let* ((rel (assq :rel cont))
  	(href (assq :href cont))
	(where (assoc
		;; The text associated with :rel is case-insensitive.
		(if rel (downcase (cdr rel)))
		      '(("next" . eww-next-url)
			;; Texinfo uses "previous", but HTML specifies
			;; "prev", so recognize both.
			("previous" . eww-previous-url)
			("prev" . eww-previous-url)
			;; HTML specifies "start" but also "contents",
			;; and Gtk seems to use "home".  Recognize
			;; them all; but store them in different
			;; variables so that we can readily choose the
			;; "best" one.
			("start" . eww-start-url)
			("home" . eww-home-url)
			("contents" . eww-contents-url)
			("up" . eww-up-url)))))
    (and href
	 where
	 (set (cdr where) (cdr href)))))

(defun eww-tag-link (cont)
  (eww-handle-link cont)
  (shr-generic cont))

(defun eww-tag-a (cont)
  (eww-handle-link cont)
  (let ((start (point)))
    (shr-tag-a cont)
    (put-text-property start (point) 'keymap eww-link-keymap)))

(defun eww-update-header-line-format ()
  (if eww-header-line-format
      (setq header-line-format
	    (replace-regexp-in-string
	     "%" "%%"
	     ;; FIXME?  Title can be blank.  Default to, eg, last component
	     ;; of url?
	     (format-spec eww-header-line-format
			  `((?u . ,eww-current-url)
			    (?t . ,eww-current-title)))))
    (setq header-line-format nil)))

(defun eww-tag-title (cont)
  (setq eww-current-title "")
  (dolist (sub cont)
    (when (eq (car sub) 'text)
      (setq eww-current-title (concat eww-current-title (cdr sub)))))
  (eww-update-header-line-format))

(defun eww-tag-body (cont)
  (let* ((start (point))
	 (fgcolor (cdr (or (assq :fgcolor cont)
                           (assq :text cont))))
	 (bgcolor (cdr (assq :bgcolor cont)))
	 (shr-stylesheet (list (cons 'color fgcolor)
			       (cons 'background-color bgcolor))))
    (shr-generic cont)
    (eww-colorize-region start (point) fgcolor bgcolor)))

(defun eww-colorize-region (start end fg &optional bg)
  (when (or fg bg)
    (let ((new-colors (shr-color-check fg bg)))
      (when new-colors
	(when fg
	  (add-face-text-property start end
				  (list :foreground (cadr new-colors))
				  t))
	(when bg
	  (add-face-text-property start end
				  (list :background (car new-colors))
				  t))))))

(defun eww-display-raw ()
  (let ((data (buffer-substring (point) (point-max))))
    (eww-setup-buffer)
    (let ((inhibit-read-only t))
      (insert data))
    (goto-char (point-min))))

(defun eww-display-image ()
  (let ((data (shr-parse-image-data)))
    (eww-setup-buffer)
    (let ((inhibit-read-only t))
      (shr-put-image data nil))
    (goto-char (point-min))))

(defun eww-setup-buffer ()
  (switch-to-buffer (get-buffer-create "*eww*"))
  (let ((inhibit-read-only t))
    (remove-overlays)
    (erase-buffer))
  (unless (eq major-mode 'eww-mode)
    (eww-mode))
  (setq-local eww-next-url nil)
  (setq-local eww-previous-url nil)
  (setq-local eww-up-url nil)
  (setq-local eww-home-url nil)
  (setq-local eww-start-url nil)
  (setq-local eww-contents-url nil))

(defun eww-view-source ()
  (interactive)
  (let ((buf (get-buffer-create "*eww-source*"))
        (source eww-current-source))
    (with-current-buffer buf
      (delete-region (point-min) (point-max))
      (insert (or eww-current-source "no source"))
      (goto-char (point-min))
      (when (fboundp 'html-mode)
        (html-mode)))
    (view-buffer buf)))

(defvar eww-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map "q" 'quit-window)
    (define-key map "g" 'eww-reload)
    (define-key map [?\t] 'shr-next-link)
    (define-key map [?\M-\t] 'shr-previous-link)
    (define-key map [delete] 'scroll-down-command)
    (define-key map [?\S-\ ] 'scroll-down-command)
    (define-key map "\177" 'scroll-down-command)
    (define-key map " " 'scroll-up-command)
    (define-key map "l" 'eww-back-url)
    (define-key map "r" 'eww-forward-url)
    (define-key map "n" 'eww-next-url)
    (define-key map "p" 'eww-previous-url)
    (define-key map "u" 'eww-up-url)
    (define-key map "t" 'eww-top-url)
    (define-key map "&" 'eww-browse-with-external-browser)
    (define-key map "d" 'eww-download)
    (define-key map "w" 'eww-copy-page-url)
    (define-key map "C" 'url-cookie-list)
    (define-key map "v" 'eww-view-source)
    (define-key map "H" 'eww-list-histories)

    (define-key map "b" 'eww-add-bookmark)
    (define-key map "B" 'eww-list-bookmarks)
    (define-key map [(meta n)] 'eww-next-bookmark)
    (define-key map [(meta p)] 'eww-previous-bookmark)

    (easy-menu-define nil map ""
      '("Eww"
	["Exit" eww-quit t]
	["Close browser" quit-window t]
	["Reload" eww-reload t]
	["Back to previous page" eww-back-url
	 :active (not (zerop (length eww-history)))]
	["Forward to next page" eww-forward-url
	 :active (not (zerop eww-history-position))]
	["Browse with external browser" eww-browse-with-external-browser t]
	["Download" eww-download t]
	["View page source" eww-view-source]
	["Copy page URL" eww-copy-page-url t]
	["List histories" eww-list-histories t]
	["Add bookmark" eww-add-bookmark t]
	["List bookmarks" eww-list-bookmarks t]
	["List cookies" url-cookie-list t]))
    map))

(defvar eww-tool-bar-map
  (let ((map (make-sparse-keymap)))
    (dolist (tool-bar-item
             '((eww-quit . "close")
               (eww-reload . "refresh")
               (eww-back-url . "left-arrow")
               (eww-forward-url . "right-arrow")
               (eww-view-source . "show")
               (eww-copy-page-url . "copy")
               (eww-add-bookmark . "bookmark_add"))) ;; ...
      (tool-bar-local-item-from-menu
       (car tool-bar-item) (cdr tool-bar-item) map eww-mode-map))
    map)
  "Tool bar for `eww-mode'.")

(define-derived-mode eww-mode nil "eww"
  "Mode for browsing the web.

\\{eww-mode-map}"
  ;; FIXME?  This seems a strange default.
  (setq-local eww-current-url 'author)
  (setq-local eww-current-dom nil)
  (setq-local eww-current-source nil)
  (setq-local eww-current-title "")
  (setq-local browse-url-browser-function 'eww-browse-url)
  (setq-local after-change-functions 'eww-process-text-input)
  (setq-local eww-history nil)
  (setq-local eww-history-position 0)
  (when (boundp 'tool-bar-map)
   (setq-local tool-bar-map eww-tool-bar-map))
  (buffer-disable-undo)
  ;;(setq buffer-read-only t)
  )

;;;###autoload
(defun eww-browse-url (url &optional _new-window)
  (when (and (equal major-mode 'eww-mode)
	     eww-current-url)
    (eww-save-history))
  (eww url))

(defun eww-back-url ()
  "Go to the previously displayed page."
  (interactive)
  (when (>= eww-history-position (length eww-history))
    (user-error "No previous page"))
  (eww-save-history)
  (setq eww-history-position (+ eww-history-position 2))
  (eww-restore-history (elt eww-history (1- eww-history-position))))

(defun eww-forward-url ()
  "Go to the next displayed page."
  (interactive)
  (when (zerop eww-history-position)
    (user-error "No next page"))
  (eww-save-history)
  (eww-restore-history (elt eww-history (1- eww-history-position))))

(defun eww-restore-history (elem)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (insert (plist-get elem :text))
    (setq eww-current-source (plist-get elem :source))
    (setq eww-current-dom (plist-get elem :dom))
    (goto-char (plist-get elem :point))
    (setq eww-current-url (plist-get elem :url)
	  eww-current-title (plist-get elem :title))
    (eww-update-header-line-format)))

(defun eww-next-url ()
  "Go to the page marked `next'.
A page is marked `next' if rel=\"next\" appears in a <link>
or <a> tag."
  (interactive)
  (if eww-next-url
      (eww-browse-url (shr-expand-url eww-next-url eww-current-url))
    (user-error "No `next' on this page")))

(defun eww-previous-url ()
  "Go to the page marked `previous'.
A page is marked `previous' if rel=\"previous\" appears in a <link>
or <a> tag."
  (interactive)
  (if eww-previous-url
      (eww-browse-url (shr-expand-url eww-previous-url eww-current-url))
    (user-error "No `previous' on this page")))

(defun eww-up-url ()
  "Go to the page marked `up'.
A page is marked `up' if rel=\"up\" appears in a <link>
or <a> tag."
  (interactive)
  (if eww-up-url
      (eww-browse-url (shr-expand-url eww-up-url eww-current-url))
    (user-error "No `up' on this page")))

(defun eww-top-url ()
  "Go to the page marked `top'.
A page is marked `top' if rel=\"start\", rel=\"home\", or rel=\"contents\"
appears in a <link> or <a> tag."
  (interactive)
  (let ((best-url (or eww-start-url
		      eww-contents-url
		      eww-home-url)))
    (if best-url
	(eww-browse-url (shr-expand-url best-url eww-current-url))
      (user-error "No `top' for this page"))))

(defun eww-reload ()
  "Reload the current page."
  (interactive)
  (url-retrieve eww-current-url 'eww-render
		(list eww-current-url (point))))

;; Form support.

(defvar eww-form nil)

(defvar eww-submit-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\r" 'eww-submit)
    (define-key map [(control c) (control c)] 'eww-submit)
    map))

(defvar eww-checkbox-map
  (let ((map (make-sparse-keymap)))
    (define-key map " " 'eww-toggle-checkbox)
    (define-key map "\r" 'eww-toggle-checkbox)
    (define-key map [(control c) (control c)] 'eww-submit)
    map))

(defvar eww-text-map
  (let ((map (make-keymap)))
    (set-keymap-parent map text-mode-map)
    (define-key map "\r" 'eww-submit)
    (define-key map [(control a)] 'eww-beginning-of-text)
    (define-key map [(control c) (control c)] 'eww-submit)
    (define-key map [(control e)] 'eww-end-of-text)
    (define-key map [?\t] 'shr-next-link)
    (define-key map [?\M-\t] 'shr-previous-link)
    map))

(defvar eww-textarea-map
  (let ((map (make-keymap)))
    (set-keymap-parent map text-mode-map)
    (define-key map "\r" 'forward-line)
    (define-key map [(control c) (control c)] 'eww-submit)
    (define-key map [?\t] 'shr-next-link)
    (define-key map [?\M-\t] 'shr-previous-link)
    map))

(defvar eww-select-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\r" 'eww-change-select)
    (define-key map [(control c) (control c)] 'eww-submit)
    map))

(defun eww-beginning-of-text ()
  "Move to the start of the input field."
  (interactive)
  (goto-char (eww-beginning-of-field)))

(defun eww-end-of-text ()
  "Move to the end of the text in the input field."
  (interactive)
  (goto-char (eww-end-of-field))
  (let ((start (eww-beginning-of-field)))
    (while (and (equal (following-char) ? )
		(> (point) start))
      (forward-char -1))
    (when (> (point) start)
      (forward-char 1))))

(defun eww-beginning-of-field ()
  (cond
   ((bobp)
    (point))
   ((not (eq (get-text-property (point) 'eww-form)
	     (get-text-property (1- (point)) 'eww-form)))
    (point))
   (t
    (previous-single-property-change
     (point) 'eww-form nil (point-min)))))

(defun eww-end-of-field ()
  (1- (next-single-property-change
       (point) 'eww-form nil (point-max))))

(defun eww-tag-form (cont)
  (let ((eww-form
	 (list (assq :method cont)
	       (assq :action cont)))
	(start (point)))
    (shr-ensure-paragraph)
    (shr-generic cont)
    (unless (bolp)
      (insert "\n"))
    (insert "\n")
    (when (> (point) start)
      (put-text-property start (1+ start)
			 'eww-form eww-form))))

(defun eww-form-submit (cont)
  (let ((start (point))
	(value (cdr (assq :value cont))))
    (setq value
	  (if (zerop (length value))
	      "Submit"
	    value))
    (insert value)
    (add-face-text-property start (point) 'eww-form-submit)
    (put-text-property start (point) 'eww-form
		       (list :eww-form eww-form
			     :value value
			     :type "submit"
			     :name (cdr (assq :name cont))))
    (put-text-property start (point) 'keymap eww-submit-map)
    (insert " ")))

(defun eww-form-checkbox (cont)
  (let ((start (point)))
    (if (cdr (assq :checked cont))
	(insert eww-form-checkbox-selected-symbol)
      (insert eww-form-checkbox-symbol))
    (add-face-text-property start (point) 'eww-form-checkbox)
    (put-text-property start (point) 'eww-form
		       (list :eww-form eww-form
			     :value (cdr (assq :value cont))
			     :type (downcase (cdr (assq :type cont)))
			     :checked (cdr (assq :checked cont))
			     :name (cdr (assq :name cont))))
    (put-text-property start (point) 'keymap eww-checkbox-map)
    (insert " ")))

(defun eww-form-text (cont)
  (let ((start (point))
	(type (downcase (or (cdr (assq :type cont))
			    "text")))
	(value (or (cdr (assq :value cont)) ""))
	(width (string-to-number
		(or (cdr (assq :size cont))
		    "40")))
        (readonly-property (if (or (cdr (assq :disabled cont))
                                   (cdr (assq :readonly cont)))
                               'read-only
                             'inhibit-read-only)))
    (insert value)
    (when (< (length value) width)
      (insert (make-string (- width (length value)) ? )))
    (put-text-property start (point) 'face 'eww-form-text)
    (put-text-property start (point) 'local-map eww-text-map)
    (put-text-property start (point) readonly-property t)
    (put-text-property start (point) 'eww-form
                       (list :eww-form eww-form
                             :value value
                             :type type
                             :name (cdr (assq :name cont))))
    (insert " ")))

(defconst eww-text-input-types '("text" "password" "textarea"
                                 "color" "date" "datetime" "datetime-local"
                                 "email" "month" "number" "search" "tel"
                                 "time" "url" "week")
  "List of input types which represent a text input.
See URL `https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input'.")

(defun eww-process-text-input (beg end length)
  (let* ((form (get-text-property (min (1+ end) (point-max)) 'eww-form))
	 (properties (text-properties-at end))
	 (type (plist-get form :type)))
    (when (and form
	       (member type eww-text-input-types))
      (cond
       ((zerop length)
	;; Delete some space at the end.
	(save-excursion
	  (goto-char
	   (if (equal type "textarea")
	       (1- (line-end-position))
	     (eww-end-of-field)))
	  (let ((new (- end beg)))
	    (while (and (> new 0)
			(eql (following-char) ? ))
	      (delete-region (point) (1+ (point)))
	      (setq new (1- new))))
	  (set-text-properties beg end properties)))
       ((> length 0)
	;; Add padding.
	(save-excursion
	  (goto-char
	   (if (equal type "textarea")
	       (1- (line-end-position))
	     (eww-end-of-field)))
	  (let ((start (point)))
	    (insert (make-string length ? ))
	    (set-text-properties start (point) properties)))))
      (let ((value (buffer-substring-no-properties
		    (eww-beginning-of-field)
		    (eww-end-of-field))))
	(when (string-match " +\\'" value)
	  (setq value (substring value 0 (match-beginning 0))))
	(plist-put form :value value)
	(when (equal type "password")
	  ;; Display passwords as asterisks.
	  (let ((start (eww-beginning-of-field)))
	    (put-text-property start (+ start (length value))
			       'display (make-string (length value) ?*))))))))

(defun eww-tag-textarea (cont)
  (let ((start (point))
	(value (or (cdr (assq :value cont)) ""))
	(lines (string-to-number
		(or (cdr (assq :rows cont))
		    "10")))
	(width (string-to-number
		(or (cdr (assq :cols cont))
		    "10")))
	end)
    (shr-ensure-newline)
    (insert value)
    (shr-ensure-newline)
    (when (< (count-lines start (point)) lines)
      (dotimes (i (- lines (count-lines start (point))))
	(insert "\n")))
    (setq end (point-marker))
    (goto-char start)
    (while (< (point) end)
      (end-of-line)
      (let ((pad (- width (- (point) (line-beginning-position)))))
	(when (> pad 0)
	  (insert (make-string pad ? ))))
      (add-face-text-property (line-beginning-position)
			      (point) 'eww-form-textarea)
      (put-text-property (line-beginning-position) (point)
			 'local-map eww-textarea-map)
      (forward-line 1))
    (put-text-property start (point) 'eww-form
		       (list :eww-form eww-form
			     :value value
			     :type "textarea"
			     :name (cdr (assq :name cont))))))

(defun eww-tag-input (cont)
  (let ((type (downcase (or (cdr (assq :type cont))
			     "text")))
	(start (point)))
    (cond
     ((or (equal type "checkbox")
	  (equal type "radio"))
      (eww-form-checkbox cont))
     ((equal type "submit")
      (eww-form-submit cont))
     ((equal type "hidden")
      (let ((form eww-form)
	    (name (cdr (assq :name cont))))
	;; Don't add <input type=hidden> elements repeatedly.
	(while (and form
		    (or (not (consp (car form)))
			(not (eq (caar form) 'hidden))
			(not (equal (plist-get (cdr (car form)) :name)
				    name))))
	  (setq form (cdr form)))
	(unless form
	  (nconc eww-form (list
			   (list 'hidden
				 :name name
				 :value (cdr (assq :value cont))))))))
     (t
      (eww-form-text cont)))
    (unless (= start (point))
      (put-text-property start (1+ start) 'help-echo "Input field"))))

(defun eww-tag-select (cont)
  (shr-ensure-paragraph)
  (let ((menu (list :name (cdr (assq :name cont))
		    :eww-form eww-form))
	(options nil)
	(start (point))
	(max 0)
	opelem)
    (if (eq (car (car cont)) 'optgroup)
	(dolist (groupelem cont)
	  (unless (cdr (assq :disabled (cdr groupelem)))
	    (setq opelem (append opelem (cdr (cdr groupelem))))))
      (setq opelem cont))
    (dolist (elem opelem)
      (when (eq (car elem) 'option)
	(when (cdr (assq :selected (cdr elem)))
	  (nconc menu (list :value
			    (cdr (assq :value (cdr elem))))))
	(let ((display (or (cdr (assq 'text (cdr elem))) "")))
	  (setq max (max max (length display)))
	  (push (list 'item
		      :value (cdr (assq :value (cdr elem)))
		      :display display)
		options))))
    (when options
      (setq options (nreverse options))
      ;; If we have no selected values, default to the first value.
      (unless (plist-get menu :value)
	(nconc menu (list :value (nth 2 (car options)))))
      (nconc menu options)
      (let ((selected (eww-select-display menu)))
	(insert selected
		(make-string (- max (length selected)) ? )))
      (put-text-property start (point) 'eww-form menu)
      (add-face-text-property start (point) 'eww-form-select)
      (put-text-property start (point) 'keymap eww-select-map)
      (unless (= start (point))
       (put-text-property start (1+ start) 'help-echo "select field"))
      (shr-ensure-paragraph))))

(defun eww-select-display (select)
  (let ((value (plist-get select :value))
	display)
    (dolist (elem select)
      (when (and (consp elem)
		 (eq (car elem) 'item)
		 (equal value (plist-get (cdr elem) :value)))
	(setq display (plist-get (cdr elem) :display))))
    display))

(defun eww-change-select ()
  "Change the value of the select drop-down menu under point."
  (interactive)
  (let* ((input (get-text-property (point) 'eww-form))
	 (completion-ignore-case t)
	 (options
	  (delq nil
		(mapcar (lambda (elem)
			  (and (consp elem)
			       (eq (car elem) 'item)
			       (cons (plist-get (cdr elem) :display)
				     (plist-get (cdr elem) :value))))
			input)))
	 (display
	  (completing-read "Change value: " options nil 'require-match))
	 (inhibit-read-only t))
    (plist-put input :value (cdr (assoc-string display options t)))
    (goto-char
     (eww-update-field display))))

(defun eww-update-field (string)
  (let ((properties (text-properties-at (point)))
	(start (eww-beginning-of-field))
	(end (1+ (eww-end-of-field))))
    (delete-region start end)
    (insert string
	    (make-string (- (- end start) (length string)) ? ))
    (set-text-properties start end properties)
    start))

(defun eww-toggle-checkbox ()
  "Toggle the value of the checkbox under point."
  (interactive)
  (let* ((input (get-text-property (point) 'eww-form))
	 (type (plist-get input :type)))
    (if (equal type "checkbox")
	(goto-char
	 (1+
	  (if (plist-get input :checked)
	      (progn
		(plist-put input :checked nil)
		(eww-update-field eww-form-checkbox-symbol))
	    (plist-put input :checked t)
	    (eww-update-field eww-form-checkbox-selected-symbol))))
      ;; Radio button.  Switch all other buttons off.
      (let ((name (plist-get input :name)))
	(save-excursion
	  (dolist (elem (eww-inputs (plist-get input :eww-form)))
	    (when (equal (plist-get (cdr elem) :name) name)
	      (goto-char (car elem))
	      (if (not (eq (cdr elem) input))
		  (progn
		    (plist-put input :checked nil)
		    (eww-update-field eww-form-checkbox-symbol))
		(plist-put input :checked t)
		(eww-update-field eww-form-checkbox-selected-symbol)))))
	(forward-char 1)))))

(defun eww-inputs (form)
  (let ((start (point-min))
	(inputs nil))
    (while (and start
		(< start (point-max)))
      (when (or (get-text-property start 'eww-form)
		(setq start (next-single-property-change start 'eww-form)))
	(when (eq (plist-get (get-text-property start 'eww-form) :eww-form)
		  form)
	  (push (cons start (get-text-property start 'eww-form))
		inputs))
	(setq start (next-single-property-change start 'eww-form))))
    (nreverse inputs)))

(defun eww-input-value (input)
  (let ((type (plist-get input :type))
	(value (plist-get input :value)))
    (cond
     ((equal type "textarea")
      (with-temp-buffer
	(insert value)
	(goto-char (point-min))
	(while (re-search-forward "^ +\n\\| +$" nil t)
	  (replace-match "" t t))
	(buffer-string)))
     (t
      (if (string-match " +\\'" value)
	  (substring value 0 (match-beginning 0))
	value)))))

(defun eww-submit ()
  "Submit the current form."
  (interactive)
  (let* ((this-input (get-text-property (point) 'eww-form))
	 (form (plist-get this-input :eww-form))
	 values next-submit)
    (dolist (elem (sort (eww-inputs form)
			 (lambda (o1 o2)
			   (< (car o1) (car o2)))))
      (let* ((input (cdr elem))
	     (input-start (car elem))
	     (name (plist-get input :name)))
	(when name
	  (cond
	   ((member (plist-get input :type) '("checkbox" "radio"))
	    (when (plist-get input :checked)
	      (push (cons name (plist-get input :value))
		    values)))
	   ((equal (plist-get input :type) "submit")
	    ;; We want the values from buttons if we hit a button if
	    ;; we hit enter on it, or if it's the first button after
	    ;; the field we did hit return on.
	    (when (or (eq input this-input)
		      (and (not (eq input this-input))
			   (null next-submit)
			   (> input-start (point))))
	      (setq next-submit t)
	      (push (cons name (plist-get input :value))
		    values)))
	   (t
	    (push (cons name (eww-input-value input))
		  values))))))
    (dolist (elem form)
      (when (and (consp elem)
		 (eq (car elem) 'hidden))
	(push (cons (plist-get (cdr elem) :name)
		    (plist-get (cdr elem) :value))
	      values)))
    (if (and (stringp (cdr (assq :method form)))
	     (equal (downcase (cdr (assq :method form))) "post"))
	(let ((url-request-method "POST")
	      (url-request-extra-headers
	       '(("Content-Type" . "application/x-www-form-urlencoded")))
	      (url-request-data (mm-url-encode-www-form-urlencoded values)))
	  (eww-browse-url (shr-expand-url (cdr (assq :action form))
					  eww-current-url)))
      (eww-browse-url
       (concat
	(if (cdr (assq :action form))
	    (shr-expand-url (cdr (assq :action form))
			    eww-current-url)
	  eww-current-url)
	"?"
	(mm-url-encode-www-form-urlencoded values))))))

(defun eww-browse-with-external-browser (&optional url)
  "Browse the current URL with an external browser.
The browser to used is specified by the `shr-external-browser' variable."
  (interactive)
  (funcall shr-external-browser (or url eww-current-url)))

(defun eww-follow-link (&optional external mouse-event)
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
     (external
      (funcall shr-external-browser url))
     ;; This is a #target url in the same page as the current one.
     ((and (url-target (url-generic-parse-url url))
	   (eww-same-page-p url eww-current-url))
      (eww-save-history)
      (eww-display-html 'utf8 url eww-current-dom))
     (t
      (eww-browse-url url)))))

(defun eww-same-page-p (url1 url2)
  "Return non-nil if both URLs represent the same page.
Differences in #targets are ignored."
  (let ((obj1 (url-generic-parse-url url1))
	(obj2 (url-generic-parse-url url2)))
    (setf (url-target obj1) nil)
    (setf (url-target obj2) nil)
    (equal (url-recreate-url obj1) (url-recreate-url obj2))))

(defun eww-copy-page-url ()
  (interactive)
  (message "%s" eww-current-url)
  (kill-new eww-current-url))

(defun eww-download ()
  "Download URL under point to `eww-download-directory'."
  (interactive)
  (let ((url (get-text-property (point) 'shr-url)))
    (if (not url)
        (message "No URL under point")
      (url-retrieve url 'eww-download-callback (list url)))))

(defun eww-download-callback (status url)
  (unless (plist-get status :error)
    (let* ((obj (url-generic-parse-url url))
           (path (car (url-path-and-query obj)))
           (file (eww-make-unique-file-name (file-name-nondirectory path)
					    eww-download-directory)))
      (write-file file)
      (message "Saved %s" file))))

(defun eww-make-unique-file-name (file directory)
    (cond
     ((zerop (length file))
      (setq file "!"))
     ((string-match "\\`[.]" file)
      (setq file (concat "!" file))))
    (let ((count 1))
      (while (file-exists-p (expand-file-name file directory))
	(setq file
	      (if (string-match "\\`\\(.*\\)\\([.][^.]+\\)" file)
		  (format "%s(%d)%s" (match-string 1 file)
			  count (match-string 2 file))
		(format "%s(%d)" file count)))
	(setq count (1+ count)))
      (expand-file-name file directory)))

;;; Bookmarks code

(defvar eww-bookmarks nil)

(defun eww-add-bookmark ()
  "Add the current page to the bookmarks."
  (interactive)
  (eww-read-bookmarks)
  (dolist (bookmark eww-bookmarks)
    (when (equal eww-current-url
		 (plist-get bookmark :url))
      (user-error "Already bookmarked")))
  (if (y-or-n-p "bookmark this page? ")
      (progn
	(let ((title (replace-regexp-in-string "[\n\t\r]" " " eww-current-title)))
	  (setq title (replace-regexp-in-string "\\` +\\| +\\'" "" title))
	  (push (list :url eww-current-url
		      :title title
		      :time (current-time-string))
		eww-bookmarks))
	(eww-write-bookmarks)
	(message "Bookmarked %s (%s)" eww-current-url eww-current-title))))

(defun eww-write-bookmarks ()
  (with-temp-file (expand-file-name "eww-bookmarks" user-emacs-directory)
    (insert ";; Auto-generated file; don't edit\n")
    (pp eww-bookmarks (current-buffer))))

(defun eww-read-bookmarks ()
  (let ((file (expand-file-name "eww-bookmarks" user-emacs-directory)))
    (setq eww-bookmarks
	  (unless (zerop (or (nth 7 (file-attributes file)) 0))
	    (with-temp-buffer
	      (insert-file-contents file)
	      (read (current-buffer)))))))

(defun eww-list-bookmarks ()
  "Display the bookmarks."
  (interactive)
  (eww-bookmark-prepare)
  (pop-to-buffer "*eww bookmarks*"))

(defun eww-bookmark-prepare ()
  (eww-read-bookmarks)
  (unless eww-bookmarks
    (user-error "No bookmarks are defined"))
  (set-buffer (get-buffer-create "*eww bookmarks*"))
  (eww-bookmark-mode)
  (let ((format "%-40s %s")
	(inhibit-read-only t)
	start url)
    (erase-buffer)
    (setq header-line-format (concat " " (format format "URL" "Title")))
    (dolist (bookmark eww-bookmarks)
      (setq start (point))
      (setq url (plist-get bookmark :url))
      (when (> (length url) 40)
	(setq url (substring url 0 40)))
      (insert (format format url
		      (plist-get bookmark :title))
	      "\n")
      (put-text-property start (1+ start) 'eww-bookmark bookmark))
    (goto-char (point-min))))

(defvar eww-bookmark-kill-ring nil)

(defun eww-bookmark-kill ()
  "Kill the current bookmark."
  (interactive)
  (let* ((start (line-beginning-position))
	 (bookmark (get-text-property start 'eww-bookmark))
	 (inhibit-read-only t))
    (unless bookmark
      (user-error "No bookmark on the current line"))
    (forward-line 1)
    (push (buffer-substring start (point)) eww-bookmark-kill-ring)
    (delete-region start (point))
    (setq eww-bookmarks (delq bookmark eww-bookmarks))
    (eww-write-bookmarks)))

(defun eww-bookmark-yank ()
  "Yank a previously killed bookmark to the current line."
  (interactive)
  (unless eww-bookmark-kill-ring
    (user-error "No previously killed bookmark"))
  (beginning-of-line)
  (let ((inhibit-read-only t)
	(start (point))
	bookmark)
    (insert (pop eww-bookmark-kill-ring))
    (setq bookmark (get-text-property start 'eww-bookmark))
    (if (= start (point-min))
	(push bookmark eww-bookmarks)
      (let ((line (count-lines start (point))))
	(setcdr (nthcdr (1- line) eww-bookmarks)
		(cons bookmark (nthcdr line eww-bookmarks)))))
    (eww-write-bookmarks)))

(defun eww-bookmark-browse ()
  "Browse the bookmark under point in eww."
  (interactive)
  (let ((bookmark (get-text-property (line-beginning-position) 'eww-bookmark)))
    (unless bookmark
      (user-error "No bookmark on the current line"))
    (quit-window)
    (eww-browse-url (plist-get bookmark :url))))

(defun eww-next-bookmark ()
  "Go to the next bookmark in the list."
  (interactive)
  (let ((first nil)
	bookmark)
    (unless (get-buffer "*eww bookmarks*")
      (setq first t)
      (eww-bookmark-prepare))
    (with-current-buffer (get-buffer "*eww bookmarks*")
      (when (and (not first)
		 (not (eobp)))
	(forward-line 1))
      (setq bookmark (get-text-property (line-beginning-position)
					'eww-bookmark))
      (unless bookmark
	(user-error "No next bookmark")))
    (eww-browse-url (plist-get bookmark :url))))

(defun eww-previous-bookmark ()
  "Go to the previous bookmark in the list."
  (interactive)
  (let ((first nil)
	bookmark)
    (unless (get-buffer "*eww bookmarks*")
      (setq first t)
      (eww-bookmark-prepare))
    (with-current-buffer (get-buffer "*eww bookmarks*")
      (if first
	  (goto-char (point-max))
	(beginning-of-line))
      ;; On the final line.
      (when (eolp)
	(forward-line -1))
      (if (bobp)
	  (user-error "No previous bookmark")
	(forward-line -1))
      (setq bookmark (get-text-property (line-beginning-position)
					'eww-bookmark)))
    (eww-browse-url (plist-get bookmark :url))))

(defvar eww-bookmark-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map "q" 'quit-window)
    (define-key map [(control k)] 'eww-bookmark-kill)
    (define-key map [(control y)] 'eww-bookmark-yank)
    (define-key map "\r" 'eww-bookmark-browse)

    (easy-menu-define nil map
      "Menu for `eww-bookmark-mode-map'."
      '("Eww Bookmark"
        ["Exit" quit-window t]
        ["Browse" eww-bookmark-browse
         :active (get-text-property (line-beginning-position) 'eww-bookmark)]
        ["Kill" eww-bookmark-kill
         :active (get-text-property (line-beginning-position) 'eww-bookmark)]
        ["Yank" eww-bookmark-yank
         :active eww-bookmark-kill-ring]))
    map))

(define-derived-mode eww-bookmark-mode nil "eww bookmarks"
  "Mode for listing bookmarks.

\\{eww-bookmark-mode-map}"
  (buffer-disable-undo)
  (setq buffer-read-only t
	truncate-lines t))

;;; History code

(defun eww-save-history ()
  (push (list :url eww-current-url
              :title eww-current-title
              :point (point)
              :dom eww-current-dom
              :source eww-current-source
              :text (buffer-string))
        eww-history))

(defun eww-list-histories ()
  "List the eww-histories."
  (interactive)
  (when (null eww-history)
    (error "No eww-histories are defined"))
  (let ((eww-history-trans eww-history))
    (set-buffer (get-buffer-create "*eww history*"))
    (eww-history-mode)
    (let ((inhibit-read-only t)
	  (domain-length 0)
	  (title-length 0)
	  url title format start)
      (erase-buffer)
      (dolist (history eww-history-trans)
	(setq start (point))
	(setq domain-length (max domain-length (length (plist-get history :url))))
	(setq title-length (max title-length (length (plist-get history :title)))))
      (setq format (format "%%-%ds %%-%ds" title-length domain-length)
	    header-line-format
	    (concat " " (format format "Title" "URL")))
      (dolist (history eww-history-trans)
	(setq start (point))
	(setq url (plist-get history :url))
	(setq title (plist-get history :title))
	(insert (format format title url))
	(insert "\n")
	(put-text-property start (1+ start) 'eww-history history))
      (goto-char (point-min)))
    (pop-to-buffer "*eww history*")))

(defun eww-history-browse ()
  "Browse the history under point in eww."
  (interactive)
  (let ((history (get-text-property (line-beginning-position) 'eww-history)))
    (unless history
      (error "No history on the current line"))
    (quit-window)
    (eww-restore-history history)))

(defvar eww-history-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map "q" 'quit-window)
    (define-key map "\r" 'eww-history-browse)
;;    (define-key map "n" 'next-error-no-select)
;;    (define-key map "p" 'previous-error-no-select)

    (easy-menu-define nil map
      "Menu for `eww-history-mode-map'."
      '("Eww History"
        ["Exit" quit-window t]
        ["Browse" eww-history-browse
         :active (get-text-property (line-beginning-position) 'eww-history)]))
    map))

(define-derived-mode eww-history-mode nil "eww history"
  "Mode for listing eww-histories.

\\{eww-history-mode-map}"
  (buffer-disable-undo)
  (setq buffer-read-only t
	truncate-lines t))

(provide 'eww)

;;; eww.el ends here
