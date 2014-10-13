/* GStreamer encoding profile registry
 * Copyright (C) 2010 Edward Hervey <edward.hervey@collabora.co.uk>
 *           (C) 2010 Nokia Corporation
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <locale.h>
#include <string.h>
#include "encoding-target.h"

/*
 * File format
 *
 * GKeyFile style.
 *
 * [GStreamer Encoding Target]
 * name : <name>
 * category : <category>
 * description : <description> #translatable
 *
 * [profile-<profile1name>]
 * name : <name>
 * description : <description> #optional
 * format : <format>
 * preset : <preset>
 *
 * [streamprofile-<id>]
 * parent : <encodingprofile.name>[,<encodingprofile.name>..]
 * type : <type> # "audio", "video", "text"
 * format : <format>
 * preset : <preset>
 * restriction : <restriction>
 * presence : <presence>
 * pass : <pass>
 * variableframerate : <variableframerate>
 *  */

/*
 * Location of profile files
 *
 * $GST_DATADIR/gstreamer-GST_API_VERSION/encoding-profile
 * $HOME/gstreamer-GST_API_VERSION/encoding-profile
 *
 * Naming convention
 *   $(target.category)/$(target.name).gep
 *
 * Naming restrictions:
 *  lowercase ASCII letter for the first character
 *  Same for all other characters + numerics + hyphens
 */


#define GST_ENCODING_TARGET_HEADER "GStreamer Encoding Target"
#define GST_ENCODING_TARGET_DIRECTORY "encoding-profiles"
#define GST_ENCODING_TARGET_SUFFIX ".gep"

struct _GstEncodingTarget
{
  GObject parent;

  gchar *name;
  gchar *category;
  gchar *description;
  GList *profiles;

  /*< private > */
  gchar *keyfile;
};

G_DEFINE_TYPE (GstEncodingTarget, gst_encoding_target, G_TYPE_OBJECT);

static void
gst_encoding_target_init (GstEncodingTarget * target)
{
  /* Nothing to initialize */
}

static void
gst_encoding_target_finalize (GObject * object)
{
  GstEncodingTarget *target = (GstEncodingTarget *) object;

  GST_DEBUG ("Finalizing");

  if (target->name)
    g_free (target->name);
  if (target->category)
    g_free (target->category);
  if (target->description)
    g_free (target->description);

  g_list_foreach (target->profiles, (GFunc) g_object_unref, NULL);
  g_list_free (target->profiles);
}

static void
gst_encoding_target_class_init (GObjectClass * klass)
{
  klass->finalize = gst_encoding_target_finalize;
}

/**
 * gst_encoding_target_get_name:
 * @target: a #GstEncodingTarget
 *
 * Returns: (transfer none): The name of the @target.
 */
const gchar *
gst_encoding_target_get_name (GstEncodingTarget * target)
{
  return target->name;
}

/**
 * gst_encoding_target_get_category:
 * @target: a #GstEncodingTarget
 *
 * Returns: (transfer none): The category of the @target. For example:
 * #GST_ENCODING_CATEGORY_DEVICE.
 */
const gchar *
gst_encoding_target_get_category (GstEncodingTarget * target)
{
  return target->category;
}

/**
 * gst_encoding_target_get_description:
 * @target: a #GstEncodingTarget
 *
 * Returns: (transfer none): The description of the @target.
 */
const gchar *
gst_encoding_target_get_description (GstEncodingTarget * target)
{
  return target->description;
}

/**
 * gst_encoding_target_get_profiles:
 * @target: a #GstEncodingTarget
 *
 * Returns: (transfer none) (element-type GstPbutils.EncodingProfile): A list of
 * #GstEncodingProfile(s) this @target handles.
 */
const GList *
gst_encoding_target_get_profiles (GstEncodingTarget * target)
{
  return target->profiles;
}

/**
 * gst_encoding_target_get_profile:
 * @target: a #GstEncodingTarget
 * @name: the name of the profile to retrieve
 *
 * Returns: (transfer full): The matching #GstEncodingProfile, or %NULL.
 */
GstEncodingProfile *
gst_encoding_target_get_profile (GstEncodingTarget * target, const gchar * name)
{
  GList *tmp;

  g_return_val_if_fail (GST_IS_ENCODING_TARGET (target), NULL);
  g_return_val_if_fail (name != NULL, NULL);

  for (tmp = target->profiles; tmp; tmp = tmp->next) {
    GstEncodingProfile *tprof = (GstEncodingProfile *) tmp->data;

    if (!g_strcmp0 (gst_encoding_profile_get_name (tprof), name)) {
      gst_encoding_profile_ref (tprof);
      return tprof;
    }
  }

  return NULL;
}

