/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Code responsible for managing style changes: tracking what style
 * changes need to happen, scheduling them, and doing them.
 */

#ifndef mozilla_RestyleManager_h
#define mozilla_RestyleManager_h

#include "mozilla/RestyleLogging.h"
#include "mozilla/RestyleManagerBase.h"
#include "nsISupportsImpl.h"
#include "nsChangeHint.h"
#include "RestyleTracker.h"
#include "nsPresContext.h"
#include "nsRefreshDriver.h"
#include "nsRefPtrHashtable.h"
#include "nsTransitionManager.h"

class nsIFrame;
class nsStyleChangeList;
struct TreeMatchContext;

namespace mozilla {
  enum class CSSPseudoElementType : uint8_t;
  class EventStates;
  struct UndisplayedNode;

namespace dom {
  class Element;
} // namespace dom

class RestyleManager final : public RestyleManagerBase
{
public:
  typedef RestyleManagerBase base_type;

  friend class RestyleTracker;
  friend class ElementRestyler;

  explicit RestyleManager(nsPresContext* aPresContext);

private:
  // Private destructor, to discourage deletion outside of Release():
  ~RestyleManager()
  {
    MOZ_ASSERT(!mReframingStyleContexts,
               "temporary member should be nulled out before destruction");
    MOZ_ASSERT(!mAnimationsWithDestroyedFrame,
               "leaving dangling pointers from AnimationsWithDestroyedFrame");
  }

public:
  NS_INLINE_DECL_REFCOUNTING(mozilla::RestyleManager)

  // Forwarded nsIDocumentObserver method, to handle restyling (and
  // passing the notification to the frame).
  nsresult ContentStateChanged(nsIContent*   aContent,
                               EventStates aStateMask);

  // Forwarded nsIMutationObserver method, to handle restyling.
  void AttributeWillChange(Element* aElement,
                           int32_t  aNameSpaceID,
                           nsIAtom* aAttribute,
                           int32_t  aModType,
                           const nsAttrValue* aNewValue);
  // Forwarded nsIMutationObserver method, to handle restyling (and
  // passing the notification to the frame).
  void AttributeChanged(Element* aElement,
                        int32_t  aNameSpaceID,
                        nsIAtom* aAttribute,
                        int32_t  aModType,
                        const nsAttrValue* aOldValue);

  // Get a counter that increments on every style change, that we use to
  // track whether off-main-thread animations are up-to-date.
  uint64_t GetAnimationGeneration() const { return mAnimationGeneration; }

  static uint64_t GetAnimationGenerationForFrame(nsIFrame* aFrame);

  // Update the animation generation count to mark that animation state
  // has changed.
  //
  // This is normally performed automatically by ProcessPendingRestyles
  // but it is also called when we have out-of-band changes to animations
  // such as changes made through the Web Animations API.
  void IncrementAnimationGeneration() {
    // We update the animation generation at start of each call to
    // ProcessPendingRestyles so we should ignore any subsequent (redundant)
    // calls that occur while we are still processing restyles.
    if (!mIsProcessingRestyles) {
      ++mAnimationGeneration;
    }
  }

  // Whether rule matching should skip styles associated with animation
  bool SkipAnimationRules() const { return mSkipAnimationRules; }

  void SetSkipAnimationRules(bool aSkipAnimationRules) {
    mSkipAnimationRules = aSkipAnimationRules;
  }

  /**
   * Reparent the style contexts of this frame subtree.  The parent frame of
   * aFrame must be changed to the new parent before this function is called;
   * the new parent style context will be automatically computed based on the
   * new position in the frame tree.
   *
   * @param aFrame the root of the subtree to reparent.  Must not be null.
   */
  nsresult ReparentStyleContext(nsIFrame* aFrame);

  void ClearSelectors() {
    mPendingRestyles.ClearSelectors();
  }

private:
  // Used when restyling an element with a frame.
  void ComputeAndProcessStyleChange(nsIFrame*              aFrame,
                                    nsChangeHint           aMinChange,
                                    RestyleTracker&        aRestyleTracker,
                                    nsRestyleHint          aRestyleHint,
                                    const RestyleHintData& aRestyleHintData);

  // Used when restyling a display:contents element.
  void ComputeAndProcessStyleChange(nsStyleContext*        aNewContext,
                                    Element*               aElement,
                                    nsChangeHint           aMinChange,
                                    RestyleTracker&        aRestyleTracker,
                                    nsRestyleHint          aRestyleHint,
                                    const RestyleHintData& aRestyleHintData);

public:

  /**
   * In order to start CSS transitions on elements that are being
   * reframed, we need to stash their style contexts somewhere during
   * the reframing process.
   *
   * In all cases, the content node in the hash table is the real
   * content node, not the anonymous content node we create for ::before
   * or ::after.  The content node passed to the Get and Put methods is,
   * however, the content node to be associate with the frame's style
   * context.
   */
  typedef nsRefPtrHashtable<nsRefPtrHashKey<nsIContent>, nsStyleContext>
            ReframingStyleContextTable;
  class MOZ_STACK_CLASS ReframingStyleContexts final {
  public:
    /**
     * Construct a ReframingStyleContexts object.  The caller must
     * ensure that aRestyleManager lives at least as long as the
     * object.  (This is generally easy since the caller is typically a
     * method of RestyleManager.)
     */
    explicit ReframingStyleContexts(RestyleManager* aRestyleManager);
    ~ReframingStyleContexts();

    void Put(nsIContent* aContent, nsStyleContext* aStyleContext) {
      MOZ_ASSERT(aContent);
      CSSPseudoElementType pseudoType = aStyleContext->GetPseudoType();
      if (pseudoType == CSSPseudoElementType::NotPseudo) {
        mElementContexts.Put(aContent, aStyleContext);
      } else if (pseudoType == CSSPseudoElementType::before) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentbefore);
        mBeforePseudoContexts.Put(aContent->GetParent(), aStyleContext);
      } else if (pseudoType == CSSPseudoElementType::after) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentafter);
        mAfterPseudoContexts.Put(aContent->GetParent(), aStyleContext);
      }
    }

    nsStyleContext* Get(nsIContent* aContent,
                        CSSPseudoElementType aPseudoType) {
      MOZ_ASSERT(aContent);
      if (aPseudoType == CSSPseudoElementType::NotPseudo) {
        return mElementContexts.GetWeak(aContent);
      }
      if (aPseudoType == CSSPseudoElementType::before) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentbefore);
        return mBeforePseudoContexts.GetWeak(aContent->GetParent());
      }
      if (aPseudoType == CSSPseudoElementType::after) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentafter);
        return mAfterPseudoContexts.GetWeak(aContent->GetParent());
      }
      MOZ_ASSERT(false, "unexpected aPseudoType");
      return nullptr;
    }
  private:
    RestyleManager* mRestyleManager;
    AutoRestore<ReframingStyleContexts*> mRestorePointer;
    ReframingStyleContextTable mElementContexts;
    ReframingStyleContextTable mBeforePseudoContexts;
    ReframingStyleContextTable mAfterPseudoContexts;
  };

  /**
   * Return the current ReframingStyleContexts struct, or null if we're
   * not currently in a restyling operation.
   */
  ReframingStyleContexts* GetReframingStyleContexts() {
    return mReframingStyleContexts;
  }

  /**
   * Try initiating a transition for an element or a ::before or ::after
   * pseudo-element, given an old and new style context.  This may
   * change the new style context if a transition is started.  Returns
   * true if it does change aNewStyleContext.
   *
   * For the pseudo-elements, aContent must be the anonymous content
   * that we're creating for that pseudo-element, not the real element.
   */
  static bool
  TryInitiatingTransition(nsPresContext* aPresContext, nsIContent* aContent,
                          nsStyleContext* aOldStyleContext,
                          RefPtr<nsStyleContext>* aNewStyleContext /* inout */);

  // AnimationsWithDestroyedFrame is used to stop animations and transitions
  // on elements that have no frame at the end of the restyling process.
  // It only lives during the restyling process.
  class MOZ_STACK_CLASS AnimationsWithDestroyedFrame final {
  public:
    // Construct a AnimationsWithDestroyedFrame object.  The caller must
    // ensure that aRestyleManager lives at least as long as the
    // object.  (This is generally easy since the caller is typically a
    // method of RestyleManager.)
    explicit AnimationsWithDestroyedFrame(RestyleManager* aRestyleManager);

    // This method takes the content node for the generated content for
    // animation/transition on ::before and ::after, rather than the
    // content node for the real element.
    void Put(nsIContent* aContent, nsStyleContext* aStyleContext) {
      MOZ_ASSERT(aContent);
      CSSPseudoElementType pseudoType = aStyleContext->GetPseudoType();
      if (pseudoType == CSSPseudoElementType::NotPseudo) {
        mContents.AppendElement(aContent);
      } else if (pseudoType == CSSPseudoElementType::before) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentbefore);
        mBeforeContents.AppendElement(aContent->GetParent());
      } else if (pseudoType == CSSPseudoElementType::after) {
        MOZ_ASSERT(aContent->NodeInfo()->NameAtom() == nsGkAtoms::mozgeneratedcontentafter);
        mAfterContents.AppendElement(aContent->GetParent());
      }
    }

    void StopAnimationsForElementsWithoutFrames();

  private:
    void StopAnimationsWithoutFrame(nsTArray<RefPtr<nsIContent>>& aArray,
                                    CSSPseudoElementType aPseudoType);

    RestyleManager* mRestyleManager;
    AutoRestore<AnimationsWithDestroyedFrame*> mRestorePointer;

    // Below three arrays might include elements that have already had their
    // animations or transitions stopped.
    //
    // mBeforeContents and mAfterContents hold the real element rather than
    // the content node for the generated content (which might change during
    // a reframe)
    nsTArray<RefPtr<nsIContent>> mContents;
    nsTArray<RefPtr<nsIContent>> mBeforeContents;
    nsTArray<RefPtr<nsIContent>> mAfterContents;
  };

  /**
   * Return the current AnimationsWithDestroyedFrame struct, or null if we're
   * not currently in a restyling operation.
   */
  AnimationsWithDestroyedFrame* GetAnimationsWithDestroyedFrame() {
    return mAnimationsWithDestroyedFrame;
  }

