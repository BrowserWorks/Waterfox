[= AutoGen5 Template  -*- Mode: Text -*-

#  AutoGen copyright 1992-2002 Bruce Korb

=][=

DEFINE state-table  =]
  { [=
  (shellf "state=%s" (string-upcase! (get "state"))) =][=

  FOR event "\n    "  =][=
    IF (first-for?)   =][=
       (set! fmt (shellf "eval echo \\\"\\$FSM_TRANS_${state}_%s,\\\""
                 (string-upcase! (get "event"))  ))
       (sprintf "%-47s /* %s state */" fmt (get "state")) =][=
    ELSE     =][=
       (shellf "eval echo \\\"\\$FSM_TRANS_${state}_%s%s\\\""
                 (string-upcase! (get "event"))
                 (if (not (last-for?)) "," "")) =][=
    ENDIF    =][=
  ENDFOR     =] }[=
ENDDEF       =][=

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
typedef struct transition t_transition;
struct transition {
    te_[=(. pfx)=]_state  next_state;
    te_[=(. pfx)=]_trans  transition;
};
[=

  IF (exist? "use_ifdef")

=]
#ifndef DEFINE_FSM
extern const t_transition [=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ];

extern int
[=(. pfx)=]_invalid_transition( te_[=(. pfx)=]_state st, te_[=
  (. pfx)=]_event evt );
#else
[=

  ELSE

=]static [=
  ENDIF

=]const t_transition
[=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ] = {[=
  state-table
    state = init =][=

  FOR state      =],
[=  state-table  =][=
  ENDFOR         =]
};[=

  IF (exist? "use_ifdef") =][=
  emit-invalid-msg =]
#endif /* DEFINE_FSM */[=
  ENDIF      =][=

ENDDEF       =][=

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
typedef struct transition t_transition;
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
static const t_transition
[=(. pfx)=]_trans_table[ [=(. PFX)
=]_STATE_CT ][ [=(. PFX)=]_EVENT_CT ] = {[=

  state-table
    state = init =][=

  FOR state      =],[=
    state-table  =][=
  ENDFOR         =]
};[=

ENDDEF       =][=

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
    if (trans_evt >= [=(. PFX)=]_EV_INVALID) {
        nxtSt = [=(. PFX)=]_ST_INVALID;
        [=(. trans-name)=] = [=(. trans-valu)=];
    } else {
        const t_transition* pTT = [=(. pfx)=]_trans_table[ [=(. pfx)
                                  =]_state ] + trans_evt;
        nxtSt = firstNext = pTT->next_state;
        [=(. trans-name)=] = pTT->[=(. trans-field)=];
    }

#ifdef DEBUG
    printf( "in state %s(%d) step %s(%d) to %s(%d)\n",
            [=(. PFX)=]_STATE_NAME( [=(. pfx)=]_state ), [=(. pfx)=]_state,
            [=(. PFX)=]_EVT_NAME( trans_evt ), trans_evt,
            [=(. PFX)=]_STATE_NAME( nxtSt ), nxtSt );
#endif[=

  IF (=* (get "method") "case")  =][=
    run-switch    =][=
  ELSE            =][=
    run-callback  =][=
  ENDIF

=]
#ifdef DEBUG
    if (nxtSt != firstNext)
        printf( "transition code changed destination state to %s(%d)\n",
                [=(. PFX)=]_STATE_NAME( nxtSt ), nxtSt );
#endif[=

  IF (not (=* (get "type") "reent")) =]
    [=(. pfx)=]_state = nxtSt;[=
  ENDIF  =]
[=
ENDDEF  machine-step     =][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE fsm-proc-variables

  =]
    te_[=(. pfx)=]_state nxtSt, firstNext;[=
    IF (=* (get "method") "call")  =]
    [=(. pfx)=]_callback_t* pT;[=
    ELSE  =]
    te_[=(. pfx)=]_trans trans;[=
    ENDIF =][=

ENDDEF       =][=

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
ENDDEF make-loop-proc  =][=

DEFINE looping-machine

  =][= make-loop-proc mode = "" =]
{
    te_[=(. pfx)=]_state [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;
    te_[=(. pfx)=]_event trans_evt;[=
    fsm-proc-variables  =]

    while ([=(. pfx)=]_state < [=(. PFX)=]_ST_INVALID) {

[=(extract fsm-source "        /* %s == FIND TRANSITION == %s */" ""
           "        trans_evt = GET_NEXT_TRANS();" )=]
[=  (out-push-new ".fsm.cktbl")=][=
    machine-step =][=
    (out-pop)
    (shell "sed 's/^ /     /;s/                /            /' .fsm.cktbl") =]
    }
    return [=(. pfx)=]_state;
}[=

ENDDEF       =][=


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

ENDDEF make-step-proc  =][=

DEFINE stepping-machine

  =][= make-step-proc mode = "" =]
{[=
    fsm-proc-variables  =]

    if ((unsigned)[=(. pfx)=]_state >= [=(. PFX)=]_ST_INVALID) {[=
  IF (=* (get "type") "step") =]
        [=(. pfx)=]_state = [=(. PFX)=]_ST_INIT;[=
  ENDIF  =]
        return [=(. PFX)=]_ST_INIT;
    }
[=  machine-step =]

[=(extract fsm-source "    /* %s == FINISH STEP == %s */")=]

    return nxtSt;
}[=


ENDDEF       =]
