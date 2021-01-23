/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_shared_LIR_shared_h
#define jit_shared_LIR_shared_h

#include "jit/AtomicOp.h"
#include "jit/shared/Assembler-shared.h"
#include "util/Memory.h"

// This file declares LIR instructions that are common to every platform.

namespace js {
namespace jit {

class LBox : public LInstructionHelper<BOX_PIECES, 1, 0> {
  MIRType type_;

 public:
  LIR_HEADER(Box);

  LBox(const LAllocation& payload, MIRType type)
      : LInstructionHelper(classOpcode), type_(type) {
    setOperand(0, payload);
  }

  MIRType type() const { return type_; }
  const char* extraName() const { return StringFromMIRType(type_); }
};

template <size_t Temps, size_t ExtraUses = 0>
class LBinaryMath : public LInstructionHelper<1, 2 + ExtraUses, Temps> {
 protected:
  explicit LBinaryMath(LNode::Opcode opcode)
      : LInstructionHelper<1, 2 + ExtraUses, Temps>(opcode) {}

 public:
  const LAllocation* lhs() { return this->getOperand(0); }
  const LAllocation* rhs() { return this->getOperand(1); }
};

// An LOsiPoint captures a snapshot after a call and ensures enough space to
// patch in a call to the invalidation mechanism.
//
// Note: LSafepoints are 1:1 with LOsiPoints, so it holds a reference to the
// corresponding LSafepoint to inform it of the LOsiPoint's masm offset when it
// gets GC'd.
class LOsiPoint : public LInstructionHelper<0, 0, 0> {
  LSafepoint* safepoint_;

 public:
  LOsiPoint(LSafepoint* safepoint, LSnapshot* snapshot)
      : LInstructionHelper(classOpcode), safepoint_(safepoint) {
    MOZ_ASSERT(safepoint && snapshot);
    assignSnapshot(snapshot);
  }

  LSafepoint* associatedSafepoint() { return safepoint_; }

  LIR_HEADER(OsiPoint)
};

class LMove {
  LAllocation from_;
  LAllocation to_;
  LDefinition::Type type_;

 public:
  LMove(LAllocation from, LAllocation to, LDefinition::Type type)
      : from_(from), to_(to), type_(type) {}

  LAllocation from() const { return from_; }
  LAllocation to() const { return to_; }
  LDefinition::Type type() const { return type_; }
};

class LMoveGroup : public LInstructionHelper<0, 0, 0> {
  js::Vector<LMove, 2, JitAllocPolicy> moves_;

#ifdef JS_CODEGEN_X86
  // Optional general register available for use when executing moves.
  LAllocation scratchRegister_;
#endif

  explicit LMoveGroup(TempAllocator& alloc)
      : LInstructionHelper(classOpcode), moves_(alloc) {}

 public:
  LIR_HEADER(MoveGroup)

  static LMoveGroup* New(TempAllocator& alloc) {
    return new (alloc) LMoveGroup(alloc);
  }

  void printOperands(GenericPrinter& out);

  // Add a move which takes place simultaneously with all others in the group.
  bool add(LAllocation from, LAllocation to, LDefinition::Type type);

  // Add a move which takes place after existing moves in the group.
  bool addAfter(LAllocation from, LAllocation to, LDefinition::Type type);

  size_t numMoves() const { return moves_.length(); }
  const LMove& getMove(size_t i) const { return moves_[i]; }

#ifdef JS_CODEGEN_X86
  void setScratchRegister(Register reg) { scratchRegister_ = LGeneralReg(reg); }
  LAllocation maybeScratchRegister() { return scratchRegister_; }
#endif

  bool uses(Register reg) {
    for (size_t i = 0; i < numMoves(); i++) {
      LMove move = getMove(i);
      if (move.from() == LGeneralReg(reg) || move.to() == LGeneralReg(reg)) {
        return true;
      }
    }
    return false;
  }
};

// Constant 32-bit integer.
class LInteger : public LInstructionHelper<1, 0, 0> {
  int32_t i32_;

 public:
  LIR_HEADER(Integer)

  explicit LInteger(int32_t i32) : LInstructionHelper(classOpcode), i32_(i32) {}

  int32_t getValue() const { return i32_; }
};

// Constant 64-bit integer.
class LInteger64 : public LInstructionHelper<INT64_PIECES, 0, 0> {
  int64_t i64_;

 public:
  LIR_HEADER(Integer64)

  explicit LInteger64(int64_t i64)
      : LInstructionHelper(classOpcode), i64_(i64) {}

  int64_t getValue() const { return i64_; }
};

// Constant pointer.
class LPointer : public LInstructionHelper<1, 0, 0> {
 public:
  enum Kind { GC_THING, NON_GC_THING };

 private:
  void* ptr_;
  Kind kind_;

 public:
  LIR_HEADER(Pointer)

  explicit LPointer(gc::Cell* ptr)
      : LInstructionHelper(classOpcode), ptr_(ptr), kind_(GC_THING) {}

  LPointer(void* ptr, Kind kind)
      : LInstructionHelper(classOpcode), ptr_(ptr), kind_(kind) {}

  void* ptr() const { return ptr_; }
  Kind kind() const { return kind_; }
  const char* extraName() const {
    return kind_ == GC_THING ? "GC_THING" : "NON_GC_THING";
  }

  gc::Cell* gcptr() const {
    MOZ_ASSERT(kind() == GC_THING);
    return (gc::Cell*)ptr_;
  }
};

// Constant double.
class LDouble : public LInstructionHelper<1, 0, 0> {
  double d_;

 public:
  LIR_HEADER(Double);

  explicit LDouble(double d) : LInstructionHelper(classOpcode), d_(d) {}

  const double& getDouble() const { return d_; }
};

// Constant float32.
class LFloat32 : public LInstructionHelper<1, 0, 0> {
  float f_;

 public:
  LIR_HEADER(Float32);

  explicit LFloat32(float f) : LInstructionHelper(classOpcode), f_(f) {}

  const float& getFloat() const { return f_; }
};

// A constant Value.
class LValue : public LInstructionHelper<BOX_PIECES, 0, 0> {
  Value v_;

 public:
  LIR_HEADER(Value)

  explicit LValue(const Value& v) : LInstructionHelper(classOpcode), v_(v) {}

  Value value() const { return v_; }
};

// Clone an object literal such as we are not modifying the object contained in
// the sources.
class LCloneLiteral : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(CloneLiteral)

  explicit LCloneLiteral(const LAllocation& obj)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, obj);
  }

  const LAllocation* getObjectLiteral() { return getOperand(0); }

  MCloneLiteral* mir() const { return mir_->toCloneLiteral(); }
};

// Formal argument for a function, returning a box. Formal arguments are
// initially read from the stack.
class LParameter : public LInstructionHelper<BOX_PIECES, 0, 0> {
 public:
  LIR_HEADER(Parameter)

  LParameter() : LInstructionHelper(classOpcode) {}
};

// Stack offset for a word-sized immutable input value to a frame.
class LCallee : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(Callee)

  LCallee() : LInstructionHelper(classOpcode) {}
};

class LIsConstructing : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(IsConstructing)

  LIsConstructing() : LInstructionHelper(classOpcode) {}
};

// Base class for control instructions (goto, branch, etc.)
template <size_t Succs, size_t Operands, size_t Temps>
class LControlInstructionHelper
    : public LInstructionHelper<0, Operands, Temps> {
  mozilla::Array<MBasicBlock*, Succs> successors_;

 protected:
  explicit LControlInstructionHelper(LNode::Opcode opcode)
      : LInstructionHelper<0, Operands, Temps>(opcode) {}

 public:
  size_t numSuccessors() const { return Succs; }
  MBasicBlock* getSuccessor(size_t i) const { return successors_[i]; }

  void setSuccessor(size_t i, MBasicBlock* successor) {
    successors_[i] = successor;
  }
};

// Jumps to the start of a basic block.
class LGoto : public LControlInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(Goto)

  explicit LGoto(MBasicBlock* block) : LControlInstructionHelper(classOpcode) {
    setSuccessor(0, block);
  }

  MBasicBlock* target() const { return getSuccessor(0); }
};

class LNewArray : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewArray)

  explicit LNewArray(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const char* extraName() const {
    return mir()->isVMCall() ? "VMCall" : nullptr;
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewArray* mir() const { return mir_->toNewArray(); }
};

class LNewArrayCopyOnWrite : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewArrayCopyOnWrite)

  explicit LNewArrayCopyOnWrite(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewArrayCopyOnWrite* mir() const { return mir_->toNewArrayCopyOnWrite(); }
};

class LNewArrayDynamicLength : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(NewArrayDynamicLength)

  explicit LNewArrayDynamicLength(const LAllocation& length,
                                  const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, length);
    setTemp(0, temp);
  }

  const LAllocation* length() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }

  MNewArrayDynamicLength* mir() const {
    return mir_->toNewArrayDynamicLength();
  }
};

class LNewIterator : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewIterator)

  explicit LNewIterator(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewIterator* mir() const { return mir_->toNewIterator(); }
};

class LNewTypedArray : public LInstructionHelper<1, 0, 2> {
 public:
  LIR_HEADER(NewTypedArray)

  LNewTypedArray(const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp1);
    setTemp(1, temp2);
  }

  const LDefinition* temp1() { return getTemp(0); }

  const LDefinition* temp2() { return getTemp(1); }

  MNewTypedArray* mir() const { return mir_->toNewTypedArray(); }
};

class LNewTypedArrayDynamicLength : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(NewTypedArrayDynamicLength)

  LNewTypedArrayDynamicLength(const LAllocation& length,
                              const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, length);
    setTemp(0, temp);
  }

  const LAllocation* length() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }

  MNewTypedArrayDynamicLength* mir() const {
    return mir_->toNewTypedArrayDynamicLength();
  }
};

class LNewTypedArrayFromArray : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NewTypedArrayFromArray)

  explicit LNewTypedArrayFromArray(const LAllocation& array)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, array);
  }

  const LAllocation* array() { return getOperand(0); }

  MNewTypedArrayFromArray* mir() const {
    return mir_->toNewTypedArrayFromArray();
  }
};

class LNewTypedArrayFromArrayBuffer
    : public LCallInstructionHelper<1, 1 + 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(NewTypedArrayFromArrayBuffer)

  LNewTypedArrayFromArrayBuffer(const LAllocation& arrayBuffer,
                                const LBoxAllocation& byteOffset,
                                const LBoxAllocation& length)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, arrayBuffer);
    setBoxOperand(ByteOffsetIndex, byteOffset);
    setBoxOperand(LengthIndex, length);
  }

  static const size_t ByteOffsetIndex = 1;
  static const size_t LengthIndex = 1 + BOX_PIECES;

  const LAllocation* arrayBuffer() { return getOperand(0); }

  MNewTypedArrayFromArrayBuffer* mir() const {
    return mir_->toNewTypedArrayFromArrayBuffer();
  }
};

class LNewObject : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewObject)

  explicit LNewObject(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const char* extraName() const {
    return mir()->isVMCall() ? "VMCall" : nullptr;
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewObject* mir() const { return mir_->toNewObject(); }
};

// Allocates a new NamedLambdaObject.
//
// This instruction generates two possible instruction sets:
//   (1) An inline allocation of the call object is attempted.
//   (2) Otherwise, a callVM create a new object.
//
class LNewNamedLambdaObject : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewNamedLambdaObject);

  explicit LNewNamedLambdaObject(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewNamedLambdaObject* mir() const { return mir_->toNewNamedLambdaObject(); }
};

// Allocates a new CallObject.
//
// This instruction generates two possible instruction sets:
//   (1) If the call object is extensible, this is a callVM to create the
//       call object.
//   (2) Otherwise, an inline allocation of the call object is attempted.
//
class LNewCallObject : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(NewCallObject)

  explicit LNewCallObject(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MNewCallObject* mir() const { return mir_->toNewCallObject(); }
};

class LNewStringObject : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(NewStringObject)

  LNewStringObject(const LAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LAllocation* input() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  MNewStringObject* mir() const { return mir_->toNewStringObject(); }
};

class LInitElem : public LCallInstructionHelper<0, 1 + 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(InitElem)

  LInitElem(const LAllocation& object, const LBoxAllocation& id,
            const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, object);
    setBoxOperand(IdIndex, id);
    setBoxOperand(ValueIndex, value);
  }

  static const size_t IdIndex = 1;
  static const size_t ValueIndex = 1 + BOX_PIECES;

  const LAllocation* getObject() { return getOperand(0); }
  MInitElem* mir() const { return mir_->toInitElem(); }
};

class LInitElemGetterSetter
    : public LCallInstructionHelper<0, 2 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(InitElemGetterSetter)

  LInitElemGetterSetter(const LAllocation& object, const LBoxAllocation& id,
                        const LAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, value);
    setBoxOperand(IdIndex, id);
  }

  static const size_t IdIndex = 2;

  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  MInitElemGetterSetter* mir() const { return mir_->toInitElemGetterSetter(); }
};

// Takes in an Object and a Value.
class LMutateProto : public LCallInstructionHelper<0, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(MutateProto)

  LMutateProto(const LAllocation& object, const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, object);
    setBoxOperand(ValueIndex, value);
  }

  static const size_t ValueIndex = 1;

  const LAllocation* getObject() { return getOperand(0); }
  const LAllocation* getValue() { return getOperand(1); }
};

class LInitPropGetterSetter : public LCallInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(InitPropGetterSetter)

  LInitPropGetterSetter(const LAllocation& object, const LAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, value);
  }

  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }

  MInitPropGetterSetter* mir() const { return mir_->toInitPropGetterSetter(); }
};

class LCheckOverRecursed : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(CheckOverRecursed)

  LCheckOverRecursed() : LInstructionHelper(classOpcode) {}

  MCheckOverRecursed* mir() const { return mir_->toCheckOverRecursed(); }
};

class LWasmTrap : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(WasmTrap);

  LWasmTrap() : LInstructionHelper(classOpcode) {}

  const MWasmTrap* mir() const { return mir_->toWasmTrap(); }
};

template <size_t Defs, size_t Ops>
class LWasmReinterpretBase : public LInstructionHelper<Defs, Ops, 0> {
  typedef LInstructionHelper<Defs, Ops, 0> Base;

 protected:
  explicit LWasmReinterpretBase(LNode::Opcode opcode) : Base(opcode) {}

 public:
  const LAllocation* input() { return Base::getOperand(0); }
  MWasmReinterpret* mir() const { return Base::mir_->toWasmReinterpret(); }
};

class LWasmReinterpret : public LWasmReinterpretBase<1, 1> {
 public:
  LIR_HEADER(WasmReinterpret);
  explicit LWasmReinterpret(const LAllocation& input)
      : LWasmReinterpretBase(classOpcode) {
    setOperand(0, input);
  }
};

class LWasmReinterpretFromI64 : public LWasmReinterpretBase<1, INT64_PIECES> {
 public:
  LIR_HEADER(WasmReinterpretFromI64);
  explicit LWasmReinterpretFromI64(const LInt64Allocation& input)
      : LWasmReinterpretBase(classOpcode) {
    setInt64Operand(0, input);
  }
};

class LWasmReinterpretToI64 : public LWasmReinterpretBase<INT64_PIECES, 1> {
 public:
  LIR_HEADER(WasmReinterpretToI64);
  explicit LWasmReinterpretToI64(const LAllocation& input)
      : LWasmReinterpretBase(classOpcode) {
    setOperand(0, input);
  }
};

namespace details {
template <size_t Defs, size_t Ops, size_t Temps>
class RotateBase : public LInstructionHelper<Defs, Ops, Temps> {
  typedef LInstructionHelper<Defs, Ops, Temps> Base;

 protected:
  explicit RotateBase(LNode::Opcode opcode) : Base(opcode) {}

 public:
  MRotate* mir() { return Base::mir_->toRotate(); }
};
}  // namespace details

class LRotate : public details::RotateBase<1, 2, 0> {
 public:
  LIR_HEADER(Rotate);

  LRotate() : RotateBase(classOpcode) {}

  const LAllocation* input() { return getOperand(0); }
  LAllocation* count() { return getOperand(1); }
};

class LRotateI64
    : public details::RotateBase<INT64_PIECES, INT64_PIECES + 1, 1> {
 public:
  LIR_HEADER(RotateI64);

  LRotateI64() : RotateBase(classOpcode) {
    setTemp(0, LDefinition::BogusTemp());
  }

  static const size_t Input = 0;
  static const size_t Count = INT64_PIECES;

  const LInt64Allocation input() { return getInt64Operand(Input); }
  const LDefinition* temp() { return getTemp(0); }
  LAllocation* count() { return getOperand(Count); }
};

class LInterruptCheck : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(InterruptCheck)

  LInterruptCheck() : LInstructionHelper(classOpcode) {}
  MInterruptCheck* mir() const { return mir_->toInterruptCheck(); }
};

class LWasmInterruptCheck : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(WasmInterruptCheck)

  explicit LWasmInterruptCheck(const LAllocation& tlsData)
      : LInstructionHelper(classOpcode) {
    setOperand(0, tlsData);
  }
  MWasmInterruptCheck* mir() const { return mir_->toWasmInterruptCheck(); }
  const LAllocation* tlsPtr() { return getOperand(0); }
};

class LDefVar : public LCallInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(DefVar)

  explicit LDefVar(const LAllocation& envChain)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
  }

  const LAllocation* environmentChain() { return getOperand(0); }
  MDefVar* mir() const { return mir_->toDefVar(); }
};

class LDefLexical : public LCallInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(DefLexical)

  explicit LDefLexical(const LAllocation& envChain)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
  }

  const LAllocation* environmentChain() { return getOperand(0); }
  MDefLexical* mir() const { return mir_->toDefLexical(); }
};

class LDefFun : public LCallInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(DefFun)

  LDefFun(const LAllocation& fun, const LAllocation& envChain)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, fun);
    setOperand(1, envChain);
  }

  const LAllocation* fun() { return getOperand(0); }
  const LAllocation* environmentChain() { return getOperand(1); }
  MDefFun* mir() const { return mir_->toDefFun(); }
};

class LTypeOfV : public LInstructionHelper<1, BOX_PIECES, 1> {
 public:
  LIR_HEADER(TypeOfV)

  LTypeOfV(const LBoxAllocation& input, const LDefinition& tempToUnbox)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, tempToUnbox);
  }

  static const size_t Input = 0;

  const LDefinition* tempToUnbox() { return getTemp(0); }

  MTypeOf* mir() const { return mir_->toTypeOf(); }
};

class LToAsyncIter : public LCallInstructionHelper<1, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(ToAsyncIter)

  explicit LToAsyncIter(const LAllocation& iterator,
                        const LBoxAllocation& nextMethod)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, iterator);
    setBoxOperand(NextMethodIndex, nextMethod);
  }

  static const size_t NextMethodIndex = 1;

  const LAllocation* iterator() { return getOperand(0); }
};

class LToIdV : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 1> {
 public:
  LIR_HEADER(ToIdV)

  LToIdV(const LBoxAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, temp);
  }

  static const size_t Input = 0;

  MToId* mir() const { return mir_->toToId(); }

  const LDefinition* tempFloat() { return getTemp(0); }
};

// Allocate an object for |new| on the caller-side,
// when there is no templateObject or prototype known
class LCreateThis : public LCallInstructionHelper<BOX_PIECES, 2, 0> {
 public:
  LIR_HEADER(CreateThis)

  LCreateThis(const LAllocation& callee, const LAllocation& newTarget)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, callee);
    setOperand(1, newTarget);
  }

  const LAllocation* getCallee() { return getOperand(0); }
  const LAllocation* getNewTarget() { return getOperand(1); }

  MCreateThis* mir() const { return mir_->toCreateThis(); }
};

// Allocate an object for |new| on the caller-side,
// when the prototype is known.
class LCreateThisWithProto : public LCallInstructionHelper<1, 3, 0> {
 public:
  LIR_HEADER(CreateThisWithProto)

  LCreateThisWithProto(const LAllocation& callee, const LAllocation& newTarget,
                       const LAllocation& prototype)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, callee);
    setOperand(1, newTarget);
    setOperand(2, prototype);
  }

  const LAllocation* getCallee() { return getOperand(0); }
  const LAllocation* getNewTarget() { return getOperand(1); }
  const LAllocation* getPrototype() { return getOperand(2); }

  MCreateThis* mir() const { return mir_->toCreateThis(); }
};

// Allocate an object for |new| on the caller-side.
// Always performs object initialization with a fast path.
class LCreateThisWithTemplate : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(CreateThisWithTemplate)

  explicit LCreateThisWithTemplate(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  MCreateThisWithTemplate* mir() const {
    return mir_->toCreateThisWithTemplate();
  }

  const LDefinition* temp() { return getTemp(0); }
};

// Allocate a new arguments object for the frame.
class LCreateArgumentsObject : public LCallInstructionHelper<1, 1, 3> {
 public:
  LIR_HEADER(CreateArgumentsObject)

  LCreateArgumentsObject(const LAllocation& callObj, const LDefinition& temp0,
                         const LDefinition& temp1, const LDefinition& temp2)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, callObj);
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
  }

  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
  const LDefinition* temp2() { return getTemp(2); }

  const LAllocation* getCallObject() { return getOperand(0); }

  MCreateArgumentsObject* mir() const {
    return mir_->toCreateArgumentsObject();
  }
};

// Get argument from arguments object.
class LGetArgumentsObjectArg : public LInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(GetArgumentsObjectArg)

  LGetArgumentsObjectArg(const LAllocation& argsObj, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, argsObj);
    setTemp(0, temp);
  }

  const LAllocation* getArgsObject() { return getOperand(0); }

  MGetArgumentsObjectArg* mir() const {
    return mir_->toGetArgumentsObjectArg();
  }
};

// Set argument on arguments object.
class LSetArgumentsObjectArg : public LInstructionHelper<0, 1 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(SetArgumentsObjectArg)

  LSetArgumentsObjectArg(const LAllocation& argsObj,
                         const LBoxAllocation& value, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, argsObj);
    setBoxOperand(ValueIndex, value);
    setTemp(0, temp);
  }

  const LAllocation* getArgsObject() { return getOperand(0); }

  MSetArgumentsObjectArg* mir() const {
    return mir_->toSetArgumentsObjectArg();
  }

  static const size_t ValueIndex = 1;
};

// If the Value is an Object, return unbox(Value).
// Otherwise, return the other Object.
class LReturnFromCtor : public LInstructionHelper<1, BOX_PIECES + 1, 0> {
 public:
  LIR_HEADER(ReturnFromCtor)

  LReturnFromCtor(const LBoxAllocation& value, const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(ValueIndex, value);
    setOperand(ObjectIndex, object);
  }

  const LAllocation* getObject() { return getOperand(ObjectIndex); }

  static const size_t ValueIndex = 0;
  static const size_t ObjectIndex = BOX_PIECES;
};

class LComputeThis : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ComputeThis)

  static const size_t ValueIndex = 0;

  explicit LComputeThis(const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(ValueIndex, value);
  }

  const LDefinition* output() { return getDef(0); }

  MComputeThis* mir() const { return mir_->toComputeThis(); }
};

class LImplicitThis : public LCallInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(ImplicitThis)

  explicit LImplicitThis(const LAllocation& env)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, env);
  }

  const LAllocation* env() { return getOperand(0); }

  MImplicitThis* mir() const { return mir_->toImplicitThis(); }
};

// Writes a typed argument for a function call to the frame's argument vector.
class LStackArgT : public LInstructionHelper<0, 1, 0> {
  uint32_t argslot_;  // Index into frame-scope argument vector.
  MIRType type_;

 public:
  LIR_HEADER(StackArgT)

