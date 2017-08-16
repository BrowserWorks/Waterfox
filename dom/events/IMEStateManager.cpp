/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Logging.h"

#include "mozilla/IMEStateManager.h"

#include "mozilla/Attributes.h"
#include "mozilla/EditorBase.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/EventStates.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/Preferences.h"
#include "mozilla/Services.h"
#include "mozilla/SizePrintfMacros.h"
#include "mozilla/TextComposition.h"
#include "mozilla/TextEvents.h"
#include "mozilla/Unused.h"
#include "mozilla/dom/HTMLFormElement.h"
#include "mozilla/dom/TabParent.h"

#include "HTMLInputElement.h"
#include "IMEContentObserver.h"

#include "nsCOMPtr.h"
#include "nsContentUtils.h"
#include "nsIContent.h"
#include "nsIDocument.h"
#include "nsIDOMMouseEvent.h"
#include "nsIForm.h"
#include "nsIFormControl.h"
#include "nsINode.h"
#include "nsIObserverService.h"
#include "nsIPresShell.h"
#include "nsISelection.h"
#include "nsISupports.h"
#include "nsPresContext.h"

namespace mozilla {

using namespace dom;
using namespace widget;

/**
 * When a method is called, log its arguments and/or related static variables
 * with LogLevel::Info.  However, if it puts too many logs like
 * OnDestroyPresContext(), should long only when the method actually does
 * something. In this case, the log should start with "<method name>".
 *
 * When a method quits due to unexpected situation, log the reason with
 * LogLevel::Error.  In this case, the log should start with
 * "<method name>(), FAILED".  The indent makes the log look easier.
 *
 * When a method does something only in some situations and it may be important
 * for debug, log the information with LogLevel::Debug.  In this case, the log
 * should start with "  <method name>(),".
 */
LazyLogModule sISMLog("IMEStateManager");

static const char*
GetBoolName(bool aBool)
{
  return aBool ? "true" : "false";
}

static const char*
GetActionCauseName(InputContextAction::Cause aCause)
{
  switch (aCause) {
    case InputContextAction::CAUSE_UNKNOWN:
      return "CAUSE_UNKNOWN";
    case InputContextAction::CAUSE_UNKNOWN_CHROME:
      return "CAUSE_UNKNOWN_CHROME";
    case InputContextAction::CAUSE_KEY:
      return "CAUSE_KEY";
    case InputContextAction::CAUSE_MOUSE:
      return "CAUSE_MOUSE";
    case InputContextAction::CAUSE_TOUCH:
      return "CAUSE_TOUCH";
    default:
      return "illegal value";
  }
}

static const char*
GetActionFocusChangeName(InputContextAction::FocusChange aFocusChange)
{
  switch (aFocusChange) {
    case InputContextAction::FOCUS_NOT_CHANGED:
      return "FOCUS_NOT_CHANGED";
    case InputContextAction::GOT_FOCUS:
      return "GOT_FOCUS";
    case InputContextAction::LOST_FOCUS:
      return "LOST_FOCUS";
    case InputContextAction::MENU_GOT_PSEUDO_FOCUS:
      return "MENU_GOT_PSEUDO_FOCUS";
    case InputContextAction::MENU_LOST_PSEUDO_FOCUS:
      return "MENU_LOST_PSEUDO_FOCUS";
    default:
      return "illegal value";
  }
}

static const char*
GetIMEStateEnabledName(IMEState::Enabled aEnabled)
{
  switch (aEnabled) {
    case IMEState::DISABLED:
      return "DISABLED";
    case IMEState::ENABLED:
      return "ENABLED";
    case IMEState::PASSWORD:
      return "PASSWORD";
    case IMEState::PLUGIN:
      return "PLUGIN";
    default:
      return "illegal value";
  }
}

static const char*
GetIMEStateSetOpenName(IMEState::Open aOpen)
{
  switch (aOpen) {
    case IMEState::DONT_CHANGE_OPEN_STATE:
      return "DONT_CHANGE_OPEN_STATE";
    case IMEState::OPEN:
      return "OPEN";
    case IMEState::CLOSED:
      return "CLOSED";
    default:
      return "illegal value";
  }
}

StaticRefPtr<nsIContent> IMEStateManager::sContent;
StaticRefPtr<nsPresContext> IMEStateManager::sPresContext;
nsIWidget* IMEStateManager::sWidget = nullptr;
nsIWidget* IMEStateManager::sFocusedIMEWidget = nullptr;
nsIWidget* IMEStateManager::sActiveInputContextWidget = nullptr;
StaticRefPtr<TabParent> IMEStateManager::sActiveTabParent;
StaticRefPtr<IMEContentObserver> IMEStateManager::sActiveIMEContentObserver;
TextCompositionArray* IMEStateManager::sTextCompositions = nullptr;
bool IMEStateManager::sInstalledMenuKeyboardListener = false;
bool IMEStateManager::sIsGettingNewIMEState = false;
bool IMEStateManager::sCheckForIMEUnawareWebApps = false;
bool IMEStateManager::sInputModeSupported = false;
bool IMEStateManager::sRemoteHasFocus = false;

// static
void
IMEStateManager::Init()
{
  Preferences::AddBoolVarCache(
    &sCheckForIMEUnawareWebApps,
    "intl.ime.hack.on_ime_unaware_apps.fire_key_events_for_composition",
    false);

  Preferences::AddBoolVarCache(
    &sInputModeSupported,
    "dom.forms.inputmode",
    false);
}

// static
void
IMEStateManager::Shutdown()
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("Shutdown(), sTextCompositions=0x%p, sTextCompositions->Length()=%" PRIuSIZE,
     sTextCompositions, sTextCompositions ? sTextCompositions->Length() : 0));

  MOZ_ASSERT(!sTextCompositions || !sTextCompositions->Length());
  delete sTextCompositions;
  sTextCompositions = nullptr;
}

// static
void
IMEStateManager::OnTabParentDestroying(TabParent* aTabParent)
{
  if (sActiveTabParent != aTabParent) {
    return;
  }
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnTabParentDestroying(aTabParent=0x%p), "
     "The active TabParent is being destroyed", aTabParent));

  // The active remote process might have crashed.
  sActiveTabParent = nullptr;

  // TODO: Need to cancel composition without TextComposition and make
  //       disable IME.
}

// static
void
IMEStateManager::WidgetDestroyed(nsIWidget* aWidget)
{
  if (sWidget == aWidget) {
    sWidget = nullptr;
  }
  if (sFocusedIMEWidget == aWidget) {
    sFocusedIMEWidget = nullptr;
  }
  if (sActiveInputContextWidget == aWidget) {
    sActiveInputContextWidget = nullptr;
  }
}

// static
void
IMEStateManager::StopIMEStateManagement()
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("StopIMEStateManagement()"));

  // NOTE: Don't set input context from here since this has already lost
  //       the rights to change input context.

  if (sTextCompositions && sPresContext) {
    NotifyIME(REQUEST_TO_COMMIT_COMPOSITION, sPresContext);
  }
  sActiveInputContextWidget = nullptr;
  sPresContext = nullptr;
  sContent = nullptr;
  sActiveTabParent = nullptr;
  DestroyIMEContentObserver();
}

// static
void
IMEStateManager::MaybeStartOffsetUpdatedInChild(nsIWidget* aWidget,
                                                uint32_t aStartOffset)
{
  if (NS_WARN_IF(!sTextCompositions)) {
    MOZ_LOG(sISMLog, LogLevel::Warning,
      ("MaybeStartOffsetUpdatedInChild(aWidget=0x%p, aStartOffset=%u), "
       "called when there is no composition", aWidget, aStartOffset));
    return;
  }

  RefPtr<TextComposition> composition = GetTextCompositionFor(aWidget);
  if (NS_WARN_IF(!composition)) {
    MOZ_LOG(sISMLog, LogLevel::Warning,
      ("MaybeStartOffsetUpdatedInChild(aWidget=0x%p, aStartOffset=%u), "
       "called when there is no composition", aWidget, aStartOffset));
    return;
  }

  if (composition->NativeOffsetOfStartComposition() == aStartOffset) {
    return;
  }

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("MaybeStartOffsetUpdatedInChild(aWidget=0x%p, aStartOffset=%u), "
     "old offset=%u",
     aWidget, aStartOffset, composition->NativeOffsetOfStartComposition()));
  composition->OnStartOffsetUpdatedInChild(aStartOffset);
}

