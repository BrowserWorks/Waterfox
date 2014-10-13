/* GLIB - Library of useful routines for C programming
 * Copyright (C) 1995-1997  Peter Mattis, Spencer Kimball and Josh MacDonald
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/*
 * Modified by the GLib Team and others 1997-2000.  See the AUTHORS
 * file for a list of people on the GLib Team.  See the ChangeLog
 * files for a list of changes.  These files are distributed with
 * GLib at ftp://ftp.gtk.org/pub/gtk/. 
 */

/* 
 * MT safe
 */

#include "config.h"

#include "gmem.h"

#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "glib-init.h"

#include "gslice.h"
#include "gbacktrace.h"
#include "gtestutils.h"
#include "gthread.h"
#include "glib_trace.h"

#define MEM_PROFILE_TABLE_SIZE 4096


/* notes on macros:
 * having G_DISABLE_CHECKS defined disables use of glib_mem_profiler_table and
 * g_mem_profile().
 * If g_mem_gc_friendly is TRUE, freed memory should be 0-wiped.
 */

/* --- variables --- */
static GMemVTable glib_mem_vtable = {
  malloc,
  realloc,
  free,
  calloc,
  malloc,
  realloc,
};

/**
 * SECTION:memory
 * @Short_Description: general memory-handling
 * @Title: Memory Allocation
 * 
 * These functions provide support for allocating and freeing memory.
 * 
 * <note>
 * If any call to allocate memory fails, the application is terminated.
 * This also means that there is no need to check if the call succeeded.
 * </note>
 * 
 * <note>
 * It's important to match g_malloc() with g_free(), plain malloc() with free(),
 * and (if you're using C++) new with delete and new[] with delete[]. Otherwise
 * bad things can happen, since these allocators may use different memory
 * pools (and new/delete call constructors and destructors). See also
 * g_mem_set_vtable().
 * </note>
 */

/* --- functions --- */
/**
 * g_malloc:
 * @n_bytes: the number of bytes to allocate
 * 
 * Allocates @n_bytes bytes of memory.
 * If @n_bytes is 0 it returns %NULL.
 * 
 * Returns: a pointer to the allocated memory
 */
gpointer
g_malloc (gsize n_bytes)
{
  if (G_LIKELY (n_bytes))
    {
      gpointer mem;

      mem = glib_mem_vtable.malloc (n_bytes);
      TRACE (GLIB_MEM_ALLOC((void*) mem, (unsigned int) n_bytes, 0, 0));
      if (mem)
	return mem;

      g_error ("%s: failed to allocate %"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_bytes);
    }

  TRACE(GLIB_MEM_ALLOC((void*) NULL, (int) n_bytes, 0, 0));

  return NULL;
}

/**
 * g_malloc0:
 * @n_bytes: the number of bytes to allocate
 * 
 * Allocates @n_bytes bytes of memory, initialized to 0's.
 * If @n_bytes is 0 it returns %NULL.
 * 
 * Returns: a pointer to the allocated memory
 */
gpointer
g_malloc0 (gsize n_bytes)
{
  if (G_LIKELY (n_bytes))
    {
      gpointer mem;

      mem = glib_mem_vtable.calloc (1, n_bytes);
      TRACE (GLIB_MEM_ALLOC((void*) mem, (unsigned int) n_bytes, 1, 0));
      if (mem)
	return mem;

      g_error ("%s: failed to allocate %"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_bytes);
    }

  TRACE(GLIB_MEM_ALLOC((void*) NULL, (int) n_bytes, 1, 0));

  return NULL;
}

/**
 * g_realloc:
 * @mem: the memory to reallocate
 * @n_bytes: new size of the memory in bytes
 * 
 * Reallocates the memory pointed to by @mem, so that it now has space for
 * @n_bytes bytes of memory. It returns the new address of the memory, which may
 * have been moved. @mem may be %NULL, in which case it's considered to
 * have zero-length. @n_bytes may be 0, in which case %NULL will be returned
 * and @mem will be freed unless it is %NULL.
 * 
 * Returns: the new address of the allocated memory
 */
