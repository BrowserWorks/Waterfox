/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsIScriptNameSpaceManager_h__
#define nsIScriptNameSpaceManager_h__

#define JAVASCRIPT_GLOBAL_CONSTRUCTOR_CATEGORY \
  "JavaScript-global-constructor"

#define JAVASCRIPT_GLOBAL_PROPERTY_CATEGORY \
  "JavaScript-global-property"

// a global property that is only accessible to privileged script
#define JAVASCRIPT_GLOBAL_PRIVILEGED_PROPERTY_CATEGORY \
  "JavaScript-global-privileged-property"

#endif /* nsIScriptNameSpaceManager_h__ */
