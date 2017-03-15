/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_IonBuilder_h
#define jit_IonBuilder_h

// This file declares the data structures for building a MIRGraph from a
// JSScript.

#include "mozilla/LinkedList.h"

#include "jit/BaselineInspector.h"
#include "jit/BytecodeAnalysis.h"
#include "jit/IonAnalysis.h"
#include "jit/IonOptimizationLevels.h"
#include "jit/MIR.h"
#include "jit/MIRGenerator.h"
#include "jit/MIRGraph.h"
#include "jit/OptimizationTracking.h"

namespace js {
namespace jit {

class CodeGenerator;
class CallInfo;
class BaselineFrameInspector;

enum class InlinableNative : uint16_t;

// Records information about a baseline frame for compilation that is stable
// when later used off thread.
BaselineFrameInspector*
NewBaselineFrameInspector(TempAllocator* temp, BaselineFrame* frame, CompileInfo* info);

class IonBuilder
  : public MIRGenerator,
    public mozilla::LinkedListElement<IonBuilder>
{
    enum ControlStatus {
        ControlStatus_Error,
        ControlStatus_Abort,
        ControlStatus_Ended,        // There is no continuation/join point.
        ControlStatus_Joined,       // Created a join node.
        ControlStatus_Jumped,       // Parsing another branch at the same level.
        ControlStatus_None          // No control flow.
    };

    struct DeferredEdge : public TempObject
    {
        MBasicBlock* block;
        DeferredEdge* next;

        DeferredEdge(MBasicBlock* block, DeferredEdge* next)
          : block(block), next(next)
        { }
    };

    struct ControlFlowInfo {
        // Entry in the cfgStack.
        uint32_t cfgEntry;

        // Label that continues go to.
        jsbytecode* continuepc;

        ControlFlowInfo(uint32_t cfgEntry, jsbytecode* continuepc)
          : cfgEntry(cfgEntry),
            continuepc(continuepc)
        { }
    };

    // To avoid recursion, the bytecode analyzer uses a stack where each entry
    // is a small state machine. As we encounter branches or jumps in the
    // bytecode, we push information about the edges on the stack so that the
    // CFG can be built in a tree-like fashion.
    struct CFGState {
        enum State {
            IF_TRUE,            // if() { }, no else.
            IF_TRUE_EMPTY_ELSE, // if() { }, empty else
            IF_ELSE_TRUE,       // if() { X } else { }
            IF_ELSE_FALSE,      // if() { } else { X }
            DO_WHILE_LOOP_BODY, // do { x } while ()
            DO_WHILE_LOOP_COND, // do { } while (x)
            WHILE_LOOP_COND,    // while (x) { }
            WHILE_LOOP_BODY,    // while () { x }
            FOR_LOOP_COND,      // for (; x;) { }
            FOR_LOOP_BODY,      // for (; ;) { x }
            FOR_LOOP_UPDATE,    // for (; ; x) { }
            TABLE_SWITCH,       // switch() { x }
            COND_SWITCH_CASE,   // switch() { case X: ... }
            COND_SWITCH_BODY,   // switch() { case ...: X }
            AND_OR,             // && x, || x
            LABEL,              // label: x
            TRY                 // try { x } catch(e) { }
        };

        State state;            // Current state of this control structure.
        jsbytecode* stopAt;     // Bytecode at which to stop the processing loop.

        // For if structures, this contains branch information.
        union {
            struct {
                MBasicBlock* ifFalse;
                jsbytecode* falseEnd;
                MBasicBlock* ifTrue;    // Set when the end of the true path is reached.
                MTest* test;
            } branch;
            struct {
                // Common entry point.
                MBasicBlock* entry;

                // Whether OSR is being performed for this loop.
                bool osr;

                // Position of where the loop body starts and ends.
                jsbytecode* bodyStart;
                jsbytecode* bodyEnd;

                // pc immediately after the loop exits.
                jsbytecode* exitpc;

                // pc for 'continue' jumps.
                jsbytecode* continuepc;

                // Common exit point. Created lazily, so it may be nullptr.
                MBasicBlock* successor;

                // Deferred break and continue targets.
                DeferredEdge* breaks;
                DeferredEdge* continues;

                // Initial state, in case loop processing is restarted.
                State initialState;
                jsbytecode* initialPc;
                jsbytecode* initialStopAt;
                jsbytecode* loopHead;

                // For-loops only.
                jsbytecode* condpc;
                jsbytecode* updatepc;
                jsbytecode* updateEnd;
            } loop;
            struct {
                // pc immediately after the switch.
                jsbytecode* exitpc;

                // Deferred break and continue targets.
                DeferredEdge* breaks;

                // MIR instruction
                MTableSwitch* ins;

                // The number of current successor that get mapped into a block.
                uint32_t currentBlock;

            } tableswitch;
            struct {
                // Vector of body blocks to process after the cases.
                FixedList<MBasicBlock*>* bodies;

                // When processing case statements, this counter points at the
                // last uninitialized body.  When processing bodies, this
                // counter targets the next body to process.
                uint32_t currentIdx;

                // Remember the block index of the default case.
                jsbytecode* defaultTarget;
                uint32_t defaultIdx;

                // Block immediately after the switch.
                jsbytecode* exitpc;
                DeferredEdge* breaks;
            } condswitch;
            struct {
                DeferredEdge* breaks;
            } label;
            struct {
                MBasicBlock* successor;
            } try_;
        };

        inline bool isLoop() const {
            switch (state) {
              case DO_WHILE_LOOP_COND:
              case DO_WHILE_LOOP_BODY:
              case WHILE_LOOP_COND:
              case WHILE_LOOP_BODY:
              case FOR_LOOP_COND:
              case FOR_LOOP_BODY:
              case FOR_LOOP_UPDATE:
                return true;
              default:
                return false;
            }
        }

        static CFGState If(jsbytecode* join, MTest* test);
        static CFGState IfElse(jsbytecode* trueEnd, jsbytecode* falseEnd, MTest* test);
        static CFGState AndOr(jsbytecode* join, MBasicBlock* lhs);
        static CFGState TableSwitch(jsbytecode* exitpc, MTableSwitch* ins);
        static CFGState CondSwitch(IonBuilder* builder, jsbytecode* exitpc, jsbytecode* defaultTarget);
        static CFGState Label(jsbytecode* exitpc);
        static CFGState Try(jsbytecode* exitpc, MBasicBlock* successor);
    };

    static int CmpSuccessors(const void* a, const void* b);

  public:
    IonBuilder(JSContext* analysisContext, CompileCompartment* comp,
               const JitCompileOptions& options, TempAllocator* temp,
               MIRGraph* graph, CompilerConstraintList* constraints,
               BaselineInspector* inspector, CompileInfo* info,
               const OptimizationInfo* optimizationInfo, BaselineFrameInspector* baselineFrame,
               size_t inliningDepth = 0, uint32_t loopDepth = 0);

    // Callers of build() and buildInline() should always check whether the
    // call overrecursed, if false is returned.  Overrecursion is not
    // signaled as OOM and will not in general be caught by OOM paths.
    MOZ_MUST_USE bool build();
    MOZ_MUST_USE bool buildInline(IonBuilder* callerBuilder, MResumePoint* callerResumePoint,
                                  CallInfo& callInfo);

  private:
    MOZ_MUST_USE bool traverseBytecode();
    ControlStatus snoopControlFlow(JSOp op);
    MOZ_MUST_USE bool processIterators();
    MOZ_MUST_USE bool inspectOpcode(JSOp op);
    uint32_t readIndex(jsbytecode* pc);
    JSAtom* readAtom(jsbytecode* pc);
    bool abort(const char* message, ...) MOZ_FORMAT_PRINTF(2, 3);
    void trackActionableAbort(const char* message);
    void spew(const char* message);

    JSFunction* getSingleCallTarget(TemporaryTypeSet* calleeTypes);
    MOZ_MUST_USE bool getPolyCallTargets(TemporaryTypeSet* calleeTypes, bool constructing,
                                         ObjectVector& targets, uint32_t maxTargets);

    void popCfgStack();
    DeferredEdge* filterDeadDeferredEdges(DeferredEdge* edge);
    MOZ_MUST_USE bool processDeferredContinues(CFGState& state);
    ControlStatus processControlEnd();
    ControlStatus processCfgStack();
    ControlStatus processCfgEntry(CFGState& state);
    ControlStatus processIfEnd(CFGState& state);
    ControlStatus processIfElseTrueEnd(CFGState& state);
    ControlStatus processIfElseFalseEnd(CFGState& state);
    ControlStatus processDoWhileBodyEnd(CFGState& state);
    ControlStatus processDoWhileCondEnd(CFGState& state);
    ControlStatus processWhileCondEnd(CFGState& state);
    ControlStatus processWhileBodyEnd(CFGState& state);
    ControlStatus processForCondEnd(CFGState& state);
    ControlStatus processForBodyEnd(CFGState& state);
    ControlStatus processForUpdateEnd(CFGState& state);
    ControlStatus processNextTableSwitchCase(CFGState& state);
    ControlStatus processCondSwitchCase(CFGState& state);
    ControlStatus processCondSwitchBody(CFGState& state);
    ControlStatus processSwitchBreak(JSOp op);
    ControlStatus processSwitchEnd(DeferredEdge* breaks, jsbytecode* exitpc);
    ControlStatus processAndOrEnd(CFGState& state);
    ControlStatus processLabelEnd(CFGState& state);
    ControlStatus processTryEnd(CFGState& state);
    ControlStatus processReturn(JSOp op);
    ControlStatus processThrow();
    ControlStatus processContinue(JSOp op);
    ControlStatus processBreak(JSOp op, jssrcnote* sn);
    ControlStatus maybeLoop(JSOp op, jssrcnote* sn);
    MOZ_MUST_USE bool pushLoop(CFGState::State state, jsbytecode* stopAt, MBasicBlock* entry,
                               bool osr, jsbytecode* loopHead, jsbytecode* initialPc,
                               jsbytecode* bodyStart, jsbytecode* bodyEnd,
                               jsbytecode* exitpc, jsbytecode* continuepc);
    MOZ_MUST_USE bool analyzeNewLoopTypes(MBasicBlock* entry, jsbytecode* start, jsbytecode* end);

    MBasicBlock* addBlock(MBasicBlock* block, uint32_t loopDepth);
    MBasicBlock* newBlock(MBasicBlock* predecessor, jsbytecode* pc);
    MBasicBlock* newBlock(MBasicBlock* predecessor, jsbytecode* pc, uint32_t loopDepth);
    MBasicBlock* newBlock(MBasicBlock* predecessor, jsbytecode* pc, MResumePoint* priorResumePoint);
    MBasicBlock* newBlockPopN(MBasicBlock* predecessor, jsbytecode* pc, uint32_t popped);
    MBasicBlock* newBlockAfter(MBasicBlock* at, MBasicBlock* predecessor, jsbytecode* pc);
    MBasicBlock* newOsrPreheader(MBasicBlock* header, jsbytecode* loopEntry,
                                 jsbytecode* beforeLoopEntry);
    MBasicBlock* newPendingLoopHeader(MBasicBlock* predecessor, jsbytecode* pc, bool osr, bool canOsr,
                                      unsigned stackPhiCount);
    MBasicBlock* newBlock(jsbytecode* pc) {
        return newBlock(nullptr, pc);
    }
    MBasicBlock* newBlockAfter(MBasicBlock* at, jsbytecode* pc) {
        return newBlockAfter(at, nullptr, pc);
    }

    // We want to make sure that our MTest instructions all check whether the
    // thing being tested might emulate undefined.  So we funnel their creation
    // through this method, to make sure that happens.  We don't want to just do
    // the check in MTest::New, because that can run on background compilation
    // threads, and we're not sure it's safe to touch that part of the typeset
    // from a background thread.
    MTest* newTest(MDefinition* ins, MBasicBlock* ifTrue, MBasicBlock* ifFalse);

    // Given a list of pending breaks, creates a new block and inserts a Goto
    // linking each break to the new block.
    MBasicBlock* createBreakCatchBlock(DeferredEdge* edge, jsbytecode* pc);

    // Finishes loops that do not actually loop, containing only breaks and
    // returns or a do while loop with a condition that is constant false.
    ControlStatus processBrokenLoop(CFGState& state);

    // Computes loop phis, places them in all successors of a loop, then
    // handles any pending breaks.
    ControlStatus finishLoop(CFGState& state, MBasicBlock* successor);

    // Incorporates a type/typeSet into an OSR value for a loop, after the loop
    // body has been processed.
    MOZ_MUST_USE bool addOsrValueTypeBarrier(uint32_t slot, MInstruction** def,
                                             MIRType type, TemporaryTypeSet* typeSet);
    MOZ_MUST_USE bool maybeAddOsrTypeBarriers();

    // Restarts processing of a loop if the type information at its header was
    // incomplete.
    ControlStatus restartLoop(const CFGState& state);

    void assertValidLoopHeadOp(jsbytecode* pc);

    ControlStatus forLoop(JSOp op, jssrcnote* sn);
    ControlStatus whileOrForInLoop(jssrcnote* sn);
    ControlStatus doWhileLoop(JSOp op, jssrcnote* sn);
    ControlStatus tableSwitch(JSOp op, jssrcnote* sn);
    ControlStatus condSwitch(JSOp op, jssrcnote* sn);

    // Please see the Big Honkin' Comment about how resume points work in
    // IonBuilder.cpp, near the definition for this function.
    MOZ_MUST_USE bool resume(MInstruction* ins, jsbytecode* pc, MResumePoint::Mode mode);
    MOZ_MUST_USE bool resumeAt(MInstruction* ins, jsbytecode* pc);
    MOZ_MUST_USE bool resumeAfter(MInstruction* ins);
    MOZ_MUST_USE bool maybeInsertResume();

    void insertRecompileCheck();

    MOZ_MUST_USE bool initParameters();
    void initLocals();
    void rewriteParameter(uint32_t slotIdx, MDefinition* param, int32_t argIndex);
    MOZ_MUST_USE bool rewriteParameters();
    MOZ_MUST_USE bool initEnvironmentChain(MDefinition* callee = nullptr);
    MOZ_MUST_USE bool initArgumentsObject();
    void pushConstant(const Value& v);

    MConstant* constant(const Value& v);
    MConstant* constantInt(int32_t i);
    MInstruction* initializedLength(MDefinition* obj, MDefinition* elements,
                                    JSValueType unboxedType);
    MInstruction* setInitializedLength(MDefinition* obj, JSValueType unboxedType, size_t count);

    // Improve the type information at tests
    MOZ_MUST_USE bool improveTypesAtTest(MDefinition* ins, bool trueBranch, MTest* test);
    MOZ_MUST_USE bool improveTypesAtCompare(MCompare* ins, bool trueBranch, MTest* test);
    MOZ_MUST_USE bool improveTypesAtNullOrUndefinedCompare(MCompare* ins, bool trueBranch,
                                                           MTest* test);
    MOZ_MUST_USE bool improveTypesAtTypeOfCompare(MCompare* ins, bool trueBranch, MTest* test);

    // Used to detect triangular structure at test.
    MOZ_MUST_USE bool detectAndOrStructure(MPhi* ins, bool* branchIsTrue);
    MOZ_MUST_USE bool replaceTypeSet(MDefinition* subject, TemporaryTypeSet* type, MTest* test);

    // Add a guard which ensure that the set of type which goes through this
    // generated code correspond to the observed types for the bytecode.
    MDefinition* addTypeBarrier(MDefinition* def, TemporaryTypeSet* observed,
                                BarrierKind kind, MTypeBarrier** pbarrier = nullptr);
    MOZ_MUST_USE bool pushTypeBarrier(MDefinition* def, TemporaryTypeSet* observed,
                                      BarrierKind kind);

    // As pushTypeBarrier, but will compute the needBarrier boolean itself based
    // on observed and the JSFunction that we're planning to call. The
    // JSFunction must be a DOM method or getter.
    MOZ_MUST_USE bool pushDOMTypeBarrier(MInstruction* ins, TemporaryTypeSet* observed,
                                         JSFunction* func);

    // If definiteType is not known or def already has the right type, just
    // returns def.  Otherwise, returns an MInstruction that has that definite
    // type, infallibly unboxing ins as needed.  The new instruction will be
    // added to |current| in this case.
    MDefinition* ensureDefiniteType(MDefinition* def, MIRType definiteType);

    // Creates a MDefinition based on the given def improved with type as TypeSet.
    MDefinition* ensureDefiniteTypeSet(MDefinition* def, TemporaryTypeSet* types);

    void maybeMarkEmpty(MDefinition* ins);

    JSObject* getSingletonPrototype(JSFunction* target);

    MDefinition* createThisScripted(MDefinition* callee, MDefinition* newTarget);
    MDefinition* createThisScriptedSingleton(JSFunction* target, MDefinition* callee);
    MDefinition* createThisScriptedBaseline(MDefinition* callee);
    MDefinition* createThis(JSFunction* target, MDefinition* callee, MDefinition* newTarget);
    MInstruction* createNamedLambdaObject(MDefinition* callee, MDefinition* envObj);
    MInstruction* createCallObject(MDefinition* callee, MDefinition* envObj);

    MDefinition* walkEnvironmentChain(unsigned hops);

    MInstruction* addConvertElementsToDoubles(MDefinition* elements);
    MDefinition* addMaybeCopyElementsForWrite(MDefinition* object, bool checkNative);
    MInstruction* addBoundsCheck(MDefinition* index, MDefinition* length);
    MInstruction* addShapeGuard(MDefinition* obj, Shape* const shape, BailoutKind bailoutKind);
    MInstruction* addGroupGuard(MDefinition* obj, ObjectGroup* group, BailoutKind bailoutKind);
    MInstruction* addUnboxedExpandoGuard(MDefinition* obj, bool hasExpando, BailoutKind bailoutKind);
    MInstruction* addSharedTypedArrayGuard(MDefinition* obj);

    MInstruction*
    addGuardReceiverPolymorphic(MDefinition* obj, const BaselineInspector::ReceiverVector& receivers);

    MDefinition* convertShiftToMaskForStaticTypedArray(MDefinition* id,
                                                       Scalar::Type viewType);

    bool invalidatedIdempotentCache();

    bool hasStaticEnvironmentObject(EnvironmentCoordinate ec, JSObject** pcall);
    MOZ_MUST_USE bool loadSlot(MDefinition* obj, size_t slot, size_t nfixed, MIRType rvalType,
                               BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool loadSlot(MDefinition* obj, Shape* shape, MIRType rvalType,
                               BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool storeSlot(MDefinition* obj, size_t slot, size_t nfixed, MDefinition* value,
                                bool needsBarrier, MIRType slotType = MIRType::None);
    MOZ_MUST_USE bool storeSlot(MDefinition* obj, Shape* shape, MDefinition* value,
                                bool needsBarrier, MIRType slotType = MIRType::None);
    bool shouldAbortOnPreliminaryGroups(MDefinition *obj);

    MDefinition* tryInnerizeWindow(MDefinition* obj);
    MDefinition* maybeUnboxForPropertyAccess(MDefinition* def);

    // jsop_getprop() helpers.
    MOZ_MUST_USE bool checkIsDefinitelyOptimizedArguments(MDefinition* obj, bool* isOptimizedArgs);
    MOZ_MUST_USE bool getPropTryInferredConstant(bool* emitted, MDefinition* obj,
                                                 PropertyName* name, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryArgumentsLength(bool* emitted, MDefinition* obj);
    MOZ_MUST_USE bool getPropTryArgumentsCallee(bool* emitted, MDefinition* obj,
                                                PropertyName* name);
    MOZ_MUST_USE bool getPropTryConstant(bool* emitted, MDefinition* obj, jsid id,
                                         TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryNotDefined(bool* emitted, MDefinition* obj, jsid id,
                                           TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryDefiniteSlot(bool* emitted, MDefinition* obj, PropertyName* name,
                                             BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryModuleNamespace(bool* emitted, MDefinition* obj, PropertyName* name,
                                                BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryUnboxed(bool* emitted, MDefinition* obj, PropertyName* name,
                                        BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryCommonGetter(bool* emitted, MDefinition* obj, PropertyName* name,
                                             TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryInlineAccess(bool* emitted, MDefinition* obj, PropertyName* name,
                                             BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryTypedObject(bool* emitted, MDefinition* obj, PropertyName* name);
    MOZ_MUST_USE bool getPropTryScalarPropOfTypedObject(bool* emitted, MDefinition* typedObj,
                                                        int32_t fieldOffset,
                                                        TypedObjectPrediction fieldTypeReprs);
    MOZ_MUST_USE bool getPropTryReferencePropOfTypedObject(bool* emitted, MDefinition* typedObj,
                                                           int32_t fieldOffset,
                                                           TypedObjectPrediction fieldPrediction,
                                                           PropertyName* name);
    MOZ_MUST_USE bool getPropTryComplexPropOfTypedObject(bool* emitted, MDefinition* typedObj,
                                                         int32_t fieldOffset,
                                                         TypedObjectPrediction fieldTypeReprs,
                                                         size_t fieldIndex);
    MOZ_MUST_USE bool getPropTryInnerize(bool* emitted, MDefinition* obj, PropertyName* name,
                                         TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTryCache(bool* emitted, MDefinition* obj, PropertyName* name,
                                      BarrierKind barrier, TemporaryTypeSet* types);
    MOZ_MUST_USE bool getPropTrySharedStub(bool* emitted, MDefinition* obj,
                                           TemporaryTypeSet* types);

    // jsop_setprop() helpers.
    MOZ_MUST_USE bool setPropTryCommonSetter(bool* emitted, MDefinition* obj,
                                             PropertyName* name, MDefinition* value);
    MOZ_MUST_USE bool setPropTryCommonDOMSetter(bool* emitted, MDefinition* obj,
                                                MDefinition* value, JSFunction* setter,
                                                TemporaryTypeSet* objTypes);
    MOZ_MUST_USE bool setPropTryDefiniteSlot(bool* emitted, MDefinition* obj,
                                             PropertyName* name, MDefinition* value,
                                             bool barrier, TemporaryTypeSet* objTypes);
    MOZ_MUST_USE bool setPropTryUnboxed(bool* emitted, MDefinition* obj,
                                        PropertyName* name, MDefinition* value,
                                        bool barrier, TemporaryTypeSet* objTypes);
    MOZ_MUST_USE bool setPropTryInlineAccess(bool* emitted, MDefinition* obj,
                                             PropertyName* name, MDefinition* value,
                                             bool barrier, TemporaryTypeSet* objTypes);
    MOZ_MUST_USE bool setPropTryTypedObject(bool* emitted, MDefinition* obj,
                                            PropertyName* name, MDefinition* value);
    MOZ_MUST_USE bool setPropTryReferencePropOfTypedObject(bool* emitted, MDefinition* obj,
                                                           int32_t fieldOffset, MDefinition* value,
                                                           TypedObjectPrediction fieldPrediction,
                                                           PropertyName* name);
    MOZ_MUST_USE bool setPropTryScalarPropOfTypedObject(bool* emitted,
                                                        MDefinition* obj,
                                                        int32_t fieldOffset,
                                                        MDefinition* value,
                                                        TypedObjectPrediction fieldTypeReprs);
    MOZ_MUST_USE bool setPropTryCache(bool* emitted, MDefinition* obj,
                                      PropertyName* name, MDefinition* value,
                                      bool barrier, TemporaryTypeSet* objTypes);

    // jsop_binary_arith helpers.
    MBinaryArithInstruction* binaryArithInstruction(JSOp op, MDefinition* left, MDefinition* right);
    MOZ_MUST_USE bool binaryArithTryConcat(bool* emitted, JSOp op, MDefinition* left,
                                           MDefinition* right);
    MOZ_MUST_USE bool binaryArithTrySpecialized(bool* emitted, JSOp op, MDefinition* left,
                                                MDefinition* right);
    MOZ_MUST_USE bool binaryArithTrySpecializedOnBaselineInspector(bool* emitted, JSOp op,
                                                                   MDefinition* left,
                                                                   MDefinition* right);
    MOZ_MUST_USE bool arithTrySharedStub(bool* emitted, JSOp op, MDefinition* left,
                                         MDefinition* right);

    // jsop_bitnot helpers.
    MOZ_MUST_USE bool bitnotTrySpecialized(bool* emitted, MDefinition* input);

    // jsop_pow helpers.
    MOZ_MUST_USE bool powTrySpecialized(bool* emitted, MDefinition* base, MDefinition* power,
                                        MIRType outputType);

    // jsop_compare helpers.
    MOZ_MUST_USE bool compareTrySpecialized(bool* emitted, JSOp op, MDefinition* left,
                                            MDefinition* right);
    MOZ_MUST_USE bool compareTryBitwise(bool* emitted, JSOp op, MDefinition* left,
                                        MDefinition* right);
    MOZ_MUST_USE bool compareTrySpecializedOnBaselineInspector(bool* emitted, JSOp op,
                                                               MDefinition* left,
                                                               MDefinition* right);
    MOZ_MUST_USE bool compareTrySharedStub(bool* emitted, JSOp op, MDefinition* left,
                                           MDefinition* right);

    // jsop_newarray helpers.
    MOZ_MUST_USE bool newArrayTrySharedStub(bool* emitted);
    MOZ_MUST_USE bool newArrayTryTemplateObject(bool* emitted, JSObject* templateObject,
                                                uint32_t length);
    MOZ_MUST_USE bool newArrayTryVM(bool* emitted, JSObject* templateObject, uint32_t length);

    // jsop_newobject helpers.
    MOZ_MUST_USE bool newObjectTrySharedStub(bool* emitted);
    MOZ_MUST_USE bool newObjectTryTemplateObject(bool* emitted, JSObject* templateObject);
    MOZ_MUST_USE bool newObjectTryVM(bool* emitted, JSObject* templateObject);

    // jsop_in helpers.
    MOZ_MUST_USE bool inTryDense(bool* emitted, MDefinition* obj, MDefinition* id);
    MOZ_MUST_USE bool inTryFold(bool* emitted, MDefinition* obj, MDefinition* id);

    // binary data lookup helpers.
    TypedObjectPrediction typedObjectPrediction(MDefinition* typedObj);
    TypedObjectPrediction typedObjectPrediction(TemporaryTypeSet* types);
    MOZ_MUST_USE bool typedObjectHasField(MDefinition* typedObj,
                                          PropertyName* name,
                                          size_t* fieldOffset,
                                          TypedObjectPrediction* fieldTypeReprs,
                                          size_t* fieldIndex);
    MDefinition* loadTypedObjectType(MDefinition* value);
    void loadTypedObjectData(MDefinition* typedObj,
                             MDefinition** owner,
                             LinearSum* ownerOffset);
    void loadTypedObjectElements(MDefinition* typedObj,
                                 const LinearSum& byteOffset,
                                 uint32_t scale,
                                 MDefinition** ownerElements,
                                 MDefinition** ownerScaledOffset,
                                 int32_t* ownerByteAdjustment);
    MDefinition* typeObjectForElementFromArrayStructType(MDefinition* typedObj);
    MDefinition* typeObjectForFieldFromStructType(MDefinition* type,
                                                  size_t fieldIndex);
    MOZ_MUST_USE bool storeReferenceTypedObjectValue(MDefinition* typedObj,
                                                     const LinearSum& byteOffset,
                                                     ReferenceTypeDescr::Type type,
                                                     MDefinition* value,
                                                     PropertyName* name);
    MOZ_MUST_USE bool storeScalarTypedObjectValue(MDefinition* typedObj,
                                                  const LinearSum& byteOffset,
                                                  ScalarTypeDescr::Type type,
                                                  MDefinition* value);
    MOZ_MUST_USE bool checkTypedObjectIndexInBounds(uint32_t elemSize,
                                                    MDefinition* obj,
                                                    MDefinition* index,
                                                    TypedObjectPrediction objTypeDescrs,
                                                    LinearSum* indexAsByteOffset);
    MOZ_MUST_USE bool pushDerivedTypedObject(bool* emitted,
                                             MDefinition* obj,
                                             const LinearSum& byteOffset,
                                             TypedObjectPrediction derivedTypeDescrs,
                                             MDefinition* derivedTypeObj);
    MOZ_MUST_USE bool pushScalarLoadFromTypedObject(MDefinition* obj,
                                                    const LinearSum& byteoffset,
                                                    ScalarTypeDescr::Type type);
    MOZ_MUST_USE bool pushReferenceLoadFromTypedObject(MDefinition* typedObj,
                                                       const LinearSum& byteOffset,
                                                       ReferenceTypeDescr::Type type,
                                                       PropertyName* name);
    JSObject* getStaticTypedArrayObject(MDefinition* obj, MDefinition* index);

    // jsop_setelem() helpers.
    MOZ_MUST_USE bool setElemTryTypedArray(bool* emitted, MDefinition* object,
                                           MDefinition* index, MDefinition* value);
    MOZ_MUST_USE bool setElemTryTypedObject(bool* emitted, MDefinition* obj,
                                            MDefinition* index, MDefinition* value);
    MOZ_MUST_USE bool setElemTryTypedStatic(bool* emitted, MDefinition* object,
                                            MDefinition* index, MDefinition* value);
    MOZ_MUST_USE bool setElemTryDense(bool* emitted, MDefinition* object,
                                      MDefinition* index, MDefinition* value, bool writeHole);
    MOZ_MUST_USE bool setElemTryArguments(bool* emitted, MDefinition* object,
                                          MDefinition* index, MDefinition* value);
    MOZ_MUST_USE bool setElemTryCache(bool* emitted, MDefinition* object,
                                      MDefinition* index, MDefinition* value);
    MOZ_MUST_USE bool setElemTryReferenceElemOfTypedObject(bool* emitted,
                                                           MDefinition* obj,
                                                           MDefinition* index,
                                                           TypedObjectPrediction objPrediction,
                                                           MDefinition* value,
                                                           TypedObjectPrediction elemPrediction);
    MOZ_MUST_USE bool setElemTryScalarElemOfTypedObject(bool* emitted,
                                                        MDefinition* obj,
                                                        MDefinition* index,
                                                        TypedObjectPrediction objTypeReprs,
                                                        MDefinition* value,
                                                        TypedObjectPrediction elemTypeReprs,
                                                        uint32_t elemSize);
    MOZ_MUST_USE bool initializeArrayElement(MDefinition* obj, size_t index, MDefinition* value,
                                             JSValueType unboxedType,
                                             bool addResumePointAndIncrementInitializedLength);

    // jsop_getelem() helpers.
    MOZ_MUST_USE bool getElemTryDense(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryGetProp(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryTypedStatic(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryTypedArray(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryTypedObject(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryString(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryArguments(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryArgumentsInlined(bool* emitted, MDefinition* obj,
                                                 MDefinition* index);
    MOZ_MUST_USE bool getElemTryCache(bool* emitted, MDefinition* obj, MDefinition* index);
    MOZ_MUST_USE bool getElemTryScalarElemOfTypedObject(bool* emitted,
                                                        MDefinition* obj,
                                                        MDefinition* index,
                                                        TypedObjectPrediction objTypeReprs,
                                                        TypedObjectPrediction elemTypeReprs,
                                                        uint32_t elemSize);
    MOZ_MUST_USE bool getElemTryReferenceElemOfTypedObject(bool* emitted,
                                                           MDefinition* obj,
                                                           MDefinition* index,
                                                           TypedObjectPrediction objPrediction,
                                                           TypedObjectPrediction elemPrediction);
    MOZ_MUST_USE bool getElemTryComplexElemOfTypedObject(bool* emitted,
                                                         MDefinition* obj,
                                                         MDefinition* index,
                                                         TypedObjectPrediction objTypeReprs,
                                                         TypedObjectPrediction elemTypeReprs,
                                                         uint32_t elemSize);
    TemporaryTypeSet* computeHeapType(const TemporaryTypeSet* objTypes, const jsid id);

    enum BoundsChecking { DoBoundsCheck, SkipBoundsCheck };

    MInstruction* addArrayBufferByteLength(MDefinition* obj);

    // Add instructions to compute a typed array's length and data.  Also
    // optionally convert |*index| into a bounds-checked definition, if
    // requested.
    //
    // If you only need the array's length, use addTypedArrayLength below.
    void addTypedArrayLengthAndData(MDefinition* obj,
                                    BoundsChecking checking,
                                    MDefinition** index,
                                    MInstruction** length, MInstruction** elements);

    // Add an instruction to compute a typed array's length to the current
    // block.  If you also need the typed array's data, use the above method
    // instead.
    MInstruction* addTypedArrayLength(MDefinition* obj) {
        MInstruction* length;
        addTypedArrayLengthAndData(obj, SkipBoundsCheck, nullptr, &length, nullptr);
        return length;
    }

    MOZ_MUST_USE bool improveThisTypesForCall();

    MDefinition* getCallee();
    MDefinition* getAliasedVar(EnvironmentCoordinate ec);
    MDefinition* addLexicalCheck(MDefinition* input);

    MDefinition* convertToBoolean(MDefinition* input);

    MOZ_MUST_USE bool tryFoldInstanceOf(MDefinition* lhs, JSObject* protoObject);
    MOZ_MUST_USE bool hasOnProtoChain(TypeSet::ObjectKey* key, JSObject* protoObject,
                                      bool* hasOnProto);

    MOZ_MUST_USE bool jsop_add(MDefinition* left, MDefinition* right);
    MOZ_MUST_USE bool jsop_bitnot();
    MOZ_MUST_USE bool jsop_bitop(JSOp op);
    MOZ_MUST_USE bool jsop_binary_arith(JSOp op);
    MOZ_MUST_USE bool jsop_binary_arith(JSOp op, MDefinition* left, MDefinition* right);
    MOZ_MUST_USE bool jsop_pow();
    MOZ_MUST_USE bool jsop_pos();
    MOZ_MUST_USE bool jsop_neg();
    MOZ_MUST_USE bool jsop_tostring();
    MOZ_MUST_USE bool jsop_setarg(uint32_t arg);
    MOZ_MUST_USE bool jsop_defvar(uint32_t index);
    MOZ_MUST_USE bool jsop_deflexical(uint32_t index);
    MOZ_MUST_USE bool jsop_deffun(uint32_t index);
    MOZ_MUST_USE bool jsop_notearg();
    MOZ_MUST_USE bool jsop_throwsetconst();
    MOZ_MUST_USE bool jsop_checklexical();
    MOZ_MUST_USE bool jsop_checkaliasedlexical(EnvironmentCoordinate ec);
    MOZ_MUST_USE bool jsop_funcall(uint32_t argc);
    MOZ_MUST_USE bool jsop_funapply(uint32_t argc);
    MOZ_MUST_USE bool jsop_funapplyarguments(uint32_t argc);
    MOZ_MUST_USE bool jsop_funapplyarray(uint32_t argc);
    MOZ_MUST_USE bool jsop_call(uint32_t argc, bool constructing);
    MOZ_MUST_USE bool jsop_eval(uint32_t argc);
    MOZ_MUST_USE bool jsop_ifeq(JSOp op);
    MOZ_MUST_USE bool jsop_try();
    MOZ_MUST_USE bool jsop_label();
    MOZ_MUST_USE bool jsop_condswitch();
    MOZ_MUST_USE bool jsop_andor(JSOp op);
    MOZ_MUST_USE bool jsop_dup2();
    MOZ_MUST_USE bool jsop_loophead(jsbytecode* pc);
    MOZ_MUST_USE bool jsop_compare(JSOp op);
    MOZ_MUST_USE bool jsop_compare(JSOp op, MDefinition* left, MDefinition* right);
    MOZ_MUST_USE bool getStaticName(JSObject* staticObject, PropertyName* name, bool* psucceeded,
                                    MDefinition* lexicalCheck = nullptr);
    MOZ_MUST_USE bool loadStaticSlot(JSObject* staticObject, BarrierKind barrier,
                                     TemporaryTypeSet* types, uint32_t slot);
    MOZ_MUST_USE bool setStaticName(JSObject* staticObject, PropertyName* name);
    MOZ_MUST_USE bool jsop_getgname(PropertyName* name);
    MOZ_MUST_USE bool jsop_getname(PropertyName* name);
    MOZ_MUST_USE bool jsop_intrinsic(PropertyName* name);
    MOZ_MUST_USE bool jsop_getimport(PropertyName* name);
    MOZ_MUST_USE bool jsop_bindname(PropertyName* name);
    MOZ_MUST_USE bool jsop_bindvar();
    MOZ_MUST_USE bool jsop_getelem();
    MOZ_MUST_USE bool jsop_getelem_dense(MDefinition* obj, MDefinition* index,
                                         JSValueType unboxedType);
    MOZ_MUST_USE bool jsop_getelem_typed(MDefinition* obj, MDefinition* index,
                                         ScalarTypeDescr::Type arrayType);
    MOZ_MUST_USE bool jsop_setelem();
    MOZ_MUST_USE bool jsop_setelem_dense(TemporaryTypeSet::DoubleConversion conversion,
                                         MDefinition* object, MDefinition* index,
                                         MDefinition* value, JSValueType unboxedType,
                                         bool writeHole, bool* emitted);
    MOZ_MUST_USE bool jsop_setelem_typed(ScalarTypeDescr::Type arrayType,
                                         MDefinition* object, MDefinition* index,
                                         MDefinition* value);
    MOZ_MUST_USE bool jsop_length();
    MOZ_MUST_USE bool jsop_length_fastPath();
    MOZ_MUST_USE bool jsop_arguments();
    MOZ_MUST_USE bool jsop_arguments_getelem();
    MOZ_MUST_USE bool jsop_runonce();
    MOZ_MUST_USE bool jsop_rest();
    MOZ_MUST_USE bool jsop_not();
    MOZ_MUST_USE bool jsop_getprop(PropertyName* name);
    MOZ_MUST_USE bool jsop_setprop(PropertyName* name);
    MOZ_MUST_USE bool jsop_delprop(PropertyName* name);
    MOZ_MUST_USE bool jsop_delelem();
    MOZ_MUST_USE bool jsop_newarray(uint32_t length);
    MOZ_MUST_USE bool jsop_newarray(JSObject* templateObject, uint32_t length);
    MOZ_MUST_USE bool jsop_newarray_copyonwrite();
    MOZ_MUST_USE bool jsop_newobject();
    MOZ_MUST_USE bool jsop_initelem();
    MOZ_MUST_USE bool jsop_initelem_array();
    MOZ_MUST_USE bool jsop_initelem_getter_setter();
    MOZ_MUST_USE bool jsop_mutateproto();
    MOZ_MUST_USE bool jsop_initprop(PropertyName* name);
    MOZ_MUST_USE bool jsop_initprop_getter_setter(PropertyName* name);
    MOZ_MUST_USE bool jsop_regexp(RegExpObject* reobj);
    MOZ_MUST_USE bool jsop_object(JSObject* obj);
    MOZ_MUST_USE bool jsop_lambda(JSFunction* fun);
    MOZ_MUST_USE bool jsop_lambda_arrow(JSFunction* fun);
    MOZ_MUST_USE bool jsop_functionthis();
    MOZ_MUST_USE bool jsop_globalthis();
    MOZ_MUST_USE bool jsop_typeof();
    MOZ_MUST_USE bool jsop_toasync();
    MOZ_MUST_USE bool jsop_toid();
    MOZ_MUST_USE bool jsop_iter(uint8_t flags);
    MOZ_MUST_USE bool jsop_itermore();
    MOZ_MUST_USE bool jsop_isnoiter();
    MOZ_MUST_USE bool jsop_iterend();
    MOZ_MUST_USE bool jsop_in();
    MOZ_MUST_USE bool jsop_instanceof();
    MOZ_MUST_USE bool jsop_getaliasedvar(EnvironmentCoordinate ec);
    MOZ_MUST_USE bool jsop_setaliasedvar(EnvironmentCoordinate ec);
    MOZ_MUST_USE bool jsop_debugger();
    MOZ_MUST_USE bool jsop_newtarget();
    MOZ_MUST_USE bool jsop_checkisobj(uint8_t kind);
    MOZ_MUST_USE bool jsop_checkobjcoercible();
    MOZ_MUST_USE bool jsop_pushcallobj();

    /* Inlining. */

    enum InliningStatus
    {
        InliningStatus_Error,
        InliningStatus_NotInlined,
        InliningStatus_WarmUpCountTooLow,
        InliningStatus_Inlined
    };

    enum InliningDecision
    {
        InliningDecision_Error,
        InliningDecision_Inline,
        InliningDecision_DontInline,
        InliningDecision_WarmUpCountTooLow
    };

    static InliningDecision DontInline(JSScript* targetScript, const char* reason);

    // Helper function for canInlineTarget
    bool hasCommonInliningPath(const JSScript* scriptToInline);

    // Oracles.
    InliningDecision canInlineTarget(JSFunction* target, CallInfo& callInfo);
    InliningDecision makeInliningDecision(JSObject* target, CallInfo& callInfo);
    MOZ_MUST_USE bool selectInliningTargets(const ObjectVector& targets, CallInfo& callInfo,
                                            BoolVector& choiceSet, uint32_t* numInlineable);

    // Native inlining helpers.
    // The typeset for the return value of our function.  These are
    // the types it's been observed returning in the past.
    TemporaryTypeSet* getInlineReturnTypeSet();
    // The known MIR type of getInlineReturnTypeSet.
    MIRType getInlineReturnType();

    // Array natives.
    InliningStatus inlineArray(CallInfo& callInfo);
    InliningStatus inlineArrayIsArray(CallInfo& callInfo);
    InliningStatus inlineArrayPopShift(CallInfo& callInfo, MArrayPopShift::Mode mode);
    InliningStatus inlineArrayPush(CallInfo& callInfo);
    InliningStatus inlineArraySlice(CallInfo& callInfo);
    InliningStatus inlineArrayJoin(CallInfo& callInfo);
    InliningStatus inlineArraySplice(CallInfo& callInfo);

    // Math natives.
    InliningStatus inlineMathAbs(CallInfo& callInfo);
    InliningStatus inlineMathFloor(CallInfo& callInfo);
    InliningStatus inlineMathCeil(CallInfo& callInfo);
    InliningStatus inlineMathClz32(CallInfo& callInfo);
    InliningStatus inlineMathRound(CallInfo& callInfo);
    InliningStatus inlineMathSqrt(CallInfo& callInfo);
    InliningStatus inlineMathAtan2(CallInfo& callInfo);
    InliningStatus inlineMathHypot(CallInfo& callInfo);
    InliningStatus inlineMathMinMax(CallInfo& callInfo, bool max);
    InliningStatus inlineMathPow(CallInfo& callInfo);
    InliningStatus inlineMathRandom(CallInfo& callInfo);
    InliningStatus inlineMathImul(CallInfo& callInfo);
    InliningStatus inlineMathFRound(CallInfo& callInfo);
    InliningStatus inlineMathFunction(CallInfo& callInfo, MMathFunction::Function function);

    // String natives.
    InliningStatus inlineStringObject(CallInfo& callInfo);
    InliningStatus inlineStrCharCodeAt(CallInfo& callInfo);
    InliningStatus inlineConstantCharCodeAt(CallInfo& callInfo);
    InliningStatus inlineStrFromCharCode(CallInfo& callInfo);
    InliningStatus inlineStrFromCodePoint(CallInfo& callInfo);
    InliningStatus inlineStrCharAt(CallInfo& callInfo);

    // String intrinsics.
    InliningStatus inlineStringReplaceString(CallInfo& callInfo);
    InliningStatus inlineConstantStringSplitString(CallInfo& callInfo);
    InliningStatus inlineStringSplitString(CallInfo& callInfo);

    // RegExp intrinsics.
    InliningStatus inlineRegExpMatcher(CallInfo& callInfo);
    InliningStatus inlineRegExpSearcher(CallInfo& callInfo);
    InliningStatus inlineRegExpTester(CallInfo& callInfo);
    InliningStatus inlineIsRegExpObject(CallInfo& callInfo);
    InliningStatus inlineRegExpPrototypeOptimizable(CallInfo& callInfo);
    InliningStatus inlineRegExpInstanceOptimizable(CallInfo& callInfo);
    InliningStatus inlineGetFirstDollarIndex(CallInfo& callInfo);

    // Object natives and intrinsics.
    InliningStatus inlineObjectCreate(CallInfo& callInfo);
    InliningStatus inlineDefineDataProperty(CallInfo& callInfo);

    // Atomics natives.
    InliningStatus inlineAtomicsCompareExchange(CallInfo& callInfo);
    InliningStatus inlineAtomicsExchange(CallInfo& callInfo);
    InliningStatus inlineAtomicsLoad(CallInfo& callInfo);
    InliningStatus inlineAtomicsStore(CallInfo& callInfo);
    InliningStatus inlineAtomicsBinop(CallInfo& callInfo, InlinableNative target);
    InliningStatus inlineAtomicsIsLockFree(CallInfo& callInfo);

    // Slot intrinsics.
    InliningStatus inlineUnsafeSetReservedSlot(CallInfo& callInfo);
    InliningStatus inlineUnsafeGetReservedSlot(CallInfo& callInfo,
                                               MIRType knownValueType);

    // Map and Set intrinsics.
    InliningStatus inlineGetNextEntryForIterator(CallInfo& callInfo,
                                                 MGetNextEntryForIterator::Mode mode);

    // ArrayBuffer intrinsics.
    InliningStatus inlineArrayBufferByteLength(CallInfo& callInfo);
    InliningStatus inlinePossiblyWrappedArrayBufferByteLength(CallInfo& callInfo);

    // TypedArray intrinsics.
    enum WrappingBehavior { AllowWrappedTypedArrays, RejectWrappedTypedArrays };
    InliningStatus inlineTypedArray(CallInfo& callInfo, Native native);
    InliningStatus inlineIsTypedArrayHelper(CallInfo& callInfo, WrappingBehavior wrappingBehavior);
    InliningStatus inlineIsTypedArray(CallInfo& callInfo);
    InliningStatus inlineIsPossiblyWrappedTypedArray(CallInfo& callInfo);
    InliningStatus inlineTypedArrayLength(CallInfo& callInfo);
    InliningStatus inlinePossiblyWrappedTypedArrayLength(CallInfo& callInfo);
    InliningStatus inlineSetDisjointTypedElements(CallInfo& callInfo);

    // TypedObject intrinsics and natives.
    InliningStatus inlineObjectIsTypeDescr(CallInfo& callInfo);
    InliningStatus inlineSetTypedObjectOffset(CallInfo& callInfo);
    InliningStatus inlineConstructTypedObject(CallInfo& callInfo, TypeDescr* target);

    // SIMD intrinsics and natives.
    InliningStatus inlineConstructSimdObject(CallInfo& callInfo, SimdTypeDescr* target);

    // SIMD helpers.
    bool canInlineSimd(CallInfo& callInfo, JSNative native, unsigned numArgs,
                       InlineTypedObject** templateObj);
    MDefinition* unboxSimd(MDefinition* ins, SimdType type);
    IonBuilder::InliningStatus boxSimd(CallInfo& callInfo, MDefinition* ins,
                                       InlineTypedObject* templateObj);
    MDefinition* convertToBooleanSimdLane(MDefinition* scalar);

    InliningStatus inlineSimd(CallInfo& callInfo, JSFunction* target, SimdType type);

    InliningStatus inlineSimdBinaryArith(CallInfo& callInfo, JSNative native,
                                         MSimdBinaryArith::Operation op, SimdType type);
    InliningStatus inlineSimdBinaryBitwise(CallInfo& callInfo, JSNative native,
                                           MSimdBinaryBitwise::Operation op, SimdType type);
    InliningStatus inlineSimdBinarySaturating(CallInfo& callInfo, JSNative native,
                                              MSimdBinarySaturating::Operation op, SimdType type);
    InliningStatus inlineSimdShift(CallInfo& callInfo, JSNative native, MSimdShift::Operation op,
                                   SimdType type);
    InliningStatus inlineSimdComp(CallInfo& callInfo, JSNative native,
                                  MSimdBinaryComp::Operation op, SimdType type);
    InliningStatus inlineSimdUnary(CallInfo& callInfo, JSNative native,
                                   MSimdUnaryArith::Operation op, SimdType type);
    InliningStatus inlineSimdExtractLane(CallInfo& callInfo, JSNative native, SimdType type);
    InliningStatus inlineSimdReplaceLane(CallInfo& callInfo, JSNative native, SimdType type);
    InliningStatus inlineSimdSplat(CallInfo& callInfo, JSNative native, SimdType type);
    InliningStatus inlineSimdShuffle(CallInfo& callInfo, JSNative native, SimdType type,
                                     unsigned numVectors);
    InliningStatus inlineSimdCheck(CallInfo& callInfo, JSNative native, SimdType type);
    InliningStatus inlineSimdConvert(CallInfo& callInfo, JSNative native, bool isCast,
                                     SimdType from, SimdType to);
    InliningStatus inlineSimdSelect(CallInfo& callInfo, JSNative native, SimdType type);

    MOZ_MUST_USE bool prepareForSimdLoadStore(CallInfo& callInfo, Scalar::Type simdType,
                                              MInstruction** elements, MDefinition** index,
                                              Scalar::Type* arrayType);
    InliningStatus inlineSimdLoad(CallInfo& callInfo, JSNative native, SimdType type,
                                  unsigned numElems);
    InliningStatus inlineSimdStore(CallInfo& callInfo, JSNative native, SimdType type,
                                   unsigned numElems);

    InliningStatus inlineSimdAnyAllTrue(CallInfo& callInfo, bool IsAllTrue, JSNative native,
                                        SimdType type);

    // Utility intrinsics.
    InliningStatus inlineIsCallable(CallInfo& callInfo);
    InliningStatus inlineIsConstructor(CallInfo& callInfo);
    InliningStatus inlineIsObject(CallInfo& callInfo);
    InliningStatus inlineToObject(CallInfo& callInfo);
    InliningStatus inlineIsWrappedArrayConstructor(CallInfo& callInfo);
    InliningStatus inlineToInteger(CallInfo& callInfo);
    InliningStatus inlineToString(CallInfo& callInfo);
    InliningStatus inlineDump(CallInfo& callInfo);
    InliningStatus inlineHasClass(CallInfo& callInfo, const Class* clasp,
                                  const Class* clasp2 = nullptr,
                                  const Class* clasp3 = nullptr,
                                  const Class* clasp4 = nullptr);
    InliningStatus inlineIsConstructing(CallInfo& callInfo);
    InliningStatus inlineSubstringKernel(CallInfo& callInfo);
    InliningStatus inlineObjectHasPrototype(CallInfo& callInfo);

    // Testing functions.
    InliningStatus inlineBailout(CallInfo& callInfo);
    InliningStatus inlineAssertFloat32(CallInfo& callInfo);
    InliningStatus inlineAssertRecoveredOnBailout(CallInfo& callInfo);

    // Bind function.
    InliningStatus inlineBoundFunction(CallInfo& callInfo, JSFunction* target);

    // Main inlining functions
    InliningStatus inlineNativeCall(CallInfo& callInfo, JSFunction* target);
    InliningStatus inlineNativeGetter(CallInfo& callInfo, JSFunction* target);
    InliningStatus inlineNonFunctionCall(CallInfo& callInfo, JSObject* target);
    InliningStatus inlineScriptedCall(CallInfo& callInfo, JSFunction* target);
    InliningStatus inlineSingleCall(CallInfo& callInfo, JSObject* target);

    // Call functions
    InliningStatus inlineCallsite(const ObjectVector& targets, CallInfo& callInfo);
    MOZ_MUST_USE bool inlineCalls(CallInfo& callInfo, const ObjectVector& targets,
                                  BoolVector& choiceSet, MGetPropertyCache* maybeCache);

    // Inlining helpers.
    MOZ_MUST_USE bool inlineGenericFallback(JSFunction* target, CallInfo& callInfo,
                                            MBasicBlock* dispatchBlock);
    MOZ_MUST_USE bool inlineObjectGroupFallback(CallInfo& callInfo, MBasicBlock* dispatchBlock,
                                                MObjectGroupDispatch* dispatch,
                                                MGetPropertyCache* cache,
                                                MBasicBlock** fallbackTarget);

    enum AtomicCheckResult {
        DontCheckAtomicResult,
        DoCheckAtomicResult
    };

    MOZ_MUST_USE bool atomicsMeetsPreconditions(CallInfo& callInfo, Scalar::Type* arrayElementType,
                                                bool* requiresDynamicCheck,
                                                AtomicCheckResult checkResult=DoCheckAtomicResult);
    void atomicsCheckBounds(CallInfo& callInfo, MInstruction** elements, MDefinition** index);

    MOZ_MUST_USE bool testNeedsArgumentCheck(JSFunction* target, CallInfo& callInfo);

    MCall* makeCallHelper(JSFunction* target, CallInfo& callInfo);
    MOZ_MUST_USE bool makeCall(JSFunction* target, CallInfo& callInfo);

    MDefinition* patchInlinedReturn(CallInfo& callInfo, MBasicBlock* exit, MBasicBlock* bottom);
    MDefinition* patchInlinedReturns(CallInfo& callInfo, MIRGraphReturns& returns,
                                     MBasicBlock* bottom);
    MDefinition* specializeInlinedReturn(MDefinition* rdef, MBasicBlock* exit);

    MOZ_MUST_USE bool objectsHaveCommonPrototype(TemporaryTypeSet* types, PropertyName* name,
                                                 bool isGetter, JSObject* foundProto,
                                                 bool* guardGlobal);
    void freezePropertiesForCommonPrototype(TemporaryTypeSet* types, PropertyName* name,
                                            JSObject* foundProto, bool allowEmptyTypesForGlobal = false);
    /*
     * Callers must pass a non-null globalGuard if they pass a non-null globalShape.
     */
    MOZ_MUST_USE bool testCommonGetterSetter(TemporaryTypeSet* types, PropertyName* name,
                                             bool isGetter, JSObject* foundProto,
                                             Shape* lastProperty, JSFunction* getterOrSetter,
                                             MDefinition** guard, Shape* globalShape = nullptr,
                                             MDefinition** globalGuard = nullptr);
    MOZ_MUST_USE bool testShouldDOMCall(TypeSet* inTypes,
                                        JSFunction* func, JSJitInfo::OpType opType);

    MDefinition*
    addShapeGuardsForGetterSetter(MDefinition* obj, JSObject* holder, Shape* holderShape,
                                  const BaselineInspector::ReceiverVector& receivers,
                                  const BaselineInspector::ObjectGroupVector& convertUnboxedGroups,
                                  bool isOwnProperty);

    MOZ_MUST_USE bool annotateGetPropertyCache(MDefinition* obj, PropertyName* name,
                                               MGetPropertyCache* getPropCache,
                                               TemporaryTypeSet* objTypes,
                                               TemporaryTypeSet* pushedTypes);

    MGetPropertyCache* getInlineableGetPropertyCache(CallInfo& callInfo);

    JSObject* testGlobalLexicalBinding(PropertyName* name);

    JSObject* testSingletonProperty(JSObject* obj, jsid id);
    JSObject* testSingletonPropertyTypes(MDefinition* obj, jsid id);

    ResultWithOOM<bool> testNotDefinedProperty(MDefinition* obj, jsid id);

    uint32_t getDefiniteSlot(TemporaryTypeSet* types, PropertyName* name, uint32_t* pnfixed);
    MDefinition* convertUnboxedObjects(MDefinition* obj);
    MDefinition* convertUnboxedObjects(MDefinition* obj,
                                       const BaselineInspector::ObjectGroupVector& list);
    uint32_t getUnboxedOffset(TemporaryTypeSet* types, PropertyName* name,
                              JSValueType* punboxedType);
    MInstruction* loadUnboxedProperty(MDefinition* obj, size_t offset, JSValueType unboxedType,
                                      BarrierKind barrier, TemporaryTypeSet* types);
    MInstruction* loadUnboxedValue(MDefinition* elements, size_t elementsOffset,
                                   MDefinition* scaledOffset, JSValueType unboxedType,
                                   BarrierKind barrier, TemporaryTypeSet* types);
    MInstruction* storeUnboxedProperty(MDefinition* obj, size_t offset, JSValueType unboxedType,
                                       MDefinition* value);
    MInstruction* storeUnboxedValue(MDefinition* obj,
                                    MDefinition* elements, int32_t elementsOffset,
                                    MDefinition* scaledOffset, JSValueType unboxedType,
                                    MDefinition* value, bool preBarrier = true);
    MOZ_MUST_USE bool checkPreliminaryGroups(MDefinition *obj);
    MOZ_MUST_USE bool freezePropTypeSets(TemporaryTypeSet* types,
                                         JSObject* foundProto, PropertyName* name);
    bool canInlinePropertyOpShapes(const BaselineInspector::ReceiverVector& receivers);

    TemporaryTypeSet* bytecodeTypes(jsbytecode* pc);

    // Use one of the below methods for updating the current block, rather than
    // updating |current| directly. setCurrent() should only be used in cases
    // where the block cannot have phis whose type needs to be computed.

    MOZ_MUST_USE bool setCurrentAndSpecializePhis(MBasicBlock* block) {
        if (block) {
            if (!block->specializePhis(alloc()))
                return false;
        }
        setCurrent(block);
        return true;
    }

    void setCurrent(MBasicBlock* block) {
        current = block;
    }

    // A builder is inextricably tied to a particular script.
    JSScript* script_;

    // script->hasIonScript() at the start of the compilation. Used to avoid
    // calling hasIonScript() from background compilation threads.
    bool scriptHasIonScript_;

    // If off thread compilation is successful, the final code generator is
    // attached here. Code has been generated, but not linked (there is not yet
    // an IonScript). This is heap allocated, and must be explicitly destroyed,
    // performed by FinishOffThreadBuilder().
    CodeGenerator* backgroundCodegen_;

    // Some aborts are actionable (e.g., using an unsupported bytecode). When
    // optimization tracking is enabled, the location and message of the abort
    // are recorded here so they may be propagated to the script's
    // corresponding JitcodeGlobalEntry::BaselineEntry.
    JSScript* actionableAbortScript_;
    jsbytecode* actionableAbortPc_;
    const char* actionableAbortMessage_;

    MRootList* rootList_;

  public:
    void setRootList(MRootList& rootList) {
        MOZ_ASSERT(!rootList_);
        rootList_ = &rootList;
    }
    void clearForBackEnd();
    JSObject* checkNurseryObject(JSObject* obj);

    JSScript* script() const { return script_; }
    bool scriptHasIonScript() const { return scriptHasIonScript_; }

    CodeGenerator* backgroundCodegen() const { return backgroundCodegen_; }
    void setBackgroundCodegen(CodeGenerator* codegen) { backgroundCodegen_ = codegen; }

    CompilerConstraintList* constraints() {
        return constraints_;
    }

    bool isInlineBuilder() const {
        return callerBuilder_ != nullptr;
    }

    const JSAtomState& names() { return compartment->runtime()->names(); }

    bool hadActionableAbort() const {
        MOZ_ASSERT(!actionableAbortScript_ ||
                   (actionableAbortPc_ && actionableAbortMessage_));
        return actionableAbortScript_ != nullptr;
    }

    TraceLoggerThread *traceLogger() {
        // Currently ionbuilder only runs on the main thread.
        return TraceLoggerForMainThread(compartment->runtime()->mainThread()->runtimeFromMainThread());
    }

    void actionableAbortLocationAndMessage(JSScript** abortScript, jsbytecode** abortPc,
                                           const char** abortMessage)
    {
        MOZ_ASSERT(hadActionableAbort());
        *abortScript = actionableAbortScript_;
        *abortPc = actionableAbortPc_;
        *abortMessage = actionableAbortMessage_;
    }

    void trace(JSTracer* trc);

  private:
    MOZ_MUST_USE bool init();

    JSContext* analysisContext;
    BaselineFrameInspector* baselineFrame_;

    // Constraints for recording dependencies on type information.
    CompilerConstraintList* constraints_;

    // Basic analysis information about the script.
    BytecodeAnalysis analysis_;
    BytecodeAnalysis& analysis() {
        return analysis_;
    }

    TemporaryTypeSet* thisTypes;
    TemporaryTypeSet* argTypes;
    TemporaryTypeSet* typeArray;
    uint32_t typeArrayHint;
    uint32_t* bytecodeTypeMap;

    GSNCache gsn;
    EnvironmentCoordinateNameCache envCoordinateNameCache;

    jsbytecode* pc;
    MBasicBlock* current;
    uint32_t loopDepth_;

    Vector<BytecodeSite*, 0, JitAllocPolicy> trackedOptimizationSites_;

    BytecodeSite* bytecodeSite(jsbytecode* pc) {
        MOZ_ASSERT(info().inlineScriptTree()->script()->containsPC(pc));
        // See comment in maybeTrackedOptimizationSite.
        if (isOptimizationTrackingEnabled()) {
            if (BytecodeSite* site = maybeTrackedOptimizationSite(pc))
                return site;
        }
        return new(alloc()) BytecodeSite(info().inlineScriptTree(), pc);
    }

    BytecodeSite* maybeTrackedOptimizationSite(jsbytecode* pc);

    MDefinition* lexicalCheck_;

    void setLexicalCheck(MDefinition* lexical) {
        MOZ_ASSERT(!lexicalCheck_);
        lexicalCheck_ = lexical;
    }
    MDefinition* takeLexicalCheck() {
        MDefinition* lexical = lexicalCheck_;
        lexicalCheck_ = nullptr;
        return lexical;
    }

    /* Information used for inline-call builders. */
    MResumePoint* callerResumePoint_;
    jsbytecode* callerPC() {
        return callerResumePoint_ ? callerResumePoint_->pc() : nullptr;
    }
    IonBuilder* callerBuilder_;

    IonBuilder* outermostBuilder();

    struct LoopHeader {
        jsbytecode* pc;
        MBasicBlock* header;

        LoopHeader(jsbytecode* pc, MBasicBlock* header)
          : pc(pc), header(header)
        {}
    };

    Vector<CFGState, 8, JitAllocPolicy> cfgStack_;
    Vector<ControlFlowInfo, 4, JitAllocPolicy> loops_;
    Vector<ControlFlowInfo, 0, JitAllocPolicy> switches_;
    Vector<ControlFlowInfo, 2, JitAllocPolicy> labels_;
    Vector<MInstruction*, 2, JitAllocPolicy> iterators_;
    Vector<LoopHeader, 0, JitAllocPolicy> loopHeaders_;
    BaselineInspector* inspector;

    size_t inliningDepth_;

    // Total bytecode length of all inlined scripts. Only tracked for the
    // outermost builder.
    size_t inlinedBytecodeLength_;

    // Cutoff to disable compilation if excessive time is spent reanalyzing
    // loop bodies to compute a fixpoint of the types for loop variables.
    static const size_t MAX_LOOP_RESTARTS = 40;
    size_t numLoopRestarts_;

    // True if script->failedBoundsCheck is set for the current script or
    // an outer script.
    bool failedBoundsCheck_;

    // True if script->failedShapeGuard is set for the current script or
    // an outer script.
    bool failedShapeGuard_;

    // True if script->failedLexicalCheck_ is set for the current script or
    // an outer script.
    bool failedLexicalCheck_;

    // Has an iterator other than 'for in'.
    bool nonStringIteration_;

    // If this script can use a lazy arguments object, it will be pre-created
    // here.
    MInstruction* lazyArguments_;

    // If this is an inline builder, the call info for the builder.
    const CallInfo* inlineCallInfo_;

    // When compiling a call with multiple targets, we are first creating a
    // MGetPropertyCache.  This MGetPropertyCache is following the bytecode, and
    // is used to recover the JSFunction.  In some cases, the Type of the object
    // which own the property is enough for dispatching to the right function.
    // In such cases we do not have read the property, except when the type
    // object is unknown.
    //
    // As an optimization, we can dispatch a call based on the object group,
    // without doing the MGetPropertyCache.  This is what is achieved by
    // |IonBuilder::inlineCalls|.  As we might not know all the functions, we
    // are adding a fallback path, where this MGetPropertyCache would be moved
    // into.
    //
    // In order to build the fallback path, we have to capture a resume point
    // ahead, for the potential fallback path.  This resume point is captured
    // while building MGetPropertyCache.  It is capturing the state of Baseline
    // before the execution of the MGetPropertyCache, such as we can safely do
    // it in the fallback path.
    //
    // This field is used to discard the resume point if it is not used for
    // building a fallback path.

    // Discard the prior resume point while setting a new MGetPropertyCache.
    void replaceMaybeFallbackFunctionGetter(MGetPropertyCache* cache);

    // Discard the MGetPropertyCache if it is handled by WrapMGetPropertyCache.
    void keepFallbackFunctionGetter(MGetPropertyCache* cache) {
        if (cache == maybeFallbackFunctionGetter_)
            maybeFallbackFunctionGetter_ = nullptr;
    }

    MGetPropertyCache* maybeFallbackFunctionGetter_;

    // Used in tracking outcomes of optimization strategies for devtools.
    void startTrackingOptimizations();

    // The track* methods below are called often. Do not combine them with the
    // unchecked variants, despite the unchecked variants having no other
    // callers.
    void trackTypeInfo(JS::TrackedTypeSite site, MIRType mirType,
                       TemporaryTypeSet* typeSet)
    {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackTypeInfoUnchecked(site, mirType, typeSet);
    }
    void trackTypeInfo(JS::TrackedTypeSite site, JSObject* obj) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackTypeInfoUnchecked(site, obj);
    }
    void trackTypeInfo(CallInfo& callInfo) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackTypeInfoUnchecked(callInfo);
    }
    void trackOptimizationAttempt(JS::TrackedStrategy strategy) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackOptimizationAttemptUnchecked(strategy);
    }
    void amendOptimizationAttempt(uint32_t index) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            amendOptimizationAttemptUnchecked(index);
    }
    void trackOptimizationOutcome(JS::TrackedOutcome outcome) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackOptimizationOutcomeUnchecked(outcome);
    }
    void trackOptimizationSuccess() {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackOptimizationSuccessUnchecked();
    }
    void trackInlineSuccess(InliningStatus status = InliningStatus_Inlined) {
        if (MOZ_UNLIKELY(current->trackedSite()->hasOptimizations()))
            trackInlineSuccessUnchecked(status);
    }

    bool forceInlineCaches() {
        return MOZ_UNLIKELY(JitOptions.forceInlineCaches);
    }

    // Out-of-line variants that don't check if optimization tracking is
    // enabled.
    void trackTypeInfoUnchecked(JS::TrackedTypeSite site, MIRType mirType,
                                TemporaryTypeSet* typeSet);
    void trackTypeInfoUnchecked(JS::TrackedTypeSite site, JSObject* obj);
    void trackTypeInfoUnchecked(CallInfo& callInfo);
    void trackOptimizationAttemptUnchecked(JS::TrackedStrategy strategy);
    void amendOptimizationAttemptUnchecked(uint32_t index);
    void trackOptimizationOutcomeUnchecked(JS::TrackedOutcome outcome);
    void trackOptimizationSuccessUnchecked();
    void trackInlineSuccessUnchecked(InliningStatus status);
};

class CallInfo
{
    MDefinition* fun_;
    MDefinition* thisArg_;
    MDefinition* newTargetArg_;
    MDefinitionVector args_;

    bool constructing_;
    bool setter_;

  public:
    CallInfo(TempAllocator& alloc, bool constructing)
      : fun_(nullptr),
        thisArg_(nullptr),
        newTargetArg_(nullptr),
        args_(alloc),
        constructing_(constructing),
        setter_(false)
    { }

    MOZ_MUST_USE bool init(CallInfo& callInfo) {
        MOZ_ASSERT(constructing_ == callInfo.constructing());

        fun_ = callInfo.fun();
        thisArg_ = callInfo.thisArg();

        if (constructing())
            newTargetArg_ = callInfo.getNewTarget();

        if (!args_.appendAll(callInfo.argv()))
            return false;

        return true;
    }

    MOZ_MUST_USE bool init(MBasicBlock* current, uint32_t argc) {
        MOZ_ASSERT(args_.empty());

        // Get the arguments in the right order
        if (!args_.reserve(argc))
            return false;

        if (constructing())
            setNewTarget(current->pop());

        for (int32_t i = argc; i > 0; i--)
            args_.infallibleAppend(current->peek(-i));
        current->popn(argc);

        // Get |this| and |fun|
        setThis(current->pop());
        setFun(current->pop());

        return true;
    }

    void popFormals(MBasicBlock* current) {
        current->popn(numFormals());
    }

    void pushFormals(MBasicBlock* current) {
        current->push(fun());
        current->push(thisArg());

        for (uint32_t i = 0; i < argc(); i++)
            current->push(getArg(i));

        if (constructing())
            current->push(getNewTarget());
    }

    uint32_t argc() const {
        return args_.length();
    }
    uint32_t numFormals() const {
        return argc() + 2 + constructing();
    }

    MOZ_MUST_USE bool setArgs(const MDefinitionVector& args) {
        MOZ_ASSERT(args_.empty());
        return args_.appendAll(args);
    }

    MDefinitionVector& argv() {
        return args_;
    }

    const MDefinitionVector& argv() const {
        return args_;
    }

    MDefinition* getArg(uint32_t i) const {
        MOZ_ASSERT(i < argc());
        return args_[i];
    }

    MDefinition* getArgWithDefault(uint32_t i, MDefinition* defaultValue) const {
        if (i < argc())
            return args_[i];

        return defaultValue;
    }

    void setArg(uint32_t i, MDefinition* def) {
        MOZ_ASSERT(i < argc());
        args_[i] = def;
    }

    MDefinition* thisArg() const {
        MOZ_ASSERT(thisArg_);
        return thisArg_;
    }

    void setThis(MDefinition* thisArg) {
        thisArg_ = thisArg;
    }

    bool constructing() const {
        return constructing_;
    }

    void setNewTarget(MDefinition* newTarget) {
        MOZ_ASSERT(constructing());
        newTargetArg_ = newTarget;
    }
    MDefinition* getNewTarget() const {
        MOZ_ASSERT(newTargetArg_);
        return newTargetArg_;
    }

    bool isSetter() const {
        return setter_;
    }
    void markAsSetter() {
        setter_ = true;
    }

    MDefinition* fun() const {
        MOZ_ASSERT(fun_);
        return fun_;
    }

    void setFun(MDefinition* fun) {
        fun_ = fun;
    }

    void setImplicitlyUsedUnchecked() {
        fun_->setImplicitlyUsedUnchecked();
        thisArg_->setImplicitlyUsedUnchecked();
        if (newTargetArg_)
            newTargetArg_->setImplicitlyUsedUnchecked();
        for (uint32_t i = 0; i < argc(); i++)
            getArg(i)->setImplicitlyUsedUnchecked();
    }
};

bool NeedsPostBarrier(MDefinition* value);

} // namespace jit
} // namespace js

#endif /* jit_IonBuilder_h */
