/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <sys/utsname.h>
#include "nsCRTGlue.h"
#include "prenv.h"

#include "GfxInfoX11.h"

#ifdef MOZ_CRASHREPORTER
#include "nsExceptionHandler.h"
#include "nsICrashReporter.h"
#endif

namespace mozilla {
namespace widget {

#ifdef DEBUG
NS_IMPL_ISUPPORTS_INHERITED(GfxInfo, GfxInfoBase, nsIGfxInfoDebug)
#endif

// these global variables will be set when firing the glxtest process
int glxtest_pipe = 0;
pid_t glxtest_pid = 0;

nsresult
GfxInfo::Init()
{
    mGLMajorVersion = 0;
    mMajorVersion = 0;
    mMinorVersion = 0;
    mRevisionVersion = 0;
    mIsMesa = false;
    mIsNVIDIA = false;
    mIsFGLRX = false;
    mIsNouveau = false;
    mIsIntel = false;
    mIsOldSwrast = false;
    mIsLlvmpipe = false;
    mHasTextureFromPixmap = false;
    return GfxInfoBase::Init();
}

void
GfxInfo::GetData()
{
    // to understand this function, see bug 639842. We retrieve the OpenGL driver information in a
    // separate process to protect against bad drivers.

    // if glxtest_pipe == 0, that means that we already read the information
    if (!glxtest_pipe)
        return;

    enum { buf_size = 1024 };
    char buf[buf_size];
    ssize_t bytesread = read(glxtest_pipe,
                             &buf,
                             buf_size-1); // -1 because we'll append a zero
    close(glxtest_pipe);
    glxtest_pipe = 0;

    // bytesread < 0 would mean that the above read() call failed.
    // This should never happen. If it did, the outcome would be to blacklist anyway.
    if (bytesread < 0)
        bytesread = 0;

    // let buf be a zero-terminated string
    buf[bytesread] = 0;

    // Wait for the glxtest process to finish. This serves 2 purposes:
    // * avoid having a zombie glxtest process laying around
    // * get the glxtest process status info.
    int glxtest_status = 0;
    bool wait_for_glxtest_process = true;
    bool waiting_for_glxtest_process_failed = false;
    int waitpid_errno = 0;
    while(wait_for_glxtest_process) {
        wait_for_glxtest_process = false;
        if (waitpid(glxtest_pid, &glxtest_status, 0) == -1) {
            waitpid_errno = errno;
            if (waitpid_errno == EINTR) {
                wait_for_glxtest_process = true;
            } else {
                // Bug 718629
                // ECHILD happens when the glxtest process got reaped got reaped after a PR_CreateProcess
                // as per bug 227246. This shouldn't matter, as we still seem to get the data
                // from the pipe, and if we didn't, the outcome would be to blacklist anyway.
                waiting_for_glxtest_process_failed = (waitpid_errno != ECHILD);
            }
        }
    }

    bool exited_with_error_code = !waiting_for_glxtest_process_failed &&
                                  WIFEXITED(glxtest_status) && 
                                  WEXITSTATUS(glxtest_status) != EXIT_SUCCESS;
    bool received_signal = !waiting_for_glxtest_process_failed &&
                           WIFSIGNALED(glxtest_status);

    bool error = waiting_for_glxtest_process_failed || exited_with_error_code || received_signal;

    nsCString textureFromPixmap; 
    nsCString *stringToFill = nullptr;
    char *bufptr = buf;
    if (!error) {
        while(true) {
            char *line = NS_strtok("\n", &bufptr);
            if (!line)
                break;
            if (stringToFill) {
                stringToFill->Assign(line);
                stringToFill = nullptr;
            }
            else if(!strcmp(line, "VENDOR"))
                stringToFill = &mVendor;
            else if(!strcmp(line, "RENDERER"))
                stringToFill = &mRenderer;
            else if(!strcmp(line, "VERSION"))
                stringToFill = &mVersion;
            else if(!strcmp(line, "TFP"))
                stringToFill = &textureFromPixmap;
        }
    }

    if (!strcmp(textureFromPixmap.get(), "TRUE"))
        mHasTextureFromPixmap = true;

    // only useful for Linux kernel version check for FGLRX driver.
    // assumes X client == X server, which is sad.
    struct utsname unameobj;
    if (uname(&unameobj) >= 0)
    {
      mOS.Assign(unameobj.sysname);
      mOSRelease.Assign(unameobj.release);
    }

    const char *spoofedVendor = PR_GetEnv("MOZ_GFX_SPOOF_GL_VENDOR");
    if (spoofedVendor)
        mVendor.Assign(spoofedVendor);
    const char *spoofedRenderer = PR_GetEnv("MOZ_GFX_SPOOF_GL_RENDERER");
    if (spoofedRenderer)
        mRenderer.Assign(spoofedRenderer);
    const char *spoofedVersion = PR_GetEnv("MOZ_GFX_SPOOF_GL_VERSION");
    if (spoofedVersion)
        mVersion.Assign(spoofedVersion);
    const char *spoofedOS = PR_GetEnv("MOZ_GFX_SPOOF_OS");
    if (spoofedOS)
        mOS.Assign(spoofedOS);
    const char *spoofedOSRelease = PR_GetEnv("MOZ_GFX_SPOOF_OS_RELEASE");
    if (spoofedOSRelease)
        mOSRelease.Assign(spoofedOSRelease);

    if (error ||
        mVendor.IsEmpty() ||
        mRenderer.IsEmpty() ||
        mVersion.IsEmpty() ||
        mOS.IsEmpty() ||
        mOSRelease.IsEmpty())
    {
        mAdapterDescription.AppendLiteral("GLXtest process failed");
        if (waiting_for_glxtest_process_failed)
            mAdapterDescription.AppendPrintf(" (waitpid failed with errno=%d for pid %d)", waitpid_errno, glxtest_pid);
        if (exited_with_error_code)
            mAdapterDescription.AppendPrintf(" (exited with status %d)", WEXITSTATUS(glxtest_status));
        if (received_signal)
            mAdapterDescription.AppendPrintf(" (received signal %d)", WTERMSIG(glxtest_status));
        if (bytesread) {
            mAdapterDescription.AppendLiteral(": ");
            mAdapterDescription.Append(nsDependentCString(buf));
            mAdapterDescription.Append('\n');
        }
#ifdef MOZ_CRASHREPORTER
        CrashReporter::AppendAppNotesToCrashReport(mAdapterDescription);
#endif
        return;
    }

    mAdapterDescription.Append(mVendor);
    mAdapterDescription.AppendLiteral(" -- ");
    mAdapterDescription.Append(mRenderer);

    nsAutoCString note;
    note.AppendLiteral("OpenGL: ");
    note.Append(mAdapterDescription);
    note.AppendLiteral(" -- ");
    note.Append(mVersion);
    if (mHasTextureFromPixmap)
        note.AppendLiteral(" -- texture_from_pixmap");
    note.Append('\n');
#ifdef MOZ_CRASHREPORTER
    CrashReporter::AppendAppNotesToCrashReport(note);
#endif

    // determine the major OpenGL version. That's the first integer in the version string.
    mGLMajorVersion = strtol(mVersion.get(), 0, 10);

    // determine driver type (vendor) and where in the version string
    // the actual driver version numbers should be expected to be found (whereToReadVersionNumbers)
    const char *whereToReadVersionNumbers = nullptr;
    const char *Mesa_in_version_string = strstr(mVersion.get(), "Mesa");
    if (Mesa_in_version_string) {
        mIsMesa = true;
        // with Mesa, the version string contains "Mesa major.minor" and that's all the version information we get:
        // there is no actual driver version info.
        whereToReadVersionNumbers = Mesa_in_version_string + strlen("Mesa");
        if (strcasestr(mVendor.get(), "nouveau"))
            mIsNouveau = true;
        if (strcasestr(mRenderer.get(), "intel")) // yes, intel is in the renderer string
            mIsIntel = true;
        if (strcasestr(mRenderer.get(), "llvmpipe"))
            mIsLlvmpipe = true;
        if (strcasestr(mRenderer.get(), "software rasterizer"))
            mIsOldSwrast = true;
    } else if (strstr(mVendor.get(), "NVIDIA Corporation")) {
        mIsNVIDIA = true;
        // with the NVIDIA driver, the version string contains "NVIDIA major.minor"
        // note that here the vendor and version strings behave differently, that's why we don't put this above
        // alongside Mesa_in_version_string.
        const char *NVIDIA_in_version_string = strstr(mVersion.get(), "NVIDIA");
        if (NVIDIA_in_version_string)
            whereToReadVersionNumbers = NVIDIA_in_version_string + strlen("NVIDIA");
    } else if (strstr(mVendor.get(), "ATI Technologies Inc")) {
        mIsFGLRX = true;
        // with the FGLRX driver, the version string only gives a OpenGL version :/ so let's return that.
        // that can at least give a rough idea of how old the driver is.
        whereToReadVersionNumbers = mVersion.get();
    }

    // read major.minor version numbers of the driver (not to be confused with the OpenGL version)
    if (whereToReadVersionNumbers) {
        // copy into writable buffer, for tokenization
        strncpy(buf, whereToReadVersionNumbers, buf_size);
        bufptr = buf;

        // now try to read major.minor version numbers. In case of failure, gracefully exit: these numbers have
        // been initialized as 0 anyways
        char *token = NS_strtok(".", &bufptr);
        if (token) {
            mMajorVersion = strtol(token, 0, 10);
            token = NS_strtok(".", &bufptr);
            if (token) {
                mMinorVersion = strtol(token, 0, 10);
                token = NS_strtok(".", &bufptr);
                if (token)
                    mRevisionVersion = strtol(token, 0, 10);
            }
        }
    }
}

static inline uint64_t version(uint32_t major, uint32_t minor, uint32_t revision = 0)
{
    return (uint64_t(major) << 32) + (uint64_t(minor) << 16) + uint64_t(revision);
}

const nsTArray<GfxDriverInfo>&
GfxInfo::GetGfxDriverInfo()
{
  // Nothing here yet.
  //if (!mDriverInfo->Length()) {
  //
  //}
  return *mDriverInfo;
}

nsresult
GfxInfo::GetFeatureStatusImpl(int32_t aFeature,
                              int32_t *aStatus,
                              nsAString & aSuggestedDriverVersion,
                              const nsTArray<GfxDriverInfo>& aDriverInfo,
                              nsACString& aFailureId,
                              OperatingSystem* aOS /* = nullptr */)

{
  GetData();

  NS_ENSURE_ARG_POINTER(aStatus);
  *aStatus = nsIGfxInfo::FEATURE_STATUS_UNKNOWN;
  aSuggestedDriverVersion.SetIsVoid(true);
  OperatingSystem os = OperatingSystem::Linux;
  if (aOS)
    *aOS = os;

  if (mGLMajorVersion == 1) {
    // We're on OpenGL 1. In most cases that indicates really old hardware.
    // We better block them, rather than rely on them to fail gracefully, because they don't!
    // see bug 696636
    *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DEVICE;
    aFailureId = "FEATURE_FAILURE_OPENGL_1";
    return NS_OK;
  }

  // Don't evaluate any special cases if we're checking the downloaded blocklist.
  if (!aDriverInfo.Length()) {
    // Blacklist software GL implementations from using layers acceleration.
    // On the test infrastructure, we'll force-enable layers acceleration.
    if (aFeature == nsIGfxInfo::FEATURE_OPENGL_LAYERS &&
        (mIsLlvmpipe || mIsOldSwrast) &&
        !PR_GetEnv("MOZ_LAYERS_ALLOW_SOFTWARE_GL"))
    {
      *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DEVICE;
      aFailureId = "FEATURE_FAILURE_SOFTWARE_GL";
      return NS_OK;
    }

    // Only check features relevant to Linux.
    if (aFeature == nsIGfxInfo::FEATURE_OPENGL_LAYERS ||
        aFeature == nsIGfxInfo::FEATURE_WEBGL_OPENGL ||
        aFeature == nsIGfxInfo::FEATURE_WEBGL_MSAA) {

      // whitelist the linux test slaves' current configuration.
      // this is necessary as they're still using the slightly outdated 190.42 driver.
      // this isn't a huge risk, as at least this is the exact setting in which we do continuous testing,
      // and this only affects GeForce 9400 cards on linux on this precise driver version, which is very few users.
      // We do the same thing on Windows XP, see in widget/windows/GfxInfo.cpp
      if (mIsNVIDIA &&
          !strcmp(mRenderer.get(), "GeForce 9400/PCI/SSE2") &&
          !strcmp(mVersion.get(), "3.2.0 NVIDIA 190.42"))
      {
        *aStatus = nsIGfxInfo::FEATURE_STATUS_OK;
        return NS_OK;
      }

      if (mIsMesa) {
        if (mIsNouveau && version(mMajorVersion, mMinorVersion) < version(8,0)) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_MESA_1";
          aSuggestedDriverVersion.AssignLiteral("Mesa 8.0");
        }
        else if (version(mMajorVersion, mMinorVersion, mRevisionVersion) < version(7,10,3)) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_MESA_2";
          aSuggestedDriverVersion.AssignLiteral("Mesa 7.10.3");
        }
        else if (mIsOldSwrast) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_SW_RAST";
        }
        else if (mIsLlvmpipe && version(mMajorVersion, mMinorVersion) < version(9, 1)) {
          // bug 791905, Mesa bug 57733, fixed in Mesa 9.1 according to
          // https://bugs.freedesktop.org/show_bug.cgi?id=57733#c3
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_MESA_3";
        }
        else if (aFeature == nsIGfxInfo::FEATURE_WEBGL_MSAA)
        {
          if (mIsIntel && version(mMajorVersion, mMinorVersion) < version(8,1)) {
            *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
            aFailureId = "FEATURE_FAILURE_MESA_4";
            aSuggestedDriverVersion.AssignLiteral("Mesa 8.1");
          }
        }

      } else if (mIsNVIDIA) {
        if (version(mMajorVersion, mMinorVersion, mRevisionVersion) < version(257,21)) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_OLD_NV";
          aSuggestedDriverVersion.AssignLiteral("NVIDIA 257.21");
        }
      } else if (mIsFGLRX) {
        // FGLRX does not report a driver version number, so we have the OpenGL version instead.
        // by requiring OpenGL 3, we effectively require recent drivers.
        if (version(mMajorVersion, mMinorVersion, mRevisionVersion) < version(3, 0)) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DRIVER_VERSION;
          aFailureId = "FEATURE_FAILURE_OLD_FGLRX";
          aSuggestedDriverVersion.AssignLiteral("<Something recent>");
        }
        // Bug 724640: FGLRX + Linux 2.6.32 is a crashy combo
        bool unknownOS = mOS.IsEmpty() || mOSRelease.IsEmpty();
        bool badOS = mOS.Find("Linux", true) != -1 &&
                     mOSRelease.Find("2.6.32") != -1;
        if (unknownOS || badOS) {
          *aStatus = nsIGfxInfo::FEATURE_BLOCKED_OS_VERSION;
          aFailureId = "FEATURE_FAILURE_OLD_OS";
        }
      } else {
        // like on windows, let's block unknown vendors. Think of virtual machines.
        // Also, this case is hit whenever the GLXtest probe failed to get driver info or crashed.
        *aStatus = nsIGfxInfo::FEATURE_BLOCKED_DEVICE;
      }
    }
  }

  return GfxInfoBase::GetFeatureStatusImpl(aFeature, aStatus, aSuggestedDriverVersion, aDriverInfo, aFailureId, &os);
}


