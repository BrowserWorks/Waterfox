[= Autogen5 Template -*- Mode: scheme -*-

#  List the output suffixes that are to be generated.
#  Header must come first.  An env variable is set that
#  is used in processing the C file.
#
#  $Id$
# Time-stamp:      "2010-02-24 08:41:08 bkorb"

h
c

# This file contains the templates used to generate the
# option descriptions for client programs, and it declares
# the macros used in the templates.

##  This file is part of AutoOpts, a companion to AutoGen.
##  AutoOpts is free software.
##  AutoOpts is Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
##
##  AutoOpts is available under any one of two licenses.  The license
##  in use must be one of these two and the choice is under the control
##  of the user of the license.
##
##   The GNU Lesser General Public License, version 3 or later
##      See the files "COPYING.lgplv3" and "COPYING.gplv3"
##
##   The Modified Berkeley Software Distribution License
##      See the file "COPYING.mbsd"
##
##  These files have the following md5sums:
##
##  43b91e8ca915626ed3818ffb1b71248b pkg/libopts/COPYING.gplv3
##  06a1a2e4760c90ea5e1dad8dfaac4d39 pkg/libopts/COPYING.lgplv3
##  66a5cedaf62c4b2637025f049f9b826f pkg/libopts/COPYING.mbsd

(define have-cb-procs     (make-hash-table 31))
(define is-ext-cb-proc    (make-hash-table 31))
(define is-lib-cb-proc    (make-hash-table 31))
(define cb-proc-name      (make-hash-table 31))
(define test-proc-name    (make-hash-table 31))
(define disable-name      (make-hash-table 31))
(define disable-prefix    (make-hash-table 31))
(define ifdef-ed          (make-hash-table 31))
(define tmp-ct            0)

(define extract-fmt       "\n/* extracted from %s near line %d */\n")

(setenv "SHELL" "/bin/sh")

=][=

 (if (= "h" (suffix))
     (begin
          (if (not (exist? "flag.name"))
              (error "No options have been defined" ))

          (if (> (count "flag") 100)
              (error (sprintf "%d options are too many - limit of 100"
                          (count "flag")) ))

          (if (not (and (exist? "prog-name") (exist? "prog-title")))
              (error "prog-name and prog-title are required"))
          (define prog-name (get "prog-name"))
          (if (> (string-length prog-name) 16)
              (error (sprintf "prog-name limited to 16 characters:  %s"
                              prog-name)) )
     )

     (if (exist? "library") (out-delete))
 )

 (dne " *  " "/*  ")    =]
 *
 * Generated from AutoOpts 33:2:8 templates.
 */[=

  INCLUDE "optlib.tpl"  =]
