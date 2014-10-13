// -*- c++ -*-

unsigned char* pDest;
const unsigned char* pSrcP;
const unsigned char* pSrc;
const unsigned char* pBob;
const unsigned char* pBobP;

// long is int32 on ARCH_368, int64 on ARCH_AMD64. Declaring it this way
// saves a lot of xor's to delete 64bit garbage.

#if defined(DBL_RESIZE) || defined(USE_FOR_DSCALER)
long	    src_pitch2 = src_pitch;			// even & odd lines are not interleaved in DScaler
#else
long	    src_pitch2 = 2 * src_pitch;		// even & odd lines are interleaved in Avisynth
#endif


long	    dst_pitch2 = 2 * dst_pitch;
long        y;

long     Last8;

	pSrc  = pWeaveSrc;			// points 1 weave line above
	pSrcP = pWeaveSrcP;			// " 

#ifdef DBL_RESIZE
	        
#ifdef USE_VERTICAL_FILTER
	pDest = pWeaveDest + dst_pitch2;
#else
	pDest = pWeaveDest + 3*dst_pitch;
#endif

#else

#ifdef USE_VERTICAL_FILTER
	pDest = pWeaveDest + dst_pitch;
#else
	pDest = pWeaveDest + dst_pitch2;
#endif

#endif

	if (TopFirst)
	{
		pBob = pCopySrc + src_pitch2;      // remember one weave line just copied previously
		pBobP = pCopySrcP + src_pitch2;
	}
	else
	{
		pBob =  pCopySrc;
		pBobP =  pCopySrcP;
	}

#ifndef IS_C

