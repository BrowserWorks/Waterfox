/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_TextServicesDocument_h
#define mozilla_TextServicesDocument_h

#include "nsCOMPtr.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIEditActionListener.h"
#include "nsISupportsImpl.h"
#include "nsStringFwd.h"
#include "nsTArray.h"
#include "nscore.h"

class nsIContent;
class nsIEditor;
class nsINode;
class nsISelectionController;
class nsRange;

namespace mozilla {

class FilteredContentIterator;
class OffsetEntry;
class TextEditor;

namespace dom {
class AbstractRange;
class Document;
class Element;
class StaticRange;
};  // namespace dom

/**
 * The TextServicesDocument presents the document in as a bunch of flattened
 * text blocks. Each text block can be retrieved as an nsString.
 */
class TextServicesDocument final : public nsIEditActionListener {
 private:
  enum class IteratorStatus : uint8_t {
    // No iterator (I), or iterator doesn't point to anything valid.
    eDone = 0,
    // I points to first text node (TN) in current block (CB).
    eValid,
    // No TN in CB, I points to first TN in prev block.
    ePrev,
    // No TN in CB, I points to first TN in next block.
    eNext,
  };

  RefPtr<dom::Document> mDocument;
  nsCOMPtr<nsISelectionController> mSelCon;
  RefPtr<TextEditor> mTextEditor;
  RefPtr<FilteredContentIterator> mFilteredIter;
  nsCOMPtr<nsIContent> mPrevTextBlock;
  nsCOMPtr<nsIContent> mNextTextBlock;
  nsTArray<OffsetEntry*> mOffsetTable;
  RefPtr<nsRange> mExtent;
  uint32_t mTxtSvcFilterType;

  int32_t mSelStartIndex;
  int32_t mSelStartOffset;
  int32_t mSelEndIndex;
  int32_t mSelEndOffset;

  IteratorStatus mIteratorStatus;

 protected:
  virtual ~TextServicesDocument();

 public:
  TextServicesDocument();

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_CLASS(TextServicesDocument)

  /**
   * Initializes the text services document to use a particular editor. The
   * text services document will use the DOM document and presentation shell
   * used by the editor.
   *
   * @param aEditor             The editor to use.
   */
  nsresult InitWithEditor(nsIEditor* aEditor);

  /**
   * Sets the range/extent over which the text services document will iterate.
   * Note that InitWithEditor() should have been called prior to calling this
   * method.  If this method is never called, the text services defaults to
   * iterating over the entire document.
   *
   * @param aAbstractRange      The range to use. aAbstractRange must point to a
   *                            valid range object.
   */
  nsresult SetExtent(const dom::AbstractRange* aAbstractRange);

  /**
   * Expands the end points of the range so that it spans complete words.  This
   * call does not change any internal state of the text services document.
   *
   * @param aStaticRange        [in/out] The range to be expanded/adjusted.
   */
  nsresult ExpandRangeToWordBoundaries(dom::StaticRange* aStaticRange);

  /**
   * Sets the filter type to be used while iterating over content.
   * This will clear the current filter type if it's not either
   * FILTERTYPE_NORMAL or FILTERTYPE_MAIL.
   *
   * @param aFilterType         The filter type to be used while iterating over
   *                            content.
   */
  nsresult SetFilterType(uint32_t aFilterType);

  /**
   * Returns the text in the current text block.
   *
   * @param aStr                [OUT] This will contain the text.
   */
  nsresult GetCurrentTextBlock(nsAString& aStr);

  /**
   * Tells the document to point to the first text block in the document.  This
   * method does not adjust the current cursor position or selection.
   */
  nsresult FirstBlock();

  enum class BlockSelectionStatus {
    // There is no text block (TB) in or before the selection (S).
    eBlockNotFound = 0,
    // No TB in S, but found one before/after S.
    eBlockOutside,
    // S extends beyond the start and end of TB.
    eBlockInside,
    // TB contains entire S.
    eBlockContains,
    // S begins or ends in TB but extends outside of TB.
    eBlockPartial,
  };

  /**
   * Tells the document to point to the last text block that contains the
   * current selection or caret.
   *
   * @param aSelectionStatus    [OUT] This will contain the text block
   *                            selection status.
   * @param aSelectionOffset    [OUT] This will contain the offset into the
   *                            string returned by GetCurrentTextBlock() where
   *                            the selection begins.
   * @param aLength             [OUT] This will contain the number of
   *                            characters that are selected in the string.
   */
  MOZ_CAN_RUN_SCRIPT
  nsresult LastSelectedBlock(BlockSelectionStatus* aSelStatus,
                             int32_t* aSelOffset, int32_t* aSelLength);

  /**
   * Tells the document to point to the text block before the current one.
   * This method will return NS_OK, even if there is no previous block.
   * Callers should call IsDone() to check if we have gone beyond the first
   * text block in the document.
   */
  nsresult PrevBlock();

  /**
   * Tells the document to point to the text block after the current one.
   * This method will return NS_OK, even if there is no next block. Callers
   * should call IsDone() to check if we have gone beyond the last text block
   * in the document.
   */
  nsresult NextBlock();

  /**
   * IsDone() will always set aIsDone == false unless the document contains
   * no text, PrevBlock() was called while the document was already pointing
   * to the first text block in the document, or NextBlock() was called while
   * the document was already pointing to the last text block in the document.
   *
   * @param aIsDone             [OUT] This will contain the result.
   */
  nsresult IsDone(bool* aIsDone);

