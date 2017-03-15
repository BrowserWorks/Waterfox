/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#include "SkSLGLSLCodeGenerator.h"

#include "string.h"

#include "GLSL.std.450.h"

#include "ir/SkSLExpressionStatement.h"
#include "ir/SkSLExtension.h"
#include "ir/SkSLIndexExpression.h"
#include "ir/SkSLVariableReference.h"

namespace SkSL {

void GLSLCodeGenerator::write(const char* s) {
    if (s[0] == 0) {
        return;
    }
    if (fAtLineStart) {
        for (int i = 0; i < fIndentation; i++) {
            *fOut << "    ";
        }
    }
    *fOut << s;
    fAtLineStart = false;
}

void GLSLCodeGenerator::writeLine(const char* s) {
    this->write(s);
    *fOut << "\n";
    fAtLineStart = true;
}

void GLSLCodeGenerator::write(const std::string& s) {
    this->write(s.c_str());
}

void GLSLCodeGenerator::writeLine(const std::string& s) {
    this->writeLine(s.c_str());
}

void GLSLCodeGenerator::writeLine() {
    this->writeLine("");
}

void GLSLCodeGenerator::writeExtension(const Extension& ext) {
    this->writeLine("#extension " + ext.fName + " : enable");
}

void GLSLCodeGenerator::writeType(const Type& type) {
    if (type.kind() == Type::kStruct_Kind) {
        for (const Type* search : fWrittenStructs) {
            if (*search == type) {
                // already written
                this->write(type.name());
                return;
            }
        }
        fWrittenStructs.push_back(&type);
        this->writeLine("struct " + type.name() + " {");
        fIndentation++;
        for (const auto& f : type.fields()) {
            this->writeModifiers(f.fModifiers);
            // sizes (which must be static in structs) are part of the type name here
            this->writeType(*f.fType);
            this->writeLine(" " + f.fName + ";");
        }
        fIndentation--;
        this->writeLine("}");
    } else {
        this->write(type.name());
    }
}

void GLSLCodeGenerator::writeExpression(const Expression& expr, Precedence parentPrecedence) {
    switch (expr.fKind) {
        case Expression::kBinary_Kind:
            this->writeBinaryExpression((BinaryExpression&) expr, parentPrecedence);
            break;
        case Expression::kBoolLiteral_Kind:
            this->writeBoolLiteral((BoolLiteral&) expr);
            break;
        case Expression::kConstructor_Kind:
            this->writeConstructor((Constructor&) expr);
            break;
        case Expression::kIntLiteral_Kind:
            this->writeIntLiteral((IntLiteral&) expr);
            break;
        case Expression::kFieldAccess_Kind:
            this->writeFieldAccess(((FieldAccess&) expr));
            break;
        case Expression::kFloatLiteral_Kind:
            this->writeFloatLiteral(((FloatLiteral&) expr));
            break;
        case Expression::kFunctionCall_Kind:
            this->writeFunctionCall((FunctionCall&) expr);
            break;
        case Expression::kPrefix_Kind:
            this->writePrefixExpression((PrefixExpression&) expr, parentPrecedence);
            break;
        case Expression::kPostfix_Kind:
            this->writePostfixExpression((PostfixExpression&) expr, parentPrecedence);
            break;
        case Expression::kSwizzle_Kind:
            this->writeSwizzle((Swizzle&) expr);
            break;
        case Expression::kVariableReference_Kind:
            this->writeVariableReference((VariableReference&) expr);
            break;
        case Expression::kTernary_Kind:
            this->writeTernaryExpression((TernaryExpression&) expr, parentPrecedence);
            break;
        case Expression::kIndex_Kind:
            this->writeIndexExpression((IndexExpression&) expr);
            break;
        default:
            ABORT("unsupported expression: %s", expr.description().c_str());
    }
}

void GLSLCodeGenerator::writeFunctionCall(const FunctionCall& c) {
    this->write(c.fFunction.fName + "(");
    const char* separator = "";
    for (const auto& arg : c.fArguments) {
        this->write(separator);
        separator = ", ";
        this->writeExpression(*arg, kSequence_Precedence);
    }
    this->write(")");
}

void GLSLCodeGenerator::writeConstructor(const Constructor& c) {
    this->write(c.fType.name() + "(");
    const char* separator = "";
    for (const auto& arg : c.fArguments) {
        this->write(separator);
        separator = ", ";
        this->writeExpression(*arg, kSequence_Precedence);
    }
    this->write(")");
}

void GLSLCodeGenerator::writeVariableReference(const VariableReference& ref) {
    this->write(ref.fVariable.fName);
}

void GLSLCodeGenerator::writeIndexExpression(const IndexExpression& expr) {
    this->writeExpression(*expr.fBase, kPostfix_Precedence);
    this->write("[");
    this->writeExpression(*expr.fIndex, kTopLevel_Precedence);
    this->write("]");
}

void GLSLCodeGenerator::writeFieldAccess(const FieldAccess& f) {
    if (f.fOwnerKind == FieldAccess::kDefault_OwnerKind) {
        this->writeExpression(*f.fBase, kPostfix_Precedence);
        this->write(".");
    }
    this->write(f.fBase->fType.fields()[f.fFieldIndex].fName);
}

void GLSLCodeGenerator::writeSwizzle(const Swizzle& swizzle) {
    this->writeExpression(*swizzle.fBase, kPostfix_Precedence);
    this->write(".");
    for (int c : swizzle.fComponents) {
        this->write(&("x\0y\0z\0w\0"[c * 2]));
    }
}

static GLSLCodeGenerator::Precedence get_binary_precedence(Token::Kind op) {
    switch (op) {
        case Token::STAR:         // fall through
        case Token::SLASH:        // fall through
        case Token::PERCENT:      return GLSLCodeGenerator::kMultiplicative_Precedence;
        case Token::PLUS:         // fall through
        case Token::MINUS:        return GLSLCodeGenerator::kAdditive_Precedence;
        case Token::SHL:          // fall through
        case Token::SHR:          return GLSLCodeGenerator::kShift_Precedence;
        case Token::LT:           // fall through
        case Token::GT:           // fall through
        case Token::LTEQ:         // fall through
        case Token::GTEQ:         return GLSLCodeGenerator::kRelational_Precedence;
        case Token::EQEQ:         // fall through
        case Token::NEQ:          return GLSLCodeGenerator::kEquality_Precedence;
        case Token::BITWISEAND:   return GLSLCodeGenerator::kBitwiseAnd_Precedence;
        case Token::BITWISEXOR:   return GLSLCodeGenerator::kBitwiseXor_Precedence;
        case Token::BITWISEOR:    return GLSLCodeGenerator::kBitwiseOr_Precedence;
        case Token::LOGICALAND:   return GLSLCodeGenerator::kLogicalAnd_Precedence;
        case Token::LOGICALXOR:   return GLSLCodeGenerator::kLogicalXor_Precedence;
        case Token::LOGICALOR:    return GLSLCodeGenerator::kLogicalOr_Precedence;
        case Token::EQ:           // fall through
        case Token::PLUSEQ:       // fall through
        case Token::MINUSEQ:      // fall through
        case Token::STAREQ:       // fall through
        case Token::SLASHEQ:      // fall through
        case Token::PERCENTEQ:    // fall through
        case Token::SHLEQ:        // fall through
        case Token::SHREQ:        // fall through
        case Token::LOGICALANDEQ: // fall through
        case Token::LOGICALXOREQ: // fall through
        case Token::LOGICALOREQ:  // fall through
        case Token::BITWISEANDEQ: // fall through
        case Token::BITWISEXOREQ: // fall through
        case Token::BITWISEOREQ:  return GLSLCodeGenerator::kAssignment_Precedence;
        default: ABORT("unsupported binary operator");
    }
}

void GLSLCodeGenerator::writeBinaryExpression(const BinaryExpression& b, 
                                              Precedence parentPrecedence) {
    Precedence precedence = get_binary_precedence(b.fOperator);
    if (precedence >= parentPrecedence) {
        this->write("(");
    }
    this->writeExpression(*b.fLeft, precedence);
    this->write(" " + Token::OperatorName(b.fOperator) + " ");
    this->writeExpression(*b.fRight, precedence);
    if (precedence >= parentPrecedence) {
        this->write(")");
    }
}

void GLSLCodeGenerator::writeTernaryExpression(const TernaryExpression& t, 
                                               Precedence parentPrecedence) {
    if (kTernary_Precedence >= parentPrecedence) {
        this->write("(");
    }
    this->writeExpression(*t.fTest, kTernary_Precedence);
    this->write(" ? ");
    this->writeExpression(*t.fIfTrue, kTernary_Precedence);
    this->write(" : ");
    this->writeExpression(*t.fIfFalse, kTernary_Precedence);
    if (kTernary_Precedence >= parentPrecedence) {
        this->write(")");
    }
}

void GLSLCodeGenerator::writePrefixExpression(const PrefixExpression& p, 
                                              Precedence parentPrecedence) {
    if (kPrefix_Precedence >= parentPrecedence) {
        this->write("(");
    }
    this->write(Token::OperatorName(p.fOperator));
    this->writeExpression(*p.fOperand, kPrefix_Precedence);
    if (kPrefix_Precedence >= parentPrecedence) {
        this->write(")");
    }
}

void GLSLCodeGenerator::writePostfixExpression(const PostfixExpression& p, 
                                               Precedence parentPrecedence) {
    if (kPostfix_Precedence >= parentPrecedence) {
        this->write("(");
    }
    this->writeExpression(*p.fOperand, kPostfix_Precedence);
    this->write(Token::OperatorName(p.fOperator));
    if (kPostfix_Precedence >= parentPrecedence) {
        this->write(")");
    }
}

void GLSLCodeGenerator::writeBoolLiteral(const BoolLiteral& b) {
    this->write(b.fValue ? "true" : "false");
}

void GLSLCodeGenerator::writeIntLiteral(const IntLiteral& i) {
    this->write(to_string(i.fValue));
}

void GLSLCodeGenerator::writeFloatLiteral(const FloatLiteral& f) {
    this->write(to_string(f.fValue));
}

void GLSLCodeGenerator::writeFunction(const FunctionDefinition& f) {
    this->writeType(f.fDeclaration.fReturnType);
    this->write(" " + f.fDeclaration.fName + "(");
    const char* separator = "";
    for (const auto& param : f.fDeclaration.fParameters) {
        this->write(separator);
        separator = ", ";
        this->writeModifiers(param->fModifiers);
        this->writeType(param->fType);
        this->write(" " + param->fName);
    }
    this->write(") ");
    this->writeBlock(*f.fBody);
    this->writeLine();
}

void GLSLCodeGenerator::writeModifiers(const Modifiers& modifiers) {
    this->write(modifiers.description());
}

void GLSLCodeGenerator::writeInterfaceBlock(const InterfaceBlock& intf) {
    if (intf.fVariable.fName == "gl_PerVertex") {
        return;
    }
    this->writeModifiers(intf.fVariable.fModifiers);
    this->writeLine(intf.fVariable.fType.name() + " {");
    fIndentation++;
    for (const auto& f : intf.fVariable.fType.fields()) {
        this->writeModifiers(f.fModifiers);
        this->writeType(*f.fType);
        this->writeLine(" " + f.fName + ";");
    }
    fIndentation--;
    this->writeLine("};");
}

void GLSLCodeGenerator::writeVarDeclarations(const VarDeclarations& decl) {
    ASSERT(decl.fVars.size() > 0);
    this->writeModifiers(decl.fVars[0].fVar->fModifiers);
    this->writeType(decl.fBaseType);
    std::string separator = " ";
    for (const auto& var : decl.fVars) {
        ASSERT(var.fVar->fModifiers == decl.fVars[0].fVar->fModifiers);
        this->write(separator);
        separator = ", ";
        this->write(var.fVar->fName);
        for (const auto& size : var.fSizes) {
            this->write("[");
            this->writeExpression(*size, kTopLevel_Precedence);
            this->write("]");
        }
        if (var.fValue) {
            this->write(" = ");
            this->writeExpression(*var.fValue, kTopLevel_Precedence);
        }
    }
    this->write(";");
}

void GLSLCodeGenerator::writeStatement(const Statement& s) {
    switch (s.fKind) {
        case Statement::kBlock_Kind:
            this->writeBlock((Block&) s);
            break;
        case Statement::kExpression_Kind:
            this->writeExpression(*((ExpressionStatement&) s).fExpression, kTopLevel_Precedence);
            this->write(";");
            break;
        case Statement::kReturn_Kind: 
            this->writeReturnStatement((ReturnStatement&) s);
            break;
        case Statement::kVarDeclarations_Kind:
            this->writeVarDeclarations(*((VarDeclarationsStatement&) s).fDeclaration);
            break;
        case Statement::kIf_Kind:
            this->writeIfStatement((IfStatement&) s);
            break;
        case Statement::kFor_Kind:
            this->writeForStatement((ForStatement&) s);
            break;
        case Statement::kWhile_Kind:
            this->writeWhileStatement((WhileStatement&) s);
            break;
        case Statement::kDo_Kind:
            this->writeDoStatement((DoStatement&) s);
            break;
        case Statement::kBreak_Kind:
            this->write("break;");
            break;
        case Statement::kContinue_Kind:
            this->write("continue;");
            break;
        case Statement::kDiscard_Kind:
            this->write("discard;");
            break;
        default:
            ABORT("unsupported statement: %s", s.description().c_str());
    }
}

void GLSLCodeGenerator::writeBlock(const Block& b) {
    this->writeLine("{");
    fIndentation++;
    for (const auto& s : b.fStatements) {
        this->writeStatement(*s);
        this->writeLine();
    }
    fIndentation--;
    this->write("}");
}

void GLSLCodeGenerator::writeIfStatement(const IfStatement& stmt) {
    this->write("if (");
    this->writeExpression(*stmt.fTest, kTopLevel_Precedence);
    this->write(") ");
    this->writeStatement(*stmt.fIfTrue);
    if (stmt.fIfFalse) {
        this->write(" else ");
        this->writeStatement(*stmt.fIfFalse);
    }
}

void GLSLCodeGenerator::writeForStatement(const ForStatement& f) {
    this->write("for (");
    if (f.fInitializer) {
        this->writeStatement(*f.fInitializer);
    } else {
        this->write("; ");
    }
    if (f.fTest) {
        this->writeExpression(*f.fTest, kTopLevel_Precedence);
    }
    this->write("; ");
    if (f.fNext) {
        this->writeExpression(*f.fNext, kTopLevel_Precedence);
    }
    this->write(") ");
    this->writeStatement(*f.fStatement);
}

void GLSLCodeGenerator::writeWhileStatement(const WhileStatement& w) {
    this->write("while (");
    this->writeExpression(*w.fTest, kTopLevel_Precedence);
    this->write(") ");
    this->writeStatement(*w.fStatement);
}

void GLSLCodeGenerator::writeDoStatement(const DoStatement& d) {
    this->write("do ");
    this->writeStatement(*d.fStatement);
    this->write(" while (");
    this->writeExpression(*d.fTest, kTopLevel_Precedence);
    this->write(");");
}

void GLSLCodeGenerator::writeReturnStatement(const ReturnStatement& r) {
    this->write("return");
    if (r.fExpression) {
        this->write(" ");
        this->writeExpression(*r.fExpression, kTopLevel_Precedence);
    }
    this->write(";");
}

void GLSLCodeGenerator::generateCode(const Program& program, std::ostream& out) {
    ASSERT(fOut == nullptr);
    fOut = &out;
    this->write("#version " + to_string(fCaps.fVersion));
    if (fCaps.fStandard == GLCaps::kGLES_Standard) {
        this->write(" es");
    }
    this->writeLine();
    for (const auto& e : program.fElements) {
        switch (e->fKind) {
            case ProgramElement::kExtension_Kind:
                this->writeExtension((Extension&) *e);
                break;
            case ProgramElement::kVar_Kind: {
                VarDeclarations& decl = (VarDeclarations&) *e;
                if (decl.fVars.size() > 0 && 
                    decl.fVars[0].fVar->fModifiers.fLayout.fBuiltin == -1) {
                    this->writeVarDeclarations(decl);
                    this->writeLine();
                }
                break;
            }
            case ProgramElement::kInterfaceBlock_Kind:
                this->writeInterfaceBlock((InterfaceBlock&) *e);
                break;
            case ProgramElement::kFunction_Kind:
                this->writeFunction((FunctionDefinition&) *e);
                break;
            default:
                printf("%s\n", e->description().c_str());
                ABORT("unsupported program element");
        }
    }
    fOut = nullptr;
}

}
