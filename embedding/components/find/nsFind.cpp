/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//#define DEBUG_FIND 1

#include "nsFind.h"
#include "nsContentCID.h"
#include "nsIContent.h"
#include "nsIDOMNode.h"
#include "nsIDOMNodeList.h"
#include "nsISelection.h"
#include "nsISelectionController.h"
#include "nsIFrame.h"
#include "nsITextControlFrame.h"
#include "nsIFormControl.h"
#include "nsIEditor.h"
#include "nsIPlaintextEditor.h"
#include "nsTextFragment.h"
#include "nsString.h"
#include "nsIAtom.h"
#include "nsServiceManagerUtils.h"
#include "nsUnicharUtils.h"
#include "nsIDOMElement.h"
#include "nsIWordBreaker.h"
#include "nsCRT.h"
#include "nsRange.h"
#include "nsContentUtils.h"
#include "mozilla/DebugOnly.h"

using namespace mozilla;

// Yikes!  Casting a char to unichar can fill with ones!
#define CHAR_TO_UNICHAR(c) ((char16_t)(const unsigned char)c)

static NS_DEFINE_CID(kCContentIteratorCID, NS_CONTENTITERATOR_CID);
static NS_DEFINE_CID(kCPreContentIteratorCID, NS_PRECONTENTITERATOR_CID);

#define CH_QUOTE ((char16_t)0x22)
#define CH_APOSTROPHE ((char16_t)0x27)
#define CH_LEFT_SINGLE_QUOTE ((char16_t)0x2018)
#define CH_RIGHT_SINGLE_QUOTE ((char16_t)0x2019)
#define CH_LEFT_DOUBLE_QUOTE ((char16_t)0x201C)
#define CH_RIGHT_DOUBLE_QUOTE ((char16_t)0x201D)

#define CH_SHY ((char16_t)0xAD)

// nsFind::Find casts CH_SHY to char before calling StripChars
// This works correctly if and only if CH_SHY <= 255
static_assert(CH_SHY <= 255, "CH_SHY is not an ascii character");

// nsFindContentIterator is a special iterator that also goes through any
// existing <textarea>'s or text <input>'s editor to lookup the anonymous DOM
// content there.
//
// Details:
// 1) We use two iterators: The "outer-iterator" goes through the normal DOM.
// The "inner-iterator" goes through the anonymous DOM inside the editor.
//
// 2) [MaybeSetupInnerIterator] As soon as the outer-iterator's current node is
// changed, a check is made to see if the node is a <textarea> or a text <input>
// node. If so, an inner-iterator is created to lookup the anynomous contents of
// the editor underneath the text control.
//
// 3) When the inner-iterator is created, we position the outer-iterator 'after'
// (or 'before' in backward search) the text control to avoid revisiting that
// control.
//
// 4) As a consequence of searching through text controls, we can be called via
// FindNext with the current selection inside a <textarea> or a text <input>.
// This means that we can be given an initial search range that stretches across
// the anonymous DOM and the normal DOM. To cater for this situation, we split
// the anonymous part into the inner-iterator and then reposition the outer-
// iterator outside.
//
// 5) The implementation assumes that First() and Next() are only called in
// find-forward mode, while Last() and Prev() are used in find-backward.

class nsFindContentIterator final : public nsIContentIterator
{
public:
  explicit nsFindContentIterator(bool aFindBackward)
    : mStartOffset(0)
    , mEndOffset(0)
    , mFindBackward(aFindBackward)
  {
  }

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_CLASS(nsFindContentIterator)

  // nsIContentIterator
  virtual nsresult Init(nsINode* aRoot) override
  {
    NS_NOTREACHED("internal error");
    return NS_ERROR_NOT_IMPLEMENTED;
  }
  virtual nsresult Init(nsIDOMRange* aRange) override
  {
    NS_NOTREACHED("internal error");
    return NS_ERROR_NOT_IMPLEMENTED;
  }
  // Not a range because one of the endpoints may be anonymous.
  nsresult Init(nsIDOMNode* aStartNode, int32_t aStartOffset,
                nsIDOMNode* aEndNode, int32_t aEndOffset);
  virtual void First() override;
  virtual void Last() override;
  virtual void Next() override;
  virtual void Prev() override;
  virtual nsINode* GetCurrentNode() override;
  virtual bool IsDone() override;
  virtual nsresult PositionAt(nsINode* aCurNode) override;

protected:
  virtual ~nsFindContentIterator() {}

private:
  static already_AddRefed<nsIDOMRange> CreateRange(nsINode* aNode)
  {
    RefPtr<nsRange> range = new nsRange(aNode);
    range->SetMaySpanAnonymousSubtrees(true);
    return range.forget();
  }

  nsCOMPtr<nsIContentIterator> mOuterIterator;
  nsCOMPtr<nsIContentIterator> mInnerIterator;
  // Can't use a range here, since we want to represent part of the flattened
  // tree, including native anonymous content.
  nsCOMPtr<nsIDOMNode> mStartNode;
  int32_t mStartOffset;
  nsCOMPtr<nsIDOMNode> mEndNode;
  int32_t mEndOffset;

  nsCOMPtr<nsIContent> mStartOuterContent;
  nsCOMPtr<nsIContent> mEndOuterContent;
  bool mFindBackward;

  void Reset();
  void MaybeSetupInnerIterator();
  void SetupInnerIterator(nsIContent* aContent);
};

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsFindContentIterator)
  NS_INTERFACE_MAP_ENTRY(nsIContentIterator)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsFindContentIterator)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsFindContentIterator)

NS_IMPL_CYCLE_COLLECTION(nsFindContentIterator, mOuterIterator, mInnerIterator,
                         mStartOuterContent, mEndOuterContent, mEndNode,
                         mStartNode)

