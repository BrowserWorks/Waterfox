[+:   -*- Mode: nroff -*-

## agman1.tpl -- Template for command line man pages
##
## Time-stamp:      "2010-02-24 08:41:28 bkorb"
## Author:          Jim Van Zandt <jrv@vanzandt.mv.com>
##              by: bkorb
##
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
##
## ---------------------------------------------------------------------
## $Id$
## ---------------------------------------------------------------------

AutoGen5 template man=%s.1

(setenv "SHELL" "/bin/sh")

:+]
.TH [+: % prog-name (string-upcase! "%s") :+] 1 [+:
  `date +%Y-%m-%d` :+] "[+:
  IF (or (exist? "package") (exist? "version"))
    :+]([+: package :+] [+: version :+])[+:
  ENDIF :+]" "Programmer's Manual"
[+:

;; The following "dne" argument is a string of 5 characters:
;; '.' '\\' '"' and two spaces.  It _is_ hard to read.
;;
(dne ".\\\"  ") :+][+:  # balance quotes for emacs: "

:+]
.\"
.SH NAME
[+: (define prog-name (string-downcase! (get "prog-name")))
    (define PROG_NAME (string-tr! (get "prog-name") "a-z^-" "A-Z__"))
    (define prog_name (string-tr! (get "prog-name") "A-Z^-" "a-z__"))
    prog-name :+] \- [+: prog-title :+]
.SH SYNOPSIS
.B [+:
  (define use-flags (if (exist? "flag.value") #t #f))
  prog-name

:+][+:

  INCLUDE "agman-lib.tpl"

:+][+:

  IF (define named-mode (not (or use-flags (exist? "long_opts") )))
     use-flags  :+][+:

    IF (exist? "long_opts") :+][+:

      # * * * * *
      #
      :+]
.\" Mixture of short (flag) options and long options
.RB [ -\fIflag\fP " [\fIvalue\fP]]... [" --\fIopt-name\fP [+:#
:+]" [[=| ]\fIvalue\fP]]..."[+:

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
[+: argument :+][+:

    IF (exist? "reorder-args") :+]
.br
Operands and options may be intermixed.  They will be reordered.
[+: ENDIF :+][+:

  ELIF (or (exist? "long_opts") use-flags) :+]
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
This manual page briefly documents the \fB[+:
    (. prog-name) :+]\fP command.
[+:

IF (exist? "prog-man-descrip")   :+][+:
  FOR prog-man-descrip "\n.PP\n" :+][+:
    prog-man-descrip             :+][+:
  ENDFOR                         :+][+:
ELIF (exist? "detail")           :+][+:
  FOR detail  "\n.PP\n"          :+][+:
    (string-substitute (get "detail") "\\" "\\\\") :+][+:
  ENDFOR                         :+][+:
ELSE
  :+]Its description is not documented.[+:
ENDIF :+][+:

IF (exist? "main")   :+][+:

  IF (= (get "main.main-type") "for-each")  :+]
[+:
    CASE main.handler-type  :+][+:
    ~* ^(name|file)|.*text  :+]
This program will perform its function for every file named on the command
line or every file named in a list read from stdin.  The arguments or input
names must be pre-existing files.  The input list may contain comments,
which[+:

    !E        :+]
This program will perform its function for every command line argument
or every non-comment line in a list read from stdin.  The input list comments[+:

    ESAC      :+]
are blank lines or lines beginning with a '[+:
 ?% comment-char "%s" "#" :+]' character.[+:

  ENDIF       :+][+:

ENDIF - "main" exists

:+]
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
)
(if (exist? "option-info")
    (string-append "\n.PP\n" (get "option-info") "\n") ) :+][+:

FOR flag

:+][+:

  IF

  (if (exist? "enable")
      (set! opt-name (string-append (get "enable") "-" (get "name")))
      (set! opt-name (get "name")) )
  (if (exist? "disable")
      (set! dis-name (string-append (get "disable") "-" (get "name")))
      (set! dis-name "") )

  (set! opt-name (string-tr! opt-name optname-from optname-to))
  (set! dis-name (string-tr! dis-name optname-from optname-to))

  (if (not (exist? "arg-type"))
      (set! opt-arg "")
      (set! opt-arg (string-append "\\fI"
            (if (exist? "arg-name") (get "arg-name")
                (string-downcase! (get "arg-type")))
            "\\fP" ))
  )

  (exist? "documentation")

:+]
.SS "[+: descrip :+]"[+:

  ELSE *NOT* documentation

:+]
.TP[+:
    IF (exist? "value") :+][+:
      IF (exist? "long-opts") :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option has a flag value (character) AND
          *  the program uses long options
          *
          :+]
