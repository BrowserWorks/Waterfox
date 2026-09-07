/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WhiteSpaceVisibilityKeeper.h"

#include "EditorDOMPoint.h"
#include "EditorUtils.h"
#include "ErrorList.h"
#include "HTMLEditHelpers.h"  // for MoveNodeResult, SplitNodeResult
#include "HTMLEditor.h"
#include "HTMLEditorNestedClasses.h"  // for AutoMoveOneLineHandler
#include "HTMLEditUtils.h"
#include "SelectionState.h"

#include "mozilla/Assertions.h"
#include "mozilla/SelectionState.h"
#include "mozilla/OwningNonNull.h"
#include "mozilla/StaticPrefs_editor.h"  // for StaticPrefs::editor_*
#include "mozilla/dom/AncestorIterator.h"

#include "nsCRT.h"
#include "nsContentUtils.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsIContent.h"
#include "nsIContentInlines.h"
#include "nsString.h"

namespace mozilla {

using namespace dom;

using EmptyCheckOption = HTMLEditUtils::EmptyCheckOption;
using LeafNodeOption = HTMLEditUtils::LeafNodeOption;
using TreatInvisibleLineBreakAs = HTMLEditUtils::TreatInvisibleLineBreakAs;

Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::PrepareToSplitBlockElement(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPointToSplit,
    const Element& aSplittingBlockElement) {
  if (NS_WARN_IF(!aPointToSplit.IsInContentNodeAndValidInComposedDoc()) ||
      NS_WARN_IF(!HTMLEditUtils::IsSplittableNode(aSplittingBlockElement)) ||
      NS_WARN_IF(!EditorUtils::IsEditableContent(
          *aPointToSplit.ContainerAs<nsIContent>(), EditorType::HTML))) {
    return Err(NS_ERROR_FAILURE);
  }

  // The container of aPointToSplit may be not splittable, e.g., selection
  // may be collapsed **in** a `<br>` element or a comment node.  So, look
  // for splittable point with climbing the tree up.
  EditorDOMPoint pointToSplit(aPointToSplit);
  for (nsIContent* content : aPointToSplit.ContainerAs<nsIContent>()
                                 ->InclusiveAncestorsOfType<nsIContent>()) {
    if (content == &aSplittingBlockElement) {
      break;
    }
    if (HTMLEditUtils::IsSplittableNode(*content)) {
      break;
    }
    pointToSplit.Set(content);
  }

  // NOTE: Chrome does not normalize white-spaces at splitting `Text` when
  // inserting a paragraph at least when the surrounding white-spaces being or
  // end with an NBSP.
  Result<EditorDOMPoint, nsresult> pointToSplitOrError =
      WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitAt(
          aHTMLEditor, pointToSplit,
          {NormalizeOption::StopIfFollowingWhiteSpacesStartsWithNBSP,
           NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP});
  if (MOZ_UNLIKELY(pointToSplitOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitAt() failed");
    return pointToSplitOrError.propagateErr();
  }
  pointToSplit = pointToSplitOrError.unwrap();

  if (NS_WARN_IF(!pointToSplit.IsInContentNode()) ||
      NS_WARN_IF(
          !pointToSplit.ContainerAs<nsIContent>()->IsInclusiveDescendantOf(
              &aSplittingBlockElement)) ||
      NS_WARN_IF(!HTMLEditUtils::IsSplittableNode(aSplittingBlockElement)) ||
      NS_WARN_IF(!HTMLEditUtils::IsSplittableNode(
          *pointToSplit.ContainerAs<nsIContent>()))) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }

  return pointToSplit;
}

// static
Result<MoveNodeResult, nsresult> WhiteSpaceVisibilityKeeper::
    MergeFirstLineOfRightBlockElementIntoDescendantLeftBlockElement(
        HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
        Element& aRightBlockElement, const EditorDOMPoint& aAtRightBlockChild,
        const Maybe<nsAtom*>& aListElementTagName,
        const HTMLBRElement* aPrecedingInvisibleBRElement,
        const Element& aEditingHost) {
  MOZ_ASSERT(
      EditorUtils::IsDescendantOf(aLeftBlockElement, aRightBlockElement));
  MOZ_ASSERT(&aRightBlockElement == aAtRightBlockChild.GetContainer());

  OwningNonNull<Element> rightBlockElement = aRightBlockElement;
  EditorDOMPoint afterRightBlockChild = aAtRightBlockChild.NextPoint();
  {
    AutoTrackDOMPoint trackAfterRightBlockChild(aHTMLEditor.RangeUpdaterRef(),
                                                &afterRightBlockChild);
    // First, delete invisible white-spaces at start of the right block and
    // normalize the leading visible white-spaces.
    nsresult rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter(
        aHTMLEditor, afterRightBlockChild);
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter() "
          "failed");
      return Err(rv);
    }
    // Next, delete invisible white-spaces at end of the left block and
    // normalize the trailing visible white-spaces.
    rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
        aHTMLEditor, EditorDOMPoint::AtEndOf(aLeftBlockElement));
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore() "
          "failed");
      return Err(rv);
    }
    trackAfterRightBlockChild.Flush(StopTracking::Yes);
    if (NS_WARN_IF(afterRightBlockChild.GetContainer() !=
                   &aRightBlockElement)) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  // Finally, make sure that we won't create new invisible white-spaces.
  {
    AutoTrackDOMPoint trackAfterRightBlockChild(aHTMLEditor.RangeUpdaterRef(),
                                                &afterRightBlockChild);
    Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
            aHTMLEditor, afterRightBlockChild,
            {NormalizeOption::StopIfFollowingWhiteSpacesStartsWithNBSP});
    if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
      return atFirstVisibleThingOrError.propagateErr();
    }
    Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(
            aHTMLEditor, EditorDOMPoint::AtEndOf(aLeftBlockElement), {});
    if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
      return afterLastVisibleThingOrError.propagateErr();
    }
  }

  // XXX And afterRightBlockChild.GetContainerAs<Element>() always returns
  //     an element pointer so that probably here should not use
  //     accessors of EditorDOMPoint, should use DOM API directly instead.
  if (afterRightBlockChild.GetContainerAs<Element>()) {
    rightBlockElement = *afterRightBlockChild.ContainerAs<Element>();
  } else if (NS_WARN_IF(
                 !afterRightBlockChild.GetContainerParentAs<Element>())) {
    return Err(NS_ERROR_UNEXPECTED);
  } else {
    rightBlockElement = *afterRightBlockChild.GetContainerParentAs<Element>();
  }

  auto atStartOfRightText = [&]() MOZ_NEVER_INLINE_DEBUG -> EditorDOMPoint {
    const WSRunScanner scanner({}, EditorRawDOMPoint(&aRightBlockElement, 0u));
    for (EditorRawDOMPointInText atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 EditorRawDOMPoint(&aRightBlockElement, 0u));
         atFirstChar.IsSet();
         atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 atFirstChar.AfterContainer<EditorRawDOMPoint>())) {
      if (atFirstChar.IsContainerEmpty()) {
        continue;  // Ignore empty text node.
      }
      if (atFirstChar.IsCharASCIISpaceOrNBSP() &&
          HTMLEditUtils::IsSimplyEditableNode(
              *atFirstChar.ContainerAs<Text>())) {
        return atFirstChar.To<EditorDOMPoint>();
      }
      break;
    }
    return EditorDOMPoint();
  }();
  AutoTrackDOMPoint trackStartOfRightText(aHTMLEditor.RangeUpdaterRef(),
                                          &atStartOfRightText);

  // Do br adjustment.
  // XXX Why don't we delete the <br> first? If so, we can skip to track the
  // MoveNodeResult at last.
  const RefPtr<HTMLBRElement> invisibleBRElementAtEndOfLeftBlockElement =
      WSRunScanner::GetPrecedingBRElementUnlessVisibleContentFound(
          {WSRunScanner::Option::OnlyEditableNodes},
          EditorDOMPoint::AtEndOf(aLeftBlockElement));
  NS_ASSERTION(
      aPrecedingInvisibleBRElement == invisibleBRElementAtEndOfLeftBlockElement,
      "The preceding invisible BR element computation was different");
  auto moveContentResult = [&]() MOZ_NEVER_INLINE_DEBUG MOZ_CAN_RUN_SCRIPT
      -> Result<MoveNodeResult, nsresult> {
    // NOTE: Keep syncing with CanMergeLeftAndRightBlockElements() of
    //       AutoInclusiveAncestorBlockElementsJoiner.
    if (NS_WARN_IF(aListElementTagName.isSome())) {
      // Since 2002, here was the following comment:
      // > The idea here is to take all children in rightListElement that are
      // > past offset, and pull them into leftlistElement.
      // However, this has never been performed because we are here only when
      // neither left list nor right list is a descendant of the other but
      // in such case, getting a list item in the right list node almost
      // always failed since a variable for offset of
      // rightListElement->GetChildAt() was not initialized.  So, it might be
      // a bug, but we should keep this traditional behavior for now.  If you
      // find when we get here, please remove this comment if we don't need to
      // do it.  Otherwise, please move children of the right list node to the
      // end of the left list node.

      // XXX Although, we do nothing here, but for keeping traditional
      //     behavior, we should mark as handled.
      return MoveNodeResult::HandledResult(
          EditorDOMPoint::AtEndOf(aLeftBlockElement));
    }

    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    // XXX Why do we ignore the result of AutoMoveOneLineHandler::Run()?
    NS_ASSERTION(rightBlockElement == afterRightBlockChild.GetContainer(),
                 "The relation is not guaranteed but assumed");
#ifdef DEBUG
    Result<bool, nsresult> firstLineHasContent =
        HTMLEditor::AutoMoveOneLineHandler::CanMoveOrDeleteSomethingInLine(
            EditorDOMPoint(rightBlockElement, afterRightBlockChild.Offset()),
            aEditingHost);
#endif  // #ifdef DEBUG
    HTMLEditor::AutoMoveOneLineHandler lineMoverToEndOfLeftBlock(
        aLeftBlockElement);
    nsresult rv = lineMoverToEndOfLeftBlock.Prepare(
        aHTMLEditor,
        EditorDOMPoint(rightBlockElement, afterRightBlockChild.Offset()),
        aEditingHost);
    if (NS_FAILED(rv)) {
      NS_WARNING("AutoMoveOneLineHandler::Prepare() failed");
      return Err(rv);
    }
    MoveNodeResult moveResult = MoveNodeResult::IgnoredResult(
        EditorDOMPoint::AtEndOf(aLeftBlockElement));
    AutoTrackDOMMoveNodeResult trackMoveResult(aHTMLEditor.RangeUpdaterRef(),
                                               &moveResult);
    Result<MoveNodeResult, nsresult> moveFirstLineResult =
        lineMoverToEndOfLeftBlock.Run(aHTMLEditor, aEditingHost);
    if (MOZ_UNLIKELY(moveFirstLineResult.isErr())) {
      NS_WARNING("AutoMoveOneLineHandler::Run() failed");
      return moveFirstLineResult.propagateErr();
    }
    trackMoveResult.Flush(StopTracking::Yes);

#ifdef DEBUG
    MOZ_ASSERT(!firstLineHasContent.isErr());
    if (firstLineHasContent.inspect()) {
      NS_ASSERTION(moveFirstLineResult.inspect().Handled(),
                   "Failed to consider whether moving or not something");
    } else {
      NS_ASSERTION(moveFirstLineResult.inspect().Ignored(),
                   "Failed to consider whether moving or not something");
    }
#endif  // #ifdef DEBUG

    moveResult |= moveFirstLineResult.unwrap();
    // Now, all children of rightBlockElement were moved to leftBlockElement.
    // So, afterRightBlockChild is now invalid.
    afterRightBlockChild.Clear();

    return std::move(moveResult);
  }();
  if (MOZ_UNLIKELY(moveContentResult.isErr())) {
    return moveContentResult;
  }

  MoveNodeResult unwrappedMoveContentResult = moveContentResult.unwrap();

  trackStartOfRightText.Flush(StopTracking::Yes);
  if (atStartOfRightText.IsInTextNode() &&
      atStartOfRightText.IsSetAndValidInComposedDoc() &&
      atStartOfRightText.IsMiddleOfContainer()) {
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    Result<EditorDOMPoint, nsresult> startOfRightTextOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt(
            aHTMLEditor, atStartOfRightText.AsInText());
    if (MOZ_UNLIKELY(startOfRightTextOrError.isErr())) {
      NS_WARNING("WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt() failed");
      return startOfRightTextOrError.propagateErr();
    }
  }

  if (!invisibleBRElementAtEndOfLeftBlockElement ||
      !invisibleBRElementAtEndOfLeftBlockElement->IsInComposedDoc()) {
    return std::move(unwrappedMoveContentResult);
  }

  {
    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(
        *invisibleBRElementAtEndOfLeftBlockElement);
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed, but ignored");
      unwrappedMoveContentResult.IgnoreCaretPointSuggestion();
      return Err(rv);
    }
  }
  return std::move(unwrappedMoveContentResult);
}

