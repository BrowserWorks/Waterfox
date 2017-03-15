/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et ft=cpp : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "Hal.h"
#include "HalLog.h"
#include "mozilla/AppProcessChecker.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/hal_sandbox/PHalChild.h"
#include "mozilla/hal_sandbox/PHalParent.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/dom/TabChild.h"
#include "mozilla/dom/battery/Types.h"
#include "mozilla/dom/network/Types.h"
#include "mozilla/dom/ScreenOrientation.h"
#include "mozilla/Observer.h"
#include "mozilla/Unused.h"
#include "nsAutoPtr.h"
#include "WindowIdentifier.h"

using namespace mozilla;
using namespace mozilla::dom;
using namespace mozilla::hal;

namespace mozilla {
namespace hal_sandbox {

static bool sHalChildDestroyed = false;

bool
HalChildDestroyed()
{
  return sHalChildDestroyed;
}

static PHalChild* sHal;
static PHalChild*
Hal()
{
  if (!sHal) {
    sHal = ContentChild::GetSingleton()->SendPHalConstructor();
  }
  return sHal;
}

void
Vibrate(const nsTArray<uint32_t>& pattern, const WindowIdentifier &id)
{
  HAL_LOG("Vibrate: Sending to parent process.");

  AutoTArray<uint32_t, 8> p(pattern);

  WindowIdentifier newID(id);
  newID.AppendProcessID();
  Hal()->SendVibrate(p, newID.AsArray(), TabChild::GetFrom(newID.GetWindow()));
}

void
CancelVibrate(const WindowIdentifier &id)
{
  HAL_LOG("CancelVibrate: Sending to parent process.");

  WindowIdentifier newID(id);
  newID.AppendProcessID();
  Hal()->SendCancelVibrate(newID.AsArray(), TabChild::GetFrom(newID.GetWindow()));
}

void
EnableBatteryNotifications()
{
  Hal()->SendEnableBatteryNotifications();
}

void
DisableBatteryNotifications()
{
  Hal()->SendDisableBatteryNotifications();
}

void
GetCurrentBatteryInformation(BatteryInformation* aBatteryInfo)
{
  Hal()->SendGetCurrentBatteryInformation(aBatteryInfo);
}

void
EnableNetworkNotifications()
{
  Hal()->SendEnableNetworkNotifications();
}

void
DisableNetworkNotifications()
{
  Hal()->SendDisableNetworkNotifications();
}

void
GetCurrentNetworkInformation(NetworkInformation* aNetworkInfo)
{
  Hal()->SendGetCurrentNetworkInformation(aNetworkInfo);
}

void
EnableScreenConfigurationNotifications()
{
  Hal()->SendEnableScreenConfigurationNotifications();
}

void
DisableScreenConfigurationNotifications()
{
  Hal()->SendDisableScreenConfigurationNotifications();
}

void
GetCurrentScreenConfiguration(ScreenConfiguration* aScreenConfiguration)
{
  Hal()->SendGetCurrentScreenConfiguration(aScreenConfiguration);
}

bool
LockScreenOrientation(const dom::ScreenOrientationInternal& aOrientation)
{
  bool allowed;
  Hal()->SendLockScreenOrientation(aOrientation, &allowed);
  return allowed;
}

void
UnlockScreenOrientation()
{
  Hal()->SendUnlockScreenOrientation();
}

bool
GetScreenEnabled()
{
  bool enabled = false;
  Hal()->SendGetScreenEnabled(&enabled);
  return enabled;
}

void
SetScreenEnabled(bool aEnabled)
{
  Hal()->SendSetScreenEnabled(aEnabled);
}

bool
GetKeyLightEnabled()
{
  bool enabled = false;
  Hal()->SendGetKeyLightEnabled(&enabled);
  return enabled;
}

void
SetKeyLightEnabled(bool aEnabled)
{
  Hal()->SendSetKeyLightEnabled(aEnabled);
}

bool
GetCpuSleepAllowed()
{
  bool allowed = true;
  Hal()->SendGetCpuSleepAllowed(&allowed);
  return allowed;
}

void
SetCpuSleepAllowed(bool aAllowed)
{
  Hal()->SendSetCpuSleepAllowed(aAllowed);
}

double
GetScreenBrightness()
{
  double brightness = 0;
  Hal()->SendGetScreenBrightness(&brightness);
  return brightness;
}

void
SetScreenBrightness(double aBrightness)
{
  Hal()->SendSetScreenBrightness(aBrightness);
}

void
AdjustSystemClock(int64_t aDeltaMilliseconds)
{
  Hal()->SendAdjustSystemClock(aDeltaMilliseconds);
}

void
SetTimezone(const nsCString& aTimezoneSpec)
{
  Hal()->SendSetTimezone(nsCString(aTimezoneSpec));
}

nsCString
GetTimezone()
{
  nsCString timezone;
  Hal()->SendGetTimezone(&timezone);
  return timezone;
}

int32_t
GetTimezoneOffset()
{
  int32_t timezoneOffset;
  Hal()->SendGetTimezoneOffset(&timezoneOffset);
  return timezoneOffset;
}

void
EnableSystemClockChangeNotifications()
{
  Hal()->SendEnableSystemClockChangeNotifications();
}

void
DisableSystemClockChangeNotifications()
{
  Hal()->SendDisableSystemClockChangeNotifications();
}

void
EnableSystemTimezoneChangeNotifications()
{
  Hal()->SendEnableSystemTimezoneChangeNotifications();
}

void
DisableSystemTimezoneChangeNotifications()
{
  Hal()->SendDisableSystemTimezoneChangeNotifications();
}

void
Reboot()
{
  NS_RUNTIMEABORT("Reboot() can't be called from sandboxed contexts.");
}

void
PowerOff()
{
  NS_RUNTIMEABORT("PowerOff() can't be called from sandboxed contexts.");
}

void
StartForceQuitWatchdog(ShutdownMode aMode, int32_t aTimeoutSecs)
{
  NS_RUNTIMEABORT("StartForceQuitWatchdog() can't be called from sandboxed contexts.");
}

void
EnableSensorNotifications(SensorType aSensor) {
  Hal()->SendEnableSensorNotifications(aSensor);
}

void
DisableSensorNotifications(SensorType aSensor) {
  Hal()->SendDisableSensorNotifications(aSensor);
}

void
EnableWakeLockNotifications()
{
  Hal()->SendEnableWakeLockNotifications();
}

void
DisableWakeLockNotifications()
{
  Hal()->SendDisableWakeLockNotifications();
}

void
ModifyWakeLock(const nsAString &aTopic,
               WakeLockControl aLockAdjust,
               WakeLockControl aHiddenAdjust,
               uint64_t aProcessID)
{
  MOZ_ASSERT(aProcessID != CONTENT_PROCESS_ID_UNKNOWN);
  Hal()->SendModifyWakeLock(nsString(aTopic), aLockAdjust, aHiddenAdjust, aProcessID);
}

void
GetWakeLockInfo(const nsAString &aTopic, WakeLockInformation *aWakeLockInfo)
{
  Hal()->SendGetWakeLockInfo(nsString(aTopic), aWakeLockInfo);
}

void
EnableSwitchNotifications(SwitchDevice aDevice)
{
  Hal()->SendEnableSwitchNotifications(aDevice);
}

void
DisableSwitchNotifications(SwitchDevice aDevice)
{
  Hal()->SendDisableSwitchNotifications(aDevice);
}

SwitchState
GetCurrentSwitchState(SwitchDevice aDevice)
{
  SwitchState state;
  Hal()->SendGetCurrentSwitchState(aDevice, &state);
  return state;
}

void
NotifySwitchStateFromInputDevice(SwitchDevice aDevice, SwitchState aState)
{
  Unused << aDevice;
  Unused << aState;
  NS_RUNTIMEABORT("Only the main process may notify switch state change.");
}

bool
EnableAlarm()
{
  NS_RUNTIMEABORT("Alarms can't be programmed from sandboxed contexts.  Yet.");
  return false;
}

void
DisableAlarm()
{
  NS_RUNTIMEABORT("Alarms can't be programmed from sandboxed contexts.  Yet.");
}

bool
SetAlarm(int32_t aSeconds, int32_t aNanoseconds)
{
  NS_RUNTIMEABORT("Alarms can't be programmed from sandboxed contexts.  Yet.");
  return false;
}

void
SetProcessPriority(int aPid, ProcessPriority aPriority, uint32_t aLRU)
{
  NS_RUNTIMEABORT("Only the main process may set processes' priorities.");
}

void
SetCurrentThreadPriority(ThreadPriority aThreadPriority)
{
  NS_RUNTIMEABORT("Setting current thread priority cannot be called from sandboxed contexts.");
}

void
SetThreadPriority(PlatformThreadId aThreadId,
                  ThreadPriority aThreadPriority)
{
  NS_RUNTIMEABORT("Setting thread priority cannot be called from sandboxed contexts.");
}

void
FactoryReset(FactoryResetReason& aReason)
{
  if (aReason == FactoryResetReason::Normal) {
    Hal()->SendFactoryReset(NS_LITERAL_STRING("normal"));
  } else if (aReason == FactoryResetReason::Wipe) {
    Hal()->SendFactoryReset(NS_LITERAL_STRING("wipe"));
  } else if (aReason == FactoryResetReason::Root) {
    Hal()->SendFactoryReset(NS_LITERAL_STRING("root"));
  }
}

void
StartDiskSpaceWatcher()
{
  NS_RUNTIMEABORT("StartDiskSpaceWatcher() can't be called from sandboxed contexts.");
}

void
StopDiskSpaceWatcher()
{
  NS_RUNTIMEABORT("StopDiskSpaceWatcher() can't be called from sandboxed contexts.");
}

bool IsHeadphoneEventFromInputDev()
{
  NS_RUNTIMEABORT("IsHeadphoneEventFromInputDev() cannot be called from sandboxed contexts.");
  return false;
}

nsresult StartSystemService(const char* aSvcName, const char* aArgs)
{
  NS_RUNTIMEABORT("System services cannot be controlled from sandboxed contexts.");
  return NS_ERROR_NOT_IMPLEMENTED;
}

void StopSystemService(const char* aSvcName)
{
  NS_RUNTIMEABORT("System services cannot be controlled from sandboxed contexts.");
}

bool SystemServiceIsRunning(const char* aSvcName)
{
  NS_RUNTIMEABORT("System services cannot be controlled from sandboxed contexts.");
  return false;
}

class HalParent : public PHalParent
                , public BatteryObserver
                , public NetworkObserver
                , public ISensorObserver
                , public WakeLockObserver
                , public ScreenConfigurationObserver
                , public SwitchObserver
                , public SystemClockChangeObserver
                , public SystemTimezoneChangeObserver
{
public:
  virtual void
  ActorDestroy(ActorDestroyReason aWhy) override
  {
    // NB: you *must* unconditionally unregister your observer here,
    // if it *may* be registered below.
    hal::UnregisterBatteryObserver(this);
    hal::UnregisterNetworkObserver(this);
    hal::UnregisterScreenConfigurationObserver(this);
    for (int32_t sensor = SENSOR_UNKNOWN + 1;
         sensor < NUM_SENSOR_TYPE; ++sensor) {
      hal::UnregisterSensorObserver(SensorType(sensor), this);
    }
    hal::UnregisterWakeLockObserver(this);
    hal::UnregisterSystemClockChangeObserver(this);
    hal::UnregisterSystemTimezoneChangeObserver(this);
    for (int32_t switchDevice = SWITCH_DEVICE_UNKNOWN + 1;
         switchDevice < NUM_SWITCH_DEVICE; ++switchDevice) {
      hal::UnregisterSwitchObserver(SwitchDevice(switchDevice), this);
    }
  }

  virtual bool
  RecvVibrate(InfallibleTArray<unsigned int>&& pattern,
              InfallibleTArray<uint64_t>&& id,
              PBrowserParent *browserParent) override
  {
    // We give all content vibration permission.
    //    TabParent *tabParent = TabParent::GetFrom(browserParent);
    /* xxxkhuey wtf
    nsCOMPtr<nsIDOMWindow> window =
      do_QueryInterface(tabParent->GetBrowserDOMWindow());
    */
    WindowIdentifier newID(id, nullptr);
    hal::Vibrate(pattern, newID);
    return true;
  }

  virtual bool
  RecvCancelVibrate(InfallibleTArray<uint64_t> &&id,
                    PBrowserParent *browserParent) override
  {
    //TabParent *tabParent = TabParent::GetFrom(browserParent);
    /* XXXkhuey wtf
    nsCOMPtr<nsIDOMWindow> window =
      tabParent->GetBrowserDOMWindow();
    */
    WindowIdentifier newID(id, nullptr);
    hal::CancelVibrate(newID);
    return true;
  }

  virtual bool
  RecvEnableBatteryNotifications() override {
    // We give all content battery-status permission.
    hal::RegisterBatteryObserver(this);
    return true;
  }

  virtual bool
  RecvDisableBatteryNotifications() override {
    hal::UnregisterBatteryObserver(this);
    return true;
  }

  virtual bool
  RecvGetCurrentBatteryInformation(BatteryInformation* aBatteryInfo) override {
    // We give all content battery-status permission.
    hal::GetCurrentBatteryInformation(aBatteryInfo);
    return true;
  }

  void Notify(const BatteryInformation& aBatteryInfo) override {
    Unused << SendNotifyBatteryChange(aBatteryInfo);
  }

  virtual bool
  RecvEnableNetworkNotifications() override {
    // We give all content access to this network-status information.
    hal::RegisterNetworkObserver(this);
    return true;
  }

  virtual bool
  RecvDisableNetworkNotifications() override {
    hal::UnregisterNetworkObserver(this);
    return true;
  }

  virtual bool
  RecvGetCurrentNetworkInformation(NetworkInformation* aNetworkInfo) override {
    hal::GetCurrentNetworkInformation(aNetworkInfo);
    return true;
  }

  void Notify(const NetworkInformation& aNetworkInfo) override {
    Unused << SendNotifyNetworkChange(aNetworkInfo);
  }

  virtual bool
  RecvEnableScreenConfigurationNotifications() override {
    // Screen configuration is used to implement CSS and DOM
    // properties, so all content already has access to this.
    hal::RegisterScreenConfigurationObserver(this);
    return true;
  }

  virtual bool
  RecvDisableScreenConfigurationNotifications() override {
    hal::UnregisterScreenConfigurationObserver(this);
    return true;
  }

  virtual bool
  RecvGetCurrentScreenConfiguration(ScreenConfiguration* aScreenConfiguration) override {
    hal::GetCurrentScreenConfiguration(aScreenConfiguration);
    return true;
  }

  virtual bool
  RecvLockScreenOrientation(const dom::ScreenOrientationInternal& aOrientation, bool* aAllowed) override
  {
    // FIXME/bug 777980: unprivileged content may only lock
    // orientation while fullscreen.  We should check whether the
    // request comes from an actor in a process that might be
    // fullscreen.  We don't have that information currently.
    *aAllowed = hal::LockScreenOrientation(aOrientation);
    return true;
  }

  virtual bool
  RecvUnlockScreenOrientation() override
  {
    hal::UnlockScreenOrientation();
    return true;
  }

  void Notify(const ScreenConfiguration& aScreenConfiguration) override {
    Unused << SendNotifyScreenConfigurationChange(aScreenConfiguration);
  }

  virtual bool
  RecvGetScreenEnabled(bool* aEnabled) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    *aEnabled = hal::GetScreenEnabled();
    return true;
  }

