/* GStreamer encoding profiles library
 * Copyright (C) 2009-2010 Edward Hervey <edward.hervey@collabora.co.uk>
 *           (C) 2009-2010 Nokia Corporation
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
 * SECTION:encoding-profile
 * @short_description: Encoding profile library
 *
 * <refsect2>
 * <para>
 * Functions to create and handle encoding profiles.
 * </para>
 * <para>
 * Encoding profiles describe the media types and settings one wishes to use for
 * an encoding process. The top-level profiles are commonly
 * #GstEncodingContainerProfile(s) (which contains a user-readable name and
 * description along with which container format to use). These, in turn,
 * reference one or more #GstEncodingProfile(s) which indicate which encoding
 * format should be used on each individual streams.
 * </para>
 * <para>
 * #GstEncodingProfile(s) can be provided to the 'encodebin' element, which will take
 * care of selecting and setting up the required elements to produce an output stream
 * conforming to the specifications of the profile.
 * </para>
 * <para>
 * Unlike other systems, the encoding profiles do not specify which #GstElement to use
 * for the various encoding and muxing steps, but instead relies on specifying the format
 * one wishes to use.
 * </para>
 * <para>
 * Encoding profiles can be created at runtime by the application or loaded from (and saved
 * to) file using the #GstEncodingTarget API.
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Example: Creating a profile</title>
 * <para>
 * |[
 * #include <gst/pbutils/encoding-profile.h>
 * ...
 * GstEncodingProfile *
 * create_ogg_theora_profile(void)
 *{
 *  GstEncodingContainerProfile *prof;
 *  GstCaps *caps;
 *
 *  caps = gst_caps_from_string("application/ogg");
 *  prof = gst_encoding_container_profile_new("Ogg audio/video",
 *     "Standard OGG/THEORA/VORBIS",
 *     caps, NULL);
 *  gst_caps_unref (caps);
 *
 *  caps = gst_caps_from_string("video/x-theora");
 *  gst_encoding_container_profile_add_profile(prof,
 *       (GstEncodingProfile*) gst_encoding_video_profile_new(caps, NULL, NULL, 0));
 *  gst_caps_unref (caps);
 *
 *  caps = gst_caps_from_string("audio/x-vorbis");
 *  gst_encoding_container_profile_add_profile(prof,
 *       (GstEncodingProfile*) gst_encoding_audio_profile_new(caps, NULL, NULL, 0));
 *  gst_caps_unref (caps);
 *
 *  return (GstEncodingProfile*) prof;
 *}
 *
 *
 * ]|
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Example: Using an encoder preset with a profile</title>
 * <para>
 * |[
 * #include <gst/pbutils/encoding-profile.h>
 * ...
 * GstEncodingProfile *
 * create_ogg_theora_profile(void)
 *{
 *  GstEncodingVideoProfile *v;
 *  GstEncodingAudioProfile *a;
 *  GstEncodingContainerProfile *prof;
 *  GstCaps *caps;
 *  GstPreset *preset;
 *
 *  caps = gst_caps_from_string ("application/ogg");
 *  prof = gst_encoding_container_profile_new ("Ogg audio/video",
 *     "Standard OGG/THEORA/VORBIS",
 *     caps, NULL);
 *  gst_caps_unref (caps);
 *
 *  preset = GST_PRESET (gst_element_factory_make ("theoraenc", "theorapreset"));
 *  g_object_set (preset, "bitrate", 1000, NULL);
 *  // The preset will be saved on the filesystem,
 *  // so try to use a descriptive name
 *  gst_preset_save_preset (preset, "theora_bitrate_preset");
 *  gst_object_unref (preset);
 *
 *  caps = gst_caps_from_string ("video/x-theora");
 *  v = gst_encoding_video_profile_new (caps, "theorapreset", NULL, 0);
 *  gst_encoding_container_profile_add_profile (prof, (GstEncodingProfile*) v);
 *  gst_caps_unref (caps);
 *
 *  caps = gst_caps_from_string ("audio/x-vorbis");
 *  a = gst_encoding_audio_profile_new (caps, NULL, NULL, 0);
 *  gst_encoding_container_profile_add_profile (prof, (GstEncodingProfile*) a);
 *  gst_caps_unref (caps);
 *
 *  return (GstEncodingProfile*) prof;
 *}
 *
 *
 * ]|
 * </para>
 * </refsect2>
 * <refsect2>
 * <title>Example: Listing categories, targets and profiles</title>
 * <para>
 * |[
 * #include <gst/pbutils/encoding-profile.h>
 * ...
 * GstEncodingProfile *prof;
 * GList *categories, *tmpc;
 * GList *targets, *tmpt;
 * ...
 * categories = gst_encoding_list_available_categories ();
 *
 * ... Show available categories to user ...
 *
 * for (tmpc = categories; tmpc; tmpc = tmpc->next) {
 *   gchar *category = (gchar *) tmpc->data;
 *
 *   ... and we can list all targets within that category ...
 *
 *   targets = gst_encoding_list_all_targets (category);
 *
 *   ... and show a list to our users ...
 *
 *   g_list_foreach (targets, (GFunc) gst_encoding_target_unref, NULL);
 *   g_list_free (targets);
 * }
 *
 * g_list_foreach (categories, (GFunc) g_free, NULL);
 * g_list_free (categories);
 *
 * ...
 * ]|
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "encoding-profile.h"
#include "encoding-target.h"

#include <string.h>

/* GstEncodingProfile API */

