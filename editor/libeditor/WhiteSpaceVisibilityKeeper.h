/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef WhiteSpaceVisibilityKeeper_h
#define WhiteSpaceVisibilityKeeper_h

#include "EditAction.h"
#include "EditorBase.h"
#include "EditorForwards.h"
#include "EditorDOMPoint.h"  // for EditorDOMPoint
#include "EditorUtils.h"     // for CaretPoint
#include "HTMLEditHelpers.h"
#include "HTMLEditor.h"
#include "HTMLEditUtils.h"
#include "WSRunScanner.h"

#include "mozilla/Assertions.h"
#include "mozilla/Maybe.h"
#include "mozilla/Result.h"
#include "mozilla/StaticPrefs_editor.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLBRElement.h"
#include "mozilla/dom/Text.h"
#include "nsCOMPtr.h"
#include "nsIContent.h"

namespace mozilla {

/**
 * WhiteSpaceVisibilityKeeper class helps `HTMLEditor` modifying the DOM tree
 * with keeps white-space sequence visibility automatically.  E.g., invisible
 * leading/trailing white-spaces becomes visible, this class members delete
 * them.  E.g., when splitting visible-white-space sequence, this class may
 * replace ASCII white-spaces at split edges with NBSPs.
 */
class WhiteSpaceVisibilityKeeper final {
 private:
  using AutoTransactionsConserveSelection =
      EditorBase::AutoTransactionsConserveSelection;
  using EditorType = EditorBase::EditorType;
  using Element = dom::Element;
  using HTMLBRElement = dom::HTMLBRElement;
  using IgnoreNonEditableNodes = WSRunScanner::IgnoreNonEditableNodes;
  using InsertTextTo = EditorBase::InsertTextTo;
  using LineBreakType = HTMLEditor::LineBreakType;
  using PointPosition = WSRunScanner::PointPosition;
  using ReferHTMLDefaultStyle = WSRunScanner::ReferHTMLDefaultStyle;
  using TextFragmentData = WSRunScanner::TextFragmentData;
  using VisibleWhiteSpacesData = WSRunScanner::VisibleWhiteSpacesData;

 public:
  WhiteSpaceVisibilityKeeper() = delete;
  explicit WhiteSpaceVisibilityKeeper(
      const WhiteSpaceVisibilityKeeper& aOther) = delete;
  WhiteSpaceVisibilityKeeper(WhiteSpaceVisibilityKeeper&& aOther) = delete;

