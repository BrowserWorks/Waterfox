/*    sv.h
 *
 *    Copyright (C) 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
 *    2000, 2001, 2002, 2003, 2004, 2005, 2006 by Larry Wall and others
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 */

#ifdef sv_flags
#undef sv_flags		/* Convex has this in <signal.h> for sigvec() */
#endif

/*
=head1 SV Flags

=for apidoc AmU||svtype
An enum of flags for Perl types.  These are found in the file B<sv.h>
in the C<svtype> enum.  Test these flags with the C<SvTYPE> macro.

=for apidoc AmU||SVt_PV
Pointer type flag for scalars.  See C<svtype>.

=for apidoc AmU||SVt_IV
Integer type flag for scalars.  See C<svtype>.

=for apidoc AmU||SVt_NV
Double type flag for scalars.  See C<svtype>.

=for apidoc AmU||SVt_PVMG
Type flag for blessed scalars.  See C<svtype>.

=for apidoc AmU||SVt_PVAV
Type flag for arrays.  See C<svtype>.

=for apidoc AmU||SVt_PVHV
Type flag for hashes.  See C<svtype>.

=for apidoc AmU||SVt_PVCV
Type flag for code refs.  See C<svtype>.

=cut
*/

typedef enum {
	SVt_NULL,	/* 0 */
	SVt_IV,		/* 1 */
	SVt_NV,		/* 2 */
	SVt_RV,		/* 3 */
	SVt_PV,		/* 4 */
	SVt_PVIV,	/* 5 */
	SVt_PVNV,	/* 6 */
	SVt_PVMG,	/* 7 */
	SVt_PVBM,	/* 8 */
	SVt_PVLV,	/* 9 */
	SVt_PVAV,	/* 10 */
	SVt_PVHV,	/* 11 */
	SVt_PVCV,	/* 12 */
	SVt_PVGV,	/* 13 */
	SVt_PVFM,	/* 14 */
	SVt_PVIO	/* 15 */
} svtype;

/* Using C's structural equivalence to help emulate C++ inheritance here... */

struct STRUCT_SV {		/* struct sv { */
    void*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

struct gv {
    XPVGV*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

struct cv {
    XPVCV*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

struct av {
    XPVAV*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

struct hv {
    XPVHV*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

struct io {
    XPVIO*	sv_any;		/* pointer to something */
    U32		sv_refcnt;	/* how many references to us */
    U32		sv_flags;	/* what we are */
};

/*
=head1 SV Manipulation Functions

=for apidoc Am|U32|SvREFCNT|SV* sv
Returns the value of the object's reference count.

=for apidoc Am|SV*|SvREFCNT_inc|SV* sv
Increments the reference count of the given SV.

=for apidoc Am|void|SvREFCNT_dec|SV* sv
Decrements the reference count of the given SV.

=for apidoc Am|svtype|SvTYPE|SV* sv
Returns the type of the SV.  See C<svtype>.

=for apidoc Am|void|SvUPGRADE|SV* sv|svtype type
Used to upgrade an SV to a more complex form.  Uses C<sv_upgrade> to
perform the upgrade if necessary.  See C<svtype>.

=cut
*/

#define SvANY(sv)	(sv)->sv_any
#define SvFLAGS(sv)	(sv)->sv_flags
#define SvREFCNT(sv)	(sv)->sv_refcnt

#ifdef USE_5005THREADS

#  if defined(VMS)
#    define ATOMIC_INC(count) __ATOMIC_INCREMENT_LONG(&count)
#    define ATOMIC_DEC_AND_TEST(res,count) res=(1==__ATOMIC_DECREMENT_LONG(&count))
 #  else
#    ifdef EMULATE_ATOMIC_REFCOUNTS
 #      define ATOMIC_INC(count) STMT_START {	\
	  MUTEX_LOCK(&PL_svref_mutex);		\
	  ++count;				\
	  MUTEX_UNLOCK(&PL_svref_mutex);		\
       } STMT_END
#      define ATOMIC_DEC_AND_TEST(res,count) STMT_START {	\
	  MUTEX_LOCK(&PL_svref_mutex);			\
	  res = (--count == 0);				\
	  MUTEX_UNLOCK(&PL_svref_mutex);			\
       } STMT_END
#    else
#      define ATOMIC_INC(count) atomic_inc(&count)
#      define ATOMIC_DEC_AND_TEST(res,count) (res = atomic_dec_and_test(&count))
#    endif /* EMULATE_ATOMIC_REFCOUNTS */
#  endif /* VMS */
#else
#  define ATOMIC_INC(count) (++count)
#  define ATOMIC_DEC_AND_TEST(res, count) (res = (--count == 0))
#endif /* USE_5005THREADS */

#if defined(__GNUC__) && !defined(__STRICT_ANSI__) && !defined(PERL_GCC_PEDANTIC)
#  define SvREFCNT_inc(sv)		\
    ({					\
	SV * const _sv = (SV*)(sv);	\
	if (_sv)			\
	     ATOMIC_INC(SvREFCNT(_sv));	\
	_sv;				\
    })
#else
#  ifdef USE_5005THREADS
#    if defined(VMS) && defined(__ALPHA)
#      define SvREFCNT_inc(sv) \
          (PL_Sv=(SV*)(sv), (PL_Sv && __ATOMIC_INCREMENT_LONG(&(SvREFCNT(PL_Sv)))), (SV *)PL_Sv)
#    else
#      define SvREFCNT_inc(sv) sv_newref((SV*)sv)
#    endif
#  else
#    define SvREFCNT_inc(sv)	\
	((PL_Sv=(SV*)(sv)), (PL_Sv && ATOMIC_INC(SvREFCNT(PL_Sv))), (SV*)PL_Sv)
#  endif
#endif

#define SvREFCNT_dec(sv)	sv_free((SV*)(sv))

#define SVTYPEMASK	0xff
#define SvTYPE(sv)	((sv)->sv_flags & SVTYPEMASK)

#define SvUPGRADE(sv, mt) (SvTYPE(sv) >= mt || sv_upgrade(sv, mt))

#define SVs_PADBUSY	0x00000100	/* reserved for tmp or my already */
#define SVs_PADTMP	0x00000200	/* in use as tmp */
#define SVs_PADMY	0x00000400	/* in use a "my" variable */
#define SVs_TEMP	0x00000800	/* string is stealable? */
#define SVs_OBJECT	0x00001000	/* is "blessed" */
#define SVs_GMG		0x00002000	/* has magical get method */
#define SVs_SMG		0x00004000	/* has magical set method */
#define SVs_RMG		0x00008000	/* has random magical methods */

#define SVf_IOK		0x00010000	/* has valid public integer value */
#define SVf_NOK		0x00020000	/* has valid public numeric value */
#define SVf_POK		0x00040000	/* has valid public pointer value */
#define SVf_ROK		0x00080000	/* has a valid reference pointer */

#define SVf_FAKE	0x00100000	/* glob or lexical is just a copy */
#define SVf_OOK		0x00200000	/* has valid offset value */
#define SVf_BREAK	0x00400000	/* refcnt is artificially low - used
					 * by SV's in final arena  cleanup */
#define SVf_READONLY	0x00800000	/* may not be modified */


#define SVp_IOK		0x01000000	/* has valid non-public integer value */
#define SVp_NOK		0x02000000	/* has valid non-public numeric value */
#define SVp_POK		0x04000000	/* has valid non-public pointer value */
#define SVp_SCREAM	0x08000000	/* has been studied? */

#define SVf_UTF8        0x20000000      /* SvPV is UTF-8 encoded */

#define SVf_THINKFIRST	(SVf_READONLY|SVf_ROK|SVf_FAKE)

#define SVf_OK		(SVf_IOK|SVf_NOK|SVf_POK|SVf_ROK| \
			 SVp_IOK|SVp_NOK|SVp_POK)

#define SVf_AMAGIC	0x10000000      /* has magical overloaded methods */

#define PRIVSHIFT 8	/* (SVp_?OK >> PRIVSHIFT) == SVf_?OK */

/* Some private flags. */

/* SVpad_OUR may be set on SVt_PV{NV,MG,GV} types */
#define SVpad_OUR	0x80000000	/* pad name is "our" instead of "my" */
#define SVpad_TYPED	0x40000000	/* Typed Lexical */

#define SVf_IVisUV	0x80000000	/* use XPVUV instead of XPVIV */

#define SVpfm_COMPILED	0x80000000	/* FORMLINE is compiled */

#define SVpbm_VALID	0x80000000
#define SVpbm_TAIL	0x40000000

#define SVrepl_EVAL	0x40000000	/* Replacement part of s///e */

#define SVphv_CLONEABLE	0x08000000	/* for stashes: clone its objects */
#define SVphv_REHASH	0x10000000	/* HV is recalculating hash values */
#define SVphv_SHAREKEYS 0x20000000	/* keys live on shared string table */
#define SVphv_LAZYDEL	0x40000000	/* entry in xhv_eiter must be deleted */
#define SVphv_HASKFLAGS	0x80000000	/* keys have flag byte after hash */

#define SVprv_WEAKREF   0x80000000      /* Weak reference */

struct xrv {
    SV *	xrv_rv;		/* pointer to another SV */
};

struct xpv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
};

struct xpviv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
};

