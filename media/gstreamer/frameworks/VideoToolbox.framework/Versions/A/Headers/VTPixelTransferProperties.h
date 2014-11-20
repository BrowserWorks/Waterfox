/*
	File:  VTPixelTransferProperties.h
	
	Framework:  VideoToolbox
 
    Copyright 2006-2013 Apple Inc. All rights reserved.
  
	Standard Video Toolbox pixel transfer properties.
*/

#ifndef VTPIXELTRANSFERPROPERTIES_H
#define VTPIXELTRANSFERPROPERTIES_H

#include <CoreMedia/CMBase.h>
#include <VideoToolbox/VTBase.h>

#include <CoreFoundation/CoreFoundation.h>

#ifndef VT_SUPPORT_COLORSYNC_PIXEL_TRANSFER
#define VT_SUPPORT_COLORSYNC_PIXEL_TRANSFER TARGET_OS_MAC && ! TARGET_OS_IPHONE && ( MAC_OS_X_VERSION_MIN_REQUIRED >= 1080 )
#endif // VT_SUPPORT_COLORSYNC_PIXEL_TRANSFER

#if defined(__cplusplus)
extern "C"
{
#endif

#pragma pack(push, 4)
    
/*!
	@header
	@abstract
		Standard Video Toolbox pixel transfer properties
		
	@discussion
		This file defines standard properties used to describe and configure pixel transfer 
		operations managed by the video toolbox.  
		
		Clients can query supported properties by calling VTSessionCopySupportedPropertyDictionary.
*/

// Properties for various scaling and cropping configurations

/*!
	@constant	kVTPixelTransferPropertyKey_ScalingMode
	@abstract
		Indicates how images should be scaled.
	@discussion
		Depending on the scaling mode, scaling may take into account:
		the full image buffer width and height of the source and destination, 
		the clean aperture attachment (kCVImageBufferCleanApertureKey) on the source image buffer, 
		the pixel aspect ratio attachment (kCVImageBufferPixelAspectRatioKey) on the source image buffer,
		the destination clean aperture (kVTPixelTransferPropertyKey_DestinationCleanAperture), and/or
		the destination pixel aspect ratio (kVTPixelTransferPropertyKey_DestinationPixelAspectRatio).
		The destination image buffer's clean aperture and pixel aspect ratio attachments are not
		taken into account, and will be overwritten.
	
	@constant	kVTScalingMode_Normal
	@abstract
		The full width and height of the source image buffer is stretched to the full width 
		and height of the destination image buffer.
	@discussion
		The source image buffer's clean aperture and pixel aspect ratio attachments are stretched 
		the same way as the image with the image, and attached to the destination image buffer.
		This is the default scaling mode.
	
	@constant	kVTScalingMode_CropSourceToCleanAperture
	@abstract
		The source image buffer's clean aperture is scaled to the destination clean aperture.
	@discussion
		The destination pixel aspect ratio is set on the destination image buffer.
	
	@constant	kVTScalingMode_Letterbox
	@abstract
		The source image buffer's clean aperture is scaled to a rectangle fitted inside the 
		destination clean aperture that preserves the source picture aspect ratio.
	@discussion
		The remainder of the destination image buffer is filled with black.
		If a destination pixel aspect ratio is not set, the source image's pixel aspect ratio is used.
		The pixel aspect ratio used is set on the destination image buffer.
	
	@constant	kVTScalingMode_Trim
	@abstract
		The source image buffer's clean aperture is scaled to a rectangle that completely fills the 
		destination clean aperture and preserves the source picture aspect ratio.
	@discussion
		If a destination pixel aspect ratio is not set, the source image's pixel aspect ratio is used.
		The pixel aspect ratio used is set on the destination image buffer.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_ScalingMode VT_AVAILABLE_STARTING(10_8); // Read/write, CFStringRef, one of:
VT_EXPORT const CFStringRef kVTScalingMode_Normal VT_AVAILABLE_STARTING(10_8); // Copy full width and height.  Write adjusted clean aperture and pixel aspect ratios to compensate for any change in dimensions.
VT_EXPORT const CFStringRef kVTScalingMode_CropSourceToCleanAperture VT_AVAILABLE_STARTING(10_8); // Crop to remove edge processing region; scale remainder to destination clean aperture.
VT_EXPORT const CFStringRef kVTScalingMode_Letterbox VT_AVAILABLE_STARTING(10_8); // Preserve aspect ratio of the source, and fill remaining areas with black in to fit destination dimensions
VT_EXPORT const CFStringRef kVTScalingMode_Trim VT_AVAILABLE_STARTING(10_8); // Preserve aspect ratio of the source, and crop picture to fit destination dimensions

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationCleanAperture
	@abstract
		Specifies the clean aperture for destination image buffers.  
	@discussion
		The value of this property is a CFDictionary with same keys as used in the 
		kCVImageBufferCleanApertureKey dictionary.  
		This property is ignored in kVTScalingMode_Normal.  
		This property defaults to NULL, meaning the clean aperture is the full width and height.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationCleanAperture VT_AVAILABLE_STARTING(10_8); // Read/write, CFDictionary with same keys as used in kCVImageBufferCleanApertureKey dictionary.  Used as applicable to current kVTPixelTransferPropertyKey_ScalingMode value.

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationPixelAspectRatio
	@abstract
		Specifies the pixel aspect ratio for destination image buffers.  
	@discussion
		The value of this property is a CFDictionary with same keys as used in the
		kCVImageBufferPixelAspectRatioKey dictionary.
		This property is ignored in kVTScalingMode_Normal.  
		This property defaults to NULL, meaning 1:1 (for kVTScalingMode_CropSourceToCleanAperture) 
		or no change in pixel aspect ratio (for kVTScalingMode_Letterbox and kVTScalingMode_Trim).
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationPixelAspectRatio VT_AVAILABLE_STARTING(10_8); // Read/write, CFDictionary with same keys as used in kCVImageBufferPixelAspectRatioKey dictionary.  Used as applicable to current kVTPixelTransferPropertyKey_ScalingMode value.

// Properties for configuring up/down sampling

/*!
	@constant	kVTPixelTransferPropertyKey_DownsamplingMode
	@abstract
		Requests a specific chroma downsampling technique be used.
	@discussion
		This property is ignored if chroma downsampling is not performed.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DownsamplingMode VT_AVAILABLE_STARTING(10_8); // Read/write, CFStringRef, one of:
VT_EXPORT const CFStringRef kVTDownsamplingMode_Decimate VT_AVAILABLE_STARTING(10_8); // Default, decimate extra samples
VT_EXPORT const CFStringRef kVTDownsamplingMode_Average VT_AVAILABLE_STARTING(10_8); // Average missing samples (default center)

// Properties for color information

#if VT_SUPPORT_COLORSYNC_PIXEL_TRANSFER

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationColorPrimaries
	@abstract
		Specifies the color primaries to be used for destination image buffers.  
	@discussion
		Specifying this value may lead to performance degradation, as a color
		matching operation may need to be performed between the source and
		the destination.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationColorPrimaries VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_ColorPrimaries), Optional

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationTransferFunction
	@abstract
		Specifies the color transfer function to be used for destination image buffers.  
	@discussion
		Specifying this value may lead to performance degradation, as a color
		matching operation may need to be performed between the source and
		the destination.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationTransferFunction VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_TransferFunction), Optional

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationYCbCrMatrix
	@abstract
		Specifies the color matrix to be used for YCbCr->RGB conversions
		involving the destination image buffers.  
	@discussion
		Specifying this value may lead to performance degradation, as a color
		matching operation may need to be performed between the source and
		the destination.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationYCbCrMatrix VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_YCbCrMatrix), Optional

/*!
	@constant	kVTPixelTransferPropertyKey_DestinationICCProfile
	@abstract
		Specifies the ICC profile for destination image buffers.  
	@discussion
		Specifying this value may lead to performance degradation, as a color
		matching operation may need to be performed between the source and
		the destination.
*/
VT_EXPORT const CFStringRef kVTPixelTransferPropertyKey_DestinationICCProfile VT_AVAILABLE_STARTING(10_8); // Read/write, CFData (see kCMFormatDescriptionExtension_ICCProfile), Optional

#endif // VT_SUPPORT_COLORSYNC_PIXEL_TRANSFER


#pragma pack(pop)

#if defined(__cplusplus)
}
#endif

#endif // VTPIXELTRANSFERPROPERTIES_H
