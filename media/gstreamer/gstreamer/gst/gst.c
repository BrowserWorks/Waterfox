/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gst.c: Initialization and non-pipeline operations
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

/**
 * SECTION:gst
 * @short_description: Media library supporting arbitrary formats and filter
 *                     graphs.
 *
 * GStreamer is a framework for constructing graphs of various filters
 * (termed elements here) that will handle streaming media.  Any discreet
 * (packetizable) media type is supported, with provisions for automatically
 * determining source type.  Formatting/framing information is provided with
 * a powerful negotiation framework.  Plugins are heavily used to provide for
 * all elements, allowing one to construct plugins outside of the GST
 * library, even released binary-only if license require (please don't).
 * GStreamer covers a wide range of use cases including: playback, recording,
 * editing, serving streams, voice over ip and video calls.
 *
 * The <application>GStreamer</application> library should be initialized with
 * gst_init() before it can be used. You should pass pointers to the main argc
 * and argv variables so that GStreamer can process its own command line
 * options, as shown in the following example.
 *
 * <example>
 * <title>Initializing the gstreamer library</title>
 * <programlisting language="c">
 * int
 * main (int argc, char *argv[])
 * {
 *   // initialize the GStreamer library
 *   gst_init (&amp;argc, &amp;argv);
 *   ...
 * }
 * </programlisting>
 * </example>
 *
 * It's allowed to pass two %NULL pointers to gst_init() in case you don't want
 * to pass the command line args to GStreamer.
 *
 * You can also use GOption to initialize your own parameters as shown in
 * the next code fragment:
 * <example>
 * <title>Initializing own parameters when initializing gstreamer</title>
 * <programlisting>
 * static gboolean stats = FALSE;
 * ...
 * int
 * main (int argc, char *argv[])
 * {
 *  GOptionEntry options[] = {
 *   {"tags", 't', 0, G_OPTION_ARG_NONE, &amp;tags,
 *       N_("Output tags (also known as metadata)"), NULL},
 *   {NULL}
 *  };
 *  ctx = g_option_context_new ("[ADDITIONAL ARGUMENTS]");
 *  g_option_context_add_main_entries (ctx, options, GETTEXT_PACKAGE);
 *  g_option_context_add_group (ctx, gst_init_get_option_group ());
 *  if (!g_option_context_parse (ctx, &amp;argc, &amp;argv, &amp;err)) {
 *    g_print ("Error initializing: &percnt;s\n", GST_STR_NULL (err->message));
 *    exit (1);
 *  }
 *  g_option_context_free (ctx);
 * ...
 * }
 * </programlisting>
 * </example>
 *
 * Use gst_version() to query the library version at runtime or use the
 * GST_VERSION_* macros to find the version at compile time. Optionally
 * gst_version_string() returns a printable string.
 *
 * The gst_deinit() call is used to clean up all internal resources used
 * by <application>GStreamer</application>. It is mostly used in unit tests 
 * to check for leaks.
 */

#include "gst_private.h"
#include "gstconfig.h"
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#ifdef HAVE_SYS_UTSNAME_H
#include <sys/utsname.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef G_OS_WIN32
#define WIN32_LEAN_AND_MEAN     /* prevents from including too many things */
#include <windows.h>            /* GetStdHandle, windows console */
#endif

#include "gst-i18n-lib.h"
#include <locale.h>             /* for LC_ALL */

#include "gst.h"
#include "gsttrace.h"

#define GST_CAT_DEFAULT GST_CAT_GST_INIT

#define MAX_PATH_SPLIT  16
#define GST_PLUGIN_SEPARATOR ","

static gboolean gst_initialized = FALSE;
static gboolean gst_deinitialized = FALSE;

#ifdef G_OS_WIN32
HMODULE _priv_gst_dll_handle = NULL;
#endif

#ifndef GST_DISABLE_REGISTRY
GList *_priv_gst_plugin_paths = NULL;   /* for delayed processing in post_init */

extern gboolean _priv_gst_disable_registry_update;
#endif

#ifndef GST_DISABLE_GST_DEBUG
const gchar *priv_gst_dump_dot_dir;
#endif

/* defaults */

/* set to TRUE when segfaults need to be left as is */
static gboolean _gst_disable_segtrap = FALSE;

static gboolean init_pre (GOptionContext * context, GOptionGroup * group,
    gpointer data, GError ** error);
static gboolean init_post (GOptionContext * context, GOptionGroup * group,
    gpointer data, GError ** error);
#ifndef GST_DISABLE_OPTION_PARSING
static gboolean parse_goption_arg (const gchar * s_opt,
    const gchar * arg, gpointer data, GError ** err);
#endif

GSList *_priv_gst_preload_plugins = NULL;

const gchar g_log_domain_gstreamer[] = "GStreamer";

static void
debug_log_handler (const gchar * log_domain,
    GLogLevelFlags log_level, const gchar * message, gpointer user_data)
{
  g_log_default_handler (log_domain, log_level, message, user_data);
  /* FIXME: do we still need this ? fatal errors these days are all
   * other than core errors */
  /* g_on_error_query (NULL); */
}

