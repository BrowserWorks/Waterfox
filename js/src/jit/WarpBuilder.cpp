/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/WarpBuilder.h"

#include "mozilla/DebugOnly.h"

#include "jit/CacheIR.h"
#include "jit/MIR.h"
#include "jit/MIRGenerator.h"
#include "jit/MIRGraph.h"
#include "jit/WarpCacheIRTranspiler.h"
#include "jit/WarpSnapshot.h"
#include "vm/Opcodes.h"

#include "jit/JitScript-inl.h"
#include "vm/BytecodeIterator-inl.h"
#include "vm/BytecodeLocation-inl.h"

using namespace js;
using namespace js::jit;

WarpBuilder::WarpBuilder(WarpSnapshot& snapshot, MIRGenerator& mirGen)
    : WarpBuilderShared(mirGen, nullptr),
      snapshot_(snapshot),
      graph_(mirGen.graph()),
      info_(mirGen.outerInfo()),
      script_(snapshot.script()->script()),
      loopStack_(mirGen.alloc()),
      iterators_(mirGen.alloc()) {
  opSnapshotIter_ = snapshot.script()->opSnapshots().getFirst();
}

BytecodeSite* WarpBuilder::newBytecodeSite(BytecodeLocation loc) {
  jsbytecode* pc = loc.toRawBytecode();
  MOZ_ASSERT(info().inlineScriptTree()->script()->containsPC(pc));
  return new (alloc()) BytecodeSite(info().inlineScriptTree(), pc);
}

const WarpOpSnapshot* WarpBuilder::getOpSnapshotImpl(BytecodeLocation loc) {
  uint32_t offset = loc.bytecodeToOffset(script_);

  // Skip snapshots until we get to a snapshot with offset >= offset. This is
  // a loop because WarpBuilder can skip unreachable bytecode ops.
  while (opSnapshotIter_ && opSnapshotIter_->offset() < offset) {
    opSnapshotIter_ = opSnapshotIter_->getNext();
  }

  if (!opSnapshotIter_ || opSnapshotIter_->offset() != offset) {
    return nullptr;
  }

  return opSnapshotIter_;
}

void WarpBuilder::initBlock(MBasicBlock* block) {
  graph().addBlock(block);

  // TODO: set block hit count (for branch pruning pass)
  block->setLoopDepth(loopDepth_);

  current = block;
}

bool WarpBuilder::startNewBlock(MBasicBlock* predecessor, BytecodeLocation loc,
                                size_t numToPop) {
  MBasicBlock* block =
      MBasicBlock::NewPopN(graph(), info(), predecessor, newBytecodeSite(loc),
                           MBasicBlock::NORMAL, numToPop);
  if (!block) {
    return false;
  }

  initBlock(block);
  return true;
}

bool WarpBuilder::startNewEntryBlock(size_t stackDepth, BytecodeLocation loc) {
  MBasicBlock* block =
      MBasicBlock::New(graph(), stackDepth, info(), /* maybePred = */ nullptr,
                       newBytecodeSite(loc), MBasicBlock::NORMAL);
  if (!block) {
    return false;
  }

  initBlock(block);
  return true;
}

bool WarpBuilder::startNewLoopHeaderBlock(BytecodeLocation loopHead) {
  MBasicBlock* header = MBasicBlock::NewPendingLoopHeader(
      graph(), info(), current, newBytecodeSite(loopHead));
  if (!header) {
    return false;
  }

  initBlock(header);
  return loopStack_.emplaceBack(header);
}

bool WarpBuilder::startNewOsrPreHeaderBlock(BytecodeLocation loopHead) {
  MOZ_ASSERT(loopHead.is(JSOp::LoopHead));
  MOZ_ASSERT(loopHead.toRawBytecode() == info().osrPc());

  // Create two blocks:
  // * The OSR entry block. This is always the graph's second block and has no
  //   predecessors. This is the entry point for OSR from the Baseline JIT.
  // * The OSR preheader block. This has two predecessors: the OSR entry block
  //   and the current block.

  MBasicBlock* pred = current;

  // Create the OSR entry block.
  if (!startNewEntryBlock(pred->stackDepth(), loopHead)) {
    return false;
  }

  MBasicBlock* osrBlock = current;
  graph().setOsrBlock(osrBlock);
  graph().moveBlockAfter(*graph().begin(), osrBlock);

  MOsrEntry* entry = MOsrEntry::New(alloc());
  osrBlock->add(entry);

  // Initialize environment chain.
  {
    uint32_t slot = info().environmentChainSlot();
    MInstruction* envv;
    if (usesEnvironmentChain()) {
      envv = MOsrEnvironmentChain::New(alloc(), entry);
    } else {
      // Use an undefined value if the script does not need its environment
      // chain, to match the main entry point.
      envv = MConstant::New(alloc(), UndefinedValue());
    }
    osrBlock->add(envv);
    osrBlock->initSlot(slot, envv);
  }

  // Initialize return value.
  {
    MInstruction* returnValue;
    if (!script_->noScriptRval()) {
      returnValue = MOsrReturnValue::New(alloc(), entry);
    } else {
      returnValue = MConstant::New(alloc(), UndefinedValue());
    }
    osrBlock->add(returnValue);
    osrBlock->initSlot(info().returnValueSlot(), returnValue);
  }

  // Initialize arguments object.
  bool needsArgsObj = info().needsArgsObj();
  MInstruction* argsObj = nullptr;
  if (info().hasArguments()) {
    if (needsArgsObj) {
      argsObj = MOsrArgumentsObject::New(alloc(), entry);
    } else {
      argsObj = MConstant::New(alloc(), UndefinedValue());
    }
    osrBlock->add(argsObj);
    osrBlock->initSlot(info().argsObjSlot(), argsObj);
  }

  if (info().funMaybeLazy()) {
    // Initialize |this| parameter.
    MParameter* thisv =
        MParameter::New(alloc(), MParameter::THIS_SLOT, nullptr);
    osrBlock->add(thisv);
    osrBlock->initSlot(info().thisSlot(), thisv);

    // Initialize arguments. There are three cases:
    //
    // 1) There's no ArgumentsObject or it doesn't alias formals. In this case
    //    we can just use the frame's argument slot.
    // 2) The ArgumentsObject aliases formals and the argument is stored in the
    //    CallObject. Use |undefined| because we can't load from the arguments
    //    object and code will use the CallObject anyway.
    // 3) The ArgumentsObject aliases formals and the argument isn't stored in
    //    the CallObject. We have to load it from the ArgumentsObject.
    for (uint32_t i = 0; i < info().nargs(); i++) {
      uint32_t slot = info().argSlotUnchecked(i);
      MInstruction* osrv;
      if (!needsArgsObj || !info().argsObjAliasesFormals()) {
        osrv = MParameter::New(alloc().fallible(), i, nullptr);
      } else if (script_->formalIsAliased(i)) {
        osrv = MConstant::New(alloc().fallible(), UndefinedValue());
      } else {
        osrv = MGetArgumentsObjectArg::New(alloc().fallible(), argsObj, i);
      }
      if (!osrv) {
        return false;
      }
      current->add(osrv);
      current->initSlot(slot, osrv);
    }
  }

  // Initialize locals.
  uint32_t nlocals = info().nlocals();
  for (uint32_t i = 0; i < nlocals; i++) {
    uint32_t slot = info().localSlot(i);
    ptrdiff_t offset = BaselineFrame::reverseOffsetOfLocal(i);
    MOsrValue* osrv = MOsrValue::New(alloc().fallible(), entry, offset);
    if (!osrv) {
      return false;
    }
    current->add(osrv);
    current->initSlot(slot, osrv);
  }

  // Initialize expression stack slots.
  uint32_t numStackSlots = current->stackDepth() - info().firstStackSlot();
  for (uint32_t i = 0; i < numStackSlots; i++) {
    uint32_t slot = info().stackSlot(i);
    ptrdiff_t offset = BaselineFrame::reverseOffsetOfLocal(nlocals + i);
    MOsrValue* osrv = MOsrValue::New(alloc().fallible(), entry, offset);
    if (!osrv) {
      return false;
    }
    current->add(osrv);
    current->initSlot(slot, osrv);
  }

  MStart* start = MStart::New(alloc());
  current->add(start);

  // Note: phi specialization can add type guard instructions to the OSR entry
  // block if needed. See ShouldSpecializeOsrPhis.

  // Create the preheader block, with the predecessor block and OSR block as
  // predecessors.
  if (!startNewBlock(pred, loopHead)) {
    return false;
  }

  pred->end(MGoto::New(alloc(), current));
  osrBlock->end(MGoto::New(alloc(), current));

  if (!current->addPredecessor(alloc(), osrBlock)) {
    return false;
  }

  // Give the preheader block the same hit count as the code before the loop.
  if (pred->getHitState() == MBasicBlock::HitState::Count) {
    current->setHitCount(pred->getHitCount());
  }

  return true;
}

bool WarpBuilder::addPendingEdge(const PendingEdge& edge,
                                 BytecodeLocation target) {
  jsbytecode* targetPC = target.toRawBytecode();
  PendingEdgesMap::AddPtr p = pendingEdges_.lookupForAdd(targetPC);
  if (p) {
    return p->value().append(edge);
  }

  PendingEdges edges;
  static_assert(PendingEdges::InlineLength >= 1,
                "Appending one element should be infallible");
  MOZ_ALWAYS_TRUE(edges.append(edge));

  return pendingEdges_.add(p, targetPC, std::move(edges));
}

bool WarpBuilder::build() {
  if (!buildPrologue()) {
    return false;
  }

  if (!buildBody()) {
    return false;
  }

  if (!buildEpilogue()) {
    return false;
  }

  if (!MPhi::markIteratorPhis(iterators_)) {
    return false;
  }

  MOZ_ASSERT(loopStack_.empty());
  MOZ_ASSERT(loopDepth_ == 0);

  return true;
}

MInstruction* WarpBuilder::buildNamedLambdaEnv(
    MDefinition* callee, MDefinition* env,
    LexicalEnvironmentObject* templateObj) {
  MOZ_ASSERT(!templateObj->hasDynamicSlots());

  MInstruction* namedLambda = MNewNamedLambdaObject::New(alloc(), templateObj);
  current->add(namedLambda);

  // Initialize the object's reserved slots. No post barrier is needed here:
  // the object will be allocated in the nursery if possible, and if the
  // tenured heap is used instead, a minor collection will have been performed
  // that moved env/callee to the tenured heap.
  size_t enclosingSlot = NamedLambdaObject::enclosingEnvironmentSlot();
  size_t lambdaSlot = NamedLambdaObject::lambdaSlot();
  current->add(MStoreFixedSlot::New(alloc(), namedLambda, enclosingSlot, env));
  current->add(MStoreFixedSlot::New(alloc(), namedLambda, lambdaSlot, callee));

  return namedLambda;
}

