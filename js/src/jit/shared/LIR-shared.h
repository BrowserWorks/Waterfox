/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_shared_LIR_shared_h
#define jit_shared_LIR_shared_h

#include "jsutil.h"

#include "jit/AtomicOp.h"
#include "jit/shared/Assembler-shared.h"

// This file declares LIR instructions that are common to every platform.

namespace js {
namespace jit {

class LBox : public LInstructionHelper<BOX_PIECES, 1, 0>
{
    MIRType type_;

  public:
    LIR_HEADER(Box);

    LBox(const LAllocation& payload, MIRType type)
      : type_(type)
    {
        setOperand(0, payload);
    }

    MIRType type() const {
        return type_;
    }
    const char* extraName() const {
        return StringFromMIRType(type_);
    }
};

template <size_t Temps, size_t ExtraUses = 0>
class LBinaryMath : public LInstructionHelper<1, 2 + ExtraUses, Temps>
{
  public:
    const LAllocation* lhs() {
        return this->getOperand(0);
    }
    const LAllocation* rhs() {
        return this->getOperand(1);
    }
};

// An LOsiPoint captures a snapshot after a call and ensures enough space to
// patch in a call to the invalidation mechanism.
//
// Note: LSafepoints are 1:1 with LOsiPoints, so it holds a reference to the
// corresponding LSafepoint to inform it of the LOsiPoint's masm offset when it
// gets CG'd.
class LOsiPoint : public LInstructionHelper<0, 0, 0>
{
    LSafepoint* safepoint_;

  public:
    LOsiPoint(LSafepoint* safepoint, LSnapshot* snapshot)
      : safepoint_(safepoint)
    {
        MOZ_ASSERT(safepoint && snapshot);
        assignSnapshot(snapshot);
    }

    LSafepoint* associatedSafepoint() {
        return safepoint_;
    }

    LIR_HEADER(OsiPoint)
};

class LMove
{
    LAllocation from_;
    LAllocation to_;
    LDefinition::Type type_;

  public:
    LMove(LAllocation from, LAllocation to, LDefinition::Type type)
      : from_(from),
        to_(to),
        type_(type)
    { }

    LAllocation from() const {
        return from_;
    }
    LAllocation to() const {
        return to_;
    }
    LDefinition::Type type() const {
        return type_;
    }
};

class LMoveGroup : public LInstructionHelper<0, 0, 0>
{
    js::Vector<LMove, 2, JitAllocPolicy> moves_;

#ifdef JS_CODEGEN_X86
    // Optional general register available for use when executing moves.
    LAllocation scratchRegister_;
#endif

    explicit LMoveGroup(TempAllocator& alloc)
      : moves_(alloc)
    { }

  public:
    LIR_HEADER(MoveGroup)

    static LMoveGroup* New(TempAllocator& alloc) {
        return new(alloc) LMoveGroup(alloc);
    }

    void printOperands(GenericPrinter& out);

    // Add a move which takes place simultaneously with all others in the group.
    bool add(LAllocation from, LAllocation to, LDefinition::Type type);

    // Add a move which takes place after existing moves in the group.
    bool addAfter(LAllocation from, LAllocation to, LDefinition::Type type);

    size_t numMoves() const {
        return moves_.length();
    }
    const LMove& getMove(size_t i) const {
        return moves_[i];
    }

#ifdef JS_CODEGEN_X86
    void setScratchRegister(Register reg) {
        scratchRegister_ = LGeneralReg(reg);
    }
    LAllocation maybeScratchRegister() {
        return scratchRegister_;
    }
#endif

    bool uses(Register reg) {
        for (size_t i = 0; i < numMoves(); i++) {
            LMove move = getMove(i);
            if (move.from() == LGeneralReg(reg) || move.to() == LGeneralReg(reg))
                return true;
        }
        return false;
    }
};


// Constructs a SIMD object (value type) based on the MIRType of its input.
class LSimdBox : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(SimdBox)

    explicit LSimdBox(const LAllocation& simd, const LDefinition& temp)
    {
        setOperand(0, simd);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MSimdBox* mir() const {
        return mir_->toSimdBox();
    }
};

class LSimdUnbox : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(SimdUnbox)

    LSimdUnbox(const LAllocation& obj, const LDefinition& temp)
    {
        setOperand(0, obj);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MSimdUnbox* mir() const {
        return mir_->toSimdUnbox();
    }
};

// Constructs a SIMD value with 16 equal components (int8x16).
class LSimdSplatX16 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdSplatX16)
    explicit LSimdSplatX16(const LAllocation& v)
    {
        setOperand(0, v);
    }

    MSimdSplat* mir() const {
        return mir_->toSimdSplat();
    }
};

// Constructs a SIMD value with 8 equal components (int16x8).
class LSimdSplatX8 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdSplatX8)
    explicit LSimdSplatX8(const LAllocation& v)
    {
        setOperand(0, v);
    }

    MSimdSplat* mir() const {
        return mir_->toSimdSplat();
    }
};

// Constructs a SIMD value with 4 equal components (e.g. int32x4, float32x4).
class LSimdSplatX4 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdSplatX4)
    explicit LSimdSplatX4(const LAllocation& v)
    {
        setOperand(0, v);
    }

    MSimdSplat* mir() const {
        return mir_->toSimdSplat();
    }
};

// Reinterpret the bits of a SIMD value with a different type.
class LSimdReinterpretCast : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdReinterpretCast)
    explicit LSimdReinterpretCast(const LAllocation& v)
    {
        setOperand(0, v);
    }

    MSimdReinterpretCast* mir() const {
        return mir_->toSimdReinterpretCast();
    }
};

class LSimdExtractElementBase : public LInstructionHelper<1, 1, 0>
{
  protected:
    explicit LSimdExtractElementBase(const LAllocation& base) {
        setOperand(0, base);
    }

  public:
    const LAllocation* getBase() {
        return getOperand(0);
    }
    MSimdExtractElement* mir() const {
        return mir_->toSimdExtractElement();
    }
};

// Extracts an element from a given SIMD bool32x4 lane.
class LSimdExtractElementB : public LSimdExtractElementBase
{
  public:
    LIR_HEADER(SimdExtractElementB);
    explicit LSimdExtractElementB(const LAllocation& base)
      : LSimdExtractElementBase(base)
    {}
};

// Extracts an element from a given SIMD int32x4 lane.
class LSimdExtractElementI : public LSimdExtractElementBase
{
  public:
    LIR_HEADER(SimdExtractElementI);
    explicit LSimdExtractElementI(const LAllocation& base)
      : LSimdExtractElementBase(base)
    {}
};

// Extracts an element from a given SIMD float32x4 lane.
class LSimdExtractElementF : public LSimdExtractElementBase
{
  public:
    LIR_HEADER(SimdExtractElementF);
    explicit LSimdExtractElementF(const LAllocation& base)
      : LSimdExtractElementBase(base)
    {}
};

// Extracts an element from an Uint32x4 SIMD vector, converts to double.
class LSimdExtractElementU2D : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(SimdExtractElementU2D);
    explicit LSimdExtractElementU2D(const LAllocation& base, const LDefinition& temp) {
        setOperand(0, base);
        setTemp(0, temp);
    }
    MSimdExtractElement* mir() const {
        return mir_->toSimdExtractElement();
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};


class LSimdInsertElementBase : public LInstructionHelper<1, 2, 0>
{
  protected:
    LSimdInsertElementBase(const LAllocation& vec, const LAllocation& val)
    {
        setOperand(0, vec);
        setOperand(1, val);
    }

  public:
    const LAllocation* vector() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    unsigned lane() const {
        return mir_->toSimdInsertElement()->lane();
    }
    unsigned length() const {
        return SimdTypeToLength(mir_->toSimdInsertElement()->type());
    }
};

// Replace an element from a given SIMD integer or boolean lane with a given value.
// The value inserted into a boolean lane should be 0 or -1.
class LSimdInsertElementI : public LSimdInsertElementBase
{
  public:
    LIR_HEADER(SimdInsertElementI);
    LSimdInsertElementI(const LAllocation& vec, const LAllocation& val)
      : LSimdInsertElementBase(vec, val)
    {}
};

// Replace an element from a given SIMD float32x4 lane with a given value.
class LSimdInsertElementF : public LSimdInsertElementBase
{
  public:
    LIR_HEADER(SimdInsertElementF);
    LSimdInsertElementF(const LAllocation& vec, const LAllocation& val)
      : LSimdInsertElementBase(vec, val)
    {}
};

// Base class for both int32x4 and float32x4 shuffle instructions.
class LSimdSwizzleBase : public LInstructionHelper<1, 1, 1>
{
  public:
    explicit LSimdSwizzleBase(const LAllocation& base)
    {
        setOperand(0, base);
    }

    const LAllocation* getBase() {
        return getOperand(0);
    }

    unsigned numLanes() const { return mir_->toSimdSwizzle()->numLanes(); }
    uint32_t lane(unsigned i) const { return mir_->toSimdSwizzle()->lane(i); }

    bool lanesMatch(uint32_t x, uint32_t y, uint32_t z, uint32_t w) const {
        return mir_->toSimdSwizzle()->lanesMatch(x, y, z, w);
    }
};

// Shuffles a int32x4 into another int32x4 vector.
class LSimdSwizzleI : public LSimdSwizzleBase
{
  public:
    LIR_HEADER(SimdSwizzleI);
    explicit LSimdSwizzleI(const LAllocation& base) : LSimdSwizzleBase(base)
    {}
};
// Shuffles a float32x4 into another float32x4 vector.
class LSimdSwizzleF : public LSimdSwizzleBase
{
  public:
    LIR_HEADER(SimdSwizzleF);
    explicit LSimdSwizzleF(const LAllocation& base) : LSimdSwizzleBase(base)
    {}
};

class LSimdGeneralShuffleBase : public LVariadicInstruction<1, 1>
{
  public:
    explicit LSimdGeneralShuffleBase(const LDefinition& temp) {
        setTemp(0, temp);
    }
    const LAllocation* vector(unsigned i) {
        MOZ_ASSERT(i < mir()->numVectors());
        return getOperand(i);
    }
    const LAllocation* lane(unsigned i) {
        MOZ_ASSERT(i < mir()->numLanes());
        return getOperand(mir()->numVectors() + i);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MSimdGeneralShuffle* mir() const {
        return mir_->toSimdGeneralShuffle();
    }
};

class LSimdGeneralShuffleI : public LSimdGeneralShuffleBase
{
  public:
    LIR_HEADER(SimdGeneralShuffleI);
    explicit LSimdGeneralShuffleI(const LDefinition& temp)
      : LSimdGeneralShuffleBase(temp)
    {}
};

class LSimdGeneralShuffleF : public LSimdGeneralShuffleBase
{
  public:
    LIR_HEADER(SimdGeneralShuffleF);
    explicit LSimdGeneralShuffleF(const LDefinition& temp)
      : LSimdGeneralShuffleBase(temp)
    {}
};

// Base class for both int32x4 and float32x4 shuffle instructions.
class LSimdShuffleX4 : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(SimdShuffleX4);
    LSimdShuffleX4()
    {}

    const LAllocation* lhs() {
        return getOperand(0);
    }
    const LAllocation* rhs() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    uint32_t lane(unsigned i) const { return mir_->toSimdShuffle()->lane(i); }

    bool lanesMatch(uint32_t x, uint32_t y, uint32_t z, uint32_t w) const {
        return mir_->toSimdShuffle()->lanesMatch(x, y, z, w);
    }
};

// Remaining shuffles (8x16, 16x8).
class LSimdShuffle : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(SimdShuffle);
    LSimdShuffle()
    {}

    const LAllocation* lhs() {
        return getOperand(0);
    }
    const LAllocation* rhs() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    unsigned numLanes() const { return mir_->toSimdShuffle()->numLanes(); }
    unsigned lane(unsigned i) const { return mir_->toSimdShuffle()->lane(i); }
};

// Binary SIMD comparison operation between two SIMD operands
class LSimdBinaryComp: public LInstructionHelper<1, 2, 0>
{
  protected:
    LSimdBinaryComp() {}

public:
    const LAllocation* lhs() {
        return getOperand(0);
    }
    const LAllocation* rhs() {
        return getOperand(1);
    }
    MSimdBinaryComp::Operation operation() const {
        return mir_->toSimdBinaryComp()->operation();
    }
    const char* extraName() const {
        return MSimdBinaryComp::OperationName(operation());
    }
};

// Binary SIMD comparison operation between two Int8x16 operands.
class LSimdBinaryCompIx16 : public LSimdBinaryComp
{
  public:
    LIR_HEADER(SimdBinaryCompIx16);
    LSimdBinaryCompIx16() : LSimdBinaryComp() {}
};

// Binary SIMD comparison operation between two Int16x8 operands.
class LSimdBinaryCompIx8 : public LSimdBinaryComp
{
  public:
    LIR_HEADER(SimdBinaryCompIx8);
    LSimdBinaryCompIx8() : LSimdBinaryComp() {}
};

// Binary SIMD comparison operation between two Int32x4 operands.
class LSimdBinaryCompIx4 : public LSimdBinaryComp
{
  public:
    LIR_HEADER(SimdBinaryCompIx4);
    LSimdBinaryCompIx4() : LSimdBinaryComp() {}
};

// Binary SIMD comparison operation between two Float32x4 operands
class LSimdBinaryCompFx4 : public LSimdBinaryComp
{
  public:
    LIR_HEADER(SimdBinaryCompFx4);
    LSimdBinaryCompFx4() : LSimdBinaryComp() {}
};

// Binary SIMD arithmetic operation between two SIMD operands
class LSimdBinaryArith : public LInstructionHelper<1, 2, 1>
{
  public:
    LSimdBinaryArith() {}

    const LAllocation* lhs() {
        return this->getOperand(0);
    }
    const LAllocation* rhs() {
        return this->getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    MSimdBinaryArith::Operation operation() const {
        return this->mir_->toSimdBinaryArith()->operation();
    }
    const char* extraName() const {
        return MSimdBinaryArith::OperationName(operation());
    }
};

// Binary SIMD arithmetic operation between two Int8x16 operands
class LSimdBinaryArithIx16 : public LSimdBinaryArith
{
  public:
    LIR_HEADER(SimdBinaryArithIx16);
    LSimdBinaryArithIx16() : LSimdBinaryArith() {}
};

// Binary SIMD arithmetic operation between two Int16x8 operands
class LSimdBinaryArithIx8 : public LSimdBinaryArith
{
  public:
    LIR_HEADER(SimdBinaryArithIx8);
    LSimdBinaryArithIx8() : LSimdBinaryArith() {}
};

// Binary SIMD arithmetic operation between two Int32x4 operands
class LSimdBinaryArithIx4 : public LSimdBinaryArith
{
  public:
    LIR_HEADER(SimdBinaryArithIx4);
    LSimdBinaryArithIx4() : LSimdBinaryArith() {}
};

// Binary SIMD arithmetic operation between two Float32x4 operands
class LSimdBinaryArithFx4 : public LSimdBinaryArith
{
  public:
    LIR_HEADER(SimdBinaryArithFx4);
    LSimdBinaryArithFx4() : LSimdBinaryArith() {}
};

// Binary SIMD saturating arithmetic operation between two SIMD operands
class LSimdBinarySaturating : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(SimdBinarySaturating);
    LSimdBinarySaturating() {}

    const LAllocation* lhs() {
        return this->getOperand(0);
    }
    const LAllocation* rhs() {
        return this->getOperand(1);
    }

    MSimdBinarySaturating::Operation operation() const {
        return this->mir_->toSimdBinarySaturating()->operation();
    }
    SimdSign signedness() const {
        return this->mir_->toSimdBinarySaturating()->signedness();
    }
    MIRType type() const {
        return mir_->type();
    }
    const char* extraName() const {
        return MSimdBinarySaturating::OperationName(operation());
    }
};

// Unary SIMD arithmetic operation on a SIMD operand
class LSimdUnaryArith : public LInstructionHelper<1, 1, 0>
{
  public:
    explicit LSimdUnaryArith(const LAllocation& in) {
        setOperand(0, in);
    }
    MSimdUnaryArith::Operation operation() const {
        return mir_->toSimdUnaryArith()->operation();
    }
};

// Unary SIMD arithmetic operation on a Int8x16 operand
class LSimdUnaryArithIx16 : public LSimdUnaryArith
{
  public:
    LIR_HEADER(SimdUnaryArithIx16);
    explicit LSimdUnaryArithIx16(const LAllocation& in) : LSimdUnaryArith(in) {}
};

// Unary SIMD arithmetic operation on a Int16x8 operand
class LSimdUnaryArithIx8 : public LSimdUnaryArith
{
  public:
    LIR_HEADER(SimdUnaryArithIx8);
    explicit LSimdUnaryArithIx8(const LAllocation& in) : LSimdUnaryArith(in) {}
};

// Unary SIMD arithmetic operation on a Int32x4 operand
class LSimdUnaryArithIx4 : public LSimdUnaryArith
{
  public:
    LIR_HEADER(SimdUnaryArithIx4);
    explicit LSimdUnaryArithIx4(const LAllocation& in) : LSimdUnaryArith(in) {}
};

// Unary SIMD arithmetic operation on a Float32x4 operand
class LSimdUnaryArithFx4 : public LSimdUnaryArith
{
  public:
    LIR_HEADER(SimdUnaryArithFx4);
    explicit LSimdUnaryArithFx4(const LAllocation& in) : LSimdUnaryArith(in) {}
};

// Binary SIMD bitwise operation between two 128-bit operands.
class LSimdBinaryBitwise : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(SimdBinaryBitwise);
    const LAllocation* lhs() {
        return getOperand(0);
    }
    const LAllocation* rhs() {
        return getOperand(1);
    }
    MSimdBinaryBitwise::Operation operation() const {
        return mir_->toSimdBinaryBitwise()->operation();
    }
    const char* extraName() const {
        return MSimdBinaryBitwise::OperationName(operation());
    }
    MIRType type() const {
        return mir_->type();
    }
};

// Shift a SIMD vector by a scalar amount.
// The temp register is only required if the shift amount is a dynamical
// value. If it is a constant, use a BogusTemp instead.
class LSimdShift : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(SimdShift)
    LSimdShift(const LAllocation& vec, const LAllocation& val, const LDefinition& temp) {
        setOperand(0, vec);
        setOperand(1, val);
        setTemp(0, temp);
    }
    const LAllocation* vector() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MSimdShift::Operation operation() const {
        return mir_->toSimdShift()->operation();
    }
    const char* extraName() const {
        return MSimdShift::OperationName(operation());
    }
    MSimdShift* mir() const {
        return mir_->toSimdShift();
    }
    MIRType type() const {
        return mir_->type();
    }
};

// SIMD selection of lanes from two int32x4 or float32x4 arguments based on a
// int32x4 argument.
class LSimdSelect : public LInstructionHelper<1, 3, 1>
{
  public:
    LIR_HEADER(SimdSelect);
    const LAllocation* mask() {
        return getOperand(0);
    }
    const LAllocation* lhs() {
        return getOperand(1);
    }
    const LAllocation* rhs() {
        return getOperand(2);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MSimdSelect* mir() const {
        return mir_->toSimdSelect();
    }
};

class LSimdAnyTrue : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdAnyTrue)
    explicit LSimdAnyTrue(const LAllocation& input) {
        setOperand(0, input);
    }
    const LAllocation* vector() {
        return getOperand(0);
    }
    MSimdAnyTrue* mir() const {
        return mir_->toSimdAnyTrue();
    }
};

class LSimdAllTrue : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SimdAllTrue)
    explicit LSimdAllTrue(const LAllocation& input) {
        setOperand(0, input);
    }
    const LAllocation* vector() {
        return getOperand(0);
    }
    MSimdAllTrue* mir() const {
        return mir_->toSimdAllTrue();
    }
};


// Constant 32-bit integer.
class LInteger : public LInstructionHelper<1, 0, 0>
{
    int32_t i32_;

  public:
    LIR_HEADER(Integer)

    explicit LInteger(int32_t i32)
      : i32_(i32)
    { }

    int32_t getValue() const {
        return i32_;
    }
};

// Constant 64-bit integer.
class LInteger64 : public LInstructionHelper<INT64_PIECES, 0, 0>
{
    int64_t i64_;

  public:
    LIR_HEADER(Integer64)

    explicit LInteger64(int64_t i64)
      : i64_(i64)
    { }

    int64_t getValue() const {
        return i64_;
    }
};

// Constant pointer.
class LPointer : public LInstructionHelper<1, 0, 0>
{
  public:
    enum Kind {
        GC_THING,
        NON_GC_THING
    };

  private:
    void* ptr_;
    Kind kind_;

  public:
    LIR_HEADER(Pointer)

    explicit LPointer(gc::Cell* ptr)
      : ptr_(ptr), kind_(GC_THING)
    { }

    LPointer(void* ptr, Kind kind)
      : ptr_(ptr), kind_(kind)
    { }

    void* ptr() const {
        return ptr_;
    }
    Kind kind() const {
        return kind_;
    }
    const char* extraName() const {
        return kind_ == GC_THING ? "GC_THING" : "NON_GC_THING";
    }

    gc::Cell* gcptr() const {
        MOZ_ASSERT(kind() == GC_THING);
        return (gc::Cell*) ptr_;
    }
};

// Constant double.
class LDouble : public LInstructionHelper<1, 0, 0>
{
    double d_;
  public:
    LIR_HEADER(Double);

    explicit LDouble(double d) : d_(d)
    { }

    const double& getDouble() const {
        return d_;
    }
};

// Constant float32.
class LFloat32 : public LInstructionHelper<1, 0, 0>
{
    float f_;
  public:
    LIR_HEADER(Float32);

    explicit LFloat32(float f)
      : f_(f)
    { }

    const float& getFloat() const {
        return f_;
    }
};

// Constant 128-bit SIMD integer vector (8x16, 16x8, 32x4).
// Also used for Bool32x4, Bool16x8, etc.
class LSimd128Int : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(Simd128Int);

    explicit LSimd128Int() {}
    const SimdConstant& getValue() const { return mir_->toSimdConstant()->value(); }
};

// Constant 128-bit SIMD floating point vector (32x4, 64x2).
class LSimd128Float : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(Simd128Float);

    explicit LSimd128Float() {}
    const SimdConstant& getValue() const { return mir_->toSimdConstant()->value(); }
};

// A constant Value.
class LValue : public LInstructionHelper<BOX_PIECES, 0, 0>
{
    Value v_;

  public:
    LIR_HEADER(Value)

    explicit LValue(const Value& v)
      : v_(v)
    { }

    Value value() const {
        return v_;
    }
};

// Clone an object literal such as we are not modifying the object contained in
// the sources.
class LCloneLiteral : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CloneLiteral)

    explicit LCloneLiteral(const LAllocation& obj)
    {
        setOperand(0, obj);
    }

    const LAllocation* getObjectLiteral() {
        return getOperand(0);
    }

    MCloneLiteral* mir() const {
        return mir_->toCloneLiteral();
    }
};

// Formal argument for a function, returning a box. Formal arguments are
// initially read from the stack.
class LParameter : public LInstructionHelper<BOX_PIECES, 0, 0>
{
  public:
    LIR_HEADER(Parameter)
};

// Stack offset for a word-sized immutable input value to a frame.
class LCallee : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(Callee)
};

class LIsConstructing : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(IsConstructing)
};

// Base class for control instructions (goto, branch, etc.)
template <size_t Succs, size_t Operands, size_t Temps>
class LControlInstructionHelper : public LInstructionHelper<0, Operands, Temps> {

    mozilla::Array<MBasicBlock*, Succs> successors_;

