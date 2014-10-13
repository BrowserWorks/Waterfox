/* GStreamer
 * Copyright (C) 2013 Fluendo S.L. <support@fluendo.com>
 *   Authors:    2013 Andoni Morales Alastruey <amorales@fluendo.com>
 * Copyright (C) 2013 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstios_assetsrc.h:
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

#ifndef __GST_IOS_ASSET_SRC_H__
#define __GST_IOS_ASSET_SRC_H__

#include <sys/types.h>

#include <gst/gst.h>
#include <gst/base/base.h>
#include <AssetsLibrary/ALAssetsLibrary.h>
#include <AssetsLibrary/ALAssetRepresentation.h>

G_BEGIN_DECLS

#define GST_TYPE_IOS_ASSET_SRC \
  (gst_ios_asset_src_get_type())
#define GST_IOS_ASSET_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_IOS_ASSET_SRC,GstIOSAssetSrc))
#define GST_IOS_ASSET_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_IOS_ASSET_SRC,GstIOSAssetSrcClass))
#define GST_IS_IOS_ASSET_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_IOS_ASSET_SRC))
#define GST_IS_IOS_ASSET_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_IOS_ASSET_SRC))
#define GST_IOS_ASSET_SRC_CAST(obj) ((GstIOSAssetSrc*) obj)

typedef struct _GstIOSAssetSrc GstIOSAssetSrc;
typedef struct _GstIOSAssetSrcClass GstIOSAssetSrcClass;

@interface GstAssetsLibrary : ALAssetsLibrary
{
}

@property (retain) ALAsset *asset;
@property (retain) ALAssetRepresentation *result;

- (ALAssetRepresentation *) assetForURLSync:(NSURL*) uri;
@end

/**
 * GstIOSAssetSrc:
 *
 * Opaque #GstIOSAssetSrc structure.
 */
struct _GstIOSAssetSrc {
  GstBaseSrc element;

  /*< private >*/
  gchar * uri;                    /* asset uri */
  NSURL * url;                    /* asset url */
  ALAssetRepresentation * asset;  /* asset representation */
  GstAssetsLibrary * library;     /* assets library */
};

struct _GstIOSAssetSrcClass {
  GstBaseSrcClass parent_class;
};

GType gst_ios_asset_src_get_type (void);

G_END_DECLS

#endif /* __GST_IOS_ASSET_SRC_H__ */
