/*
	File:  VTBase.h

	Framework:  VideoToolbox

	Copyright 2013 Apple Inc. All rights reserved.

*/

#ifndef VTBASE_H
#define VTBASE_H

#include <Availability.h>

#if defined(__cplusplus)
extern "C"
{
#endif

#pragma pack(push, 4)


#if TARGET_OS_IPHONE
#define VT_AVAILABLE_STARTING(_ver) 
#else
#define VT_AVAILABLE_STARTING(_ver) __OSX_AVAILABLE_STARTING(__MAC_##_ver, __IPHONE_NA)
#endif


#pragma pack(pop)

#if defined(__cplusplus)
}
#endif

#endif // VTBASE_H
