/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_CacheIR_h
#define jit_CacheIR_h

#include "mozilla/Maybe.h"

#include "jsmath.h"

#include "NamespaceImports.h"

#include "gc/Rooting.h"
#include "jit/CacheIROpsGenerated.h"
#include "jit/CompactBuffer.h"
#include "jit/ICState.h"
#include "jit/MacroAssembler.h"
#include "jit/Simulator.h"
#include "vm/Iteration.h"
#include "vm/Shape.h"

namespace js {
namespace jit {

enum class BaselineCacheIRStubKind;

// [SMDOC] CacheIR
//
// CacheIR is an (extremely simple) linear IR language for inline caches.
// From this IR, we can generate machine code for Baseline or Ion IC stubs.
//
// IRWriter
// --------
// CacheIR bytecode is written using IRWriter. This class also records some
// metadata that's used by the Baseline and Ion code generators to generate
// (efficient) machine code.
//
// Sharing Baseline stub code
// --------------------------
// Baseline stores data (like Shape* and fixed slot offsets) inside the ICStub
// structure, instead of embedding them directly in the JitCode. This makes
// Baseline IC code slightly slower, but allows us to share IC code between
// caches. CacheIR makes it easy to share code between stubs: stubs that have
// the same CacheIR (and CacheKind), will have the same Baseline stub code.
//
// Baseline stubs that share JitCode also share a CacheIRStubInfo structure.
// This class stores the CacheIR and the location of GC things stored in the
// stub, for the GC.
//
// JitZone has a CacheIRStubInfo* -> JitCode* weak map that's used to share both
// the IR and JitCode between Baseline CacheIR stubs. This HashMap owns the
// stubInfo (it uses UniquePtr), so once there are no references left to the
// shared stub code, we can also free the CacheIRStubInfo.
//
// Ion stubs
// ---------
// Unlike Baseline stubs, Ion stubs do not share stub code, and data stored in
// the IonICStub is baked into JIT code. This is one of the reasons Ion stubs
// are faster than Baseline stubs. Also note that Ion ICs contain more state
// (see IonGetPropertyIC for example) and use dynamic input/output registers,
// so sharing stub code for Ion would be much more difficult.

// An OperandId represents either a cache input or a value returned by a
// CacheIR instruction. Most code should use the ValOperandId and ObjOperandId
// classes below. The ObjOperandId class represents an operand that's known to
// be an object, just as StringOperandId represents a known string, etc.
class OperandId {
 protected:
  static const uint16_t InvalidId = UINT16_MAX;
  uint16_t id_;

  OperandId() : id_(InvalidId) {}
  explicit OperandId(uint16_t id) : id_(id) {}

 public:
  uint16_t id() const { return id_; }
  bool valid() const { return id_ != InvalidId; }
};

class ValOperandId : public OperandId {
 public:
  ValOperandId() = default;
  explicit ValOperandId(uint16_t id) : OperandId(id) {}
};

class ValueTagOperandId : public OperandId {
 public:
  ValueTagOperandId() = default;
  explicit ValueTagOperandId(uint16_t id) : OperandId(id) {}
};

class ObjOperandId : public OperandId {
 public:
  ObjOperandId() = default;
  explicit ObjOperandId(uint16_t id) : OperandId(id) {}

  bool operator==(const ObjOperandId& other) const { return id_ == other.id_; }
  bool operator!=(const ObjOperandId& other) const { return id_ != other.id_; }
};

class NumberOperandId : public ValOperandId {
 public:
  NumberOperandId() = default;
  explicit NumberOperandId(uint16_t id) : ValOperandId(id) {}
};

class StringOperandId : public OperandId {
 public:
  StringOperandId() = default;
  explicit StringOperandId(uint16_t id) : OperandId(id) {}
};

class SymbolOperandId : public OperandId {
 public:
  SymbolOperandId() = default;
  explicit SymbolOperandId(uint16_t id) : OperandId(id) {}
};

class BigIntOperandId : public OperandId {
 public:
  BigIntOperandId() = default;
  explicit BigIntOperandId(uint16_t id) : OperandId(id) {}
};

class Int32OperandId : public OperandId {
 public:
  Int32OperandId() = default;
  explicit Int32OperandId(uint16_t id) : OperandId(id) {}
};

class TypedOperandId : public OperandId {
  JSValueType type_;

 public:
  MOZ_IMPLICIT TypedOperandId(ObjOperandId id)
      : OperandId(id.id()), type_(JSVAL_TYPE_OBJECT) {}
  MOZ_IMPLICIT TypedOperandId(StringOperandId id)
      : OperandId(id.id()), type_(JSVAL_TYPE_STRING) {}
  MOZ_IMPLICIT TypedOperandId(SymbolOperandId id)
      : OperandId(id.id()), type_(JSVAL_TYPE_SYMBOL) {}
  MOZ_IMPLICIT TypedOperandId(BigIntOperandId id)
      : OperandId(id.id()), type_(JSVAL_TYPE_BIGINT) {}
  MOZ_IMPLICIT TypedOperandId(Int32OperandId id)
      : OperandId(id.id()), type_(JSVAL_TYPE_INT32) {}
  MOZ_IMPLICIT TypedOperandId(ValueTagOperandId val)
      : OperandId(val.id()), type_(JSVAL_TYPE_UNKNOWN) {}
  TypedOperandId(ValOperandId val, JSValueType type)
      : OperandId(val.id()), type_(type) {}

  JSValueType type() const { return type_; }
};

#define CACHE_IR_KINDS(_) \
  _(GetProp)              \
  _(GetElem)              \
  _(GetName)              \
  _(GetPropSuper)         \
  _(GetElemSuper)         \
  _(GetIntrinsic)         \
  _(SetProp)              \
  _(SetElem)              \
  _(BindName)             \
  _(In)                   \
  _(HasOwn)               \
  _(TypeOf)               \
  _(InstanceOf)           \
  _(GetIterator)          \
  _(Compare)              \
  _(ToBool)               \
  _(Call)                 \
  _(UnaryArith)           \
  _(BinaryArith)          \
  _(NewObject)

enum class CacheKind : uint8_t {
#define DEFINE_KIND(kind) kind,
  CACHE_IR_KINDS(DEFINE_KIND)
#undef DEFINE_KIND
};

extern const char* const CacheKindNames[];

#ifdef DEBUG
extern size_t NumInputsForCacheKind(CacheKind kind);
#endif

enum class CacheOp {
#define DEFINE_OP(op, ...) op,
  CACHE_IR_OPS(DEFINE_OP)
#undef DEFINE_OP
};

extern const char* const CacheIROpNames[];
extern const uint32_t CacheIROpArgLengths[];

class StubField {
 public:
  enum class Type : uint8_t {
    // These fields take up a single word.
    RawWord,
    Shape,
    ObjectGroup,
    JSObject,
    Symbol,
    String,
    Id,

    // These fields take up 64 bits on all platforms.
    RawInt64,
    First64BitType = RawInt64,
    DOMExpandoGeneration,
    Value,

    Limit
  };

  static bool sizeIsWord(Type type) {
    MOZ_ASSERT(type != Type::Limit);
    return type < Type::First64BitType;
  }

  static bool sizeIsInt64(Type type) {
    MOZ_ASSERT(type != Type::Limit);
    return type >= Type::First64BitType;
  }

  static size_t sizeInBytes(Type type) {
    if (sizeIsWord(type)) {
      return sizeof(uintptr_t);
    }
    MOZ_ASSERT(sizeIsInt64(type));
    return sizeof(int64_t);
  }

 private:
  uint64_t data_;
  Type type_;

 public:
  StubField(uint64_t data, Type type) : data_(data), type_(type) {
    MOZ_ASSERT_IF(sizeIsWord(), data <= UINTPTR_MAX);
  }

  Type type() const { return type_; }

  bool sizeIsWord() const { return sizeIsWord(type_); }
  bool sizeIsInt64() const { return sizeIsInt64(type_); }

