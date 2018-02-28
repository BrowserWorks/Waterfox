/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/voice_engine/output_mixer.h"

#include "webrtc/audio/utility/audio_frame_operations.h"
#include "webrtc/base/format_macros.h"
#include "webrtc/modules/audio_processing/include/audio_processing.h"
#include "webrtc/system_wrappers/include/file_wrapper.h"
#include "webrtc/system_wrappers/include/trace.h"
#include "webrtc/voice_engine/include/voe_external_media.h"
#include "webrtc/voice_engine/statistics.h"
#include "webrtc/voice_engine/utility.h"

namespace webrtc {
namespace voe {

void
OutputMixer::NewMixedAudio(int32_t id,
                           const AudioFrame& generalAudioFrame,
                           const AudioFrame** uniqueAudioFrames,
                           uint32_t size)
{
    WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::NewMixedAudio(id=%d, size=%u)", id, size);

    _audioFrame.CopyFrom(generalAudioFrame);
    _audioFrame.id_ = id;
}

void OutputMixer::PlayNotification(int32_t id, uint32_t durationMs)
{
    WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::PlayNotification(id=%d, durationMs=%d)",
                 id, durationMs);
    // Not implement yet
}

void OutputMixer::RecordNotification(int32_t id,
                                     uint32_t durationMs)
{
    WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::RecordNotification(id=%d, durationMs=%d)",
                 id, durationMs);

    // Not implement yet
}

void OutputMixer::PlayFileEnded(int32_t id)
{
    WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::PlayFileEnded(id=%d)", id);

    // not needed
}

void OutputMixer::RecordFileEnded(int32_t id)
{
    WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::RecordFileEnded(id=%d)", id);
    assert(id == _instanceId);

    rtc::CritScope cs(&_fileCritSect);
    _outputFileRecording = false;
    WEBRTC_TRACE(kTraceStateInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::RecordFileEnded() =>"
                 "output file recorder module is shutdown");
}

int32_t
OutputMixer::Create(OutputMixer*& mixer, uint32_t instanceId)
{
    WEBRTC_TRACE(kTraceMemory, kTraceVoice, instanceId,
                 "OutputMixer::Create(instanceId=%d)", instanceId);
    mixer = new OutputMixer(instanceId);
    if (mixer == NULL)
    {
        WEBRTC_TRACE(kTraceMemory, kTraceVoice, instanceId,
                     "OutputMixer::Create() unable to allocate memory for"
                     "mixer");
        return -1;
    }
    return 0;
}

OutputMixer::OutputMixer(uint32_t instanceId) :
    _mixerModule(*AudioConferenceMixer::Create(instanceId)),
    _audioLevel(),
    _instanceId(instanceId),
    _externalMediaCallbackPtr(NULL),
    _externalMedia(false),
    _panLeft(1.0f),
    _panRight(1.0f),
    _mixingFrequencyHz(8000),
    _outputFileRecording(false)
{
    WEBRTC_TRACE(kTraceMemory, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::OutputMixer() - ctor");

    if (_mixerModule.RegisterMixedStreamCallback(this) == -1)
    {
        WEBRTC_TRACE(kTraceError, kTraceVoice, VoEId(_instanceId,-1),
                     "OutputMixer::OutputMixer() failed to register mixer"
                     "callbacks");
    }
}

void
OutputMixer::Destroy(OutputMixer*& mixer)
{
    if (mixer)
    {
        delete mixer;
        mixer = NULL;
    }
}

OutputMixer::~OutputMixer()
{
    WEBRTC_TRACE(kTraceMemory, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::~OutputMixer() - dtor");
    if (_externalMedia)
    {
        DeRegisterExternalMediaProcessing();
    }
    {
        rtc::CritScope cs(&_fileCritSect);
        if (output_file_recorder_) {
          output_file_recorder_->RegisterModuleFileCallback(NULL);
          output_file_recorder_->StopRecording();
        }
    }
    _mixerModule.UnRegisterMixedStreamCallback();
    delete &_mixerModule;
}

int32_t
OutputMixer::SetEngineInformation(voe::Statistics& engineStatistics)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::SetEngineInformation()");
    _engineStatisticsPtr = &engineStatistics;
    return 0;
}

int32_t
OutputMixer::SetAudioProcessingModule(AudioProcessing* audioProcessingModule)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::SetAudioProcessingModule("
                 "audioProcessingModule=0x%x)", audioProcessingModule);
    _audioProcessingModulePtr = audioProcessingModule;
    return 0;
}

