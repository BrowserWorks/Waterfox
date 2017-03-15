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

#include "wasm/WasmBinaryToAST.h"

#include "mozilla/CheckedInt.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/Sprintf.h"

#include "jscntxt.h"

#include "wasm/WasmBinaryFormat.h"
#include "wasm/WasmBinaryIterator.h"

using namespace js;
using namespace js::wasm;

using mozilla::CheckedInt;
using mozilla::FloorLog2;

enum AstDecodeTerminationKind
{
    Unknown,
    End,
    Else
};

struct AstDecodeStackItem
{
    AstExpr* expr;
    AstDecodeTerminationKind terminationKind;
    ExprType type;

    explicit AstDecodeStackItem()
      : expr(nullptr),
        terminationKind(AstDecodeTerminationKind::Unknown),
        type(ExprType::Limit)
    {}
    explicit AstDecodeStackItem(AstDecodeTerminationKind terminationKind, ExprType type)
      : expr(nullptr),
        terminationKind(terminationKind),
        type(type)
    {}
    explicit AstDecodeStackItem(AstExpr* expr)
     : expr(expr),
       terminationKind(AstDecodeTerminationKind::Unknown),
       type(ExprType::Limit)
    {}
};

// We don't define a Value type because OpIter doesn't push void values, which
// we actually need here because we're building an AST, so we maintain our own
// stack.
struct AstDecodePolicy : OpIterPolicy
{
    // Enable validation because we can be called from wasmBinaryToText on bytes
    // which are not necessarily valid, and we shouldn't run the decoder in
    // non-validating mode on invalid code.
    static const bool Validate = true;

    static const bool Output = true;
};

typedef OpIter<AstDecodePolicy> AstDecodeOpIter;

class AstDecodeContext
{
  public:
    typedef AstVector<uint32_t> AstIndexVector;
    typedef AstVector<AstDecodeStackItem> AstDecodeStack;
    typedef AstVector<uint32_t> DepthStack;

    JSContext* cx;
    LifoAlloc& lifo;
    Decoder& d;
    bool generateNames;

  private:
    AstModule& module_;
    AstIndexVector funcDefSigs_;
    AstDecodeOpIter *iter_;
    AstDecodeStack exprs_;
    DepthStack depths_;
    const ValTypeVector* locals_;
    GlobalDescVector globals_;
    AstNameVector blockLabels_;
    uint32_t currentLabelIndex_;
    ExprType retType_;

  public:
    AstDecodeContext(JSContext* cx, LifoAlloc& lifo, Decoder& d, AstModule& module,
                     bool generateNames)
     : cx(cx),
       lifo(lifo),
       d(d),
       generateNames(generateNames),
       module_(module),
       funcDefSigs_(lifo),
       iter_(nullptr),
       exprs_(lifo),
       depths_(lifo),
       locals_(nullptr),
       blockLabels_(lifo),
       currentLabelIndex_(0),
       retType_(ExprType::Limit)
    {}

    AstModule& module() { return module_; }
    AstIndexVector& funcDefSigs() { return funcDefSigs_; }
    AstDecodeOpIter& iter() { return *iter_; }
    AstDecodeStack& exprs() { return exprs_; }
    DepthStack& depths() { return depths_; }

    AstNameVector& blockLabels() { return blockLabels_; }

    ExprType retType() const { return retType_; }
    const ValTypeVector& locals() const { return *locals_; }

    bool addGlobalDesc(ValType type, bool isMutable, bool isImport) {
        if (isImport)
            return globals_.append(GlobalDesc(type, isMutable, globals_.length()));
        // No need to have the precise init expr value; we just need the right
        // type.
        Val dummy;
        switch (type) {
          case ValType::I32: dummy = Val(uint32_t(0)); break;
          case ValType::I64: dummy = Val(uint64_t(0)); break;
          case ValType::F32: dummy = Val(RawF32(0.f)); break;
          case ValType::F64: dummy = Val(RawF64(0.0)); break;
          default:           return false;
        }
        return globals_.append(GlobalDesc(InitExpr(dummy), isMutable));
    }
    const GlobalDescVector& globalDescs() const { return globals_; }

    void popBack() { return exprs().popBack(); }
    AstDecodeStackItem popCopy() { return exprs().popCopy(); }
    AstDecodeStackItem& top() { return exprs().back(); }
    MOZ_MUST_USE bool push(AstDecodeStackItem item) { return exprs().append(item); }

    bool needFirst() {
        for (size_t i = depths().back(); i < exprs().length(); ++i) {
            if (!exprs()[i].expr->isVoid())
                return true;
        }
        return false;
    }

    AstExpr* handleVoidExpr(AstExpr* voidNode)
    {
        MOZ_ASSERT(voidNode->isVoid());

        // To attach a node that "returns void" to the middle of an AST, wrap it
        // in a first node next to the node it should accompany.
        if (needFirst()) {
            AstExpr *prev = popCopy().expr;

            // If the previous/A node is already a First, reuse it.
            if (prev->kind() == AstExprKind::First) {
                if (!prev->as<AstFirst>().exprs().append(voidNode))
                    return nullptr;
                return prev;
            }

            AstExprVector exprs(lifo);
            if (!exprs.append(prev))
                return nullptr;
            if (!exprs.append(voidNode))
                return nullptr;

            return new(lifo) AstFirst(Move(exprs));
        }

        return voidNode;
    }

    void startFunction(AstDecodeOpIter* iter, const ValTypeVector* locals, ExprType retType)
    {
        iter_ = iter;
        locals_ = locals;
        currentLabelIndex_ = 0;
        retType_ = retType;
    }
    void endFunction()
    {
        iter_ = nullptr;
        locals_ = nullptr;
        retType_ = ExprType::Limit;
        MOZ_ASSERT(blockLabels_.length() == 0);
    }
    uint32_t nextLabelIndex()
    {
        return currentLabelIndex_++;
    }
};

static bool
GenerateName(AstDecodeContext& c, const AstName& prefix, uint32_t index, AstName* name)
{
    if (!c.generateNames) {
        *name = AstName();
        return true;
    }

    AstVector<char16_t> result(c.lifo);
    if (!result.append(u'$'))
        return false;
    if (!result.append(prefix.begin(), prefix.length()))
        return false;

    uint32_t tmp = index;
    do {
        if (!result.append(u'0'))
            return false;
        tmp /= 10;
    } while (tmp);

    if (index) {
        char16_t* p = result.end();
        for (tmp = index; tmp; tmp /= 10)
            *(--p) = u'0' + (tmp % 10);
    }

    size_t length = result.length();
    char16_t* begin = result.extractOrCopyRawBuffer();
    if (!begin)
        return false;

    *name = AstName(begin, length);
    return true;
}

static bool
GenerateRef(AstDecodeContext& c, const AstName& prefix, uint32_t index, AstRef* ref)
{
    MOZ_ASSERT(index != AstNoIndex);

    if (!c.generateNames) {
        *ref = AstRef(index);
        return true;
    }

    AstName name;
    if (!GenerateName(c, prefix, index, &name))
        return false;
    MOZ_ASSERT(!name.empty());

    *ref = AstRef(name);
    ref->setIndex(index);
    return true;
}

