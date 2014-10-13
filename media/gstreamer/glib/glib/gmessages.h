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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
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

#ifndef __G_MESSAGES_H__
#define __G_MESSAGES_H__

#if !defined (__GLIB_H_INSIDE__) && !defined (GLIB_COMPILATION)
#error "Only <glib.h> can be included directly."
#endif

#include <stdarg.h>
#include <glib/gtypes.h>
#include <glib/gmacros.h>

/* Suppress warnings when GCC is in -pedantic mode and not -std=c99
 */
#if (__GNUC__ >= 3 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 96))
#pragma GCC system_header
#endif

G_BEGIN_DECLS

/* calculate a string size, guaranteed to fit format + args.
 */
GLIB_AVAILABLE_IN_ALL
gsize	g_printf_string_upper_bound (const gchar* format,
				     va_list	  args) G_GNUC_PRINTF(1, 0);

/* Log level shift offset for user defined
 * log levels (0-7 are used by GLib).
 */
#define G_LOG_LEVEL_USER_SHIFT  (8)

/* Glib log levels and flags.
 */
typedef enum
{
  /* log flags */
  G_LOG_FLAG_RECURSION          = 1 << 0,
  G_LOG_FLAG_FATAL              = 1 << 1,

  /* GLib log levels */
  G_LOG_LEVEL_ERROR             = 1 << 2,       /* always fatal */
  G_LOG_LEVEL_CRITICAL          = 1 << 3,
  G_LOG_LEVEL_WARNING           = 1 << 4,
  G_LOG_LEVEL_MESSAGE           = 1 << 5,
  G_LOG_LEVEL_INFO              = 1 << 6,
  G_LOG_LEVEL_DEBUG             = 1 << 7,

  G_LOG_LEVEL_MASK              = ~(G_LOG_FLAG_RECURSION | G_LOG_FLAG_FATAL)
} GLogLevelFlags;

/* GLib log levels that are considered fatal by default */
#define G_LOG_FATAL_MASK        (G_LOG_FLAG_RECURSION | G_LOG_LEVEL_ERROR)

typedef void            (*GLogFunc)             (const gchar   *log_domain,
                                                 GLogLevelFlags log_level,
                                                 const gchar   *message,
                                                 gpointer       user_data);

/* Logging mechanism
 */
GLIB_AVAILABLE_IN_ALL
guint           g_log_set_handler       (const gchar    *log_domain,
                                         GLogLevelFlags  log_levels,
                                         GLogFunc        log_func,
                                         gpointer        user_data);
GLIB_AVAILABLE_IN_ALL
void            g_log_remove_handler    (const gchar    *log_domain,
                                         guint           handler_id);
GLIB_AVAILABLE_IN_ALL
void            g_log_default_handler   (const gchar    *log_domain,
                                         GLogLevelFlags  log_level,
                                         const gchar    *message,
                                         gpointer        unused_data);
GLIB_AVAILABLE_IN_ALL
GLogFunc        g_log_set_default_handler (GLogFunc      log_func,
					   gpointer      user_data);
GLIB_AVAILABLE_IN_ALL
void            g_log                   (const gchar    *log_domain,
                                         GLogLevelFlags  log_level,
                                         const gchar    *format,
                                         ...) G_GNUC_PRINTF (3, 4);
GLIB_AVAILABLE_IN_ALL
void            g_logv                  (const gchar    *log_domain,
                                         GLogLevelFlags  log_level,
                                         const gchar    *format,
                                         va_list         args) G_GNUC_PRINTF(3, 0);
GLIB_AVAILABLE_IN_ALL
GLogLevelFlags  g_log_set_fatal_mask    (const gchar    *log_domain,
                                         GLogLevelFlags  fatal_mask);
GLIB_AVAILABLE_IN_ALL
GLogLevelFlags  g_log_set_always_fatal  (GLogLevelFlags  fatal_mask);

/* internal */
void	_g_log_fallback_handler	(const gchar   *log_domain,
						 GLogLevelFlags log_level,
						 const gchar   *message,
						 gpointer       unused_data);

/* Internal functions, used to implement the following macros */
GLIB_AVAILABLE_IN_ALL
void g_return_if_fail_warning (const char *log_domain,
			       const char *pretty_function,
			       const char *expression) G_ANALYZER_NORETURN;
GLIB_AVAILABLE_IN_ALL
void g_warn_message           (const char     *domain,
                               const char     *file,
                               int             line,
                               const char     *func,
                               const char     *warnexpr) G_ANALYZER_NORETURN;
GLIB_DEPRECATED
void g_assert_warning         (const char *log_domain,
			       const char *file,
			       const int   line,
		               const char *pretty_function,
		               const char *expression) G_GNUC_NORETURN;


#ifndef G_LOG_DOMAIN
#define G_LOG_DOMAIN    ((gchar*) 0)
#endif  /* G_LOG_DOMAIN */

