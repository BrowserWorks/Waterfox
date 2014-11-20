/*
	File:  VTPixelTransferSession.h
	
	Framework:  VideoToolbox
 
    Copyright 2006-2013 Apple Inc. All rights reserved.
  
	Video Toolbox client API for transferring images between CVPixelBuffers.
*/

#ifndef VTPIXELTRANSFERSESSION_H
#define VTPIXELTRANSFERSESSION_H

#include <CoreMedia/CMBase.h>
#include <VideoToolbox/VTBase.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreVideo/CoreVideo.h>

#include <VideoToolbox/VTSession.h>
#include <VideoToolbox/VTPixelTransferProperties.h>

#if defined(__cplusplus)
extern "C"
{
#endif
    
#pragma pack(push, 4)

/*!
	@typedef	VTPixelTransferSessionRef
	@abstract	A reference to a Video Toolbox Pixel Transfer Session.
	@discussion
		A pixel transfer session supports the copying and/or conversion of 
		images from source CVPixelBuffers to destination CVPixelBuffers.
		The session reference is a reference-counted CF object.
		To create a pixel transfer session, call VTPixelTransferSessionCreate; 
		then you can optionally configure the session using VTSessionSetProperty;
		then to transfer pixels, call VTPixelTransferSessionTransferImage.
		When you are done with the session, you should call VTPixelTransferSessionInvalidate
		to tear it down and CFRelease to release your object reference.
 */

typedef struct OpaqueVTPixelTransferSession*  VTPixelTransferSessionRef;

/*!
	@function	VTPixelTransferSessionCreate
	@abstract	Creates a session for transferring images between CVPixelBuffers.
    @discussion 
		Decompressed frames will be emitted through calls to outputCallback.
	@param	allocator
		An allocator for the session.  Pass NULL to use the default allocator.
	@param	pixelTransferSessionOut
		Points to a variable to receive the new pixel transfer session.
	
*/
VT_EXPORT OSStatus 
VTPixelTransferSessionCreate(
  CFAllocatorRef                              allocator,                                /* can be NULL */
  VTPixelTransferSessionRef *                 pixelTransferSessionOut) VT_AVAILABLE_STARTING(10_8);

/*!
	@function	VTPixelTransferSessionInvalidate
	@abstract	Tears down a pixel transfer session.
    @discussion 
    	When you are done with a pixel transfer session you created, call VTPixelTransferSessionInvalidate 
    	to tear it down and then CFRelease to release your object reference.
    	When a pixel transfer session's retain count reaches zero, it is automatically invalidated, but 
    	since sessions may be retained by multiple parties, it can be hard to predict when this will happen.
    	Calling VTPixelTransferSessionInvalidate ensures a deterministic, orderly teardown.
*/
VT_EXPORT void 
VTPixelTransferSessionInvalidate( VTPixelTransferSessionRef session ) VT_AVAILABLE_STARTING(10_8);

/*!
	@function VTPixelTransferSessionGetTypeID
	@abstract Returns the CFTypeID for pixel transfer sessions.  
*/
VT_EXPORT CFTypeID 
VTPixelTransferSessionGetTypeID(void) VT_AVAILABLE_STARTING(10_8);

/*!
	@function	VTPixelTransferSessionTransferImage
	@abstract	Copies and/or converts an image from one pixel buffer to another.
	@discussion
		By default, the full width and height of sourceBuffer are scaled to the full 
		width and height of destinationBuffer.  
		By default, all existing attachments on destinationBuffer are removed and new attachments
		are set describing the transferred image.  Unrecognised attachments on sourceBuffer will 
		be propagated to destinationBuffer.
		Some properties will modify this behaviour; see VTPixelTransferProperties.h for more details.
	@param	session
		The pixel transfer session.
	@param	sourceBuffer
		The source buffer.
	@param	destinationBuffer
		The destination buffer.  
	@result
		If the transfer was successful, noErr; otherwise an error code, such as kVTPixelTransferNotSupportedErr.
*/
VT_EXPORT OSStatus
VTPixelTransferSessionTransferImage(
  VTPixelTransferSessionRef       session,
  CVPixelBufferRef                sourceBuffer,
  CVPixelBufferRef                destinationBuffer) VT_AVAILABLE_STARTING(10_8);

// See VTSession.h for property access APIs on VTPixelTransferSessions.
// See VTPixelTransferProperties.h for standard property keys and values for pixel transfer sessions.
    
#pragma pack(pop)

#if defined(__cplusplus)
}
#endif

#endif // VTPIXELTRANSFERSESSION_H