private:
  void RestyleForEmptyChange(Element* aContainer);

public:
  // Handle ContentInserted notifications.
  void ContentInserted(nsINode* aContainer, nsIContent* aChild)
  {
    RestyleForInsertOrChange(aContainer, aChild);
  }

  // Handle ContentAppended notifications.
  void ContentAppended(nsIContent* aContainer, nsIContent* aFirstNewContent)
  {
    RestyleForAppend(aContainer, aFirstNewContent);
  }

  // Handle ContentRemoved notifications.
  //
  // This would be have the same logic as RestyleForInsertOrChange if we got the
  // notification before the removal.  However, we get it after, so we need the
  // following sibling in addition to the old child.  |aContainer| must be
  // non-null; when the container is null, no work is needed.  aFollowingSibling
  // is the sibling that used to come after aOldChild before the removal.
  void ContentRemoved(nsINode* aContainer, nsIContent* aOldChild,
                      nsIContent* aFollowingSibling);

  // Restyling for a ContentInserted (notification after insertion) or
  // for a CharacterDataChanged.  |aContainer| must be non-null; when
  // the container is null, no work is needed.
  void RestyleForInsertOrChange(nsINode* aContainer, nsIContent* aChild);

  // Restyling for a ContentAppended (notification after insertion) or
  // for a CharacterDataChanged.  |aContainer| must be non-null; when
  // the container is null, no work is needed.
  void RestyleForAppend(nsIContent* aContainer, nsIContent* aFirstNewContent);

  // Process any pending restyles. This should be called after
  // CreateNeededFrames.
  // Note: It's the caller's responsibility to make sure to wrap a
  // ProcessPendingRestyles call in a view update batch and a script blocker.
  // This function does not call ProcessAttachedQueue() on the binding manager.
  // If the caller wants that to happen synchronously, it needs to handle that
  // itself.
  void ProcessPendingRestyles();

  // Returns whether there are any pending restyles.
  bool HasPendingRestyles() { return mPendingRestyles.Count() != 0; }

private:
  // ProcessPendingRestyles calls into one of our RestyleTracker
  // objects.  It then calls back to these functions at the beginning
  // and end of its work.
  void BeginProcessingRestyles(RestyleTracker& aRestyleTracker);
  void EndProcessingRestyles();

