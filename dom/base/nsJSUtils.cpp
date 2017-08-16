/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This is not a generated file. It contains common utility functions
 * invoked from the JavaScript code generated from IDL interfaces.
 * The goal of the utility functions is to cut down on the size of
 * the generated code itself.
 */

#include "nsJSUtils.h"
#include "jsapi.h"
#include "jsfriendapi.h"
#include "nsIScriptContext.h"
#include "nsIScriptGlobalObject.h"
#include "nsIXPConnect.h"
#include "nsCOMPtr.h"
#include "nsIScriptSecurityManager.h"
#include "nsPIDOMWindow.h"
#include "GeckoProfiler.h"
#include "nsJSPrincipals.h"
#include "xpcpublic.h"
#include "nsContentUtils.h"
#include "nsGlobalWindow.h"

#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/Date.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/ScriptSettings.h"

using namespace mozilla::dom;

bool
nsJSUtils::GetCallingLocation(JSContext* aContext, nsACString& aFilename,
                              uint32_t* aLineno, uint32_t* aColumn)
{
  JS::AutoFilename filename;
  if (!JS::DescribeScriptedCaller(aContext, &filename, aLineno, aColumn)) {
    return false;
  }

  aFilename.Assign(filename.get());
  return true;
}

bool
nsJSUtils::GetCallingLocation(JSContext* aContext, nsAString& aFilename,
                              uint32_t* aLineno, uint32_t* aColumn)
{
  JS::AutoFilename filename;
  if (!JS::DescribeScriptedCaller(aContext, &filename, aLineno, aColumn)) {
    return false;
  }

  aFilename.Assign(NS_ConvertUTF8toUTF16(filename.get()));
  return true;
}

nsIScriptGlobalObject *
nsJSUtils::GetStaticScriptGlobal(JSObject* aObj)
{
  if (!aObj)
    return nullptr;
  return xpc::WindowGlobalOrNull(aObj);
}

nsIScriptContext *
nsJSUtils::GetStaticScriptContext(JSObject* aObj)
{
  nsIScriptGlobalObject *nativeGlobal = GetStaticScriptGlobal(aObj);
  if (!nativeGlobal)
    return nullptr;

  return nativeGlobal->GetScriptContext();
}

uint64_t
nsJSUtils::GetCurrentlyRunningCodeInnerWindowID(JSContext *aContext)
{
  if (!aContext)
    return 0;

  nsGlobalWindow* win = xpc::CurrentWindowOrNull(aContext);
  return win ? win->WindowID() : 0;
}

nsresult
nsJSUtils::CompileFunction(AutoJSAPI& jsapi,
                           JS::AutoObjectVector& aScopeChain,
                           JS::CompileOptions& aOptions,
                           const nsACString& aName,
                           uint32_t aArgCount,
                           const char** aArgArray,
                           const nsAString& aBody,
                           JSObject** aFunctionObject)
{
  JSContext* cx = jsapi.cx();
  MOZ_ASSERT(js::GetEnterCompartmentDepth(cx) > 0);
  MOZ_ASSERT_IF(aScopeChain.length() != 0,
                js::IsObjectInContextCompartment(aScopeChain[0], cx));
  MOZ_ASSERT_IF(aOptions.versionSet, aOptions.version != JSVERSION_UNKNOWN);

  // Do the junk Gecko is supposed to do before calling into JSAPI.
  for (size_t i = 0; i < aScopeChain.length(); ++i) {
    JS::ExposeObjectToActiveJS(aScopeChain[i]);
  }

  // Compile.
  JS::Rooted<JSFunction*> fun(cx);
  if (!JS::CompileFunction(cx, aScopeChain, aOptions,
                           PromiseFlatCString(aName).get(),
                           aArgCount, aArgArray,
                           PromiseFlatString(aBody).get(),
                           aBody.Length(), &fun))
  {
    return NS_ERROR_FAILURE;
  }

  *aFunctionObject = JS_GetFunctionObject(fun);
  return NS_OK;
}