// static
Result<MoveNodeResult, nsresult> WhiteSpaceVisibilityKeeper::
    MergeFirstLineOfRightBlockElementIntoAncestorLeftBlockElement(
        HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
        Element& aRightBlockElement, const EditorDOMPoint& aAtLeftBlockChild,
        nsIContent& aLeftContentInBlock,
        const Maybe<nsAtom*>& aListElementTagName,
        const HTMLBRElement* aPrecedingInvisibleBRElement,
        const Element& aEditingHost) {
  MOZ_ASSERT(
      EditorUtils::IsDescendantOf(aRightBlockElement, aLeftBlockElement));
  MOZ_ASSERT(
      &aLeftBlockElement == &aLeftContentInBlock ||
      EditorUtils::IsDescendantOf(aLeftContentInBlock, aLeftBlockElement));
  MOZ_ASSERT(&aLeftBlockElement == aAtLeftBlockChild.GetContainer());

  OwningNonNull<Element> originalLeftBlockElement = aLeftBlockElement;
  OwningNonNull<Element> leftBlockElement = aLeftBlockElement;
  EditorDOMPoint atLeftBlockChild(aAtLeftBlockChild);
  // First, delete invisible white-spaces before the right block.
  {
    AutoTrackDOMPoint tracker(aHTMLEditor.RangeUpdaterRef(), &atLeftBlockChild);
    nsresult rv =
        WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
            aHTMLEditor, EditorDOMPoint(&aRightBlockElement));
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore() "
          "failed");
      return Err(rv);
    }
    // Next, delete invisible white-spaces at start of the right block.
    rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter(
        aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u));
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter() "
          "failed");
      return Err(rv);
    }
    tracker.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!atLeftBlockChild.IsInContentNodeAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  // Finally, make sure that we won't create new invisible white-spaces.
  AutoTrackDOMPoint tracker(aHTMLEditor.RangeUpdaterRef(), &atLeftBlockChild);
  Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
      WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
          aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u),
          {NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP});
  if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
    return afterLastVisibleThingOrError.propagateErr();
  }
  Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
      WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(
          aHTMLEditor, atLeftBlockChild, {});
  if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
    return atFirstVisibleThingOrError.propagateErr();
  }
  tracker.Flush(StopTracking::Yes);
  if (NS_WARN_IF(!atLeftBlockChild.IsInContentNodeAndValidInComposedDoc())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }

  // XXX atLeftBlockChild.GetContainerAs<Element>() should always return
  //     an element pointer so that probably here should not use
  //     accessors of EditorDOMPoint, should use DOM API directly instead.
  if (Element* nearestAncestor =
          atLeftBlockChild.GetContainerOrContainerParentElement()) {
    leftBlockElement = *nearestAncestor;
  } else {
    return Err(NS_ERROR_UNEXPECTED);
  }

  auto atStartOfRightText = [&]() MOZ_NEVER_INLINE_DEBUG -> EditorDOMPoint {
    const WSRunScanner scanner({}, EditorRawDOMPoint(&aRightBlockElement, 0u));
    for (EditorRawDOMPointInText atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 EditorRawDOMPoint(&aRightBlockElement, 0u));
         atFirstChar.IsSet();
         atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 atFirstChar.AfterContainer<EditorRawDOMPoint>())) {
      if (atFirstChar.IsContainerEmpty()) {
        continue;  // Ignore empty text node.
      }
      if (atFirstChar.IsCharASCIISpaceOrNBSP() &&
          HTMLEditUtils::IsSimplyEditableNode(
              *atFirstChar.ContainerAs<Text>())) {
        return atFirstChar.To<EditorDOMPoint>();
      }
      break;
    }
    return EditorDOMPoint();
  }();
  AutoTrackDOMPoint trackStartOfRightText(aHTMLEditor.RangeUpdaterRef(),
                                          &atStartOfRightText);

  // Do br adjustment.
  // XXX Why don't we delete the <br> first? If so, we can skip to track the
  // MoveNodeResult at last.
  const RefPtr<HTMLBRElement> invisibleBRElementBeforeLeftBlockElement =
      WSRunScanner::GetPrecedingBRElementUnlessVisibleContentFound(
          {WSRunScanner::Option::OnlyEditableNodes}, atLeftBlockChild);
  NS_ASSERTION(
      aPrecedingInvisibleBRElement == invisibleBRElementBeforeLeftBlockElement,
      "The preceding invisible BR element computation was different");
  auto moveContentResult = [&]() MOZ_NEVER_INLINE_DEBUG MOZ_CAN_RUN_SCRIPT
      -> Result<MoveNodeResult, nsresult> {
    // NOTE: Keep syncing with CanMergeLeftAndRightBlockElements() of
    //       AutoInclusiveAncestorBlockElementsJoiner.
    if (aListElementTagName.isSome()) {
      // XXX Why do we ignore the error from MoveChildrenWithTransaction()?
      MOZ_ASSERT(originalLeftBlockElement == atLeftBlockChild.GetContainer(),
                 "This is not guaranteed, but assumed");
#ifdef DEBUG
      Result<bool, nsresult> rightBlockHasContent =
          aHTMLEditor.CanMoveChildren(aRightBlockElement, aLeftBlockElement);
#endif  // #ifdef DEBUG
      MoveNodeResult moveResult = MoveNodeResult::IgnoredResult(EditorDOMPoint(
          atLeftBlockChild.GetContainer(), atLeftBlockChild.Offset()));
      AutoTrackDOMMoveNodeResult trackMoveResult(aHTMLEditor.RangeUpdaterRef(),
                                                 &moveResult);
      // TODO: Stop using HTMLEditor::PreserveWhiteSpaceStyle::No due to no
      // tests.
      AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
      Result<MoveNodeResult, nsresult> moveChildrenResult =
          aHTMLEditor.MoveChildrenWithTransaction(
              aRightBlockElement, moveResult.NextInsertionPointRef(),
              HTMLEditor::PreserveWhiteSpaceStyle::No,
              HTMLEditor::RemoveIfInvisibleNode::Yes);
      if (MOZ_UNLIKELY(moveChildrenResult.isErr())) {
        if (NS_WARN_IF(moveChildrenResult.inspectErr() ==
                       NS_ERROR_EDITOR_DESTROYED)) {
          return moveChildrenResult;
        }
        NS_WARNING(
            "HTMLEditor::MoveChildrenWithTransaction() failed, but ignored");
      } else {
#ifdef DEBUG
        MOZ_ASSERT(!rightBlockHasContent.isErr());
        if (rightBlockHasContent.inspect()) {
          NS_ASSERTION(moveChildrenResult.inspect().Handled(),
                       "Failed to consider whether moving or not children");
        } else {
          NS_ASSERTION(moveChildrenResult.inspect().Ignored(),
                       "Failed to consider whether moving or not children");
        }
#endif  // #ifdef DEBUG
        trackMoveResult.Flush(StopTracking::Yes);
        moveResult |= moveChildrenResult.unwrap();
      }
      // atLeftBlockChild was moved to rightListElement.  So, it's invalid now.
      atLeftBlockChild.Clear();

      return std::move(moveResult);
    }

    // Left block is a parent of right block, and the parent of the previous
    // visible content.  Right block is a child and contains the contents we
    // want to move.
    EditorDOMPoint pointToMoveFirstLineContent;
    if (&aLeftContentInBlock == leftBlockElement) {
      // We are working with valid HTML, aLeftContentInBlock is a block
      // element, and is therefore allowed to contain aRightBlockElement. This
      // is the simple case, we will simply move the content in
      // aRightBlockElement out of its block.
      pointToMoveFirstLineContent = atLeftBlockChild;
      MOZ_ASSERT(pointToMoveFirstLineContent.GetContainer() ==
                 &aLeftBlockElement);
    } else {
      if (NS_WARN_IF(!aLeftContentInBlock.IsInComposedDoc())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
      // We try to work as well as possible with HTML that's already invalid.
      // Although "right block" is a block, and a block must not be contained
      // in inline elements, reality is that broken documents do exist.  The
      // DIRECT parent of "left NODE" might be an inline element.  Previous
      // versions of this code skipped inline parents until the first block
      // parent was found (and used "left block" as the destination).
      // However, in some situations this strategy moves the content to an
      // unexpected position.  (see bug 200416) The new idea is to make the
      // moving content a sibling, next to the previous visible content.
      pointToMoveFirstLineContent.SetAfter(&aLeftContentInBlock);
      if (NS_WARN_IF(!pointToMoveFirstLineContent.IsInContentNode())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
    }

    MOZ_ASSERT(pointToMoveFirstLineContent.IsSetAndValid());

    // Because we don't want the moving content to receive the style of the
    // previous content, we split the previous content's style.

#ifdef DEBUG
    Result<bool, nsresult> firstLineHasContent =
        HTMLEditor::AutoMoveOneLineHandler::CanMoveOrDeleteSomethingInLine(
            EditorDOMPoint(&aRightBlockElement, 0u), aEditingHost);
#endif  // #ifdef DEBUG

    if (&aLeftContentInBlock != &aEditingHost) {
      Result<SplitNodeResult, nsresult> splitNodeResult =
          aHTMLEditor.SplitAncestorStyledInlineElementsAt(
              pointToMoveFirstLineContent, EditorInlineStyle::RemoveAllStyles(),
              HTMLEditor::SplitAtEdges::eDoNotCreateEmptyContainer);
      if (MOZ_UNLIKELY(splitNodeResult.isErr())) {
        NS_WARNING("HTMLEditor::SplitAncestorStyledInlineElementsAt() failed");
        return splitNodeResult.propagateErr();
      }
      SplitNodeResult unwrappedSplitNodeResult = splitNodeResult.unwrap();
      nsresult rv = unwrappedSplitNodeResult.SuggestCaretPointTo(
          aHTMLEditor, {SuggestCaret::OnlyIfHasSuggestion,
                        SuggestCaret::OnlyIfTransactionsAllowedToDoIt});
      if (NS_FAILED(rv)) {
        NS_WARNING("SplitNodeResult::SuggestCaretPointTo() failed");
        return Err(rv);
      }
      if (!unwrappedSplitNodeResult.DidSplit()) {
        // If nothing was split, we should move the first line content to
        // after the parent inline elements.
        for (EditorDOMPoint parentPoint = pointToMoveFirstLineContent;
             pointToMoveFirstLineContent.IsEndOfContainer() &&
             pointToMoveFirstLineContent.IsInContentNode();
             pointToMoveFirstLineContent = EditorDOMPoint::After(
                 *pointToMoveFirstLineContent.ContainerAs<nsIContent>())) {
          if (pointToMoveFirstLineContent.GetContainer() ==
                  &aLeftBlockElement ||
              NS_WARN_IF(pointToMoveFirstLineContent.GetContainer() ==
                         &aEditingHost)) {
            break;
          }
        }
        if (NS_WARN_IF(!pointToMoveFirstLineContent.IsInContentNode())) {
          return Err(NS_ERROR_FAILURE);
        }
      } else if (unwrappedSplitNodeResult.Handled()) {
        // If se split something, we should move the first line contents
        // before the right elements.
        if (nsIContent* nextContentAtSplitPoint =
                unwrappedSplitNodeResult.GetNextContent()) {
          pointToMoveFirstLineContent.Set(nextContentAtSplitPoint);
          if (NS_WARN_IF(!pointToMoveFirstLineContent.IsInContentNode())) {
            return Err(NS_ERROR_FAILURE);
          }
        } else {
          pointToMoveFirstLineContent =
              unwrappedSplitNodeResult.AtSplitPoint<EditorDOMPoint>();
          if (NS_WARN_IF(!pointToMoveFirstLineContent.IsInContentNode())) {
            return Err(NS_ERROR_FAILURE);
          }
        }
      }
      MOZ_DIAGNOSTIC_ASSERT(pointToMoveFirstLineContent.IsSetAndValid());
    }

    MoveNodeResult moveResult =
        MoveNodeResult::IgnoredResult(pointToMoveFirstLineContent);
    HTMLEditor::AutoMoveOneLineHandler lineMoverToPoint(
        pointToMoveFirstLineContent);
    nsresult rv = lineMoverToPoint.Prepare(
        aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u), aEditingHost);
    if (NS_FAILED(rv)) {
      NS_WARNING("AutoMoveOneLineHandler::Prepare() failed");
      return Err(rv);
    }
    AutoTrackDOMMoveNodeResult trackMoveResult(aHTMLEditor.RangeUpdaterRef(),
                                               &moveResult);
    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    Result<MoveNodeResult, nsresult> moveFirstLineResult =
        lineMoverToPoint.Run(aHTMLEditor, aEditingHost);
    if (MOZ_UNLIKELY(moveFirstLineResult.isErr())) {
      NS_WARNING("AutoMoveOneLineHandler::Run() failed");
      return moveFirstLineResult.propagateErr();
    }

#ifdef DEBUG
    MOZ_ASSERT(!firstLineHasContent.isErr());
    if (firstLineHasContent.inspect()) {
      NS_ASSERTION(moveFirstLineResult.inspect().Handled(),
                   "Failed to consider whether moving or not something");
    } else {
      NS_ASSERTION(moveFirstLineResult.inspect().Ignored(),
                   "Failed to consider whether moving or not something");
    }
#endif  // #ifdef DEBUG

    trackMoveResult.Flush(StopTracking::Yes);
    moveResult |= moveFirstLineResult.unwrap();
    return std::move(moveResult);
  }();
  if (MOZ_UNLIKELY(moveContentResult.isErr())) {
    return moveContentResult;
  }

  MoveNodeResult unwrappedMoveContentResult = moveContentResult.unwrap();

  trackStartOfRightText.Flush(StopTracking::Yes);
  if (atStartOfRightText.IsInTextNode() &&
      atStartOfRightText.IsSetAndValidInComposedDoc() &&
      atStartOfRightText.IsMiddleOfContainer()) {
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    Result<EditorDOMPoint, nsresult> startOfRightTextOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt(
            aHTMLEditor, atStartOfRightText.AsInText());
    if (MOZ_UNLIKELY(startOfRightTextOrError.isErr())) {
      NS_WARNING("WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt() failed");
      return startOfRightTextOrError.propagateErr();
    }
  }

  if (!invisibleBRElementBeforeLeftBlockElement ||
      !invisibleBRElementBeforeLeftBlockElement->IsInComposedDoc()) {
    return std::move(unwrappedMoveContentResult);
  }

  {
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(
        *invisibleBRElementBeforeLeftBlockElement);
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed, but ignored");
      unwrappedMoveContentResult.IgnoreCaretPointSuggestion();
      return Err(rv);
    }
  }
  return std::move(unwrappedMoveContentResult);
}

