/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/IntegerRange.h"

#include "nsAutoPtr.h"
#include "nsBidiPresUtils.h"
#include "nsFontMetrics.h"
#include "nsGkAtoms.h"
#include "nsPresContext.h"
#include "nsRenderingContext.h"
#include "nsBidiUtils.h"
#include "nsCSSFrameConstructor.h"
#include "nsContainerFrame.h"
#include "nsInlineFrame.h"
#include "nsPlaceholderFrame.h"
#include "nsFirstLetterFrame.h"
#include "nsUnicodeProperties.h"
#include "nsTextFrame.h"
#include "nsBlockFrame.h"
#include "nsIFrameInlines.h"
#include "nsStyleStructInlines.h"
#include "RubyUtils.h"
#include "nsRubyFrame.h"
#include "nsRubyBaseFrame.h"
#include "nsRubyTextFrame.h"
#include "nsRubyBaseContainerFrame.h"
#include "nsRubyTextContainerFrame.h"
#include <algorithm>

#undef NOISY_BIDI
#undef REALLY_NOISY_BIDI

using namespace mozilla;

static const char16_t kSpace            = 0x0020;
static const char16_t kZWSP             = 0x200B;
static const char16_t kLineSeparator    = 0x2028;
static const char16_t kObjectSubstitute = 0xFFFC;
static const char16_t kLRE              = 0x202A;
static const char16_t kRLE              = 0x202B;
static const char16_t kLRO              = 0x202D;
static const char16_t kRLO              = 0x202E;
static const char16_t kPDF              = 0x202C;
static const char16_t kLRI              = 0x2066;
static const char16_t kRLI              = 0x2067;
static const char16_t kFSI              = 0x2068;
static const char16_t kPDI              = 0x2069;
static const char16_t kSeparators[] = {
  // All characters with Bidi type Segment Separator or Block Separator
  char16_t('\t'),
  char16_t('\r'),
  char16_t('\n'),
  char16_t(0xb),
  char16_t(0x1c),
  char16_t(0x1d),
  char16_t(0x1e),
  char16_t(0x1f),
  char16_t(0x85),
  char16_t(0x2029),
  char16_t(0)
};

#define NS_BIDI_CONTROL_FRAME ((nsIFrame*)0xfffb1d1)

static bool
IsIsolateControl(char16_t aChar)
{
  return aChar == kLRI || aChar == kRLI || aChar == kFSI;
}

// Given a style context, return any bidi control character necessary to
// implement style properties that override directionality (i.e. if it has
// unicode-bidi:bidi-override, or text-orientation:upright in vertical
// writing mode) when applying the bidi algorithm.
//
// Returns 0 if no override control character is implied by this style.
static char16_t
GetBidiOverride(nsStyleContext* aStyleContext)
{
  const nsStyleVisibility* vis = aStyleContext->StyleVisibility();
  if ((vis->mWritingMode == NS_STYLE_WRITING_MODE_VERTICAL_RL ||
       vis->mWritingMode == NS_STYLE_WRITING_MODE_VERTICAL_LR) &&
      vis->mTextOrientation == NS_STYLE_TEXT_ORIENTATION_UPRIGHT) {
    return kLRO;
  }
  const nsStyleTextReset* text = aStyleContext->StyleTextReset();
  if (text->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_BIDI_OVERRIDE) {
    return NS_STYLE_DIRECTION_RTL == vis->mDirection ? kRLO : kLRO;
  }
  return 0;
}

// Given a style context, return any bidi control character necessary to
// implement style properties that affect bidi resolution (i.e. if it
// has unicode-bidiembed, isolate, or plaintext) when applying the bidi
// algorithm.
//
// Returns 0 if no control character is implied by the style.
//
// Note that GetBidiOverride and GetBidiControl need to be separate
// because in the case of unicode-bidi:isolate-override we need both
// FSI and LRO/RLO.
static char16_t
GetBidiControl(nsStyleContext* aStyleContext)
{
  const nsStyleVisibility* vis = aStyleContext->StyleVisibility();
  const nsStyleTextReset* text = aStyleContext->StyleTextReset();
  if (text->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_EMBED) {
    return NS_STYLE_DIRECTION_RTL == vis->mDirection ? kRLE : kLRE;
  }
  if (text->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_ISOLATE) {
    if (text->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_BIDI_OVERRIDE) {
      // isolate-override
      return kFSI;
    }
    // <bdi> element already has its directionality set from content so
    // we never need to return kFSI.
    return NS_STYLE_DIRECTION_RTL == vis->mDirection ? kRLI : kLRI;
  }
  if (text->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_PLAINTEXT) {
    return kFSI;
  }
  return 0;
}

struct BidiParagraphData {
  nsString            mBuffer;
  AutoTArray<char16_t, 16> mEmbeddingStack;
  nsTArray<nsIFrame*> mLogicalFrames;
  nsTArray<nsLineBox*> mLinePerFrame;
  nsDataHashtable<nsISupportsHashKey, int32_t> mContentToFrameIndex;
  // Cached presentation context for the frames we're processing.
  nsPresContext*      mPresContext;
  bool                mIsVisual;
  nsBidiLevel         mParaLevel;
  nsIContent*         mPrevContent;
  nsAutoPtr<nsBidi>   mBidiEngine;
  nsIFrame*           mPrevFrame;
#ifdef DEBUG
  // Only used for NOISY debug output.
  nsBlockFrame*       mCurrentBlock;
#endif

  void Init(nsBlockFrame* aBlockFrame)
  {
    mBidiEngine = new nsBidi();
    mPrevContent = nullptr;
#ifdef DEBUG
    mCurrentBlock = aBlockFrame;
#endif

    mParaLevel = nsBidiPresUtils::BidiLevelFromStyle(aBlockFrame->StyleContext());

    mPresContext = aBlockFrame->PresContext();
    mIsVisual = mPresContext->IsVisualMode();
    if (mIsVisual) {
      /**
       * Drill up in content to detect whether this is an element that needs to
       * be rendered with logical order even on visual pages.
       *
       * We always use logical order on form controls, firstly so that text
       * entry will be in logical order, but also because visual pages were
       * written with the assumption that even if the browser had no support
       * for right-to-left text rendering, it would use native widgets with
       * bidi support to display form controls.
       *
       * We also use logical order in XUL elements, since we expect that if a
       * XUL element appears in a visual page, it will be generated by an XBL
       * binding and contain localized text which will be in logical order.
       */
      for (nsIContent* content = aBlockFrame->GetContent() ; content; 
           content = content->GetParent()) {
        if (content->IsNodeOfType(nsINode::eHTML_FORM_CONTROL) ||
            content->IsXULElement()) {
          mIsVisual = false;
          break;
        }
      }
    }
  }

  nsresult SetPara()
  {
    return mBidiEngine->SetPara(mBuffer.get(), BufferLength(),
                                mParaLevel);
  }

  /**
   * mParaLevel can be NSBIDI_DEFAULT_LTR as well as NSBIDI_LTR or NSBIDI_RTL.
   * GetParaLevel() returns the actual (resolved) paragraph level which is
   * always either NSBIDI_LTR or NSBIDI_RTL
   */
  nsBidiLevel GetParaLevel()
  {
    nsBidiLevel paraLevel = mParaLevel;
    if (paraLevel == NSBIDI_DEFAULT_LTR || paraLevel == NSBIDI_DEFAULT_RTL) {
      mBidiEngine->GetParaLevel(&paraLevel);
    }
    return paraLevel;
  }

  nsBidiDirection GetDirection()
  {
    nsBidiDirection dir;
    mBidiEngine->GetDirection(&dir);
    return dir;
  }

  nsresult CountRuns(int32_t *runCount){ return mBidiEngine->CountRuns(runCount); }

  nsresult GetLogicalRun(int32_t aLogicalStart, 
                         int32_t* aLogicalLimit,
                         nsBidiLevel* aLevel)
  {
    nsresult rv = mBidiEngine->GetLogicalRun(aLogicalStart,
                                             aLogicalLimit, aLevel);
    if (mIsVisual || NS_FAILED(rv))
      *aLevel = GetParaLevel();
    return rv;
  }

  void ResetData()
  {
    mLogicalFrames.Clear();
    mLinePerFrame.Clear();
    mContentToFrameIndex.Clear();
    mBuffer.SetLength(0);
    mPrevContent = nullptr;
    for (uint32_t i = 0; i < mEmbeddingStack.Length(); ++i) {
      mBuffer.Append(mEmbeddingStack[i]);
      mLogicalFrames.AppendElement(NS_BIDI_CONTROL_FRAME);
      mLinePerFrame.AppendElement((nsLineBox*)nullptr);
    }
  }

  void AppendFrame(nsIFrame* aFrame,
                   nsBlockInFlowLineIterator* aLineIter,
                   nsIContent* aContent = nullptr)
  {
    if (aContent) {
      mContentToFrameIndex.Put(aContent, FrameCount());
    }
    mLogicalFrames.AppendElement(aFrame);

    AdvanceLineIteratorToFrame(aFrame, aLineIter, mPrevFrame);
    mLinePerFrame.AppendElement(aLineIter->GetLine().get());
  }

  void AdvanceAndAppendFrame(nsIFrame** aFrame,
                             nsBlockInFlowLineIterator* aLineIter,
                             nsIFrame** aNextSibling)
  {
    nsIFrame* frame = *aFrame;
    nsIFrame* nextSibling = *aNextSibling;

    frame = frame->GetNextContinuation();
    if (frame) {
      AppendFrame(frame, aLineIter, nullptr);

      /*
       * If we have already overshot the saved next-sibling while
       * scanning the frame's continuations, advance it.
       */
      if (frame == nextSibling) {
        nextSibling = frame->GetNextSibling();
      }
    }

    *aFrame = frame;
    *aNextSibling = nextSibling;
  }

  int32_t GetLastFrameForContent(nsIContent *aContent)
  {
    int32_t index = 0;
    mContentToFrameIndex.Get(aContent, &index);
    return index;
  }

  int32_t FrameCount(){ return mLogicalFrames.Length(); }

  int32_t BufferLength(){ return mBuffer.Length(); }

  nsIFrame* FrameAt(int32_t aIndex){ return mLogicalFrames[aIndex]; }

  nsLineBox* GetLineForFrameAt(int32_t aIndex){ return mLinePerFrame[aIndex]; }

  void AppendUnichar(char16_t aCh){ mBuffer.Append(aCh); }

  void AppendString(const nsDependentSubstring& aString){ mBuffer.Append(aString); }

