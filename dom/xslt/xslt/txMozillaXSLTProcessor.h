/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef TRANSFRMX_TXMOZILLAXSLTPROCESSOR_H
#define TRANSFRMX_TXMOZILLAXSLTPROCESSOR_H

#include "nsAutoPtr.h"
#include "nsStubMutationObserver.h"
#include "nsIDocumentTransformer.h"
#include "nsIXSLTProcessor.h"
#include "nsIXSLTProcessorPrivate.h"
#include "txExpandedNameMap.h"
#include "txNamespaceMap.h"
#include "nsCycleCollectionParticipant.h"
#include "nsWrapperCache.h"
#include "mozilla/Attributes.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/net/ReferrerPolicy.h"

class nsINode;
class nsIDOMNode;
class nsIURI;
class txStylesheet;
class txResultRecycler;
class txIGlobalParameter;

namespace mozilla {
namespace dom {

class Document;
class DocumentFragment;
class GlobalObject;

} // namespace dom
} // namespace mozilla

/* bacd8ad0-552f-11d3-a9f7-000064657374 */
#define TRANSFORMIIX_XSLT_PROCESSOR_CID   \
{ 0x618ee71d, 0xd7a7, 0x41a1, {0xa3, 0xfb, 0xc2, 0xbe, 0xdc, 0x6a, 0x21, 0x7e} }

#define TRANSFORMIIX_XSLT_PROCESSOR_CONTRACTID \
"@mozilla.org/document-transformer;1?type=xslt"

#define XSLT_MSGS_URL  "chrome://global/locale/xslt/xslt.properties"

/**
 * txMozillaXSLTProcessor is a front-end to the XSLT Processor.
 */
class txMozillaXSLTProcessor final : public nsIXSLTProcessor,
                                     public nsIXSLTProcessorPrivate,
                                     public nsIDocumentTransformer,
                                     public nsStubMutationObserver,
                                     public nsWrapperCache
{
public:
    /**
     * Creates a new txMozillaXSLTProcessor
     */
    txMozillaXSLTProcessor();

    // nsISupports interface
    NS_DECL_CYCLE_COLLECTING_ISUPPORTS
    NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(txMozillaXSLTProcessor,
                                                           nsIXSLTProcessor)

    // nsIXSLTProcessor interface
    NS_DECL_NSIXSLTPROCESSOR

    // nsIXSLTProcessorPrivate interface
    NS_DECL_NSIXSLTPROCESSORPRIVATE

    // nsIDocumentTransformer interface
    NS_IMETHOD SetTransformObserver(nsITransformObserver* aObserver) override;
    NS_IMETHOD LoadStyleSheet(nsIURI* aUri, nsIDocument* aLoaderDocument) override;
    NS_IMETHOD SetSourceContentModel(nsIDocument* aDocument,
                                     const nsTArray<nsCOMPtr<nsIContent>>& aSource) override;
    NS_IMETHOD CancelLoads() override {return NS_OK;}
    NS_IMETHOD AddXSLTParamNamespace(const nsString& aPrefix,
                                     const nsString& aNamespace) override;
    NS_IMETHOD AddXSLTParam(const nsString& aName,
                            const nsString& aNamespace,
                            const nsString& aSelect,
                            const nsString& aValue,
                            nsIDOMNode* aContext) override;

    // nsIMutationObserver interface
    NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATACHANGED
    NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED
    NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED

    // nsWrapperCache
    virtual JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

    // WebIDL
    nsISupports*
    GetParentObject() const
    {
        return mOwner;
    }

    static already_AddRefed<txMozillaXSLTProcessor>
    Constructor(const mozilla::dom::GlobalObject& aGlobal,
                mozilla::ErrorResult& aRv);

    void ImportStylesheet(nsINode& stylesheet,
                          mozilla::ErrorResult& aRv);
    already_AddRefed<mozilla::dom::DocumentFragment>
    TransformToFragment(nsINode& source, nsIDocument& docVal, mozilla::ErrorResult& aRv);
    already_AddRefed<nsIDocument>
    TransformToDocument(nsINode& source, mozilla::ErrorResult& aRv);

    void SetParameter(JSContext* aCx,
                      const nsAString& aNamespaceURI,
                      const nsAString& aLocalName,
                      JS::Handle<JS::Value> aValue,
                      mozilla::ErrorResult& aRv);
    nsIVariant* GetParameter(const nsAString& aNamespaceURI,
                             const nsAString& aLocalName,
                             mozilla::ErrorResult& aRv);
    void RemoveParameter(const nsAString& aNamespaceURI,
                         const nsAString& aLocalName,
                         mozilla::ErrorResult& aRv)
    {
        aRv = RemoveParameter(aNamespaceURI, aLocalName);
    }

    uint32_t Flags(mozilla::dom::SystemCallerGuarantee);
    void SetFlags(uint32_t aFlags, mozilla::dom::SystemCallerGuarantee);

    nsresult setStylesheet(txStylesheet* aStylesheet);
    void reportError(nsresult aResult, const char16_t *aErrorText,
                     const char16_t *aSourceText);

    nsINode *GetSourceContentModel()
    {
        return mSource;
    }

    nsresult TransformToDoc(nsIDOMDocument **aResult,
                            bool aCreateDataDocument);

    bool IsLoadDisabled()
    {
        return (mFlags & DISABLE_ALL_LOADS) != 0;
    }

    static nsresult Startup();
    static void Shutdown();

private:
    explicit txMozillaXSLTProcessor(nsISupports* aOwner);
    /**
     * Default destructor for txMozillaXSLTProcessor
     */
    ~txMozillaXSLTProcessor();

    nsresult DoTransform();
    void notifyError();
    nsresult ensureStylesheet();

    nsCOMPtr<nsISupports> mOwner;

    RefPtr<txStylesheet> mStylesheet;
    nsIDocument* mStylesheetDocument; // weak
    nsCOMPtr<nsIContent> mEmbeddedStylesheetRoot;

    nsCOMPtr<nsINode> mSource;
    nsresult mTransformResult;
    nsresult mCompileResult;
    nsString mErrorText, mSourceText;
    nsCOMPtr<nsITransformObserver> mObserver;
    txOwningExpandedNameMap<txIGlobalParameter> mVariables;
    txNamespaceMap mParamNamespaceMap;
    RefPtr<txResultRecycler> mRecycler;

    uint32_t mFlags;
};

extern nsresult TX_LoadSheet(nsIURI* aUri, txMozillaXSLTProcessor* aProcessor,
                             nsIDocument* aLoaderDocument,
                             mozilla::net::ReferrerPolicy aReferrerPolicy);

extern nsresult TX_CompileStylesheet(nsINode* aNode,
                                     txMozillaXSLTProcessor* aProcessor,
                                     txStylesheet** aStylesheet);

#endif
