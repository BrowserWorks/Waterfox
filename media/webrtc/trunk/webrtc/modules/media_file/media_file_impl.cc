/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <assert.h>

#include "webrtc/base/format_macros.h"
#include "webrtc/modules/media_file/media_file_impl.h"
#include "webrtc/system_wrappers/include/critical_section_wrapper.h"
#include "webrtc/system_wrappers/include/file_wrapper.h"
#include "webrtc/system_wrappers/include/trace.h"

namespace webrtc {
MediaFile* MediaFile::CreateMediaFile(const int32_t id)
{
    return new MediaFileImpl(id);
}

void MediaFile::DestroyMediaFile(MediaFile* module)
{
    delete static_cast<MediaFileImpl*>(module);
}

MediaFileImpl::MediaFileImpl(const int32_t id)
    : _id(id),
      _crit(CriticalSectionWrapper::CreateCriticalSection()),
      _callbackCrit(CriticalSectionWrapper::CreateCriticalSection()),
      _ptrFileUtilityObj(NULL),
      codec_info_(),
      _ptrInStream(NULL),
      _ptrOutStream(NULL),
      _fileFormat((FileFormats)-1),
      _recordDurationMs(0),
      _playoutPositionMs(0),
      _notificationMs(0),
      _playingActive(false),
      _recordingActive(false),
      _isStereo(false),
      _openFile(false),
      _fileName(),
      _ptrCallback(NULL)
{
    WEBRTC_TRACE(kTraceMemory, kTraceFile, id, "Created");

    codec_info_.plname[0] = '\0';
    _fileName[0] = '\0';
}


MediaFileImpl::~MediaFileImpl()
{
    WEBRTC_TRACE(kTraceMemory, kTraceFile, _id, "~MediaFileImpl()");
    {
        CriticalSectionScoped lock(_crit);

        if(_playingActive)
        {
            StopPlaying();
        }

        if(_recordingActive)
        {
            StopRecording();
        }

        delete _ptrFileUtilityObj;

        if(_openFile)
        {
            delete _ptrInStream;
            _ptrInStream = NULL;
            delete _ptrOutStream;
            _ptrOutStream = NULL;
        }
    }

    delete _crit;
    delete _callbackCrit;
}

int64_t MediaFileImpl::TimeUntilNextProcess()
{
    WEBRTC_TRACE(
        kTraceWarning,
        kTraceFile,
        _id,
        "TimeUntilNextProcess: This method is not used by MediaFile class.");
    return -1;
}

void MediaFileImpl::Process()
{
    WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                 "Process: This method is not used by MediaFile class.");
}

int32_t MediaFileImpl::PlayoutAudioData(int8_t* buffer,
                                        size_t& dataLengthInBytes)
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id,
               "MediaFileImpl::PlayoutData(buffer= 0x%x, bufLen= %" PRIuS ")",
                 buffer, dataLengthInBytes);

    const size_t bufferLengthInBytes = dataLengthInBytes;
    dataLengthInBytes = 0;

    if(buffer == NULL || bufferLengthInBytes == 0)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "Buffer pointer or length is NULL!");
        return -1;
    }

    int32_t bytesRead = 0;
    {
        CriticalSectionScoped lock(_crit);

        if(!_playingActive)
        {
            WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                         "Not currently playing!");
            return -1;
        }

        if(!_ptrFileUtilityObj)
        {
            WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                         "Playing, but no FileUtility object!");
            StopPlaying();
            return -1;
        }

        switch(_fileFormat)
        {
            case kFileFormatPcm32kHzFile:
            case kFileFormatPcm16kHzFile:
            case kFileFormatPcm8kHzFile:
                bytesRead = _ptrFileUtilityObj->ReadPCMData(
                    *_ptrInStream,
                    buffer,
                    bufferLengthInBytes);
                break;
            case kFileFormatCompressedFile:
                bytesRead = _ptrFileUtilityObj->ReadCompressedData(
                    *_ptrInStream,
                    buffer,
                    bufferLengthInBytes);
                break;
            case kFileFormatWavFile:
                bytesRead = _ptrFileUtilityObj->ReadWavDataAsMono(
                    *_ptrInStream,
                    buffer,
                    bufferLengthInBytes);
                break;
            case kFileFormatPreencodedFile:
                bytesRead = _ptrFileUtilityObj->ReadPreEncodedData(
                    *_ptrInStream,
                    buffer,
                    bufferLengthInBytes);
                if(bytesRead > 0)
                {
                    dataLengthInBytes = static_cast<size_t>(bytesRead);
                    return 0;
                }
                break;
            default:
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Invalid file format: %d", _fileFormat);
                assert(false);
                break;
            }
        }

        if( bytesRead > 0)
        {
            dataLengthInBytes = static_cast<size_t>(bytesRead);
        }
    }
    HandlePlayCallbacks(bytesRead);
    return 0;
}

