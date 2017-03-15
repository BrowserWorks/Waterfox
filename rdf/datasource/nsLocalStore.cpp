/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set cindent tabstop=4 expandtab shiftwidth=4: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*

  Implementation for the local store

 */

#include "nsNetUtil.h"
#include "nsIFile.h"
#include "nsIURI.h"
#include "nsIIOService.h"
#include "nsIOutputStream.h"
#include "nsIComponentManager.h"
#include "nsILocalStore.h"
#include "nsIRDFDataSource.h"
#include "nsIRDFRemoteDataSource.h"
#include "nsIRDFService.h"
#include "nsIServiceManager.h"
#include "nsRDFCID.h"
#include "nsXPIDLString.h"
#include "plstr.h"
#include "rdf.h"
#include "nsCOMPtr.h"
#include "nsWeakPtr.h"
#include "nsAppDirectoryServiceDefs.h"
#include "nsIObserver.h"
#include "nsIObserverService.h"
#include "nsWeakReference.h"
#include "nsCRTGlue.h"
#include "nsCRT.h"
#include "nsEnumeratorUtils.h"
#include "nsCycleCollectionParticipant.h"

////////////////////////////////////////////////////////////////////////

class LocalStoreImpl : public nsILocalStore,
                       public nsIRDFDataSource,
                       public nsIRDFRemoteDataSource,
                       public nsIObserver,
                       public nsSupportsWeakReference
{
protected:
    nsCOMPtr<nsIRDFDataSource> mInner;

    LocalStoreImpl();
    virtual ~LocalStoreImpl();
    nsresult Init();
    nsresult CreateLocalStore(nsIFile* aFile);
    nsresult LoadData();

    friend nsresult
    NS_NewLocalStore(nsISupports* aOuter, REFNSIID aIID, void** aResult);

    nsCOMPtr<nsIRDFService>    mRDFService;

public:
    // nsISupports interface
    NS_DECL_CYCLE_COLLECTING_ISUPPORTS
    NS_DECL_CYCLE_COLLECTION_CLASS_AMBIGUOUS(LocalStoreImpl, nsILocalStore)

    // nsILocalStore interface

    // nsIRDFDataSource interface. Most of these are just delegated to
    // the inner, in-memory datasource.
    NS_IMETHOD GetURI(char* *aURI) override;

    NS_IMETHOD GetSource(nsIRDFResource* aProperty,
                         nsIRDFNode* aTarget,
                         bool aTruthValue,
                         nsIRDFResource** aSource) override {
        return mInner->GetSource(aProperty, aTarget, aTruthValue, aSource);
    }

    NS_IMETHOD GetSources(nsIRDFResource* aProperty,
                          nsIRDFNode* aTarget,
                          bool aTruthValue,
                          nsISimpleEnumerator** aSources) override {
        return mInner->GetSources(aProperty, aTarget, aTruthValue, aSources);
    }

    NS_IMETHOD GetTarget(nsIRDFResource* aSource,
                         nsIRDFResource* aProperty,
                         bool aTruthValue,
                         nsIRDFNode** aTarget) override {
        return mInner->GetTarget(aSource, aProperty, aTruthValue, aTarget);
    }

    NS_IMETHOD GetTargets(nsIRDFResource* aSource,
                          nsIRDFResource* aProperty,
                          bool aTruthValue,
                          nsISimpleEnumerator** aTargets) override {
        return mInner->GetTargets(aSource, aProperty, aTruthValue, aTargets);
    }

    NS_IMETHOD Assert(nsIRDFResource* aSource, 
                      nsIRDFResource* aProperty, 
                      nsIRDFNode* aTarget,
                      bool aTruthValue) override {
        return mInner->Assert(aSource, aProperty, aTarget, aTruthValue);
    }

    NS_IMETHOD Unassert(nsIRDFResource* aSource,
                        nsIRDFResource* aProperty,
                        nsIRDFNode* aTarget) override {
        return mInner->Unassert(aSource, aProperty, aTarget);
    }

    NS_IMETHOD Change(nsIRDFResource* aSource,
                      nsIRDFResource* aProperty,
                      nsIRDFNode* aOldTarget,
                      nsIRDFNode* aNewTarget) override {
        return mInner->Change(aSource, aProperty, aOldTarget, aNewTarget);
    }

    NS_IMETHOD Move(nsIRDFResource* aOldSource,
                    nsIRDFResource* aNewSource,
                    nsIRDFResource* aProperty,
                    nsIRDFNode* aTarget) override {
        return mInner->Move(aOldSource, aNewSource, aProperty, aTarget);
    }

    NS_IMETHOD HasAssertion(nsIRDFResource* aSource,
                            nsIRDFResource* aProperty,
                            nsIRDFNode* aTarget,
                            bool aTruthValue,
                            bool* hasAssertion) override {
        return mInner->HasAssertion(aSource, aProperty, aTarget, aTruthValue, hasAssertion);
    }

    NS_IMETHOD AddObserver(nsIRDFObserver* aObserver) override {
        return NS_ERROR_NOT_IMPLEMENTED;
    }

    NS_IMETHOD RemoveObserver(nsIRDFObserver* aObserver) override {
        return NS_ERROR_NOT_IMPLEMENTED;
    }

    NS_IMETHOD HasArcIn(nsIRDFNode *aNode, nsIRDFResource *aArc, bool *_retval) override {
        return mInner->HasArcIn(aNode, aArc, _retval);
    }

    NS_IMETHOD HasArcOut(nsIRDFResource *aSource, nsIRDFResource *aArc, bool *_retval) override {
        return mInner->HasArcOut(aSource, aArc, _retval);
    }

    NS_IMETHOD ArcLabelsIn(nsIRDFNode* aNode,
                           nsISimpleEnumerator** aLabels) override {
        return mInner->ArcLabelsIn(aNode, aLabels);
    }

    NS_IMETHOD ArcLabelsOut(nsIRDFResource* aSource,
                            nsISimpleEnumerator** aLabels) override {
        return mInner->ArcLabelsOut(aSource, aLabels);
    }

    NS_IMETHOD GetAllResources(nsISimpleEnumerator** aResult) override {
        return mInner->GetAllResources(aResult);
    }

    NS_IMETHOD GetAllCmds(nsIRDFResource* aSource,
                              nsISimpleEnumerator/*<nsIRDFResource>*/** aCommands) override;

    NS_IMETHOD IsCommandEnabled(nsISupports* aSources,
                                nsIRDFResource*   aCommand,
                                nsISupports* aArguments,
                                bool* aResult) override;

    NS_IMETHOD DoCommand(nsISupports* aSources,
                         nsIRDFResource*   aCommand,
                         nsISupports* aArguments) override;

    NS_IMETHOD BeginUpdateBatch() override {
        return mInner->BeginUpdateBatch();
    }
                                                                                
    NS_IMETHOD EndUpdateBatch() override {
        return mInner->EndUpdateBatch();
    }

    NS_IMETHOD GetLoaded(bool* _result) override;
    NS_IMETHOD Init(const char *uri) override;
    NS_IMETHOD Flush() override;
    NS_IMETHOD FlushTo(const char *aURI) override;
    NS_IMETHOD Refresh(bool sync) override;

    // nsIObserver
    NS_DECL_NSIOBSERVER
};