  public:
    virtual size_t numSuccessors() const final override { return Succs; }

    virtual MBasicBlock* getSuccessor(size_t i) const final override {
        return successors_[i];
    }

    virtual void setSuccessor(size_t i, MBasicBlock* successor) final override {
        successors_[i] = successor;
    }
};

// Jumps to the start of a basic block.
class LGoto : public LControlInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(Goto)

    explicit LGoto(MBasicBlock* block)
    {
         setSuccessor(0, block);
    }

    MBasicBlock* target() const {
        return getSuccessor(0);
    }
};

class LNewArray : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewArray)

    explicit LNewArray(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const char* extraName() const {
        return mir()->isVMCall() ? "VMCall" : nullptr;
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewArray* mir() const {
        return mir_->toNewArray();
    }
};

class LNewArrayCopyOnWrite : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewArrayCopyOnWrite)

    explicit LNewArrayCopyOnWrite(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewArrayCopyOnWrite* mir() const {
        return mir_->toNewArrayCopyOnWrite();
    }
};

class LNewArrayDynamicLength : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(NewArrayDynamicLength)

    explicit LNewArrayDynamicLength(const LAllocation& length, const LDefinition& temp) {
        setOperand(0, length);
        setTemp(0, temp);
    }

    const LAllocation* length() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewArrayDynamicLength* mir() const {
        return mir_->toNewArrayDynamicLength();
    }
};

class LNewIterator : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewIterator)

    explicit LNewIterator(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewIterator* mir() const {
        return mir_->toNewIterator();
    }
};

class LNewTypedArray : public LInstructionHelper<1, 0, 2>
{
  public:
    LIR_HEADER(NewTypedArray)

    explicit LNewTypedArray(const LDefinition& temp1, const LDefinition& temp2) {
        setTemp(0, temp1);
        setTemp(1, temp2);
    }

    const LDefinition* temp1() {
        return getTemp(0);
    }

    const LDefinition* temp2() {
        return getTemp(1);
    }

    MNewTypedArray* mir() const {
        return mir_->toNewTypedArray();
    }
};

class LNewTypedArrayDynamicLength : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(NewTypedArrayDynamicLength)

    explicit LNewTypedArrayDynamicLength(const LAllocation& length, const LDefinition& temp) {
        setOperand(0, length);
        setTemp(0, temp);
    }

    const LAllocation* length() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewTypedArrayDynamicLength* mir() const {
        return mir_->toNewTypedArrayDynamicLength();
    }
};

class LNewObject : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewObject)

    explicit LNewObject(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const char* extraName() const {
        return mir()->isVMCall() ? "VMCall" : nullptr;
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewObject* mir() const {
        return mir_->toNewObject();
    }
};

class LNewTypedObject : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewTypedObject)

    explicit LNewTypedObject(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewTypedObject* mir() const {
        return mir_->toNewTypedObject();
    }
};

// Allocates a new NamedLambdaObject.
//
// This instruction generates two possible instruction sets:
//   (1) An inline allocation of the call object is attempted.
//   (2) Otherwise, a callVM create a new object.
//
class LNewNamedLambdaObject : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewNamedLambdaObject);

    explicit LNewNamedLambdaObject(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewNamedLambdaObject* mir() const {
        return mir_->toNewNamedLambdaObject();
    }
};

// Allocates a new CallObject.
//
// This instruction generates two possible instruction sets:
//   (1) If the call object is extensible, this is a callVM to create the
//       call object.
//   (2) Otherwise, an inline allocation of the call object is attempted.
//
class LNewCallObject : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewCallObject)

    explicit LNewCallObject(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }


    MNewCallObject* mir() const {
        return mir_->toNewCallObject();
    }
};

// Performs a callVM to allocate a new CallObject with singleton type.
class LNewSingletonCallObject : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(NewSingletonCallObject)

    explicit LNewSingletonCallObject(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MNewSingletonCallObject* mir() const {
        return mir_->toNewSingletonCallObject();
    }
};

class LNewDerivedTypedObject : public LCallInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(NewDerivedTypedObject);

    LNewDerivedTypedObject(const LAllocation& type,
                           const LAllocation& owner,
                           const LAllocation& offset) {
        setOperand(0, type);
        setOperand(1, owner);
        setOperand(2, offset);
    }

    const LAllocation* type() {
        return getOperand(0);
    }

    const LAllocation* owner() {
        return getOperand(1);
    }

    const LAllocation* offset() {
        return getOperand(2);
    }
};

class LNewStringObject : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(NewStringObject)

    LNewStringObject(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }

    const LAllocation* input() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MNewStringObject* mir() const {
        return mir_->toNewStringObject();
    }
};

class LInitElem : public LCallInstructionHelper<0, 1 + 2*BOX_PIECES, 0>
{
  public:
    LIR_HEADER(InitElem)

    LInitElem(const LAllocation& object, const LBoxAllocation& id, const LBoxAllocation& value) {
        setOperand(0, object);
        setBoxOperand(IdIndex, id);
        setBoxOperand(ValueIndex, value);
    }

    static const size_t IdIndex = 1;
    static const size_t ValueIndex = 1 + BOX_PIECES;

    const LAllocation* getObject() {
        return getOperand(0);
    }
    MInitElem* mir() const {
        return mir_->toInitElem();
    }
};

class LInitElemGetterSetter : public LCallInstructionHelper<0, 2 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(InitElemGetterSetter)

    LInitElemGetterSetter(const LAllocation& object, const LBoxAllocation& id,
                          const LAllocation& value) {
        setOperand(0, object);
        setOperand(1, value);
        setBoxOperand(IdIndex, id);
    }

    static const size_t IdIndex = 2;

    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    MInitElemGetterSetter* mir() const {
        return mir_->toInitElemGetterSetter();
    }
};

// Takes in an Object and a Value.
class LMutateProto : public LCallInstructionHelper<0, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(MutateProto)

    LMutateProto(const LAllocation& object, const LBoxAllocation& value) {
        setOperand(0, object);
        setBoxOperand(ValueIndex, value);
    }

    static const size_t ValueIndex = 1;

    const LAllocation* getObject() {
        return getOperand(0);
    }
    const LAllocation* getValue() {
        return getOperand(1);
    }
};

// Takes in an Object and a Value.
class LInitProp : public LCallInstructionHelper<0, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(InitProp)

    LInitProp(const LAllocation& object, const LBoxAllocation& value) {
        setOperand(0, object);
        setBoxOperand(ValueIndex, value);
    }

    static const size_t ValueIndex = 1;

    const LAllocation* getObject() {
        return getOperand(0);
    }
    const LAllocation* getValue() {
        return getOperand(1);
    }

    MInitProp* mir() const {
        return mir_->toInitProp();
    }
};

class LInitPropGetterSetter : public LCallInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(InitPropGetterSetter)

    LInitPropGetterSetter(const LAllocation& object, const LAllocation& value) {
        setOperand(0, object);
        setOperand(1, value);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }

    MInitPropGetterSetter* mir() const {
        return mir_->toInitPropGetterSetter();
    }
};

class LCheckOverRecursed : public LInstructionHelper<0, 0, 1>
{
  public:
    LIR_HEADER(CheckOverRecursed)

    explicit LCheckOverRecursed(const LDefinition& temp) {
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MCheckOverRecursed* mir() const {
        return mir_->toCheckOverRecursed();
    }
};

class LWasmTrap : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(WasmTrap);

    LWasmTrap()
    { }

    const MWasmTrap* mir() const {
        return mir_->toWasmTrap();
    }
};

template<size_t Defs, size_t Ops>
class LWasmReinterpretBase : public LInstructionHelper<Defs, Ops, 0>
{
    typedef LInstructionHelper<Defs, Ops, 0> Base;

  public:
    const LAllocation* input() {
        return Base::getOperand(0);
    }
    MWasmReinterpret* mir() const {
        return Base::mir_->toWasmReinterpret();
    }
};

class LWasmReinterpret : public LWasmReinterpretBase<1, 1>
{
  public:
    LIR_HEADER(WasmReinterpret);
    explicit LWasmReinterpret(const LAllocation& input) {
        setOperand(0, input);
    }
};

class LWasmReinterpretFromI64 : public LWasmReinterpretBase<1, INT64_PIECES>
{
  public:
    LIR_HEADER(WasmReinterpretFromI64);
    explicit LWasmReinterpretFromI64(const LInt64Allocation& input) {
        setInt64Operand(0, input);
    }
};

class LWasmReinterpretToI64 : public LWasmReinterpretBase<INT64_PIECES, 1>
{
  public:
    LIR_HEADER(WasmReinterpretToI64);
    explicit LWasmReinterpretToI64(const LAllocation& input) {
        setOperand(0, input);
    }
};

namespace details {
    template<size_t Defs, size_t Ops, size_t Temps>
    class RotateBase : public LInstructionHelper<Defs, Ops, Temps>
    {
        typedef LInstructionHelper<Defs, Ops, Temps> Base;
      public:
        MRotate* mir() {
            return Base::mir_->toRotate();
        }
    };
} // details

class LRotate : public details::RotateBase<1, 2, 0>
{
  public:
    LIR_HEADER(Rotate);

    const LAllocation* input() { return getOperand(0); }
    LAllocation* count() { return getOperand(1); }
};

class LRotateI64 : public details::RotateBase<INT64_PIECES, INT64_PIECES + 1, 1>
{
  public:
    LIR_HEADER(RotateI64);

    LRotateI64()
    {
        setTemp(0, LDefinition::BogusTemp());
    }

    static const size_t Input = 0;
    static const size_t Count = INT64_PIECES;

    const LInt64Allocation input() { return getInt64Operand(Input); }
    const LDefinition* temp() { return getTemp(0); }
    LAllocation* count() { return getOperand(Count); }
};

class LInterruptCheck : public LInstructionHelper<0, 0, 1>
{
    Label* oolEntry_;

    // Whether this is an implicit interrupt check. Implicit interrupt checks
    // use a patchable backedge and signal handlers instead of an explicit
    // cx->interrupt check.
    bool implicit_;

  public:
    LIR_HEADER(InterruptCheck)

    explicit LInterruptCheck(const LDefinition& temp)
      : oolEntry_(nullptr),
        implicit_(false)
    {
        setTemp(0, temp);
    }

    Label* oolEntry() {
        MOZ_ASSERT(implicit_);
        return oolEntry_;
    }

    void setOolEntry(Label* oolEntry) {
        MOZ_ASSERT(implicit_);
        oolEntry_ = oolEntry;
    }
    MInterruptCheck* mir() const {
        return mir_->toInterruptCheck();
    }

    void setImplicit() {
        implicit_ = true;
        setTemp(0, LDefinition::BogusTemp());
    }
    bool implicit() const {
        return implicit_;
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

class LDefVar : public LCallInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(DefVar)

    explicit LDefVar(const LAllocation& envChain)
    {
        setOperand(0, envChain);
    }

    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    MDefVar* mir() const {
        return mir_->toDefVar();
    }
};

class LDefLexical : public LCallInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(DefLexical)

    MDefLexical* mir() const {
        return mir_->toDefLexical();
    }
};

class LDefFun : public LCallInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(DefFun)

    LDefFun(const LAllocation& fun, const LAllocation& envChain)
    {
        setOperand(0, fun);
        setOperand(1, envChain);
    }

    const LAllocation* fun() {
        return getOperand(0);
    }
    const LAllocation* environmentChain() {
        return getOperand(1);
    }
    MDefFun* mir() const {
        return mir_->toDefFun();
    }
};

class LTypeOfV : public LInstructionHelper<1, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(TypeOfV)

    LTypeOfV(const LBoxAllocation& input, const LDefinition& tempToUnbox) {
        setBoxOperand(Input, input);
        setTemp(0, tempToUnbox);
    }

    static const size_t Input = 0;

    const LDefinition* tempToUnbox() {
        return getTemp(0);
    }

    MTypeOf* mir() const {
        return mir_->toTypeOf();
    }
};

class LToAsync : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ToAsync)
    explicit LToAsync(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* unwrapped() {
        return getOperand(0);
    }
};

class LToAsyncGen : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ToAsyncGen)
    explicit LToAsyncGen(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* unwrapped() {
        return getOperand(0);
    }
};

class LToAsyncIter : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ToAsyncIter)
    explicit LToAsyncIter(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* unwrapped() {
        return getOperand(0);
    }
};

class LToIdV : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(ToIdV)

    LToIdV(const LBoxAllocation& input, const LDefinition& temp)
    {
        setBoxOperand(Input, input);
        setTemp(0, temp);
    }

    static const size_t Input = 0;

    MToId* mir() const {
        return mir_->toToId();
    }

    const LDefinition* tempFloat() {
        return getTemp(0);
    }
};

// Allocate an object for |new| on the caller-side,
// when there is no templateObject or prototype known
class LCreateThis : public LCallInstructionHelper<BOX_PIECES, 2, 0>
{
  public:
    LIR_HEADER(CreateThis)

    LCreateThis(const LAllocation& callee, const LAllocation& newTarget)
    {
        setOperand(0, callee);
        setOperand(1, newTarget);
    }

    const LAllocation* getCallee() {
        return getOperand(0);
    }
    const LAllocation* getNewTarget() {
        return getOperand(1);
    }

    MCreateThis* mir() const {
        return mir_->toCreateThis();
    }
};

// Allocate an object for |new| on the caller-side,
// when the prototype is known.
class LCreateThisWithProto : public LCallInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(CreateThisWithProto)

    LCreateThisWithProto(const LAllocation& callee, const LAllocation& newTarget,
                         const LAllocation& prototype)
    {
        setOperand(0, callee);
        setOperand(1, newTarget);
        setOperand(2, prototype);
    }

    const LAllocation* getCallee() {
        return getOperand(0);
    }
    const LAllocation* getNewTarget() {
        return getOperand(1);
    }
    const LAllocation* getPrototype() {
        return getOperand(2);
    }

    MCreateThis* mir() const {
        return mir_->toCreateThis();
    }
};

// Allocate an object for |new| on the caller-side.
// Always performs object initialization with a fast path.
class LCreateThisWithTemplate : public LInstructionHelper<1, 0, 1>
{
  public:
    LIR_HEADER(CreateThisWithTemplate)

    explicit LCreateThisWithTemplate(const LDefinition& temp) {
        setTemp(0, temp);
    }

    MCreateThisWithTemplate* mir() const {
        return mir_->toCreateThisWithTemplate();
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Allocate a new arguments object for the frame.
class LCreateArgumentsObject : public LCallInstructionHelper<1, 1, 3>
{
  public:
    LIR_HEADER(CreateArgumentsObject)

    LCreateArgumentsObject(const LAllocation& callObj, const LDefinition& temp0,
                           const LDefinition& temp1, const LDefinition& temp2)
    {
        setOperand(0, callObj);
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
    }

    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
    const LDefinition* temp2() {
        return getTemp(2);
    }

    const LAllocation* getCallObject() {
        return getOperand(0);
    }

    MCreateArgumentsObject* mir() const {
        return mir_->toCreateArgumentsObject();
    }
};

// Get argument from arguments object.
class LGetArgumentsObjectArg : public LInstructionHelper<BOX_PIECES, 1, 1>
{
  public:
    LIR_HEADER(GetArgumentsObjectArg)

    LGetArgumentsObjectArg(const LAllocation& argsObj, const LDefinition& temp)
    {
        setOperand(0, argsObj);
        setTemp(0, temp);
    }

    const LAllocation* getArgsObject() {
        return getOperand(0);
    }

    MGetArgumentsObjectArg* mir() const {
        return mir_->toGetArgumentsObjectArg();
    }
};

// Set argument on arguments object.
class LSetArgumentsObjectArg : public LInstructionHelper<0, 1 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(SetArgumentsObjectArg)

    LSetArgumentsObjectArg(const LAllocation& argsObj, const LBoxAllocation& value,
                           const LDefinition& temp)
    {
        setOperand(0, argsObj);
        setBoxOperand(ValueIndex, value);
        setTemp(0, temp);
    }

    const LAllocation* getArgsObject() {
        return getOperand(0);
    }

    MSetArgumentsObjectArg* mir() const {
        return mir_->toSetArgumentsObjectArg();
    }

    static const size_t ValueIndex = 1;
};

// If the Value is an Object, return unbox(Value).
// Otherwise, return the other Object.
class LReturnFromCtor : public LInstructionHelper<1, BOX_PIECES + 1, 0>
{
  public:
    LIR_HEADER(ReturnFromCtor)

    LReturnFromCtor(const LBoxAllocation& value, const LAllocation& object)
    {
        setBoxOperand(ValueIndex, value);
        setOperand(ObjectIndex, object);
    }

    const LAllocation* getObject() {
        return getOperand(ObjectIndex);
    }

    static const size_t ValueIndex = 0;
    static const size_t ObjectIndex = BOX_PIECES;
};

class LComputeThis : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(ComputeThis)

    static const size_t ValueIndex = 0;

    explicit LComputeThis(const LBoxAllocation& value) {
        setBoxOperand(ValueIndex, value);
    }

    const LDefinition* output() {
        return getDef(0);
    }

    MComputeThis* mir() const {
        return mir_->toComputeThis();
    }
};

// Writes a typed argument for a function call to the frame's argument vector.
class LStackArgT : public LInstructionHelper<0, 1, 0>
{
    uint32_t argslot_; // Index into frame-scope argument vector.
    MIRType type_;

  public:
    LIR_HEADER(StackArgT)

    LStackArgT(uint32_t argslot, MIRType type, const LAllocation& arg)
      : argslot_(argslot),
        type_(type)
    {
        setOperand(0, arg);
    }
    uint32_t argslot() const {
        return argslot_;
    }
    MIRType type() const {
        return type_;
    }
    const LAllocation* getArgument() {
        return getOperand(0);
    }
};

// Writes an untyped argument for a function call to the frame's argument vector.
class LStackArgV : public LInstructionHelper<0, BOX_PIECES, 0>
{
    uint32_t argslot_; // Index into frame-scope argument vector.

  public:
    LIR_HEADER(StackArgV)

    LStackArgV(uint32_t argslot, const LBoxAllocation& value)
      : argslot_(argslot)
    {
        setBoxOperand(0, value);
    }

    uint32_t argslot() const {
        return argslot_;
    }
};

// Common code for LIR descended from MCall.
template <size_t Defs, size_t Operands, size_t Temps>
class LJSCallInstructionHelper : public LCallInstructionHelper<Defs, Operands, Temps>
{
  public:
    uint32_t argslot() const {
        if (JitStackValueAlignment > 1)
            return AlignBytes(mir()->numStackArgs(), JitStackValueAlignment);
        return mir()->numStackArgs();
    }
    MCall* mir() const {
        return this->mir_->toCall();
    }

    bool hasSingleTarget() const {
        return getSingleTarget() != nullptr;
    }
    WrappedFunction* getSingleTarget() const {
        return mir()->getSingleTarget();
    }

    // Does not include |this|.
    uint32_t numActualArgs() const {
        return mir()->numActualArgs();
    }

    bool isConstructing() const {
        return mir()->isConstructing();
    }
    bool ignoresReturnValue() const {
        return mir()->ignoresReturnValue();
    }
};

// Generates a polymorphic callsite, wherein the function being called is
// unknown and anticipated to vary.
class LCallGeneric : public LJSCallInstructionHelper<BOX_PIECES, 1, 2>
{
  public:
    LIR_HEADER(CallGeneric)

    LCallGeneric(const LAllocation& func, const LDefinition& nargsreg,
                 const LDefinition& tmpobjreg)
    {
        setOperand(0, func);
        setTemp(0, nargsreg);
        setTemp(1, tmpobjreg);
    }

    const LAllocation* getFunction() {
        return getOperand(0);
    }
    const LDefinition* getNargsReg() {
        return getTemp(0);
    }
    const LDefinition* getTempObject() {
        return getTemp(1);
    }
};

// Generates a hardcoded callsite for a known, non-native target.
class LCallKnown : public LJSCallInstructionHelper<BOX_PIECES, 1, 1>
{
  public:
    LIR_HEADER(CallKnown)

    LCallKnown(const LAllocation& func, const LDefinition& tmpobjreg)
    {
        setOperand(0, func);
        setTemp(0, tmpobjreg);
    }

    const LAllocation* getFunction() {
        return getOperand(0);
    }
    const LDefinition* getTempObject() {
        return getTemp(0);
    }
};

// Generates a hardcoded callsite for a known, native target.
class LCallNative : public LJSCallInstructionHelper<BOX_PIECES, 0, 4>
{
  public:
    LIR_HEADER(CallNative)

    LCallNative(const LDefinition& argContext, const LDefinition& argUintN,
                const LDefinition& argVp, const LDefinition& tmpreg)
    {
        // Registers used for callWithABI().
        setTemp(0, argContext);
        setTemp(1, argUintN);
        setTemp(2, argVp);

        // Temporary registers.
        setTemp(3, tmpreg);
    }

    const LDefinition* getArgContextReg() {
        return getTemp(0);
    }
    const LDefinition* getArgUintNReg() {
        return getTemp(1);
    }
    const LDefinition* getArgVpReg() {
        return getTemp(2);
    }
    const LDefinition* getTempReg() {
        return getTemp(3);
    }
};

// Generates a hardcoded callsite for a known, DOM-native target.
class LCallDOMNative : public LJSCallInstructionHelper<BOX_PIECES, 0, 4>
{
  public:
    LIR_HEADER(CallDOMNative)

    LCallDOMNative(const LDefinition& argJSContext, const LDefinition& argObj,
                   const LDefinition& argPrivate, const LDefinition& argArgs)
    {
        setTemp(0, argJSContext);
        setTemp(1, argObj);
        setTemp(2, argPrivate);
        setTemp(3, argArgs);
    }

    const LDefinition* getArgJSContext() {
        return getTemp(0);
    }
    const LDefinition* getArgObj() {
        return getTemp(1);
    }
    const LDefinition* getArgPrivate() {
        return getTemp(2);
    }
    const LDefinition* getArgArgs() {
        return getTemp(3);
    }
};

class LBail : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(Bail)
};

class LUnreachable : public LControlInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(Unreachable)
};

class LEncodeSnapshot : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(EncodeSnapshot)
};

template <size_t defs, size_t ops>
class LDOMPropertyInstructionHelper : public LCallInstructionHelper<defs, 1 + ops, 3>
{
  protected:
    LDOMPropertyInstructionHelper(const LDefinition& JSContextReg, const LAllocation& ObjectReg,
                                  const LDefinition& PrivReg, const LDefinition& ValueReg)
    {
        this->setOperand(0, ObjectReg);
        this->setTemp(0, JSContextReg);
        this->setTemp(1, PrivReg);
        this->setTemp(2, ValueReg);
    }

  public:
    const LDefinition* getJSContextReg() {
        return this->getTemp(0);
    }
    const LAllocation* getObjectReg() {
        return this->getOperand(0);
    }
    const LDefinition* getPrivReg() {
        return this->getTemp(1);
    }
    const LDefinition* getValueReg() {
        return this->getTemp(2);
    }
};


class LGetDOMProperty : public LDOMPropertyInstructionHelper<BOX_PIECES, 0>
{
  public:
    LIR_HEADER(GetDOMProperty)

    LGetDOMProperty(const LDefinition& JSContextReg, const LAllocation& ObjectReg,
                    const LDefinition& PrivReg, const LDefinition& ValueReg)
      : LDOMPropertyInstructionHelper<BOX_PIECES, 0>(JSContextReg, ObjectReg,
                                                     PrivReg, ValueReg)
    { }

    MGetDOMProperty* mir() const {
        return mir_->toGetDOMProperty();
    }
};

