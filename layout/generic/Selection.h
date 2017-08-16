/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_Selection_h__
#define mozilla_Selection_h__

#include "nsIWeakReference.h"

#include "mozilla/AutoRestore.h"
#include "mozilla/TextRange.h"
#include "mozilla/UniquePtr.h"
#include "nsISelection.h"
#include "nsISelectionController.h"
#include "nsISelectionListener.h"
#include "nsISelectionPrivate.h"
#include "nsRange.h"
#include "nsThreadUtils.h"
#include "nsWrapperCache.h"

struct CachedOffsetForFrame;
class nsAutoScrollTimer;
class nsIContentIterator;
class nsIDocument;
class nsIEditor;
class nsIFrame;
class nsIHTMLEditor;
class nsFrameSelection;
class nsPIDOMWindowOuter;
struct SelectionDetails;
struct SelectionCustomColors;
class nsCopySupport;
class nsHTMLCopyEncoder;

namespace mozilla {
class ErrorResult;
struct AutoPrepareFocusRange;
} // namespace mozilla

struct RangeData
{
  explicit RangeData(nsRange* aRange)
    : mRange(aRange)
  {}

  RefPtr<nsRange> mRange;
  mozilla::TextRangeStyle mTextRangeStyle;
};

// Note, the ownership of mozilla::dom::Selection depends on which way the
// object is created. When nsFrameSelection has created Selection,
// addreffing/releasing the Selection object is aggregated to nsFrameSelection.
// Otherwise normal addref/release is used.  This ensures that nsFrameSelection
// is never deleted before its Selections.
namespace mozilla {
namespace dom {

class Selection final : public nsISelectionPrivate,
                        public nsWrapperCache,
                        public nsSupportsWeakReference
{
protected:
  virtual ~Selection();

public:
  Selection();
  explicit Selection(nsFrameSelection *aList);

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(Selection, nsISelectionPrivate)
  NS_DECL_NSISELECTION
  NS_DECL_NSISELECTIONPRIVATE

  virtual Selection* AsSelection() override { return this; }

  nsresult EndBatchChangesInternal(int16_t aReason = nsISelectionListener::NO_REASON);

  nsIDocument* GetParentObject() const;

  // utility methods for scrolling the selection into view
  nsPresContext* GetPresContext() const;
  nsIPresShell* GetPresShell() const;
  nsFrameSelection* GetFrameSelection() const { return mFrameSelection; }
  // Returns a rect containing the selection region, and frame that that
  // position is relative to. For SELECTION_ANCHOR_REGION or
  // SELECTION_FOCUS_REGION the rect is a zero-width rectangle. For
  // SELECTION_WHOLE_SELECTION the rect contains both the anchor and focus
  // region rects.
  nsIFrame*     GetSelectionAnchorGeometry(SelectionRegion aRegion, nsRect *aRect);
  // Returns the position of the region (SELECTION_ANCHOR_REGION or
  // SELECTION_FOCUS_REGION only), and frame that that position is relative to.
  // The 'position' is a zero-width rectangle.
  nsIFrame*     GetSelectionEndPointGeometry(SelectionRegion aRegion, nsRect *aRect);

  nsresult      PostScrollSelectionIntoViewEvent(
                                        SelectionRegion aRegion,
                                        int32_t aFlags,
                                        nsIPresShell::ScrollAxis aVertical,
                                        nsIPresShell::ScrollAxis aHorizontal);
  enum {
    SCROLL_SYNCHRONOUS = 1<<1,
    SCROLL_FIRST_ANCESTOR_ONLY = 1<<2,
    SCROLL_DO_FLUSH = 1<<3,  // only matters if SCROLL_SYNCHRONOUS is passed too
    SCROLL_OVERFLOW_HIDDEN = 1<<5,
    SCROLL_FOR_CARET_MOVE = 1<<6
  };
  // If aFlags doesn't contain SCROLL_SYNCHRONOUS, then we'll flush when
  // the scroll event fires so we make sure to scroll to the right place.
  // Otherwise, if SCROLL_DO_FLUSH is also in aFlags, then this method will
  // flush layout and you MUST hold a strong ref on 'this' for the duration
  // of this call.  This might destroy arbitrary layout objects.
  nsresult      ScrollIntoView(SelectionRegion aRegion,
                               nsIPresShell::ScrollAxis aVertical =
                                 nsIPresShell::ScrollAxis(),
                               nsIPresShell::ScrollAxis aHorizontal =
                                 nsIPresShell::ScrollAxis(),
                               int32_t aFlags = 0);
  nsresult      SubtractRange(RangeData* aRange, nsRange* aSubtract,
                              nsTArray<RangeData>* aOutput);
  /**
   * AddItem adds aRange to this Selection.  If mUserInitiated is true,
   * then aRange is first scanned for -moz-user-select:none nodes and split up
   * into multiple ranges to exclude those before adding the resulting ranges
   * to this Selection.
   */
  nsresult      AddItem(nsRange* aRange, int32_t* aOutIndex, bool aNoStartSelect = false);
  nsresult      RemoveItem(nsRange* aRange);
  nsresult      RemoveCollapsedRanges();
  nsresult      Clear(nsPresContext* aPresContext);
  nsresult      Collapse(nsINode* aParentNode, int32_t aOffset);
  nsresult      Extend(nsINode* aParentNode, int32_t aOffset);
  nsRange*      GetRangeAt(int32_t aIndex) const;

  // Get the anchor-to-focus range if we don't care which end is
  // anchor and which end is focus.
  const nsRange* GetAnchorFocusRange() const {
    return mAnchorFocusRange;
  }

  nsDirection  GetDirection(){return mDirection;}
  void         SetDirection(nsDirection aDir){mDirection = aDir;}
  nsresult     SetAnchorFocusToRange(nsRange *aRange);
  void         ReplaceAnchorFocusRange(nsRange *aRange);
  void         AdjustAnchorFocusForMultiRange(nsDirection aDirection);

  //  NS_IMETHOD   GetPrimaryFrameForRangeEndpoint(nsIDOMNode *aNode, int32_t aOffset, bool aIsEndNode, nsIFrame **aResultFrame);
  NS_IMETHOD   GetPrimaryFrameForAnchorNode(nsIFrame **aResultFrame);
  NS_IMETHOD   GetPrimaryFrameForFocusNode(nsIFrame **aResultFrame, int32_t *aOffset, bool aVisual);

  UniquePtr<SelectionDetails> LookUpSelection(
    nsIContent* aContent,
    int32_t aContentOffset,
    int32_t aContentLength,
    UniquePtr<SelectionDetails> aDetailsHead,
    SelectionType aSelectionType,
    bool aSlowCheck);

  NS_IMETHOD   Repaint(nsPresContext* aPresContext);

  // Note: StartAutoScrollTimer might destroy arbitrary frames etc.
  nsresult     StartAutoScrollTimer(nsIFrame *aFrame,
                                    nsPoint& aPoint,
                                    uint32_t aDelay);

  nsresult     StopAutoScrollTimer();

  JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  // WebIDL methods
  nsINode*     GetAnchorNode();
  uint32_t     AnchorOffset();
  nsINode*     GetFocusNode();
  uint32_t     FocusOffset();

  bool IsCollapsed() const;

  // *JS() methods are mapped to Selection.*().
  // They may move focus only when the range represents normal selection.
  // These methods shouldn't be used by non-JS callers.
  void CollapseJS(nsINode* aNode, uint32_t aOffset,
                  mozilla::ErrorResult& aRv);
  void CollapseToStartJS(mozilla::ErrorResult& aRv);
  void CollapseToEndJS(mozilla::ErrorResult& aRv);

  void ExtendJS(nsINode& aNode, uint32_t aOffset,
                mozilla::ErrorResult& aRv);

  void SelectAllChildrenJS(nsINode& aNode, mozilla::ErrorResult& aRv);

  void DeleteFromDocument(mozilla::ErrorResult& aRv);

  uint32_t RangeCount() const
  {
    return mRanges.Length();
  }
  nsRange* GetRangeAt(uint32_t aIndex, mozilla::ErrorResult& aRv);
  void AddRangeJS(nsRange& aRange, mozilla::ErrorResult& aRv);
  void RemoveRange(nsRange& aRange, mozilla::ErrorResult& aRv);
  void RemoveAllRanges(mozilla::ErrorResult& aRv);

  void Stringify(nsAString& aResult);

  bool ContainsNode(nsINode& aNode, bool aPartlyContained, mozilla::ErrorResult& aRv);

  /**
   * Check to see if the given point is contained within the selection area. In
   * particular, this iterates through all the rects that make up the selection,
   * not just the bounding box, and checks to see if the given point is contained
   * in any one of them.
   * @param aPoint The point to check, relative to the root frame.
   */
  bool ContainsPoint(const nsPoint& aPoint);

  void Modify(const nsAString& aAlter, const nsAString& aDirection,
              const nsAString& aGranularity, mozilla::ErrorResult& aRv);

  void SetBaseAndExtentJS(nsINode& aAnchorNode, uint32_t aAnchorOffset,
                          nsINode& aFocusNode, uint32_t aFocusOffset,
                          mozilla::ErrorResult& aRv);

  bool GetInterlinePosition(mozilla::ErrorResult& aRv);
  void SetInterlinePosition(bool aValue, mozilla::ErrorResult& aRv);

  Nullable<int16_t> GetCaretBidiLevel(mozilla::ErrorResult& aRv) const;
  void SetCaretBidiLevel(const Nullable<int16_t>& aCaretBidiLevel, mozilla::ErrorResult& aRv);

  void ToStringWithFormat(const nsAString& aFormatType,
                          uint32_t aFlags,
                          int32_t aWrapColumn,
                          nsAString& aReturn,
                          mozilla::ErrorResult& aRv);
  void AddSelectionListener(nsISelectionListener* aListener,
                            mozilla::ErrorResult& aRv);
  void RemoveSelectionListener(nsISelectionListener* aListener,
                               mozilla::ErrorResult& aRv);

  RawSelectionType RawType() const
  {
    return ToRawSelectionType(mSelectionType);
  }
  SelectionType Type() const { return mSelectionType; }

  void GetRangesForInterval(nsINode& aBeginNode, int32_t aBeginOffset,
                            nsINode& aEndNode, int32_t aEndOffset,
                            bool aAllowAdjacent,
                            nsTArray<RefPtr<nsRange>>& aReturn,
                            mozilla::ErrorResult& aRv);

  void ScrollIntoView(int16_t aRegion, bool aIsSynchronous,
                      int16_t aVPercent, int16_t aHPercent,
                      mozilla::ErrorResult& aRv);

  void SetColors(const nsAString& aForeColor, const nsAString& aBackColor,
                 const nsAString& aAltForeColor, const nsAString& aAltBackColor,
                 mozilla::ErrorResult& aRv);

  void ResetColors(mozilla::ErrorResult& aRv);

  // Non-JS callers should use the following methods.
  void Collapse(nsINode& aNode, uint32_t aOffset, mozilla::ErrorResult& aRv);
  void CollapseToStart(mozilla::ErrorResult& aRv);
  void CollapseToEnd(mozilla::ErrorResult& aRv);
  void Extend(nsINode& aNode, uint32_t aOffset, mozilla::ErrorResult& aRv);
  void AddRange(nsRange& aRange, mozilla::ErrorResult& aRv);
  void SelectAllChildren(nsINode& aNode, mozilla::ErrorResult& aRv);
  void SetBaseAndExtent(nsINode& aAnchorNode, uint32_t aAnchorOffset,
                        nsINode& aFocusNode, uint32_t aFocusOffset,
                        mozilla::ErrorResult& aRv);

  void AddSelectionChangeBlocker();
  void RemoveSelectionChangeBlocker();
  bool IsBlockingSelectionChangeEvents() const;
private:
  friend class ::nsAutoScrollTimer;

  // Note: DoAutoScroll might destroy arbitrary frames etc.
  nsresult DoAutoScroll(nsIFrame *aFrame, nsPoint& aPoint);

  // XXX Please don't add additional uses of this method, it's only for
  // XXX supporting broken code (bug 1245883) in the following classes:
  friend class ::nsCopySupport;
  friend class ::nsHTMLCopyEncoder;
  void AddRangeInternal(nsRange& aRange, nsIDocument* aDocument, ErrorResult&);

public:
  SelectionType GetType() const { return mSelectionType; }
  void SetType(SelectionType aSelectionType)
  {
    mSelectionType = aSelectionType;
  }

  SelectionCustomColors* GetCustomColors() const { return mCustomColors.get(); }

  nsresult NotifySelectionListeners(bool aCalledByJS);
  nsresult NotifySelectionListeners();

  friend struct AutoUserInitiated;
  struct MOZ_RAII AutoUserInitiated
  {
    explicit AutoUserInitiated(Selection* aSelection
                               MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mSavedValue(aSelection->mUserInitiated)
    {
      MOZ_GUARD_OBJECT_NOTIFIER_INIT;
      aSelection->mUserInitiated = true;
    }
    AutoRestore<bool> mSavedValue;
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
  };

private:
  friend struct mozilla::AutoPrepareFocusRange;
  class ScrollSelectionIntoViewEvent;
  friend class ScrollSelectionIntoViewEvent;

  class ScrollSelectionIntoViewEvent : public Runnable {
  public:
    NS_DECL_NSIRUNNABLE
    ScrollSelectionIntoViewEvent(Selection* aSelection,
                                 SelectionRegion aRegion,
                                 nsIPresShell::ScrollAxis aVertical,
                                 nsIPresShell::ScrollAxis aHorizontal,
                                 int32_t aFlags)
      : mSelection(aSelection),
        mRegion(aRegion),
        mVerticalScroll(aVertical),
        mHorizontalScroll(aHorizontal),
        mFlags(aFlags) {
      NS_ASSERTION(aSelection, "null parameter");
    }
    void Revoke() { mSelection = nullptr; }
  private:
    Selection *mSelection;
    SelectionRegion mRegion;
    nsIPresShell::ScrollAxis mVerticalScroll;
    nsIPresShell::ScrollAxis mHorizontalScroll;
    int32_t mFlags;
  };

  /**
   * Set mAnchorFocusRange to mRanges[aIndex] if aIndex is a valid index.
   * Set mAnchorFocusRange to nullptr if aIndex is negative.
   * Otherwise, i.e., if aIndex is positive but out of bounds of mRanges, do
   * nothing.
   */
  void SetAnchorFocusRange(int32_t aIndex);
  void SelectFramesForContent(nsIContent* aContent, bool aSelected);
  nsresult SelectAllFramesForContent(nsIContentIterator* aInnerIter,
                                     nsIContent *aContent,
                                     bool aSelected);
  nsresult SelectFrames(nsPresContext* aPresContext,
                        nsRange* aRange,
                        bool aSelect);
  nsresult GetTableCellLocationFromRange(nsRange* aRange,
                                         int32_t* aSelectionType,
                                         int32_t* aRow,
                                         int32_t* aCol);
  nsresult AddTableCellRange(nsRange* aRange,
                             bool* aDidAddRange,
                             int32_t* aOutIndex);

  nsresult FindInsertionPoint(
      nsTArray<RangeData>* aElementArray,
      nsINode* aPointNode, int32_t aPointOffset,
      nsresult (*aComparator)(nsINode*,int32_t,nsRange*,int32_t*),
      int32_t* aPoint);
  bool EqualsRangeAtPoint(nsINode* aBeginNode, int32_t aBeginOffset,
                            nsINode* aEndNode, int32_t aEndOffset,
                            int32_t aRangeIndex);
  nsresult GetIndicesForInterval(nsINode* aBeginNode, int32_t aBeginOffset,
                                 nsINode* aEndNode, int32_t aEndOffset,
                                 bool aAllowAdjacent,
                                 int32_t* aStartIndex, int32_t* aEndIndex);
  RangeData* FindRangeData(nsIDOMRange* aRange);

  void UserSelectRangesToAdd(nsRange* aItem, nsTArray<RefPtr<nsRange> >& rangesToAdd);

  /**
   * Helper method for AddItem.
   */
  nsresult AddItemInternal(nsRange* aRange, int32_t* aOutIndex);

  nsIDocument* GetDocument() const;
  nsPIDOMWindowOuter* GetWindow() const;
  nsIEditor* GetEditor() const;

  /**
   * GetCommonEditingHostForAllRanges() returns common editing host of all
   * ranges if there is. If at least one of the ranges is in non-editable
   * element, returns nullptr.  See following examples for the detail:
   *
   *  <div id="a" contenteditable>
   *    an[cestor
   *    <div id="b" contenteditable="false">
   *      non-editable
   *      <div id="c" contenteditable>
   *        desc]endant
   *  in this case, this returns div#a because div#c is also in div#a.
   *
   *  <div id="a" contenteditable>
   *    an[ce]stor
   *    <div id="b" contenteditable="false">
   *      non-editable
   *      <div id="c" contenteditable>
   *        de[sc]endant
   *  in this case, this returns div#a because second range is also in div#a
   *  and common ancestor of the range (i.e., div#c) is editable.
   *
   *  <div id="a" contenteditable>
   *    an[ce]stor
   *    <div id="b" contenteditable="false">
   *      [non]-editable
   *      <div id="c" contenteditable>
   *        de[sc]endant
   *  in this case, this returns nullptr because the second range is in
   *  non-editable area.
   */
  Element* GetCommonEditingHostForAllRanges();

  // These are the ranges inside this selection. They are kept sorted in order
  // of DOM start position.
  //
  // This data structure is sorted by the range beginnings. As the ranges are
  // disjoint, it is also implicitly sorted by the range endings. This allows
  // us to perform binary searches when searching for existence of a range,
  // giving us O(log n) search time.
  //
  // Inserting a new range requires finding the overlapping interval, requiring
  // two binary searches plus up to an additional 6 DOM comparisons. If this
  // proves to be a performance concern, then an interval tree may be a
  // possible solution, allowing the calculation of the overlap interval in
  // O(log n) time, though this would require rebalancing and other overhead.
  nsTArray<RangeData> mRanges;

  RefPtr<nsRange> mAnchorFocusRange;
  RefPtr<nsFrameSelection> mFrameSelection;
  RefPtr<nsAutoScrollTimer> mAutoScrollTimer;
  FallibleTArray<nsCOMPtr<nsISelectionListener>> mSelectionListeners;
  nsRevocableEventPtr<ScrollSelectionIntoViewEvent> mScrollEvent;
  CachedOffsetForFrame* mCachedOffsetForFrame;
  nsDirection mDirection;
  SelectionType mSelectionType;
  UniquePtr<SelectionCustomColors> mCustomColors;

  /**
   * True if the current selection operation was initiated by user action.
   * It determines whether we exclude -moz-user-select:none nodes or not,
   * as well as whether selectstart events will be fired.
   */
  bool mUserInitiated;

  /**
   * When the selection change is caused by a call of Selection API,
   * mCalledByJS is true.  Otherwise, false.
   */
  bool mCalledByJS;

  // Non-zero if we don't want any changes we make to the selection to be
  // visible to content. If non-zero, content won't be notified about changes.
  uint32_t mSelectionChangeBlockerCount;
};

// Stack-class to turn on/off selection batching.
class MOZ_STACK_CLASS SelectionBatcher final
{
private:
  RefPtr<Selection> mSelection;
public:
  explicit SelectionBatcher(Selection* aSelection)
  {
    mSelection = aSelection;
    if (mSelection) {
      mSelection->StartBatchChanges();
    }
  }

  ~SelectionBatcher()
  {
    if (mSelection) {
      mSelection->EndBatchChangesInternal();
    }
  }
};

class MOZ_RAII AutoHideSelectionChanges final
{
private:
  RefPtr<Selection> mSelection;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
public:
  explicit AutoHideSelectionChanges(const nsFrameSelection* aFrame);

  explicit AutoHideSelectionChanges(Selection* aSelection
                                    MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : mSelection(aSelection)
  {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    mSelection = aSelection;
    if (mSelection) {
      mSelection->AddSelectionChangeBlocker();
    }
  }

  ~AutoHideSelectionChanges()
  {
    if (mSelection) {
      mSelection->RemoveSelectionChangeBlocker();
    }
  }
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_Selection_h__