enum
{
  ARG_VERSION = 1,
  ARG_FATAL_WARNINGS,
#ifndef GST_DISABLE_GST_DEBUG
  ARG_DEBUG_LEVEL,
  ARG_DEBUG,
  ARG_DEBUG_DISABLE,
  ARG_DEBUG_NO_COLOR,
  ARG_DEBUG_COLOR_MODE,
  ARG_DEBUG_HELP,
#endif
  ARG_PLUGIN_SPEW,
  ARG_PLUGIN_PATH,
  ARG_PLUGIN_LOAD,
  ARG_SEGTRAP_DISABLE,
  ARG_REGISTRY_UPDATE_DISABLE,
  ARG_REGISTRY_FORK_DISABLE
};

/* debug-spec ::= category-spec [, category-spec]*
 * category-spec ::= category:val | val
 * category ::= [^:]+
 * val ::= [0-5]
 */

#ifdef G_OS_WIN32
BOOL WINAPI DllMain (HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved);
BOOL WINAPI
DllMain (HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  if (fdwReason == DLL_PROCESS_ATTACH)
    _priv_gst_dll_handle = (HMODULE) hinstDLL;
  return TRUE;
}

#endif

/**
 * gst_init_get_option_group: (skip)
 *
 * Returns a #GOptionGroup with GStreamer's argument specifications. The
 * group is set up to use standard GOption callbacks, so when using this
 * group in combination with GOption parsing methods, all argument parsing
 * and initialization is automated.
 *
 * This function is useful if you want to integrate GStreamer with other
 * libraries that use GOption (see g_option_context_add_group() ).
 *
 * If you use this function, you should make sure you initialise the GLib
 * threading system as one of the very first things in your program
 * (see the example at the beginning of this section).
 *
 * Returns: (transfer full): a pointer to GStreamer's option group.
 */

GOptionGroup *
gst_init_get_option_group (void)
{
#ifndef GST_DISABLE_OPTION_PARSING
  GOptionGroup *group;
  static const GOptionEntry gst_args[] = {
    {"gst-version", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
        (gpointer) parse_goption_arg, N_("Print the GStreamer version"), NULL},
    {"gst-fatal-warnings", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
        (gpointer) parse_goption_arg, N_("Make all warnings fatal"), NULL},
#ifndef GST_DISABLE_GST_DEBUG
    {"gst-debug-help", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Print available debug categories and exit"),
        NULL},
    {"gst-debug-level", 0, 0, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Default debug level from 1 (only error) to 9 (anything) or "
              "0 for no output"),
        N_("LEVEL")},
    {"gst-debug", 0, 0, G_OPTION_ARG_CALLBACK, (gpointer) parse_goption_arg,
          N_("Comma-separated list of category_name:level pairs to set "
              "specific levels for the individual categories. Example: "
              "GST_AUTOPLUG:5,GST_ELEMENT_*:3"),
        N_("LIST")},
    {"gst-debug-no-color", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg, N_("Disable colored debugging output"),
        NULL},
    {"gst-debug-color-mode", 0, 0, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Changes coloring mode of the debug log. "
              "Possible modes: off, on, disable, auto, unix"),
        NULL},
    {"gst-debug-disable", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
        (gpointer) parse_goption_arg, N_("Disable debugging"), NULL},
#endif
    {"gst-plugin-spew", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Enable verbose plugin loading diagnostics"),
        NULL},
    {"gst-plugin-path", 0, 0, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
        N_("Colon-separated paths containing plugins"), N_("PATHS")},
    {"gst-plugin-load", 0, 0, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Comma-separated list of plugins to preload in addition to the "
              "list stored in environment variable GST_PLUGIN_PATH"),
        N_("PLUGINS")},
    {"gst-disable-segtrap", 0, G_OPTION_FLAG_NO_ARG, G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Disable trapping of segmentation faults during plugin loading"),
        NULL},
    {"gst-disable-registry-update", 0, G_OPTION_FLAG_NO_ARG,
          G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Disable updating the registry"),
        NULL},
    {"gst-disable-registry-fork", 0, G_OPTION_FLAG_NO_ARG,
          G_OPTION_ARG_CALLBACK,
          (gpointer) parse_goption_arg,
          N_("Disable spawning a helper process while scanning the registry"),
        NULL},
    {NULL}
  };

  group = g_option_group_new ("gst", _("GStreamer Options"),
      _("Show GStreamer Options"), NULL, NULL);
  g_option_group_set_parse_hooks (group, (GOptionParseFunc) init_pre,
      (GOptionParseFunc) init_post);

  g_option_group_add_entries (group, gst_args);
  g_option_group_set_translation_domain (group, GETTEXT_PACKAGE);

  return group;
#else
  return NULL;
#endif
}

