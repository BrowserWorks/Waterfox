// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/threading/thread_local_storage.h"

#include "base/atomicops.h"
#include "base/logging.h"
#include "base/synchronization/lock.h"
#include "build/build_config.h"

using base::internal::PlatformThreadLocalStorage;

// Chrome Thread Local Storage (TLS)
//
// This TLS system allows Chrome to use a single OS level TLS slot process-wide,
// and allows us to control the slot limits instead of being at the mercy of the
// platform. To do this, Chrome TLS replicates an array commonly found in the OS
// thread metadata.
//
// Overview:
//
// OS TLS Slots       Per-Thread                 Per-Process Global
//     ...
//     []             Chrome TLS Array           Chrome TLS Metadata
//     [] ----------> [][][][][ ][][][][]        [][][][][ ][][][][]
//     []                      |                          |
//     ...                     V                          V
//                      Metadata Version           Slot Information
//                         Your Data!
//
// Using a single OS TLS slot, Chrome TLS allocates an array on demand for the
// lifetime of each thread that requests Chrome TLS data. Each per-thread TLS
// array matches the length of the per-process global metadata array.
//
// A per-process global TLS metadata array tracks information about each item in
// the per-thread array:
//   * Status: Tracks if the slot is allocated or free to assign.
//   * Destructor: An optional destructor to call on thread destruction for that
//                 specific slot.
//   * Version: Tracks the current version of the TLS slot. Each TLS slot
//              allocation is associated with a unique version number.
//
//              Most OS TLS APIs guarantee that a newly allocated TLS slot is
//              initialized to 0 for all threads. The Chrome TLS system provides
//              this guarantee by tracking the version for each TLS slot here
//              on each per-thread Chrome TLS array entry. Threads that access
//              a slot with a mismatched version will receive 0 as their value.
//              The metadata version is incremented when the client frees a
//              slot. The per-thread metadata version is updated when a client
//              writes to the slot. This scheme allows for constant time
//              invalidation and avoids the need to iterate through each Chrome
//              TLS array to mark the slot as zero.
//
// Just like an OS TLS API, clients of the Chrome TLS are responsible for
// managing any necessary lifetime of the data in their slots. The only
// convenience provided is automatic destruction when a thread ends. If a client
// frees a slot, that client is responsible for destroying the data in the slot.