////////////////////////////////////////////////////////////////////////


LocalStoreImpl::LocalStoreImpl(void)
{
}

LocalStoreImpl::~LocalStoreImpl(void)
{
    if (mRDFService)
        mRDFService->UnregisterDataSource(this);
}


nsresult
NS_NewLocalStore(nsISupports* aOuter, REFNSIID aIID, void** aResult)
{
    NS_PRECONDITION(aOuter == nullptr, "no aggregation");
    if (aOuter)
        return NS_ERROR_NO_AGGREGATION;

    NS_PRECONDITION(aResult != nullptr, "null ptr");
    if (! aResult)
        return NS_ERROR_NULL_POINTER;

    LocalStoreImpl* impl = new LocalStoreImpl();
    if (! impl)
        return NS_ERROR_OUT_OF_MEMORY;

    NS_ADDREF(impl);

    nsresult rv;
    rv = impl->Init();
    if (NS_SUCCEEDED(rv)) {
        // Set up the result pointer
        rv = impl->QueryInterface(aIID, aResult);
    }

    NS_RELEASE(impl);
    return rv;
}

NS_IMPL_CYCLE_COLLECTION(LocalStoreImpl, mInner)
NS_IMPL_CYCLE_COLLECTING_ADDREF(LocalStoreImpl)
NS_IMPL_CYCLE_COLLECTING_RELEASE(LocalStoreImpl)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(LocalStoreImpl)
    NS_INTERFACE_MAP_ENTRY(nsILocalStore)
    NS_INTERFACE_MAP_ENTRY(nsIRDFDataSource)
    NS_INTERFACE_MAP_ENTRY(nsIRDFRemoteDataSource)
    NS_INTERFACE_MAP_ENTRY(nsIObserver)
    NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
    NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsILocalStore)
