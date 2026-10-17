/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ScrollTimeline.h"

#include "mozilla/AlreadyAddRefed.h"
#include "mozilla/AnimationTarget.h"
#include "mozilla/DisplayPortUtils.h"
#include "mozilla/ElementAnimationData.h"
#include "mozilla/PresShell.h"
#include "mozilla/ScrollContainerFrame.h"
#include "mozilla/ServoStyleConsts.h"
#include "mozilla/StaticPrefs_layout.h"
#include "mozilla/dom/Animation.h"
#include "mozilla/dom/AnimationTimelinesController.h"
#include "mozilla/dom/CSSNumericValueBinding.h"
#include "mozilla/dom/CSSUnitValue.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/DocumentInlines.h"
#include "mozilla/dom/ElementInlines.h"
#include "mozilla/dom/ScrollTimelineBinding.h"
#include "nsIFrame.h"
#include "nsLayoutUtils.h"
#include "nsRefreshDriver.h"

namespace mozilla::dom {

// ---------------------------------
// Methods of ScrollTimeline
// ---------------------------------

NS_IMPL_CYCLE_COLLECTION_CLASS(ScrollTimeline)
NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(ScrollTimeline,
                                                AnimationTimeline)
  tmp->Teardown();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mDocument)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mScrollerInfo.ElementForCycleCollection())
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(ScrollTimeline,
                                                  AnimationTimeline)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mDocument)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mScrollerInfo.ElementForCycleCollection())
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED_0(ScrollTimeline,
                                               AnimationTimeline)

JSObject* ScrollTimeline::WrapObject(JSContext* aCx,
                                     JS::Handle<JSObject*> aGivenProto) {
  return ScrollTimeline_Binding::Wrap(aCx, this, aGivenProto);
}

/* static */
already_AddRefed<ScrollTimeline> ScrollTimeline::Constructor(
    const GlobalObject& aGlobal, const ScrollTimelineOptions& aOptions,
    ErrorResult& aRv) {
  RefPtr<Document> doc =
      AnimationUtils::GetCurrentRealmDocument(aGlobal.Context());
  if (!doc) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  // Implements
  // <https://drafts.csswg.org/scroll-animations-1/#dom-scrolltimeline-scrolltimeline>

  // Step 2 -- get the source for the timeline.
  // The scrollingElement depends on style/layout-tree in quirks mode, and we
  // expect to get the up-to-date scrolling element, so it may flush the layout.
  Element* source = aOptions.mSource.WasPassed()
                        ? aOptions.mSource.Value().get()
                        : doc->GetScrollingElement();
  ScrollerInfo scroller = ScrollerInfo::Anonymous(
      ScrollerInfo::Type::Provided, source, PseudoStyleRequest::NotPseudo());

  // Step 3 -- set the axis for the timeline.
  StyleScrollAxis axis;
  switch (aOptions.mAxis) {
    case dom::ScrollAxis::Block:
      axis = StyleScrollAxis::Block;
      break;
    case dom::ScrollAxis::Inline:
      axis = StyleScrollAxis::Inline;
      break;
    case dom::ScrollAxis::X:
      axis = StyleScrollAxis::X;
      break;
    case dom::ScrollAxis::Y:
      axis = StyleScrollAxis::Y;
      break;
  }

  // Step 1 -- create the new ScrollTimeline object.
  RefPtr<ScrollTimeline> result =
      MakeAndAddRef<ScrollTimeline>(doc, scroller, axis);
  if (source) {
    result->UpdateCachedCurrentTime();
  }
  return result.forget();
}

Element* ScrollTimeline::GetSource() const { return SourceElement(); }

ScrollTimeline::State ScrollTimeline::GetState() const {
  const auto source = mScrollerInfo.Source();
  // Use document.scrollingElement to tell whether it's the root scroll
  // container. Note that we can't use mScrollerInfo.mType since Type::Nearest
  // can also reach the root scroll container.
  const bool isRoot =
      source.mElement &&
      source.mElement->OwnerDoc()->GetScrollingElementNoFlush() ==
          source.mElement;
  return State{source, mAxis, isRoot};
}