// static
nsresult
IMEStateManager::OnDestroyPresContext(nsPresContext* aPresContext)
{
  NS_ENSURE_ARG_POINTER(aPresContext);

  // First, if there is a composition in the aPresContext, clean up it.
  if (sTextCompositions) {
    TextCompositionArray::index_type i =
      sTextCompositions->IndexOf(aPresContext);
    if (i != TextCompositionArray::NoIndex) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  OnDestroyPresContext(), "
         "removing TextComposition instance from the array (index=%" PRIuSIZE ")", i));
      // there should be only one composition per presContext object.
      sTextCompositions->ElementAt(i)->Destroy();
      sTextCompositions->RemoveElementAt(i);
      if (sTextCompositions->IndexOf(aPresContext) !=
            TextCompositionArray::NoIndex) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  OnDestroyPresContext(), FAILED to remove "
           "TextComposition instance from the array"));
        MOZ_CRASH("Failed to remove TextComposition instance from the array");
      }
    }
  }

  if (aPresContext != sPresContext) {
    return NS_OK;
  }

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnDestroyPresContext(aPresContext=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sTextCompositions=0x%p",
     aPresContext, sPresContext.get(), sContent.get(), sTextCompositions));

  DestroyIMEContentObserver();

  if (sWidget) {
    IMEState newState = GetNewIMEState(sPresContext, nullptr);
    InputContextAction action(InputContextAction::CAUSE_UNKNOWN,
                              InputContextAction::LOST_FOCUS);
    SetIMEState(newState, nullptr, sWidget, action);
  }
  sWidget = nullptr;
  sContent = nullptr;
  sPresContext = nullptr;
  sActiveTabParent = nullptr;
  return NS_OK;
}

// static
nsresult
IMEStateManager::OnRemoveContent(nsPresContext* aPresContext,
                                 nsIContent* aContent)
{
  NS_ENSURE_ARG_POINTER(aPresContext);

  // First, if there is a composition in the aContent, clean up it.
  if (sTextCompositions) {
    RefPtr<TextComposition> compositionInContent =
      sTextCompositions->GetCompositionInContent(aPresContext, aContent);

    if (compositionInContent) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  OnRemoveContent(), "
         "composition is in the content"));

      // Try resetting the native IME state.  Be aware, typically, this method
      // is called during the content being removed.  Then, the native
      // composition events which are caused by following APIs are ignored due
      // to unsafe to run script (in PresShell::HandleEvent()).
      nsresult rv =
        compositionInContent->NotifyIME(REQUEST_TO_CANCEL_COMPOSITION);
      if (NS_FAILED(rv)) {
        compositionInContent->NotifyIME(REQUEST_TO_COMMIT_COMPOSITION);
      }
    }
  }

  if (!sPresContext || !sContent ||
      !nsContentUtils::ContentIsDescendantOf(sContent, aContent)) {
    return NS_OK;
  }

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnRemoveContent(aPresContext=0x%p, aContent=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sTextCompositions=0x%p",
     aPresContext, aContent, sPresContext.get(), sContent.get(), sTextCompositions));

  DestroyIMEContentObserver();

  // Current IME transaction should commit
  if (sWidget) {
    IMEState newState = GetNewIMEState(sPresContext, nullptr);
    InputContextAction action(InputContextAction::CAUSE_UNKNOWN,
                              InputContextAction::LOST_FOCUS);
    SetIMEState(newState, nullptr, sWidget, action);
  }

  sWidget = nullptr;
  sContent = nullptr;
  sPresContext = nullptr;
  sActiveTabParent = nullptr;

  return NS_OK;
}

// static
bool
IMEStateManager::CanHandleWith(nsPresContext* aPresContext)
{
  return aPresContext &&
         aPresContext->GetPresShell() &&
         !aPresContext->PresShell()->IsDestroying();
}

// static
nsresult
IMEStateManager::OnChangeFocus(nsPresContext* aPresContext,
                               nsIContent* aContent,
                               InputContextAction::Cause aCause)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnChangeFocus(aPresContext=0x%p, aContent=0x%p, aCause=%s)",
     aPresContext, aContent, GetActionCauseName(aCause)));

  InputContextAction action(aCause);
  return OnChangeFocusInternal(aPresContext, aContent, action);
}