/**
 * gst_init_check:
 * @argc: (inout) (allow-none): pointer to application's argc
 * @argv: (inout) (array length=argc) (allow-none): pointer to application's argv
 * @err: pointer to a #GError to which a message will be posted on error
 *
 * Initializes the GStreamer library, setting up internal path lists,
 * registering built-in elements, and loading standard plugins.
 *
 * This function will return %FALSE if GStreamer could not be initialized
 * for some reason.  If you want your program to fail fatally,
 * use gst_init() instead.
 *
 * Returns: %TRUE if GStreamer could be initialized.
 */
gboolean
gst_init_check (int *argc, char **argv[], GError ** err)
{
#ifndef GST_DISABLE_OPTION_PARSING
  GOptionGroup *group;
  GOptionContext *ctx;
#endif
  gboolean res;

  if (gst_initialized) {
    GST_DEBUG ("already initialized gst");
    return TRUE;
  }
#ifndef GST_DISABLE_OPTION_PARSING
  ctx = g_option_context_new ("- GStreamer initialization");
  g_option_context_set_ignore_unknown_options (ctx, TRUE);
  g_option_context_set_help_enabled (ctx, FALSE);
  group = gst_init_get_option_group ();
  g_option_context_add_group (ctx, group);
  res = g_option_context_parse (ctx, argc, argv, err);
  g_option_context_free (ctx);
#else
  init_pre (NULL, NULL, NULL, NULL);
  init_post (NULL, NULL, NULL, NULL);
  res = TRUE;
#endif

  gst_initialized = res;

  if (res) {
    GST_INFO ("initialized GStreamer successfully");
  } else {
    GST_INFO ("failed to initialize GStreamer");
  }

  return res;
}

/**
 * gst_init:
 * @argc: (inout) (allow-none): pointer to application's argc
 * @argv: (inout) (array length=argc) (allow-none): pointer to application's argv
 *
 * Initializes the GStreamer library, setting up internal path lists,
 * registering built-in elements, and loading standard plugins.
 *
 * Unless the plugin registry is disabled at compile time, the registry will be
 * loaded. By default this will also check if the registry cache needs to be
 * updated and rescan all plugins if needed. See gst_update_registry() for
 * details and section
 * <link linkend="gst-running">Running GStreamer Applications</link>
 * for how to disable automatic registry updates.
 *
 * <note><para>
 * This function will terminate your program if it was unable to initialize
 * GStreamer for some reason.  If you want your program to fall back,
 * use gst_init_check() instead.
 * </para></note>
 *
 * WARNING: This function does not work in the same way as corresponding
 * functions in other glib-style libraries, such as gtk_init\(\). In
 * particular, unknown command line options cause this function to
 * abort program execution.
 */
void
gst_init (int *argc, char **argv[])
{
  GError *err = NULL;

  if (!gst_init_check (argc, argv, &err)) {
    g_print ("Could not initialize GStreamer: %s\n",
        err ? err->message : "unknown error occurred");
    if (err) {
      g_error_free (err);
    }
    exit (1);
  }
}

/**
 * gst_is_initialized:
 *
 * Use this function to check if GStreamer has been initialized with gst_init()
 * or gst_init_check().
 *
 * Returns: %TRUE if initialization has been done, %FALSE otherwise.
 */
gboolean
gst_is_initialized (void)
{
  return gst_initialized;
}

#ifndef GST_DISABLE_REGISTRY
static void
add_path_func (gpointer data, gpointer user_data)
{
  GST_INFO ("Adding plugin path: \"%s\", will scan later", (gchar *) data);
  _priv_gst_plugin_paths =
      g_list_append (_priv_gst_plugin_paths, g_strdup (data));
}
#endif

#ifndef GST_DISABLE_OPTION_PARSING
static void
prepare_for_load_plugin_func (gpointer data, gpointer user_data)
{
  _priv_gst_preload_plugins =
      g_slist_prepend (_priv_gst_preload_plugins, g_strdup (data));
}
#endif

#ifndef GST_DISABLE_OPTION_PARSING
static void
split_and_iterate (const gchar * stringlist, const gchar * separator,
    GFunc iterator, gpointer user_data)
{
  gchar **strings;
  gint j = 0;
  gchar *lastlist = g_strdup (stringlist);

  while (lastlist) {
    strings = g_strsplit (lastlist, separator, MAX_PATH_SPLIT);
    g_free (lastlist);
    lastlist = NULL;

    while (strings[j]) {
      iterator (strings[j], user_data);
      if (++j == MAX_PATH_SPLIT) {
        lastlist = g_strdup (strings[j]);
        j = 0;
        break;
      }
    }
    g_strfreev (strings);
  }
}
#endif