.BR -[+:value:+][+:
          IF (not (exist? "arg-type")) :+] ", " --[+:
          ELSE  :+] " [+:(. opt-arg):+], " --[+:
          ENDIF :+][+: (. opt-name)    :+][+:
          IF (exist? "arg-type")       :+][+:
              ? arg-optional " [ =" ' "=" '
              :+][+:  (. opt-arg)      :+][+:
              arg-optional " ]"        :+][+:
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
          IF (exist? "arg-type") :+][+:
            arg-optional "["     :+] "[+:(. opt-arg):+][+:
            arg-optional '"]"'   :+][+:
          ENDIF " :+][+:
        ENDIF     :+][+:


      ELSE  value does not exist -- named option only  :+][+:

        IF (not (exist? "long-opts")) :+][+:

          # * * * * * * * * * * * * * * * * * * * *
          *
          *  The option does not have a flag value (character).
          *  The program does _NOT_ use long options either.
          *  Special magic:  All arguments are named options.
          *
          :+]
.BR [+: (. opt-name) :+][+:
          IF (exist? "arg-type") :+] [+:
             ? arg-optional " [ =" ' "=" '
             :+][+:(. opt-arg):+][+:
             arg-optional "]" :+][+:
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
          IF (exist? "arg-type") :+] "[+: #" :+][+:
            arg-optional "["     :+]=[+:(. opt-arg):+][+:
            arg-optional "]"     :+]"[+: #" :+][+:
          ENDIF :+][+:
          IF (exist? "disable") :+], " \fB--[+:(. dis-name):+]\fP"[+:
          ENDIF :+][+:
        ENDIF   :+][+:
      ENDIF     :+]
[+: (string-substitute (get "descrip") "\\" "\\\\") :+].[+:
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
      IF (exist? "no-preset") :+]
This option may not be preset with environment variables
or in initialization (rc) files.[+:ENDIF:+][+:
      IF (and (exist? "default") named-mode) :+]
This option is the default option.[+:
      ENDIF:+][+:
      IF (exist? "equivalence") :+]
This option is a member of the [+:equivalence:+] class of options.[+:ENDIF:+][+:
      IF (exist? "flags-must") :+]
This option must appear in combination with the following options:
[+: FOR flags-must ", " :+][+:flags-must:+][+:ENDFOR:+].[+:ENDIF:+][+:
      IF (exist? "flags-cant") :+]
This option must not appear in combination with any of the following options:
[+: FOR flags-cant ", " :+][+:flags-cant:+][+:ENDFOR:+].[+:
      ENDIF     :+][+:


      IF (~* (get "arg-type") "key|set") :+]
This option takes a keyword as its argument[+:

         IF (=* (get "arg-type") "set")

:+] list.  Each entry turns on or off
membership bits.  The bits are set by name or numeric value and cleared
by preceding the name or number with an exclamation character ('!').
They can all be cleared with the magic name \fInone\fR and they can all be set
with
.IR all .
A single option will process a list of these values.[+:

         ELSE

:+].  The argument sets an enumeration value that can
be tested by comparing them against the option value macro.[+:

         ENDIF

:+]
The available keywords are:
.in +4
.nf
.na
[+: (shellf "${CLexe:-columns} --spread=1 -W50 <<_EOF_\n%s\n_EOF_"
            (join "\n" (stack "keyword"))  )   :+]
.fi
or their numeric equivalent.
.in -4[+: (if (exist? "arg-default") "\n.sp" ) :+][+:

      ELIF (=* (get "arg-type") "num")         :+]
This option takes an integer number as its argument.[+:

        IF  (exist? "arg-range")  :+]
