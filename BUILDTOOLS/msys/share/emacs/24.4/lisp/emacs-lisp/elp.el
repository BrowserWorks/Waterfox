;;; elp.el --- Emacs Lisp Profiler  -*- lexical-binding: t -*-

;; Copyright (C) 1994-1995, 1997-1998, 2001-2014 Free Software
;; Foundation, Inc.

;; Author: Barry A. Warsaw
;; Maintainer: emacs-devel@gnu.org
;; Created: 26-Feb-1994
;; Keywords: debugging lisp tools

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
;;
;; If you want to profile a bunch of functions, set elp-function-list
;; to the list of symbols, then do a M-x elp-instrument-list.  This
;; hacks those functions so that profiling information is recorded
;; whenever they are called.  To print out the current results, use
;; M-x elp-results.  If you want output to go to standard-output
;; instead of a separate buffer, setq elp-use-standard-output to
;; non-nil.  With elp-reset-after-results set to non-nil, profiling
;; information will be reset whenever the results are displayed.  You
;; can also reset all profiling info at any time with M-x
;; elp-reset-all.
;;
;; You can also instrument all functions in a package, provided that
;; the package follows the GNU coding standard of a common textual
;; prefix.  Use M-x elp-instrument-package for this.
;;
;; If you want to sort the results, set elp-sort-by-function to some
;; predicate function.  The three most obvious choices are predefined:
;; elp-sort-by-call-count, elp-sort-by-average-time, and
;; elp-sort-by-total-time.  Also, you can prune from the output, all
;; functions that have been called fewer than a given number of times
;; by setting elp-report-limit.
;;
;; Elp can instrument byte-compiled functions just as easily as
;; interpreted functions, but it cannot instrument macros.  However,
;; when you redefine a function (e.g. with eval-defun), you'll need to
;; re-instrument it with M-x elp-instrument-function.  This will also
;; reset profiling information for that function.  Elp can handle
;; interactive functions (i.e. commands), but of course any time spent
;; idling for user prompts will show up in the timing results.
;;
;; You can also designate a `master' function.  Profiling times will
;; be gathered for instrumented functions only during execution of
;; this master function.  Thus, if you have some defuns like:
;;
;;  (defun foo () (do-something-time-intensive))
;;  (defun bar () (foo))
;;  (defun baz () (bar) (foo))
;;
;; and you want to find out the amount of time spent in bar and foo,
;; but only during execution of bar, make bar the master.  The call of
;; foo from baz will not add to foo's total timing sums.  Use M-x
;; elp-set-master and M-x elp-unset-master to utilize this feature.
;; Only one master function can be set at a time.

;; You can restore any function's original function definition with
;; elp-restore-function.  The other instrument, restore, and reset
;; functions are provided for symmetry.

;; Here is a list of variable you can use to customize elp:
;;   elp-function-list
;;   elp-reset-after-results
;;   elp-sort-by-function
;;   elp-report-limit
;;
;; Here is a list of the interactive commands you can use:
;;   elp-instrument-function
;;   elp-restore-function
;;   elp-instrument-list
;;   elp-restore-list
;;   elp-instrument-package
;;   elp-restore-all
;;   elp-reset-function
;;   elp-reset-list
;;   elp-reset-all
;;   elp-set-master
;;   elp-unset-master
;;   elp-results

;; Note that there are plenty of factors that could make the times
;; reported unreliable, including the accuracy and granularity of your
;; system clock, and the overhead spent in lisp calculating and
;; recording the intervals.  I figure the latter is pretty constant,
;; so while the times may not be entirely accurate, I think they'll
;; give you a good feel for the relative amount of work spent in the
;; various lisp routines you are profiling.  Note further that times
;; are calculated using wall-clock time, so other system load will
;; affect accuracy too.

;;; Background:

;; This program was inspired by the only two existing Emacs Lisp
;; profilers that I'm aware of, Boaz Ben-Zvi's profile.el, and Root
;; Boy Jim's profiler.el. Both were written for Emacs 18 and both were
;; pretty good first shots at profiling, but I found that they didn't
;; provide the functionality or interface that I wanted, so I wrote
;; this.  I've tested elp in XEmacs 19 and Emacs 19.  There's no point
;; in even trying to make this work with Emacs 18.

;; Unlike previous profilers, elp uses Emacs 19's built-in function
;; current-time to return interval times.  This obviates the need for
;; both an external C program and Emacs processes to communicate with
;; such a program, and thus simplifies the package as a whole.

;; TBD:
;; Make this act like a real profiler, so that it records time spent
;; in all branches of execution.

;;; Code:

(eval-when-compile (require 'cl-lib))

;; start of user configuration variables
;; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

(defgroup elp nil
  "Emacs Lisp Profiler."
  :group 'lisp)

(defcustom elp-function-list nil
  "List of functions to profile.
Used by the command `elp-instrument-list'."
  :type '(repeat function)
  :group 'elp)