  void AppendControlChar(char16_t aCh)
  {
    mLogicalFrames.AppendElement(NS_BIDI_CONTROL_FRAME);
    mLinePerFrame.AppendElement((nsLineBox*)nullptr);
    AppendUnichar(aCh);
  }

  void PushBidiControl(char16_t aCh)
  {
    AppendControlChar(aCh);
    mEmbeddingStack.AppendElement(aCh);
  }

  void AppendPopChar(char16_t aCh)
  {
    AppendControlChar(IsIsolateControl(aCh) ? kPDI : kPDF);
  }

  void PopBidiControl(char16_t aCh)
  {
    MOZ_ASSERT(mEmbeddingStack.Length(), "embedding/override underflow");
    MOZ_ASSERT(aCh == mEmbeddingStack.LastElement());
    AppendPopChar(aCh);
    mEmbeddingStack.TruncateLength(mEmbeddingStack.Length() - 1);
  }

  void ClearBidiControls()
  {
    for (char16_t c : Reversed(mEmbeddingStack)) {
      AppendPopChar(c);
    }
  }

  static bool
  IsFrameInCurrentLine(nsBlockInFlowLineIterator* aLineIter,
                       nsIFrame* aPrevFrame, nsIFrame* aFrame)
  {
    nsIFrame* endFrame = aLineIter->IsLastLineInList() ? nullptr :
      aLineIter->GetLine().next()->mFirstChild;
    nsIFrame* startFrame = aPrevFrame ? aPrevFrame : aLineIter->GetLine()->mFirstChild;
    for (nsIFrame* frame = startFrame; frame && frame != endFrame;
         frame = frame->GetNextSibling()) {
      if (frame == aFrame)
        return true;
    }
    return false;
  }

  static void
  AdvanceLineIteratorToFrame(nsIFrame* aFrame,
                             nsBlockInFlowLineIterator* aLineIter,
                             nsIFrame*& aPrevFrame)
  {
    // Advance aLine to the line containing aFrame
    nsIFrame* child = aFrame;
    nsIFrame* parent = nsLayoutUtils::GetParentOrPlaceholderFor(child);
    while (parent && !nsLayoutUtils::GetAsBlock(parent)) {
      child = parent;
      parent = nsLayoutUtils::GetParentOrPlaceholderFor(child);
    }
    NS_ASSERTION (parent, "aFrame is not a descendent of a block frame");
    while (!IsFrameInCurrentLine(aLineIter, aPrevFrame, child)) {
#ifdef DEBUG
      bool hasNext =
#endif
        aLineIter->Next();
      NS_ASSERTION(hasNext, "Can't find frame in lines!");
      aPrevFrame = nullptr;
    }
    aPrevFrame = child;
  }

};

struct BidiLineData {
  nsTArray<nsIFrame*> mLogicalFrames;
  nsTArray<nsIFrame*> mVisualFrames;
  nsTArray<int32_t> mIndexMap;
  AutoTArray<uint8_t, 18> mLevels;
  bool mIsReordered;

  BidiLineData(nsIFrame* aFirstFrameOnLine, int32_t   aNumFramesOnLine)
  {
    /**
     * Initialize the logically-ordered array of frames using the top-level
     * frames of a single line
     */
    mLogicalFrames.Clear();

    bool isReordered = false;
    bool hasRTLFrames = false;
    bool hasVirtualControls = false;

    auto appendFrame = [&](nsIFrame* frame, nsBidiLevel level) {
      mLogicalFrames.AppendElement(frame);
      mLevels.AppendElement(level);
      mIndexMap.AppendElement(0);
      if (IS_LEVEL_RTL(level)) {
        hasRTLFrames = true;
      }
    };

    bool firstFrame = true;
    for (nsIFrame* frame = aFirstFrameOnLine;
         frame && aNumFramesOnLine--;
         frame = frame->GetNextSibling()) {
      FrameBidiData bidiData = nsBidiPresUtils::GetFrameBidiData(frame);
      // Ignore virtual control before the first frame. Doing so should
      // not affect the visual result, but could avoid running into the
      // stripping code below for many cases.
      if (!firstFrame && bidiData.precedingControl != kBidiLevelNone) {
        appendFrame(NS_BIDI_CONTROL_FRAME, bidiData.precedingControl);
        hasVirtualControls = true;
      }
      appendFrame(frame, bidiData.embeddingLevel);
      firstFrame = false;
    }

    // Reorder the line
    nsBidi::ReorderVisual(mLevels.Elements(), FrameCount(),
                          mIndexMap.Elements());

    // Strip virtual frames
    if (hasVirtualControls) {
      auto originalCount = mLogicalFrames.Length();
      nsTArray<int32_t> realFrameMap(originalCount);
      size_t count = 0;
      for (auto i : MakeRange(originalCount)) {
        if (mLogicalFrames[i] == NS_BIDI_CONTROL_FRAME) {
          realFrameMap.AppendElement(-1);
        } else {
          mLogicalFrames[count] = mLogicalFrames[i];
          mLevels[count] = mLevels[i];
          realFrameMap.AppendElement(count);
          count++;
        }
      }
      // Only keep index map for real frames.
      for (size_t i = 0, j = 0; i < originalCount; ++i) {
        auto newIndex = realFrameMap[mIndexMap[i]];
        if (newIndex != -1) {
          mIndexMap[j] = newIndex;
          j++;
        }
      }
      mLogicalFrames.TruncateLength(count);
      mLevels.TruncateLength(count);
      mIndexMap.TruncateLength(count);
    }

    for (int32_t i = 0; i < FrameCount(); i++) {
      mVisualFrames.AppendElement(LogicalFrameAt(mIndexMap[i]));
      if (i != mIndexMap[i]) {
        isReordered = true;
      }
    }

    // If there's an RTL frame, assume the line is reordered
    mIsReordered = isReordered || hasRTLFrames;
  }

  int32_t FrameCount(){ return mLogicalFrames.Length(); }

  nsIFrame* LogicalFrameAt(int32_t aIndex){ return mLogicalFrames[aIndex]; }

  nsIFrame* VisualFrameAt(int32_t aIndex){ return mVisualFrames[aIndex]; }
};

#ifdef DEBUG
extern "C" {
void MOZ_EXPORT
DumpFrameArray(const nsTArray<nsIFrame*>& aFrames)
{
  for (nsIFrame* frame : aFrames) {
    if (frame == NS_BIDI_CONTROL_FRAME) {
      fprintf_stderr(stderr, "(Bidi control frame)\n");
    } else {
      frame->List();
    }
  }
}

void MOZ_EXPORT
DumpBidiLine(BidiLineData* aData, bool aVisualOrder)
{
  DumpFrameArray(aVisualOrder ? aData->mVisualFrames : aData->mLogicalFrames);
}
}
#endif

/* Some helper methods for Resolve() */

// Should this frame be split between text runs?
static bool
IsBidiSplittable(nsIFrame* aFrame)
{
  // Bidi inline containers should be split, unless they're line frames.
  nsIAtom* frameType = aFrame->GetType();
  return (aFrame->IsFrameOfType(nsIFrame::eBidiInlineContainer) &&
          frameType != nsGkAtoms::lineFrame) ||
         frameType == nsGkAtoms::textFrame;
}

// Should this frame be treated as a leaf (e.g. when building mLogicalFrames)?
static bool
IsBidiLeaf(nsIFrame* aFrame)
{
  nsIFrame* kid = aFrame->PrincipalChildList().FirstChild();
  return !kid || !aFrame->IsFrameOfType(nsIFrame::eBidiInlineContainer);
}

/**
 * Create non-fluid continuations for the ancestors of a given frame all the way
 * up the frame tree until we hit a non-splittable frame (a line or a block).
 *
 * @param aParent the first parent frame to be split
 * @param aFrame the child frames after this frame are reparented to the
 *        newly-created continuation of aParent.
 *        If aFrame is null, all the children of aParent are reparented.
 */
static nsresult
SplitInlineAncestors(nsContainerFrame* aParent,
                     nsIFrame* aFrame)
{
  nsPresContext* presContext = aParent->PresContext();
  nsIPresShell* presShell = presContext->PresShell();
  nsIFrame* frame = aFrame;
  nsContainerFrame* parent = aParent;
  nsContainerFrame* newParent;

  while (IsBidiSplittable(parent)) {
    nsContainerFrame* grandparent = parent->GetParent();
    NS_ASSERTION(grandparent, "Couldn't get parent's parent in nsBidiPresUtils::SplitInlineAncestors");
    
    // Split the child list after |frame|, unless it is the last child.
    if (!frame || frame->GetNextSibling()) {
    
      newParent = static_cast<nsContainerFrame*>(presShell->FrameConstructor()->
        CreateContinuingFrame(presContext, parent, grandparent, false));

      nsFrameList tail = parent->StealFramesAfter(frame);

      // Reparent views as necessary
      nsresult rv;
      rv = nsContainerFrame::ReparentFrameViewList(tail, parent, newParent);
      if (NS_FAILED(rv)) {
        return rv;
      }

      // The parent's continuation adopts the siblings after the split.
      newParent->InsertFrames(nsIFrame::kNoReflowPrincipalList, nullptr, tail);
    
      // The list name kNoReflowPrincipalList would indicate we don't want reflow
      nsFrameList temp(newParent, newParent);
      grandparent->InsertFrames(nsIFrame::kNoReflowPrincipalList, parent, temp);
    }
    
    frame = parent;
    parent = grandparent;
  }
  
  return NS_OK;
}

static void
MakeContinuationFluid(nsIFrame* aFrame, nsIFrame* aNext)
{
  NS_ASSERTION (!aFrame->GetNextInFlow() || aFrame->GetNextInFlow() == aNext, 
                "next-in-flow is not next continuation!");
  aFrame->SetNextInFlow(aNext);

  NS_ASSERTION (!aNext->GetPrevInFlow() || aNext->GetPrevInFlow() == aFrame,
                "prev-in-flow is not prev continuation!");
  aNext->SetPrevInFlow(aFrame);
}

static void
MakeContinuationsNonFluidUpParentChain(nsIFrame* aFrame, nsIFrame* aNext)
{
  nsIFrame* frame;
  nsIFrame* next;

  for (frame = aFrame, next = aNext;
       frame && next &&
         next != frame && next == frame->GetNextInFlow() &&
         IsBidiSplittable(frame);
       frame = frame->GetParent(), next = next->GetParent()) {

    frame->SetNextContinuation(next);
    next->SetPrevContinuation(frame);
  }
}

