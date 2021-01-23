/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/UniquePtr.h"
#include "mozilla/Unused.h"

#include "gc/GCRuntime.h"
#include "js/ArrayBuffer.h"  // JS::NewArrayBuffer
#include "js/RootingAPI.h"
#include "jsapi-tests/tests.h"
#include "vm/Runtime.h"

#include "vm/JSContext-inl.h"

using namespace js;

// A heap-allocated structure containing one of our barriered pointer wrappers
// to test.
template <typename W, typename T>
struct TestStruct {
  W wrapper;

  void trace(JSTracer* trc) {
    TraceNullableEdge(trc, &wrapper, "TestStruct::wrapper");
  }

  TestStruct() {}
  explicit TestStruct(T init) : wrapper(init) {}
};

// Give the GCPtr version GCManagedDeletePolicy as required.
namespace JS {

template <typename T>
struct DeletePolicy<TestStruct<js::GCPtr<T>, T>>
    : public js::GCManagedDeletePolicy<TestStruct<js::GCPtr<T>, T>> {};

template <typename T>
struct DeletePolicy<TestStruct<const js::GCPtr<T>, T>>
    : public js::GCManagedDeletePolicy<TestStruct<const js::GCPtr<T>, T>> {};

}  // namespace JS

template <typename T>
static T* CreateNurseryGCThing(JSContext* cx) {
  MOZ_CRASH();
  return nullptr;
}

template <>
JSObject* CreateNurseryGCThing(JSContext* cx) {
  JS::RootedObject obj(cx, JS_NewPlainObject(cx));
  if (!obj) {
    return nullptr;
  }
  JS_DefineProperty(cx, obj, "x", 42, 0);
  MOZ_ASSERT(IsInsideNursery(obj));
  return obj;
}

template <>
JSFunction* CreateNurseryGCThing(JSContext* cx) {
  /*
   * We don't actually use the function as a function, so here we cheat and
   * cast a JSObject.
   */
  return static_cast<JSFunction*>(CreateNurseryGCThing<JSObject>(cx));
}

template <typename T>
static T* CreateTenuredGCThing(JSContext* cx) {
  MOZ_CRASH();
  return nullptr;
}

template <>
JSObject* CreateTenuredGCThing(JSContext* cx) {
  // Use ArrayBuffers because they have finalizers, which allows using them in
  // TenuredHeap<> without awkward conversations about nursery allocatability.
  // Note that at some point ArrayBuffers might become nursery allocated at
  // which point this test will have to change.
  JSObject* obj = JS::NewArrayBuffer(cx, 20);
  MOZ_ASSERT(!IsInsideNursery(obj));
  MOZ_ASSERT(obj->getClass()->hasFinalize() &&
             !(obj->getClass()->flags & JSCLASS_SKIP_NURSERY_FINALIZE));
  return obj;
}

static void MakeWhite(JSObject* obj) {
  gc::TenuredCell* cell = &obj->asTenured();
  cell->unmark();
  MOZ_ASSERT(!obj->isMarkedAny());
}

static void MakeGray(JSObject* obj) {
  gc::TenuredCell* cell = &obj->asTenured();
  cell->unmark();
  cell->markIfUnmarked(gc::MarkColor::Gray);
  MOZ_ASSERT(obj->isMarkedGray());
}

// Test post-barrier implementation on wrapper types. The following wrapper
// types have post barriers:
//  - JS::Heap
//  - GCPtr
//  - HeapPtr
//  - WeakHeapPtr
BEGIN_TEST(testGCHeapPostBarriers) {
#ifdef JS_GC_ZEAL
  AutoLeaveZeal nozeal(cx);
#endif /* JS_GC_ZEAL */

  /* Sanity check - objects start in the nursery and then become tenured. */
  JS_GC(cx);
  JS::RootedObject obj(cx, CreateNurseryGCThing<JSObject>(cx));
  CHECK(js::gc::IsInsideNursery(obj.get()));
  JS_GC(cx);
  CHECK(!js::gc::IsInsideNursery(obj.get()));
  JS::RootedObject tenuredObject(cx, obj);

  /* JSObject and JSFunction objects are nursery allocated. */
  CHECK(TestHeapPostBarriersForType<JSObject>());
  CHECK(TestHeapPostBarriersForType<JSFunction>());
  // Bug 1599378: Add string tests.

  return true;
}