struct xpvuv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    UV		xuv_uv;		/* unsigned value or pv offset */
};

struct xpvnv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV    	xnv_nv;		/* numeric value, if any */
};

/* These structure must match the beginning of struct xpvhv in hv.h. */
struct xpvmg {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV    	xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */
};

struct xpvlv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV    	xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */

    STRLEN	xlv_targoff;
    STRLEN	xlv_targlen;
    SV*		xlv_targ;
    char	xlv_type;	/* k=keys .=pos x=substr v=vec /=join/re
				 * y=alem/helem/iter t=tie T=tied HE */
};

struct xpvgv {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV		xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */

    GP*		xgv_gp;
    char*	xgv_name;
    STRLEN	xgv_namelen;
    HV*		xgv_stash;
    U8		xgv_flags;
};

struct xpvbm {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV		xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */

    I32		xbm_useful;	/* is this constant pattern being useful? */
    U16		xbm_previous;	/* how many characters in string before rare? */
    U8		xbm_rare;	/* rarest character in string */
};

/* This structure must match XPVCV in cv.h */

typedef U16 cv_flags_t;

struct xpvfm {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV		xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */

    HV *	xcv_stash;
    OP *	xcv_start;
    OP *	xcv_root;
    void      (*xcv_xsub)(pTHX_ CV*);
    ANY		xcv_xsubany;
    GV *	xcv_gv;
    char *	xcv_file;
    long	xcv_depth;	/* >= 2 indicates recursive call */
    AV *	xcv_padlist;
    CV *	xcv_outside;
#ifdef USE_5005THREADS
    perl_mutex *xcv_mutexp;	/* protects xcv_owner */
    struct perl_thread *xcv_owner;	/* current owner thread */
#endif /* USE_5005THREADS */
    cv_flags_t	xcv_flags;
    U32		xcv_outside_seq; /* the COP sequence (at the point of our
				  * compilation) in the lexically enclosing
				  * sub */
    IV		xfm_lines;
};

struct xpvio {
    char *	xpv_pv;		/* pointer to malloced string */
    STRLEN	xpv_cur;	/* length of xpv_pv as a C string */
    STRLEN	xpv_len;	/* allocated size */
    IV		xiv_iv;		/* integer value or pv offset */
    NV		xnv_nv;		/* numeric value, if any */
    MAGIC*	xmg_magic;	/* linked list of magicalness */
    HV*		xmg_stash;	/* class package */

    PerlIO *	xio_ifp;	/* ifp and ofp are normally the same */
    PerlIO *	xio_ofp;	/* but sockets need separate streams */
    /* Cray addresses everything by word boundaries (64 bits) and
     * code and data pointers cannot be mixed (which is exactly what
     * Perl_filter_add() tries to do with the dirp), hence the following
     * union trick (as suggested by Gurusamy Sarathy).
     * For further information see Geir Johansen's problem report titled
       [ID 20000612.002] Perl problem on Cray system
     * The any pointer (known as IoANY()) will also be a good place
     * to hang any IO disciplines to.
     */
    union {
	DIR *	xiou_dirp;	/* for opendir, readdir, etc */
	void *	xiou_any;	/* for alignment */
    } xio_dirpu;
    IV		xio_lines;	/* $. */
    IV		xio_page;	/* $% */
    IV		xio_page_len;	/* $= */
    IV		xio_lines_left;	/* $- */
    char *	xio_top_name;	/* $^ */
    GV *	xio_top_gv;	/* $^ */
    char *	xio_fmt_name;	/* $~ */
    GV *	xio_fmt_gv;	/* $~ */
    char *	xio_bottom_name;/* $^B */
    GV *	xio_bottom_gv;	/* $^B */
    short	xio_subprocess;	/* -| or |- */
    char	xio_type;
    char	xio_flags;
};
#define xio_dirp	xio_dirpu.xiou_dirp
#define xio_any		xio_dirpu.xiou_any

#define IOf_ARGV	1	/* this fp iterates over ARGV */
#define IOf_START	2	/* check for null ARGV and substitute '-' */
#define IOf_FLUSH	4	/* this fp wants a flush after write op */
#define IOf_DIDTOP	8	/* just did top of form */
#define IOf_UNTAINT	16	/* consider this fp (and its data) "safe" */
#define IOf_NOLINE	32	/* slurped a pseudo-line from empty file */
#define IOf_FAKE_DIRP	64	/* xio_dirp is fake (source filters kludge) */

/* The following macros define implementation-independent predicates on SVs. */