static nsresult
EvaluationExceptionToNSResult(JSContext* aCx)
{
  if (JS_IsExceptionPending(aCx)) {
    return NS_SUCCESS_DOM_SCRIPT_EVALUATION_THREW;
  }
  return NS_SUCCESS_DOM_SCRIPT_EVALUATION_THREW_UNCATCHABLE;
}

nsJSUtils::ExecutionContext::ExecutionContext(JSContext* aCx,
                                              JS::Handle<JSObject*> aGlobal)
  :
#ifdef MOZ_GECKO_PROFILER
    mProfilerRAII("nsJSUtils::ExecutionContext", /* dynamicStr */ nullptr,
                  __LINE__, js::ProfileEntry::Category::JS),
#endif
    mCx(aCx)
  , mCompartment(aCx, aGlobal)
  , mRetValue(aCx)
  , mScopeChain(aCx)
  , mRv(NS_OK)
  , mSkip(false)
  , mCoerceToString(false)
  , mEncodeBytecode(false)
#ifdef DEBUG
  , mWantsReturnValue(false)
  , mExpectScopeChain(false)
#endif
{
  MOZ_ASSERT(aCx == nsContentUtils::GetCurrentJSContext());
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(nsContentUtils::IsInMicroTask());
  MOZ_ASSERT(mRetValue.isUndefined());

  MOZ_ASSERT(js::GetGlobalForObjectCrossCompartment(aGlobal) == aGlobal);
  if (MOZ_UNLIKELY(!xpc::Scriptability::Get(aGlobal).Allowed())) {
    mSkip = true;
    mRv = NS_OK;
  }
}

void
nsJSUtils::ExecutionContext::SetScopeChain(
  const JS::AutoObjectVector& aScopeChain)
{
  if (mSkip) {
    return;
  }

#ifdef DEBUG
  mExpectScopeChain = true;
#endif
  // Now make sure to wrap the scope chain into the right compartment.
  if (!mScopeChain.reserve(aScopeChain.length())) {
    mSkip = true;
    mRv = NS_ERROR_OUT_OF_MEMORY;
    return;
  }

  for (size_t i = 0; i < aScopeChain.length(); ++i) {
    JS::ExposeObjectToActiveJS(aScopeChain[i]);
    mScopeChain.infallibleAppend(aScopeChain[i]);
    if (!JS_WrapObject(mCx, mScopeChain[i])) {
      mSkip = true;
      mRv = NS_ERROR_OUT_OF_MEMORY;
      return;
    }
  }
}