class LGetDOMMemberV : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(GetDOMMemberV);
    explicit LGetDOMMemberV(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    MGetDOMMember* mir() const {
        return mir_->toGetDOMMember();
    }
};

class LGetDOMMemberT : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(GetDOMMemberT);
    explicit LGetDOMMemberT(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    MGetDOMMember* mir() const {
        return mir_->toGetDOMMember();
    }
};

class LSetDOMProperty : public LDOMPropertyInstructionHelper<0, BOX_PIECES>
{
  public:
    LIR_HEADER(SetDOMProperty)

    LSetDOMProperty(const LDefinition& JSContextReg, const LAllocation& ObjectReg,
                    const LBoxAllocation& value, const LDefinition& PrivReg,
                    const LDefinition& ValueReg)
      : LDOMPropertyInstructionHelper<0, BOX_PIECES>(JSContextReg, ObjectReg,
                                                     PrivReg, ValueReg)
    {
        setBoxOperand(Value, value);
    }

    static const size_t Value = 1;

    MSetDOMProperty* mir() const {
        return mir_->toSetDOMProperty();
    }
};

// Generates a polymorphic callsite, wherein the function being called is
// unknown and anticipated to vary.
class LApplyArgsGeneric : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES + 2, 2>
{
  public:
    LIR_HEADER(ApplyArgsGeneric)

    LApplyArgsGeneric(const LAllocation& func, const LAllocation& argc,
                      const LBoxAllocation& thisv, const LDefinition& tmpobjreg,
                      const LDefinition& tmpcopy)
    {
        setOperand(0, func);
        setOperand(1, argc);
        setBoxOperand(ThisIndex, thisv);
        setTemp(0, tmpobjreg);
        setTemp(1, tmpcopy);
    }

    MApplyArgs* mir() const {
        return mir_->toApplyArgs();
    }

    bool hasSingleTarget() const {
        return getSingleTarget() != nullptr;
    }
    WrappedFunction* getSingleTarget() const {
        return mir()->getSingleTarget();
    }

    const LAllocation* getFunction() {
        return getOperand(0);
    }
    const LAllocation* getArgc() {
        return getOperand(1);
    }
    static const size_t ThisIndex = 2;

    const LDefinition* getTempObject() {
        return getTemp(0);
    }
    const LDefinition* getTempStackCounter() {
        return getTemp(1);
    }
};

class LApplyArrayGeneric : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES + 2, 2>
{
  public:
    LIR_HEADER(ApplyArrayGeneric)

    LApplyArrayGeneric(const LAllocation& func, const LAllocation& elements,
                       const LBoxAllocation& thisv, const LDefinition& tmpobjreg,
                       const LDefinition& tmpcopy)
    {
        setOperand(0, func);
        setOperand(1, elements);
        setBoxOperand(ThisIndex, thisv);
        setTemp(0, tmpobjreg);
        setTemp(1, tmpcopy);
    }

    MApplyArray* mir() const {
        return mir_->toApplyArray();
    }

    bool hasSingleTarget() const {
        return getSingleTarget() != nullptr;
    }
    WrappedFunction* getSingleTarget() const {
        return mir()->getSingleTarget();
    }

    const LAllocation* getFunction() {
        return getOperand(0);
    }
    const LAllocation* getElements() {
        return getOperand(1);
    }
    // argc is mapped to the same register as elements: argc becomes
    // live as elements is dying, all registers are calltemps.
    const LAllocation* getArgc() {
        return getOperand(1);
    }
    static const size_t ThisIndex = 2;

    const LDefinition* getTempObject() {
        return getTemp(0);
    }
    const LDefinition* getTempStackCounter() {
        return getTemp(1);
    }
};

class LGetDynamicName : public LCallInstructionHelper<BOX_PIECES, 2, 3>
{
  public:
    LIR_HEADER(GetDynamicName)

    LGetDynamicName(const LAllocation& envChain, const LAllocation& name,
                    const LDefinition& temp1, const LDefinition& temp2, const LDefinition& temp3)
    {
        setOperand(0, envChain);
        setOperand(1, name);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, temp3);
    }

    MGetDynamicName* mir() const {
        return mir_->toGetDynamicName();
    }

    const LAllocation* getEnvironmentChain() {
        return getOperand(0);
    }
    const LAllocation* getName() {
        return getOperand(1);
    }

    const LDefinition* temp1() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }
    const LDefinition* temp3() {
        return getTemp(2);
    }
};

class LCallDirectEval : public LCallInstructionHelper<BOX_PIECES, 2 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallDirectEval)

    LCallDirectEval(const LAllocation& envChain, const LAllocation& string,
                    const LBoxAllocation& newTarget)
    {
        setOperand(0, envChain);
        setOperand(1, string);
        setBoxOperand(NewTarget, newTarget);
    }

    static const size_t NewTarget = 2;

    MCallDirectEval* mir() const {
        return mir_->toCallDirectEval();
    }

    const LAllocation* getEnvironmentChain() {
        return getOperand(0);
    }
    const LAllocation* getString() {
        return getOperand(1);
    }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestIAndBranch : public LControlInstructionHelper<2, 1, 0>
{
  public:
    LIR_HEADER(TestIAndBranch)

    LTestIAndBranch(const LAllocation& in, MBasicBlock* ifTrue, MBasicBlock* ifFalse)
    {
        setOperand(0, in);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

// Takes in an int64 input and tests it for truthiness.
class LTestI64AndBranch : public LControlInstructionHelper<2, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(TestI64AndBranch)

    LTestI64AndBranch(const LInt64Allocation& in, MBasicBlock* ifTrue, MBasicBlock* ifFalse)
    {
        setInt64Operand(0, in);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestDAndBranch : public LControlInstructionHelper<2, 1, 0>
{
  public:
    LIR_HEADER(TestDAndBranch)

    LTestDAndBranch(const LAllocation& in, MBasicBlock* ifTrue, MBasicBlock* ifFalse)
    {
        setOperand(0, in);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

// Takes in either an integer or boolean input and tests it for truthiness.
class LTestFAndBranch : public LControlInstructionHelper<2, 1, 0>
{
  public:
    LIR_HEADER(TestFAndBranch)

    LTestFAndBranch(const LAllocation& in, MBasicBlock* ifTrue, MBasicBlock* ifFalse)
    {
        setOperand(0, in);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

// Takes an object and tests it for truthiness.  An object is falsy iff it
// emulates |undefined|; see js::EmulatesUndefined.
class LTestOAndBranch : public LControlInstructionHelper<2, 1, 1>
{
  public:
    LIR_HEADER(TestOAndBranch)

    LTestOAndBranch(const LAllocation& input, MBasicBlock* ifTruthy, MBasicBlock* ifFalsy,
                    const LDefinition& temp)
    {
        setOperand(0, input);
        setSuccessor(0, ifTruthy);
        setSuccessor(1, ifFalsy);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MBasicBlock* ifTruthy() {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalsy() {
        return getSuccessor(1);
    }

    MTest* mir() {
        return mir_->toTest();
    }
};

// Takes in a boxed value and tests it for truthiness.
class LTestVAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 3>
{
  public:
    LIR_HEADER(TestVAndBranch)

    LTestVAndBranch(MBasicBlock* ifTruthy, MBasicBlock* ifFalsy, const LBoxAllocation& input,
                    const LDefinition& temp0, const LDefinition& temp1, const LDefinition& temp2)
    {
        setSuccessor(0, ifTruthy);
        setSuccessor(1, ifFalsy);
        setBoxOperand(Input, input);
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
    }

    const char* extraName() const {
        return mir()->operandMightEmulateUndefined() ? "MightEmulateUndefined" : nullptr;
    }

    static const size_t Input = 0;

    const LDefinition* tempFloat() {
        return getTemp(0);
    }

    const LDefinition* temp1() {
        return getTemp(1);
    }

    const LDefinition* temp2() {
        return getTemp(2);
    }

    MBasicBlock* ifTruthy() {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalsy() {
        return getSuccessor(1);
    }

    MTest* mir() const {
        return mir_->toTest();
    }
};

// Dispatches control flow to a successor based on incoming JSFunction*.
// Used to implemenent polymorphic inlining.
class LFunctionDispatch : public LInstructionHelper<0, 1, 0>
{
    // Dispatch is performed based on a function -> block map
    // stored in the MIR.

  public:
    LIR_HEADER(FunctionDispatch);

    explicit LFunctionDispatch(const LAllocation& in) {
        setOperand(0, in);
    }

    MFunctionDispatch* mir() const {
        return mir_->toFunctionDispatch();
    }
};

class LObjectGroupDispatch : public LInstructionHelper<0, 1, 1>
{
    // Dispatch is performed based on an ObjectGroup -> block
    // map inferred by the MIR.

  public:
    LIR_HEADER(ObjectGroupDispatch);

    const char* extraName() const {
        return mir()->hasFallback() ? "HasFallback" : "NoFallback";
    }

    LObjectGroupDispatch(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MObjectGroupDispatch* mir() const {
        return mir_->toObjectGroupDispatch();
    }
};

// Compares two integral values of the same JS type, either integer or object.
// For objects, both operands are in registers.
class LCompare : public LInstructionHelper<1, 2, 0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(Compare)
    LCompare(JSOp jsop, const LAllocation& left, const LAllocation& right)
      : jsop_(jsop)
    {
        setOperand(0, left);
        setOperand(1, right);
    }

    JSOp jsop() const {
        return jsop_;
    }
    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
    const char* extraName() const {
        return CodeName[jsop_];
    }
};

class LCompareI64 : public LInstructionHelper<1, 2 * INT64_PIECES, 0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(CompareI64)

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;

    LCompareI64(JSOp jsop, const LInt64Allocation& left, const LInt64Allocation& right)
      : jsop_(jsop)
    {
        setInt64Operand(Lhs, left);
        setInt64Operand(Rhs, right);
    }

    JSOp jsop() const {
        return jsop_;
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
    const char* extraName() const {
        return CodeName[jsop_];
    }
};

class LCompareI64AndBranch : public LControlInstructionHelper<2, 2 * INT64_PIECES, 0>
{
    MCompare* cmpMir_;
    JSOp jsop_;

  public:
    LIR_HEADER(CompareI64AndBranch)

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;

    LCompareI64AndBranch(MCompare* cmpMir, JSOp jsop,
                         const LInt64Allocation& left, const LInt64Allocation& right,
                         MBasicBlock* ifTrue, MBasicBlock* ifFalse)
      : cmpMir_(cmpMir), jsop_(jsop)
    {
        setInt64Operand(Lhs, left);
        setInt64Operand(Rhs, right);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    JSOp jsop() const {
        return jsop_;
    }
    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
    const char* extraName() const {
        return CodeName[jsop_];
    }
};

// Compares two integral values of the same JS type, either integer or object.
// For objects, both operands are in registers.
class LCompareAndBranch : public LControlInstructionHelper<2, 2, 0>
{
    MCompare* cmpMir_;
    JSOp jsop_;

  public:
    LIR_HEADER(CompareAndBranch)
    LCompareAndBranch(MCompare* cmpMir, JSOp jsop,
                      const LAllocation& left, const LAllocation& right,
                      MBasicBlock* ifTrue, MBasicBlock* ifFalse)
      : cmpMir_(cmpMir), jsop_(jsop)
    {
        setOperand(0, left);
        setOperand(1, right);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    JSOp jsop() const {
        return jsop_;
    }
    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
    const char* extraName() const {
        return CodeName[jsop_];
    }
};

class LCompareD : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(CompareD)
    LCompareD(const LAllocation& left, const LAllocation& right) {
        setOperand(0, left);
        setOperand(1, right);
    }

    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
};

class LCompareF : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(CompareF)
    LCompareF(const LAllocation& left, const LAllocation& right) {
        setOperand(0, left);
        setOperand(1, right);
    }

    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
};

class LCompareDAndBranch : public LControlInstructionHelper<2, 2, 0>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(CompareDAndBranch)
    LCompareDAndBranch(MCompare* cmpMir, const LAllocation& left, const LAllocation& right,
                       MBasicBlock* ifTrue, MBasicBlock* ifFalse)
      : cmpMir_(cmpMir)
    {
        setOperand(0, left);
        setOperand(1, right);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
};

class LCompareFAndBranch : public LControlInstructionHelper<2, 2, 0>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(CompareFAndBranch)
    LCompareFAndBranch(MCompare* cmpMir, const LAllocation& left, const LAllocation& right,
                       MBasicBlock* ifTrue, MBasicBlock* ifFalse)
      : cmpMir_(cmpMir)
    {
        setOperand(0, left);
        setOperand(1, right);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
};

class LCompareS : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(CompareS)
    LCompareS(const LAllocation& left, const LAllocation& right) {
        setOperand(0, left);
        setOperand(1, right);
    }

    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
};

// strict-equality between value and string.
class LCompareStrictS : public LInstructionHelper<1, BOX_PIECES + 1, 1>
{
  public:
    LIR_HEADER(CompareStrictS)
    LCompareStrictS(const LBoxAllocation& lhs, const LAllocation& rhs, const LDefinition& temp) {
        setBoxOperand(Lhs, lhs);
        setOperand(BOX_PIECES, rhs);
        setTemp(0, temp);
    }

    static const size_t Lhs = 0;

    const LAllocation* right() {
        return getOperand(BOX_PIECES);
    }
    const LDefinition* tempToUnbox() {
        return getTemp(0);
    }
    MCompare* mir() {
        return mir_->toCompare();
    }
};

// Used for strict-equality comparisons where one side is a boolean
// and the other is a value. Note that CompareI is used to compare
// two booleans.
class LCompareB : public LInstructionHelper<1, BOX_PIECES + 1, 0>
{
  public:
    LIR_HEADER(CompareB)

    LCompareB(const LBoxAllocation& lhs, const LAllocation& rhs) {
        setBoxOperand(Lhs, lhs);
        setOperand(BOX_PIECES, rhs);
    }

    static const size_t Lhs = 0;

    const LAllocation* rhs() {
        return getOperand(BOX_PIECES);
    }

    MCompare* mir() {
        return mir_->toCompare();
    }
};

class LCompareBAndBranch : public LControlInstructionHelper<2, BOX_PIECES + 1, 0>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(CompareBAndBranch)

    LCompareBAndBranch(MCompare* cmpMir, const LBoxAllocation& lhs, const LAllocation& rhs,
                       MBasicBlock* ifTrue, MBasicBlock* ifFalse)
      : cmpMir_(cmpMir)
    {
        setBoxOperand(Lhs, lhs);
        setOperand(BOX_PIECES, rhs);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    static const size_t Lhs = 0;

    const LAllocation* rhs() {
        return getOperand(BOX_PIECES);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
};

class LCompareBitwise : public LInstructionHelper<1, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CompareBitwise)

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;

    LCompareBitwise(const LBoxAllocation& lhs, const LBoxAllocation& rhs) {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    MCompare* mir() const {
        return mir_->toCompare();
    }
};

class LCompareBitwiseAndBranch : public LControlInstructionHelper<2, 2 * BOX_PIECES, 0>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(CompareBitwiseAndBranch)

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;

    LCompareBitwiseAndBranch(MCompare* cmpMir, MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                             const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : cmpMir_(cmpMir)
    {
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
};

class LCompareVM : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CompareVM)

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;

    LCompareVM(const LBoxAllocation& lhs, const LBoxAllocation& rhs) {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    MCompare* mir() const {
        return mir_->toCompare();
    }
};

class LBitAndAndBranch : public LControlInstructionHelper<2, 2, 0>
{
    Assembler::Condition cond_;
  public:
    LIR_HEADER(BitAndAndBranch)
    LBitAndAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                     Assembler::Condition cond = Assembler::NonZero)
        : cond_(cond)
    {
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    const LAllocation* left() {
        return getOperand(0);
    }
    const LAllocation* right() {
        return getOperand(1);
    }
    Assembler::Condition cond() const {
        MOZ_ASSERT(cond_ == Assembler::Zero || cond_ == Assembler::NonZero);
        return cond_;
    }
};

// Takes a value and tests whether it is null, undefined, or is an object that
// emulates |undefined|, as determined by the JSCLASS_EMULATES_UNDEFINED class
// flag on unwrapped objects.  See also js::EmulatesUndefined.
class LIsNullOrLikeUndefinedV : public LInstructionHelper<1, BOX_PIECES, 2>
{
  public:
    LIR_HEADER(IsNullOrLikeUndefinedV)

    LIsNullOrLikeUndefinedV(const LBoxAllocation& value, const LDefinition& temp,
                            const LDefinition& tempToUnbox)
    {
        setBoxOperand(Value, value);
        setTemp(0, temp);
        setTemp(1, tempToUnbox);
    }

    static const size_t Value = 0;

    MCompare* mir() {
        return mir_->toCompare();
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    const LDefinition* tempToUnbox() {
        return getTemp(1);
    }
};

// Takes an object or object-or-null pointer and tests whether it is null or is
// an object that emulates |undefined|, as above.
class LIsNullOrLikeUndefinedT : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(IsNullOrLikeUndefinedT)

    explicit LIsNullOrLikeUndefinedT(const LAllocation& input)
    {
        setOperand(0, input);
    }

    MCompare* mir() {
        return mir_->toCompare();
    }
};

class LIsNullOrLikeUndefinedAndBranchV : public LControlInstructionHelper<2, BOX_PIECES, 2>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(IsNullOrLikeUndefinedAndBranchV)

    LIsNullOrLikeUndefinedAndBranchV(MCompare* cmpMir, MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                                     const LBoxAllocation& value, const LDefinition& temp,
                                     const LDefinition& tempToUnbox)
      : cmpMir_(cmpMir)
    {
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
        setBoxOperand(Value, value);
        setTemp(0, temp);
        setTemp(1, tempToUnbox);
    }

    static const size_t Value = 0;

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const LDefinition* tempToUnbox() {
        return getTemp(1);
    }
};

class LIsNullOrLikeUndefinedAndBranchT : public LControlInstructionHelper<2, 1, 1>
{
    MCompare* cmpMir_;

  public:
    LIR_HEADER(IsNullOrLikeUndefinedAndBranchT)

    LIsNullOrLikeUndefinedAndBranchT(MCompare* cmpMir, const LAllocation& input,
                                     MBasicBlock* ifTrue, MBasicBlock* ifFalse,
                                     const LDefinition& temp)
      : cmpMir_(cmpMir)
    {
        setOperand(0, input);
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
        setTemp(0, temp);
    }

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
    MTest* mir() const {
        return mir_->toTest();
    }
    MCompare* cmpMir() const {
        return cmpMir_;
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Not operation on an integer.
class LNotI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NotI)

    explicit LNotI(const LAllocation& input) {
        setOperand(0, input);
    }
};

// Not operation on an int64.
class LNotI64 : public LInstructionHelper<1, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(NotI64)

    explicit LNotI64(const LInt64Allocation& input) {
        setInt64Operand(0, input);
    }
};

// Not operation on a double.
class LNotD : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NotD)

    explicit LNotD(const LAllocation& input) {
        setOperand(0, input);
    }

    MNot* mir() {
        return mir_->toNot();
    }
};

// Not operation on a float32.
class LNotF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NotF)

    explicit LNotF(const LAllocation& input) {
        setOperand(0, input);
    }

    MNot* mir() {
        return mir_->toNot();
    }
};

// Boolean complement operation on an object.
class LNotO : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NotO)

    explicit LNotO(const LAllocation& input)
    {
        setOperand(0, input);
    }

    MNot* mir() {
        return mir_->toNot();
    }
};

// Boolean complement operation on a value.
class LNotV : public LInstructionHelper<1, BOX_PIECES, 3>
{
  public:
    LIR_HEADER(NotV)

    static const size_t Input = 0;
    LNotV(const LBoxAllocation& input, const LDefinition& temp0, const LDefinition& temp1,
          const LDefinition& temp2)
    {
        setBoxOperand(Input, input);
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
    }

    const LDefinition* tempFloat() {
        return getTemp(0);
    }

    const LDefinition* temp1() {
        return getTemp(1);
    }

    const LDefinition* temp2() {
        return getTemp(2);
    }

    MNot* mir() {
        return mir_->toNot();
    }
};

// Bitwise not operation, takes a 32-bit integer as input and returning
// a 32-bit integer result as an output.
class LBitNotI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(BitNotI)
};

// Call a VM function to perform a BITNOT operation.
class LBitNotV : public LCallInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(BitNotV)

    static const size_t Input = 0;

    explicit LBitNotV(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }
};

// Binary bitwise operation, taking two 32-bit integers as inputs and returning
// a 32-bit integer result as an output.
class LBitOpI : public LInstructionHelper<1, 2, 0>
{
    JSOp op_;

  public:
    LIR_HEADER(BitOpI)

    explicit LBitOpI(JSOp op)
      : op_(op)
    { }

    const char* extraName() const {
        if (bitop() == JSOP_URSH && mir_->toUrsh()->bailoutsDisabled())
            return "ursh:BailoutsDisabled";
        return CodeName[op_];
    }

    JSOp bitop() const {
        return op_;
    }
};

class LBitOpI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0>
{
    JSOp op_;

  public:
    LIR_HEADER(BitOpI64)

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;

    explicit LBitOpI64(JSOp op)
      : op_(op)
    { }

    const char* extraName() const {
        return CodeName[op_];
    }

    JSOp bitop() const {
        return op_;
    }
};