  /**
   * Remove invisible leading white-spaces and trailing white-spaces if there
   * are around aPoint.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<CaretPoint, nsresult>
  DeleteInvisibleASCIIWhiteSpaces(HTMLEditor& aHTMLEditor,
                                  const EditorDOMPoint& aPoint);

  /**
   * PrepareToSplitBlockElement() makes sure that the invisible white-spaces
   * not to become visible and returns splittable point.
   *
   * @param aHTMLEditor         The HTML editor.
   * @param aPointToSplit       The splitting point in aSplittingBlockElement.
   * @param aSplittingBlockElement  A block element which will be split.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  PrepareToSplitBlockElement(HTMLEditor& aHTMLEditor,
                             const EditorDOMPoint& aPointToSplit,
                             const Element& aSplittingBlockElement);

  enum class NormalizeOption {
    // If set, don't normalize white-spaces before the point.
    HandleOnlyFollowingWhiteSpaces,
    // If set, don't normalize white-spaces after the point.
    HandleOnlyPrecedingWhiteSpaces,
    // If set, don't normalize following white-spaces if starts with an NBSP.
    StopIfFollowingWhiteSpacesStartsWithNBSP,
    // If set, don't normalize preceding white-spaces if ends with an NBSP.
    StopIfPrecedingWhiteSpacesEndsWithNBP,
  };
  using NormalizeOptions = EnumSet<NormalizeOption>;

  /**
   * Normalize preceding white-spaces of aPoint.  aPoint should not be middle of
   * a Text node.
   *
   * @return If this updates some characters of the last `Text` node, this
   * returns the end of the `Text`.  Otherwise, this returns the position
   * of the found `Text` which ends with a visible character or aPoint.
   * Note that returning aPoint does not mean nothing is changed.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  NormalizeWhiteSpacesBefore(HTMLEditor& aHTMLEditor,
                             const EditorDOMPoint& aPoint,
                             NormalizeOptions aOptions);

  /**
   * Normalize following white-spaces of aPoint.  aPoint should not be middle of
   * a Text node.
   *
   * @return If this updates some characters of the first `Text` node, this
   * returns the start of the `Text`.  Otherwise, this returns the position
   * of the found `Text` which starts with a visible character or aPoint.
   * Note that returning aPoint does not mean nothing is changed.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  NormalizeWhiteSpacesAfter(HTMLEditor& aHTMLEditor,
                            const EditorDOMPoint& aPoint,
                            NormalizeOptions aOptions);

  /**
   * Normalize surrounding white-spaces of aPointToSplit.  This may normalize
   * 2 `Text` nodes if the point is surrounded by them.
   * Note that this is designed only for the new normalizer.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  NormalizeWhiteSpacesToSplitAt(HTMLEditor& aHTMLEditor,
                                const EditorDOMPoint& aPointToSplit,
                                NormalizeOptions aOptions);

  /**
   * Normalize surrounding white-spaces of both boundaries of aRangeToDelete.
   * This returns the range which should be deleted later.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMRange, nsresult>
  NormalizeSurroundingWhiteSpacesToJoin(HTMLEditor& aHTMLEditor,
                                        const EditorDOMRange& aRangeToDelete);

  /**
   * MergeFirstLineOfRightBlockElementIntoDescendantLeftBlockElement() merges
   * first line in aRightBlockElement into end of aLeftBlockElement which
   * is a descendant of aRightBlockElement.
   *
   * @param aHTMLEditor         The HTML editor.
   * @param aLeftBlockElement   The content will be merged into end of
   *                            this element.
   * @param aRightBlockElement  The first line in this element will be
   *                            moved to aLeftBlockElement.
   * @param aAtRightBlockChild  At a child of aRightBlockElement and inclusive
   *                            ancestor of aLeftBlockElement.
   * @param aListElementTagName Set some if aRightBlockElement is a list
   *                            element and it'll be merged with another
   *                            list element.
   * @param aEditingHost        The editing host.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<MoveNodeResult, nsresult>
  MergeFirstLineOfRightBlockElementIntoDescendantLeftBlockElement(
      HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
      Element& aRightBlockElement, const EditorDOMPoint& aAtRightBlockChild,
      const Maybe<nsAtom*>& aListElementTagName,
      const HTMLBRElement* aPrecedingInvisibleBRElement,
      const Element& aEditingHost);

  /**
   * MergeFirstLineOfRightBlockElementIntoAncestorLeftBlockElement() merges
   * first line in aRightBlockElement into end of aLeftBlockElement which
   * is an ancestor of aRightBlockElement, then, removes aRightBlockElement
   * if it becomes empty.
   *
   * @param aHTMLEditor         The HTML editor.
   * @param aLeftBlockElement   The content will be merged into end of
   *                            this element.
   * @param aRightBlockElement  The first line in this element will be
   *                            moved to aLeftBlockElement and maybe
   *                            removed when this becomes empty.
   * @param aAtLeftBlockChild   At a child of aLeftBlockElement and inclusive
   *                            ancestor of aRightBlockElement.
   * @param aLeftContentInBlock The content whose inclusive ancestor is
   *                            aLeftBlockElement.
   * @param aListElementTagName Set some if aRightBlockElement is a list
   *                            element and it'll be merged with another
   *                            list element.
   * @param aEditingHost        The editing host.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<MoveNodeResult, nsresult>
  MergeFirstLineOfRightBlockElementIntoAncestorLeftBlockElement(
      HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
      Element& aRightBlockElement, const EditorDOMPoint& aAtLeftBlockChild,
      nsIContent& aLeftContentInBlock,
      const Maybe<nsAtom*>& aListElementTagName,
      const HTMLBRElement* aPrecedingInvisibleBRElement,
      const Element& aEditingHost);

  /**
   * MergeFirstLineOfRightBlockElementIntoLeftBlockElement() merges first
   * line in aRightBlockElement into end of aLeftBlockElement and removes
   * aRightBlockElement when it has only one line.
   *
   * @param aHTMLEditor         The HTML editor.
   * @param aLeftBlockElement   The content will be merged into end of
   *                            this element.
   * @param aRightBlockElement  The first line in this element will be
   *                            moved to aLeftBlockElement and maybe
   *                            removed when this becomes empty.
   * @param aListElementTagName Set some if aRightBlockElement is a list
   *                            element and its type needs to be changed.
   * @param aEditingHost        The editing host.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<MoveNodeResult, nsresult>
  MergeFirstLineOfRightBlockElementIntoLeftBlockElement(
      HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
      Element& aRightBlockElement, const Maybe<nsAtom*>& aListElementTagName,
      const HTMLBRElement* aPrecedingInvisibleBRElement,
      const Element& aEditingHost);

  /**
   * InsertLineBreak() inserts a line break at (before) aPointToInsert and
   * delete unnecessary white-spaces around there and/or replaces white-spaces
   * with non-breaking spaces.  Note that if the point is in a text node, the
   * text node will be split and insert new <br> node between the left node
   * and the right node.
   *
   * @param aPointToInsert  The point to insert new line break.  Note that
   *                        it'll be inserted before this point.  I.e., the
   *                        point will be the point of new line break.
   * @return                If succeeded, returns the new line break and
   *                        point to put caret.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<CreateLineBreakResult,
                                                 nsresult>
  InsertLineBreak(LineBreakType aLineBreakType, HTMLEditor& aHTMLEditor,
                  const EditorDOMPoint& aPointToInsert);

  using InsertTextFor = EditorBase::InsertTextFor;

  /**
   * Insert aStringToInsert to aPointToInsert and makes any needed adjustments
   * to white-spaces around the insertion point.
   *
   * @param aStringToInsert     The string to insert.
   * @param aRangeToBeReplaced  The range to be replaced.
   * @param aInsertTextTo       Whether forcibly creates a new `Text` node in
   *                            specific condition or use existing `Text` if
   *                            available.
   * @param aEditingHost        The editing host at aPointToInsert.
   */
  template <typename EditorDOMPointType>
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<InsertTextResult, nsresult>
  InsertText(HTMLEditor& aHTMLEditor, const nsAString& aStringToInsert,
             const EditorDOMPointType& aPointToInsert,
             InsertTextTo aInsertTextTo, const Element& aEditingHost) {
    return WhiteSpaceVisibilityKeeper::
        InsertTextOrInsertOrUpdateCompositionString(
            aHTMLEditor, aStringToInsert, EditorDOMRange(aPointToInsert),
            aInsertTextTo, InsertTextFor::NormalText, aEditingHost);
  }

