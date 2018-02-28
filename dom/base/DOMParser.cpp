/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/DOMParser.h"

#include "nsIDOMDocument.h"
#include "nsNetUtil.h"
#include "nsIStreamListener.h"
#include "nsStringStream.h"
#include "nsIScriptError.h"
#include "nsIScriptSecurityManager.h"
#include "nsCRT.h"
#include "nsStreamUtils.h"
#include "nsContentUtils.h"
#include "nsDOMJSUtils.h"
#include "nsError.h"
#include "nsPIDOMWindow.h"
#include "NullPrincipal.h"
#include "mozilla/LoadInfo.h"
#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/ScriptSettings.h"

using namespace mozilla;
using namespace mozilla::dom;

DOMParser::DOMParser()
  : mAttemptedInit(false)
  , mOriginalPrincipalWasSystem(false)
{
}

DOMParser::~DOMParser()
{
}

// QueryInterface implementation for DOMParser
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(DOMParser)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIDOMParser)
  NS_INTERFACE_MAP_ENTRY(nsIDOMParser)
  NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(DOMParser, mOwner)

NS_IMPL_CYCLE_COLLECTING_ADDREF(DOMParser)
NS_IMPL_CYCLE_COLLECTING_RELEASE(DOMParser)

static const char*
StringFromSupportedType(SupportedType aType)
{
  return SupportedTypeValues::strings[static_cast<int>(aType)].value;
}

already_AddRefed<nsIDocument>
DOMParser::ParseFromString(const nsAString& aStr, SupportedType aType,
                           ErrorResult& rv)
{
  nsCOMPtr<nsIDOMDocument> domDocument;
  rv = ParseFromString(aStr,
                       StringFromSupportedType(aType),
                       getter_AddRefs(domDocument));
  nsCOMPtr<nsIDocument> document(do_QueryInterface(domDocument));
  return document.forget();
}

NS_IMETHODIMP
DOMParser::ParseFromString(const char16_t *str,
                           const char *contentType,
                           nsIDOMDocument **aResult)
{
  NS_ENSURE_ARG(str);
  // Converting a string to an enum value manually is a bit of a pain,
  // so let's just use a helper that takes a content-type string.
  return ParseFromString(nsDependentString(str), contentType, aResult);
}

