/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ContentEventHandler_h_
#define mozilla_ContentEventHandler_h_

#include "mozilla/EventForwards.h"
#include "mozilla/dom/Selection.h"
#include "nsCOMPtr.h"
#include "nsIFrame.h"
#include "nsINode.h"
#include "nsISelectionController.h"
#include "nsRange.h"

class nsPresContext;

struct nsRect;

namespace mozilla {

enum LineBreakType
{
  LINE_BREAK_TYPE_NATIVE,
  LINE_BREAK_TYPE_XP
};

/*
 * Query Content Event Handler
 *   ContentEventHandler is a helper class for EventStateManager.
 *   The platforms request some content informations, e.g., the selected text,
 *   the offset of the selected text and the text for specified range.
 *   This class answers to NS_QUERY_* events from actual contents.
 */

class MOZ_STACK_CLASS ContentEventHandler
{
public:
  typedef dom::Selection Selection;

  explicit ContentEventHandler(nsPresContext* aPresContext);

  // Handle aEvent in the current process.
  nsresult HandleQueryContentEvent(WidgetQueryContentEvent* aEvent);

  // eQuerySelectedText event handler
  nsresult OnQuerySelectedText(WidgetQueryContentEvent* aEvent);
  // eQueryTextContent event handler
  nsresult OnQueryTextContent(WidgetQueryContentEvent* aEvent);
  // eQueryCaretRect event handler
  nsresult OnQueryCaretRect(WidgetQueryContentEvent* aEvent);
  // eQueryTextRect event handler
  nsresult OnQueryTextRect(WidgetQueryContentEvent* aEvent);
  // eQueryTextRectArray event handler
  nsresult OnQueryTextRectArray(WidgetQueryContentEvent* aEvent);
  // eQueryEditorRect event handler
  nsresult OnQueryEditorRect(WidgetQueryContentEvent* aEvent);
  // eQueryContentState event handler
  nsresult OnQueryContentState(WidgetQueryContentEvent* aEvent);
  // eQuerySelectionAsTransferable event handler
  nsresult OnQuerySelectionAsTransferable(WidgetQueryContentEvent* aEvent);
  // eQueryCharacterAtPoint event handler
  nsresult OnQueryCharacterAtPoint(WidgetQueryContentEvent* aEvent);
  // eQueryDOMWidgetHittest event handler
  nsresult OnQueryDOMWidgetHittest(WidgetQueryContentEvent* aEvent);

  // NS_SELECTION_* event
  nsresult OnSelectionEvent(WidgetSelectionEvent* aEvent);

protected:
  nsPresContext* mPresContext;
  nsCOMPtr<nsIPresShell> mPresShell;
  // mSelection is typically normal selection but if OnQuerySelectedText()
  // is called, i.e., handling eQuerySelectedText, it's the specified selection
  // by WidgetQueryContentEvent::mInput::mSelectionType.
  RefPtr<Selection> mSelection;
  // mFirstSelectedRange is the first selected range of mSelection.  If
  // mSelection is normal selection, this must not be nullptr if Init()
  // succeed.  Otherwise, this may be nullptr if there are no selection
  // ranges.
  RefPtr<nsRange> mFirstSelectedRange;
  nsCOMPtr<nsIContent> mRootContent;

  nsresult Init(WidgetQueryContentEvent* aEvent);
  nsresult Init(WidgetSelectionEvent* aEvent);

  nsresult InitBasic();
  nsresult InitCommon(SelectionType aSelectionType = SelectionType::eNormal);
  /**
   * InitRootContent() computes the root content of current focused editor.
   *
   * @param aNormalSelection    This must be a Selection instance whose type is
   *                            SelectionType::eNormal.
   */
  nsresult InitRootContent(Selection* aNormalSelection);

public:
  // FlatText means the text that is generated from DOM tree. The BR elements
  // are replaced to native linefeeds. Other elements are ignored.

  // NodePosition stores a pair of node and offset in the node.
  // When mNode is an element and mOffset is 0, the start position means after
  // the open tag of mNode.
  // This is useful to receive one or more sets of them instead of nsRange.
  struct NodePosition
  {
    nsCOMPtr<nsINode> mNode;
    int32_t mOffset;
    // Only when mNode is an element node and mOffset is 0, mAfterOpenTag is
    // referred.
    bool mAfterOpenTag;

    NodePosition()
      : mOffset(-1)
      , mAfterOpenTag(true)
    {
    }

    NodePosition(nsINode* aNode, int32_t aOffset)
      : mNode(aNode)
      , mOffset(aOffset)
      , mAfterOpenTag(true)
    {
    }

