// Copyright (c) 2011 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/memory/ref_counted.h"

#include "base/threading/thread_collision_warner.h"

namespace base {
namespace {

#if DCHECK_IS_ON()
std::atomic_int g_cross_thread_ref_count_access_allow_count(0);
#endif

}  // namespace

namespace subtle {

bool RefCountedThreadSafeBase::HasOneRef() const {
  return ref_count_.IsOne();
}

bool RefCountedThreadSafeBase::HasAtLeastOneRef() const {
  return !ref_count_.IsZero();
}

#if DCHECK_IS_ON()
RefCountedThreadSafeBase::~RefCountedThreadSafeBase() {
  DCHECK(in_dtor_) << "RefCountedThreadSafe object deleted without "
                      "calling Release()";
}
#endif

// This is a security check. In 32-bit-archs, an attacker would run out of
// address space after allocating at most 2^32 scoped_refptrs. This replicates
// that boundary for 64-bit-archs.
#if defined(ARCH_CPU_64_BITS)
void RefCountedBase::AddRefImpl() const {
  // Check if |ref_count_| overflow only on 64 bit archs since the number of
  // objects may exceed 2^32.
  // To avoid the binary size bloat, use non-inline function here.
  CHECK(++ref_count_ > 0);
}
#endif

#if !defined(ARCH_CPU_X86_FAMILY)
bool RefCountedThreadSafeBase::Release() const {
  return ReleaseImpl();
}
void RefCountedThreadSafeBase::AddRef() const {
  AddRefImpl();
}
void RefCountedThreadSafeBase::AddRefWithCheck() const {
  AddRefWithCheckImpl();
}
#endif

#if DCHECK_IS_ON()
bool RefCountedBase::CalledOnValidSequence() const {
#if defined(MOZ_SANDBOX)
  return true;
#else
  return sequence_checker_.CalledOnValidSequence() ||
         g_cross_thread_ref_count_access_allow_count.load() != 0;
#endif
}
#endif

}  // namespace subtle

#if DCHECK_IS_ON()
ScopedAllowCrossThreadRefCountAccess::ScopedAllowCrossThreadRefCountAccess() {
  ++g_cross_thread_ref_count_access_allow_count;
}

ScopedAllowCrossThreadRefCountAccess::~ScopedAllowCrossThreadRefCountAccess() {
  --g_cross_thread_ref_count_access_allow_count;
}
#endif

}  // namespace base
