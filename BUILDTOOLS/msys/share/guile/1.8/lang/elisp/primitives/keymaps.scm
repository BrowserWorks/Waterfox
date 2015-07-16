(define-module (lang elisp primitives keymaps)
  #:use-module (lang elisp internals fset))

(define (make-sparse-keymap)
  (list 'keymap))

(define (define-key keymap key def)
  (set-cdr! keymap
	    (cons (cons key def) (cdr keymap))))
  
(define global-map (make-sparse-keymap))
(define esc-map (make-sparse-keymap))
(define ctl-x-map (make-sparse-keymap))
(define ctl-x-4-map (make-sparse-keymap))
(define ctl-x-5-map (make-sparse-keymap))

;;; {Elisp Exports}

(fset 'make-sparse-keymap make-sparse-keymap)
(fset 'define-key define-key)

(export global-map
	esc-map
	ctl-x-map
	ctl-x-4-map
	ctl-x-5-map)