MInstruction* WarpBuilder::buildCallObject(MDefinition* callee,
                                           MDefinition* env,
                                           CallObject* templateObj) {
  MConstant* templateCst = constant(ObjectValue(*templateObj));

  MNewCallObject* callObj = MNewCallObject::New(alloc(), templateCst);
  current->add(callObj);

  // Initialize the object's reserved slots. No post barrier is needed here,
  // for the same reason as in buildNamedLambdaEnv.
  size_t enclosingSlot = CallObject::enclosingEnvironmentSlot();
  size_t calleeSlot = CallObject::calleeSlot();
  current->add(MStoreFixedSlot::New(alloc(), callObj, enclosingSlot, env));
  current->add(MStoreFixedSlot::New(alloc(), callObj, calleeSlot, callee));

  // Copy closed-over argument slots if there aren't parameter expressions.
  MSlots* slots = nullptr;
  for (PositionalFormalParameterIter fi(script_); fi; fi++) {
    if (!fi.closedOver()) {
      continue;
    }

    if (!alloc().ensureBallast()) {
      return nullptr;
    }

    uint32_t slot = fi.location().slot();
    uint32_t formal = fi.argumentSlot();
    uint32_t numFixedSlots = templateObj->numFixedSlots();
    MDefinition* param;
    if (script_->functionHasParameterExprs()) {
      param = constant(MagicValue(JS_UNINITIALIZED_LEXICAL));
    } else {
      param = current->getSlot(info().argSlotUnchecked(formal));
    }

    if (slot >= numFixedSlots) {
      if (!slots) {
        slots = MSlots::New(alloc(), callObj);
        current->add(slots);
      }
      uint32_t dynamicSlot = slot - numFixedSlots;
      current->add(MStoreDynamicSlot::New(alloc(), slots, dynamicSlot, param));
    } else {
      current->add(MStoreFixedSlot::New(alloc(), callObj, slot, param));
    }
  }

  return callObj;
}

bool WarpBuilder::buildEnvironmentChain() {
  const WarpEnvironment& env = snapshot_.script()->environment();

  if (env.is<NoEnvironment>()) {
    return true;
  }

  MInstruction* envDef = env.match(
      [](const NoEnvironment&) -> MInstruction* {
        MOZ_CRASH("Already handled");
      },
      [this](JSObject* obj) -> MInstruction* {
        return constant(ObjectValue(*obj));
      },
      [this](const FunctionEnvironment& env) -> MInstruction* {
        MDefinition* callee = getCallee();
        MInstruction* envDef = MFunctionEnvironment::New(alloc(), callee);
        current->add(envDef);
        if (LexicalEnvironmentObject* obj = env.namedLambdaTemplate) {
          envDef = buildNamedLambdaEnv(callee, envDef, obj);
        }
        if (CallObject* obj = env.callObjectTemplate) {
          envDef = buildCallObject(callee, envDef, obj);
          if (!envDef) {
            return nullptr;
          }
        }
        return envDef;
      });
  if (!envDef) {
    return false;
  }

  // Update the environment slot from UndefinedValue only after the initial
  // environment is created so that bailout doesn't see a partial environment.
  // See: |InitFromBailout|
  current->setEnvironmentChain(envDef);
  return true;
}

bool WarpBuilder::buildPrologue() {
  BytecodeLocation startLoc(script_, script_->code());
  if (!startNewEntryBlock(info().firstStackSlot(), startLoc)) {
    return false;
  }

  if (info().funMaybeLazy()) {
    // Initialize |this|.
    MParameter* param =
        MParameter::New(alloc(), MParameter::THIS_SLOT, nullptr);
    current->add(param);
    current->initSlot(info().thisSlot(), param);

    // Initialize arguments.
    for (uint32_t i = 0; i < info().nargs(); i++) {
      MParameter* param = MParameter::New(alloc().fallible(), i, nullptr);
      if (!param) {
        return false;
      }
      current->add(param);
      current->initSlot(info().argSlotUnchecked(i), param);
    }
  }

  MConstant* undef = constant(UndefinedValue());

  // Initialize local slots.
  for (uint32_t i = 0; i < info().nlocals(); i++) {
    current->initSlot(info().localSlot(i), undef);
  }

  // Initialize the environment chain, return value, and arguments object slots.
  current->initSlot(info().environmentChainSlot(), undef);
  current->initSlot(info().returnValueSlot(), undef);
  if (info().hasArguments()) {
    current->initSlot(info().argsObjSlot(), undef);
  }

  current->add(MStart::New(alloc()));

  // Guard against over-recursion.
  MCheckOverRecursed* check = MCheckOverRecursed::New(alloc());
  current->add(check);

  if (!buildEnvironmentChain()) {
    return false;
  }

  return true;
}

#ifdef DEBUG
// In debug builds, after compiling a bytecode op, this class is used to check
// that all values popped by this opcode either:
//
//   (1) Have the ImplicitlyUsed flag set on them.
//   (2) Have more uses than before compiling this op (the value is
//       used as operand of a new MIR instruction).
//
// This is used to catch problems where WarpBuilder pops a value without
// adding any SSA uses and doesn't call setImplicitlyUsedUnchecked on it.
class MOZ_RAII WarpPoppedValueUseChecker {
  Vector<MDefinition*, 4, SystemAllocPolicy> popped_;
  Vector<size_t, 4, SystemAllocPolicy> poppedUses_;
  MBasicBlock* current_;
  BytecodeLocation loc_;

 public:
  WarpPoppedValueUseChecker(MBasicBlock* current, BytecodeLocation loc)
      : current_(current), loc_(loc) {}

  MOZ_MUST_USE bool init() {
    // Don't require SSA uses for values popped by these ops.
    switch (loc_.getOp()) {
      case JSOp::Pop:
      case JSOp::PopN:
      case JSOp::DupAt:
      case JSOp::Dup:
      case JSOp::Dup2:
      case JSOp::Pick:
      case JSOp::Unpick:
      case JSOp::Swap:
      case JSOp::SetArg:
      case JSOp::SetLocal:
      case JSOp::InitLexical:
      case JSOp::SetRval:
      case JSOp::Void:
        // Basic stack/local/argument management opcodes.
        return true;

      case JSOp::Case:
      case JSOp::Default:
        // These ops have to pop the switch value when branching but don't
        // actually use it.
        return true;

      default:
        break;
    }

    unsigned nuses = loc_.useCount();

    for (unsigned i = 0; i < nuses; i++) {
      MDefinition* def = current_->peek(-int32_t(i + 1));
      if (!popped_.append(def) || !poppedUses_.append(def->defUseCount())) {
        return false;
      }
    }

    return true;
  }

  void checkAfterOp() {
    for (size_t i = 0; i < popped_.length(); i++) {
      // First value popped by JSOp::EndIter is not used at all, it's similar
      // to JSOp::Pop above.
      if (loc_.is(JSOp::EndIter) && i == 0) {
        continue;
      }
      MOZ_ASSERT(popped_[i]->isImplicitlyUsed() ||
                 popped_[i]->defUseCount() > poppedUses_[i]);
    }
  }
};
#endif

bool WarpBuilder::buildBody() {
  for (BytecodeLocation loc : AllBytecodesIterable(script_)) {
    if (mirGen().shouldCancel("WarpBuilder (opcode loop)")) {
      return false;
    }

    // Skip unreachable ops (for example code after a 'return' or 'throw') until
    // we get to the next jump target.
    if (hasTerminatedBlock()) {
      // Finish any "broken" loops with an unreachable backedge. For example:
      //
      //   do {
      //     ...
      //     return;
      //     ...
      //   } while (x);
      //
      // This loop never actually loops.
      if (loc.isBackedge() && !loopStack_.empty()) {
        BytecodeLocation loopHead(script_, loopStack_.back().header()->pc());
        if (loc.isBackedgeForLoophead(loopHead)) {
          MOZ_ASSERT(loopDepth_ > 0);
          loopDepth_--;
          loopStack_.popBack();
        }
      }
      if (!loc.isJumpTarget()) {
        continue;
      }
    }

    if (!alloc().ensureBallast()) {
      return false;
    }

#ifdef DEBUG
    WarpPoppedValueUseChecker useChecker(current, loc);
    if (!useChecker.init()) {
      return false;
    }
#endif

    JSOp op = loc.getOp();

#define BUILD_OP(OP, ...)                       \
  case JSOp::OP:                                \
    if (MOZ_UNLIKELY(!this->build_##OP(loc))) { \
      return false;                             \
    }                                           \
    break;
    switch (op) { FOR_EACH_OPCODE(BUILD_OP) }
#undef BUILD_OP

#ifdef DEBUG
    useChecker.checkAfterOp();
#endif
  }

  return true;
}

#define DEF_OP(OP)                                 \
  bool WarpBuilder::build_##OP(BytecodeLocation) { \
    MOZ_CRASH("Unsupported op");                   \
  }
WARP_UNSUPPORTED_OPCODE_LIST(DEF_OP)
#undef DEF_OP

bool WarpBuilder::buildEpilogue() { return true; }

bool WarpBuilder::build_Nop(BytecodeLocation) { return true; }

bool WarpBuilder::build_NopDestructuring(BytecodeLocation) { return true; }

bool WarpBuilder::build_TryDestructuring(BytecodeLocation) {
  // Set the hasTryBlock flag to turn off optimizations that eliminate dead
  // resume points operands because the exception handler code for
  // TryNoteKind::Destructuring is effectively a (specialized) catch-block.
  graph().setHasTryBlock();
  return true;
}

bool WarpBuilder::build_Lineno(BytecodeLocation) { return true; }

bool WarpBuilder::build_DebugLeaveLexicalEnv(BytecodeLocation) { return true; }

bool WarpBuilder::build_Undefined(BytecodeLocation) {
  pushConstant(UndefinedValue());
  return true;
}

bool WarpBuilder::build_Void(BytecodeLocation) {
  current->pop();
  pushConstant(UndefinedValue());
  return true;
}

bool WarpBuilder::build_Null(BytecodeLocation) {
  pushConstant(NullValue());
  return true;
}

bool WarpBuilder::build_Hole(BytecodeLocation) {
  pushConstant(MagicValue(JS_ELEMENTS_HOLE));
  return true;
}

bool WarpBuilder::build_Uninitialized(BytecodeLocation) {
  pushConstant(MagicValue(JS_UNINITIALIZED_LEXICAL));
  return true;
}

bool WarpBuilder::build_IsConstructing(BytecodeLocation) {
  pushConstant(MagicValue(JS_IS_CONSTRUCTING));
  return true;
}

bool WarpBuilder::build_False(BytecodeLocation) {
  pushConstant(BooleanValue(false));
  return true;
}

bool WarpBuilder::build_True(BytecodeLocation) {
  pushConstant(BooleanValue(true));
  return true;
}

bool WarpBuilder::build_Pop(BytecodeLocation) {
  current->pop();
  // TODO: IonBuilder inserts a resume point in loops, re-evaluate this.
  return true;
}

bool WarpBuilder::build_PopN(BytecodeLocation loc) {
  for (uint32_t i = 0, n = loc.getPopCount(); i < n; i++) {
    current->pop();
  }
  return true;
}

bool WarpBuilder::build_Dup(BytecodeLocation) {
  current->pushSlot(current->stackDepth() - 1);
  return true;
}

bool WarpBuilder::build_Dup2(BytecodeLocation) {
  uint32_t lhsSlot = current->stackDepth() - 2;
  uint32_t rhsSlot = current->stackDepth() - 1;
  current->pushSlot(lhsSlot);
  current->pushSlot(rhsSlot);
  return true;
}

bool WarpBuilder::build_DupAt(BytecodeLocation loc) {
  current->pushSlot(current->stackDepth() - 1 - loc.getDupAtIndex());
  return true;
}

bool WarpBuilder::build_Swap(BytecodeLocation) {
  current->swapAt(-1);
  return true;
}

bool WarpBuilder::build_Pick(BytecodeLocation loc) {
  int32_t depth = -int32_t(loc.getPickDepth());
  current->pick(depth);
  return true;
}

bool WarpBuilder::build_Unpick(BytecodeLocation loc) {
  int32_t depth = -int32_t(loc.getUnpickDepth());
  current->unpick(depth);
  return true;
}

bool WarpBuilder::build_Zero(BytecodeLocation) {
  pushConstant(Int32Value(0));
  return true;
}

