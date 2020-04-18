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

import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

/**
 * @author Julio Vilmar Gesser
 */
public final class AssignExpr extends Expression {

    public static enum Operator {
        assign, // =
        plus, // +=
        minus, // -=
        star, // *=
        slash, // /=
        and, // &=
        or, // |=
        xor, // ^=
        rem, // %=
        lShift, // <<=
        rSignedShift, // >>=
        rUnsignedShift, // >>>=
    }

    private Expression target;

    private Expression value;

    private Operator op;

    public AssignExpr() {
    }

    public AssignExpr(Expression target, Expression value, Operator op) {
        this.target = target;
        this.value = value;
        this.op = op;
    }

    public AssignExpr(int beginLine, int beginColumn, int endLine, int endColumn, Expression target, Expression value, Operator op) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.target = target;
        this.value = value;
        this.op = op;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public Operator getOperator() {
        return op;
    }

    public Expression getTarget() {
        return target;
    }

    public Expression getValue() {
        return value;
    }

    public void setOperator(Operator op) {
        this.op = op;
    }

    public void setTarget(Expression target) {
        this.target = target;
    }

    public void setValue(Expression value) {
        this.value = value;
    }

}