// If aFrame is the last child of its parent, convert bidi continuations to
// fluid continuations for all of its inline ancestors.
// If it isn't the last child, make sure that its continuation is fluid.
static void
JoinInlineAncestors(nsIFrame* aFrame)
{
  nsIFrame* frame = aFrame;
  do {
    nsIFrame* next = frame->GetNextContinuation();
    if (next) {
      MakeContinuationFluid(frame, next);
    }
    // Join the parent only as long as we're its last child.
    if (frame->GetNextSibling())
      break;
    frame = frame->GetParent();
  } while (frame && IsBidiSplittable(frame));
}

static nsresult
CreateContinuation(nsIFrame*  aFrame,
                   nsIFrame** aNewFrame,
                   bool       aIsFluid)
{
  NS_PRECONDITION(aNewFrame, "null OUT ptr");
  NS_PRECONDITION(aFrame, "null ptr");

  *aNewFrame = nullptr;

  nsPresContext *presContext = aFrame->PresContext();
  nsIPresShell *presShell = presContext->PresShell();
  NS_ASSERTION(presShell, "PresShell must be set on PresContext before calling nsBidiPresUtils::CreateContinuation");

  nsContainerFrame* parent = aFrame->GetParent();
  NS_ASSERTION(parent, "Couldn't get frame parent in nsBidiPresUtils::CreateContinuation");

  nsresult rv = NS_OK;
  
  // Have to special case floating first letter frames because the continuation
  // doesn't go in the first letter frame. The continuation goes with the rest
  // of the text that the first letter frame was made out of.
  if (parent->GetType() == nsGkAtoms::letterFrame &&
      parent->IsFloating()) {
    nsFirstLetterFrame* letterFrame = do_QueryFrame(parent);
    rv = letterFrame->CreateContinuationForFloatingParent(presContext, aFrame,
                                                          aNewFrame, aIsFluid);
    return rv;
  }

  *aNewFrame = presShell->FrameConstructor()->
    CreateContinuingFrame(presContext, aFrame, parent, aIsFluid);

  // The list name kNoReflowPrincipalList would indicate we don't want reflow
  // XXXbz this needs higher-level framelist love
  nsFrameList temp(*aNewFrame, *aNewFrame);
  parent->InsertFrames(nsIFrame::kNoReflowPrincipalList, aFrame, temp);

  if (!aIsFluid) {  
    // Split inline ancestor frames
    rv = SplitInlineAncestors(parent, aFrame);
    if (NS_FAILED(rv)) {
      return rv;
    }
  }

  return NS_OK;
}

/*
 * Overview of the implementation of Resolve():
 *
 *  Walk through the descendants of aBlockFrame and build:
 *   * mLogicalFrames: an nsTArray of nsIFrame* pointers in logical order
 *   * mBuffer: an nsString containing a representation of
 *     the content of the frames.
 *     In the case of text frames, this is the actual text context of the
 *     frames, but some other elements are represented in a symbolic form which
 *     will make the Unicode Bidi Algorithm give the correct results.
 *     Bidi isolates, embeddings, and overrides set by CSS, <bdi>, or <bdo>
 *     elements are represented by the corresponding Unicode control characters.
 *     <br> elements are represented by U+2028 LINE SEPARATOR
 *     Other inline elements are represented by U+FFFC OBJECT REPLACEMENT
 *     CHARACTER
 *
 *  Then pass mBuffer to the Bidi engine for resolving of embedding levels
 *  by nsBidi::SetPara() and division into directional runs by
 *  nsBidi::CountRuns().
 *
 *  Finally, walk these runs in logical order using nsBidi::GetLogicalRun() and
 *  correlate them with the frames indexed in mLogicalFrames, setting the
 *  baseLevel and embeddingLevel properties according to the results returned
 *  by the Bidi engine.
 *
 *  The rendering layer requires each text frame to contain text in only one
 *  direction, so we may need to call EnsureBidiContinuation() to split frames.
 *  We may also need to call RemoveBidiContinuation() to convert frames created
 *  by EnsureBidiContinuation() in previous reflows into fluid continuations.
 */
nsresult
nsBidiPresUtils::Resolve(nsBlockFrame* aBlockFrame)
{
  BidiParagraphData bpd;
  bpd.Init(aBlockFrame);

  // Handle bidi-override being set on the block itself before calling
  // TraverseFrames.
  // No need to call GetBidiControl as well, because isolate and embed
  // values of unicode-bidi property are redundant on block elements.
  // unicode-bidi:plaintext on a block element is handled by block frame
  // via using nsIFrame::GetWritingMode(nsIFrame*).
  char16_t ch = GetBidiOverride(aBlockFrame->StyleContext());
  if (ch != 0) {
    bpd.PushBidiControl(ch);
  }
  for (nsBlockFrame* block = aBlockFrame; block;
       block = static_cast<nsBlockFrame*>(block->GetNextContinuation())) {
#ifdef DEBUG
    bpd.mCurrentBlock = block;
#endif
    block->RemoveStateBits(NS_BLOCK_NEEDS_BIDI_RESOLUTION);
    nsBlockInFlowLineIterator it(block, block->LinesBegin());
    bpd.mPrevFrame = nullptr;
    TraverseFrames(&it, block->PrincipalChildList().FirstChild(), &bpd);
    nsBlockFrame::FrameLines* overflowLines = block->GetOverflowLines();
    if (overflowLines) {
      nsBlockInFlowLineIterator it(block, overflowLines->mLines.begin(), true);
      bpd.mPrevFrame = nullptr;
      TraverseFrames(&it, overflowLines->mFrames.FirstChild(), &bpd);
    }
  }

  if (ch != 0) {
    bpd.PopBidiControl(ch);
  }

  return ResolveParagraph(&bpd);
}

