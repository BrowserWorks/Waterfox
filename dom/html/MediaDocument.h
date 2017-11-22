/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_MediaDocument_h
#define mozilla_dom_MediaDocument_h

#include "mozilla/Attributes.h"
#include "nsHTMLDocument.h"
#include "nsGenericHTMLElement.h"
#include "nsIStringBundle.h"

#define NSMEDIADOCUMENT_PROPERTIES_URI "chrome://global/locale/layout/MediaDocument.properties"

namespace mozilla {
namespace dom {

class MediaDocument : public nsHTMLDocument
{
public:
  MediaDocument();
  virtual ~MediaDocument();

  virtual nsresult Init() override;

  virtual nsresult StartDocumentLoad(const char*         aCommand,
                                     nsIChannel*         aChannel,
                                     nsILoadGroup*       aLoadGroup,
                                     nsISupports*        aContainer,
                                     nsIStreamListener** aDocListener,
                                     bool                aReset = true,
                                     nsIContentSink*     aSink = nullptr) override;

  virtual void SetScriptGlobalObject(nsIScriptGlobalObject* aGlobalObject) override;

  virtual bool WillIgnoreCharsetOverride() override
  {
    return true;
  }

protected:
  void BecomeInteractive();

  virtual nsresult CreateSyntheticDocument();

  friend class MediaDocumentStreamListener;
  nsresult StartLayout();

  void GetFileName(nsAString& aResult, nsIChannel* aChannel);

  nsresult LinkStylesheet(const nsAString& aStylesheet);
  nsresult LinkScript(const nsAString& aScript);

  // |aFormatNames[]| needs to have four elements in the following order:
  // a format name with neither dimension nor file, a format name with
  // filename but w/o dimension, a format name with dimension but w/o filename,
  // a format name with both of them.  For instance, it can have
  // "ImageTitleWithNeitherDimensionsNorFile", "ImageTitleWithoutDimensions",
  // "ImageTitleWithDimesions2",  "ImageTitleWithDimensions2AndFile".
  //
  // Also see MediaDocument.properties if you want to define format names
  // for a new subclass. aWidth and aHeight are pixels for |ImageDocument|,
  // but could be in other units for other 'media', in which case you have to
  // define format names accordingly.
  void UpdateTitleAndCharset(const nsACString&  aTypeStr,
                             nsIChannel* aChannel,
                             const char* const* aFormatNames = sFormatNames,
                             int32_t            aWidth = 0,
                             int32_t            aHeight = 0,
                             const nsAString&   aStatus = EmptyString());

  nsCOMPtr<nsIStringBundle>     mStringBundle;
  static const char* const      sFormatNames[4];

private:
  enum                          {eWithNoInfo, eWithFile, eWithDim, eWithDimAndFile};
  bool                          mDocumentElementInserted;
};


class MediaDocumentStreamListener: public nsIStreamListener
{
protected:
  virtual ~MediaDocumentStreamListener();

public:
  explicit MediaDocumentStreamListener(MediaDocument* aDocument);
  void SetStreamListener(nsIStreamListener *aListener);

  NS_DECL_ISUPPORTS

  NS_DECL_NSIREQUESTOBSERVER

  NS_DECL_NSISTREAMLISTENER

  RefPtr<MediaDocument>      mDocument;
  nsCOMPtr<nsIStreamListener>  mNextStream;
};

} // namespace dom
} // namespace mozilla

#endif /* mozilla_dom_MediaDocument_h */
