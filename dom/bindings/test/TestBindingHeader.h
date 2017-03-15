/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#ifndef TestBindingHeader_h
#define TestBindingHeader_h

#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/Date.h"
#include "mozilla/dom/MozMap.h"
#include "mozilla/dom/TypedArray.h"
#include "mozilla/ErrorResult.h"
#include "nsCOMPtr.h"
#include "nsGenericHTMLElement.h"
#include "nsWrapperCache.h"

// Forward declare this before we include TestCodeGenBinding.h, because that header relies on including
// this one for it, for ParentDict. Hopefully it won't begin to rely on it in more fundamental ways.
namespace mozilla {
namespace dom {
class TestExternalInterface;
class Promise;
} // namespace dom
} // namespace mozilla

// We don't export TestCodeGenBinding.h, but it's right in our parent dir.
#include "../TestCodeGenBinding.h"

extern bool TestFuncControlledMember(JSContext*, JSObject*);

namespace mozilla {
namespace dom {

// IID for nsRenamedInterface
#define NS_RENAMED_INTERFACE_IID \
{ 0xd4b19ef3, 0xe68b, 0x4e3f, \
 { 0x94, 0xbc, 0xc9, 0xde, 0x3a, 0x69, 0xb0, 0xe8 } }

class nsRenamedInterface : public nsISupports,
                           public nsWrapperCache
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_RENAMED_INTERFACE_IID)
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsRenamedInterface, NS_RENAMED_INTERFACE_IID)

// IID for the IndirectlyImplementedInterface
#define NS_INDIRECTLY_IMPLEMENTED_INTERFACE_IID \
{ 0xfed55b69, 0x7012, 0x4849, \
 { 0xaf, 0x56, 0x4b, 0xa9, 0xee, 0x41, 0x30, 0x89 } }

class IndirectlyImplementedInterface : public nsISupports,
                                       public nsWrapperCache
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_INDIRECTLY_IMPLEMENTED_INTERFACE_IID)
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  bool IndirectlyImplementedProperty();
  void IndirectlyImplementedProperty(bool);
  void IndirectlyImplementedMethod();
};

NS_DEFINE_STATIC_IID_ACCESSOR(IndirectlyImplementedInterface, NS_INDIRECTLY_IMPLEMENTED_INTERFACE_IID)

// IID for the TestExternalInterface
#define NS_TEST_EXTERNAL_INTERFACE_IID \
{ 0xd5ba0c99, 0x9b1d, 0x4e71, \
 { 0x8a, 0x94, 0x56, 0x38, 0x6c, 0xa3, 0xda, 0x3d } }
class TestExternalInterface : public nsISupports
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_TEST_EXTERNAL_INTERFACE_IID)
  NS_DECL_ISUPPORTS
};

NS_DEFINE_STATIC_IID_ACCESSOR(TestExternalInterface, NS_TEST_EXTERNAL_INTERFACE_IID)

class TestNonWrapperCacheInterface : public nsISupports
{
public:
  NS_DECL_ISUPPORTS

  bool WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto, JS::MutableHandle<JSObject*> aReflector);
};

class OnlyForUseInConstructor : public nsISupports,
                                public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS
  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();
};