nsresult
nsBidiPresUtils::ResolveParagraph(BidiParagraphData* aBpd)
{
  if (aBpd->BufferLength() < 1) {
    return NS_OK;
  }
  aBpd->mBuffer.ReplaceChar(kSeparators, kSpace);

  int32_t runCount;

  nsresult rv = aBpd->SetPara();
  NS_ENSURE_SUCCESS(rv, rv);

  nsBidiLevel embeddingLevel = aBpd->GetParaLevel();

  rv = aBpd->CountRuns(&runCount);
  NS_ENSURE_SUCCESS(rv, rv);

  int32_t     runLength      = 0;   // the length of the current run of text
  int32_t     logicalLimit   = 0;   // the end of the current run + 1
  int32_t     numRun         = -1;
  int32_t     fragmentLength = 0;   // the length of the current text frame
  int32_t     frameIndex     = -1;  // index to the frames in mLogicalFrames
  int32_t     frameCount     = aBpd->FrameCount();
  int32_t     contentOffset  = 0;   // offset of current frame in its content node
  bool        isTextFrame    = false;
  nsIFrame*   frame = nullptr;
  nsIContent* content = nullptr;
  int32_t     contentTextLength = 0;

  FramePropertyTable* propTable = aBpd->mPresContext->PropertyTable();
  nsLineBox* currentLine = nullptr;
  
#ifdef DEBUG
#ifdef NOISY_BIDI
  printf("Before Resolve(), mCurrentBlock=%p, mBuffer='%s', frameCount=%d, runCount=%d\n",
         (void*)aBpd->mCurrentBlock, NS_ConvertUTF16toUTF8(aBpd->mBuffer).get(), frameCount, runCount);
#ifdef REALLY_NOISY_BIDI
  printf(" block frame tree=:\n");
  aBpd->mCurrentBlock->List(stdout, 0);
#endif
#endif
#endif

  if (runCount == 1 && frameCount == 1 &&
      aBpd->GetDirection() == NSBIDI_LTR && aBpd->GetParaLevel() == 0) {
    // We have a single left-to-right frame in a left-to-right paragraph,
    // without bidi isolation from the surrounding text.
    // Make sure that the embedding level and base level frame properties aren't
    // set (because if they are this frame used to have some other direction,
    // so we can't do this optimization), and we're done.
    nsIFrame* frame = aBpd->FrameAt(0);
    if (frame != NS_BIDI_CONTROL_FRAME) {
      FrameBidiData bidiData = frame->GetBidiData();
      if (!bidiData.embeddingLevel && !bidiData.baseLevel) {
#ifdef DEBUG
#ifdef NOISY_BIDI
        printf("early return for single direction frame %p\n", (void*)frame);
#endif
#endif
        frame->AddStateBits(NS_FRAME_IS_BIDI);
        return NS_OK;
      }
    }
  }

  nsIFrame* lastRealFrame = nullptr;
  nsBidiLevel lastEmbedingLevel = kBidiLevelNone;
  nsBidiLevel precedingControl = kBidiLevelNone;

  auto storeBidiDataToFrame = [&]() {
    FrameBidiData bidiData;
    bidiData.embeddingLevel = embeddingLevel;
    bidiData.baseLevel = aBpd->GetParaLevel();
    // If a control character doesn't have a lower embedding level than
    // both the preceding and the following frame, it isn't something
    // needed for getting the correct result. This optimization should
    // remove almost all of embeds and overrides, and some of isolates.
    if (precedingControl >= embeddingLevel ||
        precedingControl >= lastEmbedingLevel) {
      bidiData.precedingControl = kBidiLevelNone;
    } else {
      bidiData.precedingControl = precedingControl;
    }
    precedingControl = kBidiLevelNone;
    lastEmbedingLevel = embeddingLevel;
    propTable->Set(frame, nsIFrame::BidiDataProperty(), bidiData);
  };

  for (; ;) {
    if (fragmentLength <= 0) {
      // Get the next frame from mLogicalFrames
      if (++frameIndex >= frameCount) {
        break;
      }
      frame = aBpd->FrameAt(frameIndex);
      if (frame == NS_BIDI_CONTROL_FRAME ||
          nsGkAtoms::textFrame != frame->GetType()) {
        /*
         * Any non-text frame corresponds to a single character in the text buffer
         * (a bidi control character, LINE SEPARATOR, or OBJECT SUBSTITUTE)
         */
        isTextFrame = false;
        fragmentLength = 1;
      } else {
        currentLine = aBpd->GetLineForFrameAt(frameIndex);
        content = frame->GetContent();
        if (!content) {
          rv = NS_OK;
          break;
        }
        contentTextLength = content->TextLength();
        if (contentTextLength == 0) {
          frame->AdjustOffsetsForBidi(0, 0);
          // Set the base level and embedding level of the current run even
          // on an empty frame. Otherwise frame reordering will not be correct.
          storeBidiDataToFrame();
          continue;
        }
        int32_t start, end;
        frame->GetOffsets(start, end);
        NS_ASSERTION(!(contentTextLength < end - start),
                     "Frame offsets don't fit in content");
        fragmentLength = std::min(contentTextLength, end - start);
        contentOffset = start;
        isTextFrame = true;
      }
    } // if (fragmentLength <= 0)

    if (runLength <= 0) {
      // Get the next run of text from the Bidi engine
      if (++numRun >= runCount) {
        break;
      }
      int32_t lineOffset = logicalLimit;
      if (NS_FAILED(aBpd->GetLogicalRun(
              lineOffset, &logicalLimit, &embeddingLevel) ) ) {
        break;
      }
      runLength = logicalLimit - lineOffset;
    } // if (runLength <= 0)

    if (frame == NS_BIDI_CONTROL_FRAME) {
      // In theory, we only need to do this for isolates. However, it is
      // easier to do this for all here because we do not maintain the
      // index to get corresponding character from buffer. Since we do
      // have proper embedding level for all those characters, including
      // them wouldn't affect the final result.
      precedingControl = std::min(precedingControl, embeddingLevel);
    }
    else {
      storeBidiDataToFrame();
      if (isTextFrame) {
        if ( (runLength > 0) && (runLength < fragmentLength) ) {
          /*
           * The text in this frame continues beyond the end of this directional run.
           * Create a non-fluid continuation frame for the next directional run.
           */
          currentLine->MarkDirty();
          nsIFrame* nextBidi;
          int32_t runEnd = contentOffset + runLength;
          rv = EnsureBidiContinuation(frame, &nextBidi, contentOffset, runEnd);
          if (NS_FAILED(rv)) {
            break;
          }
          nextBidi->AdjustOffsetsForBidi(runEnd,
                                         contentOffset + fragmentLength);
          frame = nextBidi;
          contentOffset = runEnd;
        } // if (runLength < fragmentLength)
        else {
          if (contentOffset + fragmentLength == contentTextLength) {
            /* 
             * We have finished all the text in this content node. Convert any
             * further non-fluid continuations to fluid continuations and advance
             * frameIndex to the last frame in the content node
             */
            int32_t newIndex = aBpd->GetLastFrameForContent(content);
            if (newIndex > frameIndex) {
              currentLine->MarkDirty();
              RemoveBidiContinuation(aBpd, frame, frameIndex, newIndex);
              frameIndex = newIndex;
              frame = aBpd->FrameAt(frameIndex);
            }
          } else if (fragmentLength > 0 && runLength > fragmentLength) {
            /*
             * There is more text that belongs to this directional run in the next
             * text frame: make sure it is a fluid continuation of the current frame.
             * Do not advance frameIndex, because the next frame may contain
             * multi-directional text and need to be split
             */
            int32_t newIndex = frameIndex;
            do {
            } while (++newIndex < frameCount &&
                     aBpd->FrameAt(newIndex) == NS_BIDI_CONTROL_FRAME);
            if (newIndex < frameCount) {
              currentLine->MarkDirty();
              RemoveBidiContinuation(aBpd, frame, frameIndex, newIndex);
            }
          } else if (runLength == fragmentLength) {
            /*
             * If the directional run ends at the end of the frame, make sure
             * that any continuation is non-fluid, and do the same up the
             * parent chain
             */
            nsIFrame* next = frame->GetNextInFlow();
            if (next) {
              currentLine->MarkDirty();
              MakeContinuationsNonFluidUpParentChain(frame, next);
            }
          }
          frame->AdjustOffsetsForBidi(contentOffset, contentOffset + fragmentLength);
        }
      } // isTextFrame
    } // not bidi control frame
    int32_t temp = runLength;
    runLength -= fragmentLength;
    fragmentLength -= temp;

    // Record last real frame so that we can do spliting properly even
    // if a run ends after a virtual bidi control frame.
    if (frame != NS_BIDI_CONTROL_FRAME) {
      lastRealFrame = frame;
    }
    if (lastRealFrame && fragmentLength <= 0) {
      // If the frame is at the end of a run, and this is not the end of our
      // paragrah, split all ancestor inlines that need splitting.
      // To determine whether we're at the end of the run, we check that we've
      // finished processing the current run, and that the current frame
      // doesn't have a fluid continuation (it could have a fluid continuation
      // of zero length, so testing runLength alone is not sufficient).
      if (runLength <= 0 && !lastRealFrame->GetNextInFlow()) {
        if (numRun + 1 < runCount) {
          nsIFrame* child = lastRealFrame;
          nsContainerFrame* parent = child->GetParent();
          // As long as we're on the last sibling, the parent doesn't have to
          // be split.
          // However, if the parent has a fluid continuation, we do have to make
          // it non-fluid. This can happen e.g. when we have a first-letter
          // frame and the end of the first-letter coincides with the end of a
          // directional run.
          while (parent &&
                 IsBidiSplittable(parent) &&
                 !child->GetNextSibling()) {
            nsIFrame* next = parent->GetNextInFlow();
            if (next) {
              parent->SetNextContinuation(next);
              next->SetPrevContinuation(parent);
            }
            child = parent;
            parent = child->GetParent();
          }
          if (parent && IsBidiSplittable(parent)) {
            SplitInlineAncestors(parent, child);
          }
        }
      } else if (frame != NS_BIDI_CONTROL_FRAME) {
        // We're not at an end of a run. If |frame| is the last child of its
        // parent, and its ancestors happen to have bidi continuations, convert
        // them into fluid continuations.
        JoinInlineAncestors(frame);
      }
    }
  } // for

#ifdef DEBUG
#ifdef REALLY_NOISY_BIDI
  printf("---\nAfter Resolve(), frameTree =:\n");
  aBpd->mCurrentBlock->List(stdout, 0);
  printf("===\n");
#endif
#endif

  return rv;
}

void
nsBidiPresUtils::TraverseFrames(nsBlockInFlowLineIterator* aLineIter,
                                nsIFrame*                  aCurrentFrame,
                                BidiParagraphData*         aBpd)
{
  if (!aCurrentFrame)
    return;

#ifdef DEBUG
  nsBlockFrame* initialLineContainer = aLineIter->GetContainer();
#endif

  nsIFrame* childFrame = aCurrentFrame;
  do {
    /*
     * It's important to get the next sibling and next continuation *before*
     * handling the frame: If we encounter a forced paragraph break and call
     * ResolveParagraph within this loop, doing GetNextSibling and
     * GetNextContinuation after that could return a bidi continuation that had
     * just been split from the original childFrame and we would process it
     * twice.
     */
    nsIFrame* nextSibling = childFrame->GetNextSibling();
    bool isLastFrame = !childFrame->GetNextContinuation();
    bool isFirstFrame = !childFrame->GetPrevContinuation();

    // If the real frame for a placeholder is a first letter frame, we need to
    // drill down into it and include its contents in Bidi resolution.
    // If not, we just use the placeholder.
    nsIFrame* frame = childFrame;
    if (nsGkAtoms::placeholderFrame == childFrame->GetType()) {
      nsIFrame* realFrame =
        nsPlaceholderFrame::GetRealFrameForPlaceholder(childFrame);
      if (realFrame->GetType() == nsGkAtoms::letterFrame) {
        frame = realFrame;
      }
    }

    char16_t controlChar = 0;
    char16_t overrideChar = 0;
    if (frame->IsFrameOfType(nsIFrame::eBidiInlineContainer)) {
      if (!(frame->GetStateBits() & NS_FRAME_FIRST_REFLOW)) {
        nsContainerFrame* c = static_cast<nsContainerFrame*>(frame);
        MOZ_ASSERT(c == do_QueryFrame(frame),
                   "eBidiInlineContainer must be a nsContainerFrame subclass");
        c->DrainSelfOverflowList();
      }

      controlChar = GetBidiControl(frame->StyleContext());
      overrideChar = GetBidiOverride(frame->StyleContext());

      // Add dummy frame pointers representing bidi control codes before
      // the first frames of elements specifying override, isolation, or
      // plaintext.
      if (isFirstFrame) {
        if (controlChar != 0) {
          aBpd->PushBidiControl(controlChar);
        }
        if (overrideChar != 0) {
          aBpd->PushBidiControl(overrideChar);
        }
      }
    }

    if (IsBidiLeaf(frame)) {
      /* Bidi leaf frame: add the frame to the mLogicalFrames array,
       * and add its index to the mContentToFrameIndex hashtable. This
       * will be used in RemoveBidiContinuation() to identify the last
       * frame in the array with a given content.
       */
      nsIContent* content = frame->GetContent();
      aBpd->AppendFrame(frame, aLineIter, content);

      // Append the content of the frame to the paragraph buffer
      nsIAtom* frameType = frame->GetType();
      if (nsGkAtoms::textFrame == frameType) {
        if (content != aBpd->mPrevContent) {
          aBpd->mPrevContent = content;
          if (!frame->StyleText()->NewlineIsSignificant(
                static_cast<nsTextFrame*>(frame))) {
            content->AppendTextTo(aBpd->mBuffer);
          } else {
            /*
             * For preformatted text we have to do bidi resolution on each line
             * separately. 
             */
            nsAutoString text;
            content->AppendTextTo(text);
            nsIFrame* next;
            do {
              next = nullptr;

              int32_t start, end;
              frame->GetOffsets(start, end);
              int32_t endLine = text.FindChar('\n', start);
              if (endLine == -1) {
                /*
                 * If there is no newline in the text content, just save the
                 * text from this frame and its continuations, and do bidi
                 * resolution later
                 */
                aBpd->AppendString(Substring(text, start));
                while (frame && nextSibling) {
                  aBpd->AdvanceAndAppendFrame(&frame, aLineIter, &nextSibling);
                }
                break;
              }

              /*
               * If there is a newline in the frame, break the frame after the
               * newline, do bidi resolution and repeat until the last sibling
               */
              ++endLine;

              /*
               * If the frame ends before the new line, save the text and move
               * into the next continuation
               */
              aBpd->AppendString(Substring(text, start,
                                           std::min(end, endLine) - start));
              while (end < endLine && nextSibling) { 
                aBpd->AdvanceAndAppendFrame(&frame, aLineIter, &nextSibling);
                NS_ASSERTION(frame, "Premature end of continuation chain");
                frame->GetOffsets(start, end);
                aBpd->AppendString(Substring(text, start,
                                             std::min(end, endLine) - start));
              }

              if (end < endLine) {
                aBpd->mPrevContent = nullptr;
                break;
              }

              bool createdContinuation = false;
              if (uint32_t(endLine) < text.Length()) {
                /*
                 * Timing is everything here: if the frame already has a bidi
                 * continuation, we need to make the continuation fluid *before*
                 * resetting the length of the current frame. Otherwise
                 * nsTextFrame::SetLength won't set the continuation frame's
                 * text offsets correctly.
                 *
                 * On the other hand, if the frame doesn't have a continuation,
                 * we need to create one *after* resetting the length, or
                 * CreateContinuingFrame will complain that there is no more
                 * content for the continuation.               
                 */
                next = frame->GetNextInFlow();
                if (!next) {
                  // If the frame already has a bidi continuation, make it fluid
                  next = frame->GetNextContinuation();
                  if (next) {
                    MakeContinuationFluid(frame, next);
                    JoinInlineAncestors(frame);
                  }
                }

                nsTextFrame* textFrame = static_cast<nsTextFrame*>(frame);
                textFrame->SetLength(endLine - start, nullptr);

                if (!next) {
                  // If the frame has no next in flow, create one.
                  CreateContinuation(frame, &next, true);
                  createdContinuation = true;
                }
                // Mark the line before the newline as dirty.
                aBpd->GetLineForFrameAt(aBpd->FrameCount() - 1)->MarkDirty();
              }
              ResolveParagraphWithinBlock(aBpd);

              if (!nextSibling && !createdContinuation) {
                break;
              } else if (next) {
                frame = next;
                aBpd->AppendFrame(frame, aLineIter);
                // Mark the line after the newline as dirty.
                aBpd->GetLineForFrameAt(aBpd->FrameCount() - 1)->MarkDirty();
              }

              /*
               * If we have already overshot the saved next-sibling while
               * scanning the frame's continuations, advance it.
               */
              if (frame && frame == nextSibling) {
                nextSibling = frame->GetNextSibling();
              }

            } while (next);
          }
        }
      } else if (nsGkAtoms::brFrame == frameType) {
        // break frame -- append line separator
        aBpd->AppendUnichar(kLineSeparator);
        ResolveParagraphWithinBlock(aBpd);
      } else { 
        // other frame type -- see the Unicode Bidi Algorithm:
        // "...inline objects (such as graphics) are treated as if they are ...
        // U+FFFC"
        // <wbr>, however, is treated as U+200B ZERO WIDTH SPACE. See
        // http://dev.w3.org/html5/spec/Overview.html#phrasing-content-1
        aBpd->AppendUnichar(content->IsHTMLElement(nsGkAtoms::wbr) ?
                            kZWSP : kObjectSubstitute);
        if (!frame->IsInlineOutside()) {
          // if it is not inline, end the paragraph
          ResolveParagraphWithinBlock(aBpd);
        }
      }
    } else {
      // For a non-leaf frame, recurse into TraverseFrames
      nsIFrame* kid = frame->PrincipalChildList().FirstChild();
      MOZ_ASSERT(!frame->GetChildList(nsIFrame::kOverflowList).FirstChild(),
                 "should have drained the overflow list above");
      if (kid) {
        TraverseFrames(aLineIter, kid, aBpd);
      }
    }

    // If the element is attributed by dir, indicate direction pop (add PDF frame)
    if (isLastFrame) {
      // Add a dummy frame pointer representing a bidi control code after the
      // last frame of an element specifying embedding or override
      if (overrideChar != 0) {
        aBpd->PopBidiControl(overrideChar);
      }
      if (controlChar != 0) {
        aBpd->PopBidiControl(controlChar);
      }
    }
    childFrame = nextSibling;
  } while (childFrame);

  MOZ_ASSERT(initialLineContainer == aLineIter->GetContainer());
}