/*
=for apidoc Am|bool|SvNIOK|SV* sv
Returns a boolean indicating whether the SV contains a number, integer or
double.

=for apidoc Am|bool|SvNIOKp|SV* sv
Returns a boolean indicating whether the SV contains a number, integer or
double.  Checks the B<private> setting.  Use C<SvNIOK>.

=for apidoc Am|void|SvNIOK_off|SV* sv
Unsets the NV/IV status of an SV.

=for apidoc Am|bool|SvOK|SV* sv
Returns a boolean indicating whether the value is an SV. It also tells
whether the value is defined or not.

=for apidoc Am|bool|SvIOKp|SV* sv
Returns a boolean indicating whether the SV contains an integer.  Checks
the B<private> setting.  Use C<SvIOK>.

=for apidoc Am|bool|SvNOKp|SV* sv
Returns a boolean indicating whether the SV contains a double.  Checks the
B<private> setting.  Use C<SvNOK>.

=for apidoc Am|bool|SvPOKp|SV* sv
Returns a boolean indicating whether the SV contains a character string.
Checks the B<private> setting.  Use C<SvPOK>.

=for apidoc Am|bool|SvIOK|SV* sv
Returns a boolean indicating whether the SV contains an integer.

=for apidoc Am|void|SvIOK_on|SV* sv
Tells an SV that it is an integer.

=for apidoc Am|void|SvIOK_off|SV* sv
Unsets the IV status of an SV.

=for apidoc Am|void|SvIOK_only|SV* sv
Tells an SV that it is an integer and disables all other OK bits.

=for apidoc Am|void|SvIOK_only_UV|SV* sv
Tells and SV that it is an unsigned integer and disables all other OK bits.

=for apidoc Am|bool|SvIOK_UV|SV* sv
Returns a boolean indicating whether the SV contains an unsigned integer.

=for apidoc Am|void|SvUOK|SV* sv
Returns a boolean indicating whether the SV contains an unsigned integer.

=for apidoc Am|bool|SvIOK_notUV|SV* sv
Returns a boolean indicating whether the SV contains a signed integer.

=for apidoc Am|bool|SvNOK|SV* sv
Returns a boolean indicating whether the SV contains a double.

=for apidoc Am|void|SvNOK_on|SV* sv
Tells an SV that it is a double.

=for apidoc Am|void|SvNOK_off|SV* sv
Unsets the NV status of an SV.

=for apidoc Am|void|SvNOK_only|SV* sv
Tells an SV that it is a double and disables all other OK bits.

=for apidoc Am|bool|SvPOK|SV* sv
Returns a boolean indicating whether the SV contains a character
string.

=for apidoc Am|void|SvPOK_on|SV* sv
Tells an SV that it is a string.

=for apidoc Am|void|SvPOK_off|SV* sv
Unsets the PV status of an SV.

=for apidoc Am|void|SvPOK_only|SV* sv
Tells an SV that it is a string and disables all other OK bits.
Will also turn off the UTF-8 status.

=for apidoc Am|bool|SvOOK|SV* sv
Returns a boolean indicating whether the SvIVX is a valid offset value for
the SvPVX.  This hack is used internally to speed up removal of characters
from the beginning of a SvPV.  When SvOOK is true, then the start of the
allocated string buffer is really (SvPVX - SvIVX).

=for apidoc Am|bool|SvROK|SV* sv
Tests if the SV is an RV.

=for apidoc Am|void|SvROK_on|SV* sv
Tells an SV that it is an RV.

=for apidoc Am|void|SvROK_off|SV* sv
Unsets the RV status of an SV.

=for apidoc Am|SV*|SvRV|SV* sv
Dereferences an RV to return the SV.

=for apidoc Am|IV|SvIVX|SV* sv
Returns the raw value in the SV's IV slot, without checks or conversions.
Only use when you are sure SvIOK is true. See also C<SvIV()>.

=for apidoc Am|UV|SvUVX|SV* sv
Returns the raw value in the SV's UV slot, without checks or conversions.
Only use when you are sure SvIOK is true. See also C<SvUV()>.

=for apidoc Am|NV|SvNVX|SV* sv
Returns the raw value in the SV's NV slot, without checks or conversions.
Only use when you are sure SvNOK is true. See also C<SvNV()>.

=for apidoc Am|char*|SvPVX|SV* sv
Returns a pointer to the physical string in the SV.  The SV must contain a
string.

=for apidoc Am|STRLEN|SvCUR|SV* sv
Returns the length of the string which is in the SV.  See C<SvLEN>.

=for apidoc Am|STRLEN|SvLEN|SV* sv
Returns the size of the string buffer in the SV, not including any part
attributable to C<SvOOK>.  See C<SvCUR>.

=for apidoc Am|char*|SvEND|SV* sv
Returns a pointer to the last character in the string which is in the SV.
See C<SvCUR>.  Access the character as *(SvEND(sv)).

=for apidoc Am|HV*|SvSTASH|SV* sv
Returns the stash of the SV.

=for apidoc Am|void|SvIV_set|SV* sv|IV val
Set the value of the IV pointer in sv to val.  It is possible to perform
the same function of this macro with an lvalue assignment to C<SvIVX>.
With future Perls, however, it will be more efficient to use 
C<SvIV_set> instead of the lvalue assignment to C<SvIVX>.

=for apidoc Am|void|SvNV_set|SV* sv|NV val
Set the value of the NV pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvPV_set|SV* sv|char* val
Set the value of the PV pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvUV_set|SV* sv|UV val
Set the value of the UV pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvRV_set|SV* sv|SV* val
Set the value of the RV pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvMAGIC_set|SV* sv|MAGIC* val
Set the value of the MAGIC pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvSTASH_set|SV* sv|STASH* val
Set the value of the STASH pointer in sv to val.  See C<SvIV_set>.

=for apidoc Am|void|SvCUR_set|SV* sv|STRLEN len
Set the current length of the string which is in the SV.  See C<SvCUR>
and C<SvIV_set>.

=for apidoc Am|void|SvLEN_set|SV* sv|STRLEN len
Set the actual length of the string which is in the SV.  See C<SvIV_set>.

=cut
*/

#define SvNIOK(sv)		(SvFLAGS(sv) & (SVf_IOK|SVf_NOK))
#define SvNIOKp(sv)		(SvFLAGS(sv) & (SVp_IOK|SVp_NOK))
#define SvNIOK_off(sv)		(SvFLAGS(sv) &= ~(SVf_IOK|SVf_NOK| \
						  SVp_IOK|SVp_NOK|SVf_IVisUV))

#if defined(__GNUC__) && !defined(PERL_GCC_BRACE_GROUPS_FORBIDDEN)
#define assert_not_ROK(sv)	({assert(!SvROK(sv) || !SvRV(sv));}),
#else
#define assert_not_ROK(sv)	
#endif

#define SvOK(sv)		(SvFLAGS(sv) & SVf_OK)
#define SvOK_off(sv)		(assert_not_ROK(sv)			\
				 SvFLAGS(sv) &=	~(SVf_OK|SVf_AMAGIC|	\
						  SVf_IVisUV|SVf_UTF8),	\
							SvOOK_off(sv))
#define SvOK_off_exc_UV(sv)	(assert_not_ROK(sv)			\
				 SvFLAGS(sv) &=	~(SVf_OK|SVf_AMAGIC|	\
						  SVf_UTF8),		\
							SvOOK_off(sv))

#define SvOKp(sv)		(SvFLAGS(sv) & (SVp_IOK|SVp_NOK|SVp_POK))
#define SvIOKp(sv)		(SvFLAGS(sv) & SVp_IOK)
#define SvIOKp_on(sv)		((void)SvOOK_off(sv), SvFLAGS(sv) |= SVp_IOK)
#define SvNOKp(sv)		(SvFLAGS(sv) & SVp_NOK)
#define SvNOKp_on(sv)		(SvFLAGS(sv) |= SVp_NOK)
#define SvPOKp(sv)		(SvFLAGS(sv) & SVp_POK)
#define SvPOKp_on(sv)		(assert_not_ROK(sv)			\
				 SvFLAGS(sv) |= SVp_POK)

#define SvIOK(sv)		(SvFLAGS(sv) & SVf_IOK)
#define SvIOK_on(sv)		((void)SvOOK_off(sv), \
				    SvFLAGS(sv) |= (SVf_IOK|SVp_IOK))
#define SvIOK_off(sv)		(SvFLAGS(sv) &= ~(SVf_IOK|SVp_IOK|SVf_IVisUV))
#define SvIOK_only(sv)		(SvOK_off(sv), \
				    SvFLAGS(sv) |= (SVf_IOK|SVp_IOK))
#define SvIOK_only_UV(sv)	(SvOK_off_exc_UV(sv), \
				    SvFLAGS(sv) |= (SVf_IOK|SVp_IOK))

#define SvIOK_UV(sv)		((SvFLAGS(sv) & (SVf_IOK|SVf_IVisUV))	\
				 == (SVf_IOK|SVf_IVisUV))
#define SvUOK(sv)		SvIOK_UV(sv)
#define SvIOK_notUV(sv)		((SvFLAGS(sv) & (SVf_IOK|SVf_IVisUV))	\
				 == SVf_IOK)

#define SvVOK(sv)		(SvMAGICAL(sv) && mg_find(sv,'V'))
#define SvIsUV(sv)		(SvFLAGS(sv) & SVf_IVisUV)
#define SvIsUV_on(sv)		(SvFLAGS(sv) |= SVf_IVisUV)
#define SvIsUV_off(sv)		(SvFLAGS(sv) &= ~SVf_IVisUV)

#define SvNOK(sv)		(SvFLAGS(sv) & SVf_NOK)
#define SvNOK_on(sv)		(SvFLAGS(sv) |= (SVf_NOK|SVp_NOK))
#define SvNOK_off(sv)		(SvFLAGS(sv) &= ~(SVf_NOK|SVp_NOK))
#define SvNOK_only(sv)		(SvOK_off(sv), \
				    SvFLAGS(sv) |= (SVf_NOK|SVp_NOK))

/*
=for apidoc Am|bool|SvUTF8|SV* sv
Returns a boolean indicating whether the SV contains UTF-8 encoded data.

=for apidoc Am|void|SvUTF8_on|SV *sv
Turn on the UTF-8 status of an SV (the data is not changed, just the flag).
Do not use frivolously.

=for apidoc Am|void|SvUTF8_off|SV *sv
Unsets the UTF-8 status of an SV.

=for apidoc Am|void|SvPOK_only_UTF8|SV* sv
Tells an SV that it is a string and disables all other OK bits,
and leaves the UTF-8 status as it was.

=cut
 */

