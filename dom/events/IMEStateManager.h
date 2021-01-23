/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_IMEStateManager_h_
#define mozilla_IMEStateManager_h_

#include "mozilla/EventForwards.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/dom/BrowserParent.h"
#include "nsIWidget.h"

class nsIContent;
class nsINode;
class nsPresContext;

namespace mozilla {

class EditorBase;
class EventDispatchingCallback;
class IMEContentObserver;
class TextCompositionArray;
class TextComposition;

namespace dom {
class Selection;
}  // namespace dom

/**
 * IMEStateManager manages InputContext (e.g., active editor type, IME enabled
 * state and IME open state) of nsIWidget instances, manages IMEContentObserver
 * and provides useful API for IME.
 */

class IMEStateManager {
  typedef dom::BrowserParent BrowserParent;
  typedef widget::IMEMessage IMEMessage;
  typedef widget::IMENotification IMENotification;
  typedef widget::IMEState IMEState;
  typedef widget::InputContext InputContext;
  typedef widget::InputContextAction InputContextAction;

 public:
  static void Init();
  static void Shutdown();

  /**
   * GetActiveBrowserParent() returns a pointer to a BrowserParent instance
   * which is managed by the focused content (sContent).  If the focused content
   * isn't managing another process, this returns nullptr.
   */
  static BrowserParent* GetActiveBrowserParent() {
    // If menu has pseudo focus, we should ignore active child process.
    if (sInstalledMenuKeyboardListener) {
      return nullptr;
    }
    return BrowserParent::GetFocused();
  }

  /**
   * DoesBrowserParentHaveIMEFocus() returns true when aBrowserParent has IME
   * focus, i.e., the BrowserParent sent "focus" notification but not yet sends
   * "blur". Note that this doesn't check if the remote processes are same
   * because if another BrowserParent has focus, committing composition causes
   * firing composition events in different BrowserParent.  (Anyway, such case
   * shouldn't occur.)
   */
  static bool DoesBrowserParentHaveIMEFocus(
      const BrowserParent* aBrowserParent) {
    MOZ_ASSERT(aBrowserParent);
    return sFocusedIMEBrowserParent == aBrowserParent;
  }

  /**
   * Focus moved between browsers from aBlur to aFocus. (nullptr means the
   * chrome process.)
   */
  static void OnFocusMovedBetweenBrowsers(BrowserParent* aBlur,
                                          BrowserParent* aFocus);

  /**
   * Called when aWidget is being deleted.
   */
  static void WidgetDestroyed(nsIWidget* aWidget);

  /**
   * Called when a widget exists when the app is quitting
   */
  static void WidgetOnQuit(nsIWidget* aWidget);

  /**
   * GetWidgetForActiveInputContext() returns a widget which IMEStateManager
   * is managing input context with.  If a widget instance needs to cache
   * the last input context for nsIWidget::GetInputContext() or something,
   * it should check if its cache is valid with this method before using it
   * because if this method returns another instance, it means that
   * IMEStateManager may have already changed shared input context via the
   * widget.
   */
  static nsIWidget* GetWidgetForActiveInputContext() {
    return sActiveInputContextWidget;
  }

  /**
   * SetIMEContextForChildProcess() is called when aBrowserParent receives
   * SetInputContext() from the remote process.
   */
  static void SetInputContextForChildProcess(BrowserParent* aBrowserParent,
                                             const InputContext& aInputContext,
                                             const InputContextAction& aAction);

  /**
   * StopIMEStateManagement() is called when the process should stop managing
   * IME state.
   */
  static void StopIMEStateManagement();

  /**
   * MaybeStartOffsetUpdatedInChild() is called when composition start offset
   * is maybe updated in the child process.  I.e., even if it's not updated,
   * this is called and never called if the composition is in this process.
   * @param aWidget             The widget whose native IME context has the
   *                            composition.
   * @param aStartOffset        New composition start offset with native
   *                            linebreaks.
   */
  static void MaybeStartOffsetUpdatedInChild(nsIWidget* aWidget,
                                             uint32_t aStartOffset);

  static nsresult OnDestroyPresContext(nsPresContext* aPresContext);
  static nsresult OnRemoveContent(nsPresContext* aPresContext,
                                  nsIContent* aContent);
  /**
   * OnChangeFocus() should be called when focused content is changed or
   * IME enabled state is changed.  If nobody has focus, set both aPresContext
   * and aContent nullptr.  E.g., all windows are deactivated.
   */
  static nsresult OnChangeFocus(nsPresContext* aPresContext,
                                nsIContent* aContent,
                                InputContextAction::Cause aCause);