nsresult
DOMParser::ParseFromString(const nsAString& str,
                           const char *contentType,
                           nsIDOMDocument **aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);

  nsresult rv;

  if (!nsCRT::strcmp(contentType, "text/html")) {
    nsCOMPtr<nsIDOMDocument> domDocument;
    rv = SetUpDocument(DocumentFlavorHTML, getter_AddRefs(domDocument));
    NS_ENSURE_SUCCESS(rv, rv);
    nsCOMPtr<nsIDocument> document = do_QueryInterface(domDocument);

    // Keep the XULXBL state in sync with the XML case.

    if (mOriginalPrincipalWasSystem) {
      document->ForceEnableXULXBL();
    }

    rv = nsContentUtils::ParseDocumentHTML(str, document, false);
    NS_ENSURE_SUCCESS(rv, rv);

    domDocument.forget(aResult);
    return rv;
  }

  nsAutoCString utf8str;
  // Convert from UTF16 to UTF8 using fallible allocations
  if (!AppendUTF16toUTF8(str, utf8str, mozilla::fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  // The new stream holds a reference to the buffer
  nsCOMPtr<nsIInputStream> stream;
  rv = NS_NewByteInputStream(getter_AddRefs(stream),
                             utf8str.get(), utf8str.Length(),
                             NS_ASSIGNMENT_DEPEND);
  if (NS_FAILED(rv))
    return rv;

  return ParseFromStream(stream, "UTF-8", utf8str.Length(), contentType, aResult);
}

already_AddRefed<nsIDocument>
DOMParser::ParseFromBuffer(const Sequence<uint8_t>& aBuf, uint32_t aBufLen,
                           SupportedType aType, ErrorResult& rv)
{
  if (aBufLen > aBuf.Length()) {
    rv.Throw(NS_ERROR_XPC_NOT_ENOUGH_ELEMENTS_IN_ARRAY);
    return nullptr;
  }
  nsCOMPtr<nsIDOMDocument> domDocument;
  rv = DOMParser::ParseFromBuffer(aBuf.Elements(), aBufLen,
                                  StringFromSupportedType(aType),
                                  getter_AddRefs(domDocument));
  nsCOMPtr<nsIDocument> document(do_QueryInterface(domDocument));
  return document.forget();
}

already_AddRefed<nsIDocument>
DOMParser::ParseFromBuffer(const Uint8Array& aBuf, uint32_t aBufLen,
                           SupportedType aType, ErrorResult& rv)
{
  aBuf.ComputeLengthAndData();

  if (aBufLen > aBuf.Length()) {
    rv.Throw(NS_ERROR_XPC_NOT_ENOUGH_ELEMENTS_IN_ARRAY);
    return nullptr;
  }
  nsCOMPtr<nsIDOMDocument> domDocument;
  rv = DOMParser::ParseFromBuffer(aBuf.Data(), aBufLen,
                                    StringFromSupportedType(aType),
                                    getter_AddRefs(domDocument));
  nsCOMPtr<nsIDocument> document(do_QueryInterface(domDocument));
  return document.forget();
}

NS_IMETHODIMP
DOMParser::ParseFromBuffer(const uint8_t *buf,
                           uint32_t bufLen,
                           const char *contentType,
                           nsIDOMDocument **aResult)
{
  NS_ENSURE_ARG_POINTER(buf);
  NS_ENSURE_ARG_POINTER(aResult);

  // The new stream holds a reference to the buffer
  nsCOMPtr<nsIInputStream> stream;
  nsresult rv = NS_NewByteInputStream(getter_AddRefs(stream),
                                      reinterpret_cast<const char *>(buf),
                                      bufLen, NS_ASSIGNMENT_DEPEND);
  if (NS_FAILED(rv))
    return rv;

  return ParseFromStream(stream, nullptr, bufLen, contentType, aResult);
}


already_AddRefed<nsIDocument>
DOMParser::ParseFromStream(nsIInputStream* aStream,
                           const nsAString& aCharset,
                           int32_t aContentLength,
                           SupportedType aType,
                           ErrorResult& rv)
{
  nsCOMPtr<nsIDOMDocument> domDocument;
  rv = DOMParser::ParseFromStream(aStream,
                                  NS_ConvertUTF16toUTF8(aCharset).get(),
                                  aContentLength,
                                  StringFromSupportedType(aType),
                                  getter_AddRefs(domDocument));
  nsCOMPtr<nsIDocument> document(do_QueryInterface(domDocument));
  return document.forget();
}

NS_IMETHODIMP
DOMParser::ParseFromStream(nsIInputStream *stream,
                           const char *charset,
                           int32_t contentLength,
                           const char *contentType,
                           nsIDOMDocument **aResult)
{
  NS_ENSURE_ARG(stream);
  NS_ENSURE_ARG(contentType);
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = nullptr;

  bool svg = nsCRT::strcmp(contentType, "image/svg+xml") == 0;

  // For now, we can only create XML documents.
  //XXXsmaug Should we create an HTMLDocument (in XHTML mode)
  //         for "application/xhtml+xml"?
  if ((nsCRT::strcmp(contentType, "text/xml") != 0) &&
      (nsCRT::strcmp(contentType, "application/xml") != 0) &&
      (nsCRT::strcmp(contentType, "application/xhtml+xml") != 0) &&
      !svg)
    return NS_ERROR_NOT_IMPLEMENTED;

  nsresult rv;

  // Put the nsCOMPtr out here so we hold a ref to the stream as needed
  nsCOMPtr<nsIInputStream> bufferedStream;
  if (!NS_InputStreamIsBuffered(stream)) {
    rv = NS_NewBufferedInputStream(getter_AddRefs(bufferedStream), stream,
                                   4096);
    NS_ENSURE_SUCCESS(rv, rv);

    stream = bufferedStream;
  }

  nsCOMPtr<nsIDOMDocument> domDocument;
  rv = SetUpDocument(svg ? DocumentFlavorSVG : DocumentFlavorLegacyGuess,
                     getter_AddRefs(domDocument));
  NS_ENSURE_SUCCESS(rv, rv);

  // Create a fake channel
  nsCOMPtr<nsIChannel> parserChannel;
  NS_NewInputStreamChannel(getter_AddRefs(parserChannel),
                           mDocumentURI,
                           nullptr, // aStream
                           mPrincipal,
                           nsILoadInfo::SEC_FORCE_INHERIT_PRINCIPAL,
                           nsIContentPolicy::TYPE_OTHER,
                           nsDependentCString(contentType));
  NS_ENSURE_STATE(parserChannel);

  if (charset) {
    parserChannel->SetContentCharset(nsDependentCString(charset));
  }

  // Tell the document to start loading
  nsCOMPtr<nsIStreamListener> listener;

  // Have to pass false for reset here, else the reset will remove
  // our event listener.  Should that listener addition move to later
  // than this call?
  nsCOMPtr<nsIDocument> document(do_QueryInterface(domDocument));
  if (!document) return NS_ERROR_FAILURE;

  // Keep the XULXBL state in sync with the HTML case

  if (mOriginalPrincipalWasSystem) {
    document->ForceEnableXULXBL();
  }

  rv = document->StartDocumentLoad(kLoadAsData, parserChannel,
                                   nullptr, nullptr,
                                   getter_AddRefs(listener),
                                   false);

  if (NS_FAILED(rv) || !listener) {
    return NS_ERROR_FAILURE;
  }

  // Now start pumping data to the listener
  nsresult status;

  rv = listener->OnStartRequest(parserChannel, nullptr);
  if (NS_FAILED(rv))
    parserChannel->Cancel(rv);
  parserChannel->GetStatus(&status);

  if (NS_SUCCEEDED(rv) && NS_SUCCEEDED(status)) {
    rv = listener->OnDataAvailable(parserChannel, nullptr, stream, 0,
                                   contentLength);
    if (NS_FAILED(rv))
      parserChannel->Cancel(rv);
    parserChannel->GetStatus(&status);
  }

  rv = listener->OnStopRequest(parserChannel, nullptr, status);
  // Failure returned from OnStopRequest does not affect the final status of
  // the channel, so we do not need to call Cancel(rv) as we do above.

  if (NS_FAILED(rv)) {
    return NS_ERROR_FAILURE;
  }

  domDocument.swap(*aResult);

  return NS_OK;
}

NS_IMETHODIMP
DOMParser::Init(nsIPrincipal* principal, nsIURI* documentURI,
                nsIURI* baseURI, nsIGlobalObject* aScriptObject)
{
  NS_ENSURE_STATE(!mAttemptedInit);
  mAttemptedInit = true;
  NS_ENSURE_ARG(principal || documentURI);
  mDocumentURI = documentURI;

  if (!mDocumentURI) {
    principal->GetURI(getter_AddRefs(mDocumentURI));
    // If we have the system principal, then we'll just use the null principals
    // uri.
    if (!mDocumentURI && !nsContentUtils::IsSystemPrincipal(principal)) {
      return NS_ERROR_INVALID_ARG;
    }
  }

  mScriptHandlingObject = do_GetWeakReference(aScriptObject);
  mPrincipal = principal;
  nsresult rv;
  if (!mPrincipal) {
    // BUG 1237080 -- in this case we're getting a chrome privilege scripted
    // DOMParser object creation without an explicit principal set.  This is
    // now deprecated.
    nsContentUtils::ReportToConsole(nsIScriptError::warningFlag,
                                    NS_LITERAL_CSTRING("DOM"),
                                    nullptr,
                                    nsContentUtils::eDOM_PROPERTIES,
                                    "ChromeScriptedDOMParserWithoutPrincipal",
                                    nullptr,
                                    0,
                                    documentURI);

    OriginAttributes attrs;
    mPrincipal = BasePrincipal::CreateCodebasePrincipal(mDocumentURI, attrs);
    NS_ENSURE_TRUE(mPrincipal, NS_ERROR_FAILURE);
  } else {
    if (nsContentUtils::IsSystemPrincipal(mPrincipal)) {
      // Don't give DOMParsers the system principal.  Use a null
      // principal instead.
      mOriginalPrincipalWasSystem = true;
      mPrincipal = NullPrincipal::Create();

      if (!mDocumentURI) {
        rv = mPrincipal->GetURI(getter_AddRefs(mDocumentURI));
        NS_ENSURE_SUCCESS(rv, rv);
      }
    }
  }

  mBaseURI = baseURI;

  NS_POSTCONDITION(mPrincipal, "Must have principal");
  NS_POSTCONDITION(mDocumentURI, "Must have document URI");
  return NS_OK;
}

/*static */already_AddRefed<DOMParser>
DOMParser::Constructor(const GlobalObject& aOwner,
                       nsIPrincipal* aPrincipal, nsIURI* aDocumentURI,
                       nsIURI* aBaseURI, ErrorResult& rv)
{
  if (aOwner.CallerType() != CallerType::System) {
    rv.Throw(NS_ERROR_DOM_SECURITY_ERR);
    return nullptr;
  }
  RefPtr<DOMParser> domParser = new DOMParser(aOwner.GetAsSupports());
  rv = domParser->InitInternal(aOwner.GetAsSupports(), aPrincipal, aDocumentURI,
                               aBaseURI);
  if (rv.Failed()) {
    return nullptr;
  }
  return domParser.forget();
}

/*static */already_AddRefed<DOMParser>
DOMParser::Constructor(const GlobalObject& aOwner,
                       ErrorResult& rv)
{
  RefPtr<DOMParser> domParser = new DOMParser(aOwner.GetAsSupports());
  rv = domParser->InitInternal(aOwner.GetAsSupports(),
                               nsContentUtils::SubjectPrincipal(),
                               nullptr, nullptr);
  if (rv.Failed()) {
    return nullptr;
  }
  return domParser.forget();
}

nsresult
DOMParser::InitInternal(nsISupports* aOwner, nsIPrincipal* prin,
                        nsIURI* documentURI, nsIURI* baseURI)
{
  AttemptedInitMarker marker(&mAttemptedInit);
  if (!documentURI) {
    // No explicit documentURI; grab document and base URIs off the window our
    // constructor was called on. Error out if anything untoward happens.

    // Note that this is a behavior change as far as I can tell -- we're now
    // using the base URI and document URI of the window off of which the
    // DOMParser is created, not the window in which parse*() is called.
    // Does that matter?

    // Also note that |cx| matches what GetDocumentFromContext() would return,
    // while GetDocumentFromCaller() gives us the window that the DOMParser()
    // call was made on.

    nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aOwner);
    if (!window) {
      return NS_ERROR_UNEXPECTED;
    }

    baseURI = window->GetDocBaseURI();
    documentURI = window->GetDocumentURI();
    if (!documentURI) {
      return NS_ERROR_UNEXPECTED;
    }
  }

  nsCOMPtr<nsIGlobalObject> scriptglobal = do_QueryInterface(aOwner);
  return Init(prin, documentURI, baseURI, scriptglobal);
}