dom::ScrollAxis ScrollTimeline::GetScrollAxis() const {
  switch (mAxis) {
    case StyleScrollAxis::Block:
      return dom::ScrollAxis::Block;
    case StyleScrollAxis::Inline:
      return dom::ScrollAxis::Inline;
    case StyleScrollAxis::X:
      return dom::ScrollAxis::X;
    case StyleScrollAxis::Y:
      return dom::ScrollAxis::Y;
  }
  MOZ_ASSERT_UNREACHABLE("Unknown scroll axis");
  return dom::ScrollAxis::Block;
}

ScrollTimeline::ScrollTimeline(Document* aDocument,
                               const ScrollerInfo& aScrollerInfo,
                               StyleScrollAxis aAxis)
    : AnimationTimeline(aDocument->GetParentObject(),
                        aDocument->GetScopeObject()->GetRTPCallerType()),
      mDocument(aDocument),
      mScrollerInfo(aScrollerInfo),
      mAxis(aAxis) {
  MOZ_ASSERT(aDocument);

  mDocument->TimelinesController().AddScrollTimeline(*this);
}

/* static */
std::pair<const Element*, PseudoStyleRequest>
ScrollTimeline::FindNearestScroller(Element* aSubject,
                                    const PseudoStyleRequest& aPseudoRequest) {
  MOZ_ASSERT(aSubject);
  if (!aSubject->GetPrimaryFrame()) {
    return {nullptr, PseudoStyleRequest{}};
  }
  Element* subject = aSubject->GetPseudoElement(aPseudoRequest);
  if (!subject) {
    return {nullptr, PseudoStyleRequest{}};
  }

  // Rely on the behaviour of document.scrollingElement.
  Element* root = subject->OwnerDoc()->GetScrollingElementNoFlush();
  if (root == subject) {
    // If the element is the scrollingElement, we don't need to walk up the
    // frame tree.
    return {root, PseudoStyleRequest::NotPseudo()};
  }

  nsIFrame* subjectFrame = subject->GetPrimaryFrame();
  if (!subjectFrame) {
    return {nullptr, PseudoStyleRequest{}};
  }
  // Walk the frame tree rather than the flattened DOM tree.
  for (nsIFrame* curr = subjectFrame->GetParent(); curr;
       curr = curr->GetParent()) {
    nsIContent* content = curr->GetContent();
    if (!content || !content->IsElement()) {
      continue;
    }
    Element* element = content->AsElement();
    if (element == root) {
      break;
    }
    if (curr->IsScrollContainerFrame()) {
      return AnimationUtils::GetElementPseudoPair(element);
    }
  }
  return {root, PseudoStyleRequest::NotPseudo()};
}

/* static */
already_AddRefed<ScrollTimeline> ScrollTimeline::MakeAnonymous(
    Document* aDocument, const NonOwningAnimationTarget& aTarget,
    StyleScrollAxis aAxis, StyleScroller aScroller) {
  MOZ_ASSERT(aTarget);
  auto scroller = ScrollerInfo::Anonymous(aScroller, aTarget);
  // Each use of scroll() corresponds to its own instance of ScrollTimeline in
  // the Web Animations API, even if multiple elements use scroll() to refer to
  // the same scroll container with the same arguments.
  // https://drafts.csswg.org/scroll-animations-1/#scroll-notation
  return MakeAndAddRef<ScrollTimeline>(aDocument, scroller, aAxis);
}

/* static*/
already_AddRefed<ScrollTimeline> ScrollTimeline::MakeNamed(
    Document* aDocument, Element* aReferenceElement,
    const PseudoStyleRequest& aPseudoRequest, StyleScrollAxis aAxis) {
  MOZ_ASSERT(NS_IsMainThread());

  ScrollerInfo scroller =
      ScrollerInfo::Named(aReferenceElement, aPseudoRequest);
  return MakeAndAddRef<ScrollTimeline>(aDocument, std::move(scroller), aAxis);
}

Nullable<TimeDuration> ScrollTimeline::GetCurrentTimeAsDuration() const {
  const auto& data = ComputeTimelineData();
  if (!data) {
    return nullptr;
  }

  // FIXME: Scroll offsets on the RTL container is complicated specifically on
  // mobile, see https://github.com/w3c/csswg-drafts/issues/12893. For now, we
  // use the absoluate value to make things simple.
  const double progress =
      static_cast<double>(std::abs(data->mPosition) - data->mStart) /
      static_cast<double>(data->mEnd - data->mStart);
  return TimeDuration::FromMilliseconds(progress *
                                        PROGRESS_TIMELINE_DURATION_MILLISEC);
}

