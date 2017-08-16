//
// Copyright (c) 2002-2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#include "compiler/translator/ValidateLimitations.h"
#include "compiler/translator/InfoSink.h"
#include "compiler/translator/InitializeParseContext.h"
#include "compiler/translator/ParseContext.h"
#include "angle_gl.h"

namespace sh
{

namespace
{

int GetLoopSymbolId(TIntermLoop *loop)
{
    // Here we assume all the operations are valid, because the loop node is
    // already validated before this call.
    TIntermSequence *declSeq = loop->getInit()->getAsDeclarationNode()->getSequence();
    TIntermBinary *declInit  = (*declSeq)[0]->getAsBinaryNode();
    TIntermSymbol *symbol    = declInit->getLeft()->getAsSymbolNode();

    return symbol->getId();
}

// Traverses a node to check if it represents a constant index expression.
// Definition:
// constant-index-expressions are a superset of constant-expressions.
// Constant-index-expressions can include loop indices as defined in
// GLSL ES 1.0 spec, Appendix A, section 4.
// The following are constant-index-expressions:
// - Constant expressions
// - Loop indices as defined in section 4
// - Expressions composed of both of the above
class ValidateConstIndexExpr : public TIntermTraverser
{
  public:
    ValidateConstIndexExpr(const std::vector<int> &loopSymbols)
        : TIntermTraverser(true, false, false), mValid(true), mLoopSymbolIds(loopSymbols)
    {
    }

    // Returns true if the parsed node represents a constant index expression.
    bool isValid() const { return mValid; }

    void visitSymbol(TIntermSymbol *symbol) override
    {
        // Only constants and loop indices are allowed in a
        // constant index expression.
        if (mValid)
        {
            bool isLoopSymbol = std::find(mLoopSymbolIds.begin(), mLoopSymbolIds.end(),
                                          symbol->getId()) != mLoopSymbolIds.end();
            mValid = (symbol->getQualifier() == EvqConst) || isLoopSymbol;
        }
    }