void MediaFileImpl::HandlePlayCallbacks(int32_t bytesRead)
{
    bool playEnded = false;
    uint32_t callbackNotifyMs = 0;

    if(bytesRead > 0)
    {
        // Check if it's time for PlayNotification(..).
        _playoutPositionMs = _ptrFileUtilityObj->PlayoutPositionMs();
        if(_notificationMs)
        {
            if(_playoutPositionMs >= _notificationMs)
            {
                _notificationMs = 0;
                callbackNotifyMs = _playoutPositionMs;
            }
        }
    }
    else
    {
        // If no bytes were read assume end of file.
        StopPlaying();
        playEnded = true;
    }

    // Only _callbackCrit may and should be taken when making callbacks.
    CriticalSectionScoped lock(_callbackCrit);
    if(_ptrCallback)
    {
        if(callbackNotifyMs)
        {
            _ptrCallback->PlayNotification(_id, callbackNotifyMs);
        }
        if(playEnded)
        {
            _ptrCallback->PlayFileEnded(_id);
        }
    }
}

int32_t MediaFileImpl::PlayoutStereoData(
    int8_t* bufferLeft,
    int8_t* bufferRight,
    size_t& dataLengthInBytes)
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id,
                 "MediaFileImpl::PlayoutStereoData(Left = 0x%x, Right = 0x%x,"
                 " Len= %" PRIuS ")",
                 bufferLeft,
                 bufferRight,
                 dataLengthInBytes);

    const size_t bufferLengthInBytes = dataLengthInBytes;
    dataLengthInBytes = 0;

    if(bufferLeft == NULL || bufferRight == NULL || bufferLengthInBytes == 0)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "A buffer pointer or the length is NULL!");
        return -1;
    }

    bool playEnded = false;
    uint32_t callbackNotifyMs = 0;
    {
        CriticalSectionScoped lock(_crit);

        if(!_playingActive || !_isStereo)
        {
            WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                         "Not currently playing stereo!");
            return -1;
        }

        if(!_ptrFileUtilityObj)
        {
            WEBRTC_TRACE(
                kTraceError,
                kTraceFile,
                _id,
                "Playing stereo, but the FileUtility objects is NULL!");
            StopPlaying();
            return -1;
        }

        // Stereo playout only supported for WAV files.
        int32_t bytesRead = 0;
        switch(_fileFormat)
        {
            case kFileFormatWavFile:
                    bytesRead = _ptrFileUtilityObj->ReadWavDataAsStereo(
                        *_ptrInStream,
                        bufferLeft,
                        bufferRight,
                        bufferLengthInBytes);
                    break;
            default:
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Trying to read non-WAV as stereo audio\
 (not supported)");
                break;
        }

        if(bytesRead > 0)
        {
            dataLengthInBytes = static_cast<size_t>(bytesRead);

            // Check if it's time for PlayNotification(..).
            _playoutPositionMs = _ptrFileUtilityObj->PlayoutPositionMs();
            if(_notificationMs)
            {
                if(_playoutPositionMs >= _notificationMs)
                {
                    _notificationMs = 0;
                    callbackNotifyMs = _playoutPositionMs;
                }
            }
        }
        else
        {
            // If no bytes were read assume end of file.
            StopPlaying();
            playEnded = true;
        }
    }

    CriticalSectionScoped lock(_callbackCrit);
    if(_ptrCallback)
    {
        if(callbackNotifyMs)
        {
            _ptrCallback->PlayNotification(_id, callbackNotifyMs);
        }
        if(playEnded)
        {
            _ptrCallback->PlayFileEnded(_id);
        }
    }
    return 0;
}

