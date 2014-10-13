
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>
#include <orc/orconce.h>

#include "orcinternal.h"

/**
 * SECTION:orc
 * @title: Orc
 * @short_description: Library Initialization
 */

void _orc_debug_init(void);
void _orc_once_init(void);
void _orc_compiler_init(void);

/**
 * orc_init:
 * 
 * This function initializes the Orc library, and
 * should be called before using any other Orc function.
 * Subsequent calls to this function have no effect.
 */
void
orc_init (void)
{
  static volatile int inited = FALSE;

  if (!inited) {
    orc_global_mutex_lock ();
    if (!inited) {
      ORC_ASSERT(sizeof(OrcExecutor) == sizeof(OrcExecutorAlt));

      _orc_debug_init();
      _orc_compiler_init();
      orc_opcode_init();
      orc_c_init();
#ifdef ENABLE_BACKEND_C64X
      orc_c64x_c_init();
#endif
#ifdef ENABLE_BACKEND_MMX
      orc_mmx_init();
#endif
#ifdef ENABLE_BACKEND_SSE
      orc_sse_init();
#endif
#ifdef ENABLE_BACKEND_ALTIVEC
      orc_powerpc_init();
#endif
#ifdef ENABLE_BACKEND_ARM
      orc_arm_init();
#endif
#ifdef ENABLE_BACKEND_NEON
      orc_neon_init();
#endif
#ifdef ENABLE_BACKEND_MIPS
      orc_mips_init();
#endif

      inited = TRUE;
    }
    orc_global_mutex_unlock ();
  }
}

