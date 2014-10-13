// -*- c++ -*-
		
		// First, get and save our possible Bob values
		// Assume our pixels are layed out as follows with x the calc'd bob value
		// and the other pixels are from the current field
		//  
		//	  j a b c k		current field
		//            x			calculated line
		//        m d e f n		current field
		//
		// we calc the bob value luma value as:
        // if |j - n| < Thres && |a - m| > Thres 
        //  avg(j,n)
        // end if
        // if |k - m| < Thres && |c - n| > Thres 
        //  avg(k,m)
        // end if
        // if |c - d| < Thres && |b - f| > Thres 
        //  avg(c,d)
        // end if
        // if |a - f| < Thres && |b - d| > Thres 
        //  avg(a,f)
        // end if
        // if |b - e| < Thres
        //  avg(b,e)
        // end if
        // pickup any thing not yet set with avg(b,e)

#ifndef IS_C

		// j, n
        "pxor %%mm5, %%mm5\n\t"
        "pxor %%mm6, %%mm6\n\t"
        "pxor %%mm7, %%mm7\n\t"

		"movq    -2(%%"XBX"), %%mm0\n\t"		// value a from top left		
		"movq    -4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value m from bottom right			
        
		"movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm3\n\t"
		"psubusb %%mm0, %%mm1\n\t"
		"por		%%mm1, %%mm3\n\t"					// abs(a,m)

		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(a,m) > Thres else 0
		"pxor	%%mm4, %%mm4\n\t"
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(a,m) < Thres, else 00	
		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(a,m) > Thres, else 00


		"movq    -4(%%"XBX"), %%mm0\n\t"		// value j
		"movq    4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n
		"movq	%%mm0, %%mm2\n\t"					
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(j,n)
        "movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm0\n\t"
		"psubusb %%mm3, %%mm1\n\t"
		"por		%%mm1, %%mm0\n\t"					// abs(j,n)

        "movq    %%mm0, %%mm1\n\t"
		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(j,n) > Thres else 0
		"pxor	%%mm3, %%mm3\n\t"
		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(j,n) < Thres, else 00	

        "pand    %%mm4, %%mm1\n\t"
        "pand    %%mm1, %%mm2\n\t"
        "pand    %%mm1, %%mm0\n\t"

        "movq    %%mm1, %%mm3\n\t"
        "pxor    %%mm5, %%mm3\n\t"
        "pand    %%mm3, %%mm6\n\t"
        "pand    %%mm3, %%mm7\n\t"
        "pand    %%mm3, %%mm5\n\t"

        "por     %%mm1, %%mm5\n\t"
        "por     %%mm2, %%mm6\n\t"
        "por     %%mm0, %%mm7\n\t"
        
        // k & m
		"movq    2(%%"XBX"), %%mm0\n\t"		// value c from top left		
		"movq    4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value n from bottom right			

		"movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm3\n\t"
		"psubusb %%mm0, %%mm1\n\t"
		"por		%%mm1, %%mm3\n\t"					// abs(c,n)

		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(c,n) > Thres else 0
		"pxor	%%mm4, %%mm4\n\t"
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(c,n) < Thres, else 00	
		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(c,n) > Thres, else 00


		"movq    4(%%"XBX"), %%mm0\n\t"		// value k
		"movq    -4(%%"XBX", %%"XCX"), %%mm1\n\t"	// value m
		"movq	%%mm0, %%mm2\n\t"					
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(k,m)
        "movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm0\n\t"
		"psubusb %%mm3, %%mm1\n\t"
		"por		%%mm1, %%mm0\n\t"					// abs(k,m)

        "movq    %%mm0, %%mm1\n\t"
		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(k,m) > Thres else 0
		"pxor	%%mm3, %%mm3\n\t"
		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(k,m) < Thres, else 00	

        "pand    %%mm4, %%mm1\n\t"
        
        "pand    %%mm1, %%mm2\n\t"
        "pand    %%mm1, %%mm0\n\t"

        "movq    %%mm1, %%mm3\n\t"
        "pxor    %%mm5, %%mm3\n\t"
        "pand    %%mm3, %%mm6\n\t"
        "pand    %%mm3, %%mm7\n\t"
        "pand    %%mm3, %%mm5\n\t"

        "por     %%mm1, %%mm5\n\t"
        "por     %%mm2, %%mm6\n\t"
        "por     %%mm0, %%mm7\n\t"


        // c & d
		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top left		
		"movq    2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f from bottom right			

		"movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm3\n\t"
		"psubusb %%mm0, %%mm1\n\t"
		"por		%%mm1, %%mm3\n\t"					// abs(b,f)

		"psubusb "_DiffThres", %%mm3\n\t"		// nonzero where abs(b,f) > Thres else 0
		"pxor	%%mm4, %%mm4\n\t"
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(b,f) < Thres, else 00	
		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(b,f) > Thres, else 00

		"movq    2(%%"XBX"), %%mm0\n\t"		// value c
		"movq    -2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value d
		"movq	%%mm0, %%mm2\n\t"					
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(c,d)
        "movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm0\n\t"
		"psubusb %%mm3, %%mm1\n\t"
		"por		%%mm1, %%mm0\n\t"					// abs(c,d)

        "movq    %%mm0, %%mm1\n\t"
		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(c,d) > Thres else 0
		"pxor	%%mm3, %%mm3\n\t"
        "pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(c,d) < Thres, else 00	

        "pand    %%mm4, %%mm1\n\t"

        "pand    %%mm1, %%mm2\n\t"
        "pand    %%mm1, %%mm0\n\t"

        "movq    %%mm1, %%mm3\n\t"
        "pxor    %%mm5, %%mm3\n\t"
        "pand    %%mm3, %%mm6\n\t"
        "pand    %%mm3, %%mm7\n\t"
        "pand    %%mm3, %%mm5\n\t"

        "por     %%mm1, %%mm5\n\t"
        "por     %%mm2, %%mm6\n\t"
        "por     %%mm0, %%mm7\n\t"

        // a & f
		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top left		
		"movq    -2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value d from bottom right			

		"movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm3\n\t"
		"psubusb %%mm0, %%mm1\n\t"
		"por		%%mm1, %%mm3\n\t"					// abs(b,d)

		"psubusb "_DiffThres", %%mm3\n\t"	// nonzero where abs(b,d) > Thres else 0
		"pxor	%%mm4, %%mm4\n\t"
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where abs(b,d) < Thres, else 00	
		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where abs(b,d) > Thres, else 00

		"movq    -2(%%"XBX"), %%mm0\n\t"		// value a
		"movq    2(%%"XBX", %%"XCX"), %%mm1\n\t"	// value f
		"movq	%%mm0, %%mm2\n\t"					
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(a,f)
        "movq	%%mm0, %%mm3\n\t"
        "psubusb	%%mm1, %%mm0\n\t"
		"psubusb %%mm3, %%mm1\n\t"
		"por		%%mm1, %%mm0\n\t"					// abs(a,f)

        "movq    %%mm0, %%mm1\n\t"
		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(a,f) > Thres else 0
		"pxor	%%mm3, %%mm3\n\t"
		"pcmpeqb %%mm3, %%mm1\n\t"			// now ff where abs(a,f) < Thres, else 00	

        "pand    %%mm4, %%mm1\n\t"

        "pand    %%mm1, %%mm2\n\t"
        "pand    %%mm1, %%mm0\n\t"
            
        "movq    %%mm1, %%mm3\n\t"
        "pxor    %%mm5, %%mm3\n\t"
        "pand    %%mm3, %%mm6\n\t"
        "pand    %%mm3, %%mm7\n\t"
        "pand    %%mm3, %%mm5\n\t"

        "por     %%mm1, %%mm5\n\t"
        "por     %%mm2, %%mm6\n\t"
        "por     %%mm0, %%mm7\n\t"
           
 		"pand	"_YMask", %%mm5\n\t"		// mask out chroma from here
 		"pand	"_YMask", %%mm6\n\t"			// mask out chroma from here
 		"pand	"_YMask", %%mm7\n\t"			// mask out chroma from here

		// b,e
		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top 		
		"movq    (%%"XBX", %%"XCX"), %%mm1\n\t"	// value e from bottom 
		"movq	%%mm0, %%mm2\n\t"					
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(b,e)
        "movq	%%mm0, %%mm3\n\t"
        "psubusb	%%mm1, %%mm0\n\t"
		"psubusb %%mm3, %%mm1\n\t"
		"por		%%mm1, %%mm0\n\t"					// abs(b,e)

        "movq    %%mm0, %%mm1\n\t"
		"psubusb "_DiffThres", %%mm1\n\t"		// nonzero where abs(b,e) > Thres else 0
		"pxor	%%mm3, %%mm3\n\t"
		"pcmpeqb %%mm3, %%mm1\n\t"		// now ff where abs(b,e) < Thres, else 00	

        "pand    %%mm1, %%mm2\n\t"
        "pand    %%mm1, %%mm0\n\t"

        "movq    %%mm1, %%mm3\n\t"
        "pxor    %%mm5, %%mm3\n\t"
        "pand    %%mm3, %%mm6\n\t"
        "pand    %%mm3, %%mm7\n\t"
        "pand    %%mm3, %%mm5\n\t"

        "por     %%mm1, %%mm5\n\t"
        "por     %%mm2, %%mm6\n\t"
        "por     %%mm0, %%mm7\n\t"

		// bob in any leftovers
		"movq    (%%"XBX"), %%mm0\n\t"		// value b from top 		
		"movq    (%%"XBX", %%"XCX"), %%mm1\n\t"	// value e from bottom 


