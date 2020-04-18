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

import japa.parser.ast.Node;
import japa.parser.ast.expr.AnnotationExpr;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 */
public abstract class BodyDeclaration extends Node {

    private JavadocComment javaDoc;

    private List<AnnotationExpr> annotations;

    public BodyDeclaration() {
    }

    public BodyDeclaration(List<AnnotationExpr> annotations, JavadocComment javaDoc) {
        this.javaDoc = javaDoc;
        this.annotations = annotations;
    }

    public BodyDeclaration(int beginLine, int beginColumn, int endLine, int endColumn, List<AnnotationExpr> annotations, JavadocComment javaDoc) {
        super(beginLine, beginColumn, endLine, endColumn);
        this.javaDoc = javaDoc;
        this.annotations = annotations;
    }

    public final JavadocComment getJavaDoc() {
        return javaDoc;
    }

    public final List<AnnotationExpr> getAnnotations() {
        return annotations;
    }

    public final void setJavaDoc(JavadocComment javaDoc) {
        this.javaDoc = javaDoc;
    }

    public final void setAnnotations(List<AnnotationExpr> annotations) {
        this.annotations = annotations;
    }

}
