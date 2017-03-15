/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_ASTIFSTATEMENT
#define SKSL_ASTIFSTATEMENT

#include "SkSLASTStatement.h"

namespace SkSL {

/**
 * An 'if' statement. 
 */
struct ASTIfStatement : public ASTStatement {
    ASTIfStatement(Position position, std::unique_ptr<ASTExpression> test, 
                   std::unique_ptr<ASTStatement> ifTrue, std::unique_ptr<ASTStatement> ifFalse)
    : INHERITED(position, kIf_Kind)
    , fTest(std::move(test))
    , fIfTrue(std::move(ifTrue))
    , fIfFalse(std::move(ifFalse)) {}

    std::string description() const override {
        std::string result("if (");
        result += fTest->description();
        result += ") ";
        result += fIfTrue->description();
        if (fIfFalse) {
            result += " else ";
            result += fIfFalse->description();
        }
        return result;        
    }

    const std::unique_ptr<ASTExpression> fTest;
    const std::unique_ptr<ASTStatement> fIfTrue;
    const std::unique_ptr<ASTStatement> fIfFalse;

    typedef ASTStatement INHERITED;
};

} // namespace

#endif