public:
  // Update styles for animations that are running on the compositor and
  // whose updating is suppressed on the main thread (to save
  // unnecessary work), while leaving all other aspects of style
  // out-of-date.
  //
  // Performs an animation-only style flush to make styles from
  // throttled transitions up-to-date prior to processing an unrelated
  // style change, so that any transitions triggered by that style
  // change produce correct results.
  //
  // In more detail:  when we're able to run animations on the
  // compositor, we sometimes "throttle" these animations by skipping
  // updating style data on the main thread.  However, whenever we
  // process a normal (non-animation) style change, any changes in
  // computed style on elements that have transition-* properties set
  // may need to trigger new transitions; this process requires knowing
  // both the old and new values of the property.  To do this correctly,
  // we need to have an up-to-date *old* value of the property on the
  // primary frame.  So the purpose of the mini-flush is to update the
  // style for all throttled transitions and animations to the current
  // animation state without making any other updates, so that when we
  // process the queued style updates we'll have correct old data to
  // compare against.  When we do this, we don't bother touching frames
  // other than primary frames.
  void UpdateOnlyAnimationStyles();

  // Rebuilds all style data by throwing out the old rule tree and
  // building a new one, and additionally applying aExtraHint (which
  // must not contain nsChangeHint_ReconstructFrame) to the root frame.
  //
  // aRestyleHint says which restyle hint to use for the computation;
  // the only sensible values to use are eRestyle_Subtree (which says
  // that the rebuild must run selector matching) and nsRestyleHint(0)
  // (which says that rerunning selector matching is not required.  (The
  // method adds eRestyle_ForceDescendants internally, and including it
  // in the restyle hint is harmless; some callers (e.g.,
  // nsPresContext::MediaFeatureValuesChanged) might do this for their
  // own reasons.)
  void RebuildAllStyleData(nsChangeHint aExtraHint,
                           nsRestyleHint aRestyleHint);

  /**
   * Notify the frame constructor that an element needs to have its
   * style recomputed.
   * @param aElement: The element to be restyled.
   * @param aRestyleHint: Which nodes need to have selector matching run
   *                      on them.
   * @param aMinChangeHint: A minimum change hint for aContent and its
   *                        descendants.
   * @param aRestyleHintData: Additional data to go with aRestyleHint.
   */
  void PostRestyleEvent(Element* aElement,
                        nsRestyleHint aRestyleHint,
                        nsChangeHint aMinChangeHint,
                        const RestyleHintData* aRestyleHintData = nullptr);

  void PostRestyleEventForLazyConstruction()
  {
    PostRestyleEventInternal(true);
  }

public:
  /**
   * Asynchronously clear style data from the root frame downwards and ensure
   * it will all be rebuilt. This is safe to call anytime; it will schedule
   * a restyle and take effect next time style changes are flushed.
   * This method is used to recompute the style data when some change happens
   * outside of any style rules, like a color preference change or a change
   * in a system font size, or to fix things up when an optimization in the
   * style data has become invalid. We assume that the root frame will not
   * need to be reframed.
   *
   * For parameters, see RebuildAllStyleData.
   */
  void PostRebuildAllStyleDataEvent(nsChangeHint aExtraHint,
                                    nsRestyleHint aRestyleHint);

#ifdef DEBUG
  bool InRebuildAllStyleData() const { return mInRebuildAllStyleData; }
#endif

#ifdef RESTYLE_LOGGING
  /**
   * Returns whether a restyle event currently being processed by this
   * RestyleManager should be logged.
   */
  bool ShouldLogRestyle() {
    return ShouldLogRestyle(PresContext());
  }

  /**
   * Returns whether a restyle event currently being processed for the
   * document with the specified nsPresContext should be logged.
   */
  static bool ShouldLogRestyle(nsPresContext* aPresContext) {
    return aPresContext->RestyleLoggingEnabled() &&
           (!aPresContext->TransitionManager()->
               InAnimationOnlyStyleUpdate() ||
            AnimationRestyleLoggingEnabled());
  }

  static bool RestyleLoggingInitiallyEnabled() {
    static bool enabled = getenv("MOZ_DEBUG_RESTYLE") != 0;
    return enabled;
  }

  static bool AnimationRestyleLoggingEnabled() {
    static bool animations = getenv("MOZ_DEBUG_RESTYLE_ANIMATIONS") != 0;
    return animations;
  }

  // Set MOZ_DEBUG_RESTYLE_STRUCTS to a comma-separated string of
  // style struct names -- such as "Font,SVGReset" -- to log the style context
  // tree and those cached struct pointers before each restyle.  This
  // function returns a bitfield of the structs named in the
  // environment variable.
  static uint32_t StructsToLog();

  static nsCString StructNamesToString(uint32_t aSIDs);
  int32_t& LoggingDepth() { return mLoggingDepth; }
