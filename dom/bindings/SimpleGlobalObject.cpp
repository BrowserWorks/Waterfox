/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/SimpleGlobalObject.h"

#include "jsapi.h"
#include "js/Class.h"

#include "nsJSPrincipals.h"
#include "NullPrincipal.h"
#include "nsThreadUtils.h"
#include "nsContentUtils.h"

#include "xpcprivate.h"

#include "mozilla/dom/ScriptSettings.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION_CLASS(SimpleGlobalObject)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(SimpleGlobalObject)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
  tmp->UnlinkHostObjectURIs();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(SimpleGlobalObject)
  tmp->TraverseHostObjectURIs(cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_TRACE_WRAPPERCACHE(SimpleGlobalObject)

NS_IMPL_CYCLE_COLLECTING_ADDREF(SimpleGlobalObject)
NS_IMPL_CYCLE_COLLECTING_RELEASE(SimpleGlobalObject)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(SimpleGlobalObject)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsIGlobalObject)
NS_INTERFACE_MAP_END

static void
SimpleGlobal_finalize(js::FreeOp *fop, JSObject *obj)
{
  SimpleGlobalObject* globalObject =
    static_cast<SimpleGlobalObject*>(JS_GetPrivate(obj));
  globalObject->ClearWrapper(obj);
  NS_RELEASE(globalObject);
}

static void
SimpleGlobal_moved(JSObject *obj, const JSObject *old)
{
  SimpleGlobalObject* globalObject =
    static_cast<SimpleGlobalObject*>(JS_GetPrivate(obj));
  globalObject->UpdateWrapper(obj, old);
}

static const js::ClassOps SimpleGlobalClassOps = {
    nullptr,
    nullptr,
    nullptr,
    nullptr,
    nullptr,
    JS_NewEnumerateStandardClasses,
    JS_ResolveStandardClass,
    JS_MayResolveStandardClass,
    SimpleGlobal_finalize,
    nullptr,
    nullptr,
    nullptr,
    JS_GlobalObjectTraceHook,
};

static const js::ClassExtension SimpleGlobalClassExtension = {
  nullptr,
  SimpleGlobal_moved
};

const js::Class SimpleGlobalClass = {
    "",
    JSCLASS_GLOBAL_FLAGS |
    JSCLASS_HAS_PRIVATE |
    JSCLASS_PRIVATE_IS_NSISUPPORTS |
    JSCLASS_FOREGROUND_FINALIZE,
    &SimpleGlobalClassOps,
    JS_NULL_CLASS_SPEC,
    &SimpleGlobalClassExtension,
    JS_NULL_OBJECT_OPS
};

// static
JSObject*
SimpleGlobalObject::Create(GlobalType globalType, JS::Handle<JS::Value> proto)
{
  // We can't root our return value with our AutoJSAPI because the rooting
  // analysis thinks ~AutoJSAPI can GC.  So we need to root in a scope outside
  // the lifetime of the AutoJSAPI.
  JS::Rooted<JSObject*> global(RootingCx());

  { // Scope to ensure the AutoJSAPI destructor runs before we end up returning
    AutoJSAPI jsapi;
    jsapi.Init();
    JSContext* cx = jsapi.cx();

    JS::CompartmentOptions options;
    options.creationOptions()
           .setInvisibleToDebugger(true)
           // Put our SimpleGlobalObjects in the system zone, so we won't create
           // lots of zones for what are probably very short-lived
           // compartments.  This should help them be GCed quicker and take up
           // less memory before they're GCed.
           .setSystemZone();

    if (NS_IsMainThread()) {
      nsCOMPtr<nsIPrincipal> principal = NullPrincipal::Create();
      options.creationOptions().setTrace(xpc::TraceXPCGlobal);
      global = xpc::CreateGlobalObject(cx, js::Jsvalify(&SimpleGlobalClass),
                                       nsJSPrincipals::get(principal),
                                       options);
    } else {
      global = JS_NewGlobalObject(cx, js::Jsvalify(&SimpleGlobalClass),
                                  nullptr,
                                  JS::DontFireOnNewGlobalHook, options);
    }

    if (!global) {
      jsapi.ClearException();
      return nullptr;
    }

    JSAutoCompartment ac(cx, global);

    // It's important to create the nsIGlobalObject for our new global before we
    // start trying to wrap things like the prototype into its compartment,
    // because the wrap operation relies on the global having its
    // nsIGlobalObject already.
    RefPtr<SimpleGlobalObject> globalObject =
      new SimpleGlobalObject(global, globalType);

    // Pass on ownership of globalObject to |global|.
    JS_SetPrivate(global, globalObject.forget().take());

    if (proto.isObjectOrNull()) {
      JS::Rooted<JSObject*> protoObj(cx, proto.toObjectOrNull());
      if (!JS_WrapObject(cx, &protoObj)) {
        jsapi.ClearException();
        return nullptr;
      }

      if (!JS_SplicePrototype(cx, global, protoObj)) {
        jsapi.ClearException();
        return nullptr;
      }
    } else if (!proto.isUndefined()) {
      // Bogus proto.
      return nullptr;
    }

    JS_FireOnNewGlobalObject(cx, global);
  }

  return global;
}

// static
SimpleGlobalObject::GlobalType
SimpleGlobalObject::SimpleGlobalType(JSObject* obj)
{
  if (js::GetObjectClass(obj) != &SimpleGlobalClass) {
    return SimpleGlobalObject::GlobalType::NotSimpleGlobal;
  }

  SimpleGlobalObject* globalObject =
    static_cast<SimpleGlobalObject*>(JS_GetPrivate(obj));
  return globalObject->Type();
}

} // namespace mozilla
} // namespace dom