// static
nsresult
IMEStateManager::OnChangeFocusInternal(nsPresContext* aPresContext,
                                       nsIContent* aContent,
                                       InputContextAction aAction)
{
  RefPtr<TabParent> newTabParent = TabParent::GetFrom(aContent);

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnChangeFocusInternal(aPresContext=0x%p (available: %s), "
     "aContent=0x%p (TabParent=0x%p), aAction={ mCause=%s, mFocusChange=%s }), "
     "sPresContext=0x%p (available: %s), sContent=0x%p, "
     "sWidget=0x%p (available: %s), sActiveTabParent=0x%p, "
     "sActiveIMEContentObserver=0x%p, sInstalledMenuKeyboardListener=%s",
     aPresContext, GetBoolName(CanHandleWith(aPresContext)), aContent,
     newTabParent.get(), GetActionCauseName(aAction.mCause),
     GetActionFocusChangeName(aAction.mFocusChange),
     sPresContext.get(), GetBoolName(CanHandleWith(sPresContext)),
     sContent.get(), sWidget, GetBoolName(sWidget && !sWidget->Destroyed()),
     sActiveTabParent.get(), sActiveIMEContentObserver.get(),
     GetBoolName(sInstalledMenuKeyboardListener)));

  // If new aPresShell has been destroyed, this should handle the focus change
  // as nobody is getting focus.
  if (NS_WARN_IF(aPresContext && !CanHandleWith(aPresContext))) {
    MOZ_LOG(sISMLog, LogLevel::Warning,
      ("  OnChangeFocusInternal(), called with destroyed PresShell, "
       "handling this call as nobody getting focus"));
    aPresContext = nullptr;
    aContent = nullptr;
  }

  nsCOMPtr<nsIWidget> oldWidget = sWidget;
  nsCOMPtr<nsIWidget> newWidget =
    aPresContext ? aPresContext->GetRootWidget() : nullptr;
  bool focusActuallyChanging =
    (sContent != aContent || sPresContext != aPresContext ||
     oldWidget != newWidget || sActiveTabParent != newTabParent);

  if (oldWidget && focusActuallyChanging) {
    // If we're deactivating, we shouldn't commit composition forcibly because
    // the user may want to continue the composition.
    if (aPresContext) {
      NotifyIME(REQUEST_TO_COMMIT_COMPOSITION, oldWidget);
    }
  }

  if (sActiveIMEContentObserver &&
      (aPresContext || !sActiveIMEContentObserver->KeepAliveDuringDeactive()) &&
      !sActiveIMEContentObserver->IsManaging(aPresContext, aContent)) {
    DestroyIMEContentObserver();
  }

  if (!aPresContext) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnChangeFocusInternal(), "
       "no nsPresContext is being activated"));
    return NS_OK;
  }

  nsIContentParent* currentContentParent =
    sActiveTabParent ? sActiveTabParent->Manager() : nullptr;
  nsIContentParent* newContentParent =
    newTabParent ? newTabParent->Manager() : nullptr;
  if (sActiveTabParent && currentContentParent != newContentParent) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnChangeFocusInternal(), notifying previous "
       "focused child process of parent process or another child process "
       "getting focus"));
    Unused << sActiveTabParent->SendStopIMEStateManagement();
  }

  if (NS_WARN_IF(!newWidget)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  OnChangeFocusInternal(), FAILED due to "
       "no widget to manage its IME state"));
    return NS_OK;
  }

  // Update the cached widget since root view of the presContext may be
  // changed to different view.
  sWidget = newWidget;

  // If a child process has focus, we should disable IME state until the child
  // process actually gets focus because if user types keys before that they
  // are handled by IME.
  IMEState newState =
    newTabParent ? IMEState(IMEState::DISABLED) :
                   GetNewIMEState(aPresContext, aContent);
  bool setIMEState = true;

  if (newTabParent) {
    if (aAction.mFocusChange == InputContextAction::MENU_GOT_PSEUDO_FOCUS ||
        aAction.mFocusChange == InputContextAction::MENU_LOST_PSEUDO_FOCUS) {
      // XXX When menu keyboard listener is being uninstalled, IME state needs
      //     to be restored by the child process asynchronously.  Therefore,
      //     some key events which are fired immediately after closing menu
      //     may not be handled by IME.
      Unused << newTabParent->
        SendMenuKeyboardListenerInstalled(sInstalledMenuKeyboardListener);
      setIMEState = sInstalledMenuKeyboardListener;
    } else if (focusActuallyChanging) {
      InputContext context = newWidget->GetInputContext();
      if (context.mIMEState.mEnabled == IMEState::DISABLED) {
        setIMEState = false;
        MOZ_LOG(sISMLog, LogLevel::Debug,
          ("  OnChangeFocusInternal(), doesn't set IME "
           "state because focused element (or document) is in a child process "
           "and the IME state is already disabled"));
      } else {
        MOZ_LOG(sISMLog, LogLevel::Debug,
          ("  OnChangeFocusInternal(), will disable IME "
           "until new focused element (or document) in the child process "
           "will get focus actually"));
      }
    } else {
      // When focus is NOT changed actually, we shouldn't set IME state since
      // that means that the window is being activated and the child process
      // may have composition.  Then, we shouldn't commit the composition with
      // making IME state disabled.
      setIMEState = false; 
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  OnChangeFocusInternal(), doesn't set IME "
         "state because focused element (or document) is already in the child "
         "process"));
    }
  }

  if (setIMEState) {
    if (!focusActuallyChanging) {
      // actual focus isn't changing, but if IME enabled state is changing,
      // we should do it.
      InputContext context = newWidget->GetInputContext();
      if (context.mIMEState.mEnabled == newState.mEnabled) {
        MOZ_LOG(sISMLog, LogLevel::Debug,
          ("  OnChangeFocusInternal(), "
           "neither focus nor IME state is changing"));
        return NS_OK;
      }
      aAction.mFocusChange = InputContextAction::FOCUS_NOT_CHANGED;

      // Even if focus isn't changing actually, we should commit current
      // composition here since the IME state is changing.
      if (sPresContext && oldWidget && !focusActuallyChanging) {
        NotifyIME(REQUEST_TO_COMMIT_COMPOSITION, oldWidget);
      }
    } else if (aAction.mFocusChange == InputContextAction::FOCUS_NOT_CHANGED) {
      // If aContent isn't null or aContent is null but editable, somebody gets
      // focus.
      bool gotFocus = aContent || (newState.mEnabled == IMEState::ENABLED);
      aAction.mFocusChange =
        gotFocus ? InputContextAction::GOT_FOCUS :
                   InputContextAction::LOST_FOCUS;
    }

    // Update IME state for new focus widget
    SetIMEState(newState, aContent, newWidget, aAction);
  }

  sActiveTabParent = newTabParent;
  sPresContext = aPresContext;
  sContent = aContent;

  // Don't call CreateIMEContentObserver() here except when a plugin gets
  // focus because it will be called from the focus event handler of focused
  // editor.
  if (newState.mEnabled == IMEState::PLUGIN) {
    CreateIMEContentObserver(nullptr);
    if (sActiveIMEContentObserver) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  OnChangeFocusInternal(), an "
         "IMEContentObserver instance is created for plugin and trying to "
         "flush its pending notifications..."));
      sActiveIMEContentObserver->TryToFlushPendingNotifications();
    }
  }

  return NS_OK;
}

// static
void
IMEStateManager::OnInstalledMenuKeyboardListener(bool aInstalling)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnInstalledMenuKeyboardListener(aInstalling=%s), "
     "sInstalledMenuKeyboardListener=%s",
     GetBoolName(aInstalling), GetBoolName(sInstalledMenuKeyboardListener)));

  sInstalledMenuKeyboardListener = aInstalling;

  InputContextAction action(InputContextAction::CAUSE_UNKNOWN,
    aInstalling ? InputContextAction::MENU_GOT_PSEUDO_FOCUS :
                  InputContextAction::MENU_LOST_PSEUDO_FOCUS);
  OnChangeFocusInternal(sPresContext, sContent, action);
}

// static
bool
IMEStateManager::OnMouseButtonEventInEditor(nsPresContext* aPresContext,
                                            nsIContent* aContent,
                                            WidgetMouseEvent* aMouseEvent)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnMouseButtonEventInEditor(aPresContext=0x%p, "
     "aContent=0x%p, aMouseEvent=0x%p), sPresContext=0x%p, sContent=0x%p",
     aPresContext, aContent, aMouseEvent, sPresContext.get(), sContent.get()));

  if (NS_WARN_IF(!aMouseEvent)) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnMouseButtonEventInEditor(), aMouseEvent is nullptr"));
    return false;
  }

  if (sPresContext != aPresContext || sContent != aContent) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnMouseButtonEventInEditor(), "
       "the mouse event isn't fired on the editor managed by ISM"));
    return false;
  }

  if (!sActiveIMEContentObserver) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnMouseButtonEventInEditor(), "
       "there is no active IMEContentObserver"));
    return false;
  }

  if (!sActiveIMEContentObserver->IsManaging(aPresContext, aContent)) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnMouseButtonEventInEditor(), "
       "the active IMEContentObserver isn't managing the editor"));
    return false;
  }

  bool consumed =
    sActiveIMEContentObserver->OnMouseButtonEvent(aPresContext, aMouseEvent);

  if (MOZ_LOG_TEST(sISMLog, LogLevel::Info)) {
    nsAutoString eventType;
    MOZ_LOG(sISMLog, LogLevel::Info,
      ("  OnMouseButtonEventInEditor(), "
       "mouse event (mMessage=%s, button=%d) is %s",
       ToChar(aMouseEvent->mMessage), aMouseEvent->button,
       consumed ? "consumed" : "not consumed"));
  }

  return consumed;
}

// static
void
IMEStateManager::OnClickInEditor(nsPresContext* aPresContext,
                                 nsIContent* aContent,
                                 const WidgetMouseEvent* aMouseEvent)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnClickInEditor(aPresContext=0x%p, aContent=0x%p, aMouseEvent=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sWidget=0x%p (available: %s)",
     aPresContext, aContent, aMouseEvent, sPresContext.get(), sContent.get(),
     sWidget, GetBoolName(sWidget && !sWidget->Destroyed())));

  if (NS_WARN_IF(!aMouseEvent)) {
    return;
  }

  if (sPresContext != aPresContext || sContent != aContent ||
      NS_WARN_IF(!sPresContext) || NS_WARN_IF(!sWidget) ||
      NS_WARN_IF(sWidget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnClickInEditor(), "
       "the mouse event isn't fired on the editor managed by ISM"));
    return;
  }

  nsCOMPtr<nsIWidget> widget(sWidget);

  MOZ_ASSERT(!sPresContext->GetRootWidget() ||
             sPresContext->GetRootWidget() == widget);

  if (!aMouseEvent->IsTrusted()) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnClickInEditor(), "
       "the mouse event isn't a trusted event"));
    return; // ignore untrusted event.
  }

  if (aMouseEvent->button) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnClickInEditor(), "
       "the mouse event isn't a left mouse button event"));
    return; // not a left click event.
  }

  if (aMouseEvent->mClickCount != 1) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnClickInEditor(), "
       "the mouse event isn't a single click event"));
    return; // should notify only first click event.
  }

  InputContextAction::Cause cause =
    aMouseEvent->inputSource == nsIDOMMouseEvent::MOZ_SOURCE_TOUCH ?
      InputContextAction::CAUSE_TOUCH : InputContextAction::CAUSE_MOUSE;

  InputContextAction action(cause, InputContextAction::FOCUS_NOT_CHANGED);
  IMEState newState = GetNewIMEState(aPresContext, aContent);
  SetIMEState(newState, aContent, widget, action);
}

