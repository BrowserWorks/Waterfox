/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sts=2 sw=2 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * nsWindow - Native window management and event handling.
 * 
 * nsWindow is organized into a set of major blocks and
 * block subsections. The layout is as follows:
 *
 *  Includes
 *  Variables
 *  nsIWidget impl.
 *     nsIWidget methods and utilities
 *  nsSwitchToUIThread impl.
 *     nsSwitchToUIThread methods and utilities
 *  Moz events
 *     Event initialization
 *     Event dispatching
 *  Native events
 *     Wndproc(s)
 *     Event processing
 *     OnEvent event handlers
 *  IME management and accessibility
 *  Transparency
 *  Popup hook handling
 *  Misc. utilities
 *  Child window impl.
 *
 * Search for "BLOCK:" to find major blocks.
 * Search for "SECTION:" to find specific sections.
 *
 * Blocks should be split out into separate files if they
 * become unmanageable.
 *
 * Related source:
 *
 *  nsWindowDefs.h     - Definitions, macros, structs, enums
 *                       and general setup.
 *  nsWindowDbg.h/.cpp - Debug related code and directives.
 *  nsWindowGfx.h/.cpp - Graphics and painting.
 *
 */

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Includes
 **
 ** Include headers.
 **
 **************************************************************
 **************************************************************/

#include "gfx2DGlue.h"
#include "gfxEnv.h"
#include "gfxPlatform.h"
#include "gfxPrefs.h"
#include "mozilla/Logging.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/MiscEvents.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/TouchEvents.h"

#include "mozilla/ipc/MessageChannel.h"
#include <algorithm>
#include <limits>

#include "nsWindow.h"

#include <shellapi.h>
#include <windows.h>
#include <wtsapi32.h>
#include <process.h>
#include <commctrl.h>
#include <unknwn.h>
#include <psapi.h>

#include "mozilla/Logging.h"
#include "prtime.h"
#include "prprf.h"
#include "prmem.h"
#include "prenv.h"

#include "mozilla/WidgetTraceEvent.h"
#include "nsIAppShell.h"
#include "nsISupportsPrimitives.h"
#include "nsIDOMMouseEvent.h"
#include "nsIKeyEventInPluginCallback.h"
#include "nsITheme.h"
#include "nsIObserverService.h"
#include "nsIScreenManager.h"
#include "imgIContainer.h"
#include "nsIFile.h"
#include "nsIRollupListener.h"
#include "nsIServiceManager.h"
#include "nsIClipboard.h"
#include "WinMouseScrollHandler.h"
#include "nsFontMetrics.h"
#include "nsIFontEnumerator.h"
#include "nsFont.h"
#include "nsRect.h"
#include "nsThreadUtils.h"
#include "nsNativeCharsetUtils.h"
#include "nsGkAtoms.h"
#include "nsCRT.h"
#include "nsAppDirectoryServiceDefs.h"
#include "nsXPIDLString.h"
#include "nsWidgetsCID.h"
#include "nsTHashtable.h"
#include "nsHashKeys.h"
#include "nsString.h"
#include "mozilla/Services.h"
#include "nsNativeThemeWin.h"
#include "nsWindowsDllInterceptor.h"
#include "nsLayoutUtils.h"
#include "nsView.h"
#include "nsIWindowMediator.h"
#include "nsIServiceManager.h"
#include "nsWindowGfx.h"
#include "gfxWindowsPlatform.h"
#include "Layers.h"
#include "nsPrintfCString.h"
#include "mozilla/Preferences.h"
#include "nsISound.h"
#include "SystemTimeConverter.h"
#include "WinTaskbar.h"
#include "WidgetUtils.h"
#include "nsIWidgetListener.h"
#include "mozilla/dom/Touch.h"
#include "mozilla/gfx/2D.h"
#include "nsToolkitCompsCID.h"
#include "nsIAppStartup.h"
#include "mozilla/WindowsVersion.h"
#include "mozilla/TextEvents.h" // For WidgetKeyboardEvent
#include "mozilla/TextEventDispatcherListener.h"
#include "mozilla/widget/WinNativeEventData.h"
#include "mozilla/widget/PlatformWidgetTypes.h"
#include "nsThemeConstants.h"
#include "nsBidiKeyboard.h"
#include "nsThemeConstants.h"
#include "gfxConfig.h"
#include "InProcessWinCompositorWidget.h"

#include "nsIGfxInfo.h"
#include "nsUXThemeConstants.h"
#include "KeyboardLayout.h"
#include "nsNativeDragTarget.h"
#include <mmsystem.h> // needed for WIN32_LEAN_AND_MEAN
#include <zmouse.h>
#include <richedit.h>

#if defined(ACCESSIBILITY)

#ifdef DEBUG
#include "mozilla/a11y/Logging.h"
#endif

#include "oleidl.h"
#include <winuser.h>
#include "nsAccessibilityService.h"
#include "mozilla/a11y/DocAccessible.h"
#include "mozilla/a11y/Platform.h"
#if !defined(WINABLEAPI)
#include <winable.h>
#endif // !defined(WINABLEAPI)
#endif // defined(ACCESSIBILITY)

#include "nsIWinTaskbar.h"
#define NS_TASKBAR_CONTRACTID "@mozilla.org/windows-taskbar;1"

#include "nsIWindowsUIUtils.h"

#include "nsWindowDefs.h"

#include "nsCrashOnException.h"
#include "nsIXULRuntime.h"

#include "nsIContent.h"

#include "mozilla/HangMonitor.h"
#include "WinIMEHandler.h"

#include "npapi.h"

#include <d3d11.h>

#include "InkCollector.h"

// ERROR from wingdi.h (below) gets undefined by some code.
// #define ERROR               0
// #define RGN_ERROR ERROR
#define ERROR 0

#if !defined(SM_CONVERTIBLESLATEMODE)
#define SM_CONVERTIBLESLATEMODE 0x2003
#endif

#if !defined(WM_DPICHANGED)
#define WM_DPICHANGED 0x02E0
#endif

#include "mozilla/gfx/DeviceManagerDx.h"
#include "mozilla/layers/APZCTreeManager.h"
#include "mozilla/layers/InputAPZContext.h"
#include "mozilla/layers/ScrollInputMethods.h"
#include "ClientLayerManager.h"
#include "InputData.h"

#include "mozilla/Telemetry.h"

using namespace mozilla;
using namespace mozilla::dom;
using namespace mozilla::gfx;
using namespace mozilla::layers;
using namespace mozilla::widget;

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Variables
 **
 ** nsWindow Class static initializations and global variables. 
 **
 **************************************************************
 **************************************************************/

/**************************************************************
 *
 * SECTION: nsWindow statics
 *
 **************************************************************/

bool            nsWindow::sDropShadowEnabled      = true;
uint32_t        nsWindow::sInstanceCount          = 0;
bool            nsWindow::sSwitchKeyboardLayout   = false;
BOOL            nsWindow::sIsOleInitialized       = FALSE;
HCURSOR         nsWindow::sHCursor                = nullptr;
imgIContainer*  nsWindow::sCursorImgContainer     = nullptr;
nsWindow*       nsWindow::sCurrentWindow          = nullptr;
bool            nsWindow::sJustGotDeactivate      = false;
bool            nsWindow::sJustGotActivate        = false;
bool            nsWindow::sIsInMouseCapture       = false;

// imported in nsWidgetFactory.cpp
TriStateBool    nsWindow::sCanQuit                = TRI_UNKNOWN;

// Hook Data Memebers for Dropdowns. sProcessHook Tells the
// hook methods whether they should be processing the hook
// messages.
HHOOK           nsWindow::sMsgFilterHook          = nullptr;
HHOOK           nsWindow::sCallProcHook           = nullptr;
HHOOK           nsWindow::sCallMouseHook          = nullptr;
bool            nsWindow::sProcessHook            = false;
UINT            nsWindow::sRollupMsgId            = 0;
HWND            nsWindow::sRollupMsgWnd           = nullptr;
UINT            nsWindow::sHookTimerId            = 0;

// Mouse Clicks - static variable definitions for figuring
// out 1 - 3 Clicks.
POINT           nsWindow::sLastMousePoint         = {0};
POINT           nsWindow::sLastMouseMovePoint     = {0};
LONG            nsWindow::sLastMouseDownTime      = 0L;
LONG            nsWindow::sLastClickCount         = 0L;
BYTE            nsWindow::sLastMouseButton        = 0;

// Trim heap on minimize. (initialized, but still true.)
int             nsWindow::sTrimOnMinimize         = 2;

TriStateBool nsWindow::sHasBogusPopupsDropShadowOnMultiMonitor = TRI_UNKNOWN;

WPARAM nsWindow::sMouseExitwParam = 0;
LPARAM nsWindow::sMouseExitlParamScreen = 0;

static SystemTimeConverter<DWORD>&
TimeConverter() {
  static SystemTimeConverter<DWORD> timeConverterSingleton;
  return timeConverterSingleton;
}

namespace mozilla {

class CurrentWindowsTimeGetter {
public:
  CurrentWindowsTimeGetter(HWND aWnd)
    : mWnd(aWnd)
  {
  }

  DWORD GetCurrentTime() const
  {
    return ::GetTickCount();
  }

  void GetTimeAsyncForPossibleBackwardsSkew(const TimeStamp& aNow)
  {
    DWORD currentTime = GetCurrentTime();
    if (sBackwardsSkewStamp && currentTime == sLastPostTime) {
      // There's already one inflight with this timestamp. Don't
      // send a duplicate.
      return;
    }
    sBackwardsSkewStamp = Some(aNow);
    sLastPostTime = currentTime;
    static_assert(sizeof(WPARAM) >= sizeof(DWORD), "Can't fit a DWORD in a WPARAM");
    ::PostMessage(mWnd, MOZ_WM_SKEWFIX, sLastPostTime, 0);
  }

  static bool GetAndClearBackwardsSkewStamp(DWORD aPostTime, TimeStamp* aOutSkewStamp)
  {
    if (aPostTime != sLastPostTime) {
      // The SKEWFIX message is stale; we've sent a new one since then.
      // Ignore this one.
      return false;
    }
    MOZ_ASSERT(sBackwardsSkewStamp);
    *aOutSkewStamp = sBackwardsSkewStamp.value();
    sBackwardsSkewStamp = Nothing();
    return true;
  }

private:
  static Maybe<TimeStamp> sBackwardsSkewStamp;
  static DWORD sLastPostTime;
  HWND mWnd;
};

Maybe<TimeStamp> CurrentWindowsTimeGetter::sBackwardsSkewStamp;
DWORD CurrentWindowsTimeGetter::sLastPostTime = 0;

} // namespace mozilla

/**************************************************************
 *
 * SECTION: globals variables
 *
 **************************************************************/

static const char *sScreenManagerContractID       = "@mozilla.org/gfx/screenmanager;1";

extern mozilla::LazyLogModule gWindowsLog;

// Global used in Show window enumerations.
static bool     gWindowsVisible                   = false;

// True if we have sent a notification that we are suspending/sleeping.
static bool     gIsSleepMode                      = false;

static NS_DEFINE_CID(kCClipboardCID, NS_CLIPBOARD_CID);

// General purpose user32.dll hook object
static WindowsDllInterceptor sUser32Intercept;

// 2 pixel offset for eTransparencyBorderlessGlass which equals the size of
// the default window border Windows paints. Glass will be extended inward
// this distance to remove the border.
static const int32_t kGlassMarginAdjustment = 2;

// When the client area is extended out into the default window frame area,
// this is the minimum amount of space along the edge of resizable windows
// we will always display a resize cursor in, regardless of the underlying
// content.
static const int32_t kResizableBorderMinSize = 3;

// Cached pointer events enabler value, True if pointer events are enabled.
static bool gIsPointerEventsEnabled = false;

// We should never really try to accelerate windows bigger than this. In some
// cases this might lead to no D3D9 acceleration where we could have had it
// but D3D9 does not reliably report when it supports bigger windows. 8192
// is as safe as we can get, we know at least D3D10 hardware always supports
// this, other hardware we expect to report correctly in D3D9.
#define MAX_ACCELERATED_DIMENSION 8192

// On window open (as well as after), Windows has an unfortunate habit of
// sending rather a lot of WM_NCHITTEST messages. Because we have to do point
// to DOM target conversions for these, we cache responses for a given
// coordinate this many milliseconds:
#define HITTEST_CACHE_LIFETIME_MS 50

#if defined(ACCESSIBILITY) && defined(_M_IX86)

namespace mozilla {

/**
 * Windows touchscreen code works by setting a global WH_GETMESSAGE hook and
 * injecting tiptsf.dll. The touchscreen process then posts registered messages
 * to our main thread. The tiptsf hook picks up those registered messages and
 * uses them as commands, some of which call into UIA, which then calls into
 * MSAA, which then sends WM_GETOBJECT to us.
 *
 * We can get ahead of this by installing our own thread-local WH_GETMESSAGE
 * hook. Since thread-local hooks are called ahead of global hooks, we will
 * see these registered messages before tiptsf does. At this point we can then
 * raise a flag that blocks a11y before invoking CallNextHookEx which will then
 * invoke the global tiptsf hook. Then when we see WM_GETOBJECT, we check the
 * flag by calling TIPMessageHandler::IsA11yBlocked().
 *
 * For Windows 8, we also hook tiptsf!ProcessCaretEvents, which is an a11y hook
 * function that also calls into UIA.
 */
class TIPMessageHandler
{
public:
  ~TIPMessageHandler()
  {
    if (mHook) {
      ::UnhookWindowsHookEx(mHook);
    }
  }

  static void Initialize()
  {
    if (!IsWin8OrLater()) {
      return;
    }

    if (sInstance) {
      return;
    }

    sInstance = new TIPMessageHandler();
    ClearOnShutdown(&sInstance);
  }

  static bool IsA11yBlocked()
  {
    if (!sInstance) {
      return false;
    }

    return sInstance->mA11yBlockCount > 0;
  }

private:
  TIPMessageHandler()
    : mHook(nullptr)
    , mA11yBlockCount(0)
  {
    MOZ_ASSERT(NS_IsMainThread());

    // Registered messages used by tiptsf
    mMessages[0] = ::RegisterWindowMessage(L"ImmersiveFocusNotification");
    mMessages[1] = ::RegisterWindowMessage(L"TipCloseMenus");
    mMessages[2] = ::RegisterWindowMessage(L"TabletInputPanelOpening");
    mMessages[3] = ::RegisterWindowMessage(L"IHM Pen or Touch Event noticed");
    mMessages[4] = ::RegisterWindowMessage(L"ProgrammabilityCaretVisibility");
    mMessages[5] = ::RegisterWindowMessage(L"CaretTrackingUpdateIPHidden");
    mMessages[6] = ::RegisterWindowMessage(L"CaretTrackingUpdateIPInfo");

    mHook = ::SetWindowsHookEx(WH_GETMESSAGE, &TIPHook, nullptr,
                               ::GetCurrentThreadId());
    MOZ_ASSERT(mHook);

    // On touchscreen devices, tiptsf.dll will have been loaded when STA COM was
    // first initialized.
    if (!IsWin10OrLater() && GetModuleHandle(L"tiptsf.dll") &&
        !sProcessCaretEventsStub) {
      sTipTsfInterceptor.Init("tiptsf.dll");
      DebugOnly<bool> ok = sTipTsfInterceptor.AddHook("ProcessCaretEvents",
          reinterpret_cast<intptr_t>(&ProcessCaretEventsHook),
          (void**) &sProcessCaretEventsStub);
      MOZ_ASSERT(ok);
    }

    if (!sSendMessageTimeoutWStub) {
      sUser32Intercept.Init("user32.dll");
      DebugOnly<bool> hooked = sUser32Intercept.AddHook("SendMessageTimeoutW",
          reinterpret_cast<intptr_t>(&SendMessageTimeoutWHook),
          (void**) &sSendMessageTimeoutWStub);
      MOZ_ASSERT(hooked);
    }
  }

  class MOZ_RAII A11yInstantiationBlocker
  {
  public:
    A11yInstantiationBlocker()
    {
      if (!TIPMessageHandler::sInstance) {
        return;
      }
      ++TIPMessageHandler::sInstance->mA11yBlockCount;
    }

    ~A11yInstantiationBlocker()
    {
      if (!TIPMessageHandler::sInstance) {
        return;
      }
      MOZ_ASSERT(TIPMessageHandler::sInstance->mA11yBlockCount > 0);
      --TIPMessageHandler::sInstance->mA11yBlockCount;
    }
  };

  friend class A11yInstantiationBlocker;

  static LRESULT CALLBACK TIPHook(int aCode, WPARAM aWParam, LPARAM aLParam)
  {
    if (aCode < 0 || !sInstance) {
      return ::CallNextHookEx(nullptr, aCode, aWParam, aLParam);
    }

    MSG* msg = reinterpret_cast<MSG*>(aLParam);
    UINT& msgCode = msg->message;

    for (uint32_t i = 0; i < ArrayLength(sInstance->mMessages); ++i) {
      if (msgCode == sInstance->mMessages[i]) {
        A11yInstantiationBlocker block;
        return ::CallNextHookEx(nullptr, aCode, aWParam, aLParam);
      }
    }

    return ::CallNextHookEx(nullptr, aCode, aWParam, aLParam);
  }

  static void CALLBACK ProcessCaretEventsHook(HWINEVENTHOOK aWinEventHook,
                                              DWORD aEvent, HWND aHwnd,
                                              LONG aObjectId, LONG aChildId,
                                              DWORD aGeneratingTid,
                                              DWORD aEventTime)
  {
    A11yInstantiationBlocker block;
    sProcessCaretEventsStub(aWinEventHook, aEvent, aHwnd, aObjectId, aChildId,
                            aGeneratingTid, aEventTime);
  }

  static LRESULT WINAPI SendMessageTimeoutWHook(HWND aHwnd, UINT aMsgCode,
                                                WPARAM aWParam, LPARAM aLParam,
                                                UINT aFlags, UINT aTimeout,
                                                PDWORD_PTR aMsgResult)
  {
    // We don't want to handle this unless the message is a WM_GETOBJECT that we
    // want to block, and the aHwnd is a nsWindow that belongs to the current
    // thread.
    if (!aMsgResult || aMsgCode != WM_GETOBJECT || aLParam != OBJID_CLIENT ||
        !WinUtils::GetNSWindowPtr(aHwnd) ||
        ::GetWindowThreadProcessId(aHwnd, nullptr) != ::GetCurrentThreadId() ||
        !IsA11yBlocked()) {
      return sSendMessageTimeoutWStub(aHwnd, aMsgCode, aWParam, aLParam,
                                      aFlags, aTimeout, aMsgResult);
    }

    // In this case we want to fake the result that would happen if we had
    // decided not to handle WM_GETOBJECT in our WndProc. We hand the message
    // off to DefWindowProc to accomplish this.
    *aMsgResult = static_cast<DWORD_PTR>(::DefWindowProcW(aHwnd, aMsgCode,
                                                          aWParam, aLParam));

    return static_cast<LRESULT>(TRUE);
  }

  static WindowsDllInterceptor sTipTsfInterceptor;
  static WINEVENTPROC sProcessCaretEventsStub;
  static decltype(&SendMessageTimeoutW) sSendMessageTimeoutWStub;
  static StaticAutoPtr<TIPMessageHandler> sInstance;

  HHOOK                 mHook;
  UINT                  mMessages[7];
  uint32_t              mA11yBlockCount;
};

WindowsDllInterceptor TIPMessageHandler::sTipTsfInterceptor;
WINEVENTPROC TIPMessageHandler::sProcessCaretEventsStub;
decltype(&SendMessageTimeoutW) TIPMessageHandler::sSendMessageTimeoutWStub;
StaticAutoPtr<TIPMessageHandler> TIPMessageHandler::sInstance;

} // namespace mozilla

#endif // defined(ACCESSIBILITY) && defined(_M_IX86)

/**************************************************************
 **************************************************************
 **
 ** BLOCK: nsIWidget impl.
 **
 ** nsIWidget interface implementation, broken down into
 ** sections.
 **
 **************************************************************
 **************************************************************/

/**************************************************************
 *
 * SECTION: nsWindow construction and destruction
 *
 **************************************************************/

nsWindow::nsWindow()
  : nsWindowBase()
  , mResizeState(NOT_RESIZING)
{
  mIconSmall            = nullptr;
  mIconBig              = nullptr;
  mWnd                  = nullptr;
  mTransitionWnd        = nullptr;
  mPaintDC              = nullptr;
  mPrevWndProc          = nullptr;
  mNativeDragTarget     = nullptr;
  mInDtor               = false;
  mIsVisible            = false;
  mIsTopWidgetWindow    = false;
  mUnicodeWidget        = true;
  mDisplayPanFeedback   = false;
  mTouchWindow          = false;
  mFutureMarginsToUse   = false;
  mCustomNonClient      = false;
  mHideChrome           = false;
  mFullscreenMode       = false;
  mMousePresent         = false;
  mDestroyCalled        = false;
  mHasTaskbarIconBeenCreated = false;
  mMouseTransparent     = false;
  mPickerDisplayCount   = 0;
  mWindowType           = eWindowType_child;
  mBorderStyle          = eBorderStyle_default;
  mOldSizeMode          = nsSizeMode_Normal;
  mLastSizeMode         = nsSizeMode_Normal;
  mLastSize.width       = 0;
  mLastSize.height      = 0;
  mOldStyle             = 0;
  mOldExStyle           = 0;
  mPainting             = 0;
  mLastKeyboardLayout   = 0;
  mBlurSuppressLevel    = 0;
  mLastPaintEndTime     = TimeStamp::Now();
  mCachedHitTestPoint.x = 0;
  mCachedHitTestPoint.y = 0;
  mCachedHitTestTime    = TimeStamp::Now();
  mCachedHitTestResult  = 0;
#ifdef MOZ_XUL
  mTransparencyMode     = eTransparencyOpaque;
  memset(&mGlassMargins, 0, sizeof mGlassMargins);
#endif
  DWORD background      = ::GetSysColor(COLOR_BTNFACE);
  mBrush                = ::CreateSolidBrush(NSRGB_2_COLOREF(background));
  mSendingSetText       = false;
  mDefaultScale         = -1.0; // not yet set, will be calculated on first use

  mTaskbarPreview = nullptr;

  // Global initialization
  if (!sInstanceCount) {
    // Global app registration id for Win7 and up. See
    // WinTaskbar.cpp for details.
    mozilla::widget::WinTaskbar::RegisterAppUserModelID();
    KeyboardLayout::GetInstance()->OnLayoutChange(::GetKeyboardLayout(0));
#if defined(ACCESSIBILITY) && defined(_M_IX86)
    mozilla::TIPMessageHandler::Initialize();
#endif // defined(ACCESSIBILITY) && defined(_M_IX86)
    IMEHandler::Initialize();
    if (SUCCEEDED(::OleInitialize(nullptr))) {
      sIsOleInitialized = TRUE;
    }
    NS_ASSERTION(sIsOleInitialized, "***** OLE is not initialized!\n");
    MouseScrollHandler::Initialize();
    // Init titlebar button info for custom frames.
    nsUXThemeData::InitTitlebarInfo();
    // Init theme data
    nsUXThemeData::UpdateNativeThemeInfo();
    RedirectedKeyDownMessageManager::Forget();
    InkCollector::sInkCollector = new InkCollector();

    Preferences::AddBoolVarCache(&gIsPointerEventsEnabled,
                                 "dom.w3c_pointer_events.enabled",
                                 gIsPointerEventsEnabled);
  } // !sInstanceCount

  mIdleService = nullptr;

  mSizeConstraintsScale = GetDefaultScale().scale;

  sInstanceCount++;
}

nsWindow::~nsWindow()
{
  mInDtor = true;

  // If the widget was released without calling Destroy() then the native window still
  // exists, and we need to destroy it.
  // Destroy() will early-return if it was already called. In any case it is important
  // to call it before destroying mPresentLock (cf. 1156182).
  Destroy();

  // Free app icon resources.  This must happen after `OnDestroy` (see bug 708033).
  if (mIconSmall)
    ::DestroyIcon(mIconSmall);

  if (mIconBig)
    ::DestroyIcon(mIconBig);

  sInstanceCount--;

  // Global shutdown
  if (sInstanceCount == 0) {
    InkCollector::sInkCollector->Shutdown();
    InkCollector::sInkCollector = nullptr;
    IMEHandler::Terminate();
    NS_IF_RELEASE(sCursorImgContainer);
    if (sIsOleInitialized) {
      ::OleFlushClipboard();
      ::OleUninitialize();
      sIsOleInitialized = FALSE;
    }
  }

  NS_IF_RELEASE(mNativeDragTarget);
}

NS_IMPL_ISUPPORTS_INHERITED0(nsWindow, nsBaseWidget)

/**************************************************************
 *
 * SECTION: nsIWidget::Create, nsIWidget::Destroy
 *
 * Creating and destroying windows for this widget.
 *
 **************************************************************/

// Allow Derived classes to modify the height that is passed
// when the window is created or resized.
int32_t nsWindow::GetHeight(int32_t aProposedHeight)
{
  return aProposedHeight;
}

static bool
ShouldCacheTitleBarInfo(nsWindowType aWindowType, nsBorderStyle aBorderStyle)
{
  return (aWindowType == eWindowType_toplevel)  &&
         (aBorderStyle == eBorderStyle_default  ||
            aBorderStyle == eBorderStyle_all)   &&
      (!nsUXThemeData::sTitlebarInfoPopulatedThemed ||
       !nsUXThemeData::sTitlebarInfoPopulatedAero);
}

// Create the proper widget
nsresult
nsWindow::Create(nsIWidget* aParent,
                 nsNativeWidget aNativeParent,
                 const LayoutDeviceIntRect& aRect,
                 nsWidgetInitData* aInitData)
{
  nsWidgetInitData defaultInitData;
  if (!aInitData)
    aInitData = &defaultInitData;

  mUnicodeWidget = aInitData->mUnicode;

  nsIWidget *baseParent = aInitData->mWindowType == eWindowType_dialog ||
                          aInitData->mWindowType == eWindowType_toplevel ||
                          aInitData->mWindowType == eWindowType_invisible ?
                          nullptr : aParent;

  mIsTopWidgetWindow = (nullptr == baseParent);
  mBounds = aRect;

  // Ensure that the toolkit is created.
  nsToolkit::GetToolkit();

  BaseCreate(baseParent, aInitData);

  HWND parent;
  if (aParent) { // has a nsIWidget parent
    parent = aParent ? (HWND)aParent->GetNativeData(NS_NATIVE_WINDOW) : nullptr;
    mParent = aParent;
  } else { // has a nsNative parent
    parent = (HWND)aNativeParent;
    mParent = aNativeParent ?
      WinUtils::GetNSWindowPtr((HWND)aNativeParent) : nullptr;
  }

  mIsRTL = aInitData->mRTL;

  DWORD style = WindowStyle();
  DWORD extendedStyle = WindowExStyle();

  if (mWindowType == eWindowType_popup) {
    if (!aParent) {
      parent = nullptr;
    }

    if (IsVistaOrLater() && !IsWin8OrLater() &&
        HasBogusPopupsDropShadowOnMultiMonitor()) {
      extendedStyle |= WS_EX_COMPOSITED;
    }

    if (aInitData->mMouseTransparent) {
      // This flag makes the window transparent to mouse events
      mMouseTransparent = true;
      extendedStyle |= WS_EX_TRANSPARENT;
    }
  } else if (mWindowType == eWindowType_invisible) {
    // Make sure CreateWindowEx succeeds at creating a toplevel window
    style &= ~0x40000000; // WS_CHILDWINDOW
  } else {
    // See if the caller wants to explictly set clip children and clip siblings
    if (aInitData->clipChildren) {
      style |= WS_CLIPCHILDREN;
    } else {
      style &= ~WS_CLIPCHILDREN;
    }
    if (aInitData->clipSiblings) {
      style |= WS_CLIPSIBLINGS;
    }
  }

  const wchar_t* className;
  if (aInitData->mDropShadow) {
    className = GetWindowPopupClass();
  } else {
    className = GetWindowClass();
  }
  // Plugins are created in the disabled state so that they can't
  // steal focus away from our main window.  This is especially
  // important if the plugin has loaded in a background tab.
  if (aInitData->mWindowType == eWindowType_plugin ||
      aInitData->mWindowType == eWindowType_plugin_ipc_chrome ||
      aInitData->mWindowType == eWindowType_plugin_ipc_content) {
    style |= WS_DISABLED;
  }
  mWnd = ::CreateWindowExW(extendedStyle,
                           className,
                           L"",
                           style,
                           aRect.x,
                           aRect.y,
                           aRect.width,
                           GetHeight(aRect.height),
                           parent,
                           nullptr,
                           nsToolkit::mDllInstance,
                           nullptr);

  if (!mWnd) {
    NS_WARNING("nsWindow CreateWindowEx failed.");
    return NS_ERROR_FAILURE;
  }

  if (mIsRTL && WinUtils::dwmSetWindowAttributePtr) {
    DWORD dwAttribute = TRUE;    
    WinUtils::dwmSetWindowAttributePtr(mWnd, DWMWA_NONCLIENT_RTL_LAYOUT, &dwAttribute, sizeof dwAttribute);
  }

  if (!IsPlugin() &&
      mWindowType != eWindowType_invisible &&
      MouseScrollHandler::Device::IsFakeScrollableWindowNeeded()) {
    // Ugly Thinkpad Driver Hack (Bugs 507222 and 594977)
    //
    // We create two zero-sized windows as descendants of the top-level window,
    // like so:
    //
    //   Top-level window (MozillaWindowClass)
    //     FAKETRACKPOINTSCROLLCONTAINER (MozillaWindowClass)
    //       FAKETRACKPOINTSCROLLABLE (MozillaWindowClass)
    //
    // We need to have the middle window, otherwise the Trackpoint driver
    // will fail to deliver scroll messages.  WM_MOUSEWHEEL messages are
    // sent to the FAKETRACKPOINTSCROLLABLE, which then propagate up the
    // window hierarchy until they are handled by nsWindow::WindowProc.
    // WM_HSCROLL messages are also sent to the FAKETRACKPOINTSCROLLABLE,
    // but these do not propagate automatically, so we have the window
    // procedure pretend that they were dispatched to the top-level window
    // instead.
    //
    // The FAKETRACKPOINTSCROLLABLE needs to have the specific window styles it
    // is given below so that it catches the Trackpoint driver's heuristics.
    HWND scrollContainerWnd = ::CreateWindowW
      (className, L"FAKETRACKPOINTSCROLLCONTAINER",
       WS_CHILD | WS_VISIBLE,
       0, 0, 0, 0, mWnd, nullptr, nsToolkit::mDllInstance, nullptr);
    HWND scrollableWnd = ::CreateWindowW
      (className, L"FAKETRACKPOINTSCROLLABLE",
       WS_CHILD | WS_VISIBLE | WS_VSCROLL | WS_TABSTOP | 0x30,
       0, 0, 0, 0, scrollContainerWnd, nullptr, nsToolkit::mDllInstance,
       nullptr);

    // Give the FAKETRACKPOINTSCROLLABLE window a specific ID so that
    // WindowProcInternal can distinguish it from the top-level window
    // easily.
    ::SetWindowLongPtrW(scrollableWnd, GWLP_ID, eFakeTrackPointScrollableID);

    // Make FAKETRACKPOINTSCROLLABLE use nsWindow::WindowProc, and store the
    // old window procedure in its "user data".
    WNDPROC oldWndProc;
    if (mUnicodeWidget)
      oldWndProc = (WNDPROC)::SetWindowLongPtrW(scrollableWnd, GWLP_WNDPROC,
                                                (LONG_PTR)nsWindow::WindowProc);
    else
      oldWndProc = (WNDPROC)::SetWindowLongPtrA(scrollableWnd, GWLP_WNDPROC,
                                                (LONG_PTR)nsWindow::WindowProc);
    ::SetWindowLongPtrW(scrollableWnd, GWLP_USERDATA, (LONG_PTR)oldWndProc);
  }

  SubclassWindow(TRUE);

  // Starting with Windows XP, a process always runs within a terminal services
  // session. In order to play nicely with RDP, fast user switching, and the
  // lock screen, we should be handling WM_WTSSESSION_CHANGE. We must register
  // our HWND in order to receive this message.
  DebugOnly<BOOL> wtsRegistered = ::WTSRegisterSessionNotification(mWnd,
                                                       NOTIFY_FOR_THIS_SESSION);
  NS_ASSERTION(wtsRegistered, "WTSRegisterSessionNotification failed!\n");

  mDefaultIMC.Init(this);
  IMEHandler::InitInputContext(this, mInputContext);

  // If the internal variable set by the config.trim_on_minimize pref has not
  // been initialized, and if this is the hidden window (conveniently created
  // before any visible windows, and after the profile has been initialized),
  // do some initialization work.
  if (sTrimOnMinimize == 2 && mWindowType == eWindowType_invisible) {
    // Our internal trim prevention logic is effective on 2K/XP at maintaining
    // the working set when windows are minimized, but on Vista and up it has
    // little to no effect. Since this feature has been the source of numerous
    // bugs over the years, disable it (sTrimOnMinimize=1) on Vista and up.
    sTrimOnMinimize =
      Preferences::GetBool("config.trim_on_minimize",
        IsVistaOrLater() ? 1 : 0);
    sSwitchKeyboardLayout =
      Preferences::GetBool("intl.keyboard.per_window_layout", false);
  }

  // Query for command button metric data for rendering the titlebar. We
  // only do this once on the first window that has an actual titlebar
  if (ShouldCacheTitleBarInfo(mWindowType, mBorderStyle)) {
    nsUXThemeData::UpdateTitlebarInfo(mWnd);
  }

  return NS_OK;
}

// Close this nsWindow
void nsWindow::Destroy()
{
  // WM_DESTROY has already fired, avoid calling it twice
  if (mOnDestroyCalled)
    return;

  // Don't destroy windows that have file pickers open, we'll tear these down
  // later once the picker is closed.
  mDestroyCalled = true;
  if (mPickerDisplayCount)
    return;

  // During the destruction of all of our children, make sure we don't get deleted.
  nsCOMPtr<nsIWidget> kungFuDeathGrip(this);

  /**
   * On windows the LayerManagerOGL destructor wants the widget to be around for
   * cleanup. It also would like to have the HWND intact, so we nullptr it here.
   */
  DestroyLayerManager();

  /* We should clear our cached resources now and not wait for the GC to
   * delete the nsWindow. */
  ClearCachedResources();

  // The DestroyWindow function destroys the specified window. The function sends WM_DESTROY
  // and WM_NCDESTROY messages to the window to deactivate it and remove the keyboard focus
  // from it. The function also destroys the window's menu, flushes the thread message queue,
  // destroys timers, removes clipboard ownership, and breaks the clipboard viewer chain (if
  // the window is at the top of the viewer chain).
  //
  // If the specified window is a parent or owner window, DestroyWindow automatically destroys
  // the associated child or owned windows when it destroys the parent or owner window. The
  // function first destroys child or owned windows, and then it destroys the parent or owner
  // window.
  VERIFY(::DestroyWindow(mWnd));
  
  // Our windows can be subclassed which may prevent us receiving WM_DESTROY. If OnDestroy()
  // didn't get called, call it now.
  if (false == mOnDestroyCalled) {
    MSGResult msgResult;
    mWindowHook.Notify(mWnd, WM_DESTROY, 0, 0, msgResult);
    OnDestroy();
  }
}

