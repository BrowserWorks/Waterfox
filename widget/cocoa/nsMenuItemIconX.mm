/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Retrieves and displays icons in native menu items on Mac OS X.
 */

/* exception_defines.h defines 'try' to 'if (true)' which breaks objective-c
   exceptions and produces errors like: error: unexpected '@' in program'.
   If we define __EXCEPTIONS exception_defines.h will avoid doing this.

   See bug 666609 for more information.

   We use <limits> to get the libstdc++ version. */
#include <limits>
#if __GLIBCXX__ <= 20070719
#ifndef __EXCEPTIONS
#define __EXCEPTIONS
#endif
#endif

#include "nsMenuItemIconX.h"
#include "nsObjCExceptions.h"
#include "nsIContent.h"
#include "nsIDocument.h"
#include "nsNameSpaceManager.h"
#include "nsGkAtoms.h"
#include "nsIDOMElement.h"
#include "nsICSSDeclaration.h"
#include "nsIDOMCSSValue.h"
#include "nsIDOMCSSPrimitiveValue.h"
#include "nsIDOMRect.h"
#include "nsThreadUtils.h"
#include "nsToolkit.h"
#include "nsNetUtil.h"
#include "imgLoader.h"
#include "imgRequestProxy.h"
#include "nsMenuItemX.h"
#include "gfxPlatform.h"
#include "imgIContainer.h"
#include "nsCocoaUtils.h"
#include "nsContentUtils.h"
#include "nsIContentPolicy.h"

using mozilla::dom::Element;
using mozilla::gfx::SourceSurface;

static const uint32_t kIconWidth = 16;
static const uint32_t kIconHeight = 16;

typedef decltype(&nsIDOMRect::GetBottom) GetRectSideMethod;

NS_IMPL_ISUPPORTS(nsMenuItemIconX, imgINotificationObserver)

nsMenuItemIconX::nsMenuItemIconX(nsMenuObjectX* aMenuItem,
                                 nsIContent*    aContent,
                                 NSMenuItem*    aNativeMenuItem)
: mContent(aContent)
, mLoadingPrincipal(aContent->NodePrincipal())
, mContentType(nsIContentPolicy::TYPE_INTERNAL_IMAGE)
, mMenuObject(aMenuItem)
, mLoadedIcon(false)
, mSetIcon(false)
, mNativeMenuItem(aNativeMenuItem)
{
  //  printf("Creating icon for menu item %d, menu %d, native item is %d\n", aMenuItem, aMenu, aNativeMenuItem);
}

nsMenuItemIconX::~nsMenuItemIconX()
{
  if (mIconRequest)
    mIconRequest->CancelAndForgetObserver(NS_BINDING_ABORTED);
}

// Called from mMenuObjectX's destructor, to prevent us from outliving it
// (as might otherwise happen if calls to our imgINotificationObserver methods
// are still outstanding).  mMenuObjectX owns our nNativeMenuItem.
void nsMenuItemIconX::Destroy()
{
  if (mIconRequest) {
    mIconRequest->CancelAndForgetObserver(NS_BINDING_ABORTED);
    mIconRequest = nullptr;
  }
  mMenuObject = nullptr;
  mNativeMenuItem = nil;
}