// static
void
IMEStateManager::OnFocusInEditor(nsPresContext* aPresContext,
                                 nsIContent* aContent,
                                 nsIEditor* aEditor)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnFocusInEditor(aPresContext=0x%p, aContent=0x%p, aEditor=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sActiveIMEContentObserver=0x%p",
     aPresContext, aContent, aEditor, sPresContext.get(), sContent.get(),
     sActiveIMEContentObserver.get()));

  if (sPresContext != aPresContext || sContent != aContent) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnFocusInEditor(), "
       "an editor not managed by ISM gets focus"));
    return;
  }

  // If the IMEContentObserver instance isn't managing the editor actually,
  // we need to recreate the instance.
  if (sActiveIMEContentObserver) {
    if (sActiveIMEContentObserver->IsManaging(aPresContext, aContent)) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  OnFocusInEditor(), "
         "the editor is already being managed by sActiveIMEContentObserver"));
      return;
    }
    DestroyIMEContentObserver();
  }

  CreateIMEContentObserver(aEditor);

  // Let's flush the focus notification now.
  if (sActiveIMEContentObserver) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  OnFocusInEditor(), new IMEContentObserver is "
       "created, trying to flush pending notifications..."));
    sActiveIMEContentObserver->TryToFlushPendingNotifications();
  }
}

// static
void
IMEStateManager::OnEditorInitialized(nsIEditor* aEditor)
{
  if (!sActiveIMEContentObserver ||
      sActiveIMEContentObserver->GetEditor() != aEditor) {
    return;
  }

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnEditorInitialized(aEditor=0x%p)",
     aEditor));

  sActiveIMEContentObserver->UnsuppressNotifyingIME();
}

// static
void
IMEStateManager::OnEditorDestroying(nsIEditor* aEditor)
{
  if (!sActiveIMEContentObserver ||
      sActiveIMEContentObserver->GetEditor() != aEditor) {
    return;
  }

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnEditorDestroying(aEditor=0x%p)",
     aEditor));

  // The IMEContentObserver shouldn't notify IME of anything until reframing
  // is finished.
  sActiveIMEContentObserver->SuppressNotifyingIME();
}

// static
void
IMEStateManager::UpdateIMEState(const IMEState& aNewIMEState,
                                nsIContent* aContent,
                                EditorBase& aEditorBase)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("UpdateIMEState(aNewIMEState={ mEnabled=%s, "
     "mOpen=%s }, aContent=0x%p, aEditorBase=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sWidget=0x%p (available: %s), "
     "sActiveIMEContentObserver=0x%p, sIsGettingNewIMEState=%s",
     GetIMEStateEnabledName(aNewIMEState.mEnabled),
     GetIMEStateSetOpenName(aNewIMEState.mOpen), aContent, &aEditorBase,
     sPresContext.get(), sContent.get(),
     sWidget, GetBoolName(sWidget && !sWidget->Destroyed()),
     sActiveIMEContentObserver.get(),
     GetBoolName(sIsGettingNewIMEState)));

  if (sIsGettingNewIMEState) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  UpdateIMEState(), "
       "does nothing because of called while getting new IME state"));
    return;
  }

  nsCOMPtr<nsIPresShell> presShell = aEditorBase.GetPresShell();
  if (NS_WARN_IF(!presShell)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  UpdateIMEState(), FAILED due to "
       "editor doesn't have PresShell"));
    return;
  }

  nsPresContext* presContext = presShell->GetPresContext();
  if (NS_WARN_IF(!presContext)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  UpdateIMEState(), FAILED due to "
       "editor doesn't have PresContext"));
    return;
  }

  // IMEStateManager::UpdateIMEState() should be called after
  // IMEStateManager::OnChangeFocus() is called for setting focus to aContent
  // and aEditorBase.  However, when aEditorBase is an HTMLEditor, this may be
  // called by nsIEditor::PostCreate() before IMEStateManager::OnChangeFocus().
  // Similarly, when aEditorBase is a TextEditor, this may be called by
  // nsIEditor::SetFlags().  In such cases, this method should do nothing
  // because input context should be updated when
  // IMEStateManager::OnChangeFocus() is called later.
  if (sPresContext != presContext) {
    MOZ_LOG(sISMLog, LogLevel::Warning,
      ("  UpdateIMEState(), does nothing due to "
       "the editor hasn't managed by IMEStateManager yet"));
    return;
  }

  // If IMEStateManager doesn't manage any document, this cannot update IME
  // state of any widget.
  if (NS_WARN_IF(!sPresContext)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  UpdateIMEState(), FAILED due to "
       "no managing nsPresContext"));
    return;
  }

  if (NS_WARN_IF(!sWidget) || NS_WARN_IF(sWidget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  UpdateIMEState(), FAILED due to "
       "the widget for the managing nsPresContext has gone"));
    return;
  }

  nsCOMPtr<nsIWidget> widget(sWidget);

  MOZ_ASSERT(!sPresContext->GetRootWidget() ||
             sPresContext->GetRootWidget() == widget);

  // Even if there is active IMEContentObserver, it may not be observing the
  // editor with current editable root content due to reframed.  In such case,
  // We should try to reinitialize the IMEContentObserver.
  if (sActiveIMEContentObserver && IsIMEObserverNeeded(aNewIMEState)) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  UpdateIMEState(), try to reinitialize the "
       "active IMEContentObserver"));
    RefPtr<IMEContentObserver> contentObserver = sActiveIMEContentObserver;
    if (!contentObserver->MaybeReinitialize(widget, sPresContext,
                                            aContent, &aEditorBase)) {
      MOZ_LOG(sISMLog, LogLevel::Error,
        ("  UpdateIMEState(), failed to reinitialize the "
         "active IMEContentObserver"));
    }
    if (NS_WARN_IF(widget->Destroyed())) {
      MOZ_LOG(sISMLog, LogLevel::Error,
        ("  UpdateIMEState(), widget has gone during reinitializing the "
         "active IMEContentObserver"));
      return;
    }
  }

  // If there is no active IMEContentObserver or it isn't observing the
  // editor correctly, we should recreate it.
  bool createTextStateManager =
    (!sActiveIMEContentObserver ||
     !sActiveIMEContentObserver->IsManaging(sPresContext, aContent));

  bool updateIMEState =
    (widget->GetInputContext().mIMEState.mEnabled != aNewIMEState.mEnabled);
  if (NS_WARN_IF(widget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  UpdateIMEState(), widget has gone during getting input context"));
    return;
  }

  if (updateIMEState) {
    // commit current composition before modifying IME state.
    NotifyIME(REQUEST_TO_COMMIT_COMPOSITION, widget);
    if (NS_WARN_IF(widget->Destroyed())) {
      MOZ_LOG(sISMLog, LogLevel::Error,
        ("  UpdateIMEState(), widget has gone during committing composition"));
      return;
    }
  }

  if (createTextStateManager) {
    DestroyIMEContentObserver();
  }

  if (updateIMEState) {
    InputContextAction action(InputContextAction::CAUSE_UNKNOWN,
                              InputContextAction::FOCUS_NOT_CHANGED);
    SetIMEState(aNewIMEState, aContent, widget, action);
    if (NS_WARN_IF(widget->Destroyed())) {
      MOZ_LOG(sISMLog, LogLevel::Error,
        ("  UpdateIMEState(), widget has gone during setting input context"));
      return;
    }
  }

  if (createTextStateManager) {
    // XXX In this case, it might not be enough safe to notify IME of anything.
    //     So, don't try to flush pending notifications of IMEContentObserver
    //     here.
    CreateIMEContentObserver(&aEditorBase);
  }
}

