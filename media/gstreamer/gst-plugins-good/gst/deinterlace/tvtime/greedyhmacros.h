/*
 * GStreamer
 * Copyright (c) 2001 Tom Barry  All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

/*
 * Relicensed for GStreamer from GPL to LGPL with permit from Tom Barry.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

// Define a few macros for CPU dependent instructions. 
// I suspect I don't really understand how the C macro preprocessor works but
// this seems to get the job done.          // TRB 7/01

// BEFORE USING THESE YOU MUST SET:

// #define SIMD_TYPE MMXEXT            (or MMX or 3DNOW)

// some macros for pavgb instruction
//      V_PAVGB(mmr1, mmr2, mmr work register, smask) mmr2 may = mmrw if you can trash it

#define V_PAVGB_MMX(mmr1, mmr2, mmrw, smask) \
	"movq    "mmr2",  "mmrw"\n\t"            \
	"pand    "smask", "mmrw"\n\t"            \
	"psrlw   $1,      "mmrw"\n\t"            \
	"pand    "smask", "mmr1"\n\t"            \
	"psrlw   $1,      "mmr1"\n\t"            \
	"paddusb "mmrw",  "mmr1"\n\t"
#define V_PAVGB_MMXEXT(mmr1, mmr2, mmrw, smask)      "pavgb   "mmr2", "mmr1"\n\t"
#define V_PAVGB_3DNOW(mmr1, mmr2, mmrw, smask)    "pavgusb "mmr2", "mmr1"\n\t"
#define V_PAVGB(mmr1, mmr2, mmrw, smask)          V_PAVGB2(mmr1, mmr2, mmrw, smask, SIMD_TYPE) 
#define V_PAVGB2(mmr1, mmr2, mmrw, smask, simd_type) V_PAVGB3(mmr1, mmr2, mmrw, smask, simd_type) 
#define V_PAVGB3(mmr1, mmr2, mmrw, smask, simd_type) V_PAVGB_##simd_type(mmr1, mmr2, mmrw, smask) 

// some macros for pmaxub instruction
#define V_PMAXUB_MMX(mmr1, mmr2) \
    "psubusb "mmr2", "mmr1"\n\t" \
    "paddusb "mmr2", "mmr1"\n\t"
#define V_PMAXUB_MMXEXT(mmr1, mmr2)      "pmaxub "mmr2", "mmr1"\n\t"
#define V_PMAXUB_3DNOW(mmr1, mmr2)    V_PMAXUB_MMX(mmr1, mmr2)  // use MMX version
#define V_PMAXUB(mmr1, mmr2)          V_PMAXUB2(mmr1, mmr2, SIMD_TYPE) 
#define V_PMAXUB2(mmr1, mmr2, simd_type) V_PMAXUB3(mmr1, mmr2, simd_type) 
#define V_PMAXUB3(mmr1, mmr2, simd_type) V_PMAXUB_##simd_type(mmr1, mmr2) 

// some macros for pminub instruction
//      V_PMINUB(mmr1, mmr2, mmr work register)     mmr2 may NOT = mmrw
#define V_PMINUB_MMX(mmr1, mmr2, mmrw) \
    "pcmpeqb "mmrw", "mmrw"\n\t"       \
    "psubusb "mmr2", "mmrw"\n\t"       \
    "paddusb "mmrw", "mmr1"\n\t"       \
    "psubusb "mmrw", "mmr1"\n\t"
#define V_PMINUB_MMXEXT(mmr1, mmr2, mmrw)      "pminub "mmr2", "mmr1"\n\t"
#define V_PMINUB_3DNOW(mmr1, mmr2, mmrw)    V_PMINUB_MMX(mmr1, mmr2, mmrw)  // use MMX version
#define V_PMINUB(mmr1, mmr2, mmrw)          V_PMINUB2(mmr1, mmr2, mmrw, SIMD_TYPE) 
#define V_PMINUB2(mmr1, mmr2, mmrw, simd_type) V_PMINUB3(mmr1, mmr2, mmrw, simd_type) 
#define V_PMINUB3(mmr1, mmr2, mmrw, simd_type) V_PMINUB_##simd_type(mmr1, mmr2, mmrw) 

// some macros for movntq instruction
//      V_MOVNTQ(mmr1, mmr2) 
#define V_MOVNTQ_MMX(mmr1, mmr2)      "movq   "mmr2", "mmr1"\n\t"
#define V_MOVNTQ_3DNOW(mmr1, mmr2)    "movq   "mmr2", "mmr1"\n\t"
#define V_MOVNTQ_MMXEXT(mmr1, mmr2)      "movntq "mmr2", "mmr1"\n\t"
#define V_MOVNTQ(mmr1, mmr2)          V_MOVNTQ2(mmr1, mmr2, SIMD_TYPE) 
#define V_MOVNTQ2(mmr1, mmr2, simd_type) V_MOVNTQ3(mmr1, mmr2, simd_type) 
#define V_MOVNTQ3(mmr1, mmr2, simd_type) V_MOVNTQ_##simd_type(mmr1, mmr2)

// end of macros

