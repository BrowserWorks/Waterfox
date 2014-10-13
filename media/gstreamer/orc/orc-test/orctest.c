/*
  Copyright 2002 - 2009 David A. Schleef <ds@schleef.org>
  Copyright 2012 MIPS Technologies, Inc.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.

*/

#include "config.h"

#include <orc-test/orctest.h>
#include <orc-test/orcarray.h>
#include <orc-test/orcrandom.h>
#include <orc-test/orcprofile.h>
#include <orc/orc.h>
#include <orc/orcdebug.h>


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifdef _MSC_VER
#define isnan(x) _isnan(x)
#define snprintf _snprintf
#endif

#define MIN_NONDENORMAL (1.1754944909521339405e-38)

void _orc_profile_init(void);

OrcRandomContext rand_context;

void
orc_test_init (void)
{
  orc_init ();

  setvbuf (stdout, NULL, _IONBF, 0);

  orc_random_init (&rand_context, 0x12345678);
  _orc_profile_init ();
}


OrcTestResult
orc_test_gcc_compile (OrcProgram *p)
{
  char cmd[300];
  char *base;
  char source_filename[100];
  char obj_filename[100];
  char dis_filename[100];
  char dump_filename[100];
  char dump_dis_filename[100];
  int ret;
  FILE *file;
  OrcCompileResult result;
  OrcTarget *target;
  unsigned int flags;
  int n;

  base = "temp-orc-test";

  n = snprintf(source_filename, sizeof(source_filename), "%s-source.s", base);
  ORC_ASSERT(n < sizeof(source_filename));
  n = snprintf(obj_filename, sizeof(obj_filename), "%s.o", base);
  ORC_ASSERT(n < sizeof(obj_filename));
  n = snprintf(dis_filename, sizeof(dis_filename), "%s-source.dis", base);
  ORC_ASSERT(n < sizeof(dis_filename));
  n = snprintf(dump_filename, sizeof(dump_filename), "%s-dump.bin", base);
  ORC_ASSERT(n < sizeof(dump_filename));
  n = snprintf(dump_dis_filename, sizeof(dump_dis_filename), "%s-dump.dis", base);
  ORC_ASSERT(n < sizeof(dump_dis_filename));

  target = orc_target_get_default ();
  flags = orc_target_get_default_flags (target);
  flags |= ORC_TARGET_CLEAN_COMPILE;
  if (strcmp (orc_target_get_name (target), "sse") == 0) {
    flags |= ORC_TARGET_SSE_SHORT_JUMPS;
  }
  if (strcmp (orc_target_get_name (target), "mmx") == 0) {
    flags |= ORC_TARGET_MMX_SHORT_JUMPS;
  }

  result = orc_program_compile_full (p, target, flags);
  if (ORC_COMPILE_RESULT_IS_FATAL(result)) {
    printf ("  error: %s\n", orc_program_get_error (p));
    return ORC_TEST_FAILED;
  }
  if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
    /* printf ("  no code generated: %s\n", orc_program_get_error (p)); */
    return ORC_TEST_INDETERMINATE;
  }

  fflush (stdout);

  file = fopen (source_filename, "w");
  fprintf(file, "%s", orc_program_get_asm_code (p));
  fclose (file);

  file = fopen (dump_filename, "w");
  ret = fwrite(p->orccode->code, p->orccode->code_size, 1, file);
  fclose (file);

#if defined(HAVE_POWERPC)
  n = snprintf (cmd, sizeof(cmd), "gcc -Wa,-mregnames -Wall -c %s -o %s", source_filename,
      obj_filename);
#else
  n = snprintf (cmd, sizeof(cmd), "gcc -Wall -c %s -o %s", source_filename,
      obj_filename);
#endif
  ORC_ASSERT(n < sizeof(cmd));
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("gcc failed");
    printf("%s\n", orc_program_get_asm_code (p));
    return ORC_TEST_FAILED;
  }

#if 1
  n = snprintf (cmd, sizeof(cmd), "objdump -dr %s | sed 's/^[ 0-9a-f]*:/XXX:/' >%s", obj_filename, dis_filename);
#else
  n = snprintf (cmd, sizeof(cmd), "objdump -dr %s >%s", obj_filename, dis_filename);