    explicit NodePosition(const nsIFrame::ContentOffsets& aContentOffsets)
      : mNode(aContentOffsets.content)
      , mOffset(aContentOffsets.offset)
      , mAfterOpenTag(true)
    {
    }

  protected:
    NodePosition(nsINode* aNode, int32_t aOffset, bool aAfterOpenTag)
      : mNode(aNode)
      , mOffset(aOffset)
      , mAfterOpenTag(aAfterOpenTag)
    {
    }

  public:
    bool operator==(const NodePosition& aOther) const
    {
      return mNode == aOther.mNode &&
             mOffset == aOther.mOffset &&
             mAfterOpenTag == aOther.mAfterOpenTag;
    }

    bool IsValid() const
    {
      return mNode && mOffset >= 0;
    }
    bool OffsetIsValid() const
    {
      return IsValid() && static_cast<uint32_t>(mOffset) <= mNode->Length();
    }
    bool IsBeforeOpenTag() const
    {
      return IsValid() && mNode->IsElement() && !mOffset && !mAfterOpenTag;
    }
    bool IsImmediatelyAfterOpenTag() const
    {
      return IsValid() && mNode->IsElement() && !mOffset && mAfterOpenTag;
    }
    nsresult SetToRangeStart(nsRange* aRange) const
    {
      nsCOMPtr<nsIDOMNode> domNode(do_QueryInterface(mNode));
      return aRange->SetStart(domNode, mOffset);
    }
    nsresult SetToRangeEnd(nsRange* aRange) const
    {
      nsCOMPtr<nsIDOMNode> domNode(do_QueryInterface(mNode));
      return aRange->SetEnd(domNode, mOffset);
    }
    nsresult SetToRangeEndAfter(nsRange* aRange) const
    {
      nsCOMPtr<nsIDOMNode> domNode(do_QueryInterface(mNode));
      return aRange->SetEndAfter(domNode);
    }
  };

  // NodePositionBefore isn't good name if mNode isn't an element node nor
  // mOffset is not 0, though, when mNode is an element node and mOffset is 0,
  // this is treated as before the open tag of mNode.
  struct NodePositionBefore final : public NodePosition
  {
    NodePositionBefore(nsINode* aNode, int32_t aOffset)
      : NodePosition(aNode, aOffset, false)
    {
    }
  };