int OutputMixer::RegisterExternalMediaProcessing(
    VoEMediaProcess& proccess_object)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
               "OutputMixer::RegisterExternalMediaProcessing()");

    rtc::CritScope cs(&_callbackCritSect);
    _externalMediaCallbackPtr = &proccess_object;
    _externalMedia = true;

    return 0;
}

int OutputMixer::DeRegisterExternalMediaProcessing()
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::DeRegisterExternalMediaProcessing()");

    rtc::CritScope cs(&_callbackCritSect);
    _externalMedia = false;
    _externalMediaCallbackPtr = NULL;

    return 0;
}

int32_t
OutputMixer::SetMixabilityStatus(MixerParticipant& participant,
                                 bool mixable)
{
    return _mixerModule.SetMixabilityStatus(&participant, mixable);
}

int32_t
OutputMixer::SetAnonymousMixabilityStatus(MixerParticipant& participant,
                                          bool mixable)
{
    return _mixerModule.SetAnonymousMixabilityStatus(&participant, mixable);
}

int32_t
OutputMixer::MixActiveChannels()
{
    _mixerModule.Process();
    return 0;
}

int
OutputMixer::GetSpeechOutputLevel(uint32_t& level)
{
    int8_t currentLevel = _audioLevel.Level();
    level = static_cast<uint32_t> (currentLevel);
    WEBRTC_TRACE(kTraceStateInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "GetSpeechOutputLevel() => level=%u", level);
    return 0;
}

int
OutputMixer::GetSpeechOutputLevelFullRange(uint32_t& level)
{
    int16_t currentLevel = _audioLevel.LevelFullRange();
    level = static_cast<uint32_t> (currentLevel);
    WEBRTC_TRACE(kTraceStateInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "GetSpeechOutputLevelFullRange() => level=%u", level);
    return 0;
}

int
OutputMixer::SetOutputVolumePan(float left, float right)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::SetOutputVolumePan()");
    _panLeft = left;
    _panRight = right;
    return 0;
}

int
OutputMixer::GetOutputVolumePan(float& left, float& right)
{
    left = _panLeft;
    right = _panRight;
    WEBRTC_TRACE(kTraceStateInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "GetOutputVolumePan() => left=%2.1f, right=%2.1f",
                 left, right);
    return 0;
}

int OutputMixer::GetOutputChannelCount()
{
  return _audioFrame.num_channels_;
}

int OutputMixer::StartRecordingPlayout(const char* fileName,
                                       const CodecInst* codecInst)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::StartRecordingPlayout(fileName=%s)", fileName);

    if (_outputFileRecording)
    {
        WEBRTC_TRACE(kTraceWarning, kTraceVoice, VoEId(_instanceId,-1),
                     "StartRecordingPlayout() is already recording");
        return 0;
    }

    FileFormats format;
    const uint32_t notificationTime(0);
    CodecInst dummyCodec={100,"L16",16000,320,1,320000};

    if ((codecInst != NULL) &&
      ((codecInst->channels < 1) || (codecInst->channels > 2)))
    {
        _engineStatisticsPtr->SetLastError(
            VE_BAD_ARGUMENT, kTraceError,
            "StartRecordingPlayout() invalid compression");
        return(-1);
    }
    if(codecInst == NULL)
    {
        format = kFileFormatPcm16kHzFile;
        codecInst=&dummyCodec;
    }
    else if((STR_CASE_CMP(codecInst->plname,"L16") == 0) ||
        (STR_CASE_CMP(codecInst->plname,"PCMU") == 0) ||
        (STR_CASE_CMP(codecInst->plname,"PCMA") == 0))
    {
        format = kFileFormatWavFile;
    }
    else
    {
        format = kFileFormatCompressedFile;
    }

    rtc::CritScope cs(&_fileCritSect);

    // Destroy the old instance
    if (output_file_recorder_) {
      output_file_recorder_->RegisterModuleFileCallback(NULL);
      output_file_recorder_.reset();
    }

    output_file_recorder_ = FileRecorder::CreateFileRecorder(
        _instanceId, (const FileFormats)format);
    if (!output_file_recorder_) {
      _engineStatisticsPtr->SetLastError(
          VE_INVALID_ARGUMENT, kTraceError,
          "StartRecordingPlayout() fileRecorder format isnot correct");
      return -1;
    }

    if (output_file_recorder_->StartRecordingAudioFile(
            fileName, (const CodecInst&)*codecInst, notificationTime) != 0) {
      _engineStatisticsPtr->SetLastError(
          VE_BAD_FILE, kTraceError,
          "StartRecordingAudioFile() failed to start file recording");
      output_file_recorder_->StopRecording();
      output_file_recorder_.reset();
      return -1;
    }
    output_file_recorder_->RegisterModuleFileCallback(this);
    _outputFileRecording = true;

    return 0;
}