  LStackArgT(uint32_t argslot, MIRType type, const LAllocation& arg)
      : LInstructionHelper(classOpcode), argslot_(argslot), type_(type) {
    setOperand(0, arg);
  }
  uint32_t argslot() const { return argslot_; }
  MIRType type() const { return type_; }
  const LAllocation* getArgument() { return getOperand(0); }
};

// Writes an untyped argument for a function call to the frame's argument
// vector.
class LStackArgV : public LInstructionHelper<0, BOX_PIECES, 0> {
  uint32_t argslot_;  // Index into frame-scope argument vector.

 public:
  LIR_HEADER(StackArgV)

  LStackArgV(uint32_t argslot, const LBoxAllocation& value)
      : LInstructionHelper(classOpcode), argslot_(argslot) {
    setBoxOperand(0, value);
  }

  uint32_t argslot() const { return argslot_; }
};

// Common code for LIR descended from MCall.
template <size_t Defs, size_t Operands, size_t Temps>
class LJSCallInstructionHelper
    : public LCallInstructionHelper<Defs, Operands, Temps> {
 protected:
  explicit LJSCallInstructionHelper(LNode::Opcode opcode)
      : LCallInstructionHelper<Defs, Operands, Temps>(opcode) {}

 public:
  uint32_t argslot() const {
    if (JitStackValueAlignment > 1) {
      return AlignBytes(mir()->numStackArgs(), JitStackValueAlignment);
    }
    return mir()->numStackArgs();
  }
  MCall* mir() const { return this->mir_->toCall(); }

  bool hasSingleTarget() const { return getSingleTarget() != nullptr; }
  WrappedFunction* getSingleTarget() const { return mir()->getSingleTarget(); }

  // Does not include |this|.
  uint32_t numActualArgs() const { return mir()->numActualArgs(); }

  bool isConstructing() const { return mir()->isConstructing(); }
  bool ignoresReturnValue() const { return mir()->ignoresReturnValue(); }
};

// Generates a polymorphic callsite, wherein the function being called is
// unknown and anticipated to vary.
class LCallGeneric : public LJSCallInstructionHelper<BOX_PIECES, 1, 2> {
 public:
  LIR_HEADER(CallGeneric)

  LCallGeneric(const LAllocation& func, const LDefinition& nargsreg,
               const LDefinition& tmpobjreg)
      : LJSCallInstructionHelper(classOpcode) {
    setOperand(0, func);
    setTemp(0, nargsreg);
    setTemp(1, tmpobjreg);
  }

  const LAllocation* getFunction() { return getOperand(0); }
  const LDefinition* getNargsReg() { return getTemp(0); }
  const LDefinition* getTempObject() { return getTemp(1); }
};

// Generates a hardcoded callsite for a known, non-native target.
class LCallKnown : public LJSCallInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(CallKnown)

  LCallKnown(const LAllocation& func, const LDefinition& tmpobjreg)
      : LJSCallInstructionHelper(classOpcode) {
    setOperand(0, func);
    setTemp(0, tmpobjreg);
  }

  const LAllocation* getFunction() { return getOperand(0); }
  const LDefinition* getTempObject() { return getTemp(0); }
};

// Generates a hardcoded callsite for a known, native target.
class LCallNative : public LJSCallInstructionHelper<BOX_PIECES, 0, 4> {
 public:
  LIR_HEADER(CallNative)

  LCallNative(const LDefinition& argContext, const LDefinition& argUintN,
              const LDefinition& argVp, const LDefinition& tmpreg)
      : LJSCallInstructionHelper(classOpcode) {
    // Registers used for callWithABI().
    setTemp(0, argContext);
    setTemp(1, argUintN);
    setTemp(2, argVp);

    // Temporary registers.
    setTemp(3, tmpreg);
  }

  const LDefinition* getArgContextReg() { return getTemp(0); }
  const LDefinition* getArgUintNReg() { return getTemp(1); }
  const LDefinition* getArgVpReg() { return getTemp(2); }
  const LDefinition* getTempReg() { return getTemp(3); }
};

// Generates a hardcoded callsite for a known, DOM-native target.
class LCallDOMNative : public LJSCallInstructionHelper<BOX_PIECES, 0, 4> {
 public:
  LIR_HEADER(CallDOMNative)

  LCallDOMNative(const LDefinition& argJSContext, const LDefinition& argObj,
                 const LDefinition& argPrivate, const LDefinition& argArgs)
      : LJSCallInstructionHelper(classOpcode) {
    setTemp(0, argJSContext);
    setTemp(1, argObj);
    setTemp(2, argPrivate);
    setTemp(3, argArgs);
  }

  const LDefinition* getArgJSContext() { return getTemp(0); }
  const LDefinition* getArgObj() { return getTemp(1); }
  const LDefinition* getArgPrivate() { return getTemp(2); }
  const LDefinition* getArgArgs() { return getTemp(3); }
};

class LBail : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(Bail)

  LBail() : LInstructionHelper(classOpcode) {}
};

class LUnreachable : public LControlInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(Unreachable)

  LUnreachable() : LControlInstructionHelper(classOpcode) {}
};

class LEncodeSnapshot : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(EncodeSnapshot)

  LEncodeSnapshot() : LInstructionHelper(classOpcode) {}
};

template <size_t defs, size_t ops>
class LDOMPropertyInstructionHelper
    : public LCallInstructionHelper<defs, 1 + ops, 3> {
 protected:
  LDOMPropertyInstructionHelper(LNode::Opcode opcode,
                                const LDefinition& JSContextReg,
                                const LAllocation& ObjectReg,
                                const LDefinition& PrivReg,
                                const LDefinition& ValueReg)
      : LCallInstructionHelper<defs, 1 + ops, 3>(opcode) {
    this->setOperand(0, ObjectReg);
    this->setTemp(0, JSContextReg);
    this->setTemp(1, PrivReg);
    this->setTemp(2, ValueReg);
  }

 public:
  const LDefinition* getJSContextReg() { return this->getTemp(0); }
  const LAllocation* getObjectReg() { return this->getOperand(0); }
  const LDefinition* getPrivReg() { return this->getTemp(1); }
  const LDefinition* getValueReg() { return this->getTemp(2); }
};

class LGetDOMProperty : public LDOMPropertyInstructionHelper<BOX_PIECES, 0> {
 public:
  LIR_HEADER(GetDOMProperty)

  LGetDOMProperty(const LDefinition& JSContextReg, const LAllocation& ObjectReg,
                  const LDefinition& PrivReg, const LDefinition& ValueReg)
      : LDOMPropertyInstructionHelper<BOX_PIECES, 0>(
            classOpcode, JSContextReg, ObjectReg, PrivReg, ValueReg) {}

  MGetDOMProperty* mir() const { return mir_->toGetDOMProperty(); }
};

class LGetDOMMemberV : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(GetDOMMemberV);
  explicit LGetDOMMemberV(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }

  MGetDOMMember* mir() const { return mir_->toGetDOMMember(); }
};

class LGetDOMMemberT : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(GetDOMMemberT);
  explicit LGetDOMMemberT(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }

  MGetDOMMember* mir() const { return mir_->toGetDOMMember(); }
};

class LSetDOMProperty : public LDOMPropertyInstructionHelper<0, BOX_PIECES> {
 public:
  LIR_HEADER(SetDOMProperty)

  LSetDOMProperty(const LDefinition& JSContextReg, const LAllocation& ObjectReg,
                  const LBoxAllocation& value, const LDefinition& PrivReg,
                  const LDefinition& ValueReg)
      : LDOMPropertyInstructionHelper<0, BOX_PIECES>(
            classOpcode, JSContextReg, ObjectReg, PrivReg, ValueReg) {
    setBoxOperand(Value, value);
  }

  static const size_t Value = 1;

  MSetDOMProperty* mir() const { return mir_->toSetDOMProperty(); }
};

// Generates a polymorphic callsite, wherein the function being called is
// unknown and anticipated to vary.
class LApplyArgsGeneric
    : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES + 2, 2> {
 public:
  LIR_HEADER(ApplyArgsGeneric)

  LApplyArgsGeneric(const LAllocation& func, const LAllocation& argc,
                    const LBoxAllocation& thisv, const LDefinition& tmpobjreg,
                    const LDefinition& tmpcopy)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, func);
    setOperand(1, argc);
    setBoxOperand(ThisIndex, thisv);
    setTemp(0, tmpobjreg);
    setTemp(1, tmpcopy);
  }

  MApplyArgs* mir() const { return mir_->toApplyArgs(); }

  bool hasSingleTarget() const { return getSingleTarget() != nullptr; }
  WrappedFunction* getSingleTarget() const { return mir()->getSingleTarget(); }

  const LAllocation* getFunction() { return getOperand(0); }
  const LAllocation* getArgc() { return getOperand(1); }
  static const size_t ThisIndex = 2;

  const LDefinition* getTempObject() { return getTemp(0); }
  const LDefinition* getTempStackCounter() { return getTemp(1); }
};

class LApplyArrayGeneric
    : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES + 2, 2> {
 public:
  LIR_HEADER(ApplyArrayGeneric)

  LApplyArrayGeneric(const LAllocation& func, const LAllocation& elements,
                     const LBoxAllocation& thisv, const LDefinition& tmpobjreg,
                     const LDefinition& tmpcopy)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, func);
    setOperand(1, elements);
    setBoxOperand(ThisIndex, thisv);
    setTemp(0, tmpobjreg);
    setTemp(1, tmpcopy);
  }

  MApplyArray* mir() const { return mir_->toApplyArray(); }

  bool hasSingleTarget() const { return getSingleTarget() != nullptr; }
  WrappedFunction* getSingleTarget() const { return mir()->getSingleTarget(); }

  const LAllocation* getFunction() { return getOperand(0); }
  const LAllocation* getElements() { return getOperand(1); }
  // argc is mapped to the same register as elements: argc becomes
  // live as elements is dying, all registers are calltemps.
  const LAllocation* getArgc() { return getOperand(1); }
  static const size_t ThisIndex = 2;

  const LDefinition* getTempObject() { return getTemp(0); }
  const LDefinition* getTempStackCounter() { return getTemp(1); }
};

class LConstructArrayGeneric
    : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES + 3, 1> {
 public:
  LIR_HEADER(ConstructArrayGeneric)

  LConstructArrayGeneric(const LAllocation& func, const LAllocation& elements,
                         const LAllocation& newTarget,
                         const LBoxAllocation& thisv,
                         const LDefinition& tmpobjreg)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, func);
    setOperand(1, elements);
    setOperand(2, newTarget);
    setBoxOperand(ThisIndex, thisv);
    setTemp(0, tmpobjreg);
  }

  MConstructArray* mir() const { return mir_->toConstructArray(); }

  bool hasSingleTarget() const { return getSingleTarget() != nullptr; }
  WrappedFunction* getSingleTarget() const { return mir()->getSingleTarget(); }

  const LAllocation* getFunction() { return getOperand(0); }
  const LAllocation* getElements() { return getOperand(1); }
  const LAllocation* getNewTarget() { return getOperand(2); }

  static const size_t ThisIndex = 3;

  const LDefinition* getTempObject() { return getTemp(0); }

  // argc is mapped to the same register as elements: argc becomes
  // live as elements is dying, all registers are calltemps.
  const LAllocation* getArgc() { return getOperand(1); }

  // tempStackCounter is mapped to the same register as newTarget:
  // tempStackCounter becomes live as newTarget is dying, all registers are
  // calltemps.
  const LAllocation* getTempStackCounter() { return getOperand(2); }
};

class LGetDynamicName : public LCallInstructionHelper<BOX_PIECES, 2, 3> {
 public:
  LIR_HEADER(GetDynamicName)

  LGetDynamicName(const LAllocation& envChain, const LAllocation& name,
                  const LDefinition& temp1, const LDefinition& temp2,
                  const LDefinition& temp3)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setOperand(1, name);
    setTemp(0, temp1);
    setTemp(1, temp2);
    setTemp(2, temp3);
  }

  MGetDynamicName* mir() const { return mir_->toGetDynamicName(); }

  const LAllocation* getEnvironmentChain() { return getOperand(0); }
  const LAllocation* getName() { return getOperand(1); }

  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
  const LDefinition* temp3() { return getTemp(2); }
};

class LCallDirectEval
    : public LCallInstructionHelper<BOX_PIECES, 2 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallDirectEval)

  LCallDirectEval(const LAllocation& envChain, const LAllocation& string,
                  const LBoxAllocation& newTarget)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setOperand(1, string);
    setBoxOperand(NewTarget, newTarget);
  }

  static const size_t NewTarget = 2;

  MCallDirectEval* mir() const { return mir_->toCallDirectEval(); }

  const LAllocation* getEnvironmentChain() { return getOperand(0); }
  const LAllocation* getString() { return getOperand(1); }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestIAndBranch : public LControlInstructionHelper<2, 1, 0> {
 public:
  LIR_HEADER(TestIAndBranch)

  LTestIAndBranch(const LAllocation& in, MBasicBlock* ifTrue,
                  MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode) {
    setOperand(0, in);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

// Takes in an int64 input and tests it for truthiness.
class LTestI64AndBranch : public LControlInstructionHelper<2, INT64_PIECES, 0> {
 public:
  LIR_HEADER(TestI64AndBranch)

  LTestI64AndBranch(const LInt64Allocation& in, MBasicBlock* ifTrue,
                    MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode) {
    setInt64Operand(0, in);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestDAndBranch : public LControlInstructionHelper<2, 1, 0> {
 public:
  LIR_HEADER(TestDAndBranch)

  LTestDAndBranch(const LAllocation& in, MBasicBlock* ifTrue,
                  MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode) {
    setOperand(0, in);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestFAndBranch : public LControlInstructionHelper<2, 1, 0> {
 public:
  LIR_HEADER(TestFAndBranch)

  LTestFAndBranch(const LAllocation& in, MBasicBlock* ifTrue,
                  MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode) {
    setOperand(0, in);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

// Takes an object and tests it for truthiness.  An object is falsy iff it
// emulates |undefined|; see js::EmulatesUndefined.
class LTestOAndBranch : public LControlInstructionHelper<2, 1, 1> {
 public:
  LIR_HEADER(TestOAndBranch)

  LTestOAndBranch(const LAllocation& input, MBasicBlock* ifTruthy,
                  MBasicBlock* ifFalsy, const LDefinition& temp)
      : LControlInstructionHelper(classOpcode) {
    setOperand(0, input);
    setSuccessor(0, ifTruthy);
    setSuccessor(1, ifFalsy);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MBasicBlock* ifTruthy() { return getSuccessor(0); }
  MBasicBlock* ifFalsy() { return getSuccessor(1); }

  MTest* mir() { return mir_->toTest(); }
};

// Takes in a boxed value and tests it for truthiness.
class LTestVAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 3> {
 public:
  LIR_HEADER(TestVAndBranch)

  LTestVAndBranch(MBasicBlock* ifTruthy, MBasicBlock* ifFalsy,
                  const LBoxAllocation& input, const LDefinition& temp0,
                  const LDefinition& temp1, const LDefinition& temp2)
      : LControlInstructionHelper(classOpcode) {
    setSuccessor(0, ifTruthy);
    setSuccessor(1, ifFalsy);
    setBoxOperand(Input, input);
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
  }

  const char* extraName() const {
    return mir()->operandMightEmulateUndefined() ? "MightEmulateUndefined"
                                                 : nullptr;
  }

  static const size_t Input = 0;

  const LDefinition* tempFloat() { return getTemp(0); }

  const LDefinition* temp1() { return getTemp(1); }

  const LDefinition* temp2() { return getTemp(2); }

  MBasicBlock* ifTruthy() { return getSuccessor(0); }
  MBasicBlock* ifFalsy() { return getSuccessor(1); }

  MTest* mir() const { return mir_->toTest(); }
};

// Dispatches control flow to a successor based on incoming JSFunction*.
// Used to implemenent polymorphic inlining.
class LFunctionDispatch : public LInstructionHelper<0, 1, 0> {
  // Dispatch is performed based on a function -> block map
  // stored in the MIR.

 public:
  LIR_HEADER(FunctionDispatch);

  explicit LFunctionDispatch(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MFunctionDispatch* mir() const { return mir_->toFunctionDispatch(); }
};

class LObjectGroupDispatch : public LInstructionHelper<0, 1, 1> {
  // Dispatch is performed based on an ObjectGroup -> block
  // map inferred by the MIR.

 public:
  LIR_HEADER(ObjectGroupDispatch);

  const char* extraName() const {
    return mir()->hasFallback() ? "HasFallback" : "NoFallback";
  }

  LObjectGroupDispatch(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }

  MObjectGroupDispatch* mir() const { return mir_->toObjectGroupDispatch(); }
};

// Compares two integral values of the same JS type, either integer or object.
// For objects, both operands are in registers.
class LCompare : public LInstructionHelper<1, 2, 0> {
  JSOp jsop_;

 public:
  LIR_HEADER(Compare)
  LCompare(JSOp jsop, const LAllocation& left, const LAllocation& right)
      : LInstructionHelper(classOpcode), jsop_(jsop) {
    setOperand(0, left);
    setOperand(1, right);
  }

  JSOp jsop() const { return jsop_; }
  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MCompare* mir() { return mir_->toCompare(); }
  const char* extraName() const { return CodeName(jsop_); }
};

class LCompareI64 : public LInstructionHelper<1, 2 * INT64_PIECES, 0> {
  JSOp jsop_;

 public:
  LIR_HEADER(CompareI64)

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;

  LCompareI64(JSOp jsop, const LInt64Allocation& left,
              const LInt64Allocation& right)
      : LInstructionHelper(classOpcode), jsop_(jsop) {
    setInt64Operand(Lhs, left);
    setInt64Operand(Rhs, right);
  }

  JSOp jsop() const { return jsop_; }
  MCompare* mir() { return mir_->toCompare(); }
  const char* extraName() const { return CodeName(jsop_); }
};

class LCompareI64AndBranch
    : public LControlInstructionHelper<2, 2 * INT64_PIECES, 0> {
  MCompare* cmpMir_;
  JSOp jsop_;

 public:
  LIR_HEADER(CompareI64AndBranch)

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;

  LCompareI64AndBranch(MCompare* cmpMir, JSOp jsop,
                       const LInt64Allocation& left,
                       const LInt64Allocation& right, MBasicBlock* ifTrue,
                       MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir), jsop_(jsop) {
    setInt64Operand(Lhs, left);
    setInt64Operand(Rhs, right);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  JSOp jsop() const { return jsop_; }
  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
  const char* extraName() const { return CodeName(jsop_); }
};

// Compares two integral values of the same JS type, either integer or object.
// For objects, both operands are in registers.
class LCompareAndBranch : public LControlInstructionHelper<2, 2, 0> {
  MCompare* cmpMir_;
  JSOp jsop_;

 public:
  LIR_HEADER(CompareAndBranch)
  LCompareAndBranch(MCompare* cmpMir, JSOp jsop, const LAllocation& left,
                    const LAllocation& right, MBasicBlock* ifTrue,
                    MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir), jsop_(jsop) {
    setOperand(0, left);
    setOperand(1, right);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  JSOp jsop() const { return jsop_; }
  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
  const char* extraName() const { return CodeName(jsop_); }
};

class LCompareD : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(CompareD)
  LCompareD(const LAllocation& left, const LAllocation& right)
      : LInstructionHelper(classOpcode) {
    setOperand(0, left);
    setOperand(1, right);
  }

  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MCompare* mir() { return mir_->toCompare(); }
};

class LCompareF : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(CompareF)

  LCompareF(const LAllocation& left, const LAllocation& right)
      : LInstructionHelper(classOpcode) {
    setOperand(0, left);
    setOperand(1, right);
  }

  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MCompare* mir() { return mir_->toCompare(); }
};

class LCompareDAndBranch : public LControlInstructionHelper<2, 2, 0> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(CompareDAndBranch)

  LCompareDAndBranch(MCompare* cmpMir, const LAllocation& left,
                     const LAllocation& right, MBasicBlock* ifTrue,
                     MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setOperand(0, left);
    setOperand(1, right);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
};

class LCompareFAndBranch : public LControlInstructionHelper<2, 2, 0> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(CompareFAndBranch)
  LCompareFAndBranch(MCompare* cmpMir, const LAllocation& left,
                     const LAllocation& right, MBasicBlock* ifTrue,
                     MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setOperand(0, left);
    setOperand(1, right);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
};

class LCompareS : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(CompareS)

  LCompareS(const LAllocation& left, const LAllocation& right)
      : LInstructionHelper(classOpcode) {
    setOperand(0, left);
    setOperand(1, right);
  }

  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  MCompare* mir() { return mir_->toCompare(); }
};

// strict-equality between value and string.
class LCompareStrictS : public LInstructionHelper<1, BOX_PIECES + 1, 1> {
 public:
  LIR_HEADER(CompareStrictS)

  LCompareStrictS(const LBoxAllocation& lhs, const LAllocation& rhs,
                  const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Lhs, lhs);
    setOperand(BOX_PIECES, rhs);
    setTemp(0, temp);
  }

  static const size_t Lhs = 0;

  const LAllocation* right() { return getOperand(BOX_PIECES); }
  const LDefinition* tempToUnbox() { return getTemp(0); }
  MCompare* mir() { return mir_->toCompare(); }
};

// Used for strict-equality comparisons where one side is a boolean
// and the other is a value. Note that CompareI is used to compare
// two booleans.
class LCompareB : public LInstructionHelper<1, BOX_PIECES + 1, 0> {
 public:
  LIR_HEADER(CompareB)

  LCompareB(const LBoxAllocation& lhs, const LAllocation& rhs)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Lhs, lhs);
    setOperand(BOX_PIECES, rhs);
  }

  static const size_t Lhs = 0;

  const LAllocation* rhs() { return getOperand(BOX_PIECES); }

  MCompare* mir() { return mir_->toCompare(); }
};

class LCompareBAndBranch
    : public LControlInstructionHelper<2, BOX_PIECES + 1, 0> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(CompareBAndBranch)

  LCompareBAndBranch(MCompare* cmpMir, const LBoxAllocation& lhs,
                     const LAllocation& rhs, MBasicBlock* ifTrue,
                     MBasicBlock* ifFalse)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setBoxOperand(Lhs, lhs);
    setOperand(BOX_PIECES, rhs);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  static const size_t Lhs = 0;

  const LAllocation* rhs() { return getOperand(BOX_PIECES); }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
};

class LCompareBitwise : public LInstructionHelper<1, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CompareBitwise)

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;

  LCompareBitwise(const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
  }

  MCompare* mir() const { return mir_->toCompare(); }
};

class LCompareBitwiseAndBranch
    : public LControlInstructionHelper<2, 2 * BOX_PIECES, 0> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(CompareBitwiseAndBranch)

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;

  LCompareBitwiseAndBranch(MCompare* cmpMir, MBasicBlock* ifTrue,
                           MBasicBlock* ifFalse, const LBoxAllocation& lhs,
                           const LBoxAllocation& rhs)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
};

class LCompareVM : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CompareVM)

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;

  LCompareVM(const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
  }

  MCompare* mir() const { return mir_->toCompare(); }
};

class LBitAndAndBranch : public LControlInstructionHelper<2, 2, 0> {
  Assembler::Condition cond_;

 public:
  LIR_HEADER(BitAndAndBranch)
  LBitAndAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                   Assembler::Condition cond = Assembler::NonZero)
      : LControlInstructionHelper(classOpcode), cond_(cond) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  Assembler::Condition cond() const {
    MOZ_ASSERT(cond_ == Assembler::Zero || cond_ == Assembler::NonZero);
    return cond_;
  }
};

// Takes a value and tests whether it is null, undefined, or is an object that
// emulates |undefined|, as determined by the JSCLASS_EMULATES_UNDEFINED class
// flag on unwrapped objects.  See also js::EmulatesUndefined.
class LIsNullOrLikeUndefinedV : public LInstructionHelper<1, BOX_PIECES, 2> {
 public:
  LIR_HEADER(IsNullOrLikeUndefinedV)