#define SvUTF8(sv)		(SvFLAGS(sv) & SVf_UTF8)
#define SvUTF8_on(sv)		(SvFLAGS(sv) |= (SVf_UTF8))
#define SvUTF8_off(sv)		(SvFLAGS(sv) &= ~(SVf_UTF8))

#define SvPOK(sv)		(SvFLAGS(sv) & SVf_POK)
#define SvPOK_on(sv)		(assert_not_ROK(sv)			\
				 SvFLAGS(sv) |= (SVf_POK|SVp_POK))
#define SvPOK_off(sv)		(SvFLAGS(sv) &= ~(SVf_POK|SVp_POK))
#define SvPOK_only(sv)		(assert_not_ROK(sv)			\
				 SvFLAGS(sv) &= ~(SVf_OK|SVf_AMAGIC|	\
						  SVf_IVisUV|SVf_UTF8),	\
				    SvFLAGS(sv) |= (SVf_POK|SVp_POK))
#define SvPOK_only_UTF8(sv)	(assert_not_ROK(sv)			\
				 SvFLAGS(sv) &= ~(SVf_OK|SVf_AMAGIC|	\
						  SVf_IVisUV),		\
				    SvFLAGS(sv) |= (SVf_POK|SVp_POK))

#define SvOOK(sv)		(SvFLAGS(sv) & SVf_OOK)
#define SvOOK_on(sv)		((void)SvIOK_off(sv), SvFLAGS(sv) |= SVf_OOK)
#define SvOOK_off(sv)		((void)(SvOOK(sv) && sv_backoff(sv)))

#define SvFAKE(sv)		(SvFLAGS(sv) & SVf_FAKE)
#define SvFAKE_on(sv)		(SvFLAGS(sv) |= SVf_FAKE)
#define SvFAKE_off(sv)		(SvFLAGS(sv) &= ~SVf_FAKE)

#define SvROK(sv)		(SvFLAGS(sv) & SVf_ROK)
#define SvROK_on(sv)		(SvFLAGS(sv) |= SVf_ROK)
#define SvROK_off(sv)		(SvFLAGS(sv) &= ~(SVf_ROK|SVf_AMAGIC))

#define SvMAGICAL(sv)		(SvFLAGS(sv) & (SVs_GMG|SVs_SMG|SVs_RMG))
#define SvMAGICAL_on(sv)	(SvFLAGS(sv) |= (SVs_GMG|SVs_SMG|SVs_RMG))
#define SvMAGICAL_off(sv)	(SvFLAGS(sv) &= ~(SVs_GMG|SVs_SMG|SVs_RMG))

#define SvGMAGICAL(sv)		(SvFLAGS(sv) & SVs_GMG)
#define SvGMAGICAL_on(sv)	(SvFLAGS(sv) |= SVs_GMG)
#define SvGMAGICAL_off(sv)	(SvFLAGS(sv) &= ~SVs_GMG)

#define SvSMAGICAL(sv)		(SvFLAGS(sv) & SVs_SMG)
#define SvSMAGICAL_on(sv)	(SvFLAGS(sv) |= SVs_SMG)
#define SvSMAGICAL_off(sv)	(SvFLAGS(sv) &= ~SVs_SMG)

#define SvRMAGICAL(sv)		(SvFLAGS(sv) & SVs_RMG)
#define SvRMAGICAL_on(sv)	(SvFLAGS(sv) |= SVs_RMG)
#define SvRMAGICAL_off(sv)	(SvFLAGS(sv) &= ~SVs_RMG)

#define SvAMAGIC(sv)		(SvFLAGS(sv) & SVf_AMAGIC)
#define SvAMAGIC_on(sv)		(SvFLAGS(sv) |= SVf_AMAGIC)
#define SvAMAGIC_off(sv)	(SvFLAGS(sv) &= ~SVf_AMAGIC)

#define SvGAMAGIC(sv)           (SvFLAGS(sv) & (SVs_GMG|SVf_AMAGIC))

/*
#define Gv_AMG(stash) \
        (HV_AMAGICmb(stash) && \
         ((!HV_AMAGICbad(stash) && HV_AMAGIC(stash)) || Gv_AMupdate(stash)))
*/
#define Gv_AMG(stash)           (PL_amagic_generation && Gv_AMupdate(stash))

#define SvWEAKREF(sv)		((SvFLAGS(sv) & (SVf_ROK|SVprv_WEAKREF)) \
				  == (SVf_ROK|SVprv_WEAKREF))
#define SvWEAKREF_on(sv)	(SvFLAGS(sv) |=  (SVf_ROK|SVprv_WEAKREF))
#define SvWEAKREF_off(sv)	(SvFLAGS(sv) &= ~(SVf_ROK|SVprv_WEAKREF))

#define SvTHINKFIRST(sv)	(SvFLAGS(sv) & SVf_THINKFIRST)

#define SvPADBUSY(sv)		(SvFLAGS(sv) & SVs_PADBUSY)

#define SvPADTMP(sv)		(SvFLAGS(sv) & SVs_PADTMP)
#define SvPADTMP_on(sv)		(SvFLAGS(sv) |= SVs_PADTMP|SVs_PADBUSY)
#define SvPADTMP_off(sv)	(SvFLAGS(sv) &= ~SVs_PADTMP)

#define SvPADMY(sv)		(SvFLAGS(sv) & SVs_PADMY)
#define SvPADMY_on(sv)		(SvFLAGS(sv) |= SVs_PADMY|SVs_PADBUSY)

#define SvTEMP(sv)		(SvFLAGS(sv) & SVs_TEMP)
#define SvTEMP_on(sv)		(SvFLAGS(sv) |= SVs_TEMP)
#define SvTEMP_off(sv)		(SvFLAGS(sv) &= ~SVs_TEMP)

#define SvOBJECT(sv)		(SvFLAGS(sv) & SVs_OBJECT)
#define SvOBJECT_on(sv)		(SvFLAGS(sv) |= SVs_OBJECT)
#define SvOBJECT_off(sv)	(SvFLAGS(sv) &= ~SVs_OBJECT)

#define SvREADONLY(sv)		(SvFLAGS(sv) & SVf_READONLY)
#define SvREADONLY_on(sv)	(SvFLAGS(sv) |= SVf_READONLY)
#define SvREADONLY_off(sv)	(SvFLAGS(sv) &= ~SVf_READONLY)

#define SvSCREAM(sv)		(SvFLAGS(sv) & SVp_SCREAM)
#define SvSCREAM_on(sv)		(SvFLAGS(sv) |= SVp_SCREAM)
#define SvSCREAM_off(sv)	(SvFLAGS(sv) &= ~SVp_SCREAM)

#define SvCOMPILED(sv)		(SvFLAGS(sv) & SVpfm_COMPILED)
#define SvCOMPILED_on(sv)	(SvFLAGS(sv) |= SVpfm_COMPILED)
#define SvCOMPILED_off(sv)	(SvFLAGS(sv) &= ~SVpfm_COMPILED)

#define SvEVALED(sv)		(SvFLAGS(sv) & SVrepl_EVAL)
#define SvEVALED_on(sv)		(SvFLAGS(sv) |= SVrepl_EVAL)
#define SvEVALED_off(sv)	(SvFLAGS(sv) &= ~SVrepl_EVAL)

#define SvTAIL(sv)		(SvFLAGS(sv) & SVpbm_TAIL)
#define SvTAIL_on(sv)		(SvFLAGS(sv) |= SVpbm_TAIL)
#define SvTAIL_off(sv)		(SvFLAGS(sv) &= ~SVpbm_TAIL)

#define SvVALID(sv)		(SvFLAGS(sv) & SVpbm_VALID)
#define SvVALID_on(sv)		(SvFLAGS(sv) |= SVpbm_VALID)
#define SvVALID_off(sv)		(SvFLAGS(sv) &= ~SVpbm_VALID)

#ifdef USE_ITHREADS
/* The following uses the FAKE flag to show that a regex pointer is infact
   its own offset in the regexpad for ithreads */
