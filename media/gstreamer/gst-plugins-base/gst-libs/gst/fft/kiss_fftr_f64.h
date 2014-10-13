#ifndef KISS_FTR_F64_H
#define KISS_FTR_F64_H

#include "kiss_fft_f64.h"
#ifdef __cplusplus
extern "C" {
#endif

    
/* 
 
 Real optimized version can save about 45% cpu time vs. complex fft of a real seq.

 
 
 */

typedef struct kiss_fftr_f64_state *kiss_fftr_f64_cfg;


kiss_fftr_f64_cfg kiss_fftr_f64_alloc(int nfft,int inverse_fft,void * mem, size_t * lenmem);
/*
 nfft must be even

 If you don't care to allocate space, use mem = lenmem = NULL 
*/


void kiss_fftr_f64(kiss_fftr_f64_cfg cfg,const kiss_fft_f64_scalar *timedata,kiss_fft_f64_cpx *freqdata);
/*
 input timedata has nfft scalar points
 output freqdata has nfft/2+1 complex points
*/

void kiss_fftri_f64(kiss_fftr_f64_cfg cfg,const kiss_fft_f64_cpx *freqdata,kiss_fft_f64_scalar *timedata);
/*
 input freqdata has  nfft/2+1 complex points
 output timedata has nfft scalar points
*/

#define kiss_fftr_f64_free free

#ifdef __cplusplus
}
#endif
#endif
