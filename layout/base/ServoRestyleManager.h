/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ServoRestyleManager_h
#define mozilla_ServoRestyleManager_h

#include "mozilla/EventStates.h"
#include "mozilla/RestyleManager.h"
#include "mozilla/ServoElementSnapshot.h"
#include "mozilla/ServoElementSnapshotTable.h"
#include "nsChangeHint.h"
#include "nsPresContext.h"

namespace mozilla {
namespace dom {
class Element;
} // namespace dom
} // namespace mozilla
class nsAttrValue;
class nsIAtom;
class nsIContent;
class nsIFrame;
class nsStyleChangeList;

namespace mozilla {

/**
 * Restyle manager for a Servo-backed style system.
 */
class ServoRestyleManager : public RestyleManager
{
  friend class ServoStyleSet;

public:
  typedef ServoElementSnapshotTable SnapshotTable;
  typedef RestyleManager base_type;

  explicit ServoRestyleManager(nsPresContext* aPresContext);

  void PostRestyleEvent(dom::Element* aElement,
                        nsRestyleHint aRestyleHint,
                        nsChangeHint aMinChangeHint);
  void PostRestyleEventForCSSRuleChanges();
  void RebuildAllStyleData(nsChangeHint aExtraHint,
                           nsRestyleHint aRestyleHint);
  void PostRebuildAllStyleDataEvent(nsChangeHint aExtraHint,
                                    nsRestyleHint aRestyleHint);
  void ProcessPendingRestyles();

  void UpdateOnlyAnimationStyles();

  void ContentInserted(nsINode* aContainer, nsIContent* aChild);
  void ContentAppended(nsIContent* aContainer,
                       nsIContent* aFirstNewContent);
  void ContentRemoved(nsINode* aContainer,
                      nsIContent* aOldChild,
                      nsIContent* aFollowingSibling);

  void RestyleForInsertOrChange(nsINode* aContainer,
                                nsIContent* aChild);
  void RestyleForAppend(nsIContent* aContainer,
                        nsIContent* aFirstNewContent);
  void ContentStateChanged(nsIContent* aContent, EventStates aStateMask);
  void AttributeWillChange(dom::Element* aElement,
                           int32_t aNameSpaceID,
                           nsIAtom* aAttribute,
                           int32_t aModType,
                           const nsAttrValue* aNewValue);

  void AttributeChanged(dom::Element* aElement, int32_t aNameSpaceID,
                        nsIAtom* aAttribute, int32_t aModType,
                        const nsAttrValue* aOldValue);

  nsresult ReparentStyleContext(nsIFrame* aFrame);

  /**
   * Gets the appropriate frame given a content and a pseudo-element tag.
   *
   * Right now only supports a null tag, before or after. If the pseudo-element
   * is not null, the content needs to be an element.
   */
  static nsIFrame* FrameForPseudoElement(const nsIContent* aContent,
                                         nsIAtom* aPseudoTagOrNull);

  /**
   * Clears the ServoElementData and HasDirtyDescendants from all elements
   * in the subtree rooted at aElement.
   */
  static void ClearServoDataFromSubtree(Element* aElement);

  /**
   * Clears HasDirtyDescendants and RestyleData from all elements in the
   * subtree rooted at aElement.
   */
  static void ClearRestyleStateFromSubtree(Element* aElement);

  /**
   * Posts restyle hints for animations.
   * This is only called for the second traversal for CSS animations during
   * updating CSS animations in a SequentialTask.
   * This function does neither register a refresh observer nor flag that a
   * style flush is needed since this function is supposed to be called during
   * restyling process and this restyle event will be processed in the second
   * traversal of the same restyling process.
   */
  static void PostRestyleEventForAnimations(dom::Element* aElement,
                                            CSSPseudoElementType aPseudoType,
                                            nsRestyleHint aRestyleHint);
protected:
  ~ServoRestyleManager() override
  {
    MOZ_ASSERT(!mReentrantChanges);
  }

private:
  /**
   * Performs post-Servo-traversal processing on this element and its
   * descendants.
   *
   * Returns whether any style did actually change. There may be cases where we
   * didn't need to change any style after all, for example, when a content
   * attribute changes that happens not to have any effect on the style of that
   * element or any descendant or sibling.
   */
  bool ProcessPostTraversal(Element* aElement,
                            nsStyleContext* aParentContext,
                            ServoStyleSet* aStyleSet,
                            nsStyleChangeList& aChangeList);

  struct TextPostTraversalState;
  bool ProcessPostTraversalForText(nsIContent* aTextNode,
                                   nsStyleChangeList& aChangeList,
                                   TextPostTraversalState& aState);

  inline ServoStyleSet* StyleSet() const
  {
    MOZ_ASSERT(PresContext()->StyleSet()->IsServo(),
               "ServoRestyleManager should only be used with a Servo-flavored "
               "style backend");
    return PresContext()->StyleSet()->AsServo();
  }

  const SnapshotTable& Snapshots() const { return mSnapshots; }
  void ClearSnapshots();
  ServoElementSnapshot& SnapshotFor(mozilla::dom::Element* aElement);

  void DoProcessPendingRestyles(TraversalRestyleBehavior aRestyleBehavior);

  // We use a separate data structure from nsStyleChangeList because we need a
  // frame to create nsStyleChangeList entries, and the primary frame may not be
  // attached yet.
  struct ReentrantChange {
    nsCOMPtr<nsIContent> mContent;
    nsChangeHint mHint;
  };
  typedef AutoTArray<ReentrantChange, 10> ReentrantChangeList;

  // Only non-null while processing change hints. See the comment in
  // ProcessPendingRestyles.
  ReentrantChangeList* mReentrantChanges;

  // We use this flag to track if the current restyle contains any non-animation
  // update, which triggers a normal restyle, and so there might be any new
  // transition created later. Therefore, if this flag is true, we need to
  // increase mAnimationGeneration before creating new transitions, so their
  // creation sequence will be correct.
  bool mHaveNonAnimationRestyles = false;

  // Set to true when posting restyle events triggered by CSS rule changes.
  // This flag is cleared once ProcessPendingRestyles has completed.
  // When we process a traversal all descendants elements of the document
  // triggered by CSS rule changes, we will need to update all elements with
  // CSS animations.  We propagate TraversalRestyleBehavior::ForCSSRuleChanges
  // to traversal function if this flag is set.
  bool mRestyleForCSSRuleChanges = false;

  // A hashtable with the elements that have changed state or attributes, in
  // order to calculate restyle hints during the traversal.
  SnapshotTable mSnapshots;
};

} // namespace mozilla

#endif // mozilla_ServoRestyleManager_h