  private:
    bool mValid;
    const std::vector<int> mLoopSymbolIds;
};

}  // namespace anonymous

ValidateLimitations::ValidateLimitations(sh::GLenum shaderType, TInfoSinkBase *sink)
    : TIntermTraverser(true, false, false),
      mShaderType(shaderType),
      mSink(sink),
      mNumErrors(0),
      mValidateIndexing(true),
      mValidateInnerLoops(true)
{
}

// static
bool ValidateLimitations::IsLimitedForLoop(TIntermLoop *loop)
{
    // The shader type doesn't matter in this case.
    ValidateLimitations validate(GL_FRAGMENT_SHADER, nullptr);
    validate.mValidateIndexing   = false;
    validate.mValidateInnerLoops = false;
    if (!validate.validateLoopType(loop))
        return false;
    if (!validate.validateForLoopHeader(loop))
        return false;
    TIntermNode *body = loop->getBody();
    if (body != nullptr)
    {
        validate.mLoopSymbolIds.push_back(GetLoopSymbolId(loop));
        body->traverse(&validate);
        validate.mLoopSymbolIds.pop_back();
    }
    return (validate.mNumErrors == 0);
}

bool ValidateLimitations::visitBinary(Visit, TIntermBinary *node)
{
    // Check if loop index is modified in the loop body.
    validateOperation(node, node->getLeft());

    // Check indexing.
    switch (node->getOp())
    {
      case EOpIndexDirect:
      case EOpIndexIndirect:
          if (mValidateIndexing)
              validateIndexing(node);
          break;
      default:
          break;
    }
    return true;
}

bool ValidateLimitations::visitUnary(Visit, TIntermUnary *node)
{
    // Check if loop index is modified in the loop body.
    validateOperation(node, node->getOperand());

    return true;
}

bool ValidateLimitations::visitAggregate(Visit, TIntermAggregate *node)
{
    switch (node->getOp()) {
      case EOpFunctionCall:
        validateFunctionCall(node);
        break;
      default:
        break;
    }
    return true;
}

bool ValidateLimitations::visitLoop(Visit, TIntermLoop *node)
{
    if (!mValidateInnerLoops)
        return true;

    if (!validateLoopType(node))
        return false;

    if (!validateForLoopHeader(node))
        return false;

    TIntermNode *body = node->getBody();
    if (body != NULL)
    {
        mLoopSymbolIds.push_back(GetLoopSymbolId(node));
        body->traverse(this);
        mLoopSymbolIds.pop_back();
    }

    // The loop is fully processed - no need to visit children.
    return false;
}

void ValidateLimitations::error(TSourceLoc loc,
                                const char *reason, const char *token)
{
    if (mSink)
    {
        mSink->prefix(EPrefixError);
        mSink->location(loc);
        (*mSink) << "'" << token << "' : " << reason << "\n";
    }
    ++mNumErrors;
}

bool ValidateLimitations::withinLoopBody() const
{
    return !mLoopSymbolIds.empty();
}

bool ValidateLimitations::isLoopIndex(TIntermSymbol *symbol)
{
    return std::find(mLoopSymbolIds.begin(), mLoopSymbolIds.end(), symbol->getId()) !=
           mLoopSymbolIds.end();
}

bool ValidateLimitations::validateLoopType(TIntermLoop *node)
{
    TLoopType type = node->getType();
    if (type == ELoopFor)
        return true;

    // Reject while and do-while loops.
    error(node->getLine(),
          "This type of loop is not allowed",
          type == ELoopWhile ? "while" : "do");
    return false;
}

bool ValidateLimitations::validateForLoopHeader(TIntermLoop *node)
{
    ASSERT(node->getType() == ELoopFor);

    //
    // The for statement has the form:
    //    for ( init-declaration ; condition ; expression ) statement
    //
    int indexSymbolId = validateForLoopInit(node);
    if (indexSymbolId < 0)
        return false;
    if (!validateForLoopCond(node, indexSymbolId))
        return false;
    if (!validateForLoopExpr(node, indexSymbolId))
        return false;

    return true;
}

int ValidateLimitations::validateForLoopInit(TIntermLoop *node)
{
    TIntermNode *init = node->getInit();
    if (init == NULL)
    {
        error(node->getLine(), "Missing init declaration", "for");
        return -1;
    }

    //
    // init-declaration has the form:
    //     type-specifier identifier = constant-expression
    //
    TIntermDeclaration *decl = init->getAsDeclarationNode();
    if (decl == nullptr)
    {
        error(init->getLine(), "Invalid init declaration", "for");
        return -1;
    }
    // To keep things simple do not allow declaration list.
    TIntermSequence *declSeq = decl->getSequence();
    if (declSeq->size() != 1)
    {
        error(decl->getLine(), "Invalid init declaration", "for");
        return -1;
    }
    TIntermBinary *declInit = (*declSeq)[0]->getAsBinaryNode();
    if ((declInit == NULL) || (declInit->getOp() != EOpInitialize))
    {
        error(decl->getLine(), "Invalid init declaration", "for");
        return -1;
    }
    TIntermSymbol *symbol = declInit->getLeft()->getAsSymbolNode();
    if (symbol == NULL)
    {
        error(declInit->getLine(), "Invalid init declaration", "for");
        return -1;
    }
    // The loop index has type int or float.
    TBasicType type = symbol->getBasicType();
    if ((type != EbtInt) && (type != EbtUInt) && (type != EbtFloat)) {
        error(symbol->getLine(),
              "Invalid type for loop index", getBasicString(type));
        return -1;
    }
    // The loop index is initialized with constant expression.
    if (!isConstExpr(declInit->getRight()))
    {
        error(declInit->getLine(),
              "Loop index cannot be initialized with non-constant expression",
              symbol->getSymbol().c_str());
        return -1;
    }

    return symbol->getId();
}

bool ValidateLimitations::validateForLoopCond(TIntermLoop *node,
                                              int indexSymbolId)
{
    TIntermNode *cond = node->getCondition();
    if (cond == NULL)
    {
        error(node->getLine(), "Missing condition", "for");
        return false;
    }
    //
    // condition has the form:
    //     loop_index relational_operator constant_expression
    //
    TIntermBinary *binOp = cond->getAsBinaryNode();
    if (binOp == NULL)
    {
        error(node->getLine(), "Invalid condition", "for");
        return false;
    }
    // Loop index should be to the left of relational operator.
    TIntermSymbol *symbol = binOp->getLeft()->getAsSymbolNode();
    if (symbol == NULL)
    {
        error(binOp->getLine(), "Invalid condition", "for");
        return false;
    }
    if (symbol->getId() != indexSymbolId)
    {
        error(symbol->getLine(),
              "Expected loop index", symbol->getSymbol().c_str());
        return false;
    }
    // Relational operator is one of: > >= < <= == or !=.
    switch (binOp->getOp())
    {
      case EOpEqual:
      case EOpNotEqual:
      case EOpLessThan:
      case EOpGreaterThan:
      case EOpLessThanEqual:
      case EOpGreaterThanEqual:
        break;
      default:
        error(binOp->getLine(),
              "Invalid relational operator",
              GetOperatorString(binOp->getOp()));
        break;
    }
    // Loop index must be compared with a constant.
    if (!isConstExpr(binOp->getRight()))
    {
        error(binOp->getLine(),
              "Loop index cannot be compared with non-constant expression",
              symbol->getSymbol().c_str());
        return false;
    }

    return true;
}

bool ValidateLimitations::validateForLoopExpr(TIntermLoop *node,
                                              int indexSymbolId)
{
    TIntermNode *expr = node->getExpression();
    if (expr == NULL)
    {
        error(node->getLine(), "Missing expression", "for");
        return false;
    }

    // for expression has one of the following forms:
    //     loop_index++
    //     loop_index--
    //     loop_index += constant_expression
    //     loop_index -= constant_expression
    //     ++loop_index
    //     --loop_index
    // The last two forms are not specified in the spec, but I am assuming
    // its an oversight.
    TIntermUnary *unOp = expr->getAsUnaryNode();
    TIntermBinary *binOp = unOp ? NULL : expr->getAsBinaryNode();

    TOperator op = EOpNull;
    TIntermSymbol *symbol = NULL;
    if (unOp != NULL)
    {
        op = unOp->getOp();
        symbol = unOp->getOperand()->getAsSymbolNode();
    }
    else if (binOp != NULL)
    {
        op = binOp->getOp();
        symbol = binOp->getLeft()->getAsSymbolNode();
    }

    // The operand must be loop index.
    if (symbol == NULL)
    {
        error(expr->getLine(), "Invalid expression", "for");
        return false;
    }
    if (symbol->getId() != indexSymbolId)
    {
        error(symbol->getLine(),
              "Expected loop index", symbol->getSymbol().c_str());
        return false;
    }

    // The operator is one of: ++ -- += -=.
    switch (op)
    {
      case EOpPostIncrement:
      case EOpPostDecrement:
      case EOpPreIncrement:
      case EOpPreDecrement:
        ASSERT((unOp != NULL) && (binOp == NULL));
        break;
      case EOpAddAssign:
      case EOpSubAssign:
        ASSERT((unOp == NULL) && (binOp != NULL));
        break;
      default:
        error(expr->getLine(), "Invalid operator", GetOperatorString(op));
        return false;
    }

    // Loop index must be incremented/decremented with a constant.
    if (binOp != NULL)
    {
        if (!isConstExpr(binOp->getRight()))
        {
            error(binOp->getLine(),
                  "Loop index cannot be modified by non-constant expression",
                  symbol->getSymbol().c_str());
            return false;
        }
    }

    return true;
}

bool ValidateLimitations::validateFunctionCall(TIntermAggregate *node)
{
    ASSERT(node->getOp() == EOpFunctionCall);

    // If not within loop body, there is nothing to check.
    if (!withinLoopBody())
        return true;

    // List of param indices for which loop indices are used as argument.
    typedef std::vector<size_t> ParamIndex;
    ParamIndex pIndex;
    TIntermSequence *params = node->getSequence();
    for (TIntermSequence::size_type i = 0; i < params->size(); ++i)
    {
        TIntermSymbol *symbol = (*params)[i]->getAsSymbolNode();
        if (symbol && isLoopIndex(symbol))
            pIndex.push_back(i);
    }
    // If none of the loop indices are used as arguments,
    // there is nothing to check.
    if (pIndex.empty())
        return true;

    bool valid = true;
    TSymbolTable& symbolTable = GetGlobalParseContext()->symbolTable;
    TSymbol *symbol           = symbolTable.find(node->getFunctionSymbolInfo()->getName(),
                                       GetGlobalParseContext()->getShaderVersion());
    ASSERT(symbol && symbol->isFunction());
    TFunction *function = static_cast<TFunction *>(symbol);
    for (ParamIndex::const_iterator i = pIndex.begin();
         i != pIndex.end(); ++i)
    {
        const TConstParameter &param = function->getParam(*i);
        TQualifier qual = param.type->getQualifier();
        if ((qual == EvqOut) || (qual == EvqInOut))
        {
            error((*params)[*i]->getLine(),
                  "Loop index cannot be used as argument to a function out or inout parameter",
                  (*params)[*i]->getAsSymbolNode()->getSymbol().c_str());
            valid = false;
        }
    }

    return valid;
}

bool ValidateLimitations::validateOperation(TIntermOperator *node,
                                            TIntermNode* operand)
{
    // Check if loop index is modified in the loop body.
    if (!withinLoopBody() || !node->isAssignment())
        return true;

    TIntermSymbol *symbol = operand->getAsSymbolNode();
    if (symbol && isLoopIndex(symbol))
    {
        error(node->getLine(),
              "Loop index cannot be statically assigned to within the body of the loop",
              symbol->getSymbol().c_str());
    }
    return true;
}

bool ValidateLimitations::isConstExpr(TIntermNode *node)
{
    ASSERT(node != nullptr);
    return node->getAsConstantUnion() != nullptr && node->getAsTyped()->getQualifier() == EvqConst;
}

bool ValidateLimitations::isConstIndexExpr(TIntermNode *node)
{
    ASSERT(node != NULL);

    ValidateConstIndexExpr validate(mLoopSymbolIds);
    node->traverse(&validate);
    return validate.isValid();
}

bool ValidateLimitations::validateIndexing(TIntermBinary *node)
{
    ASSERT((node->getOp() == EOpIndexDirect) ||
           (node->getOp() == EOpIndexIndirect));

    bool valid = true;
    TIntermTyped *index = node->getRight();
    // The index expession must be a constant-index-expression unless
    // the operand is a uniform in a vertex shader.
    TIntermTyped *operand = node->getLeft();
    bool skip = (mShaderType == GL_VERTEX_SHADER) &&
                (operand->getQualifier() == EvqUniform);
    if (!skip && !isConstIndexExpr(index))
    {
        error(index->getLine(), "Index expression must be constant", "[]");
        valid = false;
    }
    return valid;
}

}  // namespace sh
