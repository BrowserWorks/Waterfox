(define-module (lang elisp primitives system)
  #:use-module (lang elisp internals fset))

(fset 'system-name
      (lambda ()
	(vector-ref (uname) 1)))

(define-public system-type
  (let ((uname (vector-ref (uname) 0)))
    (if (string=? uname "Linux")
	"gnu/linux"
	uname)))

(define-public system-configuration "i386-suse-linux") ;FIXME