int OutputMixer::StartRecordingPlayout(OutStream* stream,
                                       const CodecInst* codecInst)
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::StartRecordingPlayout()");

    if (_outputFileRecording)
    {
        WEBRTC_TRACE(kTraceWarning, kTraceVoice, VoEId(_instanceId,-1),
                     "StartRecordingPlayout() is already recording");
        return 0;
    }

    FileFormats format;
    const uint32_t notificationTime(0);
    CodecInst dummyCodec={100,"L16",16000,320,1,320000};

    if (codecInst != NULL && codecInst->channels != 1)
    {
        _engineStatisticsPtr->SetLastError(
            VE_BAD_ARGUMENT, kTraceError,
            "StartRecordingPlayout() invalid compression");
        return(-1);
    }
    if(codecInst == NULL)
    {
        format = kFileFormatPcm16kHzFile;
        codecInst=&dummyCodec;
    }
    else if((STR_CASE_CMP(codecInst->plname,"L16") == 0) ||
        (STR_CASE_CMP(codecInst->plname,"PCMU") == 0) ||
        (STR_CASE_CMP(codecInst->plname,"PCMA") == 0))
    {
        format = kFileFormatWavFile;
    }
    else
    {
        format = kFileFormatCompressedFile;
    }

    rtc::CritScope cs(&_fileCritSect);

    // Destroy the old instance
    if (output_file_recorder_) {
      output_file_recorder_->RegisterModuleFileCallback(NULL);
      output_file_recorder_.reset();
    }

    output_file_recorder_ = FileRecorder::CreateFileRecorder(
        _instanceId, (const FileFormats)format);
    if (!output_file_recorder_) {
      _engineStatisticsPtr->SetLastError(
          VE_INVALID_ARGUMENT, kTraceError,
          "StartRecordingPlayout() fileRecorder format isnot correct");
      return -1;
    }

    if (output_file_recorder_->StartRecordingAudioFile(stream, *codecInst,
                                                       notificationTime) != 0) {
      _engineStatisticsPtr->SetLastError(
          VE_BAD_FILE, kTraceError,
          "StartRecordingAudioFile() failed to start file recording");
      output_file_recorder_->StopRecording();
      output_file_recorder_.reset();
      return -1;
    }

    output_file_recorder_->RegisterModuleFileCallback(this);
    _outputFileRecording = true;

    return 0;
}

int OutputMixer::StopRecordingPlayout()
{
    WEBRTC_TRACE(kTraceInfo, kTraceVoice, VoEId(_instanceId,-1),
                 "OutputMixer::StopRecordingPlayout()");

    if (!_outputFileRecording)
    {
        WEBRTC_TRACE(kTraceError, kTraceVoice, VoEId(_instanceId,-1),
                     "StopRecordingPlayout() file isnot recording");
        return -1;
    }

    rtc::CritScope cs(&_fileCritSect);

    if (output_file_recorder_->StopRecording() != 0) {
      _engineStatisticsPtr->SetLastError(
          VE_STOP_RECORDING_FAILED, kTraceError,
          "StopRecording(), could not stop recording");
      return -1;
    }
    output_file_recorder_->RegisterModuleFileCallback(NULL);
    output_file_recorder_.reset();
    _outputFileRecording = false;

    return 0;
}

