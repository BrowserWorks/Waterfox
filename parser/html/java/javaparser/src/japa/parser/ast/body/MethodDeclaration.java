/*
 * Copyright (C) 2007 Júlio Vilmar Gesser.
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
package japa.parser.ast.body;

import japa.parser.ast.TypeParameter;
import japa.parser.ast.expr.AnnotationExpr;
import japa.parser.ast.expr.NameExpr;
import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.type.Type;
import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public final class MethodDeclaration extends BodyDeclaration {

    private int modifiers;

    private List<TypeParameter> typeParameters;

    private Type type;

    private String name;

    private List<Parameter> parameters;

    private int arrayCount;

    private List<NameExpr> throws_;

    private BlockStmt body;

    public MethodDeclaration() {
    }

    public MethodDeclaration(int modifiers, Type type, String name) {
        this.modifiers = modifiers;
        this.type = type;
        this.name = name;
    }

    public MethodDeclaration(int modifiers, Type type, String name, List<Parameter> parameters) {
        this.modifiers = modifiers;
        this.type = type;
        this.name = name;
        this.parameters = parameters;
    }

    public MethodDeclaration(JavadocComment javaDoc, int modifiers, List<AnnotationExpr> annotations, List<TypeParameter> typeParameters, Type type, String name, List<Parameter> parameters, int arrayCount, List<NameExpr> throws_, BlockStmt block) {
        super(annotations, javaDoc);
        this.modifiers = modifiers;
        this.typeParameters = typeParameters;
        this.type = type;
        this.name = name;
        this.parameters = parameters;
        this.arrayCount = arrayCount;
        this.throws_ = throws_;
        this.body = block;
    }

    public MethodDeclaration(int beginLine, int beginColumn, int endLine, int endColumn, JavadocComment javaDoc, int modifiers, List<AnnotationExpr> annotations, List<TypeParameter> typeParameters, Type type, String name, List<Parameter> parameters, int arrayCount, List<NameExpr> throws_, BlockStmt block) {
        super(beginLine, beginColumn, endLine, endColumn, annotations, javaDoc);
        this.modifiers = modifiers;
        this.typeParameters = typeParameters;
        this.type = type;
        this.name = name;
        this.parameters = parameters;
        this.arrayCount = arrayCount;
        this.throws_ = throws_;
        this.body = block;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public int getArrayCount() {
        return arrayCount;
    }

    public BlockStmt getBody() {
        return body;
    }

    /**
     * Return the modifiers of this member declaration.
     * 
     * @see ModifierSet
     * @return modifiers
     */
    public int getModifiers() {
        return modifiers;
    }

    public String getName() {
        return name;
    }

    public List<Parameter> getParameters() {
        return parameters;
    }

    public List<NameExpr> getThrows() {
        return throws_;
    }

    public Type getType() {
        return type;
    }

    public List<TypeParameter> getTypeParameters() {
        return typeParameters;
    }

    public void setArrayCount(int arrayCount) {
        this.arrayCount = arrayCount;
    }

    public void setBody(BlockStmt body) {
        this.body = body;
    }

    public void setModifiers(int modifiers) {
        this.modifiers = modifiers;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setParameters(List<Parameter> parameters) {
        this.parameters = parameters;
    }

    public void setThrows(List<NameExpr> throws_) {
        this.throws_ = throws_;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public void setTypeParameters(List<TypeParameter> typeParameters) {
        this.typeParameters = typeParameters;
    }
}