(defcustom elp-reset-after-results t
  "Non-nil means reset all profiling info after results are displayed.
Results are displayed with the `elp-results' command."
  :type 'boolean
  :group 'elp)

(defcustom elp-sort-by-function 'elp-sort-by-total-time
  "Non-nil specifies ELP results sorting function.
These functions are currently available:

  `elp-sort-by-call-count'   -- sort by the highest call count
  `elp-sort-by-total-time'   -- sort by the highest total time
  `elp-sort-by-average-time' -- sort by the highest average times

You can write your own sort function.  It should adhere to the
interface specified by the PREDICATE argument for `sort'.
Each \"element of LIST\" is really a 4 element vector where element 0 is
the call count, element 1 is the total time spent in the function,
element 2 is the average time spent in the function, and element 3 is
the symbol's name string."
  :type 'function
  :group 'elp)

(defcustom elp-report-limit 1
  "Prevent some functions from being displayed in the results buffer.
If a number, no function that has been called fewer than that number
of times will be displayed in the output buffer.  If nil, all
functions will be displayed."
  :type '(choice integer
                 (const :tag "Show All" nil))
  :group 'elp)

(defcustom elp-use-standard-output nil
  "If non-nil, output to `standard-output' instead of a buffer."
  :type 'boolean
  :group 'elp)

(defcustom elp-recycle-buffers-p t
  "If nil, don't recycle the `elp-results-buffer'.
In other words, a new unique buffer is create every time you run
\\[elp-results]."
  :type 'boolean
  :group 'elp)


;; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;; end of user configuration variables


(defvar elp-results-buffer "*ELP Profiling Results*"
  "Buffer name for outputting profiling results.")

(defconst elp-timer-info-property 'elp-info
  "ELP information property name.")

(defvar elp-record-p t
  "Controls whether functions should record times or not.
This variable is set by the master function.")

(defvar elp-master nil
  "Master function symbol.")

(defvar elp-not-profilable
  ;; First, the functions used inside each instrumented function:
  '(called-interactively-p
    ;; Then the functions used by the above functions.  I used
    ;; (delq nil (mapcar (lambda (x) (and (symbolp x) (fboundp x) x))
    ;;                   (aref (symbol-function 'elp-wrapper) 2)))
    ;; to help me find this list.
    error call-interactively apply current-time
    ;; Andreas Politz reports problems profiling these (Bug#4233):
    + byte-code-function-p functionp byte-code subrp
    indirect-function fboundp)
  "List of functions that cannot be profiled.
Those functions are used internally by the profiling code and profiling
them would thus lead to infinite recursion.")

(defun elp-profilable-p (fun)
  (and (symbolp fun)
       (fboundp fun)
       (not (or (memq fun elp-not-profilable)
                (keymapp fun)
                (autoloadp (symbol-function fun)) ;FIXME: Why not just load it?
                (special-form-p fun)))))

(defconst elp--advice-name 'ELP-instrumentation\ )

;;;###autoload
(defun elp-instrument-function (funsym)
  "Instrument FUNSYM for profiling.
FUNSYM must be a symbol of a defined function."
  (interactive "aFunction to instrument: ")
  (let* ((infovec (vector 0 0)))
    ;; We cannot profile functions used internally during profiling.
    (unless (elp-profilable-p funsym)
      (error "ELP cannot profile the function: %s" funsym))
    ;; The info vector data structure is a 2 element vector.  The 0th
    ;; element is the call-count, i.e. the total number of times this
    ;; function has been entered.  This value is bumped up on entry to
    ;; the function so that non-local exists are still recorded. TBD:
    ;; I haven't tested non-local exits at all, so no guarantees.
    ;;
    ;; The 1st element is the total amount of time in seconds that has
    ;; been spent inside this function.  This number is added to on
    ;; function exit.

    ;; Put the info vector on the property list.
    (put funsym elp-timer-info-property infovec)

    ;; Set the symbol's new profiling function definition to run
    ;; ELP wrapper.
    (advice-add funsym :around (elp--make-wrapper funsym)
                `((name . ,elp--advice-name) (depth . -99)))))

(defun elp--instrumented-p (sym)
  (advice-member-p elp--advice-name sym))

(defun elp-restore-function (funsym)
  "Restore an instrumented function to its original definition.
Argument FUNSYM is the symbol of a defined function."
  (interactive
   (list
    (intern
     (completing-read "Function to restore: " obarray
                      #'elp--instrumented-p t))))
  ;; If the function was the master, reset the master.
  (if (eq funsym elp-master)
      (setq elp-master nil
            elp-record-p t))

  ;; Zap the properties.
  (put funsym elp-timer-info-property nil)

  (advice-remove funsym elp--advice-name))

;;;###autoload
(defun elp-instrument-list (&optional list)
  "Instrument, for profiling, all functions in `elp-function-list'.
Use optional LIST if provided instead.
If called interactively, read LIST using the minibuffer."
  (interactive "PList of functions to instrument: ") ;FIXME: Doesn't work?!
  (unless (listp list)
    (signal 'wrong-type-argument (list 'listp list)))
  (mapcar #'elp-instrument-function (or list elp-function-list)))

;;;###autoload
(defun elp-instrument-package (prefix)
  "Instrument for profiling, all functions which start with PREFIX.
For example, to instrument all ELP functions, do the following:

    \\[elp-instrument-package] RET elp- RET"
  (interactive
   (list (completing-read "Prefix of package to instrument: "
                          obarray 'elp-profilable-p)))
  (if (zerop (length prefix))
      (error "Instrumenting all Emacs functions would render Emacs unusable"))
  (elp-instrument-list
   (mapcar
    'intern
    (all-completions prefix obarray 'elp-profilable-p))))

(defun elp-restore-list (&optional list)
  "Restore the original definitions for all functions in `elp-function-list'.
Use optional LIST if provided instead."
  (interactive "PList of functions to restore: ") ;FIXME: Doesn't work!?
  (mapcar #'elp-restore-function (or list elp-function-list)))

(defun elp-restore-all ()
  "Restore the original definitions of all functions being profiled."
  (interactive)
  (mapatoms #'elp-restore-function))

(defun elp-reset-function (funsym)
  "Reset the profiling information for FUNSYM."
  (interactive "aFunction to reset: ")
  (let ((info (get funsym elp-timer-info-property)))
    (or info
	(error "%s is not instrumented for profiling" funsym))
    (aset info 0 0)			;reset call counter
    (aset info 1 0.0)			;reset total time
    ;; don't muck with aref 2 as that is the old symbol definition
    ))

(defun elp-reset-list (&optional list)
  "Reset the profiling information for all functions in `elp-function-list'.
Use optional LIST if provided instead."
  (interactive "PList of functions to reset: ") ;FIXME: Doesn't work!?
  (let ((list (or list elp-function-list)))
    (mapcar 'elp-reset-function list)))

(defun elp-reset-all ()
  "Reset the profiling information for all functions being profiled."
  (interactive)
  (mapatoms (lambda (sym)
              (if (get sym elp-timer-info-property)
                  (elp-reset-function sym)))))

(defun elp-set-master (funsym)
  "Set the master function for profiling."
  (interactive
   (list
    (intern
     (completing-read "Master function: " obarray
                      #'elp--instrumented-p
                      t nil nil (if elp-master (symbol-name elp-master))))))
  ;; When there's a master function, recording is turned off by default.
  (setq elp-master funsym
	elp-record-p nil)
  ;; Make sure master function is instrumented.
  (or (elp--instrumented-p funsym)
      (elp-instrument-function funsym)))

(defun elp-unset-master ()
  "Unset the master function."
  (interactive)
  ;; When there's no master function, recording is turned on by default.
  (setq elp-master nil
	elp-record-p t))


(defsubst elp-elapsed-time (start end)
  (float-time (time-subtract end start)))

(defun elp--make-wrapper (funsym)
  "Make the piece of advice that instruments FUNSYM."
  (lambda (func &rest args)
    "This function has been instrumented for profiling by the ELP.
ELP is the Emacs Lisp Profiler.  To restore the function to its
original definition, use \\[elp-restore-function] or \\[elp-restore-all]."
    ;; turn on recording if this is the master function
    (if (and elp-master
             (eq funsym elp-master))
        (setq elp-record-p t))
    ;; get info vector and original function symbol
    (let* ((info (get funsym elp-timer-info-property))
           result)
      (or func
          (error "%s is not instrumented for profiling" funsym))
      (if (not elp-record-p)
          ;; when not recording, just call the original function symbol
          ;; and return the results.
          (setq result (apply func args))
        ;; we are recording times
        (let (enter-time exit-time)
          ;; increment the call-counter
          (cl-incf (aref info 0))
	  (setq enter-time (current-time)
		result (apply func args)
                exit-time (current-time))
          ;; calculate total time in function
          (cl-incf (aref info 1) (elp-elapsed-time enter-time exit-time))
          ))
      ;; turn off recording if this is the master function
      (if (and elp-master
               (eq funsym elp-master))
          (setq elp-record-p nil))
      result)))


;; shut the byte-compiler up
(defvar elp-field-len nil)
(defvar elp-cc-len nil)
(defvar elp-at-len nil)
(defvar elp-et-len nil)

(defun elp-sort-by-call-count (vec1 vec2)
  ;; sort by highest call count.  See `sort'.
  (>= (aref vec1 0) (aref vec2 0)))

(defun elp-sort-by-total-time (vec1 vec2)
  ;; sort by highest total time spent in function. See `sort'.
  (>= (aref vec1 1) (aref vec2 1)))

(defun elp-sort-by-average-time (vec1 vec2)
  ;; sort by highest average time spent in function. See `sort'.
  (>= (aref vec1 2) (aref vec2 2)))

(defsubst elp-pack-number (number width)
  ;; pack the NUMBER string into WIDTH characters, watching out for
  ;; very small or large numbers
  (if (<= (length number) width)
      number
    ;; check for very large or small numbers
    (if (string-match "^\\(.*\\)\\(e[+-].*\\)$" number)
	(concat (substring
		 (match-string 1 number)
		 0
		 (- width (match-end 2) (- (match-beginning 2)) 3))
		"..."
		(match-string 2 number))
      (substring number 0 width))))

(defun elp-output-result (resultvec)
  ;; output the RESULTVEC into the results buffer. RESULTVEC is a 4 or
  ;; more element vector where aref 0 is the call count, aref 1 is the
  ;; total time spent in the function, aref 2 is the average time
  ;; spent in the function, and aref 3 is the symbol's string
  ;; name. All other elements in the vector are ignored.
  (let* ((cc (aref resultvec 0))
	 (tt (aref resultvec 1))
	 (at (aref resultvec 2))
	 (symname (aref resultvec 3))
	 callcnt totaltime avetime)
    (setq callcnt (number-to-string cc)
	  totaltime (number-to-string tt)
	  avetime (number-to-string at))
    ;; possibly prune the results
    (if (and elp-report-limit
	     (numberp elp-report-limit)
	     (< cc elp-report-limit))
	nil
      (elp-output-insert-symname symname)
      (insert-char 32 (+ elp-field-len (- (length symname)) 2))
      ;; print stuff out, formatting it nicely
      (insert callcnt)
      (insert-char 32 (+ elp-cc-len (- (length callcnt)) 2))
      (let ((ttstr (elp-pack-number totaltime elp-et-len))
	    (atstr (elp-pack-number avetime elp-at-len)))
	(insert ttstr)
	(insert-char 32 (+ elp-et-len (- (length ttstr)) 2))
	(insert atstr))
      (insert "\n"))))

(defvar elp-results-symname-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-2] 'elp-results-jump-to-definition)
    (define-key map [follow-link] 'mouse-face)
    (define-key map "\C-m" 'elp-results-jump-to-definition)
    map)
  "Keymap used on the function name column." )

(defun elp-results-jump-to-definition (&optional event)
  "Jump to the definition of the function under the point."
  (interactive (list last-nonmenu-event))
  (if event (posn-set-point (event-end event)))
  (find-function (get-text-property (point) 'elp-symname)))

(defun elp-output-insert-symname (symname)
  ;; Insert SYMNAME with text properties.
  (insert (propertize symname
		      'elp-symname (intern symname)
		      'keymap elp-results-symname-map
		      'mouse-face 'highlight
		      'face 'link
		      'help-echo "mouse-2 or RET jumps to definition")))

;;;###autoload
(defun elp-results ()
  "Display current profiling results.
If `elp-reset-after-results' is non-nil, then current profiling
information for all instrumented functions is reset after results are
displayed."
  (interactive)
  (let ((curbuf (current-buffer))
	(resultsbuf (if elp-recycle-buffers-p
			(get-buffer-create elp-results-buffer)
		      (generate-new-buffer elp-results-buffer))))
    (set-buffer resultsbuf)
    (erase-buffer)
    ;; get the length of the longest function name being profiled
    (let* ((longest 0)
	   (title "Function Name")
	   (titlelen (length title))
	   (elp-field-len titlelen)
	   (cc-header "Call Count")
	   (elp-cc-len    (length cc-header))
	   (et-header "Elapsed Time")
	   (elp-et-len    (length et-header))
	   (at-header "Average Time")
	   (elp-at-len    (length at-header))
	   (resvec '())
	   )				; end let*
      (mapatoms
       (lambda (funsym)
         (when (elp--instrumented-p funsym)
           (let* ((info (get funsym elp-timer-info-property))
                  (symname (format "%s" funsym))
                  (cc (aref info 0))
                  (tt (aref info 1)))
             (if (not info)
                 (insert "No profiling information found for: "
                         symname)
               (setq longest (max longest (length symname)))
               (push
                (vector cc tt (if (zerop cc)
                                  0.0 ;avoid arithmetic div-by-zero errors
                                (/ (float tt) (float cc)))
                        symname)
                resvec))))))
      ;; If printing to stdout, insert the header so it will print.
      ;; Otherwise use header-line-format.
      (setq elp-field-len (max titlelen longest))
      (if (or elp-use-standard-output noninteractive)
          (progn
            (insert title)
            (if (> longest titlelen)
                (progn
                  (insert-char 32 (- longest titlelen))))
            (insert "  " cc-header "  " et-header "  " at-header "\n")
            (insert-char ?= elp-field-len)
            (insert "  ")
            (insert-char ?= elp-cc-len)
            (insert "  ")
            (insert-char ?= elp-et-len)
            (insert "  ")
            (insert-char ?= elp-at-len)
            (insert "\n"))
        (let ((column 0))
          (setq header-line-format
                (mapconcat
                 (lambda (title)
                   (prog1
                       (concat
                        (propertize " "
                                    'display (list 'space :align-to column)
                                    'face 'fixed-pitch)
                        title)
                     (setq column (+ column 2
                                     (if (= column 0)
                                         elp-field-len
                                       (length title))))))
                 (list title cc-header et-header at-header) ""))))
      ;; if sorting is enabled, then sort the results list. in either
      ;; case, call elp-output-result to output the result in the
      ;; buffer
      (if elp-sort-by-function
	  (setq resvec (sort resvec elp-sort-by-function)))
      (mapc 'elp-output-result resvec))
    ;; now pop up results buffer
    (set-buffer curbuf)
    (pop-to-buffer resultsbuf)
    ;; copy results to standard-output?
    (if (or elp-use-standard-output noninteractive)
        (princ (buffer-substring (point-min) (point-max)))
      (goto-char (point-min)))
    ;; reset profiling info if desired
    (and elp-reset-after-results
	 (elp-reset-all))))

(defun elp-unload-function ()
  "Unload the Emacs Lisp Profiler."
  (elp-restore-all)
  ;; continue standard unloading
  nil)

(provide 'elp)

;;; elp.el ends here