#endif
  ORC_ASSERT(n < sizeof(cmd));
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("objdump failed");
    return ORC_TEST_FAILED;
  }

  n = snprintf (cmd, sizeof(cmd), "objcopy -I binary "
#ifdef HAVE_I386
      "-O elf32-i386 -B i386 "
#elif defined(HAVE_AMD64)
      "-O elf64-x86-64 -B i386 "
#elif defined(HAVE_POWERPC)
      "-O elf32-powerpc -B powerpc "
#else
      /* FIXME */
#endif
      "--rename-section .data=.text "
      "--redefine-sym _binary_temp_orc_test_dump_bin_start=%s "
      "%s %s", p->name, dump_filename, obj_filename);
  ORC_ASSERT(n < sizeof(cmd));
  ret = system (cmd);
  if (ret != 0) {
    printf("objcopy failed\n");
    return ORC_TEST_FAILED;
  }

#if 1
  n = snprintf (cmd, sizeof(cmd), "objdump -Dr %s | sed 's/^[ 0-9a-f]*:/XXX:/' >%s", obj_filename, dump_dis_filename);
#else
  n = snprintf (cmd, sizeof(cmd), "objdump -Dr %s >%s", obj_filename, dump_dis_filename);
#endif
  ORC_ASSERT(n < sizeof(cmd));
  ret = system (cmd);
  if (ret != 0) {
    printf("objdump failed\n");
    return ORC_TEST_FAILED;
  }

  n = snprintf (cmd, sizeof(cmd), "diff -u %s %s", dis_filename, dump_dis_filename);
  ORC_ASSERT(n < sizeof(cmd));
  ret = system (cmd);
  if (ret != 0) {
    printf("diff failed\n");
    return ORC_TEST_FAILED;
  }

  remove (source_filename);
  remove (obj_filename);
  remove (dis_filename);
  remove (dump_filename);
  remove (dump_dis_filename);

  return ORC_TEST_OK;
}


#define PREFIX "/opt/arm-2008q3/bin/arm-none-linux-gnueabi-"

OrcTestResult
orc_test_gcc_compile_neon (OrcProgram *p)
{
  char cmd[300];
  char *base;
  char source_filename[100];
  char obj_filename[100];
  char dis_filename[100];
  char dump_filename[100];
  char dump_dis_filename[100];
  int ret;
  FILE *file;
  OrcCompileResult result;
  OrcTarget *target;
  unsigned int flags;

  base = "temp-orc-test";

  sprintf(source_filename, "%s-source.s", base);
  sprintf(obj_filename, "%s.o", base);
  sprintf(dis_filename, "%s-source.dis", base);
  sprintf(dump_filename, "%s-dump.bin", base);
  sprintf(dump_dis_filename, "%s-dump.dis", base);

  target = orc_target_get_by_name ("neon");
  flags = orc_target_get_default_flags (target);
  flags |= ORC_TARGET_CLEAN_COMPILE;

  result = orc_program_compile_full (p, target, flags);
  if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
    /* printf ("  no code generated: %s\n", orc_program_get_error (p)); */
    return ORC_TEST_INDETERMINATE;
  }

  fflush (stdout);

  file = fopen (source_filename, "w");
  fprintf(file, "%s", orc_program_get_asm_code (p));
  fclose (file);

  file = fopen (dump_filename, "w");
  ret = fwrite(p->orccode->code, p->orccode->code_size, 1, file);
  fclose (file);

  sprintf (cmd, PREFIX "gcc -march=armv6t2 -mcpu=cortex-a8 -mfpu=neon -Wall "
      "-c %s -o %s", source_filename, obj_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("arm gcc failed");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, PREFIX "objdump -dr %s >%s", obj_filename, dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("objdump failed");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, PREFIX "objcopy -I binary "
      "-O elf32-littlearm -B arm "
      "--rename-section .data=.text "
      "--redefine-sym _binary_temp_orc_test_dump_bin_start=%s "
      "%s %s", p->name, dump_filename, obj_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objcopy failed\n");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, PREFIX "objdump -Dr %s >%s", obj_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objdump failed\n");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, "diff -u %s %s", dis_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("diff failed\n");
    return ORC_TEST_FAILED;
  }

  remove (source_filename);
  remove (obj_filename);
  remove (dis_filename);
  remove (dump_filename);
  remove (dump_dis_filename);

  return ORC_TEST_OK;
}

#define C64X_PREFIX "/opt/TI/TI_CGT_C6000_6.1.12/bin/"

