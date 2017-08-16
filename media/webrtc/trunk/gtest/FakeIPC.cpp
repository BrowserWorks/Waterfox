/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FakeIPC.h"

#ifdef WEBRTC_WIN
#include <Windows.h>
#else
#include <unistd.h>
#endif

// The implementations can't be in the .h file for some annoying reason

/* static */ void
PlatformThread:: YieldCurrentThread()
{
#ifdef WEBRTC_WIN
  Sleep(1);
#else
  sleep(1);
#endif
}

namespace base {

void AtExitManager::RegisterCallback(AtExitCallbackType func, void* param)
{
}

}

// see atomicops_internals_x86_gcc.h
// This cheats to get the unittests to build

struct AtomicOps_x86CPUFeatureStruct {
  bool field1;
  bool field2;
};

struct AtomicOps_x86CPUFeatureStruct AtomicOps_Internalx86CPUFeatures = {
  false,
  false,
};