bool CanAccessObject(JSObject* obj) {
  JS::RootedObject rootedObj(cx, obj);
  JS::RootedValue value(cx);
  CHECK(JS_GetProperty(cx, rootedObj, "x", &value));
  CHECK(value.isInt32());
  CHECK(value.toInt32() == 42);
  return true;
}

template <typename T>
bool TestHeapPostBarriersForType() {
  CHECK((TestHeapPostBarriersForWrapper<js::GCPtr, T>()));
  CHECK((TestHeapPostBarriersForMovableWrapper<JS::Heap, T>()));
  CHECK((TestHeapPostBarriersForMovableWrapper<js::HeapPtr, T>()));
  CHECK((TestHeapPostBarriersForMovableWrapper<js::WeakHeapPtr, T>()));
  return true;
}

template <template <typename> class W, typename T>
bool TestHeapPostBarriersForMovableWrapper() {
  CHECK((TestHeapPostBarriersForWrapper<W, T>()));
  CHECK((TestHeapPostBarrierMoveConstruction<W<T*>, T>()));
  CHECK((TestHeapPostBarrierMoveAssignment<W<T*>, T>()));
  return true;
}

template <template <typename> class W, typename T>
bool TestHeapPostBarriersForWrapper() {
  CHECK((TestHeapPostBarrierConstruction<W<T*>, T>()));
  CHECK((TestHeapPostBarrierConstruction<const W<T*>, T>()));
  CHECK((TestHeapPostBarrierUpdate<W<T*>, T>()));
  CHECK((TestHeapPostBarrierInitFailure<W<T*>, T>()));
  CHECK((TestHeapPostBarrierInitFailure<const W<T*>, T>()));
  return true;
}

template <typename W, typename T>
bool TestHeapPostBarrierConstruction() {
  T* initialObj = CreateNurseryGCThing<T>(cx);
  CHECK(initialObj != nullptr);
  CHECK(js::gc::IsInsideNursery(initialObj));
  uintptr_t initialObjAsInt = uintptr_t(initialObj);

  {
    // We don't root our structure because that would end up tracing it on minor
    // GC and we're testing that heap post barrier works for things that aren't
    // roots.
    JS::AutoSuppressGCAnalysis noAnalysis(cx);

    auto testStruct = cx->make_unique<TestStruct<W, T*>>(initialObj);
    CHECK(testStruct);

    auto& wrapper = testStruct->wrapper;
    CHECK(wrapper == initialObj);

    cx->minorGC(JS::GCReason::API);

    CHECK(uintptr_t(wrapper.get()) != initialObjAsInt);
    CHECK(!js::gc::IsInsideNursery(wrapper.get()));
    CHECK(CanAccessObject(wrapper.get()));
  }

  cx->minorGC(JS::GCReason::API);

  return true;
}

template <typename W, typename T>
bool TestHeapPostBarrierUpdate() {
  // Normal case - allocate a heap object, write a nursery pointer into it and
  // check that it gets updated on minor GC.

  T* initialObj = CreateNurseryGCThing<T>(cx);
  CHECK(initialObj != nullptr);
  CHECK(js::gc::IsInsideNursery(initialObj));
  uintptr_t initialObjAsInt = uintptr_t(initialObj);

  {
    // We don't root our structure because that would end up tracing it on minor
    // GC and we're testing that heap post barrier works for things that aren't
    // roots.
    JS::AutoSuppressGCAnalysis noAnalysis(cx);

    auto testStruct = cx->make_unique<TestStruct<W, T*>>();
    CHECK(testStruct);

    auto& wrapper = testStruct->wrapper;
    CHECK(wrapper.get() == nullptr);

    wrapper = initialObj;
    CHECK(wrapper == initialObj);

    cx->minorGC(JS::GCReason::API);

    CHECK(uintptr_t(wrapper.get()) != initialObjAsInt);
    CHECK(!js::gc::IsInsideNursery(wrapper.get()));
    CHECK(CanAccessObject(wrapper.get()));
  }

  cx->minorGC(JS::GCReason::API);

  return true;
}

