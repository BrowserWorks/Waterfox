/* vim: se cin sw=2 ts=2 et : */
/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __mozilla_widget_GfxInfo_h__
#define __mozilla_widget_GfxInfo_h__

#include "GfxInfoBase.h"

namespace mozilla {
namespace widget {

class GfxInfo : public GfxInfoBase {
  ~GfxInfo() {}

 public:
  GfxInfo();

  // We only declare the subset of nsIGfxInfo that we actually implement. The
  // rest is brought forward from GfxInfoBase.
  NS_IMETHOD GetD2DEnabled(bool* aD2DEnabled) override;
  NS_IMETHOD GetDWriteEnabled(bool* aDWriteEnabled) override;
  NS_IMETHOD GetDWriteVersion(nsAString& aDwriteVersion) override;
  NS_IMETHOD GetHasBattery(bool* aHasBattery) override;
  NS_IMETHOD GetCleartypeParameters(nsAString& aCleartypeParams) override;
  NS_IMETHOD GetWindowProtocol(nsAString& aWindowProtocol) override;
  NS_IMETHOD GetDesktopEnvironment(nsAString& aDesktopEnvironment) override;
  NS_IMETHOD GetAdapterDescription(nsAString& aAdapterDescription) override;
  NS_IMETHOD GetAdapterDriver(nsAString& aAdapterDriver) override;
  NS_IMETHOD GetAdapterVendorID(nsAString& aAdapterVendorID) override;
  NS_IMETHOD GetAdapterDeviceID(nsAString& aAdapterDeviceID) override;
  NS_IMETHOD GetAdapterSubsysID(nsAString& aAdapterSubsysID) override;
  NS_IMETHOD GetAdapterRAM(uint32_t* aAdapterRAM) override;
  NS_IMETHOD GetAdapterDriverVendor(nsAString& aAdapterDriverVendor) override;
  NS_IMETHOD GetAdapterDriverVersion(nsAString& aAdapterDriverVersion) override;
  NS_IMETHOD GetAdapterDriverDate(nsAString& aAdapterDriverDate) override;
  NS_IMETHOD GetAdapterDescription2(nsAString& aAdapterDescription) override;
  NS_IMETHOD GetAdapterDriver2(nsAString& aAdapterDriver) override;
  NS_IMETHOD GetAdapterVendorID2(nsAString& aAdapterVendorID) override;
  NS_IMETHOD GetAdapterDeviceID2(nsAString& aAdapterDeviceID) override;
  NS_IMETHOD GetAdapterSubsysID2(nsAString& aAdapterSubsysID) override;
  NS_IMETHOD GetAdapterRAM2(uint32_t* aAdapterRAM) override;
  NS_IMETHOD GetAdapterDriverVendor2(nsAString& aAdapterDriverVendor) override;
  NS_IMETHOD GetAdapterDriverVersion2(
      nsAString& aAdapterDriverVersion) override;
  NS_IMETHOD GetAdapterDriverDate2(nsAString& aAdapterDriverDate) override;
  NS_IMETHOD GetIsGPU2Active(bool* aIsGPU2Active) override;
  NS_IMETHOD GetDisplayInfo(nsTArray<nsString>& aDisplayInfo) override;
  NS_IMETHOD GetDisplayWidth(nsTArray<uint32_t>& aDisplayWidth) override;
  NS_IMETHOD GetDisplayHeight(nsTArray<uint32_t>& aDisplayHeight) override;
  using GfxInfoBase::GetFeatureStatus;
  using GfxInfoBase::GetFeatureSuggestedDriverVersion;

  nsresult Init() override;
  NS_IMETHOD_(int32_t) GetMaxRefreshRate() override;

  uint32_t OperatingSystemVersion() override { return mWindowsVersion; }
  uint32_t OperatingSystemBuild() override { return mWindowsBuildNumber; }

  nsresult FindMonitors(JSContext* cx, JS::HandleObject array) override;

#ifdef DEBUG
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIGFXINFODEBUG
#endif

 protected:
  virtual nsresult GetFeatureStatusImpl(
      int32_t aFeature, int32_t* aStatus, nsAString& aSuggestedDriverVersion,
      const nsTArray<GfxDriverInfo>& aDriverInfo, nsACString& aFailureId,
      OperatingSystem* aOS = nullptr) override;
  virtual const nsTArray<GfxDriverInfo>& GetGfxDriverInfo() override;

  void DescribeFeatures(JSContext* cx, JS::Handle<JSObject*> aOut) override;

 private:
  struct DisplayInfo {
    uint32_t mScreenWidth;
    uint32_t mScreenHeight;
    uint32_t mRefreshRate;
    bool mIsPseudoDisplay;
  };

 private:
  void AddCrashReportAnnotations();

  nsString mDeviceString[2];
  nsString mDeviceID[2];
  nsString mDriverVersion[2];
  nsString mDriverDate[2];
  nsString mDeviceKey[2];
  nsString mDeviceKeyDebug;
  nsString mAdapterVendorID[2];
  nsString mAdapterDeviceID[2];
  nsString mAdapterSubsysID[2];
  uint32_t mWindowsVersion;
  uint32_t mWindowsBuildNumber;
  uint32_t mActiveGPUIndex;  // This must be 0 or 1
  nsTArray<DisplayInfo> mDisplayInfo;
  bool mHasDualGPU;
  bool mHasDriverVersionMismatch;
  bool mHasBattery;
};

}  // namespace widget
}  // namespace mozilla

#endif /* __mozilla_widget_GfxInfo_h__ */