void ScrollTimeline::GetCurrentTime(
    Nullable<OwningCSSNumberish>& aRetVal) const {
  if (!StaticPrefs::layout_css_typed_om_enabled()) {
    // If Typed-OM isn't exposed, return progress encoded as milliseconds over
    // PROGRESS_TIMELINE_DURATION_MILLISEC.
    AnimationTimeline::GetCurrentTime(aRetVal);
    return;
  }

  const auto& data = ComputeTimelineData();
  if (!data) {
    aRetVal.SetNull();
    return;
  }
  // See the FIXME in our GetCurrentTimeAsDuration() override about
  // RTL/sideways scrollers. We do the same here.
  const double progress =
      static_cast<double>(std::abs(data->mPosition) - data->mStart) /
      static_cast<double>(data->mEnd - data->mStart);
  aRetVal.SetValue().SetAsCSSNumericValue() =
      MakeRefPtr<CSSUnitValue>(mWindow, progress * 100.0, "percent"_ns);
}

void ScrollTimeline::WillRefresh() {
  UpdateCachedCurrentTime();

  if (!mDocument->GetPresShell()) {
    // If we're not displayed, don't tick animations.
    return;
  }

  if (mAnimationOrder.isEmpty()) {
    return;
  }

  // FIXME: Bug 1737927: Need to check the animation mutation observers for
  // animations with scroll timelines.
  // nsAutoAnimationMutationBatch mb(mDocument);

  TickState dummyState;
  Tick(dummyState);
}

bool ScrollTimeline::UpdateIfStale() {
  // The scroll timeline may be stale if there are any updates in
  // RenderingPhase::AnimationFrameCallbacks and RenderingPhase::Layout.
  // We have to check if the ranges are still valid.
  // https://drafts.csswg.org/scroll-animations-1/#event-loop
  const bool currentTimeUpdated = UpdateCachedCurrentTime();

  if (mAnimations.IsEmpty()) {
    return false;
  }

  // Check all animations and request restyle.
  // NOTE: Even if the animation doesn't have the target, it would be okay to
  // post update. We can optimize the case later.
  for (const auto& animation :
       ToTArray<AutoTArray<RefPtr<Animation>, 32>>(mAnimationOrder)) {
    const bool triggered = animation->MakeReadyAndMaybeTrigger();
    if (currentTimeUpdated || triggered) {
      animation->PostUpdate();
    }
  }
  return true;
}

bool ScrollTimeline::SourceMatches(
    const Element* aElement, const PseudoStyleRequest& aPseudoRequest) const {
  if (mScrollerInfo.IsAnonymous()) {
    // Anonymous timelines are considered unique.
    return false;
  }
  const auto source = mScrollerInfo.Source();
  return source.mElement == aElement && source.mPseudoRequest == aPseudoRequest;
}

layers::ScrollDirection ScrollTimeline::State::Axis() const {
  const auto* e = mSource.mElement;
  MOZ_ASSERT(e && e->GetPrimaryFrame());
  const WritingMode wm = e->GetPrimaryFrame()->GetWritingMode();
  return mAxis == StyleScrollAxis::X ||
                 (!wm.IsVertical() && mAxis == StyleScrollAxis::Inline) ||
                 (wm.IsVertical() && mAxis == StyleScrollAxis::Block)
             ? layers::ScrollDirection::eHorizontal
             : layers::ScrollDirection::eVertical;
}

StyleOverflow ScrollTimeline::State::SourceScrollStyle() const {
  DebugOnly<const Element*> e = mSource.mElement;
  MOZ_ASSERT(e && e->GetPrimaryFrame());

  const ScrollContainerFrame* scrollContainerFrame = GetScrollContainerFrame();
  MOZ_ASSERT(scrollContainerFrame);

  const ScrollStyles scrollStyles = scrollContainerFrame->GetScrollStyles();

  return Axis() == layers::ScrollDirection::eHorizontal
             ? scrollStyles.mHorizontal
             : scrollStyles.mVertical;
}