OrcTestResult
orc_test_gcc_compile_c64x (OrcProgram *p)
{
  char cmd[300];
  char *base;
  char source_filename[100];
  char obj_filename[100];
  char dis_filename[100];
  char dump_filename[100];
  char dump_dis_filename[100];
  int ret;
  FILE *file;
  OrcCompileResult result;
  OrcTarget *target;
  unsigned int flags;

  base = "temp-orc-test";

  sprintf(source_filename, "%s-source.c", base);
  sprintf(obj_filename, "%s-source.obj", base);
  sprintf(dis_filename, "%s-source.dis", base);
  sprintf(dump_filename, "%s-dump.bin", base);
  sprintf(dump_dis_filename, "%s-dump.dis", base);

  target = orc_target_get_by_name ("c64x-c");
  flags = orc_target_get_default_flags (target);

  result = orc_program_compile_full (p, target, flags);
  if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
    /* printf ("  no code generated: %s\n", orc_program_get_error (p)); */
    return ORC_TEST_INDETERMINATE;
  }

  fflush (stdout);

  file = fopen (source_filename, "w");
  fprintf(file, "%s", orc_target_get_preamble (target));
  fprintf(file, "%s", orc_program_get_asm_code (p));
  fclose (file);

  file = fopen (dump_filename, "w");
  ret = fwrite(p->orccode->code, p->orccode->code_size, 1, file);
  fclose (file);

  sprintf (cmd, C64X_PREFIX "cl6x -mv=6400+ "
      "-c %s", source_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("compiler failed");
    /* printf("%s\n", orc_program_get_asm_code (p)); */
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, C64X_PREFIX "dis6x %s >%s", obj_filename, dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("objdump failed");
    return ORC_TEST_INDETERMINATE;
  }

#if 0
  sprintf (cmd, C64X_PREFIX "objcopy -I binary "
      "-O elf32-littlearm -B arm "
      "--rename-section .data=.text "
      "--redefine-sym _binary_temp_orc_test_dump_bin_start=%s "
      "%s %s", p->name, dump_filename, obj_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objcopy failed\n");
    return ORC_TEST_FAILED;
  }
#endif

#if 0
  sprintf (cmd, C64X_PREFIX "dis6x %s >%s", dump_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objdump failed\n");
    return ORC_TEST_FAILED;
  }

  sprintf (cmd, "diff -u %s %s", dis_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("diff failed\n");
    return ORC_TEST_FAILED;
  }
#endif

  remove (source_filename);
  remove (obj_filename);
  remove (dis_filename);
  remove (dump_filename);
  remove (dump_dis_filename);

  return ORC_TEST_OK;
}

void
orc_test_random_bits (void *data, int n_bytes)
{
#if 1
  orc_uint8 *d = data;
  int i;
  for(i=0;i<n_bytes;i++){
    d[i] = rand();
  }
#endif
#if 0
  float *d = data;
  int i;
  for(i=0;i<n_bytes/4;i++){
    d[i] = ((rand() & 0xffff)-32768)*0.01;
  }
#endif
}

static orc_uint64
print_array_val_signed (OrcArray *array, int i, int j)
{
  void *ptr = ORC_PTR_OFFSET (array->data,
      i*array->element_size + j*array->stride);

  switch (array->element_size) {
    case 1:
      printf(" %4d", *(orc_int8 *)ptr);
      return *(orc_int8 *)ptr;
    case 2:
      printf(" %5d", *(orc_int16 *)ptr);
      return *(orc_int16 *)ptr;
    case 4:
      printf(" %10d", *(orc_int32 *)ptr);
      return *(orc_int32 *)ptr;
    case 8:
      printf(" 0x%08x%08x", (orc_uint32)((*(orc_uint64 *)ptr)>>32),
          (orc_uint32)((*(orc_uint64 *)ptr)));
      return *(orc_int64 *)ptr;
    default:
      return -1;
  }
}

#ifdef unused
static orc_uint64
print_array_val_unsigned (OrcArray *array, int i, int j)
{
  void *ptr = ORC_PTR_OFFSET (array->data,
      i*array->element_size + j*array->stride);

  switch (array->element_size) {
    case 1:
      printf(" %4u", *(orc_uint8 *)ptr);
      return *(orc_int8 *)ptr;
    case 2:
      printf(" %5u", *(orc_uint16 *)ptr);
      return *(orc_int16 *)ptr;
    case 4:
      printf(" %10u", *(orc_uint32 *)ptr);
      return *(orc_int32 *)ptr;
    case 8:
      printf(" 0x%08x%08x", (orc_uint32)((*(orc_uint64 *)ptr)>>32),
          (orc_uint32)((*(orc_uint64 *)ptr)));
      return *(orc_int64 *)ptr;
    default:
      return -1;
  }
}
#endif

