/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_INTLITERAL
#define SKSL_INTLITERAL

#include "SkSLExpression.h"

namespace SkSL {

/**
 * A literal integer.
 */
struct IntLiteral : public Expression {
    // FIXME: we will need to revisit this if/when we add full support for both signed and unsigned
    // 64-bit integers, but for right now an int64_t will hold every value we care about
    IntLiteral(const Context& context, Position position, int64_t value)
    : INHERITED(position, kIntLiteral_Kind, *context.fInt_Type)
    , fValue(value) {}

    virtual std::string description() const override {
        return to_string(fValue);
    }

   bool isConstant() const override {
        return true;
    }

    const int64_t fValue;

    typedef Expression INHERITED;
};

} // namespace

#endif
