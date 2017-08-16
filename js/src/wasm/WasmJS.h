/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 *
 * Copyright 2016 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_js_h
#define wasm_js_h

#include "gc/Policy.h"
#include "vm/NativeObject.h"
#include "wasm/WasmTypes.h"

namespace js {

class TypedArrayObject;
class WasmFunctionScope;

namespace wasm {

// Creates a testing-only NaN JS object with fields as described above, for
// T=float or T=double.

template<typename T>
JSObject*
CreateCustomNaNObject(JSContext* cx, T* addr);

// Converts a testing-only NaN JS object with a nan_low field to a float32 NaN
// with nan_low as the payload.

bool
ReadCustomFloat32NaNObject(JSContext* cx, HandleValue v, uint32_t* ret);

// Converts a testing-only NaN JS object with nan_{low,high} components to a
// double NaN with nan_low|(nan_high)>>32 as the payload.

bool
ReadCustomDoubleNaNObject(JSContext* cx, HandleValue v, uint64_t* ret);

// Creates a JS object containing two fields (low: low 32 bits; high: high 32
// bits) of a given Int64 value. For testing purposes only.

JSObject*
CreateI64Object(JSContext* cx, int64_t i64);

// Reads an int64 from a JS object with the same shape as described in the
// comment above. For testing purposes only.

bool
ReadI64Object(JSContext* cx, HandleValue v, int64_t* i64);

// Return whether WebAssembly can be compiled on this platform.
// This must be checked and must be true to call any of the top-level wasm
// eval/compile methods.

bool
HasCompilerSupport(JSContext* cx);

// Return whether WebAssembly is enabled on this platform.

bool
HasSupport(JSContext* cx);

// Compiles the given binary wasm module given the ArrayBufferObject
// and links the module's imports with the given import object.

MOZ_MUST_USE bool
Eval(JSContext* cx, Handle<TypedArrayObject*> code, HandleObject importObj,
     MutableHandleWasmInstanceObject instanceObj);

// These accessors can be used to probe JS values for being an exported wasm
// function.

extern bool
IsExportedFunction(JSFunction* fun);

extern bool
IsExportedWasmFunction(JSFunction* fun);

extern bool
IsExportedFunction(const Value& v, MutableHandleFunction f);

extern Instance&
ExportedFunctionToInstance(JSFunction* fun);

extern WasmInstanceObject*
ExportedFunctionToInstanceObject(JSFunction* fun);

extern uint32_t
ExportedFunctionToFuncIndex(JSFunction* fun);

} // namespace wasm

// The class of the WebAssembly global namespace object.

extern const Class WebAssemblyClass;

JSObject*
InitWebAssemblyClass(JSContext* cx, HandleObject global);

// The class of WebAssembly.Module. Each WasmModuleObject owns a
// wasm::Module. These objects are used both as content-facing JS objects and as
// internal implementation details of asm.js.

class WasmModuleObject : public NativeObject
{
    static const unsigned MODULE_SLOT = 0;
    static const ClassOps classOps_;
    static void finalize(FreeOp* fop, JSObject* obj);
    static bool imports(JSContext* cx, unsigned argc, Value* vp);
    static bool exports(JSContext* cx, unsigned argc, Value* vp);
    static bool customSections(JSContext* cx, unsigned argc, Value* vp);

  public:
    static const unsigned RESERVED_SLOTS = 1;
    static const Class class_;
    static const JSPropertySpec properties[];
    static const JSFunctionSpec methods[];
    static const JSFunctionSpec static_methods[];
    static bool construct(JSContext*, unsigned, Value*);

    static WasmModuleObject* create(JSContext* cx,
                                    wasm::Module& module,
                                    HandleObject proto = nullptr);
    wasm::Module& module() const;
};

// The class of WebAssembly.Instance. Each WasmInstanceObject owns a
// wasm::Instance. These objects are used both as content-facing JS objects and
// as internal implementation details of asm.js.

class WasmInstanceObject : public NativeObject
{
    static const unsigned INSTANCE_SLOT = 0;
    static const unsigned EXPORTS_OBJ_SLOT = 1;
    static const unsigned EXPORTS_SLOT = 2;
    static const unsigned SCOPES_SLOT = 3;
    static const ClassOps classOps_;
    static bool exportsGetterImpl(JSContext* cx, const CallArgs& args);
    static bool exportsGetter(JSContext* cx, unsigned argc, Value* vp);
    bool isNewborn() const;
    static void finalize(FreeOp* fop, JSObject* obj);
    static void trace(JSTracer* trc, JSObject* obj);

    // ExportMap maps from function index to exported function object.
    // This allows the instance to lazily create exported function
    // objects on demand (instead up-front for all table elements) while
    // correctly preserving observable function object identity.
    using ExportMap = GCHashMap<uint32_t,
                                HeapPtr<JSFunction*>,
                                DefaultHasher<uint32_t>,
                                SystemAllocPolicy>;
    ExportMap& exports() const;