nsresult
nsFindContentIterator::Init(nsIDOMNode* aStartNode, int32_t aStartOffset,
                            nsIDOMNode* aEndNode, int32_t aEndOffset)
{
  NS_ENSURE_ARG_POINTER(aStartNode);
  NS_ENSURE_ARG_POINTER(aEndNode);
  if (!mOuterIterator) {
    if (mFindBackward) {
      // Use post-order in the reverse case, so we get parents before children
      // in case we want to prevent descending into a node.
      mOuterIterator = do_CreateInstance(kCContentIteratorCID);
    } else {
      // Use pre-order in the forward case, so we get parents before children in
      // case we want to prevent descending into a node.
      mOuterIterator = do_CreateInstance(kCPreContentIteratorCID);
    }
    NS_ENSURE_ARG_POINTER(mOuterIterator);
  }

  // Set up the search "range" that we will examine
  mStartNode = aStartNode;
  mStartOffset = aStartOffset;
  mEndNode = aEndNode;
  mEndOffset = aEndOffset;

  return NS_OK;
}

void
nsFindContentIterator::First()
{
  Reset();
}

void
nsFindContentIterator::Last()
{
  Reset();
}

void
nsFindContentIterator::Next()
{
  if (mInnerIterator) {
    mInnerIterator->Next();
    if (!mInnerIterator->IsDone()) {
      return;
    }

    // by construction, mOuterIterator is already on the next node
  } else {
    mOuterIterator->Next();
  }
  MaybeSetupInnerIterator();
}

void
nsFindContentIterator::Prev()
{
  if (mInnerIterator) {
    mInnerIterator->Prev();
    if (!mInnerIterator->IsDone()) {
      return;
    }

    // by construction, mOuterIterator is already on the previous node
  } else {
    mOuterIterator->Prev();
  }
  MaybeSetupInnerIterator();
}

nsINode*
nsFindContentIterator::GetCurrentNode()
{
  if (mInnerIterator && !mInnerIterator->IsDone()) {
    return mInnerIterator->GetCurrentNode();
  }
  return mOuterIterator->GetCurrentNode();
}

bool
nsFindContentIterator::IsDone()
{
  if (mInnerIterator && !mInnerIterator->IsDone()) {
    return false;
  }
  return mOuterIterator->IsDone();
}

nsresult
nsFindContentIterator::PositionAt(nsINode* aCurNode)
{
  nsINode* oldNode = mOuterIterator->GetCurrentNode();
  nsresult rv = mOuterIterator->PositionAt(aCurNode);
  if (NS_SUCCEEDED(rv)) {
    MaybeSetupInnerIterator();
  } else {
    mOuterIterator->PositionAt(oldNode);
    if (mInnerIterator) {
      rv = mInnerIterator->PositionAt(aCurNode);
    }
  }
  return rv;
}

void
nsFindContentIterator::Reset()
{
  mInnerIterator = nullptr;
  mStartOuterContent = nullptr;
  mEndOuterContent = nullptr;

  // As a consequence of searching through text controls, we may have been
  // initialized with a selection inside a <textarea> or a text <input>.

  // see if the start node is an anonymous text node inside a text control
  nsCOMPtr<nsIContent> startContent(do_QueryInterface(mStartNode));
  if (startContent) {
    mStartOuterContent = startContent->FindFirstNonChromeOnlyAccessContent();
  }

  // see if the end node is an anonymous text node inside a text control
  nsCOMPtr<nsIContent> endContent(do_QueryInterface(mEndNode));
  if (endContent) {
    mEndOuterContent = endContent->FindFirstNonChromeOnlyAccessContent();
  }

  // Note: OK to just set up the outer iterator here; if our range has a native
  // anonymous endpoint we'll end up setting up an inner iterator, and reset the
  // outer one in the process.
  nsCOMPtr<nsINode> node = do_QueryInterface(mStartNode);
  NS_ENSURE_TRUE_VOID(node);

  nsCOMPtr<nsIDOMRange> range = CreateRange(node);
  range->SetStart(mStartNode, mStartOffset);
  range->SetEnd(mEndNode, mEndOffset);
  mOuterIterator->Init(range);

  if (!mFindBackward) {
    if (mStartOuterContent != startContent) {
      // the start node was an anonymous text node
      SetupInnerIterator(mStartOuterContent);
      if (mInnerIterator) {
        mInnerIterator->First();
      }
    }
    if (!mOuterIterator->IsDone()) {
      mOuterIterator->First();
    }
  } else {
    if (mEndOuterContent != endContent) {
      // the end node was an anonymous text node
      SetupInnerIterator(mEndOuterContent);
      if (mInnerIterator) {
        mInnerIterator->Last();
      }
    }
    if (!mOuterIterator->IsDone()) {
      mOuterIterator->Last();
    }
  }

  // if we didn't create an inner-iterator, the boundary node could still be
  // a text control, in which case we also need an inner-iterator straightaway
  if (!mInnerIterator) {
    MaybeSetupInnerIterator();
  }
}

void
nsFindContentIterator::MaybeSetupInnerIterator()
{
  mInnerIterator = nullptr;

  nsCOMPtr<nsIContent> content =
    do_QueryInterface(mOuterIterator->GetCurrentNode());
  if (!content || !content->IsNodeOfType(nsINode::eHTML_FORM_CONTROL)) {
    return;
  }

  nsCOMPtr<nsIFormControl> formControl(do_QueryInterface(content));
  if (!formControl->IsTextControl(true)) {
    return;
  }

  SetupInnerIterator(content);
  if (mInnerIterator) {
    if (!mFindBackward) {
      mInnerIterator->First();
      // finish setup: position mOuterIterator on the actual "next" node (this
      // completes its re-init, @see SetupInnerIterator)
      if (!mOuterIterator->IsDone()) {
        mOuterIterator->First();
      }
    } else {
      mInnerIterator->Last();
      // finish setup: position mOuterIterator on the actual "previous" node
      // (this completes its re-init, @see SetupInnerIterator)
      if (!mOuterIterator->IsDone()) {
        mOuterIterator->Last();
      }
    }
  }
}