  uintptr_t asWord() const {
    MOZ_ASSERT(sizeIsWord());
    return uintptr_t(data_);
  }
  uint64_t asInt64() const {
    MOZ_ASSERT(sizeIsInt64());
    return data_;
  }
} JS_HAZ_GC_POINTER;

// This class is used to wrap up information about a call to make it
// easier to convey from one function to another. (In particular,
// CacheIRWriter encodes the CallFlags in CacheIR, and CacheIRReader
// decodes them and uses them for compilation.)
class CallFlags {
 public:
  enum ArgFormat : uint8_t {
    Standard,
    Spread,
    FunCall,
    FunApplyArgs,
    FunApplyArray,
    LastArgFormat = FunApplyArray
  };

  CallFlags(bool isConstructing, bool isSpread, bool isSameRealm = false)
      : argFormat_(isSpread ? Spread : Standard),
        isConstructing_(isConstructing),
        isSameRealm_(isSameRealm) {}
  explicit CallFlags(ArgFormat format)
      : argFormat_(format), isConstructing_(false), isSameRealm_(false) {}

  ArgFormat getArgFormat() const { return argFormat_; }
  bool isConstructing() const {
    MOZ_ASSERT_IF(isConstructing_,
                  argFormat_ == Standard || argFormat_ == Spread);
    return isConstructing_;
  }
  bool isSameRealm() const { return isSameRealm_; }

  uint8_t toByte() const {
    // See CacheIRReader::callFlags()
    uint8_t value = getArgFormat();
    if (isConstructing()) {
      value |= CallFlags::IsConstructing;
    }
    if (isSameRealm()) {
      value |= CallFlags::IsSameRealm;
    }
    return value;
  }

 private:
  ArgFormat argFormat_;
  bool isConstructing_;
  bool isSameRealm_;

  // Used for encoding/decoding
  static const uint8_t ArgFormatBits = 4;
  static const uint8_t ArgFormatMask = (1 << ArgFormatBits) - 1;
  static_assert(LastArgFormat <= ArgFormatMask, "Not enough arg format bits");
  static const uint8_t IsConstructing = 1 << 5;
  static const uint8_t IsSameRealm = 1 << 6;

  friend class CacheIRReader;
  friend class CacheIRWriter;
};

enum class AttachDecision {
  // We cannot attach a stub.
  NoAction,

  // We can attach a stub.
  Attach,

  // We cannot currently attach a stub, but we expect to be able to do so in the
  // future. In this case, we do not call trackNotAttached().
  TemporarilyUnoptimizable,

  // We want to attach a stub, but the result of the operation is
  // needed to generate that stub. For example, AddSlot needs to know
  // the resulting shape. Note: the attached stub will inspect the
  // inputs to the operation, so most input checks should be done
  // before the actual operation, with only minimal checks remaining
  // for the deferred portion. This prevents arbitrary scripted code
  // run by the operation from interfering with the conditions being
  // checked.
  Deferred
};

// If the input expression evaluates to an AttachDecision other than NoAction,
// return that AttachDecision. If it is NoAction, do nothing.
#define TRY_ATTACH(expr)                                    \
  do {                                                      \
    AttachDecision tryAttachTempResult_ = expr;             \
    if (tryAttachTempResult_ != AttachDecision::NoAction) { \
      return tryAttachTempResult_;                          \
    }                                                       \
  } while (0)

// Set of arguments supported by GetIndexOfArgument.
// Support for Arg2 and up can be added easily, but is currently unneeded.
enum class ArgumentKind : uint8_t { Callee, This, NewTarget, Arg0, Arg1 };

// This function calculates the index of an argument based on the call flags.
// addArgc is an out-parameter, indicating whether the value of argc should
// be added to the return value to find the actual index.
inline int32_t GetIndexOfArgument(ArgumentKind kind, CallFlags flags,
                                  bool* addArgc) {
  // *** STACK LAYOUT (bottom to top) ***        ******** INDEX ********
  //   Callee                                <-- argc+1 + isConstructing
  //   ThisValue                             <-- argc   + isConstructing
  //   Args: | Arg0 |        |  ArgArray  |  <-- argc-1 + isConstructing
  //         | Arg1 | --or-- |            |  <-- argc-2 + isConstructing
  //         | ...  |        | (if spread |  <-- ...
  //         | ArgN |        |  call)     |  <-- 0      + isConstructing
  //   NewTarget (only if constructing)      <-- 0 (if it exists)
  //
  // If this is a spread call, then argc is always 1, and we can calculate the
  // index directly. If this is not a spread call, then the index of any
  // argument other than NewTarget depends on argc.

  // First we determine whether the caller needs to add argc.
  switch (flags.getArgFormat()) {
    case CallFlags::Standard:
      *addArgc = true;
      break;
    case CallFlags::Spread:
      // Spread calls do not have Arg1 or higher.
      MOZ_ASSERT(kind != ArgumentKind::Arg1);
      *addArgc = false;
      break;
    case CallFlags::FunCall:
    case CallFlags::FunApplyArgs:
    case CallFlags::FunApplyArray:
      MOZ_CRASH("Currently unreachable");
      break;
  }

  // Second, we determine the offset relative to argc.
  bool hasArgumentArray = !*addArgc;
  switch (kind) {
    case ArgumentKind::Callee:
      return flags.isConstructing() + hasArgumentArray + 1;
    case ArgumentKind::This:
      return flags.isConstructing() + hasArgumentArray;
    case ArgumentKind::Arg0:
      return flags.isConstructing() + hasArgumentArray - 1;
    case ArgumentKind::Arg1:
      return flags.isConstructing() + hasArgumentArray - 2;
    case ArgumentKind::NewTarget:
      MOZ_ASSERT(flags.isConstructing());
      *addArgc = false;
      return 0;
    default:
      MOZ_CRASH("Invalid argument kind");
  }
}

// We use this enum as GuardClass operand, instead of storing Class* pointers
// in the IR, to keep the IR compact and the same size on all platforms.
enum class GuardClassKind : uint8_t {
  Array,
  MappedArguments,
  UnmappedArguments,
  WindowProxy,
  JSFunction,
};

// Some ops refer to shapes that might be in other zones. Instead of putting
// cross-zone pointers in the caches themselves (which would complicate tracing
// enormously), these ops instead contain wrappers for objects in the target
// zone, which refer to the actual shape via a reserved slot.
JSObject* NewWrapperWithObjectShape(JSContext* cx, HandleNativeObject obj);

// Enum for stubs handling a combination of typed arrays and typed objects.
enum class TypedThingLayout : uint8_t {
  TypedArray,
  OutlineTypedObject,
  InlineTypedObject
};

void LoadShapeWrapperContents(MacroAssembler& masm, Register obj, Register dst,
                              Label* failure);

enum class MetaTwoByteKind : uint8_t {
  NativeTemplateObject,
  ScriptedTemplateObject,
};

#ifdef JS_SIMULATOR
bool CallAnyNative(JSContext* cx, unsigned argc, Value* vp);
#endif

// Class to record CacheIR + some additional metadata for code generation.
class MOZ_RAII CacheIRWriter : public JS::CustomAutoRooter {
  JSContext* cx_;
  CompactBufferWriter buffer_;

  uint32_t nextOperandId_;
  uint32_t nextInstructionId_;
  uint32_t numInputOperands_;

  // The data (shapes, slot offsets, etc.) that will be stored in the ICStub.
  Vector<StubField, 8, SystemAllocPolicy> stubFields_;
  size_t stubDataSize_;

  // For each operand id, record which instruction accessed it last. This
  // information greatly improves register allocation.
  Vector<uint32_t, 8, SystemAllocPolicy> operandLastUsed_;

  // OperandId and stub offsets are stored in a single byte, so make sure
  // this doesn't overflow. We use a very conservative limit for now.
  static const size_t MaxOperandIds = 20;
  static const size_t MaxStubDataSizeInBytes = 20 * sizeof(uintptr_t);
  bool tooLarge_;

  // Basic caching to avoid quadatic lookup behaviour in readStubFieldForIon.
  mutable uint32_t lastOffset_;
  mutable uint32_t lastIndex_;

#ifdef DEBUG
  // Information for assertLengthMatches.
  mozilla::Maybe<CacheOp> currentOp_;
  size_t currentOpArgsStart_ = 0;
#endif

  void assertSameCompartment(JSObject*);

