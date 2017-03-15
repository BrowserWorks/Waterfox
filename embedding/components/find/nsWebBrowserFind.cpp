/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsWebBrowserFind.h"

// Only need this for NS_FIND_CONTRACTID,
// else we could use nsIDOMRange.h and nsIFind.h.
#include "nsFind.h"

#include "nsIComponentManager.h"
#include "nsIScriptSecurityManager.h"
#include "nsIInterfaceRequestor.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsPIDOMWindow.h"
#include "nsIURI.h"
#include "nsIDocShell.h"
#include "nsIPresShell.h"
#include "nsPresContext.h"
#include "nsIDocument.h"
#include "nsIDOMDocument.h"
#include "nsISelectionController.h"
#include "nsISelection.h"
#include "nsIFrame.h"
#include "nsITextControlFrame.h"
#include "nsReadableUtils.h"
#include "nsIDOMHTMLElement.h"
#include "nsIDOMHTMLDocument.h"
#include "nsIContent.h"
#include "nsContentCID.h"
#include "nsIServiceManager.h"
#include "nsIObserverService.h"
#include "nsISupportsPrimitives.h"
#include "nsFind.h"
#include "nsError.h"
#include "nsFocusManager.h"
#include "mozilla/Services.h"
#include "mozilla/dom/Element.h"
#include "nsISimpleEnumerator.h"
#include "nsContentUtils.h"

#if DEBUG
#include "nsIWebNavigation.h"
#include "nsXPIDLString.h"
#endif

nsWebBrowserFind::nsWebBrowserFind()
  : mFindBackwards(false)
  , mWrapFind(false)
  , mEntireWord(false)
  , mMatchCase(false)
  , mSearchSubFrames(true)
  , mSearchParentFrames(true)
{
}

nsWebBrowserFind::~nsWebBrowserFind()
{
}

NS_IMPL_ISUPPORTS(nsWebBrowserFind, nsIWebBrowserFind,
                  nsIWebBrowserFindInFrames)