void
nsBidiPresUtils::ResolveParagraphWithinBlock(BidiParagraphData* aBpd)
{
  aBpd->ClearBidiControls();
  ResolveParagraph(aBpd);
  aBpd->ResetData();
}

/* static */ nscoord
nsBidiPresUtils::ReorderFrames(nsIFrame* aFirstFrameOnLine,
                               int32_t aNumFramesOnLine,
                               WritingMode aLineWM,
                               const nsSize& aContainerSize,
                               nscoord aStart)
{
  nsSize containerSize(aContainerSize);

  // If this line consists of a line frame, reorder the line frame's children.
  if (aFirstFrameOnLine->GetType() == nsGkAtoms::lineFrame) {
    // The line frame is positioned at the start-edge, so use its size
    // as the container size.
    containerSize = aFirstFrameOnLine->GetSize();

    aFirstFrameOnLine = aFirstFrameOnLine->PrincipalChildList().FirstChild();
    if (!aFirstFrameOnLine) {
      return 0;
    }
    // All children of the line frame are on the first line. Setting aNumFramesOnLine
    // to -1 makes InitLogicalArrayFromLine look at all of them.
    aNumFramesOnLine = -1;
  }

  BidiLineData bld(aFirstFrameOnLine, aNumFramesOnLine);
  return RepositionInlineFrames(&bld, aLineWM, containerSize, aStart);
}

nsIFrame*
nsBidiPresUtils::GetFirstLeaf(nsIFrame* aFrame)
{
  nsIFrame* firstLeaf = aFrame;
  while (!IsBidiLeaf(firstLeaf)) {
    nsIFrame* firstChild = firstLeaf->PrincipalChildList().FirstChild();
    nsIFrame* realFrame = nsPlaceholderFrame::GetRealFrameFor(firstChild);
    firstLeaf = (realFrame->GetType() == nsGkAtoms::letterFrame) ?
                 realFrame : firstChild;
  }
  return firstLeaf;
}

FrameBidiData
nsBidiPresUtils::GetFrameBidiData(nsIFrame* aFrame)
{
  return GetFirstLeaf(aFrame)->GetBidiData();
}

nsBidiLevel
nsBidiPresUtils::GetFrameEmbeddingLevel(nsIFrame* aFrame)
{
  return GetFirstLeaf(aFrame)->GetEmbeddingLevel();
}

nsBidiLevel
nsBidiPresUtils::GetFrameBaseLevel(nsIFrame* aFrame)
{
  nsIFrame* firstLeaf = aFrame;
  while (!IsBidiLeaf(firstLeaf)) {
    firstLeaf = firstLeaf->PrincipalChildList().FirstChild();
  }
  return firstLeaf->GetBaseLevel();
}

void
nsBidiPresUtils::IsFirstOrLast(nsIFrame* aFrame,
                               const nsContinuationStates* aContinuationStates,
                               bool aSpanDirMatchesLineDir,
                               bool& aIsFirst /* out */,
                               bool& aIsLast /* out */)
{
  /*
   * Since we lay out frames in the line's direction, visiting a frame with
   * 'mFirstVisualFrame == nullptr', means it's the first appearance of one
   * of its continuation chain frames on the line.
   * To determine if it's the last visual frame of its continuation chain on
   * the line or not, we count the number of frames of the chain on the line,
   * and then reduce it when we lay out a frame of the chain. If this value
   * becomes 1 it means that it's the last visual frame of its continuation
   * chain on this line.
   */

  bool firstInLineOrder, lastInLineOrder;
  nsFrameContinuationState* frameState = aContinuationStates->GetEntry(aFrame);
  nsFrameContinuationState* firstFrameState;

  if (!frameState->mFirstVisualFrame) {
    // aFrame is the first visual frame of its continuation chain
    nsFrameContinuationState* contState;
    nsIFrame* frame;

    frameState->mFrameCount = 1;
    frameState->mFirstVisualFrame = aFrame;

    /**
     * Traverse continuation chain of aFrame in both backward and forward
     * directions while the frames are on this line. Count the frames and
     * set their mFirstVisualFrame to aFrame.
     */
    // Traverse continuation chain backward
    for (frame = aFrame->GetPrevContinuation();
         frame && (contState = aContinuationStates->GetEntry(frame));
         frame = frame->GetPrevContinuation()) {
      frameState->mFrameCount++;
      contState->mFirstVisualFrame = aFrame;
    }
    frameState->mHasContOnPrevLines = (frame != nullptr);

    // Traverse continuation chain forward
    for (frame = aFrame->GetNextContinuation();
         frame && (contState = aContinuationStates->GetEntry(frame));
         frame = frame->GetNextContinuation()) {
      frameState->mFrameCount++;
      contState->mFirstVisualFrame = aFrame;
    }
    frameState->mHasContOnNextLines = (frame != nullptr);

    firstInLineOrder = true;
    firstFrameState = frameState;
  } else {
    // aFrame is not the first visual frame of its continuation chain
    firstInLineOrder = false;
    firstFrameState = aContinuationStates->GetEntry(frameState->mFirstVisualFrame);
  }

  lastInLineOrder = (firstFrameState->mFrameCount == 1);

  if (aSpanDirMatchesLineDir) {
    aIsFirst = firstInLineOrder;
    aIsLast = lastInLineOrder;
  } else {
    aIsFirst = lastInLineOrder;
    aIsLast = firstInLineOrder;
  }

  if (frameState->mHasContOnPrevLines) {
    aIsFirst = false;
  }
  if (firstFrameState->mHasContOnNextLines) {
    aIsLast = false;
  }

  if ((aIsFirst || aIsLast) &&
      (aFrame->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT)) {
    // For ib splits, don't treat anything except the last part as
    // endmost or anything except the first part as startmost.
    // As an optimization, only get the first continuation once.
    nsIFrame* firstContinuation = aFrame->FirstContinuation();
    if (firstContinuation->FrameIsNonLastInIBSplit()) {
      // We are not endmost
      aIsLast = false;
    }
    if (firstContinuation->FrameIsNonFirstInIBSplit()) {
      // We are not startmost
      aIsFirst = false;
    }
  }

  // Reduce number of remaining frames of the continuation chain on the line.
  firstFrameState->mFrameCount--;

  nsInlineFrame* testFrame = do_QueryFrame(aFrame);

  if (testFrame) {
    aFrame->AddStateBits(NS_INLINE_FRAME_BIDI_VISUAL_STATE_IS_SET);

    if (aIsFirst) {
      aFrame->AddStateBits(NS_INLINE_FRAME_BIDI_VISUAL_IS_FIRST);
    } else {
      aFrame->RemoveStateBits(NS_INLINE_FRAME_BIDI_VISUAL_IS_FIRST);
    }

    if (aIsLast) {
      aFrame->AddStateBits(NS_INLINE_FRAME_BIDI_VISUAL_IS_LAST);
    } else {
      aFrame->RemoveStateBits(NS_INLINE_FRAME_BIDI_VISUAL_IS_LAST);
    }
  }
}