  void writeOp(CacheOp op) {
    MOZ_ASSERT(uint32_t(op) <= UINT8_MAX);
    buffer_.writeByte(uint32_t(op));
    nextInstructionId_++;
#ifdef DEBUG
    MOZ_ASSERT(currentOp_.isNothing(), "Missing call to assertLengthMatches?");
    currentOp_.emplace(op);
    currentOpArgsStart_ = buffer_.length();
#endif
  }

  void assertLengthMatches() {
#ifdef DEBUG
    // After writing arguments, assert the length matches CacheIROpArgLengths.
    size_t expectedLen = CacheIROpArgLengths[size_t(*currentOp_)];
    MOZ_ASSERT_IF(!failed(),
                  buffer_.length() - currentOpArgsStart_ == expectedLen);
    currentOp_.reset();
#endif
  }

  void writeOperandId(OperandId opId) {
    if (opId.id() < MaxOperandIds) {
      static_assert(MaxOperandIds <= UINT8_MAX,
                    "operand id must fit in a single byte");
      buffer_.writeByte(opId.id());
    } else {
      tooLarge_ = true;
      return;
    }
    if (opId.id() >= operandLastUsed_.length()) {
      buffer_.propagateOOM(operandLastUsed_.resize(opId.id() + 1));
      if (buffer_.oom()) {
        return;
      }
    }
    MOZ_ASSERT(nextInstructionId_ > 0);
    operandLastUsed_[opId.id()] = nextInstructionId_ - 1;
  }

  void writeCallFlagsImm(CallFlags flags) { buffer_.writeByte(flags.toByte()); }

  uint8_t addStubField(uint64_t value, StubField::Type fieldType) {
    uint8_t offset = 0;
    size_t newStubDataSize = stubDataSize_ + StubField::sizeInBytes(fieldType);
    if (newStubDataSize < MaxStubDataSizeInBytes) {
      buffer_.propagateOOM(stubFields_.append(StubField(value, fieldType)));
      MOZ_ASSERT((stubDataSize_ % sizeof(uintptr_t)) == 0);
      offset = stubDataSize_ / sizeof(uintptr_t);
      buffer_.writeByte(offset);
      stubDataSize_ = newStubDataSize;
    } else {
      tooLarge_ = true;
    }
    return offset;
  }

  void writeShapeField(Shape* shape) {
    MOZ_ASSERT(shape);
    addStubField(uintptr_t(shape), StubField::Type::Shape);
  }
  void writeGroupField(ObjectGroup* group) {
    MOZ_ASSERT(group);
    addStubField(uintptr_t(group), StubField::Type::ObjectGroup);
  }
  void writeObjectField(JSObject* obj) {
    assertSameCompartment(obj);
    addStubField(uintptr_t(obj), StubField::Type::JSObject);
  }
  void writeStringField(JSString* str) {
    MOZ_ASSERT(str);
    addStubField(uintptr_t(str), StubField::Type::String);
  }
  void writeSymbolField(JS::Symbol* sym) {
    MOZ_ASSERT(sym);
    addStubField(uintptr_t(sym), StubField::Type::Symbol);
  }
  void writeRawWordField(uintptr_t word) {
    addStubField(word, StubField::Type::RawWord);
  }
  void writeRawPointerField(const void* ptr) {
    addStubField(uintptr_t(ptr), StubField::Type::RawWord);
  }
  void writeIdField(jsid id) {
    addStubField(uintptr_t(JSID_BITS(id)), StubField::Type::Id);
  }
  void writeValueField(const Value& val) {
    addStubField(val.asRawBits(), StubField::Type::Value);
  }
  void writeDOMExpandoGenerationField(uint64_t generation) {
    addStubField(generation, StubField::Type::DOMExpandoGeneration);
  }

  void writeJSOpImm(JSOp op) {
    static_assert(sizeof(JSOp) == sizeof(uint8_t), "JSOp must fit in a byte");
    buffer_.writeByte(uint8_t(op));
  }
  void writeGuardClassKindImm(GuardClassKind kind) {
    static_assert(sizeof(GuardClassKind) == sizeof(uint8_t),
                  "GuardClassKind must fit in a byte");
    buffer_.writeByte(uint8_t(kind));
  }
  void writeValueTypeImm(ValueType type) {
    static_assert(sizeof(ValueType) == sizeof(uint8_t),
                  "ValueType must fit in uint8_t");
    buffer_.writeByte(uint8_t(type));
  }
  void writeJSWhyMagicImm(JSWhyMagic whyMagic) {
    static_assert(JS_WHY_MAGIC_COUNT <= UINT8_MAX,
                  "JSWhyMagic must fit in uint8_t");
    buffer_.writeByte(uint8_t(whyMagic));
  }
  void writeTypedThingLayoutImm(TypedThingLayout layout) {
    static_assert(sizeof(TypedThingLayout) == sizeof(uint8_t),
                  "TypedThingLayout must fit in a byte");
    buffer_.writeByte(uint8_t(layout));
  }
  void writeReferenceTypeImm(ReferenceType type) {
    MOZ_ASSERT(size_t(type) <= UINT8_MAX);
    buffer_.writeByte(uint8_t(type));
  }
  void writeScalarTypeImm(Scalar::Type type) {
    MOZ_ASSERT(size_t(type) <= UINT8_MAX);
    buffer_.writeByte(uint8_t(type));
  }
  void writeMetaTwoByteKindImm(MetaTwoByteKind kind) {
    static_assert(sizeof(MetaTwoByteKind) == sizeof(uint8_t),
                  "MetaTwoByteKind must fit in a byte");
    buffer_.writeByte(uint8_t(kind));
  }
  void writeUnaryMathFunctionImm(UnaryMathFunction fun) {
    static_assert(sizeof(UnaryMathFunction) == sizeof(uint8_t),
                  "UnaryMathFunction must fit in a byte");
    buffer_.writeByte(uint8_t(fun));
  }
  void writeBoolImm(bool b) { buffer_.writeByte(uint32_t(b)); }

  void writeByteImm(uint32_t b) {
    MOZ_ASSERT(b <= UINT8_MAX);
    buffer_.writeByte(b);
  }

  void writeInt32Imm(int32_t i32) { buffer_.writeFixedUint32_t(i32); }
  void writeUInt32Imm(uint32_t u32) { buffer_.writeFixedUint32_t(u32); }
  void writePointer(const void* ptr) { buffer_.writeRawPointer(ptr); }

  void writeJSNativeImm(JSNative native) {
    writePointer(JS_FUNC_TO_DATA_PTR(void*, native));
  }
  void writeStaticStringImm(const char* str) { writePointer(str); }

  uint32_t newOperandId() { return nextOperandId_++; }

  CacheIRWriter(const CacheIRWriter&) = delete;
  CacheIRWriter& operator=(const CacheIRWriter&) = delete;

 public:
  explicit CacheIRWriter(JSContext* cx)
      : CustomAutoRooter(cx),
        cx_(cx),
        nextOperandId_(0),
        nextInstructionId_(0),
        numInputOperands_(0),
        stubDataSize_(0),
        tooLarge_(false),
        lastOffset_(0),
        lastIndex_(0) {}

  bool failed() const { return buffer_.oom() || tooLarge_; }

  uint32_t numInputOperands() const { return numInputOperands_; }
  uint32_t numOperandIds() const { return nextOperandId_; }
  uint32_t numInstructions() const { return nextInstructionId_; }

  size_t numStubFields() const { return stubFields_.length(); }
  StubField::Type stubFieldType(uint32_t i) const {
    return stubFields_[i].type();
  }

  uint32_t setInputOperandId(uint32_t op) {
    MOZ_ASSERT(op == nextOperandId_);
    nextOperandId_++;
    numInputOperands_++;
    return op;
  }

  void trace(JSTracer* trc) override {
    // For now, assert we only GC before we append stub fields.
    MOZ_RELEASE_ASSERT(stubFields_.empty());
  }

  size_t stubDataSize() const { return stubDataSize_; }
  void copyStubData(uint8_t* dest) const;
  bool stubDataEqualsMaybeUpdate(uint8_t* stubData, bool* updated) const;