/**************************************************************
 *
 * SECTION: Window class utilities
 *
 * Utilities for calculating the proper window class name for
 * Create window.
 *
 **************************************************************/

const wchar_t*
nsWindow::RegisterWindowClass(const wchar_t* aClassName,
                              UINT aExtraStyle, LPWSTR aIconID) const
{
  WNDCLASSW wc;
  if (::GetClassInfoW(nsToolkit::mDllInstance, aClassName, &wc)) {
    // already registered
    return aClassName;
  }

  wc.style         = CS_DBLCLKS | aExtraStyle;
  wc.lpfnWndProc   = WinUtils::NonClientDpiScalingDefWindowProcW;
  wc.cbClsExtra    = 0;
  wc.cbWndExtra    = 0;
  wc.hInstance     = nsToolkit::mDllInstance;
  wc.hIcon         = aIconID ? ::LoadIconW(::GetModuleHandleW(nullptr), aIconID) : nullptr;
  wc.hCursor       = nullptr;
  wc.hbrBackground = mBrush;
  wc.lpszMenuName  = nullptr;
  wc.lpszClassName = aClassName;

  if (!::RegisterClassW(&wc)) {
    // For older versions of Win32 (i.e., not XP), the registration may
    // fail with aExtraStyle, so we have to re-register without it.
    wc.style = CS_DBLCLKS;
    ::RegisterClassW(&wc);
  }
  return aClassName;
}

static LPWSTR const gStockApplicationIcon = MAKEINTRESOURCEW(32512);

// Return the proper window class for everything except popups.
const wchar_t*
nsWindow::GetWindowClass() const
{
  switch (mWindowType) {
  case eWindowType_invisible:
    return RegisterWindowClass(kClassNameHidden, 0, gStockApplicationIcon);
  case eWindowType_dialog:
    return RegisterWindowClass(kClassNameDialog, 0, 0);
  default:
    return RegisterWindowClass(GetMainWindowClass(), 0, gStockApplicationIcon);
  }
}

// Return the proper popup window class
const wchar_t*
nsWindow::GetWindowPopupClass() const
{
  return RegisterWindowClass(kClassNameDropShadow,
                             CS_XP_DROPSHADOW, gStockApplicationIcon);
}

/**************************************************************
 *
 * SECTION: Window styles utilities
 *
 * Return the proper windows styles and extended styles.
 *
 **************************************************************/

// Return nsWindow styles
DWORD nsWindow::WindowStyle()
{
  DWORD style;

  switch (mWindowType) {
    case eWindowType_plugin:
    case eWindowType_plugin_ipc_chrome:
    case eWindowType_plugin_ipc_content:
    case eWindowType_child:
      style = WS_OVERLAPPED;
      break;

    case eWindowType_dialog:
      style = WS_OVERLAPPED | WS_BORDER | WS_DLGFRAME | WS_SYSMENU | DS_3DLOOK |
              DS_MODALFRAME | WS_CLIPCHILDREN;
      if (mBorderStyle != eBorderStyle_default)
        style |= WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
      break;

    case eWindowType_popup:
      style = WS_POPUP;
      if (!HasGlass()) {
        style |= WS_OVERLAPPED;
      }
      break;

    default:
      NS_ERROR("unknown border style");
      // fall through

    case eWindowType_toplevel:
    case eWindowType_invisible:
      style = WS_OVERLAPPED | WS_BORDER | WS_DLGFRAME | WS_SYSMENU |
              WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_CLIPCHILDREN;
      break;
  }

  if (mBorderStyle != eBorderStyle_default && mBorderStyle != eBorderStyle_all) {
    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_border))
      style &= ~WS_BORDER;

    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_title)) {
      style &= ~WS_DLGFRAME;
      style |= WS_POPUP;
      style &= ~WS_CHILD;
    }

    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_close))
      style &= ~0;
    // XXX The close box can only be removed by changing the window class,
    // as far as I know   --- roc+moz@cs.cmu.edu

    if (mBorderStyle == eBorderStyle_none ||
      !(mBorderStyle & (eBorderStyle_menu | eBorderStyle_close)))
      style &= ~WS_SYSMENU;
    // Looks like getting rid of the system menu also does away with the
    // close box. So, we only get rid of the system menu if you want neither it
    // nor the close box. How does the Windows "Dialog" window class get just
    // closebox and no sysmenu? Who knows.

    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_resizeh))
      style &= ~WS_THICKFRAME;

    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_minimize))
      style &= ~WS_MINIMIZEBOX;

    if (mBorderStyle == eBorderStyle_none || !(mBorderStyle & eBorderStyle_maximize))
      style &= ~WS_MAXIMIZEBOX;

    if (IsPopupWithTitleBar()) {
      style |= WS_CAPTION;
      if (mBorderStyle & eBorderStyle_close) {
        style |= WS_SYSMENU;
      }
    }
  }

  VERIFY_WINDOW_STYLE(style);
  return style;
}

// Return nsWindow extended styles
DWORD nsWindow::WindowExStyle()
{
  switch (mWindowType)
  {
    case eWindowType_plugin:
    case eWindowType_plugin_ipc_chrome:
    case eWindowType_plugin_ipc_content:
    case eWindowType_child:
      return 0;

    case eWindowType_dialog:
      return WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;

    case eWindowType_popup:
    {
      DWORD extendedStyle = WS_EX_TOOLWINDOW;
      if (mPopupLevel == ePopupLevelTop)
        extendedStyle |= WS_EX_TOPMOST;
      return extendedStyle;
    }
    default:
      NS_ERROR("unknown border style");
      // fall through

    case eWindowType_toplevel:
    case eWindowType_invisible:
      return WS_EX_WINDOWEDGE;
  }
}

/**************************************************************
 *
 * SECTION: Window subclassing utilities
 *
 * Set or clear window subclasses on native windows. Used in
 * Create and Destroy.
 *
 **************************************************************/

