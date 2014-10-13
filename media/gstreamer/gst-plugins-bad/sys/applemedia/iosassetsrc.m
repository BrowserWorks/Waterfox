/* GStreamer
 * Copyright (C) 2013 Fluendo S.L. <support@fluendo.com>
 *   Authors:    2013 Andoni Morales Alastruey <amorales@fluendo.com>
 * Copyright (C) 2013 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstios_assetsrc.c:
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */
/**
 * SECTION:element-ios_assetsrc
 * @see_also: #GstIOSAssetSrc
 *
 * Read data from an iOS asset from the media library.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch iosassetsrc uri=assets-library://asset/asset.M4V?id=11&ext=M4V ! decodebin2 ! autoaudiosink
 * ]| Plays asset with id a song.ogg from local dir.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/base.h>
#include "iosassetsrc.h"

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_ios_asset_src_debug);
#define GST_CAT_DEFAULT gst_ios_asset_src_debug


#define DEFAULT_BLOCKSIZE       4*1024
#define OBJC_CALLOUT_BEGIN() \
   NSAutoreleasePool *pool; \
   \
   pool = [[NSAutoreleasePool alloc] init]
#define OBJC_CALLOUT_END() \
  [pool release]

enum
{
  PROP_0,
  PROP_URI,
};

static void gst_ios_asset_src_finalize (GObject * object);

static void gst_ios_asset_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_ios_asset_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_ios_asset_src_start (GstBaseSrc * basesrc);
static gboolean gst_ios_asset_src_stop (GstBaseSrc * basesrc);

static gboolean gst_ios_asset_src_is_seekable (GstBaseSrc * src);
static gboolean gst_ios_asset_src_get_size (GstBaseSrc * src, guint64 * size);
static GstFlowReturn gst_ios_asset_src_create (GstBaseSrc * src, guint64 offset,
    guint length, GstBuffer ** buffer);
static gboolean gst_ios_asset_src_query (GstBaseSrc * src, GstQuery * query);

static void gst_ios_asset_src_uri_handler_init (gpointer g_iface,
    gpointer iface_data);

static void
_do_init (GType ios_assetsrc_type)
{
  static const GInterfaceInfo urihandler_info = {
    gst_ios_asset_src_uri_handler_init,
    NULL,
    NULL
  };

  g_type_add_interface_static (ios_assetsrc_type, GST_TYPE_URI_HANDLER,
      &urihandler_info);
  GST_DEBUG_CATEGORY_INIT (gst_ios_asset_src_debug, "iosassetsrc", 0, "iosassetsrc element");
}

G_DEFINE_TYPE_WITH_CODE (GstIOSAssetSrc, gst_ios_asset_src, GST_TYPE_BASE_SRC,
    _do_init (g_define_type_id));

static void
gst_ios_asset_src_class_init (GstIOSAssetSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSrcClass *gstbasesrc_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbasesrc_class = GST_BASE_SRC_CLASS (klass);

  gobject_class->set_property = gst_ios_asset_src_set_property;
  gobject_class->get_property = gst_ios_asset_src_get_property;

  g_object_class_install_property (gobject_class, PROP_URI,
      g_param_spec_string ("uri", "Asset URI",
          "URI of the asset to read", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS |
          GST_PARAM_MUTABLE_READY));

  gobject_class->finalize = gst_ios_asset_src_finalize;

  gst_element_class_set_static_metadata (gstelement_class,
      "IOSAsset Source",
      "Source/File",
      "Read from arbitrary point in a iOS asset",
      "Andoni Morales Alastruey <amorales@fluendo.com>");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));

  gstbasesrc_class->start = GST_DEBUG_FUNCPTR (gst_ios_asset_src_start);
  gstbasesrc_class->stop = GST_DEBUG_FUNCPTR (gst_ios_asset_src_stop);
  gstbasesrc_class->is_seekable = GST_DEBUG_FUNCPTR (gst_ios_asset_src_is_seekable);
  gstbasesrc_class->get_size = GST_DEBUG_FUNCPTR (gst_ios_asset_src_get_size);
  gstbasesrc_class->create = GST_DEBUG_FUNCPTR (gst_ios_asset_src_create);
  gstbasesrc_class->query = GST_DEBUG_FUNCPTR (gst_ios_asset_src_query);
}

static void
gst_ios_asset_src_init (GstIOSAssetSrc * src)
{
  OBJC_CALLOUT_BEGIN ();
  src->uri = NULL;
  src->asset = NULL;
  src->library = [[[GstAssetsLibrary alloc] init] retain];
  gst_base_src_set_blocksize (GST_BASE_SRC (src), DEFAULT_BLOCKSIZE);
  OBJC_CALLOUT_END ();
}

static void
gst_ios_asset_src_free_resources (GstIOSAssetSrc *src)
{
  OBJC_CALLOUT_BEGIN ();
  if (src->asset != NULL) {
    [src->asset release];
    src->asset = NULL;
  }

  if (src->url != NULL) {
    [src->url release];
    src->url = NULL;
  }

  if (src->uri != NULL) {
    g_free (src->uri);
    src->uri = NULL;
  }
  OBJC_CALLOUT_END ();
}

static void
gst_ios_asset_src_finalize (GObject * object)
{
  GstIOSAssetSrc *src;

  OBJC_CALLOUT_BEGIN ();
  src = GST_IOS_ASSET_SRC (object);
  gst_ios_asset_src_free_resources (src);
  [src->library release];

  OBJC_CALLOUT_END ();
  G_OBJECT_CLASS (gst_ios_asset_src_parent_class)->finalize (object);
}

static gboolean
gst_ios_asset_src_set_uri (GstIOSAssetSrc * src, const gchar * uri, GError **err)
{
  GstState state;
  NSString *nsuristr;
  NSURL *url;

  OBJC_CALLOUT_BEGIN ();
  /* the element must be stopped in order to do this */
  GST_OBJECT_LOCK (src);
  state = GST_STATE (src);
  if (state != GST_STATE_READY && state != GST_STATE_NULL)
    goto wrong_state;
  GST_OBJECT_UNLOCK (src);

  gst_ios_asset_src_free_resources (src);

  nsuristr = [[NSString alloc] initWithUTF8String:uri];
  url = [[NSURL alloc] initWithString:nsuristr];

  if (url == NULL) {
    GST_ERROR_OBJECT (src, "Invalid URI: %s", src->uri);
    g_set_error (err, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "Invalid URI: %s", src->uri);
    return FALSE;
  }

  GST_INFO_OBJECT (src, "URI      : %s", src->uri);
  src->url = url;
  src->uri = g_strdup (uri);
  g_object_notify (G_OBJECT (src), "uri");

  OBJC_CALLOUT_END ();
  return TRUE;

  /* ERROR */
