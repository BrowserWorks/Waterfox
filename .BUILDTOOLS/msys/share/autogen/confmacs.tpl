[=

AutoGen5 Template

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
[=(prefix "dnl   " doc-text) =][=
    ENDIF =][=

    IF  (exist? "author") =]
dnl
dnl @version "[=

 (strftime "%d-%B-%Y at %H:%M"
           (localtime (current-time)) ) =]"
dnl
dnl @author [=author=][=

    ENDIF (exist? "author") =]
dnl[=

  ENDIF separate-macros

=]
AC_DEFUN([[=
  (define fcn-name (string-append "try-" (get "type")))
  (define c-text (get "code"))
  (if (> (string-length c-text) 0)
      (set! c-text (string-append "[" (protect-text c-text) "]"  )))

  mac-name  =]],[[=

  IF (ag-function? fcn-name) =][=
    INVOKE (. fcn-name) =][=

  ELSE   =]

ERROR:  invalid conftest function:   [= (. fcn-name) =][=

  ENDIF  =]
[=(prefix "  " (join "\n" (stack "always")))
=]]) # end of AC_DEFUN of [=(. mac-name)=]
[=

ENDDEF  emit-macro   =][=

# # # # # # # # # # # C-Feature # # # # # # # # # #

Stash the result of a C/C++ feature test =][=

DEFINE start-feat-test =]
  AC_MSG_CHECKING([whether [=(protect-text (get "check"))=]])[=
ENDDEF start-feat-test =][=

DEFINE  end-feat-test  =][=

  (. pop-language)     =]]) # end of AC_CACHE_VAL for [=(. cv-name)=]
  AC_MSG_RESULT([${[=(. cv-name)=]}])[=
  emit-results         =][=

ENDDEF  end-feat-test  =][=

# # # # # # # # # # EMIT RESULTS # # # # # # # # # # =][=

DEFINE  emit-results   =][=

  (define good-subst 0 )
  (define bad-subst  0 )
  (define tmp-text   "") =][=

  FOR     action         =][=

    CASE (set! tmp-text (get "act-text"))
	     (string-append
           (if (exist? "no") "no-" "yes-")
           (get "act-type"))
      =][=

    == yes-define        =][=
      (set! good-text (string-append good-text
            "\n    AC_DEFINE([" (sprintf good-define-name up-name) "],["
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

    == yes-libflags      =][=
      (set! tmp-text (string-upcase! tmp-text))
      (set! good-text (string-append good-text
            "\n    CPPFLAGS=\"${ag_save_CPPFLAGS}\"\n"
            "    LDFLAGS=\"${ag_save_LDFLAGS}\"\n"
            "    AC_SUBST(" tmp-text "_CPPFLAGS)\n"
            "    AC_SUBST(" tmp-text "_LDFLAGS)\n"

            "    case \"X${" cv-name "_incdir}\" in Xyes|Xno|X )\n"
            "      case \"X${" cv-name "_root}\" in Xyes|Xno|X )\n"
            "        " tmp-text "_CPPFLAGS=\"\" ;;\n"
            "        * ) " tmp-text "_CPPFLAGS=\"-I${"
                   cv-name "_root}/include\" ;; esac ;;\n"
            "      * ) " tmp-text "_CPPFLAGS=\"-I${"
                   cv-name "_incdir}\" ;; esac\n"

            "\n    case \"X${" cv-name "_libdir}\" in Xyes|Xno|X )\n"
            "      case \"X${" cv-name "_root}\" in Xyes|Xno|X )\n"
            "        " tmp-text "_LDFLAGS=\"-l"
                   down-name "\" ;;\n"
            "        * ) " tmp-text "_LDFLAGS=\"-L${"
                   cv-name "_root}/lib -l" down-name "\" ;; esac ;;\n"
            "      * ) " tmp-text "_LDFLAGS=\"${"
                   cv-name "_libdir}\" ;; esac\n"   ))
      =][=

    ==  no-define        =][=
      (set! bad-text (string-append bad-text
            "\n    AC_DEFINE([" (sprintf bad-define-name up-name) "],["
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
  fi[= (if (> (+ good-subst bad-subst) 0)
           (string-append "\n  AC_SUBST([" sub-name "])" ))

  =][=
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

ENDDEF  set-language            =][=

# # # # # # # # # # WITH # # # # # # # # # =][=

DEFINE  try-with                =][=
  emit-enablement
       arg-name  = WITH         =][=
ENDDEF  try-with                =][=

# # # # # # # # # # WITHOUT # # # # # # # =][=

DEFINE  try-without             =][=
  (set! cv-name (string-append group-pfx "cv_with_" down-name)) =][=
  emit-enablement
       arg-name  = WITH         =][=
ENDDEF  try-without             =][=

# # # # # # # # # # WITHLIB # # # # # # # =][=

DEFINE  try-withlib             =]
  AC_ARG_WITH([lib[=
    (set! cv-name (string-append group-pfx "cv_with_" down-name))
    down-name =]],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_" "-")
        =]], [lib[=(. down-name)=] installation prefix]),
    [[=(. cv-name)=]_root=${with_lib[=(string-tr down-name "-" "_")=]}],
    AC_CACHE_CHECK([whether with-lib[=(. down-name)=] was specified], [=
        (. cv-name)=]_root,
      [=(. cv-name)=]_root=no)
  ) # end of AC_ARG_WITH lib[=(. down-name)=]

  AC_ARG_WITH([lib[=(. down-name)=]-incdir],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_A-Z" "-a-z")
        =]-incdir], [lib[=(. down-name)=] include dir]),
    [[=(. cv-name)=]_incdir=${with_[=(string-tr test-name "-A-Z" "_a-z")
                                   =]_incdir}],
    AC_CACHE_CHECK([whether with-lib[=(. down-name)=]-incdir was specified], [=
        (. cv-name)=]_incdir,
      [=(. cv-name)=]_incdir=no)
  ) # end of AC_ARG_WITH lib[=(. down-name)=]-incdir

  AC_ARG_WITH([lib[=(. down-name)=]-libdir],
    AC_HELP_STRING([--with-lib[=(string-tr down-name "_A-Z" "-a-z")
        =]-libdir], [lib[=(. down-name)=] library dir]),
    [[=(. cv-name)=]_libdir=${with_[=(string-tr test-name "-A-Z" "_a-z")
                                   =]_libdir}],
    AC_CACHE_CHECK([whether with-lib[=(. down-name)=]-libdir was specified], [=
        (. cv-name)=]_libdir,
      [=(. cv-name)=]_libdir=no)
  ) # end of AC_ARG_WITH lib[=(. down-name)=]-libdir

  case "X${[=(. cv-name)=]_incdir}" in
  Xyes|Xno|X )
    case "X${[=(. cv-name)=]_root}" in
    Xyes|Xno|X ) [=(. cv-name)=]_incdir=no ;;
    * )        [=(. cv-name)=]_incdir=-I${[=(. cv-name)=]_root}/include ;;
    esac
  esac

  case "X${[=(. cv-name)=]_libdir}" in
  Xyes|Xno|X )
    case "X${[=(. cv-name)=]_root}" in
    Xyes|Xno|X ) [=(. cv-name)=]_libdir=no ;;
    * )        [=(. cv-name)=]_libdir="-L${[=(. cv-name)
               =]_root}/lib -l[=(. down-name)=]";;
    esac
  esac
  [=(. group-pfx)=]save_CPPFLAGS="${CPPFLAGS}"
  [=(. group-pfx)=]save_LDFLAGS="${LDFLAGS}"[=
  (set! bad-text (sprintf
    "\n    CPPFLAGS=\"${%1$ssave_CPPFLAGS}\"
    LDFLAGS=\"${%1$ssave_LDFLAGS}\"" group-pfx )) =]

  case "X${[=(. cv-name)=]_incdir}" in
  Xyes|Xno|X ) : ;;
  * ) CPPFLAGS="${CPPFLAGS} ${[=(. cv-name)=]_incdir}" ;;
  esac

  case "X${[=(. cv-name)=]_libdir}" in
  Xyes|Xno|X )[=
    IF (exist? "libname")      =][=
      IF (> (string-length (get "libname")) 0) =]
    LDFLAGS="${LDFLAGS} -l[=libname=]"[=
      ENDIF length of libname =][=
    ELSE  not exist libname   =]
    LDFLAGS="${LDFLAGS} -l[=(. down-name)=]"[=
    ENDIF  =] ;;
  * )
    LDFLAGS="${LDFLAGS} ${[=(. cv-name)=]_libdir}" ;;
  esac[=

  CASE run-mode                 =][=

  ==   link                     =]
  AC_MSG_CHECKING([whether lib[=(. down-name)=] can be linked with])[=
  set-language                  =]
  AC_LINK_IFELSE([[=(. c-text)=]],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no
    CPPFLAGS="${[=(. group-pfx)=]save_CPPFLAGS}"
    LDFLAGS="${[=(. group-pfx)=]save_LDFLAGS}"]
  ) # end of AC_LINK_IFELSE [=

  ==   run                      =]
  AC_MSG_CHECKING([whether lib[=(. down-name)=] functions properly])[=
  set-language                  =]
  AC_TRY_RUN([=(. c-text)=],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no],[[=
        (. cv-name)=]=no]
  ) # end of AC_TRY_RUN [=

  ESAC                          =][=

  end-feat-test                 =][=

ENDDEF  try-withlib             =][=

# # # # # # # # # # ENABLE # # # # # # # # # =][=

DEFINE  try-enable              =][=
  emit-enablement
       arg-name  = ENABLE       =][=
ENDDEF  try-enable              =][=

# # # # # # # # # # DISABLE # # # # # # # # # =][=

DEFINE  try-disable             =][=
  (set! cv-name (string-append group-pfx "cv_enable_" down-name)) =][=
  emit-enablement
       arg-name  = ENABLE       =][=
ENDDEF  try-disable             =][=

# # # # # # # # # # TEST # # # # # # # # # =][=

DEFINE  try-test                =][=

  start-feat-test               =]
  AC_CACHE_VAL([[=(. cv-name)=]],[
    [=(. cv-name)=]=[= (sub-shell-str
      (string-append "exec 2> /dev/null ; " (get "code")) ) =]
    if [ $? -ne 0 ]
    then [=(. cv-name)=]=no
    elif [ -z "$[=(. cv-name)=]" ]
    then [=(. cv-name)=]=no
    fi
  ]) # end of CACHE_VAL of [=(. cv-name)=]
  AC_MSG_RESULT([${[=(. cv-name)=]}])[=
  emit-results         =][=

ENDDEF  try-disable             =][=

# # # # # # # # # # RUN # # # # # # # # # =][=

DEFINE  try-run                 =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_RUN([=(. c-text)=],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no],[[=
        (. cv-name)=]=no]
  ) # end of TRY_RUN[=
  end-feat-test                 =][=

ENDDEF  try-run                 =][=

# # # # # # # # # # LINK # # # # # # # # # =][=

DEFINE  try-link                =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_LINK([=(. c-text)=],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no]
  ) # end of TRY_LINK[=
  end-feat-test                 =][=

ENDDEF  try-link                =][=

# # # # # # # # # # COMPILE # # # # # # # # # # =][=

DEFINE  try-compile             =][=

  start-feat-test               =][=
  set-language                  =]
  AC_TRY_COMPILE([= % includes "[%s]" =],[=(. c-text)=],
    [[=(. cv-name)=]=yes],[[=(. cv-name)=]=no]
  ) # end of TRY_COMPILE[=
  end-feat-test                 =][=

ENDDEF  try-compile             =]
