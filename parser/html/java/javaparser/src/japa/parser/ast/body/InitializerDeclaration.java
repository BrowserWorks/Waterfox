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
 * Created on 07/11/2006
 */
package japa.parser.ast.body;

import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

/**
 * @author Julio Vilmar Gesser
 */
public final class InitializerDeclaration extends BodyDeclaration {

    private boolean isStatic;

    private BlockStmt block;

    public InitializerDeclaration() {
    }

    public InitializerDeclaration(boolean isStatic, BlockStmt block) {
        this.isStatic = isStatic;
        this.block = block;
    }

    public InitializerDeclaration(JavadocComment javaDoc, boolean isStatic, BlockStmt block) {
        super(null, javaDoc);
        this.isStatic = isStatic;
        this.block = block;
    }

    public InitializerDeclaration(int beginLine, int beginColumn, int endLine, int endColumn, JavadocComment javaDoc, boolean isStatic, BlockStmt block) {
        super(beginLine, beginColumn, endLine, endColumn, null, javaDoc);
        this.isStatic = isStatic;
        this.block = block;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    public BlockStmt getBlock() {
        return block;
    }

    public boolean isStatic() {
        return isStatic;
    }

    public void setBlock(BlockStmt block) {
        this.block = block;
    }

    public void setStatic(boolean isStatic) {
        this.isStatic = isStatic;
    }
}