  // Get the flatten text length in the range.
  // @param aStartPosition      Start node and offset in the node of the range.
  // @param aEndPosition        End node and offset in the node of the range.
  // @param aRootContent        The root content of the editor or document.
  //                            aRootContent won't cause any text including
  //                            line breaks.
  // @param aLength             The result of the flatten text length of the
  //                            range.
  // @param aLineBreakType      Whether this computes flatten text length with
  //                            native line breakers on the platform or
  //                            with XP line breaker (\n).
  // @param aIsRemovingNode     Should be true only when this is called from
  //                            nsIMutationObserver::ContentRemoved().
  //                            When this is true, aStartPosition.mNode should
  //                            be the root node of removing nodes and mOffset
  //                            should be 0 and aEndPosition.mNode should be
  //                            same as aStartPosition.mNode and mOffset should
  //                            be number of the children of mNode.
  static nsresult GetFlatTextLengthInRange(const NodePosition& aStartPosition,
                                           const NodePosition& aEndPosition,
                                           nsIContent* aRootContent,
                                           uint32_t* aLength,
                                           LineBreakType aLineBreakType,
                                           bool aIsRemovingNode = false);
  // Computes the native text length between aStartOffset and aEndOffset of
  // aContent.  aContent must be a text node.
  static uint32_t GetNativeTextLength(nsIContent* aContent,
                                      uint32_t aStartOffset,
                                      uint32_t aEndOffset);
  // Get the native text length of aContent.  aContent must be a text node.
  static uint32_t GetNativeTextLength(nsIContent* aContent,
                                      uint32_t aMaxLength = UINT32_MAX);
  // Get the native text length which is inserted before aContent.
  // aContent should be an element.
  static uint32_t GetNativeTextLengthBefore(nsIContent* aContent,
                                            nsINode* aRootNode);

protected:
  // Get the text length of aContent.  aContent must be a text node.
  static uint32_t GetTextLength(nsIContent* aContent,
                                LineBreakType aLineBreakType,
                                uint32_t aMaxLength = UINT32_MAX);
  // Get the text length of a given range of a content node in
  // the given line break type.
  static uint32_t GetTextLengthInRange(nsIContent* aContent,
                                       uint32_t aXPStartOffset,
                                       uint32_t aXPEndOffset,
                                       LineBreakType aLineBreakType);
  // Get the contents in aContent (meaning all children of aContent) as plain
  // text.  E.g., specifying mRootContent gets whole text in it.
  // Note that the result is not same as .textContent.  The result is
  // optimized for native IMEs.  For example, <br> element and some block
  // elements causes "\n" (or "\r\n"), see also ShouldBreakLineBefore().
  nsresult GenerateFlatTextContent(nsIContent* aContent,
                                   nsAFlatString& aString,
                                   LineBreakType aLineBreakType);
  // Get the contents of aRange as plain text.
  nsresult GenerateFlatTextContent(nsRange* aRange,
                                   nsAFlatString& aString,
                                   LineBreakType aLineBreakType);
  // Get offset of start of aRange.  Note that the result includes the length
  // of line breaker caused by the start of aContent because aRange never
  // includes the line breaker caused by its start node.
  nsresult GetStartOffset(nsRange* aRange,
                          uint32_t* aOffset,
                          LineBreakType aLineBreakType);
  // Check if we should insert a line break before aContent.
  // This should return false only when aContent is an html element which
  // is typically used in a paragraph like <em>.
  static bool ShouldBreakLineBefore(nsIContent* aContent,
                                    nsINode* aRootNode);
  // Get the line breaker length.
  static inline uint32_t GetBRLength(LineBreakType aLineBreakType);
  static LineBreakType GetLineBreakType(WidgetQueryContentEvent* aEvent);
  static LineBreakType GetLineBreakType(WidgetSelectionEvent* aEvent);
  static LineBreakType GetLineBreakType(bool aUseNativeLineBreak);
  // Returns focused content (including its descendant documents).
  nsIContent* GetFocusedContent();
  // Returns true if the content is a plugin host.
  bool IsPlugin(nsIContent* aContent);
  // QueryContentRect() sets the rect of aContent's frame(s) to aEvent.
  nsresult QueryContentRect(nsIContent* aContent,
                            WidgetQueryContentEvent* aEvent);
  // Make the DOM range from the offset of FlatText and the text length.
  // If aExpandToClusterBoundaries is true, the start offset and the end one are
  // expanded to nearest cluster boundaries.
  nsresult SetRangeFromFlatTextOffset(nsRange* aRange,
                                      uint32_t aOffset,
                                      uint32_t aLength,
                                      LineBreakType aLineBreakType,
                                      bool aExpandToClusterBoundaries,
                                      uint32_t* aNewOffset = nullptr,
                                      nsIContent** aLastTextNode = nullptr);
  // If the aRange isn't in text node but next to a text node, this method
  // modifies it in the text node.  Otherwise, not modified.
  nsresult AdjustCollapsedRangeMaybeIntoTextNode(nsRange* aCollapsedRange);
  // Find the first frame for the range and get the start offset in it.
  nsresult GetStartFrameAndOffset(const nsRange* aRange,
                                  nsIFrame*& aFrame,
                                  int32_t& aOffsetInFrame);
  // Convert the frame relative offset to be relative to the root frame of the
  // root presContext (but still measured in appUnits of aFrame's presContext).
  nsresult ConvertToRootRelativeOffset(nsIFrame* aFrame,
                                       nsRect& aRect);
  // Expand aXPOffset to the nearest offset in cluster boundary. aForward is
  // true, it is expanded to forward.
  nsresult ExpandToClusterBoundary(nsIContent* aContent, bool aForward,
                                   uint32_t* aXPOffset);

  typedef nsTArray<mozilla::FontRange> FontRangeArray;
  static void AppendFontRanges(FontRangeArray& aFontRanges,
                               nsIContent* aContent,
                               int32_t aBaseOffset,
                               int32_t aXPStartOffset,
                               int32_t aXPEndOffset,
                               LineBreakType aLineBreakType);
  nsresult GenerateFlatFontRanges(nsRange* aRange,
                                  FontRangeArray& aFontRanges,
                                  uint32_t& aLength,
                                  LineBreakType aLineBreakType);
  nsresult QueryTextRectByRange(nsRange* aRange,
                                LayoutDeviceIntRect& aRect,
                                WritingMode& aWritingMode);

  // Returns a node and position in the node for computing text rect.
  NodePosition GetNodePositionHavingFlatText(const NodePosition& aNodePosition);
  NodePosition GetNodePositionHavingFlatText(nsINode* aNode,
                                             int32_t aNodeOffset);

