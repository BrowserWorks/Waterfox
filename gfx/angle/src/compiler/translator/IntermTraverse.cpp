//
// Copyright (c) 2002-2010 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#include "compiler/translator/IntermNode.h"
#include "compiler/translator/InfoSink.h"
#include "compiler/translator/SymbolTable.h"

namespace sh
{

void TIntermSymbol::traverse(TIntermTraverser *it)
{
    it->traverseSymbol(this);
}

void TIntermRaw::traverse(TIntermTraverser *it)
{
    it->traverseRaw(this);
}

void TIntermConstantUnion::traverse(TIntermTraverser *it)
{
    it->traverseConstantUnion(this);
}

void TIntermSwizzle::traverse(TIntermTraverser *it)
{
    it->traverseSwizzle(this);
}

void TIntermBinary::traverse(TIntermTraverser *it)
{
    it->traverseBinary(this);
}

void TIntermUnary::traverse(TIntermTraverser *it)
{
    it->traverseUnary(this);
}

void TIntermTernary::traverse(TIntermTraverser *it)
{
    it->traverseTernary(this);
}

void TIntermIfElse::traverse(TIntermTraverser *it)
{
    it->traverseIfElse(this);
}

void TIntermSwitch::traverse(TIntermTraverser *it)
{
    it->traverseSwitch(this);
}

void TIntermCase::traverse(TIntermTraverser *it)
{
    it->traverseCase(this);
}

void TIntermFunctionDefinition::traverse(TIntermTraverser *it)
{
    it->traverseFunctionDefinition(this);
}

void TIntermBlock::traverse(TIntermTraverser *it)
{
    it->traverseBlock(this);
}

void TIntermDeclaration::traverse(TIntermTraverser *it)
{
    it->traverseDeclaration(this);
}

void TIntermAggregate::traverse(TIntermTraverser *it)
{
    it->traverseAggregate(this);
}

void TIntermLoop::traverse(TIntermTraverser *it)
{
    it->traverseLoop(this);
}

void TIntermBranch::traverse(TIntermTraverser *it)
{
    it->traverseBranch(this);
}

TIntermTraverser::TIntermTraverser(bool preVisit, bool inVisit, bool postVisit)
    : preVisit(preVisit),
      inVisit(inVisit),
      postVisit(postVisit),
      mDepth(0),
      mMaxDepth(0),
      mInGlobalScope(true),
      mTemporaryIndex(nullptr)
{
}

TIntermTraverser::~TIntermTraverser()
{
}

void TIntermTraverser::pushParentBlock(TIntermBlock *node)
{
    mParentBlockStack.push_back(ParentBlock(node, 0));
}

void TIntermTraverser::incrementParentBlockPos()
{
    ++mParentBlockStack.back().pos;
}

void TIntermTraverser::popParentBlock()
{
    ASSERT(!mParentBlockStack.empty());
    mParentBlockStack.pop_back();
}

void TIntermTraverser::insertStatementsInParentBlock(const TIntermSequence &insertions)
{
    TIntermSequence emptyInsertionsAfter;
    insertStatementsInParentBlock(insertions, emptyInsertionsAfter);
}

void TIntermTraverser::insertStatementsInParentBlock(const TIntermSequence &insertionsBefore,
                                                     const TIntermSequence &insertionsAfter)
{
    ASSERT(!mParentBlockStack.empty());
    NodeInsertMultipleEntry insert(mParentBlockStack.back().node, mParentBlockStack.back().pos,
                                   insertionsBefore, insertionsAfter);
    mInsertions.push_back(insert);
}

void TIntermTraverser::insertStatementInParentBlock(TIntermNode *statement)
{
    TIntermSequence insertions;
    insertions.push_back(statement);
    insertStatementsInParentBlock(insertions);
}

TIntermSymbol *TIntermTraverser::createTempSymbol(const TType &type, TQualifier qualifier)
{
    // Each traversal uses at most one temporary variable, so the index stays the same within a single traversal.
    TInfoSinkBase symbolNameOut;
    ASSERT(mTemporaryIndex != nullptr);
    symbolNameOut << "s" << (*mTemporaryIndex);
    TString symbolName = symbolNameOut.c_str();

    TIntermSymbol *node = new TIntermSymbol(0, symbolName, type);
    node->setInternal(true);

    ASSERT(qualifier == EvqTemporary || qualifier == EvqConst || qualifier == EvqGlobal);
    node->getTypePointer()->setQualifier(qualifier);
    // TODO(oetuaho): Might be useful to sanitize layout qualifier etc. on the type of the created
    // symbol. This might need to be done in other places as well.
    return node;
}

TIntermSymbol *TIntermTraverser::createTempSymbol(const TType &type)
{
    return createTempSymbol(type, EvqTemporary);
}

TIntermDeclaration *TIntermTraverser::createTempDeclaration(const TType &type)
{
    TIntermDeclaration *tempDeclaration = new TIntermDeclaration();
    tempDeclaration->appendDeclarator(createTempSymbol(type));
    return tempDeclaration;
}

TIntermDeclaration *TIntermTraverser::createTempInitDeclaration(TIntermTyped *initializer,
                                                                TQualifier qualifier)
{
    ASSERT(initializer != nullptr);
    TIntermSymbol *tempSymbol = createTempSymbol(initializer->getType(), qualifier);
    TIntermDeclaration *tempDeclaration = new TIntermDeclaration();
    TIntermBinary *tempInit           = new TIntermBinary(EOpInitialize, tempSymbol, initializer);
    tempDeclaration->appendDeclarator(tempInit);
    return tempDeclaration;
}

TIntermDeclaration *TIntermTraverser::createTempInitDeclaration(TIntermTyped *initializer)
{
    return createTempInitDeclaration(initializer, EvqTemporary);
}

TIntermBinary *TIntermTraverser::createTempAssignment(TIntermTyped *rightNode)
{
    ASSERT(rightNode != nullptr);
    TIntermSymbol *tempSymbol = createTempSymbol(rightNode->getType());
    TIntermBinary *assignment = new TIntermBinary(EOpAssign, tempSymbol, rightNode);
    return assignment;
}

void TIntermTraverser::useTemporaryIndex(unsigned int *temporaryIndex)
{
    mTemporaryIndex = temporaryIndex;
}

void TIntermTraverser::nextTemporaryIndex()
{
    ASSERT(mTemporaryIndex != nullptr);
    ++(*mTemporaryIndex);
}

void TLValueTrackingTraverser::addToFunctionMap(const TName &name, TIntermSequence *paramSequence)
{
    mFunctionMap[name] = paramSequence;
}

bool TLValueTrackingTraverser::isInFunctionMap(const TIntermAggregate *callNode) const
{
    ASSERT(callNode->getOp() == EOpFunctionCall);
    return (mFunctionMap.find(callNode->getFunctionSymbolInfo()->getNameObj()) !=
            mFunctionMap.end());
}

TIntermSequence *TLValueTrackingTraverser::getFunctionParameters(const TIntermAggregate *callNode)
{
    ASSERT(isInFunctionMap(callNode));
    return mFunctionMap[callNode->getFunctionSymbolInfo()->getNameObj()];
}

void TLValueTrackingTraverser::setInFunctionCallOutParameter(bool inOutParameter)
{
    mInFunctionCallOutParameter = inOutParameter;
}

bool TLValueTrackingTraverser::isInFunctionCallOutParameter() const
{
    return mInFunctionCallOutParameter;
}

//
// Traverse the intermediate representation tree, and
// call a node type specific function for each node.
// Done recursively through the member function Traverse().
// Node types can be skipped if their function to call is 0,
// but their subtree will still be traversed.
// Nodes with children can have their whole subtree skipped
// if preVisit is turned on and the type specific function
// returns false.
//

//
// Traversal functions for terminals are straighforward....
//
void TIntermTraverser::traverseSymbol(TIntermSymbol *node)
{
    visitSymbol(node);
}

void TIntermTraverser::traverseConstantUnion(TIntermConstantUnion *node)
{
    visitConstantUnion(node);
}

void TIntermTraverser::traverseSwizzle(TIntermSwizzle *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitSwizzle(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        node->getOperand()->traverse(this);

        decrementDepth();
    }

    if (visit && postVisit)
        visitSwizzle(PostVisit, node);
}

//
// Traverse a binary node.
//
void TIntermTraverser::traverseBinary(TIntermBinary *node)
{
    bool visit = true;

    //
    // visit the node before children if pre-visiting.
    //
    if (preVisit)
        visit = visitBinary(PreVisit, node);

    //
    // Visit the children, in the right order.
    //
    if (visit)
    {
        incrementDepth(node);

        if (node->getLeft())
            node->getLeft()->traverse(this);

        if (inVisit)
            visit = visitBinary(InVisit, node);

        if (visit && node->getRight())
            node->getRight()->traverse(this);

        decrementDepth();
    }

    //
    // Visit the node after the children, if requested and the traversal
    // hasn't been cancelled yet.
    //
    if (visit && postVisit)
        visitBinary(PostVisit, node);
}

void TLValueTrackingTraverser::traverseBinary(TIntermBinary *node)
{
    bool visit = true;

    //
    // visit the node before children if pre-visiting.
    //
    if (preVisit)
        visit = visitBinary(PreVisit, node);

    //
    // Visit the children, in the right order.
    //
    if (visit)
    {
        incrementDepth(node);

        // Some binary operations like indexing can be inside an expression which must be an
        // l-value.
        bool parentOperatorRequiresLValue     = operatorRequiresLValue();
        bool parentInFunctionCallOutParameter = isInFunctionCallOutParameter();
        if (node->isAssignment())
        {
            ASSERT(!isLValueRequiredHere());
            setOperatorRequiresLValue(true);
        }

        if (node->getLeft())
            node->getLeft()->traverse(this);

        if (inVisit)
            visit = visitBinary(InVisit, node);

        if (node->isAssignment())
            setOperatorRequiresLValue(false);

        // Index is not required to be an l-value even when the surrounding expression is required
        // to be an l-value.
        TOperator op = node->getOp();
        if (op == EOpIndexDirect || op == EOpIndexDirectInterfaceBlock ||
            op == EOpIndexDirectStruct || op == EOpIndexIndirect)
        {
            setOperatorRequiresLValue(false);
            setInFunctionCallOutParameter(false);
        }

        if (visit && node->getRight())
            node->getRight()->traverse(this);

        setOperatorRequiresLValue(parentOperatorRequiresLValue);
        setInFunctionCallOutParameter(parentInFunctionCallOutParameter);

        decrementDepth();
    }

    //
    // Visit the node after the children, if requested and the traversal
    // hasn't been cancelled yet.
    //
    if (visit && postVisit)
        visitBinary(PostVisit, node);
}

//
// Traverse a unary node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseUnary(TIntermUnary *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitUnary(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        node->getOperand()->traverse(this);

