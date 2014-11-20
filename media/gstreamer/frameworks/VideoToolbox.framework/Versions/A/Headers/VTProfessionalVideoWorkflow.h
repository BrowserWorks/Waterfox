/*
	File:  VTProfessionalVideoWorkflow.h
 
	Framework:  VideoToolbox
 
	Copyright 2013 Apple Inc. All rights reserved.
 
*/

#ifndef VTPROFESSIONALVIDEOWORKFLOW_H
#define VTPROFESSIONALVIDEOWORKFLOW_H

#include <VideoToolbox/VTBase.h>

#if defined(__cplusplus)
extern "C"
{
#endif
    
#pragma pack(push, 4)

/*!
	@function	VTRegisterProfessionalVideoWorkflowVideoDecoders
	@abstract	Allows the client to use decoders appropriate for professional video workflows.
	@discussion
		Loads the video decoders within "/Library/Video/Professional Video Workflow Plug-Ins/", if any are present.
*/
VT_EXPORT void VTRegisterProfessionalVideoWorkflowVideoDecoders( void ) VT_AVAILABLE_STARTING(10_9);

#pragma pack(pop)

#if defined(__cplusplus)
}
#endif

#endif // VTPROFESSIONALVIDEOWORKFLOW_H
