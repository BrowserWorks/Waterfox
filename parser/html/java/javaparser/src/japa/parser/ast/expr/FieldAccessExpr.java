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
package japa.parser.ast.expr;

import japa.parser.ast.type.Type;
import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public final class FieldAccessExpr extends Expression {

    private Expression scope;

    private List<Type> typeArgs;

    private String field;

    public FieldAccessExpr() {
    }

    public FieldAccessExpr(Expression scope, String field) {
        this.scope = scope;
        this.field = field;
    }

    public FieldAccessExpr(int beginLine, int beginColumn, int endLine, int endColumn, Expression scope, List<Type> typeArgs, String field) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.scope = scope;
        this.typeArgs = typeArgs;
        this.field = field;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public String getField() {
        return field;
    }

    public Expression getScope() {
        return scope;
    }

    public List<Type> getTypeArgs() {
        return typeArgs;
    }

    public void setField(String field) {
        this.field = field;
    }

    public void setScope(Expression scope) {
        this.scope = scope;
    }

    public void setTypeArgs(List<Type> typeArgs) {
        this.typeArgs = typeArgs;
    }

}