  LIsNullOrLikeUndefinedV(const LBoxAllocation& value, const LDefinition& temp,
                          const LDefinition& tempToUnbox)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setTemp(0, temp);
    setTemp(1, tempToUnbox);
  }

  static const size_t Value = 0;

  MCompare* mir() { return mir_->toCompare(); }

  const LDefinition* temp() { return getTemp(0); }

  const LDefinition* tempToUnbox() { return getTemp(1); }
};

// Takes an object or object-or-null pointer and tests whether it is null or is
// an object that emulates |undefined|, as above.
class LIsNullOrLikeUndefinedT : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IsNullOrLikeUndefinedT)

  explicit LIsNullOrLikeUndefinedT(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  MCompare* mir() { return mir_->toCompare(); }
};

class LIsNullOrLikeUndefinedAndBranchV
    : public LControlInstructionHelper<2, BOX_PIECES, 2> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(IsNullOrLikeUndefinedAndBranchV)

  LIsNullOrLikeUndefinedAndBranchV(MCompare* cmpMir, MBasicBlock* ifTrue,
                                   MBasicBlock* ifFalse,
                                   const LBoxAllocation& value,
                                   const LDefinition& temp,
                                   const LDefinition& tempToUnbox)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setBoxOperand(Value, value);
    setTemp(0, temp);
    setTemp(1, tempToUnbox);
  }

  static const size_t Value = 0;

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* tempToUnbox() { return getTemp(1); }
};

class LIsNullOrLikeUndefinedAndBranchT
    : public LControlInstructionHelper<2, 1, 1> {
  MCompare* cmpMir_;

 public:
  LIR_HEADER(IsNullOrLikeUndefinedAndBranchT)

  LIsNullOrLikeUndefinedAndBranchT(MCompare* cmpMir, const LAllocation& input,
                                   MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                                   const LDefinition& temp)
      : LControlInstructionHelper(classOpcode), cmpMir_(cmpMir) {
    setOperand(0, input);
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setTemp(0, temp);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
  MTest* mir() const { return mir_->toTest(); }
  MCompare* cmpMir() const { return cmpMir_; }
  const LDefinition* temp() { return getTemp(0); }
};

class LSameValueD : public LInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(SameValueD)
  LSameValueD(const LAllocation& left, const LAllocation& right,
              const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, left);
    setOperand(1, right);
    setTemp(0, temp);
  }

  const LAllocation* left() { return getOperand(0); }
  const LAllocation* right() { return getOperand(1); }
  const LDefinition* tempFloat() { return getTemp(0); }
};

class LSameValueV : public LInstructionHelper<1, BOX_PIECES + 1, 2> {
 public:
  LIR_HEADER(SameValueV)

  static const size_t LhsInput = 0;

  LSameValueV(const LBoxAllocation& left, const LAllocation& right,
              const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, left);
    setOperand(BOX_PIECES, right);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }

  const LAllocation* right() { return getOperand(BOX_PIECES); }
  const LDefinition* tempFloat1() { return getTemp(0); }
  const LDefinition* tempFloat2() { return getTemp(1); }
};

class LSameValueVM : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(SameValueVM)

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;

  LSameValueVM(const LBoxAllocation& left, const LBoxAllocation& right)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, left);
    setBoxOperand(RhsInput, right);
  }
};

// Not operation on an integer.
class LNotI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NotI)

  explicit LNotI(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Not operation on an int64.
class LNotI64 : public LInstructionHelper<1, INT64_PIECES, 0> {
 public:
  LIR_HEADER(NotI64)

  explicit LNotI64(const LInt64Allocation& input)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, input);
  }
};

// Not operation on a double.
class LNotD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NotD)

  explicit LNotD(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  MNot* mir() { return mir_->toNot(); }
};

// Not operation on a float32.
class LNotF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NotF)

  explicit LNotF(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  MNot* mir() { return mir_->toNot(); }
};

// Boolean complement operation on an object.
class LNotO : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NotO)

  explicit LNotO(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  MNot* mir() { return mir_->toNot(); }
};

// Boolean complement operation on a value.
class LNotV : public LInstructionHelper<1, BOX_PIECES, 3> {
 public:
  LIR_HEADER(NotV)

  static const size_t Input = 0;
  LNotV(const LBoxAllocation& input, const LDefinition& temp0,
        const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
  }

  const LDefinition* tempFloat() { return getTemp(0); }

  const LDefinition* temp1() { return getTemp(1); }

  const LDefinition* temp2() { return getTemp(2); }

  MNot* mir() { return mir_->toNot(); }
};

// Bitwise not operation, takes a 32-bit integer as input and returning
// a 32-bit integer result as an output.
class LBitNotI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(BitNotI)

  LBitNotI() : LInstructionHelper(classOpcode) {}
};

// Binary bitwise operation, taking two 32-bit integers as inputs and returning
// a 32-bit integer result as an output.
class LBitOpI : public LInstructionHelper<1, 2, 0> {
  JSOp op_;

 public:
  LIR_HEADER(BitOpI)

  explicit LBitOpI(JSOp op) : LInstructionHelper(classOpcode), op_(op) {}

  const char* extraName() const {
    if (bitop() == JSOp::Ursh && mir_->toUrsh()->bailoutsDisabled()) {
      return "ursh:BailoutsDisabled";
    }
    return CodeName(op_);
  }

  JSOp bitop() const { return op_; }
};

class LBitOpI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0> {
  JSOp op_;

 public:
  LIR_HEADER(BitOpI64)

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;

  explicit LBitOpI64(JSOp op) : LInstructionHelper(classOpcode), op_(op) {}

  const char* extraName() const { return CodeName(op_); }

  JSOp bitop() const { return op_; }
};

// Shift operation, taking two 32-bit integers as inputs and returning
// a 32-bit integer result as an output.
class LShiftI : public LBinaryMath<0> {
  JSOp op_;

 public:
  LIR_HEADER(ShiftI)

  explicit LShiftI(JSOp op) : LBinaryMath(classOpcode), op_(op) {}

  JSOp bitop() { return op_; }

  MInstruction* mir() { return mir_->toInstruction(); }

  const char* extraName() const { return CodeName(op_); }
};

class LShiftI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES + 1, 0> {
  JSOp op_;

 public:
  LIR_HEADER(ShiftI64)

  explicit LShiftI64(JSOp op) : LInstructionHelper(classOpcode), op_(op) {}

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;

  JSOp bitop() { return op_; }

  MInstruction* mir() { return mir_->toInstruction(); }

  const char* extraName() const { return CodeName(op_); }
};

// Sign extension
class LSignExtendInt32 : public LInstructionHelper<1, 1, 0> {
  MSignExtendInt32::Mode mode_;

 public:
  LIR_HEADER(SignExtendInt32);

  explicit LSignExtendInt32(const LAllocation& num, MSignExtendInt32::Mode mode)
      : LInstructionHelper(classOpcode), mode_(mode) {
    setOperand(0, num);
  }

  MSignExtendInt32::Mode mode() { return mode_; }
};

class LSignExtendInt64
    : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 0> {
 public:
  LIR_HEADER(SignExtendInt64)

  explicit LSignExtendInt64(const LInt64Allocation& input)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, input);
  }

  const MSignExtendInt64* mir() const { return mir_->toSignExtendInt64(); }

  MSignExtendInt64::Mode mode() const { return mir()->mode(); }
};

class LUrshD : public LBinaryMath<1> {
 public:
  LIR_HEADER(UrshD)

  LUrshD(const LAllocation& lhs, const LAllocation& rhs,
         const LDefinition& temp)
      : LBinaryMath(classOpcode) {
    setOperand(0, lhs);
    setOperand(1, rhs);
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
};

// Returns from the function being compiled (not used in inlined frames). The
// input must be a box.
class LReturn : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(Return)

  LReturn() : LInstructionHelper(classOpcode) {}
};

class LThrow : public LCallInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(Throw)

  static const size_t Value = 0;

  explicit LThrow(const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
  }
};

class LMinMaxBase : public LInstructionHelper<1, 2, 0> {
 protected:
  LMinMaxBase(LNode::Opcode opcode, const LAllocation& first,
              const LAllocation& second)
      : LInstructionHelper(opcode) {
    setOperand(0, first);
    setOperand(1, second);
  }

 public:
  const LAllocation* first() { return this->getOperand(0); }
  const LAllocation* second() { return this->getOperand(1); }
  const LDefinition* output() { return this->getDef(0); }
  MMinMax* mir() const { return mir_->toMinMax(); }
  const char* extraName() const { return mir()->isMax() ? "Max" : "Min"; }
};

class LMinMaxI : public LMinMaxBase {
 public:
  LIR_HEADER(MinMaxI)
  LMinMaxI(const LAllocation& first, const LAllocation& second)
      : LMinMaxBase(classOpcode, first, second) {}
};

class LMinMaxD : public LMinMaxBase {
 public:
  LIR_HEADER(MinMaxD)
  LMinMaxD(const LAllocation& first, const LAllocation& second)
      : LMinMaxBase(classOpcode, first, second) {}
};

class LMinMaxF : public LMinMaxBase {
 public:
  LIR_HEADER(MinMaxF)
  LMinMaxF(const LAllocation& first, const LAllocation& second)
      : LMinMaxBase(classOpcode, first, second) {}
};

// Negative of an integer
class LNegI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NegI);
  explicit LNegI(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Negative of a double.
class LNegD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NegD)
  explicit LNegD(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Negative of a float32.
class LNegF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NegF)
  explicit LNegF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Absolute value of an integer.
class LAbsI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(AbsI)
  explicit LAbsI(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }

  MAbs* mir() const { return mir_->toAbs(); }
};

// Absolute value of a double.
class LAbsD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(AbsD)
  explicit LAbsD(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Absolute value of a float32.
class LAbsF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(AbsF)
  explicit LAbsF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Copysign for doubles.
class LCopySignD : public LInstructionHelper<1, 2, 2> {
 public:
  LIR_HEADER(CopySignD)
  explicit LCopySignD() : LInstructionHelper(classOpcode) {}
};

// Copysign for float32.
class LCopySignF : public LInstructionHelper<1, 2, 2> {
 public:
  LIR_HEADER(CopySignF)
  explicit LCopySignF() : LInstructionHelper(classOpcode) {}
};

// Count leading zeroes on an int32.
class LClzI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ClzI)
  explicit LClzI(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }

  MClz* mir() const { return mir_->toClz(); }
};

// Count leading zeroes on an int64.
class LClzI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 0> {
 public:
  LIR_HEADER(ClzI64)
  explicit LClzI64(const LInt64Allocation& num)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, num);
  }

  MClz* mir() const { return mir_->toClz(); }
};

// Count trailing zeroes on an int32.
class LCtzI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(CtzI)
  explicit LCtzI(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }

  MCtz* mir() const { return mir_->toCtz(); }
};

// Count trailing zeroes on an int64.
class LCtzI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 0> {
 public:
  LIR_HEADER(CtzI64)
  explicit LCtzI64(const LInt64Allocation& num)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, num);
  }

  MCtz* mir() const { return mir_->toCtz(); }
};

// Count population on an int32.
class LPopcntI : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(PopcntI)
  explicit LPopcntI(const LAllocation& num, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, num);
    setTemp(0, temp);
  }

  MPopcnt* mir() const { return mir_->toPopcnt(); }

  const LDefinition* temp() { return getTemp(0); }
};

// Count population on an int64.
class LPopcntI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 1> {
 public:
  LIR_HEADER(PopcntI64)
  explicit LPopcntI64(const LInt64Allocation& num, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, num);
    setTemp(0, temp);
  }

  MPopcnt* mir() const { return mir_->toPopcnt(); }
};

// Square root of a double.
class LSqrtD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(SqrtD)
  explicit LSqrtD(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Square root of a float32.
class LSqrtF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(SqrtF)
  explicit LSqrtF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

class LAtan2D : public LCallInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(Atan2D)
  LAtan2D(const LAllocation& y, const LAllocation& x, const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, y);
    setOperand(1, x);
    setTemp(0, temp);
  }

  const LAllocation* y() { return getOperand(0); }

  const LAllocation* x() { return getOperand(1); }

  const LDefinition* temp() { return getTemp(0); }

  const LDefinition* output() { return getDef(0); }
};

class LHypot : public LCallInstructionHelper<1, 4, 1> {
  uint32_t numOperands_;

 public:
  LIR_HEADER(Hypot)
  LHypot(const LAllocation& x, const LAllocation& y, const LDefinition& temp)
      : LCallInstructionHelper(classOpcode), numOperands_(2) {
    setOperand(0, x);
    setOperand(1, y);
    setTemp(0, temp);
  }

  LHypot(const LAllocation& x, const LAllocation& y, const LAllocation& z,
         const LDefinition& temp)
      : LCallInstructionHelper(classOpcode), numOperands_(3) {
    setOperand(0, x);
    setOperand(1, y);
    setOperand(2, z);
    setTemp(0, temp);
  }

  LHypot(const LAllocation& x, const LAllocation& y, const LAllocation& z,
         const LAllocation& w, const LDefinition& temp)
      : LCallInstructionHelper(classOpcode), numOperands_(4) {
    setOperand(0, x);
    setOperand(1, y);
    setOperand(2, z);
    setOperand(3, w);
    setTemp(0, temp);
  }

  uint32_t numArgs() const { return numOperands_; }

  const LAllocation* x() { return getOperand(0); }

  const LAllocation* y() { return getOperand(1); }

  const LDefinition* temp() { return getTemp(0); }

  const LDefinition* output() { return getDef(0); }
};

// Double raised to an integer power.
class LPowI : public LCallInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(PowI)
  LPowI(const LAllocation& value, const LAllocation& power,
        const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, value);
    setOperand(1, power);
    setTemp(0, temp);
  }

  const LAllocation* value() { return getOperand(0); }
  const LAllocation* power() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Double raised to a double power.
class LPowD : public LCallInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(PowD)
  LPowD(const LAllocation& value, const LAllocation& power,
        const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, value);
    setOperand(1, power);
    setTemp(0, temp);
  }

  const LAllocation* value() { return getOperand(0); }
  const LAllocation* power() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Sign value of an integer.
class LSignI : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(SignI)
  explicit LSignI(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Sign value of a double.
class LSignD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(SignD)
  explicit LSignD(const LAllocation& input) : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Sign value of a double with expected int32 result.
class LSignDI : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(SignDI)
  explicit LSignDI(const LAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
};

class LMathFunctionD : public LCallInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(MathFunctionD)
  LMathFunctionD(const LAllocation& input, const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
  MMathFunction* mir() const { return mir_->toMathFunction(); }
  const char* extraName() const {
    return MMathFunction::FunctionName(mir()->function());
  }
};

class LMathFunctionF : public LCallInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(MathFunctionF)
  LMathFunctionF(const LAllocation& input, const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
  MMathFunction* mir() const { return mir_->toMathFunction(); }
  const char* extraName() const {
    return MMathFunction::FunctionName(mir()->function());
  }
};

// Adds two integers, returning an integer value.
class LAddI : public LBinaryMath<0> {
  bool recoversInput_;

 public:
  LIR_HEADER(AddI)

  LAddI() : LBinaryMath(classOpcode), recoversInput_(false) {}

  const char* extraName() const {
    return snapshot() ? "OverflowCheck" : nullptr;
  }

  bool recoversInput() const { return recoversInput_; }
  void setRecoversInput() { recoversInput_ = true; }

  MAdd* mir() const { return mir_->toAdd(); }
};

class LAddI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0> {
 public:
  LIR_HEADER(AddI64)

  LAddI64() : LInstructionHelper(classOpcode) {}

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;
};

// Subtracts two integers, returning an integer value.
class LSubI : public LBinaryMath<0> {
  bool recoversInput_;

 public:
  LIR_HEADER(SubI)

  LSubI() : LBinaryMath(classOpcode), recoversInput_(false) {}

  const char* extraName() const {
    return snapshot() ? "OverflowCheck" : nullptr;
  }

  bool recoversInput() const { return recoversInput_; }
  void setRecoversInput() { recoversInput_ = true; }
  MSub* mir() const { return mir_->toSub(); }
};

inline bool LNode::recoversInput() const {
  switch (op()) {
    case Opcode::AddI:
      return toAddI()->recoversInput();
    case Opcode::SubI:
      return toSubI()->recoversInput();
    default:
      return false;
  }
}

class LSubI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0> {
 public:
  LIR_HEADER(SubI64)

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;

  LSubI64() : LInstructionHelper(classOpcode) {}
};

class LMulI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 1> {
 public:
  LIR_HEADER(MulI64)

  explicit LMulI64() : LInstructionHelper(classOpcode) {
    setTemp(0, LDefinition());
  }

  const LDefinition* temp() { return getTemp(0); }

  static const size_t Lhs = 0;
  static const size_t Rhs = INT64_PIECES;
};

// Performs an add, sub, mul, or div on two double values.
class LMathD : public LBinaryMath<0> {
  JSOp jsop_;

 public:
  LIR_HEADER(MathD)

  explicit LMathD(JSOp jsop) : LBinaryMath(classOpcode), jsop_(jsop) {}

  JSOp jsop() const { return jsop_; }

  const char* extraName() const { return CodeName(jsop_); }
};

// Performs an add, sub, mul, or div on two double values.
class LMathF : public LBinaryMath<0> {
  JSOp jsop_;

 public:
  LIR_HEADER(MathF)

  explicit LMathF(JSOp jsop) : LBinaryMath(classOpcode), jsop_(jsop) {}

  JSOp jsop() const { return jsop_; }

  const char* extraName() const { return CodeName(jsop_); }
};

class LModD : public LBinaryMath<1> {
 public:
  LIR_HEADER(ModD)

  LModD(const LAllocation& lhs, const LAllocation& rhs, const LDefinition& temp)
      : LBinaryMath(classOpcode) {
    setOperand(0, lhs);
    setOperand(1, rhs);
    setTemp(0, temp);
    setIsCall();
  }
  const LDefinition* temp() { return getTemp(0); }
  MMod* mir() const { return mir_->toMod(); }
};

// Adds two string, returning a string.
class LConcat : public LInstructionHelper<1, 2, 5> {
 public:
  LIR_HEADER(Concat)

  LConcat(const LAllocation& lhs, const LAllocation& rhs,
          const LDefinition& temp1, const LDefinition& temp2,
          const LDefinition& temp3, const LDefinition& temp4,
          const LDefinition& temp5)
      : LInstructionHelper(classOpcode) {
    setOperand(0, lhs);
    setOperand(1, rhs);
    setTemp(0, temp1);
    setTemp(1, temp2);
    setTemp(2, temp3);
    setTemp(3, temp4);
    setTemp(4, temp5);
  }

  const LAllocation* lhs() { return this->getOperand(0); }
  const LAllocation* rhs() { return this->getOperand(1); }
  const LDefinition* temp1() { return this->getTemp(0); }
  const LDefinition* temp2() { return this->getTemp(1); }
  const LDefinition* temp3() { return this->getTemp(2); }
  const LDefinition* temp4() { return this->getTemp(3); }
  const LDefinition* temp5() { return this->getTemp(4); }
};

// Get uint16 character code from a string.
class LCharCodeAt : public LInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(CharCodeAt)

  LCharCodeAt(const LAllocation& str, const LAllocation& index,
              const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, str);
    setOperand(1, index);
    setTemp(0, temp);
  }

  const LAllocation* str() { return this->getOperand(0); }
  const LAllocation* index() { return this->getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Convert uint16 character code to a string.
class LFromCharCode : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(FromCharCode)

  explicit LFromCharCode(const LAllocation& code)
      : LInstructionHelper(classOpcode) {
    setOperand(0, code);
  }

  const LAllocation* code() { return this->getOperand(0); }
};

// Convert uint32 code point to a string.
class LFromCodePoint : public LInstructionHelper<1, 1, 2> {
 public:
  LIR_HEADER(FromCodePoint)

  explicit LFromCodePoint(const LAllocation& codePoint,
                          const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, codePoint);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }

  const LAllocation* codePoint() { return this->getOperand(0); }

  const LDefinition* temp1() { return this->getTemp(0); }

  const LDefinition* temp2() { return this->getTemp(1); }
};

// Calls the ToLowerCase or ToUpperCase case conversion function.
class LStringConvertCase : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(StringConvertCase)

  explicit LStringConvertCase(const LAllocation& string)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, string);
  }

  const MStringConvertCase* mir() const { return mir_->toStringConvertCase(); }

  const LAllocation* string() { return this->getOperand(0); }
};

class LStringSplit : public LCallInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(StringSplit)

  LStringSplit(const LAllocation& string, const LAllocation& separator)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, string);
    setOperand(1, separator);
  }
  const LAllocation* string() { return getOperand(0); }
  const LAllocation* separator() { return getOperand(1); }
  const MStringSplit* mir() const { return mir_->toStringSplit(); }
};

class LSubstr : public LInstructionHelper<1, 3, 3> {
 public:
  LIR_HEADER(Substr)

  LSubstr(const LAllocation& string, const LAllocation& begin,
          const LAllocation& length, const LDefinition& temp,
          const LDefinition& temp2, const LDefinition& temp3)
      : LInstructionHelper(classOpcode) {
    setOperand(0, string);
    setOperand(1, begin);
    setOperand(2, length);
    setTemp(0, temp);
    setTemp(1, temp2);
    setTemp(2, temp3);
  }
  const LAllocation* string() { return getOperand(0); }
  const LAllocation* begin() { return getOperand(1); }
  const LAllocation* length() { return getOperand(2); }
  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
  const LDefinition* temp3() { return getTemp(2); }
  const MStringSplit* mir() const { return mir_->toStringSplit(); }
};

// Convert a 32-bit integer to a double.
class LInt32ToDouble : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Int32ToDouble)

  explicit LInt32ToDouble(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Convert a 32-bit float to a double.
class LFloat32ToDouble : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Float32ToDouble)

  explicit LFloat32ToDouble(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Convert a double to a 32-bit float.
class LDoubleToFloat32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(DoubleToFloat32)

  explicit LDoubleToFloat32(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Convert a 32-bit integer to a float32.
class LInt32ToFloat32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Int32ToFloat32)

  explicit LInt32ToFloat32(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }
};

// Convert a value to a double.
class LValueToDouble : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ValueToDouble)
  static const size_t Input = 0;

  explicit LValueToDouble(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MToDouble* mir() { return mir_->toToDouble(); }
};

// Convert a value to a float32.
class LValueToFloat32 : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ValueToFloat32)
  static const size_t Input = 0;

  explicit LValueToFloat32(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MToFloat32* mir() { return mir_->toToFloat32(); }
};

// Convert a value to an int32.
//   Input: components of a Value
//   Output: 32-bit integer
//   Bailout: undefined, string, object, or non-int32 double
//   Temps: one float register, one GP register
//
// This instruction requires a temporary float register.
class LValueToInt32 : public LInstructionHelper<1, BOX_PIECES, 2> {
 public:
  enum Mode { NORMAL, TRUNCATE, TRUNCATE_NOWRAP };

 private:
  Mode mode_;

 public:
  LIR_HEADER(ValueToInt32)

  LValueToInt32(const LBoxAllocation& input, const LDefinition& temp0,
                const LDefinition& temp1, Mode mode)
      : LInstructionHelper(classOpcode), mode_(mode) {
    setBoxOperand(Input, input);
    setTemp(0, temp0);
    setTemp(1, temp1);
  }

  const char* extraName() const {
    return mode() == NORMAL
               ? "Normal"
               : mode() == TRUNCATE ? "Truncate" : "TruncateNoWrap";
  }

  static const size_t Input = 0;