  bool operandIsDead(uint32_t operandId, uint32_t currentInstruction) const {
    if (operandId >= operandLastUsed_.length()) {
      return false;
    }
    return currentInstruction > operandLastUsed_[operandId];
  }

  const uint8_t* codeStart() const {
    MOZ_ASSERT(!failed());
    return buffer_.buffer();
  }

  const uint8_t* codeEnd() const {
    MOZ_ASSERT(!failed());
    return buffer_.buffer() + buffer_.length();
  }

  uint32_t codeLength() const {
    MOZ_ASSERT(!failed());
    return buffer_.length();
  }

  // This should not be used when compiling Baseline code, as Baseline code
  // shouldn't bake in stub values.
  StubField readStubFieldForIon(uint32_t offset, StubField::Type type) const;

  ObjOperandId guardToObject(ValOperandId input) {
    guardToObject_(input);
    return ObjOperandId(input.id());
  }

  StringOperandId guardToString(ValOperandId input) {
    guardToString_(input);
    return StringOperandId(input.id());
  }

  SymbolOperandId guardToSymbol(ValOperandId input) {
    guardToSymbol_(input);
    return SymbolOperandId(input.id());
  }

  BigIntOperandId guardToBigInt(ValOperandId input) {
    guardToBigInt_(input);
    return BigIntOperandId(input.id());
  }

  NumberOperandId guardIsNumber(ValOperandId input) {
    guardIsNumber_(input);
    return NumberOperandId(input.id());
  }

  void guardShapeForClass(ObjOperandId obj, Shape* shape) {
    // Guard shape to ensure that object class is unchanged. This is true
    // for all shapes.
    guardShape(obj, shape);
  }

  void guardShapeForOwnProperties(ObjOperandId obj, Shape* shape) {
    // Guard shape to detect changes to (non-dense) own properties. This
    // also implies |guardShapeForClass|.
    MOZ_ASSERT(shape->getObjectClass()->isNative());
    guardShape(obj, shape);
  }

 public:
  // Instead of calling guardGroup manually, use (or create) a specialization
  // below to clarify what constraint the group guard is implying.
  void guardGroupForProto(ObjOperandId obj, ObjectGroup* group) {
    MOZ_ASSERT(!group->hasUncacheableProto());
    guardGroup(obj, group);
  }

  void guardGroupForTypeBarrier(ObjOperandId obj, ObjectGroup* group) {
    // Typesets will always be a super-set of any typesets previously seen
    // for this group. If the type/group of a value being stored to a
    // property in this group is not known, a TypeUpdate IC chain should be
    // used as well.
    guardGroup(obj, group);
  }

  void guardGroupForLayout(ObjOperandId obj, ObjectGroup* group) {
    // NOTE: Comment in guardGroupForTypeBarrier also applies.
    MOZ_ASSERT(IsTypedObjectClass(group->clasp()));
    guardGroup(obj, group);
  }

  void guardSpecificFunction(ObjOperandId obj, JSFunction* expected) {
    // Guard object is a specific function. This implies immutable fields on
    // the JSFunction struct itself are unchanged.
    // Bake in the nargs and FunctionFlags so Warp can use them off-main thread,
    // instead of directly using the JSFunction fields.
    static_assert(JSFunction::NArgsBits == 16);
    static_assert(sizeof(decltype(expected->flags().toRaw())) ==
                  sizeof(uint16_t));

    uint32_t nargsAndFlags =
        (uint32_t(expected->nargs()) << 16) | expected->flags().toRaw();
    guardSpecificFunction_(obj, expected, nargsAndFlags);
  }

  ValOperandId loadArgumentFixedSlot(
      ArgumentKind kind, uint32_t argc,
      CallFlags flags = CallFlags(CallFlags::Standard)) {
    bool addArgc;
    int32_t slotIndex = GetIndexOfArgument(kind, flags, &addArgc);
    if (addArgc) {
      slotIndex += argc;
    }
    MOZ_ASSERT(slotIndex >= 0);
    MOZ_ASSERT(slotIndex <= UINT8_MAX);
    return loadArgumentFixedSlot_(slotIndex);
  }

  ValOperandId loadArgumentDynamicSlot(
      ArgumentKind kind, Int32OperandId argcId,
      CallFlags flags = CallFlags(CallFlags::Standard)) {
    bool addArgc;
    int32_t slotIndex = GetIndexOfArgument(kind, flags, &addArgc);
    if (addArgc) {
      return loadArgumentDynamicSlot_(argcId, slotIndex);
    }
    return loadArgumentFixedSlot_(slotIndex);
  }

  void callNativeFunction(ObjOperandId calleeId, Int32OperandId argc, JSOp op,
                          HandleFunction calleeFunc, CallFlags flags) {
    // Some native functions can be implemented faster if we know that
    // the return value is ignored.
    bool ignoresReturnValue =
        op == JSOp::CallIgnoresRv && calleeFunc->hasJitInfo() &&
        calleeFunc->jitInfo()->type() == JSJitInfo::IgnoresReturnValueNative;

#ifdef JS_SIMULATOR
    // The simulator requires VM calls to be redirected to a special
    // swi instruction to handle them, so we store the redirected
    // pointer in the stub and use that instead of the original one.
    // If we are calling the ignoresReturnValue version of a native
    // function, we bake it into the redirected pointer.
    // (See BaselineCacheIRCompiler::emitCallNativeFunction.)
    JSNative target = ignoresReturnValue
                          ? calleeFunc->jitInfo()->ignoresReturnValueMethod
                          : calleeFunc->native();
    void* rawPtr = JS_FUNC_TO_DATA_PTR(void*, target);
    void* redirected = Simulator::RedirectNativeFunction(rawPtr, Args_General3);
    callNativeFunction_(calleeId, argc, flags, redirected);
#else
    // If we are not running in the simulator, we generate different jitcode
    // to find the ignoresReturnValue version of a native function.
    callNativeFunction_(calleeId, argc, flags, ignoresReturnValue);
#endif
  }

  void callAnyNativeFunction(ObjOperandId calleeId, Int32OperandId argc,
                             CallFlags flags) {
    MOZ_ASSERT(!flags.isSameRealm());
#ifdef JS_SIMULATOR
    // The simulator requires native calls to be redirected to a
    // special swi instruction. If we are calling an arbitrary native
    // function, we can't wrap the real target ahead of time, so we
    // call a wrapper function (CallAnyNative) that calls the target
    // itself, and redirect that wrapper.
    JSNative target = CallAnyNative;
    void* rawPtr = JS_FUNC_TO_DATA_PTR(void*, target);
    void* redirected = Simulator::RedirectNativeFunction(rawPtr, Args_General3);
    callNativeFunction_(calleeId, argc, flags, redirected);
#else
    callNativeFunction_(calleeId, argc, flags,
                        /* ignoresReturnValue = */ false);
#endif
  }

  void callClassHook(ObjOperandId calleeId, Int32OperandId argc, JSNative hook,
                     CallFlags flags) {
    MOZ_ASSERT(!flags.isSameRealm());
    void* target = JS_FUNC_TO_DATA_PTR(void*, hook);
#ifdef JS_SIMULATOR
    // The simulator requires VM calls to be redirected to a special
    // swi instruction to handle them, so we store the redirected
    // pointer in the stub and use that instead of the original one.
    target = Simulator::RedirectNativeFunction(target, Args_General3);
#endif
    callClassHook_(calleeId, argc, flags, target);
  }

  // These generate no code, but save the template object in a stub
  // field for BaselineInspector.
  void metaNativeTemplateObject(JSFunction* callee, JSObject* templateObject) {
    metaTwoByte_(MetaTwoByteKind::NativeTemplateObject, callee, templateObject);
  }

  void metaScriptedTemplateObject(JSFunction* callee,
                                  JSObject* templateObject) {
    metaTwoByte_(MetaTwoByteKind::ScriptedTemplateObject, callee,
                 templateObject);
  }

  CACHE_IR_WRITER_GENERATED
};

class CacheIRStubInfo;

// Helper class for reading CacheIR bytecode.
class MOZ_RAII CacheIRReader {
  CompactBufferReader buffer_;

