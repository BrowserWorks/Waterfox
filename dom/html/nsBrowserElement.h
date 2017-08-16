/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsBrowserElement_h
#define nsBrowserElement_h

#include "mozilla/dom/BindingDeclarations.h"

#include "nsCOMPtr.h"
#include "nsIBrowserElementAPI.h"

class nsFrameLoader;

namespace mozilla {

namespace dom {
struct BrowserElementDownloadOptions;
struct BrowserElementExecuteScriptOptions;
class BrowserElementNextPaintEventCallback;
class DOMRequest;
enum class BrowserFindCaseSensitivity: uint8_t;
enum class BrowserFindDirection: uint8_t;
} // namespace dom

class ErrorResult;

/**
 * A helper class for browser-element frames
 */
class nsBrowserElement
{
public:
  nsBrowserElement() {}
  virtual ~nsBrowserElement() {}

  void SendMouseEvent(const nsAString& aType,
                      uint32_t aX,
                      uint32_t aY,
                      uint32_t aButton,
                      uint32_t aClickCount,
                      uint32_t aModifiers,
                      ErrorResult& aRv);
  void SendTouchEvent(const nsAString& aType,
                      const dom::Sequence<uint32_t>& aIdentifiers,
                      const dom::Sequence<int32_t>& aX,
                      const dom::Sequence<int32_t>& aY,
                      const dom::Sequence<uint32_t>& aRx,
                      const dom::Sequence<uint32_t>& aRy,
                      const dom::Sequence<float>& aRotationAngles,
                      const dom::Sequence<float>& aForces,
                      uint32_t aCount,
                      uint32_t aModifiers,
                      ErrorResult& aRv);
  void GoBack(ErrorResult& aRv);
  void GoForward(ErrorResult& aRv);
  void Reload(bool aHardReload, ErrorResult& aRv);
  void Stop(ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest>
  Download(const nsAString& aUrl,
           const dom::BrowserElementDownloadOptions& options,
           ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest> PurgeHistory(ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest>
  GetScreenshot(uint32_t aWidth,
                uint32_t aHeight,
                const nsAString& aMimeType,
                ErrorResult& aRv);

  void Zoom(float aZoom, ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest> GetCanGoBack(ErrorResult& aRv);
  already_AddRefed<dom::DOMRequest> GetCanGoForward(ErrorResult& aRv);
  already_AddRefed<dom::DOMRequest> GetContentDimensions(ErrorResult& aRv);

  void FindAll(const nsAString& aSearchString, dom::BrowserFindCaseSensitivity aCaseSensitivity,
               ErrorResult& aRv);
  void FindNext(dom::BrowserFindDirection aDirection, ErrorResult& aRv);
  void ClearMatch(ErrorResult& aRv);

  void AddNextPaintListener(dom::BrowserElementNextPaintEventCallback& listener,
                            ErrorResult& aRv);
  void RemoveNextPaintListener(dom::BrowserElementNextPaintEventCallback& listener,
                               ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest> ExecuteScript(const nsAString& aScript,
                                                  const dom::BrowserElementExecuteScriptOptions& aOptions,
                                                  ErrorResult& aRv);

  already_AddRefed<dom::DOMRequest> GetWebManifest(ErrorResult& aRv);

protected:
  NS_IMETHOD_(already_AddRefed<nsFrameLoader>) GetFrameLoader() = 0;

  void InitBrowserElementAPI();
  void DestroyBrowserElementFrameScripts();
  nsCOMPtr<nsIBrowserElementAPI> mBrowserElementAPI;

private:
  bool IsBrowserElementOrThrow(ErrorResult& aRv);
};

} // namespace mozilla

#endif // nsBrowserElement_h