// Subclass (or remove the subclass from) this component's nsWindow
void nsWindow::SubclassWindow(BOOL bState)
{
  if (bState) {
    if (!mWnd || !IsWindow(mWnd)) {
      NS_ERROR("Invalid window handle");
    }

    if (mUnicodeWidget) {
      mPrevWndProc =
        reinterpret_cast<WNDPROC>(
          SetWindowLongPtrW(mWnd,
                            GWLP_WNDPROC,
                            reinterpret_cast<LONG_PTR>(nsWindow::WindowProc)));
    } else {
      mPrevWndProc =
        reinterpret_cast<WNDPROC>(
          SetWindowLongPtrA(mWnd,
                            GWLP_WNDPROC,
                            reinterpret_cast<LONG_PTR>(nsWindow::WindowProc)));
    }
    NS_ASSERTION(mPrevWndProc, "Null standard window procedure");
    // connect the this pointer to the nsWindow handle
    WinUtils::SetNSWindowBasePtr(mWnd, this);
  } else {
    if (IsWindow(mWnd)) {
      if (mUnicodeWidget) {
        SetWindowLongPtrW(mWnd,
                          GWLP_WNDPROC,
                          reinterpret_cast<LONG_PTR>(mPrevWndProc));
      } else {
        SetWindowLongPtrA(mWnd,
                          GWLP_WNDPROC,
                          reinterpret_cast<LONG_PTR>(mPrevWndProc));
      }
    }
    WinUtils::SetNSWindowBasePtr(mWnd, nullptr);
    mPrevWndProc = nullptr;
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::SetParent, nsIWidget::GetParent
 *
 * Set or clear the parent widgets using window properties, and
 * handles calculating native parent handles.
 *
 **************************************************************/

// Get and set parent widgets
NS_IMETHODIMP nsWindow::SetParent(nsIWidget *aNewParent)
{
  mParent = aNewParent;

  nsCOMPtr<nsIWidget> kungFuDeathGrip(this);
  nsIWidget* parent = GetParent();
  if (parent) {
    parent->RemoveChild(this);
  }
  if (aNewParent) {
    ReparentNativeWidget(aNewParent);
    aNewParent->AddChild(this);
    return NS_OK;
  }
  if (mWnd) {
    // If we have no parent, SetParent should return the desktop.
    VERIFY(::SetParent(mWnd, nullptr));
  }
  return NS_OK;
}

void
nsWindow::ReparentNativeWidget(nsIWidget* aNewParent)
{
  NS_PRECONDITION(aNewParent, "");

  mParent = aNewParent;
  if (mWindowType == eWindowType_popup) {
    return;
  }
  HWND newParent = (HWND)aNewParent->GetNativeData(NS_NATIVE_WINDOW);
  NS_ASSERTION(newParent, "Parent widget has a null native window handle");
  if (newParent && mWnd) {
    ::SetParent(mWnd, newParent);
  }
}

nsIWidget* nsWindow::GetParent(void)
{
  return GetParentWindow(false);
}

static int32_t RoundDown(double aDouble)
{
  return aDouble > 0 ? static_cast<int32_t>(floor(aDouble)) :
                       static_cast<int32_t>(ceil(aDouble));
}

float nsWindow::GetDPI()
{
  HDC dc = ::GetDC(mWnd);
  if (!dc)
    return 96.0f;

  double heightInches = ::GetDeviceCaps(dc, VERTSIZE)/MM_PER_INCH_FLOAT;
  int heightPx = ::GetDeviceCaps(dc, VERTRES);
  ::ReleaseDC(mWnd, dc);
  if (heightInches < 0.25) {
    // Something's broken
    return 96.0f;
  }
  return float(heightPx/heightInches);
}

double nsWindow::GetDefaultScaleInternal()
{
  if (mDefaultScale <= 0.0) {
    mDefaultScale = WinUtils::LogToPhysFactor(mWnd);
  }
  return mDefaultScale;
}

int32_t nsWindow::LogToPhys(double aValue)
{
  return WinUtils::LogToPhys(::MonitorFromWindow(mWnd,
                                                 MONITOR_DEFAULTTOPRIMARY),
                             aValue);
}

nsWindow*
nsWindow::GetParentWindow(bool aIncludeOwner)
{
  return static_cast<nsWindow*>(GetParentWindowBase(aIncludeOwner));
}

nsWindowBase*
nsWindow::GetParentWindowBase(bool aIncludeOwner)
{
  if (mIsTopWidgetWindow) {
    // Must use a flag instead of mWindowType to tell if the window is the
    // owned by the topmost widget, because a child window can be embedded inside
    // a HWND which is not associated with a nsIWidget.
    return nullptr;
  }

  // If this widget has already been destroyed, pretend we have no parent.
  // This corresponds to code in Destroy which removes the destroyed
  // widget from its parent's child list.
  if (mInDtor || mOnDestroyCalled)
    return nullptr;


  // aIncludeOwner set to true implies walking the parent chain to retrieve the
  // root owner. aIncludeOwner set to false implies the search will stop at the
  // true parent (default).
  nsWindow* widget = nullptr;
  if (mWnd) {
    HWND parent = nullptr;
    if (aIncludeOwner)
      parent = ::GetParent(mWnd);
    else
      parent = ::GetAncestor(mWnd, GA_PARENT);

    if (parent) {
      widget = WinUtils::GetNSWindowPtr(parent);
      if (widget) {
        // If the widget is in the process of being destroyed then
        // do NOT return it
        if (widget->mInDtor) {
          widget = nullptr;
        }
      }
    }
  }

  return static_cast<nsWindowBase*>(widget);
}
 
BOOL CALLBACK
nsWindow::EnumAllChildWindProc(HWND aWnd, LPARAM aParam)
{
  nsWindow *wnd = WinUtils::GetNSWindowPtr(aWnd);
  if (wnd) {
    ((nsWindow::WindowEnumCallback*)aParam)(wnd);
  }
  return TRUE;
}

BOOL CALLBACK
nsWindow::EnumAllThreadWindowProc(HWND aWnd, LPARAM aParam)
{
  nsWindow *wnd = WinUtils::GetNSWindowPtr(aWnd);
  if (wnd) {
    ((nsWindow::WindowEnumCallback*)aParam)(wnd);
  }
  EnumChildWindows(aWnd, EnumAllChildWindProc, aParam);
  return TRUE;
}

void
nsWindow::EnumAllWindows(WindowEnumCallback aCallback)
{
  EnumThreadWindows(GetCurrentThreadId(),
                    EnumAllThreadWindowProc,
                    (LPARAM)aCallback);
}

static already_AddRefed<SourceSurface>
CreateSourceSurfaceForGfxSurface(gfxASurface* aSurface)
{
  MOZ_ASSERT(aSurface);
  return Factory::CreateSourceSurfaceForCairoSurface(
           aSurface->CairoSurface(), aSurface->GetSize(),
           aSurface->GetSurfaceFormat());
}

nsWindow::ScrollSnapshot*
nsWindow::EnsureSnapshotSurface(ScrollSnapshot& aSnapshotData,
                                const mozilla::gfx::IntSize& aSize)
{
  // If the surface doesn't exist or is the wrong size then create new one.
  if (!aSnapshotData.surface || aSnapshotData.surface->GetSize() != aSize) {
    aSnapshotData.surface = new gfxWindowsSurface(aSize, kScrollCaptureFormat);
    aSnapshotData.surfaceHasSnapshot = false;
  }

  return &aSnapshotData;
}

already_AddRefed<SourceSurface>
nsWindow::CreateScrollSnapshot()
{
  RECT clip = { 0 };
  int rgnType = ::GetWindowRgnBox(mWnd, &clip);
  if (rgnType == RGN_ERROR) {
    // We failed to get the clip assume that we need a full fallback.
    clip.left = 0;
    clip.top = 0;
    clip.right = mBounds.width;
    clip.bottom = mBounds.height;
    return GetFallbackScrollSnapshot(clip);
  }

  // Check that the window is in a position to snapshot. We don't check for
  // clipped width as that doesn't currently matter for APZ scrolling.
  if (clip.top || clip.bottom != mBounds.height) {
    return GetFallbackScrollSnapshot(clip);
  }

  HDC windowDC = ::GetDC(mWnd);
  if (!windowDC) {
    return GetFallbackScrollSnapshot(clip);
  }
  auto releaseDC = MakeScopeExit([&] {
    ::ReleaseDC(mWnd, windowDC);
  });

  gfx::IntSize snapshotSize(mBounds.width, mBounds.height);
  ScrollSnapshot* snapshot;
  if (clip.left || clip.right != mBounds.width) {
    // Can't do a full snapshot, so use the partial snapshot.
    snapshot = EnsureSnapshotSurface(mPartialSnapshot, snapshotSize);
  } else {
    snapshot = EnsureSnapshotSurface(mFullSnapshot, snapshotSize);
  }

  // Note that we know that the clip is full height.
  if (!::BitBlt(snapshot->surface->GetDC(), clip.left, 0, clip.right - clip.left,
                clip.bottom, windowDC, clip.left, 0, SRCCOPY)) {
    return GetFallbackScrollSnapshot(clip);
  }
  ::GdiFlush();
  snapshot->surface->Flush();
  snapshot->surfaceHasSnapshot = true;
  snapshot->clip = clip;
  mCurrentSnapshot = snapshot;

  return CreateSourceSurfaceForGfxSurface(mCurrentSnapshot->surface);
}

already_AddRefed<SourceSurface>
nsWindow::GetFallbackScrollSnapshot(const RECT& aRequiredClip)
{
  gfx::IntSize snapshotSize(mBounds.width, mBounds.height);

  // If the current snapshot is the correct size and covers the required clip,
  // just keep that by returning null.
  // Note: we know the clip is always full height.
  if (mCurrentSnapshot &&
      mCurrentSnapshot->surface->GetSize() == snapshotSize &&
      mCurrentSnapshot->clip.left <= aRequiredClip.left &&
      mCurrentSnapshot->clip.right >= aRequiredClip.right) {
    return nullptr;
  }

  // Otherwise we'll use the full snapshot, making sure it is big enough first.
  mCurrentSnapshot = EnsureSnapshotSurface(mFullSnapshot, snapshotSize);

  // If there is no snapshot, create a default.
  if (!mCurrentSnapshot->surfaceHasSnapshot) {
    gfx::SurfaceFormat format = mCurrentSnapshot->surface->GetSurfaceFormat();
    RefPtr<DrawTarget> dt = Factory::CreateDrawTargetForCairoSurface(
      mCurrentSnapshot->surface->CairoSurface(),
      mCurrentSnapshot->surface->GetSize(), &format);

    DefaultFillScrollCapture(dt);
  }

  return CreateSourceSurfaceForGfxSurface(mCurrentSnapshot->surface);
}

/**************************************************************
 *
 * SECTION: nsIWidget::Show
 *
 * Hide or show this component.
 *
 **************************************************************/

NS_IMETHODIMP nsWindow::Show(bool bState)
{
  if (mWindowType == eWindowType_popup) {
    // See bug 603793. When we try to draw D3D9/10 windows with a drop shadow
    // without the DWM on a secondary monitor, windows fails to composite
    // our windows correctly. We therefor switch off the drop shadow for
    // pop-up windows when the DWM is disabled and two monitors are
    // connected.
    if (HasBogusPopupsDropShadowOnMultiMonitor() &&
        WinUtils::GetMonitorCount() > 1 &&
        !nsUXThemeData::CheckForCompositor())
    {
      if (sDropShadowEnabled) {
        ::SetClassLongA(mWnd, GCL_STYLE, 0);
        sDropShadowEnabled = false;
      }
    } else {
      if (!sDropShadowEnabled) {
        ::SetClassLongA(mWnd, GCL_STYLE, CS_DROPSHADOW);
        sDropShadowEnabled = true;
      }
    }

    // WS_EX_COMPOSITED conflicts with the WS_EX_LAYERED style and causes
    // some popup menus to become invisible.
    LONG_PTR exStyle = ::GetWindowLongPtrW(mWnd, GWL_EXSTYLE);
    if (exStyle & WS_EX_LAYERED) {
      ::SetWindowLongPtrW(mWnd, GWL_EXSTYLE, exStyle & ~WS_EX_COMPOSITED);
    }
  }

  bool syncInvalidate = false;

  bool wasVisible = mIsVisible;
  // Set the status now so that anyone asking during ShowWindow or
  // SetWindowPos would get the correct answer.
  mIsVisible = bState;

  // We may have cached an out of date visible state. This can happen
  // when session restore sets the full screen mode.
  if (mIsVisible)
    mOldStyle |= WS_VISIBLE;
  else
    mOldStyle &= ~WS_VISIBLE;

  if (!mIsVisible && wasVisible) {
      ClearCachedResources();
  }

  if (mWnd) {
    if (bState) {
      if (!wasVisible && mWindowType == eWindowType_toplevel) {
        // speed up the initial paint after show for
        // top level windows:
        syncInvalidate = true;
        switch (mSizeMode) {
          case nsSizeMode_Fullscreen:
            ::ShowWindow(mWnd, SW_SHOW);
            break;
          case nsSizeMode_Maximized :
            ::ShowWindow(mWnd, SW_SHOWMAXIMIZED);
            break;
          case nsSizeMode_Minimized :
            ::ShowWindow(mWnd, SW_SHOWMINIMIZED);
            break;
          default:
            if (CanTakeFocus()) {
              ::ShowWindow(mWnd, SW_SHOWNORMAL);
            } else {
              ::ShowWindow(mWnd, SW_SHOWNOACTIVATE);
              GetAttention(2);
            }
            break;
        }
      } else {
        DWORD flags = SWP_NOSIZE | SWP_NOMOVE | SWP_SHOWWINDOW;
        if (wasVisible)
          flags |= SWP_NOZORDER;

        if (mWindowType == eWindowType_popup) {
          // ensure popups are the topmost of the TOPMOST
          // layer. Remember not to set the SWP_NOZORDER
          // flag as that might allow the taskbar to overlap
          // the popup.
          flags |= SWP_NOACTIVATE;
          HWND owner = ::GetWindow(mWnd, GW_OWNER);
          ::SetWindowPos(mWnd, owner ? 0 : HWND_TOPMOST, 0, 0, 0, 0, flags);
        } else {
          if (mWindowType == eWindowType_dialog && !CanTakeFocus())
            flags |= SWP_NOACTIVATE;

          ::SetWindowPos(mWnd, HWND_TOP, 0, 0, 0, 0, flags);
        }
      }

      if (!wasVisible && (mWindowType == eWindowType_toplevel || mWindowType == eWindowType_dialog)) {
        // when a toplevel window or dialog is shown, initialize the UI state
        ::SendMessageW(mWnd, WM_CHANGEUISTATE, MAKEWPARAM(UIS_INITIALIZE, UISF_HIDEFOCUS | UISF_HIDEACCEL), 0);
      }
    } else {
      // Clear contents to avoid ghosting of old content if we display
      // this window again.
      if (wasVisible && mTransparencyMode == eTransparencyTransparent) {
        if (mCompositorWidgetDelegate) {
          mCompositorWidgetDelegate->ClearTransparentWindow();
        }
      }
      if (mWindowType != eWindowType_dialog) {
        ::ShowWindow(mWnd, SW_HIDE);
      } else {
        ::SetWindowPos(mWnd, 0, 0, 0, 0, 0, SWP_HIDEWINDOW | SWP_NOSIZE | SWP_NOMOVE |
                       SWP_NOZORDER | SWP_NOACTIVATE);
      }
    }
  }
  
#ifdef MOZ_XUL
  if (!wasVisible && bState) {
    Invalidate();
    if (syncInvalidate && !mInDtor && !mOnDestroyCalled) {
      ::UpdateWindow(mWnd);
    }
  }
#endif

  return NS_OK;
}

/**************************************************************
 *
 * SECTION: nsIWidget::IsVisible
 *
 * Returns the visibility state.
 *
 **************************************************************/

// Return true if the whether the component is visible, false otherwise
bool nsWindow::IsVisible() const
{
  return mIsVisible;
}

/**************************************************************
 *
 * SECTION: Window clipping utilities
 *
 * Used in Size and Move operations for setting the proper
 * window clipping regions for window transparency.
 *
 **************************************************************/

// XP and Vista visual styles sometimes require window clipping regions to be applied for proper
// transparency. These routines are called on size and move operations.
void nsWindow::ClearThemeRegion()
{
  if (IsVistaOrLater() && !HasGlass() &&
      (mWindowType == eWindowType_popup && !IsPopupWithTitleBar() &&
       (mPopupType == ePopupTypeTooltip || mPopupType == ePopupTypePanel))) {
    SetWindowRgn(mWnd, nullptr, false);
  }
}

void nsWindow::SetThemeRegion()
{
  // Popup types that have a visual styles region applied (bug 376408). This can be expanded
  // for other window types as needed. The regions are applied generically to the base window
  // so default constants are used for part and state. At some point we might need part and
  // state values from nsNativeThemeWin's GetThemePartAndState, but currently windows that
  // change shape based on state haven't come up.
  if (IsVistaOrLater() && !HasGlass() &&
      (mWindowType == eWindowType_popup && !IsPopupWithTitleBar() &&
       (mPopupType == ePopupTypeTooltip || mPopupType == ePopupTypePanel))) {
    HRGN hRgn = nullptr;
    RECT rect = {0,0,mBounds.width,mBounds.height};
    
    HDC dc = ::GetDC(mWnd);
    GetThemeBackgroundRegion(nsUXThemeData::GetTheme(eUXTooltip), dc, TTP_STANDARD, TS_NORMAL, &rect, &hRgn);
    if (hRgn) {
      if (!SetWindowRgn(mWnd, hRgn, false)) // do not delete or alter hRgn if accepted.
        DeleteObject(hRgn);
    }
    ::ReleaseDC(mWnd, dc);
  }
}

/**************************************************************
 *
 * SECTION: Touch and APZ-related functions
 *
 **************************************************************/

void nsWindow::RegisterTouchWindow() {
  mTouchWindow = true;
  mGesture.RegisterTouchWindow(mWnd);
  ::EnumChildWindows(mWnd, nsWindow::RegisterTouchForDescendants, 0);
}

BOOL CALLBACK nsWindow::RegisterTouchForDescendants(HWND aWnd, LPARAM aMsg) {
  nsWindow* win = WinUtils::GetNSWindowPtr(aWnd);
  if (win)
    win->mGesture.RegisterTouchWindow(aWnd);
  return TRUE;
}

/**************************************************************
 *
 * SECTION: nsIWidget::Move, nsIWidget::Resize,
 * nsIWidget::Size, nsIWidget::BeginResizeDrag
 *
 * Repositioning and sizing a window.
 *
 **************************************************************/

void
nsWindow::SetSizeConstraints(const SizeConstraints& aConstraints)
{
  SizeConstraints c = aConstraints;
  if (mWindowType != eWindowType_popup) {
    c.mMinSize.width = std::max(int32_t(::GetSystemMetrics(SM_CXMINTRACK)), c.mMinSize.width);
    c.mMinSize.height = std::max(int32_t(::GetSystemMetrics(SM_CYMINTRACK)), c.mMinSize.height);
  }
  ClientLayerManager *clientLayerManager = GetLayerManager()->AsClientLayerManager();

  if (clientLayerManager) {
    int32_t maxSize = clientLayerManager->GetMaxTextureSize();
    // We can't make ThebesLayers bigger than this anyway.. no point it letting
    // a window grow bigger as we won't be able to draw content there in
    // general.
    c.mMaxSize.width = std::min(c.mMaxSize.width, maxSize);
    c.mMaxSize.height = std::min(c.mMaxSize.height, maxSize);
  }

  mSizeConstraintsScale = GetDefaultScale().scale;

  nsBaseWidget::SetSizeConstraints(c);
}

const SizeConstraints
nsWindow::GetSizeConstraints()
{
  double scale = GetDefaultScale().scale;
  if (mSizeConstraintsScale == scale || mSizeConstraintsScale == 0.0) {
    return mSizeConstraints;
  }
  scale /= mSizeConstraintsScale;
  SizeConstraints c = mSizeConstraints;
  if (c.mMinSize.width != NS_MAXSIZE) {
    c.mMinSize.width = NSToIntRound(c.mMinSize.width * scale);
  }
  if (c.mMinSize.height != NS_MAXSIZE) {
    c.mMinSize.height = NSToIntRound(c.mMinSize.height * scale);
  }
  if (c.mMaxSize.width != NS_MAXSIZE) {
    c.mMaxSize.width = NSToIntRound(c.mMaxSize.width * scale);
  }
  if (c.mMaxSize.height != NS_MAXSIZE) {
    c.mMaxSize.height = NSToIntRound(c.mMaxSize.height * scale);
  }
  return c;
}

// Move this component
NS_IMETHODIMP nsWindow::Move(double aX, double aY)
{
  if (mWindowType == eWindowType_toplevel ||
      mWindowType == eWindowType_dialog) {
    SetSizeMode(nsSizeMode_Normal);
  }

  // for top-level windows only, convert coordinates from desktop pixels
  // (the "parent" coordinate space) to the window's device pixel space
  double scale = BoundsUseDesktopPixels() ? GetDesktopToDeviceScale().scale : 1.0;
  int32_t x = NSToIntRound(aX * scale);
  int32_t y = NSToIntRound(aY * scale);

  // Check to see if window needs to be moved first
  // to avoid a costly call to SetWindowPos. This check
  // can not be moved to the calling code in nsView, because
  // some platforms do not position child windows correctly

  // Only perform this check for non-popup windows, since the positioning can
  // in fact change even when the x/y do not.  We always need to perform the
  // check. See bug #97805 for details.
  if (mWindowType != eWindowType_popup && (mBounds.x == x) && (mBounds.y == y))
  {
    // Nothing to do, since it is already positioned correctly.
    return NS_OK;
  }

  mBounds.x = x;
  mBounds.y = y;

  if (mWnd) {
#ifdef DEBUG
    // complain if a window is moved offscreen (legal, but potentially worrisome)
    if (mIsTopWidgetWindow) { // only a problem for top-level windows
      // Make sure this window is actually on the screen before we move it
      // XXX: Needs multiple monitor support
      HDC dc = ::GetDC(mWnd);
      if (dc) {
        if (::GetDeviceCaps(dc, TECHNOLOGY) == DT_RASDISPLAY) {
          RECT workArea;
          ::SystemParametersInfo(SPI_GETWORKAREA, 0, &workArea, 0);
          // no annoying assertions. just mention the issue.
          if (x < 0 || x >= workArea.right || y < 0 || y >= workArea.bottom) {
            MOZ_LOG(gWindowsLog, LogLevel::Info,
                   ("window moved to offscreen position\n"));
          }
        }
      ::ReleaseDC(mWnd, dc);
      }
    }
#endif
    ClearThemeRegion();

    UINT flags = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE;
    // Workaround SetWindowPos bug with D3D9. If our window has a clip
    // region, some drivers or OSes may incorrectly copy into the clipped-out
    // area.
    if (IsPlugin() &&
        (!mLayerManager || mLayerManager->GetBackendType() == LayersBackend::LAYERS_D3D9) &&
        mClipRects &&
        (mClipRectCount != 1 || !mClipRects[0].IsEqualInterior(LayoutDeviceIntRect(0, 0, mBounds.width, mBounds.height)))) {
      flags |= SWP_NOCOPYBITS;
    }
    double oldScale = mDefaultScale;
    mResizeState = IN_SIZEMOVE;
    VERIFY(::SetWindowPos(mWnd, nullptr, x, y, 0, 0, flags));
    mResizeState = NOT_RESIZING;
    if (WinUtils::LogToPhysFactor(mWnd) != oldScale) {
      ChangedDPI();
    }

    SetThemeRegion();
  }
  NotifyRollupGeometryChange();
  return NS_OK;
}

// Resize this component
NS_IMETHODIMP nsWindow::Resize(double aWidth, double aHeight, bool aRepaint)
{
  // for top-level windows only, convert coordinates from desktop pixels
  // (the "parent" coordinate space) to the window's device pixel space
  double scale = BoundsUseDesktopPixels() ? GetDesktopToDeviceScale().scale : 1.0;
  int32_t width = NSToIntRound(aWidth * scale);
  int32_t height = NSToIntRound(aHeight * scale);

  NS_ASSERTION((width >= 0) , "Negative width passed to nsWindow::Resize");
  NS_ASSERTION((height >= 0), "Negative height passed to nsWindow::Resize");

  ConstrainSize(&width, &height);

  // Avoid unnecessary resizing calls
  if (mBounds.width == width && mBounds.height == height) {
    if (aRepaint) {
      Invalidate();
    }
    return NS_OK;
  }

  // Set cached value for lightweight and printing
  mBounds.width  = width;
  mBounds.height = height;

  if (mWnd) {
    UINT  flags = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOMOVE;

    if (!aRepaint) {
      flags |= SWP_NOREDRAW;
    }

    ClearThemeRegion();
    double oldScale = mDefaultScale;
    VERIFY(::SetWindowPos(mWnd, nullptr, 0, 0,
                          width, GetHeight(height), flags));
    if (WinUtils::LogToPhysFactor(mWnd) != oldScale) {
      ChangedDPI();
    }
    SetThemeRegion();
  }

  if (aRepaint)
    Invalidate();

  NotifyRollupGeometryChange();
  return NS_OK;
}

// Resize this component
NS_IMETHODIMP nsWindow::Resize(double aX, double aY, double aWidth,
                               double aHeight, bool aRepaint)
{
  // for top-level windows only, convert coordinates from desktop pixels
  // (the "parent" coordinate space) to the window's device pixel space
  double scale = BoundsUseDesktopPixels() ? GetDesktopToDeviceScale().scale : 1.0;
  int32_t x = NSToIntRound(aX * scale);
  int32_t y = NSToIntRound(aY * scale);
  int32_t width = NSToIntRound(aWidth * scale);
  int32_t height = NSToIntRound(aHeight * scale);

  NS_ASSERTION((width >= 0),  "Negative width passed to nsWindow::Resize");
  NS_ASSERTION((height >= 0), "Negative height passed to nsWindow::Resize");

  ConstrainSize(&width, &height);

  // Avoid unnecessary resizing calls
  if (mBounds.x == x && mBounds.y == y &&
      mBounds.width == width && mBounds.height == height) {
    if (aRepaint) {
      Invalidate();
    }
    return NS_OK;
  }

  // Set cached value for lightweight and printing
  mBounds.x      = x;
  mBounds.y      = y;
  mBounds.width  = width;
  mBounds.height = height;

  if (mWnd) {
    UINT  flags = SWP_NOZORDER | SWP_NOACTIVATE;
    if (!aRepaint) {
      flags |= SWP_NOREDRAW;
    }

    ClearThemeRegion();
    double oldScale = mDefaultScale;
    VERIFY(::SetWindowPos(mWnd, nullptr, x, y,
                          width, GetHeight(height), flags));
    if (WinUtils::LogToPhysFactor(mWnd) != oldScale) {
      ChangedDPI();
    }
    if (mTransitionWnd) {
      // If we have a fullscreen transition window, we need to make
      // it topmost again, otherwise the taskbar may be raised by
      // the system unexpectedly when we leave fullscreen state.
      ::SetWindowPos(mTransitionWnd, HWND_TOPMOST, 0, 0, 0, 0,
                     SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
      // Every transition window is only used once.
      mTransitionWnd = nullptr;
    }
    SetThemeRegion();
  }

  if (aRepaint)
    Invalidate();

  NotifyRollupGeometryChange();
  return NS_OK;
}

NS_IMETHODIMP
nsWindow::BeginResizeDrag(WidgetGUIEvent* aEvent,
                          int32_t aHorizontal,
                          int32_t aVertical)
{
  NS_ENSURE_ARG_POINTER(aEvent);

  if (aEvent->mClass != eMouseEventClass) {
    // you can only begin a resize drag with a mouse event
    return NS_ERROR_INVALID_ARG;
  }

  if (aEvent->AsMouseEvent()->button != WidgetMouseEvent::eLeftButton) {
    // you can only begin a resize drag with the left mouse button
    return NS_ERROR_INVALID_ARG;
  }

  // work out what sizemode we're talking about
  WPARAM syscommand;
  if (aVertical < 0) {
    if (aHorizontal < 0) {
      syscommand = SC_SIZE | WMSZ_TOPLEFT;
    } else if (aHorizontal == 0) {
      syscommand = SC_SIZE | WMSZ_TOP;
    } else {
      syscommand = SC_SIZE | WMSZ_TOPRIGHT;
    }
  } else if (aVertical == 0) {
    if (aHorizontal < 0) {
      syscommand = SC_SIZE | WMSZ_LEFT;
    } else if (aHorizontal == 0) {
      return NS_ERROR_INVALID_ARG;
    } else {
      syscommand = SC_SIZE | WMSZ_RIGHT;
    }
  } else {
    if (aHorizontal < 0) {
      syscommand = SC_SIZE | WMSZ_BOTTOMLEFT;
    } else if (aHorizontal == 0) {
      syscommand = SC_SIZE | WMSZ_BOTTOM;
    } else {
      syscommand = SC_SIZE | WMSZ_BOTTOMRIGHT;
    }
  }

  // resizing doesn't work if the mouse is already captured
  CaptureMouse(false);

  // find the top-level window
  HWND toplevelWnd = WinUtils::GetTopLevelHWND(mWnd, true);

  // tell Windows to start the resize
  ::PostMessage(toplevelWnd, WM_SYSCOMMAND, syscommand,
                POINTTOPOINTS(aEvent->mRefPoint));

  return NS_OK;
}

/**************************************************************
 *
 * SECTION: Window Z-order and state.
 *
 * nsIWidget::PlaceBehind, nsIWidget::SetSizeMode,
 * nsIWidget::ConstrainPosition
 *
 * Z-order, positioning, restore, minimize, and maximize.
 *
 **************************************************************/

// Position the window behind the given window
void
nsWindow::PlaceBehind(nsTopLevelWidgetZPlacement aPlacement,
                      nsIWidget *aWidget, bool aActivate)
{
  HWND behind = HWND_TOP;
  if (aPlacement == eZPlacementBottom)
    behind = HWND_BOTTOM;
  else if (aPlacement == eZPlacementBelow && aWidget)
    behind = (HWND)aWidget->GetNativeData(NS_NATIVE_WINDOW);
  UINT flags = SWP_NOMOVE | SWP_NOREPOSITION | SWP_NOSIZE;
  if (!aActivate)
    flags |= SWP_NOACTIVATE;

  if (!CanTakeFocus() && behind == HWND_TOP)
  {
    // Can't place the window to top so place it behind the foreground window
    // (as long as it is not topmost)
    HWND wndAfter = ::GetForegroundWindow();
    if (!wndAfter)
      behind = HWND_BOTTOM;
    else if (!(GetWindowLongPtrW(wndAfter, GWL_EXSTYLE) & WS_EX_TOPMOST))
      behind = wndAfter;
    flags |= SWP_NOACTIVATE;
  }

  ::SetWindowPos(mWnd, behind, 0, 0, 0, 0, flags);
}

static UINT
GetCurrentShowCmd(HWND aWnd)
{
  WINDOWPLACEMENT pl;
  pl.length = sizeof(pl);
  ::GetWindowPlacement(aWnd, &pl);
  return pl.showCmd;
}

// Maximize, minimize or restore the window.
void
nsWindow::SetSizeMode(nsSizeMode aMode)
{
  // Let's not try and do anything if we're already in that state.
  // (This is needed to prevent problems when calling window.minimize(), which
  // calls us directly, and then the OS triggers another call to us.)
  if (aMode == mSizeMode)
    return;

  // save the requested state
  mLastSizeMode = mSizeMode;
  nsBaseWidget::SetSizeMode(aMode);
  if (mIsVisible) {
    int mode;

    switch (aMode) {
      case nsSizeMode_Fullscreen :
        mode = SW_SHOW;
        break;

      case nsSizeMode_Maximized :
        mode = SW_MAXIMIZE;
        break;

      case nsSizeMode_Minimized :
        // Using SW_SHOWMINIMIZED prevents the working set from being trimmed but
        // keeps the window active in the tray. So after the window is minimized,
        // windows will fire WM_WINDOWPOSCHANGED (OnWindowPosChanged) at which point
        // we will do some additional processing to get the active window set right.
        // If sTrimOnMinimize is set, we let windows handle minimization normally
        // using SW_MINIMIZE.
        mode = sTrimOnMinimize ? SW_MINIMIZE : SW_SHOWMINIMIZED;
        break;

      default :
        mode = SW_RESTORE;
    }

    // Don't call ::ShowWindow if we're trying to "restore" a window that is
    // already in a normal state.  Prevents a bug where snapping to one side
    // of the screen and then minimizing would cause Windows to forget our
    // window's correct restored position/size.
    if(!(GetCurrentShowCmd(mWnd) == SW_SHOWNORMAL && mode == SW_RESTORE)) {
      ::ShowWindow(mWnd, mode);
    }
    // we activate here to ensure that the right child window is focused
    if (mode == SW_MAXIMIZE || mode == SW_SHOW)
      DispatchFocusToTopLevelWindow(true);
  }
}

// Constrain a potential move to fit onscreen
// Position (aX, aY) is specified in Windows screen (logical) pixels,
// except when using per-monitor DPI, in which case it's device pixels.
void
nsWindow::ConstrainPosition(bool aAllowSlop, int32_t *aX, int32_t *aY)
{
  if (!mIsTopWidgetWindow) // only a problem for top-level windows
    return;

  double dpiScale = GetDesktopToDeviceScale().scale;

  // We need to use the window size in the kind of pixels used for window-
  // manipulation APIs.
  int32_t logWidth = std::max<int32_t>(NSToIntRound(mBounds.width / dpiScale), 1);
  int32_t logHeight = std::max<int32_t>(NSToIntRound(mBounds.height / dpiScale), 1);

  /* get our playing field. use the current screen, or failing that
  for any reason, use device caps for the default screen. */
  RECT screenRect;

  nsCOMPtr<nsIScreenManager> screenmgr = do_GetService(sScreenManagerContractID);
  if (!screenmgr) {
    return;
  }
  nsCOMPtr<nsIScreen> screen;
  int32_t left, top, width, height;

  screenmgr->ScreenForRect(*aX, *aY, logWidth, logHeight,
                           getter_AddRefs(screen));
  if (mSizeMode != nsSizeMode_Fullscreen) {
    // For normalized windows, use the desktop work area.
    nsresult rv = screen->GetAvailRectDisplayPix(&left, &top, &width, &height);
    if (NS_FAILED(rv)) {
      return;
    }
  } else {
    // For full screen windows, use the desktop.
    nsresult rv = screen->GetRectDisplayPix(&left, &top, &width, &height);
    if (NS_FAILED(rv)) {
      return;
    }
  }
  screenRect.left = left;
  screenRect.right = left + width;
  screenRect.top = top;
  screenRect.bottom = top + height;

  if (aAllowSlop) {
    if (*aX < screenRect.left - logWidth + kWindowPositionSlop)
      *aX = screenRect.left - logWidth + kWindowPositionSlop;
    else if (*aX >= screenRect.right - kWindowPositionSlop)
      *aX = screenRect.right - kWindowPositionSlop;

    if (*aY < screenRect.top - logHeight + kWindowPositionSlop)
      *aY = screenRect.top - logHeight + kWindowPositionSlop;
    else if (*aY >= screenRect.bottom - kWindowPositionSlop)
      *aY = screenRect.bottom - kWindowPositionSlop;

  } else {

    if (*aX < screenRect.left)
      *aX = screenRect.left;
    else if (*aX >= screenRect.right - logWidth)
      *aX = screenRect.right - logWidth;

    if (*aY < screenRect.top)
      *aY = screenRect.top;
    else if (*aY >= screenRect.bottom - logHeight)
      *aY = screenRect.bottom - logHeight;
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::Enable, nsIWidget::IsEnabled
 *
 * Enabling and disabling the widget.
 *
 **************************************************************/

// Enable/disable this component
NS_IMETHODIMP nsWindow::Enable(bool bState)
{
  if (mWnd) {
    ::EnableWindow(mWnd, bState);
  }
  return NS_OK;
}

// Return the current enable state
bool nsWindow::IsEnabled() const
{
  return !mWnd ||
         (::IsWindowEnabled(mWnd) &&
          ::IsWindowEnabled(::GetAncestor(mWnd, GA_ROOT)));
}


/**************************************************************
 *
 * SECTION: nsIWidget::SetFocus
 *
 * Give the focus to this widget.
 *
 **************************************************************/

NS_IMETHODIMP nsWindow::SetFocus(bool aRaise)
{
  if (mWnd) {
#ifdef WINSTATE_DEBUG_OUTPUT
    if (mWnd == WinUtils::GetTopLevelHWND(mWnd)) {
      MOZ_LOG(gWindowsLog, LogLevel::Info,
             ("*** SetFocus: [  top] raise=%d\n", aRaise));
    } else {
      MOZ_LOG(gWindowsLog, LogLevel::Info,
             ("*** SetFocus: [child] raise=%d\n", aRaise));
    }
#endif
    // Uniconify, if necessary
    HWND toplevelWnd = WinUtils::GetTopLevelHWND(mWnd);
    if (aRaise && ::IsIconic(toplevelWnd)) {
      ::ShowWindow(toplevelWnd, SW_RESTORE);
    }
    ::SetFocus(mWnd);
  }
  return NS_OK;
}


/**************************************************************
 *
 * SECTION: Bounds
 *
 * GetBounds, GetClientBounds, GetScreenBounds,
 * GetRestoredBounds, GetClientOffset
 * SetDrawsInTitlebar, SetNonClientMargins
 *
 * Bound calculations.
 *
 **************************************************************/

// Return the window's full dimensions in screen coordinates.
// If the window has a parent, converts the origin to an offset
// of the parent's screen origin.
LayoutDeviceIntRect
nsWindow::GetBounds()
{
  if (!mWnd) {
    return mBounds;
  }

  RECT r;
  VERIFY(::GetWindowRect(mWnd, &r));

  LayoutDeviceIntRect rect;

  // assign size
  rect.width  = r.right - r.left;
  rect.height = r.bottom - r.top;

  // popup window bounds' are in screen coordinates, not relative to parent
  // window
  if (mWindowType == eWindowType_popup) {
    rect.x = r.left;
    rect.y = r.top;
    return rect;
  }

  // chrome on parent:
  //  ___      5,5   (chrome start)
  // |  ____   10,10 (client start)
  // | |  ____ 20,20 (child start)
  // | | |
  // 20,20 - 5,5 = 15,15 (??)
  // minus GetClientOffset:
  // 15,15 - 5,5 = 10,10
  //
  // no chrome on parent:
  //  ______   10,10 (win start)
  // |  ____   20,20 (child start)
  // | |
  // 20,20 - 10,10 = 10,10
  //
  // walking the chain:
  //  ___      5,5   (chrome start)
  // |  ___    10,10 (client start)
  // | |  ___  20,20 (child start)
  // | | |  __ 30,30 (child start)
  // | | | |
  // 30,30 - 20,20 = 10,10 (offset from second child to first)
  // 20,20 - 5,5 = 15,15 + 10,10 = 25,25 (??)
  // minus GetClientOffset:
  // 25,25 - 5,5 = 20,20 (offset from second child to parent client)

  // convert coordinates if parent exists
  HWND parent = ::GetParent(mWnd);
  if (parent) {
    RECT pr;
    VERIFY(::GetWindowRect(parent, &pr));
    r.left -= pr.left;
    r.top  -= pr.top;
    // adjust for chrome
    nsWindow* pWidget = static_cast<nsWindow*>(GetParent());
    if (pWidget && pWidget->IsTopLevelWidget()) {
      LayoutDeviceIntPoint clientOffset = pWidget->GetClientOffset();
      r.left -= clientOffset.x;
      r.top  -= clientOffset.y;
    }
  }
  rect.x = r.left;
  rect.y = r.top;
  return rect;
}

// Get this component dimension
LayoutDeviceIntRect
nsWindow::GetClientBounds()
{
  if (!mWnd) {
    return LayoutDeviceIntRect(0, 0, 0, 0);
  }

  RECT r;
  VERIFY(::GetClientRect(mWnd, &r));

  LayoutDeviceIntRect bounds = GetBounds();
  LayoutDeviceIntRect rect;
  rect.MoveTo(bounds.TopLeft() + GetClientOffset());
  rect.width  = r.right - r.left;
  rect.height = r.bottom - r.top;
  return rect;
}

// Like GetBounds, but don't offset by the parent
LayoutDeviceIntRect
nsWindow::GetScreenBounds()
{
  if (!mWnd) {
    return mBounds;
  }

  RECT r;
  VERIFY(::GetWindowRect(mWnd, &r));

  LayoutDeviceIntRect rect;
  rect.x = r.left;
  rect.y = r.top;
  rect.width  = r.right - r.left;
  rect.height = r.bottom - r.top;
  return rect;
}

nsresult
nsWindow::GetRestoredBounds(LayoutDeviceIntRect &aRect)
{
  if (SizeMode() == nsSizeMode_Normal) {
    aRect = GetScreenBounds();
    return NS_OK;
  }
  if (!mWnd) {
    return NS_ERROR_FAILURE;
  }

  WINDOWPLACEMENT pl = { sizeof(WINDOWPLACEMENT) };
  VERIFY(::GetWindowPlacement(mWnd, &pl));
  const RECT& r = pl.rcNormalPosition;

  HMONITOR monitor = ::MonitorFromWindow(mWnd, MONITOR_DEFAULTTONULL);
  if (!monitor) {
    return NS_ERROR_FAILURE;
  }
  MONITORINFO mi = { sizeof(MONITORINFO) };
  VERIFY(::GetMonitorInfo(monitor, &mi));

  aRect.SetRect(r.left, r.top, r.right - r.left, r.bottom - r.top);
  aRect.MoveBy(mi.rcWork.left - mi.rcMonitor.left,
               mi.rcWork.top - mi.rcMonitor.top);
  return NS_OK;
}

// Return the x,y offset of the client area from the origin of the window. If
// the window is borderless returns (0,0).
LayoutDeviceIntPoint
nsWindow::GetClientOffset()
{
  if (!mWnd) {
    return LayoutDeviceIntPoint(0, 0);
  }

  RECT r1;
  GetWindowRect(mWnd, &r1);
  LayoutDeviceIntPoint pt = WidgetToScreenOffset();
  return LayoutDeviceIntPoint(pt.x - r1.left, pt.y - r1.top);
}

void
nsWindow::SetDrawsInTitlebar(bool aState)
{
  nsWindow * window = GetTopLevelWindow(true);
  if (window && window != this) {
    return window->SetDrawsInTitlebar(aState);
  }

  if (aState) {
    // top, right, bottom, left for nsIntMargin
    LayoutDeviceIntMargin margins(0, -1, -1, -1);
    SetNonClientMargins(margins);
  }
  else {
    LayoutDeviceIntMargin margins(-1, -1, -1, -1);
    SetNonClientMargins(margins);
  }
}

void
nsWindow::ResetLayout()
{
  // This will trigger a frame changed event, triggering
  // nc calc size and a sizemode gecko event.
  SetWindowPos(mWnd, 0, 0, 0, 0, 0,
               SWP_FRAMECHANGED|SWP_NOACTIVATE|SWP_NOMOVE|
               SWP_NOOWNERZORDER|SWP_NOSIZE|SWP_NOZORDER);

  // If hidden, just send the frame changed event for now.
  if (!mIsVisible)
    return;

  // Send a gecko size event to trigger reflow.
  RECT clientRc = {0};
  GetClientRect(mWnd, &clientRc);
  nsIntRect evRect(WinUtils::ToIntRect(clientRc));
  OnResize(evRect);

  // Invalidate and update
  Invalidate();
}

// Internally track the caption status via a window property. Required
// due to our internal handling of WM_NCACTIVATE when custom client
// margins are set.
static const wchar_t kManageWindowInfoProperty[] = L"ManageWindowInfoProperty";
typedef BOOL (WINAPI *GetWindowInfoPtr)(HWND hwnd, PWINDOWINFO pwi);
static GetWindowInfoPtr sGetWindowInfoPtrStub = nullptr;

BOOL WINAPI
GetWindowInfoHook(HWND hWnd, PWINDOWINFO pwi)
{
  if (!sGetWindowInfoPtrStub) {
    NS_ASSERTION(FALSE, "Something is horribly wrong in GetWindowInfoHook!");
    return FALSE;
  }
  int windowStatus = 
    reinterpret_cast<LONG_PTR>(GetPropW(hWnd, kManageWindowInfoProperty));
  // No property set, return the default data.
  if (!windowStatus)
    return sGetWindowInfoPtrStub(hWnd, pwi);
  // Call GetWindowInfo and update dwWindowStatus with our
  // internally tracked value. 
  BOOL result = sGetWindowInfoPtrStub(hWnd, pwi);
  if (result && pwi)
    pwi->dwWindowStatus = (windowStatus == 1 ? 0 : WS_ACTIVECAPTION);
  return result;
}

void
nsWindow::UpdateGetWindowInfoCaptionStatus(bool aActiveCaption)
{
  if (!mWnd)
    return;

  if (!sGetWindowInfoPtrStub) {
    sUser32Intercept.Init("user32.dll");
    if (!sUser32Intercept.AddHook("GetWindowInfo", reinterpret_cast<intptr_t>(GetWindowInfoHook),
                                  (void**) &sGetWindowInfoPtrStub))
      return;
  }
  // Update our internally tracked caption status
  SetPropW(mWnd, kManageWindowInfoProperty, 
    reinterpret_cast<HANDLE>(static_cast<INT_PTR>(aActiveCaption) + 1));
}

/**
 * Called when the window layout changes: full screen mode transitions,
 * theme changes, and composition changes. Calculates the new non-client
 * margins and fires off a frame changed event, which triggers an nc calc
 * size windows event, kicking the changes in.
 *
 * The offsets calculated here are based on the value of `mNonClientMargins`
 * which is specified in the "chromemargins" attribute of the window.  For
 * each margin, the value specified has the following meaning:
 *    -1 - leave the default frame in place
 *     0 - remove the frame
 *    >0 - frame size equals min(0, (default frame size - margin value))
 *
 * This function calculates and populates `mNonClientOffset`.
 * In our processing of `WM_NCCALCSIZE`, the frame size will be calculated
 * as (default frame size - offset).  For example, if the left frame should
 * be 1 pixel narrower than the default frame size, `mNonClientOffset.left`
 * will equal 1.
 *
 * For maximized, fullscreen, and minimized windows, the values stored in
 * `mNonClientMargins` are ignored, and special processing takes place.
 *
 * For non-glass windows, we only allow frames to be their default size
 * or removed entirely.
 */
bool
nsWindow::UpdateNonClientMargins(int32_t aSizeMode, bool aReflowWindow)
{
  if (!mCustomNonClient)
    return false;

  if (aSizeMode == -1) {
    aSizeMode = mSizeMode;
  }

  bool hasCaption = (mBorderStyle
                    & (eBorderStyle_all
                     | eBorderStyle_title
                     | eBorderStyle_menu
                     | eBorderStyle_default));

  // mCaptionHeight is the default size of the NC area at
  // the top of the window. If the window has a caption,
  // the size is calculated as the sum of:
  //      SM_CYFRAME        - The thickness of the sizing border
  //                          around a resizable window
  //      SM_CXPADDEDBORDER - The amount of border padding
  //                          for captioned windows
  //      SM_CYCAPTION      - The height of the caption area
  //
  // If the window does not have a caption, mCaptionHeight will be equal to
  // `GetSystemMetrics(SM_CYFRAME)`
  mCaptionHeight = GetSystemMetrics(SM_CYFRAME)
                 + (hasCaption ? GetSystemMetrics(SM_CYCAPTION)
                                 + GetSystemMetrics(SM_CXPADDEDBORDER)
                               : 0);

  // mHorResizeMargin is the size of the default NC areas on the
  // left and right sides of our window.  It is calculated as
  // the sum of:
  //      SM_CXFRAME        - The thickness of the sizing border
  //      SM_CXPADDEDBORDER - The amount of border padding
  //                          for captioned windows
  //
  // If the window does not have a caption, mHorResizeMargin will be equal to
  // `GetSystemMetrics(SM_CXFRAME)`
  mHorResizeMargin = GetSystemMetrics(SM_CXFRAME)
                   + (hasCaption ? GetSystemMetrics(SM_CXPADDEDBORDER) : 0);

  // mVertResizeMargin is the size of the default NC area at the
  // bottom of the window. It is calculated as the sum of:
  //      SM_CYFRAME        - The thickness of the sizing border
  //      SM_CXPADDEDBORDER - The amount of border padding
  //                          for captioned windows.
  //
  // If the window does not have a caption, mVertResizeMargin will be equal to
  // `GetSystemMetrics(SM_CYFRAME)`
  mVertResizeMargin = GetSystemMetrics(SM_CYFRAME)
                    + (hasCaption ? GetSystemMetrics(SM_CXPADDEDBORDER) : 0);

  if (aSizeMode == nsSizeMode_Minimized) {
    // Use default frame size for minimized windows
    mNonClientOffset.top = 0;
    mNonClientOffset.left = 0;
    mNonClientOffset.right = 0;
    mNonClientOffset.bottom = 0;
  } else if (aSizeMode == nsSizeMode_Fullscreen) {
    // Remove the default frame from the top of our fullscreen window.  This
    // makes the whole caption part of our client area, allowing us to draw
    // in the whole caption area.  Additionally remove the default frame from
    // the left, right, and bottom.
    mNonClientOffset.top = mCaptionHeight;
    mNonClientOffset.bottom = mVertResizeMargin;
    mNonClientOffset.left = mHorResizeMargin;
    mNonClientOffset.right = mHorResizeMargin;
  } else if (aSizeMode == nsSizeMode_Maximized) {
    // Remove the default frame from the top of our maximized window.  This
    // makes the whole caption part of our client area, allowing us to draw
    // in the whole caption area.  Use default frame size on left, right, and
    // bottom. The reason this works is that, for maximized windows,
    // Windows positions them so that their frames fall off the screen.
    // This gives the illusion of windows having no frames when they are
    // maximized.  If we try to mess with the frame sizes by setting these
    // offsets to positive values, our client area will fall off the screen.
    mNonClientOffset.top = mCaptionHeight;
    mNonClientOffset.bottom = 0;
    mNonClientOffset.left = 0;
    mNonClientOffset.right = 0;

    APPBARDATA appBarData;
    appBarData.cbSize = sizeof(appBarData);
    UINT taskbarState = SHAppBarMessage(ABM_GETSTATE, &appBarData);
    if (ABS_AUTOHIDE & taskbarState) {
      UINT edge = -1;
      appBarData.hWnd = FindWindow(L"Shell_TrayWnd", nullptr);
      if (appBarData.hWnd) {
        HMONITOR taskbarMonitor = ::MonitorFromWindow(appBarData.hWnd,
                                                      MONITOR_DEFAULTTOPRIMARY);
        HMONITOR windowMonitor = ::MonitorFromWindow(mWnd,
                                                     MONITOR_DEFAULTTONEAREST);
        if (taskbarMonitor == windowMonitor) {
          SHAppBarMessage(ABM_GETTASKBARPOS, &appBarData);
          edge = appBarData.uEdge;
        }
      }

      if (ABE_LEFT == edge) {
        mNonClientOffset.left -= 1;
      } else if (ABE_RIGHT == edge) {
        mNonClientOffset.right -= 1;
      } else if (ABE_BOTTOM == edge || ABE_TOP == edge) {
        mNonClientOffset.bottom -= 1;
      }
    }
  } else {
    bool glass = nsUXThemeData::CheckForCompositor();

    // We're dealing with a "normal" window (not maximized, minimized, or
    // fullscreen), so process `mNonClientMargins` and set `mNonClientOffset`
    // accordingly.
    //
    // Setting `mNonClientOffset` to 0 has the effect of leaving the default
    // frame intact.  Setting it to a value greater than 0 reduces the frame
    // size by that amount.

    if (mNonClientMargins.top > 0 && glass) {
      mNonClientOffset.top = std::min(mCaptionHeight, mNonClientMargins.top);
    } else if (mNonClientMargins.top == 0) {
      mNonClientOffset.top = mCaptionHeight;
    } else {
      mNonClientOffset.top = 0;
    }

    if (mNonClientMargins.bottom > 0 && glass) {
      mNonClientOffset.bottom = std::min(mVertResizeMargin, mNonClientMargins.bottom);
    } else if (mNonClientMargins.bottom == 0) {
      mNonClientOffset.bottom = mVertResizeMargin;
    } else {
      mNonClientOffset.bottom = 0;
    }

    if (mNonClientMargins.left > 0 && glass) {
      mNonClientOffset.left = std::min(mHorResizeMargin, mNonClientMargins.left);
    } else if (mNonClientMargins.left == 0) {
      mNonClientOffset.left = mHorResizeMargin;
    } else {
      mNonClientOffset.left = 0;
    }

    if (mNonClientMargins.right > 0 && glass) {
      mNonClientOffset.right = std::min(mHorResizeMargin, mNonClientMargins.right);
    } else if (mNonClientMargins.right == 0) {
      mNonClientOffset.right = mHorResizeMargin;
    } else {
      mNonClientOffset.right = 0;
    }
  }

  if (aReflowWindow) {
    // Force a reflow of content based on the new client
    // dimensions.
    ResetLayout();
  }

  return true;
}

NS_IMETHODIMP
nsWindow::SetNonClientMargins(LayoutDeviceIntMargin &margins)
{
  if (!mIsTopWidgetWindow ||
      mBorderStyle == eBorderStyle_none)
    return NS_ERROR_INVALID_ARG;

  if (mHideChrome) {
    mFutureMarginsOnceChromeShows = margins;
    mFutureMarginsToUse = true;
    return NS_OK;
  }
  mFutureMarginsToUse = false;

  // Request for a reset
  if (margins.top == -1 && margins.left == -1 &&
      margins.right == -1 && margins.bottom == -1) {
    mCustomNonClient = false;
    mNonClientMargins = margins;
    // Force a reflow of content based on the new client
    // dimensions.
    ResetLayout();

    int windowStatus =
      reinterpret_cast<LONG_PTR>(GetPropW(mWnd, kManageWindowInfoProperty));
    if (windowStatus) {
      ::SendMessageW(mWnd, WM_NCACTIVATE, 1 != windowStatus, 0);
    }

    return NS_OK;
  }

  if (margins.top < -1 || margins.bottom < -1 ||
      margins.left < -1 || margins.right < -1)
    return NS_ERROR_INVALID_ARG;

  mNonClientMargins = margins;
  mCustomNonClient = true;
  if (!UpdateNonClientMargins()) {
    NS_WARNING("UpdateNonClientMargins failed!");
    return NS_OK;
  }

  return NS_OK;
}

void
nsWindow::InvalidateNonClientRegion()
{
  // +-+-----------------------+-+
  // | | app non-client chrome | |
  // | +-----------------------+ |
  // | |   app client chrome   | | }
  // | +-----------------------+ | }
  // | |      app content      | | } area we don't want to invalidate
  // | +-----------------------+ | }
  // | |   app client chrome   | | }
  // | +-----------------------+ | 
  // +---------------------------+ <
  //  ^                         ^    windows non-client chrome
  // client area = app *
  RECT rect;
  GetWindowRect(mWnd, &rect);
  MapWindowPoints(nullptr, mWnd, (LPPOINT)&rect, 2);
  HRGN winRgn = CreateRectRgnIndirect(&rect);

  // Subtract app client chrome and app content leaving
  // windows non-client chrome and app non-client chrome
  // in winRgn.
  GetWindowRect(mWnd, &rect);
  rect.top += mCaptionHeight;
  rect.right -= mHorResizeMargin;
  rect.bottom -= mHorResizeMargin;
  rect.left += mVertResizeMargin;
  MapWindowPoints(nullptr, mWnd, (LPPOINT)&rect, 2);
  HRGN clientRgn = CreateRectRgnIndirect(&rect);
  CombineRgn(winRgn, winRgn, clientRgn, RGN_DIFF);
  DeleteObject(clientRgn);

  // triggers ncpaint and paint events for the two areas
  RedrawWindow(mWnd, nullptr, winRgn, RDW_FRAME | RDW_INVALIDATE);
  DeleteObject(winRgn);
}

HRGN
nsWindow::ExcludeNonClientFromPaintRegion(HRGN aRegion)
{
  RECT rect;
  HRGN rgn = nullptr;
  if (aRegion == (HRGN)1) { // undocumented value indicating a full refresh
    GetWindowRect(mWnd, &rect);
    rgn = CreateRectRgnIndirect(&rect);
  } else {
    rgn = aRegion;
  }
  GetClientRect(mWnd, &rect);
  MapWindowPoints(mWnd, nullptr, (LPPOINT)&rect, 2);
  HRGN nonClientRgn = CreateRectRgnIndirect(&rect);
  CombineRgn(rgn, rgn, nonClientRgn, RGN_DIFF);
  DeleteObject(nonClientRgn);
  return rgn;
}

/**************************************************************
 *
 * SECTION: nsIWidget::SetBackgroundColor
 *
 * Sets the window background paint color.
 *
 **************************************************************/

void nsWindow::SetBackgroundColor(const nscolor &aColor)
{
  if (mBrush)
    ::DeleteObject(mBrush);

  mBrush = ::CreateSolidBrush(NSRGB_2_COLOREF(aColor));
  if (mWnd != nullptr) {
    ::SetClassLongPtrW(mWnd, GCLP_HBRBACKGROUND, (LONG_PTR)mBrush);
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::SetCursor
 *
 * SetCursor and related utilities for manging cursor state.
 *
 **************************************************************/

// Set this component cursor
NS_IMETHODIMP nsWindow::SetCursor(nsCursor aCursor)
{
  // Only change cursor if it's changing

  //XXX mCursor isn't always right.  Scrollbars and others change it, too.
  //XXX If we want this optimization we need a better way to do it.
  //if (aCursor != mCursor) {
  HCURSOR newCursor = nullptr;

  switch (aCursor) {
    case eCursor_select:
      newCursor = ::LoadCursor(nullptr, IDC_IBEAM);
      break;

    case eCursor_wait:
      newCursor = ::LoadCursor(nullptr, IDC_WAIT);
      break;

    case eCursor_hyperlink:
    {
      newCursor = ::LoadCursor(nullptr, IDC_HAND);
      break;
    }

    case eCursor_standard:
    case eCursor_context_menu: // XXX See bug 258960.
      newCursor = ::LoadCursor(nullptr, IDC_ARROW);
      break;

    case eCursor_n_resize:
    case eCursor_s_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENS);
      break;

    case eCursor_w_resize:
    case eCursor_e_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZEWE);
      break;

    case eCursor_nw_resize:
    case eCursor_se_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENWSE);
      break;

    case eCursor_ne_resize:
    case eCursor_sw_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENESW);
      break;

    case eCursor_crosshair:
      newCursor = ::LoadCursor(nullptr, IDC_CROSS);
      break;

    case eCursor_move:
      newCursor = ::LoadCursor(nullptr, IDC_SIZEALL);
      break;

    case eCursor_help:
      newCursor = ::LoadCursor(nullptr, IDC_HELP);
      break;

    case eCursor_copy: // CSS3
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_COPY));
      break;

    case eCursor_alias:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_ALIAS));
      break;

    case eCursor_cell:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_CELL));
      break;

    case eCursor_grab:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_GRAB));
      break;

    case eCursor_grabbing:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_GRABBING));
      break;

    case eCursor_spinning:
      newCursor = ::LoadCursor(nullptr, IDC_APPSTARTING);
      break;

    case eCursor_zoom_in:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_ZOOMIN));
      break;

    case eCursor_zoom_out:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_ZOOMOUT));
      break;

    case eCursor_not_allowed:
    case eCursor_no_drop:
      newCursor = ::LoadCursor(nullptr, IDC_NO);
      break;

    case eCursor_col_resize:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_COLRESIZE));
      break;

    case eCursor_row_resize:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_ROWRESIZE));
      break;

    case eCursor_vertical_text:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_VERTICALTEXT));
      break;

    case eCursor_all_scroll:
      // XXX not 100% appropriate perhaps
      newCursor = ::LoadCursor(nullptr, IDC_SIZEALL);
      break;

    case eCursor_nesw_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENESW);
      break;

    case eCursor_nwse_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENWSE);
      break;

    case eCursor_ns_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZENS);
      break;

    case eCursor_ew_resize:
      newCursor = ::LoadCursor(nullptr, IDC_SIZEWE);
      break;

    case eCursor_none:
      newCursor = ::LoadCursor(nsToolkit::mDllInstance, MAKEINTRESOURCE(IDC_NONE));
      break;

    default:
      NS_ERROR("Invalid cursor type");
      break;
  }

  if (nullptr != newCursor) {
    mCursor = aCursor;
    HCURSOR oldCursor = ::SetCursor(newCursor);
    
    if (sHCursor == oldCursor) {
      NS_IF_RELEASE(sCursorImgContainer);
      if (sHCursor != nullptr)
        ::DestroyIcon(sHCursor);
      sHCursor = nullptr;
    }
  }

  return NS_OK;
}

// Setting the actual cursor
NS_IMETHODIMP nsWindow::SetCursor(imgIContainer* aCursor,
                                  uint32_t aHotspotX, uint32_t aHotspotY)
{
  if (sCursorImgContainer == aCursor && sHCursor) {
    ::SetCursor(sHCursor);
    return NS_OK;
  }

  int32_t width;
  int32_t height;

  nsresult rv;
  rv = aCursor->GetWidth(&width);
  NS_ENSURE_SUCCESS(rv, rv);
  rv = aCursor->GetHeight(&height);
  NS_ENSURE_SUCCESS(rv, rv);

  // Reject cursors greater than 128 pixels in either direction, to prevent
  // spoofing.
  // XXX ideally we should rescale. Also, we could modify the API to
  // allow trusted content to set larger cursors.
  if (width > 128 || height > 128)
    return NS_ERROR_NOT_AVAILABLE;

  HCURSOR cursor;
  double scale = GetDefaultScale().scale;
  IntSize size = RoundedToInt(Size(width * scale, height * scale));
  rv = nsWindowGfx::CreateIcon(aCursor, true, aHotspotX, aHotspotY, size, &cursor);
  NS_ENSURE_SUCCESS(rv, rv);

  mCursor = nsCursor(-1);
  ::SetCursor(cursor);

  NS_IF_RELEASE(sCursorImgContainer);
  sCursorImgContainer = aCursor;
  NS_ADDREF(sCursorImgContainer);

  if (sHCursor != nullptr)
    ::DestroyIcon(sHCursor);
  sHCursor = cursor;

  return NS_OK;
}

/**************************************************************
 *
 * SECTION: nsIWidget::Get/SetTransparencyMode
 *
 * Manage the transparency mode of the top-level window
 * containing this widget.
 *
 **************************************************************/

#ifdef MOZ_XUL
nsTransparencyMode nsWindow::GetTransparencyMode()
{
  return GetTopLevelWindow(true)->GetWindowTranslucencyInner();
}

void nsWindow::SetTransparencyMode(nsTransparencyMode aMode)
{
  GetTopLevelWindow(true)->SetWindowTranslucencyInner(aMode);
}

void nsWindow::UpdateOpaqueRegion(const LayoutDeviceIntRegion& aOpaqueRegion)
{
  if (!HasGlass() || GetParent())
    return;

  // If there is no opaque region or hidechrome=true, set margins
  // to support a full sheet of glass. Comments in MSDN indicate
  // all values must be set to -1 to get a full sheet of glass.
  MARGINS margins = { -1, -1, -1, -1 };
  if (!aOpaqueRegion.IsEmpty()) {
    LayoutDeviceIntRect pluginBounds;
    for (nsIWidget* child = GetFirstChild(); child; child = child->GetNextSibling()) {
      if (child->IsPlugin()) {
        // Collect the bounds of all plugins for GetLargestRectangle.
        LayoutDeviceIntRect childBounds = child->GetBounds();
        pluginBounds.UnionRect(pluginBounds, childBounds);
      }
    }

    LayoutDeviceIntRect clientBounds = GetClientBounds();

    // Find the largest rectangle and use that to calculate the inset. Our top
    // priority is to include the bounds of all plugins.
    LayoutDeviceIntRect largest =
      aOpaqueRegion.GetLargestRectangle(pluginBounds);
    margins.cxLeftWidth = largest.x;
    margins.cxRightWidth = clientBounds.width - largest.XMost();
    margins.cyBottomHeight = clientBounds.height - largest.YMost();
    if (mCustomNonClient) {
      // The minimum glass height must be the caption buttons height,
      // otherwise the buttons are drawn incorrectly.
      largest.y = std::max<uint32_t>(largest.y,
                         nsUXThemeData::sCommandButtons[CMDBUTTONIDX_BUTTONBOX].cy);
    }
    margins.cyTopHeight = largest.y;
  }

  // Only update glass area if there are changes
  if (memcmp(&mGlassMargins, &margins, sizeof mGlassMargins)) {
    mGlassMargins = margins;
    UpdateGlass();
  }
}

