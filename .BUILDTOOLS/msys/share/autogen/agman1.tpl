[+:   -*- nroff -*-

## agman1.tpl -- Template for command line man pages
##
##  AutoOpts copyright 1992-2002 Bruce Korb
##
## Time-stamp:      "2002-08-18 19:45:16 bkorb"
## Author:          Jim Van Zandt <jrv@vanzandt.mv.com>
## Maintainer:      Bruce Korb <bkorb@gnu.org>
## Created:         Mon Jun 28 15:35:12 1999
##              by: bkorb
## ---------------------------------------------------------------------
## $Id: agman1.tpl,v 2.34 2002/08/21 01:56:37 bkorb Exp $
## ---------------------------------------------------------------------

AutoGen5 template man=%s.1

(setenv "SHELL" "/bin/sh")

:+]
.TH [+: % prog_name (string-upcase! "%s") :+] 1 [+:
  `date +%Y-%m-%d` :+] "" "Programmer's Manual"
[+:

;; The following "dne" argument is a string of 5 characters:
;; '.' '\\' '"' and two spaces.  It _is_ hard to read.
;;
(dne ".\\\"  ")

:+]
.\"
.SH NAME
[+: % prog_name (string-downcase! "%s") :+] \- [+:prog_title:+]
.SH SYNOPSIS
.B [+: (string-downcase! (get "prog_name"))
:+][+:
    ;; * * * * * * * * * * * * * * * * * * * * * * * * *
    ;;
    ;;  Display the command line prototype,
    ;;  based only on the argument processing type.
    ;;
    ;;  And run the entire output through "sed" to convert texi-isms
    ;;
    (out-push-new)

:+]
sed \
 -e 's;@code{\([^}]*\)};\\fB\1\\fP;g' \
 -e  's;@var{\([^}]*\)};\\fB\1\\fP;g' \
 -e 's;@samp{\([^}]*\)};\\fB\1\\fP;g' \
 -e 's;@file{\([^}]*\)};\\fI\1\\fP;g' \
 -e 's/@\([{}]\)/\1/g' \
 -e 's,^\$\*$,.br,' \
 -e '/@ *example/,/@ *end *example/s/^/    /' \
 -e 's/^ *@ *example/.nf/' \
 -e 's/^ *@ *end *example/.fi/' \
 -e '/^ *@ *noindent/d' \
 -e '/^ *@ *enumerate/d' \
 -e 's/^ *@ *end *enumerate/.br/' \
 -e '/^ *@ *table/d' \
 -e 's/^ *@ *end *table/.br/' \
 -e 's/^@item/.sp 1/' \
 -e 's/\*\([a-zA-Z0-9:~=_ -]*\)\*/\\fB\1\\fP/g' \
 -e 's/``\([a-zA-Z0-9:~=_ -]*\)'"''"'/\\fI\1\\fP/g' \
 -e 's/^@\*/.br/' <<'_End_Of_Man_'
[+:
  IF (define named-mode (not (or (exist? "flag.value")
                                 (exist? "long_opts") )))
     (exist? "flag.value")  :+][+:

    IF (exist? "long_opts") :+][+:

      # * * * * *
      #
      :+]