template <typename W, typename T>
bool TestHeapPostBarrierInitFailure() {
  // Failure case - allocate a heap object, write a nursery pointer into it
  // and fail to complete initialization.

  T* initialObj = CreateNurseryGCThing<T>(cx);
  CHECK(initialObj != nullptr);
  CHECK(js::gc::IsInsideNursery(initialObj));

  {
    // We don't root our structure because that would end up tracing it on minor
    // GC and we're testing that heap post barrier works for things that aren't
    // roots.
    JS::AutoSuppressGCAnalysis noAnalysis(cx);

    auto testStruct = cx->make_unique<TestStruct<W, T*>>(initialObj);
    CHECK(testStruct);

    auto& wrapper = testStruct->wrapper;
    CHECK(wrapper == initialObj);

    // testStruct deleted here, as if we left this block due to an error.
  }

  cx->minorGC(JS::GCReason::API);

  return true;
}

template <typename W, typename T>
bool TestHeapPostBarrierMoveConstruction() {
  T* initialObj = CreateNurseryGCThing<T>(cx);
  CHECK(initialObj != nullptr);
  CHECK(js::gc::IsInsideNursery(initialObj));
  uintptr_t initialObjAsInt = uintptr_t(initialObj);

  {
    // We don't root our structure because that would end up tracing it on minor
    // GC and we're testing that heap post barrier works for things that aren't
    // roots.
    JS::AutoSuppressGCAnalysis noAnalysis(cx);

    W wrapper1(initialObj);
    CHECK(wrapper1 == initialObj);

    W wrapper2(std::move(wrapper1));
    CHECK(wrapper2 == initialObj);

    cx->minorGC(JS::GCReason::API);

    CHECK(uintptr_t(wrapper1.get()) != initialObjAsInt);
    CHECK(uintptr_t(wrapper2.get()) != initialObjAsInt);
    CHECK(!js::gc::IsInsideNursery(wrapper2.get()));
    CHECK(CanAccessObject(wrapper2.get()));
  }

  cx->minorGC(JS::GCReason::API);

  return true;
}

template <typename W, typename T>
bool TestHeapPostBarrierMoveAssignment() {
  T* initialObj = CreateNurseryGCThing<T>(cx);
  CHECK(initialObj != nullptr);
  CHECK(js::gc::IsInsideNursery(initialObj));
  uintptr_t initialObjAsInt = uintptr_t(initialObj);

  {
    // We don't root our structure because that would end up tracing it on minor
    // GC and we're testing that heap post barrier works for things that aren't
    // roots.
    JS::AutoSuppressGCAnalysis noAnalysis(cx);

    W wrapper1(initialObj);
    CHECK(wrapper1 == initialObj);

    W wrapper2;
    wrapper2 = std::move(wrapper1);
    CHECK(wrapper2 == initialObj);

    cx->minorGC(JS::GCReason::API);

    CHECK(uintptr_t(wrapper1.get()) != initialObjAsInt);
    CHECK(uintptr_t(wrapper2.get()) != initialObjAsInt);
    CHECK(!js::gc::IsInsideNursery(wrapper2.get()));
    CHECK(CanAccessObject(wrapper2.get()));
  }

  cx->minorGC(JS::GCReason::API);

  return true;
}

END_TEST(testGCHeapPostBarriers)

// Test read barrier implementation on wrapper types. The following wrapper
// types have read barriers:
//  - JS::Heap
//  - JS::TenuredHeap
//  - WeakHeapPtr
//
// Also check that equality comparisons on wrappers do not trigger the read
// barrier.
BEGIN_TEST(testGCHeapReadBarriers) {
#ifdef JS_GC_ZEAL
  AutoLeaveZeal nozeal(cx);
#endif /* JS_GC_ZEAL */

  CHECK((TestWrapperType<JS::Heap<JSObject*>, JSObject*>()));
  CHECK((TestWrapperType<JS::TenuredHeap<JSObject*>, JSObject*>()));
  CHECK((TestWrapperType<WeakHeapPtr<JSObject*>, JSObject*>()));

  return true;
}