bool WarpBuilder::build_One(BytecodeLocation) {
  pushConstant(Int32Value(1));
  return true;
}

bool WarpBuilder::build_Int8(BytecodeLocation loc) {
  pushConstant(Int32Value(loc.getInt8()));
  return true;
}

bool WarpBuilder::build_Uint16(BytecodeLocation loc) {
  pushConstant(Int32Value(loc.getUint16()));
  return true;
}

bool WarpBuilder::build_Uint24(BytecodeLocation loc) {
  pushConstant(Int32Value(loc.getUint24()));
  return true;
}

bool WarpBuilder::build_Int32(BytecodeLocation loc) {
  pushConstant(Int32Value(loc.getInt32()));
  return true;
}

bool WarpBuilder::build_Double(BytecodeLocation loc) {
  pushConstant(loc.getInlineValue());
  return true;
}

bool WarpBuilder::build_ResumeIndex(BytecodeLocation loc) {
  pushConstant(Int32Value(loc.getResumeIndex()));
  return true;
}

bool WarpBuilder::build_BigInt(BytecodeLocation loc) {
  BigInt* bi = loc.getBigInt(script_);
  pushConstant(BigIntValue(bi));
  return true;
}

bool WarpBuilder::build_String(BytecodeLocation loc) {
  JSAtom* atom = loc.getAtom(script_);
  pushConstant(StringValue(atom));
  return true;
}

bool WarpBuilder::build_Symbol(BytecodeLocation loc) {
  uint32_t which = loc.getSymbolIndex();
  JS::Symbol* sym = mirGen().runtime->wellKnownSymbols().get(which);
  pushConstant(SymbolValue(sym));
  return true;
}

bool WarpBuilder::build_RegExp(BytecodeLocation loc) {
  RegExpObject* reObj = loc.getRegExp(script_);

  auto* snapshot = getOpSnapshot<WarpRegExp>(loc);

  MRegExp* regexp = MRegExp::New(alloc(), /* constraints = */ nullptr, reObj,
                                 snapshot->hasShared());
  current->add(regexp);
  current->push(regexp);

  return true;
}

bool WarpBuilder::build_Return(BytecodeLocation) {
  MDefinition* def = current->pop();

  MReturn* ret = MReturn::New(alloc(), def);
  current->end(ret);

  setTerminatedBlock();
  return true;
}

bool WarpBuilder::build_RetRval(BytecodeLocation) {
  MDefinition* rval;
  if (script_->noScriptRval()) {
    rval = constant(UndefinedValue());
  } else {
    rval = current->getSlot(info().returnValueSlot());
  }

  MReturn* ret = MReturn::New(alloc(), rval);
  current->end(ret);

  setTerminatedBlock();
  return true;
}

bool WarpBuilder::build_SetRval(BytecodeLocation) {
  MOZ_ASSERT(!script_->noScriptRval());

  MDefinition* rval = current->pop();
  current->setSlot(info().returnValueSlot(), rval);
  return true;
}

bool WarpBuilder::build_GetLocal(BytecodeLocation loc) {
  current->pushLocal(loc.local());
  return true;
}

bool WarpBuilder::build_SetLocal(BytecodeLocation loc) {
  current->setLocal(loc.local());
  return true;
}

bool WarpBuilder::build_InitLexical(BytecodeLocation loc) {
  current->setLocal(loc.local());
  return true;
}

bool WarpBuilder::build_GetArg(BytecodeLocation loc) {
  uint32_t arg = loc.arg();
  if (info().argsObjAliasesFormals()) {
    MDefinition* argsObj = current->argumentsObject();
    auto* getArg = MGetArgumentsObjectArg::New(alloc(), argsObj, arg);
    current->add(getArg);
    current->push(getArg);
  } else {
    current->pushArg(arg);
  }
  return true;
}

