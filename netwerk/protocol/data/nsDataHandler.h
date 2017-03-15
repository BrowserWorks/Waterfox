/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsDataHandler_h___
#define nsDataHandler_h___

#include "nsIProtocolHandler.h"
#include "nsWeakReference.h"

class nsDataHandler : public nsIProtocolHandler
                    , public nsSupportsWeakReference
{
    virtual ~nsDataHandler();

public:
    NS_DECL_ISUPPORTS

    // nsIProtocolHandler methods:
    NS_DECL_NSIPROTOCOLHANDLER

    // nsDataHandler methods:
    nsDataHandler();

    // Define a Create method to be used with a factory:
    static MOZ_MUST_USE nsresult
    Create(nsISupports* aOuter, const nsIID& aIID, void* *aResult);

    // Parse a data: URI and return the individual parts
    // (the given spec will temporarily be modified but will be returned
    //  to the original before returning)
    // contentCharset and dataBuffer can be nullptr if they are not needed.
    static MOZ_MUST_USE nsresult ParseURI(nsCString& spec,
                                          nsCString& contentType,
                                          nsCString* contentCharset,
                                          bool& isBase64,
                                          nsCString* dataBuffer);
};

#endif /* nsDataHandler_h___ */