static inline gboolean
validate_name (const gchar * name)
{
  guint i, len;

  len = strlen (name);
  if (len == 0)
    return FALSE;

  /* First character can only be a lower case ASCII character */
  if (!g_ascii_isalpha (name[0]) || !g_ascii_islower (name[0]))
    return FALSE;

  /* All following characters can only by:
   * either a lower case ASCII character
   * or an hyphen
   * or a numeric */
  for (i = 1; i < len; i++) {
    /* if uppercase ASCII letter, return */
    if (g_ascii_isupper (name[i]))
      return FALSE;
    /* if a digit, continue */
    if (g_ascii_isdigit (name[i]))
      continue;
    /* if an hyphen, continue */
    if (name[i] == '-')
      continue;
    /* remaining should only be ascii letters */
    if (!g_ascii_isalpha (name[i]))
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_encoding_target_new:
 * @name: The name of the target.
 * @category: (transfer none): The name of the category to which this @target
 * belongs. For example: #GST_ENCODING_CATEGORY_DEVICE.
 * @description: (transfer none): A description of #GstEncodingTarget in the
 * current locale.
 * @profiles: (transfer none) (element-type GstPbutils.EncodingProfile): A #GList of
 * #GstEncodingProfile.
 *
 * Creates a new #GstEncodingTarget.
 *
 * The name and category can only consist of lowercase ASCII letters for the
 * first character, followed by either lowercase ASCII letters, digits or
 * hyphens ('-').
 *
 * The @category <emphasis>should</emphasis> be one of the existing
 * well-defined categories, like #GST_ENCODING_CATEGORY_DEVICE, but it
 * <emphasis>can</emphasis> be a application or user specific category if
 * needed.
 *
 * Returns: (transfer full): The newly created #GstEncodingTarget or %NULL if
 * there was an error.
 */

GstEncodingTarget *
gst_encoding_target_new (const gchar * name, const gchar * category,
    const gchar * description, const GList * profiles)
{
  GstEncodingTarget *res;

  g_return_val_if_fail (name != NULL, NULL);
  g_return_val_if_fail (category != NULL, NULL);
  g_return_val_if_fail (description != NULL, NULL);

  /* Validate name */
  if (!validate_name (name))
    goto invalid_name;
  if (!validate_name (category))
    goto invalid_category;

  res = (GstEncodingTarget *) g_object_new (GST_TYPE_ENCODING_TARGET, NULL);
  res->name = g_strdup (name);
  res->category = g_strdup (category);
  res->description = g_strdup (description);

  while (profiles) {
    GstEncodingProfile *prof = (GstEncodingProfile *) profiles->data;

    res->profiles =
        g_list_append (res->profiles, gst_encoding_profile_ref (prof));
    profiles = profiles->next;
  }

  return res;

invalid_name:
  {
    GST_ERROR ("Invalid name for encoding target : '%s'", name);
    return NULL;
  }

invalid_category:
  {
    GST_ERROR ("Invalid name for encoding category : '%s'", category);
    return NULL;
  }
}

/**
 * gst_encoding_target_add_profile:
 * @target: the #GstEncodingTarget to add a profile to
 * @profile: (transfer full): the #GstEncodingProfile to add
 *
 * Adds the given @profile to the @target. Each added profile must have
 * a unique name within the profile.
 *
 * The @target will steal a reference to the @profile. If you wish to use
 * the profile after calling this method, you should increase its reference
 * count.
 *
 * Returns: %TRUE if the profile was added, else %FALSE.
 **/

gboolean
gst_encoding_target_add_profile (GstEncodingTarget * target,
    GstEncodingProfile * profile)
{
  GList *tmp;

  g_return_val_if_fail (GST_IS_ENCODING_TARGET (target), FALSE);
  g_return_val_if_fail (GST_IS_ENCODING_PROFILE (profile), FALSE);

  /* Make sure profile isn't already controlled by this target */
  for (tmp = target->profiles; tmp; tmp = tmp->next) {
    GstEncodingProfile *prof = (GstEncodingProfile *) tmp->data;

    if (!g_strcmp0 (gst_encoding_profile_get_name (profile),
            gst_encoding_profile_get_name (prof))) {
      GST_WARNING ("Profile already present in target");
      return FALSE;
    }
  }

  target->profiles = g_list_append (target->profiles, profile);

  return TRUE;
}

static gboolean
serialize_stream_profiles (GKeyFile * out, GstEncodingProfile * sprof,
    const gchar * profilename, guint id)
{
  gchar *sprofgroupname;
  gchar *tmpc;
  GstCaps *format, *restriction;
  const gchar *preset, *name, *description;

  sprofgroupname = g_strdup_printf ("streamprofile-%s-%d", profilename, id);

  /* Write the parent profile */
  g_key_file_set_value (out, sprofgroupname, "parent", profilename);

  g_key_file_set_value (out, sprofgroupname, "type",
      gst_encoding_profile_get_type_nick (sprof));

  format = gst_encoding_profile_get_format (sprof);
  if (format) {
    tmpc = gst_caps_to_string (format);
    g_key_file_set_value (out, sprofgroupname, "format", tmpc);
    g_free (tmpc);
  }

  name = gst_encoding_profile_get_name (sprof);
  if (name)
    g_key_file_set_string (out, sprofgroupname, "name", name);

  description = gst_encoding_profile_get_description (sprof);
  if (description)
    g_key_file_set_string (out, sprofgroupname, "description", description);

  preset = gst_encoding_profile_get_preset (sprof);
  if (preset)
    g_key_file_set_string (out, sprofgroupname, "preset", preset);

  restriction = gst_encoding_profile_get_restriction (sprof);
  if (restriction) {
    tmpc = gst_caps_to_string (restriction);
    g_key_file_set_value (out, sprofgroupname, "restriction", tmpc);
    g_free (tmpc);
  }
  g_key_file_set_integer (out, sprofgroupname, "presence",
      gst_encoding_profile_get_presence (sprof));

  if (GST_IS_ENCODING_VIDEO_PROFILE (sprof)) {
    GstEncodingVideoProfile *vp = (GstEncodingVideoProfile *) sprof;

    g_key_file_set_integer (out, sprofgroupname, "pass",
        gst_encoding_video_profile_get_pass (vp));
    g_key_file_set_boolean (out, sprofgroupname, "variableframerate",
        gst_encoding_video_profile_get_variableframerate (vp));
  }

  g_free (sprofgroupname);
  if (format)
    gst_caps_unref (format);
  if (restriction)
    gst_caps_unref (restriction);
  return TRUE;
}

static gchar *
get_locale (void)
{
  const char *loc = NULL;
  gchar *ret;

#ifdef ENABLE_NLS
#if defined(LC_MESSAGES)
  loc = setlocale (LC_MESSAGES, NULL);
  GST_LOG ("LC_MESSAGES: %s", GST_STR_NULL (loc));
#elif defined(LC_ALL)
  loc = setlocale (LC_ALL, NULL);
  GST_LOG ("LC_ALL: %s", GST_STR_NULL (loc));
#else
  GST_LOG ("Neither LC_ALL nor LC_MESSAGES defined");
#endif
#else /* !ENABLE_NLS */
  GST_LOG ("i18n disabled");
#endif

  if (loc == NULL || g_ascii_strncasecmp (loc, "en", 2) == 0)
    return NULL;

  /* en_GB.UTF-8 => en */
  ret = g_ascii_strdown (loc, -1);
  ret = g_strcanon (ret, "abcdefghijklmnopqrstuvwxyz", '\0');
  GST_LOG ("using locale: %s", ret);
  return ret;
}

/* Serialize the top-level profiles
 * Note: They don't have to be containerprofiles */
static gboolean
serialize_encoding_profile (GKeyFile * out, GstEncodingProfile * prof)
{
  gchar *profgroupname;
  const GList *tmp;
  guint i;
  const gchar *profname, *profdesc, *profpreset, *proftype;
  GstCaps *profformat;

  profname = gst_encoding_profile_get_name (prof);
  profdesc = gst_encoding_profile_get_description (prof);
  profformat = gst_encoding_profile_get_format (prof);
  profpreset = gst_encoding_profile_get_preset (prof);
  proftype = gst_encoding_profile_get_type_nick (prof);

  profgroupname = g_strdup_printf ("profile-%s", profname);

  g_key_file_set_string (out, profgroupname, "name", profname);

  g_key_file_set_value (out, profgroupname, "type", proftype);

  if (profdesc) {
    gchar *locale;

    locale = get_locale ();
    if (locale != NULL) {
      g_key_file_set_locale_string (out, profgroupname, "description",
          locale, profdesc);
      g_free (locale);
    } else {
      g_key_file_set_string (out, profgroupname, "description", profdesc);
    }
  }
  if (profformat) {
    gchar *tmpc = gst_caps_to_string (profformat);
    g_key_file_set_string (out, profgroupname, "format", tmpc);
    g_free (tmpc);
  }
  if (profpreset)
    g_key_file_set_string (out, profgroupname, "preset", profpreset);

  /* stream profiles */
  if (GST_IS_ENCODING_CONTAINER_PROFILE (prof)) {
    for (tmp =
        gst_encoding_container_profile_get_profiles
        (GST_ENCODING_CONTAINER_PROFILE (prof)), i = 0; tmp;
        tmp = tmp->next, i++) {
      GstEncodingProfile *sprof = (GstEncodingProfile *) tmp->data;

      if (!serialize_stream_profiles (out, sprof, profname, i))
        return FALSE;
    }
  }
  if (profformat)
    gst_caps_unref (profformat);
  g_free (profgroupname);
  return TRUE;
}

static gboolean
serialize_target (GKeyFile * out, GstEncodingTarget * target)
{
  GList *tmp;

  g_key_file_set_string (out, GST_ENCODING_TARGET_HEADER, "name", target->name);
  g_key_file_set_string (out, GST_ENCODING_TARGET_HEADER, "category",
      target->category);
  g_key_file_set_string (out, GST_ENCODING_TARGET_HEADER, "description",
      target->description);

  for (tmp = target->profiles; tmp; tmp = tmp->next) {
    GstEncodingProfile *prof = (GstEncodingProfile *) tmp->data;
    if (!serialize_encoding_profile (out, prof))
      return FALSE;
  }

  return TRUE;
}

/**
 * parse_encoding_profile:
 * @in: a #GKeyFile
 * @parentprofilename: the parent profile name (including 'profile-' or 'streamprofile-' header)
 * @profilename: the profile name group to parse
 * @nbgroups: the number of top-level groups
 * @groups: the top-level groups
 */
static GstEncodingProfile *
parse_encoding_profile (GKeyFile * in, gchar * parentprofilename,
    gchar * profilename, gsize nbgroups, gchar ** groups)
{
  GstEncodingProfile *sprof = NULL;
  gchar **parent;
  gchar *proftype, *format, *preset, *restriction, *pname, *description;
  GstCaps *formatcaps = NULL;
  GstCaps *restrictioncaps = NULL;
  gboolean variableframerate;
  gint pass, presence;
  gsize i, nbencprofiles;

  GST_DEBUG ("parentprofilename : %s , profilename : %s",
      parentprofilename, profilename);

  if (parentprofilename) {
    gboolean found = FALSE;

    parent =
        g_key_file_get_string_list (in, profilename, "parent",
        &nbencprofiles, NULL);
    if (!parent || !nbencprofiles) {
      return NULL;
    }

    /* Check if this streamprofile is used in <profilename> */
    for (i = 0; i < nbencprofiles; i++) {
      if (!g_strcmp0 (parent[i], parentprofilename)) {
        found = TRUE;
        break;
      }
    }
    g_strfreev (parent);

    if (!found) {
      GST_DEBUG ("Stream profile '%s' isn't used in profile '%s'",
          profilename, parentprofilename);
      return NULL;
    }
  }

  pname = g_key_file_get_value (in, profilename, "name", NULL);

  /* First try to get localized description */
  {
    gchar *locale;

    locale = get_locale ();
    if (locale != NULL) {
      /* will try to fall back to untranslated string if no translation found */
      description = g_key_file_get_locale_string (in, profilename,
          "description", locale, NULL);
      g_free (locale);
    } else {
      description =
          g_key_file_get_string (in, profilename, "description", NULL);
    }
  }

  /* Note: a missing description is normal for non-container profiles */
  if (description == NULL) {
    GST_LOG ("Missing 'description' field for streamprofile %s", profilename);
  }

  /* Parse the remaining fields */
  proftype = g_key_file_get_value (in, profilename, "type", NULL);
  if (!proftype) {
    GST_WARNING ("Missing 'type' field for streamprofile %s", profilename);
    return NULL;
  }

  format = g_key_file_get_value (in, profilename, "format", NULL);
  if (format) {
    formatcaps = gst_caps_from_string (format);
    g_free (format);
  }

  preset = g_key_file_get_value (in, profilename, "preset", NULL);

  restriction = g_key_file_get_value (in, profilename, "restriction", NULL);
  if (restriction) {
    restrictioncaps = gst_caps_from_string (restriction);
    g_free (restriction);
  }

  presence = g_key_file_get_integer (in, profilename, "presence", NULL);
  pass = g_key_file_get_integer (in, profilename, "pass", NULL);
  variableframerate =
      g_key_file_get_boolean (in, profilename, "variableframerate", NULL);

  /* Build the streamprofile ! */
  if (!g_strcmp0 (proftype, "container")) {
    GstEncodingProfile *pprof;

    sprof =
        (GstEncodingProfile *) gst_encoding_container_profile_new (pname,
        description, formatcaps, preset);
    /* Now look for the stream profiles */
    for (i = 0; i < nbgroups; i++) {
      if (!g_ascii_strncasecmp (groups[i], "streamprofile-", 13)) {
        pprof = parse_encoding_profile (in, pname, groups[i], nbgroups, groups);
        if (pprof) {
          gst_encoding_container_profile_add_profile (
              (GstEncodingContainerProfile *) sprof, pprof);
        }
      }
    }
  } else if (!g_strcmp0 (proftype, "video")) {
    sprof =
        (GstEncodingProfile *) gst_encoding_video_profile_new (formatcaps,
        preset, restrictioncaps, presence);
    gst_encoding_video_profile_set_variableframerate ((GstEncodingVideoProfile
            *) sprof, variableframerate);
    gst_encoding_video_profile_set_pass ((GstEncodingVideoProfile *) sprof,
        pass);
    gst_encoding_profile_set_name (sprof, pname);
    gst_encoding_profile_set_description (sprof, description);
  } else if (!g_strcmp0 (proftype, "audio")) {
    sprof =
        (GstEncodingProfile *) gst_encoding_audio_profile_new (formatcaps,
        preset, restrictioncaps, presence);
    gst_encoding_profile_set_name (sprof, pname);
    gst_encoding_profile_set_description (sprof, description);
  } else
    GST_ERROR ("Unknown profile format '%s'", proftype);

  if (restrictioncaps)
    gst_caps_unref (restrictioncaps);
  if (formatcaps)
    gst_caps_unref (formatcaps);

  if (pname)
    g_free (pname);
  if (description)
    g_free (description);
  if (preset)
    g_free (preset);
  if (proftype)
    g_free (proftype);

  return sprof;
}

static GstEncodingTarget *
parse_keyfile (GKeyFile * in, gchar * targetname, gchar * categoryname,
    gchar * description)
{
  GstEncodingTarget *res = NULL;
  GstEncodingProfile *prof;
  gchar **groups;
  gsize i, nbgroups;

  res = gst_encoding_target_new (targetname, categoryname, description, NULL);

  /* Figure out the various profiles */
  groups = g_key_file_get_groups (in, &nbgroups);
  for (i = 0; i < nbgroups; i++) {
    if (!g_ascii_strncasecmp (groups[i], "profile-", 8)) {
      prof = parse_encoding_profile (in, NULL, groups[i], nbgroups, groups);
      if (prof)
        gst_encoding_target_add_profile (res, prof);
    }
  }

  g_strfreev (groups);

  if (targetname)
    g_free (targetname);
  if (categoryname)
    g_free (categoryname);
  if (description)
    g_free (description);

  return res;
}

static GKeyFile *
load_file_and_read_header (const gchar * path, gchar ** targetname,
    gchar ** categoryname, gchar ** description, GError ** error)
{
  GKeyFile *in;
  gboolean res;
  GError *key_error = NULL;

  g_return_val_if_fail (error == NULL || *error == NULL, NULL);

  in = g_key_file_new ();

  GST_DEBUG ("path:%s", path);

  res =
      g_key_file_load_from_file (in, path,
      G_KEY_FILE_KEEP_COMMENTS | G_KEY_FILE_KEEP_TRANSLATIONS, &key_error);
  if (!res || key_error != NULL)
    goto load_error;

  key_error = NULL;
  *targetname =
      g_key_file_get_value (in, GST_ENCODING_TARGET_HEADER, "name", &key_error);
  if (!*targetname)
    goto empty_name;

  *categoryname =
      g_key_file_get_value (in, GST_ENCODING_TARGET_HEADER, "category", NULL);
  *description =
      g_key_file_get_value (in, GST_ENCODING_TARGET_HEADER, "description",
      NULL);

  return in;

load_error:
  {
    GST_WARNING ("Unable to read GstEncodingTarget file %s: %s",
        path, key_error->message);
    g_propagate_error (error, key_error);
    g_key_file_free (in);
    return NULL;
  }

empty_name:
  {
    GST_WARNING ("Wrong header in file %s: %s", path, key_error->message);
    g_propagate_error (error, key_error);
    g_key_file_free (in);
    return NULL;
  }
}

/**
 * gst_encoding_target_load_from_file:
 * @filepath: The file location to load the #GstEncodingTarget from
 * @error: If an error occured, this field will be filled in.
 *
 * Opens the provided file and returns the contained #GstEncodingTarget.
 *
 * Returns: (transfer full): The #GstEncodingTarget contained in the file, else
 * %NULL
 */

GstEncodingTarget *
gst_encoding_target_load_from_file (const gchar * filepath, GError ** error)
{
  GKeyFile *in;
  gchar *targetname, *categoryname, *description;
  GstEncodingTarget *res = NULL;

  in = load_file_and_read_header (filepath, &targetname, &categoryname,
      &description, error);
  if (!in)
    goto beach;

  res = parse_keyfile (in, targetname, categoryname, description);

  g_key_file_free (in);

beach:
  return res;
}

/*
 * returned list contents must be freed
 */
static GList *
get_matching_filenames (gchar * path, gchar * filename)
{
  GList *res = NULL;
  GDir *topdir;
  const gchar *subdirname;

  topdir = g_dir_open (path, 0, NULL);
  if (G_UNLIKELY (topdir == NULL))
    return NULL;

  while ((subdirname = g_dir_read_name (topdir))) {
    gchar *ltmp = g_build_filename (path, subdirname, NULL);

    if (g_file_test (ltmp, G_FILE_TEST_IS_DIR)) {
      gchar *tmp = g_build_filename (path, subdirname, filename, NULL);
      /* Test to see if we have a file named like that in that directory */
      if (g_file_test (tmp, G_FILE_TEST_EXISTS))
        res = g_list_append (res, tmp);
      else
        g_free (tmp);
    }
    g_free (ltmp);
  }

  g_dir_close (topdir);

  return res;
}

static GstEncodingTarget *
gst_encoding_target_subload (gchar * path, const gchar * category,
    gchar * lfilename, GError ** error)
{
  GstEncodingTarget *target = NULL;

  if (category) {
    gchar *filename;

    filename = g_build_filename (path, category, lfilename, NULL);
    target = gst_encoding_target_load_from_file (filename, error);
    g_free (filename);
  } else {
    GList *tmp, *tries = get_matching_filenames (path, lfilename);

    /* Try to find a file named %s.gstprofile in any subdirectories */
    for (tmp = tries; tmp; tmp = tmp->next) {
      target = gst_encoding_target_load_from_file ((gchar *) tmp->data, NULL);
      if (target)
        break;
    }
    g_list_foreach (tries, (GFunc) g_free, NULL);
    if (tries)
      g_list_free (tries);
  }

  return target;
}

/**
 * gst_encoding_target_load:
 * @name: the name of the #GstEncodingTarget to load.
 * @category: (allow-none): the name of the target category, like
 * #GST_ENCODING_CATEGORY_DEVICE. Can be %NULL
 * @error: If an error occured, this field will be filled in.
 *
 * Searches for the #GstEncodingTarget with the given name, loads it
 * and returns it.
 *
 * If the category name is specified only targets from that category will be
 * searched for.
 *
 * Returns: (transfer full): The #GstEncodingTarget if available, else %NULL.
 */
GstEncodingTarget *
gst_encoding_target_load (const gchar * name, const gchar * category,
    GError ** error)
{
  gchar *lfilename, *tldir;
  GstEncodingTarget *target = NULL;

  g_return_val_if_fail (name != NULL, NULL);

  if (!validate_name (name))
    goto invalid_name;

  if (category && !validate_name (category))
    goto invalid_category;

  lfilename = g_strdup_printf ("%s" GST_ENCODING_TARGET_SUFFIX, name);

  /* Try from local profiles */
  tldir =
      g_build_filename (g_get_user_data_dir (), "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, NULL);
  target = gst_encoding_target_subload (tldir, category, lfilename, error);
  g_free (tldir);

  if (target == NULL) {
    /* Try from system-wide profiles */
    tldir =
        g_build_filename (GST_DATADIR, "gstreamer-" GST_API_VERSION,
        GST_ENCODING_TARGET_DIRECTORY, NULL);
    target = gst_encoding_target_subload (tldir, category, lfilename, error);
    g_free (tldir);
  }

  g_free (lfilename);

  return target;

invalid_name:
  {
    GST_ERROR ("Invalid name for encoding target : '%s'", name);
    return NULL;
  }
invalid_category:
  {
    GST_ERROR ("Invalid name for encoding category : '%s'", category);
    return NULL;
  }
}

/**
 * gst_encoding_target_save_to_file:
 * @target: a #GstEncodingTarget
 * @filepath: the location to store the @target at.
 * @error: If an error occured, this field will be filled in.
 *
 * Saves the @target to the provided file location.
 *
 * Returns: %TRUE if the target was correctly saved, else %FALSE.
 **/

gboolean
gst_encoding_target_save_to_file (GstEncodingTarget * target,
    const gchar * filepath, GError ** error)
{
  GKeyFile *out;
  gchar *data;
  gsize data_size;

  g_return_val_if_fail (GST_IS_ENCODING_TARGET (target), FALSE);
  g_return_val_if_fail (filepath != NULL, FALSE);

  /* FIXME : Check filepath is valid and writable
   * FIXME : Strip out profiles already present in system target */

  /* Get unique name... */

  /* Create output GKeyFile */
  out = g_key_file_new ();

  if (!serialize_target (out, target))
    goto serialize_failure;

  if (!(data = g_key_file_to_data (out, &data_size, error)))
    goto convert_failed;

  if (!g_file_set_contents (filepath, data, data_size, error))
    goto write_failed;

  g_key_file_free (out);
  g_free (data);

  return TRUE;

serialize_failure:
  {
    GST_ERROR ("Failure serializing target");
    g_key_file_free (out);
    return FALSE;
  }

convert_failed:
  {
    GST_ERROR ("Failure converting keyfile: %s", (*error)->message);
    g_key_file_free (out);
    g_free (data);
    return FALSE;
  }

write_failed:
  {
    GST_ERROR ("Unable to write file %s: %s", filepath, (*error)->message);
    g_key_file_free (out);
    g_free (data);
    return FALSE;
  }
}

/**
 * gst_encoding_target_save:
 * @target: a #GstEncodingTarget
 * @error: If an error occured, this field will be filled in.
 *
 * Saves the @target to a default user-local directory.
 *
 * Returns: %TRUE if the target was correctly saved, else %FALSE.
 **/

gboolean
gst_encoding_target_save (GstEncodingTarget * target, GError ** error)
{
  gchar *filename;
  gchar *lfilename;

  g_return_val_if_fail (GST_IS_ENCODING_TARGET (target), FALSE);
  g_return_val_if_fail (target->category != NULL, FALSE);

  lfilename = g_strdup_printf ("%s" GST_ENCODING_TARGET_SUFFIX, target->name);
  filename =
      g_build_filename (g_get_user_data_dir (), "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, target->category, lfilename, NULL);
  g_free (lfilename);

  gst_encoding_target_save_to_file (target, filename, error);
  g_free (filename);

  return TRUE;
}

static GList *
get_categories (gchar * path)
{
  GList *res = NULL;
  GDir *topdir;
  const gchar *subdirname;

  topdir = g_dir_open (path, 0, NULL);
  if (G_UNLIKELY (topdir == NULL))
    return NULL;

  while ((subdirname = g_dir_read_name (topdir))) {
    gchar *ltmp = g_build_filename (path, subdirname, NULL);

    if (g_file_test (ltmp, G_FILE_TEST_IS_DIR)) {
      res = g_list_append (res, (gpointer) g_strdup (subdirname));
    }
    g_free (ltmp);
  }

  g_dir_close (topdir);

  return res;
}

/**
 * gst_encoding_list_available_categories:
 *
 * Lists all #GstEncodingTarget categories present on disk.
 *
 * Returns: (transfer full) (element-type gchar*): A list
 * of #GstEncodingTarget categories.
 */
GList *
gst_encoding_list_available_categories (void)
{
  GList *res = NULL;
  GList *tmp1, *tmp2;
  gchar *topdir;

  /* First try user-local categories */
  topdir =
      g_build_filename (g_get_user_data_dir (), "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, NULL);
  res = get_categories (topdir);
  g_free (topdir);

  /* Extend with system-wide categories */
  topdir = g_build_filename (GST_DATADIR, "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, NULL);
  tmp1 = get_categories (topdir);
  g_free (topdir);

  for (tmp2 = tmp1; tmp2; tmp2 = tmp2->next) {
    gchar *name = (gchar *) tmp2->data;
    if (!g_list_find_custom (res, name, (GCompareFunc) g_strcmp0))
      res = g_list_append (res, (gpointer) name);
    else
      g_free (name);
  }
  g_free (tmp1);

  return res;
}

static inline GList *
sub_get_all_targets (gchar * subdir)
{
  GList *res = NULL;
  const gchar *filename;
  GDir *dir;
  GstEncodingTarget *target;

  dir = g_dir_open (subdir, 0, NULL);
  if (G_UNLIKELY (dir == NULL))
    return NULL;

  while ((filename = g_dir_read_name (dir))) {
    gchar *fullname;

    /* Only try files ending with .gstprofile */
    if (!g_str_has_suffix (filename, GST_ENCODING_TARGET_SUFFIX))
      continue;

    fullname = g_build_filename (subdir, filename, NULL);
    target = gst_encoding_target_load_from_file (fullname, NULL);
    if (target) {
      res = g_list_append (res, target);
    } else
      GST_WARNING ("Failed to get a target from %s", fullname);
    g_free (fullname);
  }
  g_dir_close (dir);

  return res;
}

static inline GList *
get_all_targets (gchar * topdir, const gchar * categoryname)
{
  GList *res = NULL;

  if (categoryname) {
    gchar *subdir = g_build_filename (topdir, categoryname, NULL);
    /* Try to open the directory */
    res = sub_get_all_targets (subdir);
    g_free (subdir);
  } else {
    const gchar *subdirname;
    GDir *dir = g_dir_open (topdir, 0, NULL);

    if (G_UNLIKELY (dir == NULL))
      return NULL;

    while ((subdirname = g_dir_read_name (dir))) {
      gchar *ltmp = g_build_filename (topdir, subdirname, NULL);

      if (g_file_test (ltmp, G_FILE_TEST_IS_DIR)) {
        res = g_list_concat (res, sub_get_all_targets (ltmp));
      }
      g_free (ltmp);
    }
    g_dir_close (dir);
  }

  return res;
}

static guint
compare_targets (const GstEncodingTarget * ta, const GstEncodingTarget * tb)
{
  if (!g_strcmp0 (ta->name, tb->name)
      && !g_strcmp0 (ta->category, tb->category))
    return -1;

  return 0;
}

/**
 * gst_encoding_list_all_targets:
 * @categoryname: (allow-none): The category, for ex: #GST_ENCODING_CATEGORY_DEVICE.
 * Can be %NULL.
 *
 * List all available #GstEncodingTarget for the specified category, or all categories
 * if @categoryname is %NULL.
 *
 * Returns: (transfer full) (element-type GstEncodingTarget): The list of #GstEncodingTarget
 */
GList *
gst_encoding_list_all_targets (const gchar * categoryname)
{
  GList *res;
  GList *tmp1, *tmp2;
  gchar *topdir;

  /* Get user-locals */
  topdir =
      g_build_filename (g_get_user_data_dir (), "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, NULL);
  res = get_all_targets (topdir, categoryname);
  g_free (topdir);

  /* Get system-wide */
  topdir = g_build_filename (GST_DATADIR, "gstreamer-" GST_API_VERSION,
      GST_ENCODING_TARGET_DIRECTORY, NULL);
  tmp1 = get_all_targets (topdir, categoryname);
  g_free (topdir);

  /* Merge system-wide targets */
  /* FIXME : We should merge the system-wide profiles into the user-locals
   * instead of stopping at identical target names */
  for (tmp2 = tmp1; tmp2; tmp2 = tmp2->next) {
    GstEncodingTarget *target = (GstEncodingTarget *) tmp2->data;
    if (g_list_find_custom (res, target, (GCompareFunc) compare_targets))
      gst_encoding_target_unref (target);
    else
      res = g_list_append (res, target);
  }
  g_list_free (tmp1);

  return res;
}
