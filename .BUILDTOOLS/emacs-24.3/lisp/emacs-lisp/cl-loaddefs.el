;;; cl-loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (cl-prettyexpand cl-remprop cl--do-remf cl--set-getf
;;;;;;  cl-getf cl-get cl-tailp cl-list-length cl-nreconc cl-revappend
;;;;;;  cl-concatenate cl-subseq cl-float-limits cl-random-state-p
;;;;;;  cl-make-random-state cl-random cl-signum cl-rem cl-mod cl-round
;;;;;;  cl-truncate cl-ceiling cl-floor cl-isqrt cl-lcm cl-gcd cl--set-frame-visible-p
;;;;;;  cl--map-overlays cl--map-intervals cl--map-keymap-recursively
;;;;;;  cl-notevery cl-notany cl-every cl-some cl-mapcon cl-mapcan
;;;;;;  cl-mapl cl-mapc cl-maplist cl-map cl--mapcar-many cl-equalp
;;;;;;  cl-coerce) "cl-extra" "cl-extra.el" "6c7926a10c377679687a2ab6a4d1c186")
;;; Generated autoloads from cl-extra.el

(autoload 'cl-coerce "cl-extra" "\
Coerce OBJECT to type TYPE.
TYPE is a Common Lisp type specifier.

\(fn OBJECT TYPE)" nil nil)

(autoload 'cl-equalp "cl-extra" "\
Return t if two Lisp objects have similar structures and contents.
This is like `equal', except that it accepts numerically equal
numbers of different types (float vs. integer), and also compares
strings case-insensitively.

\(fn X Y)" nil nil)

(autoload 'cl--mapcar-many "cl-extra" "\


\(fn CL-FUNC CL-SEQS)" nil nil)

(autoload 'cl-map "cl-extra" "\
Map a FUNCTION across one or more SEQUENCEs, returning a sequence.
TYPE is the sequence type to return.

\(fn TYPE FUNCTION SEQUENCE...)" nil nil)

(autoload 'cl-maplist "cl-extra" "\
Map FUNCTION to each sublist of LIST or LISTs.
Like `cl-mapcar', except applies to lists and their cdr's rather than to
the elements themselves.

\(fn FUNCTION LIST...)" nil nil)

(autoload 'cl-mapc "cl-extra" "\
Like `cl-mapcar', but does not accumulate values returned by the function.

\(fn FUNCTION SEQUENCE...)" nil nil)

(autoload 'cl-mapl "cl-extra" "\
Like `cl-maplist', but does not accumulate values returned by the function.

\(fn FUNCTION LIST...)" nil nil)

(autoload 'cl-mapcan "cl-extra" "\
Like `cl-mapcar', but nconc's together the values returned by the function.

\(fn FUNCTION SEQUENCE...)" nil nil)

(autoload 'cl-mapcon "cl-extra" "\
Like `cl-maplist', but nconc's together the values returned by the function.

\(fn FUNCTION LIST...)" nil nil)

(autoload 'cl-some "cl-extra" "\
Return true if PREDICATE is true of any element of SEQ or SEQs.
If so, return the true (non-nil) value returned by PREDICATE.

\(fn PREDICATE SEQ...)" nil nil)

(autoload 'cl-every "cl-extra" "\
Return true if PREDICATE is true of every element of SEQ or SEQs.

\(fn PREDICATE SEQ...)" nil nil)

(autoload 'cl-notany "cl-extra" "\
Return true if PREDICATE is false of every element of SEQ or SEQs.

\(fn PREDICATE SEQ...)" nil nil)

(autoload 'cl-notevery "cl-extra" "\
Return true if PREDICATE is false of some element of SEQ or SEQs.

\(fn PREDICATE SEQ...)" nil nil)

(autoload 'cl--map-keymap-recursively "cl-extra" "\


\(fn CL-FUNC-REC CL-MAP &optional CL-BASE)" nil nil)

(autoload 'cl--map-intervals "cl-extra" "\


\(fn CL-FUNC &optional CL-WHAT CL-PROP CL-START CL-END)" nil nil)

(autoload 'cl--map-overlays "cl-extra" "\


\(fn CL-FUNC &optional CL-BUFFER CL-START CL-END CL-ARG)" nil nil)

(autoload 'cl--set-frame-visible-p "cl-extra" "\


\(fn FRAME VAL)" nil nil)

(autoload 'cl-gcd "cl-extra" "\
Return the greatest common divisor of the arguments.

\(fn &rest ARGS)" nil nil)

(autoload 'cl-lcm "cl-extra" "\
Return the least common multiple of the arguments.

\(fn &rest ARGS)" nil nil)

(autoload 'cl-isqrt "cl-extra" "\
Return the integer square root of the argument.

\(fn X)" nil nil)

(autoload 'cl-floor "cl-extra" "\
Return a list of the floor of X and the fractional part of X.
With two arguments, return floor and remainder of their quotient.

\(fn X &optional Y)" nil nil)

(autoload 'cl-ceiling "cl-extra" "\
Return a list of the ceiling of X and the fractional part of X.
With two arguments, return ceiling and remainder of their quotient.

\(fn X &optional Y)" nil nil)

(autoload 'cl-truncate "cl-extra" "\
Return a list of the integer part of X and the fractional part of X.
With two arguments, return truncation and remainder of their quotient.

\(fn X &optional Y)" nil nil)

(autoload 'cl-round "cl-extra" "\
Return a list of X rounded to the nearest integer and the remainder.
With two arguments, return rounding and remainder of their quotient.

\(fn X &optional Y)" nil nil)

(autoload 'cl-mod "cl-extra" "\
The remainder of X divided by Y, with the same sign as Y.

\(fn X Y)" nil nil)

(autoload 'cl-rem "cl-extra" "\
The remainder of X divided by Y, with the same sign as X.

\(fn X Y)" nil nil)

(autoload 'cl-signum "cl-extra" "\
Return 1 if X is positive, -1 if negative, 0 if zero.

\(fn X)" nil nil)

(autoload 'cl-random "cl-extra" "\
Return a random nonnegative number less than LIM, an integer or float.
Optional second arg STATE is a random-state object.

\(fn LIM &optional STATE)" nil nil)

(autoload 'cl-make-random-state "cl-extra" "\
Return a copy of random-state STATE, or of the internal state if omitted.
If STATE is t, return a new state object seeded from the time of day.

\(fn &optional STATE)" nil nil)

(autoload 'cl-random-state-p "cl-extra" "\
Return t if OBJECT is a random-state object.

\(fn OBJECT)" nil nil)

(autoload 'cl-float-limits "cl-extra" "\
Initialize the Common Lisp floating-point parameters.
This sets the values of: `cl-most-positive-float', `cl-most-negative-float',
`cl-least-positive-float', `cl-least-negative-float', `cl-float-epsilon',
`cl-float-negative-epsilon', `cl-least-positive-normalized-float', and
`cl-least-negative-normalized-float'.

\(fn)" nil nil)

(autoload 'cl-subseq "cl-extra" "\
Return the subsequence of SEQ from START to END.
If END is omitted, it defaults to the length of the sequence.
If START or END is negative, it counts from the end.

\(fn SEQ START &optional END)" nil nil)

(autoload 'cl-concatenate "cl-extra" "\
Concatenate, into a sequence of type TYPE, the argument SEQUENCEs.

\(fn TYPE SEQUENCE...)" nil nil)

(autoload 'cl-revappend "cl-extra" "\
Equivalent to (append (reverse X) Y).

\(fn X Y)" nil nil)

(autoload 'cl-nreconc "cl-extra" "\
Equivalent to (nconc (nreverse X) Y).

\(fn X Y)" nil nil)

(autoload 'cl-list-length "cl-extra" "\
Return the length of list X.  Return nil if list is circular.

\(fn X)" nil nil)

(autoload 'cl-tailp "cl-extra" "\
Return true if SUBLIST is a tail of LIST.

\(fn SUBLIST LIST)" nil nil)

(autoload 'cl-get "cl-extra" "\
Return the value of SYMBOL's PROPNAME property, or DEFAULT if none.

\(fn SYMBOL PROPNAME &optional DEFAULT)" nil nil)

(put 'cl-get 'compiler-macro #'cl--compiler-macro-get)

(autoload 'cl-getf "cl-extra" "\
Search PROPLIST for property PROPNAME; return its value or DEFAULT.
PROPLIST is a list of the sort returned by `symbol-plist'.

\(fn PROPLIST PROPNAME &optional DEFAULT)" nil nil)

(autoload 'cl--set-getf "cl-extra" "\


\(fn PLIST TAG VAL)" nil nil)

(autoload 'cl--do-remf "cl-extra" "\


\(fn PLIST TAG)" nil nil)

(autoload 'cl-remprop "cl-extra" "\
Remove from SYMBOL's plist the property PROPNAME and its value.

\(fn SYMBOL PROPNAME)" nil nil)

(autoload 'cl-prettyexpand "cl-extra" "\
Expand macros in FORM and insert the pretty-printed result.
Optional argument FULL non-nil means to expand all macros,
including `cl-block' and `cl-eval-when'.

\(fn FORM &optional FULL)" nil nil)

;;;***

;;;### (autoloads (cl--compiler-macro-adjoin cl-defsubst cl-compiler-macroexpand
;;;;;;  cl-define-compiler-macro cl-assert cl-check-type cl-typep
;;;;;;  cl-deftype cl-defstruct cl-callf2 cl-callf cl-letf* cl-letf
;;;;;;  cl-rotatef cl-shiftf cl-remf cl-psetf cl-declare cl-the cl-locally
;;;;;;  cl-multiple-value-setq cl-multiple-value-bind cl-symbol-macrolet
;;;;;;  cl-macrolet cl-labels cl-flet* cl-flet cl-progv cl-psetq
;;;;;;  cl-do-all-symbols cl-do-symbols cl-dotimes cl-dolist cl-do*
;;;;;;  cl-do cl-loop cl-return-from cl-return cl-block cl-etypecase
;;;;;;  cl-typecase cl-ecase cl-case cl-load-time-value cl-eval-when
;;;;;;  cl-destructuring-bind cl-function cl-defmacro cl-defun cl-gentemp
;;;;;;  cl-gensym cl--compiler-macro-cXXr cl--compiler-macro-list*)
;;;;;;  "cl-macs" "cl-macs.el" "ad8afd35d8d75f5f22e7547b02bac556")
;;; Generated autoloads from cl-macs.el

(autoload 'cl--compiler-macro-list* "cl-macs" "\


\(fn FORM ARG &rest OTHERS)" nil nil)

(autoload 'cl--compiler-macro-cXXr "cl-macs" "\


\(fn FORM X)" nil nil)

(autoload 'cl-gensym "cl-macs" "\
Generate a new uninterned symbol.
The name is made by appending a number to PREFIX, default \"G\".

\(fn &optional PREFIX)" nil nil)

(autoload 'cl-gentemp "cl-macs" "\
Generate a new interned symbol with a unique name.
The name is made by appending a number to PREFIX, default \"G\".

\(fn &optional PREFIX)" nil nil)

(autoload 'cl-defun "cl-macs" "\
Define NAME as a function.
Like normal `defun', except ARGLIST allows full Common Lisp conventions,
and BODY is implicitly surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)" nil t)

(put 'cl-defun 'doc-string-elt '3)

(put 'cl-defun 'lisp-indent-function '2)

(autoload 'cl-defmacro "cl-macs" "\
Define NAME as a macro.
Like normal `defmacro', except ARGLIST allows full Common Lisp conventions,
and BODY is implicitly surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)" nil t)

(put 'cl-defmacro 'doc-string-elt '3)

(put 'cl-defmacro 'lisp-indent-function '2)

(autoload 'cl-function "cl-macs" "\
Introduce a function.
Like normal `function', except that if argument is a lambda form,
its argument list allows full Common Lisp conventions.

\(fn FUNC)" nil t)

(autoload 'cl-destructuring-bind "cl-macs" "\
Bind the variables in ARGS to the result of EXPR and execute BODY.

\(fn ARGS EXPR &rest BODY)" nil t)

(put 'cl-destructuring-bind 'lisp-indent-function '2)

(autoload 'cl-eval-when "cl-macs" "\
Control when BODY is evaluated.
If `compile' is in WHEN, BODY is evaluated when compiled at top-level.
If `load' is in WHEN, BODY is evaluated when loaded after top-level compile.
If `eval' is in WHEN, BODY is evaluated when interpreted or at non-top-level.

\(fn (WHEN...) BODY...)" nil t)

(put 'cl-eval-when 'lisp-indent-function '1)

(autoload 'cl-load-time-value "cl-macs" "\
Like `progn', but evaluates the body at load time.
The result of the body appears to the compiler as a quoted constant.

\(fn FORM &optional READ-ONLY)" nil t)

(autoload 'cl-case "cl-macs" "\
Eval EXPR and choose among clauses on that value.
Each clause looks like (KEYLIST BODY...).  EXPR is evaluated and compared
against each key in each KEYLIST; the corresponding BODY is evaluated.
If no clause succeeds, cl-case returns nil.  A single atom may be used in
place of a KEYLIST of one atom.  A KEYLIST of t or `otherwise' is
allowed only in the final clause, and matches if no other keys match.
Key values are compared by `eql'.

\(fn EXPR (KEYLIST BODY...)...)" nil t)

(put 'cl-case 'lisp-indent-function '1)

(autoload 'cl-ecase "cl-macs" "\
Like `cl-case', but error if no case fits.
`otherwise'-clauses are not allowed.

\(fn EXPR (KEYLIST BODY...)...)" nil t)

(put 'cl-ecase 'lisp-indent-function '1)

(autoload 'cl-typecase "cl-macs" "\
Evals EXPR, chooses among clauses on that value.
Each clause looks like (TYPE BODY...).  EXPR is evaluated and, if it
satisfies TYPE, the corresponding BODY is evaluated.  If no clause succeeds,
cl-typecase returns nil.  A TYPE of t or `otherwise' is allowed only in the
final clause, and matches if no other keys match.

\(fn EXPR (TYPE BODY...)...)" nil t)

(put 'cl-typecase 'lisp-indent-function '1)

(autoload 'cl-etypecase "cl-macs" "\
Like `cl-typecase', but error if no case fits.
`otherwise'-clauses are not allowed.

\(fn EXPR (TYPE BODY...)...)" nil t)

(put 'cl-etypecase 'lisp-indent-function '1)

(autoload 'cl-block "cl-macs" "\
Define a lexically-scoped block named NAME.
NAME may be any symbol.  Code inside the BODY forms can call `cl-return-from'
to jump prematurely out of the block.  This differs from `catch' and `throw'
in two respects:  First, the NAME is an unevaluated symbol rather than a
quoted symbol or other form; and second, NAME is lexically rather than
dynamically scoped:  Only references to it within BODY will work.  These
references may appear inside macro expansions, but not inside functions
called from BODY.

\(fn NAME &rest BODY)" nil t)

(put 'cl-block 'lisp-indent-function '1)

(autoload 'cl-return "cl-macs" "\
Return from the block named nil.
This is equivalent to `(cl-return-from nil RESULT)'.

\(fn &optional RESULT)" nil t)

(autoload 'cl-return-from "cl-macs" "\
Return from the block named NAME.
This jumps out to the innermost enclosing `(cl-block NAME ...)' form,
returning RESULT from that form (or nil if RESULT is omitted).
This is compatible with Common Lisp, but note that `defun' and
`defmacro' do not create implicit blocks as they do in Common Lisp.

\(fn NAME &optional RESULT)" nil t)

(put 'cl-return-from 'lisp-indent-function '1)

(autoload 'cl-loop "cl-macs" "\
The Common Lisp `loop' macro.
Valid clauses are:
  for VAR from/upfrom/downfrom NUM to/upto/downto/above/below NUM by NUM,
  for VAR in LIST by FUNC, for VAR on LIST by FUNC, for VAR = INIT then EXPR,
  for VAR across ARRAY, repeat NUM, with VAR = INIT, while COND, until COND,
  always COND, never COND, thereis COND, collect EXPR into VAR,
  append EXPR into VAR, nconc EXPR into VAR, sum EXPR into VAR,
  count EXPR into VAR, maximize EXPR into VAR, minimize EXPR into VAR,
  if COND CLAUSE [and CLAUSE]... else CLAUSE [and CLAUSE...],
  unless COND CLAUSE [and CLAUSE]... else CLAUSE [and CLAUSE...],
  do EXPRS..., initially EXPRS..., finally EXPRS..., return EXPR,
  finally return EXPR, named NAME.

\(fn CLAUSE...)" nil t)

(autoload 'cl-do "cl-macs" "\
The Common Lisp `do' loop.

\(fn ((VAR INIT [STEP])...) (END-TEST [RESULT...]) BODY...)" nil t)

(put 'cl-do 'lisp-indent-function '2)

(autoload 'cl-do* "cl-macs" "\
The Common Lisp `do*' loop.

\(fn ((VAR INIT [STEP])...) (END-TEST [RESULT...]) BODY...)" nil t)

(put 'cl-do* 'lisp-indent-function '2)

(autoload 'cl-dolist "cl-macs" "\
Loop over a list.
Evaluate BODY with VAR bound to each `car' from LIST, in turn.
Then evaluate RESULT to get return value, default nil.
An implicit nil block is established around the loop.

\(fn (VAR LIST [RESULT]) BODY...)" nil t)

(put 'cl-dolist 'lisp-indent-function '1)

(autoload 'cl-dotimes "cl-macs" "\
Loop a certain number of times.
Evaluate BODY with VAR bound to successive integers from 0, inclusive,
to COUNT, exclusive.  Then evaluate RESULT to get return value, default
nil.

\(fn (VAR COUNT [RESULT]) BODY...)" nil t)

(put 'cl-dotimes 'lisp-indent-function '1)

(autoload 'cl-do-symbols "cl-macs" "\
Loop over all symbols.
Evaluate BODY with VAR bound to each interned symbol, or to each symbol
from OBARRAY.

\(fn (VAR [OBARRAY [RESULT]]) BODY...)" nil t)

(put 'cl-do-symbols 'lisp-indent-function '1)

(autoload 'cl-do-all-symbols "cl-macs" "\
Like `cl-do-symbols', but use the default obarray.

\(fn (VAR [RESULT]) BODY...)" nil t)

(put 'cl-do-all-symbols 'lisp-indent-function '1)

(autoload 'cl-psetq "cl-macs" "\
Set SYMs to the values VALs in parallel.
This is like `setq', except that all VAL forms are evaluated (in order)
before assigning any symbols SYM to the corresponding values.

\(fn SYM VAL SYM VAL ...)" nil t)

(autoload 'cl-progv "cl-macs" "\
Bind SYMBOLS to VALUES dynamically in BODY.
The forms SYMBOLS and VALUES are evaluated, and must evaluate to lists.
Each symbol in the first list is bound to the corresponding value in the
second list (or to nil if VALUES is shorter than SYMBOLS); then the
BODY forms are executed and their result is returned.  This is much like
a `let' form, except that the list of symbols can be computed at run-time.

\(fn SYMBOLS VALUES &rest BODY)" nil t)

(put 'cl-progv 'lisp-indent-function '2)

(autoload 'cl-flet "cl-macs" "\
Make local function definitions.
Like `cl-labels' but the definitions are not recursive.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)" nil t)

(put 'cl-flet 'lisp-indent-function '1)

(autoload 'cl-flet* "cl-macs" "\
Make local function definitions.
Like `cl-flet' but the definitions can refer to previous ones.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)" nil t)

(put 'cl-flet* 'lisp-indent-function '1)

(autoload 'cl-labels "cl-macs" "\
Make temporary function bindings.
The bindings can be recursive and the scoping is lexical, but capturing them
in closures will only work if `lexical-binding' is in use.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)" nil t)

(put 'cl-labels 'lisp-indent-function '1)

(autoload 'cl-macrolet "cl-macs" "\
Make temporary macro definitions.
This is like `cl-flet', but for macros instead of functions.

\(fn ((NAME ARGLIST BODY...) ...) FORM...)" nil t)

(put 'cl-macrolet 'lisp-indent-function '1)

(autoload 'cl-symbol-macrolet "cl-macs" "\
Make symbol macro definitions.
Within the body FORMs, references to the variable NAME will be replaced
by EXPANSION, and (setq NAME ...) will act like (setf EXPANSION ...).

\(fn ((NAME EXPANSION) ...) FORM...)" nil t)

(put 'cl-symbol-macrolet 'lisp-indent-function '1)

(autoload 'cl-multiple-value-bind "cl-macs" "\
Collect multiple return values.
FORM must return a list; the BODY is then executed with the first N elements
of this list bound (`let'-style) to each of the symbols SYM in turn.  This
is analogous to the Common Lisp `cl-multiple-value-bind' macro, using lists to
simulate true multiple return values.  For compatibility, (cl-values A B C) is
a synonym for (list A B C).

\(fn (SYM...) FORM BODY)" nil t)

(put 'cl-multiple-value-bind 'lisp-indent-function '2)

(autoload 'cl-multiple-value-setq "cl-macs" "\
Collect multiple return values.
FORM must return a list; the first N elements of this list are stored in
each of the symbols SYM in turn.  This is analogous to the Common Lisp
`cl-multiple-value-setq' macro, using lists to simulate true multiple return
values.  For compatibility, (cl-values A B C) is a synonym for (list A B C).

\(fn (SYM...) FORM)" nil t)

(put 'cl-multiple-value-setq 'lisp-indent-function '1)

(autoload 'cl-locally "cl-macs" "\
Equivalent to `progn'.

\(fn &rest BODY)" nil t)

(autoload 'cl-the "cl-macs" "\
At present this ignores _TYPE and is simply equivalent to FORM.

\(fn TYPE FORM)" nil t)

(put 'cl-the 'lisp-indent-function '1)

(autoload 'cl-declare "cl-macs" "\
Declare SPECS about the current function while compiling.
For instance

  (cl-declare (warn 0))

will turn off byte-compile warnings in the function.
See Info node `(cl)Declarations' for details.

\(fn &rest SPECS)" nil t)

(autoload 'cl-psetf "cl-macs" "\
Set PLACEs to the values VALs in parallel.
This is like `setf', except that all VAL forms are evaluated (in order)
before assigning any PLACEs to the corresponding values.

\(fn PLACE VAL PLACE VAL ...)" nil t)

(autoload 'cl-remf "cl-macs" "\
Remove TAG from property list PLACE.
PLACE may be a symbol, or any generalized variable allowed by `setf'.
The form returns true if TAG was found and removed, nil otherwise.

\(fn PLACE TAG)" nil t)

(autoload 'cl-shiftf "cl-macs" "\
Shift left among PLACEs.
Example: (cl-shiftf A B C) sets A to B, B to C, and returns the old A.
Each PLACE may be a symbol, or any generalized variable allowed by `setf'.

\(fn PLACE... VAL)" nil t)

(autoload 'cl-rotatef "cl-macs" "\
Rotate left among PLACEs.
Example: (cl-rotatef A B C) sets A to B, B to C, and C to A.  It returns nil.
Each PLACE may be a symbol, or any generalized variable allowed by `setf'.

\(fn PLACE...)" nil t)

(autoload 'cl-letf "cl-macs" "\
Temporarily bind to PLACEs.
This is the analogue of `let', but with generalized variables (in the
sense of `setf') for the PLACEs.  Each PLACE is set to the corresponding
VALUE, then the BODY forms are executed.  On exit, either normally or
because of a `throw' or error, the PLACEs are set back to their original
values.  Note that this macro is *not* available in Common Lisp.
As a special case, if `(PLACE)' is used instead of `(PLACE VALUE)',
the PLACE is not modified before executing BODY.

\(fn ((PLACE VALUE) ...) BODY...)" nil t)

(put 'cl-letf 'lisp-indent-function '1)

(autoload 'cl-letf* "cl-macs" "\
Temporarily bind to PLACEs.
Like `cl-letf' but where the bindings are performed one at a time,
rather than all at the end (i.e. like `let*' rather than like `let').

\(fn BINDINGS &rest BODY)" nil t)

(put 'cl-letf* 'lisp-indent-function '1)

(autoload 'cl-callf "cl-macs" "\
Set PLACE to (FUNC PLACE ARGS...).
FUNC should be an unquoted function name.  PLACE may be a symbol,
or any generalized variable allowed by `setf'.

\(fn FUNC PLACE &rest ARGS)" nil t)

(put 'cl-callf 'lisp-indent-function '2)

(autoload 'cl-callf2 "cl-macs" "\
Set PLACE to (FUNC ARG1 PLACE ARGS...).
Like `cl-callf', but PLACE is the second argument of FUNC, not the first.

\(fn FUNC ARG1 PLACE ARGS...)" nil t)

(put 'cl-callf2 'lisp-indent-function '3)

(autoload 'cl-defstruct "cl-macs" "\
Define a struct type.
This macro defines a new data type called NAME that stores data
in SLOTs.  It defines a `make-NAME' constructor, a `copy-NAME'
copier, a `NAME-p' predicate, and slot accessors named `NAME-SLOT'.
You can use the accessors to set the corresponding slots, via `setf'.

NAME may instead take the form (NAME OPTIONS...), where each
OPTION is either a single keyword or (KEYWORD VALUE) where
KEYWORD can be one of :conc-name, :constructor, :copier, :predicate,
:type, :named, :initial-offset, :print-function, or :include.

Each SLOT may instead take the form (SLOT SLOT-OPTS...), where
SLOT-OPTS are keyword-value pairs for that slot.  Currently, only
one keyword is supported, `:read-only'.  If this has a non-nil
value, that slot cannot be set via `setf'.

\(fn NAME SLOTS...)" nil t)

(put 'cl-defstruct 'doc-string-elt '2)

(put 'cl-defstruct 'lisp-indent-function '1)

(autoload 'cl-deftype "cl-macs" "\
Define NAME as a new data type.
The type name can then be used in `cl-typecase', `cl-check-type', etc.

\(fn NAME ARGLIST &rest BODY)" nil t)

(put 'cl-deftype 'doc-string-elt '3)

(autoload 'cl-typep "cl-macs" "\
Check that OBJECT is of type TYPE.
TYPE is a Common Lisp-style type specifier.

\(fn OBJECT TYPE)" nil nil)

(autoload 'cl-check-type "cl-macs" "\
Verify that FORM is of type TYPE; signal an error if not.
STRING is an optional description of the desired type.

\(fn FORM TYPE &optional STRING)" nil t)

(autoload 'cl-assert "cl-macs" "\
Verify that FORM returns non-nil; signal an error if not.
Second arg SHOW-ARGS means to include arguments of FORM in message.
Other args STRING and ARGS... are arguments to be passed to `error'.
They are not evaluated unless the assertion fails.  If STRING is
omitted, a default message listing FORM itself is used.

\(fn FORM &optional SHOW-ARGS STRING &rest ARGS)" nil t)

(autoload 'cl-define-compiler-macro "cl-macs" "\
Define a compiler-only macro.
This is like `defmacro', but macro expansion occurs only if the call to
FUNC is compiled (i.e., not interpreted).  Compiler macros should be used
for optimizing the way calls to FUNC are compiled; the form returned by
BODY should do the same thing as a call to the normal function called
FUNC, though possibly more efficiently.  Note that, like regular macros,
compiler macros are expanded repeatedly until no further expansions are
possible.  Unlike regular macros, BODY can decide to \"punt\" and leave the
original function call alone by declaring an initial `&whole foo' parameter
and then returning foo.

\(fn FUNC ARGS &rest BODY)" nil t)

(autoload 'cl-compiler-macroexpand "cl-macs" "\
Like `macroexpand', but for compiler macros.
Expands FORM repeatedly until no further expansion is possible.
Returns FORM unchanged if it has no compiler macro, or if it has a
macro that returns its `&whole' argument.

\(fn FORM)" nil nil)

(autoload 'cl-defsubst "cl-macs" "\
Define NAME as a function.
Like `defun', except the function is automatically declared `inline',
ARGLIST allows full Common Lisp conventions, and BODY is implicitly
surrounded by (cl-block NAME ...).

\(fn NAME ARGLIST [DOCSTRING] BODY...)" nil t)

(put 'cl-defsubst 'lisp-indent-function '2)

(autoload 'cl--compiler-macro-adjoin "cl-macs" "\


\(fn FORM A LIST &rest KEYS)" nil nil)

;;;***

;;;### (autoloads (cl-tree-equal cl-nsublis cl-sublis cl-nsubst-if-not
;;;;;;  cl-nsubst-if cl-nsubst cl-subst-if-not cl-subst-if cl-subsetp
;;;;;;  cl-nset-exclusive-or cl-set-exclusive-or cl-nset-difference
;;;;;;  cl-set-difference cl-nintersection cl-intersection cl-nunion
;;;;;;  cl-union cl-rassoc-if-not cl-rassoc-if cl-rassoc cl-assoc-if-not
;;;;;;  cl-assoc-if cl-assoc cl--adjoin cl-member-if-not cl-member-if
;;;;;;  cl-member cl-merge cl-stable-sort cl-sort cl-search cl-mismatch
;;;;;;  cl-count-if-not cl-count-if cl-count cl-position-if-not cl-position-if
;;;;;;  cl-position cl-find-if-not cl-find-if cl-find cl-nsubstitute-if-not
;;;;;;  cl-nsubstitute-if cl-nsubstitute cl-substitute-if-not cl-substitute-if
;;;;;;  cl-substitute cl-delete-duplicates cl-remove-duplicates cl-delete-if-not
;;;;;;  cl-delete-if cl-delete cl-remove-if-not cl-remove-if cl-remove
;;;;;;  cl-replace cl-fill cl-reduce) "cl-seq" "cl-seq.el" "5ce2761d9a21845a7f6a2da0e4543844")
;;; Generated autoloads from cl-seq.el

(autoload 'cl-reduce "cl-seq" "\
Reduce two-argument FUNCTION across SEQ.

Keywords supported:  :start :end :from-end :initial-value :key

\(fn FUNCTION SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-fill "cl-seq" "\
Fill the elements of SEQ with ITEM.

Keywords supported:  :start :end

\(fn SEQ ITEM [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-replace "cl-seq" "\
Replace the elements of SEQ1 with the elements of SEQ2.
SEQ1 is destructively modified, then returned.

Keywords supported:  :start1 :end1 :start2 :end2

\(fn SEQ1 SEQ2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-remove "cl-seq" "\
Remove all occurrences of ITEM in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :test :test-not :key :count :start :end :from-end

\(fn ITEM SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-remove-if "cl-seq" "\
Remove all items satisfying PREDICATE in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :key :count :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-remove-if-not "cl-seq" "\
Remove all items not satisfying PREDICATE in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :key :count :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-delete "cl-seq" "\
Remove all occurrences of ITEM in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :test :test-not :key :count :start :end :from-end

\(fn ITEM SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-delete-if "cl-seq" "\
Remove all items satisfying PREDICATE in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :key :count :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-delete-if-not "cl-seq" "\
Remove all items not satisfying PREDICATE in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :key :count :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-remove-duplicates "cl-seq" "\
Return a copy of SEQ with all duplicate elements removed.

Keywords supported:  :test :test-not :key :start :end :from-end

\(fn SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-delete-duplicates "cl-seq" "\
Remove all duplicate elements from SEQ (destructively).

Keywords supported:  :test :test-not :key :start :end :from-end

\(fn SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-substitute "cl-seq" "\
Substitute NEW for OLD in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :test :test-not :key :count :start :end :from-end

\(fn NEW OLD SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-substitute-if "cl-seq" "\
Substitute NEW for all items satisfying PREDICATE in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :key :count :start :end :from-end

\(fn NEW PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-substitute-if-not "cl-seq" "\
Substitute NEW for all items not satisfying PREDICATE in SEQ.
This is a non-destructive function; it makes a copy of SEQ if necessary
to avoid corrupting the original SEQ.

Keywords supported:  :key :count :start :end :from-end

\(fn NEW PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubstitute "cl-seq" "\
Substitute NEW for OLD in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :test :test-not :key :count :start :end :from-end

\(fn NEW OLD SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubstitute-if "cl-seq" "\
Substitute NEW for all items satisfying PREDICATE in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :key :count :start :end :from-end

\(fn NEW PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubstitute-if-not "cl-seq" "\
Substitute NEW for all items not satisfying PREDICATE in SEQ.
This is a destructive function; it reuses the storage of SEQ whenever possible.

Keywords supported:  :key :count :start :end :from-end

\(fn NEW PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-find "cl-seq" "\
Find the first occurrence of ITEM in SEQ.
Return the matching ITEM, or nil if not found.

Keywords supported:  :test :test-not :key :start :end :from-end

\(fn ITEM SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-find-if "cl-seq" "\
Find the first item satisfying PREDICATE in SEQ.
Return the matching item, or nil if not found.

Keywords supported:  :key :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-find-if-not "cl-seq" "\
Find the first item not satisfying PREDICATE in SEQ.
Return the matching item, or nil if not found.

Keywords supported:  :key :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-position "cl-seq" "\
Find the first occurrence of ITEM in SEQ.
Return the index of the matching item, or nil if not found.

Keywords supported:  :test :test-not :key :start :end :from-end

\(fn ITEM SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-position-if "cl-seq" "\
Find the first item satisfying PREDICATE in SEQ.
Return the index of the matching item, or nil if not found.

Keywords supported:  :key :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-position-if-not "cl-seq" "\
Find the first item not satisfying PREDICATE in SEQ.
Return the index of the matching item, or nil if not found.

Keywords supported:  :key :start :end :from-end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-count "cl-seq" "\
Count the number of occurrences of ITEM in SEQ.

Keywords supported:  :test :test-not :key :start :end

\(fn ITEM SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-count-if "cl-seq" "\
Count the number of items satisfying PREDICATE in SEQ.

Keywords supported:  :key :start :end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-count-if-not "cl-seq" "\
Count the number of items not satisfying PREDICATE in SEQ.

Keywords supported:  :key :start :end

\(fn PREDICATE SEQ [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-mismatch "cl-seq" "\
Compare SEQ1 with SEQ2, return index of first mismatching element.
Return nil if the sequences match.  If one sequence is a prefix of the
other, the return value indicates the end of the shorter sequence.

Keywords supported:  :test :test-not :key :start1 :end1 :start2 :end2 :from-end

\(fn SEQ1 SEQ2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-search "cl-seq" "\
Search for SEQ1 as a subsequence of SEQ2.
Return the index of the leftmost element of the first match found;
return nil if there are no matches.

Keywords supported:  :test :test-not :key :start1 :end1 :start2 :end2 :from-end

\(fn SEQ1 SEQ2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-sort "cl-seq" "\
Sort the argument SEQ according to PREDICATE.
This is a destructive function; it reuses the storage of SEQ if possible.

Keywords supported:  :key

\(fn SEQ PREDICATE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-stable-sort "cl-seq" "\
Sort the argument SEQ stably according to PREDICATE.
This is a destructive function; it reuses the storage of SEQ if possible.

Keywords supported:  :key

\(fn SEQ PREDICATE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-merge "cl-seq" "\
Destructively merge the two sequences to produce a new sequence.
TYPE is the sequence type to return, SEQ1 and SEQ2 are the two argument
sequences, and PREDICATE is a `less-than' predicate on the elements.

Keywords supported:  :key

\(fn TYPE SEQ1 SEQ2 PREDICATE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-member "cl-seq" "\
Find the first occurrence of ITEM in LIST.
Return the sublist of LIST whose car is ITEM.

Keywords supported:  :test :test-not :key

\(fn ITEM LIST [KEYWORD VALUE]...)" nil nil)

(put 'cl-member 'compiler-macro #'cl--compiler-macro-member)

(autoload 'cl-member-if "cl-seq" "\
Find the first item satisfying PREDICATE in LIST.
Return the sublist of LIST whose car matches.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-member-if-not "cl-seq" "\
Find the first item not satisfying PREDICATE in LIST.
Return the sublist of LIST whose car matches.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl--adjoin "cl-seq" "\


\(fn CL-ITEM CL-LIST &rest CL-KEYS)" nil nil)

(autoload 'cl-assoc "cl-seq" "\
Find the first item whose car matches ITEM in LIST.

Keywords supported:  :test :test-not :key

\(fn ITEM LIST [KEYWORD VALUE]...)" nil nil)

(put 'cl-assoc 'compiler-macro #'cl--compiler-macro-assoc)

(autoload 'cl-assoc-if "cl-seq" "\
Find the first item whose car satisfies PREDICATE in LIST.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-assoc-if-not "cl-seq" "\
Find the first item whose car does not satisfy PREDICATE in LIST.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-rassoc "cl-seq" "\
Find the first item whose cdr matches ITEM in LIST.

Keywords supported:  :test :test-not :key

\(fn ITEM LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-rassoc-if "cl-seq" "\
Find the first item whose cdr satisfies PREDICATE in LIST.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-rassoc-if-not "cl-seq" "\
Find the first item whose cdr does not satisfy PREDICATE in LIST.

Keywords supported:  :key

\(fn PREDICATE LIST [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-union "cl-seq" "\
Combine LIST1 and LIST2 using a set-union operation.
The resulting list contains all items that appear in either LIST1 or LIST2.
This is a non-destructive function; it makes a copy of the data if necessary
to avoid corrupting the original LIST1 and LIST2.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nunion "cl-seq" "\
Combine LIST1 and LIST2 using a set-union operation.
The resulting list contains all items that appear in either LIST1 or LIST2.
This is a destructive function; it reuses the storage of LIST1 and LIST2
whenever possible.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-intersection "cl-seq" "\
Combine LIST1 and LIST2 using a set-intersection operation.
The resulting list contains all items that appear in both LIST1 and LIST2.
This is a non-destructive function; it makes a copy of the data if necessary
to avoid corrupting the original LIST1 and LIST2.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nintersection "cl-seq" "\
Combine LIST1 and LIST2 using a set-intersection operation.
The resulting list contains all items that appear in both LIST1 and LIST2.
This is a destructive function; it reuses the storage of LIST1 and LIST2
whenever possible.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-set-difference "cl-seq" "\
Combine LIST1 and LIST2 using a set-difference operation.
The resulting list contains all items that appear in LIST1 but not LIST2.
This is a non-destructive function; it makes a copy of the data if necessary
to avoid corrupting the original LIST1 and LIST2.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nset-difference "cl-seq" "\
Combine LIST1 and LIST2 using a set-difference operation.
The resulting list contains all items that appear in LIST1 but not LIST2.
This is a destructive function; it reuses the storage of LIST1 and LIST2
whenever possible.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-set-exclusive-or "cl-seq" "\
Combine LIST1 and LIST2 using a set-exclusive-or operation.
The resulting list contains all items appearing in exactly one of LIST1, LIST2.
This is a non-destructive function; it makes a copy of the data if necessary
to avoid corrupting the original LIST1 and LIST2.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nset-exclusive-or "cl-seq" "\
Combine LIST1 and LIST2 using a set-exclusive-or operation.
The resulting list contains all items appearing in exactly one of LIST1, LIST2.
This is a destructive function; it reuses the storage of LIST1 and LIST2
whenever possible.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-subsetp "cl-seq" "\
Return true if LIST1 is a subset of LIST2.
I.e., if every element of LIST1 also appears in LIST2.

Keywords supported:  :test :test-not :key

\(fn LIST1 LIST2 [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-subst-if "cl-seq" "\
Substitute NEW for elements matching PREDICATE in TREE (non-destructively).
Return a copy of TREE with all matching elements replaced by NEW.

Keywords supported:  :key

\(fn NEW PREDICATE TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-subst-if-not "cl-seq" "\
Substitute NEW for elts not matching PREDICATE in TREE (non-destructively).
Return a copy of TREE with all non-matching elements replaced by NEW.

Keywords supported:  :key

\(fn NEW PREDICATE TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubst "cl-seq" "\
Substitute NEW for OLD everywhere in TREE (destructively).
Any element of TREE which is `eql' to OLD is changed to NEW (via a call
to `setcar').

Keywords supported:  :test :test-not :key

\(fn NEW OLD TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubst-if "cl-seq" "\
Substitute NEW for elements matching PREDICATE in TREE (destructively).
Any element of TREE which matches is changed to NEW (via a call to `setcar').

Keywords supported:  :key

\(fn NEW PREDICATE TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsubst-if-not "cl-seq" "\
Substitute NEW for elements not matching PREDICATE in TREE (destructively).
Any element of TREE which matches is changed to NEW (via a call to `setcar').

Keywords supported:  :key

\(fn NEW PREDICATE TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-sublis "cl-seq" "\
Perform substitutions indicated by ALIST in TREE (non-destructively).
Return a copy of TREE with all matching elements replaced.

Keywords supported:  :test :test-not :key

\(fn ALIST TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-nsublis "cl-seq" "\
Perform substitutions indicated by ALIST in TREE (destructively).
Any matching element of TREE is changed via a call to `setcar'.

Keywords supported:  :test :test-not :key

\(fn ALIST TREE [KEYWORD VALUE]...)" nil nil)

(autoload 'cl-tree-equal "cl-seq" "\
Return t if trees TREE1 and TREE2 have `eql' leaves.
Atoms are compared by `eql'; cons cells are compared recursively.

Keywords supported:  :test :test-not :key

\(fn TREE1 TREE2 [KEYWORD VALUE]...)" nil nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cl-loaddefs.el ends here