static bool
AstDecodeCallArgs(AstDecodeContext& c, const AstSig& sig, AstExprVector* funcArgs)
{
    MOZ_ASSERT(c.iter().inReachableCode());

    const AstValTypeVector& args = sig.args();
    uint32_t numArgs = args.length();

    if (!funcArgs->resize(numArgs))
        return false;

    for (size_t i = 0; i < numArgs; ++i) {
        ValType argType = args[i];
        AstDecodeStackItem item;
        if (!c.iter().readCallArg(argType, numArgs, i, nullptr))
            return false;
        (*funcArgs)[i] = c.exprs()[c.exprs().length() - numArgs + i].expr;
    }
    c.exprs().shrinkBy(numArgs);

    return c.iter().readCallArgsEnd(numArgs);
}

static bool
AstDecodeCallReturn(AstDecodeContext& c, const AstSig& sig)
{
    return c.iter().readCallReturn(sig.ret());
}

static bool
AstDecodeExpr(AstDecodeContext& c);

static bool
AstDecodeDrop(AstDecodeContext& c)
{
    if (!c.iter().readDrop())
        return false;

    AstDecodeStackItem value = c.popCopy();

    AstExpr* tmp = new(c.lifo) AstDrop(*value.expr);
    if (!tmp)
        return false;

    tmp = c.handleVoidExpr(tmp);
    if (!tmp)
        return false;

    if (!c.push(AstDecodeStackItem(tmp)))
        return false;

    return true;
}

static bool
AstDecodeCall(AstDecodeContext& c)
{
    uint32_t funcIndex;
    if (!c.iter().readCall(&funcIndex))
        return false;

    if (!c.iter().inReachableCode())
        return true;

    uint32_t sigIndex;
    AstRef funcRef;
    if (funcIndex < c.module().numFuncImports()) {
        AstImport* import = c.module().imports()[funcIndex];
        sigIndex = import->funcSig().index();
        funcRef = AstRef(import->name());
    } else {
        uint32_t funcDefIndex = funcIndex - c.module().numFuncImports();
        if (funcDefIndex >= c.funcDefSigs().length())
            return c.iter().fail("callee index out of range");

        sigIndex = c.funcDefSigs()[funcDefIndex];

        if (!GenerateRef(c, AstName(u"func"), funcIndex, &funcRef))
            return false;
    }

    const AstSig* sig = c.module().sigs()[sigIndex];

    AstExprVector args(c.lifo);
    if (!AstDecodeCallArgs(c, *sig, &args))
        return false;

    if (!AstDecodeCallReturn(c, *sig))
        return false;

    AstCall* call = new(c.lifo) AstCall(Op::Call, sig->ret(), funcRef, Move(args));
    if (!call)
        return false;

    AstExpr* result = call;
    if (IsVoid(sig->ret()))
        result = c.handleVoidExpr(call);

    if (!c.push(AstDecodeStackItem(result)))
        return false;

    return true;
}

static bool
AstDecodeCallIndirect(AstDecodeContext& c)
{
    uint32_t sigIndex;
    if (!c.iter().readCallIndirect(&sigIndex, nullptr))
        return false;

    if (!c.iter().inReachableCode())
        return true;

    if (sigIndex >= c.module().sigs().length())
        return c.iter().fail("signature index out of range");

    AstDecodeStackItem index = c.popCopy();

    AstRef sigRef;
    if (!GenerateRef(c, AstName(u"type"), sigIndex, &sigRef))
        return false;

    const AstSig* sig = c.module().sigs()[sigIndex];
    AstExprVector args(c.lifo);
    if (!AstDecodeCallArgs(c, *sig, &args))
        return false;

    if (!AstDecodeCallReturn(c, *sig))
        return false;

    AstCallIndirect* call = new(c.lifo) AstCallIndirect(sigRef, sig->ret(),
                                                        Move(args), index.expr);
    if (!call)
        return false;

    AstExpr* result = call;
    if (IsVoid(sig->ret()))
        result = c.handleVoidExpr(call);

    if (!c.push(AstDecodeStackItem(result)))
        return false;

    return true;
}

static bool
AstDecodeGetBlockRef(AstDecodeContext& c, uint32_t depth, AstRef* ref)
{
    if (!c.generateNames || depth >= c.blockLabels().length()) {
        // Also ignoring if it's a function body label.
        *ref = AstRef(depth);
        return true;
    }

    uint32_t index = c.blockLabels().length() - depth - 1;
    if (c.blockLabels()[index].empty()) {
        if (!GenerateName(c, AstName(u"label"), c.nextLabelIndex(), &c.blockLabels()[index]))
            return false;
    }
    *ref = AstRef(c.blockLabels()[index]);
    ref->setIndex(depth);
    return true;
}

static bool
AstDecodeBrTable(AstDecodeContext& c)
{
    uint32_t tableLength;
    ExprType type;
    if (!c.iter().readBrTable(&tableLength, &type, nullptr, nullptr))
        return false;

    AstRefVector table(c.lifo);
    if (!table.resize(tableLength))
        return false;

    uint32_t depth;
    for (size_t i = 0, e = tableLength; i < e; ++i) {
        if (!c.iter().readBrTableEntry(&type, nullptr, &depth))
            return false;
        if (!AstDecodeGetBlockRef(c, depth, &table[i]))
            return false;
    }

    // Read the default label.
    if (!c.iter().readBrTableDefault(&type, nullptr, &depth))
        return false;

    AstDecodeStackItem index = c.popCopy();
    AstDecodeStackItem value;
    if (!IsVoid(type))
        value = c.popCopy();

    AstRef def;
    if (!AstDecodeGetBlockRef(c, depth, &def))
        return false;

    AstBranchTable* branchTable = new(c.lifo) AstBranchTable(*index.expr,
                                                             def, Move(table), value.expr);
    if (!branchTable)
        return false;

    if (!c.push(AstDecodeStackItem(branchTable)))
        return false;

    return true;
}

static bool
AstDecodeBlock(AstDecodeContext& c, Op op)
{
    MOZ_ASSERT(op == Op::Block || op == Op::Loop);

    if (!c.blockLabels().append(AstName()))
        return false;

    if (op == Op::Loop) {
      if (!c.iter().readLoop())
          return false;
    } else {
      if (!c.iter().readBlock())
          return false;
    }

    if (!c.depths().append(c.exprs().length()))
        return false;

    ExprType type;
    while (true) {
        if (!AstDecodeExpr(c))
            return false;

        const AstDecodeStackItem& item = c.top();
        if (!item.expr) { // Op::End was found
            type = item.type;
            c.popBack();
            break;
        }
    }

    AstExprVector exprs(c.lifo);
    for (auto i = c.exprs().begin() + c.depths().back(), e = c.exprs().end();
         i != e; ++i) {
        if (!exprs.append(i->expr))
            return false;
    }
    c.exprs().shrinkTo(c.depths().popCopy());

    AstName name = c.blockLabels().popCopy();
    AstBlock* block = new(c.lifo) AstBlock(op, type, name, Move(exprs));
    if (!block)
        return false;

    AstExpr* result = block;
    if (IsVoid(type))
        result = c.handleVoidExpr(block);

    if (!c.push(AstDecodeStackItem(result)))
        return false;

    return true;
}