  virtual bool
  RecvSetScreenEnabled(const bool& aEnabled) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    hal::SetScreenEnabled(aEnabled);
    return true;
  }

  virtual bool
  RecvGetKeyLightEnabled(bool* aEnabled) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    *aEnabled = hal::GetKeyLightEnabled();
    return true;
  }

  virtual bool
  RecvSetKeyLightEnabled(const bool& aEnabled) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    hal::SetKeyLightEnabled(aEnabled);
    return true;
  }

  virtual bool
  RecvGetCpuSleepAllowed(bool* aAllowed) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    *aAllowed = hal::GetCpuSleepAllowed();
    return true;
  }

  virtual bool
  RecvSetCpuSleepAllowed(const bool& aAllowed) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    hal::SetCpuSleepAllowed(aAllowed);
    return true;
  }

  virtual bool
  RecvGetScreenBrightness(double* aBrightness) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    *aBrightness = hal::GetScreenBrightness();
    return true;
  }

  virtual bool
  RecvSetScreenBrightness(const double& aBrightness) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }
    hal::SetScreenBrightness(aBrightness);
    return true;
  }

  virtual bool
  RecvAdjustSystemClock(const int64_t &aDeltaMilliseconds) override
  {
    if (!AssertAppProcessPermission(this, "time")) {
      return false;
    }
    hal::AdjustSystemClock(aDeltaMilliseconds);
    return true;
  }

  virtual bool
  RecvSetTimezone(const nsCString& aTimezoneSpec) override
  {
    if (!AssertAppProcessPermission(this, "time")) {
      return false;
    }
    hal::SetTimezone(aTimezoneSpec);
    return true;
  }

  virtual bool
  RecvGetTimezone(nsCString *aTimezoneSpec) override
  {
    if (!AssertAppProcessPermission(this, "time")) {
      return false;
    }
    *aTimezoneSpec = hal::GetTimezone();
    return true;
  }

  virtual bool
  RecvGetTimezoneOffset(int32_t *aTimezoneOffset) override
  {
    if (!AssertAppProcessPermission(this, "time")) {
      return false;
    }
    *aTimezoneOffset = hal::GetTimezoneOffset();
    return true;
  }

  virtual bool
  RecvEnableSystemClockChangeNotifications() override
  {
    hal::RegisterSystemClockChangeObserver(this);
    return true;
  }

  virtual bool
  RecvDisableSystemClockChangeNotifications() override
  {
    hal::UnregisterSystemClockChangeObserver(this);
    return true;
  }

  virtual bool
  RecvEnableSystemTimezoneChangeNotifications() override
  {
    hal::RegisterSystemTimezoneChangeObserver(this);
    return true;
  }

  virtual bool
  RecvDisableSystemTimezoneChangeNotifications() override
  {
    hal::UnregisterSystemTimezoneChangeObserver(this);
    return true;
  }

  virtual bool
  RecvEnableSensorNotifications(const SensorType &aSensor) override {
    // We currently allow any content to register device-sensor
    // listeners.
    hal::RegisterSensorObserver(aSensor, this);
    return true;
  }

  virtual bool
  RecvDisableSensorNotifications(const SensorType &aSensor) override {
    hal::UnregisterSensorObserver(aSensor, this);
    return true;
  }

  void Notify(const SensorData& aSensorData) override {
    Unused << SendNotifySensorChange(aSensorData);
  }

  virtual bool
  RecvModifyWakeLock(const nsString& aTopic,
                     const WakeLockControl& aLockAdjust,
                     const WakeLockControl& aHiddenAdjust,
                     const uint64_t& aProcessID) override
  {
    MOZ_ASSERT(aProcessID != CONTENT_PROCESS_ID_UNKNOWN);

    // We allow arbitrary content to use wake locks.
    hal::ModifyWakeLock(aTopic, aLockAdjust, aHiddenAdjust, aProcessID);
    return true;
  }

  virtual bool
  RecvEnableWakeLockNotifications() override
  {
    // We allow arbitrary content to use wake locks.
    hal::RegisterWakeLockObserver(this);
    return true;
  }

  virtual bool
  RecvDisableWakeLockNotifications() override
  {
    hal::UnregisterWakeLockObserver(this);
    return true;
  }

  virtual bool
  RecvGetWakeLockInfo(const nsString &aTopic, WakeLockInformation *aWakeLockInfo) override
  {
    hal::GetWakeLockInfo(aTopic, aWakeLockInfo);
    return true;
  }

  void Notify(const WakeLockInformation& aWakeLockInfo) override
  {
    Unused << SendNotifyWakeLockChange(aWakeLockInfo);
  }

  virtual bool
  RecvEnableSwitchNotifications(const SwitchDevice& aDevice) override
  {
    // Content has no reason to listen to switch events currently.
    hal::RegisterSwitchObserver(aDevice, this);
    return true;
  }

  virtual bool
  RecvDisableSwitchNotifications(const SwitchDevice& aDevice) override
  {
    hal::UnregisterSwitchObserver(aDevice, this);
    return true;
  }

  void Notify(const SwitchEvent& aSwitchEvent) override
  {
    Unused << SendNotifySwitchChange(aSwitchEvent);
  }

  virtual bool
  RecvGetCurrentSwitchState(const SwitchDevice& aDevice, hal::SwitchState *aState) override
  {
    // Content has no reason to listen to switch events currently.
    *aState = hal::GetCurrentSwitchState(aDevice);
    return true;
  }

  void Notify(const int64_t& aClockDeltaMS) override
  {
    Unused << SendNotifySystemClockChange(aClockDeltaMS);
  }

  void Notify(const SystemTimezoneChangeInformation& aSystemTimezoneChangeInfo) override
  {
    Unused << SendNotifySystemTimezoneChange(aSystemTimezoneChangeInfo);
  }

  virtual bool
  RecvFactoryReset(const nsString& aReason) override
  {
    if (!AssertAppProcessPermission(this, "power")) {
      return false;
    }

    FactoryResetReason reason = FactoryResetReason::Normal;
    if (aReason.EqualsLiteral("normal")) {
      reason = FactoryResetReason::Normal;
    } else if (aReason.EqualsLiteral("wipe")) {
      reason = FactoryResetReason::Wipe;
    } else if (aReason.EqualsLiteral("root")) {
      reason = FactoryResetReason::Root;
    } else {
      // Invalid factory reset reason. That should never happen.
      return false;
    }

    hal::FactoryReset(reason);
    return true;
  }
};

