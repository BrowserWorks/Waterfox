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
public final class SwitchStmt extends Statement {

    private Expression selector;

    private List<SwitchEntryStmt> entries;

    public SwitchStmt() {
    }

    public SwitchStmt(Expression selector, List<SwitchEntryStmt> entries) {
        this.selector = selector;
        this.entries = entries;
    }

    public SwitchStmt(int beginLine, int beginColumn, int endLine, int endColumn, Expression selector, List<SwitchEntryStmt> entries) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.selector = selector;
        this.entries = entries;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public List<SwitchEntryStmt> getEntries() {
        return entries;
    }

    public Expression getSelector() {
        return selector;
    }

    public void setEntries(List<SwitchEntryStmt> entries) {
        this.entries = entries;
    }

    public void setSelector(Expression selector) {
        this.selector = selector;
    }
}