int32_t MediaFileImpl::StartPlayingAudioFile(
    const char* fileName,
    const uint32_t notificationTimeMs,
    const bool loop,
    const FileFormats format,
    const CodecInst* codecInst,
    const uint32_t startPointMs,
    const uint32_t stopPointMs)
{
    if(!ValidFileName(fileName))
    {
        return -1;
    }
    if(!ValidFileFormat(format,codecInst))
    {
        return -1;
    }
    if(!ValidFilePositions(startPointMs,stopPointMs))
    {
        return -1;
    }

    // Check that the file will play longer than notificationTimeMs ms.
    if((startPointMs && stopPointMs && !loop) &&
       (notificationTimeMs > (stopPointMs - startPointMs)))
    {
        WEBRTC_TRACE(
            kTraceError,
            kTraceFile,
            _id,
            "specified notification time is longer than amount of ms that will\
 be played");
        return -1;
    }

    FileWrapper* inputStream = FileWrapper::Create();
    if(inputStream == NULL)
    {
       WEBRTC_TRACE(kTraceMemory, kTraceFile, _id,
                    "Failed to allocate input stream for file %s", fileName);
        return -1;
    }

    if (!inputStream->OpenFile(fileName, true)) {
      delete inputStream;
      WEBRTC_TRACE(kTraceError, kTraceFile, _id, "Could not open input file %s",
                   fileName);
      return -1;
    }

    if(StartPlayingStream(*inputStream, loop, notificationTimeMs,
                          format, codecInst, startPointMs, stopPointMs) == -1)
    {
        inputStream->CloseFile();
        delete inputStream;
        return -1;
    }

    CriticalSectionScoped lock(_crit);
    _openFile = true;
    strncpy(_fileName, fileName, sizeof(_fileName));
    _fileName[sizeof(_fileName) - 1] = '\0';
    return 0;
}

int32_t MediaFileImpl::StartPlayingAudioStream(
    InStream& stream,
    const uint32_t notificationTimeMs,
    const FileFormats format,
    const CodecInst* codecInst,
    const uint32_t startPointMs,
    const uint32_t stopPointMs)
{
    return StartPlayingStream(stream, false, notificationTimeMs, format,
                              codecInst, startPointMs, stopPointMs);
}

int32_t MediaFileImpl::StartPlayingStream(
    InStream& stream,
    bool loop,
    const uint32_t notificationTimeMs,
    const FileFormats format,
    const CodecInst*  codecInst,
    const uint32_t startPointMs,
    const uint32_t stopPointMs)
{
    if(!ValidFileFormat(format,codecInst))
    {
        return -1;
    }

    if(!ValidFilePositions(startPointMs,stopPointMs))
    {
        return -1;
    }

    CriticalSectionScoped lock(_crit);
    if(_playingActive || _recordingActive)
    {
        WEBRTC_TRACE(
            kTraceError,
            kTraceFile,
            _id,
            "StartPlaying called, but already playing or recording file %s",
            (_fileName[0] == '\0') ? "(name not set)" : _fileName);
        return -1;
    }

    if(_ptrFileUtilityObj != NULL)
    {
        WEBRTC_TRACE(kTraceError,
                     kTraceFile,
                     _id,
                     "StartPlaying called, but FileUtilityObj already exists!");
        StopPlaying();
        return -1;
    }

    _ptrFileUtilityObj = new ModuleFileUtility(_id);
    if(_ptrFileUtilityObj == NULL)
    {
        WEBRTC_TRACE(kTraceMemory, kTraceFile, _id,
                     "Failed to create FileUtilityObj!");
        return -1;
    }

    switch(format)
    {
        case kFileFormatWavFile:
        {
            if(_ptrFileUtilityObj->InitWavReading(stream, startPointMs,
                                                  stopPointMs) == -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Not a valid WAV file!");
                StopPlaying();
                return -1;
            }
            _fileFormat = kFileFormatWavFile;
            break;
        }
        case kFileFormatCompressedFile:
        {
            if(_ptrFileUtilityObj->InitCompressedReading(stream, startPointMs,
                                                         stopPointMs) == -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Not a valid Compressed file!");
                StopPlaying();
                return -1;
            }
            _fileFormat = kFileFormatCompressedFile;
            break;
        }
        case kFileFormatPcm8kHzFile:
        case kFileFormatPcm16kHzFile:
        case kFileFormatPcm32kHzFile:
        {
            // ValidFileFormat() called in the beginneing of this function
            // prevents codecInst from being NULL here.
            assert(codecInst != NULL);
            if(!ValidFrequency(codecInst->plfreq) ||
               _ptrFileUtilityObj->InitPCMReading(stream, startPointMs,
                                                  stopPointMs,
                                                  codecInst->plfreq) == -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Not a valid raw 8 or 16 KHz PCM file!");
                StopPlaying();
                return -1;
            }

            _fileFormat = format;
            break;
        }
        case kFileFormatPreencodedFile:
        {
            // ValidFileFormat() called in the beginneing of this function
            // prevents codecInst from being NULL here.
            assert(codecInst != NULL);
            if(_ptrFileUtilityObj->InitPreEncodedReading(stream, *codecInst) ==
               -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Not a valid PreEncoded file!");
                StopPlaying();
                return -1;
            }

            _fileFormat = kFileFormatPreencodedFile;
            break;
        }
        default:
        {
            WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                         "Invalid file format: %d", format);
            assert(false);
            break;
        }
    }
    if(_ptrFileUtilityObj->codec_info(codec_info_) == -1)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "Failed to retrieve codec info!");
        StopPlaying();
        return -1;
    }

    _isStereo = (codec_info_.channels == 2);
    if(_isStereo && (_fileFormat != kFileFormatWavFile))
    {
        WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                     "Stereo is only allowed for WAV files");
        StopPlaying();
        return -1;
    }
    _playingActive = true;
    _playoutPositionMs = _ptrFileUtilityObj->PlayoutPositionMs();
    _ptrInStream = &stream;
    _notificationMs = notificationTimeMs;

    return 0;
}

