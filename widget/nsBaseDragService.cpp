/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsBaseDragService.h"
#include "nsITransferable.h"

#include "nsIServiceManager.h"
#include "nsITransferable.h"
#include "nsSize.h"
#include "nsXPCOM.h"
#include "nsISupportsPrimitives.h"
#include "nsCOMPtr.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsIFrame.h"
#include "nsIDocument.h"
#include "nsIContent.h"
#include "nsIPresShell.h"
#include "nsViewManager.h"
#include "nsIDOMNode.h"
#include "nsIDOMDragEvent.h"
#include "nsISelection.h"
#include "nsISelectionPrivate.h"
#include "nsPresContext.h"
#include "nsIDOMDataTransfer.h"
#include "nsIImageLoadingContent.h"
#include "imgIContainer.h"
#include "imgIRequest.h"
#include "ImageRegion.h"
#include "nsRegion.h"
#include "nsXULPopupManager.h"
#include "nsMenuPopupFrame.h"
#include "SVGImageContext.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/Preferences.h"
#include "mozilla/dom/DataTransferItemList.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/Unused.h"
#include "nsFrameLoader.h"
#include "TabParent.h"

#include "gfxContext.h"
#include "gfxPlatform.h"
#include <algorithm>

using namespace mozilla;
using namespace mozilla::dom;
using namespace mozilla::gfx;
using namespace mozilla::image;

#define DRAGIMAGES_PREF "nglayout.enable_drag_images"

nsBaseDragService::nsBaseDragService()
  : mCanDrop(false), mOnlyChromeDrop(false), mDoingDrag(false),
    mHasImage(false), mUserCancelled(false),
    mDragEventDispatchedToChildProcess(false),
    mDragAction(DRAGDROP_ACTION_NONE),
    mDragActionFromChildProcess(DRAGDROP_ACTION_UNINITIALIZED), mTargetSize(0,0),
    mContentPolicyType(nsIContentPolicy::TYPE_OTHER),
    mSuppressLevel(0), mInputSource(nsIDOMMouseEvent::MOZ_SOURCE_MOUSE)
{
}

nsBaseDragService::~nsBaseDragService()
{
}

