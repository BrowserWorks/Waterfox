[=  AutoGen5 Template  -*- Mode: shell-script -*-

 help-text

# This file is part of AutoGen.
# AutoGen Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
#
# AutoGen is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# AutoGen is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

=][=

 ;; This template is designed to emit help text from the current set
 ;; of option definitions.
 ;;
 (make-tmp-dir)
 (out-push-new (shellf "echo ${tmp_dir}/%s.def" (get "prog-name")))

=]
AutoGen Definitions options.tpl;
no-libopts;
[=

FOR var IN  prog-name prog-title argument      config-header
            environrc export     homerc        include
            long-opts rcfile     version       detail
            explain   package    preserve-case prog-desc
            opts-ptr  gnu-usage  reorder-args  usage-opt

             version-value help-value more-help-value usage-value
             save-opts-value load-opts-value
  =][=

  IF (exist? (get "var"))   =]
[= var =] = [= (kr-string (get (get "var"))) =];[=
  ENDIF have "var"          =][=

ENDFOR var IN ....          =][=

FOR copyright               =]
copyright = {[=

  FOR var IN  date owner type text author eaddr
    =][=

    IF (exist? (get "var")) =]
    [= var =] = [=
       (kr-string (get (string-append "copyright." (get "var"))))=];[=
    ENDIF have "var"        =][=

  ENDFOR var IN ....        =]
};[=
ENDFOR copyright            =]

main = {
  main-type = shell-process;
};

[=

FOR flag

=]
flag = {[=

  FOR var IN name descrip value max min must-set enable disable enabled
             ifdef ifndef no-preset settable equivalence documentation
             immediate immed-disable also
             arg-type arg-optional arg-default default arg-range
             stack-arg unstack-arg
    =][=

    IF (exist? (get "var")) =]
    [= var =] = [= (kr-string (get (get "var"))) =];[=
    ENDIF have "var"        =][=

  ENDFOR var IN ....        =][=

  IF (exist? "keyword")     =]
    keyword = [= (join "," (stack "keyword")) =];[=
  ENDIF  keyword exists     =][=

  IF (exist? "flags-must")  =]
    flags-must = [= (join "," (stack "flags-must")) =];[=
  ENDIF  flags-must exists  =][=

  IF (exist? "flags-cant")  =]
    flags-cant = [= (join "," (stack "flags-cant")) =];[=
  ENDIF  flags-cant exists  =]
};[=

ENDFOR flag

=][=

(out-pop)
(out-push-new)  \=]

defs=-DTEST_[= (string-upcase! (string->c-name! (get "prog-name"))) =]_OPTS=1
cflags=`autoopts-config cflags`
ldflags=`autoopts-config ldflags`
flags="${defs} ${cflags} ${CFLAGS}"

( cd ${tmp_dir}
  autogen [= prog-name=].def
) || die "Cannot gen [= prog-name =]"
exe=tmp-[= prog-name =]-$$
cfile=${tmp_dir}/[= prog-name =].c
${CC:-cc} ${flags} -g -o ${exe} ${cfile} ${ldflags} || \
  die cannot compile ${cfile}
mv -f ${exe} ${tmp_dir}/[= prog-name =]
${tmp_dir}/[= prog-name =] [=

CASE usage-type =][=
== short        =][=
   IF (exist? "usage-opt") =][=
      (if (exist? "long-opts") "--usage"
          (string-append "-"
              (if (exist? "usage-value") (get "usage-value") "u")) ) =][=
   ELSE no usage-opt 
      =]--give-me-short-usage 2>&1 | sed -e '/: illegal option /d'[=
   ENDIF        =][=

*               =][=

  (if (exist? "long-opts") "--help"
      (string-append "-" (if (exist? "help-value") (get "help-value") "?")) )

=][=

ESAC      =] || \
  die cannot obtain [= prog-name =] help in ${tmp_dir}[=

(shell (out-pop #t))

=]
[=

# end of usage.tpl      \=]