#endif

private:
  inline nsStyleSet* StyleSet() const {
    MOZ_ASSERT(PresContext()->StyleSet()->IsGecko(),
               "RestyleManager should only be used with a Gecko-flavored "
               "style backend");
    return PresContext()->StyleSet()->AsGecko();
  }

  /* aMinHint is the minimal change that should be made to the element */
  // XXXbz do we really need the aPrimaryFrame argument here?
  void RestyleElement(Element*        aElement,
                      nsIFrame*       aPrimaryFrame,
                      nsChangeHint    aMinHint,
                      RestyleTracker& aRestyleTracker,
                      nsRestyleHint   aRestyleHint,
                      const RestyleHintData& aRestyleHintData);

  void StartRebuildAllStyleData(RestyleTracker& aRestyleTracker);
  void FinishRebuildAllStyleData();

  bool ShouldStartRebuildAllFor(RestyleTracker& aRestyleTracker) {
    // When we process our primary restyle tracker and we have a pending
    // rebuild-all, we need to process it.
    return mDoRebuildAllStyleData &&
           &aRestyleTracker == &mPendingRestyles;
  }

  void ProcessRestyles(RestyleTracker& aRestyleTracker) {
    // Fast-path the common case (esp. for the animation restyle
    // tracker) of not having anything to do.
    if (aRestyleTracker.Count() || ShouldStartRebuildAllFor(aRestyleTracker)) {
      IncrementRestyleGeneration();
      aRestyleTracker.DoProcessRestyles();
    }
  }

private:
  // True if we need to reconstruct the rule tree the next time we
  // process restyles.
  bool mDoRebuildAllStyleData : 1;
  // True if we're currently in the process of reconstructing the rule tree.
  bool mInRebuildAllStyleData : 1;
  // Whether rule matching should skip styles associated with animation
  bool mSkipAnimationRules : 1;
  bool mHavePendingNonAnimationRestyles : 1;

  nsChangeHint mRebuildAllExtraHint;
  nsRestyleHint mRebuildAllRestyleHint;

  // The total number of animation flushes by this frame constructor.
  // Used to keep the layer and animation manager in sync.
  uint64_t mAnimationGeneration;

  ReframingStyleContexts* mReframingStyleContexts;
  AnimationsWithDestroyedFrame* mAnimationsWithDestroyedFrame;

  RestyleTracker mPendingRestyles;

  // Are we currently in the middle of a call to ProcessRestyles?
  // This flag is used both as a debugging aid to assert that we are not
  // performing nested calls to ProcessPendingRestyles, as well as to ignore
  // redundant calls to IncrementAnimationGeneration.
  bool mIsProcessingRestyles;

#ifdef RESTYLE_LOGGING
  int32_t mLoggingDepth;
#endif
};

/**
 * An ElementRestyler is created for *each* element in a subtree that we
 * recompute styles for.
 */
class ElementRestyler final
{
public:
  typedef mozilla::dom::Element Element;

  struct ContextToClear {
    RefPtr<nsStyleContext> mStyleContext;
    uint32_t mStructs;
  };

  // Construct for the root of the subtree that we're restyling.
  ElementRestyler(nsPresContext* aPresContext,
                  nsIFrame* aFrame,
                  nsStyleChangeList* aChangeList,
                  nsChangeHint aHintsHandledByAncestors,
                  RestyleTracker& aRestyleTracker,
                  nsTArray<nsCSSSelector*>& aSelectorsForDescendants,
                  TreeMatchContext& aTreeMatchContext,
                  nsTArray<nsIContent*>& aVisibleKidsOfHiddenElement,
                  nsTArray<ContextToClear>& aContextsToClear,
                  nsTArray<RefPtr<nsStyleContext>>& aSwappedStructOwners);

  // Construct for an element whose parent is being restyled.
  enum ConstructorFlags {
    FOR_OUT_OF_FLOW_CHILD = 1<<0
  };
  ElementRestyler(const ElementRestyler& aParentRestyler,
                  nsIFrame* aFrame,
                  uint32_t aConstructorFlags);

  // Construct for a frame whose parent is being restyled, but whose
  // style context is the parent style context for its parent frame.
  // (This is only used for table frames, whose style contexts are used
  // as the parent style context for their table wrapper frame. We should
  // probably try to get rid of this exception and have the inheritance go
  // the other way.)
  enum ParentContextFromChildFrame { PARENT_CONTEXT_FROM_CHILD_FRAME };
  ElementRestyler(ParentContextFromChildFrame,
                  const ElementRestyler& aParentFrameRestyler,
                  nsIFrame* aFrame);