static orc_uint64
print_array_val_hex (OrcArray *array, int i, int j)
{
  void *ptr = ORC_PTR_OFFSET (array->data,
      i*array->element_size + j*array->stride);

  switch (array->element_size) {
    case 1:
      printf(" %02x", *(orc_uint8 *)ptr);
      return *(orc_int8 *)ptr;
    case 2:
      printf(" %04x", *(orc_uint16 *)ptr);
      return *(orc_int16 *)ptr;
    case 4:
      printf(" %08x", *(orc_uint32 *)ptr);
      return *(orc_int32 *)ptr;
    case 8:
      printf(" 0x%08x%08x", (orc_uint32)((*(orc_uint64 *)ptr)>>32),
          (orc_uint32)((*(orc_uint64 *)ptr)));
      return *(orc_int64 *)ptr;
    default:
      return -1;
  }
}

static orc_uint64
print_array_val_float (OrcArray *array, int i, int j)
{
  void *ptr = ORC_PTR_OFFSET (array->data,
      i*array->element_size + j*array->stride);

  switch (array->element_size) {
    case 4:
      if (isnan(*(float *)ptr)) {
        printf(" nan %08x", *(orc_uint32 *)ptr);
        /* This is to get around signaling/non-signaling nans in the output */
        return (*(orc_uint32 *)ptr) & 0xffbfffff;
      } else {
        printf(" %12.5g", *(float *)ptr);
        return *(orc_int32 *)ptr;
      }
    case 8:
      printf(" %12.5g", *(double *)ptr);
      return *(orc_int64 *)ptr;
    default:
      printf(" ERROR");
      return -1;
  }
}

int
float_compare (OrcArray *array1, OrcArray *array2, int i, int j)
{
  void *ptr1 = ORC_PTR_OFFSET (array1->data,
      i*array1->element_size + j*array1->stride);
  void *ptr2 = ORC_PTR_OFFSET (array2->data,
      i*array2->element_size + j*array2->stride);

  switch (array1->element_size) {
    case 4:
      if (isnan(*(float *)ptr1) && isnan(*(float *)ptr2)) return TRUE;
      if (*(float *)ptr1 == *(float *)ptr2) return TRUE;
      if (fabs(*(float *)ptr1 - *(float *)ptr2) < MIN_NONDENORMAL) return TRUE;
      return FALSE;
    case 8:
      /* FIXME */
      return FALSE;
  }
  return FALSE;
}

OrcTestResult
orc_test_compare_output (OrcProgram *program)
{
  return orc_test_compare_output_full (program, 0);
}

OrcTestResult
orc_test_compare_output_backup (OrcProgram *program)
{
  return orc_test_compare_output_full (program, ORC_TEST_FLAGS_BACKUP);
}