  Mode mode() const { return mode_; }
  const LDefinition* tempFloat() { return getTemp(0); }
  const LDefinition* temp() { return getTemp(1); }
  MToNumberInt32* mirNormal() const {
    MOZ_ASSERT(mode_ == NORMAL);
    return mir_->toToNumberInt32();
  }
  MTruncateToInt32* mirTruncate() const {
    MOZ_ASSERT(mode_ == TRUNCATE);
    return mir_->toTruncateToInt32();
  }
  MToIntegerInt32* mirTruncateNoWrap() const {
    MOZ_ASSERT(mode_ == TRUNCATE_NOWRAP);
    return mir_->toToIntegerInt32();
  }
  MInstruction* mir() const { return mir_->toInstruction(); }
};

// Convert a value to a BigInt.
class LValueToBigInt : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ValueToBigInt)
  static const size_t Input = 0;

  explicit LValueToBigInt(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MToBigInt* mir() const { return mir_->toToBigInt(); }
};

// Convert a double to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the double cannot be converted to an integer.
class LDoubleToInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(DoubleToInt32)

  explicit LDoubleToInt32(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MToNumberInt32* mir() const { return mir_->toToNumberInt32(); }
};

// Convert a float32 to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the float32 cannot be converted to an integer.
class LFloat32ToInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Float32ToInt32)

  explicit LFloat32ToInt32(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MToNumberInt32* mir() const { return mir_->toToNumberInt32(); }
};

// Truncates a double to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the double when converted to an integer exceeds the int32
//            bounds. No bailout for NaN or negative zero.
class LDoubleToIntegerInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(DoubleToIntegerInt32)

  explicit LDoubleToIntegerInt32(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MToIntegerInt32* mir() const { return mir_->toToIntegerInt32(); }
};

// Truncates a float to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the double when converted to an integer exceeds the int32
//            bounds. No bailout for NaN or negative zero.
class LFloat32ToIntegerInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Float32ToIntegerInt32)

  explicit LFloat32ToIntegerInt32(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MToIntegerInt32* mir() const { return mir_->toToIntegerInt32(); }
};

// Convert a double to a truncated int32.
//   Input: floating-point register
//   Output: 32-bit integer
class LTruncateDToInt32 : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(TruncateDToInt32)

  LTruncateDToInt32(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }

  const LDefinition* tempFloat() { return getTemp(0); }

  MTruncateToInt32* mir() const { return mir_->toTruncateToInt32(); }
};

// Convert a float32 to a truncated int32.
//   Input: floating-point register
//   Output: 32-bit integer
class LTruncateFToInt32 : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(TruncateFToInt32)

  LTruncateFToInt32(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }

  const LDefinition* tempFloat() { return getTemp(0); }

  MTruncateToInt32* mir() const { return mir_->toTruncateToInt32(); }
};

class LWasmTruncateToInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmTruncateToInt32)

  explicit LWasmTruncateToInt32(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }

  MWasmTruncateToInt32* mir() const { return mir_->toWasmTruncateToInt32(); }
};

class LWrapInt64ToInt32 : public LInstructionHelper<1, INT64_PIECES, 0> {
 public:
  LIR_HEADER(WrapInt64ToInt32)

  static const size_t Input = 0;

  explicit LWrapInt64ToInt32(const LInt64Allocation& input)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(Input, input);
  }

  const MWrapInt64ToInt32* mir() { return mir_->toWrapInt64ToInt32(); }
};

class LExtendInt32ToInt64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
 public:
  LIR_HEADER(ExtendInt32ToInt64)

  explicit LExtendInt32ToInt64(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const MExtendInt32ToInt64* mir() { return mir_->toExtendInt32ToInt64(); }
};

// Convert a boolean value to a string.
class LBooleanToString : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(BooleanToString)

  explicit LBooleanToString(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const MToString* mir() { return mir_->toToString(); }
};

// Convert an integer hosted on one definition to a string with a function call.
class LIntToString : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IntToString)

  explicit LIntToString(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const MToString* mir() { return mir_->toToString(); }
};

// Convert a double hosted on one definition to a string with a function call.
class LDoubleToString : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(DoubleToString)

  LDoubleToString(const LAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LDefinition* tempInt() { return getTemp(0); }
  const MToString* mir() { return mir_->toToString(); }
};

// Convert a primitive to a string with a function call.
class LValueToString : public LInstructionHelper<1, BOX_PIECES, 1> {
 public:
  LIR_HEADER(ValueToString)

  LValueToString(const LBoxAllocation& input, const LDefinition& tempToUnbox)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, tempToUnbox);
  }

  static const size_t Input = 0;

  const MToString* mir() { return mir_->toToString(); }

  const LDefinition* tempToUnbox() { return getTemp(0); }
};

// Convert a value to an object.
class LValueToObject : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ValueToObject)

  explicit LValueToObject(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;
};

// Convert a value to an object or null pointer.
class LValueToObjectOrNull : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ValueToObjectOrNull)

  explicit LValueToObjectOrNull(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;

  const MToObjectOrNull* mir() { return mir_->toToObjectOrNull(); }
};

// Double raised to a half power.
class LPowHalfD : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(PowHalfD);
  explicit LPowHalfD(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const LAllocation* input() { return getOperand(0); }
  const LDefinition* output() { return getDef(0); }
  MPowHalf* mir() const { return mir_->toPowHalf(); }
};

// No-op instruction that is used to hold the entry snapshot. This simplifies
// register allocation as it doesn't need to sniff the snapshot out of the
// LIRGraph.
class LStart : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(Start)

  LStart() : LInstructionHelper(classOpcode) {}
};

class LNaNToZero : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(NaNToZero)

  explicit LNaNToZero(const LAllocation& input, const LDefinition& tempDouble)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, tempDouble);
  }

  const MNaNToZero* mir() { return mir_->toNaNToZero(); }
  const LAllocation* input() { return getOperand(0); }
  const LDefinition* output() { return getDef(0); }
  const LDefinition* tempDouble() { return getTemp(0); }
};

// Passed the BaselineFrame address in the OsrFrameReg by SideCannon().
// Forwards this object to the LOsrValues for Value materialization.
class LOsrEntry : public LInstructionHelper<1, 0, 1> {
 protected:
  Label label_;
  uint32_t frameDepth_;

 public:
  LIR_HEADER(OsrEntry)

  explicit LOsrEntry(const LDefinition& temp)
      : LInstructionHelper(classOpcode), frameDepth_(0) {
    setTemp(0, temp);
  }

  void setFrameDepth(uint32_t depth) { frameDepth_ = depth; }
  uint32_t getFrameDepth() { return frameDepth_; }
  Label* label() { return &label_; }
  const LDefinition* temp() { return getTemp(0); }
};

// Materialize a Value stored in an interpreter frame for OSR.
class LOsrValue : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(OsrValue)

  explicit LOsrValue(const LAllocation& entry)
      : LInstructionHelper(classOpcode) {
    setOperand(0, entry);
  }

  const MOsrValue* mir() { return mir_->toOsrValue(); }
};

// Materialize a JSObject env chain stored in an interpreter frame for OSR.
class LOsrEnvironmentChain : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(OsrEnvironmentChain)

  explicit LOsrEnvironmentChain(const LAllocation& entry)
      : LInstructionHelper(classOpcode) {
    setOperand(0, entry);
  }

  const MOsrEnvironmentChain* mir() { return mir_->toOsrEnvironmentChain(); }
};

// Materialize a JSObject env chain stored in an interpreter frame for OSR.
class LOsrReturnValue : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(OsrReturnValue)

  explicit LOsrReturnValue(const LAllocation& entry)
      : LInstructionHelper(classOpcode) {
    setOperand(0, entry);
  }

  const MOsrReturnValue* mir() { return mir_->toOsrReturnValue(); }
};

// Materialize a JSObject ArgumentsObject stored in an interpreter frame for
// OSR.
class LOsrArgumentsObject : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(OsrArgumentsObject)

  explicit LOsrArgumentsObject(const LAllocation& entry)
      : LInstructionHelper(classOpcode) {
    setOperand(0, entry);
  }

  const MOsrArgumentsObject* mir() { return mir_->toOsrArgumentsObject(); }
};

class LRegExp : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(RegExp)

  explicit LRegExp(const LDefinition& temp) : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
  const MRegExp* mir() const { return mir_->toRegExp(); }
};

class LRegExpMatcher : public LCallInstructionHelper<BOX_PIECES, 3, 0> {
 public:
  LIR_HEADER(RegExpMatcher)

  LRegExpMatcher(const LAllocation& regexp, const LAllocation& string,
                 const LAllocation& lastIndex)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, regexp);
    setOperand(1, string);
    setOperand(2, lastIndex);
  }

  const LAllocation* regexp() { return getOperand(0); }
  const LAllocation* string() { return getOperand(1); }
  const LAllocation* lastIndex() { return getOperand(2); }

  const MRegExpMatcher* mir() const { return mir_->toRegExpMatcher(); }
};

class LRegExpSearcher : public LCallInstructionHelper<1, 3, 0> {
 public:
  LIR_HEADER(RegExpSearcher)

  LRegExpSearcher(const LAllocation& regexp, const LAllocation& string,
                  const LAllocation& lastIndex)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, regexp);
    setOperand(1, string);
    setOperand(2, lastIndex);
  }

  const LAllocation* regexp() { return getOperand(0); }
  const LAllocation* string() { return getOperand(1); }
  const LAllocation* lastIndex() { return getOperand(2); }

  const MRegExpSearcher* mir() const { return mir_->toRegExpSearcher(); }
};

class LRegExpTester : public LCallInstructionHelper<1, 3, 0> {
 public:
  LIR_HEADER(RegExpTester)

  LRegExpTester(const LAllocation& regexp, const LAllocation& string,
                const LAllocation& lastIndex)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, regexp);
    setOperand(1, string);
    setOperand(2, lastIndex);
  }

  const LAllocation* regexp() { return getOperand(0); }
  const LAllocation* string() { return getOperand(1); }
  const LAllocation* lastIndex() { return getOperand(2); }

  const MRegExpTester* mir() const { return mir_->toRegExpTester(); }
};

class LRegExpPrototypeOptimizable : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(RegExpPrototypeOptimizable);
  LRegExpPrototypeOptimizable(const LAllocation& object,
                              const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setTemp(0, temp);
  }

  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  MRegExpPrototypeOptimizable* mir() const {
    return mir_->toRegExpPrototypeOptimizable();
  }
};

class LRegExpInstanceOptimizable : public LInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(RegExpInstanceOptimizable);
  LRegExpInstanceOptimizable(const LAllocation& object,
                             const LAllocation& proto, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, proto);
    setTemp(0, temp);
  }

  const LAllocation* object() { return getOperand(0); }
  const LAllocation* proto() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
  MRegExpInstanceOptimizable* mir() const {
    return mir_->toRegExpInstanceOptimizable();
  }
};

class LGetFirstDollarIndex : public LInstructionHelper<1, 1, 3> {
 public:
  LIR_HEADER(GetFirstDollarIndex);
  LGetFirstDollarIndex(const LAllocation& str, const LDefinition& temp0,
                       const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, str);
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
  }

  const LAllocation* str() { return getOperand(0); }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
  const LDefinition* temp2() { return getTemp(2); }
};

class LStringReplace : public LCallInstructionHelper<1, 3, 0> {
 public:
  LIR_HEADER(StringReplace);

  LStringReplace(const LAllocation& string, const LAllocation& pattern,
                 const LAllocation& replacement)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, string);
    setOperand(1, pattern);
    setOperand(2, replacement);
  }

  const MStringReplace* mir() const { return mir_->toStringReplace(); }

  const LAllocation* string() { return getOperand(0); }
  const LAllocation* pattern() { return getOperand(1); }
  const LAllocation* replacement() { return getOperand(2); }
};

class LBinaryValueCache
    : public LInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 2> {
 public:
  LIR_HEADER(BinaryValueCache)

  // Takes two temps: these are intendend to be FloatReg0 and FloatReg1
  // To allow the actual cache code to safely clobber those values without
  // save and restore.
  LBinaryValueCache(const LBoxAllocation& lhs, const LBoxAllocation& rhs,
                    const LDefinition& temp0, const LDefinition& temp1)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
    setTemp(0, temp0);
    setTemp(1, temp1);
  }

  const MBinaryCache* mir() const { return mir_->toBinaryCache(); }

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;
};

class LBinaryBoolCache : public LInstructionHelper<1, 2 * BOX_PIECES, 2> {
 public:
  LIR_HEADER(BinaryBoolCache)

  // Takes two temps: these are intendend to be FloatReg0 and FloatReg1
  // To allow the actual cache code to safely clobber those values without
  // save and restore.
  LBinaryBoolCache(const LBoxAllocation& lhs, const LBoxAllocation& rhs,
                   const LDefinition& temp0, const LDefinition& temp1)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
    setTemp(0, temp0);
    setTemp(1, temp1);
  }

  const MBinaryCache* mir() const { return mir_->toBinaryCache(); }

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;
};

class LUnaryCache : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 0> {
 public:
  LIR_HEADER(UnaryCache)

  explicit LUnaryCache(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  const MUnaryCache* mir() const { return mir_->toUnaryCache(); }

  const LAllocation* input() { return getOperand(Input); }

  static const size_t Input = 0;
};

class LClassConstructor : public LCallInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(ClassConstructor)

  const MClassConstructor* mir() const { return mir_->toClassConstructor(); }

  LClassConstructor() : LCallInstructionHelper(classOpcode) {}
};

class LDerivedClassConstructor : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(DerivedClassConstructor)

  explicit LDerivedClassConstructor(const LAllocation& prototype)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, prototype);
  }

  const LAllocation* prototype() { return getOperand(0); }

  const MDerivedClassConstructor* mir() const {
    return mir_->toDerivedClassConstructor();
  }
};

class LModuleMetadata : public LCallInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(ModuleMetadata)

  const MModuleMetadata* mir() const { return mir_->toModuleMetadata(); }

  LModuleMetadata() : LCallInstructionHelper(classOpcode) {}
};

class LDynamicImport : public LCallInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(DynamicImport)

  static const size_t SpecifierIndex = 0;

  explicit LDynamicImport(const LBoxAllocation& specifier)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(SpecifierIndex, specifier);
  }

  const MDynamicImport* mir() const { return mir_->toDynamicImport(); }
};

class LLambdaForSingleton : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(LambdaForSingleton)

  explicit LLambdaForSingleton(const LAllocation& envChain)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const MLambda* mir() const { return mir_->toLambda(); }
};

class LLambda : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(Lambda)

  LLambda(const LAllocation& envChain, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setTemp(0, temp);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MLambda* mir() const { return mir_->toLambda(); }
};

class LLambdaArrow : public LInstructionHelper<1, 1 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(LambdaArrow)

  static const size_t NewTargetValue = 1;

  LLambdaArrow(const LAllocation& envChain, const LBoxAllocation& newTarget,
               const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setBoxOperand(NewTargetValue, newTarget);
    setTemp(0, temp);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MLambdaArrow* mir() const { return mir_->toLambdaArrow(); }
};

class LFunctionWithProto : public LCallInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(FunctionWithProto)

  LFunctionWithProto(const LAllocation& envChain, const LAllocation& prototype)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setOperand(1, prototype);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const LAllocation* prototype() { return getOperand(1); }
  const MFunctionWithProto* mir() const { return mir_->toFunctionWithProto(); }
};

class LSetFunName : public LCallInstructionHelper<1, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(SetFunName)

  static const size_t NameValue = 1;

  LSetFunName(const LAllocation& fun, const LBoxAllocation& name)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, fun);
    setBoxOperand(NameValue, name);
  }
  const LAllocation* fun() { return getOperand(0); }
  const MSetFunName* mir() const { return mir_->toSetFunName(); }
};

class LKeepAliveObject : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(KeepAliveObject)

  explicit LKeepAliveObject(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }
};

// Load the "slots" member out of a JSObject.
//   Input: JSObject pointer
//   Output: slots pointer
class LSlots : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Slots)

  explicit LSlots(const LAllocation& object) : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }
};

// Load the "elements" member out of a JSObject.
//   Input: JSObject pointer
//   Output: elements pointer
class LElements : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Elements)

  explicit LElements(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }

  const MElements* mir() const { return mir_->toElements(); }
};

// If necessary, convert any int32 elements in a vector into doubles.
class LConvertElementsToDoubles : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(ConvertElementsToDoubles)

  explicit LConvertElementsToDoubles(const LAllocation& elements)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
  }

  const LAllocation* elements() { return getOperand(0); }
};

// If |elements| has the CONVERT_DOUBLE_ELEMENTS flag, convert int32 value to
// double. Else return the original value.
class LMaybeToDoubleElement : public LInstructionHelper<BOX_PIECES, 2, 1> {
 public:
  LIR_HEADER(MaybeToDoubleElement)

  LMaybeToDoubleElement(const LAllocation& elements, const LAllocation& value,
                        const LDefinition& tempFloat)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, value);
    setTemp(0, tempFloat);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* tempFloat() { return getTemp(0); }
};

// If necessary, copy the elements in an object so they may be written to.
class LMaybeCopyElementsForWrite : public LInstructionHelper<0, 1, 1> {
 public:
  LIR_HEADER(MaybeCopyElementsForWrite)

  explicit LMaybeCopyElementsForWrite(const LAllocation& obj,
                                      const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setTemp(0, temp);
  }

  const LAllocation* object() { return getOperand(0); }

  const LDefinition* temp() { return getTemp(0); }

  const MMaybeCopyElementsForWrite* mir() const {
    return mir_->toMaybeCopyElementsForWrite();
  }
};

// Load the initialized length from an elements header.
class LInitializedLength : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(InitializedLength)

  explicit LInitializedLength(const LAllocation& elements)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
  }

  const LAllocation* elements() { return getOperand(0); }
};

// Store to the initialized length in an elements header. Note the input is an
// *index*, one less than the desired initialized length.
class LSetInitializedLength : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(SetInitializedLength)

  LSetInitializedLength(const LAllocation& elements, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

// Load the length from an elements header.
class LArrayLength : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ArrayLength)

  explicit LArrayLength(const LAllocation& elements)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
  }

  const LAllocation* elements() { return getOperand(0); }
};

// Store to the length in an elements header. Note the input is an *index*,
// one less than the desired length.
class LSetArrayLength : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(SetArrayLength)

  LSetArrayLength(const LAllocation& elements, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

class LGetNextEntryForIterator : public LInstructionHelper<1, 2, 3> {
 public:
  LIR_HEADER(GetNextEntryForIterator)

  explicit LGetNextEntryForIterator(const LAllocation& iter,
                                    const LAllocation& result,
                                    const LDefinition& temp0,
                                    const LDefinition& temp1,
                                    const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, iter);
    setOperand(1, result);
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
  }

  const MGetNextEntryForIterator* mir() const {
    return mir_->toGetNextEntryForIterator();
  }
  const LAllocation* iter() { return getOperand(0); }
  const LAllocation* result() { return getOperand(1); }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
  const LDefinition* temp2() { return getTemp(2); }
};

// Read the length of an array buffer view.
class LArrayBufferViewLength : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ArrayBufferViewLength)

  explicit LArrayBufferViewLength(const LAllocation& obj)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
  }

  const LAllocation* object() { return getOperand(0); }
};

// Read the byteOffset of an array buffer view.
class LArrayBufferViewByteOffset : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ArrayBufferViewByteOffset)

  explicit LArrayBufferViewByteOffset(const LAllocation& obj)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
  }

  const LAllocation* object() { return getOperand(0); }
};

// Load an array buffer view's elements vector.
class LArrayBufferViewElements : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ArrayBufferViewElements)

  explicit LArrayBufferViewElements(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
  const LAllocation* object() { return getOperand(0); }
};

// Return the element shift of a typed array.
class LTypedArrayElementShift : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(TypedArrayElementShift)

  explicit LTypedArrayElementShift(const LAllocation& obj)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
  }

  const LAllocation* object() { return getOperand(0); }
};

// Double to Int32, eligible for accessing into a TypedArray. If the index isn't
// exactly representable as an Int32, produce any Int32 which is equivalent to
// an OOB access into a TypedArray.
class LTypedArrayIndexToInt32 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(TypedArrayIndexToInt32)

  explicit LTypedArrayIndexToInt32(const LAllocation& obj)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
  }

  const LAllocation* index() { return getOperand(0); }
  const MTypedArrayIndexToInt32* mir() const {
    return mir_->toTypedArrayIndexToInt32();
  }
};

// Bailout if index >= length.
class LBoundsCheck : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(BoundsCheck)

  LBoundsCheck(const LAllocation& index, const LAllocation& length)
      : LInstructionHelper(classOpcode) {
    setOperand(0, index);
    setOperand(1, length);
  }
  const MBoundsCheck* mir() const { return mir_->toBoundsCheck(); }
  const LAllocation* index() { return getOperand(0); }
  const LAllocation* length() { return getOperand(1); }
};

// Bailout if index + minimum < 0 or index + maximum >= length.
class LBoundsCheckRange : public LInstructionHelper<0, 2, 1> {
 public:
  LIR_HEADER(BoundsCheckRange)

  LBoundsCheckRange(const LAllocation& index, const LAllocation& length,
                    const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, index);
    setOperand(1, length);
    setTemp(0, temp);
  }
  const MBoundsCheck* mir() const { return mir_->toBoundsCheck(); }
  const LAllocation* index() { return getOperand(0); }
  const LAllocation* length() { return getOperand(1); }
};

// Bailout if index < minimum.
class LBoundsCheckLower : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(BoundsCheckLower)

  explicit LBoundsCheckLower(const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, index);
  }
  MBoundsCheckLower* mir() const { return mir_->toBoundsCheckLower(); }
  const LAllocation* index() { return getOperand(0); }
};

class LSpectreMaskIndex : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(SpectreMaskIndex)

  LSpectreMaskIndex(const LAllocation& index, const LAllocation& length)
      : LInstructionHelper(classOpcode) {
    setOperand(0, index);
    setOperand(1, length);
  }
  const LAllocation* index() { return getOperand(0); }
  const LAllocation* length() { return getOperand(1); }
};

// Load a value from a dense array's elements vector. Bail out if it's the hole
// value.
class LLoadElementV : public LInstructionHelper<BOX_PIECES, 2, 0> {
 public:
  LIR_HEADER(LoadElementV)

  LLoadElementV(const LAllocation& elements, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
  }

  const char* extraName() const {
    return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
  }