class HalChild : public PHalChild {
public:
  virtual void
  ActorDestroy(ActorDestroyReason aWhy) override
  {
    sHalChildDestroyed = true;
  }

  virtual bool
  RecvNotifyBatteryChange(const BatteryInformation& aBatteryInfo) override {
    hal::NotifyBatteryChange(aBatteryInfo);
    return true;
  }

  virtual bool
  RecvNotifySensorChange(const hal::SensorData &aSensorData) override;

  virtual bool
  RecvNotifyNetworkChange(const NetworkInformation& aNetworkInfo) override {
    hal::NotifyNetworkChange(aNetworkInfo);
    return true;
  }

  virtual bool
  RecvNotifyWakeLockChange(const WakeLockInformation& aWakeLockInfo) override {
    hal::NotifyWakeLockChange(aWakeLockInfo);
    return true;
  }

  virtual bool
  RecvNotifyScreenConfigurationChange(const ScreenConfiguration& aScreenConfiguration) override {
    hal::NotifyScreenConfigurationChange(aScreenConfiguration);
    return true;
  }

  virtual bool
  RecvNotifySwitchChange(const mozilla::hal::SwitchEvent& aEvent) override {
    hal::NotifySwitchChange(aEvent);
    return true;
  }

  virtual bool
  RecvNotifySystemClockChange(const int64_t& aClockDeltaMS) override {
    hal::NotifySystemClockChange(aClockDeltaMS);
    return true;
  }

  virtual bool
  RecvNotifySystemTimezoneChange(
    const SystemTimezoneChangeInformation& aSystemTimezoneChangeInfo) override {
    hal::NotifySystemTimezoneChange(aSystemTimezoneChangeInfo);
    return true;
  }
};

bool
HalChild::RecvNotifySensorChange(const hal::SensorData &aSensorData) {
  hal::NotifySensorChange(aSensorData);

  return true;
}

PHalChild* CreateHalChild() {
  return new HalChild();
}

PHalParent* CreateHalParent() {
  return new HalParent();
}

} // namespace hal_sandbox
} // namespace mozilla
