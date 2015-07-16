[= AutoGen5 Template  -*- Mode: Text -*-

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

=][=

(define event-string "")  =][=

DEFINE state-table  =]

  /* STATE [= (get "st_ix") =]:  [=
              (. PFX)=]_ST_[= (string-upcase! (get "state")) =] */
  { [=
  (shellf "state=%s" (string-upcase! (get "state"))) =][=

  FOR event "\n    "  =][=
    (set! fmt (shellf "eval echo \\\"\\$FSM_TRANS_${state}_%s%s\\\""
              (string-upcase! (get "event"))
              (if (last-for?) "" ",")  ))
    (set! event-string (if (exist? (get "event"))
                           (get (get "event"))
                           (get "event")  ))
    (sprintf "%-47s /* EVT:  %s */" fmt event-string ) =][=

  ENDFOR

=]
  }[=

ENDDEF state-table

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE  enumerate-transitions   =]
/*
 *  Enumeration of the valid transition types
 *  Some transition types may be common to several transitions.
 */
typedef enum {
[=(string-upcase! (shellf
 "sed '$s/,$//;s/^/    %s_TR_/' .fsm.xlist" PFX))=]
} te_[=(. pfx)=]_trans;
#define [=(. PFX)=]_TRANSITION_CT  [=
   `tct="\`wc -l < .fsm.xlist\`"
   echo $tct`=]

/*
 *  the state transition handling map
 *  This table maps the state enumeration + the event enumeration to
 *  the new state and the transition enumeration code (in that order).
 *  It is indexed by first the current state and then the event code.
 */
typedef struct [=(. pfx)=]_transition [= (. t-trans) =];
struct [=(. pfx)=]_transition {
    te_[=(. pfx)=]_state  next_state;
    te_[=(. pfx)=]_trans  transition;
};
[=

  IF (exist? "use_ifdef")

=]
#ifndef DEFINE_FSM
extern const [= (. t-trans) =] [=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ];

extern int
[=(. pfx)=]_invalid_transition( te_[=(. pfx)=]_state st, te_[=
  (. pfx)=]_event evt );
#else
[=

  ELSE

=]static [=
  ENDIF

=]const [= (. t-trans) =]
[=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ] = {[=
  state-table
    state = init
    st_ix = "0"  =][=

  FOR state      =],
[=  state-table  st_ix = (+ 1 (for-index)) =][=
  ENDFOR         =]
};[=

  IF (exist? "use_ifdef") =][=
  emit-invalid-msg =]
#endif /* DEFINE_FSM */[=
  ENDIF      =][=

ENDDEF  enumerate-transitions

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE callback-transitions

=]
/*
 *  This is the prototype for the callback routines.  They are to
 *  return the next state.  Normally, that should be the value of
 *  the "maybe_next" argument.
 */
typedef te_[=(. pfx)=]_state ([=(. pfx)=]_callback_t)([=
    emit-cookie-args =]
    te_[=(. pfx)=]_state initial,
    te_[=(. pfx)=]_state maybe_next,
    te_[=(. pfx)=]_event trans_evt );

static [=(. pfx)=]_callback_t
[=(shellf "sed '$s/,$/;/;s/^/    %s_do_/' .fsm.xlist" pfx)=]

/*
 *  This declares all the state transition handling routines
 */
typedef struct transition [= (. t-trans) =];
struct transition {[=
    (set! fmt (sprintf "\n    %%-%ds %%s;"
                (+ (string-length pfx) 14) ))
    (sprintf (string-append fmt fmt)
             (string-append "te_" pfx "_state") "next_state"
             (string-append pfx "_callback_t*") "trans_proc") =]
};

/*
 *  This table maps the state enumeration + the event enumeration to
 *  the new state and the transition enumeration code (in that order).
 *  It is indexed by first the current state and then the event code.
 */
static const [= (. t-trans) =]
[=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ] = {[=

  state-table
    state = init st_ix = "0" =][=

  FOR state      =],[=
    state-table  st_ix = (+ 1 (for-index)) =][=
  ENDFOR         =]
};[=

ENDDEF callback-transitions

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE machine-step  =][=

  (if (=* (get "method") "case")
      (begin (define trans-name "trans")
             (define trans-field "transition")
             (define trans-valu (string-append PFX "_TR_INVALID"))  )
      (begin (define trans-name "pT   ")
             (define trans-field "trans_proc")
             (define trans-valu (string-append pfx "_do_invalid"))  ))
=]
#ifndef __COVERITY__
    if (trans_evt >= [=(. PFX)=]_EV_INVALID) {
        nxtSt = [=(. PFX)=]_ST_INVALID;
        [=(. trans-name)=] = [=(. trans-valu)=];
    } else
#endif /* __COVERITY__ */
    {
        const [= (. t-trans) =]* pTT =
            [=(. pfx)=]_trans_table[ [=(. pfx)=]_state ] + trans_evt;
[= IF (exist? "debug-flag") \=]
#ifdef [= (get "debug-flag") =]
        firstNext = /* next line */
#endif /* [= "debug-flag =] */
[= ENDIF \=]
        nxtSt = pTT->next_state;
        [=(. trans-name)=] = pTT->[=(. trans-field)=];
    }