void
nsFindContentIterator::SetupInnerIterator(nsIContent* aContent)
{
  if (!aContent) {
    return;
  }
  NS_ASSERTION(!aContent->IsRootOfNativeAnonymousSubtree(), "invalid call");

  nsITextControlFrame* tcFrame = do_QueryFrame(aContent->GetPrimaryFrame());
  if (!tcFrame) {
    return;
  }

  nsCOMPtr<nsIEditor> editor;
  tcFrame->GetEditor(getter_AddRefs(editor));
  if (!editor) {
    return;
  }

  // don't mess with disabled input fields
  uint32_t editorFlags = 0;
  editor->GetFlags(&editorFlags);
  if (editorFlags & nsIPlaintextEditor::eEditorDisabledMask) {
    return;
  }

  nsCOMPtr<nsIDOMElement> rootElement;
  editor->GetRootElement(getter_AddRefs(rootElement));

  nsCOMPtr<nsIDOMRange> innerRange = CreateRange(aContent);
  nsCOMPtr<nsIDOMRange> outerRange = CreateRange(aContent);
  if (!innerRange || !outerRange) {
    return;
  }

  // now create the inner-iterator
  mInnerIterator = do_CreateInstance(kCPreContentIteratorCID);

  if (mInnerIterator) {
    innerRange->SelectNodeContents(rootElement);

    // fix up the inner bounds, we may have to only lookup a portion
    // of the text control if the current node is a boundary point
    if (aContent == mStartOuterContent) {
      innerRange->SetStart(mStartNode, mStartOffset);
    }
    if (aContent == mEndOuterContent) {
      innerRange->SetEnd(mEndNode, mEndOffset);
    }
    // Note: we just init here. We do First() or Last() later.
    mInnerIterator->Init(innerRange);

    // make sure to place the outer-iterator outside the text control so that we
    // don't go there again.
    nsresult res1, res2;
    nsCOMPtr<nsIDOMNode> outerNode(do_QueryInterface(aContent));
    if (!mFindBackward) { // find forward
      // cut the outer-iterator after the current node
      res1 = outerRange->SetEnd(mEndNode, mEndOffset);
      res2 = outerRange->SetStartAfter(outerNode);
    } else { // find backward
      // cut the outer-iterator before the current node
      res1 = outerRange->SetStart(mStartNode, mStartOffset);
      res2 = outerRange->SetEndBefore(outerNode);
    }
    if (NS_FAILED(res1) || NS_FAILED(res2)) {
      // we are done with the outer-iterator, the inner-iterator will traverse
      // what we want
      outerRange->Collapse(true);
    }

    // Note: we just re-init here, using the segment of our search range that
    // is yet to be visited. Thus when we later do mOuterIterator->First() [or
    // mOuterIterator->Last()], we will effectively be on the next node [or
    // the previous node] _with respect to_ the search range.
    mOuterIterator->Init(outerRange);
  }
}

nsresult
NS_NewFindContentIterator(bool aFindBackward, nsIContentIterator** aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  if (!aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  nsFindContentIterator* it = new nsFindContentIterator(aFindBackward);
  if (!it) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  return it->QueryInterface(NS_GET_IID(nsIContentIterator), (void**)aResult);
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsFind)
  NS_INTERFACE_MAP_ENTRY(nsIFind)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsFind)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsFind)

NS_IMPL_CYCLE_COLLECTION(nsFind, mLastBlockParent, mIterNode, mIterator)

nsFind::nsFind()
  : mFindBackward(false)
  , mCaseSensitive(false)
  , mIterOffset(0)
{
}

nsFind::~nsFind()
{
}

#ifdef DEBUG_FIND
static void
DumpNode(nsIDOMNode* aNode)
{
  if (!aNode) {
    printf(">>>> Node: NULL\n");
    return;
  }
  nsAutoString nodeName;
  aNode->GetNodeName(nodeName);
  nsCOMPtr<nsIContent> textContent(do_QueryInterface(aNode));
  if (textContent && textContent->IsNodeOfType(nsINode::eTEXT)) {
    nsAutoString newText;
    textContent->AppendTextTo(newText);
    printf(">>>> Text node (node name %s): '%s'\n",
           NS_LossyConvertUTF16toASCII(nodeName).get(),
           NS_LossyConvertUTF16toASCII(newText).get());
  } else {
    printf(">>>> Node: %s\n", NS_LossyConvertUTF16toASCII(nodeName).get());
  }
}
#endif

nsresult
nsFind::InitIterator(nsIDOMNode* aStartNode, int32_t aStartOffset,
                     nsIDOMNode* aEndNode, int32_t aEndOffset)
{
  if (!mIterator) {
    mIterator = new nsFindContentIterator(mFindBackward);
    NS_ENSURE_TRUE(mIterator, NS_ERROR_OUT_OF_MEMORY);
  }

  NS_ENSURE_ARG_POINTER(aStartNode);
  NS_ENSURE_ARG_POINTER(aEndNode);

#ifdef DEBUG_FIND
  printf("InitIterator search range:\n");
  printf(" -- start %d, ", aStartOffset);
  DumpNode(aStartNode);
  printf(" -- end %d, ", aEndOffset);
  DumpNode(aEndNode);
#endif

  nsresult rv = mIterator->Init(aStartNode, aStartOffset, aEndNode, aEndOffset);
  NS_ENSURE_SUCCESS(rv, rv);
  if (mFindBackward) {
    mIterator->Last();
  } else {
    mIterator->First();
  }
  return NS_OK;
}