bool WarpBuilder::build_SetArg(BytecodeLocation loc) {
  MOZ_ASSERT(script_->jitScript()->modifiesArguments());

  uint32_t arg = loc.arg();
  MDefinition* val = current->peek(-1);

  if (!info().argumentsAliasesFormals()) {
    MOZ_ASSERT(!info().argsObjAliasesFormals());

    // |arguments| is never referenced within this function. No arguments object
    // is created in this case, so we don't need to worry about synchronizing
    // the argument values when writing to them.
    MOZ_ASSERT_IF(!info().hasArguments(), !info().needsArgsObj());

    // The arguments object doesn't map to the actual argument values, so we
    // also don't need to worry about synchronizing them.
    // Directly writing to a positional formal parameter is only possible when
    // the |arguments| contents are never observed, otherwise we can't
    // reconstruct the original parameter values when we access them through
    // |arguments[i]|. AnalyzeArgumentsUsage ensures this is handled correctly.
    MOZ_ASSERT_IF(info().hasArguments(), !info().hasMappedArgsObj());

    current->setArg(arg);
    return true;
  }

  MOZ_ASSERT(info().hasArguments() && info().hasMappedArgsObj(),
             "arguments aliases formals when an arguments binding is present "
             "and the arguments object is mapped");

  // TODO: double check corresponding IonBuilder code when supporting the
  // arguments analysis in WarpBuilder.

  MOZ_ASSERT(info().needsArgsObj(),
             "unexpected JSOp::SetArg with lazy arguments");

  MOZ_ASSERT(
      info().argsObjAliasesFormals(),
      "argsObjAliasesFormals() is true iff a mapped arguments object is used");

  // If an arguments object is in use, and it aliases formals, then all SetArgs
  // must go through the arguments object.
  MDefinition* argsObj = current->argumentsObject();
  current->add(MPostWriteBarrier::New(alloc(), argsObj, val));
  auto* ins = MSetArgumentsObjectArg::New(alloc(), argsObj, arg, val);
  current->add(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_ToNumeric(BytecodeLocation loc) {
  return buildUnaryOp(loc);
}

bool WarpBuilder::build_Pos(BytecodeLocation loc) {
  // TODO: MUnaryCache is the most basic implementation. Optimize it for known
  // numbers at least.
  return buildUnaryOp(loc);
}

bool WarpBuilder::buildUnaryOp(BytecodeLocation loc) {
  MDefinition* value = current->pop();
  return buildIC(loc, CacheKind::UnaryArith, {value});
}

bool WarpBuilder::build_Inc(BytecodeLocation loc) { return buildUnaryOp(loc); }

bool WarpBuilder::build_Dec(BytecodeLocation loc) { return buildUnaryOp(loc); }

bool WarpBuilder::build_Neg(BytecodeLocation loc) { return buildUnaryOp(loc); }

bool WarpBuilder::build_BitNot(BytecodeLocation loc) {
  return buildUnaryOp(loc);
}

bool WarpBuilder::buildBinaryOp(BytecodeLocation loc) {
  MDefinition* right = current->pop();
  MDefinition* left = current->pop();
  return buildIC(loc, CacheKind::BinaryArith, {left, right});
}

bool WarpBuilder::build_Add(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Sub(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Mul(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Div(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Mod(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Pow(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_BitAnd(BytecodeLocation loc) {
  return buildBinaryOp(loc);
}

bool WarpBuilder::build_BitOr(BytecodeLocation loc) {
  return buildBinaryOp(loc);
}

bool WarpBuilder::build_BitXor(BytecodeLocation loc) {
  return buildBinaryOp(loc);
}

bool WarpBuilder::build_Lsh(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Rsh(BytecodeLocation loc) { return buildBinaryOp(loc); }

bool WarpBuilder::build_Ursh(BytecodeLocation loc) {
  return buildBinaryOp(loc);
}

bool WarpBuilder::buildCompareOp(BytecodeLocation loc) {
  MDefinition* right = current->pop();
  MDefinition* left = current->pop();
  return buildIC(loc, CacheKind::Compare, {left, right});
}

bool WarpBuilder::build_Eq(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_Ne(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_Lt(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_Le(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_Gt(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_Ge(BytecodeLocation loc) { return buildCompareOp(loc); }

bool WarpBuilder::build_StrictEq(BytecodeLocation loc) {
  return buildCompareOp(loc);
}

bool WarpBuilder::build_StrictNe(BytecodeLocation loc) {
  return buildCompareOp(loc);
}

bool WarpBuilder::build_JumpTarget(BytecodeLocation loc) {
  PendingEdgesMap::Ptr p = pendingEdges_.lookup(loc.toRawBytecode());
  if (!p) {
    // No (reachable) jumps so this is just a no-op.
    return true;
  }

  PendingEdges edges(std::move(p->value()));
  pendingEdges_.remove(p);

  MOZ_ASSERT(!edges.empty());

  MBasicBlock* joinBlock = nullptr;

  // Create join block if there's fall-through from the previous bytecode op.
  if (!hasTerminatedBlock()) {
    MBasicBlock* pred = current;
    if (!startNewBlock(pred, loc)) {
      return false;
    }
    pred->end(MGoto::New(alloc(), current));
    joinBlock = current;
    setTerminatedBlock();
  }

  auto addEdge = [&](MBasicBlock* pred, size_t numToPop) -> bool {
    if (joinBlock) {
      MOZ_ASSERT(pred->stackDepth() - numToPop == joinBlock->stackDepth());
      return joinBlock->addPredecessorPopN(alloc(), pred, numToPop);
    }
    if (!startNewBlock(pred, loc, numToPop)) {
      return false;
    }
    joinBlock = current;
    setTerminatedBlock();
    return true;
  };

  // When a block is terminated with an MTest instruction we can end up with the
  // following triangle structure:
  //
  //        testBlock
  //         /    |
  //     block    |
  //         \    |
  //        joinBlock
  //
  // Although this is fine for correctness, the FoldTests pass is unable to
  // optimize this pattern. This matters for short-circuit operations
  // (JSOp::And, JSOp::Coalesce, etc).
  //
  // To fix these issues, we create an empty block to get a diamond structure:
  //
  //        testBlock
  //         /    |
  //     block  emptyBlock
  //         \    |
  //        joinBlock
  //
  // TODO: re-evaluate this. It would probably be better to fix FoldTests to
  // support the triangle pattern so that we can remove this. IonBuilder had
  // other concerns that don't apply to WarpBuilder.
  auto createEmptyBlockForTest = [&](MBasicBlock* pred, size_t successor,
                                     size_t numToPop) -> MBasicBlock* {
    MOZ_ASSERT(joinBlock);

    if (!startNewBlock(pred, loc, numToPop)) {
      return nullptr;
    }

    MBasicBlock* emptyBlock = current;
    MOZ_ASSERT(emptyBlock->stackDepth() == joinBlock->stackDepth());

    MTest* test = pred->lastIns()->toTest();
    test->initSuccessor(successor, emptyBlock);

    emptyBlock->end(MGoto::New(alloc(), joinBlock));
    setTerminatedBlock();

    return emptyBlock;
  };

  for (const PendingEdge& edge : edges) {
    MBasicBlock* source = edge.block();
    MControlInstruction* lastIns = source->lastIns();
    switch (edge.kind()) {
      case PendingEdge::Kind::TestTrue: {
        // JSOp::Case must pop the value when branching to the true-target.
        // If we create an empty block, we have to pop the value there instead
        // of as part of the emptyBlock -> joinBlock edge so stack depths match
        // the current depth.
        const size_t numToPop = (edge.testOp() == JSOp::Case) ? 1 : 0;

        const size_t successor = 0;  // true-branch
        if (joinBlock && TestTrueTargetIsJoinPoint(edge.testOp())) {
          MBasicBlock* pred =
              createEmptyBlockForTest(source, successor, numToPop);
          if (!pred || !addEdge(pred, /* numToPop = */ 0)) {
            return false;
          }
        } else {
          if (!addEdge(source, numToPop)) {
            return false;
          }
          lastIns->toTest()->initSuccessor(successor, joinBlock);
        }
        continue;
      }

      case PendingEdge::Kind::TestFalse: {
        const size_t numToPop = 0;
        const size_t successor = 1;  // false-branch
        if (joinBlock && !TestTrueTargetIsJoinPoint(edge.testOp())) {
          MBasicBlock* pred =
              createEmptyBlockForTest(source, successor, numToPop);
          if (!pred || !addEdge(pred, /* numToPop = */ 0)) {
            return false;
          }
        } else {
          if (!addEdge(source, numToPop)) {
            return false;
          }
          lastIns->toTest()->initSuccessor(successor, joinBlock);
        }
        continue;
      }

      case PendingEdge::Kind::Goto:
        if (!addEdge(source, /* numToPop = */ 0)) {
          return false;
        }
        lastIns->toGoto()->initSuccessor(0, joinBlock);
        continue;

      case PendingEdge::Kind::GotoWithFake:
        if (!addEdge(source, /* numToPop = */ 0)) {
          return false;
        }
        lastIns->toGotoWithFake()->initSuccessor(1, joinBlock);
        continue;
    }
    MOZ_CRASH("Invalid kind");
  }

  // Start traversing the join block. Make sure it comes after predecessor
  // blocks created by createEmptyBlockForTest.
  MOZ_ASSERT(hasTerminatedBlock());
  MOZ_ASSERT(joinBlock);
  graph().moveBlockToEnd(joinBlock);
  current = joinBlock;

  return true;
}

bool WarpBuilder::addIteratorLoopPhis(BytecodeLocation loopHead) {
  // When unwinding the stack for a thrown exception, the exception handler must
  // close live iterators. For ForIn and Destructuring loops, the exception
  // handler needs access to values on the stack. To prevent them from being
  // optimized away (and replaced with the JS_OPTIMIZED_OUT MagicValue), we need
  // to mark the phis (and phis they flow into) as having implicit uses.
  // See ProcessTryNotes in vm/Interpreter.cpp and CloseLiveIteratorIon in
  // jit/JitFrames.cpp

  MOZ_ASSERT(current->stackDepth() >= info().firstStackSlot());

  bool emptyStack = current->stackDepth() == info().firstStackSlot();
  if (emptyStack) {
    return true;
  }

  jsbytecode* loopHeadPC = loopHead.toRawBytecode();

  for (TryNoteIterAllNoGC tni(script_, loopHeadPC); !tni.done(); ++tni) {
    const TryNote& tn = **tni;

    // Stop if we reach an outer loop because outer loops were already
    // processed when we visited their loop headers.
    if (tn.isLoop()) {
      BytecodeLocation tnStart = script_->offsetToLocation(tn.start);
      if (tnStart != loopHead) {
        MOZ_ASSERT(tnStart.is(JSOp::LoopHead));
        MOZ_ASSERT(tnStart < loopHead);
        return true;
      }
    }

    switch (tn.kind()) {
      case TryNoteKind::Destructuring:
      case TryNoteKind::ForIn: {
        // For for-in loops we add the iterator object to iterators_. For
        // destructuring loops we add the "done" value that's on top of the
        // stack and used in the exception handler.
        MOZ_ASSERT(tn.stackDepth >= 1);
        uint32_t slot = info().stackSlot(tn.stackDepth - 1);
        MPhi* phi = current->getSlot(slot)->toPhi();
        if (!iterators_.append(phi)) {
          return false;
        }
        break;
      }
      case TryNoteKind::Loop:
      case TryNoteKind::ForOf:
        // Regular loops do not have iterators to close. ForOf loops handle
        // unwinding using catch blocks.
        break;
      default:
        break;
    }
  }

  return true;
}

bool WarpBuilder::build_LoopHead(BytecodeLocation loc) {
  // All loops have the following bytecode structure:
  //
  //    LoopHead
  //    ...
  //    IfNe/Goto to LoopHead

  if (hasTerminatedBlock()) {
    // The whole loop is unreachable.
    return true;
  }

  // Handle OSR from Baseline JIT code.
  if (loc.toRawBytecode() == info().osrPc()) {
    if (!startNewOsrPreHeaderBlock(loc)) {
      return false;
    }
  }

  loopDepth_++;

  MBasicBlock* pred = current;
  if (!startNewLoopHeaderBlock(loc)) {
    return false;
  }

  pred->end(MGoto::New(alloc(), current));

  if (!addIteratorLoopPhis(loc)) {
    return false;
  }

  MInterruptCheck* check = MInterruptCheck::New(alloc());
  current->add(check);

  // TODO: recompile check

  return true;
}

bool WarpBuilder::buildTestOp(BytecodeLocation loc) {
  if (loc.isBackedge()) {
    return buildTestBackedge(loc);
  }

  JSOp op = loc.getOp();
  BytecodeLocation target1 = loc.next();
  BytecodeLocation target2 = loc.getJumpTarget();

  if (TestTrueTargetIsJoinPoint(op)) {
    std::swap(target1, target2);
  }

  // JSOp::And and JSOp::Or inspect the top stack value but don't pop it.
  // Also note that JSOp::Case must pop a second value on the true-branch (the
  // input to the switch-statement). This conditional pop happens in
  // build_JumpTarget.
  bool mustKeepCondition = (op == JSOp::And || op == JSOp::Or);
  MDefinition* value = mustKeepCondition ? current->peek(-1) : current->pop();

  // If this op always branches to the same location we treat this as a
  // JSOp::Goto.
  if (target1 == target2) {
    value->setImplicitlyUsedUnchecked();
    return buildForwardGoto(target1);
  }

  MTest* test = MTest::New(alloc(), value, /* ifTrue = */ nullptr,
                           /* ifFalse = */ nullptr);
  current->end(test);

  if (!addPendingEdge(PendingEdge::NewTestTrue(current, op), target1)) {
    return false;
  }
  if (!addPendingEdge(PendingEdge::NewTestFalse(current, op), target2)) {
    return false;
  }

  setTerminatedBlock();
  return true;
}

bool WarpBuilder::buildTestBackedge(BytecodeLocation loc) {
  JSOp op = loc.getOp();
  MOZ_ASSERT(op == JSOp::IfNe);
  MOZ_ASSERT(loopDepth_ > 0);

  MDefinition* value = current->pop();

  BytecodeLocation loopHead = loc.getJumpTarget();
  MOZ_ASSERT(loopHead.is(JSOp::LoopHead));

  BytecodeLocation successor = loc.next();

  // We can finish the loop now. Use the loophead pc instead of the current pc
  // because the stack depth at the start of that op matches the current stack
  // depth (after popping our operand).
  MBasicBlock* pred = current;
  if (!startNewBlock(current, loopHead)) {
    return false;
  }

  pred->end(MTest::New(alloc(), value, /* ifTrue = */ current,
                       /* ifFalse = */ nullptr));

  if (!addPendingEdge(PendingEdge::NewTestFalse(pred, op), successor)) {
    return false;
  }

  return buildBackedge();
}

bool WarpBuilder::build_IfEq(BytecodeLocation loc) { return buildTestOp(loc); }

bool WarpBuilder::build_IfNe(BytecodeLocation loc) { return buildTestOp(loc); }

bool WarpBuilder::build_And(BytecodeLocation loc) { return buildTestOp(loc); }

bool WarpBuilder::build_Or(BytecodeLocation loc) { return buildTestOp(loc); }

bool WarpBuilder::build_Case(BytecodeLocation loc) { return buildTestOp(loc); }

bool WarpBuilder::build_Default(BytecodeLocation loc) {
  current->pop();
  return buildForwardGoto(loc.getJumpTarget());
}

bool WarpBuilder::build_Coalesce(BytecodeLocation loc) {
  BytecodeLocation target1 = loc.next();
  BytecodeLocation target2 = loc.getJumpTarget();
  MOZ_ASSERT(target2 > target1);

  MDefinition* value = current->peek(-1);

  MInstruction* isNullOrUndefined = MIsNullOrUndefined::New(alloc(), value);
  current->add(isNullOrUndefined);

  current->end(MTest::New(alloc(), isNullOrUndefined, /* ifTrue = */ nullptr,
                          /* ifFalse = */ nullptr));

  if (!addPendingEdge(PendingEdge::NewTestTrue(current, JSOp::Coalesce),
                      target1)) {
    return false;
  }
  if (!addPendingEdge(PendingEdge::NewTestFalse(current, JSOp::Coalesce),
                      target2)) {
    return false;
  }

  setTerminatedBlock();
  return true;
}

bool WarpBuilder::buildBackedge() {
  MOZ_ASSERT(loopDepth_ > 0);
  loopDepth_--;

  MBasicBlock* header = loopStack_.popCopy().header();
  current->end(MGoto::New(alloc(), header));

  AbortReason r = header->setBackedge(alloc(), current);
  if (r == AbortReason::NoAbort) {
    setTerminatedBlock();
    return true;
  }

  MOZ_ASSERT(r == AbortReason::Alloc);
  return false;
}

bool WarpBuilder::buildForwardGoto(BytecodeLocation target) {
  current->end(MGoto::New(alloc(), nullptr));

  if (!addPendingEdge(PendingEdge::NewGoto(current), target)) {
    return false;
  }

  setTerminatedBlock();
  return true;
}

bool WarpBuilder::build_Goto(BytecodeLocation loc) {
  if (loc.isBackedge()) {
    return buildBackedge();
  }

  return buildForwardGoto(loc.getJumpTarget());
}

bool WarpBuilder::build_DebugCheckSelfHosted(BytecodeLocation loc) {
#ifdef DEBUG
  MDefinition* val = current->pop();
  MDebugCheckSelfHosted* check = MDebugCheckSelfHosted::New(alloc(), val);
  current->add(check);
  current->push(check);
  if (!resumeAfter(check, loc)) {
    return false;
  }
#endif
  return true;
}

bool WarpBuilder::build_DynamicImport(BytecodeLocation loc) {
  MDefinition* specifier = current->pop();
  MDynamicImport* ins = MDynamicImport::New(alloc(), specifier);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_Not(BytecodeLocation loc) {
  MDefinition* value = current->pop();
  MNot* ins = MNot::New(alloc(), value, /* constraints = */ nullptr);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_ToString(BytecodeLocation loc) {
  MDefinition* value = current->pop();
  MToString* ins =
      MToString::New(alloc(), value, MToString::SideEffectHandling::Supported);
  current->add(ins);
  current->push(ins);
  MOZ_ASSERT(ins->isEffectful());
  return resumeAfter(ins, loc);
}

bool WarpBuilder::usesEnvironmentChain() const {
  return script_->jitScript()->usesEnvironmentChain();
}

bool WarpBuilder::build_DefVar(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* env = current->environmentChain();
  MDefVar* defvar = MDefVar::New(alloc(), env);
  current->add(defvar);
  return resumeAfter(defvar, loc);
}

bool WarpBuilder::buildDefLexicalOp(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* env = current->environmentChain();
  MDefLexical* defLexical = MDefLexical::New(alloc(), env);
  current->add(defLexical);
  return resumeAfter(defLexical, loc);
}

bool WarpBuilder::build_DefLet(BytecodeLocation loc) {
  return buildDefLexicalOp(loc);
}

bool WarpBuilder::build_DefConst(BytecodeLocation loc) {
  return buildDefLexicalOp(loc);
}

bool WarpBuilder::build_DefFun(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* fun = current->pop();
  MDefinition* env = current->environmentChain();
  MDefFun* deffun = MDefFun::New(alloc(), fun, env);
  current->add(deffun);
  return resumeAfter(deffun, loc);
}

bool WarpBuilder::build_CheckGlobalOrEvalDecl(BytecodeLocation loc) {
  MOZ_ASSERT(!script_->isForEval(), "Eval scripts not supported");
  auto* redeclCheck = MGlobalNameConflictsCheck::New(alloc());
  current->add(redeclCheck);
  return resumeAfter(redeclCheck, loc);
}

bool WarpBuilder::build_BindVar(BytecodeLocation) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* env = current->environmentChain();
  MCallBindVar* ins = MCallBindVar::New(alloc(), env);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_MutateProto(BytecodeLocation loc) {
  MDefinition* value = current->pop();
  MDefinition* obj = current->peek(-1);
  MMutateProto* mutate = MMutateProto::New(alloc(), obj, value);
  current->add(mutate);
  return resumeAfter(mutate, loc);
}

MDefinition* WarpBuilder::getCallee() {
  // TODO: handle inlined callees when we implement inlining.
  MInstruction* callee = MCallee::New(alloc());
  current->add(callee);
  return callee;
}

bool WarpBuilder::build_Callee(BytecodeLocation) {
  MDefinition* callee = getCallee();
  current->push(callee);
  return true;
}

bool WarpBuilder::build_ClassConstructor(BytecodeLocation loc) {
  jsbytecode* pc = loc.toRawBytecode();
  auto* constructor = MClassConstructor::New(alloc(), pc);
  current->add(constructor);
  current->push(constructor);
  return resumeAfter(constructor, loc);
}

bool WarpBuilder::build_DerivedConstructor(BytecodeLocation loc) {
  jsbytecode* pc = loc.toRawBytecode();
  MDefinition* prototype = current->pop();
  auto* constructor = MDerivedClassConstructor::New(alloc(), prototype, pc);
  current->add(constructor);
  current->push(constructor);
  return resumeAfter(constructor, loc);
}

bool WarpBuilder::build_ToAsyncIter(BytecodeLocation loc) {
  MDefinition* nextMethod = current->pop();
  MDefinition* iterator = current->pop();
  MToAsyncIter* ins = MToAsyncIter::New(alloc(), iterator, nextMethod);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_ToId(BytecodeLocation loc) {
  MDefinition* index = current->pop();
  MToId* ins = MToId::New(alloc(), index);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_Typeof(BytecodeLocation) {
  // TODO: remove MTypeOf::inputType_ and unbox in foldsTo instead.
  MDefinition* input = current->pop();
  MTypeOf* ins = MTypeOf::New(alloc(), input, MIRType::Value);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_TypeofExpr(BytecodeLocation loc) {
  return build_Typeof(loc);
}

bool WarpBuilder::build_Arguments(BytecodeLocation loc) {
  auto* snapshot = getOpSnapshot<WarpArguments>(loc);
  MOZ_ASSERT(info().needsArgsObj() == !!snapshot);

  if (!snapshot) {
    pushConstant(MagicValue(JS_OPTIMIZED_ARGUMENTS));
    return true;
  }

  ArgumentsObject* templateObj = snapshot->templateObj();
  MDefinition* env = current->environmentChain();
  auto* argsObj = MCreateArgumentsObject::New(alloc(), env, templateObj);
  current->add(argsObj);
  current->setArgumentsObject(argsObj);
  current->push(argsObj);
  return true;
}

bool WarpBuilder::build_ObjWithProto(BytecodeLocation loc) {
  MDefinition* proto = current->pop();
  MInstruction* ins = MObjectWithProto::New(alloc(), proto);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

MDefinition* WarpBuilder::walkEnvironmentChain(uint32_t numHops) {
  MDefinition* env = current->environmentChain();

  for (uint32_t i = 0; i < numHops; i++) {
    MInstruction* ins = MEnclosingEnvironment::New(alloc(), env);
    current->add(ins);
    env = ins;
  }

  return env;
}

bool WarpBuilder::build_GetAliasedVar(BytecodeLocation loc) {
  EnvironmentCoordinate ec = loc.getEnvironmentCoordinate();
  MDefinition* obj = walkEnvironmentChain(ec.hops());

  MInstruction* load;
  if (EnvironmentObject::nonExtensibleIsFixedSlot(ec)) {
    load = MLoadFixedSlot::New(alloc(), obj, ec.slot());
  } else {
    MInstruction* slots = MSlots::New(alloc(), obj);
    current->add(slots);

    uint32_t slot = EnvironmentObject::nonExtensibleDynamicSlotIndex(ec);
    load = MLoadDynamicSlot::New(alloc(), slots, slot);
  }

  current->add(load);
  current->push(load);
  return true;
}

bool WarpBuilder::build_SetAliasedVar(BytecodeLocation loc) {
  EnvironmentCoordinate ec = loc.getEnvironmentCoordinate();
  MDefinition* val = current->peek(-1);
  MDefinition* obj = walkEnvironmentChain(ec.hops());

  current->add(MPostWriteBarrier::New(alloc(), obj, val));

  MInstruction* store;
  if (EnvironmentObject::nonExtensibleIsFixedSlot(ec)) {
    store = MStoreFixedSlot::NewBarriered(alloc(), obj, ec.slot(), val);
  } else {
    MInstruction* slots = MSlots::New(alloc(), obj);
    current->add(slots);

    uint32_t slot = EnvironmentObject::nonExtensibleDynamicSlotIndex(ec);
    store = MStoreDynamicSlot::NewBarriered(alloc(), slots, slot, val);
  }

  current->add(store);
  return resumeAfter(store, loc);
}

bool WarpBuilder::build_InitAliasedLexical(BytecodeLocation loc) {
  return build_SetAliasedVar(loc);
}

bool WarpBuilder::build_EnvCallee(BytecodeLocation loc) {
  uint32_t numHops = loc.getEnvCalleeNumHops();
  MDefinition* env = walkEnvironmentChain(numHops);
  auto* callee = MLoadFixedSlot::New(alloc(), env, CallObject::calleeSlot());
  current->add(callee);
  current->push(callee);
  return true;
}

bool WarpBuilder::build_Iter(BytecodeLocation loc) {
  MDefinition* obj = current->pop();
  return buildIC(loc, CacheKind::GetIterator, {obj});
}

bool WarpBuilder::build_IterNext(BytecodeLocation) {
  // TODO: IterNext was added as hint to prevent IonBuilder/TI loop restarts.
  // Once IonBuilder is gone this op should probably just be removed.
  MDefinition* def = current->pop();
  MInstruction* unbox =
      MUnbox::New(alloc(), def, MIRType::String, MUnbox::Infallible);
  current->add(unbox);
  current->push(unbox);
  return true;
}

bool WarpBuilder::build_MoreIter(BytecodeLocation loc) {
  MDefinition* iter = current->peek(-1);
  MInstruction* ins = MIteratorMore::New(alloc(), iter);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_EndIter(BytecodeLocation loc) {
  current->pop();  // Iterator value is not used.
  MDefinition* iter = current->pop();
  MInstruction* ins = MIteratorEnd::New(alloc(), iter);
  current->add(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_IsNoIter(BytecodeLocation) {
  MDefinition* def = current->peek(-1);
  MOZ_ASSERT(def->isIteratorMore());
  MInstruction* ins = MIsNoIter::New(alloc(), def);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::buildCallOp(BytecodeLocation loc) {
  uint32_t argc = loc.getCallArgc();
  JSOp op = loc.getOp();
  bool constructing = IsConstructOp(op);
  bool ignoresReturnValue = (op == JSOp::CallIgnoresRv || loc.resultIsPopped());

  CallInfo callInfo(alloc(), loc.toRawBytecode(), constructing,
                    ignoresReturnValue);
  if (!callInfo.init(current, argc)) {
    return false;
  }

  // TODO: Consider using buildIC for this as well.
  if (auto* snapshot = getOpSnapshot<WarpCacheIR>(loc)) {
    return TranspileCacheIRToMIR(mirGen(), loc, current, snapshot, callInfo);
  }

  // TODO: consider adding a Call IC like Baseline has.

  bool needsThisCheck = false;
  if (callInfo.constructing()) {
    // Inline the this-object allocation on the caller-side.
    MDefinition* callee = callInfo.callee();
    MDefinition* newTarget = callInfo.getNewTarget();
    MCreateThis* createThis = MCreateThis::New(alloc(), callee, newTarget);
    current->add(createThis);
    callInfo.thisArg()->setImplicitlyUsedUnchecked();
    callInfo.setThis(createThis);
    needsThisCheck = true;
  }

  MCall* call = makeCall(callInfo, needsThisCheck);
  if (!call) {
    return false;
  }

  current->add(call);
  current->push(call);
  return resumeAfter(call, loc);
}

bool WarpBuilder::build_Call(BytecodeLocation loc) { return buildCallOp(loc); }

bool WarpBuilder::build_CallIgnoresRv(BytecodeLocation loc) {
  return buildCallOp(loc);
}

bool WarpBuilder::build_CallIter(BytecodeLocation loc) {
  return buildCallOp(loc);
}

bool WarpBuilder::build_FunCall(BytecodeLocation loc) {
  return buildCallOp(loc);
}

bool WarpBuilder::build_FunApply(BytecodeLocation loc) {
  return buildCallOp(loc);
}

bool WarpBuilder::build_New(BytecodeLocation loc) { return buildCallOp(loc); }

bool WarpBuilder::build_SuperCall(BytecodeLocation loc) {
  return buildCallOp(loc);
}

bool WarpBuilder::build_FunctionThis(BytecodeLocation loc) {
  MOZ_ASSERT(info().funMaybeLazy());

  if (script_->strict()) {
    // No need to wrap primitive |this| in strict mode.
    current->pushSlot(info().thisSlot());
    return true;
  }

  MOZ_ASSERT(!script_->hasNonSyntacticScope(),
             "WarpOracle should have aborted compilation");

  // TODO: Add fast path to MComputeThis for null/undefined => globalThis.
  MDefinition* def = current->getSlot(info().thisSlot());
  MComputeThis* thisObj = MComputeThis::New(alloc(), def);
  current->add(thisObj);
  current->push(thisObj);

  return resumeAfter(thisObj, loc);
}

bool WarpBuilder::build_GlobalThis(BytecodeLocation loc) {
  MOZ_ASSERT(!script_->hasNonSyntacticScope(),
             "WarpOracle should have aborted compilation");
  Value v = snapshot_.globalLexicalEnvThis();
  pushConstant(v);
  return true;
}

MConstant* WarpBuilder::globalLexicalEnvConstant() {
  JSObject* globalLexical = snapshot_.globalLexicalEnv();
  return constant(ObjectValue(*globalLexical));
}

bool WarpBuilder::build_GetName(BytecodeLocation loc) {
  MDefinition* env = current->environmentChain();
  return buildIC(loc, CacheKind::GetName, {env});
}

bool WarpBuilder::build_GetGName(BytecodeLocation loc) {
  if (script_->hasNonSyntacticScope()) {
    return build_GetName(loc);
  }

  // Try to optimize undefined/NaN/Infinity.
  PropertyName* name = loc.getPropertyName(script_);
  const JSAtomState& names = mirGen().runtime->names();

  if (name == names.undefined) {
    pushConstant(UndefinedValue());
    return true;
  }
  if (name == names.NaN) {
    pushConstant(JS::NaNValue());
    return true;
  }
  if (name == names.Infinity) {
    pushConstant(JS::InfinityValue());
    return true;
  }

  MDefinition* env = globalLexicalEnvConstant();
  return buildIC(loc, CacheKind::GetName, {env});
}

bool WarpBuilder::build_BindName(BytecodeLocation loc) {
  MDefinition* env = current->environmentChain();
  return buildIC(loc, CacheKind::BindName, {env});
}

bool WarpBuilder::build_BindGName(BytecodeLocation loc) {
  if (script_->hasNonSyntacticScope()) {
    return build_BindName(loc);
  }

  MDefinition* env = globalLexicalEnvConstant();
  return buildIC(loc, CacheKind::BindName, {env});
}

bool WarpBuilder::build_GetProp(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  return buildIC(loc, CacheKind::GetProp, {val});
}

bool WarpBuilder::build_CallProp(BytecodeLocation loc) {
  return build_GetProp(loc);
}

bool WarpBuilder::build_Length(BytecodeLocation loc) {
  return build_GetProp(loc);
}

bool WarpBuilder::build_GetElem(BytecodeLocation loc) {
  MDefinition* id = current->pop();
  MDefinition* val = current->pop();
  return buildIC(loc, CacheKind::GetElem, {val, id});
}

bool WarpBuilder::build_CallElem(BytecodeLocation loc) {
  return build_GetElem(loc);
}

bool WarpBuilder::build_SetProp(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* obj = current->pop();
  current->push(val);
  return buildIC(loc, CacheKind::SetProp, {obj, val});
}

bool WarpBuilder::build_StrictSetProp(BytecodeLocation loc) {
  return build_SetProp(loc);
}

bool WarpBuilder::build_SetName(BytecodeLocation loc) {
  return build_SetProp(loc);
}

bool WarpBuilder::build_StrictSetName(BytecodeLocation loc) {
  return build_SetProp(loc);
}

bool WarpBuilder::build_SetGName(BytecodeLocation loc) {
  return build_SetProp(loc);
}

bool WarpBuilder::build_StrictSetGName(BytecodeLocation loc) {
  return build_SetProp(loc);
}

bool WarpBuilder::build_InitGLexical(BytecodeLocation loc) {
  MOZ_ASSERT(!script_->hasNonSyntacticScope());

  MDefinition* globalLexical = globalLexicalEnvConstant();
  MDefinition* val = current->peek(-1);

  return buildIC(loc, CacheKind::SetProp, {globalLexical, val});
}

bool WarpBuilder::build_SetElem(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* id = current->pop();
  MDefinition* obj = current->pop();
  current->push(val);
  return buildIC(loc, CacheKind::SetElem, {obj, id, val});
}

bool WarpBuilder::build_StrictSetElem(BytecodeLocation loc) {
  return build_SetElem(loc);
}

bool WarpBuilder::build_DelProp(BytecodeLocation loc) {
  PropertyName* name = loc.getPropertyName(script_);
  MDefinition* obj = current->pop();
  bool strict = loc.getOp() == JSOp::StrictDelProp;

  MInstruction* ins = MDeleteProperty::New(alloc(), obj, name, strict);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_StrictDelProp(BytecodeLocation loc) {
  return build_DelProp(loc);
}

bool WarpBuilder::build_DelElem(BytecodeLocation loc) {
  MDefinition* id = current->pop();
  MDefinition* obj = current->pop();
  bool strict = loc.getOp() == JSOp::StrictDelElem;

  MInstruction* ins = MDeleteElement::New(alloc(), obj, id, strict);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_StrictDelElem(BytecodeLocation loc) {
  return build_DelElem(loc);
}

bool WarpBuilder::build_SetFunName(BytecodeLocation loc) {
  FunctionPrefixKind prefixKind = loc.getFunctionPrefixKind();
  MDefinition* name = current->pop();
  MDefinition* fun = current->pop();

  MSetFunName* ins = MSetFunName::New(alloc(), fun, name, uint8_t(prefixKind));
  current->add(ins);
  current->push(fun);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_PushLexicalEnv(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  LexicalScope* scope = &loc.getScope(script_)->as<LexicalScope>();
  MDefinition* env = current->environmentChain();

  auto* ins = MNewLexicalEnvironmentObject::New(alloc(), env, scope);
  current->add(ins);
  current->setEnvironmentChain(ins);
  return true;
}

bool WarpBuilder::build_PopLexicalEnv(BytecodeLocation) {
  MDefinition* enclosingEnv = walkEnvironmentChain(1);
  current->setEnvironmentChain(enclosingEnv);
  return true;
}

void WarpBuilder::buildCopyLexicalEnvOp(bool copySlots) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* env = current->environmentChain();
  auto* ins = MCopyLexicalEnvironmentObject::New(alloc(), env, copySlots);
  current->add(ins);
  current->setEnvironmentChain(ins);
}

bool WarpBuilder::build_FreshenLexicalEnv(BytecodeLocation) {
  buildCopyLexicalEnvOp(/* copySlots = */ true);
  return true;
}

bool WarpBuilder::build_RecreateLexicalEnv(BytecodeLocation) {
  buildCopyLexicalEnvOp(/* copySlots = */ false);
  return true;
}

bool WarpBuilder::build_ImplicitThis(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  PropertyName* name = loc.getPropertyName(script_);
  MDefinition* env = current->environmentChain();

  auto* ins = MImplicitThis::New(alloc(), env, name);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_GImplicitThis(BytecodeLocation loc) {
  if (script_->hasNonSyntacticScope()) {
    return build_ImplicitThis(loc);
  }
  return build_Undefined(loc);
}

bool WarpBuilder::build_CheckClassHeritage(BytecodeLocation loc) {
  MDefinition* def = current->pop();
  auto* ins = MCheckClassHeritage::New(alloc(), def);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_CheckThis(BytecodeLocation) {
  MDefinition* def = current->pop();
  auto* ins = MCheckThis::New(alloc(), def);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_CheckThisReinit(BytecodeLocation) {
  MDefinition* def = current->pop();
  auto* ins = MCheckThisReinit::New(alloc(), def);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_CheckReturn(BytecodeLocation) {
  MOZ_ASSERT(!script_->noScriptRval());

  MDefinition* returnValue = current->getSlot(info().returnValueSlot());
  MDefinition* thisValue = current->pop();

  auto* ins = MCheckReturn::New(alloc(), returnValue, thisValue);
  current->add(ins);
  current->setSlot(info().returnValueSlot(), ins);
  return true;
}

void WarpBuilder::buildCheckLexicalOp(BytecodeLocation loc) {
  JSOp op = loc.getOp();
  MOZ_ASSERT(op == JSOp::CheckLexical || op == JSOp::CheckAliasedLexical);

  // TODO: IonBuilder has code to mark not-movable if lexical checks failed
  // before. We likely need a mechanism to prevent LICM/bailout loops.
  MDefinition* input = current->pop();
  MInstruction* lexicalCheck = MLexicalCheck::New(alloc(), input);
  current->add(lexicalCheck);
  current->push(lexicalCheck);

  if (op == JSOp::CheckLexical) {
    // Set the local slot so that a subsequent GetLocal without a CheckLexical
    // (the frontend can elide lexical checks) doesn't let a definition with
    // MIRType::MagicUninitializedLexical escape to arbitrary MIR instructions.
    // Note that in this case the GetLocal would be unreachable because we throw
    // an exception here, but we still generate MIR instructions for it.
    uint32_t slot = info().localSlot(loc.local());
    current->setSlot(slot, lexicalCheck);
  }
}

bool WarpBuilder::build_CheckLexical(BytecodeLocation loc) {
  buildCheckLexicalOp(loc);
  return true;
}

bool WarpBuilder::build_CheckAliasedLexical(BytecodeLocation loc) {
  buildCheckLexicalOp(loc);
  return true;
}

bool WarpBuilder::build_InitHomeObject(BytecodeLocation loc) {
  MDefinition* homeObject = current->pop();
  MDefinition* function = current->pop();

  current->add(MPostWriteBarrier::New(alloc(), function, homeObject));

  auto* ins = MInitHomeObject::New(alloc(), function, homeObject);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_SuperBase(BytecodeLocation) {
  MDefinition* callee = current->pop();

  auto* homeObject = MHomeObject::New(alloc(), callee);
  current->add(homeObject);

  auto* superBase = MHomeObjectSuperBase::New(alloc(), homeObject);
  current->add(superBase);
  current->push(superBase);
  return true;
}

bool WarpBuilder::build_SuperFun(BytecodeLocation) {
  MDefinition* callee = current->pop();
  auto* ins = MSuperFunction::New(alloc(), callee);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_FunctionProto(BytecodeLocation loc) {
  if (auto* snapshot = getOpSnapshot<WarpFunctionProto>(loc)) {
    JSObject* proto = snapshot->proto();
    pushConstant(ObjectValue(*proto));
    return true;
  }

  auto* ins = MFunctionProto::New(alloc());
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_GetIntrinsic(BytecodeLocation loc) {
  if (auto* snapshot = getOpSnapshot<WarpGetIntrinsic>(loc)) {
    Value intrinsic = snapshot->intrinsic();
    pushConstant(intrinsic);
    return true;
  }

  PropertyName* name = loc.getPropertyName(script_);
  MCallGetIntrinsicValue* ins = MCallGetIntrinsicValue::New(alloc(), name);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_ImportMeta(BytecodeLocation loc) {
  ModuleObject* moduleObj = snapshot_.script()->moduleObject();
  MOZ_ASSERT(moduleObj);

  MModuleMetadata* ins = MModuleMetadata::New(alloc(), moduleObj);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_CallSiteObj(BytecodeLocation loc) {
  // WarpOracle already called ProcessCallSiteObjOperation to prepare the
  // object.
  JSObject* obj = loc.getObject(script_);
  pushConstant(ObjectValue(*obj));
  return true;
}

bool WarpBuilder::build_NewArray(BytecodeLocation loc) {
  uint32_t length = loc.getNewArrayLength();

  // TODO: support pre-tenuring.
  gc::InitialHeap heap = gc::DefaultHeap;

  MConstant* templateConst;
  bool useVMCall;
  if (const auto* snapshot = getOpSnapshot<WarpNewArray>(loc)) {
    templateConst = constant(ObjectValue(*snapshot->templateObject()));
    useVMCall = snapshot->useVMCall();
  } else {
    templateConst = constant(NullValue());
    useVMCall = true;
  }

  MNewArray* ins;
  if (useVMCall) {
    ins = MNewArray::NewVM(alloc(), /* constraints = */ nullptr, length,
                           templateConst, heap, loc.toRawBytecode());
  } else {
    ins = MNewArray::New(alloc(), /* constraints = */ nullptr, length,
                         templateConst, heap, loc.toRawBytecode());
  }
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_NewArrayCopyOnWrite(BytecodeLocation loc) {
  MOZ_CRASH("Bug 1626854: COW arrays disabled without TI for now");

  ArrayObject* templateObject = &loc.getObject(script_)->as<ArrayObject>();

  // TODO: pre-tenuring.
  gc::InitialHeap heap = gc::DefaultHeap;
  MConstant* templateConst =
      MConstant::NewConstraintlessObject(alloc(), templateObject);
  current->add(templateConst);

  auto* ins = MNewArrayCopyOnWrite::New(alloc(), /* constraints = */ nullptr,
                                        templateConst, heap);
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_NewObject(BytecodeLocation loc) {
  // TODO: support pre-tenuring.
  gc::InitialHeap heap = gc::DefaultHeap;

  MNewObject* ins;
  if (const auto* snapshot = getOpSnapshot<WarpNewObject>(loc)) {
    auto* templateConst = constant(ObjectValue(*snapshot->templateObject()));
    ins = MNewObject::New(alloc(), /* constraints = */ nullptr, templateConst,
                          heap, MNewObject::ObjectLiteral);
  } else {
    auto* templateConst = constant(NullValue());
    ins = MNewObject::NewVM(alloc(), /* constraints = */ nullptr, templateConst,
                            heap, MNewObject::ObjectLiteral);
  }
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_NewObjectWithGroup(BytecodeLocation loc) {
  return build_NewObject(loc);
}

bool WarpBuilder::build_NewInit(BytecodeLocation loc) {
  return build_NewObject(loc);
}

bool WarpBuilder::build_Object(BytecodeLocation loc) {
  JSObject* obj = loc.getObject(script_);
  MConstant* objConst = constant(ObjectValue(*obj));

  if (mirGen().options.cloneSingletons()) {
    auto* clone = MCloneLiteral::New(alloc(), objConst);
    current->add(clone);
    current->push(clone);
    return resumeAfter(clone, loc);
  }

  // WarpOracle called realm->setSingletonsAsValues() so we can just push the
  // object here.
  current->push(objConst);
  return true;
}

bool WarpBuilder::buildInitPropGetterSetterOp(BytecodeLocation loc) {
  PropertyName* name = loc.getPropertyName(script_);
  MDefinition* value = current->pop();
  MDefinition* obj = current->peek(-1);

  auto* ins = MInitPropGetterSetter::New(alloc(), obj, name, value);
  current->add(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_InitPropGetter(BytecodeLocation loc) {
  return buildInitPropGetterSetterOp(loc);
}

bool WarpBuilder::build_InitPropSetter(BytecodeLocation loc) {
  return buildInitPropGetterSetterOp(loc);
}

bool WarpBuilder::build_InitHiddenPropGetter(BytecodeLocation loc) {
  return buildInitPropGetterSetterOp(loc);
}

bool WarpBuilder::build_InitHiddenPropSetter(BytecodeLocation loc) {
  return buildInitPropGetterSetterOp(loc);
}

bool WarpBuilder::buildInitElemGetterSetterOp(BytecodeLocation loc) {
  MDefinition* value = current->pop();
  MDefinition* id = current->pop();
  MDefinition* obj = current->peek(-1);

  auto* ins = MInitElemGetterSetter::New(alloc(), obj, id, value);
  current->add(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_InitElemGetter(BytecodeLocation loc) {
  return buildInitElemGetterSetterOp(loc);
}

bool WarpBuilder::build_InitElemSetter(BytecodeLocation loc) {
  return buildInitElemGetterSetterOp(loc);
}

bool WarpBuilder::build_InitHiddenElemGetter(BytecodeLocation loc) {
  return buildInitElemGetterSetterOp(loc);
}

bool WarpBuilder::build_InitHiddenElemSetter(BytecodeLocation loc) {
  return buildInitElemGetterSetterOp(loc);
}

bool WarpBuilder::build_In(BytecodeLocation loc) {
  MDefinition* obj = current->pop();
  MDefinition* id = current->pop();
  return buildIC(loc, CacheKind::In, {id, obj});
}

bool WarpBuilder::build_HasOwn(BytecodeLocation loc) {
  MDefinition* obj = current->pop();
  MDefinition* id = current->pop();
  return buildIC(loc, CacheKind::HasOwn, {id, obj});
}

bool WarpBuilder::build_Instanceof(BytecodeLocation loc) {
  MDefinition* rhs = current->pop();
  MDefinition* obj = current->pop();
  return buildIC(loc, CacheKind::InstanceOf, {obj, rhs});
}

bool WarpBuilder::build_NewTarget(BytecodeLocation loc) {
  MOZ_ASSERT(script_->isFunction());
  MOZ_ASSERT(info().funMaybeLazy());

  if (snapshot_.script()->isArrowFunction()) {
    MDefinition* callee = getCallee();
    MArrowNewTarget* ins = MArrowNewTarget::New(alloc(), callee);
    current->add(ins);
    current->push(ins);
    return true;
  }

  // TODO: handle newTarget in inlined functions when we can inline.

  MNewTarget* ins = MNewTarget::New(alloc());
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_CheckIsObj(BytecodeLocation loc) {
  CheckIsObjectKind kind = loc.getCheckIsObjectKind();
  MDefinition* val = current->pop();

  MCheckIsObj* ins = MCheckIsObj::New(alloc(), val, uint8_t(kind));
  current->add(ins);
  current->push(ins);
  return true;
}

bool WarpBuilder::build_CheckObjCoercible(BytecodeLocation) {
  MDefinition* val = current->pop();
  MCheckObjCoercible* ins = MCheckObjCoercible::New(alloc(), val);
  current->add(ins);
  current->push(ins);
  return true;
}

MInstruction* WarpBuilder::buildLoadSlot(MDefinition* obj,
                                         uint32_t numFixedSlots,
                                         uint32_t slot) {
  if (slot < numFixedSlots) {
    MLoadFixedSlot* load = MLoadFixedSlot::New(alloc(), obj, slot);
    current->add(load);
    return load;
  }

  MSlots* slots = MSlots::New(alloc(), obj);
  current->add(slots);

  MLoadDynamicSlot* load =
      MLoadDynamicSlot::New(alloc(), slots, slot - numFixedSlots);
  current->add(load);
  return load;
}

bool WarpBuilder::build_GetImport(BytecodeLocation loc) {
  auto* snapshot = getOpSnapshot<WarpGetImport>(loc);

  ModuleEnvironmentObject* targetEnv = snapshot->targetEnv();

  // Load the target environment slot.
  MConstant* obj = constant(ObjectValue(*targetEnv));
  auto* load = buildLoadSlot(obj, snapshot->numFixedSlots(), snapshot->slot());

  if (snapshot->needsLexicalCheck()) {
    // TODO: IonBuilder has code to mark non-movable. See buildCheckLexicalOp.
    MInstruction* lexicalCheck = MLexicalCheck::New(alloc(), load);
    current->add(lexicalCheck);
    current->push(lexicalCheck);
  } else {
    current->push(load);
  }

  return true;
}

bool WarpBuilder::build_GetPropSuper(BytecodeLocation loc) {
  MDefinition* obj = current->pop();
  MDefinition* receiver = current->pop();
  return buildIC(loc, CacheKind::GetPropSuper, {obj, receiver});
}

bool WarpBuilder::build_GetElemSuper(BytecodeLocation loc) {
  MDefinition* obj = current->pop();
  MDefinition* id = current->pop();
  MDefinition* receiver = current->pop();
  return buildIC(loc, CacheKind::GetElemSuper, {obj, id, receiver});
}

bool WarpBuilder::build_InitProp(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* obj = current->peek(-1);
  return buildIC(loc, CacheKind::SetProp, {obj, val});
}

bool WarpBuilder::build_InitLockedProp(BytecodeLocation loc) {
  return build_InitProp(loc);
}

bool WarpBuilder::build_InitHiddenProp(BytecodeLocation loc) {
  return build_InitProp(loc);
}

bool WarpBuilder::build_InitElem(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* id = current->pop();
  MDefinition* obj = current->peek(-1);
  return buildIC(loc, CacheKind::SetElem, {obj, id, val});
}

bool WarpBuilder::build_InitHiddenElem(BytecodeLocation loc) {
  return build_InitElem(loc);
}

bool WarpBuilder::build_InitElemArray(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* obj = current->peek(-1);

  // Note: getInitElemArrayIndex asserts the index fits in int32_t.
  uint32_t index = loc.getInitElemArrayIndex();
  MConstant* indexConst = constant(Int32Value(index));

  // Note: InitArrayElemOperation asserts the index does not exceed the array's
  // dense element capacity.

  auto* elements = MElements::New(alloc(), obj);
  current->add(elements);

  current->add(MPostWriteBarrier::New(alloc(), obj, val));

  auto* store = MStoreElement::New(alloc(), elements, indexConst, val,
                                   /* needsHoleCheck = */ false);
  current->add(store);

  auto* setLength = MSetInitializedLength::New(alloc(), elements, indexConst);
  current->add(setLength);

  return resumeAfter(setLength, loc);
}

bool WarpBuilder::build_InitElemInc(BytecodeLocation loc) {
  MDefinition* val = current->pop();
  MDefinition* index = current->pop();
  MDefinition* obj = current->peek(-1);

  // Push index + 1.
  MConstant* constOne = constant(Int32Value(1));
  MAdd* nextIndex = MAdd::New(alloc(), index, constOne, MDefinition::Truncate);
  current->add(nextIndex);
  current->push(nextIndex);

  return buildIC(loc, CacheKind::SetElem, {obj, index, val});
}

static LambdaFunctionInfo LambdaInfoFromSnapshot(JSFunction* fun,
                                                 const WarpLambda* snapshot) {
  // Pass false for singletonType and useSingletonForClone as asserted in
  // WarpOracle.
  return LambdaFunctionInfo(fun, snapshot->baseScript(), snapshot->flags(),
                            snapshot->nargs(), /* singletonType = */ false,
                            /* useSingletonForClone = */ false);
}

bool WarpBuilder::build_Lambda(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  auto* snapshot = getOpSnapshot<WarpLambda>(loc);

  MDefinition* env = current->environmentChain();

  JSFunction* fun = loc.getFunction(script_);
  MConstant* funConst = constant(ObjectValue(*fun));

  auto* ins = MLambda::New(alloc(), /* constraints = */ nullptr, env, funConst,
                           LambdaInfoFromSnapshot(fun, snapshot));
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_LambdaArrow(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  auto* snapshot = getOpSnapshot<WarpLambda>(loc);

  MDefinition* env = current->environmentChain();
  MDefinition* newTarget = current->pop();

  JSFunction* fun = loc.getFunction(script_);
  MConstant* funConst = constant(ObjectValue(*fun));

  auto* ins =
      MLambdaArrow::New(alloc(), /* constraints = */ nullptr, env, newTarget,
                        funConst, LambdaInfoFromSnapshot(fun, snapshot));
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_FunWithProto(BytecodeLocation loc) {
  MOZ_ASSERT(usesEnvironmentChain());

  MDefinition* proto = current->pop();
  MDefinition* env = current->environmentChain();

  JSFunction* fun = loc.getFunction(script_);
  MConstant* funConst = constant(ObjectValue(*fun));

  auto* ins = MFunctionWithProto::New(alloc(), env, proto, funConst);
  current->add(ins);
  current->push(ins);
  return resumeAfter(ins, loc);
}

bool WarpBuilder::build_SpreadCall(BytecodeLocation loc) {
  MDefinition* argArr = current->pop();
  MDefinition* argThis = current->pop();
  MDefinition* argFunc = current->pop();

  // Load dense elements of the argument array. Note that the bytecode ensures
  // this is an array.
  MElements* elements = MElements::New(alloc(), argArr);
  current->add(elements);

  WrappedFunction* wrappedTarget = nullptr;
  auto* apply =
      MApplyArray::New(alloc(), wrappedTarget, argFunc, elements, argThis);
  current->add(apply);
  current->push(apply);

  if (loc.resultIsPopped()) {
    apply->setIgnoresReturnValue();
  }

  return resumeAfter(apply, loc);
}

bool WarpBuilder::build_SpreadNew(BytecodeLocation loc) {
  MDefinition* newTarget = current->pop();
  MDefinition* argArr = current->pop();
  MDefinition* thisValue = current->pop();
  MDefinition* callee = current->pop();

  // Inline the constructor on the caller-side.
  MCreateThis* createThis = MCreateThis::New(alloc(), callee, newTarget);
  current->add(createThis);
  thisValue->setImplicitlyUsedUnchecked();

  // Load dense elements of the argument array. Note that the bytecode ensures
  // this is an array.
  MElements* elements = MElements::New(alloc(), argArr);
  current->add(elements);

  WrappedFunction* wrappedTarget = nullptr;
  auto* apply = MConstructArray::New(alloc(), wrappedTarget, callee, elements,
                                     createThis, newTarget);
  current->add(apply);
  current->push(apply);
  return resumeAfter(apply, loc);
}

bool WarpBuilder::build_SpreadSuperCall(BytecodeLocation loc) {
  return build_SpreadNew(loc);
}

bool WarpBuilder::build_OptimizeSpreadCall(BytecodeLocation loc) {
  // TODO: like IonBuilder's slow path always deoptimize for now. Consider using
  // an IC for this so that we can optimize by inlining Baseline's CacheIR.
  MDefinition* arr = current->peek(-1);
  arr->setImplicitlyUsedUnchecked();
  pushConstant(BooleanValue(false));
  return true;
}

bool WarpBuilder::build_Debugger(BytecodeLocation loc) {
  // The |debugger;| statement will bail out to Baseline if the realm is a
  // debuggee realm with an onDebuggerStatement hook.
  MDebugger* debugger = MDebugger::New(alloc());
  current->add(debugger);
  return resumeAfter(debugger, loc);
}

bool WarpBuilder::build_InstrumentationActive(BytecodeLocation) {
  bool active = snapshot_.script()->instrumentationActive();
  pushConstant(BooleanValue(active));
  return true;
}

bool WarpBuilder::build_InstrumentationCallback(BytecodeLocation) {
  JSObject* callback = snapshot_.script()->instrumentationCallback();
  pushConstant(ObjectValue(*callback));
  return true;
}

bool WarpBuilder::build_InstrumentationScriptId(BytecodeLocation) {
  int32_t scriptId = snapshot_.script()->instrumentationScriptId();
  pushConstant(Int32Value(scriptId));
  return true;
}

bool WarpBuilder::build_TableSwitch(BytecodeLocation loc) {
  int32_t low = loc.getTableSwitchLow();
  int32_t high = loc.getTableSwitchHigh();
  size_t numCases = high - low + 1;

  MDefinition* input = current->pop();
  MTableSwitch* tableswitch = MTableSwitch::New(alloc(), input, low, high);
  current->end(tableswitch);

  MBasicBlock* switchBlock = current;

  // Create |default| block.
  {
    BytecodeLocation defaultLoc = loc.getTableSwitchDefaultTarget();
    if (!startNewBlock(switchBlock, defaultLoc)) {
      return false;
    }

    size_t index;
    if (!tableswitch->addDefault(current, &index)) {
      return false;
    }
    MOZ_ASSERT(index == 0);

    if (!buildForwardGoto(defaultLoc)) {
      return false;
    }
  }

  // Create blocks for all cases.
  for (size_t i = 0; i < numCases; i++) {
    BytecodeLocation caseLoc = loc.getTableSwitchCaseTarget(script_, i);
    if (!startNewBlock(switchBlock, caseLoc)) {
      return false;
    }

    size_t index;
    if (!tableswitch->addSuccessor(current, &index)) {
      return false;
    }
    if (!tableswitch->addCase(index)) {
      return false;
    }

    // TODO: IonBuilder has an optimization where it replaces the switch input
    // with the case value. This probably matters less for Warp. Re-evaluate.

    if (!buildForwardGoto(caseLoc)) {
      return false;
    }
  }

  MOZ_ASSERT(hasTerminatedBlock());
  return true;
}

bool WarpBuilder::build_Rest(BytecodeLocation loc) {
  // TODO: handle inlined functions once we support inlining.

  auto* snapshot = getOpSnapshot<WarpRest>(loc);
  ArrayObject* templateObject = snapshot->templateObject();

  MArgumentsLength* numActuals = MArgumentsLength::New(alloc());
  current->add(numActuals);

  // Pass in the number of actual arguments, the number of formals (not
  // including the rest parameter slot itself), and the template object.
  unsigned numFormals = info().nargs() - 1;
  MRest* rest = MRest::New(alloc(), /* constraints = */ nullptr, numActuals,
                           numFormals, templateObject);
  current->add(rest);
  current->push(rest);
  return true;
}

bool WarpBuilder::build_Try(BytecodeLocation loc) {
  // Note: WarpOracle aborts compilation for try-statements with a 'finally'
  // block.

  // TODO: IonBuilder doesn't support try-catch in inlined functions. This is
  // most likely not a hard limitation. Re-evaluate this when we can inline.

  // Get the location of the last instruction in the try block. It's a
  // JSOp::Goto to jump over the catch block.
  BytecodeLocation endOfTryLoc = loc.getEndOfTryLocation();
  MOZ_ASSERT(endOfTryLoc.is(JSOp::Goto));

  BytecodeLocation afterTryLoc = endOfTryLoc.getJumpTarget();
  MOZ_ASSERT(afterTryLoc > endOfTryLoc);

  // The Baseline compiler should not attempt to enter the catch block via OSR.
  MOZ_ASSERT(info().osrPc() < endOfTryLoc.toRawBytecode() ||
             info().osrPc() >= afterTryLoc.toRawBytecode());

  graph().setHasTryBlock();

  // If control flow in the try body is terminated (by a return or throw
  // statement), the code after the try-statement may still be reachable via the
  // catch block (which we don't compile) and OSR can enter it.
  // For example:
  //
  //     try {
  //         throw 3;
  //     } catch(e) { }
  //
  //     for (var i=0; i<1000; i++) {} // OSR
  //
  // To handle this, we create two blocks: one for the try block and one
  // for the code following the try-catch statement. MGotoWithFake is used to
  // link both blocks to the predecessor block.

  MBasicBlock* pred = current;
  if (!startNewBlock(pred, loc.next())) {
    return false;
  }

  pred->end(MGotoWithFake::New(alloc(), current, nullptr));
  return addPendingEdge(PendingEdge::NewGotoWithFake(pred), afterTryLoc);
}

bool WarpBuilder::build_Throw(BytecodeLocation loc) {
  MDefinition* def = current->pop();

  MThrow* ins = MThrow::New(alloc(), def);
  current->add(ins);
  if (!resumeAfter(ins, loc)) {
    return false;
  }

  // Terminate the block.
  current->end(MUnreachable::New(alloc()));
  setTerminatedBlock();
  return true;
}

bool WarpBuilder::build_ThrowSetConst(BytecodeLocation loc) {
  auto* ins = MThrowRuntimeLexicalError::New(alloc(), JSMSG_BAD_CONST_ASSIGN);
  current->add(ins);
  if (!resumeAfter(ins, loc)) {
    return false;
  }

  // Terminate the block.
  current->end(MUnreachable::New(alloc()));
  setTerminatedBlock();
  return true;
}

bool WarpBuilder::buildIC(BytecodeLocation loc, CacheKind kind,
                          std::initializer_list<MDefinition*> inputs) {
  MOZ_ASSERT(loc.opHasIC());

  mozilla::DebugOnly<size_t> numInputs = inputs.size();
  MOZ_ASSERT(numInputs == NumInputsForCacheKind(kind));

  if (auto* snapshot = getOpSnapshot<WarpCacheIR>(loc)) {
    MDefinitionStackVector inputs_;
    if (!inputs_.append(inputs.begin(), inputs.end())) {
      return false;
    }
    return TranspileCacheIRToMIR(mirGen(), loc, current, snapshot, inputs_);
  }

  // Work around std::initializer_list not defining operator[].
  auto getInput = [&](size_t index) -> MDefinition* {
    MOZ_ASSERT(index < numInputs);
    return inputs.begin()[index];
  };

  switch (kind) {
    case CacheKind::UnaryArith: {
      MOZ_ASSERT(numInputs == 1);
      auto* ins = MUnaryCache::New(alloc(), getInput(0));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::BinaryArith: {
      MOZ_ASSERT(numInputs == 2);
      auto* ins =
          MBinaryCache::New(alloc(), getInput(0), getInput(1), MIRType::Value);
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::Compare: {
      MOZ_ASSERT(numInputs == 2);
      auto* ins = MBinaryCache::New(alloc(), getInput(0), getInput(1),
                                    MIRType::Boolean);
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::In: {
      MOZ_ASSERT(numInputs == 2);
      auto* ins = MInCache::New(alloc(), getInput(0), getInput(1));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::HasOwn: {
      MOZ_ASSERT(numInputs == 2);
      // Note: the MHasOwnCache constructor takes obj/id instead of id/obj.
      auto* ins = MHasOwnCache::New(alloc(), getInput(1), getInput(0));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::InstanceOf: {
      MOZ_ASSERT(numInputs == 2);
      auto* ins = MInstanceOfCache::New(alloc(), getInput(0), getInput(1));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::BindName: {
      MOZ_ASSERT(numInputs == 1);
      auto* ins = MBindNameCache::New(alloc(), getInput(0));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetIterator: {
      MOZ_ASSERT(numInputs == 1);
      auto* ins = MGetIteratorCache::New(alloc(), getInput(0));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetName: {
      MOZ_ASSERT(numInputs == 1);
      auto* ins = MGetNameCache::New(alloc(), getInput(0));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetProp: {
      MOZ_ASSERT(numInputs == 1);
      PropertyName* name = loc.getPropertyName(script_);
      MConstant* id = constant(StringValue(name));
      // For now pass monitoredResult = true to get the behavior we want (no
      // TI-related restrictions apply, similar to the Baseline IC).
      // See also IonGetPropertyICFlags.
      bool monitoredResult = true;
      auto* ins =
          MGetPropertyCache::New(alloc(), getInput(0), id, monitoredResult);
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetElem: {
      MOZ_ASSERT(numInputs == 2);
      bool monitoredResult = true;  // See GetProp case above.
      auto* ins = MGetPropertyCache::New(alloc(), getInput(0), getInput(1),
                                         monitoredResult);
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::SetProp: {
      MOZ_ASSERT(numInputs == 2);
      PropertyName* name = loc.getPropertyName(script_);
      MConstant* id = constant(StringValue(name));
      bool strict = loc.isStrictSetOp();
      bool needsPostBarrier = true;
      bool needsTypeBarrier = false;
      bool guardHoles = true;
      auto* ins = MSetPropertyCache::New(alloc(), getInput(0), id, getInput(1),
                                         strict, needsPostBarrier,
                                         needsTypeBarrier, guardHoles);
      current->add(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::SetElem: {
      MOZ_ASSERT(numInputs == 3);
      bool strict = loc.isStrictSetOp();
      bool needsPostBarrier = true;
      bool needsTypeBarrier = false;
      bool guardHoles = true;
      auto* ins = MSetPropertyCache::New(alloc(), getInput(0), getInput(1),
                                         getInput(2), strict, needsPostBarrier,
                                         needsTypeBarrier, guardHoles);
      current->add(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetPropSuper: {
      MOZ_ASSERT(numInputs == 2);
      PropertyName* name = loc.getPropertyName(script_);
      MConstant* id = constant(StringValue(name));
      auto* ins =
          MGetPropSuperCache::New(alloc(), getInput(0), getInput(1), id);
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetElemSuper: {
      MOZ_ASSERT(numInputs == 3);
      // Note: CacheIR expects obj/id/receiver but MGetPropSuperCache takes
      // obj/receiver/id so swap the last two inputs.
      auto* ins = MGetPropSuperCache::New(alloc(), getInput(0), getInput(2),
                                          getInput(1));
      current->add(ins);
      current->push(ins);
      return resumeAfter(ins, loc);
    }
    case CacheKind::GetIntrinsic:
    case CacheKind::ToBool:
    case CacheKind::TypeOf:
    case CacheKind::Call:
    case CacheKind::NewObject:
      // We're currently not using an IC or transpiling CacheIR for these kinds.
      MOZ_CRASH("Unexpected kind");
  }

  return true;
}