wrong_state:
  {
    g_warning ("Changing the 'uri' property on iosassetsrc when an asset is "
        "open is not supported.");
    g_set_error (err, GST_URI_ERROR, GST_URI_ERROR_BAD_STATE,
        "Changing the 'uri' property on iosassetsrc when an asset is "
        "open is not supported.");
    GST_OBJECT_UNLOCK (src);
    OBJC_CALLOUT_END ();
    return FALSE;
  }
}

static void
gst_ios_asset_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstIOSAssetSrc *src;

  g_return_if_fail (GST_IS_IOS_ASSET_SRC (object));

  src = GST_IOS_ASSET_SRC (object);

  switch (prop_id) {
    case PROP_URI:
      gst_ios_asset_src_set_uri (src, g_value_get_string (value), NULL);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_ios_asset_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstIOSAssetSrc *src;

  g_return_if_fail (GST_IS_IOS_ASSET_SRC (object));

  src = GST_IOS_ASSET_SRC (object);

  switch (prop_id) {
    case PROP_URI:
      g_value_set_string (value, src->uri);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstFlowReturn
gst_ios_asset_src_create (GstBaseSrc * basesrc, guint64 offset, guint length,
    GstBuffer ** buffer)
{
  GstBuffer *buf = NULL;
  GstMapInfo info;
  NSError *err = nil;
  guint bytes_read;
  GstFlowReturn ret;
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (basesrc);

  OBJC_CALLOUT_BEGIN ();
  buf = gst_buffer_new_and_alloc (length);
  if (G_UNLIKELY (buf == NULL && length > 0)) {
    GST_ERROR_OBJECT (src, "Failed to allocate %u bytes", length);
    ret = GST_FLOW_ERROR;
    goto exit;
  }

  gst_buffer_map (buf, &info, GST_MAP_READWRITE);

  /* No need to read anything if length is 0 */
  bytes_read = [src->asset getBytes: info.data
                           fromOffset:offset
                           length:length
                           error:&err];
  if (G_UNLIKELY (err != NULL)) {
    goto could_not_read;
  }

  /* we should eos if we read less than what was requested */
  if (G_UNLIKELY (bytes_read < length)) {
    GST_DEBUG ("EOS");
    ret = GST_FLOW_EOS;
  } else {
    ret = GST_FLOW_OK;
  }

  gst_buffer_unmap (buf, &info);
  gst_buffer_set_size (buf, bytes_read);

  GST_BUFFER_OFFSET (buf) = offset;
  GST_BUFFER_OFFSET_END (buf) = offset + bytes_read;

  *buffer = buf;

  goto exit;

  /* ERROR */
could_not_read:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL), GST_ERROR_SYSTEM);
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    ret = GST_FLOW_ERROR;
    goto exit;
  }
