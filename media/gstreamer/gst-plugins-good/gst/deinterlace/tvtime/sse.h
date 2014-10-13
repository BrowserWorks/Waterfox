/*	sse.h

	Streaming SIMD Extenstions (a.k.a. Katmai New Instructions)
	GCC interface library for IA32.

	To use this library, simply include this header file
	and compile with GCC.  You MUST have inlining enabled
	in order for sse_ok() to work; this can be done by
	simply using -O on the GCC command line.

	Compiling with -DSSE_TRACE will cause detailed trace
	output to be sent to stderr for each sse operation.
	This adds lots of code, and obviously slows execution to
	a crawl, but can be very useful for debugging.

	THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY
	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT
	LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY
	AND FITNESS FOR ANY PARTICULAR PURPOSE.

	1999 by R. Fisher
	Based on libmmx by H. Dietz and R. Fisher

 Notes:
	This is still extremely alpha.
	Because this library depends on an assembler which understands the
	 SSE opcodes, you probably won't be able to use this yet.
	For now, do not use TRACE versions.  These both make use
	 of the MMX registers, not the SSE registers.  This will be resolved
	 at a later date.
 ToDo:
	Rewrite TRACE macros
	Major Debugging Work
*/

#ifndef _SSE_H
#define _SSE_H



/*	The type of an value that fits in an SSE register
	(note that long long constant values MUST be suffixed
	 by LL and unsigned long long values by ULL, lest
	 they be truncated by the compiler)
*/
typedef	union {
	float			sf[4];	/* Single-precision (32-bit) value */
} __attribute__ ((aligned (16))) sse_t;	/* On a 16 byte (128-bit) boundary */


#if 0
/*	Function to test if multimedia instructions are supported...
*/
inline extern int
mm_support(void)
{
	/* Returns 1 if MMX instructions are supported,
	   3 if Cyrix MMX and Extended MMX instructions are supported
	   5 if AMD MMX and 3DNow! instructions are supported
	   9 if MMX and SSE instructions are supported
	   0 if hardware does not support any of these
	*/
	register int rval = 0;

	__asm__ __volatile__ (
		/* See if CPUID instruction is supported ... */
		/* ... Get copies of EFLAGS into eax and ecx */
		"pushf\n\t"
		"popl %%eax\n\t"
		"movl %%eax, %%ecx\n\t"

		/* ... Toggle the ID bit in one copy and store */
		/*     to the EFLAGS reg */
		"xorl $0x200000, %%eax\n\t"
		"push %%eax\n\t"
		"popf\n\t"

		/* ... Get the (hopefully modified) EFLAGS */
		"pushf\n\t"
		"popl %%eax\n\t"

		/* ... Compare and test result */
		"xorl %%eax, %%ecx\n\t"
		"testl $0x200000, %%ecx\n\t"
		"jz NotSupported1\n\t"		/* CPUID not supported */


		/* Get standard CPUID information, and
		       go to a specific vendor section */
		"movl $0, %%eax\n\t"
		"cpuid\n\t"

		/* Check for Intel */
		"cmpl $0x756e6547, %%ebx\n\t"
		"jne TryAMD\n\t"
		"cmpl $0x49656e69, %%edx\n\t"
		"jne TryAMD\n\t"
		"cmpl $0x6c65746e, %%ecx\n"
		"jne TryAMD\n\t"
		"jmp Intel\n\t"

		/* Check for AMD */
		"\nTryAMD:\n\t"
		"cmpl $0x68747541, %%ebx\n\t"
		"jne TryCyrix\n\t"
		"cmpl $0x69746e65, %%edx\n\t"
		"jne TryCyrix\n\t"
		"cmpl $0x444d4163, %%ecx\n"
		"jne TryCyrix\n\t"
		"jmp AMD\n\t"

		/* Check for Cyrix */
		"\nTryCyrix:\n\t"
		"cmpl $0x69727943, %%ebx\n\t"
		"jne NotSupported2\n\t"
		"cmpl $0x736e4978, %%edx\n\t"
		"jne NotSupported3\n\t"
		"cmpl $0x64616574, %%ecx\n\t"
		"jne NotSupported4\n\t"
		/* Drop through to Cyrix... */


		/* Cyrix Section */
		/* See if extended CPUID level 80000001 is supported */
		/* The value of CPUID/80000001 for the 6x86MX is undefined
		   according to the Cyrix CPU Detection Guide (Preliminary
		   Rev. 1.01 table 1), so we'll check the value of eax for
		   CPUID/0 to see if standard CPUID level 2 is supported.
		   According to the table, the only CPU which supports level
		   2 is also the only one which supports extended CPUID levels.
		*/
		"cmpl $0x2, %%eax\n\t"
		"jne MMXtest\n\t"	/* Use standard CPUID instead */

		/* Extended CPUID supported (in theory), so get extended
		   features */
		"movl $0x80000001, %%eax\n\t"
		"cpuid\n\t"
		"testl $0x00800000, %%eax\n\t"	/* Test for MMX */
		"jz NotSupported5\n\t"		/* MMX not supported */
		"testl $0x01000000, %%eax\n\t"	/* Test for Ext'd MMX */
		"jnz EMMXSupported\n\t"
		"movl $1, %0:\n\n\t"		/* MMX Supported */
		"jmp Return\n\n"
		"EMMXSupported:\n\t"
		"movl $3, %0:\n\n\t"		/* EMMX and MMX Supported */
		"jmp Return\n\t"


		/* AMD Section */
		"AMD:\n\t"

		/* See if extended CPUID is supported */
		"movl $0x80000000, %%eax\n\t"
		"cpuid\n\t"
		"cmpl $0x80000000, %%eax\n\t"
		"jl MMXtest\n\t"	/* Use standard CPUID instead */

		/* Extended CPUID supported, so get extended features */
		"movl $0x80000001, %%eax\n\t"
		"cpuid\n\t"
		"testl $0x00800000, %%edx\n\t"	/* Test for MMX */
		"jz NotSupported6\n\t"		/* MMX not supported */
		"testl $0x80000000, %%edx\n\t"	/* Test for 3DNow! */
		"jnz ThreeDNowSupported\n\t"
		"movl $1, %0:\n\n\t"		/* MMX Supported */
		"jmp Return\n\n"
		"ThreeDNowSupported:\n\t"
		"movl $5, %0:\n\n\t"		/* 3DNow! and MMX Supported */
		"jmp Return\n\t"


		/* Intel Section */
		"Intel:\n\t"

		/* Check for SSE */
		"SSEtest:\n\t"
		"movl $1, %%eax\n\t"
		"cpuid\n\t"
		"testl $0x02000000, %%edx\n\t"	/* Test for SSE */
		"jz MMXtest\n\t"		/* SSE Not supported */
		"movl $9, %0:\n\n\t"		/* SSE Supported */
		"jmp Return\n\t"

		/* Check for MMX */
		"MMXtest:\n\t"
		"movl $1, %%eax\n\t"
		"cpuid\n\t"
		"testl $0x00800000, %%edx\n\t"	/* Test for MMX */
		"jz NotSupported7\n\t"		/* MMX Not supported */
		"movl $1, %0:\n\n\t"		/* MMX Supported */
		"jmp Return\n\t"

		/* Nothing supported */
		"\nNotSupported1:\n\t"
		"#movl $101, %0:\n\n\t"
		"\nNotSupported2:\n\t"
		"#movl $102, %0:\n\n\t"
		"\nNotSupported3:\n\t"
		"#movl $103, %0:\n\n\t"
		"\nNotSupported4:\n\t"
		"#movl $104, %0:\n\n\t"
		"\nNotSupported5:\n\t"
		"#movl $105, %0:\n\n\t"
		"\nNotSupported6:\n\t"
		"#movl $106, %0:\n\n\t"
		"\nNotSupported7:\n\t"
		"#movl $107, %0:\n\n\t"
		"movl $0, %0:\n\n\t"

		"Return:\n\t"
		: "=a" (rval)
		: /* no input */
		: "eax", "ebx", "ecx", "edx"
	);

	/* Return */
	return(rval);
}

