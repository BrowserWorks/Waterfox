/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsNumberControlFrame_h__
#define nsNumberControlFrame_h__

#include "mozilla/Attributes.h"
#include "nsContainerFrame.h"
#include "nsIFormControlFrame.h"
#include "nsIAnonymousContentCreator.h"
#include "nsCOMPtr.h"

class nsITextControlFrame;
class nsPresContext;

namespace mozilla {
enum class CSSPseudoElementType : uint8_t;
class WidgetEvent;
class WidgetGUIEvent;
namespace dom {
class HTMLInputElement;
} // namespace dom
} // namespace mozilla

/**
 * This frame type is used for <input type=number>.
 */
class nsNumberControlFrame final : public nsContainerFrame
                                 , public nsIAnonymousContentCreator
                                 , public nsIFormControlFrame
{
  friend nsIFrame*
  NS_NewNumberControlFrame(nsIPresShell* aPresShell, nsStyleContext* aContext);

  typedef mozilla::CSSPseudoElementType CSSPseudoElementType;
  typedef mozilla::dom::Element Element;
  typedef mozilla::dom::HTMLInputElement HTMLInputElement;
  typedef mozilla::WidgetEvent WidgetEvent;
  typedef mozilla::WidgetGUIEvent WidgetGUIEvent;

  explicit nsNumberControlFrame(nsStyleContext* aContext);

public:
  NS_DECL_QUERYFRAME
  NS_DECL_FRAMEARENA_HELPERS(nsNumberControlFrame)

  virtual void DestroyFrom(nsIFrame* aDestructRoot) override;
  virtual void ContentStatesChanged(mozilla::EventStates aStates) override;

#ifdef ACCESSIBILITY
  virtual mozilla::a11y::AccType AccessibleType() override;
#endif

  virtual nscoord GetMinISize(nsRenderingContext* aRenderingContext) override;

  virtual nscoord GetPrefISize(nsRenderingContext* aRenderingContext) override;

  virtual void Reflow(nsPresContext*           aPresContext,
                      ReflowOutput&     aDesiredSize,
                      const ReflowInput& aReflowInput,
                      nsReflowStatus&          aStatus) override;

  virtual nsresult AttributeChanged(int32_t  aNameSpaceID,
                                    nsIAtom* aAttribute,
                                    int32_t  aModType) override;

  // nsIAnonymousContentCreator
  virtual nsresult CreateAnonymousContent(nsTArray<ContentInfo>& aElements) override;
  virtual void AppendAnonymousContentTo(nsTArray<nsIContent*>& aElements,
                                        uint32_t aFilter) override;

#ifdef DEBUG_FRAME_DUMP
  virtual nsresult GetFrameName(nsAString& aResult) const override {
    return MakeFrameName(NS_LITERAL_STRING("NumberControl"), aResult);
  }
#endif

  virtual bool IsFrameOfType(uint32_t aFlags) const override
  {
    return nsContainerFrame::IsFrameOfType(aFlags &
      ~(nsIFrame::eReplaced | nsIFrame::eReplacedContainsBlock));
  }

  // nsIFormControlFrame
  virtual void SetFocus(bool aOn, bool aRepaint) override;
  virtual nsresult SetFormProperty(nsIAtom* aName, const nsAString& aValue) override;

  /**
   * This method attempts to localizes aValue and then sets the result as the
   * value of our anonymous text control. It's called when our
   * HTMLInputElement's value changes, when we need to sync up the value
   * displayed in our anonymous text control.
   */
  void SetValueOfAnonTextControl(const nsAString& aValue);

  /**
   * This method gets the string value of our anonymous text control,
   * attempts to normalizes (de-localizes) it, then sets the outparam aValue to
   * the result. It's called when user input changes the text value of our
   * anonymous text control so that we can sync up the internal value of our
   * HTMLInputElement.
   */
  void GetValueOfAnonTextControl(nsAString& aValue);

  bool AnonTextControlIsEmpty();

  /**
   * Called to notify this frame that its HTMLInputElement is currently
   * processing a DOM 'input' event.
   */
  void HandlingInputEvent(bool aHandlingEvent)
  {
    mHandlingInputEvent = aHandlingEvent;
  }

  HTMLInputElement* GetAnonTextControl();

  /**
   * If the frame is the frame for an nsNumberControlFrame's anonymous text
   * field, returns the nsNumberControlFrame. Else returns nullptr.
   */
  static nsNumberControlFrame* GetNumberControlFrameForTextField(nsIFrame* aFrame);

  /**
   * If the frame is the frame for an nsNumberControlFrame's up or down spin
   * button, returns the nsNumberControlFrame. Else returns nullptr.
   */
  static nsNumberControlFrame* GetNumberControlFrameForSpinButton(nsIFrame* aFrame);

  enum SpinButtonEnum {
    eSpinButtonNone,
    eSpinButtonUp,
    eSpinButtonDown
  };

  /**
   * Returns one of the SpinButtonEnum values to depending on whether the
   * pointer event is over the spin-up button, the spin-down button, or
   * neither.
   */
  int32_t GetSpinButtonForPointerEvent(WidgetGUIEvent* aEvent) const;

  void SpinnerStateChanged() const;

  bool SpinnerUpButtonIsDepressed() const;
  bool SpinnerDownButtonIsDepressed() const;

  bool IsFocused() const;

  void HandleFocusEvent(WidgetEvent* aEvent);

  /**
   * Our element had HTMLInputElement::Select() called on it.
   */
  nsresult HandleSelectCall();

  virtual Element* GetPseudoElement(CSSPseudoElementType aType) override;

  bool ShouldUseNativeStyleForSpinner() const;

private:

  nsITextControlFrame* GetTextFieldFrame();
  nsresult MakeAnonymousElement(Element** aResult,
                                nsTArray<ContentInfo>& aElements,
                                nsIAtom* aTagName,
                                CSSPseudoElementType aPseudoType);

  class SyncDisabledStateEvent;
  friend class SyncDisabledStateEvent;
  class SyncDisabledStateEvent : public mozilla::Runnable
  {
  public:
    explicit SyncDisabledStateEvent(nsNumberControlFrame* aFrame)
    : mFrame(aFrame)
    {}

    NS_IMETHOD Run() override
    {
      nsNumberControlFrame* frame =
        static_cast<nsNumberControlFrame*>(mFrame.GetFrame());
      NS_ENSURE_STATE(frame);

      frame->SyncDisabledState();
      return NS_OK;
    }

  private:
    WeakFrame mFrame;
  };

  /**
   * Sync the disabled state of the anonymous children up with our content's.
   */
  void SyncDisabledState();

  /**
   * The text field used to edit and show the number.
   * @see nsNumberControlFrame::CreateAnonymousContent.
   */
  nsCOMPtr<Element> mOuterWrapper;
  nsCOMPtr<Element> mTextField;
  nsCOMPtr<Element> mSpinBox;
  nsCOMPtr<Element> mSpinUp;
  nsCOMPtr<Element> mSpinDown;
  bool mHandlingInputEvent;
};

#endif // nsNumberControlFrame_h__
