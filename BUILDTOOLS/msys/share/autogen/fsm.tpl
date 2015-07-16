[= AutoGen5 Template  -*- Mode: text -*-

h=%s-fsm.h

c=%s-fsm.c

#  Time-stamp:      "2010-02-24 08:42:13 bkorb"

## This file is part of AutoGen.
## AutoGen Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
##
## AutoGen is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the
## Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## AutoGen is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program.  If not, see <http://www.gnu.org/licenses/>.
##
## NB:  THIS FILE IS GPL.  THE OUTPUT OF THIS FILE IS LICENSED MBSD.

(setenv "SHELL" "/bin/sh")
(define fmt "")
(shellf "test -f %1$s-fsm.h && mv -f %1$s-fsm.h .fsm.head
         test -f %1$s-fsm.c && mv -f %1$s-fsm.c .fsm.code" (base-name))

(define add-cleanup (lambda (t)
   (set! shell-cleanup (string-append shell-cleanup "\n" t "\n"))  ))
(add-cleanup "rm -f .fsm.*")

=]
[=

CASE (suffix) =][=

== h =][=

  INCLUDE "fsm-trans.tpl" =][=
  INCLUDE "fsm-macro.tpl" =][=

  INVOKE  preamble

=]
/*
 *  This file enumerates the states and transition events for a FSM.
 *
 *  te_[=(. pfx)=]_state
 *      The available states.  FSS_INIT is always defined to be zero
 *      and FSS_INVALID and FSS_DONE are always made the last entries.
 *
 *  te_[=(. pfx)=]_event
 *      The transition events.  These enumerate the event values used
 *      to select the next state from the current state.
 *      [=(. PFX)=]_EV_INVALID is always defined at the end.
 */
[=(make-header-guard "autofsm")=]
[=

FOR extra-header "\n" \=]
#include "[=extra-header=]"[=
ENDFOR

=]
/*
 *  Finite State machine States
 *
 *  Count of non-terminal states.  The generated states INVALID and DONE
 *  are terminal, but INIT is not  :-).
 */
#define [=(. PFX)=]_STATE_CT  [=(+ 1 (count "state"))=]
typedef enum {
[=
  (shellf "${CLexe-columns} --spread=1 -I4 -S, -f'%s_ST_%%s' <<_EOF_
INIT
%s
INVALID
DONE
_EOF_" PFX (string-upcase! (join "\n" (stack "state"))) )=]
} te_[=(. pfx)=]_state;

/*
 *  Finite State machine transition Events.
 *
 *  Count of the valid transition events
 */
#define [=(. PFX)=]_EVENT_CT [=(count "event")=]
typedef enum {
[= compute-transitions =][=
  (shellf "${CLexe-columns} --spread=1 -I4 -S, -f'%s_EV_%%s' <<_EOF_
%s
INVALID
_EOF_" PFX (string-upcase! (join "\n" (stack "event"))) )=]
} te_[=(. pfx)=]_event;
[=

  CASE method     =][=

  ~*  call|case   =][=

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    #
    #   We are implementing the machine.  Declare the external  =][=

    CASE type     =][=

    ~* step|reent =][= make-step-proc mode = "extern " =];[=

    =* loop       =][= make-loop-proc mode = "extern " =];[=

    *             =][=
    (error (string-append "invalid FSM type:  ``" (get "type")
           "'' must be ``looping'', ``stepping'' or ``reentrant''" ))
    =][=
    ESAC          =][=

    #  End external procedure declarations
    #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #
  #   We are *NOT* implementing the machine.  Define the table  =][=

  ==  ""       =][=
    enumerate-transitions  use_ifdef = yes  =][=
  =*  no       =][=
    enumerate-transitions  use_ifdef = yes  =][=
  *            =][=
    (error (sprintf
        "invalid FSM method:  ``%s'' must be ``callout'', ``case'' or ``none''"
        (get "method"))) =][=
  ESAC         =]

#endif /* [=(. header-guard)=] */[=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#   C OUTPUT BEGINS HERE
#
=][=

== c =][=

  (if (~ (get "method") "(no.*){0,1}")
      (out-delete)  ) =][=

  INVOKE preamble

=]
#define DEFINE_FSM
#include "[=(. header-file)=]"
#include <stdio.h>
#include <ctype.h>
[=IF (exist? "handler-file")=]
#define FSM_USER_HEADERS
#include "[= handler-file =]"
#undef  FSM_USER_HEADERS[=
  ELSE =]
/*
 *  Do not make changes to this file, except between the START/END
 *  comments, or it will be removed the next time it is generated.
 */
[=(extract fsm-source "/* %s === USER HEADERS === %s */")=][=
  ENDIF =]

#ifndef NULL
#  define NULL 0
#endif
[= CASE method          =][=
   =* "case"            =][= enumerate-transitions =][=
   =* "call"            =][= callback-transitions  =][=
   ESAC                 =]
[=IF (=* (get "type") "step")=]
/*
 *  The FSM machine state
 */
static te_[=(. pfx)=]_state [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;
[=ENDIF=]
[= emit-invalid-msg     =][=

  IF  (=* (get "method") "call") =][=

    IF (exist? "handler-file")   =]
#define FSM_HANDLER_CODE
#include "[= handler-file =]"
#undef  FSM_HANDLER_CODE
[=
    ELSE                =][=
      INVOKE callbacks  =][=
    ENDIF               =][=

  ELSE                  =][=
  ENDIF                 =][=

  CASE type             =][=
  =*   loop             =][= looping-machine  =][=
  ~*   step|reent       =][= stepping-machine =][=
  ESAC                  =][=

ESAC (suffix)

=]
/*
 * Local Variables:
 * mode: C
 * c-file-style: "stroustrup"
 * indent-tabs-mode: nil
 * End:
 * end of [=(out-name)=] */