// static
Result<MoveNodeResult, nsresult> WhiteSpaceVisibilityKeeper::
    MergeFirstLineOfRightBlockElementIntoLeftBlockElement(
        HTMLEditor& aHTMLEditor, Element& aLeftBlockElement,
        Element& aRightBlockElement, const Maybe<nsAtom*>& aListElementTagName,
        const HTMLBRElement* aPrecedingInvisibleBRElement,
        const Element& aEditingHost) {
  MOZ_ASSERT(
      !EditorUtils::IsDescendantOf(aLeftBlockElement, aRightBlockElement));
  MOZ_ASSERT(
      !EditorUtils::IsDescendantOf(aRightBlockElement, aLeftBlockElement));

  // First, delete invisible white-spaces at end of the left block
  nsresult rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
      aHTMLEditor, EditorDOMPoint::AtEndOf(aLeftBlockElement));
  if (NS_FAILED(rv)) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore() "
        "failed");
    return Err(rv);
  }
  // Next, delete invisible white-spaces at start of the right block and
  // normalize the leading visible white-spaces.
  rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter(
      aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u));
  if (NS_FAILED(rv)) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter() "
        "failed");
    return Err(rv);
  }
  // Finally, make sure to that we won't create new invisible white-spaces.
  Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
      WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
          aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u),
          {NormalizeOption::StopIfFollowingWhiteSpacesStartsWithNBSP});
  if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
    return atFirstVisibleThingOrError.propagateErr();
  }
  Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
      WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(
          aHTMLEditor, EditorDOMPoint::AtEndOf(aLeftBlockElement), {});
  if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore() failed");
    return afterLastVisibleThingOrError.propagateErr();
  }
  auto atStartOfRightText = [&]() MOZ_NEVER_INLINE_DEBUG -> EditorDOMPoint {
    const WSRunScanner scanner({}, EditorRawDOMPoint(&aRightBlockElement, 0u));
    for (EditorRawDOMPointInText atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 EditorRawDOMPoint(&aRightBlockElement, 0u));
         atFirstChar.IsSet();
         atFirstChar =
             scanner.GetInclusiveNextCharPoint<EditorRawDOMPointInText>(
                 atFirstChar.AfterContainer<EditorRawDOMPoint>())) {
      if (atFirstChar.IsContainerEmpty()) {
        continue;  // Ignore empty text node.
      }
      if (atFirstChar.IsCharASCIISpaceOrNBSP() &&
          HTMLEditUtils::IsSimplyEditableNode(
              *atFirstChar.ContainerAs<Text>())) {
        return atFirstChar.To<EditorDOMPoint>();
      }
      break;
    }
    return EditorDOMPoint();
  }();
  AutoTrackDOMPoint trackStartOfRightText(aHTMLEditor.RangeUpdaterRef(),
                                          &atStartOfRightText);
  // Do br adjustment.
  // XXX Why don't we delete the <br> first? If so, we can skip to track the
  // MoveNodeResult at last.
  const RefPtr<HTMLBRElement> invisibleBRElementAtEndOfLeftBlockElement =
      WSRunScanner::GetPrecedingBRElementUnlessVisibleContentFound(
          {WSRunScanner::Option::OnlyEditableNodes},
          EditorDOMPoint::AtEndOf(aLeftBlockElement));
  NS_ASSERTION(
      aPrecedingInvisibleBRElement == invisibleBRElementAtEndOfLeftBlockElement,
      "The preceding invisible BR element computation was different");
  auto moveContentResult = [&]() MOZ_NEVER_INLINE_DEBUG MOZ_CAN_RUN_SCRIPT
      -> Result<MoveNodeResult, nsresult> {
    if (aListElementTagName.isSome() ||
        // TODO: We should stop merging entire blocks even if they have same
        // white-space style because Chrome behave so.  However, it's risky to
        // change our behavior in the major cases so that we should do it in
        // a bug to manage only the change.
        (aLeftBlockElement.NodeInfo()->NameAtom() ==
             aRightBlockElement.NodeInfo()->NameAtom() &&
         EditorUtils::GetComputedWhiteSpaceStyles(aLeftBlockElement) ==
             EditorUtils::GetComputedWhiteSpaceStyles(aRightBlockElement))) {
      MoveNodeResult moveResult = MoveNodeResult::IgnoredResult(
          EditorDOMPoint::AtEndOf(aLeftBlockElement));
      AutoTrackDOMMoveNodeResult trackMoveResult(aHTMLEditor.RangeUpdaterRef(),
                                                 &moveResult);
      AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
      // Nodes are same type.  merge them.
      EditorDOMPoint atFirstChildOfRightNode;
      nsresult rv = aHTMLEditor.JoinNearestEditableNodesWithTransaction(
          aLeftBlockElement, aRightBlockElement, &atFirstChildOfRightNode);
      if (NS_WARN_IF(rv == NS_ERROR_EDITOR_DESTROYED)) {
        return Err(NS_ERROR_EDITOR_DESTROYED);
      }
      NS_WARNING_ASSERTION(
          NS_SUCCEEDED(rv),
          "HTMLEditor::JoinNearestEditableNodesWithTransaction()"
          " failed, but ignored");
      if (aListElementTagName.isSome() && atFirstChildOfRightNode.IsSet()) {
        Result<CreateElementResult, nsresult> convertListTypeResult =
            aHTMLEditor.ChangeListElementType(
                // XXX Shouldn't be aLeftBlockElement here?
                aRightBlockElement, MOZ_KnownLive(*aListElementTagName.ref()),
                *nsGkAtoms::li);
        if (MOZ_UNLIKELY(convertListTypeResult.isErr())) {
          if (NS_WARN_IF(convertListTypeResult.inspectErr() ==
                         NS_ERROR_EDITOR_DESTROYED)) {
            return Err(NS_ERROR_EDITOR_DESTROYED);
          }
          NS_WARNING("HTMLEditor::ChangeListElementType() failed, but ignored");
        } else {
          // There is AutoTransactionConserveSelection above, therefore, we
          // don't need to update selection here.
          convertListTypeResult.inspect().IgnoreCaretPointSuggestion();
        }
      }
      trackMoveResult.Flush(StopTracking::Yes);
      moveResult |= MoveNodeResult::HandledResult(
          EditorDOMPoint::AtEndOf(aLeftBlockElement));
      return std::move(moveResult);
    }

#ifdef DEBUG
    Result<bool, nsresult> firstLineHasContent =
        HTMLEditor::AutoMoveOneLineHandler::CanMoveOrDeleteSomethingInLine(
            EditorDOMPoint(&aRightBlockElement, 0u), aEditingHost);
#endif  // #ifdef DEBUG

    MoveNodeResult moveResult = MoveNodeResult::IgnoredResult(
        EditorDOMPoint::AtEndOf(aLeftBlockElement));
    // Nodes are dissimilar types.
    HTMLEditor::AutoMoveOneLineHandler lineMoverToEndOfLeftBlock(
        aLeftBlockElement);
    nsresult rv = lineMoverToEndOfLeftBlock.Prepare(
        aHTMLEditor, EditorDOMPoint(&aRightBlockElement, 0u), aEditingHost);
    if (NS_FAILED(rv)) {
      NS_WARNING("AutoMoveOneLineHandler::Prepare() failed");
      return Err(rv);
    }
    AutoTrackDOMMoveNodeResult trackMoveResult(aHTMLEditor.RangeUpdaterRef(),
                                               &moveResult);
    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    Result<MoveNodeResult, nsresult> moveFirstLineResult =
        lineMoverToEndOfLeftBlock.Run(aHTMLEditor, aEditingHost);
    if (MOZ_UNLIKELY(moveFirstLineResult.isErr())) {
      NS_WARNING("AutoMoveOneLineHandler::Run() failed");
      return moveFirstLineResult.propagateErr();
    }

#ifdef DEBUG
    MOZ_ASSERT(!firstLineHasContent.isErr());
    if (firstLineHasContent.inspect()) {
      NS_ASSERTION(moveFirstLineResult.inspect().Handled(),
                   "Failed to consider whether moving or not something");
    } else {
      NS_ASSERTION(moveFirstLineResult.inspect().Ignored(),
                   "Failed to consider whether moving or not something");
    }
#endif  // #ifdef DEBUG

    trackMoveResult.Flush(StopTracking::Yes);
    moveResult |= moveFirstLineResult.unwrap();
    return std::move(moveResult);
  }();
  if (MOZ_UNLIKELY(moveContentResult.isErr())) {
    return moveContentResult;
  }

  MoveNodeResult unwrappedMoveContentResult = moveContentResult.unwrap();

  trackStartOfRightText.Flush(StopTracking::Yes);
  if (atStartOfRightText.IsInTextNode() &&
      atStartOfRightText.IsSetAndValidInComposedDoc() &&
      atStartOfRightText.IsMiddleOfContainer()) {
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    Result<EditorDOMPoint, nsresult> startOfRightTextOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt(
            aHTMLEditor, atStartOfRightText.AsInText());
    if (MOZ_UNLIKELY(startOfRightTextOrError.isErr())) {
      NS_WARNING("WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt() failed");
      return startOfRightTextOrError.propagateErr();
    }
  }

  if (!invisibleBRElementAtEndOfLeftBlockElement ||
      !invisibleBRElementAtEndOfLeftBlockElement->IsInComposedDoc()) {
    unwrappedMoveContentResult.ForceToMarkAsHandled();
    return std::move(unwrappedMoveContentResult);
  }

  {
    AutoTrackDOMMoveNodeResult trackMoveContentResult(
        aHTMLEditor.RangeUpdaterRef(), &unwrappedMoveContentResult);
    AutoTransactionsConserveSelection dontChangeMySelection(aHTMLEditor);
    nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(
        *invisibleBRElementAtEndOfLeftBlockElement);
    // XXX In other top level if blocks, the result of
    //     DeleteNodeWithTransaction() is ignored.  Why does only this result
    //     is respected?
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      unwrappedMoveContentResult.IgnoreCaretPointSuggestion();
      return Err(rv);
    }
  }
  return std::move(unwrappedMoveContentResult);
}

// static
Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt(
    HTMLEditor& aHTMLEditor, const EditorDOMPointInText& aPoint) {
  MOZ_ASSERT(aPoint.IsSet());
  MOZ_ASSERT(!aPoint.IsEndOfContainer());

  if (!aPoint.IsCharCollapsibleASCIISpaceOrNBSP()) {
    return aPoint.To<EditorDOMPoint>();
  }

  const HTMLEditor::ReplaceWhiteSpacesData normalizedWhiteSpaces =
      aHTMLEditor.GetNormalizedStringAt(aPoint).GetMinimizedData(
          *aPoint.ContainerAs<Text>());
  if (!normalizedWhiteSpaces.ReplaceLength()) {
    return aPoint.To<EditorDOMPoint>();
  }

  const OwningNonNull<Text> textNode = *aPoint.ContainerAs<Text>();
  Result<InsertTextResult, nsresult> insertTextResultOrError =
      aHTMLEditor.ReplaceTextWithTransaction(textNode, normalizedWhiteSpaces,
                                             InsertTextFor::NormalText);
  if (MOZ_UNLIKELY(insertTextResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
    return insertTextResultOrError.propagateErr();
  }
  return insertTextResultOrError.unwrap().UnwrapCaretPoint();
}

// static
Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint,
    NormalizeOptions aOptions  // NOLINT(performance-unnecessary-value-param)
) {
  MOZ_ASSERT(aPoint.IsSetAndValid());
  MOZ_ASSERT_IF(aPoint.IsInTextNode(), !aPoint.IsMiddleOfContainer());
  MOZ_ASSERT(
      !aOptions.contains(NormalizeOption::HandleOnlyFollowingWhiteSpaces));

  const RefPtr<Element> colsetBlockElement =
      aPoint.IsInContentNode() ? HTMLEditUtils::GetInclusiveAncestorElement(
                                     *aPoint.ContainerAs<nsIContent>(),
                                     HTMLEditUtils::ClosestEditableBlockElement,
                                     BlockInlineCheck::UseComputedDisplayStyle)
                               : nullptr;
  EditorDOMPoint afterLastVisibleThing(aPoint);
  AutoTArray<OwningNonNull<nsIContent>, 32> unnecessaryContents;
  for (nsIContent* previousContent =
           aPoint.IsInTextNode() && aPoint.IsEndOfContainer()
               ? aPoint.ContainerAs<Text>()
               : HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
                     aPoint, {LeafNodeOption::TreatChildBlockAsLeafNode},
                     BlockInlineCheck::UseComputedDisplayStyle,
                     colsetBlockElement);
       previousContent;
       previousContent =
           HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
               EditorRawDOMPoint(previousContent),
               {LeafNodeOption::TreatChildBlockAsLeafNode},
               BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement)) {
    if (!HTMLEditUtils::IsSimplyEditableNode(*previousContent)) {
      // XXX Assume non-editable nodes are visible.
      break;
    }
    const RefPtr<Text> precedingTextNode = Text::FromNode(previousContent);
    if (!precedingTextNode &&
        HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*previousContent)) {
      afterLastVisibleThing.SetAfter(previousContent);
      break;
    }
    if (!precedingTextNode || !precedingTextNode->TextDataLength()) {
      // If it's an empty inline element like `<b></b>` or an empty `Text`,
      // delete it.
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *previousContent, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = previousContent;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    const auto atLastChar =
        EditorRawDOMPointInText::AtLastContentOf(*precedingTextNode);
    if (!atLastChar.IsCharCollapsibleASCIISpaceOrNBSP()) {
      afterLastVisibleThing.SetAfter(precedingTextNode);
      break;
    }
    if (aOptions.contains(
            NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP) &&
        atLastChar.IsCharNBSP()) {
      afterLastVisibleThing.SetAfter(precedingTextNode);
      break;
    }
    const HTMLEditor::ReplaceWhiteSpacesData replaceData =
        aHTMLEditor.GetNormalizedStringAt(atLastChar.AsInText())
            .GetMinimizedData(*precedingTextNode);
    if (!replaceData.ReplaceLength()) {
      afterLastVisibleThing.SetAfter(precedingTextNode);
      break;
    }
    // If the Text node has only invisible white-spaces, delete the node itself.
    if (replaceData.ReplaceLength() == precedingTextNode->TextDataLength() &&
        replaceData.mNormalizedString.IsEmpty()) {
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *precedingTextNode, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = precedingTextNode;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    Result<InsertTextResult, nsresult> replaceWhiteSpacesResultOrError =
        aHTMLEditor.ReplaceTextWithTransaction(*precedingTextNode, replaceData,
                                               InsertTextFor::NormalText);
    if (MOZ_UNLIKELY(replaceWhiteSpacesResultOrError.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return replaceWhiteSpacesResultOrError.propagateErr();
    }
    InsertTextResult replaceWhiteSpacesResult =
        replaceWhiteSpacesResultOrError.unwrap();
    replaceWhiteSpacesResult.IgnoreCaretPointSuggestion();
    afterLastVisibleThing = replaceWhiteSpacesResult.EndOfInsertedTextRef();
  }

  AutoTrackDOMPoint trackAfterLastVisibleThing(aHTMLEditor.RangeUpdaterRef(),
                                               &afterLastVisibleThing);
  for (const auto& contentToDelete : unnecessaryContents) {
    if (MOZ_UNLIKELY(!contentToDelete->IsInComposedDoc())) {
      continue;
    }
    nsresult rv =
        aHTMLEditor.DeleteNodeWithTransaction(MOZ_KnownLive(contentToDelete));
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return Err(rv);
    }
  }
  trackAfterLastVisibleThing.Flush(StopTracking::Yes);
  if (NS_WARN_IF(
          !afterLastVisibleThing.IsInContentNodeAndValidInComposedDoc())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }
  return std::move(afterLastVisibleThing);
}