template <typename WrapperT, typename ObjectT>
bool TestWrapperType() {
  // Check that the read barrier normally marks gray things black.
  {
    Rooted<ObjectT> obj0(cx, CreateTenuredGCThing<JSObject>(cx));
    WrapperT wrapper0(obj0);
    MakeGray(obj0);
    mozilla::Unused << *wrapper0;
    CHECK(obj0->isMarkedBlack());
  }

  // Allocate test objects and make them gray. We will make sure they stay
  // gray. (For most reads, the barrier will unmark gray.)
  Rooted<ObjectT> obj1(cx, CreateTenuredGCThing<JSObject>(cx));
  Rooted<ObjectT> obj2(cx, CreateTenuredGCThing<JSObject>(cx));
  MakeGray(obj1);
  MakeGray(obj2);

  WrapperT wrapper1(obj1);
  WrapperT wrapper2(obj2);
  const ObjectT constobj1 = obj1;
  const ObjectT constobj2 = obj2;
  CHECK((TestUnbarrieredOperations<WrapperT, ObjectT>(obj1, obj2, wrapper1,
                                                      wrapper2)));
  CHECK((TestUnbarrieredOperations<WrapperT, ObjectT>(constobj1, constobj2,
                                                      wrapper1, wrapper2)));

  return true;
}

template <typename WrapperT, typename ObjectT>
bool TestUnbarrieredOperations(ObjectT obj, ObjectT obj2, WrapperT& wrapper,
                               WrapperT& wrapper2) {
  mozilla::Unused << bool(wrapper);
  mozilla::Unused << bool(wrapper2);
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());

  int x = 0;

  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += obj == obj2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += obj == wrapper2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += wrapper == obj2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += wrapper == wrapper2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());

  CHECK(x == 0);

  x += obj != obj2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += obj != wrapper2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += wrapper != obj2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());
  x += wrapper != wrapper2;
  CHECK(obj->isMarkedGray());
  CHECK(obj2->isMarkedGray());

  CHECK(x == 4);

  return true;
}

END_TEST(testGCHeapReadBarriers)

// Test pre-barrier implementation on wrapper types. The following wrapper types
// have a pre-barrier:
//  - GCPtr
//  - HeapPtr
//  - PreBarriered
BEGIN_TEST(testGCHeapPreBarriers) {
#ifdef JS_GC_ZEAL
  AutoLeaveZeal nozeal(cx);
#endif /* JS_GC_ZEAL */

  uint32_t oldMode = JS_GetGCParameter(cx, JSGC_MODE);
  JS_SetGCParameter(cx, JSGC_MODE, JSGC_MODE_ZONE_INCREMENTAL);

  RootedObject obj1(cx, CreateTenuredGCThing<JSObject>(cx));
  RootedObject obj2(cx, CreateTenuredGCThing<JSObject>(cx));
  CHECK(obj1);
  CHECK(obj2);

  // Start an incremental GC so we can detect if we cause barriers to fire, as
  // these will mark objects black.
  JS::PrepareForFullGC(cx);
  SliceBudget budget(WorkBudget(1));
  gc::GCRuntime* gc = &cx->runtime()->gc;
  gc->startDebugGC(GC_NORMAL, budget);
  MOZ_ASSERT(cx->zone()->needsIncrementalBarrier());

  TestWrapper<HeapPtr<JSObject*>>(obj1, obj2);
  TestWrapper<PreBarriered<JSObject*>>(obj1, obj2);

  // GCPtr is different because 1) it doesn't support move operations as it's
  // supposed to be part of a GC thing and 2) it doesn't perform a pre-barrier
  // in its destructor because these are only destroyed as part of a GC where
  // the barrier is unnecessary.
  TestGCPtr(obj1, obj2);

  gc::FinishGC(cx, JS::GCReason::API);

  JS_SetGCParameter(cx, JSGC_MODE, oldMode);

  return true;
}

template <typename Wrapper>
bool TestWrapper(HandleObject obj1, HandleObject obj2) {
  CHECK(TestCopyConstruction<Wrapper>(obj1));
  CHECK(TestMoveConstruction<Wrapper>(obj1));
  CHECK(TestAssignment<Wrapper>(obj1, obj2));
  CHECK(TestMoveAssignment<Wrapper>(obj1, obj2));
  return true;
}