// We will also calc here the max/min values to later limit comb
// so the max excursion will not exceed the Max_Comb constant

#ifdef SKIP_SEARCH		
		"movq	%%mm0, %%mm2\n\t"
//		pminub	%%mm2, %%mm1
		V_PMINUB ("%%mm2", "%%mm1", "%%mm4")

//		pmaxub	%%mm6, %%mm2			// clip our current results so far to be above this
		V_PMAXUB ("%%mm6", "%%mm2")
        "movq	%%mm0, %%mm2\n\t"
		V_PMAXUB ("%%mm2", "%%mm1")
//		pminub	%%mm6, %%mm2			// clip our current results so far to be below this
		V_PMINUB ("%%mm6", "%%mm2", "%%mm4")

#else
        "movq	%%mm0, %%mm2\n\t"
		"movq	(%%"XAX"), %%mm4\n\t"
		"psubusb %%mm4, %%mm2\n\t"
		"psubusb %%mm0, %%mm4\n\t"
		"por		%%mm2, %%mm4\n\t"			// abs diff
		
		"movq	%%mm1, %%mm2\n\t"
		"movq	(%%"XAX", %%"XCX"), %%mm3\n\t"
		"psubusb %%mm3, %%mm2\n\t"
		"psubusb %%mm1, %%mm3\n\t"
		"por		%%mm2, %%mm3\n\t"			// abs diff