exit:
  {
    OBJC_CALLOUT_END ();
    return ret;
  }

}

static gboolean
gst_ios_asset_src_query (GstBaseSrc * basesrc, GstQuery * query)
{
  gboolean ret = FALSE;
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (basesrc);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_URI:
      gst_query_set_uri (query, src->uri);
      ret = TRUE;
      break;
    default:
      ret = FALSE;
      break;
  }

  if (!ret)
    ret = GST_BASE_SRC_CLASS (gst_ios_asset_src_parent_class)->query (basesrc, query);

  return ret;
}

static gboolean
gst_ios_asset_src_is_seekable (GstBaseSrc * basesrc)
{
  return TRUE;
}

static gboolean
gst_ios_asset_src_get_size (GstBaseSrc * basesrc, guint64 * size)
{
  GstIOSAssetSrc *src;

  src = GST_IOS_ASSET_SRC (basesrc);

  OBJC_CALLOUT_BEGIN ();
  *size = (guint64) [src->asset size];
  OBJC_CALLOUT_END ();
  return TRUE;
}

static gboolean
gst_ios_asset_src_start (GstBaseSrc * basesrc)
{
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (basesrc);
  gboolean ret = TRUE;

  OBJC_CALLOUT_BEGIN ();
  src->asset = [[src->library assetForURLSync: src->url] retain];

  if (src->asset == NULL) {
    GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ,
        ("Could not open asset \"%s\" for reading.", src->uri),
        GST_ERROR_SYSTEM);
    ret = FALSE;
  };

  OBJC_CALLOUT_END ();
  return ret;
}

/* unmap and close the ios_asset */
static gboolean
gst_ios_asset_src_stop (GstBaseSrc * basesrc)
{
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (basesrc);

  OBJC_CALLOUT_BEGIN ();
  [src->asset release];
  OBJC_CALLOUT_END ();
  return TRUE;
}

static GstURIType
gst_ios_asset_src_uri_get_type (GType type)
{
  return GST_URI_SRC;
}

static const gchar * const *
gst_ios_asset_src_uri_get_protocols (GType type)
{
  static const gchar * const protocols[] = { "assets-library", NULL };

  return protocols;
}

static gchar *
gst_ios_asset_src_uri_get_uri (GstURIHandler * handler)
{
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (handler);

  return g_strdup (src->uri);
}

static gboolean
gst_ios_asset_src_uri_set_uri (GstURIHandler * handler, const gchar * uri, GError **err)
{
  GstIOSAssetSrc *src = GST_IOS_ASSET_SRC (handler);

  if (! g_str_has_prefix (uri, "assets-library://")) {
    GST_WARNING_OBJECT (src, "Invalid URI '%s' for ios_assetsrc", uri);
    g_set_error (err, GST_URI_ERROR, GST_URI_ERROR_BAD_URI,
        "Invalid URI '%s' for ios_assetsrc", uri);
    return FALSE;
  }

  return gst_ios_asset_src_set_uri (src, uri, err);
}

static void
gst_ios_asset_src_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_ios_asset_src_uri_get_type;
  iface->get_protocols = gst_ios_asset_src_uri_get_protocols;
  iface->get_uri = gst_ios_asset_src_uri_get_uri;
  iface->set_uri = gst_ios_asset_src_uri_set_uri;
}


@implementation GstAssetsLibrary

@synthesize asset;
@synthesize result;

- (id) init
{
  self = [super init];

  return self;
}

- (ALAssetRepresentation *) assetForURLSync:(NSURL*) uri
{
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);

  dispatch_async(queue, ^{
    [self assetForURL:uri resultBlock:
        ^(ALAsset *myasset)
        {
          self.asset = myasset;
          self.result = [myasset defaultRepresentation];

          dispatch_semaphore_signal(sema);
        }
      failureBlock:
        ^(NSError *myerror)
        {
          self.result = nil;
          dispatch_semaphore_signal(sema);
        }
    ];
  });

  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
  dispatch_release(sema);

  return self.result;
}
@end
