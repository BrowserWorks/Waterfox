/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This frame type is used for input type=date, time, month, week, and
 * datetime-local.
 */

#include "nsDateTimeControlFrame.h"

#include "nsContentUtils.h"
#include "nsFormControlFrame.h"
#include "nsGkAtoms.h"
#include "nsContentUtils.h"
#include "nsContentCreatorFunctions.h"
#include "nsContentList.h"
#include "mozilla/dom/HTMLInputElement.h"
#include "nsNodeInfoManager.h"
#include "nsIDateTimeInputArea.h"
#include "nsIObserverService.h"
#include "nsIDOMHTMLInputElement.h"
#include "nsIDOMMutationEvent.h"
#include "jsapi.h"
#include "nsJSUtils.h"
#include "nsThreadUtils.h"

using namespace mozilla;
using namespace mozilla::dom;

nsIFrame*
NS_NewDateTimeControlFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsDateTimeControlFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsDateTimeControlFrame)

NS_QUERYFRAME_HEAD(nsDateTimeControlFrame)
  NS_QUERYFRAME_ENTRY(nsDateTimeControlFrame)
  NS_QUERYFRAME_ENTRY(nsIAnonymousContentCreator)
NS_QUERYFRAME_TAIL_INHERITING(nsContainerFrame)

nsDateTimeControlFrame::nsDateTimeControlFrame(nsStyleContext* aContext)
  : nsContainerFrame(aContext)
{
}

void
nsDateTimeControlFrame::DestroyFrom(nsIFrame* aDestructRoot)
{
  nsContentUtils::DestroyAnonymousContent(&mInputAreaContent);
  nsContainerFrame::DestroyFrom(aDestructRoot);
}

void
nsDateTimeControlFrame::UpdateInputBoxValue()
{
  nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
    do_QueryInterface(mInputAreaContent);
  if (inputAreaContent) {
    inputAreaContent->NotifyInputElementValueChanged();
  }
}

void
nsDateTimeControlFrame::SetValueFromPicker(const DateTimeValue& aValue)
{
  nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
    do_QueryInterface(mInputAreaContent);
  if (inputAreaContent) {
    AutoJSAPI api;
    if (!api.Init(mContent->OwnerDoc()->GetScopeObject())) {
      return;
    }

    JSObject* wrapper = mContent->GetWrapper();
    if (!wrapper) {
      return;
    }

    JSObject* scope = xpc::GetXBLScope(api.cx(), wrapper);
    AutoJSAPI jsapi;
    if (!scope || !jsapi.Init(scope)) {
      return;
    }

    JS::Rooted<JS::Value> jsValue(jsapi.cx());
    if (!ToJSValue(jsapi.cx(), aValue, &jsValue)) {
      return;
    }

    inputAreaContent->SetValueFromPicker(jsValue);
  }
}

void
nsDateTimeControlFrame::SetPickerState(bool aOpen)
{
  nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
    do_QueryInterface(mInputAreaContent);
  if (inputAreaContent) {
    inputAreaContent->SetPickerState(aOpen);
  }
}

void
nsDateTimeControlFrame::HandleFocusEvent()
{
  nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
    do_QueryInterface(mInputAreaContent);
  if (inputAreaContent) {
    inputAreaContent->FocusInnerTextBox();
  }
}

void
nsDateTimeControlFrame::HandleBlurEvent()
{
  nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
    do_QueryInterface(mInputAreaContent);
  if (inputAreaContent) {
    inputAreaContent->BlurInnerTextBox();
  }
}

nscoord
nsDateTimeControlFrame::GetMinISize(nsRenderingContext* aRenderingContext)
{
  nscoord result;
  DISPLAY_MIN_WIDTH(this, result);

  nsIFrame* kid = mFrames.FirstChild();
  if (kid) { // display:none?
    result = nsLayoutUtils::IntrinsicForContainer(aRenderingContext,
                                                  kid,
                                                  nsLayoutUtils::MIN_ISIZE);
  } else {
    result = 0;
  }

  return result;
}