  /**
   * OnInstalledMenuKeyboardListener() is called when menu keyboard listener
   * is installed or uninstalled in the process.  So, even if menu keyboard
   * listener was installed in chrome process, this won't be called in content
   * processes.
   *
   * @param aInstalling     true if menu keyboard listener is installed.
   *                        Otherwise, i.e., menu keyboard listener is
   *                        uninstalled, false.
   */
  static void OnInstalledMenuKeyboardListener(bool aInstalling);

  // These two methods manage focus and selection/text observers.
  // They are separate from OnChangeFocus above because this offers finer
  // control compared to having the two methods incorporated into OnChangeFocus

  // Get the focused editor's selection and root
  static nsresult GetFocusSelectionAndRoot(dom::Selection** aSel,
                                           nsIContent** aRoot);
  // This method updates the current IME state.  However, if the enabled state
  // isn't changed by the new state, this method does nothing.
  // Note that this method changes the IME state of the active element in the
  // widget.  So, the caller must have focus.
  static void UpdateIMEState(const IMEState& aNewIMEState, nsIContent* aContent,
                             EditorBase* aEditorBase);

  // This method is called when user operates mouse button in focused editor
  // and before the editor handles it.
  // Returns true if IME consumes the event.  Otherwise, false.
  static bool OnMouseButtonEventInEditor(nsPresContext* aPresContext,
                                         nsIContent* aContent,
                                         WidgetMouseEvent* aMouseEvent);

  // This method is called when user clicked in an editor.
  // aContent must be:
  //   If the editor is for <input> or <textarea>, the element.
  //   If the editor is for contenteditable, the active editinghost.
  //   If the editor is for designMode, nullptr.
  static void OnClickInEditor(nsPresContext* aPresContext, nsIContent* aContent,
                              const WidgetMouseEvent* aMouseEvent);

  // This method is called when editor actually gets focus.
  // aContent must be:
  //   If the editor is for <input> or <textarea>, the element.
  //   If the editor is for contenteditable, the active editinghost.
  //   If the editor is for designMode, nullptr.
  static void OnFocusInEditor(nsPresContext* aPresContext, nsIContent* aContent,
                              EditorBase& aEditorBase);

  // This method is called when the editor is initialized.
  static void OnEditorInitialized(EditorBase& aEditorBase);

  // This method is called when the editor is (might be temporarily) being
  // destroyed.
  static void OnEditorDestroying(EditorBase& aEditorBase);

  /**
   * All composition events must be dispatched via DispatchCompositionEvent()
   * for storing the composition target and ensuring a set of composition
   * events must be fired the stored target.  If the stored composition event
   * target is destroying, this removes the stored composition automatically.
   */
  static void DispatchCompositionEvent(
      nsINode* aEventTargetNode, nsPresContext* aPresContext,
      BrowserParent* aBrowserParent, WidgetCompositionEvent* aCompositionEvent,
      nsEventStatus* aStatus, EventDispatchingCallback* aCallBack,
      bool aIsSynthesized = false);

  /**
   * All selection events must be handled via HandleSelectionEvent()
   * because they must be handled by same target as composition events when
   * there is a composition.
   */
  MOZ_CAN_RUN_SCRIPT
  static void HandleSelectionEvent(nsPresContext* aPresContext,
                                   nsIContent* aEventTargetContent,
                                   WidgetSelectionEvent* aSelectionEvent);

  /**
   * This is called when PresShell ignores a composition event due to not safe
   * to dispatch events.
   */
  static void OnCompositionEventDiscarded(
      WidgetCompositionEvent* aCompositionEvent);

  /**
   * Get TextComposition from widget.
   */
  static already_AddRefed<TextComposition> GetTextCompositionFor(
      nsIWidget* aWidget);

  /**
   * Returns TextComposition instance for the event.
   */
  static already_AddRefed<TextComposition> GetTextCompositionFor(
      const WidgetCompositionEvent* aCompositionEvent);

  /**
   * Returns TextComposition instance for the pres context.
   * Be aware, even if another pres context which shares native IME context with
   * specified pres context has composition, this returns nullptr.
   */
  static already_AddRefed<TextComposition> GetTextCompositionFor(
      nsPresContext* aPresContext);

  /**
   * Send a notification to IME.  It depends on the IME or platform spec what
   * will occur (or not occur).
   */
  static nsresult NotifyIME(const IMENotification& aNotification,
                            nsIWidget* aWidget,
                            BrowserParent* aBrowserParent = nullptr);
  static nsresult NotifyIME(IMEMessage aMessage, nsIWidget* aWidget,
                            BrowserParent* aBrowserParent = nullptr);
  static nsresult NotifyIME(IMEMessage aMessage, nsPresContext* aPresContext,
                            BrowserParent* aBrowserParent = nullptr);