void
DOMParser::Init(nsIPrincipal* aPrincipal, nsIURI* aDocumentURI,
                nsIURI* aBaseURI, mozilla::ErrorResult& rv)
{
  AttemptedInitMarker marker(&mAttemptedInit);

  nsCOMPtr<nsIPrincipal> principal = aPrincipal;
  if (!principal && !aDocumentURI) {
    principal = nsContentUtils::SubjectPrincipal();
  }

  rv = Init(principal, aDocumentURI, aBaseURI, GetEntryGlobal());
}

nsresult
DOMParser::SetUpDocument(DocumentFlavor aFlavor, nsIDOMDocument** aResult)
{
  // We should really QI to nsIGlobalObject here, but nsDocument gets confused
  // if we pass it a scriptHandlingObject that doesn't QI to
  // nsIScriptGlobalObject, and test_isequalnode.js (an xpcshell test without
  // a window global) breaks. The correct solution is just to wean nsDocument
  // off of nsIScriptGlobalObject, but that's a yak to shave another day.
  nsCOMPtr<nsIScriptGlobalObject> scriptHandlingObject =
    do_QueryReferent(mScriptHandlingObject);
  nsresult rv;
  if (!mPrincipal) {
    NS_ENSURE_TRUE(!mAttemptedInit, NS_ERROR_NOT_INITIALIZED);
    AttemptedInitMarker marker(&mAttemptedInit);

    nsCOMPtr<nsIPrincipal> prin = NullPrincipal::Create();
    rv = Init(prin, nullptr, nullptr, scriptHandlingObject);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  NS_ASSERTION(mPrincipal, "Must have principal by now");
  NS_ASSERTION(mDocumentURI, "Must have document URI by now");

  return NS_NewDOMDocument(aResult, EmptyString(), EmptyString(), nullptr,
                           mDocumentURI, mBaseURI,
                           mPrincipal,
                           true,
                           scriptHandlingObject,
                           aFlavor);
}