nscoord
nsDateTimeControlFrame::GetPrefISize(nsRenderingContext* aRenderingContext)
{
  nscoord result;
  DISPLAY_PREF_WIDTH(this, result);

  nsIFrame* kid = mFrames.FirstChild();
  if (kid) { // display:none?
    result = nsLayoutUtils::IntrinsicForContainer(aRenderingContext,
                                                  kid,
                                                  nsLayoutUtils::PREF_ISIZE);
  } else {
    result = 0;
  }

  return result;
}

void
nsDateTimeControlFrame::Reflow(nsPresContext* aPresContext,
                               ReflowOutput& aDesiredSize,
                               const ReflowInput& aReflowInput,
                               nsReflowStatus& aStatus)
{
  MarkInReflow();

  DO_GLOBAL_REFLOW_COUNT("nsDateTimeControlFrame");
  DISPLAY_REFLOW(aPresContext, this, aReflowInput, aDesiredSize, aStatus);
  NS_FRAME_TRACE(NS_FRAME_TRACE_CALLS,
                 ("enter nsDateTimeControlFrame::Reflow: availSize=%d,%d",
                  aReflowInput.AvailableWidth(),
                  aReflowInput.AvailableHeight()));

  NS_ASSERTION(mInputAreaContent, "The input area content must exist!");

  const WritingMode myWM = aReflowInput.GetWritingMode();

  // The ISize of our content box, which is the available ISize
  // for our anonymous content:
  const nscoord contentBoxISize = aReflowInput.ComputedISize();
  nscoord contentBoxBSize = aReflowInput.ComputedBSize();

  // Figure out our border-box sizes as well (by adding borderPadding to
  // content-box sizes):
  const nscoord borderBoxISize = contentBoxISize +
    aReflowInput.ComputedLogicalBorderPadding().IStartEnd(myWM);

  nscoord borderBoxBSize;
  if (contentBoxBSize != NS_INTRINSICSIZE) {
    borderBoxBSize = contentBoxBSize +
      aReflowInput.ComputedLogicalBorderPadding().BStartEnd(myWM);
  } // else, we'll figure out borderBoxBSize after we resolve contentBoxBSize.

  nsIFrame* inputAreaFrame = mFrames.FirstChild();
  if (!inputAreaFrame) { // display:none?
    if (contentBoxBSize == NS_INTRINSICSIZE) {
      contentBoxBSize = 0;
      borderBoxBSize =
        aReflowInput.ComputedLogicalBorderPadding().BStartEnd(myWM);
    }
  } else {
    NS_ASSERTION(inputAreaFrame->GetContent() == mInputAreaContent,
                 "What is this child doing here?");

    ReflowOutput childDesiredSize(aReflowInput);

    WritingMode wm = inputAreaFrame->GetWritingMode();
    LogicalSize availSize = aReflowInput.ComputedSize(wm);
    availSize.BSize(wm) = NS_UNCONSTRAINEDSIZE;

    ReflowInput childReflowOuput(aPresContext, aReflowInput,
                                 inputAreaFrame, availSize);

    // Convert input area margin into my own writing-mode (in case it differs):
    LogicalMargin childMargin =
      childReflowOuput.ComputedLogicalMargin().ConvertTo(myWM, wm);

    // offsets of input area frame within this frame:
    LogicalPoint
      childOffset(myWM,
                  aReflowInput.ComputedLogicalBorderPadding().IStart(myWM) +
                  childMargin.IStart(myWM),
                  aReflowInput.ComputedLogicalBorderPadding().BStart(myWM) +
                  childMargin.BStart(myWM));

    nsReflowStatus childStatus;
    // We initially reflow the child with a dummy containerSize; positioning
    // will be fixed later.
    const nsSize dummyContainerSize;
    ReflowChild(inputAreaFrame, aPresContext, childDesiredSize,
                childReflowOuput, myWM, childOffset, dummyContainerSize, 0,
                childStatus);
    MOZ_ASSERT(NS_FRAME_IS_FULLY_COMPLETE(childStatus),
               "We gave our child unconstrained available block-size, "
               "so it should be complete");

    nscoord childMarginBoxBSize =
      childDesiredSize.BSize(myWM) + childMargin.BStartEnd(myWM);

    if (contentBoxBSize == NS_INTRINSICSIZE) {
      // We are intrinsically sized -- we should shrinkwrap the input area's
      // block-size:
      contentBoxBSize = childMarginBoxBSize;

      // Make sure we obey min/max-bsize in the case when we're doing intrinsic
      // sizing (we get it for free when we have a non-intrinsic
      // aReflowInput.ComputedBSize()).  Note that we do this before
      // adjusting for borderpadding, since ComputedMaxBSize and
      // ComputedMinBSize are content heights.
      contentBoxBSize =
        NS_CSS_MINMAX(contentBoxBSize,
                      aReflowInput.ComputedMinBSize(),
                      aReflowInput.ComputedMaxBSize());

      borderBoxBSize = contentBoxBSize +
        aReflowInput.ComputedLogicalBorderPadding().BStartEnd(myWM);
    }

    // Center child in block axis
    nscoord extraSpace = contentBoxBSize - childMarginBoxBSize;
    childOffset.B(myWM) += std::max(0, extraSpace / 2);

    // Needed in FinishReflowChild, for logical-to-physical conversion:
    nsSize borderBoxSize = LogicalSize(myWM, borderBoxISize, borderBoxBSize).
                           GetPhysicalSize(myWM);

    // Place the child
    FinishReflowChild(inputAreaFrame, aPresContext, childDesiredSize,
                      &childReflowOuput, myWM, childOffset, borderBoxSize, 0);

    nsSize contentBoxSize =
      LogicalSize(myWM, contentBoxISize, contentBoxBSize).
        GetPhysicalSize(myWM);
    aDesiredSize.SetBlockStartAscent(
      childDesiredSize.BlockStartAscent() +
      inputAreaFrame->BStart(aReflowInput.GetWritingMode(),
                             contentBoxSize));
  }

  LogicalSize logicalDesiredSize(myWM, borderBoxISize, borderBoxBSize);
  aDesiredSize.SetSize(myWM, logicalDesiredSize);

  aDesiredSize.SetOverflowAreasToDesiredBounds();

  if (inputAreaFrame) {
    ConsiderChildOverflow(aDesiredSize.mOverflowAreas, inputAreaFrame);
  }

  FinishAndStoreOverflow(&aDesiredSize);

  aStatus = NS_FRAME_COMPLETE;

  NS_FRAME_TRACE(NS_FRAME_TRACE_CALLS,
                 ("exit nsDateTimeControlFrame::Reflow: size=%d,%d",
                  aDesiredSize.Width(), aDesiredSize.Height()));
  NS_FRAME_SET_TRUNCATION(aStatus, aReflowInput, aDesiredSize);
}

