(define-module (lang elisp variables))

;;; The only purpose of this module is to provide a place where the
;;; variables holding Elisp function definitions can be bound to
;;; symbols.
;;;
;;; This can be useful when looking at unmemoized procedure source
;;; code for Elisp functions and macros.  Elisp function and macro
;;; symbols get memoized into variables.  When the unmemoizer tries to
;;; unmemoize a variables, it does so by looking for a symbol that is
;;; bound to that variable, starting from the module in which the
;;; function or macro was defined and then trying the interfaces on
;;; that module's uses list.  If it can't find any such symbol, it
;;; returns the symbol '???.
;;;
;;; Normally we don't want to bind Elisp function definition variables
;;; to symbols that are visible from the Elisp evaluation module (lang
;;; elisp base), because they would pollute the namespace available
;;; to Elisp variables.  On the other hand, if we are trying to debug
;;; something, and looking at unmemoized source code, it's far more
;;; informative if that code has symbols that indicate the Elisp
;;; function being called than if it just says ??? everywhere.
;;;
;;; So we have a compromise, which achieves a reasonable balance of
;;; correctness (for general operation) and convenience (for
;;; debugging).
;;;
;;; 1. We bind Elisp function definition variables to symbols in this
;;; module (lang elisp variables).
;;;
;;; 2. By default, the Elisp evaluation module (lang elisp base) does
;;; not use (lang elisp variables), so the Elisp variable namespace
;;; stays clean.
;;;
;;; 3. When debugging, a simple (named-module-use! '(lang elisp base)
;;; '(lang elisp variables)) makes the function definition symbols
;;; visible in (lang elisp base) so that the unmemoizer can find
;;; them, which makes the unmemoized source code much easier to read.
;;;
;;; 4. To reduce the effects of namespace pollution even after step 3,
;;; the symbols that we bind are all prefixed with `<elisp' and
;;; suffixed with `>'.