  const MLoadElement* mir() const { return mir_->toLoadElement(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

class LInArray : public LInstructionHelper<1, 4, 0> {
 public:
  LIR_HEADER(InArray)

  LInArray(const LAllocation& elements, const LAllocation& index,
           const LAllocation& initLength, const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, initLength);
    setOperand(3, object);
  }
  const MInArray* mir() const { return mir_->toInArray(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* initLength() { return getOperand(2); }
  const LAllocation* object() { return getOperand(3); }
};

// Load a value from an array's elements vector, loading |undefined| if we hit a
// hole. Bail out if we get a negative index.
class LLoadElementHole : public LInstructionHelper<BOX_PIECES, 3, 0> {
 public:
  LIR_HEADER(LoadElementHole)

  LLoadElementHole(const LAllocation& elements, const LAllocation& index,
                   const LAllocation& initLength)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, initLength);
  }

  const char* extraName() const {
    return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
  }

  const MLoadElementHole* mir() const { return mir_->toLoadElementHole(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* initLength() { return getOperand(2); }
};

// Load a typed value from a dense array's elements vector. The array must be
// known to be packed, so that we don't have to check for the hole value.
// This instruction does not load the type tag and can directly load into a
// FP register.
class LLoadElementT : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(LoadElementT)

  LLoadElementT(const LAllocation& elements, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
  }

  const char* extraName() const {
    return mir()->needsHoleCheck()
               ? "HoleCheck"
               : (mir()->loadDoubles() ? "Doubles" : nullptr);
  }

  const MLoadElement* mir() const { return mir_->toLoadElement(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

class LUnboxObjectOrNull : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(UnboxObjectOrNull);

  explicit LUnboxObjectOrNull(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  MUnbox* mir() const { return mir_->toUnbox(); }
  const LAllocation* input() { return getOperand(0); }
};

// Load an element from a non-allocated entity represented by its state object
// such as ArgumentState. The elements of the state object are set as operands
// of this variadic LIR instruction and inlined in the code generated for this
// instruction.
//
// Each element is represented with BOX_PIECES allocations, even if 1 (typed
// register) or 0 (constants) is enough. In such case, the unused allocations
// would be bogus.
class LLoadElementFromStateV : public LVariadicInstruction<BOX_PIECES, 3> {
 public:
  LIR_HEADER(LoadElementFromStateV)

  LLoadElementFromStateV(uint32_t numOperands, const LDefinition& temp0,
                         const LDefinition& temp1, const LDefinition& tempD)
      : LVariadicInstruction<BOX_PIECES, 3>(classOpcode, numOperands) {
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, tempD);
  }

  const MLoadElementFromState* mir() const {
    return mir_->toLoadElementFromState();
  }
  const LAllocation* index() { return getOperand(0); }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
  const LDefinition* tempD() { return getTemp(2); }
  MDefinition* array() { return mir()->array(); }
};

// Store a boxed value to a dense array's element vector.
class LStoreElementV : public LInstructionHelper<0, 2 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(StoreElementV)

  LStoreElementV(const LAllocation& elements, const LAllocation& index,
                 const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setBoxOperand(Value, value);
  }

  const char* extraName() const {
    return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
  }

  static const size_t Value = 2;

  const MStoreElement* mir() const { return mir_->toStoreElement(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

// Store a typed value to a dense array's elements vector. Compared to
// LStoreElementV, this instruction can store doubles and constants directly,
// and does not store the type tag if the array is monomorphic and known to
// be packed.
class LStoreElementT : public LInstructionHelper<0, 3, 0> {
 public:
  LIR_HEADER(StoreElementT)

  LStoreElementT(const LAllocation& elements, const LAllocation& index,
                 const LAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
  }

  const char* extraName() const {
    return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
  }

  const MStoreElement* mir() const { return mir_->toStoreElement(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
};

// Like LStoreElementV, but supports indexes >= initialized length.
class LStoreElementHoleV : public LInstructionHelper<0, 3 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(StoreElementHoleV)

  LStoreElementHoleV(const LAllocation& object, const LAllocation& elements,
                     const LAllocation& index, const LBoxAllocation& value,
                     const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, elements);
    setOperand(2, index);
    setBoxOperand(Value, value);
    setTemp(0, spectreTemp);
  }

  static const size_t Value = 3;

  const MStoreElementHole* mir() const { return mir_->toStoreElementHole(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* elements() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LDefinition* spectreTemp() { return getTemp(0); }
};

// Like LStoreElementT, but supports indexes >= initialized length.
class LStoreElementHoleT : public LInstructionHelper<0, 4, 1> {
 public:
  LIR_HEADER(StoreElementHoleT)

  LStoreElementHoleT(const LAllocation& object, const LAllocation& elements,
                     const LAllocation& index, const LAllocation& value,
                     const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, elements);
    setOperand(2, index);
    setOperand(3, value);
    setTemp(0, spectreTemp);
  }

  const MStoreElementHole* mir() const { return mir_->toStoreElementHole(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* elements() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LAllocation* value() { return getOperand(3); }
  const LDefinition* spectreTemp() { return getTemp(0); }
};

// Like LStoreElementV, but can just ignore assignment (for eg. frozen objects)
class LFallibleStoreElementV : public LInstructionHelper<0, 3 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(FallibleStoreElementV)

  LFallibleStoreElementV(const LAllocation& object, const LAllocation& elements,
                         const LAllocation& index, const LBoxAllocation& value,
                         const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, elements);
    setOperand(2, index);
    setBoxOperand(Value, value);
    setTemp(0, spectreTemp);
  }

  static const size_t Value = 3;

  const MFallibleStoreElement* mir() const {
    return mir_->toFallibleStoreElement();
  }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* elements() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LDefinition* spectreTemp() { return getTemp(0); }
};

// Like LStoreElementT, but can just ignore assignment (for eg. frozen objects)
class LFallibleStoreElementT : public LInstructionHelper<0, 4, 1> {
 public:
  LIR_HEADER(FallibleStoreElementT)

  LFallibleStoreElementT(const LAllocation& object, const LAllocation& elements,
                         const LAllocation& index, const LAllocation& value,
                         const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, elements);
    setOperand(2, index);
    setOperand(3, value);
    setTemp(0, spectreTemp);
  }

  const MFallibleStoreElement* mir() const {
    return mir_->toFallibleStoreElement();
  }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* elements() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LAllocation* value() { return getOperand(3); }
  const LDefinition* spectreTemp() { return getTemp(0); }
};

class LArrayPopShiftV : public LInstructionHelper<BOX_PIECES, 1, 2> {
 public:
  LIR_HEADER(ArrayPopShiftV)

  LArrayPopShiftV(const LAllocation& object, const LDefinition& temp0,
                  const LDefinition& temp1)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setTemp(0, temp0);
    setTemp(1, temp1);
  }

  const char* extraName() const {
    return mir()->mode() == MArrayPopShift::Pop ? "Pop" : "Shift";
  }

  const MArrayPopShift* mir() const { return mir_->toArrayPopShift(); }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
};

class LArrayPopShiftT : public LInstructionHelper<1, 1, 2> {
 public:
  LIR_HEADER(ArrayPopShiftT)

  LArrayPopShiftT(const LAllocation& object, const LDefinition& temp0,
                  const LDefinition& temp1)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setTemp(0, temp0);
    setTemp(1, temp1);
  }

  const char* extraName() const {
    return mir()->mode() == MArrayPopShift::Pop ? "Pop" : "Shift";
  }

  const MArrayPopShift* mir() const { return mir_->toArrayPopShift(); }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
};

class LArrayPushV : public LInstructionHelper<1, 1 + BOX_PIECES, 2> {
 public:
  LIR_HEADER(ArrayPushV)

  LArrayPushV(const LAllocation& object, const LBoxAllocation& value,
              const LDefinition& temp, const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setBoxOperand(Value, value);
    setTemp(0, temp);
    setTemp(1, spectreTemp);
  }

  static const size_t Value = 1;

  const MArrayPush* mir() const { return mir_->toArrayPush(); }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* spectreTemp() { return getTemp(1); }
};

class LArrayPushT : public LInstructionHelper<1, 2, 2> {
 public:
  LIR_HEADER(ArrayPushT)

  LArrayPushT(const LAllocation& object, const LAllocation& value,
              const LDefinition& temp, const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, value);
    setTemp(0, temp);
    setTemp(1, spectreTemp);
  }

  const MArrayPush* mir() const { return mir_->toArrayPush(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* spectreTemp() { return getTemp(1); }
};

class LArraySlice : public LCallInstructionHelper<1, 3, 2> {
 public:
  LIR_HEADER(ArraySlice)

  LArraySlice(const LAllocation& obj, const LAllocation& begin,
              const LAllocation& end, const LDefinition& temp1,
              const LDefinition& temp2)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, begin);
    setOperand(2, end);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }
  const MArraySlice* mir() const { return mir_->toArraySlice(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* begin() { return getOperand(1); }
  const LAllocation* end() { return getOperand(2); }
  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
};

class LArrayJoin : public LCallInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(ArrayJoin)

  LArrayJoin(const LAllocation& array, const LAllocation& sep,
             const LDefinition& temp)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, array);
    setOperand(1, sep);
    setTemp(0, temp);
  }

  const MArrayJoin* mir() const { return mir_->toArrayJoin(); }
  const LDefinition* output() { return getDef(0); }
  const LAllocation* array() { return getOperand(0); }
  const LAllocation* separator() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

class LLoadUnboxedScalar : public LInstructionHelper<1, 2, 1> {
 public:
  LIR_HEADER(LoadUnboxedScalar)

  LLoadUnboxedScalar(const LAllocation& elements, const LAllocation& index,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setTemp(0, temp);
  }
  const MLoadUnboxedScalar* mir() const { return mir_->toLoadUnboxedScalar(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

class LLoadUnboxedBigInt : public LInstructionHelper<1, 2, 1 + INT64_PIECES> {
 public:
  LIR_HEADER(LoadUnboxedBigInt)

  LLoadUnboxedBigInt(const LAllocation& elements, const LAllocation& index,
                     const LDefinition& temp, const LInt64Definition& temp64)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setTemp(0, temp);
    setInt64Temp(1, temp64);
  }
  const MLoadUnboxedScalar* mir() const { return mir_->toLoadUnboxedScalar(); }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
  const LInt64Definition temp64() { return getInt64Temp(1); }
};

class LLoadDataViewElement : public LInstructionHelper<1, 3, 1 + INT64_PIECES> {
 public:
  LIR_HEADER(LoadDataViewElement)

  LLoadDataViewElement(const LAllocation& elements, const LAllocation& index,
                       const LAllocation& littleEndian, const LDefinition& temp,
                       const LInt64Definition& temp64)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, littleEndian);
    setTemp(0, temp);
    setInt64Temp(1, temp64);
  }
  const MLoadDataViewElement* mir() const {
    return mir_->toLoadDataViewElement();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* littleEndian() { return getOperand(2); }
  const LDefinition* temp() { return getTemp(0); }
  const LInt64Definition temp64() { return getInt64Temp(1); }
};

class LLoadTypedArrayElementHole : public LInstructionHelper<BOX_PIECES, 2, 1> {
 public:
  LIR_HEADER(LoadTypedArrayElementHole)

  LLoadTypedArrayElementHole(const LAllocation& object,
                             const LAllocation& index, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, index);
    setTemp(0, temp);
  }
  const MLoadTypedArrayElementHole* mir() const {
    return mir_->toLoadTypedArrayElementHole();
  }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

class LLoadTypedArrayElementHoleBigInt
    : public LInstructionHelper<BOX_PIECES, 2, 1 + INT64_PIECES> {
 public:
  LIR_HEADER(LoadTypedArrayElementHoleBigInt)

  LLoadTypedArrayElementHoleBigInt(const LAllocation& object,
                                   const LAllocation& index,
                                   const LDefinition& temp,
                                   const LInt64Definition& temp64)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setOperand(1, index);
    setTemp(0, temp);
    setInt64Temp(1, temp64);
  }
  const MLoadTypedArrayElementHole* mir() const {
    return mir_->toLoadTypedArrayElementHole();
  }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
  const LInt64Definition temp64() { return getInt64Temp(1); }
};

class LStoreUnboxedScalar : public LInstructionHelper<0, 3, 0> {
 public:
  LIR_HEADER(StoreUnboxedScalar)

  LStoreUnboxedScalar(const LAllocation& elements, const LAllocation& index,
                      const LAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
  }

  const MStoreUnboxedScalar* mir() const {
    return mir_->toStoreUnboxedScalar();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
};

class LStoreUnboxedBigInt : public LInstructionHelper<0, 3, INT64_PIECES> {
 public:
  LIR_HEADER(StoreUnboxedBigInt)

  LStoreUnboxedBigInt(const LAllocation& elements, const LAllocation& index,
                      const LAllocation& value, const LInt64Definition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setInt64Temp(0, temp);
  }

  const MStoreUnboxedScalar* mir() const {
    return mir_->toStoreUnboxedScalar();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
  LInt64Definition temp() { return getInt64Temp(0); }
};

class LStoreDataViewElement
    : public LInstructionHelper<0, 4, 1 + INT64_PIECES> {
 public:
  LIR_HEADER(StoreDataViewElement)

  LStoreDataViewElement(const LAllocation& elements, const LAllocation& index,
                        const LAllocation& value,
                        const LAllocation& littleEndian,
                        const LDefinition& temp, const LInt64Definition& temp64)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setOperand(3, littleEndian);
    setTemp(0, temp);
    setInt64Temp(1, temp64);
  }

  const MStoreDataViewElement* mir() const {
    return mir_->toStoreDataViewElement();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
  const LAllocation* littleEndian() { return getOperand(3); }
  const LDefinition* temp() { return getTemp(0); }
  const LInt64Definition temp64() { return getInt64Temp(1); }
};

class LStoreTypedArrayElementHole : public LInstructionHelper<0, 4, 1> {
 public:
  LIR_HEADER(StoreTypedArrayElementHole)

  LStoreTypedArrayElementHole(const LAllocation& elements,
                              const LAllocation& length,
                              const LAllocation& index,
                              const LAllocation& value,
                              const LDefinition& spectreTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, length);
    setOperand(2, index);
    setOperand(3, value);
    setTemp(0, spectreTemp);
  }

  const MStoreTypedArrayElementHole* mir() const {
    return mir_->toStoreTypedArrayElementHole();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* length() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LAllocation* value() { return getOperand(3); }
  const LDefinition* spectreTemp() { return getTemp(0); }
};

class LStoreTypedArrayElementHoleBigInt
    : public LInstructionHelper<0, 4, INT64_PIECES> {
 public:
  LIR_HEADER(StoreTypedArrayElementHoleBigInt)

  LStoreTypedArrayElementHoleBigInt(const LAllocation& elements,
                                    const LAllocation& length,
                                    const LAllocation& index,
                                    const LAllocation& value,
                                    const LInt64Definition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, length);
    setOperand(2, index);
    setOperand(3, value);
    setInt64Temp(0, temp);
  }

  const MStoreTypedArrayElementHole* mir() const {
    return mir_->toStoreTypedArrayElementHole();
  }
  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* length() { return getOperand(1); }
  const LAllocation* index() { return getOperand(2); }
  const LAllocation* value() { return getOperand(3); }
  LInt64Definition temp() { return getInt64Temp(0); }
};

class LAtomicIsLockFree : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(AtomicIsLockFree)

  explicit LAtomicIsLockFree(const LAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, value);
  }
  const LAllocation* value() { return getOperand(0); }
};

class LCompareExchangeTypedArrayElement : public LInstructionHelper<1, 4, 4> {
 public:
  LIR_HEADER(CompareExchangeTypedArrayElement)

  // ARM, ARM64, x86, x64
  LCompareExchangeTypedArrayElement(const LAllocation& elements,
                                    const LAllocation& index,
                                    const LAllocation& oldval,
                                    const LAllocation& newval,
                                    const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, oldval);
    setOperand(3, newval);
    setTemp(0, temp);
  }
  // MIPS32, MIPS64
  LCompareExchangeTypedArrayElement(
      const LAllocation& elements, const LAllocation& index,
      const LAllocation& oldval, const LAllocation& newval,
      const LDefinition& temp, const LDefinition& valueTemp,
      const LDefinition& offsetTemp, const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, oldval);
    setOperand(3, newval);
    setTemp(0, temp);
    setTemp(1, valueTemp);
    setTemp(2, offsetTemp);
    setTemp(3, maskTemp);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* oldval() { return getOperand(2); }
  const LAllocation* newval() { return getOperand(3); }
  const LDefinition* temp() { return getTemp(0); }

  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(1); }
  const LDefinition* offsetTemp() { return getTemp(2); }
  const LDefinition* maskTemp() { return getTemp(3); }

  const MCompareExchangeTypedArrayElement* mir() const {
    return mir_->toCompareExchangeTypedArrayElement();
  }
};

class LAtomicExchangeTypedArrayElement : public LInstructionHelper<1, 3, 4> {
 public:
  LIR_HEADER(AtomicExchangeTypedArrayElement)

  // ARM, ARM64, x86, x64
  LAtomicExchangeTypedArrayElement(const LAllocation& elements,
                                   const LAllocation& index,
                                   const LAllocation& value,
                                   const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, temp);
  }
  // MIPS32, MIPS64
  LAtomicExchangeTypedArrayElement(const LAllocation& elements,
                                   const LAllocation& index,
                                   const LAllocation& value,
                                   const LDefinition& temp,
                                   const LDefinition& valueTemp,
                                   const LDefinition& offsetTemp,
                                   const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, temp);
    setTemp(1, valueTemp);
    setTemp(2, offsetTemp);
    setTemp(3, maskTemp);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
  const LDefinition* temp() { return getTemp(0); }

  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(1); }
  const LDefinition* offsetTemp() { return getTemp(2); }
  const LDefinition* maskTemp() { return getTemp(3); }

  const MAtomicExchangeTypedArrayElement* mir() const {
    return mir_->toAtomicExchangeTypedArrayElement();
  }
};

class LAtomicTypedArrayElementBinop : public LInstructionHelper<1, 3, 5> {
 public:
  LIR_HEADER(AtomicTypedArrayElementBinop)

  static const int32_t valueOp = 2;

  // ARM, ARM64, x86, x64
  LAtomicTypedArrayElementBinop(const LAllocation& elements,
                                const LAllocation& index,
                                const LAllocation& value,
                                const LDefinition& temp1,
                                const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }
  // MIPS32, MIPS64
  LAtomicTypedArrayElementBinop(const LAllocation& elements,
                                const LAllocation& index,
                                const LAllocation& value,
                                const LDefinition& temp2,
                                const LDefinition& valueTemp,
                                const LDefinition& offsetTemp,
                                const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, temp2);
    setTemp(2, valueTemp);
    setTemp(3, offsetTemp);
    setTemp(4, maskTemp);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() {
    MOZ_ASSERT(valueOp == 2);
    return getOperand(2);
  }
  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }

  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(2); }
  const LDefinition* offsetTemp() { return getTemp(3); }
  const LDefinition* maskTemp() { return getTemp(4); }

  const MAtomicTypedArrayElementBinop* mir() const {
    return mir_->toAtomicTypedArrayElementBinop();
  }
};

// Atomic binary operation where the result is discarded.
class LAtomicTypedArrayElementBinopForEffect
    : public LInstructionHelper<0, 3, 4> {
 public:
  LIR_HEADER(AtomicTypedArrayElementBinopForEffect)

  // ARM, ARM64, x86, x64
  LAtomicTypedArrayElementBinopForEffect(
      const LAllocation& elements, const LAllocation& index,
      const LAllocation& value,
      const LDefinition& flagTemp = LDefinition::BogusTemp())
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, flagTemp);
  }
  // MIPS32, MIPS64
  LAtomicTypedArrayElementBinopForEffect(const LAllocation& elements,
                                         const LAllocation& index,
                                         const LAllocation& value,
                                         const LDefinition& valueTemp,
                                         const LDefinition& offsetTemp,
                                         const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
    setOperand(2, value);
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, valueTemp);
    setTemp(2, offsetTemp);
    setTemp(3, maskTemp);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }

  // Temp that may be used on LL/SC platforms for the flag result of the store.
  const LDefinition* flagTemp() { return getTemp(0); }
  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(1); }
  const LDefinition* offsetTemp() { return getTemp(2); }
  const LDefinition* maskTemp() { return getTemp(3); }

  const MAtomicTypedArrayElementBinop* mir() const {
    return mir_->toAtomicTypedArrayElementBinop();
  }
};

class LEffectiveAddress : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(EffectiveAddress);

  LEffectiveAddress(const LAllocation& base, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, base);
    setOperand(1, index);
  }
  const MEffectiveAddress* mir() const { return mir_->toEffectiveAddress(); }
  const LAllocation* base() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
};

class LClampIToUint8 : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ClampIToUint8)

  explicit LClampIToUint8(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }
};

class LClampDToUint8 : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(ClampDToUint8)

  LClampDToUint8(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }
};

class LClampVToUint8 : public LInstructionHelper<1, BOX_PIECES, 1> {
 public:
  LIR_HEADER(ClampVToUint8)

  LClampVToUint8(const LBoxAllocation& input, const LDefinition& tempFloat)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, tempFloat);
  }

  static const size_t Input = 0;

  const LDefinition* tempFloat() { return getTemp(0); }
  const MClampToUint8* mir() const { return mir_->toClampToUint8(); }
};

// Load a boxed value from an object's fixed slot.
class LLoadFixedSlotV : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(LoadFixedSlotV)

  explicit LLoadFixedSlotV(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
  const MLoadFixedSlot* mir() const { return mir_->toLoadFixedSlot(); }
};

// Load a typed value from an object's fixed slot.
class LLoadFixedSlotT : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(LoadFixedSlotT)

  explicit LLoadFixedSlotT(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
  const MLoadFixedSlot* mir() const { return mir_->toLoadFixedSlot(); }
};

class LLoadFixedSlotAndUnbox : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(LoadFixedSlotAndUnbox)

  explicit LLoadFixedSlotAndUnbox(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }

  const MLoadFixedSlotAndUnbox* mir() const {
    return mir_->toLoadFixedSlotAndUnbox();
  }
};

class LLoadDynamicSlotAndUnbox : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(LoadDynamicSlotAndUnbox)

  explicit LLoadDynamicSlotAndUnbox(const LAllocation& slots)
      : LInstructionHelper(classOpcode) {
    setOperand(0, slots);
  }

  const LAllocation* slots() { return getOperand(0); }

  const MLoadDynamicSlotAndUnbox* mir() const {
    return mir_->toLoadDynamicSlotAndUnbox();
  }
};

class LLoadElementAndUnbox : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(LoadElementAndUnbox)

  LLoadElementAndUnbox(const LAllocation& elements, const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, elements);
    setOperand(1, index);
  }

  const LAllocation* elements() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }

  const MLoadElementAndUnbox* mir() const {
    return mir_->toLoadElementAndUnbox();
  }
};

// Store a boxed value to an object's fixed slot.
class LStoreFixedSlotV : public LInstructionHelper<0, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(StoreFixedSlotV)

  LStoreFixedSlotV(const LAllocation& obj, const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Value, value);
  }

  static const size_t Value = 1;

  const MStoreFixedSlot* mir() const { return mir_->toStoreFixedSlot(); }
  const LAllocation* obj() { return getOperand(0); }
};

// Store a typed value to an object's fixed slot.
class LStoreFixedSlotT : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(StoreFixedSlotT)

  LStoreFixedSlotT(const LAllocation& obj, const LAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
  }
  const MStoreFixedSlot* mir() const { return mir_->toStoreFixedSlot(); }
  const LAllocation* obj() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
};

// Note, Name ICs always return a Value. There are no V/T variants.
class LGetNameCache : public LInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(GetNameCache)

  LGetNameCache(const LAllocation& envObj, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, envObj);
    setTemp(0, temp);
  }
  const LAllocation* envObj() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MGetNameCache* mir() const { return mir_->toGetNameCache(); }
};

class LCallGetIntrinsicValue : public LCallInstructionHelper<BOX_PIECES, 0, 0> {
 public:
  LIR_HEADER(CallGetIntrinsicValue)

  const MCallGetIntrinsicValue* mir() const {
    return mir_->toCallGetIntrinsicValue();
  }

  LCallGetIntrinsicValue() : LCallInstructionHelper(classOpcode) {}
};

class LGetPropSuperCacheV
    : public LInstructionHelper<BOX_PIECES, 1 + 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(GetPropSuperCacheV)

  static const size_t Receiver = 1;
  static const size_t Id = Receiver + BOX_PIECES;

  LGetPropSuperCacheV(const LAllocation& obj, const LBoxAllocation& receiver,
                      const LBoxAllocation& id)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Receiver, receiver);
    setBoxOperand(Id, id);
  }
  const LAllocation* obj() { return getOperand(0); }
  const MGetPropSuperCache* mir() const { return mir_->toGetPropSuperCache(); }
};

// Patchable jump to stubs generated for a GetProperty cache, which loads a
// boxed value.
class LGetPropertyCacheV
    : public LInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 1> {
 public:
  LIR_HEADER(GetPropertyCacheV)

  static const size_t Value = 0;
  static const size_t Id = BOX_PIECES;

  LGetPropertyCacheV(const LBoxAllocation& value, const LBoxAllocation& id,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setBoxOperand(Id, id);
    setTemp(0, temp);
  }
  const MGetPropertyCache* mir() const { return mir_->toGetPropertyCache(); }
  const LDefinition* temp() { return getTemp(0); }
};