NS_IMPL_ISUPPORTS(nsBaseDragService, nsIDragService, nsIDragSession)

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::SetCanDrop(bool aCanDrop)
{
  mCanDrop = aCanDrop;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::GetCanDrop(bool * aCanDrop)
{
  *aCanDrop = mCanDrop;
  return NS_OK;
}
//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::SetOnlyChromeDrop(bool aOnlyChrome)
{
  mOnlyChromeDrop = aOnlyChrome;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::GetOnlyChromeDrop(bool* aOnlyChrome)
{
  *aOnlyChrome = mOnlyChromeDrop;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::SetDragAction(uint32_t anAction)
{
  mDragAction = anAction;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::GetDragAction(uint32_t * anAction)
{
  *anAction = mDragAction;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::SetTargetSize(nsSize aDragTargetSize)
{
  mTargetSize = aDragTargetSize;
  return NS_OK;
}

//---------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::GetTargetSize(nsSize * aDragTargetSize)
{
  *aDragTargetSize = mTargetSize;
  return NS_OK;
}

//-------------------------------------------------------------------------

NS_IMETHODIMP
nsBaseDragService::GetNumDropItems(uint32_t * aNumItems)
{
  *aNumItems = 0;
  return NS_ERROR_FAILURE;
}


//
// GetSourceDocument
//
// Returns the DOM document where the drag was initiated. This will be
// nullptr if the drag began outside of our application.
//
NS_IMETHODIMP
nsBaseDragService::GetSourceDocument(nsIDOMDocument** aSourceDocument)
{
  *aSourceDocument = mSourceDocument.get();
  NS_IF_ADDREF(*aSourceDocument);

  return NS_OK;
}

//
// GetSourceNode
//
// Returns the DOM node where the drag was initiated. This will be
// nullptr if the drag began outside of our application.
//
NS_IMETHODIMP
nsBaseDragService::GetSourceNode(nsIDOMNode** aSourceNode)
{
  *aSourceNode = mSourceNode.get();
  NS_IF_ADDREF(*aSourceNode);

  return NS_OK;
}


//-------------------------------------------------------------------------

NS_IMETHODIMP
nsBaseDragService::GetData(nsITransferable * aTransferable,
                           uint32_t aItemIndex)
{
  return NS_ERROR_FAILURE;
}

//-------------------------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::IsDataFlavorSupported(const char *aDataFlavor,
                                         bool *_retval)
{
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
nsBaseDragService::GetDataTransfer(nsIDOMDataTransfer** aDataTransfer)
{
  *aDataTransfer = mDataTransfer;
  NS_IF_ADDREF(*aDataTransfer);
  return NS_OK;
}

NS_IMETHODIMP
nsBaseDragService::SetDataTransfer(nsIDOMDataTransfer* aDataTransfer)
{
  mDataTransfer = aDataTransfer;
  return NS_OK;
}

//-------------------------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::InvokeDragSession(nsIDOMNode *aDOMNode,
                                     nsIArray* aTransferableArray,
                                     nsIScriptableRegion* aDragRgn,
                                     uint32_t aActionType,
                                     nsContentPolicyType aContentPolicyType =
                                       nsIContentPolicy::TYPE_OTHER)
{
  PROFILER_LABEL_FUNC(js::ProfileEntry::Category::OTHER);

  NS_ENSURE_TRUE(aDOMNode, NS_ERROR_INVALID_ARG);
  NS_ENSURE_TRUE(mSuppressLevel == 0, NS_ERROR_FAILURE);

  // stash the document of the dom node
  aDOMNode->GetOwnerDocument(getter_AddRefs(mSourceDocument));
  mSourceNode = aDOMNode;
  mContentPolicyType = aContentPolicyType;
  mEndDragPoint = LayoutDeviceIntPoint(0, 0);

  // When the mouse goes down, the selection code starts a mouse
  // capture. However, this gets in the way of determining drag
  // feedback for things like trees because the event coordinates
  // are in the wrong coord system, so turn off mouse capture.
  nsIPresShell::ClearMouseCapture(nullptr);

  nsresult rv = InvokeDragSessionImpl(aTransferableArray,
                                      aDragRgn, aActionType);

  if (NS_FAILED(rv)) {
    mSourceNode = nullptr;
    mSourceDocument = nullptr;
  }

  return rv;
}

NS_IMETHODIMP
nsBaseDragService::InvokeDragSessionWithImage(nsIDOMNode* aDOMNode,
                                              nsIArray* aTransferableArray,
                                              nsIScriptableRegion* aRegion,
                                              uint32_t aActionType,
                                              nsIDOMNode* aImage,
                                              int32_t aImageX, int32_t aImageY,
                                              nsIDOMDragEvent* aDragEvent,
                                              nsIDOMDataTransfer* aDataTransfer)
{
  NS_ENSURE_TRUE(aDragEvent, NS_ERROR_NULL_POINTER);
  NS_ENSURE_TRUE(aDataTransfer, NS_ERROR_NULL_POINTER);
  NS_ENSURE_TRUE(mSuppressLevel == 0, NS_ERROR_FAILURE);

  mDataTransfer = aDataTransfer;
  mSelection = nullptr;
  mHasImage = true;
  mDragPopup = nullptr;
  mImage = aImage;
  mImageOffset = CSSIntPoint(aImageX, aImageY);

  aDragEvent->GetScreenX(&mScreenPosition.x);
  aDragEvent->GetScreenY(&mScreenPosition.y);
  aDragEvent->GetMozInputSource(&mInputSource);

  nsresult rv = InvokeDragSession(aDOMNode, aTransferableArray,
                                  aRegion, aActionType,
                                  nsIContentPolicy::TYPE_INTERNAL_IMAGE);

  if (NS_FAILED(rv)) {
    mImage = nullptr;
    mHasImage = false;
    mDataTransfer = nullptr;
  }

  return rv;
}

NS_IMETHODIMP
nsBaseDragService::InvokeDragSessionWithSelection(nsISelection* aSelection,
                                                  nsIArray* aTransferableArray,
                                                  uint32_t aActionType,
                                                  nsIDOMDragEvent* aDragEvent,
                                                  nsIDOMDataTransfer* aDataTransfer)
{
  NS_ENSURE_TRUE(aSelection, NS_ERROR_NULL_POINTER);
  NS_ENSURE_TRUE(aDragEvent, NS_ERROR_NULL_POINTER);
  NS_ENSURE_TRUE(mSuppressLevel == 0, NS_ERROR_FAILURE);

  mDataTransfer = aDataTransfer;
  mSelection = aSelection;
  mHasImage = true;
  mDragPopup = nullptr;
  mImage = nullptr;
  mImageOffset = CSSIntPoint();

  aDragEvent->GetScreenX(&mScreenPosition.x);
  aDragEvent->GetScreenY(&mScreenPosition.y);
  aDragEvent->GetMozInputSource(&mInputSource);

  // just get the focused node from the selection
  // XXXndeakin this should actually be the deepest node that contains both
  // endpoints of the selection
  nsCOMPtr<nsIDOMNode> node;
  aSelection->GetFocusNode(getter_AddRefs(node));

  nsresult rv = InvokeDragSession(node, aTransferableArray,
                                  nullptr, aActionType,
                                  nsIContentPolicy::TYPE_OTHER);

  if (NS_FAILED(rv)) {
    mHasImage = false;
    mSelection = nullptr;
    mDataTransfer = nullptr;
  }

  return rv;
}

//-------------------------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::GetCurrentSession(nsIDragSession ** aSession)
{
  if (!aSession)
    return NS_ERROR_INVALID_ARG;

  // "this" also implements a drag session, so say we are one but only
  // if there is currently a drag going on.
  if (!mSuppressLevel && mDoingDrag) {
    *aSession = this;
    NS_ADDREF(*aSession);      // addRef because we're a "getter"
  }
  else
    *aSession = nullptr;

  return NS_OK;
}

//-------------------------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::StartDragSession()
{
  if (mDoingDrag) {
    return NS_ERROR_FAILURE;
  }
  mDoingDrag = true;
  // By default dispatch drop also to content.
  mOnlyChromeDrop = false;

  return NS_OK;
}

void
nsBaseDragService::OpenDragPopup()
{
  if (mDragPopup) {
    nsXULPopupManager* pm = nsXULPopupManager::GetInstance();
    if (pm) {
      pm->ShowPopupAtScreen(mDragPopup, mScreenPosition.x - mImageOffset.x,
                            mScreenPosition.y - mImageOffset.y, false, nullptr);
    }
  }
}

int32_t
nsBaseDragService::TakeChildProcessDragAction()
{
  // If the last event was dispatched to the child process, use the drag action
  // assigned from it instead and return it. DRAGDROP_ACTION_UNINITIALIZED is
  // returned otherwise.
  int32_t retval = DRAGDROP_ACTION_UNINITIALIZED;
  if (TakeDragEventDispatchedToChildProcess() &&
      mDragActionFromChildProcess != DRAGDROP_ACTION_UNINITIALIZED) {
    retval = mDragActionFromChildProcess;
  }

  return retval;
}

//-------------------------------------------------------------------------
NS_IMETHODIMP
nsBaseDragService::EndDragSession(bool aDoneDrag)
{
  if (!mDoingDrag) {
    return NS_ERROR_FAILURE;
  }

  if (aDoneDrag && !mSuppressLevel) {
    FireDragEventAtSource(eDragEnd);
  }

  if (mDragPopup) {
    nsXULPopupManager* pm = nsXULPopupManager::GetInstance();
    if (pm) {
      pm->HidePopup(mDragPopup, false, true, false, false);
    }
  }

  for (uint32_t i = 0; i < mChildProcesses.Length(); ++i) {
    mozilla::Unused << mChildProcesses[i]->SendEndDragSession(aDoneDrag,
                                                              mUserCancelled,
                                                              mEndDragPoint);
  }
  mChildProcesses.Clear();

  // mDataTransfer and the items it owns are going to die anyway, but we
  // explicitly deref the contained data here so that we don't have to wait for
  // CC to reclaim the memory.
  if (XRE_IsParentProcess()) {
    DiscardInternalTransferData();
  }

  mDoingDrag = false;
  mCanDrop = false;

  // release the source we've been holding on to.
  mSourceDocument = nullptr;
  mSourceNode = nullptr;
  mSelection = nullptr;
  mDataTransfer = nullptr;
  mHasImage = false;
  mUserCancelled = false;
  mDragPopup = nullptr;
  mImage = nullptr;
  mImageOffset = CSSIntPoint();
  mScreenPosition = CSSIntPoint();
  mEndDragPoint = LayoutDeviceIntPoint(0, 0);
  mInputSource = nsIDOMMouseEvent::MOZ_SOURCE_MOUSE;

  return NS_OK;
}

void
nsBaseDragService::DiscardInternalTransferData()
{
  if (mDataTransfer && mSourceNode) {
    MOZ_ASSERT(!!DataTransfer::Cast(mDataTransfer));

    DataTransferItemList* items = DataTransfer::Cast(mDataTransfer)->Items();
    for (size_t i = 0; i < items->Length(); i++) {
      bool found;
      DataTransferItem* item = items->IndexedGetter(i, found);

      // Non-OTHER items may still be needed by JS. Skip them.
      if (!found || item->Kind() != DataTransferItem::KIND_OTHER) {
        continue;
      }

      nsCOMPtr<nsIVariant> variant = item->DataNoSecurityCheck();
      nsCOMPtr<nsIWritableVariant> writable = do_QueryInterface(variant);

      if (writable) {
        writable->SetAsEmpty();
      }
    }
  }
}

NS_IMETHODIMP
nsBaseDragService::FireDragEventAtSource(EventMessage aEventMessage)
{
  if (mSourceNode && !mSuppressLevel) {
    nsCOMPtr<nsIDocument> doc = do_QueryInterface(mSourceDocument);
    if (doc) {
      nsCOMPtr<nsIPresShell> presShell = doc->GetShell();
      if (presShell) {
        nsEventStatus status = nsEventStatus_eIgnore;
        WidgetDragEvent event(true, aEventMessage, nullptr);
        event.inputSource = mInputSource;
        if (aEventMessage == eDragEnd) {
          event.mRefPoint = mEndDragPoint;
          event.mUserCancelled = mUserCancelled;
        }

        // Send the drag event to APZ, which needs to know about them to be
        // able to accurately detect the end of a drag gesture.
        if (nsPresContext* presContext = presShell->GetPresContext()) {
          if (nsCOMPtr<nsIWidget> widget = presContext->GetRootWidget()) {
            widget->DispatchEventToAPZOnly(&event);
          }
        }

        nsCOMPtr<nsIContent> content = do_QueryInterface(mSourceNode);
        return presShell->HandleDOMEventWithTarget(content, &event, &status);
      }
    }
  }

  return NS_OK;
}

/* This is used by Windows and Mac to update the position of a popup being
 * used as a drag image during the drag. This isn't used on GTK as it manages
 * the drag popup itself.
 */
NS_IMETHODIMP
nsBaseDragService::DragMoved(int32_t aX, int32_t aY)
{
  if (mDragPopup) {
    nsIFrame* frame = mDragPopup->GetPrimaryFrame();
    if (frame && frame->GetType() == nsGkAtoms::menuPopupFrame) {
      CSSIntPoint cssPos = RoundedToInt(LayoutDeviceIntPoint(aX, aY) /
          frame->PresContext()->CSSToDevPixelScale()) - mImageOffset;
      (static_cast<nsMenuPopupFrame *>(frame))->MoveTo(cssPos, true);
    }
  }

  return NS_OK;
}

static nsIPresShell*
GetPresShellForContent(nsIDOMNode* aDOMNode)
{
  nsCOMPtr<nsIContent> content = do_QueryInterface(aDOMNode);
  if (!content)
    return nullptr;

  nsCOMPtr<nsIDocument> document = content->GetUncomposedDoc();
  if (document) {
    document->FlushPendingNotifications(Flush_Display);

    return document->GetShell();
  }

  return nullptr;
}

nsresult
nsBaseDragService::DrawDrag(nsIDOMNode* aDOMNode,
                            nsIScriptableRegion* aRegion,
                            CSSIntPoint aScreenPosition,
                            LayoutDeviceIntRect* aScreenDragRect,
                            RefPtr<SourceSurface>* aSurface,
                            nsPresContext** aPresContext)
{
  *aSurface = nullptr;
  *aPresContext = nullptr;

  // use a default size, in case of an error.
  aScreenDragRect->MoveTo(aScreenPosition.x - mImageOffset.x,
                          aScreenPosition.y - mImageOffset.y);
  aScreenDragRect->SizeTo(1, 1);

  // if a drag image was specified, use that, otherwise, use the source node
  nsCOMPtr<nsIDOMNode> dragNode = mImage ? mImage.get() : aDOMNode;

  // get the presshell for the node being dragged. If the drag image is not in
  // a document or has no frame, get the presshell from the source drag node
  nsIPresShell* presShell = GetPresShellForContent(dragNode);
  if (!presShell && mImage)
    presShell = GetPresShellForContent(aDOMNode);
  if (!presShell)
    return NS_ERROR_FAILURE;

  *aPresContext = presShell->GetPresContext();

  nsCOMPtr<nsIFrameLoaderOwner> flo = do_QueryInterface(dragNode);
  if (flo) {
    RefPtr<nsFrameLoader> fl = flo->GetFrameLoader();
    if (fl) {
      mozilla::dom::TabParent* tp =
        static_cast<mozilla::dom::TabParent*>(fl->GetRemoteBrowser());
      if (tp && tp->TakeDragVisualization(*aSurface, aScreenDragRect)) {
        if (mImage) {
          // Just clear the surface if chrome has overridden it with an image.
          *aSurface = nullptr;
        }

        return NS_OK;
      }
    }
  }

  // convert mouse position to dev pixels of the prescontext
  CSSIntPoint screenPosition(aScreenPosition);
  screenPosition.x -= mImageOffset.x;
  screenPosition.y -= mImageOffset.y;
  LayoutDeviceIntPoint screenPoint = ConvertToUnscaledDevPixels(*aPresContext, screenPosition);
  aScreenDragRect->x = screenPoint.x;
  aScreenDragRect->y = screenPoint.y;

  // check if drag images are disabled
  bool enableDragImages = Preferences::GetBool(DRAGIMAGES_PREF, true);

  // didn't want an image, so just set the screen rectangle to the frame size
  if (!enableDragImages || !mHasImage) {
    // if a region was specified, set the screen rectangle to the area that
    // the region occupies
    nsIntRect dragRect;
    if (aRegion) {
      // the region's coordinates are relative to the root frame
      aRegion->GetBoundingBox(&dragRect.x, &dragRect.y, &dragRect.width, &dragRect.height);

      nsIFrame* rootFrame = presShell->GetRootFrame();
      nsIntRect screenRect = rootFrame->GetScreenRect();
      dragRect.MoveBy(screenRect.TopLeft());
    }
    else {
      // otherwise, there was no region so just set the rectangle to
      // the size of the primary frame of the content.
      nsCOMPtr<nsIContent> content = do_QueryInterface(dragNode);
      nsIFrame* frame = content->GetPrimaryFrame();
      if (frame) {
        dragRect = frame->GetScreenRect();
      }
    }

    dragRect = ToAppUnits(dragRect, nsPresContext::AppUnitsPerCSSPixel()).
                          ToOutsidePixels((*aPresContext)->AppUnitsPerDevPixel());
    aScreenDragRect->SizeTo(dragRect.width, dragRect.height);
    return NS_OK;
  }

  // draw the image for selections
  if (mSelection) {
    LayoutDeviceIntPoint pnt(aScreenDragRect->TopLeft());
    *aSurface = presShell->RenderSelection(mSelection, pnt, aScreenDragRect,
        mImage ? 0 : nsIPresShell::RENDER_AUTO_SCALE);
    return NS_OK;
  }

  // if a custom image was specified, check if it is an image node and draw
  // using the source rather than the displayed image. But if mImage isn't
  // an image or canvas, fall through to RenderNode below.
  if (mImage) {
    nsCOMPtr<nsIContent> content = do_QueryInterface(dragNode);
    HTMLCanvasElement *canvas = HTMLCanvasElement::FromContentOrNull(content);
    if (canvas) {
      return DrawDragForImage(*aPresContext, nullptr, canvas, aScreenDragRect, aSurface);
    }

    nsCOMPtr<nsIImageLoadingContent> imageLoader = do_QueryInterface(dragNode);
    // for image nodes, create the drag image from the actual image data
    if (imageLoader) {
      return DrawDragForImage(*aPresContext, imageLoader, nullptr, aScreenDragRect, aSurface);
    }

    // If the image is a popup, use that as the image. This allows custom drag
    // images that can change during the drag, but means that any platform
    // default image handling won't occur.
    // XXXndeakin this should be chrome-only

    nsIFrame* frame = content->GetPrimaryFrame();
    if (frame && frame->GetType() == nsGkAtoms::menuPopupFrame) {
      mDragPopup = content;
    }
  }

  if (!mDragPopup) {
    // otherwise, just draw the node
    nsIntRegion clipRegion;
    uint32_t renderFlags = mImage ? 0 : nsIPresShell::RENDER_AUTO_SCALE;
    if (aRegion) {
      aRegion->GetRegion(&clipRegion);
    }

    if (renderFlags) {
      nsCOMPtr<nsIDOMNode> child;
      nsCOMPtr<nsIDOMNodeList> childList;
      uint32_t length;
      uint32_t count = 0;
      nsAutoString childNodeName;

      if (NS_SUCCEEDED(dragNode->GetChildNodes(getter_AddRefs(childList))) &&
          NS_SUCCEEDED(childList->GetLength(&length))) {
        // check every childnode for being a img-tag
        while (count < length) {
          if (NS_FAILED(childList->Item(count, getter_AddRefs(child))) ||
              NS_FAILED(child->GetNodeName(childNodeName))) {
            break;
          }
          // here the node is checked for being a img-tag
          if (childNodeName.LowerCaseEqualsLiteral("img")) {
            // if the dragnnode contains a image, set RENDER_IS_IMAGE flag
            renderFlags = renderFlags | nsIPresShell::RENDER_IS_IMAGE;
            break;
          }
          count++;
        }
      }
    }
    LayoutDeviceIntPoint pnt(aScreenDragRect->TopLeft());
    *aSurface = presShell->RenderNode(dragNode, aRegion ? &clipRegion : nullptr,
                                      pnt, aScreenDragRect,
                                      renderFlags);
  }

  // If an image was specified, reset the position from the offset that was supplied.
  if (mImage) {
    aScreenDragRect->x = screenPoint.x;
    aScreenDragRect->y = screenPoint.y;
  }

  return NS_OK;
}

nsresult
nsBaseDragService::DrawDragForImage(nsPresContext* aPresContext,
                                    nsIImageLoadingContent* aImageLoader,
                                    HTMLCanvasElement* aCanvas,
                                    LayoutDeviceIntRect* aScreenDragRect,
                                    RefPtr<SourceSurface>* aSurface)
{
  nsCOMPtr<imgIContainer> imgContainer;
  if (aImageLoader) {
    nsCOMPtr<imgIRequest> imgRequest;
    nsresult rv = aImageLoader->GetRequest(nsIImageLoadingContent::CURRENT_REQUEST,
                                          getter_AddRefs(imgRequest));
    NS_ENSURE_SUCCESS(rv, rv);
    if (!imgRequest)
      return NS_ERROR_NOT_AVAILABLE;

    rv = imgRequest->GetImage(getter_AddRefs(imgContainer));
    NS_ENSURE_SUCCESS(rv, rv);
    if (!imgContainer)
      return NS_ERROR_NOT_AVAILABLE;

    // use the size of the image as the size of the drag image
    int32_t imageWidth, imageHeight;
    rv = imgContainer->GetWidth(&imageWidth);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = imgContainer->GetHeight(&imageHeight);
    NS_ENSURE_SUCCESS(rv, rv);

    aScreenDragRect->width = aPresContext->CSSPixelsToDevPixels(imageWidth);
    aScreenDragRect->height = aPresContext->CSSPixelsToDevPixels(imageHeight);
  }
  else {
    // XXX The canvas size should be converted to dev pixels.
    NS_ASSERTION(aCanvas, "both image and canvas are null");
    nsIntSize sz = aCanvas->GetSize();
    aScreenDragRect->width = sz.width;
    aScreenDragRect->height = sz.height;
  }

  nsIntSize destSize;
  destSize.width = aScreenDragRect->width;
  destSize.height = aScreenDragRect->height;
  if (destSize.width == 0 || destSize.height == 0)
    return NS_ERROR_FAILURE;

  nsresult result = NS_OK;
  if (aImageLoader) {
    RefPtr<DrawTarget> dt =
      gfxPlatform::GetPlatform()->
        CreateOffscreenContentDrawTarget(destSize,
                                         SurfaceFormat::B8G8R8A8);
    if (!dt || !dt->IsValid())
      return NS_ERROR_FAILURE;

    RefPtr<gfxContext> ctx = gfxContext::CreateOrNull(dt);
    if (!ctx)
      return NS_ERROR_FAILURE;

    DrawResult res =
      imgContainer->Draw(ctx, destSize, ImageRegion::Create(destSize),
                         imgIContainer::FRAME_CURRENT,
                         SamplingFilter::GOOD, /* no SVGImageContext */ Nothing(),
                         imgIContainer::FLAG_SYNC_DECODE);
    if (res == DrawResult::BAD_IMAGE || res == DrawResult::BAD_ARGS) {
      return NS_ERROR_FAILURE;
    }
    *aSurface = dt->Snapshot();
  } else {
    *aSurface = aCanvas->GetSurfaceSnapshot();
  }

  return result;
}

LayoutDeviceIntPoint
nsBaseDragService::ConvertToUnscaledDevPixels(nsPresContext* aPresContext,
                                              CSSIntPoint aScreenPosition)
{
  int32_t adj = aPresContext->DeviceContext()->AppUnitsPerDevPixelAtUnitFullZoom();
  return LayoutDeviceIntPoint(nsPresContext::CSSPixelsToAppUnits(aScreenPosition.x) / adj,
                              nsPresContext::CSSPixelsToAppUnits(aScreenPosition.y) / adj);
}

NS_IMETHODIMP
nsBaseDragService::Suppress()
{
  EndDragSession(false);
  ++mSuppressLevel;
  return NS_OK;
}

NS_IMETHODIMP
nsBaseDragService::Unsuppress()
{
  --mSuppressLevel;
  return NS_OK;
}

NS_IMETHODIMP
nsBaseDragService::UserCancelled()
{
  mUserCancelled = true;
  return NS_OK;
}

NS_IMETHODIMP
nsBaseDragService::UpdateDragEffect()
{
  mDragActionFromChildProcess = mDragAction;
  return NS_OK;
}

NS_IMETHODIMP
nsBaseDragService::DragEventDispatchedToChildProcess()
{
  mDragEventDispatchedToChildProcess = true;
  return NS_OK;
}

bool
nsBaseDragService::MaybeAddChildProcess(mozilla::dom::ContentParent* aChild)
{
  if (!mChildProcesses.Contains(aChild)) {
    mChildProcesses.AppendElement(aChild);
    return true;
  }
  return false;
}
