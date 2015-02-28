;;; profiler.el --- UI and helper functions for Emacs's native profiler -*- lexical-binding: t -*-

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Tomohiro Matsuyama <tomo@cx4a.org>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See Info node `(elisp)Profiling'.

;;; Code:

(require 'cl-lib)

(defgroup profiler nil
  "Emacs profiler."
  :group 'lisp
  :version "24.3"
  :prefix "profiler-")

(defconst profiler-version "24.3")

(defcustom profiler-sampling-interval 1000000
  "Default sampling interval in nanoseconds."
  :type 'integer
  :group 'profiler)


;;; Utilities

(defun profiler-ensure-string (object)
  (cond ((stringp object)
	 object)
	((symbolp object)
	 (symbol-name object))
	((numberp object)
	 (number-to-string object))
	(t
	 (format "%s" object))))

(defun profiler-format-percent (number divisor)
  (concat (number-to-string (/ (* number 100) divisor)) "%"))

(defun profiler-format-number (number)
  "Format NUMBER in human readable string."
  (if (and (integerp number) (> number 0))
      (cl-loop with i = (% (1+ (floor (log10 number))) 3)
	       for c in (append (number-to-string number) nil)
	       if (= i 0)
	       collect ?, into s
	       and do (setq i 3)
	       collect c into s
	       do (cl-decf i)
	       finally return
	       (apply 'string (if (eq (car s) ?,) (cdr s) s)))
    (profiler-ensure-string number)))

(defun profiler-format (fmt &rest args)
  (cl-loop for (width align subfmt) in fmt
	   for arg in args
	   for str = (cond
		      ((consp subfmt)
		       (apply 'profiler-format subfmt arg))
		      ((stringp subfmt)
		       (format subfmt arg))
		      ((and (symbolp subfmt)
			    (fboundp subfmt))
		       (funcall subfmt arg))
		      (t
		       (profiler-ensure-string arg)))
	   for len = (length str)
	   if (< width len)
	   collect (substring str 0 width) into frags
	   else
	   collect
	   (let ((padding (make-string (- width len) ?\s)))
	     (cl-ecase align
	       (left (concat str padding))
	       (right (concat padding str))))
	   into frags
	   finally return (apply #'concat frags)))


;;; Entries

(defun profiler-format-entry (entry)
  "Format ENTRY in human readable string.  ENTRY would be a
function name of a function itself."
  (cond ((memq (car-safe entry) '(closure lambda))
	 (format "#<lambda 0x%x>" (sxhash entry)))
	((byte-code-function-p entry)
	 (format "#<compiled 0x%x>" (sxhash entry)))
	((or (subrp entry) (symbolp entry) (stringp entry))
	 (format "%s" entry))
	(t
	 (format "#<unknown 0x%x>" (sxhash entry)))))

(defun profiler-fixup-entry (entry)
  (if (symbolp entry)
      entry
    (profiler-format-entry entry)))


;;; Backtraces

(defun profiler-fixup-backtrace (backtrace)
  (apply 'vector (mapcar 'profiler-fixup-entry backtrace)))


;;; Logs

;; The C code returns the log in the form of a hash-table where the keys are
;; vectors (of size profiler-max-stack-depth, holding truncated
;; backtraces, where the first element is the top of the stack) and
;; the values are integers (which count how many times this backtrace
;; has been seen, multiplied by a "weight factor" which is either the
;; sampling-interval or the memory being allocated).

(defun profiler-compare-logs (log1 log2)
  "Compare LOG1 with LOG2 and return diff."
  (let ((newlog (make-hash-table :test 'equal)))
    ;; Make a copy of `log1' into `newlog'.
    (maphash (lambda (backtrace count) (puthash backtrace count newlog))
             log1)
    (maphash (lambda (backtrace count)
               (puthash backtrace (- (gethash backtrace log1 0) count)
                        newlog))
             log2)
    newlog))

