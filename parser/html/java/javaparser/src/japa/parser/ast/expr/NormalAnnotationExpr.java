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
 * Created on 21/11/2006
 */
package japa.parser.ast.expr;

import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public final class NormalAnnotationExpr extends AnnotationExpr {

    private NameExpr name;

    private List<MemberValuePair> pairs;

    public NormalAnnotationExpr() {
    }

    public NormalAnnotationExpr(NameExpr name, List<MemberValuePair> pairs) {
        this.name = name;
        this.pairs = pairs;
    }

    public NormalAnnotationExpr(int beginLine, int beginColumn, int endLine, int endColumn, NameExpr name, List<MemberValuePair> pairs) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.name = name;
        this.pairs = pairs;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public NameExpr getName() {
        return name;
    }

    public List<MemberValuePair> getPairs() {
        return pairs;
    }

    public void setName(NameExpr name) {
        this.name = name;
    }

    public void setPairs(List<MemberValuePair> pairs) {
        this.pairs = pairs;
    }

}