NS_IMETHODIMP
nsWebBrowserFind::FindNext(bool* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = false;

  NS_ENSURE_TRUE(CanFindNext(), NS_ERROR_NOT_INITIALIZED);

  nsresult rv = NS_OK;
  nsCOMPtr<nsPIDOMWindowOuter> searchFrame = do_QueryReferent(mCurrentSearchFrame);
  NS_ENSURE_TRUE(searchFrame, NS_ERROR_NOT_INITIALIZED);

  nsCOMPtr<nsPIDOMWindowOuter> rootFrame = do_QueryReferent(mRootSearchFrame);
  NS_ENSURE_TRUE(rootFrame, NS_ERROR_NOT_INITIALIZED);

  // first, if there's a "cmd_findagain" observer around, check to see if it
  // wants to perform the find again command . If it performs the find again
  // it will return true, in which case we exit ::FindNext() early.
  // Otherwise, nsWebBrowserFind needs to perform the find again command itself
  // this is used by nsTypeAheadFind, which controls find again when it was
  // the last executed find in the current window.
  nsCOMPtr<nsIObserverService> observerSvc =
    mozilla::services::GetObserverService();
  if (observerSvc) {
    nsCOMPtr<nsISupportsInterfacePointer> windowSupportsData =
      do_CreateInstance(NS_SUPPORTS_INTERFACE_POINTER_CONTRACTID, &rv);
    NS_ENSURE_SUCCESS(rv, rv);
    nsCOMPtr<nsISupports> searchWindowSupports = do_QueryInterface(rootFrame);
    windowSupportsData->SetData(searchWindowSupports);
    NS_NAMED_LITERAL_STRING(dnStr, "down");
    NS_NAMED_LITERAL_STRING(upStr, "up");
    observerSvc->NotifyObservers(windowSupportsData,
                                 "nsWebBrowserFind_FindAgain",
                                 mFindBackwards ? upStr.get() : dnStr.get());
    windowSupportsData->GetData(getter_AddRefs(searchWindowSupports));
    // findnext performed if search window data cleared out
    *aResult = searchWindowSupports == nullptr;
    if (*aResult) {
      return NS_OK;
    }
  }

  // next, look in the current frame. If found, return.

  // Beware! This may flush notifications via synchronous
  // ScrollSelectionIntoView.
  rv = SearchInFrame(searchFrame, false, aResult);
  if (NS_FAILED(rv)) {
    return rv;
  }
  if (*aResult) {
    return OnFind(searchFrame); // we are done
  }

  // if we are not searching other frames, return
  if (!mSearchSubFrames && !mSearchParentFrames) {
    return NS_OK;
  }

  nsIDocShell* rootDocShell = rootFrame->GetDocShell();
  if (!rootDocShell) {
    return NS_ERROR_FAILURE;
  }

  int32_t enumDirection = mFindBackwards ? nsIDocShell::ENUMERATE_BACKWARDS :
                                           nsIDocShell::ENUMERATE_FORWARDS;

  nsCOMPtr<nsISimpleEnumerator> docShellEnumerator;
  rv = rootDocShell->GetDocShellEnumerator(nsIDocShellTreeItem::typeAll,
                                           enumDirection,
                                           getter_AddRefs(docShellEnumerator));
  if (NS_FAILED(rv)) {
    return rv;
  }

  // remember where we started
  nsCOMPtr<nsIDocShellTreeItem> startingItem =
    do_QueryInterface(searchFrame->GetDocShell(), &rv);
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsIDocShellTreeItem> curItem;

  // XXX We should avoid searching in frameset documents here.
  // We also need to honour mSearchSubFrames and mSearchParentFrames.
  bool hasMore, doFind = false;
  while (NS_SUCCEEDED(docShellEnumerator->HasMoreElements(&hasMore)) &&
         hasMore) {
    nsCOMPtr<nsISupports> curSupports;
    rv = docShellEnumerator->GetNext(getter_AddRefs(curSupports));
    if (NS_FAILED(rv)) {
      break;
    }
    curItem = do_QueryInterface(curSupports, &rv);
    if (NS_FAILED(rv)) {
      break;
    }

    if (doFind) {
      searchFrame = curItem->GetWindow();
      if (!searchFrame) {
        break;
      }

      OnStartSearchFrame(searchFrame);

      // Beware! This may flush notifications via synchronous
      // ScrollSelectionIntoView.
      rv = SearchInFrame(searchFrame, false, aResult);
      if (NS_FAILED(rv)) {
        return rv;
      }
      if (*aResult) {
        return OnFind(searchFrame); // we are done
      }

      OnEndSearchFrame(searchFrame);
    }

    if (curItem.get() == startingItem.get()) {
      doFind = true; // start looking in frames after this one
    }
  }

  if (!mWrapFind) {
    // remember where we left off
    SetCurrentSearchFrame(searchFrame);
    return NS_OK;
  }

  // From here on, we're wrapping, first through the other frames, then finally
  // from the beginning of the starting frame back to the starting point.

  // because nsISimpleEnumerator is totally lame and isn't resettable, I have to
  // make a new one
  docShellEnumerator = nullptr;
  rv = rootDocShell->GetDocShellEnumerator(nsIDocShellTreeItem::typeAll,
                                           enumDirection,
                                           getter_AddRefs(docShellEnumerator));
  if (NS_FAILED(rv)) {
    return rv;
  }

  while (NS_SUCCEEDED(docShellEnumerator->HasMoreElements(&hasMore)) &&
         hasMore) {
    nsCOMPtr<nsISupports> curSupports;
    rv = docShellEnumerator->GetNext(getter_AddRefs(curSupports));
    if (NS_FAILED(rv)) {
      break;
    }
    curItem = do_QueryInterface(curSupports, &rv);
    if (NS_FAILED(rv)) {
      break;
    }

    searchFrame = curItem->GetWindow();
    if (!searchFrame) {
      rv = NS_ERROR_FAILURE;
      break;
    }

    if (curItem.get() == startingItem.get()) {
      // Beware! This may flush notifications via synchronous
      // ScrollSelectionIntoView.
      rv = SearchInFrame(searchFrame, true, aResult);
      if (NS_FAILED(rv)) {
        return rv;
      }
      if (*aResult) {
        return OnFind(searchFrame); // we are done
      }
      break;
    }

    OnStartSearchFrame(searchFrame);

    // Beware! This may flush notifications via synchronous
    // ScrollSelectionIntoView.
    rv = SearchInFrame(searchFrame, false, aResult);
    if (NS_FAILED(rv)) {
      return rv;
    }
    if (*aResult) {
      return OnFind(searchFrame); // we are done
    }

    OnEndSearchFrame(searchFrame);
  }

  // remember where we left off
  SetCurrentSearchFrame(searchFrame);

  NS_ASSERTION(NS_SUCCEEDED(rv), "Something failed");
  return rv;
}