// Call a VM function to perform a bitwise operation.
class LBitOpV : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(BitOpV)

    LBitOpV(JSOp jsop, const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : jsop_(jsop)
    {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    JSOp jsop() const {
        return jsop_;
    }

    const char* extraName() const {
        return CodeName[jsop_];
    }

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;
};

// Shift operation, taking two 32-bit integers as inputs and returning
// a 32-bit integer result as an output.
class LShiftI : public LBinaryMath<0>
{
    JSOp op_;

  public:
    LIR_HEADER(ShiftI)

    explicit LShiftI(JSOp op)
      : op_(op)
    { }

    JSOp bitop() {
        return op_;
    }

    MInstruction* mir() {
        return mir_->toInstruction();
    }

    const char* extraName() const {
        return CodeName[op_];
    }
};

class LShiftI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES + 1, 0>
{
    JSOp op_;

  public:
    LIR_HEADER(ShiftI64)

    explicit LShiftI64(JSOp op)
      : op_(op)
    { }

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;

    JSOp bitop() {
        return op_;
    }

    MInstruction* mir() {
        return mir_->toInstruction();
    }

    const char* extraName() const {
        return CodeName[op_];
    }
};

// Sign extension
class LSignExtend : public LInstructionHelper<1, 1, 0>
{
    MSignExtend::Mode mode_;

  public:
    LIR_HEADER(SignExtend);
    explicit LSignExtend(const LAllocation& num, MSignExtend::Mode mode)
      : mode_(mode)
    {
        setOperand(0, num);
    }

    MSignExtend::Mode mode() { return mode_; }
};

class LUrshD : public LBinaryMath<1>
{
  public:
    LIR_HEADER(UrshD)

    LUrshD(const LAllocation& lhs, const LAllocation& rhs, const LDefinition& temp) {
        setOperand(0, lhs);
        setOperand(1, rhs);
        setTemp(0, temp);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Returns from the function being compiled (not used in inlined frames). The
// input must be a box.
class LReturn : public LInstructionHelper<0, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(Return)
};

class LThrow : public LCallInstructionHelper<0, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(Throw)

    static const size_t Value = 0;

    explicit LThrow(const LBoxAllocation& value) {
        setBoxOperand(Value, value);
    }
};

class LMinMaxBase : public LInstructionHelper<1, 2, 0>
{
  protected:
    LMinMaxBase(const LAllocation& first, const LAllocation& second)
    {
        setOperand(0, first);
        setOperand(1, second);
    }

  public:
    const LAllocation* first() {
        return this->getOperand(0);
    }
    const LAllocation* second() {
        return this->getOperand(1);
    }
    const LDefinition* output() {
        return this->getDef(0);
    }
    MMinMax* mir() const {
        return mir_->toMinMax();
    }
    const char* extraName() const {
        return mir()->isMax() ? "Max" : "Min";
    }
};

class LMinMaxI : public LMinMaxBase
{
  public:
    LIR_HEADER(MinMaxI)
    LMinMaxI(const LAllocation& first, const LAllocation& second) : LMinMaxBase(first, second)
    {}
};

class LMinMaxD : public LMinMaxBase
{
  public:
    LIR_HEADER(MinMaxD)
    LMinMaxD(const LAllocation& first, const LAllocation& second) : LMinMaxBase(first, second)
    {}
};

class LMinMaxF : public LMinMaxBase
{
  public:
    LIR_HEADER(MinMaxF)
    LMinMaxF(const LAllocation& first, const LAllocation& second) : LMinMaxBase(first, second)
    {}
};

// Negative of an integer
class LNegI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NegI);
    explicit LNegI(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Negative of a double.
class LNegD : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NegD)
    explicit LNegD(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Negative of a float32.
class LNegF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NegF)
    explicit LNegF(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Absolute value of an integer.
class LAbsI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(AbsI)
    explicit LAbsI(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Absolute value of a double.
class LAbsD : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(AbsD)
    explicit LAbsD(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Absolute value of a float32.
class LAbsF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(AbsF)
    explicit LAbsF(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Copysign for doubles.
class LCopySignD : public LInstructionHelper<1, 2, 2>
{
  public:
    LIR_HEADER(CopySignD)
    explicit LCopySignD() {}
};

// Copysign for float32.
class LCopySignF : public LInstructionHelper<1, 2, 2>
{
  public:
    LIR_HEADER(CopySignF)
    explicit LCopySignF() {}
};

// Count leading zeroes on an int32.
class LClzI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ClzI)
    explicit LClzI(const LAllocation& num) {
        setOperand(0, num);
    }

    MClz* mir() const {
        return mir_->toClz();
    }
};

// Count leading zeroes on an int64.
class LClzI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(ClzI64)
    explicit LClzI64(const LInt64Allocation& num) {
        setInt64Operand(0, num);
    }

    MClz* mir() const {
        return mir_->toClz();
    }
};

// Count trailing zeroes on an int32.
class LCtzI : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CtzI)
    explicit LCtzI(const LAllocation& num) {
        setOperand(0, num);
    }

    MCtz* mir() const {
        return mir_->toCtz();
    }
};

// Count trailing zeroes on an int64.
class LCtzI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(CtzI64)
    explicit LCtzI64(const LInt64Allocation& num) {
        setInt64Operand(0, num);
    }

    MCtz* mir() const {
        return mir_->toCtz();
    }
};

// Count population on an int32.
class LPopcntI : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(PopcntI)
    explicit LPopcntI(const LAllocation& num, const LDefinition& temp) {
        setOperand(0, num);
        setTemp(0, temp);
    }

    MPopcnt* mir() const {
        return mir_->toPopcnt();
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Count population on an int64.
class LPopcntI64 : public LInstructionHelper<INT64_PIECES, INT64_PIECES, 1>
{
  public:
    LIR_HEADER(PopcntI64)
    explicit LPopcntI64(const LInt64Allocation& num, const LDefinition& temp) {
        setInt64Operand(0, num);
        setTemp(0, temp);
    }

    MPopcnt* mir() const {
        return mir_->toPopcnt();
    }
};

// Square root of a double.
class LSqrtD : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SqrtD)
    explicit LSqrtD(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Square root of a float32.
class LSqrtF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(SqrtF)
    explicit LSqrtF(const LAllocation& num) {
        setOperand(0, num);
    }
};

class LAtan2D : public LCallInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(Atan2D)
    LAtan2D(const LAllocation& y, const LAllocation& x, const LDefinition& temp) {
        setOperand(0, y);
        setOperand(1, x);
        setTemp(0, temp);
    }

    const LAllocation* y() {
        return getOperand(0);
    }

    const LAllocation* x() {
        return getOperand(1);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    const LDefinition* output() {
        return getDef(0);
    }
};

class LHypot : public LCallInstructionHelper<1, 4, 1>
{
    uint32_t numOperands_;
  public:
    LIR_HEADER(Hypot)
    LHypot(const LAllocation& x, const LAllocation& y, const LDefinition& temp)
      : numOperands_(2)
    {
        setOperand(0, x);
        setOperand(1, y);
        setTemp(0, temp);
    }

    LHypot(const LAllocation& x, const LAllocation& y, const LAllocation& z, const LDefinition& temp)
      : numOperands_(3)
    {
        setOperand(0, x);
        setOperand(1, y);
        setOperand(2, z);
        setTemp(0, temp);
    }

    LHypot(const LAllocation& x, const LAllocation& y, const LAllocation& z, const LAllocation& w, const LDefinition& temp)
      : numOperands_(4)
    {
        setOperand(0, x);
        setOperand(1, y);
        setOperand(2, z);
        setOperand(3, w);
        setTemp(0, temp);
    }

    uint32_t numArgs() const { return numOperands_; }

    const LAllocation* x() {
        return getOperand(0);
    }

    const LAllocation* y() {
        return getOperand(1);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    const LDefinition* output() {
        return getDef(0);
    }
};

// Double raised to an integer power.
class LPowI : public LCallInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(PowI)
    LPowI(const LAllocation& value, const LAllocation& power, const LDefinition& temp) {
        setOperand(0, value);
        setOperand(1, power);
        setTemp(0, temp);
    }

    const LAllocation* value() {
        return getOperand(0);
    }
    const LAllocation* power() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Double raised to a double power.
class LPowD : public LCallInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(PowD)
    LPowD(const LAllocation& value, const LAllocation& power, const LDefinition& temp) {
        setOperand(0, value);
        setOperand(1, power);
        setTemp(0, temp);
    }

    const LAllocation* value() {
        return getOperand(0);
    }
    const LAllocation* power() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

class LPowV : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(PowV)

    LPowV(const LBoxAllocation& value, const LBoxAllocation& power) {
        setBoxOperand(ValueInput, value);
        setBoxOperand(PowerInput, power);
    }

    static const size_t ValueInput = 0;
    static const size_t PowerInput = BOX_PIECES;
};

class LMathFunctionD : public LCallInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(MathFunctionD)
    LMathFunctionD(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
    MMathFunction* mir() const {
        return mir_->toMathFunction();
    }
    const char* extraName() const {
        return MMathFunction::FunctionName(mir()->function());
    }
};

class LMathFunctionF : public LCallInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(MathFunctionF)
    LMathFunctionF(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
    MMathFunction* mir() const {
        return mir_->toMathFunction();
    }
    const char* extraName() const {
        return MMathFunction::FunctionName(mir()->function());
    }
};

// Adds two integers, returning an integer value.
class LAddI : public LBinaryMath<0>
{
    bool recoversInput_;

  public:
    LIR_HEADER(AddI)

    LAddI()
      : recoversInput_(false)
    { }

    const char* extraName() const {
        return snapshot() ? "OverflowCheck" : nullptr;
    }

    virtual bool recoversInput() const {
        return recoversInput_;
    }
    void setRecoversInput() {
        recoversInput_ = true;
    }

    MAdd* mir() const {
        return mir_->toAdd();
    }
};

class LAddI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0>
{
  public:
    LIR_HEADER(AddI64)

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;
};

// Subtracts two integers, returning an integer value.
class LSubI : public LBinaryMath<0>
{
    bool recoversInput_;

  public:
    LIR_HEADER(SubI)

    LSubI()
      : recoversInput_(false)
    { }

    const char* extraName() const {
        return snapshot() ? "OverflowCheck" : nullptr;
    }

    virtual bool recoversInput() const {
        return recoversInput_;
    }
    void setRecoversInput() {
        recoversInput_ = true;
    }
    MSub* mir() const {
        return mir_->toSub();
    }
};

class LSubI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 0>
{
  public:
    LIR_HEADER(SubI64)

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;
};

class LMulI64 : public LInstructionHelper<INT64_PIECES, 2 * INT64_PIECES, 1>
{
  public:
    LIR_HEADER(MulI64)

    explicit LMulI64()
    {
        setTemp(0, LDefinition());
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    static const size_t Lhs = 0;
    static const size_t Rhs = INT64_PIECES;
};

// Performs an add, sub, mul, or div on two double values.
class LMathD : public LBinaryMath<0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(MathD)

    explicit LMathD(JSOp jsop)
      : jsop_(jsop)
    { }

    JSOp jsop() const {
        return jsop_;
    }

    const char* extraName() const {
        return CodeName[jsop_];
    }
};

// Performs an add, sub, mul, or div on two double values.
class LMathF: public LBinaryMath<0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(MathF)

    explicit LMathF(JSOp jsop)
      : jsop_(jsop)
    { }

    JSOp jsop() const {
        return jsop_;
    }

    const char* extraName() const {
        return CodeName[jsop_];
    }
};

class LModD : public LBinaryMath<1>
{
  public:
    LIR_HEADER(ModD)

    LModD(const LAllocation& lhs, const LAllocation& rhs, const LDefinition& temp) {
        setOperand(0, lhs);
        setOperand(1, rhs);
        setTemp(0, temp);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    bool isCall() const {
        return true;
    }
    MMod* mir() const {
        return mir_->toMod();
    }
};

// Call a VM function to perform a binary operation.
class LBinaryV : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0>
{
    JSOp jsop_;

  public:
    LIR_HEADER(BinaryV)

    LBinaryV(JSOp jsop, const LBoxAllocation& lhs, const LBoxAllocation& rhs)
      : jsop_(jsop)
    {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    JSOp jsop() const {
        return jsop_;
    }

    const char* extraName() const {
        return CodeName[jsop_];
    }

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;
};

// Adds two string, returning a string.
class LConcat : public LInstructionHelper<1, 2, 5>
{
  public:
    LIR_HEADER(Concat)

    LConcat(const LAllocation& lhs, const LAllocation& rhs, const LDefinition& temp1,
            const LDefinition& temp2, const LDefinition& temp3, const LDefinition& temp4,
            const LDefinition& temp5)
    {
        setOperand(0, lhs);
        setOperand(1, rhs);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, temp3);
        setTemp(3, temp4);
        setTemp(4, temp5);
    }

    const LAllocation* lhs() {
        return this->getOperand(0);
    }
    const LAllocation* rhs() {
        return this->getOperand(1);
    }
    const LDefinition* temp1() {
        return this->getTemp(0);
    }
    const LDefinition* temp2() {
        return this->getTemp(1);
    }
    const LDefinition* temp3() {
        return this->getTemp(2);
    }
    const LDefinition* temp4() {
        return this->getTemp(3);
    }
    const LDefinition* temp5() {
        return this->getTemp(4);
    }
};

// Get uint16 character code from a string.
class LCharCodeAt : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(CharCodeAt)

    LCharCodeAt(const LAllocation& str, const LAllocation& index) {
        setOperand(0, str);
        setOperand(1, index);
    }

    const LAllocation* str() {
        return this->getOperand(0);
    }
    const LAllocation* index() {
        return this->getOperand(1);
    }
};

// Convert uint16 character code to a string.
class LFromCharCode : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(FromCharCode)

    explicit LFromCharCode(const LAllocation& code) {
        setOperand(0, code);
    }

    const LAllocation* code() {
        return this->getOperand(0);
    }
};

// Convert uint32 code point to a string.
class LFromCodePoint : public LInstructionHelper<1, 1, 2>
{
  public:
    LIR_HEADER(FromCodePoint)

    explicit LFromCodePoint(const LAllocation& codePoint, const LDefinition& temp1,
                            const LDefinition& temp2)
    {
        setOperand(0, codePoint);
        setTemp(0, temp1);
        setTemp(1, temp2);
    }

    const LAllocation* codePoint() {
        return this->getOperand(0);
    }

    const LDefinition* temp1() {
        return this->getTemp(0);
    }

    const LDefinition* temp2() {
        return this->getTemp(1);
    }
};

// Calculates sincos(x) and returns two values (sin/cos).
class LSinCos : public LCallInstructionHelper<2, 1, 2>
{
  public:
    LIR_HEADER(SinCos)

    LSinCos(const LAllocation &input, const LDefinition &temp, const LDefinition &temp2)
    {
        setOperand(0, input);
        setTemp(0, temp);
        setTemp(1, temp2);
    }
    const LAllocation *input() {
        return getOperand(0);
    }
    const LDefinition *outputSin() {
        return getDef(0);
    }
    const LDefinition *outputCos() {
        return getDef(1);
    }
    const LDefinition *temp() {
        return getTemp(0);
    }
    const LDefinition *temp2() {
        return getTemp(1);
    }
    const MSinCos *mir() const {
        return mir_->toSinCos();
    }
};

class LStringSplit : public LCallInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(StringSplit)

    LStringSplit(const LAllocation& string, const LAllocation& separator) {
        setOperand(0, string);
        setOperand(1, separator);
    }
    const LAllocation* string() {
        return getOperand(0);
    }
    const LAllocation* separator() {
        return getOperand(1);
    }
    const MStringSplit* mir() const {
        return mir_->toStringSplit();
    }
};

class LSubstr : public LInstructionHelper<1, 3, 3>
{
  public:
    LIR_HEADER(Substr)

    LSubstr(const LAllocation& string, const LAllocation& begin, const LAllocation& length,
            const LDefinition& temp, const LDefinition& temp2, const LDefinition& temp3)
    {
        setOperand(0, string);
        setOperand(1, begin);
        setOperand(2, length);
        setTemp(0, temp);
        setTemp(1, temp2);
        setTemp(2, temp3);
    }
    const LAllocation* string() {
        return getOperand(0);
    }
    const LAllocation* begin() {
        return getOperand(1);
    }
    const LAllocation* length() {
        return getOperand(2);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }
    const LDefinition* temp3() {
        return getTemp(2);
    }
    const MStringSplit* mir() const {
        return mir_->toStringSplit();
    }
};

// Convert a 32-bit integer to a double.
class LInt32ToDouble : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Int32ToDouble)

    explicit LInt32ToDouble(const LAllocation& input) {
        setOperand(0, input);
    }
};

// Convert a 32-bit float to a double.
class LFloat32ToDouble : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Float32ToDouble)

    explicit LFloat32ToDouble(const LAllocation& input) {
        setOperand(0, input);
    }
};

// Convert a double to a 32-bit float.
class LDoubleToFloat32 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(DoubleToFloat32)

    explicit LDoubleToFloat32(const LAllocation& input) {
        setOperand(0, input);
    }
};

// Convert a 32-bit integer to a float32.
class LInt32ToFloat32 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Int32ToFloat32)

    explicit LInt32ToFloat32(const LAllocation& input) {
        setOperand(0, input);
    }
};

// Convert a value to a double.
class LValueToDouble : public LInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(ValueToDouble)
    static const size_t Input = 0;

    explicit LValueToDouble(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    MToDouble* mir() {
        return mir_->toToDouble();
    }
};

// Convert a value to a float32.
class LValueToFloat32 : public LInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(ValueToFloat32)
    static const size_t Input = 0;

    explicit LValueToFloat32(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    MToFloat32* mir() {
        return mir_->toToFloat32();
    }
};

// Convert a value to an int32.
//   Input: components of a Value
//   Output: 32-bit integer
//   Bailout: undefined, string, object, or non-int32 double
//   Temps: one float register, one GP register
//
// This instruction requires a temporary float register.
class LValueToInt32 : public LInstructionHelper<1, BOX_PIECES, 2>
{
  public:
    enum Mode {
        NORMAL,
        TRUNCATE
    };

  private:
    Mode mode_;

  public:
    LIR_HEADER(ValueToInt32)

    LValueToInt32(const LBoxAllocation& input, const LDefinition& temp0, const LDefinition& temp1,
                  Mode mode)
      : mode_(mode)
    {
        setBoxOperand(Input, input);
        setTemp(0, temp0);
        setTemp(1, temp1);
    }

    const char* extraName() const {
        return mode() == NORMAL ? "Normal" : "Truncate";
    }

    static const size_t Input = 0;

    Mode mode() const {
        return mode_;
    }
    const LDefinition* tempFloat() {
        return getTemp(0);
    }
    const LDefinition* temp() {
        return getTemp(1);
    }
    MToInt32* mirNormal() const {
        MOZ_ASSERT(mode_ == NORMAL);
        return mir_->toToInt32();
    }
    MTruncateToInt32* mirTruncate() const {
        MOZ_ASSERT(mode_ == TRUNCATE);
        return mir_->toTruncateToInt32();
    }
    MInstruction* mir() const {
        return mir_->toInstruction();
    }
};

// Convert a double to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the double cannot be converted to an integer.
class LDoubleToInt32 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(DoubleToInt32)

    explicit LDoubleToInt32(const LAllocation& in) {
        setOperand(0, in);
    }

    MToInt32* mir() const {
        return mir_->toToInt32();
    }
};

// Convert a float32 to an int32.
//   Input: floating-point register
//   Output: 32-bit integer
//   Bailout: if the float32 cannot be converted to an integer.
class LFloat32ToInt32 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Float32ToInt32)

    explicit LFloat32ToInt32(const LAllocation& in) {
        setOperand(0, in);
    }

    MToInt32* mir() const {
        return mir_->toToInt32();
    }
};

// Convert a double to a truncated int32.
//   Input: floating-point register
//   Output: 32-bit integer
class LTruncateDToInt32 : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(TruncateDToInt32)

    LTruncateDToInt32(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }

    const LDefinition* tempFloat() {
        return getTemp(0);
    }

    MTruncateToInt32* mir() const {
        return mir_->toTruncateToInt32();
    }
};

// Convert a float32 to a truncated int32.
//   Input: floating-point register
//   Output: 32-bit integer
class LTruncateFToInt32 : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(TruncateFToInt32)

    LTruncateFToInt32(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }

    const LDefinition* tempFloat() {
        return getTemp(0);
    }

    MTruncateToInt32* mir() const {
        return mir_->toTruncateToInt32();
    }
};

class LWasmTruncateToInt32 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(WasmTruncateToInt32)

    explicit LWasmTruncateToInt32(const LAllocation& in) {
        setOperand(0, in);
    }

    MWasmTruncateToInt32* mir() const {
        return mir_->toWasmTruncateToInt32();
    }
};

class LWrapInt64ToInt32 : public LInstructionHelper<1, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(WrapInt64ToInt32)

    static const size_t Input = 0;

    explicit LWrapInt64ToInt32(const LInt64Allocation& input) {
        setInt64Operand(Input, input);
    }

    const MWrapInt64ToInt32* mir() {
        return mir_->toWrapInt64ToInt32();
    }
};

class LExtendInt32ToInt64 : public LInstructionHelper<INT64_PIECES, 1, 0>
{
  public:
    LIR_HEADER(ExtendInt32ToInt64)

    explicit LExtendInt32ToInt64(const LAllocation& input) {
        setOperand(0, input);
    }

    const MExtendInt32ToInt64* mir() {
        return mir_->toExtendInt32ToInt64();
    }
};

// Convert a boolean value to a string.
class LBooleanToString : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(BooleanToString)

    explicit LBooleanToString(const LAllocation& input) {
        setOperand(0, input);
    }

    const MToString* mir() {
        return mir_->toToString();
    }
};

// Convert an integer hosted on one definition to a string with a function call.
class LIntToString : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(IntToString)

    explicit LIntToString(const LAllocation& input) {
        setOperand(0, input);
    }

    const MToString* mir() {
        return mir_->toToString();
    }
};

// Convert a double hosted on one definition to a string with a function call.
class LDoubleToString : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(DoubleToString)

    LDoubleToString(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }

    const LDefinition* tempInt() {
        return getTemp(0);
    }
    const MToString* mir() {
        return mir_->toToString();
    }
};

// Convert a primitive to a string with a function call.
class LValueToString : public LInstructionHelper<1, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(ValueToString)

    LValueToString(const LBoxAllocation& input, const LDefinition& tempToUnbox)
    {
        setBoxOperand(Input, input);
        setTemp(0, tempToUnbox);
    }

    static const size_t Input = 0;

    const MToString* mir() {
        return mir_->toToString();
    }

    const LDefinition* tempToUnbox() {
        return getTemp(0);
    }
};

// Convert a value to an object or null pointer.
class LValueToObjectOrNull : public LInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(ValueToObjectOrNull)

    explicit LValueToObjectOrNull(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    static const size_t Input = 0;

    const MToObjectOrNull* mir() {
        return mir_->toToObjectOrNull();
    }
};

class LInt32x4ToFloat32x4 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Int32x4ToFloat32x4);
    explicit LInt32x4ToFloat32x4(const LAllocation& input) {
        setOperand(0, input);
    }
};

class LFloat32x4ToInt32x4 : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(Float32x4ToInt32x4);
    explicit LFloat32x4ToInt32x4(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MSimdConvert* mir() const {
        return mir_->toSimdConvert();
    }
};

// Float32x4 to Uint32x4 needs one GPR temp and one FloatReg temp.
class LFloat32x4ToUint32x4 : public LInstructionHelper<1, 1, 2>
{
  public:
    LIR_HEADER(Float32x4ToUint32x4);
    explicit LFloat32x4ToUint32x4(const LAllocation& input, const LDefinition& tempR,
                                  const LDefinition& tempF)
    {
        setOperand(0, input);
        setTemp(0, tempR);
        setTemp(1, tempF);
    }
    const LDefinition* tempR() {
        return getTemp(0);
    }
    const LDefinition* tempF() {
        return getTemp(1);
    }
    const MSimdConvert* mir() const {
        return mir_->toSimdConvert();
    }
};

// Double raised to a half power.
class LPowHalfD : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(PowHalfD);
    explicit LPowHalfD(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* input() {
        return getOperand(0);
    }
    const LDefinition* output() {
        return getDef(0);
    }
    MPowHalf* mir() const {
        return mir_->toPowHalf();
    }
};

// No-op instruction that is used to hold the entry snapshot. This simplifies
// register allocation as it doesn't need to sniff the snapshot out of the
// LIRGraph.
class LStart : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(Start)
};

class LNaNToZero : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(NaNToZero)

    explicit LNaNToZero(const LAllocation& input, const LDefinition& tempDouble) {
        setOperand(0, input);
        setTemp(0, tempDouble);
    }

    const MNaNToZero* mir() {
        return mir_->toNaNToZero();
    }
    const LAllocation* input() {
        return getOperand(0);
    }
    const LDefinition* output() {
        return getDef(0);
    }
    const LDefinition* tempDouble() {
        return getTemp(0);
    }
};

// Passed the BaselineFrame address in the OsrFrameReg by SideCannon().
// Forwards this object to the LOsrValues for Value materialization.
class LOsrEntry : public LInstructionHelper<1, 0, 1>
{
  protected:
    Label label_;
    uint32_t frameDepth_;

  public:
    LIR_HEADER(OsrEntry)

    explicit LOsrEntry(const LDefinition& temp)
      : frameDepth_(0)
    {
        setTemp(0, temp);
    }

    void setFrameDepth(uint32_t depth) {
        frameDepth_ = depth;
    }
    uint32_t getFrameDepth() {
        return frameDepth_;
    }
    Label* label() {
        return &label_;
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Materialize a Value stored in an interpreter frame for OSR.
class LOsrValue : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(OsrValue)

    explicit LOsrValue(const LAllocation& entry)
    {
        setOperand(0, entry);
    }

    const MOsrValue* mir() {
        return mir_->toOsrValue();
    }
};

// Materialize a JSObject env chain stored in an interpreter frame for OSR.
class LOsrEnvironmentChain : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(OsrEnvironmentChain)