/* we have no fail cases yet, but maybe in the future */
static gboolean
init_pre (GOptionContext * context, GOptionGroup * group, gpointer data,
    GError ** error)
{
  gchar *libdir;
  if (gst_initialized) {
    GST_DEBUG ("already initialized");
    return TRUE;
  }
#if !GLIB_CHECK_VERSION(2, 35, 0)
  g_type_init ();
#endif

#ifndef GST_DISABLE_GST_DEBUG
  _priv_gst_debug_init ();
  priv_gst_dump_dot_dir = g_getenv ("GST_DEBUG_DUMP_DOT_DIR");
#endif

#ifdef ENABLE_NLS
  bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif /* ENABLE_NLS */

  /* This is the earliest we can make stuff show up in the logs.
   * So give some useful info about GStreamer here */
#ifdef G_OS_WIN32
  {
    gchar *basedir =
        g_win32_get_package_installation_directory_of_module
        (_priv_gst_dll_handle);

    libdir = g_build_filename (basedir,
#ifdef _DEBUG
        "debug"
#endif
        "lib", NULL);
    g_free (basedir);
  }
#else
  libdir = g_strdup (LIBDIR);
#endif
  GST_INFO ("Initializing GStreamer Core Library version %s", VERSION);
  GST_INFO ("Using library installed in %s", libdir);
  g_free (libdir);

  /* Print some basic system details if possible (OS/architecture) */
#ifdef HAVE_SYS_UTSNAME_H
  {
    struct utsname sys_details;

    if (uname (&sys_details) == 0) {
      GST_INFO ("%s %s %s %s %s", sys_details.sysname,
          sys_details.nodename, sys_details.release, sys_details.version,
          sys_details.machine);
    }
  }
#endif

#ifndef G_ATOMIC_LOCK_FREE
  GST_CAT_WARNING (GST_CAT_PERFORMANCE, "GLib atomic operations are NOT "
      "implemented using real hardware atomic operations!");
#endif

  return TRUE;
}

static gboolean
gst_register_core_elements (GstPlugin * plugin)
{
  /* register some standard builtin types */
  if (!gst_element_register (plugin, "bin", GST_RANK_PRIMARY,
          GST_TYPE_BIN) ||
      !gst_element_register (plugin, "pipeline", GST_RANK_PRIMARY,
          GST_TYPE_PIPELINE)
      )
    g_assert_not_reached ();

  return TRUE;
}

/*
 * this bit handles:
 * - initalization of threads if we use them
 * - log handler
 * - initial output
 * - initializes gst_format
 * - registers a bunch of types for gst_objects
 *
 * - we don't have cases yet where this fails, but in the future
 *   we might and then it's nice to be able to return that
 */
