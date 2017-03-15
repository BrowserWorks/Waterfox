/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsFileProtocolHandler_h__
#define nsFileProtocolHandler_h__

#include "nsIFileProtocolHandler.h"
#include "nsWeakReference.h"

class nsFileProtocolHandler : public nsIFileProtocolHandler
                            , public nsSupportsWeakReference
{
    virtual ~nsFileProtocolHandler() {}

public:
    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIPROTOCOLHANDLER
    NS_DECL_NSIFILEPROTOCOLHANDLER

    nsFileProtocolHandler();

    MOZ_MUST_USE nsresult Init();
};

#endif // !nsFileProtocolHandler_h__