    explicit LOsrEnvironmentChain(const LAllocation& entry)
    {
        setOperand(0, entry);
    }

    const MOsrEnvironmentChain* mir() {
        return mir_->toOsrEnvironmentChain();
    }
};

// Materialize a JSObject env chain stored in an interpreter frame for OSR.
class LOsrReturnValue : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(OsrReturnValue)

    explicit LOsrReturnValue(const LAllocation& entry)
    {
        setOperand(0, entry);
    }

    const MOsrReturnValue* mir() {
        return mir_->toOsrReturnValue();
    }
};

// Materialize a JSObject ArgumentsObject stored in an interpreter frame for OSR.
class LOsrArgumentsObject : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(OsrArgumentsObject)

    explicit LOsrArgumentsObject(const LAllocation& entry)
    {
        setOperand(0, entry);
    }

    const MOsrArgumentsObject* mir() {
        return mir_->toOsrArgumentsObject();
    }
};

class LRegExp : public LCallInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(RegExp)

    const MRegExp* mir() const {
        return mir_->toRegExp();
    }
};

class LRegExpMatcher : public LCallInstructionHelper<BOX_PIECES, 3, 0>
{
  public:
    LIR_HEADER(RegExpMatcher)

    LRegExpMatcher(const LAllocation& regexp, const LAllocation& string,
                   const LAllocation& lastIndex)
    {
        setOperand(0, regexp);
        setOperand(1, string);
        setOperand(2, lastIndex);
    }

    const LAllocation* regexp() {
        return getOperand(0);
    }
    const LAllocation* string() {
        return getOperand(1);
    }
    const LAllocation* lastIndex() {
        return getOperand(2);
    }

    const MRegExpMatcher* mir() const {
        return mir_->toRegExpMatcher();
    }
};

class LRegExpSearcher : public LCallInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(RegExpSearcher)

    LRegExpSearcher(const LAllocation& regexp, const LAllocation& string,
                    const LAllocation& lastIndex)
    {
        setOperand(0, regexp);
        setOperand(1, string);
        setOperand(2, lastIndex);
    }

    const LAllocation* regexp() {
        return getOperand(0);
    }
    const LAllocation* string() {
        return getOperand(1);
    }
    const LAllocation* lastIndex() {
        return getOperand(2);
    }

    const MRegExpSearcher* mir() const {
        return mir_->toRegExpSearcher();
    }
};

class LRegExpTester : public LCallInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(RegExpTester)

    LRegExpTester(const LAllocation& regexp, const LAllocation& string,
                  const LAllocation& lastIndex)
    {
        setOperand(0, regexp);
        setOperand(1, string);
        setOperand(2, lastIndex);
    }

    const LAllocation* regexp() {
        return getOperand(0);
    }
    const LAllocation* string() {
        return getOperand(1);
    }
    const LAllocation* lastIndex() {
        return getOperand(2);
    }

    const MRegExpTester* mir() const {
        return mir_->toRegExpTester();
    }
};

class LRegExpPrototypeOptimizable : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(RegExpPrototypeOptimizable);
    explicit LRegExpPrototypeOptimizable(const LAllocation& object, const LDefinition& temp) {
        setOperand(0, object);
        setTemp(0, temp);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MRegExpPrototypeOptimizable* mir() const {
        return mir_->toRegExpPrototypeOptimizable();
    }
};

class LRegExpInstanceOptimizable : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(RegExpInstanceOptimizable);
    explicit LRegExpInstanceOptimizable(const LAllocation& object, const LAllocation& proto,
                                        const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, proto);
        setTemp(0, temp);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* proto() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MRegExpInstanceOptimizable* mir() const {
        return mir_->toRegExpInstanceOptimizable();
    }
};

class LGetFirstDollarIndex : public LInstructionHelper<1, 1, 3>
{
  public:
    LIR_HEADER(GetFirstDollarIndex);
    explicit LGetFirstDollarIndex(const LAllocation& str, const LDefinition& temp0,
                                  const LDefinition& temp1, const LDefinition& temp2) {
        setOperand(0, str);
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
    }

    const LAllocation* str() {
        return getOperand(0);
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
    const LDefinition* temp2() {
        return getTemp(2);
    }
};

class LStringReplace: public LCallInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(StringReplace);

    LStringReplace(const LAllocation& string, const LAllocation& pattern,
                   const LAllocation& replacement)
    {
        setOperand(0, string);
        setOperand(1, pattern);
        setOperand(2, replacement);
    }

    const MStringReplace* mir() const {
        return mir_->toStringReplace();
    }

    const LAllocation* string() {
        return getOperand(0);
    }
    const LAllocation* pattern() {
        return getOperand(1);
    }
    const LAllocation* replacement() {
        return getOperand(2);
    }
};

class LBinarySharedStub : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(BinarySharedStub)

    LBinarySharedStub(const LBoxAllocation& lhs, const LBoxAllocation& rhs) {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    const MBinarySharedStub* mir() const {
        return mir_->toBinarySharedStub();
    }

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;
};

class LUnarySharedStub : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(UnarySharedStub)

    explicit LUnarySharedStub(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    const MUnarySharedStub* mir() const {
        return mir_->toUnarySharedStub();
    }

    static const size_t Input = 0;
};

class LNullarySharedStub : public LCallInstructionHelper<BOX_PIECES, 0, 0>
{
  public:
    LIR_HEADER(NullarySharedStub)

    const MNullarySharedStub* mir() const {
        return mir_->toNullarySharedStub();
    }
};

class LLambdaForSingleton : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LambdaForSingleton)

    explicit LLambdaForSingleton(const LAllocation& envChain)
    {
        setOperand(0, envChain);
    }
    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    const MLambda* mir() const {
        return mir_->toLambda();
    }
};

class LLambda : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(Lambda)

    LLambda(const LAllocation& envChain, const LDefinition& temp) {
        setOperand(0, envChain);
        setTemp(0, temp);
    }
    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MLambda* mir() const {
        return mir_->toLambda();
    }
};

class LLambdaArrow : public LInstructionHelper<1, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(LambdaArrow)

    static const size_t NewTargetValue = 1;

    LLambdaArrow(const LAllocation& envChain, const LBoxAllocation& newTarget) {
        setOperand(0, envChain);
        setBoxOperand(NewTargetValue, newTarget);
    }
    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    const MLambdaArrow* mir() const {
        return mir_->toLambdaArrow();
    }
};

class LSetFunName : public LCallInstructionHelper<1, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(SetFunName)

    static const size_t NameValue = 1;

    LSetFunName(const LAllocation& fun, const LBoxAllocation& name) {
        setOperand(0, fun);
        setBoxOperand(NameValue, name);
    }
    const LAllocation* fun() {
        return getOperand(0);
    }
    const MSetFunName* mir() const {
        return mir_->toSetFunName();
    }
};

class LKeepAliveObject : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(KeepAliveObject)

    explicit LKeepAliveObject(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

// Load the "slots" member out of a JSObject.
//   Input: JSObject pointer
//   Output: slots pointer
class LSlots : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Slots)

    explicit LSlots(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

// Load the "elements" member out of a JSObject.
//   Input: JSObject pointer
//   Output: elements pointer
class LElements : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Elements)

    explicit LElements(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    const MElements* mir() const {
        return mir_->toElements();
    }
};

// If necessary, convert any int32 elements in a vector into doubles.
class LConvertElementsToDoubles : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(ConvertElementsToDoubles)

    explicit LConvertElementsToDoubles(const LAllocation& elements) {
        setOperand(0, elements);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
};

// If |elements| has the CONVERT_DOUBLE_ELEMENTS flag, convert int32 value to
// double. Else return the original value.
class LMaybeToDoubleElement : public LInstructionHelper<BOX_PIECES, 2, 1>
{
  public:
    LIR_HEADER(MaybeToDoubleElement)

    LMaybeToDoubleElement(const LAllocation& elements, const LAllocation& value,
                          const LDefinition& tempFloat) {
        setOperand(0, elements);
        setOperand(1, value);
        setTemp(0, tempFloat);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LDefinition* tempFloat() {
        return getTemp(0);
    }
};

// If necessary, copy the elements in an object so they may be written to.
class LMaybeCopyElementsForWrite : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(MaybeCopyElementsForWrite)

    explicit LMaybeCopyElementsForWrite(const LAllocation& obj, const LDefinition& temp) {
        setOperand(0, obj);
        setTemp(0, temp);
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    const MMaybeCopyElementsForWrite* mir() const {
        return mir_->toMaybeCopyElementsForWrite();
    }
};

// Load the initialized length from an elements header.
class LInitializedLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(InitializedLength)

    explicit LInitializedLength(const LAllocation& elements) {
        setOperand(0, elements);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
};

// Store to the initialized length in an elements header. Note the input is an
// *index*, one less than the desired initialized length.
class LSetInitializedLength : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(SetInitializedLength)

    LSetInitializedLength(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LUnboxedArrayLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(UnboxedArrayLength)

    explicit LUnboxedArrayLength(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

class LUnboxedArrayInitializedLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(UnboxedArrayInitializedLength)

    explicit LUnboxedArrayInitializedLength(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

class LIncrementUnboxedArrayInitializedLength : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(IncrementUnboxedArrayInitializedLength)

    explicit LIncrementUnboxedArrayInitializedLength(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

class LSetUnboxedArrayInitializedLength : public LInstructionHelper<0, 2, 1>
{
  public:
    LIR_HEADER(SetUnboxedArrayInitializedLength)

    explicit LSetUnboxedArrayInitializedLength(const LAllocation& object,
                                               const LAllocation& length,
                                               const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, length);
        setTemp(0, temp);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* length() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Load the length from an elements header.
class LArrayLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ArrayLength)

    explicit LArrayLength(const LAllocation& elements) {
        setOperand(0, elements);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
};

// Store to the length in an elements header. Note the input is an *index*,
// one less than the desired length.
class LSetArrayLength : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(SetArrayLength)

    LSetArrayLength(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LGetNextEntryForIterator : public LInstructionHelper<1, 2, 3>
{
  public:
    LIR_HEADER(GetNextEntryForIterator)

    explicit LGetNextEntryForIterator(const LAllocation& iter, const LAllocation& result,
                                      const LDefinition& temp0, const LDefinition& temp1,
                                      const LDefinition& temp2)
    {
        setOperand(0, iter);
        setOperand(1, result);
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
    }

    const MGetNextEntryForIterator* mir() const {
        return mir_->toGetNextEntryForIterator();
    }
    const LAllocation* iter() {
        return getOperand(0);
    }
    const LAllocation* result() {
        return getOperand(1);
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
    const LDefinition* temp2() {
        return getTemp(2);
    }
};

// Read the length of a typed array.
class LTypedArrayLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(TypedArrayLength)

    explicit LTypedArrayLength(const LAllocation& obj) {
        setOperand(0, obj);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
};

// Load a typed array's elements vector.
class LTypedArrayElements : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(TypedArrayElements)

    explicit LTypedArrayElements(const LAllocation& object) {
        setOperand(0, object);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
};

// Assign
//
//   target[targetOffset..targetOffset + source.length] = source[0..source.length]
//
// where the source element range doesn't overlap the target element range in
// memory.
class LSetDisjointTypedElements : public LCallInstructionHelper<0, 3, 1>
{
  public:
    LIR_HEADER(SetDisjointTypedElements)

    explicit LSetDisjointTypedElements(const LAllocation& target, const LAllocation& targetOffset,
                                       const LAllocation& source, const LDefinition& temp)
    {
        setOperand(0, target);
        setOperand(1, targetOffset);
        setOperand(2, source);
        setTemp(0, temp);
    }

    const LAllocation* target() {
        return getOperand(0);
    }

    const LAllocation* targetOffset() {
        return getOperand(1);
    }

    const LAllocation* source() {
        return getOperand(2);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Load a typed object's descriptor.
class LTypedObjectDescr : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(TypedObjectDescr)

    explicit LTypedObjectDescr(const LAllocation& object) {
        setOperand(0, object);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
};

// Load a typed object's elements vector.
class LTypedObjectElements : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(TypedObjectElements)

    explicit LTypedObjectElements(const LAllocation& object) {
        setOperand(0, object);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const MTypedObjectElements* mir() const {
        return mir_->toTypedObjectElements();
    }
};

// Load a typed array's elements vector.
class LSetTypedObjectOffset : public LInstructionHelper<0, 2, 2>
{
  public:
    LIR_HEADER(SetTypedObjectOffset)

    LSetTypedObjectOffset(const LAllocation& object,
                          const LAllocation& offset,
                          const LDefinition& temp0,
                          const LDefinition& temp1)
    {
        setOperand(0, object);
        setOperand(1, offset);
        setTemp(0, temp0);
        setTemp(1, temp1);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* offset() {
        return getOperand(1);
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
};

// Bailout if index >= length.
class LBoundsCheck : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(BoundsCheck)

    LBoundsCheck(const LAllocation& index, const LAllocation& length) {
        setOperand(0, index);
        setOperand(1, length);
    }
    const MBoundsCheck* mir() const {
        return mir_->toBoundsCheck();
    }
    const LAllocation* index() {
        return getOperand(0);
    }
    const LAllocation* length() {
        return getOperand(1);
    }
};

// Bailout if index + minimum < 0 or index + maximum >= length.
class LBoundsCheckRange : public LInstructionHelper<0, 2, 1>
{
  public:
    LIR_HEADER(BoundsCheckRange)

    LBoundsCheckRange(const LAllocation& index, const LAllocation& length,
                      const LDefinition& temp)
    {
        setOperand(0, index);
        setOperand(1, length);
        setTemp(0, temp);
    }
    const MBoundsCheck* mir() const {
        return mir_->toBoundsCheck();
    }
    const LAllocation* index() {
        return getOperand(0);
    }
    const LAllocation* length() {
        return getOperand(1);
    }
};

// Bailout if index < minimum.
class LBoundsCheckLower : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(BoundsCheckLower)

    explicit LBoundsCheckLower(const LAllocation& index)
    {
        setOperand(0, index);
    }
    MBoundsCheckLower* mir() const {
        return mir_->toBoundsCheckLower();
    }
    const LAllocation* index() {
        return getOperand(0);
    }
};

// Load a value from a dense array's elements vector. Bail out if it's the hole value.
class LLoadElementV : public LInstructionHelper<BOX_PIECES, 2, 0>
{
  public:
    LIR_HEADER(LoadElementV)

    LLoadElementV(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    const char* extraName() const {
        return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
    }

    const MLoadElement* mir() const {
        return mir_->toLoadElement();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LInArray : public LInstructionHelper<1, 4, 0>
{
  public:
    LIR_HEADER(InArray)

    LInArray(const LAllocation& elements, const LAllocation& index,
             const LAllocation& initLength, const LAllocation& object)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, initLength);
        setOperand(3, object);
    }
    const MInArray* mir() const {
        return mir_->toInArray();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* initLength() {
        return getOperand(2);
    }
    const LAllocation* object() {
        return getOperand(3);
    }
};


// Load a value from an array's elements vector, loading |undefined| if we hit a hole.
// Bail out if we get a negative index.
class LLoadElementHole : public LInstructionHelper<BOX_PIECES, 3, 0>
{
  public:
    LIR_HEADER(LoadElementHole)

    LLoadElementHole(const LAllocation& elements, const LAllocation& index, const LAllocation& initLength) {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, initLength);
    }

    const char* extraName() const {
        return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
    }

    const MLoadElementHole* mir() const {
        return mir_->toLoadElementHole();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* initLength() {
        return getOperand(2);
    }
};

// Load a typed value from a dense array's elements vector. The array must be
// known to be packed, so that we don't have to check for the hole value.
// This instruction does not load the type tag and can directly load into a
// FP register.
class LLoadElementT : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(LoadElementT)

    LLoadElementT(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    const char* extraName() const {
        return mir()->needsHoleCheck() ? "HoleCheck"
                                       : (mir()->loadDoubles() ? "Doubles" : nullptr);
    }

    const MLoadElement* mir() const {
        return mir_->toLoadElement();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LLoadUnboxedPointerV : public LInstructionHelper<BOX_PIECES, 2, 0>
{
  public:
    LIR_HEADER(LoadUnboxedPointerV)

    LLoadUnboxedPointerV(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    const MLoadUnboxedObjectOrNull* mir() const {
        return mir_->toLoadUnboxedObjectOrNull();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LLoadUnboxedPointerT : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(LoadUnboxedPointerT)

    LLoadUnboxedPointerT(const LAllocation& elements, const LAllocation& index) {
        setOperand(0, elements);
        setOperand(1, index);
    }

    MDefinition* mir() {
        MOZ_ASSERT(mir_->isLoadUnboxedObjectOrNull() || mir_->isLoadUnboxedString());
        return mir_;
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LUnboxObjectOrNull : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(UnboxObjectOrNull);

    explicit LUnboxObjectOrNull(const LAllocation& input)
    {
        setOperand(0, input);
    }

    MUnbox* mir() const {
        return mir_->toUnbox();
    }
    const LAllocation* input() {
        return getOperand(0);
    }
};

// Store a boxed value to a dense array's element vector.
class LStoreElementV : public LInstructionHelper<0, 2 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(StoreElementV)

    LStoreElementV(const LAllocation& elements, const LAllocation& index,
                   const LBoxAllocation& value) {
        setOperand(0, elements);
        setOperand(1, index);
        setBoxOperand(Value, value);
    }

    const char* extraName() const {
        return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
    }

    static const size_t Value = 2;

    const MStoreElement* mir() const {
        return mir_->toStoreElement();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

// Store a typed value to a dense array's elements vector. Compared to
// LStoreElementV, this instruction can store doubles and constants directly,
// and does not store the type tag if the array is monomorphic and known to
// be packed.
class LStoreElementT : public LInstructionHelper<0, 3, 0>
{
  public:
    LIR_HEADER(StoreElementT)

    LStoreElementT(const LAllocation& elements, const LAllocation& index, const LAllocation& value) {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
    }

    const char* extraName() const {
        return mir()->needsHoleCheck() ? "HoleCheck" : nullptr;
    }

    const MStoreElement* mir() const {
        return mir_->toStoreElement();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        return getOperand(2);
    }
};

// Like LStoreElementV, but supports indexes >= initialized length.
class LStoreElementHoleV : public LInstructionHelper<0, 3 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(StoreElementHoleV)

    LStoreElementHoleV(const LAllocation& object, const LAllocation& elements,
                       const LAllocation& index, const LBoxAllocation& value,
                       const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, elements);
        setOperand(2, index);
        setBoxOperand(Value, value);
        setTemp(0, temp);
    }

    static const size_t Value = 3;

    const MStoreElementHole* mir() const {
        return mir_->toStoreElementHole();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* elements() {
        return getOperand(1);
    }
    const LAllocation* index() {
        return getOperand(2);
    }
};

// Like LStoreElementT, but supports indexes >= initialized length.
class LStoreElementHoleT : public LInstructionHelper<0, 4, 1>
{
  public:
    LIR_HEADER(StoreElementHoleT)

    LStoreElementHoleT(const LAllocation& object, const LAllocation& elements,
                       const LAllocation& index, const LAllocation& value,
                       const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, elements);
        setOperand(2, index);
        setOperand(3, value);
        setTemp(0, temp);
    }

    const MStoreElementHole* mir() const {
        return mir_->toStoreElementHole();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* elements() {
        return getOperand(1);
    }
    const LAllocation* index() {
        return getOperand(2);
    }
    const LAllocation* value() {
        return getOperand(3);
    }
};

// Like LStoreElementV, but can just ignore assignment (for eg. frozen objects)
class LFallibleStoreElementV : public LInstructionHelper<0, 3 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(FallibleStoreElementV)

    LFallibleStoreElementV(const LAllocation& object, const LAllocation& elements,
                           const LAllocation& index, const LBoxAllocation& value,
                           const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, elements);
        setOperand(2, index);
        setBoxOperand(Value, value);
        setTemp(0, temp);
    }

    static const size_t Value = 3;

    const MFallibleStoreElement* mir() const {
        return mir_->toFallibleStoreElement();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* elements() {
        return getOperand(1);
    }
    const LAllocation* index() {
        return getOperand(2);
    }
};

// Like LStoreElementT, but can just ignore assignment (for eg. frozen objects)
class LFallibleStoreElementT : public LInstructionHelper<0, 4, 1>
{
  public:
    LIR_HEADER(FallibleStoreElementT)

    LFallibleStoreElementT(const LAllocation& object, const LAllocation& elements,
                           const LAllocation& index, const LAllocation& value,
                           const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, elements);
        setOperand(2, index);
        setOperand(3, value);
        setTemp(0, temp);
    }

    const MFallibleStoreElement* mir() const {
        return mir_->toFallibleStoreElement();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* elements() {
        return getOperand(1);
    }
    const LAllocation* index() {
        return getOperand(2);
    }
    const LAllocation* value() {
        return getOperand(3);
    }
};

class LStoreUnboxedPointer : public LInstructionHelper<0, 3, 0>
{
  public:
    LIR_HEADER(StoreUnboxedPointer)

    LStoreUnboxedPointer(LAllocation elements, LAllocation index, LAllocation value) {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
    }

    MDefinition* mir() {
        MOZ_ASSERT(mir_->isStoreUnboxedObjectOrNull() || mir_->isStoreUnboxedString());
        return mir_;
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        return getOperand(2);
    }
};

// If necessary, convert an unboxed object in a particular group to its native
// representation.
class LConvertUnboxedObjectToNative : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(ConvertUnboxedObjectToNative)

    explicit LConvertUnboxedObjectToNative(const LAllocation& object) {
        setOperand(0, object);
    }

    MConvertUnboxedObjectToNative* mir() {
        return mir_->toConvertUnboxedObjectToNative();
    }
};

class LArrayPopShiftV : public LInstructionHelper<BOX_PIECES, 1, 2>
{
  public:
    LIR_HEADER(ArrayPopShiftV)

    LArrayPopShiftV(const LAllocation& object, const LDefinition& temp0, const LDefinition& temp1) {
        setOperand(0, object);
        setTemp(0, temp0);
        setTemp(1, temp1);
    }

    const char* extraName() const {
        return mir()->mode() == MArrayPopShift::Pop ? "Pop" : "Shift";
    }

    const MArrayPopShift* mir() const {
        return mir_->toArrayPopShift();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
};

class LArrayPopShiftT : public LInstructionHelper<1, 1, 2>
{
  public:
    LIR_HEADER(ArrayPopShiftT)

    LArrayPopShiftT(const LAllocation& object, const LDefinition& temp0, const LDefinition& temp1) {
        setOperand(0, object);
        setTemp(0, temp0);
        setTemp(1, temp1);
    }

    const char* extraName() const {
        return mir()->mode() == MArrayPopShift::Pop ? "Pop" : "Shift";
    }

    const MArrayPopShift* mir() const {
        return mir_->toArrayPopShift();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
};

class LArrayPushV : public LInstructionHelper<1, 1 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(ArrayPushV)

    LArrayPushV(const LAllocation& object, const LBoxAllocation& value, const LDefinition& temp) {
        setOperand(0, object);
        setBoxOperand(Value, value);
        setTemp(0, temp);
    }

    static const size_t Value = 1;

    const MArrayPush* mir() const {
        return mir_->toArrayPush();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

class LArrayPushT : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(ArrayPushT)

    LArrayPushT(const LAllocation& object, const LAllocation& value, const LDefinition& temp) {
        setOperand(0, object);
        setOperand(1, value);
        setTemp(0, temp);
    }

    const MArrayPush* mir() const {
        return mir_->toArrayPush();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

class LArraySlice : public LCallInstructionHelper<1, 3, 2>
{
  public:
    LIR_HEADER(ArraySlice)

    LArraySlice(const LAllocation& obj, const LAllocation& begin, const LAllocation& end,
                const LDefinition& temp1, const LDefinition& temp2) {
        setOperand(0, obj);
        setOperand(1, begin);
        setOperand(2, end);
        setTemp(0, temp1);
        setTemp(1, temp2);
    }
    const MArraySlice* mir() const {
        return mir_->toArraySlice();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* begin() {
        return getOperand(1);
    }
    const LAllocation* end() {
        return getOperand(2);
    }
    const LDefinition* temp1() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }
};

class LArrayJoin : public LCallInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(ArrayJoin)

    LArrayJoin(const LAllocation& array, const LAllocation& sep) {
        setOperand(0, array);
        setOperand(1, sep);
    }

    const MArrayJoin* mir() const {
        return mir_->toArrayJoin();
    }
    const LAllocation* array() {
        return getOperand(0);
    }
    const LAllocation* separator() {
        return getOperand(1);
    }
};

class LLoadUnboxedScalar : public LInstructionHelper<1, 2, 1>
{
  public:
    LIR_HEADER(LoadUnboxedScalar)

    LLoadUnboxedScalar(const LAllocation& elements, const LAllocation& index,
                       const LDefinition& temp) {
        setOperand(0, elements);
        setOperand(1, index);
        setTemp(0, temp);
    }
    const MLoadUnboxedScalar* mir() const {
        return mir_->toLoadUnboxedScalar();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

class LLoadTypedArrayElementHole : public LInstructionHelper<BOX_PIECES, 2, 0>
{
  public:
    LIR_HEADER(LoadTypedArrayElementHole)

    LLoadTypedArrayElementHole(const LAllocation& object, const LAllocation& index) {
        setOperand(0, object);
        setOperand(1, index);
    }
    const MLoadTypedArrayElementHole* mir() const {
        return mir_->toLoadTypedArrayElementHole();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LLoadTypedArrayElementStatic : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LoadTypedArrayElementStatic);
    explicit LLoadTypedArrayElementStatic(const LAllocation& ptr) {
        setOperand(0, ptr);
    }
    MLoadTypedArrayElementStatic* mir() const {
        return mir_->toLoadTypedArrayElementStatic();
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
};

class LStoreUnboxedScalar : public LInstructionHelper<0, 3, 0>
{
  public:
    LIR_HEADER(StoreUnboxedScalar)

    LStoreUnboxedScalar(const LAllocation& elements, const LAllocation& index,
                        const LAllocation& value) {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
    }

    const MStoreUnboxedScalar* mir() const {
        return mir_->toStoreUnboxedScalar();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        return getOperand(2);
    }
};

class LStoreTypedArrayElementHole : public LInstructionHelper<0, 4, 0>
{
  public:
    LIR_HEADER(StoreTypedArrayElementHole)

    LStoreTypedArrayElementHole(const LAllocation& elements, const LAllocation& length,
                                const LAllocation& index, const LAllocation& value)
    {
        setOperand(0, elements);
        setOperand(1, length);
        setOperand(2, index);
        setOperand(3, value);
    }

    const MStoreTypedArrayElementHole* mir() const {
        return mir_->toStoreTypedArrayElementHole();
    }
    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* length() {
        return getOperand(1);
    }
    const LAllocation* index() {
        return getOperand(2);
    }
    const LAllocation* value() {
        return getOperand(3);
    }
};

class LStoreTypedArrayElementStatic : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(StoreTypedArrayElementStatic);
    LStoreTypedArrayElementStatic(const LAllocation& ptr, const LAllocation& value) {
        setOperand(0, ptr);
        setOperand(1, value);
    }
    MStoreTypedArrayElementStatic* mir() const {
        return mir_->toStoreTypedArrayElementStatic();
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
};

class LAtomicIsLockFree : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(AtomicIsLockFree)

    explicit LAtomicIsLockFree(const LAllocation& value) {
        setOperand(0, value);
    }
    const LAllocation* value() {
        return getOperand(0);
    }
};

class LCompareExchangeTypedArrayElement : public LInstructionHelper<1, 4, 4>
{
  public:
    LIR_HEADER(CompareExchangeTypedArrayElement)

    LCompareExchangeTypedArrayElement(const LAllocation& elements, const LAllocation& index,
                                      const LAllocation& oldval, const LAllocation& newval,
                                      const LDefinition& temp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, oldval);
        setOperand(3, newval);
        setTemp(0, temp);
    }
    LCompareExchangeTypedArrayElement(const LAllocation& elements, const LAllocation& index,
                                      const LAllocation& oldval, const LAllocation& newval,
                                      const LDefinition& temp, const LDefinition& valueTemp,
                                      const LDefinition& offsetTemp, const LDefinition& maskTemp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, oldval);
        setOperand(3, newval);
        setTemp(0, temp);
        setTemp(1, valueTemp);
        setTemp(2, offsetTemp);
        setTemp(3, maskTemp);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* oldval() {
        return getOperand(2);
    }
    const LAllocation* newval() {
        return getOperand(3);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(1);
    }
    const LDefinition* offsetTemp() {
        return getTemp(2);
    }
    const LDefinition* maskTemp() {
        return getTemp(3);
    }

    const MCompareExchangeTypedArrayElement* mir() const {
        return mir_->toCompareExchangeTypedArrayElement();
    }
};

class LAtomicExchangeTypedArrayElement : public LInstructionHelper<1, 3, 4>
{
  public:
    LIR_HEADER(AtomicExchangeTypedArrayElement)

    LAtomicExchangeTypedArrayElement(const LAllocation& elements, const LAllocation& index,
                                     const LAllocation& value, const LDefinition& temp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, temp);
    }
    LAtomicExchangeTypedArrayElement(const LAllocation& elements, const LAllocation& index,
                                     const LAllocation& value, const LDefinition& temp,
                                     const LDefinition& valueTemp, const LDefinition& offsetTemp,
                                     const LDefinition& maskTemp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, temp);
        setTemp(1, valueTemp);
        setTemp(2, offsetTemp);
        setTemp(3, maskTemp);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        return getOperand(2);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(1);
    }
    const LDefinition* offsetTemp() {
        return getTemp(2);
    }
    const LDefinition* maskTemp() {
        return getTemp(3);
    }

    const MAtomicExchangeTypedArrayElement* mir() const {
        return mir_->toAtomicExchangeTypedArrayElement();
    }
};

class LAtomicTypedArrayElementBinop : public LInstructionHelper<1, 3, 5>
{
  public:
    LIR_HEADER(AtomicTypedArrayElementBinop)

    static const int32_t valueOp = 2;

    LAtomicTypedArrayElementBinop(const LAllocation& elements, const LAllocation& index,
                                  const LAllocation& value, const LDefinition& temp1,
                                  const LDefinition& temp2)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, temp1);
        setTemp(1, temp2);
    }
    LAtomicTypedArrayElementBinop(const LAllocation& elements, const LAllocation& index,
                                  const LAllocation& value, const LDefinition& temp1,
                                  const LDefinition& temp2, const LDefinition& valueTemp,
                                  const LDefinition& offsetTemp, const LDefinition& maskTemp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, valueTemp);
        setTemp(3, offsetTemp);
        setTemp(4, maskTemp);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        MOZ_ASSERT(valueOp == 2);
        return getOperand(2);
    }
    const LDefinition* temp1() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }

    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(2);
    }
    const LDefinition* offsetTemp() {
        return getTemp(3);
    }
    const LDefinition* maskTemp() {
        return getTemp(4);
    }

    const MAtomicTypedArrayElementBinop* mir() const {
        return mir_->toAtomicTypedArrayElementBinop();
    }
};

// Atomic binary operation where the result is discarded.
class LAtomicTypedArrayElementBinopForEffect : public LInstructionHelper<0, 3, 4>
{
  public:
    LIR_HEADER(AtomicTypedArrayElementBinopForEffect)

    LAtomicTypedArrayElementBinopForEffect(const LAllocation& elements, const LAllocation& index,
                                           const LAllocation& value,
                                           const LDefinition& flagTemp = LDefinition::BogusTemp())
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, flagTemp);
    }
    LAtomicTypedArrayElementBinopForEffect(const LAllocation& elements, const LAllocation& index,
                                           const LAllocation& value, const LDefinition& flagTemp,
                                           const LDefinition& valueTemp, const LDefinition& offsetTemp,
                                           const LDefinition& maskTemp)
    {
        setOperand(0, elements);
        setOperand(1, index);
        setOperand(2, value);
        setTemp(0, flagTemp);
        setTemp(1, valueTemp);
        setTemp(2, offsetTemp);
        setTemp(3, maskTemp);
    }

    const LAllocation* elements() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const LAllocation* value() {
        return getOperand(2);
    }

    // Temp that may be used on LL/SC platforms for the flag result of the store.
    const LDefinition* flagTemp() {
        return getTemp(0);
    }
    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(1);
    }
    const LDefinition* offsetTemp() {
        return getTemp(2);
    }
    const LDefinition* maskTemp() {
        return getTemp(3);
    }

    const MAtomicTypedArrayElementBinop* mir() const {
        return mir_->toAtomicTypedArrayElementBinop();
    }
};

class LEffectiveAddress : public LInstructionHelper<1, 2, 0>
{
  public:
    LIR_HEADER(EffectiveAddress);

    LEffectiveAddress(const LAllocation& base, const LAllocation& index) {
        setOperand(0, base);
        setOperand(1, index);
    }
    const MEffectiveAddress* mir() const {
        return mir_->toEffectiveAddress();
    }
    const LAllocation* base() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
};

class LClampIToUint8 : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(ClampIToUint8)

    explicit LClampIToUint8(const LAllocation& in) {
        setOperand(0, in);
    }
};

class LClampDToUint8 : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(ClampDToUint8)

    LClampDToUint8(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }
};

class LClampVToUint8 : public LInstructionHelper<1, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(ClampVToUint8)

    LClampVToUint8(const LBoxAllocation& input, const LDefinition& tempFloat) {
        setBoxOperand(Input, input);
        setTemp(0, tempFloat);
    }

    static const size_t Input = 0;

    const LDefinition* tempFloat() {
        return getTemp(0);
    }
    const MClampToUint8* mir() const {
        return mir_->toClampToUint8();
    }
};

// Load a boxed value from an object's fixed slot.
class LLoadFixedSlotV : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(LoadFixedSlotV)

    explicit LLoadFixedSlotV(const LAllocation& object) {
        setOperand(0, object);
    }
    const MLoadFixedSlot* mir() const {
        return mir_->toLoadFixedSlot();
    }
};

// Load a typed value from an object's fixed slot.
class LLoadFixedSlotT : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LoadFixedSlotT)

    explicit LLoadFixedSlotT(const LAllocation& object) {
        setOperand(0, object);
    }
    const MLoadFixedSlot* mir() const {
        return mir_->toLoadFixedSlot();
    }
};

class LLoadFixedSlotAndUnbox : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LoadFixedSlotAndUnbox)

