/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_SandboxInfo_h
#define mozilla_SandboxInfo_h

#include "mozilla/Types.h"

// Information on what parts of sandboxing are enabled in this build
// and/or supported by the system.

namespace mozilla {

class SandboxInfo {
public:
  // No need to prevent copying; this is essentially just a const int.
  SandboxInfo(const SandboxInfo& aOther) : mFlags(aOther.mFlags) { }

  // Flags are checked at initializer time; this returns them.
  static const SandboxInfo& Get() { return sSingleton; }

  enum Flags {
    // System call filtering; kernel config option CONFIG_SECCOMP_FILTER.
    kHasSeccompBPF     = 1 << 0,
    // Config flag MOZ_CONTENT_SANDBOX; env var MOZ_DISABLE_CONTENT_SANDBOX.
    kEnabledForContent = 1 << 1,
    // Config flag MOZ_GMP_SANDBOX; env var MOZ_DISABLE_GMP_SANDBOX.
    kEnabledForMedia   = 1 << 2,
    // Env var MOZ_SANDBOX_VERBOSE.
    kVerbose           = 1 << 3,
    // Kernel can atomically set system call filtering on entire thread group.
    kHasSeccompTSync   = 1 << 4,
    // Can this process create user namespaces? (Man page user_namespaces(7).)
    kHasUserNamespaces = 1 << 5,
    // Could a more privileged process have user namespaces, even if we can't?
    kHasPrivilegedUserNamespaces = 1 << 6,
    // Env var MOZ_PERMISSIVE_CONTENT_SANDBOX
    kPermissive        = 1 << 7,
    // Something is creating threads when we need to still be single-threaded.
    kUnexpectedThreads = 1 << 8,
  };

  bool Test(Flags aFlag) const { return (mFlags & aFlag) == aFlag; }

  // Returns true if SetContentProcessSandbox may be called.
  bool CanSandboxContent() const
  {
    return !Test(kEnabledForContent) || Test(kHasSeccompBPF);
  }

  // Returns true if SetMediaPluginSandbox may be called.
  bool CanSandboxMedia() const
  {
    return !Test(kEnabledForMedia) || Test(kHasSeccompBPF);
  }

  // For telemetry / crash annotation uses.
  uint32_t AsInteger() const {
    return mFlags;
  }

  // For bug 1222500 or anything else like it: On desktop, this is
  // called in the parent process at a point when it should still be
  // single-threaded, to check that the SandboxEarlyInit() call in a
  // child process is early enough to be single-threaded.  If not,
  // kUnexpectedThreads is set and affected flags (user namespaces;
  // possibly others in the future) are cleared.
  static MOZ_EXPORT void ThreadingCheck();
private:
  enum Flags mFlags;
  // This should be const, but has to allow for ThreadingCheck.
  static MOZ_EXPORT SandboxInfo sSingleton;
  SandboxInfo();
};

} // namespace mozilla

#endif // mozilla_SandboxInfo_h