  // For restyling undisplayed content only (mFrame==null).
  ElementRestyler(nsPresContext* aPresContext,
                  nsIContent* aContent,
                  nsStyleChangeList* aChangeList,
                  nsChangeHint aHintsHandledByAncestors,
                  RestyleTracker& aRestyleTracker,
                  nsTArray<nsCSSSelector*>& aSelectorsForDescendants,
                  TreeMatchContext& aTreeMatchContext,
                  nsTArray<nsIContent*>& aVisibleKidsOfHiddenElement,
                  nsTArray<ContextToClear>& aContextsToClear,
                  nsTArray<RefPtr<nsStyleContext>>& aSwappedStructOwners);

  /**
   * Restyle our frame's element and its subtree.
   *
   * Use eRestyle_Self for the aRestyleHint argument to mean
   * "reresolve our style context but not kids", use eRestyle_Subtree
   * to mean "reresolve our style context and kids", and use
   * nsRestyleHint(0) to mean recompute a new style context for our
   * current parent and existing rulenode, and the same for kids.
   */
  void Restyle(nsRestyleHint aRestyleHint);

  /**
   * mHintsHandled changes over time; it starts off as the hints that
   * have been handled by ancestors, and by the end of Restyle it
   * represents the hints that have been handled for this frame.  This
   * method is intended to be called after Restyle, to find out what
   * hints have been handled for this frame.
   */
  nsChangeHint HintsHandledForFrame() { return mHintsHandled; }

  /**
   * Called from RestyleManager::ComputeAndProcessStyleChange to restyle
   * children of a display:contents element.
   */
  void RestyleChildrenOfDisplayContentsElement(nsIFrame*       aParentFrame,
                                               nsStyleContext* aNewContext,
                                               nsChangeHint    aMinHint,
                                               RestyleTracker& aRestyleTracker,
                                               nsRestyleHint   aRestyleHint,
                                               const RestyleHintData&
                                                 aRestyleHintData);

  /**
   * Re-resolve the style contexts for a frame tree, building aChangeList
   * based on the resulting style changes, plus aMinChange applied to aFrame.
   */
  static void ComputeStyleChangeFor(nsIFrame*          aFrame,
                                    nsStyleChangeList* aChangeList,
                                    nsChangeHint       aMinChange,
                                    RestyleTracker&    aRestyleTracker,
                                    nsRestyleHint      aRestyleHint,
                                    const RestyleHintData& aRestyleHintData,
                                    nsTArray<ContextToClear>& aContextsToClear,
                                    nsTArray<RefPtr<nsStyleContext>>&
                                      aSwappedStructOwners);

#ifdef RESTYLE_LOGGING
  bool ShouldLogRestyle() {
    return RestyleManager::ShouldLogRestyle(mPresContext);
  }
#endif

private:
  inline nsStyleSet* StyleSet() const;

  // Enum class for the result of RestyleSelf, which indicates whether the
  // restyle procedure should continue to the children, and how.
  //
  // These values must be ordered so that later values imply that all
  // the work of the earlier values is also done.
  enum class RestyleResult : uint8_t {
    // default initial value
    eNone,

    // we left the old style context on the frame; do not restyle children
    eStop,

    // we got a new style context on this frame, but we know that children
    // do not depend on the changed values; do not restyle children
    eStopWithStyleChange,

    // continue restyling children
    eContinue,

    // continue restyling children with eRestyle_ForceDescendants set
    eContinueAndForceDescendants
  };

  struct SwapInstruction
  {
    RefPtr<nsStyleContext> mOldContext;
    RefPtr<nsStyleContext> mNewContext;
    uint32_t mStructsToSwap;
  };

  /**
   * First half of Restyle().
   */
  RestyleResult RestyleSelf(nsIFrame* aSelf,
                            nsRestyleHint aRestyleHint,
                            uint32_t* aSwappedStructs,
                            nsTArray<SwapInstruction>& aSwaps);

  /**
   * Restyle the children of this frame (and, in turn, their children).
   *
   * Second half of Restyle().
   */
  void RestyleChildren(nsRestyleHint aChildRestyleHint);