    explicit LLoadFixedSlotAndUnbox(const LAllocation& object) {
        setOperand(0, object);
    }

    const MLoadFixedSlotAndUnbox* mir() const {
        return mir_->toLoadFixedSlotAndUnbox();
    }
};

// Store a boxed value to an object's fixed slot.
class LStoreFixedSlotV : public LInstructionHelper<0, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(StoreFixedSlotV)

    LStoreFixedSlotV(const LAllocation& obj, const LBoxAllocation& value) {
        setOperand(0, obj);
        setBoxOperand(Value, value);
    }

    static const size_t Value = 1;

    const MStoreFixedSlot* mir() const {
        return mir_->toStoreFixedSlot();
    }
    const LAllocation* obj() {
        return getOperand(0);
    }
};

// Store a typed value to an object's fixed slot.
class LStoreFixedSlotT : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(StoreFixedSlotT)

    LStoreFixedSlotT(const LAllocation& obj, const LAllocation& value)
    {
        setOperand(0, obj);
        setOperand(1, value);
    }
    const MStoreFixedSlot* mir() const {
        return mir_->toStoreFixedSlot();
    }
    const LAllocation* obj() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
};

// Note, Name ICs always return a Value. There are no V/T variants.
class LGetNameCache : public LInstructionHelper<BOX_PIECES, 1, 1>
{
  public:
    LIR_HEADER(GetNameCache)

    LGetNameCache(const LAllocation& envObj, const LDefinition& temp) {
        setOperand(0, envObj);
        setTemp(0, temp);
    }
    const LAllocation* envObj() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MGetNameCache* mir() const {
        return mir_->toGetNameCache();
    }
};

class LCallGetIntrinsicValue : public LCallInstructionHelper<BOX_PIECES, 0, 0>
{
  public:
    LIR_HEADER(CallGetIntrinsicValue)

    const MCallGetIntrinsicValue* mir() const {
        return mir_->toCallGetIntrinsicValue();
    }
};

// Patchable jump to stubs generated for a GetProperty cache, which loads a
// boxed value.
class LGetPropertyCacheV : public LInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 1>
{
  public:
    LIR_HEADER(GetPropertyCacheV)

    static const size_t Value = 0;
    static const size_t Id = BOX_PIECES;

    LGetPropertyCacheV(const LBoxAllocation& value, const LBoxAllocation& id,
                       const LDefinition& temp) {
        setBoxOperand(Value, value);
        setBoxOperand(Id, id);
        setTemp(0, temp);
    }
    const MGetPropertyCache* mir() const {
        return mir_->toGetPropertyCache();
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Patchable jump to stubs generated for a GetProperty cache, which loads a
// value of a known type, possibly into an FP register.
class LGetPropertyCacheT : public LInstructionHelper<1, 2 * BOX_PIECES, 1>
{
  public:
    LIR_HEADER(GetPropertyCacheT)

    static const size_t Value = 0;
    static const size_t Id = BOX_PIECES;

    LGetPropertyCacheT(const LBoxAllocation& value, const LBoxAllocation& id,
                       const LDefinition& temp) {
        setBoxOperand(Value, value);
        setBoxOperand(Id, id);
        setTemp(0, temp);
    }
    const MGetPropertyCache* mir() const {
        return mir_->toGetPropertyCache();
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Emit code to load a boxed value from an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LGetPropertyPolymorphicV : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(GetPropertyPolymorphicV)

    explicit LGetPropertyPolymorphicV(const LAllocation& obj) {
        setOperand(0, obj);
    }
    const LAllocation* obj() {
        return getOperand(0);
    }
    const MGetPropertyPolymorphic* mir() const {
        return mir_->toGetPropertyPolymorphic();
    }
    virtual const char* extraName() const {
        return PropertyNameToExtraName(mir()->name());
    }
};

// Emit code to load a typed value from an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LGetPropertyPolymorphicT : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(GetPropertyPolymorphicT)

    LGetPropertyPolymorphicT(const LAllocation& obj, const LDefinition& temp) {
        setOperand(0, obj);
        setTemp(0, temp);
    }
    const LAllocation* obj() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MGetPropertyPolymorphic* mir() const {
        return mir_->toGetPropertyPolymorphic();
    }
    virtual const char* extraName() const {
        return PropertyNameToExtraName(mir()->name());
    }
};

// Emit code to store a boxed value to an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LSetPropertyPolymorphicV : public LInstructionHelper<0, 1 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(SetPropertyPolymorphicV)

    LSetPropertyPolymorphicV(const LAllocation& obj, const LBoxAllocation& value,
                             const LDefinition& temp) {
        setOperand(0, obj);
        setBoxOperand(Value, value);
        setTemp(0, temp);
    }

    static const size_t Value = 1;

    const LAllocation* obj() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MSetPropertyPolymorphic* mir() const {
        return mir_->toSetPropertyPolymorphic();
    }
};

// Emit code to store a typed value to an object's slots if its shape matches
// one of the shapes observed by the baseline IC, else bails out.
class LSetPropertyPolymorphicT : public LInstructionHelper<0, 2, 1>
{
    MIRType valueType_;

  public:
    LIR_HEADER(SetPropertyPolymorphicT)

    LSetPropertyPolymorphicT(const LAllocation& obj, const LAllocation& value, MIRType valueType,
                             const LDefinition& temp)
      : valueType_(valueType)
    {
        setOperand(0, obj);
        setOperand(1, value);
        setTemp(0, temp);
    }

    const LAllocation* obj() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MIRType valueType() const {
        return valueType_;
    }
    const MSetPropertyPolymorphic* mir() const {
        return mir_->toSetPropertyPolymorphic();
    }
    const char* extraName() const {
        return StringFromMIRType(valueType_);
    }
};

class LBindNameCache : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(BindNameCache)

    LBindNameCache(const LAllocation& envChain, const LDefinition& temp) {
        setOperand(0, envChain);
        setTemp(0, temp);
    }
    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MBindNameCache* mir() const {
        return mir_->toBindNameCache();
    }
};

class LCallBindVar : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CallBindVar)

    explicit LCallBindVar(const LAllocation& envChain) {
        setOperand(0, envChain);
    }
    const LAllocation* environmentChain() {
        return getOperand(0);
    }
    const MCallBindVar* mir() const {
        return mir_->toCallBindVar();
    }
};

// Load a value from an object's dslots or a slots vector.
class LLoadSlotV : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(LoadSlotV)

    explicit LLoadSlotV(const LAllocation& in) {
        setOperand(0, in);
    }
    const MLoadSlot* mir() const {
        return mir_->toLoadSlot();
    }
};

// Load a typed value from an object's dslots or a slots vector. Unlike
// LLoadSlotV, this can bypass extracting a type tag, directly retrieving a
// pointer, integer, or double.
class LLoadSlotT : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LoadSlotT)

    explicit LLoadSlotT(const LAllocation& slots) {
        setOperand(0, slots);
    }
    const LAllocation* slots() {
        return getOperand(0);
    }
    const LDefinition* output() {
        return this->getDef(0);
    }
    const MLoadSlot* mir() const {
        return mir_->toLoadSlot();
    }
};

// Store a value to an object's dslots or a slots vector.
class LStoreSlotV : public LInstructionHelper<0, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(StoreSlotV)

    LStoreSlotV(const LAllocation& slots, const LBoxAllocation& value) {
        setOperand(0, slots);
        setBoxOperand(Value, value);
    }

    static const size_t Value = 1;

    const MStoreSlot* mir() const {
        return mir_->toStoreSlot();
    }
    const LAllocation* slots() {
        return getOperand(0);
    }
};

// Store a typed value to an object's dslots or a slots vector. This has a
// few advantages over LStoreSlotV:
// 1) We can bypass storing the type tag if the slot has the same type as
//    the value.
// 2) Better register allocation: we can store constants and FP regs directly
//    without requiring a second register for the value.
class LStoreSlotT : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(StoreSlotT)

    LStoreSlotT(const LAllocation& slots, const LAllocation& value) {
        setOperand(0, slots);
        setOperand(1, value);
    }
    const MStoreSlot* mir() const {
        return mir_->toStoreSlot();
    }
    const LAllocation* slots() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
};

// Read length field of a JSString*.
class LStringLength : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(StringLength)

    explicit LStringLength(const LAllocation& string) {
        setOperand(0, string);
    }

    const LAllocation* string() {
        return getOperand(0);
    }
};

// Take the floor of a double precision number and converts it to an int32.
// Implements Math.floor().
class LFloor : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Floor)

    explicit LFloor(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Take the floor of a single precision number and converts it to an int32.
// Implements Math.floor().
class LFloorF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(FloorF)

    explicit LFloorF(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Take the ceiling of a double precision number and converts it to an int32.
// Implements Math.ceil().
class LCeil : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(Ceil)

    explicit LCeil(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Take the ceiling of a single precision number and converts it to an int32.
// Implements Math.ceil().
class LCeilF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CeilF)

    explicit LCeilF(const LAllocation& num) {
        setOperand(0, num);
    }
};

// Round a double precision number and converts it to an int32.
// Implements Math.round().
class LRound : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(Round)

    LRound(const LAllocation& num, const LDefinition& temp) {
        setOperand(0, num);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
    MRound* mir() const {
        return mir_->toRound();
    }
};

// Round a single precision number and converts it to an int32.
// Implements Math.round().
class LRoundF : public LInstructionHelper<1, 1, 1>
{
  public:
    LIR_HEADER(RoundF)

    LRoundF(const LAllocation& num, const LDefinition& temp) {
        setOperand(0, num);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
    MRound* mir() const {
        return mir_->toRound();
    }
};

// Rounds a double precision number accordingly to mir()->roundingMode(),
// and keeps a double output.
class LNearbyInt : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NearbyInt)

    explicit LNearbyInt(const LAllocation& num) {
        setOperand(0, num);
    }
    MNearbyInt* mir() const {
        return mir_->toNearbyInt();
    }
};

// Rounds a single precision number accordingly to mir()->roundingMode(),
// and keeps a single output.
class LNearbyIntF : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NearbyIntF)

    explicit LNearbyIntF(const LAllocation& num) {
        setOperand(0, num);
    }
    MNearbyInt* mir() const {
        return mir_->toNearbyInt();
    }
};

// Load a function's call environment.
class LFunctionEnvironment : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(FunctionEnvironment)

    explicit LFunctionEnvironment(const LAllocation& function) {
        setOperand(0, function);
    }
    const LAllocation* function() {
        return getOperand(0);
    }
};

// Allocate a new LexicalEnvironmentObject.
class LNewLexicalEnvironmentObject : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(NewLexicalEnvironmentObject)

    explicit LNewLexicalEnvironmentObject(const LAllocation& enclosing) {
        setOperand(0, enclosing);
    }
    const LAllocation* enclosing() {
        return getOperand(0);
    }

    MNewLexicalEnvironmentObject* mir() const {
        return mir_->toNewLexicalEnvironmentObject();
    }
};

// Copy a LexicalEnvironmentObject.
class LCopyLexicalEnvironmentObject : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CopyLexicalEnvironmentObject)

    explicit LCopyLexicalEnvironmentObject(const LAllocation& env) {
        setOperand(0, env);
    }
    const LAllocation* env() {
        return getOperand(0);
    }

    MCopyLexicalEnvironmentObject* mir() const {
        return mir_->toCopyLexicalEnvironmentObject();
    }
};

class LCallGetProperty : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallGetProperty)

    static const size_t Value = 0;

    explicit LCallGetProperty(const LBoxAllocation& val) {
        setBoxOperand(Value, val);
    }

    MCallGetProperty* mir() const {
        return mir_->toCallGetProperty();
    }
};

// Call js::GetElement.
class LCallGetElement : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallGetElement)

    static const size_t LhsInput = 0;
    static const size_t RhsInput = BOX_PIECES;

    LCallGetElement(const LBoxAllocation& lhs, const LBoxAllocation& rhs) {
        setBoxOperand(LhsInput, lhs);
        setBoxOperand(RhsInput, rhs);
    }

    MCallGetElement* mir() const {
        return mir_->toCallGetElement();
    }
};

// Call js::SetElement.
class LCallSetElement : public LCallInstructionHelper<0, 1 + 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallSetElement)

    static const size_t Index = 1;
    static const size_t Value = 1 + BOX_PIECES;

    LCallSetElement(const LAllocation& obj, const LBoxAllocation& index,
                    const LBoxAllocation& value) {
        setOperand(0, obj);
        setBoxOperand(Index, index);
        setBoxOperand(Value, value);
    }

    const MCallSetElement* mir() const {
        return mir_->toCallSetElement();
    }
};

