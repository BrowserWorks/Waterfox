// Copyright (c) 2010 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef SANDBOX_SRC_FILESYSTEM_DISPATCHER_H__
#define SANDBOX_SRC_FILESYSTEM_DISPATCHER_H__

#include <stdint.h>

#include "base/macros.h"
#include "base/strings/string16.h"
#include "sandbox/win/src/crosscall_server.h"
#include "sandbox/win/src/sandbox_policy_base.h"

namespace sandbox {

// This class handles file system-related IPC calls.
class FilesystemDispatcher : public Dispatcher {
 public:
  explicit FilesystemDispatcher(PolicyBase* policy_base);
  ~FilesystemDispatcher() override {}

  // Dispatcher interface.
  bool SetupService(InterceptionManager* manager, int service) override;

 private:
  // Processes IPC requests coming from calls to NtCreateFile in the target.
  bool NtCreateFile(IPCInfo* ipc,
                    base::string16* name,
                    uint32_t attributes,
                    uint32_t desired_access,
                    uint32_t file_attributes,
                    uint32_t share_access,
                    uint32_t create_disposition,
                    uint32_t create_options);

  // Processes IPC requests coming from calls to NtOpenFile in the target.
  bool NtOpenFile(IPCInfo* ipc,
                  base::string16* name,
                  uint32_t attributes,
                  uint32_t desired_access,
                  uint32_t share_access,
                  uint32_t create_options);

  // Processes IPC requests coming from calls to NtQueryAttributesFile in the
  // target.
  bool NtQueryAttributesFile(IPCInfo* ipc,
                             base::string16* name,
                             uint32_t attributes,
                             CountedBuffer* info);

  // Processes IPC requests coming from calls to NtQueryFullAttributesFile in
  // the target.
  bool NtQueryFullAttributesFile(IPCInfo* ipc,
                                 base::string16* name,
                                 uint32_t attributes,
                                 CountedBuffer* info);

  // Processes IPC requests coming from calls to NtSetInformationFile with the
  // rename information class.
  bool NtSetInformationFile(IPCInfo* ipc,
                            HANDLE handle,
                            CountedBuffer* status,
                            CountedBuffer* info,
                            uint32_t length,
                            uint32_t info_class);

  PolicyBase* policy_base_;
  DISALLOW_COPY_AND_ASSIGN(FilesystemDispatcher);
};

}  // namespace sandbox

#endif  // SANDBOX_SRC_FILESYSTEM_DISPATCHER_H__