OrcTestResult
orc_test_compare_output_full (OrcProgram *program, int flags)
{
  OrcExecutor *ex;
  int n;
  int m;
  OrcArray *dest_exec[4] = { NULL, NULL, NULL, NULL };
  OrcArray *dest_emul[4] = { NULL, NULL, NULL, NULL };
  OrcArray *src[8] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
  int i;
  int j;
  int k;
  int have_dest ORC_GNUC_UNUSED = FALSE;
  OrcCompileResult result;
  int have_acc = FALSE;
  int acc_exec = 0, acc_emul = 0;
  int ret = ORC_TEST_OK;
  int bad = 0;
  int misalignment;

  ORC_DEBUG ("got here");

  {
    OrcTarget *target;
    unsigned int flags;

    target = orc_target_get_default ();
    flags = orc_target_get_default_flags (target);

    result = orc_program_compile_full (program, target, flags);
    if (ORC_COMPILE_RESULT_IS_FATAL(result)) {
      ret = ORC_TEST_FAILED;
      goto out;
    }
    if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
      /* printf ("  no code generated: %s\n", orc_program_get_error (program)); */
      ret = ORC_TEST_INDETERMINATE;
      goto out;
    }
  }

  if (program->constant_n > 0) {
    n = program->constant_n;
  } else {
    n = 64 + (orc_random(&rand_context)&0xf);
  }

  ex = orc_executor_new (program);
  orc_executor_set_n (ex, n);
  if (program->is_2d) {
    if (program->constant_m > 0) {
      m = program->constant_m;
    } else {
      m = 8 + (orc_random(&rand_context)&0xf);
    }
  } else {
    m = 1;
  }
  orc_executor_set_m (ex, m);
  ORC_DEBUG("size %d %d", ex->n, ex->params[ORC_VAR_A1]);

  misalignment = 0;
  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].name == NULL) continue;

    if (program->vars[i].vartype == ORC_VAR_TYPE_SRC) {
      src[i-ORC_VAR_S1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_random (src[i-ORC_VAR_S1], &rand_context);
      misalignment++;
    } else if (program->vars[i].vartype == ORC_VAR_TYPE_DEST) {
      dest_exec[i-ORC_VAR_D1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_pattern (dest_exec[i], ORC_OOB_VALUE);
      dest_emul[i-ORC_VAR_D1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_pattern (dest_emul[i], ORC_OOB_VALUE);
      misalignment++;
    } else if (program->vars[i].vartype == ORC_VAR_TYPE_PARAM) {
      switch (program->vars[i].param_type) {
        case ORC_PARAM_TYPE_INT:
          orc_executor_set_param (ex, i, 2);
          break;
        case ORC_PARAM_TYPE_FLOAT:
          orc_executor_set_param_float (ex, i, 2.0);
          break;
        case ORC_PARAM_TYPE_INT64:
          orc_executor_set_param_int64 (ex, i, 2);
          break;
        case ORC_PARAM_TYPE_DOUBLE:
          orc_executor_set_param_double (ex, i, 2.0);
          break;
      }
    }
  }

  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].vartype == ORC_VAR_TYPE_DEST) {
      orc_executor_set_array (ex, i, dest_exec[i-ORC_VAR_D1]->data);
      orc_executor_set_stride (ex, i, dest_exec[i-ORC_VAR_D1]->stride);
      have_dest = TRUE;
    }
    if (program->vars[i].vartype == ORC_VAR_TYPE_SRC) {
      orc_executor_set_array (ex, i, src[i-ORC_VAR_S1]->data);
      orc_executor_set_stride (ex, i, src[i-ORC_VAR_S1]->stride);
    }
  }
  ORC_DEBUG ("running");
  if (flags & ORC_TEST_FLAGS_BACKUP) {
    orc_executor_run_backup (ex);
  } else {
    orc_executor_run (ex);
  }
  ORC_DEBUG ("done running");
  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].vartype == ORC_VAR_TYPE_ACCUMULATOR) {
      acc_exec = ex->accumulators[0];
      have_acc = TRUE;
    }
  }

  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].vartype == ORC_VAR_TYPE_DEST) {
      orc_executor_set_array (ex, i, dest_emul[i]->data);
      orc_executor_set_stride (ex, i, dest_emul[i]->stride);
    }
    if (program->vars[i].vartype == ORC_VAR_TYPE_SRC) {
      ORC_DEBUG("setting array %p", src[i-ORC_VAR_S1]->data);
      orc_executor_set_array (ex, i, src[i-ORC_VAR_S1]->data);
      orc_executor_set_stride (ex, i, src[i-ORC_VAR_S1]->stride);
    }
  }
  orc_executor_emulate (ex);
  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].vartype == ORC_VAR_TYPE_ACCUMULATOR) {
      acc_emul = ex->accumulators[0];
    }
  }

  for(k=ORC_VAR_D1;k<ORC_VAR_D1+4;k++){
    if (program->vars[k].size > 0) {
      if (!orc_array_compare (dest_exec[k-ORC_VAR_D1], dest_emul[k-ORC_VAR_D1], flags)) {
        printf("dest array %d bad\n", k);
        bad = TRUE;
      }
      if (!orc_array_check_out_of_bounds (dest_exec[k-ORC_VAR_D1])) {
        printf("out of bounds failure\n");

        ret = ORC_TEST_FAILED;
      }
    }
  }
  if (bad) {
    for(j=0;j<m;j++){
      for(i=0;i<n;i++){
        orc_uint64 a,b;
        int l;
        int line_bad = 0;

        printf("%2d %2d:", i, j);

        for(l=ORC_VAR_S1;l<ORC_VAR_S1+8;l++){
          if (program->vars[l].size > 0) {
            if (flags & ORC_TEST_FLAGS_FLOAT) {
              print_array_val_float (src[l-ORC_VAR_S1], i, j);
            } else {
              print_array_val_hex (src[l-ORC_VAR_S1], i, j);
            }
          }
        }

        printf(" ->");
        for(l=ORC_VAR_D1;l<ORC_VAR_D1+4;l++){
          if (program->vars[l].size > 0) {
            if (flags & ORC_TEST_FLAGS_FLOAT) {
              a = print_array_val_float (dest_emul[l-ORC_VAR_D1], i, j);
              b = print_array_val_float (dest_exec[l-ORC_VAR_D1], i, j);
              if (!float_compare (dest_emul[l-ORC_VAR_D1], dest_exec[l-ORC_VAR_D1], i, j) != 0) {
                line_bad = TRUE;
              }
            } else {
              a = print_array_val_hex (dest_emul[l-ORC_VAR_D1], i, j);
              b = print_array_val_hex (dest_exec[l-ORC_VAR_D1], i, j);
              if (a != b) {
                line_bad = TRUE;
              }
            }
          }
        }

        if (line_bad) {
          printf(" *");
        }

        printf("\n");
      }
    }

    ret = ORC_TEST_FAILED;
  }

  if (have_acc) {
    if (acc_emul != acc_exec) {
      for(j=0;j<m;j++){
        for(i=0;i<n;i++){

          printf("%2d %2d:", i, j);

          for(k=0;k<ORC_N_VARIABLES;k++){
            if (program->vars[k].name == NULL) continue;
            if (program->vars[k].vartype == ORC_VAR_TYPE_SRC &&
                program->vars[k].size > 0) {
              if (flags & ORC_TEST_FLAGS_FLOAT) {
                print_array_val_float (src[k-ORC_VAR_S1], i, j);
              } else {
                print_array_val_signed (src[k-ORC_VAR_S1], i, j);
              }
            }
          }

          printf(" -> acc\n");
        }
      }
      printf("acc %d %d\n", acc_emul, acc_exec);
      ret = ORC_TEST_FAILED;
    }
  }

  if (ret == ORC_TEST_FAILED) {
    printf("%s", orc_program_get_asm_code (program));
  }

  for(i=0;i<4;i++){
    if (dest_exec[i]) orc_array_free (dest_exec[i]);
    if (dest_emul[i]) orc_array_free (dest_emul[i]);
  }
  for(i=0;i<8;i++){
    if (src[i]) orc_array_free (src[i]);
  }

  orc_executor_free (ex);