// static
Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint,
    NormalizeOptions aOptions  // NOLINT(performance-unnecessary-value-param)
) {
  MOZ_ASSERT(aPoint.IsSetAndValid());
  MOZ_ASSERT_IF(aPoint.IsInTextNode(), !aPoint.IsMiddleOfContainer());
  MOZ_ASSERT(
      !aOptions.contains(NormalizeOption::HandleOnlyPrecedingWhiteSpaces));

  const RefPtr<Element> colsetBlockElement =
      aPoint.IsInContentNode() ? HTMLEditUtils::GetInclusiveAncestorElement(
                                     *aPoint.ContainerAs<nsIContent>(),
                                     HTMLEditUtils::ClosestEditableBlockElement,
                                     BlockInlineCheck::UseComputedDisplayStyle)
                               : nullptr;
  EditorDOMPoint atFirstVisibleThing(aPoint);
  AutoTArray<OwningNonNull<nsIContent>, 32> unnecessaryContents;
  for (nsIContent* nextContent =
           aPoint.IsInTextNode() && aPoint.IsStartOfContainer()
               ? aPoint.ContainerAs<Text>()
               : HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
                     aPoint, {LeafNodeOption::TreatChildBlockAsLeafNode},
                     BlockInlineCheck::UseComputedDisplayStyle,
                     colsetBlockElement);
       nextContent;
       nextContent = HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
           EditorRawDOMPoint::After(*nextContent),
           {LeafNodeOption::TreatChildBlockAsLeafNode},
           BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement)) {
    if (!HTMLEditUtils::IsSimplyEditableNode(*nextContent)) {
      // XXX Assume non-editable nodes are visible.
      break;
    }
    const RefPtr<Text> followingTextNode = Text::FromNode(nextContent);
    if (!followingTextNode &&
        HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*nextContent)) {
      atFirstVisibleThing.Set(nextContent);
      break;
    }
    if (!followingTextNode || !followingTextNode->TextDataLength()) {
      // If it's an empty inline element like `<b></b>` or an empty `Text`,
      // delete it.
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *nextContent, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = nextContent;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    const auto atFirstChar = EditorRawDOMPointInText(followingTextNode, 0u);
    if (!atFirstChar.IsCharCollapsibleASCIISpaceOrNBSP()) {
      atFirstVisibleThing.Set(followingTextNode);
      break;
    }
    if (aOptions.contains(
            NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP) &&
        atFirstChar.IsCharNBSP()) {
      atFirstVisibleThing.Set(followingTextNode);
      break;
    }
    const HTMLEditor::ReplaceWhiteSpacesData replaceData =
        aHTMLEditor.GetNormalizedStringAt(atFirstChar.AsInText())
            .GetMinimizedData(*followingTextNode);
    if (!replaceData.ReplaceLength()) {
      atFirstVisibleThing.Set(followingTextNode);
      break;
    }
    // If the Text node has only invisible white-spaces, delete the node itself.
    if (replaceData.ReplaceLength() == followingTextNode->TextDataLength() &&
        replaceData.mNormalizedString.IsEmpty()) {
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *followingTextNode, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = followingTextNode;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    Result<InsertTextResult, nsresult> replaceWhiteSpacesResultOrError =
        aHTMLEditor.ReplaceTextWithTransaction(*followingTextNode, replaceData,
                                               InsertTextFor::NormalText);
    if (MOZ_UNLIKELY(replaceWhiteSpacesResultOrError.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return replaceWhiteSpacesResultOrError.propagateErr();
    }
    replaceWhiteSpacesResultOrError.unwrap().IgnoreCaretPointSuggestion();
    atFirstVisibleThing.Set(followingTextNode, 0u);
    break;
  }

  AutoTrackDOMPoint trackAtFirstVisibleThing(aHTMLEditor.RangeUpdaterRef(),
                                             &atFirstVisibleThing);
  for (const auto& contentToDelete : unnecessaryContents) {
    if (MOZ_UNLIKELY(!contentToDelete->IsInComposedDoc())) {
      continue;
    }
    nsresult rv =
        aHTMLEditor.DeleteNodeWithTransaction(MOZ_KnownLive(contentToDelete));
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return Err(rv);
    }
  }
  trackAtFirstVisibleThing.Flush(StopTracking::Yes);
  if (NS_WARN_IF(!atFirstVisibleThing.IsInContentNodeAndValidInComposedDoc())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }
  return std::move(atFirstVisibleThing);
}

// static
Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
    HTMLEditor& aHTMLEditor, const EditorDOMPointInText& aPointToSplit,
    NormalizeOptions aOptions  // NOLINT(performance-unnecessary-value-param)
) {
  MOZ_ASSERT(aPointToSplit.IsSetAndValid());

  if (EditorUtils::IsWhiteSpacePreformatted(
          *aPointToSplit.ContainerAs<Text>())) {
    return aPointToSplit.To<EditorDOMPoint>();
  }

  const OwningNonNull<Text> textNode = *aPointToSplit.ContainerAs<Text>();
  if (!textNode->TextDataLength()) {
    // Delete if it's an empty `Text` node and removable.
    if (!HTMLEditUtils::IsRemovableNode(*textNode)) {
      // It's logically odd to call this for non-editable `Text`, but it may
      // happen if surrounding white-space sequence contains empty non-editable
      // `Text`.  In that case, the caller needs to normalize its preceding
      // `Text` nodes too.
      return EditorDOMPoint();
    }
    const nsCOMPtr<nsINode> parentNode = textNode->GetParentNode();
    const nsCOMPtr<nsIContent> nextSibling = textNode->GetNextSibling();
    nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(textNode);
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return Err(rv);
    }
    if (NS_WARN_IF(nextSibling && nextSibling->GetParentNode() != parentNode)) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    return nextSibling ? EditorDOMPoint(nextSibling)
                       : EditorDOMPoint::AtEndOf(*parentNode);
  }

  const HTMLEditor::ReplaceWhiteSpacesData replacePrecedingWhiteSpacesData =
      aPointToSplit.IsStartOfContainer() ||
              aOptions.contains(
                  NormalizeOption::HandleOnlyFollowingWhiteSpaces) ||
              (aOptions.contains(
                   NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP) &&
               aPointToSplit.IsPreviousCharNBSP())
          ? HTMLEditor::ReplaceWhiteSpacesData()
          : aHTMLEditor.GetPrecedingNormalizedStringToSplitAt(aPointToSplit);
  const HTMLEditor::ReplaceWhiteSpacesData replaceFollowingWhiteSpaceData =
      aPointToSplit.IsEndOfContainer() ||
              aOptions.contains(
                  NormalizeOption::HandleOnlyPrecedingWhiteSpaces) ||
              (aOptions.contains(
                   NormalizeOption::StopIfFollowingWhiteSpacesStartsWithNBSP) &&
               aPointToSplit.IsCharNBSP())
          ? HTMLEditor::ReplaceWhiteSpacesData()
          : aHTMLEditor.GetFollowingNormalizedStringToSplitAt(aPointToSplit);
  const HTMLEditor::ReplaceWhiteSpacesData replaceWhiteSpacesData =
      (replacePrecedingWhiteSpacesData + replaceFollowingWhiteSpaceData)
          .GetMinimizedData(*textNode);
  if (!replaceWhiteSpacesData.ReplaceLength()) {
    return aPointToSplit.To<EditorDOMPoint>();
  }
  if (replaceWhiteSpacesData.mNormalizedString.IsEmpty() &&
      replaceWhiteSpacesData.ReplaceLength() == textNode->TextDataLength()) {
    // If there is only invisible white-spaces, mNormalizedString is empty
    // string but replace length is same the the `Text` length. In this case, we
    // should delete the `Text` to avoid empty `Text` to stay in the DOM tree.
    const nsCOMPtr<nsINode> parentNode = textNode->GetParentNode();
    const nsCOMPtr<nsIContent> nextSibling = textNode->GetNextSibling();
    nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(textNode);
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return Err(rv);
    }
    if (NS_WARN_IF(nextSibling && nextSibling->GetParentNode() != parentNode)) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    return nextSibling ? EditorDOMPoint(nextSibling)
                       : EditorDOMPoint::AtEndOf(*parentNode);
  }
  Result<InsertTextResult, nsresult> replaceWhiteSpacesResultOrError =
      aHTMLEditor.ReplaceTextWithTransaction(textNode, replaceWhiteSpacesData,
                                             InsertTextFor::NormalText);
  if (MOZ_UNLIKELY(replaceWhiteSpacesResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
    return replaceWhiteSpacesResultOrError.propagateErr();
  }
  replaceWhiteSpacesResultOrError.unwrap().IgnoreCaretPointSuggestion();
  const uint32_t offsetToSplit =
      aPointToSplit.Offset() - replacePrecedingWhiteSpacesData.ReplaceLength() +
      replacePrecedingWhiteSpacesData.mNormalizedString.Length();
  if (NS_WARN_IF(textNode->TextDataLength() < offsetToSplit)) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }
  return EditorDOMPoint(textNode, offsetToSplit);
}

// static
Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitAt(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPointToSplit,
    NormalizeOptions aOptions  // NOLINT(performance-unnecessary-value-param)
) {
  MOZ_ASSERT(aPointToSplit.IsSet());

  // If the insertion point is not in composed doc, we're probably initializing
  // an element which will be inserted.  In such case, the caller should own the
  // responsibility for normalizing the white-spaces.
  if (!aPointToSplit.IsInComposedDoc()) {
    return aPointToSplit;
  }

  EditorDOMPoint pointToSplit(aPointToSplit);
  {
    AutoTrackDOMPoint trackPointToSplit(aHTMLEditor.RangeUpdaterRef(),
                                        &pointToSplit);
    Result<EditorDOMPoint, nsresult> pointToSplitOrError =
        WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(aHTMLEditor,
                                                                 pointToSplit);
    if (MOZ_UNLIKELY(pointToSplitOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces() failed");
      return pointToSplitOrError.propagateErr();
    }
  }

  if (NS_WARN_IF(!pointToSplit.IsInContentNode())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }

  if (pointToSplit.IsInTextNode()) {
    Result<EditorDOMPoint, nsresult> pointToSplitOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
            aHTMLEditor, pointToSplit.AsInText(), aOptions);
    if (MOZ_UNLIKELY(pointToSplitOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt() "
          "failed");
      return pointToSplitOrError.propagateErr();
    }
    pointToSplit = pointToSplitOrError.unwrap().To<EditorDOMPoint>();
    if (NS_WARN_IF(!pointToSplit.IsInContentNode())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    // If we normalize white-spaces in middle of the `Text`, we don't need to
    // touch surrounding `Text` nodes.
    if (pointToSplit.IsMiddleOfContainer()) {
      return pointToSplit;
    }
  }

  // Preceding and/or following white-space sequence may be across multiple
  // `Text` nodes.  Then, they may become unexpectedly visible without
  // normalizing the white-spaces.  Therefore, we need to list up all possible
  // `Text` nodes first. Then, normalize them unless the `Text` is not
  const RefPtr<Element> closestBlockElement =
      HTMLEditUtils::GetInclusiveAncestorElement(
          *pointToSplit.ContainerAs<nsIContent>(),
          HTMLEditUtils::ClosestBlockElement,
          BlockInlineCheck::UseComputedDisplayStyle);
  AutoTArray<OwningNonNull<Text>, 3> precedingTextNodes, followingTextNodes;
  if (!pointToSplit.IsInTextNode() || pointToSplit.IsStartOfContainer()) {
    for (nsCOMPtr<nsIContent> previousContent =
             HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
                 pointToSplit, {LeafNodeOption::TreatChildBlockAsLeafNode},
                 BlockInlineCheck::UseComputedDisplayStyle,
                 closestBlockElement);
         previousContent;
         previousContent =
             HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
                 *previousContent, {LeafNodeOption::TreatChildBlockAsLeafNode},
                 BlockInlineCheck::UseComputedDisplayStyle,
                 closestBlockElement)) {
      if (auto* const textNode = Text::FromNode(previousContent)) {
        if (!HTMLEditUtils::IsSimplyEditableNode(*textNode) &&
            textNode->TextDataLength()) {
          break;
        }
        if (aOptions.contains(
                NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP) &&
            textNode->DataBuffer().SafeLastChar() == HTMLEditUtils::kNBSP) {
          break;
        }
        precedingTextNodes.AppendElement(*textNode);
        if (textNode->TextIsOnlyWhitespace()) {
          // white-space only `Text` will be removed, so, we need to check
          // preceding one too.
          continue;
        }
        break;
      }
      if (auto* const element = Element::FromNode(previousContent)) {
        if (HTMLEditUtils::IsBlockElement(
                *element, BlockInlineCheck::UseComputedDisplayStyle) ||
            !HTMLEditUtils::IsContainerNode(*element) ||
            HTMLEditUtils::IsReplacedElement(*element)) {
          break;
        }
        // Ignore invisible inline elements
      }
    }
  }
  if (!pointToSplit.IsInTextNode() || pointToSplit.IsEndOfContainer()) {
    for (nsCOMPtr<nsIContent> nextContent =
             HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
                 pointToSplit, {LeafNodeOption::TreatChildBlockAsLeafNode},
                 BlockInlineCheck::UseComputedDisplayStyle,
                 closestBlockElement);
         nextContent;
         nextContent = HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
             *nextContent, {LeafNodeOption::TreatChildBlockAsLeafNode},
             BlockInlineCheck::UseComputedDisplayStyle, closestBlockElement)) {
      if (auto* const textNode = Text::FromNode(nextContent)) {
        if (!HTMLEditUtils::IsSimplyEditableNode(*textNode) &&
            textNode->TextDataLength()) {
          break;
        }
        if (aOptions.contains(
                NormalizeOption::StopIfFollowingWhiteSpacesStartsWithNBSP) &&
            textNode->DataBuffer().SafeFirstChar() == HTMLEditUtils::kNBSP) {
          break;
        }
        followingTextNodes.AppendElement(*textNode);
        if (textNode->TextIsOnlyWhitespace() &&
            EditorUtils::IsWhiteSpacePreformatted(*textNode)) {
          // white-space only `Text` will be removed, so, we need to check next
          // one too.
          continue;
        }
        break;
      }
      if (auto* const element = Element::FromNode(nextContent)) {
        if (HTMLEditUtils::IsBlockElement(
                *element, BlockInlineCheck::UseComputedDisplayStyle) ||
            !HTMLEditUtils::IsContainerNode(*element) ||
            HTMLEditUtils::IsReplacedElement(*element)) {
          break;
        }
        // Ignore invisible inline elements
      }
    }
  }
  AutoTrackDOMPoint trackPointToSplit(aHTMLEditor.RangeUpdaterRef(),
                                      &pointToSplit);
  for (const auto& textNode : precedingTextNodes) {
    Result<EditorDOMPoint, nsresult> normalizeWhiteSpacesResultOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
            aHTMLEditor, EditorDOMPointInText::AtEndOf(textNode), aOptions);
    if (MOZ_UNLIKELY(normalizeWhiteSpacesResultOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt() "
          "failed");
      return normalizeWhiteSpacesResultOrError.propagateErr();
    }
    if (normalizeWhiteSpacesResultOrError.inspect().IsInTextNode() &&
        !normalizeWhiteSpacesResultOrError.inspect().IsStartOfContainer()) {
      // The white-space sequence started from middle of this node, so, we need
      // to do this for the preceding nodes.
      break;
    }
  }
  for (const auto& textNode : followingTextNodes) {
    Result<EditorDOMPoint, nsresult> normalizeWhiteSpacesResultOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
            aHTMLEditor, EditorDOMPointInText(textNode, 0u), aOptions);
    if (MOZ_UNLIKELY(normalizeWhiteSpacesResultOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt() "
          "failed");
      return normalizeWhiteSpacesResultOrError.propagateErr();
    }
    if (normalizeWhiteSpacesResultOrError.inspect().IsInTextNode() &&
        !normalizeWhiteSpacesResultOrError.inspect().IsEndOfContainer()) {
      // The white-space sequence ended in middle of this node, so, we need
      // to do this for the following nodes.
      break;
    }
  }
  trackPointToSplit.Flush(StopTracking::Yes);
  if (NS_WARN_IF(!pointToSplit.IsInContentNode())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }
  return std::move(pointToSplit);
}