gpointer
g_realloc (gpointer mem,
	   gsize    n_bytes)
{
  gpointer newmem;

  if (G_LIKELY (n_bytes))
    {
      newmem = glib_mem_vtable.realloc (mem, n_bytes);
      TRACE (GLIB_MEM_REALLOC((void*) newmem, (void*)mem, (unsigned int) n_bytes, 0));
      if (newmem)
	return newmem;

      g_error ("%s: failed to allocate %"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_bytes);
    }

  if (mem)
    glib_mem_vtable.free (mem);

  TRACE (GLIB_MEM_REALLOC((void*) NULL, (void*)mem, 0, 0));

  return NULL;
}

/**
 * g_free:
 * @mem: the memory to free
 * 
 * Frees the memory pointed to by @mem.
 * If @mem is %NULL it simply returns.
 */
void
g_free (gpointer mem)
{
  if (G_LIKELY (mem))
    glib_mem_vtable.free (mem);
  TRACE(GLIB_MEM_FREE((void*) mem));
}

/**
 * g_clear_pointer: (skip)
 * @pp: a pointer to a variable, struct member etc. holding a pointer
 * @destroy: a function to which a gpointer can be passed, to destroy *@pp
 *
 * Clears a reference to a variable.
 *
 * @pp must not be %NULL.
 *
 * If the reference is %NULL then this function does nothing.
 * Otherwise, the variable is destroyed using @destroy and the
 * pointer is set to %NULL.
 *
 * This function is threadsafe and modifies the pointer atomically,
 * using memory barriers where needed.
 *
 * A macro is also included that allows this function to be used without
 * pointer casts.
 *
 * Since: 2.34
 **/
#undef g_clear_pointer
void
g_clear_pointer (gpointer      *pp,
                 GDestroyNotify destroy)
{
  gpointer _p;

  /* This is a little frustrating.
   * Would be nice to have an atomic exchange (with no compare).
   */
  do
    _p = g_atomic_pointer_get (pp);
  while G_UNLIKELY (!g_atomic_pointer_compare_and_exchange (pp, _p, NULL));

  if (_p)
    destroy (_p);
}

/**
 * g_try_malloc:
 * @n_bytes: number of bytes to allocate.
 * 
 * Attempts to allocate @n_bytes, and returns %NULL on failure.
 * Contrast with g_malloc(), which aborts the program on failure.
 * 
 * Returns: the allocated memory, or %NULL.
 */
gpointer
g_try_malloc (gsize n_bytes)
{
  gpointer mem;

  if (G_LIKELY (n_bytes))
    mem = glib_mem_vtable.try_malloc (n_bytes);
  else
    mem = NULL;

  TRACE (GLIB_MEM_ALLOC((void*) mem, (unsigned int) n_bytes, 0, 1));

  return mem;
}

/**
 * g_try_malloc0:
 * @n_bytes: number of bytes to allocate
 * 
 * Attempts to allocate @n_bytes, initialized to 0's, and returns %NULL on
 * failure. Contrast with g_malloc0(), which aborts the program on failure.
 * 
 * Since: 2.8
 * Returns: the allocated memory, or %NULL
 */
gpointer
g_try_malloc0 (gsize n_bytes)
{
  gpointer mem;

  if (G_LIKELY (n_bytes))
    mem = glib_mem_vtable.try_malloc (n_bytes);
  else
    mem = NULL;

  if (mem)
    memset (mem, 0, n_bytes);

  return mem;
}

/**
 * g_try_realloc:
 * @mem: (allow-none): previously-allocated memory, or %NULL.
 * @n_bytes: number of bytes to allocate.
 * 
 * Attempts to realloc @mem to a new size, @n_bytes, and returns %NULL
 * on failure. Contrast with g_realloc(), which aborts the program
 * on failure. If @mem is %NULL, behaves the same as g_try_malloc().
 * 
 * Returns: the allocated memory, or %NULL.
 */