  CacheIRReader(const CacheIRReader&) = delete;
  CacheIRReader& operator=(const CacheIRReader&) = delete;

 public:
  CacheIRReader(const uint8_t* start, const uint8_t* end)
      : buffer_(start, end) {}
  explicit CacheIRReader(const CacheIRWriter& writer)
      : CacheIRReader(writer.codeStart(), writer.codeEnd()) {}
  explicit CacheIRReader(const CacheIRStubInfo* stubInfo);

  bool more() const { return buffer_.more(); }

  CacheOp readOp() { return CacheOp(buffer_.readByte()); }

  // Skip data not currently used.
  void skip() { buffer_.readByte(); }
  void skip(uint32_t skipLength) {
    if (skipLength > 0) {
      buffer_.seek(buffer_.currentPosition(), skipLength);
    }
  }

  ValOperandId valOperandId() { return ValOperandId(buffer_.readByte()); }
  ValueTagOperandId valueTagOperandId() {
    return ValueTagOperandId(buffer_.readByte());
  }

  ObjOperandId objOperandId() { return ObjOperandId(buffer_.readByte()); }
  NumberOperandId numberOperandId() {
    return NumberOperandId(buffer_.readByte());
  }
  StringOperandId stringOperandId() {
    return StringOperandId(buffer_.readByte());
  }

  SymbolOperandId symbolOperandId() {
    return SymbolOperandId(buffer_.readByte());
  }

  BigIntOperandId bigIntOperandId() {
    return BigIntOperandId(buffer_.readByte());
  }

  Int32OperandId int32OperandId() { return Int32OperandId(buffer_.readByte()); }

  uint32_t rawOperandId() { return buffer_.readByte(); }

  uint32_t stubOffset() { return buffer_.readByte() * sizeof(uintptr_t); }
  GuardClassKind guardClassKind() { return GuardClassKind(buffer_.readByte()); }
  JSValueType jsValueType() { return JSValueType(buffer_.readByte()); }
  ValueType valueType() { return ValueType(buffer_.readByte()); }

  TypedThingLayout typedThingLayout() {
    return TypedThingLayout(buffer_.readByte());
  }

  Scalar::Type scalarType() { return Scalar::Type(buffer_.readByte()); }
  uint32_t typeDescrKey() { return buffer_.readByte(); }
  JSWhyMagic whyMagic() { return JSWhyMagic(buffer_.readByte()); }
  JSOp jsop() { return JSOp(buffer_.readByte()); }
  int32_t int32Immediate() { return int32_t(buffer_.readFixedUint32_t()); }
  uint32_t uint32Immediate() { return buffer_.readFixedUint32_t(); }
  void* pointer() { return buffer_.readRawPointer(); }

  template <typename MetaKind>
  MetaKind metaKind() {
    return MetaKind(buffer_.readByte());
  }

  ReferenceType referenceTypeDescrType() {
    return ReferenceType(buffer_.readByte());
  }

  UnaryMathFunction unaryMathFunction() {
    return UnaryMathFunction(buffer_.readByte());
  }

  CallFlags callFlags() {
    // See CacheIRWriter::writeCallFlagsImm()
    uint8_t encoded = buffer_.readByte();
    CallFlags::ArgFormat format =
        CallFlags::ArgFormat(encoded & CallFlags::ArgFormatMask);
    bool isConstructing = encoded & CallFlags::IsConstructing;
    bool isSameRealm = encoded & CallFlags::IsSameRealm;
    switch (format) {
      case CallFlags::Standard:
        return CallFlags(isConstructing, /*isSpread =*/false, isSameRealm);
      case CallFlags::Spread:
        return CallFlags(isConstructing, /*isSpread =*/true, isSameRealm);
      default:
        // The existing non-standard argument formats (FunCall and FunApply)
        // can't be constructors and have no support for isSameRealm.
        MOZ_ASSERT(!isConstructing && !isSameRealm);
        return CallFlags(format);
    }
  }

  uint8_t readByte() { return buffer_.readByte(); }
  bool readBool() {
    uint8_t b = buffer_.readByte();
    MOZ_ASSERT(b <= 1);
    return bool(b);
  }

  bool matchOp(CacheOp op) {
    const uint8_t* pos = buffer_.currentPosition();
    if (readOp() == op) {
      return true;
    }
    buffer_.seek(pos, 0);
    return false;
  }

  bool matchOp(CacheOp op, OperandId id) {
    const uint8_t* pos = buffer_.currentPosition();
    if (readOp() == op && buffer_.readByte() == id.id()) {
      return true;
    }
    buffer_.seek(pos, 0);
    return false;
  }

  bool matchOpEither(CacheOp op1, CacheOp op2) {
    const uint8_t* pos = buffer_.currentPosition();
    CacheOp op = readOp();
    if (op == op1 || op == op2) {
      return true;
    }
    buffer_.seek(pos, 0);
    return false;
  }
  const uint8_t* currentPosition() const { return buffer_.currentPosition(); }
};

class MOZ_RAII IRGenerator {
 protected:
  CacheIRWriter writer;
  JSContext* cx_;
  HandleScript script_;
  jsbytecode* pc_;
  CacheKind cacheKind_;
  ICState::Mode mode_;

  IRGenerator(const IRGenerator&) = delete;
  IRGenerator& operator=(const IRGenerator&) = delete;

  bool maybeGuardInt32Index(const Value& index, ValOperandId indexId,
                            uint32_t* int32Index, Int32OperandId* int32IndexId);

  ObjOperandId guardDOMProxyExpandoObjectAndShape(JSObject* obj,
                                                  ObjOperandId objId,
                                                  const Value& expandoVal,
                                                  JSObject* expandoObj);

  void emitIdGuard(ValOperandId valId, jsid id);

  friend class CacheIRSpewer;

 public:
  explicit IRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                       CacheKind cacheKind, ICState::Mode mode);

  const CacheIRWriter& writerRef() const { return writer; }
  CacheKind cacheKind() const { return cacheKind_; }

  static constexpr char* NotAttached = nullptr;
};

// Flags used to describe what values a GetProperty cache may produce.
enum class GetPropertyResultFlags {
  None = 0,

  // Values produced by this cache will go through a type barrier,
  // so the cache may produce any type of value that is compatible with its
  // result operand.
  Monitored = 1 << 0,

  // Whether particular primitives may be produced by this cache.
  AllowUndefined = 1 << 1,
  AllowInt32 = 1 << 2,
  AllowDouble = 1 << 3,

  All = Monitored | AllowUndefined | AllowInt32 | AllowDouble
};

static inline bool operator&(GetPropertyResultFlags a,
                             GetPropertyResultFlags b) {
  return static_cast<int>(a) & static_cast<int>(b);
}

static inline GetPropertyResultFlags operator|(GetPropertyResultFlags a,
                                               GetPropertyResultFlags b) {
  return static_cast<GetPropertyResultFlags>(static_cast<int>(a) |
                                             static_cast<int>(b));
}

static inline GetPropertyResultFlags& operator|=(GetPropertyResultFlags& lhs,
                                                 GetPropertyResultFlags b) {
  lhs = lhs | b;
  return lhs;
}

// GetPropIRGenerator generates CacheIR for a GetProp IC.
class MOZ_RAII GetPropIRGenerator : public IRGenerator {
  HandleValue val_;
  HandleValue idVal_;
  HandleValue receiver_;
  GetPropertyResultFlags resultFlags_;

  enum class PreliminaryObjectAction { None, Unlink, NotePreliminary };
  PreliminaryObjectAction preliminaryObjectAction_;