Result<EditorDOMRange, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeSurroundingWhiteSpacesToJoin(
    HTMLEditor& aHTMLEditor, const EditorDOMRange& aRangeToDelete) {
  MOZ_ASSERT(!aRangeToDelete.Collapsed());

  // Special case if the range for deleting text in same `Text`.  In the case,
  // we need to normalize the white-space sequence which may be joined after
  // deletion.
  if (aRangeToDelete.StartRef().IsInTextNode() &&
      aRangeToDelete.InSameContainer()) {
    const RefPtr<Text> textNode = aRangeToDelete.StartRef().ContainerAs<Text>();
    Result<EditorDOMRange, nsresult> rangeToDeleteOrError =
        WhiteSpaceVisibilityKeeper::
            NormalizeSurroundingWhiteSpacesToDeleteCharacters(
                aHTMLEditor, *textNode, aRangeToDelete.StartRef().Offset(),
                aRangeToDelete.EndRef().Offset() -
                    aRangeToDelete.StartRef().Offset());
    NS_WARNING_ASSERTION(
        rangeToDeleteOrError.isOk(),
        "WhiteSpaceVisibilityKeeper::"
        "NormalizeSurroundingWhiteSpacesToDeleteCharacters() failed");
    return rangeToDeleteOrError;
  }

  EditorDOMRange rangeToDelete(aRangeToDelete);
  // First, delete all invisible white-spaces around the end boundary.
  // The end boundary may be middle of invisible white-spaces.  If so,
  // NormalizeWhiteSpacesToSplitTextNodeAt() won't work well for this.
  {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    const WSScanResult nextThing =
        WSRunScanner::ScanInclusiveNextVisibleNodeOrBlockBoundary(
            {}, rangeToDelete.StartRef());
    if (nextThing.ReachedLineBoundary()) {
      nsresult rv =
          WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
              aHTMLEditor, nextThing.PointAtReachedContent<EditorDOMPoint>());
      if (NS_FAILED(rv)) {
        NS_WARNING(
            "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore() "
            "failed");
        return Err(rv);
      }
    } else {
      Result<EditorDOMPoint, nsresult>
          deleteInvisibleLeadingWhiteSpaceResultOrError =
              WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
                  aHTMLEditor, rangeToDelete.EndRef());
      if (MOZ_UNLIKELY(deleteInvisibleLeadingWhiteSpaceResultOrError.isErr())) {
        NS_WARNING(
            "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces() "
            "failed");
        return deleteInvisibleLeadingWhiteSpaceResultOrError.propagateErr();
      }
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositionedAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }

  // Then, normalize white-spaces after the end boundary.
  if (rangeToDelete.EndRef().IsInTextNode() &&
      rangeToDelete.EndRef().IsMiddleOfContainer()) {
    Result<EditorDOMPoint, nsresult> pointToSplitOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
            aHTMLEditor, rangeToDelete.EndRef().AsInText(),
            {NormalizeOption::HandleOnlyFollowingWhiteSpaces});
    if (MOZ_UNLIKELY(pointToSplitOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt("
          ") failed");
      return pointToSplitOrError.propagateErr();
    }
    EditorDOMPoint pointToSplit = pointToSplitOrError.unwrap();
    if (pointToSplit.IsSet() && pointToSplit != rangeToDelete.EndRef()) {
      MOZ_ASSERT(rangeToDelete.StartRef().EqualsOrIsBefore(pointToSplit));
      rangeToDelete.SetEnd(std::move(pointToSplit));
    }
    if (NS_WARN_IF(!rangeToDelete.IsPositionedAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  } else {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
            aHTMLEditor, rangeToDelete.EndRef(), {});
    if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() failed");
      return atFirstVisibleThingOrError.propagateErr();
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositionedAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }

  // If cleaning up the white-spaces around the end boundary made the range
  // collapsed, the range was in invisible white-spaces.  So, in the case, we
  // don't need to do nothing.
  if (MOZ_UNLIKELY(rangeToDelete.Collapsed())) {
    return rangeToDelete;
  }

  // Next, delete the invisible white-spaces around the start boundary.
  {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    Result<EditorDOMPoint, nsresult>
        deleteInvisibleTrailingWhiteSpaceResultOrError =
            WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
                aHTMLEditor, rangeToDelete.StartRef());
    if (MOZ_UNLIKELY(deleteInvisibleTrailingWhiteSpaceResultOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces() failed");
      return deleteInvisibleTrailingWhiteSpaceResultOrError.propagateErr();
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositionedAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }

  // Finally, normalize white-spaces before the start boundary only when
  // the start boundary is middle of a `Text` node.  This is compatible with
  // the other browsers.
  if (rangeToDelete.StartRef().IsInTextNode() &&
      rangeToDelete.StartRef().IsMiddleOfContainer()) {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt(
            aHTMLEditor, rangeToDelete.StartRef().AsInText(),
            {NormalizeOption::HandleOnlyPrecedingWhiteSpaces});
    if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitTextNodeAt() "
          "failed");
      return afterLastVisibleThingOrError.propagateErr();
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositionedAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    EditorDOMPoint pointToSplit = afterLastVisibleThingOrError.unwrap();
    if (pointToSplit.IsSet() && pointToSplit != rangeToDelete.StartRef()) {
      MOZ_ASSERT(pointToSplit.EqualsOrIsBefore(rangeToDelete.EndRef()));
      rangeToDelete.SetStart(std::move(pointToSplit));
    }
  }
  return rangeToDelete;
}

Result<EditorDOMRange, nsresult>
WhiteSpaceVisibilityKeeper::NormalizeSurroundingWhiteSpacesToDeleteCharacters(
    HTMLEditor& aHTMLEditor, Text& aTextNode, uint32_t aOffset,
    uint32_t aLength) {
  MOZ_ASSERT(aOffset <= aTextNode.TextDataLength());
  MOZ_ASSERT(aOffset + aLength <= aTextNode.TextDataLength());

  const HTMLEditor::ReplaceWhiteSpacesData normalizedWhiteSpacesData =
      aHTMLEditor.GetSurroundingNormalizedStringToDelete(aTextNode, aOffset,
                                                         aLength);
  EditorDOMRange rangeToDelete(EditorDOMPoint(&aTextNode, aOffset),
                               EditorDOMPoint(&aTextNode, aOffset + aLength));
  if (!normalizedWhiteSpacesData.ReplaceLength()) {
    return rangeToDelete;
  }
  // mNewOffsetAfterReplace is set to aOffset after applying replacing the
  // range.
  MOZ_ASSERT(normalizedWhiteSpacesData.mNewOffsetAfterReplace != UINT32_MAX);
  MOZ_ASSERT(normalizedWhiteSpacesData.mNewOffsetAfterReplace >=
             normalizedWhiteSpacesData.mReplaceStartOffset);
  MOZ_ASSERT(normalizedWhiteSpacesData.mNewOffsetAfterReplace <=
             normalizedWhiteSpacesData.mReplaceEndOffset);
#ifdef DEBUG
  {
    const HTMLEditor::ReplaceWhiteSpacesData
        normalizedPrecedingWhiteSpacesData =
            normalizedWhiteSpacesData.PreviousDataOfNewOffset(aOffset);
    const HTMLEditor::ReplaceWhiteSpacesData
        normalizedFollowingWhiteSpacesData =
            normalizedWhiteSpacesData.NextDataOfNewOffset(aOffset + aLength);
    MOZ_ASSERT(normalizedPrecedingWhiteSpacesData.ReplaceLength() + aLength +
                   normalizedFollowingWhiteSpacesData.ReplaceLength() ==
               normalizedWhiteSpacesData.ReplaceLength());
    MOZ_ASSERT(
        normalizedPrecedingWhiteSpacesData.mNormalizedString.Length() +
            normalizedFollowingWhiteSpacesData.mNormalizedString.Length() ==
        normalizedWhiteSpacesData.mNormalizedString.Length());
  }
#endif
  const HTMLEditor::ReplaceWhiteSpacesData normalizedPrecedingWhiteSpacesData =
      normalizedWhiteSpacesData.PreviousDataOfNewOffset(aOffset)
          .GetMinimizedData(aTextNode);
  const HTMLEditor::ReplaceWhiteSpacesData normalizedFollowingWhiteSpacesData =
      normalizedWhiteSpacesData.NextDataOfNewOffset(aOffset + aLength)
          .GetMinimizedData(aTextNode);
  if (normalizedFollowingWhiteSpacesData.ReplaceLength()) {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    Result<InsertTextResult, nsresult>
        replaceFollowingWhiteSpacesResultOrError =
            aHTMLEditor.ReplaceTextWithTransaction(
                aTextNode, normalizedFollowingWhiteSpacesData,
                InsertTextFor::NormalText);
    if (MOZ_UNLIKELY(replaceFollowingWhiteSpacesResultOrError.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return replaceFollowingWhiteSpacesResultOrError.propagateErr();
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositioned())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  if (normalizedPrecedingWhiteSpacesData.ReplaceLength()) {
    AutoTrackDOMRange trackRangeToDelete(aHTMLEditor.RangeUpdaterRef(),
                                         &rangeToDelete);
    Result<InsertTextResult, nsresult>
        replacePrecedingWhiteSpacesResultOrError =
            aHTMLEditor.ReplaceTextWithTransaction(
                aTextNode, normalizedPrecedingWhiteSpacesData,
                InsertTextFor::NormalText);
    if (MOZ_UNLIKELY(replacePrecedingWhiteSpacesResultOrError.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return replacePrecedingWhiteSpacesResultOrError.propagateErr();
    }
    trackRangeToDelete.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!rangeToDelete.IsPositioned())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  return std::move(rangeToDelete);
}

// static
Result<CreateLineBreakResult, nsresult>
WhiteSpaceVisibilityKeeper::InsertLineBreak(
    LineBreakType aLineBreakType, HTMLEditor& aHTMLEditor,
    const EditorDOMPoint& aPointToInsert) {
  if (MOZ_UNLIKELY(NS_WARN_IF(!aPointToInsert.IsSet()))) {
    return Err(NS_ERROR_INVALID_ARG);
  }

  EditorDOMPoint pointToInsert(aPointToInsert);
  // Chrome does not normalize preceding white-spaces at least when it ends
  // with an NBSP.
  Result<EditorDOMPoint, nsresult>
      normalizeSurroundingWhiteSpacesResultOrError =
          WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitAt(
              aHTMLEditor, aPointToInsert,
              {NormalizeOption::StopIfPrecedingWhiteSpacesEndsWithNBP});
  if (MOZ_UNLIKELY(normalizeSurroundingWhiteSpacesResultOrError.isErr())) {
    NS_WARNING(
        "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesToSplitAt() failed");
    return normalizeSurroundingWhiteSpacesResultOrError.propagateErr();
  }
  pointToInsert = normalizeSurroundingWhiteSpacesResultOrError.unwrap();
  if (NS_WARN_IF(!pointToInsert.IsSet())) {
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }

  Result<CreateLineBreakResult, nsresult> insertBRElementResultOrError =
      aHTMLEditor.InsertLineBreak(WithTransaction::Yes, aLineBreakType,
                                  pointToInsert);
  NS_WARNING_ASSERTION(insertBRElementResultOrError.isOk(),
                       "HTMLEditor::InsertLineBreak(WithTransaction::Yes, "
                       "aLineBreakType, eNone) failed");
  return insertBRElementResultOrError;
}

nsresult WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint) {
  MOZ_ASSERT(aPoint.IsInContentNode());

  const RefPtr<Element> colsetBlockElement =
      HTMLEditUtils::GetInclusiveAncestorElement(
          *aPoint.ContainerAs<nsIContent>(),
          HTMLEditUtils::ClosestEditableBlockElement,
          BlockInlineCheck::UseComputedDisplayStyle);
  EditorDOMPoint atFirstInvisibleWhiteSpace;
  AutoTArray<OwningNonNull<nsIContent>, 32> unnecessaryContents;
  for (nsIContent* nextContent =
           HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
               aPoint,
               {LeafNodeOption::TreatChildBlockAsLeafNode,
                LeafNodeOption::TreatCommentAsLeafNode},
               BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement);
       nextContent;
       nextContent = HTMLEditUtils::GetNextLeafContentOrNextBlockElement(
           EditorRawDOMPoint::After(*nextContent),
           {LeafNodeOption::TreatChildBlockAsLeafNode,
            LeafNodeOption::TreatCommentAsLeafNode},
           BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement)) {
    if (!HTMLEditUtils::IsSimplyEditableNode(*nextContent)) {
      // XXX Assume non-editable nodes are visible.
      break;
    }
    const RefPtr<Text> followingTextNode = Text::FromNode(nextContent);
    if (!followingTextNode &&
        HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*nextContent)) {
      break;
    }
    if (!followingTextNode || !followingTextNode->TextDataLength()) {
      // If it's an empty inline element like `<b></b>` or an empty `Text`,
      // delete it.
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *nextContent, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = nextContent;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    const EditorRawDOMPointInText atFirstChar(followingTextNode, 0u);
    if (!atFirstChar.IsCharCollapsibleASCIISpace()) {
      break;
    }
    // If the preceding Text is collapsed and invisible, we should delete it
    // and keep deleting preceding invisible white-spaces.
    if (!HTMLEditUtils::IsVisibleTextNode(
            *followingTextNode, TreatInvisibleLineBreakAs::Invisible)) {
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *followingTextNode, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = followingTextNode;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    Result<EditorDOMPoint, nsresult> startOfTextOrError =
        WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
            aHTMLEditor, EditorDOMPoint(followingTextNode, 0u));
    if (MOZ_UNLIKELY(startOfTextOrError.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return startOfTextOrError.unwrapErr();
    }
    break;
  }

  for (const auto& contentToDelete : unnecessaryContents) {
    if (MOZ_UNLIKELY(!contentToDelete->IsInComposedDoc())) {
      continue;
    }
    nsresult rv =
        aHTMLEditor.DeleteNodeWithTransaction(MOZ_KnownLive(contentToDelete));
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return rv;
    }
  }
  return NS_OK;
}

nsresult WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint) {
  MOZ_ASSERT(aPoint.IsInContentNode());

  const RefPtr<Element> colsetBlockElement =
      HTMLEditUtils::GetInclusiveAncestorElement(
          *aPoint.ContainerAs<nsIContent>(),
          HTMLEditUtils::ClosestEditableBlockElement,
          BlockInlineCheck::UseComputedDisplayStyle);
  EditorDOMPoint atFirstInvisibleWhiteSpace;
  AutoTArray<OwningNonNull<nsIContent>, 32> unnecessaryContents;
  for (nsIContent* previousContent =
           HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
               aPoint,
               {LeafNodeOption::TreatChildBlockAsLeafNode,
                LeafNodeOption::TreatCommentAsLeafNode},
               BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement);
       previousContent;
       previousContent =
           HTMLEditUtils::GetPreviousLeafContentOrPreviousBlockElement(
               EditorRawDOMPoint(previousContent),
               {LeafNodeOption::TreatChildBlockAsLeafNode,
                LeafNodeOption::TreatCommentAsLeafNode},
               BlockInlineCheck::UseComputedDisplayStyle, colsetBlockElement)) {
    if (!HTMLEditUtils::IsSimplyEditableNode(*previousContent)) {
      // XXX Assume non-editable nodes are visible.
      break;
    }
    const RefPtr<Text> precedingTextNode = Text::FromNode(previousContent);
    if (!precedingTextNode &&
        HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*previousContent)) {
      break;
    }
    if (!precedingTextNode || !precedingTextNode->TextDataLength()) {
      // If it's an empty inline element like `<b></b>` or an empty `Text`,
      // delete it.
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *previousContent, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = previousContent;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    const auto atLastChar =
        EditorRawDOMPointInText::AtLastContentOf(*precedingTextNode);
    if (!atLastChar.IsCharCollapsibleASCIISpace()) {
      break;
    }
    // If the preceding Text is collapsed and invisible, we should delete it
    // and keep deleting preceding invisible white-spaces.
    if (!HTMLEditUtils::IsVisibleTextNode(
            *precedingTextNode, TreatInvisibleLineBreakAs::Invisible)) {
      nsIContent* emptyInlineContent =
          HTMLEditUtils::GetMostDistantAncestorEditableEmptyInlineElement(
              *precedingTextNode, BlockInlineCheck::UseComputedDisplayStyle);
      if (!emptyInlineContent) {
        emptyInlineContent = precedingTextNode;
      }
      unnecessaryContents.AppendElement(*emptyInlineContent);
      continue;
    }
    Result<EditorDOMPoint, nsresult> endOfTextOrResult =
        WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
            aHTMLEditor, EditorDOMPoint::AtEndOf(*precedingTextNode));
    if (MOZ_UNLIKELY(endOfTextOrResult.isErr())) {
      NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
      return endOfTextOrResult.unwrapErr();
    }
    break;
  }

  for (const auto& contentToDelete : Reversed(unnecessaryContents)) {
    if (MOZ_UNLIKELY(!contentToDelete->IsInComposedDoc())) {
      continue;
    }
    nsresult rv =
        aHTMLEditor.DeleteNodeWithTransaction(MOZ_KnownLive(contentToDelete));
    if (NS_FAILED(rv)) {
      NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
      return rv;
    }
  }
  return NS_OK;
}