#if defined(G_HAVE_ISO_VARARGS) && !G_ANALYZER_ANALYZING
/* for(;;) ; so that GCC knows that control doesn't go past g_error().
 * Put space before ending semicolon to avoid C++ build warnings.
 */
#define g_error(...)  G_STMT_START {                 \
                        g_log (G_LOG_DOMAIN,         \
                               G_LOG_LEVEL_ERROR,    \
                               __VA_ARGS__);         \
                        for (;;) ;                   \
                      } G_STMT_END
                        
#define g_message(...)  g_log (G_LOG_DOMAIN,         \
                               G_LOG_LEVEL_MESSAGE,  \
                               __VA_ARGS__)
#define g_critical(...) g_log (G_LOG_DOMAIN,         \
                               G_LOG_LEVEL_CRITICAL, \
                               __VA_ARGS__)
#define g_warning(...)  g_log (G_LOG_DOMAIN,         \
                               G_LOG_LEVEL_WARNING,  \
                               __VA_ARGS__)
#define g_debug(...)    g_log (G_LOG_DOMAIN,         \
                               G_LOG_LEVEL_DEBUG,    \
                               __VA_ARGS__)
#elif defined(G_HAVE_GNUC_VARARGS)  && !G_ANALYZER_ANALYZING
#define g_error(format...)    G_STMT_START {                 \
                                g_log (G_LOG_DOMAIN,         \
                                       G_LOG_LEVEL_ERROR,    \
                                       format);              \
                                for (;;) ;                   \
                              } G_STMT_END
                              
#define g_message(format...)    g_log (G_LOG_DOMAIN,         \
                                       G_LOG_LEVEL_MESSAGE,  \
                                       format)
#define g_critical(format...)   g_log (G_LOG_DOMAIN,         \
                                       G_LOG_LEVEL_CRITICAL, \
                                       format)
#define g_warning(format...)    g_log (G_LOG_DOMAIN,         \
                                       G_LOG_LEVEL_WARNING,  \
                                       format)
#define g_debug(format...)      g_log (G_LOG_DOMAIN,         \
                                       G_LOG_LEVEL_DEBUG,    \
                                       format)
#else   /* no varargs macros */
static void g_error (const gchar *format, ...) G_ANALYZER_NORETURN;
static void g_critical (const gchar *format, ...) G_ANALYZER_NORETURN;

static void
g_error (const gchar *format,
         ...)
{
  va_list args;
  va_start (args, format);
  g_logv (G_LOG_DOMAIN, G_LOG_LEVEL_ERROR, format, args);
  va_end (args);

  for(;;) ;
}
static void
g_message (const gchar *format,
           ...)
{
  va_list args;
  va_start (args, format);
  g_logv (G_LOG_DOMAIN, G_LOG_LEVEL_MESSAGE, format, args);
  va_end (args);
}
static void
g_critical (const gchar *format,
            ...)
{
  va_list args;
  va_start (args, format);
  g_logv (G_LOG_DOMAIN, G_LOG_LEVEL_CRITICAL, format, args);
  va_end (args);
}
static void
g_warning (const gchar *format,
           ...)
{
  va_list args;
  va_start (args, format);
  g_logv (G_LOG_DOMAIN, G_LOG_LEVEL_WARNING, format, args);
  va_end (args);
}
static void
g_debug (const gchar *format,
         ...)
{
  va_list args;
  va_start (args, format);
  g_logv (G_LOG_DOMAIN, G_LOG_LEVEL_DEBUG, format, args);
  va_end (args);
}
#endif  /* !__GNUC__ */

/**
 * GPrintFunc:
 * @string: the message to output
 *
 * Specifies the type of the print handler functions.
 * These are called with the complete formatted string to output.
 */
typedef void    (*GPrintFunc)           (const gchar    *string);
GLIB_AVAILABLE_IN_ALL
void            g_print                 (const gchar    *format,
                                         ...) G_GNUC_PRINTF (1, 2);
GLIB_AVAILABLE_IN_ALL
GPrintFunc      g_set_print_handler     (GPrintFunc      func);
GLIB_AVAILABLE_IN_ALL
void            g_printerr              (const gchar    *format,
                                         ...) G_GNUC_PRINTF (1, 2);
GLIB_AVAILABLE_IN_ALL
GPrintFunc      g_set_printerr_handler  (GPrintFunc      func);

/**
 * g_warn_if_reached:
 *
 * Logs a critical warning.
 *
 * Since: 2.16
 */
#define g_warn_if_reached() \
  do { \
    g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, NULL); \
  } while (0)

/**
 * g_warn_if_fail:
 * @expr: the expression to check
 *
 * Logs a warning if the expression is not true.
 *
 * Since: 2.16
 */
