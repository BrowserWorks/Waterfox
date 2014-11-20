/*
    File:  CMAttachment.h

	Framework:  CoreMedia
 
    Copyright 2006-2013 Apple Inc. All rights reserved.

*/

#ifndef CMATTACHMENT_H
#define CMATTACHMENT_H

#include <Availability.h>
#include <CoreMedia/CMBase.h>
#include <CoreFoundation/CoreFoundation.h>

#if defined(__cplusplus)
extern "C" {
#endif
    
#pragma pack(push, 4)

/* A CMAttachmentBearer is a CF-based object that supports the suite of key/value/mode attachment APIs defined in this header file.  Since plain C has no type subclassing, we use CFType as the basis for the CMAttachmentBearer type.  (Not all CFTypes support CMAttachmentBearer methods; if a CMAttachmentBearer method is called on a CF object that does not support it, it will fail.) */
typedef CFTypeRef CMAttachmentBearerRef;

// The attachment modes are the same as those defined in CVBuffer.h.
enum {
	kCMAttachmentMode_ShouldNotPropagate    = 0,
	kCMAttachmentMode_ShouldPropagate       = 1
};
typedef uint32_t CMAttachmentMode;

/*!
    @function   CMSetAttachment
    @abstract   Sets or adds a attachment of a CMAttachmentBearer
    @discussion You can attach any CF object to a CMAttachmentBearer object to store additional information. CMSetAttachment stores an attachment identified by a key. If the key doesn't exist, the attachment will be added. If the key does exist, the existing attachment will be replaced. In both cases the retain count of the attachment will be incremented. The value can be any CFType but nil has no defined behavior.  Given a CVBufferRef, CMSetAttachment is equivalent to CVBufferSetAttachment.
    @param      target  Target CMAttachmentBearer.
    @param      key     Key in form of a CFString identifying the desired attachment.
    @param      value	Attachment in form af a CF object.
    @param      attachmentMode	Specifies which attachment mode is desired for this attachment.   A particular attachment key may only exist in
                                a single mode at a time.
*/
CM_EXPORT void	CMSetAttachment(CMAttachmentBearerRef target, CFStringRef key, CFTypeRef value, CMAttachmentMode attachmentMode) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );


/*!
    @function   CMGetAttachment
    @abstract   Returns a specific attachment of a CMAttachmentBearer
    @discussion You can attach any CF object to a CMAttachmentBearer to store additional information. CMGetAttachment retrieves an attachment identified by a key.  Given a CVBufferRef, CMGetAttachment is equivalent to CVBufferGetAttachment.
    @param      target  Target CMAttachmentBearer.
    @param      key	Key in form of a CFString identifying the desired attachment.
    @param      attachmentModeOut.  Returns the mode of the attachment, if desired.  May be NULL.
    @result     If found the attachment object; else NULL.
*/
CM_EXPORT CFTypeRef CMGetAttachment(CMAttachmentBearerRef target,  CFStringRef key, CMAttachmentMode *attachmentModeOut) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

/*!
    @function   CMRemoveAttachment
    @abstract   Removes a specific attachment of a CMAttachmentBearer
    @discussion CMRemoveAttachment removes an attachment identified by a key. If found the attachment is removed and the retain count decremented.  Given a CVBufferRef, CMRemoveAttachment is equivalent to CVBufferRemoveAttachment.
    @param      target  Target CMAttachmentBearer.
    @param      key	Key in form of a CFString identifying the desired attachment.
*/
CM_EXPORT void	CMRemoveAttachment(CMAttachmentBearerRef target, CFStringRef key) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

/*!
    @function   CMRemoveAllAttachments
    @abstract   Removes all attachments of a CMAttachmentBearer
    @discussion While CMRemoveAttachment removes a specific attachment identified by a key CMRemoveAllAttachments removes all attachments of a buffer and decrements their retain counts.  Given a CVBufferRef, CMRemoveAllAttachments is equivalent to CVBufferRemoveAllAttachments.
    @param      target  Target CMAttachmentBearer.
*/
CM_EXPORT void	CMRemoveAllAttachments(CMAttachmentBearerRef target) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

/*!
    @function   CMCopyDictionaryOfAttachments
    @abstract   Returns all attachments of a CMAttachmentBearer
    @discussion CMCopyDictionaryOfAttachments is a convenience call that returns all attachments with their corresponding keys in a new CFDictionary that the caller must dispose by calling CFRelease.  Given a CVBufferRef, CMCopyDictionaryOfAttachments is similar to CVBufferGetAttachments, except that CVBufferGetAttachments returns a CFDictionary that may change if attachments are added later.
    @param      allocator  Allocator for the new dictionary; pass kCFAllocatorDefault or NULL to use the default allocator.
    @param      target  Target CMAttachmentBearer.
    @result     A CFDictionary with all buffer attachments identified by there keys. If no attachment is present, NULL is returned.  Returns NULL
		for invalid attachment mode.
*/
CM_EXPORT CFDictionaryRef CMCopyDictionaryOfAttachments(CFAllocatorRef allocator, CMAttachmentBearerRef target, CMAttachmentMode attachmentMode) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

/*!
    @function   CMSetAttachments
    @abstract   Sets a set of attachments for a CMAttachmentBearer
    @discussion CMSetAttachments is a convenience call that in turn calls CMSetAttachment for each key and value in the given dictionary. All key value pairs must be in the root level of the dictionary.  Given a CVBufferRef, CMSetAttachments is equivalent to CVBufferSetAttachments.
    @param      target  Target CMAttachmentBearer.
*/
CM_EXPORT void CMSetAttachments(CMAttachmentBearerRef target, CFDictionaryRef theAttachments, CMAttachmentMode attachmentMode) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

/*!
    @function   CMPropagateAttachments
    @abstract   Copy all propagatable attachments from one buffer to another.
    @discussion CMPropagateAttachments is a convenience call that copies all attachments with a mode of kCMAttachmentMode_ShouldPropagate from one
                buffer to another.  Given a CVBufferRef, CMPropagateAttachments is equivalent to CVBufferPropagateAttachments.
    @param      source  CMAttachmentBearer to copy attachments from.
    @param      destination  CMAttachmentBearer to copy attachments to.
*/
CM_EXPORT void  CMPropagateAttachments(CMAttachmentBearerRef source, CMAttachmentBearerRef destination) __OSX_AVAILABLE_STARTING( __MAC_10_7, __IPHONE_4_0 );

#pragma pack(pop)
    
#if defined(__cplusplus)
}
#endif

#endif // CMATTACHMENT_H
