/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/plugins/PluginProcessChild.h"

#include "ClearOnShutdown.h"
#include "base/command_line.h"
#include "base/string_util.h"
#include "mozilla/AbstractThread.h"
#include "mozilla/ipc/IOThreadChild.h"
#include "nsDebugImpl.h"
#include "nsThreadManager.h"
#include "prlink.h"

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
#  include "mozilla/SandboxSettings.h"
#endif

#if defined(XP_MACOSX)
#  include "nsCocoaFeatures.h"
// An undocumented CoreGraphics framework method, present in the same form
// since at least OS X 10.5.
extern "C" CGError CGSSetDebugOptions(int options);
#endif

#ifdef XP_WIN
#  if defined(MOZ_SANDBOX)
#    include "mozilla/sandboxTarget.h"
#    include "ProcessUtils.h"
#    include "nsDirectoryService.h"
#  endif
#endif

using mozilla::ipc::IOThreadChild;

#ifdef OS_WIN
#  include <algorithm>
#endif

namespace mozilla {
namespace plugins {

#if defined(XP_WIN) && defined(MOZ_SANDBOX)
static void SetSandboxTempPath(const std::wstring& aFullTmpPath) {
  // Save the TMP environment variable so that is is picked up by GetTempPath().
  // Note that we specifically write to the TMP variable, as that is the first
  // variable that is checked by GetTempPath() to determine its output.
  Unused << NS_WARN_IF(!SetEnvironmentVariableW(L"TMP", aFullTmpPath.c_str()));

  // We also set TEMP in case there is naughty third-party code that is
  // referencing the environment variable directly.
  Unused << NS_WARN_IF(!SetEnvironmentVariableW(L"TEMP", aFullTmpPath.c_str()));
}
#endif

bool PluginProcessChild::Init(int aArgc, char* aArgv[]) {
  nsDebugImpl::SetMultiprocessMode("NPAPI");

#if defined(XP_MACOSX)
  // Remove the trigger for "dyld interposing" that we added in
  // GeckoChildProcessHost::PerformAsyncLaunch(), in the host
  // process just before we were launched.  Dyld interposing will still
  // happen in our process (the plugin child process).  But we don't want
  // it to happen in any processes that the plugin might launch from our
  // process.
  nsCString interpose(PR_GetEnv("DYLD_INSERT_LIBRARIES"));
  if (!interpose.IsEmpty()) {
    // If we added the path to libplugin_child_interpose.dylib to an
    // existing DYLD_INSERT_LIBRARIES, we appended it to the end, after a
    // ":" path seperator.
    int32_t lastSeparatorPos = interpose.RFind(":");
    int32_t lastTriggerPos = interpose.RFind("libplugin_child_interpose.dylib");
    bool needsReset = false;
    if (lastTriggerPos != -1) {
      if (lastSeparatorPos == -1) {
        interpose.Truncate();
        needsReset = true;
      } else if (lastTriggerPos > lastSeparatorPos) {
        interpose.SetLength(lastSeparatorPos);
        needsReset = true;
      }
    }
    if (needsReset) {
      nsCString setInterpose("DYLD_INSERT_LIBRARIES=");
      if (!interpose.IsEmpty()) {
        setInterpose.Append(interpose);
      }
      // Values passed to PR_SetEnv() must be seperately allocated.
      char* setInterposePtr = strdup(setInterpose.get());
      PR_SetEnv(setInterposePtr);
    }
  }
#endif

  // Certain plugins, such as flash, steal the unhandled exception filter
  // thus we never get crash reports when they fault. This call fixes it.
  message_loop()->set_exception_restoration(true);

  std::string pluginFilename;

#if defined(OS_POSIX)
  // NB: need to be very careful in ensuring that the first arg
  // (after the binary name) here is indeed the plugin module path.
  // Keep in sync with dom/plugins/PluginModuleParent.
  std::vector<std::string> values = CommandLine::ForCurrentProcess()->argv();
  MOZ_ASSERT(values.size() >= 2, "not enough args");

  pluginFilename = UnmungePluginDsoPath(values[1]);

#  if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
  int level;
  if (values.size() >= 4 && values[2] == "-flashSandboxLevel" &&
      (level = std::stoi(values[3], nullptr)) > 0) {
    level = ClampFlashSandboxLevel(level);
    MOZ_ASSERT(level > 0);

    bool enableLogging = false;
    if (values.size() >= 5 && values[4] == "-flashSandboxLogging") {
      enableLogging = true;
    }

    mPlugin.EnableFlashSandbox(level, enableLogging);
  }
#  endif

#elif defined(OS_WIN)
  std::vector<std::wstring> values =
      CommandLine::ForCurrentProcess()->GetLooseValues();
  MOZ_ASSERT(values.size() >= 1, "not enough loose args");

  // parameters are:
  // values[0] is path to plugin DLL
  // values[1] is path to folder that should be used for temp files
  // values[2] is path to the Flash Player roaming folder
  //   (this is always that Flash folder, regardless of what plugin is being
  //   run)
  pluginFilename = WideToUTF8(values[0]);

  // We don't initialize XPCOM but we need the thread manager and the
  // logging framework for the FunctionBroker.
  NS_SetMainThread();
  mozilla::TimeStamp::Startup();
  NS_LogInit();
  mozilla::LogModule::Init(aArgc, aArgv);
  nsThreadManager::get().Init();

#  if defined(MOZ_SANDBOX)
  MOZ_ASSERT(values.size() >= 3,
             "not enough loose args for sandboxed plugin process");

  // The sandbox closes off the default location temp file location so we set
  // a new one here (regardless of whether or not we are sandboxing).
  SetSandboxTempPath(values[1]);
  PluginModuleChild::SetFlashRoamingPath(values[2]);

  // This is probably the earliest we would want to start the sandbox.
  // As we attempt to tighten the sandbox, we may need to consider moving this
  // to later in the plugin initialization.
  mozilla::SandboxTarget::Instance()->StartSandbox();
#  endif
#else
#  error Sorry
#endif

  bool retval = mPlugin.InitForChrome(pluginFilename, ParentPid(),
                                      IOThreadChild::message_loop(),
                                      IOThreadChild::TakeChannel());
#if defined(XP_MACOSX)
  if (nsCocoaFeatures::OnYosemiteOrLater()) {
    // Explicitly turn off CGEvent logging.  This works around bug 1092855.
    // If there are already CGEvents in the log, turning off logging also
    // causes those events to be written to disk.  But at this point no
    // CGEvents have yet been processed.  CGEvents are events (usually
    // input events) pulled from the WindowServer.  An option of 0x80000008
    // turns on CGEvent logging.
    CGSSetDebugOptions(0x80000007);
  }
#endif
  return retval;
}

void PluginProcessChild::CleanUp() {
#if defined(OS_WIN)
  MOZ_ASSERT(NS_IsMainThread());

  // Shutdown components we started in Init.  Note that KillClearOnShutdown
  // is an event that is regularly part of XPCOM shutdown.  We do not
  // call XPCOM's shutdown but we need this event to be sent to avoid
  // leaking objects labeled as ClearOnShutdown.
  nsThreadManager::get().Shutdown();
  NS_LogTerm();
#endif

  mozilla::KillClearOnShutdown(ShutdownPhase::ShutdownFinal);
  AbstractThread::ShutdownMainThread();
}

}  // namespace plugins
}  // namespace mozilla