    // WeakScopeMap maps from function index to js::Scope. This maps is weak
    // to avoid holding scope objects alive. The scopes are normally created
    // during debugging.
    using ScopeMap = GCHashMap<uint32_t,
                               ReadBarriered<WasmFunctionScope*>,
                               DefaultHasher<uint32_t>,
                               SystemAllocPolicy>;
    using WeakScopeMap = JS::WeakCache<ScopeMap>;
    WeakScopeMap& scopes() const;

  public:
    static const unsigned RESERVED_SLOTS = 4;
    static const Class class_;
    static const JSPropertySpec properties[];
    static const JSFunctionSpec methods[];
    static const JSFunctionSpec static_methods[];
    static bool construct(JSContext*, unsigned, Value*);

    static WasmInstanceObject* create(JSContext* cx,
                                      RefPtr<const wasm::Code> code,
                                      UniquePtr<wasm::DebugState> debug,
                                      UniquePtr<wasm::GlobalSegment> globals,
                                      HandleWasmMemoryObject memory,
                                      Vector<RefPtr<wasm::Table>, 0, SystemAllocPolicy>&& tables,
                                      Handle<FunctionVector> funcImports,
                                      const wasm::ValVector& globalImports,
                                      HandleObject proto);
    void initExportsObj(JSObject& exportsObj);

    wasm::Instance& instance() const;
    JSObject& exportsObj() const;

    static bool getExportedFunction(JSContext* cx,
                                    HandleWasmInstanceObject instanceObj,
                                    uint32_t funcIndex,
                                    MutableHandleFunction fun);

    const wasm::CodeRange& getExportedFunctionCodeRange(HandleFunction fun, wasm::Tier tier);

    static WasmFunctionScope* getFunctionScope(JSContext* cx,
                                               HandleWasmInstanceObject instanceObj,
                                               uint32_t funcIndex);
};

// The class of WebAssembly.Memory. A WasmMemoryObject references an ArrayBuffer
// or SharedArrayBuffer object which owns the actual memory.

class WasmMemoryObject : public NativeObject
{
    static const unsigned BUFFER_SLOT = 0;
    static const unsigned OBSERVERS_SLOT = 1;
    static const ClassOps classOps_;
    static void finalize(FreeOp* fop, JSObject* obj);
    static bool bufferGetterImpl(JSContext* cx, const CallArgs& args);
    static bool bufferGetter(JSContext* cx, unsigned argc, Value* vp);
    static bool growImpl(JSContext* cx, const CallArgs& args);
    static bool grow(JSContext* cx, unsigned argc, Value* vp);

    using InstanceSet = GCHashSet<ReadBarrieredWasmInstanceObject,
                                  MovableCellHasher<ReadBarrieredWasmInstanceObject>,
                                  SystemAllocPolicy>;
    using WeakInstanceSet = JS::WeakCache<InstanceSet>;
    bool hasObservers() const;
    WeakInstanceSet& observers() const;
    WeakInstanceSet* getOrCreateObservers(JSContext* cx);

  public:
    static const unsigned RESERVED_SLOTS = 2;
    static const Class class_;
    static const JSPropertySpec properties[];
    static const JSFunctionSpec methods[];
    static const JSFunctionSpec static_methods[];
    static bool construct(JSContext*, unsigned, Value*);

    static WasmMemoryObject* create(JSContext* cx,
                                    Handle<ArrayBufferObjectMaybeShared*> buffer,
                                    HandleObject proto);
    ArrayBufferObjectMaybeShared& buffer() const;

    bool movingGrowable() const;
    bool addMovingGrowObserver(JSContext* cx, WasmInstanceObject* instance);
    static uint32_t grow(HandleWasmMemoryObject memory, uint32_t delta, JSContext* cx);
};

// The class of WebAssembly.Table. A WasmTableObject holds a refcount on a
// wasm::Table, allowing a Table to be shared between multiple Instances
// (eventually between multiple threads).

class WasmTableObject : public NativeObject
{
    static const unsigned TABLE_SLOT = 0;
    static const ClassOps classOps_;
    bool isNewborn() const;
    static void finalize(FreeOp* fop, JSObject* obj);
    static void trace(JSTracer* trc, JSObject* obj);
    static bool lengthGetterImpl(JSContext* cx, const CallArgs& args);
    static bool lengthGetter(JSContext* cx, unsigned argc, Value* vp);
    static bool getImpl(JSContext* cx, const CallArgs& args);
    static bool get(JSContext* cx, unsigned argc, Value* vp);
    static bool setImpl(JSContext* cx, const CallArgs& args);
    static bool set(JSContext* cx, unsigned argc, Value* vp);
    static bool growImpl(JSContext* cx, const CallArgs& args);
    static bool grow(JSContext* cx, unsigned argc, Value* vp);

  public:
    static const unsigned RESERVED_SLOTS = 1;
    static const Class class_;
    static const JSPropertySpec properties[];
    static const JSFunctionSpec methods[];
    static const JSFunctionSpec static_methods[];
    static bool construct(JSContext*, unsigned, Value*);

    // Note that, after creation, a WasmTableObject's table() is not initialized
    // and must be initialized before use.

    static WasmTableObject* create(JSContext* cx, const wasm::Limits& limits);
    wasm::Table& table() const;
};

} // namespace js

#endif // wasm_js_h
