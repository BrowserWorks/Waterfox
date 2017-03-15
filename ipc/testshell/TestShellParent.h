/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef ipc_testshell_TestShellParent_h
#define ipc_testshell_TestShellParent_h 1

#include "mozilla/ipc/PTestShellParent.h"
#include "mozilla/ipc/PTestShellCommandParent.h"

#include "js/TypeDecls.h"
#include "js/RootingAPI.h"
#include "nsString.h"

namespace mozilla {

namespace ipc {

class TestShellCommandParent;

class TestShellParent : public PTestShellParent
{
public:
  virtual void ActorDestroy(ActorDestroyReason aWhy) override;

  PTestShellCommandParent*
  AllocPTestShellCommandParent(const nsString& aCommand) override;

  bool
  DeallocPTestShellCommandParent(PTestShellCommandParent* aActor) override;

  bool
  CommandDone(TestShellCommandParent* aActor, const nsString& aResponse);
};


class TestShellCommandParent : public PTestShellCommandParent
{
public:
  TestShellCommandParent() {}

  bool SetCallback(JSContext* aCx, const JS::Value& aCallback);

  bool RunCallback(const nsString& aResponse);

  void ReleaseCallback();

protected:
  bool ExecuteCallback(const nsString& aResponse);

  void ActorDestroy(ActorDestroyReason why);

  bool Recv__delete__(const nsString& aResponse) {
    return ExecuteCallback(aResponse);
  }

private:
  JS::PersistentRooted<JS::Value> mCallback;
};


} /* namespace ipc */
} /* namespace mozilla */

#endif /* ipc_testshell_TestShellParent_h */