NS_IMETHODIMP
nsWebBrowserFind::GetSearchString(char16_t** aSearchString)
{
  NS_ENSURE_ARG_POINTER(aSearchString);
  *aSearchString = ToNewUnicode(mSearchString);
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetSearchString(const char16_t* aSearchString)
{
  mSearchString.Assign(aSearchString);
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetFindBackwards(bool* aFindBackwards)
{
  NS_ENSURE_ARG_POINTER(aFindBackwards);
  *aFindBackwards = mFindBackwards;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetFindBackwards(bool aFindBackwards)
{
  mFindBackwards = aFindBackwards;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetWrapFind(bool* aWrapFind)
{
  NS_ENSURE_ARG_POINTER(aWrapFind);
  *aWrapFind = mWrapFind;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetWrapFind(bool aWrapFind)
{
  mWrapFind = aWrapFind;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetEntireWord(bool* aEntireWord)
{
  NS_ENSURE_ARG_POINTER(aEntireWord);
  *aEntireWord = mEntireWord;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetEntireWord(bool aEntireWord)
{
  mEntireWord = aEntireWord;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetMatchCase(bool* aMatchCase)
{
  NS_ENSURE_ARG_POINTER(aMatchCase);
  *aMatchCase = mMatchCase;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetMatchCase(bool aMatchCase)
{
  mMatchCase = aMatchCase;
  return NS_OK;
}

static bool
IsInNativeAnonymousSubtree(nsIContent* aContent)
{
  while (aContent) {
    nsIContent* bindingParent = aContent->GetBindingParent();
    if (bindingParent == aContent) {
      return true;
    }

    aContent = bindingParent;
  }

  return false;
}

void
nsWebBrowserFind::SetSelectionAndScroll(nsPIDOMWindowOuter* aWindow,
                                        nsIDOMRange* aRange)
{
  nsCOMPtr<nsIDocument> doc = aWindow->GetDoc();
  if (!doc) {
    return;
  }

  nsIPresShell* presShell = doc->GetShell();
  if (!presShell) {
    return;
  }

  nsCOMPtr<nsIDOMNode> node;
  aRange->GetStartContainer(getter_AddRefs(node));
  nsCOMPtr<nsIContent> content(do_QueryInterface(node));
  nsIFrame* frame = content->GetPrimaryFrame();
  if (!frame) {
    return;
  }
  nsCOMPtr<nsISelectionController> selCon;
  frame->GetSelectionController(presShell->GetPresContext(),
                                getter_AddRefs(selCon));

  // since the match could be an anonymous textnode inside a
  // <textarea> or text <input>, we need to get the outer frame
  nsITextControlFrame* tcFrame = nullptr;
  for (; content; content = content->GetParent()) {
    if (!IsInNativeAnonymousSubtree(content)) {
      nsIFrame* f = content->GetPrimaryFrame();
      if (!f) {
        return;
      }
      tcFrame = do_QueryFrame(f);
      break;
    }
  }

  nsCOMPtr<nsISelection> selection;

  selCon->SetDisplaySelection(nsISelectionController::SELECTION_ON);
  selCon->GetSelection(nsISelectionController::SELECTION_NORMAL,
                       getter_AddRefs(selection));
  if (selection) {
    selection->RemoveAllRanges();
    selection->AddRange(aRange);

    nsCOMPtr<nsIFocusManager> fm = do_GetService(FOCUSMANAGER_CONTRACTID);
    if (fm) {
      if (tcFrame) {
        nsCOMPtr<nsIDOMElement> newFocusedElement(do_QueryInterface(content));
        fm->SetFocus(newFocusedElement, nsIFocusManager::FLAG_NOSCROLL);
      } else {
        nsCOMPtr<nsIDOMElement> result;
        fm->MoveFocus(aWindow, nullptr, nsIFocusManager::MOVEFOCUS_CARET,
                      nsIFocusManager::FLAG_NOSCROLL, getter_AddRefs(result));
      }
    }

    // Scroll if necessary to make the selection visible:
    // Must be the last thing to do - bug 242056

    // After ScrollSelectionIntoView(), the pending notifications might be
    // flushed and PresShell/PresContext/Frames may be dead. See bug 418470.
    selCon->ScrollSelectionIntoView(
      nsISelectionController::SELECTION_NORMAL,
      nsISelectionController::SELECTION_WHOLE_SELECTION,
      nsISelectionController::SCROLL_CENTER_VERTICALLY |
        nsISelectionController::SCROLL_SYNCHRONOUS);
  }
}

// Adapted from nsTextServicesDocument::GetDocumentContentRootNode
nsresult
nsWebBrowserFind::GetRootNode(nsIDOMDocument* aDomDoc, nsIDOMNode** aNode)
{
  nsresult rv;

  NS_ENSURE_ARG_POINTER(aNode);
  *aNode = 0;

  nsCOMPtr<nsIDOMHTMLDocument> htmlDoc = do_QueryInterface(aDomDoc);
  if (htmlDoc) {
    // For HTML documents, the content root node is the body.
    nsCOMPtr<nsIDOMHTMLElement> bodyElement;
    rv = htmlDoc->GetBody(getter_AddRefs(bodyElement));
    NS_ENSURE_SUCCESS(rv, rv);
    NS_ENSURE_ARG_POINTER(bodyElement);
    bodyElement.forget(aNode);
    return NS_OK;
  }

  // For non-HTML documents, the content root node will be the doc element.
  nsCOMPtr<nsIDOMElement> docElement;
  rv = aDomDoc->GetDocumentElement(getter_AddRefs(docElement));
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ENSURE_ARG_POINTER(docElement);
  docElement.forget(aNode);
  return NS_OK;
}

nsresult
nsWebBrowserFind::SetRangeAroundDocument(nsIDOMRange* aSearchRange,
                                         nsIDOMRange* aStartPt,
                                         nsIDOMRange* aEndPt,
                                         nsIDOMDocument* aDoc)
{
  nsCOMPtr<nsIDOMNode> bodyNode;
  nsresult rv = GetRootNode(aDoc, getter_AddRefs(bodyNode));
  nsCOMPtr<nsIContent> bodyContent(do_QueryInterface(bodyNode));
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ENSURE_ARG_POINTER(bodyContent);

  uint32_t childCount = bodyContent->GetChildCount();

  aSearchRange->SetStart(bodyNode, 0);
  aSearchRange->SetEnd(bodyNode, childCount);

  if (mFindBackwards) {
    aStartPt->SetStart(bodyNode, childCount);
    aStartPt->SetEnd(bodyNode, childCount);
    aEndPt->SetStart(bodyNode, 0);
    aEndPt->SetEnd(bodyNode, 0);
  } else {
    aStartPt->SetStart(bodyNode, 0);
    aStartPt->SetEnd(bodyNode, 0);
    aEndPt->SetStart(bodyNode, childCount);
    aEndPt->SetEnd(bodyNode, childCount);
  }

  return NS_OK;
}

// Set the range to go from the end of the current selection to the end of the
// document (forward), or beginning to beginning (reverse). or around the whole
// document if there's no selection.
nsresult
nsWebBrowserFind::GetSearchLimits(nsIDOMRange* aSearchRange,
                                  nsIDOMRange* aStartPt, nsIDOMRange* aEndPt,
                                  nsIDOMDocument* aDoc, nsISelection* aSel,
                                  bool aWrap)
{
  NS_ENSURE_ARG_POINTER(aSel);

  // There is a selection.
  int32_t count = -1;
  nsresult rv = aSel->GetRangeCount(&count);
  NS_ENSURE_SUCCESS(rv, rv);
  if (count < 1) {
    return SetRangeAroundDocument(aSearchRange, aStartPt, aEndPt, aDoc);
  }

  // Need bodyNode, for the start/end of the document
  nsCOMPtr<nsIDOMNode> bodyNode;
  rv = GetRootNode(aDoc, getter_AddRefs(bodyNode));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIContent> bodyContent(do_QueryInterface(bodyNode));
  NS_ENSURE_ARG_POINTER(bodyContent);

  uint32_t childCount = bodyContent->GetChildCount();

  // There are four possible range endpoints we might use:
  // DocumentStart, SelectionStart, SelectionEnd, DocumentEnd.

  nsCOMPtr<nsIDOMRange> range;
  nsCOMPtr<nsIDOMNode> node;
  int32_t offset;

  // Forward, not wrapping: SelEnd to DocEnd
  if (!mFindBackwards && !aWrap) {
    // This isn't quite right, since the selection's ranges aren't
    // necessarily in order; but they usually will be.
    aSel->GetRangeAt(count - 1, getter_AddRefs(range));
    if (!range) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetEndContainer(getter_AddRefs(node));
    if (!node) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetEndOffset(&offset);

    aSearchRange->SetStart(node, offset);
    aSearchRange->SetEnd(bodyNode, childCount);
    aStartPt->SetStart(node, offset);
    aStartPt->SetEnd(node, offset);
    aEndPt->SetStart(bodyNode, childCount);
    aEndPt->SetEnd(bodyNode, childCount);
  }
  // Backward, not wrapping: DocStart to SelStart
  else if (mFindBackwards && !aWrap) {
    aSel->GetRangeAt(0, getter_AddRefs(range));
    if (!range) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetStartContainer(getter_AddRefs(node));
    if (!node) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetStartOffset(&offset);

    aSearchRange->SetStart(bodyNode, 0);
    aSearchRange->SetEnd(bodyNode, childCount);
    aStartPt->SetStart(node, offset);
    aStartPt->SetEnd(node, offset);
    aEndPt->SetStart(bodyNode, 0);
    aEndPt->SetEnd(bodyNode, 0);
  }
  // Forward, wrapping: DocStart to SelEnd
  else if (!mFindBackwards && aWrap) {
    aSel->GetRangeAt(count - 1, getter_AddRefs(range));
    if (!range) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetEndContainer(getter_AddRefs(node));
    if (!node) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetEndOffset(&offset);

    aSearchRange->SetStart(bodyNode, 0);
    aSearchRange->SetEnd(bodyNode, childCount);
    aStartPt->SetStart(bodyNode, 0);
    aStartPt->SetEnd(bodyNode, 0);
    aEndPt->SetStart(node, offset);
    aEndPt->SetEnd(node, offset);
  }
  // Backward, wrapping: SelStart to DocEnd
  else if (mFindBackwards && aWrap) {
    aSel->GetRangeAt(0, getter_AddRefs(range));
    if (!range) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetStartContainer(getter_AddRefs(node));
    if (!node) {
      return NS_ERROR_UNEXPECTED;
    }
    range->GetStartOffset(&offset);

    aSearchRange->SetStart(bodyNode, 0);
    aSearchRange->SetEnd(bodyNode, childCount);
    aStartPt->SetStart(bodyNode, childCount);
    aStartPt->SetEnd(bodyNode, childCount);
    aEndPt->SetStart(node, offset);
    aEndPt->SetEnd(node, offset);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetSearchFrames(bool* aSearchFrames)
{
  NS_ENSURE_ARG_POINTER(aSearchFrames);
  // this only returns true if we are searching both sub and parent frames.
  // There is ambiguity if the caller has previously set one, but not both of
  // these.
  *aSearchFrames = mSearchSubFrames && mSearchParentFrames;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetSearchFrames(bool aSearchFrames)
{
  mSearchSubFrames = aSearchFrames;
  mSearchParentFrames = aSearchFrames;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetCurrentSearchFrame(mozIDOMWindowProxy** aCurrentSearchFrame)
{
  NS_ENSURE_ARG_POINTER(aCurrentSearchFrame);
  nsCOMPtr<mozIDOMWindowProxy> searchFrame = do_QueryReferent(mCurrentSearchFrame);
  searchFrame.forget(aCurrentSearchFrame);
  return (*aCurrentSearchFrame) ? NS_OK : NS_ERROR_NOT_INITIALIZED;
}

NS_IMETHODIMP
nsWebBrowserFind::SetCurrentSearchFrame(mozIDOMWindowProxy* aCurrentSearchFrame)
{
  // is it ever valid to set this to null?
  NS_ENSURE_ARG(aCurrentSearchFrame);
  mCurrentSearchFrame = do_GetWeakReference(aCurrentSearchFrame);
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetRootSearchFrame(mozIDOMWindowProxy** aRootSearchFrame)
{
  NS_ENSURE_ARG_POINTER(aRootSearchFrame);
  nsCOMPtr<mozIDOMWindowProxy> searchFrame = do_QueryReferent(mRootSearchFrame);
  searchFrame.forget(aRootSearchFrame);
  return (*aRootSearchFrame) ? NS_OK : NS_ERROR_NOT_INITIALIZED;
}

NS_IMETHODIMP
nsWebBrowserFind::SetRootSearchFrame(mozIDOMWindowProxy* aRootSearchFrame)
{
  // is it ever valid to set this to null?
  NS_ENSURE_ARG(aRootSearchFrame);
  mRootSearchFrame = do_GetWeakReference(aRootSearchFrame);
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetSearchSubframes(bool* aSearchSubframes)
{
  NS_ENSURE_ARG_POINTER(aSearchSubframes);
  *aSearchSubframes = mSearchSubFrames;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetSearchSubframes(bool aSearchSubframes)
{
  mSearchSubFrames = aSearchSubframes;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::GetSearchParentFrames(bool* aSearchParentFrames)
{
  NS_ENSURE_ARG_POINTER(aSearchParentFrames);
  *aSearchParentFrames = mSearchParentFrames;
  return NS_OK;
}

NS_IMETHODIMP
nsWebBrowserFind::SetSearchParentFrames(bool aSearchParentFrames)
{
  mSearchParentFrames = aSearchParentFrames;
  return NS_OK;
}

/*
    This method handles finding in a single window (aka frame).

*/
nsresult
nsWebBrowserFind::SearchInFrame(nsPIDOMWindowOuter* aWindow, bool aWrapping,
                                bool* aDidFind)
{
  NS_ENSURE_ARG(aWindow);
  NS_ENSURE_ARG_POINTER(aDidFind);

  *aDidFind = false;

  // Do security check, to ensure that the frame we're searching is
  // acccessible from the frame where the Find is being run.

  // get a uri for the window
  nsCOMPtr<nsIDocument> theDoc = aWindow->GetDoc();
  if (!theDoc) {
    return NS_ERROR_FAILURE;
  }

  if (!nsContentUtils::SubjectPrincipal()->Subsumes(theDoc->NodePrincipal())) {
    return NS_ERROR_DOM_PROP_ACCESS_DENIED;
  }

  nsresult rv;
  nsCOMPtr<nsIFind> find = do_CreateInstance(NS_FIND_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  (void)find->SetCaseSensitive(mMatchCase);
  (void)find->SetFindBackwards(mFindBackwards);

  (void)find->SetEntireWord(mEntireWord);

  // Now make sure the content (for actual finding) and frame (for
  // selection) models are up to date.
  theDoc->FlushPendingNotifications(Flush_Frames);

  nsCOMPtr<nsISelection> sel = GetFrameSelection(aWindow);
  NS_ENSURE_ARG_POINTER(sel);

  nsCOMPtr<nsIDOMRange> searchRange = new nsRange(theDoc);
  NS_ENSURE_ARG_POINTER(searchRange);
  nsCOMPtr<nsIDOMRange> startPt = new nsRange(theDoc);
  NS_ENSURE_ARG_POINTER(startPt);
  nsCOMPtr<nsIDOMRange> endPt = new nsRange(theDoc);
  NS_ENSURE_ARG_POINTER(endPt);

  nsCOMPtr<nsIDOMRange> foundRange;

  nsCOMPtr<nsIDOMDocument> domDoc = do_QueryInterface(theDoc);
  MOZ_ASSERT(domDoc);

  // If !aWrapping, search from selection to end
  if (!aWrapping)
    rv = GetSearchLimits(searchRange, startPt, endPt, domDoc, sel, false);

  // If aWrapping, search the part of the starting frame
  // up to the point where we left off.
  else
    rv = GetSearchLimits(searchRange, startPt, endPt, domDoc, sel, true);

  NS_ENSURE_SUCCESS(rv, rv);

  rv = find->Find(mSearchString.get(), searchRange, startPt, endPt,
                  getter_AddRefs(foundRange));

  if (NS_SUCCEEDED(rv) && foundRange) {
    *aDidFind = true;
    sel->RemoveAllRanges();
    // Beware! This may flush notifications via synchronous
    // ScrollSelectionIntoView.
    SetSelectionAndScroll(aWindow, foundRange);
  }

  return rv;
}

// called when we start searching a frame that is not the initial focussed
// frame. Prepare the frame to be searched. we clear the selection, so that the
// search starts from the top of the frame.
nsresult
nsWebBrowserFind::OnStartSearchFrame(nsPIDOMWindowOuter* aWindow)
{
  return ClearFrameSelection(aWindow);
}

// called when we are done searching a frame and didn't find anything, and about
// about to start searching the next frame.
nsresult
nsWebBrowserFind::OnEndSearchFrame(nsPIDOMWindowOuter* aWindow)
{
  return NS_OK;
}

already_AddRefed<nsISelection>
nsWebBrowserFind::GetFrameSelection(nsPIDOMWindowOuter* aWindow)
{
  nsCOMPtr<nsIDocument> doc = aWindow->GetDoc();
  if (!doc) {
    return nullptr;
  }

  nsIPresShell* presShell = doc->GetShell();
  if (!presShell) {
    return nullptr;
  }

  // text input controls have their independent selection controllers that we
  // must use when they have focus.
  nsPresContext* presContext = presShell->GetPresContext();

  nsCOMPtr<nsPIDOMWindowOuter> focusedWindow;
  nsCOMPtr<nsIContent> focusedContent = nsFocusManager::GetFocusedDescendant(
    aWindow, false, getter_AddRefs(focusedWindow));

  nsIFrame* frame =
    focusedContent ? focusedContent->GetPrimaryFrame() : nullptr;

  nsCOMPtr<nsISelectionController> selCon;
  nsCOMPtr<nsISelection> sel;
  if (frame) {
    frame->GetSelectionController(presContext, getter_AddRefs(selCon));
    selCon->GetSelection(nsISelectionController::SELECTION_NORMAL,
                         getter_AddRefs(sel));
    if (sel) {
      int32_t count = -1;
      sel->GetRangeCount(&count);
      if (count > 0) {
        return sel.forget();
      }
    }
  }

  selCon = do_QueryInterface(presShell);
  selCon->GetSelection(nsISelectionController::SELECTION_NORMAL,
                       getter_AddRefs(sel));
  return sel.forget();
}

nsresult
nsWebBrowserFind::ClearFrameSelection(nsPIDOMWindowOuter* aWindow)
{
  NS_ENSURE_ARG(aWindow);
  nsCOMPtr<nsISelection> selection = GetFrameSelection(aWindow);
  if (selection) {
    selection->RemoveAllRanges();
  }

  return NS_OK;
}

nsresult
nsWebBrowserFind::OnFind(nsPIDOMWindowOuter* aFoundWindow)
{
  SetCurrentSearchFrame(aFoundWindow);

  // We don't want a selection to appear in two frames simultaneously
  nsCOMPtr<nsPIDOMWindowOuter> lastFocusedWindow =
    do_QueryReferent(mLastFocusedWindow);
  if (lastFocusedWindow && lastFocusedWindow != aFoundWindow) {
    ClearFrameSelection(lastFocusedWindow);
  }

  nsCOMPtr<nsIFocusManager> fm = do_GetService(FOCUSMANAGER_CONTRACTID);
  if (fm) {
    // get the containing frame and focus it. For top-level windows, the right
    // window should already be focused.
    nsCOMPtr<nsIDOMElement> frameElement =
      do_QueryInterface(aFoundWindow->GetFrameElementInternal());
    if (frameElement) {
      fm->SetFocus(frameElement, 0);
    }

    mLastFocusedWindow = do_GetWeakReference(aFoundWindow);
  }

  return NS_OK;
}
