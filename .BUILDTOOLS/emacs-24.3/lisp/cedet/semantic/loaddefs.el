;;; loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (semantic-analyze-current-context) "semantic/analyze"
;;;;;;  "analyze.el" "2af49632a953e0d0bf64841971b03347")
;;; Generated autoloads from analyze.el

(autoload 'semantic-analyze-current-context "semantic/analyze" "\
Analyze the current context at optional POSITION.
If called interactively, display interesting information about POSITION
in a separate buffer.
Returns an object based on symbol `semantic-analyze-context'.

This function can be overridden with the symbol `analyze-context'.
When overriding this function, your override will be called while
cursor is at POSITION.  In addition, your function will not be called
if a cached copy of the return object is found.

\(fn &optional POSITION)" t nil)

;;;***

;;;### (autoloads (semantic-analyze-possible-completions semantic-analyze-type-constants)
;;;;;;  "semantic/analyze/complete" "analyze/complete.el" "44a4d253e631ee63d9b9de54f208dc5d")
;;; Generated autoloads from analyze/complete.el

(autoload 'semantic-analyze-type-constants "semantic/analyze/complete" "\
For the tag TYPE, return any constant symbols of TYPE.
Used as options when completing.

\(fn TYPE)" nil nil)

(autoload 'semantic-analyze-possible-completions "semantic/analyze/complete" "\
Return a list of semantic tags which are possible completions.
CONTEXT is either a position (such as point), or a precalculated
context.  Passing in a context is useful if the caller also needs
to access parts of the analysis.
The remaining FLAGS arguments are passed to the mode specific completion engine.
Bad flags should be ignored by modes that don't use them.
See `semantic-analyze-possible-completions-default' for details on the default FLAGS.

Completions run through the following filters:
  * Elements currently in scope
  * Constants currently in scope
  * Elements match the :prefix in the CONTEXT.
  * Type of the completion matches the type of the context.
Context type matching can identify the following:
  * No specific type
  * Assignment into a variable of some type.
  * Argument to a function with type constraints.
When called interactively, displays the list of possible completions
in a buffer.

\(fn CONTEXT &rest FLAGS)" t nil)

;;;***

;;;### (autoloads (semantic-analyze-proto-impl-toggle semantic-analyze-current-tag)
;;;;;;  "semantic/analyze/refs" "analyze/refs.el" "49a8dbd5d4dfba2c05441503a37b53b1")
;;; Generated autoloads from analyze/refs.el

(autoload 'semantic-analyze-current-tag "semantic/analyze/refs" "\
Analyze the tag under point.

\(fn)" t nil)

(autoload 'semantic-analyze-proto-impl-toggle "semantic/analyze/refs" "\
Toggle between the implementation, and a prototype of tag under point.

\(fn)" t nil)

;;;***

;;;### (autoloads (semantic-bovinate-stream) "semantic/bovine" "bovine.el"
;;;;;;  "7a236d2e55e9fe21eba305e37c3651f2")
;;; Generated autoloads from bovine.el

(autoload 'semantic-bovinate-stream "semantic/bovine" "\
Bovinate STREAM, starting at the first NONTERMINAL rule.
Use `bovine-toplevel' if NONTERMINAL is not provided.
This is the core routine for converting a stream into a table.
Return the list (STREAM SEMANTIC-STREAM) where STREAM are those
elements of STREAM that have not been used.  SEMANTIC-STREAM is the
list of semantic tokens found.

\(fn STREAM &optional NONTERMINAL)" nil nil)

(defalias 'semantic-parse-stream-default 'semantic-bovinate-stream)

;;;***

;;;### (autoloads (semantic-c-add-preprocessor-symbol semantic-default-c-setup)
;;;;;;  "semantic/bovine/c" "bovine/c.el" "bba379c395ddcd6152eccd893e7f5567")
;;; Generated autoloads from bovine/c.el

(autoload 'semantic-default-c-setup "semantic/bovine/c" "\
Set up a buffer for semantic parsing of the C language.

\(fn)" nil nil)

(autoload 'semantic-c-add-preprocessor-symbol "semantic/bovine/c" "\
Add a preprocessor symbol SYM with a REPLACEMENT value.

\(fn SYM REPLACEMENT)" t nil)

;;;***

;;;### (autoloads (semantic-gcc-setup) "semantic/bovine/gcc" "bovine/gcc.el"
;;;;;;  "f62b1a6af84859d858af3401d017b54d")
;;; Generated autoloads from bovine/gcc.el

(autoload 'semantic-gcc-setup "semantic/bovine/gcc" "\
Setup Semantic C/C++ parsing based on GCC output.

\(fn)" t nil)

;;;***

;;;### (autoloads (semantic-default-make-setup) "semantic/bovine/make"
;;;;;;  "bovine/make.el" "99e5df38c7bbb3f344c67e3f57e4c8e5")
;;; Generated autoloads from bovine/make.el

(autoload 'semantic-default-make-setup "semantic/bovine/make" "\
Set up a Makefile buffer for parsing with semantic.

\(fn)" nil nil)

;;;***

;;;### (autoloads (semantic-default-scheme-setup) "semantic/bovine/scm"
;;;;;;  "bovine/scm.el" "3e635163c7361d0e0954f054141365a1")
;;; Generated autoloads from bovine/scm.el

(autoload 'semantic-default-scheme-setup "semantic/bovine/scm" "\
Setup hook function for Emacs Lisp files and Semantic.

\(fn)" nil nil)

;;;***

;;;### (autoloads (semantic-complete-inline-project semantic-complete-self-insert
;;;;;;  semantic-complete-analyze-inline-idle semantic-complete-analyze-inline
;;;;;;  semantic-complete-analyze-and-replace semantic-complete-jump-local-members
;;;;;;  semantic-complete-jump semantic-complete-jump-local semantic-displayor-tooltip-initial-max-tags
;;;;;;  semantic-displayor-tooltip-mode) "semantic/complete" "complete.el"
;;;;;;  "d93584c80e037d1d577cd7446f4aae8d")
;;; Generated autoloads from complete.el

(defvar semantic-displayor-tooltip-mode 'standard "\
Mode for the tooltip inline completion.

Standard: Show only `semantic-displayor-tooltip-initial-max-tags'
number of completions initially.  Pressing TAB will show the
extended set.

Quiet: Only show completions when we have narrowed all
possibilities down to a maximum of
`semantic-displayor-tooltip-initial-max-tags' tags.  Pressing TAB
multiple times will also show completions.

Verbose: Always show all completions available.

The absolute maximum number of completions for all mode is
determined through `semantic-displayor-tooltip-max-tags'.")

(custom-autoload 'semantic-displayor-tooltip-mode "semantic/complete" t)

(defvar semantic-displayor-tooltip-initial-max-tags 5 "\
Maximum number of tags to be displayed initially.
See doc-string of `semantic-displayor-tooltip-mode' for details.")

(custom-autoload 'semantic-displayor-tooltip-initial-max-tags "semantic/complete" t)

(autoload 'semantic-complete-jump-local "semantic/complete" "\
Jump to a local semantic symbol.

\(fn)" t nil)

(autoload 'semantic-complete-jump "semantic/complete" "\
Jump to a semantic symbol.

\(fn)" t nil)

(autoload 'semantic-complete-jump-local-members "semantic/complete" "\
Jump to a semantic symbol.

\(fn)" t nil)

(autoload 'semantic-complete-analyze-and-replace "semantic/complete" "\
Perform prompt completion to do in buffer completion.
`semantic-analyze-possible-completions' is used to determine the
possible values.
The minibuffer is used to perform the completion.
The result is inserted as a replacement of the text that was there.

\(fn)" t nil)

(autoload 'semantic-complete-analyze-inline "semantic/complete" "\
Perform prompt completion to do in buffer completion.
`semantic-analyze-possible-completions' is used to determine the
possible values.
The function returns immediately, leaving the buffer in a mode that
will perform the completion.
Configure `semantic-complete-inline-analyzer-displayor-class' to change
how completion options are displayed.

\(fn)" t nil)

(autoload 'semantic-complete-analyze-inline-idle "semantic/complete" "\
Perform prompt completion to do in buffer completion.
`semantic-analyze-possible-completions' is used to determine the
possible values.
The function returns immediately, leaving the buffer in a mode that
will perform the completion.
Configure `semantic-complete-inline-analyzer-idle-displayor-class'
to change how completion options are displayed.

\(fn)" t nil)

(autoload 'semantic-complete-self-insert "semantic/complete" "\
Like `self-insert-command', but does completion afterwards.
ARG is passed to `self-insert-command'.  If ARG is nil,
use `semantic-complete-analyze-inline' to complete.

\(fn ARG)" t nil)

(autoload 'semantic-complete-inline-project "semantic/complete" "\
Perform inline completion for any symbol in the current project.
`semantic-analyze-possible-completions' is used to determine the
possible values.
The function returns immediately, leaving the buffer in a mode that
will perform the completion.

\(fn)" t nil)

;;;***

;;;### (autoloads (semantic-ctxt-current-mode) "semantic/ctxt" "ctxt.el"
;;;;;;  "15e43412cdd96706f29f0024a34ea8f9")
;;; Generated autoloads from ctxt.el

(autoload 'semantic-ctxt-current-mode "semantic/ctxt" "\
Return the major mode active at POINT.
POINT defaults to the value of point in current buffer.
You should override this function in multiple mode buffers to
determine which major mode apply at point.

\(fn &optional POINT)" nil nil)

;;;***

;;;### (autoloads (semanticdb-file-table-object) "semantic/db" "db.el"
;;;;;;  "540f52a8b5a76c42f1c9539a5037e604")
;;; Generated autoloads from db.el

(defvar semanticdb-current-database nil "\
For a given buffer, this is the currently active database.")

(defvar semanticdb-current-table nil "\
For a given buffer, this is the currently active database table.")

(autoload 'semanticdb-file-table-object "semantic/db" "\
Return a semanticdb table belonging to FILE, make it up to date.
If file has database tags available in the database, return it.
If file does not have tags available, and DONTLOAD is nil,
then load the tags for FILE, and create a new table object for it.
DONTLOAD does not affect the creation of new database objects.

\(fn FILE &optional DONTLOAD)" nil nil)

;;;***

;;;### (autoloads (semanticdb-project-database-file) "semantic/db-file"
;;;;;;  "db-file.el" "ecfacda9797e02e780f15db282c94320")
;;; Generated autoloads from db-file.el

(eieio-defclass-autoload 'semanticdb-project-database-file '(semanticdb-project-database eieio-persistent) "semantic/db-file" "Database of file tables saved to disk.")

;;;***

;;;### (autoloads (semanticdb-find-tags-by-class semanticdb-find-tags-for-completion
;;;;;;  semanticdb-find-tags-by-name-regexp semanticdb-find-tags-by-name
;;;;;;  semanticdb-find-result-nth-in-buffer semanticdb-find-result-nth
;;;;;;  semanticdb-find-result-length semanticdb-strip-find-results
;;;;;;  semanticdb-find-adebug-lost-includes semanticdb-find-test-translate-path
;;;;;;  semanticdb-find-table-for-include semanticdb-find-translate-path
;;;;;;  semanticdb-find-default-throttle) "semantic/db-find" "db-find.el"
;;;;;;  "2d5bf7d2679998d2884095ee4b1eca91")
;;; Generated autoloads from db-find.el

(defvar semanticdb-find-default-throttle '(local project unloaded system recursive) "\
The default throttle for `semanticdb-find' routines.
The throttle controls how detailed the list of database
tables is for a symbol lookup.  The value is a list with
the following keys:
  `file'       - The file the search is being performed from.
                 This option is here for completeness only, and
                 is assumed to always be on.
  `local'      - Tables from the same local directory are included.
                 This includes files directly referenced by a file name
                 which might be in a different directory.
  `project'    - Tables from the same local project are included
                 If `project' is specified, then `local' is assumed.
  `unloaded'   - If a table is not in memory, load it.  If it is not cached
                 on disk either, get the source, parse it, and create
                 the table.
  `system'     - Tables from system databases.  These are specifically
                 tables from system header files, or language equivalent.
  `recursive'  - For include based searches, includes tables referenced
                 by included files.
  `omniscience' - Included system databases which are omniscience, or
                 somehow know everything.  Omniscience databases are found
                 in `semanticdb-project-system-databases'.
                 The Emacs Lisp system DB is an omniscience database.")

(custom-autoload 'semanticdb-find-default-throttle "semantic/db-find" t)

(autoload 'semanticdb-find-translate-path "semantic/db-find" "\
Translate PATH into a list of semantic tables.
Path translation involves identifying the PATH input argument
in one of the following ways:
  nil - Take the current buffer, and use its include list
  buffer - Use that buffer's include list.
  filename - Use that file's include list.  If the file is not
      in a buffer, see of there is a semanticdb table for it.  If
      not, read that file into a buffer.
  tag - Get that tag's buffer of file file.  See above.
  table - Search that table, and its include list.
  find result - Search the results of a previous find.

In addition, once the base path is found, there is the possibility of
each added table adding yet more tables to the path, so this routine
can return a lengthy list.

If argument BRUTISH is non-nil, then instead of using the include
list, use all tables found in the parent project of the table
identified by translating PATH.  Such searches use brute force to
scan every available table.

The return value is a list of objects of type `semanticdb-table' or
their children.  In the case of passing in a find result, the result
is returned unchanged.

This routine uses `semanticdb-find-table-for-include' to translate
specific include tags into a semanticdb table.

Note: When searching using a non-brutish method, the list of
included files will be cached between runs.  Database-references
are used to track which files need to have their include lists
refreshed when things change.  See `semanticdb-ref-test'.

Note for overloading:  If you opt to overload this function for your
major mode, and your routine takes a long time, be sure to call

 (semantic-throw-on-input 'your-symbol-here)

so that it can be called from the idle work handler.

\(fn PATH BRUTISH)" nil nil)

(autoload 'semanticdb-find-table-for-include "semantic/db-find" "\
For a single INCLUDETAG found in TABLE, find a `semanticdb-table' object
INCLUDETAG is a semantic TAG of class 'include.
TABLE is a semanticdb table that identifies where INCLUDETAG came from.
TABLE is optional if INCLUDETAG has an overlay of :filename attribute.

\(fn INCLUDETAG &optional TABLE)" nil nil)

(autoload 'semanticdb-find-test-translate-path "semantic/db-find" "\
Call and output results of `semanticdb-find-translate-path'.
With ARG non-nil, specify a BRUTISH translation.
See `semanticdb-find-default-throttle' and `semanticdb-project-roots'
for details on how this list is derived.

\(fn &optional ARG)" t nil)

(autoload 'semanticdb-find-adebug-lost-includes "semantic/db-find" "\
Translate the current path, then display the lost includes.
Examines the variable `semanticdb-find-lost-includes'.

\(fn)" t nil)

(autoload 'semanticdb-strip-find-results "semantic/db-find" "\
Strip a semanticdb search RESULTS to exclude objects.
This makes it appear more like the results of a `semantic-find-' call.
Optional FIND-FILE-MATCH loads all files associated with RESULTS
into buffers.  This has the side effect of enabling `semantic-tag-buffer' to
return a value.
If FIND-FILE-MATCH is 'name, then only the filename is stored
in each tag instead of loading each file into a buffer.
If the input RESULTS are not going to be used again, and if
FIND-FILE-MATCH is nil, you can use `semanticdb-fast-strip-find-results'
instead.

\(fn RESULTS &optional FIND-FILE-MATCH)" nil nil)

(autoload 'semanticdb-find-result-length "semantic/db-find" "\
Number of tags found in RESULT.

\(fn RESULT)" nil nil)

(autoload 'semanticdb-find-result-nth "semantic/db-find" "\
In RESULT, return the Nth search result.
This is a 0 based search result, with the first match being element 0.

The returned value is a cons cell: (TAG . TABLE) where TAG
is the tag at the Nth position.  TABLE is the semanticdb table where
the TAG was found.  Sometimes TABLE can be nil.

\(fn RESULT N)" nil nil)

(autoload 'semanticdb-find-result-nth-in-buffer "semantic/db-find" "\
In RESULT, return the Nth search result.
Like `semanticdb-find-result-nth', except that only the TAG
is returned, and the buffer it is found it will be made current.
If the result tag has no position information, the originating buffer
is still made current.

\(fn RESULT N)" nil nil)

(autoload 'semanticdb-find-tags-by-name "semantic/db-find" "\
Search for all tags matching NAME on PATH.
See `semanticdb-find-translate-path' for details on PATH.
FIND-FILE-MATCH indicates that any time a match is found, the file
associated with that tag should be loaded into a buffer.

\(fn NAME &optional PATH FIND-FILE-MATCH)" nil nil)

(autoload 'semanticdb-find-tags-by-name-regexp "semantic/db-find" "\
Search for all tags matching REGEXP on PATH.
See `semanticdb-find-translate-path' for details on PATH.
FIND-FILE-MATCH indicates that any time a match is found, the file
associated with that tag should be loaded into a buffer.

\(fn REGEXP &optional PATH FIND-FILE-MATCH)" nil nil)

(autoload 'semanticdb-find-tags-for-completion "semantic/db-find" "\
Search for all tags matching PREFIX on PATH.
See `semanticdb-find-translate-path' for details on PATH.
FIND-FILE-MATCH indicates that any time a match is found, the file
associated with that tag should be loaded into a buffer.

\(fn PREFIX &optional PATH FIND-FILE-MATCH)" nil nil)

(autoload 'semanticdb-find-tags-by-class "semantic/db-find" "\
Search for all tags of CLASS on PATH.
See `semanticdb-find-translate-path' for details on PATH.
FIND-FILE-MATCH indicates that any time a match is found, the file
associated with that tag should be loaded into a buffer.

\(fn CLASS &optional PATH FIND-FILE-MATCH)" nil nil)

;;;***

;;;### (autoloads (semanticdb-enable-gnu-global-databases) "semantic/db-global"
;;;;;;  "db-global.el" "884cb85331fac4b472b83415918e9868")
;;; Generated autoloads from db-global.el

(autoload 'semanticdb-enable-gnu-global-databases "semantic/db-global" "\
Enable the use of the GNU Global SemanticDB back end for all files of MODE.
This will add an instance of a GNU Global database to each buffer
in a GNU Global supported hierarchy.

Two sanity checks are performed to assure (a) that GNU global program exists
and (b) that the GNU global program version is compatibility with the database
version.  If optional NOERROR is nil, then an error may be signalled on version
mismatch.  If NOERROR is not nil, then no error will be signaled.  Instead
return value will indicate success or failure with non-nil or nil respective
values.

\(fn MODE &optional NOERROR)" t nil)

;;;***

;;;### (autoloads (global-semanticdb-minor-mode semanticdb-minor-mode-p)
;;;;;;  "semantic/db-mode" "db-mode.el" "118c69ec555ed67ae074566d5e09437e")
;;; Generated autoloads from db-mode.el

(autoload 'semanticdb-minor-mode-p "semantic/db-mode" "\
Return non-nil if `semanticdb-minor-mode' is active.

\(fn)" nil nil)

(defvar global-semanticdb-minor-mode nil "\
Non-nil if Global-Semanticdb minor mode is enabled.
See the command `global-semanticdb-minor-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semanticdb-minor-mode'.")

(custom-autoload 'global-semanticdb-minor-mode "semantic/db-mode" nil)

(autoload 'global-semanticdb-minor-mode "semantic/db-mode" "\
Toggle Semantic DB mode.
With ARG, turn Semantic DB mode on if ARG is positive, off otherwise.

In Semantic DB mode, Semantic parsers store results in a
database, which can be saved for future Emacs sessions.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (semanticdb-typecache-find semanticdb-database-typecache
;;;;;;  semanticdb-typecache) "semantic/db-typecache" "db-typecache.el"
;;;;;;  "74f0006cfde8826ff37cf80587dcad23")
;;; Generated autoloads from db-typecache.el

(eieio-defclass-autoload 'semanticdb-typecache 'nil "semantic/db-typecache" "Structure for maintaining a typecache.")

(eieio-defclass-autoload 'semanticdb-database-typecache '(semanticdb-abstract-db-cache) "semantic/db-typecache" "Structure for maintaining a typecache.")

(autoload 'semanticdb-typecache-find "semantic/db-typecache" "\
Search the typecache for TYPE in PATH.
If type is a string, split the string, and search for the parts.
If type is a list, treat the type as a pre-split string.
PATH can be nil for the current buffer, or a semanticdb table.
FIND-FILE-MATCH is non-nil to force all found tags to be loaded into a buffer.

\(fn TYPE &optional PATH FIND-FILE-MATCH)" nil nil)

;;;***

;;;### (autoloads nil "semantic/debug" "debug.el" "c708ca44f240343d3a0a5e6e604b73ef")
;;; Generated autoloads from debug.el

(defvar semantic-debug-parser-source nil "\
For any buffer, the file name (no path) of the parser.
This would be a parser for a specific language, not the source
to one of the parser generators.")

(make-variable-buffer-local 'semantic-debug-parser-source)

(defvar semantic-debug-parser-class nil "\
Class to create when building a debug parser object.")

(make-variable-buffer-local 'semantic-debug-parser-class)

;;;***

;;;### (autoloads (semantic-decoration-unparsed-include-do-reset
;;;;;;  semantic-decoration-include-visit) "semantic/decorate/include"
;;;;;;  "decorate/include.el" "18ecd50e0f9009bcb411858fff005800")
;;; Generated autoloads from decorate/include.el

(autoload 'semantic-decoration-include-visit "semantic/decorate/include" "\
Visit the included file at point.

\(fn)" t nil)

(autoload 'semantic-decoration-unparsed-include-do-reset "semantic/decorate/include" "\
Do a reset of unparsed includes in the current buffer.

\(fn)" nil nil)

;;;***

;;;### (autoloads (global-semantic-decoration-mode) "semantic/decorate/mode"
;;;;;;  "decorate/mode.el" "9e4e266461dbc83f0da3fdb06d2e9c15")
;;; Generated autoloads from decorate/mode.el

(defvar global-semantic-decoration-mode nil "\
Non-nil if Global-Semantic-Decoration mode is enabled.
See the command `global-semantic-decoration-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-decoration-mode'.")

(custom-autoload 'global-semantic-decoration-mode "semantic/decorate/mode" nil)

(autoload 'global-semantic-decoration-mode "semantic/decorate/mode" "\
Toggle global use of option `semantic-decoration-mode'.
Decoration mode turns on all active decorations as specified
by `semantic-decoration-styles'.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (semantic-customize-system-include-path semantic-reset-system-include
;;;;;;  semantic-remove-system-include semantic-add-system-include)
;;;;;;  "semantic/dep" "dep.el" "7bc067756058a6bf82b50ec54eb56e68")
;;; Generated autoloads from dep.el

(autoload 'semantic-add-system-include "semantic/dep" "\
Add a system include DIR to path for MODE.
Modifies a mode-local version of `semantic-dependency-system-include-path'.

Changes made by this function are not persistent.

\(fn DIR &optional MODE)" t nil)

(autoload 'semantic-remove-system-include "semantic/dep" "\
Add a system include DIR to path for MODE.
Modifies a mode-local version of`semantic-dependency-system-include-path'.

Changes made by this function are not persistent.

\(fn DIR &optional MODE)" t nil)

(autoload 'semantic-reset-system-include "semantic/dep" "\
Reset the system include list to empty for MODE.
Modifies a mode-local version of
`semantic-dependency-system-include-path'.

\(fn &optional MODE)" t nil)

(autoload 'semantic-customize-system-include-path "semantic/dep" "\
Customize the include path for this `major-mode'.
To create a customizable include path for a major MODE, use the
macro `defcustom-mode-local-semantic-dependency-system-include-path'.

\(fn &optional MODE)" t nil)

;;;***

;;;### (autoloads (semantic-documentation-for-tag) "semantic/doc"
;;;;;;  "doc.el" "10cd8ac906ac9fe3d5fe30be0ed2cb2d")
;;; Generated autoloads from doc.el

(autoload 'semantic-documentation-for-tag "semantic/doc" "\
Find documentation from TAG and return it as a clean string.
TAG might have DOCUMENTATION set in it already.  If not, there may be
some documentation in a comment preceding TAG's definition which we
can look for.  When appropriate, this can be overridden by a language specific
enhancement.
Optional argument NOSNARF means to only return the lexical analyzer token for it.
If nosnarf if 'lex, then only return the lex token.

\(fn &optional TAG NOSNARF)" nil nil)

;;;***

;;;### (autoloads (semantic-edits-incremental-parser semantic-change-function)
;;;;;;  "semantic/edit" "edit.el" "9fdd04a1ad136e6f92a8067105ca6ed2")
;;; Generated autoloads from edit.el

(autoload 'semantic-change-function "semantic/edit" "\
Provide a mechanism for semantic tag management.
Argument START, END, and LENGTH specify the bounds of the change.

\(fn START END LENGTH)" nil nil)

(autoload 'semantic-edits-incremental-parser "semantic/edit" "\
Incrementally reparse the current buffer.
Incremental parser allows semantic to only reparse those sections of
the buffer that have changed.  This function depends on
`semantic-edits-change-function-handle-changes' setting up change
overlays in the current buffer.  Those overlays are analyzed against
the semantic cache to see what needs to be changed.

\(fn)" nil nil)

(defalias 'semantic-parse-changes-default 'semantic-edits-incremental-parser)

;;;***

;;;### (autoloads (semantic-find-tags-included semantic-find-tags-by-scope-protection
;;;;;;  semantic-find-first-tag-by-name semantic-current-tag-parent
;;;;;;  semantic-current-tag semantic-find-tag-parent-by-overlay
;;;;;;  semantic-find-tag-by-overlay-prev semantic-find-tag-by-overlay-next
;;;;;;  semantic-find-tag-by-overlay-in-region semantic-find-tag-by-overlay)
;;;;;;  "semantic/find" "find.el" "d539cc97e8cb66b178fbe5426605cd81")
;;; Generated autoloads from find.el

(autoload 'semantic-find-tag-by-overlay "semantic/find" "\
Find all tags covering POSITIONORMARKER by using overlays.
If POSITIONORMARKER is nil, use the current point.
Optional BUFFER is used if POSITIONORMARKER is a number, otherwise the current
buffer is used.  This finds all tags covering the specified position
by checking for all overlays covering the current spot.  They are then sorted
from largest to smallest via the start location.

\(fn &optional POSITIONORMARKER BUFFER)" nil nil)

(autoload 'semantic-find-tag-by-overlay-in-region "semantic/find" "\
Find all tags which exist in whole or in part between START and END.
Uses overlays to determine position.
Optional BUFFER argument specifies the buffer to use.

\(fn START END &optional BUFFER)" nil nil)

(autoload 'semantic-find-tag-by-overlay-next "semantic/find" "\
Find the next tag after START in BUFFER.
If START is in an overlay, find the tag which starts next,
not the current tag.

\(fn &optional START BUFFER)" nil nil)

(autoload 'semantic-find-tag-by-overlay-prev "semantic/find" "\
Find the next tag before START in BUFFER.
If START is in an overlay, find the tag which starts next,
not the current tag.

\(fn &optional START BUFFER)" nil nil)

(autoload 'semantic-find-tag-parent-by-overlay "semantic/find" "\
Find the parent of TAG by overlays.
Overlays are a fast way of finding this information for active buffers.

\(fn TAG)" nil nil)

(autoload 'semantic-current-tag "semantic/find" "\
Return the current tag in the current buffer.
If there are more than one in the same location, return the
smallest tag.  Return nil if there is no tag here.

\(fn)" nil nil)

(autoload 'semantic-current-tag-parent "semantic/find" "\
Return the current tags parent in the current buffer.
A tag's parent would be a containing structure, such as a type
containing a field.  Return nil if there is no parent.

\(fn)" nil nil)

(autoload 'semantic-find-first-tag-by-name "semantic/find" "\
Find the first tag with NAME in TABLE.
NAME is a string.
TABLE is a semantic tags table.  See `semantic-something-to-tag-table'.
This routine uses `assoc' to quickly find the first matching entry.

\(fn NAME &optional TABLE)" nil nil)

(autoload 'semantic-find-tags-by-scope-protection "semantic/find" "\
Find all tags accessible by SCOPEPROTECTION.
SCOPEPROTECTION is a symbol which can be returned by the method
`semantic-tag-protection'.  A hard-coded order is used to determine a match.
PARENT is a tag representing the PARENT slot needed for
`semantic-tag-protection'.
TABLE is a list of tags (a subset of PARENT members) to scan.  If TABLE is nil,
the type members of PARENT are used.
See `semantic-tag-protected-p' for details on which tags are returned.

\(fn SCOPEPROTECTION PARENT &optional TABLE)" nil nil)

(autoload 'semantic-find-tags-included "semantic/find" "\
Find all tags in TABLE that are of the 'include class.
TABLE is a tag table.  See `semantic-something-to-tag-table'.

\(fn &optional TABLE)" nil nil)

;;;***

;;;### (autoloads (semantic-format-tag-concise-prototype semantic-format-tag-prototype
;;;;;;  semantic-format-tag-summarize semantic-format-tag-name) "semantic/format"
;;;;;;  "format.el" "8154f2ce6ed14c11b962fc7eacd11453")
;;; Generated autoloads from format.el

(autoload 'semantic-format-tag-name "semantic/format" "\
Return the name string describing TAG.
The name is the shortest possible representation.
Optional argument PARENT is the parent type if TAG is a detail.
Optional argument COLOR means highlight the prototype with font-lock colors.

\(fn TAG &optional PARENT COLOR)" nil nil)

(autoload 'semantic-format-tag-summarize "semantic/format" "\
Summarize TAG in a reasonable way.
Optional argument PARENT is the parent type if TAG is a detail.
Optional argument COLOR means highlight the prototype with font-lock colors.

\(fn TAG &optional PARENT COLOR)" nil nil)

(autoload 'semantic-format-tag-prototype "semantic/format" "\
Return a prototype for TAG.
This function should be overloaded, though it need not be used.
This is because it can be used to create code by language independent
tools.
Optional argument PARENT is the parent type if TAG is a detail.
Optional argument COLOR means highlight the prototype with font-lock colors.

\(fn TAG &optional PARENT COLOR)" nil nil)

(autoload 'semantic-format-tag-concise-prototype "semantic/format" "\
Return a concise prototype for TAG.
Optional argument PARENT is the parent type if TAG is a detail.
Optional argument COLOR means highlight the prototype with font-lock colors.

\(fn TAG &optional PARENT COLOR)" nil nil)

;;;***

;;;### (autoloads (semantic-default-html-setup) "semantic/html" "html.el"
;;;;;;  "57af792cac3545f740d934870011585e")
;;; Generated autoloads from html.el

(autoload 'semantic-default-html-setup "semantic/html" "\
Set up a buffer for parsing of HTML files.

\(fn)" nil nil)

;;;***

;;;### (autoloads (semantic-ia-describe-class semantic-ia-show-doc
;;;;;;  semantic-ia-fast-mouse-jump semantic-ia-fast-jump semantic-ia-show-variants
;;;;;;  semantic-ia-show-summary semantic-ia-complete-tip semantic-ia-complete-symbol-menu
;;;;;;  semantic-ia-complete-symbol) "semantic/ia" "ia.el" "9c0894ca0f132524fdab9a6e907fd081")
;;; Generated autoloads from ia.el

(autoload 'semantic-ia-complete-symbol "semantic/ia" "\
Complete the current symbol at POS.
If POS is nil, default to point.
Completion options are calculated with `semantic-analyze-possible-completions'.

\(fn &optional POS)" t nil)

(autoload 'semantic-ia-complete-symbol-menu "semantic/ia" "\
Complete the current symbol via a menu based at POINT.
Completion options are calculated with `semantic-analyze-possible-completions'.

\(fn POINT)" t nil)

(autoload 'semantic-ia-complete-tip "semantic/ia" "\
Pop up a tooltip for completion at POINT.

\(fn POINT)" t nil)

(autoload 'semantic-ia-show-summary "semantic/ia" "\
Display a summary for the symbol under POINT.

\(fn POINT)" t nil)

(autoload 'semantic-ia-show-variants "semantic/ia" "\
Display a list of all variants for the symbol under POINT.

\(fn POINT)" t nil)

(autoload 'semantic-ia-fast-jump "semantic/ia" "\
Jump to the tag referred to by the code at POINT.
Uses `semantic-analyze-current-context' output to identify an accurate
origin of the code at point.

\(fn POINT)" t nil)

(autoload 'semantic-ia-fast-mouse-jump "semantic/ia" "\
Jump to the tag referred to by the point clicked on.
See `semantic-ia-fast-jump' for details on how it works.
 This command is meant to be bound to a mouse event.

\(fn EVT)" t nil)

(autoload 'semantic-ia-show-doc "semantic/ia" "\
Display the code-level documentation for the symbol at POINT.

\(fn POINT)" t nil)

(autoload 'semantic-ia-describe-class "semantic/ia" "\
Display all known parts for the datatype TYPENAME.
If the type in question is a class, all methods and other accessible
parts of the parent classes are displayed.

\(fn TYPENAME)" t nil)

;;;***

;;;### (autoloads (semantic-speedbar-analysis) "semantic/ia-sb" "ia-sb.el"
;;;;;;  "38b0223a5c7313337be26c7b14c73d6f")
;;; Generated autoloads from ia-sb.el

(autoload 'semantic-speedbar-analysis "semantic/ia-sb" "\
Start Speedbar in semantic analysis mode.
The analyzer displays information about the current context, plus a smart
list of possible completions.

\(fn)" t nil)

;;;***

;;;### (autoloads (global-semantic-idle-scheduler-mode semantic-idle-scheduler-mode)
;;;;;;  "semantic/idle" "idle.el" "2f4b51b76eab7e242e5bd1c5f999f9dd")
;;; Generated autoloads from idle.el

(autoload 'semantic-idle-scheduler-mode "semantic/idle" "\
Minor mode to auto parse buffer following a change.
When this mode is off, a buffer is only rescanned for tokens when
some command requests the list of available tokens.  When idle-scheduler
is enabled, Emacs periodically checks to see if the buffer is out of
date, and reparses while the user is idle (not typing.)

With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\(fn &optional ARG)" t nil)

(defvar global-semantic-idle-scheduler-mode nil "\
Non-nil if Global-Semantic-Idle-Scheduler mode is enabled.
See the command `global-semantic-idle-scheduler-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-idle-scheduler-mode'.")

(custom-autoload 'global-semantic-idle-scheduler-mode "semantic/idle" nil)

(autoload 'global-semantic-idle-scheduler-mode "semantic/idle" "\
Toggle global use of option `semantic-idle-scheduler-mode'.
The idle scheduler will automatically reparse buffers in idle time,
and then schedule other jobs setup with `semantic-idle-scheduler-add'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (semantic-create-imenu-index semantic-imenu-expand-type-members
;;;;;;  semantic-imenu-bucketize-file semantic-imenu-summary-function)
;;;;;;  "semantic/imenu" "imenu.el" "f266140ffee1d7000efd88b5eba51a18")
;;; Generated autoloads from imenu.el

(defvar semantic-imenu-summary-function 'semantic-format-tag-abbreviate "\
*Function to use when creating items in Imenu.
Some useful functions are found in `semantic-format-tag-functions'.")

(custom-autoload 'semantic-imenu-summary-function "semantic/imenu" t)

(defvar semantic-imenu-bucketize-file t "\
*Non-nil if tags in a file are to be grouped into buckets.")

(custom-autoload 'semantic-imenu-bucketize-file "semantic/imenu" t)

(defvar semantic-imenu-expand-type-members t "\
*Non-nil if types should have submenus with members in them.")

(custom-autoload 'semantic-imenu-expand-type-members "semantic/imenu" t)

(defvar semantic-imenu-expandable-tag-classes '(type) "\
List of expandable tag classes.
Tags of those classes will be given submenu with children.
By default, a `type' has interesting children.  In Texinfo, however, a
`section' has interesting children.")

(autoload 'semantic-create-imenu-index "semantic/imenu" "\
Create an imenu index for any buffer which supports Semantic.
Uses the output of the Semantic parser to create the index.
Optional argument STREAM is an optional stream of tags used to create menus.

\(fn &optional STREAM)" nil nil)

;;;***

;;;### (autoloads (semantic-lex) "semantic/lex" "lex.el" "74a8a08bddea2b46e07e49dd5ee905e2")
;;; Generated autoloads from lex.el

(autoload 'semantic-lex "semantic/lex" "\
Lexically analyze text in the current buffer between START and END.
Optional argument DEPTH indicates at what level to scan over entire
lists.  The last argument, LENGTH specifies that `semantic-lex'
should only return LENGTH tokens.  The return value is a token stream.
Each element is a list, such of the form
  (symbol start-expression .  end-expression)
where SYMBOL denotes the token type.
See `semantic-lex-tokens' variable for details on token types.  END
does not mark the end of the text scanned, only the end of the
beginning of text scanned.  Thus, if a string extends past END, the
end of the return token will be larger than END.  To truly restrict
scanning, use `narrow-to-region'.

\(fn START END &optional DEPTH LENGTH)" nil nil)

;;;***

;;;### (autoloads (semantic-lex-spp-table-write-slot-value) "semantic/lex-spp"
;;;;;;  "lex-spp.el" "87180b7d660a9384a987378057662632")
;;; Generated autoloads from lex-spp.el

(autoload 'semantic-lex-spp-table-write-slot-value "semantic/lex-spp" "\
Write out the VALUE of a slot for EIEIO.
The VALUE is a spp lexical table.

\(fn VALUE)" nil nil)

;;;***

;;;### (autoloads (global-semantic-mru-bookmark-mode) "semantic/mru-bookmark"
;;;;;;  "mru-bookmark.el" "c088dd47aaec4c002897fc506266fa26")
;;; Generated autoloads from mru-bookmark.el

(defvar global-semantic-mru-bookmark-mode nil "\
Non-nil if Global-Semantic-Mru-Bookmark mode is enabled.
See the command `global-semantic-mru-bookmark-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-mru-bookmark-mode'.")

(custom-autoload 'global-semantic-mru-bookmark-mode "semantic/mru-bookmark" nil)

(autoload 'global-semantic-mru-bookmark-mode "semantic/mru-bookmark" "\
Toggle global use of option `semantic-mru-bookmark-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (semantic-calculate-scope) "semantic/scope" "scope.el"
;;;;;;  "b469c4d54fa7220d5020919624cbdc50")
;;; Generated autoloads from scope.el

(autoload 'semantic-calculate-scope "semantic/scope" "\
Calculate the scope at POINT.
If POINT is not provided, then use the current location of point.
The class returned from the scope calculation is variable
`semantic-scope-cache'.

\(fn &optional POINT)" t nil)

;;;***

;;;### (autoloads (senator-transpose-tags-down senator-transpose-tags-up
;;;;;;  senator-copy-tag-to-register senator-yank-tag senator-kill-tag
;;;;;;  senator-copy-tag senator-go-to-up-reference senator-previous-tag
;;;;;;  senator-next-tag senator-step-at-start-end-tag-classes senator-step-at-tag-classes)
;;;;;;  "semantic/senator" "senator.el" "7ff453cdf89a91c3baaef97b981cb4be")
;;; Generated autoloads from senator.el

(defvar senator-step-at-tag-classes nil "\
List of tag classes recognized by Senator's navigation commands.
A tag class is a symbol, such as `variable', `function', or `type'.

As a special exception, if the value is nil, Senator's navigation
commands recognize all tag classes.")

(custom-autoload 'senator-step-at-tag-classes "semantic/senator" t)

(make-variable-buffer-local 'senator-step-at-tag-classes)

(defvar senator-step-at-start-end-tag-classes nil "\
List of tag classes at which Senator's navigation commands should stop.
A tag class is a symbol, such as `variable', `function', or `type'.
The navigation commands stop at the start and end of each tag
class in this list, provided the tag class is recognized (see
`senator-step-at-tag-classes').

As a special exception, if the value is nil, the navigation
commands stop at the beginning of every tag.

If t, the navigation commands stop at the start and end of any
tag, where possible.")

(custom-autoload 'senator-step-at-start-end-tag-classes "semantic/senator" t)

(make-variable-buffer-local 'senator-step-at-start-end-tag-classes)

(autoload 'senator-next-tag "semantic/senator" "\
Navigate to the next Semantic tag.
Return the tag or nil if at end of buffer.

\(fn)" t nil)

(autoload 'senator-previous-tag "semantic/senator" "\
Navigate to the previous Semantic tag.
Return the tag or nil if at beginning of buffer.

\(fn)" t nil)

(autoload 'senator-go-to-up-reference "semantic/senator" "\
Move up one reference from the current TAG.
A \"reference\" could be any interesting feature of TAG.
In C++, a function may have a 'parent' which is non-local.
If that parent which is only a reference in the function tag
is found, we can jump to it.
Some tags such as includes have other reference features.

\(fn &optional TAG)" t nil)

(autoload 'senator-copy-tag "semantic/senator" "\
Take the current tag, and place it in the tag ring.

\(fn)" t nil)

(autoload 'senator-kill-tag "semantic/senator" "\
Take the current tag, place it in the tag ring, and kill it.
Killing the tag removes the text for that tag, and places it into
the kill ring.  Retrieve that text with \\[yank].

\(fn)" t nil)

(autoload 'senator-yank-tag "semantic/senator" "\
Yank a tag from the tag ring.
The form the tag takes is different depending on where it is being
yanked to.

\(fn)" t nil)

(autoload 'senator-copy-tag-to-register "semantic/senator" "\
Copy the current tag into REGISTER.
Optional argument KILL-FLAG will delete the text of the tag to the
kill ring.

\(fn REGISTER &optional KILL-FLAG)" t nil)

(autoload 'senator-transpose-tags-up "semantic/senator" "\
Transpose the current tag, and the preceding tag.

\(fn)" t nil)

(autoload 'senator-transpose-tags-down "semantic/senator" "\
Transpose the current tag, and the following tag.

\(fn)" t nil)

;;;***

;;;### (autoloads (semantic-tag-external-member-parent semantic-flatten-tags-table)
;;;;;;  "semantic/sort" "sort.el" "56cc425f78191d79424279ff61f24c2c")
;;; Generated autoloads from sort.el

(autoload 'semantic-flatten-tags-table "semantic/sort" "\
Flatten the tags table TABLE.
All tags in TABLE, and all components of top level tags
in TABLE will appear at the top level of list.
Tags promoted to the top of the list will still appear
unmodified as components of their parent tags.

\(fn &optional TABLE)" nil nil)

(autoload 'semantic-tag-external-member-parent "semantic/sort" "\
Return a parent for TAG when TAG is an external member.
TAG is an external member if it is defined at a toplevel and
has some sort of label defining a parent.  The parent return will
be a string.

The default behavior, if not overridden with
`tag-member-parent' gets the 'parent extra
specifier of TAG.

If this function is overridden, use
`semantic-tag-external-member-parent-default' to also
include the default behavior, and merely extend your own.

\(fn TAG)" nil nil)

;;;***

;;;### (autoloads (semantic-symref-find-text semantic-symref-find-file-references-by-name
;;;;;;  semantic-symref-find-tags-by-completion semantic-symref-find-tags-by-regexp
;;;;;;  semantic-symref-find-tags-by-name semantic-symref-find-references-by-name)
;;;;;;  "semantic/symref" "symref.el" "b09faca854169c69e14c72f67b9a26f8")
;;; Generated autoloads from symref.el

(autoload 'semantic-symref-find-references-by-name "semantic/symref" "\
Find a list of references to NAME in the current project.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.
TOOL-RETURN is an optional symbol, which will be assigned the tool used
to perform the search.  This was added for use by a test harness.

\(fn NAME &optional SCOPE TOOL-RETURN)" t nil)

(autoload 'semantic-symref-find-tags-by-name "semantic/symref" "\
Find a list of tags by NAME in the current project.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.

\(fn NAME &optional SCOPE)" t nil)

(autoload 'semantic-symref-find-tags-by-regexp "semantic/symref" "\
Find a list of references to NAME in the current project.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.

\(fn NAME &optional SCOPE)" t nil)

(autoload 'semantic-symref-find-tags-by-completion "semantic/symref" "\
Find a list of references to NAME in the current project.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.

\(fn NAME &optional SCOPE)" t nil)

(autoload 'semantic-symref-find-file-references-by-name "semantic/symref" "\
Find a list of references to NAME in the current project.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.

\(fn NAME &optional SCOPE)" t nil)

(autoload 'semantic-symref-find-text "semantic/symref" "\
Find a list of occurrences of TEXT in the current project.
TEXT is a regexp formatted for use with egrep.
Optional SCOPE specifies which file set to search.  Defaults to 'project.
Refers to `semantic-symref-tool', to determine the reference tool to use
for the current buffer.
Returns an object of class `semantic-symref-result'.

\(fn TEXT &optional SCOPE)" t nil)

;;;***

;;;### (autoloads (semantic-symref-tool-cscope) "semantic/symref/cscope"
;;;;;;  "symref/cscope.el" "22f112c6bd920497aabfe98ed34011c7")
;;; Generated autoloads from symref/cscope.el

(eieio-defclass-autoload 'semantic-symref-tool-cscope '(semantic-symref-tool-baseclass) "semantic/symref/cscope" "A symref tool implementation using CScope.\nThe CScope command can be used to generate lists of tags in a way\nsimilar to that of `grep'.  This tool will parse the output to generate\nthe hit list.\n\nSee the function `cedet-cscope-search' for more details.")

;;;***

;;;### (autoloads (semantic-symref-tool-global) "semantic/symref/global"
;;;;;;  "symref/global.el" "92163d1626dc26b29f3dfe9ffde60948")
;;; Generated autoloads from symref/global.el

(eieio-defclass-autoload 'semantic-symref-tool-global '(semantic-symref-tool-baseclass) "semantic/symref/global" "A symref tool implementation using GNU Global.\nThe GNU Global command can be used to generate lists of tags in a way\nsimilar to that of `grep'.  This tool will parse the output to generate\nthe hit list.\n\nSee the function `cedet-gnu-global-search' for more details.")

;;;***

;;;### (autoloads (semantic-symref-tool-grep) "semantic/symref/grep"
;;;;;;  "symref/grep.el" "3c4fded67e7e75aa84d96c0b33ec563d")
;;; Generated autoloads from symref/grep.el

(eieio-defclass-autoload 'semantic-symref-tool-grep '(semantic-symref-tool-baseclass) "semantic/symref/grep" "A symref tool implementation using grep.\nThis tool uses EDE to find he root of the project, then executes\nfind-grep in the project.  The output is parsed for hits\nand those hits returned.")

;;;***

;;;### (autoloads (semantic-symref-tool-idutils) "semantic/symref/idutils"
;;;;;;  "symref/idutils.el" "cf142ab124074d31e32c897de2f6bfe1")
;;; Generated autoloads from symref/idutils.el

(eieio-defclass-autoload 'semantic-symref-tool-idutils '(semantic-symref-tool-baseclass) "semantic/symref/idutils" "A symref tool implementation using ID Utils.\nThe udutils command set can be used to generate lists of tags in a way\nsimilar to that of `grep'.  This tool will parse the output to generate\nthe hit list.\n\nSee the function `cedet-idutils-search' for more details.")

;;;***

;;;### (autoloads (semantic-symref-regexp semantic-symref-symbol
;;;;;;  semantic-symref) "semantic/symref/list" "symref/list.el"
;;;;;;  "d408916c24a8d37bef2bc9a2925c4ea7")
;;; Generated autoloads from symref/list.el

(autoload 'semantic-symref "semantic/symref/list" "\
Find references to the current tag.
This command uses the currently configured references tool within the
current project to find references to the current tag.  The
references are organized by file and the name of the function
they are used in.
Display the references in `semantic-symref-results-mode'.

\(fn)" t nil)

(autoload 'semantic-symref-symbol "semantic/symref/list" "\
Find references to the symbol SYM.
This command uses the currently configured references tool within the
current project to find references to the input SYM.  The
references are organized by file and the name of the function
they are used in.
Display the references in `semantic-symref-results-mode'.

\(fn SYM)" t nil)

(autoload 'semantic-symref-regexp "semantic/symref/list" "\
Find references to the a symbol regexp SYM.
This command uses the currently configured references tool within the
current project to find references to the input SYM.  The
references are the organized by file and the name of the function
they are used in.
Display the references in`semantic-symref-results-mode'.

\(fn SYM)" t nil)

;;;***

;;;### (autoloads (semantic-tag-components) "semantic/tag" "tag.el"
;;;;;;  "6f9c5c0e4638e2cf7f913f7d61a7ff3d")
;;; Generated autoloads from tag.el

(autoload 'semantic-tag-components "semantic/tag" "\
Return a list of components for TAG.
A Component is a part of TAG which itself may be a TAG.
Examples include the elements of a structure in a
tag of class `type, or the list of arguments to a
tag of class 'function.

\(fn TAG)" nil nil)

;;;***

;;;### (autoloads (semantic-dependency-tag-file semantic-go-to-tag)
;;;;;;  "semantic/tag-file" "tag-file.el" "d6ed698e3736b0e71e23c8d8eccd3b7d")
;;; Generated autoloads from tag-file.el

(autoload 'semantic-go-to-tag "semantic/tag-file" "\
Go to the location of TAG.
TAG may be a stripped element, in which case PARENT specifies a
parent tag that has position information.
PARENT can also be a `semanticdb-table' object.

\(fn TAG &optional PARENT)" nil nil)

(autoload 'semantic-dependency-tag-file "semantic/tag-file" "\
Find the filename represented from TAG.
Depends on `semantic-dependency-include-path' for searching.  Always searches
`.' first, then searches additional paths.

\(fn &optional TAG)" nil nil)

;;;***

;;;### (autoloads (semantic-tag-prototype-p) "semantic/tag-ls" "tag-ls.el"
;;;;;;  "5006320cc9ffd87ceb50dba31524ae31")
;;; Generated autoloads from tag-ls.el

(autoload 'semantic-tag-prototype-p "semantic/tag-ls" "\
Return non nil if TAG is a prototype.
For some languages, such as C, a prototype is a declaration of
something without an implementation.

\(fn TAG)" nil nil)

;;;***

;;;### (autoloads (semantic-tag-write-list-slot-value) "semantic/tag-write"
;;;;;;  "tag-write.el" "14bbea4f1262c16c8b98ade71ad82b56")
;;; Generated autoloads from tag-write.el

(autoload 'semantic-tag-write-list-slot-value "semantic/tag-write" "\
Write out the VALUE of a slot for EIEIO.
The VALUE is a list of tags.

\(fn VALUE)" nil nil)

;;;***

;;;### (autoloads (semantic-default-texi-setup) "semantic/texi" "texi.el"
;;;;;;  "122d6e815ca6e24b13b5bb523a49df19")
;;; Generated autoloads from texi.el

(autoload 'semantic-default-texi-setup "semantic/texi" "\
Set up a buffer for parsing of Texinfo files.

\(fn)" nil nil)

;;;***

;;;### (autoloads (semantic-highlight-func-mode global-semantic-highlight-func-mode
;;;;;;  semantic-stickyfunc-mode global-semantic-stickyfunc-mode
;;;;;;  semantic-show-parser-state-mode global-semantic-show-parser-state-mode
;;;;;;  semantic-show-unmatched-syntax-mode global-semantic-show-unmatched-syntax-mode
;;;;;;  semantic-highlight-edits-mode global-semantic-highlight-edits-mode)
;;;;;;  "semantic/util-modes" "util-modes.el" "77d87e5b3a38b2110c5be2ce36d74979")
;;; Generated autoloads from util-modes.el

(defvar global-semantic-highlight-edits-mode nil "\
Non-nil if Global-Semantic-Highlight-Edits mode is enabled.
See the command `global-semantic-highlight-edits-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-highlight-edits-mode'.")

(custom-autoload 'global-semantic-highlight-edits-mode "semantic/util-modes" nil)

(autoload 'global-semantic-highlight-edits-mode "semantic/util-modes" "\
Toggle global use of option `semantic-highlight-edits-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

(autoload 'semantic-highlight-edits-mode "semantic/util-modes" "\
Minor mode for highlighting changes made in a buffer.
Changes are tracked by semantic so that the incremental parser can work
properly.
This mode will highlight those changes as they are made, and clear them
when the incremental parser accounts for those edits.
With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\(fn &optional ARG)" t nil)

(defvar global-semantic-show-unmatched-syntax-mode nil "\
Non-nil if Global-Semantic-Show-Unmatched-Syntax mode is enabled.
See the command `global-semantic-show-unmatched-syntax-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-show-unmatched-syntax-mode'.")

(custom-autoload 'global-semantic-show-unmatched-syntax-mode "semantic/util-modes" nil)

(autoload 'global-semantic-show-unmatched-syntax-mode "semantic/util-modes" "\
Toggle global use of option `semantic-show-unmatched-syntax-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

(autoload 'semantic-show-unmatched-syntax-mode "semantic/util-modes" "\
Minor mode to highlight unmatched lexical syntax tokens.
When a parser executes, some elements in the buffer may not match any
parser rules.  These text characters are considered unmatched syntax.
Often time, the display of unmatched syntax can expose coding
problems before the compiler is run.

With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\\{semantic-show-unmatched-syntax-mode-map}

\(fn &optional ARG)" t nil)

(defvar global-semantic-show-parser-state-mode nil "\
Non-nil if Global-Semantic-Show-Parser-State mode is enabled.
See the command `global-semantic-show-parser-state-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-show-parser-state-mode'.")

(custom-autoload 'global-semantic-show-parser-state-mode "semantic/util-modes" nil)

(autoload 'global-semantic-show-parser-state-mode "semantic/util-modes" "\
Toggle global use of option `semantic-show-parser-state-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

(autoload 'semantic-show-parser-state-mode "semantic/util-modes" "\
Minor mode for displaying parser cache state in the modeline.
The cache can be in one of three states.  They are
Up to date, Partial reparse needed, and Full reparse needed.
The state is indicated in the modeline with the following characters:
 `-'  ->  The cache is up to date.
 `!'  ->  The cache requires a full update.
 `~'  ->  The cache needs to be incrementally parsed.
 `%'  ->  The cache is not currently parsable.
 `@'  ->  Auto-parse in progress (not set here.)
With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\(fn &optional ARG)" t nil)

(defvar global-semantic-stickyfunc-mode nil "\
Non-nil if Global-Semantic-Stickyfunc mode is enabled.
See the command `global-semantic-stickyfunc-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-stickyfunc-mode'.")

(custom-autoload 'global-semantic-stickyfunc-mode "semantic/util-modes" nil)

(autoload 'global-semantic-stickyfunc-mode "semantic/util-modes" "\
Toggle global use of option `semantic-stickyfunc-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

(autoload 'semantic-stickyfunc-mode "semantic/util-modes" "\
Minor mode to show the title of a tag in the header line.
Enables/disables making the header line of functions sticky.
A function (or other tag class specified by
`semantic-stickyfunc-sticky-classes') has a header line, meaning the
first line which describes the rest of the construct.  This first
line is what is displayed in the header line.

With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\(fn &optional ARG)" t nil)

(defvar global-semantic-highlight-func-mode nil "\
Non-nil if Global-Semantic-Highlight-Func mode is enabled.
See the command `global-semantic-highlight-func-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-semantic-highlight-func-mode'.")

(custom-autoload 'global-semantic-highlight-func-mode "semantic/util-modes" nil)

(autoload 'global-semantic-highlight-func-mode "semantic/util-modes" "\
Toggle global use of option `semantic-highlight-func-mode'.
If ARG is positive or nil, enable, if it is negative, disable.

\(fn &optional ARG)" t nil)

(autoload 'semantic-highlight-func-mode "semantic/util-modes" "\
Minor mode to highlight the first line of the current tag.
Enables/disables making the current function's first line light up.
A function (or other tag class specified by
`semantic-stickyfunc-sticky-classes') is highlighted, meaning the
first line which describes the rest of the construct.

See `semantic-stickyfunc-mode' for putting a function in the
header line.  This mode recycles the stickyfunc configuration
classes list.

With prefix argument ARG, turn on if positive, otherwise off.  The
minor mode can be turned on only if semantic feature is available and
the current buffer was set up for parsing.  Return non-nil if the
minor mode is enabled.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads (wisent-java-default-setup) "semantic/wisent/java-tags"
;;;;;;  "wisent/java-tags.el" "22ac21aa1cac200b7dc8f881096be0c1")
;;; Generated autoloads from wisent/java-tags.el

(autoload 'wisent-java-default-setup "semantic/wisent/java-tags" "\
Hook run to setup Semantic in `java-mode'.
Use the alternate LALR(1) parser.

\(fn)" nil nil)

;;;***

;;;### (autoloads (wisent-javascript-setup-parser) "semantic/wisent/javascript"
;;;;;;  "wisent/javascript.el" "dd992c38af65372cafe96d1ef8770f04")
;;; Generated autoloads from wisent/javascript.el

(autoload 'wisent-javascript-setup-parser "semantic/wisent/javascript" "\
Setup buffer for parse.

\(fn)" nil nil)

;;;***

;;;### (autoloads (wisent-python-default-setup) "semantic/wisent/python"
;;;;;;  "wisent/python.el" "eb88038b5123e3924ad68ac0205f59e3")
;;; Generated autoloads from wisent/python.el

(autoload 'wisent-python-default-setup "semantic/wisent/python" "\
Setup buffer for parse.

\(fn)" nil nil)

(add-hook 'python-mode-hook 'wisent-python-default-setup)

;;;***

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
