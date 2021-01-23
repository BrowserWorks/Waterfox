/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <sys/mman.h>  // mprotect
#include <unistd.h>    // sysconf

#include "mozilla/ipc/SharedMemory.h"

namespace mozilla {
namespace ipc {

void SharedMemory::SystemProtect(char* aAddr, size_t aSize, int aRights) {
  if (!SystemProtectFallible(aAddr, aSize, aRights)) {
    MOZ_CRASH("can't mprotect()");
  }
}

bool SharedMemory::SystemProtectFallible(char* aAddr, size_t aSize,
                                         int aRights) {
  int flags = 0;
  if (aRights & RightsRead) flags |= PROT_READ;
  if (aRights & RightsWrite) flags |= PROT_WRITE;
  if (RightsNone == aRights) flags = PROT_NONE;

  return 0 == mprotect(aAddr, aSize, flags);
}

size_t SharedMemory::SystemPageSize() { return sysconf(_SC_PAGESIZE); }

}  // namespace ipc
}  // namespace mozilla