bool ScrollTimeline::State::APZIsActiveForSource() const {
  auto* e = mSource.mElement;
  MOZ_ASSERT(e, "HasNonMinimalNonZeroDisplayPort requires a source element");
  return gfxPlatform::AsyncPanZoomEnabled() &&
         !nsLayoutUtils::ShouldDisableApzForElement(e) &&
         DisplayPortUtils::HasNonMinimalNonZeroDisplayPort(e);
}

bool ScrollTimeline::State::ScrollingDirectionIsAvailable() const {
  const ScrollContainerFrame* scrollContainerFrame = GetScrollContainerFrame();
  MOZ_ASSERT(scrollContainerFrame);
  return scrollContainerFrame->GetAvailableScrollingDirections().contains(
      Axis());
}

const ScrollContainerFrame* ScrollTimeline::State::GetScrollContainerFrame()
    const {
  auto* e = mSource.mElement;
  if (!e) {
    return nullptr;
  }

  if (mIsRoot) {
    // document.scrollingElement may point to <body> in quirks mode, but the
    // root scroll container frame is what actually scrolls - return it.
    if (const PresShell* presShell = e->OwnerDoc()->GetPresShell()) {
      return presShell->GetRootScrollContainerFrame();
    }
    return nullptr;
  }
  return nsLayoutUtils::FindScrollContainerFrameFor(e);
}

void ScrollTimeline::ReplacePropertiesWith(
    const Element* aReferenceElement, const PseudoStyleRequest& aPseudoRequest,
    nsAtom* aName, StyleScrollAxis aAxis) {
  MOZ_ASSERT(!mScrollerInfo.IsAnonymous());
  MOZ_ASSERT(aReferenceElement == mScrollerInfo.Source().mElement &&
             aPseudoRequest == mScrollerInfo.Source().mPseudoRequest);
  mAxis = aAxis;

  for (auto* anim = mAnimationOrder.getFirst(); anim;
       anim = static_cast<LinkedListElement<Animation>*>(anim)->getNext()) {
    MOZ_ASSERT(anim->GetTimeline() == this);
    MOZ_ASSERT(anim->GetTimelineName() == aName);
    // Set this so we just PostUpdate() for this animation.
    // FIXME(dshin, bug 1737927): Mutation observer may need to be notified.
    anim->SetTimeline(this, aName, Animation::FromJS::No);
  }
}

ScrollTimeline::~ScrollTimeline() { Teardown(); }

bool ScrollTimeline::UpdateCachedCurrentTime() {
  const auto prevCachedCurrentTime = std::move(mCachedCurrentTime);

  mCachedCurrentTime.reset();

  const auto state = GetState();
  // If no layout box, this timeline is inactive.
  if (const auto* e = state.mSource.mElement; !e || !e->GetPrimaryFrame()) {
    return prevCachedCurrentTime.isSome();
  }

  // if this is not a scroller container, this timeline is inactive.
  const ScrollContainerFrame* scrollContainerFrame =
      state.GetScrollContainerFrame();
  if (!scrollContainerFrame) {
    return prevCachedCurrentTime.isSome();
  }

  const auto orientation = state.Axis();

  // If there is no scrollable overflow, then the ScrollTimeline is inactive.
  // https://drafts.csswg.org/scroll-animations-1/#scrolltimeline-interface
  if (!scrollContainerFrame->GetAvailableScrollingDirections().contains(
          orientation)) {
    return prevCachedCurrentTime.isSome();
  }

  const nsPoint& scrollPosition = scrollContainerFrame->GetScrollPosition();
  const nsRect& scrollRange = scrollContainerFrame->GetScrollRange();

  mCachedCurrentTime.emplace(CurrentTimeData{
      orientation == layers::ScrollDirection::eHorizontal ? scrollPosition.x
                                                          : scrollPosition.y,
      orientation == layers::ScrollDirection::eHorizontal
          ? scrollRange.width
          : scrollRange.height});

  if (!prevCachedCurrentTime || mCachedCurrentTime->mMaxScrollOffset !=
                                    prevCachedCurrentTime->mMaxScrollOffset) {
    TimelineDataDidChange();
  }
  return mCachedCurrentTime != prevCachedCurrentTime;
}

void ScrollTimeline::TimelineDataDidChange() {
  for (auto* anim = mAnimationOrder.getFirst(); anim;
       anim = static_cast<LinkedListElement<Animation>*>(anim)->getNext()) {
    anim->UpdateNormalizedTimingForTimelineDataChange();
    anim->MaybeUpdateKeyframeComputedOffsets();
  }
}