out:
  orc_program_reset (program);

  return ret;
}

OrcProgram *
orc_test_get_program_for_opcode (OrcStaticOpcode *opcode)
{
  OrcProgram *p;
  char s[40];
  int flags ORC_GNUC_UNUSED = 0;
  int args[4] = { -1, -1, -1, -1 };
  int n_args = 0;

  p = orc_program_new ();
  if (opcode->flags & ORC_STATIC_OPCODE_ACCUMULATOR) {
    args[n_args++] =
      orc_program_add_accumulator (p, opcode->dest_size[0], "d1");
  } else {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[0], "d1");
  }
  if (opcode->dest_size[1] != 0) {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[1], "d2");
  }
  if (opcode->flags & ORC_STATIC_OPCODE_SCALAR) {
    if (opcode->src_size[1] == 0) {
      args[n_args++] =
        orc_program_add_constant (p, opcode->src_size[0], 1, "c1");
    } else {
      args[n_args++] =
        orc_program_add_source (p, opcode->src_size[0], "s1");
      args[n_args++] =
        orc_program_add_constant (p, opcode->src_size[1], 1, "c1");
      if (opcode->src_size[2] != 0) {
        args[n_args++] =
          orc_program_add_constant (p, opcode->src_size[1], 1, "c1");
      }
    }
  } else {
    args[n_args++] =
      orc_program_add_source (p, opcode->src_size[0], "s1");
    args[n_args++] =
      orc_program_add_source (p, opcode->src_size[1], "s2");
  }

  if ((opcode->flags & ORC_STATIC_OPCODE_FLOAT_SRC) ||
      (opcode->flags & ORC_STATIC_OPCODE_FLOAT_DEST)) {
    flags = ORC_TEST_FLAGS_FLOAT;
  }

  sprintf(s, "test_%s", opcode->name);
  orc_program_set_name (p, s);

  orc_program_append_2 (p, opcode->name, 0, args[0], args[1],
      args[2], args[3]);

  return p;
}

OrcProgram *
orc_test_get_program_for_opcode_const (OrcStaticOpcode *opcode)
{
  OrcProgram *p;
  char s[40];
  int args[4] = { -1, -1, -1, -1 };
  int flags ORC_GNUC_UNUSED;
  int n_args = 0;

  p = orc_program_new ();
  if (opcode->flags & ORC_STATIC_OPCODE_ACCUMULATOR) {
    args[n_args++] =
      orc_program_add_accumulator (p, opcode->dest_size[0], "d1");
  } else {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[0], "d1");
  }
  if (opcode->dest_size[1] != 0) {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[1], "d2");
  }
  if (opcode->src_size[1] == 0) {
    args[n_args++] =
      orc_program_add_constant (p, opcode->src_size[0], 1, "c1");
  } else {
    args[n_args++] =
      orc_program_add_source (p, opcode->src_size[0], "s1");
    args[n_args++] =
      orc_program_add_constant (p, opcode->src_size[1], 1, "c1");
    if (opcode->src_size[2]) {
      args[n_args++] =
        orc_program_add_constant (p, opcode->src_size[2], 1, "c2");
    }
  }

  if ((opcode->flags & ORC_STATIC_OPCODE_FLOAT_SRC) ||
      (opcode->flags & ORC_STATIC_OPCODE_FLOAT_DEST)) {
    flags = ORC_TEST_FLAGS_FLOAT;
  }

  sprintf(s, "test_const_%s", opcode->name);
  orc_program_set_name (p, s);

  orc_program_append_2 (p, opcode->name, 0, args[0], args[1],
      args[2], args[3]);

  return p;
}

