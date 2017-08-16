//
// Copyright (c) 2002-2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// The SeparateArrayInitialization function splits each array initialization into a declaration and an assignment.
// Example:
//     type[n] a = initializer;
// will effectively become
//     type[n] a;
//     a = initializer;
//
// Note that if the array is declared as const, the initialization may still be split, making the
// AST technically invalid. Because of that this transformation should only be used when subsequent
// stages don't care about const qualifiers. However, the initialization will not be split if the
// initializer can be written as a HLSL literal.

#include "compiler/translator/SeparateArrayInitialization.h"

#include "compiler/translator/IntermNode.h"
#include "compiler/translator/OutputHLSL.h"

namespace sh
{

namespace
{

class SeparateArrayInitTraverser : private TIntermTraverser
{
  public:
    static void apply(TIntermNode *root);
  private:
    SeparateArrayInitTraverser();
    bool visitDeclaration(Visit, TIntermDeclaration *node) override;
};

void SeparateArrayInitTraverser::apply(TIntermNode *root)
{
    SeparateArrayInitTraverser separateInit;
    root->traverse(&separateInit);
    separateInit.updateTree();
}

SeparateArrayInitTraverser::SeparateArrayInitTraverser()
    : TIntermTraverser(true, false, false)
{
}

bool SeparateArrayInitTraverser::visitDeclaration(Visit, TIntermDeclaration *node)
{
    TIntermSequence *sequence = node->getSequence();
    TIntermBinary *initNode   = sequence->back()->getAsBinaryNode();
    if (initNode != nullptr && initNode->getOp() == EOpInitialize)
    {
        TIntermTyped *initializer = initNode->getRight();
        if (initializer->isArray() && !sh::OutputHLSL::canWriteAsHLSLLiteral(initializer))
        {
            // We rely on that array declarations have been isolated to single declarations.
            ASSERT(sequence->size() == 1);
            TIntermTyped *symbol      = initNode->getLeft();
            TIntermBlock *parentBlock = getParentNode()->getAsBlock();
            ASSERT(parentBlock != nullptr);

            TIntermSequence replacements;

            TIntermDeclaration *replacementDeclaration = new TIntermDeclaration();
            replacementDeclaration->appendDeclarator(symbol);
            replacementDeclaration->setLine(symbol->getLine());
            replacements.push_back(replacementDeclaration);

            TIntermBinary *replacementAssignment =
                new TIntermBinary(EOpAssign, symbol, initializer);
            replacementAssignment->setLine(symbol->getLine());
            replacements.push_back(replacementAssignment);

            mMultiReplacements.push_back(
                NodeReplaceWithMultipleEntry(parentBlock, node, replacements));
        }
    }
    return false;
}

} // namespace

void SeparateArrayInitialization(TIntermNode *root)
{
    SeparateArrayInitTraverser::apply(root);
}

}  // namespace sh