NS_IMETHODIMP
nsFind::GetFindBackwards(bool* aFindBackward)
{
  if (!aFindBackward) {
    return NS_ERROR_NULL_POINTER;
  }

  *aFindBackward = mFindBackward;
  return NS_OK;
}

NS_IMETHODIMP
nsFind::SetFindBackwards(bool aFindBackward)
{
  mFindBackward = aFindBackward;
  return NS_OK;
}

NS_IMETHODIMP
nsFind::GetCaseSensitive(bool* aCaseSensitive)
{
  if (!aCaseSensitive) {
    return NS_ERROR_NULL_POINTER;
  }

  *aCaseSensitive = mCaseSensitive;
  return NS_OK;
}

NS_IMETHODIMP
nsFind::SetCaseSensitive(bool aCaseSensitive)
{
  mCaseSensitive = aCaseSensitive;
  return NS_OK;
}

/* attribute boolean entireWord; */
NS_IMETHODIMP
nsFind::GetEntireWord(bool *aEntireWord)
{
  if (!aEntireWord)
    return NS_ERROR_NULL_POINTER;

  *aEntireWord = !!mWordBreaker;
  return NS_OK;
}

NS_IMETHODIMP
nsFind::SetEntireWord(bool aEntireWord)
{
  mWordBreaker = aEntireWord ? nsContentUtils::WordBreaker() : nullptr;
  return NS_OK;
}

// Here begins the find code. A ten-thousand-foot view of how it works: Find
// needs to be able to compare across inline (but not block) nodes, e.g. find
// for "abc" should match a<b>b</b>c. So after we've searched a node, we're not
// done with it; in the case of a partial match we may need to reset the
// iterator to go back to a previously visited node, so we always save the
// "match anchor" node and offset.
//
// Text nodes store their text in an nsTextFragment, which is effectively a
// union of a one-byte string or a two-byte string. Single and double strings
// are intermixed in the dom. We don't have string classes which can deal with
// intermixed strings, so all the handling is done explicitly here.

nsresult
nsFind::NextNode(nsIDOMRange* aSearchRange,
                 nsIDOMRange* aStartPoint, nsIDOMRange* aEndPoint,
                 bool aContinueOk)
{
  nsresult rv;

  nsCOMPtr<nsIContent> content;

  if (!mIterator || aContinueOk) {
    // If we are continuing, that means we have a match in progress. In that
    // case, we want to continue from the end point (where we are now) to the
    // beginning/end of the search range.
    nsCOMPtr<nsIDOMNode> startNode;
    nsCOMPtr<nsIDOMNode> endNode;
    int32_t startOffset, endOffset;
    if (aContinueOk) {
#ifdef DEBUG_FIND
      printf("Match in progress: continuing past endpoint\n");
#endif
      if (mFindBackward) {
        aSearchRange->GetStartContainer(getter_AddRefs(startNode));
        aSearchRange->GetStartOffset(&startOffset);
        aEndPoint->GetStartContainer(getter_AddRefs(endNode));
        aEndPoint->GetStartOffset(&endOffset);
      } else { // forward
        aEndPoint->GetEndContainer(getter_AddRefs(startNode));
        aEndPoint->GetEndOffset(&startOffset);
        aSearchRange->GetEndContainer(getter_AddRefs(endNode));
        aSearchRange->GetEndOffset(&endOffset);
      }
    } else { // Normal, not continuing
      if (mFindBackward) {
        aSearchRange->GetStartContainer(getter_AddRefs(startNode));
        aSearchRange->GetStartOffset(&startOffset);
        aStartPoint->GetEndContainer(getter_AddRefs(endNode));
        aStartPoint->GetEndOffset(&endOffset);
        // XXX Needs work: Problem with this approach: if there is a match which
        // starts just before the current selection and continues into the
        // selection, we will miss it, because our search algorithm only starts
        // searching from the end of the word, so we would have to search the
        // current selection but discount any matches that fall entirely inside
        // it.
      } else { // forward
        aStartPoint->GetStartContainer(getter_AddRefs(startNode));
        aStartPoint->GetStartOffset(&startOffset);
        aEndPoint->GetEndContainer(getter_AddRefs(endNode));
        aEndPoint->GetEndOffset(&endOffset);
      }
    }

    rv = InitIterator(startNode, startOffset, endNode, endOffset);
    NS_ENSURE_SUCCESS(rv, rv);
    if (!aStartPoint) {
      aStartPoint = aSearchRange;
    }

    content = do_QueryInterface(mIterator->GetCurrentNode());
#ifdef DEBUG_FIND
    nsCOMPtr<nsIDOMNode> dnode(do_QueryInterface(content));
    printf(":::::: Got the first node ");
    DumpNode(dnode);
#endif
    if (content && content->IsNodeOfType(nsINode::eTEXT) &&
        !SkipNode(content)) {
      mIterNode = do_QueryInterface(content);
      // Also set mIterOffset if appropriate:
      nsCOMPtr<nsIDOMNode> node;
      if (mFindBackward) {
        aStartPoint->GetEndContainer(getter_AddRefs(node));
        if (mIterNode.get() == node.get()) {
          aStartPoint->GetEndOffset(&mIterOffset);
        } else {
          mIterOffset = -1; // sign to start from end
        }
      } else {
        aStartPoint->GetStartContainer(getter_AddRefs(node));
        if (mIterNode.get() == node.get()) {
          aStartPoint->GetStartOffset(&mIterOffset);
        } else {
          mIterOffset = 0;
        }
      }
#ifdef DEBUG_FIND
      printf("Setting initial offset to %d\n", mIterOffset);
#endif
      return NS_OK;
    }
  }

  while (true) {
    if (mFindBackward) {
      mIterator->Prev();
    } else {
      mIterator->Next();
    }

    content = do_QueryInterface(mIterator->GetCurrentNode());
    if (!content) {
      break;
    }

#ifdef DEBUG_FIND
    nsCOMPtr<nsIDOMNode> dnode(do_QueryInterface(content));
    printf(":::::: Got another node ");
    DumpNode(dnode);
#endif

    // If we ever cross a block node, we might want to reset the match anchor:
    // we don't match patterns extending across block boundaries. But we can't
    // depend on this test here now, because the iterator doesn't give us the
    // parent going in and going out, and we need it both times to depend on
    // this.
    //if (IsBlockNode(content))

    // Now see if we need to skip this node -- e.g. is it part of a script or
    // other invisible node? Note that we don't ask for CSS information; a node
    // can be invisible due to CSS, and we'd still find it.
    if (SkipNode(content)) {
      continue;
    }

    if (content->IsNodeOfType(nsINode::eTEXT)) {
      break;
    }
#ifdef DEBUG_FIND
    dnode = do_QueryInterface(content);
    printf("Not a text node: ");
    DumpNode(dnode);
#endif
  }

  if (content) {
    mIterNode = do_QueryInterface(content);
  } else {
    mIterNode = nullptr;
  }
  mIterOffset = -1;

#ifdef DEBUG_FIND
  printf("Iterator gave: ");
  DumpNode(mIterNode);
#endif
  return NS_OK;
}

