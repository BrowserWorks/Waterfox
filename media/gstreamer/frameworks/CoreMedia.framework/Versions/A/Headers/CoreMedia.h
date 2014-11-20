/* 
	File:  CoreMedia.h
	
	Framework:  CoreMedia

    Copyright 2010-2012 Apple Inc. All rights reserved.
    
	To report bugs, go to:  http://developer.apple.com/bugreporter/

 */

#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreMedia/CMTimeRange.h>
#include <CoreMedia/CMFormatDescription.h>
#include <CoreMedia/CMAttachment.h>
#include <CoreMedia/CMBufferQueue.h>
#include <CoreMedia/CMBlockBuffer.h>
#include <CoreMedia/CMSampleBuffer.h>
#include <CoreMedia/CMSimpleQueue.h>
#include <CoreMedia/CMMemoryPool.h>
#include <CoreMedia/CMSync.h>
#include <CoreMedia/CMTextMarkup.h>
#if TARGET_OS_IPHONE
#include <CoreMedia/CMAudioClock.h>
#else
#include <CoreMedia/CMAudioDeviceClock.h>
#endif