#ifndef _pBob
#define _pBob       "%0"
#define _src_pitch2 "%1"
#define _ShiftMask  "%2"
#define _pDest      "%3"
#define _dst_pitchw "%4"
#define _Last8      "%5"
#define _pSrc       "%6"
#define _pSrcP      "%7"
#define _pBobP      "%8"
#define _DiffThres  "%9"
#define _Min_Vals   "%10"
#define _Max_Vals   "%11"
#define _FOURS      "%12"
#define _TENS       "%13"
#define _ONES       "%14"
#define _UVMask     "%15"
#define _Max_Mov    "%16"
#define _YMask      "%17"
#define _oldbx      "%18"
#endif
        Last8 = (rowsize-8);

	for (y=1; y < FldHeight-1; y++)	
	{	
          long	dst_pitchw = dst_pitch; // local stor so asm can ref
          int64_t Max_Mov   = 0x0404040404040404ull; 
          int64_t DiffThres = 0x0f0f0f0f0f0f0f0full; 
          int64_t YMask     = 0x00ff00ff00ff00ffull; // keeps only luma
          int64_t UVMask    = 0xff00ff00ff00ff00ull; // keeps only chroma
          int64_t TENS      = 0x0a0a0a0a0a0a0a0aull; 
          int64_t FOURS     = 0x0404040404040404ull; 
          int64_t ONES      = 0x0101010101010101ull; 
          int64_t Min_Vals  = 0x0000000000000000ull;
          int64_t Max_Vals  = 0x0000000000000000ull;
          int64_t ShiftMask = 0xfefffefffefffeffull;

          long oldbx = 0;

		// pretend it's indented -->>
        __asm__ __volatile__
            (
             // Loop general reg usage
             //
             // XAX - pBobP, then pDest 
             // XBX - pBob
             // XCX - src_pitch2
             // XDX - current offset
             // XDI - prev weave pixels, 1 line up
             // XSI - next weave pixels, 1 line up

             // Save "XBX" (-fPIC)
	     MOVX" %%"XBX", "_oldbx"\n\t"
             
             // simple bob first 8 bytes
             MOVX"	"_pBob",        %%"XBX"\n\t"
             MOVX"	"_src_pitch2",  %%"XCX"\n\t"

#ifdef USE_VERTICAL_FILTER
             "movq	    (%%"XBX"),        %%mm0\n\t"
             "movq	    (%%"XBX", %%"XCX"), %%mm1\n\t" //, qword ptr["XBX"+"XCX"]
             "movq	    %%mm0,          %%mm2\n\t"
             V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)		// halfway between
             V_PAVGB ("%%mm0", "%%mm2", "%%mm3", _ShiftMask)		// 1/4 way
             V_PAVGB ("%%mm1", "%%mm2", "%%mm3", _ShiftMask)		// 3/4 way
             MOVX"		"_pDest",       %%"XDI"\n\t"
             MOVX"		"_dst_pitchw",  %%"XAX"\n\t"
             V_MOVNTQ	("(%%"XDI")", "%%mm0")
             V_MOVNTQ	("(%%"XDI", %%"XAX")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1

             // simple bob last 8 bytes
             MOVX"		"_Last8", %%"XDX"\n\t"
             LEAX"		(%%"XBX", %%"XDX"), %%"XSI"\n\t"  // ["XBX"+"XDX"]
             "movq	    (%%"XSI"), %%mm0\n\t"
             "movq	    (%%"XSI", %%"XCX"), %%mm1\n\t"    // qword ptr["XSI"+"XCX"]
             "movq	    %%mm0, %%mm2\n\t"
             V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)		// halfway between
             V_PAVGB ("%%mm0", "%%mm2", "%%mm3", _ShiftMask)		// 1/4 way
             V_PAVGB ("%%mm1", "%%mm2", "%%mm3", _ShiftMask)		// 3/4 way
             ADDX"		%%"XDX", %%"XDI"\n\t"						// last 8 bytes of dest
             V_MOVNTQ	("%%"XDI"", "%%mm0")
             V_MOVNTQ	("(%%"XDI", %%"XAX")", "%%mm1") // qword ptr["XDI"+"XAX"], mm1)

#else
             "movq	(%%"XBX"), %%mm0\n\t"
             //		pavgb	mm0, qword ptr["XBX"+"XCX"]
             V_PAVGB ("%%mm0", "(%%"XBX", %%"XCX")", "%%mm2", _ShiftMask) // qword ptr["XBX"+"XCX"], mm2, ShiftMask)
             MOVX"		"_pDest", %%"XDI"\n\t"
             V_MOVNTQ	("(%%"XDI")", "%%mm0")

             // simple bob last 8 bytes
             MOVX"		"_Last8", %%"XDX"\n\t"
             LEAX"		(%%"XBX", %%"XDX"), %%"XSI"\n\t" //"XSI", ["XBX"+"XDX"]
             "movq	    (%%"XSI"), %%mm0\n\t"
             //		pavgb	mm0, qword ptr["XSI"+"XCX"]
             V_PAVGB	("%%mm0", "(%%"XSI", %%"XCX")", "%%mm2", _ShiftMask) // qword ptr["XSI"+"XCX"], mm2, ShiftMask)
             V_MOVNTQ	("(%%"XDI", %%"XDX")", "%%mm0") // qword ptr["XDI"+"XDX"], mm0)
#endif
             // now loop and get the middle qwords
             MOVX"		"_pSrc", %%"XSI"\n\t"
             MOVX"		"_pSrcP", %%"XDI"\n\t"
             MOVX"		$8, %%"XDX"\n\t"				// curr offset longo all lines

             "1:\n\t"	
             MOVX"		"_pBobP", %%"XAX"\n\t"
             ADDX"		$8, %%"XDI"\n\t"
             ADDX"		$8, %%"XSI"\n\t"
             ADDX"		$8, %%"XBX"\n\t"
             ADDX"		%%"XDX", %%"XAX"\n\t"

#ifdef USE_STRANGE_BOB
#include "StrangeBob.inc"
#else
#include "WierdBob.inc"
#endif

             // For non-SSE2:
             // through out most of the rest of this loop we will maintain
             //	mm4		our min bob value
             //	mm5		best weave pixels so far
             // mm6		our max Bob value 
             //	mm7		best weighted pixel ratings so far
             
             // We will keep a slight bias to using the weave pixels
             // from the current location, by rating them by the min distance
             // from the Bob value instead of the avg distance from that value.
             // our best and only rating so far
             "pcmpeqb	%%mm7, %%mm7\n\t"			// ffff, say we didn't find anything good yet

#else
        Last8 = (rowsize - 4);

	for (y=1; y < FldHeight-1; y++)
	{
	  #ifdef USE_STRANGE_BOB
	  long DiffThres = 0x0f;
	  #endif

	  #ifndef SKIP_SEARCH
	  long weave[2], MaxVals[2], MinVals[2];
	  #endif

	  long diff[2], best[2], avg[2], diff2[2], out[2], x;

#ifdef USE_VERTICAL_FILTER
             pDest[0] = (3 * pBob[0] + pBob[src_pitch2]) / 4;
             pDest[1] = (3 * pBob[1] + pBob[src_pitch2 + 1]) / 4;
             pDest[2] = (3 * pBob[2] + pBob[src_pitch2 + 2]) / 4;
             pDest[3] = (3 * pBob[3] + pBob[src_pitch2 + 3]) / 4;
	     pDest[dst_pitchw] = (pBob[0] + 3 * pBob[src_pitch2]) / 4;
	     pDest[dst_pitchw + 1] = (pBob[1] + 3 * pBob[src_pitch2 + 1]) / 4;
	     pDest[dst_pitchw + 2] = (pBob[2] + 3 * pBob[src_pitch2 + 2]) / 4;
	     pDest[dst_pitchw + 3] = (pBob[3] + 3 * pBob[src_pitch2 + 3]) / 4;

             // simple bob last byte
	     pDest[Last8] = (3 * pBob[Last8] + pBob[Last8 + src_pitch2]) / 4;
	     pDest[Last8 + 1] = (3 * pBob[Last8 + 1] + pBob[Last8 + src_pitch2 + 1]) / 4;
	     pDest[Last8 + 2] = (3 * pBob[Last8 + 2] + pBob[Last8 + src_pitch2 + 2]) / 4;
	     pDest[Last8 + 3] = (3 * pBob[Last8 + 3] + pBob[Last8 + src_pitch2 + 3]) / 4;
	     pDest[Last8 + src_pitch2] = (pBob[Last8] + 3 * pBob[Last8 + src_pitch2]) / 4;
	     pDest[Last8 + src_pitch2 + 1] = (pBob[Last8 + 1] + 3 * pBob[Last8 + src_pitch2 + 1]) / 4;
	     pDest[Last8 + src_pitch2 + 2] = (pBob[Last8 + 2] + 3 * pBob[Last8 + src_pitch2 + 2]) / 4;
	     pDest[Last8 + src_pitch2 + 3] = (pBob[Last8 + 3] + 3 * pBob[Last8 + src_pitch2 + 3]) / 4;
#else
             pDest[0] = (pBob[0] + pBob[src_pitch2 + 1]) / 2;
             pDest[1] = (pBob[1] + pBob[src_pitch2 + 1]) / 2;
             pDest[2] = (pBob[2] + pBob[src_pitch2 + 2]) / 2;
             pDest[3] = (pBob[3] + pBob[src_pitch2 + 3]) / 2;

             // simple bob last byte
	     pDest[Last8] = (pBob[Last8] + pBob[Last8 + src_pitch2]) / 2;
	     pDest[Last8 + 1] = (pBob[Last8 + 1] + pBob[Last8 + src_pitch2 + 1]) / 2;
	     pDest[Last8 + 2] = (pBob[Last8 + 2] + pBob[Last8 + src_pitch2 + 2]) / 2;
	     pDest[Last8 + 3] = (pBob[Last8 + 3] + pBob[Last8 + src_pitch2 + 3]) / 2;
#endif

             pBob += 4;
	     pBobP += 4;
	     pSrc += 4;
	     pSrcP += 4;

             for (x=4; x < Last8; x += 2) {

#ifdef USE_STRANGE_BOB
#include "StrangeBob.inc"
#else
#include "WierdBob.inc"
#endif

             // We will keep a slight bias to using the weave pixels
             // from the current location, by rating them by the min distance
             // from the Bob value instead of the avg distance from that value.
             // our best and only rating so far
             diff[0] = diff[1] = 255;


#endif