//		pmaxub  %%mm3, %%mm4			// top or bottom pixel moved most
		V_PMAXUB ("%%mm3", "%%mm4")			// top or bottom pixel moved most
        "psubusb "_DiffThres", %%mm3\n\t"		// moved more than allowed? or goes to 0?
		"pxor	%%mm4, %%mm4\n\t"
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where low motion, else high motion
		
		"movq	%%mm0, %%mm2\n\t"
//		pminub	%%mm2, %%mm1
		V_PMINUB ("%%mm2", "%%mm1", "%%mm4")

//		pmaxub	%%mm6, %%mm2			// clip our current results so far to be above this
		V_PMAXUB ("%%mm6", "%%mm2")

        "psubusb %%mm3, %%mm2\n\t"			// maybe decrease it to 0000.. if no surround motion
		"movq	%%mm2, "_Min_Vals"\n\t"

		"movq	%%mm0, %%mm2\n\t"
		V_PMAXUB ("%%mm2", "%%mm1")
//		pminub	%%mm6, %%mm2			// clip our current results so far to be below this
		V_PMINUB ("%%mm6", "%%mm2", "%%mm4")
        "paddusb %%mm3, %%mm2\n\t"			// maybe increase it to ffffff if no surround motion
		"movq	%%mm2, "_Max_Vals"\n\t"