#define SvREPADTMP(sv)		(SvFLAGS(sv) & SVf_FAKE)
#define SvREPADTMP_on(sv)	(SvFLAGS(sv) |= SVf_FAKE)
#define SvREPADTMP_off(sv)	(SvFLAGS(sv) &= ~SVf_FAKE)
#endif

#define SvRV(sv) ((XRV*)  SvANY(sv))->xrv_rv
#define SvRVx(sv) SvRV(sv)

#define SvIVX(sv) ((XPVIV*)  SvANY(sv))->xiv_iv
#define SvUVX(sv) ((XPVUV*)  SvANY(sv))->xuv_uv
#define SvNVX(sv)  ((XPVNV*)SvANY(sv))->xnv_nv
#define SvPVX(sv)  ((XPV*)  SvANY(sv))->xpv_pv
/* Given that these two are new, there can't be any existing code using them
 *  as LVALUEs  */
#define SvPVX_mutable(sv)	(0 + SvPVX(sv))
#define SvPVX_const(sv)	((const char*) (0 + SvPVX(sv)))
#define SvCUR(sv) ((XPV*)  SvANY(sv))->xpv_cur
#define SvLEN(sv) ((XPV*)  SvANY(sv))->xpv_len
#define SvEND(sv)(((XPV*)  SvANY(sv))->xpv_pv + ((XPV*)SvANY(sv))->xpv_cur)

#define SvIVXx(sv) SvIVX(sv)
#define SvUVXx(sv) SvUVX(sv)
#define SvNVXx(sv) SvNVX(sv)
#define SvPVXx(sv) SvPVX(sv)
#define SvLENx(sv) SvLEN(sv)
#define SvENDx(sv) ((PL_Sv = (sv)), SvEND(PL_Sv))
#define SvMAGIC(sv)	((XPVMG*)  SvANY(sv))->xmg_magic
#define SvSTASH(sv)	((XPVMG*)  SvANY(sv))->xmg_stash

/* Ask a scalar nicely to try to become an IV, if possible.
   Not guaranteed to stay returning void */
/* Macro won't actually call sv_2iv if already IOK */
#define SvIV_please(sv) \
	STMT_START {if (!SvIOKp(sv) && (SvNOK(sv) || SvPOK(sv))) \
		(void) SvIV(sv); } STMT_END
/* Put the asserts back at some point and figure out where they reveal bugs
*/
#define SvIV_set(sv, val) \
	STMT_START { assert(SvTYPE(sv) == SVt_IV || SvTYPE(sv) >= SVt_PVIV); \
		(((XPVIV*)  SvANY(sv))->xiv_iv = (val)); } STMT_END
#define SvNV_set(sv, val) \
	STMT_START { assert(SvTYPE(sv) == SVt_NV || SvTYPE(sv) >= SVt_PVNV); \
		(((XPVNV*)SvANY(sv))->xnv_nv = (val)); } STMT_END
/* assert(SvTYPE(sv) >= SVt_PV); */
#define SvPV_set(sv, val) \
	STMT_START { \
		(((XPV*)  SvANY(sv))->xpv_pv = (val)); } STMT_END
/* assert(SvTYPE(sv) == SVt_IV || SvTYPE(sv) >= SVt_PVIV); */
#define SvUV_set(sv, val) \
	STMT_START { \
		(((XPVUV*)SvANY(sv))->xuv_uv = (val)); } STMT_END
/* assert(SvTYPE(sv) >=  SVt_RV); */
#define SvRV_set(sv, val) \
        STMT_START { \
                (((XRV*)SvANY(sv))->xrv_rv = (val)); } STMT_END
/* assert(SvTYPE(sv) >= SVt_PVMG); */
#define SvMAGIC_set(sv, val) \
        STMT_START {  \
                (((XPVMG*)SvANY(sv))->xmg_magic = (val)); } STMT_END
/* assert(SvTYPE(sv) >= SVt_PVMG); */
#define SvSTASH_set(sv, val) \
        STMT_START { \
                (((XPVMG*)  SvANY(sv))->xmg_stash = (val)); } STMT_END
/* assert(SvTYPE(sv) >= SVt_PV); */
#define SvCUR_set(sv, val) \
	STMT_START { \
		(((XPV*)  SvANY(sv))->xpv_cur = (val)); } STMT_END
/* assert(SvTYPE(sv) >= SVt_PV); */
#define SvLEN_set(sv, val) \
	STMT_START { \
		(((XPV*)  SvANY(sv))->xpv_len = (val)); } STMT_END
#define SvEND_set(sv, val) \
	STMT_START { assert(SvTYPE(sv) >= SVt_PV); \
		(SvCUR(sv) = (val) - SvPVX(sv)); } STMT_END

#define SvPV_renew(sv,n) \
	STMT_START { SvLEN_set(sv, n); \
		SvPV_set((sv), (MEM_WRAP_CHECK_(n,char)			\
				(char*)saferealloc((Malloc_t)SvPVX(sv), \
						   (MEM_SIZE)((n)))));  \
		 } STMT_END

#define SvPV_shrink_to_cur(sv) STMT_START { \
		   const STRLEN _lEnGtH = SvCUR(sv) + 1; \
		   SvPV_renew(sv, _lEnGtH); \
		 } STMT_END

#define SvPV_free(sv) \
	STMT_START { assert(SvTYPE(sv) >= SVt_PV);	\
		if (SvLEN(sv)) {			\
		    if(SvOOK(sv)) {			\
		      Safefree(SvPVX(sv) - SvIVX(sv));	\
		      SvFLAGS(sv) &= ~SVf_OOK;		\
		    } else {				\
		      Safefree(SvPVX(sv));		\
		    }					\
		}					\
	} STMT_END

#define BmRARE(sv)	((XPVBM*)  SvANY(sv))->xbm_rare
#define BmUSEFUL(sv)	((XPVBM*)  SvANY(sv))->xbm_useful
#define BmPREVIOUS(sv)	((XPVBM*)  SvANY(sv))->xbm_previous

#define FmLINES(sv)	((XPVFM*)  SvANY(sv))->xfm_lines

#define LvTYPE(sv)	((XPVLV*)  SvANY(sv))->xlv_type
#define LvTARG(sv)	((XPVLV*)  SvANY(sv))->xlv_targ
#define LvTARGOFF(sv)	((XPVLV*)  SvANY(sv))->xlv_targoff
#define LvTARGLEN(sv)	((XPVLV*)  SvANY(sv))->xlv_targlen

#define IoIFP(sv)	((XPVIO*)  SvANY(sv))->xio_ifp
#define IoOFP(sv)	((XPVIO*)  SvANY(sv))->xio_ofp
#define IoDIRP(sv)	((XPVIO*)  SvANY(sv))->xio_dirp
#define IoANY(sv)	((XPVIO*)  SvANY(sv))->xio_any
#define IoLINES(sv)	((XPVIO*)  SvANY(sv))->xio_lines
#define IoPAGE(sv)	((XPVIO*)  SvANY(sv))->xio_page
#define IoPAGE_LEN(sv)	((XPVIO*)  SvANY(sv))->xio_page_len
#define IoLINES_LEFT(sv)((XPVIO*)  SvANY(sv))->xio_lines_left
#define IoTOP_NAME(sv)	((XPVIO*)  SvANY(sv))->xio_top_name
#define IoTOP_GV(sv)	((XPVIO*)  SvANY(sv))->xio_top_gv
#define IoFMT_NAME(sv)	((XPVIO*)  SvANY(sv))->xio_fmt_name
#define IoFMT_GV(sv)	((XPVIO*)  SvANY(sv))->xio_fmt_gv
#define IoBOTTOM_NAME(sv)((XPVIO*) SvANY(sv))->xio_bottom_name
#define IoBOTTOM_GV(sv)	((XPVIO*)  SvANY(sv))->xio_bottom_gv
#define IoSUBPROCESS(sv)((XPVIO*)  SvANY(sv))->xio_subprocess
#define IoTYPE(sv)	((XPVIO*)  SvANY(sv))->xio_type
#define IoFLAGS(sv)	((XPVIO*)  SvANY(sv))->xio_flags