NS_IMETHODIMP
GfxInfo::GetD2DEnabled(bool *aEnabled)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetDWriteEnabled(bool *aEnabled)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetDWriteVersion(nsAString & aDwriteVersion)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetCleartypeParameters(nsAString & aCleartypeParams)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDescription(nsAString & aAdapterDescription)
{
  GetData();
  AppendASCIItoUTF16(mAdapterDescription, aAdapterDescription);
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDescription2(nsAString & aAdapterDescription)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterRAM(nsAString & aAdapterRAM)
{
  aAdapterRAM.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterRAM2(nsAString & aAdapterRAM)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriver(nsAString & aAdapterDriver)
{
  aAdapterDriver.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriver2(nsAString & aAdapterDriver)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriverVersion(nsAString & aAdapterDriverVersion)
{
  GetData();
  CopyASCIItoUTF16(mVersion, aAdapterDriverVersion);
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriverVersion2(nsAString & aAdapterDriverVersion)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriverDate(nsAString & aAdapterDriverDate)
{
  aAdapterDriverDate.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDriverDate2(nsAString & aAdapterDriverDate)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterVendorID(nsAString & aAdapterVendorID)
{
  GetData();
  CopyUTF8toUTF16(mVendor, aAdapterVendorID);
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterVendorID2(nsAString & aAdapterVendorID)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDeviceID(nsAString & aAdapterDeviceID)
{
  GetData();
  CopyUTF8toUTF16(mRenderer, aAdapterDeviceID);
  return NS_OK;
}

NS_IMETHODIMP
GfxInfo::GetAdapterDeviceID2(nsAString & aAdapterDeviceID)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterSubsysID(nsAString & aAdapterSubsysID)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetAdapterSubsysID2(nsAString & aAdapterSubsysID)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
GfxInfo::GetIsGPU2Active(bool* aIsGPU2Active)
{
  return NS_ERROR_FAILURE;
}

#ifdef DEBUG

// Implement nsIGfxInfoDebug
// We don't support spoofing anything on Linux

NS_IMETHODIMP GfxInfo::SpoofVendorID(const nsAString & aVendorID)
{
  CopyUTF16toUTF8(aVendorID, mVendor);
  return NS_OK;
}

NS_IMETHODIMP GfxInfo::SpoofDeviceID(const nsAString & aDeviceID)
{
  CopyUTF16toUTF8(aDeviceID, mRenderer);
  return NS_OK;
}

NS_IMETHODIMP GfxInfo::SpoofDriverVersion(const nsAString & aDriverVersion)
{
  CopyUTF16toUTF8(aDriverVersion, mVersion);
  return NS_OK;
}

NS_IMETHODIMP GfxInfo::SpoofOSVersion(uint32_t aVersion)
{
  // We don't support OS versioning on Linux. There's just "Linux".
  return NS_OK;
}

#endif

} // end namespace widget
} // end namespace mozilla
