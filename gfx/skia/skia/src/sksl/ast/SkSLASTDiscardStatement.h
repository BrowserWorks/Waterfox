/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_ASTDISCARDSTATEMENT
#define SKSL_ASTDISCARDSTATEMENT

#include "SkSLASTStatement.h"

namespace SkSL {

/**
 * A 'discard' statement. 
 */
struct ASTDiscardStatement : public ASTStatement {
    ASTDiscardStatement(Position position)
    : INHERITED(position, kDiscard_Kind) {}

    std::string description() const override {
        return "discard;";
    }

    typedef ASTStatement INHERITED;
};

} // namespace

#endif
