[=

AutoGen5 Template

## Time-stamp:        "2010-02-24 08:39:02 bkorb"
##
##  This file is part of AutoGen.
##
##  AutoGen Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
##
##  AutoGen is free software: you can redistribute it and/or modify it
##  under the terms of the GNU General Public License as published by the
##  Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  AutoGen is distributed in the hope that it will be useful, but
##  WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##  See the GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License along
##  with this program.  If not, see <http://www.gnu.org/licenses/>.

=][=

(define restore-flags "")
(define (protect-text t)
    (string-substitute t
        '("["     "]"     "$"     "#"     )
        '("@<:@"  "@:>@"  "@S|@"  "@%:@"  ))  )
=][=

DEFINE preamble

=][=

  (define test-name (get "name"))
  (if (= (string-length test-name) 0)
      (set! test-name "test_name")
      (string->c-name! test-name) )

  (define author-name (get "author"))
  (define up-name     (string-upcase    test-name))
  (define down-name   (string-downcase  test-name))
  (define group-id    (string-downcase! (get "group")))
  (if (= (string-length group-id) 0)
      (set! group-id "ac")
      (string->c-name! group-id)  )
  (define group-pfx   (string-append    group-id "_"))
  (define mac-name    (string-upcase!   (string-append group-pfx
                      (get "type") "_" up-name)))
  (define sub-name    (string-upcase!   (string-append group-pfx down-name)))
  (define cv-name     (string-downcase! (string-append group-pfx "cv_"
                      (get "type") "_" down-name)))

=][=

ENDDEF   preamble

=][=

DEFINE  emit-macro       =][=

  CASE    type           =][=
  ~~  compile|run|link|test   =][=
      (define bad-define-name   "NEED_%s")
      (define good-define-name  "HAVE_%s")     =][=
  ~~  enable|disable     =][=
      (define bad-define-name   "%s_DISABLED")
      (define good-define-name  "%s_ENABLED")  =][=
  ~~  with|without       =][=
      (define bad-define-name   "WITHOUT_%s")
      (define good-define-name  "WITH_%s")     =][=
  ~~  withlib|withconf   =][=
      (define lib-name          (string-append "lib" down-name))
      (define bad-define-name   "WITHOUT_LIB%s")
      (define good-define-name  "WITH_LIB%s")     =][=
  ESAC  =][=

  IF  (define good-text  "")
      (define bad-text   "")
      (. separate-macros)    =][=

(dne "dnl " "dnl ")      =]
dnl
dnl @synopsis  [=(. mac-name)=]
dnl
dnl @success-result[=
    IF (<= (count "action") (count "action.no"))
      =]:  there is no output[=
    ELSE         =]
dnl[=
      FOR action =][=
        IF (not (exist? "no"))  =][=
          CASE  act-type  =][=
          ==  define      =]
dnl   * [=(sprintf good-define-name up-name)
          =] is #defined as [=?% act-text "%s" "1"=][=
          ==  subst       =]
dnl   * @[=(.  sub-name)=]@ is replaced by [=act-text=][=
          ==  script      =]
dnl   * a short script is run[=
          ESAC   =][=
        ENDIF    =][=
      ENDFOR     =][=
    ENDIF (<= (count "action") (count "action.no")) =]
dnl
dnl @failure-result[=
    IF (= (count "action.no") 0)
      =]:  there is no output[=
    ELSE         =]
dnl[=
      FOR action =][=
        IF (exist? "no")  =][=
          CASE  act-type  =][=
          ==  define      =]
dnl   * [=(sprintf bad-define-name up-name)
           =] is #defined as [=?% act-text "%s" "1"=][=
          ==  subst       =]
dnl   * @[=(. sub-name)=]@ is replaced by [=act-text=][=
          ==  script      =]
dnl   * a short script is run[=
          ESAC   =][=
        ENDIF    =][=
      ENDFOR     =][=
    ENDIF (= (count "action.no") 0) =][=

    IF   (define doc-text (get "doc"))
      (> (string-length doc-text) 0) =]
dnl
dnl @description
[=(prefix "dnl " doc-text) =][=
    ENDIF =][=

    IF  (> (string-length author-name) 0) =]
dnl
dnl @version "[=

 (strftime "%d-%B-%Y at %H:%M"
           (localtime (current-time)) ) =]"
