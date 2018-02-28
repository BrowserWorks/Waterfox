/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_AUDIO_PROCESSING_LOGGING_APM_DATA_DUMPER_H_
#define WEBRTC_MODULES_AUDIO_PROCESSING_LOGGING_APM_DATA_DUMPER_H_

#include <stdio.h>

#include <memory>
#include <string>
#include <string.h>
#include <unordered_map>

#include "webrtc/base/array_view.h"
#include "webrtc/base/constructormagic.h"
#include "webrtc/common_audio/wav_file.h"
#include "webrtc/system_wrappers/include/trace.h"

// Check to verify that the define is properly set.
#if !defined(WEBRTC_APM_DEBUG_DUMP) || \
    (WEBRTC_APM_DEBUG_DUMP != 0 && WEBRTC_APM_DEBUG_DUMP != 1)
#error "Set WEBRTC_APM_DEBUG_DUMP to either 0 or 1"
#endif

namespace webrtc {

#if WEBRTC_APM_DEBUG_DUMP == 1
// Functor used to use as a custom deleter in the map of file pointers to raw
// files.
struct RawFileCloseFunctor {
  void operator()(FILE* f) const { if (f) fclose(f); }
};
#endif

// Class that handles dumping of variables into files.
class ApmDataDumper {
 public:
  // Constructor that takes an instance index that may
  // be used to distinguish data dumped from different
  // instances of the code.
  explicit ApmDataDumper(int instance_index);

  ~ApmDataDumper();

  // Reinitializes the data dumping such that new versions
  // of all files being dumped to are created.
  void InitiateNewSetOfRecordings() {
#if WEBRTC_APM_DEBUG_DUMP == 1
    ++recording_set_index_;
    debug_written_ = 0;
#endif
  }

  // Methods for performing dumping of data of various types into
  // various formats.
  void DumpRaw(const char* name, int v_length, const float* v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    if (webrtc::Trace::aec_debug()) {
      FILE* file = GetRawFile(name);
      if (file) {
        fwrite(v, sizeof(v[0]), v_length, file);
      }
    }
#endif
  }

  void DumpRaw(const char* name, rtc::ArrayView<const float> v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    DumpRaw(name, v.size(), v.data());
#endif
  }

  void DumpRaw(const char* name, int v_length, const bool* v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    if (webrtc::Trace::aec_debug()) {
      FILE* file = GetRawFile(name);
      if (file) {
        for (int k = 0; k < v_length; ++k) {
          int16_t value = static_cast<int16_t>(v[k]);
          fwrite(&value, sizeof(value), 1, file);
        }
      }
    }
#endif
  }

  void DumpRaw(const char* name, rtc::ArrayView<const bool> v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    DumpRaw(name, v.size(), v.data());
#endif
  }

  void DumpRaw(const char* name, int v_length, const int16_t* v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    if (webrtc::Trace::aec_debug()) {
      FILE* file = GetRawFile(name);
      if (file) {
        fwrite(v, sizeof(v[0]), v_length, file);
      }
    }
#endif
  }

  void DumpRaw(const char* name, rtc::ArrayView<const int16_t> v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    DumpRaw(name, v.size(), v.data());
#endif
  }

  void DumpRaw(const char* name, int v_length, const int32_t* v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    if (webrtc::Trace::aec_debug()) {
      FILE* file = GetRawFile(name);
      if (file) {
        fwrite(v, sizeof(v[0]), v_length, file);
      }
    }
#endif
  }

  void DumpRaw(const char* name, rtc::ArrayView<const int32_t> v) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    DumpRaw(name, v.size(), v.data());
#endif
  }

  void DumpWav(const char* name,
               int v_length,
               const float* v,
               int sample_rate_hz,
               int num_channels) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    if (webrtc::Trace::aec_debug()) {
      WavWriter* file = GetWavFile(name, sample_rate_hz, num_channels);
      file->WriteSamples(v, v_length);
      // Cheat and use aec_near as a stand-in for "size of the largest file"
      // in the dump.  We're looking to limit the total time, and that's a
      // reasonable stand-in.
      if (strcmp(name, "aec_near") == 0) {
        updateDebugWritten(v_length * sizeof(float));
      }
    }
#endif
  }

  void DumpWav(const char* name,
               rtc::ArrayView<const float> v,
               int sample_rate_hz,
               int num_channels) {
#if WEBRTC_APM_DEBUG_DUMP == 1
    DumpWav(name, v.size(), v.data(), sample_rate_hz, num_channels);
#endif
  }

 private:
#if WEBRTC_APM_DEBUG_DUMP == 1
  const int instance_index_;
  int recording_set_index_ = 0;
  std::unordered_map<std::string, std::unique_ptr<FILE, RawFileCloseFunctor>>
      raw_files_;
  std::unordered_map<std::string, std::unique_ptr<WavWriter>> wav_files_;

  FILE* GetRawFile(const char* name);
  WavWriter* GetWavFile(const char* name, int sample_rate_hz, int num_channels);

  uint32_t debug_written_;

  void updateDebugWritten(uint32_t amount) {
    debug_written_ += amount;
    // Limit largest files to a specific (rough) size, to avoid filling up disk.
    if (debug_written_ >= webrtc::Trace::aec_debug_size()) {
      webrtc::Trace::set_aec_debug(false);
    }
  }

#endif
  RTC_DISALLOW_IMPLICIT_CONSTRUCTORS(ApmDataDumper);
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_AUDIO_PROCESSING_LOGGING_APM_DATA_DUMPER_H_