// Patchable jump to stubs generated for a GetProperty cache, which loads a
// value of a known type, possibly into an FP register.
class LGetPropertyCacheT : public LInstructionHelper<1, 2 * BOX_PIECES, 1> {
 public:
  LIR_HEADER(GetPropertyCacheT)

  static const size_t Value = 0;
  static const size_t Id = BOX_PIECES;

  LGetPropertyCacheT(const LBoxAllocation& value, const LBoxAllocation& id,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setBoxOperand(Id, id);
    setTemp(0, temp);
  }
  const MGetPropertyCache* mir() const { return mir_->toGetPropertyCache(); }
  const LDefinition* temp() { return getTemp(0); }
};

// Emit code to load a boxed value from an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LGetPropertyPolymorphicV : public LInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(GetPropertyPolymorphicV)

  LGetPropertyPolymorphicV(const LAllocation& obj, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setTemp(0, temp);
  }
  const LAllocation* obj() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MGetPropertyPolymorphic* mir() const {
    return mir_->toGetPropertyPolymorphic();
  }
};

// Emit code to load a typed value from an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LGetPropertyPolymorphicT : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(GetPropertyPolymorphicT)

  LGetPropertyPolymorphicT(const LAllocation& obj, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setTemp(0, temp);
  }
  const LAllocation* obj() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MGetPropertyPolymorphic* mir() const {
    return mir_->toGetPropertyPolymorphic();
  }
};

// Emit code to store a boxed value to an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LSetPropertyPolymorphicV
    : public LInstructionHelper<0, 1 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(SetPropertyPolymorphicV)

  LSetPropertyPolymorphicV(const LAllocation& obj, const LBoxAllocation& value,
                           const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Value, value);
    setTemp(0, temp);
  }

  static const size_t Value = 1;

  const LAllocation* obj() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MSetPropertyPolymorphic* mir() const {
    return mir_->toSetPropertyPolymorphic();
  }
};

// Emit code to store a typed value to an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LSetPropertyPolymorphicT : public LInstructionHelper<0, 2, 1> {
  MIRType valueType_;

 public:
  LIR_HEADER(SetPropertyPolymorphicT)

  LSetPropertyPolymorphicT(const LAllocation& obj, const LAllocation& value,
                           MIRType valueType, const LDefinition& temp)
      : LInstructionHelper(classOpcode), valueType_(valueType) {
    setOperand(0, obj);
    setOperand(1, value);
    setTemp(0, temp);
  }

  const LAllocation* obj() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
  MIRType valueType() const { return valueType_; }
  const MSetPropertyPolymorphic* mir() const {
    return mir_->toSetPropertyPolymorphic();
  }
  const char* extraName() const { return StringFromMIRType(valueType_); }
};

class LBindNameCache : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(BindNameCache)

  LBindNameCache(const LAllocation& envChain, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, envChain);
    setTemp(0, temp);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MBindNameCache* mir() const { return mir_->toBindNameCache(); }
};

class LCallBindVar : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(CallBindVar)

  explicit LCallBindVar(const LAllocation& envChain)
      : LInstructionHelper(classOpcode) {
    setOperand(0, envChain);
  }
  const LAllocation* environmentChain() { return getOperand(0); }
  const MCallBindVar* mir() const { return mir_->toCallBindVar(); }
};

// Load a value from an object's dslots or a slots vector.
class LLoadDynamicSlotV : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(LoadDynamicSlotV)

  explicit LLoadDynamicSlotV(const LAllocation& in)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
  }
  const MLoadDynamicSlot* mir() const { return mir_->toLoadDynamicSlot(); }
};

// Load a typed value from an object's dslots or a slots vector. Unlike
// LLoadDynamicSlotV, this can bypass extracting a type tag, directly retrieving
// a pointer, integer, or double.
class LLoadDynamicSlotT : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(LoadDynamicSlotT)

  explicit LLoadDynamicSlotT(const LAllocation& slots)
      : LInstructionHelper(classOpcode) {
    setOperand(0, slots);
  }
  const LAllocation* slots() { return getOperand(0); }
  const LDefinition* output() { return this->getDef(0); }
  const MLoadDynamicSlot* mir() const { return mir_->toLoadDynamicSlot(); }
};

// Store a value to an object's dslots or a slots vector.
class LStoreDynamicSlotV : public LInstructionHelper<0, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(StoreDynamicSlotV)

  LStoreDynamicSlotV(const LAllocation& slots, const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, slots);
    setBoxOperand(Value, value);
  }

  static const size_t Value = 1;

  const MStoreDynamicSlot* mir() const { return mir_->toStoreDynamicSlot(); }
  const LAllocation* slots() { return getOperand(0); }
};

// Store a typed value to an object's dslots or a slots vector. This has a
// few advantages over LStoreDynamicSlotV:
// 1) We can bypass storing the type tag if the slot has the same type as
//    the value.
// 2) Better register allocation: we can store constants and FP regs directly
//    without requiring a second register for the value.
class LStoreDynamicSlotT : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(StoreDynamicSlotT)

  LStoreDynamicSlotT(const LAllocation& slots, const LAllocation& value)
      : LInstructionHelper(classOpcode) {
    setOperand(0, slots);
    setOperand(1, value);
  }
  const MStoreDynamicSlot* mir() const { return mir_->toStoreDynamicSlot(); }
  const LAllocation* slots() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
};

// Read length field of a JSString*.
class LStringLength : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(StringLength)

  explicit LStringLength(const LAllocation& string)
      : LInstructionHelper(classOpcode) {
    setOperand(0, string);
  }

  const LAllocation* string() { return getOperand(0); }
};

// Take the floor of a double precision number and converts it to an int32.
// Implements Math.floor().
class LFloor : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Floor)

  explicit LFloor(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Take the floor of a single precision number and converts it to an int32.
// Implements Math.floor().
class LFloorF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(FloorF)

  explicit LFloorF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Take the ceiling of a double precision number and converts it to an int32.
// Implements Math.ceil().
class LCeil : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Ceil)

  explicit LCeil(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Take the ceiling of a single precision number and converts it to an int32.
// Implements Math.ceil().
class LCeilF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(CeilF)

  explicit LCeilF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Round a double precision number and converts it to an int32.
// Implements Math.round().
class LRound : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(Round)

  LRound(const LAllocation& num, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, num);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
  MRound* mir() const { return mir_->toRound(); }
};

// Round a single precision number and converts it to an int32.
// Implements Math.round().
class LRoundF : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(RoundF)

  LRoundF(const LAllocation& num, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, num);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
  MRound* mir() const { return mir_->toRound(); }
};

// Truncates a double precision number and converts it to an int32.
// Implements Math.trunc().
class LTrunc : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(Trunc)

  explicit LTrunc(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Truncates a single precision number and converts it to an int32.
// Implements Math.trunc().
class LTruncF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(TruncF)

  explicit LTruncF(const LAllocation& num) : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
};

// Rounds a double precision number accordingly to mir()->roundingMode(),
// and keeps a double output.
class LNearbyInt : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NearbyInt)

  explicit LNearbyInt(const LAllocation& num)
      : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
  MNearbyInt* mir() const { return mir_->toNearbyInt(); }
};

// Rounds a single precision number accordingly to mir()->roundingMode(),
// and keeps a single output.
class LNearbyIntF : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NearbyIntF)

  explicit LNearbyIntF(const LAllocation& num)
      : LInstructionHelper(classOpcode) {
    setOperand(0, num);
  }
  MNearbyInt* mir() const { return mir_->toNearbyInt(); }
};

// Load a function's call environment.
class LFunctionEnvironment : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(FunctionEnvironment)

  explicit LFunctionEnvironment(const LAllocation& function)
      : LInstructionHelper(classOpcode) {
    setOperand(0, function);
  }
  const LAllocation* function() { return getOperand(0); }
};

class LHomeObject : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(HomeObject)

  explicit LHomeObject(const LAllocation& function)
      : LInstructionHelper(classOpcode) {
    setOperand(0, function);
  }
  const LAllocation* function() { return getOperand(0); }
};

class LHomeObjectSuperBase : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(HomeObjectSuperBase)

  explicit LHomeObjectSuperBase(const LAllocation& homeObject)
      : LInstructionHelper(classOpcode) {
    setOperand(0, homeObject);
  }

  const LAllocation* homeObject() { return getOperand(0); }
};

// Allocate a new LexicalEnvironmentObject.
class LNewLexicalEnvironmentObject : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(NewLexicalEnvironmentObject)

  explicit LNewLexicalEnvironmentObject(const LAllocation& enclosing)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, enclosing);
  }
  const LAllocation* enclosing() { return getOperand(0); }

  MNewLexicalEnvironmentObject* mir() const {
    return mir_->toNewLexicalEnvironmentObject();
  }
};

// Copy a LexicalEnvironmentObject.
class LCopyLexicalEnvironmentObject : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(CopyLexicalEnvironmentObject)

  explicit LCopyLexicalEnvironmentObject(const LAllocation& env)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, env);
  }
  const LAllocation* env() { return getOperand(0); }

  MCopyLexicalEnvironmentObject* mir() const {
    return mir_->toCopyLexicalEnvironmentObject();
  }
};

class LCallGetProperty
    : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallGetProperty)

  static const size_t Value = 0;

  explicit LCallGetProperty(const LBoxAllocation& val)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(Value, val);
  }

  MCallGetProperty* mir() const { return mir_->toCallGetProperty(); }
};

// Call js::GetElement.
class LCallGetElement
    : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallGetElement)

  static const size_t LhsInput = 0;
  static const size_t RhsInput = BOX_PIECES;

  LCallGetElement(const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(LhsInput, lhs);
    setBoxOperand(RhsInput, rhs);
  }

  MCallGetElement* mir() const { return mir_->toCallGetElement(); }
};

// Call js::SetElement.
class LCallSetElement
    : public LCallInstructionHelper<0, 1 + 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallSetElement)

  static const size_t Index = 1;
  static const size_t Value = 1 + BOX_PIECES;

  LCallSetElement(const LAllocation& obj, const LBoxAllocation& index,
                  const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Index, index);
    setBoxOperand(Value, value);
  }

  const MCallSetElement* mir() const { return mir_->toCallSetElement(); }
};

// Call js::InitElementArray.
class LCallInitElementArray
    : public LCallInstructionHelper<0, 2 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallInitElementArray)

  static const size_t Value = 2;

  LCallInitElementArray(const LAllocation& obj, const LAllocation& index,
                        const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, index);
    setBoxOperand(Value, value);
  }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* index() { return getOperand(1); }
  const MCallInitElementArray* mir() const {
    return mir_->toCallInitElementArray();
  }
};

// Call a VM function to perform a property or name assignment of a generic
// value.
class LCallSetProperty : public LCallInstructionHelper<0, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallSetProperty)

  LCallSetProperty(const LAllocation& obj, const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Value, value);
  }

  static const size_t Value = 1;

  const MCallSetProperty* mir() const { return mir_->toCallSetProperty(); }
};

class LCallDeleteProperty : public LCallInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallDeleteProperty)

  static const size_t Value = 0;

  explicit LCallDeleteProperty(const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
  }

  MDeleteProperty* mir() const { return mir_->toDeleteProperty(); }
};

class LCallDeleteElement : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CallDeleteElement)

  static const size_t Value = 0;
  static const size_t Index = BOX_PIECES;

  LCallDeleteElement(const LBoxAllocation& value, const LBoxAllocation& index)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setBoxOperand(Index, index);
  }

  MDeleteElement* mir() const { return mir_->toDeleteElement(); }
};

// Patchable jump to stubs generated for a SetProperty cache.
class LSetPropertyCache : public LInstructionHelper<0, 1 + 2 * BOX_PIECES, 2> {
 public:
  LIR_HEADER(SetPropertyCache)

  // Takes an additional temp: this is intendend to be FloatReg0 to allow the
  // actual cache code to safely clobber that value without save and restore.
  LSetPropertyCache(const LAllocation& object, const LBoxAllocation& id,
                    const LBoxAllocation& value, const LDefinition& temp,
                    const LDefinition& tempDouble)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
    setBoxOperand(Id, id);
    setBoxOperand(Value, value);
    setTemp(0, temp);
    setTemp(1, tempDouble);
  }

  static const size_t Id = 1;
  static const size_t Value = 1 + BOX_PIECES;

  const MSetPropertyCache* mir() const { return mir_->toSetPropertyCache(); }

  const LDefinition* temp() { return getTemp(0); }
};

class LGetIteratorCache : public LInstructionHelper<1, BOX_PIECES, 2> {
 public:
  LIR_HEADER(GetIteratorCache)

  static const size_t Value = 0;

  LGetIteratorCache(const LBoxAllocation& value, const LDefinition& temp1,
                    const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }
  const MGetIteratorCache* mir() const { return mir_->toGetIteratorCache(); }
  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
};

class LIteratorMore : public LInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(IteratorMore)

  LIteratorMore(const LAllocation& iterator, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, iterator);
    setTemp(0, temp);
  }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  MIteratorMore* mir() const { return mir_->toIteratorMore(); }
};

class LIsNoIterAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 0> {
 public:
  LIR_HEADER(IsNoIterAndBranch)

  LIsNoIterAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                     const LBoxAllocation& input)
      : LControlInstructionHelper(classOpcode) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

class LIteratorEnd : public LInstructionHelper<0, 1, 3> {
 public:
  LIR_HEADER(IteratorEnd)

  LIteratorEnd(const LAllocation& iterator, const LDefinition& temp1,
               const LDefinition& temp2, const LDefinition& temp3)
      : LInstructionHelper(classOpcode) {
    setOperand(0, iterator);
    setTemp(0, temp1);
    setTemp(1, temp2);
    setTemp(2, temp3);
  }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
  const LDefinition* temp3() { return getTemp(2); }
  MIteratorEnd* mir() const { return mir_->toIteratorEnd(); }
};

// Read the number of actual arguments.
class LArgumentsLength : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(ArgumentsLength)

  LArgumentsLength() : LInstructionHelper(classOpcode) {}
};

// Load a value from the actual arguments.
class LGetFrameArgument : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(GetFrameArgument)

  explicit LGetFrameArgument(const LAllocation& index)
      : LInstructionHelper(classOpcode) {
    setOperand(0, index);
  }
  const LAllocation* index() { return getOperand(0); }
};

// Create the rest parameter.
class LRest : public LCallInstructionHelper<1, 1, 3> {
 public:
  LIR_HEADER(Rest)

  LRest(const LAllocation& numActuals, const LDefinition& temp1,
        const LDefinition& temp2, const LDefinition& temp3)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, numActuals);
    setTemp(0, temp1);
    setTemp(1, temp2);
    setTemp(2, temp3);
  }
  const LAllocation* numActuals() { return getOperand(0); }
  MRest* mir() const { return mir_->toRest(); }
};

class LGuardReceiverPolymorphic : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(GuardReceiverPolymorphic)

  LGuardReceiverPolymorphic(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const MGuardReceiverPolymorphic* mir() const {
    return mir_->toGuardReceiverPolymorphic();
  }
};

// Convert a Boolean to an Int64, following ToBigInt.
class LBooleanToInt64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
 public:
  LIR_HEADER(BooleanToInt64)

  explicit LBooleanToInt64(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(Input, input);
  }

  static const size_t Input = 0;

  const MToInt64* mir() const { return mir_->toToInt64(); }
};

// Convert a String to an Int64, following ToBigInt.
class LStringToInt64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
 public:
  LIR_HEADER(StringToInt64)

  explicit LStringToInt64(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(Input, input);
  }

  static const size_t Input = 0;

  const MToInt64* mir() const { return mir_->toToInt64(); }
};

// Simulate ToBigInt on a Value and produce a matching Int64.
class LValueToInt64 : public LInstructionHelper<INT64_PIECES, BOX_PIECES, 1> {
 public:
  LIR_HEADER(ValueToInt64)

  explicit LValueToInt64(const LBoxAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, temp);
  }

  static const size_t Input = 0;

  const MToInt64* mir() const { return mir_->toToInt64(); }
  const LDefinition* temp() { return getTemp(0); }
};

// Truncate a BigInt to an unboxed int64.
class LTruncateBigIntToInt64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
 public:
  LIR_HEADER(TruncateBigIntToInt64)

  explicit LTruncateBigIntToInt64(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(Input, input);
  }

  static const size_t Input = 0;

  const MTruncateBigIntToInt64* mir() const {
    return mir_->toTruncateBigIntToInt64();
  }
};

// Create a new BigInt* from an unboxed int64.
class LInt64ToBigInt : public LInstructionHelper<1, INT64_PIECES, 1> {
 public:
  LIR_HEADER(Int64ToBigInt)

  LInt64ToBigInt(const LInt64Allocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(Input, input);
    setTemp(0, temp);
  }

  static const size_t Input = 0;

  const MInt64ToBigInt* mir() const { return mir_->toInt64ToBigInt(); }
  const LInt64Allocation input() { return getInt64Operand(Input); }
  const LDefinition* temp() { return getTemp(0); }
};

// Guard that a value is in a TypeSet.
class LTypeBarrierV : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 2> {
 public:
  LIR_HEADER(TypeBarrierV)

  LTypeBarrierV(const LBoxAllocation& input, const LDefinition& unboxTemp,
                const LDefinition& objTemp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, unboxTemp);
    setTemp(1, objTemp);
  }

  static const size_t Input = 0;

  const MTypeBarrier* mir() const { return mir_->toTypeBarrier(); }
  const LDefinition* unboxTemp() { return getTemp(0); }
  const LDefinition* objTemp() { return getTemp(1); }
};

// Guard that a object is in a TypeSet.
class LTypeBarrierO : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(TypeBarrierO)

  LTypeBarrierO(const LAllocation& obj, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setTemp(0, temp);
  }
  const MTypeBarrier* mir() const { return mir_->toTypeBarrier(); }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing an object to another object.
class LPostWriteBarrierO : public LInstructionHelper<0, 2, 1> {
 public:
  LIR_HEADER(PostWriteBarrierO)

  LPostWriteBarrierO(const LAllocation& obj, const LAllocation& value,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setTemp(0, temp);
  }

  const MPostWriteBarrier* mir() const { return mir_->toPostWriteBarrier(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a string to an object.
class LPostWriteBarrierS : public LInstructionHelper<0, 2, 1> {
 public:
  LIR_HEADER(PostWriteBarrierS)

  LPostWriteBarrierS(const LAllocation& obj, const LAllocation& value,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setTemp(0, temp);
  }

  const MPostWriteBarrier* mir() const { return mir_->toPostWriteBarrier(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a BigInt to an object.
class LPostWriteBarrierBI : public LInstructionHelper<0, 2, 1> {
 public:
  LIR_HEADER(PostWriteBarrierBI)

  LPostWriteBarrierBI(const LAllocation& obj, const LAllocation& value,
                      const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setTemp(0, temp);
  }

  const MPostWriteBarrier* mir() const { return mir_->toPostWriteBarrier(); }
  const LAllocation* object() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a value to another object.
class LPostWriteBarrierV : public LInstructionHelper<0, 1 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(PostWriteBarrierV)

  LPostWriteBarrierV(const LAllocation& obj, const LBoxAllocation& value,
                     const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setBoxOperand(Input, value);
    setTemp(0, temp);
  }

  static const size_t Input = 1;

  const MPostWriteBarrier* mir() const { return mir_->toPostWriteBarrier(); }
  const LAllocation* object() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing an object to another object's
// elements.
class LPostWriteElementBarrierO : public LInstructionHelper<0, 3, 1> {
 public:
  LIR_HEADER(PostWriteElementBarrierO)

  LPostWriteElementBarrierO(const LAllocation& obj, const LAllocation& value,
                            const LAllocation& index, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setOperand(2, index);
    setTemp(0, temp);
  }

  const MPostWriteElementBarrier* mir() const {
    return mir_->toPostWriteElementBarrier();
  }

  const LAllocation* object() { return getOperand(0); }

  const LAllocation* value() { return getOperand(1); }

  const LAllocation* index() { return getOperand(2); }

  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a string to an object's
// elements.
class LPostWriteElementBarrierS : public LInstructionHelper<0, 3, 1> {
 public:
  LIR_HEADER(PostWriteElementBarrierS)

  LPostWriteElementBarrierS(const LAllocation& obj, const LAllocation& value,
                            const LAllocation& index, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setOperand(2, index);
    setTemp(0, temp);
  }

  const MPostWriteElementBarrier* mir() const {
    return mir_->toPostWriteElementBarrier();
  }

  const LAllocation* object() { return getOperand(0); }

  const LAllocation* value() { return getOperand(1); }

  const LAllocation* index() { return getOperand(2); }

  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a BigInt to an object's
// elements.
class LPostWriteElementBarrierBI : public LInstructionHelper<0, 3, 1> {
 public:
  LIR_HEADER(PostWriteElementBarrierBI)

  LPostWriteElementBarrierBI(const LAllocation& obj, const LAllocation& value,
                             const LAllocation& index, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, value);
    setOperand(2, index);
    setTemp(0, temp);
  }

  const MPostWriteElementBarrier* mir() const {
    return mir_->toPostWriteElementBarrier();
  }

  const LAllocation* object() { return getOperand(0); }

  const LAllocation* value() { return getOperand(1); }

  const LAllocation* index() { return getOperand(2); }

  const LDefinition* temp() { return getTemp(0); }
};

// Generational write barrier used when writing a value to another object's
// elements.
class LPostWriteElementBarrierV
    : public LInstructionHelper<0, 2 + BOX_PIECES, 1> {
 public:
  LIR_HEADER(PostWriteElementBarrierV)

  LPostWriteElementBarrierV(const LAllocation& obj, const LAllocation& index,
                            const LBoxAllocation& value,
                            const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, obj);
    setOperand(1, index);
    setBoxOperand(Input, value);
    setTemp(0, temp);
  }

  static const size_t Input = 2;

  const MPostWriteElementBarrier* mir() const {
    return mir_->toPostWriteElementBarrier();
  }

  const LAllocation* object() { return getOperand(0); }

  const LAllocation* index() { return getOperand(1); }

  const LDefinition* temp() { return getTemp(0); }
};

// Guard against an object's identity.
class LGuardObjectIdentity : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(GuardObjectIdentity)

  LGuardObjectIdentity(const LAllocation& in, const LAllocation& expected)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setOperand(1, expected);
  }
  const LAllocation* input() { return getOperand(0); }
  const LAllocation* expected() { return getOperand(1); }
  const MGuardObjectIdentity* mir() const {
    return mir_->toGuardObjectIdentity();
  }
};

// Guard against an function's identity.
class LGuardSpecificFunction : public LInstructionHelper<0, 2, 0> {
 public:
  LIR_HEADER(GuardSpecificFunction)

  LGuardSpecificFunction(const LAllocation& in, const LAllocation& expected)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setOperand(1, expected);
  }
  const LAllocation* input() { return getOperand(0); }
  const LAllocation* expected() { return getOperand(1); }
};

class LGuardSpecificAtom : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(GuardSpecificAtom)

  explicit LGuardSpecificAtom(const LAllocation& str)
      : LInstructionHelper(classOpcode) {
    setOperand(0, str);
  }
  const LAllocation* str() { return getOperand(0); }
  const MGuardSpecificAtom* mir() const { return mir_->toGuardSpecificAtom(); }
};

class LGuardShape : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(GuardShape)

  LGuardShape(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
  const MGuardShape* mir() const { return mir_->toGuardShape(); }
};

class LGuardObjectGroup : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(GuardObjectGroup)

  LGuardObjectGroup(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
  const MGuardObjectGroup* mir() const { return mir_->toGuardObjectGroup(); }
};

// Guard against the sharedness of a TypedArray's memory.
class LGuardSharedTypedArray : public LInstructionHelper<0, 1, 1> {
 public:
  LIR_HEADER(GuardSharedTypedArray)

  LGuardSharedTypedArray(const LAllocation& in, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, in);
    setTemp(0, temp);
  }
  const MGuardSharedTypedArray* mir() const {
    return mir_->toGuardSharedTypedArray();
  }
  const LDefinition* tempInt() { return getTemp(0); }
};

class LInCache : public LInstructionHelper<1, BOX_PIECES + 1, 1> {
 public:
  LIR_HEADER(InCache)
  LInCache(const LBoxAllocation& lhs, const LAllocation& rhs,
           const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LHS, lhs);
    setOperand(RHS, rhs);
    setTemp(0, temp);
  }

  const LAllocation* lhs() { return getOperand(LHS); }
  const LAllocation* rhs() { return getOperand(RHS); }
  const LDefinition* temp() { return getTemp(0); }
  const MInCache* mir() const { return mir_->toInCache(); }

  static const size_t LHS = 0;
  static const size_t RHS = BOX_PIECES;
};

class LHasOwnCache : public LInstructionHelper<1, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(HasOwnCache)