gpointer
g_try_realloc (gpointer mem,
	       gsize    n_bytes)
{
  gpointer newmem;

  if (G_LIKELY (n_bytes))
    newmem = glib_mem_vtable.try_realloc (mem, n_bytes);
  else
    {
      newmem = NULL;
      if (mem)
	glib_mem_vtable.free (mem);
    }

  TRACE (GLIB_MEM_REALLOC((void*) newmem, (void*)mem, (unsigned int) n_bytes, 1));

  return newmem;
}


#define SIZE_OVERFLOWS(a,b) (G_UNLIKELY ((b) > 0 && (a) > G_MAXSIZE / (b)))

/**
 * g_malloc_n:
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_malloc(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: a pointer to the allocated memory
 */
gpointer
g_malloc_n (gsize n_blocks,
	    gsize n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    {
      g_error ("%s: overflow allocating %"G_GSIZE_FORMAT"*%"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_blocks, n_block_bytes);
    }

  return g_malloc (n_blocks * n_block_bytes);
}

/**
 * g_malloc0_n:
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_malloc0(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: a pointer to the allocated memory
 */
gpointer
g_malloc0_n (gsize n_blocks,
	     gsize n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    {
      g_error ("%s: overflow allocating %"G_GSIZE_FORMAT"*%"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_blocks, n_block_bytes);
    }

  return g_malloc0 (n_blocks * n_block_bytes);
}

/**
 * g_realloc_n:
 * @mem: the memory to reallocate
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_realloc(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: the new address of the allocated memory
 */
gpointer
g_realloc_n (gpointer mem,
	     gsize    n_blocks,
	     gsize    n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    {
      g_error ("%s: overflow allocating %"G_GSIZE_FORMAT"*%"G_GSIZE_FORMAT" bytes",
               G_STRLOC, n_blocks, n_block_bytes);
    }

  return g_realloc (mem, n_blocks * n_block_bytes);
}

/**
 * g_try_malloc_n:
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_try_malloc(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: the allocated memory, or %NULL.
 */
gpointer
g_try_malloc_n (gsize n_blocks,
		gsize n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    return NULL;

  return g_try_malloc (n_blocks * n_block_bytes);
}

/**
 * g_try_malloc0_n:
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_try_malloc0(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: the allocated memory, or %NULL
 */
gpointer
g_try_malloc0_n (gsize n_blocks,
		 gsize n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    return NULL;

  return g_try_malloc0 (n_blocks * n_block_bytes);
}

/**
 * g_try_realloc_n:
 * @mem: (allow-none): previously-allocated memory, or %NULL.
 * @n_blocks: the number of blocks to allocate
 * @n_block_bytes: the size of each block in bytes
 * 
 * This function is similar to g_try_realloc(), allocating (@n_blocks * @n_block_bytes) bytes,
 * but care is taken to detect possible overflow during multiplication.
 * 
 * Since: 2.24
 * Returns: the allocated memory, or %NULL.
 */
gpointer
g_try_realloc_n (gpointer mem,
		 gsize    n_blocks,
		 gsize    n_block_bytes)
{
  if (SIZE_OVERFLOWS (n_blocks, n_block_bytes))
    return NULL;

  return g_try_realloc (mem, n_blocks * n_block_bytes);
}



static gpointer
fallback_calloc (gsize n_blocks,
		 gsize n_block_bytes)
{
  gsize l = n_blocks * n_block_bytes;
  gpointer mem = glib_mem_vtable.malloc (l);

  if (mem)
    memset (mem, 0, l);

  return mem;
}

static gboolean vtable_set = FALSE;

/**
 * g_mem_is_system_malloc:
 * 
 * Checks whether the allocator used by g_malloc() is the system's
 * malloc implementation. If it returns %TRUE memory allocated with
 * malloc() can be used interchangeable with memory allocated using g_malloc().
 * This function is useful for avoiding an extra copy of allocated memory returned
 * by a non-GLib-based API.
 *
 * A different allocator can be set using g_mem_set_vtable().
 *
 * Return value: if %TRUE, malloc() and g_malloc() can be mixed.
 **/
gboolean
g_mem_is_system_malloc (void)
{
  return !vtable_set;
}