class MOZ_STACK_CLASS PeekNextCharRestoreState final
{
public:
  explicit PeekNextCharRestoreState(nsFind* aFind)
    : mIterOffset(aFind->mIterOffset),
      mIterNode(aFind->mIterNode),
      mCurrNode(aFind->mIterator->GetCurrentNode()),
      mFind(aFind)
  {
  }

  ~PeekNextCharRestoreState()
  {
    mFind->mIterOffset = mIterOffset;
    mFind->mIterNode = mIterNode;
    mFind->mIterator->PositionAt(mCurrNode);
  }

private:
  int32_t mIterOffset;
  nsCOMPtr<nsIDOMNode> mIterNode;
  nsCOMPtr<nsINode> mCurrNode;
  RefPtr<nsFind> mFind;
};

char16_t
nsFind::PeekNextChar(nsIDOMRange* aSearchRange,
                     nsIDOMRange* aStartPoint,
                     nsIDOMRange* aEndPoint)
{
  // We need to restore the necessary member variables before this function
  // returns.
  PeekNextCharRestoreState restoreState(this);

  nsCOMPtr<nsIContent> tc;
  nsresult rv;
  const nsTextFragment *frag;
  int32_t fragLen;

  // Loop through non-block nodes until we find one that's not empty.
  do {
    tc = nullptr;
    NextNode(aSearchRange, aStartPoint, aEndPoint, false);

    // Get the text content:
    tc = do_QueryInterface(mIterNode);

    // Get the block parent.
    nsCOMPtr<nsIDOMNode> blockParent;
    rv = GetBlockParent(mIterNode, getter_AddRefs(blockParent));
    if (NS_FAILED(rv))
      return L'\0';

    // If out of nodes or in new parent.
    if (!mIterNode || !tc || (blockParent != mLastBlockParent))
      return L'\0';

    frag = tc->GetText();
    fragLen = frag->GetLength();
  } while (fragLen <= 0);

  const char16_t *t2b = nullptr;
  const char *t1b = nullptr;

  if (frag->Is2b()) {
    t2b = frag->Get2b();
  } else {
    t1b = frag->Get1b();
  }

  // Index of char to return.
  int32_t index = mFindBackward ? fragLen - 1 : 0;

  return t1b ? CHAR_TO_UNICHAR(t1b[index]) : t2b[index];
}

bool
nsFind::IsBlockNode(nsIContent* aContent)
{
  if (aContent->IsAnyOfHTMLElements(nsGkAtoms::img,
                                    nsGkAtoms::hr,
                                    nsGkAtoms::th,
                                    nsGkAtoms::td)) {
    return true;
  }

  return nsContentUtils::IsHTMLBlock(aContent);
}

bool
nsFind::IsTextNode(nsIDOMNode* aNode)
{
  uint16_t nodeType;
  aNode->GetNodeType(&nodeType);

  return nodeType == nsIDOMNode::TEXT_NODE ||
         nodeType == nsIDOMNode::CDATA_SECTION_NODE;
}

bool
nsFind::IsVisibleNode(nsIDOMNode* aDOMNode)
{
  nsCOMPtr<nsIContent> content(do_QueryInterface(aDOMNode));
  if (!content) {
    return false;
  }

  nsIFrame* frame = content->GetPrimaryFrame();
  if (!frame) {
    // No frame! Not visible then.
    return false;
  }

  return frame->StyleVisibility()->IsVisible();
}

bool
nsFind::SkipNode(nsIContent* aContent)
{
#ifdef HAVE_BIDI_ITERATOR
  // We may not need to skip comment nodes, now that IsTextNode distinguishes
  // them from real text nodes.
  return aContent->IsNodeOfType(nsINode::eCOMMENT) ||
         aContent->IsAnyOfHTMLElements(sScriptAtom, sNoframesAtom, sSelectAtom);

#else /* HAVE_BIDI_ITERATOR */
  // Temporary: eventually we will have an iterator to do this, but for now, we
  // have to climb up the tree for each node and see whether any parent is a
  // skipped node, and take the performance hit.

  nsIContent* content = aContent;
  while (content) {
    if (aContent->IsNodeOfType(nsINode::eCOMMENT) ||
        content->IsAnyOfHTMLElements(nsGkAtoms::script,
                                     nsGkAtoms::noframes,
                                     nsGkAtoms::select)) {
#ifdef DEBUG_FIND
      printf("Skipping node: ");
      nsCOMPtr<nsIDOMNode> node(do_QueryInterface(content));
      DumpNode(node);
#endif

      return true;
    }

    // Only climb to the nearest block node
    if (IsBlockNode(content)) {
      return false;
    }

    content = content->GetParent();
  }

  return false;
#endif /* HAVE_BIDI_ITERATOR */
}