static gboolean
init_post (GOptionContext * context, GOptionGroup * group, gpointer data,
    GError ** error)
{
  GLogLevelFlags llf;

  if (gst_initialized) {
    GST_DEBUG ("already initialized");
    return TRUE;
  }

  llf = G_LOG_LEVEL_CRITICAL | G_LOG_LEVEL_ERROR | G_LOG_FLAG_FATAL;
  g_log_set_handler (g_log_domain_gstreamer, llf, debug_log_handler, NULL);

#ifndef GST_DISABLE_TRACE
  _priv_gst_alloc_trace_initialize ();
#endif

  _priv_gst_mini_object_initialize ();
  _priv_gst_quarks_initialize ();
  _priv_gst_allocator_initialize ();
  _priv_gst_memory_initialize ();
  _priv_gst_format_initialize ();
  _priv_gst_query_initialize ();
  _priv_gst_structure_initialize ();
  _priv_gst_caps_initialize ();
  _priv_gst_caps_features_initialize ();
  _priv_gst_meta_initialize ();
  _priv_gst_message_initialize ();

  g_type_class_ref (gst_object_get_type ());
  g_type_class_ref (gst_pad_get_type ());
  g_type_class_ref (gst_element_factory_get_type ());
  g_type_class_ref (gst_element_get_type ());
  g_type_class_ref (gst_type_find_factory_get_type ());
  g_type_class_ref (gst_bin_get_type ());
  g_type_class_ref (gst_bus_get_type ());
  g_type_class_ref (gst_task_get_type ());
  g_type_class_ref (gst_clock_get_type ());
  g_type_class_ref (gst_debug_color_mode_get_type ());

  gst_uri_handler_get_type ();

  g_type_class_ref (gst_object_flags_get_type ());
  g_type_class_ref (gst_bin_flags_get_type ());
  g_type_class_ref (gst_buffer_flags_get_type ());
  g_type_class_ref (gst_buffer_copy_flags_get_type ());
  g_type_class_ref (gst_bus_flags_get_type ());
  g_type_class_ref (gst_bus_sync_reply_get_type ());
  g_type_class_ref (gst_caps_flags_get_type ());
  g_type_class_ref (gst_clock_return_get_type ());
  g_type_class_ref (gst_clock_entry_type_get_type ());
  g_type_class_ref (gst_clock_flags_get_type ());
  g_type_class_ref (gst_clock_type_get_type ());
  g_type_class_ref (gst_debug_graph_details_get_type ());
  g_type_class_ref (gst_state_get_type ());
  g_type_class_ref (gst_state_change_return_get_type ());
  g_type_class_ref (gst_state_change_get_type ());
  g_type_class_ref (gst_element_flags_get_type ());
  g_type_class_ref (gst_core_error_get_type ());
  g_type_class_ref (gst_library_error_get_type ());
  g_type_class_ref (gst_resource_error_get_type ());
  g_type_class_ref (gst_stream_error_get_type ());
  g_type_class_ref (gst_event_type_flags_get_type ());
  g_type_class_ref (gst_event_type_get_type ());
  g_type_class_ref (gst_seek_type_get_type ());
  g_type_class_ref (gst_seek_flags_get_type ());
  g_type_class_ref (gst_qos_type_get_type ());
  g_type_class_ref (gst_format_get_type ());
  g_type_class_ref (gst_debug_level_get_type ());
  g_type_class_ref (gst_debug_color_flags_get_type ());
  g_type_class_ref (gst_iterator_result_get_type ());
  g_type_class_ref (gst_iterator_item_get_type ());
  g_type_class_ref (gst_message_type_get_type ());
  g_type_class_ref (gst_mini_object_flags_get_type ());
  g_type_class_ref (gst_pad_link_return_get_type ());
  g_type_class_ref (gst_pad_link_check_get_type ());
  g_type_class_ref (gst_flow_return_get_type ());
  g_type_class_ref (gst_pad_mode_get_type ());
  g_type_class_ref (gst_pad_direction_get_type ());
  g_type_class_ref (gst_pad_flags_get_type ());
  g_type_class_ref (gst_pad_presence_get_type ());
  g_type_class_ref (gst_pad_template_flags_get_type ());
  g_type_class_ref (gst_pipeline_flags_get_type ());
  g_type_class_ref (gst_plugin_error_get_type ());
  g_type_class_ref (gst_plugin_flags_get_type ());
  g_type_class_ref (gst_plugin_dependency_flags_get_type ());
  g_type_class_ref (gst_rank_get_type ());
  g_type_class_ref (gst_query_type_flags_get_type ());
  g_type_class_ref (gst_query_type_get_type ());
  g_type_class_ref (gst_buffering_mode_get_type ());
  g_type_class_ref (gst_stream_status_type_get_type ());
  g_type_class_ref (gst_structure_change_type_get_type ());
  g_type_class_ref (gst_tag_merge_mode_get_type ());
  g_type_class_ref (gst_tag_flag_get_type ());
  g_type_class_ref (gst_tag_scope_get_type ());
  g_type_class_ref (gst_task_pool_get_type ());
  g_type_class_ref (gst_task_state_get_type ());
  g_type_class_ref (gst_toc_entry_type_get_type ());
  g_type_class_ref (gst_type_find_probability_get_type ());
  g_type_class_ref (gst_uri_error_get_type ());
  g_type_class_ref (gst_uri_type_get_type ());
  g_type_class_ref (gst_parse_error_get_type ());
  g_type_class_ref (gst_parse_flags_get_type ());
  g_type_class_ref (gst_search_mode_get_type ());
  g_type_class_ref (gst_progress_type_get_type ());
  g_type_class_ref (gst_buffer_pool_acquire_flags_get_type ());
  g_type_class_ref (gst_memory_flags_get_type ());
  g_type_class_ref (gst_map_flags_get_type ());
  g_type_class_ref (gst_caps_intersect_mode_get_type ());
  g_type_class_ref (gst_pad_probe_type_get_type ());
  g_type_class_ref (gst_pad_probe_return_get_type ());
  g_type_class_ref (gst_segment_flags_get_type ());
  g_type_class_ref (gst_scheduling_flags_get_type ());
  g_type_class_ref (gst_meta_flags_get_type ());
  g_type_class_ref (gst_toc_entry_type_get_type ());
  g_type_class_ref (gst_toc_scope_get_type ());
  g_type_class_ref (gst_toc_loop_type_get_type ());
  g_type_class_ref (gst_control_binding_get_type ());
  g_type_class_ref (gst_control_source_get_type ());
  g_type_class_ref (gst_lock_flags_get_type ());
  g_type_class_ref (gst_allocator_flags_get_type ());
  g_type_class_ref (gst_stream_flags_get_type ());

  _priv_gst_event_initialize ();
  _priv_gst_buffer_initialize ();
  _priv_gst_buffer_list_initialize ();
  _priv_gst_sample_initialize ();
  _priv_gst_context_initialize ();
  _priv_gst_date_time_initialize ();
  _priv_gst_tag_initialize ();
  _priv_gst_toc_initialize ();
  _priv_gst_value_initialize ();

  g_type_class_ref (gst_param_spec_fraction_get_type ());
  gst_parse_context_get_type ();

  _priv_gst_plugin_initialize ();

  /* register core plugins */
  gst_plugin_register_static (GST_VERSION_MAJOR, GST_VERSION_MINOR,
      "staticelements", "core elements linked into the GStreamer library",
      gst_register_core_elements, VERSION, GST_LICENSE, PACKAGE,
      GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN);

  /*
   * Any errors happening below this point are non-fatal, we therefore mark
   * gstreamer as being initialized, since it is the case from a plugin point of
   * view.
   *
   * If anything fails, it will be put back to %FALSE in gst_init_check().
   * This allows some special plugins that would call gst_init() to not cause a
   * looping effect (i.e. initializing GStreamer twice).
   */
  gst_initialized = TRUE;

  if (!gst_update_registry ())
    return FALSE;

  GST_INFO ("GLib runtime version: %d.%d.%d", glib_major_version,
      glib_minor_version, glib_micro_version);
  GST_INFO ("GLib headers version: %d.%d.%d", GLIB_MAJOR_VERSION,
      GLIB_MINOR_VERSION, GLIB_MICRO_VERSION);

  return TRUE;
}