/* IoTYPE(sv) is a single character telling the type of I/O connection. */
#define IoTYPE_RDONLY		'<'
#define IoTYPE_WRONLY		'>'
#define IoTYPE_RDWR		'+'
#define IoTYPE_APPEND 		'a'
#define IoTYPE_PIPE		'|'
#define IoTYPE_STD		'-'	/* stdin or stdout */
#define IoTYPE_SOCKET		's'
#define IoTYPE_CLOSED		' '
#define IoTYPE_IMPLICIT		'I'	/* stdin or stdout or stderr */
#define IoTYPE_NUMERIC		'#'	/* fdopen */

/*
=for apidoc Am|bool|SvTAINTED|SV* sv
Checks to see if an SV is tainted. Returns TRUE if it is, FALSE if
not.

=for apidoc Am|void|SvTAINTED_on|SV* sv
Marks an SV as tainted if tainting is enabled.

=for apidoc Am|void|SvTAINTED_off|SV* sv
Untaints an SV. Be I<very> careful with this routine, as it short-circuits
some of Perl's fundamental security features. XS module authors should not
use this function unless they fully understand all the implications of
unconditionally untainting the value. Untainting should be done in the
standard perl fashion, via a carefully crafted regexp, rather than directly
untainting variables.

=for apidoc Am|void|SvTAINT|SV* sv
Taints an SV if tainting is enabled.

=cut
*/

#define SvTAINTED(sv)	  (SvMAGICAL(sv) && sv_tainted(sv))
#define SvTAINTED_on(sv)  STMT_START{ if(PL_tainting){sv_taint(sv);}   }STMT_END
#define SvTAINTED_off(sv) STMT_START{ if(PL_tainting){sv_untaint(sv);} }STMT_END

#define SvTAINT(sv)			\
    STMT_START {			\
	if (PL_tainting) {		\
	    if (PL_tainted)		\
		SvTAINTED_on(sv);	\
	}				\
    } STMT_END

/*
=for apidoc Am|char*|SvPV_force|SV* sv|STRLEN len
Like C<SvPV> but will force the SV into containing just a string
(C<SvPOK_only>).  You want force if you are going to update the C<SvPVX>
directly.

=for apidoc Am|char*|SvPV_force_nomg|SV* sv|STRLEN len
Like C<SvPV> but will force the SV into containing just a string
(C<SvPOK_only>).  You want force if you are going to update the C<SvPVX>
directly. Doesn't process magic.

=for apidoc Am|char*|SvPV|SV* sv|STRLEN len
Returns a pointer to the string in the SV, or a stringified form of
the SV if the SV does not contain a string.  The SV may cache the
stringified version becoming C<SvPOK>.  Handles 'get' magic. See also
C<SvPVx> for a version which guarantees to evaluate sv only once.

=for apidoc Am|char*|SvPVx|SV* sv|STRLEN len
A version of C<SvPV> which guarantees to evaluate sv only once.

=for apidoc Am|char*|SvPV_nolen|SV* sv
Returns a pointer to the string in the SV, or a stringified form of
the SV if the SV does not contain a string.  The SV may cache the
stringified form becoming C<SvPOK>.  Handles 'get' magic.

=for apidoc Am|IV|SvIV|SV* sv
Coerces the given SV to an integer and returns it. See  C<SvIVx> for a
version which guarantees to evaluate sv only once.

=for apidoc Am|IV|SvIVx|SV* sv
Coerces the given SV to an integer and returns it. Guarantees to evaluate
sv only once. Use the more efficient C<SvIV> otherwise.

=for apidoc Am|NV|SvNV|SV* sv
Coerce the given SV to a double and return it. See  C<SvNVx> for a version
which guarantees to evaluate sv only once.

=for apidoc Am|NV|SvNVx|SV* sv
Coerces the given SV to a double and returns it. Guarantees to evaluate
sv only once. Use the more efficient C<SvNV> otherwise.

=for apidoc Am|UV|SvUV|SV* sv
Coerces the given SV to an unsigned integer and returns it.  See C<SvUVx>
for a version which guarantees to evaluate sv only once.

=for apidoc Am|UV|SvUVx|SV* sv
Coerces the given SV to an unsigned integer and returns it. Guarantees to
evaluate sv only once. Use the more efficient C<SvUV> otherwise.

=for apidoc Am|bool|SvTRUE|SV* sv
Returns a boolean indicating whether Perl would evaluate the SV as true or
false, defined or undefined.  Does not handle 'get' magic.

=for apidoc Am|char*|SvPVutf8_force|SV* sv|STRLEN len
Like C<SvPV_force>, but converts sv to utf8 first if necessary.

=for apidoc Am|char*|SvPVutf8|SV* sv|STRLEN len
Like C<SvPV>, but converts sv to utf8 first if necessary.

=for apidoc Am|char*|SvPVutf8_nolen|SV* sv
Like C<SvPV_nolen>, but converts sv to utf8 first if necessary.

=for apidoc Am|char*|SvPVbyte_force|SV* sv|STRLEN len
Like C<SvPV_force>, but converts sv to byte representation first if necessary.

=for apidoc Am|char*|SvPVbyte|SV* sv|STRLEN len
Like C<SvPV>, but converts sv to byte representation first if necessary.

=for apidoc Am|char*|SvPVbyte_nolen|SV* sv
Like C<SvPV_nolen>, but converts sv to byte representation first if necessary.

=for apidoc Am|char*|SvPVutf8x_force|SV* sv|STRLEN len
Like C<SvPV_force>, but converts sv to utf8 first if necessary.
Guarantees to evaluate sv only once; use the more efficient C<SvPVutf8_force>
otherwise.

=for apidoc Am|char*|SvPVutf8x|SV* sv|STRLEN len
Like C<SvPV>, but converts sv to utf8 first if necessary.
Guarantees to evaluate sv only once; use the more efficient C<SvPVutf8>
otherwise.

=for apidoc Am|char*|SvPVbytex_force|SV* sv|STRLEN len
Like C<SvPV_force>, but converts sv to byte representation first if necessary.
Guarantees to evaluate sv only once; use the more efficient C<SvPVbyte_force>
otherwise.

=for apidoc Am|char*|SvPVbytex|SV* sv|STRLEN len
Like C<SvPV>, but converts sv to byte representation first if necessary.
Guarantees to evaluate sv only once; use the more efficient C<SvPVbyte>
otherwise.

=for apidoc Am|bool|SvIsCOW|SV* sv
Returns a boolean indicating whether the SV is Copy-On-Write. (either shared
hash key scalars, or full Copy On Write scalars if 5.9.0 is configured for
COW)

=for apidoc Am|bool|SvIsCOW_shared_hash|SV* sv
Returns a boolean indicating whether the SV is Copy-On-Write shared hash key
scalar.

=for apidoc Am|void|sv_catpvn_nomg|SV* sv|const char* ptr|STRLEN len
Like C<sv_catpvn> but doesn't process magic.

=for apidoc Am|void|sv_setsv_nomg|SV* dsv|SV* ssv
Like C<sv_setsv> but doesn't process magic.

=for apidoc Am|void|sv_catsv_nomg|SV* dsv|SV* ssv
Like C<sv_catsv> but doesn't process magic.

=cut
*/

/* Let us hope that bitmaps for UV and IV are the same */
#define SvIV(sv) (SvIOK(sv) ? SvIVX(sv) : sv_2iv(sv))
#define SvUV(sv) (SvIOK(sv) ? SvUVX(sv) : sv_2uv(sv))
#define SvNV(sv) (SvNOK(sv) ? SvNVX(sv) : sv_2nv(sv))

/* ----*/

#define SvPV(sv, lp) SvPV_flags(sv, lp, SV_GMAGIC)
#define SvPV_const(sv, lp) SvPV_flags_const(sv, lp, SV_GMAGIC)
#define SvPV_mutable(sv, lp) SvPV_flags_mutable(sv, lp, SV_GMAGIC)

#define SvPV_flags(sv, lp, flags) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_2pv_flags(sv, &lp, flags))
#define SvPV_flags_const(sv, lp, flags) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? ((lp = SvCUR(sv)), SvPVX_const(sv)) : \
     (const char*) sv_2pv_flags(sv, &lp, flags|SV_CONST_RETURN))
