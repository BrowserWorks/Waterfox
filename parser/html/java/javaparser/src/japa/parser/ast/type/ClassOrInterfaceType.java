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
package japa.parser.ast.type;

import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public final class ClassOrInterfaceType extends Type {

    private ClassOrInterfaceType scope;

    private String name;

    private List<Type> typeArgs;

    public ClassOrInterfaceType() {
    }

    public ClassOrInterfaceType(String name) {
        this.name = name;
    }

    public ClassOrInterfaceType(ClassOrInterfaceType scope, String name) {
        this.scope = scope;
        this.name = name;
    }

    public ClassOrInterfaceType(int beginLine, int beginColumn, int endLine, int endColumn, ClassOrInterfaceType scope, String name, List<Type> typeArgs) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.scope = scope;
        this.name = name;
        this.typeArgs = typeArgs;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public String getName() {
        return name;
    }

    public ClassOrInterfaceType getScope() {
        return scope;
    }

    public List<Type> getTypeArgs() {
        return typeArgs;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setScope(ClassOrInterfaceType scope) {
        this.scope = scope;
    }

    public void setTypeArgs(List<Type> typeArgs) {
        this.typeArgs = typeArgs;
    }
}