nsresult
nsMenuItemIconX::SetupIcon()
{
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  // Still don't have one, then something is wrong, get out of here.
  if (!mNativeMenuItem) {
    NS_ERROR("No native menu item");
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIURI> iconURI;
  nsresult rv = GetIconURI(getter_AddRefs(iconURI));
  if (NS_FAILED(rv)) {
    // There is no icon for this menu item. An icon might have been set
    // earlier.  Clear it.
    [mNativeMenuItem setImage:nil];

    return NS_OK;
  }

  rv = LoadIcon(iconURI);
  if (NS_FAILED(rv)) {
    // There is no icon for this menu item, as an error occurred while loading it.
    // An icon might have been set earlier or the place holder icon may have
    // been set.  Clear it.
    [mNativeMenuItem setImage:nil];
  }
  return rv;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

static int32_t
GetDOMRectSide(nsIDOMRect* aRect, GetRectSideMethod aMethod)
{
  nsCOMPtr<nsIDOMCSSPrimitiveValue> dimensionValue;
  (aRect->*aMethod)(getter_AddRefs(dimensionValue));
  if (!dimensionValue)
    return -1;

  uint16_t primitiveType;
  nsresult rv = dimensionValue->GetPrimitiveType(&primitiveType);
  if (NS_FAILED(rv) || primitiveType != nsIDOMCSSPrimitiveValue::CSS_PX)
    return -1;

  float dimension = 0;
  rv = dimensionValue->GetFloatValue(nsIDOMCSSPrimitiveValue::CSS_PX,
                                     &dimension);
  if (NS_FAILED(rv))
    return -1;

  return NSToIntRound(dimension);
}

nsresult
nsMenuItemIconX::GetIconURI(nsIURI** aIconURI)
{
  if (!mMenuObject)
    return NS_ERROR_FAILURE;

  // Mac native menu items support having both a checkmark and an icon
  // simultaneously, but this is unheard of in the cross-platform toolkit,
  // seemingly because the win32 theme is unable to cope with both at once.
  // The downside is that it's possible to get a menu item marked with a
  // native checkmark and a checkmark for an icon.  Head off that possibility
  // by pretending that no icon exists if this is a checkable menu item.
  if (mMenuObject->MenuObjectType() == eMenuItemObjectType) {
    nsMenuItemX* menuItem = static_cast<nsMenuItemX*>(mMenuObject);
    if (menuItem->GetMenuItemType() != eRegularMenuItemType)
      return NS_ERROR_FAILURE;
  }

  if (!mContent)
    return NS_ERROR_FAILURE;

  // First, look at the content node's "image" attribute.
  nsAutoString imageURIString;
  bool hasImageAttr = mContent->GetAttr(kNameSpaceID_None,
                                        nsGkAtoms::image,
                                        imageURIString);

  nsresult rv;
  nsCOMPtr<nsIDOMCSSValue> cssValue;
  nsCOMPtr<nsICSSDeclaration> cssStyleDecl;
  nsCOMPtr<nsIDOMCSSPrimitiveValue> primitiveValue;
  uint16_t primitiveType;
  if (!hasImageAttr) {
    // If the content node has no "image" attribute, get the
    // "list-style-image" property from CSS.
    nsCOMPtr<nsIDocument> document = mContent->GetComposedDoc();
    if (!document)
      return NS_ERROR_FAILURE;

    nsCOMPtr<nsPIDOMWindowInner> window = document->GetInnerWindow();
    if (!window)
      return NS_ERROR_FAILURE;

    nsCOMPtr<Element> domElement = do_QueryInterface(mContent);
    if (!domElement)
      return NS_ERROR_FAILURE;

    ErrorResult dummy;
    cssStyleDecl = window->GetComputedStyle(*domElement, EmptyString(), dummy);
    dummy.SuppressException();
    if (!cssStyleDecl)
      return NS_ERROR_FAILURE;

    NS_NAMED_LITERAL_STRING(listStyleImage, "list-style-image");
    rv = cssStyleDecl->GetPropertyCSSValue(listStyleImage,
                                           getter_AddRefs(cssValue));
    if (NS_FAILED(rv)) return rv;

    primitiveValue = do_QueryInterface(cssValue);
    if (!primitiveValue) return NS_ERROR_FAILURE;

    rv = primitiveValue->GetPrimitiveType(&primitiveType);
    if (NS_FAILED(rv)) return rv;
    if (primitiveType != nsIDOMCSSPrimitiveValue::CSS_URI)
      return NS_ERROR_FAILURE;

    rv = primitiveValue->GetStringValue(imageURIString);
    if (NS_FAILED(rv)) return rv;
  } else {
    nsContentUtils::GetContentPolicyTypeForUIImageLoading(mContent,
                                                          getter_AddRefs(mLoadingPrincipal),
                                                          mContentType);
  }

  // Empty the mImageRegionRect initially as the image region CSS could
  // have been changed and now have an error or have been removed since the
  // last GetIconURI call.
  mImageRegionRect.SetEmpty();

  // If this menu item shouldn't have an icon, the string will be empty,
  // and NS_NewURI will fail.
  nsCOMPtr<nsIURI> iconURI;
  rv = NS_NewURI(getter_AddRefs(iconURI), imageURIString);
  if (NS_FAILED(rv)) return rv;

  *aIconURI = iconURI;
  NS_ADDREF(*aIconURI);

  if (!hasImageAttr) {
    // Check if the icon has a specified image region so that it can be
    // cropped appropriately before being displayed.
    NS_NAMED_LITERAL_STRING(imageRegion, "-moz-image-region");
    rv = cssStyleDecl->GetPropertyCSSValue(imageRegion,
                                           getter_AddRefs(cssValue));
    // Just return NS_OK if there if there is a failure due to no
    // moz-image region specified so the whole icon will be drawn anyway.
    if (NS_FAILED(rv)) return NS_OK;

    primitiveValue = do_QueryInterface(cssValue);
    if (!primitiveValue) return NS_OK;

    rv = primitiveValue->GetPrimitiveType(&primitiveType);
    if (NS_FAILED(rv)) return NS_OK;
    if (primitiveType != nsIDOMCSSPrimitiveValue::CSS_RECT)
      return NS_OK;

    nsCOMPtr<nsIDOMRect> imageRegionRect;
    rv = primitiveValue->GetRectValue(getter_AddRefs(imageRegionRect));
    if (NS_FAILED(rv)) return NS_OK;

    if (imageRegionRect) {
      // Return NS_ERROR_FAILURE if the image region is invalid so the image
      // is not drawn, and behavior is similar to XUL menus.
      int32_t bottom = GetDOMRectSide(imageRegionRect, &nsIDOMRect::GetBottom);
      int32_t right = GetDOMRectSide(imageRegionRect, &nsIDOMRect::GetRight);
      int32_t top = GetDOMRectSide(imageRegionRect, &nsIDOMRect::GetTop);
      int32_t left = GetDOMRectSide(imageRegionRect, &nsIDOMRect::GetLeft);

      if (top < 0 || left < 0 || bottom <= top || right <= left)
        return NS_ERROR_FAILURE;

      mImageRegionRect.SetRect(left, top, right - left, bottom - top);
    }
  }

  return NS_OK;
}

nsresult
nsMenuItemIconX::LoadIcon(nsIURI* aIconURI)
{
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  if (mIconRequest) {
    // Another icon request is already in flight.  Kill it.
    mIconRequest->Cancel(NS_BINDING_ABORTED);
    mIconRequest = nullptr;
  }

  mLoadedIcon = false;

  if (!mContent) return NS_ERROR_FAILURE;

  nsCOMPtr<nsIDocument> document = mContent->OwnerDoc();

  nsCOMPtr<nsILoadGroup> loadGroup = document->GetDocumentLoadGroup();
  if (!loadGroup) return NS_ERROR_FAILURE;

  RefPtr<imgLoader> loader = nsContentUtils::GetImgLoaderForDocument(document);
  if (!loader) return NS_ERROR_FAILURE;

  if (!mSetIcon) {
    // Set a completely transparent 16x16 image as the icon on this menu item
    // as a placeholder.  This keeps the menu item text displayed in the same
    // position that it will be displayed when the real icon is loaded, and
    // prevents it from jumping around or looking misaligned.

    static bool sInitializedPlaceholder;
    static NSImage* sPlaceholderIconImage;
    if (!sInitializedPlaceholder) {
      sInitializedPlaceholder = true;

      // Note that we only create the one and reuse it forever, so this is not a leak.
      sPlaceholderIconImage = [[NSImage alloc] initWithSize:NSMakeSize(kIconWidth, kIconHeight)];
    }

    if (!sPlaceholderIconImage) return NS_ERROR_FAILURE;

    if (mNativeMenuItem)
      [mNativeMenuItem setImage:sPlaceholderIconImage];
  }

  nsresult rv = loader->LoadImage(aIconURI, nullptr, nullptr,
                                  mozilla::net::RP_Unset,
                                  mLoadingPrincipal, loadGroup, this,
                                  mContent, document, nsIRequest::LOAD_NORMAL, nullptr,
                                  mContentType, EmptyString(),
                                  /* aUseUrgentStartForChannel */ false,
                                  getter_AddRefs(mIconRequest));
  if (NS_FAILED(rv)) return rv;

  return NS_OK;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}

//
// imgINotificationObserver
//

NS_IMETHODIMP
nsMenuItemIconX::Notify(imgIRequest* aRequest,
                        int32_t aType,
                        const nsIntRect* aData)
{
  if (aType == imgINotificationObserver::LOAD_COMPLETE) {
    // Make sure the image loaded successfully.
    uint32_t status = imgIRequest::STATUS_ERROR;
    if (NS_FAILED(aRequest->GetImageStatus(&status)) ||
        (status & imgIRequest::STATUS_ERROR)) {
      mIconRequest->Cancel(NS_BINDING_ABORTED);
      mIconRequest = nullptr;
      return NS_ERROR_FAILURE;
    }

    nsCOMPtr<imgIContainer> image;
    aRequest->GetImage(getter_AddRefs(image));
    MOZ_ASSERT(image);

    // Ask the image to decode at its intrinsic size.
    int32_t width = 0, height = 0;
    image->GetWidth(&width);
    image->GetHeight(&height);
    image->RequestDecodeForSize(nsIntSize(width, height), imgIContainer::FLAG_NONE);
  }

  if (aType == imgINotificationObserver::FRAME_COMPLETE) {
    return OnFrameComplete(aRequest);
  }

  if (aType == imgINotificationObserver::DECODE_COMPLETE) {
    if (mIconRequest && mIconRequest == aRequest) {
      mIconRequest->Cancel(NS_BINDING_ABORTED);
      mIconRequest = nullptr;
    }
  }

  return NS_OK;
}

nsresult
nsMenuItemIconX::OnFrameComplete(imgIRequest* aRequest)
{
  NS_OBJC_BEGIN_TRY_ABORT_BLOCK_NSRESULT;

  if (aRequest != mIconRequest)
    return NS_ERROR_FAILURE;

  // Only support one frame.
  if (mLoadedIcon)
    return NS_OK;

  if (!mNativeMenuItem)
    return NS_ERROR_FAILURE;

  nsCOMPtr<imgIContainer> imageContainer;
  aRequest->GetImage(getter_AddRefs(imageContainer));
  if (!imageContainer) {
    [mNativeMenuItem setImage:nil];
    return NS_ERROR_FAILURE;
  }

  int32_t origWidth = 0, origHeight = 0;
  imageContainer->GetWidth(&origWidth);
  imageContainer->GetHeight(&origHeight);

  // If the image region is invalid, don't draw the image to almost match
  // the behavior of other platforms.
  if (!mImageRegionRect.IsEmpty() &&
      (mImageRegionRect.XMost() > origWidth ||
       mImageRegionRect.YMost() > origHeight)) {
    [mNativeMenuItem setImage:nil];
    return NS_ERROR_FAILURE;
  }

  if (mImageRegionRect.IsEmpty()) {
    mImageRegionRect.SetRect(0, 0, origWidth, origHeight);
  }

  RefPtr<SourceSurface> surface =
    imageContainer->GetFrame(imgIContainer::FRAME_CURRENT,
                             imgIContainer::FLAG_SYNC_DECODE);
  if (!surface) {
    [mNativeMenuItem setImage:nil];
    return NS_ERROR_FAILURE;
  }

  CGImageRef origImage = NULL;
  nsresult rv = nsCocoaUtils::CreateCGImageFromSurface(surface, &origImage);
  if (NS_FAILED(rv) || !origImage) {
    [mNativeMenuItem setImage:nil];
    return NS_ERROR_FAILURE;
  }

  bool createSubImage = !(mImageRegionRect.x == 0 && mImageRegionRect.y == 0 &&
                            mImageRegionRect.width == origWidth && mImageRegionRect.height == origHeight);

  CGImageRef finalImage = origImage;
  if (createSubImage) {
    // if mImageRegionRect is set using CSS, we need to slice a piece out of the overall
    // image to use as the icon
    finalImage = ::CGImageCreateWithImageInRect(origImage,
                                                ::CGRectMake(mImageRegionRect.x,
                                                mImageRegionRect.y,
                                                mImageRegionRect.width,
                                                mImageRegionRect.height));
    ::CGImageRelease(origImage);
    if (!finalImage) {
      [mNativeMenuItem setImage:nil];
      return NS_ERROR_FAILURE;
    }
  }

  NSImage *newImage = nil;
  rv = nsCocoaUtils::CreateNSImageFromCGImage(finalImage, &newImage);
  if (NS_FAILED(rv) || !newImage) {
    [mNativeMenuItem setImage:nil];
    ::CGImageRelease(finalImage);
    return NS_ERROR_FAILURE;
  }

  [newImage setSize:NSMakeSize(kIconWidth, kIconHeight)];
  [mNativeMenuItem setImage:newImage];

  [newImage release];
  ::CGImageRelease(finalImage);

  mLoadedIcon = true;
  mSetIcon = true;

  if (mMenuObject) {
    mMenuObject->IconUpdated();
  }

  return NS_OK;

  NS_OBJC_END_TRY_ABORT_BLOCK_NSRESULT;
}
