[= AutoGen5 Template  -*- Mode: text -*-

h=%s-fsm.h

c=%s-fsm.c

(setenv "SHELL" "/bin/sh")
(define fmt "")
(shellf "[ -f %1$s-fsm.h ] && mv -f %1$s-fsm.h .fsm.head
[ -f %1$s-fsm.c ] && mv -f %1$s-fsm.c .fsm.code" (base-name))

#  AutoGen copyright 1992-2002 Bruce Korb

=][=

CASE (suffix) =][=

== h =][=

  INCLUDE "fsm-trans.tpl" =][=
  INCLUDE "fsm-macro.tpl" =][=

  preamble     

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

/*
 *  Finite State machine States
 *
 *  Count of non-terminal states.  The generated states INVALID and DONE
 *  are terminal, but INIT is not  :-).
 */
#define [=(. PFX)=]_STATE_CT  [=(+ 1 (count "state"))=]
typedef enum {
[=
  (shellf "${COLUMNS_EXE-columns} --spread=1 -I4 -S, -f'%s_ST_%%s' <<_EOF_
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
  (shellf "${COLUMNS_EXE-columns} --spread=1 -I4 -S, -f'%s_EV_%%s' <<_EOF_
%s
INVALID
_EOF_" PFX (string-upcase! (join "\n" (stack "event"))) )=]
} te_[=(. pfx)=]_event;
[=

  CASE method  =][=

  ~*  call|case=][=

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
      (begin (shell "rm -f .fsm.*") (out-delete))  ) =][=

  preamble     

=]
#define DEFINE_FSM
#include "[=(. header-file)=]"
#include <stdio.h>

/*
 *  Do not make changes to this file, except between the START/END
 *  comments, or it will be removed the next time it is generated.
 */
[=(extract fsm-source "/* %s === USER HEADERS === %s */")=]

#ifndef NULL
#  define NULL 0
#endif

#ifndef tSCC
#  define tSCC static const char
#endif
[= CASE method  =][=

  =* "case"       =][=
   enumerate-transitions =][=
  =* "call"       =][=
   callback-transitions  =][=
  ESAC            =]
[=IF (=* (get "type") "step")=]
/*
 *  The FSM machine state
 */
static te_[=(. pfx)=]_state [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;
[=ENDIF=]
[= emit-invalid-msg =][=

  IF  (=* (get "method") "call")        =][=

    `set -- \`sed 's/,//' .fsm.xlist\`` =][=

    WHILE `echo $#`     =][=

      invoke build-callback
        cb_prefix = (string-append pfx "_do")
        cb_name   = (shell "echo $1 ; shift") =][=

    ENDWHILE  echo $#   =][=

  ENDIF                 =][=


  CASE type             =][=

  =*  loop              =][=
    looping-machine     =][=
  ~*  step|reent        =][=
    stepping-machine    =][=
  ESAC                  =][=

  `rm -f .fsm.*`        =][=

ESAC (suffix) =][=

trailer =]