  AttachDecision tryAttachNative(HandleObject obj, ObjOperandId objId,
                                 HandleId id);
  AttachDecision tryAttachUnboxed(HandleObject obj, ObjOperandId objId,
                                  HandleId id);
  AttachDecision tryAttachUnboxedExpando(HandleObject obj, ObjOperandId objId,
                                         HandleId id);
  AttachDecision tryAttachTypedObject(HandleObject obj, ObjOperandId objId,
                                      HandleId id);
  AttachDecision tryAttachObjectLength(HandleObject obj, ObjOperandId objId,
                                       HandleId id);
  AttachDecision tryAttachTypedArrayLength(HandleObject obj, ObjOperandId objId,
                                           HandleId id);
  AttachDecision tryAttachModuleNamespace(HandleObject obj, ObjOperandId objId,
                                          HandleId id);
  AttachDecision tryAttachWindowProxy(HandleObject obj, ObjOperandId objId,
                                      HandleId id);
  AttachDecision tryAttachCrossCompartmentWrapper(HandleObject obj,
                                                  ObjOperandId objId,
                                                  HandleId id);
  AttachDecision tryAttachXrayCrossCompartmentWrapper(HandleObject obj,
                                                      ObjOperandId objId,
                                                      HandleId id);
  AttachDecision tryAttachFunction(HandleObject obj, ObjOperandId objId,
                                   HandleId id);

  AttachDecision tryAttachGenericProxy(HandleObject obj, ObjOperandId objId,
                                       HandleId id, bool handleDOMProxies);
  AttachDecision tryAttachDOMProxyExpando(HandleObject obj, ObjOperandId objId,
                                          HandleId id);
  AttachDecision tryAttachDOMProxyShadowed(HandleObject obj, ObjOperandId objId,
                                           HandleId id);
  AttachDecision tryAttachDOMProxyUnshadowed(HandleObject obj,
                                             ObjOperandId objId, HandleId id);
  AttachDecision tryAttachProxy(HandleObject obj, ObjOperandId objId,
                                HandleId id);

  AttachDecision tryAttachPrimitive(ValOperandId valId, HandleId id);
  AttachDecision tryAttachStringChar(ValOperandId valId, ValOperandId indexId);
  AttachDecision tryAttachStringLength(ValOperandId valId, HandleId id);
  AttachDecision tryAttachMagicArgumentsName(ValOperandId valId, HandleId id);

  AttachDecision tryAttachMagicArgument(ValOperandId valId,
                                        ValOperandId indexId);
  AttachDecision tryAttachArgumentsObjectArg(HandleObject obj,
                                             ObjOperandId objId,
                                             Int32OperandId indexId);

  AttachDecision tryAttachDenseElement(HandleObject obj, ObjOperandId objId,
                                       uint32_t index, Int32OperandId indexId);
  AttachDecision tryAttachDenseElementHole(HandleObject obj, ObjOperandId objId,
                                           uint32_t index,
                                           Int32OperandId indexId);
  AttachDecision tryAttachSparseElement(HandleObject obj, ObjOperandId objId,
                                        uint32_t index, Int32OperandId indexId);
  AttachDecision tryAttachTypedElement(HandleObject obj, ObjOperandId objId,
                                       uint32_t index, Int32OperandId indexId);
  AttachDecision tryAttachTypedArrayNonInt32Index(HandleObject obj,
                                                  ObjOperandId objId);

  AttachDecision tryAttachGenericElement(HandleObject obj, ObjOperandId objId,
                                         uint32_t index,
                                         Int32OperandId indexId);

  AttachDecision tryAttachProxyElement(HandleObject obj, ObjOperandId objId);

  void attachMegamorphicNativeSlot(ObjOperandId objId, jsid id,
                                   bool handleMissing);

  ValOperandId getElemKeyValueId() const {
    MOZ_ASSERT(cacheKind_ == CacheKind::GetElem ||
               cacheKind_ == CacheKind::GetElemSuper);
    return ValOperandId(1);
  }

  ValOperandId getSuperReceiverValueId() const {
    if (cacheKind_ == CacheKind::GetPropSuper) {
      return ValOperandId(1);
    }

    MOZ_ASSERT(cacheKind_ == CacheKind::GetElemSuper);
    return ValOperandId(2);
  }

  bool isSuper() const {
    return (cacheKind_ == CacheKind::GetPropSuper ||
            cacheKind_ == CacheKind::GetElemSuper);
  }

  // No pc if idempotent, as there can be multiple bytecode locations
  // due to GVN.
  bool idempotent() const { return pc_ == nullptr; }

  // If this is a GetElem cache, emit instructions to guard the incoming Value
  // matches |id|.
  void maybeEmitIdGuard(jsid id);

  void trackAttached(const char* name);

 public:
  GetPropIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                     ICState::Mode mode, CacheKind cacheKind, HandleValue val,
                     HandleValue idVal, HandleValue receiver,
                     GetPropertyResultFlags resultFlags);

  AttachDecision tryAttachStub();
  AttachDecision tryAttachIdempotentStub();

  bool shouldUnlinkPreliminaryObjectStubs() const {
    return preliminaryObjectAction_ == PreliminaryObjectAction::Unlink;
  }

  bool shouldNotePreliminaryObjectStub() const {
    return preliminaryObjectAction_ == PreliminaryObjectAction::NotePreliminary;
  }
};

// GetNameIRGenerator generates CacheIR for a GetName IC.
class MOZ_RAII GetNameIRGenerator : public IRGenerator {
  HandleObject env_;
  HandlePropertyName name_;

  AttachDecision tryAttachGlobalNameValue(ObjOperandId objId, HandleId id);
  AttachDecision tryAttachGlobalNameGetter(ObjOperandId objId, HandleId id);
  AttachDecision tryAttachEnvironmentName(ObjOperandId objId, HandleId id);

  void trackAttached(const char* name);

 public:
  GetNameIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                     ICState::Mode mode, HandleObject env,
                     HandlePropertyName name);

  AttachDecision tryAttachStub();
};

// BindNameIRGenerator generates CacheIR for a BindName IC.
class MOZ_RAII BindNameIRGenerator : public IRGenerator {
  HandleObject env_;
  HandlePropertyName name_;

  AttachDecision tryAttachGlobalName(ObjOperandId objId, HandleId id);
  AttachDecision tryAttachEnvironmentName(ObjOperandId objId, HandleId id);

  void trackAttached(const char* name);

 public:
  BindNameIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                      ICState::Mode mode, HandleObject env,
                      HandlePropertyName name);

  AttachDecision tryAttachStub();
};

// Information used by SetProp/SetElem stubs to check/update property types.
class MOZ_RAII PropertyTypeCheckInfo {
  RootedObjectGroup group_;
  RootedId id_;
  bool needsTypeBarrier_;

  PropertyTypeCheckInfo(const PropertyTypeCheckInfo&) = delete;
  void operator=(const PropertyTypeCheckInfo&) = delete;

 public:
  PropertyTypeCheckInfo(JSContext* cx, bool needsTypeBarrier)
      : group_(cx), id_(cx), needsTypeBarrier_(needsTypeBarrier) {
    if (!IsTypeInferenceEnabled()) {
      needsTypeBarrier_ = false;
    }
  }

  bool needsTypeBarrier() const { return needsTypeBarrier_; }
  bool isSet() const { return group_ != nullptr; }

  ObjectGroup* group() const {
    MOZ_ASSERT(isSet());
    return group_;
  }

  jsid id() const {
    MOZ_ASSERT(isSet());
    return id_;
  }

  void set(ObjectGroup* group, jsid id) {
    MOZ_ASSERT(!group_);
    MOZ_ASSERT(group);
    if (needsTypeBarrier_) {
      group_ = group;
      id_ = id;
    }
  }
};

// SetPropIRGenerator generates CacheIR for a SetProp IC.
class MOZ_RAII SetPropIRGenerator : public IRGenerator {
  HandleValue lhsVal_;
  HandleValue idVal_;
  HandleValue rhsVal_;
  PropertyTypeCheckInfo typeCheckInfo_;

  enum class PreliminaryObjectAction { None, Unlink, NotePreliminary };
  PreliminaryObjectAction preliminaryObjectAction_;
  bool attachedTypedArrayOOBStub_;

  bool maybeHasExtraIndexedProps_;

 public:
  enum class DeferType { None, AddSlot };

 private:
  DeferType deferType_ = DeferType::None;

  ValOperandId setElemKeyValueId() const {
    MOZ_ASSERT(cacheKind_ == CacheKind::SetElem);
    return ValOperandId(1);
  }

  ValOperandId rhsValueId() const {
    if (cacheKind_ == CacheKind::SetProp) {
      return ValOperandId(1);
    }
    MOZ_ASSERT(cacheKind_ == CacheKind::SetElem);
    return ValOperandId(2);
  }