  static const size_t Value = 0;
  static const size_t Id = BOX_PIECES;

  LHasOwnCache(const LBoxAllocation& value, const LBoxAllocation& id)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Value, value);
    setBoxOperand(Id, id);
  }

  const MHasOwnCache* mir() const { return mir_->toHasOwnCache(); }
};

class LInstanceOfO : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(InstanceOfO)
  explicit LInstanceOfO(const LAllocation& lhs)
      : LInstructionHelper(classOpcode) {
    setOperand(0, lhs);
  }

  MInstanceOf* mir() const { return mir_->toInstanceOf(); }

  const LAllocation* lhs() { return getOperand(0); }
};

class LInstanceOfV : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(InstanceOfV)
  explicit LInstanceOfV(const LBoxAllocation& lhs)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LHS, lhs);
  }

  MInstanceOf* mir() const { return mir_->toInstanceOf(); }

  const LAllocation* lhs() { return getOperand(LHS); }

  static const size_t LHS = 0;
};

class LInstanceOfCache : public LInstructionHelper<1, BOX_PIECES + 1, 0> {
 public:
  LIR_HEADER(InstanceOfCache)
  LInstanceOfCache(const LBoxAllocation& lhs, const LAllocation& rhs)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(LHS, lhs);
    setOperand(RHS, rhs);
  }

  const LDefinition* output() { return this->getDef(0); }
  const LAllocation* lhs() { return getOperand(LHS); }
  const LAllocation* rhs() { return getOperand(RHS); }

  static const size_t LHS = 0;
  static const size_t RHS = BOX_PIECES;
};

class LIsCallableO : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IsCallableO);
  explicit LIsCallableO(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }
  MIsCallable* mir() const { return mir_->toIsCallable(); }
};

class LIsCallableV : public LInstructionHelper<1, BOX_PIECES, 1> {
 public:
  LIR_HEADER(IsCallableV);
  static const size_t Value = 0;

  LIsCallableV(const LBoxAllocation& value, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(0, value);
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
  MIsCallable* mir() const { return mir_->toIsCallable(); }
};

class LIsConstructor : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IsConstructor);
  explicit LIsConstructor(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }

  const LAllocation* object() { return getOperand(0); }
  MIsConstructor* mir() const { return mir_->toIsConstructor(); }
};

class LIsArrayO : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IsArrayO);

  explicit LIsArrayO(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
  const LAllocation* object() { return getOperand(0); }
  MIsArray* mir() const { return mir_->toIsArray(); }
};

class LIsArrayV : public LInstructionHelper<1, BOX_PIECES, 1> {
 public:
  LIR_HEADER(IsArrayV);
  static const size_t Value = 0;

  LIsArrayV(const LBoxAllocation& value, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(0, value);
    setTemp(0, temp);
  }
  const LDefinition* temp() { return getTemp(0); }
  MIsArray* mir() const { return mir_->toIsArray(); }
};

class LIsTypedArray : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(IsTypedArray);

  explicit LIsTypedArray(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
  const LAllocation* object() { return getOperand(0); }
  MIsTypedArray* mir() const { return mir_->toIsTypedArray(); }
};

class LIsObject : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(IsObject);
  static const size_t Input = 0;

  explicit LIsObject(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MIsObject* mir() const { return mir_->toIsObject(); }
};

class LIsObjectAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 0> {
 public:
  LIR_HEADER(IsObjectAndBranch)

  LIsObjectAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                     const LBoxAllocation& input)
      : LControlInstructionHelper(classOpcode) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }
};

class LIsNullOrUndefined : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(IsNullOrUndefined);
  static const size_t Input = 0;

  explicit LIsNullOrUndefined(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MIsNullOrUndefined* mir() const { return mir_->toIsNullOrUndefined(); }
};

class LIsNullOrUndefinedAndBranch
    : public LControlInstructionHelper<2, BOX_PIECES, 0> {
  MIsNullOrUndefined* isNullOrUndefined_;

 public:
  LIR_HEADER(IsNullOrUndefinedAndBranch)
  static const size_t Input = 0;

  LIsNullOrUndefinedAndBranch(MIsNullOrUndefined* isNullOrUndefined,
                              MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                              const LBoxAllocation& input)
      : LControlInstructionHelper(classOpcode),
        isNullOrUndefined_(isNullOrUndefined) {
    setSuccessor(0, ifTrue);
    setSuccessor(1, ifFalse);
    setBoxOperand(Input, input);
  }

  MBasicBlock* ifTrue() const { return getSuccessor(0); }
  MBasicBlock* ifFalse() const { return getSuccessor(1); }

  MIsNullOrUndefined* isNullOrUndefinedMir() const {
    return isNullOrUndefined_;
  }
};

class LHasClass : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(HasClass);
  explicit LHasClass(const LAllocation& lhs) : LInstructionHelper(classOpcode) {
    setOperand(0, lhs);
  }

  const LAllocation* lhs() { return getOperand(0); }
  MHasClass* mir() const { return mir_->toHasClass(); }
};

class LGuardToClass : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(GuardToClass);
  explicit LGuardToClass(const LAllocation& lhs, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, lhs);
    setTemp(0, temp);
  }

  const LAllocation* lhs() { return getOperand(0); }

  const LDefinition* temp() { return getTemp(0); }

  MGuardToClass* mir() const { return mir_->toGuardToClass(); }
};

class LObjectClassToString : public LCallInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ObjectClassToString);

  explicit LObjectClassToString(const LAllocation& lhs)
      : LCallInstructionHelper(classOpcode) {
    setOperand(0, lhs);
  }
  const LAllocation* object() { return getOperand(0); }
  MObjectClassToString* mir() const { return mir_->toObjectClassToString(); }
};

template <size_t Defs, size_t Ops>
class LWasmSelectBase : public LInstructionHelper<Defs, Ops, 0> {
  typedef LInstructionHelper<Defs, Ops, 0> Base;

 protected:
  explicit LWasmSelectBase(LNode::Opcode opcode) : Base(opcode) {}

 public:
  MWasmSelect* mir() const { return Base::mir_->toWasmSelect(); }
};

class LWasmSelect : public LWasmSelectBase<1, 3> {
 public:
  LIR_HEADER(WasmSelect);

  static const size_t TrueExprIndex = 0;
  static const size_t FalseExprIndex = 1;
  static const size_t CondIndex = 2;

  LWasmSelect(const LAllocation& trueExpr, const LAllocation& falseExpr,
              const LAllocation& cond)
      : LWasmSelectBase(classOpcode) {
    setOperand(TrueExprIndex, trueExpr);
    setOperand(FalseExprIndex, falseExpr);
    setOperand(CondIndex, cond);
  }

  const LAllocation* trueExpr() { return getOperand(TrueExprIndex); }
  const LAllocation* falseExpr() { return getOperand(FalseExprIndex); }
  const LAllocation* condExpr() { return getOperand(CondIndex); }
};

class LWasmSelectI64
    : public LWasmSelectBase<INT64_PIECES, 2 * INT64_PIECES + 1> {
 public:
  LIR_HEADER(WasmSelectI64);

  static const size_t TrueExprIndex = 0;
  static const size_t FalseExprIndex = INT64_PIECES;
  static const size_t CondIndex = INT64_PIECES * 2;

  LWasmSelectI64(const LInt64Allocation& trueExpr,
                 const LInt64Allocation& falseExpr, const LAllocation& cond)
      : LWasmSelectBase(classOpcode) {
    setInt64Operand(TrueExprIndex, trueExpr);
    setInt64Operand(FalseExprIndex, falseExpr);
    setOperand(CondIndex, cond);
  }

  const LInt64Allocation trueExpr() { return getInt64Operand(TrueExprIndex); }
  const LInt64Allocation falseExpr() { return getInt64Operand(FalseExprIndex); }
  const LAllocation* condExpr() { return getOperand(CondIndex); }
};

class LWasmCompareAndSelect : public LWasmSelectBase<1, 4> {
  MCompare::CompareType compareType_;
  JSOp jsop_;

 public:
  LIR_HEADER(WasmCompareAndSelect);

  static const size_t LeftExprIndex = 0;
  static const size_t RightExprIndex = 1;
  static const size_t IfTrueExprIndex = 2;
  static const size_t IfFalseExprIndex = 3;

  LWasmCompareAndSelect(const LAllocation& leftExpr,
                        const LAllocation& rightExpr,
                        MCompare::CompareType compareType, JSOp jsop,
                        const LAllocation& ifTrueExpr,
                        const LAllocation& ifFalseExpr)
      : LWasmSelectBase(classOpcode), compareType_(compareType), jsop_(jsop) {
    setOperand(LeftExprIndex, leftExpr);
    setOperand(RightExprIndex, rightExpr);
    setOperand(IfTrueExprIndex, ifTrueExpr);
    setOperand(IfFalseExprIndex, ifFalseExpr);
  }

  const LAllocation* leftExpr() { return getOperand(LeftExprIndex); }
  const LAllocation* rightExpr() { return getOperand(RightExprIndex); }
  const LAllocation* ifTrueExpr() { return getOperand(IfTrueExprIndex); }
  const LAllocation* ifFalseExpr() { return getOperand(IfFalseExprIndex); }

  MCompare::CompareType compareType() { return compareType_; }
  JSOp jsop() { return jsop_; }
};

class LWasmAddOffset : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmAddOffset);
  explicit LWasmAddOffset(const LAllocation& base)
      : LInstructionHelper(classOpcode) {
    setOperand(0, base);
  }
  MWasmAddOffset* mir() const { return mir_->toWasmAddOffset(); }
  const LAllocation* base() { return getOperand(0); }
};

class LWasmBoundsCheck : public LInstructionHelper<1, 2, 0> {
 public:
  LIR_HEADER(WasmBoundsCheck);
  explicit LWasmBoundsCheck(const LAllocation& ptr,
                            const LAllocation& boundsCheckLimit = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, boundsCheckLimit);
  }
  MWasmBoundsCheck* mir() const { return mir_->toWasmBoundsCheck(); }
  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* boundsCheckLimit() { return getOperand(1); }
};

class LWasmAlignmentCheck : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(WasmAlignmentCheck);
  explicit LWasmAlignmentCheck(const LAllocation& ptr)
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
  }
  MWasmAlignmentCheck* mir() const { return mir_->toWasmAlignmentCheck(); }
  const LAllocation* ptr() { return getOperand(0); }
};

class LWasmLoadTls : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmLoadTls);
  explicit LWasmLoadTls(const LAllocation& tlsPtr)
      : LInstructionHelper(classOpcode) {
    setOperand(0, tlsPtr);
  }
  MWasmLoadTls* mir() const { return mir_->toWasmLoadTls(); }
  const LAllocation* tlsPtr() { return getOperand(0); }
};

class LWasmHeapBase : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmHeapBase);
  explicit LWasmHeapBase(const LAllocation& tlsPtr)
      : LInstructionHelper(classOpcode) {
    setOperand(0, tlsPtr);
  }
  MWasmHeapBase* mir() const { return mir_->toWasmHeapBase(); }
  const LAllocation* tlsPtr() { return getOperand(0); }
};

namespace details {

// This is a base class for LWasmLoad/LWasmLoadI64.
template <size_t Defs, size_t Temp>
class LWasmLoadBase : public LInstructionHelper<Defs, 2, Temp> {
 public:
  typedef LInstructionHelper<Defs, 2, Temp> Base;
  explicit LWasmLoadBase(LNode::Opcode opcode, const LAllocation& ptr,
                         const LAllocation& memoryBase)
      : Base(opcode) {
    Base::setOperand(0, ptr);
    Base::setOperand(1, memoryBase);
  }
  MWasmLoad* mir() const { return Base::mir_->toWasmLoad(); }
  const LAllocation* ptr() { return Base::getOperand(0); }
  const LAllocation* memoryBase() { return Base::getOperand(1); }
};

}  // namespace details

class LWasmLoad : public details::LWasmLoadBase<1, 1> {
 public:
  explicit LWasmLoad(const LAllocation& ptr,
                     const LAllocation& memoryBase = LAllocation())
      : LWasmLoadBase(classOpcode, ptr, memoryBase) {
    setTemp(0, LDefinition::BogusTemp());
  }

  const LDefinition* ptrCopy() { return Base::getTemp(0); }

  LIR_HEADER(WasmLoad);
};

class LWasmLoadI64 : public details::LWasmLoadBase<INT64_PIECES, 1> {
 public:
  explicit LWasmLoadI64(const LAllocation& ptr,
                        const LAllocation& memoryBase = LAllocation())
      : LWasmLoadBase(classOpcode, ptr, memoryBase) {
    setTemp(0, LDefinition::BogusTemp());
  }

  const LDefinition* ptrCopy() { return Base::getTemp(0); }

  LIR_HEADER(WasmLoadI64);
};

class LWasmStore : public LInstructionHelper<0, 3, 1> {
 public:
  LIR_HEADER(WasmStore);

  static const size_t PtrIndex = 0;
  static const size_t ValueIndex = 1;
  static const size_t MemoryBaseIndex = 2;

  LWasmStore(const LAllocation& ptr, const LAllocation& value,
             const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(PtrIndex, ptr);
    setOperand(ValueIndex, value);
    setOperand(MemoryBaseIndex, memoryBase);
    setTemp(0, LDefinition::BogusTemp());
  }
  MWasmStore* mir() const { return mir_->toWasmStore(); }
  const LAllocation* ptr() { return getOperand(PtrIndex); }
  const LDefinition* ptrCopy() { return getTemp(0); }
  const LAllocation* value() { return getOperand(ValueIndex); }
  const LAllocation* memoryBase() { return getOperand(MemoryBaseIndex); }
};

class LWasmStoreI64 : public LInstructionHelper<0, INT64_PIECES + 2, 1> {
 public:
  LIR_HEADER(WasmStoreI64);

  static const size_t PtrIndex = 0;
  static const size_t MemoryBaseIndex = 1;
  static const size_t ValueIndex = 2;

  LWasmStoreI64(const LAllocation& ptr, const LInt64Allocation& value,
                const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(PtrIndex, ptr);
    setOperand(MemoryBaseIndex, memoryBase);
    setInt64Operand(ValueIndex, value);
    setTemp(0, LDefinition::BogusTemp());
  }
  MWasmStore* mir() const { return mir_->toWasmStore(); }
  const LAllocation* ptr() { return getOperand(PtrIndex); }
  const LAllocation* memoryBase() { return getOperand(MemoryBaseIndex); }
  const LDefinition* ptrCopy() { return getTemp(0); }
  const LInt64Allocation value() { return getInt64Operand(ValueIndex); }
};

class LAsmJSLoadHeap : public LInstructionHelper<1, 3, 0> {
 public:
  LIR_HEADER(AsmJSLoadHeap);
  explicit LAsmJSLoadHeap(const LAllocation& ptr,
                          const LAllocation& boundsCheckLimit,
                          const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, boundsCheckLimit);
    setOperand(2, memoryBase);
  }
  MAsmJSLoadHeap* mir() const { return mir_->toAsmJSLoadHeap(); }
  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* boundsCheckLimit() { return getOperand(1); }
  const LAllocation* memoryBase() { return getOperand(2); }
};

class LAsmJSStoreHeap : public LInstructionHelper<0, 4, 0> {
 public:
  LIR_HEADER(AsmJSStoreHeap);
  LAsmJSStoreHeap(const LAllocation& ptr, const LAllocation& value,
                  const LAllocation& boundsCheckLimit,
                  const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, boundsCheckLimit);
    setOperand(3, memoryBase);
  }
  MAsmJSStoreHeap* mir() const { return mir_->toAsmJSStoreHeap(); }
  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LAllocation* boundsCheckLimit() { return getOperand(2); }
  const LAllocation* memoryBase() { return getOperand(3); }
};

class LWasmCompareExchangeHeap : public LInstructionHelper<1, 4, 4> {
 public:
  LIR_HEADER(WasmCompareExchangeHeap);

  // ARM, ARM64, x86, x64
  LWasmCompareExchangeHeap(const LAllocation& ptr, const LAllocation& oldValue,
                           const LAllocation& newValue,
                           const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, oldValue);
    setOperand(2, newValue);
    setOperand(3, memoryBase);
    setTemp(0, LDefinition::BogusTemp());
  }
  // MIPS32, MIPS64
  LWasmCompareExchangeHeap(const LAllocation& ptr, const LAllocation& oldValue,
                           const LAllocation& newValue,
                           const LDefinition& valueTemp,
                           const LDefinition& offsetTemp,
                           const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, oldValue);
    setOperand(2, newValue);
    setOperand(3, LAllocation());
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, valueTemp);
    setTemp(2, offsetTemp);
    setTemp(3, maskTemp);
  }

  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* oldValue() { return getOperand(1); }
  const LAllocation* newValue() { return getOperand(2); }
  const LAllocation* memoryBase() { return getOperand(3); }
  const LDefinition* addrTemp() { return getTemp(0); }

  void setAddrTemp(const LDefinition& addrTemp) { setTemp(0, addrTemp); }

  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(1); }
  const LDefinition* offsetTemp() { return getTemp(2); }
  const LDefinition* maskTemp() { return getTemp(3); }

  MWasmCompareExchangeHeap* mir() const {
    return mir_->toWasmCompareExchangeHeap();
  }
};

class LWasmFence : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(WasmFence);
  explicit LWasmFence() : LInstructionHelper(classOpcode) {}
};

class LWasmAtomicExchangeHeap : public LInstructionHelper<1, 3, 4> {
 public:
  LIR_HEADER(WasmAtomicExchangeHeap);

  // ARM, ARM64, x86, x64
  LWasmAtomicExchangeHeap(const LAllocation& ptr, const LAllocation& value,
                          const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, memoryBase);
    setTemp(0, LDefinition::BogusTemp());
  }
  // MIPS32, MIPS64
  LWasmAtomicExchangeHeap(const LAllocation& ptr, const LAllocation& value,
                          const LDefinition& valueTemp,
                          const LDefinition& offsetTemp,
                          const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, LAllocation());
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, valueTemp);
    setTemp(2, offsetTemp);
    setTemp(3, maskTemp);
  }

  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LAllocation* memoryBase() { return getOperand(2); }
  const LDefinition* addrTemp() { return getTemp(0); }

  void setAddrTemp(const LDefinition& addrTemp) { setTemp(0, addrTemp); }

  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(1); }
  const LDefinition* offsetTemp() { return getTemp(2); }
  const LDefinition* maskTemp() { return getTemp(3); }

  MWasmAtomicExchangeHeap* mir() const {
    return mir_->toWasmAtomicExchangeHeap();
  }
};

class LWasmAtomicBinopHeap : public LInstructionHelper<1, 3, 6> {
 public:
  LIR_HEADER(WasmAtomicBinopHeap);

  static const int32_t valueOp = 1;

  // ARM, ARM64, x86, x64
  LWasmAtomicBinopHeap(const LAllocation& ptr, const LAllocation& value,
                       const LDefinition& temp,
                       const LDefinition& flagTemp = LDefinition::BogusTemp(),
                       const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, memoryBase);
    setTemp(0, temp);
    setTemp(1, LDefinition::BogusTemp());
    setTemp(2, flagTemp);
  }
  // MIPS32, MIPS64
  LWasmAtomicBinopHeap(const LAllocation& ptr, const LAllocation& value,
                       const LDefinition& valueTemp,
                       const LDefinition& offsetTemp,
                       const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, LAllocation());
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, LDefinition::BogusTemp());
    setTemp(2, LDefinition::BogusTemp());
    setTemp(3, valueTemp);
    setTemp(4, offsetTemp);
    setTemp(5, maskTemp);
  }
  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* value() {
    MOZ_ASSERT(valueOp == 1);
    return getOperand(1);
  }
  const LAllocation* memoryBase() { return getOperand(2); }
  const LDefinition* temp() { return getTemp(0); }

  // Temp that may be used on some platforms to hold a computed address.
  const LDefinition* addrTemp() { return getTemp(1); }
  void setAddrTemp(const LDefinition& addrTemp) { setTemp(1, addrTemp); }

  // Temp that may be used on LL/SC platforms for the flag result of the store.
  const LDefinition* flagTemp() { return getTemp(2); }
  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(3); }
  const LDefinition* offsetTemp() { return getTemp(4); }
  const LDefinition* maskTemp() { return getTemp(5); }

  MWasmAtomicBinopHeap* mir() const { return mir_->toWasmAtomicBinopHeap(); }
};

// Atomic binary operation where the result is discarded.
class LWasmAtomicBinopHeapForEffect : public LInstructionHelper<0, 3, 5> {
 public:
  LIR_HEADER(WasmAtomicBinopHeapForEffect);
  // ARM, ARM64, x86, x64
  LWasmAtomicBinopHeapForEffect(
      const LAllocation& ptr, const LAllocation& value,
      const LDefinition& flagTemp = LDefinition::BogusTemp(),
      const LAllocation& memoryBase = LAllocation())
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, memoryBase);
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, flagTemp);
  }
  // MIPS32, MIPS64
  LWasmAtomicBinopHeapForEffect(const LAllocation& ptr,
                                const LAllocation& value,
                                const LDefinition& valueTemp,
                                const LDefinition& offsetTemp,
                                const LDefinition& maskTemp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, ptr);
    setOperand(1, value);
    setOperand(2, LAllocation());
    setTemp(0, LDefinition::BogusTemp());
    setTemp(1, LDefinition::BogusTemp());
    setTemp(2, valueTemp);
    setTemp(3, offsetTemp);
    setTemp(4, maskTemp);
  }
  const LAllocation* ptr() { return getOperand(0); }
  const LAllocation* value() { return getOperand(1); }
  const LAllocation* memoryBase() { return getOperand(2); }

  // Temp that may be used on some platforms to hold a computed address.
  const LDefinition* addrTemp() { return getTemp(0); }
  void setAddrTemp(const LDefinition& addrTemp) { setTemp(0, addrTemp); }

  // Temp that may be used on LL/SC platforms for the flag result of the store.
  const LDefinition* flagTemp() { return getTemp(1); }
  // Temp that may be used on LL/SC platforms for extract/insert bits of word.
  const LDefinition* valueTemp() { return getTemp(2); }
  const LDefinition* offsetTemp() { return getTemp(3); }
  const LDefinition* maskTemp() { return getTemp(4); }

  MWasmAtomicBinopHeap* mir() const { return mir_->toWasmAtomicBinopHeap(); }
};

class LWasmLoadSlot : public LInstructionHelper<1, 1, 0> {
  size_t offset_;
  MIRType type_;