#define g_warn_if_fail(expr) \
  do { \
    if G_LIKELY (expr) ; \
    else g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr); \
  } while (0)

#ifdef G_DISABLE_CHECKS

/**
 * g_return_if_fail:
 * @expr: the expression to check
 *
 * Verifies that the expression evaluates to %TRUE.  If the expression
 * evaluates to %FALSE, a critical message is logged and the current
 * function returns.  This can only be used in functions which do not
 * return a value.
 *
 * If G_DISABLE_CHECKS is defined then the check is not performed.  You
 * should therefore not depend on any side effects of @expr.
 */
#define g_return_if_fail(expr) G_STMT_START{ (void)0; }G_STMT_END

/**
 * g_return_val_if_fail:
 * @expr: the expression to check
 * @val: the value to return from the current function
 *       if the expression is not true
 *
 * Verifies that the expression evaluates to %TRUE.  If the expression
 * evaluates to %FALSE, a critical message is logged and @val is
 * returned from the current function.
 *
 * If G_DISABLE_CHECKS is defined then the check is not performed.  You
 * should therefore not depend on any side effects of @expr.
 */
#define g_return_val_if_fail(expr,val) G_STMT_START{ (void)0; }G_STMT_END

/**
 * g_return_if_reached:
 *
 * Logs a critical message and returns from the current function.
 * This can only be used in functions which do not return a value.
 */
#define g_return_if_reached() G_STMT_START{ return; }G_STMT_END

/**
 * g_return_val_if_reached:
 * @val: the value to return from the current function
 *
 * Logs a critical message and returns @val.
 */
#define g_return_val_if_reached(val) G_STMT_START{ return (val); }G_STMT_END

#else /* !G_DISABLE_CHECKS */

#ifdef __GNUC__

#define g_return_if_fail(expr)		G_STMT_START{			\
     if G_LIKELY(expr) { } else       					\
       {								\
	 g_return_if_fail_warning (G_LOG_DOMAIN,			\
		                   __PRETTY_FUNCTION__,		        \
		                   #expr);				\
	 return;							\
       };				}G_STMT_END

#define g_return_val_if_fail(expr,val)	G_STMT_START{			\
     if G_LIKELY(expr) { } else						\
       {								\
	 g_return_if_fail_warning (G_LOG_DOMAIN,			\
		                   __PRETTY_FUNCTION__,		        \
		                   #expr);				\
	 return (val);							\
       };				}G_STMT_END

#define g_return_if_reached()		G_STMT_START{			\
     g_log (G_LOG_DOMAIN,						\
	    G_LOG_LEVEL_CRITICAL,					\
	    "file %s: line %d (%s): should not be reached",		\
	    __FILE__,							\
	    __LINE__,							\
	    __PRETTY_FUNCTION__);					\
     return;				}G_STMT_END

#define g_return_val_if_reached(val)	G_STMT_START{			\
     g_log (G_LOG_DOMAIN,						\
	    G_LOG_LEVEL_CRITICAL,					\
	    "file %s: line %d (%s): should not be reached",		\
	    __FILE__,							\
	    __LINE__,							\
	    __PRETTY_FUNCTION__);					\
     return (val);			}G_STMT_END

#else /* !__GNUC__ */

#define g_return_if_fail(expr)		G_STMT_START{		\
     if (expr) { } else						\
       {							\
	 g_log (G_LOG_DOMAIN,					\
		G_LOG_LEVEL_CRITICAL,				\
		"file %s: line %d: assertion '%s' failed",	\
		__FILE__,					\
		__LINE__,					\
		#expr);						\
	 return;						\
       };				}G_STMT_END

#define g_return_val_if_fail(expr, val)	G_STMT_START{		\
     if (expr) { } else						\
       {							\
	 g_log (G_LOG_DOMAIN,					\
		G_LOG_LEVEL_CRITICAL,				\
		"file %s: line %d: assertion '%s' failed",	\
		__FILE__,					\
		__LINE__,					\
		#expr);						\
	 return (val);						\
       };				}G_STMT_END

#define g_return_if_reached()		G_STMT_START{		\
     g_log (G_LOG_DOMAIN,					\
	    G_LOG_LEVEL_CRITICAL,				\
	    "file %s: line %d: should not be reached",		\
	    __FILE__,						\
	    __LINE__);						\
     return;				}G_STMT_END

#define g_return_val_if_reached(val)	G_STMT_START{		\
     g_log (G_LOG_DOMAIN,					\
	    G_LOG_LEVEL_CRITICAL,				\
	    "file %s: line %d: should not be reached",		\
	    __FILE__,						\
	    __LINE__);						\
     return (val);			}G_STMT_END

#endif /* !__GNUC__ */

#endif /* !G_DISABLE_CHECKS */

G_END_DECLS

#endif /* __G_MESSAGES_H__ */
