/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#ifndef mozilla_interceptor_PatcherBase_h
#define mozilla_interceptor_PatcherBase_h

#include "mozilla/interceptor/TargetFunction.h"

namespace mozilla {
namespace interceptor {

template <typename MMPolicy>
struct GetProcAddressSelector;

template <>
struct GetProcAddressSelector<MMPolicyOutOfProcess> {
  FARPROC operator()(HMODULE aModule, const char* aName,
                     const MMPolicyOutOfProcess& aMMPolicy) const {
    auto exportSection =
        mozilla::nt::PEExportSection<MMPolicyOutOfProcess>::Get(aModule,
                                                                aMMPolicy);
    return exportSection.GetProcAddress(aName);
  }
};

template <>
struct GetProcAddressSelector<MMPolicyInProcess> {
  FARPROC operator()(HMODULE aModule, const char* aName,
                     const MMPolicyInProcess&) const {
    // PEExportSection works for MMPolicyInProcess, too, but the native
    // GetProcAddress is still better because PEExportSection does not
    // solve a forwarded entry.
    return ::GetProcAddress(aModule, aName);
  }
};

template <typename VMPolicy>
class WindowsDllPatcherBase {
 protected:
  typedef typename VMPolicy::MMPolicyT MMPolicyT;

  template <typename... Args>
  explicit WindowsDllPatcherBase(Args&&... aArgs)
      : mVMPolicy(std::forward<Args>(aArgs)...) {}

  ReadOnlyTargetFunction<MMPolicyT> ResolveRedirectedAddress(
      FARPROC aOriginalFunction) {
    ReadOnlyTargetFunction<MMPolicyT> origFn(mVMPolicy, aOriginalFunction);
#if defined(_M_IX86) || defined(_M_X64)
    // If function entry is jmp rel8 stub to the internal implementation, we
    // resolve redirected address from the jump target.
    if (origFn[0] == 0xeb) {
      int8_t offset = (int8_t)(origFn[1]);
      uintptr_t abstarget = origFn.GetAddress() + 2 + offset;

#  if defined(_M_X64)
      // We redirect to the target of a short jump backwards if the target
      // is another jump (only 32-bit displacement is currently supported).
      // This case is used by GetFileAttributesW in Win7.
      if ((offset < 0) && (origFn.IsValidAtOffset(2 + offset))) {
        ReadOnlyTargetFunction<MMPolicyT> redirectFn(mVMPolicy, abstarget);
        if ((redirectFn[0] == 0xff) && (redirectFn[1] == 0x25)) {
          return redirectFn;
        }
      }
#  endif

      if (offset <= 0) {
        // Bail out for negative offset: probably already patched by some
        // third-party code.
        return origFn;
      }

      for (int8_t i = 0; i < offset; i++) {
        if (origFn[2 + i] != 0x90) {
          // Bail out on insufficient nop space.
          return origFn;
        }
      }

      return EnsureTargetIsAccessible(std::move(origFn), abstarget);
    }

#  if defined(_M_IX86)
    // If function entry is jmp [disp32] such as used by kernel32,
    // we resolve redirected address from import table.
    if (origFn[0] == 0xff && origFn[1] == 0x25) {
      uintptr_t abstarget = (origFn + 2).template ChasePointer<uintptr_t*>();
      return EnsureTargetIsAccessible(std::move(origFn), abstarget);
    }
#  elif defined(_M_X64)
    // If function entry is jmp [disp32] such as used by kernel32,
    // we resolve redirected address from import table.
    if (origFn[0] == 0x48 && origFn[1] == 0xff && origFn[2] == 0x25) {
      uintptr_t abstarget = (origFn + 3).ChasePointerFromDisp();
      return EnsureTargetIsAccessible(std::move(origFn), abstarget);
    }

    if (origFn[0] == 0xe9) {
      // require for TestDllInterceptor with --disable-optimize
      uintptr_t abstarget = (origFn + 1).ReadDisp32AsAbsolute();
      return EnsureTargetIsAccessible(std::move(origFn), abstarget);
    }
#  endif
#endif  // defined(_M_IX86) || defined(_M_X64)

    return origFn;
  }

 private:
  ReadOnlyTargetFunction<MMPolicyT> EnsureTargetIsAccessible(
      ReadOnlyTargetFunction<MMPolicyT> aOrigFn, uintptr_t aRedirAddress) {
    if (!mVMPolicy.IsPageAccessible(reinterpret_cast<void*>(aRedirAddress))) {
      return aOrigFn;
    }

    return ReadOnlyTargetFunction<MMPolicyT>(mVMPolicy, aRedirAddress);
  }

 public:
  FARPROC GetProcAddress(HMODULE aModule, const char* aName) const {
    GetProcAddressSelector<MMPolicyT> selector;
    return selector(aModule, aName, mVMPolicy);
  }

 protected:
  VMPolicy mVMPolicy;
};

}  // namespace interceptor
}  // namespace mozilla

#endif  // mozilla_interceptor_PatcherBase_h