 public:
  LIR_HEADER(WasmLoadSlot);
  explicit LWasmLoadSlot(const LAllocation& containerRef, size_t offset,
                         MIRType type)
      : LInstructionHelper(classOpcode), offset_(offset), type_(type) {
    setOperand(0, containerRef);
  }
  const LAllocation* containerRef() { return getOperand(0); }
  size_t offset() const { return offset_; }
  MIRType type() const { return type_; }
};

class LWasmLoadSlotI64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
  size_t offset_;

 public:
  LIR_HEADER(WasmLoadSlotI64);
  explicit LWasmLoadSlotI64(const LAllocation& containerRef, size_t offset)
      : LInstructionHelper(classOpcode), offset_(offset) {
    setOperand(0, containerRef);
  }
  const LAllocation* containerRef() { return getOperand(0); }
  size_t offset() const { return offset_; }
};

class LWasmStoreSlot : public LInstructionHelper<0, 2, 0> {
  size_t offset_;
  MIRType type_;

 public:
  LIR_HEADER(WasmStoreSlot);
  LWasmStoreSlot(const LAllocation& value, const LAllocation& containerRef,
                 size_t offset, MIRType type)
      : LInstructionHelper(classOpcode), offset_(offset), type_(type) {
    setOperand(0, value);
    setOperand(1, containerRef);
  }
  const LAllocation* value() { return getOperand(0); }
  const LAllocation* containerRef() { return getOperand(1); }
  size_t offset() const { return offset_; }
  MIRType type() const { return type_; }
};

class LWasmStoreSlotI64 : public LInstructionHelper<0, INT64_PIECES + 1, 0> {
  size_t offset_;

 public:
  LIR_HEADER(WasmStoreSlotI64);
  LWasmStoreSlotI64(const LInt64Allocation& value,
                    const LAllocation& containerRef, size_t offset)
      : LInstructionHelper(classOpcode), offset_(offset) {
    setInt64Operand(0, value);
    setOperand(INT64_PIECES, containerRef);
  }
  const LInt64Allocation value() { return getInt64Operand(0); }
  const LAllocation* containerRef() { return getOperand(INT64_PIECES); }
  size_t offset() const { return offset_; }
};

class LWasmDerivedPointer : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmDerivedPointer);
  explicit LWasmDerivedPointer(const LAllocation& base)
      : LInstructionHelper(classOpcode) {
    setOperand(0, base);
  }
  const LAllocation* base() { return getOperand(0); }
  size_t offset() { return mirRaw()->toWasmDerivedPointer()->offset(); }
};

class LWasmStoreRef : public LInstructionHelper<0, 3, 1> {
 public:
  LIR_HEADER(WasmStoreRef);
  LWasmStoreRef(const LAllocation& tls, const LAllocation& valueAddr,
                const LAllocation& value, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, tls);
    setOperand(1, valueAddr);
    setOperand(2, value);
    setTemp(0, temp);
  }
  MWasmStoreRef* mir() const { return mirRaw()->toWasmStoreRef(); }
  const LAllocation* tls() { return getOperand(0); }
  const LAllocation* valueAddr() { return getOperand(1); }
  const LAllocation* value() { return getOperand(2); }
  const LDefinition* temp() { return getTemp(0); }
};

class LWasmParameter : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(WasmParameter);

  LWasmParameter() : LInstructionHelper(classOpcode) {}
};

class LWasmParameterI64 : public LInstructionHelper<INT64_PIECES, 0, 0> {
 public:
  LIR_HEADER(WasmParameterI64);

  LWasmParameterI64() : LInstructionHelper(classOpcode) {}
};

class LWasmReturn : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(WasmReturn);

  LWasmReturn() : LInstructionHelper(classOpcode) {}
};

class LWasmReturnI64 : public LInstructionHelper<0, INT64_PIECES, 0> {
 public:
  LIR_HEADER(WasmReturnI64)

  explicit LWasmReturnI64(const LInt64Allocation& input)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, input);
  }
};

class LWasmReturnVoid : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(WasmReturnVoid);

  LWasmReturnVoid() : LInstructionHelper(classOpcode) {}
};

class LWasmStackArg : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(WasmStackArg);
  explicit LWasmStackArg(const LAllocation& arg)
      : LInstructionHelper(classOpcode) {
    setOperand(0, arg);
  }
  MWasmStackArg* mir() const { return mirRaw()->toWasmStackArg(); }
  const LAllocation* arg() { return getOperand(0); }
};

class LWasmStackArgI64 : public LInstructionHelper<0, INT64_PIECES, 0> {
 public:
  LIR_HEADER(WasmStackArgI64);
  explicit LWasmStackArgI64(const LInt64Allocation& arg)
      : LInstructionHelper(classOpcode) {
    setInt64Operand(0, arg);
  }
  MWasmStackArg* mir() const { return mirRaw()->toWasmStackArg(); }
  const LInt64Allocation arg() { return getInt64Operand(0); }
};

class LWasmNullConstant : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(WasmNullConstant);
  explicit LWasmNullConstant() : LInstructionHelper(classOpcode) {}
};

class LWasmCall : public LVariadicInstruction<0, 0> {
  bool needsBoundsCheck_;

 public:
  LIR_HEADER(WasmCall);

  LWasmCall(uint32_t numOperands, bool needsBoundsCheck)
      : LVariadicInstruction(classOpcode, numOperands),
        needsBoundsCheck_(needsBoundsCheck) {
    this->setIsCall();
  }

  MWasmCall* mir() const { return mir_->toWasmCall(); }

  static bool isCallPreserved(AnyRegister reg) {
    // All MWasmCalls preserve the TLS register:
    //  - internal/indirect calls do by the internal wasm ABI
    //  - import calls do by explicitly saving/restoring at the callsite
    //  - builtin calls do because the TLS reg is non-volatile
    // See also CodeGeneratorShared::emitWasmCall.
    return !reg.isFloat() && reg.gpr() == WasmTlsReg;
  }

  bool needsBoundsCheck() const { return needsBoundsCheck_; }
};

class LWasmRegisterResult : public LInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(WasmRegisterResult);

  LWasmRegisterResult() : LInstructionHelper(classOpcode) {}

  MWasmRegisterResult* mir() const {
    if (!mir_->isWasmRegisterResult()) {
      return nullptr;
    }
    return mir_->toWasmRegisterResult();
  }
};

class LWasmRegisterPairResult : public LInstructionHelper<2, 0, 0> {
 public:
  LIR_HEADER(WasmRegisterPairResult);

  LWasmRegisterPairResult() : LInstructionHelper(classOpcode) {}

  MDefinition* mir() const { return mirRaw(); }
};

class LWasmStackResultArea : public LInstructionHelper<1, 0, 1> {
 public:
  LIR_HEADER(WasmStackResultArea);

  explicit LWasmStackResultArea(const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp);
  }

  MWasmStackResultArea* mir() const { return mir_->toWasmStackResultArea(); }
  const LDefinition* temp() { return getTemp(0); }
};

inline uint32_t LStackArea::base() const {
  return ins()->toWasmStackResultArea()->mir()->base();
}
inline void LStackArea::setBase(uint32_t base) {
  ins()->toWasmStackResultArea()->mir()->setBase(base);
}
inline uint32_t LStackArea::size() const {
  return ins()->toWasmStackResultArea()->mir()->byteSize();
}

inline bool LStackArea::ResultIterator::done() const {
  return idx_ == alloc_.ins()->toWasmStackResultArea()->mir()->resultCount();
}
inline void LStackArea::ResultIterator::next() {
  MOZ_ASSERT(!done());
  idx_++;
}
inline LAllocation LStackArea::ResultIterator::alloc() const {
  MOZ_ASSERT(!done());
  MWasmStackResultArea* area = alloc_.ins()->toWasmStackResultArea()->mir();
  return LStackSlot(area->base() - area->result(idx_).offset());
}
inline bool LStackArea::ResultIterator::isGcPointer() const {
  MOZ_ASSERT(!done());
  MWasmStackResultArea* area = alloc_.ins()->toWasmStackResultArea()->mir();
  MIRType type = area->result(idx_).type();
#ifndef JS_PUNBOX64
  // LDefinition::TypeFrom isn't defined for MIRType::Int64 values on
  // this platform, so here we have a special case.
  if (type == MIRType::Int64) {
    return false;
  }
#endif
  return LDefinition::TypeFrom(type) == LDefinition::OBJECT;
}

class LWasmStackResult : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmStackResult);

  LWasmStackResult() : LInstructionHelper(classOpcode) {}

  MWasmStackResult* mir() const { return mir_->toWasmStackResult(); }
  LStackSlot result(uint32_t base) const {
    return LStackSlot(base - mir()->result().offset());
  }
};

class LWasmStackResult64 : public LInstructionHelper<INT64_PIECES, 1, 0> {
 public:
  LIR_HEADER(WasmStackResult64);

  LWasmStackResult64() : LInstructionHelper(classOpcode) {}

  MWasmStackResult* mir() const { return mir_->toWasmStackResult(); }
  LStackSlot result(uint32_t base, LDefinition* def) {
    uint32_t offset = base - mir()->result().offset();
#if defined(JS_NUNBOX32)
    if (def == getDef(INT64LOW_INDEX)) {
      offset -= INT64LOW_OFFSET;
    } else {
      MOZ_ASSERT(def == getDef(INT64HIGH_INDEX));
      offset -= INT64HIGH_OFFSET;
    }
#else
    MOZ_ASSERT(def == getDef(0));
#endif
    return LStackSlot(offset);
  }
};

inline LStackSlot LStackArea::resultAlloc(LInstruction* lir,
                                          LDefinition* def) const {
  if (lir->isWasmStackResult64()) {
    return lir->toWasmStackResult64()->result(base(), def);
  }
  MOZ_ASSERT(def == lir->getDef(0));
  return lir->toWasmStackResult()->result(base());
}

inline bool LNode::isCallPreserved(AnyRegister reg) const {
  return isWasmCall() && LWasmCall::isCallPreserved(reg);
}

class LAssertRangeI : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(AssertRangeI)

  explicit LAssertRangeI(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const LAllocation* input() { return getOperand(0); }

  MAssertRange* mir() { return mir_->toAssertRange(); }
  const Range* range() { return mir()->assertedRange(); }
};

class LAssertRangeD : public LInstructionHelper<0, 1, 1> {
 public:
  LIR_HEADER(AssertRangeD)

  LAssertRangeD(const LAllocation& input, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
  }

  const LAllocation* input() { return getOperand(0); }

  const LDefinition* temp() { return getTemp(0); }

  MAssertRange* mir() { return mir_->toAssertRange(); }
  const Range* range() { return mir()->assertedRange(); }
};

class LAssertRangeF : public LInstructionHelper<0, 1, 2> {
 public:
  LIR_HEADER(AssertRangeF)
  LAssertRangeF(const LAllocation& input, const LDefinition& temp,
                const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
    setTemp(0, temp);
    setTemp(1, temp2);
  }

  const LAllocation* input() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }

  MAssertRange* mir() { return mir_->toAssertRange(); }
  const Range* range() { return mir()->assertedRange(); }
};

class LAssertRangeV : public LInstructionHelper<0, BOX_PIECES, 3> {
 public:
  LIR_HEADER(AssertRangeV)

  LAssertRangeV(const LBoxAllocation& input, const LDefinition& temp,
                const LDefinition& floatTemp1, const LDefinition& floatTemp2)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
    setTemp(0, temp);
    setTemp(1, floatTemp1);
    setTemp(2, floatTemp2);
  }

  static const size_t Input = 0;

  const LDefinition* temp() { return getTemp(0); }
  const LDefinition* floatTemp1() { return getTemp(1); }
  const LDefinition* floatTemp2() { return getTemp(2); }

  MAssertRange* mir() { return mir_->toAssertRange(); }
  const Range* range() { return mir()->assertedRange(); }
};

class LAssertResultT : public LInstructionHelper<0, 1, 0> {
 public:
  LIR_HEADER(AssertResultT)

  explicit LAssertResultT(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(0, input);
  }

  const LAllocation* input() { return getOperand(0); }
};

class LAssertResultV : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(AssertResultV)

  static const size_t Input = 0;

  explicit LAssertResultV(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }
};

class LGuardValue : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(GuardValue)

  explicit LGuardValue(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;

  MGuardValue* mir() { return mir_->toGuardValue(); }
};

class LGuardNullOrUndefined : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(GuardNullOrUndefined)

  explicit LGuardNullOrUndefined(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;

  MGuardNullOrUndefined* mir() { return mir_->toGuardNullOrUndefined(); }
};

class LRecompileCheck : public LInstructionHelper<0, 0, 1> {
 public:
  LIR_HEADER(RecompileCheck)

  explicit LRecompileCheck(const LDefinition& scratch)
      : LInstructionHelper(classOpcode) {
    setTemp(0, scratch);
  }

  const LDefinition* scratch() { return getTemp(0); }
  MRecompileCheck* mir() { return mir_->toRecompileCheck(); }
};

class LLexicalCheck : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(LexicalCheck)

  explicit LLexicalCheck(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  MLexicalCheck* mir() { return mir_->toLexicalCheck(); }

  static const size_t Input = 0;
};

class LThrowRuntimeLexicalError : public LCallInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(ThrowRuntimeLexicalError)

  LThrowRuntimeLexicalError() : LCallInstructionHelper(classOpcode) {}

  MThrowRuntimeLexicalError* mir() {
    return mir_->toThrowRuntimeLexicalError();
  }
};

class LGlobalNameConflictsCheck : public LInstructionHelper<0, 0, 0> {
 public:
  LIR_HEADER(GlobalNameConflictsCheck)

  LGlobalNameConflictsCheck() : LInstructionHelper(classOpcode) {}

  MGlobalNameConflictsCheck* mir() {
    return mir_->toGlobalNameConflictsCheck();
  }
};

class LMemoryBarrier : public LInstructionHelper<0, 0, 0> {
 private:
  const MemoryBarrierBits type_;

 public:
  LIR_HEADER(MemoryBarrier)

  // The parameter 'type' is a bitwise 'or' of the barrier types needed,
  // see AtomicOp.h.
  explicit LMemoryBarrier(MemoryBarrierBits type)
      : LInstructionHelper(classOpcode), type_(type) {
    MOZ_ASSERT((type_ & ~MembarAllbits) == MembarNobits);
  }

  MemoryBarrierBits type() const { return type_; }
};

class LDebugger : public LCallInstructionHelper<0, 0, 2> {
 public:
  LIR_HEADER(Debugger)

  LDebugger(const LDefinition& temp1, const LDefinition& temp2)
      : LCallInstructionHelper(classOpcode) {
    setTemp(0, temp1);
    setTemp(1, temp2);
  }
};

class LNewTarget : public LInstructionHelper<BOX_PIECES, 0, 0> {
 public:
  LIR_HEADER(NewTarget)

  LNewTarget() : LInstructionHelper(classOpcode) {}
};

class LArrowNewTarget : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  explicit LArrowNewTarget(const LAllocation& callee)
      : LInstructionHelper(classOpcode) {
    setOperand(0, callee);
  }

  LIR_HEADER(ArrowNewTarget)

  const LAllocation* callee() { return getOperand(0); }
};

// Math.random().
#ifdef JS_PUNBOX64
#  define LRANDOM_NUM_TEMPS 3
#else
#  define LRANDOM_NUM_TEMPS 5
#endif

class LRandom : public LInstructionHelper<1, 0, LRANDOM_NUM_TEMPS> {
 public:
  LIR_HEADER(Random)
  LRandom(const LDefinition& temp0, const LDefinition& temp1,
          const LDefinition& temp2
#ifndef JS_PUNBOX64
          ,
          const LDefinition& temp3, const LDefinition& temp4
#endif
          )
      : LInstructionHelper(classOpcode) {
    setTemp(0, temp0);
    setTemp(1, temp1);
    setTemp(2, temp2);
#ifndef JS_PUNBOX64
    setTemp(3, temp3);
    setTemp(4, temp4);
#endif
  }
  const LDefinition* temp0() { return getTemp(0); }
  const LDefinition* temp1() { return getTemp(1); }
  const LDefinition* temp2() { return getTemp(2); }
#ifndef JS_PUNBOX64
  const LDefinition* temp3() { return getTemp(3); }
  const LDefinition* temp4() { return getTemp(4); }
#endif

  MRandom* mir() const { return mir_->toRandom(); }
};

class LCheckReturn : public LInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0> {
 public:
  LIR_HEADER(CheckReturn)

  LCheckReturn(const LBoxAllocation& retVal, const LBoxAllocation& thisVal)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(ReturnValue, retVal);
    setBoxOperand(ThisValue, thisVal);
  }

  static const size_t ReturnValue = 0;
  static const size_t ThisValue = BOX_PIECES;
};

class LCheckIsObj : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CheckIsObj)

  static const size_t CheckValue = 0;

  explicit LCheckIsObj(const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(CheckValue, value);
  }

  MCheckIsObj* mir() const { return mir_->toCheckIsObj(); }
};

class LCheckObjCoercible : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CheckObjCoercible)

  static const size_t CheckValue = 0;

  explicit LCheckObjCoercible(const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(CheckValue, value);
  }
};

class LCheckClassHeritage : public LInstructionHelper<0, BOX_PIECES, 1> {
 public:
  LIR_HEADER(CheckClassHeritage)

  static const size_t Heritage = 0;

  LCheckClassHeritage(const LBoxAllocation& value, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Heritage, value);
    setTemp(0, temp);
  }

  const LDefinition* temp() { return getTemp(0); }
};

class LCheckThis : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CheckThis)

  static const size_t ThisValue = 0;

  explicit LCheckThis(const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(ThisValue, value);
  }
};

class LCheckThisReinit : public LInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(CheckThisReinit)

  static const size_t ThisValue = 0;

  explicit LCheckThisReinit(const LBoxAllocation& value)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(ThisValue, value);
  }
};

class LDebugCheckSelfHosted : public LCallInstructionHelper<0, BOX_PIECES, 0> {
 public:
  LIR_HEADER(DebugCheckSelfHosted)

  static const size_t CheckValue = 0;

  explicit LDebugCheckSelfHosted(const LBoxAllocation& value)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(CheckValue, value);
  }
};

class LFinishBoundFunctionInit : public LInstructionHelper<0, 3, 2> {
 public:
  LIR_HEADER(FinishBoundFunctionInit)

  LFinishBoundFunctionInit(const LAllocation& bound, const LAllocation& target,
                           const LAllocation& argCount,
                           const LDefinition& temp1, const LDefinition& temp2)
      : LInstructionHelper(classOpcode) {
    setOperand(0, bound);
    setOperand(1, target);
    setOperand(2, argCount);
    setTemp(0, temp1);
    setTemp(1, temp2);
  }

  const LAllocation* bound() { return getOperand(0); }
  const LAllocation* target() { return getOperand(1); }
  const LAllocation* argCount() { return getOperand(2); }
  const LDefinition* temp1() { return getTemp(0); }
  const LDefinition* temp2() { return getTemp(1); }
};

class LIsPackedArray : public LInstructionHelper<1, 1, 1> {
 public:
  LIR_HEADER(IsPackedArray)

  LIsPackedArray(const LAllocation& array, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, array);
    setTemp(0, temp);
  }

  const LAllocation* array() { return getOperand(0); }
  const LDefinition* temp() { return getTemp(0); }
};

class LGetPrototypeOf : public LInstructionHelper<BOX_PIECES, 1, 0> {
 public:
  LIR_HEADER(GetPrototypeOf)

  explicit LGetPrototypeOf(const LAllocation& target)
      : LInstructionHelper(classOpcode) {
    setOperand(0, target);
  }

  const LAllocation* target() { return getOperand(0); }
};

class LObjectWithProto : public LCallInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(ObjectWithProto)

  static const size_t PrototypeValue = 0;

  explicit LObjectWithProto(const LBoxAllocation& prototype)
      : LCallInstructionHelper(classOpcode) {
    setBoxOperand(PrototypeValue, prototype);
  }
};

class LObjectStaticProto : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(ObjectStaticProto)

  explicit LObjectStaticProto(const LAllocation& object)
      : LInstructionHelper(classOpcode) {
    setOperand(0, object);
  }
};

class LFunctionProto : public LCallInstructionHelper<1, 0, 0> {
 public:
  LIR_HEADER(FunctionProto)

  LFunctionProto() : LCallInstructionHelper(classOpcode) {}

  MFunctionProto* mir() const { return mir_->toFunctionProto(); }
};

class LSuperFunction : public LInstructionHelper<BOX_PIECES, 1, 1> {
 public:
  LIR_HEADER(SuperFunction)

  explicit LSuperFunction(const LAllocation& callee, const LDefinition& temp)
      : LInstructionHelper(classOpcode) {
    setOperand(0, callee);
    setTemp(0, temp);
  }

  const LAllocation* callee() { return getOperand(0); }
  const LDefinition* temp() { return this->getTemp(0); }
};

class LInitHomeObject : public LInstructionHelper<0, 1 + BOX_PIECES, 0> {
 public:
  LIR_HEADER(InitHomeObject)

  static const size_t HomeObjectValue = 1;

  LInitHomeObject(const LAllocation& function, const LBoxAllocation& homeObject)
      : LInstructionHelper(classOpcode) {
    setOperand(0, function);
    setBoxOperand(HomeObjectValue, homeObject);
  }

  const LAllocation* function() { return getOperand(0); }
};

template <size_t NumDefs>
class LIonToWasmCallBase : public LVariadicInstruction<NumDefs, 2> {
  using Base = LVariadicInstruction<NumDefs, 2>;

 public:
  explicit LIonToWasmCallBase(LNode::Opcode classOpcode, uint32_t numOperands,
                              const LDefinition& temp, const LDefinition& fp)
      : Base(classOpcode, numOperands) {
    this->setIsCall();
    this->setTemp(0, temp);
    this->setTemp(1, fp);
  }
  MIonToWasmCall* mir() const { return this->mir_->toIonToWasmCall(); }
  const LDefinition* temp() { return this->getTemp(0); }
};

class LIonToWasmCall : public LIonToWasmCallBase<1> {
 public:
  LIR_HEADER(IonToWasmCall);
  LIonToWasmCall(uint32_t numOperands, const LDefinition& temp,
                 const LDefinition& fp)
      : LIonToWasmCallBase<1>(classOpcode, numOperands, temp, fp) {}
};

class LIonToWasmCallV : public LIonToWasmCallBase<BOX_PIECES> {
 public:
  LIR_HEADER(IonToWasmCallV);
  LIonToWasmCallV(uint32_t numOperands, const LDefinition& temp,
                  const LDefinition& fp)
      : LIonToWasmCallBase<BOX_PIECES>(classOpcode, numOperands, temp, fp) {}
};

class LIonToWasmCallI64 : public LIonToWasmCallBase<INT64_PIECES> {
 public:
  LIR_HEADER(IonToWasmCallI64);
  LIonToWasmCallI64(uint32_t numOperands, const LDefinition& temp,
                    const LDefinition& fp)
      : LIonToWasmCallBase<INT64_PIECES>(classOpcode, numOperands, temp, fp) {}
};

class LWasmBoxValue : public LInstructionHelper<1, BOX_PIECES, 0> {
 public:
  LIR_HEADER(WasmBoxValue)

  explicit LWasmBoxValue(const LBoxAllocation& input)
      : LInstructionHelper(classOpcode) {
    setBoxOperand(Input, input);
  }

  static const size_t Input = 0;
};

class LWasmAnyRefFromJSObject : public LInstructionHelper<1, 1, 0> {
 public:
  LIR_HEADER(WasmAnyRefFromJSObject)

  explicit LWasmAnyRefFromJSObject(const LAllocation& input)
      : LInstructionHelper(classOpcode) {
    setOperand(Input, input);
  }

  static const size_t Input = 0;
};

}  // namespace jit
}  // namespace js

#endif /* jit_shared_LIR_shared_h */