#ifndef GST_DISABLE_GST_DEBUG
static gboolean
select_all (GstPlugin * plugin, gpointer user_data)
{
  return TRUE;
}

static gint
sort_by_category_name (gconstpointer a, gconstpointer b)
{
  return strcmp (gst_debug_category_get_name ((GstDebugCategory *) a),
      gst_debug_category_get_name ((GstDebugCategory *) b));
}

static void
gst_debug_help (void)
{
  GSList *list, *walk;
  GList *list2, *g;

  /* Need to ensure the registry is loaded to get debug categories */
  if (!init_post (NULL, NULL, NULL, NULL))
    exit (1);

  list2 = gst_registry_plugin_filter (gst_registry_get (),
      select_all, FALSE, NULL);

  /* FIXME this is gross.  why don't debug have categories PluginFeatures? */
  for (g = list2; g; g = g_list_next (g)) {
    GstPlugin *plugin = GST_PLUGIN_CAST (g->data);

    gst_plugin_load (plugin);
  }
  g_list_free (list2);

  list = gst_debug_get_all_categories ();
  walk = list = g_slist_sort (list, sort_by_category_name);

  g_print ("\n");
  g_print ("name                  level    description\n");
  g_print ("---------------------+--------+--------------------------------\n");

  while (walk) {
    gboolean on_unix;
    GstDebugCategory *cat = (GstDebugCategory *) walk->data;
    GstDebugColorMode coloring = gst_debug_get_color_mode ();
#ifdef G_OS_UNIX
    on_unix = TRUE;
#else
    on_unix = FALSE;
#endif

    if (GST_DEBUG_COLOR_MODE_UNIX == coloring
        || (on_unix && GST_DEBUG_COLOR_MODE_ON == coloring)) {
      gchar *color = gst_debug_construct_term_color (cat->color);

      g_print ("%s%-20s\033[00m  %1d %s  %s%s\033[00m\n",
          color,
          gst_debug_category_get_name (cat),
          gst_debug_category_get_threshold (cat),
          gst_debug_level_get_name (gst_debug_category_get_threshold (cat)),
          color, gst_debug_category_get_description (cat));
      g_free (color);
    } else if (GST_DEBUG_COLOR_MODE_ON == coloring && !on_unix) {
#ifdef G_OS_WIN32
      gint color = gst_debug_construct_win_color (cat->color);
      const gint clear = FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE;

      SetConsoleTextAttribute (GetStdHandle (STD_OUTPUT_HANDLE), color);
      g_print ("%-20s", gst_debug_category_get_name (cat));
      SetConsoleTextAttribute (GetStdHandle (STD_OUTPUT_HANDLE), clear);
      g_print (" %1d %s ", gst_debug_category_get_threshold (cat),
          gst_debug_level_get_name (gst_debug_category_get_threshold (cat)));
      SetConsoleTextAttribute (GetStdHandle (STD_OUTPUT_HANDLE), color);
      g_print ("%s", gst_debug_category_get_description (cat));
      SetConsoleTextAttribute (GetStdHandle (STD_OUTPUT_HANDLE), clear);
      g_print ("\n");
#endif /* G_OS_WIN32 */
    } else {
      g_print ("%-20s  %1d %s  %s\n", gst_debug_category_get_name (cat),
          gst_debug_category_get_threshold (cat),
          gst_debug_level_get_name (gst_debug_category_get_threshold (cat)),
          gst_debug_category_get_description (cat));
    }
    walk = g_slist_next (walk);
  }
  g_slist_free (list);
  g_print ("\n");
}
#endif