  /**
   * Insert aCompositionString to the start boundary of aCompositionStringRange
   * or update existing composition string with aCompositionString.
   * If inserting composition string, this may normalize white-spaces around
   * there.  However, if updating composition string, this will skip it to
   * avoid CompositionTransaction work.
   *
   * @param aCompositionString  The new composition string.
   * @param aCompositionStringRange
   *                            If there is old composition string, this should
   *                            cover all of it.  Otherwise, this should be
   *                            collapsed and indicate the insertion point.
   * @param aEditingHost        The editing host at aCompositionStringRange.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<InsertTextResult, nsresult>
  InsertOrUpdateCompositionString(HTMLEditor& aHTMLEditor,
                                  const nsAString& aCompositionString,
                                  const EditorDOMRange& aCompositionStringRange,
                                  InsertTextFor aPurpose,
                                  const Element& aEditingHost) {
    MOZ_ASSERT(EditorBase::InsertingTextForComposition(aPurpose));
    return InsertTextOrInsertOrUpdateCompositionString(
        aHTMLEditor, aCompositionString, aCompositionStringRange,
        HTMLEditor::InsertTextTo::ExistingTextNodeIfAvailable, aPurpose,
        aEditingHost);
  }

  /**
   * Normalize white-space sequence containing aPoint or starts from next to
   * aPoint.  This assumes all white-spaces in the sequence is visible.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static nsresult
  NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces(
      HTMLEditor& aHTMLEditor, const EditorDOMPointInText& aPoint);

  /**
   * Delete aContentToDelete and may remove/replace white-spaces around it.
   * Then, if deleting content makes 2 text nodes around it are adjacent
   * siblings, this joins them and put selection at the joined point.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<CaretPoint, nsresult>
  DeleteContentNodeAndJoinTextNodesAroundIt(HTMLEditor& aHTMLEditor,
                                            nsIContent& aContentToDelete,
                                            const EditorDOMPoint& aCaretPoint,
                                            const Element& aEditingHost);

 private:
  /**
   * Normalize surrounding white-spaces of aPointToSplit.
   *
   * @return The split point which you specified before.  Note that the result
   *         may be different from aPointToSplit if this deletes some invisible
   *         white-spaces.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  NormalizeWhiteSpacesToSplitTextNodeAt(
      HTMLEditor& aHTMLEditor, const EditorDOMPointInText& aPointToSplit,
      NormalizeOptions aOptions);

  /**
   * Normalize surrounding white-spaces of the range between aOffset - aOffset +
   * aLength.
   *
   * @return The delete range after normalized.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMRange, nsresult>
  NormalizeSurroundingWhiteSpacesToDeleteCharacters(HTMLEditor& aHTMLEditor,
                                                    dom::Text& aTextNode,
                                                    uint32_t aOffset,
                                                    uint32_t aLength);

  /**
   * Delete leading or trailing invisible white-spaces around block boundaries
   * or collapsed white-spaces in a white-space sequence if aPoint is around
   * them.
   *
   * @param aHTMLEditor The HTMLEditor.
   * @param aPoint      Point must be in an editable content node.
   * @return            If deleted some invisible white-spaces, returns the
   *                    removed point.
   *                    If this does nothing, returns unset point.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  EnsureNoInvisibleWhiteSpaces(HTMLEditor& aHTMLEditor,
                               const EditorDOMPoint& aPoint);

  /**
   * Delete preceding invisible white-spaces before aPoint.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static nsresult
  EnsureNoInvisibleWhiteSpacesBefore(HTMLEditor& aHTMLEditor,
                                     const EditorDOMPoint& aPoint);

  /**
   * Delete following invisible white-spaces after aPoint.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static nsresult
  EnsureNoInvisibleWhiteSpacesAfter(HTMLEditor& aHTMLEditor,
                                    const EditorDOMPoint& aPoint);

  /**
   * If aPoint points a collapsible white-space, normalize entire the
   * white-space sequence.
   *
   * @return Equivalent point of aPoint after normalizing the white-spaces.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<EditorDOMPoint, nsresult>
  NormalizeWhiteSpacesAt(HTMLEditor& aHTMLEditor,
                         const EditorDOMPointInText& aPoint);

  /**
   * Insert aStringToInsert to aRangeToBeReplaced.StartRef() with normalizing
   * white-spaces around there.
   *
   * @param aStringToInsert     The string to insert.
   * @param aRangeToBeReplaced  If you insert non-composing text, this MUST be
   *                            collapsed to the insertion point.
   *                            If you update composition string, this may be
   *                            not collapsed.  The range is required to
   *                            normalizing the new composition string.
   *                            Therefore, this should match the range of the
   *                            latest composition string.
   * @param aInsertTextTo       Whether forcibly creates a new `Text` node in
   *                            specific condition or use existing `Text` if
   *                            available.
   * @param aPurpose            Whether it's handling normal text input or
   *                            updating composition.
   * @param aEditingHost        The editing host at aRangeToBeReplaced.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT static Result<InsertTextResult, nsresult>
  InsertTextOrInsertOrUpdateCompositionString(
      HTMLEditor& aHTMLEditor, const nsAString& aStringToInsert,
      const EditorDOMRange& aRangeToBeReplaced, InsertTextTo aInsertTextTo,
      InsertTextFor aPurpose, const Element& aEditingHost);
};

}  // namespace mozilla

#endif  // #ifndef WhiteSpaceVisibilityKeeper_h