int OutputMixer::GetMixedAudio(int sample_rate_hz,
                               size_t num_channels,
                               AudioFrame* frame) {
  WEBRTC_TRACE(
      kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
      "OutputMixer::GetMixedAudio(sample_rate_hz=%d, num_channels=%" PRIuS ")",
      sample_rate_hz, num_channels);

  // --- Record playout if enabled
  {
    rtc::CritScope cs(&_fileCritSect);
    if (_outputFileRecording && output_file_recorder_)
      output_file_recorder_->RecordAudioToFile(_audioFrame);
  }

  frame->num_channels_ = num_channels;
  frame->sample_rate_hz_ = sample_rate_hz;
  // TODO(andrew): Ideally the downmixing would occur much earlier, in
  // AudioCodingModule.
  RemixAndResample(_audioFrame, &resampler_, frame);
  return 0;
}

int32_t
OutputMixer::DoOperationsOnCombinedSignal(bool feed_data_to_apm)
{
    if (_audioFrame.sample_rate_hz_ != _mixingFrequencyHz)
    {
        WEBRTC_TRACE(kTraceStream, kTraceVoice, VoEId(_instanceId,-1),
                     "OutputMixer::DoOperationsOnCombinedSignal() => "
                     "mixing frequency = %d", _audioFrame.sample_rate_hz_);
        _mixingFrequencyHz = _audioFrame.sample_rate_hz_;
    }

    // Scale left and/or right channel(s) if balance is active
    if (_panLeft != 1.0 || _panRight != 1.0)
    {
        if (_audioFrame.num_channels_ == 1)
        {
            AudioFrameOperations::MonoToStereo(&_audioFrame);
        }
        else
        {
            // Pure stereo mode (we are receiving a stereo signal).
        }

        assert(_audioFrame.num_channels_ == 2);
        AudioFrameOperations::Scale(_panLeft, _panRight, _audioFrame);
    }

    // --- Far-end Voice Quality Enhancement (AudioProcessing Module)
    if (feed_data_to_apm) {
      APMAnalyzeReverseStream(_audioFrame);
    }

    // --- External media processing
    {
        rtc::CritScope cs(&_callbackCritSect);
        if (_externalMedia)
        {
            const bool is_stereo = (_audioFrame.num_channels_ == 2);
            if (_externalMediaCallbackPtr)
            {
                _externalMediaCallbackPtr->Process(
                    -1,
                    kPlaybackAllChannelsMixed,
                    (int16_t*)_audioFrame.data_,
                    _audioFrame.samples_per_channel_,
                    _audioFrame.sample_rate_hz_,
                    is_stereo);
            }
        }
    }

    // --- Measure audio level (0-9) for the combined signal
    _audioLevel.ComputeLevel(_audioFrame);

    return 0;
}

// Brought back by Mozilla so we can insert the reverse stream
void OutputMixer::APMAnalyzeReverseStream(AudioFrame &audioFrame) {
  // Convert 44100Hz to 32000Hz since Processing doesn't support 44100
  // directly.
  // XXX Bug 1367510 -- convert to 48000?  Or modify Processing to
  // support 44100 directly? (that's probably the best)
  AudioFrame *frame = &audioFrame;
  AudioFrame tempframe;
  if (frame->sample_rate_hz_ == AudioProcessing::NativeRate::kSampleRate44_1kHz) {
    tempframe.num_channels_ = 1;
    tempframe.sample_rate_hz_ = AudioProcessing::NativeRate::kSampleRate32kHz;
    RemixAndResample(audioFrame, &audioproc_resampler_, &tempframe);
    frame = &tempframe;
  }

  if (_audioProcessingModulePtr->ProcessReverseStream(frame) != 0) {
    WEBRTC_TRACE(kTraceWarning, kTraceVoice, VoEId(_instanceId,-1),
                 "AudioProcessingModule::ProcessReverseStream() => error");
    RTC_DCHECK(false);
  }
}

}  // namespace voe
}  // namespace webrtc