// static
IMEState
IMEStateManager::GetNewIMEState(nsPresContext* aPresContext,
                                nsIContent*    aContent)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("GetNewIMEState(aPresContext=0x%p, aContent=0x%p), "
     "sInstalledMenuKeyboardListener=%s",
     aPresContext, aContent, GetBoolName(sInstalledMenuKeyboardListener)));

  if (!CanHandleWith(aPresContext)) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  GetNewIMEState() returns DISABLED because "
       "the nsPresContext has been destroyed"));
    return IMEState(IMEState::DISABLED);
  }

  // On Printing or Print Preview, we don't need IME.
  if (aPresContext->Type() == nsPresContext::eContext_PrintPreview ||
      aPresContext->Type() == nsPresContext::eContext_Print) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  GetNewIMEState() returns DISABLED because "
       "the nsPresContext is for print or print preview"));
    return IMEState(IMEState::DISABLED);
  }

  if (sInstalledMenuKeyboardListener) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  GetNewIMEState() returns DISABLED because "
       "menu keyboard listener was installed"));
    return IMEState(IMEState::DISABLED);
  }

  if (!aContent) {
    // Even if there are no focused content, the focused document might be
    // editable, such case is design mode.
    nsIDocument* doc = aPresContext->Document();
    if (doc && doc->HasFlag(NODE_IS_EDITABLE)) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  GetNewIMEState() returns ENABLED because "
         "design mode editor has focus"));
      return IMEState(IMEState::ENABLED);
    }
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  GetNewIMEState() returns DISABLED because "
       "no content has focus"));
    return IMEState(IMEState::DISABLED);
  }

  // nsIContent::GetDesiredIMEState() may cause a call of UpdateIMEState()
  // from EditorBase::PostCreate() because GetDesiredIMEState() needs to
  // retrieve an editor instance for the element if it's editable element.
  // For avoiding such nested IME state updates, we should set
  // sIsGettingNewIMEState here and UpdateIMEState() should check it.
  GettingNewIMEStateBlocker blocker;

  IMEState newIMEState = aContent->GetDesiredIMEState();
  MOZ_LOG(sISMLog, LogLevel::Debug,
    ("  GetNewIMEState() returns { mEnabled=%s, "
     "mOpen=%s }",
     GetIMEStateEnabledName(newIMEState.mEnabled),
     GetIMEStateSetOpenName(newIMEState.mOpen)));
  return newIMEState;
}

static bool
MayBeIMEUnawareWebApp(nsINode* aNode)
{
  bool haveKeyEventsListener = false;

  while (aNode) {
    EventListenerManager* const mgr = aNode->GetExistingListenerManager();
    if (mgr) {
      if (mgr->MayHaveInputOrCompositionEventListener()) {
        return false;
      }
      haveKeyEventsListener |= mgr->MayHaveKeyEventListener();
    }
    aNode = aNode->GetParentNode();
  }

  return haveKeyEventsListener;
}

// static
void
IMEStateManager::SetInputContextForChildProcess(
                   TabParent* aTabParent,
                   const InputContext& aInputContext,
                   const InputContextAction& aAction)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("SetInputContextForChildProcess(aTabParent=0x%p, "
     "aInputContext={ mIMEState={ mEnabled=%s, mOpen=%s }, "
     "mHTMLInputType=\"%s\", mHTMLInputInputmode=\"%s\", mActionHint=\"%s\" }, "
     "aAction={ mCause=%s, mAction=%s }), "
     "sPresContext=0x%p (available: %s), sWidget=0x%p (available: %s), "
     "sActiveTabParent=0x%p",
     aTabParent, GetIMEStateEnabledName(aInputContext.mIMEState.mEnabled),
     GetIMEStateSetOpenName(aInputContext.mIMEState.mOpen),
     NS_ConvertUTF16toUTF8(aInputContext.mHTMLInputType).get(),
     NS_ConvertUTF16toUTF8(aInputContext.mHTMLInputInputmode).get(),
     NS_ConvertUTF16toUTF8(aInputContext.mActionHint).get(),
     GetActionCauseName(aAction.mCause),
     GetActionFocusChangeName(aAction.mFocusChange),
     sPresContext.get(), GetBoolName(CanHandleWith(sPresContext)),
     sWidget, GetBoolName(sWidget && !sWidget->Destroyed()),
     sActiveTabParent.get()));

  if (aTabParent != sActiveTabParent) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  SetInputContextForChildProcess(), FAILED, "
       "because non-focused tab parent tries to set input context"));
    return;
  }

  if (NS_WARN_IF(!CanHandleWith(sPresContext))) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  SetInputContextForChildProcess(), FAILED, "
       "due to no focused presContext"));
    return;
  }

  if (NS_WARN_IF(!sWidget) || NS_WARN_IF(sWidget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  SetInputContextForChildProcess(), FAILED, "
       "due to the widget for the nsPresContext has gone"));
    return;
  }

  nsCOMPtr<nsIWidget> widget(sWidget);

  MOZ_ASSERT(!sPresContext->GetRootWidget() ||
             sPresContext->GetRootWidget() == widget);
  MOZ_ASSERT(aInputContext.mOrigin == InputContext::ORIGIN_CONTENT);

  SetInputContext(widget, aInputContext, aAction);
}

// static
void
IMEStateManager::SetIMEState(const IMEState& aState,
                             nsIContent* aContent,
                             nsIWidget* aWidget,
                             InputContextAction aAction)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("SetIMEState(aState={ mEnabled=%s, mOpen=%s }, "
     "aContent=0x%p (TabParent=0x%p), aWidget=0x%p, aAction={ mCause=%s, "
     "mFocusChange=%s })",
     GetIMEStateEnabledName(aState.mEnabled),
     GetIMEStateSetOpenName(aState.mOpen), aContent,
     TabParent::GetFrom(aContent), aWidget,
     GetActionCauseName(aAction.mCause),
     GetActionFocusChangeName(aAction.mFocusChange)));

  NS_ENSURE_TRUE_VOID(aWidget);

  InputContext context;
  context.mIMEState = aState;
  context.mMayBeIMEUnaware = context.mIMEState.IsEditable() &&
    sCheckForIMEUnawareWebApps && MayBeIMEUnawareWebApp(aContent);

  if (aContent &&
      aContent->IsAnyOfHTMLElements(nsGkAtoms::input, nsGkAtoms::textarea)) {
    if (!aContent->IsHTMLElement(nsGkAtoms::textarea)) {
      // <input type=number> has an anonymous <input type=text> descendant
      // that gets focus whenever anyone tries to focus the number control. We
      // need to check if aContent is one of those anonymous text controls and,
      // if so, use the number control instead:
      nsIContent* content = aContent;
      HTMLInputElement* inputElement =
        HTMLInputElement::FromContentOrNull(aContent);
      if (inputElement) {
        HTMLInputElement* ownerNumberControl =
          inputElement->GetOwnerNumberControl();
        if (ownerNumberControl) {
          content = ownerNumberControl; // an <input type=number>
        }
      }
      content->GetAttr(kNameSpaceID_None, nsGkAtoms::type,
                       context.mHTMLInputType);
    } else {
      context.mHTMLInputType.Assign(nsGkAtoms::textarea->GetUTF16String());
    }

    if (sInputModeSupported ||
        nsContentUtils::IsChromeDoc(aContent->OwnerDoc())) {
      aContent->GetAttr(kNameSpaceID_None, nsGkAtoms::inputmode,
                        context.mHTMLInputInputmode);
    }

    aContent->GetAttr(kNameSpaceID_None, nsGkAtoms::moz_action_hint,
                      context.mActionHint);

    // Get the input content corresponding to the focused node,
    // which may be an anonymous child of the input content.
    nsIContent* inputContent = aContent->FindFirstNonChromeOnlyAccessContent();

    // If we don't have an action hint and
    // return won't submit the form, use "next".
    if (context.mActionHint.IsEmpty() &&
        inputContent->IsHTMLElement(nsGkAtoms::input)) {
      bool willSubmit = false;
      nsCOMPtr<nsIFormControl> control(do_QueryInterface(inputContent));
      mozilla::dom::Element* formElement = nullptr;
      nsCOMPtr<nsIForm> form;
      if (control) {
        formElement = control->GetFormElement();
        // is this a form and does it have a default submit element?
        if ((form = do_QueryInterface(formElement)) &&
            form->GetDefaultSubmitElement()) {
          willSubmit = true;
        // is this an html form and does it only have a single text input element?
        } else if (formElement && formElement->IsHTMLElement(nsGkAtoms::form) &&
                   !static_cast<dom::HTMLFormElement*>(formElement)->
                     ImplicitSubmissionIsDisabled()) {
          willSubmit = true;
        }
      }
      context.mActionHint.Assign(
        willSubmit ? (control->ControlType() == NS_FORM_INPUT_SEARCH ?
                       NS_LITERAL_STRING("search") : NS_LITERAL_STRING("go")) :
                     (formElement ?
                       NS_LITERAL_STRING("next") : EmptyString()));
    }
  }

  // XXX I think that we should use nsContentUtils::IsCallerChrome() instead
  //     of the process type.
  if (aAction.mCause == InputContextAction::CAUSE_UNKNOWN &&
      !XRE_IsContentProcess()) {
    aAction.mCause = InputContextAction::CAUSE_UNKNOWN_CHROME;
  }

  SetInputContext(aWidget, context, aAction);
}

