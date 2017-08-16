/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef WinIMEHandler_h_
#define WinIMEHandler_h_

#include "nscore.h"
#include "nsWindowBase.h"
#include "npapi.h"
#include <windows.h>
#include <inputscope.h>

#define NS_WM_IMEFIRST WM_IME_SETCONTEXT
#define NS_WM_IMELAST  WM_IME_KEYUP

class nsWindow;

namespace mozilla {
namespace widget {

struct MSGResult;

/**
 * IMEHandler class is a mediator class.  On Windows, there are two IME API
 * sets: One is IMM which is legacy API set. The other is TSF which is modern
 * API set. By using this class, non-IME handler classes don't need to worry
 * that we're in which mode.
 */
class IMEHandler final
{
public:
  static void Initialize();
  static void Terminate();

  /**
   * Returns TSF related native data or native IME context.
   */
  static void* GetNativeData(nsWindow* aWindow, uint32_t aDataType);

  /**
   * ProcessRawKeyMessage() message is called before calling TranslateMessage()
   * and DispatchMessage().  If this returns true, the message is consumed.
   * Then, caller must not perform TranslateMessage() nor DispatchMessage().
   */
  static bool ProcessRawKeyMessage(const MSG& aMsg);

  /**
   * When the message is not needed to handle anymore by the caller, this
   * returns true.  Otherwise, false.
   */
  static bool ProcessMessage(nsWindow* aWindow, UINT aMessage,
                             WPARAM& aWParam, LPARAM& aLParam,
                             MSGResult& aResult);

  /**
   * When there is a composition, returns true.  Otherwise, false.
   */
  static bool IsComposing();

  /**
   * When there is a composition and it's in the window, returns true.
   * Otherwise, false.
   */
  static bool IsComposingOn(nsWindow* aWindow);

  /**
   * Notifies IME of the notification (a request or an event).
   */
  static nsresult NotifyIME(nsWindow* aWindow,
                            const IMENotification& aIMENotification);

  /**
   * Returns notification requests of IME.
   */
  static IMENotificationRequests GetIMENotificationRequests();

  /**
   * Returns native text event dispatcher listener.
   */
  static TextEventDispatcherListener* GetNativeTextEventDispatcherListener();

  /**
   * Returns IME open state on the window.
   */
  static bool GetOpenState(nsWindow* aWindow);

  /**
   * Called when the window is destroying.
   */
  static void OnDestroyWindow(nsWindow* aWindow);

  /**
   * Called when nsIWidget::SetInputContext() is called before the window's
   * InputContext is modified actually.
   */
  static void SetInputContext(nsWindow* aWindow,
                              InputContext& aInputContext,
                              const InputContextAction& aAction);

  /**
   * Associate or disassociate IME context to/from the aWindowBase.
   */
  static void AssociateIMEContext(nsWindowBase* aWindowBase, bool aEnable);

  /**
   * Called when the window is created.
   */
  static void InitInputContext(nsWindow* aWindow, InputContext& aInputContext);

  /*
   * For windowless plugin helper.
   */
  static void SetCandidateWindow(nsWindow* aWindow, CANDIDATEFORM* aForm);

  /*
   * For WM_IME_*COMPOSITION messages and e10s with windowless plugin
   */
  static void DefaultProcOfPluginEvent(nsWindow* aWindow,
                                       const NPEvent* aPluginEvent);

#ifdef NS_ENABLE_TSF
  /**
   * This is called by TSFStaticSink when active IME is changed.
   */
  static void OnKeyboardLayoutChanged();
#endif // #ifdef NS_ENABLE_TSF

#ifdef DEBUG
  /**
   * Returns true when current keyboard layout has IME.  Otherwise, false.
   */
  static bool CurrentKeyboardLayoutHasIME();
#endif // #ifdef DEBUG

private:
  static nsWindow* sFocusedWindow;
  static InputContextAction::Cause sLastContextActionCause;

  static bool sPluginHasFocus;

#ifdef NS_ENABLE_TSF
  static decltype(SetInputScopes)* sSetInputScopes;
  static void SetInputScopeForIMM32(nsWindow* aWindow,
                                    const nsAString& aHTMLInputType,
                                    const nsAString& aHTMLInputInputmode);
  static bool sIsInTSFMode;
  // If sIMMEnabled is false, any IME messages are not handled in TSF mode.
  // Additionally, IME context is always disassociated from focused window.
  static bool sIsIMMEnabled;
  static bool sAssociateIMCOnlyWhenIMM_IMEActive;

  static bool IsTSFAvailable() { return (sIsInTSFMode && !sPluginHasFocus); }
  static bool IsIMMActive();

  static void MaybeShowOnScreenKeyboard();
  static void MaybeDismissOnScreenKeyboard(nsWindow* aWindow);
  static bool WStringStartsWithCaseInsensitive(const std::wstring& aHaystack,
                                               const std::wstring& aNeedle);
  static bool NeedOnScreenKeyboard();
  static bool IsKeyboardPresentOnSlate();
  static bool IsInTabletMode();
  static bool AutoInvokeOnScreenKeyboardInDesktopMode();
  static bool NeedsToAssociateIMC();

  /**
   * Show the Windows on-screen keyboard. Only allowed for
   * chrome documents and Windows 8 and higher.
   */
  static void ShowOnScreenKeyboard();

  /**
   * Dismiss the Windows on-screen keyboard. Only allowed for
   * Windows 8 and higher.
   */
  static void DismissOnScreenKeyboard();

  /**
   * Get the HWND for the on-screen keyboard, if it's up. Only
   * allowed for Windows 8 and higher.
   */
  static HWND GetOnScreenKeyboardWindow();
#endif // #ifdef NS_ENABLE_TSF
};

} // namespace widget
} // namespace mozilla

#endif // #ifndef WinIMEHandler_h_