int32_t MediaFileImpl::StopPlaying()
{

    CriticalSectionScoped lock(_crit);
    _isStereo = false;
    if(_ptrFileUtilityObj)
    {
        delete _ptrFileUtilityObj;
        _ptrFileUtilityObj = NULL;
    }
    if(_ptrInStream)
    {
        // If MediaFileImpl opened the InStream it must be reclaimed here.
        if(_openFile)
        {
            delete _ptrInStream;
            _openFile = false;
        }
        _ptrInStream = NULL;
    }

    codec_info_.pltype = 0;
    codec_info_.plname[0] = '\0';

    if(!_playingActive)
    {
        WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                     "playing is not active!");
        return -1;
    }

    _playingActive = false;
    return 0;
}

bool MediaFileImpl::IsPlaying()
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id, "MediaFileImpl::IsPlaying()");
    CriticalSectionScoped lock(_crit);
    return _playingActive;
}

int32_t MediaFileImpl::IncomingAudioData(
    const int8_t*  buffer,
    const size_t bufferLengthInBytes)
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id,
                 "MediaFile::IncomingData(buffer= 0x%x, bufLen= %" PRIuS,
                 buffer, bufferLengthInBytes);

    if(buffer == NULL || bufferLengthInBytes == 0)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "Buffer pointer or length is NULL!");
        return -1;
    }

    bool recordingEnded = false;
    uint32_t callbackNotifyMs = 0;
    {
        CriticalSectionScoped lock(_crit);

        if(!_recordingActive)
        {
            WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                         "Not currently recording!");
            return -1;
        }
        if(_ptrOutStream == NULL)
        {
            WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                         "Recording is active, but output stream is NULL!");
            assert(false);
            return -1;
        }

        int32_t bytesWritten = 0;
        uint32_t samplesWritten = codec_info_.pacsize;
        if(_ptrFileUtilityObj)
        {
            switch(_fileFormat)
            {
                case kFileFormatPcm8kHzFile:
                case kFileFormatPcm16kHzFile:
                case kFileFormatPcm32kHzFile:
                    bytesWritten = _ptrFileUtilityObj->WritePCMData(
                        *_ptrOutStream,
                        buffer,
                        bufferLengthInBytes);

                    // Sample size is 2 bytes.
                    if(bytesWritten > 0)
                    {
                        samplesWritten = bytesWritten/sizeof(int16_t);
                    }
                    break;
                case kFileFormatCompressedFile:
                    bytesWritten = _ptrFileUtilityObj->WriteCompressedData(
                        *_ptrOutStream, buffer, bufferLengthInBytes);
                    break;
                case kFileFormatWavFile:
                    bytesWritten = _ptrFileUtilityObj->WriteWavData(
                        *_ptrOutStream,
                        buffer,
                        bufferLengthInBytes);
                    if(bytesWritten > 0 && STR_NCASE_CMP(codec_info_.plname,
                                                         "L16", 4) == 0)
                    {
                        // Sample size is 2 bytes.
                        samplesWritten = bytesWritten/sizeof(int16_t);
                    }
                    break;
                case kFileFormatPreencodedFile:
                    bytesWritten = _ptrFileUtilityObj->WritePreEncodedData(
                        *_ptrOutStream, buffer, bufferLengthInBytes);
                    break;
                default:
                    WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                                 "Invalid file format: %d", _fileFormat);
                    assert(false);
                    break;
            }
        } else {
            // TODO (hellner): quick look at the code makes me think that this
            //                 code is never executed. Remove?
            if(_ptrOutStream)
            {
                if(_ptrOutStream->Write(buffer, bufferLengthInBytes))
                {
                    bytesWritten = static_cast<int32_t>(bufferLengthInBytes);
                }
            }
        }

        _recordDurationMs += samplesWritten / (codec_info_.plfreq / 1000);

        // Check if it's time for RecordNotification(..).
        if(_notificationMs)
        {
            if(_recordDurationMs  >= _notificationMs)
            {
                _notificationMs = 0;
                callbackNotifyMs = _recordDurationMs;
            }
        }
        if(bytesWritten < (int32_t)bufferLengthInBytes)
        {
            WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                         "Failed to write all requested bytes!");
            StopRecording();
            recordingEnded = true;
        }
    }

    // Only _callbackCrit may and should be taken when making callbacks.
    CriticalSectionScoped lock(_callbackCrit);
    if(_ptrCallback)
    {
        if(callbackNotifyMs)
        {
            _ptrCallback->RecordNotification(_id, callbackNotifyMs);
        }
        if(recordingEnded)
        {
            _ptrCallback->RecordFileEnded(_id);
            return -1;
        }
    }
    return 0;
}

