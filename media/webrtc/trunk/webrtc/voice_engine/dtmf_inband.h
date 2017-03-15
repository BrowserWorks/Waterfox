/*
 *  Copyright (c) 2011 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_VOICE_ENGINE_DTMF_INBAND_H_
#define WEBRTC_VOICE_ENGINE_DTMF_INBAND_H_

#include "webrtc/typedefs.h"
#include "webrtc/voice_engine/voice_engine_defines.h"

#define MAX_DTMF_SAMPLERATE 48000

namespace webrtc {
class CriticalSectionWrapper;

class DtmfInband
{
public:
    DtmfInband(int32_t id);

    virtual ~DtmfInband();

    void Init();

    int SetSampleRate(uint16_t frequency);

    int GetSampleRate(uint16_t& frequency);

    int AddTone(uint8_t eventCode,
                int32_t lengthMs,
                int32_t attenuationDb);

    int ResetTone();
    int StartTone(uint8_t eventCode, int32_t attenuationDb);

    int StopTone();

    bool IsAddingTone();

    int Get10msTone(int16_t output[MAX_DTMF_SAMPLERATE/100], uint16_t& outputSizeInSamples);

    uint32_t DelaySinceLastTone() const;

    void UpdateDelaySinceLastTone();

private:
    void ReInit();
    int16_t DtmfFix_generate(int16_t* decoded,
                             int16_t value,
                             int16_t volume,
                             int16_t frameLen,
                             uint16_t fs);

private:
    enum {kDtmfFrameSizeMs = 10};
    enum {kDtmfAmpHigh = 32768};
    enum {kDtmfAmpLow  = 23171};	// 3 dB lower than the high frequency

    int16_t DtmfFix_generateSignal(int16_t a1_times2,
                                   int16_t a2_times2,
                                   int16_t volume,
                                   int16_t* signal,
                                   int16_t length);

private:
    CriticalSectionWrapper& _critSect;
    int32_t _id;
    uint16_t _outputFrequencyHz;  // {8000, 16000, 32000, 44100, 48000}
    int16_t _oldOutputLow[2];     // Data needed for oscillator model
    int16_t _oldOutputHigh[2];    // Data needed for oscillator model
    int16_t _frameLengthSamples;  // {80, 160, 320, 441, 480}
    int32_t _remainingSamples;
    int16_t _eventCode;           // [0, 15]
    int16_t _attenuationDb;       // [0, 36]
    int32_t _lengthMs;
    bool _reinit;  // 'true' if the oscillator should be reinit for next event
    bool _playing;
    uint32_t _delaySinceLastToneMS; // time since last generated tone [ms]
};

}  // namespace webrtc

#endif // #ifndef WEBRTC_VOICE_ENGINE_DTMF_INBAND_H_
