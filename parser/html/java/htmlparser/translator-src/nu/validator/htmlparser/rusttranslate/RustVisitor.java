/*
 * Copyright (C) 2007 Júlio Vilmar Gesser.
 * Copyright (C) 2012 Mozilla Foundation
 * 
 * This file is part of Java 1.5 parser and Abstract Syntax Tree.
 *
 * Java 1.5 parser and Abstract Syntax Tree is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Java 1.5 parser and Abstract Syntax Tree is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Java 1.5 parser and Abstract Syntax Tree.  If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * Created on 05/10/2006
 */
package nu.validator.htmlparser.rusttranslate;

import japa.parser.ast.BlockComment;
import japa.parser.ast.CompilationUnit;
import japa.parser.ast.LineComment;
import japa.parser.ast.TypeParameter;
import japa.parser.ast.body.BodyDeclaration;
import japa.parser.ast.body.ClassOrInterfaceDeclaration;
import japa.parser.ast.body.ConstructorDeclaration;
import japa.parser.ast.body.EmptyMemberDeclaration;
import japa.parser.ast.body.EmptyTypeDeclaration;
import japa.parser.ast.body.EnumConstantDeclaration;
import japa.parser.ast.body.EnumDeclaration;
import japa.parser.ast.body.FieldDeclaration;
import japa.parser.ast.body.InitializerDeclaration;
import japa.parser.ast.body.JavadocComment;
import japa.parser.ast.body.MethodDeclaration;
import japa.parser.ast.body.ModifierSet;
import japa.parser.ast.body.Parameter;
import japa.parser.ast.body.TypeDeclaration;
import japa.parser.ast.body.VariableDeclarator;
import japa.parser.ast.body.VariableDeclaratorId;
import japa.parser.ast.expr.AnnotationExpr;
import japa.parser.ast.expr.ArrayAccessExpr;
import japa.parser.ast.expr.ArrayCreationExpr;
import japa.parser.ast.expr.ArrayInitializerExpr;
import japa.parser.ast.expr.AssignExpr;
import japa.parser.ast.expr.BinaryExpr;
import japa.parser.ast.expr.BooleanLiteralExpr;
import japa.parser.ast.expr.CastExpr;
import japa.parser.ast.expr.CharLiteralExpr;
import japa.parser.ast.expr.ClassExpr;
import japa.parser.ast.expr.ConditionalExpr;
import japa.parser.ast.expr.DoubleLiteralExpr;
import japa.parser.ast.expr.EnclosedExpr;
import japa.parser.ast.expr.Expression;
import japa.parser.ast.expr.FieldAccessExpr;
import japa.parser.ast.expr.InstanceOfExpr;
import japa.parser.ast.expr.IntegerLiteralExpr;
import japa.parser.ast.expr.IntegerLiteralMinValueExpr;
import japa.parser.ast.expr.LongLiteralExpr;
import japa.parser.ast.expr.LongLiteralMinValueExpr;
import japa.parser.ast.expr.MemberValuePair;
import japa.parser.ast.expr.MethodCallExpr;
import japa.parser.ast.expr.NameExpr;
import japa.parser.ast.expr.NullLiteralExpr;
import japa.parser.ast.expr.ObjectCreationExpr;
import japa.parser.ast.expr.QualifiedNameExpr;
import japa.parser.ast.expr.StringLiteralExpr;
import japa.parser.ast.expr.SuperExpr;
import japa.parser.ast.expr.ThisExpr;
import japa.parser.ast.expr.UnaryExpr;
import japa.parser.ast.expr.UnaryExpr.Operator;
import japa.parser.ast.expr.VariableDeclarationExpr;
import japa.parser.ast.stmt.AssertStmt;
import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.stmt.BreakStmt;
import japa.parser.ast.stmt.CatchClause;
import japa.parser.ast.stmt.ContinueStmt;
import japa.parser.ast.stmt.DoStmt;
import japa.parser.ast.stmt.EmptyStmt;
import japa.parser.ast.stmt.ExplicitConstructorInvocationStmt;
import japa.parser.ast.stmt.ExpressionStmt;
import japa.parser.ast.stmt.ForStmt;
import japa.parser.ast.stmt.ForeachStmt;
import japa.parser.ast.stmt.IfStmt;
import japa.parser.ast.stmt.LabeledStmt;
import japa.parser.ast.stmt.ReturnStmt;
import japa.parser.ast.stmt.Statement;
import japa.parser.ast.stmt.SwitchEntryStmt;
import japa.parser.ast.stmt.SwitchStmt;
import japa.parser.ast.stmt.SynchronizedStmt;
import japa.parser.ast.stmt.ThrowStmt;
import japa.parser.ast.stmt.TryStmt;
import japa.parser.ast.stmt.TypeDeclarationStmt;
import japa.parser.ast.stmt.WhileStmt;
import japa.parser.ast.type.ClassOrInterfaceType;
import japa.parser.ast.type.PrimitiveType;
import japa.parser.ast.type.ReferenceType;
import japa.parser.ast.type.Type;
import japa.parser.ast.type.VoidType;
import japa.parser.ast.type.WildcardType;
import japa.parser.ast.visitor.VoidVisitorAdapter;

import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import nu.validator.htmlparser.cpptranslate.TranslatorUtils;

/**
 * @author Julio Vilmar Gesser
 * @author Henri Sivonen
 */

public final class RustVisitor extends VoidVisitorAdapter<Object> {
    
