/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ipc_InputStreamUtils_h
#define mozilla_ipc_InputStreamUtils_h

#include "mozilla/ipc/InputStreamParams.h"
#include "nsCOMPtr.h"
#include "nsIInputStream.h"
#include "nsTArray.h"

namespace mozilla {
namespace ipc {

class FileDescriptor;

// If you want to serialize an inputStream, please use AutoIPCStream.
class InputStreamHelper
{
public:
  static void
  SerializeInputStream(nsIInputStream* aInputStream,
                       InputStreamParams& aParams,
                       nsTArray<FileDescriptor>& aFileDescriptors);

  static already_AddRefed<nsIInputStream>
  DeserializeInputStream(const InputStreamParams& aParams,
                         const nsTArray<FileDescriptor>& aFileDescriptors);
};

} // namespace ipc
} // namespace mozilla

#endif // mozilla_ipc_InputStreamUtils_h