static bool
AstDecodeIf(AstDecodeContext& c)
{
    if (!c.iter().readIf(nullptr))
        return false;

    AstDecodeStackItem cond = c.popCopy();

    bool hasElse = false;

    if (!c.depths().append(c.exprs().length()))
        return false;

    if (!c.blockLabels().append(AstName()))
        return false;

    ExprType type;
    while (true) {
        if (!AstDecodeExpr(c))
            return false;

        const AstDecodeStackItem& item = c.top();
        if (!item.expr) { // Op::End was found
            hasElse = item.terminationKind == AstDecodeTerminationKind::Else;
            type = item.type;
            c.popBack();
            break;
        }
    }

    AstExprVector thenExprs(c.lifo);
    for (auto i = c.exprs().begin() + c.depths().back(), e = c.exprs().end();
         i != e; ++i) {
        if (!thenExprs.append(i->expr))
            return false;
    }
    c.exprs().shrinkTo(c.depths().back());

    AstExprVector elseExprs(c.lifo);
    if (hasElse) {
        while (true) {
            if (!AstDecodeExpr(c))
                return false;

            const AstDecodeStackItem& item = c.top();
            if (!item.expr) { // Op::End was found
                c.popBack();
                break;
            }
        }

        for (auto i = c.exprs().begin() + c.depths().back(), e = c.exprs().end();
             i != e; ++i) {
            if (!elseExprs.append(i->expr))
                return false;
        }
        c.exprs().shrinkTo(c.depths().back());
    }

    c.depths().popBack();

    AstName name = c.blockLabels().popCopy();

    AstIf* if_ = new(c.lifo) AstIf(type, cond.expr, name, Move(thenExprs), Move(elseExprs));
    if (!if_)
        return false;

    AstExpr* result = if_;
    if (IsVoid(type))
        result = c.handleVoidExpr(if_);

    if (!c.push(AstDecodeStackItem(result)))
        return false;

    return true;
}

static bool
AstDecodeEnd(AstDecodeContext& c)
{
    LabelKind kind;
    ExprType type;
    if (!c.iter().readEnd(&kind, &type, nullptr))
        return false;

    if (!c.push(AstDecodeStackItem(AstDecodeTerminationKind::End, type)))
        return false;

    return true;
}

static bool
AstDecodeElse(AstDecodeContext& c)
{
    ExprType type;

    if (!c.iter().readElse(&type, nullptr))
        return false;

    if (!c.push(AstDecodeStackItem(AstDecodeTerminationKind::Else, type)))
        return false;

    return true;
}

static bool
AstDecodeNop(AstDecodeContext& c)
{
    if (!c.iter().readNop())
        return false;

    AstExpr* tmp = new(c.lifo) AstNop();
    if (!tmp)
        return false;

    tmp = c.handleVoidExpr(tmp);
    if (!tmp)
        return false;

    if (!c.push(AstDecodeStackItem(tmp)))
        return false;

    return true;
}

static bool
AstDecodeUnary(AstDecodeContext& c, ValType type, Op op)
{
    if (!c.iter().readUnary(type, nullptr))
        return false;

    AstDecodeStackItem operand = c.popCopy();

    AstUnaryOperator* unary = new(c.lifo) AstUnaryOperator(op, operand.expr);
    if (!unary)
        return false;

    if (!c.push(AstDecodeStackItem(unary)))
        return false;

    return true;
}

static bool
AstDecodeBinary(AstDecodeContext& c, ValType type, Op op)
{
    if (!c.iter().readBinary(type, nullptr, nullptr))
        return false;

    AstDecodeStackItem rhs = c.popCopy();
    AstDecodeStackItem lhs = c.popCopy();

    AstBinaryOperator* binary = new(c.lifo) AstBinaryOperator(op, lhs.expr, rhs.expr);
    if (!binary)
        return false;

    if (!c.push(AstDecodeStackItem(binary)))
        return false;

    return true;
}

static bool
AstDecodeSelect(AstDecodeContext& c)
{
    ValType type;
    if (!c.iter().readSelect(&type, nullptr, nullptr, nullptr))
        return false;

    AstDecodeStackItem selectFalse = c.popCopy();
    AstDecodeStackItem selectTrue = c.popCopy();
    AstDecodeStackItem cond = c.popCopy();

    AstTernaryOperator* ternary = new(c.lifo) AstTernaryOperator(Op::Select, cond.expr, selectTrue.expr, selectFalse.expr);
    if (!ternary)
        return false;

    if (!c.push(AstDecodeStackItem(ternary)))
        return false;

    return true;
}

static bool
AstDecodeComparison(AstDecodeContext& c, ValType type, Op op)
{
    if (!c.iter().readComparison(type, nullptr, nullptr))
        return false;

    AstDecodeStackItem rhs = c.popCopy();
    AstDecodeStackItem lhs = c.popCopy();

    AstComparisonOperator* comparison = new(c.lifo) AstComparisonOperator(op, lhs.expr, rhs.expr);
    if (!comparison)
        return false;

    if (!c.push(AstDecodeStackItem(comparison)))
        return false;

    return true;
}

static bool
AstDecodeConversion(AstDecodeContext& c, ValType fromType, ValType toType, Op op)
{
    if (!c.iter().readConversion(fromType, toType, nullptr))
        return false;

    AstDecodeStackItem operand = c.popCopy();

    AstConversionOperator* conversion = new(c.lifo) AstConversionOperator(op, operand.expr);
    if (!conversion)
        return false;

    if (!c.push(AstDecodeStackItem(conversion)))
        return false;

    return true;
}

static AstLoadStoreAddress
AstDecodeLoadStoreAddress(const LinearMemoryAddress<Nothing>& addr, const AstDecodeStackItem& item)
{
    uint32_t flags = FloorLog2(addr.align);
    return AstLoadStoreAddress(item.expr, flags, addr.offset);
}

static bool
AstDecodeLoad(AstDecodeContext& c, ValType type, uint32_t byteSize, Op op)
{
    LinearMemoryAddress<Nothing> addr;
    if (!c.iter().readLoad(type, byteSize, &addr))
        return false;

    AstDecodeStackItem item = c.popCopy();

    AstLoad* load = new(c.lifo) AstLoad(op, AstDecodeLoadStoreAddress(addr, item));
    if (!load)
        return false;

    if (!c.push(AstDecodeStackItem(load)))
        return false;

    return true;
}

static bool
AstDecodeStore(AstDecodeContext& c, ValType type, uint32_t byteSize, Op op)
{
    LinearMemoryAddress<Nothing> addr;
    if (!c.iter().readStore(type, byteSize, &addr, nullptr))
        return false;

    AstDecodeStackItem value = c.popCopy();
    AstDecodeStackItem item = c.popCopy();

    AstStore* store = new(c.lifo) AstStore(op, AstDecodeLoadStoreAddress(addr, item), value.expr);
    if (!store)
        return false;

    AstExpr* wrapped = c.handleVoidExpr(store);
    if (!wrapped)
        return false;

    if (!c.push(AstDecodeStackItem(wrapped)))
        return false;

    return true;
}

static bool
AstDecodeCurrentMemory(AstDecodeContext& c)
{
    if (!c.iter().readCurrentMemory())
        return false;

    AstCurrentMemory* gm = new(c.lifo) AstCurrentMemory();
    if (!gm)
        return false;

    if (!c.push(AstDecodeStackItem(gm)))
        return false;

    return true;
}