  struct MOZ_STACK_CLASS FrameAndNodeOffset final
  {
    // mFrame is safe since this can live in only stack class and
    // ContentEventHandler doesn't modify layout after
    // ContentEventHandler::Init() flushes pending layout.  In other words,
    // this struct shouldn't be used before calling
    // ContentEventHandler::Init().
    nsIFrame* mFrame;
    // offset in the node of mFrame
    int32_t mOffsetInNode;

    FrameAndNodeOffset()
      : mFrame(nullptr)
      , mOffsetInNode(-1)
    {
    }

    FrameAndNodeOffset(nsIFrame* aFrame, int32_t aStartOffsetInNode)
      : mFrame(aFrame)
      , mOffsetInNode(aStartOffsetInNode)
    {
    }

    nsIFrame* operator->() { return mFrame; }
    const nsIFrame* operator->() const { return mFrame; }
    operator nsIFrame*() { return mFrame; }
    operator const nsIFrame*() const { return mFrame; }
    bool IsValid() const { return mFrame && mOffsetInNode >= 0; }
  };
  // Get first frame after the start of the given range for computing text rect.
  // This returns invalid FrameAndNodeOffset if there is no content which
  // should affect to computing text rect in the range.  mOffsetInNode is start
  // offset in the frame.
  FrameAndNodeOffset GetFirstFrameInRangeForTextRect(nsRange* aRange);

  // Get last frame before the end of the given range for computing text rect.
  // This returns invalid FrameAndNodeOffset if there is no content which
  // should affect to computing text rect in the range.  mOffsetInNode is end
  // offset in the frame.
  FrameAndNodeOffset GetLastFrameInRangeForTextRect(nsRange* aRange);

  struct MOZ_STACK_CLASS FrameRelativeRect final
  {
    // mRect is relative to the mBaseFrame's position.
    nsRect mRect;
    nsIFrame* mBaseFrame;

    FrameRelativeRect()
      : mBaseFrame(nullptr)
    {
    }

    explicit FrameRelativeRect(nsIFrame* aBaseFrame)
      : mBaseFrame(aBaseFrame)
    {
    }

    FrameRelativeRect(const nsRect& aRect, nsIFrame* aBaseFrame)
      : mRect(aRect)
      , mBaseFrame(aBaseFrame)
    {
    }

    bool IsValid() const { return mBaseFrame != nullptr; }

    // Returns an nsRect relative to aBaseFrame instead of mBaseFrame.
    nsRect RectRelativeTo(nsIFrame* aBaseFrame) const;
  };

  // Returns a rect for line breaker before the node of aFrame (If aFrame is
  // a <br> frame or a block level frame, it causes a line break at its
  // element's open tag, see also ShouldBreakLineBefore()).  Note that this
  // doesn't check if aFrame should cause line break in non-debug build.
  FrameRelativeRect GetLineBreakerRectBefore(nsIFrame* aFrame);

  // Returns a line breaker rect after aTextContent as there is a line breaker
  // immediately after aTextContent.  This is useful when following block
  // element causes a line break before it and it needs to compute the line
  // breaker's rect.  For example, if there is |<p>abc</p><p>def</p>|, the
  // rect of 2nd <p>'s line breaker should be at right of "c" in the first
  // <p>, not the start of 2nd <p>.  The result is relative to the last text
  // frame which represents the last character of aTextContent.
  FrameRelativeRect GuessLineBreakerRectAfter(nsIContent* aTextContent);

  // Returns a guessed first rect.  I.e., it may be different from actual
  // caret when selection is collapsed at start of aFrame.  For example, this
  // guess the caret rect only with the content box of aFrame and its font
  // height like:
  // +-aFrame----------------- (border box)
  // |
  // |  +--------------------- (content box)
  // |  | I
  //      ^ guessed caret rect
  // However, actual caret is computed with more information like line-height,
  // child frames of aFrame etc.  But this does not emulate actual caret
  // behavior exactly for simpler and faster code because it's difficult and
  // we're not sure it's worthwhile to do it with complicated implementation.
  FrameRelativeRect GuessFirstCaretRectIn(nsIFrame* aFrame);

  // Make aRect non-empty.  If width and/or height is 0, these methods set them
  // to 1.  Note that it doesn't set nsRect's width nor height to one device
  // pixel because using nsRect::ToOutsidePixels() makes actual width or height
  // to 2 pixels because x and y may not be aligned to device pixels.
  void EnsureNonEmptyRect(nsRect& aRect) const;
  void EnsureNonEmptyRect(LayoutDeviceIntRect& aRect) const;
};

} // namespace mozilla

#endif // mozilla_ContentEventHandler_h_
