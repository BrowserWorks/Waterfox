/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef debugger_Script_h
#define debugger_Script_h

#include "jsapi.h"  // for Handle, JSFunctionSpec, JSPropertySpec

#include "jstypes.h"            // for JS_PUBLIC_API
#include "NamespaceImports.h"   // for Value, HandleObject, CallArgs
#include "debugger/Debugger.h"  // for DebuggerScriptReferent
#include "gc/Rooting.h"         // for HandleNativeObject
#include "vm/NativeObject.h"    // for NativeObject

class JS_PUBLIC_API JSObject;

namespace js {

class BaseScript;
class GlobalObject;

namespace gc {
struct Cell;
}

class DebuggerScript : public NativeObject {
 public:
  static const JSClass class_;

  enum {
    OWNER_SLOT,

    // Holds any instrumentation ID that has been assigned to the script.
    INSTRUMENTATION_ID_SLOT,

    RESERVED_SLOTS,
  };

  static NativeObject* initClass(JSContext* cx, Handle<GlobalObject*> global,
                                 HandleObject debugCtor);
  static DebuggerScript* create(JSContext* cx, HandleObject proto,
                                Handle<DebuggerScriptReferent> referent,
                                HandleNativeObject debugger);

  void trace(JSTracer* trc);

  using ReferentVariant = DebuggerScriptReferent;

  inline gc::Cell* getReferentCell() const;
  inline js::BaseScript* getReferentScript() const;
  inline DebuggerScriptReferent getReferent() const;

  static DebuggerScript* check(JSContext* cx, HandleValue v);

  static bool construct(JSContext* cx, unsigned argc, Value* vp);

  struct CallData;

  static bool getSuccessorOrPredecessorOffsets(JSContext* cx, unsigned argc,
                                               Value* vp, const char* name,
                                               bool successor);

  Value getInstrumentationId() const {
    return getSlot(INSTRUMENTATION_ID_SLOT);
  }

 private:
  static const JSClassOps classOps_;

  static const JSPropertySpec properties_[];
  static const JSFunctionSpec methods_[];

  struct GetLineCountMatcher;
  class GetSourceMatcher;
  template <bool OnlyOffsets>
  class GetPossibleBreakpointsMatcher;
  class GetOffsetMetadataMatcher;
  class GetOffsetLocationMatcher;
  class GetSuccessorOrPredecessorOffsetsMatcher;
  class GetAllColumnOffsetsMatcher;
  class GetLineOffsetsMatcher;
  struct SetBreakpointMatcher;
  class ClearBreakpointMatcher;
  class IsInCatchScopeMatcher;
};

} /* namespace js */

#endif /* debugger_Script_h */
