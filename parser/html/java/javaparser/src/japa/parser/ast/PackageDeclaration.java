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
 * Created on 17/10/2007
 */
package japa.parser.ast;

import japa.parser.ast.expr.AnnotationExpr;
import japa.parser.ast.expr.NameExpr;
import japa.parser.ast.visitor.GenericVisitor;
import japa.parser.ast.visitor.VoidVisitor;

import java.util.List;

/**
 * <p>
 * This class represents the package declaration. The package declaration is
 * optional for the {@link CompilationUnit}.
 * </p>
 * The PackageDeclaration is constructed following the syntax:<br>
 * <code>
 * <table>
 * <tr valign=baseline>
 *   <td align=right>PackageDeclaration</td>
 *   <td align=center>::=</td>
 *   <td align=left>
 *       ( {@link AnnotationExpr} )* "package" {@link NameExpr} ) ";"
 *   </td>
 * </tr>
 * </table> 
 * </code>
 * 
 * @author Julio Vilmar Gesser
 */
public final class PackageDeclaration extends Node {

    private List<AnnotationExpr> annotations;

    private NameExpr name;

    public PackageDeclaration() {
    }

    public PackageDeclaration(NameExpr name) {
        this.name = name;
    }

    public PackageDeclaration(List<AnnotationExpr> annotations, NameExpr name) {
        this.annotations = annotations;
        this.name = name;
    }

    public PackageDeclaration(int beginLine, int beginColumn, int endLine, int endColumn, List<AnnotationExpr> annotations, NameExpr name) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.annotations = annotations;
        this.name = name;
    }

    @Override
    public <R, A> R accept(GenericVisitor<R, A> v, A arg) {
        return v.visit(this, arg);
    }

    @Override
    public <A> void accept(VoidVisitor<A> v, A arg) {
        v.visit(this, arg);
    }

    /**
     * Retrieves the list of annotations declared before the package
     * declaration. Return <code>null</code> if there are no annotations.
     * 
     * @return list of annotations or <code>null</code>
     */
    public List<AnnotationExpr> getAnnotations() {
        return annotations;
    }

    /**
     * Return the name of the package.
     * 
     * @return the name of the package
     */
    public NameExpr getName() {
        return name;
    }

    /**
     * @param annotations
     *            the annotations to set
     */
    public void setAnnotations(List<AnnotationExpr> annotations) {
        this.annotations = annotations;
    }

    /**
     * Sets the name of this package declaration.
     * 
     * @param name
     *            the name to set
     */
    public void setName(NameExpr name) {
        this.name = name;
    }

}
