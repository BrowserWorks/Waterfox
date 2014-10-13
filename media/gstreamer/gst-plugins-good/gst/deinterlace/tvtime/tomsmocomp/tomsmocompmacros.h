#include <string.h>
#include <math.h>

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

#ifdef IS_SSE2

#define MERGE4PIXavg(PADDR1, PADDR2)                                                     \
    "movdqu  "PADDR1",   %%xmm0\n\t"       /* our 4 pixels */                            \
    "movdqu  "PADDR2",   %%xmm1\n\t"       /* our pixel2 value */                        \
    "movdqa  %%xmm0,     %%xmm2\n\t"       /* another copy of our pixel1 value */        \
    "movdqa  %%xmm1,     %%xmm3\n\t"       /* another copy of our pixel1 value */        \
    "psubusb %%xmm1,     %%xmm2\n\t"                                                     \
    "psubusb %%xmm0,     %%xmm3\n\t"                                                     \
    "por     %%xmm3,     %%xmm2\n\t"                                                     \
    "pavgb   %%xmm1,     %%xmm0\n\t"       /* avg of 2 pixels */                         \
    "movdqa  %%xmm2,     %%xmm3\n\t"       /* another copy of our our weights */         \
    "pxor    %%xmm1,     %%xmm1\n\t"                                                     \
    "psubusb %%xmm7,     %%xmm3\n\t"       /* nonzero where old weights lower, else 0 */ \
    "pcmpeqb %%xmm1,     %%xmm3\n\t"       /* now ff where new better, else 00 */        \
    "pcmpeqb %%xmm3,     %%xmm1\n\t"       /* here ff where old better, else 00 */       \
    "pand    %%xmm3,     %%xmm0\n\t"       /* keep only better new pixels */             \
    "pand    %%xmm3,     %%xmm2\n\t"       /* and weights */                             \
    "pand    %%xmm1,     %%xmm5\n\t"       /* keep only better old pixels */             \
    "pand    %%xmm1,     %%xmm7\n\t"                                                     \
    "por     %%xmm0,     %%xmm5\n\t"       /* and merge new & old vals */                \
    "por     %%xmm2,     %%xmm7\n\t"

#define MERGE4PIXavgH(PADDR1A, PADDR1B, PADDR2A, PADDR2B)                                \
    "movdqu  "PADDR1A",   %%xmm0\n\t"      /* our 4 pixels */                            \
    "movdqu  "PADDR2A",   %%xmm1\n\t"      /* our pixel2 value */                        \
    "movdqu  "PADDR1B",   %%xmm2\n\t"      /* our 4 pixels */                            \
    "movdqu  "PADDR2B",   %%xmm3\n\t"      /* our pixel2 value */                        \
    "pavgb   %%xmm2,      %%xmm0\n\t"                                                    \
    "pavgb   %%xmm3,      %%xmm1\n\t"                                                    \
    "movdqa  %%xmm0,      %%xmm2\n\t"      /* another copy of our pixel1 value */        \
    "movdqa  %%xmm1,      %%xmm3\n\t"      /* another copy of our pixel1 value */        \
    "psubusb %%xmm1,      %%xmm2\n\t"                                                    \
    "psubusb %%xmm0,      %%xmm3\n\t"                                                    \
    "por     %%xmm3,      %%xmm2\n\t"                                                    \
    "pavgb   %%xmm1,      %%xmm0\n\t"      /* avg of 2 pixels */                         \
    "movdqa  %%xmm2,      %%xmm3\n\t"      /* another copy of our our weights */         \
    "pxor    %%xmm1,      %%xmm1\n\t"                                                    \
    "psubusb %%xmm7,      %%xmm3\n\t"      /* nonzero where old weights lower, else 0 */ \
    "pcmpeqb %%xmm1,      %%xmm3\n\t"      /* now ff where new better, else 00 */        \
    "pcmpeqb %%xmm3,      %%xmm1\n\t"      /* here ff where old better, else 00 */       \
    "pand    %%xmm3,      %%xmm0\n\t"      /* keep only better new pixels */             \
    "pand    %%xmm3,      %%xmm2\n\t"      /* and weights */                             \
    "pand    %%xmm1,      %%xmm5\n\t"      /* keep only better old pixels */             \
    "pand    %%xmm1,      %%xmm7\n\t"                                                    \
    "por     %%xmm0,      %%xmm5\n\t"      /* and merge new & old vals */                \
    "por     %%xmm2,      %%xmm7\n\t"