    private static final String[] MODS = {
        "Tokenizer",
        "TreeBuilder",
        "MetaScanner",
        "AttributeName",
        "ElementName",
        "HtmlAttributes",
        "StackNode",
        "UTF16Buffer",
        "StateSnapshot",
    };
    
    private boolean inMethodSignature = false;
    
    private Set<String> fields = new HashSet<String>();
    
    private Set<String> constants = new HashSet<String>();

    private Expression loopUpdate = null;
    
    private static class SourcePrinter {

        private int level = 0;

        private boolean indented = false;

        private final StringBuilder buf = new StringBuilder();

        public void indent() {
            level++;
        }

        public void unindent() {
            level--;
        }

        private void makeIndent() {
            for (int i = 0; i < level; i++) {
                buf.append("    ");
            }
        }

        public void print(String arg) {
            if (!indented) {
                makeIndent();
                indented = true;
            }
            buf.append(arg);
        }

        public void printLn(String arg) {
            print(arg);
            printLn();
        }

        public void printLn() {
            buf.append("\n");
            indented = false;
        }

        public String getSource() {
            return buf.toString();
        }

        @Override
        public String toString() {
            return getSource();
        }
    }

    private final SourcePrinter printer = new SourcePrinter();

    public String getSource() {
        return printer.getSource();
    }

    private void printModifiers(int modifiers) {
        if (ModifierSet.isPrivate(modifiers)) {
            printer.print("private ");
        }
        if (ModifierSet.isProtected(modifiers)) {
            printer.print("protected ");
        }
        if (ModifierSet.isPublic(modifiers)) {
            printer.print("public ");
        }
        if (ModifierSet.isAbstract(modifiers)) {
            printer.print("abstract ");
        }
        if (ModifierSet.isStatic(modifiers)) {
            printer.print("static ");
        }
        if (ModifierSet.isFinal(modifiers)) {
            printer.print("final ");
        }
        if (ModifierSet.isNative(modifiers)) {
            printer.print("native ");
        }
        if (ModifierSet.isStrictfp(modifiers)) {
            printer.print("strictfp ");
        }
        if (ModifierSet.isSynchronized(modifiers)) {
            printer.print("synchronized ");
        }
        if (ModifierSet.isTransient(modifiers)) {
            printer.print("transient ");
        }
        if (ModifierSet.isVolatile(modifiers)) {
            printer.print("volatile ");
        }
    }

    private void printMethods(List<BodyDeclaration> members, Object arg) {
        for (BodyDeclaration member : members) {
            if (member instanceof MethodDeclaration) {
                MethodDeclaration meth = (MethodDeclaration) member;
                if (meth.getName().startsWith("fatal") || meth.getName().startsWith("err")
                        || meth.getName().startsWith("warn")
                        || meth.getName().startsWith("maybeErr")
                        || meth.getName().startsWith("maybeWarn")
                        || meth.getName().startsWith("note")
                        || "releaseArray".equals(meth.getName())
                        || "deleteArray".equals(meth.getName())
                        || "delete".equals(meth.getName())) {
                    continue;
                }
                printer.printLn();
                member.accept(this, arg);
                printer.printLn();
            }
        }
    }

    private void printFields(List<BodyDeclaration> members, Object arg) {
        for (BodyDeclaration member : members) {
            if (member instanceof FieldDeclaration) {
                FieldDeclaration field = (FieldDeclaration) member;
                int mods = field.getModifiers();
                if (ModifierSet.isStatic(mods) && ModifierSet.isFinal(mods)) {
                    continue;
                }
                fields.add(field.getVariables().get(0).getId().getName());
                printer.printLn();
                member.accept(this, arg);
                printer.printLn();                
            }
        }
    }

    private void printConstants(List<BodyDeclaration> members, Object arg) {
        for (BodyDeclaration member : members) {
            if (member instanceof FieldDeclaration) {
                FieldDeclaration field = (FieldDeclaration) member;
                int mods = field.getModifiers();
                if (!(ModifierSet.isStatic(mods) && ModifierSet.isFinal(mods))) {
                    continue;
                }
                constants.add(field.getVariables().get(0).getId().getName());
                printer.printLn();
                member.accept(this, arg);
                printer.printLn();                
            }
        }
    }
    
    private void printMemberAnnotations(List<AnnotationExpr> annotations, Object arg) {
        if (annotations != null) {
            for (AnnotationExpr a : annotations) {
                a.accept(this, arg);
                printer.printLn();
            }
        }
    }