OrcProgram *
orc_test_get_program_for_opcode_param (OrcStaticOpcode *opcode)
{
  OrcProgram *p;
  char s[40];
  int args[4] = { -1, -1, -1, -1 };
  int flags ORC_GNUC_UNUSED;
  int n_args = 0;

  if (opcode->src_size[1] == 0) {
    return NULL;
  }

  p = orc_program_new ();
  if (opcode->flags & ORC_STATIC_OPCODE_ACCUMULATOR) {
    args[n_args++] =
      orc_program_add_accumulator (p, opcode->dest_size[0], "d1");
  } else {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[0], "d1");
  }
  if (opcode->dest_size[1] != 0) {
    args[n_args++] =
      orc_program_add_destination (p, opcode->dest_size[1], "d2");
  }
  args[n_args++] =
    orc_program_add_source (p, opcode->src_size[0], "s1");
  args[n_args++] =
    orc_program_add_parameter (p, opcode->src_size[1], "p1");
  if (opcode->src_size[2]) {
    args[n_args++] =
      orc_program_add_parameter (p, opcode->src_size[2], "p2");
  }

  if ((opcode->flags & ORC_STATIC_OPCODE_FLOAT_SRC) ||
      (opcode->flags & ORC_STATIC_OPCODE_FLOAT_DEST)) {
    flags = ORC_TEST_FLAGS_FLOAT;
  }

  sprintf(s, "test_p_%s", opcode->name);
  orc_program_set_name (p, s);

  orc_program_append_2 (p, opcode->name, 0, args[0], args[1],
      args[2], args[3]);

  return p;
}

void
orc_test_performance (OrcProgram *program, int flags)
{
  orc_test_performance_full (program, flags, NULL);
}