.\" Mixture of short (flag) options and long options
.RB [ -\fIflag\fP " [\fIvalue\fP]]... [" --\fIopt-name\fP " [[=| ]\fIvalue\fP]]..."[+:

    ELSE no long options:+][+:

      # * * * * *
      #
      :+]
.\" Short (flag) options only
.RB [ -\fIflag\fP " [\fIvalue\fP]]..."[+:
    ENDIF :+][+:

  ELIF (exist? "long_opts") :+][+:

      # * * * * *
      #
      :+]
.\" Long options only
.RB [ --\fIopt-name\fP [ = "| ] \fIvalue\fP]]..."[+:

  ELIF  (not (exist? "argument")) :+][+:

      # * * * * *
      #
      :+]
.\" All arguments are named options.
.RI [ opt-name "[\fB=\fP" value ]]...
.PP
All arguments are named options.[+:

  ELSE :+][+:
    (error "Named option programs cannot have arguments") :+][+:
  ENDIF :+][+:

  IF (exist? "argument") :+]
.br
.in +8
[+:argument:+][+:
  ELIF (or (exist? "long_opts") (exist? "flag.value")) :+]
.PP
All arguments must be options.[+:
  ENDIF :+][+:

      # * * * * * * * * * * * * * * * * * * * * * * * * *
      #
      #  Describe the command.  Use 'prog_man_desrip' if it exists,
      #  otherwise use the 'detail' help option.  If not that,
      #  then the thing is undocumented.
      #
      :+][+:
IF (exist? "explain") :+]
.PP
[+:explain:+][+:
ENDIF :+]
.SH "DESCRIPTION"
This manual page documents, briefly, the \fB[+:
    (string-downcase! (get "prog_name")) :+]\fP command.
[+:

IF (exist? "prog_man_descrip")   :+][+:
  FOR prog_man_descrip "\n.PP\n" :+][+:
    prog_man_descrip             :+][+:
  ENDFOR                         :+][+:
ELIF (exist? "detail")           :+][+:
  FOR detail  "\n.PP\n"          :+][+:
    detail                       :+][+:
  ENDFOR                         :+][+:
ELSE
  :+]Its description is not documented.[+:
ENDIF :+]
.SH OPTIONS[+:

;; * * * * * * * * * * * * * * * * * * * * * * * * *
;;
;; Describe each option
;;
(define opt-arg  "")
(define dis-name "")
(define opt-name "")
(if (exist? "preserve-case")
    (begin
      (define optname-from "_^")
      (define optname-to   "--") )
    (begin
      (define optname-from "A-Z_^")
      (define optname-to   "a-z--") )
) :+][+:

FOR flag

:+][+:
  ;;  Skip the documentation options!
  ;;
  (if (exist? "enable")
      (set! opt-name (string-append (get "enable") "-" (get "name")))
      (set! opt-name (get "name")) )
  (if (exist? "disable")
      (set! dis-name (string-append (get "disable") "-" (get "name")))
      (set! dis-name "") )

  (set! opt-name (string-tr! opt-name optname-from optname-to))
  (set! dis-name (string-tr! dis-name optname-from optname-to))

  (if (not (exist? "arg_type"))
      (set! opt-arg "")
      (set! opt-arg (string-append "\\fI"
            (if (exist? "arg_name") (get "arg_name")
                (string-downcase! (get "arg_type")))
            "\\fP" ))
  )
  :+][+:
  IF (not (exist? "documentation")) :+]
.TP[+:
    IF (exist? "value") :+][+:
      IF (exist? "long_opts") :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option has a flag value (character) AND
          *  the program uses long options
          *
          :+]
.BR -[+:value:+][+:
          IF (not (exist? "arg_type")) :+] ", " --[+:
          ELSE  :+] " [+:(. opt-arg):+], " --[+:
          ENDIF :+][+: (. opt-name)    :+][+:
          IF (exist? "arg_type")       :+][+:
              ? arg_optional " [ =" ' "=" '
              :+][+:  (. opt-arg)      :+][+:
              arg_optional " ]"        :+][+:
          ENDIF :+][+:
          IF (exist? "disable") :+], " \fB--[+:(. dis-name):+]\fP"[+:
          ENDIF :+][+:

        ELSE   :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option has a flag value (character) BUT
          *  the program does _NOT_ use long options
          *
          :+]
.BR -[+:value:+][+:
          IF (exist? "arg_type") :+][+:
            arg_optional "["     :+] "[+:(. opt-arg):+][+:
            arg_optional '"]"'   :+][+:
          ENDIF:+][+:
        ENDIF  :+][+:


      ELSE  value does not exist -- named option only  :+][+:

        IF (not (exist? "long_opts")) :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option does not have a flag value (character).
          *  The program does _NOT_ use long options either.
          *  Special magic:  All arguments are named options.
          *
          :+]
.BR [+: (. opt-name) :+][+:
          IF (exist? "arg_type") :+] [+:
             ? arg_optional " [ =" ' "=" '
             :+][+:(. opt-arg):+][+:
             arg_optional "]" :+][+:
          ENDIF:+][+:
          IF (exist? "disable") :+], " \fB[+:(. dis-name):+]\fP"[+:
          ENDIF :+][+:


        ELSE   :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option does not have a flag value (character).
          *  The program, instead, only accepts long options.
          *
          :+]
.BR --[+: (. opt-name) :+][+:
          IF (exist? "arg_type") :+] "[+:
            arg_optional "["     :+]=[+:(. opt-arg):+][+:
            arg_optional "]"     :+]"[+:
          ENDIF:+][+:
          IF (exist? "disable") :+], " \fB--[+:(. dis-name):+]\fP"[+:
          ENDIF :+][+:
        ENDIF  :+][+:
      ENDIF :+]
