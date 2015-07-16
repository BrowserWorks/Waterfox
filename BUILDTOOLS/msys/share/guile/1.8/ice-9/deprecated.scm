;;;; Copyright (C) 2003, 2005, 2006 Free Software Foundation, Inc.
;;;;
;;;; This library is free software; you can redistribute it and/or
;;;; modify it under the terms of the GNU Lesser General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2.1 of the License, or (at your option) any later version.
;;;; 
;;;; This library is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;; Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU Lesser General Public
;;;; License along with this library; if not, write to the Free Software
;;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;;;;

;;;; Deprecated definitions.

(define substring-move-left! substring-move!)
(define substring-move-right! substring-move!)

;; This method of dynamically linking Guile Extensions is deprecated.
;; Use `load-extension' explicitly from Scheme code instead.

(define (split-c-module-name str)
  (let loop ((rev '())
	     (start 0)
	     (pos 0)
	     (end (string-length str)))
    (cond
     ((= pos end)
      (reverse (cons (string->symbol (substring str start pos)) rev)))
     ((eq? (string-ref str pos) #\space)
      (loop (cons (string->symbol (substring str start pos)) rev)
	    (+ pos 1)
	    (+ pos 1)
	    end))
     (else
      (loop rev start (+ pos 1) end)))))

(define (convert-c-registered-modules dynobj)
  (let ((res (map (lambda (c)
		    (list (split-c-module-name (car c)) (cdr c) dynobj))
		  (c-registered-modules))))
    (c-clear-registered-modules)
    res))

(define registered-modules '())

(define (register-modules dynobj)
  (set! registered-modules
	(append! (convert-c-registered-modules dynobj)
		 registered-modules)))

(define (warn-autoload-deprecation modname)
  (issue-deprecation-warning
   "Autoloading of compiled code modules is deprecated."
   "Write a Scheme file instead that uses `load-extension'.")
  (issue-deprecation-warning
   (simple-format #f "(You just autoloaded module ~S.)" modname)))

(define (init-dynamic-module modname)
  ;; Register any linked modules which have been registered on the C level
  (register-modules #f)
  (or-map (lambda (modinfo)
	    (if (equal? (car modinfo) modname)
		(begin
		  (warn-autoload-deprecation modname)
		  (set! registered-modules (delq! modinfo registered-modules))
		  (let ((mod (resolve-module modname #f)))
		    (save-module-excursion
		     (lambda ()
		       (set-current-module mod)
		       (set-module-public-interface! mod mod)
		       (dynamic-call (cadr modinfo) (caddr modinfo))
		       ))
		    #t))
		#f))
	  registered-modules))

(define (dynamic-maybe-call name dynobj)
  (catch #t				; could use false-if-exception here
	 (lambda ()
	   (dynamic-call name dynobj))
	 (lambda args
	   #f)))

(define (dynamic-maybe-link filename)
  (catch #t				; could use false-if-exception here
	 (lambda ()
	   (dynamic-link filename))
	 (lambda args
	   #f)))

(define (find-and-link-dynamic-module module-name)
  (define (make-init-name mod-name)
    (string-append "scm_init"
		   (list->string (map (lambda (c)
					(if (or (char-alphabetic? c)
						(char-numeric? c))
					    c
					    #\_))
				      (string->list mod-name)))
		   "_module"))

  ;; Put the subdirectory for this module in the car of SUBDIR-AND-LIBNAME,
  ;; and the `libname' (the name of the module prepended by `lib') in the cdr
  ;; field.  For example, if MODULE-NAME is the list (inet tcp-ip udp), then
  ;; SUBDIR-AND-LIBNAME will be the pair ("inet/tcp-ip" . "libudp").
  (let ((subdir-and-libname
	 (let loop ((dirs "")
		    (syms module-name))
	   (if (null? (cdr syms))
	       (cons dirs (string-append "lib" (symbol->string (car syms))))
	       (loop (string-append dirs (symbol->string (car syms)) "/")
		     (cdr syms)))))
	(init (make-init-name (apply string-append
				     (map (lambda (s)
					    (string-append "_"
							   (symbol->string s)))
					  module-name)))))
    (let ((subdir (car subdir-and-libname))
	  (libname (cdr subdir-and-libname)))

      ;; Now look in each dir in %LOAD-PATH for `subdir/libfoo.la'.  If that
      ;; file exists, fetch the dlname from that file and attempt to link
      ;; against it.  If `subdir/libfoo.la' does not exist, or does not seem
      ;; to name any shared library, look for `subdir/libfoo.so' instead and
      ;; link against that.
      (let check-dirs ((dir-list %load-path))
	(if (null? dir-list)
	    #f
	    (let* ((dir (in-vicinity (car dir-list) subdir))
		   (sharlib-full
		    (or (try-using-libtool-name dir libname)
			(try-using-sharlib-name dir libname))))
	      (if (and sharlib-full (file-exists? sharlib-full))
		  (link-dynamic-module sharlib-full init)
		  (check-dirs (cdr dir-list)))))))))

(define (try-using-libtool-name libdir libname)
  (let ((libtool-filename (in-vicinity libdir
				       (string-append libname ".la"))))
    (and (file-exists? libtool-filename)
	 libtool-filename)))

(define (try-using-sharlib-name libdir libname)
  (in-vicinity libdir (string-append libname ".so")))

(define (link-dynamic-module filename initname)
  ;; Register any linked modules which have been registered on the C level
  (register-modules #f)
  (let ((dynobj (dynamic-link filename)))
    (dynamic-call initname dynobj)
    (register-modules dynobj)))

(define (try-module-linked module-name)
  (init-dynamic-module module-name))

(define (try-module-dynamic-link module-name)
  (and (find-and-link-dynamic-module module-name)
       (init-dynamic-module module-name)))

(define (list* . args)
  (issue-deprecation-warning "'list*' is deprecated.  Use 'cons*' instead.")
  (apply cons* args))

;; The strange prototype system for uniform arrays has been
;; deprecated.

(define uniform-vector-fill! array-fill!)

(define make-uniform-vector dimensions->uniform-array)

(define (make-uniform-array prot . bounds)
  (dimensions->uniform-array bounds prot))
 
(define (list->uniform-vector prot lst)
  (list->uniform-array 1 prot lst))