struct _GstEncodingProfile
{
  GObject parent;

  /*< public > */
  gchar *name;
  gchar *description;
  GstCaps *format;
  gchar *preset;
  gchar *preset_name;
  guint presence;
  GstCaps *restriction;
};

struct _GstEncodingProfileClass
{
  GObjectClass parent_class;
};

enum
{
  FIRST_PROPERTY,
  PROP_RESTRICTION_CAPS,
  LAST_PROPERTY
};

static GParamSpec *_properties[LAST_PROPERTY];

static void string_to_profile_transform (const GValue * src_value,
    GValue * dest_value);
static gboolean gst_encoding_profile_deserialize_valfunc (GValue * value,
    const gchar * s);

static void gst_encoding_profile_class_init (GstEncodingProfileClass * klass);
static gpointer gst_encoding_profile_parent_class = NULL;

static void
gst_encoding_profile_class_intern_init (gpointer klass)
{
  gst_encoding_profile_parent_class = g_type_class_peek_parent (klass);
  gst_encoding_profile_class_init ((GstEncodingProfileClass *) klass);
}

GType
gst_encoding_profile_get_type (void)
{
  static volatile gsize g_define_type_id__volatile = 0;

  if (g_once_init_enter (&g_define_type_id__volatile)) {
    GType g_define_type_id = g_type_register_static_simple (G_TYPE_OBJECT,
        g_intern_static_string ("GstEncodingProfile"),
        sizeof (GstEncodingProfileClass),
        (GClassInitFunc) gst_encoding_profile_class_intern_init,
        sizeof (GstEncodingProfile),
        NULL,
        (GTypeFlags) 0);
    static GstValueTable gstvtable = {
      G_TYPE_NONE,
      (GstValueCompareFunc) NULL,
      (GstValueSerializeFunc) NULL,
      (GstValueDeserializeFunc) gst_encoding_profile_deserialize_valfunc
    };

    gstvtable.type = g_define_type_id;

    /* Register a STRING=>PROFILE GValueTransformFunc */
    g_value_register_transform_func (G_TYPE_STRING, g_define_type_id,
        string_to_profile_transform);
    /* Register gst-specific GValue functions */
    gst_value_register (&gstvtable);

    g_once_init_leave (&g_define_type_id__volatile, g_define_type_id);
  }
  return g_define_type_id__volatile;
}


