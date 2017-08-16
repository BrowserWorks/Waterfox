/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=2 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPProcessParent.h"
#include "GMPUtils.h"
#include "nsIFile.h"
#include "nsIRunnable.h"
#if defined(XP_WIN) && defined(MOZ_SANDBOX)
#include "WinUtils.h"
#endif
#include "GMPLog.h"

#include "base/string_util.h"
#include "base/process_util.h"

#include <string>

using std::vector;
using std::string;

using mozilla::gmp::GMPProcessParent;
using mozilla::ipc::GeckoChildProcessHost;
using base::ProcessArchitecture;

namespace mozilla {
namespace gmp {

GMPProcessParent::GMPProcessParent(const std::string& aGMPPath)
: GeckoChildProcessHost(GeckoProcessType_GMPlugin),
  mGMPPath(aGMPPath)
{
  MOZ_COUNT_CTOR(GMPProcessParent);
}

GMPProcessParent::~GMPProcessParent()
{
  MOZ_COUNT_DTOR(GMPProcessParent);
}

bool
GMPProcessParent::Launch(int32_t aTimeoutMs)
{
  vector<string> args;

#if defined(XP_WIN) && defined(MOZ_SANDBOX)
  std::wstring wGMPPath = UTF8ToWide(mGMPPath.c_str());

  // The sandbox doesn't allow file system rules where the paths contain
  // symbolic links or junction points. Sometimes the Users folder has been
  // moved to another drive using a junction point, so allow for this specific
  // case. See bug 1236680 for details.
  if (!widget::WinUtils::ResolveJunctionPointsAndSymLinks(wGMPPath)) {
    GMP_LOG("ResolveJunctionPointsAndSymLinks failed for GMP path=%S",
            wGMPPath.c_str());
    NS_WARNING("ResolveJunctionPointsAndSymLinks failed for GMP path.");
    return false;
  }
  GMP_LOG("GMPProcessParent::Launch() resolved path to %S", wGMPPath.c_str());

  // If the GMP path is a network path that is not mapped to a drive letter,
  // then we need to fix the path format for the sandbox rule.
  wchar_t volPath[MAX_PATH];
  if (::GetVolumePathNameW(wGMPPath.c_str(), volPath, MAX_PATH) &&
      ::GetDriveTypeW(volPath) == DRIVE_REMOTE &&
      wGMPPath.compare(0, 2, L"\\\\") == 0) {
    std::wstring sandboxGMPPath(wGMPPath);
    sandboxGMPPath.insert(1, L"??\\UNC");
    mAllowedFilesRead.push_back(sandboxGMPPath + L"\\*");
  } else {
    mAllowedFilesRead.push_back(wGMPPath + L"\\*");
  }

  args.push_back(WideToUTF8(wGMPPath));
#else
  args.push_back(mGMPPath);
#endif

  return SyncLaunch(args, aTimeoutMs, base::GetCurrentProcessArchitecture());
}

void
GMPProcessParent::Delete(nsCOMPtr<nsIRunnable> aCallback)
{
  mDeletedCallback = aCallback;
  XRE_GetIOMessageLoop()->PostTask(NewNonOwningRunnableMethod(this, &GMPProcessParent::DoDelete));
}

void
GMPProcessParent::DoDelete()
{
  MOZ_ASSERT(MessageLoop::current() == XRE_GetIOMessageLoop());
  Join();

  if (mDeletedCallback) {
    mDeletedCallback->Run();
  }

  delete this;
}

} // namespace gmp
} // namespace mozilla
