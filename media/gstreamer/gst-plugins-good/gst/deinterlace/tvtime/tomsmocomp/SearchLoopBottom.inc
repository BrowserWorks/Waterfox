// -*- c++ -*-       

// Version for non-SSE2

#ifndef IS_C

#ifdef SKIP_SEARCH
            "movq    %%mm6, %%mm0\n\t"            // just use the results of our wierd bob
#else


            // JA 9/Dec/2002
            // failed experiment
            // but leave in placeholder for me to play about
#ifdef DONT_USE_STRANGE_BOB
            // Use the best weave if diffs less than 10 as that
            // means the image is still or moving cleanly
            // if there is motion we will clip which will catch anything
            "psubusb "_FOURS", %%mm7\n\t"          // sets bits to zero if weave diff < 4
            "pxor    %%mm0, %%mm0\n\t"
            "pcmpeqb %%mm0, %%mm7\n\t"            // all ff where weave better, else 00
            "pcmpeqb %%mm7, %%mm0\n\t"            // all ff where bob better, else 00
            "pand    %%mm6, %%mm0\n\t"            // use bob for these pixel values
            "pand    %%mm5, %%mm7\n\t"            // use weave for these
            "por     %%mm7, %%mm0\n\t"            // combine both
#else
            // Use the better of bob or weave
            //      pminub  mm4, TENS           // the most we care about
            V_PMINUB ("%%mm4", _TENS, "%%mm0")   // the most we care about
            
            "psubusb %%mm4, %%mm7\n\t"            // foregive that much from weave est?
            "psubusb "_FOURS", %%mm7\n\t"       // bias it a bit toward weave
            "pxor    %%mm0, %%mm0\n\t"
            "pcmpeqb %%mm0, %%mm7\n\t"            // all ff where weave better, else 00
            "pcmpeqb %%mm7, %%mm0\n\t"            // all ff where bob better, else 00
            "pand    %%mm6, %%mm0\n\t"            // use bob for these pixel values
            "pand    %%mm5, %%mm7\n\t"            // use weave for these
            "por     %%mm7, %%mm0\n\t"            // combine both
#endif
            
            
                //      pminub  mm0, Max_Vals       // but clip to catch the stray error
                V_PMINUB ("%%mm0", _Max_Vals, "%%mm1") // but clip to catch the stray error
                //      pmaxub  mm0, Min_Vals
                V_PMAXUB ("%%mm0", _Min_Vals)
                
#endif


            MOVX"     "_pDest", %%"XAX"\n\t"
                
#ifdef USE_VERTICAL_FILTER
            "movq    %%mm0, %%mm1\n\t"
            //      pavgb   mm0, qword ptr["XBX"]
            V_PAVGB ("%%mm0", "(%%"XBX")", "%%mm2", _ShiftMask)
            //      movntq  qword ptr["XAX"+"XDX"], mm0
            V_MOVNTQ ("(%"XAX", %%"XDX")", "%%mm0")
            //      pavgb   mm1, qword ptr["XBX"+"XCX"]
            V_PAVGB ("%%mm1", "(%%"XBX", %%"XCX")", "%%mm2", _ShiftMask)
	    //FIXME: XDX or XAX!!
            "addq   "_dst_pitchw", %%"XBX
            //      movntq  qword ptr["XAX"+"XDX"], mm1
            V_MOVNTQ ("(%%"XAX", %%"XDX")", "%%mm1")
#else
                
            //      movntq  qword ptr["XAX"+"XDX"], mm0
                V_MOVNTQ ("(%%"XAX", %%"XDX")", "%%mm0")
#endif
                
           LEAX"    8(%%"XDX"), %%"XDX"\n\t"       // bump offset pointer
           CMPX"    "_Last8", %%"XDX"\n\t"       // done with line?
           "jb      1b\n\t"                    // y

           MOVX" "_oldbx", %%"XBX"\n\t"

        : /* no outputs */

        : "m"(pBob),
          "m"(src_pitch2),
          "m"(ShiftMask),
          "m"(pDest),
          "m"(dst_pitchw),
          "m"(Last8),
          "m"(pSrc),
          "m"(pSrcP),
          "m"(pBobP),
          "m"(DiffThres),
          "m"(Min_Vals),
          "m"(Max_Vals),
          "m"(FOURS),
          "m"(TENS),
          "m"(ONES),
          "m"(UVMask),
          "m"(Max_Mov),
          "m"(YMask),
          "m"(oldbx)

        : XAX, XCX, XDX, XSI, XDI,
          "st", "st(1)", "st(2)", "st(3)", "st(4)", "st(5)", "st(6)", "st(7)",
#ifdef __MMX__
          "mm0", "mm1", "mm2", "mm3", "mm4", "mm5", "mm6", "mm7",
#endif
          "memory", "cc"
        );

        // adjust for next line
        pSrc  += src_pitch2;
        pSrcP += src_pitch2;
        pDest += dst_pitch2;
        pBob  += src_pitch2;
        pBobP += src_pitch2;
    }
    
    return 0;
#else
#ifdef SKIP_SEARCH
            out[0] = best[0];            // just use the results of our wierd bob
	    out[1] = best[1];
#else
            diff[0] = diff[0] - MIN (diff[0], 10) - 4;
	    diff[1] = diff[1] - MIN (diff[1] - 10) - 4;
	    if (diff[0] < 0)
	      out[0] = weave[0];
	    else
	      out[0] = best[0];
	    
	    if (diff[1] < 0)
	      out[1] = weave[1];
	    else
	      out[1] = best[1];


	    out[0] = CLAMP (out[0], MinVals[0], MaxVals[0]);
	    out[1] = CLAMP (out[1], MinVals[1], MaxVals[1]);
#endif

#ifdef USE_VERTICAL_FILTER
            pDest[x] = (out[0] + pBob[0]) / 2;
	    pDest[x + dst_pitchw] = (pBob[src_pitch2] + out[0]) / 2;
            pDest[x + 1] = (out[1] + pBob[1]) / 2;
	    pDest[x + 1 + dst_pitchw] = (pBob[src_pitch2 + 1] + out[1]) / 2;
#else
            pDest[x] = out[0];
	    pDest[x+1] = out[1];
#endif
            pBob += 2;
            pBobP += 2;
            pSrc += 2;
            pSrcP += 2;
	}
        // adjust for next line
        pSrc  = src_pitch2 * (y+1) + pWeaveSrc;
        pSrcP = src_pitch2 * (y+1) + pWeaveSrcP;
        pDest = dst_pitch2 * (y+1) + pWeaveDest + dst_pitch2;


	if (TopFirst)
	{
		pBob = pCopySrc + src_pitch2;
		pBobP = pCopySrcP + src_pitch2;
	}
	else
	{
		pBob =  pCopySrc;
		pBobP =  pCopySrcP;
	}

        pBob  += src_pitch2 * (y+1);
        pBobP += src_pitch2 * (y+1);
    }
    
    return 0;

#endif
