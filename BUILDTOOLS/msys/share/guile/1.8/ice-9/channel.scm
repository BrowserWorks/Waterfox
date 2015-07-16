;;; Guile object channel

;; Copyright (C) 2001, 2006 Free Software Foundation, Inc.

;; This library is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public
;; License as published by the Free Software Foundation; either
;; version 2.1 of the License, or (at your option) any later version.
;; 
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public
;; License along with this library; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

;;; Commentary:

;; Now you can use Guile's modules in Emacs Lisp like this:
;;
;;   (guile-import current-module)
;;   (guile-import module-ref)
;;
;;   (setq assq (module-ref (current-module) 'assq))
;;     => ("<guile>" %%1%% . "#<primitive-procedure assq>")
;;
;;   (guile-use-modules (ice-9 documentation))
;;
;;   (object-documentation assq)
;;     =>
;;  " - primitive: assq key alist
;;    - primitive: assv key alist
;;    - primitive: assoc key alist
;;        Fetches the entry in ALIST that is associated with KEY.  To decide
;;        whether the argument KEY matches a particular entry in ALIST,
;;        `assq' compares keys with `eq?', `assv' uses `eqv?' and `assoc'
;;        uses `equal?'.  If KEY cannot be found in ALIST (according to
;;        whichever equality predicate is in use), then `#f' is returned.
;;        These functions return the entire alist entry found (i.e. both the
;;        key and the value)."
;;
;; Probably we can use GTK in Emacs Lisp.  Can anybody try it?
;;
;; I have also implemented Guile Scheme mode and Scheme Interaction mode.
;; Just put the following lines in your ~/.emacs:
;;
;;   (require 'guile-scheme)
;;   (setq initial-major-mode 'scheme-interaction-mode)
;;
;; Currently, the following commands are available:
;;
;;   M-TAB    guile-scheme-complete-symbol
;;   M-C-x    guile-scheme-eval-define
;;   C-x C-e  guile-scheme-eval-last-sexp
;;   C-c C-b  guile-scheme-eval-buffer
;;   C-c C-r  guile-scheme-eval-region
;;   C-c :    guile-scheme-eval-expression
;;
;; I'll write more commands soon, or if you want to hack, please take
;; a look at the following files:
;;
;;   guile-core/ice-9/channel.scm       ;; object channel
;;   guile-core/emacs/guile.el          ;; object adapter
;;   guile-core/emacs/guile-emacs.scm   ;; Guile <-> Emacs channels
;;   guile-core/emacs/guile-scheme.el   ;; Guile Scheme mode
;;
;; As always, there are more than one bugs ;)

;;; Code:

(define-module (ice-9 channel)
  :export (make-object-channel
	   channel-open
	   channel-print-value
	   channel-print-token))

;;;
;;; Channel type
;;;

(define channel-type
  (make-record-type 'channel '(stdin stdout printer token-module)))

(define make-channel (record-constructor channel-type))

(define (make-object-channel printer)
  (make-channel (current-input-port)
		(current-output-port)
		printer
		(make-module)))

(define channel-stdin (record-accessor channel-type 'stdin))
(define channel-stdout (record-accessor channel-type 'stdout))
(define channel-printer (record-accessor channel-type 'printer))
(define channel-token-module (record-accessor channel-type 'token-module))

;;;
;;; Channel
;;;

(define (channel-open ch)
  (let ((stdin (channel-stdin ch))
	(stdout (channel-stdout ch))
	(printer (channel-printer ch))
	(token-module (channel-token-module ch)))
    (let loop ()
      (catch #t
	(lambda ()
	  (channel:prompt stdout)
	  (let ((cmd (read stdin)))
	    (if (eof-object? cmd)
	      (throw 'quit)
	      (case cmd
		((eval)
		 (module-use! (current-module) token-module)
		 (printer ch (eval (read stdin) (current-module))))
		((destroy)
		 (let ((token (read stdin)))
		   (if (module-defined? token-module token)
		     (module-remove! token-module token)
		     (channel:error stdout "Invalid token: ~S" token))))
		((quit)
		 (throw 'quit))
		(else
		 (channel:error stdout "Unknown command: ~S" cmd)))))
	  (loop))
	(lambda (key . args)
	  (case key
	    ((quit) (throw 'quit))
	    (else
	     (format stdout "exception = ~S\n"
		     (list key (apply format #f (cadr args) (caddr args))))
	     (loop))))))))

(define (channel-print-value ch val)
  (format (channel-stdout ch) "value = ~S\n" val))

(define (channel-print-token ch val)
  (let* ((token (symbol-append (gensym "%%") '%%))
	 (pair (cons token (object->string val))))
    (format (channel-stdout ch) "token = ~S\n" pair)
    (module-define! (channel-token-module ch) token val)))

(define (channel:prompt port)
  (display "channel> " port)
  (force-output port))

(define (channel:error port msg . args)
  (display "ERROR: " port)
  (apply format port msg args)
  (newline port))

;;;
;;; Guile 1.4 compatibility
;;;

(define guile:eval eval)
(define eval
  (if (= (car (procedure-property guile:eval 'arity)) 1)
    (lambda (x e) (guile:eval x))
    guile:eval))

(define object->string
  (if (defined? 'object->string)
    object->string
    (lambda (x) (format #f "~S" x))))

;;; channel.scm ends here
