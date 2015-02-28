{+ AutoGen5 template  -*- nroff -*-

## agman3.tpl -- Template for command line man pages
##
##  AutoOpts copyright 1992-2002 Bruce Korb
##
## Time-stamp:      "2002-06-10 17:10:34 bkorb"
## Author:          Bruce Korb <bkorb@gnu.org>
## Maintainer:      Bruce Korb <bkorb@gnu.org>
## Created:         Mon Jun 28 15:35:12 1999
##              by: bkorb
## ---------------------------------------------------------------------
## $Id: agman3.tpl,v 2.3 2002/06/11 01:45:31 bkorb Exp $
## ---------------------------------------------------------------------

null

(setenv "SHELL" "/bin/sh")

+}{+

(if (exist? "see-also")
    (define see-also (string-append (get "see-also") " "))
    (define see-also "")  )

+}{+

FOR export_func     +}{+
  (if (not (exist? "private"))
      (set! see-also (string-append see-also
            (get "name") "(3) " ))  )
  +}{+

ENDFOR export_func  +}{+


FOR export_func                +}{+
  IF (not (exist? "private"))  +}{+

    (out-push-new (string-append
         (get "name") ".3" ))

+}.TH {+name+} 3 {+ `date +%Y-%m-%d` +} "" "Programmer's Manual"
{+

;; The following "dne" argument is a string of 5 characters:
;; '.' '\\' '"' and two spaces.  It _is_ hard to read.
;;
(dne ".\\\"  ")

+}
.\"
.SH NAME
{+name+} - {+what+}
.sp 1
.SH SYNOPSIS
cc [...] -o outfile infile.c -l{+library+} [...]
{+

  IF (exist? "header") +}
#include "\fI{+header+}\fP"
{+ENDIF+}
{+ ?% ret-type "%s" void
+} \fB{+name+}\fP({+
  IF (not (exist? "arg")) +}void{+
  ELSE  +}{+
    FOR arg ", " +}{+arg-type+} {+arg-name+}{+
    ENDFOR arg +}{+
  ENDIF +});
.sp 1
.SH DESCRIPTION
{+
(out-push-new) +}
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
 -e 's/\*\([a-zA-Z0-9=_ -]*\)\*/\\fB\1\\fP/g' \
 -e 's/``\([a-zA-Z0-9=_ -]*\)'"''"'/\\fI\1\\fP/g' \
 -e 's/^@\*/.br/' <<'_End_Of_Man_'
{+
(get "doc")    +}{+

  IF (exist? "ret-type") +}
.sp 1
.SH RETURN VALUE
{+ret-desc+}{+

  ENDIF +}{+

  IF (exist? "err") +}
.sp 1
.SH ERRORS
{+err+}{+

  ENDIF +}
_End_Of_Man_{+

(shell (out-pop #t) ) +}
.SH SEE ALSO
The \fIinfo\fP documentation for the \fI-l{+library+}\fP library.
.br
{+(shellf "echo '%s' | \
sed 's,%s(3) ,,;s/3) $/3)/;s/(3) /(3), /g'" see-also (get "name"))+}
{+

    (out-pop)    +}{+

  ENDIF private  +}{+

ENDFOR  export_func


+}