#endif
			
		"movq	%%mm0, %%mm2\n\t"						
//		pavgb	%%mm2, %%mm1					// avg(b,e)
		V_PAVGB ("%%mm2", "%%mm1", "%%mm3", _ShiftMask)	// avg(b,e)
				
        "movq	%%mm0, %%mm3\n\t"
		"psubusb	%%mm1, %%mm3\n\t"
		"psubusb %%mm0, %%mm1\n\t"
		"por		%%mm1, %%mm3\n\t"			// abs(b,e)
		"movq	%%mm3, %%mm1\n\t"			// keep copy of diffs
            
		"pxor	%%mm4, %%mm4\n\t"			
		"psubusb %%mm7, %%mm3\n\t"			// nonzero where new weights bigger, else 0
		"pcmpeqb %%mm4, %%mm3\n\t"			// now ff where new better, else 00	
        "pcmpeqb %%mm0, %%mm0\n\t"
        "pandn   %%mm0, %%mm5\n\t"
        "por     %%mm5, %%mm3\n\t"
		"pcmpeqb	%%mm3, %%mm4\n\t"			// here ff where old better, else 00

		"pand	%%mm3, %%mm1\n\t"
		"pand	%%mm3, %%mm2\n\t"
        
		"pand    %%mm4, %%mm6\n\t"
		"pand    %%mm4, %%mm7\n\t"

		"por		%%mm2, %%mm6\n\t"			// our x2 value
		"por		%%mm1, %%mm7\n\t"			// our x2 diffs
		"movq	%%mm7, %%mm4\n\t"			// save as bob uncertainty indicator

#else

        diff[0] = -1;
        diff[1] = -1;
	best[0] = 0;
	best[1] = 0;
	// j, n
        if (ABS (pBob[-2] - pBob[src_pitch2 - 4]) < DiffThres &&
	    ABS (pBob[-4] - pBob[src_pitch2 + 4]) > DiffThres) {
	   best[0] = (pBob[-2] + pBob[src_pitch2 - 4]) / 2;
	   diff[0] = ABS (pBob[-2] - pBob[src_pitch2 - 4]);
	}
        if (ABS (pBob[-1] - pBob[src_pitch2 - 3]) < DiffThres &&
	    ABS (pBob[-3] - pBob[src_pitch2 + 5]) > DiffThres) {
	   best[1] = (pBob[-1] + pBob[src_pitch2 - 3]) / 2;
	   diff[1] = ABS (pBob[-1] - pBob[src_pitch2 - 3]);
	}

        // k & m
        if (ABS (pBob[2] - pBob[src_pitch2 + 4]) < DiffThres &&
	    ABS (pBob[4] - pBob[src_pitch2 - 4]) > DiffThres) {
	   best[0] = (pBob[4] + pBob[src_pitch2 - 4]) / 2;
	   diff[0] = ABS (pBob[4] - pBob[src_pitch2 - 4]);
	}

        if (ABS (pBob[3] - pBob[src_pitch2 + 5]) < DiffThres &&
	    ABS (pBob[5] - pBob[src_pitch2 - 3]) > DiffThres) {
	   best[1] = (pBob[5] + pBob[src_pitch2 - 3]) / 2;
	   diff[1] = ABS (pBob[5] - pBob[src_pitch2 - 3]);
	}

        // c & d
	if (ABS (pBob[0] - pBob[src_pitch2 + 2]) < DiffThres &&
	    ABS (pBob[2] - pBob[src_pitch2 - 2]) > DiffThres) {
	   best[0] = (pBob[2] + pBob[src_pitch2 - 2]) / 2;
	   diff[0] = ABS (pBob[2] - pBob[src_pitch2 - 2]);
	}

	if (ABS (pBob[1] - pBob[src_pitch2 + 3]) < DiffThres &&
	    ABS (pBob[3] - pBob[src_pitch2 - 1]) > DiffThres) {
	   best[1] = (pBob[3] + pBob[src_pitch2 - 1]) / 2;
	   diff[1] = ABS (pBob[3] - pBob[src_pitch2 - 1]);
	}

        // a & f
	if (ABS (pBob[0] - pBob[src_pitch2 - 2]) < DiffThres &&
	    ABS (pBob[-2] - pBob[src_pitch2 + 2]) > DiffThres) {
	   best[0] = (pBob[-2] + pBob[src_pitch2 + 2]) / 2;
	   diff[0] = ABS (pBob[-2] - pBob[src_pitch2 + 2]);
	}

	if (ABS (pBob[1] - pBob[src_pitch2 - 1]) < DiffThres &&
	    ABS (pBob[-1] - pBob[src_pitch2 + 3]) > DiffThres) {
	   best[1] = (pBob[-1] + pBob[src_pitch2 + 3]) / 2;
	   diff[1] = ABS (pBob[-1] - pBob[src_pitch2 + 3]);
	}

	// b,e
	if (ABS (pBob[0] - pBob[src_pitch2]) < DiffThres) {
	   best[0] = (pBob[0] + pBob[src_pitch2]) / 2;
	   diff[0] = ABS (pBob[0] - pBob[src_pitch2]);
	}

	if (ABS (pBob[1] - pBob[src_pitch2 + 1]) < DiffThres) {
	   best[1] = (pBob[1] + pBob[src_pitch2 + 1]) / 2;
	   diff[1] = ABS (pBob[1] - pBob[src_pitch2 + 1]);
	}


