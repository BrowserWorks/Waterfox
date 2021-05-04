//
// Copyright 2019 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// RemoveInactiveInterfaceVariables.h:
//  Drop shader interface variable declarations for those that are inactive.
//

#include "compiler/translator/tree_ops/RemoveInactiveInterfaceVariables.h"

#include "compiler/translator/SymbolTable.h"
#include "compiler/translator/tree_util/IntermTraverse.h"
#include "compiler/translator/util.h"

namespace sh
{

namespace
{

// Traverser that removes all declarations that correspond to inactive variables.
class RemoveInactiveInterfaceVariablesTraverser : public TIntermTraverser
{
  public:
    RemoveInactiveInterfaceVariablesTraverser(
        const std::vector<sh::ShaderVariable> &attributes,
        const std::vector<sh::ShaderVariable> &inputVaryings,
        const std::vector<sh::ShaderVariable> &outputVariables,
        const std::vector<sh::ShaderVariable> &uniforms,
        const std::vector<sh::InterfaceBlock> &interfaceBlocks);

    bool visitDeclaration(Visit visit, TIntermDeclaration *node) override;

  private:
    const std::vector<sh::ShaderVariable> &mAttributes;
    const std::vector<sh::ShaderVariable> &mInputVaryings;
    const std::vector<sh::ShaderVariable> &mOutputVariables;
    const std::vector<sh::ShaderVariable> &mUniforms;
    const std::vector<sh::InterfaceBlock> &mInterfaceBlocks;
};

RemoveInactiveInterfaceVariablesTraverser::RemoveInactiveInterfaceVariablesTraverser(
    const std::vector<sh::ShaderVariable> &attributes,
    const std::vector<sh::ShaderVariable> &inputVaryings,
    const std::vector<sh::ShaderVariable> &outputVariables,
    const std::vector<sh::ShaderVariable> &uniforms,
    const std::vector<sh::InterfaceBlock> &interfaceBlocks)
    : TIntermTraverser(true, false, false),
      mAttributes(attributes),
      mInputVaryings(inputVaryings),
      mOutputVariables(outputVariables),
      mUniforms(uniforms),
      mInterfaceBlocks(interfaceBlocks)
{}

template <typename Variable>
bool IsVariableActive(const std::vector<Variable> &mVars, const ImmutableString &name)
{
    for (const Variable &var : mVars)
    {
        if (name == var.name)
        {
            return var.active;
        }
    }
    UNREACHABLE();
    return true;
}

bool RemoveInactiveInterfaceVariablesTraverser::visitDeclaration(Visit visit,
                                                                 TIntermDeclaration *node)
{
    // SeparateDeclarations should have already been run.
    ASSERT(node->getSequence()->size() == 1u);

    TIntermTyped *declarator = node->getSequence()->front()->getAsTyped();
    ASSERT(declarator);

    TIntermSymbol *asSymbol = declarator->getAsSymbolNode();
    if (!asSymbol)
    {
        return false;
    }

    const TType &type = declarator->getType();

    // Remove all shader interface variables except outputs, i.e. uniforms, interface blocks and
    // inputs.
    //
    // Imagine a situation where the VS doesn't write to a varying but the FS reads from it.  This
    // is allowed, though the value of the varying is undefined.  If the varying is removed here,
    // the situation is changed to VS not declaring the varying, but the FS reading from it, which
    // is not allowed.  That's why inactive shader outputs are not removed.
    //
    // Inactive fragment shader outputs can be removed though, as there is no next stage.
    bool removeDeclaration     = false;
    const TQualifier qualifier = type.getQualifier();

    if (type.isInterfaceBlock())
    {
        removeDeclaration = !IsVariableActive(mInterfaceBlocks, type.getInterfaceBlock()->name());
    }
    else if (qualifier == EvqUniform)
    {
        removeDeclaration = !IsVariableActive(mUniforms, asSymbol->getName());
    }
    else if (qualifier == EvqAttribute || qualifier == EvqVertexIn)
    {
        removeDeclaration = !IsVariableActive(mAttributes, asSymbol->getName());
    }
    else if (IsShaderIn(qualifier))
    {
        removeDeclaration = !IsVariableActive(mInputVaryings, asSymbol->getName());
    }
    else if (qualifier == EvqFragmentOut)
    {
        removeDeclaration = !IsVariableActive(mOutputVariables, asSymbol->getName());
    }

    if (removeDeclaration)
    {
        TIntermSequence emptySequence;
        mMultiReplacements.emplace_back(getParentNode()->getAsBlock(), node, emptySequence);
    }

    return false;
}

}  // namespace

bool RemoveInactiveInterfaceVariables(TCompiler *compiler,
                                      TIntermBlock *root,
                                      const std::vector<sh::ShaderVariable> &attributes,
                                      const std::vector<sh::ShaderVariable> &inputVaryings,
                                      const std::vector<sh::ShaderVariable> &outputVariables,
                                      const std::vector<sh::ShaderVariable> &uniforms,
                                      const std::vector<sh::InterfaceBlock> &interfaceBlocks)
{
    RemoveInactiveInterfaceVariablesTraverser traverser(attributes, inputVaryings, outputVariables,
                                                        uniforms, interfaceBlocks);
    root->traverse(&traverser);
    return traverser.updateTree(compiler, root);
}

}  // namespace sh