int32_t MediaFileImpl::StartRecordingAudioFile(
    const char* fileName,
    const FileFormats format,
    const CodecInst& codecInst,
    const uint32_t notificationTimeMs,
    const uint32_t maxSizeBytes)
{
    if(!ValidFileName(fileName))
    {
        return -1;
    }
    if(!ValidFileFormat(format,&codecInst))
    {
        return -1;
    }

    FileWrapper* outputStream = FileWrapper::Create();
    if(outputStream == NULL)
    {
        WEBRTC_TRACE(kTraceMemory, kTraceFile, _id,
                     "Failed to allocate memory for output stream");
        return -1;
    }

    if (!outputStream->OpenFile(fileName, false)) {
      delete outputStream;
      WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                   "Could not open output file '%s' for writing!", fileName);
      return -1;
    }

    if(maxSizeBytes)
    {
        outputStream->SetMaxFileSize(maxSizeBytes);
    }

    if(StartRecordingAudioStream(*outputStream, format, codecInst,
                                 notificationTimeMs) == -1)
    {
        outputStream->CloseFile();
        delete outputStream;
        return -1;
    }

    CriticalSectionScoped lock(_crit);
    _openFile = true;
    strncpy(_fileName, fileName, sizeof(_fileName));
    _fileName[sizeof(_fileName) - 1] = '\0';
    return 0;
}

