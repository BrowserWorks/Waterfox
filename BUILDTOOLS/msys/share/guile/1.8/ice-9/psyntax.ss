;;;; -*-scheme-*-
;;;;
;;;; 	Copyright (C) 2001, 2003, 2006 Free Software Foundation, Inc.
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


;;; Portable implementation of syntax-case
;;; Extracted from Chez Scheme Version 5.9f
;;; Authors: R. Kent Dybvig, Oscar Waddell, Bob Hieb, Carl Bruggeman

;;; Modified by Mikael Djurfeldt <djurfeldt@nada.kth.se> according
;;; to the ChangeLog distributed in the same directory as this file:
;;; 1997-08-19, 1997-09-03, 1997-09-10, 2000-08-13, 2000-08-24,
;;; 2000-09-12, 2001-03-08

;;; Copyright (c) 1992-1997 Cadence Research Systems
;;; Permission to copy this software, in whole or in part, to use this
;;; software for any lawful purpose, and to redistribute this software
;;; is granted subject to the restriction that all copies made of this
;;; software must include this copyright notice in full.  This software
;;; is provided AS IS, with NO WARRANTY, EITHER EXPRESS OR IMPLIED,
;;; INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY
;;; OR FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT SHALL THE
;;; AUTHORS BE LIABLE FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES OF ANY
;;; NATURE WHATSOEVER.

;;; Before attempting to port this code to a new implementation of
;;; Scheme, please read the notes below carefully.


;;; This file defines the syntax-case expander, sc-expand, and a set
;;; of associated syntactic forms and procedures.  Of these, the
;;; following are documented in The Scheme Programming Language,
;;; Second Edition (R. Kent Dybvig, Prentice Hall, 1996).  Most are
;;; also documented in the R4RS and draft R5RS.
;;;
;;;   bound-identifier=?
;;;   datum->syntax-object
;;;   define-syntax
;;;   fluid-let-syntax
;;;   free-identifier=?
;;;   generate-temporaries
;;;   identifier?
;;;   identifier-syntax
;;;   let-syntax
;;;   letrec-syntax
;;;   syntax
;;;   syntax-case
;;;   syntax-object->datum
;;;   syntax-rules
;;;   with-syntax
;;;
;;; All standard Scheme syntactic forms are supported by the expander
;;; or syntactic abstractions defined in this file.  Only the R4RS
;;; delay is omitted, since its expansion is implementation-dependent.

;;; The remaining exports are listed below:
;;;
;;;   (sc-expand datum)
;;;      if datum represents a valid expression, sc-expand returns an
;;;      expanded version of datum in a core language that includes no
;;;      syntactic abstractions.  The core language includes begin,
;;;      define, if, lambda, letrec, quote, and set!.
;;;   (eval-when situations expr ...)
;;;      conditionally evaluates expr ... at compile-time or run-time
;;;      depending upon situations (see the Chez Scheme System Manual,
;;;      Revision 3, for a complete description)
;;;   (syntax-error object message)
;;;      used to report errors found during expansion
;;;   (install-global-transformer symbol value)
;;;      used by expanded code to install top-level syntactic abstractions
;;;   (syntax-dispatch e p)
;;;      used by expanded code to handle syntax-case matching