  // If this is a SetElem cache, emit instructions to guard the incoming Value
  // matches |id|.
  void maybeEmitIdGuard(jsid id);

  OperandId emitNumericGuard(ValOperandId valId, Scalar::Type type);

  AttachDecision tryAttachNativeSetSlot(HandleObject obj, ObjOperandId objId,
                                        HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachUnboxedExpandoSetSlot(HandleObject obj,
                                                ObjOperandId objId, HandleId id,
                                                ValOperandId rhsId);
  AttachDecision tryAttachUnboxedProperty(HandleObject obj, ObjOperandId objId,
                                          HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachTypedObjectProperty(HandleObject obj,
                                              ObjOperandId objId, HandleId id,
                                              ValOperandId rhsId);
  AttachDecision tryAttachSetter(HandleObject obj, ObjOperandId objId,
                                 HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachSetArrayLength(HandleObject obj, ObjOperandId objId,
                                         HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachWindowProxy(HandleObject obj, ObjOperandId objId,
                                      HandleId id, ValOperandId rhsId);

  AttachDecision tryAttachSetDenseElement(HandleObject obj, ObjOperandId objId,
                                          uint32_t index,
                                          Int32OperandId indexId,
                                          ValOperandId rhsId);
  AttachDecision tryAttachSetTypedElement(HandleObject obj, ObjOperandId objId,
                                          uint32_t index,
                                          Int32OperandId indexId,
                                          ValOperandId rhsId);
  AttachDecision tryAttachSetTypedArrayElementNonInt32Index(HandleObject obj,
                                                            ObjOperandId objId,
                                                            ValOperandId rhsId);

  AttachDecision tryAttachSetDenseElementHole(HandleObject obj,
                                              ObjOperandId objId,
                                              uint32_t index,
                                              Int32OperandId indexId,
                                              ValOperandId rhsId);

  AttachDecision tryAttachAddOrUpdateSparseElement(HandleObject obj,
                                                   ObjOperandId objId,
                                                   uint32_t index,
                                                   Int32OperandId indexId,
                                                   ValOperandId rhsId);

  AttachDecision tryAttachGenericProxy(HandleObject obj, ObjOperandId objId,
                                       HandleId id, ValOperandId rhsId,
                                       bool handleDOMProxies);
  AttachDecision tryAttachDOMProxyShadowed(HandleObject obj, ObjOperandId objId,
                                           HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachDOMProxyUnshadowed(HandleObject obj,
                                             ObjOperandId objId, HandleId id,
                                             ValOperandId rhsId);
  AttachDecision tryAttachDOMProxyExpando(HandleObject obj, ObjOperandId objId,
                                          HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachProxy(HandleObject obj, ObjOperandId objId,
                                HandleId id, ValOperandId rhsId);
  AttachDecision tryAttachProxyElement(HandleObject obj, ObjOperandId objId,
                                       ValOperandId rhsId);
  AttachDecision tryAttachMegamorphicSetElement(HandleObject obj,
                                                ObjOperandId objId,
                                                ValOperandId rhsId);

  bool canAttachAddSlotStub(HandleObject obj, HandleId id);

 public:
  SetPropIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                     CacheKind cacheKind, ICState::Mode mode,
                     HandleValue lhsVal, HandleValue idVal, HandleValue rhsVal,
                     bool needsTypeBarrier = true,
                     bool maybeHasExtraIndexedProps = true);

  AttachDecision tryAttachStub();
  AttachDecision tryAttachAddSlotStub(HandleObjectGroup oldGroup,
                                      HandleShape oldShape);
  void trackAttached(const char* name);

  bool shouldUnlinkPreliminaryObjectStubs() const {
    return preliminaryObjectAction_ == PreliminaryObjectAction::Unlink;
  }

  bool shouldNotePreliminaryObjectStub() const {
    return preliminaryObjectAction_ == PreliminaryObjectAction::NotePreliminary;
  }

  const PropertyTypeCheckInfo* typeCheckInfo() const { return &typeCheckInfo_; }

  bool attachedTypedArrayOOBStub() const { return attachedTypedArrayOOBStub_; }

  DeferType deferType() const { return deferType_; }
};

// HasPropIRGenerator generates CacheIR for a HasProp IC. Used for
// CacheKind::In / CacheKind::HasOwn.
class MOZ_RAII HasPropIRGenerator : public IRGenerator {
  HandleValue val_;
  HandleValue idVal_;

  AttachDecision tryAttachDense(HandleObject obj, ObjOperandId objId,
                                uint32_t index, Int32OperandId indexId);
  AttachDecision tryAttachDenseHole(HandleObject obj, ObjOperandId objId,
                                    uint32_t index, Int32OperandId indexId);
  AttachDecision tryAttachTypedArray(HandleObject obj, ObjOperandId objId,
                                     Int32OperandId indexId);
  AttachDecision tryAttachTypedArrayNonInt32Index(HandleObject obj,
                                                  ObjOperandId objId,
                                                  ValOperandId keyId);
  AttachDecision tryAttachSparse(HandleObject obj, ObjOperandId objId,
                                 Int32OperandId indexId);
  AttachDecision tryAttachNamedProp(HandleObject obj, ObjOperandId objId,
                                    HandleId key, ValOperandId keyId);
  AttachDecision tryAttachMegamorphic(ObjOperandId objId, ValOperandId keyId);
  AttachDecision tryAttachNative(JSObject* obj, ObjOperandId objId, jsid key,
                                 ValOperandId keyId, PropertyResult prop,
                                 JSObject* holder);
  AttachDecision tryAttachUnboxed(JSObject* obj, ObjOperandId objId, jsid key,
                                  ValOperandId keyId);
  AttachDecision tryAttachUnboxedExpando(JSObject* obj, ObjOperandId objId,
                                         jsid key, ValOperandId keyId);
  AttachDecision tryAttachTypedObject(JSObject* obj, ObjOperandId objId,
                                      jsid key, ValOperandId keyId);
  AttachDecision tryAttachSlotDoesNotExist(JSObject* obj, ObjOperandId objId,
                                           jsid key, ValOperandId keyId);
  AttachDecision tryAttachDoesNotExist(HandleObject obj, ObjOperandId objId,
                                       HandleId key, ValOperandId keyId);
  AttachDecision tryAttachProxyElement(HandleObject obj, ObjOperandId objId,
                                       ValOperandId keyId);

  void trackAttached(const char* name);

 public:
  // NOTE: Argument order is PROPERTY, OBJECT
  HasPropIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc,
                     ICState::Mode mode, CacheKind cacheKind, HandleValue idVal,
                     HandleValue val);

  AttachDecision tryAttachStub();
};

class MOZ_RAII InstanceOfIRGenerator : public IRGenerator {
  HandleValue lhsVal_;
  HandleObject rhsObj_;

  void trackAttached(const char* name);

 public:
  InstanceOfIRGenerator(JSContext*, HandleScript, jsbytecode*, ICState::Mode,
                        HandleValue, HandleObject);

  AttachDecision tryAttachStub();
};

class MOZ_RAII TypeOfIRGenerator : public IRGenerator {
  HandleValue val_;

  AttachDecision tryAttachPrimitive(ValOperandId valId);
  AttachDecision tryAttachObject(ValOperandId valId);
  void trackAttached(const char* name);

 public:
  TypeOfIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                    ICState::Mode mode, HandleValue value);

  AttachDecision tryAttachStub();
};

class MOZ_RAII GetIteratorIRGenerator : public IRGenerator {
  HandleValue val_;

  AttachDecision tryAttachNativeIterator(ObjOperandId objId, HandleObject obj);

 public:
  GetIteratorIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                         ICState::Mode mode, HandleValue value);

  AttachDecision tryAttachStub();

  void trackAttached(const char* name);
};

enum class StringChar { CodeAt, At };

class MOZ_RAII CallIRGenerator : public IRGenerator {
 private:
  JSOp op_;
  uint32_t argc_;
  HandleValue callee_;
  HandleValue thisval_;
  HandleValue newTarget_;
  HandleValueArray args_;
  PropertyTypeCheckInfo typeCheckInfo_;
  BaselineCacheIRStubKind cacheIRStubKind_;

  bool getTemplateObjectForScripted(HandleFunction calleeFunc,
                                    MutableHandleObject result,
                                    bool* skipAttach);
  bool getTemplateObjectForNative(HandleFunction calleeFunc,
                                  MutableHandleObject result);

  void emitNativeCalleeGuard(HandleFunction callee);

  AttachDecision tryAttachArrayPush(HandleFunction callee);
  AttachDecision tryAttachArrayJoin(HandleFunction callee);
  AttachDecision tryAttachArrayIsArray(HandleFunction callee);
  AttachDecision tryAttachIsSuspendedGenerator(HandleFunction callee);
  AttachDecision tryAttachToString(HandleFunction callee);
  AttachDecision tryAttachToObject(HandleFunction callee);
  AttachDecision tryAttachToInteger(HandleFunction callee);
  AttachDecision tryAttachIsObject(HandleFunction callee);
  AttachDecision tryAttachIsCallable(HandleFunction callee);
  AttachDecision tryAttachIsConstructor(HandleFunction callee);
  AttachDecision tryAttachStringChar(HandleFunction callee, StringChar kind);
  AttachDecision tryAttachStringCharCodeAt(HandleFunction callee);
  AttachDecision tryAttachStringCharAt(HandleFunction callee);
  AttachDecision tryAttachMathAbs(HandleFunction callee);
  AttachDecision tryAttachMathFloor(HandleFunction callee);
  AttachDecision tryAttachMathCeil(HandleFunction callee);
  AttachDecision tryAttachMathRound(HandleFunction callee);
  AttachDecision tryAttachMathSqrt(HandleFunction callee);
  AttachDecision tryAttachMathFunction(HandleFunction callee,
                                       UnaryMathFunction fun);

  AttachDecision tryAttachFunCall(HandleFunction calleeFunc);
  AttachDecision tryAttachFunApply(HandleFunction calleeFunc);
  AttachDecision tryAttachCallScripted(HandleFunction calleeFunc);
  AttachDecision tryAttachInlinableNative(HandleFunction calleeFunc);
  AttachDecision tryAttachCallNative(HandleFunction calleeFunc);
  AttachDecision tryAttachCallHook(HandleObject calleeObj);

  void trackAttached(const char* name);

 public:
  CallIRGenerator(JSContext* cx, HandleScript script, jsbytecode* pc, JSOp op,
                  ICState::Mode mode, uint32_t argc, HandleValue callee,
                  HandleValue thisval, HandleValue newTarget,
                  HandleValueArray args);

  AttachDecision tryAttachStub();

  AttachDecision tryAttachDeferredStub(HandleValue result);

  BaselineCacheIRStubKind cacheIRStubKind() const { return cacheIRStubKind_; }

  const PropertyTypeCheckInfo* typeCheckInfo() const { return &typeCheckInfo_; }
};

class MOZ_RAII CompareIRGenerator : public IRGenerator {
  JSOp op_;
  HandleValue lhsVal_;
  HandleValue rhsVal_;

  AttachDecision tryAttachString(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachObject(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachSymbol(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachStrictDifferentTypes(ValOperandId lhsId,
                                               ValOperandId rhsId);
  AttachDecision tryAttachInt32(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachNumber(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachBigInt(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachNumberUndefined(ValOperandId lhsId,
                                          ValOperandId rhsId);
  AttachDecision tryAttachPrimitiveUndefined(ValOperandId lhsId,
                                             ValOperandId rhsId);
  AttachDecision tryAttachObjectUndefined(ValOperandId lhsId,
                                          ValOperandId rhsId);
  AttachDecision tryAttachNullUndefined(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachStringNumber(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachPrimitiveSymbol(ValOperandId lhsId,
                                          ValOperandId rhsId);
  AttachDecision tryAttachBoolStringOrNumber(ValOperandId lhsId,
                                             ValOperandId rhsId);
  AttachDecision tryAttachBigIntInt32(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachBigIntNumber(ValOperandId lhsId, ValOperandId rhsId);
  AttachDecision tryAttachBigIntString(ValOperandId lhsId, ValOperandId rhsId);

  void trackAttached(const char* name);

 public:
  CompareIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                     ICState::Mode mode, JSOp op, HandleValue lhsVal,
                     HandleValue rhsVal);

  AttachDecision tryAttachStub();
};

class MOZ_RAII ToBoolIRGenerator : public IRGenerator {
  HandleValue val_;

  AttachDecision tryAttachInt32();
  AttachDecision tryAttachNumber();
  AttachDecision tryAttachString();
  AttachDecision tryAttachSymbol();
  AttachDecision tryAttachNullOrUndefined();
  AttachDecision tryAttachObject();
  AttachDecision tryAttachBigInt();

  void trackAttached(const char* name);

 public:
  ToBoolIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                    ICState::Mode mode, HandleValue val);

  AttachDecision tryAttachStub();
};

class MOZ_RAII GetIntrinsicIRGenerator : public IRGenerator {
  HandleValue val_;

  void trackAttached(const char* name);

 public:
  GetIntrinsicIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                          ICState::Mode, HandleValue val);

  AttachDecision tryAttachStub();
};

class MOZ_RAII UnaryArithIRGenerator : public IRGenerator {
  JSOp op_;
  HandleValue val_;
  HandleValue res_;

  AttachDecision tryAttachInt32();
  AttachDecision tryAttachNumber();
  AttachDecision tryAttachBigInt();
  AttachDecision tryAttachStringInt32();
  AttachDecision tryAttachStringNumber();

  void trackAttached(const char* name);

 public:
  UnaryArithIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                        ICState::Mode mode, JSOp op, HandleValue val,
                        HandleValue res);

  AttachDecision tryAttachStub();
};

class MOZ_RAII BinaryArithIRGenerator : public IRGenerator {
  JSOp op_;
  HandleValue lhs_;
  HandleValue rhs_;
  HandleValue res_;

  void trackAttached(const char* name);

  AttachDecision tryAttachInt32();
  AttachDecision tryAttachDouble();
  AttachDecision tryAttachBitwise();
  AttachDecision tryAttachStringConcat();
  AttachDecision tryAttachStringObjectConcat();
  AttachDecision tryAttachStringNumberConcat();
  AttachDecision tryAttachStringBooleanConcat();
  AttachDecision tryAttachBigInt();
  AttachDecision tryAttachStringInt32Arith();

 public:
  BinaryArithIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                         ICState::Mode, JSOp op, HandleValue lhs,
                         HandleValue rhs, HandleValue res);

  AttachDecision tryAttachStub();
};

class MOZ_RAII NewObjectIRGenerator : public IRGenerator {
#ifdef JS_CACHEIR_SPEW
  JSOp op_;
#endif
  HandleObject templateObject_;

  void trackAttached(const char* name);

 public:
  NewObjectIRGenerator(JSContext* cx, HandleScript, jsbytecode* pc,
                       ICState::Mode, JSOp op, HandleObject templateObj);

  AttachDecision tryAttachStub();
};

static inline uint32_t SimpleTypeDescrKey(SimpleTypeDescr* descr) {
  if (descr->is<ScalarTypeDescr>()) {
    return uint32_t(descr->as<ScalarTypeDescr>().type()) << 1;
  }
  return (uint32_t(descr->as<ReferenceTypeDescr>().type()) << 1) | 1;
}

inline bool SimpleTypeDescrKeyIsScalar(uint32_t key) { return !(key & 1); }

inline ScalarTypeDescr::Type ScalarTypeFromSimpleTypeDescrKey(uint32_t key) {
  MOZ_ASSERT(SimpleTypeDescrKeyIsScalar(key));
  return ScalarTypeDescr::Type(key >> 1);
}

inline ReferenceType ReferenceTypeFromSimpleTypeDescrKey(uint32_t key) {
  MOZ_ASSERT(!SimpleTypeDescrKeyIsScalar(key));
  return ReferenceType(key >> 1);
}

// Returns whether obj is a WindowProxy wrapping the script's global.
extern bool IsWindowProxyForScriptGlobal(JSScript* script, JSObject* obj);

}  // namespace jit
}  // namespace js

#endif /* jit_CacheIR_h */