nsresult
nsDateTimeControlFrame::CreateAnonymousContent(nsTArray<ContentInfo>& aElements)
{
  // Set up "datetimebox" XUL element which will be XBL-bound to the
  // actual controls.
  nsNodeInfoManager* nodeInfoManager =
    mContent->GetComposedDoc()->NodeInfoManager();
  RefPtr<NodeInfo> nodeInfo =
    nodeInfoManager->GetNodeInfo(nsGkAtoms::datetimebox, nullptr,
                                 kNameSpaceID_XUL, nsIDOMNode::ELEMENT_NODE);
  NS_ENSURE_TRUE(nodeInfo, NS_ERROR_OUT_OF_MEMORY);

  NS_TrustedNewXULElement(getter_AddRefs(mInputAreaContent), nodeInfo.forget());
  aElements.AppendElement(mInputAreaContent);

  // Propogate our tabindex.
  nsAutoString tabIndexStr;
  if (mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::tabindex, tabIndexStr)) {
    mInputAreaContent->SetAttr(kNameSpaceID_None, nsGkAtoms::tabindex,
                               tabIndexStr, false);
  }

  // Propagate our readonly state.
  nsAutoString readonly;
  if (mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::readonly, readonly)) {
    mInputAreaContent->SetAttr(kNameSpaceID_None, nsGkAtoms::readonly, readonly,
                               false);
  }

  SyncDisabledState();

  return NS_OK;
}