static void
_encoding_profile_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstEncodingProfile *prof = (GstEncodingProfile *) object;

  switch (prop_id) {
    case PROP_RESTRICTION_CAPS:
      gst_value_set_caps (value, prof->restriction);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
_encoding_profile_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstEncodingProfile *prof = (GstEncodingProfile *) object;

  switch (prop_id) {
    case PROP_RESTRICTION_CAPS:
      gst_encoding_profile_set_restriction (prof, gst_caps_copy
          (gst_value_get_caps (value)));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_encoding_profile_finalize (GObject * object)
{
  GstEncodingProfile *prof = (GstEncodingProfile *) object;
  if (prof->name)
    g_free (prof->name);
  if (prof->format)
    gst_caps_unref (prof->format);
  if (prof->preset)
    g_free (prof->preset);
  if (prof->description)
    g_free (prof->description);
  if (prof->restriction)
    gst_caps_unref (prof->restriction);
  if (prof->preset_name)
    g_free (prof->preset_name);
}

static void
gst_encoding_profile_class_init (GstEncodingProfileClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->finalize = gst_encoding_profile_finalize;

  gobject_class->set_property = _encoding_profile_set_property;
  gobject_class->get_property = _encoding_profile_get_property;

  _properties[PROP_RESTRICTION_CAPS] =
      g_param_spec_boxed ("restriction-caps", "Restriction caps",
      "The restriction caps to use", GST_TYPE_CAPS,
      G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);

  g_object_class_install_property (gobject_class,
      PROP_RESTRICTION_CAPS, _properties[PROP_RESTRICTION_CAPS]);

}

/**
 * gst_encoding_profile_get_name:
 * @profile: a #GstEncodingProfile
 *
 * Returns: the name of the profile, can be %NULL.
 */
const gchar *
gst_encoding_profile_get_name (GstEncodingProfile * profile)
{
  return profile->name;
}

/**
 * gst_encoding_profile_get_description:
 * @profile: a #GstEncodingProfile
 *
 * Returns: the description of the profile, can be %NULL.
 */
const gchar *
gst_encoding_profile_get_description (GstEncodingProfile * profile)
{
  return profile->description;
}

/**
 * gst_encoding_profile_get_format:
 * @profile: a #GstEncodingProfile
 *
 * Returns: (transfer full): the #GstCaps corresponding to the media format used
 * in the profile. Unref after usage.
 */
GstCaps *
gst_encoding_profile_get_format (GstEncodingProfile * profile)
{
  return (profile->format ? gst_caps_ref (profile->format) : NULL);
}

/**
 * gst_encoding_profile_get_preset:
 * @profile: a #GstEncodingProfile
 *
 * Returns: the name of the #GstPreset to be used in the profile.
 * This is the name that has been set when saving the preset.
 */
const gchar *
gst_encoding_profile_get_preset (GstEncodingProfile * profile)
{
  return profile->preset;
}

/**
 * gst_encoding_profile_get_preset_name:
 * @profile: a #GstEncodingProfile
 *
 * Returns: the name of the #GstPreset factory to be used in the profile.
 */
const gchar *
gst_encoding_profile_get_preset_name (GstEncodingProfile * profile)
{
  return profile->preset_name;
}

/**
 * gst_encoding_profile_get_presence:
 * @profile: a #GstEncodingProfile
 *
 * Returns: The number of times the profile is used in its parent
 * container profile. If 0, it is not a mandatory stream.
 */
guint
gst_encoding_profile_get_presence (GstEncodingProfile * profile)
{
  return profile->presence;
}

/**
 * gst_encoding_profile_get_restriction:
 * @profile: a #GstEncodingProfile
 *
 * Returns: (transfer full): The restriction #GstCaps to apply before the encoder
 * that will be used in the profile. The fields present in restriction caps are
 * properties of the raw stream (that is before encoding), such as height and
 * width for video and depth and sampling rate for audio. Does not apply to
 * #GstEncodingContainerProfile (since there is no corresponding raw stream).
 * Can be %NULL. Unref after usage.
 */
GstCaps *
gst_encoding_profile_get_restriction (GstEncodingProfile * profile)
{
  return (profile->restriction ? gst_caps_ref (profile->restriction) : NULL);
}

/**
 * gst_encoding_profile_set_name:
 * @profile: a #GstEncodingProfile
 * @name: the name to set on the profile
 *
 * Set @name as the given name for the @profile. A copy of @name will be made
 * internally.
 */
void
gst_encoding_profile_set_name (GstEncodingProfile * profile, const gchar * name)
{
  if (profile->name)
    g_free (profile->name);
  profile->name = g_strdup (name);
}

/**
 * gst_encoding_profile_set_description:
 * @profile: a #GstEncodingProfile
 * @description: the description to set on the profile
 *
 * Set @description as the given description for the @profile. A copy of
 * @description will be made internally.
 */
void
gst_encoding_profile_set_description (GstEncodingProfile * profile,
    const gchar * description)
{
  if (profile->description)
    g_free (profile->description);
  profile->description = g_strdup (description);
}

/**
 * gst_encoding_profile_set_format:
 * @profile: a #GstEncodingProfile
 * @format: the media format to use in the profile.
 *
 * Sets the media format used in the profile.
 */
void
gst_encoding_profile_set_format (GstEncodingProfile * profile, GstCaps * format)
{
  if (profile->format)
    gst_caps_unref (profile->format);
  profile->format = gst_caps_ref (format);
}

/**
 * gst_encoding_profile_set_preset:
 * @profile: a #GstEncodingProfile
 * @preset: the element preset to use
 *
 * Sets the name of the #GstElement that implements the #GstPreset interface
 * to use for the profile.
 * This is the name that has been set when saving the preset.
 */
void
gst_encoding_profile_set_preset (GstEncodingProfile * profile,
    const gchar * preset)
{
  if (profile->preset)
    g_free (profile->preset);
  profile->preset = g_strdup (preset);
}

/**
 * gst_encoding_profile_set_preset_name:
 * @profile: a #GstEncodingProfile
 * @preset_name: The name of the preset to use in this @profile.
 *
 * Sets the name of the #GstPreset's factory to be used in the profile.
 */
void
gst_encoding_profile_set_preset_name (GstEncodingProfile * profile,
    const gchar * preset_name)
{
  if (profile->preset_name)
    g_free (profile->preset_name);
  profile->preset_name = g_strdup (preset_name);
}

/**
 * gst_encoding_profile_set_presence:
 * @profile: a #GstEncodingProfile
 * @presence: the number of time the profile can be used
 *
 * Set the number of time the profile is used in its parent
 * container profile. If 0, it is not a mandatory stream
 */
void
gst_encoding_profile_set_presence (GstEncodingProfile * profile, guint presence)
{
  profile->presence = presence;
}

/**
 * gst_encoding_profile_set_restriction:
 * @profile: a #GstEncodingProfile
 * @restriction: (transfer full): the restriction to apply
 *
 * Set the restriction #GstCaps to apply before the encoder
 * that will be used in the profile. See gst_encoding_profile_get_restriction()
 * for more about restrictions. Does not apply to #GstEncodingContainerProfile.
 */
void
gst_encoding_profile_set_restriction (GstEncodingProfile * profile,
    GstCaps * restriction)
{
  if (profile->restriction)
    gst_caps_unref (profile->restriction);
  profile->restriction = restriction;

  g_object_notify_by_pspec (G_OBJECT (profile),
      _properties[PROP_RESTRICTION_CAPS]);
}

/* Container profiles */

struct _GstEncodingContainerProfile
{
  GstEncodingProfile parent;

  GList *encodingprofiles;
};

struct _GstEncodingContainerProfileClass
{
  GstEncodingProfileClass parent;
};

G_DEFINE_TYPE (GstEncodingContainerProfile, gst_encoding_container_profile,
    GST_TYPE_ENCODING_PROFILE);

static void
gst_encoding_container_profile_init (GstEncodingContainerProfile * prof)
{
  /* Nothing to initialize */
}

static void
gst_encoding_container_profile_finalize (GObject * object)
{
  GstEncodingContainerProfile *prof = (GstEncodingContainerProfile *) object;

  g_list_foreach (prof->encodingprofiles, (GFunc) g_object_unref, NULL);
  g_list_free (prof->encodingprofiles);

  G_OBJECT_CLASS (gst_encoding_container_profile_parent_class)->finalize
      ((GObject *) prof);
}

static void
gst_encoding_container_profile_class_init (GstEncodingContainerProfileClass * k)
{
  GObjectClass *gobject_class = (GObjectClass *) k;

  gobject_class->finalize = gst_encoding_container_profile_finalize;
}

/**
 * gst_encoding_container_profile_get_profiles:
 * @profile: a #GstEncodingContainerProfile
 *
 * Returns: (element-type GstPbutils.EncodingProfile) (transfer none):
 * the list of contained #GstEncodingProfile.
 */
const GList *
gst_encoding_container_profile_get_profiles (GstEncodingContainerProfile *
    profile)
{
  return profile->encodingprofiles;
}

/* Video profiles */

struct _GstEncodingVideoProfile
{
  GstEncodingProfile parent;

  guint pass;
  gboolean variableframerate;
};

struct _GstEncodingVideoProfileClass
{
  GstEncodingProfileClass parent;
};

G_DEFINE_TYPE (GstEncodingVideoProfile, gst_encoding_video_profile,
    GST_TYPE_ENCODING_PROFILE);

static void
gst_encoding_video_profile_init (GstEncodingVideoProfile * prof)
{
  /* Nothing to initialize */
}

static void
gst_encoding_video_profile_class_init (GstEncodingVideoProfileClass * klass)
{
}

/**
 * gst_encoding_video_profile_get_pass:
 * @prof: a #GstEncodingVideoProfile
 *
 * Get the pass number if this is part of a multi-pass profile.
 *
 * Returns: The pass number. Starts at 1 for multi-pass. 0 if this is
 * not a multi-pass profile
 */
guint
gst_encoding_video_profile_get_pass (GstEncodingVideoProfile * prof)
{
  return prof->pass;
}

/**
 * gst_encoding_video_profile_get_variableframerate:
 * @prof: a #GstEncodingVideoProfile
 *
 * Returns: Whether non-constant video framerate is allowed for encoding.
 */
gboolean
gst_encoding_video_profile_get_variableframerate (GstEncodingVideoProfile *
    prof)
{
  return prof->variableframerate;
}

/**
 * gst_encoding_video_profile_set_pass:
 * @prof: a #GstEncodingVideoProfile
 * @pass: the pass number for this profile
 *
 * Sets the pass number of this video profile. The first pass profile should have
 * this value set to 1. If this video profile isn't part of a multi-pass profile,
 * you may set it to 0 (the default value).
 */
void
gst_encoding_video_profile_set_pass (GstEncodingVideoProfile * prof, guint pass)
{
  prof->pass = pass;
}

/**
 * gst_encoding_video_profile_set_variableframerate:
 * @prof: a #GstEncodingVideoProfile
 * @variableframerate: a boolean
 *
 * If set to %TRUE, then the incoming stream will be allowed to have non-constant
 * framerate. If set to %FALSE (default value), then the incoming stream will
 * be normalized by dropping/duplicating frames in order to produce a
 * constance framerate.
 */
void
gst_encoding_video_profile_set_variableframerate (GstEncodingVideoProfile *
    prof, gboolean variableframerate)
{
  prof->variableframerate = variableframerate;
}

/* Audio profiles */

struct _GstEncodingAudioProfile
{
  GstEncodingProfile parent;
};

struct _GstEncodingAudioProfileClass
{
  GstEncodingProfileClass parent;
};

G_DEFINE_TYPE (GstEncodingAudioProfile, gst_encoding_audio_profile,
    GST_TYPE_ENCODING_PROFILE);

static void
gst_encoding_audio_profile_init (GstEncodingAudioProfile * prof)
{
  /* Nothing to initialize */
}

static void
gst_encoding_audio_profile_class_init (GstEncodingAudioProfileClass * klass)
{
}

static inline gboolean
_gst_caps_is_equal_safe (GstCaps * a, GstCaps * b)
{
  if (a == b)
    return TRUE;
  if ((a == NULL) || (b == NULL))
    return FALSE;
  return gst_caps_is_equal (a, b);
}

static gint
_compare_container_encoding_profiles (GstEncodingContainerProfile * ca,
    GstEncodingContainerProfile * cb)
{
  GList *tmp;

  if (g_list_length (ca->encodingprofiles) !=
      g_list_length (cb->encodingprofiles))
    return -1;

  for (tmp = ca->encodingprofiles; tmp; tmp = tmp->next) {
    GstEncodingProfile *prof = (GstEncodingProfile *) tmp->data;
    if (!gst_encoding_container_profile_contains_profile (ca, prof))
      return -1;
  }

  return 0;
}

static gint
_compare_encoding_profiles (const GstEncodingProfile * a,
    const GstEncodingProfile * b)
{
  if ((G_TYPE_FROM_INSTANCE (a) != G_TYPE_FROM_INSTANCE (b)) ||
      !_gst_caps_is_equal_safe (a->format, b->format) ||
      (g_strcmp0 (a->preset, b->preset) != 0) ||
      (g_strcmp0 (a->name, b->name) != 0) ||
      (g_strcmp0 (a->description, b->description) != 0))
    return -1;

  if (GST_IS_ENCODING_CONTAINER_PROFILE (a))
    return
        _compare_container_encoding_profiles (GST_ENCODING_CONTAINER_PROFILE
        (a), GST_ENCODING_CONTAINER_PROFILE (b));

  if (GST_IS_ENCODING_VIDEO_PROFILE (a)) {
    GstEncodingVideoProfile *va = (GstEncodingVideoProfile *) a;
    GstEncodingVideoProfile *vb = (GstEncodingVideoProfile *) b;

    if ((va->pass != vb->pass)
        || (va->variableframerate != vb->variableframerate))
      return -1;
  }

  return 0;
}

/**
 * gst_encoding_container_profile_contains_profile:
 * @container: a #GstEncodingContainerProfile
 * @profile: a #GstEncodingProfile
 *
 * Checks if @container contains a #GstEncodingProfile identical to
 * @profile.
 *
 * Returns: %TRUE if @container contains a #GstEncodingProfile identical
 * to @profile, else %FALSE.
 */
gboolean
gst_encoding_container_profile_contains_profile (GstEncodingContainerProfile *
    container, GstEncodingProfile * profile)
{
  g_return_val_if_fail (GST_IS_ENCODING_CONTAINER_PROFILE (container), FALSE);
  g_return_val_if_fail (GST_IS_ENCODING_PROFILE (profile), FALSE);

  return (g_list_find_custom (container->encodingprofiles, profile,
          (GCompareFunc) _compare_encoding_profiles) != NULL);
}

/**
 * gst_encoding_container_profile_add_profile:
 * @container: the #GstEncodingContainerProfile to use
 * @profile: (transfer full): the #GstEncodingProfile to add.
 *
 * Add a #GstEncodingProfile to the list of profiles handled by @container.
 *
 * No copy of @profile will be made, if you wish to use it elsewhere after this
 * method you should increment its reference count.
 *
 * Returns: %TRUE if the @stream was properly added, else %FALSE.
 */
gboolean
gst_encoding_container_profile_add_profile (GstEncodingContainerProfile *
    container, GstEncodingProfile * profile)
{
  g_return_val_if_fail (GST_IS_ENCODING_CONTAINER_PROFILE (container), FALSE);
  g_return_val_if_fail (GST_IS_ENCODING_PROFILE (profile), FALSE);

  if (g_list_find_custom (container->encodingprofiles, profile,
          (GCompareFunc) _compare_encoding_profiles)) {
    GST_ERROR
        ("Encoding profile already contains an identical GstEncodingProfile");
    return FALSE;
  }

  container->encodingprofiles =
      g_list_append (container->encodingprofiles, profile);

  return TRUE;
}

static GstEncodingProfile *
common_creation (GType objtype, GstCaps * format, const gchar * preset,
    const gchar * name, const gchar * description, GstCaps * restriction,
    guint presence)
{
  GstEncodingProfile *prof;

  prof = (GstEncodingProfile *) g_object_new (objtype, NULL);

  if (name)
    prof->name = g_strdup (name);
  if (description)
    prof->description = g_strdup (description);
  if (preset)
    prof->preset = g_strdup (preset);
  if (format)
    prof->format = gst_caps_ref (format);
  if (restriction)
    prof->restriction = gst_caps_ref (restriction);
  prof->presence = presence;
  prof->preset_name = NULL;

  return prof;
}

/**
 * gst_encoding_container_profile_new:
 * @name: (allow-none): The name of the container profile, can be %NULL
 * @description: (allow-none): The description of the container profile,
 *     can be %NULL
 * @format: The format to use for this profile
 * @preset: (allow-none): The preset to use for this profile.
 *
 * Creates a new #GstEncodingContainerProfile.
 *
 * Returns: The newly created #GstEncodingContainerProfile.
 */
GstEncodingContainerProfile *
gst_encoding_container_profile_new (const gchar * name,
    const gchar * description, GstCaps * format, const gchar * preset)
{
  g_return_val_if_fail (GST_IS_CAPS (format), NULL);

  return (GstEncodingContainerProfile *)
      common_creation (GST_TYPE_ENCODING_CONTAINER_PROFILE, format, preset,
      name, description, NULL, 0);
}

/**
 * gst_encoding_video_profile_new:
 * @format: the #GstCaps
 * @preset: (allow-none): the preset(s) to use on the encoder, can be #NULL
 * @restriction: (allow-none): the #GstCaps used to restrict the input to the encoder, can be
 * NULL. See gst_encoding_profile_get_restriction() for more details.
 * @presence: the number of time this stream must be used. 0 means any number of
 *  times (including never)
 *
 * Creates a new #GstEncodingVideoProfile
 *
 * All provided allocatable arguments will be internally copied, so can be
 * safely freed/unreferenced after calling this method.
 *
 * If you wish to control the pass number (in case of multi-pass scenarios),
 * please refer to the gst_encoding_video_profile_set_pass() documentation.
 *
 * If you wish to use/force a constant framerate please refer to the
 * gst_encoding_video_profile_set_variableframerate() documentation.
 *
 * Returns: the newly created #GstEncodingVideoProfile.
 */
GstEncodingVideoProfile *
gst_encoding_video_profile_new (GstCaps * format, const gchar * preset,
    GstCaps * restriction, guint presence)
{
  return (GstEncodingVideoProfile *)
      common_creation (GST_TYPE_ENCODING_VIDEO_PROFILE, format, preset, NULL,
      NULL, restriction, presence);
}

/**
 * gst_encoding_audio_profile_new:
 * @format: the #GstCaps
 * @preset: (allow-none): the preset(s) to use on the encoder, can be #NULL
 * @restriction: (allow-none): the #GstCaps used to restrict the input to the encoder, can be
 * NULL. See gst_encoding_profile_get_restriction() for more details.
 * @presence: the number of time this stream must be used. 0 means any number of
 *  times (including never)
 *
 * Creates a new #GstEncodingAudioProfile
 *
 * All provided allocatable arguments will be internally copied, so can be
 * safely freed/unreferenced after calling this method.
 *
 * Returns: the newly created #GstEncodingAudioProfile.
 */
GstEncodingAudioProfile *
gst_encoding_audio_profile_new (GstCaps * format, const gchar * preset,
    GstCaps * restriction, guint presence)
{
  return (GstEncodingAudioProfile *)
      common_creation (GST_TYPE_ENCODING_AUDIO_PROFILE, format, preset, NULL,
      NULL, restriction, presence);
}


/**
 * gst_encoding_profile_is_equal:
 * @a: a #GstEncodingProfile
 * @b: a #GstEncodingProfile
 *
 * Checks whether the two #GstEncodingProfile are equal
 *
 * Returns: %TRUE if @a and @b are equal, else %FALSE.
 */
gboolean
gst_encoding_profile_is_equal (GstEncodingProfile * a, GstEncodingProfile * b)
{
  return (_compare_encoding_profiles (a, b) == 0);
}


/**
 * gst_encoding_profile_get_input_caps:
 * @profile: a #GstEncodingProfile
 *
 * Computes the full output caps that this @profile will be able to consume.
 *
 * Returns: (transfer full): The full caps the given @profile can consume. Call
 * gst_caps_unref() when you are done with the caps.
 */
GstCaps *
gst_encoding_profile_get_input_caps (GstEncodingProfile * profile)
{
  GstCaps *out, *tmp;
  GList *ltmp;
  GstStructure *st, *outst;
  GQuark out_name;
  guint i, len;
  GstCaps *fcaps;

  if (GST_IS_ENCODING_CONTAINER_PROFILE (profile)) {
    GstCaps *res = gst_caps_new_empty ();

    for (ltmp = GST_ENCODING_CONTAINER_PROFILE (profile)->encodingprofiles;
        ltmp; ltmp = ltmp->next) {
      GstEncodingProfile *sprof = (GstEncodingProfile *) ltmp->data;
      res = gst_caps_merge (res, gst_encoding_profile_get_input_caps (sprof));
    }
    return res;
  }

  fcaps = profile->format;

  /* fast-path */
  if ((profile->restriction == NULL) || gst_caps_is_any (profile->restriction))
    return gst_caps_ref (fcaps);

  /* Combine the format with the restriction caps */
  outst = gst_caps_get_structure (fcaps, 0);
  out_name = gst_structure_get_name_id (outst);
  tmp = gst_caps_new_empty ();
  len = gst_caps_get_size (profile->restriction);

  for (i = 0; i < len; i++) {
    st = gst_structure_copy (gst_caps_get_structure (profile->restriction, i));
    st->name = out_name;
    gst_caps_append_structure (tmp, st);
  }

  out = gst_caps_intersect (tmp, fcaps);
  gst_caps_unref (tmp);

  return out;
}

/**
 * gst_encoding_profile_get_type_nick:
 * @profile: a #GstEncodingProfile
 *
 * Returns: the human-readable name of the type of @profile.
 */
const gchar *
gst_encoding_profile_get_type_nick (GstEncodingProfile * profile)
{
  if (GST_IS_ENCODING_CONTAINER_PROFILE (profile))
    return "container";
  if (GST_IS_ENCODING_VIDEO_PROFILE (profile))
    return "video";
  if (GST_IS_ENCODING_AUDIO_PROFILE (profile))
    return "audio";
  return NULL;
}

extern const gchar *pb_utils_get_file_extension_from_caps (const GstCaps *
    caps);
gboolean pb_utils_is_tag (const GstCaps * caps);

static gboolean
gst_encoding_profile_has_format (GstEncodingProfile * profile,
    const gchar * media_type)
{
  GstCaps *caps;
  gboolean ret;

  caps = gst_encoding_profile_get_format (profile);
  ret = gst_structure_has_name (gst_caps_get_structure (caps, 0), media_type);
  gst_caps_unref (caps);

  return ret;
}

static gboolean
gst_encoding_container_profile_has_video (GstEncodingContainerProfile * profile)
{
  const GList *l;

  for (l = profile->encodingprofiles; l != NULL; l = l->next) {
    if (GST_IS_ENCODING_VIDEO_PROFILE (l->data))
      return TRUE;
    if (GST_IS_ENCODING_CONTAINER_PROFILE (l->data) &&
        gst_encoding_container_profile_has_video (l->data))
      return TRUE;
  }

  return FALSE;
}

/**
 * gst_encoding_profile_get_file_extension:
 * @profile: a #GstEncodingProfile
 *
 * Returns: a suitable file extension for @profile, or NULL.
 */
const gchar *
gst_encoding_profile_get_file_extension (GstEncodingProfile * profile)
{
  GstEncodingContainerProfile *cprofile;
  const gchar *ext = NULL;
  gboolean has_video;
  GstCaps *caps;
  guint num_children;

  g_return_val_if_fail (GST_IS_ENCODING_PROFILE (profile), NULL);

  caps = gst_encoding_profile_get_format (profile);
  ext = pb_utils_get_file_extension_from_caps (caps);

  if (!GST_IS_ENCODING_CONTAINER_PROFILE (profile))
    goto done;

  cprofile = GST_ENCODING_CONTAINER_PROFILE (profile);

  num_children = g_list_length (cprofile->encodingprofiles);

  /* if it's a tag container profile (e.g. id3mux/apemux), we need
   * to look at what's inside it */
  if (pb_utils_is_tag (caps)) {
    GST_DEBUG ("tag container profile");
    if (num_children == 1) {
      GstEncodingProfile *child_profile = cprofile->encodingprofiles->data;

      ext = gst_encoding_profile_get_file_extension (child_profile);
    } else {
      GST_WARNING ("expected exactly one child profile with tag profile");
    }
    goto done;
  }

  if (num_children == 0)
    goto done;

  /* special cases */
  has_video = gst_encoding_container_profile_has_video (cprofile);

  /* Ogg */
  if (strcmp (ext, "ogg") == 0) {
    /* ogg with video => .ogv */
    if (has_video) {
      ext = "ogv";
      goto done;
    }
    /* ogg with just speex audio => .spx */
    if (num_children == 1) {
      GstEncodingProfile *child_profile = cprofile->encodingprofiles->data;

      if (GST_IS_ENCODING_AUDIO_PROFILE (child_profile) &&
          gst_encoding_profile_has_format (child_profile, "audio/x-speex")) {
        ext = "spx";
        goto done;
      }
    }
    /* does anyone actually use .oga for ogg audio files? */
    goto done;
  }

  /* Matroska */
  if (has_video && strcmp (ext, "mka") == 0) {
    ext = "mkv";
    goto done;
  }

  /* Windows Media / ASF */
  if (gst_encoding_profile_has_format (profile, "video/x-ms-asf")) {
    const GList *l;
    guint num_wmv = 0, num_wma = 0, num_other = 0;

    for (l = cprofile->encodingprofiles; l != NULL; l = l->next) {
      if (gst_encoding_profile_has_format (l->data, "video/x-wmv"))
        ++num_wmv;
      else if (gst_encoding_profile_has_format (l->data, "audio/x-wma"))
        ++num_wma;
      else
        ++num_other;
    }

    if (num_other > 0)
      ext = "asf";
    else if (num_wmv > 0)
      ext = "wmv";
    else if (num_wma > 0)
      ext = "wma";

    goto done;
  }

done:

  GST_INFO ("caps %" GST_PTR_FORMAT ", ext: %s", caps, GST_STR_NULL (ext));
  gst_caps_unref (caps);
  return ext;
}

/**
 * gst_encoding_profile_find:
 * @targetname: (transfer none): The name of the target
 * @profilename: (transfer none): The name of the profile
 * @category: (transfer none) (allow-none): The target category. Can be %NULL
 *
 * Find the #GstEncodingProfile with the specified name and category.
 *
 * Returns: (transfer full): The matching #GstEncodingProfile or %NULL.
 */
GstEncodingProfile *
gst_encoding_profile_find (const gchar * targetname, const gchar * profilename,
    const gchar * category)
{
  GstEncodingProfile *res = NULL;
  GstEncodingTarget *target;

  g_return_val_if_fail (targetname != NULL, NULL);
  g_return_val_if_fail (profilename != NULL, NULL);

  /* FIXME : how do we handle profiles named the same in several
   * categories but of which only one has the required profile ? */
  target = gst_encoding_target_load (targetname, category, NULL);
  if (target) {
    res = gst_encoding_target_get_profile (target, profilename);
    gst_encoding_target_unref (target);
  }

  return res;
}

static GstEncodingProfile *
combo_search (const gchar * pname)
{
  GstEncodingProfile *res;
  gchar **split;

  /* Splitup */
  split = g_strsplit (pname, "/", 2);
  if (g_strv_length (split) != 2)
    return NULL;

  res = gst_encoding_profile_find (split[0], split[1], NULL);

  g_strfreev (split);

  return res;
}

/* GValue transform function */
static void
string_to_profile_transform (const GValue * src_value, GValue * dest_value)
{
  const gchar *profilename;
  GstEncodingProfile *profile;

  profilename = g_value_get_string (src_value);

  profile = combo_search (profilename);

  if (profile)
    g_value_take_object (dest_value, (GObject *) profile);
}

static gboolean
gst_encoding_profile_deserialize_valfunc (GValue * value, const gchar * s)
{
  GstEncodingProfile *profile;

  profile = combo_search (s);

  if (profile) {
    g_value_take_object (value, (GObject *) profile);
    return TRUE;
  }

  return FALSE;
}

/**
 * gst_encoding_profile_from_discoverer:
 * @info: (transfer none): The #GstDiscovererInfo to read from
 *
 * Creates a #GstEncodingProfile matching the formats from the given
 * #GstDiscovererInfo. Streams other than audio or video (eg,
 * subtitles), are currently ignored.
 *
 * Returns: (transfer full): The new #GstEncodingProfile or %NULL.
 */
GstEncodingProfile *
gst_encoding_profile_from_discoverer (GstDiscovererInfo * info)
{
  GstEncodingContainerProfile *profile;
  GstDiscovererStreamInfo *sinfo;
  GList *streams, *stream;
  GstCaps *caps = NULL;

  if (!info || gst_discoverer_info_get_result (info) != GST_DISCOVERER_OK)
    return NULL;

  sinfo = gst_discoverer_info_get_stream_info (info);
  if (!sinfo)
    return NULL;

  caps = gst_discoverer_stream_info_get_caps (sinfo);
  GST_LOG ("Container: %" GST_PTR_FORMAT "\n", caps);
  profile =
      gst_encoding_container_profile_new ("auto-generated",
      "Automatically generated from GstDiscovererInfo", caps, NULL);
  gst_caps_unref (caps);
  if (!profile) {
    GST_ERROR ("Failed to create container profile from caps %" GST_PTR_FORMAT,
        caps);
    return NULL;
  }

  streams =
      gst_discoverer_container_info_get_streams (GST_DISCOVERER_CONTAINER_INFO
      (sinfo));
  for (stream = streams; stream; stream = stream->next) {
    GstEncodingProfile *sprofile = NULL;
    sinfo = (GstDiscovererStreamInfo *) stream->data;
    caps = gst_discoverer_stream_info_get_caps (sinfo);
    GST_LOG ("Stream: %" GST_PTR_FORMAT "\n", caps);
    if (GST_IS_DISCOVERER_AUDIO_INFO (sinfo)) {
      sprofile =
          (GstEncodingProfile *) gst_encoding_audio_profile_new (caps, NULL,
          NULL, 0);
    } else if (GST_IS_DISCOVERER_VIDEO_INFO (sinfo)) {
      sprofile =
          (GstEncodingProfile *) gst_encoding_video_profile_new (caps, NULL,
          NULL, 0);
    } else {
      /* subtitles or other ? ignore for now */
    }
    if (sprofile)
      gst_encoding_container_profile_add_profile (profile, sprofile);
    else
      GST_ERROR ("Failed to create stream profile from caps %" GST_PTR_FORMAT,
          caps);
    gst_caps_unref (caps);
  }
  gst_discoverer_stream_info_list_free (streams);

  return (GstEncodingProfile *) profile;
}