[+:descrip:+].[+:
      IF (exist? "min") :+]
This option is required to appear.[+:ENDIF:+][+:
      IF (exist? "max") :+]
This option may appear [+:
          IF % max (= "%s" "NOLIMIT")
          :+]an unlimited number of times[+:ELSE
          :+]up to [+:max:+] times[+:
          ENDIF:+].[+:
      ENDIF:+][+:
      IF (exist? "disable") :+]
The \fI[+:(. dis-name):+]\fP form will [+:
         IF (exist? "stack-arg") :+]clear the list of option arguments[+:
         ELSE  :+]disable the option[+:
         ENDIF :+].[+:
      ENDIF:+][+:
      IF (exist? "enabled") :+]
This option is enabled by default.[+:ENDIF:+][+:
      IF (exist? "no_preset") :+]
This option may not be preset with environment variables
or in initialization (rc) files.[+:ENDIF:+][+:
      IF (exist? "arg-default") :+]
The default [+:(. opt-arg):+] for this opton is \fI[+: arg-default :+]\fP.[+:
      ENDIF:+][+:
      IF (and (exist? "default") named-mode) :+]
This option is the default option.[+:
      ENDIF:+][+:
      IF (exist? "equivalence") :+]
This option is a member of the [+:equivalence:+] class of options.[+:ENDIF:+][+:
      IF (exist? "flags_must") :+]
This opton must appear in combination with the following options:
[+: FOR flags_must ", " :+][+:flags_must:+][+:ENDFOR:+].[+:ENDIF:+][+:
      IF (exist? "flags_cant") :+]
This option must not appear in combination with any of the following options:
[+: FOR flags_cant ", " :+][+:flags_cant:+][+:ENDFOR:+].[+:
      ENDIF:+]
.sp
[+: doc :+][+:

  ENDIF (not (exist? "documentation")) :+][+:

ENDFOR flag


:+]
.TP
.BR [+:IF (exist? "flag.value") :+]\-[+: ?% help-value "%s" "?" :+] , " --[+:
      ELIF (exist? "long_opt") :+]--[+:
      ENDIF:+]help
Display usage information and exit.
.TP
.BR [+:IF (exist? "flag.value") :+]-[+: ?% more-help-value "%s" "!" :+] , " --[+:
      ELIF (exist? "long_opt") :+]--[+:
      ENDIF:+]more-help
Extended usage information passed thru pager.[+:


IF (exist? "homerc") :+]
.TP
.BR [+: IF (exist? "flag.value") :+]-[+: ?% save-opts-value "%s" ">" :+] " \fIrcfile\fP, --" [+:
      ELIF (exist? "long_opt") :+]--[+:
      ENDIF:+]save-opts "[=\fIrcfile\fP]
Save the option state to \fIrcfile\fP.  The default is the \fIlast\fP
rc file listed in the \fBOPTION PRESETS\fP section, below.
.TP
.BR [+: IF (exist? "flag.value") :+]-[+: ?% load-opts-value "%s" "<" :+] " \fIrcfile\fP, --" [+:
      ELIF (exist? "long_opt") :+]--[+:
      ENDIF:+]load-opts "=\fIrcfile\fP", " \fB--no-load-opts\fP"
