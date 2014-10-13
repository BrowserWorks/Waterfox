
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <orc-test/orctest.h>
#include <orc-test/orcarray.h>
#include <orc-test/orcrandom.h>
#include <orc/orc.h>
#include <orc/orcutils.h>
#include <orc/orcdebug.h>

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

#ifdef HAVE_MMAP
#include <sys/mman.h>
#endif

#ifdef HAVE_MMAP
/* This can be used to test non-zero high-32-bits of pointers. */
/* #define USE_MMAP */
#endif

#define EXTEND_ROWS 16
#define EXTEND_STRIDE 256

#ifdef _MSC_VER
#define isnan(x) _isnan(x)
#endif

#define ALIGNMENT 64
#define MISALIGNMENT 0

OrcArray *
orc_array_new (int n, int m, int element_size, int misalignment,
    int alignment)
{
  OrcArray *ar;
  void *data;
#ifndef USE_MMAP
#ifdef HAVE_POSIX_MEMALIGN
  int ret;
#endif
#endif
  int offset;
#ifdef USE_MMAP
  static unsigned long idx = 1;
#endif

  ar = malloc (sizeof(OrcArray));
  memset (ar, 0, sizeof(OrcArray));

  ar->n = n;
  ar->m = m;
  ar->element_size = element_size;

  ar->stride = (n*element_size + EXTEND_STRIDE);
  ar->stride = (ar->stride + (ALIGNMENT-1)) & (~(ALIGNMENT-1));
  ar->alloc_len = ar->stride * (m+2*EXTEND_ROWS) + (ALIGNMENT * element_size);
  ar->alloc_len = (ar->alloc_len + 4095) & (~4095);

#ifdef USE_MMAP
  data = mmap ((void *)(idx<<32), ar->alloc_len, PROT_READ|PROT_WRITE,
      MAP_FIXED|MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  idx++;
  ar->alloc_data = data;
  ar->aligned_data = data;
#else
#ifdef HAVE_POSIX_MEMALIGN
  ret = posix_memalign (&data, ALIGNMENT, ar->alloc_len);
  ORC_ASSERT (ret == 0);
  ar->alloc_data = data;
  ar->aligned_data = data;
#else
  data = malloc (ar->alloc_len + ALIGNMENT);
  ar->alloc_data = data;
  ar->aligned_data = (void *)((((size_t)data) + (ALIGNMENT-1))&(~(ALIGNMENT-1)));
#endif
#endif

  if (alignment == 0) alignment = element_size;
  offset = (alignment * misalignment) & (ALIGNMENT - 1);

  ar->data = ORC_PTR_OFFSET (ar->aligned_data, ar->stride * EXTEND_ROWS + offset);

  return ar;
}

void
orc_array_free (OrcArray *array)
{
#ifdef USE_MMAP
  munmap (array->alloc_data, array->alloc_len);
#else
  free (array->alloc_data);
#endif
  free (array);
}

void
orc_array_set_pattern (OrcArray *array, int value)
{
  memset (array->aligned_data, value, array->alloc_len);
}

void
orc_array_set_random (OrcArray *array, OrcRandomContext *context)
{
  orc_random_bits (context, array->aligned_data, array->alloc_len);
}

#define CREATE_FLOAT(sign,exp,mant) (((sign)<<31)|((exp)<<23)|((mant)<<0))

static const orc_uint32 special_floats[] = {
  CREATE_FLOAT(0,0,0), /* 0 */
  CREATE_FLOAT(1,0,0), /* -0 */
  CREATE_FLOAT(0,126,0), /* 0.5 */
  CREATE_FLOAT(0,127,0), /* 1 */
  CREATE_FLOAT(0,128,0), /* 2 */
  CREATE_FLOAT(1,126,0), /* -0.5 */
  CREATE_FLOAT(1,127,0), /* -1 */
  CREATE_FLOAT(1,128,0), /* -2 */
  CREATE_FLOAT(0,255,0), /* infinity */
  CREATE_FLOAT(1,255,0), /* -infinity */
  CREATE_FLOAT(0,255,1), /* nan */
  CREATE_FLOAT(1,255,1), /* -nan */
  CREATE_FLOAT(0,0,1), /* denormal */
  CREATE_FLOAT(1,0,1), /* -denormal */
  CREATE_FLOAT(0,127+31,0), /* MAX_INT+1 */
  CREATE_FLOAT(0,127+30,0x7fffff), /* largest float < MAX_INT */
  CREATE_FLOAT(0,127+23,0x7fffff), /* largest non-integer float */
  CREATE_FLOAT(1,127+31,0), /* MIN_INT */
  CREATE_FLOAT(1,127+31,1), /* MIN_INT-1 */
  CREATE_FLOAT(1,127+30,0x7fffff), /* largest float >= MIN_INT */
  CREATE_FLOAT(1,127+23,0x7fffff), /* (negative) largest non-integer float */
  CREATE_FLOAT(0,127+14,(32767-16384)<<(23-14)), /* 32767 */
  CREATE_FLOAT(0,127+15,(0)<<(23-15)), /* 32768 */
  CREATE_FLOAT(0,127+15,(1)<<(23-15)), /* -32769 */
  CREATE_FLOAT(1,127+14,(32767-16384)<<(23-14)), /* -32767 */
  CREATE_FLOAT(1,127+15,(0)<<(23-15)), /* -32768 */
  CREATE_FLOAT(1,127+15,(1)<<(23-15)), /* -32769 */
  CREATE_FLOAT(0,127+4,(27-16)<<(23-4)), /* 27 */
  CREATE_FLOAT(0,127+4,(28-16)<<(23-4)), /* 28 */
  CREATE_FLOAT(0,127+4,(29-16)<<(23-4)), /* 29 */
  CREATE_FLOAT(0,127+4,(30-16)<<(23-4)), /* 30 */
  CREATE_FLOAT(0,127+4,(31-16)<<(23-4)), /* 31 */
};

void
orc_array_set_pattern_2 (OrcArray *array, OrcRandomContext *context,
    int type)
{
  int i,j;

  switch (type) {
    case ORC_PATTERN_RANDOM:
      orc_random_bits (context, array->aligned_data, array->alloc_len);
      break;
    case ORC_PATTERN_FLOAT_SMALL:
      {
        if (array->element_size != 4) return;
        for(j=0;j<array->m;j++){
          orc_union32 *data;
          int exp;

          data = ORC_PTR_OFFSET(array->data, array->stride * j);

          for(i=0;i<array->n;i++){
            data[i].i = orc_random (context);
            exp = (data[i].i & 0x7f80000) >> 23;
            exp &= 0xf;
            exp += 122;
            data[i].i &= ~0x7f800000;
            data[i].i |= (exp&0xff) << 23;
          }
        }
      }
      break;
    case ORC_PATTERN_FLOAT_SPECIAL:
      {
        if (array->element_size != 4) return;
        for(j=0;j<array->m;j++){
          orc_union32 *data;
          int x;

          data = ORC_PTR_OFFSET(array->data, array->stride * j);

          for(i=0;i<array->n;i++){
            x = i&0x1f;
            data[i].i = special_floats[x];
          }
        }
      }
      break;
    case ORC_PATTERN_FLOAT_DENORMAL:
      {
        if (array->element_size != 4) return;
        for(j=0;j<array->m;j++){
          orc_union32 *data;

          data = ORC_PTR_OFFSET(array->data, array->stride * j);

          for(i=0;i<array->n;i++){
            data[i].i = orc_random (context);
            data[i].i &= ~0x7f800000;
          }
        }
      }
      break;
    default:
      break;
  }
}

#define MIN_NONDENORMAL (1.1754944909521339405e-38)
#define MIN_NONDENORMAL_D (2.2250738585072014e-308)

int
orc_array_compare (OrcArray *array1, OrcArray *array2, int flags)
{
  if ((flags & ORC_TEST_FLAGS_FLOAT)) {
    if (array1->element_size == 4) {
      int j;
      for(j=0;j<array1->m;j++){
        float *a, *b;
        int i;

        a = ORC_PTR_OFFSET (array1->data, j*array1->stride);
        b = ORC_PTR_OFFSET (array2->data, j*array2->stride);

        for (i=0;i<array1->n;i++){
          if (isnan(a[i]) && isnan(b[i])) continue;
          if (a[i] == b[i]) continue;
          if (fabs(a[i] - b[i]) < MIN_NONDENORMAL) continue;
          return FALSE;
        }
      }
      return TRUE;
    } else if (array1->element_size == 8) {
      int j;
      for(j=0;j<array1->m;j++){
        double *a, *b;
        int i;

        a = ORC_PTR_OFFSET (array1->data, j*array1->stride);
        b = ORC_PTR_OFFSET (array2->data, j*array2->stride);

        for (i=0;i<array1->n;i++){
          if (isnan(a[i]) && isnan(b[i])) continue;
          if (a[i] == b[i]) continue;
          if (fabs(a[i] - b[i]) < MIN_NONDENORMAL_D) continue;
          return FALSE;
        }
      }
      return TRUE;
    }
  } else {
    if (memcmp (array1->aligned_data, array2->aligned_data,
          array1->alloc_len) == 0) {
      return TRUE;
    }
  }

  return FALSE;
}

int
orc_array_check_out_of_bounds (OrcArray *array)
{
  int i;
  int j;
  unsigned char *data;
  
  data = array->aligned_data;
  for(i=0;i<array->stride * EXTEND_ROWS;i++){
    if (data[i] != ORC_OOB_VALUE) {
      printf("OOB check failed at start-%d\n", array->stride * EXTEND_ROWS - i);
      return FALSE;
    }
  }

  for(j=0;j<array->m;j++){
    data = ORC_PTR_OFFSET(array->data, array->stride * j);
    for(i=array->element_size * array->n;i<array->stride;i++){
      if (data[i] != ORC_OOB_VALUE) {
        printf("OOB check failed on row %d, end+%d\n", j,
            i - array->element_size * array->n);
        return FALSE;
      }
    }
  }

  data = ORC_PTR_OFFSET (array->data, array->stride * array->m);
  for(i=0;i<array->stride * EXTEND_ROWS;i++){
    if (data[i] != ORC_OOB_VALUE) {
      printf("OOB check failed at end+%d\n", i);
      return FALSE;
    }
  }

  return TRUE;
}

#if 0
void
orc_array_print_compare (OrcArray *array1, OrcArray *array2)
{

  for(j=0;j<array1->m;j++){
    for(i=0;i<array1->n;i++){
      int a,b;
      int j;

      printf("%2d %2d:", i, j);

      for(k=0;k<ORC_N_VARIABLES;k++){
        if (program->vars[k].name == NULL) continue;
        if (program->vars[k].vartype == ORC_VAR_TYPE_SRC &&
            program->vars[k].size > 0) {
          print_array_val_signed (ex->arrays[k], program->vars[k].size, i);
        }
      }

      printf(" ->");
      a = print_array_val_signed (dest_emul[k], program->vars[k].size, i);
      b = print_array_val_signed (dest_exec[k], program->vars[k].size, i);

      if (a != b) {
        printf(" *");
      }

      printf("\n");
    }
  }
}
#endif