#define SvPV_flags_const_nolen(sv, flags) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? SvPVX_const(sv) : \
     (const char*) sv_2pv_flags(sv, 0, flags|SV_CONST_RETURN))
#define SvPV_flags_mutable(sv, lp, flags) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? ((lp = SvCUR(sv)), SvPVX_mutable(sv)) : \
     sv_2pv_flags(sv, &lp, flags|SV_MUTABLE_RETURN))

#define SvPV_force(sv, lp) SvPV_force_flags(sv, lp, SV_GMAGIC)
#define SvPV_force_nolen(sv) SvPV_force_flags_nolen(sv, SV_GMAGIC)
#define SvPV_force_mutable(sv, lp) SvPV_force_flags_mutable(sv, lp, SV_GMAGIC)

#define SvPV_force_nomg(sv, lp) SvPV_force_flags(sv, lp, 0)
#define SvPV_force_nomg_nolen(sv) SvPV_force_flags_nolen(sv, 0)

#define SvPV_force_flags(sv, lp, flags) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_THINKFIRST)) == SVf_POK \
    ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_pvn_force_flags(sv, &lp, flags))
#define SvPV_force_flags_nolen(sv, flags) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_THINKFIRST)) == SVf_POK \
    ? SvPVX(sv) : sv_pvn_force_flags(sv, 0, flags))
#define SvPV_force_flags_mutable(sv, lp, flags) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_THINKFIRST)) == SVf_POK \
    ? ((lp = SvCUR(sv)), SvPVX_mutable(sv)) \
     : sv_pvn_force_flags(sv, &lp, flags|SV_MUTABLE_RETURN))

#define SvPV_nolen(sv) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? SvPVX(sv) : sv_2pv_flags(sv, 0, SV_GMAGIC))

#define SvPV_nolen_const(sv) \
    ((SvFLAGS(sv) & (SVf_POK)) == SVf_POK \
     ? SvPVX_const(sv) : sv_2pv_flags(sv, 0, SV_GMAGIC|SV_CONST_RETURN))

#define SvPV_nomg(sv, lp) SvPV_flags(sv, lp, 0)
#define SvPV_nomg_const(sv, lp) SvPV_flags_const(sv, lp, 0)
#define SvPV_nomg_const_nolen(sv) SvPV_flags_const_nolen(sv, 0)

/* ----*/

#define SvPVutf8(sv, lp) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_UTF8)) == (SVf_POK|SVf_UTF8) \
     ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_2pvutf8(sv, &lp))

#define SvPVutf8_force(sv, lp) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_THINKFIRST)) == (SVf_POK|SVf_UTF8) \
     ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_pvutf8n_force(sv, &lp))


#define SvPVutf8_nolen(sv) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_UTF8)) == (SVf_POK|SVf_UTF8)\
     ? SvPVX(sv) : sv_2pvutf8(sv, 0))

/* ----*/

#define SvPVbyte(sv, lp) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_UTF8)) == (SVf_POK) \
     ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_2pvbyte(sv, &lp))

#define SvPVbyte_force(sv, lp) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_UTF8|SVf_THINKFIRST)) == (SVf_POK) \
     ? ((lp = SvCUR(sv)), SvPVX(sv)) : sv_pvbyten_force(sv, &lp))

#define SvPVbyte_nolen(sv) \
    ((SvFLAGS(sv) & (SVf_POK|SVf_UTF8)) == (SVf_POK)\
     ? SvPVX(sv) : sv_2pvbyte(sv, 0))


    
/* define FOOx(): idempotent versions of FOO(). If possible, use a local
 * var to evaluate the arg once; failing that, use a global if possible;
 * failing that, call a function to do the work
 */

#define SvPVx_force(sv, lp) sv_pvn_force(sv, &lp)
#define SvPVutf8x_force(sv, lp) sv_pvutf8n_force(sv, &lp)
#define SvPVbytex_force(sv, lp) sv_pvbyten_force(sv, &lp)

#if defined(__GNUC__) && !defined(PERL_GCC_BRACE_GROUPS_FORBIDDEN)

#  define SvIVx(sv) ({SV *_sv = (SV*)(sv); SvIV(_sv); })
#  define SvUVx(sv) ({SV *_sv = (SV*)(sv); SvUV(_sv); })
#  define SvNVx(sv) ({SV *_sv = (SV*)(sv); SvNV(_sv); })
#  define SvPVx(sv, lp) ({SV *_sv = (sv); SvPV(_sv, lp); })
#  define SvPVx_const(sv, lp) ({SV *_sv = (sv); SvPV_const(_sv, lp); })
#  define SvPVx_nolen(sv) ({SV *_sv = (sv); SvPV_nolen(_sv); })
#  define SvPVx_nolen_const(sv) ({SV *_sv = (sv); SvPV_nolen_const(_sv); })
#  define SvPVutf8x(sv, lp) ({SV *_sv = (sv); SvPVutf8(_sv, lp); })
#  define SvPVbytex(sv, lp) ({SV *_sv = (sv); SvPVbyte(_sv, lp); })
#  define SvPVbytex_nolen(sv) ({SV *_sv = (sv); SvPVbyte_nolen(_sv); })
#  define SvTRUE(sv) (						\
    !sv								\
    ? 0								\
    :    SvPOK(sv)						\
	?   (({XPV *nxpv = (XPV*)SvANY(sv);			\
	     nxpv &&						\
	     (nxpv->xpv_cur > 1 ||				\
	      (nxpv->xpv_cur && *nxpv->xpv_pv != '0')); })	\
	     ? 1						\
	     : 0)						\
	:							\
	    SvIOK(sv)						\
	    ? SvIVX(sv) != 0					\
	    :   SvNOK(sv)					\
		? SvNVX(sv) != 0.0				\
		: sv_2bool(sv) )
#  define SvTRUEx(sv) ({SV *_sv = (sv); SvTRUE(_sv); })

#else /* __GNUC__ */

#  ifdef USE_5005THREADS
#    define SvIVx(sv) sv_iv(sv)
#    define SvUVx(sv) sv_uv(sv)
#    define SvNVx(sv) sv_nv(sv)
#    define SvPVx(sv, lp) sv_pvn(sv, &lp)
#    define SvPVutf8x(sv, lp) sv_pvutf8n(sv, &lp)
#    define SvPVbytex(sv, lp) sv_pvbyten(sv, &lp)
#    define SvTRUE(sv) SvTRUEx(sv)
#    define SvTRUEx(sv) sv_true(sv)

#  else /* USE_5005THREADS */

/* These inlined macros use globals, which will require a thread
 * declaration in user code, so we avoid them under threads */

#    define SvIVx(sv) ((PL_Sv = (sv)), SvIV(PL_Sv))
#    define SvUVx(sv) ((PL_Sv = (sv)), SvUV(PL_Sv))
#    define SvNVx(sv) ((PL_Sv = (sv)), SvNV(PL_Sv))
#    define SvPVx(sv, lp) ((PL_Sv = (sv)), SvPV(PL_Sv, lp))
#    define SvPVx_const(sv, lp) ((PL_Sv = (sv)), SvPV_const(PL_Sv, lp))
#    define SvPVx_nolen(sv) ((PL_Sv = (sv)), SvPV_nolen(PL_Sv))
#    define SvPVx_nolen_const(sv) ((PL_Sv = (sv)), SvPV_nolen_const(PL_Sv))
#    define SvPVutf8x(sv, lp) ((PL_Sv = (sv)), SvPVutf8(PL_Sv, lp))
#    define SvPVbytex(sv, lp) ((PL_Sv = (sv)), SvPVbyte(PL_Sv, lp))
#    define SvPVbytex_nolen(sv) ((PL_Sv = (sv)), SvPVbyte_nolen(PL_Sv))
#    define SvTRUE(sv) (						\
    !sv								\
    ? 0								\
    :    SvPOK(sv)						\
	?   ((PL_Xpv = (XPV*)SvANY(sv)) &&			\
	     (PL_Xpv->xpv_cur > 1 ||				\
	      (PL_Xpv->xpv_cur && *PL_Xpv->xpv_pv != '0'))	\
	     ? 1						\
	     : 0)						\
	:							\
	    SvIOK(sv)						\
	    ? SvIVX(sv) != 0					\
	    :   SvNOK(sv)					\
		? SvNVX(sv) != 0.0				\
		: sv_2bool(sv) )
