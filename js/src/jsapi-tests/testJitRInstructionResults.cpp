/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/JSJitFrameIter.h"
#include "js/Exception.h"
#include "js/PropertyAndElement.h"
#include "jsapi-tests/tests.h"
#include "vm/JSContext.h"
#include "vm/SavedFrame.h"

using js::jit::RInstructionResults;

enum class FailureKind { Exception, OutOfMemory, Uncatchable };

BEGIN_TEST(testJitRInstructionResults_failure) {
  for (FailureKind kind : {FailureKind::Exception, FailureKind::OutOfMemory,
                           FailureKind::Uncatchable}) {
    for (bool initialize : {false, true}) {
      CHECK(testFailure(kind, initialize));
    }
  }
  return true;
}

bool testFailure(FailureKind kind, bool initialize) {
  JS::Rooted<RInstructionResults> results(cx, RInstructionResults(nullptr));
  if (initialize) {
    CHECK(results.get().init(cx, 3));
  }

  JS::ExceptionStatus status;
  {
    switch (kind) {
      case FailureKind::Exception: {
        JS::RootedValue exception(cx);
        EVAL("({ marker: 42 })", &exception);
        JS::RootedValue error(cx);
        EVAL("new Error('saved stack')", &error);
        JS::RootedObject errorObject(cx, &error.toObject());
        JS::RootedObject stack(cx, JS::ExceptionStackOrNull(errorObject));
        CHECK(stack);
        JS::Rooted<js::SavedFrame*> savedFrame(cx,
                                               &stack->as<js::SavedFrame>());
        cx->setPendingException(exception, savedFrame);
        break;
      }
      case FailureKind::OutOfMemory:
        js::ReportOutOfMemory(cx);
        break;
      case FailureKind::Uncatchable:
        cx->reportUncatchableException();
        break;
    }
    status = cx->exceptionStatus();
    results.get().saveFailure(cx);
    CHECK(cx->exceptionStatus() == status);
    JS_ClearPendingException(cx);
  }

  // The saved failure is the only reference to the exception now.
  JS::Rooted<RInstructionResults> moved(cx, RInstructionResults(nullptr));
  moved.get() = std::move(results.get());
  JS_GC(cx);

  JS::RootedValue firstException(cx);
  JS::RootedObject firstStack(cx);
  for (size_t i = 0; i < 2; i++) {
    CHECK(moved.get().hasFailure());
    moved.get().restoreFailure(cx);
    CHECK(cx->exceptionStatus() == status);
    CHECK(JS_IsExceptionPending(cx) == (kind != FailureKind::Uncatchable));

    if (kind == FailureKind::Exception) {
      JS::ExceptionStack pending(cx);
      CHECK(JS::GetPendingExceptionStack(cx, &pending));
      CHECK(pending.exception().isObject());
      CHECK(pending.stack());
      JS::RootedObject exception(cx, &pending.exception().toObject());
      JS::RootedValue marker(cx);
      CHECK(JS_GetProperty(cx, exception, "marker", &marker));
      CHECK_SAME(marker, JS::Int32Value(42));
      if (i == 0) {
        firstException = pending.exception();
        firstStack = pending.stack();
      } else {
        CHECK_SAME(pending.exception(), firstException);
        CHECK(pending.stack() == firstStack);
      }
    } else {
      CHECK(!cx->getPendingExceptionStack());
    }
    JS_ClearPendingException(cx);
  }
  return true;
}
END_TEST(testJitRInstructionResults_failure)