/**************************************************************
*
* SECTION: nsIWidget::UpdateWindowDraggingRegion
*
* For setting the draggable titlebar region from CSS
* with -moz-window-dragging: drag.
*
**************************************************************/

void
nsWindow::UpdateWindowDraggingRegion(const LayoutDeviceIntRegion& aRegion)
{
  if (mDraggableRegion != aRegion) {
    mDraggableRegion = aRegion;
  }
}

void nsWindow::UpdateGlass()
{
  MARGINS margins = mGlassMargins;

  // DWMNCRP_USEWINDOWSTYLE - The non-client rendering area is
  //                          rendered based on the window style.
  // DWMNCRP_ENABLED        - The non-client area rendering is
  //                          enabled; the window style is ignored.
  DWMNCRENDERINGPOLICY policy = DWMNCRP_USEWINDOWSTYLE;
  switch (mTransparencyMode) {
  case eTransparencyBorderlessGlass:
    // Only adjust if there is some opaque rectangle
    if (margins.cxLeftWidth >= 0) {
      margins.cxLeftWidth += kGlassMarginAdjustment;
      margins.cyTopHeight += kGlassMarginAdjustment;
      margins.cxRightWidth += kGlassMarginAdjustment;
      margins.cyBottomHeight += kGlassMarginAdjustment;
    }
    // Fall through
  case eTransparencyGlass:
    policy = DWMNCRP_ENABLED;
    break;
  default:
    break;
  }

  MOZ_LOG(gWindowsLog, LogLevel::Info,
         ("glass margins: left:%d top:%d right:%d bottom:%d\n",
          margins.cxLeftWidth, margins.cyTopHeight,
          margins.cxRightWidth, margins.cyBottomHeight));

  // Extends the window frame behind the client area
  if (nsUXThemeData::CheckForCompositor()) {
    WinUtils::dwmExtendFrameIntoClientAreaPtr(mWnd, &margins);
    WinUtils::dwmSetWindowAttributePtr(mWnd, DWMWA_NCRENDERING_POLICY, &policy, sizeof policy);
  }
}
#endif

/**************************************************************
 *
 * SECTION: nsIWidget::HideWindowChrome
 *
 * Show or hide window chrome.
 *
 **************************************************************/

NS_IMETHODIMP nsWindow::HideWindowChrome(bool aShouldHide)
{
  HWND hwnd = WinUtils::GetTopLevelHWND(mWnd, true);
  if (!WinUtils::GetNSWindowPtr(hwnd))
  {
    NS_WARNING("Trying to hide window decorations in an embedded context");
    return NS_ERROR_FAILURE;
  }

  if (mHideChrome == aShouldHide)
    return NS_OK;

  DWORD_PTR style, exStyle;
  mHideChrome = aShouldHide;
  if (aShouldHide) {
    DWORD_PTR tempStyle = ::GetWindowLongPtrW(hwnd, GWL_STYLE);
    DWORD_PTR tempExStyle = ::GetWindowLongPtrW(hwnd, GWL_EXSTYLE);

    style = tempStyle & ~(WS_CAPTION | WS_THICKFRAME);
    exStyle = tempExStyle & ~(WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE |
                              WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);

    mOldStyle = tempStyle;
    mOldExStyle = tempExStyle;
  }
  else {
    if (!mOldStyle || !mOldExStyle) {
      mOldStyle = ::GetWindowLongPtrW(hwnd, GWL_STYLE);
      mOldExStyle = ::GetWindowLongPtrW(hwnd, GWL_EXSTYLE);
    }

    style = mOldStyle;
    exStyle = mOldExStyle;
    if (mFutureMarginsToUse) {
      SetNonClientMargins(mFutureMarginsOnceChromeShows);
    }
  }

  VERIFY_WINDOW_STYLE(style);
  ::SetWindowLongPtrW(hwnd, GWL_STYLE, style);
  ::SetWindowLongPtrW(hwnd, GWL_EXSTYLE, exStyle);

  return NS_OK;
}

/**************************************************************
 *
 * SECTION: nsWindow::Invalidate
 *
 * Invalidate an area of the client for painting.
 *
 **************************************************************/

// Invalidate this component visible area
NS_IMETHODIMP nsWindow::Invalidate(bool aEraseBackground,
                                   bool aUpdateNCArea,
                                   bool aIncludeChildren)
{
  if (!mWnd) {
    return NS_OK;
  }

#ifdef WIDGET_DEBUG_OUTPUT
  debug_DumpInvalidate(stdout,
                       this,
                       nullptr,
                       "noname",
                       (int32_t) mWnd);
#endif // WIDGET_DEBUG_OUTPUT

  DWORD flags = RDW_INVALIDATE;
  if (aEraseBackground) {
    flags |= RDW_ERASE;
  }
  if (aUpdateNCArea) {
    flags |= RDW_FRAME;
  }
  if (aIncludeChildren) {
    flags |= RDW_ALLCHILDREN;
  }

  VERIFY(::RedrawWindow(mWnd, nullptr, nullptr, flags));
  return NS_OK;
}

// Invalidate this component visible area
NS_IMETHODIMP nsWindow::Invalidate(const LayoutDeviceIntRect& aRect)
{
  if (mWnd) {
#ifdef WIDGET_DEBUG_OUTPUT
    debug_DumpInvalidate(stdout,
                         this,
                         &aRect,
                         "noname",
                         (int32_t) mWnd);
#endif // WIDGET_DEBUG_OUTPUT

    RECT rect;

    rect.left   = aRect.x;
    rect.top    = aRect.y;
    rect.right  = aRect.x + aRect.width;
    rect.bottom = aRect.y + aRect.height;

    VERIFY(::InvalidateRect(mWnd, &rect, FALSE));
  }
  return NS_OK;
}

static LRESULT CALLBACK
FullscreenTransitionWindowProc(HWND hWnd, UINT uMsg,
                               WPARAM wParam, LPARAM lParam)
{
  switch (uMsg) {
    case WM_FULLSCREEN_TRANSITION_BEFORE:
    case WM_FULLSCREEN_TRANSITION_AFTER: {
      DWORD duration = (DWORD)lParam;
      DWORD flags = AW_BLEND;
      if (uMsg == WM_FULLSCREEN_TRANSITION_AFTER) {
        flags |= AW_HIDE;
      }
      ::AnimateWindow(hWnd, duration, flags);
      // The message sender should have added ref for us.
      NS_DispatchToMainThread(
        already_AddRefed<nsIRunnable>((nsIRunnable*)wParam));
      break;
    }
    case WM_DESTROY:
      ::PostQuitMessage(0);
      break;
    default:
      return ::DefWindowProcW(hWnd, uMsg, wParam, lParam);
  }
  return 0;
}

struct FullscreenTransitionInitData
{
  nsIntRect mBounds;
  HANDLE mSemaphore;
  HANDLE mThread;
  HWND mWnd;

  FullscreenTransitionInitData()
    : mSemaphore(nullptr)
    , mThread(nullptr)
    , mWnd(nullptr) { }

  ~FullscreenTransitionInitData()
  {
    if (mSemaphore) {
      ::CloseHandle(mSemaphore);
    }
    if (mThread) {
      ::CloseHandle(mThread);
    }
  }
};