  static nsINode* GetRootEditableNode(nsPresContext* aPresContext,
                                      nsIContent* aContent);

  /**
   * Returns active IMEContentObserver but may be nullptr if focused content
   * isn't editable or focus in a remote process.
   */
  static IMEContentObserver* GetActiveContentObserver();

 protected:
  static nsresult OnChangeFocusInternal(nsPresContext* aPresContext,
                                        nsIContent* aContent,
                                        InputContextAction aAction);
  static void SetIMEState(const IMEState& aState, nsPresContext* aPresContext,
                          nsIContent* aContent, nsIWidget* aWidget,
                          InputContextAction aAction,
                          InputContext::Origin aOrigin);
  static void SetInputContext(nsIWidget* aWidget,
                              const InputContext& aInputContext,
                              const InputContextAction& aAction);
  static IMEState GetNewIMEState(nsPresContext* aPresContext,
                                 nsIContent* aContent);

  static void EnsureTextCompositionArray();
  static void CreateIMEContentObserver(EditorBase* aEditorBase);
  static void DestroyIMEContentObserver();

  static bool IsEditable(nsINode* node);

  static bool IsIMEObserverNeeded(const IMEState& aState);

  static nsIContent* GetRootContent(nsPresContext* aPresContext);

  /**
   * CanHandleWith() returns false if aPresContext is nullptr or it's destroyed.
   */
  static bool CanHandleWith(nsPresContext* aPresContext);

  /**
   * ResetActiveChildInputContext() resets sActiveChildInputContext.
   * So, HasActiveChildSetInputContext() will return false until a remote
   * process gets focus and set input context.
   */
  static void ResetActiveChildInputContext();

  /**
   * HasActiveChildSetInputContext() returns true if a remote tab has focus
   * and it has already set input context.  Otherwise, returns false.
   */
  static bool HasActiveChildSetInputContext();

  // sContent and sPresContext are the focused content and PresContext.  If a
  // document has focus but there is no focused element, sContent may be
  // nullptr.
  static StaticRefPtr<nsIContent> sContent;
  static StaticRefPtr<nsPresContext> sPresContext;
  // sWidget is cache for the root widget of sPresContext.  Even afer
  // sPresContext has gone, we need to clean up some IME state on the widget
  // if the widget is available.
  static nsIWidget* sWidget;
  // sFocusedIMEBrowserParent is the tab parent, which send "focus" notification
  // to sFocusedIMEWidget (and didn't yet sent "blur" notification).
  static nsIWidget* sFocusedIMEWidget;
  static StaticRefPtr<BrowserParent> sFocusedIMEBrowserParent;
  // sActiveInputContextWidget is the last widget whose SetInputContext() is
  // called.  This is important to reduce sync IPC cost with parent process.
  // If IMEStateManager set input context to different widget, PuppetWidget can
  // return cached input context safely.
  static nsIWidget* sActiveInputContextWidget;
  // sActiveIMEContentObserver points to the currently active
  // IMEContentObserver.  This is null if there is no focused editor.
  static StaticRefPtr<IMEContentObserver> sActiveIMEContentObserver;

  // All active compositions in the process are stored by this array.
  // When you get an item of this array and use it, please be careful.
  // The instances in this array can be destroyed automatically if you do
  // something to cause committing or canceling the composition.
  static TextCompositionArray* sTextCompositions;

  // Origin type of current process.
  static InputContext::Origin sOrigin;

  // sActiveChildInputContext is valid only when BrowserParent::GetFocused() is
  // not nullptr.  This stores last information of input context in the remote
  // process of BrowserParent::GetFocused().  I.e., they are set when
  // SetInputContextForChildProcess() is called.  This is necessary for
  // restoring IME state when menu keyboard listener is uninstalled.
  static InputContext sActiveChildInputContext;

  // sInstalledMenuKeyboardListener is true if menu keyboard listener is
  // installed in the process.
  static bool sInstalledMenuKeyboardListener;

  static bool sIsGettingNewIMEState;
  static bool sCheckForIMEUnawareWebApps;

  class MOZ_STACK_CLASS GettingNewIMEStateBlocker final {
   public:
    GettingNewIMEStateBlocker()
        : mOldValue(IMEStateManager::sIsGettingNewIMEState) {
      IMEStateManager::sIsGettingNewIMEState = true;
    }
    ~GettingNewIMEStateBlocker() {
      IMEStateManager::sIsGettingNewIMEState = mOldValue;
    }

   private:
    bool mOldValue;
  };
};

}  // namespace mozilla

#endif  // mozilla_IMEStateManager_h_
