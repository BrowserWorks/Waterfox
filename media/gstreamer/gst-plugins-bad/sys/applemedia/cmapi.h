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

#ifndef _GST_CMAPI_H_
#define _GST_CMAPI_H_

#include <CoreMedia/CoreMedia.h>

#define GST_CM_DYNAMIC_NAME(symbol) Gst##symbol
#define GST_CM_DYNAMIC_DECLARE(symbol) typeof(symbol) (*GST_CM_DYNAMIC_NAME(symbol))

extern GST_CM_DYNAMIC_DECLARE(CMTimeMake);
extern GST_CM_DYNAMIC_DECLARE(CMBlockBufferCreateWithMemoryBlock);
extern GST_CM_DYNAMIC_DECLARE(CMSampleBufferCreate);
extern GST_CM_DYNAMIC_DECLARE(CMVideoFormatDescriptionCreate);

void gst_cmapi_load(void);

#endif