        decrementDepth();
    }

    if (visit && postVisit)
        visitUnary(PostVisit, node);
}

void TLValueTrackingTraverser::traverseUnary(TIntermUnary *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitUnary(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        ASSERT(!operatorRequiresLValue());
        switch (node->getOp())
        {
            case EOpPostIncrement:
            case EOpPostDecrement:
            case EOpPreIncrement:
            case EOpPreDecrement:
                setOperatorRequiresLValue(true);
                break;
            default:
                break;
        }

        node->getOperand()->traverse(this);

        setOperatorRequiresLValue(false);

        decrementDepth();
    }

    if (visit && postVisit)
        visitUnary(PostVisit, node);
}

// Traverse a function definition node.
void TIntermTraverser::traverseFunctionDefinition(TIntermFunctionDefinition *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitFunctionDefinition(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);
        mInGlobalScope = false;

        node->getFunctionParameters()->traverse(this);
        if (inVisit)
            visit = visitFunctionDefinition(InVisit, node);
        node->getBody()->traverse(this);

        mInGlobalScope = true;
        decrementDepth();
    }

    if (visit && postVisit)
        visitFunctionDefinition(PostVisit, node);
}

// Traverse a block node.
void TIntermTraverser::traverseBlock(TIntermBlock *node)
{
    bool visit = true;

    TIntermSequence *sequence = node->getSequence();

    if (preVisit)
        visit = visitBlock(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);
        pushParentBlock(node);

        for (auto *child : *sequence)
        {
            child->traverse(this);
            if (visit && inVisit)
            {
                if (child != sequence->back())
                    visit = visitBlock(InVisit, node);
            }

            incrementParentBlockPos();
        }

        popParentBlock();
        decrementDepth();
    }

    if (visit && postVisit)
        visitBlock(PostVisit, node);
}