dnl
dnl @author [=(. author-name)=][=

    ENDIF     =]
dnl[=

  ENDIF separate-macros

=]
AC_DEFUN([[=
  (define fcn-name (string-append "try-" (get "type")))
  (define c-text (get "code"))  =][=

  CASE code-mode  =][=
  = body  =][=
    (set! c-text (string-append "int main(int argc,char** argv) {\n"
          c-text "\nreturn 0; }" )) =][=
  = all   =][=
  ESAC    =][=

  (. mac-name)    =]],[[=

  IF (ag-function? fcn-name) =][=
    INVOKE (. fcn-name) =][=

  ELSE   =]

ERROR:  invalid conftest function:   ``[= (. fcn-name) =]''[=

  ENDIF  =]
[=(prefix "  " (join "\n" (stack "always")))
=]
]) # end of AC_DEFUN of [=(. mac-name)=]
[=

ENDDEF  emit-macro   =][=

# # # # # # # # # # # C-Feature # # # # # # # # # #

Stash the result of a C/C++ feature test =][=

DEFINE start-feat-test =][=
  (if (exist? "preamble") (prefix "  " (get "preamble"))) =]
  AC_MSG_CHECKING([whether [=(protect-text (get "check"))=]])[=
ENDDEF start-feat-test =][=

DEFINE  end-feat-test  =][=

  (. pop-language)     =]
  ]) # end of AC_CACHE_VAL for [=(. cv-name)=]
  AC_MSG_RESULT([${[=(. cv-name)=]}])[=
  emit-results         =][=

ENDDEF  end-feat-test  =][=

# # # # # # # # # # EMIT RESULTS # # # # # # # # # # =][=

DEFINE  emit-results   =][=

  (define good-subst 0 )
  (define bad-subst  0 )
  (define TMP-text   "")
  (define tmp-text   "") =][=

  IF (and (= (get "type") "withlib") (exist? "config")) =]
    AC_SUBST([LIB[=(. up-name)=]_CFLAGS])
    AC_SUBST([LIB[=(. up-name)=]_LIBS])
    AC_SUBST([LIB[=(. up-name)=]_PATH])[=

    (define good-subst 1)
    (define bad-subst  1)
    (set! good-text (string-append good-text (sprintf "[
      LIB%1$s_CFLAGS=\"${%2$s_cflags}\"
      LIB%1$s_LIBS=\"${%2$s_libs}\"
      case \"${LIB%1$s_LIBS}\" in *-L* )
        LIB%1$s_PATH=`echo ,${LIB%1$s_LIBS} | \
          sed 's/.*[, ]-L[ \t]*//;s/[ \t].*//'`
      ;; * ) LIB%1$s_PATH='' ;; esac]"
       up-name cv-name )))

    (set! bad-text (string-append bad-text (sprintf "
      LIB%1$s_CFLAGS=''
      LIB%1$s_LIBS=''
      LIB%1$s_PATH=''"  up-name )))  =][=

  ENDIF  type is withlib =][=

  FOR     action         =][=

    CASE (set! tmp-text (get "act-text"))
         (set! TMP-text (string-upcase tmp-text))
         (string-append
           (if (exist? "no") "no-" "yes-")
           (get "act-type"))
      =][=

    == yes-define        =][=
      (set! good-text (string-append good-text
            "\n    AC_DEFINE" (if (exist? "unquoted") "_UNQUOTED" "")
            "([" (sprintf good-define-name up-name) "],["
            (if (> (string-length tmp-text) 0) tmp-text "1")
            "],\n        [Define this if " (protect-text (get "check")) "])" ))
      =][=

    == yes-subst         =][=
      (set! good-subst 1)
      (set! good-text (string-append good-text
                   "\n    " sub-name "=" (protect-text (shell-str tmp-text)) ))
      =][=

    == yes-script        =][=
      (set! good-text (string-append good-text "\n    "
            (if (exist? "asis") tmp-text (protect-text tmp-text))  ))
      =][=

    ==  no-define        =][=
      (set! bad-text (string-append bad-text
            "\n    AC_DEFINE" (if (exist? "unquoted") "_UNQUOTED" "")
            "([" (sprintf bad-define-name up-name) "],["
            (if (> (string-length tmp-text) 0) tmp-text "1")
            "],\n        [Define this if '" (protect-text (get "check"))
                                       "' is not true])" ))
      =][=

    ==  no-subst         =][=
      (set! bad-subst  1)
      (set! bad-text (string-append bad-text
                   "\n    " sub-name "=" (protect-text (shell-str tmp-text)) ))
      =][=

    ==  no-script        =][=
      (set! bad-text (string-append bad-text "\n    "
            (if (exist? "asis") tmp-text (protect-text tmp-text))  ))
      =][=

    ESAC                 =][=
  ENDFOR  action         =][=

  (if (> good-subst 0)
      (if (< bad-subst 1)
          (set! bad-text (string-append bad-text "\n    "
                         sub-name "=''" ))  )
      (if (> bad-subst 0)
          (set! good-text (string-append good-text "\n    "
                         sub-name "=''" ))  )
  )

=]

  if test "X${[=(. cv-name)=]}" [=

  IF (> (string-length good-text) 0)

    =]!= Xno
  then[=
    (. good-text) =][=

    IF (> (string-length bad-text) 0) =]
  else[=
    ENDIF         =][=
  ELSE            =]= Xno
  then[=
  ENDIF           =][=
    (. bad-text)  =]
  fi[=

  (if (> (+ good-subst bad-subst) 0)
     (string-append "\n  AC_SUBST([" sub-name "])" ))  =][=

  FOR conditional =]
  AM_CONDITIONAL([[= conditional =]],[test "X${[=(. cv-name)=]}" != Xno])[=
  ENDFOR cond..   =][=

ENDDEF  emit-results   =][=

# # # # # # # # # # ENABLEMENT # # # # # # # # # # =][=

DEFINE  emit-enablement

  =]
  AC_ARG_[=arg-name=]([[=(string-tr down-name "_" "-")=]],
    AC_HELP_STRING([--[=type=]-[=(string-tr test-name "_A-Z" "-a-z")
                   =]], [[=check=]]),
    [[=(. cv-name)=]=${[=(string-downcase! (get "arg-name"))
      =]_[=(string-tr test-name "-A-Z" "_a-z")=]}],
    AC_CACHE_CHECK([whether [=check=]], [=(. cv-name)=],
      [=(. cv-name)=]=[=
         (if (~~ (get "type") "with|enable") "no" "yes") =])
  ) # end of AC_ARG_[=arg-name=][=

  emit-results =][=

ENDDEF  emit-enablement

=][=

# # # # # # # # # SET-LANGUAGE # # # # # # # # =][=

DEFINE  set-language

=]
  AC_CACHE_VAL([[=(. cv-name)=]],[[=
  CASE language  =][=
  ==   ""        =][=(define pop-language "")=][=
  ==   default   =][=(define pop-language "")=][=
  *              =]
  AC_LANG_PUSH([=language=])[=
    (define pop-language (sprintf "
  AC_LANG_POP(%s)" (get "language"))) =][=

  ESAC  =][=

  IF (exist? "cflags")

=]
    [=(. group-pfx)=]save_CPPFLAGS="${CPPFLAGS}"
    CPPFLAGS="[= cflags =] ${CPPFLAGS}"[=
    (set! pop-language (string-append pop-language
          "\n    CPPFLAGS=\"${" group-pfx "save_CPPFLAGS}\"" )) =][=

  ENDIF   cflags exists         =][=

  IF (exist? "libs")

=]
    [=(. group-pfx)=]save_LIBS="${LIBS}"
    LIBS="[= libs =] ${LIBS}"[=
    (set! pop-language (string-append pop-language
          "\n    LIBS=\"${" group-pfx "save_LIBS}\"" )) =][=

  ENDIF   libs exists           =][=

ENDDEF  set-language            =][=

# # # # # # # # # # WITH # # # # # # # # # =][=

DEFINE  try-with                =][=
  INVOKE emit-enablement
       arg-name  = WITH         =][=
ENDDEF  try-with                =][=

# # # # # # # # # # WITHOUT # # # # # # # =][=

DEFINE  try-without             =][=
  (set! cv-name (string-append group-pfx "cv_with_" down-name)) =][=
  INVOKE emit-enablement
       arg-name  = WITH         =][=
ENDDEF  try-without             =][=

# # # # # # # # # # ENABLE # # # # # # # # # =][=

DEFINE  try-enable              =][=
  INVOKE emit-enablement
       arg-name  = ENABLE       =][=
ENDDEF  try-enable              =][=

# # # # # # # # # # DISABLE # # # # # # # # # =][=

DEFINE  try-disable             =][=
  (set! cv-name (string-append group-pfx "cv_enable_" down-name)) =][=
  INVOKE emit-enablement
       arg-name  = ENABLE       =][=
ENDDEF  try-disable             =][=

# # # # # # # # # # WITHLIB # # # # # # # =][=

DEFINE  try-withlib             =][=

  # # # # # # # # options # # # # # # #

=]
  AC_ARG_WITH([[=
    (set! cv-name  (string-append group-pfx "cv_with_lib" down-name))
    (set! lib-name (string-append "lib" down-name))
    lib-name =]],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_" "-")
        =]], [[=(. lib-name)=] installation prefix]),
    [[=(. cv-name)=]_root=${with_lib[=(string-tr down-name "-" "_")=]}],
    AC_CACHE_CHECK([whether with-[=(. lib-name)=] was specified], [=
        (. cv-name)=]_root,
      [=(. cv-name)=]_root=no)
  ) # end of AC_ARG_WITH [=(. lib-name)=]

  if test "${with_libguile+set}" = set && \
     test "${withval}" = no
  then ## disabled by request
    [=(. cv-name)=]_root=no
    [=(. cv-name)=]_cflags=no
    [=(. cv-name)=]_libs=no
  else

  AC_ARG_WITH([[=(. lib-name)=]-cflags],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_A-Z" "-a-z")
        =]-cflags], [[=(. lib-name)=] compile flags]),
    [[=(. cv-name)=]_cflags=${with_[=(string-tr test-name "-A-Z" "_a-z")
                                   =]_cflags}],
    AC_CACHE_CHECK([whether with-[=(. lib-name)=]-cflags was specified], [=
        (. cv-name)=]_cflags,
      [=(. cv-name)=]_cflags=no)
  ) # end of AC_ARG_WITH [=(. lib-name)=]-cflags

  AC_ARG_WITH([[=(. lib-name)=]-libs],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_A-Z" "-a-z")
        =]-libs], [[=(. lib-name)=] link command arguments]),
    [[=(. cv-name)=]_libs=${with_[=(string-tr test-name "-A-Z" "_a-z")
                                   =]_libs}],
    AC_CACHE_CHECK([whether with-[=(. lib-name)=]-libs was specified], [=
        (. cv-name)=]_libs,
      [=(. cv-name)=]_libs=no)
  ) # end of AC_ARG_WITH [=(. lib-name)=]-libs
