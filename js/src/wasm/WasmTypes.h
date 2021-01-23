/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 *
 * Copyright 2015 Mozilla Foundation
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

#ifndef wasm_types_h
#define wasm_types_h

#include "mozilla/Alignment.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/Atomics.h"
#include "mozilla/BinarySearch.h"
#include "mozilla/EnumeratedArray.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/Maybe.h"
#include "mozilla/RefPtr.h"
#include "mozilla/Unused.h"

#include <type_traits>

#include "NamespaceImports.h"

#include "ds/LifoAlloc.h"
#include "jit/IonTypes.h"
#include "js/RefCounted.h"
#include "js/UniquePtr.h"
#include "js/Utility.h"
#include "js/Vector.h"
#include "vm/JSFunction.h"
#include "vm/MallocProvider.h"
#include "vm/NativeObject.h"
#include "wasm/WasmConstants.h"
#include "wasm/WasmUtility.h"

namespace js {

namespace jit {
class JitScript;
enum class RoundingMode;
template <class VecT>
class ABIArgIter;
}  // namespace jit

// This is a widespread header, so lets keep out the core wasm impl types.

typedef GCVector<JSFunction*, 0, SystemAllocPolicy> JSFunctionVector;

class WasmMemoryObject;
using GCPtrWasmMemoryObject = GCPtr<WasmMemoryObject*>;
using RootedWasmMemoryObject = Rooted<WasmMemoryObject*>;
using HandleWasmMemoryObject = Handle<WasmMemoryObject*>;
using MutableHandleWasmMemoryObject = MutableHandle<WasmMemoryObject*>;

class WasmModuleObject;
using RootedWasmModuleObject = Rooted<WasmModuleObject*>;
using HandleWasmModuleObject = Handle<WasmModuleObject*>;
using MutableHandleWasmModuleObject = MutableHandle<WasmModuleObject*>;

class WasmInstanceObject;
using WasmInstanceObjectVector = GCVector<WasmInstanceObject*>;
using RootedWasmInstanceObject = Rooted<WasmInstanceObject*>;
using HandleWasmInstanceObject = Handle<WasmInstanceObject*>;
using MutableHandleWasmInstanceObject = MutableHandle<WasmInstanceObject*>;

class WasmTableObject;
typedef GCVector<WasmTableObject*, 0, SystemAllocPolicy> WasmTableObjectVector;
using RootedWasmTableObject = Rooted<WasmTableObject*>;
using HandleWasmTableObject = Handle<WasmTableObject*>;
using MutableHandleWasmTableObject = MutableHandle<WasmTableObject*>;

class WasmGlobalObject;
typedef GCVector<WasmGlobalObject*, 0, SystemAllocPolicy>
    WasmGlobalObjectVector;
using RootedWasmGlobalObject = Rooted<WasmGlobalObject*>;

class StructTypeDescr;
typedef GCVector<HeapPtr<StructTypeDescr*>, 0, SystemAllocPolicy>
    StructTypeDescrVector;

namespace wasm {

using mozilla::ArrayEqual;
using mozilla::Atomic;
using mozilla::DebugOnly;
using mozilla::EnumeratedArray;
using mozilla::MallocSizeOf;
using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::PodCopy;
using mozilla::PodZero;
using mozilla::Some;
using mozilla::Unused;

class Code;
class DebugState;
class GeneratedSourceMap;
class Memory;
class Module;
class Instance;
class Table;

// Uint32Vector has initial size 8 on the basis that the dominant use cases
// (line numbers and control stacks) tend to have a small but nonzero number
// of elements.
typedef Vector<uint32_t, 8, SystemAllocPolicy> Uint32Vector;

typedef Vector<uint8_t, 0, SystemAllocPolicy> Bytes;
using UniqueBytes = UniquePtr<Bytes>;
using UniqueConstBytes = UniquePtr<const Bytes>;
typedef Vector<char, 0, SystemAllocPolicy> UTF8Bytes;
typedef Vector<Instance*, 0, SystemAllocPolicy> InstanceVector;
typedef Vector<UniqueChars, 0, SystemAllocPolicy> UniqueCharsVector;

// To call Vector::shrinkStorageToFit , a type must specialize mozilla::IsPod
// which is pretty verbose to do within js::wasm, so factor that process out
// into a macro.

#define WASM_DECLARE_POD_VECTOR(Type, VectorName)   \
  }                                                 \
  }                                                 \
  namespace mozilla {                               \
  template <>                                       \
  struct IsPod<js::wasm::Type> : std::true_type {}; \
  }                                                 \
  namespace js {                                    \
  namespace wasm {                                  \
  typedef Vector<Type, 0, SystemAllocPolicy> VectorName;

// A wasm Module and everything it contains must support serialization and
// deserialization. Some data can be simply copied as raw bytes and,
// as a convention, is stored in an inline CacheablePod struct. Everything else
// should implement the below methods which are called recusively by the
// containing Module.

#define WASM_DECLARE_SERIALIZABLE(Type)              \
  size_t serializedSize() const;                     \
  uint8_t* serialize(uint8_t* cursor) const;         \
  const uint8_t* deserialize(const uint8_t* cursor); \
  size_t sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const;

template <class T>
struct SerializableRefPtr : RefPtr<T> {
  using RefPtr<T>::operator=;

  SerializableRefPtr() = default;

  template <class U>
  MOZ_IMPLICIT SerializableRefPtr(U&& u) : RefPtr<T>(std::forward<U>(u)) {}

  WASM_DECLARE_SERIALIZABLE(SerializableRefPtr)
};

// This reusable base class factors out the logic for a resource that is shared
// by multiple instances/modules but should only be counted once when computing
// about:memory stats.

template <class T>
struct ShareableBase : AtomicRefCounted<T> {
  using SeenSet = HashSet<const T*, DefaultHasher<const T*>, SystemAllocPolicy>;

  size_t sizeOfIncludingThisIfNotSeen(MallocSizeOf mallocSizeOf,
                                      SeenSet* seen) const {
    const T* self = static_cast<const T*>(this);
    typename SeenSet::AddPtr p = seen->lookupForAdd(self);
    if (p) {
      return 0;
    }
    bool ok = seen->add(p, self);
    (void)ok;  // oh well
    return mallocSizeOf(self) + self->sizeOfExcludingThis(mallocSizeOf);
  }
};

// ShareableBytes is a reference-counted Vector of bytes.

struct ShareableBytes : ShareableBase<ShareableBytes> {
  // Vector is 'final', so instead make Vector a member and add boilerplate.
  Bytes bytes;

  ShareableBytes() = default;
  explicit ShareableBytes(Bytes&& bytes) : bytes(std::move(bytes)) {}
  size_t sizeOfExcludingThis(MallocSizeOf mallocSizeOf) const {
    return bytes.sizeOfExcludingThis(mallocSizeOf);
  }
  const uint8_t* begin() const { return bytes.begin(); }
  const uint8_t* end() const { return bytes.end(); }
  size_t length() const { return bytes.length(); }
  bool append(const uint8_t* start, uint32_t len) {
    return bytes.append(start, len);
  }
};

using MutableBytes = RefPtr<ShareableBytes>;
using SharedBytes = RefPtr<const ShareableBytes>;

// The Opcode compactly and safely represents the primary opcode plus any
// extension, with convenient predicates and accessors.

class Opcode {
  uint32_t bits_;

 public:
  MOZ_IMPLICIT Opcode(Op op) : bits_(uint32_t(op)) {
    static_assert(size_t(Op::Limit) == 256, "fits");
    MOZ_ASSERT(size_t(op) < size_t(Op::Limit));
  }
  MOZ_IMPLICIT Opcode(MiscOp op)
      : bits_((uint32_t(op) << 8) | uint32_t(Op::MiscPrefix)) {
    static_assert(size_t(MiscOp::Limit) <= 0xFFFFFF, "fits");
    MOZ_ASSERT(size_t(op) < size_t(MiscOp::Limit));
  }
  MOZ_IMPLICIT Opcode(ThreadOp op)
      : bits_((uint32_t(op) << 8) | uint32_t(Op::ThreadPrefix)) {
    static_assert(size_t(ThreadOp::Limit) <= 0xFFFFFF, "fits");
    MOZ_ASSERT(size_t(op) < size_t(ThreadOp::Limit));
  }
  MOZ_IMPLICIT Opcode(MozOp op)
      : bits_((uint32_t(op) << 8) | uint32_t(Op::MozPrefix)) {
    static_assert(size_t(MozOp::Limit) <= 0xFFFFFF, "fits");
    MOZ_ASSERT(size_t(op) < size_t(MozOp::Limit));
  }
  MOZ_IMPLICIT Opcode(SimdOp op)
      : bits_((uint32_t(op) << 8) | uint32_t(Op::SimdPrefix)) {
    static_assert(size_t(SimdOp::Limit) <= 0xFFFFFF, "fits");
    MOZ_ASSERT(size_t(op) < size_t(SimdOp::Limit));
  }

  bool isOp() const { return bits_ < uint32_t(Op::FirstPrefix); }
  bool isMisc() const { return (bits_ & 255) == uint32_t(Op::MiscPrefix); }
  bool isThread() const { return (bits_ & 255) == uint32_t(Op::ThreadPrefix); }
  bool isMoz() const { return (bits_ & 255) == uint32_t(Op::MozPrefix); }
  bool isSimd() const { return (bits_ & 255) == uint32_t(Op::SimdPrefix); }

  Op asOp() const {
    MOZ_ASSERT(isOp());
    return Op(bits_);
  }
  MiscOp asMisc() const {
    MOZ_ASSERT(isMisc());
    return MiscOp(bits_ >> 8);
  }
  ThreadOp asThread() const {
    MOZ_ASSERT(isThread());
    return ThreadOp(bits_ >> 8);
  }
  MozOp asMoz() const {
    MOZ_ASSERT(isMoz());
    return MozOp(bits_ >> 8);
  }
  SimdOp asSimd() const {
    MOZ_ASSERT(isSimd());
    return SimdOp(bits_ >> 8);
  }

  uint32_t bits() const { return bits_; }

  bool operator==(const Opcode& that) const { return bits_ == that.bits_; }
  bool operator!=(const Opcode& that) const { return bits_ != that.bits_; }
};

// A PackedTypeCode represents a TypeCode paired with a refTypeIndex (valid only
// for TypeCode::OptRef).  PackedTypeCode is guaranteed to be POD.  The TypeCode
// spans the full range of type codes including the specialized AnyRef, and
// FuncRef.
//
// PackedTypeCode is an enum class, as opposed to the more natural
// struct-with-bitfields, because bitfields would make it non-POD.
//
// DO NOT use PackedTypeCode as a cast.  ALWAYS go via PackTypeCode().

enum class PackedTypeCode : uint32_t {};

static_assert(std::is_pod_v<PackedTypeCode>,
              "must be POD to be simply serialized/deserialized");

const uint32_t NoTypeCode = 0xFF;          // Only use these
const uint32_t NoRefTypeIndex = 0x3FFFFF;  //   with PackedTypeCode

static inline PackedTypeCode PackTypeCode(TypeCode tc, uint32_t refTypeIndex) {
  MOZ_ASSERT(uint32_t(tc) <= 0xFF);
  MOZ_ASSERT_IF(tc != TypeCode::OptRef, refTypeIndex == NoRefTypeIndex);
  MOZ_ASSERT_IF(tc == TypeCode::OptRef, refTypeIndex <= MaxTypes);
  // A PackedTypeCode should be representable in a single word, so in the
  // smallest case, 32 bits.  However sometimes 2 bits of the word may be taken
  // by a pointer tag; for that reason, limit to 30 bits; and then there's the
  // 8-bit typecode, so 22 bits left for the type index.
  static_assert(MaxTypes < (1 << (30 - 8)), "enough bits");
  return PackedTypeCode((refTypeIndex << 8) | uint32_t(tc));
}

static inline PackedTypeCode PackTypeCode(TypeCode tc) {
  return PackTypeCode(tc, NoRefTypeIndex);
}

static inline PackedTypeCode InvalidPackedTypeCode() {
  return PackedTypeCode(NoTypeCode);
}

static inline PackedTypeCode PackedTypeCodeFromBits(uint32_t bits) {
  return PackTypeCode(TypeCode(bits & 255), bits >> 8);
}

static inline bool IsValid(PackedTypeCode ptc) {
  return (uint32_t(ptc) & 255) != NoTypeCode;
}

static inline uint32_t PackedTypeCodeToBits(PackedTypeCode ptc) {
  return uint32_t(ptc);
}

static inline TypeCode UnpackTypeCodeType(PackedTypeCode ptc) {
  MOZ_ASSERT(IsValid(ptc));
  return TypeCode(uint32_t(ptc) & 255);
}

static inline uint32_t UnpackTypeCodeIndex(PackedTypeCode ptc) {
  MOZ_ASSERT(UnpackTypeCodeType(ptc) == TypeCode::OptRef);
  return uint32_t(ptc) >> 8;
}

static inline uint32_t UnpackTypeCodeIndexUnchecked(PackedTypeCode ptc) {
  return uint32_t(ptc) >> 8;
}

// Return the TypeCode, but return TypeCode::OptRef for any reference type.
//
// This function is very, very hot, hence what would normally be a switch on the
// value `c` to map the reference types to TypeCode::OptRef has been distilled
// into a simple comparison; this is fastest.  Should type codes become too
// complicated for this to work then a lookup table also has better performance
// than a switch.
//
// An alternative is for the PackedTypeCode to represent something closer to
// what ValType needs, so that this decoding step is not necessary, but that
// moves complexity elsewhere, and the perf gain here would be only about 1% for
// baseline compilation throughput.

static inline TypeCode UnpackTypeCodeTypeAbstracted(PackedTypeCode ptc) {
  TypeCode c = UnpackTypeCodeType(ptc);
  return c < LowestPrimitiveTypeCode ? TypeCode::OptRef : c;
}

static inline bool IsReferenceType(PackedTypeCode ptc) {
  return UnpackTypeCodeTypeAbstracted(ptc) == TypeCode::OptRef;
}

// The RefType carries more information about types t for which t.isReference()
// is true.

class RefType {
 public:
  enum Kind {
    Any = uint8_t(TypeCode::AnyRef),
    Func = uint8_t(TypeCode::FuncRef),
    TypeIndex = uint8_t(TypeCode::OptRef)
  };

 private:
  PackedTypeCode ptc_;

#ifdef DEBUG
  bool isValid() const {
    switch (UnpackTypeCodeType(ptc_)) {
      case TypeCode::FuncRef:
      case TypeCode::AnyRef:
        MOZ_ASSERT(UnpackTypeCodeIndexUnchecked(ptc_) == NoRefTypeIndex);
        return true;
      case TypeCode::OptRef:
        MOZ_ASSERT(UnpackTypeCodeIndexUnchecked(ptc_) != NoRefTypeIndex);
        return true;
      default:
        return false;
    }
  }
#endif
  explicit RefType(Kind kind) : ptc_(PackTypeCode(TypeCode(kind))) {
    MOZ_ASSERT(isValid());
  }

  // We keep this private since all sorts of values coerce to uint32_t.
  explicit RefType(uint32_t refTypeIndex)
      : ptc_(PackTypeCode(TypeCode::OptRef, refTypeIndex)) {
    MOZ_ASSERT(isValid());
  }

 public:
  RefType() : ptc_(InvalidPackedTypeCode()) {}
  explicit RefType(PackedTypeCode ptc) : ptc_(ptc) { MOZ_ASSERT(isValid()); }

  static RefType fromTypeCode(TypeCode tc) {
    MOZ_ASSERT(tc != TypeCode::OptRef);
    return RefType(Kind(tc));
  }

  static RefType fromTypeIndex(uint32_t refTypeIndex) {
    return RefType(refTypeIndex);
  }

  Kind kind() const { return Kind(UnpackTypeCodeType(ptc_)); }

  uint32_t typeIndex() const { return UnpackTypeCodeIndex(ptc_); }

  PackedTypeCode packed() const { return ptc_; }

  static RefType any() { return RefType(Any); }
  static RefType func() { return RefType(Func); }

  bool operator==(const RefType& that) const { return ptc_ == that.ptc_; }
  bool operator!=(const RefType& that) const { return ptc_ != that.ptc_; }
};

// The ValType represents the storage type of a WebAssembly location, whether
// parameter, local, or global.

class ValType {
  PackedTypeCode tc_;

#ifdef DEBUG
  bool isValidTypeCode() {
    MOZ_ASSERT(isValid());
    switch (UnpackTypeCodeType(tc_)) {
      case TypeCode::I32:
      case TypeCode::I64:
      case TypeCode::F32:
      case TypeCode::F64:
      case TypeCode::V128:
      case TypeCode::AnyRef:
      case TypeCode::FuncRef:
      case TypeCode::OptRef:
        return true;
      default:
        return false;
    }
  }
#endif

 public:
  enum Kind {
    I32 = uint8_t(TypeCode::I32),
    I64 = uint8_t(TypeCode::I64),
    F32 = uint8_t(TypeCode::F32),
    F64 = uint8_t(TypeCode::F64),
    V128 = uint8_t(TypeCode::V128),
    Ref = uint8_t(TypeCode::OptRef),
  };

 private:
  explicit ValType(TypeCode c) : tc_(PackTypeCode(c)) {
    MOZ_ASSERT(c != TypeCode::OptRef);
    MOZ_ASSERT(isValid());
  }

  TypeCode typeCode() const {
    MOZ_ASSERT(isValid());
    return UnpackTypeCodeType(tc_);
  }

 public:
  ValType() : tc_(InvalidPackedTypeCode()) {}

  MOZ_IMPLICIT ValType(Kind c) : tc_(PackTypeCode(TypeCode(c))) {
    MOZ_ASSERT(c != Ref);
    MOZ_ASSERT(isValidTypeCode());
  }

  MOZ_IMPLICIT ValType(RefType rt) : tc_(rt.packed()) {
    MOZ_ASSERT(isValidTypeCode());
  }

  explicit ValType(PackedTypeCode ptc) : tc_(ptc) {
    MOZ_ASSERT(isValidTypeCode());
  }

  explicit ValType(jit::MIRType mty) {
    switch (mty) {
      case jit::MIRType::Int32:
        tc_ = PackTypeCode(TypeCode::I32);
        break;
      case jit::MIRType::Int64:
        tc_ = PackTypeCode(TypeCode::I64);
        break;
      case jit::MIRType::Float32:
        tc_ = PackTypeCode(TypeCode::F32);
        break;
      case jit::MIRType::Double:
        tc_ = PackTypeCode(TypeCode::F64);
        break;
      case jit::MIRType::Simd128:
        tc_ = PackTypeCode(TypeCode::V128);
        break;
      default:
        MOZ_CRASH("ValType(MIRType): unexpected type");
    }
  }

  static ValType fromNonRefTypeCode(TypeCode tc) {
#ifdef DEBUG
    switch (tc) {
      case TypeCode::I32:
      case TypeCode::I64:
      case TypeCode::F32:
      case TypeCode::F64:
      case TypeCode::V128:
        break;
      default:
        MOZ_CRASH("Bad type code");
    }
#endif
    return ValType(tc);
  }

  static ValType fromBitsUnsafe(uint32_t bits) {
    return ValType(PackedTypeCodeFromBits(bits));
  }

  bool isValid() const { return IsValid(tc_); }

  PackedTypeCode packed() const {
    MOZ_ASSERT(isValid());
    return tc_;
  }

  uint32_t bitsUnsafe() const {
    MOZ_ASSERT(isValid());
    return PackedTypeCodeToBits(tc_);
  }

  bool isAnyRef() const { return UnpackTypeCodeType(tc_) == TypeCode::AnyRef; }

  bool isFuncRef() const {
    return UnpackTypeCodeType(tc_) == TypeCode::FuncRef;
  }

  bool isNullable() const {
    MOZ_ASSERT(isReference());
    return true;
  }

  bool isTypeIndex() const {
    MOZ_ASSERT(isValid());
    return UnpackTypeCodeType(tc_) == TypeCode::OptRef;
  }

  bool isReference() const {
    MOZ_ASSERT(isValid());
    return IsReferenceType(tc_);
  }

  Kind kind() const {
    MOZ_ASSERT(isValid());
    return Kind(UnpackTypeCodeTypeAbstracted(tc_));
  }

  RefType refType() const {
    MOZ_ASSERT(isReference());
    return RefType(tc_);
  }

  RefType::Kind refTypeKind() const {
    MOZ_ASSERT(isReference());
    return RefType(tc_).kind();
  }

  // Some types are encoded as JS::Value when they escape from Wasm (when passed
  // as parameters to imports or returned from exports).  For AnyRef the Value
  // encoding is pretty much a requirement.  For other types it's a choice that
  // may (temporarily) simplify some code.
  bool isEncodedAsJSValueOnEscape() const {
    switch (typeCode()) {
      case TypeCode::AnyRef:
      case TypeCode::FuncRef:
        return true;
      default:
        return false;
    }
  }

  bool operator==(const ValType& that) const {
    MOZ_ASSERT(isValid() && that.isValid());
    return tc_ == that.tc_;
  }

  bool operator!=(const ValType& that) const {
    MOZ_ASSERT(isValid() && that.isValid());
    return tc_ != that.tc_;
  }

  bool operator==(Kind that) const {
    MOZ_ASSERT(isValid());
    MOZ_ASSERT(that != Kind::Ref);
    return Kind(typeCode()) == that;
  }

  bool operator!=(Kind that) const { return !(*this == that); }
};

struct V128 {
  uint8_t bytes[16];  // Little-endian

  V128() { memset(bytes, 0, sizeof(bytes)); }

  template <typename T>
  T extractLane(int lane) {
    T result;
    MOZ_ASSERT(lane < 16 / sizeof(T));
    memcpy(&result, bytes + sizeof(T) * lane, sizeof(T));
    return result;
  }

  template <typename T>
  void insertLane(int lane, T value) {
    MOZ_ASSERT(lane < 16 / sizeof(T));
    memcpy(bytes + sizeof(T) * lane, &value, sizeof(T));
  }
};

static_assert(sizeof(V128) == 16, "Invariant");

// The dominant use of this data type is for locals and args, and profiling
// with ZenGarden and Tanks suggests an initial size of 16 minimises heap
// allocation, both in terms of blocks and bytes.
typedef Vector<ValType, 16, SystemAllocPolicy> ValTypeVector;

// ValType utilities

static inline unsigned SizeOf(ValType vt) {
  switch (vt.kind()) {
    case ValType::I32:
    case ValType::F32:
      return 4;
    case ValType::I64:
    case ValType::F64:
      return 8;
    case ValType::V128:
      return 16;
    case ValType::Ref:
      return sizeof(intptr_t);
  }
  MOZ_CRASH("Invalid ValType");
}

// Note, ToMIRType is only correct within Wasm, where an AnyRef is represented
// as a pointer.  At the JS/wasm boundary, an AnyRef can be represented as a
// JS::Value, and the type translation may have to be handled specially and on a
// case-by-case basis.

static inline jit::MIRType ToMIRType(ValType vt) {
  switch (vt.kind()) {
    case ValType::I32:
      return jit::MIRType::Int32;
    case ValType::I64:
      return jit::MIRType::Int64;
    case ValType::F32:
      return jit::MIRType::Float32;
    case ValType::F64:
      return jit::MIRType::Double;
    case ValType::V128:
      return jit::MIRType::Simd128;
    case ValType::Ref:
      return jit::MIRType::RefOrNull;
  }
  MOZ_MAKE_COMPILER_ASSUME_IS_UNREACHABLE("bad type");
}

static inline bool IsNumberType(ValType vt) { return !vt.isReference(); }

static inline jit::MIRType ToMIRType(const Maybe<ValType>& t) {
  return t ? ToMIRType(ValType(t.ref())) : jit::MIRType::None;
}

extern UniqueChars ToString(ValType type);

static inline const char* ToCString(ValType type) {
  switch (type.kind()) {
    case ValType::I32:
      return "i32";
    case ValType::I64:
      return "i64";
    case ValType::V128:
      return "v128";
    case ValType::F32:
      return "f32";
    case ValType::F64:
      return "f64";
    case ValType::Ref:
      switch (type.refTypeKind()) {
        case RefType::Any:
          return "externref";
        case RefType::Func:
          return "funcref";
        case RefType::TypeIndex:
          return "optref";
      }
  }
  MOZ_CRASH("bad value type");
}

static inline const char* ToCString(const Maybe<ValType>& type) {
  return type ? ToCString(type.ref()) : "void";
}

// An AnyRef is a boxed value that can represent any wasm reference type and any
// host type that the host system allows to flow into and out of wasm
// transparently.  It is a pointer-sized datum that has the same representation
// as all its subtypes (funcref, eqref, (ref T), et al) due to the non-coercive
// subtyping of the wasm type system.  Its current representation is a plain
// JSObject*, and the private JSObject subtype WasmValueBox is used to box
// non-object non-null JS values.
//
// The C++/wasm boundary always uses a 'void*' type to express AnyRef values, to
// emphasize the pointer-ness of the value.  The C++ code must transform the
// void* into an AnyRef by calling AnyRef::fromCompiledCode(), and transform an
// AnyRef into a void* by calling AnyRef::toCompiledCode().  Once in C++, we use
// AnyRef everywhere.  A JS Value is transformed into an AnyRef by calling
// AnyRef::box(), and the AnyRef is transformed into a JS Value by calling
// AnyRef::unbox().
//
// NOTE that AnyRef values may point to GC'd storage and as such need to be
// rooted if they are kept live in boxed form across code that may cause GC!
// Use RootedAnyRef / HandleAnyRef / MutableHandleAnyRef where necessary.
//
// The lowest bits of the pointer value are used for tagging, to allow for some
// representation optimizations and to distinguish various types.

// For version 0, we simply equate AnyRef and JSObject* (this means that there
// are technically no tags at all yet).  We use a simple boxing scheme that
// wraps a JS value that is not already JSObject in a distinguishable JSObject
// that holds the value, see WasmTypes.cpp for details.  Knowledge of this
// mapping is embedded in CodeGenerator.cpp (in WasmBoxValue and
// WasmAnyRefFromJSObject) and in WasmStubs.cpp (in functions Box* and Unbox*).

class AnyRef {
  JSObject* value_;

  explicit AnyRef() : value_((JSObject*)-1) {}
  explicit AnyRef(JSObject* p) : value_(p) {
    MOZ_ASSERT(((uintptr_t)p & 0x03) == 0);
  }

 public:
  // An invalid AnyRef cannot arise naturally from wasm and so can be used as
  // a sentinel value to indicate failure from an AnyRef-returning function.
  static AnyRef invalid() { return AnyRef(); }

  // Given a void* that comes from compiled wasm code, turn it into AnyRef.
  static AnyRef fromCompiledCode(void* p) { return AnyRef((JSObject*)p); }

  // Given a JSObject* that comes from JS, turn it into AnyRef.
  static AnyRef fromJSObject(JSObject* p) { return AnyRef(p); }

  // Generate an AnyRef null pointer.
  static AnyRef null() { return AnyRef(nullptr); }

  bool isNull() { return value_ == nullptr; }

  void* forCompiledCode() const { return value_; }

  JSObject* asJSObject() { return value_; }

  JSObject** asJSObjectAddress() { return &value_; }

  void trace(JSTracer* trc);

  // Tags (to be developed further)
  static constexpr uintptr_t AnyRefTagMask = 1;
  static constexpr uintptr_t AnyRefObjTag = 0;
};

using RootedAnyRef = Rooted<AnyRef>;
using HandleAnyRef = Handle<AnyRef>;
using MutableHandleAnyRef = MutableHandle<AnyRef>;

// TODO/AnyRef-boxing: With boxed immediates and strings, these will be defined
// as MOZ_CRASH or similar so that we can find all locations that need to be
// fixed.

#define ASSERT_ANYREF_IS_JSOBJECT (void)(0)
#define STATIC_ASSERT_ANYREF_IS_JSOBJECT static_assert(1, "AnyRef is JSObject")

// Given any JS value, box it as an AnyRef and store it in *result.  Returns
// false on OOM.

bool BoxAnyRef(JSContext* cx, HandleValue val, MutableHandleAnyRef result);

// Given a JS value that requires an object box, box it as an AnyRef and return
// it, returning nullptr on OOM.
//
// Currently the values requiring a box are those other than JSObject* or
// nullptr, but in the future more values will be represented without an
// allocation.
JSObject* BoxBoxableValue(JSContext* cx, HandleValue val);

// Given any AnyRef, unbox it as a JS Value.  If it is a reference to a wasm
// object it will be reflected as a JSObject* representing some TypedObject
// instance.

Value UnboxAnyRef(AnyRef val);

class WasmValueBox : public NativeObject {
  static const unsigned VALUE_SLOT = 0;

 public:
  static const unsigned RESERVED_SLOTS = 1;
  static const JSClass class_;

  static WasmValueBox* create(JSContext* cx, HandleValue val);
  Value value() const { return getFixedSlot(VALUE_SLOT); }
  static size_t offsetOfValue() {
    return NativeObject::getFixedSlotOffset(VALUE_SLOT);
  }
};

// A FuncRef is a JSFunction* and is hence also an AnyRef, and the remarks above
// about AnyRef apply also to FuncRef.  When 'funcref' is used as a value type
// in wasm code, the value that is held is "the canonical function value", which
// is a function for which IsWasmExportedFunction() is true, and which has the
// correct identity wrt reference equality of functions.  Notably, if a function
// is imported then its ref.func value compares === in JS to the function that
// was passed as an import when the instance was created.
//
// These rules ensure that casts from funcref to anyref are non-converting
// (generate no code), and that no wrapping or unwrapping needs to happen when a
// funcref or anyref flows across the JS/wasm boundary, and that functions have
// the necessary identity when observed from JS, and in the future, from wasm.
//
// Functions stored in tables, whether wasm tables or internal tables, can be
// stored in a form that optimizes for eg call speed, however.
//
// Reading a funcref from a funcref table, writing a funcref to a funcref table,
// and generating the value for a ref.func instruction are therefore nontrivial
// operations that require mapping between the canonical JSFunction and the
// optimized table representation.  Once we get an instruction to call a
// ref.func directly it too will require such a mapping.

// In many cases, a FuncRef is exactly the same as AnyRef and we can use AnyRef
// functionality on funcref values.  The FuncRef class exists mostly to add more
// checks and to make it clear, when we need to, that we're manipulating funcref
// values.  FuncRef does not currently subclass AnyRef because there's been no
// need to, but it probably could.

class FuncRef {
  JSFunction* value_;

  explicit FuncRef() : value_((JSFunction*)-1) {}
  explicit FuncRef(JSFunction* p) : value_(p) {
    MOZ_ASSERT(((uintptr_t)p & 0x03) == 0);
  }

 public:
  // Given a void* that comes from compiled wasm code, turn it into FuncRef.
  static FuncRef fromCompiledCode(void* p) { return FuncRef((JSFunction*)p); }

  // Given a JSFunction* that comes from JS, turn it into FuncRef.
  static FuncRef fromJSFunction(JSFunction* p) { return FuncRef(p); }

  // Given an AnyRef that represents a possibly-null funcref, turn it into a
  // FuncRef.
  static FuncRef fromAnyRefUnchecked(AnyRef p) {
#ifdef DEBUG
    Value v = UnboxAnyRef(p);
    if (v.isNull()) {
      return FuncRef(nullptr);
    }
    if (v.toObject().is<JSFunction>()) {
      return FuncRef(&v.toObject().as<JSFunction>());
    }
    MOZ_CRASH("Bad value");
#else
    return FuncRef(&p.asJSObject()->as<JSFunction>());
#endif
  }

  AnyRef asAnyRef() { return AnyRef::fromJSObject((JSObject*)value_); }

  void* forCompiledCode() const { return value_; }

  JSFunction* asJSFunction() { return value_; }

  bool isNull() { return value_ == nullptr; }
};

using RootedFuncRef = Rooted<FuncRef>;
using HandleFuncRef = Handle<FuncRef>;
using MutableHandleFuncRef = MutableHandle<FuncRef>;

// Given any FuncRef, unbox it as a JS Value -- always a JSFunction*.

Value UnboxFuncRef(FuncRef val);

// Code can be compiled either with the Baseline compiler or the Ion compiler,
// and tier-variant data are tagged with the Tier value.
//
// A tier value is used to request tier-variant aspects of code, metadata, or
// linkdata.  The tiers are normally explicit (Baseline and Ion); implicit tiers
// can be obtained through accessors on Code objects (eg, stableTier).

enum class Tier {
  Baseline,
  Debug = Baseline,
  Optimized,
  Serialized = Optimized
};

// Which backend to use in the case of the optimized tier.

enum class OptimizedBackend {
  Ion,
  Cranelift,
};

// The CompileMode controls how compilation of a module is performed (notably,
// how many times we compile it).

enum class CompileMode { Once, Tier1, Tier2 };

// Typed enum for whether debugging is enabled.

enum class DebugEnabled { False, True };

// A wasm module can either use no memory, a unshared memory (ArrayBuffer) or
// shared memory (SharedArrayBuffer).

enum class MemoryUsage { None = false, Unshared = 1, Shared = 2 };

// Iterator over tiers present in a tiered data structure.

class Tiers {
  Tier t_[2];
  uint32_t n_;

 public:
  explicit Tiers() { n_ = 0; }
  explicit Tiers(Tier t) {
    t_[0] = t;
    n_ = 1;
  }
  explicit Tiers(Tier t, Tier u) {
    MOZ_ASSERT(t != u);
    t_[0] = t;
    t_[1] = u;
    n_ = 2;
  }

  Tier* begin() { return t_; }
  Tier* end() { return t_ + n_; }
};

// A Module can either be asm.js or wasm.

enum ModuleKind { Wasm, AsmJS };

enum class Shareable { False, True };

// The LitVal class represents a single WebAssembly value of a given value
// type, mostly for the purpose of numeric literals and initializers. A LitVal
// does not directly map to a JS value since there is not (currently) a precise
// representation of i64 values. A LitVal may contain non-canonical NaNs since,
// within WebAssembly, floats are not canonicalized. Canonicalization must
// happen at the JS boundary.

class LitVal {
 protected:
  ValType type_;
  union U {
    U() : i32_(0) {}
    uint32_t i32_;
    uint64_t i64_;
    float f32_;
    double f64_;
    AnyRef ref_;
    V128 v128_;
  } u;

 public:
  LitVal() : type_(), u{} {}

  explicit LitVal(ValType type) : type_(type) {
    switch (type.kind()) {
      case ValType::Kind::I32: {
        u.i32_ = 0;
        break;
      }
      case ValType::Kind::I64: {
        u.i64_ = 0;
        break;
      }
      case ValType::Kind::F32: {
        u.f32_ = 0;
        break;
      }
      case ValType::Kind::F64: {
        u.f64_ = 0;
        break;
      }
      case ValType::Kind::V128: {
        new (&u.v128_) V128();
        break;
      }
      case ValType::Kind::Ref: {
        u.ref_ = AnyRef::null();
        break;
      }
    }
  }

  explicit LitVal(uint32_t i32) : type_(ValType::I32) { u.i32_ = i32; }
  explicit LitVal(uint64_t i64) : type_(ValType::I64) { u.i64_ = i64; }

  explicit LitVal(float f32) : type_(ValType::F32) { u.f32_ = f32; }
  explicit LitVal(double f64) : type_(ValType::F64) { u.f64_ = f64; }

  explicit LitVal(V128 v128) : type_(ValType::V128) { u.v128_ = v128; }

  explicit LitVal(ValType type, AnyRef any) : type_(type) {
    MOZ_ASSERT(type.isReference());
    MOZ_ASSERT(any.isNull(),
               "use Val for non-nullptr ref types to get tracing");
    u.ref_ = any;
  }

  ValType type() const { return type_; }
  static constexpr size_t sizeofLargestValue() { return sizeof(u); }

  uint32_t i32() const {
    MOZ_ASSERT(type_ == ValType::I32);
    return u.i32_;
  }
  uint64_t i64() const {
    MOZ_ASSERT(type_ == ValType::I64);
    return u.i64_;
  }
  const float& f32() const {
    MOZ_ASSERT(type_ == ValType::F32);
    return u.f32_;
  }
  const double& f64() const {
    MOZ_ASSERT(type_ == ValType::F64);
    return u.f64_;
  }
  AnyRef ref() const {
    MOZ_ASSERT(type_.isReference());
    return u.ref_;
  }
  const V128& v128() const {
    MOZ_ASSERT(type_ == ValType::V128);
    return u.v128_;
  }
};

// A Val is a LitVal that can contain (non-null) pointers to GC things. All Vals
// must be stored in Rooteds so that their trace() methods are called during
// stack marking. Vals do not implement barriers and thus may not be stored on
// the heap.

class MOZ_NON_PARAM Val : public LitVal {
 public:
  Val() : LitVal() {}
  explicit Val(ValType type) : LitVal(type) {}
  explicit Val(const LitVal& val);
  explicit Val(uint32_t i32) : LitVal(i32) {}
  explicit Val(uint64_t i64) : LitVal(i64) {}
  explicit Val(float f32) : LitVal(f32) {}
  explicit Val(double f64) : LitVal(f64) {}
  explicit Val(V128 v128) : LitVal(v128) {}
  explicit Val(ValType type, AnyRef val) : LitVal(type, AnyRef::null()) {
    MOZ_ASSERT(type.isReference());
    u.ref_ = val;
  }
  explicit Val(ValType type, FuncRef val) : LitVal(type, AnyRef::null()) {
    MOZ_ASSERT(type.isFuncRef());
    u.ref_ = val.asAnyRef();
  }
  void trace(JSTracer* trc);
};

using RootedVal = Rooted<Val>;
using HandleVal = Handle<Val>;
using MutableHandleVal = MutableHandle<Val>;

typedef GCVector<Val, 0, SystemAllocPolicy> ValVector;
using RootedValVector = Rooted<ValVector>;
using HandleValVector = Handle<ValVector>;
using MutableHandleValVector = MutableHandle<ValVector>;

// The FuncType class represents a WebAssembly function signature which takes a
// list of value types and returns an expression type. The engine uses two
// in-memory representations of the argument Vector's memory (when elements do
// not fit inline): normal malloc allocation (via SystemAllocPolicy) and
// allocation in a LifoAlloc (via LifoAllocPolicy). The former FuncType objects
// can have any lifetime since they own the memory. The latter FuncType objects
// must not outlive the associated LifoAlloc mark/release interval (which is
// currently the duration of module validation+compilation). Thus, long-lived
// objects like WasmModule must use malloced allocation.

class FuncType {
  ValTypeVector args_;
  ValTypeVector results_;

 public:
  FuncType() : args_(), results_() {}
  FuncType(ValTypeVector&& args, ValTypeVector&& results)
      : args_(std::move(args)), results_(std::move(results)) {}

  MOZ_MUST_USE bool clone(const FuncType& rhs) {
    MOZ_ASSERT(args_.empty());
    MOZ_ASSERT(results_.empty());
    return args_.appendAll(rhs.args_) && results_.appendAll(rhs.results_);
  }

  ValType arg(unsigned i) const { return args_[i]; }
  const ValTypeVector& args() const { return args_; }
  ValType result(unsigned i) const { return results_[i]; }
  const ValTypeVector& results() const { return results_; }

  HashNumber hash() const {
    HashNumber hn = 0;
    for (const ValType& vt : args_) {
      hn = mozilla::AddToHash(hn, HashNumber(vt.packed()));
    }
    for (const ValType& vt : results_) {
      hn = mozilla::AddToHash(hn, HashNumber(vt.packed()));
    }
    return hn;
  }
  bool operator==(const FuncType& rhs) const {
    return EqualContainers(args(), rhs.args()) &&
           EqualContainers(results(), rhs.results());
  }
  bool operator!=(const FuncType& rhs) const { return !(*this == rhs); }

  // Entry from JS to wasm via the JIT is currently unimplemented for
  // functions that return multiple values.
  bool temporarilyUnsupportedResultCountForJitEntry() const {
    return results().length() > MaxResultsForJitEntry;
  }
  // Calls out from wasm to JS that return multiple values is currently
  // unsupported.
  bool temporarilyUnsupportedResultCountForJitExit() const {
    return results().length() > MaxResultsForJitExit;
  }
#ifdef ENABLE_WASM_SIMD
  bool hasV128ArgOrRet() const {
    for (ValType arg : args()) {
      if (arg == ValType::V128) {
        return true;
      }
    }
    for (ValType result : results()) {
      if (result == ValType::V128) {
        return true;
      }
    }
    return false;
  }
#endif
  // For JS->wasm jit entries, AnyRef parameters and returns are allowed, as are
  // all reference types apart from TypeIndex.  V128 types are excluded per spec
  // but are guarded against separately.
  bool temporarilyUnsupportedReftypeForEntry() const {
    for (ValType arg : args()) {
      if (arg.isReference() && !arg.isAnyRef()) {
        return true;
      }
    }
    for (ValType result : results()) {
      if (result.isTypeIndex()) {
        return true;
      }
    }
    return false;
  }
  // For inlined JS->wasm jit entries, AnyRef parameters and returns are
  // allowed, as are all reference types apart from TypeIndex.  V128 types are
  // excluded per spec but are guarded against separately.
  bool temporarilyUnsupportedReftypeForInlineEntry() const {
    for (ValType arg : args()) {
      if (arg.isReference() && !arg.isAnyRef()) {
        return true;
      }
    }
    for (ValType result : results()) {
      if (result.isTypeIndex()) {
        return true;
      }
    }
    return false;
  }
  // For wasm->JS jit exits, AnyRef parameters and returns are allowed, as are
  // reference type parameters of all types except TypeIndex.  V128 types are
  // excluded per spec but are guarded against separately.
  bool temporarilyUnsupportedReftypeForExit() const {
    for (ValType arg : args()) {
      if (arg.isTypeIndex()) {
        return true;
      }
    }
    for (ValType result : results()) {
      if (result.isReference() && !result.isAnyRef()) {
        return true;
      }
    }
    return false;
  }
  bool jitExitRequiresArgCheck() const {
    for (ValType arg : args()) {
      if (arg.isEncodedAsJSValueOnEscape()) {
        return true;
      }
    }
    return false;
  }
#ifdef WASM_PRIVATE_REFTYPES
  bool exposesTypeIndex() const {
    for (const ValType& arg : args()) {
      if (arg.isTypeIndex()) {
        return true;
      }
    }
    for (const ValType& result : results()) {
      if (result.isTypeIndex()) {
        return true;
      }
    }
    return false;
  }
#endif

  WASM_DECLARE_SERIALIZABLE(FuncType)
};

struct FuncTypeHashPolicy {
  using Lookup = const FuncType&;
  static HashNumber hash(Lookup ft) { return ft.hash(); }
  static bool match(const FuncType* lhs, Lookup rhs) { return *lhs == rhs; }
};

// ArgTypeVector type.
//
// Functions usually receive one ABI argument per WebAssembly argument.  However
// if a function has multiple results and some of those results go to the stack,
// then it additionally receives a synthetic ABI argument holding a pointer to
// the stack result area.
//
// Given the presence of synthetic arguments, sometimes we need a name for
// non-synthetic arguments.  We call those "natural" arguments.

enum class StackResults { HasStackResults, NoStackResults };

class ArgTypeVector {
  const ValTypeVector& args_;
  bool hasStackResults_;

  // To allow ABIArgIter<ArgTypeVector>, we define a private length()
  // method.  To prevent accidental errors, other users need to be
  // explicit and call lengthWithStackResults() or
  // lengthWithoutStackResults().
  size_t length() const { return args_.length() + size_t(hasStackResults_); }
  friend jit::ABIArgIter<ArgTypeVector>;
  friend jit::ABIArgIter<const ArgTypeVector>;

 public:
  ArgTypeVector(const ValTypeVector& args, StackResults stackResults)
      : args_(args),
        hasStackResults_(stackResults == StackResults::HasStackResults) {}
  explicit ArgTypeVector(const FuncType& funcType);

  bool hasSyntheticStackResultPointerArg() const { return hasStackResults_; }
  StackResults stackResults() const {
    return hasSyntheticStackResultPointerArg() ? StackResults::HasStackResults
                                               : StackResults::NoStackResults;
  }
  size_t lengthWithoutStackResults() const { return args_.length(); }
  bool isSyntheticStackResultPointerArg(size_t idx) const {
    // The pointer to stack results area, if present, is a synthetic argument
    // tacked on at the end.
    MOZ_ASSERT(idx < lengthWithStackResults());
    return idx == args_.length();
  }
  bool isNaturalArg(size_t idx) const {
    return !isSyntheticStackResultPointerArg(idx);
  }
  size_t naturalIndex(size_t idx) const {
    MOZ_ASSERT(isNaturalArg(idx));
    // Because the synthetic argument, if present, is tacked on the end, an
    // argument index that isn't synthetic is natural.
    return idx;
  }

  size_t lengthWithStackResults() const { return length(); }
  jit::MIRType operator[](size_t i) const {
    MOZ_ASSERT(i < lengthWithStackResults());
    if (isSyntheticStackResultPointerArg(i)) {
      return jit::MIRType::StackResults;
    }
    return ToMIRType(args_[naturalIndex(i)]);
  }
};

template <typename PointerType>
class TaggedValue {
 public:
  enum Kind {
    ImmediateKind1 = 0,
    ImmediateKind2 = 1,
    PointerKind1 = 2,
    PointerKind2 = 3
  };

 private:
  uintptr_t bits_;

  static constexpr uintptr_t PayloadShift = 2;
  static constexpr uintptr_t KindMask = 0x3;
  static constexpr uintptr_t PointerKindBit = 0x2;

  constexpr static bool IsPointerKind(Kind kind) {
    return uintptr_t(kind) & PointerKindBit;
  }
  constexpr static bool IsImmediateKind(Kind kind) {
    return !IsPointerKind(kind);
  }

  static_assert(IsImmediateKind(ImmediateKind1), "immediate kind 1");
  static_assert(IsImmediateKind(ImmediateKind2), "immediate kind 2");
  static_assert(IsPointerKind(PointerKind1), "pointer kind 1");
  static_assert(IsPointerKind(PointerKind2), "pointer kind 2");

  static uintptr_t PackImmediate(Kind kind, uint32_t imm) {
    MOZ_ASSERT(IsImmediateKind(kind));
    MOZ_ASSERT((uintptr_t(kind) & KindMask) == kind);
    MOZ_ASSERT((imm & (uint32_t(KindMask) << (32 - PayloadShift))) == 0);
    return uintptr_t(kind) | (uintptr_t(imm) << PayloadShift);
  }

  static uintptr_t PackPointer(Kind kind, PointerType* ptr) {
    uintptr_t ptrBits = reinterpret_cast<uintptr_t>(ptr);
    MOZ_ASSERT(IsPointerKind(kind));
    MOZ_ASSERT((uintptr_t(kind) & KindMask) == kind);
    MOZ_ASSERT((ptrBits & KindMask) == 0);
    return uintptr_t(kind) | ptrBits;
  }

 public:
  TaggedValue(Kind kind, uint32_t imm) : bits_(PackImmediate(kind, imm)) {}
  TaggedValue(Kind kind, PointerType* ptr) : bits_(PackPointer(kind, ptr)) {}

  uintptr_t bits() const { return bits_; }
  Kind kind() const { return Kind(bits() & KindMask); }
  uint32_t immediate() const {
    MOZ_ASSERT(IsImmediateKind(kind()));
    return mozilla::AssertedCast<uint32_t>(bits() >> PayloadShift);
  }
  PointerType* pointer() const {
    MOZ_ASSERT(IsPointerKind(kind()));
    return reinterpret_cast<PointerType*>(bits() & ~KindMask);
  }
};

// ResultType represents the WebAssembly spec's `resulttype`. Semantically, a
// result type is just a vec(valtype).  For effiency, though, the ResultType
// value is packed into a word, with separate encodings for these 3 cases:
//  []
//  [valtype]
//  pointer to ValTypeVector
//
// Additionally there is an encoding indicating uninitialized ResultType
// values.
//
// Generally in the latter case the ValTypeVector is the args() or results() of
// a FuncType in the compilation unit, so as long as the lifetime of the
// ResultType value is less than the OpIter, we can just borrow the pointer
// without ownership or copying.
class ResultType {
  using Tagged = TaggedValue<const ValTypeVector>;
  Tagged tagged_;

  enum Kind {
    EmptyKind = Tagged::ImmediateKind1,
    SingleKind = Tagged::ImmediateKind2,
#ifdef ENABLE_WASM_MULTI_VALUE
    VectorKind = Tagged::PointerKind1,
#endif
    InvalidKind = Tagged::PointerKind2,
  };

  ResultType(Kind kind, uint32_t imm) : tagged_(Tagged::Kind(kind), imm) {}
#ifdef ENABLE_WASM_MULTI_VALUE
  explicit ResultType(const ValTypeVector* ptr)
      : tagged_(Tagged::Kind(VectorKind), ptr) {}
#endif

  Kind kind() const { return Kind(tagged_.kind()); }

  ValType singleValType() const {
    MOZ_ASSERT(kind() == SingleKind);
    return ValType(PackedTypeCodeFromBits(tagged_.immediate()));
  }

#ifdef ENABLE_WASM_MULTI_VALUE
  const ValTypeVector& values() const {
    MOZ_ASSERT(kind() == VectorKind);
    return *tagged_.pointer();
  }
#endif

 public:
  ResultType() : tagged_(Tagged::Kind(InvalidKind), nullptr) {}

  static ResultType Empty() { return ResultType(EmptyKind, uint32_t(0)); }
  static ResultType Single(ValType vt) {
    return ResultType(SingleKind, vt.bitsUnsafe());
  }
  static ResultType Vector(const ValTypeVector& vals) {
    switch (vals.length()) {
      case 0:
        return Empty();
      case 1:
        return Single(vals[0]);
      default:
#ifdef ENABLE_WASM_MULTI_VALUE
        return ResultType(&vals);
#else
        MOZ_CRASH("multi-value returns not supported");
#endif
    }
  }

  bool empty() const { return kind() == EmptyKind; }

  size_t length() const {
    switch (kind()) {
      case EmptyKind:
        return 0;
      case SingleKind:
        return 1;
#ifdef ENABLE_WASM_MULTI_VALUE
      case VectorKind:
        return values().length();
#endif
      default:
        MOZ_CRASH("bad resulttype");
    }
  }

  ValType operator[](size_t i) const {
    switch (kind()) {
      case SingleKind:
        MOZ_ASSERT(i == 0);
        return singleValType();
#ifdef ENABLE_WASM_MULTI_VALUE
      case VectorKind:
        return values()[i];
#endif
      default:
        MOZ_CRASH("bad resulttype");
    }
  }

  bool operator==(ResultType rhs) const {
    switch (kind()) {
      case EmptyKind:
      case SingleKind:
      case InvalidKind:
        return tagged_.bits() == rhs.tagged_.bits();
#ifdef ENABLE_WASM_MULTI_VALUE
      case VectorKind: {
        if (rhs.kind() != VectorKind) {
          return false;
        }
        return EqualContainers(values(), rhs.values());
      }
#endif
      default:
        MOZ_CRASH("bad resulttype");
    }
  }
  bool operator!=(ResultType rhs) const { return !(*this == rhs); }
};

// BlockType represents the WebAssembly spec's `blocktype`. Semantically, a
// block type is just a (vec(valtype) -> vec(valtype)) with four special
// encodings which are represented explicitly in BlockType:
//  [] -> []
//  [] -> [valtype]
//  [params] -> [results] via pointer to FuncType
//  [] -> [results] via pointer to FuncType (ignoring [params])

class BlockType {
  using Tagged = TaggedValue<const FuncType>;
  Tagged tagged_;

  enum Kind {
    VoidToVoidKind = Tagged::ImmediateKind1,
    VoidToSingleKind = Tagged::ImmediateKind2,
#ifdef ENABLE_WASM_MULTI_VALUE
    FuncKind = Tagged::PointerKind1,
    FuncResultsKind = Tagged::PointerKind2
#endif
  };

  BlockType(Kind kind, uint32_t imm) : tagged_(Tagged::Kind(kind), imm) {}
#ifdef ENABLE_WASM_MULTI_VALUE
  BlockType(Kind kind, const FuncType& type)
      : tagged_(Tagged::Kind(kind), &type) {}
#endif

  Kind kind() const { return Kind(tagged_.kind()); }
  ValType singleValType() const {
    MOZ_ASSERT(kind() == VoidToSingleKind);
    return ValType(PackedTypeCodeFromBits(tagged_.immediate()));
  }

#ifdef ENABLE_WASM_MULTI_VALUE
  const FuncType& funcType() const { return *tagged_.pointer(); }
#endif

 public:
  BlockType()
      : tagged_(Tagged::Kind(VoidToVoidKind),
                uint32_t(InvalidPackedTypeCode())) {}

  static BlockType VoidToVoid() {
    return BlockType(VoidToVoidKind, uint32_t(0));
  }
  static BlockType VoidToSingle(ValType vt) {
    return BlockType(VoidToSingleKind, vt.bitsUnsafe());
  }
  static BlockType Func(const FuncType& type) {
#ifdef ENABLE_WASM_MULTI_VALUE
    if (type.args().length() == 0) {
      return FuncResults(type);
    }
    return BlockType(FuncKind, type);
#else
    MOZ_ASSERT(type.args().length() == 0);
    return FuncResults(type);
#endif
  }
  static BlockType FuncResults(const FuncType& type) {
    switch (type.results().length()) {
      case 0:
        return VoidToVoid();
      case 1:
        return VoidToSingle(type.results()[0]);
      default:
#ifdef ENABLE_WASM_MULTI_VALUE
        return BlockType(FuncResultsKind, type);
#else
        MOZ_CRASH("multi-value returns not supported");
#endif
    }
  }

  ResultType params() const {
    switch (kind()) {
      case VoidToVoidKind:
      case VoidToSingleKind:
#ifdef ENABLE_WASM_MULTI_VALUE
      case FuncResultsKind:
#endif
        return ResultType::Empty();
#ifdef ENABLE_WASM_MULTI_VALUE
      case FuncKind:
        return ResultType::Vector(funcType().args());
#endif
      default:
        MOZ_CRASH("unexpected kind");
    }
  }

  ResultType results() const {
    switch (kind()) {
      case VoidToVoidKind:
        return ResultType::Empty();
      case VoidToSingleKind:
        return ResultType::Single(singleValType());
#ifdef ENABLE_WASM_MULTI_VALUE
      case FuncKind:
      case FuncResultsKind:
        return ResultType::Vector(funcType().results());
#endif
      default:
        MOZ_CRASH("unexpected kind");
    }
  }

  bool operator==(BlockType rhs) const {
    if (kind() != rhs.kind()) {
      return false;
    }
    switch (kind()) {
      case VoidToVoidKind:
      case VoidToSingleKind:
        return tagged_.bits() == rhs.tagged_.bits();
#ifdef ENABLE_WASM_MULTI_VALUE
      case FuncKind:
        return funcType() == rhs.funcType();
      case FuncResultsKind:
        return EqualContainers(funcType().results(), rhs.funcType().results());
#endif
      default:
        MOZ_CRASH("unexpected kind");
    }
  }

  bool operator!=(BlockType rhs) const { return !(*this == rhs); }
};

// Structure type.
//
// The Module owns a dense array of StructType values that represent the
// structure types that the module knows about.  It is created from the sparse
// array of types in the ModuleEnvironment when the Module is created.

struct StructField {
  ValType type;
  uint32_t offset;
  bool isMutable;
};

typedef Vector<StructField, 0, SystemAllocPolicy> StructFieldVector;

class StructType {
 public:
  StructFieldVector fields_;  // Field type, offset, and mutability
  uint32_t moduleIndex_;      // Index in a dense array of structs in the module
  bool isInline_;             // True if this is an InlineTypedObject and we
                   //   interpret the offsets from the object pointer;
                   //   if false this is an OutlineTypedObject and we
                   //   interpret everything relative to the pointer to
                   //   the attached storage.
 public:
  StructType() : fields_(), moduleIndex_(0), isInline_(true) {}

  StructType(StructFieldVector&& fields, uint32_t index, bool isInline)
      : fields_(std::move(fields)), moduleIndex_(index), isInline_(isInline) {}

  bool copyFrom(const StructType& src) {
    if (!fields_.appendAll(src.fields_)) {
      return false;
    }
    moduleIndex_ = src.moduleIndex_;
    isInline_ = src.isInline_;
    return true;
  }

  bool hasPrefix(const StructType& other) const;

  WASM_DECLARE_SERIALIZABLE(StructType)
};

typedef Vector<StructType, 0, SystemAllocPolicy> StructTypeVector;

// An InitExpr describes a deferred initializer expression, used to initialize
// a global or a table element offset. Such expressions are created during
// decoding and actually executed on module instantiation.

class InitExpr {
 public:
  enum class Kind { Constant, GetGlobal, RefFunc };

 private:
  // Note: all this private data is currently (de)serialized via memcpy().
  Kind kind_;
  union U {
    LitVal val_;
    struct {
      uint32_t index_;
      ValType type_;
    } global;
    uint32_t refFuncIndex_;
    U() : global{} {}
  } u;

 public:
  InitExpr() = default;

  static InitExpr fromConstant(LitVal val) {
    InitExpr expr;
    expr.kind_ = Kind::Constant;
    expr.u.val_ = val;
    return expr;
  }

  static InitExpr fromGetGlobal(uint32_t globalIndex, ValType type) {
    InitExpr expr;
    expr.kind_ = Kind::GetGlobal;
    expr.u.global.index_ = globalIndex;
    expr.u.global.type_ = type;
    return expr;
  }

  static InitExpr fromRefFunc(uint32_t refFuncIndex) {
    InitExpr expr;
    expr.kind_ = Kind::RefFunc;
    expr.u.refFuncIndex_ = refFuncIndex;
    return expr;
  }

  Kind kind() const { return kind_; }

  bool isVal() const { return kind() == Kind::Constant; }
  LitVal val() const {
    MOZ_ASSERT(isVal());
    return u.val_;
  }

  uint32_t globalIndex() const {
    MOZ_ASSERT(kind() == Kind::GetGlobal);
    return u.global.index_;
  }

  uint32_t refFuncIndex() const {
    MOZ_ASSERT(kind() == Kind::RefFunc);
    return u.refFuncIndex_;
  }

  ValType type() const {
    switch (kind()) {
      case Kind::Constant:
        return u.val_.type();
      case Kind::GetGlobal:
        return u.global.type_;
      case Kind::RefFunc:
        return ValType(RefType::func());
    }
    MOZ_CRASH("unexpected initExpr type");
  }
};

// CacheableChars is used to cacheably store UniqueChars.

struct CacheableChars : UniqueChars {
  CacheableChars() = default;
  explicit CacheableChars(char* ptr) : UniqueChars(ptr) {}
  MOZ_IMPLICIT CacheableChars(UniqueChars&& rhs)
      : UniqueChars(std::move(rhs)) {}
  WASM_DECLARE_SERIALIZABLE(CacheableChars)
};

typedef Vector<CacheableChars, 0, SystemAllocPolicy> CacheableCharsVector;

// Import describes a single wasm import. An ImportVector describes all
// of a single module's imports.
//
// ImportVector is built incrementally by ModuleGenerator and then stored
// immutably by Module.

struct Import {
  CacheableChars module;
  CacheableChars field;
  DefinitionKind kind;

  Import() = default;
  Import(UniqueChars&& module, UniqueChars&& field, DefinitionKind kind)
      : module(std::move(module)), field(std::move(field)), kind(kind) {}

  WASM_DECLARE_SERIALIZABLE(Import)
};

typedef Vector<Import, 0, SystemAllocPolicy> ImportVector;

// Export describes the export of a definition in a Module to a field in the
// export object. For functions, Export stores an index into the
// FuncExportVector in Metadata. For memory and table exports, there is
// at most one (default) memory/table so no index is needed. Note: a single
// definition can be exported by multiple Exports in the ExportVector.
//
// ExportVector is built incrementally by ModuleGenerator and then stored
// immutably by Module.

class Export {
  CacheableChars fieldName_;
  struct CacheablePod {
    DefinitionKind kind_;
    uint32_t index_;
  } pod;

 public:
  Export() = default;
  explicit Export(UniqueChars fieldName, uint32_t index, DefinitionKind kind);
  explicit Export(UniqueChars fieldName, DefinitionKind kind);

  const char* fieldName() const { return fieldName_.get(); }

  DefinitionKind kind() const { return pod.kind_; }
  uint32_t funcIndex() const;
  uint32_t globalIndex() const;
  uint32_t tableIndex() const;

  WASM_DECLARE_SERIALIZABLE(Export)
};

typedef Vector<Export, 0, SystemAllocPolicy> ExportVector;

// A GlobalDesc describes a single global variable.
//
// wasm can import and export mutable and immutable globals.
//
// asm.js can import mutable and immutable globals, but a mutable global has a
// location that is private to the module, and its initial value is copied into
// that cell from the environment.  asm.js cannot export globals.

enum class GlobalKind { Import, Constant, Variable };

class GlobalDesc {
  union V {
    struct {
      union U {
        InitExpr initial_;
        struct {
          ValType type_;
          uint32_t index_;
        } import;
        U() : import{} {}
      } val;
      unsigned offset_;
      bool isMutable_;
      bool isWasm_;
      bool isExport_;
    } var;
    LitVal cst_;
    V() {}
  } u;
  GlobalKind kind_;

  // Private, as they have unusual semantics.

  bool isExport() const { return !isConstant() && u.var.isExport_; }
  bool isWasm() const { return !isConstant() && u.var.isWasm_; }

 public:
  GlobalDesc() = default;

  explicit GlobalDesc(InitExpr initial, bool isMutable,
                      ModuleKind kind = ModuleKind::Wasm)
      : kind_((isMutable || !initial.isVal()) ? GlobalKind::Variable
                                              : GlobalKind::Constant) {
    if (isVariable()) {
      u.var.val.initial_ = initial;
      u.var.isMutable_ = isMutable;
      u.var.isWasm_ = kind == Wasm;
      u.var.isExport_ = false;
      u.var.offset_ = UINT32_MAX;
    } else {
      u.cst_ = initial.val();
    }
  }

  explicit GlobalDesc(ValType type, bool isMutable, uint32_t importIndex,
                      ModuleKind kind = ModuleKind::Wasm)
      : kind_(GlobalKind::Import) {
    u.var.val.import.type_ = type;
    u.var.val.import.index_ = importIndex;
    u.var.isMutable_ = isMutable;
    u.var.isWasm_ = kind == Wasm;
    u.var.isExport_ = false;
    u.var.offset_ = UINT32_MAX;
  }

  void setOffset(unsigned offset) {
    MOZ_ASSERT(!isConstant());
    MOZ_ASSERT(u.var.offset_ == UINT32_MAX);
    u.var.offset_ = offset;
  }
  unsigned offset() const {
    MOZ_ASSERT(!isConstant());
    MOZ_ASSERT(u.var.offset_ != UINT32_MAX);
    return u.var.offset_;
  }

  void setIsExport() {
    if (!isConstant()) {
      u.var.isExport_ = true;
    }
  }

  GlobalKind kind() const { return kind_; }
  bool isVariable() const { return kind_ == GlobalKind::Variable; }
  bool isConstant() const { return kind_ == GlobalKind::Constant; }
  bool isImport() const { return kind_ == GlobalKind::Import; }

  bool isMutable() const { return !isConstant() && u.var.isMutable_; }
  LitVal constantValue() const {
    MOZ_ASSERT(isConstant());
    return u.cst_;
  }
  const InitExpr& initExpr() const {
    MOZ_ASSERT(isVariable());
    return u.var.val.initial_;
  }
  uint32_t importIndex() const {
    MOZ_ASSERT(isImport());
    return u.var.val.import.index_;
  }

  // If isIndirect() is true then storage for the value is not in the
  // instance's global area, but in a WasmGlobalObject::Cell hanging off a
  // WasmGlobalObject; the global area contains a pointer to the Cell.
  //
  // We don't want to indirect unless we must, so only mutable, exposed
  // globals are indirected - in all other cases we copy values into and out
  // of their module.
  //
  // Note that isIndirect() isn't equivalent to getting a WasmGlobalObject:
  // an immutable exported global will still get an object, but will not be
  // indirect.
  bool isIndirect() const {
    return isMutable() && isWasm() && (isImport() || isExport());
  }

  ValType type() const {
    switch (kind_) {
      case GlobalKind::Import:
        return u.var.val.import.type_;
      case GlobalKind::Variable:
        return u.var.val.initial_.type();
      case GlobalKind::Constant:
        return u.cst_.type();
    }
    MOZ_CRASH("unexpected global kind");
  }
};

typedef Vector<GlobalDesc, 0, SystemAllocPolicy> GlobalDescVector;

// When a ElemSegment is "passive" it is shared between a wasm::Module and its
// wasm::Instances. To allow each segment to be released as soon as the last
// Instance elem.drops it and the Module is destroyed, each ElemSegment is
// individually atomically ref-counted.

struct ElemSegment : AtomicRefCounted<ElemSegment> {
  enum class Kind {
    Active,
    Passive,
    Declared,
  };

  Kind kind;
  uint32_t tableIndex;
  ValType elementType;
  Maybe<InitExpr> offsetIfActive;
  Uint32Vector elemFuncIndices;  // Element may be NullFuncIndex

  bool active() const { return kind == Kind::Active; }

  InitExpr offset() const { return *offsetIfActive; }

  size_t length() const { return elemFuncIndices.length(); }

  ValType elemType() const { return elementType; }

  WASM_DECLARE_SERIALIZABLE(ElemSegment)
};

// NullFuncIndex represents the case when an element segment (of type funcref)
// contains a null element.
constexpr uint32_t NullFuncIndex = UINT32_MAX;
static_assert(NullFuncIndex > MaxFuncs, "Invariant");

using MutableElemSegment = RefPtr<ElemSegment>;
using SharedElemSegment = SerializableRefPtr<const ElemSegment>;
typedef Vector<SharedElemSegment, 0, SystemAllocPolicy> ElemSegmentVector;

// DataSegmentEnv holds the initial results of decoding a data segment from the
// bytecode and is stored in the ModuleEnvironment during compilation. When
// compilation completes, (non-Env) DataSegments are created and stored in
// the wasm::Module which contain copies of the data segment payload. This
// allows non-compilation uses of wasm validation to avoid expensive copies.
//
// When a DataSegment is "passive" it is shared between a wasm::Module and its
// wasm::Instances. To allow each segment to be released as soon as the last
// Instance mem.drops it and the Module is destroyed, each DataSegment is
// individually atomically ref-counted.

struct DataSegmentEnv {
  Maybe<InitExpr> offsetIfActive;
  uint32_t bytecodeOffset;
  uint32_t length;
};

typedef Vector<DataSegmentEnv, 0, SystemAllocPolicy> DataSegmentEnvVector;

struct DataSegment : AtomicRefCounted<DataSegment> {
  Maybe<InitExpr> offsetIfActive;
  Bytes bytes;

  DataSegment() = default;
  explicit DataSegment(const DataSegmentEnv& src)
      : offsetIfActive(src.offsetIfActive) {}

  bool active() const { return !!offsetIfActive; }

  InitExpr offset() const { return *offsetIfActive; }

  WASM_DECLARE_SERIALIZABLE(DataSegment)
};

using MutableDataSegment = RefPtr<DataSegment>;
using SharedDataSegment = SerializableRefPtr<const DataSegment>;
typedef Vector<SharedDataSegment, 0, SystemAllocPolicy> DataSegmentVector;

// The CustomSection(Env) structs are like DataSegment(Env): CustomSectionEnv is
// stored in the ModuleEnvironment and CustomSection holds a copy of the payload
// and is stored in the wasm::Module.

struct CustomSectionEnv {
  uint32_t nameOffset;
  uint32_t nameLength;
  uint32_t payloadOffset;
  uint32_t payloadLength;
};

typedef Vector<CustomSectionEnv, 0, SystemAllocPolicy> CustomSectionEnvVector;

struct CustomSection {
  Bytes name;
  SharedBytes payload;

  WASM_DECLARE_SERIALIZABLE(CustomSection)
};

typedef Vector<CustomSection, 0, SystemAllocPolicy> CustomSectionVector;

// A Name represents a string of utf8 chars embedded within the name custom
// section. The offset of a name is expressed relative to the beginning of the
// name section's payload so that Names can stored in wasm::Code, which only
// holds the name section's bytes, not the whole bytecode.

struct Name {
  // All fields are treated as cacheable POD:
  uint32_t offsetInNamePayload;
  uint32_t length;

  Name() : offsetInNamePayload(UINT32_MAX), length(0) {}
};

typedef Vector<Name, 0, SystemAllocPolicy> NameVector;

// FuncTypeIdDesc describes a function type that can be used by call_indirect
// and table-entry prologues to structurally compare whether the caller and
// callee's signatures *structurally* match. To handle the general case, a
// FuncType is allocated and stored in a process-wide hash table, so that
// pointer equality implies structural equality. As an optimization for the 99%
// case where the FuncType has a small number of parameters, the FuncType is
// bit-packed into a uint32 immediate value so that integer equality implies
// structural equality. Both cases can be handled with a single comparison by
// always setting the LSB for the immediates (the LSB is necessarily 0 for
// allocated FuncType pointers due to alignment).

class FuncTypeIdDesc {
 public:
  static const uintptr_t ImmediateBit = 0x1;

 private:
  FuncTypeIdDescKind kind_;
  size_t bits_;

  FuncTypeIdDesc(FuncTypeIdDescKind kind, size_t bits)
      : kind_(kind), bits_(bits) {}

 public:
  FuncTypeIdDescKind kind() const { return kind_; }
  static bool isGlobal(const FuncType& funcType);

  FuncTypeIdDesc() : kind_(FuncTypeIdDescKind::None), bits_(0) {}
  static FuncTypeIdDesc global(const FuncType& funcType,
                               uint32_t globalDataOffset);
  static FuncTypeIdDesc immediate(const FuncType& funcType);

  bool isGlobal() const { return kind_ == FuncTypeIdDescKind::Global; }

  size_t immediate() const {
    MOZ_ASSERT(kind_ == FuncTypeIdDescKind::Immediate);
    return bits_;
  }
  uint32_t globalDataOffset() const {
    MOZ_ASSERT(kind_ == FuncTypeIdDescKind::Global);
    return bits_;
  }
};

// FuncTypeWithId pairs a FuncType with FuncTypeIdDesc, describing either how to
// compile code that compares this signature's id or, at instantiation what
// signature ids to allocate in the global hash and where to put them.

struct FuncTypeWithId : FuncType {
  FuncTypeIdDesc id;

  FuncTypeWithId() = default;
  explicit FuncTypeWithId(FuncType&& funcType)
      : FuncType(std::move(funcType)), id() {}
  FuncTypeWithId(FuncType&& funcType, FuncTypeIdDesc id)
      : FuncType(std::move(funcType)), id(id) {}
  void operator=(FuncType&& rhs) { FuncType::operator=(std::move(rhs)); }

  WASM_DECLARE_SERIALIZABLE(FuncTypeWithId)
};

typedef Vector<FuncTypeWithId, 0, SystemAllocPolicy> FuncTypeWithIdVector;
typedef Vector<const FuncTypeWithId*, 0, SystemAllocPolicy>
    FuncTypeWithIdPtrVector;

// A tagged container for the various types that can be present in a wasm
// module's type section.

class TypeDef {
  enum { IsFuncType, IsStructType, IsNone } tag_;
  union {
    FuncTypeWithId funcType_;
    StructType structType_;
  };

 public:
  TypeDef() : tag_(IsNone) {}

  explicit TypeDef(FuncType&& funcType)
      : tag_(IsFuncType), funcType_(FuncTypeWithId(std::move(funcType))) {}

  explicit TypeDef(StructType&& structType)
      : tag_(IsStructType), structType_(std::move(structType)) {}

  TypeDef(TypeDef&& td) : tag_(td.tag_) {
    switch (tag_) {
      case IsFuncType:
        new (&funcType_) FuncTypeWithId(std::move(td.funcType_));
        break;
      case IsStructType:
        new (&structType_) StructType(std::move(td.structType_));
        break;
      case IsNone:
        break;
    }
  }

  ~TypeDef() {
    switch (tag_) {
      case IsFuncType:
        funcType_.~FuncTypeWithId();
        break;
      case IsStructType:
        structType_.~StructType();
        break;
      case IsNone:
        break;
    }
  }

  TypeDef& operator=(TypeDef&& that) {
    MOZ_ASSERT(isNone());
    switch (that.tag_) {
      case IsFuncType:
        new (&funcType_) FuncTypeWithId(std::move(that.funcType_));
        break;
      case IsStructType:
        new (&structType_) StructType(std::move(that.structType_));
        break;
      case IsNone:
        break;
    }
    tag_ = that.tag_;
    return *this;
  }

  bool isFuncType() const { return tag_ == IsFuncType; }

  bool isNone() const { return tag_ == IsNone; }

  bool isStructType() const { return tag_ == IsStructType; }

  const FuncTypeWithId& funcType() const {
    MOZ_ASSERT(isFuncType());
    return funcType_;
  }

  FuncTypeWithId& funcType() {
    MOZ_ASSERT(isFuncType());
    return funcType_;
  }

  // p has to point to the funcType_ embedded within a TypeDef for this to be
  // valid.
  static const TypeDef* fromFuncTypeWithIdPtr(const FuncTypeWithId* p) {
    const TypeDef* q =
        (const TypeDef*)((char*)p - offsetof(TypeDef, funcType_));
    MOZ_ASSERT(q->tag_ == IsFuncType);
    return q;
  }

  const StructType& structType() const {
    MOZ_ASSERT(isStructType());
    return structType_;
  }

  StructType& structType() {
    MOZ_ASSERT(isStructType());
    return structType_;
  }

  // p has to point to the struct_ embedded within a TypeDef for this to be
  // valid.
  static const TypeDef* fromStructPtr(const StructType* p) {
    const TypeDef* q =
        (const TypeDef*)((char*)p - offsetof(TypeDef, structType_));
    MOZ_ASSERT(q->tag_ == IsStructType);
    return q;
  }
};

typedef Vector<TypeDef, 0, SystemAllocPolicy> TypeDefVector;

// A wrapper around the bytecode offset of a wasm instruction within a whole
// module, used for trap offsets or call offsets. These offsets should refer to
// the first byte of the instruction that triggered the trap / did the call and
// should ultimately derive from OpIter::bytecodeOffset.

class BytecodeOffset {
  static const uint32_t INVALID = -1;
  uint32_t offset_;

 public:
  BytecodeOffset() : offset_(INVALID) {}
  explicit BytecodeOffset(uint32_t offset) : offset_(offset) {}

  bool isValid() const { return offset_ != INVALID; }
  uint32_t offset() const {
    MOZ_ASSERT(isValid());
    return offset_;
  }
};

// A TrapSite (in the TrapSiteVector for a given Trap code) represents a wasm
// instruction at a given bytecode offset that can fault at the given pc offset.
// When such a fault occurs, a signal/exception handler looks up the TrapSite to
// confirm the fault is intended/safe and redirects pc to the trap stub.

struct TrapSite {
  uint32_t pcOffset;
  BytecodeOffset bytecode;

  TrapSite() : pcOffset(-1), bytecode() {}
  TrapSite(uint32_t pcOffset, BytecodeOffset bytecode)
      : pcOffset(pcOffset), bytecode(bytecode) {}

  void offsetBy(uint32_t offset) { pcOffset += offset; }
};

WASM_DECLARE_POD_VECTOR(TrapSite, TrapSiteVector)

struct TrapSiteVectorArray
    : EnumeratedArray<Trap, Trap::Limit, TrapSiteVector> {
  bool empty() const;
  void clear();
  void swap(TrapSiteVectorArray& rhs);
  void shrinkStorageToFit();

  WASM_DECLARE_SERIALIZABLE(TrapSiteVectorArray)
};

// On trap, the bytecode offset to be reported in callstacks is saved.

struct TrapData {
  // The resumePC indicates where, if the trap doesn't throw, the trap stub
  // should jump to after restoring all register state.
  void* resumePC;

  // The unwoundPC is the PC after adjustment by wasm::StartUnwinding(), which
  // basically unwinds partially-construted wasm::Frames when pc is in the
  // prologue/epilogue. Stack traces during a trap should use this PC since
  // it corresponds to the JitActivation::wasmExitFP.
  void* unwoundPC;

  Trap trap;
  uint32_t bytecodeOffset;
};

// The (,Callable,Func)Offsets classes are used to record the offsets of
// different key points in a CodeRange during compilation.

struct Offsets {
  explicit Offsets(uint32_t begin = 0, uint32_t end = 0)
      : begin(begin), end(end) {}

  // These define a [begin, end) contiguous range of instructions compiled
  // into a CodeRange.
  uint32_t begin;
  uint32_t end;
};

struct CallableOffsets : Offsets {
  MOZ_IMPLICIT CallableOffsets(uint32_t ret = 0) : Offsets(), ret(ret) {}

  // The offset of the return instruction precedes 'end' by a variable number
  // of instructions due to out-of-line codegen.
  uint32_t ret;
};

struct JitExitOffsets : CallableOffsets {
  MOZ_IMPLICIT JitExitOffsets()
      : CallableOffsets(), untrustedFPStart(0), untrustedFPEnd(0) {}

  // There are a few instructions in the Jit exit where FP may be trash
  // (because it may have been clobbered by the JS Jit), known as the
  // untrusted FP zone.
  uint32_t untrustedFPStart;
  uint32_t untrustedFPEnd;
};

struct FuncOffsets : CallableOffsets {
  MOZ_IMPLICIT FuncOffsets()
      : CallableOffsets(), normalEntry(0), tierEntry(0) {}

  // Function CodeRanges have a table entry which takes an extra signature
  // argument which is checked against the callee's signature before falling
  // through to the normal prologue. The table entry is thus at the beginning
  // of the CodeRange and the normal entry is at some offset after the table
  // entry.
  uint32_t normalEntry;

  // The tierEntry is the point within a function to which the patching code
  // within a Tier-1 function jumps.  It could be the instruction following
  // the jump in the Tier-1 function, or the point following the standard
  // prologue within a Tier-2 function.
  uint32_t tierEntry;
};

typedef Vector<FuncOffsets, 0, SystemAllocPolicy> FuncOffsetsVector;

// A CodeRange describes a single contiguous range of code within a wasm
// module's code segment. A CodeRange describes what the code does and, for
// function bodies, the name and source coordinates of the function.

class CodeRange {
 public:
  enum Kind {
    Function,          // function definition
    InterpEntry,       // calls into wasm from C++
    JitEntry,          // calls into wasm from jit code
    ImportInterpExit,  // slow-path calling from wasm into C++ interp
    ImportJitExit,     // fast-path calling from wasm into jit code
    BuiltinThunk,      // fast-path calling from wasm into a C++ native
    TrapExit,          // calls C++ to report and jumps to throw stub
    DebugTrap,         // calls C++ to handle debug event
    FarJumpIsland,     // inserted to connect otherwise out-of-range insns
    Throw              // special stack-unwinding stub jumped to by other stubs
  };

 private:
  // All fields are treated as cacheable POD:
  uint32_t begin_;
  uint32_t ret_;
  uint32_t end_;
  union {
    struct {
      uint32_t funcIndex_;
      union {
        struct {
          uint32_t lineOrBytecode_;
          uint8_t beginToNormalEntry_;
          uint8_t beginToTierEntry_;
        } func;
        struct {
          uint16_t beginToUntrustedFPStart_;
          uint16_t beginToUntrustedFPEnd_;
        } jitExit;
      };
    };
    Trap trap_;
  } u;
  Kind kind_ : 8;

 public:
  CodeRange() = default;
  CodeRange(Kind kind, Offsets offsets);
  CodeRange(Kind kind, uint32_t funcIndex, Offsets offsets);
  CodeRange(Kind kind, CallableOffsets offsets);
  CodeRange(Kind kind, uint32_t funcIndex, CallableOffsets);
  CodeRange(uint32_t funcIndex, JitExitOffsets offsets);
  CodeRange(uint32_t funcIndex, uint32_t lineOrBytecode, FuncOffsets offsets);

  void offsetBy(uint32_t offset) {
    begin_ += offset;
    end_ += offset;
    if (hasReturn()) {
      ret_ += offset;
    }
  }

  // All CodeRanges have a begin and end.

  uint32_t begin() const { return begin_; }
  uint32_t end() const { return end_; }

  // Other fields are only available for certain CodeRange::Kinds.

  Kind kind() const { return kind_; }

  bool isFunction() const { return kind() == Function; }
  bool isImportExit() const {
    return kind() == ImportJitExit || kind() == ImportInterpExit ||
           kind() == BuiltinThunk;
  }
  bool isImportInterpExit() const { return kind() == ImportInterpExit; }
  bool isImportJitExit() const { return kind() == ImportJitExit; }
  bool isTrapExit() const { return kind() == TrapExit; }
  bool isDebugTrap() const { return kind() == DebugTrap; }
  bool isThunk() const { return kind() == FarJumpIsland; }

  // Function, import exits and trap exits have standard callable prologues
  // and epilogues. Asynchronous frame iteration needs to know the offset of
  // the return instruction to calculate the frame pointer.

  bool hasReturn() const {
    return isFunction() || isImportExit() || isDebugTrap();
  }
  uint32_t ret() const {
    MOZ_ASSERT(hasReturn());
    return ret_;
  }

  // Functions, export stubs and import stubs all have an associated function
  // index.

  bool isJitEntry() const { return kind() == JitEntry; }
  bool isInterpEntry() const { return kind() == InterpEntry; }
  bool isEntry() const { return isInterpEntry() || isJitEntry(); }
  bool hasFuncIndex() const {
    return isFunction() || isImportExit() || isEntry();
  }
  uint32_t funcIndex() const {
    MOZ_ASSERT(hasFuncIndex());
    return u.funcIndex_;
  }

  // TrapExit CodeRanges have a Trap field.

  Trap trap() const {
    MOZ_ASSERT(isTrapExit());
    return u.trap_;
  }

  // Function CodeRanges have two entry points: one for normal calls (with a
  // known signature) and one for table calls (which involves dynamic
  // signature checking).

  uint32_t funcTableEntry() const {
    MOZ_ASSERT(isFunction());
    return begin_;
  }
  uint32_t funcNormalEntry() const {
    MOZ_ASSERT(isFunction());
    return begin_ + u.func.beginToNormalEntry_;
  }
  uint32_t funcTierEntry() const {
    MOZ_ASSERT(isFunction());
    return begin_ + u.func.beginToTierEntry_;
  }
  uint32_t funcLineOrBytecode() const {
    MOZ_ASSERT(isFunction());
    return u.func.lineOrBytecode_;
  }

  // ImportJitExit have a particular range where the value of FP can't be
  // trusted for profiling and thus must be ignored.

  uint32_t jitExitUntrustedFPStart() const {
    MOZ_ASSERT(isImportJitExit());
    return begin_ + u.jitExit.beginToUntrustedFPStart_;
  }
  uint32_t jitExitUntrustedFPEnd() const {
    MOZ_ASSERT(isImportJitExit());
    return begin_ + u.jitExit.beginToUntrustedFPEnd_;
  }

  // A sorted array of CodeRanges can be looked up via BinarySearch and
  // OffsetInCode.

  struct OffsetInCode {
    size_t offset;
    explicit OffsetInCode(size_t offset) : offset(offset) {}
    bool operator==(const CodeRange& rhs) const {
      return offset >= rhs.begin() && offset < rhs.end();
    }
    bool operator<(const CodeRange& rhs) const { return offset < rhs.begin(); }
  };
};

WASM_DECLARE_POD_VECTOR(CodeRange, CodeRangeVector)

extern const CodeRange* LookupInSorted(const CodeRangeVector& codeRanges,
                                       CodeRange::OffsetInCode target);

// While the frame-pointer chain allows the stack to be unwound without
// metadata, Error.stack still needs to know the line/column of every call in
// the chain. A CallSiteDesc describes a single callsite to which CallSite adds
// the metadata necessary to walk up to the next frame. Lastly CallSiteAndTarget
// adds the function index of the callee.

class CallSiteDesc {
  static constexpr size_t LINE_OR_BYTECODE_BITS_SIZE = 29;
  uint32_t lineOrBytecode_ : LINE_OR_BYTECODE_BITS_SIZE;
  uint32_t kind_ : 3;

 public:
  static constexpr uint32_t MAX_LINE_OR_BYTECODE_VALUE =
      (1 << LINE_OR_BYTECODE_BITS_SIZE) - 1;

  enum Kind {
    Func,        // pc-relative call to a specific function
    Dynamic,     // dynamic callee called via register
    Symbolic,    // call to a single symbolic callee
    EnterFrame,  // call to a enter frame handler
    LeaveFrame,  // call to a leave frame handler
    Breakpoint   // call to instruction breakpoint
  };
  CallSiteDesc() : lineOrBytecode_(0), kind_(0) {}
  explicit CallSiteDesc(Kind kind) : lineOrBytecode_(0), kind_(kind) {
    MOZ_ASSERT(kind == Kind(kind_));
  }
  CallSiteDesc(uint32_t lineOrBytecode, Kind kind)
      : lineOrBytecode_(lineOrBytecode), kind_(kind) {
    MOZ_ASSERT(kind == Kind(kind_));
    MOZ_ASSERT(lineOrBytecode == lineOrBytecode_);
  }
  uint32_t lineOrBytecode() const { return lineOrBytecode_; }
  Kind kind() const { return Kind(kind_); }
};

class CallSite : public CallSiteDesc {
  uint32_t returnAddressOffset_;

 public:
  CallSite() : returnAddressOffset_(0) {}

  CallSite(CallSiteDesc desc, uint32_t returnAddressOffset)
      : CallSiteDesc(desc), returnAddressOffset_(returnAddressOffset) {}

  void offsetBy(int32_t delta) { returnAddressOffset_ += delta; }
  uint32_t returnAddressOffset() const { return returnAddressOffset_; }
};

WASM_DECLARE_POD_VECTOR(CallSite, CallSiteVector)

// A CallSiteTarget describes the callee of a CallSite, either a function or a
// trap exit. Although checked in debug builds, a CallSiteTarget doesn't
// officially know whether it targets a function or trap, relying on the Kind of
// the CallSite to discriminate.

class CallSiteTarget {
  uint32_t packed_;
#ifdef DEBUG
  enum Kind { None, FuncIndex, TrapExit } kind_;
#endif

 public:
  explicit CallSiteTarget()
      : packed_(UINT32_MAX)
#ifdef DEBUG
        ,
        kind_(None)
#endif
  {
  }

  explicit CallSiteTarget(uint32_t funcIndex)
      : packed_(funcIndex)
#ifdef DEBUG
        ,
        kind_(FuncIndex)
#endif
  {
  }

  explicit CallSiteTarget(Trap trap)
      : packed_(uint32_t(trap))
#ifdef DEBUG
        ,
        kind_(TrapExit)
#endif
  {
  }

  uint32_t funcIndex() const {
    MOZ_ASSERT(kind_ == FuncIndex);
    return packed_;
  }

  Trap trap() const {
    MOZ_ASSERT(kind_ == TrapExit);
    MOZ_ASSERT(packed_ < uint32_t(Trap::Limit));
    return Trap(packed_);
  }
};

typedef Vector<CallSiteTarget, 0, SystemAllocPolicy> CallSiteTargetVector;

// A wasm::SymbolicAddress represents a pointer to a well-known function that is
// embedded in wasm code. Since wasm code is serialized and later deserialized
// into a different address space, symbolic addresses must be used for *all*
// pointers into the address space. The MacroAssembler records a list of all
// SymbolicAddresses and the offsets of their use in the code for later patching
// during static linking.

enum class SymbolicAddress {
  ToInt32,
#if defined(JS_CODEGEN_ARM)
  aeabi_idivmod,
  aeabi_uidivmod,
#endif
  ModD,
  SinD,
  CosD,
  TanD,
  ASinD,
  ACosD,
  ATanD,
  CeilD,
  CeilF,
  FloorD,
  FloorF,
  TruncD,
  TruncF,
  NearbyIntD,
  NearbyIntF,
  ExpD,
  LogD,
  PowD,
  ATan2D,
  HandleDebugTrap,
  HandleThrow,
  HandleTrap,
  ReportV128JSCall,
  CallImport_Void,
  CallImport_I32,
  CallImport_I64,
  CallImport_V128,
  CallImport_F64,
  CallImport_FuncRef,
  CallImport_AnyRef,
  CoerceInPlace_ToInt32,
  CoerceInPlace_ToNumber,
  CoerceInPlace_JitEntry,
  CoerceInPlace_ToBigInt,
  AllocateBigInt,
  BoxValue_Anyref,
  DivI64,
  UDivI64,
  ModI64,
  UModI64,
  TruncateDoubleToInt64,
  TruncateDoubleToUint64,
  SaturatingTruncateDoubleToInt64,
  SaturatingTruncateDoubleToUint64,
  Uint64ToFloat32,
  Uint64ToDouble,
  Int64ToFloat32,
  Int64ToDouble,
  MemoryGrow,
  MemorySize,
  WaitI32,
  WaitI64,
  Wake,
  MemCopy,
  MemCopyShared,
  DataDrop,
  MemFill,
  MemFillShared,
  MemInit,
  TableCopy,
  ElemDrop,
  TableFill,
  TableGet,
  TableGrow,
  TableInit,
  TableSet,
  TableSize,
  RefFunc,
  PreBarrierFiltering,
  PostBarrier,
  PostBarrierFiltering,
  StructNew,
  StructNarrow,
#if defined(JS_CODEGEN_MIPS32)
  js_jit_gAtomic64Lock,
#endif
#ifdef WASM_CODEGEN_DEBUG
  PrintI32,
  PrintPtr,
  PrintF32,
  PrintF64,
  PrintText,
#endif
  Limit
};

// The FailureMode indicates whether, immediately after a call to a builtin
// returns, the return value should be checked against an error condition
// (and if so, which one) which signals that the C++ calle has already
// reported an error and thus wasm needs to wasmTrap(Trap::ThrowReported).

enum class FailureMode : uint8_t {
  Infallible,
  FailOnNegI32,
  FailOnNullPtr,
  FailOnInvalidRef
};

// SymbolicAddressSignature carries type information for a function referred
// to by a SymbolicAddress.  In order that |argTypes| can be written out as a
// static initialiser, it has to have fixed length.  At present
// SymbolicAddressType is used to describe functions with at most 6 arguments,
// so |argTypes| has 7 entries in order to allow the last value to be
// MIRType::None, in the hope of catching any accidental overruns of the
// defined section of the array.

static constexpr size_t SymbolicAddressSignatureMaxArgs = 6;

struct SymbolicAddressSignature {
  // The SymbolicAddress that is described.
  const SymbolicAddress identity;
  // The return type, or MIRType::None to denote 'void'.
  const jit::MIRType retType;
  // The failure mode, which is checked by masm.wasmCallBuiltinInstanceMethod.
  const FailureMode failureMode;
  // The number of arguments, 0 .. SymbolicAddressSignatureMaxArgs only.
  const uint8_t numArgs;
  // The argument types; SymbolicAddressSignatureMaxArgs + 1 guard, which
  // should be MIRType::None.
  const jit::MIRType argTypes[SymbolicAddressSignatureMaxArgs + 1];
};

// The 16 in this assertion is derived as follows: SymbolicAddress is probably
// size-4 aligned-4, but it's at the start of the struct, so there's no
// alignment hole before it.  All other components (MIRType and uint8_t) are
// size-1 aligned-1, and there are 8 in total, so it is reasonable to assume
// that they also don't create any alignment holes.  Hence it is also
// reasonable to assume that the actual size is 1 * 4 + 8 * 1 == 12.  The
// worst-plausible-case rounding will take that up to 16.  Hence, the
// assertion uses 16.

static_assert(sizeof(SymbolicAddressSignature) <= 16,
              "SymbolicAddressSignature unexpectedly large");

bool IsRoundingFunction(SymbolicAddress callee, jit::RoundingMode* mode);

// Represents the resizable limits of memories and tables.

struct Limits {
  uint32_t initial;
  Maybe<uint32_t> maximum;

  // `shared` is Shareable::False for tables but may be Shareable::True for
  // memories.
  Shareable shared;

  Limits() = default;
  explicit Limits(uint32_t initial, const Maybe<uint32_t>& maximum = Nothing(),
                  Shareable shared = Shareable::False)
      : initial(initial), maximum(maximum), shared(shared) {}
};

// TableDesc describes a table as well as the offset of the table's base pointer
// in global memory.
//
// The TableKind determines the representation:
//  - AnyRef: a wasm anyref word (wasm::AnyRef)
//  - FuncRef: a two-word FunctionTableElem (wasm indirect call ABI)
//  - AsmJS: a two-word FunctionTableElem (asm.js ABI)
// Eventually there should be a single unified AnyRef representation.

enum class TableKind { AnyRef, FuncRef, AsmJS };

static inline ValType ToElemValType(TableKind tk) {
  switch (tk) {
    case TableKind::AnyRef:
      return RefType::any();
    case TableKind::FuncRef:
      return RefType::func();
    case TableKind::AsmJS:
      break;
  }
  MOZ_MAKE_COMPILER_ASSUME_IS_UNREACHABLE("switch is exhaustive");
}

struct TableDesc {
  TableKind kind;
  bool importedOrExported;
  uint32_t globalDataOffset;
  Limits limits;

  TableDesc() = default;
  TableDesc(TableKind kind, const Limits& limits,
            bool importedOrExported = false)
      : kind(kind),
        importedOrExported(importedOrExported),
        globalDataOffset(UINT32_MAX),
        limits(limits) {}
};

typedef Vector<TableDesc, 0, SystemAllocPolicy> TableDescVector;

// An enum that describes the representation classes for tables; TableKind is
// mapped into this by Table::repr().

enum class TableRepr { Ref, Func };

// TLS data for a single module instance.
//
// Every WebAssembly function expects to be passed a hidden TLS pointer argument
// in WasmTlsReg. The TLS pointer argument points to a TlsData struct.
// Compiled functions expect that the TLS pointer does not change for the
// lifetime of the thread.
//
// There is a TlsData per module instance per thread, so inter-module calls need
// to pass the TLS pointer appropriate for the callee module.
//
// After the TlsData struct follows the module's declared TLS variables.

struct TlsData {
  // Pointer to the base of the default memory (or null if there is none).
  uint8_t* memoryBase;

  // Bounds check limit of memory, in bytes (or zero if there is no memory).
  uint32_t boundsCheckLimit;

  // Pointer to the Instance that contains this TLS data.
  Instance* instance;

  // Equal to instance->realm_.
  JS::Realm* realm;

  // The containing JSContext.
  JSContext* cx;

  // The class_ of WasmValueBox, this is a per-process value.
  const JSClass* valueBoxClass;

  // Usually equal to cx->stackLimitForJitCode(JS::StackForUntrustedScript),
  // but can be racily set to trigger immediate trap as an opportunity to
  // CheckForInterrupt without an additional branch.
  Atomic<uintptr_t, mozilla::Relaxed> stackLimit;

  // Set to 1 when wasm should call CheckForInterrupt.
  Atomic<uint32_t, mozilla::Relaxed> interrupt;

  uint8_t* addressOfNeedsIncrementalBarrier;

  // Methods to set, test and clear the above two fields. Both interrupt
  // fields are Relaxed and so no consistency/ordering can be assumed.
  void setInterrupt();
  bool isInterrupted() const;
  void resetInterrupt(JSContext* cx);

  // Pointer that should be freed (due to padding before the TlsData).
  void* allocatedBase;

  // When compiling with tiering, the jumpTable has one entry for each
  // baseline-compiled function.
  void** jumpTable;

  // The globalArea must be the last field.  Globals for the module start here
  // and are inline in this structure.  16-byte alignment is required for SIMD
  // data.
  MOZ_ALIGNED_DECL(char globalArea, 16);
};

static const size_t TlsDataAlign = 16;  // = Simd128DataSize
static_assert(offsetof(TlsData, globalArea) % TlsDataAlign == 0, "aligned");

struct TlsDataDeleter {
  void operator()(TlsData* tlsData) { js_free(tlsData->allocatedBase); }
};

typedef UniquePtr<TlsData, TlsDataDeleter> UniqueTlsData;

extern UniqueTlsData CreateTlsData(uint32_t globalDataLength);

// ExportArg holds the unboxed operands to the wasm entry trampoline which can
// be called through an ExportFuncPtr.

struct ExportArg {
  uint64_t lo;
  uint64_t hi;
};

using ExportFuncPtr = int32_t (*)(ExportArg*, TlsData*);

// FuncImportTls describes the region of wasm global memory allocated in the
// instance's thread-local storage for a function import. This is accessed
// directly from JIT code and mutated by Instance as exits become optimized and
// deoptimized.

struct FuncImportTls {
  // The code to call at an import site: a wasm callee, a thunk into C++, or a
  // thunk into JIT code.
  void* code;

  // The callee's TlsData pointer, which must be loaded to WasmTlsReg (along
  // with any pinned registers) before calling 'code'.
  TlsData* tls;

  // The callee function's realm.
  JS::Realm* realm;

  // If 'code' points into a JIT code thunk, the JitScript of the callee, for
  // bidirectional registration purposes.
  jit::JitScript* jitScript;

  // A GC pointer which keeps the callee alive and is used to recover import
  // values for lazy table initialization.
  GCPtrFunction fun;
  static_assert(sizeof(GCPtrFunction) == sizeof(void*), "for JIT access");
};

// TableTls describes the region of wasm global memory allocated in the
// instance's thread-local storage which is accessed directly from JIT code
// to bounds-check and index the table.

struct TableTls {
  // Length of the table in number of elements (not bytes).
  uint32_t length;

  // Pointer to the array of elements (which can have various representations).
  // For tables of anyref this is null.
  void* functionBase;
};

// Table element for TableKind::FuncRef which carries both the code pointer and
// a tls pointer (and thus anything reachable through the tls, including the
// instance).

struct FunctionTableElem {
  // The code to call when calling this element. The table ABI is the system
  // ABI with the additional ABI requirements that:
  //  - WasmTlsReg and any pinned registers have been loaded appropriately
  //  - if this is a heterogeneous table that requires a signature check,
  //    WasmTableCallSigReg holds the signature id.
  void* code;

  // The pointer to the callee's instance's TlsData. This must be loaded into
  // WasmTlsReg before calling 'code'.
  TlsData* tls;
};

// CalleeDesc describes how to compile one of the variety of asm.js/wasm calls.
// This is hoisted into WasmTypes.h for sharing between Ion and Baseline.

class CalleeDesc {
 public:
  enum Which {
    // Calls a function defined in the same module by its index.
    Func,

    // Calls the import identified by the offset of its FuncImportTls in
    // thread-local data.
    Import,

    // Calls a WebAssembly table (heterogeneous, index must be bounds
    // checked, callee instance depends on TableDesc).
    WasmTable,

    // Calls an asm.js table (homogeneous, masked index, same-instance).
    AsmJSTable,

    // Call a C++ function identified by SymbolicAddress.
    Builtin,

    // Like Builtin, but automatically passes Instance* as first argument.
    BuiltinInstanceMethod
  };

 private:
  // which_ shall be initialized in the static constructors
  MOZ_INIT_OUTSIDE_CTOR Which which_;
  union U {
    U() : funcIndex_(0) {}
    uint32_t funcIndex_;
    struct {
      uint32_t globalDataOffset_;
    } import;
    struct {
      uint32_t globalDataOffset_;
      uint32_t minLength_;
      FuncTypeIdDesc funcTypeId_;
    } table;
    SymbolicAddress builtin_;
  } u;

 public:
  CalleeDesc() = default;
  static CalleeDesc function(uint32_t funcIndex) {
    CalleeDesc c;
    c.which_ = Func;
    c.u.funcIndex_ = funcIndex;
    return c;
  }
  static CalleeDesc import(uint32_t globalDataOffset) {
    CalleeDesc c;
    c.which_ = Import;
    c.u.import.globalDataOffset_ = globalDataOffset;
    return c;
  }
  static CalleeDesc wasmTable(const TableDesc& desc,
                              FuncTypeIdDesc funcTypeId) {
    CalleeDesc c;
    c.which_ = WasmTable;
    c.u.table.globalDataOffset_ = desc.globalDataOffset;
    c.u.table.minLength_ = desc.limits.initial;
    c.u.table.funcTypeId_ = funcTypeId;
    return c;
  }
  static CalleeDesc asmJSTable(const TableDesc& desc) {
    CalleeDesc c;
    c.which_ = AsmJSTable;
    c.u.table.globalDataOffset_ = desc.globalDataOffset;
    return c;
  }
  static CalleeDesc builtin(SymbolicAddress callee) {
    CalleeDesc c;
    c.which_ = Builtin;
    c.u.builtin_ = callee;
    return c;
  }
  static CalleeDesc builtinInstanceMethod(SymbolicAddress callee) {
    CalleeDesc c;
    c.which_ = BuiltinInstanceMethod;
    c.u.builtin_ = callee;
    return c;
  }
  Which which() const { return which_; }
  uint32_t funcIndex() const {
    MOZ_ASSERT(which_ == Func);
    return u.funcIndex_;
  }
  uint32_t importGlobalDataOffset() const {
    MOZ_ASSERT(which_ == Import);
    return u.import.globalDataOffset_;
  }
  bool isTable() const { return which_ == WasmTable || which_ == AsmJSTable; }
  uint32_t tableLengthGlobalDataOffset() const {
    MOZ_ASSERT(isTable());
    return u.table.globalDataOffset_ + offsetof(TableTls, length);
  }
  uint32_t tableFunctionBaseGlobalDataOffset() const {
    MOZ_ASSERT(isTable());
    return u.table.globalDataOffset_ + offsetof(TableTls, functionBase);
  }
  FuncTypeIdDesc wasmTableSigId() const {
    MOZ_ASSERT(which_ == WasmTable);
    return u.table.funcTypeId_;
  }
  uint32_t wasmTableMinLength() const {
    MOZ_ASSERT(which_ == WasmTable);
    return u.table.minLength_;
  }
  SymbolicAddress builtin() const {
    MOZ_ASSERT(which_ == Builtin || which_ == BuiltinInstanceMethod);
    return u.builtin_;
  }
};

// Because ARM has a fixed-width instruction encoding, ARM can only express a
// limited subset of immediates (in a single instruction).

extern bool IsValidARMImmediate(uint32_t i);

extern uint32_t RoundUpToNextValidARMImmediate(uint32_t i);

// The WebAssembly spec hard-codes the virtual page size to be 64KiB and
// requires the size of linear memory to always be a multiple of 64KiB.

static const unsigned PageSize = 64 * 1024;

// Bounds checks always compare the base of the memory access with the bounds
// check limit. If the memory access is unaligned, this means that, even if the
// bounds check succeeds, a few bytes of the access can extend past the end of
// memory. To guard against this, extra space is included in the guard region to
// catch the overflow. MaxMemoryAccessSize is a conservative approximation of
// the maximum guard space needed to catch all unaligned overflows.

static const unsigned MaxMemoryAccessSize = LitVal::sizeofLargestValue();

#ifdef WASM_SUPPORTS_HUGE_MEMORY

// On WASM_SUPPORTS_HUGE_MEMORY platforms, every asm.js or WebAssembly memory
// unconditionally allocates a huge region of virtual memory of size
// wasm::HugeMappedSize. This allows all memory resizing to work without
// reallocation and provides enough guard space for all offsets to be folded
// into memory accesses.

static const uint64_t HugeIndexRange = uint64_t(UINT32_MAX) + 1;
static const uint64_t HugeOffsetGuardLimit = uint64_t(INT32_MAX) + 1;
static const uint64_t HugeUnalignedGuardPage = PageSize;
static const uint64_t HugeMappedSize =
    HugeIndexRange + HugeOffsetGuardLimit + HugeUnalignedGuardPage;

static_assert(MaxMemoryAccessSize <= HugeUnalignedGuardPage,
              "rounded up to static page size");
static_assert(HugeOffsetGuardLimit < UINT32_MAX,
              "checking for overflow against OffsetGuardLimit is enough.");

#endif

// On !WASM_SUPPORTS_HUGE_MEMORY platforms:
//  - To avoid OOM in ArrayBuffer::prepareForAsmJS, asm.js continues to use the
//    original ArrayBuffer allocation which has no guard region at all.
//  - For WebAssembly memories, an additional GuardSize is mapped after the
//    accessible region of the memory to catch folded (base+offset) accesses
//    where `offset < OffsetGuardLimit` as well as the overflow from unaligned
//    accesses, as described above for MaxMemoryAccessSize.

static const size_t OffsetGuardLimit = PageSize - MaxMemoryAccessSize;
static const size_t GuardSize = PageSize;

static_assert(MaxMemoryAccessSize < GuardSize,
              "Guard page handles partial out-of-bounds");
static_assert(OffsetGuardLimit < UINT32_MAX,
              "checking for overflow against OffsetGuardLimit is enough.");

static constexpr size_t GetOffsetGuardLimit(bool hugeMemory) {
#ifdef WASM_SUPPORTS_HUGE_MEMORY
  return hugeMemory ? HugeOffsetGuardLimit : OffsetGuardLimit;
#else
  return OffsetGuardLimit;
#endif
}

#ifdef WASM_SUPPORTS_HUGE_MEMORY
static const size_t MaxOffsetGuardLimit = HugeOffsetGuardLimit;
static const size_t MinOffsetGuardLimit = OffsetGuardLimit;
#else
static const size_t MaxOffsetGuardLimit = OffsetGuardLimit;
static const size_t MinOffsetGuardLimit = OffsetGuardLimit;
#endif

// Return whether the given immediate satisfies the constraints of the platform
// (viz. that, on ARM, IsValidARMImmediate).

extern bool IsValidBoundsCheckImmediate(uint32_t i);

// For a given WebAssembly/asm.js max size, return the number of bytes to
// map which will necessarily be a multiple of the system page size and greater
// than maxSize. For a returned mappedSize:
//   boundsCheckLimit = mappedSize - GuardSize
//   IsValidBoundsCheckImmediate(boundsCheckLimit)

extern size_t ComputeMappedSize(uint32_t maxSize);

// The following thresholds were derived from a microbenchmark. If we begin to
// ship this optimization for more platforms, we will need to extend this list.

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_ARM64)
static const uint32_t MaxInlineMemoryCopyLength = 64;
static const uint32_t MaxInlineMemoryFillLength = 64;
#elif defined(JS_CODEGEN_X86)
static const uint32_t MaxInlineMemoryCopyLength = 32;
static const uint32_t MaxInlineMemoryFillLength = 32;
#else
static const uint32_t MaxInlineMemoryCopyLength = 0;
static const uint32_t MaxInlineMemoryFillLength = 0;
#endif

static_assert(MaxInlineMemoryCopyLength < MinOffsetGuardLimit, "precondition");
static_assert(MaxInlineMemoryFillLength < MinOffsetGuardLimit, "precondition");

// wasm::Frame represents the bytes pushed by the call instruction and the
// fixed prologue generated by wasm::GenerateCallablePrologue.
//
// Across all architectures it is assumed that, before the call instruction, the
// stack pointer is WasmStackAlignment-aligned. Thus after the prologue, and
// before the function has made its stack reservation, the stack alignment is
// sizeof(Frame) % WasmStackAlignment.
//
// During MacroAssembler code generation, the bytes pushed after the wasm::Frame
// are counted by masm.framePushed. Thus, the stack alignment at any point in
// time is (sizeof(wasm::Frame) + masm.framePushed) % WasmStackAlignment.

struct Frame {
  // The caller's Frame*. See GenerateCallableEpilogue for why this must be
  // the first field of wasm::Frame (in a downward-growing stack).
  Frame* callerFP;

  // The saved value of WasmTlsReg on entry to the function. This is
  // effectively the callee's instance.
  TlsData* tls;

#if defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_ARM64)
  // Double word aligned frame ensures:
  // - correct alignment for wasm locals on architectures that require the
  //   stack alignment to be more than word size.
  // - correct stack alignment on architectures that require the SP alignment
  //   to be more than word size.
  uintptr_t padding_;
#endif

  // The return address pushed by the call (in the case of ARM/MIPS the return
  // address is pushed by the first instruction of the prologue).
  void* returnAddress;

  // Helper functions:

  Instance* instance() const { return tls->instance; }
};

#if defined(JS_CODEGEN_ARM64)
static_assert(sizeof(Frame) % 16 == 0, "frame size");
#endif

// A DebugFrame is a Frame with additional fields that are added after the
// normal function prologue by the baseline compiler. If a Module is compiled
// with debugging enabled, then all its code creates DebugFrames on the stack
// instead of just Frames. These extra fields are used by the Debugger API.

class DebugFrame {
  // The register results field.  Initialized only during the baseline
  // compiler's return sequence to allow the debugger to inspect and
  // modify the return values of a frame being debugged.
  union SpilledRegisterResult {
   private:
    int32_t i32_;
    int64_t i64_;
    intptr_t ref_;
    AnyRef anyref_;
    float f32_;
    double f64_;
#ifdef ENABLE_WASM_SIMD
    V128 v128_;
#endif
#ifdef DEBUG
    // Should we add a new value representation, this will remind us to update
    // SpilledRegisterResult.
    static inline void assertAllValueTypesHandled(ValType type) {
      switch (type.kind()) {
        case ValType::I32:
        case ValType::I64:
        case ValType::F32:
        case ValType::F64:
        case ValType::V128:
          return;
        case ValType::Ref:
          switch (type.refTypeKind()) {
            case RefType::Any:
            case RefType::Func:
            case RefType::TypeIndex:
              return;
          }
      }
    }
#endif
  };
  SpilledRegisterResult registerResults_[MaxRegisterResults];

  // The returnValue() method returns a HandleValue pointing to this field.
  js::Value cachedReturnJSValue_;

  // If the function returns multiple results, this field is initialized
  // to a pointer to the stack results.
  void* stackResultsPointer_;

  // The function index of this frame. Technically, this could be derived
  // given a PC into this frame (which could lookup the CodeRange which has
  // the function index), but this isn't always readily available.
  uint32_t funcIndex_;

  // Flags whose meaning are described below.
  union Flags {
    struct {
      uint32_t observing : 1;
      uint32_t isDebuggee : 1;
      uint32_t prevUpToDate : 1;
      uint32_t hasCachedSavedFrame : 1;
      uint32_t hasCachedReturnJSValue : 1;
      uint32_t hasSpilledRefRegisterResult : MaxRegisterResults;
    };
    uint32_t allFlags;
  } flags_;

  // Avoid -Wunused-private-field warnings.
 protected:
#if defined(JS_CODEGEN_MIPS32)
  // See alignmentStaticAsserts().  For MIPS32, sizeof(Frame) is only
  // 4-byte aligned, so we add another word to get up to 8-byte
  // alignment.
  uint32_t padding_;
#endif

 private:
  // The Frame goes at the end since the stack grows down.
  Frame frame_;

 public:
  static DebugFrame* from(Frame* fp);
  Frame& frame() { return frame_; }
  uint32_t funcIndex() const { return funcIndex_; }
  Instance* instance() const { return frame_.instance(); }
  GlobalObject* global() const;
  bool hasGlobal(const GlobalObject* global) const;
  JSObject* environmentChain() const;
  bool getLocal(uint32_t localIndex, MutableHandleValue vp);

  // The return value must be written from the unboxed representation in the
  // results union into cachedReturnJSValue_ by updateReturnJSValue() before
  // returnValue() can return a Handle to it.

  bool hasCachedReturnJSValue() const { return flags_.hasCachedReturnJSValue; }
  MOZ_MUST_USE bool updateReturnJSValue(JSContext* cx);
  HandleValue returnValue() const;
  void clearReturnJSValue();

  // Once the debugger observes a frame, it must be notified via
  // onLeaveFrame() before the frame is popped. Calling observe() ensures the
  // leave frame traps are enabled. Both methods are idempotent so the caller
  // doesn't have to worry about calling them more than once.

  void observe(JSContext* cx);
  void leave(JSContext* cx);

  // The 'isDebugge' bit is initialized to false and set by the WebAssembly
  // runtime right before a frame is exposed to the debugger, as required by
  // the Debugger API. The bit is then used for Debugger-internal purposes
  // afterwards.

  bool isDebuggee() const { return flags_.isDebuggee; }
  void setIsDebuggee() { flags_.isDebuggee = true; }
  void unsetIsDebuggee() { flags_.isDebuggee = false; }

  // These are opaque boolean flags used by the debugger to implement
  // AbstractFramePtr. They are initialized to false and not otherwise read or
  // written by wasm code or runtime.

  bool prevUpToDate() const { return flags_.prevUpToDate; }
  void setPrevUpToDate() { flags_.prevUpToDate = true; }
  void unsetPrevUpToDate() { flags_.prevUpToDate = false; }

  bool hasCachedSavedFrame() const { return flags_.hasCachedSavedFrame; }
  void setHasCachedSavedFrame() { flags_.hasCachedSavedFrame = true; }
  void clearHasCachedSavedFrame() { flags_.hasCachedSavedFrame = false; }

  bool hasSpilledRegisterRefResult(size_t n) const {
    uint32_t mask = hasSpilledRegisterRefResultBitMask(n);
    return (flags_.allFlags & mask) != 0;
  }

  // DebugFrame is accessed directly by JIT code.

  static constexpr size_t offsetOfRegisterResults() {
    return offsetof(DebugFrame, registerResults_);
  }
  static constexpr size_t offsetOfRegisterResult(size_t n) {
    MOZ_ASSERT(n < MaxRegisterResults);
    return offsetOfRegisterResults() + n * sizeof(SpilledRegisterResult);
  }
  static constexpr size_t offsetOfCachedReturnJSValue() {
    return offsetof(DebugFrame, cachedReturnJSValue_);
  }
  static constexpr size_t offsetOfStackResultsPointer() {
    return offsetof(DebugFrame, stackResultsPointer_);
  }
  static constexpr size_t offsetOfFlags() {
    return offsetof(DebugFrame, flags_);
  }
  static constexpr uint32_t hasSpilledRegisterRefResultBitMask(size_t n) {
    MOZ_ASSERT(n < MaxRegisterResults);
    union Flags flags = {.allFlags = 0};
    flags.hasSpilledRefRegisterResult = 1 << n;
    MOZ_ASSERT(flags.allFlags != 0);
    return flags.allFlags;
  }
  static constexpr size_t offsetOfFuncIndex() {
    return offsetof(DebugFrame, funcIndex_);
  }
  static constexpr size_t offsetOfFrame() {
    return offsetof(DebugFrame, frame_);
  }

  // DebugFrames are aligned to 8-byte aligned, allowing them to be placed in
  // an AbstractFramePtr.

  static const unsigned Alignment = 8;
  static void alignmentStaticAsserts();
};

// Verbose logging support.

extern void Log(JSContext* cx, const char* fmt, ...) MOZ_FORMAT_PRINTF(2, 3);

// Codegen debug support.

enum class DebugChannel {
  Function,
  Import,
};

#ifdef WASM_CODEGEN_DEBUG
bool IsCodegenDebugEnabled(DebugChannel channel);
#endif

void DebugCodegen(DebugChannel channel, const char* fmt, ...)
    MOZ_FORMAT_PRINTF(2, 3);

using PrintCallback = void (*)(const char*);

}  // namespace wasm
}  // namespace js

#endif  // wasm_types_h