(defun profiler-fixup-log (log)
  (let ((newlog (make-hash-table :test 'equal)))
    (maphash (lambda (backtrace count)
               (puthash (profiler-fixup-backtrace backtrace)
                        count newlog))
             log)
    newlog))


;;; Profiles

(cl-defstruct (profiler-profile (:type vector)
                                (:constructor profiler-make-profile))
  (tag 'profiler-profile)
  (version profiler-version)
  ;; - `type' has a value indicating the kind of profile (`memory' or `cpu').
  ;; - `log' indicates the profile log.
  ;; - `timestamp' has a value giving the time when the profile was obtained.
  ;; - `diff-p' indicates if this profile represents a diff between two profiles.
  type log timestamp diff-p)

(defun profiler-compare-profiles (profile1 profile2)
  "Compare PROFILE1 with PROFILE2 and return diff."
  (unless (eq (profiler-profile-type profile1)
	      (profiler-profile-type profile2))
    (error "Can't compare different type of profiles"))
  (profiler-make-profile
   :type (profiler-profile-type profile1)
   :timestamp (current-time)
   :diff-p t
   :log (profiler-compare-logs
         (profiler-profile-log profile1)
         (profiler-profile-log profile2))))

(defun profiler-fixup-profile (profile)
  "Fixup PROFILE so that the profile could be serialized into file."
  (profiler-make-profile
   :type (profiler-profile-type profile)
   :timestamp (profiler-profile-timestamp profile)
   :diff-p (profiler-profile-diff-p profile)
   :log (profiler-fixup-log (profiler-profile-log profile))))

(defun profiler-write-profile (profile filename &optional confirm)
  "Write PROFILE into file FILENAME."
  (with-temp-buffer
    (let (print-level print-length)
      (print (profiler-fixup-profile profile)
             (current-buffer)))
    (write-file filename confirm)))

(defun profiler-read-profile (filename)
  "Read profile from file FILENAME."
  ;; FIXME: tag and version check
  (with-temp-buffer
    (insert-file-contents filename)
    (goto-char (point-min))
    (read (current-buffer))))

(defun profiler-cpu-profile ()
  "Return CPU profile."
  (when (and (fboundp 'profiler-cpu-running-p)
             (fboundp 'profiler-cpu-log)
             (profiler-cpu-running-p))
    (profiler-make-profile
     :type 'cpu
     :timestamp (current-time)
     :log (profiler-cpu-log))))

(defun profiler-memory-profile ()
  "Return memory profile."
  (when (profiler-memory-running-p)
    (profiler-make-profile
     :type 'memory
     :timestamp (current-time)
     :log (profiler-memory-log))))


;;; Calltrees

(cl-defstruct (profiler-calltree (:constructor profiler-make-calltree))
  entry
  (count 0) (count-percent "")
  parent children)

(defun profiler-calltree-leaf-p (tree)
  (null (profiler-calltree-children tree)))

(defun profiler-calltree-count< (a b)
  (cond ((eq (profiler-calltree-entry a) t) t)
	((eq (profiler-calltree-entry b) t) nil)
	(t (< (profiler-calltree-count a)
	      (profiler-calltree-count b)))))

(defun profiler-calltree-count> (a b)
  (not (profiler-calltree-count< a b)))

(defun profiler-calltree-depth (tree)
  (let ((parent (profiler-calltree-parent tree)))
    (if (null parent)
	0
      (1+ (profiler-calltree-depth parent)))))

(defun profiler-calltree-find (tree entry)
  "Return a child tree of ENTRY under TREE."
  (let (result (children (profiler-calltree-children tree)))
    ;; FIXME: Use `assoc'.
    (while (and children (null result))
      (let ((child (car children)))
	(when (equal (profiler-calltree-entry child) entry)
	  (setq result child))
	(setq children (cdr children))))
    result))

(defun profiler-calltree-walk (calltree function)
  (funcall function calltree)
  (dolist (child (profiler-calltree-children calltree))
    (profiler-calltree-walk child function)))

(defun profiler-calltree-build-1 (tree log &optional reverse)
  ;; FIXME: Do a better job of reconstructing a complete call-tree
  ;; when the backtraces have been truncated.  Ideally, we should be
  ;; able to reduce profiler-max-stack-depth to 3 or 4 and still
  ;; get a meaningful call-tree.
  (maphash
   (lambda (backtrace count)
     (let ((node tree)
           (max (length backtrace)))
       (dotimes (i max)
         (let ((entry (aref backtrace (if reverse i (- max i 1)))))
           (when entry
             (let ((child (profiler-calltree-find node entry)))
               (unless child
                 (setq child (profiler-make-calltree
                              :entry entry :parent node))
                 (push child (profiler-calltree-children node)))
               (cl-incf (profiler-calltree-count child) count)
               (setq node child)))))))
   log))

(defun profiler-calltree-compute-percentages (tree)
  (let ((total-count 0))
    ;; FIXME: the memory profiler's total wraps around all too easily!
    (dolist (child (profiler-calltree-children tree))
      (cl-incf total-count (profiler-calltree-count child)))
    (unless (zerop total-count)
      (profiler-calltree-walk
       tree (lambda (node)
              (setf (profiler-calltree-count-percent node)
                    (profiler-format-percent (profiler-calltree-count node)
                                             total-count)))))))

(cl-defun profiler-calltree-build (log &key reverse)
  (let ((tree (profiler-make-calltree)))
    (profiler-calltree-build-1 tree log reverse)
    (profiler-calltree-compute-percentages tree)
    tree))

(defun profiler-calltree-sort (tree predicate)
  (let ((children (profiler-calltree-children tree)))
    (setf (profiler-calltree-children tree) (sort children predicate))
    (dolist (child (profiler-calltree-children tree))
      (profiler-calltree-sort child predicate))))


;;; Report rendering

(defcustom profiler-report-closed-mark "+"
  "An indicator of closed calltrees."
  :type 'string
  :group 'profiler)

(defcustom profiler-report-open-mark "-"
  "An indicator of open calltrees."
  :type 'string
  :group 'profiler)

(defcustom profiler-report-leaf-mark " "
  "An indicator of calltree leaves."
  :type 'string
  :group 'profiler)

(defvar profiler-report-cpu-line-format
  '((50 left)
    (24 right ((19 right)
	       (5 right)))))

(defvar profiler-report-memory-line-format
  '((55 left)
    (19 right ((14 right profiler-format-number)
	       (5 right)))))

(defvar-local profiler-report-profile nil
  "The current profile.")

(defvar-local profiler-report-reversed nil
  "True if calltree is rendered in bottom-up.  Do not touch this
variable directly.")

(defvar-local profiler-report-order nil
  "The value can be `ascending' or `descending'.  Do not touch
this variable directly.")

(defun profiler-report-make-entry-part (entry)
  (let ((string (cond
		 ((eq entry t)
		  "Others")
		 ((and (symbolp entry)
		       (fboundp entry))
		  (propertize (symbol-name entry)
			      'face 'link
			      'mouse-face 'highlight
			      'help-echo "\
mouse-2: jump to definition\n\
RET: expand or collapse"))
		 (t
		  (profiler-format-entry entry)))))
    (propertize string 'profiler-entry entry)))

(defun profiler-report-make-name-part (tree)
  (let* ((entry (profiler-calltree-entry tree))
	 (depth (profiler-calltree-depth tree))
	 (indent (make-string (* (1- depth) 2) ?\s))
	 (mark (if (profiler-calltree-leaf-p tree)
		   profiler-report-leaf-mark
		 profiler-report-closed-mark))
	 (entry (profiler-report-make-entry-part entry)))
    (format "%s%s %s" indent mark entry)))

(defun profiler-report-header-line-format (fmt &rest args)
  (let* ((header (apply 'profiler-format fmt args))
	 (escaped (replace-regexp-in-string "%" "%%" header)))
    (concat " " escaped)))

(defun profiler-report-line-format (tree)
  (let ((diff-p (profiler-profile-diff-p profiler-report-profile))
	(name-part (profiler-report-make-name-part tree))
	(count (profiler-calltree-count tree))
	(count-percent (profiler-calltree-count-percent tree)))
    (profiler-format (cl-ecase (profiler-profile-type profiler-report-profile)
		       (cpu profiler-report-cpu-line-format)
		       (memory profiler-report-memory-line-format))
		     name-part
		     (if diff-p
			 (list (if (> count 0)
				   (format "+%s" count)
				 count)
			       "")
		       (list count count-percent)))))

(defun profiler-report-insert-calltree (tree)
  (let ((line (profiler-report-line-format tree)))
    (insert (propertize (concat line "\n") 'calltree tree))))

(defun profiler-report-insert-calltree-children (tree)
  (mapc 'profiler-report-insert-calltree
	(profiler-calltree-children tree)))


;;; Report mode

(defvar profiler-report-mode-map
  (let ((map (make-sparse-keymap)))
    ;; FIXME: Add menu.
    (define-key map "n"	    'profiler-report-next-entry)
    (define-key map "p"	    'profiler-report-previous-entry)
    ;; I find it annoying more than helpful to not be able to navigate
    ;; normally with the cursor keys.  --Stef
    ;; (define-key map [down]  'profiler-report-next-entry)
    ;; (define-key map [up]    'profiler-report-previous-entry)
    (define-key map "\r"    'profiler-report-toggle-entry)
    (define-key map "\t"    'profiler-report-toggle-entry)
    (define-key map "i"     'profiler-report-toggle-entry)
    (define-key map "f"     'profiler-report-find-entry)
    (define-key map "j"     'profiler-report-find-entry)
    (define-key map [mouse-2] 'profiler-report-find-entry)
    (define-key map "d"	    'profiler-report-describe-entry)
    (define-key map "C"	    'profiler-report-render-calltree)
    (define-key map "B"	    'profiler-report-render-reversed-calltree)
    (define-key map "A"	    'profiler-report-ascending-sort)
    (define-key map "D"	    'profiler-report-descending-sort)
    (define-key map "="	    'profiler-report-compare-profile)
    (define-key map (kbd "C-x C-w") 'profiler-report-write-profile)
    (define-key map "q"     'quit-window)
    map))

(defun profiler-report-make-buffer-name (profile)
  (format "*%s-Profiler-Report %s*"
          (cl-ecase (profiler-profile-type profile) (cpu 'CPU) (memory 'Memory))
          (format-time-string "%Y-%m-%d %T" (profiler-profile-timestamp profile))))

(defun profiler-report-setup-buffer-1 (profile)
  "Make a buffer for PROFILE and return it."
  (let* ((buf-name (profiler-report-make-buffer-name profile))
	 (buffer (get-buffer-create buf-name)))
    (with-current-buffer buffer
      (profiler-report-mode)
      (setq profiler-report-profile profile
	    profiler-report-reversed nil
	    profiler-report-order 'descending))
    buffer))

(defun profiler-report-setup-buffer (profile)
  "Make a buffer for PROFILE with rendering the profile and
return it."
  (let ((buffer (profiler-report-setup-buffer-1 profile)))
    (with-current-buffer buffer
      (profiler-report-render-calltree))
    buffer))

(define-derived-mode profiler-report-mode special-mode "Profiler-Report"
  "Profiler Report Mode."
  (setq buffer-read-only t
	buffer-undo-list t
	truncate-lines t))


;;; Report commands

(defun profiler-report-calltree-at-point (&optional point)
  (get-text-property (or point (point)) 'calltree))

(defun profiler-report-move-to-entry ()
  (let ((point (next-single-property-change
                (line-beginning-position) 'profiler-entry)))
    (if point
	(goto-char point)
      (back-to-indentation))))

(defun profiler-report-next-entry ()
  "Move cursor to next entry."
  (interactive)
  (forward-line)
  (profiler-report-move-to-entry))

(defun profiler-report-previous-entry ()
  "Move cursor to previous entry."
  (interactive)
  (forward-line -1)
  (profiler-report-move-to-entry))

(defun profiler-report-expand-entry ()
  "Expand entry at point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (when (search-forward (concat profiler-report-closed-mark " ")
			  (line-end-position) t)
      (let ((tree (profiler-report-calltree-at-point)))
	(when tree
	  (let ((inhibit-read-only t))
	    (replace-match (concat profiler-report-open-mark " "))
	    (forward-line)
	    (profiler-report-insert-calltree-children tree)
	    t))))))

(defun profiler-report-collapse-entry ()
  "Collapse entry at point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (when (search-forward (concat profiler-report-open-mark " ")
			  (line-end-position) t)
      (let* ((tree (profiler-report-calltree-at-point))
	     (depth (profiler-calltree-depth tree))
	     (start (line-beginning-position 2))
	     d)
	(when tree
	  (let ((inhibit-read-only t))
	    (replace-match (concat profiler-report-closed-mark " "))
	    (while (and (eq (forward-line) 0)
			(let ((child (get-text-property (point) 'calltree)))
			  (and child
			       (numberp (setq d (profiler-calltree-depth child)))))
			(> d depth)))
	    (delete-region start (line-beginning-position)))))
      t)))

(defun profiler-report-toggle-entry ()
  "Expand entry at point if the tree is collapsed,
otherwise collapse."
  (interactive)
  (or (profiler-report-expand-entry)
      (profiler-report-collapse-entry)))

(defun profiler-report-find-entry (&optional event)
  "Find entry at point."
  (interactive (list last-nonmenu-event))
  (if event (posn-set-point (event-end event)))
  (let ((tree (profiler-report-calltree-at-point)))
    (when tree
      (let ((entry (profiler-calltree-entry tree)))
	(find-function entry)))))

(defun profiler-report-describe-entry ()
  "Describe entry at point."
  (interactive)
  (let ((tree (profiler-report-calltree-at-point)))
    (when tree
      (let ((entry (profiler-calltree-entry tree)))
	(require 'help-fns)
	(describe-function entry)))))

(cl-defun profiler-report-render-calltree-1
    (profile &key reverse (order 'descending))
  (let ((calltree (profiler-calltree-build
                   (profiler-profile-log profile)
                   :reverse reverse)))
    (setq header-line-format
	  (cl-ecase (profiler-profile-type profile)
	    (cpu
	     (profiler-report-header-line-format
	      profiler-report-cpu-line-format
	      "Function" (list "CPU samples" "%")))
	    (memory
	     (profiler-report-header-line-format
	      profiler-report-memory-line-format
	      "Function" (list "Bytes" "%")))))
    (let ((predicate (cl-ecase order
		       (ascending #'profiler-calltree-count<)
		       (descending #'profiler-calltree-count>))))
      (profiler-calltree-sort calltree predicate))
    (let ((inhibit-read-only t))
      (erase-buffer)
      (profiler-report-insert-calltree-children calltree)
      (goto-char (point-min))
      (profiler-report-move-to-entry))))

(defun profiler-report-rerender-calltree ()
  (profiler-report-render-calltree-1 profiler-report-profile
				     :reverse profiler-report-reversed
				     :order profiler-report-order))

(defun profiler-report-render-calltree ()
  "Render calltree view."
  (interactive)
  (setq profiler-report-reversed nil)
  (profiler-report-rerender-calltree))

(defun profiler-report-render-reversed-calltree ()
  "Render reversed calltree view."
  (interactive)
  (setq profiler-report-reversed t)
  (profiler-report-rerender-calltree))

(defun profiler-report-ascending-sort ()
  "Sort calltree view in ascending order."
  (interactive)
  (setq profiler-report-order 'ascending)
  (profiler-report-rerender-calltree))

(defun profiler-report-descending-sort ()
  "Sort calltree view in descending order."
  (interactive)
  (setq profiler-report-order 'descending)
  (profiler-report-rerender-calltree))

(defun profiler-report-profile (profile)
  (switch-to-buffer (profiler-report-setup-buffer profile)))

(defun profiler-report-profile-other-window (profile)
  (switch-to-buffer-other-window (profiler-report-setup-buffer profile)))

(defun profiler-report-profile-other-frame (profile)
  (switch-to-buffer-other-frame (profiler-report-setup-buffer profile)))

(defun profiler-report-compare-profile (buffer)
  "Compare the current profile with another."
  (interactive (list (read-buffer "Compare to: ")))
  (let* ((profile1 (with-current-buffer buffer profiler-report-profile))
	 (profile2 profiler-report-profile)
	 (diff-profile (profiler-compare-profiles profile1 profile2)))
    (profiler-report-profile diff-profile)))

(defun profiler-report-write-profile (filename &optional confirm)
  "Write the current profile into file FILENAME."
  (interactive
   (list (read-file-name "Write profile: " default-directory)
	 (not current-prefix-arg)))
  (profiler-write-profile profiler-report-profile
                          filename
                          confirm))


;;; Profiler commands

;;;###autoload
(defun profiler-start (mode)
  "Start/restart profilers.
MODE can be one of `cpu', `mem', or `cpu+mem'.
If MODE is `cpu' or `cpu+mem', time-based profiler will be started.
Also, if MODE is `mem' or `cpu+mem', then memory profiler will be started."
  (interactive
   (list (if (not (fboundp 'profiler-cpu-start)) 'mem
           (intern (completing-read "Mode (default cpu): "
                                    '("cpu" "mem" "cpu+mem")
                                    nil t nil nil "cpu")))))
  (cl-ecase mode
    (cpu
     (profiler-cpu-start profiler-sampling-interval)
     (message "CPU profiler started"))
    (mem
     (profiler-memory-start)
     (message "Memory profiler started"))
    (cpu+mem
     (profiler-cpu-start profiler-sampling-interval)
     (profiler-memory-start)
     (message "CPU and memory profiler started"))))

(defun profiler-stop ()
  "Stop started profilers.  Profiler logs will be kept."
  (interactive)
  (let ((cpu (if (fboundp 'profiler-cpu-stop) (profiler-cpu-stop)))
        (mem (profiler-memory-stop)))
    (message "%s profiler stopped"
             (cond ((and mem cpu) "CPU and memory")
                   (mem "Memory")
                   (cpu "CPU")
                   (t "No")))))

(defun profiler-reset ()
  "Reset profiler logs."
  (interactive)
  (when (fboundp 'profiler-cpu-log)
    (ignore (profiler-cpu-log)))
  (ignore (profiler-memory-log))
  t)

(defun profiler-report-cpu ()
  (let ((profile (profiler-cpu-profile)))
    (when profile
      (profiler-report-profile-other-window profile))))

(defun profiler-report-memory ()
  (let ((profile (profiler-memory-profile)))
    (when profile
      (profiler-report-profile-other-window profile))))

(defun profiler-report ()
  "Report profiling results."
  (interactive)
  (profiler-report-cpu)
  (profiler-report-memory))

;;;###autoload
(defun profiler-find-profile (filename)
  "Open profile FILENAME."
  (interactive
   (list (read-file-name "Find profile: " default-directory)))
  (profiler-report-profile (profiler-read-profile filename)))

;;;###autoload
(defun profiler-find-profile-other-window (filename)
  "Open profile FILENAME."
  (interactive
   (list (read-file-name "Find profile: " default-directory)))
  (profiler-report-profile-other-window (profiler-read-profile filename)))

;;;###autoload
(defun profiler-find-profile-other-frame (filename)
  "Open profile FILENAME."
  (interactive
   (list (read-file-name "Find profile: " default-directory)))
  (profiler-report-profile-other-frame(profiler-read-profile filename)))


;;; Profiling helpers

;; (cl-defmacro with-cpu-profiling ((&key sampling-interval) &rest body)
;;   `(unwind-protect
;;        (progn
;;          (ignore (profiler-cpu-log))
;;          (profiler-cpu-start ,sampling-interval)
;;          ,@body)
;;      (profiler-cpu-stop)
;;      (profiler--report-cpu)))

;; (defmacro with-memory-profiling (&rest body)
;;   `(unwind-protect
;;        (progn
;;          (ignore (profiler-memory-log))
;;          (profiler-memory-start)
;;          ,@body)
;;      (profiler-memory-stop)
;;      (profiler--report-memory)))

(provide 'profiler)
;;; profiler.el ends here