/* static */ void
nsBidiPresUtils::RepositionRubyContentFrame(
  nsIFrame* aFrame, WritingMode aFrameWM, const LogicalMargin& aBorderPadding)
{
  const nsFrameList& childList = aFrame->PrincipalChildList();
  if (childList.IsEmpty()) {
    return;
  }

  // Reorder the children.
  // XXX It currently doesn't work properly because we do not
  // resolve frames inside ruby content frames.
  nscoord isize = ReorderFrames(childList.FirstChild(),
                                childList.GetLength(),
                                aFrameWM, aFrame->GetSize(),
                                aBorderPadding.IStart(aFrameWM));
  isize += aBorderPadding.IEnd(aFrameWM);

  if (aFrame->StyleText()->mRubyAlign == NS_STYLE_RUBY_ALIGN_START) {
    return;
  }
  nscoord residualISize = aFrame->ISize(aFrameWM) - isize;
  if (residualISize <= 0) {
    return;
  }

  // When ruby-align is not "start", if the content does not fill this
  // frame, we need to center the children.
  const nsSize dummyContainerSize;
  for (nsIFrame* child : childList) {
    LogicalRect rect = child->GetLogicalRect(aFrameWM, dummyContainerSize);
    rect.IStart(aFrameWM) += residualISize / 2;
    child->SetRect(aFrameWM, rect, dummyContainerSize);
  }
}

/* static */ nscoord
nsBidiPresUtils::RepositionRubyFrame(
  nsIFrame* aFrame,
  const nsContinuationStates* aContinuationStates,
  const WritingMode aContainerWM,
  const LogicalMargin& aBorderPadding)
{
  nsIAtom* frameType = aFrame->GetType();
  MOZ_ASSERT(RubyUtils::IsRubyBox(frameType));

  nscoord icoord = 0;
  WritingMode frameWM = aFrame->GetWritingMode();
  bool isLTR = frameWM.IsBidiLTR();
  nsSize frameSize = aFrame->GetSize();
  if (frameType == nsGkAtoms::rubyFrame) {
    icoord += aBorderPadding.IStart(frameWM);
    // Reposition ruby segments in a ruby container
    for (RubySegmentEnumerator e(static_cast<nsRubyFrame*>(aFrame));
          !e.AtEnd(); e.Next()) {
      nsRubyBaseContainerFrame* rbc = e.GetBaseContainer();
      AutoRubyTextContainerArray textContainers(rbc);

      nscoord segmentISize = RepositionFrame(rbc, isLTR, icoord,
                                             aContinuationStates,
                                             frameWM, false, frameSize);
      for (nsRubyTextContainerFrame* rtc : textContainers) {
        nscoord isize = RepositionFrame(rtc, isLTR, icoord, aContinuationStates,
                                        frameWM, false, frameSize);
        segmentISize = std::max(segmentISize, isize);
      }
      icoord += segmentISize;
    }
    icoord += aBorderPadding.IEnd(frameWM);
  } else if (frameType == nsGkAtoms::rubyBaseContainerFrame) {
    // Reposition ruby columns in a ruby segment
    auto rbc = static_cast<nsRubyBaseContainerFrame*>(aFrame);
    AutoRubyTextContainerArray textContainers(rbc);

    for (RubyColumnEnumerator e(rbc, textContainers); !e.AtEnd(); e.Next()) {
      RubyColumn column;
      e.GetColumn(column);

      nscoord columnISize = RepositionFrame(column.mBaseFrame, isLTR, icoord,
                                            aContinuationStates,
                                            frameWM, false, frameSize);
      for (nsRubyTextFrame* rt : column.mTextFrames) {
        nscoord isize = RepositionFrame(rt, isLTR, icoord, aContinuationStates,
                                        frameWM, false, frameSize);
        columnISize = std::max(columnISize, isize);
      }
      icoord += columnISize;
    }
  } else {
    if (frameType == nsGkAtoms::rubyBaseFrame ||
        frameType == nsGkAtoms::rubyTextFrame) {
      RepositionRubyContentFrame(aFrame, frameWM, aBorderPadding);
    }
    // Note that, ruby text container is not present in all conditions
    // above. It is intended, because the children of rtc are reordered
    // with the children of ruby base container simultaneously. We only
    // need to return its isize here, as it should not be changed.
    icoord += aFrame->ISize(aContainerWM);
  }
  return icoord;
}

/* static */ nscoord
nsBidiPresUtils::RepositionFrame(nsIFrame* aFrame,
                                 bool aIsEvenLevel,
                                 nscoord aStartOrEnd,
                                 const nsContinuationStates* aContinuationStates,
                                 WritingMode aContainerWM,
                                 bool aContainerReverseDir,
                                 const nsSize& aContainerSize)
{
  nscoord lineSize = aContainerWM.IsVertical() ?
    aContainerSize.height : aContainerSize.width;
  NS_ASSERTION(lineSize != NS_UNCONSTRAINEDSIZE,
               "Unconstrained inline line size in bidi frame reordering");
  if (!aFrame)
    return 0;

  bool isFirst, isLast;
  WritingMode frameWM = aFrame->GetWritingMode();
  IsFirstOrLast(aFrame,
                aContinuationStates,
                aContainerWM.IsBidiLTR() == frameWM.IsBidiLTR(),
                isFirst /* out */,
                isLast /* out */);

  // We only need the margin if the frame is first or last in its own
  // writing mode, but we're traversing the frames in the order of the
  // container's writing mode. To get the right values, we set start and
  // end margins on a logical margin in the frame's writing mode, and
  // then convert the margin to the container's writing mode to set the
  // coordinates.

  // This method is called from nsBlockFrame::PlaceLine via the call to
  // bidiUtils->ReorderFrames, so this is guaranteed to be after the inlines
  // have been reflowed, which is required for GetUsedMargin/Border/Padding
  nscoord frameISize = aFrame->ISize();
  LogicalMargin frameMargin = aFrame->GetLogicalUsedMargin(frameWM);
  LogicalMargin borderPadding = aFrame->GetLogicalUsedBorderAndPadding(frameWM);
  // Since the visual order of frame could be different from the continuation
  // order, we need to remove any inline border/padding [that is already applied
  // based on continuation order] and then add it back based on the visual order
  // (i.e. isFirst/isLast) to get the correct isize for the current frame.
  // We don't need to do that for 'box-decoration-break:clone' because then all
  // continuations have border/padding/margin applied.
  if (aFrame->StyleBorder()->mBoxDecorationBreak ==
        StyleBoxDecorationBreak::Slice) {
    // First remove the border/padding that was applied based on logical order.
    if (!aFrame->GetPrevContinuation()) {
      frameISize -= borderPadding.IStart(frameWM);
    }
    if (!aFrame->GetNextContinuation()) {
      frameISize -= borderPadding.IEnd(frameWM);
    }
    // Set margin/border/padding based on visual order.
    if (!isFirst) {
      frameMargin.IStart(frameWM) = 0;
      borderPadding.IStart(frameWM) = 0;
    }
    if (!isLast) {
      frameMargin.IEnd(frameWM) = 0;
      borderPadding.IEnd(frameWM) = 0;
    }
    // Add the border/padding which is now based on visual order.
    frameISize += borderPadding.IStartEnd(frameWM);
  }

  nscoord icoord = 0;
  if (!IsBidiLeaf(aFrame)) {
    bool reverseDir = aIsEvenLevel != frameWM.IsBidiLTR();
    icoord += reverseDir ?
      borderPadding.IEnd(frameWM) : borderPadding.IStart(frameWM);
    LogicalSize logicalSize(frameWM, frameISize, aFrame->BSize());
    nsSize frameSize = logicalSize.GetPhysicalSize(frameWM);
    // Reposition the child frames
    for (nsFrameList::Enumerator e(aFrame->PrincipalChildList());
         !e.AtEnd(); e.Next()) {
      icoord += RepositionFrame(e.get(), aIsEvenLevel, icoord,
                                aContinuationStates,
                                frameWM, reverseDir, frameSize);
    }
    icoord += reverseDir ?
      borderPadding.IStart(frameWM) : borderPadding.IEnd(frameWM);
  } else if (RubyUtils::IsRubyBox(aFrame->GetType())) {
    icoord += RepositionRubyFrame(aFrame, aContinuationStates,
                                  aContainerWM, borderPadding);
  } else {
    icoord +=
      frameWM.IsOrthogonalTo(aContainerWM) ? aFrame->BSize() : frameISize;
  }

  // In the following variables, if aContainerReverseDir is true, i.e.
  // the container is positioning its children in reverse of its logical
  // direction, the "StartOrEnd" refers to the distance from the frame
  // to the inline end edge of the container, elsewise, it refers to the
  // distance to the inline start edge.
  const LogicalMargin margin = frameMargin.ConvertTo(aContainerWM, frameWM);
  nscoord marginStartOrEnd =
    aContainerReverseDir ? margin.IEnd(aContainerWM)
                         : margin.IStart(aContainerWM);
  nscoord frameStartOrEnd = aStartOrEnd + marginStartOrEnd;

  LogicalRect rect = aFrame->GetLogicalRect(aContainerWM, aContainerSize);
  rect.ISize(aContainerWM) = icoord;
  rect.IStart(aContainerWM) =
    aContainerReverseDir ? lineSize - frameStartOrEnd - icoord
                         : frameStartOrEnd;
  aFrame->SetRect(aContainerWM, rect, aContainerSize);

  return icoord + margin.IStartEnd(aContainerWM);
}

void
nsBidiPresUtils::InitContinuationStates(nsIFrame*              aFrame,
                                        nsContinuationStates*  aContinuationStates)
{
  nsFrameContinuationState* state = aContinuationStates->PutEntry(aFrame);
  state->mFirstVisualFrame = nullptr;
  state->mFrameCount = 0;

  if (!IsBidiLeaf(aFrame) || RubyUtils::IsRubyBox(aFrame->GetType())) {
    // Continue for child frames
    for (nsIFrame* frame : aFrame->PrincipalChildList()) {
      InitContinuationStates(frame,
                             aContinuationStates);
    }
  }
}

/* static */ nscoord
nsBidiPresUtils::RepositionInlineFrames(BidiLineData *aBld,
                                        WritingMode aLineWM,
                                        const nsSize& aContainerSize,
                                        nscoord aStart)
{
  nscoord start = aStart;
  nsIFrame* frame;
  int32_t count = aBld->mVisualFrames.Length();
  int32_t index;
  nsContinuationStates continuationStates;

  // Initialize continuation states to (nullptr, 0) for
  // each frame on the line.
  for (index = 0; index < count; index++) {
    InitContinuationStates(aBld->VisualFrameAt(index), &continuationStates);
  }

  // Reposition frames in visual order
  int32_t step, limit;
  if (aLineWM.IsBidiLTR()) {
    index = 0;
    step = 1;
    limit = count;
  } else {
    index = count - 1;
    step = -1;
    limit = -1;
  }
  for (; index != limit; index += step) {
    frame = aBld->VisualFrameAt(index);
    start += RepositionFrame(
      frame, !(IS_LEVEL_RTL(aBld->mLevels[aBld->mIndexMap[index]])),
      start, &continuationStates,
      aLineWM, false, aContainerSize);
  }
  return start;
}