static DWORD WINAPI
FullscreenTransitionThreadProc(LPVOID lpParam)
{
  // Initialize window class
  static bool sInitialized = false;
  if (!sInitialized) {
    WNDCLASSW wc = {};
    wc.lpfnWndProc = ::FullscreenTransitionWindowProc;
    wc.hInstance = nsToolkit::mDllInstance;
    wc.hbrBackground = ::CreateSolidBrush(RGB(0, 0, 0));
    wc.lpszClassName = kClassNameTransition;
    ::RegisterClassW(&wc);
    sInitialized = true;
  }

  auto data = static_cast<FullscreenTransitionInitData*>(lpParam);
  HWND wnd = ::CreateWindowW(
    kClassNameTransition, L"", 0, 0, 0, 0, 0,
    nullptr, nullptr, nsToolkit::mDllInstance, nullptr);
  if (!wnd) {
    ::ReleaseSemaphore(data->mSemaphore, 1, nullptr);
    return 0;
  }

  // Since AnimateWindow blocks the thread of the transition window,
  // we need to hide the cursor for that window, otherwise the system
  // would show the busy pointer to the user.
  ::ShowCursor(false);
  ::SetWindowLongW(wnd, GWL_STYLE, 0);
  ::SetWindowLongW(wnd, GWL_EXSTYLE, WS_EX_LAYERED |
                   WS_EX_TRANSPARENT | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE);
  ::SetWindowPos(wnd, HWND_TOPMOST, data->mBounds.x, data->mBounds.y,
                 data->mBounds.width, data->mBounds.height, 0);
  data->mWnd = wnd;
  ::ReleaseSemaphore(data->mSemaphore, 1, nullptr);
  // The initialization data may no longer be valid
  // after we release the semaphore.
  data = nullptr;

  MSG msg;
  while (::GetMessageW(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }
  ::ShowCursor(true);
  ::DestroyWindow(wnd);
  return 0;
}

class FullscreenTransitionData final : public nsISupports
{
public:
  NS_DECL_ISUPPORTS

  explicit FullscreenTransitionData(HWND aWnd)
    : mWnd(aWnd)
  {
    MOZ_ASSERT(NS_IsMainThread(), "FullscreenTransitionData "
               "should be constructed in the main thread");
  }

  const HWND mWnd;

private:
  ~FullscreenTransitionData()
  {
    MOZ_ASSERT(NS_IsMainThread(), "FullscreenTransitionData "
               "should be deconstructed in the main thread");
    ::PostMessageW(mWnd, WM_DESTROY, 0, 0);
  }
};

NS_IMPL_ISUPPORTS0(FullscreenTransitionData)

/* virtual */ bool
nsWindow::PrepareForFullscreenTransition(nsISupports** aData)
{
  // We don't support fullscreen transition when composition is not
  // enabled, which could make the transition broken and annoying.
  // See bug 1184201.
  if (!nsUXThemeData::CheckForCompositor()) {
    return false;
  }

  FullscreenTransitionInitData initData;
  nsCOMPtr<nsIScreen> screen = GetWidgetScreen();
  int32_t x, y, width, height;
  screen->GetRectDisplayPix(&x, &y, &width, &height);
  MOZ_ASSERT(BoundsUseDesktopPixels(),
             "Should only be called on top-level window");
  double scale = GetDesktopToDeviceScale().scale; // XXX or GetDefaultScale() ?
  initData.mBounds.x = NSToIntRound(x * scale);
  initData.mBounds.y = NSToIntRound(y * scale);
  initData.mBounds.width = NSToIntRound(width * scale);
  initData.mBounds.height = NSToIntRound(height * scale);

  // Create a semaphore for synchronizing the window handle which will
  // be created by the transition thread and used by the main thread for
  // posting the transition messages.
  initData.mSemaphore = ::CreateSemaphore(nullptr, 0, 1, nullptr);
  if (initData.mSemaphore) {
    initData.mThread = ::CreateThread(
      nullptr, 0, FullscreenTransitionThreadProc, &initData, 0, nullptr);
    if (initData.mThread) {
      ::WaitForSingleObject(initData.mSemaphore, INFINITE);
    }
  }
  if (!initData.mWnd) {
    return false;
  }

  mTransitionWnd = initData.mWnd;
  auto data = new FullscreenTransitionData(initData.mWnd);
  *aData = data;
  NS_ADDREF(data);
  return true;
}

/* virtual */ void
nsWindow::PerformFullscreenTransition(FullscreenTransitionStage aStage,
                                      uint16_t aDuration, nsISupports* aData,
                                      nsIRunnable* aCallback)
{
  auto data = static_cast<FullscreenTransitionData*>(aData);
  nsCOMPtr<nsIRunnable> callback = aCallback;
  UINT msg = aStage == eBeforeFullscreenToggle ?
    WM_FULLSCREEN_TRANSITION_BEFORE : WM_FULLSCREEN_TRANSITION_AFTER;
  WPARAM wparam = (WPARAM)callback.forget().take();
  ::PostMessage(data->mWnd, msg, wparam, (LPARAM)aDuration);
}

nsresult
nsWindow::MakeFullScreen(bool aFullScreen, nsIScreen* aTargetScreen)
{
  // taskbarInfo will be nullptr pre Windows 7 until Bug 680227 is resolved.
  nsCOMPtr<nsIWinTaskbar> taskbarInfo =
    do_GetService(NS_TASKBAR_CONTRACTID);

  mFullscreenMode = aFullScreen;
  if (aFullScreen) {
    if (mSizeMode == nsSizeMode_Fullscreen)
      return NS_OK;
    mOldSizeMode = mSizeMode;
    SetSizeMode(nsSizeMode_Fullscreen);

    // Notify the taskbar that we will be entering full screen mode.
    if (taskbarInfo) {
      taskbarInfo->PrepareFullScreenHWND(mWnd, TRUE);
    }
  } else {
    if (mSizeMode != nsSizeMode_Fullscreen)
      return NS_OK;
    SetSizeMode(mOldSizeMode);
  }

  // If we are going fullscreen, the window size continues to change
  // and the window will be reflow again then.
  UpdateNonClientMargins(mSizeMode, /* Reflow */ !aFullScreen);

  // Will call hide chrome, reposition window. Note this will
  // also cache dimensions for restoration, so it should only
  // be called once per fullscreen request.
  nsBaseWidget::InfallibleMakeFullScreen(aFullScreen, aTargetScreen);

  if (mIsVisible && !aFullScreen && mOldSizeMode == nsSizeMode_Normal) {
    // Ensure the window exiting fullscreen get activated. Window
    // activation might be bypassed in SetSizeMode.
    DispatchFocusToTopLevelWindow(true);
  }

  // Notify the taskbar that we have exited full screen mode.
  if (!aFullScreen && taskbarInfo) {
    taskbarInfo->PrepareFullScreenHWND(mWnd, FALSE);
  }

  if (mWidgetListener) {
    mWidgetListener->SizeModeChanged(mSizeMode);
    mWidgetListener->FullscreenChanged(aFullScreen);
  }

  // Send a eMouseEnterIntoWidget event since Windows has already sent
  // a WM_MOUSELEAVE that caused us to send a eMouseExitFromWidget event.
  if (aFullScreen && !sCurrentWindow) {
    sCurrentWindow = this;
    LPARAM pos = sCurrentWindow->lParamToClient(sMouseExitlParamScreen);
    sCurrentWindow->DispatchMouseEvent(eMouseEnterIntoWidget,
                                       sMouseExitwParam, pos, false,
                                       WidgetMouseEvent::eLeftButton,
                                       MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
  }

  return NS_OK;
}

/**************************************************************
 *
 * SECTION: Native data storage
 *
 * nsIWidget::GetNativeData
 * nsIWidget::FreeNativeData
 *
 * Set or clear native data based on a constant.
 *
 **************************************************************/

// Return some native data according to aDataType
void* nsWindow::GetNativeData(uint32_t aDataType)
{
  switch (aDataType) {
    case NS_NATIVE_TMP_WINDOW:
      return (void*)::CreateWindowExW(mIsRTL ? WS_EX_LAYOUTRTL : 0,
                                      GetWindowClass(),
                                      L"",
                                      WS_CHILD,
                                      CW_USEDEFAULT,
                                      CW_USEDEFAULT,
                                      CW_USEDEFAULT,
                                      CW_USEDEFAULT,
                                      mWnd,
                                      nullptr,
                                      nsToolkit::mDllInstance,
                                      nullptr);
    case NS_NATIVE_PLUGIN_ID:
    case NS_NATIVE_PLUGIN_PORT:
    case NS_NATIVE_WIDGET:
    case NS_NATIVE_WINDOW:
      return (void*)mWnd;
    case NS_NATIVE_SHAREABLE_WINDOW:
      return (void*) WinUtils::GetTopLevelHWND(mWnd);
    case NS_NATIVE_GRAPHIC:
      MOZ_ASSERT_UNREACHABLE("Not supported on Windows:");
      return nullptr;
    case NS_RAW_NATIVE_IME_CONTEXT: {
      void* pseudoIMEContext = GetPseudoIMEContext();
      if (pseudoIMEContext) {
        return pseudoIMEContext;
      }
      MOZ_FALLTHROUGH;
    }
    case NS_NATIVE_TSF_THREAD_MGR:
    case NS_NATIVE_TSF_CATEGORY_MGR:
    case NS_NATIVE_TSF_DISPLAY_ATTR_MGR:
      return IMEHandler::GetNativeData(this, aDataType);

    default:
      break;
  }

  return nullptr;
}

static void
SetChildStyleAndParent(HWND aChildWindow, HWND aParentWindow)
{
    // Make sure the window is styled to be a child window.
    LONG_PTR style = GetWindowLongPtr(aChildWindow, GWL_STYLE);
    style |= WS_CHILD;
    style &= ~WS_POPUP;
    SetWindowLongPtr(aChildWindow, GWL_STYLE, style);

    // Do the reparenting. Note that this call will probably cause a sync native
    // message to the process that owns the child window.
    ::SetParent(aChildWindow, aParentWindow);
}

void
nsWindow::SetNativeData(uint32_t aDataType, uintptr_t aVal)
{
  switch (aDataType) {
    case NS_NATIVE_CHILD_WINDOW:
      SetChildStyleAndParent(reinterpret_cast<HWND>(aVal), mWnd);
      break;
    case NS_NATIVE_CHILD_OF_SHAREABLE_WINDOW:
      SetChildStyleAndParent(reinterpret_cast<HWND>(aVal),
                             WinUtils::GetTopLevelHWND(mWnd));
      break;
    default:
      NS_ERROR("SetNativeData called with unsupported data type.");
  }
}

// Free some native data according to aDataType
void nsWindow::FreeNativeData(void * data, uint32_t aDataType)
{
  switch (aDataType)
  {
    case NS_NATIVE_GRAPHIC:
    case NS_NATIVE_WIDGET:
    case NS_NATIVE_WINDOW:
    case NS_NATIVE_PLUGIN_PORT:
      break;
    default:
      break;
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::SetTitle
 *
 * Set the main windows title text.
 *
 **************************************************************/

NS_IMETHODIMP nsWindow::SetTitle(const nsAString& aTitle)
{
  const nsString& strTitle = PromiseFlatString(aTitle);
  AutoRestore<bool> sendingText(mSendingSetText);
  mSendingSetText = true;
  ::SendMessageW(mWnd, WM_SETTEXT, (WPARAM)0, (LPARAM)(LPCWSTR)strTitle.get());
  return NS_OK;
}

/**************************************************************
 *
 * SECTION: nsIWidget::SetIcon
 *
 * Set the main windows icon.
 *
 **************************************************************/

NS_IMETHODIMP nsWindow::SetIcon(const nsAString& aIconSpec) 
{
  // Assume the given string is a local identifier for an icon file.

  nsCOMPtr<nsIFile> iconFile;
  ResolveIconName(aIconSpec, NS_LITERAL_STRING(".ico"),
                  getter_AddRefs(iconFile));
  if (!iconFile)
    return NS_OK; // not an error if icon is not found

  nsAutoString iconPath;
  iconFile->GetPath(iconPath);

  // XXX this should use MZLU (see bug 239279)

  ::SetLastError(0);

  HICON bigIcon = (HICON)::LoadImageW(nullptr,
                                      (LPCWSTR)iconPath.get(),
                                      IMAGE_ICON,
                                      ::GetSystemMetrics(SM_CXICON),
                                      ::GetSystemMetrics(SM_CYICON),
                                      LR_LOADFROMFILE );
  HICON smallIcon = (HICON)::LoadImageW(nullptr,
                                        (LPCWSTR)iconPath.get(),
                                        IMAGE_ICON,
                                        ::GetSystemMetrics(SM_CXSMICON),
                                        ::GetSystemMetrics(SM_CYSMICON),
                                        LR_LOADFROMFILE );

  if (bigIcon) {
    HICON icon = (HICON) ::SendMessageW(mWnd, WM_SETICON, (WPARAM)ICON_BIG, (LPARAM)bigIcon);
    if (icon)
      ::DestroyIcon(icon);
    mIconBig = bigIcon;
  }
#ifdef DEBUG_SetIcon
  else {
    NS_LossyConvertUTF16toASCII cPath(iconPath);
    MOZ_LOG(gWindowsLog, LogLevel::Info,
           ("\nIcon load error; icon=%s, rc=0x%08X\n\n", 
            cPath.get(), ::GetLastError()));
  }
#endif
  if (smallIcon) {
    HICON icon = (HICON) ::SendMessageW(mWnd, WM_SETICON, (WPARAM)ICON_SMALL, (LPARAM)smallIcon);
    if (icon)
      ::DestroyIcon(icon);
    mIconSmall = smallIcon;
  }
#ifdef DEBUG_SetIcon
  else {
    NS_LossyConvertUTF16toASCII cPath(iconPath);
    MOZ_LOG(gWindowsLog, LogLevel::Info,
           ("\nSmall icon load error; icon=%s, rc=0x%08X\n\n", 
            cPath.get(), ::GetLastError()));
  }
#endif
  return NS_OK;
}

/**************************************************************
 *
 * SECTION: nsIWidget::WidgetToScreenOffset
 *
 * Return this widget's origin in screen coordinates.
 *
 **************************************************************/

LayoutDeviceIntPoint nsWindow::WidgetToScreenOffset()
{
  POINT point;
  point.x = 0;
  point.y = 0;
  ::ClientToScreen(mWnd, &point);
  return LayoutDeviceIntPoint(point.x, point.y);
}

LayoutDeviceIntSize
nsWindow::ClientToWindowSize(const LayoutDeviceIntSize& aClientSize)
{
  if (mWindowType == eWindowType_popup && !IsPopupWithTitleBar())
    return aClientSize;

  // just use (200, 200) as the position
  RECT r;
  r.left = 200;
  r.top = 200;
  r.right = 200 + aClientSize.width;
  r.bottom = 200 + aClientSize.height;
  ::AdjustWindowRectEx(&r, WindowStyle(), false, WindowExStyle());

  return LayoutDeviceIntSize(r.right - r.left, r.bottom - r.top);
}

/**************************************************************
 *
 * SECTION: nsIWidget::EnableDragDrop
 *
 * Enables/Disables drag and drop of files on this widget.
 *
 **************************************************************/

void
nsWindow::EnableDragDrop(bool aEnable)
{
  NS_ASSERTION(mWnd, "nsWindow::EnableDragDrop() called after Destroy()");

  nsresult rv = NS_ERROR_FAILURE;
  if (aEnable) {
    if (!mNativeDragTarget) {
      mNativeDragTarget = new nsNativeDragTarget(this);
      mNativeDragTarget->AddRef();
      if (SUCCEEDED(::CoLockObjectExternal((LPUNKNOWN)mNativeDragTarget,
                                           TRUE, FALSE))) {
        ::RegisterDragDrop(mWnd, (LPDROPTARGET)mNativeDragTarget);
      }
    }
  } else {
    if (mWnd && mNativeDragTarget) {
      ::RevokeDragDrop(mWnd);
      ::CoLockObjectExternal((LPUNKNOWN)mNativeDragTarget, FALSE, TRUE);
      mNativeDragTarget->DragCancel();
      NS_RELEASE(mNativeDragTarget);
    }
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::CaptureMouse
 *
 * Enables/Disables system mouse capture.
 *
 **************************************************************/

void nsWindow::CaptureMouse(bool aCapture)
{
  TRACKMOUSEEVENT mTrack;
  mTrack.cbSize = sizeof(TRACKMOUSEEVENT);
  mTrack.dwHoverTime = 0;
  mTrack.hwndTrack = mWnd;
  if (aCapture) {
    mTrack.dwFlags = TME_CANCEL | TME_LEAVE;
    ::SetCapture(mWnd);
  } else {
    mTrack.dwFlags = TME_LEAVE;
    ::ReleaseCapture();
  }
  sIsInMouseCapture = aCapture;
  TrackMouseEvent(&mTrack);
}

/**************************************************************
 *
 * SECTION: nsIWidget::CaptureRollupEvents
 *
 * Dealing with event rollup on destroy for popups. Enables &
 * Disables system capture of any and all events that would
 * cause a dropdown to be rolled up.
 *
 **************************************************************/

void
nsWindow::CaptureRollupEvents(nsIRollupListener* aListener, bool aDoCapture)
{
  if (aDoCapture) {
    gRollupListener = aListener;
    if (!sMsgFilterHook && !sCallProcHook && !sCallMouseHook) {
      RegisterSpecialDropdownHooks();
    }
    sProcessHook = true;
  } else {
    gRollupListener = nullptr;
    sProcessHook = false;
    UnregisterSpecialDropdownHooks();
  }
}

/**************************************************************
 *
 * SECTION: nsIWidget::GetAttention
 *
 * Bring this window to the user's attention.
 *
 **************************************************************/

// Draw user's attention to this window until it comes to foreground.
NS_IMETHODIMP
nsWindow::GetAttention(int32_t aCycleCount)
{
  // Got window?
  if (!mWnd)
    return NS_ERROR_NOT_INITIALIZED;

  HWND flashWnd = WinUtils::GetTopLevelHWND(mWnd, false, false);
  HWND fgWnd = ::GetForegroundWindow();
  // Don't flash if the flash count is 0 or if the foreground window is our
  // window handle or that of our owned-most window.
  if (aCycleCount == 0 || 
      flashWnd == fgWnd ||
      flashWnd == WinUtils::GetTopLevelHWND(fgWnd, false, false)) {
    return NS_OK;
  }

  DWORD defaultCycleCount = 0;
  ::SystemParametersInfo(SPI_GETFOREGROUNDFLASHCOUNT, 0, &defaultCycleCount, 0);

  FLASHWINFO flashInfo = { sizeof(FLASHWINFO), flashWnd,
    FLASHW_ALL, aCycleCount > 0 ? aCycleCount : defaultCycleCount, 0 };
  ::FlashWindowEx(&flashInfo);

  return NS_OK;
}

void nsWindow::StopFlashing()
{
  HWND flashWnd = mWnd;
  while (HWND ownerWnd = ::GetWindow(flashWnd, GW_OWNER)) {
    flashWnd = ownerWnd;
  }

  FLASHWINFO flashInfo = { sizeof(FLASHWINFO), flashWnd,
    FLASHW_STOP, 0, 0 };
  ::FlashWindowEx(&flashInfo);
}

/**************************************************************
 *
 * SECTION: nsIWidget::HasPendingInputEvent
 *
 * Ask whether there user input events pending.  All input events are
 * included, including those not targeted at this nsIwidget instance.
 *
 **************************************************************/

bool
nsWindow::HasPendingInputEvent()
{
  // If there is pending input or the user is currently
  // moving the window then return true.
  // Note: When the user is moving the window WIN32 spins
  // a separate event loop and input events are not
  // reported to the application.
  if (HIWORD(GetQueueStatus(QS_INPUT)))
    return true;
  GUITHREADINFO guiInfo;
  guiInfo.cbSize = sizeof(GUITHREADINFO);
  if (!GetGUIThreadInfo(GetCurrentThreadId(), &guiInfo))
    return false;
  return GUI_INMOVESIZE == (guiInfo.flags & GUI_INMOVESIZE);
}

/**************************************************************
 *
 * SECTION: nsIWidget::GetLayerManager
 *
 * Get the layer manager associated with this widget.
 *
 **************************************************************/

LayerManager*
nsWindow::GetLayerManager(PLayerTransactionChild* aShadowManager,
                          LayersBackend aBackendHint,
                          LayerManagerPersistence aPersistence)
{
  RECT windowRect;
  ::GetClientRect(mWnd, &windowRect);

  // Try OMTC first.
  if (!mLayerManager && ShouldUseOffMainThreadCompositing()) {
    gfxWindowsPlatform::GetPlatform()->UpdateRenderMode();

    // e10s uses the parameter to pass in the shadow manager from the TabChild
    // so we don't expect to see it there since this doesn't support e10s.
    NS_ASSERTION(aShadowManager == nullptr, "Async Compositor not supported with e10s");
    CreateCompositor();
  }

  if (!mLayerManager) {
    MOZ_ASSERT(!mCompositorSession && !mCompositorBridgeChild);
    MOZ_ASSERT(!mCompositorWidgetDelegate);

    // Ensure we have a widget proxy even if we're not using the compositor,
    // since all our transparent window handling lives there.
    CompositorWidgetInitData initData(
      reinterpret_cast<uintptr_t>(mWnd),
      reinterpret_cast<uintptr_t>(static_cast<nsIWidget*>(this)),
      mTransparencyMode);
    mBasicLayersSurface = new InProcessWinCompositorWidget(initData, this);
    mCompositorWidgetDelegate = mBasicLayersSurface;
    mLayerManager = CreateBasicLayerManager();
  }

  NS_ASSERTION(mLayerManager, "Couldn't provide a valid layer manager.");

  return mLayerManager;
}

/**************************************************************
 *
 * SECTION: nsIWidget::OnDefaultButtonLoaded
 *
 * Called after the dialog is loaded and it has a default button.
 *
 **************************************************************/
 
NS_IMETHODIMP
nsWindow::OnDefaultButtonLoaded(const LayoutDeviceIntRect& aButtonRect)
{
  if (aButtonRect.IsEmpty())
    return NS_OK;

  // Don't snap when we are not active.
  HWND activeWnd = ::GetActiveWindow();
  if (activeWnd != ::GetForegroundWindow() ||
      WinUtils::GetTopLevelHWND(mWnd, true) !=
        WinUtils::GetTopLevelHWND(activeWnd, true)) {
    return NS_OK;
  }

  bool isAlwaysSnapCursor =
    Preferences::GetBool("ui.cursor_snapping.always_enabled", false);

  if (!isAlwaysSnapCursor) {
    BOOL snapDefaultButton;
    if (!::SystemParametersInfo(SPI_GETSNAPTODEFBUTTON, 0,
                                &snapDefaultButton, 0) || !snapDefaultButton)
      return NS_OK;
  }

  LayoutDeviceIntRect widgetRect = GetScreenBounds();
  LayoutDeviceIntRect buttonRect(aButtonRect + widgetRect.TopLeft());

  LayoutDeviceIntPoint centerOfButton(buttonRect.x + buttonRect.width / 2,
                                      buttonRect.y + buttonRect.height / 2);
  // The center of the button can be outside of the widget.
  // E.g., it could be hidden by scrolling.
  if (!widgetRect.Contains(centerOfButton)) {
    return NS_OK;
  }

  if (!::SetCursorPos(centerOfButton.x, centerOfButton.y)) {
    NS_ERROR("SetCursorPos failed");
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

void
nsWindow::UpdateThemeGeometries(const nsTArray<ThemeGeometry>& aThemeGeometries)
{
  RefPtr<LayerManager> layerManager = GetLayerManager();
  if (!layerManager) {
    return;
  }

  nsIntRegion clearRegion;
  if (!HasGlass() || !nsUXThemeData::CheckForCompositor()) {
    // Make sure and clear old regions we've set previously. Note HasGlass can be false
    // for glass desktops if the window we are rendering to doesn't make use of glass
    // (e.g. fullscreen browsing).
    layerManager->SetRegionToClear(clearRegion);
    return;
  }

  // On Win10, force show the top border:
  if (IsWin10OrLater() && mCustomNonClient && mSizeMode == nsSizeMode_Normal) {
    RECT rect;
    ::GetWindowRect(mWnd, &rect);
    // We want 1 pixel of border for every whole 100% of scaling
    double borderSize = std::min(1, RoundDown(GetDesktopToDeviceScale().scale));
    clearRegion.Or(clearRegion, gfx::IntRect::Truncate(0, 0, rect.right - rect.left, borderSize));
  }

  if (!IsWin10OrLater()) {
    for (size_t i = 0; i < aThemeGeometries.Length(); i++) {
      if (aThemeGeometries[i].mType == nsNativeThemeWin::eThemeGeometryTypeWindowButtons) {
        LayoutDeviceIntRect bounds = aThemeGeometries[i].mRect;
        clearRegion.Or(clearRegion, gfx::IntRect::Truncate(bounds.X(), bounds.Y(), bounds.Width(), bounds.Height() - 2.0));
        clearRegion.Or(clearRegion, gfx::IntRect::Truncate(bounds.X() + 1.0, bounds.YMost() - 2.0, bounds.Width() - 1.0, 1.0));
        clearRegion.Or(clearRegion, gfx::IntRect::Truncate(bounds.X() + 2.0, bounds.YMost() - 1.0, bounds.Width() - 3.0, 1.0));
      }
    }
  }

  layerManager->SetRegionToClear(clearRegion);
}

uint32_t
nsWindow::GetMaxTouchPoints() const
{
  return WinUtils::GetMaxTouchPoints();
}

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Moz Events
 **
 ** Moz GUI event management. 
 **
 **************************************************************
 **************************************************************/

/**************************************************************
 *
 * SECTION: Mozilla event initialization
 *
 * Helpers for initializing moz events.
 *
 **************************************************************/

// Event initialization
void nsWindow::InitEvent(WidgetGUIEvent& event, LayoutDeviceIntPoint* aPoint)
{
  if (nullptr == aPoint) {     // use the point from the event
    // get the message position in client coordinates
    if (mWnd != nullptr) {
      DWORD pos = ::GetMessagePos();
      POINT cpos;

      cpos.x = GET_X_LPARAM(pos);
      cpos.y = GET_Y_LPARAM(pos);

      ::ScreenToClient(mWnd, &cpos);
      event.mRefPoint = LayoutDeviceIntPoint(cpos.x, cpos.y);
    } else {
      event.mRefPoint = LayoutDeviceIntPoint(0, 0);
    }
  } else {
    // use the point override if provided
    event.mRefPoint = *aPoint;
  }

  event.AssignEventTime(CurrentMessageWidgetEventTime());
}

WidgetEventTime
nsWindow::CurrentMessageWidgetEventTime() const
{
  LONG messageTime = ::GetMessageTime();
  return WidgetEventTime(messageTime, GetMessageTimeStamp(messageTime));
}

/**************************************************************
 *
 * SECTION: Moz event dispatch helpers
 *
 * Helpers for dispatching different types of moz events.
 *
 **************************************************************/

// Main event dispatch. Invokes callback and ProcessEvent method on
// Event Listener object. Part of nsIWidget.
NS_IMETHODIMP nsWindow::DispatchEvent(WidgetGUIEvent* event,
                                      nsEventStatus& aStatus)
{
#ifdef WIDGET_DEBUG_OUTPUT
  debug_DumpEvent(stdout,
                  event->mWidget,
                  event,
                  "something",
                  (int32_t) mWnd);
#endif // WIDGET_DEBUG_OUTPUT

  aStatus = nsEventStatus_eIgnore;

  // Top level windows can have a view attached which requires events be sent
  // to the underlying base window and the view. Added when we combined the
  // base chrome window with the main content child for nc client area (title
  // bar) rendering.
  if (mAttachedWidgetListener) {
    aStatus = mAttachedWidgetListener->HandleEvent(event, mUseAttachedEvents);
  }
  else if (mWidgetListener) {
    aStatus = mWidgetListener->HandleEvent(event, mUseAttachedEvents);
  }

  // the window can be destroyed during processing of seemingly innocuous events like, say,
  // mousedowns due to the magic of scripting. mousedowns will return nsEventStatus_eIgnore,
  // which causes problems with the deleted window. therefore:
  if (mOnDestroyCalled)
    aStatus = nsEventStatus_eConsumeNoDefault;
  return NS_OK;
}

bool nsWindow::DispatchStandardEvent(EventMessage aMsg)
{
  WidgetGUIEvent event(true, aMsg, this);
  InitEvent(event);

  bool result = DispatchWindowEvent(&event);
  return result;
}

bool nsWindow::DispatchKeyboardEvent(WidgetKeyboardEvent* event)
{
  nsEventStatus status = DispatchInputEvent(event);
  return ConvertStatus(status);
}

bool nsWindow::DispatchContentCommandEvent(WidgetContentCommandEvent* aEvent)
{
  nsEventStatus status;
  DispatchEvent(aEvent, status);
  return ConvertStatus(status);
}

bool nsWindow::DispatchWheelEvent(WidgetWheelEvent* aEvent)
{
  nsEventStatus status = DispatchInputEvent(aEvent->AsInputEvent());
  return ConvertStatus(status);
}

bool nsWindow::DispatchWindowEvent(WidgetGUIEvent* event)
{
  nsEventStatus status;
  DispatchEvent(event, status);
  return ConvertStatus(status);
}

bool nsWindow::DispatchWindowEvent(WidgetGUIEvent* event,
                                   nsEventStatus& aStatus)
{
  DispatchEvent(event, aStatus);
  return ConvertStatus(aStatus);
}

// Recursively dispatch synchronous paints for nsIWidget
// descendants with invalidated rectangles.
BOOL CALLBACK nsWindow::DispatchStarvedPaints(HWND aWnd, LPARAM aMsg)
{
  LONG_PTR proc = ::GetWindowLongPtrW(aWnd, GWLP_WNDPROC);
  if (proc == (LONG_PTR)&nsWindow::WindowProc) {
    // its one of our windows so check to see if it has a
    // invalidated rect. If it does. Dispatch a synchronous
    // paint.
    if (GetUpdateRect(aWnd, nullptr, FALSE))
      VERIFY(::UpdateWindow(aWnd));
  }
  return TRUE;
}

// Check for pending paints and dispatch any pending paint
// messages for any nsIWidget which is a descendant of the
// top-level window that *this* window is embedded within.
//
// Note: We do not dispatch pending paint messages for non
// nsIWidget managed windows.
void nsWindow::DispatchPendingEvents()
{
  if (mPainting) {
    NS_WARNING("We were asked to dispatch pending events during painting, "
               "denying since that's unsafe.");
    return;
  }

  // We need to ensure that reflow events do not get starved.
  // At the same time, we don't want to recurse through here
  // as that would prevent us from dispatching starved paints.
  static int recursionBlocker = 0;
  if (recursionBlocker++ == 0) {
    NS_ProcessPendingEvents(nullptr, PR_MillisecondsToInterval(100));
    --recursionBlocker;
  }

  // Quickly check to see if there are any paint events pending,
  // but only dispatch them if it has been long enough since the
  // last paint completed.
  if (::GetQueueStatus(QS_PAINT) &&
      ((TimeStamp::Now() - mLastPaintEndTime).ToMilliseconds() >= 50)) {
    // Find the top level window.
    HWND topWnd = WinUtils::GetTopLevelHWND(mWnd);

    // Dispatch pending paints for topWnd and all its descendant windows.
    // Note: EnumChildWindows enumerates all descendant windows not just
    // the children (but not the window itself).
    nsWindow::DispatchStarvedPaints(topWnd, 0);
    ::EnumChildWindows(topWnd, nsWindow::DispatchStarvedPaints, 0);
  }
}

bool nsWindow::DispatchPluginEvent(UINT aMessage,
                                     WPARAM aWParam,
                                     LPARAM aLParam,
                                     bool aDispatchPendingEvents)
{
  bool ret = nsWindowBase::DispatchPluginEvent(
               WinUtils::InitMSG(aMessage, aWParam, aLParam, mWnd));
  if (aDispatchPendingEvents && !Destroyed()) {
    DispatchPendingEvents();
  }
  return ret;
}

// Deal with all sort of mouse event
bool
nsWindow::DispatchMouseEvent(EventMessage aEventMessage, WPARAM wParam,
                             LPARAM lParam, bool aIsContextMenuKey,
                             int16_t aButton, uint16_t aInputSource,
                             uint16_t aPointerId)
{
  bool result = false;

  UserActivity();

  if (!mWidgetListener) {
    return result;
  }

  LayoutDeviceIntPoint eventPoint(GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
  LayoutDeviceIntPoint mpScreen = eventPoint + WidgetToScreenOffset();

  // Suppress mouse moves caused by widget creation. Make sure to do this early
  // so that we update sLastMouseMovePoint even for touch-induced mousemove events.
  if (aEventMessage == eMouseMove) {
    if ((sLastMouseMovePoint.x == mpScreen.x) && (sLastMouseMovePoint.y == mpScreen.y)) {
      return result;
    }
    sLastMouseMovePoint.x = mpScreen.x;
    sLastMouseMovePoint.y = mpScreen.y;
  }

  if (WinUtils::GetIsMouseFromTouch(aEventMessage)) {
    if (aEventMessage == eMouseDown) {
      Telemetry::Accumulate(Telemetry::FX_TOUCH_USED, 1);
    }

    if (mTouchWindow) {
      // If mTouchWindow is true, then we must have APZ enabled and be
      // feeding it raw touch events. In that case we don't need to
      // send touch-generated mouse events to content. The only exception is
      // the touch-generated mouse double-click, which is used to start off the
      // touch-based drag-and-drop gesture.
      MOZ_ASSERT(mAPZC);
      if (aEventMessage == eMouseDoubleClick) {
        aEventMessage = eMouseTouchDrag;
      } else {
        return result;
      }
    }
  }

  // Since it is unclear whether a user will use the digitizer,
  // Postpone initialization until first PEN message will be found.
  if (nsIDOMMouseEvent::MOZ_SOURCE_PEN == aInputSource
      // Messages should be only at topLevel window.
      && nsWindowType::eWindowType_toplevel == mWindowType
      // Currently this scheme is used only when pointer events is enabled.
      && gfxPrefs::PointerEventsEnabled()) {
    InkCollector::sInkCollector->SetTarget(mWnd);
    InkCollector::sInkCollector->SetPointerId(aPointerId);
  }

  switch (aEventMessage) {
    case eMouseDown:
      CaptureMouse(true);
      break;

    // eMouseMove and eMouseExitFromWidget are here because we need to make
    // sure capture flag isn't left on after a drag where we wouldn't see a
    // button up message (see bug 324131).
    case eMouseUp:
    case eMouseMove:
    case eMouseExitFromWidget:
      if (!(wParam & (MK_LBUTTON | MK_MBUTTON | MK_RBUTTON)) && sIsInMouseCapture)
        CaptureMouse(false);
      break;

    default:
      break;

  } // switch

  WidgetMouseEvent event(true, aEventMessage, this, WidgetMouseEvent::eReal,
                         aIsContextMenuKey ? WidgetMouseEvent::eContextMenuKey :
                                             WidgetMouseEvent::eNormal);
  if (aEventMessage == eContextMenu && aIsContextMenuKey) {
    LayoutDeviceIntPoint zero(0, 0);
    InitEvent(event, &zero);
  } else {
    InitEvent(event, &eventPoint);
  }

  ModifierKeyState modifierKeyState;
  modifierKeyState.InitInputEvent(event);
  event.button    = aButton;
  event.inputSource = aInputSource;
  event.pointerId = aPointerId;
  // If we get here the mouse events must be from non-touch sources, so
  // convert it to pointer events as well
  event.convertToPointer = true;

  bool insideMovementThreshold = (DeprecatedAbs(sLastMousePoint.x - eventPoint.x) < (short)::GetSystemMetrics(SM_CXDOUBLECLK)) &&
                                   (DeprecatedAbs(sLastMousePoint.y - eventPoint.y) < (short)::GetSystemMetrics(SM_CYDOUBLECLK));

  BYTE eventButton;
  switch (aButton) {
    case WidgetMouseEvent::eLeftButton:
      eventButton = VK_LBUTTON;
      break;
    case WidgetMouseEvent::eMiddleButton:
      eventButton = VK_MBUTTON;
      break;
    case WidgetMouseEvent::eRightButton:
      eventButton = VK_RBUTTON;
      break;
    default:
      eventButton = 0;
      break;
  }

  // Doubleclicks are used to set the click count, then changed to mousedowns
  // We're going to time double-clicks from mouse *up* to next mouse *down*
  LONG curMsgTime = ::GetMessageTime();

  switch (aEventMessage) {
    case eMouseDoubleClick:
      event.mMessage = eMouseDown;
      event.button = aButton;
      sLastClickCount = 2;
      sLastMouseDownTime = curMsgTime;
      break;
    case eMouseUp:
      // remember when this happened for the next mouse down
      sLastMousePoint.x = eventPoint.x;
      sLastMousePoint.y = eventPoint.y;
      sLastMouseButton = eventButton;
      break;
    case eMouseDown:
      // now look to see if we want to convert this to a double- or triple-click
      if (((curMsgTime - sLastMouseDownTime) < (LONG)::GetDoubleClickTime()) &&
          insideMovementThreshold &&
          eventButton == sLastMouseButton) {
        sLastClickCount ++;
      } else {
        // reset the click count, to count *this* click
        sLastClickCount = 1;
      }
      // Set last Click time on MouseDown only
      sLastMouseDownTime = curMsgTime;
      break;
    case eMouseMove:
      if (!insideMovementThreshold) {
        sLastClickCount = 0;
      }
      break;
    case eMouseExitFromWidget:
      event.mExitFrom =
        IsTopLevelMouseExit(mWnd) ? WidgetMouseEvent::eTopLevel :
                                    WidgetMouseEvent::eChild;
      break;
    default:
      break;
  }
  event.mClickCount = sLastClickCount;

#ifdef NS_DEBUG_XX
  MOZ_LOG(gWindowsLog, LogLevel::Info,
         ("Msg Time: %d Click Count: %d\n", curMsgTime, event.mClickCount));
#endif

  NPEvent pluginEvent;

  switch (aEventMessage) {
    case eMouseDown:
      switch (aButton) {
        case WidgetMouseEvent::eLeftButton:
          pluginEvent.event = WM_LBUTTONDOWN;
          break;
        case WidgetMouseEvent::eMiddleButton:
          pluginEvent.event = WM_MBUTTONDOWN;
          break;
        case WidgetMouseEvent::eRightButton:
          pluginEvent.event = WM_RBUTTONDOWN;
          break;
        default:
          break;
      }
      break;
    case eMouseUp:
      switch (aButton) {
        case WidgetMouseEvent::eLeftButton:
          pluginEvent.event = WM_LBUTTONUP;
          break;
        case WidgetMouseEvent::eMiddleButton:
          pluginEvent.event = WM_MBUTTONUP;
          break;
        case WidgetMouseEvent::eRightButton:
          pluginEvent.event = WM_RBUTTONUP;
          break;
        default:
          break;
      }
      break;
    case eMouseDoubleClick:
      switch (aButton) {
        case WidgetMouseEvent::eLeftButton:
          pluginEvent.event = WM_LBUTTONDBLCLK;
          break;
        case WidgetMouseEvent::eMiddleButton:
          pluginEvent.event = WM_MBUTTONDBLCLK;
          break;
        case WidgetMouseEvent::eRightButton:
          pluginEvent.event = WM_RBUTTONDBLCLK;
          break;
        default:
          break;
      }
      break;
    case eMouseMove:
      pluginEvent.event = WM_MOUSEMOVE;
      break;
    case eMouseExitFromWidget:
      pluginEvent.event = WM_MOUSELEAVE;
      break;
    default:
      pluginEvent.event = WM_NULL;
      break;
  }

  pluginEvent.wParam = wParam;     // plugins NEED raw OS event flags!
  pluginEvent.lParam = lParam;

  event.mPluginEvent.Copy(pluginEvent);

  // call the event callback
  if (mWidgetListener) {
    if (aEventMessage == eMouseMove) {
      LayoutDeviceIntRect rect = GetBounds();
      rect.x = 0;
      rect.y = 0;

      if (rect.Contains(event.mRefPoint)) {
        if (sCurrentWindow == nullptr || sCurrentWindow != this) {
          if ((nullptr != sCurrentWindow) && (!sCurrentWindow->mInDtor)) {
            LPARAM pos = sCurrentWindow->lParamToClient(lParamToScreen(lParam));
            sCurrentWindow->DispatchMouseEvent(eMouseExitFromWidget,
                                               wParam, pos, false, 
                                               WidgetMouseEvent::eLeftButton,
                                               aInputSource, aPointerId);
          }
          sCurrentWindow = this;
          if (!mInDtor) {
            LPARAM pos = sCurrentWindow->lParamToClient(lParamToScreen(lParam));
            sCurrentWindow->DispatchMouseEvent(eMouseEnterIntoWidget,
                                               wParam, pos, false,
                                               WidgetMouseEvent::eLeftButton,
                                               aInputSource, aPointerId);
          }
        }
      }
    } else if (aEventMessage == eMouseExitFromWidget) {
      sMouseExitwParam = wParam;
      sMouseExitlParamScreen = lParamToScreen(lParam);
      if (sCurrentWindow == this) {
        sCurrentWindow = nullptr;
      }
    }

    result = ConvertStatus(DispatchInputEvent(&event));

    // Release the widget with NS_IF_RELEASE() just in case
    // the context menu key code in EventListenerManager::HandleEvent()
    // released it already.
    return result;
  }

  return result;
}

void nsWindow::DispatchFocusToTopLevelWindow(bool aIsActivate)
{
  if (aIsActivate)
    sJustGotActivate = false;
  sJustGotDeactivate = false;

  // retrive the toplevel window or dialog
  HWND curWnd = mWnd;
  HWND toplevelWnd = nullptr;
  while (curWnd) {
    toplevelWnd = curWnd;

    nsWindow *win = WinUtils::GetNSWindowPtr(curWnd);
    if (win) {
      nsWindowType wintype = win->WindowType();
      if (wintype == eWindowType_toplevel || wintype == eWindowType_dialog)
        break;
    }

    curWnd = ::GetParent(curWnd); // Parent or owner (if has no parent)
  }

  if (toplevelWnd) {
    nsWindow *win = WinUtils::GetNSWindowPtr(toplevelWnd);
    if (win && win->mWidgetListener) {
      if (aIsActivate) {
        win->mWidgetListener->WindowActivated();
      } else {
        if (!win->BlurEventsSuppressed()) {
          win->mWidgetListener->WindowDeactivated();
        }
      }
    }
  }
}

bool nsWindow::IsTopLevelMouseExit(HWND aWnd)
{
  DWORD pos = ::GetMessagePos();
  POINT mp;
  mp.x = GET_X_LPARAM(pos);
  mp.y = GET_Y_LPARAM(pos);
  HWND mouseWnd = ::WindowFromPoint(mp);

  // WinUtils::GetTopLevelHWND() will return a HWND for the window frame
  // (which includes the non-client area).  If the mouse has moved into
  // the non-client area, we should treat it as a top-level exit.
  HWND mouseTopLevel = WinUtils::GetTopLevelHWND(mouseWnd);
  if (mouseWnd == mouseTopLevel)
    return true;

  return WinUtils::GetTopLevelHWND(aWnd) != mouseTopLevel;
}

bool nsWindow::BlurEventsSuppressed()
{
  // are they suppressed in this window?
  if (mBlurSuppressLevel > 0)
    return true;

  // are they suppressed by any container widget?
  HWND parentWnd = ::GetParent(mWnd);
  if (parentWnd) {
    nsWindow *parent = WinUtils::GetNSWindowPtr(parentWnd);
    if (parent)
      return parent->BlurEventsSuppressed();
  }
  return false;
}

// In some circumstances (opening dependent windows) it makes more sense
// (and fixes a crash bug) to not blur the parent window. Called from
// nsFilePicker.
void nsWindow::SuppressBlurEvents(bool aSuppress)
{
  if (aSuppress)
    ++mBlurSuppressLevel; // for this widget
  else {
    NS_ASSERTION(mBlurSuppressLevel > 0, "unbalanced blur event suppression");
    if (mBlurSuppressLevel > 0)
      --mBlurSuppressLevel;
  }
}

bool nsWindow::ConvertStatus(nsEventStatus aStatus)
{
  return aStatus == nsEventStatus_eConsumeNoDefault;
}

/**************************************************************
 *
 * SECTION: IPC
 *
 * IPC related helpers.
 *
 **************************************************************/

// static
bool
nsWindow::IsAsyncResponseEvent(UINT aMsg, LRESULT& aResult)
{
  switch(aMsg) {
    case WM_SETFOCUS:
    case WM_KILLFOCUS:
    case WM_ENABLE:
    case WM_WINDOWPOSCHANGING:
    case WM_WINDOWPOSCHANGED:
    case WM_PARENTNOTIFY:
    case WM_ACTIVATEAPP:
    case WM_NCACTIVATE:
    case WM_ACTIVATE:
    case WM_CHILDACTIVATE:
    case WM_IME_SETCONTEXT:
    case WM_IME_NOTIFY:
    case WM_SHOWWINDOW:
    case WM_CANCELMODE:
    case WM_MOUSEACTIVATE:
    case WM_CONTEXTMENU:
      aResult = 0;
    return true;

    case WM_SETTINGCHANGE:
    case WM_SETCURSOR:
    return false;
  }

#ifdef DEBUG
  char szBuf[200];
  sprintf(szBuf,
    "An unhandled ISMEX_SEND message was received during spin loop! (%X)", aMsg);
  NS_WARNING(szBuf);
#endif

  return false;
}

void
nsWindow::IPCWindowProcHandler(UINT& msg, WPARAM& wParam, LPARAM& lParam)
{
  MOZ_ASSERT_IF(msg != WM_GETOBJECT,
                !mozilla::ipc::MessageChannel::IsPumpingMessages() ||
                mozilla::ipc::SuppressedNeuteringRegion::IsNeuteringSuppressed());

  // Modal UI being displayed in windowless plugins.
  if (mozilla::ipc::MessageChannel::IsSpinLoopActive() &&
      (InSendMessageEx(nullptr) & (ISMEX_REPLIED|ISMEX_SEND)) == ISMEX_SEND) {
    LRESULT res;
    if (IsAsyncResponseEvent(msg, res)) {
      ReplyMessage(res);
    }
    return;
  }

  // Handle certain sync plugin events sent to the parent which
  // trigger ipc calls that result in deadlocks.

  DWORD dwResult = 0;
  bool handled = false;

  switch(msg) {
    // Windowless flash sending WM_ACTIVATE events to the main window
    // via calls to ShowWindow.
    case WM_ACTIVATE:
      if (lParam != 0 && LOWORD(wParam) == WA_ACTIVE &&
          IsWindow((HWND)lParam)) {
        // Check for Adobe Reader X sync activate message from their
        // helper window and ignore. Fixes an annoying focus problem.
        if ((InSendMessageEx(nullptr) & (ISMEX_REPLIED|ISMEX_SEND)) == ISMEX_SEND) {
          wchar_t szClass[10];
          HWND focusWnd = (HWND)lParam;
          if (IsWindowVisible(focusWnd) &&
              GetClassNameW(focusWnd, szClass,
                            sizeof(szClass)/sizeof(char16_t)) &&
              !wcscmp(szClass, L"Edit") &&
              !WinUtils::IsOurProcessWindow(focusWnd)) {
            break;
          }
        }
        handled = true;
      }
    break;
    // Plugins taking or losing focus triggering focus app messages.
    case WM_SETFOCUS:
    case WM_KILLFOCUS:
    // Windowed plugins that pass sys key events to defwndproc generate
    // WM_SYSCOMMAND events to the main window.
    case WM_SYSCOMMAND:
    // Windowed plugins that fire context menu selection events to parent
    // windows.
    case WM_CONTEXTMENU:
    // IME events fired as a result of synchronous focus changes
    case WM_IME_SETCONTEXT:
      handled = true;
    break;
  }

  if (handled &&
      (InSendMessageEx(nullptr) & (ISMEX_REPLIED|ISMEX_SEND)) == ISMEX_SEND) {
    ReplyMessage(dwResult);
  }
}

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Native events
 **
 ** Main Windows message handlers and OnXXX handlers for
 ** Windows event handling.
 **
 **************************************************************
 **************************************************************/

/**************************************************************
 *
 * SECTION: Wind proc.
 *
 * The main Windows event procedures and associated
 * message processing methods.
 *
 **************************************************************/

static bool
DisplaySystemMenu(HWND hWnd, nsSizeMode sizeMode, bool isRtl, int32_t x, int32_t y)
{
  HMENU hMenu = GetSystemMenu(hWnd, FALSE);
  if (hMenu) {
    MENUITEMINFO mii;
    mii.cbSize = sizeof(MENUITEMINFO);
    mii.fMask = MIIM_STATE;
    mii.fType = 0;

    // update the options
    mii.fState = MF_ENABLED;
    SetMenuItemInfo(hMenu, SC_RESTORE, FALSE, &mii);
    SetMenuItemInfo(hMenu, SC_SIZE, FALSE, &mii);
    SetMenuItemInfo(hMenu, SC_MOVE, FALSE, &mii);
    SetMenuItemInfo(hMenu, SC_MAXIMIZE, FALSE, &mii);
    SetMenuItemInfo(hMenu, SC_MINIMIZE, FALSE, &mii);

    mii.fState = MF_GRAYED;
    switch(sizeMode) {
      case nsSizeMode_Fullscreen:
        // intentional fall through
      case nsSizeMode_Maximized:
        SetMenuItemInfo(hMenu, SC_SIZE, FALSE, &mii);
        SetMenuItemInfo(hMenu, SC_MOVE, FALSE, &mii);
        SetMenuItemInfo(hMenu, SC_MAXIMIZE, FALSE, &mii);
        break;
      case nsSizeMode_Minimized:
        SetMenuItemInfo(hMenu, SC_MINIMIZE, FALSE, &mii);
        break;
      case nsSizeMode_Normal:
        SetMenuItemInfo(hMenu, SC_RESTORE, FALSE, &mii);
        break;
    }
    LPARAM cmd =
      TrackPopupMenu(hMenu,
                     (TPM_LEFTBUTTON|TPM_RIGHTBUTTON|
                      TPM_RETURNCMD|TPM_TOPALIGN|
                      (isRtl ? TPM_RIGHTALIGN : TPM_LEFTALIGN)),
                     x, y, 0, hWnd, nullptr);
    if (cmd) {
      PostMessage(hWnd, WM_SYSCOMMAND, cmd, 0);
      return true;
    }
  }
  return false;
}

inline static mozilla::HangMonitor::ActivityType ActivityTypeForMessage(UINT msg)
{
  if ((msg >= WM_KEYFIRST && msg <= WM_IME_KEYLAST) ||
      (msg >= WM_MOUSEFIRST && msg <= WM_MOUSELAST) ||
      (msg >= MOZ_WM_MOUSEWHEEL_FIRST && msg <= MOZ_WM_MOUSEWHEEL_LAST) ||
      (msg >= NS_WM_IMEFIRST && msg <= NS_WM_IMELAST)) {
    return mozilla::HangMonitor::kUIActivity;
  }

  // This may not actually be right, but we don't want to reset the timer if
  // we're not actually processing a UI message.
  return mozilla::HangMonitor::kActivityUIAVail;
}

// The WndProc procedure for all nsWindows in this toolkit. This merely catches
// exceptions and passes the real work to WindowProcInternal. See bug 587406
// and http://msdn.microsoft.com/en-us/library/ms633573%28VS.85%29.aspx
LRESULT CALLBACK nsWindow::WindowProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
  mozilla::ipc::CancelCPOWs();

  HangMonitor::NotifyActivity(ActivityTypeForMessage(msg));

  return mozilla::CallWindowProcCrashProtected(WindowProcInternal, hWnd, msg, wParam, lParam);
}

LRESULT CALLBACK nsWindow::WindowProcInternal(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
  if (::GetWindowLongPtrW(hWnd, GWLP_ID) == eFakeTrackPointScrollableID) {
    // This message was sent to the FAKETRACKPOINTSCROLLABLE.
    if (msg == WM_HSCROLL) {
      // Route WM_HSCROLL messages to the main window.
      hWnd = ::GetParent(::GetParent(hWnd));
    } else {
      // Handle all other messages with its original window procedure.
      WNDPROC prevWindowProc = (WNDPROC)::GetWindowLongPtr(hWnd, GWLP_USERDATA);
      return ::CallWindowProcW(prevWindowProc, hWnd, msg, wParam, lParam);
    }
  }

  if (msg == MOZ_WM_TRACE) {
    // This is a tracer event for measuring event loop latency.
    // See WidgetTraceEvent.cpp for more details.
    mozilla::SignalTracerThread();
    return 0;
  }

  // Get the window which caused the event and ask it to process the message
  nsWindow *targetWindow = WinUtils::GetNSWindowPtr(hWnd);
  NS_ASSERTION(targetWindow, "nsWindow* is null!");
  if (!targetWindow)
    return ::DefWindowProcW(hWnd, msg, wParam, lParam);

  // Hold the window for the life of this method, in case it gets
  // destroyed during processing, unless we're in the dtor already.
  nsCOMPtr<nsIWidget> kungFuDeathGrip;
  if (!targetWindow->mInDtor)
    kungFuDeathGrip = targetWindow;

  targetWindow->IPCWindowProcHandler(msg, wParam, lParam);

  // Create this here so that we store the last rolled up popup until after
  // the event has been processed.
  nsAutoRollup autoRollup;

  LRESULT popupHandlingResult;
  if (DealWithPopups(hWnd, msg, wParam, lParam, &popupHandlingResult))
    return popupHandlingResult;

  // Call ProcessMessage
  LRESULT retValue;
  if (targetWindow->ProcessMessage(msg, wParam, lParam, &retValue)) {
    return retValue;
  }

  LRESULT res = ::CallWindowProcW(targetWindow->GetPrevWindowProc(),
                                  hWnd, msg, wParam, lParam);

  return res;
}

// The main windows message processing method for plugins.
// The result means whether this method processed the native
// event for plugin. If false, the native event should be
// processed by the caller self.
bool
nsWindow::ProcessMessageForPlugin(const MSG &aMsg,
                                  MSGResult& aResult)
{
  aResult.mResult = 0;
  aResult.mConsumed = true;

  bool eventDispatched = false;
  switch (aMsg.message) {
    case WM_CHAR:
    case WM_SYSCHAR:
      aResult.mResult = ProcessCharMessage(aMsg, &eventDispatched);
      break;

    case WM_KEYUP:
    case WM_SYSKEYUP:
      aResult.mResult = ProcessKeyUpMessage(aMsg, &eventDispatched);
      break;

    case WM_KEYDOWN:
    case WM_SYSKEYDOWN:
      aResult.mResult = ProcessKeyDownMessage(aMsg, &eventDispatched);
      break;

    case WM_DEADCHAR:
    case WM_SYSDEADCHAR:

    case WM_CUT:
    case WM_COPY:
    case WM_PASTE:
    case WM_CLEAR:
    case WM_UNDO:
      break;

    default:
      return false;
  }

  if (!eventDispatched) {
    aResult.mConsumed = nsWindowBase::DispatchPluginEvent(aMsg);
  }
  if (!Destroyed()) {
    DispatchPendingEvents();
  }
  return true;
}

static void ForceFontUpdate()
{
  // update device context font cache
  // Dirty but easiest way:
  // Changing nsIPrefBranch entry which triggers callbacks
  // and flows into calling mDeviceContext->FlushFontCache()
  // to update the font cache in all the instance of Browsers
  static const char kPrefName[] = "font.internaluseonly.changed";
  bool fontInternalChange =
    Preferences::GetBool(kPrefName, false);
  Preferences::SetBool(kPrefName, !fontInternalChange);
}

static bool CleartypeSettingChanged()
{
  static int currentQuality = -1;
  BYTE quality = cairo_win32_get_system_text_quality();

  if (currentQuality == quality)
    return false;

  if (currentQuality < 0) {
    currentQuality = quality;
    return false;
  }
  currentQuality = quality;
  return true;
}

bool
nsWindow::ExternalHandlerProcessMessage(UINT aMessage,
                                        WPARAM& aWParam,
                                        LPARAM& aLParam,
                                        MSGResult& aResult)
{
  if (mWindowHook.Notify(mWnd, aMessage, aWParam, aLParam, aResult)) {
    return true;
  }

  if (IMEHandler::ProcessMessage(this, aMessage, aWParam, aLParam, aResult)) {
    return true;
  }

  if (MouseScrollHandler::ProcessMessage(this, aMessage, aWParam, aLParam,
                                         aResult)) {
    return true;
  }

  if (PluginHasFocus()) {
    MSG nativeMsg = WinUtils::InitMSG(aMessage, aWParam, aLParam, mWnd);
    if (ProcessMessageForPlugin(nativeMsg, aResult)) {
      return true;
    }
  }

  return false;
}

// The main windows message processing method.
bool
nsWindow::ProcessMessage(UINT msg, WPARAM& wParam, LPARAM& lParam,
                         LRESULT *aRetValue)
{
#if defined(EVENT_DEBUG_OUTPUT)
  // First param shows all events, second param indicates whether
  // to show mouse move events. See nsWindowDbg for details.
  PrintEvent(msg, SHOW_REPEAT_EVENTS, SHOW_MOUSEMOVE_EVENTS);
#endif

  MSGResult msgResult(aRetValue);
  if (ExternalHandlerProcessMessage(msg, wParam, lParam, msgResult)) {
    return (msgResult.mConsumed || !mWnd);
  }

  bool result = false;    // call the default nsWindow proc
  *aRetValue = 0;

  // Glass hit testing w/custom transparent margins
  LRESULT dwmHitResult;
  if (mCustomNonClient &&
      nsUXThemeData::CheckForCompositor() &&
      /* We don't do this for win10 glass with a custom titlebar,
       * in order to avoid the caption buttons breaking. */
      !(IsWin10OrLater() && HasGlass()) &&
      WinUtils::dwmDwmDefWindowProcPtr(mWnd, msg, wParam, lParam, &dwmHitResult)) {
    *aRetValue = dwmHitResult;
    return true;
  }

  // (Large blocks of code should be broken out into OnEvent handlers.)
  switch (msg) {
    // WM_QUERYENDSESSION must be handled by all windows.
    // Otherwise Windows thinks the window can just be killed at will.
    case WM_QUERYENDSESSION:
      if (sCanQuit == TRI_UNKNOWN)
      {
        // Ask if it's ok to quit, and store the answer until we
        // get WM_ENDSESSION signaling the round is complete.
        nsCOMPtr<nsIObserverService> obsServ =
          mozilla::services::GetObserverService();
        nsCOMPtr<nsISupportsPRBool> cancelQuit =
          do_CreateInstance(NS_SUPPORTS_PRBOOL_CONTRACTID);
        cancelQuit->SetData(false);
        obsServ->NotifyObservers(cancelQuit, "quit-application-requested", nullptr);

        bool abortQuit;
        cancelQuit->GetData(&abortQuit);
        sCanQuit = abortQuit ? TRI_FALSE : TRI_TRUE;
      }
      *aRetValue = sCanQuit ? TRUE : FALSE;
      result = true;
      break;

    case WM_ENDSESSION:
    case MOZ_WM_APP_QUIT:
      if (msg == MOZ_WM_APP_QUIT || (wParam == TRUE && sCanQuit == TRI_TRUE))
      {
        // Let's fake a shutdown sequence without actually closing windows etc.
        // to avoid Windows killing us in the middle. A proper shutdown would
        // require having a chance to pump some messages. Unfortunately
        // Windows won't let us do that. Bug 212316.
        nsCOMPtr<nsIObserverService> obsServ =
          mozilla::services::GetObserverService();
        NS_NAMED_LITERAL_STRING(context, "shutdown-persist");
        NS_NAMED_LITERAL_STRING(syncShutdown, "syncShutdown");
        obsServ->NotifyObservers(nullptr, "quit-application-granted", syncShutdown.get());
        obsServ->NotifyObservers(nullptr, "quit-application-forced", nullptr);
        obsServ->NotifyObservers(nullptr, "quit-application", nullptr);
        obsServ->NotifyObservers(nullptr, "profile-change-net-teardown", context.get());
        obsServ->NotifyObservers(nullptr, "profile-change-teardown", context.get());
        obsServ->NotifyObservers(nullptr, "profile-before-change", context.get());
        obsServ->NotifyObservers(nullptr, "profile-before-change-qm", context.get());
        obsServ->NotifyObservers(nullptr, "profile-before-change-telemetry", context.get());
        // Then a controlled but very quick exit.
        _exit(0);
      }
      sCanQuit = TRI_UNKNOWN;
      result = true;
      break;

    case WM_SYSCOLORCHANGE:
      OnSysColorChanged();
      break;

    case WM_THEMECHANGED:
    {
      // Update non-client margin offsets 
      UpdateNonClientMargins();
      nsUXThemeData::InitTitlebarInfo();
      nsUXThemeData::UpdateNativeThemeInfo();

      NotifyThemeChanged();

      // Invalidate the window so that the repaint will
      // pick up the new theme.
      Invalidate(true, true, true);
    }
    break;

    case WM_WTSSESSION_CHANGE:
    {
      switch (wParam) {
        case WTS_CONSOLE_CONNECT:
        case WTS_REMOTE_CONNECT:
        case WTS_SESSION_UNLOCK:
          // When a session becomes visible, we should invalidate.
          Invalidate(true, true, true);
          break;
        default:
          break;
      }
    }
    break;

    case WM_FONTCHANGE:
    {
      // We only handle this message for the hidden window,
      // as we only need to update the (global) font list once
      // for any given change, not once per window!
      if (mWindowType != eWindowType_invisible) {
        break;
      }

      nsresult rv;
      bool didChange = false;

      // update the global font list
      nsCOMPtr<nsIFontEnumerator> fontEnum = do_GetService("@mozilla.org/gfx/fontenumerator;1", &rv);
      if (NS_SUCCEEDED(rv)) {
        fontEnum->UpdateFontList(&didChange);
        ForceFontUpdate();
      } //if (NS_SUCCEEDED(rv))
    }
    break;

    case WM_SETTINGCHANGE:
    {
      if (IsWin10OrLater() && mWindowType == eWindowType_invisible && lParam) {
        auto lParamString = reinterpret_cast<const wchar_t*>(lParam);
        if (!wcscmp(lParamString, L"UserInteractionMode")) {
          nsCOMPtr<nsIWindowsUIUtils> uiUtils(do_GetService("@mozilla.org/windows-ui-utils;1"));
          if (uiUtils) {
            uiUtils->UpdateTabletModeState();
          }
        }
      }
    }
    break;

    case WM_NCCALCSIZE:
    {
      if (mCustomNonClient) {
        // If `wParam` is `FALSE`, `lParam` points to a `RECT` that contains
        // the proposed window rectangle for our window.  During our
        // processing of the `WM_NCCALCSIZE` message, we are expected to
        // modify the `RECT` that `lParam` points to, so that its value upon
        // our return is the new client area.  We must return 0 if `wParam`
        // is `FALSE`.
        //
        // If `wParam` is `TRUE`, `lParam` points to a `NCCALCSIZE_PARAMS`
        // struct.  This struct contains an array of 3 `RECT`s, the first of
        // which has the exact same meaning as the `RECT` that is pointed to
        // by `lParam` when `wParam` is `FALSE`.  The remaining `RECT`s, in
        // conjunction with our return value, can
        // be used to specify portions of the source and destination window
        // rectangles that are valid and should be preserved.  We opt not to
        // implement an elaborate client-area preservation technique, and
        // simply return 0, which means "preserve the entire old client area
        // and align it with the upper-left corner of our new client area".
        RECT *clientRect = wParam
                         ? &(reinterpret_cast<NCCALCSIZE_PARAMS*>(lParam))->rgrc[0]
                         : (reinterpret_cast<RECT*>(lParam));
        double scale = WinUtils::IsPerMonitorDPIAware()
          ? WinUtils::LogToPhysFactor(mWnd) / WinUtils::SystemScaleFactor()
          : 1.0;
        clientRect->top +=
          NSToIntRound((mCaptionHeight - mNonClientOffset.top) * scale);
        clientRect->left +=
          NSToIntRound((mHorResizeMargin - mNonClientOffset.left) * scale);
        clientRect->right -=
          NSToIntRound((mHorResizeMargin - mNonClientOffset.right) * scale);
        clientRect->bottom -=
          NSToIntRound((mVertResizeMargin - mNonClientOffset.bottom) * scale);

        result = true;
        *aRetValue = 0;
      }
      break;
    }

    case WM_NCHITTEST:
    {
      if (mMouseTransparent) {
        // Treat this window as transparent.
        *aRetValue = HTTRANSPARENT;
        result = true;
        break;
      }

      /*
       * If an nc client area margin has been moved, we are responsible
       * for calculating where the resize margins are and returning the
       * appropriate set of hit test constants. DwmDefWindowProc (above)
       * will handle hit testing on it's command buttons if we are on a
       * composited desktop.
       */

      if (!mCustomNonClient)
        break;

      *aRetValue =
        ClientMarginHitTestPoint(GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
      result = true;
      break;
    }

    case WM_SETTEXT:
      /*
       * WM_SETTEXT paints the titlebar area. Avoid this if we have a
       * custom titlebar we paint ourselves, or if we're the ones
       * sending the message with an updated title
       */

      if ((mSendingSetText && nsUXThemeData::CheckForCompositor()) ||
          !mCustomNonClient || mNonClientMargins.top == -1)
        break;

      {
        // From msdn, the way around this is to disable the visible state
        // temporarily. We need the text to be set but we don't want the
        // redraw to occur. However, we need to make sure that we don't
        // do this at the same time that a Present is happening.
        //
        // To do this we take mPresentLock in nsWindow::PreRender and
        // if that lock is taken we wait before doing WM_SETTEXT
        if (mCompositorWidgetDelegate) {
          mCompositorWidgetDelegate->EnterPresentLock();
        }
        DWORD style = GetWindowLong(mWnd, GWL_STYLE);
        SetWindowLong(mWnd, GWL_STYLE, style & ~WS_VISIBLE);
        *aRetValue = CallWindowProcW(GetPrevWindowProc(), mWnd,
                                     msg, wParam, lParam);
        SetWindowLong(mWnd, GWL_STYLE, style);
        if (mCompositorWidgetDelegate) {
          mCompositorWidgetDelegate->LeavePresentLock();
        }

        return true;
      }

    case WM_NCACTIVATE:
    {
      /*
       * WM_NCACTIVATE paints nc areas. Avoid this and re-route painting
       * through WM_NCPAINT via InvalidateNonClientRegion.
       */
      UpdateGetWindowInfoCaptionStatus(FALSE != wParam);

      if (!mCustomNonClient)
        break;

      // There is a case that rendered result is not kept. Bug 1237617
      if (wParam == TRUE &&
          !gfxEnv::DisableForcePresent() &&
          gfxWindowsPlatform::GetPlatform()->DwmCompositionEnabled()) {
        NS_DispatchToMainThread(NewRunnableMethod(this, &nsWindow::ForcePresent));
      }

      // let the dwm handle nc painting on glass
      // Never allow native painting if we are on fullscreen
      if(mSizeMode != nsSizeMode_Fullscreen &&
         nsUXThemeData::CheckForCompositor())
        break;

      if (wParam == TRUE) {
        // going active
        *aRetValue = FALSE; // ignored
        result = true;
        // invalidate to trigger a paint
        InvalidateNonClientRegion();
        break;
      } else {
        // going inactive
        *aRetValue = TRUE; // go ahead and deactive
        result = true;
        // invalidate to trigger a paint
        InvalidateNonClientRegion();
        break;
      }
    }

    case WM_NCPAINT:
    {
      /*
       * Reset the non-client paint region so that it excludes the
       * non-client areas we paint manually. Then call defwndproc
       * to do the actual painting.
       */

      if (!mCustomNonClient)
        break;

      // let the dwm handle nc painting on glass
      if(nsUXThemeData::CheckForCompositor())
        break;

      HRGN paintRgn = ExcludeNonClientFromPaintRegion((HRGN)wParam);
      LRESULT res = CallWindowProcW(GetPrevWindowProc(), mWnd,
                                    msg, (WPARAM)paintRgn, lParam);
      if (paintRgn != (HRGN)wParam)
        DeleteObject(paintRgn);
      *aRetValue = res;
      result = true;
    }
    break;

    case WM_POWERBROADCAST:
      switch (wParam)
      {
        case PBT_APMSUSPEND:
          PostSleepWakeNotification(true);
          break;
        case PBT_APMRESUMEAUTOMATIC:
        case PBT_APMRESUMECRITICAL:
        case PBT_APMRESUMESUSPEND:
          PostSleepWakeNotification(false);
          break;
      }
      break;

    case WM_CLOSE: // close request
      if (mWidgetListener)
        mWidgetListener->RequestWindowClose(this);
      result = true; // abort window closure
      break;

    case WM_DESTROY:
      // clean up.
      OnDestroy();
      result = true;
      break;

    case WM_PAINT:
      if (CleartypeSettingChanged()) {
        ForceFontUpdate();
        gfxFontCache *fc = gfxFontCache::GetCache();
        if (fc) {
          fc->Flush();
        }
      }
      *aRetValue = (int) OnPaint(nullptr, 0);
      result = true;
      break;

    case WM_PRINTCLIENT:
      result = OnPaint((HDC) wParam, 0);
      break;

    case WM_HOTKEY:
      result = OnHotKey(wParam, lParam);
      break;

    case WM_SYSCHAR:
    case WM_CHAR:
    {
      MSG nativeMsg = WinUtils::InitMSG(msg, wParam, lParam, mWnd);
      result = ProcessCharMessage(nativeMsg, nullptr);
      DispatchPendingEvents();
    }
    break;

    case WM_SYSKEYUP:
    case WM_KEYUP:
    {
      MSG nativeMsg = WinUtils::InitMSG(msg, wParam, lParam, mWnd);
      nativeMsg.time = ::GetMessageTime();
      result = ProcessKeyUpMessage(nativeMsg, nullptr);
      DispatchPendingEvents();
    }
    break;

    case WM_SYSKEYDOWN:
    case WM_KEYDOWN:
    {
      MSG nativeMsg = WinUtils::InitMSG(msg, wParam, lParam, mWnd);
      result = ProcessKeyDownMessage(nativeMsg, nullptr);
      DispatchPendingEvents();
    }
    break;

    // say we've dealt with erase background if widget does
    // not need auto-erasing
    case WM_ERASEBKGND:
      if (!AutoErase((HDC)wParam)) {
        *aRetValue = 1;
        result = true;
      }
      break;

    case WM_MOUSEMOVE:
    {
      if (!mMousePresent && !sIsInMouseCapture) {
        // First MOUSEMOVE over the client area. Ask for MOUSELEAVE
        TRACKMOUSEEVENT mTrack;
        mTrack.cbSize = sizeof(TRACKMOUSEEVENT);
        mTrack.dwFlags = TME_LEAVE;
        mTrack.dwHoverTime = 0;
        mTrack.hwndTrack = mWnd;
        TrackMouseEvent(&mTrack);
      }
      mMousePresent = true;

      // Suppress dispatch of pending events
      // when mouse moves are generated by widget
      // creation instead of user input.
      LPARAM lParamScreen = lParamToScreen(lParam);
      POINT mp;
      mp.x      = GET_X_LPARAM(lParamScreen);
      mp.y      = GET_Y_LPARAM(lParamScreen);
      bool userMovedMouse = false;
      if ((sLastMouseMovePoint.x != mp.x) || (sLastMouseMovePoint.y != mp.y)) {
        userMovedMouse = true;
      }

      result = DispatchMouseEvent(eMouseMove, wParam, lParam,
                                  false, WidgetMouseEvent::eLeftButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      if (userMovedMouse) {
        DispatchPendingEvents();
      }
    }
    break;

    case WM_NCMOUSEMOVE:
      // If we receive a mouse move event on non-client chrome, make sure and
      // send an eMouseExitFromWidget event as well.
      if (mMousePresent && !sIsInMouseCapture)
        SendMessage(mWnd, WM_MOUSELEAVE, 0, 0);
    break;

    case WM_LBUTTONDOWN:
    {
      result = DispatchMouseEvent(eMouseDown, wParam, lParam,
                                  false, WidgetMouseEvent::eLeftButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
    }
    break;

    case WM_LBUTTONUP:
    {
      result = DispatchMouseEvent(eMouseUp, wParam, lParam,
                                  false, WidgetMouseEvent::eLeftButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
    }
    break;

    case WM_MOUSELEAVE:
    {
      if (!mMousePresent)
        break;
      mMousePresent = false;

      // We need to check mouse button states and put them in for
      // wParam.
      WPARAM mouseState = (GetKeyState(VK_LBUTTON) ? MK_LBUTTON : 0)
        | (GetKeyState(VK_MBUTTON) ? MK_MBUTTON : 0)
        | (GetKeyState(VK_RBUTTON) ? MK_RBUTTON : 0);
      // Synthesize an event position because we don't get one from
      // WM_MOUSELEAVE.
      LPARAM pos = lParamToClient(::GetMessagePos());
      DispatchMouseEvent(eMouseExitFromWidget, mouseState, pos, false,
                         WidgetMouseEvent::eLeftButton,
                         MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
    }
    break;

    case MOZ_WM_PEN_LEAVES_HOVER_OF_DIGITIZER:
    {
      LPARAM pos = lParamToClient(::GetMessagePos());
      uint16_t pointerId = InkCollector::sInkCollector->GetPointerId();
      if (pointerId != 0) {
        DispatchMouseEvent(eMouseExitFromWidget, wParam, pos, false,
                           WidgetMouseEvent::eLeftButton,
                           nsIDOMMouseEvent::MOZ_SOURCE_PEN, pointerId);
        InkCollector::sInkCollector->ClearTarget();
        InkCollector::sInkCollector->ClearPointerId();
      }
    }
    break;

    case WM_CONTEXTMENU:
    {
      // If the context menu is brought up by a touch long-press, then
      // the APZ code is responsible for dealing with this, so we don't
      // need to do anything.
      if (mTouchWindow && MOUSE_INPUT_SOURCE() == nsIDOMMouseEvent::MOZ_SOURCE_TOUCH) {
        MOZ_ASSERT(mAPZC); // since mTouchWindow is true, APZ must be enabled
        result = true;
        break;
      }

      // if the context menu is brought up from the keyboard, |lParam|
      // will be -1.
      LPARAM pos;
      bool contextMenukey = false;
      if (lParam == -1)
      {
        contextMenukey = true;
        pos = lParamToClient(GetMessagePos());
      }
      else
      {
        pos = lParamToClient(lParam);
      }

      result = DispatchMouseEvent(eContextMenu, wParam, pos, contextMenukey,
                                  contextMenukey ?
                                    WidgetMouseEvent::eLeftButton :
                                    WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      if (lParam != -1 && !result && mCustomNonClient &&
          mDraggableRegion.Contains(GET_X_LPARAM(pos), GET_Y_LPARAM(pos))) {
        // Blank area hit, throw up the system menu.
        DisplaySystemMenu(mWnd, mSizeMode, mIsRTL, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
        result = true;
      }
    }
    break;

    case WM_LBUTTONDBLCLK:
      result = DispatchMouseEvent(eMouseDoubleClick, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eLeftButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_MBUTTONDOWN:
      result = DispatchMouseEvent(eMouseDown, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_MBUTTONUP:
      result = DispatchMouseEvent(eMouseUp, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_MBUTTONDBLCLK:
      result = DispatchMouseEvent(eMouseDoubleClick, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCMBUTTONDOWN:
      result = DispatchMouseEvent(eMouseDown, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCMBUTTONUP:
      result = DispatchMouseEvent(eMouseUp, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCMBUTTONDBLCLK:
      result = DispatchMouseEvent(eMouseDoubleClick, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eMiddleButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_RBUTTONDOWN:
      result = DispatchMouseEvent(eMouseDown, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_RBUTTONUP:
      result = DispatchMouseEvent(eMouseUp, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_RBUTTONDBLCLK:
      result = DispatchMouseEvent(eMouseDoubleClick, wParam,
                                  lParam, false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCRBUTTONDOWN:
      result = DispatchMouseEvent(eMouseDown, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCRBUTTONUP:
      result = DispatchMouseEvent(eMouseUp, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_NCRBUTTONDBLCLK:
      result = DispatchMouseEvent(eMouseDoubleClick, 0,
                                  lParamToClient(lParam), false,
                                  WidgetMouseEvent::eRightButton,
                                  MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    // Windows doesn't provide to customize the behavior of 4th nor 5th button
    // of mouse.  If 5-button mouse works with standard mouse deriver of
    // Windows, users cannot disable 4th button (browser back) nor 5th button
    // (browser forward).  We should allow to do it with our prefs since we can
    // prevent Windows to generate WM_APPCOMMAND message if WM_XBUTTONUP
    // messages are not sent to DefWindowProc.
    case WM_XBUTTONDOWN:
    case WM_XBUTTONUP:
    case WM_NCXBUTTONDOWN:
    case WM_NCXBUTTONUP:
      *aRetValue = TRUE;
      switch (GET_XBUTTON_WPARAM(wParam)) {
        case XBUTTON1:
          result = !Preferences::GetBool("mousebutton.4th.enabled", true);
          break;
        case XBUTTON2:
          result = !Preferences::GetBool("mousebutton.5th.enabled", true);
          break;
        default:
          break;
      }
      break;

    case WM_SIZING:
    {
      // When we get WM_ENTERSIZEMOVE we don't know yet if we're in a live
      // resize or move event. Instead we wait for first VM_SIZING message
      // within a ENTERSIZEMOVE to consider this a live resize event.
      if (mResizeState == IN_SIZEMOVE) {
        mResizeState = RESIZING;
        nsCOMPtr<nsIObserverService> observerService =
          mozilla::services::GetObserverService();

        if (observerService) {
          observerService->NotifyObservers(nullptr, "live-resize-start",
                                           nullptr);
        }
      }
      break;
    }

    case WM_MOVING:
      FinishLiveResizing(MOVING);
      if (WinUtils::IsPerMonitorDPIAware()) {
        // Sometimes, we appear to miss a WM_DPICHANGED message while moving
        // a window around. Therefore, call ChangedDPI and ResetLayout here,
        // which causes the prescontext and appshell window management code to
        // check the appUnitsPerDevPixel value and current widget size, and
        // refresh them if necessary. If nothing has changed, these calls will
        // return without actually triggering any extra reflow or painting.
        ChangedDPI();
        ResetLayout();
      }
      break;

    case WM_ENTERSIZEMOVE:
    {
      if (mResizeState == NOT_RESIZING) {
        mResizeState = IN_SIZEMOVE;
      }
      break;
    }

    case WM_EXITSIZEMOVE:
    {
      FinishLiveResizing(NOT_RESIZING);

      if (!sIsInMouseCapture) {
        NotifySizeMoveDone();
      }

      break;
    }

    case WM_NCLBUTTONDBLCLK:
      DispatchMouseEvent(eMouseDoubleClick, 0, lParamToClient(lParam),
                         false, WidgetMouseEvent::eLeftButton,
                         MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      result = 
        DispatchMouseEvent(eMouseUp, 0, lParamToClient(lParam),
                           false, WidgetMouseEvent::eLeftButton,
                           MOUSE_INPUT_SOURCE(), MOUSE_POINTERID());
      DispatchPendingEvents();
      break;

    case WM_APPCOMMAND:
    {
      MSG nativeMsg = WinUtils::InitMSG(msg, wParam, lParam, mWnd);
      result = HandleAppCommandMsg(nativeMsg, aRetValue);
      break;
    }

    // The WM_ACTIVATE event is fired when a window is raised or lowered,
    // and the loword of wParam specifies which. But we don't want to tell
    // the focus system about this until the WM_SETFOCUS or WM_KILLFOCUS
    // events are fired. Instead, set either the sJustGotActivate or
    // gJustGotDeactivate flags and activate/deactivate once the focus
    // events arrive.
    case WM_ACTIVATE:
      if (mWidgetListener) {
        int32_t fActive = LOWORD(wParam);

        if (WA_INACTIVE == fActive) {
          // when minimizing a window, the deactivation and focus events will
          // be fired in the reverse order. Instead, just deactivate right away.
          if (HIWORD(wParam))
            DispatchFocusToTopLevelWindow(false);
          else
            sJustGotDeactivate = true;

          if (mIsTopWidgetWindow)
            mLastKeyboardLayout = KeyboardLayout::GetInstance()->GetLayout();

        } else {
          StopFlashing();

          sJustGotActivate = true;
          WidgetMouseEvent event(true, eMouseActivate, this,
                                 WidgetMouseEvent::eReal);
          InitEvent(event);
          ModifierKeyState modifierKeyState;
          modifierKeyState.InitInputEvent(event);
          DispatchInputEvent(&event);
          if (sSwitchKeyboardLayout && mLastKeyboardLayout)
            ActivateKeyboardLayout(mLastKeyboardLayout, 0);
        }
      }
      break;

    case WM_MOUSEACTIVATE:
      // A popup with a parent owner should not be activated when clicked but
      // should still allow the mouse event to be fired, so the return value
      // is set to MA_NOACTIVATE. But if the owner isn't the frontmost window,
      // just use default processing so that the window is activated.
      if (IsPopup() && IsOwnerForegroundWindow()) {
        *aRetValue = MA_NOACTIVATE;
        result = true;
      }
      break;

    case WM_WINDOWPOSCHANGING:
    {
      LPWINDOWPOS info = (LPWINDOWPOS)lParam;
      OnWindowPosChanging(info);
      result = true;
    }
    break;

    case WM_GETMINMAXINFO:
    {
      MINMAXINFO* mmi = (MINMAXINFO*)lParam;
      // Set the constraints. The minimum size should also be constrained to the
      // default window maximum size so that it fits on screen.
      mmi->ptMinTrackSize.x =
        std::min((int32_t)mmi->ptMaxTrackSize.x,
               std::max((int32_t)mmi->ptMinTrackSize.x, mSizeConstraints.mMinSize.width));
      mmi->ptMinTrackSize.y =
        std::min((int32_t)mmi->ptMaxTrackSize.y,
        std::max((int32_t)mmi->ptMinTrackSize.y, mSizeConstraints.mMinSize.height));
      mmi->ptMaxTrackSize.x = std::min((int32_t)mmi->ptMaxTrackSize.x, mSizeConstraints.mMaxSize.width);
      mmi->ptMaxTrackSize.y = std::min((int32_t)mmi->ptMaxTrackSize.y, mSizeConstraints.mMaxSize.height);
    }
    break;

    case WM_SETFOCUS:
      // If previous focused window isn't ours, it must have received the
      // redirected message.  So, we should forget it.
      if (!WinUtils::IsOurProcessWindow(HWND(wParam))) {
        RedirectedKeyDownMessageManager::Forget();
      }
      if (sJustGotActivate) {
        DispatchFocusToTopLevelWindow(true);
      }
      break;

    case WM_KILLFOCUS:
      if (sJustGotDeactivate) {
        DispatchFocusToTopLevelWindow(false);
      }
      break;

    case WM_WINDOWPOSCHANGED:
    {
      WINDOWPOS* wp = (LPWINDOWPOS)lParam;
      OnWindowPosChanged(wp);
      result = true;
    }
    break;

    case WM_INPUTLANGCHANGEREQUEST:
      *aRetValue = TRUE;
      result = false;
      break;

    case WM_INPUTLANGCHANGE:
      KeyboardLayout::GetInstance()->
        OnLayoutChange(reinterpret_cast<HKL>(lParam));
      nsBidiKeyboard::OnLayoutChange();
      result = false; // always pass to child window
      break;

    case WM_DESTROYCLIPBOARD:
    {
      nsIClipboard* clipboard;
      nsresult rv = CallGetService(kCClipboardCID, &clipboard);
      if(NS_SUCCEEDED(rv)) {
        clipboard->EmptyClipboard(nsIClipboard::kGlobalClipboard);
        NS_RELEASE(clipboard);
      }
    }
    break;

#ifdef ACCESSIBILITY
    case WM_GETOBJECT:
    {
      *aRetValue = 0;
      // Do explicit casting to make it working on 64bit systems (see bug 649236
      // for details).
      int32_t objId = static_cast<DWORD>(lParam);
      if (objId == OBJID_CLIENT) { // oleacc.dll will be loaded dynamically
        a11y::Accessible* rootAccessible = GetAccessible(); // Held by a11y cache
        if (rootAccessible) {
          IAccessible *msaaAccessible = nullptr;
          rootAccessible->GetNativeInterface((void**)&msaaAccessible); // does an addref
          if (msaaAccessible) {
            *aRetValue = LresultFromObject(IID_IAccessible, wParam, msaaAccessible); // does an addref
            msaaAccessible->Release(); // release extra addref
            result = true;  // We handled the WM_GETOBJECT message
          }
        }
      }
    }
    break;
#endif

    case WM_SYSCOMMAND:
    {
      WPARAM filteredWParam = (wParam &0xFFF0);
      // prevent Windows from trimming the working set. bug 76831
      if (!sTrimOnMinimize && filteredWParam == SC_MINIMIZE) {
        ::ShowWindow(mWnd, SW_SHOWMINIMIZED);
        result = true;
      }

      if (mSizeMode == nsSizeMode_Fullscreen &&
          filteredWParam == SC_RESTORE &&
          GetCurrentShowCmd(mWnd) != SW_SHOWMINIMIZED) {
        MakeFullScreen(false);
        result = true;
      }

      // Handle the system menu manually when we're in full screen mode
      // so we can set the appropriate options.
      if (filteredWParam == SC_KEYMENU && lParam == VK_SPACE &&
          mSizeMode == nsSizeMode_Fullscreen) {
        DisplaySystemMenu(mWnd, mSizeMode, mIsRTL,
                          MOZ_SYSCONTEXT_X_POS,
                          MOZ_SYSCONTEXT_Y_POS);
        result = true;
      }
    }
    break;

  case WM_DWMCOMPOSITIONCHANGED:
    // First, update the compositor state to latest one. All other methods
    // should use same state as here for consistency painting.
    nsUXThemeData::CheckForCompositor(true);

    UpdateNonClientMargins();
    BroadcastMsg(mWnd, WM_DWMCOMPOSITIONCHANGED);
    NotifyThemeChanged();
    UpdateGlass();
    Invalidate(true, true, true);
    break;

  case WM_DPICHANGED:
  {
    LPRECT rect = (LPRECT) lParam;
    OnDPIChanged(rect->left, rect->top, rect->right - rect->left,
                 rect->bottom - rect->top);
    break;
  }

  case WM_UPDATEUISTATE:
  {
    // If the UI state has changed, fire an event so the UI updates the
    // keyboard cues based on the system setting and how the window was
    // opened. For example, a dialog opened via a keyboard press on a button
    // should enable cues, whereas the same dialog opened via a mouse click of
    // the button should not.
    if (mWindowType == eWindowType_toplevel ||
        mWindowType == eWindowType_dialog) {
      int32_t action = LOWORD(wParam);
      if (action == UIS_SET || action == UIS_CLEAR) {
        int32_t flags = HIWORD(wParam);
        UIStateChangeType showAccelerators = UIStateChangeType_NoChange;
        UIStateChangeType showFocusRings = UIStateChangeType_NoChange;
        if (flags & UISF_HIDEACCEL)
          showAccelerators = (action == UIS_SET) ? UIStateChangeType_Clear : UIStateChangeType_Set;
        if (flags & UISF_HIDEFOCUS)
          showFocusRings = (action == UIS_SET) ? UIStateChangeType_Clear : UIStateChangeType_Set;

        NotifyUIStateChanged(showAccelerators, showFocusRings);
      }
    }

    break;
  }

  /* Gesture support events */
  case WM_TABLET_QUERYSYSTEMGESTURESTATUS:
    // According to MS samples, this must be handled to enable
    // rotational support in multi-touch drivers.
    result = true;
    *aRetValue = TABLET_ROTATE_GESTURE_ENABLE;
    break;

  case WM_TOUCH:
    result = OnTouch(wParam, lParam);
    if (result) {
      *aRetValue = 0;
    }
    break;

  case WM_GESTURE:
    result = OnGesture(wParam, lParam);
    break;

  case WM_GESTURENOTIFY:
    {
      if (mWindowType != eWindowType_invisible &&
          !IsPlugin()) {
        // A GestureNotify event is dispatched to decide which single-finger panning
        // direction should be active (including none) and if pan feedback should
        // be displayed. Java and plugin windows can make their own calls.

        GESTURENOTIFYSTRUCT * gestureinfo = (GESTURENOTIFYSTRUCT*)lParam;
        nsPointWin touchPoint;
        touchPoint = gestureinfo->ptsLocation;
        touchPoint.ScreenToClient(mWnd);
        WidgetGestureNotifyEvent gestureNotifyEvent(true, eGestureNotify, this);
        gestureNotifyEvent.mRefPoint =
          LayoutDeviceIntPoint::FromUnknownPoint(touchPoint);
        nsEventStatus status;
        DispatchEvent(&gestureNotifyEvent, status);
        mDisplayPanFeedback = gestureNotifyEvent.mDisplayPanFeedback;
        if (!mTouchWindow)
          mGesture.SetWinGestureSupport(mWnd, gestureNotifyEvent.mPanDirection);
      }
      result = false; //should always bubble to DefWindowProc
    }
    break;

    case WM_CLEAR:
    {
      WidgetContentCommandEvent command(true, eContentCommandDelete, this);
      DispatchWindowEvent(&command);
      result = true;
    }
    break;

    case WM_CUT:
    {
      WidgetContentCommandEvent command(true, eContentCommandCut, this);
      DispatchWindowEvent(&command);
      result = true;
    }
    break;

    case WM_COPY:
    {
      WidgetContentCommandEvent command(true, eContentCommandCopy, this);
      DispatchWindowEvent(&command);
      result = true;
    }
    break;

    case WM_PASTE:
    {
      WidgetContentCommandEvent command(true, eContentCommandPaste, this);
      DispatchWindowEvent(&command);
      result = true;
    }
    break;

    case EM_UNDO:
    {
      WidgetContentCommandEvent command(true, eContentCommandUndo, this);
      DispatchWindowEvent(&command);
      *aRetValue = (LRESULT)(command.mSucceeded && command.mIsEnabled);
      result = true;
    }
    break;

    case EM_REDO:
    {
      WidgetContentCommandEvent command(true, eContentCommandRedo, this);
      DispatchWindowEvent(&command);
      *aRetValue = (LRESULT)(command.mSucceeded && command.mIsEnabled);
      result = true;
    }
    break;

    case EM_CANPASTE:
    {
      // Support EM_CANPASTE message only when wParam isn't specified or
      // is plain text format.
      if (wParam == 0 || wParam == CF_TEXT || wParam == CF_UNICODETEXT) {
        WidgetContentCommandEvent command(true, eContentCommandPaste,
                                          this, true);
        DispatchWindowEvent(&command);
        *aRetValue = (LRESULT)(command.mSucceeded && command.mIsEnabled);
        result = true;
      }
    }
    break;

    case EM_CANUNDO:
    {
      WidgetContentCommandEvent command(true, eContentCommandUndo, this, true);
      DispatchWindowEvent(&command);
      *aRetValue = (LRESULT)(command.mSucceeded && command.mIsEnabled);
      result = true;
    }
    break;

    case EM_CANREDO:
    {
      WidgetContentCommandEvent command(true, eContentCommandRedo, this, true);
      DispatchWindowEvent(&command);
      *aRetValue = (LRESULT)(command.mSucceeded && command.mIsEnabled);
      result = true;
    }
    break;

    case MOZ_WM_SKEWFIX:
    {
      TimeStamp skewStamp;
      if (CurrentWindowsTimeGetter::GetAndClearBackwardsSkewStamp(wParam, &skewStamp)) {
        TimeConverter().CompensateForBackwardsSkew(::GetMessageTime(), skewStamp);
      }
    }
    break;

    default:
    {
      if (msg == nsAppShell::GetTaskbarButtonCreatedMessage()) {
        SetHasTaskbarIconBeenCreated();
      }
    }
    break;

  }

  //*aRetValue = result;
  if (mWnd) {
    return result;
  }
  else {
    //Events which caused mWnd destruction and aren't consumed
    //will crash during the Windows default processing.
    return true;
  }
}

void
nsWindow::FinishLiveResizing(ResizeState aNewState)
{
  if (mResizeState == RESIZING) {
    nsCOMPtr<nsIObserverService> observerService = mozilla::services::GetObserverService();
    if (observerService) {
      observerService->NotifyObservers(nullptr, "live-resize-end", nullptr);
    }
  }
  mResizeState = aNewState;
  ForcePresent();
}

/**************************************************************
 *
 * SECTION: Broadcast messaging
 *
 * Broadcast messages to all windows.
 *
 **************************************************************/

// Enumerate all child windows sending aMsg to each of them
BOOL CALLBACK nsWindow::BroadcastMsgToChildren(HWND aWnd, LPARAM aMsg)
{
  WNDPROC winProc = (WNDPROC)::GetWindowLongPtrW(aWnd, GWLP_WNDPROC);
  if (winProc == &nsWindow::WindowProc) {
    // it's one of our windows so go ahead and send a message to it
    ::CallWindowProcW(winProc, aWnd, aMsg, 0, 0);
  }
  return TRUE;
}

// Enumerate all top level windows specifying that the children of each
// top level window should be enumerated. Do *not* send the message to
// each top level window since it is assumed that the toolkit will send
// aMsg to them directly.
BOOL CALLBACK nsWindow::BroadcastMsg(HWND aTopWindow, LPARAM aMsg)
{
  // Iterate each of aTopWindows child windows sending the aMsg
  // to each of them.
  ::EnumChildWindows(aTopWindow, nsWindow::BroadcastMsgToChildren, aMsg);
  return TRUE;
}

/**************************************************************
 *
 * SECTION: Event processing helpers
 *
 * Special processing for certain event types and 
 * synthesized events.
 *
 **************************************************************/

int32_t
nsWindow::ClientMarginHitTestPoint(int32_t mx, int32_t my)
{
  if (mSizeMode == nsSizeMode_Minimized ||
      mSizeMode == nsSizeMode_Fullscreen) {
    return HTCLIENT;
  }

  // Calculations are done in screen coords
  RECT winRect;
  GetWindowRect(mWnd, &winRect);

  // hit return constants:
  // HTBORDER                     - non-resizable border
  // HTBOTTOM, HTLEFT, HTRIGHT, HTTOP - resizable border
  // HTBOTTOMLEFT, HTBOTTOMRIGHT  - resizable corner
  // HTTOPLEFT, HTTOPRIGHT        - resizable corner
  // HTCAPTION                    - general title bar area
  // HTCLIENT                     - area considered the client
  // HTCLOSE                      - hovering over the close button
  // HTMAXBUTTON                  - maximize button
  // HTMINBUTTON                  - minimize button

  int32_t testResult = HTCLIENT;

  bool isResizable = (mBorderStyle & (eBorderStyle_all |
                                      eBorderStyle_resizeh |
                                      eBorderStyle_default)) > 0 ? true : false;
  if (mSizeMode == nsSizeMode_Maximized)
    isResizable = false;

  // Ensure being accessible to borders of window.  Even if contents are in
  // this area, the area must behave as border.
  nsIntMargin nonClientSize(std::max(mCaptionHeight - mNonClientOffset.top,
                                     kResizableBorderMinSize),
                            std::max(mHorResizeMargin - mNonClientOffset.right,
                                     kResizableBorderMinSize),
                            std::max(mVertResizeMargin - mNonClientOffset.bottom,
                                     kResizableBorderMinSize),
                            std::max(mHorResizeMargin - mNonClientOffset.left,
                                     kResizableBorderMinSize));

  bool allowContentOverride = mSizeMode == nsSizeMode_Maximized ||
                              (mx >= winRect.left + nonClientSize.left &&
                               mx <= winRect.right - nonClientSize.right &&
                               my >= winRect.top + nonClientSize.top &&
                               my <= winRect.bottom - nonClientSize.bottom);

  // The border size.  If there is no content under mouse cursor, the border
  // size should be larger than the values in system settings.  Otherwise,
  // contents under the mouse cursor should be able to override the behavior.
  // E.g., user must expect that Firefox button always opens the popup menu
  // even when the user clicks on the above edge of it.
  nsIntMargin borderSize(std::max(nonClientSize.top,    mVertResizeMargin),
                         std::max(nonClientSize.right,  mHorResizeMargin),
                         std::max(nonClientSize.bottom, mVertResizeMargin),
                         std::max(nonClientSize.left,   mHorResizeMargin));

  bool top    = false;
  bool bottom = false;
  bool left   = false;
  bool right  = false;

  if (my >= winRect.top && my < winRect.top + borderSize.top) {
    top = true;
  } else if (my <= winRect.bottom && my > winRect.bottom - borderSize.bottom) {
    bottom = true;
  }

  // (the 2x case here doubles the resize area for corners)
  int multiplier = (top || bottom) ? 2 : 1;
  if (mx >= winRect.left &&
      mx < winRect.left + (multiplier * borderSize.left)) {
    left = true;
  } else if (mx <= winRect.right &&
             mx > winRect.right - (multiplier * borderSize.right)) {
    right = true;
  }

  if (isResizable) {
    if (top) {
      testResult = HTTOP;
      if (left)
        testResult = HTTOPLEFT;
      else if (right)
        testResult = HTTOPRIGHT;
    } else if (bottom) {
      testResult = HTBOTTOM;
      if (left)
        testResult = HTBOTTOMLEFT;
      else if (right)
        testResult = HTBOTTOMRIGHT;
    } else {
      if (left)
        testResult = HTLEFT;
      if (right)
        testResult = HTRIGHT;
    }
  } else {
    if (top)
      testResult = HTCAPTION;
    else if (bottom || left || right)
      testResult = HTBORDER;
  }

  if (!sIsInMouseCapture && allowContentOverride) {
    POINT pt = { mx, my };
    ::ScreenToClient(mWnd, &pt);
    if (pt.x == mCachedHitTestPoint.x && pt.y == mCachedHitTestPoint.y &&
        TimeStamp::Now() - mCachedHitTestTime < TimeDuration::FromMilliseconds(HITTEST_CACHE_LIFETIME_MS)) {
      return mCachedHitTestResult;
    }
    if (mDraggableRegion.Contains(pt.x, pt.y)) {
      testResult = HTCAPTION;
    } else {
      testResult = HTCLIENT;
    }
    mCachedHitTestPoint = pt;
    mCachedHitTestTime = TimeStamp::Now();
    mCachedHitTestResult = testResult;
  }

  return testResult;
}

TimeStamp
nsWindow::GetMessageTimeStamp(LONG aEventTime) const
{
  CurrentWindowsTimeGetter getCurrentTime(mWnd);
  return TimeConverter().GetTimeStampFromSystemTime(aEventTime,
                                                    getCurrentTime);
}

void nsWindow::PostSleepWakeNotification(const bool aIsSleepMode)
{
  if (aIsSleepMode == gIsSleepMode)
    return;

  gIsSleepMode = aIsSleepMode;

  nsCOMPtr<nsIObserverService> observerService =
    mozilla::services::GetObserverService();
  if (observerService)
    observerService->NotifyObservers(nullptr,
      aIsSleepMode ? NS_WIDGET_SLEEP_OBSERVER_TOPIC :
                     NS_WIDGET_WAKE_OBSERVER_TOPIC, nullptr);
}

LRESULT nsWindow::ProcessCharMessage(const MSG &aMsg, bool *aEventDispatched)
{
  if (IMEHandler::IsComposingOn(this)) {
    IMEHandler::NotifyIME(this, REQUEST_TO_COMMIT_COMPOSITION);
  }
  // These must be checked here too as a lone WM_CHAR could be received
  // if a child window didn't handle it (for example Alt+Space in a content
  // window)
  ModifierKeyState modKeyState;
  NativeKey nativeKey(this, aMsg, modKeyState);
  return static_cast<LRESULT>(nativeKey.HandleCharMessage(aEventDispatched));
}

LRESULT nsWindow::ProcessKeyUpMessage(const MSG &aMsg, bool *aEventDispatched)
{
  ModifierKeyState modKeyState;
  NativeKey nativeKey(this, aMsg, modKeyState);
  return static_cast<LRESULT>(nativeKey.HandleKeyUpMessage(aEventDispatched));
}

LRESULT nsWindow::ProcessKeyDownMessage(const MSG &aMsg,
                                        bool *aEventDispatched)
{
  // If this method doesn't call NativeKey::HandleKeyDownMessage(), this method
  // must clean up the redirected message information itself.  For more
  // information, see above comment of
  // RedirectedKeyDownMessageManager::AutoFlusher class definition in
  // KeyboardLayout.h.
  RedirectedKeyDownMessageManager::AutoFlusher redirectedMsgFlusher(this, aMsg);

  ModifierKeyState modKeyState;

  NativeKey nativeKey(this, aMsg, modKeyState);
  LRESULT result =
    static_cast<LRESULT>(nativeKey.HandleKeyDownMessage(aEventDispatched));
  // HandleKeyDownMessage cleaned up the redirected message information
  // itself, so, we should do nothing.
  redirectedMsgFlusher.Cancel();

  if (aMsg.wParam == VK_MENU ||
      (aMsg.wParam == VK_F10 && !modKeyState.IsShift())) {
    // We need to let Windows handle this keypress,
    // by returning false, if there's a native menu
    // bar somewhere in our containing window hierarchy.
    // Otherwise we handle the keypress and don't pass
    // it on to Windows, by returning true.
    bool hasNativeMenu = false;
    HWND hWnd = mWnd;
    while (hWnd) {
      if (::GetMenu(hWnd)) {
        hasNativeMenu = true;
        break;
      }
      hWnd = ::GetParent(hWnd);
    }
    result = !hasNativeMenu;
  }

  return result;
}

nsresult
nsWindow::SynthesizeNativeKeyEvent(int32_t aNativeKeyboardLayout,
                                   int32_t aNativeKeyCode,
                                   uint32_t aModifierFlags,
                                   const nsAString& aCharacters,
                                   const nsAString& aUnmodifiedCharacters,
                                   nsIObserver* aObserver)
{
  AutoObserverNotifier notifier(aObserver, "keyevent");

  KeyboardLayout* keyboardLayout = KeyboardLayout::GetInstance();
  return keyboardLayout->SynthesizeNativeKeyEvent(
           this, aNativeKeyboardLayout, aNativeKeyCode, aModifierFlags,
           aCharacters, aUnmodifiedCharacters);
}

nsresult
nsWindow::SynthesizeNativeMouseEvent(LayoutDeviceIntPoint aPoint,
                                     uint32_t aNativeMessage,
                                     uint32_t aModifierFlags,
                                     nsIObserver* aObserver)
{
  AutoObserverNotifier notifier(aObserver, "mouseevent");

  if (aNativeMessage == MOUSEEVENTF_MOVE) {
    // Reset sLastMouseMovePoint so that even if we're moving the mouse
    // to the position it's already at, we still dispatch a mousemove
    // event, because the callers of this function expect that.
    sLastMouseMovePoint = {0};
  }
  ::SetCursorPos(aPoint.x, aPoint.y);

  INPUT input;
  memset(&input, 0, sizeof(input));

  input.type = INPUT_MOUSE;
  input.mi.dwFlags = aNativeMessage;
  ::SendInput(1, &input, sizeof(INPUT));

  return NS_OK;
}

nsresult
nsWindow::SynthesizeNativeMouseScrollEvent(LayoutDeviceIntPoint aPoint,
                                           uint32_t aNativeMessage,
                                           double aDeltaX,
                                           double aDeltaY,
                                           double aDeltaZ,
                                           uint32_t aModifierFlags,
                                           uint32_t aAdditionalFlags,
                                           nsIObserver* aObserver)
{
  AutoObserverNotifier notifier(aObserver, "mousescrollevent");
  return MouseScrollHandler::SynthesizeNativeMouseScrollEvent(
           this, aPoint, aNativeMessage,
           (aNativeMessage == WM_MOUSEWHEEL || aNativeMessage == WM_VSCROLL) ?
             static_cast<int32_t>(aDeltaY) : static_cast<int32_t>(aDeltaX),
           aModifierFlags, aAdditionalFlags);
}

/**************************************************************
 *
 * SECTION: OnXXX message handlers
 *
 * For message handlers that need to be broken out or
 * implemented in specific platform code.
 *
 **************************************************************/

void nsWindow::OnWindowPosChanged(WINDOWPOS* wp)
{
  if (wp == nullptr)
    return;

#ifdef WINSTATE_DEBUG_OUTPUT
  if (mWnd == WinUtils::GetTopLevelHWND(mWnd)) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("*** OnWindowPosChanged: [  top] "));
  } else {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("*** OnWindowPosChanged: [child] "));
  }
  MOZ_LOG(gWindowsLog, LogLevel::Info, ("WINDOWPOS flags:"));
  if (wp->flags & SWP_FRAMECHANGED) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_FRAMECHANGED "));
  }
  if (wp->flags & SWP_SHOWWINDOW) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_SHOWWINDOW "));
  }
  if (wp->flags & SWP_NOSIZE) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_NOSIZE "));
  }
  if (wp->flags & SWP_HIDEWINDOW) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_HIDEWINDOW "));
  }
  if (wp->flags & SWP_NOZORDER) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_NOZORDER "));
  }
  if (wp->flags & SWP_NOACTIVATE) {
    MOZ_LOG(gWindowsLog, LogLevel::Info, ("SWP_NOACTIVATE "));
  }
  MOZ_LOG(gWindowsLog, LogLevel::Info, ("\n"));
#endif

  // Handle window size mode changes
  if (wp->flags & SWP_FRAMECHANGED && mSizeMode != nsSizeMode_Fullscreen) {

    // Bug 566135 - Windows theme code calls show window on SW_SHOWMINIMIZED
    // windows when fullscreen games disable desktop composition. If we're
    // minimized and not being activated, ignore the event and let windows
    // handle it.
    if (mSizeMode == nsSizeMode_Minimized && (wp->flags & SWP_NOACTIVATE))
      return;

    WINDOWPLACEMENT pl;
    pl.length = sizeof(pl);
    ::GetWindowPlacement(mWnd, &pl);

    nsSizeMode previousSizeMode = mSizeMode;

    // Windows has just changed the size mode of this window. The call to
    // SizeModeChanged will trigger a call into SetSizeMode where we will
    // set the min/max window state again or for nsSizeMode_Normal, call
    // SetWindow with a parameter of SW_RESTORE. There's no need however as
    // this window's mode has already changed. Updating mSizeMode here
    // insures the SetSizeMode call is a no-op. Addresses a bug on Win7 related
    // to window docking. (bug 489258)
    if (pl.showCmd == SW_SHOWMAXIMIZED)
      mSizeMode = (mFullscreenMode ? nsSizeMode_Fullscreen : nsSizeMode_Maximized);
    else if (pl.showCmd == SW_SHOWMINIMIZED)
      mSizeMode = nsSizeMode_Minimized;
    else if (mFullscreenMode)
      mSizeMode = nsSizeMode_Fullscreen;
    else
      mSizeMode = nsSizeMode_Normal;

    // If !sTrimOnMinimize, we minimize windows using SW_SHOWMINIMIZED (See
    // SetSizeMode for internal calls, and WM_SYSCOMMAND for external). This
    // prevents the working set from being trimmed but keeps the window active.
    // After the window is minimized, we need to do some touch up work on the
    // active window. (bugs 76831 & 499816)
    if (!sTrimOnMinimize && nsSizeMode_Minimized == mSizeMode)
      ActivateOtherWindowHelper(mWnd);

#ifdef WINSTATE_DEBUG_OUTPUT
    switch (mSizeMode) {
      case nsSizeMode_Normal:
          MOZ_LOG(gWindowsLog, LogLevel::Info, 
                 ("*** mSizeMode: nsSizeMode_Normal\n"));
        break;
      case nsSizeMode_Minimized:
        MOZ_LOG(gWindowsLog, LogLevel::Info, 
               ("*** mSizeMode: nsSizeMode_Minimized\n"));
        break;
      case nsSizeMode_Maximized:
          MOZ_LOG(gWindowsLog, LogLevel::Info, 
                 ("*** mSizeMode: nsSizeMode_Maximized\n"));
        break;
      default:
          MOZ_LOG(gWindowsLog, LogLevel::Info, ("*** mSizeMode: ??????\n"));
        break;
    }
#endif

    if (mWidgetListener && mSizeMode != previousSizeMode)
      mWidgetListener->SizeModeChanged(mSizeMode);

    // If window was restored, window activation was bypassed during the 
    // SetSizeMode call originating from OnWindowPosChanging to avoid saving
    // pre-restore attributes. Force activation now to get correct attributes.
    if (mLastSizeMode != nsSizeMode_Normal && mSizeMode == nsSizeMode_Normal)
      DispatchFocusToTopLevelWindow(true);

    mLastSizeMode = mSizeMode;

    // Skip window size change events below on minimization.
    if (mSizeMode == nsSizeMode_Minimized)
      return;
  }

  // Handle window position changes
  if (!(wp->flags & SWP_NOMOVE)) {
    mBounds.x = wp->x;
    mBounds.y = wp->y;

    NotifyWindowMoved(wp->x, wp->y);
  }

  // Handle window size changes
  if (!(wp->flags & SWP_NOSIZE)) {
    RECT r;
    int32_t newWidth, newHeight;

    ::GetWindowRect(mWnd, &r);

    newWidth  = r.right - r.left;
    newHeight = r.bottom - r.top;
    nsIntRect rect(wp->x, wp->y, newWidth, newHeight);

    if (newWidth > mLastSize.width)
    {
      RECT drect;

      // getting wider
      drect.left   = wp->x + mLastSize.width;
      drect.top    = wp->y;
      drect.right  = drect.left + (newWidth - mLastSize.width);
      drect.bottom = drect.top + newHeight;

      ::RedrawWindow(mWnd, &drect, nullptr,
                     RDW_INVALIDATE |
                     RDW_NOERASE |
                     RDW_NOINTERNALPAINT |
                     RDW_ERASENOW |
                     RDW_ALLCHILDREN);
    }
    if (newHeight > mLastSize.height)
    {
      RECT drect;

      // getting taller
      drect.left   = wp->x;
      drect.top    = wp->y + mLastSize.height;
      drect.right  = drect.left + newWidth;
      drect.bottom = drect.top + (newHeight - mLastSize.height);

      ::RedrawWindow(mWnd, &drect, nullptr,
                     RDW_INVALIDATE |
                     RDW_NOERASE |
                     RDW_NOINTERNALPAINT |
                     RDW_ERASENOW |
                     RDW_ALLCHILDREN);
    }

    mBounds.width    = newWidth;
    mBounds.height   = newHeight;
    mLastSize.width  = newWidth;
    mLastSize.height = newHeight;

#ifdef WINSTATE_DEBUG_OUTPUT
    MOZ_LOG(gWindowsLog, LogLevel::Info, 
           ("*** Resize window: %d x %d x %d x %d\n", wp->x, wp->y, 
            newWidth, newHeight));
#endif

    // If a maximized window is resized, recalculate the non-client margins.
    if (mSizeMode == nsSizeMode_Maximized) {
      if (UpdateNonClientMargins(nsSizeMode_Maximized, true)) {
        // gecko resize event already sent by UpdateNonClientMargins.
        return;
      }
    }

    // Recalculate the width and height based on the client area for gecko events.
    if (::GetClientRect(mWnd, &r)) {
      rect.width  = r.right - r.left;
      rect.height = r.bottom - r.top;
    }
    
    // Send a gecko resize event
    OnResize(rect);
  }
}

// static
void nsWindow::ActivateOtherWindowHelper(HWND aWnd)
{
  // Find the next window that is enabled, visible, and not minimized.
  HWND hwndBelow = ::GetNextWindow(aWnd, GW_HWNDNEXT);
  while (hwndBelow && (!::IsWindowEnabled(hwndBelow) || !::IsWindowVisible(hwndBelow) ||
                       ::IsIconic(hwndBelow))) {
    hwndBelow = ::GetNextWindow(hwndBelow, GW_HWNDNEXT);
  }

  // Push ourselves to the bottom of the stack, then activate the
  // next window.
  ::SetWindowPos(aWnd, HWND_BOTTOM, 0, 0, 0, 0,
                 SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE);
  if (hwndBelow)
    ::SetForegroundWindow(hwndBelow);

  // Play the minimize sound while we're here, since that is also
  // forgotten when we use SW_SHOWMINIMIZED.
  nsCOMPtr<nsISound> sound(do_CreateInstance("@mozilla.org/sound;1"));
  if (sound) {
    sound->PlaySystemSound(NS_LITERAL_STRING("Minimize"));
  }
}

void nsWindow::OnWindowPosChanging(LPWINDOWPOS& info)
{
  // Update non-client margins if the frame size is changing, and let the
  // browser know we are changing size modes, so alternative css can kick in.
  // If we're going into fullscreen mode, ignore this, since it'll reset
  // margins to normal mode. 
  if ((info->flags & SWP_FRAMECHANGED && !(info->flags & SWP_NOSIZE)) &&
      mSizeMode != nsSizeMode_Fullscreen) {
    WINDOWPLACEMENT pl;
    pl.length = sizeof(pl);
    ::GetWindowPlacement(mWnd, &pl);
    nsSizeMode sizeMode;
    if (pl.showCmd == SW_SHOWMAXIMIZED)
      sizeMode = (mFullscreenMode ? nsSizeMode_Fullscreen : nsSizeMode_Maximized);
    else if (pl.showCmd == SW_SHOWMINIMIZED)
      sizeMode = nsSizeMode_Minimized;
    else if (mFullscreenMode)
      sizeMode = nsSizeMode_Fullscreen;
    else
      sizeMode = nsSizeMode_Normal;

    if (mWidgetListener)
      mWidgetListener->SizeModeChanged(sizeMode);

    UpdateNonClientMargins(sizeMode, false);
  }

  // enforce local z-order rules
  if (!(info->flags & SWP_NOZORDER)) {
    HWND hwndAfter = info->hwndInsertAfter;

    nsWindow *aboveWindow = 0;
    nsWindowZ placement;

    if (hwndAfter == HWND_BOTTOM)
      placement = nsWindowZBottom;
    else if (hwndAfter == HWND_TOP || hwndAfter == HWND_TOPMOST || hwndAfter == HWND_NOTOPMOST)
      placement = nsWindowZTop;
    else {
      placement = nsWindowZRelative;
      aboveWindow = WinUtils::GetNSWindowPtr(hwndAfter);
    }

    if (mWidgetListener) {
      nsCOMPtr<nsIWidget> actualBelow = nullptr;
      if (mWidgetListener->ZLevelChanged(false, &placement,
                                         aboveWindow, getter_AddRefs(actualBelow))) {
        if (placement == nsWindowZBottom)
          info->hwndInsertAfter = HWND_BOTTOM;
        else if (placement == nsWindowZTop)
          info->hwndInsertAfter = HWND_TOP;
        else {
          info->hwndInsertAfter = (HWND)actualBelow->GetNativeData(NS_NATIVE_WINDOW);
        }
      }
    }
  }
  // prevent rude external programs from making hidden window visible
  if (mWindowType == eWindowType_invisible)
    info->flags &= ~SWP_SHOWWINDOW;
}

void nsWindow::UserActivity()
{
  // Check if we have the idle service, if not we try to get it.
  if (!mIdleService) {
    mIdleService = do_GetService("@mozilla.org/widget/idleservice;1");
  }

  // Check that we now have the idle service.
  if (mIdleService) {
    mIdleService->ResetIdleTimeOut(0);
  }
}

bool nsWindow::OnTouch(WPARAM wParam, LPARAM lParam)
{
  uint32_t cInputs = LOWORD(wParam);
  PTOUCHINPUT pInputs = new TOUCHINPUT[cInputs];

  if (mGesture.GetTouchInputInfo((HTOUCHINPUT)lParam, cInputs, pInputs)) {
    MultiTouchInput touchInput, touchEndInput;

    // Walk across the touch point array processing each contact point.
    for (uint32_t i = 0; i < cInputs; i++) {
      bool addToEvent = false, addToEndEvent = false;

      // N.B.: According with MS documentation
      // https://msdn.microsoft.com/en-us/library/windows/desktop/dd317334(v=vs.85).aspx
      // TOUCHEVENTF_DOWN cannot be combined with TOUCHEVENTF_MOVE or TOUCHEVENTF_UP.
      // Possibly, it means that TOUCHEVENTF_MOVE and TOUCHEVENTF_UP can be combined together.

      if (pInputs[i].dwFlags & (TOUCHEVENTF_DOWN | TOUCHEVENTF_MOVE)) {
        if (touchInput.mTimeStamp.IsNull()) {
          // Initialize a touch event to send.
          touchInput.mType = MultiTouchInput::MULTITOUCH_MOVE;
          touchInput.mTime = ::GetMessageTime();
          touchInput.mTimeStamp = GetMessageTimeStamp(touchInput.mTime);
          ModifierKeyState modifierKeyState;
          touchInput.modifiers = modifierKeyState.GetModifiers();
        }
        // Pres shell expects this event to be a eTouchStart
        // if any new contact points have been added since the last event sent.
        if (pInputs[i].dwFlags & TOUCHEVENTF_DOWN) {
          touchInput.mType = MultiTouchInput::MULTITOUCH_START;
        }
        addToEvent = true;
      }
      if (pInputs[i].dwFlags & TOUCHEVENTF_UP) {
        // Pres shell expects removed contacts points to be delivered in a separate
        // eTouchEnd event containing only the contact points that were removed.
        if (touchEndInput.mTimeStamp.IsNull()) {
          // Initialize a touch event to send.
          touchEndInput.mType = MultiTouchInput::MULTITOUCH_END;
          touchEndInput.mTime = ::GetMessageTime();
          touchEndInput.mTimeStamp = GetMessageTimeStamp(touchEndInput.mTime);
          ModifierKeyState modifierKeyState;
          touchEndInput.modifiers = modifierKeyState.GetModifiers();
        }
        addToEndEvent = true;
      }
      if (!addToEvent && !addToEndEvent) {
        // Filter out spurious Windows events we don't understand, like palm contact.
        continue;
      }

      // Setup the touch point we'll append to the touch event array.
      nsPointWin touchPoint;
      touchPoint.x = TOUCH_COORD_TO_PIXEL(pInputs[i].x);
      touchPoint.y = TOUCH_COORD_TO_PIXEL(pInputs[i].y);
      touchPoint.ScreenToClient(mWnd);

      // Initialize the touch data.
      SingleTouchData touchData(pInputs[i].dwID,                                      // aIdentifier
                                ScreenIntPoint::FromUnknownPoint(touchPoint),         // aScreenPoint
                                /* radius, if known */
                                pInputs[i].dwFlags & TOUCHINPUTMASKF_CONTACTAREA
                                  ? ScreenSize(
                                      TOUCH_COORD_TO_PIXEL(pInputs[i].cxContact) / 2,
                                      TOUCH_COORD_TO_PIXEL(pInputs[i].cyContact) / 2)
                                  : ScreenSize(1, 1),                                 // aRadius
                                0.0f,                                                 // aRotationAngle
                                0.0f);                                                // aForce

      // Append touch data to the appropriate event.
      if (addToEvent) {
        touchInput.mTouches.AppendElement(touchData);
      }
      if (addToEndEvent) {
        touchEndInput.mTouches.AppendElement(touchData);
      }
    }

    // Dispatch touch start and touch move event if we have one.
    if (!touchInput.mTimeStamp.IsNull()) {
      DispatchTouchInput(touchInput);
    }
    // Dispatch touch end event if we have one.
    if (!touchEndInput.mTimeStamp.IsNull()) {
      DispatchTouchInput(touchEndInput);
    }
  }

  delete [] pInputs;
  mGesture.CloseTouchInputHandle((HTOUCHINPUT)lParam);
  return true;
}

// Gesture event processing. Handles WM_GESTURE events.
bool nsWindow::OnGesture(WPARAM wParam, LPARAM lParam)
{
  // Treatment for pan events which translate into scroll events:
  if (mGesture.IsPanEvent(lParam)) {
    if ( !mGesture.ProcessPanMessage(mWnd, wParam, lParam) )
      return false; // ignore

    nsEventStatus status;

    WidgetWheelEvent wheelEvent(true, eWheel, this);

    ModifierKeyState modifierKeyState;
    modifierKeyState.InitInputEvent(wheelEvent);

    wheelEvent.button      = 0;
    wheelEvent.mTime       = ::GetMessageTime();
    wheelEvent.mTimeStamp  = GetMessageTimeStamp(wheelEvent.mTime);
    wheelEvent.inputSource = nsIDOMMouseEvent::MOZ_SOURCE_TOUCH;

    bool endFeedback = true;

    if (mGesture.PanDeltaToPixelScroll(wheelEvent)) {
      mozilla::Telemetry::Accumulate(mozilla::Telemetry::SCROLL_INPUT_METHODS,
          (uint32_t) ScrollInputMethod::MainThreadTouch);
      DispatchEvent(&wheelEvent, status);
    }

    if (mDisplayPanFeedback) {
      mGesture.UpdatePanFeedbackX(
                 mWnd,
                 DeprecatedAbs(RoundDown(wheelEvent.mOverflowDeltaX)),
                 endFeedback);
      mGesture.UpdatePanFeedbackY(
                 mWnd,
                 DeprecatedAbs(RoundDown(wheelEvent.mOverflowDeltaY)),
                 endFeedback);
      mGesture.PanFeedbackFinalize(mWnd, endFeedback);
    }

    mGesture.CloseGestureInfoHandle((HGESTUREINFO)lParam);

    return true;
  }

  // Other gestures translate into simple gesture events:
  WidgetSimpleGestureEvent event(true, eVoidEvent, this);
  if ( !mGesture.ProcessGestureMessage(mWnd, wParam, lParam, event) ) {
    return false; // fall through to DefWndProc
  }
  
  // Polish up and send off the new event
  ModifierKeyState modifierKeyState;
  modifierKeyState.InitInputEvent(event);
  event.button    = 0;
  event.mTime     = ::GetMessageTime();
  event.mTimeStamp = GetMessageTimeStamp(event.mTime);
  event.inputSource = nsIDOMMouseEvent::MOZ_SOURCE_TOUCH;

  nsEventStatus status;
  DispatchEvent(&event, status);
  if (status == nsEventStatus_eIgnore) {
    return false; // Ignored, fall through
  }

  // Only close this if we process and return true.
  mGesture.CloseGestureInfoHandle((HGESTUREINFO)lParam);

  return true; // Handled
}

nsresult
nsWindow::ConfigureChildren(const nsTArray<Configuration>& aConfigurations)
{
  // If this is a remotely updated widget we receive clipping, position, and
  // size information from a source other than our owner. Don't let our parent
  // update this information.
  if (mWindowType == eWindowType_plugin_ipc_chrome) {
    return NS_OK;
  }

  // XXXroc we could use BeginDeferWindowPos/DeferWindowPos/EndDeferWindowPos
  // here, if that helps in some situations. So far I haven't seen a
  // need.
  for (uint32_t i = 0; i < aConfigurations.Length(); ++i) {
    const Configuration& configuration = aConfigurations[i];
    nsWindow* w = static_cast<nsWindow*>(configuration.mChild.get());
    NS_ASSERTION(w->GetParent() == this,
                 "Configured widget is not a child");
    nsresult rv = w->SetWindowClipRegion(configuration.mClipRegion, true);
    NS_ENSURE_SUCCESS(rv, rv);
    LayoutDeviceIntRect bounds = w->GetBounds();
    if (bounds.Size() != configuration.mBounds.Size()) {
      w->Resize(configuration.mBounds.x, configuration.mBounds.y,
                configuration.mBounds.width, configuration.mBounds.height,
                true);
    } else if (bounds.TopLeft() != configuration.mBounds.TopLeft()) {
      w->Move(configuration.mBounds.x, configuration.mBounds.y);


      if (gfxWindowsPlatform::GetPlatform()->IsDirect2DBackend() ||
          GetLayerManager()->GetBackendType() != LayersBackend::LAYERS_BASIC) {
        // XXX - Workaround for Bug 587508. This will invalidate the part of the
        // plugin window that might be touched by moving content somehow. The
        // underlying problem should be found and fixed!
        LayoutDeviceIntRegion r;
        r.Sub(bounds, configuration.mBounds);
        r.MoveBy(-bounds.x,
                 -bounds.y);
        LayoutDeviceIntRect toInvalidate = r.GetBounds();

        WinUtils::InvalidatePluginAsWorkaround(w, toInvalidate);
      }
    }
    rv = w->SetWindowClipRegion(configuration.mClipRegion, false);
    NS_ENSURE_SUCCESS(rv, rv);
  }
  return NS_OK;
}

static HRGN
CreateHRGNFromArray(const nsTArray<LayoutDeviceIntRect>& aRects)
{
  int32_t size = sizeof(RGNDATAHEADER) + sizeof(RECT)*aRects.Length();
  AutoTArray<uint8_t,100> buf;
  buf.SetLength(size);
  RGNDATA* data = reinterpret_cast<RGNDATA*>(buf.Elements());
  RECT* rects = reinterpret_cast<RECT*>(data->Buffer);
  data->rdh.dwSize = sizeof(data->rdh);
  data->rdh.iType = RDH_RECTANGLES;
  data->rdh.nCount = aRects.Length();
  LayoutDeviceIntRect bounds;
  for (uint32_t i = 0; i < aRects.Length(); ++i) {
    const LayoutDeviceIntRect& r = aRects[i];
    bounds.UnionRect(bounds, r);
    ::SetRect(&rects[i], r.x, r.y, r.XMost(), r.YMost());
  }
  ::SetRect(&data->rdh.rcBound, bounds.x, bounds.y, bounds.XMost(), bounds.YMost());
  return ::ExtCreateRegion(nullptr, buf.Length(), data);
}

nsresult
nsWindow::SetWindowClipRegion(const nsTArray<LayoutDeviceIntRect>& aRects,
                              bool aIntersectWithExisting)
{
  if (IsWindowClipRegionEqual(aRects)) {
    return NS_OK;
  }

  nsBaseWidget::SetWindowClipRegion(aRects, aIntersectWithExisting);

  HRGN dest = CreateHRGNFromArray(aRects);
  if (!dest)
    return NS_ERROR_OUT_OF_MEMORY;

  if (aIntersectWithExisting) {
    HRGN current = ::CreateRectRgn(0, 0, 0, 0);
    if (current) {
      if (::GetWindowRgn(mWnd, current) != 0 /*ERROR*/) {
        ::CombineRgn(dest, dest, current, RGN_AND);
      }
      ::DeleteObject(current);
    }
  }

  // If a plugin is not visible, especially if it is in a background tab,
  // it should not be able to steal keyboard focus.  This code checks whether
  // the region that the plugin is being clipped to is NULLREGION.  If it is,
  // the plugin window gets disabled.
  if (IsPlugin()) {
    if (NULLREGION == ::CombineRgn(dest, dest, dest, RGN_OR)) {
      ::ShowWindow(mWnd, SW_HIDE);
      ::EnableWindow(mWnd, FALSE);
    } else {
      ::EnableWindow(mWnd, TRUE);
      ::ShowWindow(mWnd, SW_SHOW);
    }
  }
  if (!::SetWindowRgn(mWnd, dest, TRUE)) {
    ::DeleteObject(dest);
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

// WM_DESTROY event handler
void nsWindow::OnDestroy()
{
  mOnDestroyCalled = true;

  // Make sure we don't get destroyed in the process of tearing down.
  nsCOMPtr<nsIWidget> kungFuDeathGrip(this);
  
  // Dispatch the destroy notification.
  if (!mInDtor)
    NotifyWindowDestroyed();

  // Prevent the widget from sending additional events.
  mWidgetListener = nullptr;
  mAttachedWidgetListener = nullptr;

  // Unregister notifications from terminal services
  ::WTSUnRegisterSessionNotification(mWnd);

  // Free our subclass and clear |this| stored in the window props. We will no longer
  // receive events from Windows after this point.
  SubclassWindow(FALSE);

  // Once mWidgetListener is cleared and the subclass is reset, sCurrentWindow can be
  // cleared. (It's used in tracking windows for mouse events.)
  if (sCurrentWindow == this)
    sCurrentWindow = nullptr;

  // Disconnects us from our parent, will call our GetParent().
  nsBaseWidget::Destroy();

  // Release references to children, device context, toolkit, and app shell.
  nsBaseWidget::OnDestroy();
  
  // Clear our native parent handle.
  // XXX Windows will take care of this in the proper order, and SetParent(nullptr)'s
  // remove child on the parent already took place in nsBaseWidget's Destroy call above.
  //SetParent(nullptr);
  mParent = nullptr;

  // We have to destroy the native drag target before we null out our window pointer.
  EnableDragDrop(false);

  // If we're going away and for some reason we're still the rollup widget, rollup and
  // turn off capture.
  nsIRollupListener* rollupListener = nsBaseWidget::GetActiveRollupListener();
  nsCOMPtr<nsIWidget> rollupWidget;
  if (rollupListener) {
    rollupWidget = rollupListener->GetRollupWidget();
  }
  if (this == rollupWidget) {
    if ( rollupListener )
      rollupListener->Rollup(0, false, nullptr, nullptr);
    CaptureRollupEvents(nullptr, false);
  }

  IMEHandler::OnDestroyWindow(this);

  // Free GDI window class objects
  if (mBrush) {
    VERIFY(::DeleteObject(mBrush));
    mBrush = nullptr;
  }

  // Destroy any custom cursor resources.
  if (mCursor == -1)
    SetCursor(eCursor_standard);

  if (mCompositorWidgetDelegate) {
    mCompositorWidgetDelegate->OnDestroyWindow();
  }
  mBasicLayersSurface = nullptr;

  // Finalize panning feedback to possibly restore window displacement
  mGesture.PanFeedbackFinalize(mWnd, true);

  // Clear the main HWND.
  mWnd = nullptr;
}

// Send a resize message to the listener
bool nsWindow::OnResize(nsIntRect &aWindowRect)
{
  bool result = mWidgetListener ?
                mWidgetListener->WindowResized(this, aWindowRect.width, aWindowRect.height) : false;

  // If there is an attached view, inform it as well as the normal widget listener.
  if (mAttachedWidgetListener) {
    return mAttachedWidgetListener->WindowResized(this, aWindowRect.width, aWindowRect.height);
  }

  return result;
}

bool nsWindow::OnHotKey(WPARAM wParam, LPARAM lParam)
{
  return true;
}

// Can be overriden. Controls auto-erase of background.
bool nsWindow::AutoErase(HDC dc)
{
  return false;
}

bool
nsWindow::IsPopup()
{
  return mWindowType == eWindowType_popup;
}

bool
nsWindow::ShouldUseOffMainThreadCompositing()
{
  // We don't currently support using an accelerated layer manager with
  // transparent windows so don't even try. I'm also not sure if we even
  // want to support this case. See bug 593471
  if (mTransparencyMode == eTransparencyTransparent) {
    return false;
  }

  return nsBaseWidget::ShouldUseOffMainThreadCompositing();
}

void
nsWindow::WindowUsesOMTC()
{
  ULONG_PTR style = ::GetClassLongPtr(mWnd, GCL_STYLE);
  if (!style) {
    NS_WARNING("Could not get window class style");
    return;
  }
  style |= CS_HREDRAW | CS_VREDRAW;
  DebugOnly<ULONG_PTR> result = ::SetClassLongPtr(mWnd, GCL_STYLE, style);
  NS_WARNING_ASSERTION(result, "Could not reset window class style");
}

bool
nsWindow::HasBogusPopupsDropShadowOnMultiMonitor() {
  if (sHasBogusPopupsDropShadowOnMultiMonitor == TRI_UNKNOWN) {
    // Since any change in the preferences requires a restart, this can be
    // done just once.
    // Check for Direct2D first.
    sHasBogusPopupsDropShadowOnMultiMonitor =
      gfxWindowsPlatform::GetPlatform()->IsDirect2DBackend() ? TRI_TRUE : TRI_FALSE;
    if (!sHasBogusPopupsDropShadowOnMultiMonitor) {
      // Otherwise check if Direct3D 9 may be used.
      if (gfxConfig::IsEnabled(Feature::HW_COMPOSITING) &&
          !gfxConfig::IsEnabled(Feature::OPENGL_COMPOSITING))
      {
        nsCOMPtr<nsIGfxInfo> gfxInfo = services::GetGfxInfo();
        if (gfxInfo) {
          int32_t status;
          nsCString discardFailureId;
          if (NS_SUCCEEDED(gfxInfo->GetFeatureStatus(nsIGfxInfo::FEATURE_DIRECT3D_9_LAYERS,
                                                     discardFailureId, &status))) {
            if (status == nsIGfxInfo::FEATURE_STATUS_OK ||
                gfxConfig::IsForcedOnByUser(Feature::HW_COMPOSITING))
            {
              sHasBogusPopupsDropShadowOnMultiMonitor = TRI_TRUE;
            }
          }
        }
      }
    }
  }
  return !!sHasBogusPopupsDropShadowOnMultiMonitor;
}

void
nsWindow::OnSysColorChanged()
{
  if (mWindowType == eWindowType_invisible) {
    ::EnumThreadWindows(GetCurrentThreadId(), nsWindow::BroadcastMsg, WM_SYSCOLORCHANGE);
  }
  else {
    // Note: This is sent for child windows as well as top-level windows.
    // The Win32 toolkit normally only sends these events to top-level windows.
    // But we cycle through all of the childwindows and send it to them as well
    // so all presentations get notified properly.
    // See nsWindow::GlobalMsgWindowProc.
    NotifySysColorChanged();
  }
}

void
nsWindow::OnDPIChanged(int32_t x, int32_t y, int32_t width, int32_t height)
{
  // Don't try to handle WM_DPICHANGED for popup windows (see bug 1239353);
  // they remain tied to their original parent's resolution.
  if (mWindowType == eWindowType_popup) {
    return;
  }
  if (DefaultScaleOverride() > 0.0) {
    return;
  }
  double oldScale = mDefaultScale;
  mDefaultScale = -1.0; // force recomputation of scale factor
  double newScale = GetDefaultScaleInternal();

  if (mResizeState != RESIZING && mSizeMode == nsSizeMode_Normal) {
    // Limit the position (if not in the middle of a drag-move) & size,
    // if it would overflow the destination screen
    nsCOMPtr<nsIScreenManager> sm = do_GetService(sScreenManagerContractID);
    if (sm) {
      nsCOMPtr<nsIScreen> screen;
      sm->ScreenForRect(x, y, width, height, getter_AddRefs(screen));
      if (screen) {
        int32_t availLeft, availTop, availWidth, availHeight;
        screen->GetAvailRect(&availLeft, &availTop, &availWidth, &availHeight);
        if (mResizeState != MOVING) {
          x = std::max(x, availLeft);
          y = std::max(y, availTop);
        }
        width = std::min(width, availWidth);
        height = std::min(height, availHeight);
      }
    }

    Resize(x, y, width, height, true);
  }
  ChangedDPI();
  ResetLayout();
}

/**************************************************************
 **************************************************************
 **
 ** BLOCK: IME management and accessibility
 **
 ** Handles managing IME input and accessibility.
 **
 **************************************************************
 **************************************************************/

NS_IMETHODIMP_(void)
nsWindow::SetInputContext(const InputContext& aContext,
                          const InputContextAction& aAction)
{
  InputContext newInputContext = aContext;
  IMEHandler::SetInputContext(this, newInputContext, aAction);
  mInputContext = newInputContext;
}

NS_IMETHODIMP_(InputContext)
nsWindow::GetInputContext()
{
  mInputContext.mIMEState.mOpen = IMEState::CLOSED;
  if (WinUtils::IsIMEEnabled(mInputContext) && IMEHandler::GetOpenState(this)) {
    mInputContext.mIMEState.mOpen = IMEState::OPEN;
  } else {
    mInputContext.mIMEState.mOpen = IMEState::CLOSED;
  }
  return mInputContext;
}

nsIMEUpdatePreference
nsWindow::GetIMEUpdatePreference()
{
  return IMEHandler::GetUpdatePreference();
}

NS_IMETHODIMP_(TextEventDispatcherListener*)
nsWindow::GetNativeTextEventDispatcherListener()
{
  return IMEHandler::GetNativeTextEventDispatcherListener();
}

#ifdef ACCESSIBILITY
#ifdef DEBUG
#define NS_LOG_WMGETOBJECT(aWnd, aHwnd, aAcc)                                  \
  if (a11y::logging::IsEnabled(a11y::logging::ePlatforms)) {                   \
    printf("Get the window:\n  {\n     HWND: %p, parent HWND: %p, wndobj: %p,\n",\
           aHwnd, ::GetParent(aHwnd), aWnd);                                   \
    printf("     acc: %p", aAcc);                                              \
    if (aAcc) {                                                                \
      nsAutoString name;                                                       \
      aAcc->Name(name);                                                        \
      printf(", accname: %s", NS_ConvertUTF16toUTF8(name).get());              \
    }                                                                          \
    printf("\n }\n");                                                          \
  }

#else
#define NS_LOG_WMGETOBJECT(aWnd, aHwnd, aAcc)
#endif

a11y::Accessible*
nsWindow::GetAccessible()
{
  // If the pref was ePlatformIsDisabled, return null here, disabling a11y.
  if (a11y::PlatformDisabledState() == a11y::ePlatformIsDisabled)
    return nullptr;

  if (mInDtor || mOnDestroyCalled || mWindowType == eWindowType_invisible) {
    return nullptr;
  }

  // In case of popup window return a popup accessible.
  nsView* view = nsView::GetViewFor(this);
  if (view) {
    nsIFrame* frame = view->GetFrame();
    if (frame && nsLayoutUtils::IsPopup(frame)) {
      nsAccessibilityService* accService = GetOrCreateAccService();
      if (accService) {
        a11y::DocAccessible* docAcc =
          GetAccService()->GetDocAccessible(frame->PresContext()->PresShell());
        if (docAcc) {
          NS_LOG_WMGETOBJECT(this, mWnd,
                             docAcc->GetAccessibleOrDescendant(frame->GetContent()));
          return docAcc->GetAccessibleOrDescendant(frame->GetContent());
        }
      }
    }
  }

  // otherwise root document accessible.
  NS_LOG_WMGETOBJECT(this, mWnd, GetRootAccessible());
  return GetRootAccessible();
}
#endif

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Transparency
 **
 ** Window transparency helpers.
 **
 **************************************************************
 **************************************************************/

#ifdef MOZ_XUL

void nsWindow::SetWindowTranslucencyInner(nsTransparencyMode aMode)
{
  if (aMode == mTransparencyMode)
    return;

  // stop on dialogs and popups!
  HWND hWnd = WinUtils::GetTopLevelHWND(mWnd, true);
  nsWindow* parent = WinUtils::GetNSWindowPtr(hWnd);

  if (!parent)
  {
    NS_WARNING("Trying to use transparent chrome in an embedded context");
    return;
  }

  if (parent != this) {
    NS_WARNING("Setting SetWindowTranslucencyInner on a parent this is not us!");
  }

  if (aMode == eTransparencyTransparent) {
    // If we're switching to the use of a transparent window, hide the chrome
    // on our parent.
    HideWindowChrome(true);
  } else if (mHideChrome && mTransparencyMode == eTransparencyTransparent) {
    // if we're switching out of transparent, re-enable our parent's chrome.
    HideWindowChrome(false);
  }

  LONG_PTR style = ::GetWindowLongPtrW(hWnd, GWL_STYLE),
    exStyle = ::GetWindowLongPtr(hWnd, GWL_EXSTYLE);
 
   if (parent->mIsVisible)
     style |= WS_VISIBLE;
   if (parent->mSizeMode == nsSizeMode_Maximized)
     style |= WS_MAXIMIZE;
   else if (parent->mSizeMode == nsSizeMode_Minimized)
     style |= WS_MINIMIZE;

   if (aMode == eTransparencyTransparent)
     exStyle |= WS_EX_LAYERED;
   else
     exStyle &= ~WS_EX_LAYERED;

  VERIFY_WINDOW_STYLE(style);
  ::SetWindowLongPtrW(hWnd, GWL_STYLE, style);
  ::SetWindowLongPtrW(hWnd, GWL_EXSTYLE, exStyle);

  if (HasGlass())
    memset(&mGlassMargins, 0, sizeof mGlassMargins);
  mTransparencyMode = aMode;

  if (mCompositorWidgetDelegate) {
    mCompositorWidgetDelegate->UpdateTransparency(aMode);
  }
  UpdateGlass();
}

#endif //MOZ_XUL

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Popup rollup hooks
 **
 ** Deals with CaptureRollup on popup windows.
 **
 **************************************************************
 **************************************************************/

// Schedules a timer for a window, so we can rollup after processing the hook event
void nsWindow::ScheduleHookTimer(HWND aWnd, UINT aMsgId)
{
  // In some cases multiple hooks may be scheduled
  // so ignore any other requests once one timer is scheduled
  if (sHookTimerId == 0) {
    // Remember the window handle and the message ID to be used later
    sRollupMsgId = aMsgId;
    sRollupMsgWnd = aWnd;
    // Schedule native timer for doing the rollup after
    // this event is done being processed
    sHookTimerId = ::SetTimer(nullptr, 0, 0, (TIMERPROC)HookTimerForPopups);
    NS_ASSERTION(sHookTimerId, "Timer couldn't be created.");
  }
}

#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
int gLastMsgCode = 0;
extern MSGFEventMsgInfo gMSGFEvents[];
#endif

// Process Menu messages, rollup when popup is clicked.
LRESULT CALLBACK nsWindow::MozSpecialMsgFilter(int code, WPARAM wParam, LPARAM lParam)
{
#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
  if (sProcessHook) {
    MSG* pMsg = (MSG*)lParam;

    int inx = 0;
    while (gMSGFEvents[inx].mId != code && gMSGFEvents[inx].mStr != nullptr) {
      inx++;
    }
    if (code != gLastMsgCode) {
      if (gMSGFEvents[inx].mId == code) {
#ifdef DEBUG
        MOZ_LOG(gWindowsLog, LogLevel::Info, 
               ("MozSpecialMessageProc - code: 0x%X  - %s  hw: %p\n", 
                code, gMSGFEvents[inx].mStr, pMsg->hwnd));
#endif
      } else {
#ifdef DEBUG
        MOZ_LOG(gWindowsLog, LogLevel::Info, 
               ("MozSpecialMessageProc - code: 0x%X  - %d  hw: %p\n", 
                code, gMSGFEvents[inx].mId, pMsg->hwnd));
#endif
      }
      gLastMsgCode = code;
    }
    PrintEvent(pMsg->message, FALSE, FALSE);
  }
#endif // #ifdef POPUP_ROLLUP_DEBUG_OUTPUT

  if (sProcessHook && code == MSGF_MENU) {
    MSG* pMsg = (MSG*)lParam;
    ScheduleHookTimer( pMsg->hwnd, pMsg->message);
  }

  return ::CallNextHookEx(sMsgFilterHook, code, wParam, lParam);
}

// Process all mouse messages. Roll up when a click is in a native window
// that doesn't have an nsIWidget.
LRESULT CALLBACK nsWindow::MozSpecialMouseProc(int code, WPARAM wParam, LPARAM lParam)
{
  if (sProcessHook) {
    switch (WinUtils::GetNativeMessage(wParam)) {
      case WM_LBUTTONDOWN:
      case WM_RBUTTONDOWN:
      case WM_MBUTTONDOWN:
      case WM_MOUSEWHEEL:
      case WM_MOUSEHWHEEL:
      {
        MOUSEHOOKSTRUCT* ms = (MOUSEHOOKSTRUCT*)lParam;
        nsIWidget* mozWin = WinUtils::GetNSWindowPtr(ms->hwnd);
        if (mozWin) {
          // If this window is windowed plugin window, the mouse events are not
          // sent to us.
          if (static_cast<nsWindow*>(mozWin)->IsPlugin())
            ScheduleHookTimer(ms->hwnd, (UINT)wParam);
        } else {
          ScheduleHookTimer(ms->hwnd, (UINT)wParam);
        }
        break;
      }
    }
  }
  return ::CallNextHookEx(sCallMouseHook, code, wParam, lParam);
}

// Process all messages. Roll up when the window is moving, or
// is resizing or when maximized or mininized.
LRESULT CALLBACK nsWindow::MozSpecialWndProc(int code, WPARAM wParam, LPARAM lParam)
{
#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
  if (sProcessHook) {
    CWPSTRUCT* cwpt = (CWPSTRUCT*)lParam;
    PrintEvent(cwpt->message, FALSE, FALSE);
  }
#endif

  if (sProcessHook) {
    CWPSTRUCT* cwpt = (CWPSTRUCT*)lParam;
    if (cwpt->message == WM_MOVING ||
        cwpt->message == WM_SIZING ||
        cwpt->message == WM_GETMINMAXINFO) {
      ScheduleHookTimer(cwpt->hwnd, (UINT)cwpt->message);
    }
  }

  return ::CallNextHookEx(sCallProcHook, code, wParam, lParam);
}

// Register the special "hooks" for dropdown processing.
void nsWindow::RegisterSpecialDropdownHooks()
{
  NS_ASSERTION(!sMsgFilterHook, "sMsgFilterHook must be NULL!");
  NS_ASSERTION(!sCallProcHook,  "sCallProcHook must be NULL!");

  DISPLAY_NMM_PRT("***************** Installing Msg Hooks ***************\n");

  // Install msg hook for moving the window and resizing
  if (!sMsgFilterHook) {
    DISPLAY_NMM_PRT("***** Hooking sMsgFilterHook!\n");
    sMsgFilterHook = SetWindowsHookEx(WH_MSGFILTER, MozSpecialMsgFilter,
                                      nullptr, GetCurrentThreadId());
#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
    if (!sMsgFilterHook) {
      MOZ_LOG(gWindowsLog, LogLevel::Info, 
             ("***** SetWindowsHookEx is NOT installed for WH_MSGFILTER!\n"));
    }
#endif
  }

  // Install msg hook for menus
  if (!sCallProcHook) {
    DISPLAY_NMM_PRT("***** Hooking sCallProcHook!\n");
    sCallProcHook  = SetWindowsHookEx(WH_CALLWNDPROC, MozSpecialWndProc,
                                      nullptr, GetCurrentThreadId());
#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
    if (!sCallProcHook) {
      MOZ_LOG(gWindowsLog, LogLevel::Info, 
             ("***** SetWindowsHookEx is NOT installed for WH_CALLWNDPROC!\n"));
    }
#endif
  }

  // Install msg hook for the mouse
  if (!sCallMouseHook) {
    DISPLAY_NMM_PRT("***** Hooking sCallMouseHook!\n");
    sCallMouseHook  = SetWindowsHookEx(WH_MOUSE, MozSpecialMouseProc,
                                       nullptr, GetCurrentThreadId());
#ifdef POPUP_ROLLUP_DEBUG_OUTPUT
    if (!sCallMouseHook) {
      MOZ_LOG(gWindowsLog, LogLevel::Info, 
             ("***** SetWindowsHookEx is NOT installed for WH_MOUSE!\n"));
    }
#endif
  }
}

// Unhook special message hooks for dropdowns.
void nsWindow::UnregisterSpecialDropdownHooks()
{
  DISPLAY_NMM_PRT("***************** De-installing Msg Hooks ***************\n");

  if (sCallProcHook) {
    DISPLAY_NMM_PRT("***** Unhooking sCallProcHook!\n");
    if (!::UnhookWindowsHookEx(sCallProcHook)) {
      DISPLAY_NMM_PRT("***** UnhookWindowsHookEx failed for sCallProcHook!\n");
    }
    sCallProcHook = nullptr;
  }

  if (sMsgFilterHook) {
    DISPLAY_NMM_PRT("***** Unhooking sMsgFilterHook!\n");
    if (!::UnhookWindowsHookEx(sMsgFilterHook)) {
      DISPLAY_NMM_PRT("***** UnhookWindowsHookEx failed for sMsgFilterHook!\n");
    }
    sMsgFilterHook = nullptr;
  }

  if (sCallMouseHook) {
    DISPLAY_NMM_PRT("***** Unhooking sCallMouseHook!\n");
    if (!::UnhookWindowsHookEx(sCallMouseHook)) {
      DISPLAY_NMM_PRT("***** UnhookWindowsHookEx failed for sCallMouseHook!\n");
    }
    sCallMouseHook = nullptr;
  }
}

// This timer is designed to only fire one time at most each time a "hook" function
// is used to rollup the dropdown. In some cases, the timer may be scheduled from the
// hook, but that hook event or a subsequent event may roll up the dropdown before
// this timer function is executed.
//
// For example, if an MFC control takes focus, the combobox will lose focus and rollup
// before this function fires.
VOID CALLBACK nsWindow::HookTimerForPopups(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime)
{
  if (sHookTimerId != 0) {
    // if the window is nullptr then we need to use the ID to kill the timer
    BOOL status = ::KillTimer(nullptr, sHookTimerId);
    NS_ASSERTION(status, "Hook Timer was not killed.");
    sHookTimerId = 0;
  }

  if (sRollupMsgId != 0) {
    // Note: DealWithPopups does the check to make sure that the rollup widget is set.
    LRESULT popupHandlingResult;
    nsAutoRollup autoRollup;
    DealWithPopups(sRollupMsgWnd, sRollupMsgId, 0, 0, &popupHandlingResult);
    sRollupMsgId = 0;
    sRollupMsgWnd = nullptr;
  }
}

BOOL CALLBACK nsWindow::ClearResourcesCallback(HWND aWnd, LPARAM aMsg)
{
    nsWindow *window = WinUtils::GetNSWindowPtr(aWnd);
    if (window) {
        window->ClearCachedResources();
    }  
    return TRUE;
}

void
nsWindow::ClearCachedResources()
{
    if (mLayerManager &&
        mLayerManager->GetBackendType() == LayersBackend::LAYERS_BASIC) {
      mLayerManager->ClearCachedResources();
    }
    ::EnumChildWindows(mWnd, nsWindow::ClearResourcesCallback, 0);
}

static bool IsDifferentThreadWindow(HWND aWnd)
{
  return ::GetCurrentThreadId() != ::GetWindowThreadProcessId(aWnd, nullptr);
}

// static
bool
nsWindow::EventIsInsideWindow(nsWindow* aWindow)
{
  RECT r;
  ::GetWindowRect(aWindow->mWnd, &r);
  DWORD pos = ::GetMessagePos();
  POINT mp;
  mp.x = GET_X_LPARAM(pos);
  mp.y = GET_Y_LPARAM(pos);

  // was the event inside this window?
  return static_cast<bool>(::PtInRect(&r, mp));
}

// static
bool
nsWindow::GetPopupsToRollup(nsIRollupListener* aRollupListener,
                            uint32_t* aPopupsToRollup)
{
  // If we're dealing with menus, we probably have submenus and we don't want
  // to rollup some of them if the click is in a parent menu of the current
  // submenu.
  *aPopupsToRollup = UINT32_MAX;
  AutoTArray<nsIWidget*, 5> widgetChain;
  uint32_t sameTypeCount =
    aRollupListener->GetSubmenuWidgetChain(&widgetChain);
  for (uint32_t i = 0; i < widgetChain.Length(); ++i) {
    nsIWidget* widget = widgetChain[i];
    if (EventIsInsideWindow(static_cast<nsWindow*>(widget))) {
      // Don't roll up if the mouse event occurred within a menu of the
      // same type. If the mouse event occurred in a menu higher than that,
      // roll up, but pass the number of popups to Rollup so that only those
      // of the same type close up.
      if (i < sameTypeCount) {
        return false;
      }

      *aPopupsToRollup = sameTypeCount;
      break;
    }
  }
  return true;
}

// static
bool
nsWindow::NeedsToHandleNCActivateDelayed(HWND aWnd)
{
  // While popup is open, popup window might be activated by other application.
  // At this time, we need to take back focus to the previous window but it
  // causes flickering its nonclient area because WM_NCACTIVATE comes before
  // WM_ACTIVATE and we cannot know which window will take focus at receiving
  // WM_NCACTIVATE. Therefore, we need a hack for preventing the flickerling.
  //
  // If non-popup window receives WM_NCACTIVATE at deactivating, default
  // wndproc shouldn't handle it as deactivating. Instead, at receiving
  // WM_ACTIVIATE after that, WM_NCACTIVATE should be sent again manually.
  // This returns true if the window needs to handle WM_NCACTIVATE later.

  nsWindow* window = WinUtils::GetNSWindowPtr(aWnd);
  return window && !window->IsPopup();
}

static bool
IsTouchSupportEnabled(HWND aWnd)
{
  nsWindow* topWindow = WinUtils::GetNSWindowPtr(WinUtils::GetTopLevelHWND(aWnd, true));
  return topWindow ? topWindow->IsTouchWindow() : false;
}

// static
bool
nsWindow::DealWithPopups(HWND aWnd, UINT aMessage,
                         WPARAM aWParam, LPARAM aLParam, LRESULT* aResult)
{
  NS_ASSERTION(aResult, "Bad outResult");

  // XXX Why do we use the return value of WM_MOUSEACTIVATE for all messages?
  *aResult = MA_NOACTIVATE;

  if (!::IsWindowVisible(aWnd)) {
    return false;
  }

  nsIRollupListener* rollupListener = nsBaseWidget::GetActiveRollupListener();
  NS_ENSURE_TRUE(rollupListener, false);

  nsCOMPtr<nsIWidget> popup = rollupListener->GetRollupWidget();
  if (!popup) {
    return false;
  }

  static bool sSendingNCACTIVATE = false;
  static bool sPendingNCACTIVATE = false;
  uint32_t popupsToRollup = UINT32_MAX;

  bool consumeRollupEvent = false;

  nsWindow* popupWindow = static_cast<nsWindow*>(popup.get());
  UINT nativeMessage = WinUtils::GetNativeMessage(aMessage);
  switch (nativeMessage) {
    case WM_TOUCH:
      if (!IsTouchSupportEnabled(aWnd)) {
        // If APZ is disabled, don't allow touch inputs to dismiss popups. The
        // compatibility mouse events will do it instead.
        return false;
      }
      MOZ_FALLTHROUGH;
    case WM_LBUTTONDOWN:
    case WM_RBUTTONDOWN:
    case WM_MBUTTONDOWN:
    case WM_NCLBUTTONDOWN:
    case WM_NCRBUTTONDOWN:
    case WM_NCMBUTTONDOWN:
      if (nativeMessage != WM_TOUCH &&
          IsTouchSupportEnabled(aWnd) &&
          MOUSE_INPUT_SOURCE() == nsIDOMMouseEvent::MOZ_SOURCE_TOUCH) {
        // If any of these mouse events are really compatibility events that
        // Windows is sending for touch inputs, then don't allow them to dismiss
        // popups when APZ is enabled (instead we do the dismissing as part of
        // WM_TOUCH handling which is more correct).
        // If we don't do this, then when the user lifts their finger after a
        // long-press, the WM_RBUTTONDOWN compatibility event that Windows sends
        // us will dismiss the contextmenu popup that we displayed as part of
        // handling the long-tap-up.
        return false;
      }
      if (!EventIsInsideWindow(popupWindow) &&
          GetPopupsToRollup(rollupListener, &popupsToRollup)) {
        break;
      }
      return false;

    case WM_MOUSEWHEEL:
    case WM_MOUSEHWHEEL:
      // We need to check if the popup thinks that it should cause closing
      // itself when mouse wheel events are fired outside the rollup widget.
      if (!EventIsInsideWindow(popupWindow)) {
        // Check if we should consume this event even if we don't roll-up:
        consumeRollupEvent =
          rollupListener->ShouldConsumeOnMouseWheelEvent();
        *aResult = MA_ACTIVATE;
        if (rollupListener->ShouldRollupOnMouseWheelEvent() &&
            GetPopupsToRollup(rollupListener, &popupsToRollup)) {
          break;
        }
      }
      return consumeRollupEvent;

    case WM_ACTIVATEAPP:
      break;

    case WM_ACTIVATE:
      // NOTE: Don't handle WA_INACTIVE for preventing popup taking focus
      // because we cannot distinguish it's caused by mouse or not.
      if (LOWORD(aWParam) == WA_ACTIVE && aLParam) {
        nsWindow* window = WinUtils::GetNSWindowPtr(aWnd);
        if (window && window->IsPopup()) {
          // Cancel notifying widget listeners of deactivating the previous
          // active window (see WM_KILLFOCUS case in ProcessMessage()).
          sJustGotDeactivate = false;
          // Reactivate the window later.
          ::PostMessageW(aWnd, MOZ_WM_REACTIVATE, aWParam, aLParam);
          return true;
        }
        // Don't rollup the popup when focus moves back to the parent window
        // from a popup because such case is caused by strange mouse drivers.
        nsWindow* prevWindow =
          WinUtils::GetNSWindowPtr(reinterpret_cast<HWND>(aLParam));
        if (prevWindow && prevWindow->IsPopup()) {
          return false;
        }
      } else if (LOWORD(aWParam) == WA_INACTIVE) {
        nsWindow* activeWindow =
          WinUtils::GetNSWindowPtr(reinterpret_cast<HWND>(aLParam));
        if (sPendingNCACTIVATE && NeedsToHandleNCActivateDelayed(aWnd)) {
          // If focus moves to non-popup widget or focusable popup, the window
          // needs to update its nonclient area.
          if (!activeWindow || !activeWindow->IsPopup()) {
            sSendingNCACTIVATE = true;
            ::SendMessageW(aWnd, WM_NCACTIVATE, false, 0);
            sSendingNCACTIVATE = false;
          }
          sPendingNCACTIVATE = false;
        }
        // If focus moves from/to popup, we don't need to rollup the popup
        // because such case is caused by strange mouse drivers.
        if (activeWindow) {
          if (activeWindow->IsPopup()) {
            return false;
          }
          nsWindow* deactiveWindow = WinUtils::GetNSWindowPtr(aWnd);
          if (deactiveWindow && deactiveWindow->IsPopup()) {
            return false;
          }
        }
      } else if (LOWORD(aWParam) == WA_CLICKACTIVE) {
        // If the WM_ACTIVATE message is caused by a click in a popup,
        // we should not rollup any popups.
        if (EventIsInsideWindow(popupWindow) ||
            !GetPopupsToRollup(rollupListener, &popupsToRollup)) {
          return false;
        }
      }
      break;

    case MOZ_WM_REACTIVATE:
      // The previous active window should take back focus.
      if (::IsWindow(reinterpret_cast<HWND>(aLParam))) {
        ::SetForegroundWindow(reinterpret_cast<HWND>(aLParam));
      }
      return true;

    case WM_NCACTIVATE:
      if (!aWParam && !sSendingNCACTIVATE &&
          NeedsToHandleNCActivateDelayed(aWnd)) {
        // Don't just consume WM_NCACTIVATE. It doesn't handle only the
        // nonclient area state change.
        ::DefWindowProcW(aWnd, aMessage, TRUE, aLParam);
        // Accept the deactivating because it's necessary to receive following
        // WM_ACTIVATE.
        *aResult = TRUE;
        sPendingNCACTIVATE = true;
        return true;
      }
      return false;

    case WM_MOUSEACTIVATE:
      if (!EventIsInsideWindow(popupWindow) &&
          GetPopupsToRollup(rollupListener, &popupsToRollup)) {
        // WM_MOUSEACTIVATE may be caused by moving the mouse (e.g., X-mouse
        // of TweakUI is enabled. Then, check if the popup should be rolled up
        // with rollup listener. If not, just consume the message.
        if (HIWORD(aLParam) == WM_MOUSEMOVE &&
            !rollupListener->ShouldRollupOnMouseActivate()) {
          return true;
        }
        // Otherwise, it should be handled by wndproc.
        return false;
      }

      // Prevent the click inside the popup from causing a change in window
      // activation. Since the popup is shown non-activated, we need to eat any
      // requests to activate the window while it is displayed. Windows will
      // automatically activate the popup on the mousedown otherwise.
      return true;

    case WM_SHOWWINDOW:
      // If the window is being minimized, close popups.
      if (aLParam == SW_PARENTCLOSING) {
        break;
      }
      return false;

    case WM_KILLFOCUS:
      // If focus moves to other window created in different process/thread,
      // e.g., a plugin window, popups should be rolled up.
      if (IsDifferentThreadWindow(reinterpret_cast<HWND>(aWParam))) {
        break;
      }
      return false;

    case WM_MOVING:
    case WM_MENUSELECT:
      break;

    default:
      return false;
  }

  // Only need to deal with the last rollup for left mouse down events.
  NS_ASSERTION(!mLastRollup, "mLastRollup is null");

  if (nativeMessage == WM_LBUTTONDOWN) {
    POINT pt;
    pt.x = GET_X_LPARAM(aLParam);
    pt.y = GET_Y_LPARAM(aLParam);
    ::ClientToScreen(aWnd, &pt);
    nsIntPoint pos(pt.x, pt.y);

    consumeRollupEvent =
      rollupListener->Rollup(popupsToRollup, true, &pos, &mLastRollup);
    NS_IF_ADDREF(mLastRollup);
  } else {
    consumeRollupEvent =
      rollupListener->Rollup(popupsToRollup, true, nullptr, nullptr);
  }

  // Tell hook to stop processing messages
  sProcessHook = false;
  sRollupMsgId = 0;
  sRollupMsgWnd = nullptr;

  // If we are NOT supposed to be consuming events, let it go through
  if (consumeRollupEvent && nativeMessage != WM_RBUTTONDOWN) {
    *aResult = MA_ACTIVATE;
    return true;
  }

  return false;
}

/**************************************************************
 **************************************************************
 **
 ** BLOCK: Misc. utility methods and functions.
 **
 ** General use.
 **
 **************************************************************
 **************************************************************/

// Note that the result of GetTopLevelWindow method can be different from the
// result of WinUtils::GetTopLevelHWND().  The result can be non-floating
// window.  Because our top level window may be contained in another window
// which is not managed by us.
nsWindow* nsWindow::GetTopLevelWindow(bool aStopOnDialogOrPopup)
{
  nsWindow* curWindow = this;

  while (true) {
    if (aStopOnDialogOrPopup) {
      switch (curWindow->mWindowType) {
        case eWindowType_dialog:
        case eWindowType_popup:
          return curWindow;
        default:
          break;
      }
    }

    // Retrieve the top level parent or owner window
    nsWindow* parentWindow = curWindow->GetParentWindow(true);

    if (!parentWindow)
      return curWindow;

    curWindow = parentWindow;
  }
}

static BOOL CALLBACK gEnumWindowsProc(HWND hwnd, LPARAM lParam)
{
  DWORD pid;
  ::GetWindowThreadProcessId(hwnd, &pid);
  if (pid == GetCurrentProcessId() && ::IsWindowVisible(hwnd))
  {
    gWindowsVisible = true;
    return FALSE;
  }
  return TRUE;
}

bool nsWindow::CanTakeFocus()
{
  gWindowsVisible = false;
  EnumWindows(gEnumWindowsProc, 0);
  if (!gWindowsVisible) {
    return true;
  } else {
    HWND fgWnd = ::GetForegroundWindow();
    if (!fgWnd) {
      return true;
    }
    DWORD pid;
    GetWindowThreadProcessId(fgWnd, &pid);
    if (pid == GetCurrentProcessId()) {
      return true;
    }
  }
  return false;
}

/* static */ const wchar_t*
nsWindow::GetMainWindowClass()
{
  static const wchar_t* sMainWindowClass = nullptr;
  if (!sMainWindowClass) {
    nsAdoptingString className =
      Preferences::GetString("ui.window_class_override");
    if (!className.IsEmpty()) {
      sMainWindowClass = wcsdup(className.get());
    } else {
      sMainWindowClass = kClassNameGeneral;
    }
  }
  return sMainWindowClass;
}

LPARAM nsWindow::lParamToScreen(LPARAM lParam)
{
  POINT pt;
  pt.x = GET_X_LPARAM(lParam);
  pt.y = GET_Y_LPARAM(lParam);
  ::ClientToScreen(mWnd, &pt);
  return MAKELPARAM(pt.x, pt.y);
}

LPARAM nsWindow::lParamToClient(LPARAM lParam)
{
  POINT pt;
  pt.x = GET_X_LPARAM(lParam);
  pt.y = GET_Y_LPARAM(lParam);
  ::ScreenToClient(mWnd, &pt);
  return MAKELPARAM(pt.x, pt.y);
}

void nsWindow::PickerOpen()
{
  mPickerDisplayCount++;
}

void nsWindow::PickerClosed()
{
  NS_ASSERTION(mPickerDisplayCount > 0, "mPickerDisplayCount out of sync!");
  if (!mPickerDisplayCount)
    return;
  mPickerDisplayCount--;
  if (!mPickerDisplayCount && mDestroyCalled) {
    Destroy();
  }
}

bool
nsWindow::WidgetTypeSupportsAcceleration()
{
  // We don't currently support using an accelerated layer manager with
  // transparent windows so don't even try. I'm also not sure if we even
  // want to support this case. See bug 593471.
  //
  // Also see bug 1150376, D3D11 composition can cause issues on some devices
  // on Windows 7 where presentation fails randomly for windows with drop
  // shadows.
  return mTransparencyMode != eTransparencyTransparent &&
         !(IsPopup() && DeviceManagerDx::Get()->IsWARP());
}

void
nsWindow::SetCandidateWindowForPlugin(const CandidateWindowPosition& aPosition)
{
  CANDIDATEFORM form;
  form.dwIndex = 0;
  if (aPosition.mExcludeRect) {
    form.dwStyle = CFS_EXCLUDE;
    form.rcArea.left = aPosition.mRect.x;
    form.rcArea.top = aPosition.mRect.y;
    form.rcArea.right = aPosition.mRect.x + aPosition.mRect.width;
    form.rcArea.bottom = aPosition.mRect.y + aPosition.mRect.height;
  } else {
    form.dwStyle = CFS_CANDIDATEPOS;
  }
  form.ptCurrentPos.x = aPosition.mPoint.x;
  form.ptCurrentPos.y = aPosition.mPoint.y;

  IMEHandler::SetCandidateWindow(this, &form);
}

void
nsWindow::DefaultProcOfPluginEvent(const WidgetPluginEvent& aEvent)
{
  const NPEvent* pPluginEvent =
   static_cast<const NPEvent*>(aEvent.mPluginEvent);

  if (NS_WARN_IF(!pPluginEvent)) {
    return;
  }

  if (!mWnd) {
    return;
  }

  // For WM_IME_*COMPOSITION
  IMEHandler::DefaultProcOfPluginEvent(this, pPluginEvent);

  CallWindowProcW(GetPrevWindowProc(), mWnd, pPluginEvent->event,
                  pPluginEvent->wParam, pPluginEvent->lParam);
}

nsresult
nsWindow::OnWindowedPluginKeyEvent(const NativeEventData& aKeyEventData,
                                   nsIKeyEventInPluginCallback* aCallback)
{
  if (NS_WARN_IF(!mWnd)) {
    return NS_OK;
  }
  const WinNativeKeyEventData* eventData =
    static_cast<const WinNativeKeyEventData*>(aKeyEventData);
  switch (eventData->mMessage) {
    case WM_KEYDOWN:
    case WM_SYSKEYDOWN: {
      MSG mozMsg =
        WinUtils::InitMSG(MOZ_WM_KEYDOWN, eventData->mWParam,
                          eventData->mLParam, mWnd);
      ModifierKeyState modifierKeyState(eventData->mModifiers);
      NativeKey nativeKey(this, mozMsg, modifierKeyState,
                          eventData->GetKeyboardLayout());
      return nativeKey.HandleKeyDownMessage() ? NS_SUCCESS_EVENT_CONSUMED :
                                                NS_OK;
    }
    case WM_KEYUP:
    case WM_SYSKEYUP: {
      MSG mozMsg =
        WinUtils::InitMSG(MOZ_WM_KEYUP, eventData->mWParam,
                          eventData->mLParam, mWnd);
      ModifierKeyState modifierKeyState(eventData->mModifiers);
      NativeKey nativeKey(this, mozMsg, modifierKeyState,
                          eventData->GetKeyboardLayout());
      return nativeKey.HandleKeyUpMessage() ? NS_SUCCESS_EVENT_CONSUMED : NS_OK;
    }
    default:
      // We shouldn't consume WM_*CHAR messages here even if the preceding
      // keydown or keyup event on the plugin is consumed.  It should be
      // managed in each plugin window rather than top level window.
      return NS_OK;
  }
}

/**************************************************************
 **************************************************************
 **
 ** BLOCK: ChildWindow impl.
 **
 ** Child window overrides.
 **
 **************************************************************
 **************************************************************/

// return the style for a child nsWindow
DWORD ChildWindow::WindowStyle()
{
  DWORD style = WS_CLIPCHILDREN | nsWindow::WindowStyle();
  if (!(style & WS_POPUP))
    style |= WS_CHILD; // WS_POPUP and WS_CHILD are mutually exclusive.
  VERIFY_WINDOW_STYLE(style);
  return style;
}

void
nsWindow::GetCompositorWidgetInitData(mozilla::widget::CompositorWidgetInitData* aInitData)
{
  aInitData->hWnd() = reinterpret_cast<uintptr_t>(mWnd);
  aInitData->widgetKey() = reinterpret_cast<uintptr_t>(static_cast<nsIWidget*>(this));
  aInitData->transparencyMode() = mTransparencyMode;
}