/**
 * g_mem_set_vtable:
 * @vtable: table of memory allocation routines.
 * 
 * Sets the #GMemVTable to use for memory allocation. You can use this to provide
 * custom memory allocation routines. <emphasis>This function must be called
 * before using any other GLib functions.</emphasis> The @vtable only needs to
 * provide malloc(), realloc(), and free() functions; GLib can provide default
 * implementations of the others. The malloc() and realloc() implementations
 * should return %NULL on failure, GLib will handle error-checking for you.
 * @vtable is copied, so need not persist after this function has been called.
 */
void
g_mem_set_vtable (GMemVTable *vtable)
{
  if (!vtable_set)
    {
      if (vtable->malloc && vtable->realloc && vtable->free)
	{
	  glib_mem_vtable.malloc = vtable->malloc;
	  glib_mem_vtable.realloc = vtable->realloc;
	  glib_mem_vtable.free = vtable->free;
	  glib_mem_vtable.calloc = vtable->calloc ? vtable->calloc : fallback_calloc;
	  glib_mem_vtable.try_malloc = vtable->try_malloc ? vtable->try_malloc : glib_mem_vtable.malloc;
	  glib_mem_vtable.try_realloc = vtable->try_realloc ? vtable->try_realloc : glib_mem_vtable.realloc;
	  vtable_set = TRUE;
	}
      else
	g_warning (G_STRLOC ": memory allocation vtable lacks one of malloc(), realloc() or free()");
    }
  else
    g_warning (G_STRLOC ": memory allocation vtable can only be set once at startup");
}


/* --- memory profiling and checking --- */
#ifdef	G_DISABLE_CHECKS
/**
 * glib_mem_profiler_table:
 * 
 * A #GMemVTable containing profiling variants of the memory
 * allocation functions. Use them together with g_mem_profile()
 * in order to get information about the memory allocation pattern
 * of your program.
 */
GMemVTable *glib_mem_profiler_table = &glib_mem_vtable;
void
g_mem_profile (void)
{
}
#else	/* !G_DISABLE_CHECKS */
typedef enum {
  PROFILER_FREE		= 0,
  PROFILER_ALLOC	= 1,
  PROFILER_RELOC	= 2,
  PROFILER_ZINIT	= 4
} ProfilerJob;
static guint *profile_data = NULL;
static gsize profile_allocs = 0;
static gsize profile_zinit = 0;
static gsize profile_frees = 0;
static GMutex gmem_profile_mutex;
#ifdef  G_ENABLE_DEBUG
static volatile gsize g_trap_free_size = 0;
static volatile gsize g_trap_realloc_size = 0;
static volatile gsize g_trap_malloc_size = 0;
#endif  /* G_ENABLE_DEBUG */

#define	PROFILE_TABLE(f1,f2,f3)   ( ( ((f3) << 2) | ((f2) << 1) | (f1) ) * (MEM_PROFILE_TABLE_SIZE + 1))

static void
profiler_log (ProfilerJob job,
	      gsize       n_bytes,
	      gboolean    success)
{
  g_mutex_lock (&gmem_profile_mutex);
  if (!profile_data)
    {
      profile_data = calloc ((MEM_PROFILE_TABLE_SIZE + 1) * 8, 
                             sizeof (profile_data[0]));
      if (!profile_data)	/* memory system kiddin' me, eh? */
	{
	  g_mutex_unlock (&gmem_profile_mutex);
	  return;
	}
    }

  if (n_bytes < MEM_PROFILE_TABLE_SIZE)
    profile_data[n_bytes + PROFILE_TABLE ((job & PROFILER_ALLOC) != 0,
                                          (job & PROFILER_RELOC) != 0,
                                          success != 0)] += 1;
  else
    profile_data[MEM_PROFILE_TABLE_SIZE + PROFILE_TABLE ((job & PROFILER_ALLOC) != 0,
                                                         (job & PROFILER_RELOC) != 0,
                                                         success != 0)] += 1;
  if (success)
    {
      if (job & PROFILER_ALLOC)
        {
          profile_allocs += n_bytes;
          if (job & PROFILER_ZINIT)
            profile_zinit += n_bytes;
        }
      else
        profile_frees += n_bytes;
    }
  g_mutex_unlock (&gmem_profile_mutex);
}