#    define SvTRUEx(sv) ((PL_Sv = (sv)), SvTRUE(PL_Sv))
#  endif /* USE_5005THREADS */
#endif /* __GNU__ */

#define SvIsCOW(sv)		((SvFLAGS(sv) & (SVf_FAKE | SVf_READONLY)) == \
				    (SVf_FAKE | SVf_READONLY))
#define SvIsCOW_shared_hash(sv)	(SvIsCOW(sv) && SvLEN(sv) == 0)

#define SvSHARED_HASH(sv) (0 + SvUVX(sv))

/* flag values for sv_*_flags functions */
#define SV_IMMEDIATE_UNREF	1
#define SV_GMAGIC		2
#define SV_COW_DROP_PV		4	/* Unused in Perl 5.8.x */
#define SV_UTF8_NO_ENCODING	8
#define SV_NOSTEAL		16
#define SV_CONST_RETURN		32
#define SV_MUTABLE_RETURN	64

/* all these 'functions' are now just macros */

#define sv_pv(sv) SvPV_nolen(sv)
#define sv_pvutf8(sv) SvPVutf8_nolen(sv)
#define sv_pvbyte(sv) SvPVbyte_nolen(sv)

#define sv_pvn_force_nomg(sv, lp) sv_pvn_force_flags(sv, lp, 0)
#define sv_utf8_upgrade_nomg(sv) sv_utf8_upgrade_flags(sv, 0)
#define sv_catpvn_nomg(dsv, sstr, slen) sv_catpvn_flags(dsv, sstr, slen, 0)
#define sv_setsv(dsv, ssv) sv_setsv_flags(dsv, ssv, SV_GMAGIC)
#define sv_setsv_nomg(dsv, ssv) sv_setsv_flags(dsv, ssv, 0)
#define sv_catsv(dsv, ssv) sv_catsv_flags(dsv, ssv, SV_GMAGIC)
#define sv_catsv_nomg(dsv, ssv) sv_catsv_flags(dsv, ssv, 0)
#define sv_catpvn(dsv, sstr, slen) sv_catpvn_flags(dsv, sstr, slen, SV_GMAGIC)
#define sv_2pv(sv, lp) sv_2pv_flags(sv, lp, SV_GMAGIC)
#define sv_2pv_nomg(sv, lp) sv_2pv_flags(sv, lp, 0)
#define sv_pvn_force(sv, lp) sv_pvn_force_flags(sv, lp, SV_GMAGIC)
#define sv_utf8_upgrade(sv) sv_utf8_upgrade_flags(sv, SV_GMAGIC)

/* Should be named SvCatPVN_utf8_upgrade? */
#define sv_catpvn_utf8_upgrade(dsv, sstr, slen, nsv)	\
	STMT_START {					\
	    if (!(nsv))					\
		nsv = sv_2mortal(newSVpvn(sstr, slen));	\
	    else					\
		sv_setpvn(nsv, sstr, slen);		\
	    SvUTF8_off(nsv);				\
	    sv_utf8_upgrade(nsv);			\
	    sv_catsv(dsv, nsv);	\
	} STMT_END

/*
=for apidoc Am|SV*|newRV_inc|SV* sv

Creates an RV wrapper for an SV.  The reference count for the original SV is
incremented.

=cut
*/

#define newRV_inc(sv)	newRV(sv)

/* the following macros update any magic values this sv is associated with */

/*
=head1 Magical Functions

=for apidoc Am|void|SvGETMAGIC|SV* sv
Invokes C<mg_get> on an SV if it has 'get' magic.  This macro evaluates its
argument more than once.

=for apidoc Am|void|SvSETMAGIC|SV* sv
Invokes C<mg_set> on an SV if it has 'set' magic.  This macro evaluates its
argument more than once.

=for apidoc Am|void|SvSetSV|SV* dsb|SV* ssv
Calls C<sv_setsv> if dsv is not the same as ssv.  May evaluate arguments
more than once.

=for apidoc Am|void|SvSetSV_nosteal|SV* dsv|SV* ssv
Calls a non-destructive version of C<sv_setsv> if dsv is not the same as
ssv. May evaluate arguments more than once.

=for apidoc Am|void|SvSetMagicSV|SV* dsb|SV* ssv
Like C<SvSetSV>, but does any set magic required afterwards.

=for apidoc Am|void|SvSetMagicSV_nosteal|SV* dsv|SV* ssv
Like C<SvSetSV_nosteal>, but does any set magic required afterwards.

=for apidoc Am|void|SvSHARE|SV* sv
Arranges for sv to be shared between threads if a suitable module
has been loaded.

=for apidoc Am|void|SvLOCK|SV* sv
Arranges for a mutual exclusion lock to be obtained on sv if a suitable module
has been loaded.

=for apidoc Am|void|SvUNLOCK|SV* sv
Releases a mutual exclusion lock on sv if a suitable module
has been loaded.

=head1 SV Manipulation Functions

=for apidoc Am|char *|SvGROW|SV* sv|STRLEN len
Expands the character buffer in the SV so that it has room for the
indicated number of bytes (remember to reserve space for an extra trailing
NUL character).  Calls C<sv_grow> to perform the expansion if necessary.
Returns a pointer to the character buffer.

=cut
*/

#define SvSHARE(sv) CALL_FPTR(PL_sharehook)(aTHX_ sv)
#define SvLOCK(sv) CALL_FPTR(PL_lockhook)(aTHX_ sv)
#define SvUNLOCK(sv) CALL_FPTR(PL_unlockhook)(aTHX_ sv)

#define SvGETMAGIC(x) STMT_START { if (SvGMAGICAL(x)) mg_get(x); } STMT_END
#define SvSETMAGIC(x) STMT_START { if (SvSMAGICAL(x)) mg_set(x); } STMT_END

#define SvSetSV_and(dst,src,finally) \
	STMT_START {					\
	    if ((dst) != (src)) {			\
		sv_setsv(dst, src);			\
		finally;				\
	    }						\
	} STMT_END
#define SvSetSV_nosteal_and(dst,src,finally) \
	STMT_START {					\
	    if ((dst) != (src)) {			\
		sv_setsv_flags(dst, src, SV_GMAGIC | SV_NOSTEAL);	\
		finally;				\
	    }						\
	} STMT_END

#define SvSetSV(dst,src) \
		SvSetSV_and(dst,src,/*nothing*/;)
#define SvSetSV_nosteal(dst,src) \
		SvSetSV_nosteal_and(dst,src,/*nothing*/;)

#define SvSetMagicSV(dst,src) \
		SvSetSV_and(dst,src,SvSETMAGIC(dst))
#define SvSetMagicSV_nosteal(dst,src) \
		SvSetSV_nosteal_and(dst,src,SvSETMAGIC(dst))


#if !defined(SKIP_DEBUGGING)
#define SvPEEK(sv) sv_peek(sv)
#else
#define SvPEEK(sv) ""
#endif

#define SvIMMORTAL(sv) ((sv)==&PL_sv_undef || (sv)==&PL_sv_yes || (sv)==&PL_sv_no || (sv)==&PL_sv_placeholder)

#define boolSV(b) ((b) ? &PL_sv_yes : &PL_sv_no)

#define isGV(sv) (SvTYPE(sv) == SVt_PVGV)

#define SvGROW(sv,len) (SvLEN(sv) < (len) ? sv_grow(sv,len) : SvPVX(sv))
#define SvGROW_mutable(sv,len) \
    (SvLEN(sv) < (len) ? sv_grow(sv,len) : SvPVX_mutable(sv))
#define Sv_Grow sv_grow

#define CLONEf_COPY_STACKS 1
#define CLONEf_KEEP_PTR_TABLE 2
#define CLONEf_CLONE_HOST 4
#define CLONEf_JOIN_IN 8

struct clone_params {
  AV* stashes;
  UV  flags;
  PerlInterpreter *proto_perl;
};

#define SV_CHECK_THINKFIRST(sv) if (SvTHINKFIRST(sv)) sv_force_normal(sv)