std::pair<double, double> ScrollTimeline::IntervalForAttachmentRange(
    const AnimationRange& aStyleRange) const {
  if (!mCachedCurrentTime || aStyleRange.IsNormal()) {
    return {0.0, 1.0};
  }

  auto computeRangeEdgeAsPercentage =
      [&](const StyleGenericAnimationRangeValue<StyleLengthPercentage>&
              aValue) {
        const auto range = mCachedCurrentTime->mMaxScrollOffset;
        return static_cast<double>(aValue.lp.Resolve(range)) /
               static_cast<double>(range);
      };
  // We skip the unsupported timeline range anmes here. The spec doesn't address
  // this but other browsers agree with this behavior now.
  return {computeRangeEdgeAsPercentage(aStyleRange.mStart),
          computeRangeEdgeAsPercentage(aStyleRange.mEnd)};
};

void ScrollTimeline::AutoAlignStartTime() {
  for (Animation* animation : mAnimations) {
    animation->AutoAlignStartTime();
  }
}

Maybe<ScrollTimeline::ComputedTimelineData>
ScrollTimeline::ComputeTimelineData() const {
  return mCachedCurrentTime
             ? Some(ComputedTimelineData{mCachedCurrentTime->mPosition, 0,
                                         mCachedCurrentTime->mMaxScrollOffset})
             : Nothing();
}

static nsRefreshDriver* GetRefreshDriver(Document* aDocument) {
  nsPresContext* presContext = aDocument->GetPresContext();
  if (MOZ_UNLIKELY(!presContext)) {
    return nullptr;
  }
  return presContext->RefreshDriver();
}

void ScrollTimeline::NotifyAnimationUpdated(Animation& aAnimation) {
  AnimationTimeline::NotifyAnimationUpdated(aAnimation);

  if (!mAnimationOrder.isEmpty()) {
    if (auto* rd = GetRefreshDriver(mDocument)) {
      MOZ_ASSERT(isInList(),
                 "We should not register with the refresh driver if we are not"
                 " in the document's list of timelines");
      rd->EnsureAnimationUpdate();
    }
  }
}

void ScrollTimeline::NotifyAnimationContentVisibilityChanged(
    Animation* aAnimation, bool aIsVisible) {
  AnimationTimeline::NotifyAnimationContentVisibilityChanged(aAnimation,
                                                             aIsVisible);
  if (auto* rd = GetRefreshDriver(mDocument)) {
    MOZ_ASSERT(isInList(),
               "We should not register with the refresh driver if we are not"
               " in the document's list of timelines");
    rd->EnsureAnimationUpdate();
  }
}

NonOwningAnimationTarget ScrollTimeline::ScrollerInfo::Source() const {
  switch (mType) {
    case Type::Name:
      return NonOwningAnimationTarget{mSourceOrTarget};
    case Type::Nearest: {
      auto [element, pseudo] = FindNearestScroller(
          mSourceOrTarget.mElement, mSourceOrTarget.mPseudoRequest);
      return {const_cast<Element*>(element), pseudo};
    }
    case Type::Provided:
    case Type::Self:
      return NonOwningAnimationTarget{mSourceOrTarget};
    case Type::Root:
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("Unhandled timeline type");
  }
  // Specifies to use the document viewport as the scroll container.
  //
  // We use the owner doc of the animation target. This may be different
  // from |mDocument| after we implement ScrollTimeline interface for
  // script.
  return {mSourceOrTarget.mElement->OwnerDoc()->GetScrollingElementNoFlush(),
          PseudoStyleRequest{}};
}

NS_IMPL_CYCLE_COLLECTION_CLASS(InactiveTimeline)
NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(InactiveTimeline,
                                                ScrollTimeline)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(InactiveTimeline,
                                                  ScrollTimeline)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED_0(InactiveTimeline,
                                               AnimationTimeline)

InactiveTimeline::InactiveTimeline(Document* aDocument)
    : ScrollTimeline{
          aDocument,
          ScrollerInfo::Anonymous(ScrollerInfo::Type::Provided, nullptr, {}),
          StyleScrollAxis::Y} {}

}  // namespace mozilla::dom