class TestInterface : public nsISupports,
                      public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  // And now our actual WebIDL API
  // Constructors
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, const nsAString&, ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, uint32_t, const Nullable<bool>&,
                ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, TestInterface*, ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, uint32_t, IndirectlyImplementedInterface&, ErrorResult&);

  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, Date&, ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, const ArrayBuffer&, ErrorResult&);
  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, const Uint8Array&, ErrorResult&);
  /*  static
  already_AddRefed<TestInterface>
    Constructor(const GlobalObject&, uint32_t, uint32_t,
                const TestInterfaceOrOnlyForUseInConstructor&, ErrorResult&);
  */

  static
  already_AddRefed<TestInterface> Test(const GlobalObject&, ErrorResult&);
  static
  already_AddRefed<TestInterface> Test(const GlobalObject&, const nsAString&,
                                       ErrorResult&);
  static
  already_AddRefed<TestInterface> Test(const GlobalObject&, const nsACString&,
                                       ErrorResult&);

  static
  already_AddRefed<TestInterface> Test2(const GlobalObject&,
                                        const DictForConstructor&,
                                        JS::Handle<JS::Value>,
                                        JS::Handle<JSObject*>,
                                        JS::Handle<JSObject*>,
                                        const Sequence<Dict>&,
                                        JS::Handle<JS::Value>,
                                        const Optional<JS::Handle<JSObject*> >&,
                                        const Optional<JS::Handle<JSObject*> >&,
                                        ErrorResult&);

  static
  already_AddRefed<TestInterface> Test3(const GlobalObject&,
                                        const LongOrAnyMozMap&,
                                        ErrorResult&);

  // Integer types
  int8_t ReadonlyByte();
  int8_t WritableByte();
  void SetWritableByte(int8_t);
  void PassByte(int8_t);
  int8_t ReceiveByte();
  void PassOptionalByte(const Optional<int8_t>&);
  void PassOptionalByteBeforeRequired(const Optional<int8_t>&, int8_t);
  void PassOptionalByteWithDefault(int8_t);
  void PassOptionalByteWithDefaultBeforeRequired(int8_t, int8_t);
  void PassNullableByte(const Nullable<int8_t>&);
  void PassOptionalNullableByte(const Optional< Nullable<int8_t> >&);
  void PassVariadicByte(const Sequence<int8_t>&);
  int8_t CachedByte();
  int8_t CachedConstantByte();
  int8_t CachedWritableByte();
  void SetCachedWritableByte(int8_t);
  int8_t SideEffectFreeByte();
  int8_t SetSideEffectFreeByte(int8_t);
  int8_t DomDependentByte();
  int8_t SetDomDependentByte(int8_t);
  int8_t ConstantByte();
  int8_t DeviceStateDependentByte();
  int8_t ReturnByteSideEffectFree();
  int8_t ReturnDOMDependentByte();
  int8_t ReturnConstantByte();
  int8_t ReturnDeviceStateDependentByte();

  void UnsafePrerenderMethod();
  int32_t UnsafePrerenderWritable();
  void SetUnsafePrerenderWritable(int32_t);
  int32_t UnsafePrerenderReadonly();
  int16_t ReadonlyShort();
  int16_t WritableShort();
  void SetWritableShort(int16_t);
  void PassShort(int16_t);
  int16_t ReceiveShort();
  void PassOptionalShort(const Optional<int16_t>&);
  void PassOptionalShortWithDefault(int16_t);

  int32_t ReadonlyLong();
  int32_t WritableLong();
  void SetWritableLong(int32_t);
  void PassLong(int32_t);
  int16_t ReceiveLong();
  void PassOptionalLong(const Optional<int32_t>&);
  void PassOptionalLongWithDefault(int32_t);

  int64_t ReadonlyLongLong();
  int64_t WritableLongLong();
  void SetWritableLongLong(int64_t);
  void PassLongLong(int64_t);
  int64_t ReceiveLongLong();
  void PassOptionalLongLong(const Optional<int64_t>&);
  void PassOptionalLongLongWithDefault(int64_t);

  uint8_t ReadonlyOctet();
  uint8_t WritableOctet();
  void SetWritableOctet(uint8_t);
  void PassOctet(uint8_t);
  uint8_t ReceiveOctet();
  void PassOptionalOctet(const Optional<uint8_t>&);
  void PassOptionalOctetWithDefault(uint8_t);

  uint16_t ReadonlyUnsignedShort();
  uint16_t WritableUnsignedShort();
  void SetWritableUnsignedShort(uint16_t);
  void PassUnsignedShort(uint16_t);
  uint16_t ReceiveUnsignedShort();
  void PassOptionalUnsignedShort(const Optional<uint16_t>&);
  void PassOptionalUnsignedShortWithDefault(uint16_t);

  uint32_t ReadonlyUnsignedLong();
  uint32_t WritableUnsignedLong();
  void SetWritableUnsignedLong(uint32_t);
  void PassUnsignedLong(uint32_t);
  uint32_t ReceiveUnsignedLong();
  void PassOptionalUnsignedLong(const Optional<uint32_t>&);
  void PassOptionalUnsignedLongWithDefault(uint32_t);

  uint64_t ReadonlyUnsignedLongLong();
  uint64_t WritableUnsignedLongLong();
  void SetWritableUnsignedLongLong(uint64_t);
  void PassUnsignedLongLong(uint64_t);
  uint64_t ReceiveUnsignedLongLong();
  void PassOptionalUnsignedLongLong(const Optional<uint64_t>&);
  void PassOptionalUnsignedLongLongWithDefault(uint64_t);

  float WritableFloat() const;
  void SetWritableFloat(float);
  float WritableUnrestrictedFloat() const;
  void SetWritableUnrestrictedFloat(float);
  Nullable<float> GetWritableNullableFloat() const;
  void SetWritableNullableFloat(Nullable<float>);
  Nullable<float> GetWritableNullableUnrestrictedFloat() const;
  void SetWritableNullableUnrestrictedFloat(Nullable<float>);
  double WritableDouble() const;
  void SetWritableDouble(double);
  double WritableUnrestrictedDouble() const;
  void SetWritableUnrestrictedDouble(double);
  Nullable<double> GetWritableNullableDouble() const;
  void SetWritableNullableDouble(Nullable<double>);
  Nullable<double> GetWritableNullableUnrestrictedDouble() const;
  void SetWritableNullableUnrestrictedDouble(Nullable<double>);
  void PassFloat(float, float, Nullable<float>, Nullable<float>,
                 double, double, Nullable<double>, Nullable<double>,
                 const Sequence<float>&, const Sequence<float>&,
                 const Sequence<Nullable<float> >&,
                 const Sequence<Nullable<float> >&,
                 const Sequence<double>&, const Sequence<double>&,
                 const Sequence<Nullable<double> >&,
                 const Sequence<Nullable<double> >&);
  void PassLenientFloat(float, float, Nullable<float>, Nullable<float>,
                        double, double, Nullable<double>, Nullable<double>,
                        const Sequence<float>&, const Sequence<float>&,
                        const Sequence<Nullable<float> >&,
                        const Sequence<Nullable<float> >&,
                        const Sequence<double>&, const Sequence<double>&,
                        const Sequence<Nullable<double> >&,
                        const Sequence<Nullable<double> >&);
  float LenientFloatAttr() const;
  void SetLenientFloatAttr(float);
  double LenientDoubleAttr() const;
  void SetLenientDoubleAttr(double);

  void PassUnrestricted(float arg1,
                        float arg2,
                        float arg3,
                        float arg4,
                        double arg5,
                        double arg6,
                        double arg7,
                        double arg8);

  // Interface types
  already_AddRefed<TestInterface> ReceiveSelf();
  already_AddRefed<TestInterface> ReceiveNullableSelf();
  TestInterface* ReceiveWeakSelf();
  TestInterface* ReceiveWeakNullableSelf();
  void PassSelf(TestInterface&);
  void PassNullableSelf(TestInterface*);
  already_AddRefed<TestInterface> NonNullSelf();
  void SetNonNullSelf(TestInterface&);
  already_AddRefed<TestInterface> GetNullableSelf();
  already_AddRefed<TestInterface> CachedSelf();
  void SetNullableSelf(TestInterface*);
  void PassOptionalSelf(const Optional<TestInterface*> &);
  void PassOptionalNonNullSelf(const Optional<NonNull<TestInterface> >&);
  void PassOptionalSelfWithDefault(TestInterface*);

  already_AddRefed<TestNonWrapperCacheInterface> ReceiveNonWrapperCacheInterface();
  already_AddRefed<TestNonWrapperCacheInterface> ReceiveNullableNonWrapperCacheInterface();
  void ReceiveNonWrapperCacheInterfaceSequence(nsTArray<RefPtr<TestNonWrapperCacheInterface> >&);
  void ReceiveNullableNonWrapperCacheInterfaceSequence(nsTArray<RefPtr<TestNonWrapperCacheInterface> >&);
  void ReceiveNonWrapperCacheInterfaceNullableSequence(Nullable<nsTArray<RefPtr<TestNonWrapperCacheInterface> > >&);
  void ReceiveNullableNonWrapperCacheInterfaceNullableSequence(Nullable<nsTArray<RefPtr<TestNonWrapperCacheInterface> > >&);

  already_AddRefed<IndirectlyImplementedInterface> ReceiveOther();
  already_AddRefed<IndirectlyImplementedInterface> ReceiveNullableOther();
  IndirectlyImplementedInterface* ReceiveWeakOther();
  IndirectlyImplementedInterface* ReceiveWeakNullableOther();
  void PassOther(IndirectlyImplementedInterface&);
  void PassNullableOther(IndirectlyImplementedInterface*);
  already_AddRefed<IndirectlyImplementedInterface> NonNullOther();
  void SetNonNullOther(IndirectlyImplementedInterface&);
  already_AddRefed<IndirectlyImplementedInterface> GetNullableOther();
  void SetNullableOther(IndirectlyImplementedInterface*);
  void PassOptionalOther(const Optional<IndirectlyImplementedInterface*>&);
  void PassOptionalNonNullOther(const Optional<NonNull<IndirectlyImplementedInterface> >&);
  void PassOptionalOtherWithDefault(IndirectlyImplementedInterface*);

  already_AddRefed<TestExternalInterface> ReceiveExternal();
  already_AddRefed<TestExternalInterface> ReceiveNullableExternal();
  TestExternalInterface* ReceiveWeakExternal();
  TestExternalInterface* ReceiveWeakNullableExternal();
  void PassExternal(TestExternalInterface*);
  void PassNullableExternal(TestExternalInterface*);
  already_AddRefed<TestExternalInterface> NonNullExternal();
  void SetNonNullExternal(TestExternalInterface*);
  already_AddRefed<TestExternalInterface> GetNullableExternal();
  void SetNullableExternal(TestExternalInterface*);
  void PassOptionalExternal(const Optional<TestExternalInterface*>&);
  void PassOptionalNonNullExternal(const Optional<TestExternalInterface*>&);
  void PassOptionalExternalWithDefault(TestExternalInterface*);

  already_AddRefed<TestCallbackInterface> ReceiveCallbackInterface();
  already_AddRefed<TestCallbackInterface> ReceiveNullableCallbackInterface();
  TestCallbackInterface* ReceiveWeakCallbackInterface();
  TestCallbackInterface* ReceiveWeakNullableCallbackInterface();
  void PassCallbackInterface(TestCallbackInterface&);
  void PassNullableCallbackInterface(TestCallbackInterface*);
  already_AddRefed<TestCallbackInterface> NonNullCallbackInterface();
  void SetNonNullCallbackInterface(TestCallbackInterface&);
  already_AddRefed<TestCallbackInterface> GetNullableCallbackInterface();
  void SetNullableCallbackInterface(TestCallbackInterface*);
  void PassOptionalCallbackInterface(const Optional<RefPtr<TestCallbackInterface> >&);
  void PassOptionalNonNullCallbackInterface(const Optional<OwningNonNull<TestCallbackInterface> >&);
  void PassOptionalCallbackInterfaceWithDefault(TestCallbackInterface*);

  already_AddRefed<IndirectlyImplementedInterface> ReceiveConsequentialInterface();
  void PassConsequentialInterface(IndirectlyImplementedInterface&);

  // Sequence types
  void GetReadonlySequence(nsTArray<int32_t>&);
  void GetReadonlySequenceOfDictionaries(JSContext*, nsTArray<Dict>&);
  void GetReadonlyNullableSequenceOfDictionaries(JSContext*, Nullable<nsTArray<Dict> >&);
  void GetReadonlyFrozenSequence(JSContext*, nsTArray<Dict>&);
  void GetReadonlyFrozenNullableSequence(JSContext*, Nullable<nsTArray<Dict>>&);
  void ReceiveSequence(nsTArray<int32_t>&);
  void ReceiveNullableSequence(Nullable< nsTArray<int32_t> >&);
  void ReceiveSequenceOfNullableInts(nsTArray< Nullable<int32_t> >&);
  void ReceiveNullableSequenceOfNullableInts(Nullable< nsTArray< Nullable<int32_t> > >&);
  void PassSequence(const Sequence<int32_t> &);
  void PassNullableSequence(const Nullable< Sequence<int32_t> >&);
  void PassSequenceOfNullableInts(const Sequence<Nullable<int32_t> >&);
  void PassOptionalSequenceOfNullableInts(const Optional<Sequence<Nullable<int32_t> > > &);
  void PassOptionalNullableSequenceOfNullableInts(const Optional<Nullable<Sequence<Nullable<int32_t> > > > &);
  void ReceiveCastableObjectSequence(nsTArray< RefPtr<TestInterface> > &);
  void ReceiveCallbackObjectSequence(nsTArray< RefPtr<TestCallbackInterface> > &);
  void ReceiveNullableCastableObjectSequence(nsTArray< RefPtr<TestInterface> > &);
  void ReceiveNullableCallbackObjectSequence(nsTArray< RefPtr<TestCallbackInterface> > &);
  void ReceiveCastableObjectNullableSequence(Nullable< nsTArray< RefPtr<TestInterface> > >&);
  void ReceiveNullableCastableObjectNullableSequence(Nullable< nsTArray< RefPtr<TestInterface> > >&);
  void ReceiveWeakCastableObjectSequence(nsTArray<RefPtr<TestInterface>> &);
  void ReceiveWeakNullableCastableObjectSequence(nsTArray<RefPtr<TestInterface>> &);
  void ReceiveWeakCastableObjectNullableSequence(Nullable< nsTArray<RefPtr<TestInterface>> >&);
  void ReceiveWeakNullableCastableObjectNullableSequence(Nullable< nsTArray<RefPtr<TestInterface>> >&);
  void PassCastableObjectSequence(const Sequence< OwningNonNull<TestInterface> >&);
  void PassNullableCastableObjectSequence(const Sequence< RefPtr<TestInterface> > &);
  void PassCastableObjectNullableSequence(const Nullable< Sequence< OwningNonNull<TestInterface> > >&);
  void PassNullableCastableObjectNullableSequence(const Nullable< Sequence< RefPtr<TestInterface> > >&);
  void PassOptionalSequence(const Optional<Sequence<int32_t> >&);
  void PassOptionalSequenceWithDefaultValue(const Sequence<int32_t> &);
  void PassOptionalNullableSequence(const Optional<Nullable<Sequence<int32_t> > >&);
  void PassOptionalNullableSequenceWithDefaultValue(const Nullable< Sequence<int32_t> >&);
  void PassOptionalNullableSequenceWithDefaultValue2(const Nullable< Sequence<int32_t> >&);
  void PassOptionalObjectSequence(const Optional<Sequence<OwningNonNull<TestInterface> > >&);
  void PassExternalInterfaceSequence(const Sequence<RefPtr<TestExternalInterface> >&);
  void PassNullableExternalInterfaceSequence(const Sequence<RefPtr<TestExternalInterface> >&);

  void ReceiveStringSequence(nsTArray<nsString>&);
  void PassStringSequence(const Sequence<nsString>&);

  void ReceiveByteStringSequence(nsTArray<nsCString>&);
  void PassByteStringSequence(const Sequence<nsCString>&);

  void ReceiveAnySequence(JSContext*, nsTArray<JS::Value>&);
  void ReceiveNullableAnySequence(JSContext*, Nullable<nsTArray<JS::Value> >&);
  void ReceiveAnySequenceSequence(JSContext*, nsTArray<nsTArray<JS::Value> >&);

  void ReceiveObjectSequence(JSContext*, nsTArray<JSObject*>&);
  void ReceiveNullableObjectSequence(JSContext*, nsTArray<JSObject*>&);

  void PassSequenceOfSequences(const Sequence< Sequence<int32_t> >&);
  void PassSequenceOfSequencesOfSequences(const Sequence<Sequence<Sequence<int32_t>>>&);
  void ReceiveSequenceOfSequences(nsTArray< nsTArray<int32_t> >&);
  void ReceiveSequenceOfSequencesOfSequences(nsTArray<nsTArray<nsTArray<int32_t>>>&);

  // MozMap types
  void PassMozMap(const MozMap<int32_t> &);
  void PassNullableMozMap(const Nullable< MozMap<int32_t> >&);
  void PassMozMapOfNullableInts(const MozMap<Nullable<int32_t> >&);
  void PassOptionalMozMapOfNullableInts(const Optional<MozMap<Nullable<int32_t> > > &);
  void PassOptionalNullableMozMapOfNullableInts(const Optional<Nullable<MozMap<Nullable<int32_t> > > > &);
  void PassCastableObjectMozMap(const MozMap< OwningNonNull<TestInterface> >&);
  void PassNullableCastableObjectMozMap(const MozMap< RefPtr<TestInterface> > &);
  void PassCastableObjectNullableMozMap(const Nullable< MozMap< OwningNonNull<TestInterface> > >&);
  void PassNullableCastableObjectNullableMozMap(const Nullable< MozMap< RefPtr<TestInterface> > >&);
  void PassOptionalMozMap(const Optional<MozMap<int32_t> >&);
  void PassOptionalNullableMozMap(const Optional<Nullable<MozMap<int32_t> > >&);
  void PassOptionalNullableMozMapWithDefaultValue(const Nullable< MozMap<int32_t> >&);
  void PassOptionalObjectMozMap(const Optional<MozMap<OwningNonNull<TestInterface> > >&);
  void PassExternalInterfaceMozMap(const MozMap<RefPtr<TestExternalInterface> >&);
  void PassNullableExternalInterfaceMozMap(const MozMap<RefPtr<TestExternalInterface> >&);
  void PassStringMozMap(const MozMap<nsString>&);
  void PassByteStringMozMap(const MozMap<nsCString>&);
  void PassMozMapOfMozMaps(const MozMap< MozMap<int32_t> >&);
  void ReceiveMozMap(MozMap<int32_t>&);
  void ReceiveNullableMozMap(Nullable<MozMap<int32_t>>&);
  void ReceiveMozMapOfNullableInts(MozMap<Nullable<int32_t>>&);
  void ReceiveNullableMozMapOfNullableInts(Nullable<MozMap<Nullable<int32_t>>>&);
  void ReceiveMozMapOfMozMaps(MozMap<MozMap<int32_t>>&);
  void ReceiveAnyMozMap(JSContext*, MozMap<JS::Value>&);

  // Typed array types
  void PassArrayBuffer(const ArrayBuffer&);
  void PassNullableArrayBuffer(const Nullable<ArrayBuffer>&);
  void PassOptionalArrayBuffer(const Optional<ArrayBuffer>&);
  void PassOptionalNullableArrayBuffer(const Optional<Nullable<ArrayBuffer> >&);
  void PassOptionalNullableArrayBufferWithDefaultValue(const Nullable<ArrayBuffer>&);
  void PassArrayBufferView(const ArrayBufferView&);
  void PassInt8Array(const Int8Array&);
  void PassInt16Array(const Int16Array&);
  void PassInt32Array(const Int32Array&);
  void PassUint8Array(const Uint8Array&);
  void PassUint16Array(const Uint16Array&);
  void PassUint32Array(const Uint32Array&);
  void PassUint8ClampedArray(const Uint8ClampedArray&);
  void PassFloat32Array(const Float32Array&);
  void PassFloat64Array(const Float64Array&);
  void PassSequenceOfArrayBuffers(const Sequence<ArrayBuffer>&);
  void PassSequenceOfNullableArrayBuffers(const Sequence<Nullable<ArrayBuffer> >&);
  void PassMozMapOfArrayBuffers(const MozMap<ArrayBuffer>&);
  void PassMozMapOfNullableArrayBuffers(const MozMap<Nullable<ArrayBuffer> >&);
  void PassVariadicTypedArray(const Sequence<Float32Array>&);
  void PassVariadicNullableTypedArray(const Sequence<Nullable<Float32Array> >&);
  void ReceiveUint8Array(JSContext*, JS::MutableHandle<JSObject*>);
  void SetUint8ArrayAttr(const Uint8Array&);
  void GetUint8ArrayAttr(JSContext*, JS::MutableHandle<JSObject*>);

  // DOMString types
  void PassString(const nsAString&);
  void PassNullableString(const nsAString&);
  void PassOptionalString(const Optional<nsAString>&);
  void PassOptionalStringWithDefaultValue(const nsAString&);
  void PassOptionalNullableString(const Optional<nsAString>&);
  void PassOptionalNullableStringWithDefaultValue(const nsAString&);
  void PassVariadicString(const Sequence<nsString>&);
  void ReceiveString(DOMString&);

  // ByteString types
  void PassByteString(const nsCString&);
  void PassNullableByteString(const nsCString&);
  void PassOptionalByteString(const Optional<nsCString>&);
  void PassOptionalByteStringWithDefaultValue(const nsCString&);
  void PassOptionalNullableByteString(const Optional<nsCString>&);
  void PassOptionalNullableByteStringWithDefaultValue(const nsCString&);
  void PassVariadicByteString(const Sequence<nsCString>&);
  void PassOptionalUnionByteString(const Optional<ByteStringOrLong>&);
  void PassOptionalUnionByteStringWithDefaultValue(const ByteStringOrLong&);

  // USVString types
  void PassUSVS(const nsAString&);
  void PassNullableUSVS(const nsAString&);
  void PassOptionalUSVS(const Optional<nsAString>&);
  void PassOptionalUSVSWithDefaultValue(const nsAString&);
  void PassOptionalNullableUSVS(const Optional<nsAString>&);
  void PassOptionalNullableUSVSWithDefaultValue(const nsAString&);
  void PassVariadicUSVS(const Sequence<nsString>&);
  void ReceiveUSVS(DOMString&);

  // Enumerated types
  void PassEnum(TestEnum);
  void PassNullableEnum(const Nullable<TestEnum>&);
  void PassOptionalEnum(const Optional<TestEnum>&);
  void PassEnumWithDefault(TestEnum);
  void PassOptionalNullableEnum(const Optional<Nullable<TestEnum> >&);
  void PassOptionalNullableEnumWithDefaultValue(const Nullable<TestEnum>&);
  void PassOptionalNullableEnumWithDefaultValue2(const Nullable<TestEnum>&);
  TestEnum ReceiveEnum();
  Nullable<TestEnum> ReceiveNullableEnum();
  TestEnum EnumAttribute();
  TestEnum ReadonlyEnumAttribute();
  void SetEnumAttribute(TestEnum);

  // Callback types
  void PassCallback(TestCallback&);
  void PassNullableCallback(TestCallback*);
  void PassOptionalCallback(const Optional<OwningNonNull<TestCallback> >&);
  void PassOptionalNullableCallback(const Optional<RefPtr<TestCallback> >&);
  void PassOptionalNullableCallbackWithDefaultValue(TestCallback*);
  already_AddRefed<TestCallback> ReceiveCallback();
  already_AddRefed<TestCallback> ReceiveNullableCallback();
  void PassNullableTreatAsNullCallback(TestTreatAsNullCallback*);
  void PassOptionalNullableTreatAsNullCallback(const Optional<RefPtr<TestTreatAsNullCallback> >&);
  void PassOptionalNullableTreatAsNullCallbackWithDefaultValue(TestTreatAsNullCallback*);
  void SetTreatAsNullCallback(TestTreatAsNullCallback&);
  already_AddRefed<TestTreatAsNullCallback> TreatAsNullCallback();
  void SetNullableTreatAsNullCallback(TestTreatAsNullCallback*);
  already_AddRefed<TestTreatAsNullCallback> GetNullableTreatAsNullCallback();

  void ForceCallbackGeneration(TestIntegerReturn&,
                               TestNullableIntegerReturn&,
                               TestBooleanReturn&,
                               TestFloatReturn&,
                               TestStringReturn&,
                               TestEnumReturn&,
                               TestInterfaceReturn&,
                               TestNullableInterfaceReturn&,
                               TestExternalInterfaceReturn&,
                               TestNullableExternalInterfaceReturn&,
                               TestCallbackInterfaceReturn&,
                               TestNullableCallbackInterfaceReturn&,
                               TestCallbackReturn&,
                               TestNullableCallbackReturn&,
                               TestObjectReturn&,
                               TestNullableObjectReturn&,
                               TestTypedArrayReturn&,
                               TestNullableTypedArrayReturn&,
                               TestSequenceReturn&,
                               TestNullableSequenceReturn&,
                               TestIntegerArguments&,
                               TestInterfaceArguments&,
                               TestStringEnumArguments&,
                               TestObjectArguments&,
                               TestOptionalArguments&);

  // Any types
  void PassAny(JSContext*, JS::Handle<JS::Value>);
  void PassVariadicAny(JSContext*, const Sequence<JS::Value>&);
  void PassOptionalAny(JSContext*, JS::Handle<JS::Value>);
  void PassAnyDefaultNull(JSContext*, JS::Handle<JS::Value>);
  void PassSequenceOfAny(JSContext*, const Sequence<JS::Value>&);
  void PassNullableSequenceOfAny(JSContext*, const Nullable<Sequence<JS::Value> >&);
  void PassOptionalSequenceOfAny(JSContext*, const Optional<Sequence<JS::Value> >&);
  void PassOptionalNullableSequenceOfAny(JSContext*, const Optional<Nullable<Sequence<JS::Value> > >&);
  void PassOptionalSequenceOfAnyWithDefaultValue(JSContext*, const Nullable<Sequence<JS::Value> >&);
  void PassSequenceOfSequenceOfAny(JSContext*, const Sequence<Sequence<JS::Value> >&);
  void PassSequenceOfNullableSequenceOfAny(JSContext*, const Sequence<Nullable<Sequence<JS::Value> > >&);
  void PassNullableSequenceOfNullableSequenceOfAny(JSContext*, const Nullable<Sequence<Nullable<Sequence<JS::Value> > > >&);
  void PassOptionalNullableSequenceOfNullableSequenceOfAny(JSContext*, const Optional<Nullable<Sequence<Nullable<Sequence<JS::Value> > > > >&);
  void PassMozMapOfAny(JSContext*, const MozMap<JS::Value>&);
  void PassNullableMozMapOfAny(JSContext*, const Nullable<MozMap<JS::Value> >&);
  void PassOptionalMozMapOfAny(JSContext*, const Optional<MozMap<JS::Value> >&);
  void PassOptionalNullableMozMapOfAny(JSContext*, const Optional<Nullable<MozMap<JS::Value> > >&);
  void PassOptionalMozMapOfAnyWithDefaultValue(JSContext*, const Nullable<MozMap<JS::Value> >&);
  void PassMozMapOfMozMapOfAny(JSContext*, const MozMap<MozMap<JS::Value> >&);
  void PassMozMapOfNullableMozMapOfAny(JSContext*, const MozMap<Nullable<MozMap<JS::Value> > >&);
  void PassNullableMozMapOfNullableMozMapOfAny(JSContext*, const Nullable<MozMap<Nullable<MozMap<JS::Value> > > >&);
  void PassOptionalNullableMozMapOfNullableMozMapOfAny(JSContext*, const Optional<Nullable<MozMap<Nullable<MozMap<JS::Value>>>>>&);
  void PassOptionalNullableMozMapOfNullableSequenceOfAny(JSContext*, const Optional<Nullable<MozMap<Nullable<Sequence<JS::Value>>>>>&);
  void PassOptionalNullableSequenceOfNullableMozMapOfAny(JSContext*, const Optional<Nullable<Sequence<Nullable<MozMap<JS::Value>>>>>&);
  void ReceiveAny(JSContext*, JS::MutableHandle<JS::Value>);

  // object types
  void PassObject(JSContext*, JS::Handle<JSObject*>);
  void PassVariadicObject(JSContext*, const Sequence<JSObject*>&);
  void PassNullableObject(JSContext*, JS::Handle<JSObject*>);
  void PassVariadicNullableObject(JSContext*, const Sequence<JSObject*>&);
  void PassOptionalObject(JSContext*, const Optional<JS::Handle<JSObject*> >&);
  void PassOptionalNullableObject(JSContext*, const Optional<JS::Handle<JSObject*> >&);
  void PassOptionalNullableObjectWithDefaultValue(JSContext*, JS::Handle<JSObject*>);
  void PassSequenceOfObject(JSContext*, const Sequence<JSObject*>&);
  void PassSequenceOfNullableObject(JSContext*, const Sequence<JSObject*>&);
  void PassNullableSequenceOfObject(JSContext*, const Nullable<Sequence<JSObject*> >&);
  void PassOptionalNullableSequenceOfNullableSequenceOfObject(JSContext*, const Optional<Nullable<Sequence<Nullable<Sequence<JSObject*> > > > >&);
  void PassOptionalNullableSequenceOfNullableSequenceOfNullableObject(JSContext*, const Optional<Nullable<Sequence<Nullable<Sequence<JSObject*> > > > >&);
  void PassMozMapOfObject(JSContext*, const MozMap<JSObject*>&);
  void ReceiveObject(JSContext*, JS::MutableHandle<JSObject*>);
  void ReceiveNullableObject(JSContext*, JS::MutableHandle<JSObject*>);

  // Union types
  void PassUnion(JSContext*, const ObjectOrLong& arg);
  void PassUnionWithNullable(JSContext* cx, const ObjectOrNullOrLong& arg)
  {
    OwningObjectOrLong returnValue;
    if (arg.IsNull()) {
    } else if (arg.IsObject()) {
      JS::Rooted<JSObject*> obj(cx, arg.GetAsObject());
      JS_GetClass(obj);
      returnValue.SetAsObject() = obj;
    } else {
      int32_t i = arg.GetAsLong();
      i += 1;
      returnValue.SetAsLong() = i;
    }
  }