NS_INTERFACE_MAP_END

// nsILocalStore interface

// nsIRDFDataSource interface

NS_IMETHODIMP
LocalStoreImpl::GetLoaded(bool* _result)
{
	nsCOMPtr<nsIRDFRemoteDataSource> remote = do_QueryInterface(mInner);
    NS_ASSERTION(remote != nullptr, "not an nsIRDFRemoteDataSource");
	if (! remote)
        return NS_ERROR_UNEXPECTED;

    return remote->GetLoaded(_result);
}


NS_IMETHODIMP
LocalStoreImpl::Init(const char *uri)
{
	return(NS_OK);
}

NS_IMETHODIMP
LocalStoreImpl::Flush()
{
	nsCOMPtr<nsIRDFRemoteDataSource> remote = do_QueryInterface(mInner);
    // FIXME Bug 340242: Temporarily make this a warning rather than an
    // assertion until we sort out the ordering of how we write
    // everything to the localstore, flush it, and disconnect it when
    // we're getting profile-change notifications.
    NS_WARNING_ASSERTION(remote != nullptr, "not an nsIRDFRemoteDataSource");
	if (! remote)
        return NS_ERROR_UNEXPECTED;

    return remote->Flush();
}

NS_IMETHODIMP
LocalStoreImpl::FlushTo(const char *aURI)
{
  // Do not ever implement this (security)
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
LocalStoreImpl::Refresh(bool sync)
{
	nsCOMPtr<nsIRDFRemoteDataSource> remote = do_QueryInterface(mInner);
    NS_ASSERTION(remote != nullptr, "not an nsIRDFRemoteDataSource");
	if (! remote)
        return NS_ERROR_UNEXPECTED;

    return remote->Refresh(sync);
}

nsresult
LocalStoreImpl::Init()
{
    nsresult rv;

    rv = LoadData();
    if (NS_FAILED(rv)) return rv;

    // register this as a named data source with the RDF service
    mRDFService = do_GetService(NS_RDF_CONTRACTID "/rdf-service;1", &rv);
    if (NS_FAILED(rv)) return rv;

    mRDFService->RegisterDataSource(this, false);

    // Register as an observer of profile changes
    nsCOMPtr<nsIObserverService> obs =
        do_GetService("@mozilla.org/observer-service;1");

    if (obs) {
        obs->AddObserver(this, "profile-before-change", true);
        obs->AddObserver(this, "profile-do-change", true);
    }

    return NS_OK;
}

nsresult
LocalStoreImpl::CreateLocalStore(nsIFile* aFile)
{
    nsresult rv;

    rv = aFile->Create(nsIFile::NORMAL_FILE_TYPE, 0666);
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIOutputStream> outStream;
    rv = NS_NewLocalFileOutputStream(getter_AddRefs(outStream), aFile);
    if (NS_FAILED(rv)) return rv;

    const char defaultRDF[] = 
        "<?xml version=\"1.0\"?>\n" \
        "<RDF:RDF xmlns:RDF=\"" RDF_NAMESPACE_URI "\"\n" \
        "         xmlns:NC=\""  NC_NAMESPACE_URI "\">\n" \
        "  <!-- Empty -->\n" \
        "</RDF:RDF>\n";

    uint32_t count;
    rv = outStream->Write(defaultRDF, sizeof(defaultRDF)-1, &count);
    if (NS_FAILED(rv)) return rv;

    if (count != sizeof(defaultRDF)-1)
        return NS_ERROR_UNEXPECTED;

    // Okay, now see if the file exists _for real_. If it's still
    // not there, it could be that the profile service gave us
    // back a read-only directory. Whatever.
    bool fileExistsFlag = false;
    aFile->Exists(&fileExistsFlag);
    if (!fileExistsFlag)
        return NS_ERROR_UNEXPECTED;

    return NS_OK;
}

nsresult
LocalStoreImpl::LoadData()
{
    nsresult rv;

    // Look for localstore.rdf in the current profile
    // directory. Bomb if we can't find it.

    nsCOMPtr<nsIFile> aFile;
    rv = NS_GetSpecialDirectory(NS_APP_LOCALSTORE_50_FILE, getter_AddRefs(aFile));
    if (NS_FAILED(rv)) return rv;

    bool fileExistsFlag = false;
    (void)aFile->Exists(&fileExistsFlag);
    if (!fileExistsFlag) {
        // if file doesn't exist, create it
        rv = CreateLocalStore(aFile);
        if (NS_FAILED(rv)) return rv;
    }

    mInner = do_CreateInstance(NS_RDF_DATASOURCE_CONTRACTID_PREFIX "xml-datasource", &rv);
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIRDFRemoteDataSource> remote = do_QueryInterface(mInner, &rv);
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIURI> aURI;
    rv = NS_NewFileURI(getter_AddRefs(aURI), aFile);
    if (NS_FAILED(rv)) return rv;

    nsAutoCString spec;
    rv = aURI->GetSpec(spec);
    if (NS_FAILED(rv)) return rv;

    rv = remote->Init(spec.get());
    if (NS_FAILED(rv)) return rv;

    // Read the datasource synchronously.
    rv = remote->Refresh(true);
    
    if (NS_FAILED(rv)) {
        // Load failed, delete and recreate a fresh localstore
        aFile->Remove(true);
        rv = CreateLocalStore(aFile);
        if (NS_FAILED(rv)) return rv;
        
        rv = remote->Refresh(true);
    }

    return rv;
}


NS_IMETHODIMP
LocalStoreImpl::GetURI(char* *aURI)
{
    NS_PRECONDITION(aURI != nullptr, "null ptr");
    if (! aURI)
        return NS_ERROR_NULL_POINTER;

    *aURI = NS_strdup("rdf:local-store");
    if (! *aURI)
        return NS_ERROR_OUT_OF_MEMORY;

    return NS_OK;
}


NS_IMETHODIMP
LocalStoreImpl::GetAllCmds(nsIRDFResource* aSource,
                               nsISimpleEnumerator/*<nsIRDFResource>*/** aCommands)
{
	return(NS_NewEmptyEnumerator(aCommands));
}

NS_IMETHODIMP
LocalStoreImpl::IsCommandEnabled(nsISupports* aSources,
                                 nsIRDFResource*   aCommand,
                                 nsISupports* aArguments,
                                 bool* aResult)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
LocalStoreImpl::DoCommand(nsISupports* aSources,
                          nsIRDFResource*   aCommand,
                          nsISupports* aArguments)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
LocalStoreImpl::Observe(nsISupports *aSubject, const char *aTopic, const char16_t *someData)
{
    nsresult rv = NS_OK;

    if (!nsCRT::strcmp(aTopic, "profile-before-change")) {
        // Write out the old datasource's contents.
        if (mInner) {
            nsCOMPtr<nsIRDFRemoteDataSource> remote = do_QueryInterface(mInner);
            if (remote)
                remote->Flush();
        }

        // Create an in-memory datasource for use while we're
        // profile-less.
        mInner = do_CreateInstance(NS_RDF_DATASOURCE_CONTRACTID_PREFIX "in-memory-datasource");
    }
    else if (!nsCRT::strcmp(aTopic, "profile-do-change")) {
        rv = LoadData();
    }
    return rv;
}