namespace {
// In order to make TLS destructors work, we need to keep around a function
// pointer to the destructor for each slot. We keep this array of pointers in a
// global (static) array.
// We use the single OS-level TLS slot (giving us one pointer per thread) to
// hold a pointer to a per-thread array (table) of slots that we allocate to
// Chromium consumers.

// g_native_tls_key is the one native TLS that we use. It stores our table.
base::subtle::Atomic32 g_native_tls_key =
    PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES;

// The OS TLS slot has three states:
//   * kUninitialized: Any call to Slot::Get()/Set() will create the base
//     per-thread TLS state. On POSIX, kUninitialized must be 0.
//   * [Memory Address]: Raw pointer to the base per-thread TLS state.
//   * kDestroyed: The base per-thread TLS state has been freed.
//
// Final States:
//   * Windows: kDestroyed. Windows does not iterate through the OS TLS to clean
//     up the values.
//   * POSIX: kUninitialized. POSIX iterates through TLS until all slots contain
//     nullptr.
//
// More details on this design:
//   We need some type of thread-local state to indicate that the TLS system has
//   been destroyed. To do so, we leverage the multi-pass nature of destruction
//   of pthread_key.
//
//    a) After destruction of TLS system, we set the pthread_key to a sentinel
//       kDestroyed.
//    b) All calls to Slot::Get() DCHECK that the state is not kDestroyed, and
//       any system which might potentially invoke Slot::Get() after destruction
//       of TLS must check ThreadLocalStorage::ThreadIsBeingDestroyed().
//    c) After a full pass of the pthread_keys, on the next invocation of
//       ConstructTlsVector(), we'll then set the key to nullptr.
//    d) At this stage, the TLS system is back in its uninitialized state.
//    e) If in the second pass of destruction of pthread_keys something were to
//       re-initialize TLS [this should never happen! Since the only code which
//       uses Chrome TLS is Chrome controlled, we should really be striving for
//       single-pass destruction], then TLS will be re-initialized and then go
//       through the 2-pass destruction system again. Everything should just
//       work (TM).

// The consumers of kUninitialized and kDestroyed expect void*, since that's
// what the API exposes on both POSIX and Windows.
void* const kUninitialized = nullptr;

// A sentinel value to indicate that the TLS system has been destroyed.
void* const kDestroyed = reinterpret_cast<void*>(1);

// The maximum number of slots in our thread local storage stack.
constexpr int kThreadLocalStorageSize = 256;

enum TlsStatus {
  FREE,
  IN_USE,
};

struct TlsMetadata {
  TlsStatus status;
  base::ThreadLocalStorage::TLSDestructorFunc destructor;
  uint32_t version;
};

struct TlsVectorEntry {
  void* data;
  uint32_t version;
};

// This lock isn't needed until after we've constructed the per-thread TLS
// vector, so it's safe to use.
base::Lock* GetTLSMetadataLock() {
  static auto* lock = new base::Lock();
  return lock;
}
TlsMetadata g_tls_metadata[kThreadLocalStorageSize];
size_t g_last_assigned_slot = 0;

// The maximum number of times to try to clear slots by calling destructors.
// Use pthread naming convention for clarity.
constexpr int kMaxDestructorIterations = kThreadLocalStorageSize;

// This function is called to initialize our entire Chromium TLS system.
// It may be called very early, and we need to complete most all of the setup
// (initialization) before calling *any* memory allocator functions, which may
// recursively depend on this initialization.
// As a result, we use Atomics, and avoid anything (like a singleton) that might
// require memory allocations.
TlsVectorEntry* ConstructTlsVector() {
  PlatformThreadLocalStorage::TLSKey key =
      base::subtle::NoBarrier_Load(&g_native_tls_key);
  if (key == PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES) {
    CHECK(PlatformThreadLocalStorage::AllocTLS(&key));

    // The TLS_KEY_OUT_OF_INDEXES is used to find out whether the key is set or
    // not in NoBarrier_CompareAndSwap, but Posix doesn't have invalid key, we
    // define an almost impossible value be it.
    // If we really get TLS_KEY_OUT_OF_INDEXES as value of key, just alloc
    // another TLS slot.
    if (key == PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES) {
      PlatformThreadLocalStorage::TLSKey tmp = key;
      CHECK(PlatformThreadLocalStorage::AllocTLS(&key) &&
            key != PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES);
      PlatformThreadLocalStorage::FreeTLS(tmp);
    }
    // Atomically test-and-set the tls_key. If the key is
    // TLS_KEY_OUT_OF_INDEXES, go ahead and set it. Otherwise, do nothing, as
    // another thread already did our dirty work.
    if (PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES !=
        static_cast<PlatformThreadLocalStorage::TLSKey>(
            base::subtle::NoBarrier_CompareAndSwap(
                &g_native_tls_key,
                PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES, key))) {
      // We've been shortcut. Another thread replaced g_native_tls_key first so
      // we need to destroy our index and use the one the other thread got
      // first.
      PlatformThreadLocalStorage::FreeTLS(key);
      key = base::subtle::NoBarrier_Load(&g_native_tls_key);
    }
  }
  CHECK_EQ(PlatformThreadLocalStorage::GetTLSValue(key), kUninitialized);

  // Some allocators, such as TCMalloc, make use of thread local storage. As a
  // result, any attempt to call new (or malloc) will lazily cause such a system
  // to initialize, which will include registering for a TLS key. If we are not
  // careful here, then that request to create a key will call new back, and
  // we'll have an infinite loop. We avoid that as follows: Use a stack
  // allocated vector, so that we don't have dependence on our allocator until
  // our service is in place. (i.e., don't even call new until after we're
  // setup)
  TlsVectorEntry stack_allocated_tls_data[kThreadLocalStorageSize];
  memset(stack_allocated_tls_data, 0, sizeof(stack_allocated_tls_data));
  // Ensure that any rentrant calls change the temp version.
  PlatformThreadLocalStorage::SetTLSValue(key, stack_allocated_tls_data);

  // Allocate an array to store our data.
  TlsVectorEntry* tls_data = new TlsVectorEntry[kThreadLocalStorageSize];
  memcpy(tls_data, stack_allocated_tls_data, sizeof(stack_allocated_tls_data));
  PlatformThreadLocalStorage::SetTLSValue(key, tls_data);
  return tls_data;
}

void OnThreadExitInternal(TlsVectorEntry* tls_data) {
  // This branch is for POSIX, where this function is called twice. The first
  // pass calls dtors and sets state to kDestroyed. The second pass sets
  // kDestroyed to kUninitialized.
  if (tls_data == kDestroyed) {
    PlatformThreadLocalStorage::TLSKey key =
        base::subtle::NoBarrier_Load(&g_native_tls_key);
    PlatformThreadLocalStorage::SetTLSValue(key, kUninitialized);
    return;
  }

  DCHECK(tls_data);
  // Some allocators, such as TCMalloc, use TLS. As a result, when a thread
  // terminates, one of the destructor calls we make may be to shut down an
  // allocator. We have to be careful that after we've shutdown all of the known
  // destructors (perchance including an allocator), that we don't call the
  // allocator and cause it to resurrect itself (with no possibly destructor
  // call to follow). We handle this problem as follows: Switch to using a stack
  // allocated vector, so that we don't have dependence on our allocator after
  // we have called all g_tls_metadata destructors. (i.e., don't even call
  // delete[] after we're done with destructors.)
  TlsVectorEntry stack_allocated_tls_data[kThreadLocalStorageSize];
  memcpy(stack_allocated_tls_data, tls_data, sizeof(stack_allocated_tls_data));
  // Ensure that any re-entrant calls change the temp version.
  PlatformThreadLocalStorage::TLSKey key =
      base::subtle::NoBarrier_Load(&g_native_tls_key);
  PlatformThreadLocalStorage::SetTLSValue(key, stack_allocated_tls_data);
  delete[] tls_data;  // Our last dependence on an allocator.

  // Snapshot the TLS Metadata so we don't have to lock on every access.
  TlsMetadata tls_metadata[kThreadLocalStorageSize];
  {
    base::AutoLock auto_lock(*GetTLSMetadataLock());
    memcpy(tls_metadata, g_tls_metadata, sizeof(g_tls_metadata));
  }

  int remaining_attempts = kMaxDestructorIterations;
  bool need_to_scan_destructors = true;
  while (need_to_scan_destructors) {
    need_to_scan_destructors = false;
    // Try to destroy the first-created-slot (which is slot 1) in our last
    // destructor call. That user was able to function, and define a slot with
    // no other services running, so perhaps it is a basic service (like an
    // allocator) and should also be destroyed last. If we get the order wrong,
    // then we'll iterate several more times, so it is really not that critical
    // (but it might help).
    for (int slot = 0; slot < kThreadLocalStorageSize ; ++slot) {
      void* tls_value = stack_allocated_tls_data[slot].data;
      if (!tls_value || tls_metadata[slot].status == TlsStatus::FREE ||
          stack_allocated_tls_data[slot].version != tls_metadata[slot].version)
        continue;

      base::ThreadLocalStorage::TLSDestructorFunc destructor =
          tls_metadata[slot].destructor;
      if (!destructor)
        continue;
      stack_allocated_tls_data[slot].data = nullptr;  // pre-clear the slot.
      destructor(tls_value);
      // Any destructor might have called a different service, which then set a
      // different slot to a non-null value. Hence we need to check the whole
      // vector again. This is a pthread standard.
      need_to_scan_destructors = true;
    }
    if (--remaining_attempts <= 0) {
      NOTREACHED();  // Destructors might not have been called.
      break;
    }
  }

  // Remove our stack allocated vector.
  PlatformThreadLocalStorage::SetTLSValue(key, kDestroyed);
}

}  // namespace