/*	Function to test if sse instructions are supported...
*/
inline extern int
sse_ok(void)
{
	/* Returns 1 if SSE instructions are supported, 0 otherwise */
	return ( (mm_support() & 0x8) >> 3  );
}
#endif



/*	Helper functions for the instruction macros that follow...
	(note that memory-to-register, m2r, instructions are nearly
	 as efficient as register-to-register, r2r, instructions;
	 however, memory-to-memory instructions are really simulated
	 as a convenience, and are only 1/3 as efficient)
*/
#ifdef	SSE_TRACE

/*	Include the stuff for printing a trace to stderr...
*/

#include <stdio.h>

#define	sse_i2r(op, imm, reg) \
	{ \
		sse_t sse_trace; \
		sse_trace.uq = (imm); \
		fprintf(stderr, #op "_i2r(" #imm "=0x%08x%08x, ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ ("movq %%" #reg ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #reg "=0x%08x%08x) => ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ (#op " %0, %%" #reg \
				      : /* nothing */ \
				      : "X" (imm)); \
		__asm__ __volatile__ ("movq %%" #reg ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #reg "=0x%08x%08x\n", \
			sse_trace.d[1], sse_trace.d[0]); \
	}

#define	sse_m2r(op, mem, reg) \
	{ \
		sse_t sse_trace; \
		sse_trace = (mem); \
		fprintf(stderr, #op "_m2r(" #mem "=0x%08x%08x, ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ ("movq %%" #reg ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #reg "=0x%08x%08x) => ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ (#op " %0, %%" #reg \
				      : /* nothing */ \
				      : "X" (mem)); \
		__asm__ __volatile__ ("movq %%" #reg ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #reg "=0x%08x%08x\n", \
			sse_trace.d[1], sse_trace.d[0]); \
	}