bool
nsBidiPresUtils::CheckLineOrder(nsIFrame*  aFirstFrameOnLine,
                                int32_t    aNumFramesOnLine,
                                nsIFrame** aFirstVisual,
                                nsIFrame** aLastVisual)
{
  BidiLineData bld(aFirstFrameOnLine, aNumFramesOnLine);
  int32_t count = bld.FrameCount();
  
  if (aFirstVisual) {
    *aFirstVisual = bld.VisualFrameAt(0);
  }
  if (aLastVisual) {
    *aLastVisual = bld.VisualFrameAt(count-1);
  }
  
  return bld.mIsReordered;
}

nsIFrame*
nsBidiPresUtils::GetFrameToRightOf(const nsIFrame*  aFrame,
                                   nsIFrame*        aFirstFrameOnLine,
                                   int32_t          aNumFramesOnLine)
{
  BidiLineData bld(aFirstFrameOnLine, aNumFramesOnLine);

  int32_t count = bld.mVisualFrames.Length();

  if (aFrame == nullptr && count)
    return bld.VisualFrameAt(0);
  
  for (int32_t i = 0; i < count - 1; i++) {
    if (bld.VisualFrameAt(i) == aFrame) {
      return bld.VisualFrameAt(i+1);
    }
  }
  
  return nullptr;
}

nsIFrame*
nsBidiPresUtils::GetFrameToLeftOf(const nsIFrame*  aFrame,
                                  nsIFrame*        aFirstFrameOnLine,
                                  int32_t          aNumFramesOnLine)
{
  BidiLineData bld(aFirstFrameOnLine, aNumFramesOnLine);

  int32_t count = bld.mVisualFrames.Length();
  
  if (aFrame == nullptr && count)
    return bld.VisualFrameAt(count-1);
  
  for (int32_t i = 1; i < count; i++) {
    if (bld.VisualFrameAt(i) == aFrame) {
      return bld.VisualFrameAt(i-1);
    }
  }
  
  return nullptr;
}

inline nsresult
nsBidiPresUtils::EnsureBidiContinuation(nsIFrame*       aFrame,
                                        nsIFrame**      aNewFrame,
                                        int32_t         aStart,
                                        int32_t         aEnd)
{
  NS_PRECONDITION(aNewFrame, "null OUT ptr");
  NS_PRECONDITION(aFrame, "aFrame is null");

  aFrame->AdjustOffsetsForBidi(aStart, aEnd);
  return CreateContinuation(aFrame, aNewFrame, false);
}

void
nsBidiPresUtils::RemoveBidiContinuation(BidiParagraphData *aBpd,
                                        nsIFrame*       aFrame,
                                        int32_t         aFirstIndex,
                                        int32_t         aLastIndex)
{
  FrameBidiData bidiData = aFrame->GetBidiData();
  bidiData.precedingControl = kBidiLevelNone;
  for (int32_t index = aFirstIndex + 1; index <= aLastIndex; index++) {
    nsIFrame* frame = aBpd->FrameAt(index);
    if (frame != NS_BIDI_CONTROL_FRAME) {
      // Make the frame and its continuation ancestors fluid,
      // so they can be reused or deleted by normal reflow code
      frame->Properties().Set(nsIFrame::BidiDataProperty(), bidiData);
      frame->AddStateBits(NS_FRAME_IS_BIDI);
      while (frame) {
        nsIFrame* prev = frame->GetPrevContinuation();
        if (prev) {
          MakeContinuationFluid(prev, frame);
          frame = frame->GetParent();
        } else {
          break;
        }
      }
    }
  }

  // Make sure that the last continuation we made fluid does not itself have a
  // fluid continuation (this can happen when re-resolving after dynamic changes
  // to content)
  nsIFrame* lastFrame = aBpd->FrameAt(aLastIndex);
  MakeContinuationsNonFluidUpParentChain(lastFrame, lastFrame->GetNextInFlow());
}

nsresult
nsBidiPresUtils::FormatUnicodeText(nsPresContext*  aPresContext,
                                   char16_t*       aText,
                                   int32_t&        aTextLength,
                                   nsCharType      aCharType)
{
  nsresult rv = NS_OK;
  // ahmed 
  //adjusted for correct numeral shaping  
  uint32_t bidiOptions = aPresContext->GetBidi();
  switch (GET_BIDI_OPTION_NUMERAL(bidiOptions)) {

    case IBMBIDI_NUMERAL_HINDI:
      HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_HINDI);
      break;

    case IBMBIDI_NUMERAL_ARABIC:
      HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_ARABIC);
      break;

    case IBMBIDI_NUMERAL_PERSIAN:
      HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_PERSIAN);
      break;

    case IBMBIDI_NUMERAL_REGULAR:

      switch (aCharType) {

        case eCharType_EuropeanNumber:
          HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_ARABIC);
          break;

        case eCharType_ArabicNumber:
          HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_HINDI);
          break;

        default:
          break;
      }
      break;

    case IBMBIDI_NUMERAL_HINDICONTEXT:
      if ( ( (GET_BIDI_OPTION_DIRECTION(bidiOptions)==IBMBIDI_TEXTDIRECTION_RTL) && (IS_ARABIC_DIGIT (aText[0])) ) || (eCharType_ArabicNumber == aCharType) )
        HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_HINDI);
      else if (eCharType_EuropeanNumber == aCharType)
        HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_ARABIC);
      break;

    case IBMBIDI_NUMERAL_PERSIANCONTEXT:
      if ( ( (GET_BIDI_OPTION_DIRECTION(bidiOptions)==IBMBIDI_TEXTDIRECTION_RTL) && (IS_ARABIC_DIGIT (aText[0])) ) || (eCharType_ArabicNumber == aCharType) )
        HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_PERSIAN);
      else if (eCharType_EuropeanNumber == aCharType)
        HandleNumbers(aText,aTextLength,IBMBIDI_NUMERAL_ARABIC);
      break;

    case IBMBIDI_NUMERAL_NOMINAL:
    default:
      break;
  }

  StripBidiControlCharacters(aText, aTextLength);
  return rv;
}

void
nsBidiPresUtils::StripBidiControlCharacters(char16_t* aText,
                                            int32_t&   aTextLength)
{
  if ( (nullptr == aText) || (aTextLength < 1) ) {
    return;
  }

  int32_t stripLen = 0;

  for (int32_t i = 0; i < aTextLength; i++) {
    // XXX: This silently ignores surrogate characters.
    //      As of Unicode 4.0, all Bidi control characters are within the BMP.
    if (IsBidiControl((uint32_t)aText[i])) {
      ++stripLen;
    }
    else {
      aText[i - stripLen] = aText[i];
    }
  }
  aTextLength -= stripLen;
}
 
#if 0 // XXX: for the future use ???
void
RemoveDiacritics(char16_t* aText,
                 int32_t&   aTextLength)
{
  if (aText && (aTextLength > 0) ) {
    int32_t offset = 0;

    for (int32_t i = 0; i < aTextLength && aText[i]; i++) {
      if (IS_BIDI_DIACRITIC(aText[i]) ) {
        ++offset;
        continue;
      }
      aText[i - offset] = aText[i];
    }
    aTextLength = i - offset;
    aText[aTextLength] = 0;
  }
}
#endif

void
nsBidiPresUtils::CalculateCharType(nsBidi* aBidiEngine,
                                   const char16_t* aText,
                                   int32_t& aOffset,
                                   int32_t  aCharTypeLimit,
                                   int32_t& aRunLimit,
                                   int32_t& aRunLength,
                                   int32_t& aRunCount,
                                   uint8_t& aCharType,
                                   uint8_t& aPrevCharType)

{
  bool       strongTypeFound = false;
  int32_t    offset;
  nsCharType charType;

  aCharType = eCharType_OtherNeutral;

  int32_t charLen;
  for (offset = aOffset; offset < aCharTypeLimit; offset += charLen) {
    // Make sure we give RTL chartype to all characters that would be classified
    // as Right-To-Left by a bidi platform.
    // (May differ from the UnicodeData, eg we set RTL chartype to some NSMs.)
    charLen = 1;
    uint32_t ch = aText[offset];
    if (IS_HEBREW_CHAR(ch) ) {
      charType = eCharType_RightToLeft;
    } else if (IS_ARABIC_ALPHABETIC(ch) ) {
      charType = eCharType_RightToLeftArabic;
    } else {
      if (NS_IS_HIGH_SURROGATE(ch) && offset + 1 < aCharTypeLimit &&
          NS_IS_LOW_SURROGATE(aText[offset + 1])) {
        ch = SURROGATE_TO_UCS4(ch, aText[offset + 1]);
        charLen = 2;
      }
      charType = unicode::GetBidiCat(ch);
    }

    if (!CHARTYPE_IS_WEAK(charType) ) {

      if (strongTypeFound
          && (charType != aPrevCharType)
          && (CHARTYPE_IS_RTL(charType) || CHARTYPE_IS_RTL(aPrevCharType) ) ) {
        // Stop at this point to ensure uni-directionality of the text
        // (from platform's point of view).
        // Also, don't mix Arabic and Hebrew content (since platform may
        // provide BIDI support to one of them only).
        aRunLength = offset - aOffset;
        aRunLimit = offset;
        ++aRunCount;
        break;
      }

      if ( (eCharType_RightToLeftArabic == aPrevCharType
            || eCharType_ArabicNumber == aPrevCharType)
          && eCharType_EuropeanNumber == charType) {
        charType = eCharType_ArabicNumber;
      }

      // Set PrevCharType to the last strong type in this frame
      // (for correct numeric shaping)
      aPrevCharType = charType;

      strongTypeFound = true;
      aCharType = charType;
    }
  }
  aOffset = offset;
}

