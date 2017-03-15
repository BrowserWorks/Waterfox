/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/TestFunctions.h"
#include "mozilla/dom/TestFunctionsBinding.h"
#include "nsStringBuffer.h"

namespace mozilla {
namespace dom {

/* static */ TestFunctions*
TestFunctions::Constructor(GlobalObject& aGlobal, ErrorResult& aRv)
{
  return new TestFunctions;
}

/* static */ void
TestFunctions::ThrowUncatchableException(GlobalObject& aGlobal,
                                         ErrorResult& aRv)
{
  aRv.ThrowUncatchableException();
}

/* static */ Promise*
TestFunctions::PassThroughPromise(GlobalObject& aGlobal, Promise& aPromise)
{
  return &aPromise;
}

/* static */ already_AddRefed<Promise>
TestFunctions::PassThroughCallbackPromise(GlobalObject& aGlobal,
                                          PromiseReturner& aCallback,
                                          ErrorResult& aRv)
{
  return aCallback.Call(aRv);
}

void
TestFunctions::SetStringData(const nsAString& aString)
{
  mStringData = aString;
}

void
TestFunctions::GetStringDataAsAString(nsAString& aString)
{
  aString = mStringData;
}

void
TestFunctions::GetStringDataAsAString(uint32_t aLength, nsAString& aString)
{
  MOZ_RELEASE_ASSERT(aLength <= mStringData.Length(),
                     "Bogus test passing in a too-big length");
  aString.Assign(mStringData.BeginReading(), aLength);
}

void
TestFunctions::GetStringDataAsDOMString(const Optional<uint32_t>& aLength,
                                        DOMString& aString)
{
  uint32_t length;
  if (aLength.WasPassed()) {
    length = aLength.Value();
    MOZ_RELEASE_ASSERT(length <= mStringData.Length(),
                       "Bogus test passing in a too-big length");
  } else {
    length = mStringData.Length();
  }

  nsStringBuffer* buf = nsStringBuffer::FromString(mStringData);
  if (buf) {
    aString.SetStringBuffer(buf, length);
    return;
  }

  // We better have an empty mStringData; otherwise why did we not have a string
  // buffer?
  MOZ_RELEASE_ASSERT(length == 0, "Why no stringbuffer?");
  // No need to do anything here; aString is already empty.
}

bool
TestFunctions::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto,
                          JS::MutableHandle<JSObject*> aWrapper)
{
  return TestFunctionsBinding::Wrap(aCx, this, aGivenProto, aWrapper);
}

}
}