// We will also calc here the max/min values to later limit comb
// so the max excursion will not exceed the Max_Comb constant

#ifdef SKIP_SEARCH
		best[0] = CLAMP (best[0], MIN (pBob[src_pitch2], pBob[0]), MAX (pBob[src_pitch2], pBob[0]));
		best[1] = CLAMP (best[1], MIN (pBob[src_pitch2 + 1], pBob[1]), MAX (pBob[src_pitch2 + 1], pBob[1]));
#else
		mov[0] = MAX (ABS (pBob[0] - pBobP[0]), ABS (pBob[src_pitch2] - pBobP[src_pitch2]));
		mov[1] = MAX (ABS (pBob[1] - pBobP[1]), ABS (pBob[src_pitch2 + 1] - pBobP[src_pitch2 + 1]));

		MinVals[0] = 0;
		MinVals[1] = 0;
		MaxVals[0] = 255;
		MaxVals[1] = 255;
		if (mov[0] > DiffThres) {
		  MinVals[0] = MAX (MIN (pBob[0], pBob[src_pitch2]), best[0]);
		  MaxVals[0] = MIN (MAX (pBob[0], pBob[src_pitch2]), best[0]);
		}
		
		if (mov[1] > DiffThres) {
		  MinVals[1] = MAX (MIN (pBob[1], pBob[src_pitch2+1]), best[1]);
		  MaxVals[1] = MIN (MAX (pBob[1], pBob[src_pitch2+1]), best[1]);
		}

		best[0] = CLAMP (best[0], MIN (pBob[src_pitch2], pBob[0]), MAX (pBob[src_pitch2], pBob[0]));
		best[1] = CLAMP (best[1], MIN (pBob[src_pitch2 + 1], pBob[1]), MAX (pBob[src_pitch2 + 1], pBob[1]));
#endif
		avg[0] = (pBob[src_pitch2] + pBob[0]) / 2;
		avg[1] = (pBob[src_pitch2 + 1] + pBob[1]) / 2;
		diff2[0] = ABS (pBob[src_pitch2 + 1] - pBob[1]);
		diff2[1] = ABS (pBob[src_pitch2 + 1] - pBob[1]);

		if (diff[0] == -1 || diff2[0] < diff[0]) {
		  best[0] = avg[0];
		  diff[0] = diff2[0];
		}

		if (diff[1] == -1 || diff2[1] < diff[1]) {
		  best[1] = avg[1];
		  diff[1] = diff2[1];
		}
#endif
