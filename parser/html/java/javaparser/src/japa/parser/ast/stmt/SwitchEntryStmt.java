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
 * Created on 04/11/2006
 */
package japa.parser.ast.stmt;

import japa.parser.ast.expr.Expression;
import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public final class SwitchEntryStmt extends Statement {

    private Expression label;

    private List<Statement> stmts;

    public SwitchEntryStmt() {
    }

    public SwitchEntryStmt(Expression label, List<Statement> stmts) {
        this.label = label;
        this.stmts = stmts;
    }

    public SwitchEntryStmt(int beginLine, int beginColumn, int endLine, int endColumn, Expression label, List<Statement> stmts) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.label = label;
        this.stmts = stmts;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public Expression getLabel() {
        return label;
    }

    public List<Statement> getStmts() {
        return stmts;
    }

    public void setLabel(Expression label) {
        this.label = label;
    }

    public void setStmts(List<Statement> stmts) {
        this.stmts = stmts;
    }
}