static void
profile_print_locked (guint   *local_data,
		      gboolean success)
{
  gboolean need_header = TRUE;
  guint i;

  for (i = 0; i <= MEM_PROFILE_TABLE_SIZE; i++)
    {
      glong t_malloc = local_data[i + PROFILE_TABLE (1, 0, success)];
      glong t_realloc = local_data[i + PROFILE_TABLE (1, 1, success)];
      glong t_free = local_data[i + PROFILE_TABLE (0, 0, success)];
      glong t_refree = local_data[i + PROFILE_TABLE (0, 1, success)];
      
      if (!t_malloc && !t_realloc && !t_free && !t_refree)
	continue;
      else if (need_header)
	{
	  need_header = FALSE;
	  g_print (" blocks of | allocated  | freed      | allocated  | freed      | n_bytes   \n");
	  g_print ("  n_bytes  | n_times by | n_times by | n_times by | n_times by | remaining \n");
	  g_print ("           | malloc()   | free()     | realloc()  | realloc()  |           \n");
	  g_print ("===========|============|============|============|============|===========\n");
	}
      if (i < MEM_PROFILE_TABLE_SIZE)
	g_print ("%10u | %10ld | %10ld | %10ld | %10ld |%+11ld\n",
		 i, t_malloc, t_free, t_realloc, t_refree,
		 (t_malloc - t_free + t_realloc - t_refree) * i);
      else if (i >= MEM_PROFILE_TABLE_SIZE)
	g_print ("   >%6u | %10ld | %10ld | %10ld | %10ld |        ***\n",
		 i, t_malloc, t_free, t_realloc, t_refree);
    }
  if (need_header)
    g_print (" --- none ---\n");
}

/**
 * g_mem_profile:
 * 
 * Outputs a summary of memory usage.
 * 
 * It outputs the frequency of allocations of different sizes,
 * the total number of bytes which have been allocated,
 * the total number of bytes which have been freed,
 * and the difference between the previous two values, i.e. the number of bytes
 * still in use.
 * 
 * Note that this function will not output anything unless you have
 * previously installed the #glib_mem_profiler_table with g_mem_set_vtable().
 */

void
g_mem_profile (void)
{
  guint local_data[(MEM_PROFILE_TABLE_SIZE + 1) * 8];
  gsize local_allocs;
  gsize local_zinit;
  gsize local_frees;

  g_mutex_lock (&gmem_profile_mutex);

  local_allocs = profile_allocs;
  local_zinit = profile_zinit;
  local_frees = profile_frees;

  if (!profile_data)
    {
      g_mutex_unlock (&gmem_profile_mutex);
      return;
    }

  memcpy (local_data, profile_data, 
	  (MEM_PROFILE_TABLE_SIZE + 1) * 8 * sizeof (profile_data[0]));
  
  g_mutex_unlock (&gmem_profile_mutex);

  g_print ("GLib Memory statistics (successful operations):\n");
  profile_print_locked (local_data, TRUE);
  g_print ("GLib Memory statistics (failing operations):\n");
  profile_print_locked (local_data, FALSE);
  g_print ("Total bytes: allocated=%"G_GSIZE_FORMAT", "
           "zero-initialized=%"G_GSIZE_FORMAT" (%.2f%%), "
           "freed=%"G_GSIZE_FORMAT" (%.2f%%), "
           "remaining=%"G_GSIZE_FORMAT"\n",
	   local_allocs,
	   local_zinit,
	   ((gdouble) local_zinit) / local_allocs * 100.0,
	   local_frees,
	   ((gdouble) local_frees) / local_allocs * 100.0,
	   local_allocs - local_frees);
}

static gpointer
profiler_try_malloc (gsize n_bytes)
{
  gsize *p;

#ifdef  G_ENABLE_DEBUG
  if (g_trap_malloc_size == n_bytes)
    G_BREAKPOINT ();
#endif  /* G_ENABLE_DEBUG */

  p = malloc (sizeof (gsize) * 2 + n_bytes);

  if (p)
    {
      p[0] = 0;		/* free count */
      p[1] = n_bytes;	/* length */
      profiler_log (PROFILER_ALLOC, n_bytes, TRUE);
      p += 2;
    }
  else
    profiler_log (PROFILER_ALLOC, n_bytes, FALSE);
  
  return p;
}