// Call js::InitElementArray.
class LCallInitElementArray : public LCallInstructionHelper<0, 2 + BOX_PIECES, 0>
{
public:
    LIR_HEADER(CallInitElementArray)

    static const size_t Value = 2;

    LCallInitElementArray(const LAllocation& obj, const LAllocation& index,
                          const LBoxAllocation& value) {
        setOperand(0, obj);
        setOperand(1, index);
        setBoxOperand(Value, value);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* index() {
        return getOperand(1);
    }
    const MCallInitElementArray* mir() const {
        return mir_->toCallInitElementArray();
    }
};

// Call a VM function to perform a property or name assignment of a generic value.
class LCallSetProperty : public LCallInstructionHelper<0, 1 + BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallSetProperty)

    LCallSetProperty(const LAllocation& obj, const LBoxAllocation& value) {
        setOperand(0, obj);
        setBoxOperand(Value, value);
    }

    static const size_t Value = 1;

    const MCallSetProperty* mir() const {
        return mir_->toCallSetProperty();
    }
};

class LCallDeleteProperty : public LCallInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallDeleteProperty)

    static const size_t Value = 0;

    explicit LCallDeleteProperty(const LBoxAllocation& value) {
        setBoxOperand(Value, value);
    }

    MDeleteProperty* mir() const {
        return mir_->toDeleteProperty();
    }
};

class LCallDeleteElement : public LCallInstructionHelper<1, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallDeleteElement)

    static const size_t Value = 0;
    static const size_t Index = BOX_PIECES;

    LCallDeleteElement(const LBoxAllocation& value, const LBoxAllocation& index) {
        setBoxOperand(Value, value);
        setBoxOperand(Index, index);
    }

    MDeleteElement* mir() const {
        return mir_->toDeleteElement();
    }
};

// Patchable jump to stubs generated for a SetProperty cache.
class LSetPropertyCache : public LInstructionHelper<0, 1 + 2 * BOX_PIECES, 3>
{
  public:
    LIR_HEADER(SetPropertyCache)

    LSetPropertyCache(const LAllocation& object, const LBoxAllocation& id,
                      const LBoxAllocation& value, const LDefinition& temp,
                      const LDefinition& tempDouble, const LDefinition& tempFloat32) {
        setOperand(0, object);
        setBoxOperand(Id, id);
        setBoxOperand(Value, value);
        setTemp(0, temp);
        setTemp(1, tempDouble);
        setTemp(2, tempFloat32);
    }

    static const size_t Id = 1;
    static const size_t Value = 1 + BOX_PIECES;

    const MSetPropertyCache* mir() const {
        return mir_->toSetPropertyCache();
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
    const LDefinition* tempDouble() {
        return getTemp(1);
    }
    const LDefinition* tempFloat32() {
        if (hasUnaliasedDouble())
            return getTemp(2);
        return getTemp(1);
    }
};

class LCallIteratorStartV : public LCallInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CallIteratorStartV)

    static const size_t Value = 0;

    explicit LCallIteratorStartV(const LBoxAllocation& value) {
        setBoxOperand(Value, value);
    }
    MIteratorStart* mir() const {
        return mir_->toIteratorStart();
    }
};

class LCallIteratorStartO : public LCallInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(CallIteratorStartO)

    explicit LCallIteratorStartO(const LAllocation& object) {
        setOperand(0, object);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    MIteratorStart* mir() const {
        return mir_->toIteratorStart();
    }
};

class LIteratorStartO : public LInstructionHelper<1, 1, 3>
{
  public:
    LIR_HEADER(IteratorStartO)

    LIteratorStartO(const LAllocation& object, const LDefinition& temp1,
                    const LDefinition& temp2, const LDefinition& temp3) {
        setOperand(0, object);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, temp3);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp1() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }
    const LDefinition* temp3() {
        return getTemp(2);
    }
    MIteratorStart* mir() const {
        return mir_->toIteratorStart();
    }
};

class LIteratorMore : public LInstructionHelper<BOX_PIECES, 1, 1>
{
  public:
    LIR_HEADER(IteratorMore)

    LIteratorMore(const LAllocation& iterator, const LDefinition& temp) {
        setOperand(0, iterator);
        setTemp(0, temp);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    MIteratorMore* mir() const {
        return mir_->toIteratorMore();
    }
};

class LIsNoIterAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(IsNoIterAndBranch)

    LIsNoIterAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse, const LBoxAllocation& input) {
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
        setBoxOperand(Input, input);
    }

    static const size_t Input = 0;

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

class LIteratorEnd : public LInstructionHelper<0, 1, 3>
{
  public:
    LIR_HEADER(IteratorEnd)

    LIteratorEnd(const LAllocation& iterator, const LDefinition& temp1,
                 const LDefinition& temp2, const LDefinition& temp3) {
        setOperand(0, iterator);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, temp3);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp1() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }
    const LDefinition* temp3() {
        return getTemp(2);
    }
    MIteratorEnd* mir() const {
        return mir_->toIteratorEnd();
    }
};

// Read the number of actual arguments.
class LArgumentsLength : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(ArgumentsLength)
};

// Load a value from the actual arguments.
class LGetFrameArgument : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    LIR_HEADER(GetFrameArgument)

    explicit LGetFrameArgument(const LAllocation& index) {
        setOperand(0, index);
    }
    const LAllocation* index() {
        return getOperand(0);
    }
};

// Load a value from the actual arguments.
class LSetFrameArgumentT : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(SetFrameArgumentT)

    explicit LSetFrameArgumentT(const LAllocation& input) {
        setOperand(0, input);
    }
    MSetFrameArgument* mir() const {
        return mir_->toSetFrameArgument();
    }
    const LAllocation* input() {
        return getOperand(0);
    }
};

// Load a value from the actual arguments.
class LSetFrameArgumentC : public LInstructionHelper<0, 0, 0>
{
    Value val_;

  public:
    LIR_HEADER(SetFrameArgumentC)

    explicit LSetFrameArgumentC(const Value& val) {
        val_ = val;
    }
    MSetFrameArgument* mir() const {
        return mir_->toSetFrameArgument();
    }
    const Value& val() const {
        return val_;
    }
};

// Load a value from the actual arguments.
class LSetFrameArgumentV : public LInstructionHelper<0, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(SetFrameArgumentV)

    explicit LSetFrameArgumentV(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    static const size_t Input = 0;

    MSetFrameArgument* mir() const {
        return mir_->toSetFrameArgument();
    }
};

class LRunOncePrologue : public LCallInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(RunOncePrologue)

    MRunOncePrologue* mir() const {
        return mir_->toRunOncePrologue();
    }
};

// Create the rest parameter.
class LRest : public LCallInstructionHelper<1, 1, 3>
{
  public:
    LIR_HEADER(Rest)

    LRest(const LAllocation& numActuals, const LDefinition& temp1, const LDefinition& temp2,
          const LDefinition& temp3)
    {
        setOperand(0, numActuals);
        setTemp(0, temp1);
        setTemp(1, temp2);
        setTemp(2, temp3);
    }
    const LAllocation* numActuals() {
        return getOperand(0);
    }
    MRest* mir() const {
        return mir_->toRest();
    }
};

class LGuardReceiverPolymorphic : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(GuardReceiverPolymorphic)

    LGuardReceiverPolymorphic(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MGuardReceiverPolymorphic* mir() const {
        return mir_->toGuardReceiverPolymorphic();
    }
};

class LGuardUnboxedExpando : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(GuardUnboxedExpando)

    explicit LGuardUnboxedExpando(const LAllocation& in) {
        setOperand(0, in);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const MGuardUnboxedExpando* mir() const {
        return mir_->toGuardUnboxedExpando();
    }
};

class LLoadUnboxedExpando : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(LoadUnboxedExpando)

    explicit LLoadUnboxedExpando(const LAllocation& in) {
        setOperand(0, in);
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const MLoadUnboxedExpando* mir() const {
        return mir_->toLoadUnboxedExpando();
    }
};

// Guard that a value is in a TypeSet.
class LTypeBarrierV : public LInstructionHelper<0, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(TypeBarrierV)

    LTypeBarrierV(const LBoxAllocation& input, const LDefinition& temp) {
        setBoxOperand(Input, input);
        setTemp(0, temp);
    }

    static const size_t Input = 0;

    const MTypeBarrier* mir() const {
        return mir_->toTypeBarrier();
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Guard that a object is in a TypeSet.
class LTypeBarrierO : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(TypeBarrierO)

    LTypeBarrierO(const LAllocation& obj, const LDefinition& temp) {
        setOperand(0, obj);
        setTemp(0, temp);
    }
    const MTypeBarrier* mir() const {
        return mir_->toTypeBarrier();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Guard that a value is in a TypeSet.
class LMonitorTypes : public LInstructionHelper<0, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(MonitorTypes)

    LMonitorTypes(const LBoxAllocation& input, const LDefinition& temp) {
        setBoxOperand(Input, input);
        setTemp(0, temp);
    }

    static const size_t Input = 0;

    const MMonitorTypes* mir() const {
        return mir_->toMonitorTypes();
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Generational write barrier used when writing an object to another object.
class LPostWriteBarrierO : public LInstructionHelper<0, 2, 1>
{
  public:
    LIR_HEADER(PostWriteBarrierO)

    LPostWriteBarrierO(const LAllocation& obj, const LAllocation& value,
                       const LDefinition& temp) {
        setOperand(0, obj);
        setOperand(1, value);
        setTemp(0, temp);
    }

    const MPostWriteBarrier* mir() const {
        return mir_->toPostWriteBarrier();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Generational write barrier used when writing a value to another object.
class LPostWriteBarrierV : public LInstructionHelper<0, 1 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(PostWriteBarrierV)

    LPostWriteBarrierV(const LAllocation& obj, const LBoxAllocation& value,
                       const LDefinition& temp) {
        setOperand(0, obj);
        setBoxOperand(Input, value);
        setTemp(0, temp);
    }

    static const size_t Input = 1;

    const MPostWriteBarrier* mir() const {
        return mir_->toPostWriteBarrier();
    }
    const LAllocation* object() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Generational write barrier used when writing an object to another object's
// elements.
class LPostWriteElementBarrierO : public LInstructionHelper<0, 3, 1>
{
  public:
    LIR_HEADER(PostWriteElementBarrierO)

    LPostWriteElementBarrierO(const LAllocation& obj, const LAllocation& value,
                              const LAllocation& index, const LDefinition& temp) {
        setOperand(0, obj);
        setOperand(1, value);
        setOperand(2, index);
        setTemp(0, temp);
    }

    const MPostWriteElementBarrier* mir() const {
        return mir_->toPostWriteElementBarrier();
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    const LAllocation* value() {
        return getOperand(1);
    }

    const LAllocation* index() {
        return getOperand(2);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Generational write barrier used when writing a value to another object's
// elements.
class LPostWriteElementBarrierV : public LInstructionHelper<0, 2 + BOX_PIECES, 1>
{
  public:
    LIR_HEADER(PostWriteElementBarrierV)

    LPostWriteElementBarrierV(const LAllocation& obj, const LAllocation& index,
                              const LBoxAllocation& value, const LDefinition& temp) {
        setOperand(0, obj);
        setOperand(1, index);
        setBoxOperand(Input, value);
        setTemp(0, temp);
    }

    static const size_t Input = 2;

    const MPostWriteElementBarrier* mir() const {
        return mir_->toPostWriteElementBarrier();
    }

    const LAllocation* object() {
        return getOperand(0);
    }

    const LAllocation* index() {
        return getOperand(1);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }
};

// Guard against an object's identity.
class LGuardObjectIdentity : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(GuardObjectIdentity)

    explicit LGuardObjectIdentity(const LAllocation& in, const LAllocation& expected) {
        setOperand(0, in);
        setOperand(1, expected);
    }
    const LAllocation* input() {
        return getOperand(0);
    }
    const LAllocation* expected() {
        return getOperand(1);
    }
    const MGuardObjectIdentity* mir() const {
        return mir_->toGuardObjectIdentity();
    }
};

// Guard against an object's class.
class LGuardClass : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(GuardClass)

    LGuardClass(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }
    const MGuardClass* mir() const {
        return mir_->toGuardClass();
    }
    const LDefinition* tempInt() {
        return getTemp(0);
    }
};

// Guard against the sharedness of a TypedArray's memory.
class LGuardSharedTypedArray : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(GuardSharedTypedArray)

    LGuardSharedTypedArray(const LAllocation& in, const LDefinition& temp) {
        setOperand(0, in);
        setTemp(0, temp);
    }
    const MGuardSharedTypedArray* mir() const {
        return mir_->toGuardSharedTypedArray();
    }
    const LDefinition* tempInt() {
        return getTemp(0);
    }
};

class LInCache : public LInstructionHelper<1, BOX_PIECES+1, 1>
{
  public:
    LIR_HEADER(InCache)
    LInCache(const LBoxAllocation& lhs, const LAllocation& rhs, const LDefinition& temp) {
        setBoxOperand(LHS, lhs);
        setOperand(RHS, rhs);
        setTemp(0, temp);
    }

    const LAllocation* lhs() {
        return getOperand(LHS);
    }
    const LAllocation* rhs() {
        return getOperand(RHS);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const MInCache* mir() const {
        return mir_->toInCache();
    }

    static const size_t LHS = 0;
    static const size_t RHS = BOX_PIECES;
};

class LHasOwnCache : public LInstructionHelper<1, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(HasOwnCache)

    static const size_t Value = 0;
    static const size_t Id = BOX_PIECES;

    LHasOwnCache(const LBoxAllocation& value, const LBoxAllocation& id) {
        setBoxOperand(Value, value);
        setBoxOperand(Id, id);
    }

    const MHasOwnCache* mir() const {
        return mir_->toHasOwnCache();
    }
};

class LInstanceOfO : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(InstanceOfO)
    explicit LInstanceOfO(const LAllocation& lhs) {
        setOperand(0, lhs);
    }

    MInstanceOf* mir() const {
        return mir_->toInstanceOf();
    }

    const LAllocation* lhs() {
        return getOperand(0);
    }
};

class LInstanceOfV : public LInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(InstanceOfV)
    explicit LInstanceOfV(const LBoxAllocation& lhs) {
        setBoxOperand(LHS, lhs);
    }

    MInstanceOf* mir() const {
        return mir_->toInstanceOf();
    }

    const LAllocation* lhs() {
        return getOperand(LHS);
    }

    static const size_t LHS = 0;
};

class LCallInstanceOf : public LCallInstructionHelper<1, BOX_PIECES+1, 0>
{
  public:
    LIR_HEADER(CallInstanceOf)
    LCallInstanceOf(const LBoxAllocation& lhs, const LAllocation& rhs) {
        setBoxOperand(LHS, lhs);
        setOperand(RHS, rhs);
    }

    const LDefinition* output() {
        return this->getDef(0);
    }
    const LAllocation* lhs() {
        return getOperand(LHS);
    }
    const LAllocation* rhs() {
        return getOperand(RHS);
    }

    static const size_t LHS = 0;
    static const size_t RHS = BOX_PIECES;
};

class LIsCallable : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(IsCallable);
    explicit LIsCallable(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    MIsCallable* mir() const {
        return mir_->toIsCallable();
    }
};

class LIsConstructor : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(IsConstructor);
    explicit LIsConstructor(const LAllocation& object) {
        setOperand(0, object);
    }

    const LAllocation* object() {
        return getOperand(0);
    }
    MIsConstructor* mir() const {
        return mir_->toIsConstructor();
    }
};

class LIsObject : public LInstructionHelper<1, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(IsObject);
    static const size_t Input = 0;

    explicit LIsObject(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    MIsObject* mir() const {
        return mir_->toIsObject();
    }
};

class LIsObjectAndBranch : public LControlInstructionHelper<2, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(IsObjectAndBranch)

    LIsObjectAndBranch(MBasicBlock* ifTrue, MBasicBlock* ifFalse, const LBoxAllocation& input) {
        setSuccessor(0, ifTrue);
        setSuccessor(1, ifFalse);
        setBoxOperand(Input, input);
    }

    static const size_t Input = 0;

    MBasicBlock* ifTrue() const {
        return getSuccessor(0);
    }
    MBasicBlock* ifFalse() const {
        return getSuccessor(1);
    }
};

class LHasClass : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(HasClass);
    explicit LHasClass(const LAllocation& lhs) {
        setOperand(0, lhs);
    }

    const LAllocation* lhs() {
        return getOperand(0);
    }
    MHasClass* mir() const {
        return mir_->toHasClass();
    }
};

template<size_t Defs, size_t Ops>
class LWasmSelectBase : public LInstructionHelper<Defs, Ops, 0>
{
    typedef LInstructionHelper<Defs, Ops, 0> Base;
  public:

    MWasmSelect* mir() const {
        return Base::mir_->toWasmSelect();
    }
};

class LWasmSelect : public LWasmSelectBase<1, 3>
{
  public:
    LIR_HEADER(WasmSelect);

    static const size_t TrueExprIndex = 0;
    static const size_t FalseExprIndex = 1;
    static const size_t CondIndex = 2;

    LWasmSelect(const LAllocation& trueExpr, const LAllocation& falseExpr,
                const LAllocation& cond)
    {
        setOperand(TrueExprIndex, trueExpr);
        setOperand(FalseExprIndex, falseExpr);
        setOperand(CondIndex, cond);
    }

    const LAllocation* trueExpr() {
        return getOperand(TrueExprIndex);
    }
    const LAllocation* falseExpr() {
        return getOperand(FalseExprIndex);
    }
    const LAllocation* condExpr() {
        return getOperand(CondIndex);
    }
};

class LWasmSelectI64 : public LWasmSelectBase<INT64_PIECES, 2 * INT64_PIECES + 1>
{
  public:
    LIR_HEADER(WasmSelectI64);

    static const size_t TrueExprIndex = 0;
    static const size_t FalseExprIndex = INT64_PIECES;
    static const size_t CondIndex = INT64_PIECES * 2;

    LWasmSelectI64(const LInt64Allocation& trueExpr, const LInt64Allocation& falseExpr,
                   const LAllocation& cond)
    {
        setInt64Operand(TrueExprIndex, trueExpr);
        setInt64Operand(FalseExprIndex, falseExpr);
        setOperand(CondIndex, cond);
    }

    const LInt64Allocation trueExpr() {
        return getInt64Operand(TrueExprIndex);
    }
    const LInt64Allocation falseExpr() {
        return getInt64Operand(FalseExprIndex);
    }
    const LAllocation* condExpr() {
        return getOperand(CondIndex);
    }
};

class LWasmAddOffset : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(WasmAddOffset);
    explicit LWasmAddOffset(const LAllocation& base) {
        setOperand(0, base);
    }
    MWasmAddOffset* mir() const {
        return mir_->toWasmAddOffset();
    }
    const LAllocation* base() {
        return getOperand(0);
    }
};

class LWasmBoundsCheck : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(WasmBoundsCheck);
    explicit LWasmBoundsCheck(const LAllocation& ptr,
                              const LAllocation& boundsCheckLimit = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, boundsCheckLimit);
    }
    MWasmBoundsCheck* mir() const {
        return mir_->toWasmBoundsCheck();
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* boundsCheckLimit() {
        return getOperand(1);
    }
};

class LWasmLoadTls : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(WasmLoadTls);
    explicit LWasmLoadTls(const LAllocation& tlsPtr) {
        setOperand(0, tlsPtr);
    }
    MWasmLoadTls* mir() const {
        return mir_->toWasmLoadTls();
    }
    const LAllocation* tlsPtr() {
        return getOperand(0);
    }
};

namespace details {

// This is a base class for LWasmLoad/LWasmLoadI64.
template<size_t Defs, size_t Temp>
class LWasmLoadBase : public LInstructionHelper<Defs, 2, Temp>
{
  public:
    typedef LInstructionHelper<Defs, 2, Temp> Base;
    explicit LWasmLoadBase(const LAllocation& ptr, const LAllocation& memoryBase) {
        Base::setOperand(0, ptr);
        Base::setOperand(1, memoryBase);
    }
    MWasmLoad* mir() const {
        return Base::mir_->toWasmLoad();
    }
    const LAllocation* ptr() {
        return Base::getOperand(0);
    }
    const LAllocation* memoryBase() {
        return Base::getOperand(1);
    }
};

} // namespace details

class LWasmLoad : public details::LWasmLoadBase<1, 1>
{
  public:
    explicit LWasmLoad(const LAllocation& ptr, const LAllocation& memoryBase = LAllocation())
      : LWasmLoadBase(ptr, memoryBase)
    {
        setTemp(0, LDefinition::BogusTemp());
    }

    const LDefinition* ptrCopy() {
        return Base::getTemp(0);
    }

    LIR_HEADER(WasmLoad);
};

class LWasmLoadI64 : public details::LWasmLoadBase<INT64_PIECES, 1>
{
  public:
    explicit LWasmLoadI64(const LAllocation& ptr, const LAllocation& memoryBase = LAllocation())
      : LWasmLoadBase(ptr, memoryBase)
    {
        setTemp(0, LDefinition::BogusTemp());
    }

    const LDefinition* ptrCopy() {
        return Base::getTemp(0);
    }

    LIR_HEADER(WasmLoadI64);
};

class LWasmStore : public LInstructionHelper<0, 3, 1>
{
  public:
    LIR_HEADER(WasmStore);

    static const size_t PtrIndex = 0;
    static const size_t ValueIndex = 1;
    static const size_t MemoryBaseIndex = 2;

    LWasmStore(const LAllocation& ptr, const LAllocation& value,
               const LAllocation& memoryBase = LAllocation())
    {
        setOperand(PtrIndex, ptr);
        setOperand(ValueIndex, value);
        setOperand(MemoryBaseIndex, memoryBase);
        setTemp(0, LDefinition::BogusTemp());
    }
    MWasmStore* mir() const {
        return mir_->toWasmStore();
    }
    const LAllocation* ptr() {
        return getOperand(PtrIndex);
    }
    const LDefinition* ptrCopy() {
        return getTemp(0);
    }
    const LAllocation* value() {
        return getOperand(ValueIndex);
    }
    const LAllocation* memoryBase() {
        return getOperand(MemoryBaseIndex);
    }
};

class LWasmStoreI64 : public LInstructionHelper<0, INT64_PIECES + 2, 1>
{
  public:
    LIR_HEADER(WasmStoreI64);

    static const size_t PtrIndex = 0;
    static const size_t MemoryBaseIndex = 1;
    static const size_t ValueIndex = 2;

    LWasmStoreI64(const LAllocation& ptr, const LInt64Allocation& value,
                  const LAllocation& memoryBase = LAllocation())
    {
        setOperand(PtrIndex, ptr);
        setOperand(MemoryBaseIndex, memoryBase);
        setInt64Operand(ValueIndex, value);
        setTemp(0, LDefinition::BogusTemp());
    }
    MWasmStore* mir() const {
        return mir_->toWasmStore();
    }
    const LAllocation* ptr() {
        return getOperand(PtrIndex);
    }
    const LAllocation* memoryBase() {
        return getOperand(MemoryBaseIndex);
    }
    const LDefinition* ptrCopy() {
        return getTemp(0);
    }
    const LInt64Allocation value() {
        return getInt64Operand(ValueIndex);
    }
};

class LAsmJSLoadHeap : public LInstructionHelper<1, 3, 0>
{
  public:
    LIR_HEADER(AsmJSLoadHeap);
    explicit LAsmJSLoadHeap(const LAllocation& ptr, const LAllocation& boundsCheckLimit = LAllocation(),
                            const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, boundsCheckLimit);
        setOperand(2, memoryBase);
    }
    MAsmJSLoadHeap* mir() const {
        return mir_->toAsmJSLoadHeap();
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* boundsCheckLimit() {
        return getOperand(1);
    }
    const LAllocation* memoryBase() {
        return getOperand(2);
    }
};