    private void printArguments(List<Expression> args, Object arg) {
        printer.print("(");
        if (args != null) {
            for (Iterator<Expression> i = args.iterator(); i.hasNext();) {
                Expression e = i.next();
                e.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }
        printer.print(")");
    }

    private void printJavadoc(JavadocComment javadoc, Object arg) {
        if (javadoc != null) {
            javadoc.accept(this, arg);
        }
    }

    public void visit(CompilationUnit n, Object arg) {
        if (n.getTypes() != null) {
            for (Iterator<TypeDeclaration> i = n.getTypes().iterator(); i.hasNext();) {
                i.next().accept(this, arg);
                printer.printLn();
                if (i.hasNext()) {
                    printer.printLn();
                }
            }
        }
    }

    public void visit(NameExpr n, Object arg) {
        if (fields.contains(n.getName())) {
            printer.print("self.");
        }
        printer.print(n.getName());
    }

    public void visit(QualifiedNameExpr n, Object arg) {
        n.getQualifier().accept(this, arg);
        printer.print(".");
        printer.print(n.getName());
    }

    public void visit(ClassOrInterfaceDeclaration n, Object arg) {
        for (int i = 0; i < MODS.length; i++) {
            String mod = MODS[i];
            if (!mod.equals(n.getName())) {
                printer.print("mod ");
                printer.print(mod);
                printer.printLn(";");
            }
        }
        
        printJavadoc(n.getJavaDoc(), arg);


        if (n.getMembers() != null) {
            printConstants(n.getMembers(), arg);
        }
        printer.printLn();
        printer.printLn();

        printer.print("struct ");

        printer.print(n.getName());

        printer.printLn(" {");
        printer.indent();
        if (n.getMembers() != null) {
            printFields(n.getMembers(), arg);
        }
        printer.unindent();
        printer.print("}");

        printer.printLn();
        printer.printLn();
        
        printer.print("impl ");

        printer.print(n.getName());

        printer.printLn(" {");
        printer.indent();
        if (n.getMembers() != null) {
            printMethods(n.getMembers(), arg);
        }
        printer.unindent();
        printer.print("}");

    }

    public void visit(EmptyTypeDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        printer.print(";");
    }

    public void visit(JavadocComment n, Object arg) {
        printer.print("/**");
        printer.print(n.getContent());
        printer.printLn("*/");
    }

    public void visit(ClassOrInterfaceType n, Object arg) {
        if (n.getScope() != null) {
            n.getScope().accept(this, arg);
            printer.print(".");
        }
        printer.print(n.getName());
    }

    public void visit(TypeParameter n, Object arg) {
        printer.print(n.getName());
        if (n.getTypeBound() != null) {
            printer.print(" extends ");
            for (Iterator<ClassOrInterfaceType> i = n.getTypeBound().iterator(); i.hasNext();) {
                ClassOrInterfaceType c = i.next();
                c.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(" & ");
                }
            }
        }
    }

    public void visit(PrimitiveType n, Object arg) {
        switch (n.getType()) {
            case Boolean:
                printer.print("bool");
                break;
            case Byte:
                printer.print("i8");
                break;
            case Char:
                printer.print("u16");
                break;
            case Double:
                printer.print("f64");
                break;
            case Float:
                printer.print("f32");
                break;
            case Int:
                printer.print("i32");
                break;
            case Long:
                printer.print("i64");
                break;
            case Short:
                printer.print("i16");
                break;
        }
    }

    public void visit(ReferenceType n, Object arg) {
//        if (inMethodSignature) {
//            printer.print("&");
//        } else {
//            printer.print("~");            
//        }
        printer.print("@");
        for (int i = 0; i < n.getArrayCount(); i++) {
            printer.print("[");
        }
        n.getType().accept(this, arg);
        for (int i = 0; i < n.getArrayCount(); i++) {
            printer.print("]");
        }
    }

    public void visit(WildcardType n, Object arg) {
        printer.print("?");
        if (n.getExtends() != null) {
            printer.print(" extends ");
            n.getExtends().accept(this, arg);
        }
        if (n.getSuper() != null) {
            printer.print(" super ");
            n.getSuper().accept(this, arg);
        }
    }

    public void visit(FieldDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
//        printMemberAnnotations(n.getAnnotations(), arg);
        
        boolean field = true;
        int mods = n.getModifiers();
        if (ModifierSet.isStatic(mods) && ModifierSet.isFinal(mods)) {
            if (!ModifierSet.isPrivate(mods)) {
                printer.print("pub ");
            }
            printer.print("const ");
            field = false;
        } else if (!ModifierSet.isFinal(mods)) {
            printer.print("mut ");
        }
        
        List<VariableDeclarator> vars = n.getVariables();
        
        printVariableDeclarator(n.getType(), vars, arg, field);

        printer.print(field ? "," : ";");
    }

    private void printVariableDeclarator(Type type, List<VariableDeclarator> vars,
            Object arg, boolean field) {
        if (vars.size() != 1) {
            throw new RuntimeException();            
        }
        
        VariableDeclarator decl = vars.get(0);
        
        VariableDeclaratorId id = decl.getId();
        
        printer.print(id.getName());
        
        printer.print(": ");
        
        for (int i = 0; i < id.getArrayCount(); i++) {
            printer.print("[");
        }
        
        type.accept(this, arg);

        for (int i = 0; i < id.getArrayCount(); i++) {
            printer.print("]");
        }
        
        Expression init = decl.getInit();
        
        if (init != null && !field) {
            printer.print(" = ");
            init.accept(this, arg);
        }
    }

