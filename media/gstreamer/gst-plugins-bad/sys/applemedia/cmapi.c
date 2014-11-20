/*
 * Copyright (C) 2014 Alessandro Decina <alessandro.d@gmail.com>
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

#include "cmapi.h"
#include <dlfcn.h>

#define GST_MACRO_STR(symbol) #symbol
#define GST_CM_DYNAMIC_RESOLVE(symbol, old_symbol) { \
  GST_CM_DYNAMIC_NAME(symbol) = dlsym(coreMedia, #symbol); \
  if (GST_CM_DYNAMIC_NAME(symbol) == NULL) { \
    GST_CM_DYNAMIC_NAME(symbol) = dlsym(coreMedia, #symbol); \
  } \
  assert(GST_CM_DYNAMIC_NAME(symbol)); \
}

void *coreMedia;
GST_CM_DYNAMIC_DECLARE(CMTimeMake);
GST_CM_DYNAMIC_DECLARE(CMBlockBufferCreateWithMemoryBlock);
GST_CM_DYNAMIC_DECLARE(CMSampleBufferCreate);
GST_CM_DYNAMIC_DECLARE(CMVideoFormatDescriptionCreate);

void
gst_cmapi_load(void)
{
  coreMedia = dlopen("/System/Library/Frameworks/CoreMedia.framework/CoreMedia", RTLD_GLOBAL);
  if (!coreMedia)
    coreMedia = dlopen("/System/Library/PrivateFrameworks/CoreMedia.framework/CoreMedia", RTLD_GLOBAL);
  GST_CM_DYNAMIC_RESOLVE(CMTimeMake, FigTimeMake); 
  GST_CM_DYNAMIC_RESOLVE(CMBlockBufferCreateWithMemoryBlock, FigBlockBufferCreateWithMemoryBlock);
  GST_CM_DYNAMIC_RESOLVE(CMSampleBufferCreate, FigSampleBufferCreate);
  GST_CM_DYNAMIC_RESOLVE(CMVideoFormatDescriptionCreate, FigVideoFormatDescriptionCreate);
}