nsresult
nsFind::GetBlockParent(nsIDOMNode* aNode, nsIDOMNode** aParent)
{
  while (aNode) {
    nsCOMPtr<nsIDOMNode> parent;
    nsresult rv = aNode->GetParentNode(getter_AddRefs(parent));
    NS_ENSURE_SUCCESS(rv, rv);
    nsCOMPtr<nsIContent> content(do_QueryInterface(parent));
    if (content && IsBlockNode(content)) {
      *aParent = parent;
      NS_ADDREF(*aParent);
      return NS_OK;
    }
    aNode = parent;
  }
  return NS_ERROR_FAILURE;
}

// Call ResetAll before returning, to remove all references to external objects.
void
nsFind::ResetAll()
{
  mIterator = nullptr;
  mLastBlockParent = nullptr;
}

#define NBSP_CHARCODE (CHAR_TO_UNICHAR(160))
#define IsSpace(c) (nsCRT::IsAsciiSpace(c) || (c) == NBSP_CHARCODE)
#define OVERFLOW_PINDEX (mFindBackward ? pindex < 0 : pindex > patLen)
#define DONE_WITH_PINDEX (mFindBackward ? pindex <= 0 : pindex >= patLen)
#define ALMOST_DONE_WITH_PINDEX (mFindBackward ? pindex <= 0 : pindex >= patLen - 1)