Result<EditorDOMPoint, nsresult>
WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint) {
  if (EditorUtils::IsWhiteSpacePreformatted(
          *aPoint.ContainerAs<nsIContent>())) {
    return EditorDOMPoint();
  }
  if (aPoint.IsInTextNode() &&
      // If there is a previous char and it's not a collapsible ASCII
      // white-space, the point is not in the leading white-spaces.
      (!aPoint.IsStartOfContainer() && !aPoint.IsPreviousCharASCIISpace()) &&
      // If it does not points a collapsible ASCII white-space, the point is not
      // in the trailing white-spaces.
      (!aPoint.IsEndOfContainer() && !aPoint.IsCharCollapsibleASCIISpace())) {
    return EditorDOMPoint();
  }
  const Element* const maybeNonEditableClosestBlockElement =
      HTMLEditUtils::GetInclusiveAncestorElement(
          *aPoint.ContainerAs<nsIContent>(), HTMLEditUtils::ClosestBlockElement,
          BlockInlineCheck::UseComputedDisplayStyle);
  if (MOZ_UNLIKELY(!maybeNonEditableClosestBlockElement)) {
    return EditorDOMPoint();  // aPoint is not in a block.
  }
  const TextFragmentData textFragmentDataForLeadingWhiteSpaces(
      {WSRunScanner::Option::OnlyEditableNodes},
      aPoint.IsStartOfContainer() &&
              (aPoint.GetContainer() == maybeNonEditableClosestBlockElement ||
               aPoint.GetContainer()->IsEditingHost())
          ? aPoint
          : aPoint.PreviousPointOrParentPoint<EditorDOMPoint>(),
      maybeNonEditableClosestBlockElement);
  if (NS_WARN_IF(!textFragmentDataForLeadingWhiteSpaces.IsInitialized())) {
    return Err(NS_ERROR_FAILURE);
  }

  {
    const EditorDOMRange& leadingWhiteSpaceRange =
        textFragmentDataForLeadingWhiteSpaces
            .InvisibleLeadingWhiteSpaceRangeRef();
    if (leadingWhiteSpaceRange.IsPositioned() &&
        !leadingWhiteSpaceRange.Collapsed()) {
      EditorDOMPoint endOfLeadingWhiteSpaces(leadingWhiteSpaceRange.EndRef());
      AutoTrackDOMPoint trackEndOfLeadingWhiteSpaces(
          aHTMLEditor.RangeUpdaterRef(), &endOfLeadingWhiteSpaces);
      Result<CaretPoint, nsresult> caretPointOrError =
          aHTMLEditor.DeleteTextAndTextNodesWithTransaction(
              leadingWhiteSpaceRange.StartRef(),
              leadingWhiteSpaceRange.EndRef(),
              HTMLEditor::TreatEmptyTextNodes::
                  KeepIfContainerOfRangeBoundaries);
      if (MOZ_UNLIKELY(caretPointOrError.isErr())) {
        NS_WARNING(
            "HTMLEditor::DeleteTextAndTextNodesWithTransaction("
            "TreatEmptyTextNodes::KeepIfContainerOfRangeBoundaries) failed");
        return caretPointOrError.propagateErr();
      }
      caretPointOrError.unwrap().IgnoreCaretPointSuggestion();
      // If the leading white-spaces were split into multiple text node, we need
      // only the last `Text` node.
      if (!leadingWhiteSpaceRange.InSameContainer() &&
          leadingWhiteSpaceRange.StartRef().IsInTextNode() &&
          leadingWhiteSpaceRange.StartRef()
              .ContainerAs<Text>()
              ->IsInComposedDoc() &&
          leadingWhiteSpaceRange.EndRef().IsInTextNode() &&
          leadingWhiteSpaceRange.EndRef()
              .ContainerAs<Text>()
              ->IsInComposedDoc() &&
          !leadingWhiteSpaceRange.StartRef()
               .ContainerAs<Text>()
               ->TextDataLength()) {
        nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(MOZ_KnownLive(
            *leadingWhiteSpaceRange.StartRef().ContainerAs<Text>()));
        if (NS_FAILED(rv)) {
          NS_WARNING("HTMLEditor::DeleteNodeWithTransaction() failed");
          return Err(rv);
        }
      }
      trackEndOfLeadingWhiteSpaces.Flush(StopTracking::Yes);
      if (NS_WARN_IF(!endOfLeadingWhiteSpaces.IsSetAndValidInComposedDoc())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
      return endOfLeadingWhiteSpaces;
    }
  }

  const TextFragmentData textFragmentData =
      textFragmentDataForLeadingWhiteSpaces.ScanStartRef() == aPoint
          ? textFragmentDataForLeadingWhiteSpaces
          : TextFragmentData({WSRunScanner::Option::OnlyEditableNodes}, aPoint,
                             maybeNonEditableClosestBlockElement);
  const EditorDOMRange& trailingWhiteSpaceRange =
      textFragmentData.InvisibleTrailingWhiteSpaceRangeRef();
  if (trailingWhiteSpaceRange.IsPositioned() &&
      !trailingWhiteSpaceRange.Collapsed()) {
    EditorDOMPoint startOfTrailingWhiteSpaces(
        trailingWhiteSpaceRange.StartRef());
    AutoTrackDOMPoint trackStartOfTrailingWhiteSpaces(
        aHTMLEditor.RangeUpdaterRef(), &startOfTrailingWhiteSpaces);
    Result<CaretPoint, nsresult> caretPointOrError =
        aHTMLEditor.DeleteTextAndTextNodesWithTransaction(
            trailingWhiteSpaceRange.StartRef(),
            trailingWhiteSpaceRange.EndRef(),
            HTMLEditor::TreatEmptyTextNodes::KeepIfContainerOfRangeBoundaries);
    if (MOZ_UNLIKELY(caretPointOrError.isErr())) {
      NS_WARNING(
          "HTMLEditor::DeleteTextAndTextNodesWithTransaction("
          "TreatEmptyTextNodes::KeepIfContainerOfRangeBoundaries) failed");
      return caretPointOrError.propagateErr();
    }
    caretPointOrError.unwrap().IgnoreCaretPointSuggestion();
    // If the leading white-spaces were split into multiple text node, we need
    // only the last `Text` node.
    if (!trailingWhiteSpaceRange.InSameContainer() &&
        trailingWhiteSpaceRange.StartRef().IsInTextNode() &&
        trailingWhiteSpaceRange.StartRef()
            .ContainerAs<Text>()
            ->IsInComposedDoc() &&
        trailingWhiteSpaceRange.EndRef().IsInTextNode() &&
        trailingWhiteSpaceRange.EndRef()
            .ContainerAs<Text>()
            ->IsInComposedDoc() &&
        !trailingWhiteSpaceRange.EndRef()
             .ContainerAs<Text>()
             ->TextDataLength()) {
      nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(
          MOZ_KnownLive(*trailingWhiteSpaceRange.EndRef().ContainerAs<Text>()));
      if (NS_FAILED(rv)) {
        NS_WARNING("HTMLEditor::DeleteNodeWithTransaction() failed");
        return Err(rv);
      }
    }
    trackStartOfTrailingWhiteSpaces.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!startOfTrailingWhiteSpaces.IsSetAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    return startOfTrailingWhiteSpaces;
  }

  const auto atCollapsibleASCIISpace =
      [&]() MOZ_NEVER_INLINE_DEBUG -> EditorDOMPointInText {
    const auto point =
        textFragmentData.GetInclusiveNextCharPoint<EditorDOMPointInText>(
            textFragmentData.ScanStartRef(), IgnoreNonEditableNodes::Yes);
    if (point.IsSet() &&
        // XXX Perhaps, we should ignore empty `Text` nodes and keep scanning.
        !point.IsEndOfContainer() && point.IsCharCollapsibleASCIISpace()) {
      return point;
    }
    const auto prevPoint =
        textFragmentData.GetPreviousCharPoint<EditorDOMPointInText>(
            textFragmentData.ScanStartRef(), IgnoreNonEditableNodes::Yes);
    return prevPoint.IsSet() &&
                   // XXX Perhaps, we should ignore empty `Text` nodes and keep
                   // scanning.
                   !prevPoint.IsEndOfContainer() &&
                   prevPoint.IsCharCollapsibleASCIISpace()
               ? prevPoint
               : EditorDOMPointInText();
  }();
  if (!atCollapsibleASCIISpace.IsSet()) {
    return EditorDOMPoint();
  }
  const auto firstCollapsibleASCIISpacePoint =
      textFragmentData
          .GetFirstASCIIWhiteSpacePointCollapsedTo<EditorDOMPointInText>(
              atCollapsibleASCIISpace, nsIEditor::eNone,
              IgnoreNonEditableNodes::No);
  const auto endOfCollapsibleASCIISpacePoint =
      textFragmentData
          .GetEndOfCollapsibleASCIIWhiteSpaces<EditorDOMPointInText>(
              atCollapsibleASCIISpace, nsIEditor::eNone,
              IgnoreNonEditableNodes::No);
  if (firstCollapsibleASCIISpacePoint.NextPoint() ==
      endOfCollapsibleASCIISpacePoint) {
    // Only one white-space, so that nothing to do.
    return EditorDOMPoint();
  }
  // Okay, there are some collapsed white-spaces. We should delete them with
  // keeping first one.
  Result<CaretPoint, nsresult> deleteTextResultOrError =
      aHTMLEditor.DeleteTextAndTextNodesWithTransaction(
          firstCollapsibleASCIISpacePoint.NextPoint(),
          endOfCollapsibleASCIISpacePoint,
          HTMLEditor::TreatEmptyTextNodes::Remove);
  if (MOZ_UNLIKELY(deleteTextResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::DeleteTextWithTransaction() failed");
    return deleteTextResultOrError.propagateErr();
  }
  return deleteTextResultOrError.unwrap().UnwrapCaretPoint();
}

// static
Result<InsertTextResult, nsresult>
WhiteSpaceVisibilityKeeper::InsertTextOrInsertOrUpdateCompositionString(
    HTMLEditor& aHTMLEditor, const nsAString& aStringToInsert,
    const EditorDOMRange& aRangeToBeReplaced, InsertTextTo aInsertTextTo,
    InsertTextFor aPurpose, const Element& aEditingHost) {
  MOZ_ASSERT(aRangeToBeReplaced.StartRef().IsInContentNode());
  MOZ_ASSERT_IF(!EditorBase::InsertingTextForExtantComposition(aPurpose),
                aRangeToBeReplaced.Collapsed());
  if (aStringToInsert.IsEmpty()) {
    MOZ_ASSERT(aRangeToBeReplaced.Collapsed());
    return InsertTextResult();
  }

  if (NS_WARN_IF(!aRangeToBeReplaced.StartRef().IsInContentNode())) {
    return Err(NS_ERROR_FAILURE);  // Cannot insert text
  }

  EditorDOMPoint pointToInsert = aHTMLEditor.ComputePointToInsertText(
      aRangeToBeReplaced.StartRef(), aInsertTextTo);
  MOZ_ASSERT(pointToInsert.IsInContentNode());
  const bool isWhiteSpaceCollapsible = !EditorUtils::IsWhiteSpacePreformatted(
      *aRangeToBeReplaced.StartRef().ContainerAs<nsIContent>());

  // First, delete invisible leading white-spaces and trailing white-spaces if
  // they are there around the replacing range boundaries.  However, don't do
  // that if we're updating existing composition string to avoid the composition
  // transaction is broken by the text change around composition string.
  if (!EditorBase::InsertingTextForExtantComposition(aPurpose) &&
      isWhiteSpaceCollapsible && pointToInsert.IsInContentNode()) {
    AutoTrackDOMPoint trackPointToInsert(aHTMLEditor.RangeUpdaterRef(),
                                         &pointToInsert);
    Result<EditorDOMPoint, nsresult>
        deletePointOfInvisibleWhiteSpacesAtStartOrError =
            WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces(
                aHTMLEditor, pointToInsert);
    if (MOZ_UNLIKELY(deletePointOfInvisibleWhiteSpacesAtStartOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpaces() failed");
      return deletePointOfInvisibleWhiteSpacesAtStartOrError.propagateErr();
    }
    trackPointToInsert.Flush(StopTracking::Yes);
    const EditorDOMPoint deletePointOfInvisibleWhiteSpacesAtStart =
        deletePointOfInvisibleWhiteSpacesAtStartOrError.unwrap();
    if (NS_WARN_IF(deletePointOfInvisibleWhiteSpacesAtStart.IsSet() &&
                   !pointToInsert.IsSetAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
    // If we're starting composition, we won't normalizing surrounding
    // white-spaces until end of the composition.  Additionally, at that time,
    // we need to assume all white-spaces of surrounding white-spaces are
    // visible because canceling composition may cause previous white-space
    // invisible temporarily. Therefore, we should normalize surrounding
    // white-spaces to delete invisible white-spaces contained in the sequence.
    // E.g., `NBSP SP SP NBSP`, in this case, one of the SP is invisible.
    if (EditorBase::InsertingTextForStartingComposition(aPurpose) &&
        pointToInsert.IsInTextNode()) {
      const auto whiteSpaceOffset = [&]() -> Maybe<uint32_t> {
        if (!pointToInsert.IsEndOfContainer() &&
            pointToInsert.IsCharCollapsibleASCIISpaceOrNBSP()) {
          return Some(pointToInsert.Offset());
        }
        if (!pointToInsert.IsStartOfContainer() &&
            pointToInsert.IsPreviousCharCollapsibleASCIISpaceOrNBSP()) {
          return Some(pointToInsert.Offset() - 1u);
        }
        return Nothing();
      }();
      if (whiteSpaceOffset.isSome()) {
        Maybe<AutoTrackDOMPoint> trackPointToInsert;
        if (pointToInsert.Offset() != *whiteSpaceOffset) {
          trackPointToInsert.emplace(aHTMLEditor.RangeUpdaterRef(),
                                     &pointToInsert);
        }
        Result<EditorDOMPoint, nsresult> pointToInsertOrError =
            WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt(
                aHTMLEditor,
                EditorDOMPointInText(pointToInsert.ContainerAs<Text>(),
                                     *whiteSpaceOffset));
        if (MOZ_UNLIKELY(pointToInsertOrError.isErr())) {
          NS_WARNING(
              "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAt() failed");
          return pointToInsertOrError.propagateErr();
        }
        if (trackPointToInsert.isSome()) {
          trackPointToInsert.reset();
        } else {
          pointToInsert = pointToInsertOrError.unwrap();
        }
        if (NS_WARN_IF(!pointToInsert.IsInContentNodeAndValidInComposedDoc())) {
          return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
        }
      }
    }
  }

  if (NS_WARN_IF(!pointToInsert.IsInContentNode())) {
    return Err(NS_ERROR_FAILURE);
  }

  const HTMLEditor::NormalizedStringToInsertText insertTextData =
      [&]() MOZ_NEVER_INLINE_DEBUG {
        if (!isWhiteSpaceCollapsible) {
          return HTMLEditor::NormalizedStringToInsertText(aStringToInsert,
                                                          pointToInsert);
        }
        if (pointToInsert.IsInTextNode() &&
            !EditorBase::InsertingTextForComposition(aPurpose)) {
          // If normalizing the surrounding white-spaces in the `Text`, we
          // should minimize the replacing range to avoid to unnecessary
          // replacement.
          return aHTMLEditor
              .NormalizeWhiteSpacesToInsertText(
                  pointToInsert, aStringToInsert,
                  HTMLEditor::NormalizeSurroundingWhiteSpaces::Yes)
              .GetMinimizedData(*pointToInsert.ContainerAs<Text>());
        }
        return aHTMLEditor.NormalizeWhiteSpacesToInsertText(
            pointToInsert, aStringToInsert,
            // If we're handling composition string, we should not replace
            // surrounding white-spaces to avoid to make
            // CompositionTransaction confused.
            EditorBase::InsertingTextForComposition(aPurpose)
                ? HTMLEditor::NormalizeSurroundingWhiteSpaces::No
                : HTMLEditor::NormalizeSurroundingWhiteSpaces::Yes);
      }();

  // Now, we prepare to insert normalized text and the text may be going to be
  // followed by an unnecessary line break. In this case, we need to delete the
  // unnecessary line break before inserting the new text because X (Twitter)
  // expects the last mutation is the character data change.
  if (!aStringToInsert.IsEmpty() &&
      !EditorBase::InsertingTextForExtantComposition(aPurpose)) {
    const WSScanResult nextThing =
        HTMLEditUtils::ScanInclusiveNextThingWithIgnoringUnnecessaryLineBreak(
            pointToInsert, PaddingForEmptyBlock::Unnecessary, aEditingHost);
    if (nextThing.MaybeIgnoredLineBreak().isSome()) {
      const EditorLineBreak& lineBreak =
          nextThing.MaybeIgnoredLineBreak().ref();
      // When user inserting content, the web app may expect that nothing
      // extant content will be deleted. Therefore, we should preserve
      // preformatted linefeed at least. However, we should delete it if it's a
      // padding for empty block for the compatibility with the other browsers.
      if (lineBreak.IsHTMLBRElement() || lineBreak.IsPaddingForEmptyBlock()) {
        const RefPtr<const Element> ancestorLimiterToDeleteEmptyInlines =
            lineBreak.ContentRef().IsInclusiveDescendantOf(
                pointToInsert.GetContainer())
                ? pointToInsert.GetContainerOrContainerParentElement()
                : &aEditingHost;
        {
          AutoTrackDOMPoint trackCurrentPoint(aHTMLEditor.RangeUpdaterRef(),
                                              &pointToInsert);
          Result<EditorDOMPoint, nsresult> deleteLineBreakResultOrError =
              aHTMLEditor.DeleteLineBreakWithTransaction(
                  nextThing.MaybeIgnoredLineBreak().ref(), nsIEditor::eStrip,
                  *ancestorLimiterToDeleteEmptyInlines);
          if (deleteLineBreakResultOrError.isErr()) [[unlikely]] {
            NS_WARNING("HTMLEditor::DeleteLineBreakWithTransaction() failed");
            return deleteLineBreakResultOrError.propagateErr();
          }
        }
        if (NS_WARN_IF(!pointToInsert.IsSetAndValidInComposedDoc())) {
          return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
        }
      }
    }
  }

  MOZ_ASSERT_IF(insertTextData.ReplaceLength(), pointToInsert.IsInTextNode());
  Result<InsertTextResult, nsresult> insertOrReplaceTextResultOrError =
      aHTMLEditor.InsertOrReplaceTextWithTransaction(pointToInsert,
                                                     insertTextData, aPurpose);
  if (MOZ_UNLIKELY(insertOrReplaceTextResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
    return insertOrReplaceTextResultOrError;
  }
  // If the composition is committed, we should normalize surrounding
  // white-spaces of the commit string.
  if (!EditorBase::InsertingTextForCommittingComposition(aPurpose)) {
    return insertOrReplaceTextResultOrError;
  }
  InsertTextResult insertOrReplaceTextResult =
      insertOrReplaceTextResultOrError.unwrap();
  const EditorDOMPointInText endOfCommitString =
      insertOrReplaceTextResult.EndOfInsertedTextRef().GetAsInText();
  if (!endOfCommitString.IsSet() || endOfCommitString.IsContainerEmpty()) {
    return std::move(insertOrReplaceTextResult);
  }
  if (NS_WARN_IF(endOfCommitString.Offset() <
                 insertTextData.mNormalizedString.Length())) {
    insertOrReplaceTextResult.IgnoreCaretPointSuggestion();
    return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
  }
  const EditorDOMPointInText startOfCommitString(
      endOfCommitString.ContainerAs<Text>(),
      endOfCommitString.Offset() - insertTextData.mNormalizedString.Length());
  MOZ_ASSERT(insertOrReplaceTextResult.EndOfInsertedTextRef() ==
             insertOrReplaceTextResult.CaretPointRef());
  EditorDOMPoint pointToPutCaret = insertOrReplaceTextResult.UnwrapCaretPoint();
  // First, normalize the trailing white-spaces if there is.  Note that its
  // sequence may start from before the commit string.  In such case, the
  // another call of NormalizeWhiteSpacesAt() won't update the DOM.
  if (endOfCommitString.IsMiddleOfContainer()) {
    nsresult rv = WhiteSpaceVisibilityKeeper::
        NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces(
            aHTMLEditor, endOfCommitString.PreviousPoint());
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::"
          "NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces() "
          "failed");
      return Err(rv);
    }
    if (NS_WARN_IF(!pointToPutCaret.IsSetAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  // Finally, normalize the leading white-spaces if there is and not a part of
  // the trailing white-spaces.
  if (!startOfCommitString.IsStartOfContainer()) {
    nsresult rv = WhiteSpaceVisibilityKeeper::
        NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces(
            aHTMLEditor, startOfCommitString.PreviousPoint());
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::"
          "NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces() "
          "failed");
      return Err(rv);
    }
    if (NS_WARN_IF(!pointToPutCaret.IsSetAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  EditorDOMPoint endOfCommitStringAfterNormalized = pointToPutCaret;
  return InsertTextResult(std::move(endOfCommitStringAfterNormalized),
                          CaretPoint(std::move(pointToPutCaret)));
}

// static
nsresult WhiteSpaceVisibilityKeeper::
    NormalizeVisibleWhiteSpacesWithoutDeletingInvisibleWhiteSpaces(
        HTMLEditor& aHTMLEditor, const EditorDOMPointInText& aPoint) {
  MOZ_ASSERT(aPoint.IsSet());
  MOZ_ASSERT(!aPoint.IsEndOfContainer());

  if (EditorUtils::IsWhiteSpacePreformatted(*aPoint.ContainerAs<Text>())) {
    return NS_OK;
  }
  Text& textNode = *aPoint.ContainerAs<Text>();
  const bool isNewLinePreformatted =
      EditorUtils::IsNewLinePreformatted(textNode);
  const auto IsCollapsibleChar = [&](char16_t aChar) {
    return aChar == HTMLEditUtils::kNewLine ? !isNewLinePreformatted
                                            : nsCRT::IsAsciiSpace(aChar);
  };
  const auto IsCollapsibleCharOrNBSP = [&](char16_t aChar) {
    return aChar == HTMLEditUtils::kNBSP || IsCollapsibleChar(aChar);
  };
  const auto whiteSpaceOffset = [&]() -> Maybe<uint32_t> {
    if (IsCollapsibleCharOrNBSP(aPoint.Char())) {
      return Some(aPoint.Offset());
    }
    if (!aPoint.IsAtLastContent() &&
        IsCollapsibleCharOrNBSP(aPoint.NextChar())) {
      return Some(aPoint.Offset() + 1u);
    }
    return Nothing();
  }();
  if (whiteSpaceOffset.isNothing()) {
    return NS_OK;
  }
  CharacterDataBuffer::WhitespaceOptions whitespaceOptions{
      CharacterDataBuffer::WhitespaceOption::FormFeedIsSignificant,
      CharacterDataBuffer::WhitespaceOption::TreatNBSPAsCollapsible};
  if (isNewLinePreformatted) {
    whitespaceOptions +=
        CharacterDataBuffer::WhitespaceOption::NewLineIsSignificant;
  }
  const uint32_t firstOffset = [&]() {
    if (!*whiteSpaceOffset) {
      return 0u;
    }
    const uint32_t offset = textNode.DataBuffer().RFindNonWhitespaceChar(
        whitespaceOptions, *whiteSpaceOffset - 1);
    return offset == CharacterDataBuffer::kNotFound ? 0u : offset + 1u;
  }();
  const uint32_t endOffset = [&]() {
    const uint32_t offset = textNode.DataBuffer().FindNonWhitespaceChar(
        whitespaceOptions, *whiteSpaceOffset + 1);
    return offset == CharacterDataBuffer::kNotFound ? textNode.TextDataLength()
                                                    : offset;
  }();
  MOZ_DIAGNOSTIC_ASSERT(firstOffset <= endOffset);
  nsAutoString normalizedString;
  const char16_t precedingChar =
      !firstOffset ? static_cast<char16_t>(0)
                   : textNode.DataBuffer().CharAt(firstOffset - 1u);
  const char16_t followingChar = endOffset == textNode.TextDataLength()
                                     ? static_cast<char16_t>(0)
                                     : textNode.DataBuffer().CharAt(endOffset);
  HTMLEditor::GenerateWhiteSpaceSequence(
      normalizedString, endOffset - firstOffset,
      !firstOffset ? HTMLEditor::CharPointData::InSameTextNode(
                         HTMLEditor::CharPointType::TextEnd)
                   : HTMLEditor::CharPointData::InSameTextNode(
                         precedingChar == HTMLEditUtils::kNewLine
                             ? HTMLEditor::CharPointType::PreformattedLineBreak
                             : HTMLEditor::CharPointType::VisibleChar),
      endOffset == textNode.TextDataLength()
          ? HTMLEditor::CharPointData::InSameTextNode(
                HTMLEditor::CharPointType::TextEnd)
          : HTMLEditor::CharPointData::InSameTextNode(
                followingChar == HTMLEditUtils::kNewLine
                    ? HTMLEditor::CharPointType::PreformattedLineBreak
                    : HTMLEditor::CharPointType::VisibleChar));
  MOZ_ASSERT(normalizedString.Length() == endOffset - firstOffset);
  const OwningNonNull<Text> text(textNode);
  Result<InsertTextResult, nsresult> normalizeWhiteSpaceSequenceResultOrError =
      aHTMLEditor.ReplaceTextWithTransaction(
          text, firstOffset, endOffset - firstOffset, normalizedString,
          InsertTextFor::NormalText);
  if (MOZ_UNLIKELY(normalizeWhiteSpaceSequenceResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::ReplaceTextWithTransaction() failed");
    return normalizeWhiteSpaceSequenceResultOrError.unwrapErr();
  }
  normalizeWhiteSpaceSequenceResultOrError.unwrap()
      .IgnoreCaretPointSuggestion();
  return NS_OK;
}

// static
Result<CaretPoint, nsresult>
WhiteSpaceVisibilityKeeper::DeleteContentNodeAndJoinTextNodesAroundIt(
    HTMLEditor& aHTMLEditor, nsIContent& aContentToDelete,
    const EditorDOMPoint& aCaretPoint, const Element& aEditingHost) {
  EditorDOMPoint atContent(&aContentToDelete);
  if (!atContent.IsSet()) {
    NS_WARNING("Deleting content node was an orphan node");
    return Err(NS_ERROR_FAILURE);
  }
  if (!HTMLEditUtils::IsRemovableNode(aContentToDelete)) {
    NS_WARNING("Deleting content node wasn't removable");
    return Err(NS_ERROR_FAILURE);
  }
  EditorDOMPoint pointToPutCaret(aCaretPoint);
  Maybe<AutoTrackDOMPoint> trackPointToPutCaret;
  if (aCaretPoint.IsSet()) {
    trackPointToPutCaret.emplace(aHTMLEditor.RangeUpdaterRef(),
                                 &pointToPutCaret);
  }
  // If we're removing a block, it may be surrounded by invisible
  // white-spaces.  We should remove them to avoid to make them accidentally
  // visible.
  if (HTMLEditUtils::IsBlockElement(
          aContentToDelete, BlockInlineCheck::UseComputedDisplayOutsideStyle)) {
    AutoTrackDOMPoint trackAtContent(aHTMLEditor.RangeUpdaterRef(), &atContent);
    {
      nsresult rv =
          WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore(
              aHTMLEditor, EditorDOMPoint(aContentToDelete.AsElement()));
      if (NS_FAILED(rv)) {
        NS_WARNING(
            "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesBefore()"
            " failed");
        return Err(rv);
      }
      if (NS_WARN_IF(!aContentToDelete.IsInComposedDoc())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
      rv = WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter(
          aHTMLEditor, EditorDOMPoint::After(*aContentToDelete.AsElement()));
      if (NS_FAILED(rv)) {
        NS_WARNING(
            "WhiteSpaceVisibilityKeeper::EnsureNoInvisibleWhiteSpacesAfter() "
            "failed");
        return Err(rv);
      }
      if (NS_WARN_IF(!aContentToDelete.IsInComposedDoc())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
      if (trackPointToPutCaret.isSome()) {
        trackPointToPutCaret->Flush(StopTracking::No);
      }
    }
    if (pointToPutCaret.IsInContentNode()) {
      // Additionally, we may put caret into the preceding block (this is the
      // case when caret was in an empty block and type `Backspace`, or when
      // caret is at end of the preceding block and type `Delete`).  In such
      // case, we need to normalize the white-space of the preceding `Text` of
      // the deleting empty block for the compatibility with the other
      // browsers.
      if (pointToPutCaret.IsBefore(EditorRawDOMPoint(&aContentToDelete))) {
        const WSScanResult nextThingOfCaretPoint = HTMLEditUtils::
            ScanInclusiveNextThingWithIgnoringUnnecessaryLineBreak(
                pointToPutCaret,
                // We never delete a line break in an empty block so that we can
                // treat it as significant and can skip the normalization.
                PaddingForEmptyBlock::Significant, aEditingHost);
        if (nextThingOfCaretPoint.ReachedBlockBoundary()) {
          const EditorDOMPoint atBlockBoundary =
              nextThingOfCaretPoint
                  .PointAtReachedBlockBoundaryOrEditingHostBoundary<
                      EditorDOMPoint>();
          Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
              WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(
                  aHTMLEditor, atBlockBoundary, {});
          if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
            NS_WARNING(
                "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore() "
                "failed");
            return afterLastVisibleThingOrError.propagateErr();
          }
          if (NS_WARN_IF(!aContentToDelete.IsInComposedDoc())) {
            return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
          }
          // If the previous content ends with an invisible line break, let's
          // delete it.
          const Maybe<EditorLineBreak>& unnecessaryLineBreak =
              nextThingOfCaretPoint.MaybeIgnoredLineBreak();
          if (unnecessaryLineBreak.isSome() &&
              unnecessaryLineBreak->IsInComposedDoc() &&
              unnecessaryLineBreak->IsInclusiveDescendantOf(aEditingHost)) {
            const WSScanResult prevThing =
                WSRunScanner::ScanPreviousVisibleNodeOrBlockBoundary(
                    {}, unnecessaryLineBreak->To<EditorRawDOMPoint>(),
                    &aEditingHost);
            if (!prevThing.ReachedLineBoundary()) {
              Result<EditorDOMPoint, nsresult> pointOrError =
                  aHTMLEditor.DeleteLineBreakWithTransaction(
                      unnecessaryLineBreak.ref(), nsIEditor::eStrip,
                      aEditingHost);
              if (MOZ_UNLIKELY(pointOrError.isErr())) {
                NS_WARNING(
                    "HTMLEditor::DeleteLineBreakWithTransaction() failed");
                return pointOrError.propagateErr();
              }
              trackPointToPutCaret->Flush(StopTracking::No);
            }
          }
        }
      }
      // Similarly, we may put caret into the following block (this is the
      // case when caret was in an empty block and type `Delete`, or when
      // caret is at start of the following block and type `Backspace`).  In
      // such case, we need to normalize the white-space of the following
      // `Text` of the deleting empty block for the compatibility with the
      // other browsers.
      else if (EditorRawDOMPoint::After(aContentToDelete)
                   .EqualsOrIsBefore(pointToPutCaret)) {
        const WSScanResult previousThingOfCaretPoint =
            WSRunScanner::ScanPreviousVisibleNodeOrBlockBoundary(
                {}, pointToPutCaret);
        if (previousThingOfCaretPoint.ReachedBlockBoundary()) {
          const EditorDOMPoint atBlockBoundary =
              previousThingOfCaretPoint.ReachedCurrentBlockBoundary()
                  ? EditorDOMPoint(previousThingOfCaretPoint.ElementPtr(), 0u)
                  : EditorDOMPoint(previousThingOfCaretPoint.ElementPtr());
          Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
              WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
                  aHTMLEditor, atBlockBoundary, {});
          if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
            NS_WARNING(
                "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter() "
                "failed");
            return atFirstVisibleThingOrError.propagateErr();
          }
          if (NS_WARN_IF(!aContentToDelete.IsInComposedDoc())) {
            return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
          }
        }
      }
    }
    trackAtContent.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!atContent.IsInContentNodeAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }
  // If we're deleting inline content which is not followed by visible
  // content, i.e., the preceding text will become the last Text node, we
  // should normalize the preceding white-spaces for compatibility with the
  // other browsers.
  else {
    const WSScanResult nextThing =
        WSRunScanner::ScanInclusiveNextVisibleNodeOrBlockBoundary(
            {}, EditorRawDOMPoint::After(aContentToDelete));
    if (nextThing.ReachedLineBoundary()) {
      AutoTrackDOMPoint trackAtContent(aHTMLEditor.RangeUpdaterRef(),
                                       &atContent);
      Result<EditorDOMPoint, nsresult> afterLastVisibleThingOrError =
          WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore(aHTMLEditor,
                                                                 atContent, {});
      if (MOZ_UNLIKELY(afterLastVisibleThingOrError.isErr())) {
        NS_WARNING(
            "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore() "
            "failed");
        return afterLastVisibleThingOrError.propagateErr();
      }
      trackAtContent.Flush(StopTracking::Yes);
      if (NS_WARN_IF(!atContent.IsInContentNodeAndValidInComposedDoc())) {
        return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
      }
    }
  }

  // Finally, we should normalize the following white-spaces for compatibility
  // with the other browsers.
  {
    AutoTrackDOMPoint trackAtContent(aHTMLEditor.RangeUpdaterRef(), &atContent);
    Result<EditorDOMPoint, nsresult> atFirstVisibleThingOrError =
        WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesAfter(
            aHTMLEditor, atContent.NextPoint(), {});
    if (MOZ_UNLIKELY(atFirstVisibleThingOrError.isErr())) {
      NS_WARNING(
          "WhiteSpaceVisibilityKeeper::NormalizeWhiteSpacesBefore() failed");
      return atFirstVisibleThingOrError.propagateErr();
    }
    trackAtContent.Flush(StopTracking::Yes);
    if (NS_WARN_IF(!atContent.IsInContentNodeAndValidInComposedDoc())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }

  const nsCOMPtr<nsIContent> previousEditableSibling =
      HTMLEditUtils::GetPreviousSibling(
          aContentToDelete, {LeafNodeOption::IgnoreNonEditableNode},
          BlockInlineCheck::UseComputedDisplayOutsideStyle);
  // Delete the node, and join like nodes if appropriate
  nsresult rv = aHTMLEditor.DeleteNodeWithTransaction(aContentToDelete);
  if (NS_FAILED(rv)) {
    NS_WARNING("EditorBase::DeleteNodeWithTransaction() failed");
    return Err(rv);
  }

  if (trackPointToPutCaret.isSome()) {
    trackPointToPutCaret->Flush(StopTracking::Yes);
    if (NS_WARN_IF(!pointToPutCaret.IsInContentNode())) {
      return Err(NS_ERROR_EDITOR_UNEXPECTED_DOM_TREE);
    }
  }

  // Are they both text nodes?  If so, join them!
  // XXX This may cause odd behavior if there is non-editable nodes
  //     around the atomic content.
  if (!aCaretPoint.IsInTextNode() || !previousEditableSibling ||
      !previousEditableSibling->IsText()) {
    return CaretPoint(std::move(pointToPutCaret));
  }

  nsIContent* const nextEditableSibling = HTMLEditUtils::GetNextSibling(
      *previousEditableSibling, {LeafNodeOption::IgnoreNonEditableNode},
      BlockInlineCheck::UseComputedDisplayOutsideStyle);
  if (aCaretPoint.GetContainer() != nextEditableSibling) {
    return CaretPoint(std::move(pointToPutCaret));
  }

  Result<JoinNodesResult, nsresult> joinTextNodesResultOrError =
      aHTMLEditor.JoinTextNodesWithNormalizeWhiteSpaces(
          MOZ_KnownLive(*previousEditableSibling->AsText()),
          MOZ_KnownLive(*aCaretPoint.ContainerAs<Text>()));
  if (MOZ_UNLIKELY(joinTextNodesResultOrError.isErr())) {
    NS_WARNING("HTMLEditor::JoinTextNodesWithNormalizeWhiteSpaces() failed");
    return joinTextNodesResultOrError.propagateErr();
  }
  return CaretPoint(
      joinTextNodesResultOrError.unwrap().AtJoinedPoint<EditorDOMPoint>());
}

// static
Result<CaretPoint, nsresult>
WhiteSpaceVisibilityKeeper::DeleteInvisibleASCIIWhiteSpaces(
    HTMLEditor& aHTMLEditor, const EditorDOMPoint& aPoint) {
  MOZ_ASSERT(aPoint.IsSet());
  const TextFragmentData textFragmentData(
      {WSRunScanner::Option::OnlyEditableNodes}, aPoint);
  if (NS_WARN_IF(!textFragmentData.IsInitialized())) {
    return Err(NS_ERROR_FAILURE);
  }
  const EditorDOMRange& leadingWhiteSpaceRange =
      textFragmentData.InvisibleLeadingWhiteSpaceRangeRef();
  // XXX Getting trailing white-space range now must be wrong because
  //     mutation event listener may invalidate it.
  const EditorDOMRange& trailingWhiteSpaceRange =
      textFragmentData.InvisibleTrailingWhiteSpaceRangeRef();
  EditorDOMPoint pointToPutCaret;
  DebugOnly<bool> leadingWhiteSpacesDeleted = false;
  if (leadingWhiteSpaceRange.IsPositioned() &&
      !leadingWhiteSpaceRange.Collapsed()) {
    Result<CaretPoint, nsresult> caretPointOrError =
        aHTMLEditor.DeleteTextAndTextNodesWithTransaction(
            leadingWhiteSpaceRange.StartRef(), leadingWhiteSpaceRange.EndRef(),
            HTMLEditor::TreatEmptyTextNodes::KeepIfContainerOfRangeBoundaries);
    if (MOZ_UNLIKELY(caretPointOrError.isErr())) {
      NS_WARNING("HTMLEditor::DeleteTextAndTextNodesWithTransaction() failed");
      return caretPointOrError;
    }
    caretPointOrError.unwrap().MoveCaretPointTo(
        pointToPutCaret, {SuggestCaret::OnlyIfHasSuggestion});
    leadingWhiteSpacesDeleted = true;
  }
  if (trailingWhiteSpaceRange.IsPositioned() &&
      !trailingWhiteSpaceRange.Collapsed() &&
      leadingWhiteSpaceRange != trailingWhiteSpaceRange) {
    NS_ASSERTION(!leadingWhiteSpacesDeleted,
                 "We're trying to remove trailing white-spaces with maybe "
                 "outdated range");
    AutoTrackDOMPoint trackPointToPutCaret(aHTMLEditor.RangeUpdaterRef(),
                                           &pointToPutCaret);
    Result<CaretPoint, nsresult> caretPointOrError =
        aHTMLEditor.DeleteTextAndTextNodesWithTransaction(
            trailingWhiteSpaceRange.StartRef(),
            trailingWhiteSpaceRange.EndRef(),
            HTMLEditor::TreatEmptyTextNodes::KeepIfContainerOfRangeBoundaries);
    if (MOZ_UNLIKELY(caretPointOrError.isErr())) {
      NS_WARNING("HTMLEditor::DeleteTextAndTextNodesWithTransaction() failed");
      return caretPointOrError.propagateErr();
    }
    trackPointToPutCaret.Flush(StopTracking::Yes);
    caretPointOrError.unwrap().MoveCaretPointTo(
        pointToPutCaret, {SuggestCaret::OnlyIfHasSuggestion});
  }
  return CaretPoint(std::move(pointToPutCaret));
}

}  // namespace mozilla