[= IF (exist? "debug-flag") \=]
#ifdef [= (get "debug-flag") =]
    printf( "in state %s(%d) step %s(%d) to %s(%d)\n",
            [=(. PFX)=]_STATE_NAME( [=(. pfx)=]_state ), [=(. pfx)=]_state,
            [=(. PFX)=]_EVT_NAME( trans_evt ), trans_evt,
            [=(. PFX)=]_STATE_NAME( nxtSt ), nxtSt );
#endif /* [= "debug-flag =] */
[= ENDIF \=][=

  IF (not (=* (get "method") "case"))  =][=
    INVOKE run-callback         =][=
  ELIF (exist? "handler-file")  =]
#define FSM_SWITCH_CODE
#include "[= handler-file =]"
#undef  FSM_SWITCH_CODE[=
  ELSE                          =][=
    INVOKE run-switch           =][=
  ENDIF

=]
[= IF (exist? "debug-flag") \=]
#ifdef [= (get "debug-flag") =]
    if (nxtSt != firstNext)
        printf( "transition code changed destination state to %s(%d)\n",
                [=(. PFX)=]_STATE_NAME( nxtSt ), nxtSt );
#endif /* [= "debug-flag =] */
[= ENDIF \=][=

  IF (not (=* (get "type") "reent")) =]
    [=(. pfx)=]_state = nxtSt;[=
  ENDIF  =]
[=
ENDDEF  machine-step

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE fsm-proc-variables

  =]
[= IF (exist? "debug-flag") \=]
#ifdef [= (get "debug-flag") =]
    te_[=(. pfx)=]_state firstNext;
#endif
[= ENDIF \=]
    te_[=(. pfx)=]_state nxtSt;[=
    IF (=* (get "method") "call")  =]
    [=(. pfx)=]_callback_t* pT;[=
    ELSE  =]
    te_[=(. pfx)=]_trans trans;[=
    ENDIF =][=

ENDDEF fsm-proc-variables

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE make-loop-proc  =]
/*
 *  Run the FSM.  Will return [=(. PFX)=]_ST_DONE or [=(. PFX)=]_ST_INVALID
 */
[=mode=]te_[=(. pfx)=]_state
[=(. pfx)=]_run_fsm([=
  IF (exist? "cookie") =][=
    FOR cookie "," =]
    [=cookie=][=
    ENDFOR=][=
  ELSE=] void[=ENDIF=] )[=

ENDDEF make-loop-proc

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE looping-machine

  =][= make-loop-proc mode = "" =]
{
    te_[=(. pfx)=]_state [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;
    te_[=(. pfx)=]_event trans_evt;[=
    INVOKE fsm-proc-variables  =]

    while ([=(. pfx)=]_state < [=(. PFX)=]_ST_INVALID) {
[=IF (exist? "handler-file")=]
#define FSM_FIND_TRANSITION
#include "[= handler-file =]"
#undef  FSM_FIND_TRANSITION[=
  ELSE =]
[=(extract fsm-source "        /* %s == FIND TRANSITION == %s */" ""
           "        trans_evt = GET_NEXT_TRANS();" ) =][=
  ENDIF =]
[=  (out-push-new ".fsm.cktbl")=][=
    INVOKE machine-step =][=
    (out-pop)
    (shell "sed 's/^ /     /;s/                /            /' .fsm.cktbl") =]
    }
    return [=(. pfx)=]_state;
}[=

ENDDEF looping-machine

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE make-step-proc  =]
/*
 *  Step the FSM.  Returns the resulting state.  If the current state is
 *  [=(. PFX)=]_ST_DONE or [=(. PFX)=]_ST_INVALID, it resets to
 *  [=(. PFX)=]_ST_INIT and returns [=(. PFX)=]_ST_INIT.
 */
[=mode=]te_[=(. pfx)=]_state
[=(. pfx)=]_step([=
  IF (=* (get "type") "reent") =]
    te_[= (. pfx) =]_state [= (. pfx) =]_state,[=
  ENDIF  =]
    te_[= (. pfx) =]_event trans_evt[=
  FOR cookie =],
    [=cookie=][=
  ENDFOR=] )[=

ENDDEF make-step-proc

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE stepping-machine

  =][= INVOKE make-step-proc mode = "" =]
{[=
    fsm-proc-variables  =]

    if ((unsigned)[=(. pfx)=]_state >= [=(. PFX)=]_ST_INVALID) {[=
  IF (=* (get "type") "step") =]
        [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;[=
  ENDIF  =]
        return [=(. PFX)=]_ST_INIT;
    }
[=INVOKE machine-step       =][=
  IF (exist? "handler-file")=]
#define FSM_FINISH_STEP
#include "[= handler-file =]"
#undef  FSM_FINISH_STEP[=
  ELSE =]
[=(extract fsm-source "    /* %s == FINISH STEP == %s */")=][=
  ENDIF =]

    return nxtSt;
}[=

ENDDEF stepping-machine

=]