#define	sse_r2m(op, reg, mem) \
	{ \
		sse_t sse_trace; \
		__asm__ __volatile__ ("movq %%" #reg ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #op "_r2m(" #reg "=0x%08x%08x, ", \
			sse_trace.d[1], sse_trace.d[0]); \
		sse_trace = (mem); \
		fprintf(stderr, #mem "=0x%08x%08x) => ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ (#op " %%" #reg ", %0" \
				      : "=X" (mem) \
				      : /* nothing */ ); \
		sse_trace = (mem); \
		fprintf(stderr, #mem "=0x%08x%08x\n", \
			sse_trace.d[1], sse_trace.d[0]); \
	}

#define	sse_r2r(op, regs, regd) \
	{ \
		sse_t sse_trace; \
		__asm__ __volatile__ ("movq %%" #regs ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #op "_r2r(" #regs "=0x%08x%08x, ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ ("movq %%" #regd ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #regd "=0x%08x%08x) => ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ (#op " %" #regs ", %" #regd); \
		__asm__ __volatile__ ("movq %%" #regd ", %0" \
				      : "=X" (sse_trace) \
				      : /* nothing */ ); \
		fprintf(stderr, #regd "=0x%08x%08x\n", \
			sse_trace.d[1], sse_trace.d[0]); \
	}

#define	sse_m2m(op, mems, memd) \
	{ \
		sse_t sse_trace; \
		sse_trace = (mems); \
		fprintf(stderr, #op "_m2m(" #mems "=0x%08x%08x, ", \
			sse_trace.d[1], sse_trace.d[0]); \
		sse_trace = (memd); \
		fprintf(stderr, #memd "=0x%08x%08x) => ", \
			sse_trace.d[1], sse_trace.d[0]); \
		__asm__ __volatile__ ("movq %0, %%mm0\n\t" \
				      #op " %1, %%mm0\n\t" \
				      "movq %%mm0, %0" \
				      : "=X" (memd) \
				      : "X" (mems)); \
		sse_trace = (memd); \
		fprintf(stderr, #memd "=0x%08x%08x\n", \
			sse_trace.d[1], sse_trace.d[0]); \
	}

#else

/*	These macros are a lot simpler without the tracing...
*/

#define	sse_i2r(op, imm, reg) \
	__asm__ __volatile__ (#op " %0, %%" #reg \
			      : /* nothing */ \
			      : "X" (imm) )

#define	sse_m2r(op, mem, reg) \
	__asm__ __volatile__ (#op " %0, %%" #reg \
			      : /* nothing */ \
			      : "X" (mem))

#define	sse_r2m(op, reg, mem) \
	__asm__ __volatile__ (#op " %%" #reg ", %0" \
			      : "=X" (mem) \
			      : /* nothing */ )

#define	sse_r2r(op, regs, regd) \
	__asm__ __volatile__ (#op " %" #regs ", %" #regd)

#define	sse_r2ri(op, regs, regd, imm) \
	__asm__ __volatile__ (#op " %0, %%" #regs ", %%" #regd \
			      : /* nothing */ \
			      : "X" (imm) )

/* Load data from mems to xmmreg, operate on xmmreg, and store data to memd */
#define	sse_m2m(op, mems, memd, xmmreg) \
	__asm__ __volatile__ ("movups %0, %%xmm0\n\t" \
			      #op " %1, %%xmm0\n\t" \
			      "movups %%mm0, %0" \
			      : "=X" (memd) \
			      : "X" (mems))

#define	sse_m2ri(op, mem, reg, subop) \
	__asm__ __volatile__ (#op " %0, %%" #reg ", " #subop \
			      : /* nothing */ \
			      : "X" (mem))

#define	sse_m2mi(op, mems, memd, xmmreg, subop) \
	__asm__ __volatile__ ("movups %0, %%xmm0\n\t" \
			      #op " %1, %%xmm0, " #subop "\n\t" \
			      "movups %%mm0, %0" \
			      : "=X" (memd) \
			      : "X" (mems))
#endif




/*	1x128 MOVe Aligned four Packed Single-fp
*/
#define	movaps_m2r(var, reg)	sse_m2r(movaps, var, reg)
#define	movaps_r2m(reg, var)	sse_r2m(movaps, reg, var)
#define	movaps_r2r(regs, regd)	sse_r2r(movaps, regs, regd)
#define	movaps(vars, vard) \
	__asm__ __volatile__ ("movaps %1, %%mm0\n\t" \
			      "movaps %%mm0, %0" \
			      : "=X" (vard) \
			      : "X" (vars))


/*	1x128 MOVe aligned Non-Temporal four Packed Single-fp
*/
#define	movntps_r2m(xmmreg, var)	sse_r2m(movntps, xmmreg, var)


/*	1x64 MOVe Non-Temporal Quadword
*/
#define	movntq_r2m(mmreg, var)		sse_r2m(movntq, mmreg, var)


/*	1x128 MOVe Unaligned four Packed Single-fp
*/
#define	movups_m2r(var, reg)	sse_m2r(movups, var, reg)
#define	movups_r2m(reg, var)	sse_r2m(movups, reg, var)
#define	movups_r2r(regs, regd)	sse_r2r(movups, regs, regd)
#define	movups(vars, vard) \
	__asm__ __volatile__ ("movups %1, %%mm0\n\t" \
			      "movups %%mm0, %0" \
			      : "=X" (vard) \
			      : "X" (vars))


/*	MOVe High to Low Packed Single-fp
	high half of 4x32f (x) -> low half of 4x32f (y)
*/
#define	movhlps_r2r(regs, regd)	sse_r2r(movhlps, regs, regd)


/*	MOVe Low to High Packed Single-fp
	low half of 4x32f (x) -> high half of 4x32f (y)
*/
#define	movlhps_r2r(regs, regd)	sse_r2r(movlhps, regs, regd)


/*	MOVe High Packed Single-fp
	2x32f -> high half of 4x32f
*/
#define	movhps_m2r(var, reg)	sse_m2r(movhps, var, reg)
#define	movhps_r2m(reg, var)	sse_r2m(movhps, reg, var)
#define	movhps(vars, vard) \
	__asm__ __volatile__ ("movhps %1, %%mm0\n\t" \
			      "movhps %%mm0, %0" \
			      : "=X" (vard) \
			      : "X" (vars))


/*	MOVe Low Packed Single-fp
	2x32f -> low half of 4x32f
*/
#define	movlps_m2r(var, reg)	sse_m2r(movlps, var, reg)
#define	movlps_r2m(reg, var)	sse_r2m(movlps, reg, var)
#define	movlps(vars, vard) \
	__asm__ __volatile__ ("movlps %1, %%mm0\n\t" \
			      "movlps %%mm0, %0" \
			      : "=X" (vard) \
			      : "X" (vars))


/*	MOVe Scalar Single-fp
	lowest field of 4x32f (x) -> lowest field of 4x32f (y)
*/
#define	movss_m2r(var, reg)	sse_m2r(movss, var, reg)
#define	movss_r2m(reg, var)	sse_r2m(movss, reg, var)
#define	movss_r2r(regs, regd)	sse_r2r(movss, regs, regd)
#define	movss(vars, vard) \
	__asm__ __volatile__ ("movss %1, %%mm0\n\t" \
			      "movss %%mm0, %0" \
			      : "=X" (vard) \
			      : "X" (vars))


/*	4x16 Packed SHUFfle Word
*/
#define	pshufw_m2r(var, reg, index)	sse_m2ri(pshufw, var, reg, index)
#define	pshufw_r2r(regs, regd, index)	sse_r2ri(pshufw, regs, regd, index)


/*	1x128 SHUFfle Packed Single-fp
*/
#define	shufps_m2r(var, reg, index)	sse_m2ri(shufps, var, reg, index)
#define	shufps_r2r(regs, regd, index)	sse_r2ri(shufps, regs, regd, index)


/*	ConVerT Packed signed Int32 to(2) Packed Single-fp
*/
#define	cvtpi2ps_m2r(var, xmmreg)	sse_m2r(cvtpi2ps, var, xmmreg)
#define	cvtpi2ps_r2r(mmreg, xmmreg)	sse_r2r(cvtpi2ps, mmreg, xmmreg)


/*	ConVerT Packed Single-fp to(2) Packed signed Int32
*/
#define	cvtps2pi_m2r(var, mmreg)	sse_m2r(cvtps2pi, var, mmreg)
#define	cvtps2pi_r2r(xmmreg, mmreg)	sse_r2r(cvtps2pi, mmreg, xmmreg)


/*	ConVerT with Truncate Packed Single-fp to(2) Packed Int32
*/
#define	cvttps2pi_m2r(var, mmreg)	sse_m2r(cvttps2pi, var, mmreg)
#define	cvttps2pi_r2r(xmmreg, mmreg)	sse_r2r(cvttps2pi, mmreg, xmmreg)


/*	ConVerT Signed Int32 to(2) Single-fp (Scalar)
*/
#define	cvtsi2ss_m2r(var, xmmreg)	sse_m2r(cvtsi2ss, var, xmmreg)
#define	cvtsi2ss_r2r(reg, xmmreg)	sse_r2r(cvtsi2ss, reg, xmmreg)


/*	ConVerT Scalar Single-fp to(2) Signed Int32
*/
#define	cvtss2si_m2r(var, reg)		sse_m2r(cvtss2si, var, reg)
#define	cvtss2si_r2r(xmmreg, reg)	sse_r2r(cvtss2si, xmmreg, reg)


/*	ConVerT with Truncate Scalar Single-fp to(2) Signed Int32
*/
#define	cvttss2si_m2r(var, reg)		sse_m2r(cvtss2si, var, reg)
#define	cvttss2si_r2r(xmmreg, reg)	sse_r2r(cvtss2si, xmmreg, reg)


/*	Parallel EXTRact Word from 4x16
*/
#define	pextrw_r2r(mmreg, reg, field)	sse_r2ri(pextrw, mmreg, reg, field)


/*	Parallel INSeRt Word from 4x16
*/
#define	pinsrw_r2r(reg, mmreg, field)	sse_r2ri(pinsrw, reg, mmreg, field)



/*	MOVe MaSK from Packed Single-fp
*/
#ifdef	SSE_TRACE
	#define	movmskps(xmmreg, reg) \
	{ \
		fprintf(stderr, "movmskps()\n"); \
		__asm__ __volatile__ ("movmskps %" #xmmreg ", %" #reg) \
	}
#else
	#define	movmskps(xmmreg, reg) \
	__asm__ __volatile__ ("movmskps %" #xmmreg ", %" #reg)
#endif


/*	Parallel MOVe MaSK from mmx reg to 32-bit reg
*/
#ifdef	SSE_TRACE
	#define	pmovmskb(mmreg, reg) \
	{ \
		fprintf(stderr, "movmskps()\n"); \
		__asm__ __volatile__ ("movmskps %" #mmreg ", %" #reg) \
	}
#else
	#define	pmovmskb(mmreg, reg) \
	__asm__ __volatile__ ("movmskps %" #mmreg ", %" #reg)
#endif


/*	MASKed MOVe from 8x8 to memory pointed to by (e)di register
*/
#define	maskmovq(mmregs, fieldreg)	sse_r2ri(maskmovq, mmregs, fieldreg)




/*	4x32f Parallel ADDs
*/
#define	addps_m2r(var, reg)		sse_m2r(addps, var, reg)
#define	addps_r2r(regs, regd)		sse_r2r(addps, regs, regd)
#define	addps(vars, vard, xmmreg)	sse_m2m(addps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel ADDs
*/
#define	addss_m2r(var, reg)		sse_m2r(addss, var, reg)
#define	addss_r2r(regs, regd)		sse_r2r(addss, regs, regd)
#define	addss(vars, vard, xmmreg)	sse_m2m(addss, vars, vard, xmmreg)


/*	4x32f Parallel SUBs
*/
#define	subps_m2r(var, reg)		sse_m2r(subps, var, reg)
#define	subps_r2r(regs, regd)		sse_r2r(subps, regs, regd)
#define	subps(vars, vard, xmmreg)	sse_m2m(subps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel SUBs
*/
#define	subss_m2r(var, reg)		sse_m2r(subss, var, reg)
#define	subss_r2r(regs, regd)		sse_r2r(subss, regs, regd)
#define	subss(vars, vard, xmmreg)	sse_m2m(subss, vars, vard, xmmreg)


/*	8x8u -> 4x16u Packed Sum of Absolute Differences
*/
#define	psadbw_m2r(var, reg)		sse_m2r(psadbw, var, reg)
#define	psadbw_r2r(regs, regd)		sse_r2r(psadbw, regs, regd)
#define	psadbw(vars, vard, mmreg)	sse_m2m(psadbw, vars, vard, mmreg)


/*	4x16u Parallel MUL High Unsigned
*/
#define	pmulhuw_m2r(var, reg)		sse_m2r(pmulhuw, var, reg)
#define	pmulhuw_r2r(regs, regd)		sse_r2r(pmulhuw, regs, regd)
#define	pmulhuw(vars, vard, mmreg)	sse_m2m(pmulhuw, vars, vard, mmreg)


/*	4x32f Parallel MULs
*/
#define	mulps_m2r(var, reg)		sse_m2r(mulps, var, reg)
#define	mulps_r2r(regs, regd)		sse_r2r(mulps, regs, regd)
#define	mulps(vars, vard, xmmreg)	sse_m2m(mulps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel MULs
*/
#define	mulss_m2r(var, reg)		sse_m2r(mulss, var, reg)
#define	mulss_r2r(regs, regd)		sse_r2r(mulss, regs, regd)
#define	mulss(vars, vard, xmmreg)	sse_m2m(mulss, vars, vard, xmmreg)


/*	4x32f Parallel DIVs
*/
#define	divps_m2r(var, reg)		sse_m2r(divps, var, reg)
#define	divps_r2r(regs, regd)		sse_r2r(divps, regs, regd)
#define	divps(vars, vard, xmmreg)	sse_m2m(divps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel DIVs
*/
#define	divss_m2r(var, reg)		sse_m2r(divss, var, reg)
#define	divss_r2r(regs, regd)		sse_r2r(divss, regs, regd)
#define	divss(vars, vard, xmmreg)	sse_m2m(divss, vars, vard, xmmreg)


/*	4x32f Parallel Reciprocals
*/
#define	rcpps_m2r(var, reg)		sse_m2r(rcpps, var, reg)
#define	rcpps_r2r(regs, regd)		sse_r2r(rcpps, regs, regd)
#define	rcpps(vars, vard, xmmreg)	sse_m2m(rcpps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel Reciprocals
*/
#define	rcpss_m2r(var, reg)		sse_m2r(rcpss, var, reg)
#define	rcpss_r2r(regs, regd)		sse_r2r(rcpss, regs, regd)
#define	rcpss(vars, vard, xmmreg)	sse_m2m(rcpss, vars, vard, xmmreg)


/*	4x32f Parallel Square Root of Reciprocals
*/
#define	rsqrtps_m2r(var, reg)		sse_m2r(rsqrtps, var, reg)
#define	rsqrtps_r2r(regs, regd)		sse_r2r(rsqrtps, regs, regd)
#define	rsqrtps(vars, vard, xmmreg)	sse_m2m(rsqrtps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel Square Root of Reciprocals
*/
#define	rsqrtss_m2r(var, reg)		sse_m2r(rsqrtss, var, reg)
#define	rsqrtss_r2r(regs, regd)		sse_r2r(rsqrtss, regs, regd)
#define	rsqrtss(vars, vard, xmmreg)	sse_m2m(rsqrtss, vars, vard, xmmreg)


/*	4x32f Parallel Square Roots
*/
#define	sqrtps_m2r(var, reg)		sse_m2r(sqrtps, var, reg)
#define	sqrtps_r2r(regs, regd)		sse_r2r(sqrtps, regs, regd)
#define	sqrtps(vars, vard, xmmreg)	sse_m2m(sqrtps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel Square Roots
*/
#define	sqrtss_m2r(var, reg)		sse_m2r(sqrtss, var, reg)
#define	sqrtss_r2r(regs, regd)		sse_r2r(sqrtss, regs, regd)
#define	sqrtss(vars, vard, xmmreg)	sse_m2m(sqrtss, vars, vard, xmmreg)


/*	8x8u and 4x16u Parallel AVeraGe
*/
#define	pavgb_m2r(var, reg)		sse_m2r(pavgb, var, reg)
#define	pavgb_r2r(regs, regd)		sse_r2r(pavgb, regs, regd)
#define	pavgb(vars, vard, mmreg)	sse_m2m(pavgb, vars, vard, mmreg)

#define	pavgw_m2r(var, reg)		sse_m2r(pavgw, var, reg)
#define	pavgw_r2r(regs, regd)		sse_r2r(pavgw, regs, regd)
#define	pavgw(vars, vard, mmreg)	sse_m2m(pavgw, vars, vard, mmreg)


/*	1x128 bitwise AND
*/
#define	andps_m2r(var, reg)		sse_m2r(andps, var, reg)
#define	andps_r2r(regs, regd)		sse_r2r(andps, regs, regd)
#define	andps(vars, vard, xmmreg)	sse_m2m(andps, vars, vard, xmmreg)


/*	1x128 bitwise AND with Not the destination
*/
#define	andnps_m2r(var, reg)		sse_m2r(andnps, var, reg)
#define	andnps_r2r(regs, regd)		sse_r2r(andnps, regs, regd)
#define	andnps(vars, vard, xmmreg)	sse_m2m(andnps, vars, vard, xmmreg)


/*	1x128 bitwise OR
*/
#define	orps_m2r(var, reg)		sse_m2r(orps, var, reg)
#define	orps_r2r(regs, regd)		sse_r2r(orps, regs, regd)
#define	orps(vars, vard, xmmreg)	sse_m2m(orps, vars, vard, xmmreg)


/*	1x128 bitwise eXclusive OR
*/
#define	xorps_m2r(var, reg)		sse_m2r(xorps, var, reg)
#define	xorps_r2r(regs, regd)		sse_r2r(xorps, regs, regd)
#define	xorps(vars, vard, xmmreg)	sse_m2m(xorps, vars, vard, xmmreg)


/*	8x8u, 4x16, and 4x32f Parallel Maximum
*/
#define	pmaxub_m2r(var, reg)		sse_m2r(pmaxub, var, reg)
#define	pmaxub_r2r(regs, regd)		sse_r2r(pmaxub, regs, regd)
#define	pmaxub(vars, vard, mmreg)	sse_m2m(pmaxub, vars, vard, mmreg)

#define	pmaxsw_m2r(var, reg)		sse_m2r(pmaxsw, var, reg)
#define	pmaxsw_r2r(regs, regd)		sse_r2r(pmaxsw, regs, regd)
#define	pmaxsw(vars, vard, mmreg)	sse_m2m(pmaxsw, vars, vard, mmreg)

#define	maxps_m2r(var, reg)		sse_m2r(maxps, var, reg)
#define	maxps_r2r(regs, regd)		sse_r2r(maxps, regs, regd)
#define	maxps(vars, vard, xmmreg)	sse_m2m(maxps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel Maximum
*/
#define	maxss_m2r(var, reg)		sse_m2r(maxss, var, reg)
#define	maxss_r2r(regs, regd)		sse_r2r(maxss, regs, regd)
#define	maxss(vars, vard, xmmreg)	sse_m2m(maxss, vars, vard, xmmreg)


/*	8x8u, 4x16, and 4x32f Parallel Minimum
*/
#define	pminub_m2r(var, reg)		sse_m2r(pminub, var, reg)
#define	pminub_r2r(regs, regd)		sse_r2r(pminub, regs, regd)
#define	pminub(vars, vard, mmreg)	sse_m2m(pminub, vars, vard, mmreg)

#define	pminsw_m2r(var, reg)		sse_m2r(pminsw, var, reg)
#define	pminsw_r2r(regs, regd)		sse_r2r(pminsw, regs, regd)
#define	pminsw(vars, vard, mmreg)	sse_m2m(pminsw, vars, vard, mmreg)

#define	minps_m2r(var, reg)		sse_m2r(minps, var, reg)
#define	minps_r2r(regs, regd)		sse_r2r(minps, regs, regd)
#define	minps(vars, vard, xmmreg)	sse_m2m(minps, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Parallel Minimum
*/
#define	minss_m2r(var, reg)		sse_m2r(minss, var, reg)
#define	minss_r2r(regs, regd)		sse_r2r(minss, regs, regd)
#define	minss(vars, vard, xmmreg)	sse_m2m(minss, vars, vard, xmmreg)


/*	4x32f Parallel CoMPares
	(resulting fields are either 0 or -1)
*/
#define	cmpps_m2r(var, reg, op)		sse_m2ri(cmpps, var, reg, op)
#define	cmpps_r2r(regs, regd, op)	sse_r2ri(cmpps, regs, regd, op)
#define	cmpps(vars, vard, op, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, op)

#define	cmpeqps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 0)
#define	cmpeqps_r2r(regs, regd)		sse_r2ri(cmpps, regs, regd, 0)
#define	cmpeqps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 0)

#define	cmpltps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 1)
#define	cmpltps_r2r(regs, regd)		sse_r2ri(cmpps, regs, regd, 1)
#define	cmpltps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 1)

#define	cmpleps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 2)
#define	cmpleps_r2r(regs, regd)		sse_r2ri(cmpps, regs, regd, 2)
#define	cmpleps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 2)

#define	cmpunordps_m2r(var, reg)	sse_m2ri(cmpps, var, reg, 3)
#define	cmpunordps_r2r(regs, regd)	sse_r2ri(cmpps, regs, regd, 3)
#define	cmpunordps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 3)

#define	cmpneqps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 4)
#define	cmpneqps_r2r(regs, regd)	sse_r2ri(cmpps, regs, regd, 4)
#define	cmpneqps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 4)

#define	cmpnltps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 5)
#define	cmpnltps_r2r(regs, regd)	sse_r2ri(cmpps, regs, regd, 5)
#define	cmpnltps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 5)

#define	cmpnleps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 6)
#define	cmpnleps_r2r(regs, regd)	sse_r2ri(cmpps, regs, regd, 6)
#define	cmpnleps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 6)

#define	cmpordps_m2r(var, reg)		sse_m2ri(cmpps, var, reg, 7)
#define	cmpordps_r2r(regs, regd)	sse_r2ri(cmpps, regs, regd, 7)
#define	cmpordps(vars, vard, xmmreg)	sse_m2mi(cmpps, vars, vard, xmmreg, 7)


/*	Lowest Field of 4x32f Parallel CoMPares
	(resulting fields are either 0 or -1)
*/
#define	cmpss_m2r(var, reg, op)		sse_m2ri(cmpss, var, reg, op)
#define	cmpss_r2r(regs, regd, op)	sse_r2ri(cmpss, regs, regd, op)
#define	cmpss(vars, vard, op, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, op)

#define	cmpeqss_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 0)
#define	cmpeqss_r2r(regs, regd)		sse_r2ri(cmpss, regs, regd, 0)
#define	cmpeqss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 0)

#define	cmpltss_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 1)
#define	cmpltss_r2r(regs, regd)		sse_r2ri(cmpss, regs, regd, 1)
#define	cmpltss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 1)

#define	cmpless_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 2)
#define	cmpless_r2r(regs, regd)		sse_r2ri(cmpss, regs, regd, 2)
#define	cmpless(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 2)

#define	cmpunordss_m2r(var, reg)	sse_m2ri(cmpss, var, reg, 3)
#define	cmpunordss_r2r(regs, regd)	sse_r2ri(cmpss, regs, regd, 3)
#define	cmpunordss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 3)

#define	cmpneqss_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 4)
#define	cmpneqss_r2r(regs, regd)	sse_r2ri(cmpss, regs, regd, 4)
#define	cmpneqss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 4)

#define	cmpnltss_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 5)
#define	cmpnltss_r2r(regs, regd)	sse_r2ri(cmpss, regs, regd, 5)
#define	cmpnltss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 5)

#define	cmpnless_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 6)
#define	cmpnless_r2r(regs, regd)	sse_r2ri(cmpss, regs, regd, 6)
#define	cmpnless(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 6)

#define	cmpordss_m2r(var, reg)		sse_m2ri(cmpss, var, reg, 7)
#define	cmpordss_r2r(regs, regd)	sse_r2ri(cmpss, regs, regd, 7)
#define	cmpordss(vars, vard, xmmreg)	sse_m2mi(cmpss, vars, vard, xmmreg, 7)


/*	Lowest Field of 4x32f Parallel CoMPares to set EFLAGS
	(resulting fields are either 0 or -1)
*/
#define	comiss_m2r(var, reg)		sse_m2r(comiss, var, reg)
#define	comiss_r2r(regs, regd)		sse_r2r(comiss, regs, regd)
#define	comiss(vars, vard, xmmreg)	sse_m2m(comiss, vars, vard, xmmreg)


/*	Lowest Field of 4x32f Unordered Parallel CoMPares to set EFLAGS
	(resulting fields are either 0 or -1)
*/
#define	ucomiss_m2r(var, reg)		sse_m2r(ucomiss, var, reg)
#define	ucomiss_r2r(regs, regd)		sse_r2r(ucomiss, regs, regd)
#define	ucomiss(vars, vard, xmmreg)	sse_m2m(ucomiss, vars, vard, xmmreg)


/*	2-(4x32f) -> 4x32f UNPaCK Low Packed Single-fp
	(interleaves low half of dest with low half of source
	 as padding in each result field)
*/
#define	unpcklps_m2r(var, reg)		sse_m2r(unpcklps, var, reg)
#define	unpcklps_r2r(regs, regd)	sse_r2r(unpcklps, regs, regd)


/*	2-(4x32f) -> 4x32f UNPaCK High Packed Single-fp
	(interleaves high half of dest with high half of source
	 as padding in each result field)
*/
#define	unpckhps_m2r(var, reg)		sse_m2r(unpckhps, var, reg)
#define	unpckhps_r2r(regs, regd)	sse_r2r(unpckhps, regs, regd)



/*	Fp and mmX ReSTORe state
*/
#ifdef	SSE_TRACE
	#define	fxrstor(mem) \
	{ \
		fprintf(stderr, "fxrstor()\n"); \
		__asm__ __volatile__ ("fxrstor %0" \
			      : /* nothing */ \
			      : "X" (mem)) \
	}
#else
	#define	fxrstor(mem) \
	__asm__ __volatile__ ("fxrstor %0" \
			      : /* nothing */ \
			      : "X" (mem))
#endif


/*	Fp and mmX SAVE state
*/
#ifdef	SSE_TRACE
	#define	fxsave(mem) \
	{ \
		fprintf(stderr, "fxsave()\n"); \
		__asm__ __volatile__ ("fxsave %0" \
			      : /* nothing */ \
			      : "X" (mem)) \
	}
#else
	#define	fxsave(mem) \
	__asm__ __volatile__ ("fxsave %0" \
			      : /* nothing */ \
			      : "X" (mem))
#endif


/*	STore streaMing simd eXtensions Control/Status Register
*/
#ifdef	SSE_TRACE
	#define	stmxcsr(mem) \
	{ \
		fprintf(stderr, "stmxcsr()\n"); \
		__asm__ __volatile__ ("stmxcsr %0" \
			      : /* nothing */ \
			      : "X" (mem)) \
	}
#else
	#define	stmxcsr(mem) \
	__asm__ __volatile__ ("stmxcsr %0" \
			      : /* nothing */ \
			      : "X" (mem))
#endif


/*	LoaD streaMing simd eXtensions Control/Status Register
*/
#ifdef	SSE_TRACE
	#define	ldmxcsr(mem) \
	{ \
		fprintf(stderr, "ldmxcsr()\n"); \
		__asm__ __volatile__ ("ldmxcsr %0" \
			      : /* nothing */ \
			      : "X" (mem)) \
	}
#else
	#define	ldmxcsr(mem) \
	__asm__ __volatile__ ("ldmxcsr %0" \
			      : /* nothing */ \
			      : "X" (mem))
#endif


/*	Store FENCE - enforce ordering of stores before fence vs. stores
	occuring after fence in source code.
*/
#ifdef	SSE_TRACE
	#define	sfence() \
	{ \
		fprintf(stderr, "sfence()\n"); \
		__asm__ __volatile__ ("sfence\n\t") \
	}
#else
	#define	sfence() \
	__asm__ __volatile__ ("sfence\n\t")
#endif


/*	PREFETCH data using T0, T1, T2, or NTA hint
		T0  = Prefetch into all cache levels
		T1  = Prefetch into all cache levels except 0th level
		T2  = Prefetch into all cache levels except 0th and 1st levels
		NTA = Prefetch data into non-temporal cache structure
*/
#ifdef	SSE_TRACE
#else
	#define	prefetch(mem, hint) \
	__asm__ __volatile__ ("prefetch" #hint " %0" \
			      : /* nothing */ \
			      : "X" (mem))

	#define	prefetcht0(mem)		prefetch(mem, t0)
	#define	prefetcht1(mem)		prefetch(mem, t1)
	#define	prefetcht2(mem)		prefetch(mem, t2)
	#define	prefetchnta(mem)	prefetch(mem, nta)
#endif



#endif
