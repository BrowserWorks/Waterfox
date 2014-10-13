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

#ifndef __GST_PROFILE_H__
#define __GST_PROFILE_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#include <gst/pbutils/pbutils-enumtypes.h>
#include <gst/pbutils/gstdiscoverer.h>

/**
 * GstEncodingProfile:
 *
 * The opaque base class object for all encoding profiles. This contains generic
 * information like name, description, format and preset.
 */

#define GST_TYPE_ENCODING_PROFILE                       \
  (gst_encoding_profile_get_type ())
#define GST_ENCODING_PROFILE(obj)                       \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_ENCODING_PROFILE, GstEncodingProfile))
#define GST_IS_ENCODING_PROFILE(obj)                    \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_ENCODING_PROFILE))
typedef struct _GstEncodingProfile GstEncodingProfile;
typedef struct _GstEncodingProfileClass GstEncodingProfileClass;
GType gst_encoding_profile_get_type (void);



/**
 * GstEncodingContainerProfile:
 *
 * Encoding profiles for containers. Keeps track of a list of #GstEncodingProfile
 */
#define GST_TYPE_ENCODING_CONTAINER_PROFILE                     \
  (gst_encoding_container_profile_get_type ())
#define GST_ENCODING_CONTAINER_PROFILE(obj)                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_ENCODING_CONTAINER_PROFILE, GstEncodingContainerProfile))
#define GST_IS_ENCODING_CONTAINER_PROFILE(obj)                  \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_ENCODING_CONTAINER_PROFILE))
typedef struct _GstEncodingContainerProfile GstEncodingContainerProfile;
typedef struct _GstEncodingContainerProfileClass GstEncodingContainerProfileClass;
GType gst_encoding_container_profile_get_type (void);



/**
 * GstEncodingVideoProfile:
 *
 * Variant of #GstEncodingProfile for video streams, allows specifying the @pass.
 */
#define GST_TYPE_ENCODING_VIDEO_PROFILE                 \
  (gst_encoding_video_profile_get_type ())
#define GST_ENCODING_VIDEO_PROFILE(obj)                 \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_ENCODING_VIDEO_PROFILE, GstEncodingVideoProfile))
#define GST_IS_ENCODING_VIDEO_PROFILE(obj)                      \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_ENCODING_VIDEO_PROFILE))
typedef struct _GstEncodingVideoProfile GstEncodingVideoProfile;
typedef struct _GstEncodingVideoProfileClass GstEncodingVideoProfileClass;
GType gst_encoding_video_profile_get_type (void);



/**
 * GstEncodingAudioProfile:
 *
 * Variant of #GstEncodingProfile for audio streams.
 */
#define GST_TYPE_ENCODING_AUDIO_PROFILE                 \
  (gst_encoding_audio_profile_get_type ())
#define GST_ENCODING_AUDIO_PROFILE(obj)                 \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_ENCODING_AUDIO_PROFILE, GstEncodingAudioProfile))
#define GST_IS_ENCODING_AUDIO_PROFILE(obj)                      \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_ENCODING_AUDIO_PROFILE))
typedef struct _GstEncodingAudioProfile GstEncodingAudioProfile;
typedef struct _GstEncodingAudioProfileClass GstEncodingAudioProfileClass;
GType gst_encoding_audio_profile_get_type (void);



/* GstEncodingProfile API */

/**
 * gst_encoding_profile_unref:
 * @profile: a #GstEncodingProfile
 *
 * Decreases the reference count of the @profile, possibly freeing the @profile.
 */
#define gst_encoding_profile_unref(profile) (g_object_unref ((GObject*) profile))

/**
 * gst_encoding_profile_ref:
 * @profile: a #GstEncodingProfile
 *
 * Increases the reference count of the @profile.
 */
#define gst_encoding_profile_ref(profile) (g_object_ref ((GObject*) profile))

const gchar *   gst_encoding_profile_get_name           (GstEncodingProfile *profile);
void            gst_encoding_profile_set_name           (GstEncodingProfile *profile,
                                                         const gchar *name);
const gchar *   gst_encoding_profile_get_description    (GstEncodingProfile *profile);
void            gst_encoding_profile_set_description    (GstEncodingProfile *profile,
                                                         const gchar *description);
GstCaps *       gst_encoding_profile_get_format         (GstEncodingProfile *profile);
void            gst_encoding_profile_set_format         (GstEncodingProfile *profile,
                                                         GstCaps *format);
const gchar *   gst_encoding_profile_get_preset         (GstEncodingProfile *profile);
const gchar *   gst_encoding_profile_get_preset_name    (GstEncodingProfile *profile);
void            gst_encoding_profile_set_preset         (GstEncodingProfile *profile,
                                                         const gchar *preset);
guint           gst_encoding_profile_get_presence       (GstEncodingProfile *profile);
void            gst_encoding_profile_set_presence       (GstEncodingProfile *profile,
                                                         guint presence);
void            gst_encoding_profile_set_preset_name    (GstEncodingProfile * profile,
                                                         const gchar * preset_name);
GstCaps *       gst_encoding_profile_get_restriction    (GstEncodingProfile *profile);
void            gst_encoding_profile_set_restriction    (GstEncodingProfile *profile,
                                                         GstCaps *restriction);

gboolean        gst_encoding_profile_is_equal           (GstEncodingProfile *a,
                                                         GstEncodingProfile *b);
GstCaps *       gst_encoding_profile_get_input_caps     (GstEncodingProfile *profile);
const gchar *   gst_encoding_profile_get_type_nick      (GstEncodingProfile *profile);

const gchar *   gst_encoding_profile_get_file_extension (GstEncodingProfile * profile);

GstEncodingProfile * gst_encoding_profile_find (const gchar *targetname,
                                                const gchar *profilename,
                                                const gchar *category);

/* GstEncodingContainerProfile API */
gboolean        gst_encoding_container_profile_add_profile       (GstEncodingContainerProfile *container,
                                                                  GstEncodingProfile *profile);
gboolean        gst_encoding_container_profile_contains_profile  (GstEncodingContainerProfile * container,
                                                                  GstEncodingProfile *profile);
const GList *   gst_encoding_container_profile_get_profiles      (GstEncodingContainerProfile *profile);


GstEncodingContainerProfile *  gst_encoding_container_profile_new (const gchar *name,
                                                                   const gchar *description,
                                                                   GstCaps *format,
                                                                   const gchar *preset);


/* Invidual stream encodingprofile API */
GstEncodingVideoProfile * gst_encoding_video_profile_new (GstCaps *format,
                                                          const gchar *preset,
                                                          GstCaps *restriction,
                                                          guint presence);
GstEncodingAudioProfile * gst_encoding_audio_profile_new (GstCaps *format,
                                                          const gchar *preset,
                                                          GstCaps *restriction,
                                                          guint presence);

guint    gst_encoding_video_profile_get_pass              (GstEncodingVideoProfile *prof);
gboolean gst_encoding_video_profile_get_variableframerate (GstEncodingVideoProfile *prof);

void     gst_encoding_video_profile_set_pass              (GstEncodingVideoProfile *prof,
                                                           guint pass);
void     gst_encoding_video_profile_set_variableframerate (GstEncodingVideoProfile *prof,
                                                           gboolean variableframerate);

GstEncodingProfile * gst_encoding_profile_from_discoverer (GstDiscovererInfo *info);

G_END_DECLS

#endif /* __GST_PROFILE_H__ */