The value of [+:(. opt-arg):+] is constrained to being:
.in +4
.nf
.na[+:     FOR arg_range ", or"   :+]
[+: (shellf "
range='%s'

case \"X${range}\" in
X'->'?*  )
  echo \"less than or equal to\" `
    echo $range | sed 's/->//' ` ;;

X?*'->'  )
  echo \"greater than or equal to\" `
    echo $range | sed 's/->.*//' ` ;;

X?*'->'?* )
  echo \"in the range \" `
    echo $range | sed 's/->/ through /' ` ;;

X?* )
  echo exactly $range ;;

X* ) echo $range is indeterminate
esac"

(get "arg-range") )
:+][+:
           ENDFOR arg-range :+]
.fi
.in -4[+:

        ENDIF   :+][+:

      ENDIF     :+][+:

      IF (exist? "arg-default") :+]
The default [+: (. opt-arg) :+] for this option is:
.ti +4
 [+: (join " + " (stack "arg-default" )) :+][+:
      ENDIF     :+]
.sp
[+:
 (if (exist? "doc")
        (string-substitute (get "doc")
          '("\\"   "@{" "@}")
          '("\\\\" "{"  "}"))
        "This option has not been fully documented." ) :+][+:
      IF (exist? "deprecated") :+]
.sp
.B
NOTE: THIS OPTION IS DEPRECATED
.R[+:
      ENDIF     :+][+:

  ENDIF (not (exist? "documentation")) :+][+:

ENDFOR flag


:+]
.TP
.BR [+:

  IF (. use-flags)  :+]\-[+: ?% help-value "%s" "?" :+][+:
     IF (exist? "long-opts") :+] , " \--help"[+: ENDIF :+][+:
  ELSE   :+][+:
     IF (exist? "long-opts") :+]\--[+: ENDIF :+]help[+:
  ENDIF  :+]
Display extended usage information and exit.[+:

  IF (not (exist? "no-libopts")) :+]
.TP
.BR [+:

  IF (. use-flags)  :+]\-[+: ?% more-help-value "%s" "!" :+][+:
     IF (exist? "long-opts") :+] , " \--more-help"[+: ENDIF :+][+:
  ELSE   :+][+:
     IF (exist? "long-opts") :+]\--[+: ENDIF :+]more-help[+:
  ENDIF  :+]
Extended usage information passed thru pager.[+:

ENDIF no no-libopts :+][+:

IF (exist? "homerc") :+]
.TP
.BR [+:

  IF (. use-flags)  :+]\-[+: ?% save-opts-value "%s" ">"
     :+] " [\fIrcfile\fP][+:
     IF (exist? "long-opts") :+]," " \--save-opts" "[=\fIrcfile\fP][+:
     ENDIF :+]"[+:
  ELSE     :+][+:
     IF (exist? "long-opts") :+]\--[+:
     ENDIF :+]save-opts "[=\fIrcfile\fP]"[+:
  ENDIF    :+]
Save the option state to \fIrcfile\fP.  The default is the \fIlast\fP
configuration file listed in the \fBOPTION PRESETS\fP section, below.
.TP
.BR [+:

  IF (. use-flags)  :+]\-[+: ?% load-opts-value "%s" "<"
     :+] " \fIrcfile\fP[+:
     IF (exist? "long-opts")
           :+]," " \--load-opts" "=\fIrcfile\fP," " --no-load-opts[+:
     ENDIF :+]"[+:
  ELSE     :+][+:
     IF (exist? "long-opts") :+]\--[+:
     ENDIF :+]load-opts "=\fIrcfile\fP," " --no-load-opts"[+:
  ENDIF    :+]
Load options from \fIrcfile\fP.
The \fIno-load-opts\fP form will disable the loading
of earlier RC/INI files.  \fI--no-load-opts\fP is handled early,
out of order.[+:
ENDIF (exist? "homerc") :+][+:


IF (exist? "version") :+]
.TP
.BR [+:

  IF (. use-flags)  :+]\-[+: ?% version-value "%s" "v"
     :+] " [{\fIv|c|n\fP}][+:
     IF (exist? "long-opts") :+]," " \--version" "[=\fI{v|c|n}\fP][+:
     ENDIF :+]"[+:
  ELSE     :+][+:
     IF (exist? "long-opts") :+]\--[+:
     ENDIF :+]version "[=\fI{v|c|n}\fP]"[+:
  ENDIF    :+]
Output version of program and exit.  The default mode is `v', a simple
version.  The `c' mode will print copyright information and `n' will
print the full copyright notice.[+:
ENDIF


:+][+:
IF (or (exist? "homerc") (exist? "environrc")) :+]
.SH OPTION PRESETS
Any option that is not marked as \fInot presettable\fP may be preset
by loading values from [+:
  IF (exist? "homerc")
    :+]configuration ("RC" or ".INI") file(s)[+:
    IF (exist? "environrc")
            :+] and values from
[+:
    ENDIF   :+][+:
  ENDIF     :+][+:
  IF (exist? "environrc") :+]environment variables named:
.nf
  \fB[+: (. PROG_NAME) :+]_<option-name>\fP or \fB[+: (. PROG_NAME) :+]\fP
.fi
.ad[+:
    IF (exist? "homerc") :+]
The environmental presets take precedence (are processed later than)
the configuration files.[+:
    ENDIF   :+][+:
  ELSE      :+].[+:
  ENDIF     :+][+:

  CASE
    (define rc-file (if (exist? "rcfile") (get "rcfile")
                    (string-append "." prog_name "rc")  ))
    (count "homerc") :+][+:
  == "0"    :+][+:
  == "1"    :+]
The \fIhomerc\fP file is "\fI[+:homerc:+]\fP", unless that is a directory.
In that case, the file "\fI[+: (. rc-file) :+]\fP"
is searched for within that directory.[+:

  *         :+]
The \fIhomerc\fP files are [+:
    FOR homerc ", "  :+][+:
      IF (last-for?) :+]and [+:
      ENDIF :+]"\fI[+: homerc :+]\fP"[+: ENDFOR :+].
If any of these are directories, then the file \fI[+: (. rc-file) :+]\fP
is searched for within those directories.[+:
  ESAC      :+][+:


ENDIF       :+][+:
IF (exist? "man-doc") :+]
[+:man-doc:+][+:
ENDIF:+][+:

IF (define tmp-str (get "copyright.author" (get "copyright.owner")))
   (> (string-length tmp-str) 0) :+]
.SH AUTHOR
[+: (. tmp-str) :+][+:

 (set! tmp-str (get "copyright.eaddr" (get "eaddr")))
 (if (> (string-length tmp-str) 0)
   (string-append "\n.br\nPlease send bug reports to:  " tmp-str "\n") ) :+][+:

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
ENDIF      :+][+:

INVOKE emit-man-text

:+]
.PP
This manual page was \fIAutoGen\fP-erated from the \fB[+: prog-name :+]\fP
option definitions.[+: #

agman1.tpl ends here  :+]