// Traverse a declaration node.
void TIntermTraverser::traverseDeclaration(TIntermDeclaration *node)
{
    bool visit = true;

    TIntermSequence *sequence = node->getSequence();

    if (preVisit)
        visit = visitDeclaration(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        for (auto *child : *sequence)
        {
            child->traverse(this);
            if (visit && inVisit)
            {
                if (child != sequence->back())
                    visit = visitDeclaration(InVisit, node);
            }
        }

        decrementDepth();
    }

    if (visit && postVisit)
        visitDeclaration(PostVisit, node);
}

// Traverse an aggregate node.  Same comments in binary node apply here.
void TIntermTraverser::traverseAggregate(TIntermAggregate *node)
{
    bool visit = true;

    TIntermSequence *sequence = node->getSequence();

    if (preVisit)
        visit = visitAggregate(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        for (auto *child : *sequence)
        {
            child->traverse(this);
            if (visit && inVisit)
            {
                if (child != sequence->back())
                    visit = visitAggregate(InVisit, node);
            }
        }

        decrementDepth();
    }

    if (visit && postVisit)
        visitAggregate(PostVisit, node);
}

void TLValueTrackingTraverser::traverseFunctionDefinition(TIntermFunctionDefinition *node)
{
    TIntermAggregate *params = node->getFunctionParameters();
    ASSERT(params != nullptr);
    ASSERT(params->getOp() == EOpParameters);
    addToFunctionMap(node->getFunctionSymbolInfo()->getNameObj(), params->getSequence());

    TIntermTraverser::traverseFunctionDefinition(node);
}