#ifdef DEBUG
  void PassUnion2(const LongOrBoolean& arg);
  void PassUnion3(JSContext*, const ObjectOrLongOrBoolean& arg);
  void PassUnion4(const NodeOrLongOrBoolean& arg);
  void PassUnion5(JSContext*, const ObjectOrBoolean& arg);
  void PassUnion6(JSContext*, const ObjectOrString& arg);
  void PassUnion7(JSContext*, const ObjectOrStringOrLong& arg);
  void PassUnion8(JSContext*, const ObjectOrStringOrBoolean& arg);
  void PassUnion9(JSContext*, const ObjectOrStringOrLongOrBoolean& arg);
  void PassUnion10(const EventInitOrLong& arg);
  void PassUnion11(JSContext*, const CustomEventInitOrLong& arg);
  void PassUnion12(const EventInitOrLong& arg);
  void PassUnion13(JSContext*, const ObjectOrLongOrNull& arg);
  void PassUnion14(JSContext*, const ObjectOrLongOrNull& arg);
  void PassUnion15(const LongSequenceOrLong&);
  void PassUnion16(const Optional<LongSequenceOrLong>&);
  void PassUnion17(const LongSequenceOrNullOrLong&);
  void PassUnion18(JSContext*, const ObjectSequenceOrLong&);
  void PassUnion19(JSContext*, const Optional<ObjectSequenceOrLong>&);
  void PassUnion20(JSContext*, const ObjectSequenceOrLong&);
  void PassUnion21(const LongMozMapOrLong&);
  void PassUnion22(JSContext*, const ObjectMozMapOrLong&);
  void PassUnion23(const ImageDataSequenceOrLong&);
  void PassUnion24(const ImageDataOrNullSequenceOrLong&);
  void PassUnion25(const ImageDataSequenceSequenceOrLong&);
  void PassUnion26(const ImageDataOrNullSequenceSequenceOrLong&);
  void PassUnion27(const StringSequenceOrEventInit&);
  void PassUnion28(const EventInitOrStringSequence&);
  void PassUnionWithCallback(const EventHandlerNonNullOrNullOrLong& arg);
  void PassUnionWithByteString(const ByteStringOrLong&);
  void PassUnionWithMozMap(const StringMozMapOrString&);
  void PassUnionWithMozMapAndSequence(const StringMozMapOrStringSequence&);
  void PassUnionWithSequenceAndMozMap(const StringSequenceOrStringMozMap&);
  void PassUnionWithUSVS(const USVStringOrLong&);