// Take nodes out of the tree with NextNode, until null (NextNode will return 0
// at the end of our range).
NS_IMETHODIMP
nsFind::Find(const char16_t* aPatText, nsIDOMRange* aSearchRange,
             nsIDOMRange* aStartPoint, nsIDOMRange* aEndPoint,
             nsIDOMRange** aRangeRet)
{
#ifdef DEBUG_FIND
  printf("============== nsFind::Find('%s'%s, %p, %p, %p)\n",
         NS_LossyConvertUTF16toASCII(aPatText).get(),
         mFindBackward ? " (backward)" : " (forward)",
         (void*)aSearchRange, (void*)aStartPoint, (void*)aEndPoint);
#endif

  NS_ENSURE_ARG(aSearchRange);
  NS_ENSURE_ARG(aStartPoint);
  NS_ENSURE_ARG(aEndPoint);
  NS_ENSURE_ARG_POINTER(aRangeRet);
  *aRangeRet = 0;

  if (!aPatText) {
    return NS_ERROR_NULL_POINTER;
  }

  ResetAll();

  nsAutoString patAutoStr(aPatText);
  if (!mCaseSensitive) {
    ToLowerCase(patAutoStr);
  }

  // Ignore soft hyphens in the pattern
  static const char kShy[] = { char(CH_SHY), 0 };
  patAutoStr.StripChars(kShy);

  const char16_t* patStr = patAutoStr.get();
  int32_t patLen = patAutoStr.Length() - 1;

  // current offset into the pattern -- reset to beginning/end:
  int32_t pindex = (mFindBackward ? patLen : 0);

  // Current offset into the fragment
  int32_t findex = 0;

  // Direction to move pindex and ptr*
  int incr = (mFindBackward ? -1 : 1);

  nsCOMPtr<nsIContent> tc;
  const nsTextFragment* frag = nullptr;
  int32_t fragLen = 0;

  // Pointers into the current fragment:
  const char16_t* t2b = nullptr;
  const char* t1b = nullptr;

  // Keep track of when we're in whitespace:
  // (only matters when we're matching)
  bool inWhitespace = false;
  // Keep track of whether the previous char was a word-breaking one.
  bool wordBreakPrev = false;

  // Place to save the range start point in case we find a match:
  nsCOMPtr<nsIDOMNode> matchAnchorNode;
  int32_t matchAnchorOffset = 0;

  // Get the end point, so we know when to end searches:
  nsCOMPtr<nsIDOMNode> endNode;
  int32_t endOffset;
  aEndPoint->GetEndContainer(getter_AddRefs(endNode));
  aEndPoint->GetEndOffset(&endOffset);

  char16_t c = 0;
  char16_t patc = 0;
  char16_t prevChar = 0;
  char16_t prevCharInMatch = 0;
  while (1) {
#ifdef DEBUG_FIND
    printf("Loop ...\n");
#endif

    // If this is our first time on a new node, reset the pointers:
    if (!frag) {

      tc = nullptr;
      NextNode(aSearchRange, aStartPoint, aEndPoint, false);
      if (!mIterNode) { // Out of nodes
        // Are we in the middle of a match? If so, try again with continuation.
        if (matchAnchorNode) {
          NextNode(aSearchRange, aStartPoint, aEndPoint, true);
        }

        // Reset the iterator, so this nsFind will be usable if the user wants
        // to search again (from beginning/end).
        ResetAll();
        return NS_OK;
      }

      // We have a new text content. If its block parent is different from the
      // block parent of the last text content, then we need to clear the match
      // since we don't want to find across block boundaries.
      nsCOMPtr<nsIDOMNode> blockParent;
      GetBlockParent(mIterNode, getter_AddRefs(blockParent));
#ifdef DEBUG_FIND
      printf("New node: old blockparent = %p, new = %p\n",
             (void*)mLastBlockParent.get(), (void*)blockParent.get());
#endif
      if (blockParent != mLastBlockParent) {
#ifdef DEBUG_FIND
        printf("Different block parent!\n");
#endif
        mLastBlockParent = blockParent;
        // End any pending match:
        matchAnchorNode = nullptr;
        matchAnchorOffset = 0;
        pindex = (mFindBackward ? patLen : 0);
        inWhitespace = false;
      }

      // Get the text content:
      tc = do_QueryInterface(mIterNode);
      if (!tc || !(frag = tc->GetText())) { // Out of nodes
        mIterator = nullptr;
        mLastBlockParent = nullptr;
        ResetAll();
        return NS_OK;
      }

      fragLen = frag->GetLength();

      // Set our starting point in this node. If we're going back to the anchor
      // node, which means that we just ended a partial match, use the saved
      // offset:
      if (mIterNode == matchAnchorNode) {
        findex = matchAnchorOffset + (mFindBackward ? 1 : 0);
      }

      // mIterOffset, if set, is the range's idea of an offset, and points
      // between characters. But when translated to a string index, it points to
      // a character. If we're going backward, this is one character too late
      // and we'll match part of our previous pattern.
      else if (mIterOffset >= 0) {
        findex = mIterOffset - (mFindBackward ? 1 : 0);
      }

      // Otherwise, just start at the appropriate end of the fragment:
      else if (mFindBackward) {
        findex = fragLen - 1;
      } else {
        findex = 0;
      }

      // Offset can only apply to the first node:
      mIterOffset = -1;

      // If this is outside the bounds of the string, then skip this node:
      if (findex < 0 || findex > fragLen - 1) {
#ifdef DEBUG_FIND
        printf("At the end of a text node -- skipping to the next\n");
#endif
        frag = 0;
        continue;
      }

#ifdef DEBUG_FIND
      printf("Starting from offset %d\n", findex);
#endif
      if (frag->Is2b()) {
        t2b = frag->Get2b();
        t1b = nullptr;
#ifdef DEBUG_FIND
        nsAutoString str2(t2b, fragLen);
        printf("2 byte, '%s'\n", NS_LossyConvertUTF16toASCII(str2).get());
#endif
      } else {
        t1b = frag->Get1b();
        t2b = nullptr;
#ifdef DEBUG_FIND
        nsAutoCString str1(t1b, fragLen);
        printf("1 byte, '%s'\n", str1.get());
#endif
      }
    } else {
      // Still on the old node. Advance the pointers, then see if we need to
      // pull a new node.
      findex += incr;
#ifdef DEBUG_FIND
      printf("Same node -- (%d, %d)\n", pindex, findex);
#endif
      if (mFindBackward ? (findex < 0) : (findex >= fragLen)) {
#ifdef DEBUG_FIND
        printf("Will need to pull a new node: mAO = %d, frag len=%d\n",
               matchAnchorOffset, fragLen);
#endif
        // Done with this node.  Pull a new one.
        frag = nullptr;
        continue;
      }
    }

    // Have we gone past the endpoint yet? If we have, and we're not in the
    // middle of a match, return.
    if (mIterNode == endNode &&
        ((mFindBackward && findex < endOffset) ||
         (!mFindBackward && findex > endOffset))) {
      ResetAll();
      return NS_OK;
    }

    // Save the previous character for word boundary detection
    prevChar = c;
    // The two characters we'll be comparing:
    c = (t2b ? t2b[findex] : CHAR_TO_UNICHAR(t1b[findex]));
    patc = patStr[pindex];

#ifdef DEBUG_FIND
    printf("Comparing '%c'=%x to '%c' (%d of %d), findex=%d%s\n",
           (char)c, (int)c, patc, pindex, patLen, findex,
           inWhitespace ? " (inWhitespace)" : "");
#endif

    // Do we need to go back to non-whitespace mode? If inWhitespace, then this
    // space in the pat str has already matched at least one space in the
    // document.
    if (inWhitespace && !IsSpace(c)) {
      inWhitespace = false;
      pindex += incr;
#ifdef DEBUG
      // This shouldn't happen -- if we were still matching, and we were at the
      // end of the pat string, then we should have caught it in the last
      // iteration and returned success.
      if (OVERFLOW_PINDEX) {
        NS_ASSERTION(false, "Missed a whitespace match");
      }
#endif
      patc = patStr[pindex];
    }
    if (!inWhitespace && IsSpace(patc)) {
      inWhitespace = true;
    } else if (!inWhitespace && !mCaseSensitive && IsUpperCase(c)) {
      c = ToLowerCase(c);
    }

    if (c == CH_SHY) {
      // ignore soft hyphens in the document
      continue;
    }

    if (!mCaseSensitive) {
      switch (c) {
        // treat curly and straight quotes as identical
        case CH_LEFT_SINGLE_QUOTE:
        case CH_RIGHT_SINGLE_QUOTE:
          c = CH_APOSTROPHE;
          break;
        case CH_LEFT_DOUBLE_QUOTE:
        case CH_RIGHT_DOUBLE_QUOTE:
          c = CH_QUOTE;
          break;
      }

      switch (patc) {
        // treat curly and straight quotes as identical
        case CH_LEFT_SINGLE_QUOTE:
        case CH_RIGHT_SINGLE_QUOTE:
          patc = CH_APOSTROPHE;
          break;
        case CH_LEFT_DOUBLE_QUOTE:
        case CH_RIGHT_DOUBLE_QUOTE:
          patc = CH_QUOTE;
          break;
      }
    }

    // a '\n' between CJ characters is ignored
    if (pindex != (mFindBackward ? patLen : 0) && c != patc && !inWhitespace) {
      if (c == '\n' && t2b && IS_CJ_CHAR(prevCharInMatch)) {
        int32_t nindex = findex + incr;
        if (mFindBackward ? (nindex >= 0) : (nindex < fragLen)) {
          if (IS_CJ_CHAR(t2b[nindex])) {
            continue;
          }
        }
      }
    }

    wordBreakPrev = false;
    if (mWordBreaker) {
      if (prevChar == NBSP_CHARCODE)
        prevChar = CHAR_TO_UNICHAR(' ');
      wordBreakPrev = mWordBreaker->BreakInBetween(&prevChar, 1, &c, 1);
    }

    // Compare. Match if we're in whitespace and c is whitespace, or if the
    // characters match and at least one of the following is true:
    // a) we're not matching the entire word
    // b) a match has already been stored
    // c) the previous character is a different "class" than the current character.
    if ((c == patc && (!mWordBreaker || matchAnchorNode || wordBreakPrev)) ||
        (inWhitespace && IsSpace(c)))
    {
      prevCharInMatch = c;
#ifdef DEBUG_FIND
      if (inWhitespace) {
        printf("YES (whitespace)(%d of %d)\n", pindex, patLen);
      } else {
        printf("YES! '%c' == '%c' (%d of %d)\n", c, patc, pindex, patLen);
      }
#endif

      // Save the range anchors if we haven't already:
      if (!matchAnchorNode) {
        matchAnchorNode = mIterNode;
        matchAnchorOffset = findex;
      }

      // Are we done?
      if (DONE_WITH_PINDEX) {
        // Matched the whole string!
#ifdef DEBUG_FIND
        printf("Found a match!\n");
#endif

        // Make the range:
        nsCOMPtr<nsIDOMNode> startParent;
        nsCOMPtr<nsIDOMNode> endParent;

        // Check for word break (if necessary)
        if (mWordBreaker) {
          int32_t nextfindex = findex + incr;

          char16_t nextChar;
          // If still in array boundaries, get nextChar.
          if (mFindBackward ? (nextfindex >= 0) : (nextfindex < fragLen))
            nextChar = (t2b ? t2b[nextfindex] : CHAR_TO_UNICHAR(t1b[nextfindex]));
          // Get next character from the next node.
          else
            nextChar = PeekNextChar(aSearchRange, aStartPoint, aEndPoint);

          if (nextChar == NBSP_CHARCODE)
            nextChar = CHAR_TO_UNICHAR(' ');

          // If a word break isn't there when it needs to be, reset search.
          if (!mWordBreaker->BreakInBetween(&c, 1, &nextChar, 1)) {
            matchAnchorNode = nullptr;
            continue;
          }
        }

        nsCOMPtr<nsIDOMRange> range = new nsRange(tc);
        if (range) {
          int32_t matchStartOffset, matchEndOffset;
          // convert char index to range point:
          int32_t mao = matchAnchorOffset + (mFindBackward ? 1 : 0);
          if (mFindBackward) {
            startParent = do_QueryInterface(tc);
            endParent = matchAnchorNode;
            matchStartOffset = findex;
            matchEndOffset = mao;
          } else {
            startParent = matchAnchorNode;
            endParent = do_QueryInterface(tc);
            matchStartOffset = mao;
            matchEndOffset = findex + 1;
          }
          if (startParent && endParent &&
              IsVisibleNode(startParent) && IsVisibleNode(endParent)) {
            range->SetStart(startParent, matchStartOffset);
            range->SetEnd(endParent, matchEndOffset);
            *aRangeRet = range.get();
            NS_ADDREF(*aRangeRet);
          } else {
            // This match is no good -- invisible or bad range
            startParent = nullptr;
          }
        }

        if (startParent) {
          // If startParent == nullptr, we didn't successfully make range
          // or, we didn't make a range because the start or end node were
          // invisible. Reset the offset to the other end of the found string:
          mIterOffset = findex + (mFindBackward ? 1 : 0);
#ifdef DEBUG_FIND
          printf("mIterOffset = %d, mIterNode = ", mIterOffset);
          DumpNode(mIterNode);
#endif

          ResetAll();
          return NS_OK;
        }
        // This match is no good, continue on in document
        matchAnchorNode = nullptr;
      }

      if (matchAnchorNode) {
        // Not done, but still matching. Advance and loop around for the next
        // characters. But don't advance from a space to a non-space:
        if (!inWhitespace || DONE_WITH_PINDEX ||
            IsSpace(patStr[pindex + incr])) {
          pindex += incr;
          inWhitespace = false;
#ifdef DEBUG_FIND
          printf("Advancing pindex to %d\n", pindex);
#endif
        }

        continue;
      }
    }

#ifdef DEBUG_FIND
    printf("NOT: %c == %c\n", c, patc);
#endif

    // If we didn't match, go back to the beginning of patStr, and set findex
    // back to the next char after we started the current match.
    if (matchAnchorNode) { // we're ending a partial match
      findex = matchAnchorOffset;
      mIterOffset = matchAnchorOffset;
      // +incr will be added to findex when we continue

      // Are we going back to a previous node?
      if (matchAnchorNode != mIterNode) {
        nsCOMPtr<nsIContent> content(do_QueryInterface(matchAnchorNode));
        DebugOnly<nsresult> rv = NS_ERROR_UNEXPECTED;
        if (content) {
          rv = mIterator->PositionAt(content);
        }
        frag = 0;
        NS_ASSERTION(NS_SUCCEEDED(rv), "Text content wasn't nsIContent!");
#ifdef DEBUG_FIND
        printf("Repositioned anchor node\n");
#endif
      }
#ifdef DEBUG_FIND
      printf("Ending a partial match; findex -> %d, mIterOffset -> %d\n",
             findex, mIterOffset);
#endif
    }
    matchAnchorNode = nullptr;
    matchAnchorOffset = 0;
    inWhitespace = false;
    pindex = (mFindBackward ? patLen : 0);
#ifdef DEBUG_FIND
    printf("Setting findex back to %d, pindex to %d\n", findex, pindex);

#endif
  }

  // Out of nodes, and didn't match.
  ResetAll();
  return NS_OK;
}