// static
void
IMEStateManager::SetInputContext(nsIWidget* aWidget,
                                 const InputContext& aInputContext,
                                 const InputContextAction& aAction)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("SetInputContext(aWidget=0x%p, aInputContext={ "
     "mIMEState={ mEnabled=%s, mOpen=%s }, mHTMLInputType=\"%s\", "
     "mHTMLInputInputmode=\"%s\", mActionHint=\"%s\" }, "
     "aAction={ mCause=%s, mAction=%s }), sActiveTabParent=0x%p",
     aWidget,
     GetIMEStateEnabledName(aInputContext.mIMEState.mEnabled),
     GetIMEStateSetOpenName(aInputContext.mIMEState.mOpen),
     NS_ConvertUTF16toUTF8(aInputContext.mHTMLInputType).get(),
     NS_ConvertUTF16toUTF8(aInputContext.mHTMLInputInputmode).get(),
     NS_ConvertUTF16toUTF8(aInputContext.mActionHint).get(),
     GetActionCauseName(aAction.mCause),
     GetActionFocusChangeName(aAction.mFocusChange),
     sActiveTabParent.get()));

  MOZ_RELEASE_ASSERT(aWidget);

  nsCOMPtr<nsIWidget> widget(aWidget);
  widget->SetInputContext(aInputContext, aAction);
  sActiveInputContextWidget = widget;
}

// static
void
IMEStateManager::EnsureTextCompositionArray()
{
  if (sTextCompositions) {
    return;
  }
  sTextCompositions = new TextCompositionArray();
}

// static
void
IMEStateManager::DispatchCompositionEvent(
                   nsINode* aEventTargetNode,
                   nsPresContext* aPresContext,
                   WidgetCompositionEvent* aCompositionEvent,
                   nsEventStatus* aStatus,
                   EventDispatchingCallback* aCallBack,
                   bool aIsSynthesized)
{
  RefPtr<TabParent> tabParent =
    aEventTargetNode->IsContent() ?
      TabParent::GetFrom(aEventTargetNode->AsContent()) : nullptr;

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("DispatchCompositionEvent(aNode=0x%p, "
     "aPresContext=0x%p, aCompositionEvent={ mMessage=%s, "
     "mNativeIMEContext={ mRawNativeIMEContext=0x%" PRIXPTR ", "
     "mOriginProcessID=0x%" PRIX64 " }, mWidget(0x%p)={ "
     "GetNativeIMEContext()={ mRawNativeIMEContext=0x%" PRIXPTR ", "
     "mOriginProcessID=0x%" PRIX64 " }, Destroyed()=%s }, "
     "mFlags={ mIsTrusted=%s, mPropagationStopped=%s } }, "
     "aIsSynthesized=%s), tabParent=%p",
     aEventTargetNode, aPresContext,
     ToChar(aCompositionEvent->mMessage),
     aCompositionEvent->mNativeIMEContext.mRawNativeIMEContext,
     aCompositionEvent->mNativeIMEContext.mOriginProcessID,
     aCompositionEvent->mWidget.get(),
     aCompositionEvent->mWidget->GetNativeIMEContext().mRawNativeIMEContext,
     aCompositionEvent->mWidget->GetNativeIMEContext().mOriginProcessID,
     GetBoolName(aCompositionEvent->mWidget->Destroyed()),
     GetBoolName(aCompositionEvent->mFlags.mIsTrusted),
     GetBoolName(aCompositionEvent->mFlags.mPropagationStopped),
     GetBoolName(aIsSynthesized), tabParent.get()));

  if (!aCompositionEvent->IsTrusted() ||
      aCompositionEvent->PropagationStopped()) {
    return;
  }

  MOZ_ASSERT(aCompositionEvent->mMessage != eCompositionUpdate,
             "compositionupdate event shouldn't be dispatched manually");

  EnsureTextCompositionArray();

  RefPtr<TextComposition> composition =
    sTextCompositions->GetCompositionFor(aCompositionEvent);
  if (!composition) {
    // If synthesized event comes after delayed native composition events
    // for request of commit or cancel, we should ignore it.
    if (NS_WARN_IF(aIsSynthesized)) {
      return;
    }
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  DispatchCompositionEvent(), "
       "adding new TextComposition to the array"));
    MOZ_ASSERT(aCompositionEvent->mMessage == eCompositionStart);
    composition =
      new TextComposition(aPresContext, aEventTargetNode, tabParent,
                          aCompositionEvent);
    sTextCompositions->AppendElement(composition);
  }
#ifdef DEBUG
  else {
    MOZ_ASSERT(aCompositionEvent->mMessage != eCompositionStart);
  }
#endif // #ifdef DEBUG

  // Dispatch the event on composing target.
  composition->DispatchCompositionEvent(aCompositionEvent, aStatus, aCallBack,
                                        aIsSynthesized);

  // WARNING: the |composition| might have been destroyed already.

  // Remove the ended composition from the array.
  // NOTE: When TextComposition is synthesizing compositionend event for
  //       emulating a commit, the instance shouldn't be removed from the array
  //       because IME may perform it later.  Then, we need to ignore the
  //       following commit events in TextComposition::DispatchEvent().
  //       However, if commit or cancel for a request is performed synchronously
  //       during not safe to dispatch events, PresShell must have discarded
  //       compositionend event.  Then, the synthesized compositionend event is
  //       the last event for the composition.  In this case, we need to
  //       destroy the TextComposition with synthesized compositionend event.
  if ((!aIsSynthesized ||
       composition->WasNativeCompositionEndEventDiscarded()) &&
      aCompositionEvent->CausesDOMCompositionEndEvent()) {
    TextCompositionArray::index_type i =
      sTextCompositions->IndexOf(aCompositionEvent->mWidget);
    if (i != TextCompositionArray::NoIndex) {
      MOZ_LOG(sISMLog, LogLevel::Debug,
        ("  DispatchCompositionEvent(), "
         "removing TextComposition from the array since NS_COMPOSTION_END "
         "was dispatched"));
      sTextCompositions->ElementAt(i)->Destroy();
      sTextCompositions->RemoveElementAt(i);
    }
  }
}

// static
IMEContentObserver*
IMEStateManager::GetActiveContentObserver()
{
  return sActiveIMEContentObserver;
}

// static
nsIContent*
IMEStateManager::GetRootContent(nsPresContext* aPresContext)
{
  nsIDocument* doc = aPresContext->Document();
  if (NS_WARN_IF(!doc)) {
    return nullptr;
  }
  return doc->GetRootElement();
}