void
nsDateTimeControlFrame::AppendAnonymousContentTo(nsTArray<nsIContent*>& aElements,
                                                 uint32_t aFilter)
{
  if (mInputAreaContent) {
    aElements.AppendElement(mInputAreaContent);
  }
}

void
nsDateTimeControlFrame::SyncDisabledState()
{
  EventStates eventStates = mContent->AsElement()->State();
  if (eventStates.HasState(NS_EVENT_STATE_DISABLED)) {
    mInputAreaContent->SetAttr(kNameSpaceID_None, nsGkAtoms::disabled,
                               EmptyString(), true);
  } else {
    mInputAreaContent->UnsetAttr(kNameSpaceID_None, nsGkAtoms::disabled, true);
  }
}

nsresult
nsDateTimeControlFrame::AttributeChanged(int32_t aNameSpaceID,
                                         nsIAtom* aAttribute,
                                         int32_t aModType)
{
  NS_ASSERTION(mInputAreaContent, "The input area content must exist!");

  // nsGkAtoms::disabled is handled by SyncDisabledState
  if (aNameSpaceID == kNameSpaceID_None) {
    if (aAttribute == nsGkAtoms::value ||
        aAttribute == nsGkAtoms::readonly ||
        aAttribute == nsGkAtoms::tabindex) {
      MOZ_ASSERT(mContent->IsHTMLElement(nsGkAtoms::input), "bad cast");
      auto contentAsInputElem = static_cast<dom::HTMLInputElement*>(mContent);
      // If script changed the <input>'s type before setting these attributes
      // then we don't need to do anything since we are going to be reframed.
      if (contentAsInputElem->GetType() == NS_FORM_INPUT_TIME) {
        if (aAttribute == nsGkAtoms::value) {
          nsCOMPtr<nsIDateTimeInputArea> inputAreaContent =
            do_QueryInterface(mInputAreaContent);
          if (inputAreaContent) {
            nsContentUtils::AddScriptRunner(NewRunnableMethod(inputAreaContent,
              &nsIDateTimeInputArea::NotifyInputElementValueChanged));
          }
        } else {
          if (aModType == nsIDOMMutationEvent::REMOVAL) {
            mInputAreaContent->UnsetAttr(aNameSpaceID, aAttribute, true);
          } else {
            MOZ_ASSERT(aModType == nsIDOMMutationEvent::ADDITION ||
                       aModType == nsIDOMMutationEvent::MODIFICATION);
            nsAutoString value;
            mContent->GetAttr(aNameSpaceID, aAttribute, value);
            mInputAreaContent->SetAttr(aNameSpaceID, aAttribute, value, true);
          }
        }
      }
    }
  }

  return nsContainerFrame::AttributeChanged(aNameSpaceID, aAttribute,
                                            aModType);
}

void
nsDateTimeControlFrame::ContentStatesChanged(EventStates aStates)
{
  if (aStates.HasState(NS_EVENT_STATE_DISABLED)) {
    nsContentUtils::AddScriptRunner(new SyncDisabledStateEvent(this));
  }
}

nsIAtom*
nsDateTimeControlFrame::GetType() const
{
  return nsGkAtoms::dateTimeControlFrame;
}
