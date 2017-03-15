/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_ASTINTERFACEBLOCK
#define SKSL_ASTINTERFACEBLOCK

#include "SkSLASTVarDeclaration.h"

namespace SkSL {

/**
 * An interface block, as in:
 *
 * out gl_PerVertex {
 *   layout(builtin=0) vec4 gl_Position;
 *   layout(builtin=1) float gl_PointSize;
 * };
 */
struct ASTInterfaceBlock : public ASTDeclaration {
    // valueName is empty when it was not present in the source
    ASTInterfaceBlock(Position position,
                      ASTModifiers modifiers, 
                      std::string interfaceName, 
                      std::string valueName, 
                      std::vector<std::unique_ptr<ASTVarDeclarations>> declarations)
    : INHERITED(position, kInterfaceBlock_Kind)
    , fModifiers(modifiers)
    , fInterfaceName(std::move(interfaceName))
    , fValueName(std::move(valueName))
    , fDeclarations(std::move(declarations)) {}

    std::string description() const override {
        std::string result = fModifiers.description() + fInterfaceName + " {\n";
        for (size_t i = 0; i < fDeclarations.size(); i++) {
            result += fDeclarations[i]->description() + "\n";
        }
        result += "}";
        if (fValueName.length()) {
            result += " " + fValueName;
        }
        return result + ";";
    }

    const ASTModifiers fModifiers;
    const std::string fInterfaceName;
    const std::string fValueName;
    const std::vector<std::unique_ptr<ASTVarDeclarations>> fDeclarations;

    typedef ASTDeclaration INHERITED;
};

} // namespace

#endif