#ifndef GST_DISABLE_OPTION_PARSING
static gboolean
parse_one_option (gint opt, const gchar * arg, GError ** err)
{
  switch (opt) {
    case ARG_VERSION:
      g_print ("GStreamer Core Library version %s\n", PACKAGE_VERSION);
      exit (0);
    case ARG_FATAL_WARNINGS:{
      GLogLevelFlags fatal_mask;

      fatal_mask = g_log_set_always_fatal (G_LOG_FATAL_MASK);
      fatal_mask |= G_LOG_LEVEL_WARNING | G_LOG_LEVEL_CRITICAL;
      g_log_set_always_fatal (fatal_mask);
      break;
    }
#ifndef GST_DISABLE_GST_DEBUG
    case ARG_DEBUG_LEVEL:{
      GstDebugLevel tmp = GST_LEVEL_NONE;

      tmp = (GstDebugLevel) strtol (arg, NULL, 0);
      if (((guint) tmp) < GST_LEVEL_COUNT) {
        gst_debug_set_default_threshold (tmp);
      }
      break;
    }
    case ARG_DEBUG:
      gst_debug_set_threshold_from_string (arg, FALSE);
      break;
    case ARG_DEBUG_NO_COLOR:
      gst_debug_set_colored (FALSE);
      break;
    case ARG_DEBUG_COLOR_MODE:
      gst_debug_set_color_mode_from_string (arg);
      break;
    case ARG_DEBUG_DISABLE:
      gst_debug_set_active (FALSE);
      break;
    case ARG_DEBUG_HELP:
      gst_debug_help ();
      exit (0);
#endif
    case ARG_PLUGIN_SPEW:
      break;
    case ARG_PLUGIN_PATH:
#ifndef GST_DISABLE_REGISTRY
      split_and_iterate (arg, G_SEARCHPATH_SEPARATOR_S, add_path_func, NULL);
#endif /* GST_DISABLE_REGISTRY */
      break;
    case ARG_PLUGIN_LOAD:
      split_and_iterate (arg, ",", prepare_for_load_plugin_func, NULL);
      break;
    case ARG_SEGTRAP_DISABLE:
      _gst_disable_segtrap = TRUE;
      break;
    case ARG_REGISTRY_UPDATE_DISABLE:
#ifndef GST_DISABLE_REGISTRY
      _priv_gst_disable_registry_update = TRUE;
#endif
      break;
    case ARG_REGISTRY_FORK_DISABLE:
      gst_registry_fork_set_enabled (FALSE);
      break;
    default:
      g_set_error (err, G_OPTION_ERROR, G_OPTION_ERROR_UNKNOWN_OPTION,
          _("Unknown option"));
      return FALSE;
  }

  return TRUE;
}

static gboolean
parse_goption_arg (const gchar * opt,
    const gchar * arg, gpointer data, GError ** err)
{
  static const struct
  {
    const gchar *opt;
    int val;
  } options[] = {
    {
    "--gst-version", ARG_VERSION}, {
    "--gst-fatal-warnings", ARG_FATAL_WARNINGS},
#ifndef GST_DISABLE_GST_DEBUG
    {
    "--gst-debug-level", ARG_DEBUG_LEVEL}, {
    "--gst-debug", ARG_DEBUG}, {
    "--gst-debug-disable", ARG_DEBUG_DISABLE}, {
    "--gst-debug-no-color", ARG_DEBUG_NO_COLOR}, {
    "--gst-debug-color-mode", ARG_DEBUG_COLOR_MODE}, {
    "--gst-debug-help", ARG_DEBUG_HELP},
#endif
    {
    "--gst-plugin-spew", ARG_PLUGIN_SPEW}, {
    "--gst-plugin-path", ARG_PLUGIN_PATH}, {
    "--gst-plugin-load", ARG_PLUGIN_LOAD}, {
    "--gst-disable-segtrap", ARG_SEGTRAP_DISABLE}, {
    "--gst-disable-registry-update", ARG_REGISTRY_UPDATE_DISABLE}, {
    "--gst-disable-registry-fork", ARG_REGISTRY_FORK_DISABLE}, {
    NULL}
  };
  gint val = 0, n;

  for (n = 0; options[n].opt; n++) {
    if (!strcmp (opt, options[n].opt)) {
      val = options[n].val;
      break;
    }
  }

  return parse_one_option (val, arg, err);
}
#endif

/**
 * gst_deinit:
 *
 * Clean up any resources created by GStreamer in gst_init().
 *
 * It is normally not needed to call this function in a normal application
 * as the resources will automatically be freed when the program terminates.
 * This function is therefore mostly used by testsuites and other memory
 * profiling tools.
 *
 * After this call GStreamer (including this method) should not be used anymore. 
 */