  /**
   * SetSelection() allows the caller to set the selection based on an offset
   * into the string returned by GetCurrentTextBlock().  A length of zero
   * places the cursor at that offset. A positive non-zero length "n" selects
   * n characters in the string.
   *
   * @param aOffset             Offset into string returned by
   *                            GetCurrentTextBlock().
   * @param aLength             Number of characters selected.
   */
  MOZ_CAN_RUN_SCRIPT
  nsresult SetSelection(int32_t aOffset, int32_t aLength);

  /**
   * Scrolls the document so that the current selection is visible.
   */
  nsresult ScrollSelectionIntoView();

  /**
   * Deletes the text selected by SetSelection(). Calling DeleteSelection()
   * with nothing selected, or with a collapsed selection (cursor) does
   * nothing and returns NS_OK.
   */
  MOZ_CAN_RUN_SCRIPT
  nsresult DeleteSelection();

  /**
   * Inserts the given text at the current cursor position.  If there is a
   * selection, it will be deleted before the text is inserted.
   */
  MOZ_CAN_RUN_SCRIPT
  nsresult InsertText(const nsAString& aText);

  /**
   * nsIEditActionListener method implementations.
   */
  NS_DECL_NSIEDITACTIONLISTENER

  /**
   * Actual edit action listeners.  When you add new method here for listening
   * to new edit action, you need to make it called by EditorBase.
   * Additionally, you need to call it from proper method of
   * nsIEditActionListener too because if this is created not for inline
   * spell checker of the editor, edit actions will be notified via
   * nsIEditActionListener (slow path, though).
   */
  void DidDeleteNode(nsINode* aChild);
  void DidJoinNodes(nsINode& aLeftNode, nsINode& aRightNode);

  // TODO: We should get rid of this method since `aAbstractRange` has
  //       enough simple API to get them.
  static nsresult GetRangeEndPoints(const dom::AbstractRange* aAbstractRange,
                                    nsINode** aStartContainer,
                                    int32_t* aStartOffset,
                                    nsINode** aEndContainer,
                                    int32_t* aEndOffset);

 private:
  nsresult CreateFilteredContentIterator(
      const dom::AbstractRange* aAbstractRange,
      FilteredContentIterator** aFilteredIter);

  dom::Element* GetDocumentContentRootNode() const;
  already_AddRefed<nsRange> CreateDocumentContentRange();
  already_AddRefed<nsRange> CreateDocumentContentRootToNodeOffsetRange(
      nsINode* aParent, uint32_t aOffset, bool aToStart);
  nsresult CreateDocumentContentIterator(
      FilteredContentIterator** aFilteredIter);

  nsresult AdjustContentIterator();

  static nsresult FirstTextNode(FilteredContentIterator* aFilteredIter,
                                IteratorStatus* aIteratorStatus);
  static nsresult LastTextNode(FilteredContentIterator* aFilteredIter,
                               IteratorStatus* aIteratorStatus);

  static nsresult FirstTextNodeInCurrentBlock(
      FilteredContentIterator* aFilteredIter);
  static nsresult FirstTextNodeInPrevBlock(
      FilteredContentIterator* aFilteredIter);
  static nsresult FirstTextNodeInNextBlock(
      FilteredContentIterator* aFilteredIter);

  nsresult GetFirstTextNodeInPrevBlock(nsIContent** aContent);
  nsresult GetFirstTextNodeInNextBlock(nsIContent** aContent);

  static bool IsBlockNode(nsIContent* aContent);
  static bool IsTextNode(nsIContent* aContent);

  static bool DidSkip(FilteredContentIterator* aFilteredIter);
  static void ClearDidSkip(FilteredContentIterator* aFilteredIter);

  static bool HasSameBlockNodeParent(nsIContent* aContent1,
                                     nsIContent* aContent2);

  MOZ_CAN_RUN_SCRIPT
  nsresult SetSelectionInternal(int32_t aOffset, int32_t aLength,
                                bool aDoUpdate);
  MOZ_CAN_RUN_SCRIPT
  nsresult GetSelection(BlockSelectionStatus* aSelStatus, int32_t* aSelOffset,
                        int32_t* aSelLength);
  MOZ_CAN_RUN_SCRIPT
  nsresult GetCollapsedSelection(BlockSelectionStatus* aSelStatus,
                                 int32_t* aSelOffset, int32_t* aSelLength);
  nsresult GetUncollapsedSelection(BlockSelectionStatus* aSelStatus,
                                   int32_t* aSelOffset, int32_t* aSelLength);

  bool SelectionIsCollapsed();
  bool SelectionIsValid();

  static nsresult CreateOffsetTable(nsTArray<OffsetEntry*>* aOffsetTable,
                                    FilteredContentIterator* aFilteredIter,
                                    IteratorStatus* aIteratorStatus,
                                    nsRange* aIterRange, nsAString* aStr);
  static nsresult ClearOffsetTable(nsTArray<OffsetEntry*>* aOffsetTable);

  static nsresult NodeHasOffsetEntry(nsTArray<OffsetEntry*>* aOffsetTable,
                                     nsINode* aNode, bool* aHasEntry,
                                     int32_t* aEntryIndex);

  nsresult RemoveInvalidOffsetEntries();
  nsresult SplitOffsetEntry(int32_t aTableIndex, int32_t aOffsetIntoEntry);

  static nsresult FindWordBounds(nsTArray<OffsetEntry*>* aOffsetTable,
                                 nsString* aBlockStr, nsINode* aNode,
                                 int32_t aNodeOffset, nsINode** aWordStartNode,
                                 int32_t* aWordStartOffset,
                                 nsINode** aWordEndNode,
                                 int32_t* aWordEndOffset);
};

}  // namespace mozilla

#endif  // #ifndef mozilla_TextServicesDocument_h