// static
void
IMEStateManager::HandleSelectionEvent(nsPresContext* aPresContext,
                                      nsIContent* aEventTargetContent,
                                      WidgetSelectionEvent* aSelectionEvent)
{
  nsIContent* eventTargetContent =
    aEventTargetContent ? aEventTargetContent :
                          GetRootContent(aPresContext);
  RefPtr<TabParent> tabParent =
    eventTargetContent ? TabParent::GetFrom(eventTargetContent) : nullptr;

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("HandleSelectionEvent(aPresContext=0x%p, "
     "aEventTargetContent=0x%p, aSelectionEvent={ mMessage=%s, "
     "mFlags={ mIsTrusted=%s } }), tabParent=%p",
     aPresContext, aEventTargetContent,
     ToChar(aSelectionEvent->mMessage),
     GetBoolName(aSelectionEvent->mFlags.mIsTrusted),
     tabParent.get()));

  if (!aSelectionEvent->IsTrusted()) {
    return;
  }

  RefPtr<TextComposition> composition = sTextCompositions ?
    sTextCompositions->GetCompositionFor(aSelectionEvent->mWidget) : nullptr;
  if (composition) {
    // When there is a composition, TextComposition should guarantee that the
    // selection event will be handled in same target as composition events.
    composition->HandleSelectionEvent(aSelectionEvent);
  } else {
    // When there is no composition, the selection event should be handled
    // in the aPresContext or tabParent.
    TextComposition::HandleSelectionEvent(aPresContext, tabParent,
                                          aSelectionEvent);
  }
}

// static
void
IMEStateManager::OnCompositionEventDiscarded(
                   WidgetCompositionEvent* aCompositionEvent)
{
  // Note that this method is never called for synthesized events for emulating
  // commit or cancel composition.

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("OnCompositionEventDiscarded(aCompositionEvent={ "
     "mMessage=%s, mNativeIMEContext={ mRawNativeIMEContext=0x%" PRIXPTR ", "
     "mOriginProcessID=0x%" PRIX64 " }, mWidget(0x%p)={ "
     "GetNativeIMEContext()={ mRawNativeIMEContext=0x%" PRIXPTR ", "
     "mOriginProcessID=0x%" PRIX64 " }, Destroyed()=%s }, "
     "mFlags={ mIsTrusted=%s } })",
     ToChar(aCompositionEvent->mMessage),
     aCompositionEvent->mNativeIMEContext.mRawNativeIMEContext,
     aCompositionEvent->mNativeIMEContext.mOriginProcessID,
     aCompositionEvent->mWidget.get(),
     aCompositionEvent->mWidget->GetNativeIMEContext().mRawNativeIMEContext,
     aCompositionEvent->mWidget->GetNativeIMEContext().mOriginProcessID,
     GetBoolName(aCompositionEvent->mWidget->Destroyed()),
     GetBoolName(aCompositionEvent->mFlags.mIsTrusted)));

  if (!aCompositionEvent->IsTrusted()) {
    return;
  }

  // Ignore compositionstart for now because sTextCompositions may not have
  // been created yet.
  if (aCompositionEvent->mMessage == eCompositionStart) {
    return;
  }

  RefPtr<TextComposition> composition =
    sTextCompositions->GetCompositionFor(aCompositionEvent->mWidget);
  if (!composition) {
    // If the PresShell has been being destroyed during composition,
    // a TextComposition instance for the composition was already removed from
    // the array and destroyed in OnDestroyPresContext().  Therefore, we may
    // fail to retrieve a TextComposition instance here.
    MOZ_LOG(sISMLog, LogLevel::Info,
      ("  OnCompositionEventDiscarded(), "
       "TextComposition instance for the widget has already gone"));
    return;
  }
  composition->OnCompositionEventDiscarded(aCompositionEvent);
}

// static
nsresult
IMEStateManager::NotifyIME(IMEMessage aMessage,
                           nsIWidget* aWidget,
                           bool aOriginIsRemote)
{
  return IMEStateManager::NotifyIME(IMENotification(aMessage), aWidget,
                                    aOriginIsRemote);
}

// static
nsresult
IMEStateManager::NotifyIME(const IMENotification& aNotification,
                           nsIWidget* aWidget,
                           bool aOriginIsRemote)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("NotifyIME(aNotification={ mMessage=%s }, "
     "aWidget=0x%p, aOriginIsRemote=%s), sFocusedIMEWidget=0x%p, "
     "sRemoteHasFocus=%s",
     ToChar(aNotification.mMessage), aWidget,
     GetBoolName(aOriginIsRemote), sFocusedIMEWidget,
     GetBoolName(sRemoteHasFocus)));

  if (NS_WARN_IF(!aWidget)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  NotifyIME(), FAILED due to no widget"));
    return NS_ERROR_INVALID_ARG;
  }

  switch (aNotification.mMessage) {
    case NOTIFY_IME_OF_FOCUS: {
      if (sFocusedIMEWidget) {
        if (NS_WARN_IF(!sRemoteHasFocus && !aOriginIsRemote)) {
          MOZ_LOG(sISMLog, LogLevel::Error,
            ("  NotifyIME(), although, this process is "
             "getting IME focus but there was focused IME widget"));
        } else {
          MOZ_LOG(sISMLog, LogLevel::Info,
            ("  NotifyIME(), tries to notify IME of "
             "blur first because remote process's blur notification hasn't "
             "been received yet..."));
        }
        nsCOMPtr<nsIWidget> focusedIMEWidget(sFocusedIMEWidget);
        sFocusedIMEWidget = nullptr;
        sRemoteHasFocus = false;
        focusedIMEWidget->NotifyIME(IMENotification(NOTIFY_IME_OF_BLUR));
      }
      sRemoteHasFocus = aOriginIsRemote;
      sFocusedIMEWidget = aWidget;
      nsCOMPtr<nsIWidget> widget(aWidget);
      return widget->NotifyIME(aNotification);
    }
    case NOTIFY_IME_OF_BLUR: {
      if (!sRemoteHasFocus && aOriginIsRemote) {
        MOZ_LOG(sISMLog, LogLevel::Info,
          ("  NotifyIME(), received blur notification "
           "after another one has focus, nothing to do..."));
        return NS_OK;
      }
      if (NS_WARN_IF(sRemoteHasFocus && !aOriginIsRemote)) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  NotifyIME(), FAILED, received blur "
           "notification from this process but the remote has focus"));
        return NS_OK;
      }
      if (!sFocusedIMEWidget && aOriginIsRemote) {
        MOZ_LOG(sISMLog, LogLevel::Info,
          ("  NotifyIME(), received blur notification "
           "but the remote has already lost focus"));
        return NS_OK;
      }
      if (NS_WARN_IF(!sFocusedIMEWidget)) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  NotifyIME(), FAILED, received blur "
           "notification but there is no focused IME widget"));
        return NS_OK;
      }
      if (NS_WARN_IF(sFocusedIMEWidget != aWidget)) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  NotifyIME(), FAILED, received blur "
           "notification but there is no focused IME widget"));
        return NS_OK;
      }
      nsCOMPtr<nsIWidget> focusedIMEWidget(sFocusedIMEWidget);
      sFocusedIMEWidget = nullptr;
      sRemoteHasFocus = false;
      return focusedIMEWidget->NotifyIME(IMENotification(NOTIFY_IME_OF_BLUR));
    }
    case NOTIFY_IME_OF_SELECTION_CHANGE:
    case NOTIFY_IME_OF_TEXT_CHANGE:
    case NOTIFY_IME_OF_POSITION_CHANGE:
    case NOTIFY_IME_OF_MOUSE_BUTTON_EVENT:
    case NOTIFY_IME_OF_COMPOSITION_EVENT_HANDLED: {
      if (!sRemoteHasFocus && aOriginIsRemote) {
        MOZ_LOG(sISMLog, LogLevel::Info,
          ("  NotifyIME(), received content change "
           "notification from the remote but it's already lost focus"));
        return NS_OK;
      }
      if (NS_WARN_IF(sRemoteHasFocus && !aOriginIsRemote)) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  NotifyIME(), FAILED, received content "
           "change notification from this process but the remote has already "
           "gotten focus"));
        return NS_OK;
      }
      if (!sFocusedIMEWidget) {
        MOZ_LOG(sISMLog, LogLevel::Info,
          ("  NotifyIME(), received content change "
           "notification but there is no focused IME widget"));
        return NS_OK;
      }
      if (NS_WARN_IF(sFocusedIMEWidget != aWidget)) {
        MOZ_LOG(sISMLog, LogLevel::Error,
          ("  NotifyIME(), FAILED, received content "
           "change notification for IME which has already lost focus, so, "
           "nothing to do..."));
        return NS_OK;
      }
      nsCOMPtr<nsIWidget> widget(aWidget);
      return widget->NotifyIME(aNotification);
    }
    default:
      // Other notifications should be sent only when there is composition.
      // So, we need to handle the others below.
      break;
  }

  RefPtr<TextComposition> composition;
  if (sTextCompositions) {
    composition = sTextCompositions->GetCompositionFor(aWidget);
  }

  bool isSynthesizedForTests =
    composition && composition->IsSynthesizedForTests();

  MOZ_LOG(sISMLog, LogLevel::Info,
    ("  NotifyIME(), composition=0x%p, "
     "composition->IsSynthesizedForTests()=%s",
     composition.get(), GetBoolName(isSynthesizedForTests)));

  switch (aNotification.mMessage) {
    case REQUEST_TO_COMMIT_COMPOSITION:
      return composition ?
        composition->RequestToCommit(aWidget, false) : NS_OK;
    case REQUEST_TO_CANCEL_COMPOSITION:
      return composition ?
        composition->RequestToCommit(aWidget, true) : NS_OK;
    default:
      MOZ_CRASH("Unsupported notification");
  }
  MOZ_CRASH(
    "Failed to handle the notification for non-synthesized composition");
  return NS_ERROR_FAILURE;
}

