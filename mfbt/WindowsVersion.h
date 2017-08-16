/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_WindowsVersion_h
#define mozilla_WindowsVersion_h

#include "mozilla/Attributes.h"
#include <stdint.h>
#include <windows.h>

namespace mozilla {

inline bool
IsWindowsVersionOrLater(uint32_t aVersion)
{
  static uint32_t minVersion = 0;
  static uint32_t maxVersion = UINT32_MAX;

  if (minVersion >= aVersion) {
    return true;
  }

  if (aVersion >= maxVersion) {
    return false;
  }

  OSVERSIONINFOEX info;
  ZeroMemory(&info, sizeof(OSVERSIONINFOEX));
  info.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
  info.dwMajorVersion = aVersion >> 24;
  info.dwMinorVersion = (aVersion >> 16) & 0xFF;
  info.wServicePackMajor = (aVersion >> 8) & 0xFF;
  info.wServicePackMinor = aVersion & 0xFF;

  DWORDLONG conditionMask = 0;
  VER_SET_CONDITION(conditionMask, VER_MAJORVERSION, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_MINORVERSION, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_SERVICEPACKMINOR, VER_GREATER_EQUAL);

  if (VerifyVersionInfo(&info,
                        VER_MAJORVERSION | VER_MINORVERSION |
                        VER_SERVICEPACKMAJOR | VER_SERVICEPACKMINOR,
                        conditionMask)) {
    minVersion = aVersion;
    return true;
  }

  maxVersion = aVersion;
  return false;
}

inline bool
IsWindowsBuildOrLater(uint32_t aBuild)
{
  static uint32_t minBuild = 0;
  static uint32_t maxBuild = UINT32_MAX;

  if (minBuild >= aBuild) {
    return true;
  }

  if (aBuild >= maxBuild) {
    return false;
  }

  OSVERSIONINFOEX info;
  ZeroMemory(&info, sizeof(OSVERSIONINFOEX));
  info.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
  info.dwBuildNumber = aBuild;

  DWORDLONG conditionMask = 0;
  VER_SET_CONDITION(conditionMask, VER_BUILDNUMBER, VER_GREATER_EQUAL);

  if (VerifyVersionInfo(&info, VER_BUILDNUMBER, conditionMask)) {
    minBuild = aBuild;
    return true;
  }

  maxBuild = aBuild;
  return false;
}

inline bool
IsWindows10BuildOrLater(uint32_t aBuild)
{
  static uint32_t minBuild = 0;
  static uint32_t maxBuild = UINT32_MAX;

  if (minBuild >= aBuild) {
    return true;
  }

  if (aBuild >= maxBuild) {
    return false;
  }

  OSVERSIONINFOEX info;
  ZeroMemory(&info, sizeof(OSVERSIONINFOEX));
  info.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
  info.dwMajorVersion = 10;
  info.dwBuildNumber = aBuild;

  DWORDLONG conditionMask = 0;
  VER_SET_CONDITION(conditionMask, VER_MAJORVERSION, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_MINORVERSION, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_BUILDNUMBER, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL);
  VER_SET_CONDITION(conditionMask, VER_SERVICEPACKMINOR, VER_GREATER_EQUAL);

  if (VerifyVersionInfo(&info, VER_MAJORVERSION | VER_MINORVERSION |
                        VER_BUILDNUMBER | VER_SERVICEPACKMAJOR |
                        VER_SERVICEPACKMINOR, conditionMask)) {
    minBuild = aBuild;
    return true;
  }

  maxBuild = aBuild;
  return false;
}

MOZ_ALWAYS_INLINE bool
IsWin7SP1OrLater()
{
  return IsWindowsVersionOrLater(0x06010100ul);
}

MOZ_ALWAYS_INLINE bool
IsWin8OrLater()
{
  return IsWindowsVersionOrLater(0x06020000ul);
}

MOZ_ALWAYS_INLINE bool
IsWin8Point1OrLater()
{
  return IsWindowsVersionOrLater(0x06030000ul);
}

MOZ_ALWAYS_INLINE bool
IsWin10OrLater()
{
  return IsWindowsVersionOrLater(0x0a000000ul);
}

MOZ_ALWAYS_INLINE bool
IsWin10CreatorsUpdateOrLater()
{
  return IsWindows10BuildOrLater(15063);
}

MOZ_ALWAYS_INLINE bool
IsNotWin7PreRTM()
{
  return IsWin7SP1OrLater() || IsWindowsBuildOrLater(7600);
}

} // namespace mozilla

#endif /* mozilla_WindowsVersion_h */