void TLValueTrackingTraverser::traverseAggregate(TIntermAggregate *node)
{
    bool visit = true;

    TIntermSequence *sequence = node->getSequence();
    if (node->getOp() == EOpPrototype)
    {
        addToFunctionMap(node->getFunctionSymbolInfo()->getNameObj(), sequence);
    }

    if (preVisit)
        visit = visitAggregate(PreVisit, node);

    if (visit)
    {
        bool inFunctionMap = false;
        if (node->getOp() == EOpFunctionCall)
        {
            inFunctionMap = isInFunctionMap(node);
            if (!inFunctionMap)
            {
                // The function is not user-defined - it is likely built-in texture function.
                // Assume that those do not have out parameters.
                setInFunctionCallOutParameter(false);
            }
        }

        incrementDepth(node);

        if (inFunctionMap)
        {
            TIntermSequence *params             = getFunctionParameters(node);
            TIntermSequence::iterator paramIter = params->begin();
            for (auto *child : *sequence)
            {
                ASSERT(paramIter != params->end());
                TQualifier qualifier = (*paramIter)->getAsTyped()->getQualifier();
                setInFunctionCallOutParameter(qualifier == EvqOut || qualifier == EvqInOut);

                child->traverse(this);
                if (visit && inVisit)
                {
                    if (child != sequence->back())
                        visit = visitAggregate(InVisit, node);
                }

                ++paramIter;
            }

            setInFunctionCallOutParameter(false);
        }
        else
        {
            // Find the built-in function corresponding to this op so that we can determine the
            // in/out qualifiers of its parameters.
            TFunction *builtInFunc = nullptr;
            TString opString = GetOperatorString(node->getOp());
            if (!node->isConstructor() && !opString.empty())
            {
                // The return type doesn't affect the mangled name of the function, which is used
                // to look it up from the symbol table.
                TType dummyReturnType;
                TFunction call(&opString, &dummyReturnType, node->getOp());
                for (auto *child : *sequence)
                {
                    TType *paramType = child->getAsTyped()->getTypePointer();
                    TConstParameter p(paramType);
                    call.addParameter(p);
                }

                TSymbol *sym = mSymbolTable.findBuiltIn(call.getMangledName(), mShaderVersion);
                if (sym != nullptr && sym->isFunction())
                {
                    builtInFunc = static_cast<TFunction *>(sym);
                    ASSERT(builtInFunc->getParamCount() == sequence->size());
                }
            }

            size_t paramIndex = 0;

            for (auto *child : *sequence)
            {
                TQualifier qualifier = EvqIn;
                if (builtInFunc != nullptr)
                    qualifier = builtInFunc->getParam(paramIndex).type->getQualifier();
                setInFunctionCallOutParameter(qualifier == EvqOut || qualifier == EvqInOut);
                child->traverse(this);

                if (visit && inVisit)
                {
                    if (child != sequence->back())
                        visit = visitAggregate(InVisit, node);
                }

                ++paramIndex;
            }

            setInFunctionCallOutParameter(false);
        }

        decrementDepth();
    }

    if (visit && postVisit)
        visitAggregate(PostVisit, node);
}