;;; The following nonstandard procedures must be provided by the
;;; implementation for this code to run.
;;;
;;; (void)
;;; returns the implementation's cannonical "unspecified value".  This
;;; usually works: (define void (lambda () (if #f #f))).
;;;
;;; (andmap proc list1 list2 ...)
;;; returns true if proc returns true when applied to each element of list1
;;; along with the corresponding elements of list2 ....
;;; The following definition works but does no error checking:
;;;
;;; (define andmap
;;;   (lambda (f first . rest)
;;;     (or (null? first)
;;;         (if (null? rest)
;;;             (let andmap ((first first))
;;;               (let ((x (car first)) (first (cdr first)))
;;;                 (if (null? first)
;;;                     (f x)
;;;                     (and (f x) (andmap first)))))
;;;             (let andmap ((first first) (rest rest))
;;;               (let ((x (car first))
;;;                     (xr (map car rest))
;;;                     (first (cdr first))
;;;                     (rest (map cdr rest)))
;;;                 (if (null? first)
;;;                     (apply f (cons x xr))
;;;                     (and (apply f (cons x xr)) (andmap first rest)))))))))
;;;
;;; The following nonstandard procedures must also be provided by the
;;; implementation for this code to run using the standard portable
;;; hooks and output constructors.  They are not used by expanded code,
;;; and so need be present only at expansion time.
;;;
;;; (eval x)
;;; where x is always in the form ("noexpand" expr).
;;; returns the value of expr.  the "noexpand" flag is used to tell the
;;; evaluator/expander that no expansion is necessary, since expr has
;;; already been fully expanded to core forms.
;;;
;;; eval will not be invoked during the loading of psyntax.pp.  After
;;; psyntax.pp has been loaded, the expansion of any macro definition,
;;; whether local or global, will result in a call to eval.  If, however,
;;; sc-expand has already been registered as the expander to be used
;;; by eval, and eval accepts one argument, nothing special must be done
;;; to support the "noexpand" flag, since it is handled by sc-expand.
;;;
;;; (error who format-string why what)
;;; where who is either a symbol or #f, format-string is always "~a ~s",
;;; why is always a string, and what may be any object.  error should
;;; signal an error with a message something like
;;;
;;;    "error in <who>: <why> <what>"
;;;
;;; (gensym)
;;; returns a unique symbol each time it's called
;;;
;;; (putprop symbol key value)
;;; (getprop symbol key)
;;; key is always the symbol *sc-expander*; value may be any object.
;;; putprop should associate the given value with the given symbol in
;;; some way that it can be retrieved later with getprop.

;;; When porting to a new Scheme implementation, you should define the
;;; procedures listed above, load the expanded version of psyntax.ss
;;; (psyntax.pp, which should be available whereever you found
;;; psyntax.ss), and register sc-expand as the current expander (how
;;; you do this depends upon your implementation of Scheme).  You may
;;; change the hooks and constructors defined toward the beginning of
;;; the code below, but to avoid bootstrapping problems, do so only
;;; after you have a working version of the expander.

;;; Chez Scheme allows the syntactic form (syntax <template>) to be
;;; abbreviated to #'<template>, just as (quote <datum>) may be
;;; abbreviated to '<datum>.  The #' syntax makes programs written
;;; using syntax-case shorter and more readable and draws out the
;;; intuitive connection between syntax and quote.

;;; If you find that this code loads or runs slowly, consider
;;; switching to faster hardware or a faster implementation of
;;; Scheme.  In Chez Scheme on a 200Mhz Pentium Pro, expanding,
;;; compiling (with full optimization), and loading this file takes
;;; between one and two seconds.

;;; In the expander implementation, we sometimes use syntactic abstractions
;;; when procedural abstractions would suffice.  For example, we define
;;; top-wrap and top-marked? as
;;;   (define-syntax top-wrap (identifier-syntax '((top))))
;;;   (define-syntax top-marked?
;;;     (syntax-rules ()
;;;       ((_ w) (memq 'top (wrap-marks w)))))
;;; rather than
;;;   (define top-wrap '((top)))
;;;   (define top-marked?
;;;     (lambda (w) (memq 'top (wrap-marks w))))
;;; On ther other hand, we don't do this consistently; we define make-wrap,
;;; wrap-marks, and wrap-subst simply as
;;;   (define make-wrap cons)
;;;   (define wrap-marks car)
;;;   (define wrap-subst cdr)
;;; In Chez Scheme, the syntactic and procedural forms of these
;;; abstractions are equivalent, since the optimizer consistently
;;; integrates constants and small procedures.  Some Scheme
;;; implementations, however, may benefit from more consistent use 
;;; of one form or the other.


;;; implementation information:

;;; "begin" is treated as a splicing construct at top level and at
;;; the beginning of bodies.  Any sequence of expressions that would
;;; be allowed where the "begin" occurs is allowed.

;;; "let-syntax" and "letrec-syntax" are also treated as splicing
;;; constructs, in violation of the R4RS appendix and probably the R5RS
;;; when it comes out.  A consequence, let-syntax and letrec-syntax do
;;; not create local contours, as do let and letrec.  Although the
;;; functionality is greater as it is presently implemented, we will
;;; probably change it to conform to the R4RS/expected R5RS.

;;; Objects with no standard print syntax, including objects containing
;;; cycles and syntax object, are allowed in quoted data as long as they
;;; are contained within a syntax form or produced by datum->syntax-object.
;;; Such objects are never copied.

;;; All identifiers that don't have macro definitions and are not bound
;;; lexically are assumed to be global variables

;;; Top-level definitions of macro-introduced identifiers are allowed.
;;; This may not be appropriate for implementations in which the
;;; model is that bindings are created by definitions, as opposed to
;;; one in which initial values are assigned by definitions.

;;; Top-level variable definitions of syntax keywords is not permitted.
;;; Any solution allowing this would be kludgey and would yield
;;; surprising results in some cases.  We can provide an undefine-syntax
;;; form.  The questions is, should define be an implicit undefine-syntax?
;;; We've decided no for now.

;;; Identifiers and syntax objects are implemented as vectors for
;;; portability.  As a result, it is possible to "forge" syntax
;;; objects.

;;; The implementation of generate-temporaries assumes that it is possible
;;; to generate globally unique symbols (gensyms).

;;; The input to sc-expand may contain "annotations" describing, e.g., the
;;; source file and character position from where each object was read if
;;; it was read from a file.  These annotations are handled properly by
;;; sc-expand only if the annotation? hook (see hooks below) is implemented
;;; properly and the operators make-annotation, annotation-expression,
;;; annotation-source, annotation-stripped, and set-annotation-stripped!
;;; are supplied.  If annotations are supplied, the proper annotation
;;; source is passed to the various output constructors, allowing
;;; implementations to accurately correlate source and expanded code.
;;; Contact one of the authors for details if you wish to make use of
;;; this feature.



;;; Bootstrapping:

;;; When changing syntax-object representations, it is necessary to support
;;; both old and new syntax-object representations in id-var-name.  It
;;; should be sufficient to recognize old representations and treat
;;; them as not lexically bound.



(let ()
(define-syntax define-structure
  (lambda (x)
    (define construct-name
      (lambda (template-identifier . args)
        (datum->syntax-object
          template-identifier
          (string->symbol
            (apply string-append
                   (map (lambda (x)
                          (if (string? x)
                              x
                              (symbol->string (syntax-object->datum x))))
                        args))))))
    (syntax-case x ()
      ((_ (name id1 ...))
       (andmap identifier? (syntax (name id1 ...)))
       (with-syntax
         ((constructor (construct-name (syntax name) "make-" (syntax name)))
          (predicate (construct-name (syntax name) (syntax name) "?"))
          ((access ...)
           (map (lambda (x) (construct-name x (syntax name) "-" x))
                (syntax (id1 ...))))
          ((assign ...)
           (map (lambda (x)
                  (construct-name x "set-" (syntax name) "-" x "!"))
                (syntax (id1 ...))))
          (structure-length
           (+ (length (syntax (id1 ...))) 1))
          ((index ...)
           (let f ((i 1) (ids (syntax (id1 ...))))
              (if (null? ids)
                  '()
                  (cons i (f (+ i 1) (cdr ids)))))))
         (syntax (begin
                   (define constructor
                     (lambda (id1 ...)
                       (vector 'name id1 ... )))
                   (define predicate
                     (lambda (x)
                       (and (vector? x)
                            (= (vector-length x) structure-length)
                            (eq? (vector-ref x 0) 'name))))
                   (define access
                     (lambda (x)
                       (vector-ref x index)))
                   ...
                   (define assign
                     (lambda (x update)
                       (vector-set! x index update)))
                   ...)))))))

(let ()
(define noexpand "noexpand")

;;; hooks to nonportable run-time helpers
(begin
(define fx+ +)
(define fx- -)
(define fx= =)
(define fx< <)

(define annotation? (lambda (x) #f))

(define top-level-eval-hook
  (lambda (x)
    (eval `(,noexpand ,x) (interaction-environment))))

(define local-eval-hook
  (lambda (x)
    (eval `(,noexpand ,x) (interaction-environment))))

(define error-hook
  (lambda (who why what)
    (error who "~a ~s" why what)))

(define-syntax gensym-hook
  (syntax-rules ()
    ((_) (gensym))))

(define put-global-definition-hook
  (lambda (symbol binding)
     (putprop symbol '*sc-expander* binding)))

(define get-global-definition-hook
  (lambda (symbol)
     (getprop symbol '*sc-expander*)))
)


;;; output constructors
(begin
(define-syntax build-application
  (syntax-rules ()
    ((_ source fun-exp arg-exps)
     `(,fun-exp . ,arg-exps))))

(define-syntax build-conditional
  (syntax-rules ()
    ((_ source test-exp then-exp else-exp)
     `(if ,test-exp ,then-exp ,else-exp))))

(define-syntax build-lexical-reference
  (syntax-rules ()
    ((_ type source var)
     var)))

(define-syntax build-lexical-assignment
  (syntax-rules ()
    ((_ source var exp)
     `(set! ,var ,exp))))

(define-syntax build-global-reference
  (syntax-rules ()
    ((_ source var)
     var)))

(define-syntax build-global-assignment
  (syntax-rules ()
    ((_ source var exp)
     `(set! ,var ,exp))))

(define-syntax build-global-definition
  (syntax-rules ()
    ((_ source var exp)
     `(define ,var ,exp))))

(define-syntax build-lambda
  (syntax-rules ()
    ((_ src vars exp)
     `(lambda ,vars ,exp))))

(define-syntax build-primref
  (syntax-rules ()
    ((_ src name) name)
    ((_ src level name) name)))

(define (build-data src exp)
  (if (and (self-evaluating? exp)
	   (not (vector? exp)))
      exp
      (list 'quote exp)))

(define build-sequence
  (lambda (src exps)
    (if (null? (cdr exps))
        (car exps)
        `(begin ,@exps))))

(define build-let
  (lambda (src vars val-exps body-exp)
    (if (null? vars)
	body-exp
	`(let ,(map list vars val-exps) ,body-exp))))

(define build-named-let
  (lambda (src vars val-exps body-exp)
    (if (null? vars)
	body-exp
	`(let ,(car vars) ,(map list (cdr vars) val-exps) ,body-exp))))

(define build-letrec
  (lambda (src vars val-exps body-exp)
    (if (null? vars)
        body-exp
        `(letrec ,(map list vars val-exps) ,body-exp))))

(define-syntax build-lexical-var
  (syntax-rules ()
    ((_ src id) (gensym (symbol->string id)))))
)

(define-structure (syntax-object expression wrap))

(define-syntax unannotate
  (syntax-rules ()
    ((_ x)
     (let ((e x))
       (if (annotation? e)
           (annotation-expression e)
           e)))))

(define-syntax no-source (identifier-syntax #f))

(define source-annotation
  (lambda (x)
     (cond
       ((annotation? x) (annotation-source x))
       ((syntax-object? x) (source-annotation (syntax-object-expression x)))
       (else no-source))))

(define-syntax arg-check
  (syntax-rules ()
    ((_ pred? e who)
     (let ((x e))
       (if (not (pred? x)) (error-hook who "invalid argument" x))))))

;;; compile-time environments

;;; wrap and environment comprise two level mapping.
;;;   wrap : id --> label
;;;   env : label --> <element>

;;; environments are represented in two parts: a lexical part and a global
;;; part.  The lexical part is a simple list of associations from labels
;;; to bindings.  The global part is implemented by
;;; {put,get}-global-definition-hook and associates symbols with
;;; bindings.

;;; global (assumed global variable) and displaced-lexical (see below)
;;; do not show up in any environment; instead, they are fabricated by
;;; lookup when it finds no other bindings.

;;; <environment>              ::= ((<label> . <binding>)*)

;;; identifier bindings include a type and a value

;;; <binding> ::= (macro . <procedure>)           macros
;;;               (core . <procedure>)            core forms
;;;               (external-macro . <procedure>)  external-macro
;;;               (begin)                         begin
;;;               (define)                        define
;;;               (define-syntax)                 define-syntax
;;;               (local-syntax . rec?)           let-syntax/letrec-syntax
;;;               (eval-when)                     eval-when
;;;               (syntax . (<var> . <level>))    pattern variables
;;;               (global)                        assumed global variable
;;;               (lexical . <var>)               lexical variables
;;;               (displaced-lexical)             displaced lexicals
;;; <level>   ::= <nonnegative integer>
;;; <var>     ::= variable returned by build-lexical-var

;;; a macro is a user-defined syntactic-form.  a core is a system-defined
;;; syntactic form.  begin, define, define-syntax, and eval-when are
;;; treated specially since they are sensitive to whether the form is
;;; at top-level and (except for eval-when) can denote valid internal
;;; definitions.

;;; a pattern variable is a variable introduced by syntax-case and can
;;; be referenced only within a syntax form.

;;; any identifier for which no top-level syntax definition or local
;;; binding of any kind has been seen is assumed to be a global
;;; variable.

;;; a lexical variable is a lambda- or letrec-bound variable.

;;; a displaced-lexical identifier is a lexical identifier removed from
;;; it's scope by the return of a syntax object containing the identifier.
;;; a displaced lexical can also appear when a letrec-syntax-bound
;;; keyword is referenced on the rhs of one of the letrec-syntax clauses.
;;; a displaced lexical should never occur with properly written macros.

(define-syntax make-binding
  (syntax-rules (quote)
    ((_ type value) (cons type value))
    ((_ 'type) '(type))
    ((_ type) (cons type '()))))
(define binding-type car)
(define binding-value cdr)

(define-syntax null-env (identifier-syntax '()))

(define extend-env
  (lambda (labels bindings r) 
    (if (null? labels)
        r
        (extend-env (cdr labels) (cdr bindings)
          (cons (cons (car labels) (car bindings)) r)))))

(define extend-var-env
  ; variant of extend-env that forms "lexical" binding
  (lambda (labels vars r)
    (if (null? labels)
        r
        (extend-var-env (cdr labels) (cdr vars)
          (cons (cons (car labels) (make-binding 'lexical (car vars))) r)))))

;;; we use a "macros only" environment in expansion of local macro
;;; definitions so that their definitions can use local macros without
;;; attempting to use other lexical identifiers.
(define macros-only-env
  (lambda (r)
    (if (null? r)
        '()
        (let ((a (car r)))
          (if (eq? (cadr a) 'macro)
              (cons a (macros-only-env (cdr r)))
              (macros-only-env (cdr r)))))))

(define lookup
  ; x may be a label or a symbol
  ; although symbols are usually global, we check the environment first
  ; anyway because a temporary binding may have been established by
  ; fluid-let-syntax
  (lambda (x r)
    (cond
      ((assq x r) => cdr)
      ((symbol? x)
       (or (get-global-definition-hook x) (make-binding 'global)))
      (else (make-binding 'displaced-lexical)))))

(define global-extend
  (lambda (type sym val)
    (put-global-definition-hook sym (make-binding type val))))


;;; Conceptually, identifiers are always syntax objects.  Internally,
;;; however, the wrap is sometimes maintained separately (a source of
;;; efficiency and confusion), so that symbols are also considered
;;; identifiers by id?.  Externally, they are always wrapped.

(define nonsymbol-id?
  (lambda (x)
    (and (syntax-object? x)
         (symbol? (unannotate (syntax-object-expression x))))))

(define id?
  (lambda (x)
    (cond
      ((symbol? x) #t)
      ((syntax-object? x) (symbol? (unannotate (syntax-object-expression x))))
      ((annotation? x) (symbol? (annotation-expression x)))
      (else #f))))

(define-syntax id-sym-name
  (syntax-rules ()
    ((_ e)
     (let ((x e))
       (unannotate (if (syntax-object? x) (syntax-object-expression x) x))))))

(define id-sym-name&marks
  (lambda (x w)
    (if (syntax-object? x)
        (values
          (unannotate (syntax-object-expression x))
          (join-marks (wrap-marks w) (wrap-marks (syntax-object-wrap x))))
        (values (unannotate x) (wrap-marks w)))))

;;; syntax object wraps

;;;         <wrap> ::= ((<mark> ...) . (<subst> ...))
;;;        <subst> ::= <shift> | <subs>
;;;         <subs> ::= #(<old name> <label> (<mark> ...))
;;;        <shift> ::= positive fixnum

(define make-wrap cons)
(define wrap-marks car)
(define wrap-subst cdr)

(define-syntax subst-rename? (identifier-syntax vector?))
(define-syntax rename-old (syntax-rules () ((_ x) (vector-ref x 0))))
(define-syntax rename-new (syntax-rules () ((_ x) (vector-ref x 1))))
(define-syntax rename-marks (syntax-rules () ((_ x) (vector-ref x 2))))
(define-syntax make-rename
  (syntax-rules ()
    ((_ old new marks) (vector old new marks))))

;;; labels must be comparable with "eq?" and distinct from symbols.
(define gen-label
  (lambda () (string #\i)))

(define gen-labels
  (lambda (ls)
    (if (null? ls)
        '()
        (cons (gen-label) (gen-labels (cdr ls))))))

(define-structure (ribcage symnames marks labels))

(define-syntax empty-wrap (identifier-syntax '(())))

(define-syntax top-wrap (identifier-syntax '((top))))

(define-syntax top-marked?
  (syntax-rules ()
    ((_ w) (memq 'top (wrap-marks w)))))

;;; Marks must be comparable with "eq?" and distinct from pairs and
;;; the symbol top.  We do not use integers so that marks will remain
;;; unique even across file compiles.

(define-syntax the-anti-mark (identifier-syntax #f))

(define anti-mark
  (lambda (w)
    (make-wrap (cons the-anti-mark (wrap-marks w))
               (cons 'shift (wrap-subst w)))))

(define-syntax new-mark
  (syntax-rules ()
    ((_) (string #\m))))

;;; make-empty-ribcage and extend-ribcage maintain list-based ribcages for
;;; internal definitions, in which the ribcages are built incrementally
(define-syntax make-empty-ribcage
  (syntax-rules ()
    ((_) (make-ribcage '() '() '()))))

(define extend-ribcage!
  ; must receive ids with complete wraps
  (lambda (ribcage id label)
    (set-ribcage-symnames! ribcage
      (cons (unannotate (syntax-object-expression id))
            (ribcage-symnames ribcage)))
    (set-ribcage-marks! ribcage
      (cons (wrap-marks (syntax-object-wrap id))
            (ribcage-marks ribcage)))
    (set-ribcage-labels! ribcage
      (cons label (ribcage-labels ribcage)))))

;;; make-binding-wrap creates vector-based ribcages
(define make-binding-wrap
  (lambda (ids labels w)
    (if (null? ids)
        w
        (make-wrap
          (wrap-marks w)
          (cons
            (let ((labelvec (list->vector labels)))
              (let ((n (vector-length labelvec)))
                (let ((symnamevec (make-vector n)) (marksvec (make-vector n)))
                  (let f ((ids ids) (i 0))
                    (if (not (null? ids))
                        (call-with-values
                          (lambda () (id-sym-name&marks (car ids) w))
                          (lambda (symname marks)
                            (vector-set! symnamevec i symname)
                            (vector-set! marksvec i marks)
                            (f (cdr ids) (fx+ i 1))))))
                  (make-ribcage symnamevec marksvec labelvec))))
            (wrap-subst w))))))

(define smart-append
  (lambda (m1 m2)
    (if (null? m2)
        m1
        (append m1 m2))))

(define join-wraps
  (lambda (w1 w2)
    (let ((m1 (wrap-marks w1)) (s1 (wrap-subst w1)))
      (if (null? m1)
          (if (null? s1)
              w2
              (make-wrap
                (wrap-marks w2)
                (smart-append s1 (wrap-subst w2))))
          (make-wrap
            (smart-append m1 (wrap-marks w2))
            (smart-append s1 (wrap-subst w2)))))))

(define join-marks
  (lambda (m1 m2)
    (smart-append m1 m2)))

(define same-marks?
  (lambda (x y)
    (or (eq? x y)
        (and (not (null? x))
             (not (null? y))
             (eq? (car x) (car y))
             (same-marks? (cdr x) (cdr y))))))

(define id-var-name
  (lambda (id w)
    (define-syntax first
      (syntax-rules ()
        ((_ e) (call-with-values (lambda () e) (lambda (x . ignore) x)))))
    (define search
      (lambda (sym subst marks)
        (if (null? subst)
            (values #f marks)
            (let ((fst (car subst)))
              (if (eq? fst 'shift)
                  (search sym (cdr subst) (cdr marks))
                  (let ((symnames (ribcage-symnames fst)))
                    (if (vector? symnames)
                        (search-vector-rib sym subst marks symnames fst)
                        (search-list-rib sym subst marks symnames fst))))))))
    (define search-list-rib
      (lambda (sym subst marks symnames ribcage)
        (let f ((symnames symnames) (i 0))
          (cond
            ((null? symnames) (search sym (cdr subst) marks))
            ((and (eq? (car symnames) sym)
                  (same-marks? marks (list-ref (ribcage-marks ribcage) i)))
             (values (list-ref (ribcage-labels ribcage) i) marks))
            (else (f (cdr symnames) (fx+ i 1)))))))
    (define search-vector-rib
      (lambda (sym subst marks symnames ribcage)
        (let ((n (vector-length symnames)))
          (let f ((i 0))
            (cond
              ((fx= i n) (search sym (cdr subst) marks))
              ((and (eq? (vector-ref symnames i) sym)
                    (same-marks? marks (vector-ref (ribcage-marks ribcage) i)))
               (values (vector-ref (ribcage-labels ribcage) i) marks))
              (else (f (fx+ i 1))))))))
    (cond
      ((symbol? id)
       (or (first (search id (wrap-subst w) (wrap-marks w))) id))
      ((syntax-object? id)
        (let ((id (unannotate (syntax-object-expression id)))
              (w1 (syntax-object-wrap id)))
          (let ((marks (join-marks (wrap-marks w) (wrap-marks w1))))
            (call-with-values (lambda () (search id (wrap-subst w) marks))
              (lambda (new-id marks)
                (or new-id
                    (first (search id (wrap-subst w1) marks))
                    id))))))
      ((annotation? id)
       (let ((id (unannotate id)))
         (or (first (search id (wrap-subst w) (wrap-marks w))) id)))
      (else (error-hook 'id-var-name "invalid id" id)))))

;;; free-id=? must be passed fully wrapped ids since (free-id=? x y)
;;; may be true even if (free-id=? (wrap x w) (wrap y w)) is not.

(define free-id=?
  (lambda (i j)
    (and (eq? (id-sym-name i) (id-sym-name j)) ; accelerator
         (eq? (id-var-name i empty-wrap) (id-var-name j empty-wrap)))))

;;; bound-id=? may be passed unwrapped (or partially wrapped) ids as
;;; long as the missing portion of the wrap is common to both of the ids
;;; since (bound-id=? x y) iff (bound-id=? (wrap x w) (wrap y w))

(define bound-id=?
  (lambda (i j)
    (if (and (syntax-object? i) (syntax-object? j))
        (and (eq? (unannotate (syntax-object-expression i))
                  (unannotate (syntax-object-expression j)))
             (same-marks? (wrap-marks (syntax-object-wrap i))
                  (wrap-marks (syntax-object-wrap j))))
        (eq? (unannotate i) (unannotate j)))))

;;; "valid-bound-ids?" returns #t if it receives a list of distinct ids.
;;; valid-bound-ids? may be passed unwrapped (or partially wrapped) ids
;;; as long as the missing portion of the wrap is common to all of the
;;; ids.

(define valid-bound-ids?
  (lambda (ids)
     (and (let all-ids? ((ids ids))
            (or (null? ids)
                (and (id? (car ids))
                     (all-ids? (cdr ids)))))
          (distinct-bound-ids? ids))))

;;; distinct-bound-ids? expects a list of ids and returns #t if there are
;;; no duplicates.  It is quadratic on the length of the id list; long
;;; lists could be sorted to make it more efficient.  distinct-bound-ids?
;;; may be passed unwrapped (or partially wrapped) ids as long as the
;;; missing portion of the wrap is common to all of the ids.

(define distinct-bound-ids?
  (lambda (ids)
    (let distinct? ((ids ids))
      (or (null? ids)
          (and (not (bound-id-member? (car ids) (cdr ids)))
               (distinct? (cdr ids)))))))

(define bound-id-member?
   (lambda (x list)
      (and (not (null? list))
           (or (bound-id=? x (car list))
               (bound-id-member? x (cdr list))))))

;;; wrapping expressions and identifiers

(define wrap
  (lambda (x w)
    (cond
      ((and (null? (wrap-marks w)) (null? (wrap-subst w))) x)
      ((syntax-object? x)
       (make-syntax-object
         (syntax-object-expression x)
         (join-wraps w (syntax-object-wrap x))))
      ((null? x) x)
      (else (make-syntax-object x w)))))

(define source-wrap
  (lambda (x w s)
    (wrap (if s (make-annotation x s #f) x) w)))

;;; expanding

(define chi-sequence
  (lambda (body r w s)
    (build-sequence s
      (let dobody ((body body) (r r) (w w))
        (if (null? body)
            '()
            (let ((first (chi (car body) r w)))
              (cons first (dobody (cdr body) r w))))))))

(define chi-top-sequence
  (lambda (body r w s m esew)
    (build-sequence s
      (let dobody ((body body) (r r) (w w) (m m) (esew esew))
        (if (null? body)
            '()
            (let ((first (chi-top (car body) r w m esew)))
              (cons first (dobody (cdr body) r w m esew))))))))

(define chi-install-global
  (lambda (name e)
    (build-application no-source
      (build-primref no-source 'install-global-transformer)
      (list (build-data no-source name) e))))

(define chi-when-list
  (lambda (e when-list w)
    ; when-list is syntax'd version of list of situations
    (let f ((when-list when-list) (situations '()))
      (if (null? when-list)
          situations
          (f (cdr when-list)
             (cons (let ((x (car when-list)))
                     (cond
                       ((free-id=? x (syntax compile)) 'compile)
                       ((free-id=? x (syntax load)) 'load)
                       ((free-id=? x (syntax eval)) 'eval)
                       (else (syntax-error (wrap x w)
                               "invalid eval-when situation"))))
                   situations))))))

;;; syntax-type returns five values: type, value, e, w, and s.  The first
;;; two are described in the table below.
;;;
;;;    type                   value         explanation
;;;    -------------------------------------------------------------------
;;;    core                   procedure     core form (including singleton)
;;;    external-macro         procedure     external macro
;;;    lexical                name          lexical variable reference
;;;    global                 name          global variable reference
;;;    begin                  none          begin keyword
;;;    define                 none          define keyword
;;;    define-syntax          none          define-syntax keyword
;;;    local-syntax           rec?          letrec-syntax/let-syntax keyword
;;;    eval-when              none          eval-when keyword
;;;    syntax                 level         pattern variable
;;;    displaced-lexical      none          displaced lexical identifier
;;;    lexical-call           name          call to lexical variable
;;;    global-call            name          call to global variable
;;;    call                   none          any other call
;;;    begin-form             none          begin expression
;;;    define-form            id            variable definition
;;;    define-syntax-form     id            syntax definition
;;;    local-syntax-form      rec?          syntax definition
;;;    eval-when-form         none          eval-when form
;;;    constant               none          self-evaluating datum
;;;    other                  none          anything else
;;;
;;; For define-form and define-syntax-form, e is the rhs expression.
;;; For all others, e is the entire form.  w is the wrap for e.
;;; s is the source for the entire form.
;;;
;;; syntax-type expands macros and unwraps as necessary to get to
;;; one of the forms above.  It also parses define and define-syntax
;;; forms, although perhaps this should be done by the consumer.

(define syntax-type
  (lambda (e r w s rib)
    (cond
      ((symbol? e)
       (let* ((n (id-var-name e w))
              (b (lookup n r))
              (type (binding-type b)))
         (case type
           ((lexical) (values type (binding-value b) e w s))
           ((global) (values type n e w s))
           ((macro)
            (syntax-type (chi-macro (binding-value b) e r w rib) r empty-wrap s rib))
           (else (values type (binding-value b) e w s)))))
      ((pair? e)
       (let ((first (car e)))
         (if (id? first)
             (let* ((n (id-var-name first w))
                    (b (lookup n r))
                    (type (binding-type b)))
               (case type
                 ((lexical) (values 'lexical-call (binding-value b) e w s))
                 ((global) (values 'global-call n e w s))
                 ((macro)
                  (syntax-type (chi-macro (binding-value b) e r w rib)
                    r empty-wrap s rib))
                 ((core external-macro) (values type (binding-value b) e w s))
                 ((local-syntax)
                  (values 'local-syntax-form (binding-value b) e w s))
                 ((begin) (values 'begin-form #f e w s))
                 ((eval-when) (values 'eval-when-form #f e w s))
                 ((define)
                  (syntax-case e ()
                    ((_ name val)
                     (id? (syntax name))
                     (values 'define-form (syntax name) (syntax val) w s))
                    ((_ (name . args) e1 e2 ...)
                     (and (id? (syntax name))
                          (valid-bound-ids? (lambda-var-list (syntax args))))
                     ; need lambda here...
                     (values 'define-form (wrap (syntax name) w)
                       (cons (syntax lambda) (wrap (syntax (args e1 e2 ...)) w))
                       empty-wrap s))
                    ((_ name)
                     (id? (syntax name))
                     (values 'define-form (wrap (syntax name) w)
                       (syntax (void))
                       empty-wrap s))))
                 ((define-syntax)
                  (syntax-case e ()
                    ((_ name val)
                     (id? (syntax name))
                     (values 'define-syntax-form (syntax name)
                       (syntax val) w s))))
                 (else (values 'call #f e w s))))
             (values 'call #f e w s))))
      ((syntax-object? e)
       ;; s can't be valid source if we've unwrapped
       (syntax-type (syntax-object-expression e)
                    r
                    (join-wraps w (syntax-object-wrap e))
                    no-source rib))
      ((annotation? e)
       (syntax-type (annotation-expression e) r w (annotation-source e) rib))
      ((self-evaluating? e) (values 'constant #f e w s))
      (else (values 'other #f e w s)))))

(define chi-top
  (lambda (e r w m esew)
    (define-syntax eval-if-c&e
      (syntax-rules ()
        ((_ m e)
         (let ((x e))
           (if (eq? m 'c&e) (top-level-eval-hook x))
           x))))
    (call-with-values
      (lambda () (syntax-type e r w no-source #f))
      (lambda (type value e w s)
        (case type
          ((begin-form)
           (syntax-case e ()
             ((_) (chi-void))
             ((_ e1 e2 ...)
              (chi-top-sequence (syntax (e1 e2 ...)) r w s m esew))))
          ((local-syntax-form)
           (chi-local-syntax value e r w s
             (lambda (body r w s)
               (chi-top-sequence body r w s m esew))))
          ((eval-when-form)
           (syntax-case e ()
             ((_ (x ...) e1 e2 ...)
              (let ((when-list (chi-when-list e (syntax (x ...)) w))
                    (body (syntax (e1 e2 ...))))
                (cond
                  ((eq? m 'e)
                   (if (memq 'eval when-list)
                       (chi-top-sequence body r w s 'e '(eval))
                       (chi-void)))
                  ((memq 'load when-list)
                   (if (or (memq 'compile when-list)
                           (and (eq? m 'c&e) (memq 'eval when-list)))
                       (chi-top-sequence body r w s 'c&e '(compile load))
                       (if (memq m '(c c&e))
                           (chi-top-sequence body r w s 'c '(load))
                           (chi-void))))
                  ((or (memq 'compile when-list)
                       (and (eq? m 'c&e) (memq 'eval when-list)))
                   (top-level-eval-hook
                     (chi-top-sequence body r w s 'e '(eval)))
                   (chi-void))
                  (else (chi-void)))))))
          ((define-syntax-form)
           (let ((n (id-var-name value w)) (r (macros-only-env r)))
             (case m
               ((c)
                (if (memq 'compile esew)
                    (let ((e (chi-install-global n (chi e r w))))
                      (top-level-eval-hook e)
                      (if (memq 'load esew) e (chi-void)))
                    (if (memq 'load esew)
                        (chi-install-global n (chi e r w))
                        (chi-void))))
               ((c&e)
                (let ((e (chi-install-global n (chi e r w))))
                  (top-level-eval-hook e)
                  e))
               (else
                (if (memq 'eval esew)
                    (top-level-eval-hook
                      (chi-install-global n (chi e r w))))
                (chi-void)))))
          ((define-form)
           (let* ((n (id-var-name value w))
		  (type (binding-type (lookup n r))))
             (case type
               ((global)
                (eval-if-c&e m
                  (build-global-definition s n (chi e r w))))
               ((displaced-lexical)
                (syntax-error (wrap value w) "identifier out of context"))
               (else
		(if (eq? type 'external-macro)
		    (eval-if-c&e m
				 (build-global-definition s n (chi e r w)))
		    (syntax-error (wrap value w)
				  "cannot define keyword at top level"))))))
          (else (eval-if-c&e m (chi-expr type value e r w s))))))))

(define chi
  (lambda (e r w)
    (call-with-values
      (lambda () (syntax-type e r w no-source #f))
      (lambda (type value e w s)
        (chi-expr type value e r w s)))))

(define chi-expr
  (lambda (type value e r w s)
    (case type
      ((lexical)
       (build-lexical-reference 'value s value))
      ((core external-macro) (value e r w s))
      ((lexical-call)
       (chi-application
         (build-lexical-reference 'fun (source-annotation (car e)) value)
         e r w s))
      ((global-call)
       (chi-application
         (build-global-reference (source-annotation (car e)) value)
         e r w s))
      ((constant) (build-data s (strip (source-wrap e w s) empty-wrap)))
      ((global) (build-global-reference s value))
      ((call) (chi-application (chi (car e) r w) e r w s))
      ((begin-form)
       (syntax-case e ()
         ((_ e1 e2 ...) (chi-sequence (syntax (e1 e2 ...)) r w s))))
      ((local-syntax-form)
       (chi-local-syntax value e r w s chi-sequence))
      ((eval-when-form)
       (syntax-case e ()
         ((_ (x ...) e1 e2 ...)
          (let ((when-list (chi-when-list e (syntax (x ...)) w)))
            (if (memq 'eval when-list)
                (chi-sequence (syntax (e1 e2 ...)) r w s)
                (chi-void))))))
      ((define-form define-syntax-form)
       (syntax-error (wrap value w) "invalid context for definition of"))
      ((syntax)
       (syntax-error (source-wrap e w s)
         "reference to pattern variable outside syntax form"))
      ((displaced-lexical)
       (syntax-error (source-wrap e w s)
         "reference to identifier outside its scope"))
      (else (syntax-error (source-wrap e w s))))))

(define chi-application
  (lambda (x e r w s)
    (syntax-case e ()
      ((e0 e1 ...)
       (build-application s x
         (map (lambda (e) (chi e r w)) (syntax (e1 ...))))))))

(define chi-macro
  (lambda (p e r w rib)
    (define rebuild-macro-output
      (lambda (x m)
        (cond ((pair? x)
               (cons (rebuild-macro-output (car x) m)
                     (rebuild-macro-output (cdr x) m)))
              ((syntax-object? x)
               (let ((w (syntax-object-wrap x)))
                 (let ((ms (wrap-marks w)) (s (wrap-subst w)))
                   (make-syntax-object (syntax-object-expression x)
                     (if (and (pair? ms) (eq? (car ms) the-anti-mark))
                         (make-wrap (cdr ms)
                           (if rib (cons rib (cdr s)) (cdr s)))
                         (make-wrap (cons m ms)
                           (if rib
                               (cons rib (cons 'shift s))
                               (cons 'shift s))))))))
              ((vector? x)
               (let* ((n (vector-length x)) (v (make-vector n)))
                 (do ((i 0 (fx+ i 1)))
                     ((fx= i n) v)
                     (vector-set! v i
                       (rebuild-macro-output (vector-ref x i) m)))))
              ((symbol? x)
               (syntax-error x "encountered raw symbol in macro output"))
              (else x))))
    (rebuild-macro-output (p (wrap e (anti-mark w))) (new-mark))))

(define chi-body
  ;; In processing the forms of the body, we create a new, empty wrap.
  ;; This wrap is augmented (destructively) each time we discover that
  ;; the next form is a definition.  This is done:
  ;;
  ;;   (1) to allow the first nondefinition form to be a call to
  ;;       one of the defined ids even if the id previously denoted a
  ;;       definition keyword or keyword for a macro expanding into a
  ;;       definition;
  ;;   (2) to prevent subsequent definition forms (but unfortunately
  ;;       not earlier ones) and the first nondefinition form from
  ;;       confusing one of the bound identifiers for an auxiliary
  ;;       keyword; and
  ;;   (3) so that we do not need to restart the expansion of the
  ;;       first nondefinition form, which is problematic anyway
  ;;       since it might be the first element of a begin that we
  ;;       have just spliced into the body (meaning if we restarted,
  ;;       we'd really need to restart with the begin or the macro
  ;;       call that expanded into the begin, and we'd have to give
  ;;       up allowing (begin <defn>+ <expr>+), which is itself
  ;;       problematic since we don't know if a begin contains only
  ;;       definitions until we've expanded it).
  ;;
  ;; Before processing the body, we also create a new environment
  ;; containing a placeholder for the bindings we will add later and
  ;; associate this environment with each form.  In processing a
  ;; let-syntax or letrec-syntax, the associated environment may be
  ;; augmented with local keyword bindings, so the environment may
  ;; be different for different forms in the body.  Once we have
  ;; gathered up all of the definitions, we evaluate the transformer
  ;; expressions and splice into r at the placeholder the new variable
  ;; and keyword bindings.  This allows let-syntax or letrec-syntax
  ;; forms local to a portion or all of the body to shadow the
  ;; definition bindings.
  ;;
  ;; Subforms of a begin, let-syntax, or letrec-syntax are spliced
  ;; into the body.
  ;;
  ;; outer-form is fully wrapped w/source
  (lambda (body outer-form r w)
    (let* ((r (cons '("placeholder" . (placeholder)) r))
           (ribcage (make-empty-ribcage))
           (w (make-wrap (wrap-marks w) (cons ribcage (wrap-subst w)))))
      (let parse ((body (map (lambda (x) (cons r (wrap x w))) body))
                  (ids '()) (labels '()) (vars '()) (vals '()) (bindings '()))
        (if (null? body)
            (syntax-error outer-form "no expressions in body")
            (let ((e (cdar body)) (er (caar body)))
              (call-with-values
                (lambda () (syntax-type e er empty-wrap no-source ribcage))
                (lambda (type value e w s)
                  (case type
                    ((define-form)
                     (let ((id (wrap value w)) (label (gen-label)))
                       (let ((var (gen-var id)))
                         (extend-ribcage! ribcage id label)
                         (parse (cdr body)
                           (cons id ids) (cons label labels)
                           (cons var vars) (cons (cons er (wrap e w)) vals)
                           (cons (make-binding 'lexical var) bindings)))))
                    ((define-syntax-form)
                     (let ((id (wrap value w)) (label (gen-label)))
                       (extend-ribcage! ribcage id label)
                       (parse (cdr body)
                         (cons id ids) (cons label labels)
                         vars vals
                         (cons (make-binding 'macro (cons er (wrap e w)))
                               bindings))))
                    ((begin-form)
                     (syntax-case e ()
                       ((_ e1 ...)
                        (parse (let f ((forms (syntax (e1 ...))))
                                 (if (null? forms)
                                     (cdr body)
                                     (cons (cons er (wrap (car forms) w))
                                           (f (cdr forms)))))
                          ids labels vars vals bindings))))
                    ((local-syntax-form)
                     (chi-local-syntax value e er w s
                       (lambda (forms er w s)
                         (parse (let f ((forms forms))
                                  (if (null? forms)
                                      (cdr body)
                                      (cons (cons er (wrap (car forms) w))
                                            (f (cdr forms)))))
                           ids labels vars vals bindings))))
                    (else ; found a non-definition
                     (if (null? ids)
                         (build-sequence no-source
                           (map (lambda (x)
                                  (chi (cdr x) (car x) empty-wrap))
                                (cons (cons er (source-wrap e w s))
                                      (cdr body))))
                         (begin
                           (if (not (valid-bound-ids? ids))
                               (syntax-error outer-form
                                 "invalid or duplicate identifier in definition"))
                           (let loop ((bs bindings) (er-cache #f) (r-cache #f))
                             (if (not (null? bs))
                                 (let* ((b (car bs)))
                                   (if (eq? (car b) 'macro)
                                       (let* ((er (cadr b))
                                              (r-cache
                                                (if (eq? er er-cache)
                                                    r-cache
                                                    (macros-only-env er))))
                                         (set-cdr! b
                                           (eval-local-transformer
                                             (chi (cddr b) r-cache empty-wrap)))
                                         (loop (cdr bs) er r-cache))
                                       (loop (cdr bs) er-cache r-cache)))))
                           (set-cdr! r (extend-env labels bindings (cdr r)))
                           (build-letrec no-source
                             vars
                             (map (lambda (x)
                                    (chi (cdr x) (car x) empty-wrap))
                                  vals)
                             (build-sequence no-source
                               (map (lambda (x)
                                      (chi (cdr x) (car x) empty-wrap))
                                    (cons (cons er (source-wrap e w s))
                                          (cdr body)))))))))))))))))

(define chi-lambda-clause
  (lambda (e c r w k)
    (syntax-case c ()
      (((id ...) e1 e2 ...)
       (let ((ids (syntax (id ...))))
         (if (not (valid-bound-ids? ids))
             (syntax-error e "invalid parameter list in")
             (let ((labels (gen-labels ids))
                   (new-vars (map gen-var ids)))
               (k new-vars
                  (chi-body (syntax (e1 e2 ...))
                            e
                            (extend-var-env labels new-vars r)
                            (make-binding-wrap ids labels w)))))))
      ((ids e1 e2 ...)
       (let ((old-ids (lambda-var-list (syntax ids))))
         (if (not (valid-bound-ids? old-ids))
             (syntax-error e "invalid parameter list in")
             (let ((labels (gen-labels old-ids))
                   (new-vars (map gen-var old-ids)))
               (k (let f ((ls1 (cdr new-vars)) (ls2 (car new-vars)))
                    (if (null? ls1)
                        ls2
                        (f (cdr ls1) (cons (car ls1) ls2))))
                  (chi-body (syntax (e1 e2 ...))
                            e
                            (extend-var-env labels new-vars r)
                            (make-binding-wrap old-ids labels w)))))))
      (_ (syntax-error e)))))

(define chi-local-syntax
  (lambda (rec? e r w s k)
    (syntax-case e ()
      ((_ ((id val) ...) e1 e2 ...)
       (let ((ids (syntax (id ...))))
         (if (not (valid-bound-ids? ids))
             (syntax-error e "duplicate bound keyword in")
             (let ((labels (gen-labels ids)))
               (let ((new-w (make-binding-wrap ids labels w)))
                 (k (syntax (e1 e2 ...))
                    (extend-env
                      labels
                      (let ((w (if rec? new-w w))
                            (trans-r (macros-only-env r)))
                        (map (lambda (x)
                               (make-binding 'macro
                                 (eval-local-transformer (chi x trans-r w))))
                             (syntax (val ...))))
                      r)
                    new-w
                    s))))))
      (_ (syntax-error (source-wrap e w s))))))

(define eval-local-transformer
  (lambda (expanded)
    (let ((p (local-eval-hook expanded)))
      (if (procedure? p)
          p
          (syntax-error p "nonprocedure transformer")))))

(define chi-void
  (lambda ()
    (build-application no-source (build-primref no-source 'void) '())))

(define ellipsis?
  (lambda (x)
    (and (nonsymbol-id? x)
         (free-id=? x (syntax (... ...))))))

;;; data

;;; strips all annotations from potentially circular reader output

(define strip-annotation
  (lambda (x parent)
    (cond
      ((pair? x)
       (let ((new (cons #f #f)))
         (when parent (set-annotation-stripped! parent new))
         (set-car! new (strip-annotation (car x) #f))
         (set-cdr! new (strip-annotation (cdr x) #f))
         new))
      ((annotation? x)
       (or (annotation-stripped x)
           (strip-annotation (annotation-expression x) x)))
      ((vector? x)
       (let ((new (make-vector (vector-length x))))
         (when parent (set-annotation-stripped! parent new))
         (let loop ((i (- (vector-length x) 1)))
           (unless (fx< i 0)
             (vector-set! new i (strip-annotation (vector-ref x i) #f))
             (loop (fx- i 1))))
         new))
      (else x))))

;;; strips syntax-objects down to top-wrap; if top-wrap is layered directly
;;; on an annotation, strips the annotation as well.
;;; since only the head of a list is annotated by the reader, not each pair
;;; in the spine, we also check for pairs whose cars are annotated in case
;;; we've been passed the cdr of an annotated list

(define strip
  (lambda (x w)
    (if (top-marked? w)
        (if (or (annotation? x) (and (pair? x) (annotation? (car x))))
            (strip-annotation x #f)
            x)
        (let f ((x x))
          (cond
            ((syntax-object? x)
             (strip (syntax-object-expression x) (syntax-object-wrap x)))
            ((pair? x)
             (let ((a (f (car x))) (d (f (cdr x))))
               (if (and (eq? a (car x)) (eq? d (cdr x)))
                   x
                   (cons a d))))
            ((vector? x)
             (let ((old (vector->list x)))
                (let ((new (map f old)))
                   (if (andmap eq? old new) x (list->vector new)))))
            (else x))))))

;;; lexical variables

(define gen-var
  (lambda (id)
    (let ((id (if (syntax-object? id) (syntax-object-expression id) id)))
      (if (annotation? id)
          (build-lexical-var (annotation-source id) (annotation-expression id))
          (build-lexical-var no-source id)))))

(define lambda-var-list
  (lambda (vars)
    (let lvl ((vars vars) (ls '()) (w empty-wrap))
       (cond
         ((pair? vars) (lvl (cdr vars) (cons (wrap (car vars) w) ls) w))
         ((id? vars) (cons (wrap vars w) ls))
         ((null? vars) ls)
         ((syntax-object? vars)
          (lvl (syntax-object-expression vars)
               ls
               (join-wraps w (syntax-object-wrap vars))))
         ((annotation? vars)
          (lvl (annotation-expression vars) ls w))
       ; include anything else to be caught by subsequent error
       ; checking
         (else (cons vars ls))))))

;;; core transformers

(global-extend 'local-syntax 'letrec-syntax #t)
(global-extend 'local-syntax 'let-syntax #f)

(global-extend 'core 'fluid-let-syntax
  (lambda (e r w s)
    (syntax-case e ()
      ((_ ((var val) ...) e1 e2 ...)
       (valid-bound-ids? (syntax (var ...)))
       (let ((names (map (lambda (x) (id-var-name x w)) (syntax (var ...)))))
         (for-each
           (lambda (id n)
             (case (binding-type (lookup n r))
               ((displaced-lexical)
                (syntax-error (source-wrap id w s)
                  "identifier out of context"))))
           (syntax (var ...))
           names)
         (chi-body
           (syntax (e1 e2 ...))
           (source-wrap e w s)
           (extend-env
             names
             (let ((trans-r (macros-only-env r)))
               (map (lambda (x)
                      (make-binding 'macro
                        (eval-local-transformer (chi x trans-r w))))
                    (syntax (val ...))))
             r)
           w)))
      (_ (syntax-error (source-wrap e w s))))))

(global-extend 'core 'quote
   (lambda (e r w s)
      (syntax-case e ()
         ((_ e) (build-data s (strip (syntax e) w)))
         (_ (syntax-error (source-wrap e w s))))))

(global-extend 'core 'syntax
  (let ()
    (define gen-syntax
      (lambda (src e r maps ellipsis?)
        (if (id? e)
            (let ((label (id-var-name e empty-wrap)))
              (let ((b (lookup label r)))
                (if (eq? (binding-type b) 'syntax)
                    (call-with-values
                      (lambda ()
                        (let ((var.lev (binding-value b)))
                          (gen-ref src (car var.lev) (cdr var.lev) maps)))
                      (lambda (var maps) (values `(ref ,var) maps)))
                    (if (ellipsis? e)
                        (syntax-error src "misplaced ellipsis in syntax form")
                        (values `(quote ,e) maps)))))
            (syntax-case e ()
              ((dots e)
               (ellipsis? (syntax dots))
               (gen-syntax src (syntax e) r maps (lambda (x) #f)))
              ((x dots . y)
               ; this could be about a dozen lines of code, except that we
               ; choose to handle (syntax (x ... ...)) forms
               (ellipsis? (syntax dots))
               (let f ((y (syntax y))
                       (k (lambda (maps)
                            (call-with-values
                              (lambda ()
                                (gen-syntax src (syntax x) r
                                  (cons '() maps) ellipsis?))
                              (lambda (x maps)
                                (if (null? (car maps))
                                    (syntax-error src
                                      "extra ellipsis in syntax form")
                                    (values (gen-map x (car maps))
                                            (cdr maps))))))))
                 (syntax-case y ()
                   ((dots . y)
                    (ellipsis? (syntax dots))
                    (f (syntax y)
                       (lambda (maps)
                         (call-with-values
                           (lambda () (k (cons '() maps)))
                           (lambda (x maps)
                             (if (null? (car maps))
                                 (syntax-error src
                                   "extra ellipsis in syntax form")
                                 (values (gen-mappend x (car maps))
                                         (cdr maps))))))))
                   (_ (call-with-values
                        (lambda () (gen-syntax src y r maps ellipsis?))
                        (lambda (y maps)
                          (call-with-values
                            (lambda () (k maps))
                            (lambda (x maps)
                              (values (gen-append x y) maps)))))))))
              ((x . y)
               (call-with-values
                 (lambda () (gen-syntax src (syntax x) r maps ellipsis?))
                 (lambda (x maps)
                   (call-with-values
                     (lambda () (gen-syntax src (syntax y) r maps ellipsis?))
                     (lambda (y maps) (values (gen-cons x y) maps))))))
              (#(e1 e2 ...)
               (call-with-values
                 (lambda ()
                   (gen-syntax src (syntax (e1 e2 ...)) r maps ellipsis?))
                 (lambda (e maps) (values (gen-vector e) maps))))
              (_ (values `(quote ,e) maps))))))

    (define gen-ref
      (lambda (src var level maps)
        (if (fx= level 0)
            (values var maps)
            (if (null? maps)
                (syntax-error src "missing ellipsis in syntax form")
                (call-with-values
                  (lambda () (gen-ref src var (fx- level 1) (cdr maps)))
                  (lambda (outer-var outer-maps)
                    (let ((b (assq outer-var (car maps))))
                      (if b
                          (values (cdr b) maps)
                          (let ((inner-var (gen-var 'tmp)))
                            (values inner-var
                                    (cons (cons (cons outer-var inner-var)
                                                (car maps))
                                          outer-maps)))))))))))

    (define gen-mappend
      (lambda (e map-env)
        `(apply (primitive append) ,(gen-map e map-env))))

    (define gen-map
      (lambda (e map-env)
        (let ((formals (map cdr map-env))
              (actuals (map (lambda (x) `(ref ,(car x))) map-env)))
          (cond
            ((eq? (car e) 'ref)
             ; identity map equivalence:
             ; (map (lambda (x) x) y) == y
             (car actuals))
            ((andmap
                (lambda (x) (and (eq? (car x) 'ref) (memq (cadr x) formals)))
                (cdr e))
             ; eta map equivalence:
             ; (map (lambda (x ...) (f x ...)) y ...) == (map f y ...)
             `(map (primitive ,(car e))
                   ,@(map (let ((r (map cons formals actuals)))
                            (lambda (x) (cdr (assq (cadr x) r))))
                          (cdr e))))
            (else `(map (lambda ,formals ,e) ,@actuals))))))

    (define gen-cons
      (lambda (x y)
        (case (car y)
          ((quote)
           (if (eq? (car x) 'quote)
               `(quote (,(cadr x) . ,(cadr y)))
               (if (eq? (cadr y) '())
                   `(list ,x)
                   `(cons ,x ,y))))
          ((list) `(list ,x ,@(cdr y)))
          (else `(cons ,x ,y)))))

    (define gen-append
      (lambda (x y)
        (if (equal? y '(quote ()))
            x
            `(append ,x ,y))))

    (define gen-vector
      (lambda (x)
        (cond
          ((eq? (car x) 'list) `(vector ,@(cdr x)))
          ((eq? (car x) 'quote) `(quote #(,@(cadr x))))
          (else `(list->vector ,x)))))


    (define regen
      (lambda (x)
        (case (car x)
          ((ref) (build-lexical-reference 'value no-source (cadr x)))
          ((primitive) (build-primref no-source (cadr x)))
          ((quote) (build-data no-source (cadr x)))
          ((lambda) (build-lambda no-source (cadr x) (regen (caddr x))))
          ((map) (let ((ls (map regen (cdr x))))
                   (build-application no-source
                     (if (fx= (length ls) 2)
                         (build-primref no-source 'map)
                        ; really need to do our own checking here
                         (build-primref no-source 2 'map)) ; require error check
                     ls)))
          (else (build-application no-source
                  (build-primref no-source (car x))
                  (map regen (cdr x)))))))

    (lambda (e r w s)
      (let ((e (source-wrap e w s)))
        (syntax-case e ()
          ((_ x)
           (call-with-values
             (lambda () (gen-syntax e (syntax x) r '() ellipsis?))
             (lambda (e maps) (regen e))))
          (_ (syntax-error e)))))))


(global-extend 'core 'lambda
   (lambda (e r w s)
      (syntax-case e ()
         ((_ . c)
          (chi-lambda-clause (source-wrap e w s) (syntax c) r w
            (lambda (vars body) (build-lambda s vars body)))))))


(global-extend 'core 'let
  (let ()
    (define (chi-let e r w s constructor ids vals exps)
      (if (not (valid-bound-ids? ids))
	  (syntax-error e "duplicate bound variable in")
	  (let ((labels (gen-labels ids))
		(new-vars (map gen-var ids)))
	    (let ((nw (make-binding-wrap ids labels w))
		  (nr (extend-var-env labels new-vars r)))
	      (constructor s
			   new-vars
			   (map (lambda (x) (chi x r w)) vals)
			   (chi-body exps (source-wrap e nw s) nr nw))))))
    (lambda (e r w s)
      (syntax-case e ()
	((_ ((id val) ...) e1 e2 ...)
	 (chi-let e r w s
		  build-let
		  (syntax (id ...))
		  (syntax (val ...))
		  (syntax (e1 e2 ...))))
	((_ f ((id val) ...) e1 e2 ...)
	 (id? (syntax f))
	 (chi-let e r w s
		  build-named-let
		  (syntax (f id ...))
		  (syntax (val ...))
		  (syntax (e1 e2 ...))))
	(_ (syntax-error (source-wrap e w s)))))))


(global-extend 'core 'letrec
  (lambda (e r w s)
    (syntax-case e ()
      ((_ ((id val) ...) e1 e2 ...)
       (let ((ids (syntax (id ...))))
         (if (not (valid-bound-ids? ids))
             (syntax-error e "duplicate bound variable in")
             (let ((labels (gen-labels ids))
                   (new-vars (map gen-var ids)))
               (let ((w (make-binding-wrap ids labels w))
                    (r (extend-var-env labels new-vars r)))
                 (build-letrec s
                   new-vars
                   (map (lambda (x) (chi x r w)) (syntax (val ...)))
                   (chi-body (syntax (e1 e2 ...)) (source-wrap e w s) r w)))))))
      (_ (syntax-error (source-wrap e w s))))))


(global-extend 'core 'set!
  (lambda (e r w s)
    (syntax-case e ()
      ((_ id val)
       (id? (syntax id))
       (let ((val (chi (syntax val) r w))
             (n (id-var-name (syntax id) w)))
         (let ((b (lookup n r)))
           (case (binding-type b)
             ((lexical)
              (build-lexical-assignment s (binding-value b) val))
             ((global) (build-global-assignment s n val))
             ((displaced-lexical)
              (syntax-error (wrap (syntax id) w)
                "identifier out of context"))
             (else (syntax-error (source-wrap e w s)))))))
      ((_ (getter arg ...) val)
       (build-application s
			  (chi (syntax (setter getter)) r w)
			  (map (lambda (e) (chi e r w))
			       (syntax (arg ... val)))))
      (_ (syntax-error (source-wrap e w s))))))

(global-extend 'begin 'begin '())

(global-extend 'define 'define '())

(global-extend 'define-syntax 'define-syntax '())

(global-extend 'eval-when 'eval-when '())

(global-extend 'core 'syntax-case
  (let ()
    (define convert-pattern
      ; accepts pattern & keys
      ; returns syntax-dispatch pattern & ids
      (lambda (pattern keys)
        (let cvt ((p pattern) (n 0) (ids '()))
          (if (id? p)
              (if (bound-id-member? p keys)
                  (values (vector 'free-id p) ids)
                  (values 'any (cons (cons p n) ids)))
              (syntax-case p ()
                ((x dots)
                 (ellipsis? (syntax dots))
                 (call-with-values
                   (lambda () (cvt (syntax x) (fx+ n 1) ids))
                   (lambda (p ids)
                     (values (if (eq? p 'any) 'each-any (vector 'each p))
                             ids))))
                ((x . y)
                 (call-with-values
                   (lambda () (cvt (syntax y) n ids))
                   (lambda (y ids)
                     (call-with-values
                       (lambda () (cvt (syntax x) n ids))
                       (lambda (x ids)
                         (values (cons x y) ids))))))
                (() (values '() ids))
                (#(x ...)
                 (call-with-values
                   (lambda () (cvt (syntax (x ...)) n ids))
                   (lambda (p ids) (values (vector 'vector p) ids))))
                (x (values (vector 'atom (strip p empty-wrap)) ids)))))))

    (define build-dispatch-call
      (lambda (pvars exp y r)
        (let ((ids (map car pvars)) (levels (map cdr pvars)))
          (let ((labels (gen-labels ids)) (new-vars (map gen-var ids)))
            (build-application no-source
              (build-primref no-source 'apply)
              (list (build-lambda no-source new-vars
                      (chi exp
                         (extend-env
                             labels
                             (map (lambda (var level)
                                    (make-binding 'syntax `(,var . ,level)))
                                  new-vars
                                  (map cdr pvars))
                             r)
                           (make-binding-wrap ids labels empty-wrap)))
                    y))))))

    (define gen-clause
      (lambda (x keys clauses r pat fender exp)
        (call-with-values
          (lambda () (convert-pattern pat keys))
          (lambda (p pvars)
            (cond
              ((not (distinct-bound-ids? (map car pvars)))
               (syntax-error pat
                 "duplicate pattern variable in syntax-case pattern"))
              ((not (andmap (lambda (x) (not (ellipsis? (car x)))) pvars))
               (syntax-error pat
                 "misplaced ellipsis in syntax-case pattern"))
              (else
               (let ((y (gen-var 'tmp)))
                 ; fat finger binding and references to temp variable y
                 (build-application no-source
                   (build-lambda no-source (list y)
                     (let ((y (build-lexical-reference 'value no-source y)))
                       (build-conditional no-source
                         (syntax-case fender ()
                           (#t y)
                           (_ (build-conditional no-source
                                y
                                (build-dispatch-call pvars fender y r)
                                (build-data no-source #f))))
                         (build-dispatch-call pvars exp y r)
                         (gen-syntax-case x keys clauses r))))
                   (list (if (eq? p 'any)
                             (build-application no-source
                               (build-primref no-source 'list)
                               (list x))
                             (build-application no-source
                               (build-primref no-source 'syntax-dispatch)
                               (list x (build-data no-source p)))))))))))))

    (define gen-syntax-case
      (lambda (x keys clauses r)
        (if (null? clauses)
            (build-application no-source
              (build-primref no-source 'syntax-error)
              (list x))
            (syntax-case (car clauses) ()
              ((pat exp)
               (if (and (id? (syntax pat))
                        (andmap (lambda (x) (not (free-id=? (syntax pat) x)))
                          (cons (syntax (... ...)) keys)))
                   (let ((labels (list (gen-label)))
                         (var (gen-var (syntax pat))))
                     (build-application no-source
                       (build-lambda no-source (list var)
                         (chi (syntax exp)
                              (extend-env labels
                                (list (make-binding 'syntax `(,var . 0)))
                                r)
                              (make-binding-wrap (syntax (pat))
                                labels empty-wrap)))
                       (list x)))
                   (gen-clause x keys (cdr clauses) r
                     (syntax pat) #t (syntax exp))))
              ((pat fender exp)
               (gen-clause x keys (cdr clauses) r
                 (syntax pat) (syntax fender) (syntax exp)))
              (_ (syntax-error (car clauses) "invalid syntax-case clause"))))))

    (lambda (e r w s)
      (let ((e (source-wrap e w s)))
        (syntax-case e ()
          ((_ val (key ...) m ...)
           (if (andmap (lambda (x) (and (id? x) (not (ellipsis? x))))
                       (syntax (key ...)))
               (let ((x (gen-var 'tmp)))
                 ; fat finger binding and references to temp variable x
                 (build-application s
                   (build-lambda no-source (list x)
                     (gen-syntax-case (build-lexical-reference 'value no-source x)
                       (syntax (key ...)) (syntax (m ...))
                       r))
                   (list (chi (syntax val) r empty-wrap))))
               (syntax-error e "invalid literals list in"))))))))

;;; The portable sc-expand seeds chi-top's mode m with 'e (for
;;; evaluating) and esew (which stands for "eval syntax expanders
;;; when") with '(eval).  In Chez Scheme, m is set to 'c instead of e
;;; if we are compiling a file, and esew is set to
;;; (eval-syntactic-expanders-when), which defaults to the list
;;; '(compile load eval).  This means that, by default, top-level
;;; syntactic definitions are evaluated immediately after they are
;;; expanded, and the expanded definitions are also residualized into
;;; the object file if we are compiling a file.
(set! sc-expand
  (let ((m 'e) (esew '(eval)))
    (lambda (x)
      (if (and (pair? x) (equal? (car x) noexpand))
          (cadr x)
          (chi-top x null-env top-wrap m esew)))))

(set! sc-expand3
  (let ((m 'e) (esew '(eval)))
    (lambda (x . rest)
      (if (and (pair? x) (equal? (car x) noexpand))
          (cadr x)
          (chi-top x
		   null-env
		   top-wrap
		   (if (null? rest) m (car rest))
		   (if (or (null? rest) (null? (cdr rest)))
		       esew
		       (cadr rest)))))))

(set! identifier?
  (lambda (x)
    (nonsymbol-id? x)))

(set! datum->syntax-object
  (lambda (id datum)
    (make-syntax-object datum (syntax-object-wrap id))))

(set! syntax-object->datum
  ; accepts any object, since syntax objects may consist partially
  ; or entirely of unwrapped, nonsymbolic data
  (lambda (x)
    (strip x empty-wrap)))

(set! generate-temporaries
  (lambda (ls)
    (arg-check list? ls 'generate-temporaries)
    (map (lambda (x) (wrap (gensym-hook) top-wrap)) ls)))

(set! free-identifier=?
   (lambda (x y)
      (arg-check nonsymbol-id? x 'free-identifier=?)
      (arg-check nonsymbol-id? y 'free-identifier=?)
      (free-id=? x y)))

(set! bound-identifier=?
   (lambda (x y)
      (arg-check nonsymbol-id? x 'bound-identifier=?)
      (arg-check nonsymbol-id? y 'bound-identifier=?)
      (bound-id=? x y)))

(set! syntax-error
  (lambda (object . messages)
    (for-each (lambda (x) (arg-check string? x 'syntax-error)) messages)
    (let ((message (if (null? messages)
                       "invalid syntax"
                       (apply string-append messages))))
      (error-hook #f message (strip object empty-wrap)))))

(set! install-global-transformer
  (lambda (sym v)
    (arg-check symbol? sym 'define-syntax)
    (arg-check procedure? v 'define-syntax)
    (global-extend 'macro sym v)))

;;; syntax-dispatch expects an expression and a pattern.  If the expression
;;; matches the pattern a list of the matching expressions for each
;;; "any" is returned.  Otherwise, #f is returned.  (This use of #f will
;;; not work on r4rs implementations that violate the ieee requirement
;;; that #f and () be distinct.)

;;; The expression is matched with the pattern as follows:

;;; pattern:                           matches:
;;;   ()                                 empty list
;;;   any                                anything
;;;   (<pattern>1 . <pattern>2)          (<pattern>1 . <pattern>2)
;;;   each-any                           (any*)
;;;   #(free-id <key>)                   <key> with free-identifier=?
;;;   #(each <pattern>)                  (<pattern>*)
;;;   #(vector <pattern>)                (list->vector <pattern>)
;;;   #(atom <object>)                   <object> with "equal?"

;;; Vector cops out to pair under assumption that vectors are rare.  If
;;; not, should convert to:
;;;   #(vector <pattern>*)               #(<pattern>*)

(let ()

(define match-each
  (lambda (e p w)
    (cond
      ((annotation? e)
       (match-each (annotation-expression e) p w))
      ((pair? e)
       (let ((first (match (car e) p w '())))
         (and first
              (let ((rest (match-each (cdr e) p w)))
                 (and rest (cons first rest))))))
      ((null? e) '())
      ((syntax-object? e)
       (match-each (syntax-object-expression e)
                   p
                   (join-wraps w (syntax-object-wrap e))))
      (else #f))))

(define match-each-any
  (lambda (e w)
    (cond
      ((annotation? e)
       (match-each-any (annotation-expression e) w))
      ((pair? e)
       (let ((l (match-each-any (cdr e) w)))
         (and l (cons (wrap (car e) w) l))))
      ((null? e) '())
      ((syntax-object? e)
       (match-each-any (syntax-object-expression e)
                       (join-wraps w (syntax-object-wrap e))))
      (else #f))))

(define match-empty
  (lambda (p r)
    (cond
      ((null? p) r)
      ((eq? p 'any) (cons '() r))
      ((pair? p) (match-empty (car p) (match-empty (cdr p) r)))
      ((eq? p 'each-any) (cons '() r))
      (else
       (case (vector-ref p 0)
         ((each) (match-empty (vector-ref p 1) r))
         ((free-id atom) r)
         ((vector) (match-empty (vector-ref p 1) r)))))))

(define match*
  (lambda (e p w r)
    (cond
      ((null? p) (and (null? e) r))
      ((pair? p)
       (and (pair? e) (match (car e) (car p) w
                        (match (cdr e) (cdr p) w r))))
      ((eq? p 'each-any)
       (let ((l (match-each-any e w))) (and l (cons l r))))
      (else
       (case (vector-ref p 0)
         ((each)
          (if (null? e)
              (match-empty (vector-ref p 1) r)
              (let ((l (match-each e (vector-ref p 1) w)))
                (and l
                     (let collect ((l l))
                       (if (null? (car l))
                           r
                           (cons (map car l) (collect (map cdr l)))))))))
         ((free-id) (and (id? e) (free-id=? (wrap e w) (vector-ref p 1)) r))
         ((atom) (and (equal? (vector-ref p 1) (strip e w)) r))
         ((vector)
          (and (vector? e)
               (match (vector->list e) (vector-ref p 1) w r))))))))

(define match
  (lambda (e p w r)
    (cond
      ((not r) #f)
      ((eq? p 'any) (cons (wrap e w) r))
      ((syntax-object? e)
       (match*
         (unannotate (syntax-object-expression e))
         p
         (join-wraps w (syntax-object-wrap e))
         r))
      (else (match* (unannotate e) p w r)))))

(set! syntax-dispatch
  (lambda (e p)
    (cond
      ((eq? p 'any) (list e))
      ((syntax-object? e)
       (match* (unannotate (syntax-object-expression e))
         p (syntax-object-wrap e) '()))
      (else (match* (unannotate e) p empty-wrap '())))))

(set! sc-chi chi)
))
)

(define-syntax with-syntax
   (lambda (x)
      (syntax-case x ()
         ((_ () e1 e2 ...)
          (syntax (begin e1 e2 ...)))
         ((_ ((out in)) e1 e2 ...)
          (syntax (syntax-case in () (out (begin e1 e2 ...)))))
         ((_ ((out in) ...) e1 e2 ...)
          (syntax (syntax-case (list in ...) ()
                     ((out ...) (begin e1 e2 ...))))))))

(define-syntax syntax-rules
  (lambda (x)
    (syntax-case x ()
      ((_ (k ...) ((keyword . pattern) template) ...)
       (syntax (lambda (x)
                (syntax-case x (k ...)
                  ((dummy . pattern) (syntax template))
                  ...)))))))

(define-syntax let*
  (lambda (x)
    (syntax-case x ()
      ((let* ((x v) ...) e1 e2 ...)
       (andmap identifier? (syntax (x ...)))
       (let f ((bindings (syntax ((x v)  ...))))
         (if (null? bindings)
             (syntax (let () e1 e2 ...))
             (with-syntax ((body (f (cdr bindings)))
                           (binding (car bindings)))
               (syntax (let (binding) body)))))))))

(define-syntax do
   (lambda (orig-x)
      (syntax-case orig-x ()
         ((_ ((var init . step) ...) (e0 e1 ...) c ...)
          (with-syntax (((step ...)
                         (map (lambda (v s)
                                 (syntax-case s ()
                                    (() v)
                                    ((e) (syntax e))
                                    (_ (syntax-error orig-x))))
                              (syntax (var ...))
                              (syntax (step ...)))))
             (syntax-case (syntax (e1 ...)) ()
                (() (syntax (let doloop ((var init) ...)
                               (if (not e0)
                                   (begin c ... (doloop step ...))))))
                ((e1 e2 ...)
                 (syntax (let doloop ((var init) ...)
                            (if e0
                                (begin e1 e2 ...)
                                (begin c ... (doloop step ...))))))))))))

(define-syntax quasiquote
   (letrec
      ((quasicons
        (lambda (x y)
          (with-syntax ((x x) (y y))
            (syntax-case (syntax y) (quote list)
              ((quote dy)
               (syntax-case (syntax x) (quote)
                 ((quote dx) (syntax (quote (dx . dy))))
                 (_ (if (null? (syntax dy))
                        (syntax (list x))
                        (syntax (cons x y))))))
              ((list . stuff) (syntax (list x . stuff)))
              (else (syntax (cons x y)))))))
       (quasiappend
        (lambda (x y)
          (with-syntax ((x x) (y y))
            (syntax-case (syntax y) (quote)
              ((quote ()) (syntax x))
              (_ (syntax (append x y)))))))
       (quasivector
        (lambda (x)
          (with-syntax ((x x))
            (syntax-case (syntax x) (quote list)
              ((quote (x ...)) (syntax (quote #(x ...))))
              ((list x ...) (syntax (vector x ...)))
              (_ (syntax (list->vector x)))))))
       (quasi
        (lambda (p lev)
           (syntax-case p (unquote unquote-splicing quasiquote)
              ((unquote p)
               (if (= lev 0)
                   (syntax p)
                   (quasicons (syntax (quote unquote))
                              (quasi (syntax (p)) (- lev 1)))))
              (((unquote-splicing p) . q)
               (if (= lev 0)
                   (quasiappend (syntax p) (quasi (syntax q) lev))
                   (quasicons (quasicons (syntax (quote unquote-splicing))
                                         (quasi (syntax (p)) (- lev 1)))
                              (quasi (syntax q) lev))))
              ((quasiquote p)
               (quasicons (syntax (quote quasiquote))
                          (quasi (syntax (p)) (+ lev 1))))
              ((p . q)
               (quasicons (quasi (syntax p) lev) (quasi (syntax q) lev)))
              (#(x ...) (quasivector (quasi (syntax (x ...)) lev)))
              (p (syntax (quote p)))))))
    (lambda (x)
       (syntax-case x ()
          ((_ e) (quasi (syntax e) 0))))))

(define-syntax include
  (lambda (x)
    (define read-file
      (lambda (fn k)
        (let ((p (open-input-file fn)))
          (let f ((x (read p)))
            (if (eof-object? x)
                (begin (close-input-port p) '())
                (cons (datum->syntax-object k x)
                      (f (read p))))))))
    (syntax-case x ()
      ((k filename)
       (let ((fn (syntax-object->datum (syntax filename))))
         (with-syntax (((exp ...) (read-file fn (syntax k))))
           (syntax (begin exp ...))))))))

(define-syntax unquote
   (lambda (x)
      (syntax-case x ()
         ((_ e)
          (error 'unquote
		 "expression ,~s not valid outside of quasiquote"
		 (syntax-object->datum (syntax e)))))))

(define-syntax unquote-splicing
   (lambda (x)
      (syntax-case x ()
         ((_ e)
          (error 'unquote-splicing
		 "expression ,@~s not valid outside of quasiquote"
		 (syntax-object->datum (syntax e)))))))

(define-syntax case
  (lambda (x)
    (syntax-case x ()
      ((_ e m1 m2 ...)
       (with-syntax
         ((body (let f ((clause (syntax m1)) (clauses (syntax (m2 ...))))
                  (if (null? clauses)
                      (syntax-case clause (else)
                        ((else e1 e2 ...) (syntax (begin e1 e2 ...)))
                        (((k ...) e1 e2 ...)
                         (syntax (if (memv t '(k ...)) (begin e1 e2 ...))))
                        (_ (syntax-error x)))
                      (with-syntax ((rest (f (car clauses) (cdr clauses))))
                        (syntax-case clause (else)
                          (((k ...) e1 e2 ...)
                           (syntax (if (memv t '(k ...))
                                       (begin e1 e2 ...)
                                       rest)))
                          (_ (syntax-error x))))))))
         (syntax (let ((t e)) body)))))))

(define-syntax identifier-syntax
  (lambda (x)
    (syntax-case x ()
      ((_ e)
       (syntax
         (lambda (x)
           (syntax-case x ()
             (id
              (identifier? (syntax id))
              (syntax e))
             ((_ x (... ...))
              (syntax (e x (... ...)))))))))))