void
gst_deinit (void)
{
  GstBinClass *bin_class;
  GstClock *clock;

  GST_INFO ("deinitializing GStreamer");

  if (gst_deinitialized) {
    GST_DEBUG ("already deinitialized");
    return;
  }

  g_thread_pool_set_max_unused_threads (0);
  bin_class = GST_BIN_CLASS (g_type_class_peek (gst_bin_get_type ()));
  if (bin_class->pool != NULL) {
    g_thread_pool_free (bin_class->pool, FALSE, TRUE);
    bin_class->pool = NULL;
  }
  gst_task_cleanup_all ();

  g_slist_foreach (_priv_gst_preload_plugins, (GFunc) g_free, NULL);
  g_slist_free (_priv_gst_preload_plugins);
  _priv_gst_preload_plugins = NULL;

#ifndef GST_DISABLE_REGISTRY
  g_list_foreach (_priv_gst_plugin_paths, (GFunc) g_free, NULL);
  g_list_free (_priv_gst_plugin_paths);
  _priv_gst_plugin_paths = NULL;
#endif

  clock = gst_system_clock_obtain ();
  gst_object_unref (clock);
  gst_object_unref (clock);

  _priv_gst_registry_cleanup ();

#ifndef GST_DISABLE_TRACE
  _priv_gst_alloc_trace_deinit ();
#endif

  g_type_class_unref (g_type_class_peek (gst_object_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_element_factory_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_element_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_type_find_factory_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_bin_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_bus_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_task_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_object_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_bin_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_buffer_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_buffer_copy_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_bus_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_bus_sync_reply_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_caps_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_clock_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_clock_return_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_clock_entry_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_clock_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_debug_graph_details_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_state_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_state_change_return_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_state_change_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_element_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_core_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_library_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_plugin_dependency_flags_get_type
          ()));
  g_type_class_unref (g_type_class_peek (gst_parse_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_resource_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_search_mode_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_stream_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_stream_status_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_structure_change_type_get_type
          ()));
  g_type_class_unref (g_type_class_peek (gst_event_type_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_event_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_seek_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_seek_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_qos_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_format_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_debug_level_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_debug_color_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_iterator_result_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_iterator_item_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_message_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_meta_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_mini_object_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_link_return_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_link_check_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_flow_return_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_mode_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_direction_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_presence_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_template_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pipeline_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_plugin_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_plugin_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_rank_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_query_type_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_query_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_buffering_mode_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_tag_merge_mode_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_tag_flag_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_tag_scope_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_task_state_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_toc_entry_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_toc_scope_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_type_find_probability_get_type
          ()));
  g_type_class_unref (g_type_class_peek (gst_uri_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_uri_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_parse_error_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_param_spec_fraction_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_progress_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_buffer_pool_acquire_flags_get_type
          ()));
  g_type_class_unref (g_type_class_peek (gst_memory_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_map_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_caps_intersect_mode_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_probe_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_pad_probe_return_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_segment_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_scheduling_flags_get_type ()));

  g_type_class_unref (g_type_class_peek (gst_control_binding_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_control_source_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_toc_entry_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_toc_loop_type_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_lock_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_allocator_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_stream_flags_get_type ()));
  g_type_class_unref (g_type_class_peek (gst_debug_color_mode_get_type ()));

  gst_deinitialized = TRUE;
  GST_INFO ("deinitialized GStreamer");
}

/**
 * gst_version:
 * @major: (out): pointer to a guint to store the major version number
 * @minor: (out): pointer to a guint to store the minor version number
 * @micro: (out): pointer to a guint to store the micro version number
 * @nano:  (out): pointer to a guint to store the nano version number
 *
 * Gets the version number of the GStreamer library.
 */
void
gst_version (guint * major, guint * minor, guint * micro, guint * nano)
{
  g_return_if_fail (major);
  g_return_if_fail (minor);
  g_return_if_fail (micro);
  g_return_if_fail (nano);

  *major = GST_VERSION_MAJOR;
  *minor = GST_VERSION_MINOR;
  *micro = GST_VERSION_MICRO;
  *nano = GST_VERSION_NANO;
}

/**
 * gst_version_string:
 *
 * This function returns a string that is useful for describing this version
 * of GStreamer to the outside world: user agent strings, logging, ...
 *
 * Returns: (transfer full): a newly allocated string describing this version
 *     of GStreamer.
 */

gchar *
gst_version_string (void)
{
  guint major, minor, micro, nano;

  gst_version (&major, &minor, &micro, &nano);
  if (nano == 0)
    return g_strdup_printf ("GStreamer %d.%d.%d", major, minor, micro);
  else if (nano == 1)
    return g_strdup_printf ("GStreamer %d.%d.%d (GIT)", major, minor, micro);
  else
    return g_strdup_printf ("GStreamer %d.%d.%d (prerelease)", major, minor,
        micro);
}

/**
 * gst_segtrap_is_enabled:
 *
 * Some functions in the GStreamer core might install a custom SIGSEGV handler
 * to better catch and report errors to the application. Currently this feature
 * is enabled by default when loading plugins.
 *
 * Applications might want to disable this behaviour with the
 * gst_segtrap_set_enabled() function. This is typically done if the application
 * wants to install its own handler without GStreamer interfering.
 *
 * Returns: %TRUE if GStreamer is allowed to install a custom SIGSEGV handler.
 */
gboolean
gst_segtrap_is_enabled (void)
{
  /* yeps, it's enabled when it's not disabled */
  return !_gst_disable_segtrap;
}

/**
 * gst_segtrap_set_enabled:
 * @enabled: whether a custom SIGSEGV handler should be installed.
 *
 * Applications might want to disable/enable the SIGSEGV handling of
 * the GStreamer core. See gst_segtrap_is_enabled() for more information.
 */
void
gst_segtrap_set_enabled (gboolean enabled)
{
  _gst_disable_segtrap = !enabled;
}