Load options from \fIrcfile\fP.
The \fIno-load-opts\fP form will disable the loading
of earlier RC/INI files.  \fI--no-load-opts\fP is handled early,
out of order.[+:
ENDIF (exist? "homerc") :+][+:


IF (exist? "version") :+]
.TP
.BR [+:  IF (exist? "flag.value") :+]\-v " \fI[v|c|n]\fP, " --[+:
      ELIF (exist? "long_opt") :+]--[+:ENDIF:+]version "\fI[=v|c|n]\fP"
Output version of program and exit.  The default mode is `v', a simple
version.  The `c' mode will print copyright information and `n' will
print the full copyright notice.[+:
ENDIF


:+][+:
IF (or (exist? "homerc") (exist? "environrc")) :+]
.SH OPTION PRESETS
Any option that is not marked as ``not presettable'' may be preset
by loading values from [+:
  IF (exist? "homerc")
    :+]RC (.ini) file(s)[+:
    IF (exist? "environrc")
            :+] and values from
[+:
    ENDIF   :+][+:
  ENDIF     :+][+:
  IF (exist? "environrc") :+]environment variables named:
.nf
  \fB[+:(string-tr! (get "prog-name") "a-z^-" "A-Z__") :+]_<option-name>\fP
.fi
.aj[+:
    IF (exist? "homerc") :+]
The environmental presets take precedence (are processed later than)
the RC files.[+:
    ENDIF   :+][+:
  ELSE      :+].[+:
  ENDIF     :+][+:

  CASE (count "homerc") :+][+:
  == "0"    :+][+:
  == "1"    :+]
The \fIhomerc\fP file is "\fI[+:homerc:+]\fP", unless that is a directory.
In that case, the file "\fI[+: ?% rcfile "%s"
(string-append "." (string-tr (get "prog-name") "A-Z^-" "a-z__") "rc") :+]\fP"
is searched for within that directory.[+:

  *         :+]
The \fIhomerc\fP files are [+:
    FOR homerc ", "  :+][+:
      IF (last-for?) :+]and [+:
      ENDIF :+]"\fI[+: homerc :+]\fP"[+: ENDFOR :+].
If any of these are directories, then the file \fI[+: ?% rcfile "%s"
(string-append "." (string-tr (get "prog-name") "A-Z^-" "a-z__") "rc") :+]\fP
is searched for within those directories.[+:
  ESAC      :+][+:


ENDIF       :+][+:
IF (exist? "man_doc") :+]
[+:man_doc:+][+:
ENDIF:+][+:

IF (or (exist? "copyright.author") (exist? "copyright.owner")) :+]
.SH AUTHOR
[+: ?% copyright.author '%s' (get "copyright.owner")
  :+][+:

  (define bug-text "\n.br\nPlease send bug reports to:  %s\n")

  (if (exist? "copyright.eaddr")
      (sprintf bug-text (get "copyright.eaddr"))
  (if (exist? "eaddr")
      (sprintf bug-text (get "eaddr"))
  ))       :+][+:

  CASE copyright.type :+][+:
   =  gpl  :+]
.PP
Released under the GNU General Public License.[+:
   = lgpl  :+]
.PP
Released under the GNU General Public License with Library Extensions.[+:
   =  bsd  :+]
.PP
Released under the Free BSD License.[+:
   *       :+][+:
     IF (exist? "copyright.text")
           :+]
.PP
.nf
.na
[+: copyright.text :+]
.fi
.ad[+:
     ELIF (exist? "copyright.date") :+]
.PP
Released under an unspecified copyright license.[+:
     ENDIF :+][+:
  ESAC     :+][+:
ENDIF      :+]
_End_Of_Man_[+:

(shell (out-pop #t) ) :+]
.PP
This manual page was \fIAutoGen\fP-erated from the \fB[+:prog_name:+]\fP
option definitions.[+: #

agman.tpl ends here  :+]