#define RESET_CHROMA "por "_UVMask", %%xmm7\n\t"

#else // ifdef IS_SSE2

#define MERGE4PIXavg(PADDR1, PADDR2)                                                    \
    "movq    "PADDR1",   %%mm0\n\t"       /* our 4 pixels */                            \
    "movq    "PADDR2",   %%mm1\n\t"       /* our pixel2 value */                        \
    "movq    %%mm0,      %%mm2\n\t"       /* another copy of our pixel1 value */        \
    "movq    %%mm1,      %%mm3\n\t"       /* another copy of our pixel1 value */        \
    "psubusb %%mm1,      %%mm2\n\t"                                                     \
    "psubusb %%mm0,      %%mm3\n\t"                                                     \
    "por     %%mm3,      %%mm2\n\t"                                                     \
    V_PAVGB ("%%mm0", "%%mm1", "%%mm3", _ShiftMask) /* avg of 2 pixels */               \
    "movq    %%mm2,      %%mm3\n\t"       /* another copy of our our weights */         \
    "pxor    %%mm1,      %%mm1\n\t"                                                     \
    "psubusb %%mm7,      %%mm3\n\t"       /* nonzero where old weights lower, else 0 */ \
    "pcmpeqb %%mm1,      %%mm3\n\t"       /* now ff where new better, else 00 */        \
    "pcmpeqb %%mm3,      %%mm1\n\t"       /* here ff where old better, else 00 */       \
    "pand    %%mm3,      %%mm0\n\t"       /* keep only better new pixels */             \
    "pand    %%mm3,      %%mm2\n\t"       /* and weights */                             \
    "pand    %%mm1,      %%mm5\n\t"       /* keep only better old pixels */             \
    "pand    %%mm1,      %%mm7\n\t"                                                     \
    "por     %%mm0,      %%mm5\n\t"       /* and merge new & old vals */                \
    "por     %%mm2,      %%mm7\n\t"

#define MERGE4PIXavgH(PADDR1A, PADDR1B, PADDR2A, PADDR2B)                               \
    "movq    "PADDR1A",   %%mm0\n\t"      /* our 4 pixels */                            \
    "movq    "PADDR2A",   %%mm1\n\t"      /* our pixel2 value */                        \
    "movq    "PADDR1B",   %%mm2\n\t"      /* our 4 pixels */                            \
    "movq    "PADDR2B",   %%mm3\n\t"      /* our pixel2 value */                        \
    V_PAVGB("%%mm0", "%%mm2", "%%mm2", _ShiftMask)                                      \
    V_PAVGB("%%mm1", "%%mm3", "%%mm3", _ShiftMask)                                      \
    "movq    %%mm0,       %%mm2\n\t"      /* another copy of our pixel1 value */        \
    "movq    %%mm1,       %%mm3\n\t"      /* another copy of our pixel1 value */        \
    "psubusb %%mm1,       %%mm2\n\t"                                                    \
    "psubusb %%mm0,       %%mm3\n\t"                                                    \
    "por     %%mm3,       %%mm2\n\t"                                                    \
    V_PAVGB("%%mm0", "%%mm1", "%%mm3", _ShiftMask)   /* avg of 2 pixels */              \
    "movq    %%mm2,       %%mm3\n\t"      /* another copy of our our weights */         \
    "pxor    %%mm1,       %%mm1\n\t"                                                    \
    "psubusb %%mm7,       %%mm3\n\t"      /* nonzero where old weights lower, else 0 */ \
    "pcmpeqb %%mm1,       %%mm3\n\t"      /* now ff where new better, else 00 */        \
    "pcmpeqb %%mm3,       %%mm1\n\t"      /* here ff where old better, else 00 */       \
    "pand    %%mm3,       %%mm0\n\t"      /* keep only better new pixels */             \
    "pand    %%mm3,       %%mm2\n\t"      /* and weights */                             \
    "pand    %%mm1,       %%mm5\n\t"      /* keep only better old pixels */             \
    "pand    %%mm1,       %%mm7\n\t"                                                    \
    "por     %%mm0,       %%mm5\n\t"      /* and merge new & old vals */                \
    "por     %%mm2,       %%mm7\n\t"

#define RESET_CHROMA "por "_UVMask", %%mm7\n\t"

#endif