[= INVOKE Option_Copyright =][=

CASE    (suffix)        =][=

== h                    =][=

  `tried=""
   test_exe() {
     tried="${tried} ${1}"
     test -n "${1}" && test -x ${1} && ${1} -v >/dev/null
     test $? -ne 0 && return 1
     CLexe=${1}
   }
   prefix="/usr"
   exec_prefix="${prefix}"
   test_exe "${CLexe}" || \
     test_exe ${top_builddir}/columns/columns || \
     test_exe "${exec_prefix}/bin/columns" || \
     test_exe columns || \
     die "cannot locate columns program:  ${tried}"
  `

=][=

  (define do-ifdefs (or (exist? "flag.ifdef") (exist? "flag.ifndef")))

  ;; IF    long options are disallowed
  ;;   AND at least one flag character (value) is supplied
  ;; THEN every option must have a 'value' attribute
  ;;
  (define flag-options-only
          (and (not (exist? "long-opts")) (exist? "flag.value")))

  (if (and (exist? "reorder-args") (not (exist? "argument")) )
    (error
      "Reordering arguments requires operands (the 'argument' attribute)"))

  (if (and flag-options-only (exist? "flag.disable"))
      (error "options can be disabled only with a long option name"))

  (if (exist? "flag.extract-code")
      (shellf "f=%s.c ; test -s $f && mv -f $f $f.save"
              (base-name)))

  (if (and (exist? "usage") (exist? "gnu-usage"))
      (error "'usage' and 'gnu-usage' conflict." ))

  (if (> (count "flag.default") 1)
      (error "Too many default options"))

  (if (exist? "library") (begin
      (if (not (exist? "flag[0].documentation")) (error
          "The first option of a library must be a documentation option"))
      (if (not (exist? "flag[0].lib-name"))
          (error "The first option of a library must specify 'lib-name'"))
      (if (< 1 (count "flag.lib-name"))
          (error "a library must only have one 'flag.lib-name'"))
  )   )

  ;;  Establish a number of variations on the spelling of the
  ;;  program name.  Use these Scheme defined values throughout.
  ;;
  (define pname           (string->c-name!    (get "prog-name")))
  (define pname-cap       (string-capitalize  pname))
  (define pname-up        (string-upcase      pname))
  (define pname-down      (string-downcase    pname))
  (define main-guard      (string-append "TEST_" pname-up "_OPTS" ))
  (define number-opt-index  -1)
  (define default-opt-index -1)
  (define make-test-main  (if (exist? "test-main") #t
                              (string? (getenv "TEST_MAIN")) ))

  (define descriptor "")
  (define opt-name   "")
  (define flg-name   "")
  (define UP-name    "")
  (define cap-name   "")
  (define low-name   "")
  (define tmp-val    "")
  (define enum-pfx   "")
  (define added-hdr  "")
  (make-tmp-dir)

  (define set-flag-names (lambda () (begin
      (set! flg-name (get "name"))
      (set! UP-name  (up-c-name "name"))
      (set! cap-name (string-capitalize UP-name ))
      (set! low-name (string-downcase   UP-name ))
      (set! enum-pfx (if (exist? ".prefix-enum")
                         (up-c-name (string-append (get "prefix-enum") "_"))
                         (string-append UP-prefix UP-name "_") ))
  ) ) )

  (if (exist? "prefix")
   (begin
     (define UP-prefix  (string-append (string-upcase! (get "prefix")) "_"))
     (define Cap-prefix (string-capitalize UP-prefix))
     (define OPT-pfx    (string-append UP-prefix "OPT_"))
     (define INDEX-pfx  (string-append "INDEX_" OPT-pfx))
     (define VALUE-pfx  (string-append "VALUE_" OPT-pfx))
   )
   (begin
     (define UP-prefix  "")
     (define Cap-prefix "")
     (define OPT-pfx    "OPT_")
     (define INDEX-pfx  "INDEX_OPT_")
     (define VALUE-pfx  "VALUE_OPT_")
   )  )

   (define up-c-name  (lambda (ag-name)
      (string-upcase! (string->c-name! (get ag-name)))  ))

   (define cap-c-name  (lambda (ag-name)
      (string-capitalize! (string->c-name! (get ag-name)))  ))

   (define down-c-name  (lambda (ag-name)
      (string-downcase! (string->c-name! (get ag-name)))  ))

   (define index-name (lambda (i-name)
      (string-append INDEX-pfx (up-c-name i-name))  ))

   (if (exist? "preserve-case")
      (begin
        (define optname-from "_^")
        (define optname-to   "--")
      )
      (begin
        (define optname-from "A-Z_^")
        (define optname-to   "a-z--")
   )  )

   (define version-text (string-append prog-name
           (if (exist? "package")
               (string-append " (" (get "package") ")")
               "" )
           " - " (get "prog-title")
           (if (exist? "version")
               (string-append " - Ver. " (get "version"))
               "" ) ))

   (if (exist? "flag.value")
       (shellf "

list=`echo '%s' | sort`
ulst=`echo \"${list}\" | sort -u`
test `echo \"${ulst}\" | wc -l` -ne %d && {
  echo \"${list}\" > ${tmp_dir}/sort
  echo \"${ulst}\" > ${tmp_dir}/uniq
  df=`diff ${tmp_dir}/sort ${tmp_dir}/uniq | sed -n 's/< *//p'`
  die 'duplicate option value characters:' ${df}
}"

           (join "\n" (stack "flag.value"))
           (count "flag.value") ) )

   (define lib-opt-ptr  "")
   (define max-name-len 10)

  =][=
  FOR flag              =][=

    (set! tmp-ct (len "name"))
    (if (> tmp-ct 32)
        (error (sprintf "Option %d name exceeds 32 characters: %s"
                       (for-index) (get "name")) ))
    (if (> tmp-ct max-name-len)
        (set! max-name-len tmp-ct))

    (if (< 1 (count "value"))
        (error (sprintf "Option %s has too many `value's" (get "name"))))

    (if (and flag-options-only
             (not (exist? "documentation"))
             (not (exist? "value")))
        (error (sprintf "Option %s needs a `value' attribute" (get "name"))))

    (set! tmp-val
           (+ (if (exist? "call-proc")    1 0)
              (if (exist? "flag-code")    1 0)
              (if (exist? "extract-code") 1 0)
              (if (exist? "flag-proc")    1 0)
              (if (exist? "unstack-arg")  1 0)
              (if (exist? "stack-arg")    1 0)  ))

    ;;  IF there is one of the above callback proc types AND there is an
    ;;     option argument of type non-string, THEN oops.  Conflict.
    ;;
    (if (and (> tmp-val 0) (exist? "arg-type")
             (not (=* (get "arg-type") "str"))  )
        (error (sprintf
               "Option %s has a %s argument and a callback procedure"
               (get "name") (get "arg-type") )
    )   )

    ;;  Count up the ways a callback procedure was specified.  Must be 0 or 1
    ;;
    (if (< 1 (+ (if (exist? "arg-range") 1 0)
                (if (~* (get "arg-type") "key|set") 1 0) tmp-val))
       (error (sprintf "Option %s has multiple callback specifications"
                      (get "name")) ))

    (if (< 1 (+ (count "ifdef") (count "ifndef") ))
        (error (sprintf "Option %s has multiple 'ifdef-es'" (get "name") )) )

    (if (and (exist? "stack-arg") (not (exist? "arg-type")))
        (error (sprintf "Option %s has stacked args, but no arg-type"
                        (get "name"))))

    (if (and (exist? "min") (exist? "must-set"))
        (error (sprintf "Option %s has both 'min' and 'must-set' attributes"
                        (get "name"))))

    (if (and (exist? "omitted-usage")
             (not (exist? "ifdef"))
             (not (exist? "ifndef")) )
        (error (string-append "Option " (get "name") " has 'omitted-usage' "
               "but neither 'ifdef' nor 'ifndef'" )) )

    (if (and (exist? "equivalence")
             (exist? "aliases"))
        (error (string-append "Option " (get "name") " has both "
               "'equivalence' and 'aliases'" )) )

    (if (exist? "lib-name")
        (set! lib-opt-ptr (string->c-name! (string-append
                          (get "lib-name") "_" (get "name") "_optDesc_p"))) )
  =][=
  ENDFOR flag           =][=

  include "opthead"     =][= # create the option header

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

== c                    =][=

   (if (exist? "library") (out-delete))  =][=

   INCLUDE "optcode"    =][= ;; create the option source code

   (if (exist? "flag.extract-code")
       (shellf "test -f %1$s.c && rm -f %1$s.c.save" (base-name)))  =][=

ESAC =]
/* [= (out-name) =] ends here */[=

# options.tpl ends here =]