// static
nsresult
IMEStateManager::NotifyIME(IMEMessage aMessage,
                           nsPresContext* aPresContext,
                           bool aOriginIsRemote)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("NotifyIME(aMessage=%s, aPresContext=0x%p, aOriginIsRemote=%s)",
     ToChar(aMessage), aPresContext, GetBoolName(aOriginIsRemote)));

  if (NS_WARN_IF(!CanHandleWith(aPresContext))) {
    return NS_ERROR_INVALID_ARG;
  }

  nsIWidget* widget = aPresContext->GetRootWidget();
  if (NS_WARN_IF(!widget)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  NotifyIME(), FAILED due to no widget for the "
       "nsPresContext"));
    return NS_ERROR_NOT_AVAILABLE;
  }
  return NotifyIME(aMessage, widget, aOriginIsRemote);
}

// static
bool
IMEStateManager::IsEditable(nsINode* node)
{
  if (node->IsEditable()) {
    return true;
  }
  // |node| might be readwrite (for example, a text control)
  if (node->IsElement() &&
      node->AsElement()->State().HasState(NS_EVENT_STATE_MOZ_READWRITE)) {
    return true;
  }
  return false;
}

// static
nsINode*
IMEStateManager::GetRootEditableNode(nsPresContext* aPresContext,
                                     nsIContent* aContent)
{
  if (aContent) {
    nsINode* root = nullptr;
    nsINode* node = aContent;
    while (node && IsEditable(node)) {
      // If the node has independent selection like <input type="text"> or
      // <textarea>, the node should be the root editable node for aContent.
      // FYI: <select> element also has independent selection but IsEditable()
      //      returns false.
      // XXX: If somebody adds new editable element which has independent
      //      selection but doesn't own editor, we'll need more checks here.
      if (node->IsContent() &&
          node->AsContent()->HasIndependentSelection()) {
        return node;
      }
      root = node;
      node = node->GetParentNode();
    }
    return root;
  }
  if (aPresContext) {
    nsIDocument* document = aPresContext->Document();
    if (document && document->IsEditable()) {
      return document;
    }
  }
  return nullptr;
}

// static
bool
IMEStateManager::IsIMEObserverNeeded(const IMEState& aState)
{
  return aState.MaybeEditable();
}

// static
void
IMEStateManager::DestroyIMEContentObserver()
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("DestroyIMEContentObserver(), sActiveIMEContentObserver=0x%p",
     sActiveIMEContentObserver.get()));

  if (!sActiveIMEContentObserver) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  DestroyIMEContentObserver() does nothing"));
    return;
  }

  MOZ_LOG(sISMLog, LogLevel::Debug,
    ("  DestroyIMEContentObserver(), destroying "
     "the active IMEContentObserver..."));
  RefPtr<IMEContentObserver> tsm = sActiveIMEContentObserver.get();
  sActiveIMEContentObserver = nullptr;
  tsm->Destroy();
}

// static
void
IMEStateManager::CreateIMEContentObserver(nsIEditor* aEditor)
{
  MOZ_LOG(sISMLog, LogLevel::Info,
    ("CreateIMEContentObserver(aEditor=0x%p), "
     "sPresContext=0x%p, sContent=0x%p, sWidget=0x%p (available: %s), "
     "sActiveIMEContentObserver=0x%p, "
     "sActiveIMEContentObserver->IsManaging(sPresContext, sContent)=%s",
     aEditor, sPresContext.get(), sContent.get(),
     sWidget, GetBoolName(sWidget && !sWidget->Destroyed()),
     sActiveIMEContentObserver.get(),
     GetBoolName(sActiveIMEContentObserver ?
       sActiveIMEContentObserver->IsManaging(sPresContext, sContent) : false)));

  if (NS_WARN_IF(sActiveIMEContentObserver)) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  CreateIMEContentObserver(), FAILED due to "
       "there is already an active IMEContentObserver"));
    MOZ_ASSERT(sActiveIMEContentObserver->IsManaging(sPresContext, sContent));
    return;
  }

  if (!sWidget || NS_WARN_IF(sWidget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  CreateIMEContentObserver(), FAILED due to "
       "the widget for the nsPresContext has gone"));
    return; // Sometimes, there are no widgets.
  }

  nsCOMPtr<nsIWidget> widget(sWidget);

  // If it's not text editable, we don't need to create IMEContentObserver.
  if (!IsIMEObserverNeeded(widget->GetInputContext().mIMEState)) {
    MOZ_LOG(sISMLog, LogLevel::Debug,
      ("  CreateIMEContentObserver() doesn't create "
       "IMEContentObserver because of non-editable IME state"));
    return;
  }

  if (NS_WARN_IF(widget->Destroyed())) {
    MOZ_LOG(sISMLog, LogLevel::Error,
      ("  CreateIMEContentObserver(), FAILED due to "
       "the widget for the nsPresContext has gone"));
    return;
  }

  MOZ_ASSERT(sPresContext->GetRootWidget() == widget);

  MOZ_LOG(sISMLog, LogLevel::Debug,
    ("  CreateIMEContentObserver() is creating an "
     "IMEContentObserver instance..."));
  sActiveIMEContentObserver = new IMEContentObserver();

  // IMEContentObserver::Init() might create another IMEContentObserver
  // instance.  So, sActiveIMEContentObserver would be replaced with new one.
  // We should hold the current instance here.
  RefPtr<IMEContentObserver> activeIMEContentObserver(sActiveIMEContentObserver);
  activeIMEContentObserver->Init(widget, sPresContext, sContent, aEditor);
}

// static
nsresult
IMEStateManager::GetFocusSelectionAndRoot(nsISelection** aSelection,
                                          nsIContent** aRootContent)
{
  if (!sActiveIMEContentObserver) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  return sActiveIMEContentObserver->GetSelectionAndRoot(aSelection,
                                                        aRootContent);
}

// static
already_AddRefed<TextComposition>
IMEStateManager::GetTextCompositionFor(nsIWidget* aWidget)
{
  if (!sTextCompositions) {
    return nullptr;
  }
  RefPtr<TextComposition> textComposition =
    sTextCompositions->GetCompositionFor(aWidget);
  return textComposition.forget();
}

// static
already_AddRefed<TextComposition>
IMEStateManager::GetTextCompositionFor(
                   const WidgetCompositionEvent* aCompositionEvent)
{
  if (!sTextCompositions) {
    return nullptr;
  }
  RefPtr<TextComposition> textComposition =
    sTextCompositions->GetCompositionFor(aCompositionEvent);
  return textComposition.forget();
}

// static
already_AddRefed<TextComposition>
IMEStateManager::GetTextCompositionFor(nsPresContext* aPresContext)
{
  if (!sTextCompositions) {
    return nullptr;
  }
  RefPtr<TextComposition> textComposition =
    sTextCompositions->GetCompositionFor(aPresContext);
  return textComposition.forget();
}

} // namespace mozilla