nsresult nsBidiPresUtils::ProcessText(const char16_t*       aText,
                                      int32_t                aLength,
                                      nsBidiLevel            aBaseLevel,
                                      nsPresContext*         aPresContext,
                                      BidiProcessor&         aprocessor,
                                      Mode                   aMode,
                                      nsBidiPositionResolve* aPosResolve,
                                      int32_t                aPosResolveCount,
                                      nscoord*               aWidth,
                                      nsBidi*                aBidiEngine)
{
  NS_ASSERTION((aPosResolve == nullptr) != (aPosResolveCount > 0), "Incorrect aPosResolve / aPosResolveCount arguments");

  int32_t runCount;

  nsAutoString textBuffer(aText, aLength);
  textBuffer.ReplaceChar(kSeparators, kSpace);
  const char16_t* text = textBuffer.get();

  nsresult rv = aBidiEngine->SetPara(text, aLength, aBaseLevel);
  if (NS_FAILED(rv))
    return rv;

  rv = aBidiEngine->CountRuns(&runCount);
  if (NS_FAILED(rv))
    return rv;

  nscoord xOffset = 0;
  nscoord width, xEndRun = 0;
  nscoord totalWidth = 0;
  int32_t i, start, limit, length;
  uint32_t visualStart = 0;
  uint8_t charType;
  uint8_t prevType = eCharType_LeftToRight;

  for(int nPosResolve=0; nPosResolve < aPosResolveCount; ++nPosResolve)
  {
    aPosResolve[nPosResolve].visualIndex = kNotFound;
    aPosResolve[nPosResolve].visualLeftTwips = kNotFound;
    aPosResolve[nPosResolve].visualWidth = kNotFound;
  }

  for (i = 0; i < runCount; i++) {
    nsBidiDirection dir;
    rv = aBidiEngine->GetVisualRun(i, &start, &length, &dir);
    if (NS_FAILED(rv))
      return rv;

    nsBidiLevel level;
    rv = aBidiEngine->GetLogicalRun(start, &limit, &level);
    if (NS_FAILED(rv))
      return rv;

    dir = DIRECTION_FROM_LEVEL(level);
    int32_t subRunLength = limit - start;
    int32_t lineOffset = start;
    int32_t typeLimit = std::min(limit, aLength);
    int32_t subRunCount = 1;
    int32_t subRunLimit = typeLimit;

    /*
     * If |level| is even, i.e. the direction of the run is left-to-right, we
     * render the subruns from left to right and increment the x-coordinate
     * |xOffset| by the width of each subrun after rendering.
     *
     * If |level| is odd, i.e. the direction of the run is right-to-left, we
     * render the subruns from right to left. We begin by incrementing |xOffset| by
     * the width of the whole run, and then decrement it by the width of each
     * subrun before rendering. After rendering all the subruns, we restore the
     * x-coordinate of the end of the run for the start of the next run.
     */

    if (dir == NSBIDI_RTL) {
      aprocessor.SetText(text + start, subRunLength, dir);
      width = aprocessor.GetWidth();
      xOffset += width;
      xEndRun = xOffset;
    }

    while (subRunCount > 0) {
      // CalculateCharType can increment subRunCount if the run
      // contains mixed character types
      CalculateCharType(aBidiEngine, text, lineOffset, typeLimit, subRunLimit, subRunLength, subRunCount, charType, prevType);

      nsAutoString runVisualText;
      runVisualText.Assign(text + start, subRunLength);
      if (int32_t(runVisualText.Length()) < subRunLength)
        return NS_ERROR_OUT_OF_MEMORY;
      FormatUnicodeText(aPresContext, runVisualText.BeginWriting(),
                        subRunLength, (nsCharType)charType);

      aprocessor.SetText(runVisualText.get(), subRunLength, dir);
      width = aprocessor.GetWidth();
      totalWidth += width;
      if (dir == NSBIDI_RTL) {
        xOffset -= width;
      }
      if (aMode == MODE_DRAW) {
        aprocessor.DrawText(xOffset, width);
      }

      /*
       * The caller may request to calculate the visual position of one
       * or more characters.
       */
      for(int nPosResolve=0; nPosResolve<aPosResolveCount; ++nPosResolve)
      {
        nsBidiPositionResolve* posResolve = &aPosResolve[nPosResolve];
        /*
         * Did we already resolve this position's visual metric? If so, skip.
         */
        if (posResolve->visualLeftTwips != kNotFound)
           continue;
           
        /*
         * First find out if the logical position is within this run.
         */
        if (start <= posResolve->logicalIndex &&
            start + subRunLength > posResolve->logicalIndex) {
          /*
           * If this run is only one character long, we have an easy case:
           * the visual position is the x-coord of the start of the run
           * less the x-coord of the start of the whole text.
           */
          if (subRunLength == 1) {
            posResolve->visualIndex = visualStart;
            posResolve->visualLeftTwips = xOffset;
            posResolve->visualWidth = width;
          }
          /*
           * Otherwise, we need to measure the width of the run's part
           * which is to the visual left of the index.
           * In other words, the run is broken in two, around the logical index,
           * and we measure the part which is visually left.
           * If the run is right-to-left, this part will span from after the index
           * up to the end of the run; if it is left-to-right, this part will span
           * from the start of the run up to (and inclduing) the character before the index.
           */
          else {
            /*
             * Here is a description of how the width of the current character
             * (posResolve->visualWidth) is calculated:
             *
             * LTR (current char: "P"):
             *    S A M P L E          (logical index: 3, visual index: 3)
             *    ^ (visualLeftPart)
             *    ^ (visualRightSide)
             *    visualLeftLength == 3
             *    ^^^^^^ (subWidth)
             *    ^^^^^^^^ (aprocessor.GetWidth() -- with visualRightSide)
             *          ^^ (posResolve->visualWidth)
             *
             * RTL (current char: "M"):
             *    E L P M A S          (logical index: 2, visual index: 3)
             *        ^ (visualLeftPart)
             *          ^ (visualRightSide)
             *    visualLeftLength == 3
             *    ^^^^^^ (subWidth)
             *    ^^^^^^^^ (aprocessor.GetWidth() -- with visualRightSide)
             *          ^^ (posResolve->visualWidth)
             */
            nscoord subWidth;
            // The position in the text where this run's "left part" begins.
            const char16_t* visualLeftPart;
            const char16_t* visualRightSide;
            if (dir == NSBIDI_RTL) {
              // One day, son, this could all be replaced with mBidiEngine.GetVisualIndex ...
              posResolve->visualIndex = visualStart + (subRunLength - (posResolve->logicalIndex + 1 - start));
              // Skipping to the "left part".
              visualLeftPart = text + posResolve->logicalIndex + 1;
              // Skipping to the right side of the current character
              visualRightSide = visualLeftPart - 1;
            }
            else {
              posResolve->visualIndex = visualStart + (posResolve->logicalIndex - start);
              // Skipping to the "left part".
              visualLeftPart = text + start;
              // In LTR mode this is the same as visualLeftPart
              visualRightSide = visualLeftPart;
            }
            // The delta between the start of the run and the left part's end.
            int32_t visualLeftLength = posResolve->visualIndex - visualStart;
            aprocessor.SetText(visualLeftPart, visualLeftLength, dir);
            subWidth = aprocessor.GetWidth();
            aprocessor.SetText(visualRightSide, visualLeftLength + 1, dir);
            posResolve->visualLeftTwips = xOffset + subWidth;
            posResolve->visualWidth = aprocessor.GetWidth() - subWidth;
          }
        }
      }

      if (dir == NSBIDI_LTR) {
        xOffset += width;
      }

      --subRunCount;
      start = lineOffset;
      subRunLimit = typeLimit;
      subRunLength = typeLimit - lineOffset;
    } // while
    if (dir == NSBIDI_RTL) {
      xOffset = xEndRun;
    }

    visualStart += length;
  } // for

  if (aWidth) {
    *aWidth = totalWidth;
  }
  return NS_OK;
}

class MOZ_STACK_CLASS nsIRenderingContextBidiProcessor final
  : public nsBidiPresUtils::BidiProcessor
{
public:
  typedef mozilla::gfx::DrawTarget DrawTarget;

  nsIRenderingContextBidiProcessor(nsRenderingContext* aCtx,
                                   DrawTarget* aTextRunConstructionDrawTarget,
                                   nsFontMetrics* aFontMetrics,
                                   const nsPoint&       aPt)
    : mCtx(aCtx)
    , mTextRunConstructionDrawTarget(aTextRunConstructionDrawTarget)
    , mFontMetrics(aFontMetrics)
    , mPt(aPt)
  {}

  ~nsIRenderingContextBidiProcessor()
  {
    mFontMetrics->SetTextRunRTL(false);
  }

  virtual void SetText(const char16_t* aText,
                       int32_t         aLength,
                       nsBidiDirection aDirection) override
  {
    mFontMetrics->SetTextRunRTL(aDirection==NSBIDI_RTL);
    mText = aText;
    mLength = aLength;
  }

  virtual nscoord GetWidth() override
  {
    return nsLayoutUtils::AppUnitWidthOfString(mText, mLength, *mFontMetrics,
                                               mTextRunConstructionDrawTarget);
  }

  virtual void DrawText(nscoord aIOffset,
                        nscoord) override
  {
    nsPoint pt(mPt);
    if (mFontMetrics->GetVertical()) {
      pt.y += aIOffset;
    } else {
      pt.x += aIOffset;
    }
    mFontMetrics->DrawString(mText, mLength, pt.x, pt.y,
                             mCtx, mTextRunConstructionDrawTarget);
  }

private:
  nsRenderingContext* mCtx;
  DrawTarget* mTextRunConstructionDrawTarget;
  nsFontMetrics* mFontMetrics;
  nsPoint mPt;
  const char16_t* mText;
  int32_t mLength;
};

nsresult nsBidiPresUtils::ProcessTextForRenderingContext(const char16_t*       aText,
                                                         int32_t                aLength,
                                                         nsBidiLevel            aBaseLevel,
                                                         nsPresContext*         aPresContext,
                                                         nsRenderingContext&   aRenderingContext,
                                                         DrawTarget*           aTextRunConstructionDrawTarget,
                                                         nsFontMetrics&         aFontMetrics,
                                                         Mode                   aMode,
                                                         nscoord                aX,
                                                         nscoord                aY,
                                                         nsBidiPositionResolve* aPosResolve,
                                                         int32_t                aPosResolveCount,
                                                         nscoord*               aWidth)
{
  nsIRenderingContextBidiProcessor processor(&aRenderingContext,
                                             aTextRunConstructionDrawTarget,
                                             &aFontMetrics,
                                             nsPoint(aX, aY));
  nsBidi bidiEngine;
  return ProcessText(aText, aLength, aBaseLevel, aPresContext, processor,
                     aMode, aPosResolve, aPosResolveCount, aWidth, &bidiEngine);
}

/* static */
nsBidiLevel
nsBidiPresUtils::BidiLevelFromStyle(nsStyleContext* aStyleContext)
{
  if (aStyleContext->StyleTextReset()->mUnicodeBidi &
      NS_STYLE_UNICODE_BIDI_PLAINTEXT) {
    return NSBIDI_DEFAULT_LTR;
  }

  if (aStyleContext->StyleVisibility()->mDirection == NS_STYLE_DIRECTION_RTL) {
    return NSBIDI_RTL;
  }

  return NSBIDI_LTR;
}