int32_t MediaFileImpl::StartRecordingAudioStream(
    OutStream& stream,
    const FileFormats format,
    const CodecInst& codecInst,
    const uint32_t notificationTimeMs)
{
    // Check codec info
    if(!ValidFileFormat(format,&codecInst))
    {
        return -1;
    }

    CriticalSectionScoped lock(_crit);
    if(_recordingActive || _playingActive)
    {
        WEBRTC_TRACE(
            kTraceError,
            kTraceFile,
            _id,
            "StartRecording called, but already recording or playing file %s!",
                   _fileName);
        return -1;
    }

    if(_ptrFileUtilityObj != NULL)
    {
        WEBRTC_TRACE(
            kTraceError,
            kTraceFile,
            _id,
            "StartRecording called, but fileUtilityObj already exists!");
        StopRecording();
        return -1;
    }

    _ptrFileUtilityObj = new ModuleFileUtility(_id);
    if(_ptrFileUtilityObj == NULL)
    {
        WEBRTC_TRACE(kTraceMemory, kTraceFile, _id,
                     "Cannot allocate fileUtilityObj!");
        return -1;
    }

    CodecInst tmpAudioCodec;
    memcpy(&tmpAudioCodec, &codecInst, sizeof(CodecInst));
    switch(format)
    {
        case kFileFormatWavFile:
        {
            if(_ptrFileUtilityObj->InitWavWriting(stream, codecInst) == -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Failed to initialize WAV file!");
                delete _ptrFileUtilityObj;
                _ptrFileUtilityObj = NULL;
                return -1;
            }
            _fileFormat = kFileFormatWavFile;
            break;
        }
        case kFileFormatCompressedFile:
        {
            // Write compression codec name at beginning of file
            if(_ptrFileUtilityObj->InitCompressedWriting(stream, codecInst) ==
               -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Failed to initialize Compressed file!");
                delete _ptrFileUtilityObj;
                _ptrFileUtilityObj = NULL;
                return -1;
            }
            _fileFormat = kFileFormatCompressedFile;
            break;
        }
        case kFileFormatPcm8kHzFile:
        case kFileFormatPcm16kHzFile:
        {
            if(!ValidFrequency(codecInst.plfreq) ||
               _ptrFileUtilityObj->InitPCMWriting(stream, codecInst.plfreq) ==
               -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Failed to initialize 8 or 16KHz PCM file!");
                delete _ptrFileUtilityObj;
                _ptrFileUtilityObj = NULL;
                return -1;
            }
            _fileFormat = format;
            break;
        }
        case kFileFormatPreencodedFile:
        {
            if(_ptrFileUtilityObj->InitPreEncodedWriting(stream, codecInst) ==
               -1)
            {
                WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                             "Failed to initialize Pre-Encoded file!");
                delete _ptrFileUtilityObj;
                _ptrFileUtilityObj = NULL;
                return -1;
            }

            _fileFormat = kFileFormatPreencodedFile;
            break;
        }
        default:
        {
            WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                         "Invalid file format %d specified!", format);
            delete _ptrFileUtilityObj;
            _ptrFileUtilityObj = NULL;
            return -1;
        }
    }
    _isStereo = (tmpAudioCodec.channels == 2);
    if(_isStereo)
    {
        if(_fileFormat != kFileFormatWavFile)
        {
            WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                         "Stereo is only allowed for WAV files");
            StopRecording();
            return -1;
        }
        if((STR_NCASE_CMP(tmpAudioCodec.plname, "L16", 4) != 0) &&
           (STR_NCASE_CMP(tmpAudioCodec.plname, "PCMU", 5) != 0) &&
           (STR_NCASE_CMP(tmpAudioCodec.plname, "PCMA", 5) != 0))
        {
            WEBRTC_TRACE(
                kTraceWarning,
                kTraceFile,
                _id,
                "Stereo is only allowed for codec PCMU, PCMA and L16 ");
            StopRecording();
            return -1;
        }
    }
    memcpy(&codec_info_, &tmpAudioCodec, sizeof(CodecInst));
    _recordingActive = true;
    _ptrOutStream = &stream;
    _notificationMs = notificationTimeMs;
    _recordDurationMs = 0;
    return 0;
}

int32_t MediaFileImpl::StopRecording()
{

    CriticalSectionScoped lock(_crit);
    if(!_recordingActive)
    {
        WEBRTC_TRACE(kTraceWarning, kTraceFile, _id,
                     "recording is not active!");
        return -1;
    }

    _isStereo = false;

    if(_ptrFileUtilityObj != NULL)
    {
        // Both AVI and WAV header has to be updated before closing the stream
        // because they contain size information.
        if((_fileFormat == kFileFormatWavFile) &&
            (_ptrOutStream != NULL))
        {
            _ptrFileUtilityObj->UpdateWavHeader(*_ptrOutStream);
        }
        delete _ptrFileUtilityObj;
        _ptrFileUtilityObj = NULL;
    }

    if(_ptrOutStream != NULL)
    {
        // If MediaFileImpl opened the OutStream it must be reclaimed here.
        if(_openFile)
        {
            delete _ptrOutStream;
            _openFile = false;
        }
        _ptrOutStream = NULL;
    }

    _recordingActive = false;
    codec_info_.pltype = 0;
    codec_info_.plname[0] = '\0';

    return 0;
}