template <typename Wrapper>
bool TestCopyConstruction(HandleObject obj) {
  MakeWhite(obj);

  {
    Wrapper wrapper1(obj);
    Wrapper wrapper2(wrapper1);
    CHECK(wrapper1 == obj);
    CHECK(wrapper2 == obj);
    CHECK(!obj->isMarkedAny());
  }

  // Check destructor performs pre-barrier.
  MOZ_ASSERT(obj->isMarkedBlack());

  return true;
}

template <typename Wrapper>
bool TestMoveConstruction(HandleObject obj) {
  MakeWhite(obj);

  {
    Wrapper wrapper1(obj);
    MakeGray(obj);  // Check that we allow move of gray GC thing.
    Wrapper wrapper2(std::move(wrapper1));
    CHECK(!wrapper1);
    CHECK(wrapper2 == obj);
    CHECK(obj->isMarkedGray());
  }

  // Check destructor performs pre-barrier.
  CHECK(obj->isMarkedBlack());

  return true;
}

template <typename Wrapper>
bool TestAssignment(HandleObject obj1, HandleObject obj2) {
  MakeWhite(obj1);
  MakeWhite(obj2);

  {
    Wrapper wrapper1(obj1);
    Wrapper wrapper2(obj2);

    wrapper2 = wrapper1;

    CHECK(wrapper1 == obj1);
    CHECK(wrapper2 == obj1);
    CHECK(!obj1->isMarkedAny());   // No barrier fired.
    CHECK(obj2->isMarkedBlack());  // Pre barrier fired.
  }

  // Check destructor performs pre-barrier.
  CHECK(obj1->isMarkedBlack());

  return true;
}

template <typename Wrapper>
bool TestMoveAssignment(HandleObject obj1, HandleObject obj2) {
  MakeWhite(obj1);
  MakeWhite(obj2);

  {
    Wrapper wrapper1(obj1);
    Wrapper wrapper2(obj2);

    MakeGray(obj1);  // Check we allow move of gray thing.
    wrapper2 = std::move(wrapper1);

    CHECK(!wrapper1);
    CHECK(wrapper2 == obj1);
    CHECK(obj1->isMarkedGray());   // No barrier fired.
    CHECK(obj2->isMarkedBlack());  // Pre barrier fired.
  }

  // Check destructor performs pre-barrier.
  CHECK(obj1->isMarkedBlack());

  return true;
}

bool TestGCPtr(HandleObject obj1, HandleObject obj2) {
  CHECK(TestGCPtrCopyConstruction(obj1));
  CHECK(TestGCPtrAssignment(obj1, obj2));
  return true;
}

bool TestGCPtrCopyConstruction(HandleObject obj) {
  MakeWhite(obj);

  {
    // Let us destroy GCPtrs ourselves for testing purposes.
    gc::AutoSetThreadIsFinalizing threadIsFinalizing;

    GCPtrObject wrapper1(obj);
    GCPtrObject wrapper2(wrapper1);
    CHECK(wrapper1 == obj);
    CHECK(wrapper2 == obj);
    CHECK(!obj->isMarkedAny());
  }

  // GCPtr doesn't perform pre-barrier in destructor.
  CHECK(!obj->isMarkedAny());

  return true;
}

bool TestGCPtrAssignment(HandleObject obj1, HandleObject obj2) {
  MakeWhite(obj1);
  MakeWhite(obj2);

  {
    // Let us destroy GCPtrs ourselves for testing purposes.
    gc::AutoSetThreadIsFinalizing threadIsFinalizing;

    GCPtrObject wrapper1(obj1);
    GCPtrObject wrapper2(obj2);

    wrapper2 = wrapper1;

    CHECK(wrapper1 == obj1);
    CHECK(wrapper2 == obj1);
    CHECK(!obj1->isMarkedAny());   // No barrier fired.
    CHECK(obj2->isMarkedBlack());  // Pre barrier fired.
  }

  // GCPtr doesn't perform pre-barrier in destructor.
  CHECK(!obj1->isMarkedAny());

  return true;
}

END_TEST(testGCHeapPreBarriers)