static bool
AstDecodeGrowMemory(AstDecodeContext& c)
{
    if (!c.iter().readGrowMemory(nullptr))
        return false;

    AstDecodeStackItem operand = c.popCopy();

    AstGrowMemory* gm = new(c.lifo) AstGrowMemory(operand.expr);
    if (!gm)
        return false;

    if (!c.push(AstDecodeStackItem(gm)))
        return false;

    return true;
}

static bool
AstDecodeBranch(AstDecodeContext& c, Op op)
{
    MOZ_ASSERT(op == Op::Br || op == Op::BrIf);

    uint32_t depth;
    ExprType type;
    AstDecodeStackItem value;
    AstDecodeStackItem cond;
    if (op == Op::Br) {
        if (!c.iter().readBr(&depth, &type, nullptr))
            return false;
        if (!IsVoid(type))
            value = c.popCopy();
    } else {
        if (!c.iter().readBrIf(&depth, &type, nullptr, nullptr))
            return false;
        if (!IsVoid(type))
            value = c.popCopy();
        cond = c.popCopy();
    }

    AstRef depthRef;
    if (!AstDecodeGetBlockRef(c, depth, &depthRef))
        return false;

    if (op == Op::Br || !value.expr)
        type = ExprType::Void;
    AstBranch* branch = new(c.lifo) AstBranch(op, type, cond.expr, depthRef, value.expr);
    if (!branch)
        return false;

    if (!c.push(AstDecodeStackItem(branch)))
        return false;

    return true;
}

static bool
AstDecodeGetLocal(AstDecodeContext& c)
{
    uint32_t getLocalId;
    if (!c.iter().readGetLocal(c.locals(), &getLocalId))
        return false;

    AstRef localRef;
    if (!GenerateRef(c, AstName(u"var"), getLocalId, &localRef))
        return false;

    AstGetLocal* getLocal = new(c.lifo) AstGetLocal(localRef);
    if (!getLocal)
        return false;

    if (!c.push(AstDecodeStackItem(getLocal)))
        return false;

    return true;
}

static bool
AstDecodeSetLocal(AstDecodeContext& c)
{
    uint32_t setLocalId;
    if (!c.iter().readSetLocal(c.locals(), &setLocalId, nullptr))
        return false;

    AstDecodeStackItem setLocalValue = c.popCopy();

    AstRef localRef;
    if (!GenerateRef(c, AstName(u"var"), setLocalId, &localRef))
        return false;

    AstSetLocal* setLocal = new(c.lifo) AstSetLocal(localRef, *setLocalValue.expr);
    if (!setLocal)
        return false;

    AstExpr* expr = c.handleVoidExpr(setLocal);
    if (!expr)
        return false;

    if (!c.push(AstDecodeStackItem(expr)))
        return false;

    return true;
}

static bool
AstDecodeTeeLocal(AstDecodeContext& c)
{
    uint32_t teeLocalId;
    if (!c.iter().readTeeLocal(c.locals(), &teeLocalId, nullptr))
        return false;

    AstDecodeStackItem teeLocalValue = c.popCopy();

    AstRef localRef;
    if (!GenerateRef(c, AstName(u"var"), teeLocalId, &localRef))
        return false;

    AstTeeLocal* teeLocal = new(c.lifo) AstTeeLocal(localRef, *teeLocalValue.expr);
    if (!teeLocal)
        return false;

    if (!c.push(AstDecodeStackItem(teeLocal)))
        return false;

    return true;
}

static bool
AstDecodeGetGlobal(AstDecodeContext& c)
{
    uint32_t globalId;
    if (!c.iter().readGetGlobal(c.globalDescs(), &globalId))
        return false;

    AstRef globalRef;
    if (!GenerateRef(c, AstName(u"global"), globalId, &globalRef))
        return false;

    auto* getGlobal = new(c.lifo) AstGetGlobal(globalRef);
    if (!getGlobal)
        return false;

    if (!c.push(AstDecodeStackItem(getGlobal)))
        return false;

    return true;
}

static bool
AstDecodeSetGlobal(AstDecodeContext& c)
{
    uint32_t globalId;
    if (!c.iter().readSetGlobal(c.globalDescs(), &globalId, nullptr))
        return false;

    AstDecodeStackItem value = c.popCopy();

    AstRef globalRef;
    if (!GenerateRef(c, AstName(u"global"), globalId, &globalRef))
        return false;

    auto* setGlobal = new(c.lifo) AstSetGlobal(globalRef, *value.expr);
    if (!setGlobal)
        return false;

    AstExpr* expr = c.handleVoidExpr(setGlobal);
    if (!expr)
        return false;

    if (!c.push(AstDecodeStackItem(expr)))
        return false;

    return true;
}

static bool
AstDecodeReturn(AstDecodeContext& c)
{
    if (!c.iter().readReturn(nullptr))
        return false;

    AstDecodeStackItem result;
    if (!IsVoid(c.retType()))
       result = c.popCopy();

    AstReturn* ret = new(c.lifo) AstReturn(result.expr);
    if (!ret)
        return false;

    if (!c.push(AstDecodeStackItem(ret)))
        return false;

    return true;
}