double
orc_test_performance_full (OrcProgram *program, int flags,
    const char *target_name)
{
  OrcExecutor *ex;
  int n;
  int m;
  OrcArray *dest_exec[4] = { NULL, NULL, NULL, NULL };
  OrcArray *dest_emul[4] = { NULL, NULL, NULL, NULL };
  OrcArray *src[8] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
  int i, j;
  OrcCompileResult result;
  OrcProfile prof;
  double ave, std;
  OrcTarget *target;
  int misalignment;

  ORC_DEBUG ("got here");

  target = orc_target_get_by_name (target_name);

  if (!(flags & ORC_TEST_FLAGS_BACKUP)) {
    unsigned int flags;

    flags = orc_target_get_default_flags (target);

    result = orc_program_compile_full (program, target, flags);
    if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
      /* printf("compile failed\n"); */
      orc_program_reset (program);
      return 0;
    }
  }

  if (program->constant_n > 0) {
    n = program->constant_n;
  } else {
    /* n = 64 + (orc_random(&rand_context)&0xf); */
    n = 1000;
  }

  ex = orc_executor_new (program);
  orc_executor_set_n (ex, n);
  if (program->is_2d) {
    if (program->constant_m > 0) {
      m = program->constant_m;
    } else {
      m = 8 + (orc_random(&rand_context)&0xf);
    }
  } else {
    m = 1;
  }
  orc_executor_set_m (ex, m);
  ORC_DEBUG("size %d %d", ex->n, ex->params[ORC_VAR_A1]);

  misalignment = 0;
  for(i=0;i<ORC_N_VARIABLES;i++){
    if (program->vars[i].name == NULL) continue;

    if (program->vars[i].vartype == ORC_VAR_TYPE_SRC) {
      src[i-ORC_VAR_S1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_random (src[i-ORC_VAR_S1], &rand_context);
      misalignment++;
    } else if (program->vars[i].vartype == ORC_VAR_TYPE_DEST) {
      dest_exec[i-ORC_VAR_D1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_pattern (dest_exec[i], ORC_OOB_VALUE);
      dest_emul[i-ORC_VAR_D1] = orc_array_new (n, m, program->vars[i].size,
          misalignment, program->vars[i].alignment);
      orc_array_set_pattern (dest_emul[i], ORC_OOB_VALUE);
      misalignment++;
    } else if (program->vars[i].vartype == ORC_VAR_TYPE_PARAM) {
      orc_executor_set_param (ex, i, 2);
    }
  }

  ORC_DEBUG ("running");
  orc_profile_init (&prof);
  for(i=0;i<10;i++){
    orc_executor_set_n (ex, n);
    orc_executor_set_m (ex, m);
    for(j=0;j<ORC_N_VARIABLES;j++){
      if (program->vars[j].vartype == ORC_VAR_TYPE_DEST) {
        orc_executor_set_array (ex, j, dest_exec[j-ORC_VAR_D1]->data);
        orc_executor_set_stride (ex, j, dest_exec[j-ORC_VAR_D1]->stride);
      }
      if (program->vars[j].vartype == ORC_VAR_TYPE_SRC) {
        orc_executor_set_array (ex, j, src[j-ORC_VAR_S1]->data);
        orc_executor_set_stride (ex, j, src[j-ORC_VAR_S1]->stride);
      }
    }
    if (flags & ORC_TEST_FLAGS_BACKUP) {
      orc_profile_start (&prof);
      orc_executor_run_backup (ex);
      orc_profile_stop (&prof);
    } else if (flags & ORC_TEST_FLAGS_EMULATE) {
      orc_profile_start (&prof);
      orc_executor_emulate (ex);
      orc_profile_stop (&prof);
    } else {
      orc_profile_start (&prof);
      orc_executor_run (ex);
      orc_profile_stop (&prof);
    }
  }
  ORC_DEBUG ("done running");

  orc_profile_get_ave_std (&prof, &ave, &std);

  for(i=0;i<4;i++){
    if (dest_exec[i]) orc_array_free (dest_exec[i]);
    if (dest_emul[i]) orc_array_free (dest_emul[i]);
  }
  for(i=0;i<8;i++){
    if (src[i]) orc_array_free (src[i]);
  }

  orc_executor_free (ex);
  orc_program_reset (program);

  return ave/(n*m);
}

#define MIPS_PREFIX "mipsel-linux-gnu-"

OrcTestResult
orc_test_gcc_compile_mips (OrcProgram *p)
{
  char cmd[300];
  char *base;
  char source_filename[100];
  char obj_filename[100];
  char dis_filename[100];
  char dump_filename[100];
  char dump_dis_filename[100];
  int ret;
  FILE *file;
  OrcCompileResult result;
  OrcTarget *target;
  unsigned int flags;

  base = "temp-orc-test";

  sprintf(source_filename, "%s-source.s", base);
  sprintf(obj_filename, "%s.o", base);
  sprintf(dis_filename, "%s-source.dis", base);
  sprintf(dump_filename, "%s-dump.bin", base);
  sprintf(dump_dis_filename, "%s-dump.dis", base);

  target = orc_target_get_by_name ("mips");
  flags = orc_target_get_default_flags (target);
  flags |= ORC_TARGET_CLEAN_COMPILE;

  result = orc_program_compile_full (p, target, flags);
  if (!ORC_COMPILE_RESULT_IS_SUCCESSFUL(result)) {
    /* printf ("  no code generated: %s\n", orc_program_get_error (p)); */
    return ORC_TEST_INDETERMINATE;
  }

  fflush (stdout);

  file = fopen (source_filename, "w");
  fprintf(file, "%s", orc_target_get_preamble (target));
  fprintf(file, "%s", orc_program_get_asm_code (p));
  fclose (file);

  file = fopen (dump_filename, "w");
  ret = fwrite(p->orccode->code, p->orccode->code_size, 1, file);
  fclose (file);

  sprintf (cmd, MIPS_PREFIX "gcc -mips32r2 -mdspr2 -Wall "
      "-c %s -o %s", source_filename, obj_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("mips gcc failed");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, MIPS_PREFIX "objdump -Dr -j .text %s >%s", obj_filename, dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    ORC_ERROR ("objdump failed");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, MIPS_PREFIX "objcopy -I binary "
      "-O elf32-tradlittlemips -B mips:isa32r2 "
      "--rename-section .data=.text "
      "--redefine-sym _binary_temp_orc_test_dump_bin_start=%s "
      "%s %s", p->name, dump_filename, obj_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objcopy failed\n");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, MIPS_PREFIX "objdump -Dr %s >%s", obj_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("objdump failed\n");
    return ORC_TEST_INDETERMINATE;
  }

  sprintf (cmd, "diff -u %s %s", dis_filename, dump_dis_filename);
  ret = system (cmd);
  if (ret != 0) {
    printf("diff failed\n");
    return ORC_TEST_FAILED;
  }

  remove (source_filename);
  remove (obj_filename);
  remove (dis_filename);
  remove (dump_filename);
  remove (dump_dis_filename);

  return ORC_TEST_OK;
}

