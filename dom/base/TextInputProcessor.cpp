/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gfxPrefs.h"
#include "mozilla/dom/Event.h"
#include "mozilla/EventForwards.h"
#include "mozilla/TextEventDispatcher.h"
#include "mozilla/TextEvents.h"
#include "mozilla/TextInputProcessor.h"
#include "mozilla/widget/IMEData.h"
#include "nsContentUtils.h"
#include "nsIDocShell.h"
#include "nsIWidget.h"
#include "nsPIDOMWindow.h"
#include "nsPresContext.h"

using namespace mozilla::widget;

namespace mozilla {

/******************************************************************************
 * TextInputProcessorNotification
 ******************************************************************************/

class TextInputProcessorNotification final :
        public nsITextInputProcessorNotification
{
  typedef IMENotification::SelectionChangeData SelectionChangeData;
  typedef IMENotification::SelectionChangeDataBase SelectionChangeDataBase;
  typedef IMENotification::TextChangeData TextChangeData;
  typedef IMENotification::TextChangeDataBase TextChangeDataBase;

public:
  explicit TextInputProcessorNotification(const char* aType)
    : mType(aType)
  {
  }

  explicit TextInputProcessorNotification(
             const TextChangeDataBase& aTextChangeData)
    : mType("notify-text-change")
    , mTextChangeData(aTextChangeData)
  {
  }

  explicit TextInputProcessorNotification(
             const SelectionChangeDataBase& aSelectionChangeData)
    : mType("notify-selection-change")
    , mSelectionChangeData(aSelectionChangeData)
  {
    // SelectionChangeDataBase::mString still refers nsString instance owned
    // by aSelectionChangeData.  So, this needs to copy the instance.
    nsString* string = new nsString(aSelectionChangeData.String());
    mSelectionChangeData.mString = string;
  }

  NS_DECL_ISUPPORTS

  NS_IMETHOD GetType(nsACString& aType) override final
  {
    aType = mType;
    return NS_OK;
  }

  // "notify-text-change" and "notify-selection-change"
  NS_IMETHOD GetOffset(uint32_t* aOffset) override final
  {
    if (NS_WARN_IF(!aOffset)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aOffset = mSelectionChangeData.mOffset;
      return NS_OK;
    }
    if (IsTextChange()) {
      *aOffset = mTextChangeData.mStartOffset;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  // "notify-selection-change"
  NS_IMETHOD GetText(nsAString& aText) override final
  {
    if (IsSelectionChange()) {
      aText = mSelectionChangeData.String();
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetCollapsed(bool* aCollapsed) override final
  {
    if (NS_WARN_IF(!aCollapsed)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aCollapsed = mSelectionChangeData.IsCollapsed();
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetLength(uint32_t* aLength) override final
  {
    if (NS_WARN_IF(!aLength)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aLength = mSelectionChangeData.Length();
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetReversed(bool* aReversed) override final
  {
    if (NS_WARN_IF(!aReversed)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aReversed = mSelectionChangeData.mReversed;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetWritingMode(nsACString& aWritingMode) override final
  {
    if (IsSelectionChange()) {
      WritingMode writingMode = mSelectionChangeData.GetWritingMode();
      if (!writingMode.IsVertical()) {
        aWritingMode.AssignLiteral("horizontal-tb");
      } else if (writingMode.IsVerticalLR()) {
        aWritingMode.AssignLiteral("vertical-lr");
      } else {
        aWritingMode.AssignLiteral("vertical-rl");
      }
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetCausedByComposition(bool* aCausedByComposition) override final
  {
    if (NS_WARN_IF(!aCausedByComposition)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aCausedByComposition = mSelectionChangeData.mCausedByComposition;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetCausedBySelectionEvent(
               bool* aCausedBySelectionEvent) override final
  {
    if (NS_WARN_IF(!aCausedBySelectionEvent)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aCausedBySelectionEvent = mSelectionChangeData.mCausedBySelectionEvent;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetOccurredDuringComposition(
               bool* aOccurredDuringComposition) override final
  {
    if (NS_WARN_IF(!aOccurredDuringComposition)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsSelectionChange()) {
      *aOccurredDuringComposition =
        mSelectionChangeData.mOccurredDuringComposition;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  // "notify-text-change"
  NS_IMETHOD GetRemovedLength(uint32_t* aLength) override final
  {
    if (NS_WARN_IF(!aLength)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsTextChange()) {
      *aLength = mTextChangeData.OldLength();
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetAddedLength(uint32_t* aLength) override final
  {
    if (NS_WARN_IF(!aLength)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsTextChange()) {
      *aLength = mTextChangeData.NewLength();
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetCausedOnlyByComposition(
               bool* aCausedOnlyByComposition) override final
  {
    if (NS_WARN_IF(!aCausedOnlyByComposition)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsTextChange()) {
      *aCausedOnlyByComposition = mTextChangeData.mCausedOnlyByComposition;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetIncludingChangesDuringComposition(
               bool* aIncludingChangesDuringComposition) override final
  {
    if (NS_WARN_IF(!aIncludingChangesDuringComposition)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsTextChange()) {
      *aIncludingChangesDuringComposition =
        mTextChangeData.mIncludingChangesDuringComposition;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_IMETHOD GetIncludingChangesWithoutComposition(
               bool* aIncludingChangesWithoutComposition) override final
  {
    if (NS_WARN_IF(!aIncludingChangesWithoutComposition)) {
      return NS_ERROR_INVALID_ARG;
    }
    if (IsTextChange()) {
      *aIncludingChangesWithoutComposition =
        mTextChangeData.mIncludingChangesWithoutComposition;
      return NS_OK;
    }
    return NS_ERROR_NOT_AVAILABLE;
  }

protected:
  virtual ~TextInputProcessorNotification()
  {
    if (IsSelectionChange()) {
      delete mSelectionChangeData.mString;
      mSelectionChangeData.mString = nullptr;
    }
  }

  bool IsTextChange() const
  {
    return mType.EqualsLiteral("notify-text-change");
  }

  bool IsSelectionChange() const
  {
    return mType.EqualsLiteral("notify-selection-change");
  }

private:
  nsAutoCString mType;
  union
  {
    TextChangeDataBase mTextChangeData;
    SelectionChangeDataBase mSelectionChangeData;
  };

  TextInputProcessorNotification() { }
};

NS_IMPL_ISUPPORTS(TextInputProcessorNotification,
                  nsITextInputProcessorNotification)

/******************************************************************************
 * TextInputProcessor
 ******************************************************************************/

NS_IMPL_ISUPPORTS(TextInputProcessor,
                  nsITextInputProcessor,
                  TextEventDispatcherListener,
                  nsISupportsWeakReference)

TextInputProcessor::TextInputProcessor()
  : mDispatcher(nullptr)
  , mForTests(false)
{
}

TextInputProcessor::~TextInputProcessor()
{
  if (mDispatcher && mDispatcher->IsComposing()) {
    // If this is composing and not canceling the composition, nobody can steal
    // the rights of TextEventDispatcher from this instance.  Therefore, this
    // needs to cancel the composition here.
    if (NS_SUCCEEDED(IsValidStateForComposition())) {
      RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
      nsEventStatus status = nsEventStatus_eIgnore;
      kungFuDeathGrip->CommitComposition(status, &EmptyString());
    }
  }
}

bool
TextInputProcessor::IsComposing() const
{
  return mDispatcher && mDispatcher->IsComposing();
}

NS_IMETHODIMP
TextInputProcessor::GetHasComposition(bool* aHasComposition)
{
  MOZ_RELEASE_ASSERT(aHasComposition, "aHasComposition must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  *aHasComposition = IsComposing();
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::BeginInputTransaction(
                      mozIDOMWindow* aWindow,
                      nsITextInputProcessorCallback* aCallback,
                      bool* aSucceeded)
{
  MOZ_RELEASE_ASSERT(aSucceeded, "aSucceeded must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  if (NS_WARN_IF(!aCallback)) {
    *aSucceeded = false;
    return NS_ERROR_INVALID_ARG;
  }
  return BeginInputTransactionInternal(aWindow, aCallback, false, *aSucceeded);
}

NS_IMETHODIMP
TextInputProcessor::BeginInputTransactionForTests(
                      mozIDOMWindow* aWindow,
                      nsITextInputProcessorCallback* aCallback,
                      uint8_t aOptionalArgc,
                      bool* aSucceeded)
{
  MOZ_RELEASE_ASSERT(aSucceeded, "aSucceeded must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  nsITextInputProcessorCallback* callback =
    aOptionalArgc >= 1 ? aCallback : nullptr;
  return BeginInputTransactionInternal(aWindow, callback, true, *aSucceeded);
}

nsresult
TextInputProcessor::BeginInputTransactionInternal(
                      mozIDOMWindow* aWindow,
                      nsITextInputProcessorCallback* aCallback,
                      bool aForTests,
                      bool& aSucceeded)
{
  aSucceeded = false;
  if (NS_WARN_IF(!aWindow)) {
    return NS_ERROR_INVALID_ARG;
  }
  nsCOMPtr<nsPIDOMWindowInner> pWindow = nsPIDOMWindowInner::From(aWindow);
  if (NS_WARN_IF(!pWindow)) {
    return NS_ERROR_INVALID_ARG;
  }
  nsCOMPtr<nsIDocShell> docShell(pWindow->GetDocShell());
  if (NS_WARN_IF(!docShell)) {
    return NS_ERROR_FAILURE;
  }
  RefPtr<nsPresContext> presContext;
  nsresult rv = docShell->GetPresContext(getter_AddRefs(presContext));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  if (NS_WARN_IF(!presContext)) {
    return NS_ERROR_FAILURE;
  }
  nsCOMPtr<nsIWidget> widget = presContext->GetRootWidget();
  if (NS_WARN_IF(!widget)) {
    return NS_ERROR_FAILURE;
  }

  RefPtr<TextEventDispatcher> dispatcher = widget->GetTextEventDispatcher();
  MOZ_RELEASE_ASSERT(dispatcher, "TextEventDispatcher must not be null");

  // If the instance was initialized and is being initialized for same
  // dispatcher and same purpose, we don't need to initialize the dispatcher
  // again.
  if (mDispatcher && dispatcher == mDispatcher && aCallback == mCallback &&
      aForTests == mForTests) {
    aSucceeded = true;
    return NS_OK;
  }

  // If this instance is composing or dispatching an event, don't allow to
  // initialize again.  Especially, if we allow to begin input transaction with
  // another TextEventDispatcher during dispatching an event, it may cause that
  // nobody cannot begin input transaction with it if the last event causes
  // opening modal dialog.
  if (mDispatcher &&
      (mDispatcher->IsComposing() || mDispatcher->IsDispatchingEvent())) {
    return NS_ERROR_ALREADY_INITIALIZED;
  }

  // And also if another instance is composing with the new dispatcher or
  // dispatching an event, it'll fail to steal its ownership.  Then, we should
  // not throw an exception, just return false.
  if (dispatcher->IsComposing() || dispatcher->IsDispatchingEvent()) {
    return NS_OK;
  }

  // This instance has finished preparing to link to the dispatcher.  Therefore,
  // let's forget the old dispatcher and purpose.
  if (mDispatcher) {
    mDispatcher->EndInputTransaction(this);
    if (NS_WARN_IF(mDispatcher)) {
      // Forcibly initialize the members if we failed to end the input
      // transaction.
      UnlinkFromTextEventDispatcher();
    }
  }

  if (aForTests) {
    bool isAPZAware = gfxPrefs::TestEventsAsyncEnabled();
    rv = dispatcher->BeginTestInputTransaction(this, isAPZAware);
  } else {
    rv = dispatcher->BeginInputTransaction(this);
  }

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mDispatcher = dispatcher;
  mCallback = aCallback;
  mForTests = aForTests;
  aSucceeded = true;
  return NS_OK;
}

void
TextInputProcessor::UnlinkFromTextEventDispatcher()
{
  mDispatcher = nullptr;
  mForTests = false;
  if (mCallback) {
    nsCOMPtr<nsITextInputProcessorCallback> callback(mCallback);
    mCallback = nullptr;

    RefPtr<TextInputProcessorNotification> notification =
      new TextInputProcessorNotification("notify-end-input-transaction");
    bool result = false;
    callback->OnNotify(this, notification, &result);
  }
}

nsresult
TextInputProcessor::IsValidStateForComposition()
{
  if (NS_WARN_IF(!mDispatcher)) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  nsresult rv = mDispatcher->GetState();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

bool
TextInputProcessor::IsValidEventTypeForComposition(
                      const WidgetKeyboardEvent& aKeyboardEvent) const
{
  // The key event type of composition methods must be "" or "keydown".
  if (aKeyboardEvent.mMessage == eKeyDown) {
    return true;
  }
  if (aKeyboardEvent.mMessage == eUnidentifiedEvent &&
      aKeyboardEvent.mSpecifiedEventType &&
      nsDependentAtomString(
        aKeyboardEvent.mSpecifiedEventType).EqualsLiteral("on")) {
    return true;
  }
  return false;
}

TextInputProcessor::EventDispatcherResult
TextInputProcessor::MaybeDispatchKeydownForComposition(
                      const WidgetKeyboardEvent* aKeyboardEvent,
                      uint32_t aKeyFlags)
{
  EventDispatcherResult result;

  result.mResult = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(result.mResult))) {
    result.mCanContinue = false;
    return result;
  }

  if (!aKeyboardEvent) {
    return result;
  }

  // Modifier keys are not allowed because managing modifier state in this
  // method makes this messy.
  if (NS_WARN_IF(aKeyboardEvent->IsModifierKeyEvent())) {
    result.mResult = NS_ERROR_INVALID_ARG;
    result.mCanContinue = false;
    return result;
  }

  uint32_t consumedFlags = 0;

  result.mResult = KeydownInternal(*aKeyboardEvent, aKeyFlags, false,
                                   consumedFlags);
  result.mDoDefault = !consumedFlags;
  if (NS_WARN_IF(NS_FAILED(result.mResult))) {
    result.mCanContinue = false;
    return result;
  }

  result.mCanContinue = NS_SUCCEEDED(IsValidStateForComposition());
  return result;
}

TextInputProcessor::EventDispatcherResult
TextInputProcessor::MaybeDispatchKeyupForComposition(
                      const WidgetKeyboardEvent* aKeyboardEvent,
                      uint32_t aKeyFlags)
{
  EventDispatcherResult result;

  if (!aKeyboardEvent) {
    return result;
  }

  // If the mMessage is eKeyDown, the caller doesn't want TIP to dispatch
  // keyup event.
  if (aKeyboardEvent->mMessage == eKeyDown) {
    return result;
  }

  // If the widget has been destroyed, we can do nothing here.
  result.mResult = IsValidStateForComposition();
  if (NS_FAILED(result.mResult)) {
    result.mCanContinue = false;
    return result;
  }

  result.mResult = KeyupInternal(*aKeyboardEvent, aKeyFlags, result.mDoDefault);
  if (NS_WARN_IF(NS_FAILED(result.mResult))) {
    result.mCanContinue = false;
    return result;
  }

  result.mCanContinue = NS_SUCCEEDED(IsValidStateForComposition());
  return result;
}

nsresult
TextInputProcessor::PrepareKeyboardEventForComposition(
                      nsIDOMKeyEvent* aDOMKeyEvent,
                      uint32_t& aKeyFlags,
                      uint8_t aOptionalArgc,
                      WidgetKeyboardEvent*& aKeyboardEvent)
{
  aKeyboardEvent = nullptr;

  aKeyboardEvent =
    aOptionalArgc && aDOMKeyEvent ?
      aDOMKeyEvent->AsEvent()->WidgetEventPtr()->AsKeyboardEvent() : nullptr;
  if (!aKeyboardEvent || aOptionalArgc < 2) {
    aKeyFlags = 0;
  }

  if (!aKeyboardEvent) {
    return NS_OK;
  }

  if (NS_WARN_IF(!IsValidEventTypeForComposition(*aKeyboardEvent))) {
    return NS_ERROR_INVALID_ARG;
  }

  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::StartComposition(nsIDOMKeyEvent* aDOMKeyEvent,
                                     uint32_t aKeyFlags,
                                     uint8_t aOptionalArgc,
                                     bool* aSucceeded)
{
  MOZ_RELEASE_ASSERT(aSucceeded, "aSucceeded must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  *aSucceeded = false;

  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);

  WidgetKeyboardEvent* keyboardEvent;
  nsresult rv =
    PrepareKeyboardEventForComposition(aDOMKeyEvent, aKeyFlags, aOptionalArgc,
                                       keyboardEvent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  EventDispatcherResult dispatcherResult =
    MaybeDispatchKeydownForComposition(keyboardEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(dispatcherResult.mResult)) ||
      !dispatcherResult.mCanContinue) {
    return dispatcherResult.mResult;
  }

  if (dispatcherResult.mDoDefault) {
    nsEventStatus status = nsEventStatus_eIgnore;
    rv = kungFuDeathGrip->StartComposition(status);
    *aSucceeded = status != nsEventStatus_eConsumeNoDefault &&
                    kungFuDeathGrip && kungFuDeathGrip->IsComposing();
  }

  MaybeDispatchKeyupForComposition(keyboardEvent, aKeyFlags);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::SetPendingCompositionString(const nsAString& aString)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  nsresult rv = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return kungFuDeathGrip->SetPendingCompositionString(aString);
}

NS_IMETHODIMP
TextInputProcessor::AppendClauseToPendingComposition(uint32_t aLength,
                                                     uint32_t aAttribute)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  TextRangeType textRangeType;
  switch (aAttribute) {
    case ATTR_RAW_CLAUSE:
    case ATTR_SELECTED_RAW_CLAUSE:
    case ATTR_CONVERTED_CLAUSE:
    case ATTR_SELECTED_CLAUSE:
      textRangeType = ToTextRangeType(aAttribute);
      break;
    default:
      return NS_ERROR_INVALID_ARG;
  }
  nsresult rv = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return kungFuDeathGrip->AppendClauseToPendingComposition(aLength, textRangeType);
}

NS_IMETHODIMP
TextInputProcessor::SetCaretInPendingComposition(uint32_t aOffset)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  nsresult rv = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return kungFuDeathGrip->SetCaretInPendingComposition(aOffset, 0);
}

NS_IMETHODIMP
TextInputProcessor::FlushPendingComposition(nsIDOMKeyEvent* aDOMKeyEvent,
                                            uint32_t aKeyFlags,
                                            uint8_t aOptionalArgc,
                                            bool* aSucceeded)
{
  MOZ_RELEASE_ASSERT(aSucceeded, "aSucceeded must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());

  // Even if this doesn't flush pending composition actually, we need to reset
  // pending composition for starting next composition with new user input.
  AutoPendingCompositionResetter resetter(this);

  *aSucceeded = false;
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  bool wasComposing = IsComposing();

  WidgetKeyboardEvent* keyboardEvent;
  nsresult rv =
    PrepareKeyboardEventForComposition(aDOMKeyEvent, aKeyFlags, aOptionalArgc,
                                       keyboardEvent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  EventDispatcherResult dispatcherResult =
    MaybeDispatchKeydownForComposition(keyboardEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(dispatcherResult.mResult)) ||
      !dispatcherResult.mCanContinue) {
    return dispatcherResult.mResult;
  }

  // Even if the preceding keydown event was consumed, if the composition
  // was already started, we shouldn't prevent the change of composition.
  if (dispatcherResult.mDoDefault || wasComposing) {
    // Preceding keydown event may cause destroying the widget.
    if (NS_FAILED(IsValidStateForComposition())) {
      return NS_OK;
    }
    nsEventStatus status = nsEventStatus_eIgnore;
    rv = kungFuDeathGrip->FlushPendingComposition(status);
    *aSucceeded = status != nsEventStatus_eConsumeNoDefault;
  }

  MaybeDispatchKeyupForComposition(keyboardEvent, aKeyFlags);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::CommitComposition(nsIDOMKeyEvent* aDOMKeyEvent,
                                      uint32_t aKeyFlags,
                                      uint8_t aOptionalArgc)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());

  WidgetKeyboardEvent* keyboardEvent;
  nsresult rv =
    PrepareKeyboardEventForComposition(aDOMKeyEvent, aKeyFlags, aOptionalArgc,
                                       keyboardEvent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return CommitCompositionInternal(keyboardEvent, aKeyFlags);
}

NS_IMETHODIMP
TextInputProcessor::CommitCompositionWith(const nsAString& aCommitString,
                                          nsIDOMKeyEvent* aDOMKeyEvent,
                                          uint32_t aKeyFlags,
                                          uint8_t aOptionalArgc,
                                          bool* aSucceeded)
{
  MOZ_RELEASE_ASSERT(aSucceeded, "aSucceeded must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());

  WidgetKeyboardEvent* keyboardEvent;
  nsresult rv =
    PrepareKeyboardEventForComposition(aDOMKeyEvent, aKeyFlags, aOptionalArgc,
                                       keyboardEvent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return CommitCompositionInternal(keyboardEvent, aKeyFlags,
                                   &aCommitString, aSucceeded);
}

nsresult
TextInputProcessor::CommitCompositionInternal(
                      const WidgetKeyboardEvent* aKeyboardEvent,
                      uint32_t aKeyFlags,
                      const nsAString* aCommitString,
                      bool* aSucceeded)
{
  if (aSucceeded) {
    *aSucceeded = false;
  }
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  bool wasComposing = IsComposing();

  EventDispatcherResult dispatcherResult =
    MaybeDispatchKeydownForComposition(aKeyboardEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(dispatcherResult.mResult)) ||
      !dispatcherResult.mCanContinue) {
    return dispatcherResult.mResult;
  }

  // Even if the preceding keydown event was consumed, if the composition
  // was already started, we shouldn't prevent the commit of composition.
  nsresult rv = NS_OK;
  if (dispatcherResult.mDoDefault || wasComposing) {
    // Preceding keydown event may cause destroying the widget.
    if (NS_FAILED(IsValidStateForComposition())) {
      return NS_OK;
    }
    nsEventStatus status = nsEventStatus_eIgnore;
    rv = kungFuDeathGrip->CommitComposition(status, aCommitString);
    if (aSucceeded) {
      *aSucceeded = status != nsEventStatus_eConsumeNoDefault;
    }
  }

  MaybeDispatchKeyupForComposition(aKeyboardEvent, aKeyFlags);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::CancelComposition(nsIDOMKeyEvent* aDOMKeyEvent,
                                      uint32_t aKeyFlags,
                                      uint8_t aOptionalArgc)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());

  WidgetKeyboardEvent* keyboardEvent;
  nsresult rv =
    PrepareKeyboardEventForComposition(aDOMKeyEvent, aKeyFlags, aOptionalArgc,
                                       keyboardEvent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return CancelCompositionInternal(keyboardEvent, aKeyFlags);
}

nsresult
TextInputProcessor::CancelCompositionInternal(
                      const WidgetKeyboardEvent* aKeyboardEvent,
                      uint32_t aKeyFlags)
{
  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);

  EventDispatcherResult dispatcherResult =
    MaybeDispatchKeydownForComposition(aKeyboardEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(dispatcherResult.mResult)) ||
      !dispatcherResult.mCanContinue) {
    return dispatcherResult.mResult;
  }

  nsEventStatus status = nsEventStatus_eIgnore;
  nsresult rv = kungFuDeathGrip->CommitComposition(status, &EmptyString());

  MaybeDispatchKeyupForComposition(aKeyboardEvent, aKeyFlags);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::NotifyIME(TextEventDispatcher* aTextEventDispatcher,
                              const IMENotification& aNotification)
{
  // If This is called while this is being initialized, ignore the call.
  // In such case, this method should return NS_ERROR_NOT_IMPLEMENTED because
  // we can say, TextInputProcessor doesn't implement any handlers of the
  // requests and notifications.
  if (!mDispatcher) {
    return NS_ERROR_NOT_IMPLEMENTED;
  }
  MOZ_ASSERT(aTextEventDispatcher == mDispatcher,
             "Wrong TextEventDispatcher notifies this");
  NS_ASSERTION(mForTests || mCallback,
               "mCallback can be null only when IME is initialized for tests");
  if (mCallback) {
    RefPtr<TextInputProcessorNotification> notification;
    switch (aNotification.mMessage) {
      case REQUEST_TO_COMMIT_COMPOSITION: {
        NS_ASSERTION(aTextEventDispatcher->IsComposing(),
                     "Why is this requested without composition?");
        notification = new TextInputProcessorNotification("request-to-commit");
        break;
      }
      case REQUEST_TO_CANCEL_COMPOSITION: {
        NS_ASSERTION(aTextEventDispatcher->IsComposing(),
                     "Why is this requested without composition?");
        notification = new TextInputProcessorNotification("request-to-cancel");
        break;
      }
      case NOTIFY_IME_OF_FOCUS:
        notification = new TextInputProcessorNotification("notify-focus");
        break;
      case NOTIFY_IME_OF_BLUR:
        notification = new TextInputProcessorNotification("notify-blur");
        break;
      case NOTIFY_IME_OF_TEXT_CHANGE:
        notification = new TextInputProcessorNotification(
                             aNotification.mTextChangeData);
        break;
      case NOTIFY_IME_OF_SELECTION_CHANGE:
        notification = new TextInputProcessorNotification(
                             aNotification.mSelectionChangeData);
        break;
      case NOTIFY_IME_OF_POSITION_CHANGE:
        notification = new TextInputProcessorNotification(
                             "notify-position-change");
        break;
      default:
        return NS_ERROR_NOT_IMPLEMENTED;
    }
    MOZ_RELEASE_ASSERT(notification);
    bool result = false;
    nsresult rv = mCallback->OnNotify(this, notification, &result);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    return result ? NS_OK : NS_ERROR_FAILURE;
  }

  switch (aNotification.mMessage) {
    case REQUEST_TO_COMMIT_COMPOSITION: {
      NS_ASSERTION(aTextEventDispatcher->IsComposing(),
                   "Why is this requested without composition?");
      CommitCompositionInternal();
      return NS_OK;
    }
    case REQUEST_TO_CANCEL_COMPOSITION: {
      NS_ASSERTION(aTextEventDispatcher->IsComposing(),
                   "Why is this requested without composition?");
      CancelCompositionInternal();
      return NS_OK;
    }
    default:
      return NS_ERROR_NOT_IMPLEMENTED;
  }
}

NS_IMETHODIMP_(IMENotificationRequests)
TextInputProcessor::GetIMENotificationRequests()
{
  // TextInputProcessor should support all change notifications.
  return IMENotificationRequests(
           IMENotificationRequests::NOTIFY_TEXT_CHANGE |
           IMENotificationRequests::NOTIFY_POSITION_CHANGE);
}

NS_IMETHODIMP_(void)
TextInputProcessor::OnRemovedFrom(TextEventDispatcher* aTextEventDispatcher)
{
  // If This is called while this is being initialized, ignore the call.
  if (!mDispatcher) {
    return;
  }
  MOZ_ASSERT(aTextEventDispatcher == mDispatcher,
             "Wrong TextEventDispatcher notifies this");
  UnlinkFromTextEventDispatcher();
}

NS_IMETHODIMP_(void)
TextInputProcessor::WillDispatchKeyboardEvent(
                      TextEventDispatcher* aTextEventDispatcher,
                      WidgetKeyboardEvent& aKeyboardEvent,
                      uint32_t aIndexOfKeypress,
                      void* aData)
{
  // TextInputProcessor doesn't set alternative char code nor modify charCode
  // even when Ctrl key is pressed.
}

nsresult
TextInputProcessor::PrepareKeyboardEventToDispatch(
                      WidgetKeyboardEvent& aKeyboardEvent,
                      uint32_t aKeyFlags)
{
  if (NS_WARN_IF(aKeyboardEvent.mCodeNameIndex == CODE_NAME_INDEX_USE_STRING)) {
    return NS_ERROR_INVALID_ARG;
  }
  if ((aKeyFlags & KEY_NON_PRINTABLE_KEY) &&
      NS_WARN_IF(aKeyboardEvent.mKeyNameIndex == KEY_NAME_INDEX_USE_STRING)) {
    return NS_ERROR_INVALID_ARG;
  }
  if ((aKeyFlags & KEY_FORCE_PRINTABLE_KEY) &&
      aKeyboardEvent.mKeyNameIndex != KEY_NAME_INDEX_USE_STRING) {
    aKeyboardEvent.GetDOMKeyName(aKeyboardEvent.mKeyValue);
    aKeyboardEvent.mKeyNameIndex = KEY_NAME_INDEX_USE_STRING;
  }
  if (aKeyFlags & KEY_KEEP_KEY_LOCATION_STANDARD) {
    // If .location is initialized with specific value, using
    // KEY_KEEP_KEY_LOCATION_STANDARD must be a bug of the caller.
    // Let's throw an exception for notifying the developer of this bug.
    if (NS_WARN_IF(aKeyboardEvent.mLocation)) {
      return NS_ERROR_INVALID_ARG;
    }
  } else if (!aKeyboardEvent.mLocation) {
    // If KeyboardEvent.mLocation is 0, it may be uninitialized.  If so, we
    // should compute proper mLocation value from its .code value.
    aKeyboardEvent.mLocation =
      WidgetKeyboardEvent::ComputeLocationFromCodeValue(
        aKeyboardEvent.mCodeNameIndex);
  }

  if (aKeyFlags & KEY_KEEP_KEYCODE_ZERO) {
    // If .keyCode is initialized with specific value, using
    // KEY_KEEP_KEYCODE_ZERO must be a bug of the caller.  Let's throw an
    // exception for notifying the developer of such bug.
    if (NS_WARN_IF(aKeyboardEvent.mKeyCode)) {
      return NS_ERROR_INVALID_ARG;
    }
  } else if (!aKeyboardEvent.mKeyCode &&
             aKeyboardEvent.mKeyNameIndex > KEY_NAME_INDEX_Unidentified &&
             aKeyboardEvent.mKeyNameIndex < KEY_NAME_INDEX_USE_STRING) {
    // If KeyboardEvent.keyCode is 0, it may be uninitialized.  If so, we may
    // be able to decide a good .keyCode value if the .key value is a
    // non-printable key.
    aKeyboardEvent.mKeyCode =
      WidgetKeyboardEvent::ComputeKeyCodeFromKeyNameIndex(
        aKeyboardEvent.mKeyNameIndex);
  }

  aKeyboardEvent.mIsSynthesizedByTIP = (mForTests)? false : true;

  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::Keydown(nsIDOMKeyEvent* aDOMKeyEvent,
                            uint32_t aKeyFlags,
                            uint8_t aOptionalArgc,
                            uint32_t* aConsumedFlags)
{
  MOZ_RELEASE_ASSERT(aConsumedFlags, "aConsumedFlags must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  if (!aOptionalArgc) {
    aKeyFlags = 0;
  }
  if (NS_WARN_IF(!aDOMKeyEvent)) {
    return NS_ERROR_INVALID_ARG;
  }
  WidgetKeyboardEvent* originalKeyEvent =
    aDOMKeyEvent->AsEvent()->WidgetEventPtr()->AsKeyboardEvent();
  if (NS_WARN_IF(!originalKeyEvent)) {
    return NS_ERROR_INVALID_ARG;
  }
  return KeydownInternal(*originalKeyEvent, aKeyFlags, true, *aConsumedFlags);
}

nsresult
TextInputProcessor::KeydownInternal(const WidgetKeyboardEvent& aKeyboardEvent,
                                    uint32_t aKeyFlags,
                                    bool aAllowToDispatchKeypress,
                                    uint32_t& aConsumedFlags)
{
  aConsumedFlags = KEYEVENT_NOT_CONSUMED;

  // We shouldn't modify the internal WidgetKeyboardEvent.
  WidgetKeyboardEvent keyEvent(aKeyboardEvent);
  nsresult rv = PrepareKeyboardEventToDispatch(keyEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  aConsumedFlags = (aKeyFlags & KEY_DEFAULT_PREVENTED) ? KEYDOWN_IS_CONSUMED :
                                                         KEYEVENT_NOT_CONSUMED;

  if (WidgetKeyboardEvent::GetModifierForKeyName(keyEvent.mKeyNameIndex)) {
    ModifierKeyData modifierKeyData(keyEvent);
    if (WidgetKeyboardEvent::IsLockableModifier(keyEvent.mKeyNameIndex)) {
      // If the modifier key is lockable modifier key such as CapsLock,
      // let's toggle modifier key state at keydown.
      ToggleModifierKey(modifierKeyData);
    } else {
      // Activate modifier flag before dispatching keydown event (i.e., keydown
      // event should indicate the releasing modifier is active.
      ActivateModifierKey(modifierKeyData);
    }
    if (aKeyFlags & KEY_DONT_DISPATCH_MODIFIER_KEY_EVENT) {
      return NS_OK;
    }
  } else if (NS_WARN_IF(aKeyFlags & KEY_DONT_DISPATCH_MODIFIER_KEY_EVENT)) {
    return NS_ERROR_INVALID_ARG;
  }
  keyEvent.mModifiers = GetActiveModifiers();

  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  rv = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsEventStatus status = aConsumedFlags ? nsEventStatus_eConsumeNoDefault :
                                          nsEventStatus_eIgnore;
  if (!kungFuDeathGrip->DispatchKeyboardEvent(eKeyDown, keyEvent, status)) {
    // If keydown event isn't dispatched, we don't need to dispatch keypress
    // events.
    return NS_OK;
  }

  aConsumedFlags |=
    (status == nsEventStatus_eConsumeNoDefault) ? KEYDOWN_IS_CONSUMED :
                                                  KEYEVENT_NOT_CONSUMED;

  if (aAllowToDispatchKeypress &&
      kungFuDeathGrip->MaybeDispatchKeypressEvents(keyEvent, status)) {
    aConsumedFlags |=
      (status == nsEventStatus_eConsumeNoDefault) ? KEYPRESS_IS_CONSUMED :
                                                    KEYEVENT_NOT_CONSUMED;
  }

  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::Keyup(nsIDOMKeyEvent* aDOMKeyEvent,
                          uint32_t aKeyFlags,
                          uint8_t aOptionalArgc,
                          bool* aDoDefault)
{
  MOZ_RELEASE_ASSERT(aDoDefault, "aDoDefault must not be nullptr");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  if (!aOptionalArgc) {
    aKeyFlags = 0;
  }
  if (NS_WARN_IF(!aDOMKeyEvent)) {
    return NS_ERROR_INVALID_ARG;
  }
  WidgetKeyboardEvent* originalKeyEvent =
    aDOMKeyEvent->AsEvent()->WidgetEventPtr()->AsKeyboardEvent();
  if (NS_WARN_IF(!originalKeyEvent)) {
    return NS_ERROR_INVALID_ARG;
  }
  return KeyupInternal(*originalKeyEvent, aKeyFlags, *aDoDefault);
}

nsresult
TextInputProcessor::KeyupInternal(const WidgetKeyboardEvent& aKeyboardEvent,
                                  uint32_t aKeyFlags,
                                  bool& aDoDefault)
{
  aDoDefault = false;

  // We shouldn't modify the internal WidgetKeyboardEvent.
  WidgetKeyboardEvent keyEvent(aKeyboardEvent);
  nsresult rv = PrepareKeyboardEventToDispatch(keyEvent, aKeyFlags);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  aDoDefault = !(aKeyFlags & KEY_DEFAULT_PREVENTED);

  if (WidgetKeyboardEvent::GetModifierForKeyName(keyEvent.mKeyNameIndex)) {
    if (!WidgetKeyboardEvent::IsLockableModifier(keyEvent.mKeyNameIndex)) {
      // Inactivate modifier flag before dispatching keyup event (i.e., keyup
      // event shouldn't indicate the releasing modifier is active.
      InactivateModifierKey(ModifierKeyData(keyEvent));
    }
    if (aKeyFlags & KEY_DONT_DISPATCH_MODIFIER_KEY_EVENT) {
      return NS_OK;
    }
  } else if (NS_WARN_IF(aKeyFlags & KEY_DONT_DISPATCH_MODIFIER_KEY_EVENT)) {
    return NS_ERROR_INVALID_ARG;
  }
  keyEvent.mModifiers = GetActiveModifiers();

  RefPtr<TextEventDispatcher> kungFuDeathGrip(mDispatcher);
  rv = IsValidStateForComposition();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsEventStatus status = aDoDefault ? nsEventStatus_eIgnore :
                                      nsEventStatus_eConsumeNoDefault;
  kungFuDeathGrip->DispatchKeyboardEvent(eKeyUp, keyEvent, status);
  aDoDefault = (status != nsEventStatus_eConsumeNoDefault);
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::GetModifierState(const nsAString& aModifierKeyName,
                                     bool* aActive)
{
  MOZ_RELEASE_ASSERT(aActive, "aActive must not be null");
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  if (!mModifierKeyDataArray) {
    *aActive = false;
    return NS_OK;
  }
  Modifiers activeModifiers = mModifierKeyDataArray->GetActiveModifiers();
  Modifiers modifier = WidgetInputEvent::GetModifier(aModifierKeyName);
  *aActive = ((activeModifiers & modifier) != 0);
  return NS_OK;
}

NS_IMETHODIMP
TextInputProcessor::ShareModifierStateOf(nsITextInputProcessor* aOther)
{
  MOZ_RELEASE_ASSERT(nsContentUtils::IsCallerChrome());
  if (!aOther) {
    mModifierKeyDataArray = nullptr;
    return NS_OK;
  }
  TextInputProcessor* other = static_cast<TextInputProcessor*>(aOther);
  if (!other->mModifierKeyDataArray) {
    other->mModifierKeyDataArray = new ModifierKeyDataArray();
  }
  mModifierKeyDataArray = other->mModifierKeyDataArray;
  return NS_OK;
}

/******************************************************************************
 * TextInputProcessor::AutoPendingCompositionResetter
 ******************************************************************************/
TextInputProcessor::AutoPendingCompositionResetter::
  AutoPendingCompositionResetter(TextInputProcessor* aTIP)
  : mTIP(aTIP)
{
  MOZ_RELEASE_ASSERT(mTIP.get(), "mTIP must not be null");
}

TextInputProcessor::AutoPendingCompositionResetter::
  ~AutoPendingCompositionResetter()
{
  if (mTIP->mDispatcher) {
    mTIP->mDispatcher->ClearPendingComposition();
  }
}

/******************************************************************************
 * TextInputProcessor::ModifierKeyData
 ******************************************************************************/
TextInputProcessor::ModifierKeyData::ModifierKeyData(
  const WidgetKeyboardEvent& aKeyboardEvent)
  : mKeyNameIndex(aKeyboardEvent.mKeyNameIndex)
  , mCodeNameIndex(aKeyboardEvent.mCodeNameIndex)
{
  mModifier = WidgetKeyboardEvent::GetModifierForKeyName(mKeyNameIndex);
  MOZ_ASSERT(mModifier, "mKeyNameIndex must be a modifier key name");
}

/******************************************************************************
 * TextInputProcessor::ModifierKeyDataArray
 ******************************************************************************/
Modifiers
TextInputProcessor::ModifierKeyDataArray::GetActiveModifiers() const
{
  Modifiers result = MODIFIER_NONE;
  for (uint32_t i = 0; i < Length(); i++) {
    result |= ElementAt(i).mModifier;
  }
  return result;
}

void
TextInputProcessor::ModifierKeyDataArray::ActivateModifierKey(
  const TextInputProcessor::ModifierKeyData& aModifierKeyData)
{
  if (Contains(aModifierKeyData)) {
    return;
  }
  AppendElement(aModifierKeyData);
}

void
TextInputProcessor::ModifierKeyDataArray::InactivateModifierKey(
  const TextInputProcessor::ModifierKeyData& aModifierKeyData)
{
  RemoveElement(aModifierKeyData);
}

void
TextInputProcessor::ModifierKeyDataArray::ToggleModifierKey(
  const TextInputProcessor::ModifierKeyData& aModifierKeyData)
{
  auto index = IndexOf(aModifierKeyData);
  if (index == NoIndex) {
    AppendElement(aModifierKeyData);
    return;
  }
  RemoveElementAt(index);
}

} // namespace mozilla
