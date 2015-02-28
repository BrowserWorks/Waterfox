[= Autogen5 Template -*- Mode: scheme -*-

#  List the output suffixes that are to be generated.
#  Header must come first.  An env variable is set that
#  is used in processing the C file.
#
#  $Id: options.tpl,v 2.21 2002/09/29 00:14:18 bkorb Exp $

h
c

# This file contains the templates used to generate the
# option descriptions for client programs, and it declares
# the macros used in the templates.

# Automated Options copyright 1992-2002 Bruce Korb

(setenv "SHELL" "/bin/sh")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# --  COPYRIGHT  --

# Automated Options is free software.
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License, as published by the Free Software
# Foundation; either version 2, or (at your option) any later version.

# Automated Options is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Automated Options.  See the file "COPYING".  If not,
# write to:  The Free Software Foundation, Inc.,
#            59 Temple Place - Suite 330,
#            Boston,  MA  02111-1307, USA.

# As a special exception, Bruce Korb gives permission for additional
# uses of the text contained in his release of AutoOpts.

# The exception is that, if you link the AutoOpts library with other
# files to produce an executable, this does not by itself cause the
# resulting executable to be covered by the GNU General Public License.
# Your use of that executable is in no way restricted on account of
# linking the AutoOpts library code into it.

# This exception does not however invalidate any other reasons why
# the executable file might be covered by the GNU General Public License.

# This exception applies only to the code released by Bruce Korb under
# the name AutoOpts.  If you copy code from other sources under the
# General Public License into a copy of AutoOpts, as the General Public
# License permits, the exception does not apply to the code that you add
# in this way.  To avoid misleading anyone as to the status of such
# modified files, you must delete this exception notice from them.

# If you write modifications of your own for AutoOpts, it is your choice
# whether to permit this exception to apply to your modifications.
# If you do not wish that, delete this exception notice.

# --  END COPYRIGHT  --

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

=][=

 (dne " *  " "/*  ") =]
 */
[=

CASE    (suffix)     =][=

== h

  =][=

  ;;  Establish a number of variations on the spelling of the
  ;;  program name.  Use these Scheme defined values throughout.
  ;;
  (define prog-name       (get "prog_name"))
  (define cap-prog-name   (string-capitalize  prog-name))
  (define UP-prog         (string-upcase      prog-name))

  (define pname           (string->c-name!    (get "prog_name")))
  (define pname-cap       (string-capitalize  pname))
  (define pname-up        (string-upcase      pname))
  (define pname-down      (string-downcase    pname))
  (define number-opt-index  -1)
  (define default-opt-index -1)

  (if (not (exist? "flag.name"))
      (error "No options have been defined" ))

  (if (> (count "flag") 100)
      (error (sprintf "%d options are too many - limit of 100"
                  (count "flag")) ))

  (if (> (len "prog_name") 16)
      (error (sprintf "Prog_name limited to 16 characters:  %s"
                    (get "prog_name")) ))

  ;; IF    long options are disallowed
  ;;   AND at least one flag character (value) is supplied
  ;; THEN every option must have a 'value' attribute
  ;;
  (define must-have-values
      (if (and (not (exist? "long_opts")) (exist? "flag.value"))
          1 0 ))

  (if (exist? "flag.extract_code")
      (shellf "f=%s.c ; [ -f $f ] && [ -s $f ] && mv -f $f $f.save"
              (base-name)))

  (define descriptor "")
  (define opt-name "")
  (define flg-name "")
  (define UP-name  "")
  (define cap-name "")
  (define low-name "")
  (define set-flag-names (lambda () (begin
      (set! flg-name (get "name"))
      (set! UP-name  (string-upcase (string->c-name! flg-name)))
      (set! cap-name (string-capitalize UP-name ))
      (set! low-name (string-downcase   UP-name ))
  ) ) )

  (if (exist? "prefix")
   (begin
     (define UP-prefix  (string-append (string-upcase! (get "prefix")) "_"))
     (define Cap-prefix (string-capitalize UP-prefix))
   )
   (begin
     (define UP-prefix  "")
     (define Cap-prefix "")
   )  )

  =][=
  FOR flag           =][=

    (if (> (len "name") 32)
        (error (sprintf "Option %d name exceeds 32 characters: %s"
                       (for-index) (get "name")) ))

    (if (< 1 (count "value"))
        (error (sprintf "Option %s has too many `value's" (get "name"))))

    (if (and (= 1 must-have-values)
             (not (exist? "documentation"))
             (not (exist? "value")))
        (error (sprintf "Option %s needs a `value' attribute" (get "name"))))

    (if (< 1
           (+ (if (exist? "call-proc")    1 0)
              (if (exist? "flag-code")    1 0)
              (if (exist? "arg-range")    1 0)
              (if (exist? "extract-code") 1 0)
              (if (exist? "flag-proc")    1 0)
              (if (=* (get "arg-type") "key") 1 0)
              (if (exist? "stack-arg")    1 0) ))
       (error (sprintf "Option %s has multiple code specifications"
                      (get "name")) ))

    (if (and (exist? "stack_arg") (not (exist? "arg_type")))
        (error (sprintf "Option %s has stacked args, but no arg_type"
                        (get "name"))))
  =][=
  ENDFOR flag        =][=

  IF `if [ -z "${COLUMNS_EXE}" ] ; then
    COLUMNS_EXE="\`type columns 2>/dev/null\`"
    if [ $? -ne 0 ]
    then echo failure
      COLUMNS_EXE=false
    else
      COLUMNS_EXE="\`echo ${COLUMNS_EXE}|sed 's,.* ,,'\`"
  fi ; fi
  ${COLUMNS_EXE} -v > /dev/null || echo failure`  =][=
    (error "Cannot find a working 'columns' program") =][=
  ENDIF =][=

  include "optlib"   =][=

  include "opthead"  =][= # create the option header

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

== c  =][=  C Code   =][=

   include "optcode" =][= ;; create the option source code

   (if (exist? "flag.extract-code")
       (shellf "[ -f %1$s.c ] && rm -f %1$s.c.save" (base-name)))  =][=

ESAC =]