class LAsmJSStoreHeap : public LInstructionHelper<0, 4, 0>
{
  public:
    LIR_HEADER(AsmJSStoreHeap);
    LAsmJSStoreHeap(const LAllocation& ptr, const LAllocation& value,
                    const LAllocation& boundsCheckLimit = LAllocation(),
                    const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, boundsCheckLimit);
        setOperand(3, memoryBase);
    }
    MAsmJSStoreHeap* mir() const {
        return mir_->toAsmJSStoreHeap();
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LAllocation* boundsCheckLimit() {
        return getOperand(2);
    }
    const LAllocation* memoryBase() {
        return getOperand(3);
    }
};

class LAsmJSCompareExchangeHeap : public LInstructionHelper<1, 4, 4>
{
  public:
    LIR_HEADER(AsmJSCompareExchangeHeap);

    // ARM, ARM64, x86, x64
    LAsmJSCompareExchangeHeap(const LAllocation& ptr, const LAllocation& oldValue,
                              const LAllocation& newValue, const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, oldValue);
        setOperand(2, newValue);
        setOperand(3, memoryBase);
        setTemp(0, LDefinition::BogusTemp());
    }
    // MIPS32, MIPS64
    LAsmJSCompareExchangeHeap(const LAllocation& ptr, const LAllocation& oldValue,
                              const LAllocation& newValue, const LDefinition& valueTemp,
                              const LDefinition& offsetTemp, const LDefinition& maskTemp)
    {
        setOperand(0, ptr);
        setOperand(1, oldValue);
        setOperand(2, newValue);
        setOperand(3, LAllocation());
        setTemp(0, LDefinition::BogusTemp());
        setTemp(1, valueTemp);
        setTemp(2, offsetTemp);
        setTemp(3, maskTemp);
    }

    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* oldValue() {
        return getOperand(1);
    }
    const LAllocation* newValue() {
        return getOperand(2);
    }
    const LAllocation* memoryBase() {
        return getOperand(3);
    }
    const LDefinition* addrTemp() {
        return getTemp(0);
    }

    void setAddrTemp(const LDefinition& addrTemp) {
        setTemp(0, addrTemp);
    }

    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(1);
    }
    const LDefinition* offsetTemp() {
        return getTemp(2);
    }
    const LDefinition* maskTemp() {
        return getTemp(3);
    }

    MAsmJSCompareExchangeHeap* mir() const {
        return mir_->toAsmJSCompareExchangeHeap();
    }
};

class LAsmJSAtomicExchangeHeap : public LInstructionHelper<1, 3, 4>
{
  public:
    LIR_HEADER(AsmJSAtomicExchangeHeap);

    // ARM, ARM64, x86, x64
    LAsmJSAtomicExchangeHeap(const LAllocation& ptr, const LAllocation& value,
                             const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, memoryBase);
        setTemp(0, LDefinition::BogusTemp());
    }
    // MIPS32, MIPS64
    LAsmJSAtomicExchangeHeap(const LAllocation& ptr, const LAllocation& value,
                             const LDefinition& valueTemp, const LDefinition& offsetTemp,
                             const LDefinition& maskTemp)
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, LAllocation());
        setTemp(0, LDefinition::BogusTemp());
        setTemp(1, valueTemp);
        setTemp(2, offsetTemp);
        setTemp(3, maskTemp);
    }

    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LAllocation* memoryBase() {
        return getOperand(2);
    }
    const LDefinition* addrTemp() {
        return getTemp(0);
    }

    void setAddrTemp(const LDefinition& addrTemp) {
        setTemp(0, addrTemp);
    }

    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(1);
    }
    const LDefinition* offsetTemp() {
        return getTemp(2);
    }
    const LDefinition* maskTemp() {
        return getTemp(3);
    }

    MAsmJSAtomicExchangeHeap* mir() const {
        return mir_->toAsmJSAtomicExchangeHeap();
    }
};

class LAsmJSAtomicBinopHeap : public LInstructionHelper<1, 3, 6>
{
  public:
    LIR_HEADER(AsmJSAtomicBinopHeap);

    static const int32_t valueOp = 1;

    // ARM, ARM64, x86, x64
    LAsmJSAtomicBinopHeap(const LAllocation& ptr, const LAllocation& value,
                          const LDefinition& temp,
                          const LDefinition& flagTemp = LDefinition::BogusTemp(),
                          const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, memoryBase);
        setTemp(0, temp);
        setTemp(1, LDefinition::BogusTemp());
        setTemp(2, flagTemp);
    }
    // MIPS32, MIPS64
    LAsmJSAtomicBinopHeap(const LAllocation& ptr, const LAllocation& value,
                          const LDefinition& temp, const LDefinition& flagTemp,
                          const LDefinition& valueTemp, const LDefinition& offsetTemp,
                          const LDefinition& maskTemp)
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, LAllocation());
        setTemp(0, temp);
        setTemp(1, LDefinition::BogusTemp());
        setTemp(2, flagTemp);
        setTemp(3, valueTemp);
        setTemp(4, offsetTemp);
        setTemp(5, maskTemp);
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* value() {
        MOZ_ASSERT(valueOp == 1);
        return getOperand(1);
    }
    const LAllocation* memoryBase() {
        return getOperand(2);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }

    // Temp that may be used on some platforms to hold a computed address.
    const LDefinition* addrTemp() {
        return getTemp(1);
    }
    void setAddrTemp(const LDefinition& addrTemp) {
        setTemp(1, addrTemp);
    }

    // Temp that may be used on LL/SC platforms for the flag result of the store.
    const LDefinition* flagTemp() {
        return getTemp(2);
    }
    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(3);
    }
    const LDefinition* offsetTemp() {
        return getTemp(4);
    }
    const LDefinition* maskTemp() {
        return getTemp(5);
    }

    MAsmJSAtomicBinopHeap* mir() const {
        return mir_->toAsmJSAtomicBinopHeap();
    }
};

// Atomic binary operation where the result is discarded.
class LAsmJSAtomicBinopHeapForEffect : public LInstructionHelper<0, 3, 5>
{
  public:
    LIR_HEADER(AsmJSAtomicBinopHeapForEffect);
    // ARM, ARM64, x86, x64
    LAsmJSAtomicBinopHeapForEffect(const LAllocation& ptr, const LAllocation& value,
                                   const LDefinition& flagTemp = LDefinition::BogusTemp(),
                                   const LAllocation& memoryBase = LAllocation())
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, memoryBase);
        setTemp(0, LDefinition::BogusTemp());
        setTemp(1, flagTemp);
    }
    // MIPS32, MIPS64
    LAsmJSAtomicBinopHeapForEffect(const LAllocation& ptr, const LAllocation& value,
                                   const LDefinition& flagTemp, const LDefinition& valueTemp,
                                   const LDefinition& offsetTemp, const LDefinition& maskTemp)
    {
        setOperand(0, ptr);
        setOperand(1, value);
        setOperand(2, LAllocation());
        setTemp(0, LDefinition::BogusTemp());
        setTemp(1, flagTemp);
        setTemp(2, valueTemp);
        setTemp(3, offsetTemp);
        setTemp(4, maskTemp);
    }
    const LAllocation* ptr() {
        return getOperand(0);
    }
    const LAllocation* value() {
        return getOperand(1);
    }
    const LAllocation* memoryBase() {
        return getOperand(2);
    }

    // Temp that may be used on some platforms to hold a computed address.
    const LDefinition* addrTemp() {
        return getTemp(0);
    }
    void setAddrTemp(const LDefinition& addrTemp) {
        setTemp(0, addrTemp);
    }

    // Temp that may be used on LL/SC platforms for the flag result of the store.
    const LDefinition* flagTemp() {
        return getTemp(1);
    }
    // Temp that may be used on LL/SC platforms for extract/insert bits of word.
    const LDefinition* valueTemp() {
        return getTemp(2);
    }
    const LDefinition* offsetTemp() {
        return getTemp(3);
    }
    const LDefinition* maskTemp() {
        return getTemp(4);
    }

    MAsmJSAtomicBinopHeap* mir() const {
        return mir_->toAsmJSAtomicBinopHeap();
    }
};

class LWasmLoadGlobalVar : public LInstructionHelper<1, 1, 0>
{
  public:
    LIR_HEADER(WasmLoadGlobalVar);
    explicit LWasmLoadGlobalVar(const LAllocation& tlsPtr) {
        setOperand(0, tlsPtr);
    }
    MWasmLoadGlobalVar* mir() const {
        return mir_->toWasmLoadGlobalVar();
    }
    const LAllocation* tlsPtr() {
        return getOperand(0);
    }
};

class LWasmLoadGlobalVarI64 : public LInstructionHelper<INT64_PIECES, 1, 0>
{
  public:
    LIR_HEADER(WasmLoadGlobalVarI64);
    explicit LWasmLoadGlobalVarI64(const LAllocation& tlsPtr) {
        setOperand(0, tlsPtr);
    }
    MWasmLoadGlobalVar* mir() const {
        return mir_->toWasmLoadGlobalVar();
    }
    const LAllocation* tlsPtr() {
        return getOperand(0);
    }
};

class LWasmStoreGlobalVar : public LInstructionHelper<0, 2, 0>
{
  public:
    LIR_HEADER(WasmStoreGlobalVar);
    explicit LWasmStoreGlobalVar(const LAllocation& value, const LAllocation& tlsPtr) {
        setOperand(0, value);
        setOperand(1, tlsPtr);
    }
    MWasmStoreGlobalVar* mir() const {
        return mir_->toWasmStoreGlobalVar();
    }
    const LAllocation* value() {
        return getOperand(0);
    }
    const LAllocation* tlsPtr() {
        return getOperand(1);
    }
};

class LWasmStoreGlobalVarI64 : public LInstructionHelper<0, INT64_PIECES + 1, 0>
{
  public:
    LIR_HEADER(WasmStoreGlobalVarI64);
    explicit LWasmStoreGlobalVarI64(const LInt64Allocation& value, const LAllocation& tlsPtr) {
        setInt64Operand(0, value);
        setOperand(INT64_PIECES, tlsPtr);
    }
    MWasmStoreGlobalVar* mir() const {
        return mir_->toWasmStoreGlobalVar();
    }
    const LInt64Allocation value() {
        return getInt64Operand(0);
    }
    const LAllocation* tlsPtr() {
        return getOperand(INT64_PIECES);
    }
};

class LWasmParameter : public LInstructionHelper<1, 0, 0>
{
  public:
    LIR_HEADER(WasmParameter);
};

class LWasmParameterI64 : public LInstructionHelper<INT64_PIECES, 0, 0>
{
  public:
    LIR_HEADER(WasmParameterI64);
};

class LWasmReturn : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(WasmReturn);
};

class LWasmReturnI64 : public LInstructionHelper<0, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(WasmReturnI64)

    explicit LWasmReturnI64(const LInt64Allocation& input) {
        setInt64Operand(0, input);
    }
};

class LWasmReturnVoid : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(WasmReturnVoid);
};

class LWasmStackArg : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(WasmStackArg);
    explicit LWasmStackArg(const LAllocation& arg) {
        setOperand(0, arg);
    }
    MWasmStackArg* mir() const {
        return mirRaw()->toWasmStackArg();
    }
    const LAllocation* arg() {
        return getOperand(0);
    }
};

class LWasmStackArgI64 : public LInstructionHelper<0, INT64_PIECES, 0>
{
  public:
    LIR_HEADER(WasmStackArgI64);
    explicit LWasmStackArgI64(const LInt64Allocation& arg) {
        setInt64Operand(0, arg);
    }
    MWasmStackArg* mir() const {
        return mirRaw()->toWasmStackArg();
    }
    const LInt64Allocation arg() {
        return getInt64Operand(0);
    }
};

class LWasmCallBase : public LInstruction
{
    LAllocation* operands_;
    uint32_t numOperands_;
    uint32_t needsBoundsCheck_;

  public:

    LWasmCallBase(LAllocation* operands, uint32_t numOperands, bool needsBoundsCheck)
      : operands_(operands),
        numOperands_(numOperands),
        needsBoundsCheck_(needsBoundsCheck)
    {}

    MWasmCall* mir() const {
        return mir_->toWasmCall();
    }

    bool isCall() const override {
        return true;
    }
    bool isCallPreserved(AnyRegister reg) const override {
        // All MWasmCalls preserve the TLS register:
        //  - internal/indirect calls do by the internal wasm ABI
        //  - import calls do by explicitly saving/restoring at the callsite
        //  - builtin calls do because the TLS reg is non-volatile
        // See also CodeGeneratorShared::emitWasmCallBase.
        return !reg.isFloat() && reg.gpr() == WasmTlsReg;
    }

    // LInstruction interface
    size_t numOperands() const override {
        return numOperands_;
    }
    LAllocation* getOperand(size_t index) override {
        MOZ_ASSERT(index < numOperands_);
        return &operands_[index];
    }
    void setOperand(size_t index, const LAllocation& a) override {
        MOZ_ASSERT(index < numOperands_);
        operands_[index] = a;
    }
    size_t numTemps() const override {
        return 0;
    }
    LDefinition* getTemp(size_t index) override {
        MOZ_CRASH("no temps");
    }
    void setTemp(size_t index, const LDefinition& a) override {
        MOZ_CRASH("no temps");
    }
    size_t numSuccessors() const override {
        return 0;
    }
    MBasicBlock* getSuccessor(size_t i) const override {
        MOZ_CRASH("no successors");
    }
    void setSuccessor(size_t i, MBasicBlock*) override {
        MOZ_CRASH("no successors");
    }
    bool needsBoundsCheck() const {
        return needsBoundsCheck_;
    }
};

class LWasmCall : public LWasmCallBase
{
     LDefinition def_;

  public:
    LIR_HEADER(WasmCall);

    LWasmCall(LAllocation* operands, uint32_t numOperands, bool needsBoundsCheck)
      : LWasmCallBase(operands, numOperands, needsBoundsCheck),
        def_(LDefinition::BogusTemp())
    {}

    // LInstruction interface
    size_t numDefs() const {
        return def_.isBogusTemp() ? 0 : 1;
    }
    LDefinition* getDef(size_t index) {
        MOZ_ASSERT(numDefs() == 1);
        MOZ_ASSERT(index == 0);
        return &def_;
    }
    void setDef(size_t index, const LDefinition& def) {
        MOZ_ASSERT(index == 0);
        def_ = def;
    }
};

class LWasmCallI64 : public LWasmCallBase
{
    LDefinition defs_[INT64_PIECES];

  public:
    LIR_HEADER(WasmCallI64);

    LWasmCallI64(LAllocation* operands, uint32_t numOperands, bool needsBoundsCheck)
      : LWasmCallBase(operands, numOperands, needsBoundsCheck)
    {
        for (size_t i = 0; i < numDefs(); i++)
            defs_[i] = LDefinition::BogusTemp();
    }

    // LInstruction interface
    size_t numDefs() const {
        return INT64_PIECES;
    }
    LDefinition* getDef(size_t index) {
        MOZ_ASSERT(index < numDefs());
        return &defs_[index];
    }
    void setDef(size_t index, const LDefinition& def) {
        MOZ_ASSERT(index < numDefs());
        defs_[index] = def;
    }
};

class LAssertRangeI : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(AssertRangeI)

    explicit LAssertRangeI(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* input() {
        return getOperand(0);
    }

    MAssertRange* mir() {
        return mir_->toAssertRange();
    }
    const Range* range() {
        return mir()->assertedRange();
    }
};

class LAssertRangeD : public LInstructionHelper<0, 1, 1>
{
  public:
    LIR_HEADER(AssertRangeD)

    LAssertRangeD(const LAllocation& input, const LDefinition& temp) {
        setOperand(0, input);
        setTemp(0, temp);
    }

    const LAllocation* input() {
        return getOperand(0);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MAssertRange* mir() {
        return mir_->toAssertRange();
    }
    const Range* range() {
        return mir()->assertedRange();
    }
};

class LAssertRangeF : public LInstructionHelper<0, 1, 2>
{
  public:
    LIR_HEADER(AssertRangeF)
    LAssertRangeF(const LAllocation& input, const LDefinition& temp, const LDefinition& temp2) {
        setOperand(0, input);
        setTemp(0, temp);
        setTemp(1, temp2);
    }

    const LAllocation* input() {
        return getOperand(0);
    }
    const LDefinition* temp() {
        return getTemp(0);
    }
    const LDefinition* temp2() {
        return getTemp(1);
    }

    MAssertRange* mir() {
        return mir_->toAssertRange();
    }
    const Range* range() {
        return mir()->assertedRange();
    }
};

class LAssertRangeV : public LInstructionHelper<0, BOX_PIECES, 3>
{
  public:
    LIR_HEADER(AssertRangeV)

    LAssertRangeV(const LBoxAllocation& input, const LDefinition& temp,
                  const LDefinition& floatTemp1, const LDefinition& floatTemp2)
    {
        setBoxOperand(Input, input);
        setTemp(0, temp);
        setTemp(1, floatTemp1);
        setTemp(2, floatTemp2);
    }

    static const size_t Input = 0;

    const LDefinition* temp() {
        return getTemp(0);
    }
    const LDefinition* floatTemp1() {
        return getTemp(1);
    }
    const LDefinition* floatTemp2() {
        return getTemp(2);
    }

    MAssertRange* mir() {
        return mir_->toAssertRange();
    }
    const Range* range() {
        return mir()->assertedRange();
    }
};

class LAssertResultT : public LInstructionHelper<0, 1, 0>
{
  public:
    LIR_HEADER(AssertResultT)

    explicit LAssertResultT(const LAllocation& input) {
        setOperand(0, input);
    }

    const LAllocation* input() {
        return getOperand(0);
    }
};

class LAssertResultV : public LInstructionHelper<0, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(AssertResultV)

    static const size_t Input = 0;

    explicit LAssertResultV(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }
};

class LRecompileCheck : public LInstructionHelper<0, 0, 1>
{
  public:
    LIR_HEADER(RecompileCheck)

    explicit LRecompileCheck(const LDefinition& scratch) {
        setTemp(0, scratch);
    }

    const LDefinition* scratch() {
        return getTemp(0);
    }
    MRecompileCheck* mir() {
        return mir_->toRecompileCheck();
    }
};

class LLexicalCheck : public LInstructionHelper<0, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(LexicalCheck)

    explicit LLexicalCheck(const LBoxAllocation& input) {
        setBoxOperand(Input, input);
    }

    MLexicalCheck* mir() {
        return mir_->toLexicalCheck();
    }

    static const size_t Input = 0;
};

class LThrowRuntimeLexicalError : public LCallInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(ThrowRuntimeLexicalError)

    MThrowRuntimeLexicalError* mir() {
        return mir_->toThrowRuntimeLexicalError();
    }
};

class LGlobalNameConflictsCheck : public LInstructionHelper<0, 0, 0>
{
  public:
    LIR_HEADER(GlobalNameConflictsCheck)

    MGlobalNameConflictsCheck* mir() {
        return mir_->toGlobalNameConflictsCheck();
    }
};

class LMemoryBarrier : public LInstructionHelper<0, 0, 0>
{
  private:
    const MemoryBarrierBits type_;

  public:
    LIR_HEADER(MemoryBarrier)

    // The parameter 'type' is a bitwise 'or' of the barrier types needed,
    // see AtomicOp.h.
    explicit LMemoryBarrier(MemoryBarrierBits type) : type_(type)
    {
        MOZ_ASSERT((type_ & ~MembarAllbits) == MembarNobits);
    }

    MemoryBarrierBits type() const {
        return type_;
    }
};

class LDebugger : public LCallInstructionHelper<0, 0, 2>
{
  public:
    LIR_HEADER(Debugger)

    LDebugger(const LDefinition& temp1, const LDefinition& temp2) {
        setTemp(0, temp1);
        setTemp(1, temp2);
    }
};

class LNewTarget : public LInstructionHelper<BOX_PIECES, 0, 0>
{
  public:
    LIR_HEADER(NewTarget)
};

class LArrowNewTarget : public LInstructionHelper<BOX_PIECES, 1, 0>
{
  public:
    explicit LArrowNewTarget(const LAllocation& callee) {
        setOperand(0, callee);
    }

    LIR_HEADER(ArrowNewTarget)

    const LAllocation* callee() {
        return getOperand(0);
    }
};

// Math.random().
#ifdef JS_PUNBOX64
# define LRANDOM_NUM_TEMPS 3
#else
# define LRANDOM_NUM_TEMPS 5
#endif

class LRandom : public LInstructionHelper<1, 0, LRANDOM_NUM_TEMPS>
{
  public:
    LIR_HEADER(Random)
    LRandom(const LDefinition &temp0, const LDefinition &temp1,
            const LDefinition &temp2
#ifndef JS_PUNBOX64
            , const LDefinition &temp3, const LDefinition &temp4
#endif
            )
    {
        setTemp(0, temp0);
        setTemp(1, temp1);
        setTemp(2, temp2);
#ifndef JS_PUNBOX64
        setTemp(3, temp3);
        setTemp(4, temp4);
#endif
    }
    const LDefinition* temp0() {
        return getTemp(0);
    }
    const LDefinition* temp1() {
        return getTemp(1);
    }
    const LDefinition *temp2() {
        return getTemp(2);
    }
#ifndef JS_PUNBOX64
    const LDefinition *temp3() {
        return getTemp(3);
    }
    const LDefinition *temp4() {
        return getTemp(4);
    }
#endif

    MRandom* mir() const {
        return mir_->toRandom();
    }
};

class LCheckReturn : public LCallInstructionHelper<BOX_PIECES, 2 * BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CheckReturn)

    LCheckReturn(const LBoxAllocation& retVal, const LBoxAllocation& thisVal) {
        setBoxOperand(ReturnValue, retVal);
        setBoxOperand(ThisValue, thisVal);
    }

    static const size_t ReturnValue = 0;
    static const size_t ThisValue = BOX_PIECES;
};

class LCheckIsObj : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CheckIsObj)

    static const size_t CheckValue = 0;

    explicit LCheckIsObj(const LBoxAllocation& value) {
        setBoxOperand(CheckValue, value);
    }

    MCheckIsObj* mir() const {
        return mir_->toCheckIsObj();
    }
};

class LCheckIsCallable : public LInstructionHelper<BOX_PIECES, BOX_PIECES, 1>
{
  public:
    LIR_HEADER(CheckIsCallable)

    static const size_t CheckValue = 0;

    LCheckIsCallable(const LBoxAllocation& value, const LDefinition& temp) {
        setBoxOperand(CheckValue, value);
        setTemp(0, temp);
    }

    const LDefinition* temp() {
        return getTemp(0);
    }

    MCheckIsCallable* mir() const {
        return mir_->toCheckIsCallable();
    }
};

class LCheckObjCoercible : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(CheckObjCoercible)

    static const size_t CheckValue = 0;

    explicit LCheckObjCoercible(const LBoxAllocation& value) {
        setBoxOperand(CheckValue, value);
    }
};

class LDebugCheckSelfHosted : public LCallInstructionHelper<BOX_PIECES, BOX_PIECES, 0>
{
  public:
    LIR_HEADER(DebugCheckSelfHosted)

    static const size_t CheckValue = 0;

    explicit LDebugCheckSelfHosted(const LBoxAllocation& value) {
        setBoxOperand(CheckValue, value);
    }
};

} // namespace jit
} // namespace js

#endif /* jit_shared_LIR_shared_h */
