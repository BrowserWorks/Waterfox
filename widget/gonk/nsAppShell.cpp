/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=4 sw=4 sts=4 tw=80 et: */
/* Copyright 2012 Mozilla Foundation and Mozilla contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <hardware_legacy/power.h>
#include <signal.h>
#include <sys/epoll.h>
#include <sys/ioctl.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <utils/BitSet.h>

#include "base/basictypes.h"
#include "GonkPermission.h"
#include "libdisplay/BootAnimation.h"
#include "nscore.h"
#include "mozilla/TouchEvents.h"
#include "mozilla/FileUtils.h"
#include "mozilla/Hal.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/Mutex.h"
#include "mozilla/Services.h"
#include "mozilla/TextEvents.h"
#if ANDROID_VERSION >= 18
#include "nativewindow/FakeSurfaceComposer.h"
#endif
#include "nsAppShell.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/dom/Touch.h"
#include "nsGkAtoms.h"
#include "nsIObserverService.h"
#include "nsIScreen.h"
#include "nsScreenManagerGonk.h"
#include "nsThreadUtils.h"
#include "nsWindow.h"
#include "OrientationObserver.h"
#include "GonkMemoryPressureMonitoring.h"

#include "android/log.h"
#include "libui/EventHub.h"
#include "libui/InputReader.h"
#include "libui/InputDispatcher.h"

#include "mozilla/Preferences.h"
#include "GeckoProfiler.h"

// Defines kKeyMapping and GetKeyNameIndex()
#include "GonkKeyMapping.h"
#include "mozilla/layers/CompositorBridgeParent.h"
#include "GeckoTouchDispatcher.h"

#undef LOG
#define LOG(args...)                                            \
    __android_log_print(ANDROID_LOG_INFO, "Gonk" , ## args)
#ifdef VERBOSE_LOG_ENABLED
# define VERBOSE_LOG(args...)                           \
    __android_log_print(ANDROID_LOG_INFO, "Gonk" , ## args)
#else
# define VERBOSE_LOG(args...)                   \
    (void)0
#endif

using namespace android;
using namespace mozilla;
using namespace mozilla::dom;
using namespace mozilla::services;
using namespace mozilla::widget;

bool gDrawRequest = false;
static nsAppShell *gAppShell = nullptr;
static int epollfd = 0;
static int signalfds[2] = {0};
static bool sDevInputAudioJack;
static int32_t sHeadphoneState;
static int32_t sMicrophoneState;

// Amount of time in MS before an input is considered expired.
static const uint64_t kInputExpirationThresholdMs = 1000;
static const char kKey_WAKE_LOCK_ID[] = "GeckoKeyEvent";

NS_IMPL_ISUPPORTS_INHERITED(nsAppShell, nsBaseAppShell, nsIObserver)

static uint64_t
nanosecsToMillisecs(nsecs_t nsecs)
{
    return nsecs / 1000000;
}

namespace mozilla {

bool ProcessNextEvent()
{
    return gAppShell->ProcessNextNativeEvent(true);
}

void NotifyEvent()
{
    gAppShell->NotifyNativeEvent();
}

} // namespace mozilla

static void
pipeHandler(int fd, FdHandler *data)
{
    ssize_t len;
    do {
        char tmp[32];
        len = read(fd, tmp, sizeof(tmp));
    } while (len > 0);
}

struct Touch {
    int32_t id;
    PointerCoords coords;
};

struct UserInputData {
    uint64_t timeMs;
    enum {
        MOTION_DATA,
        KEY_DATA
    } type;
    int32_t action;
    int32_t flags;
    int32_t metaState;
    int32_t deviceId;
    union {
        struct {
            int32_t keyCode;
            int32_t scanCode;
        } key;
        struct {
            int32_t touchCount;
            ::Touch touches[MAX_POINTERS];
        } motion;
    };
};

static mozilla::Modifiers
getDOMModifiers(int32_t metaState)
{
    mozilla::Modifiers result = 0;
    if (metaState & (AMETA_ALT_ON | AMETA_ALT_LEFT_ON | AMETA_ALT_RIGHT_ON)) {
        result |= MODIFIER_ALT;
    }
    if (metaState & (AMETA_SHIFT_ON |
                     AMETA_SHIFT_LEFT_ON | AMETA_SHIFT_RIGHT_ON)) {
        result |= MODIFIER_SHIFT;
    }
    if (metaState & AMETA_FUNCTION_ON) {
        result |= MODIFIER_FN;
    }
    if (metaState & (AMETA_CTRL_ON |
                     AMETA_CTRL_LEFT_ON | AMETA_CTRL_RIGHT_ON)) {
        result |= MODIFIER_CONTROL;
    }
    if (metaState & (AMETA_META_ON |
                     AMETA_META_LEFT_ON | AMETA_META_RIGHT_ON)) {
        result |= MODIFIER_META;
    }
    if (metaState & AMETA_CAPS_LOCK_ON) {
        result |= MODIFIER_CAPSLOCK;
    }
    if (metaState & AMETA_NUM_LOCK_ON) {
        result |= MODIFIER_NUMLOCK;
    }
    if (metaState & AMETA_SCROLL_LOCK_ON) {
        result |= MODIFIER_SCROLLLOCK;
    }
    return result;
}

class MOZ_STACK_CLASS KeyEventDispatcher
{
public:
    KeyEventDispatcher(const UserInputData& aData,
                       KeyCharacterMap* aKeyCharMap);
    void Dispatch();

private:
    const UserInputData& mData;
    sp<KeyCharacterMap> mKeyCharMap;

    char16_t mChar;
    char16_t mUnmodifiedChar;

    uint32_t mDOMKeyCode;
    uint32_t mDOMKeyLocation;
    KeyNameIndex mDOMKeyNameIndex;
    CodeNameIndex mDOMCodeNameIndex;
    char16_t mDOMPrintableKeyValue;

    bool IsKeyPress() const
    {
        return mData.action == AKEY_EVENT_ACTION_DOWN;
    }
    bool IsRepeat() const
    {
        return IsKeyPress() && (mData.flags & AKEY_EVENT_FLAG_LONG_PRESS);
    }

    char16_t PrintableKeyValue() const;

    int32_t UnmodifiedMetaState() const
    {
        return mData.metaState &
            ~(AMETA_ALT_ON | AMETA_ALT_LEFT_ON | AMETA_ALT_RIGHT_ON |
              AMETA_CTRL_ON | AMETA_CTRL_LEFT_ON | AMETA_CTRL_RIGHT_ON |
              AMETA_META_ON | AMETA_META_LEFT_ON | AMETA_META_RIGHT_ON);
    }

    static bool IsControlChar(char16_t aChar)
    {
        return (aChar < ' ' || aChar == 0x7F);
    }

    void DispatchKeyDownEvent();
    void DispatchKeyUpEvent();
    nsEventStatus DispatchKeyEventInternal(EventMessage aEventMessage);
};

KeyEventDispatcher::KeyEventDispatcher(const UserInputData& aData,
                                       KeyCharacterMap* aKeyCharMap)
    : mData(aData)
    , mKeyCharMap(aKeyCharMap)
    , mChar(0)
    , mUnmodifiedChar(0)
    , mDOMPrintableKeyValue(0)
{
    // XXX Printable key's keyCode value should be computed with actual
    //     input character.
    mDOMKeyCode = (mData.key.keyCode < (ssize_t)ArrayLength(kKeyMapping)) ?
        kKeyMapping[mData.key.keyCode] : 0;
    mDOMKeyNameIndex = GetKeyNameIndex(mData.key.keyCode);
    mDOMCodeNameIndex = GetCodeNameIndex(mData.key.scanCode);
    mDOMKeyLocation =
        WidgetKeyboardEvent::ComputeLocationFromCodeValue(mDOMCodeNameIndex);

    if (!mKeyCharMap.get()) {
        return;
    }

    mChar = mKeyCharMap->getCharacter(mData.key.keyCode, mData.metaState);
    if (IsControlChar(mChar)) {
        mChar = 0;
    }
    int32_t unmodifiedMetaState = UnmodifiedMetaState();
    if (mData.metaState == unmodifiedMetaState) {
        mUnmodifiedChar = mChar;
    } else {
        mUnmodifiedChar = mKeyCharMap->getCharacter(mData.key.keyCode,
                                                    unmodifiedMetaState);
        if (IsControlChar(mUnmodifiedChar)) {
            mUnmodifiedChar = 0;
        }
    }

    mDOMPrintableKeyValue = PrintableKeyValue();
}

char16_t
KeyEventDispatcher::PrintableKeyValue() const
{
    if (mDOMKeyNameIndex != KEY_NAME_INDEX_USE_STRING) {
        return 0;
    }
    return mChar ? mChar : mUnmodifiedChar;
}

nsEventStatus
KeyEventDispatcher::DispatchKeyEventInternal(EventMessage aEventMessage)
{
    WidgetKeyboardEvent event(true, aEventMessage, nullptr);
    if (aEventMessage == eKeyPress) {
        // XXX If the charCode is not a printable character, the charCode
        //     should be computed without Ctrl/Alt/Meta modifiers.
        event.mCharCode = static_cast<uint32_t>(mChar);
    }
    if (!event.mCharCode) {
        event.mKeyCode = mDOMKeyCode;
    }
    event.mIsChar = !!event.mCharCode;
    event.mIsRepeat = IsRepeat();
    event.mKeyNameIndex = mDOMKeyNameIndex;
    if (mDOMPrintableKeyValue) {
        event.mKeyValue = mDOMPrintableKeyValue;
    }
    event.mCodeNameIndex = mDOMCodeNameIndex;
    event.mModifiers = getDOMModifiers(mData.metaState);
    event.mLocation = mDOMKeyLocation;
    event.mTime = mData.timeMs;
    return nsWindow::DispatchKeyInput(event);
}

void
KeyEventDispatcher::Dispatch()
{
    // XXX Even if unknown key is pressed, DOM key event should be
    //     dispatched since Gecko for the other platforms are implemented
    //     as so.
    if (!mDOMKeyCode && mDOMKeyNameIndex == KEY_NAME_INDEX_Unidentified) {
        VERBOSE_LOG("Got unknown key event code. "
                    "type 0x%04x code 0x%04x value %d",
                    mData.action, mData.key.keyCode, IsKeyPress());
        return;
    }

    if (IsKeyPress()) {
        DispatchKeyDownEvent();
    } else {
        DispatchKeyUpEvent();
    }
}

void
KeyEventDispatcher::DispatchKeyDownEvent()
{
    nsEventStatus status = DispatchKeyEventInternal(eKeyDown);
    if (status != nsEventStatus_eConsumeNoDefault) {
        DispatchKeyEventInternal(eKeyPress);
    }
}

void
KeyEventDispatcher::DispatchKeyUpEvent()
{
    DispatchKeyEventInternal(eKeyUp);
}

class SwitchEventRunnable : public mozilla::Runnable {
public:
    SwitchEventRunnable(hal::SwitchEvent& aEvent) : mEvent(aEvent)
    {}

    NS_IMETHOD Run() override
    {
        hal::NotifySwitchStateFromInputDevice(mEvent.device(),
          mEvent.status());
        return NS_OK;
    }
private:
    hal::SwitchEvent mEvent;
};

static void
updateHeadphoneSwitch()
{
    hal::SwitchEvent event;

    switch (sHeadphoneState) {
    case AKEY_STATE_UP:
        event.status() = hal::SWITCH_STATE_OFF;
        break;
    case AKEY_STATE_DOWN:
        event.status() = sMicrophoneState == AKEY_STATE_DOWN ?
            hal::SWITCH_STATE_HEADSET : hal::SWITCH_STATE_HEADPHONE;
        break;
    default:
        return;
    }

    event.device() = hal::SWITCH_HEADPHONES;
    NS_DispatchToMainThread(new SwitchEventRunnable(event));
}

class GeckoPointerController : public PointerControllerInterface {
    float mX;
    float mY;
    int32_t mButtonState;
    InputReaderConfiguration* mConfig;
public:
    GeckoPointerController(InputReaderConfiguration* config)
        : mX(0)
        , mY(0)
        , mButtonState(0)
        , mConfig(config)
    {}

    virtual bool getBounds(float* outMinX, float* outMinY,
            float* outMaxX, float* outMaxY) const;
    virtual void move(float deltaX, float deltaY);
    virtual void setButtonState(int32_t buttonState);
    virtual int32_t getButtonState() const;
    virtual void setPosition(float x, float y);
    virtual void getPosition(float* outX, float* outY) const;
    virtual void fade(Transition transition) {}
    virtual void unfade(Transition transition) {}
    virtual void setPresentation(Presentation presentation) {}
    virtual void setSpots(const PointerCoords* spotCoords, const uint32_t* spotIdToIndex,
            BitSet32 spotIdBits) {}
    virtual void clearSpots() {}
};

bool
GeckoPointerController::getBounds(float* outMinX,
                                  float* outMinY,
                                  float* outMaxX,
                                  float* outMaxY) const
{
    DisplayViewport viewport;

    mConfig->getDisplayInfo(false, &viewport);

    *outMinX = *outMinY = 0;
    *outMaxX = viewport.logicalRight;
    *outMaxY = viewport.logicalBottom;
    return true;
}

void
GeckoPointerController::move(float deltaX, float deltaY)
{
    float minX, minY, maxX, maxY;
    getBounds(&minX, &minY, &maxX, &maxY);

    mX = clamped(mX + deltaX, minX, maxX);
    mY = clamped(mY + deltaY, minY, maxY);
}

void
GeckoPointerController::setButtonState(int32_t buttonState)
{
    mButtonState = buttonState;
}

int32_t
GeckoPointerController::getButtonState() const
{
    return mButtonState;
}

void
GeckoPointerController::setPosition(float x, float y)
{
    mX = x;
    mY = y;
}

void
GeckoPointerController::getPosition(float* outX, float* outY) const
{
    *outX = mX;
    *outY = mY;
}

class GeckoInputReaderPolicy : public InputReaderPolicyInterface {
    InputReaderConfiguration mConfig;
public:
    GeckoInputReaderPolicy() {}

    virtual void getReaderConfiguration(InputReaderConfiguration* outConfig);
    virtual sp<PointerControllerInterface> obtainPointerController(int32_t
deviceId)
    {
        return new GeckoPointerController(&mConfig);
    };
    virtual void notifyInputDevicesChanged(const android::Vector<InputDeviceInfo>& inputDevices) {};
    virtual sp<KeyCharacterMap> getKeyboardLayoutOverlay(const String8& inputDeviceDescriptor)
    {
        return nullptr;
    };
    virtual String8 getDeviceAlias(const InputDeviceIdentifier& identifier)
    {
        return String8::empty();
    };

    void setDisplayInfo();

protected:
    virtual ~GeckoInputReaderPolicy() {}
};

class GeckoInputDispatcher : public InputDispatcherInterface {
public:
    GeckoInputDispatcher(sp<EventHub> &aEventHub)
        : mQueueLock("GeckoInputDispatcher::mQueueMutex")
        , mEventHub(aEventHub)
        , mKeyDownCount(0)
        , mKeyEventsFiltered(false)
        , mPowerWakelock(false)
    {
        mTouchDispatcher = GeckoTouchDispatcher::GetInstance();
    }

    virtual void dump(String8& dump);

    virtual void monitor() {}

    // Called on the main thread
    virtual void dispatchOnce();

    // notify* methods are called on the InputReaderThread
    virtual void notifyConfigurationChanged(const NotifyConfigurationChangedArgs* args);
    virtual void notifyKey(const NotifyKeyArgs* args);
    virtual void notifyMotion(const NotifyMotionArgs* args);
    virtual void notifySwitch(const NotifySwitchArgs* args);
    virtual void notifyDeviceReset(const NotifyDeviceResetArgs* args);

    virtual int32_t injectInputEvent(const InputEvent* event,
            int32_t injectorPid, int32_t injectorUid, int32_t syncMode, int32_t timeoutMillis,
            uint32_t policyFlags);

    virtual void setInputWindows(const android::Vector<sp<InputWindowHandle> >& inputWindowHandles);
    virtual void setFocusedApplication(const sp<InputApplicationHandle>& inputApplicationHandle);

    virtual void setInputDispatchMode(bool enabled, bool frozen);
    virtual void setInputFilterEnabled(bool enabled) {}
    virtual bool transferTouchFocus(const sp<InputChannel>& fromChannel,
            const sp<InputChannel>& toChannel) { return true; }

    virtual status_t registerInputChannel(const sp<InputChannel>& inputChannel,
            const sp<InputWindowHandle>& inputWindowHandle, bool monitor);
    virtual status_t unregisterInputChannel(const sp<InputChannel>& inputChannel);



protected:
    virtual ~GeckoInputDispatcher() { }

private:
    // mQueueLock should generally be locked while using mEventQueue.
    // UserInputData is pushed on on the InputReaderThread and
    // popped and dispatched on the main thread.
    mozilla::Mutex mQueueLock;
    std::queue<UserInputData> mEventQueue;
    sp<EventHub> mEventHub;
    RefPtr<GeckoTouchDispatcher> mTouchDispatcher;

    int mKeyDownCount;
    bool mKeyEventsFiltered;
    bool mPowerWakelock;
};

// GeckoInputReaderPolicy
void
GeckoInputReaderPolicy::setDisplayInfo()
{
    static_assert(static_cast<int>(nsIScreen::ROTATION_0_DEG) ==
                  static_cast<int>(DISPLAY_ORIENTATION_0),
                  "Orientation enums not matched!");
    static_assert(static_cast<int>(nsIScreen::ROTATION_90_DEG) ==
                  static_cast<int>(DISPLAY_ORIENTATION_90),
                  "Orientation enums not matched!");
    static_assert(static_cast<int>(nsIScreen::ROTATION_180_DEG) ==
                  static_cast<int>(DISPLAY_ORIENTATION_180),
                  "Orientation enums not matched!");
    static_assert(static_cast<int>(nsIScreen::ROTATION_270_DEG) ==
                  static_cast<int>(DISPLAY_ORIENTATION_270),
                  "Orientation enums not matched!");

    RefPtr<nsScreenGonk> screen = nsScreenManagerGonk::GetPrimaryScreen();

    uint32_t rotation = nsIScreen::ROTATION_0_DEG;
    DebugOnly<nsresult> rv = screen->GetRotation(&rotation);
    MOZ_ASSERT(NS_SUCCEEDED(rv));
    LayoutDeviceIntRect screenBounds = screen->GetNaturalBounds();

    DisplayViewport viewport;
    viewport.displayId = 0;
    viewport.orientation = rotation;
    viewport.physicalRight = viewport.deviceWidth = screenBounds.width;
    viewport.physicalBottom = viewport.deviceHeight = screenBounds.height;
    if (viewport.orientation == DISPLAY_ORIENTATION_90 ||
        viewport.orientation == DISPLAY_ORIENTATION_270) {
        viewport.logicalRight = screenBounds.height;
        viewport.logicalBottom = screenBounds.width;
    } else {
        viewport.logicalRight = screenBounds.width;
        viewport.logicalBottom = screenBounds.height;
    }
    mConfig.setDisplayInfo(false, viewport);
}

void GeckoInputReaderPolicy::getReaderConfiguration(InputReaderConfiguration* outConfig)
{
    *outConfig = mConfig;
}


// GeckoInputDispatcher
void
GeckoInputDispatcher::dump(String8& dump)
{
}

static bool
isExpired(const UserInputData& data)
{
    uint64_t timeNowMs =
        nanosecsToMillisecs(systemTime(SYSTEM_TIME_MONOTONIC));
    return (timeNowMs - data.timeMs) > kInputExpirationThresholdMs;
}

void
GeckoInputDispatcher::dispatchOnce()
{
    UserInputData data;
    {
        MutexAutoLock lock(mQueueLock);
        if (mEventQueue.empty())
            return;
        data = mEventQueue.front();
        mEventQueue.pop();
        if (!mEventQueue.empty())
            gAppShell->NotifyNativeEvent();
    }

    switch (data.type) {
    case UserInputData::MOTION_DATA: {
        MOZ_ASSERT_UNREACHABLE("Should not dispatch touch events here anymore");
        break;
    }
    case UserInputData::KEY_DATA: {
        if (!mKeyDownCount) {
            // No pending events, the filter state can be updated.
            mKeyEventsFiltered = isExpired(data);
        }

        mKeyDownCount += (data.action == AKEY_EVENT_ACTION_DOWN) ? 1 : -1;
        if (mKeyEventsFiltered) {
            return;
        }

        sp<KeyCharacterMap> kcm = mEventHub->getKeyCharacterMap(data.deviceId);
        KeyEventDispatcher dispatcher(data, kcm.get());
        dispatcher.Dispatch();
        break;
    }
    }
    MutexAutoLock lock(mQueueLock);
    if (mPowerWakelock && mEventQueue.empty()) {
        release_wake_lock(kKey_WAKE_LOCK_ID);
        mPowerWakelock = false;
    }
}

void
GeckoInputDispatcher::notifyConfigurationChanged(const NotifyConfigurationChangedArgs*)
{
    gAppShell->CheckPowerKey();
}

void
GeckoInputDispatcher::notifyKey(const NotifyKeyArgs* args)
{
    UserInputData data;
    data.timeMs = nanosecsToMillisecs(args->eventTime);
    data.type = UserInputData::KEY_DATA;
    data.action = args->action;
    data.flags = args->flags;
    data.metaState = args->metaState;
    data.deviceId = args->deviceId;
    data.key.keyCode = args->keyCode;
    data.key.scanCode = args->scanCode;
    {
        MutexAutoLock lock(mQueueLock);
        mEventQueue.push(data);
        if (!mPowerWakelock) {
            mPowerWakelock =
                acquire_wake_lock(PARTIAL_WAKE_LOCK, kKey_WAKE_LOCK_ID);
        }
    }
    gAppShell->NotifyNativeEvent();
}

static void
addMultiTouch(MultiTouchInput& aMultiTouch,
                                    const NotifyMotionArgs* args, int aIndex)
{
    int32_t id = args->pointerProperties[aIndex].id;
    PointerCoords coords = args->pointerCoords[aIndex];
    float force = coords.getAxisValue(AMOTION_EVENT_AXIS_PRESSURE);

    float orientation = coords.getAxisValue(AMOTION_EVENT_AXIS_ORIENTATION);
    float rotationAngle = orientation * 180 / M_PI;
    if (rotationAngle == 90) {
      rotationAngle = -90;
    }

    float radiusX, radiusY;
    if (rotationAngle < 0) {
      radiusX = coords.getAxisValue(AMOTION_EVENT_AXIS_TOUCH_MINOR) / 2;
      radiusY = coords.getAxisValue(AMOTION_EVENT_AXIS_TOUCH_MAJOR) / 2;
      rotationAngle += 90;
    } else {
      radiusX = coords.getAxisValue(AMOTION_EVENT_AXIS_TOUCH_MAJOR) / 2;
      radiusY = coords.getAxisValue(AMOTION_EVENT_AXIS_TOUCH_MINOR) / 2;
    }

    ScreenIntPoint point = ScreenIntPoint::Round(coords.getX(),
                                                 coords.getY());

    SingleTouchData touchData(id, point, ScreenSize(radiusX, radiusY),
                              rotationAngle, force);

    aMultiTouch.mTouches.AppendElement(touchData);
}

void
GeckoInputDispatcher::notifyMotion(const NotifyMotionArgs* args)
{
    uint32_t time = nanosecsToMillisecs(args->eventTime);
    int32_t action = args->action & AMOTION_EVENT_ACTION_MASK;
    int touchCount = args->pointerCount;
    MOZ_ASSERT(touchCount <= MAX_POINTERS);
    TimeStamp timestamp = mozilla::TimeStamp::FromSystemTime(args->eventTime);
    Modifiers modifiers = getDOMModifiers(args->metaState);

    MultiTouchInput::MultiTouchType touchType = MultiTouchInput::MULTITOUCH_CANCEL;
    switch (action) {
    case AMOTION_EVENT_ACTION_DOWN:
    case AMOTION_EVENT_ACTION_POINTER_DOWN:
        touchType = MultiTouchInput::MULTITOUCH_START;
        break;
    case AMOTION_EVENT_ACTION_MOVE:
        touchType = MultiTouchInput::MULTITOUCH_MOVE;
        break;
    case AMOTION_EVENT_ACTION_UP:
    case AMOTION_EVENT_ACTION_POINTER_UP:
        touchType = MultiTouchInput::MULTITOUCH_END;
        break;
    case AMOTION_EVENT_ACTION_OUTSIDE:
    case AMOTION_EVENT_ACTION_CANCEL:
        touchType = MultiTouchInput::MULTITOUCH_CANCEL;
        break;
    case AMOTION_EVENT_ACTION_HOVER_EXIT:
    case AMOTION_EVENT_ACTION_HOVER_ENTER:
    case AMOTION_EVENT_ACTION_HOVER_MOVE:
        NS_WARNING("Ignoring hover touch events");
        return;
    default:
        MOZ_ASSERT_UNREACHABLE("Could not assign a touch type");
        break;
    }

    MultiTouchInput touchData(touchType, time, timestamp, modifiers);

    // For touch ends, we have to filter out which finger is actually
    // the touch end since the touch array has all fingers, not just the touch
    // that we want to end
    if (touchType == MultiTouchInput::MULTITOUCH_END) {
        int touchIndex = args->action & AMOTION_EVENT_ACTION_POINTER_INDEX_MASK;
        touchIndex >>= AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT;
        addMultiTouch(touchData, args, touchIndex);
    } else {
        for (int32_t i = 0; i < touchCount; ++i) {
            addMultiTouch(touchData, args, i);
        }
    }

    mTouchDispatcher->NotifyTouch(touchData, timestamp);
}

void GeckoInputDispatcher::notifySwitch(const NotifySwitchArgs* args)
{
    if (!sDevInputAudioJack)
        return;

    bool needSwitchUpdate = false;

    if (args->switchMask & (1 << SW_HEADPHONE_INSERT)) {
        sHeadphoneState = (args->switchValues & (1 << SW_HEADPHONE_INSERT)) ?
                          AKEY_STATE_DOWN : AKEY_STATE_UP;
        needSwitchUpdate = true;
    }

    if (args->switchMask & (1 << SW_MICROPHONE_INSERT)) {
        sMicrophoneState = (args->switchValues & (1 << SW_MICROPHONE_INSERT)) ?
                           AKEY_STATE_DOWN : AKEY_STATE_UP;
        needSwitchUpdate = true;
    }

    if (needSwitchUpdate)
        updateHeadphoneSwitch();
}

void GeckoInputDispatcher::notifyDeviceReset(const NotifyDeviceResetArgs* args)
{
}

int32_t GeckoInputDispatcher::injectInputEvent(
    const InputEvent* event,
    int32_t injectorPid, int32_t injectorUid, int32_t syncMode,
    int32_t timeoutMillis, uint32_t policyFlags)
{
    return INPUT_EVENT_INJECTION_SUCCEEDED;
}

void
GeckoInputDispatcher::setInputWindows(const android::Vector<sp<InputWindowHandle> >& inputWindowHandles)
{
}

void
GeckoInputDispatcher::setFocusedApplication(const sp<InputApplicationHandle>& inputApplicationHandle)
{
}

void
GeckoInputDispatcher::setInputDispatchMode(bool enabled, bool frozen)
{
}

status_t
GeckoInputDispatcher::registerInputChannel(const sp<InputChannel>& inputChannel,
                                           const sp<InputWindowHandle>& inputWindowHandle, bool monitor)
{
    return OK;
}

status_t
GeckoInputDispatcher::unregisterInputChannel(const sp<InputChannel>& inputChannel)
{
    return OK;
}

nsAppShell::nsAppShell()
    : mNativeCallbackRequest(false)
    , mEnableDraw(false)
    , mHandlers()
    , mPowerKeyChecked(false)
{
    gAppShell = this;
    if (XRE_IsParentProcess()) {
        Preferences::SetCString("b2g.safe_mode", "unset");
    }
}

nsAppShell::~nsAppShell()
{
    // mReaderThread and mEventHub will both be null if InitInputDevices
    // is not called.
    if (mReaderThread.get()) {
        // We separate requestExit() and join() here so we can wake the EventHub's
        // input loop, and stop it from polling for input events
        mReaderThread->requestExit();
        mEventHub->wake();

        status_t result = mReaderThread->requestExitAndWait();
        if (result)
            LOG("Could not stop reader thread - %d", result);
    }
    gAppShell = nullptr;
}

nsresult
nsAppShell::Init()
{
    nsresult rv = nsBaseAppShell::Init();
    NS_ENSURE_SUCCESS(rv, rv);

    epollfd = epoll_create(16);
    NS_ENSURE_TRUE(epollfd >= 0, NS_ERROR_UNEXPECTED);

    int ret = pipe2(signalfds, O_NONBLOCK);
    NS_ENSURE_FALSE(ret, NS_ERROR_UNEXPECTED);

    rv = AddFdHandler(signalfds[0], pipeHandler, "");
    NS_ENSURE_SUCCESS(rv, rv);

    InitGonkMemoryPressureMonitoring();

    if (XRE_IsParentProcess()) {
        printf("*****************************************************************\n");
        printf("***\n");
        printf("*** This is stdout. Most of the useful output will be in logcat.\n");
        printf("***\n");
        printf("*****************************************************************\n");
        GonkPermissionService::instantiate();

        // Causes the kernel timezone to be set, which in turn causes the
        // timestamps on SD cards to have the local time rather than UTC time.
        hal::SetTimezone(hal::GetTimezone());
    }

    nsCOMPtr<nsIObserverService> obsServ = GetObserverService();
    if (obsServ) {
        obsServ->AddObserver(this, "browser-ui-startup-complete", false);
        obsServ->AddObserver(this, "network-connection-state-changed", false);
    }

    // Delay initializing input devices until the screen has been
    // initialized (and we know the resolution).
    return rv;
}

void
nsAppShell::CheckPowerKey()
{
    if (mPowerKeyChecked) {
        return;
    }

    uint32_t deviceId = 0;
    int32_t powerState = AKEY_STATE_UNKNOWN;

    // EventHub doesn't report the number of devices.
    while (powerState != AKEY_STATE_DOWN && deviceId < 32) {
        powerState = mEventHub->getKeyCodeState(deviceId++, AKEYCODE_POWER);
    }

    // If Power is pressed while we startup, mark safe mode.
    // Consumers of the b2g.safe_mode preference need to listen on this
    // preference change to prevent startup races.
    nsCOMPtr<nsIRunnable> prefSetter = 
    NS_NewRunnableFunction([powerState] () -> void {
        Preferences::SetCString("b2g.safe_mode",
                                (powerState == AKEY_STATE_DOWN) ? "yes" : "no");
    });
    NS_DispatchToMainThread(prefSetter.forget());

    mPowerKeyChecked = true;
}

NS_IMETHODIMP
nsAppShell::Observe(nsISupports* aSubject,
                    const char* aTopic,
                    const char16_t* aData)
{
    if (!strcmp(aTopic, "network-connection-state-changed")) {
        NS_ConvertUTF16toUTF8 type(aData);
        if (!type.IsEmpty()) {
            hal::NotifyNetworkChange(hal::NetworkInformation(atoi(type.get()), 0, 0));
        }
        return NS_OK;
    } else if (!strcmp(aTopic, "browser-ui-startup-complete")) {
        if (sDevInputAudioJack) {
            sHeadphoneState  = mReader->getSwitchState(-1, AINPUT_SOURCE_SWITCH, SW_HEADPHONE_INSERT);
            sMicrophoneState = mReader->getSwitchState(-1, AINPUT_SOURCE_SWITCH, SW_MICROPHONE_INSERT);
            updateHeadphoneSwitch();
        }
        mEnableDraw = true;

        // System is almost booting up. Stop the bootAnim now.
        StopBootAnimation();

        NotifyEvent();
        return NS_OK;
    }

    return nsBaseAppShell::Observe(aSubject, aTopic, aData);
}

NS_IMETHODIMP
nsAppShell::Exit()
{
    OrientationObserver::ShutDown();
    nsCOMPtr<nsIObserverService> obsServ = GetObserverService();
    if (obsServ) {
        obsServ->RemoveObserver(this, "browser-ui-startup-complete");
        obsServ->RemoveObserver(this, "network-connection-state-changed");
    }
    return nsBaseAppShell::Exit();
}

void
nsAppShell::InitInputDevices()
{
    sDevInputAudioJack = hal::IsHeadphoneEventFromInputDev();
    sHeadphoneState = AKEY_STATE_UNKNOWN;
    sMicrophoneState = AKEY_STATE_UNKNOWN;

    mEventHub = new EventHub();
    mReaderPolicy = new GeckoInputReaderPolicy();
    mReaderPolicy->setDisplayInfo();
    mDispatcher = new GeckoInputDispatcher(mEventHub);

    mReader = new InputReader(mEventHub, mReaderPolicy, mDispatcher);
    mReaderThread = new InputReaderThread(mReader);

    status_t result = mReaderThread->run("InputReader", PRIORITY_URGENT_DISPLAY);
    if (result) {
        LOG("Failed to initialize InputReader thread, bad things are going to happen...");
    }
}

nsresult
nsAppShell::AddFdHandler(int fd, FdHandlerCallback handlerFunc,
                         const char* deviceName)
{
    epoll_event event = {
        EPOLLIN,
        { 0 }
    };

    FdHandler *handler = mHandlers.AppendElement();
    handler->fd = fd;
    strncpy(handler->name, deviceName, sizeof(handler->name) - 1);
    handler->func = handlerFunc;
    event.data.u32 = mHandlers.Length() - 1;
    return epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &event) ?
           NS_ERROR_UNEXPECTED : NS_OK;
}

void
nsAppShell::ScheduleNativeEventCallback()
{
    mNativeCallbackRequest = true;
    NotifyEvent();
}

bool
nsAppShell::ProcessNextNativeEvent(bool mayWait)
{
    PROFILER_LABEL("nsAppShell", "ProcessNextNativeEvent",
        js::ProfileEntry::Category::EVENTS);

    epoll_event events[16] = {{ 0 }};

    int event_count;
    {
        PROFILER_LABEL("nsAppShell", "ProcessNextNativeEvent::Wait",
            js::ProfileEntry::Category::EVENTS);

        if ((event_count = epoll_wait(epollfd, events, 16,  mayWait ? -1 : 0)) <= 0)
            return true;
    }

    for (int i = 0; i < event_count; i++)
        mHandlers[events[i].data.u32].run();

    if (mDispatcher.get())
        mDispatcher->dispatchOnce();

    // NativeEventCallback always schedules more if it needs it
    // so we can coalesce these.
    // See the implementation in nsBaseAppShell.cpp for more info
    if (mNativeCallbackRequest) {
        mNativeCallbackRequest = false;
        NativeEventCallback();
    }

    if (gDrawRequest && mEnableDraw) {
        gDrawRequest = false;
        nsWindow::DoDraw();
    }

    return true;
}

void
nsAppShell::NotifyNativeEvent()
{
    write(signalfds[1], "w", 1);
}

/* static */ void
nsAppShell::NotifyScreenInitialized()
{
    gAppShell->InitInputDevices();

    // Getting the instance of OrientationObserver to initialize it.
    OrientationObserver::GetInstance();
}

/* static */ void
nsAppShell::NotifyScreenRotation()
{
    gAppShell->mReaderPolicy->setDisplayInfo();
    gAppShell->mReader->requestRefreshConfiguration(InputReaderConfiguration::CHANGE_DISPLAY_INFO);

    RefPtr<nsScreenGonk> screen = nsScreenManagerGonk::GetPrimaryScreen();
    hal::NotifyScreenConfigurationChange(screen->GetConfiguration());
}