static gpointer
profiler_malloc (gsize n_bytes)
{
  gpointer mem = profiler_try_malloc (n_bytes);

  if (!mem)
    g_mem_profile ();

  return mem;
}

static gpointer
profiler_calloc (gsize n_blocks,
		 gsize n_block_bytes)
{
  gsize l = n_blocks * n_block_bytes;
  gsize *p;

#ifdef  G_ENABLE_DEBUG
  if (g_trap_malloc_size == l)
    G_BREAKPOINT ();
#endif  /* G_ENABLE_DEBUG */
  
  p = calloc (1, sizeof (gsize) * 2 + l);

  if (p)
    {
      p[0] = 0;		/* free count */
      p[1] = l;		/* length */
      profiler_log (PROFILER_ALLOC | PROFILER_ZINIT, l, TRUE);
      p += 2;
    }
  else
    {
      profiler_log (PROFILER_ALLOC | PROFILER_ZINIT, l, FALSE);
      g_mem_profile ();
    }

  return p;
}

static void
profiler_free (gpointer mem)
{
  gsize *p = mem;

  p -= 2;
  if (p[0])	/* free count */
    {
      g_warning ("free(%p): memory has been freed %"G_GSIZE_FORMAT" times already",
                 p + 2, p[0]);
      profiler_log (PROFILER_FREE,
		    p[1],	/* length */
		    FALSE);
    }
  else
    {
#ifdef  G_ENABLE_DEBUG
      if (g_trap_free_size == p[1])
	G_BREAKPOINT ();
#endif  /* G_ENABLE_DEBUG */

      profiler_log (PROFILER_FREE,
		    p[1],	/* length */
		    TRUE);
      memset (p + 2, 0xaa, p[1]);

      /* for all those that miss free (p); in this place, yes,
       * we do leak all memory when profiling, and that is intentional
       * to catch double frees. patch submissions are futile.
       */
    }
  p[0] += 1;
}

static gpointer
profiler_try_realloc (gpointer mem,
		      gsize    n_bytes)
{
  gsize *p = mem;

  p -= 2;

#ifdef  G_ENABLE_DEBUG
  if (g_trap_realloc_size == n_bytes)
    G_BREAKPOINT ();
#endif  /* G_ENABLE_DEBUG */
  
  if (mem && p[0])	/* free count */
    {
      g_warning ("realloc(%p, %"G_GSIZE_FORMAT"): "
                 "memory has been freed %"G_GSIZE_FORMAT" times already",
                 p + 2, (gsize) n_bytes, p[0]);
      profiler_log (PROFILER_ALLOC | PROFILER_RELOC, n_bytes, FALSE);

      return NULL;
    }
  else
    {
      p = realloc (mem ? p : NULL, sizeof (gsize) * 2 + n_bytes);

      if (p)
	{
	  if (mem)
	    profiler_log (PROFILER_FREE | PROFILER_RELOC, p[1], TRUE);
	  p[0] = 0;
	  p[1] = n_bytes;
	  profiler_log (PROFILER_ALLOC | PROFILER_RELOC, p[1], TRUE);
	  p += 2;
	}
      else
	profiler_log (PROFILER_ALLOC | PROFILER_RELOC, n_bytes, FALSE);

      return p;
    }
}

static gpointer
profiler_realloc (gpointer mem,
		  gsize    n_bytes)
{
  mem = profiler_try_realloc (mem, n_bytes);

  if (!mem)
    g_mem_profile ();

  return mem;
}

static GMemVTable profiler_table = {
  profiler_malloc,
  profiler_realloc,
  profiler_free,
  profiler_calloc,
  profiler_try_malloc,
  profiler_try_realloc,
};
GMemVTable *glib_mem_profiler_table = &profiler_table;

#endif	/* !G_DISABLE_CHECKS */