    public void visit(ArrayInitializerExpr n, Object arg) {
        printer.print("[");
        if (n.getValues() != null) {
            printer.print(" ");
            for (Iterator<Expression> i = n.getValues().iterator(); i.hasNext();) {
                Expression expr = i.next();
                expr.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
            printer.print(" ");
        }
        printer.print("]");
    }

    public void visit(VoidType n, Object arg) {
        printer.print("void");
    }

    public void visit(ArrayAccessExpr n, Object arg) {
        n.getName().accept(this, arg);
        printer.print("[");
        n.getIndex().accept(this, arg);
        printer.print("]");
    }

    public void visit(ArrayCreationExpr n, Object arg) {
        printer.print("new ");
        n.getType().accept(this, arg);

        if (n.getDimensions() != null) {
            for (Expression dim : n.getDimensions()) {
                printer.print("[");
                dim.accept(this, arg);
                printer.print("]");
            }
            for (int i = 0; i < n.getArrayCount(); i++) {
                printer.print("[]");
            }
        } else {
            for (int i = 0; i < n.getArrayCount(); i++) {
                printer.print("[]");
            }
            printer.print(" ");
            n.getInitializer().accept(this, arg);
        }
    }

    public void visit(AssignExpr n, Object arg) {
        n.getTarget().accept(this, arg);
        printer.print(" ");
        switch (n.getOperator()) {
            case assign:
                printer.print("=");
                break;
            case and:
                printer.print("&=");
                break;
            case or:
                printer.print("|=");
                break;
            case xor:
                printer.print("^=");
                break;
            case plus:
                printer.print("+=");
                break;
            case minus:
                printer.print("-=");
                break;
            case rem:
                printer.print("%=");
                break;
            case slash:
                printer.print("/=");
                break;
            case star:
                printer.print("*=");
                break;
            case lShift:
                printer.print("<<=");
                break;
            case rSignedShift:
                printer.print(">>=");
                break;
            case rUnsignedShift:
                printer.print(">>>=");
                break;
        }
        printer.print(" ");
        n.getValue().accept(this, arg);
    }

    public void visit(BinaryExpr n, Object arg) {
        n.getLeft().accept(this, arg);
        printer.print(" ");
        switch (n.getOperator()) {
            case or:
                printer.print("||");
                break;
            case and:
                printer.print("&&");
                break;
            case binOr:
                printer.print("|");
                break;
            case binAnd:
                printer.print("&");
                break;
            case xor:
                printer.print("^");
                break;
            case equals:
                printer.print("==");
                break;
            case notEquals:
                printer.print("!=");
                break;
            case less:
                printer.print("<");
                break;
            case greater:
                printer.print(">");
                break;
            case lessEquals:
                printer.print("<=");
                break;
            case greaterEquals:
                printer.print(">=");
                break;
            case lShift:
                printer.print("<<");
                break;
            case rSignedShift:
                printer.print(">>");
                break;
            case rUnsignedShift:
                printer.print(">>>");
                break;
            case plus:
                printer.print("+");
                break;
            case minus:
                printer.print("-");
                break;
            case times:
                printer.print("*");
                break;
            case divide:
                printer.print("/");
                break;
            case remainder:
                printer.print("%");
                break;
        }
        printer.print(" ");
        n.getRight().accept(this, arg);
    }

    public void visit(CastExpr n, Object arg) {
        printer.print("(");
        n.getType().accept(this, arg);
        printer.print(") ");
        n.getExpr().accept(this, arg);
    }

    public void visit(ClassExpr n, Object arg) {
        n.getType().accept(this, arg);
        printer.print(".class");
    }

    public void visit(ConditionalExpr n, Object arg) {
        n.getCondition().accept(this, arg);
        printer.print(" ? ");
        n.getThenExpr().accept(this, arg);
        printer.print(" : ");
        n.getElseExpr().accept(this, arg);
    }

    public void visit(EnclosedExpr n, Object arg) {
        printer.print("(");
        n.getInner().accept(this, arg);
        printer.print(")");
    }

    public void visit(FieldAccessExpr n, Object arg) {
        String scope = n.getScope().toString();
        printer.print(scope);
        boolean mod = false;
        for (int i = 0; i < MODS.length; i++) {
            if (MODS[i].equals(scope)) {
                mod = true;
                break;
            }
        }
        printer.print(mod ? "::" : ".");
        if ("length".equals(n.getField())) {
            printer.print("len() as i32");
        } else {
            printer.print(n.getField());
        }
    }

    public void visit(InstanceOfExpr n, Object arg) {
        n.getExpr().accept(this, arg);
        printer.print(" instanceof ");
        n.getType().accept(this, arg);
    }

    public void visit(CharLiteralExpr n, Object arg) {
//        printer.print("'");
//        char c = n.getValue().charAt(0);
//        switch (c) {
//            case '\b':
//                printer.print("\\b");
//                break;
//            case '\t':
//                printer.print("\\t");
//                break;
//            case '\n':
//                printer.print("\\n");
//                break;
//            case '\f':
//                printer.print("\\f");
//                break;
//            case '\r':
//                printer.print("\\r");
//                break;
//            case '\'':
//                printer.print("\\'");
//                break;
//            case '\\':
//                printer.print(n.getValue());
//                break;
//            default:
//                if (c < ' ' || c > '~') {
//                    String hex = Integer.toHexString(c);
//                    switch (hex.length()) {
//                        case 1:
//                            printer.print("\\u000"+hex);
//                            break;
//                        case 2:
//                            printer.print("\\u00"+hex);
//                            break;
//                        case 3:
//                            printer.print("\\u0"+hex);
//                            break;
//                        case 4:
//                            printer.print("\\u"+hex);
//                            break;
//                    }
//                } else {
//                    printer.print(""+c);
//                }
//                break;
//        }   
//        printer.print("'");
        String str = n.getValue();
        if (str.length() == 1) {
            String hex = Integer.toHexString(str.charAt(0));
            switch (hex.length()) {
                case 1:
                    printer.print("0x0"+hex);
                    break;
                case 2:
                    printer.print("0x"+hex);
                    break;
                case 3:
                    printer.print("0x0"+hex);
                    break;
                case 4:
                    printer.print("0x"+hex);
                    break;
            }
        } else if ("\\n".equals(str)) {
            printer.print("0x0A");
        } else if ("\\r".equals(str)) {
            printer.print("0x0D");
        } else if ("\\t".equals(str)) {
            printer.print("0x09");
        } else if ("\\\"".equals(str)) {
            printer.print("0x22");
        } else if ("\\'".equals(str)) {
            printer.print("0x27");
        } else {
            throw new RuntimeException(str);
        }
    }

    public void visit(DoubleLiteralExpr n, Object arg) {
        printer.print(n.getValue());
    }

    public void visit(IntegerLiteralExpr n, Object arg) {
        printer.print(n.getValue());
    }

    public void visit(LongLiteralExpr n, Object arg) {
        printer.print(n.getValue());
    }

    public void visit(IntegerLiteralMinValueExpr n, Object arg) {
        printer.print(n.getValue());
    }

    public void visit(LongLiteralMinValueExpr n, Object arg) {
        printer.print(n.getValue());
    }

    public void visit(StringLiteralExpr n, Object arg) {
        printer.print("\"");
        printer.print(n.getValue());
        printer.print("\"");
    }

    public void visit(BooleanLiteralExpr n, Object arg) {
        printer.print(String.valueOf(n.getValue()));
    }

    public void visit(NullLiteralExpr n, Object arg) {
        printer.print("null");
    }

    public void visit(ThisExpr n, Object arg) {
        if (n.getClassExpr() != null) {
            n.getClassExpr().accept(this, arg);
            printer.print(".");
        }
        printer.print("self");
    }

    public void visit(SuperExpr n, Object arg) {
        if (n.getClassExpr() != null) {
            n.getClassExpr().accept(this, arg);
            printer.print(".");
        }
        printer.print("super");
    }

    public void visit(MethodCallExpr n, Object arg) {
        if (n.getScope() != null) {
            n.getScope().accept(this, arg);
            printer.print(".");
        }
        printer.print(n.getName());
        printArguments(n.getArgs(), arg);
    }

    public void visit(ObjectCreationExpr n, Object arg) {
        if (n.getScope() != null) {
            n.getScope().accept(this, arg);
            printer.print(".");
        }

        printer.print("new ");

        n.getType().accept(this, arg);

        printArguments(n.getArgs(), arg);

        if (n.getAnonymousClassBody() != null) {
            printer.printLn(" {");
            printer.indent();
            printMethods(n.getAnonymousClassBody(), arg);
            printer.unindent();
            printer.print("}");
        }
    }

    public void visit(UnaryExpr n, Object arg) {
        Operator op = n.getOperator();
        if (op == null) {
            n.getExpr().accept(this, arg);
            return;
        }
        switch (op) {
            case positive:
                printer.print("+");
                n.getExpr().accept(this, arg);
                break;
            case negative:
                printer.print("-");
                n.getExpr().accept(this, arg);
                break;
            case inverse:
                printer.print("i32::compl(");
                n.getExpr().accept(this, arg);
                printer.print(")");
                break;
            case not:
                printer.print("!");
                n.getExpr().accept(this, arg);
                break;
            case preIncrement:
            case posIncrement:
                n.getExpr().accept(this, arg);
                printer.print(" = ");
                n.getExpr().accept(this, arg);
                printer.print(" + 1");
                break;
            case preDecrement:
            case posDecrement:
                n.getExpr().accept(this, arg);
                printer.print(" = ");
                n.getExpr().accept(this, arg);
                printer.print(" - 1");
                break;
        }
    }

    public void visit(ConstructorDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        printMemberAnnotations(n.getAnnotations(), arg);
        printModifiers(n.getModifiers());

        if (n.getTypeParameters() != null) {
            printer.print(" ");
        }
        printer.print(n.getName());

        printer.print("(");
        if (n.getParameters() != null) {
            for (Iterator<Parameter> i = n.getParameters().iterator(); i.hasNext();) {
                Parameter p = i.next();
                p.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }
        printer.print(")");

        if (n.getThrows() != null) {
            printer.print(" throws ");
            for (Iterator<NameExpr> i = n.getThrows().iterator(); i.hasNext();) {
                NameExpr name = i.next();
                name.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }
        printer.print(" ");
        n.getBlock().accept(this, arg);
    }

    public void visit(MethodDeclaration n, Object arg) {

        printJavadoc(n.getJavaDoc(), arg);
//        printMemberAnnotations(n.getAnnotations(), arg);
//        printModifiers(n.getModifiers());

//        printTypeParameters(n.getTypeParameters(), arg);
//        if (n.getTypeParameters() != null) {
//            printer.print(" ");
//        }

        printer.print("fn ");
        printer.print(n.getName());

        printer.print("(");
        inMethodSignature = true;
        if (n.getParameters() != null) {
            for (Iterator<Parameter> i = n.getParameters().iterator(); i.hasNext();) {
                Parameter p = i.next();
                p.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }
        inMethodSignature = false;
        printer.print(")");

        Type type = n.getType();
        
        if (!(type instanceof VoidType)) {
            printer.print(" -> ");
            type.accept(this, arg);
        }
        
//        for (int i = 0; i < n.getArrayCount(); i++) {
//            printer.print("[]");
//        }

//        if (n.getThrows() != null) {
//            printer.print(" throws ");
//            for (Iterator<NameExpr> i = n.getThrows().iterator(); i.hasNext();) {
//                NameExpr name = i.next();
//                name.accept(this, arg);
//                if (i.hasNext()) {
//                    printer.print(", ");
//                }
//            }
//        }
        if (n.getBody() == null) {
            printer.print(";");
        } else {
            printer.print(" ");
            n.getBody().accept(this, arg);
        }
    }

    public void visit(Parameter n, Object arg) {
//        printAnnotations(n.getAnnotations(), arg);
//        printModifiers(n.getModifiers());

        VariableDeclaratorId id = n.getId();
        
        printer.print(id.getName());
//        if (n.isVarArgs()) {
//            printer.print("...");
//        }
        printer.print(": ");
        n.getType().accept(this, arg);
    }

    public void visit(ExplicitConstructorInvocationStmt n, Object arg) {
        if (n.isThis()) {
            printer.print("this");
        } else {
            if (n.getExpr() != null) {
                n.getExpr().accept(this, arg);
                printer.print(".");
            }
            printer.print("super");
        }
        printArguments(n.getArgs(), arg);
        printer.print(";");
    }

    public void visit(VariableDeclarationExpr n, Object arg) {
//        printAnnotations(n.getAnnotations(), arg);
        
        printer.print("let ");
        
        if (!ModifierSet.isFinal(n.getModifiers())) {
            printer.print("mut ");
        }
        
//        printModifiers(n.getModifiers());

        List<VariableDeclarator> vars = n.getVars();
        
        printVariableDeclarator(n.getType(), vars, arg, false);
    }

    public void visit(TypeDeclarationStmt n, Object arg) {
        n.getTypeDeclaration().accept(this, arg);
    }

    public void visit(AssertStmt n, Object arg) {
        Expression check = n.getCheck();
        if (check instanceof BooleanLiteralExpr) {
            BooleanLiteralExpr bool = (BooleanLiteralExpr) check;
            if (!bool.getValue()) {
                printer.print("fail;");                
                return;
            }
        }
        printer.print("assert ");
        check.accept(this, arg);
        printer.print(";");
    }

    public void visit(BlockStmt n, Object arg) {
        printer.printLn("{");
        if (n.getStmts() != null) {
            printer.indent();
            for (Statement s : n.getStmts()) {
                s.accept(this, arg);
                printer.printLn();
            }
            printer.unindent();
        }
        printer.print("}");
    }

    public void visit(LabeledStmt n, Object arg) {
        assert arg == null;
        n.getStmt().accept(this, n.getLabel());
    }

    public void visit(EmptyStmt n, Object arg) {
        printer.print(";");
    }

    public void visit(ExpressionStmt n, Object arg) {
        Expression plusplus = null;
        Expression ex = n.getExpression();
        
        if (ex instanceof MethodCallExpr) {
            MethodCallExpr meth = (MethodCallExpr) ex;
            if (meth.getName().startsWith("fatal") || meth.getName().startsWith("err")
                    || meth.getName().startsWith("warn")
                    || meth.getName().startsWith("maybeErr")
                    || meth.getName().startsWith("maybeWarn")
                    || meth.getName().startsWith("note")
                    || "releaseArray".equals(meth.getName())
                    || "deleteArray".equals(meth.getName())
                    || "delete".equals(meth.getName())) {
                return;
            }
        }
        
        if (ex instanceof AssignExpr) {
            AssignExpr ax = (AssignExpr) ex;
            Expression left = ax.getTarget();
            if (left instanceof ArrayAccessExpr) {
                ArrayAccessExpr aae = (ArrayAccessExpr) left;
                Expression index = aae.getIndex();
                if (index instanceof UnaryExpr) {
                    UnaryExpr unex = (UnaryExpr) index;
                    if (unex.getOperator() == Operator.posIncrement) {
                        plusplus = unex.getExpr();
                        unex.setOperator(null);
                    }
                }
            }
        }
        n.getExpression().accept(this, arg);
        printer.print(";");
        if (plusplus != null) {
            printer.printLn();
            plusplus.accept(this, arg);
            printer.print(" = ");
            plusplus.accept(this, arg);
            printer.print(" + 1;");
        }
    }

    public void visit(SwitchStmt n, Object arg) {
        printer.print("match ");
        n.getSelector().accept(this, arg);
        printer.printLn(" {");
        if (n.getEntries() != null) {
            printer.indent();
            List<Expression> labels = new LinkedList<Expression>();
            for (SwitchEntryStmt e : n.getEntries()) {
                labels.add(e.getLabel());
                List<Statement> stmts = e.getStmts();
                if (stmts != null) {
                    if (stmts.get(stmts.size() - 1) instanceof BreakStmt) {
                        BreakStmt brk = (BreakStmt)stmts.get(stmts.size() - 1);
                        if (brk.getId() == null) {
                            stmts.remove(stmts.size() - 1);
                        }
                    }
                    if (!stmts.isEmpty()) {
                        boolean first = true;
                        for (Expression label : labels) {
                            if (!first) {
                                printer.print(" | ");
                            }
                            first = false;
                            if (label == null) {
                                printer.print("_");
                            } else {
                                label.accept(this, arg);
                            }
                        }
                        printer.printLn(" => {");
                        printer.indent();
                        for (Statement statement : stmts) {
                            statement.accept(this, arg);
                            printer.printLn();
                        }
                        printer.unindent();
                        printer.printLn("}");
                    }
                    labels.clear();
                }
            }
            printer.unindent();
        }
        printer.print("}");

    }

    public void visit(SwitchEntryStmt n, Object arg) {
        throw new RuntimeException("Not supposed to come here.");
    }

    public void visit(BreakStmt n, Object arg) {
        printer.print("break");
        if (n.getId() != null && !"charsetloop".equals(n.getId()) && !"charactersloop".equals(n.getId())) {
            printer.print(" ");
            printer.print(n.getId());
        }
        printer.print(";");
    }

    public void visit(ReturnStmt n, Object arg) {
        printer.print("return");
        if (n.getExpr() != null) {
            printer.print(" ");
            n.getExpr().accept(this, arg);
        }
        printer.print(";");
    }

    public void visit(EnumDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        printMemberAnnotations(n.getAnnotations(), arg);
        printModifiers(n.getModifiers());

        printer.print("enum ");
        printer.print(n.getName());

        if (n.getImplements() != null) {
            printer.print(" implements ");
            for (Iterator<ClassOrInterfaceType> i = n.getImplements().iterator(); i.hasNext();) {
                ClassOrInterfaceType c = i.next();
                c.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }

        printer.printLn(" {");
        printer.indent();
        if (n.getEntries() != null) {
            printer.printLn();
            for (Iterator<EnumConstantDeclaration> i = n.getEntries().iterator(); i.hasNext();) {
                EnumConstantDeclaration e = i.next();
                e.accept(this, arg);
                if (i.hasNext()) {
                    printer.print(", ");
                }
            }
        }
        if (n.getMembers() != null) {
            printer.printLn(";");
            printMethods(n.getMembers(), arg);
        } else {
            if (n.getEntries() != null) {
                printer.printLn();
            }
        }
        printer.unindent();
        printer.print("}");
        throw new RuntimeException("Unsupported syntax.");
    }

    public void visit(EnumConstantDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        printMemberAnnotations(n.getAnnotations(), arg);
        printer.print(n.getName());

        if (n.getArgs() != null) {
            printArguments(n.getArgs(), arg);
        }

        if (n.getClassBody() != null) {
            printer.printLn(" {");
            printer.indent();
            printMethods(n.getClassBody(), arg);
            printer.unindent();
            printer.printLn("}");
        }
        throw new RuntimeException("Unsupported syntax.");
    }

    public void visit(EmptyMemberDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        printer.print(";");
    }

    public void visit(InitializerDeclaration n, Object arg) {
        printJavadoc(n.getJavaDoc(), arg);
        if (n.isStatic()) {
            printer.print("static ");
        }
        n.getBlock().accept(this, arg);
    }

    public void visit(IfStmt n, Object arg) {
        Expression cond = n.getCondition();
        if (cond instanceof BinaryExpr) {
            BinaryExpr binex = (BinaryExpr) cond;
            Expression left = binex.getLeft();
            if (left instanceof UnaryExpr) {
                UnaryExpr unex = (UnaryExpr) left;
                if (unex.getOperator() == Operator.preIncrement) {
                    unex.getExpr().accept(this, arg);
                    printer.print(" = ");
                    unex.getExpr().accept(this, arg);
                    printer.printLn(" + 1;");
                    unex.setOperator(null);
                }
            }
        }
        
        if (!TranslatorUtils.isErrorHandlerIf(n.getCondition(), false)) {
            if (TranslatorUtils.isErrorOnlyBlock(n.getThenStmt(), false)) {
                if (n.getElseStmt() != null
                        && !TranslatorUtils.isErrorOnlyBlock(n.getElseStmt(), false)) {
                    printer.print("if ");
                    if (n.getCondition() instanceof BinaryExpr) {
                        BinaryExpr binExpr = (BinaryExpr) n.getCondition();
                        switch (binExpr.getOperator()) {
                            case equals:
                                binExpr.getLeft().accept(this, arg);
                                printer.print(" != ");
                                binExpr.getRight().accept(this, arg);
                                break;
                            case notEquals:
                                binExpr.getLeft().accept(this, arg);
                                printer.print(" == ");
                                binExpr.getRight().accept(this, arg);
                                break;
                            default:
                                printer.print("!(");
                                n.getCondition().accept(this, arg);
                                printer.print(")");
                                break;
                        }
                    } else {
                        printer.print("!(");
                        n.getCondition().accept(this, arg);
                        printer.print(")");
                    }
                    printer.print(" ");
                    n.getElseStmt().accept(this, arg);
                }
            } else {
                printer.print("if ");
                n.getCondition().accept(this, arg);
                printer.print(" ");
                n.getThenStmt().accept(this, arg);
                if (n.getElseStmt() != null
                        && !TranslatorUtils.isErrorOnlyBlock(n.getElseStmt(), false)) {
                    printer.print(" else ");
                    n.getElseStmt().accept(this, arg);
                }
            }
        }

    }

    public void visit(WhileStmt n, Object arg) {
        printer.print("while ");
        n.getCondition().accept(this, arg);
        printer.print(" ");
        n.getBody().accept(this, arg);
    }

    public void visit(ContinueStmt n, Object arg) {
        if (loopUpdate != null) {
            loopUpdate.accept(this, arg);
            printer.printLn(";");
        }
        printer.print("loop");
        if (n.getId() != null) {
            printer.print(" ");
            printer.print(n.getId());
        }
        printer.print(";");
    }

    public void visit(DoStmt n, Object arg) {
        printer.print("do ");
        n.getBody().accept(this, arg);
        printer.print(" while (");
        n.getCondition().accept(this, arg);
        printer.print(");");
        throw new RuntimeException("Unsupported syntax.");
    }

    public void visit(ForeachStmt n, Object arg) {
        printer.print("for (");
        n.getVariable().accept(this, arg);
        printer.print(" : ");
        n.getIterable().accept(this, arg);
        printer.print(") ");
        n.getBody().accept(this, arg);
        throw new RuntimeException("Unsupported syntax.");
    }

    public void visit(ForStmt n, Object arg) {
        String label = null;
        if (arg instanceof String) {
            label = (String) arg;
            arg = null;
        }
        if (n.getInit() == null && n.getCompare() == null && n.getUpdate() == null) {
            printer.print("loop ");
            if (label != null) {
                printer.print(label);
                printer.print(": ");
            }
            n.getBody().accept(this, arg);
            return;
        }
        
        assert label == null || "charsetloop".equals(label) || "charactersloop".equals(label);
        
        Expression oldLoopUpdate = loopUpdate;
        loopUpdate = n.getUpdate().get(0);
        
        if (n.getInit() != null) {
            n.getInit().get(0).accept(this, arg);
            printer.printLn(";");
        }
        
        if (n.getCompare() == null) {
            printer.print("loop ");
        } else {
            printer.print("while ");
            n.getCompare().accept(this, arg);
            printer.print(" ");
        }
        
        Statement body = n.getBody();
        if (body instanceof BlockStmt) {
            BlockStmt blockStmt = (BlockStmt) body;
            printer.printLn("{");
            printer.indent();
            if (blockStmt.getStmts() != null) {
                for (Statement s : blockStmt.getStmts()) {
                    s.accept(this, arg);
                    printer.printLn();
                }
            }
            if (loopUpdate != null) {
                loopUpdate.accept(this, arg);
                printer.printLn(";");
            }
            printer.unindent();
            printer.print("}");    
        } else {
            throw new RuntimeException();
        }
        
        loopUpdate = oldLoopUpdate;
    }

    public void visit(ThrowStmt n, Object arg) {
        printer.print("throw ");
        n.getExpr().accept(this, arg);
        printer.print(";");
    }

    public void visit(SynchronizedStmt n, Object arg) {
        printer.print("synchronized (");
        n.getExpr().accept(this, arg);
        printer.print(") ");
        n.getBlock().accept(this, arg);
    }

    public void visit(TryStmt n, Object arg) {
        printer.print("try ");
        n.getTryBlock().accept(this, arg);
        if (n.getCatchs() != null) {
            for (CatchClause c : n.getCatchs()) {
                c.accept(this, arg);
            }
        }
        if (n.getFinallyBlock() != null) {
            printer.print(" finally ");
            n.getFinallyBlock().accept(this, arg);
        }
    }

    public void visit(CatchClause n, Object arg) {
        printer.print(" catch (");
        n.getExcept().accept(this, arg);
        printer.print(") ");
        n.getCatchBlock().accept(this, arg);

    }

//    public void visit(AnnotationDeclaration n, Object arg) {
//        printJavadoc(n.getJavaDoc(), arg);
//        printMemberAnnotations(n.getAnnotations(), arg);
//        printModifiers(n.getModifiers());
//
//        printer.print("@interface ");
//        printer.print(n.getName());
//        printer.printLn(" {");
//        printer.indent();
//        if (n.getMembers() != null) {
//            printMembers(n.getMembers(), arg);
//        }
//        printer.unindent();
//        printer.print("}");
//    }
//
//    public void visit(AnnotationMemberDeclaration n, Object arg) {
//        printJavadoc(n.getJavaDoc(), arg);
//        printMemberAnnotations(n.getAnnotations(), arg);
//        printModifiers(n.getModifiers());
//
//        n.getType().accept(this, arg);
//        printer.print(" ");
//        printer.print(n.getName());
//        printer.print("()");
//        if (n.getDefaultValue() != null) {
//            printer.print(" default ");
//            n.getDefaultValue().accept(this, arg);
//        }
//        printer.print(";");
//    }
//
//    public void visit(MarkerAnnotationExpr n, Object arg) {
//        printer.print("@");
//        n.getName().accept(this, arg);
//    }
//
//    public void visit(SingleMemberAnnotationExpr n, Object arg) {
//        printer.print("@");
//        n.getName().accept(this, arg);
//        printer.print("(");
//        n.getMemberValue().accept(this, arg);
//        printer.print(")");
//    }
//
//    public void visit(NormalAnnotationExpr n, Object arg) {
//        printer.print("@");
//        n.getName().accept(this, arg);
//        printer.print("(");
//        if (n.getPairs() != null) {
//            for (Iterator<MemberValuePair> i = n.getPairs().iterator(); i.hasNext();) {
//                MemberValuePair m = i.next();
//                m.accept(this, arg);
//                if (i.hasNext()) {
//                    printer.print(", ");
//                }
//            }
//        }
//        printer.print(")");
//    }

    public void visit(MemberValuePair n, Object arg) {
        printer.print(n.getName());
        printer.print(" = ");
        n.getValue().accept(this, arg);
    }

    public void visit(LineComment n, Object arg) {
        printer.print("//");
        printer.printLn(n.getContent());
    }

    public void visit(BlockComment n, Object arg) {
        printer.print("/*");
        printer.print(n.getContent());
        printer.printLn("*/");
    }

}