nsresult
nsJSUtils::ExecutionContext::JoinAndExec(void **aOffThreadToken,
                                         JS::MutableHandle<JSScript*> aScript)
{
  if (mSkip) {
    return mRv;
  }

  MOZ_ASSERT(!mWantsReturnValue);
  MOZ_ASSERT(!mExpectScopeChain);
  aScript.set(JS::FinishOffThreadScript(mCx, *aOffThreadToken));
  *aOffThreadToken = nullptr; // Mark the token as having been finished.
  if (!aScript) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  if (mEncodeBytecode && !StartIncrementalEncoding(mCx, aScript)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  if (!JS_ExecuteScript(mCx, mScopeChain, aScript)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  return NS_OK;
}

nsresult
nsJSUtils::ExecutionContext::CompileAndExec(JS::CompileOptions& aCompileOptions,
                                            JS::SourceBufferHolder& aSrcBuf,
                                            JS::MutableHandle<JSScript*> aScript)
{
  if (mSkip) {
    return mRv;
  }

  MOZ_ASSERT_IF(aCompileOptions.versionSet,
                aCompileOptions.version != JSVERSION_UNKNOWN);
  MOZ_ASSERT(aSrcBuf.get());
  MOZ_ASSERT(mRetValue.isUndefined());
#ifdef DEBUG
  mWantsReturnValue = !aCompileOptions.noScriptRval;
#endif

  bool compiled = true;
  if (mScopeChain.length() == 0) {
    compiled = JS::Compile(mCx, aCompileOptions, aSrcBuf, aScript);
  } else {
    compiled = JS::CompileForNonSyntacticScope(mCx, aCompileOptions, aSrcBuf, aScript);
  }

  MOZ_ASSERT_IF(compiled, aScript);
  if (!compiled) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  if (mEncodeBytecode && !StartIncrementalEncoding(mCx, aScript)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  MOZ_ASSERT(!mCoerceToString || mWantsReturnValue);
  if (!JS_ExecuteScript(mCx, mScopeChain, aScript, &mRetValue)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  return NS_OK;
}

nsresult
nsJSUtils::ExecutionContext::CompileAndExec(JS::CompileOptions& aCompileOptions,
                                            const nsAString& aScript)
{
  MOZ_ASSERT(!mEncodeBytecode, "A JSScript is needed for calling FinishIncrementalEncoding");
  if (mSkip) {
    return mRv;
  }

  const nsPromiseFlatString& flatScript = PromiseFlatString(aScript);
  JS::SourceBufferHolder srcBuf(flatScript.get(), aScript.Length(),
                                JS::SourceBufferHolder::NoOwnership);
  JS::Rooted<JSScript*> script(mCx);
  return CompileAndExec(aCompileOptions, srcBuf, &script);
}

nsresult
nsJSUtils::ExecutionContext::DecodeAndExec(JS::CompileOptions& aCompileOptions,
                                           mozilla::Vector<uint8_t>& aBytecodeBuf,
                                           size_t aBytecodeIndex)
{
  MOZ_ASSERT(!mEncodeBytecode, "A JSScript is needed for calling FinishIncrementalEncoding");
  if (mSkip) {
    return mRv;
  }

  MOZ_ASSERT(!mWantsReturnValue);
  JS::Rooted<JSScript*> script(mCx);
  JS::TranscodeResult tr = JS::DecodeScript(mCx, aBytecodeBuf, &script, aBytecodeIndex);
  // These errors are external parameters which should be handled before the
  // decoding phase, and which are the only reasons why you might want to
  // fallback on decoding failures.
  MOZ_ASSERT(tr != JS::TranscodeResult_Failure_BadBuildId &&
             tr != JS::TranscodeResult_Failure_WrongCompileOption);
  if (tr != JS::TranscodeResult_Ok) {
    mSkip = true;
    mRv = NS_ERROR_DOM_JS_DECODING_ERROR;
    return mRv;
  }

  if (!JS_ExecuteScript(mCx, mScopeChain, script)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  return mRv;
}

nsresult
nsJSUtils::ExecutionContext::DecodeJoinAndExec(void **aOffThreadToken)
{
  if (mSkip) {
    return mRv;
  }

  MOZ_ASSERT(!mWantsReturnValue);
  MOZ_ASSERT(!mExpectScopeChain);
  JS::Rooted<JSScript*> script(mCx);
  script.set(JS::FinishOffThreadScriptDecoder(mCx, *aOffThreadToken));
  *aOffThreadToken = nullptr; // Mark the token as having been finished.
  if (!script || !JS_ExecuteScript(mCx, mScopeChain, script)) {
    mSkip = true;
    mRv = EvaluationExceptionToNSResult(mCx);
    return mRv;
  }

  return NS_OK;
}

nsresult
nsJSUtils::ExecutionContext::ExtractReturnValue(JS::MutableHandle<JS::Value> aRetValue)
{
  MOZ_ASSERT(aRetValue.isUndefined());
  if (mSkip) {
    // Repeat earlier result, as NS_SUCCESS_DOM_SCRIPT_EVALUATION_THREW are not
    // failures cases.
#ifdef DEBUG
    mWantsReturnValue = false;
#endif
    return mRv;
  }

  MOZ_ASSERT(mWantsReturnValue);
#ifdef DEBUG
  mWantsReturnValue = false;
#endif
  if (mCoerceToString && !mRetValue.isUndefined()) {
    JSString* str = JS::ToString(mCx, mRetValue);
    if (!str) {
      // ToString can be a function call, so an exception can be raised while
      // executing the function.
      mSkip = true;
      return EvaluationExceptionToNSResult(mCx);
    }
    mRetValue.set(JS::StringValue(str));
  }

  aRetValue.set(mRetValue);
  return NS_OK;
}

nsresult
nsJSUtils::CompileModule(JSContext* aCx,
                       JS::SourceBufferHolder& aSrcBuf,
                       JS::Handle<JSObject*> aEvaluationGlobal,
                       JS::CompileOptions &aCompileOptions,
                       JS::MutableHandle<JSObject*> aModule)
{
  PROFILER_LABEL("nsJSUtils", "CompileModule",
    js::ProfileEntry::Category::JS);

  MOZ_ASSERT_IF(aCompileOptions.versionSet,
                aCompileOptions.version != JSVERSION_UNKNOWN);
  MOZ_ASSERT(aCx == nsContentUtils::GetCurrentJSContext());
  MOZ_ASSERT(aSrcBuf.get());
  MOZ_ASSERT(js::GetGlobalForObjectCrossCompartment(aEvaluationGlobal) ==
             aEvaluationGlobal);
  MOZ_ASSERT(JS::CurrentGlobalOrNull(aCx) == aEvaluationGlobal);
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(nsContentUtils::IsInMicroTask());

  NS_ENSURE_TRUE(xpc::Scriptability::Get(aEvaluationGlobal).Allowed(), NS_OK);

  if (!JS::CompileModule(aCx, aCompileOptions, aSrcBuf, aModule)) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
nsJSUtils::ModuleDeclarationInstantiation(JSContext* aCx, JS::Handle<JSObject*> aModule)
{
  PROFILER_LABEL("nsJSUtils", "ModuleDeclarationInstantiation",
    js::ProfileEntry::Category::JS);

  MOZ_ASSERT(aCx == nsContentUtils::GetCurrentJSContext());
  MOZ_ASSERT(NS_IsMainThread());

  NS_ENSURE_TRUE(xpc::Scriptability::Get(aModule).Allowed(), NS_OK);

  if (!JS::ModuleDeclarationInstantiation(aCx, aModule)) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
nsJSUtils::ModuleEvaluation(JSContext* aCx, JS::Handle<JSObject*> aModule)
{
  PROFILER_LABEL("nsJSUtils", "ModuleEvaluation",
    js::ProfileEntry::Category::JS);

  MOZ_ASSERT(aCx == nsContentUtils::GetCurrentJSContext());
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(nsContentUtils::IsInMicroTask());

  NS_ENSURE_TRUE(xpc::Scriptability::Get(aModule).Allowed(), NS_OK);

  if (!JS::ModuleEvaluation(aCx, aModule)) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

/* static */
bool
nsJSUtils::GetScopeChainForElement(JSContext* aCx,
                                   mozilla::dom::Element* aElement,
                                   JS::AutoObjectVector& aScopeChain)
{
  for (nsINode* cur = aElement; cur; cur = cur->GetScopeChainParent()) {
    JS::RootedValue val(aCx);
    if (!GetOrCreateDOMReflector(aCx, cur, &val)) {
      return false;
    }

    if (!aScopeChain.append(&val.toObject())) {
      return false;
    }
  }

  return true;
}

/* static */
void
nsJSUtils::ResetTimeZone()
{
  JS::ResetTimeZone();
}

//
// nsDOMJSUtils.h
//

bool nsAutoJSString::init(const JS::Value &v)
{
  // Note: it's okay to use danger::GetJSContext here instead of AutoJSAPI,
  // because the init() call below is careful not to run script (for instance,
  // it only calls JS::ToString for non-object values).
  JSContext* cx = danger::GetJSContext();
  if (!init(cx, v)) {
    JS_ClearPendingException(cx);
    return false;
  }

  return true;
}

