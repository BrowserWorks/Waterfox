/*
 * Copyright (C) 2011, Google Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1.  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2.  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef DenormalDisabler_h
#define DenormalDisabler_h

#include <float.h>

#include <cmath>
#include <cstdint>
#include <cstring>

#if defined(__SSE__)
#  include <immintrin.h>
#endif

namespace WebCore {

// Deal with denormals. They can very seriously impact performance on x86.

// Define HAVE_DENORMAL if we support flushing denormals to zero.

#if defined(__SSE__) || defined(__arm__) || defined(__aarch64__)
#  define HAVE_DENORMAL 1
#endif

#ifdef HAVE_DENORMAL
namespace detail {

#  if defined(__SSE__)
#    if !defined(__x86_64__) && !defined(_M_X64)
#      if defined(__GNUC__) || defined(__clang__)
__attribute__((target("fxsr")))
#      endif
inline bool queryDAZSupported() {
  alignas(16) uint8_t fxsaveArea[512] = {};
  _fxsave(fxsaveArea);
  uint32_t mxcsrMask;
  memcpy(&mxcsrMask, fxsaveArea + 28, sizeof(mxcsrMask));
  return mxcsrMask & 0x0040;
}
#    endif

inline bool isDAZSupported() {
#    if defined(__x86_64__) || defined(_M_X64)
  return true;
#    else
  static const bool s_isSupported = queryDAZSupported();
  return s_isSupported;
#    endif
}

inline unsigned setDenormalMode(bool aDisabled) {
  unsigned saved = _mm_getcsr();
  unsigned mask = isDAZSupported() ? 0x8040 : 0x8000;
  _mm_setcsr(aDisabled ? (saved | mask) : (saved & ~mask));
  return saved;
}

inline void restoreDenormalMode(unsigned aSaved) { _mm_setcsr(aSaved); }

#  elif defined(__arm__) || defined(__aarch64__)
inline int getStatusWord() {
  int result;
#    if defined(__aarch64__)
  asm volatile("mrs %x[result], FPCR" : [result] "=r"(result));
#    else
  asm volatile("vmrs %[result], FPSCR" : [result] "=r"(result));
#    endif
  return result;
}

inline void setStatusWord(int a) {
#    if defined(__aarch64__)
  asm volatile("msr FPCR, %x[src]" : : [src] "r"(a));
#    else
  asm volatile("vmsr FPSCR, %[src]" : : [src] "r"(a));
#    endif
}

inline unsigned setDenormalMode(bool aDisabled) {
  unsigned saved = getStatusWord();
  // Bit 24 is the flush-to-zero mode control bit. Setting it to 1 flushes
  // denormals to 0.
  setStatusWord(aDisabled ? (saved | (1u << 24)) : (saved & ~(1u << 24)));
  return saved;
}

inline void restoreDenormalMode(unsigned aSaved) { setStatusWord(aSaved); }

#  endif
}  // namespace detail

// Disable denormals for the duration of this scope.
class DenormalDisabler {
 public:
  DenormalDisabler() : m_savedCSR(detail::setDenormalMode(true)) {}

  ~DenormalDisabler() { detail::restoreDenormalMode(m_savedCSR); }

  // This is a nop if we can flush denormals to zero in hardware.
  static inline float flushDenormalFloatToZero(float f) { return f; }

 private:
  unsigned m_savedCSR;
};

// Restore denormals for the duration of this scope if there is a
// DenormalDisabler somewhere higher on the stack.
class DenormalEnabler {
 public:
  DenormalEnabler() : m_savedCSR(detail::setDenormalMode(false)) {}

  ~DenormalEnabler() { detail::restoreDenormalMode(m_savedCSR); }

 private:
  unsigned m_savedCSR;
};

#else
// FIXME: add implementations for other architectures and compilers
class DenormalDisabler {
 public:
  DenormalDisabler() {}

  // Assume the worst case that other architectures and compilers
  // need to flush denormals to zero manually.
  static inline float flushDenormalFloatToZero(float f) {
    return (fabs(f) < FLT_MIN) ? 0.0f : f;
  }
};

class DenormalEnabler {
 public:
  DenormalEnabler() {}
};

#endif

}  // namespace WebCore
#endif  // DenormalDisabler_h