static bool
AstDecodeExpr(AstDecodeContext& c)
{
    uint32_t exprOffset = c.iter().currentOffset();
    uint16_t op;
    if (!c.iter().readOp(&op))
        return false;

    AstExpr* tmp;
    switch (op) {
      case uint16_t(Op::Nop):
        if (!AstDecodeNop(c))
            return false;
        break;
      case uint16_t(Op::Drop):
        if (!AstDecodeDrop(c))
            return false;
        break;
      case uint16_t(Op::Call):
        if (!AstDecodeCall(c))
            return false;
        break;
      case uint16_t(Op::CallIndirect):
        if (!AstDecodeCallIndirect(c))
            return false;
        break;
      case uint16_t(Op::I32Const):
        int32_t i32;
        if (!c.iter().readI32Const(&i32))
            return false;
        tmp = new(c.lifo) AstConst(Val((uint32_t)i32));
        if (!tmp || !c.push(AstDecodeStackItem(tmp)))
            return false;
        break;
      case uint16_t(Op::I64Const):
        int64_t i64;
        if (!c.iter().readI64Const(&i64))
            return false;
        tmp = new(c.lifo) AstConst(Val((uint64_t)i64));
        if (!tmp || !c.push(AstDecodeStackItem(tmp)))
            return false;
        break;
      case uint16_t(Op::F32Const): {
        RawF32 f32;
        if (!c.iter().readF32Const(&f32))
            return false;
        tmp = new(c.lifo) AstConst(Val(f32));
        if (!tmp || !c.push(AstDecodeStackItem(tmp)))
            return false;
        break;
      }
      case uint16_t(Op::F64Const): {
        RawF64 f64;
        if (!c.iter().readF64Const(&f64))
            return false;
        tmp = new(c.lifo) AstConst(Val(f64));
        if (!tmp || !c.push(AstDecodeStackItem(tmp)))
            return false;
        break;
      }
      case uint16_t(Op::GetLocal):
        if (!AstDecodeGetLocal(c))
            return false;
        break;
      case uint16_t(Op::SetLocal):
        if (!AstDecodeSetLocal(c))
            return false;
        break;
      case uint16_t(Op::TeeLocal):
        if (!AstDecodeTeeLocal(c))
            return false;
        break;
      case uint16_t(Op::Select):
        if (!AstDecodeSelect(c))
            return false;
        break;
      case uint16_t(Op::Block):
      case uint16_t(Op::Loop):
        if (!AstDecodeBlock(c, Op(op)))
            return false;
        break;
      case uint16_t(Op::If):
        if (!AstDecodeIf(c))
            return false;
        break;
      case uint16_t(Op::Else):
        if (!AstDecodeElse(c))
            return false;
        break;
      case uint16_t(Op::End):
        if (!AstDecodeEnd(c))
            return false;
        break;
      case uint16_t(Op::I32Clz):
      case uint16_t(Op::I32Ctz):
      case uint16_t(Op::I32Popcnt):
        if (!AstDecodeUnary(c, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Clz):
      case uint16_t(Op::I64Ctz):
      case uint16_t(Op::I64Popcnt):
        if (!AstDecodeUnary(c, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32Abs):
      case uint16_t(Op::F32Neg):
      case uint16_t(Op::F32Ceil):
      case uint16_t(Op::F32Floor):
      case uint16_t(Op::F32Sqrt):
      case uint16_t(Op::F32Trunc):
      case uint16_t(Op::F32Nearest):
        if (!AstDecodeUnary(c, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64Abs):
      case uint16_t(Op::F64Neg):
      case uint16_t(Op::F64Ceil):
      case uint16_t(Op::F64Floor):
      case uint16_t(Op::F64Sqrt):
      case uint16_t(Op::F64Trunc):
      case uint16_t(Op::F64Nearest):
        if (!AstDecodeUnary(c, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Add):
      case uint16_t(Op::I32Sub):
      case uint16_t(Op::I32Mul):
      case uint16_t(Op::I32DivS):
      case uint16_t(Op::I32DivU):
      case uint16_t(Op::I32RemS):
      case uint16_t(Op::I32RemU):
      case uint16_t(Op::I32And):
      case uint16_t(Op::I32Or):
      case uint16_t(Op::I32Xor):
      case uint16_t(Op::I32Shl):
      case uint16_t(Op::I32ShrS):
      case uint16_t(Op::I32ShrU):
      case uint16_t(Op::I32Rotl):
      case uint16_t(Op::I32Rotr):
        if (!AstDecodeBinary(c, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Add):
      case uint16_t(Op::I64Sub):
      case uint16_t(Op::I64Mul):
      case uint16_t(Op::I64DivS):
      case uint16_t(Op::I64DivU):
      case uint16_t(Op::I64RemS):
      case uint16_t(Op::I64RemU):
      case uint16_t(Op::I64And):
      case uint16_t(Op::I64Or):
      case uint16_t(Op::I64Xor):
      case uint16_t(Op::I64Shl):
      case uint16_t(Op::I64ShrS):
      case uint16_t(Op::I64ShrU):
      case uint16_t(Op::I64Rotl):
      case uint16_t(Op::I64Rotr):
        if (!AstDecodeBinary(c, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32Add):
      case uint16_t(Op::F32Sub):
      case uint16_t(Op::F32Mul):
      case uint16_t(Op::F32Div):
      case uint16_t(Op::F32Min):
      case uint16_t(Op::F32Max):
      case uint16_t(Op::F32CopySign):
        if (!AstDecodeBinary(c, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64Add):
      case uint16_t(Op::F64Sub):
      case uint16_t(Op::F64Mul):
      case uint16_t(Op::F64Div):
      case uint16_t(Op::F64Min):
      case uint16_t(Op::F64Max):
      case uint16_t(Op::F64CopySign):
        if (!AstDecodeBinary(c, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Eq):
      case uint16_t(Op::I32Ne):
      case uint16_t(Op::I32LtS):
      case uint16_t(Op::I32LtU):
      case uint16_t(Op::I32LeS):
      case uint16_t(Op::I32LeU):
      case uint16_t(Op::I32GtS):
      case uint16_t(Op::I32GtU):
      case uint16_t(Op::I32GeS):
      case uint16_t(Op::I32GeU):
        if (!AstDecodeComparison(c, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Eq):
      case uint16_t(Op::I64Ne):
      case uint16_t(Op::I64LtS):
      case uint16_t(Op::I64LtU):
      case uint16_t(Op::I64LeS):
      case uint16_t(Op::I64LeU):
      case uint16_t(Op::I64GtS):
      case uint16_t(Op::I64GtU):
      case uint16_t(Op::I64GeS):
      case uint16_t(Op::I64GeU):
        if (!AstDecodeComparison(c, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32Eq):
      case uint16_t(Op::F32Ne):
      case uint16_t(Op::F32Lt):
      case uint16_t(Op::F32Le):
      case uint16_t(Op::F32Gt):
      case uint16_t(Op::F32Ge):
        if (!AstDecodeComparison(c, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64Eq):
      case uint16_t(Op::F64Ne):
      case uint16_t(Op::F64Lt):
      case uint16_t(Op::F64Le):
      case uint16_t(Op::F64Gt):
      case uint16_t(Op::F64Ge):
        if (!AstDecodeComparison(c, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Eqz):
        if (!AstDecodeConversion(c, ValType::I32, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Eqz):
      case uint16_t(Op::I32WrapI64):
        if (!AstDecodeConversion(c, ValType::I64, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32TruncSF32):
      case uint16_t(Op::I32TruncUF32):
      case uint16_t(Op::I32ReinterpretF32):
        if (!AstDecodeConversion(c, ValType::F32, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32TruncSF64):
      case uint16_t(Op::I32TruncUF64):
        if (!AstDecodeConversion(c, ValType::F64, ValType::I32, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64ExtendSI32):
      case uint16_t(Op::I64ExtendUI32):
        if (!AstDecodeConversion(c, ValType::I32, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64TruncSF32):
      case uint16_t(Op::I64TruncUF32):
        if (!AstDecodeConversion(c, ValType::F32, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64TruncSF64):
      case uint16_t(Op::I64TruncUF64):
      case uint16_t(Op::I64ReinterpretF64):
        if (!AstDecodeConversion(c, ValType::F64, ValType::I64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32ConvertSI32):
      case uint16_t(Op::F32ConvertUI32):
      case uint16_t(Op::F32ReinterpretI32):
        if (!AstDecodeConversion(c, ValType::I32, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32ConvertSI64):
      case uint16_t(Op::F32ConvertUI64):
        if (!AstDecodeConversion(c, ValType::I64, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32DemoteF64):
        if (!AstDecodeConversion(c, ValType::F64, ValType::F32, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64ConvertSI32):
      case uint16_t(Op::F64ConvertUI32):
        if (!AstDecodeConversion(c, ValType::I32, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64ConvertSI64):
      case uint16_t(Op::F64ConvertUI64):
      case uint16_t(Op::F64ReinterpretI64):
        if (!AstDecodeConversion(c, ValType::I64, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64PromoteF32):
        if (!AstDecodeConversion(c, ValType::F32, ValType::F64, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Load8S):
      case uint16_t(Op::I32Load8U):
        if (!AstDecodeLoad(c, ValType::I32, 1, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Load16S):
      case uint16_t(Op::I32Load16U):
        if (!AstDecodeLoad(c, ValType::I32, 2, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Load):
        if (!AstDecodeLoad(c, ValType::I32, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Load8S):
      case uint16_t(Op::I64Load8U):
        if (!AstDecodeLoad(c, ValType::I64, 1, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Load16S):
      case uint16_t(Op::I64Load16U):
        if (!AstDecodeLoad(c, ValType::I64, 2, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Load32S):
      case uint16_t(Op::I64Load32U):
        if (!AstDecodeLoad(c, ValType::I64, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Load):
        if (!AstDecodeLoad(c, ValType::I64, 8, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32Load):
        if (!AstDecodeLoad(c, ValType::F32, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64Load):
        if (!AstDecodeLoad(c, ValType::F64, 8, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Store8):
        if (!AstDecodeStore(c, ValType::I32, 1, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Store16):
        if (!AstDecodeStore(c, ValType::I32, 2, Op(op)))
            return false;
        break;
      case uint16_t(Op::I32Store):
        if (!AstDecodeStore(c, ValType::I32, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Store8):
        if (!AstDecodeStore(c, ValType::I64, 1, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Store16):
        if (!AstDecodeStore(c, ValType::I64, 2, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Store32):
        if (!AstDecodeStore(c, ValType::I64, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::I64Store):
        if (!AstDecodeStore(c, ValType::I64, 8, Op(op)))
            return false;
        break;
      case uint16_t(Op::F32Store):
        if (!AstDecodeStore(c, ValType::F32, 4, Op(op)))
            return false;
        break;
      case uint16_t(Op::F64Store):
        if (!AstDecodeStore(c, ValType::F64, 8, Op(op)))
            return false;
        break;
      case uint16_t(Op::CurrentMemory):
        if (!AstDecodeCurrentMemory(c))
            return false;
        break;
      case uint16_t(Op::GrowMemory):
        if (!AstDecodeGrowMemory(c))
            return false;
        break;
      case uint16_t(Op::SetGlobal):
        if (!AstDecodeSetGlobal(c))
            return false;
        break;
      case uint16_t(Op::GetGlobal):
        if (!AstDecodeGetGlobal(c))
            return false;
        break;
      case uint16_t(Op::Br):
      case uint16_t(Op::BrIf):
        if (!AstDecodeBranch(c, Op(op)))
            return false;
        break;
      case uint16_t(Op::BrTable):
        if (!AstDecodeBrTable(c))
            return false;
        break;
      case uint16_t(Op::Return):
        if (!AstDecodeReturn(c))
            return false;
        break;
      case uint16_t(Op::Unreachable):
        if (!c.iter().readUnreachable())
            return false;
        tmp = new(c.lifo) AstUnreachable();
        if (!tmp)
            return false;
        if (!c.push(AstDecodeStackItem(tmp)))
            return false;
        break;
      default:
        return c.iter().unrecognizedOpcode(op);
    }

    AstExpr* lastExpr = c.top().expr;
    if (lastExpr)
        lastExpr->setOffset(exprOffset);
    return true;
}

/*****************************************************************************/
// wasm decoding and generation

static bool
AstDecodeTypeSection(AstDecodeContext& c, SigWithIdVector* sigs)
{
    if (!DecodeTypeSection(c.d, sigs))
        return false;

    for (size_t sigIndex = 0; sigIndex < sigs->length(); sigIndex++) {
        const Sig& sig = (*sigs)[sigIndex];

        AstValTypeVector args(c.lifo);
        if (!args.appendAll(sig.args()))
            return false;

        AstSig sigNoName(Move(args), sig.ret());
        AstName sigName;
        if (!GenerateName(c, AstName(u"type"), sigIndex, &sigName))
            return false;

        AstSig* astSig = new(c.lifo) AstSig(sigName, Move(sigNoName));
        if (!astSig || !c.module().append(astSig))
            return false;
    }

    return true;
}

static AstName
ToAstName(AstDecodeContext& c, const UniqueChars& name)
{
    size_t len = strlen(name.get());
    char16_t* buffer = static_cast<char16_t *>(c.lifo.alloc(len * sizeof(char16_t)));
    if (!buffer)
        return AstName();

    for (size_t i = 0; i < len; i++)
        buffer[i] = name.get()[i];

    return AstName(buffer, len);
}

static bool
AstDecodeImportSection(AstDecodeContext& c, const SigWithIdVector& sigs)
{
    Uint32Vector funcSigIndices;
    GlobalDescVector globals;
    TableDescVector tables;
    Maybe<Limits> memory;
    ImportVector imports;
    if (!DecodeImportSection(c.d, sigs, &funcSigIndices, &globals, &tables, &memory, &imports))
        return false;

    size_t lastFunc = 0;
    size_t lastGlobal = 0;
    size_t lastTable = 0;
    size_t lastMemory = 0;

    for (size_t importIndex = 0; importIndex < imports.length(); importIndex++) {
        const Import& import = imports[importIndex];

        AstName moduleName = ToAstName(c, import.module);
        AstName fieldName = ToAstName(c, import.field);

        AstImport* ast = nullptr;
        switch (import.kind) {
          case DefinitionKind::Function: {
            AstName importName;
            if (!GenerateName(c, AstName(u"import"), lastFunc, &importName))
                return false;

            AstRef sigRef;
            if (!GenerateRef(c, AstName(u"type"), funcSigIndices[lastFunc], &sigRef))
                return false;

            ast = new(c.lifo) AstImport(importName, moduleName, fieldName, sigRef);
            lastFunc++;
            break;
          }
          case DefinitionKind::Global: {
            AstName importName;
            if (!GenerateName(c, AstName(u"global"), lastGlobal, &importName))
                return false;

            const GlobalDesc& global = globals[lastGlobal];
            ValType type = global.type();
            bool isMutable = global.isMutable();

            if (!c.addGlobalDesc(type, isMutable, /* import */ true))
                return false;

            ast = new(c.lifo) AstImport(importName, moduleName, fieldName,
                                        AstGlobal(importName, type, isMutable));
            lastGlobal++;
            break;
          }
          case DefinitionKind::Table: {
            AstName importName;
            if (!GenerateName(c, AstName(u"table"), lastTable, &importName))
                return false;

            ast = new(c.lifo) AstImport(importName, moduleName, fieldName, DefinitionKind::Table,
                                        tables[lastTable].limits);
            lastTable++;
            break;
          }
          case DefinitionKind::Memory: {
            AstName importName;
            if (!GenerateName(c, AstName(u"memory"), lastMemory, &importName))
                return false;

            ast = new(c.lifo) AstImport(importName, moduleName, fieldName, DefinitionKind::Memory,
                                        *memory);
            lastMemory++;
            break;
          }
        }

        if (!ast || !c.module().append(ast))
            return false;
    }

    return true;
}

static bool
AstDecodeFunctionSection(AstDecodeContext& c, const SigWithIdVector& sigs)
{
    Uint32Vector funcSigIndexes;
    if (!DecodeFunctionSection(c.d, sigs, c.module().numFuncImports(), &funcSigIndexes))
        return false;

    return c.funcDefSigs().appendAll(funcSigIndexes);
}

static bool
AstDecodeTableSection(AstDecodeContext& c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Table, &sectionStart, &sectionSize, "table"))
        return false;
    if (sectionStart == Decoder::NotStarted)
        return true;

    uint32_t numTables;
    if (!c.d.readVarU32(&numTables))
        return c.d.fail("failed to read number of tables");

    if (numTables != 1)
        return c.d.fail("the number of tables must be exactly one");

    uint32_t typeConstructorValue;
    if (!c.d.readVarU32(&typeConstructorValue))
        return c.d.fail("expected type constructor kind");

    if (typeConstructorValue != uint32_t(TypeCode::AnyFunc))
        return c.d.fail("unknown type constructor kind");

    Limits table;
    if (!DecodeLimits(c.d, &table))
        return false;

    if (table.initial > MaxTableElems)
        return c.d.fail("too many table elements");

    if (c.module().hasTable())
        return c.d.fail("already have a table");

    AstName name;
    if (!GenerateName(c, AstName(u"table"), c.module().tables().length(), &name))
        return false;

    if (!c.module().addTable(name, table))
        return false;

    if (!c.d.finishSection(sectionStart, sectionSize, "table"))
        return false;

    return true;
}

static bool
AstDecodeName(AstDecodeContext& c, AstName* name)
{
    uint32_t length;
    if (!c.d.readVarU32(&length))
        return false;

    const uint8_t* bytes;
    if (!c.d.readBytes(length, &bytes))
        return false;

    char16_t* buffer = static_cast<char16_t *>(c.lifo.alloc(length * sizeof(char16_t)));
    for (size_t i = 0; i < length; i++)
        buffer[i] = bytes[i];

    *name = AstName(buffer, length);
    return true;
}

static bool
AstDecodeMemorySection(AstDecodeContext& c)
{
    bool present;
    Limits memory;
    if (!DecodeMemorySection(c.d, c.module().hasMemory(), &memory, &present))
        return false;

    if (present) {
        AstName name;
        if (!GenerateName(c, AstName(u"memory"), c.module().memories().length(), &name))
            return false;
        if (!c.module().addMemory(name, memory))
            return false;
    }

    return true;
}

static AstExpr*
ToAstExpr(AstDecodeContext& c, const InitExpr& initExpr)
{
    switch (initExpr.kind()) {
      case InitExpr::Kind::Constant: {
        return new(c.lifo) AstConst(Val(initExpr.val()));
      }
      case InitExpr::Kind::GetGlobal: {
        AstRef globalRef;
        if (!GenerateRef(c, AstName(u"global"), initExpr.globalIndex(), &globalRef))
            return nullptr;
        return new(c.lifo) AstGetGlobal(globalRef);
      }
    }
    return nullptr;
}

static bool
AstDecodeInitializerExpression(AstDecodeContext& c, ValType type, AstExpr** init)
{
    InitExpr initExpr;
    if (!DecodeInitializerExpression(c.d, c.globalDescs(), type, &initExpr))
        return false;

    *init = ToAstExpr(c, initExpr);
    return !!*init;
}

static bool
AstDecodeGlobal(AstDecodeContext& c, uint32_t i, AstGlobal* global)
{
    AstName name;
    if (!GenerateName(c, AstName(u"global"), i, &name))
        return false;

    ValType type;
    bool isMutable;
    if (!DecodeGlobalType(c.d, &type, &isMutable))
        return false;

    AstExpr* init;
    if (!AstDecodeInitializerExpression(c, type, &init))
        return false;

    if (!c.addGlobalDesc(type, isMutable, /* import */ false))
        return false;

    *global = AstGlobal(name, type, isMutable, Some(init));
    return true;
}

static bool
AstDecodeGlobalSection(AstDecodeContext& c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Global, &sectionStart, &sectionSize, "global"))
        return false;
    if (sectionStart == Decoder::NotStarted)
        return true;

    uint32_t numGlobals;
    if (!c.d.readVarU32(&numGlobals))
        return c.d.fail("expected number of globals");

    uint32_t numImported = c.globalDescs().length();

    for (uint32_t i = 0; i < numGlobals; i++) {
        auto* global = new(c.lifo) AstGlobal;
        if (!AstDecodeGlobal(c, i + numImported, global))
            return false;
        if (!c.module().append(global))
            return false;
    }

    if (!c.d.finishSection(sectionStart, sectionSize, "global"))
        return false;

    return true;
}

static bool
AstDecodeExport(AstDecodeContext& c, AstExport** export_)
{
    AstName fieldName;
    if (!AstDecodeName(c, &fieldName))
        return c.d.fail("expected export name");

    uint32_t kindValue;
    if (!c.d.readVarU32(&kindValue))
        return c.d.fail("expected export kind");

    uint32_t index;
    if (!c.d.readVarU32(&index))
        return c.d.fail("expected export internal index");

    *export_ = new(c.lifo) AstExport(fieldName, DefinitionKind(kindValue), AstRef(index));
    if (!*export_)
        return false;

    return true;
}

static bool
AstDecodeExportSection(AstDecodeContext& c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Export, &sectionStart, &sectionSize, "export"))
        return false;
    if (sectionStart == Decoder::NotStarted)
        return true;

    uint32_t numExports;
    if (!c.d.readVarU32(&numExports))
        return c.d.fail("failed to read number of exports");

    if (numExports > MaxExports)
        return c.d.fail("too many exports");

    for (uint32_t i = 0; i < numExports; i++) {
        AstExport* export_ = nullptr;
        if (!AstDecodeExport(c, &export_))
            return false;
        if (!c.module().append(export_))
            return false;
    }

    if (!c.d.finishSection(sectionStart, sectionSize, "export"))
        return false;

    return true;
}

static bool
AstDecodeFunctionBody(AstDecodeContext &c, uint32_t funcDefIndex, AstFunc** func)
{
    uint32_t offset = c.d.currentOffset();
    uint32_t bodySize;
    if (!c.d.readVarU32(&bodySize))
        return c.d.fail("expected number of function body bytes");

    if (c.d.bytesRemain() < bodySize)
        return c.d.fail("function body length too big");

    const uint8_t* bodyBegin = c.d.currentPosition();
    const uint8_t* bodyEnd = bodyBegin + bodySize;

    AstDecodeOpIter iter(c.d);

    uint32_t sigIndex = c.funcDefSigs()[funcDefIndex];
    const AstSig* sig = c.module().sigs()[sigIndex];

    AstValTypeVector vars(c.lifo);
    AstNameVector localsNames(c.lifo);
    AstExprVector body(c.lifo);

    ValTypeVector locals;
    if (!locals.appendAll(sig->args()))
        return false;

    if (!DecodeLocalEntries(c.d, ModuleKind::Wasm, &locals))
        return c.d.fail("failed decoding local entries");

    c.startFunction(&iter, &locals, sig->ret());

    AstName funcName;
    if (!GenerateName(c, AstName(u"func"), c.module().numFuncImports() + funcDefIndex, &funcName))
        return false;

    uint32_t numParams = sig->args().length();
    uint32_t numLocals = locals.length();
    for (uint32_t i = numParams; i < numLocals; i++) {
        if (!vars.append(locals[i]))
            return false;
    }
    for (uint32_t i = 0; i < numLocals; i++) {
        AstName varName;
        if (!GenerateName(c, AstName(u"var"), i, &varName))
            return false;
        if (!localsNames.append(varName))
            return false;
    }

    if (!c.iter().readFunctionStart(sig->ret()))
        return false;

    if (!c.depths().append(c.exprs().length()))
        return false;

    while (c.d.currentPosition() < bodyEnd) {
        if (!AstDecodeExpr(c))
            return false;

        const AstDecodeStackItem& item = c.top();
        if (!item.expr) { // Op::End was found
            c.popBack();
            break;
        }
    }

    for (auto i = c.exprs().begin() + c.depths().back(), e = c.exprs().end();
         i != e; ++i) {
        if (!body.append(i->expr))
            return false;
    }
    c.exprs().shrinkTo(c.depths().popCopy());

    if (!c.iter().readFunctionEnd())
        return false;

    c.endFunction();

    if (c.d.currentPosition() != bodyEnd)
        return c.d.fail("function body length mismatch");

    AstRef sigRef;
    if (!GenerateRef(c, AstName(u"type"), sigIndex, &sigRef))
        return false;

    *func = new(c.lifo) AstFunc(funcName, sigRef, Move(vars), Move(localsNames), Move(body));
    if (!*func)
        return false;
    (*func)->setOffset(offset);

    return true;
}

static bool
AstDecodeCodeSection(AstDecodeContext &c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Code, &sectionStart, &sectionSize, "code"))
        return false;

    if (sectionStart == Decoder::NotStarted) {
        if (c.funcDefSigs().length() != 0)
            return c.d.fail("expected function bodies");

        return false;
    }

    uint32_t numFuncBodies;
    if (!c.d.readVarU32(&numFuncBodies))
        return c.d.fail("expected function body count");

    if (numFuncBodies != c.funcDefSigs().length())
        return c.d.fail("function body count does not match function signature count");

    for (uint32_t funcDefIndex = 0; funcDefIndex < numFuncBodies; funcDefIndex++) {
        AstFunc* func;
        if (!AstDecodeFunctionBody(c, funcDefIndex, &func))
            return false;
        if (!c.module().append(func))
            return false;
    }

    if (!c.d.finishSection(sectionStart, sectionSize, "code"))
        return false;

    return true;
}

// Number of bytes to display in a single fragment of a data section (per line).
static const size_t WRAP_DATA_BYTES = 30;

static bool
AstDecodeDataSection(AstDecodeContext &c)
{
    DataSegmentVector segments;
    bool hasMemory = c.module().hasMemory();

    MOZ_ASSERT(c.module().memories().length() <= 1, "at most one memory in MVP");
    uint32_t memByteLength = hasMemory ? c.module().memories()[0].limits.initial : 0;

    if (!DecodeDataSection(c.d, hasMemory, memByteLength, c.globalDescs(), &segments))
        return false;

    for (DataSegment& s : segments) {
        const uint8_t* src = c.d.begin() + s.bytecodeOffset;
        char16_t* buffer = static_cast<char16_t*>(c.lifo.alloc(s.length * sizeof(char16_t)));
        for (size_t i = 0; i < s.length; i++)
            buffer[i] = src[i];

        AstExpr* offset = ToAstExpr(c, s.offset);
        if (!offset)
            return false;

        AstNameVector fragments(c.lifo);
        for (size_t start = 0; start < s.length; start += WRAP_DATA_BYTES) {
            AstName name(buffer + start, Min(WRAP_DATA_BYTES, s.length - start));
            if (!fragments.append(name))
                return false;
        }

        AstDataSegment* segment = new(c.lifo) AstDataSegment(offset, Move(fragments));
        if (!segment || !c.module().append(segment))
            return false;
    }

    return true;
}

static bool
AstDecodeElemSection(AstDecodeContext &c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Elem, &sectionStart, &sectionSize, "elem"))
        return false;
    if (sectionStart == Decoder::NotStarted)
        return true;

    uint32_t numElems;
    if (!c.d.readVarU32(&numElems))
        return c.d.fail("failed to read number of table elements");

    for (uint32_t i = 0; i < numElems; i++) {
        uint32_t tableIndex;
        if (!c.d.readVarU32(&tableIndex))
            return c.d.fail("expected table index for element");

        if (tableIndex != 0)
            return c.d.fail("non-zero table index for element");

        AstExpr* offset;
        if (!AstDecodeInitializerExpression(c, ValType::I32, &offset))
            return false;

        uint32_t count;
        if (!c.d.readVarU32(&count))
            return c.d.fail("expected element count");

        AstRefVector elems(c.lifo);
        if (!elems.resize(count))
            return false;

        for (uint32_t i = 0; i < count; i++) {
            uint32_t index;
            if (!c.d.readVarU32(&index))
                return c.d.fail("expected element index");

            elems[i] = AstRef(index);
        }

        AstElemSegment* segment = new(c.lifo) AstElemSegment(offset, Move(elems));
        if (!segment || !c.module().append(segment))
            return false;
    }

    if (!c.d.finishSection(sectionStart, sectionSize, "elem"))
        return false;

    return true;
}

static bool
AstDecodeStartSection(AstDecodeContext &c)
{
    uint32_t sectionStart, sectionSize;
    if (!c.d.startSection(SectionId::Start, &sectionStart, &sectionSize, "start"))
        return false;
    if (sectionStart == Decoder::NotStarted)
        return true;

    uint32_t funcIndex;
    if (!c.d.readVarU32(&funcIndex))
        return c.d.fail("failed to read start func index");

    AstRef funcRef;
    if (!GenerateRef(c, AstName(u"func"), funcIndex, &funcRef))
        return false;

    c.module().setStartFunc(AstStartFunc(funcRef));

    if (!c.d.finishSection(sectionStart, sectionSize, "start"))
        return false;

    return true;
}

bool
wasm::BinaryToAst(JSContext* cx, const uint8_t* bytes, uint32_t length,
                  LifoAlloc& lifo, AstModule** module)
{
    AstModule* result = new(lifo) AstModule(lifo);
    if (!result->init())
        return false;

    UniqueChars error;
    Decoder d(bytes, bytes + length, &error);
    AstDecodeContext c(cx, lifo, d, *result, true);

    SigWithIdVector sigs;
    if (!DecodePreamble(d) ||
        !AstDecodeTypeSection(c, &sigs) ||
        !AstDecodeImportSection(c, sigs) ||
        !AstDecodeFunctionSection(c, sigs) ||
        !AstDecodeTableSection(c) ||
        !AstDecodeMemorySection(c) ||
        !AstDecodeGlobalSection(c) ||
        !AstDecodeExportSection(c) ||
        !AstDecodeStartSection(c) ||
        !AstDecodeElemSection(c) ||
        !AstDecodeCodeSection(c) ||
        !AstDecodeDataSection(c) ||
        !DecodeUnknownSections(c.d))
    {
        if (error) {
            JS_ReportErrorNumberASCII(c.cx, GetErrorMessage, nullptr, JSMSG_WASM_COMPILE_ERROR,
                                      error.get());
            return false;
        }
        ReportOutOfMemory(c.cx);
        return false;
    }

    MOZ_ASSERT(!error, "unreported error in decoding");

    *module = result;
    return true;
}