  /**
   * Returns true iff a selector in mSelectorsForDescendants matches aElement.
   * This is called when processing a eRestyle_SomeDescendants restyle hint.
   */
  bool SelectorMatchesForRestyle(Element* aElement);

  /**
   * Returns true iff aRestyleHint indicates that we should be restyling.
   * Specifically, this will return true when eRestyle_Self or
   * eRestyle_Subtree is present, or if eRestyle_SomeDescendants is
   * present and the specified element matches one of the selectors in
   * mSelectorsForDescendants.
   */
  bool MustRestyleSelf(nsRestyleHint aRestyleHint, Element* aElement);

  /**
   * Returns true iff aRestyleHint indicates that we can call
   * ReparentStyleContext rather than any other restyling method of
   * nsStyleSet that looks up a new rule node, and if we are
   * not in the process of reconstructing the whole rule tree.
   * This is used to check whether it is appropriate to call
   * ReparentStyleContext.
   */
  bool CanReparentStyleContext(nsRestyleHint aRestyleHint);

  /**
   * Helpers for Restyle().
   */
  void AddLayerChangesForAnimation();

  bool MoveStyleContextsForContentChildren(nsIFrame* aParent,
                                           nsStyleContext* aOldContext,
                                           nsTArray<nsStyleContext*>& aContextsToMove);
  bool MoveStyleContextsForChildren(nsStyleContext* aOldContext);

  /**
   * Helpers for RestyleSelf().
   */
  void CaptureChange(nsStyleContext* aOldContext,
                     nsStyleContext* aNewContext,
                     nsChangeHint aChangeToAssume,
                     uint32_t* aEqualStructs,
                     uint32_t* aSamePointerStructs);
  void ComputeRestyleResultFromFrame(nsIFrame* aSelf,
                                     RestyleResult& aRestyleResult,
                                     bool& aCanStopWithStyleChange);
  void ComputeRestyleResultFromNewContext(nsIFrame* aSelf,
                                          nsStyleContext* aNewContext,
                                          RestyleResult& aRestyleResult,
                                          bool& aCanStopWithStyleChange);

  // Helpers for RestyleChildren().
  void RestyleUndisplayedDescendants(nsRestyleHint aChildRestyleHint);
  bool MustCheckUndisplayedContent(nsIFrame* aFrame,
                                   nsIContent*& aUndisplayedParent);

  /**
   * In the following two methods, aParentStyleContext is either
   * mFrame->StyleContext() if we have a frame, or a display:contents
   * style context if we don't.
   */
  void DoRestyleUndisplayedDescendants(nsRestyleHint aChildRestyleHint,
                                       nsIContent* aParent,
                                       nsStyleContext* aParentStyleContext);
  void RestyleUndisplayedNodes(nsRestyleHint      aChildRestyleHint,
                               UndisplayedNode*   aUndisplayed,
                               nsIContent*        aUndisplayedParent,
                               nsStyleContext*    aParentStyleContext,
                               const StyleDisplay aDisplay);
  void MaybeReframeForBeforePseudo();
  void MaybeReframeForAfterPseudo(nsIFrame* aFrame);
  void MaybeReframeForPseudo(CSSPseudoElementType aPseudoType,
                             nsIFrame* aGenConParentFrame,
                             nsIFrame* aFrame,
                             nsIContent* aContent,
                             nsStyleContext* aStyleContext);
#ifdef DEBUG
  bool MustReframeForBeforePseudo();
  bool MustReframeForAfterPseudo(nsIFrame* aFrame);
#endif
  bool MustReframeForPseudo(CSSPseudoElementType aPseudoType,
                            nsIFrame* aGenConParentFrame,
                            nsIFrame* aFrame,
                            nsIContent* aContent,
                            nsStyleContext* aStyleContext);
  void RestyleContentChildren(nsIFrame* aParent,
                              nsRestyleHint aChildRestyleHint);
  void InitializeAccessibilityNotifications(nsStyleContext* aNewContext);
  void SendAccessibilityNotifications();

  enum DesiredA11yNotifications {
    eSkipNotifications,
    eSendAllNotifications,
    eNotifyIfShown
  };

  enum A11yNotificationType {
    eDontNotify,
    eNotifyShown,
    eNotifyHidden
  };