bool MediaFileImpl::IsRecording()
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id, "MediaFileImpl::IsRecording()");
    CriticalSectionScoped lock(_crit);
    return _recordingActive;
}

int32_t MediaFileImpl::RecordDurationMs(uint32_t& durationMs)
{

    CriticalSectionScoped lock(_crit);
    if(!_recordingActive)
    {
        durationMs = 0;
        return -1;
    }
    durationMs = _recordDurationMs;
    return 0;
}

bool MediaFileImpl::IsStereo()
{
    WEBRTC_TRACE(kTraceStream, kTraceFile, _id, "MediaFileImpl::IsStereo()");
    CriticalSectionScoped lock(_crit);
    return _isStereo;
}

int32_t MediaFileImpl::SetModuleFileCallback(FileCallback* callback)
{

    CriticalSectionScoped lock(_callbackCrit);

    _ptrCallback = callback;
    return 0;
}

int32_t MediaFileImpl::FileDurationMs(const char* fileName,
                                      uint32_t& durationMs,
                                      const FileFormats format,
                                      const uint32_t freqInHz)
{

    if(!ValidFileName(fileName))
    {
        return -1;
    }
    if(!ValidFrequency(freqInHz))
    {
        return -1;
    }

    ModuleFileUtility* utilityObj = new ModuleFileUtility(_id);
    if(utilityObj == NULL)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "failed to allocate utility object!");
        return -1;
    }

    const int32_t duration = utilityObj->FileDurationMs(fileName, format,
                                                        freqInHz);
    delete utilityObj;
    if(duration == -1)
    {
        durationMs = 0;
        return -1;
    }

    durationMs = duration;
    return 0;
}

int32_t MediaFileImpl::PlayoutPositionMs(uint32_t& positionMs) const
{
    CriticalSectionScoped lock(_crit);
    if(!_playingActive)
    {
        positionMs = 0;
        return -1;
    }
    positionMs = _playoutPositionMs;
    return 0;
}

int32_t MediaFileImpl::codec_info(CodecInst& codecInst) const
{
    CriticalSectionScoped lock(_crit);
    if(!_playingActive && !_recordingActive)
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "Neither playout nor recording has been initialized!");
        return -1;
    }
    if (codec_info_.pltype == 0 && codec_info_.plname[0] == '\0')
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, _id,
                     "The CodecInst for %s is unknown!",
            _playingActive ? "Playback" : "Recording");
        return -1;
    }
    memcpy(&codecInst,&codec_info_,sizeof(CodecInst));
    return 0;
}

bool MediaFileImpl::ValidFileFormat(const FileFormats format,
                                    const CodecInst*  codecInst)
{
    if(codecInst == NULL)
    {
        if(format == kFileFormatPreencodedFile ||
           format == kFileFormatPcm8kHzFile    ||
           format == kFileFormatPcm16kHzFile   ||
           format == kFileFormatPcm32kHzFile)
        {
            WEBRTC_TRACE(kTraceError, kTraceFile, -1,
                         "Codec info required for file format specified!");
            return false;
        }
    }
    return true;
}

bool MediaFileImpl::ValidFileName(const char* fileName)
{
    if((fileName == NULL) ||(fileName[0] == '\0'))
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, -1, "FileName not specified!");
        return false;
    }
    return true;
}


bool MediaFileImpl::ValidFilePositions(const uint32_t startPointMs,
                                       const uint32_t stopPointMs)
{
    if(startPointMs == 0 && stopPointMs == 0) // Default values
    {
        return true;
    }
    if(stopPointMs &&(startPointMs >= stopPointMs))
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, -1,
                     "startPointMs must be less than stopPointMs!");
        return false;
    }
    if(stopPointMs &&((stopPointMs - startPointMs) < 20))
    {
        WEBRTC_TRACE(kTraceError, kTraceFile, -1,
                     "minimum play duration for files is 20 ms!");
        return false;
    }
    return true;
}

bool MediaFileImpl::ValidFrequency(const uint32_t frequency)
{
    if((frequency == 8000) || (frequency == 16000)|| (frequency == 32000))
    {
        return true;
    }
    WEBRTC_TRACE(kTraceError, kTraceFile, -1,
                 "Frequency should be 8000, 16000 or 32000 (Hz)");
    return false;
}
}  // namespace webrtc