#endif
  void PassNullableUnion(JSContext*, const Nullable<ObjectOrLong>&);
  void PassOptionalUnion(JSContext*, const Optional<ObjectOrLong>&);
  void PassOptionalNullableUnion(JSContext*, const Optional<Nullable<ObjectOrLong> >&);
  void PassOptionalNullableUnionWithDefaultValue(JSContext*, const Nullable<ObjectOrLong>&);
  //void PassUnionWithInterfaces(const TestInterfaceOrTestExternalInterface& arg);
  //void PassUnionWithInterfacesAndNullable(const TestInterfaceOrNullOrTestExternalInterface& arg);
  void PassUnionWithArrayBuffer(const ArrayBufferOrLong&);
  void PassUnionWithString(JSContext*, const StringOrObject&);
  void PassUnionWithEnum(JSContext*, const SupportedTypeOrObject&);
  //void PassUnionWithCallback(JSContext*, const TestCallbackOrLong&);
  void PassUnionWithObject(JSContext*, const ObjectOrLong&);

  void PassUnionWithDefaultValue1(const DoubleOrString& arg);
  void PassUnionWithDefaultValue2(const DoubleOrString& arg);
  void PassUnionWithDefaultValue3(const DoubleOrString& arg);
  void PassUnionWithDefaultValue4(const FloatOrString& arg);
  void PassUnionWithDefaultValue5(const FloatOrString& arg);
  void PassUnionWithDefaultValue6(const FloatOrString& arg);
  void PassUnionWithDefaultValue7(const UnrestrictedDoubleOrString& arg);
  void PassUnionWithDefaultValue8(const UnrestrictedDoubleOrString& arg);
  void PassUnionWithDefaultValue9(const UnrestrictedDoubleOrString& arg);
  void PassUnionWithDefaultValue10(const UnrestrictedDoubleOrString& arg);
  void PassUnionWithDefaultValue11(const UnrestrictedFloatOrString& arg);
  void PassUnionWithDefaultValue12(const UnrestrictedFloatOrString& arg);
  void PassUnionWithDefaultValue13(const UnrestrictedFloatOrString& arg);
  void PassUnionWithDefaultValue14(const DoubleOrByteString& arg);
  void PassUnionWithDefaultValue15(const DoubleOrByteString& arg);
  void PassUnionWithDefaultValue16(const DoubleOrByteString& arg);
  void PassUnionWithDefaultValue17(const DoubleOrSupportedType& arg);
  void PassUnionWithDefaultValue18(const DoubleOrSupportedType& arg);
  void PassUnionWithDefaultValue19(const DoubleOrSupportedType& arg);

  void PassNullableUnionWithDefaultValue1(const Nullable<DoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue2(const Nullable<DoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue3(const Nullable<DoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue4(const Nullable<FloatOrString>& arg);
  void PassNullableUnionWithDefaultValue5(const Nullable<FloatOrString>& arg);
  void PassNullableUnionWithDefaultValue6(const Nullable<FloatOrString>& arg);
  void PassNullableUnionWithDefaultValue7(const Nullable<UnrestrictedDoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue8(const Nullable<UnrestrictedDoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue9(const Nullable<UnrestrictedDoubleOrString>& arg);
  void PassNullableUnionWithDefaultValue10(const Nullable<UnrestrictedFloatOrString>& arg);
  void PassNullableUnionWithDefaultValue11(const Nullable<UnrestrictedFloatOrString>& arg);
  void PassNullableUnionWithDefaultValue12(const Nullable<UnrestrictedFloatOrString>& arg);
  void PassNullableUnionWithDefaultValue13(const Nullable<DoubleOrByteString>& arg);
  void PassNullableUnionWithDefaultValue14(const Nullable<DoubleOrByteString>& arg);
  void PassNullableUnionWithDefaultValue15(const Nullable<DoubleOrByteString>& arg);
  void PassNullableUnionWithDefaultValue16(const Nullable<DoubleOrByteString>& arg);
  void PassNullableUnionWithDefaultValue17(const Nullable<DoubleOrSupportedType>& arg);
  void PassNullableUnionWithDefaultValue18(const Nullable<DoubleOrSupportedType>& arg);
  void PassNullableUnionWithDefaultValue19(const Nullable<DoubleOrSupportedType>& arg);
  void PassNullableUnionWithDefaultValue20(const Nullable<DoubleOrSupportedType>& arg);

  void PassSequenceOfUnions(const Sequence<OwningCanvasPatternOrCanvasGradient>&);
  void PassSequenceOfUnions2(JSContext*, const Sequence<OwningObjectOrLong>&);
  void PassVariadicUnion(const Sequence<OwningCanvasPatternOrCanvasGradient>&);

  void PassSequenceOfNullableUnions(const Sequence<Nullable<OwningCanvasPatternOrCanvasGradient>>&);
  void PassVariadicNullableUnion(const Sequence<Nullable<OwningCanvasPatternOrCanvasGradient>>&);
  void PassMozMapOfUnions(const MozMap<OwningCanvasPatternOrCanvasGradient>&);
  void PassMozMapOfUnions2(JSContext*, const MozMap<OwningObjectOrLong>&);

  void ReceiveUnion(OwningCanvasPatternOrCanvasGradient&);
  void ReceiveUnion2(JSContext*, OwningObjectOrLong&);
  void ReceiveUnionContainingNull(OwningCanvasPatternOrNullOrCanvasGradient&);
  void ReceiveNullableUnion(Nullable<OwningCanvasPatternOrCanvasGradient>&);
  void ReceiveNullableUnion2(JSContext*, Nullable<OwningObjectOrLong>&);
  void GetWritableUnion(OwningCanvasPatternOrCanvasGradient&);
  void SetWritableUnion(const CanvasPatternOrCanvasGradient&);
  void GetWritableUnionContainingNull(OwningCanvasPatternOrNullOrCanvasGradient&);
  void SetWritableUnionContainingNull(const CanvasPatternOrNullOrCanvasGradient&);
  void GetWritableNullableUnion(Nullable<OwningCanvasPatternOrCanvasGradient>&);
  void SetWritableNullableUnion(const Nullable<CanvasPatternOrCanvasGradient>&);

  // Date types
  void PassDate(Date);
  void PassNullableDate(const Nullable<Date>&);
  void PassOptionalDate(const Optional<Date>&);
  void PassOptionalNullableDate(const Optional<Nullable<Date> >&);
  void PassOptionalNullableDateWithDefaultValue(const Nullable<Date>&);
  void PassDateSequence(const Sequence<Date>&);
  void PassDateMozMap(const MozMap<Date>&);
  void PassNullableDateSequence(const Sequence<Nullable<Date> >&);
  Date ReceiveDate();
  Nullable<Date> ReceiveNullableDate();

  // Promise types
  void PassPromise(Promise&);
  void PassNullablePromise(Promise*);
  void PassOptionalPromise(const Optional<OwningNonNull<Promise>>&);
  void PassOptionalNullablePromise(const Optional<RefPtr<Promise>>&);
  void PassOptionalNullablePromiseWithDefaultValue(Promise*);
  void PassPromiseSequence(const Sequence<OwningNonNull<Promise>>&);
  void PassPromiseMozMap(const MozMap<RefPtr<Promise>>&);
  void PassNullablePromiseSequence(const Sequence<RefPtr<Promise>> &);
  Promise* ReceivePromise();
  already_AddRefed<Promise> ReceiveAddrefedPromise();

  // binaryNames tests
  void MethodRenamedTo();
  void OtherMethodRenamedTo();
  void MethodRenamedTo(int8_t);
  int8_t AttributeGetterRenamedTo();
  int8_t AttributeRenamedTo();
  void SetAttributeRenamedTo(int8_t);
  int8_t OtherAttributeRenamedTo();
  void SetOtherAttributeRenamedTo(int8_t);

  // Dictionary tests
  void PassDictionary(JSContext*, const Dict&);
  void PassDictionary2(JSContext*, const Dict&);
  void GetReadonlyDictionary(JSContext*, Dict&);
  void GetReadonlyNullableDictionary(JSContext*, Nullable<Dict>&);
  void GetWritableDictionary(JSContext*, Dict&);
  void SetWritableDictionary(JSContext*, const Dict&);
  void GetReadonlyFrozenDictionary(JSContext*, Dict&);
  void GetReadonlyFrozenNullableDictionary(JSContext*, Nullable<Dict>&);
  void GetWritableFrozenDictionary(JSContext*, Dict&);
  void SetWritableFrozenDictionary(JSContext*, const Dict&);
  void ReceiveDictionary(JSContext*, Dict&);
  void ReceiveNullableDictionary(JSContext*, Nullable<Dict>&);
  void PassOtherDictionary(const GrandparentDict&);
  void PassSequenceOfDictionaries(JSContext*, const Sequence<Dict>&);
  void PassMozMapOfDictionaries(const MozMap<GrandparentDict>&);
  void PassDictionaryOrLong(JSContext*, const Dict&);
  void PassDictionaryOrLong(int32_t);
  void PassDictContainingDict(JSContext*, const DictContainingDict&);
  void PassDictContainingSequence(JSContext*, const DictContainingSequence&);
  void ReceiveDictContainingSequence(JSContext*, DictContainingSequence&);
  void PassVariadicDictionary(JSContext*, const Sequence<Dict>&);

  // Typedefs
  void ExerciseTypedefInterfaces1(TestInterface&);
  already_AddRefed<TestInterface> ExerciseTypedefInterfaces2(TestInterface*);
  void ExerciseTypedefInterfaces3(TestInterface&);

  // Deprecated methods and attributes
  int8_t DeprecatedAttribute();
  int8_t SetDeprecatedAttribute(int8_t);
  int8_t DeprecatedMethod();
  int8_t DeprecatedMethodWithContext(JSContext*, const JS::Value&);

  // Static methods and attributes
  static void StaticMethod(const GlobalObject&, bool);
  static void StaticMethodWithContext(const GlobalObject&, const JS::Value&);
  static bool StaticAttribute(const GlobalObject&);
  static void SetStaticAttribute(const GlobalObject&, bool);
  static void Assert(const GlobalObject&, bool);

  // Deprecated static methods and attributes
  static int8_t StaticDeprecatedAttribute(const GlobalObject&);
  static int8_t SetStaticDeprecatedAttribute(const GlobalObject&, int8_t);
  static int8_t StaticDeprecatedMethod(const GlobalObject&);
  static int8_t StaticDeprecatedMethodWithContext(const GlobalObject&, const JS::Value&);

  // Overload resolution tests
  bool Overload1(TestInterface&);
  TestInterface* Overload1(const nsAString&, TestInterface&);
  void Overload2(TestInterface&);
  void Overload2(JSContext*, const Dict&);
  void Overload2(bool);
  void Overload2(const nsAString&);
  void Overload2(Date);
  void Overload3(TestInterface&);
  void Overload3(const TestCallback&);
  void Overload3(bool);
  void Overload4(TestInterface&);
  void Overload4(TestCallbackInterface&);
  void Overload4(const nsAString&);
  void Overload5(int32_t);
  void Overload5(TestEnum);
  void Overload6(int32_t);
  void Overload6(bool);
  void Overload7(int32_t);
  void Overload7(bool);
  void Overload7(const nsCString&);
  void Overload8(int32_t);
  void Overload8(TestInterface&);
  void Overload9(const Nullable<int32_t>&);
  void Overload9(const nsAString&);
  void Overload10(const Nullable<int32_t>&);
  void Overload10(JSContext*, JS::Handle<JSObject*>);
  void Overload11(int32_t);
  void Overload11(const nsAString&);
  void Overload12(int32_t);
  void Overload12(const Nullable<bool>&);
  void Overload13(const Nullable<int32_t>&);
  void Overload13(bool);
  void Overload14(const Optional<int32_t>&);
  void Overload14(TestInterface&);
  void Overload15(int32_t);
  void Overload15(const Optional<NonNull<TestInterface> >&);
  void Overload16(int32_t);
  void Overload16(const Optional<TestInterface*>&);
  void Overload17(const Sequence<int32_t>&);
  void Overload17(const MozMap<int32_t>&);
  void Overload18(const MozMap<nsString>&);
  void Overload18(const Sequence<nsString>&);
  void Overload19(const Sequence<int32_t>&);
  void Overload19(JSContext*, const Dict&);
  void Overload20(JSContext*, const Dict&);
  void Overload20(const Sequence<int32_t>&);
  
  // Variadic handling
  void PassVariadicThirdArg(const nsAString&, int32_t,
                            const Sequence<OwningNonNull<TestInterface> >&);

  // Conditionally exposed methods/attributes
  bool Prefable1();
  bool Prefable2();
  bool Prefable3();
  bool Prefable4();
  bool Prefable5();
  bool Prefable6();
  bool Prefable7();
  bool Prefable8();
  bool Prefable9();
  void Prefable10();
  void Prefable11();
  bool Prefable12();
  void Prefable13();
  bool Prefable14();
  bool Prefable15();
  bool Prefable16();
  void Prefable17();
  void Prefable18();
  void Prefable19();
  void Prefable20();
  void Prefable21();
  void Prefable22();
  void Prefable23();
  void Prefable24();

  // Conditionally exposed methods/attributes involving [SecureContext]
  bool ConditionalOnSecureContext1();
  bool ConditionalOnSecureContext2();
  bool ConditionalOnSecureContext3();
  bool ConditionalOnSecureContext4();
  void ConditionalOnSecureContext5();
  void ConditionalOnSecureContext6();
  void ConditionalOnSecureContext7();
  void ConditionalOnSecureContext8();

  // Miscellania
  int32_t AttrWithLenientThis();
  void SetAttrWithLenientThis(int32_t);
  uint32_t UnforgeableAttr();
  uint32_t UnforgeableAttr2();
  uint32_t UnforgeableMethod();
  uint32_t UnforgeableMethod2();
  void Stringify(nsString&);
  void PassRenamedInterface(nsRenamedInterface&);
  TestInterface* PutForwardsAttr();
  TestInterface* PutForwardsAttr2();
  TestInterface* PutForwardsAttr3();
  void GetJsonifierShouldSkipThis(JSContext*, JS::MutableHandle<JS::Value>);
  void SetJsonifierShouldSkipThis(JSContext*, JS::Rooted<JS::Value>&);
  TestParentInterface* JsonifierShouldSkipThis2();
  void SetJsonifierShouldSkipThis2(TestParentInterface&);
  TestCallbackInterface* JsonifierShouldSkipThis3();
  void SetJsonifierShouldSkipThis3(TestCallbackInterface&);
  void ThrowingMethod(ErrorResult& aRv);
  bool GetThrowingAttr(ErrorResult& aRv) const;
  void SetThrowingAttr(bool arg, ErrorResult& aRv);
  bool GetThrowingGetterAttr(ErrorResult& aRv) const;
  void SetThrowingGetterAttr(bool arg);
  bool ThrowingSetterAttr() const;
  void SetThrowingSetterAttr(bool arg, ErrorResult& aRv);
  void NeedsSubjectPrincipalMethod(nsIPrincipal&);
  bool NeedsSubjectPrincipalAttr(nsIPrincipal&);
  void SetNeedsSubjectPrincipalAttr(bool, nsIPrincipal&);
  void NeedsCallerTypeMethod(CallerType);
  bool NeedsCallerTypeAttr(CallerType);
  void SetNeedsCallerTypeAttr(bool, CallerType);
  int16_t LegacyCall(const JS::Value&, uint32_t, TestInterface&);
  void PassArgsWithDefaults(JSContext*, const Optional<int32_t>&,
                            TestInterface*, const Dict&, double,
                            const Optional<float>&);

  void SetDashed_attribute(int8_t);
  int8_t Dashed_attribute();
  void Dashed_method();

  // Methods and properties imported via "implements"
  bool ImplementedProperty();
  void SetImplementedProperty(bool);
  void ImplementedMethod();
  bool ImplementedParentProperty();
  void SetImplementedParentProperty(bool);
  void ImplementedParentMethod();
  bool IndirectlyImplementedProperty();
  void SetIndirectlyImplementedProperty(bool);
  void IndirectlyImplementedMethod();
  uint32_t DiamondImplementedProperty();

  // Test EnforceRange/Clamp
  void DontEnforceRangeOrClamp(int8_t);
  void DoEnforceRange(int8_t);
  void DoClamp(int8_t);
  void SetEnforcedByte(int8_t);
  int8_t EnforcedByte();
  void SetClampedByte(int8_t);
  int8_t ClampedByte();

private:
  // We add signatures here that _could_ start matching if the codegen
  // got data types wrong.  That way if it ever does we'll have a call
  // to these private deleted methods and compilation will fail.
  void SetReadonlyByte(int8_t) = delete;
  template<typename T>
  void SetWritableByte(T) = delete;
  template<typename T>
  void PassByte(T) = delete;
  void PassNullableByte(Nullable<int8_t>&) = delete;
  template<typename T>
  void PassOptionalByte(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalByteWithDefault(T) = delete;
  void PassVariadicByte(Sequence<int8_t>&) = delete;

  void SetReadonlyShort(int16_t) = delete;
  template<typename T>
  void SetWritableShort(T) = delete;
  template<typename T>
  void PassShort(T) = delete;
  template<typename T>
  void PassOptionalShort(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalShortWithDefault(T) = delete;

  void SetReadonlyLong(int32_t) = delete;
  template<typename T>
  void SetWritableLong(T) = delete;
  template<typename T>
  void PassLong(T) = delete;
  template<typename T>
  void PassOptionalLong(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalLongWithDefault(T) = delete;

  void SetReadonlyLongLong(int64_t) = delete;
  template<typename T>
  void SetWritableLongLong(T) = delete;
  template<typename T>
  void PassLongLong(T) = delete;
  template<typename T>
  void PassOptionalLongLong(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalLongLongWithDefault(T) = delete;

  void SetReadonlyOctet(uint8_t) = delete;
  template<typename T>
  void SetWritableOctet(T) = delete;
  template<typename T>
  void PassOctet(T) = delete;
  template<typename T>
  void PassOptionalOctet(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalOctetWithDefault(T) = delete;

  void SetReadonlyUnsignedShort(uint16_t) = delete;
  template<typename T>
  void SetWritableUnsignedShort(T) = delete;
  template<typename T>
  void PassUnsignedShort(T) = delete;
  template<typename T>
  void PassOptionalUnsignedShort(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalUnsignedShortWithDefault(T) = delete;

  void SetReadonlyUnsignedLong(uint32_t) = delete;
  template<typename T>
  void SetWritableUnsignedLong(T) = delete;
  template<typename T>
  void PassUnsignedLong(T) = delete;
  template<typename T>
  void PassOptionalUnsignedLong(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalUnsignedLongWithDefault(T) = delete;

  void SetReadonlyUnsignedLongLong(uint64_t) = delete;
  template<typename T>
  void SetWritableUnsignedLongLong(T) = delete;
  template<typename T>
  void PassUnsignedLongLong(T) = delete;
  template<typename T>
  void PassOptionalUnsignedLongLong(const Optional<T>&) = delete;
  template<typename T>
  void PassOptionalUnsignedLongLongWithDefault(T) = delete;

  // Enforce that only const things are passed for sequences
  void PassSequence(Sequence<int32_t> &) = delete;
  void PassNullableSequence(Nullable< Sequence<int32_t> >&) = delete;
  void PassOptionalNullableSequenceWithDefaultValue(Nullable< Sequence<int32_t> >&) = delete;
  void PassSequenceOfAny(JSContext*, Sequence<JS::Value>&) = delete;
  void PassNullableSequenceOfAny(JSContext*, Nullable<Sequence<JS::Value> >&) = delete;
  void PassOptionalSequenceOfAny(JSContext*, Optional<Sequence<JS::Value> >&) = delete;
  void PassOptionalNullableSequenceOfAny(JSContext*, Optional<Nullable<Sequence<JS::Value> > >&) = delete;
  void PassOptionalSequenceOfAnyWithDefaultValue(JSContext*, Nullable<Sequence<JS::Value> >&) = delete;
  void PassSequenceOfSequenceOfAny(JSContext*, Sequence<Sequence<JS::Value> >&) = delete;
  void PassSequenceOfNullableSequenceOfAny(JSContext*, Sequence<Nullable<Sequence<JS::Value> > >&) = delete;
  void PassNullableSequenceOfNullableSequenceOfAny(JSContext*, Nullable<Sequence<Nullable<Sequence<JS::Value> > > >&) = delete;
  void PassOptionalNullableSequenceOfNullableSequenceOfAny(JSContext*, Optional<Nullable<Sequence<Nullable<Sequence<JS::Value> > > > >&) = delete;
  void PassSequenceOfObject(JSContext*, Sequence<JSObject*>&) = delete;
  void PassSequenceOfNullableObject(JSContext*, Sequence<JSObject*>&) = delete;
  void PassOptionalNullableSequenceOfNullableSequenceOfObject(JSContext*, Optional<Nullable<Sequence<Nullable<Sequence<JSObject*> > > > >&) = delete;
  void PassOptionalNullableSequenceOfNullableSequenceOfNullableObject(JSContext*, Optional<Nullable<Sequence<Nullable<Sequence<JSObject*> > > > >&) = delete;

  // Enforce that only const things are passed for optional
  void PassOptionalByte(Optional<int8_t>&) = delete;
  void PassOptionalNullableByte(Optional<Nullable<int8_t> >&) = delete;
  void PassOptionalShort(Optional<int16_t>&) = delete;
  void PassOptionalLong(Optional<int32_t>&) = delete;
  void PassOptionalLongLong(Optional<int64_t>&) = delete;
  void PassOptionalOctet(Optional<uint8_t>&) = delete;
  void PassOptionalUnsignedShort(Optional<uint16_t>&) = delete;
  void PassOptionalUnsignedLong(Optional<uint32_t>&) = delete;
  void PassOptionalUnsignedLongLong(Optional<uint64_t>&) = delete;
  void PassOptionalSelf(Optional<TestInterface*> &) = delete;
  void PassOptionalNonNullSelf(Optional<NonNull<TestInterface> >&) = delete;
  void PassOptionalOther(Optional<IndirectlyImplementedInterface*>&);
  void PassOptionalNonNullOther(Optional<NonNull<IndirectlyImplementedInterface> >&);
  void PassOptionalExternal(Optional<TestExternalInterface*>&) = delete;
  void PassOptionalNonNullExternal(Optional<TestExternalInterface*>&) = delete;
  void PassOptionalSequence(Optional<Sequence<int32_t> >&) = delete;
  void PassOptionalNullableSequence(Optional<Nullable<Sequence<int32_t> > >&) = delete;
  void PassOptionalObjectSequence(Optional<Sequence<OwningNonNull<TestInterface> > >&) = delete;
  void PassOptionalArrayBuffer(Optional<ArrayBuffer>&) = delete;
  void PassOptionalNullableArrayBuffer(Optional<ArrayBuffer*>&) = delete;
  void PassOptionalEnum(Optional<TestEnum>&) = delete;
  void PassOptionalCallback(JSContext*, Optional<OwningNonNull<TestCallback> >&) = delete;
  void PassOptionalNullableCallback(JSContext*, Optional<RefPtr<TestCallback> >&) = delete;
  void PassOptionalAny(Optional<JS::Handle<JS::Value> >&) = delete;

  // And test that string stuff is always const
  void PassString(nsAString&) = delete;
  void PassNullableString(nsAString&) = delete;
  void PassOptionalString(Optional<nsAString>&) = delete;
  void PassOptionalStringWithDefaultValue(nsAString&) = delete;
  void PassOptionalNullableString(Optional<nsAString>&) = delete;
  void PassOptionalNullableStringWithDefaultValue(nsAString&) = delete;
  void PassVariadicString(Sequence<nsString>&) = delete;

  // cstrings should be const as well
  void PassByteString(nsCString&) = delete;
  void PassNullableByteString(nsCString&) = delete;
  void PassOptionalByteString(Optional<nsCString>&) = delete;
  void PassOptionalByteStringWithDefaultValue(nsCString&) = delete;
  void PassOptionalNullableByteString(Optional<nsCString>&) = delete;
  void PassOptionalNullableByteStringWithDefaultValue(nsCString&) = delete;
  void PassVariadicByteString(Sequence<nsCString>&) = delete;

  // Make sure dictionary arguments are always const
  void PassDictionary(JSContext*, Dict&) = delete;
  void PassOtherDictionary(GrandparentDict&) = delete;
  void PassSequenceOfDictionaries(JSContext*, Sequence<Dict>&) = delete;
  void PassDictionaryOrLong(JSContext*, Dict&) = delete;
  void PassDictContainingDict(JSContext*, DictContainingDict&) = delete;
  void PassDictContainingSequence(DictContainingSequence&) = delete;

  // Make sure various nullable things are always const
  void PassNullableEnum(Nullable<TestEnum>&) = delete;

  // Make sure unions are always const
  void PassUnion(JSContext*, ObjectOrLong& arg) = delete;
  void PassUnionWithNullable(JSContext*, ObjectOrNullOrLong& arg) = delete;
  void PassNullableUnion(JSContext*, Nullable<ObjectOrLong>&) = delete;
  void PassOptionalUnion(JSContext*, Optional<ObjectOrLong>&) = delete;
  void PassOptionalNullableUnion(JSContext*, Optional<Nullable<ObjectOrLong> >&) = delete;
  void PassOptionalNullableUnionWithDefaultValue(JSContext*, Nullable<ObjectOrLong>&) = delete;

  // Make sure various date stuff is const as needed
  void PassNullableDate(Nullable<Date>&) = delete;
  void PassOptionalDate(Optional<Date>&) = delete;
  void PassOptionalNullableDate(Optional<Nullable<Date> >&) = delete;
  void PassOptionalNullableDateWithDefaultValue(Nullable<Date>&) = delete;
  void PassDateSequence(Sequence<Date>&) = delete;
  void PassNullableDateSequence(Sequence<Nullable<Date> >&) = delete;

  // Make sure variadics are const as needed
  void PassVariadicAny(JSContext*, Sequence<JS::Value>&) = delete;
  void PassVariadicObject(JSContext*, Sequence<JSObject*>&) = delete;
  void PassVariadicNullableObject(JSContext*, Sequence<JSObject*>&) = delete;

  // Ensure NonNull does not leak in
  void PassSelf(NonNull<TestInterface>&) = delete;
  void PassSelf(OwningNonNull<TestInterface>&) = delete;
  void PassSelf(const NonNull<TestInterface>&) = delete;
  void PassSelf(const OwningNonNull<TestInterface>&) = delete;
  void PassOther(NonNull<IndirectlyImplementedInterface>&) = delete;
  void PassOther(const NonNull<IndirectlyImplementedInterface>&) = delete;
  void PassOther(OwningNonNull<IndirectlyImplementedInterface>&) = delete;
  void PassOther(const OwningNonNull<IndirectlyImplementedInterface>&) = delete;
  void PassCallbackInterface(OwningNonNull<TestCallbackInterface>&) = delete;
  void PassCallbackInterface(const OwningNonNull<TestCallbackInterface>&) = delete;
  void PassCallbackInterface(NonNull<TestCallbackInterface>&) = delete;
  void PassCallbackInterface(const NonNull<TestCallbackInterface>&) = delete;
  void PassCallback(OwningNonNull<TestCallback>&) = delete;
  void PassCallback(const OwningNonNull<TestCallback>&) = delete;
  void PassCallback(NonNull<TestCallback>&) = delete;
  void PassCallback(const NonNull<TestCallback>&) = delete;
  void PassString(const NonNull<nsAString>&) = delete;
  void PassString(NonNull<nsAString>&) = delete;
  void PassString(const OwningNonNull<nsAString>&) = delete;
  void PassString(OwningNonNull<nsAString>&) = delete;
};

class TestIndexedGetterInterface : public nsISupports,
                                   public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  uint32_t IndexedGetter(uint32_t, bool&);
  uint32_t IndexedGetter(uint32_t&) = delete;
  uint32_t Item(uint32_t&);
  uint32_t Item(uint32_t, bool&) = delete;
  uint32_t Length();
  void LegacyCall(JS::Handle<JS::Value>);
};

class TestNamedGetterInterface : public nsISupports,
                                 public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void NamedGetter(const nsAString&, bool&, nsAString&);
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestIndexedGetterAndSetterAndNamedGetterInterface : public nsISupports,
                                                          public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void NamedGetter(const nsAString&, bool&, nsAString&);
  void GetSupportedNames(nsTArray<nsString>&);
  int32_t IndexedGetter(uint32_t, bool&);
  void IndexedSetter(uint32_t, int32_t);
  uint32_t Length();
};

class TestIndexedAndNamedGetterInterface : public nsISupports,
                                           public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  uint32_t IndexedGetter(uint32_t, bool&);
  void NamedGetter(const nsAString&, bool&, nsAString&);
  void NamedItem(const nsAString&, nsAString&);
  uint32_t Length();
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestIndexedSetterInterface : public nsISupports,
                                   public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void IndexedSetter(uint32_t, const nsAString&);
  void IndexedGetter(uint32_t, bool&, nsString&);
  uint32_t Length();
  void SetItem(uint32_t, const nsAString&);
};

class TestNamedSetterInterface : public nsISupports,
                                 public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void NamedSetter(const nsAString&, TestIndexedSetterInterface&);
  TestIndexedSetterInterface* NamedGetter(const nsAString&, bool&);
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestIndexedAndNamedSetterInterface : public nsISupports,
                                           public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void IndexedSetter(uint32_t, TestIndexedSetterInterface&);
  TestIndexedSetterInterface* IndexedGetter(uint32_t, bool&);
  uint32_t Length();
  void NamedSetter(const nsAString&, TestIndexedSetterInterface&);
  TestIndexedSetterInterface* NamedGetter(const nsAString&, bool&);
  void SetNamedItem(const nsAString&, TestIndexedSetterInterface&);
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestIndexedAndNamedGetterAndSetterInterface : public TestIndexedSetterInterface
{
public:
  uint32_t IndexedGetter(uint32_t, bool&);
  uint32_t Item(uint32_t);
  void NamedGetter(const nsAString&, bool&, nsAString&);
  void NamedItem(const nsAString&, nsAString&);
  void IndexedSetter(uint32_t, int32_t&);
  void IndexedSetter(uint32_t, const nsAString&) = delete;
  void NamedSetter(const nsAString&, const nsAString&);
  void Stringify(nsAString&);
  uint32_t Length();
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestCppKeywordNamedMethodsInterface : public nsISupports,
                                            public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  bool Continue();
  bool Delete();
  int32_t Volatile();
};

class TestNamedDeleterInterface : public nsISupports,
                                  public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  void NamedDeleter(const nsAString&, bool&);
  long NamedGetter(const nsAString&, bool&);
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestNamedDeleterWithRetvalInterface : public nsISupports,
                                            public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();

  bool NamedDeleter(const nsAString&, bool&);
  bool NamedDeleter(const nsAString&) = delete;
  long NamedGetter(const nsAString&, bool&);
  bool DelNamedItem(const nsAString&);
  bool DelNamedItem(const nsAString&, bool&) = delete;
  void GetSupportedNames(nsTArray<nsString>&);
};

class TestParentInterface : public nsISupports,
                            public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  virtual nsISupports* GetParentObject();
};

class TestChildInterface : public TestParentInterface
{
};

class TestDeprecatedInterface : public nsISupports, public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  static
  already_AddRefed<TestDeprecatedInterface>
    Constructor(const GlobalObject&, ErrorResult&);

  static void AlsoDeprecated(const GlobalObject&);

  virtual nsISupports* GetParentObject();
};

class TestInterfaceWithPromiseConstructorArg : public nsISupports, public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  static
  already_AddRefed<TestInterfaceWithPromiseConstructorArg>
    Constructor(const GlobalObject&, Promise&, ErrorResult&);

  virtual nsISupports* GetParentObject();
};

class TestSecureContextInterface : public nsISupports, public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  static
  already_AddRefed<TestSecureContextInterface>
    Constructor(const GlobalObject&, ErrorResult&);

  static void AlsoSecureContext(const GlobalObject&);

  virtual nsISupports* GetParentObject();
};

class TestNamespace {
public:
  static bool Foo(const GlobalObject&);
  static int32_t Bar(const GlobalObject&);
  static void Baz(const GlobalObject&);
};

class TestRenamedNamespace {
};

class TestProtoObjectHackedNamespace {
};

class TestWorkerExposedInterface : public nsISupports,
                                   public nsWrapperCache
{
public:
  NS_DECL_ISUPPORTS

  // We need a GetParentObject to make binding codegen happy
  nsISupports* GetParentObject();

  void NeedsSubjectPrincipalMethod(Maybe<nsIPrincipal*>);
  bool NeedsSubjectPrincipalAttr(Maybe<nsIPrincipal*>);
  void SetNeedsSubjectPrincipalAttr(bool, Maybe<nsIPrincipal*>);
  void NeedsCallerTypeMethod(CallerType);
  bool NeedsCallerTypeAttr(CallerType);
  void SetNeedsCallerTypeAttr(bool, CallerType);
};

} // namespace dom
} // namespace mozilla

#endif /* TestBindingHeader_h */
