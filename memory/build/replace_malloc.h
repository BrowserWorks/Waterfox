/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef replace_malloc_h
#define replace_malloc_h

/*
 * The replace_malloc facility allows an external library to replace or
 * supplement the jemalloc implementation.
 *
 * The external library may be hooked by setting one of the following
 * environment variables to the library path:
 *   - LD_PRELOAD on Linux,
 *   - DYLD_INSERT_LIBRARIES on OSX,
 *   - MOZ_REPLACE_MALLOC_LIB on Windows and Android.
 *
 * An initialization function is called before any malloc replacement
 * function, and has the following declaration:
 *
 *   void replace_init(const malloc_table_t *)
 *
 * The const malloc_table_t pointer given to that function is a table
 * containing pointers to the original jemalloc implementation, so that
 * replacement functions can call them back if they need to. The pointer
 * itself can safely be kept around (no need to copy the table itself).
 *
 * The functions to be implemented in the external library are of the form:
 *
 *   void *replace_malloc(size_t size)
 *   {
 *     // Fiddle with the size if necessary.
 *     // orig->malloc doesn't have to be called if the external library
 *     // provides its own allocator, but in this case it will have to
 *     // implement all functions.
 *     void *ptr = orig->malloc(size);
 *     // Do whatever you want with the ptr.
 *     return ptr;
 *   }
 *
 * where "orig" is the pointer obtained from replace_init.
 *
 * See malloc_decls.h for a list of functions that can be replaced this
 * way. The implementations are all in the form:
 *   return_type replace_name(arguments [,...])
 *
 * They don't all need to be provided.
 *
 * Building a replace-malloc library is like rocket science. It can end up
 * with things blowing up, especially when trying to use complex types, and
 * even more especially when these types come from XPCOM or other parts of the
 * Mozilla codebase.
 * It is recommended to add the following to a replace-malloc implementation's
 * moz.build:
 *   DISABLE_STL_WRAPPING = True # Avoid STL wrapping
 *
 * If your replace-malloc implementation lives under memory/replace, these
 * are taken care of by memory/replace/defs.mk.
 */

#ifdef replace_malloc_bridge_h
#error Do not include replace_malloc_bridge.h before replace_malloc.h. \
  In fact, you only need the latter.
#endif

#define REPLACE_MALLOC_IMPL

#include "replace_malloc_bridge.h"

/* Implementing a replace-malloc library is incompatible with using mozalloc. */
#define MOZ_NO_MOZALLOC 1

#include "mozilla/Types.h"

MOZ_BEGIN_EXTERN_C

/* MOZ_NO_REPLACE_FUNC_DECL and MOZ_REPLACE_WEAK are only defined in
 * replace_malloc.c. Normally including this header will add function
 * definitions. */
#ifndef MOZ_NO_REPLACE_FUNC_DECL

#  ifndef MOZ_REPLACE_WEAK
#    define MOZ_REPLACE_WEAK
#  endif

#  define MALLOC_DECL(name, return_type, ...) \
    MOZ_EXPORT return_type replace_ ## name(__VA_ARGS__) MOZ_REPLACE_WEAK;

#  define MALLOC_FUNCS MALLOC_FUNCS_ALL
#  include "malloc_decls.h"

#endif /* MOZ_NO_REPLACE_FUNC_DECL */

MOZ_END_EXTERN_C

#endif /* replace_malloc_h */