namespace base {

namespace internal {

#if defined(OS_WIN)
void PlatformThreadLocalStorage::OnThreadExit() {
  PlatformThreadLocalStorage::TLSKey key =
      base::subtle::NoBarrier_Load(&g_native_tls_key);
  if (key == PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES)
    return;
  void *tls_data = GetTLSValue(key);

  // On Windows, thread destruction callbacks are only invoked once per module,
  // so there should be no way that this could be invoked twice.
  DCHECK_NE(tls_data, kDestroyed);

  // Maybe we have never initialized TLS for this thread.
  if (tls_data == kUninitialized)
    return;
  OnThreadExitInternal(static_cast<TlsVectorEntry*>(tls_data));
}
#elif defined(OS_POSIX) || defined(OS_FUCHSIA)
void PlatformThreadLocalStorage::OnThreadExit(void* value) {
  OnThreadExitInternal(static_cast<TlsVectorEntry*>(value));
}
#endif  // defined(OS_WIN)

}  // namespace internal

bool ThreadLocalStorage::HasBeenDestroyed() {
  PlatformThreadLocalStorage::TLSKey key =
      base::subtle::NoBarrier_Load(&g_native_tls_key);
  if (key == PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES)
    return false;
  return PlatformThreadLocalStorage::GetTLSValue(key) == kDestroyed;
}

void ThreadLocalStorage::Slot::Initialize(TLSDestructorFunc destructor) {
  PlatformThreadLocalStorage::TLSKey key =
      base::subtle::NoBarrier_Load(&g_native_tls_key);
  if (key == PlatformThreadLocalStorage::TLS_KEY_OUT_OF_INDEXES ||
      PlatformThreadLocalStorage::GetTLSValue(key) == kUninitialized) {
    ConstructTlsVector();
  }

  // Grab a new slot.
  {
    base::AutoLock auto_lock(*GetTLSMetadataLock());
    for (int i = 0; i < kThreadLocalStorageSize; ++i) {
      // Tracking the last assigned slot is an attempt to find the next
      // available slot within one iteration. Under normal usage, slots remain
      // in use for the lifetime of the process (otherwise before we reclaimed
      // slots, we would have run out of slots). This makes it highly likely the
      // next slot is going to be a free slot.
      size_t slot_candidate =
          (g_last_assigned_slot + 1 + i) % kThreadLocalStorageSize;
      if (g_tls_metadata[slot_candidate].status == TlsStatus::FREE) {
        g_tls_metadata[slot_candidate].status = TlsStatus::IN_USE;
        g_tls_metadata[slot_candidate].destructor = destructor;
        g_last_assigned_slot = slot_candidate;
        DCHECK_EQ(kInvalidSlotValue, slot_);
        slot_ = slot_candidate;
        version_ = g_tls_metadata[slot_candidate].version;
        break;
      }
    }
  }
  CHECK_NE(slot_, kInvalidSlotValue);
  CHECK_LT(slot_, kThreadLocalStorageSize);
}

void ThreadLocalStorage::Slot::Free() {
  DCHECK_NE(slot_, kInvalidSlotValue);
  DCHECK_LT(slot_, kThreadLocalStorageSize);
  {
    base::AutoLock auto_lock(*GetTLSMetadataLock());
    g_tls_metadata[slot_].status = TlsStatus::FREE;
    g_tls_metadata[slot_].destructor = nullptr;
    ++(g_tls_metadata[slot_].version);
  }
  slot_ = kInvalidSlotValue;
}

void* ThreadLocalStorage::Slot::Get() const {
  TlsVectorEntry* tls_data = static_cast<TlsVectorEntry*>(
      PlatformThreadLocalStorage::GetTLSValue(
          base::subtle::NoBarrier_Load(&g_native_tls_key)));
  DCHECK_NE(tls_data, kDestroyed);
  if (!tls_data)
    return nullptr;
  DCHECK_NE(slot_, kInvalidSlotValue);
  DCHECK_LT(slot_, kThreadLocalStorageSize);
  // Version mismatches means this slot was previously freed.
  if (tls_data[slot_].version != version_)
    return nullptr;
  return tls_data[slot_].data;
}

void ThreadLocalStorage::Slot::Set(void* value) {
  TlsVectorEntry* tls_data = static_cast<TlsVectorEntry*>(
      PlatformThreadLocalStorage::GetTLSValue(
          base::subtle::NoBarrier_Load(&g_native_tls_key)));
  DCHECK_NE(tls_data, kDestroyed);
  if (!tls_data) {
    if (!value)
      return;
    tls_data = ConstructTlsVector();
  }
  DCHECK_NE(slot_, kInvalidSlotValue);
  DCHECK_LT(slot_, kThreadLocalStorageSize);
  tls_data[slot_].data = value;
  tls_data[slot_].version = version_;
}

ThreadLocalStorage::Slot::Slot(TLSDestructorFunc destructor) {
  Initialize(destructor);
}

ThreadLocalStorage::Slot::~Slot() {
  Free();
}

}  // namespace base