[=

  # # # # # # set cflags/libs # # # # # #

=]
  case "X${[=(. cv-name)=]_cflags}" in
  Xyes|Xno|X )
    case "X${[=(. cv-name)=]_root}" in
    Xyes|Xno|X ) [=(. cv-name)=]_cflags=no ;;
    * )        [=(. cv-name)=]_cflags=-I${[=(. cv-name)=]_root}/include ;;
    esac
  esac
  case "X${[=(. cv-name)=]_libs}" in
  Xyes|Xno|X )
    case "X${[=(. cv-name)=]_root}" in
    Xyes|Xno|X ) [=(. cv-name)=]_libs=no ;;
    * )        [=(. cv-name)=]_libs="-L${[=(. cv-name)
               =]_root}/lib -l[=(. down-name)=]";;
    esac
  esac
  [=(. group-pfx)=]save_CPPFLAGS="${CPPFLAGS}"
  [=(. group-pfx)=]save_LIBS="${LIBS}"[=
  (set! bad-text (sprintf
    "\n    CPPFLAGS=\"${%1$ssave_CPPFLAGS}\"
    LIBS=\"${%1$ssave_LIBS}\"" group-pfx )) =][=

  # # # # # # check config script # # # # # =][=

  IF (exist? "config")

=]
  case "X${[=

  (define tmp-text (if (exist? "config.script") (get "config.script")
                       (string-append down-name "-config")  ))

  cv-name =]_cflags}" in
  Xyes|Xno|X )
    f=`[=(. tmp-text)=] [= config.cflags-arg =] 2>/dev/null` || f=''
    test -n "${f}" && [=(. cv-name)=]_cflags="${f}" && \
      AC_MSG_NOTICE([[=(. tmp-text)=] used for CFLAGS: $f]) ;;
  esac
  case "X${[=(. cv-name)=]_libs}" in
  Xyes|Xno|X )
    f=`[=(. tmp-text)=] [= config.libs-arg =] 2>/dev/null` || f=''
    test -n "${f}" && [=(. cv-name)=]_libs="${f}" && \
      AC_MSG_NOTICE([[=(. tmp-text)=] used for LIBS: $f]) ;;
  esac[=

  ENDIF (exist? "config")

  =][= # # # # set cflags/libs # # # #

=]
  fi ## disabled by request

  case "X${[=(. cv-name)=]_cflags}" in
  Xyes|Xno|X )
    [=(. cv-name)=]_cflags="" ;;
  * ) CPPFLAGS="${CPPFLAGS} ${[=(. cv-name)=]_cflags}" ;;
  esac
  case "X${[=(. cv-name)=]_libs}" in
  Xyes|Xno|X )[=
    IF (not (exist? "libname")) =]
    LIBS="${LIBS} -l[=(. down-name)=]"
    [=(. cv-name)=]_libs="-l[=(. down-name)=]"[=

    ELIF (> (string-length (get "libname")) 0) =]
    LIBS="${LIBS} -l[=(get "libname")=]"
    [=(. cv-name)=]_libs="-l[=(get "libname")=]"[=
    ELSE   =]
    [=(. cv-name)=]_libs=""[=
    ENDIF  =] ;;
  * )
    LIBS="${LIBS} ${[=(. cv-name)=]_libs}" ;;
  esac[=

  # # # # # # # # testing # # # # # # #

  =]
  LIB[=(. up-name)=]_CFLAGS=""
  LIB[=(. up-name)=]_LIBS=""[=

  CASE run-mode                 =][=

  ==   link                     =]
  AC_MSG_CHECKING([whether [=(. lib-name)=] can be linked with])[=
  set-language                  =]
  AC_LINK_IFELSE([[[=(protect-text c-text)=]]],
    [[=(. cv-name)=]=yes],
    [[=(. cv-name)=]=no]) # end of AC_LINK_IFELSE [=

  ==   run                      =]
  AC_MSG_CHECKING([whether [=(. lib-name)=] functions properly])[=
  set-language                  =]
  AC_TRY_RUN([[=(protect-text c-text)=]],
    [[=(. cv-name)=]=yes], [[=(. cv-name)=]=no],
    [[=(. cv-name)=]=no]) # end of AC_TRY_RUN [=

  ESAC                          =][=

  end-feat-test                 =][=

ENDDEF  try-withlib             =][=

# # # # # # # # # # TEST # # # # # # # # # =][=

DEFINE  try-test                =][=

  start-feat-test               =]
  AC_CACHE_VAL([[=(. cv-name)=]],[
    [=(. cv-name)=]=[= (sub-shell-str
      (string-append "exec 2> /dev/null\n" (get "code")) ) =]
    if test $? -ne 0
    then [=(. cv-name)=]=no
    elif test -z "$[=(. cv-name)=]"
    then [=(. cv-name)=]=no
    fi
  ]) # end of CACHE_VAL of [=(. cv-name)=]
  AC_MSG_RESULT([${[=(. cv-name)=]}])[=
  emit-results                  =][=

ENDDEF  try-test                =][=

# # # # # # # # # # RUN # # # # # # # # # =][=

DEFINE  try-run                 =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_RUN([[=(protect-text c-text)=]],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no],[[=
        (. cv-name)=]=no]
  ) # end of TRY_RUN[=
  end-feat-test                 =][=

ENDDEF  try-run                 =][=

# # # # # # # # # # LINK # # # # # # # # # =][=

DEFINE  try-link                =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_LINK([[= (protect-text (shellf
    "egrep '^#' <<_EOF_\n%s\n_EOF_" c-text )) =]],
    [[= (protect-text (shellf
    "egrep -v '^#' <<_EOF_\n%s\n_EOF_" c-text )) =]],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no]
  ) # end of TRY_LINK[=
  end-feat-test                 =][=

ENDDEF  try-link                =][=

# # # # # # # # # # COMPILE # # # # # # # # # # =][=

DEFINE  try-compile             =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_COMPILE([= % includes "[%s]" =],[[=(protect-text c-text)=]],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no]
  ) # end of TRY_COMPILE[=
  end-feat-test                 =][=

ENDDEF  try-compile             =]