//
// Traverse a ternary node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseTernary(TIntermTernary *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitTernary(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);
        node->getCondition()->traverse(this);
        if (node->getTrueExpression())
            node->getTrueExpression()->traverse(this);
        if (node->getFalseExpression())
            node->getFalseExpression()->traverse(this);
        decrementDepth();
    }

    if (visit && postVisit)
        visitTernary(PostVisit, node);
}

// Traverse an if-else node.  Same comments in binary node apply here.
void TIntermTraverser::traverseIfElse(TIntermIfElse *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitIfElse(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);
        node->getCondition()->traverse(this);
        if (node->getTrueBlock())
            node->getTrueBlock()->traverse(this);
        if (node->getFalseBlock())
            node->getFalseBlock()->traverse(this);
        decrementDepth();
    }

    if (visit && postVisit)
        visitIfElse(PostVisit, node);
}

//
// Traverse a switch node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseSwitch(TIntermSwitch *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitSwitch(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);
        node->getInit()->traverse(this);
        if (inVisit)
            visit = visitSwitch(InVisit, node);
        if (visit && node->getStatementList())
            node->getStatementList()->traverse(this);
        decrementDepth();
    }

    if (visit && postVisit)
        visitSwitch(PostVisit, node);
}

//
// Traverse a case node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseCase(TIntermCase *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitCase(PreVisit, node);

    if (visit && node->getCondition())
    {
        incrementDepth(node);
        node->getCondition()->traverse(this);
        decrementDepth();
    }

    if (visit && postVisit)
        visitCase(PostVisit, node);
}

//
// Traverse a loop node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseLoop(TIntermLoop *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitLoop(PreVisit, node);

    if (visit)
    {
        incrementDepth(node);

        if (node->getInit())
            node->getInit()->traverse(this);

        if (node->getCondition())
            node->getCondition()->traverse(this);

        if (node->getBody())
            node->getBody()->traverse(this);

        if (node->getExpression())
            node->getExpression()->traverse(this);

        decrementDepth();
    }

    if (visit && postVisit)
        visitLoop(PostVisit, node);
}

//
// Traverse a branch node.  Same comments in binary node apply here.
//
void TIntermTraverser::traverseBranch(TIntermBranch *node)
{
    bool visit = true;

    if (preVisit)
        visit = visitBranch(PreVisit, node);

    if (visit && node->getExpression())
    {
        incrementDepth(node);
        node->getExpression()->traverse(this);
        decrementDepth();
    }

    if (visit && postVisit)
        visitBranch(PostVisit, node);
}

void TIntermTraverser::traverseRaw(TIntermRaw *node)
{
    visitRaw(node);
}

}  // namespace sh