  // These methods handle the eRestyle_SomeDescendants hint by traversing
  // down the frame tree (and then when reaching undisplayed content,
  // the flattened content tree) find elements that match a selector
  // in mSelectorsForDescendants and call AddPendingRestyle for them.
  void ConditionallyRestyleChildren();
  void ConditionallyRestyleChildren(nsIFrame* aFrame,
                                    Element* aRestyleRoot);
  void ConditionallyRestyleContentChildren(nsIFrame* aFrame,
                                           Element* aRestyleRoot);
  void ConditionallyRestyleUndisplayedDescendants(nsIFrame* aFrame,
                                                  Element* aRestyleRoot);
  void DoConditionallyRestyleUndisplayedDescendants(nsIContent* aParent,
                                                    Element* aRestyleRoot);
  void ConditionallyRestyleUndisplayedNodes(UndisplayedNode* aUndisplayed,
                                            nsIContent* aUndisplayedParent,
                                            const StyleDisplay aDisplay,
                                            Element* aRestyleRoot);
  void ConditionallyRestyleContentDescendants(Element* aElement,
                                              Element* aRestyleRoot);
  bool ConditionallyRestyle(nsIFrame* aFrame, Element* aRestyleRoot);
  bool ConditionallyRestyle(Element* aElement, Element* aRestyleRoot);

#ifdef RESTYLE_LOGGING
  int32_t& LoggingDepth() { return mLoggingDepth; }
#endif

#ifdef DEBUG
  static nsCString RestyleResultToString(RestyleResult aRestyleResult);
#endif

private:
  nsPresContext* const mPresContext;
  nsIFrame* const mFrame;
  nsIContent* const mParentContent;
  // |mContent| is the node that we used for rule matching of
  // normal elements (not pseudo-elements) and for which we generate
  // framechange hints if we need them.
  nsIContent* const mContent;
  nsStyleChangeList* const mChangeList;
  // We have already generated change list entries for hints listed in
  // mHintsHandled (initially it's those handled by ancestors, but by
  // the end of Restyle it is those handled for this frame as well).  We
  // need to generate a new change list entry for the frame when its
  // style comparision returns a hint other than one of these hints.
  nsChangeHint mHintsHandled;
  // See nsStyleContext::CalcStyleDifference
  nsChangeHint mParentFrameHintsNotHandledForDescendants;
  nsChangeHint mHintsNotHandledForDescendants;
  RestyleTracker& mRestyleTracker;
  nsTArray<nsCSSSelector*>& mSelectorsForDescendants;
  TreeMatchContext& mTreeMatchContext;
  nsIFrame* mResolvedChild; // child that provides our parent style context
  // Array of style context subtrees in which we need to clear out cached
  // structs at the end of the restyle (after change hints have been
  // processed).
  nsTArray<ContextToClear>& mContextsToClear;
  // Style contexts that had old structs swapped into it and which should
  // stay alive until the end of the restyle.  (See comment in
  // ElementRestyler::Restyle.)
  nsTArray<RefPtr<nsStyleContext>>& mSwappedStructOwners;
  // Whether this is the root of the restyle.
  bool mIsRootOfRestyle;

#ifdef ACCESSIBILITY
  const DesiredA11yNotifications mDesiredA11yNotifications;
  DesiredA11yNotifications mKidsDesiredA11yNotifications;
  A11yNotificationType mOurA11yNotification;
  nsTArray<nsIContent*>& mVisibleKidsOfHiddenElement;
  bool mWasFrameVisible;
#endif

#ifdef RESTYLE_LOGGING
  int32_t mLoggingDepth;
#endif
};

/**
 * This pushes any display:contents nodes onto a TreeMatchContext.
 * Use it before resolving style for kids of aParent where aParent
 * (and further ancestors) may be display:contents nodes which have
 * not yet been pushed onto TreeMatchContext.
 */
class MOZ_RAII AutoDisplayContentsAncestorPusher final
{
 public:
  typedef mozilla::dom::Element Element;
  AutoDisplayContentsAncestorPusher(TreeMatchContext& aTreeMatchContext,
                                    nsPresContext*    aPresContext,
                                    nsIContent*       aParent);
  ~AutoDisplayContentsAncestorPusher();
  bool IsEmpty() const { return mAncestors.Length() == 0; }
private:
  TreeMatchContext& mTreeMatchContext;
  nsPresContext* const mPresContext;
  AutoTArray<mozilla::dom::Element*, 4> mAncestors;
};

} // namespace mozilla

#endif /* mozilla_RestyleManager_h */
