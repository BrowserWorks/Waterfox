/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_BlobMemoryReporter_h
#define mozilla_dom_BlobMemoryReporter_h

#include "nsIMemoryReporter.h"

namespace mozilla::dom {

class BlobImpl;

// Shared memory reporter for all BlobImpl instances.
// Call Register/Unregister from BlobImpl ctor/dtor.
class BlobMemoryReporter final : public nsIMemoryReporter {
 public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIMEMORYREPORTER

  static void Register(BlobImpl* aImpl);
  static void Unregister(BlobImpl* aImpl);

 private:
  ~BlobMemoryReporter();
};

}  // namespace mozilla::dom

#endif  // mozilla_dom_BlobMemoryReporter_h
