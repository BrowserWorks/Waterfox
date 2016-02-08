// This is a fix for
// https://software.intel.com/en-us/articles/limits1120-error-identifier-builtin-nanf-is-undefined
// Force-included into compilation with /FI.

#define __builtin_huge_val() HUGE_VAL
#define __builtin_huge_valf() HUGE_VALF
#define __builtin_nan(p) NAN
#define __builtin_nanf(p) NAN
#define __builtin_nans(p) NAN
#define __builtin_nansf(p) NAN
